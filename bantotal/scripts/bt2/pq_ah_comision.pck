create or replace package PQ_AH_COMISION is

  -- Author  : YLOZADA
  -- Created : 11/05/2015 01:06:29 p.m.
  -- Purpose : 
  Procedure sp_ah_cal_comision(P_N_PGCOD  IN NUMBER,
                               P_N_ITSUC  IN NUMBER,
                               P_N_ITMOD  IN NUMBER, 
                               P_N_ITTRAN IN NUMBER,
                               P_N_ITNREL IN NUMBER,
                               P_N_ITORD  IN NUMBER,
                               P_N_ITSBO  IN NUMBER,                               
                               p_n_moncom out NUMBER,
                               p_n_nummov out NUMBER                                                              
                               );
  Function fn_ah_mov_canal(P_N_TIPTRX IN NUMBER,
                           P_N_CODCAN IN NUMBER,
                           P_N_CODCOM IN NUMBER,
                           P_N_PGCOD  IN NUMBER,
                           P_N_CTNRO  IN NUMBER,
                           P_N_ITOPER IN NUMBER,
                           P_N_ITSUBO IN NUMBER, 
                           P_N_SUCDES IN NUMBER,
                           P_N_ITTOPE IN NUMBER,
                           P_N_MODULO IN NUMBER,
                           P_N_MONEDA IN NUMBER,
                           P_N_PAPEL  IN NUMBER
                           ) return number;  
  Function fn_ah_mov_dia(P_N_CODCAN IN NUMBER,
                         P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER
                         ) return number;
  Function fn_ah_mov_dia2(P_N_CODCAN IN NUMBER,
                         P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER
                         ) return number;  
  Function fn_ah_mov_dia3(P_N_CODCAN IN NUMBER,
                         P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER
                         ) return number;                                                   
  Function fn_ah_mov_his(P_N_CODCAN IN NUMBER,
                         P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER,
                         P_D_FECINI IN DATE,
                         P_D_FECFIN IN DATE
                         ) return number;  
  Function fn_ah_mov_his2(P_N_CODCAN IN NUMBER,
                         P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER,
                         P_D_FECINI IN DATE,
                         P_D_FECFIN IN DATE
                         ) return number;   
  Function fn_ah_mov_his3(P_N_CODCAN IN NUMBER,
                         P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER,
                         P_D_FECINI IN DATE,
                         P_D_FECFIN IN DATE
                         ) return number;                                                  
  Function fn_ah_mov_off(P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER,
                         P_D_FECPRO IN DATE
                         ) return number;
  Function fn_ah_ind_data return varchar2;                                                                         
  Function fn_ah_monto_comision(P_N_MODCOM IN NUMBER,
                                P_N_CODCOM IN NUMBER,
                                P_N_MONMOV IN NUMBER
                               ) return number;  
  Procedure sp_ah_calcula_comision(P_N_PGCOD  IN NUMBER,
                                   P_N_CTNRO  IN NUMBER,
                                   P_N_ITOPER IN NUMBER,
                                   P_N_ITSUBO IN NUMBER,
                                   P_N_SUCDES IN NUMBER,
                                   P_N_ITTOPE IN NUMBER,
                                   P_N_MODULO IN NUMBER,
                                   P_N_MONEDA IN NUMBER,
                                   P_N_PAPEL  IN NUMBER,
                                   P_N_ITMOD  IN NUMBER,
                                   P_N_ITTRAN IN NUMBER,
                                   P_N_MONTO  IN NUMBER,
                                   p_n_moncom out number,
                                   p_n_nummov out number
                                  );      
  Function fn_ah_valida_ordinal(P_N_CODMOD IN NUMBER,
                                P_N_CODTRX IN NUMBER,
                                P_N_CODORD IN NUMBER
                               ) return varchar2;                                                           
  Procedure sp_ah_rep_cobro_com(P_D_FECINI IN DATE,
                                P_D_FECFIN IN DATE
                                );                               
  
  Procedure sp_ah_exonera_inactiva(P_N_PGCOD  IN NUMBER,
                                   P_N_CTNRO  IN NUMBER,
                                   P_N_ITOPER IN NUMBER,
                                   P_N_ITSUBO IN NUMBER,
                                   P_N_SUCDES IN NUMBER,
                                   P_N_ITTOPE IN NUMBER,
                                   P_N_MODULO IN NUMBER,
                                   P_N_MONEDA IN NUMBER,
                                   P_N_PAPEL  IN NUMBER,
                                   P_D_FECPRO IN DATE,
                                   P_C_CODUSU IN VARCHAR2
                                  );
  Procedure sp_ah_act_exoneracion(P_N_CODCOM IN NUMBER,
                                  P_D_FECPRO IN DATE,
                                  P_C_CODUSU IN VARCHAR2           
                                  );                                  
  Procedure sp_ah_exonera_com_mtc(P_N_PGCOD  IN NUMBER,
                                  P_N_CTNRO  IN NUMBER,
                                  P_N_ITOPER IN NUMBER,
                                  P_N_ITSUBO IN NUMBER,
                                  P_N_SUCDES IN NUMBER,
                                  P_N_ITTOPE IN NUMBER,
                                  P_N_MODULO IN NUMBER,
                                  P_N_MONEDA IN NUMBER,
                                  P_N_PAPEL  IN NUMBER,
                                  P_C_ESTADO IN VARCHAR2
                                  );      
                                                              
  Procedure sp_ah_monto_rubro(P_N_PGCOD  IN NUMBER,
                              P_N_CTNRO  IN NUMBER,
                              P_N_ITOPER IN NUMBER,
                              P_N_ITSUBO IN NUMBER,
                              P_N_SUCDES IN NUMBER,
                              P_N_MONEDA IN NUMBER,
                              P_N_PAPEL  IN NUMBER,
                              p_n_monto  out number
                             ); 
                                                              
  Procedure sp_ah_monto_asiento(P_D_FECPRO IN DATE,
                                P_N_PGCOD  IN NUMBER,
                                P_N_ITSUC  IN NUMBER,           
                                P_N_ITMOD  IN NUMBER,
                                P_N_ITTRAN IN NUMBER,                                
                                P_N_ITNREL IN NUMBER,
                                P_N_ITORD  IN NUMBER,  
                                P_N_ITSBO  IN NUMBER
                                );
                               
  Function fn_ah_monto_opemes(P_N_CODCOM IN NUMBER,
                              P_N_PGCOD  IN NUMBER,
                              P_N_CTNRO  IN NUMBER,
                              P_N_ITOPER IN NUMBER,
                              P_N_ITSUBO IN NUMBER, 
                              P_N_SUCDES IN NUMBER,
                              P_N_ITTOPE IN NUMBER,
                              P_N_MODULO IN NUMBER,
                              P_N_MONEDA IN NUMBER,
                              P_N_PAPEL  IN NUMBER
                              ) return number;  
                                                           
  Function fn_ah_mov_dia_com(P_N_CODCOM IN NUMBER,
                             P_N_PGCOD  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_SUCDES IN NUMBER,
                             --P_N_ITTOPE IN NUMBER,
                             --P_N_MODULO IN NUMBER,
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER
                             ) return number;     
                                                     
  Function fn_ah_mov_his_com(P_N_CODCOM IN NUMBER,
                             P_N_PGCOD  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_SUCDES IN NUMBER,
                             --P_N_ITTOPE IN NUMBER,
                             --P_N_MODULO IN NUMBER,
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER,
                             P_D_FECINI IN DATE,
                             P_D_FECFIN IN DATE
                             ) return number;      
                                                    
  Function fn_ah_mov_off_com(P_N_CODCOM IN NUMBER,
                             P_N_PGCOD  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_SUCDES IN NUMBER,
                             P_N_ITTOPE IN NUMBER,
                             P_N_MODULO IN NUMBER,
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER,
                             P_D_FECPRO IN DATE
                             ) return number;    
                                                      
  Function fn_ah_fec_ult_des(P_N_PGCOD  IN NUMBER,
                             P_N_MODULO IN NUMBER,
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_ITTOPE IN NUMBER,
                             P_N_SUCDES IN NUMBER
                             ) return date;     
                                                     
  Procedure sp_ah_monto_AC(P_N_PGCOD   IN NUMBER,                                        
                           P_N_MODULO  IN NUMBER,                          
                           P_N_CTNRO   IN NUMBER,                           
                           P_N_ITOPER  IN NUMBER,                          
                           P_N_ITSUBO  IN NUMBER,                          
                           P_N_ITTOPE  IN NUMBER,                           
                           P_N_SUCDES  IN NUMBER,                          
                           P_N_MONEDA  IN NUMBER,                           
                           P_N_PAPEL   IN NUMBER,
                           P_D_FECPRO  IN DATE,
                           p_n_mtoexo out number
                           );
                          
  Function fn_ah_monto_desembolso(P_N_MODULO IN NUMBER, 
                                  P_N_ITTOPE IN NUMBER, 
                                  P_N_MONTO  IN NUMBER
                                  ) return number;
  Procedure sp_ah_graba_importe_asiento(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER,
                                        P_N_ITORD  IN NUMBER,
                                        P_N_ITSBO  IN NUMBER,
                                        P_N_MONTO  IN NUMBER
                                        );   
  Procedure sp_ah_graba_importe_comisio(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER,
                                        P_N_ITORD  IN NUMBER,
                                        P_N_ITSBO  IN NUMBER,
                                        P_N_MONTO1 IN NUMBER,
                                        P_N_MONTO2 IN NUMBER
                                        );                  
  Procedure sp_valida_edad_18_25(P_N_CODPGC IN NUMBER,
                                 P_N_NUMCTA IN NUMBER,
                                 p_c_valida out varchar2,
                                 p_d_fecfin out date             
                                );     
                                
  Procedure sp_ah_saldos_remu(P_N_PGCOD   IN NUMBER,                                        
                              P_N_MODULO  IN NUMBER,                          
                              P_N_CTNRO   IN NUMBER,                           
                              P_N_ITOPER  IN NUMBER,                          
                              P_N_ITSUBO  IN NUMBER,                          
                              P_N_ITTOPE  IN NUMBER,                           
                              P_N_SUCDES  IN NUMBER,                          
                              P_N_MONEDA  IN NUMBER,                           
                              P_N_PAPEL   IN NUMBER,
                              p_n_saldo   out number,
                              p_n_salte   out number
                             );          
/*                                                                                                                                          
  Procedure sp_ah_abm_remu(P_N_PGCOD  IN NUMBER,
                           P_N_ITSUC  IN NUMBER,
                           P_N_ITMOD  IN NUMBER, 
                           P_N_ITTRAN IN NUMBER,
                           P_N_ITNREL IN NUMBER,
                           P_N_ITORD  IN NUMBER,
                           P_N_ITSBO  IN NUMBER,
                           P_N_TIPRTE IN NUMBER,
                           p_c_cancel out varchar2
                           );                             
 Procedure sp_ah_graba_monto_itf(P_N_PGCOD  IN NUMBER,
                                 P_N_ITSUC  IN NUMBER,
                                 P_N_ITMOD  IN NUMBER,
                                 P_N_ITTRAN IN NUMBER,
                                 P_N_ITNREL IN NUMBER,
                                 P_N_ITORD  IN NUMBER,
                                 P_N_ITSBO  IN NUMBER,
                                 P_N_MONTO1 IN NUMBER
                                 );                           
  Procedure sp_ah_calcula_itf(P_N_MONTO IN NUMBER,
                              p_n_itf out number          
                              );                                 
  Procedure sp_ah_analiza_integracion(P_N_PGCOD  IN NUMBER,
                                      P_N_ITSUC  IN NUMBER,
                                      P_N_ITMOD  IN NUMBER,
                                      P_N_ITTRAN IN NUMBER,
                                      P_N_ITNREL IN NUMBER,
                                      P_N_ITORD  IN NUMBER,
                                      P_N_ITSBO  IN NUMBER,
                                      P_N_CTADEB IN NUMBER,                                      
                                      P_N_MONTO1 IN OUT NUMBER
                                      );  
                                      
  Procedure sp_ah_analiza_integ_trans(P_N_PGCOD  IN NUMBER,
                                      P_N_ITSUC  IN NUMBER,
                                      P_N_ITMOD  IN NUMBER,
                                      P_N_ITTRAN IN NUMBER,
                                      P_N_ITNREL IN NUMBER,
                                      P_N_ITORD  IN NUMBER,
                                      P_N_ITSBO  IN NUMBER,
                                      P_N_CTADEB IN NUMBER,                                      
                                      P_N_MONTO1 IN OUT NUMBER
                                      );     
*/                 

Procedure sp_ah_graba_inicio(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER
                                        );

Procedure sp_ah_graba_fin(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER,
                                        p_n_moncom IN NUMBER,
                                        p_n_nummov IN NUMBER
                                        ) ;                                                                                                                                                                                              
  Procedure sp_ah_graba_bolsa(P_D_FECPRO IN DATE,
                              P_N_PGCOD  IN NUMBER,
                              P_N_MODULO IN NUMBER,
                              P_N_SUCDES IN NUMBER,  
                              P_N_MONEDA IN NUMBER,
                              P_N_PAPEL  IN NUMBER,
                              P_N_CTNRO  IN NUMBER,
                              P_N_ITOPER IN NUMBER,
                              P_N_ITSUBO IN NUMBER,
                              P_N_ITTOPE IN NUMBER,
                              P_C_TIPTRX IN VARCHAR2, --A= AUMENTA D=DISMINUYE
                              P_N_MONMOV IN NUMBER, 
                              P_N_MONTEM IN NUMBER, 
                              P_N_PGEMP  IN NUMBER,
                              P_N_ITSUC  IN NUMBER,
                              P_N_ITMOD  IN NUMBER,
                              P_N_ITTRAN IN NUMBER,
                              P_N_ITNREL IN NUMBER,
                              P_N_ITNORD IN NUMBER
                              );             
  Procedure sp_ah_consu_bolsa(P_N_PGCOD  IN NUMBER,
                              P_N_MODULO IN NUMBER,
                              P_N_SUCDES IN NUMBER,  
                              P_N_MONEDA IN NUMBER,
                              P_N_PAPEL  IN NUMBER,
                              P_N_CTNRO  IN NUMBER,
                              P_N_ITOPER IN NUMBER,
                              P_N_ITSUBO IN NUMBER,
                              P_N_ITTOPE IN NUMBER,
                              P_D_FECPRO IN DATE,
                              p_n_mtosal out number,
                              p_c_indcre out varchar2
                              );                                                         
end PQ_AH_COMISION;
/

create or replace package body PQ_AH_COMISION is
  Procedure sp_ah_cal_comision(P_N_PGCOD  IN NUMBER,
                               P_N_ITSUC  IN NUMBER,
                               P_N_ITMOD  IN NUMBER, 
                               P_N_ITTRAN IN NUMBER,
                               P_N_ITNREL IN NUMBER,
                               P_N_ITORD  IN NUMBER,
                               P_N_ITSBO  IN NUMBER,
                               p_n_moncom out NUMBER,
                               p_n_nummov out NUMBER                                                              
                               ) IS
  ln_Pgcod   number(3);                              
  ln_ctnro   number(9);                             
  ln_Itoper  number(9);                             
  ln_Itsubo  number(3);                             
  ln_Itsucd  number(3);                             
  ln_Ittope  number(3);                             
  ln_Modulo  number(3);                             
  ln_Moneda  number(4);                             
  ln_Papel   number(4);   
    
  ln_monto     number(17,2) := 0;
  ln_moncom    number(17,2) := 0;
  ln_nummov    number;
  ln_indcob    number(17,2) := 0;
  --ld_feceje    date := trunc(sysdate);
  begin
 
 /*--registramos tiempo inicio de ejecucion*/
   /* begin
      insert into jaql490
        (jaql490pgc,
         jaql490suc,
         jaql490mod,
         jaql490trx,
         jaql490rel,
         jaql490fec,
         jaql490ini)
      values
        (P_N_PGCOD,
         P_N_ITSUC,
         P_N_ITMOD,
         P_N_ITTRAN,
         P_N_ITNREL,
         ld_feceje,
         sysdate
         );
         commit;
    Exception
    When others then
         null;
    end;*/
/*    HMEV 05.04.2018
    begin
      sp_ah_graba_inicio(P_N_PGCOD ,
                                        P_N_ITSUC ,
                                        P_N_ITMOD ,
                                        P_N_ITTRAN,
                                        P_N_ITNREL);
    exception
      when others then
        null;
    end;
*/
    /*--fin registro inicio*/

    --obtenemos los datos de la cuenta
    begin           
      select Pgcod,
             Ctnro,
             Itoper,
             Itsubo,
             Itsucd,
             Ittope,
             Modulo,
             Moneda,
             Papel,
             itimp1,
             itimp4 
       into  ln_Pgcod, 
             ln_ctnro,
             ln_Itoper,
             ln_Itsubo,
             ln_Itsucd,
             ln_Ittope,
             ln_Modulo,
             ln_Moneda,
             ln_Papel,
             ln_monto,
             ln_indcob 
       from FSD016 
      Where Pgcod   = P_N_PGCOD
        and Itsuc   = P_N_ITSUC
        and Itmod   = P_N_ITMOD
        and Ittran  = P_N_ITTRAN
        and Itnrel  = P_N_ITNREL
        and Itord   = P_N_ITORD
        and Itsbor  = P_N_ITSBO;
    Exception
    When others then
      ln_Pgcod  := 0;       
      ln_ctnro  := 0;    
      ln_Itoper := 0;    
      ln_Itsubo := 0;    
      ln_Itsucd := 0;    
      ln_Ittope := 0;    
      ln_Modulo := 0;    
      ln_Moneda := 0;    
      ln_Papel  := 0;         
    End;  
        
    -- verificamos si la trx y cuenta estan afectas a comsión
    begin
      pq_ah_comision.sp_ah_calcula_comision(p_n_pgcod  => ln_Pgcod,
                                            p_n_ctnro  => ln_ctnro,
                                            p_n_itoper => ln_Itoper,
                                            p_n_itsubo => ln_Itsubo,
                                            p_n_sucdes => ln_Itsucd,
                                            p_n_ittope => ln_Ittope,
                                            p_n_modulo => ln_Modulo,
                                            p_n_moneda => ln_Moneda,
                                            p_n_papel  => ln_Papel,
                                            p_n_itmod  => P_N_ITMOD,
                                            p_n_ittran => P_N_ITTRAN,
                                            p_n_monto  => ln_monto,
                                            p_n_moncom => ln_moncom,
                                            p_n_nummov => ln_nummov
                                            );
    end;
    
    
    --If ln_moncom > 0 and ln_indafe = 1 then   
       --actualizamos comision en ordinal
       if ln_indcob > 0 then
           ln_nummov := ln_indcob;          
       End If;
         
/*       Begin                              
        Update FSD016
           set Itimp12 = ln_moncom,
               Itimp4  = ln_nummov
         Where Pgcod  = P_N_PGCOD
           and Itsuc  = P_N_ITSUC
           and Itmod  = P_N_ITMOD
           and Ittran = P_N_ITTRAN
           and Itnrel = P_N_ITNREL
           and Itord  = P_N_ITORD
           and Itsbor = P_N_ITSBO;   
           commit;    
       Exception
       When others then    
        null;
       end; */
                 
        begin
          -- Call the procedure
          pq_ah_comision.sp_ah_graba_importe_comisio(p_n_pgcod  => P_N_PGCOD,
                                                     p_n_itsuc  => P_N_ITSUC,
                                                     p_n_itmod  => P_N_ITMOD,
                                                     p_n_ittran => P_N_ITTRAN,
                                                     p_n_itnrel => P_N_ITNREL,
                                                     p_n_itord  => P_N_ITORD,
                                                     p_n_itsbo  => P_N_ITSBO,
                                                     p_n_monto1 => ln_moncom,
                                                     p_n_monto2 => ln_nummov
                                                     );
        end;                 
    --End If;  
    
     p_n_nummov := ln_nummov;
     
    /*--registramos tiempo final de ejecucion*/
/*    begin
     update jaql490 
        set jaql490fin = sysdate,
            jaql490mco = p_n_moncom,
            jaql490nmo = p_n_nummov            
      where jaql490pgc = P_N_PGCOD
        and jaql490suc = P_N_ITSUC
        and jaql490mod = P_N_ITMOD
        and jaql490trx = P_N_ITTRAN
        and jaql490rel = P_N_ITNREL
        and jaql490fec = ld_feceje;
        commit;
    Exception
    When others then
         null;
    end;*/
    /*HMEV 05.04.2018
    begin
      sp_ah_graba_fin(P_N_PGCOD,
                      P_N_ITSUC,
                      P_N_ITMOD,
                      P_N_ITTRAN,
                      P_N_ITNREL,
                      ln_moncom,
                      ln_nummov);
    exception
      when others then
        null;
    end;*/
    /*--fin registro inicio*/  
          
    p_n_moncom := ln_moncom;  
  end sp_ah_cal_comision;           
  Function fn_ah_mov_canal(P_N_TIPTRX IN NUMBER,
                           P_N_CODCAN IN NUMBER,
                           P_N_CODCOM IN NUMBER,
                           P_N_PGCOD  IN NUMBER,
                           P_N_CTNRO  IN NUMBER,
                           P_N_ITOPER IN NUMBER,
                           P_N_ITSUBO IN NUMBER, 
                           P_N_SUCDES IN NUMBER,
                           P_N_ITTOPE IN NUMBER,
                           P_N_MODULO IN NUMBER,
                           P_N_MONEDA IN NUMBER,
                           P_N_PAPEL  IN NUMBER
                           ) return number is
  ld_fecini date;
  ld_fecfin date;
  ln_totmov number(10):=0;
  ln_totdia number(10):=0;
  ln_tothis number(10):=0;
  ln_totoff number(10):=0;
  lc_indoff char(1);
  ld_fecsis date;
  begin
  
  select opgval into lc_indoff from fst200 where opgcod=544;  
  select pgfape into ld_fecsis from fst017 where pgcod=1;
  
  begin
   select max(JAQL485FEF)
     into ld_fecini
     from jaql485 
    where JAQL485PGE = P_N_PGCOD
      and JAQL485SUC = P_N_SUCDES
      and JAQL485CTA = P_N_CTNRO
      and JAQL485MOD = P_N_MODULO
      and JAQL485MDA = P_N_MONEDA
      and JAQL485PAP = P_N_PAPEL
      and JAQL485OPE = P_N_ITOPER
      and JAQL485SBO = case
                         when P_N_MODULO = 22 then
                           JAQL485SBO
                         else
                           P_N_ITSUBO
                       end 
      and JAQL485TOP = P_N_ITTOPE
      and JAQL485TCO = P_N_CODCOM
      and to_char(JAQL485FEF,'MMRRRR') = to_char(ld_fecsis,'MMRRRR')--21.11.2019--YLOZADA
      and JAQL485AX2 = case
                        when P_N_CODCAN = 2 then
                             3
                        when P_N_CODCAN = 3 then
                             2                        
                        Else
                             P_N_CODCAN
                        end;       
      /*
      and JAQL485SBO = P_N_ITSUBO
      and JAQL485TOP = P_N_ITTOPE
      and JAQL485TCO = P_N_CODCOM
      and to_char(JAQL485FEF,'MMRRRR') = to_char(ld_fecsis,'MMRRRR')--21.11.2019--YLOZADA
      and case
          when P_N_CODCAN = 1 then
               JAQL485CNV
          when P_N_CODCAN = 2 then
               JAQL485CNA
          when P_N_CODCAN = 3 then    
               JAQL485CNC
          Else
               0
          end = 1; 
          */
  Exception
  When others then
    ld_fecini := ld_fecsis;               
  end;  
  
  
  if P_N_TIPTRX = 1 then --exceso de depositos
     If ld_fecsis = trunc(sysdate) Then
               
        If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then        
            ln_totdia := pq_ah_comision.fn_ah_mov_dia2(p_n_codcan => P_N_CODCAN,
                                                       p_n_pgcod  => P_N_PGCOD,
                                                       p_n_ctnro  => P_N_CTNRO,
                                                       p_n_itoper => P_N_ITOPER,
                                                       p_n_itsubo => P_N_ITSUBO,
                                                       p_n_sucdes => P_N_SUCDES,
                                                       p_n_ittope => P_N_ITTOPE,
                                                       p_n_modulo => P_N_MODULO,
                                                       p_n_moneda => P_N_MONEDA,
                                                       p_n_papel  => P_N_PAPEL
                                                       );   
        Else
            --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
            if ld_fecini = ld_fecsis then
               ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
            Else  
               ld_fecini := ld_fecini + 1;
            End If;
            ld_fecfin := ld_fecsis - 1;                                                                 
            ln_totdia := pq_ah_comision.fn_ah_mov_dia2(p_n_codcan => P_N_CODCAN,
                                                       p_n_pgcod  => P_N_PGCOD,
                                                       p_n_ctnro  => P_N_CTNRO,
                                                       p_n_itoper => P_N_ITOPER,
                                                       p_n_itsubo => P_N_ITSUBO,
                                                       p_n_sucdes => P_N_SUCDES,
                                                       p_n_ittope => P_N_ITTOPE,
                                                       p_n_modulo => P_N_MODULO,
                                                       p_n_moneda => P_N_MONEDA,
                                                       p_n_papel  => P_N_PAPEL
                                                       );   
                 
            ln_tothis := pq_ah_comision.fn_ah_mov_his2(p_n_codcan => P_N_CODCAN,
                                                       p_n_pgcod  => P_N_PGCOD,
                                                       p_n_ctnro  => P_N_CTNRO,
                                                       p_n_itoper => P_N_ITOPER,
                                                       p_n_itsubo => P_N_ITSUBO,
                                                       p_n_sucdes => P_N_SUCDES,
                                                       p_n_ittope => P_N_ITTOPE,
                                                       p_n_modulo => P_N_MODULO,
                                                       p_n_moneda => P_N_MONEDA,
                                                       p_n_papel  => P_N_PAPEL,
                                                       p_d_fecini => ld_fecini,
                                                       p_d_fecfin => ld_fecfin
                                                       );   
       End If;                                                          
     Else
       If pq_ah_comision.fn_ah_ind_data = 'N' then --NO hay data en el diario
          --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
          if ld_fecini = ld_fecsis then
             ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
          Else  
             ld_fecini := ld_fecini + 1;
          End If;          
          ld_fecfin := ld_fecsis;                                       
          ln_tothis := pq_ah_comision.fn_ah_mov_his2(p_n_codcan => P_N_CODCAN,
                                                     p_n_pgcod  => P_N_PGCOD,
                                                     p_n_ctnro  => P_N_CTNRO,
                                                     p_n_itoper => P_N_ITOPER,
                                                     p_n_itsubo => P_N_ITSUBO,
                                                     p_n_sucdes => P_N_SUCDES,
                                                     p_n_ittope => P_N_ITTOPE,
                                                     p_n_modulo => P_N_MODULO,
                                                     p_n_moneda => P_N_MONEDA,
                                                     p_n_papel  => P_N_PAPEL,
                                                     p_d_fecini => ld_fecini,
                                                     p_d_fecfin => ld_fecfin
                                                     );                      
       Else
          If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then            
              ln_totdia := pq_ah_comision.fn_ah_mov_dia2(p_n_codcan => P_N_CODCAN,
                                                         p_n_pgcod  => P_N_PGCOD,
                                                         p_n_ctnro  => P_N_CTNRO,
                                                         p_n_itoper => P_N_ITOPER,
                                                         p_n_itsubo => P_N_ITSUBO,
                                                         p_n_sucdes => P_N_SUCDES,
                                                         p_n_ittope => P_N_ITTOPE,
                                                         p_n_modulo => P_N_MODULO,
                                                         p_n_moneda => P_N_MONEDA,
                                                         p_n_papel  => P_N_PAPEL
                                                         );    
                                                    
          Else
              --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
              if ld_fecini = ld_fecsis then
                 ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
              Else  
                 ld_fecini := ld_fecini + 1;
              End If;              
              ld_fecfin := ld_fecsis - 1;      
              ln_totdia := pq_ah_comision.fn_ah_mov_dia2(p_n_codcan => P_N_CODCAN,
                                                         p_n_pgcod  => P_N_PGCOD,
                                                         p_n_ctnro  => P_N_CTNRO,
                                                         p_n_itoper => P_N_ITOPER,
                                                         p_n_itsubo => P_N_ITSUBO,
                                                         p_n_sucdes => P_N_SUCDES,
                                                         p_n_ittope => P_N_ITTOPE,
                                                         p_n_modulo => P_N_MODULO,
                                                         p_n_moneda => P_N_MONEDA,
                                                         p_n_papel  => P_N_PAPEL
                                                         ); 
              ln_tothis := pq_ah_comision.fn_ah_mov_his2(p_n_codcan => P_N_CODCAN,
                                                         p_n_pgcod  => P_N_PGCOD,
                                                         p_n_ctnro  => P_N_CTNRO,
                                                         p_n_itoper => P_N_ITOPER,
                                                         p_n_itsubo => P_N_ITSUBO,
                                                         p_n_sucdes => P_N_SUCDES,
                                                         p_n_ittope => P_N_ITTOPE,
                                                         p_n_modulo => P_N_MODULO,
                                                         p_n_moneda => P_N_MONEDA,
                                                         p_n_papel  => P_N_PAPEL,
                                                         p_d_fecini => ld_fecini,
                                                         p_d_fecfin => ld_fecfin
                                                         );   
          End If;                                                               
       End If;
    End If;       
  End If;    
  
  if P_N_TIPTRX = 2 then  --exceso de retiros
      if lc_indoff = 'S' Then --online
         If ld_fecsis = trunc(sysdate) Then
                   
            If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then        
                ln_totdia := pq_ah_comision.fn_ah_mov_dia(p_n_codcan => P_N_CODCAN,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          p_n_ittope => P_N_ITTOPE,
                                                          p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL
                                                          );   
            Else
                --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
                if ld_fecini = ld_fecsis then
                   ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
                Else  
                   ld_fecini := ld_fecini + 1;
                End If;                
                ld_fecfin := ld_fecsis - 1;                                                                 
                ln_totdia := pq_ah_comision.fn_ah_mov_dia(p_n_codcan => P_N_CODCAN,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          p_n_ittope => P_N_ITTOPE,
                                                          p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL
                                                          );   
                     
                ln_tothis := pq_ah_comision.fn_ah_mov_his(p_n_codcan => P_N_CODCAN,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          p_n_ittope => P_N_ITTOPE,
                                                          p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL,
                                                          p_d_fecini => ld_fecini,
                                                          p_d_fecfin => ld_fecfin
                                                          );   
           End If;                                                          
         Else
           If pq_ah_comision.fn_ah_ind_data = 'N' then --NO hay data en el diario
              --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
              if ld_fecini = ld_fecsis then
                 ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
              Else  
                 ld_fecini := ld_fecini + 1;
              End If;              
              ld_fecfin := ld_fecsis;                                       
              ln_tothis := pq_ah_comision.fn_ah_mov_his(p_n_codcan => P_N_CODCAN,
                                                        p_n_pgcod  => P_N_PGCOD,
                                                        p_n_ctnro  => P_N_CTNRO,
                                                        p_n_itoper => P_N_ITOPER,
                                                        p_n_itsubo => P_N_ITSUBO,
                                                        p_n_sucdes => P_N_SUCDES,
                                                        p_n_ittope => P_N_ITTOPE,
                                                        p_n_modulo => P_N_MODULO,
                                                        p_n_moneda => P_N_MONEDA,
                                                        p_n_papel  => P_N_PAPEL,
                                                        p_d_fecini => ld_fecini,
                                                        p_d_fecfin => ld_fecfin
                                                        );                      
           Else
              If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then            
                  ln_totdia := pq_ah_comision.fn_ah_mov_dia(p_n_codcan => P_N_CODCAN,
                                                            p_n_pgcod  => P_N_PGCOD,
                                                            p_n_ctnro  => P_N_CTNRO,
                                                            p_n_itoper => P_N_ITOPER,
                                                            p_n_itsubo => P_N_ITSUBO,
                                                            p_n_sucdes => P_N_SUCDES,
                                                            p_n_ittope => P_N_ITTOPE,
                                                            p_n_modulo => P_N_MODULO,
                                                            p_n_moneda => P_N_MONEDA,
                                                            p_n_papel  => P_N_PAPEL
                                                            );    
                                                        
              Else
                  --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
                  if ld_fecini = ld_fecsis then
                     ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
                  Else  
                     ld_fecini := ld_fecini + 1;
                  End If;                  
                  ld_fecfin := ld_fecsis - 1;      
                  ln_totdia := pq_ah_comision.fn_ah_mov_dia(p_n_codcan => P_N_CODCAN,
                                                            p_n_pgcod  => P_N_PGCOD,
                                                            p_n_ctnro  => P_N_CTNRO,
                                                            p_n_itoper => P_N_ITOPER,
                                                            p_n_itsubo => P_N_ITSUBO,
                                                            p_n_sucdes => P_N_SUCDES,
                                                            p_n_ittope => P_N_ITTOPE,
                                                            p_n_modulo => P_N_MODULO,
                                                            p_n_moneda => P_N_MONEDA,
                                                            p_n_papel  => P_N_PAPEL
                                                            ); 
                  ln_tothis := pq_ah_comision.fn_ah_mov_his(p_n_codcan => P_N_CODCAN,
                                                            p_n_pgcod  => P_N_PGCOD,
                                                            p_n_ctnro  => P_N_CTNRO,
                                                            p_n_itoper => P_N_ITOPER,
                                                            p_n_itsubo => P_N_ITSUBO,
                                                            p_n_sucdes => P_N_SUCDES,
                                                            p_n_ittope => P_N_ITTOPE,
                                                            p_n_modulo => P_N_MODULO,
                                                            p_n_moneda => P_N_MONEDA,
                                                            p_n_papel  => P_N_PAPEL,
                                                            p_d_fecini => ld_fecini,
                                                            p_d_fecfin => ld_fecfin
                                                            );   
              End If;                                                               
           End If;
        End If;            
      Else
         If pq_ah_comision.fn_ah_ind_data = 'S' Then --SI HAY DATA EN EL DIARIO
            If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then   
                ln_totdia := pq_ah_comision.fn_ah_mov_dia(p_n_codcan => P_N_CODCAN,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          p_n_ittope => P_N_ITTOPE,
                                                          p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL
                                                          );    
            Else 
                --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
                if ld_fecini = ld_fecsis then
                   ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
                Else  
                   ld_fecini := ld_fecini + 1;
                End If;                
                ld_fecfin := ld_fecsis - 1;       
                ln_totdia := pq_ah_comision.fn_ah_mov_dia(p_n_codcan => P_N_CODCAN,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          p_n_ittope => P_N_ITTOPE,
                                                          p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL
                                                          );                 
                ln_tothis := pq_ah_comision.fn_ah_mov_his(p_n_codcan => P_N_CODCAN,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          p_n_ittope => P_N_ITTOPE,
                                                          p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL,
                                                          p_d_fecini => ld_fecini,
                                                          p_d_fecfin => ld_fecfin
                                                          );    
                                                
                ln_totoff := pq_ah_comision.fn_ah_mov_off(p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          p_n_ittope => P_N_ITTOPE,
                                                          p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL,
                                                          p_d_fecpro => trunc(sysdate)
                                                          );
            End If;                                                                                                         
         Else
            --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
            if ld_fecini = ld_fecsis then
               ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
            Else  
               ld_fecini := ld_fecini + 1;
            End If;            
            ld_fecfin := ld_fecsis;      
            ln_tothis := pq_ah_comision.fn_ah_mov_his(p_n_codcan => P_N_CODCAN,
                                                      p_n_pgcod  => P_N_PGCOD,
                                                      p_n_ctnro  => P_N_CTNRO,
                                                      p_n_itoper => P_N_ITOPER,
                                                      p_n_itsubo => P_N_ITSUBO,
                                                      p_n_sucdes => P_N_SUCDES,
                                                      p_n_ittope => P_N_ITTOPE,
                                                      p_n_modulo => P_N_MODULO,
                                                      p_n_moneda => P_N_MONEDA,
                                                      p_n_papel  => P_N_PAPEL,
                                                      p_d_fecini => ld_fecini,
                                                      p_d_fecfin => ld_fecfin
                                                      );    
                                                
            ln_totoff := pq_ah_comision.fn_ah_mov_off(p_n_pgcod  => P_N_PGCOD,
                                                      p_n_ctnro  => P_N_CTNRO,
                                                      p_n_itoper => P_N_ITOPER,
                                                      p_n_itsubo => P_N_ITSUBO,
                                                      p_n_sucdes => P_N_SUCDES,
                                                      p_n_ittope => P_N_ITTOPE,
                                                      p_n_modulo => P_N_MODULO,
                                                      p_n_moneda => P_N_MONEDA,
                                                      p_n_papel  => P_N_PAPEL,
                                                      p_d_fecpro => trunc(sysdate)
                                                      );              
         End If;   
      End If;   
  End If;      
  
  if P_N_TIPTRX = 3 then --exceso de operaciones por OP
     If ld_fecsis = trunc(sysdate) Then
               
        If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then        
            ln_totdia := pq_ah_comision.fn_ah_mov_dia3(p_n_codcan => P_N_CODCAN,
                                                       p_n_pgcod  => P_N_PGCOD,
                                                       p_n_ctnro  => P_N_CTNRO,
                                                       p_n_itoper => P_N_ITOPER,
                                                       p_n_itsubo => P_N_ITSUBO,
                                                       p_n_sucdes => P_N_SUCDES,
                                                       p_n_ittope => P_N_ITTOPE,
                                                       p_n_modulo => P_N_MODULO,
                                                       p_n_moneda => P_N_MONEDA,
                                                       p_n_papel  => P_N_PAPEL
                                                       );   
        Else
            --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
            if ld_fecini = ld_fecsis then
               ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
            Else  
               ld_fecini := ld_fecini + 1;
            End If;            
            ld_fecfin := ld_fecsis - 1;                                                                 
            ln_totdia := pq_ah_comision.fn_ah_mov_dia3(p_n_codcan => P_N_CODCAN,
                                                       p_n_pgcod  => P_N_PGCOD,
                                                       p_n_ctnro  => P_N_CTNRO,
                                                       p_n_itoper => P_N_ITOPER,
                                                       p_n_itsubo => P_N_ITSUBO,
                                                       p_n_sucdes => P_N_SUCDES,
                                                       p_n_ittope => P_N_ITTOPE,
                                                       p_n_modulo => P_N_MODULO,
                                                       p_n_moneda => P_N_MONEDA,
                                                       p_n_papel  => P_N_PAPEL
                                                       );   
                 
            ln_tothis := pq_ah_comision.fn_ah_mov_his3(p_n_codcan => P_N_CODCAN,
                                                       p_n_pgcod  => P_N_PGCOD,
                                                       p_n_ctnro  => P_N_CTNRO,
                                                       p_n_itoper => P_N_ITOPER,
                                                       p_n_itsubo => P_N_ITSUBO,
                                                       p_n_sucdes => P_N_SUCDES,
                                                       p_n_ittope => P_N_ITTOPE,
                                                       p_n_modulo => P_N_MODULO,
                                                       p_n_moneda => P_N_MONEDA,
                                                       p_n_papel  => P_N_PAPEL,
                                                       p_d_fecini => ld_fecini,
                                                       p_d_fecfin => ld_fecfin
                                                       );   
       End If;                                                          
     Else
       If pq_ah_comision.fn_ah_ind_data = 'N' then --NO hay data en el diario
          --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
          if ld_fecini = ld_fecsis then
             ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
          Else  
             ld_fecini := ld_fecini + 1;
          End If;          
          ld_fecfin := ld_fecsis;                                       
          ln_tothis := pq_ah_comision.fn_ah_mov_his3(p_n_codcan => P_N_CODCAN,
                                                     p_n_pgcod  => P_N_PGCOD,
                                                     p_n_ctnro  => P_N_CTNRO,
                                                     p_n_itoper => P_N_ITOPER,
                                                     p_n_itsubo => P_N_ITSUBO,
                                                     p_n_sucdes => P_N_SUCDES,
                                                     p_n_ittope => P_N_ITTOPE,
                                                     p_n_modulo => P_N_MODULO,
                                                     p_n_moneda => P_N_MONEDA,
                                                     p_n_papel  => P_N_PAPEL,
                                                     p_d_fecini => ld_fecini,
                                                     p_d_fecfin => ld_fecfin
                                                     );                      
       Else
          If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then            
              ln_totdia := pq_ah_comision.fn_ah_mov_dia3(p_n_codcan => P_N_CODCAN,
                                                         p_n_pgcod  => P_N_PGCOD,
                                                         p_n_ctnro  => P_N_CTNRO,
                                                         p_n_itoper => P_N_ITOPER,
                                                         p_n_itsubo => P_N_ITSUBO,
                                                         p_n_sucdes => P_N_SUCDES,
                                                         p_n_ittope => P_N_ITTOPE,
                                                         p_n_modulo => P_N_MODULO,
                                                         p_n_moneda => P_N_MONEDA,
                                                         p_n_papel  => P_N_PAPEL
                                                         );    
                                                    
          Else
              --ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
              if ld_fecini = ld_fecsis then
                 ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
              Else  
                 ld_fecini := ld_fecini + 1;
              End If;              
              ld_fecfin := ld_fecsis - 1;      
              ln_totdia := pq_ah_comision.fn_ah_mov_dia3(p_n_codcan => P_N_CODCAN,
                                                         p_n_pgcod  => P_N_PGCOD,
                                                         p_n_ctnro  => P_N_CTNRO,
                                                         p_n_itoper => P_N_ITOPER,
                                                         p_n_itsubo => P_N_ITSUBO,
                                                         p_n_sucdes => P_N_SUCDES,
                                                         p_n_ittope => P_N_ITTOPE,
                                                         p_n_modulo => P_N_MODULO,
                                                         p_n_moneda => P_N_MONEDA,
                                                         p_n_papel  => P_N_PAPEL
                                                         ); 
              ln_tothis := pq_ah_comision.fn_ah_mov_his3(p_n_codcan => P_N_CODCAN,
                                                         p_n_pgcod  => P_N_PGCOD,
                                                         p_n_ctnro  => P_N_CTNRO,
                                                         p_n_itoper => P_N_ITOPER,
                                                         p_n_itsubo => P_N_ITSUBO,
                                                         p_n_sucdes => P_N_SUCDES,
                                                         p_n_ittope => P_N_ITTOPE,
                                                         p_n_modulo => P_N_MODULO,
                                                         p_n_moneda => P_N_MONEDA,
                                                         p_n_papel  => P_N_PAPEL,
                                                         p_d_fecini => ld_fecini,
                                                         p_d_fecfin => ld_fecfin
                                                         );   
          End If;                                                               
       End If;
    End If;       
  End If;                                         
  ln_totmov := ln_totdia + ln_tothis + ln_totoff;    
  return ln_totmov;  
  end fn_ah_mov_canal; 
  Function fn_ah_mov_dia(P_N_CODCAN IN NUMBER,
                         P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER
                         ) return number is
  ln_totdia number(10):=0;                         
  begin
      --diario
      Begin                   
            select nvl(sum(b.tp1imp1),0) into ln_totdia
              from fsd016 f, fsd015 h, fst198 a, fst198 b
             where f.pgcod = P_N_PGCOD
               and f.ctnro = P_N_CTNRO
               and f.itoper = P_N_ITOPER
               and f.itsubo = P_N_ITSUBO
               and f.modulo = P_N_MODULO
               and f.itsucd = P_N_SUCDES
               and f.ittope = P_N_ITTOPE
               and f.moneda = P_N_MONEDA
               and f.papel = P_N_PAPEL
               and a.TP1IMP1 = P_N_CODCAN
               and h.pgcod = f.pgcod
               and f.pgcod = a.tp1cod
               and a.tp1cod = b.tp1cod
               and h.itmod = f.itmod
               and f.itmod = a.TP1NRO1
               and a.TP1NRO1 = b.tp1nro1
               and h.itsuc = f.itsuc
               and h.ittran = f.ittran
               and f.ittran = a.TP1NRO2
               and a.TP1NRO2 = b.tp1nro2
               and h.itnrel = f.itnrel
               and f.itord = b.tp1nro3
               and f.ittope = a.TP1NRO3
               and f.modulo = a.TP1CORR3
               and a.tp1cod = 1
               and a.tp1cod1 = 10825
               and a.tp1corr1 = 6 --guia de trx x tipo de oper y canla
               and b.tp1cod = 1
               and b.tp1cod1 = 10825
               and b.tp1corr1 = 7 --guia de ordinales x mod/trx
               and h.itcorr <> 99
               and h.itcont = 'S'
               and (Itimp4 > 0 or Itimp4 = -1)   
               and b.tp1imp1 in (1,-1)
               and b.tp1imp2 = 2
               ;                              
      Exception
      When others then
           ln_totdia := 0;         
      End;     
  return ln_totdia;   
  end fn_ah_mov_dia;
  
  Function fn_ah_mov_dia2(P_N_CODCAN IN NUMBER,
                          P_N_PGCOD  IN NUMBER,
                          P_N_CTNRO  IN NUMBER,
                          P_N_ITOPER IN NUMBER,
                          P_N_ITSUBO IN NUMBER,
                          P_N_SUCDES IN NUMBER,
                          P_N_ITTOPE IN NUMBER,
                          P_N_MODULO IN NUMBER,
                          P_N_MONEDA IN NUMBER,
                          P_N_PAPEL  IN NUMBER
                          ) return number is
  ln_totdia number(10):=0;                         
  begin
  
      --diario
      Begin                   
            select nvl(sum(b.tp1imp1),0) into ln_totdia
              from fsd016 f, fsd015 h, fst198 a, fst198 b
             where f.pgcod = P_N_PGCOD
               and f.ctnro = P_N_CTNRO
               and f.itoper = P_N_ITOPER
               and f.itsubo = P_N_ITSUBO
               and f.modulo = P_N_MODULO
               and f.itsucd = P_N_SUCDES
               and f.ittope = P_N_ITTOPE
               and f.moneda = P_N_MONEDA
               and f.papel = P_N_PAPEL
               and a.TP1IMP1 = P_N_CODCAN
               and h.pgcod = f.pgcod
               and f.pgcod = a.tp1cod
               and a.tp1cod = b.tp1cod
               and h.itmod = f.itmod
               and f.itmod = a.TP1NRO1
               and a.TP1NRO1 = b.tp1nro1
               and h.itsuc = f.itsuc
               and h.ittran = f.ittran
               and f.ittran = a.TP1NRO2
               and a.TP1NRO2 = b.tp1nro2
               and h.itnrel = f.itnrel
               and f.itord = b.tp1nro3
               and f.ittope = a.TP1NRO3
               and f.modulo = a.TP1CORR3
               and a.tp1cod = 1
               and a.tp1cod1 = 10825
               and a.tp1corr1 = 6 --guia de trx x tipo de oper y canla
               and b.tp1cod = 1
               and b.tp1cod1 = 10825
               and b.tp1corr1 = 7 --guia de ordinales x mod/trx
               and h.itcorr <> 99
               and h.itcont = 'S'
               --and (Itimp4 > 0 or Itimp4 = -1)   
               and b.tp1imp1 in (1,-1)
               and b.tp1imp2 = 1
               ;                              
      Exception
      When others then
           ln_totdia := 0;         
      End;     
  return ln_totdia;   
  end fn_ah_mov_dia2;  
  Function fn_ah_mov_dia3(P_N_CODCAN IN NUMBER,
                         P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER
                         ) return number is
  ln_totdia number(10):=0;                         
  begin
      --diario
      Begin                   
            select nvl(sum(b.tp1imp1),0) into ln_totdia
              from fsd016 f, fsd015 h, fst198 a, fst198 b
             where f.pgcod = P_N_PGCOD
               and f.ctnro = P_N_CTNRO
               and f.itoper = P_N_ITOPER
               and f.itsubo = P_N_ITSUBO
               and f.modulo = P_N_MODULO
               and f.itsucd = P_N_SUCDES
               and f.ittope = P_N_ITTOPE
               and f.moneda = P_N_MONEDA
               and f.papel = P_N_PAPEL
               and a.TP1IMP1 = P_N_CODCAN
               and h.pgcod = f.pgcod
               and f.pgcod = a.tp1cod
               and a.tp1cod = b.tp1cod
               and h.itmod = f.itmod
               and f.itmod = a.TP1NRO1
               and a.TP1NRO1 = b.tp1nro1
               and h.itsuc = f.itsuc
               and h.ittran = f.ittran
               and f.ittran = a.TP1NRO2
               and a.TP1NRO2 = b.tp1nro2
               and h.itnrel = f.itnrel
               and f.itord = b.tp1nro3
               --and f.ittope = a.TP1NRO3
               and a.TP1NRO3 = 98
               and f.modulo = a.TP1CORR3
               and a.tp1cod = 1
               and a.tp1cod1 = 10825
               and a.tp1corr1 = 6 --guia de trx x tipo de oper y canla
               and b.tp1cod = 1
               and b.tp1cod1 = 10825
               and b.tp1corr1 = 7 --guia de ordinales x mod/trx
               and h.itcorr <> 99
               and h.itcont = 'S'
               --and (Itimp4 > 0 or Itimp4 = -1)   
               and b.tp1imp1 in (1,-1)
               and b.tp1imp2 = 2
               ;                              
      Exception
      When others then
           ln_totdia := 0;         
      End;     
  return ln_totdia;   
  end fn_ah_mov_dia3;  
  Function fn_ah_mov_his(P_N_CODCAN IN NUMBER,
                         P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER,
                         P_D_FECINI IN DATE,
                         P_D_FECFIN IN DATE
                         ) return number is
  ln_tothis number(10):=0;                        
  begin
     --historico
      Begin                       
            select nvl(sum(b.tp1imp1),0) into ln_tothis
              from fsh016 f,
                   fsh015 h,
                   fst198 a,
                   fst198 b
             where f.pgcod    = P_N_PGCOD
               and f.hcta     = P_N_CTNRO
               and f.hoper    = P_N_ITOPER
               and f.hsubop   = P_N_ITSUBO
               and f.hmodul   = P_N_MODULO
               and f.hsucur   = P_N_SUCDES
               and f.htoper   = P_N_ITTOPE
               and f.hmda     = P_N_MONEDA
               and f.hpap     = P_N_PAPEL
               and a.TP1IMP1  = P_N_CODCAN      
               and h.pgcod    = f.pgcod
               and f.pgcod    = a.tp1cod
               and a.tp1cod   = b.tp1cod               
               and h.hcmod    = f.hcmod
               and f.hcmod    = a.TP1NRO1 
               and a.TP1NRO1  = b.tp1nro1                         
               and h.hsucor   = f.hsucor
               and h.htran    = f.htran
               and f.htran    = a.TP1NRO2
               and a.TP1NRO2  = b.tp1nro2               
               and h.hnrel    = f.hnrel
               and f.hcord    = b.tp1nro3     
               and h.hfcon    = f.hfcon
               and f.htoper   = a.TP1NRO3
               and f.hmodul   = a.TP1CORR3
               and a.tp1cod   = 1 
               and a.tp1cod1  = 10825 
               and a.tp1corr1 = 6   --guia de trx x tipo de oper y canla
               and b.tp1cod   = 1 
               and b.tp1cod1  = 10825 
               and b.tp1corr1 = 7   --guia de ordinales x mod/trx                    
               and h.hccorr <> 99
               and f.hfcon between P_D_FECINI and P_D_FECFIN
               and (Hcimp4 > 0 or Hcimp4 = -1)   
               and b.tp1imp1 in (1,-1)
               and b.tp1imp2 = 2
               ;
      Exception
      When others then
           ln_tothis := 0;         
      End;    
  return ln_tothis;    
  end fn_ah_mov_his; 
  Function fn_ah_mov_his2(P_N_CODCAN IN NUMBER,
                          P_N_PGCOD  IN NUMBER,
                          P_N_CTNRO  IN NUMBER,
                          P_N_ITOPER IN NUMBER,
                          P_N_ITSUBO IN NUMBER,
                          P_N_SUCDES IN NUMBER,
                          P_N_ITTOPE IN NUMBER,
                          P_N_MODULO IN NUMBER,
                          P_N_MONEDA IN NUMBER,
                          P_N_PAPEL  IN NUMBER,
                          P_D_FECINI IN DATE,
                          P_D_FECFIN IN DATE
                          ) return number is
  ln_tothis number(10):=0;                        
  begin
     --historico
      Begin                       
            select nvl(sum(b.tp1imp1),0) into ln_tothis
              from fsh016 f,
                   fsh015 h,
                   fst198 a,
                   fst198 b
             where f.pgcod    = P_N_PGCOD
               and f.hcta     = P_N_CTNRO
               and f.hoper    = P_N_ITOPER
               and f.hsubop   = P_N_ITSUBO
               and f.hmodul   = P_N_MODULO
               and f.hsucur   = P_N_SUCDES
               and f.htoper   = P_N_ITTOPE
               and f.hmda     = P_N_MONEDA
               and f.hpap     = P_N_PAPEL
               and a.TP1IMP1  = P_N_CODCAN      
               and h.pgcod    = f.pgcod
               and f.pgcod    = a.tp1cod
               and a.tp1cod   = b.tp1cod               
               and h.hcmod    = f.hcmod
               and f.hcmod    = a.TP1NRO1 
               and a.TP1NRO1  = b.tp1nro1                         
               and h.hsucor   = f.hsucor
               and h.htran    = f.htran
               and f.htran    = a.TP1NRO2
               and a.TP1NRO2  = b.tp1nro2               
               and h.hnrel    = f.hnrel
               and f.hcord    = b.tp1nro3     
               and h.hfcon    = f.hfcon
               and f.htoper   = a.TP1NRO3
               and f.hmodul   = a.TP1CORR3
               and a.tp1cod   = 1 
               and a.tp1cod1  = 10825 
               and a.tp1corr1 = 6   --guia de trx x tipo de oper y canla
               and b.tp1cod   = 1 
               and b.tp1cod1  = 10825 
               and b.tp1corr1 = 7   --guia de ordinales x mod/trx                    
               and h.hccorr <> 99
               and f.hfcon between P_D_FECINI and P_D_FECFIN
               --and (Hcimp4 > 0 or Hcimp4 = -1)   
               and b.tp1imp1 in (1,-1)
               and b.tp1imp2 = 1
               ;
      Exception
      When others then
           ln_tothis := 0;         
      End;    
  return ln_tothis;    
  end fn_ah_mov_his2;   
  Function fn_ah_mov_his3(P_N_CODCAN IN NUMBER,
                          P_N_PGCOD  IN NUMBER,
                          P_N_CTNRO  IN NUMBER,
                          P_N_ITOPER IN NUMBER,
                          P_N_ITSUBO IN NUMBER,
                          P_N_SUCDES IN NUMBER,
                          P_N_ITTOPE IN NUMBER,
                          P_N_MODULO IN NUMBER,
                          P_N_MONEDA IN NUMBER,
                          P_N_PAPEL  IN NUMBER,
                          P_D_FECINI IN DATE,
                          P_D_FECFIN IN DATE
                          ) return number is
  ln_tothis number(10):=0;                        
  begin
     --historico
      Begin                       
            select nvl(sum(b.tp1imp1),0) into ln_tothis
              from fsh016 f,
                   fsh015 h,
                   fst198 a,
                   fst198 b
             where f.pgcod    = P_N_PGCOD
               and f.hcta     = P_N_CTNRO
               and f.hoper    = P_N_ITOPER
               and f.hsubop   = P_N_ITSUBO
               and f.hmodul   = P_N_MODULO
               and f.hsucur   = P_N_SUCDES
               and f.htoper   = P_N_ITTOPE
               and f.hmda     = P_N_MONEDA
               and f.hpap     = P_N_PAPEL
               and a.TP1IMP1  = P_N_CODCAN      
               and h.pgcod    = f.pgcod
               and f.pgcod    = a.tp1cod
               and a.tp1cod   = b.tp1cod               
               and h.hcmod    = f.hcmod
               and f.hcmod    = a.TP1NRO1 
               and a.TP1NRO1  = b.tp1nro1                         
               and h.hsucor   = f.hsucor
               and h.htran    = f.htran
               and f.htran    = a.TP1NRO2
               and a.TP1NRO2  = b.tp1nro2               
               and h.hnrel    = f.hnrel
               and f.hcord    = b.tp1nro3     
               and h.hfcon    = f.hfcon
               --and f.htoper   = a.TP1NRO3
               and a.TP1NRO3 = 98
               and f.hmodul   = a.TP1CORR3
               and a.tp1cod   = 1 
               and a.tp1cod1  = 10825 
               and a.tp1corr1 = 6   --guia de trx x tipo de oper y canla
               and b.tp1cod   = 1 
               and b.tp1cod1  = 10825 
               and b.tp1corr1 = 7   --guia de ordinales x mod/trx                    
               and h.hccorr <> 99
               and f.hfcon between P_D_FECINI and P_D_FECFIN
               --and (Hcimp4 > 0 or Hcimp4 = -1)   
               and b.tp1imp1 in (1,-1)
               and b.tp1imp2 = 2
               ;
      Exception
      When others then
           ln_tothis := 0;         
      End;    
  return ln_tothis;    
  end fn_ah_mov_his3;  
  Function fn_ah_mov_off(P_N_PGCOD  IN NUMBER,
                         P_N_CTNRO  IN NUMBER,
                         P_N_ITOPER IN NUMBER,
                         P_N_ITSUBO IN NUMBER,
                         P_N_SUCDES IN NUMBER,
                         P_N_ITTOPE IN NUMBER,
                         P_N_MODULO IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_PAPEL  IN NUMBER,
                         P_D_FECPRO IN DATE
                         ) return number is
  ln_totoff number(10):=0;                         
  begin
    begin                       
      select nvl(sum(decode(z0e4gcesm,1,1,-1)),0) 
        into ln_totoff
        from z0e4gc 
       where z0e4gcest = 'ZZ' 
         and z0e4gcesm in (1,3)
         and z0e4gctop in (1,2) 
         and z0e4gcfec = P_D_FECPRO
         and z0e4gcdpg = P_N_PGCOD
         and z0e4gcdmd = P_N_MODULO
         and z0e4gcdmo = P_N_MONEDA
         and z0e4gcdpa = P_N_PAPEL
         and z0e4gcdct = P_N_CTNRO
         and z0e4gcdop = P_N_ITOPER
         and z0e4gcdsc = P_N_ITSUBO
         and z0e4gcdto = P_N_ITTOPE
         and z0e4gcdsu = P_N_SUCDES;                                          
    Exception      
    When others then
         ln_totoff := 0;
    end;
    return ln_totoff;
  end fn_ah_mov_off;  
  Function fn_ah_ind_data return varchar2 is
  lc_inddat char(1):='N';
  begin
     begin
            select 'S' into lc_inddat from FSD016 where rownum =1;
     Exception
     when others then
          lc_inddat := 'N';
     end;
  return lc_inddat;   
  End fn_ah_ind_data;  
  Function fn_ah_monto_comision(P_N_MODCOM IN NUMBER,
                                P_N_CODCOM IN NUMBER,
                                P_N_MONMOV IN NUMBER
                               ) return number is
  ln_cotasap number(10,6);
  ln_cominp  number(17,2);
  ln_comaxp  number(17,2);
  ln_coimpp  number(17,2);  
  ln_moncom  number(17,2):= 0;                                       
  begin
             
    begin --obtenemos parametros de comision
/*      select c.cotasap,c.cominp,c.comaxp,c.coimpp 
        into ln_cotasap,ln_cominp,ln_comaxp,ln_coimpp
       from fsp026 c
       where c.pgcod = 1
         and c.comod = P_N_MODCOM
         and c.cocod = P_N_CODCOM
         and c.cocta = 0
         and c.copap = 0
         and c.comda = 0;*/
         
      Select c.cotasap,c.cominp,c.comaxp,c.coimpp  
        into ln_cotasap,ln_cominp,ln_comaxp,ln_coimpp      
        from (
            select a.*
             from fsp026 a,
                  fsr026 d
             where a.pgcod = d.pgcod
               and a.comod = d.comod
               and a.cocod = d.cocod
               and a.cocta = d.cocta
               and a.copap = d.copap
               and a.comda = d.comda
               and a.cofech = d.cofech
               and a.comto >= P_N_MONMOV
               and d.covig = 'S'
               and a.pgcod = 1
               and a.comod = P_N_MODCOM
               and a.cocod = P_N_CODCOM
               and a.cocta = 0
               and a.copap = 0
               and a.comda = 0
          order by a.comto asc
              ) c
        where rownum=1;         
    exception
    when others then    
         return ln_moncom; 
    end;
    
    If ln_coimpp = 0 then
        ln_moncom := round((P_N_MONMOV*ln_cotasap)/100,2);
        If ln_cominp >= ln_moncom Then        --valor minimo de comision
           ln_moncom := ln_cominp;
        ElsIf ln_comaxp <= ln_moncom Then     --valor maximo de comision
           ln_moncom := ln_comaxp;         
        Else
           ln_moncom := ln_moncom;
       End If;    
    Else
       ln_moncom := ln_coimpp;
    End If;  
  return ln_moncom;  
  end fn_ah_monto_comision;                                            
  Procedure sp_ah_calcula_comision(P_N_PGCOD  IN NUMBER,
                                   P_N_CTNRO  IN NUMBER,
                                   P_N_ITOPER IN NUMBER,
                                   P_N_ITSUBO IN NUMBER,
                                   P_N_SUCDES IN NUMBER,
                                   P_N_ITTOPE IN NUMBER,
                                   P_N_MODULO IN NUMBER,
                                   P_N_MONEDA IN NUMBER,
                                   P_N_PAPEL  IN NUMBER,
                                   P_N_ITMOD  IN NUMBER,
                                   P_N_ITTRAN IN NUMBER,
                                   P_N_MONTO  IN NUMBER,
                                   p_n_moncom out number,
                                   p_n_nummov out number
                                  ) is
  LN_TP1CORR3  number(9);                  
  LN_TP1NRO1   number(9); 
  LN_TP1NRO2   number(9); 
  LN_TP1NRO3   number(9);   
  LN_TP1IMP1   number(17,2); 
  LN_TP1IMP2   number(17,2); 
  LN_TP1IMP3   number(17,2);

  ln_monto     number(17,2) := 0;
  ln_totmov    number(10) := 0;           
  ln_modcom    number(3) := 462;        
  lc_indcob    char(1):= 'N';   
  ln_monrub    number(17,2) := 0;
  ln_monsal    number(17,2) := 0;      
  ln_monexo    number(17,2) := 0;     
  ln_monret    number(17,2) := 0;  
  lc_valida    varchar2(1);   
  ld_fecfin    date;
  ln_salrem    number(17,2);   
  ln_salter    number(17,2);   
  
  --ln_codseg    number(2);       
  
  --ld_fecdes    date;
  --ln_nunmes    number;    
  --ld_fecsis    date;
  
  LN_TP1NRO31   number(9);   
  ld_fecpro     date;
  ln_tipcom     number(9);  
  lc_tipo       char(1);   
   
  Begin
    
  begin select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1; exception when others then null; end;     
  
  p_n_moncom := 0;
  ln_monto   := P_N_MONTO;
  
  --OBTENEMOS EL TIPO DE TRANSACCION DE INGRESO O EGRESO 29/01/2018
    Begin
       Select TP1NRO3                
         into LN_TP1NRO31 --tipo de transacción  
         from fst198 
        where tp1cod      = 1 
          and tp1cod1     = 10825 
          and tp1corr1    = 68
          and TP1NRO1     = P_N_MODULO
          and TP1IMP1     = P_N_ITMOD
          and TP1IMP2     = P_N_ITTRAN
          and TP1NRO2     = P_N_ITTOPE;           
          lc_indcob := 'S';
    Exception
    When others then
     LN_TP1NRO31 := 0;    
    End;
  --*/ FIN 29/01/2018
         
    Begin
       Select TP1CORR3,
              TP1NRO1, 
              TP1NRO2, 
              TP1NRO3,                
              TP1IMP1, 
              TP1IMP2, 
              TP1IMP3
         into LN_TP1CORR3, 
              LN_TP1NRO1,  
              LN_TP1NRO2,  
              LN_TP1NRO3,  
              LN_TP1IMP1,  -- canal
              LN_TP1IMP2,  -- codigo comision
              LN_TP1IMP3   -- numero de operaciones x canal                    
         from fst198 
        where tp1cod      = 1 
          and tp1cod1     = 10825 
          and tp1corr1    = 6
          and TP1CORR3    = P_N_MODULO
          and TP1NRO1     = P_N_ITMOD
          and TP1NRO2     = P_N_ITTRAN
          and TP1NRO3     = P_N_ITTOPE;           
          lc_indcob := 'S';
    Exception
    When no_data_found then
         begin
           Select TP1CORR3,
                  TP1NRO1, 
                  TP1NRO2, 
                  TP1NRO3,                
                  TP1IMP1, 
                  TP1IMP2, 
                  TP1IMP3
             into LN_TP1CORR3, 
                  LN_TP1NRO1,  
                  LN_TP1NRO2,  
                  LN_TP1NRO3,  
                  LN_TP1IMP1,  -- canal
                  LN_TP1IMP2,  -- codigo comision
                  LN_TP1IMP3   -- numero de operaciones x canal                    
             from fst198 
            where tp1cod      = 1 
              and tp1cod1     = 10825 
              and tp1corr1    = 6
              and TP1CORR3    = P_N_MODULO
              and TP1NRO1     = P_N_ITMOD
              and TP1NRO2     = P_N_ITTRAN
              and TP1NRO3     = 98;    -- retito con op exceso      
              lc_indcob := 'S';           
         exception
         when others then  
           lc_indcob := 'N';    
         end;     
    When others then
     lc_indcob := 'N';
    End;
    
    -- verificamos si esta exonerado
    If lc_indcob = 'S' then
        if LN_TP1NRO31 = 1 then 
          ln_tipcom := 6;
            --verificamos si es PJ
            begin
              select y.petipo
                into lc_tipo 
                from fsr008 x,
                     fsd001 y 
               where x.pgcod  = P_N_PGCOD 
                 and x.ctnro  = P_N_CTNRO
                 and x.pepais = y.pepais
                 and x.petdoc = y.petdoc
                 and x.pendoc = y.pendoc
                 and x.ttcod  = 1
                 and x.cttfir = 'T';
                 
                 if lc_tipo = 'J' then
                    lc_indcob := 'S';
                 Else
                    lc_indcob := 'N';
                 End If;  
            exception
            when others then     
               lc_indcob := 'N';
            end;        
        End if;  
        if LN_TP1NRO31 = 2 then 
           ln_tipcom := 3;
        End if;

        if LN_TP1NRO31 = 3 then --exceso por OP
           ln_tipcom := 7;        
        End if;
      
      If lc_indcob = 'S' then     
          if P_N_MODULO = 21 then                     
              begin
               select 'N'      
                 into lc_indcob
                 from jaql485 
                where JAQL485PGE = P_N_PGCOD
                  and JAQL485SUC = P_N_SUCDES
                  and JAQL485CTA = P_N_CTNRO
                  and JAQL485MOD = P_N_MODULO
                  and JAQL485MDA = P_N_MONEDA
                  and JAQL485PAP = P_N_PAPEL
                  and JAQL485OPE = P_N_ITOPER
                  and JAQL485SBO = P_N_ITSUBO
                  and JAQL485TOP = P_N_ITTOPE
                  and JAQL485TCO = ln_tipcom
                  and JAQL485FEI <= ld_fecpro--trunc(sysdate)
                  and JAQL485FEF >= ld_fecpro--trunc(sysdate)
                  and JAQL485AX2 = case
                        when LN_TP1IMP1 = 2 then
                             3
                        when LN_TP1IMP1 = 3 then
                             2                        
                        Else
                             LN_TP1IMP1
                        end;                       
                  /*and case
                      when LN_TP1IMP1 = 1 then
                           JAQL485CNV
                      when LN_TP1IMP1 = 2 then
                           JAQL485CNA
                      when LN_TP1IMP1 = 3 then    
                           JAQL485CNC
                      Else
                           0
                      end = 1; */
              Exception
              When others then
                lc_indcob := 'S';               
              end;
          else
              begin
               select 'N'      
                 into lc_indcob
                 from jaql485 
                where JAQL485PGE = P_N_PGCOD
                  and JAQL485SUC = P_N_SUCDES
                  and JAQL485CTA = P_N_CTNRO
                  and JAQL485MOD = P_N_MODULO
                  and JAQL485MDA = P_N_MONEDA
                  and JAQL485PAP = P_N_PAPEL
                  and JAQL485OPE = P_N_ITOPER
    --              and JAQL485SBO = P_N_ITSUBO
                  and JAQL485TOP = P_N_ITTOPE
                  and JAQL485TCO = ln_tipcom
                  and JAQL485FEI <= ld_fecpro--trunc(sysdate)
                  and JAQL485FEF >= ld_fecpro--trunc(sysdate)
                  and JAQL485AX2 = case
                        when LN_TP1IMP1 = 2 then
                             3
                        when LN_TP1IMP1 = 3 then
                             2                        
                        Else
                             LN_TP1IMP1
                        end 
                  and rownum <2;                   
                  /*and case
                      when LN_TP1IMP1 = 1 then
                           JAQL485CNV
                      when LN_TP1IMP1 = 2 then
                           JAQL485CNA
                      when LN_TP1IMP1 = 3 then    
                           JAQL485CNC
                      Else
                           0
                      end = 1
                  and rownum <2;*/ 
              Exception
              When others then
                lc_indcob := 'S';               
              end;        
          end if;
      end if;
           
      
      /*--VERIFICAMOS SI LA CUENTA ES DE CLIENTE ENTRE 18 Y 25 AÑOS --*/
      if lc_indcob = 'S' and P_N_ITTOPE in(1,6) and LN_TP1NRO31 = 2 then
        begin
          -- Call the procedure
          pq_ah_comision.sp_valida_edad_18_25(p_n_codpgc => P_N_PGCOD,
                                              p_n_numcta => P_N_CTNRO,
                                              p_c_valida => lc_valida,
                                              p_d_fecfin => ld_fecfin
                                              );
        end;  
        if lc_valida = 'S' then
           --obtenemos codigo de comision a cobrar y límites a considerar
            Begin
               Select TP1CORR3,
                      TP1NRO1, 
                      TP1NRO2, 
                      TP1NRO3,                
                      TP1IMP1, 
                      TP1IMP2, 
                      TP1IMP3
                 into LN_TP1CORR3, 
                      LN_TP1NRO1,  
                      LN_TP1NRO2,  
                      LN_TP1NRO3,  
                      LN_TP1IMP1,  -- canal
                      LN_TP1IMP2,  -- codigo comision
                      LN_TP1IMP3   -- numero de operaciones x canal                    
                 from fst198 
                where tp1cod      = 1 
                  and tp1cod1     = 10825 
                  and tp1corr1    = 6
                  and TP1CORR3    = P_N_MODULO
                  and TP1NRO1     = P_N_ITMOD
                  and TP1NRO2     = P_N_ITTRAN
                  and TP1NRO3     = 99;-- condideramos tipo de operacion 99 para este caso particular y usar la misma guía           
                  lc_indcob := 'S';
            Exception
            When no_data_found then
             lc_indcob := 'N';    
            When others then
             lc_indcob := 'N';
            End;           
        end if;
      end if;
      
      /* CAMBIOS COMISIONES REMUNERACION MIXTA*/
      if lc_indcob = 'S' and P_N_ITTOPE = 6 and LN_TP1NRO31 = 2 then
          --obtenemos el monto actual de remuneraciones
          begin
            -- Call the procedure
            pq_ah_comision.sp_ah_saldos_remu(p_n_pgcod  => P_N_PGCOD,
                                             p_n_modulo => P_N_MODULO,
                                             p_n_ctnro  => P_N_CTNRO,
                                             p_n_itoper => P_N_ITOPER,
                                             p_n_itsubo => P_N_ITSUBO,
                                             p_n_ittope => P_N_ITTOPE,
                                             p_n_sucdes => P_N_SUCDES,
                                             p_n_moneda => P_N_MONEDA,
                                             p_n_papel  => P_N_PAPEL,
                                             p_n_saldo  => ln_salrem,
                                             p_n_salte  => ln_salter
                                            );
          end;   
          if ln_salrem - ln_monto < 0 then 
             lc_indcob := 'S';
          else
             lc_indcob := 'N'; 
          End If;
          ln_monsal := ln_salrem;
      End if;
      /* FIN CAMBIOS REMUNERACION MIXTA*/
      
      /*--CAMBIOS MONTO EXONERADO*/                 
      if lc_indcob = 'S' and LN_TP1NRO31 = 2 then
            
              /*                      
              begin
                -- Call the function
                ld_fecdes := pq_ah_comision.fn_ah_fec_ult_des(p_n_pgcod  => P_N_PGCOD,
                                                              p_n_modulo => P_N_MODULO,
                                                              p_n_moneda => P_N_MONEDA,
                                                              p_n_papel  => P_N_PAPEL,
                                                              p_n_ctnro  => P_N_CTNRO,
                                                              p_n_itoper => P_N_ITOPER,
                                                              p_n_itsubo => P_N_ITSUBO,
                                                              p_n_ittope => P_N_ITTOPE,
                                                              p_n_sucdes => P_N_SUCDES
                                                             );
              end; 
              
              --obtenemos cantidad de meses inactivos de desembolso
              begin
                select a.tpnro 
                  into ln_nunmes 
                  from fst098 a 
                 where a.pgcod  = 1 
                   and a.tpcod  = 7680 
                   and a.tpcorr = 15 ;
              exception
              when others then
                ln_nunmes := 0;       
              end;
              --obtenemos fecha de bantotal
              select pgfape into ld_fecsis from fst017 where pgcod=1;
              
              if ld_fecdes >= add_months(ld_fecsis,-1*ln_nunmes) then          
                 ln_monsal := pq_ah_comision.fn_ah_monto_ac(p_n_pgcod  => P_N_PGCOD, 
                                                            p_n_modulo => P_N_MODULO,
                                                            p_n_ctnro  => P_N_CTNRO, 
                                                            p_n_itoper => P_N_ITOPER,
                                                            p_n_itsubo => P_N_ITSUBO,
                                                            p_n_ittope => P_N_ITTOPE,
                                                            p_n_sucdes => P_N_SUCDES,
                                                            p_n_moneda => P_N_MONEDA,
                                                            p_n_papel  => P_N_PAPEL, 
                                                            p_d_fecpro => ld_fecsis
                                                            );
                  --funcion que retorna el monto del capital de trabajo
              else
                 ln_monsal := 0;
              end if; 
         
           */   
      
           --obtenemos el monto del rubro de exoneracion
           begin
              -- Call the procedure
              pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => P_N_PGCOD,
                                               p_n_ctnro  => P_N_CTNRO,
                                               p_n_itoper => P_N_ITOPER,
                                               p_n_itsubo => P_N_ITSUBO,
                                               p_n_sucdes => P_N_SUCDES,
                                               p_n_moneda => P_N_MONEDA,
                                               p_n_papel  => P_N_PAPEL,
                                               p_n_monto  => ln_monrub
                                               );
           end;               
           ln_monexo := ln_monsal + ln_monrub;
            --obtenemos total monto retirado SIN AFECTO A COMISION            
           /* 
           begin
              -- Call the function
           ln_monret := pq_ah_comision.fn_ah_monto_opemes(p_n_codcom => 1,--1 = exceso de operaciones 2 = interplaza
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          p_n_ittope => P_N_ITTOPE,
                                                          p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL
                                                          );
           end;   
           */         
            
           ln_monret := ln_monret + ln_monto; --total retirado incluido movimiento actual  
           
           if ln_monexo >= ln_monret then
              lc_indcob := 'N';
              p_n_nummov := 0;
           else
              lc_indcob := 'S';  
              p_n_nummov := -1;
           end if;                                                                                                                                       
      end if;  
     /*-FIN CAMBIOS -*/                 
      
      If lc_indcob = 'S' then
          --verificamos cantidad de movimientos por canal  
          ln_totmov := pq_ah_comision.fn_ah_mov_canal(p_n_tiptrx => LN_TP1NRO31,
                                                      p_n_codcan => LN_TP1IMP1,
                                                      p_n_codcom => ln_tipcom,
                                                      p_n_pgcod  => P_N_PGCOD,
                                                      p_n_ctnro  => P_N_CTNRO,
                                                      p_n_itoper => P_N_ITOPER,
                                                      p_n_itsubo => P_N_ITSUBO,
                                                      p_n_sucdes => P_N_SUCDES,
                                                      p_n_ittope => P_N_ITTOPE,
                                                      p_n_modulo => P_N_MODULO,
                                                      p_n_moneda => P_N_MONEDA,
                                                      p_n_papel  => P_N_PAPEL
                                                    );                         
 
          --Si la trx que se esta ejecutando es un reverso disminuir el numero de mov. en 1
          If P_N_ITMOD = 66 and P_N_ITTRAN = 25 Then
            ln_totmov := ln_totmov - 1;
          End If;
            
          If  ln_totmov >= LN_TP1IMP3 then
              -- calcula comisión
             If P_N_MONEDA = 101 Then
                ln_monto := round(ln_monto* fn_tipo_cambio(fecha  => ld_fecpro,--trunc(sysdate),
                                                           monori => P_N_MONEDA,
                                                           mondes => 0,
                                                           tipo   => 500
                                                           ),2);
             End If; 
             
             --verificamos si tiene tarifario especial el producto                          
             begin
                 select b.jaql481com,b.jaql481coc
                   into ln_modcom, LN_TP1IMP2
                   from jaql482 a,
                        jaql481 b
                  where a.jaql482cct = b.jaql481cct
                    and a.jaql482pge = P_N_PGCOD
                    and a.jaql482suc = P_N_SUCDES
                    and a.jaql482cta = P_N_CTNRO
                    and a.jaql482mod = P_N_MODULO
                    and a.jaql482mda = P_N_MONEDA
                    and a.jaql482pap = P_N_PAPEL
                    and a.jaql482ope = P_N_ITOPER
                    and a.jaql482sbo = P_N_ITSUBO
                    and a.jaql482top = P_N_ITTOPE
                    and a.jaql482fei <= ld_fecpro
                    and a.jaql482fef >= ld_fecpro
                    and b.jaql481fei <= ld_fecpro
                    and b.jaql481fef >= ld_fecpro
                    --and b.jaql481ax1 = LN_TP1IMP1
                    and b.jaql481ax1 = case
                                       when LN_TP1IMP1 = 2 then
                                         3
                                       when LN_TP1IMP1 = 3 then
                                         2
                                       else
                                         LN_TP1IMP1
                                       end--canal                    
                    and a.jaql482ax1 = ln_tipcom --se agrego comisiones de deposito
                    ;               
             exception
             when others then  
               null;
             end;
             
                                         
             p_n_moncom := pq_ah_comision.fn_ah_monto_comision(p_n_modcom => ln_modcom,
                                                               p_n_codcom => LN_TP1IMP2,
                                                               p_n_monmov => ln_monto
                                                               );
             If P_N_MONEDA = 101 Then
                p_n_moncom := round(p_n_moncom/ fn_tipo_cambio(fecha  => ld_fecpro,--trunc(sysdate),
                                                               monori => P_N_MONEDA,
                                                               mondes => 0,
                                                               tipo   => 500
                                                               ),2);
             End If; 
         End If;            
       End If;
     End If;
     --p_n_nummov := ln_totmov;                                                                                     
  end sp_ah_calcula_comision;   
  Function fn_ah_valida_ordinal(P_N_CODMOD IN NUMBER,
                                P_N_CODTRX IN NUMBER,
                                P_N_CODORD IN NUMBER
                               ) return varchar2 is
  lc_indica char(1):= 'N';                               
  begin
    begin        
        select 'S' 
          into lc_indica
          from fst198 b
         where b.tp1nro1  = P_N_CODMOD 
           and b.tp1nro2  = P_N_CODTRX
           and b.tp1nro3  = P_N_CODORD     
           and b.tp1cod   = 1 
           and b.tp1cod1  = 10825 
           and b.tp1corr1 = 7;
    exception
    when others then
      lc_indica := 'N';       
    end;       
  return lc_indica;  
  end fn_ah_valida_ordinal;                               
  Procedure sp_ah_rep_cobro_com(P_D_FECINI IN DATE,
                                P_D_FECFIN IN DATE           
                               ) is
  type tp_pgcod  IS TABLE OF fsh016.pgcod%type  INDEX BY BINARY_INTEGER;                             
  type tp_hsucor IS TABLE OF fsh016.hsucor%type INDEX BY BINARY_INTEGER;
  type tp_hcmod  IS TABLE OF fsh016.hcmod%type  INDEX BY BINARY_INTEGER;
  type tp_hctran IS TABLE OF fsh016.htran%type  INDEX BY BINARY_INTEGER;
  type tp_hnrel  IS TABLE OF fsh016.hnrel%type  INDEX BY BINARY_INTEGER;
  type tp_fecha  IS TABLE OF fsh016.hfcon%type  INDEX BY BINARY_INTEGER;
  type tp_canal  IS TABLE OF fsh016.hnrel%type  INDEX BY BINARY_INTEGER;  
  type tp_moncon IS TABLE OF fsh016.hcimp1%type INDEX BY BINARY_INTEGER;  
  type tp_numreg IS TABLE OF fsh016.hnrel%type  INDEX BY BINARY_INTEGER;
  
  type tp_hmodul IS TABLE OF fsh016.hmodul%type INDEX BY BINARY_INTEGER;
  type tp_htoper IS TABLE OF fsh016.htoper%type INDEX BY BINARY_INTEGER;
  type tp_hsucur IS TABLE OF fsh016.hsucur%type INDEX BY BINARY_INTEGER;
  type tp_hmda   IS TABLE OF fsh016.hmda%type   INDEX BY BINARY_INTEGER;    
  type tp_hpap   IS TABLE OF fsh016.hpap%type   INDEX BY BINARY_INTEGER;  
  type tp_hcta   IS TABLE OF fsh016.hcta%type   INDEX BY BINARY_INTEGER;
  type tp_hoper  IS TABLE OF fsh016.hoper%type  INDEX BY BINARY_INTEGER;  
  type tp_hsubop IS TABLE OF fsh016.hsubop%type INDEX BY BINARY_INTEGER;
  type tp_monto  IS TABLE OF fsd011.scsdo%type  INDEX BY BINARY_INTEGER;
  
  type tp_sucursal IS TABLE OF fst001.scnom%type  INDEX BY BINARY_INTEGER;
  type tp_region   IS TABLE OF fst810.regnom%type INDEX BY BINARY_INTEGER;
  type tp_titular  IS TABLE OF fsd008.ctnom%type  INDEX BY BINARY_INTEGER;
  
  
  ln_pgcod    tp_pgcod;
  ln_hsucor   tp_hsucor;
  ln_hcmod    tp_hcmod;
  ln_hctran   tp_hctran;
  ln_hnrel    tp_hnrel;
  ld_fecha    tp_fecha;
  ln_canal    tp_canal;  
  ln_moncon   tp_moncon;
  ln_numreg   tp_numreg; 
  
  ln_hmodul   tp_hmodul; 
  ln_htoper   tp_htoper; 
  ln_hsucur   tp_hsucur; 
  ln_hmda     tp_hmda;   
  ln_hpap     tp_hpap;   
  ln_hcta     tp_hcta;   
  ln_hoper    tp_hoper;  
  ln_hsubop   tp_hsubop; 
  
  ln_totven   tp_hcta;
  ln_totatm   tp_hcta;
  ln_totcor   tp_hcta;
  ln_tocven   tp_hcta;
  ln_tocatm   tp_hcta;
  ln_toccor   tp_hcta; 
  ln_mtosol   tp_monto; 
  ln_mtodol   tp_monto;  
  lc_sucursal tp_sucursal;
  lc_region   tp_region;
  lc_titular  tp_titular;
  
  
  cursor c_datos_a(ld_fecha in date) is
  select x.pgcod, x.hsucor, x.hcmod, x.htran, x.hnrel,ld_fecha,x.tp1imp1,
         sum(
           case 
           when x.hrubro in (5212290000037,5222290000037) then
                x.hcimp1
           else
                0
           end 
         ) moncon,  
         count(1) numreg 
    from (
          select distinct f.*,a.tp1imp1 
            from fsh016 f,
                 fsh015 h,
                 (
                 select distinct tp1cod,tp1cod1,TP1NRO1,TP1NRO2,tp1imp1 
                   from fst198 
                  where tp1cod   = 1 
                    and tp1cod1  = 10825 
                    and tp1corr1 = 6 
                 )a,
                 fst198 b
           where f.pgcod    = h.pgcod    
             and h.pgcod    = a.tp1cod
             and a.tp1cod   = b.tp1cod
             and h.hcmod    = f.hcmod
             and h.hcmod    = a.TP1NRO1             
             and a.TP1NRO1  = b.tp1nro1            
             and h.hsucor   = f.hsucor
             and h.htran    = f.htran
             and f.htran    = a.TP1NRO2
             and a.TP1NRO2  = b.TP1NRO2
             and h.hnrel    = f.hnrel            
             and h.hfcon    = f.hfcon
             and a.tp1cod1  = b.tp1cod1
             and b.tp1cod   = 1 
             and b.tp1cod1  = 10825 
             and b.tp1corr1 = 7           
             and h.hccorr   <> 99 
             --and f.hmodul   = 21
             and h.hfcon    = ld_fecha
             and (
                   (f.hcmod = b.Tp1nro1 and f.htran = b.Tp1nro2 and f.hcord = b.Tp1nro3 and f.hmodul   = 21) 
                   or 
                   f.hrubro IN (5212290000037,5222290000037)
                 )
          ) x
  group by x.pgcod, x.hsucor, x.hcmod, x.htran, x.hnrel,ld_fecha,x.tp1imp1;   
  
  cursor c_datos_b(ld_fecha in date) is 
    select f.pgcod, f.hsucor, f.hcmod, f.htran, f.hnrel, f.hfcon, f.hmodul, f.htoper, f.hsucur, f.hmda, f.hpap, f.hcta, f.hoper, f.hsubop 
      from fsh016 f,
           fsh015 h,
           fst198 b
     where f.pgcod    = h.pgcod    
       and h.pgcod    = b.tp1cod
       and h.hcmod    = f.hcmod
       and h.hcmod    = b.TP1NRO1                         
       and h.hsucor   = f.hsucor
       and h.htran    = f.htran
       and f.htran    = b.TP1NRO2
       and h.hnrel    = f.hnrel            
       and h.hfcon    = f.hfcon
       and b.tp1cod   = 1 
       and b.tp1cod1  = 10825 
       and b.tp1corr1 = 7           
       and h.hccorr   <> 99 
       and f.hmodul   = 21
       and f.hcmod    = b.Tp1nro1 
       and f.htran    = b.Tp1nro2 
       and f.hcord    = b.Tp1nro3 
       and h.hfcon    = ld_fecha;
  
  ld_fecfin date;
  ld_fecpro date;
  lc_error varchar2(400);                             
  
  cursor c_resultado is
      select /*+ parallel(f,4) parallel(a,4)*/
             f.jaql486bpgc, 
             f.jaql486bcta,
             f.jaql486bope,
             f.jaql486bsbo,
             f.jaql486bmdo, 
             f.jaql486bsca,
             f.jaql486btpo, 
             f.jaql486bmda, 
             f.jaql486bpap, 
            sum(
                 case                   
                 When a.jaql486acan = 1 then
                 1
                 Else
                 0
                 End
               ) Ventanilla_realizadas,
             sum(  
                 case
                 When a.jaql486acan = 2 then
                 1
                 Else
                 0
                 End 
                )ATM_realizadas,                   
             sum(   
                 case
                 When a.jaql486acan = 3 then
                 1
                 Else
                 0
                 End 
                )Corresponsal_realizadas,
            sum(
                 case                   
                 When a.jaql486acan = 1  and a.jaql486areg >1 then
                 1
                 Else
                 0
                 End
               ) Ventanilla_cobradas,
             sum(  
                 case
                 When a.jaql486acan = 2 and a.jaql486areg > 1 then
                 1
                 Else
                 0
                 End 
                )ATM_cobradas,                   
             sum(   
                 case
                 When a.jaql486acan = 3 and a.jaql486areg > 1 then
                 1
                 Else
                 0
                 End 
                )Corresponsal_cobradas, 
             sum(   
                 case                     
                 When f.jaql486bmda = 0 then
                 a.jaql486amco 
                 Else
                 0
                 End
                )total_com_soles, 
             sum(   
                 case                     
                 When f.jaql486bmda = 101 then
                 a.jaql486amco 
                 Else
                 0
                 End
                )total_com_dolares,
             upper(d.scnom)  sucursal,
             upper(e.regnom) region,
             upper(c.ctnom)  titular        
        from jaql486b f,             
             jaql486a a,
             fsd008   c,
             fst001   d,
             fst810   e,
             fst811   g,
             fst198   h  
       where f.jaql486bpgc = a.jaql486apgc 
         and f.jaql486bmod = a.jaql486amod                                  
         and f.jaql486bsuc = a.jaql486asuc
         and f.jaql486btrx = a.jaql486atrx               
         and f.jaql486brel = a.jaql486arel                        
         and f.jaql486bfec = a.jaql486afec
         and f.jaql486bpgc = c.pgcod
         and f.jaql486bcta = c.ctnro
         and e.pgcod       = g.pgcod
         and g.pgcod       = d.pgcod
         and e.regcod      = g.regcod
         and g.oficod      = f.jaql486bsca
         and f.jaql486bsca = d.sucurs          
         and e.regcod < 100
         and g.regcod < 100    
         and h.tp1cod   = 1 
         and a.jaql486amod = h.tp1nro1
         and a.jaql486atrx = h.tp1nro2
         and f.jaql486bmdo = h.tp1corr3
         and f.jaql486btpo = h.tp1nro3
         and h.tp1cod1  = 10825 
         and tp1corr1   = 6
         and g.pgcod    = 1     
    group by f.jaql486bpgc,                        
             f.jaql486bcta,
             f.jaql486bope,
             f.jaql486bsbo,
             f.jaql486bmdo,
             f.jaql486bsca,
             f.jaql486btpo,
             f.jaql486bmda,
             f.jaql486bpap,
             upper(d.scnom), 
             upper(e.regnom),
             upper(c.ctnom);
  begin
  execute immediate('truncate table jaql486A');
  execute immediate('truncate table jaql486B');  

  delete from jaql486 where jaql486fpr = P_D_FECFIN; 
  commit;
  
  ld_fecfin:= P_D_FECFIN;  
  ld_fecpro := P_D_FECINI;
  
    While ld_fecpro <= ld_fecfin loop
          OPEN c_datos_a(ld_fecpro);
          LOOP
          FETCH c_datos_a BULK COLLECT 
           INTO ln_pgcod, ln_hsucor,ln_hcmod,ln_hctran,ln_hnrel,ld_fecha,ln_canal,ln_moncon,ln_numreg
          LIMIT 10000;
          EXIT WHEN ln_pgcod.count = 0;                                                       
              begin                    
              FORALL z IN 1..ln_pgcod.COUNT
              INSERT  /*+ append */  INTO JAQL486A
              
                        (jaql486apgc,
                         jaql486asuc,
                         jaql486amod,
                         jaql486atrx,
                         jaql486arel,
                         jaql486afec,
                         jaql486acan,
                         jaql486amco,
                         jaql486areg
                         )                         
                  VALUES                           
                        (ln_pgcod(z) , 
                         ln_hsucor(z),
                         ln_hcmod(z) ,
                         ln_hctran(z),
                         ln_hnrel(z) ,
                         ld_fecha(z) ,
                         ln_canal(z) ,
                         ln_moncon(z),
                         ln_numreg(z)                        
                         );          
                          commit;          
               exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
/*                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (999, 'JAQL486a', lc_error, sysdate);

                  commit;              */
                end;  
          END LOOP;       
          CLOSE c_datos_a;  
          --SEGUNDO BULL COLLECT
          
        OPEN c_datos_b(ld_fecpro);
          LOOP
          FETCH c_datos_b BULK COLLECT 
           INTO ln_pgcod, ln_hsucor,ln_hcmod,ln_hctran,ln_hnrel,ld_fecha,ln_hmodul,ln_htoper,ln_hsucur,ln_hmda,ln_hpap,ln_hcta,ln_hoper,ln_hsubop 
          LIMIT 10000;
          EXIT WHEN ln_pgcod.count = 0;                                                       
              begin                    
              FORALL z IN 1..ln_pgcod.COUNT
              INSERT  /*+ append */  INTO JAQL486B
              
                        (jaql486bpgc,
                         jaql486bsuc,
                         jaql486bmod,
                         jaql486btrx,
                         jaql486brel,
                         jaql486bfec,
                         jaql486bmdo,                          
                         jaql486btpo,                         
                         jaql486bsca,                        
                         jaql486bmda,                       
                         jaql486bpap,                          
                         jaql486bcta,                          
                         jaql486bope,                          
                         jaql486bsbo                          
                         )                         
                  VALUES                           
                        (ln_pgcod(z) , 
                         ln_hsucor(z),
                         ln_hcmod(z) ,
                         ln_hctran(z),
                         ln_hnrel(z) ,
                         ld_fecha(z) ,
                         ln_hmodul(z),
                         ln_htoper(z),
                         ln_hsucur(z),
                         ln_hmda(z)  ,
                         ln_hpap(z)  ,
                         ln_hcta(z)  ,
                         ln_hoper(z) ,
                         ln_hsubop(z)
                         );          
                          commit;          
               exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
/*                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (999, 'JAQL486b', lc_error, sysdate);

                  commit;      */        
                end;  
          END LOOP;       
          CLOSE c_datos_b;            
          
       ld_fecpro := ld_fecpro + 1;    
    End Loop;
    
    --LLENAMOS LA DATA EN TABLA DE RESULTADO
    OPEN c_resultado ;
          LOOP
          FETCH c_resultado BULK COLLECT 
           INTO ln_pgcod, ln_hcta,ln_hoper,ln_hsubop,ln_hmodul,ln_hsucur,ln_htoper,ln_hmda,ln_hpap,ln_totven,ln_totatm,ln_totcor,
                ln_tocven, ln_tocatm, ln_toccor, ln_mtosol, ln_mtodol, lc_sucursal, lc_region, lc_titular
          LIMIT 10000;
          EXIT WHEN ln_pgcod.count = 0;                                                       
              begin                    
              FORALL z IN 1..ln_pgcod.COUNT
              INSERT  /*+ append */  INTO JAQL486
              
                        (jaql486fpr,
                         jaql486pgc,
                         jaql486cta,
                         jaql486ope,
                         jaql486sbo,
                         jaql486mod,
                         jaql486suc,
                         jaql486top,
                         jaql486mda,
                         jaql486pap,
                         jaql486tve,
                         jaql486tat,
                         jaql486tco,
                         jaql486tcv,
                         jaql486tca,
                         jaql486tcc,
                         jaql486mts,
                         jaql486mtd,
                         jaql486dag,
                         jaql486reg,
                         jaql486tit                         
                         )                         
                  VALUES                           
                        (ld_fecfin     ,
                         ln_pgcod(z)   ,   
                         ln_hcta(z)    ,
                         ln_hoper(z)   ,
                         ln_hsubop(z)  ,
                         ln_hmodul(z)  ,
                         ln_hsucur(z)  ,
                         ln_htoper(z)  ,
                         ln_hmda(z)    ,
                         ln_hpap(z)    ,
                         ln_totven(z)  ,
                         ln_totatm(z)  ,
                         ln_totcor(z)  ,
                         ln_tocven(z)  , 
                         ln_tocatm(z)  , 
                         ln_toccor(z)  , 
                         ln_mtosol(z)  , 
                         ln_mtodol(z)  ,
                         lc_sucursal(z), 
                         lc_region(z)  , 
                         lc_titular(z)
                         );          
                          commit;          
               exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
/*                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (999, 'JAQL486', lc_error, sysdate);

                  commit; */             
                end;  
          END LOOP;       
          CLOSE c_resultado;  
          
  commit;        
  end sp_ah_rep_cobro_com;             
  
  Procedure sp_ah_exonera_inactiva(P_N_PGCOD  IN NUMBER,
                                   P_N_CTNRO  IN NUMBER,
                                   P_N_ITOPER IN NUMBER,
                                   P_N_ITSUBO IN NUMBER,
                                   P_N_SUCDES IN NUMBER,
                                   P_N_ITTOPE IN NUMBER,
                                   P_N_MODULO IN NUMBER,
                                   P_N_MONEDA IN NUMBER,
                                   P_N_PAPEL  IN NUMBER,
                                   P_D_FECPRO IN DATE,
                                   P_C_CODUSU IN VARCHAR2                                   
                                  ) is
  PRAGMA AUTONOMOUS_TRANSACTION;                                                                      
  lc_aplica char(1):='N'; 
  ln_diaexo  number(9):= 0;
  ld_fecini date;
  ld_fecfin date;
  dia number(2):=0;
  mes number(2):=0;  
  ano number(2):=0;
  ld_fecha date;
  ln_cormax number(5):=0;
  ln_corina number(5):=0;
  ld_fecmax date;
  ld_fecina date;
  lc_registra CHAR(1):= 'N';
  lc_indexo char(1) := 'N';
  ld_fecpro date;
  lv_exonera varchar2(1):= 'N';
  
  cursor c_canales(pn_codcom in number) is
    Select distinct 
           a.tp1imp3 aqpa109ccan
      from fst198 a
     where a.tp1cod   = 1
       and a.tp1cod1  = 10825
       and a.tp1corr1 = 95
       and a.tp1corr2 = 1
       and a.tp1nro3  = pn_codcom;--comision  
  
  CURSOR C_COMISIONES IS
  select x.tp1nro1                                                                                   tp1corr2,
         decode(a.aqpa109exo,null,x.tp1nro3,a.aqpa109exo)                                            tp1nro1,
         decode(a.aqpa109fin,null,x.tp1imp1,to_number(substr(to_char(a.aqpa109fin,'dd/mm/yy'),1,2))) tp1imp1,
         decode(a.aqpa109fin,null,x.tp1imp2,to_number(substr(to_char(a.aqpa109fin,'dd/mm/yy'),4,2))) tp1imp2,
         decode(a.aqpa109fin,null,x.tp1imp3,to_number(substr(to_char(a.aqpa109fin,'dd/mm/yy'),7,2))) tp1imp3, 
         x.tp1nro2  
    from fst198 x,
         aqpa109 a
   where a.aqpa109com(+) = x.tp1nro1
     and x.tp1cod1  = 10825 
     and x.tp1corr1 = 9 
     and x.tp1corr2 = 1;
     
/*  select x.tp1corr2,x.tp1nro1,x.tp1imp1,x.tp1imp2,x.tp1imp3
    from fst198 x
   where x.tp1cod1  = 10825 
     and x.tp1corr1 = 9 
     and x.tp1corr3 = 0
     ; */                           
     
  begin
  --verificar que la cuenta este vigente en fsd011
    begin
      select 'S' 
        into lc_aplica
        from fsd011 a
       where a.pgcod  = P_N_PGCOD
         and a.scsuc  = P_N_SUCDES
         and a.sccta  = P_N_CTNRO
         and a.scmod  = P_N_MODULO
         and a.scmda  = P_N_MONEDA
         and a.scpap  = P_N_PAPEL
         and a.scoper = P_N_ITOPER
         and a.scsbop = P_N_ITSUBO
         and a.sctope = P_N_ITTOPE
         and a.scstat <> 99;                 
    Exception
    When others then     
      lc_aplica := 'N';
    end;   
    
    If lc_aplica = 'S' then
       --obtenemos fecha maxima de cambio de estado       
       begin 
          select b.cbiefec, 
                 max(b.cbierel)
            into ld_fecmax,
                 ln_cormax
            from fsd450 b
           where b.CBIEEMP = P_N_PGCOD                         
             and b.CBIEMOD = P_N_MODULO                         
             and b.CBIESUC = P_N_SUCDES                         
             and b.CBIEMDA = P_N_MONEDA                         
             and b.CBIEPAP = P_N_PAPEL                         
             and b.CBIECTA = P_N_CTNRO                         
             and b.CBIEOPE = P_N_ITOPER                         
             and b.CBIESUB = P_N_ITSUBO                         
             and b.CBIETOP = P_N_ITTOPE            
             and b.CBIEFEC = (select max(cbiefec) 
                                from fsd450 a
                               where a.CBIEEMP = P_N_PGCOD                         
                                 and a.CBIEMOD = P_N_MODULO                         
                                 and a.CBIESUC = P_N_SUCDES                         
                                 and a.CBIEMDA = P_N_MONEDA                         
                                 and a.CBIEPAP = P_N_PAPEL                         
                                 and a.CBIECTA = P_N_CTNRO                         
                                 and a.CBIEOPE = P_N_ITOPER                         
                                 and a.CBIESUB = P_N_ITSUBO                         
                                 and a.CBIETOP = P_N_ITTOPE                         
                              )
         group by b.CBIEFEC;
       Exception
       When others then
            ld_fecmax := null;
            ln_cormax := 0;
       End;
       --obtenemos fecha de ultima inactivacion de la cuenta       
       begin 
          select b.cbiefec, 
                 max(b.cbierel)
            into ld_fecina,
                 ln_corina
            from fsd450 b
           where b.CBIEEMP = P_N_PGCOD                         
             and b.CBIEMOD = P_N_MODULO                         
             and b.CBIESUC = P_N_SUCDES                         
             and b.CBIEMDA = P_N_MONEDA                         
             and b.CBIEPAP = P_N_PAPEL                         
             and b.CBIECTA = P_N_CTNRO                         
             and b.CBIEOPE = P_N_ITOPER                         
             and b.CBIESUB = P_N_ITSUBO                         
             and b.CBIETOP = P_N_ITTOPE           
             and upper(b.CBIETXT1) like '%INACTIVA%' 
             and b.CBIEFEC = (select max(cbiefec) 
                                from fsd450 a
                               where a.CBIEEMP = P_N_PGCOD                         
                                 and a.CBIEMOD = P_N_MODULO                         
                                 and a.CBIESUC = P_N_SUCDES                         
                                 and a.CBIEMDA = P_N_MONEDA                         
                                 and a.CBIEPAP = P_N_PAPEL                         
                                 and a.CBIECTA = P_N_CTNRO                         
                                 and a.CBIEOPE = P_N_ITOPER                         
                                 and a.CBIESUB = P_N_ITSUBO                         
                                 and a.CBIETOP = P_N_ITTOPE   
                                 and upper(A.CBIETXT1) like '%INACTIVA%'                      
                              )
           group by b.CBIEFEC;
       Exception
       When others then
           ld_fecina := null;
           ln_corina := 0;
       End;       

       If (ld_fecina = ld_fecmax) and (ln_corina = ln_cormax) then
          lc_registra := 'S';
       Else
          lc_registra := 'N';
       End If;
    
       If lc_registra = 'S' then
           --VALIDAMOS SI FUE NOTIFICADO EL CLIENTE POR SUS PRODUCTO EN CASO NO HAYA SIDO RECIEN EXONERAMOS
           ld_fecpro := pq_ah_new_comision.fn_ah_exonera_stock(p_d_fecpro => P_D_FECPRO,
                                                               p_n_pgcod  => P_N_PGCOD,
                                                               p_n_modulo => P_N_MODULO,
                                                               p_n_sucdes => P_N_SUCDES,
                                                               p_n_moneda => P_N_MONEDA,
                                                               p_n_papel  => P_N_PAPEL, 
                                                               p_n_ctnro  => P_N_CTNRO,
                                                               p_n_itoper => P_N_ITOPER,                                                                      
                                                               p_n_itsubo => P_N_ITSUBO,
                                                               p_n_ittope => P_N_ITTOPE
                                                               );
           if ld_fecpro is null or ld_fecpro > P_D_FECPRO then   
              lv_exonera := 'S';                                                           
           End if;          
                                                      
           If lv_exonera = 'S' then                                                              
             For i in c_comisiones loop
               ln_diaexo := i.tp1nro1;
               dia := i.tp1imp1;
               mes := i.tp1imp2;
               ano := i.tp1imp3;
               ld_fecha := to_date(lpad(dia,2,'0')||'/'||lpad(mes,2,'0')||'/'||lpad(ano,2,'0'),'dd/mm/yy');
                           
               If ((ld_fecina < ld_fecha) and ln_diaexo > 0) then 
                    ld_fecini := P_D_FECPRO;
                    ld_fecfin := P_D_FECPRO + ln_diaexo;  
                    
                    if lv_exonera = 'S' and ld_fecpro > P_D_FECPRO then
                       ld_fecfin := ld_fecpro;
                    End If;
                    lc_indexo := 'S'; 
                    
                    --
                    --validamos guias de tipo de operacion a exonerar
                    --
                    /*  if i.tp1corr2 <> 4 then
                        begin
                          select 'S'
                            into lc_indexo
                            from fst198 x
                           where x.tp1cod1  = 10825 
                             and x.tp1corr1 = 6
                             and x.tp1corr3 = 21
                             and x.tp1nro3  = P_N_ITTOPE
                             and rownum < 2;
                        Exception     
                        When no_data_found then
                          lc_indexo := 'N';
                        End;  
                      else
                          lc_indexo := 'S';
                      end if;*/
                      
                      if lc_indexo = 'S' and i.tp1corr2 = 2 then
                        begin
                          select 'S'
                            into lc_indexo
                            from Prd001 a
                           where a.pgcod  = P_N_PGCOD
                             and a.modulo = P_N_MODULO
                             and a.totope = P_N_ITTOPE
                             and a.moneda = P_N_MONEDA
                             and a.papel  = P_N_PAPEL
                             and prd1cspr = 'S';           
                        Exception     
                        When no_data_found then
                          lc_indexo := 'N';
                        When others then  
                          lc_indexo := 'N';
                        End;    
                      End If;  
                    --     
               
                   if lc_indexo = 'S' and i.tp1corr2 not in (4,5) then  
                       if i.tp1corr2 = 2 then
                         Begin
                           insert into JAQL485(JAQL485PGE, 
                                               JAQL485SUC,
                                               JAQL485CTA,
                                               JAQL485MOD,
                                               JAQL485MDA,
                                               JAQL485PAP,
                                               JAQL485OPE,
                                               JAQL485SBO,
                                               JAQL485TOP,
                                               JAQL485TCO,
                                               JAQL485CNV,
                                               JAQL485CNA,
                                               JAQL485CNC,
                                               JAQL485CNH,
                                               JAQL485FEI,
                                               JAQL485FEF,
                                               JAQL485FEC,
                                               JAQL485USC,
                                               JAQL485HCR,
                                               JAQL485AX1,
                                               JAQL485AX2
                                               )
                                        values(P_N_PGCOD,
                                               P_N_SUCDES,
                                               P_N_CTNRO,
                                               P_N_MODULO,
                                               P_N_MONEDA,
                                               P_N_PAPEL ,
                                               P_N_ITOPER,
                                               P_N_ITSUBO,
                                               P_N_ITTOPE,
                                               i.tp1corr2,
                                               0,
                                               0,
                                               0,
                                               0,
                                               ld_fecini,
                                               ld_fecfin,
                                               P_D_FECPRO,
                                               decode(trim(P_C_CODUSU),null,'BANTOTAL',RPAD(P_C_CODUSU,10,' ')),
                                               TO_CHAR(sysdate,'HH24:mi:ss'),
                                               1,
                                               0                                 
                                               );                                      
                         Exception
                         When others then
                           null;
                         End;                         
                       else                         
                         For j in c_canales(i.tp1corr2) loop                             
                           Begin
                             insert into JAQL485(JAQL485PGE, 
                                                 JAQL485SUC,
                                                 JAQL485CTA,
                                                 JAQL485MOD,
                                                 JAQL485MDA,
                                                 JAQL485PAP,
                                                 JAQL485OPE,
                                                 JAQL485SBO,
                                                 JAQL485TOP,
                                                 JAQL485TCO,
                                                 JAQL485CNV,
                                                 JAQL485CNA,
                                                 JAQL485CNC,
                                                 JAQL485CNH,
                                                 JAQL485FEI,
                                                 JAQL485FEF,
                                                 JAQL485FEC,
                                                 JAQL485USC,
                                                 JAQL485HCR,
                                                 JAQL485AX1,
                                                 JAQL485AX2
                                                 )
                                          values(P_N_PGCOD,
                                                 P_N_SUCDES,
                                                 P_N_CTNRO,
                                                 P_N_MODULO,
                                                 P_N_MONEDA,
                                                 P_N_PAPEL ,
                                                 P_N_ITOPER,
                                                 P_N_ITSUBO,
                                                 P_N_ITTOPE,
                                                 i.tp1corr2,
                                                 0,
                                                 0,
                                                 0,
                                                 0,
                                                 ld_fecini,
                                                 ld_fecfin,
                                                 P_D_FECPRO,
                                                 decode(trim(P_C_CODUSU),null,'BANTOTAL',RPAD(P_C_CODUSU,10,' ')),
                                                 TO_CHAR(sysdate,'HH24:mi:ss'),
                                                 1,
                                                 j.aqpa109ccan                                 
                                                 );                                      
                           Exception
                           When others then
                             null;
                           End;  
                         End loop; 
                       end if;                     
                   End If;
                   if lc_indexo = 'S' and i.tp1corr2 in (4,5) then                   
                       --AGREGAMOS AL GRUPO DE COMISION INACTIVAS
                       begin
                         insert into fsd009
                           (tgcod, grnro, pgcod, ctnro, grincod, grporc)
                         values
                           (27, 131216, P_N_PGCOD, P_N_CTNRO, 1, 0.00);
                       exception
                       when others then  
                         null;
                         end;                               
                   End if;                 
               End IF;          
             End Loop; 
           End if;          
           commit;
       End If;
    End If; 
  Exception
  When others then
    null;         
  end sp_ah_exonera_inactiva;                                                                                                         
  Procedure sp_ah_act_exoneracion(P_N_CODCOM IN NUMBER,
                                  P_D_FECPRO IN DATE,
                                  P_C_CODUSU IN VARCHAR2           
                                  ) is 
  CURSOR C_COMISIONES IS
  select x.tp1corr2,x.tp1nro1,x.tp1imp1,x.tp1imp2,x.tp1imp3
    from fst198 x
   where x.tp1cod1  = 10825 
     and x.tp1corr1 = 9 
     and x.tp1corr3 = 0
     and x.tp1corr2 = P_N_CODCOM
     ;    
     
  ln_diaexo  number(9):= 0;
  ld_fecini date;
  ld_fecfin date;
  dia number(2):=0;
  mes number(2):=0;  
  ano number(2):=0;
  ld_fecha date;
       
  begin
     
     For i in c_comisiones loop
         ln_diaexo := i.tp1nro1;
         dia := i.tp1imp1;
         mes := i.tp1imp2;
         ano := i.tp1imp3;
         ld_fecha := to_date(lpad(dia,2,'0')||'/'||lpad(mes,2,'0')||'/'||lpad(ano,2,'0'),'dd/mm/yy');     
         ld_fecini := ld_fecha;
         ld_fecfin := ld_fecha + ln_diaexo;           
         
         begin
           update JAQL485                
              set JAQL485FEI = ld_fecini,
                  JAQL485FEF = ld_fecfin,
                  JAQL485FEM = P_D_FECPRO,
                  JAQL485USM = RPAD(P_C_CODUSU,10,' '),
                  JAQL485HMD = TO_CHAR(sysdate,'HH24:mi:ss')
            where JAQL485TCO = P_N_CODCOM
              and JAQL485USC = RPAD('BANTOTAL',10,' ');
         Exception
         when others then
           null;
         end;         
     end Loop;
     commit;
  Exception
  When others then
       null;
  end sp_ah_act_exoneracion;      
  Procedure sp_ah_exonera_com_mtc(P_N_PGCOD  IN NUMBER,
                                  P_N_CTNRO  IN NUMBER,
                                  P_N_ITOPER IN NUMBER,
                                  P_N_ITSUBO IN NUMBER,
                                  P_N_SUCDES IN NUMBER,
                                  P_N_ITTOPE IN NUMBER,
                                  P_N_MODULO IN NUMBER,
                                  P_N_MONEDA IN NUMBER,
                                  P_N_PAPEL  IN NUMBER,
                                  P_C_ESTADO IN VARCHAR2
                                  ) is  
  begin
    update fse013 b
       set b.cvcspr = P_C_ESTADO
     where b.pgcod  = P_N_PGCOD
       and b.cvsuc  = P_N_SUCDES
       and b.cvcta  = P_N_CTNRO
       and b.cvmod  = P_N_MODULO
       and b.cvmda  = P_N_MONEDA
       and b.cvpap  = P_N_PAPEL
       and b.cvoper = P_N_ITOPER
       and b.cvsbop = P_N_ITSUBO
       and b.cvtope = P_N_ITTOPE;
       commit;
  Exception
  When others then
    null;                                    
  end sp_ah_exonera_com_mtc;                                                              
  Procedure sp_ah_monto_rubro(P_N_PGCOD  IN NUMBER,
                              P_N_CTNRO  IN NUMBER,
                              P_N_ITOPER IN NUMBER,
                              P_N_ITSUBO IN NUMBER,
                              P_N_SUCDES IN NUMBER,
                              P_N_MONEDA IN NUMBER,
                              P_N_PAPEL  IN NUMBER,
                              p_n_monto  out number
                              ) is  
  ln_modulo number(3);  
  ln_rubro  number(16);                  
  begin
   -- obtenemos rubro de exoneración           
     begin
         select to_number(trim(a.tp1desc)),
                a.tp1nro2
           into ln_rubro,
                ln_modulo
           from fst198 a 
          where a.tp1cod   = P_N_PGCOD
            and a.tp1cod1  = 10825
            and a.tp1corr1 = 33
            and a.tp1corr2 = 2
            and a.tp1nro1  = P_N_MONEDA;
     exception
     when others then            
       ln_rubro := 0;
     end;                 

    begin
    select a.scsdo 
      into p_n_monto 
      from fsd011 a 
     where a.pgcod  = P_N_PGCOD
       and a.scsuc  = P_N_SUCDES
       and a.scmod  = ln_modulo
       and a.scrub  = ln_rubro
       and a.scmda  = P_N_MONEDA
       and a.scpap  = P_N_PAPEL
       and a.sccta  = P_N_CTNRO
       and a.scoper = P_N_ITOPER
       and a.scsbop = P_N_ITSUBO;
   end;
  Exception
  When others then
    p_n_monto := 0;      
/*    insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'PR_MAL','SI ENTRA',trunc(sysdate));      
   COMMIT;                                  */
  end sp_ah_monto_rubro;                                 
  Procedure sp_ah_monto_asiento(P_D_FECPRO IN DATE,
                                P_N_PGCOD  IN NUMBER,
                                P_N_ITSUC  IN NUMBER,           
                                P_N_ITMOD  IN NUMBER,
                                P_N_ITTRAN IN NUMBER,                                
                                P_N_ITNREL IN NUMBER,
                                P_N_ITORD  IN NUMBER,  
                                P_N_ITSBO  IN NUMBER
                                ) is                                 
  ln_ctnro   number(9);  
  --ln_codseg  number(2);   
  ln_itoper  number(9);  
  ln_itsubo  number(3);  
  ln_sucdes  number(3);  
  ln_ittope  number(3);  

  ln_moneda  number(4);  
  ln_papel   number(4);  
  ln_monrub  number(17,2);
  ln_monto   number(17,2);
  ln_modeb   number(17,2);
  ln_tipasi  number(9);
  ln_ordin1  number(17,2);
  ln_ordin2  number(17,2);  
   
  ln_r1cod   number(3); 
  ln_r1mod   number(3); 
  ln_r1suc   number(3); 
  ln_r1mda   number(4); 
  ln_r1pap   number(5); 
  ln_r1cta   number(9); 
  ln_r1oper  number(9);
  ln_r1sbop  number(3);
  ln_r1tope  number(3);
  ln_modulo  number(3);
  /*
  ln_r2cod   number(3); 
  ln_r2mod   number(3); 
  ln_r2suc   number(3); 
  ln_r2mda   number(4); 
  ln_r2pap   number(5); 
  ln_r2cta   number(9); 
  ln_r2oper  number(9);
  ln_r2sbop  number(3);
  ln_r2tope  number(3);
  */
  --ld_fecsis  date;
  ln_flag   number(1):=0;   
  --lc_error  varchar2(400);        
  ln_salrem   number(17,2):=0;
  ln_salter   number(17,2):=0;
  lc_cancel   char(1) := 'N';
  
  ln_relori number(4):=0;
  ld_fecori date;
  ln_modori number(3):= 0;
  ln_totdeb  number(17,2):=0;
  
  cursor c_original is
    Select * 
     from FSX015 --Textos
    Where PgCod  = P_N_PGCOD
      and Hcmod  = P_N_ITMOD
      and Hsucor = P_N_ITSUC
      and Htran  = P_N_ITTRAN
      and Hnrel  = P_N_ITNREL
      and Hfcon  = P_D_FECPRO
      and Txcod  = 0;  
  
  cursor c_cuentas (ln_r1cod  in number,
                    ln_r1mod  in number,
                    ln_r1mda  in number, 
                    ln_r1pap  in number,
                    ln_r1cta  in number,
                    ln_r1oper in number,
                    ln_r1sbop in number,
                    ln_r1tope in number
                    )is
    select q.r2cod, 
           q.r2mod, 
           q.r2suc, 
           q.r2mda, 
           q.r2pap, 
           q.r2cta, 
           q.r2oper,
           q.r2sbop,
           q.r2tope,
           sum(q.r1rub/100) saldo    
      from fsr011 q 
     where q.r1cod  = ln_r1cod 
       and q.r1mod  = ln_r1mod 
       --and q.r1suc  = ln_r1suc 
       and q.r1mda  = ln_r1mda 
       and q.r1pap  = ln_r1pap 
       and q.r1cta  = ln_r1cta 
       and q.r1oper = ln_r1oper
       and q.r1sbop = ln_r1sbop
       and q.r1tope = ln_r1tope
       and q.relcod = 200
  group by q.r2cod, 
           q.r2mod, 
           q.r2suc, 
           q.r2mda, 
           q.r2pap, 
           q.r2cta, 
           q.r2oper,
           q.r2sbop,
           q.r2tope;
        
  begin  
    
/*                lc_error := 'PROBANDO TRANSACCION - '||P_N_ITMOD||' - '||P_N_ITTRAN;
                insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'XXX',lc_error,trunc(sysdate));
                commit;     */
                
    begin
        select a.modulo,
               a.ctnro,
               a.itoper,
               a.itsubo,
               a.itsucd,
               a.ittope,
               a.moneda,
               a.papel,
               a.itimp1
          into ln_modulo,
               ln_ctnro,
               ln_itoper,          
               ln_itsubo,          
               ln_sucdes,          
               ln_ittope,          
               ln_moneda,          
               ln_papel,
               ln_monto          
          from fsd016 a
         where a.pgcod  = P_N_PGCOD
           and a.itsuc  = P_N_ITSUC
           and a.itmod  = P_N_ITMOD
           and a.ittran = P_N_ITTRAN
           and a.itnrel = P_N_ITNREL
           and a.itord  = P_N_ITORD
           and a.itsbor = P_N_ITSBO;
    exception
    when others then            
      ln_ctnro := 0;
/*                lc_error := 'NO SE ENCONTRO DATOS DEL AHORRO';
                insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'FSD016',lc_error,trunc(sysdate));
*/                --commit;      
    end;    
    begin
       select Tp1nro3,
              Tp1imp2,
              Tp1imp3
         into ln_tipasi,
              ln_ordin1, 
              ln_ordin2
         from fst198
        Where Tp1cod   = 1
          and Tp1cod1  = 10825
          and Tp1corr1 = 33
          and Tp1corr2 = 1
          and Tp1nro1  = P_N_ITMOD
          and Tp1nro2  = P_N_ITTRAN
          and Tp1imp1  = ln_ittope;
          --and Tp1imp2  =       
      exception
      when no_data_found then
        begin
           select Tp1nro3,
                  Tp1imp2,
                  Tp1imp3
             into ln_tipasi,
                  ln_ordin1, 
                  ln_ordin2
             from fst198
            Where Tp1cod   = 1
              and Tp1cod1  = 10825
              and Tp1corr1 = 33
              and Tp1corr2 = 1
              and Tp1nro1  = P_N_ITMOD
              and Tp1nro2  = P_N_ITTRAN;
        exception
        when others then    
            ln_tipasi := -1;
            /*
                      lc_error := sqlerrm;--'NO SE ENCONTRO EN GUIA DE PROCESOS';
                      insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'FST198',lc_error,trunc(sysdate));*/
                      --commit;                    
        end;    
    when others then 
      ln_tipasi := -1;
      /*
                lc_error := sqlerrm;--'NO SE ENCONTRO EN GUIA DE PROCESOS';
                insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'FST198',lc_error,trunc(sysdate));*/
                --commit;          
    end;   
    
    if ln_tipasi > 0 and ln_tipasi not in (98,99) then
          --verificamos si la cuenta cliente pertenece a cliente dependiente o independiente
          /*
          begin
              select y.ctsegm
                into ln_codseg
                from fsd008 y
               where y.pgcod = 1
                 and y.ctnro = ln_ctnro;      
          exception
          when others then   
            ln_codseg := 3;  
          end;
          */      
          if ln_ordin1 <> 0 and ln_ordin2 <>0 then
              --registramos la relacion de desembolso credito cuenta de ahorro, o dpf-cuenta de ahorro
              begin
                  select z.pgcod,
                         decode(z.modulo,426,22,z.modulo),
                         z.itsucd,
                         z.moneda,
                         z.papel,
                         z.ctnro,
                         z.itoper,
                         z.itsubo,
                         z.ittope
                    into ln_r1cod, 
                         ln_r1mod, 
                         ln_r1suc, 
                         ln_r1mda, 
                         ln_r1pap, 
                         ln_r1cta, 
                         ln_r1oper,
                         ln_r1sbop,
                         ln_r1tope
                    from fsd016 z
                   where z.Pgcod  = P_N_PGCOD
                     and z.Itsuc  = P_N_ITSUC
                     and z.Itmod  = P_N_ITMOD
                     and z.Ittran = P_N_ITTRAN
                     and z.Itnrel = P_N_ITNREL
                     and z.Itord  = ln_ordin1;
              exception 
              when others then       
                ln_flag := 1;
              /*  lc_error := 'NO SE ENCONTRO DATOS DEL CREDITO';
                insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'FSD016',lc_error,trunc(sysdate));*/
               -- commit;

              end;  
              --si e slinea traer los datos d ela linea total del modulo 117 de la fsr011
              if ln_r1mod = 116 then
                begin
                  select q.r2cod, 
                         q.r2mod, 
                         q.r2suc, 
                         q.r2mda, 
                         q.r2pap, 
                         q.r2cta, 
                         q.r2oper,
                         q.r2sbop,
                         q.r2tope
                    into ln_r1cod, 
                         ln_r1mod, 
                         ln_r1suc, 
                         ln_r1mda, 
                         ln_r1pap, 
                         ln_r1cta, 
                         ln_r1oper,
                         ln_r1sbop,
                         ln_r1tope
                    from fsr011 q 
                   where q.r1cod  = ln_r1cod 
                     and q.r1mod  = ln_r1mod 
                     and q.r1suc  = ln_r1suc 
                     and q.r1mda  = ln_r1mda 
                     and q.r1pap  = ln_r1pap 
                     and q.r1cta  = ln_r1cta 
                     and q.r1oper = ln_r1oper
                     and q.r1sbop = ln_r1sbop
                     and q.r1tope = ln_r1tope
                     and q.relcod = 46
                     and q.r2mod  = 117
                     and q.r2cod  = ln_r1cod
                     and q.r2cta  = ln_r1cta;
                exception 
                when others then
                   ln_flag := 1;
                end;
                
              End If;  
              -- obtenemos el monto de al linea de la fsd011 (ln_monto  )
              if ln_r1mod = 117 then  
                begin
                  select k.scsdo
                    into ln_monto 
                    from fsd011 k 
                   where k.pgcod  = ln_r1cod
                     and k.scmod  = ln_r1mod
                     and k.scsuc  = ln_r1suc
                     and k.scmda  = ln_r1mda
                     and k.scpap  = ln_r1pap
                     and k.sccta  = ln_r1cta
                     and k.scoper = ln_r1oper
                     and k.scsbop = ln_r1sbop
                     and k.sctope = ln_r1tope;
                exception
                when others then
                     ln_monto := 0;
                end; 
              end if;               
              /*
              begin
                  select z.pgcod,
                         z.modulo,
                         z.itsucd,
                         z.moneda,
                         z.papel,
                         z.ctnro,
                         z.itoper,
                         z.itsubo,
                         z.ittope
                    into ln_r2cod, 
                         ln_r2mod, 
                         ln_r2suc, 
                         ln_r2mda, 
                         ln_r2pap, 
                         ln_r2cta, 
                         ln_r2oper,
                         ln_r2sbop,
                         ln_r2tope
                    from fsd016 z
                   where z.Pgcod  = P_N_PGCOD
                     and z.Itsuc  = P_N_ITSUC
                     and z.Itmod  = P_N_ITMOD
                     and z.Ittran = P_N_ITTRAN
                     and z.Itnrel = P_N_ITNREL
                     and z.Itord  = ln_ordin2;
              exception 
              when others then       
                null;
              end;    
              */  
              --if ln_codseg <> 2 then   
                if ln_flag = 0 then
                  --obtenemos fecha de bantotal
                  --select pgfape into ld_fecsis from fst017 where pgcod = P_N_PGCOD;               
                  --registramos en fsr011          
                  begin
                  if ln_ittope = 9 then     
                    insert into fsr011(r1cod, 
                                       r1mod, 
                                       r1suc, 
                                       r1mda, 
                                       r1pap, 
                                       r1cta, 
                                       r1oper,
                                       r1sbop,
                                       r1tope,
                                       relcod,
                                       r2mod, 
                                       r2cta, 
                                       r2oper,
                                       r2sbop,
                                       r1rub, 
                                       r2cod, 
                                       r2suc, 
                                       r2mda, 
                                       r2pap, 
                                       r2tope,
                                       r2rub, 
                                       r011cd,
                                       r011mo,
                                       r011su,
                                       r011tr,
                                       r011re,
                                       r011fc,
                                       r011or,
                                       r011sb,
                                       r011co
                                      )
                                values(ln_r1cod, 
                                       ln_r1mod, 
                                       ln_r1suc, 
                                       ln_r1mda, 
                                       ln_r1pap, 
                                       ln_r1cta, 
                                       ln_r1oper,
                                       ln_r1sbop,
                                       ln_r1tope,
                                       200,
                                       ln_modulo,
                                       ln_ctnro,
                                       ln_itoper,
                                       ln_itsubo,
                                       ln_monto*100,
                                       ln_r1cod,
                                       ln_sucdes, 
                                       ln_moneda, 
                                       ln_papel, 
                                       ln_ittope,          
                                       0,
                                       0,
                                       0,
                                       0,
                                       0,
                                       0,
                                       P_D_FECPRO,
                                       0,
                                       0,
                                       'S'
                                      );
                   --                                        
                   --Adicionamos registro de bolsa producto del desembolso
                   --
                      -- Call the procedure
                      pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => P_D_FECPRO,
                                                       p_n_pgcod  => ln_r1cod,
                                                       p_n_modulo => ln_modulo,
                                                       p_n_sucdes => ln_sucdes,
                                                       p_n_moneda => ln_moneda,
                                                       p_n_papel  => ln_papel,
                                                       p_n_ctnro  => ln_ctnro,
                                                       p_n_itoper => ln_itoper,
                                                       p_n_itsubo => ln_itsubo,
                                                       p_n_ittope => ln_ittope,
                                                       p_c_tiptrx => 'A',
                                                       p_n_monmov => 0,
                                                       p_n_montem => ln_monto,
                                                       p_n_pgemp  => P_N_PGCOD, 
                                                       p_n_itsuc  => P_N_ITSUC,
                                                       p_n_itmod  => P_N_ITMOD, 
                                                       p_n_ittran => P_N_ITTRAN,
                                                       p_n_itnrel => P_N_ITNREL,
                                                       p_n_itnord => P_N_ITORD
                                                       );
                  end if;                                                        
                  exception
                  when dup_val_on_index then
                    if ln_r1mod = 117 then
                        if ln_ittope = 9 then
                        begin
                           update fsr011 X
                              set r011fc = P_D_FECPRO,
                                  --R1RUB  = R1RUB + ln_monto*100,
                                  R1RUB  = ln_monto*100,
                                  r011co = 'S'
                            where R1COD  = ln_r1cod
                              and R1MOD  = ln_r1mod 
                              and R1SUC  = ln_r1suc 
                              and R1MDA  = ln_r1mda 
                              and R1PAP  = ln_r1pap 
                              and R1CTA  = ln_r1cta 
                              and R1OPER = ln_r1oper
                              and R1SBOP = ln_r1sbop 
                              and R1TOPE = ln_r1tope
                              and RELCOD = 200
                              and R2MOD  = ln_modulo
                              and R2CTA  = ln_ctnro
                              and R2OPER = ln_itoper
                              and R2SBOP = ln_itsubo
                              and R2TOPE = ln_ittope;
                       --                                        
                       --Adicionamos registro de bolsa producto del desembolso
                       --
                          -- Call the procedure
                          pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => P_D_FECPRO,
                                                           p_n_pgcod  => ln_r1cod,
                                                           p_n_modulo => ln_modulo,
                                                           p_n_sucdes => ln_sucdes,
                                                           p_n_moneda => ln_moneda,
                                                           p_n_papel  => ln_papel,
                                                           p_n_ctnro  => ln_ctnro,
                                                           p_n_itoper => ln_itoper,
                                                           p_n_itsubo => ln_itsubo,
                                                           p_n_ittope => ln_ittope,
                                                           p_c_tiptrx => 'A',
                                                           p_n_monmov => 0,
                                                           p_n_montem => ln_monto,
                                                           p_n_pgemp  => P_N_PGCOD, 
                                                           p_n_itsuc  => P_N_ITSUC,
                                                           p_n_itmod  => P_N_ITMOD, 
                                                           p_n_ittran => P_N_ITTRAN,
                                                           p_n_itnrel => P_N_ITNREL,
                                                           p_n_itnord => P_N_ITORD
                                                           );                              
                        exception
                        when others then
                            null;
    /*                        lc_error := sqlerrm;
                            insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'FSR011',lc_error,trunc(sysdate));*/
                           -- commit;
                        end;
                        end if;
                    else
                        if ln_ittope = 9 then
                        begin
                           update fsr011 X
                              set r011fc = P_D_FECPRO,
                                  R1RUB  = R1RUB + ln_monto*100,                                  
                                  r011co = 'S'
                            where R1COD  = ln_r1cod
                              and R1MOD  = ln_r1mod 
                              and R1SUC  = ln_r1suc 
                              and R1MDA  = ln_r1mda 
                              and R1PAP  = ln_r1pap 
                              and R1CTA  = ln_r1cta 
                              and R1OPER = ln_r1oper
                              and R1SBOP = ln_r1sbop 
                              and R1TOPE = ln_r1tope
                              and RELCOD = 200
                              and R2MOD  = ln_modulo
                              and R2CTA  = ln_ctnro
                              and R2OPER = ln_itoper
                              and R2SBOP = ln_itsubo
                              and R2TOPE = ln_ittope;
                              
                       --                                        
                       --Adicionamos registro de bolsa producto del desembolso
                       --
                          -- Call the procedure
                          pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => P_D_FECPRO,
                                                           p_n_pgcod  => ln_r1cod,
                                                           p_n_modulo => ln_modulo,
                                                           p_n_sucdes => ln_sucdes,
                                                           p_n_moneda => ln_moneda,
                                                           p_n_papel  => ln_papel,
                                                           p_n_ctnro  => ln_ctnro,
                                                           p_n_itoper => ln_itoper,
                                                           p_n_itsubo => ln_itsubo,
                                                           p_n_ittope => ln_ittope,
                                                           p_c_tiptrx => 'A',
                                                           p_n_monmov => 0,
                                                           p_n_montem => ln_monto,
                                                           p_n_pgemp  => P_N_PGCOD, 
                                                           p_n_itsuc  => P_N_ITSUC,
                                                           p_n_itmod  => P_N_ITMOD, 
                                                           p_n_ittran => P_N_ITTRAN,
                                                           p_n_itnrel => P_N_ITNREL,
                                                           p_n_itnord => P_N_ITORD
                                                           );                                 
                        exception
                        when others then
                            null;
    /*                        lc_error := sqlerrm;
                            insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'FSR011',lc_error,trunc(sysdate));*/
                           -- commit;
                        end;
                        end if;                       
                    end if;
                   when others then  
                        null;
/*                        lc_error := sqlerrm;
                        insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'FSR011_1',lc_error,trunc(sysdate));*/
                        --commit;                     
                  end;
                end if;  
              --end if;
          End if;   
          
          --obtenemos saldo de remuneraciones    
          begin
            -- Call the procedure
            pq_ah_comision.sp_ah_saldos_remu(p_n_pgcod  => P_N_PGCOD,
                                             p_n_modulo => 21,
                                             p_n_ctnro  => ln_ctnro,
                                             p_n_itoper => ln_itoper,
                                             p_n_itsubo => ln_itsubo,
                                             p_n_ittope => 6,
                                             p_n_sucdes => ln_sucdes,
                                             p_n_moneda => ln_moneda,
                                             p_n_papel  => ln_papel,
                                             p_n_saldo  => ln_salrem,
                                             p_n_salte  => ln_salter
                                             );
          end;                             
          ---obtenemos monto del rubro exonerado
          begin
            -- Call the procedure
            pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => P_N_PGCOD,
                                             p_n_ctnro  => ln_ctnro,
                                             p_n_itoper => ln_itoper,
                                             p_n_itsubo => ln_itsubo,
                                             p_n_sucdes => ln_sucdes,
                                             p_n_moneda => ln_moneda,
                                             p_n_papel  => ln_papel,
                                             p_n_monto  => ln_monrub
                                             );
          end;    
          --1 APLICARA PARA TRX DE EXCESO DE OPERACIONES y/o interplaza 2 APLICA PARA DESEMBOLSO Y ABONO DE INTERESES                   
          IF ln_tipasi = 1 THEN
                ln_modeb := ln_monto;
                if (ln_monrub + ln_salrem) >= ln_monto then
                   if ln_salrem >= ln_monto then
                       ln_modeb := 0;
                   else
                      ln_modeb := ln_monto - ln_salrem;
                   End If;
                else     
                   ln_modeb := ln_monrub;
                end if;  
                if P_N_ITMOD = 21 and P_N_ITTRAN = 905 then
                   ln_modeb := ln_monrub;                   
                End if;
          ELSE  
              -- verificar si el desembolso es de tipo consumo  va directo al rubro y si es hipotecario va el 30% al rubro
              --ln_modeb := pq_ah_comision.fn_ah_monto_desembolso(ln_r1mod, ln_r1tope, ln_monto);
              
              ln_modeb := 0;
              /*
              if ln_codseg = 1 then
                ln_modeb := 0;
              else
                ln_modeb := ln_monto;
              end if;      
              */
          END IF;
          
/*           Begin                              
              Update FSD016
                 set Itimp13 = ln_modeb  --LUCHO DEFINE EL IMPORTE CUAL SERA EL CAMPO itimpxx
               Where Pgcod  = P_N_PGCOD
                 and Itsuc  = P_N_ITSUC
                 and Itmod  = P_N_ITMOD
                 and Ittran = P_N_ITTRAN
                 and Itnrel = P_N_ITNREL
                 and Itord  = P_N_ITORD
                 and Itsbor = P_N_ITSBO;  
                 commit; 
           Exception
           When others then    
            null;
           end; */
           begin
              -- Call the procedure
              pq_ah_comision.sp_ah_graba_importe_asiento(p_n_pgcod  => P_N_PGCOD,
                                                         p_n_itsuc  => P_N_ITSUC,
                                                         p_n_itmod  => P_N_ITMOD,
                                                         p_n_ittran => P_N_ITTRAN,
                                                         p_n_itnrel => P_N_ITNREL,
                                                         p_n_itord  => P_N_ITORD,
                                                         p_n_itsbo  => P_N_ITSBO,
                                                         p_n_monto  => ln_modeb
                                                         );
           end;           
     end if;  
     if  ln_tipasi = 0 then
         --obtenemos los datos del credito
              begin
                  select z.pgcod,
                         decode(z.modulo,426,22,z.modulo),
                         z.itsucd,
                         z.moneda,
                         z.papel,
                         z.ctnro,
                         z.itoper,
                         z.itsubo,
                         z.ittope
                    into ln_r1cod, 
                         ln_r1mod, 
                         ln_r1suc, 
                         ln_r1mda, 
                         ln_r1pap, 
                         ln_r1cta, 
                         ln_r1oper,
                         ln_r1sbop,
                         ln_r1tope
                    from fsd016 z
                   where z.Pgcod  = P_N_PGCOD
                     and z.Itsuc  = P_N_ITSUC
                     and z.Itmod  = P_N_ITMOD
                     and z.Ittran = P_N_ITTRAN
                     and z.Itnrel = P_N_ITNREL
                     and z.Itord  = ln_ordin1;
              exception 
              when others then       
                null;
 /*               lc_error := 'NO SE ENCONTRO DATOS DEL CREDITO';
                insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'FSD016',lc_error,trunc(sysdate));*/
              end;         
              
              if ln_r1mod = 116 then
                begin
                  select q.r2cod, 
                         q.r2mod, 
                         q.r2suc, 
                         q.r2mda, 
                         q.r2pap, 
                         q.r2cta, 
                         q.r2oper,
                         q.r2sbop,
                         q.r2tope
                    into ln_r1cod, 
                         ln_r1mod, 
                         ln_r1suc, 
                         ln_r1mda, 
                         ln_r1pap, 
                         ln_r1cta, 
                         ln_r1oper,
                         ln_r1sbop,
                         ln_r1tope
                    from fsr011 q 
                   where q.r1cod  = ln_r1cod 
                     and q.r1mod  = ln_r1mod 
                     and q.r1suc  = ln_r1suc 
                     and q.r1mda  = ln_r1mda 
                     and q.r1pap  = ln_r1pap 
                     and q.r1cta  = ln_r1cta 
                     and q.r1oper = ln_r1oper
                     and q.r1sbop = ln_r1sbop
                     and q.r1tope = ln_r1tope
                     and q.relcod = 46
                     and q.r2mod  = 117
                     and q.r2cod  = ln_r1cod
                     and q.r2cta  = ln_r1cta;
                exception 
                when others then
                   --ln_flag := 1;
                   null;
                end;
                
              End If;  
              -- obtenemos el monto de al linea de la fsd011 (ln_monto  )
              if ln_r1mod = 117 then  
                begin
                  select k.scsdo
                    into ln_monto 
                    from fsd011 k 
                   where k.pgcod  = ln_r1cod
                     and k.scmod  = ln_r1mod
                     and k.scsuc  = ln_r1suc
                     and k.scmda  = ln_r1mda
                     and k.scpap  = ln_r1pap
                     and k.sccta  = ln_r1cta
                     and k.scoper = ln_r1oper
                     and k.scsbop = ln_r1sbop
                     and k.sctope = ln_r1tope;
                exception
                when others then
                     ln_monto := 0;
                end; 
              end if;                             
              if ln_ittope = 9 then
              begin
                 update fsr011 X
                    set r011fc = P_D_FECPRO,
                        R1RUB  = R1RUB - ln_monto*100/*,
                        r011co = decode(R1RUB - ln_monto*100,0,'N','S')*/
                  where R1COD  = ln_r1cod
                    and R1MOD  = ln_r1mod 
                    and R1SUC  = ln_r1suc 
                    and R1MDA  = ln_r1mda 
                    and R1PAP  = ln_r1pap 
                    and R1CTA  = ln_r1cta 
                    and R1OPER = ln_r1oper
                    and R1SBOP = ln_r1sbop 
                    and R1TOPE = ln_r1tope
                    and RELCOD = 200
                    and R2MOD  = ln_modulo
                    and R2CTA  = ln_ctnro
                    and R2OPER = ln_itoper
                    and R2SBOP = ln_itsubo
                    and R2TOPE = ln_ittope;
                    
               --                                        
               --Adicionamos registro de bolsa producto del desembolso
               --
                  -- Call the procedure
                  pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => P_D_FECPRO,
                                                   p_n_pgcod  => ln_r1cod,
                                                   p_n_modulo => ln_modulo,
                                                   p_n_sucdes => ln_sucdes,
                                                   p_n_moneda => ln_moneda,
                                                   p_n_papel  => ln_papel,
                                                   p_n_ctnro  => ln_ctnro,
                                                   p_n_itoper => ln_itoper,
                                                   p_n_itsubo => ln_itsubo,
                                                   p_n_ittope => ln_ittope,
                                                   p_c_tiptrx => 'A',
                                                   p_n_monmov => 0,
                                                   p_n_montem => ln_monto,
                                                   p_n_pgemp  => P_N_PGCOD, 
                                                   p_n_itsuc  => P_N_ITSUC,
                                                   p_n_itmod  => P_N_ITMOD, 
                                                   p_n_ittran => P_N_ITTRAN,
                                                   p_n_itnrel => P_N_ITNREL,
                                                   p_n_itnord => P_N_ITORD
                                                   );                       
              exception
              when others then
                  null;
/*                  lc_error := sqlerrm;
                  insert into LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR) VALUES(111,'FSR011',lc_error,trunc(sysdate));
*/                 -- commit;
              end;
              end if;
     end if;
     --REDUCIR LA BOLSA POR EL MONTO DEL DESEMBOLSO DEL CREDITO CANCELADO
     if  ln_tipasi = 99 then     
              begin
                  select z.pgcod,
                         decode(z.modulo,426,22,z.modulo),
                         z.itsucd,
                         z.moneda,
                         z.papel,
                         z.ctnro,
                         z.itoper,
                         z.itsubo,
                         z.ittope
                    into ln_r1cod, 
                         ln_r1mod, 
                         ln_r1suc, 
                         ln_r1mda, 
                         ln_r1pap, 
                         ln_r1cta, 
                         ln_r1oper,
                         ln_r1sbop,
                         ln_r1tope
                    from fsd016 z
                   where z.Pgcod  = P_N_PGCOD
                     and z.Itsuc  = P_N_ITSUC
                     and z.Itmod  = P_N_ITMOD
                     and z.Ittran = P_N_ITTRAN
                     and z.Itnrel = P_N_ITNREL
                     and z.Itord  = ln_ordin1;
              exception 
              when others then   
                null;
              end;
              
              --ylozada 22/05/2019
              if ln_r1mod = 117 then --si es linea la que esta cancelando verificar si ya se bajo la bolsa por vencimiento
                  begin
                    Select 'N' 
                      into lc_cancel
                      from aqpa102 a 
                     where a.aqpa102pgc = ln_r1cod
                       and a.aqpa102mod = ln_r1mod
                       and a.aqpa102mda = ln_r1mda
                       and a.aqpa102pap = ln_r1pap
                       and a.aqpa102cta = ln_r1cta
                       and a.aqpa102ope = ln_r1oper
                       and a.aqpa102sbo = ln_r1sbop
                       and a.aqpa102top = ln_r1tope;
                  exception
                  when others then  
                    lc_cancel := 'S' ;
                  end;                
              Else  
                 lc_cancel := 'S' ;
              End If;
              --fin
              
              /*
              --verificamos que el credito este en estado cancelado
              begin
                select 'S'
                  into lc_cancel 
                  from fsd011 k 
                 where k.pgcod  = ln_r1cod
                   and k.scmod  = ln_r1mod
                   and k.scsuc  = ln_r1suc
                   and k.scmda  = ln_r1mda
                   and k.scpap  = ln_r1pap
                   and k.sccta  = ln_r1cta
                   and k.scoper = ln_r1oper
                   and k.scsbop = ln_r1sbop
                   and k.sctope = ln_r1tope
                   and k.scstat = 99;
              exception
              when others then
                   lc_cancel := 'N';
              end;  
              */   
              
              if lc_cancel = 'S' then            
                  for i in c_cuentas(ln_r1cod, 
                                     ln_r1mod,                                  
                                     ln_r1mda, 
                                     ln_r1pap, 
                                     ln_r1cta, 
                                     ln_r1oper,
                                     ln_r1sbop,
                                     ln_r1tope
                                     ) loop

                   --                                        
                   --Debitamos de la bolsa
                   --
                      -- Call the procedure
                      pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => P_D_FECPRO,
                                                       p_n_pgcod  => i.r2cod,
                                                       p_n_modulo => i.r2mod,
                                                       p_n_sucdes => i.r2suc,
                                                       p_n_moneda => i.r2mda,
                                                       p_n_papel  => i.r2pap,
                                                       p_n_ctnro  => i.r2cta,
                                                       p_n_itoper => i.r2oper,
                                                       p_n_itsubo => i.r2sbop,
                                                       p_n_ittope => i.r2tope,
                                                       p_c_tiptrx => 'D',
                                                       p_n_monmov => 0,
                                                       p_n_montem => i.saldo,
                                                       p_n_pgemp  => P_N_PGCOD, 
                                                       p_n_itsuc  => P_N_ITSUC,
                                                       p_n_itmod  => P_N_ITMOD, 
                                                       p_n_ittran => P_N_ITTRAN,
                                                       p_n_itnrel => P_N_ITNREL,
                                                       p_n_itnord => P_N_ITORD
                                                       );                                    
                  end loop; 
              end if;                        
     End If;  
      --AUMENTAR LA BOLSA POR EL EXTORNO DE LA OPERACION DE INTERPLAZA
     if  ln_tipasi = 98 then     
       --Buscamos los datos del asiento original      
        for i in c_original loop
          If i.Txreng   = 1 then
              ln_relori:= to_number(trim(i.Txtext),'9,999,999.90');
          End If;
          If i.Txreng = 2 then
              ld_fecori := to_date(trim(i.Txtext),'dd/mm/rrrr');
          End If;      
        end loop;  
       
        ln_modori:= P_N_ITMOD - 500;                          
       --Obtenemos de la fsx016 el monto que se debito de la bolsa para regresarlo
       begin
          Select to_number(trim(a.txtord),'9,999,999.90')
            into ln_totdeb
            from fsx016 a 
           where a.pgcod  = P_N_PGCOD
             and a.hcmod  = ln_modori
             and a.hsucor = P_N_ITSUC
             and a.htran  = P_N_ITTRAN
             and a.hnrel  = ln_relori
             and a.hfcon  = ld_fecori
             and a.hcord  = P_N_ITORD
             and a.hcsubo = P_N_ITSBO
             and a.txcod  = 0
             and a.txoren = 999;
       exception
       when others then  
         ln_totdeb := 0;
       end;
       --ylozada 22/05/2019
        begin
            select z.pgcod,
                   decode(z.modulo,426,22,z.modulo),
                   z.itsucd,
                   z.moneda,
                   z.papel,
                   z.ctnro,
                   z.itoper,
                   z.itsubo,
                   z.ittope
              into ln_r1cod, 
                   ln_r1mod, 
                   ln_r1suc, 
                   ln_r1mda, 
                   ln_r1pap, 
                   ln_r1cta, 
                   ln_r1oper,
                   ln_r1sbop,
                   ln_r1tope
              from fsd016 z
             where z.Pgcod  = P_N_PGCOD
               and z.Itsuc  = P_N_ITSUC
               and z.Itmod  = P_N_ITMOD
               and z.Ittran = P_N_ITTRAN
               and z.Itnrel = P_N_ITNREL
               and z.Itord  = ln_ordin1;
        exception 
        when others then   
          null;
        end;       
        if ln_r1mod = 117 then --si es linea la que esta extornando la cancelacion verificar si bajo la bolsa por vencimiento
            begin
              Select 'N' 
                into lc_cancel
                from aqpa102 a 
               where a.aqpa102pgc = ln_r1cod
                 and a.aqpa102mod = ln_r1mod
                 and a.aqpa102mda = ln_r1mda
                 and a.aqpa102pap = ln_r1pap
                 and a.aqpa102cta = ln_r1cta
                 and a.aqpa102ope = ln_r1oper
                 and a.aqpa102sbo = ln_r1sbop
                 and a.aqpa102top = ln_r1tope;
            exception
            when others then  
              lc_cancel := 'S' ;
            end;                
        Else  
           lc_cancel := 'S' ;
        End If;        
       -- fin
       if lc_cancel = 'S' then
       --                                        
       -- Aumentamos  la bolsa
       --
          -- Call the procedure
          pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => ld_fecori,
                                           p_n_pgcod  => 1,
                                           p_n_modulo => ln_modulo,
                                           p_n_sucdes => ln_sucdes,
                                           p_n_moneda => ln_moneda,
                                           p_n_papel  => ln_papel,
                                           p_n_ctnro  => ln_ctnro,
                                           p_n_itoper => ln_itoper,
                                           p_n_itsubo => ln_itsubo,
                                           p_n_ittope => ln_ittope,
                                           p_c_tiptrx => 'D',
                                           p_n_monmov => 0,
                                           p_n_montem => ln_totdeb,
                                           p_n_pgemp  => P_N_PGCOD, 
                                           p_n_itsuc  => P_N_ITSUC,
                                           p_n_itmod  => P_N_ITMOD, 
                                           p_n_ittran => P_N_ITTRAN,
                                           p_n_itnrel => P_N_ITNREL,
                                           p_n_itnord => P_N_ITORD
                                           );       
      End If;                                                                     
     End If;  
  Exception
  When others then
    null;
  end sp_ah_monto_asiento;                                             
  Function fn_ah_monto_opemes(P_N_CODCOM IN NUMBER,
                              P_N_PGCOD  IN NUMBER,
                              P_N_CTNRO  IN NUMBER,
                              P_N_ITOPER IN NUMBER,
                              P_N_ITSUBO IN NUMBER, 
                              P_N_SUCDES IN NUMBER,
                              P_N_ITTOPE IN NUMBER,
                              P_N_MODULO IN NUMBER,
                              P_N_MONEDA IN NUMBER,
                              P_N_PAPEL  IN NUMBER
                              ) return number is
  ld_fecini date;
  ld_fecfin date;
  ln_totmov number(10):=0;
  ln_totdia number(17,2):=0;
  ln_tothis number(17,2):=0;
  ln_totoff number(17,2):=0;
  lc_indoff char(1);
  ld_fecsis date;
  begin
  
  select opgval into lc_indoff from fst200 where opgcod=544;  
  select pgfape into ld_fecsis from fst017 where pgcod=1;
  
  if lc_indoff = 'S' Then --online
     If ld_fecsis = trunc(sysdate) Then
               
        If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then        
            ln_totdia := pq_ah_comision.fn_ah_mov_dia_com(p_n_codcom => P_N_CODCOM,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          --p_n_ittope => P_N_ITTOPE,
                                                          --p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL
                                                          );   
        Else
            ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
            ld_fecfin := ld_fecsis - 1;                                                                 
            ln_totdia := pq_ah_comision.fn_ah_mov_dia_com(p_n_codcom => P_N_CODCOM,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          --p_n_ittope => P_N_ITTOPE,
                                                          --p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL
                                                          );   
                 
            ln_tothis := pq_ah_comision.fn_ah_mov_his_com(p_n_codcom => P_N_CODCOM,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          --p_n_ittope => P_N_ITTOPE,
                                                          --p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL,
                                                          p_d_fecini => ld_fecini,
                                                          p_d_fecfin => ld_fecfin
                                                          );   
       End If;                                                          
     Else
       If pq_ah_comision.fn_ah_ind_data = 'N' then --NO hay data en el diario
          ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
          ld_fecfin := ld_fecsis;                                       
          ln_tothis := pq_ah_comision.fn_ah_mov_his_com(p_n_codcom => P_N_CODCOM,
                                                        p_n_pgcod  => P_N_PGCOD,
                                                        p_n_ctnro  => P_N_CTNRO,
                                                        p_n_itoper => P_N_ITOPER,
                                                        p_n_itsubo => P_N_ITSUBO,
                                                        p_n_sucdes => P_N_SUCDES,
                                                        --p_n_ittope => P_N_ITTOPE,
                                                        --p_n_modulo => P_N_MODULO,
                                                        p_n_moneda => P_N_MONEDA,
                                                        p_n_papel  => P_N_PAPEL,
                                                        p_d_fecini => ld_fecini,
                                                        p_d_fecfin => ld_fecfin
                                                        );                      
       Else
          If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then            
              ln_totdia := pq_ah_comision.fn_ah_mov_dia_com(p_n_codcom => P_N_CODCOM,
                                                            p_n_pgcod  => P_N_PGCOD,
                                                            p_n_ctnro  => P_N_CTNRO,
                                                            p_n_itoper => P_N_ITOPER,
                                                            p_n_itsubo => P_N_ITSUBO,
                                                            p_n_sucdes => P_N_SUCDES,
                                                            --p_n_ittope => P_N_ITTOPE,
                                                            --p_n_modulo => P_N_MODULO,
                                                            p_n_moneda => P_N_MONEDA,
                                                            p_n_papel  => P_N_PAPEL
                                                            );    
                                                    
          Else
              ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
              ld_fecfin := ld_fecsis - 1;      
              ln_totdia := pq_ah_comision.fn_ah_mov_dia_com(p_n_codcom => P_N_CODCOM,
                                                            p_n_pgcod  => P_N_PGCOD,
                                                            p_n_ctnro  => P_N_CTNRO,
                                                            p_n_itoper => P_N_ITOPER,
                                                            p_n_itsubo => P_N_ITSUBO,
                                                            p_n_sucdes => P_N_SUCDES,
                                                            --p_n_ittope => P_N_ITTOPE,
                                                            --p_n_modulo => P_N_MODULO,
                                                            p_n_moneda => P_N_MONEDA,
                                                            p_n_papel  => P_N_PAPEL
                                                            ); 
              ln_tothis := pq_ah_comision.fn_ah_mov_his_com(p_n_codcom => P_N_CODCOM,
                                                            p_n_pgcod  => P_N_PGCOD,
                                                            p_n_ctnro  => P_N_CTNRO,
                                                            p_n_itoper => P_N_ITOPER,
                                                            p_n_itsubo => P_N_ITSUBO,
                                                            p_n_sucdes => P_N_SUCDES,
                                                            --p_n_ittope => P_N_ITTOPE,
                                                            --p_n_modulo => P_N_MODULO,
                                                            p_n_moneda => P_N_MONEDA,
                                                            p_n_papel  => P_N_PAPEL,
                                                            p_d_fecini => ld_fecini,
                                                            p_d_fecfin => ld_fecfin
                                                            );   
          End If;                                                               
       End If;
    End If;            
  Else
     If pq_ah_comision.fn_ah_ind_data = 'S' Then --SI HAY DATA EN EL DIARIO
        If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then   
            ln_totdia := pq_ah_comision.fn_ah_mov_dia_com(p_n_codcom => P_N_CODCOM,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          --p_n_ittope => P_N_ITTOPE,
                                                          --p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL
                                                          );    
        Else 
            ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
            ld_fecfin := ld_fecsis - 1;       
            ln_totdia := pq_ah_comision.fn_ah_mov_dia_com(p_n_codcom => P_N_CODCOM,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          --p_n_ittope => P_N_ITTOPE,
                                                          --p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL
                                                          );                 
            ln_tothis := pq_ah_comision.fn_ah_mov_his_com(p_n_codcom => P_N_CODCOM,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          --p_n_ittope => P_N_ITTOPE,
                                                          --p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL,
                                                          p_d_fecini => ld_fecini,
                                                          p_d_fecfin => ld_fecfin
                                                          );    
                                            
            ln_totoff := pq_ah_comision.fn_ah_mov_off_com(p_n_codcom => P_N_CODCOM,
                                                          p_n_pgcod  => P_N_PGCOD,
                                                          p_n_ctnro  => P_N_CTNRO,
                                                          p_n_itoper => P_N_ITOPER,
                                                          p_n_itsubo => P_N_ITSUBO,
                                                          p_n_sucdes => P_N_SUCDES,
                                                          p_n_ittope => P_N_ITTOPE,
                                                          p_n_modulo => P_N_MODULO,
                                                          p_n_moneda => P_N_MONEDA,
                                                          p_n_papel  => P_N_PAPEL,
                                                          p_d_fecpro => trunc(sysdate)
                                                          );
        End If;                                                                                                         
     Else
        ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
        ld_fecfin := ld_fecsis;      
        ln_tothis := pq_ah_comision.fn_ah_mov_his_com(p_n_codcom => P_N_CODCOM,
                                                      p_n_pgcod  => P_N_PGCOD,
                                                      p_n_ctnro  => P_N_CTNRO,
                                                      p_n_itoper => P_N_ITOPER,
                                                      p_n_itsubo => P_N_ITSUBO,
                                                      p_n_sucdes => P_N_SUCDES,
                                                      --p_n_ittope => P_N_ITTOPE,
                                                      --p_n_modulo => P_N_MODULO,
                                                      p_n_moneda => P_N_MONEDA,
                                                      p_n_papel  => P_N_PAPEL,
                                                      p_d_fecini => ld_fecini,
                                                      p_d_fecfin => ld_fecfin
                                                      );    
                                            
        ln_totoff := pq_ah_comision.fn_ah_mov_off_com(p_n_codcom => P_N_CODCOM,
                                                      p_n_pgcod  => P_N_PGCOD,
                                                      p_n_ctnro  => P_N_CTNRO,
                                                      p_n_itoper => P_N_ITOPER,
                                                      p_n_itsubo => P_N_ITSUBO,
                                                      p_n_sucdes => P_N_SUCDES,
                                                      p_n_ittope => P_N_ITTOPE,
                                                      p_n_modulo => P_N_MODULO,
                                                      p_n_moneda => P_N_MONEDA,
                                                      p_n_papel  => P_N_PAPEL,
                                                      p_d_fecpro => trunc(sysdate)
                                                      );              
     End If;   
  End If;                                            
  ln_totmov := ln_totdia + ln_tothis + ln_totoff;    
  return ln_totmov;  
  end fn_ah_monto_opemes;
  Function fn_ah_mov_dia_com(P_N_CODCOM IN NUMBER,
                             P_N_PGCOD  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_SUCDES IN NUMBER,
                             --P_N_ITTOPE IN NUMBER,
                             --P_N_MODULO IN NUMBER,
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER
                             ) return number is
  ln_totdia number(17,2):=0;                         
  ln_rubro  number(16);
  begin
   -- obtenemos rubro de exoneración           
     begin
         select to_number(trim(a.tp1desc))
           into ln_rubro
           from fst198 a 
          where a.tp1cod   = P_N_PGCOD
            and a.tp1cod1  = 10825
            and a.tp1corr1 = 33
            and a.tp1corr2 = 2
            and a.tp1nro1  = P_N_MONEDA;
     exception
     when others then            
       ln_rubro := 0;
     end; 
       
      if P_N_CODCOM = 1 then --exceos de operaciones      
      --diario
        Begin                         
            select nvl(sum(
                           case
                             when b.tp1imp1 = -1 and f.rubro <>ln_rubro then
                                  -1*f.itimp1
                             when b.tp1imp1 = -1 and f.rubro = ln_rubro then  
                                  f.itimp1
                             when b.tp1imp1 >=  1 and f.rubro = ln_rubro then
                                  -1*f.itimp1 
                             else
                                  itimp1
                             end    
                          ),0)
              into ln_totdia
              from fsd016 f, 
                   fsd015 h, 
                   fst198 b
             where f.pgcod    = P_N_PGCOD
               and f.ctnro    = P_N_CTNRO
               and f.itoper   = P_N_ITOPER
               and f.itsubo   = P_N_ITSUBO
               --and f.modulo   = P_N_MODULO
               and f.itsucd   = P_N_SUCDES
               --and f.ittope   = P_N_ITTOPE
               and f.moneda   = P_N_MONEDA
               and f.papel    = P_N_PAPEL
               and h.pgcod    = f.pgcod
               and f.pgcod    = b.tp1cod
               and h.itmod    = f.itmod
               and f.itmod    = b.TP1NRO1
               and h.itsuc    = f.itsuc
               and h.ittran   = f.ittran
               and f.ittran   = b.TP1NRO2
               and h.itnrel   = f.itnrel
               and f.itord    = b.tp1nro3
               and f.ittope   in (1,3,8,9,0)--agregar el tipo 9
               and f.modulo   in (21,174) 
               and b.tp1cod   = 1
               and b.tp1cod1  = 10825
               and b.tp1corr1 = 7 --guia de ordinales x mod/trx
               and h.itcorr   <> 99
               and h.itcont = 'S';                                
        Exception
        When others then
             ln_totdia := 0;         
        End;   
    else
      Begin                         
            select nvl(sum(
                           case
                             when f6.itmod = 66 and f6.ittran = 25 and f6.rubro <>ln_rubro then
                                  -1*f6.itimp1
                             when f6.itmod = 66 and f6.ittran = 25 and f6.rubro = ln_rubro then  
                                  f6.itimp1
                             when (f6.itmod <> 66 or f6.ittran <> 25) and f6.rubro = ln_rubro then
                                  -1*f6.itimp1 
                             else
                                  f6.itimp1 
                             end    
                          ),0)                      
              into ln_totdia                      
              from fsd016 f6,
                   fst198 f8,
                   fsd015 f5
             where f8.tp1cod   = 1
               and f6.pgcod    = f8.tp1cod
               and f6.itmod    = f8.tp1nro1
               and f6.ittran   = f8.tp1nro2
               and f6.itord    = f8.tp1nro3
               and f8.tp1cod1  = 10884
               and f8.TP1CORR1 = 3
               and f8.TP1CORR2 = 1
--               and f6.modulo   = P_N_MODULO
--               and f6.ittope   = P_N_ITTOPE
               and f6.modulo   in (21,174)
               and f6.ittope   in (1,3,8,9,0)
               and f6.itsucd   = P_N_SUCDES
               and f6.moneda   = P_N_MONEDA
               and f6.papel    = P_N_PAPEL       
               --and f6.itimp3   <> 0.00 
               and f6.pgcod    = P_N_PGCOD   
               and f6.ctnro    = P_N_CTNRO
               and f6.itoper   = P_N_ITOPER
               and f6.itsubo   = P_N_ITSUBO
               and f5.itsuc    = f6.itsuc
               and f5.itmod    = f6.itmod
               and f5.ittran   = f6.ittran
               and f5.itnrel   = f6.itnrel
               and f5.itcorr   <> 99
               and f5.itcont   = 'S'
               --and (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itimp3) <>(select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd )
               and f8.tp1imp2  = 1
               ;                              
        Exception
        When others then
             ln_totdia := 0;         
        End;         
    end if;    
  return ln_totdia;   
  end fn_ah_mov_dia_com;
  Function fn_ah_mov_his_com(P_N_CODCOM IN NUMBER,
                             P_N_PGCOD  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_SUCDES IN NUMBER,
                             --P_N_ITTOPE IN NUMBER,
                             --P_N_MODULO IN NUMBER,
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER,
                             P_D_FECINI IN DATE,
                             P_D_FECFIN IN DATE
                             ) return number is
  ln_tothis number(17,2):=0; 
  ln_rubro  number(16);                       
  begin
   -- obtenemos rubro de exoneración           
     begin
         select to_number(trim(a.tp1desc))
           into ln_rubro
           from fst198 a 
          where a.tp1cod   = P_N_PGCOD
            and a.tp1cod1  = 10825
            and a.tp1corr1 = 33
            and a.tp1corr2 = 2
            and a.tp1nro1  = P_N_MONEDA;
     exception
     when others then            
       ln_rubro := 0;
     end;    
     --historico
     If P_N_CODCOM = 1 then --exceso de operaciones
          Begin               
                select nvl(sum(
                               case
                                 when b.tp1imp1 = -1 and f.hrubro <>ln_rubro then
                                      -1*f.hcimp1
                                 when b.tp1imp1 = -1 and f.hrubro = ln_rubro then  
                                      f.hcimp1
                                 when b.tp1imp1 >=  1 and f.hrubro = ln_rubro then
                                      -1*f.hcimp1 
                                 else
                                      f.hcimp1
                                 end    
                              ),0)                
                  into ln_tothis
                  from fsh016 f,
                       fsh015 h,
                       fst198 b
                 where f.pgcod    = P_N_PGCOD
                   and f.hcta     = P_N_CTNRO
                   and f.hoper    = P_N_ITOPER
                   and f.hsubop   = P_N_ITSUBO
                   --and f.hmodul   = P_N_MODULO
                   and f.hsucur   = P_N_SUCDES
                   --and f.htoper   = P_N_ITTOPE
                   and f.hmda     = P_N_MONEDA
                   and f.hpap     = P_N_PAPEL
                   and h.pgcod    = f.pgcod
                   and f.pgcod    = b.tp1cod
                   and h.hcmod    = f.hcmod
                   and f.hcmod    = b.TP1NRO1 
                   and h.hsucor   = f.hsucor
                   and h.htran    = f.htran
                   and f.htran    = b.TP1NRO2
                   and h.hnrel    = f.hnrel
                   and f.hcord    = b.tp1nro3     
                   and h.hfcon    = f.hfcon
                   and f.htoper   in (1,3,8,9,0)--= a.TP1NRO3
                   and f.hmodul   in (21,174)--a.TP1CORR3
                   and b.tp1cod   = 1 
                   and b.tp1cod1  = 10825 
                   and b.tp1corr1 = 7   --guia de ordinales x mod/trx                    
                   and h.hccorr   <> 99
                   and f.hfcon between P_D_FECINI and P_D_FECFIN;
          Exception
          When others then
               ln_tothis := 0;         
          End;    
     else
          begin
             select nvl(sum(
                           case
                             when f.hcmod = 66 and f.htran = 25 and f.hrubro <>ln_rubro then
                                  -1*f.hcimp1
                             when f.hcmod = 66 and f.htran = 25 and f.hrubro = ln_rubro then  
                                  f.hcimp1
                             when (f.hcmod <> 66 or f.htran <> 25) and f.hrubro = ln_rubro then
                                  -1*f.hcimp1 
                             else
                                  f.hcimp1 
                             end    
                          ),0)                                        
              into ln_tothis                                      
              from fsh016 f,
                   fsh015 h,
                   fst198 f8
             where f8.tp1cod   = 1
               and f8.tp1cod1  = 10884
               and f8.TP1CORR1 = 3
               and f8.TP1CORR2 = 1
               and f.pgcod     = f8.tp1cod
               and f.hcmod     = f8.tp1nro1 --moduno
               and f.htran     = f8.tp1nro2 ---tranuno
               and f.hcord     = f8.tp1nro3 --orduno
               and f.hfcon     between P_D_FECINI and P_D_FECFIN ---ld_fecfin
               and f.pgcod     = P_N_PGCOD 
               --and f.hmodul    = P_N_MODULO
               --and f.htoper    = P_N_ITTOPE
               and f.hmodul   in (21,174)
               and f.htoper   in (1,3,8,9,0)               
               and f.hsucur    = P_N_SUCDES
               and f.hmda      = P_N_MONEDA
               and f.hpap      = P_N_PAPEL
               and f.hcta      = P_N_CTNRO
               and f.hoper     = P_N_ITOPER
               and f.hsubop    = P_N_ITSUBO
               --and f.hcimp3    <> 0.00
               and h.pgcod     = f.pgcod
               and h.hcmod     = f.hcmod
               and h.hsucor    = f.hsucor
               and h.htran     = f.htran
               and h.hnrel     = f.hnrel
               and h.hfcon     = f.hfcon
               and h.hccorr    <> 99          
               --and (select jaqy657pza  from jaqy657 where jaqy657suc = f.hcimp3) <> (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur )
               and f8.tp1imp2  = 1
               ;       
          Exception
          When others then
               ln_tothis := 0;         
          End;    
     end if; 
  return ln_tothis;    
  end fn_ah_mov_his_com;
  Function fn_ah_mov_off_com(P_N_CODCOM IN NUMBER,
                             P_N_PGCOD  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_SUCDES IN NUMBER,
                             P_N_ITTOPE IN NUMBER,
                             P_N_MODULO IN NUMBER,
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER,
                             P_D_FECPRO IN DATE
                             ) return number is
  ln_totoff number(17,2):=0;                         
  begin
    if P_N_CODCOM = 1 then --exceso de operaciones
        begin                       
          select nvl(sum(decode(z0e4gcesm,1,1* z0e4gcimd,-1*z0e4gcimd)),0)                    
            into ln_totoff
            from z0e4gc 
           where z0e4gcest = 'ZZ' 
             and z0e4gcesm in (1,3)
             and z0e4gctop in (1,2) 
             and z0e4gcfec = P_D_FECPRO
             and z0e4gcdpg = P_N_PGCOD
             and z0e4gcdmd = P_N_MODULO
             and z0e4gcdmo = P_N_MONEDA
             and z0e4gcdpa = P_N_PAPEL
             and z0e4gcdct = P_N_CTNRO
             and z0e4gcdop = P_N_ITOPER
             and z0e4gcdsc = P_N_ITSUBO
             and z0e4gcdto = P_N_ITTOPE
             and z0e4gcdsu = P_N_SUCDES;                                          
        Exception      
        When others then
             ln_totoff := 0;
        end;
    else
        select nvl(sum(decode(z1.z0e4gcesm,1,1* z1.z0e4gcimd,-1*z1.z0e4gcimd)),0)                    
          into ln_totoff
          from z0e4gc z1,
               z0e475 z2
         where z1.z0e4gcest = 'ZZ' 
           and z1.z0e4gcesm in (1,3)
           and z1.z0e4gctop in (1,2) 
           and z1.z0e4gcfec = P_D_FECPRO
           and z1.z0e4gcdpg = P_N_PGCOD
           and z1.z0e4gcdmd = P_N_MODULO
           and z1.z0e4gcdmo = P_N_MONEDA
           and z1.z0e4gcdpa = P_N_PAPEL
           and z1.z0e4gcdct = P_N_CTNRO
           and z1.z0e4gcdop = P_N_ITOPER
           and z1.z0e4gcdsc = P_N_ITSUBO
           and z1.z0e4gcdto = P_N_ITTOPE 
           and z1.z0e4gcdsu = P_N_SUCDES   
           and z2.z0e475cod = z1.z0e4gcter
           and (select jaqy657pza  from jaqy657 where jaqy657suc = z2.z0e475suc) <> (select jaqy657pza  from jaqy657 where jaqy657suc = z1.z0e4gcdsu );      
    end if;
    return ln_totoff;
  end fn_ah_mov_off_com;
  Function fn_ah_fec_ult_des(P_N_PGCOD  IN NUMBER,
                             P_N_MODULO IN NUMBER,
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_ITTOPE IN NUMBER,
                             P_N_SUCDES IN NUMBER
                             ) return date is
  ld_fecdes date;                                                          
  begin
    select nvl(max(a.r011fc),to_date('01/01/2001','dd/mm/rrrr')) 
     into ld_fecdes
     from fsr011 a 
    where a.r2cod  = P_N_PGCOD
      and a.r2mod  = P_N_MODULO 
      and a.r2cta  = P_N_CTNRO
      and a.r2oper = P_N_ITOPER
      and a.r2sbop = P_N_ITSUBO
      and a.r2suc  = P_N_SUCDES
      and a.r2mda  = P_N_MONEDA 
      and a.r2pap  = P_N_PAPEL
      and a.r2tope = P_N_ITTOPE
      and a.relcod = 200
      and a.r011co = 'S';
      
      return ld_fecdes;
  exception
  when others then                               
    ld_fecdes := to_date('01/01/2001','dd/mm/rrrr');
    return ld_fecdes;
  end fn_ah_fec_ult_des;  
  Procedure sp_ah_monto_AC(P_N_PGCOD   IN NUMBER,                                        
                           P_N_MODULO  IN NUMBER,                          
                           P_N_CTNRO   IN NUMBER,                           
                           P_N_ITOPER  IN NUMBER,                          
                           P_N_ITSUBO  IN NUMBER,                          
                           P_N_ITTOPE  IN NUMBER,                           
                           P_N_SUCDES  IN NUMBER,                          
                           P_N_MONEDA  IN NUMBER,                           
                           P_N_PAPEL   IN NUMBER,
                           P_D_FECPRO  IN DATE,
                           p_n_mtoexo out number
                           ) is
  cursor c_creditos is  
     select distinct b.pgcod, b.aocta, b.aooper, b.aomda, b.aopap, b.aofvto, b.aomod
       from fsr011 a, fsd010 b
      where a.r1cod  = b.pgcod
        and a.r1mod  = b.aomod
      --and a.r1suc  = b.aosuc
        and a.r1mda  = b.aomda
        and a.r1pap  = b.aopap
        and a.r1cta  = b.aocta
        and a.r1oper = b.aooper
        and a.r1sbop = b.aosbop
        and a.r1tope = b.aotope
        and a.relcod = 200
        and b.aostat <> 99
        and a.r2cod  = P_N_PGCOD
        and a.r2mod  = P_N_MODULO
        and a.r2cta  = P_N_CTNRO
        and a.r2oper = P_N_ITOPER
        and a.r2sbop = P_N_ITSUBO
        and a.r2tope = P_N_ITTOPE
        and a.r2suc  = P_N_SUCDES
        and a.r2mda  = P_N_MONEDA
        and a.r2pap  = P_N_PAPEL
        and a.r011co = 'S';
     
  ln_totsal number(17,2):=0;     
  ln_totdes number(17,2):=0;     

  begin     

      -- obtenemos los créditos vigentes que tiene esa cuenta cliente y el monto desmbolsado
      for i in c_creditos loop           
        begin
           select nvl(min(a.r1rub),0)/100
             into ln_totdes
             from fsr011 a
            where a.r1cod  = i.pgcod
              and a.r1mda  = i.aomda
              and a.r1pap  = i.aopap
              and a.r1cta  = i.aocta
              and a.r1oper = i.aooper
              and a.relcod = 200
              and a.r2cod  = P_N_PGCOD
              and a.r2mod  = P_N_MODULO
              and a.r2cta  = P_N_CTNRO
              and a.r2oper = P_N_ITOPER
              and a.r2sbop = P_N_ITSUBO
              and a.r2tope = P_N_ITTOPE
              and a.r2suc  = P_N_SUCDES
              and a.r2mda  = P_N_MONEDA
              and a.r2pap  = P_N_PAPEL
              and a.r1rub  > 0
              and a.r1rub  < 10000000000              
              and a.r011co = 'S';       
        exception
        when others then
             ln_totdes := 0;
        end; 
        if i.aomod = 117 then --linea de crédito
           if i.aofvto >= P_D_FECPRO then
             ln_totsal := ln_totsal + ln_totdes;        
           end if;                
        Else  
           ln_totsal := ln_totsal + ln_totdes;        
        End If;        
      end loop;  
      p_n_mtoexo := ln_totsal;           
  End sp_ah_monto_AC;
  Function fn_ah_monto_desembolso(P_N_MODULO IN NUMBER, 
                                  P_N_ITTOPE IN NUMBER, 
                                  P_N_MONTO  IN NUMBER
                                 ) return number is
  ln_flag   number(1):=0;
  ln_indhip number(1):=0;     
  ln_monto  number(17,2):=0;
  ln_porhip number(17,2):=0;
  begin
    -- verificamos guia especial de proceso para mod/tipo de creditos consumo e hipotecario
    begin
      select 1,tp1nro3
        into ln_flag, ln_indhip 
       from fst198 a 
      where a.tp1cod   = 1 
        and a.tp1cod1  = 10825 
        and a.tp1corr1 = 36
        and a.tp1imp1  = 1
        and a.tp1nro1  = P_N_MODULO
        and a.tp1nro2  = P_N_ITTOPE;
    exception
    when no_data_found then
      begin
        select 1,tp1nro3
          into ln_flag, ln_indhip 
         from fst198 b 
        where b.tp1cod   = 1 
          and b.tp1cod1  = 10825 
          and b.tp1corr1 = 36
          and b.tp1nro1  = P_N_MODULO   
          and b.tp1imp1  = 1     
          and b.tp1imp2  = 1;    --indicador de que contempla todo el modulo
        Exception
        when others then  
          ln_flag   := 0;
          ln_indhip := 0;          
        end;
    when too_many_rows then
      ln_flag   := 0;
      ln_indhip := 0;          
    end;
    
    if ln_indhip = 1 and ln_flag = 1 then  
       --obtenemos el porcentaje de exoneracion del hipotecario
        begin
          select a.tpimp
            into ln_porhip
            from fst098 a 
           where a.pgcod  = 1 
             and a.tpcod  = 7680 
             and a.tpcorr = 17 ;
        exception
        when others then
          ln_porhip := 0;       
        end;
        ln_monto := round(P_N_MONTO*ln_porhip,2);
        
    Elsif ln_flag = 1 then
        ln_monto := P_N_MONTO;
    Else
        ln_monto := 0;   
    End If;  
    return ln_monto;
  End fn_ah_monto_desembolso;
  Procedure sp_ah_graba_importe_asiento(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER,
                                        P_N_ITORD  IN NUMBER,
                                        P_N_ITSBO  IN NUMBER,
                                        P_N_MONTO  IN NUMBER
                                        ) IS
  PRAGMA AUTONOMOUS_TRANSACTION;                                                                      
  begin
        Update FSD016
           set Itimp13 = P_N_MONTO  --LUCHO DEFINE EL IMPORTE CUAL SERA EL CAMPO itimpxx
         Where Pgcod  = P_N_PGCOD
           and Itsuc  = P_N_ITSUC
           and Itmod  = P_N_ITMOD
           and Ittran = P_N_ITTRAN
           and Itnrel = P_N_ITNREL
           and Itord  = P_N_ITORD
           and Itsbor = P_N_ITSBO;  
           commit;     
  exception
  when others then
    null;  
  end sp_ah_graba_importe_asiento;
  Procedure sp_ah_graba_importe_comisio(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER,
                                        P_N_ITORD  IN NUMBER,
                                        P_N_ITSBO  IN NUMBER,
                                        P_N_MONTO1 IN NUMBER,
                                        P_N_MONTO2 IN NUMBER
                                        ) IS
  PRAGMA AUTONOMOUS_TRANSACTION;                                                                      
  begin
        Update FSD016
           set Itimp12 = P_N_MONTO1,  
               Itimp4  = P_N_MONTO2  
         Where Pgcod  = P_N_PGCOD
           and Itsuc  = P_N_ITSUC
           and Itmod  = P_N_ITMOD
           and Ittran = P_N_ITTRAN
           and Itnrel = P_N_ITNREL
           and Itord  = P_N_ITORD
           and Itsbor = P_N_ITSBO;  
           commit;     
  exception
  when others then
    null;  
  end sp_ah_graba_importe_comisio;  
  
  Procedure sp_valida_edad_18_25(P_N_CODPGC IN NUMBER,
                                 P_N_NUMCTA IN NUMBER,
                                 p_c_valida out varchar2,             
                                 p_d_fecfin out date
                                ) is
  cursor c_integrantes is
    select * 
      from fsr008 a 
     where a.pgcod = P_N_CODPGC 
       and a.ctnro = P_N_NUMCTA
       and a.ttcod = 1;
       
  ld_fecpro date;
  ld_fecnac date;
  ln_integrantes number(1):=0;
  begin
  p_c_valida := 'N';
      begin
        select a.pgfape 
          into ld_fecpro 
          from fst017 a 
         where a.pgcod = P_N_CODPGC;
      exception
      when others then
           ld_fecpro := trunc(sysdate);
      end;     
      begin
        select nvl(count(a.pgcod),0) 
          into ln_integrantes
          from fsr008 a 
         where a.pgcod = P_N_CODPGC 
           and a.ctnro = P_N_NUMCTA;
      exception
      when others then
        ln_integrantes := 0;
      end;            

      if ln_integrantes = 1 then
          For i in c_integrantes loop

              --obtenemos fecha de nacimiento
              begin
                select x.pffnac 
                  into ld_fecnac 
                  from fsd002 x,
                       fsd001 y 
                 where x.pfpais = y.pepais
                   and x.pftdoc = y.petdoc
                   and x.pfndoc = y.pendoc
                   and x.pfpais = i.pepais 
                   and x.pftdoc = i.petdoc
                   and x.pfndoc = i.pendoc
                   and y.petipo = 'F';
              exception
              when others then     
                 ld_fecnac := null; 
                 p_c_valida := 'N'; 
                 return;
              end;
              if ld_fecnac is not null then
                begin
                    select case
                         when months_between(ld_fecpro,ld_fecnac) >=  216 and months_between(ld_fecpro,ld_fecnac) < 312 then
                              'S'
                         when months_between(ld_fecpro,ld_fecnac) < 216 then
                              'N' -- < 216 MESES SIGNIFICA QUE ES MENOR DE EDAD NO DEBE DE CONSIDERARSE
                         else
                              'N'
                         end entre_18_y_25
                    into p_c_valida 
                    from dual;        
                exception
                when others then    
                  p_c_valida := 'N';
                end;  
              else 
                 p_c_valida := 'N'; 
                 return;            
              end if;
              
              if  p_c_valida = 'N' then
                  exit;
                  return;
              End If;
          End loop;
          if p_c_valida = 'S' then
             p_d_fecfin := add_months(ld_fecnac,312)-1;
          End if;
      End if;      
  end sp_valida_edad_18_25;  
  Procedure sp_ah_saldos_remu(P_N_PGCOD   IN NUMBER,                                        
                             P_N_MODULO  IN NUMBER,                          
                             P_N_CTNRO   IN NUMBER,                           
                             P_N_ITOPER  IN NUMBER,                          
                             P_N_ITSUBO  IN NUMBER,                          
                             P_N_ITTOPE  IN NUMBER,                           
                             P_N_SUCDES  IN NUMBER,                          
                             P_N_MONEDA  IN NUMBER,                           
                             P_N_PAPEL   IN NUMBER,
                             p_n_saldo   out number,
                             p_n_salte   out number
                             ) is
  ln_saldo number(17,2);    
  ln_salte number(17,2);                            
  ln_salto number(17,2);                            
  begin
      begin
      /*  select a.jaqz157sdo
          into ln_saldo 
          from JAQZ157 a
         where a.jaqz157pgc = P_N_PGCOD
           and a.jaqz157mod = P_N_MODULO
           and a.jaqz157suc = P_N_SUCDES
           and a.jaqz157mda = P_N_MONEDA
           and a.jaqz157pap = P_N_PAPEL
           and a.jaqz157cta = P_N_CTNRO 
           and a.jaqz157ope = P_N_ITOPER
           and a.jaqz157sbo = P_N_ITSUBO
           and a.jaqz157tpo = P_N_ITTOPE;*/
           
           select a.iarssaldo
             into ln_saldo 
             from iar001 a
            where a.iarspgcod = P_N_PGCOD
              and a.iarsmod   = P_N_MODULO
              and a.iarssuc   = P_N_SUCDES
              and a.iarscta   = P_N_CTNRO
              and a.iarsscta  = P_N_ITSUBO
              and a.iarssope  = P_N_ITOPER
              and a.iarstope  = P_N_ITTOPE
              and a.iarspap   = P_N_PAPEL
              and a.iarsmda   = P_N_MONEDA
              ;
                     
           p_n_saldo := ln_saldo;     
      exception
      when others then     
        ln_saldo := 0;
        p_n_saldo := ln_saldo;
      end; 
      
      --obtenemos saldo de la FSD011
      begin
        select a.scsdo
          into ln_salto
          from fsd011 a 
         where a.pgcod  = P_N_PGCOD
           and a.scsuc  = P_N_SUCDES
           and a.scmda  = P_N_MONEDA
           and a.scpap  = P_N_PAPEL
           and a.sccta  = P_N_CTNRO
           and a.scoper = P_N_ITOPER
           and a.scsbop = P_N_ITSUBO
           and a.sctope = P_N_ITTOPE
           and a.scmod  = P_N_MODULO;
      exception
      when others then     
        ln_salto := 0;
      end;  
      ln_salte  := ln_salto - ln_saldo;
      p_n_salte := ln_salte;
  exception
  when others then
    p_n_saldo := 0;
    p_n_salte := 0;    
  end sp_ah_saldos_remu;    
  /* 
  Procedure sp_ah_abm_remu(P_N_PGCOD  IN NUMBER,
                           P_N_ITSUC  IN NUMBER,
                           P_N_ITMOD  IN NUMBER, 
                           P_N_ITTRAN IN NUMBER,
                           P_N_ITNREL IN NUMBER,
                           P_N_ITORD  IN NUMBER,
                           P_N_ITSBO  IN NUMBER,
                           P_N_TIPRTE IN NUMBER,
                           p_c_cancel out varchar2
                           ) is
                    
  cursor c_importa(ld_fecpro in date) is
    select b.jaql72pgco ln_Pgcod, 
           b.jaql72scsu ln_Itsucd,
           b.jaql72scmo ln_Modulo,
           b.jaql72scmd ln_Moneda,
           b.jaql72scpa ln_Papel,
           b.jaql72scct ln_ctnro,
           b.jaql72scop ln_Itoper,
           b.jaql72scsb ln_Itsubo,
           b.jaql72scto ln_Ittope,
           b.jaql72impo ln_monto,
           a.jaql71tiab,
           a.jaql71fopa 
     from jaql071 a,
          jaql072 b
    where a.jaql71nuim = b.jaql72nuim
      and a.jaql71itcd = P_N_PGCOD 
      and a.jaql71itsu = P_N_ITSUC       
      and a.jaql71itmo = P_N_ITMOD 
      and a.jaql71ittr = P_N_ITTRAN
      and a.jaql71itre = P_N_ITNREL
      and a.jaql71itor = P_N_ITORD 
      and a.jaql71itsb = P_N_ITSBO 
      and a.jaql71itfc = ld_fecpro;  
      
  cursor c_importa_ext(PItfcon_ori in date,PItnrel_ori in number) is
    select b.jaql72pgco ln_Pgcod, 
           b.jaql72scsu ln_Itsucd,
           b.jaql72scmo ln_Modulo,
           b.jaql72scmd ln_Moneda,
           b.jaql72scpa ln_Papel,
           b.jaql72scct ln_ctnro,
           b.jaql72scop ln_Itoper,
           b.jaql72scsb ln_Itsubo,
           b.jaql72scto ln_Ittope,
           b.jaql72impo ln_monto,
           a.jaql71tiab,
           a.jaql71fopa            
     from jaql071 a,
          jaql072 b
    where a.jaql71nuim = b.jaql72nuim
      and a.jaql71itcd = P_N_PGCOD 
      and a.jaql71itsu = P_N_ITSUC       
      and a.jaql71itmo = P_N_ITMOD - 500 
      and a.jaql71ittr = P_N_ITTRAN
      and a.jaql71itre = PItnrel_ori
      and a.jaql71itfc = PItfcon_ori;           
      
 cursor c_trxori(ld_fecpro in date) is
    select a.* 
      from FSX015 a --: Textos obtenemos la trx original del abono
     Where a.PgCod  = P_N_PGCOD
       and a.Hcmod  = P_N_ITMOD
       and a.Hsucor = P_N_ITSUC
       and a.Htran  = P_N_ITTRAN
       and a.Hnrel  = P_N_ITNREL
       and a.Hfcon  = ld_fecpro
       and a.Txcod  = 0;       
                              
  ln_Pgcod   number(3);                              
  ln_ctnro   number(9);                             
  ln_Itoper  number(9);                             
  ln_Itsubo  number(3);                             
  ln_Itsucd  number(3);                             
  ln_Ittope  number(3);                             
  ln_Modulo  number(3);                             
  ln_Moneda  number(4);                             
  ln_Papel   number(4);   
    
  ln_monto     number(17,2);   
  ln_monap     number(17,2);   
  ln_montp     number(17,2);     
  ln_salrem    number(17,2);   
  ln_salter    number(17,2);   
  ln_itf       number(10,2):= 0;
 
  LN_TP1IMP1   number(17,2); 
  LN_TP1IMP2   number(17,2); 
  LN_TP1IMP3   number(17,2);          
  
  lc_indcob    char(1);   
  ld_fecpro    date;        
  ln_hcmod_o   number(3);
  ln_hnrel_o   number(4);                           
  ld_fecpro_o  date;        
  ln_itdbha    number(1);
  PItnrel_ori  number(4);
  PItfcon_ori  date;
  lc_indexo    varchar2(1):= 'N';
  
  begin
    p_c_cancel := 'N';
    --obtenemos fecha del sistema
    begin
      select a.pgfape 
        into ld_fecpro 
        from fst017 a 
       where a.pgcod = P_N_PGCOD;
    end;  
    
    --obtenemos los datos de la cuenta
    begin           
      select Pgcod,
             Ctnro,
             Itoper,
             Itsubo,
             Itsucd,
             Ittope,
             Modulo,
             Moneda,
             Papel,
             itimp1,
             itdbha
       into  ln_Pgcod, 
             ln_ctnro,
             ln_Itoper,
             ln_Itsubo,
             ln_Itsucd,
             ln_Ittope,
             ln_Modulo,
             ln_Moneda,
             ln_Papel,
             ln_monto,
             ln_itdbha
       from FSD016 
      Where Pgcod   = P_N_PGCOD
        and Itsuc   = P_N_ITSUC
        and Itmod   = P_N_ITMOD
        and Ittran  = P_N_ITTRAN
        and Itnrel  = P_N_ITNREL
        and Itord   = P_N_ITORD
        and Itsbor  = P_N_ITSBO;
    Exception
    When others then
      ln_Pgcod  := 0;       
      ln_ctnro  := 0;    
      ln_Itoper := 0;    
      ln_Itsubo := 0;    
      ln_Itsucd := 0;    
      ln_Ittope := 0;    
      ln_Modulo := 0;    
      ln_Moneda := 0;    
      ln_Papel  := 0;         
    End;  

    -- obtenemos los valores de la guia para verificar mod/trx y tipo remuneraciones
    Begin
       Select TP1IMP1, 
              TP1IMP2, 
              TP1IMP3
         into LN_TP1IMP1,  -- 1 = trx normal 2 = trx de extorno
              LN_TP1IMP2,  -- 1 = egreso 2 = ingreso
              LN_TP1IMP3   -- 1 =  trx de terceros 0 =  trx de remuneraciones 2 = trx remuneraciones batch 
         from fst198 
        where tp1cod      = 1 
          and tp1cod1     = 10825 
          and tp1corr1    = 41
          and TP1CORR3    = ln_Modulo
          and TP1NRO1     = P_N_ITMOD
          and TP1NRO2     = P_N_ITTRAN
          and TP1NRO3     = ln_Ittope;           
          lc_indcob := 'S';
    Exception
    When no_data_found then
         if P_N_TIPRTE = 3 then
            lc_indcob := 'S';
            ln_Modulo := 21;
            ln_Ittope := 6;            
         else  
            lc_indcob := 'N';
         end if;
    When others then
         lc_indcob := 'N';
    End;    
    
    if lc_indcob = 'S' then
      --obtenemos de la guía monto tope de saldo por terceros
      Begin
         Select nvl(TP1IMP1,0)--nvl(to_number(trim(TP1DESC),'999,999,999.90'),0)
           into ln_montp
           from fst198 
          where tp1cod      = 1 
            and tp1cod1     = 10825 
            and tp1corr1    = 40
            and TP1NRO1     = ln_Modulo
            and TP1NRO2     = ln_Ittope;
      Exception
      When others then
        ln_montp := 0;           
      End;       
          
      --obtenemos el monto actual de remuneraciones
      begin
        -- Call the procedure
        pq_ah_comision.sp_ah_saldos_remu(p_n_pgcod  => ln_Pgcod,
                                         p_n_modulo => ln_Modulo,
                                         p_n_ctnro  => ln_ctnro,
                                         p_n_itoper => ln_Itoper,
                                         p_n_itsubo => ln_Itsubo,
                                         p_n_ittope => ln_Ittope,
                                         p_n_sucdes => ln_Itsucd,
                                         p_n_moneda => ln_Moneda,
                                         p_n_papel  => ln_Papel,
                                         p_n_saldo  => ln_salrem,
                                         p_n_salte  => ln_salter
                                        );
      end;         
        if P_N_TIPRTE = 1 then --RTE PJAQZ184
            if LN_TP1IMP1 = 1 then --trx normal
                if LN_TP1IMP2 = 1 and ln_itdbha = 1 then --egreso
                    if ln_salrem >= ln_monto then       
                       ln_monap := ln_monto;
                       ln_itf   := 0;                                                   
                    else
                       ln_monap := ln_monto - ln_salrem;       
                       --calculamos el itf
                       ln_itf   := pq_ah_compensa_ctas.fn_calcula_itf(p_n_monto => ln_monap);                                          
                    end if;     
  
                    
                    --actualizamos el asiento                    
                    begin
                      if ln_itf > 0 then
                        begin
                          -- Call the function
                        lc_indexo := pq_ah_compensa_ctas.fn_cr_verexonera(p_n_pgcod  => ln_Pgcod,
                                                                          p_n_scmod  => ln_Modulo, 
                                                                          p_n_scsuc  => ln_Itsucd, 
                                                                          p_n_scmda  => ln_Moneda, 
                                                                          p_n_scpap  => ln_Papel,  
                                                                          p_n_sccta  => ln_ctnro,  
                                                                          p_n_scoper => ln_Itoper, 
                                                                          p_n_scsbop => ln_Itsubo, 
                                                                          p_n_sctope => ln_Ittope 
                                                                          );
                        end;         
                        if lc_indexo = 'N' then               
                          -- Call the procedure
                          pq_ah_comision.sp_ah_graba_monto_itf(p_n_pgcod  => P_N_PGCOD,
                                                               p_n_itsuc  => P_N_ITSUC,
                                                               p_n_itmod  => P_N_ITMOD,
                                                               p_n_ittran => P_N_ITTRAN,
                                                               p_n_itnrel => P_N_ITNREL,
                                                               p_n_itord  => P_N_ITORD,
                                                               p_n_itsbo  => P_N_ITSBO,
                                                               p_n_monto1 => ln_itf
                                                               );
                        end if;                                     
                      end if;                                                                                                  
                    end;  
                    
                else                                      
                   ln_monap := ln_monto;                     
                   if ln_itdbha = 2 then --ingreso
                      ln_itf   := pq_ah_compensa_ctas.fn_calcula_itf(p_n_monto => ln_monap);                             
                      --actualizamos el asiento                    
                      begin
                        if ln_itf > 0 then
                          begin
                            -- Call the function
                          lc_indexo := pq_ah_compensa_ctas.fn_cr_verexonera(p_n_pgcod  => ln_Pgcod,
                                                                            p_n_scmod  => ln_Modulo, 
                                                                            p_n_scsuc  => ln_Itsucd, 
                                                                            p_n_scmda  => ln_Moneda, 
                                                                            p_n_scpap  => ln_Papel,  
                                                                            p_n_sccta  => ln_ctnro,  
                                                                            p_n_scoper => ln_Itoper, 
                                                                            p_n_scsbop => ln_Itsubo, 
                                                                            p_n_sctope => ln_Ittope 
                                                                            );
                          end;         
                          if lc_indexo = 'N' then                               
                            -- Call the procedure
                            pq_ah_comision.sp_ah_graba_monto_itf(p_n_pgcod  => P_N_PGCOD,
                                                                 p_n_itsuc  => P_N_ITSUC,
                                                                 p_n_itmod  => P_N_ITMOD,
                                                                 p_n_ittran => P_N_ITTRAN,
                                                                 p_n_itnrel => P_N_ITNREL,
                                                                 p_n_itord  => P_N_ITORD,
                                                                 p_n_itsbo  => P_N_ITSBO,
                                                                 p_n_monto1 => ln_itf
                                                                 );
                          end if;                                                                 
                        end if;   
                       --debito masivo contra cuenta de remuneraciones analizar cuentas cliente origen y destino 
                       pq_ah_comision.sp_ah_analiza_integ_trans(p_n_pgcod  => P_N_PGCOD,
                                                                p_n_itsuc  => P_N_ITSUC,
                                                                p_n_itmod  => P_N_ITMOD,
                                                                p_n_ittran => P_N_ITTRAN,
                                                                p_n_itnrel => P_N_ITNREL,
                                                                p_n_itord  => 6,
                                                                p_n_itsbo  => 1,
                                                                p_n_ctadeb => ln_ctnro,
                                                                p_n_monto1 => ln_itf
                                                               );                                                                                                                                                 
                      end;                                                                                                   
                   End If;  
                   if LN_TP1IMP3 = 1 and ln_montp > 0 then --el ingreso es de transaccion de abono por terceros
                      if ln_monap + ln_salter > ln_montp then
                         p_c_cancel := 'S';
                         return;
                      End If;      
                   end if;                   
                end if;  
            end if;
        else --P_N_TIPRTE = 2 --RTE PJAQZ160
            If LN_TP1IMP1 = 1 then --trx normal 
               if LN_TP1IMP2 = 1 then --De egreso
                      if ln_salrem >= ln_monto then       
                         ln_monap := ln_monto;
                      else
                         ln_monap := ln_salrem;
                      end If;    
                       --actualizamos el monto a la tabla de saldos de remuneraciones              
                      begin
                        update JAQZ157 a 
                           set a.jaqz157ful = ld_fecpro,  
                               a.jaqz157sdo = a.jaqz157sdo - ln_monap
                         where a.jaqz157pgc = ln_Pgcod
                           and a.jaqz157mod = ln_Modulo
                           and a.jaqz157suc = ln_Itsucd
                           and a.jaqz157mda = ln_Moneda
                           and a.jaqz157pap = ln_Papel
                           and a.jaqz157cta = ln_ctnro
                           and a.jaqz157ope = ln_Itoper
                           and a.jaqz157sbo = ln_Itsubo
                           and a.jaqz157tpo = ln_Ittope;
                      end; 
                      
                      -- registramos en tabla de textos el monto que se afecto del saldo de remuneraciones para 
                      begin
                        insert into fsx015
                                    (pgcod,
                                     hcmod,
                                     hsucor,
                                     htran,
                                     hnrel,
                                     hfcon,
                                     txcod,
                                     txreng,
                                     txtext)
                                  values
                                    (P_N_PGCOD,
                                     P_N_ITMOD,
                                     P_N_ITSUC,
                                     P_N_ITTRAN,
                                     P_N_ITNREL,
                                     ld_fecpro,
                                     907, --monto remu
                                     1,
                                     ln_monap
                                     );
                      exception
                      when others then               
                        null;
                      end;                         
                      --actualizamos tabla de ITF TI0019 
                      begin                       
                        update ti0019 
                           set Timontoimp = ln_monto - ln_salrem
                         where Tipgcod = P_N_PGCOD
                           and Tipsuc  = P_N_ITSUC
                           and Timodt  = P_N_ITMOD
                           and Titrn   = P_N_ITTRAN
                           and Tifchc  = ld_fecpro
                           and Tinrel  = P_N_ITNREL
                           and Timontoimp = ln_monto;                                                      
                      exception
                      when others then  
                        null;
                      end;       
                      
                      begin                       
                        update ti0019 
                           set Tiimportet = ln_monto - ln_salrem
                         where Tipgcod = P_N_PGCOD
                           and Tipsuc  = P_N_ITSUC
                           and Timodt  = P_N_ITMOD
                           and Titrn   = P_N_ITTRAN
                           and Tifchc  = ld_fecpro
                           and Tinrel  = P_N_ITNREL
                           and Tiimportet = ln_monto;                                                      
                      exception
                      when others then  
                        null;                      
                      end;             
                                       
               Else--De ingreso
                 ln_monap := ln_monto;
                 case
                 when LN_TP1IMP3 = 0 then --significa que la trx es de remuneraciones 
                    
                    begin
                      --obtenemos el monto actual de remuneraciones
                      select a.jaqz157sdo
                        into ln_salrem
                        from JAQZ157 a 
                       where a.jaqz157pgc = ln_Pgcod
                         and a.jaqz157mod = ln_Modulo
                         and a.jaqz157suc = ln_Itsucd
                         and a.jaqz157mda = ln_Moneda
                         and a.jaqz157pap = ln_Papel
                         and a.jaqz157cta = ln_ctnro
                         and a.jaqz157ope = ln_Itoper
                         and a.jaqz157sbo = ln_Itsubo
                         and a.jaqz157tpo = ln_Ittope; 
                                
                      ln_salrem := ln_salrem + ln_monap;      
                          
                      update JAQZ157 a 
                         set a.jaqz157ful = ld_fecpro,  
                             a.jaqz157sdo = ln_salrem
                       where a.jaqz157pgc = ln_Pgcod
                         and a.jaqz157mod = ln_Modulo
                         and a.jaqz157suc = ln_Itsucd
                         and a.jaqz157mda = ln_Moneda
                         and a.jaqz157pap = ln_Papel
                         and a.jaqz157cta = ln_ctnro
                         and a.jaqz157ope = ln_Itoper
                         and a.jaqz157sbo = ln_Itsubo
                         and a.jaqz157tpo = ln_Ittope;                         
                    exception
                    when no_data_found then
                      begin
                        insert into JAQZ157(jaqz157pgc,  
                                            jaqz157mod,
                                            jaqz157suc,
                                            jaqz157mda,
                                            jaqz157pap,
                                            jaqz157cta,
                                            jaqz157ope,
                                            jaqz157sbo,
                                            jaqz157tpo,
                                            jaqz157ful,
                                            jaqz157sdo
                                            )
                                      values(ln_Pgcod,
                                             ln_Modulo,
                                             ln_Itsucd,
                                             ln_Moneda,
                                             ln_Papel,
                                             ln_ctnro,
                                             ln_Itoper,
                                             ln_Itsubo,
                                             ln_Ittope,
                                             ld_fecpro,
                                             ln_monap
                                            );
                      exception
                      when others then
                        null;                        
                      end;
                    end;                                                               
                 when LN_TP1IMP3 = 2 then --Abono batch 99/280
                    for i in c_importa(ld_fecpro) loop
                        if i.jaql71tiab = 'R' then
                          begin
                            --obtenemos el monto actual de remuneraciones
                            select a.jaqz157sdo
                              into ln_salrem
                              from JAQZ157 a 
                             where a.jaqz157pgc = ln_Pgcod
                               and a.jaqz157mod = ln_Modulo
                               and a.jaqz157suc = ln_Itsucd
                               and a.jaqz157mda = ln_Moneda
                               and a.jaqz157pap = ln_Papel
                               and a.jaqz157cta = ln_ctnro
                               and a.jaqz157ope = ln_Itoper
                               and a.jaqz157sbo = ln_Itsubo
                               and a.jaqz157tpo = ln_Ittope; 
                                  
                            ln_salrem := ln_salrem + i.ln_monto;      
                            
                            update JAQZ157 a 
                               set a.jaqz157ful = ld_fecpro,  
                                   a.jaqz157sdo = ln_salrem
                             where a.jaqz157pgc = ln_Pgcod
                               and a.jaqz157mod = ln_Modulo
                               and a.jaqz157suc = ln_Itsucd
                               and a.jaqz157mda = ln_Moneda
                               and a.jaqz157pap = ln_Papel
                               and a.jaqz157cta = ln_ctnro
                               and a.jaqz157ope = ln_Itoper
                               and a.jaqz157sbo = ln_Itsubo
                               and a.jaqz157tpo = ln_Ittope;                         
                          exception
                          when no_data_found then
                            begin
                              insert into JAQZ157(jaqz157pgc,  
                                                  jaqz157mod,
                                                  jaqz157suc,
                                                  jaqz157mda,
                                                  jaqz157pap,
                                                  jaqz157cta,
                                                  jaqz157ope,
                                                  jaqz157sbo,
                                                  jaqz157tpo,
                                                  jaqz157ful,
                                                  jaqz157sdo
                                                  )
                                            values(i.ln_Pgcod,
                                                   i.ln_Modulo,
                                                   i.ln_Itsucd,
                                                   i.ln_Moneda,
                                                   i.ln_Papel,
                                                   i.ln_ctnro,
                                                   i.ln_Itoper,
                                                   i.ln_Itsubo,
                                                   i.ln_Ittope,
                                                   ld_fecpro,
                                                   i.ln_monto
                                                  );
                            exception
                            when others then
                              null;                        
                            end;
                          end; 
                        end if;   
                    end loop;  
                 else  --50/501 para cta de remuneraciones/ abono terceros                   
                    if ln_montp > 0 then 
                       if ln_monap + ln_salter > ln_montp then
                          p_c_cancel := 'S';
                          return;
                       End If;      
                    end if;                      
                 End Case;  
               End If;   

            Else   --trx de extorno
               if LN_TP1IMP2 = 1 then --extorno de egreso                                                
                  --traer la trx original 
                  begin
                    -- Call the procedure
                    pq_op_asientos_mplus.sp_ah_trx_ori(pn_pgcod    => P_N_PGCOD,
                                                       pn_hcmod    => P_N_ITMOD,
                                                       pn_hsucor   => P_N_ITSUC,
                                                       pn_htran    => P_N_ITTRAN,
                                                       pn_hnrel    => P_N_ITNREL,
                                                       pd_fecpro   => ld_fecpro,
                                                       pn_hcmod_o  => ln_hcmod_o,
                                                       pn_hnrel_o  => ln_hnrel_o,
                                                       pd_fecpro_o => ld_fecpro_o
                                                       );
                  end;                 

                  begin
                     select nvl(to_number(trim(a.txtext),'999,999,999.90'),0)
                       into ln_monap
                       from FSX015 a
                      Where a.Pgcod  = P_N_PGCOD
                        and a.Hcmod  = ln_hcmod_o
                        and a.Hsucor = P_N_ITSUC
                        and a.Htran  = P_N_ITTRAN
                        and a.Hnrel  = ln_hnrel_o
                        and a.Hfcon  = ld_fecpro_o
                        and a.Txcod  = 907   
                        and a.txreng = 1;
                  exception
                  when others then       
                    ln_monap := 0;
                  end;
                  --actualizamos el monto a la tabla de saldos de remuneraciones
                  begin
                    update JAQZ157 a 
                       set a.jaqz157ful = ld_fecpro,  
                           a.jaqz157sdo = a.jaqz157sdo + ln_monap
                     where a.jaqz157pgc = ln_Pgcod
                       and a.jaqz157mod = ln_Modulo
                       and a.jaqz157suc = ln_Itsucd
                       and a.jaqz157mda = ln_Moneda
                       and a.jaqz157pap = ln_Papel
                       and a.jaqz157cta = ln_ctnro
                       and a.jaqz157ope = ln_Itoper
                       and a.jaqz157sbo = ln_Itsubo
                       and a.jaqz157tpo = ln_Ittope;
                  end;   
               Else--extorno de ingreso
                 ln_monap := ln_monto;
                 case
                 when LN_TP1IMP3 = 0 then --significa que es de remuneraciones
                    begin
                      update JAQZ157 a 
                         set a.jaqz157ful = ld_fecpro,  
                             a.jaqz157sdo = a.jaqz157sdo - ln_monap
                       where a.jaqz157pgc = ln_Pgcod
                         and a.jaqz157mod = ln_Modulo
                         and a.jaqz157suc = ln_Itsucd
                         and a.jaqz157mda = ln_Moneda
                         and a.jaqz157pap = ln_Papel
                         and a.jaqz157cta = ln_ctnro
                         and a.jaqz157ope = ln_Itoper
                         and a.jaqz157sbo = ln_Itsubo
                         and a.jaqz157tpo = ln_Ittope;
                    end; 
                 when LN_TP1IMP3 = 2 then --extorno abono batch
                    For i in c_trxori(ld_fecpro) loop
                        If i.Txreng   = 1 then
                            PItnrel_ori := to_number(trim(i.Txtext));
                        End If;
                        If i.Txreng   = 2 then
                            PItfcon_ori := to_date(trim(i.Txtext),'dd/mm/rrrr');
                        End If;                      
                    end loop;  
                    For i in c_importa_ext(PItfcon_ori,PItnrel_ori) loop
                      if i.jaql71tiab = 'R' then
                        update JAQZ157 a 
                           set a.jaqz157ful = ld_fecpro,  
                               a.jaqz157sdo = a.jaqz157sdo - ln_monap
                         where a.jaqz157pgc = ln_Pgcod
                           and a.jaqz157mod = ln_Modulo
                           and a.jaqz157suc = ln_Itsucd
                           and a.jaqz157mda = ln_Moneda
                           and a.jaqz157pap = ln_Papel
                           and a.jaqz157cta = ln_ctnro
                           and a.jaqz157ope = ln_Itoper
                           and a.jaqz157sbo = ln_Itsubo
                           and a.jaqz157tpo = ln_Ittope; 
                      end if;                          
                    end loop;
                 else
                   null;                       
                 End case;  
               End If;                 
            End if;
        end if;                             
    end if;                   
  exception 
  when others then  
   null;  
  end sp_ah_abm_remu;                                                          
  
 Procedure sp_ah_graba_monto_itf(P_N_PGCOD  IN NUMBER,
                                 P_N_ITSUC  IN NUMBER,
                                 P_N_ITMOD  IN NUMBER,
                                 P_N_ITTRAN IN NUMBER,
                                 P_N_ITNREL IN NUMBER,
                                 P_N_ITORD  IN NUMBER,
                                 P_N_ITSBO  IN NUMBER,
                                 P_N_MONTO1 IN NUMBER
                                 ) IS
  PRAGMA AUTONOMOUS_TRANSACTION;                                                                      

  begin
    begin
       insert into fsd016(pgcod,itsuc,itmod,ittran,itnrel,itord,itsbor,modulo,ittope,itsucd,rubro,moneda,papel,ctnro,itoper,  
                   itsubo,itfval,itfvto,itpzo,itper,itttas,ittasa,ittmor,ittdia,ittvto,ittano,ittint,itarb,itarb1,itmd,    
                   itmd1,ittcbi,ittcbi1,itpre,itpre1,itdrev,itafiv,itafgt,itplus,itcodm,itser,itcheq,itimp1,itimp2,  
                   itimp3,itimp4,itimp5,itimp6,itimp7,itimp8,itimp9,itimp10,itimp11,itimp12,itimp13,itimp14,itimp15,itimp16, 
                   itimp17,itimp18,itimp19,itimp20,itimpo,itmdao,itdbha,itncor,itbbtt,itfunc,itsegm,itccos,itcbcu,itccli,  
                   itref,itanu,itposic,itvalua,itcltcod,itpza,itdcom  
                  ) 
            SELECT pgcod,itsuc,itmod,ittran,itnrel,91,itsbor,modulo,ittope,itsucd,rubro,moneda,papel,ctnro,itoper,  
                   itsubo,itfval,null,itpzo,itper,itttas,ittasa,ittmor,ittdia,ittvto,ittano,ittint,itarb,itarb1,itmd,    
                   itmd1,ittcbi,ittcbi1,itpre,itpre1,itdrev,itafiv,itafgt,itplus,55,itser,itcheq,P_N_MONTO1,itimp2,  
                   itimp3,itimp4,itimp5,itimp6,itimp7,itimp8,itimp9,itimp10,itimp11,itimp12,itimp13,itimp14,itimp15,itimp16, 
                   itimp17,itimp18,itimp19,itimp20,itimpo,itmdao,1,itncor,itbbtt,itfunc,itsegm,itccos,itcbcu,itccli,  
                   itref,itanu,itposic,itvalua,itcltcod,itpza,itdcom  
              from fsd016 
             Where Pgcod   = P_N_PGCOD
               and Itsuc   = P_N_ITSUC
               and Itmod   = P_N_ITMOD
               and Ittran  = P_N_ITTRAN
               and Itnrel  = P_N_ITNREL
               and Itord   = P_N_ITORD
               and Itsbor  = P_N_ITSBO;                     
    exception
    when dup_val_on_index then
  	    begin
         insert into fsd016(pgcod,itsuc,itmod,ittran,itnrel,itord,itsbor,modulo,ittope,itsucd,rubro,moneda,papel,ctnro,itoper,  
                     itsubo,itfval,itfvto,itpzo,itper,itttas,ittasa,ittmor,ittdia,ittvto,ittano,ittint,itarb,itarb1,itmd,    
                     itmd1,ittcbi,ittcbi1,itpre,itpre1,itdrev,itafiv,itafgt,itplus,itcodm,itser,itcheq,itimp1,itimp2,  
                     itimp3,itimp4,itimp5,itimp6,itimp7,itimp8,itimp9,itimp10,itimp11,itimp12,itimp13,itimp14,itimp15,itimp16, 
                     itimp17,itimp18,itimp19,itimp20,itimpo,itmdao,itdbha,itncor,itbbtt,itfunc,itsegm,itccos,itcbcu,itccli,  
                     itref,itanu,itposic,itvalua,itcltcod,itpza,itdcom  
                    ) 
              SELECT pgcod,itsuc,itmod,ittran,itnrel,91,itsbor,modulo,ittope,itsucd,rubro,moneda,papel,ctnro,itoper,  
                     itsubo,itfval,null,itpzo,itper,itttas,ittasa,ittmor,ittdia,ittvto,ittano,ittint,itarb,itarb1,itmd,    
                     itmd1,ittcbi,ittcbi1,itpre,itpre1,itdrev,itafiv,itafgt,itplus,55,itser,itcheq,P_N_MONTO1,itimp2,  
                     itimp3,itimp4,itimp5,itimp6,itimp7,itimp8,itimp9,itimp10,itimp11,itimp12,itimp13,itimp14,itimp15,itimp16, 
                     itimp17,itimp18,itimp19,itimp20,itimpo,itmdao,1,itncor,itbbtt,itfunc,itsegm,itccos,itcbcu,itccli,  
                     itref,itanu,itposic,itvalua,itcltcod,itpza,itdcom  
                from fsd016 
               Where Pgcod   = P_N_PGCOD
                 and Itsuc   = P_N_ITSUC
                 and Itmod   = P_N_ITMOD
                 and Ittran  = P_N_ITTRAN
                 and Itnrel  = P_N_ITNREL
                 and Itord   = P_N_ITORD
                 and Itsbor  = P_N_ITSBO + 1;                     
      exception
      when others then
         null;  
      end;  
    when others then
      null;         
    end;     
    
    begin
       insert into fsd016(pgcod,itsuc,itmod,ittran,itnrel,itord,itsbor,modulo,ittope,itsucd,rubro,moneda,papel,ctnro,itoper,  
                   itsubo,itfval,itfvto,itpzo,itper,itttas,ittasa,ittmor,ittdia,ittvto,ittano,ittint,itarb,itarb1,itmd,    
                   itmd1,ittcbi,ittcbi1,itpre,itpre1,itdrev,itafiv,itafgt,itplus,itcodm,itser,itcheq,itimp1,itimp2,  
                   itimp3,itimp4,itimp5,itimp6,itimp7,itimp8,itimp9,itimp10,itimp11,itimp12,itimp13,itimp14,itimp15,itimp16, 
                   itimp17,itimp18,itimp19,itimp20,itimpo,itmdao,itdbha,itncor,itbbtt,itfunc,itsegm,itccos,itcbcu,itccli,  
                   itref,itanu,itposic,itvalua,itcltcod,itpza,itdcom  
                  ) 
            SELECT pgcod,itsuc,itmod,ittran,itnrel,92,itsbor,75,0,itsucd,decode(moneda,0,2517050901001,2527050901001),moneda,papel,ctnro,itoper,  
                   0,null,null,itpzo,itper,itttas,ittasa,ittmor,ittdia,ittvto,ittano,ittint,itarb,itarb1,itmd,    
                   itmd1,ittcbi,ittcbi1,itpre,itpre1,itdrev,itafiv,itafgt,itplus,0,itser,itcheq,P_N_MONTO1,itimp2,  
                   itimp3,itimp4,itimp5,itimp6,itimp7,itimp8,itimp9,itimp10,itimp11,itimp12,itimp13,itimp14,itimp15,itimp16, 
                   itimp17,itimp18,itimp19,itimp20,itimpo,itmdao,2,itncor,itbbtt,itfunc,itsegm,itccos,itcbcu,itccli,  
                   itref,itanu,itposic,itvalua,itcltcod,itpza,itdcom  
              from fsd016 
             Where Pgcod   = P_N_PGCOD
               and Itsuc   = P_N_ITSUC
               and Itmod   = P_N_ITMOD
               and Ittran  = P_N_ITTRAN
               and Itnrel  = P_N_ITNREL
               and Itord   = P_N_ITORD
               and Itsbor  = P_N_ITSBO;                     
    exception
    when dup_val_on_index then
      begin
         insert into fsd016(pgcod,itsuc,itmod,ittran,itnrel,itord,itsbor,modulo,ittope,itsucd,rubro,moneda,papel,ctnro,itoper,  
                     itsubo,itfval,itfvto,itpzo,itper,itttas,ittasa,ittmor,ittdia,ittvto,ittano,ittint,itarb,itarb1,itmd,    
                     itmd1,ittcbi,ittcbi1,itpre,itpre1,itdrev,itafiv,itafgt,itplus,itcodm,itser,itcheq,itimp1,itimp2,  
                     itimp3,itimp4,itimp5,itimp6,itimp7,itimp8,itimp9,itimp10,itimp11,itimp12,itimp13,itimp14,itimp15,itimp16, 
                     itimp17,itimp18,itimp19,itimp20,itimpo,itmdao,itdbha,itncor,itbbtt,itfunc,itsegm,itccos,itcbcu,itccli,  
                     itref,itanu,itposic,itvalua,itcltcod,itpza,itdcom  
                    ) 
              SELECT pgcod,itsuc,itmod,ittran,itnrel,92,itsbor,75,0,itsucd,decode(moneda,0,2517050901001,2527050901001),moneda,papel,ctnro,itoper,  
                     0,null,null,itpzo,itper,itttas,ittasa,ittmor,ittdia,ittvto,ittano,ittint,itarb,itarb1,itmd,    
                     itmd1,ittcbi,ittcbi1,itpre,itpre1,itdrev,itafiv,itafgt,itplus,0,itser,itcheq,P_N_MONTO1,itimp2,  
                     itimp3,itimp4,itimp5,itimp6,itimp7,itimp8,itimp9,itimp10,itimp11,itimp12,itimp13,itimp14,itimp15,itimp16, 
                     itimp17,itimp18,itimp19,itimp20,itimpo,itmdao,2,itncor,itbbtt,itfunc,itsegm,itccos,itcbcu,itccli,  
                     itref,itanu,itposic,itvalua,itcltcod,itpza,itdcom  
                from fsd016 
               Where Pgcod   = P_N_PGCOD
                 and Itsuc   = P_N_ITSUC
                 and Itmod   = P_N_ITMOD
                 and Ittran  = P_N_ITTRAN
                 and Itnrel  = P_N_ITNREL
                 and Itord   = P_N_ITORD
                 and Itsbor  = P_N_ITSBO + 1;                     
      exception       
      When others then
        null;
      end;                              
    When others then
      null;
    end;                           
    commit;     
  exception
  when others then
    null;  
  end sp_ah_graba_monto_itf;      
  Procedure sp_ah_calcula_itf(P_N_MONTO IN NUMBER,
                              p_n_itf out number          
                              ) is
  ln_itf  number(10,2):=0;
  begin
    ln_itf := pq_ah_compensa_ctas.fn_calcula_itf(P_N_MONTO);   
    p_n_itf := ln_itf;
  Exception
  when others then  
    p_n_itf := 0;
    return;
  end sp_ah_calcula_itf;  
  Procedure sp_ah_analiza_integracion(P_N_PGCOD  IN NUMBER,
                                      P_N_ITSUC  IN NUMBER,
                                      P_N_ITMOD  IN NUMBER,
                                      P_N_ITTRAN IN NUMBER,
                                      P_N_ITNREL IN NUMBER,
                                      P_N_ITORD  IN NUMBER,
                                      P_N_ITSBO  IN NUMBER,
                                      P_N_CTADEB IN NUMBER,
                                      P_N_MONTO1 IN OUT NUMBER
                                      ) IS
  ln_ctacre number(9);
  begin
      --Obtenemos la cuenta del crédito
    begin           
     select Ctnro
       into ln_ctacre
       from FSD016 
      Where Pgcod   = P_N_PGCOD
        and Itsuc   = P_N_ITSUC
        and Itmod   = P_N_ITMOD
        and Ittran  = P_N_ITTRAN
        and Itnrel  = P_N_ITNREL
        and Itord   = P_N_ITORD
        and Itsbor  = P_N_ITSBO;
    Exception
    When others then
      ln_ctacre  := 0;    
    end;
    
    if P_N_CTADEB = ln_ctacre then
       P_N_MONTO1 := 0;
    Else
       P_N_MONTO1 := P_N_MONTO1;
    End If;
    
  exception
  when others then
     null;   
  end sp_ah_analiza_integracion;                                               
  Procedure sp_ah_analiza_integ_trans(P_N_PGCOD  IN NUMBER,
                                      P_N_ITSUC  IN NUMBER,
                                      P_N_ITMOD  IN NUMBER,
                                      P_N_ITTRAN IN NUMBER,
                                      P_N_ITNREL IN NUMBER,
                                      P_N_ITORD  IN NUMBER,
                                      P_N_ITSBO  IN NUMBER,
                                      P_N_CTADEB IN NUMBER,
                                      P_N_MONTO1 IN OUT NUMBER
                                      ) IS
  ln_ctacre number(9);
  begin
      --Obtenemos la cuenta origen
    begin           
     select Ctnro
       into ln_ctacre
       from FSD016 
      Where Pgcod   = P_N_PGCOD
        and Itsuc   = P_N_ITSUC
        and Itmod   = P_N_ITMOD
        and Ittran  = P_N_ITTRAN
        and Itnrel  = P_N_ITNREL
        and Itord   = P_N_ITORD
        and Itsbor  = P_N_ITSBO;
    Exception
    When No_data_found then
      begin           
       select Ctnro
         into ln_ctacre
         from FSD016 
        Where Pgcod   = P_N_PGCOD
          and Itsuc   = P_N_ITSUC
          and Itmod   = P_N_ITMOD
          and Ittran  = P_N_ITTRAN
          and Itnrel  = P_N_ITNREL
          and Itord   = P_N_ITORD + 1
          and Itsbor  = P_N_ITSBO;
      Exception
      When others then
        ln_ctacre  := 0;    
      end;      
    When others then
      ln_ctacre  := 0;    
    end;
    
    if P_N_CTADEB = ln_ctacre then
       begin
         delete 
           from FSD016  
          Where Pgcod   = P_N_PGCOD
            and Itsuc   = P_N_ITSUC
            and Itmod   = P_N_ITMOD
            and Ittran  = P_N_ITTRAN
            and Itnrel  = P_N_ITNREL
            and Itord   in (91,92); 
       exception
       when others then
           null;   
       end;       
    Else
       P_N_MONTO1 := P_N_MONTO1;
    End If;
    
  exception
  when others then
     null;   
  end sp_ah_analiza_integ_trans;   
  */
  
  
  Procedure sp_ah_graba_inicio(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER
                                        ) IS
  PRAGMA AUTONOMOUS_TRANSACTION;                                                                      
  begin
        begin
          insert into jaql490
            (jaql490pgc,
             jaql490suc,
             jaql490mod,
             jaql490trx,
             jaql490rel,
             jaql490fec,
             jaql490ini)
          values
            (P_N_PGCOD,
             P_N_ITSUC,
             P_N_ITMOD,
             P_N_ITTRAN,
             P_N_ITNREL,
             trunc(sysdate),
             sysdate);
          commit;
        Exception
          When others then
            null;
        end;
  exception
  when others then
    null;  
  end sp_ah_graba_inicio;  
  
  Procedure sp_ah_graba_fin(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER,
                                        p_n_moncom IN NUMBER,
                                        p_n_nummov IN NUMBER
                                        ) IS
  PRAGMA AUTONOMOUS_TRANSACTION;                                                                      
  begin
    begin
      update jaql490
         set jaql490fin = sysdate,
             jaql490mco = p_n_moncom,
             jaql490nmo = p_n_nummov
       where jaql490pgc = P_N_PGCOD
         and jaql490suc = P_N_ITSUC
         and jaql490mod = P_N_ITMOD
         and jaql490trx = P_N_ITTRAN
         and jaql490rel = P_N_ITNREL
         and jaql490fec = trunc(sysdate);
      commit;
    Exception
      When others then
        null;
    end;
  exception
  when others then
    null;  
  end sp_ah_graba_fin;  
  Procedure sp_ah_graba_bolsa(P_D_FECPRO IN DATE,
                              P_N_PGCOD  IN NUMBER,
                              P_N_MODULO IN NUMBER,
                              P_N_SUCDES IN NUMBER,  
                              P_N_MONEDA IN NUMBER,
                              P_N_PAPEL  IN NUMBER,
                              P_N_CTNRO  IN NUMBER,
                              P_N_ITOPER IN NUMBER,
                              P_N_ITSUBO IN NUMBER,
                              P_N_ITTOPE IN NUMBER,
                              P_C_TIPTRX IN VARCHAR2, --A= AUMENTA D=DISMINUYE
                              P_N_MONMOV IN NUMBER, 
                              P_N_MONTEM IN NUMBER, 
                              P_N_PGEMP  IN NUMBER,
                              P_N_ITSUC  IN NUMBER,
                              P_N_ITMOD  IN NUMBER,
                              P_N_ITTRAN IN NUMBER,
                              P_N_ITNREL IN NUMBER,
                              P_N_ITNORD IN NUMBER
                              ) IS   
  PRAGMA AUTONOMOUS_TRANSACTION;                               
  begin  
      if P_N_ITTOPE = 9 then  
        begin
            insert into jaqz193(jaqz193pgc,
                                jaqz193mod,
                                jaqz193suc,
                                jaqz193mda,
                                jaqz193pap,
                                jaqz193cta,
                                jaqz193ope,
                                jaqz193sbo,
                                jaqz193tpo,
                                jaqz193fec,
                                jaqz193mto,
                                jaqz193sal,
                                jaqz193fmv,
                                jaqz193emc,
                                jaqz193agc,
                                jaqz193mdc,
                                jaqz193trc,
                                jaqz193rel,
                                jaqz193ord,
                                jaqz193ax3,
                                jaqz193ax7    
                               ) 
                         values(P_N_PGCOD,  
                                P_N_MODULO, 
                                P_N_SUCDES,
                                P_N_MONEDA, 
                                P_N_PAPEL,  
                                P_N_CTNRO,  
                                P_N_ITOPER, 
                                P_N_ITSUBO, 
                                P_N_ITTOPE,
                                P_D_FECPRO,
                                P_N_MONMOV,
                                P_N_MONMOV,
                                P_D_FECPRO,
                                P_N_PGEMP,
                                P_N_ITSUC, 
                                P_N_ITMOD, 
                                P_N_ITTRAN,
                                P_N_ITNREL,
                                P_N_ITNORD,
                                P_N_MONTEM,
                                P_C_TIPTRX
                               );
          commit;                       
        Exception  
        When dup_val_on_index then
             update jaqz193 
                set jaqz193sal = Case
                                 when P_N_ITMOD > 500  and P_C_TIPTRX = 'A' then
                                   Case
                                     when jaqz193sal - P_N_MONMOV  >= 0 then
                                       jaqz193sal - P_N_MONMOV          
                                     else
                                       0
                                   end                                       
                                 when P_N_ITMOD > 500  and P_C_TIPTRX = 'D' then       
                                   Case
                                     when jaqz193sal + P_N_MONMOV  >= 0 then
                                       jaqz193sal + P_N_MONMOV       
                                     else
                                       0                                       
                                   end       
                                 when P_N_ITMOD <= 500  and P_C_TIPTRX = 'A' then                   
                                   Case
                                     when jaqz193sal + P_N_MONMOV   >= 0 then
                                       jaqz193sal + P_N_MONMOV    
                                     else
                                       0                                       
                                   end                               
                                 when P_N_ITMOD <= 500  and P_C_TIPTRX = 'D' then                                                    
                                   Case
                                     when jaqz193sal - P_N_MONMOV     >= 0 then
                                       jaqz193sal - P_N_MONMOV    
                                     else
                                       0                                       
                                   end                             
                                 Else
                                   0
                                 End,           
                    jaqz193ax3 = abs(P_N_MONTEM),                        
                    jaqz193ax7 = P_C_TIPTRX,  
                    jaqz193fmv = P_D_FECPRO,
                    jaqz193emc = P_N_PGEMP,
                    jaqz193agc = P_N_ITSUC,
                    jaqz193mdc = P_N_ITMOD, 
                    jaqz193trc = P_N_ITTRAN,
                    jaqz193rel = P_N_ITNREL,    
                    jaqz193ord = P_N_ITNORD            
              where jaqz193pgc = P_N_PGCOD  
                and jaqz193mod = P_N_MODULO 
                and jaqz193suc = P_N_SUCDES
                and jaqz193mda = P_N_MONEDA 
                and jaqz193pap = P_N_PAPEL  
                and jaqz193cta = P_N_CTNRO  
                and jaqz193ope = P_N_ITOPER 
                and jaqz193sbo = P_N_ITSUBO 
                and jaqz193tpo = P_N_ITTOPE;
                commit;
        When others then
              null;
        end;                
      End If;        
  End sp_ah_graba_bolsa;                                        
  Procedure sp_ah_consu_bolsa(P_N_PGCOD  IN NUMBER,
                              P_N_MODULO IN NUMBER,
                              P_N_SUCDES IN NUMBER,  
                              P_N_MONEDA IN NUMBER,
                              P_N_PAPEL  IN NUMBER,
                              P_N_CTNRO  IN NUMBER,
                              P_N_ITOPER IN NUMBER,
                              P_N_ITSUBO IN NUMBER,
                              P_N_ITTOPE IN NUMBER,
                              P_D_FECPRO IN DATE,
                              p_n_mtosal out number,
                              p_c_indcre out varchar2
                              ) IS    
  ld_fecini date;  
  ld_fecape date;     
  lc_newcal char(1):= 'N';            
  ln_monto  number(17,2):=0;              
  begin
  p_n_mtosal := 0;  
  p_c_indcre := 'N';
      
    --OBTENEMOS EL SALDO DE EXONERACIÓN 
    begin      
     Select jaqz193sal 
       into p_n_mtosal
       from JAQZ193 
      where jaqz193pgc = P_N_PGCOD  
        and jaqz193mod = P_N_MODULO 
        and jaqz193suc = P_N_SUCDES
        and jaqz193mda = P_N_MONEDA 
        and jaqz193pap = P_N_PAPEL  
        and jaqz193cta = P_N_CTNRO  
        and jaqz193ope = P_N_ITOPER 
        and jaqz193sbo = P_N_ITSUBO 
        and jaqz193tpo = P_N_ITTOPE;
     exception 
     when others then  
        p_n_mtosal := 0;
     end;
     
      --VERIFICAMOS SI ESTAN EXONERADAS DEL NUEVO CALCULO
     begin        
          select to_date(trim(b.tp1desc),'dd/mm/rrrr')
            into ld_fecini
            from fst198 b
           where b.tp1cod   = 1 
             and b.tp1cod1  = 10825
             and b.tp1corr1 = 85
             and b.tp1corr2 = 1 
             and b.tp1corr3 = 1  -- solo obtenemos la fecha de comparación
             and b.tp1nro1  = 1; --1= HABILITADO 0 = INHABILITADO
     exception
     when others then
       ld_fecini := null;       
     end;      
      
     if ld_fecini is not null then
       --VERIFICAMOS LA FECHA DE APERTURA DEL AHORRO CORRIENTE
       begin        
            select a.scfval
              into ld_fecape
              from fsd011 a
             where a.pgcod  = P_N_PGCOD   
               and a.scmod  = P_N_MODULO 
               and a.scsuc  = P_N_SUCDES
               and a.scmda  = P_N_MONEDA 
               and a.scpap  = P_N_PAPEL  
               and a.sccta  = P_N_CTNRO  
               and a.scoper = P_N_ITOPER 
               and a.scsbop = P_N_ITSUBO 
               and a.sctope = P_N_ITTOPE;
       exception
       when others then
         ld_fecape := null;       
       end;  
       if ld_fecape >= ld_fecini then
         lc_newcal := 'S';
       else
         lc_newcal := 'N';
       end if;  
     else
       lc_newcal := 'S';       
     End If;  
     
     if lc_newcal = 'S' then
         --OBTENEMOS EL INDICADOR DE CREDITOS VIGENTES
         begin   
           /*   
           Select 'S'
             into p_c_indcre
             from fsr011 a,
                  fsd011 b 
            where a.r1cod = b.pgcod
              and a.r1mod = b.scmod
              --and a.r1suc = b.scsuc
              and a.r1mda = b.scmda
              and a.r1pap = b.scpap
              and a.r1cta = b.sccta
              and a.r1oper = b.scoper
              and a.r1sbop = b.scsbop
              and a.r1tope = b.sctope
              and a.relcod = 200
              and b.scstat <> 99
              and a.r2cod  = P_N_PGCOD  
              and a.r2mod  = P_N_MODULO 
              and a.r2suc  = P_N_SUCDES
              and a.r2mda  = P_N_MONEDA 
              and a.r2pap  = P_N_PAPEL  
              and a.r2cta  = P_N_CTNRO  
              and a.r2oper = P_N_ITOPER 
              and a.r2sbop = P_N_ITSUBO 
              and a.r2tope = P_N_ITTOPE
              and rownum < 2;     
              */
              pq_ah_comision.sp_ah_monto_ac(p_n_pgcod  => P_N_PGCOD,
                                            p_n_modulo => P_N_MODULO,
                                            p_n_ctnro  => P_N_CTNRO,
                                            p_n_itoper => P_N_ITOPER,
                                            p_n_itsubo => P_N_ITSUBO,
                                            p_n_ittope => P_N_ITTOPE,
                                            p_n_sucdes => P_N_SUCDES,
                                            p_n_moneda => P_N_MONEDA,
                                            p_n_papel  => P_N_PAPEL,
                                            p_d_fecpro => P_D_FECPRO,
                                            p_n_mtoexo => ln_monto
                                            );         
               if ln_monto > 0 then
                  p_c_indcre := 'S';
               Else
                  p_c_indcre := 'N'; 
               End If;                                                                                                   
         exception 
         when others then  
            p_c_indcre := 'N';
         end; 
     else
       p_c_indcre := 'S';    
     end if;         
  exception 
  when others then  
    p_n_mtosal := 0;
    p_c_indcre := 'N';
  end sp_ah_consu_bolsa;                              
end PQ_AH_COMISION;
/

