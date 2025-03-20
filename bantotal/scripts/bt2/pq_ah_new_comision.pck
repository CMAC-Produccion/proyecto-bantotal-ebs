create or replace package PQ_AH_NEW_COMISION is

  -- Author  : YLOZADA
  -- Created : 18/03/2020 9:30:22 a. m.
  -- Purpose : 
  

  Procedure sp_ah_cal_comision(P_N_PGCOD  IN NUMBER,
                               P_N_ITSUC  IN NUMBER,
                               P_N_ITMOD  IN NUMBER, 
                               P_N_ITTRAN IN NUMBER,
                               P_N_ITNREL IN NUMBER,
                               P_N_ITORD  IN NUMBER,
                               P_N_ITSBO  IN NUMBER,
                               P_D_FECPRO IN DATE,
                               p_n_moncom out number,
                               p_n_nummov out number,   
                               p_c_coderr out varchar2,
                               p_c_msgerr out varchar2                                                            
                               );
  Procedure sp_ah_calcula_comision(P_D_FECPRO IN DATE,
                                   P_N_PGCOD  IN NUMBER,
                                   P_N_CTNRO  IN NUMBER,
                                   P_N_ITOPER IN NUMBER,
                                   P_N_ITSUBO IN NUMBER,
                                   P_N_SUCDES IN NUMBER,
                                   P_N_ITTOPE IN NUMBER,
                                   P_N_MODULO IN NUMBER,
                                   P_N_MONEDA IN NUMBER,
                                   P_N_PAPEL  IN NUMBER,
                                   P_N_MONTO  IN NUMBER,
                                   P_N_CODTAR IN NUMBER,
                                   P_N_CODPRE IN NUMBER,
                                   P_N_CODCOM IN NUMBER,   
                                   P_N_PREESP IN NUMBER,                                    
                                   p_n_moncom out number,
                                   p_n_nummov out number,
                                   p_c_coderr out varchar2, 
                                   p_c_msgerr out varchar2
                                  ) ;                                 
  procedure sp_ah_verif_tablas16(ln_cuenta in number,-- datos de la cuenta
                                 ln_scsuc  in number,--
                                 ln_modulo in number,--
                                 ln_opera  in number,--
                                 ln_tipo   in number,--
                                 ln_moneda in number,--
                                 ln_subope in number,--datos de la cuenta
                                 ln_trans  in number,
                                 ln_rel    in number,
                                 ld_fecha  in date,
                                 ln_pitsuc in number,
                                 ln_pitmod in number,
                                 ln_pitord in number,
                                 ln_pitsbor in number,
                                 ln_monto  in number,
                                 lc_rpta   out number,
                                 P_N_CODTAR IN NUMBER,
                                 P_N_CODPRE IN NUMBER,
                                 P_N_CODCOM IN NUMBER,
                                 P_N_PREESP IN NUMBER,
                                 p_n_moncom out number,
                                 p_n_nummov out number,
                                 p_c_coderr out varchar2, 
                                 p_c_msgerr out varchar2                               
                                 );
  Procedure sp_ah_calcula_comision_plaza(P_N_PGCOD  IN NUMBER,
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
                                         P_N_CANSUC IN NUMBER,
                                         P_N_MONTO  IN NUMBER,                                         
                                         P_N_CODTAR IN NUMBER,
                                         P_N_CODPRE IN NUMBER,
                                         P_N_CODCOM IN NUMBER,  
                                         P_N_PREESP IN NUMBER, 
                                         P_D_FECPRO IN DATE,                 
                                         p_n_moncom out number,
                                         p_n_nummov out number,
                                         p_c_coderr out varchar2, 
                                         p_c_msgerr out varchar2                                            
                                        );                                   
  Procedure sp_ah_consulta_new_comision(P_D_FECPRO IN DATE,
                                        P_N_PGCOD  IN NUMBER,
                                        P_N_CTNRO  IN NUMBER,
                                        P_N_ITOPER IN NUMBER,
                                        P_N_ITSUBO IN NUMBER,
                                        P_N_SUCDES IN NUMBER,
                                        P_N_ITTOPE IN NUMBER,
                                        P_N_MODULO IN NUMBER,
                                        P_N_MONEDA IN NUMBER,
                                        P_N_PAPEL  IN NUMBER,
                                        P_N_MONTO  IN NUMBER,
                                        P_N_CODCOM IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,   
                                        P_N_CANSUC IN NUMBER,                                     
                                        p_n_moncom in out number,
                                        p_n_nummov in out number,
                                        p_c_coderr out varchar2, 
                                        p_c_msgerr out varchar2
                                       );   
                                                                                       
  procedure sp_ah_abm_comision(P_C_NOMTBL IN VARCHAR2,
                               P_C_TIPACC IN VARCHAR2,
                               P_N_NUMAX1 IN OUT NUMBER,
                               P_N_NUMAX2 IN OUT NUMBER,
                               P_N_NUMAX3 IN OUT NUMBER,
                               P_N_NUMAX4 IN OUT NUMBER,
                               P_N_NUMAX5 IN OUT NUMBER,
                               P_N_NUMAX6 IN OUT NUMBER,
                               P_N_NUMAX7 IN OUT NUMBER,
                               P_N_NUMAX8 IN OUT NUMBER,
                               P_N_NUMAX9 IN OUT NUMBER,
                               P_N_NUMA10 IN OUT NUMBER,
                               P_N_NUMA11 IN OUT NUMBER,
                               P_N_NUMA12 IN OUT NUMBER, 
                               P_N_NUMA13 IN OUT NUMBER,                                                                                                                                                                                                                                                       
                               P_D_DATAX1 IN OUT DATE,
                               P_D_DATAX2 IN OUT DATE,
                               P_D_DATAX3 IN OUT DATE,
                               P_D_DATAX4 IN OUT DATE,
                               P_D_DATAX5 IN OUT DATE,
                               P_D_DATAX6 IN OUT DATE,
                               P_C_CHRAX1 IN OUT VARCHAR2,
                               P_C_CHRAX2 IN OUT VARCHAR2,
                               P_C_CHRAX3 IN OUT VARCHAR2,
                               P_C_CHRAX4 IN OUT VARCHAR2,
                               P_C_CHRAX5 IN OUT VARCHAR2,
                               P_C_CHRAX6 IN OUT VARCHAR2,
                               P_C_CHRAX7 IN OUT VARCHAR2,
                               p_c_coderr out varchar2,
                               p_c_deserr out varchar2   
                              );
  Procedure sp_ah_tipper(P_N_CODPGC IN NUMBER,
                         P_N_NUMCTA IN NUMBER,
                         p_c_codval out varchar2
                         ) ;  
  Function fn_ah_aplica_comision(P_N_ITMOD  IN NUMBER, 
                                 P_N_ITTRAN IN NUMBER,
                                 P_N_CODCOM IN NUMBER,                                 
                                 P_D_FECPRO IN DATE      
                                 ) return varchar2;   
                                 
  Procedure sp_ah_datos_asiento(P_N_PGCOD  IN NUMBER,
                                P_N_ITSUC  IN NUMBER,
                                P_N_ITMOD  IN NUMBER, 
                                P_N_ITTRAN IN NUMBER,
                                P_N_ITNREL IN NUMBER,
                                P_N_ITORD  IN NUMBER,
                                P_N_ITSBO  IN NUMBER,
                                 pn_Pgcod  out number, 
                                 pn_ctnro  out number, 
                                 pn_Itoper out number, 
                                 pn_Itsubo out number, 
                                 pn_Itsucd out number, 
                                 pn_Ittope out number, 
                                 pn_Modulo out number, 
                                 pn_Moneda out number, 
                                 pn_Papel  out number, 
                                 pn_monto  out number, 
                                 pn_indcob out number, 
                                 p_c_coderr out varchar2,
                                 p_c_msgerr out varchar2                                                            
                                );  
  function fn_ah_comtipper(P_N_CODCOM IN NUMBER,
                           P_C_TIPPER IN VARCHAR2
                          ) return number; 
  Procedure sp_ah_graba_importe_comisio(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER,
                                        P_N_ITORD  IN NUMBER,
                                        P_N_ITSBO  IN NUMBER,
                                        P_N_CODCOM IN NUMBER,
                                        P_N_MONTO1 IN NUMBER,
                                        P_N_MONTO2 IN NUMBER,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2                                            
                                       );  
  procedure sp_ah_interplaza(P_N_PGCOD  IN NUMBER,
                             P_N_ITSUC  IN NUMBER,
                             P_N_ITMOD  IN NUMBER, 
                             P_N_ITTRAN IN NUMBER,
                             P_N_ITNREL IN NUMBER,
                             P_N_ITORD  IN NUMBER,
                             P_N_ITSBO  IN NUMBER,
                             P_D_FECPRO IN DATE,
                             PN_PGCOD   IN NUMBER,
                             PN_CTNRO   IN NUMBER,
                             PN_ITOPER  IN NUMBER,
                             PN_ITSUBO  IN NUMBER,
                             PN_ITSUCD  IN NUMBER,
                             PN_ITTOPE  IN NUMBER,
                             PN_MODULO  IN NUMBER,
                             PN_MONEDA  IN NUMBER,
                             PN_MONTO   IN NUMBER,
                             PN_BTCP    IN NUMBER,
                             PN_CODTAR  IN NUMBER,
                             PN_CODPRE  IN NUMBER,
                             PN_CODCOM  IN NUMBER, 
                             PN_PREESP  IN NUMBER,   
                             p_n_moncom out number,
                             p_n_nummov out number,                                                        
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2                                                             
                            );
  procedure sp_ah_det_criterio(P_D_FECPRO IN DATE,
                               PN_PGCOD   IN NUMBER,
                               PN_CTNRO   IN NUMBER,
                               PN_ITOPER  IN NUMBER,
                               PN_ITSUBO  IN NUMBER,
                               PN_ITSUCD  IN NUMBER,
                               PN_ITTOPE  IN NUMBER,
                               PN_MODULO  IN NUMBER,
                               PN_MONEDA  IN NUMBER,
                               PN_PAPEL   IN NUMBER,
                               PN_MONTO   IN NUMBER,
                               pn_numcri  in out number,
                               p_c_coderr out varchar2,
                               p_c_msgerr out varchar2
                              );   
  function fn_ah_crican(P_N_CODCRI IN NUMBER,
                        P_N_CODCAN IN NUMBER
                       ) return number;
                       
  procedure sp_ah_tarifario_comision(PN_CRICAN  IN NUMBER,                                         
                                     PN_ITSUCD  IN NUMBER,
                                     PN_ITTOPE  IN NUMBER,
                                     PN_MODULO  IN NUMBER,
                                     PN_MONEDA  IN NUMBER,                                     
                                     pn_codtar  out number,
                                     pn_codpre  out number,
                                     p_c_coderr out varchar2,
                                     p_c_msgerr out varchar2
                                    );   
   

  Procedure sp_ah_det_precio(P_N_CODPRE IN NUMBER,
                             p_n_codmod out number,
                             p_n_codcod out number,
                             p_n_topmov out number,
                             p_n_topsal out number,
                             p_c_coderr out varchar2, 
                             p_c_msgerr out varchar2                             
                            );   
  Function fn_ah_mov_canal(P_D_FECPRO IN DATE,
                           P_N_CODTAR IN NUMBER,
                           P_N_NUMMOV IN NUMBER,
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
  Function fn_ah_mov_dia(P_N_CODTAR IN NUMBER,
                         P_N_NUMMOV IN NUMBER,
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
  Function fn_ah_mov_his(P_N_CODTAR IN NUMBER,
                         P_N_NUMMOV IN NUMBER,
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
  function fn_ah_verif_monto(monto   in number,
                             moneda  in number,
                             fecha   in date,
                             moncol  in number,
                             tipoper in number
                            ) return number;
  Function fn_ah_verif_nroope(P_N_CODPRE IN NUMBER, ope in number) return number;
  Function fn_ah_verifica_tar_especial(P_D_FECPRO IN DATE,
                                       P_N_PGCOD  IN NUMBER,
                                       P_N_CTNRO  IN NUMBER,
                                       P_N_ITOPER IN NUMBER,
                                       P_N_ITSUBO IN NUMBER,
                                       P_N_SUCDES IN NUMBER,
                                       P_N_ITTOPE IN NUMBER,
                                       P_N_MODULO IN NUMBER,
                                       P_N_MONEDA IN NUMBER,
                                       P_N_PAPEL  IN NUMBER,
                                       P_N_CODCOM IN NUMBER,   
                                       P_N_CODCAN IN NUMBER                                                      
                                      )return number;  
  Function fn_ah_verifica_exoneracion(P_D_FECPRO IN DATE,
                                      P_N_PGCOD  IN NUMBER,
                                      P_N_CTNRO  IN NUMBER,
                                      P_N_ITOPER IN NUMBER,
                                      P_N_ITSUBO IN NUMBER,
                                      P_N_SUCDES IN NUMBER,
                                      P_N_ITTOPE IN NUMBER,
                                      P_N_MODULO IN NUMBER,
                                      P_N_MONEDA IN NUMBER,
                                      P_N_PAPEL  IN NUMBER,
                                      P_N_CODCOM IN NUMBER,   
                                      P_N_CODCAN IN NUMBER                                                      
                                     )return varchar2;   
  Procedure sp_ah_reg_tasesp_ah(P_N_PGCOD  IN NUMBER,
                               P_N_MODULO IN NUMBER,
                               P_N_MONEDA IN NUMBER,
                               P_N_PAPEL  IN NUMBER,
                               P_N_CTNRO  IN NUMBER,
                               P_N_ITSUBO IN NUMBER,
                               P_N_ITTOPE IN NUMBER,
                                P_D_FECINI IN DATE,
                                P_D_FECFIN IN DATE,
                               P_N_TASESP IN NUMBER,                           
                               p_c_coderr out varchar2,
                               p_c_msgerr out varchar2
                              );
                              
  Procedure sp_ah_reg_logcta_ah(P_N_PGCOD  IN NUMBER,
                                P_N_MODULO IN NUMBER,
                                P_N_SUCURS IN NUMBER,
                                P_N_MONEDA IN NUMBER,
                                P_N_PAPEL  IN NUMBER,
                                P_N_CTNRO  IN NUMBER,
                                P_N_OPERAC IN NUMBER,
                                P_N_ITSUBO IN NUMBER,
                                P_N_ITTOPE IN NUMBER,
                                P_D_FECPRO IN DATE,
                                P_N_TASINI IN NUMBER,
                                P_N_TASFIN IN NUMBER,
                                P_C_CODEST IN VARCHAR2,
                                P_C_CODUSU IN VARCHAR2,
                                P_C_DESMSG IN VARCHAR2,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2
                               );                              
  Procedure sp_ah_del_tasesp_ah(P_N_PGCOD  IN NUMBER,
                                P_N_MODULO IN NUMBER,
                                P_N_MONEDA IN NUMBER,
                                P_N_PAPEL  IN NUMBER,
                                P_N_CTNRO  IN NUMBER,
                                P_N_ITSUBO IN NUMBER,
                                P_N_ITTOPE IN NUMBER,
                                P_D_FECPRO IN DATE,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2
                               ); 
  procedure sp_ah_tasa_especial_sub(P_N_PGCOD  IN NUMBER,
                                    P_N_MODULO IN NUMBER,
                                    P_N_MONEDA IN NUMBER,
                                    P_N_PAPEL  IN NUMBER,
                                    P_N_CTNRO  IN NUMBER,
                                    P_N_ITSUBO IN NUMBER,
                                    P_N_ITTOPE IN NUMBER,
                                    P_D_FECPRO IN DATE,
                                    p_d_fecini out date,
                                    p_d_fecfin out date,
                                    p_n_tasesp out number,
                                    p_c_coderr out varchar2,
                                    p_c_msgerr out varchar2
                                   );
  function fn_ah_abono_n_meses(P_D_FECPRO IN DATE,
                               P_N_PGCOD  IN NUMBER,
                               P_N_MODULO IN NUMBER,
                               P_N_SUCDES IN NUMBER,
                               P_N_MONEDA IN NUMBER,
                               P_N_PAPEL  IN NUMBER,
                               P_N_CTNRO  IN NUMBER,
                               P_N_ITOPER IN NUMBER,
                               P_N_ITSUBO IN NUMBER,
                               P_N_ITTOPE IN NUMBER
                               ) return varchar2;    
  function fn_ah_consulta_stock(P_D_FECPRO IN DATE,
                                P_N_PGCOD  IN NUMBER,
                                P_N_MODULO IN NUMBER,
                                P_N_SUCDES IN NUMBER,
                                P_N_MONEDA IN NUMBER,
                                P_N_PAPEL  IN NUMBER,
                                P_N_CTNRO  IN NUMBER,
                                P_N_ITOPER IN NUMBER,
                                P_N_ITSUBO IN NUMBER,
                                P_N_ITTOPE IN NUMBER
                                ) return date; 
  function fn_ah_exonera_stock(P_D_FECPRO IN DATE,
                               P_N_PGCOD  IN NUMBER,
                               P_N_MODULO IN NUMBER,
                               P_N_SUCDES IN NUMBER,
                               P_N_MONEDA IN NUMBER,
                               P_N_PAPEL  IN NUMBER,
                               P_N_CTNRO  IN NUMBER,
                               P_N_ITOPER IN NUMBER,
                               P_N_ITSUBO IN NUMBER,
                               P_N_ITTOPE IN NUMBER
                               ) return date;    
  Procedure sp_valida_edad_junior(P_N_EDAMIN IN NUMBER,
                                  P_N_EDAMAX IN NUMBER,
                                  P_D_FECNAC IN DATE,
                                  P_D_FECPRO IN DATE,
                                  p_c_valida out varchar2
                                 ); 
  Procedure sp_ah_exonera_TDV(P_D_FECPRO IN DATE,
                              P_N_CTNRO  IN NUMBER,
                              p_c_exoner out varchar2 
                              ); 
  Function fn_ah_exonera_trx(P_N_PGCOD  IN NUMBER,
                             P_N_MODULO IN NUMBER,
                             P_N_SUCDES IN NUMBER,  
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_ITTOPE IN NUMBER,
                             P_N_ITMOD  IN NUMBER, 
                             P_N_ITTRAN IN NUMBER,
                             P_N_CODCOM IN NUMBER,
                             P_N_CODCAN IN NUMBER
                             ) return varchar2;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
end PQ_AH_NEW_COMISION;
/

create or replace package body PQ_AH_NEW_COMISION is
  Procedure sp_ah_cal_comision(P_N_PGCOD  IN NUMBER,
                               P_N_ITSUC  IN NUMBER,
                               P_N_ITMOD  IN NUMBER, 
                               P_N_ITTRAN IN NUMBER,
                               P_N_ITNREL IN NUMBER,
                               P_N_ITORD  IN NUMBER,
                               P_N_ITSBO  IN NUMBER,
                               P_D_FECPRO IN DATE,
                               p_n_moncom out number,
                               p_n_nummov out number,   
                               p_c_coderr out varchar2,
                               p_c_msgerr out varchar2                                                            
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
  
  lv_tipper    varchar2(1);
   cursor c_criterios(ln_aqpa109btcp in number,ld_fecpro in date) is
     Select a.* 
       from aqpa109b a 
      where a.aqpa109btcp = ln_aqpa109btcp
        and ld_fecpro 
            between 
            a.aqpa109bfin and 
            case
              when a.aqpa109bffi = to_date('01/01/0001','dd/mm/rrrr') then
                 to_date('31/12/2099','dd/mm/rrrr')
              when a.aqpa109bffi is null then   
                 to_date('31/12/2099','dd/mm/rrrr')
              else
                 a.aqpa109bffi
            end             
        and a.aqpa109best = 'S'
   order by a.aqpa109bpri asc;
   
   cursor c_com_x_trx is      
    Select a.*
      from fst198  a,
           aqpa109 b
     where a.tp1cod   = 1
       and a.tp1cod1  = 10825
       and a.tp1corr1 = 95
       and a.tp1corr2 = 1
       and a.tp1nro1  = P_N_ITMOD
       and a.tp1nro2  = P_N_ITTRAN
       and a.tp1nro3 = b.aqpa109com
       --and b.aqpa109fin <= P_D_FECPRO
       and P_D_FECPRO 
              between 
              b.aqpa109fin and 
              case
                when b.aqpa109ffi = to_date('01/01/0001','dd/mm/rrrr') then
                   to_date('31/12/2099','dd/mm/rrrr')
                when b.aqpa109ffi is null then   
                   to_date('31/12/2099','dd/mm/rrrr')
                else
                   b.aqpa109ffi
              end
       and a.tp1imp2  = 1
       and b.aqpa109est = 'S'       
  order by tp1nro1,tp1nro2,tp1imp1;
  
  ln_aqpa109com  aqpa109.aqpa109com%type;
  ln_aqpa109btcp aqpa109b.aqpa109btcp%type;
  ln_numcri number(9):=0;    
  ln_crican number(9):=0;    
  ln_codcan number(9):=0;       
  ln_codtar number(9):=0;       
  ln_codpre number(9):=0;  
  ln_preesp number(9):=0;  
  ln_rpta   number;    
  lc_indcob char(1); 
  ln_mtoexo number(17,2):=0;
  ln_tipo   number(3):=0;
  ld_fecpro date;    
  ld_fecret date; 
  begin
  p_c_coderr := '000';             
  p_n_moncom := 0;     
  p_n_nummov := 0;  
  p_c_msgerr := '';  
                    
   -- PASO 1 verificamos si la trx mod/trx que comsiones aplican sobre ella
   if fn_ah_aplica_comision(P_N_ITMOD,P_N_ITTRAN,0,P_D_FECPRO) = 'S' then
      --PASO 2 obtenemos los datos del producto
      pq_ah_new_comision.sp_ah_datos_asiento(p_n_pgcod  => P_N_PGCOD, 
                                             p_n_itsuc  => P_N_ITSUC,
                                             p_n_itmod  => P_N_ITMOD,
                                             p_n_ittran => P_N_ITTRAN,
                                             p_n_itnrel => P_N_ITNREL,
                                             p_n_itord  => P_N_ITORD, 
                                             p_n_itsbo  => P_N_ITSBO,                                            
                                             pn_pgcod   => ln_Pgcod, 
                                             pn_ctnro   => ln_ctnro,
                                             pn_itoper  => ln_Itoper,
                                             pn_itsubo  => ln_Itsubo,
                                             pn_itsucd  => ln_Itsucd,
                                             pn_ittope  => ln_Ittope,
                                             pn_modulo  => ln_Modulo,
                                             pn_moneda  => ln_Moneda,
                                             pn_papel   => ln_Papel,
                                             pn_monto   => ln_monto,
                                             pn_indcob  => ln_indcob, 
                                             p_c_coderr => p_c_coderr,
                                             p_c_msgerr => p_c_msgerr
                                            );    
    if p_c_coderr = '000' then
       -- PASO 3 obtenemos el tipo de persona de la cuenta cliente
       pq_ah_new_comision.sp_ah_tipper(p_n_codpgc => ln_Pgcod,
                                       p_n_numcta => ln_ctnro,
                                       p_c_codval => lv_tipper
                                      );     
       if lv_tipper is not null then
         -- PASO 4 verificamos si esta parametrizado comsión por tipo de persona
           For i in c_com_x_trx loop
             ln_aqpa109com := i.tp1nro3; -- codigo de comisión
             ln_codcan     := i.tp1imp3; -- canal sobre el cual aplica
             --Determina si esta exonerado de cobro de la comisión por producto                      
             lc_indcob := pq_ah_new_comision.fn_ah_verifica_exoneracion(p_d_fecpro => P_D_FECPRO,
                                                                        p_n_pgcod  => ln_Pgcod,
                                                                        p_n_ctnro  => ln_ctnro,
                                                                        p_n_itoper => ln_Itoper,
                                                                        p_n_itsubo => ln_Itsubo,
                                                                        p_n_sucdes => ln_Itsucd,
                                                                        p_n_ittope => ln_Ittope,
                                                                        p_n_modulo => ln_Modulo,
                                                                        p_n_moneda => ln_Moneda,
                                                                        p_n_papel  => ln_Papel,
                                                                        p_n_codcom => ln_aqpa109com,
                                                                        p_n_codcan => ln_codcan
                                                                        ); 
                                                                        
             if lc_indcob = 'S' then                                                            
               --VERIFICA EXONERACION PARTICULAR
               lc_indcob := pq_ah_new_comision.fn_ah_exonera_trx(p_n_pgcod  => ln_Pgcod,        
                                                                 p_n_modulo => ln_Modulo,       
                                                                 p_n_sucdes => ln_Itsucd,       
                                                                 p_n_moneda => ln_Moneda,       
                                                                 p_n_papel  => ln_Papel,        
                                                                 p_n_ctnro  => ln_ctnro,        
                                                                 p_n_itoper => ln_Itoper,       
                                                                 p_n_itsubo => ln_Itsubo,       
                                                                 p_n_ittope => ln_Ittope,       
                                                                 p_n_itmod  => P_N_ITMOD,
                                                                 p_n_ittran => P_N_ITTRAN,
                                                                 p_n_codcom => ln_aqpa109com,
                                                                 p_n_codcan => ln_codcan
                                                                 );  
             End if; 
                                                                                     
             if lc_indcob ='S' then                                                                                      
                 -- verifica parametrización de comisión por tipo de persona
                 ln_aqpa109btcp := fn_ah_comtipper(ln_aqpa109com,lv_tipper);
                 --CONTROLAR FECHA PARA TARIFARIO DE COMISIONES DEL STOCK
                 ld_fecpro := pq_ah_new_comision.fn_ah_consulta_stock(p_d_fecpro => P_D_FECPRO,
                                                                      p_n_pgcod  => ln_Pgcod,
                                                                      p_n_modulo => ln_Modulo,
                                                                      p_n_sucdes => ln_Itsucd,
                                                                      p_n_moneda => ln_Moneda,
                                                                      p_n_papel  => ln_Papel, 
                                                                      p_n_ctnro  => ln_ctnro,
                                                                      p_n_itoper => ln_Itoper,                                                                      
                                                                      p_n_itsubo => ln_Itsubo,
                                                                      p_n_ittope => ln_Ittope
                                                                      ); 
                 --OBTENEMOS FECHA LIMITE DE TARIFARIO DE COMISIONES ANTERIOR                                                       
                 begin
                   Select to_date(trim(a.tp1desc),'dd/mm/rrrr') 
                     into ld_fecret
                     from fst198 a 
                    where a.tp1cod   = 1 
                      and a.tp1cod1  = 10825 
                      and a.tp1corr1 = 95 
                      and a.tp1corr2 = 5;
                 exception
                 when others then
                   ld_fecret := null;    
                 end;                                                                       
                 if ld_fecpro = ld_fecret or (ln_Modulo = 22 and ln_aqpa109com <> 11) or (ln_Modulo = 21 and ln_Ittope =2 and ln_aqpa109com in (8,9,10)) then
                    --if ln_aqpa109com in (1,3,6,7) or ln_Modulo = 22 then
                       ln_aqpa109btcp := 0; --FORZAMOS PARA QUE SE VAYA POR LA LOGICA ANTIGUA A ESTAS COMISIONES
                    --End if;
                 End If;                                                                                                                                
                 if ln_aqpa109btcp > 0 then--NUEVA LOGICA
                    --PASO 5 DETERMINAR EL CRITERIO HABILITADO
                    For j in c_criterios(ln_aqpa109btcp,ld_fecpro) loop
                      ln_numcri := j.aqpa109bcri;
                      -- obtenemos de cual de los criterios viegentes en cual calza la cuenta cliente
                      pq_ah_new_comision.sp_ah_det_criterio(p_d_fecpro => P_D_FECPRO,
                                                            pn_pgcod   => ln_Pgcod, 
                                                            pn_ctnro   => ln_ctnro,
                                                            pn_itoper  => ln_Itoper,
                                                            pn_itsubo  => ln_Itsubo,
                                                            pn_itsucd  => ln_Itsucd,
                                                            pn_ittope  => ln_Ittope,
                                                            pn_modulo  => ln_Modulo,
                                                            pn_moneda  => ln_Moneda,
                                                            pn_papel   => ln_Papel,
                                                            pn_monto   => ln_monto,
                                                            pn_numcri  => ln_numcri,
                                                            p_c_coderr => p_c_coderr,
                                                            p_c_msgerr => p_c_msgerr                  
                                                            );
                       --obtenemos criterio vs canal
                       if ln_numcri > 0 then
                          Exit;
                       End If;
                       if ln_numcri < 0 then
                          return;
                       End If;                   
                    end loop; 
                    --PASO 6 una vez determinado el criterio vigente, evaluamos el CANAL que esta realizando la operación y si esta configurado a cobro dicho canal
                    -- validar canal por criterio
                    ln_crican := fn_ah_crican(ln_numcri,ln_codcan);
                    if ln_crican > 0 then
                        /*
                        -- verificamos si hay crédito vigente para cambiar el tipo de operación antes de ubicar el tarifario y el precio
                        if ln_Ittope in (9,12) then
                           pq_ah_comision.sp_ah_monto_ac(p_n_pgcod  => ln_Pgcod,    
                                                         p_n_modulo => ln_Modulo,   
                                                         p_n_ctnro  => ln_ctnro,    
                                                         p_n_itoper => ln_Itoper,   
                                                         p_n_itsubo => ln_Itsubo,   
                                                         p_n_ittope => ln_Ittope,   
                                                         p_n_sucdes => ln_Itsucd,   
                                                         p_n_moneda => ln_Moneda,   
                                                         p_n_papel  => ln_Papel,    
                                                         p_d_fecpro => P_D_FECPRO,  
                                                         p_n_mtoexo => ln_mtoexo
                                                         );
                            if ln_mtoexo >0 then --tiene credito vigente
                               ln_tipo := 9; --flexible con credito
                            Else
                               ln_tipo := 12;--flexible sin credito
                            End if; 
                        Else
                          ln_tipo := ln_Ittope;                                                        
                        End if;
                        */
                        
                       --ln_tipo := ln_Ittope; 
                        --VERIFICAMOS SI ES CUENTA SUELDO Y HAY ABONO E LOS ULTIMOS X MESES
                        if ln_Modulo = 21 And ln_Ittope = 6 then
                          if fn_ah_abono_n_meses(P_D_FECPRO,
                                                 ln_Pgcod,
                                                 ln_Modulo,
                                                 ln_Itsucd,
                                                 ln_Moneda,
                                                 ln_Papel,
                                                 ln_ctnro,
                                                 ln_Itoper,
                                                 ln_Itsubo,
                                                 ln_Ittope) = 'N' then    
                            ln_tipo := 3;                       
                          Else
                            ln_tipo := ln_Ittope;                         
                          End if;
                        Else
                          ln_tipo := ln_Ittope;                             
                        End if;                       
                       -- Determina tarifario por modeda/sucursal/tipo de producto/modulo/
                        pq_ah_new_comision.sp_ah_tarifario_comision(pn_crican  => ln_crican,                                                                 
                                                                    pn_itsucd  => ln_Itsucd,
                                                                    pn_ittope  => ln_tipo,--ln_Ittope,
                                                                    pn_modulo  => ln_Modulo,
                                                                    pn_moneda  => ln_Moneda,                                                              
                                                                    pn_codtar  => ln_codtar,  --codigo de tarifario
                                                                    pn_codpre  => ln_codpre,  --codigo de precio
                                                                    p_c_coderr => p_c_coderr, 
                                                                    p_c_msgerr => p_c_msgerr                  
                                                                   );
                        if p_c_coderr = '000' then                                                                              
                           --Determina si tiene algun tarifario especial para la comisión y canal por producto
                           ln_preesp := pq_ah_new_comision.fn_ah_verifica_tar_especial(p_d_fecpro => P_D_FECPRO,
                                                                                       p_n_pgcod  => ln_Pgcod,
                                                                                       p_n_ctnro  => ln_ctnro,
                                                                                       p_n_itoper => ln_Itoper,
                                                                                       p_n_itsubo => ln_Itsubo,
                                                                                       p_n_sucdes => ln_Itsucd,
                                                                                       p_n_ittope => ln_Ittope,
                                                                                       p_n_modulo => ln_Modulo,
                                                                                       p_n_moneda => ln_Moneda,
                                                                                       p_n_papel  => ln_Papel,
                                                                                       p_n_codcom => ln_aqpa109com,
                                                                                       p_n_codcan => ln_codcan
                                                                                       );                      
                                  
                            /*if ln_preesp <> 0 then
                              ln_codpre := ln_preesp;
                            End If; */                  
                              
                          --
                          -- DEPENDIENDO DEL TIPO DE COMISION EJECUTAMOS EL PROCEDIMIENTO CORRESPONDIENTE
                          --
                          Case
                            when i.tp1nro3 = 1 then --New Interplaza                              
                                pq_ah_new_comision.sp_ah_interplaza(p_n_pgcod  => P_N_PGCOD, 
                                                                    p_n_itsuc  => P_N_ITSUC,
                                                                    p_n_itmod  => P_N_ITMOD,
                                                                    p_n_ittran => P_N_ITTRAN,
                                                                    p_n_itnrel => P_N_ITNREL,
                                                                    p_n_itord  => P_N_ITORD, 
                                                                    p_n_itsbo  => P_N_ITSBO,   
                                                                    p_d_fecpro => P_D_FECPRO, 
                                                                    pn_pgcod   => ln_Pgcod, 
                                                                    pn_ctnro   => ln_ctnro,
                                                                    pn_itoper  => ln_Itoper,
                                                                    pn_itsubo  => ln_Itsubo,
                                                                    pn_itsucd  => ln_Itsucd,
                                                                    pn_ittope  => ln_Ittope,
                                                                    pn_modulo  => ln_Modulo,
                                                                    pn_moneda  => ln_Moneda,
                                                                    pn_monto   => ln_monto,
                                                                    pn_btcp    => ln_aqpa109btcp,                                                            
                                                                    pn_codtar  => ln_codtar,
                                                                    pn_codpre  => ln_codpre,
                                                                    pn_codcom  => ln_aqpa109com,
                                                                    pn_preesp  => ln_preesp,
                                                                    p_n_moncom => p_n_moncom,
                                                                    p_n_nummov => p_n_nummov,
                                                                    p_c_coderr => p_c_coderr,
                                                                    p_c_msgerr => p_c_msgerr
                                                                    );
                             Else --cualquier otra comisión                                                                                                                                                                 
                             --when i.tp1nro3 in (3,6,7,8,9) then --New Exceso de retiros, depositos op
                                 pq_ah_new_comision.sp_ah_calcula_comision(p_d_fecpro => P_D_FECPRO,
                                                                           p_n_pgcod  => ln_Pgcod,
                                                                           p_n_ctnro  => ln_ctnro,
                                                                           p_n_itoper => ln_Itoper,
                                                                           p_n_itsubo => ln_Itsubo,
                                                                           p_n_sucdes => ln_Itsucd,
                                                                           p_n_ittope => ln_Ittope,
                                                                           p_n_modulo => ln_Modulo,
                                                                           p_n_moneda => ln_Moneda,
                                                                           p_n_papel  => ln_Papel,
                                                                           p_n_monto  => ln_monto,
                                                                           p_n_codtar => ln_codtar,--codigo de tarifario calculado
                                                                           p_n_codpre => ln_codpre,--codigo de precio en caso tenga especial enviarlo
                                                                           p_n_codcom => ln_aqpa109com,
                                                                           p_n_preesp => ln_preesp,
                                                                           p_n_moncom => ln_moncom,
                                                                           p_n_nummov => ln_nummov,
                                                                           p_c_coderr => p_c_coderr, 
                                                                           p_c_msgerr => p_c_msgerr                                                                         
                                                                           );  
                                                                                   
                                     if ln_indcob > 0 then
                                         ln_nummov := ln_indcob;          
                                     End If;
                                                                                                  
                                     pq_ah_new_comision.sp_ah_graba_importe_comisio(p_n_pgcod   => P_N_PGCOD,
                                                                                     p_n_itsuc  => P_N_ITSUC,
                                                                                     p_n_itmod  => P_N_ITMOD,
                                                                                     p_n_ittran => P_N_ITTRAN,
                                                                                     p_n_itnrel => P_N_ITNREL,
                                                                                     p_n_itord  => P_N_ITORD,
                                                                                     p_n_itsbo  => P_N_ITSBO,
                                                                                     p_n_codcom => ln_aqpa109com,--exceso retiros
                                                                                     p_n_monto1 => ln_moncom,
                                                                                     p_n_monto2 => ln_nummov,
                                                                                     p_c_coderr => p_c_coderr,
                                                                                     p_c_msgerr => p_c_msgerr
                                                                                    );  
                                      
                                     p_n_nummov := ln_nummov;
                                     p_n_moncom := ln_moncom;                                                                            
/*                            when i.tp1nro3 = 6 then --New Exceso de depósitos      
                                 pq_ah_new_comision.sp_ah_calcula_comision(p_d_fecpro => P_D_FECPRO,
                                                                           p_n_pgcod  => ln_Pgcod,
                                                                           p_n_ctnro  => ln_ctnro,
                                                                           p_n_itoper => ln_Itoper,
                                                                           p_n_itsubo => ln_Itsubo,
                                                                           p_n_sucdes => ln_Itsucd,
                                                                           p_n_ittope => ln_Ittope,
                                                                           p_n_modulo => ln_Modulo,
                                                                           p_n_moneda => ln_Moneda,
                                                                           p_n_papel  => ln_Papel,
                                                                           p_n_monto  => ln_monto,
                                                                           p_n_codtar => ln_codtar,-- codigo de tarifario calculado
                                                                           p_n_codpre => ln_codpre,--codigo de precio en caso tenga especial enviarlo
                                                                           p_n_codcom => ln_aqpa109com,
                                                                           p_n_moncom => ln_moncom,
                                                                           p_n_nummov => ln_nummov,
                                                                           p_c_coderr => p_c_coderr, 
                                                                           p_c_msgerr => p_c_msgerr                                                                         
                                                                           );  
                                                                                   
                                     if ln_indcob > 0 then
                                         ln_nummov := ln_indcob;          
                                     End If;
                                                                                                  
                                     pq_ah_new_comision.sp_ah_graba_importe_comisio(p_n_pgcod   => P_N_PGCOD,
                                                                                     p_n_itsuc  => P_N_ITSUC,
                                                                                     p_n_itmod  => P_N_ITMOD,
                                                                                     p_n_ittran => P_N_ITTRAN,
                                                                                     p_n_itnrel => P_N_ITNREL,
                                                                                     p_n_itord  => P_N_ITORD,
                                                                                     p_n_itsbo  => P_N_ITSBO,
                                                                                     p_n_codcom => ln_aqpa109com,--exceso retiros
                                                                                     p_n_monto1 => ln_moncom,
                                                                                     p_n_monto2 => ln_nummov,
                                                                                     p_c_coderr => p_c_coderr,
                                                                                     p_c_msgerr => p_c_msgerr
                                                                                    );  
                                      
                                     p_n_nummov := ln_nummov;
                                     p_n_moncom := ln_moncom;*/ 
                            --Else
                               --p_c_msgerr :='No se encontró comsiión a validar'; 
                          End Case;                   
                        End If;
                    Else
                       p_c_coderr := '002';
                       p_c_msgerr := 'No existe parametrización de canal para criterio a evaluar';
                      return;
                    End If;
                 else --MODULO ANTERIOR
                   -- si no hay parametrizacion es porque utiliza módulo anterior
                    if ln_aqpa109com = 1 then -- interplaza                  
                        pq_ah_new_comision.sp_ah_interplaza(p_n_pgcod  => P_N_PGCOD, 
                                                            p_n_itsuc  => P_N_ITSUC,
                                                            p_n_itmod  => P_N_ITMOD,
                                                            p_n_ittran => P_N_ITTRAN,
                                                            p_n_itnrel => P_N_ITNREL,
                                                            p_n_itord  => P_N_ITORD, 
                                                            p_n_itsbo  => P_N_ITSBO,   
                                                            p_d_fecpro => P_D_FECPRO, 
                                                            pn_pgcod   => ln_Pgcod, 
                                                            pn_ctnro   => ln_ctnro,
                                                            pn_itoper  => ln_Itoper,
                                                            pn_itsubo  => ln_Itsubo,
                                                            pn_itsucd  => ln_Itsucd,
                                                            pn_ittope  => ln_Ittope,
                                                            pn_modulo  => ln_Modulo,
                                                            pn_moneda  => ln_Moneda,
                                                            pn_monto   => ln_monto,
                                                            pn_btcp    => ln_aqpa109btcp,                                                            
                                                            pn_codtar  => ln_codtar,
                                                            pn_codpre  => ln_codpre,
                                                            pn_codcom  => ln_aqpa109com,
                                                            pn_preesp  => ln_preesp,
                                                            p_n_moncom => p_n_moncom,
                                                            p_n_nummov => p_n_nummov,
                                                            p_c_coderr => p_c_coderr,
                                                            p_c_msgerr => p_c_msgerr
                                                            );                                                                                                                        
                    else--exceso de retiros, depositos op   
                      --if ln_aqpa109com in (3,6,7,8,9) then -- exceso de retiros, depositos op   
                          pq_ah_comision.sp_ah_cal_comision(p_n_pgcod  => P_N_PGCOD, 
                                                            p_n_itsuc  => P_N_ITSUC,
                                                            p_n_itmod  => P_N_ITMOD,
                                                            p_n_ittran => P_N_ITTRAN,
                                                            p_n_itnrel => P_N_ITNREL,
                                                            p_n_itord  => P_N_ITORD, 
                                                            p_n_itsbo  => P_N_ITSBO,    
                                                            p_n_moncom => p_n_moncom,
                                                            p_n_nummov => p_n_nummov
                                                            );     
                           p_c_coderr := '000';
                           p_c_msgerr := to_char(ln_moncom,'9,999,999.00')||'-'||to_char(ln_nummov); 
                       --else
                          --p_c_coderr := '00x';
                          --p_c_msgerr := 'No se reconoce acción';
                       --End if;                                                                                                                     
                    End If;
                 End If;
             Else
               p_c_msgerr := 'Producto exonerado de cobro de comisión';
             End if;                 
           end loop;
       else
           p_c_coderr := '001';
           p_c_msgerr := 'No se reconoce tipo de persona';
       End If;                                
    end if;                                            
   Else
     p_c_msgerr := 'No aplican comisiones sobre la transacción especificada';
   End If;
  exception
  when others then  
   p_c_coderr := sqlcode;
   p_c_msgerr := sqlerrm;
  end sp_ah_cal_comision;   
  Procedure sp_ah_calcula_comision(P_D_FECPRO IN DATE,
                                   P_N_PGCOD  IN NUMBER,
                                   P_N_CTNRO  IN NUMBER,
                                   P_N_ITOPER IN NUMBER,
                                   P_N_ITSUBO IN NUMBER,
                                   P_N_SUCDES IN NUMBER,
                                   P_N_ITTOPE IN NUMBER,
                                   P_N_MODULO IN NUMBER,
                                   P_N_MONEDA IN NUMBER,
                                   P_N_PAPEL  IN NUMBER,
                                   P_N_MONTO  IN NUMBER,
                                   P_N_CODTAR IN NUMBER,
                                   P_N_CODPRE IN NUMBER,
                                   P_N_CODCOM IN NUMBER,
                                   P_N_PREESP IN NUMBER,
                                   p_n_moncom out number,
                                   p_n_nummov out number,
                                   p_c_coderr out varchar2, 
                                   p_c_msgerr out varchar2
                                  ) is
  ln_salrem    number(17,2) := 0;
  ln_salter    number(17,2) := 0;
  ln_monto     number(17,2) := 0;
  ln_monrub    number(17,2) := 0;     
  ln_monexo    number(17,2) := 0;         
  lc_indcob    char(1):= 'S';  
  ln_totmov    number(10) := 0;       
  ln_codmod    number(3) := 0;
  ln_codcod    number(3) := 0;
  ln_topmov    number(3) := 0;
  ln_topsal    number(17,2) := 0;
                        
  begin
    p_c_coderr :='000';
    p_n_moncom := 0;
    p_n_nummov := 0;  
    ln_monto   := P_N_MONTO;
    if P_N_CODCOM = 3 then --EXCESO DE RETIROS
      /* CAMBIOS COMISIONES REMUNERACION MIXTA*/
      if P_N_ITTOPE = 6 and P_N_MODULO = 21 then
          --obtenemos el monto actual de remuneraciones

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
      End if;
        
      /*--CAMBIOS MONTO EXONERADO*/                 
      --obtenemos el monto del rubro de exoneracion

      pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => P_N_PGCOD,
                                       p_n_ctnro  => P_N_CTNRO,
                                       p_n_itoper => P_N_ITOPER,
                                       p_n_itsubo => P_N_ITSUBO,
                                       p_n_sucdes => P_N_SUCDES,
                                       p_n_moneda => P_N_MONEDA,
                                       p_n_papel  => P_N_PAPEL,
                                       p_n_monto  => ln_monrub
                                       );
           
      ln_monexo := ln_salrem + ln_monrub;                         
             
     if ln_monexo >= ln_monto then
        lc_indcob := 'N';
        p_n_nummov := 0;
     else
        lc_indcob := 'S';  
        p_n_nummov := -1;
     end if; 
     
     --Adicionar validación extra si ha recibido abonos en los ultimos 2 meses puede retirar 
     --sin comision asi toque saldo de terceros
     /*
     if lc_indcob = 'S' and  P_N_ITTOPE = 6 then
       if fn_ah_abono_n_meses(P_D_FECPRO,
                              P_N_PGCOD,
                              P_N_MODULO,
                              P_N_SUCDES,
                              P_N_MONEDA,
                              P_N_PAPEL,
                              P_N_CTNRO,
                              P_N_ITOPER,
                              P_N_ITSUBO,
                              P_N_ITTOPE) = 'S' then
         lc_indcob := 'N';
       end if;
     end if;  
     */       
   End If;                                                                                                                                      
       
   If lc_indcob = 'S' then
      -- detalle del precio
      pq_ah_new_comision.sp_ah_det_precio(p_n_codpre => P_N_CODPRE,
                                          p_n_codmod => ln_codmod,
                                          p_n_codcod => ln_codcod,
                                          p_n_topmov => ln_topmov,
                                          p_n_topsal => ln_topsal,
                                          p_c_coderr => p_c_coderr,
                                          p_c_msgerr => p_c_msgerr
                                          );   
      if P_N_PREESP > 0 then      
         ln_codcod := P_N_PREESP; 
      End If;                                           
                                          
       --verificamos cantidad de movimientos por canal  
       
      ln_totmov := pq_ah_new_comision.fn_ah_mov_canal(p_d_fecpro => P_D_FECPRO,
                                                      p_n_codtar => P_N_CODTAR,
                                                      p_n_nummov => p_n_nummov,
                                                      p_n_codcom => P_N_CODCOM,
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
            
          If  ln_totmov >= ln_topmov then
              -- calcula comisión
             If P_N_MONEDA = 101 Then
                ln_monto := round(ln_monto* fn_tipo_cambio(fecha  => P_D_FECPRO,--trunc(sysdate),
                                                           monori => P_N_MONEDA,
                                                           mondes => 0,
                                                           tipo   => 500
                                                           ),2);
             End If; 
             
            
                                         
             p_n_moncom := pq_ah_comision.fn_ah_monto_comision(p_n_modcom => ln_codmod,
                                                               p_n_codcom => ln_codcod,
                                                               p_n_monmov => ln_monto
                                                               );
             If P_N_MONEDA = 101 Then
                p_n_moncom := round(p_n_moncom/ fn_tipo_cambio(fecha  => P_D_FECPRO,--trunc(sysdate),
                                                               monori => P_N_MONEDA,
                                                               mondes => 0,
                                                               tipo   => 500
                                                               ),2);
             End If; 
         End If;            
       End If;
       --p_n_nummov := ln_totmov;
  exception
  when others then
     p_c_coderr := sqlcode;  
     p_c_msgerr := sqlerrm;      
  End sp_ah_calcula_comision;          
  procedure sp_ah_verif_tablas16(ln_cuenta in number,
                                 ln_scsuc  in number,--
                                 ln_modulo in number,--
                                 ln_opera  in number,--
                                 ln_tipo   in number,--
                                 ln_moneda in number,--
                                 ln_subope in number,
                                 ln_trans  in number,
                                 ln_rel    in number,
                                 ld_fecha  in date,
                                 ln_pitsuc in number,
                                 ln_pitmod in number,
                                 ln_pitord in number,
                                 ln_pitsbor in number,
                                 ln_monto  in number,
                                 lc_rpta   out number,
                                 P_N_CODTAR IN NUMBER,
                                 P_N_CODPRE IN NUMBER,
                                 P_N_CODCOM IN NUMBER,
                                 P_N_PREESP IN NUMBER,
                                 p_n_moncom out number,
                                 p_n_nummov out number,
                                 p_c_coderr out varchar2, 
                                 p_c_msgerr out varchar2                                 
                                 )is
                                 
                                  



---------------------------------------------------------------------------------------------------------------------------------
  cursor BuscaDiaT16 is
       select  trunc(f6.itimp3),
               f6.itsuc,
               decode(f6.modulo,174,((f6.itimp1)*-1),f6.itimp1) itimp1,
               f6.itimp9,
               f6.itimp13,
               f6.itmod,
               f6.ittran,
               f6.itnrel,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f6.itimp3)) as plaza1,
               (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd ) as plaza2
          from fsd016 f6,
               aqpa109f f8,
               fsd015 f5
         where f6.pgcod = 1
           and f6.itmod = f8.aqpa109fmod
           and f6.ittran = f8.aqpa109ftrx
           and f6.itnrel <> ln_rel
           and f6.itord = f8.aqpa109ford
           and f8.aqpa109ftar = P_N_CODTAR           
           and (f6.modulo  in (21,22) or (f6.modulo =174 and f6.rubro = 9300070800001)) 
           and f6.itsucd = ln_scsuc
           and f6.moneda = ln_moneda
           and f6.papel = 0
           and f6.itimp3 <> 0.00
           and f6.itimp1 <> 0.00
           and f6.ctnro =  ln_cuenta
           and f6.itoper = ln_opera
           and f6.itsubo = ln_subope
           and f5.itsuc = f6.itsuc
           and f5.pgcod = f6.pgcod
           and f5.itmod = f6.itmod
           and f5.ittran = f6.ittran
           and f5.itnrel = f6.itnrel
           and f5.itcorr <> 99
           and f5.itcont = 'S'
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itimp3) <>(select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd );

  cursor BuscaHisT16 (FechaIn in date,FechaFin in date) is
        select trunc(f.hcimp3),
               f.hsucor,
               decode(f.hmodul,174,((f.hcimp1)*-1),f.hcimp1) hcimp1,
               f.hfcon,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f.hcimp3)) as plaza1, ---f6.itimp3
               (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur ) as plaza2
          from fsh016 f,
               fsh015 h,
               aqpa109f f8
         where f.pgcod = 1
           and f.hcmod = f8.aqpa109fmod --moduno
           and f.htran = f8.aqpa109ftrx ---tranuno
           and f.hcord = f8.aqpa109ford --orduno
           and f8.aqpa109ftar = P_N_CODTAR
           and f.hfcon between FechaIn and FechaFin ---ld_fecfin
           and (f.hmodul in (21,22) or (f.hmodul =174 and f.hrubro =9300070800001 )) --- 24/05/2019
           and f.hsucur = ln_scsuc
           and f.hmda   = ln_moneda
           and f.hpap   = 0
           and f.hcta   = ln_cuenta
           and f.hoper  = ln_opera
           and f.hsubop = ln_subope
           and f.hcimp3 <> 0.00
           and h.pgcod  = f.pgcod
           and h.hcmod  = f.hcmod
           and h.hsucor = f.hsucor
           and h.htran = f.htran
           and h.hnrel = f.hnrel
           and h.hfcon = f.hfcon
           and h.hccorr <> 99
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f.hcimp3) <> (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur );

   cursor BuscaOffline(P_fecha in date) is
     select nvl(sum(decode(z1.z0e4gcesm,1,1,-1)),0) operacion ,
            nvl(sum(decode(z1.z0e4gcesm,1,1* z1.z0e4gcimd,-1*z1.z0e4gcimd)),0) monto
          from z0e4gc z1,
               z0e475 z2
         where z1.z0e4gcest = 'ZZ'
           and z1.z0e4gcesm in (1,3)
           and z1.z0e4gctop in (1,2)
           and z1.z0e4gcfec = P_fecha
           and z1.z0e4gcdpg = 1
           and z1.z0e4gcdmd = ln_modulo
           and z1.z0e4gcdmo = ln_moneda
           and z1.z0e4gcdpa = 0
           and z1.z0e4gcdct = ln_cuenta
           and z1.z0e4gcdop = ln_opera
           and z1.z0e4gcdsc = ln_subope
           and z1.z0e4gcdto = ln_tipo
           and z1.z0e4gcdsu = ln_scsuc
           and z2.z0e475cod = z1.z0e4gcter
           and (select jaqy657pza  from jaqy657 where jaqy657suc = z2.z0e475suc) <> (select jaqy657pza  from jaqy657 where jaqy657suc = z1.z0e4gcdsu );

  v_cont1    number;
  v_monto    number(17,2);
  v_ctrl1    number;
  v_ctrl2    number;
  control    number;
  FechaInicial date;
  FechaFin   date;
  ln_moncom  number(17,2):= 0;
  lc_indcob  char(1):= 'S';
  MontoEx    number(17,2);
  NroOpe     number(1);

  lc_indoff  char(1);
  ln_monsal  number(17,2) := 0;
  ln_monrub  number(17,2) := 0;
  ln_monexo  number(17,2) := 0;
  ln_monret  number(17,2) := 0;
  ln_marca   number(17,2) := 0;
  ln_monto1  number(17,2) := 0;
  valor      number(1)    := 0;
  ln_tp1imp2 number(1)    := 0;
  ln_montoV  number(17,2) := 0;
  ld_fechaB  date;
  montoCol   number(17,2) := 0;
  ln_salrem  number(17,2) := 0;
  ln_salter  number(17,2) := 0;
  SaldoMtoB  number(17,2) := 0;
  ln_monrub1 number(17,2) := 0;
  sucursal   number(3):=0;
  -------------------------------
  monto_cte  number;
  IndCredVi  char(1);
  ln_monmov  number;
  ingreso9   char(1):='N';  
  --lc_error   varchar2(500);
  
  --nuevas variables
  ln_canal     number :=0;
  ln_codmod    number(3) := 0;
  ln_codcod    number(3) := 0;
  --ln_topmov    number(3) := 0;
  --ln_topsal    number(17,2) := 0;    
  ld_fecini    date;
  Begin
  p_n_moncom := 0;
  p_n_nummov := 0;
  p_c_coderr :='000';
  --obtenemos el canal para evaluar las fechas de exoneración

  begin
   select a.aqpa109dcan
     into ln_canal
     from aqpa109d a,
          aqpa109e b
     where a.aqpa109dcct = b.aqpa109ecct
       and b.aqpa109etar = P_N_CODTAR;
  Exception
  When others then
    ln_canal := 0;               
  end;     
    
            v_monto := 0;
            v_cont1 := 0;--1; SE CMBIO YLOZADA
            v_ctrl1 := 0;
            v_ctrl2 := 0;
            control := 0;
            MontoEx := 0;
            NroOpe  := 0;

            lc_indoff := null;
            ld_fechab := ld_fecha;
     /*       select pgfape
              into ld_fechaB
              from fst017
             where pgcod = 1;*/

            /*--CAMBIOS MONTO EXONERADO*/
            --determina si la trx es de ingreso o de egreso
            begin
              select --tp1imp2
                     tp1imp1,tp1imp2
                into valor,ln_tp1imp2
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10884
                 and TP1CORR1 = 3
                 and TP1CORR2 = 1
                 and tp1nro1 = ln_pitmod
                 and tp1nro2 = ln_trans
                 and tp1nro3 = ln_pitord
                 and tp1imp1 = 1
                 and tp1imp3 = ln_canal;
            exception
              when no_data_found then
                valor := 0;
            end;
            if ln_tipo = 9 and ln_modulo = 21 then
             --CON ESTE PROCEDIMIENTO TE RETORNA EL MONTO ACTUAL DISPONIBLE DE LA BOLSA Y EL INDICADOR SI AUN TIENNE CREDITOS VIGENTES ASOCIADOS A DICHA CUENTA DE AHORRO CORRIENTE
             -- Call the procedure
/*              pq_ah_comision.sp_ah_consu_bolsa(p_n_pgcod => 1,
                                               p_n_modulo => ln_modulo,
                                               p_n_sucdes => ln_scsuc,
                                               p_n_moneda => ln_moneda,
                                               p_n_papel => 0,
                                               p_n_ctnro => ln_cuenta,
                                               p_n_itoper => ln_opera,
                                               p_n_itsubo => ln_subope,
                                               p_n_ittope => ln_tipo,
                                               p_d_fecpro => ld_fecha,
                                               p_n_mtosal => monto_cte, --SALDO RESTANTE EN BOLSA
                                               p_c_indcre => IndCredVi); --INDICADOR DE CREDITO S= SI TIENE N= NO TIENE
*/

             monto_cte :=0;
             IndCredVi := 'N';
            end if;

            if valor = 1 then
         /*     lc_indcob := Pq_Ah_Com_Interplaza.fn_valida_cobrocom (ln_cuenta,-- datos de la cuenta
                                                                    ln_scsuc,--
                                                                    ln_modulo,--
                                                                    ln_opera,--
                                                                    ln_tipo,--
                                                                    ln_moneda,--
                                                                    ln_subope,
                                                                    ld_fecha,
                                                                    ln_canal);
              Begin
              select 'N'
                into lc_indcob
                from fst198
               where TP1COD = 1
                 and TP1COD1 = 10884
                 and TP1CORR1 = 1
                 and TP1CORR2 = 1
                 and tp1nro1 = ln_tipo
                 and tp1nro2 = ln_modulo;
            Exception
              When no_data_found then
                lc_indcob := 'S';
            end;*/
            lc_indcob:='S';

              if lc_indcob = 'S' and ln_tp1imp2 = 1 /*and  ln_tipo <> 9*/  then ---2016/11/25
                   --verificamos si la cuenta cliente es dependiente o independiente para a partir de eso determinar el monto exonerado
                   --obtenemos el monto del rubro de exoneracion
                 if  ln_tipo <> 6 or ln_modulo = 22 then

                      pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => 1,
                                                       p_n_ctnro  => ln_cuenta,
                                                       p_n_itoper => ln_opera,
                                                       p_n_itsubo => ln_subope,
                                                       p_n_sucdes => ln_scsuc,
                                                       p_n_moneda => ln_moneda,
                                                       p_n_papel  => 0,
                                                       p_n_monto  => ln_monrub
                                                       );

                 else
                     if ln_tipo = 6 and ln_modulo = 21 then ---23.03.2017
                        pq_ah_comision.sp_ah_saldos_remu(p_n_pgcod  => 1,
                                                         p_n_modulo => ln_modulo,
                                                         p_n_ctnro  => ln_cuenta,
                                                         p_n_itoper => ln_opera,
                                                         p_n_itsubo => ln_subope,
                                                         p_n_ittope => ln_tipo,
                                                         p_n_sucdes => ln_scsuc,
                                                         p_n_moneda => ln_moneda,
                                                         p_n_papel  => 0,
                                                         p_n_saldo  => ln_salrem,
                                                         p_n_salte  => ln_salter
                                                        );
                         --monto exonerado por rubro
                      pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => 1,
                                                       p_n_ctnro  => ln_cuenta,
                                                       p_n_itoper => ln_opera,
                                                       p_n_itsubo => ln_subope,
                                                       p_n_sucdes => ln_scsuc,
                                                       p_n_moneda => ln_moneda,
                                                       p_n_papel  => 0,
                                                       p_n_monto  => ln_monrub1
                                                       );

                         if (ln_salrem + ln_monrub1) > 0  and ln_tp1imp2 = 1 then
                           ln_monrub := ln_salrem+ln_monrub1 ;
                         else
                            ln_monrub := 0;
                         end if;
                      end if;
                 end if;
                   ln_monexo := ln_monsal + ln_monrub;
                    --obtenemos total monto retirado SIN AFECTO A COMISION

                   ln_monret := ln_monret + ln_monto; --total retirado incluido movimiento actual

                   if ln_monexo >= ln_monret then ---ln_monto then ----
                      lc_indcob := 'N';
                      ln_marca := 0;
                      SaldoMtoB := ln_monret;

                   else
                      lc_indcob := 'S';
                      if ln_monexo <> 0 then
                         ln_marca := ln_monto - ln_monexo;
                         SaldoMtoB :=ln_monexo;
                      else
                         ln_marca := ln_monto;--0;
                      end if;
                   end if;
                   
                   --Adicionar validación extra si ha recibido abonos en los ultimos 2 meses puede retirar 
                   --sin comision asi toque saldo de terceros
                   /*
                   if lc_indcob = 'S' and ln_tipo = 6 and ln_modulo = 21 then
                     if fn_ah_abono_n_meses(ld_fecha,
                                            1,
                                            ln_modulo,
                                            ln_scsuc,
                                            ln_moneda,
                                            0,
                                            ln_cuenta,
                                            ln_opera,
                                            ln_subope,
                                            ln_tipo) = 'S' then
                       lc_indcob := 'N';
                     end if;
                   end if; 
                   */
                   if SaldoMtoB > 0 and ln_tipo = 6 and ln_modulo = 21 then
                        begin
                            if ln_pitsuc = 902 then
                                Begin
                                   select PfdSu03
                                     into sucursal
                                     from fsd603
                                    where PgCod = 1
                                      and Itsuc = ln_pitsuc
                                      and Itmod = ln_pitmod
                                      and Ittran = ln_trans
                                      and Itnrel = ln_rel;
                                exception
                                  when no_data_found then
                                    sucursal:= 0;
                                end;
                            else
                              sucursal:= ln_pitsuc;
                            end if;

                            insert into fsd016(pgcod, itsuc,itmod,ittran, itnrel, itord, itsbor, modulo,ittope,itsucd,rubro, moneda,papel, ctnro,
                                               itoper,itsubo, itfval, itfvto, itpzo, itper, itttas, ittasa, ittmor, ittdia, ittvto,  ittano,
                                               ittint, itarb, itarb1, itmd, itmd1, ittcbi, ittcbi1, itpre, itpre1, itdrev, itafiv,itafgt, itplus,
                                               itcodm, itser, itcheq, itimp1,itimp2, itimp3, itimp4, itimp5, itimp6, itimp7, itimp8, itimp9, itimp10,
                                               itimp11, itimp12, itimp13, itimp14, itimp15, itimp16, itimp17, itimp18,itimp19, itimp20,
                                               itimpo, itmdao,  itdbha, itncor, itbbtt, itfunc, itsegm, itccos, itcbcu, itccli,itref, itanu,
                                               itposic, itvalua,itcltcod, itpza, itdcom)
                                            values
                                              (1, ln_pitsuc,ln_pitmod, ln_trans, ln_rel, 45 ,2 , --ln_pitord, ln_pitsbor,
                                               174, 0, ln_scsuc,9300070800001, ln_moneda, 0, ln_cuenta, ln_opera, ln_subope, ld_fecha,
                                               to_date('01/01/0001', 'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, 'N', 0, null, 0, 0, null, null, 0,
                                               1,0, 0, 0, 'N', 'N', 0, 0, null, 0,  SaldoMtoB, --impt1
                                               0,
                                               sucursal,--ln_pitsuc, ---bolsa
                                               0, 0, 0, 0, 0, 0,  0, 0, --impt11
                                               0, 0, 0,0, 0,0,0,0,0, --fin importes
                                               0,0,2, 0,null, 0,0, 0, 0,0, null,'N', 0, 0,0,0, 0);

                             insert into fsd016(pgcod, itsuc,itmod,ittran, itnrel, itord, itsbor, modulo,ittope,itsucd,rubro, moneda,papel, ctnro,
                                               itoper,itsubo, itfval, itfvto, itpzo, itper, itttas, ittasa, ittmor, ittdia, ittvto,  ittano,
                                               ittint, itarb, itarb1, itmd, itmd1, ittcbi, ittcbi1, itpre, itpre1, itdrev, itafiv,itafgt, itplus,
                                               itcodm, itser, itcheq, itimp1,itimp2, itimp3, itimp4, itimp5, itimp6, itimp7, itimp8, itimp9, itimp10,
                                               itimp11, itimp12, itimp13, itimp14, itimp15, itimp16, itimp17, itimp18,itimp19, itimp20,
                                               itimpo, itmdao,  itdbha, itncor, itbbtt, itfunc, itsegm, itccos, itcbcu, itccli,itref, itanu,
                                               itposic, itvalua,itcltcod, itpza, itdcom)
                                            values
                                              (1, ln_pitsuc,ln_pitmod, ln_trans, ln_rel,53,2,-- ln_pitord, ln_pitsbor,
                                               457, 0, ln_scsuc,9300071800001, ln_moneda, 0, 0, ln_opera, 0, to_date('01/01/0001', 'dd/mm/yyyy'),
                                               to_date('01/01/0001', 'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, 'N', 0, null, 0, 0, null, null, 0,
                                               1,0, 0, 0, 'N', 'N', 0, 0, null, 0,  SaldoMtob, --impt1
                                               0,
                                               0, ---bolsa
                                               0, 0, 0, 0, 0, 0,  0, 0, --impt11
                                               0, 0, 0,0, 0,0,0,0,0, --fin importes
                                               0,0,1, 0,null, 0,0, 0, 0,0, null,'N', 0, 0,0,0, 0);
                               commit;
                        exception
                          when dup_val_on_index then
                            null;
                        end;
                   end if;
              end if;
             /*-FIN CAMBIOS -*/
          else
/*             Begin
              select 'N'
                into lc_indcob
                from fst198
               where TP1COD = 1
                 and TP1COD1 = 10884
                 and TP1CORR1 = 1
                 and TP1CORR2 = 1
                 and tp1nro1 = ln_tipo
                 and tp1nro2 = ln_modulo;
            Exception
              When no_data_found then
                lc_indcob := 'S';
            end;*/
            lc_indcob :='S';
          end if;
          IF lc_indcob = 'S' THEN
         

                -- Fecha Inicial y Final -- FechaInicial := to_date('01'||TO_CHAR(SYSDATE,'MM')||TO_CHAR(SYSDATE,'YYYY'),'dd/mm/yyyy');
/*                select to_date('01' || TO_CHAR(pgfape, 'MM') || TO_CHAR(pgfape, 'YYYY'),'dd/mm/yyyy'),
                       last_day(pgfape)
                  into FechaInicial,
                       FechaFin
                  from fst017
                 where pgcod = 1;*/
                 
                 --
                 -- meter la validación de exoneracion por parte de los dias
                 -- 

                 
                select to_date('01' || TO_CHAR(ld_fecha, 'MM') || TO_CHAR(ld_fecha, 'YYYY'),'dd/mm/yyyy'),
                       last_day(ld_fecha)
                  into FechaInicial,
                       FechaFin
                  from fst017
                 where pgcod = 1;  
                                   
                  begin
                   select max(JAQL485FEF)
                     into ld_fecini
                     from jaql485 
                    where JAQL485PGE = 1
                      and JAQL485SUC = ln_scsuc
                      and JAQL485CTA = ln_cuenta
                      and JAQL485MOD = ln_modulo
                      and JAQL485MDA = ln_moneda
                      and JAQL485PAP = 0
                      and JAQL485OPE = ln_opera
                      and JAQL485SBO = case
                                         when ln_modulo = 22 then
                                           JAQL485SBO
                                         else
                                           ln_subope
                                       end             
                      and JAQL485TOP = ln_tipo
                      and JAQL485TCO = P_N_CODCOM
                      and to_char(JAQL485FEF,'MMRRRR') = to_char(ld_fecha,'MMRRRR')--21.11.2019--YLOZADA
                      and JAQL485AX2 = ln_canal;
                      
                      if ld_fecini is not null then
                         FechaInicial := ld_fecini + 1; 
                      End if;
                      
                  Exception
                  When others then
                    null;
                  end;   
                  --fin validacion                                             

                --- Monto Exonerado 2016/11/25

                if ln_moneda = 101 then
                  IF ln_tipo <> 9 or ln_modulo = 22 then
            /*        select round(TP1IMP1/ fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                    monori => ln_moneda,
                                                                    mondes => 0,
                                                                    tipo   => 500
                                                                    ),2)
                      into MontoEx
                      from fst198
                     where TP1COD = 1
                       and TP1COD1 = 10884
                       and TP1CORR1 = 2
                       and TP1CORR2 = 1
                       and TP1CORR3 = 1;*/
                       MontoEx :=0;
                  end if;
                else
/*                  select TP1IMP1
                  into MontoEx
                    from fst198
                   where TP1COD = 1
                     and TP1COD1 = 10884
                     and TP1CORR1 = 2
                     and TP1CORR2 = 1
                     and TP1CORR3 = 1;*/
                     MontoEx:=0;
                end if;
                -- Nro operaciones Permitidas
/*                select TP1NRO1
                  into NroOpe
                  from fst198
                 where TP1COD = 1
                   and TP1COD1 = 10884
                   and TP1CORR1 = 2
                   and TP1CORR2 = 1
                   and TP1CORR3 = 2;*/
                   
              -- detalle del precio
              pq_ah_new_comision.sp_ah_det_precio(p_n_codpre => P_N_CODPRE,
                                                  p_n_codmod => ln_codmod,
                                                  p_n_codcod => ln_codcod,
                                                  p_n_topmov => NroOpe,
                                                  p_n_topsal => montoCol,
                                                  p_c_coderr => p_c_coderr,
                                                  p_c_msgerr => p_c_msgerr
                                                  );    
              if P_N_PREESP > 0 then      
                 ln_codcod := P_N_PREESP; 
              End If;                                                                     
                                                         
                ---****** Nueva Forma de Cobro Interplaza ***------
                select opgval into lc_indoff from fst200 where opgcod=544;

                if lc_indoff = 'S' then --online
                   if ld_fecha = ld_fechaB then ----trunc(sysdate) then ----to_date('01/06/2015','dd/mm/yyyy') then--- para pruebas solamente trunc(sysdate) then
                      if substr(to_char(ld_fecha,'dd/mm/yyyy'),1,2) = '01'then  -- verif 1er dia

                          For reg in BuscaDiaT16 loop
                             if (monto_cte > 0) and (IndCredVi = 'S') then
                                if reg.itimp1 > 0 then ---new
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 end if;
                             else
                                 --if ln_tipo <> 9 then
                                     v_monto := v_monto + reg.itimp1 ;
                                     v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha ,  montoCol,ln_tipo);

                                     if reg.itimp1 > 0 then ---new
                                       v_cont1 := v_cont1 + 1;
                                        v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                      else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                     end if;
                                 /*else
                                   if reg.itimp1 > 0 then ---new
                                      v_cont1 := v_cont1 + 1;
                                      v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                   end if;
                                 end if;*/
                             end if;
                          end loop;
                          /*
                          IF ln_tipo = 9 THEN ---sma 19032019
                            if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                              v_ctrl1 := 0;
                            elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;
                          */

                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;

                          if  (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                               if ln_tipo = 9 then
                                 if IndCredVi = 'S' then
                                    if (monto_cte - ln_monto)> 0 then
                                      control := 0;
                                    else
                                      control := 1;
                                    end if;
                                 else

                                   control := 1;
                                 end if;
                               else*/
                                 control := 1;
                               --end if;

                          elsif  pq_ah_new_comision.fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then --ln_montov
                               control := 1;
                          elsif pq_ah_new_comision.fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha,  montoCol,ln_tipo )= 1 then --ln_montov
                               control := 1;
                          end if;
                      else

                          For reg in BuscaDiaT16 loop
                               if (monto_cte > 0) and (IndCredVi = 'S') then
                                 if reg.itimp1  > 0 then
                                    v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 end if;
                               else
                                 --if ln_tipo <> 9 then
                                     v_monto := v_monto + reg.itimp1 ;
                                     v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);

                                     if reg.itimp1  > 0 then
                                       v_cont1 := v_cont1 + 1;
                                       v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                     else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                     end if;
                                 /* else
                                     if reg.itimp1  > 0 then
                                        v_cont1 := v_cont1 + 1;
                                        v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                     end if;
                                  end if;*/
                               end if;
                          end loop;

/*                          IF ln_tipo = 9 THEN
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;*/

                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                               if ln_tipo = 9 then
                                 if IndCredVi = 'S' then
                                    if (monto_cte - ln_monto)> 0 then
                                      control := 0;
                                    else
                                      control := 1;
                                    end if;
                                 else
                                   control := 1;
                                 end if;
                               else*/
                                  control := 1;
                               --end if;
                          end if;

                          -- Busca Movimientos Historicos
                          For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                            if (monto_cte > 0) and (IndCredVi = 'S') then
                                 if reh.hcimp1 > 0 then
                                   v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                end if;
                            else
                               --if ln_tipo <> 9 then
                                  v_monto := v_monto +  reh.hcimp1;
                                  v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );

                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                   else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  end if;
  /*                             else
                                 if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 end if;
                               end if;*/
                            end if;
                          end loop;
/*                          IF ln_tipo = 9 THEN
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;*/
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;

                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then

/*                                 if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else*/
                                   control := 1;
                                 --end if;

                          elsif  pq_ah_new_comision.fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif pq_ah_new_comision.fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo)= 1 then
                               control := 1;
                          end if;
                      end if;
                   Else
                     IF pq_ah_com_interplaza.fn_ah_ind_data ='N' then
                        -- Busca Movimientos Historicos
                        For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                          IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                            if reh.hcimp1 >0 then
                               v_cont1 := v_cont1 + 1;
                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                            end if;
                          ELSE
                            --if ln_tipo <> 9 then
                                v_monto := v_monto +  reh.hcimp1;
                                v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );

                                if reh.hcimp1 >0 then
                                    v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                end if;
/*                            else
                                if reh.hcimp1 >0 then
                                   v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                end if;
                            end if;*/
                          END IF;
                        end loop;
/*                        IF ln_tipo = 9 THEN --2019/03/19
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                              v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                        END IF;*/
                        if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;
                        if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                             if ln_tipo = 9 then
                                 if IndCredVi = 'S' then
                                    if (monto_cte - ln_monto)> 0 then
                                      control := 0;
                                    else
                                      control := 1;
                                    end if;
                                 else
                                   control := 1;
                                 end if;
                               else*/
                                 control := 1;
                             --end if;
                        elsif  pq_ah_new_comision.fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                             control := 1;
                        elsif pq_ah_new_comision.fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                             control := 1;
                        end if;
                     Else
                       if substr(to_char(ld_fecha,'dd/mm/yyyy'),1,2) = '01' then
                          For reg in BuscaDiaT16 loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                 if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 end if;
                            ELSE
/*                               if ln_tipo = 9 then
                                   v_monto := v_monto + reg.itimp1 ;
                                   v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);

                                   if reg.itimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                      v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                   else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                   end if;
                               else*/
                                  if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  end if;
                               --end if;

                             END IF;
                          end loop;
/*                          IF ln_tipo = 9 THEN --2019/03/19
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;*/
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                               else*/
                                 control := 1;
                               --end if;
                          elsif  pq_ah_new_comision.fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif pq_ah_new_comision.fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          end if;
                       Else
                          For reg in BuscaDiaT16 loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 end if;
                            eLSE
                              --if ln_tipo <> 9 then
                                 v_monto := v_monto + reg.itimp1 ;
                                 v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);

                                 if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 else
                                   v_cont1 := v_cont1 - 1;
                                   v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 end if;
/*                              else
                                 if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 end if;
                              end if;*/
                            END IF;
                          end loop;
/*                          IF ln_tipo = 9 THEN --2019/03/19
                            if ((monto_cte - ln_monto)> 0)and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;*/
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                               else*/
                                 control := 1;
                               --end if;
                          end if;
                          -- Busca Movimientos Historicos
                          For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                 if reh.hcimp1 > 0 then
                                   v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                end if;
                            ELSE
                              --if ln_tipo <>9 then
                                  v_monto := v_monto +  reh.hcimp1;
                                  v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );
                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  end if;
/*                              else
                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                   end if;
                              end if;*/
                            END IF;
                          end loop;
/*                          IF ln_tipo = 9 THEN --2019/03/19
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;*/
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                               if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                               else*/
                                 control := 1;
                               --end if;
                          elsif  pq_ah_new_comision.fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif pq_ah_new_comision.fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          end if;
                       end if;
                     end if;
                   end if;
                 Else
                     if pq_ah_com_interplaza.fn_ah_ind_data = 'S' then
                        if substr(to_char(ld_fecha,'dd/mm/yyyy'),1,2) = '01' then

                           For reg in BuscaDiaT16 loop
                               IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                 if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 end if;
                               ELSE
                                 --if ln_tipo <> 9 then
                                     v_monto := v_monto + reg.itimp1 ;
                                     v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);
                                   ---  v_cont1 := v_cont1 + 1;
                                     if reg.itimp1 > 0 then
                                        v_cont1 := v_cont1 + 1;
                                        v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                     else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                     end if;
/*                                 else
                                     if reg.itimp1 > 0 then
                                        v_cont1 := v_cont1 + 1;
                                        v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                     end if;
                                 end if;*/
                               END IF;
                            end loop;
/*                            IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                               else
                               v_ctrl1 := 1;
                              end if;
                            END IF;*/
                            if ln_marca <> 0 then ---2016/11/03
                              ln_montoV := ln_marca;
                            else
                              ln_montoV := ln_monto;
                            end if;
                            if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                               if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else*/
                                   control := 1;
                                 --end if;
                            elsif  pq_ah_new_comision.fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                            elsif pq_ah_new_comision.fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                                 control := 1;
                            end if;
                        else

                           For reg in BuscaDiaT16 loop
                             IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 end if;
                             ELSE
                               --if ln_tipo <> 9 then
                                   v_monto := v_monto + reg.itimp1 ;
                                   v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);

                                   if reg.itimp1 > 0 then
                                       v_cont1 := v_cont1 + 1;
                                      v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                    else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                   end if;
/*                               else
                                   if reg.itimp1 > 0 then
                                      v_cont1 := v_cont1 + 1;
                                      v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                   end if;
                               end if;*/
                             END IF;
                          end loop;
/*                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                               else
                               v_ctrl1 := 1;
                              end if;
                          END IF;*/
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                              if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else*/
                                   control := 1;
                                 --end if;
                          end if;

                          -- Busca Movimientos Historicos
                          For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                               if reh.hcimp1 > 0 then
                                 v_cont1 := v_cont1 + 1;
                                 v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                               end if;
                            ELSE
                              --if ln_tipo <> 9 then
                                  v_monto := v_monto +  reh.hcimp1;
                                  v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );

                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                   else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  end if;
/*                              else
                                if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                end if;
                              end if;*/
                            END IF;
                          end loop;
/*                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                                  v_ctrl1 := 0;
                               else
                                   v_ctrl1 := 1;
                              end if;
                            END IF;*/
                           if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                               if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else*/
                                   control := 1;
                                 --end if;
                          elsif  pq_ah_new_comision.fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif pq_ah_new_comision.fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          end if;

                          -- Busca Offline
                          For reo in BuscaOffline (trunc(sysdate))loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                              if reo.monto > 0 then
                                 v_cont1 := v_cont1 + reo.operacion ;
                                 v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                              end if;
                            ELSE
                              --if ln_tipo <> 9 then
                                  v_monto := v_monto + reo.monto;
                                  v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda, ld_fecha, montoCol,ln_tipo );

                                  if reo.monto > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  end if;
/*                              else
                                  if reo.monto > 0 then
                                     v_cont1 := v_cont1 + reo.operacion ;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  end if;
                              end if;*/
                            END IF;
                          end Loop;
/*                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                                 v_ctrl1 := 0;
                              else
                                 v_ctrl1 := 1;
                              end if;
                            END IF;*/
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else*/
                                   control := 1;
                                 --end if;
                          elsif  pq_ah_new_comision.fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif pq_ah_new_comision.fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          end if;

                        end if;
                     else
                        -- Busca Movimientos Historicos
                          For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                               if reh.hcimp1 > 0 then
                                   v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                end if;
                            ELSE
                              --if ln_tipo <> 9 then
                                  v_monto := v_monto +  reh.hcimp1;
                                  v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );

                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  end if;
/*                              else
                                if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                end if;
                              end if;*/
                            END IF;
                          end loop;
/*                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0)  and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                                 v_ctrl1 := 0;
                              else
                                 v_ctrl1 := 1;
                              end if;
                           END IF;*/
                           if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                              if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else*/
                                   control := 1;
                                 --end if;
                          end if;
                          -- Busca Offline
                          For reo in BuscaOffline (trunc(sysdate))loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                               if reo.monto > 0 then
                                  v_cont1 := v_cont1 + reo.operacion ;
                                  v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                end if;
                            ELSE
                              --if ln_tipo <> 9 then
                                  v_monto := v_monto + reo.monto;
                                  v_ctrl1 := pq_ah_new_comision.fn_ah_verif_monto(v_monto, ln_moneda, ld_fecha, montoCol,ln_tipo );---reh.hfcon

                                  if reo.monto > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                 else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  end if;
/*                              else
                                  if reo.monto > 0 then
                                    v_cont1 := v_cont1 + reo.operacion ;
                                    v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                  end if;
                              end if;*/
                            END IF;
                          end Loop;
/*                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                                 v_ctrl1 := 0;
                              else
                                 v_ctrl1 := 1;
                              end if;
                          END IF;*/
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;

                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else*/
                                   control := 1;
                                 --end if;
                          elsif  pq_ah_new_comision.fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then --ln_monto
                               control := 1;
                          elsif pq_ah_new_comision.fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then --ln_monto
                               control := 1;
                          end if;
                     end if;
                   End if;

                if v_cont1 >=  NroOpe then --PARA QUE RESPETE LA CANTIDAD DE OPERACIONES LIBRES SEGUN PARAMETRIZACCIÓN >=
                  control := 1;
                Else
                  control := 0;
                End If;
                
                if control = 1 then
                  lc_rpta := 1;
/*
                  --VERIFICAMOS EXONERACIÓN
                  lc_indcob := pq_ah_com_interplaza.fn_valida_cobrocom(ln_cuenta => ln_cuenta,
                                                                       ln_scsuc  => ln_scsuc,
                                                                       ln_modulo => ln_modulo,
                                                                       ln_opera  => ln_opera,
                                                                       ln_tipo   => ln_tipo,
                                                                       ln_moneda => ln_moneda,
                                                                       ln_subope => ln_subope,
                                                                       ld_fecfin => ld_fecha,--ld_fecfin
                                                                       ln_canal  => ln_canal
                                                                       );*/
                   lc_indcob :='S';                                                    
                  -- Aplica comisión
                  If lc_indcob = 'S' then
                     --if ln_tipo <> 9 then
                         ln_monto1 :=  ln_monto - ln_monexo;---ln_marca ;

                           --OBTENEMOS MONTO DE COMISION--nuevo
                           if  v_cont1 >=  NroOpe then --PARA QUE RESPETE LA CANTIDAD DE OPERACIONES LIBRES SEGUN PARAMETRIZACCIÓN >=
                              IF ln_monexo > 0 /*or montoCol > 0*/ THEN -- se comento ylozada or montoCol > 0
                                  -- v_monto := ln_monto1;---07/11/2016
                                   if  v_monto = 0 then
                                      --if ln_monto >= MontoEx then
                                        v_monto := ln_monto1 - MontoEx ;
                                      --end if;
                                   else
                                     if v_monto < MontoEx  then ---19/11/2016
                                       -- if (v_monto + ln_monto )>= MontoEx then

                                           v_monto := (v_monto + ln_monto1)-MontoEx;
                                       -- end if;
                                     else
                                       if v_monto >= MontoEx then
                                         v_monto := ln_monto1;
                                       end if;
                                     end if;
                                   end if;
                              ELSE
                                v_monto := ln_monto1;
                              END IF;
                           else
                             if  v_monto = 0 then
                                --if ln_monto >= MontoEx then
                                  v_monto := ln_monto1 - MontoEx ;
                                --end if;
                             else
                               if v_monto < MontoEx then
                                 -- if (v_monto + ln_monto )>= MontoEx then
                                     v_monto := (v_monto + ln_monto1)-MontoEx;
                                 -- end if;
                               else
                                 if v_monto >= MontoEx then
                                   v_monto := ln_monto1;
                                 end if;
                               end if;
                             end if;
                           end if;
                           /*
                     else --sma 22.01.19 aqui llamar la funcion del Yrving
                       ingreso9 := 'S';
                       ln_monto1 :=   monto_cte - ln_monto ;

                       if IndCredVi = 'S' then
                          if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                              v_monto := 0;
                              ln_monmov := ln_monto;--ln_monto1;
                          else
                              v_monto := ABS(ln_monto1);
                              ln_monmov := monto_cte;
                          end if;
                       else
                           --OBTENEMOS MONTO DE COMISION--nuevo
                           if  v_cont1 >  NroOpe then
                               v_monto := ln_monto;
                             --  ln_monmov := ln_monto;
                                if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                                    ln_monmov := ln_monto;--ln_monto1;
                                else
                                    ln_monmov := monto_cte;
                                end if;
                           else
                                    v_monto := ABS(ln_monto1);
                                    if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                                       ln_monmov := ln_monto;--ln_monto1;
                                    else
                                        ln_monmov := monto_cte;
                                    end if;

--                                end if;
                              end if;
                           end if;
                       end if;



                     end if;----
                     */

                        If ln_moneda = 101 Then
                          v_monto := round(v_monto* fn_tipo_cambio(fecha   => ld_fecha, ---ld_fecfin,
                                                                    monori => ln_moneda,
                                                                    mondes => 0,
                                                                    tipo   => 500
                                                                   ),2);
                        End If;

/*                        ln_moncom := pq_ah_com_interplaza.fn_monto_comision(ln_cuenta => ln_cuenta,
                                                                            ln_scsuc  => ln_scsuc,
                                                                            ln_modulo => ln_modulo,
                                                                            ln_opera  => ln_opera,
                                                                            ln_tipo   => ln_tipo,
                                                                            ln_moneda => ln_moneda,
                                                                            ln_subope => ln_subope,
                                                                            ld_fecfin => ld_fecha, --ld_fecfin,
                                                                            ln_canal  => ln_canal,
                                                                            ln_monto  => v_monto
                                                                            );*/
                                                                                      
                       ln_moncom := pq_ah_comision.fn_ah_monto_comision(p_n_modcom  => ln_codmod,
                                                                         p_n_codcom => ln_codcod,
                                                                         p_n_monmov => v_monto
                                                                         );                                                                            
                        If ln_moneda = 101 Then
                          ln_moncom := round(ln_moncom/ fn_tipo_cambio(fecha  => ld_fecha,--ld_fecfin,
                                                                       monori => ln_moneda,
                                                                       mondes => 0,
                                                                       tipo   => 500
                                                                      ),2);
                        End If;
                  Else
                      ln_moncom := 0;
                  End If;

                 Begin
                  Update FSD016
                     set Itimp11 = ln_moncom --,    /*v_monto*/
                        -- Itimp4  = nvl(ln_marca,0)--v_monto
                   Where Pgcod = 1
                     and Itsuc = ln_pitsuc
                     and Itmod = ln_pitmod
                     and Ittran = ln_trans
                     and Itnrel = ln_rel
                     and Itord = ln_pitord
                     and Itsbor = ln_pitsbor;
                     commit;
                     
                    exception
                      when others then

                       null;
                    end;

                else
                  lc_rpta := 0;
                  ln_marca := 0;
                end if;

                
               
            END IF;
            if ingreso9 = 'N' then
               ln_monto1 :=   monto_cte - ln_monto ;
               if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                   ln_monmov := ln_monto;--ln_monto1;
               else
                   ln_monmov := monto_cte;
               end if;
            end if;
            /*
            if ln_tipo = 9 then
             --CON ESTE PROCEDIMIENTO ACTUALIZAS LA BOLSA, ENVIARLE EL MONTO QUE DEBE DE DISMINUIR DE LA BOLSA.
                       pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => ld_fecha,
                                                         p_n_pgcod => 1,
                                                         p_n_modulo => ln_modulo,
                                                         p_n_sucdes => ln_scsuc,
                                                         p_n_moneda => ln_moneda,
                                                         p_n_papel => 0,
                                                         p_n_ctnro => ln_cuenta,
                                                         p_n_itoper => ln_opera,
                                                         p_n_itsubo => ln_subope,
                                                         p_n_ittope => ln_tipo,
                                                         p_c_tiptrx => 'D',---lc_tiptrx,
                                                         p_n_monmov => 0,--MONTO
                                                         p_n_montem => ln_monmov,
                                                         p_n_pgemp => 1,  -- EMPRESA
                                                         p_n_itsuc => ln_pitsuc,  --SUCURSAL DEL ASIENTO
                                                         p_n_itmod => ln_pitmod,  --MODULO DEL ASIENTO
                                                         p_n_ittran => ln_trans,  -- TRANSACCION DEL ASIENTO
                                                         p_n_itnrel => ln_rel,    --RELACION DEL ASIENTO
                                                         p_n_itnord => ln_pitord  --ORDINAL DEL ASIENTO
                                                         );

             --REGISTRAMOS EN LA FSX016 EL MONTO DEBITADO DE LA BOLSA PARA UTILIZARLO EN EL EXTORNO DE SER EL CASO
             begin
               insert into fsx016 (PGCOD,
                                   HCMOD,
                                   HSUCOR,
                                   HTRAN,
                                   HNREL,
                                   HFCON,
                                   HCORD,
                                   HCSUBO,
                                   TXCOD,
                                   TXOREN,
                                   TXTORD
                                  )
                           values (1,
                                  ln_pitmod,
                                  ln_pitsuc,
                                  ln_trans,
                                  ln_rel,
                                  ld_fecha,
                                  ln_pitord,
                                  ln_pitsbor,
                                  0,
                                  999,
                                  trim(to_char(ln_monmov,'9,999,999.90'))
                                  );
               commit;
             exception
             when others then
              null;
             end;
            end if;
            */

    -- end if;
    p_n_nummov := v_cont1;
    p_n_moncom := ln_moncom;    
  exception
  when others then  
    p_n_nummov := 0;
    p_n_moncom := 0;
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;        
  end sp_ah_verif_tablas16;  
  Procedure sp_ah_calcula_comision_plaza(P_N_PGCOD  IN NUMBER,
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
                                         P_N_CANSUC IN NUMBER,
                                         P_N_MONTO  IN NUMBER,
                                         P_N_CODTAR IN NUMBER,
                                         P_N_CODPRE IN NUMBER,
                                         P_N_CODCOM IN NUMBER,  
                                         P_N_PREESP IN NUMBER,
                                         P_D_FECPRO IN DATE,         
                                         p_n_moncom out number,
                                         p_n_nummov out number,
                                         p_c_coderr out varchar2, 
                                         p_c_msgerr out varchar2   
                                        ) is
   cursor BuscaDiaT16 is
       select  trunc(f6.itimp3),
               f6.itsuc,
               decode(f6.modulo,174,((f6.itimp1)*-1),f6.itimp1) itimp1,
               f6.itimp9,
               f6.itimp13,
               f6.itmod,
               f6.ittran,
               f6.itnrel,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f6.itimp3)) as plaza1, ---f6.itimp3
               (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd ) as plaza2
          from fsd016 f6,
               aqpa109f f8,
               fsd015 f5
         where f6.pgcod = 1
           and f6.itmod  = f8.aqpa109fmod
           and f6.ittran = f8.aqpa109ftrx
           and f6.itord  = f8.aqpa109ford   
           and f8.aqpa109ftar = P_N_CODTAR                  
           and (f6.modulo  in (21,22) or (f6.modulo =174 and f6.rubro = 9300070800001)) 
           and f6.itsucd = P_N_SUCDES
           and f6.moneda = P_N_MONEDA
           and f6.papel = 0
           and f6.itimp3 <> 0.00
           and f6.ctnro =  P_N_CTNRO
           and f6.itoper = P_N_ITOPER
           and f6.itsubo = P_N_ITSUBO
           and f5.pgcod = f6.pgcod
           and f5.itsuc = f6.itsuc
           and f5.itmod = f6.itmod
           and f5.ittran = f6.ittran
           and f5.itnrel = f6.itnrel
           and f5.itcorr <>99
           and f5.itcont = 'S'
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itimp3) <>(select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd );

  cursor BuscaHisT16 (FechaIn in date,FechaFin in date) is
        select trunc(f.hcimp3),
               f.hsucor,
               decode(f.hmodul,174,((f.hcimp1)*-1),f.hcimp1) hcimp1,
               f.hfcon,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f.hcimp3)) as plaza1, ---f6.itimp3
               (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur ) as plaza2
          from fsh016 f,
               fsh015 h,
               aqpa109f f8
         where f.pgcod = 1
           and f.hcmod = f8.aqpa109fmod --moduno
           and f.htran = f8.aqpa109ftrx ---tranuno
           and f.hcord = f8.aqpa109ford --orduno
           and f8.aqpa109ftar = P_N_CODTAR
           and f.hfcon between FechaIn and FechaFin
           and (f.hmodul in (21,22) or (f.hmodul =174 and f.hrubro =9300070800001 ))
           and f.hsucur = P_N_SUCDES
           and f.hmda   = P_N_MONEDA
           and f.hpap   = 0
           and f.hcta   = P_N_CTNRO
           and f.hoper  = P_N_ITOPER
           and f.hsubop = P_N_ITSUBO
           and f.hcimp3 <> 0.00
           and h.pgcod  = f.pgcod
           and h.hcmod  = f.hcmod
           and h.hsucor = f.hsucor
           and h.htran = f.htran
           and h.hnrel = f.hnrel
           and h.hfcon = f.hfcon
           and h.hccorr <> 99
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f.hcimp3) <> (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur );

   cursor BuscaOffline(P_fecha in date) is
     select nvl(sum(decode(z1.z0e4gcesm,1,1,-1)),0) operacion ,
            nvl(sum(decode(z1.z0e4gcesm,1,1* z1.z0e4gcimd,-1*z1.z0e4gcimd)),0) monto
          from z0e4gc z1,
               z0e475 z2
         where z1.z0e4gcest = 'ZZ'
           and z1.z0e4gcesm in (1,3)
           and z1.z0e4gctop in (1,2)
           and z1.z0e4gcfec = P_fecha
           and z1.z0e4gcdpg = P_N_PGCOD
           and z1.z0e4gcdmd = P_N_MODULO
           and z1.z0e4gcdmo = P_N_MONEDA
           and z1.z0e4gcdpa = 0
           and z1.z0e4gcdct = P_N_CTNRO
           and z1.z0e4gcdop = P_N_ITOPER
           and z1.z0e4gcdsc = P_N_ITSUBO
           and z1.z0e4gcdto = P_N_ITTOPE
           and z1.z0e4gcdsu = P_N_SUCDES
           and z2.z0e475cod = z1.z0e4gcter
           and (select jaqy657pza  from jaqy657 where jaqy657suc = z2.z0e475suc) <> (select jaqy657pza  from jaqy657 where jaqy657suc = z1.z0e4gcdsu );

  v_cont1 number := 0;--1; SE CAMBIO YLOZADA
  v_monto number(17,2):= 0;
  v_ctrl1 number := 0;
  v_ctrl2 number := 0;
  control number := 0;
  FechaInicial date;
  FechaFin  date;
  FechaHoy  date;
  MontoEx number(10) := 0;
  NroOpe number(1) := 0;
  lc_indoff char(1);
  /*
  LN_TP1NRO1   number(9);
  LN_TP1NRO2   number(9);
  LN_TP1NRO3   number(9);
  LN_TP1IMP3   number(17,2);
  */
  ln_monto     number(17,2) := 0;
  lc_indcob    char(1):= 'N';
  ln_tipocta   char(1);
  v_canal      number;
  ln_monsal    number(17,2) := 0;
  ln_monrub    number(17,2) := 0;
  ln_monexo    number(17,2) := 0;
  ln_monret    number(17,2) := 0;
  ln_monto1    number(17,2) := 0;
  ln_marca     number(17,2) := 0;
  ln_montoV    number(17,2) := 0;
  montocol     number(17,2) := 0;
  ln_tp1imp2   number:= 0;
  ln_salrem    number(17,2) := 0;
  ln_salter    number(17,2) := 0;
  ld_fechaB    date;
  valor        number := 0;
  SaldoMtoB    number(17,2) := 0;
  ln_monrub1 number(17,2) := 0;
------------------------------------
  monto_cte    number;
  IndCredVi    char(1);
  ln_monmov  number;
  ingreso9   char(1):='N';

  --nuevas variables
  ln_canal     number :=0;
  ln_codmod    number(3) := 0;
  ln_codcod    number(3) := 0;
  ln_topmov    number(3) := 0;
  ln_topsal    number(17,2) := 0;    
  ld_fecini    date;
  Begin
  p_c_coderr :='000';
  p_n_nummov := 0;
  --obtenemos el canal para evaluar las fechas de exoneración

  begin
   select a.aqpa109dcan
     into ln_canal
     from aqpa109d a,
          aqpa109e b
     where a.aqpa109dcct = b.aqpa109ecct
       and b.aqpa109etar = P_N_CODTAR;
  Exception
  When others then
    ln_canal := 0;               
  end;           
    p_n_moncom := 0;
    ln_monto   := P_N_MONTO;
    ln_tipocta := 'N';
/*      Begin
        select 'S'
          into ln_tipocta
          from fst198
         where TP1COD = 1
           and TP1COD1 = 10884
           and TP1CORR1 = 1
           and TP1CORR2 = 1
           and tp1nro1 = P_N_ITTOPE;
      Exception
        When no_data_found then
          ln_tipocta := 'N';
      end;*/
      ld_fechaB := P_D_FECPRO;
/*      select pgfape
        into ld_fechaB
        from fst017
       where pgcod = 1;*/
       v_canal := ln_canal;
       
/*        Begin
        Select  TRUNC(TP1IMP3)
          into v_canal
          from fst198
         where TP1COD = 1
           and TP1COD1 = 10884
           and TP1CORR1 = 3
           and TP1CORR2 = 1
           and TP1NRO1 = P_N_ITMOD
           AND TP1NRO2 = P_N_ITTRAN
           and rownum = 1; -------21//11/2016
      Exception
           when no_data_found then
             v_canal := 0;
      End;*/
         -- Verifica tipo de Operacion
     if ln_tipocta = 'N' then
        -- verifica si transaccion esta en la guia
        If v_canal <> 0 Then
          -- Verifica interplaza
           if pq_ah_com_interplaza.fn_ah_verif_interplaza(P_N_SUCDES,P_N_CANSUC) = 1 then
/*                  Begin
                     Select TP1NRO1,
                            TP1NRO2,
                            TP1NRO3,
                            TP1IMP3
                       into LN_TP1NRO1,  --modulo
                            LN_TP1NRO2,  -- transaccion
                            LN_TP1NRO3,  --ordinal
                            LN_TP1IMP3   -- canal
                       from fst198
                      where tp1cod      = 1
                        and tp1cod1     = 10884
                        and tp1corr1    = 3
                        and TP1NRO1     = P_N_ITMOD
                        and TP1NRO2     = P_N_ITTRAN
                        and rownum      = 1;
                        lc_indcob := 'S';
                  Exception
                    When no_data_found then
                     lc_indcob := 'N';
                    When others then
                     lc_indcob := 'N';
                  End;*/
                lc_indcob := 'S';
                -- verificamos si esta exonerado
                If lc_indcob = 'S' then
                  /*
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
                      and JAQL485TCO = 3
                      and JAQL485FEI <= trunc(sysdate)
                      and JAQL485FEF >= trunc(sysdate)
                      and case
                          when LN_TP1IMP3 = 1 then
                               JAQL485CNV
                          when LN_TP1IMP3 = 2 then
                               JAQL485CNA
                          when LN_TP1IMP3 = 3 then
                               JAQL485CNC
                          Else
                               0
                          end = 1;
                  Exception
                  When others then
                    lc_indcob := 'S';
                  end;
                  */
                   -- verifica si es trx de ingreso o egreso
                   
                  /*--CAMBIOS MONTO EXONERADO*/
                  begin
                      select --tp1imp2
                             tp1imp1,tp1imp2
                        into valor,ln_tp1imp2
                        from fst198
                       where tp1cod = 1
                         and tp1cod1 = 10884
                         and TP1CORR1 = 3
                         and TP1CORR2 = 1
                         and tp1nro1 = P_N_ITMOD
                         and tp1nro2 = P_N_ITTRAN
                         and tp1nro3 = 10--ln_pitord
                         and tp1imp1 = 1
                         and tp1imp3 = v_canal;
                    exception
                      when no_data_found then
                        valor := 0;
                    end;
                    if P_N_ITTOPE = 9 and P_N_MODULO = 21 then
                       FechaHoy := P_D_FECPRO;
                   -- Call the procedure
/*                        select pgfape
                          into FechaHoy
                          from fst017
                         where pgcod = P_N_PGCOD;*/
                         
/*                     pq_ah_comision.sp_ah_consu_bolsa(p_n_pgcod => P_N_PGCOD,
                                                     p_n_modulo => P_N_MODULO,
                                                     p_n_sucdes => P_N_SUCDES,
                                                     p_n_moneda => P_N_MONEDA,
                                                     p_n_papel => 0,
                                                     p_n_ctnro => P_N_CTNRO,
                                                     p_n_itoper => P_N_ITOPER,
                                                     p_n_itsubo => P_N_ITSUBO,
                                                     p_n_ittope => P_N_ITTOPE,
                                                     p_d_fecpro => FechaHoy,
                                                     p_n_mtosal => monto_cte, --SALDO RESTANTE EN BOLSA
                                                     p_c_indcre => IndCredVi);*/ --INDICADOR DE CREDITO S= SI TIENE N= NO TIENE
                                                    
                       monto_cte := 0;
                       IndCredVi := 'N';
                    end if;
                    if lc_indcob = 'S' and ln_tp1imp2 = 1 /*and P_N_ITTOPE <> 9*/ then

                         --obtenemos el monto del rubro de exoneracion
                         if P_N_ITTOPE <> 6 or P_N_MODULO = 22 then

                            pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => P_N_PGCOD,
                                                             p_n_ctnro  => P_N_CTNRO,
                                                             p_n_itoper => P_N_ITOPER,
                                                             p_n_itsubo => P_N_ITSUBO,
                                                             p_n_sucdes => P_N_SUCDES,
                                                             p_n_moneda => P_N_MONEDA,
                                                             p_n_papel  => P_N_PAPEL,
                                                             p_n_monto  => ln_monrub
                                                             );
                         else
                           if P_N_ITTOPE = 6 and P_N_MODULO = 21 then
                             pq_ah_comision.sp_ah_saldos_remu(P_N_PGCOD => P_N_PGCOD,
                                                              P_N_MODULO => P_N_MODULO,
                                                              P_N_CTNRO => P_N_CTNRO,
                                                              P_N_ITOPER => P_N_ITOPER,
                                                              P_N_ITSUBO => P_N_ITSUBO,
                                                              P_N_ITTOPE => P_N_ITTOPE,
                                                              P_N_SUCDES => P_N_SUCDES,
                                                              P_N_MONEDA => P_N_MONEDA,
                                                              P_N_PAPEL => P_N_PAPEL,
                                                              p_n_saldo => ln_salrem,
                                                              p_n_salte => ln_salter
                                                             );
                            pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => P_N_PGCOD,
                                                             p_n_ctnro  => P_N_CTNRO,
                                                             p_n_itoper => P_N_ITOPER,
                                                             p_n_itsubo => P_N_ITSUBO,
                                                             p_n_sucdes => P_N_SUCDES,
                                                             p_n_moneda => P_N_MONEDA,
                                                             p_n_papel  => P_N_PAPEL,
                                                             p_n_monto  => ln_monrub1
                                                             );

                               if (ln_salrem + ln_monrub1)> 0  and ln_tp1imp2 = 1 then
                                 ln_monrub := ln_salrem + ln_monrub1;
                               else
                                  ln_monrub := 0;
                               end if;
                            end if;
                        end if;
                         ln_monexo := ln_monsal + ln_monrub;
                          --obtenemos total monto retirado SIN AFECTO A COMISION

                         ln_monret := ln_monret + ln_monto; --total retirado incluido movimiento actual

                         if ln_monexo >= ln_monret then
                            lc_indcob := 'N';
                            ln_marca  := 0;
                            p_n_nummov := 0;
                            SaldoMtoB := ln_monret;
                         else
                            lc_indcob := 'S';
                            if ln_monexo <> 0 then
                               ln_marca := ln_monto - ln_monexo;
                               SaldoMtoB :=ln_monexo;
                            else
                               ln_marca := ln_monto;--0;
                            end if;
                         end if;
                         --Adicionar validación extra si ha recibido abonos en los ultimos 2 meses puede retirar 
                         --sin comision asi toque saldo de terceros
                         /*
                         if lc_indcob = 'S' and P_N_ITTOPE = 6 and P_N_MODULO = 21 then
                           if fn_ah_abono_n_meses(P_D_FECPRO,
                                                  P_N_PGCOD,
                                                  P_N_MODULO,
                                                  P_N_SUCDES,
                                                  P_N_MONEDA,
                                                  P_N_PAPEL,
                                                  P_N_CTNRO,
                                                  P_N_ITOPER,
                                                  P_N_ITSUBO,
                                                  P_N_ITTOPE) = 'S' then
                             lc_indcob := 'N';
                           end if;
                         end if;  
                         */                        
                    end if;
                   /*-FIN CAMBIOS -*/

    ----VERIFICACION DE LOS MONTOS
                  If lc_indcob = 'S' then
                 --
                 -- meter la validación de exoneracion por parte de los dias
                 -- 
                                   
                  -- Fecha Inicial y Final
                        select to_date('01' || TO_CHAR(P_D_FECPRO, 'MM') || TO_CHAR(P_D_FECPRO, 'YYYY'),'dd/mm/yyyy'),
                               last_day(P_D_FECPRO),
                               P_D_FECPRO
                          into FechaInicial,
                               FechaFin,
                               FechaHoy
                          from fst017
                         where pgcod = P_N_PGCOD;
  
                                                   
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
                              and to_char(JAQL485FEF,'MMRRRR') = to_char(P_D_FECPRO,'MMRRRR')--21.11.2019--YLOZADA
                              and JAQL485AX2 = ln_canal;                             
                              
                              if ld_fecini is not null then
                                 FechaInicial := ld_fecini + 1; 
                              End if;        
                                                    
                          Exception
                          When others then
                            null;
                          end;                           
                          -- fin validacion
                          
                        --- Monto Exonerado
                          if P_N_MONEDA = 101 then
                            if P_N_ITTOPE <> 9 or P_N_MODULO = 22 then
                               /* select round(TP1IMP1/ fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                                monori => P_N_MONEDA,
                                                                                mondes => 0,
                                                                                tipo   => 500
                                                                                ),2)
                                  into MontoEx
                                  from fst198
                                 where TP1COD = 1
                                   and TP1COD1 = 10884
                                   and TP1CORR1 = 2
                                   and TP1CORR2 = 1
                                   and TP1CORR3 = 1;*/
                                   
                                   MontoEx :=0;                        

                            end if;
                          else
                        /*    select TP1IMP1
                              into MontoEx
                              from fst198
                             where TP1COD = 1
                               and TP1COD1 = 10884
                               and TP1CORR1 = 2
                               and TP1CORR2 = 1
                               and TP1CORR3 = 1;*/
                        
                             MontoEx:=0;
                          end if;

                        -- Nro operaciones Permitidas
/*                        select TP1NRO1
                          into NroOpe
                          from fst198
                         where TP1COD = 1
                           and TP1COD1 = 10884
                           and TP1CORR1 = 2
                           and TP1CORR2 = 1
                           and TP1CORR3 = 2;*/
                      -- detalle del precio
                      pq_ah_new_comision.sp_ah_det_precio(p_n_codpre => P_N_CODPRE,
                                                          p_n_codmod => ln_codmod,
                                                          p_n_codcod => ln_codcod,
                                                          p_n_topmov => NroOpe,
                                                          p_n_topsal => ln_topsal,
                                                          p_c_coderr => p_c_coderr,
                                                          p_c_msgerr => p_c_msgerr
                                                          );                                                                                      
                      if P_N_PREESP > 0 then      
                         ln_codcod := P_N_PREESP; 
                      End If; 
                      ---****** Nueva Forma de Cobro Interplaza ***------
                        select opgval into lc_indoff from fst200 where opgcod=544;

                        if lc_indoff = 'S' then --online
                           if FechaHoy = trunc(sysdate) then
                              if substr(to_char(FechaHoy,'dd/mm/yyyy'),1,2) = '01'then  -- verif 1er dia
                                  For reg in BuscaDiaT16 loop
                                       if (monto_cte > 0) and (IndCredVi = 'S') then
                                           if reg.itimp1 > 0 then ---new
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);

                                           end if;
                                       else
                                          --if P_N_ITTOPE <> 9 then
                                             v_monto := v_monto + reg.itimp1 ;
                                             v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy, montoCol,P_N_ITTOPE);

                                             if reg.itimp1 > 0 then ---new
                                                v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                              else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                             end if;
/*                                          else
                                            if reg.itimp1 > 0 then ---new
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                            end if;
                                          end if;*/
                                       end if;
                                  end loop;
/*                                  IF P_N_ITTOPE  = 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                     elsif (monto_cte - ln_monto)> 0  then
                                       v_ctrl1 := 0;
                                    else
                                       v_ctrl1 := 1;
                                    end if;
                                  END IF;*/
                                  if ln_marca <> 0 then ---2016/11/03
                                      ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
                                    if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                           if P_N_ITTOPE = 9 then
                                               if IndCredVi = 'S' then
                                                  if (monto_cte - ln_monto)> 0 then
                                                    control := 0;
                                                  else
                                                    control := 1;
                                                  end if;
                                               else
                                                 control := 1;
                                               end if;
                                             else*/
                                               control := 1;
                                             --end if;
                                    elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then --P_N_MONTO
                                         control := 1;
                                    elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy, montoCol,P_N_ITTOPE )= 1 then --P_N_MONTO
                                         control := 1;
                                    end if;
                              else
                                  For reg in BuscaDiaT16 loop
                                     if(monto_cte > 0) and (IndCredVi = 'S')then
                                        if reg.itimp1  > 0 then
                                            v_cont1 := v_cont1 + 1;
                                            v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                         end if;
                                     else
                                       --if P_N_ITTOPE <> 9 then
                                           v_monto := v_monto + reg.itimp1 ;
                                           v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy, montoCol,P_N_ITTOPE);
                                           v_cont1 := v_cont1 + 1;
                                           if reg.itimp1  > 0 then

                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                           else
                                             v_cont1 := v_cont1 - 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                           end if;
/*                                       else
                                         if reg.itimp1  > 0 then
                                              v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                         end if;
                                       end if;*/
                                     end if;
                                  end loop;
/*                                  IF P_N_ITTOPE = 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                     elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                    end if;
                                  END IF;*/
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                       if P_N_ITTOPE = 9 then
                                         if IndCredVi = 'S' then
                                            if (monto_cte - ln_monto)> 0 then
                                              control := 0;
                                            else
                                              control := 1;
                                            end if;
                                         else
                                           control := 1;
                                         end if;
                                       else*/
                                         control := 1;
                                       --end if;
                                  end if;
                                  -- Busca Movimientos Historicos
                                  For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    if (monto_cte > 0) and (IndCredVi = 'S') then
                                        if reh.hcimp1 > 0 then
                                           v_cont1 := v_cont1 + 1;
                                           v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                        end if;
                                    else
                                        --if P_N_ITTOPE <> 9 then
                                            v_monto := v_monto +  reh.hcimp1;
                                            v_ctrl1 :=  fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon,montoCol,P_N_ITTOPE );

                                            if reh.hcimp1 > 0 then
                                               v_cont1 := v_cont1 + 1;
                                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                             else
                                                 v_cont1 := v_cont1 - 1;
                                                 v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                            end if;
/*                                        else
                                          if reh.hcimp1 > 0 then
                                               v_cont1 := v_cont1 + 1;
                                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
                                        end if;*/
                                    end if;
                                  end loop;
/*                                  IF P_N_ITTOPE = 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                     elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                    end if;
                                  END IF;*/
                                  if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then--
/*                                           if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else*/
                                             control := 1;
                                           --end if;
                                  elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  end if;
                              end if;
                           Else
                             IF pq_ah_com_interplaza.fn_ah_ind_data ='N' then
                                -- Busca Movimientos Historicos
                                For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                       if reh.hcimp1 >0 then
                                         v_cont1 := v_cont1 + 1;
                                         v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                       end if;
                                    ELSE
                                      --if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto +  reh.hcimp1;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon, montoCol,P_N_ITTOPE );

                                          if reh.hcimp1 >0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
/*                                      else
                                         if reh.hcimp1 >0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                         end if;
                                      end if;*/
                                    END IF;
                                end loop;
 /*                               IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                  if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                    v_ctrl1 := 0;
                                  elsif (monto_cte - ln_monto)> 0  then
                                     v_ctrl1 := 0;
                                  else
                                     v_ctrl1 := 1;
                                  end if;
                                END IF;*/

                                if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                else
                                    ln_montoV := P_N_MONTO;
                                end if;

                                if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else*/
                                             control := 1;
                                           --end if;
                                elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                     control := 1;
                                elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                     control := 1;
                                end if;
                             Else
                               if substr(to_char(FechaHoy,'dd/mm/yyyy'),1,2) = '01' then
                                  For reg in BuscaDiaT16 loop
                                      IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                         if reg.itimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                           end if;
                                      ELSE
                                           v_monto := v_monto + reg.itimp1 ;
                                           v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy,montoCol,P_N_ITTOPE);
                                           if reg.itimp1 > 0 then
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                            else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                           end if;
                                       END IF;
                                  end loop;
/*                                    IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                      elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                      end if;
                                    END IF;*/
                                    if ln_marca <> 0 then ---2016/11/03
                                      ln_montoV := ln_marca;
                                    else
                                      ln_montoV := P_N_MONTO;
                                    end if;
                                    if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                           if P_N_ITTOPE = 9 then
                                               if IndCredVi = 'S' then
                                                  if (monto_cte - ln_monto)> 0 then
                                                    control := 0;
                                                  else
                                                    control := 1;
                                                  end if;
                                               else
                                                 control := 1;
                                               end if;
                                             else*/
                                               control := 1;
                                             --end if;
                                    elsif  fn_ah_verif_monto(ln_montov, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                         control := 1;
                                    elsif fn_ah_verif_monto((ln_montov + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                         control := 1;
                                    end if;
                               Else
                                  For reg in BuscaDiaT16 loop
                                      IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                           if reg.itimp1 > 0 then
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                           end if;
                                      eLSE
                                          --if P_N_ITTOPE <> 9 then
                                             v_monto := v_monto + reg.itimp1 ;
                                             v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy,montoCol,P_N_ITTOPE);

                                             if reg.itimp1 > 0 then
                                                v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                             else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                             end if;
/*                                          else
                                            if reg.itimp1 > 0 then
                                                v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                            end if;
                                          end if;*/
                                       END IF;
                                  end loop;
/*                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                    elsif (monto_cte - ln_monto)> 0  then
                                     v_ctrl1 := 0;
                                    else
                                     v_ctrl1 := 1;
                                    end if;
                                  END IF;*/
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                         if P_N_ITTOPE = 9 then
                                           if IndCredVi = 'S' then
                                              if (monto_cte - ln_monto)> 0 then
                                                control := 0;
                                              else
                                                control := 1;
                                              end if;
                                           else
                                             control := 1;
                                           end if;
                                         else*/
                                           control := 1;
                                         --end if;
                                  end if;
                                  -- Busca Movimientos Historicos
                                  For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    IF(monto_cte > 0) and (IndCredVi = 'S') THEN
                                        if reh.hcimp1 > 0 then
                                           v_cont1 := v_cont1 + 1;
                                           v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                        end if;
                                    ELSE
                                      --if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto +  reh.hcimp1;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon ,montoCol,P_N_ITTOPE);

                                          if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          else
                                             v_cont1 := v_cont1 - 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
/*                                       else
                                         if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                         end if;
                                       end if;*/
                                    END IF;
                                  end loop;
/*                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                    elsif (monto_cte - ln_monto)> 0  then
                                     v_ctrl1 := 0;
                                    else
                                     v_ctrl1 := 1;
                                    end if;
                                  END IF;*/
                                  if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else*/
                                             control := 1;
                                           --end if;
                                  elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  end if;
                               end if;
                             end if;
                           end if;
                         Else
                             if pq_ah_com_interplaza.fn_ah_ind_data = 'S' then
                                if substr(to_char(FechaHoy,'dd/mm/yyyy'),1,2) = '01' then
                                   For reg in BuscaDiaT16 loop
                                      IF(monto_cte > 0) and (IndCredVi = 'S') THEN
                                          if reg.itimp1 > 0 then
                                            v_cont1 := v_cont1 + 1;
                                            v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
                                       ELSE
                                         --if P_N_ITTOPE <> 9 then
                                             v_monto := v_monto + reg.itimp1 ;
                                             v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy,montoCol,P_N_ITTOPE);

                                             if reg.itimp1 > 0 then
                                                 v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                             else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                             end if;
/*                                         else
                                            if reg.itimp1 > 0 then
                                                v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                            end if;
                                         end if;*/
                                       END IF;
                                    end loop;
/*                                    IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                      elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                      end if;
                                    END IF;*/
                                    if ln_marca <> 0 then ---2016/11/03
                                      ln_montoV := ln_marca;
                                    else
                                      ln_montoV := P_N_MONTO;
                                    end if;
                                    if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                           if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else*/
                                             control := 1;
                                           --end if;
                                    elsif  fn_ah_verif_monto(ln_montov, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                    elsif fn_ah_verif_monto((ln_montov + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                         control := 1;
                                    end if;
                                else
                                   For reg in BuscaDiaT16 loop
                                       IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                           if reg.itimp1 > 0 then
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                           end if;
                                       ELSE
                                          --if P_N_ITTOPE <> 9 then
                                               v_monto := v_monto + reg.itimp1 ;
                                               v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy, montoCol,P_N_ITTOPE);

                                               if reg.itimp1 > 0 then
                                                  v_cont1 := v_cont1 + 1;
                                                  v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                                else
                                                 v_cont1 := v_cont1 - 1;
                                                 v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                               end if;
/*                                           else
                                              if reg.itimp1 > 0 then
                                                  v_cont1 := v_cont1 + 1;
                                                  v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                              end if;
                                           end if;*/
                                       End if;
                                  end loop;
/*                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                    elsif (monto_cte - ln_monto)> 0  then
                                     v_ctrl1 := 0;
                                    else
                                     v_ctrl1 := 1;
                                    end if;
                                  END IF;*/
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                       if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else*/
                                             control := 1;
                                           --end if;
                                  end if;
                                  -- Busca Movimientos Historicos
                                  For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                       if reh.hcimp1 > 0 then
                                         v_cont1 := v_cont1 + 1;
                                         v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                      end if;
                                    ELSE
                                      --if  P_N_ITTOPE <> 9 then
                                          v_monto := v_monto +  reh.hcimp1;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon,montoCol,P_N_ITTOPE );

                                          if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                           else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
/*                                       else
                                         if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                         end if;
                                       end if;*/
                                    END IF;
                                  end loop;
/*                                    IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                     elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                      end if;
                                    END IF;*/
                                   if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else*/
                                             control := 1;
                                         --end if;
                                  end if;
                                  -- Busca Offline
                                  For reo in BuscaOffline (trunc(sysdate))loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                      if reo.monto > 0 then
                                         v_cont1 := v_cont1 + reo.operacion ;
                                         v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                      end if;
                                    ELSE
                                      --if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto + reo.monto;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE );

                                          if reo.monto > 0 then
                                             v_cont1 := v_cont1 + 1 ;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
/*                                       else
                                          if reo.monto > 0 then
                                             v_cont1 := v_cont1 + reo.operacion ;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
                                       end if;*/
                                    END IF;
                                  end Loop;
                                  if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
/*                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                      elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                      end if;
                                  END IF;*/
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else*/
                                             control := 1;
                                           --end if;
                                  elsif  fn_ah_verif_monto(ln_montov, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  elsif fn_ah_verif_monto((ln_montov + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  end if;
                                end if;
                             else
                                -- Busca Movimientos Historicos
                                  For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                      if reh.hcimp1 > 0 then
                                         v_cont1 := v_cont1 + 1;
                                         v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                      end if;
                                    ELSE
                                      --if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto +  reh.hcimp1;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon,montoCol,P_N_ITTOPE );

                                          if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                         else
                                             v_cont1 := v_cont1 - 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
/*                                       else
                                          if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
                                       end if;*/
                                    END IF;
                                  end loop;
/*                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                      elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                        v_ctrl1 := 1;
                                      end if;
                                   END IF;*/
                                   if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else*/
                                             control := 1;
                                           --end if;
                                  end if;
                                  -- Busca Offline
                                  For reo in BuscaOffline (trunc(sysdate))loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                        if reo.monto > 0 then
                                          v_cont1 := v_cont1 + reo.operacion ;
                                          v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                        end if;
                                    ELSE
                                      --if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto + reo.monto;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE );

                                          if reo.monto > 0 then
                                            v_cont1 := v_cont1 + 1;
                                            v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                         else
                                             v_cont1 := v_cont1 - 1;
                                             v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                          end if;
/*                                      ELSE
                                         if reo.monto > 0 then
                                            v_cont1 := v_cont1 + reo.operacion ;
                                            v_ctrl2 := pq_ah_new_comision.fn_ah_verif_nroope(P_N_CODPRE,v_cont1);
                                         END IF;
                                      END IF;*/
                                    END IF;
                                  end Loop;
/*                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                    elsif (monto_cte - ln_monto)> 0  then
                                       v_ctrl1 := 0;
                                    else
                                       v_ctrl1 := 1;
                                    end if;
                                  END IF;*/
                                  if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
/*                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else*/
                                             control := 1;
                                           --end if;

                                  elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy ,montoCol,P_N_ITTOPE)= 1 then
                                       control := 1;
                                  elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  end if;
                             end if;
                        End if;
                        
                        
                        if v_cont1 >=  NroOpe then --PARA QUE RESPETE LA CANTIDAD DE OPERACIONES LIBRES SEGUN PARAMETRIZACCIÓN >=
                          control := 1;
                        Else
                          control := 0;
                        End If;                        
                        if control = 1 then
                           --lc_rpta := 1;
/*                           --VERIFICAMOS EXONERACIÓN                           
                            lc_indcob := pq_ah_com_interplaza.fn_valida_cobrocom(ln_cuenta => P_N_CTNRO,
                                                                                 ln_scsuc  => P_N_SUCDES,
                                                                                 ln_modulo => P_N_MODULO,
                                                                                 ln_opera  => P_N_ITOPER,
                                                                                 ln_tipo   => P_N_ITTOPE,
                                                                                 ln_moneda => P_N_MONEDA,
                                                                                 ln_subope => P_N_ITSUBO,
                                                                                 ld_fecfin => FechaHoy,--ld_fecfin
                                                                                 ln_canal  => v_canal
                                                                                 );*/
                           -- Aplica comisión
                           lc_indcob :='S';
                           
                           If lc_indcob = 'S' then
                             --if P_N_ITTOPE <> 9 then
                               ln_monto1 := P_N_MONTO - ln_monexo;
                               --OBTENEMOS MONTO DE COMISION--nuevo

                               if  v_cont1 >=  NroOpe then --PARA QUE RESPETE LA CANTIDAD DE OPERACIONES LIBRES SEGUN PARAMETRIZACCIÓN >=
                                  IF ln_monexo > 0 or montoCol > 0 THEN
                                    -- v_monto := ln_monto1;---07/11/2016
                                     if  v_monto = 0 then
                                        --if ln_monto >= MontoEx then
                                          v_monto := ln_monto1 - MontoEx ;
                                        --end if;
                                     else
                                         if v_monto < MontoEx  then ---19/11/2016
                                           -- if (v_monto + ln_monto )>= MontoEx then

                                               v_monto := (v_monto + ln_monto1)-MontoEx;
                                           -- end if;
                                         else
                                           if v_monto >= MontoEx then
                                             v_monto := ln_monto1;
                                           end if;
                                         end if;
                                     end if;
                                  ELSE
                                     v_monto := ln_monto1; -- P_N_MONTO;
                                  end if;
                               else
                                 if  v_monto = 0 then
                                    --if ln_monto >= MontoEx then
                                      v_monto := ln_monto1 - MontoEx ; --P_N_MONTO - MontoEx ;
                                    --end if;
                                 else
                                   if v_monto < MontoEx then
                                     -- if (v_monto + P_N_MONTO )>= MontoEx then
                                         v_monto := (v_monto + ln_monto1)-MontoEx;
                                     -- end if;
                                   else
                                     if v_monto >= MontoEx then
                                       v_monto := ln_monto1;
                                     end if;
                                   end if;
                                 end if;
                               end if; 
                               /*              ----
                            else
                              ingreso9 := 'S';
                                 ln_monto1 :=   monto_cte - ln_monto ;
                                 if IndCredVi = 'S' then
                                    if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                                        v_monto := 0;
                                        ln_monmov := P_N_MONTO;--ln_monto1;
                                    else
                                        v_monto := ABS(ln_monto1);
                                        ln_monmov := monto_cte;
                                    end if;
                                 else
                                     --OBTENEMOS MONTO DE COMISION--nuevo
                                     if  v_cont1 >  NroOpe then
                                         v_monto := P_N_MONTO;
                                          if  ln_monto1 >= 0 then-- :=  P_N_MONTO - monto_cte;---verificar
                                              ln_monmov := P_N_MONTO;--ln_monto1;
                                          else
                                              ln_monmov := monto_cte;
                                          end if;
                                     else
                                       if  v_monto = 0 then
                                          v_monto := ABS(ln_monto1);
                                          if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                                             ln_monmov := ln_monto;--ln_monto1;
                                          else
                                              ln_monmov := monto_cte;
                                          end if;
                                       end if;
                                     end if;
                                 end if;
                            end if;
                            */

                                If P_N_MONEDA = 101 Then
                                  v_monto := round(v_monto* fn_tipo_cambio(fecha   => FechaHoy, ---ld_fecfin,
                                                                            monori => P_N_MONEDA,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                           ),2);
                                End If;

/*                                p_n_moncom := pq_ah_com_interplaza.fn_monto_comision(ln_cuenta => P_N_CTNRO,
                                                                                    ln_scsuc  => P_N_SUCDES,
                                                                                    ln_modulo => P_N_MODULO,
                                                                                    ln_opera  => P_N_ITOPER,
                                                                                    ln_tipo   => P_N_ITTOPE,
                                                                                    ln_moneda => P_N_MONEDA,
                                                                                    ln_subope => P_N_ITSUBO,
                                                                                    ld_fecfin => FechaHoy, --ld_fecfin,
                                                                                    ln_canal  => v_canal,
                                                                                    ln_monto  => v_monto
                                                                                    );*/
                                                                                    
                                                                                                
                                p_n_moncom := pq_ah_comision.fn_ah_monto_comision(p_n_modcom => ln_codmod,
                                                                                  p_n_codcom => ln_codcod,
                                                                                  p_n_monmov => v_monto
                                                                                  );                                                                                       
                                If P_N_MONEDA = 101 Then
                                  p_n_moncom := round(p_n_moncom/ fn_tipo_cambio(fecha  => FechaHoy,--ld_fecfin,
                                                                                 monori => P_N_MONEDA,
                                                                                 mondes => 0,
                                                                                 tipo   => 500
                                                                                ),2);
                                End If;
                                p_n_nummov := v_cont1;

                         end if;
                      Else
                          p_n_moncom := 0;
                      End If;
                end if;
              end if;
           end if;
        end if;
    end if;

  ---------------------
            if ingreso9 = 'N' then
               ln_monto1 :=   monto_cte - ln_monto ;
               if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                   ln_monmov := ln_monto;--ln_monto1;
               else
                   ln_monmov := monto_cte;
               end if;
            end if;
            /*
             --CON ESTE PROCEDIMIENTO ACTUALIZAS LA BOLSA, ENVIARLE EL MONTO QUE DEBE DE DISMINUIR DE LA BOLSA.
             If P_N_ITTOPE = 9 then
                       pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => ld_fechaB,
                                                         p_n_pgcod => P_N_PGCOD,
                                                         p_n_modulo => P_N_MODULO,
                                                         p_n_sucdes => P_N_SUCDES,
                                                         p_n_moneda => P_N_MONEDA,
                                                         p_n_papel => 0,
                                                         p_n_ctnro => P_N_CTNRO,
                                                         p_n_itoper => P_N_ITOPER,
                                                         p_n_itsubo => P_N_ITSUBO,
                                                         p_n_ittope => P_N_ITTOPE,
                                                         p_c_tiptrx => 'D',---lc_tiptrx,
                                                         p_n_monmov => 0,--MONTO
                                                         p_n_montem => ln_monmov,
                                                         p_n_pgemp => 1,  -- EMPRESA
                                                         p_n_itsuc => P_N_CANSUC,  --SUCURSAL DEL ASIENTO
                                                         p_n_itmod => P_N_ITMOD,  --MODULO DEL ASIENTO
                                                         p_n_ittran => P_N_ITTRAN, -- TRANSACCION DEL ASIENTO
                                                         p_n_itnrel => 0,  --RELACION DEL ASIENTO
                                                         p_n_itnord => 0  --ORDINAL DEL ASIENTO
                                                         );
             End If;
             */
    p_n_nummov := v_cont1;  
  exception
  when others then  
    p_n_nummov := 0;
    p_n_moncom := 0;
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;     
  end sp_ah_calcula_comision_plaza;  
  
  Procedure sp_ah_consulta_new_comision(P_D_FECPRO IN DATE,
                                        P_N_PGCOD  IN NUMBER,
                                        P_N_CTNRO  IN NUMBER,
                                        P_N_ITOPER IN NUMBER,
                                        P_N_ITSUBO IN NUMBER,
                                        P_N_SUCDES IN NUMBER,
                                        P_N_ITTOPE IN NUMBER,
                                        P_N_MODULO IN NUMBER,
                                        P_N_MONEDA IN NUMBER,
                                        P_N_PAPEL  IN NUMBER,
                                        P_N_MONTO  IN NUMBER,
                                        P_N_CODCOM IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_CANSUC IN NUMBER,
                                        p_n_moncom in out number,
                                        p_n_nummov in out number,
                                        p_c_coderr out varchar2, 
                                        p_c_msgerr out varchar2
                                       ) is  
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
  --ln_moncom    number(17,2) := 0;
  ln_nummov    number;
  --ln_indcob    number(17,2) := 0;  
  lv_tipper    varchar2(1);
  ln_mtoexo number(17,2):=0;
  ln_tipo   number(3):=0;  
    
   cursor c_criterios(ln_aqpa109btcp in number,ld_fecpro in date) is
     Select a.* 
       from aqpa109b a 
      where a.aqpa109btcp = ln_aqpa109btcp
        and ld_fecpro 
            between 
            a.aqpa109bfin and 
            case
              when a.aqpa109bffi = to_date('01/01/0001','dd/mm/rrrr') then
                 to_date('31/12/2099','dd/mm/rrrr')
              when a.aqpa109bffi is null then   
                 to_date('31/12/2099','dd/mm/rrrr')
              else
                 a.aqpa109bffi
            end             
        and a.aqpa109best = 'S'
   order by a.aqpa109bpri asc;
   
   cursor c_com_x_trx is      
    Select a.*
      from fst198  a,
           aqpa109 b
     where a.tp1cod   = 1
       and a.tp1cod1  = 10825
       and a.tp1corr1 = 95
       and a.tp1corr2 = 1
       and a.tp1nro1  = P_N_ITMOD
       and a.tp1nro2  = P_N_ITTRAN
       and a.tp1nro3 = b.aqpa109com
       and b.aqpa109com = decode(P_N_CODCOM,0,b.aqpa109com,P_N_CODCOM)
       --and b.aqpa109fin <= P_D_FECPRO
       and P_D_FECPRO 
              between 
              b.aqpa109fin and 
              case
                when b.aqpa109ffi = to_date('01/01/0001','dd/mm/rrrr') then
                   to_date('31/12/2099','dd/mm/rrrr')
                when b.aqpa109ffi is null then   
                   to_date('31/12/2099','dd/mm/rrrr')
                else
                   b.aqpa109ffi
              end
       and a.tp1imp2  = 1
       and b.aqpa109est = 'S'       
  order by tp1nro1,tp1nro2,tp1imp1;
  
  ln_aqpa109com  aqpa109.aqpa109com%type;
  ln_aqpa109btcp aqpa109b.aqpa109btcp%type;
  ln_numcri number(9):=0;    
  ln_crican number(9):=0;    
  ln_codcan number(9):=0;       
  ln_codtar number(9):=0;         
  ln_codpre number(9):=0;   
  ln_preesp number(9):=0; 
  lc_indcob char(1);   
  ld_fecpro date;  
  ld_fecret date;
                               
  begin
    p_n_moncom := 0;  
    ln_nummov := p_n_nummov;   
    p_n_nummov := 0;  
    p_c_coderr := '000';  
    p_c_msgerr := '';    
     
    ln_Pgcod   := P_N_PGCOD; 
    ln_ctnro   := P_N_CTNRO;
    ln_Itoper  := P_N_ITOPER;
    ln_Itsubo  := P_N_ITSUBO;
    ln_Itsucd  := P_N_SUCDES;
    ln_Ittope  := P_N_ITTOPE;
    ln_Modulo  := P_N_MODULO;
    ln_Moneda  := P_N_MONEDA;
    ln_Papel   := P_N_PAPEL;
    ln_monto   := P_N_MONTO;
      
    if fn_ah_aplica_comision(P_N_ITMOD,P_N_ITTRAN,P_N_CODCOM,P_D_FECPRO) = 'S' then
       -- PASO 3 obtenemos el tipo de persona de la cuenta cliente
       pq_ah_new_comision.sp_ah_tipper(p_n_codpgc => ln_Pgcod,
                                       p_n_numcta => ln_ctnro,
                                       p_c_codval => lv_tipper
                                      );    
                                      
       if lv_tipper is not null then
         -- PASO 4 verificamos si esta parametrizado comsión por tipo de persona
           For i in c_com_x_trx loop
             ln_aqpa109com := i.tp1nro3; -- codigo de comisión
             ln_codcan     := i.tp1imp3; -- canal sobre el cual aplica
             --Determina si esta exonerado de cobro de la comisión por producto
             lc_indcob := pq_ah_new_comision.fn_ah_verifica_exoneracion(p_d_fecpro => P_D_FECPRO,
                                                                        p_n_pgcod  => P_N_PGCOD,
                                                                        p_n_ctnro  => P_N_CTNRO,
                                                                        p_n_itoper => P_N_ITOPER,
                                                                        p_n_itsubo => P_N_ITSUBO,
                                                                        p_n_sucdes => P_N_SUCDES,
                                                                        p_n_ittope => P_N_ITTOPE,
                                                                        p_n_modulo => P_N_MODULO,
                                                                        p_n_moneda => P_N_MONEDA,
                                                                        p_n_papel  => P_N_PAPEL,
                                                                        p_n_codcom => ln_aqpa109com,
                                                                        p_n_codcan => ln_codcan
                                                                        );      
                                                                        
             if lc_indcob = 'S' then                                                            
               --VERIFICA EXONERACION PARTICULAR
               lc_indcob := pq_ah_new_comision.fn_ah_exonera_trx(p_n_pgcod  => ln_Pgcod,        
                                                                 p_n_modulo => ln_Modulo,       
                                                                 p_n_sucdes => ln_Itsucd,       
                                                                 p_n_moneda => ln_Moneda,       
                                                                 p_n_papel  => ln_Papel,        
                                                                 p_n_ctnro  => ln_ctnro,        
                                                                 p_n_itoper => ln_Itoper,       
                                                                 p_n_itsubo => ln_Itsubo,       
                                                                 p_n_ittope => ln_Ittope,       
                                                                 p_n_itmod  => P_N_ITMOD,
                                                                 p_n_ittran => P_N_ITTRAN,
                                                                 p_n_codcom => ln_aqpa109com,
                                                                 p_n_codcan => ln_codcan
                                                                 );  
             End if;
                                                                                             
             if lc_indcob = 'S' then                 
                 -- verifica parametrización de comisión por tipo de persona
                 ln_aqpa109btcp := fn_ah_comtipper(ln_aqpa109com,lv_tipper);
                 --CONTROLAR FECHA PARA TARIFARIO DE COMISIONES DEL STOCK
                 ld_fecpro := pq_ah_new_comision.fn_ah_consulta_stock(p_d_fecpro => P_D_FECPRO,
                                                                      p_n_pgcod  => ln_Pgcod,
                                                                      p_n_modulo => ln_Modulo,
                                                                      p_n_sucdes => ln_Itsucd,
                                                                      p_n_moneda => ln_Moneda,
                                                                      p_n_papel  => ln_Papel, 
                                                                      p_n_ctnro  => ln_ctnro,
                                                                      p_n_itoper => ln_Itoper,                                                                      
                                                                      p_n_itsubo => ln_Itsubo,
                                                                      p_n_ittope => ln_Ittope
                                                                      ); 
                 --OBTENEMOS FECHA LIMITE DE TARIFARIO DE COMISIONES ANTERIOR                                                       
                 begin
                   Select to_date(trim(a.tp1desc),'dd/mm/rrrr') 
                     into ld_fecret
                     from fst198 a 
                    where a.tp1cod   = 1 
                      and a.tp1cod1  = 10825 
                      and a.tp1corr1 = 95 
                      and a.tp1corr2 = 5;
                 exception
                 when others then
                   ld_fecret := null;    
                 end;                                                                          
                 if ld_fecpro = ld_fecret or (ln_Modulo = 22 and ln_aqpa109com <> 11) or (ln_Modulo = 21 and ln_Ittope =2 and ln_aqpa109com in (8,9,10)) then
                    --if ln_aqpa109com in (1,3,6,7) or ln_Modulo = 22 then
                       ln_aqpa109btcp := 0; --FORZAMOS PARA QUE SE VAYA POR LA LOGICA ANTIGUA A ESTAS COMISIONES
                    --End if;
                 End If;                       
                 if ln_aqpa109btcp > 0 then--NUEVA LOGICA
                   --PASO 5 DETERMINAR EL CRITERIO HABILITADO
                    For j in c_criterios(ln_aqpa109btcp,ld_fecpro) loop
                      ln_numcri := j.aqpa109bcri;
                      -- obtenemos de cual de los criterios viegentes en cual calza la cuenta ciente
                      pq_ah_new_comision.sp_ah_det_criterio(p_d_fecpro => P_D_FECPRO,
                                                            pn_pgcod   => ln_Pgcod, 
                                                            pn_ctnro   => ln_ctnro,
                                                            pn_itoper  => ln_Itoper,
                                                            pn_itsubo  => ln_Itsubo,
                                                            pn_itsucd  => ln_Itsucd,
                                                            pn_ittope  => ln_Ittope,
                                                            pn_modulo  => ln_Modulo,
                                                            pn_moneda  => ln_Moneda,
                                                            pn_papel   => ln_Papel,
                                                            pn_monto   => ln_monto,
                                                            pn_numcri  => ln_numcri,
                                                            p_c_coderr => p_c_coderr,
                                                            p_c_msgerr => p_c_msgerr                  
                                                            );
                       --obtenemos criterio vs canal
                       if ln_numcri > 0 then
                          Exit;
                       End If;
                       if ln_numcri < 0 then
                          return;
                       End If;                   
                    end loop; 
                    --PASO 6 una vez determinado el criterio vigente, evaluamos el CANAL que esta realizando la operación y si esta configurado a cobro dicho canal
                    -- validar canal por criterio
                    ln_crican := fn_ah_crican(ln_numcri,ln_codcan);
                    if ln_crican > 0 then
                        /*
                        -- verificamos si hay crédito vigente para cambiar el tipo de operación antes de ubicar el tarifario y el precio
                        if ln_Ittope in (9,12) then
                           pq_ah_comision.sp_ah_monto_ac(p_n_pgcod  => ln_Pgcod,    
                                                         p_n_modulo => ln_Modulo,   
                                                         p_n_ctnro  => ln_ctnro,    
                                                         p_n_itoper => ln_Itoper,   
                                                         p_n_itsubo => ln_Itsubo,   
                                                         p_n_ittope => ln_Ittope,   
                                                         p_n_sucdes => ln_Itsucd,   
                                                         p_n_moneda => ln_Moneda,   
                                                         p_n_papel  => ln_Papel,    
                                                         p_d_fecpro => P_D_FECPRO,  
                                                         p_n_mtoexo => ln_mtoexo
                                                         );
                            if ln_mtoexo >0 then --tiene credito vigente
                               ln_tipo := 9; --flexible con credito
                            Else
                               ln_tipo := 12;--flexible sin credito
                            End if; 
                        Else
                          ln_tipo := ln_Ittope;                                                        
                        End if; 
                        */
                       --ln_tipo := ln_Ittope;
                        --VERIFICAMOS SI ES CUENTA SUELDO Y HAY ABONO E LOS ULTIMOS X MESES
                        if ln_Modulo = 21 And ln_Ittope = 6 then
                          if fn_ah_abono_n_meses(P_D_FECPRO,
                                                 ln_Pgcod,
                                                 ln_Modulo,
                                                 ln_Itsucd,
                                                 ln_Moneda,
                                                 ln_Papel,
                                                 ln_ctnro,
                                                 ln_Itoper,
                                                 ln_Itsubo,
                                                 ln_Ittope) = 'N' then    
                            ln_tipo := 3;                       
                          Else
                            ln_tipo := ln_Ittope;                         
                          End if;
                        Else
                          ln_tipo := ln_Ittope;                             
                        End if;                                              
                       -- Determina tarifario por modeda/sucursal/tipo de producto/modulo/
                        pq_ah_new_comision.sp_ah_tarifario_comision(pn_crican  => ln_crican,                                                                 
                                                                    pn_itsucd  => ln_Itsucd,
                                                                    pn_ittope  => ln_Ittope,
                                                                    pn_modulo  => ln_Modulo,
                                                                    pn_moneda  => ln_Moneda,                                                              
                                                                    pn_codtar  => ln_codtar,  --codigo de tarifario
                                                                    pn_codpre  => ln_codpre,  --codigo de precio
                                                                    p_c_coderr => p_c_coderr, 
                                                                    p_c_msgerr => p_c_msgerr                  
                                                                   );
                        if p_c_coderr = '000' then
                                                                                                               
                          --Determina si tiene algun tarifario especial para la comisión y canal por producto
                          ln_preesp := pq_ah_new_comision.fn_ah_verifica_tar_especial(p_d_fecpro => P_D_FECPRO,
                                                                                      p_n_pgcod  => ln_Pgcod,
                                                                                      p_n_ctnro  => ln_ctnro,
                                                                                      p_n_itoper => ln_Itoper,
                                                                                      p_n_itsubo => ln_Itsubo,
                                                                                      p_n_sucdes => ln_Itsucd,
                                                                                      p_n_ittope => ln_Ittope,
                                                                                      p_n_modulo => ln_Modulo,
                                                                                      p_n_moneda => ln_Moneda,
                                                                                      p_n_papel  => ln_Papel,
                                                                                      p_n_codcom => ln_aqpa109com,
                                                                                      p_n_codcan => ln_codcan
                                                                                      );  
                             
                          /*if ln_preesp <> 0 then
                             ln_codpre := ln_preesp;
                          End If;*/                                                                                                            
                          --
                          -- DEPENDIENDO DEL TIPO DE COMISION EJECUTAMOS EL PROCEDIMIENTO CORRESPONDIENTE
                          --
                          Case
                            when i.tp1nro3 = 1 then --New Interplaza             
                                pq_ah_new_comision.sp_ah_calcula_comision_plaza(p_n_pgcod  => ln_Pgcod,
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
                                                                                p_n_cansuc => P_N_CANSUC,
                                                                                p_n_monto  => ln_monto,
                                                                                p_n_codtar => ln_codtar,
                                                                                p_n_codpre => ln_codpre,
                                                                                p_n_codcom => ln_aqpa109com,
                                                                                p_d_fecpro => P_D_FECPRO,
                                                                                p_n_moncom => p_n_moncom,
                                                                                p_n_preesp => ln_preesp,
                                                                                p_n_nummov => p_n_nummov,
                                                                                p_c_coderr => p_c_coderr,
                                                                                p_c_msgerr => p_c_msgerr
                                                                                );
                             Else --cualquier otra comisión de conteo                                                   
                             --when i.tp1nro3 in (3,6,7,8,9) then --New Exceso de retiros
                                 pq_ah_new_comision.sp_ah_calcula_comision(p_d_fecpro => P_D_FECPRO,
                                                                           p_n_pgcod  => ln_Pgcod,
                                                                           p_n_ctnro  => ln_ctnro,
                                                                           p_n_itoper => ln_Itoper,
                                                                           p_n_itsubo => ln_Itsubo,
                                                                           p_n_sucdes => ln_Itsucd,
                                                                           p_n_ittope => ln_Ittope,
                                                                           p_n_modulo => ln_Modulo,
                                                                           p_n_moneda => ln_Moneda,
                                                                           p_n_papel  => ln_Papel,
                                                                           p_n_monto  => ln_monto,
                                                                           p_n_codtar => ln_codtar,-- codigo de tarifario calculado
                                                                           p_n_codpre => ln_codpre,--codigo de precio en caso tenga especial enviarlo
                                                                           p_n_codcom => ln_aqpa109com,
                                                                           p_n_preesp => ln_preesp,
                                                                           p_n_moncom => p_n_moncom,
                                                                           p_n_nummov => p_n_nummov,
                                                                           p_c_coderr => p_c_coderr, 
                                                                           p_c_msgerr => p_c_msgerr                                                                         
                                                                           );                                                                              
                           /* when i.tp1nro3 = 6 then --New Exceso de depósitos      
                                 pq_ah_new_comision.sp_ah_calcula_comision(p_d_fecpro => P_D_FECPRO,
                                                                           p_n_pgcod  => ln_Pgcod,
                                                                           p_n_ctnro  => ln_ctnro,
                                                                           p_n_itoper => ln_Itoper,
                                                                           p_n_itsubo => ln_Itsubo,
                                                                           p_n_sucdes => ln_Itsucd,
                                                                           p_n_ittope => ln_Ittope,
                                                                           p_n_modulo => ln_Modulo,
                                                                           p_n_moneda => ln_Moneda,
                                                                           p_n_papel  => ln_Papel,
                                                                           p_n_monto  => ln_monto,
                                                                           p_n_codtar => ln_codtar,-- codigo de tarifario calculado
                                                                           p_n_codpre => ln_codpre,--codigo de precio en caso tenga especial enviarlo
                                                                           p_n_codcom => ln_aqpa109com,
                                                                           p_n_moncom => p_n_moncom,
                                                                           p_n_nummov => p_n_nummov,
                                                                           p_c_coderr => p_c_coderr, 
                                                                           p_c_msgerr => p_c_msgerr                                                                         
                                                                           );  */
                            --Else
                              -- p_c_msgerr :='No se encontró comsiión a validar'; 
                          End Case;                    
                        End If;
                    Else
                       p_c_coderr := '002';
                       p_c_msgerr := 'No existe parametrización de canal para criterio a evaluar';
                      return;
                    End If;
                 else --MODULO ANTERIOR
                 -- si no hay parametrizacion es porque utiliza módulo anterior
                
                    if ln_aqpa109com = 1 then -- interplaza               
                        pq_ah_com_interplaza.sp_ah_calcula_comision(p_n_pgcod  => P_N_PGCOD,
                                                                    p_n_ctnro  => P_N_CTNRO,
                                                                    p_n_itoper => P_N_ITOPER,
                                                                    p_n_itsubo => P_N_ITSUBO,
                                                                    p_n_sucdes => P_N_SUCDES,
                                                                    p_n_ittope => P_N_ITTOPE,
                                                                    p_n_modulo => P_N_MODULO,
                                                                    p_n_moneda => P_N_MONEDA,
                                                                    p_n_papel  => P_N_PAPEL,
                                                                    p_n_itmod  => P_N_ITMOD,
                                                                    p_n_ittran => P_N_ITTRAN,
                                                                    p_n_cansuc => P_N_CANSUC,
                                                                    p_n_monto  => P_N_MONTO,
                                                                    p_n_moncom => p_n_moncom,
                                                                    p_n_nummov => p_n_nummov
                                                                    );
                    else--otras comisiones de conteo
                        --if ln_aqpa109com in (3,6,7,8,9) then -- exceso de retiros, depositos op   
                        pq_ah_comision.sp_ah_calcula_comision(p_n_pgcod  => P_N_PGCOD  ,
                                                              p_n_ctnro  => P_N_CTNRO,
                                                              p_n_itoper => P_N_ITOPER,
                                                              p_n_itsubo => P_N_ITSUBO,
                                                              p_n_sucdes => P_N_SUCDES,
                                                              p_n_ittope => P_N_ITTOPE,
                                                              p_n_modulo => P_N_MODULO,
                                                              p_n_moneda => P_N_MONEDA,
                                                              p_n_papel  => P_N_PAPEL,
                                                              p_n_itmod  => P_N_ITMOD,
                                                              p_n_ittran => P_N_ITTRAN,
                                                              p_n_monto  => P_N_MONTO,
                                                              p_n_moncom => p_n_moncom,
                                                              p_n_nummov => p_n_nummov
                                                              );    
                        --Else
                          --p_c_coderr := '00x';
                          --p_c_msgerr := 'No se reconoce acción';                          
                        --End If;                                                                                                                                                                                        
                    End If;
                 End If;
             Else
               p_c_msgerr := 'Producto exonerado de cobro de comisión';
             End if;
           end loop;
       else
           p_c_coderr := '001';
           p_c_msgerr := 'No se reconoce tipo de persona';
       End If; 
    else
     p_n_moncom := 0;     
     p_n_nummov := 0;  
     p_c_coderr := '001';  
     p_c_msgerr := 'No aplica comisión';                                     
    end if;                                            
  exception
  when others then
   p_n_moncom := 0;     
   p_n_nummov := 0;  
   p_c_coderr := sqlcode;  
   p_c_msgerr := sqlerrm;    
  end sp_ah_consulta_new_comision;                                                                                                                                                                                 
                          
  procedure sp_ah_abm_comision(P_C_NOMTBL IN VARCHAR2,
                               P_C_TIPACC IN VARCHAR2,
                               P_N_NUMAX1 IN OUT NUMBER,
                               P_N_NUMAX2 IN OUT NUMBER,
                               P_N_NUMAX3 IN OUT NUMBER,
                               P_N_NUMAX4 IN OUT NUMBER,
                               P_N_NUMAX5 IN OUT NUMBER,
                               P_N_NUMAX6 IN OUT NUMBER,
                               P_N_NUMAX7 IN OUT NUMBER,
                               P_N_NUMAX8 IN OUT NUMBER,
                               P_N_NUMAX9 IN OUT NUMBER,
                               P_N_NUMA10 IN OUT NUMBER,
                               P_N_NUMA11 IN OUT NUMBER,
                               P_N_NUMA12 IN OUT NUMBER, 
                               P_N_NUMA13 IN OUT NUMBER,                                                                                                                                                                                                                                                       
                               P_D_DATAX1 IN OUT DATE,
                               P_D_DATAX2 IN OUT DATE,
                               P_D_DATAX3 IN OUT DATE,
                               P_D_DATAX4 IN OUT DATE,
                               P_D_DATAX5 IN OUT DATE,
                               P_D_DATAX6 IN OUT DATE,
                               P_C_CHRAX1 IN OUT VARCHAR2,
                               P_C_CHRAX2 IN OUT VARCHAR2,
                               P_C_CHRAX3 IN OUT VARCHAR2,
                               P_C_CHRAX4 IN OUT VARCHAR2,
                               P_C_CHRAX5 IN OUT VARCHAR2,
                               P_C_CHRAX6 IN OUT VARCHAR2,
                               P_C_CHRAX7 IN OUT VARCHAR2,
                               p_c_coderr out varchar2,
                               p_c_deserr out varchar2                               
                              ) is
  begin  
    p_c_coderr := '000';
    case
      when trim(P_C_NOMTBL) = 'AQPA109'  then
        case 
          when trim(P_C_TIPACC) = 'INS' then
            begin
               insert into AQPA109(AQPA109COM,AQPA109DES,AQPA109FIN,AQPA109FFI,AQPA109EST,
                                   AQPA109EXO,AQPA109TEP,AQPA109USR,AQPA109AGR,AQPA109FER,
                                   AQPA109FEM,AQPA109USM,AQPA109AGM,AQPA109AX1,AQPA109AX2,
                                   AQPA109AX3,AQPA109AX4,AQPA109AX5,AQPA109AX6,AQPA109AX7,
                                   AQPA109AX8,AQPA109AX9
                                  ) values
                                  (P_N_NUMAX1,P_C_CHRAX1,P_D_DATAX1,P_D_DATAX2,P_C_CHRAX2,
                                   P_N_NUMAX2,P_N_NUMAX3,P_C_CHRAX3,P_N_NUMAX4,P_D_DATAX3,
                                   P_D_DATAX4,P_C_CHRAX4,P_N_NUMAX5,P_N_NUMAX6,P_N_NUMAX7,
                                   P_N_NUMAX8,P_N_NUMAX9,P_D_DATAX5,P_D_DATAX6,P_C_CHRAX5,
                                   P_C_CHRAX6,P_C_CHRAX7
                                  );               
            exception
            when dup_val_on_index then 
              p_c_coderr := '002';
              p_c_deserr := 'AQPA109-YA EXISTE LA COMISION';
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;
          when trim(P_C_TIPACC) = 'UPD' then
            begin
               update AQPA109 a 
                  set a.AQPA109DES = decode(a.AQPA109DES,P_C_CHRAX1,a.AQPA109DES,P_C_CHRAX1),  
                      a.AQPA109FIN = decode(a.AQPA109FIN,P_D_DATAX1,a.AQPA109FIN,P_D_DATAX1),
                      a.AQPA109FFI = decode(a.AQPA109FFI,P_D_DATAX2,a.AQPA109FFI,P_D_DATAX2),
                      a.AQPA109EST = decode(a.AQPA109EST,P_C_CHRAX2,a.AQPA109EST,P_C_CHRAX2),
                      a.AQPA109EXO = decode(a.AQPA109EXO,P_N_NUMAX2,a.AQPA109EXO,P_N_NUMAX2),
                      a.AQPA109TEP = decode(a.AQPA109TEP,P_N_NUMAX3,a.AQPA109TEP,P_N_NUMAX3),                      
                      a.AQPA109FEM = P_D_DATAX3,
                      a.AQPA109USM = P_C_CHRAX3,
                      a.AQPA109AGM = P_N_NUMAX4,
                      a.AQPA109AX1 = decode(a.AQPA109AX1,P_N_NUMAX5,a.AQPA109AX1,P_N_NUMAX5),
                      a.AQPA109AX2 = decode(a.AQPA109AX2,P_N_NUMAX6,a.AQPA109AX2,P_N_NUMAX6),
                      a.AQPA109AX3 = decode(a.AQPA109AX3,P_N_NUMAX7,a.AQPA109AX3,P_N_NUMAX7),
                      a.AQPA109AX4 = decode(a.AQPA109AX4,P_N_NUMAX8,a.AQPA109AX4,P_N_NUMAX8),
                      a.AQPA109AX5 = decode(a.AQPA109AX5,P_D_DATAX4,a.AQPA109AX5,P_D_DATAX4),  
                      a.AQPA109AX6 = decode(a.AQPA109AX6,P_D_DATAX5,a.AQPA109AX6,P_D_DATAX5), 
                      a.AQPA109AX7 = decode(a.AQPA109AX7,P_C_CHRAX4,a.AQPA109AX7,P_C_CHRAX4), 
                      a.AQPA109AX8 = decode(a.AQPA109AX8,P_C_CHRAX5,a.AQPA109AX8,P_C_CHRAX5), 
                      a.AQPA109AX9 = decode(a.AQPA109AX9,P_C_CHRAX6,a.AQPA109AX9,P_C_CHRAX6) 
                where a.AQPA109COM = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;
          when trim(P_C_TIPACC) = 'DEL' then
            begin
               delete 
                 from AQPA109 a 
                where a.aqpa109com = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '003';
                  p_c_deserr := 'AQPA109-NO SE ENCONTRARON REGISTROS A ELIMINAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end; 
          when trim(P_C_TIPACC) = 'SEL' then   
            begin
               Select a.aqpa109des,
                      a.aqpa109fin,
                      a.aqpa109ffi,
                      a.aqpa109est,
                      a.aqpa109exo,
                      a.aqpa109tep                         
                 into P_C_CHRAX1,
                      P_D_DATAX1,
                      P_D_DATAX2,
                      P_C_CHRAX2,
                      P_N_NUMAX2,
                      P_N_NUMAX3               
                 from AQPA109 a 
                where a.aqpa109com = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109-NO SE ENCONTRARON REGISTROS A BUSCAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                           
          else
            p_c_coderr := '001';
            p_c_deserr := 'AQPA109-TIPO DE ACCION NO VALIDA';            
        end case;                              
      when trim(P_C_NOMTBL) = 'AQPA109A' then  
        case 
          when trim(P_C_TIPACC) = 'INS' then
            begin
               insert into AQPA109A(AQPA109ATCP,AQPA109ACOM,AQPA109ATPE,AQPA109AFIN,AQPA109AFFI,
                                    AQPA109AFER,AQPA109AUSR,AQPA109AAGR,AQPA109AEST,AQPA109AFEM,
                                    AQPA109AUSM,AQPA109AAGM,AQPA109AAX1,AQPA109AAX2,AQPA109AAX3,
                                    AQPA109AAX4,AQPA109AAX5,AQPA109AAX6,AQPA109AAX7,AQPA109AAX8,
                                    AQPA109AAX9
                                   ) values
                                   (P_N_NUMAX1,P_N_NUMAX2,P_C_CHRAX1,P_D_DATAX1,P_D_DATAX2,
                                    P_D_DATAX3,P_C_CHRAX2,P_N_NUMAX3,P_C_CHRAX3,P_D_DATAX4,
                                    P_C_CHRAX4,P_N_NUMAX4,P_N_NUMAX5,P_N_NUMAX6,P_N_NUMAX7,
                                    P_N_NUMAX8,P_D_DATAX5,P_D_DATAX6,P_C_CHRAX5,P_C_CHRAX6,
                                    P_C_CHRAX7
                                   );               
            exception
            when dup_val_on_index then 
              p_c_coderr := '002';
              p_c_deserr := 'AQPA109A-YA EXISTE COMIISON POR TIPO DE PERSONA';
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;            
          when trim(P_C_TIPACC) = 'UPD' then
            begin
               update AQPA109A a 
                  set a.AQPA109ACOM = decode(a.AQPA109ACOM,P_N_NUMAX2,a.AQPA109ACOM,P_N_NUMAX2),  
                      a.AQPA109ATPE = decode(a.AQPA109ATPE,P_C_CHRAX1,a.AQPA109ATPE,P_C_CHRAX1),
                      a.AQPA109AFIN = decode(a.AQPA109AFIN,P_D_DATAX1,a.AQPA109AFIN,P_D_DATAX1),
                      a.AQPA109AFFI = decode(a.AQPA109AFFI,P_D_DATAX2,a.AQPA109AFFI,P_D_DATAX2),
                      a.AQPA109AEST = decode(a.AQPA109AEST,P_C_CHRAX2,a.AQPA109AEST,P_C_CHRAX2),
                      a.AQPA109AFEM = P_D_DATAX3,
                      a.AQPA109AUSM = P_C_CHRAX3,
                      a.AQPA109AAGM = P_N_NUMAX3,
                      a.AQPA109AAX1 = decode(a.AQPA109AAX1,P_N_NUMAX4,a.AQPA109AAX1,P_N_NUMAX4),  
                      a.AQPA109AAX2 = decode(a.AQPA109AAX2,P_N_NUMAX5,a.AQPA109AAX2,P_N_NUMAX5), 
                      a.AQPA109AAX3 = decode(a.AQPA109AAX3,P_N_NUMAX6,a.AQPA109AAX3,P_N_NUMAX6), 
                      a.AQPA109AAX4 = decode(a.AQPA109AAX4,P_N_NUMAX7,a.AQPA109AAX4,P_N_NUMAX7), 
                      a.AQPA109AAX5 = decode(a.AQPA109AAX5,P_D_DATAX4,a.AQPA109AAX5,P_D_DATAX4),
                      a.AQPA109AAX6 = decode(a.AQPA109AAX6,P_D_DATAX5,a.AQPA109AAX6,P_D_DATAX5),
                      a.AQPA109AAX7 = decode(a.AQPA109AAX7,P_C_CHRAX4,a.AQPA109AAX7,P_C_CHRAX4),
                      a.AQPA109AAX8 = decode(a.AQPA109AAX8,P_C_CHRAX5,a.AQPA109AAX8,P_C_CHRAX5),
                      a.AQPA109AAX9 = decode(a.AQPA109AAX9,P_C_CHRAX6,a.AQPA109AAX9,P_C_CHRAX6)    
                where a.AQPA109ATCP = P_N_NUMAX1;
                              
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109A-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;            
          when trim(P_C_TIPACC) = 'DEL' then
            begin
               delete 
                 from AQPA109A a 
                where a.aqpa109atcp = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '003';
                  p_c_deserr := 'AQPA109A-NO SE ENCONTRARON REGISTROS A ELIMINAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;  
          when trim(P_C_TIPACC) = 'SEL' then   
            begin
               Select a.aqpa109acom,
                      a.aqpa109atpe,
                      a.aqpa109afin,
                      a.aqpa109affi,   
                      a.aqpa109aest                   
                 into P_N_NUMAX2,
                      P_C_CHRAX1,
                      P_D_DATAX1,
                      P_D_DATAX2,
                      P_C_CHRAX1               
                 from AQPA109A a 
                where a.aqpa109atcp = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109A-NO SE ENCONTRARON REGISTROS A BUSCAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                     
          else
            p_c_coderr := '001';
            p_c_deserr := 'AQPA109A-TIPO DE ACCION NO VALIDA';            
        end case;            
      when trim(P_C_NOMTBL) = 'AQPA109B' then
        case 
          when trim(P_C_TIPACC) = 'INS' then
            begin
               insert into AQPA109B(AQPA109BCRI,AQPA109BTCP,AQPA109BDES,AQPA109BFIN,AQPA109BFFI,
                                    AQPA109BPRI,AQPA109BEST,AQPA109BFER,AQPA109BUSR,AQPA109BAGR,
                                    AQPA109BFEM,AQPA109BUSM,AQPA109BAGM,AQPA109BAX1,AQPA109BAX2,
                                    AQPA109BAX3,AQPA109BAX4,AQPA109BAX5,AQPA109BAX6,AQPA109BAX7,
                                    AQPA109BAX8,AQPA109BAX9
                                   ) values
                                   (P_N_NUMAX1,P_N_NUMAX2,P_C_CHRAX1,P_D_DATAX1,P_D_DATAX2,
                                    P_N_NUMAX3,P_C_CHRAX2,P_D_DATAX3,P_C_CHRAX3,P_N_NUMAX4,
                                    P_D_DATAX4,P_C_CHRAX4,P_N_NUMAX5,P_N_NUMAX6,P_N_NUMAX7,
                                    P_N_NUMAX8,P_N_NUMAX9,P_D_DATAX5,P_D_DATAX6,P_C_CHRAX5,
                                    P_C_CHRAX6,P_C_CHRAX7
                                   );               
            exception
            when dup_val_on_index then 
              p_c_coderr := '002';
              p_c_deserr := 'AQPA109B-YA EXISTE CRITERIOS X COMISION POR TIPO DE PERSONA';
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                        
          when trim(P_C_TIPACC) = 'UPD' then
            begin
               update AQPA109B a 
                  set a.AQPA109BTCP = decode(a.AQPA109BTCP,P_N_NUMAX2,a.AQPA109BTCP,P_N_NUMAX2),  
                      a.AQPA109BDES = decode(a.AQPA109BDES,P_C_CHRAX1,a.AQPA109BDES,P_C_CHRAX1),
                      a.AQPA109BFIN = decode(a.AQPA109BFIN,P_D_DATAX1,a.AQPA109BFIN,P_D_DATAX1),
                      a.AQPA109BFFI = decode(a.AQPA109BFFI,P_D_DATAX2,a.AQPA109BFFI,P_D_DATAX2),
                      a.AQPA109BPRI = decode(a.AQPA109BPRI,P_N_NUMAX3,a.AQPA109BPRI,P_N_NUMAX3),
                      a.AQPA109BEST = decode(a.AQPA109BEST,P_C_CHRAX2,a.AQPA109BEST,P_C_CHRAX2),
                      a.AQPA109BFEM = P_D_DATAX3,
                      a.AQPA109BUSM = P_C_CHRAX3,
                      a.AQPA109BAGM = P_N_NUMAX4,
                      a.AQPA109BAX1 = decode(a.AQPA109BAX1,P_N_NUMAX5,a.AQPA109BAX1,P_N_NUMAX5),  
                      a.AQPA109BAX2 = decode(a.AQPA109BAX2,P_N_NUMAX6,a.AQPA109BAX2,P_N_NUMAX6), 
                      a.AQPA109BAX3 = decode(a.AQPA109BAX3,P_N_NUMAX7,a.AQPA109BAX3,P_N_NUMAX7), 
                      a.AQPA109BAX4 = decode(a.AQPA109BAX4,P_N_NUMAX8,a.AQPA109BAX4,P_N_NUMAX8), 
                      a.AQPA109BAX5 = decode(a.AQPA109BAX5,P_D_DATAX4,a.AQPA109BAX5,P_D_DATAX4),
                      a.AQPA109BAX6 = decode(a.AQPA109BAX6,P_D_DATAX5,a.AQPA109BAX6,P_D_DATAX5),
                      a.AQPA109BAX7 = decode(a.AQPA109BAX7,P_C_CHRAX4,a.AQPA109BAX7,P_C_CHRAX4),
                      a.AQPA109BAX8 = decode(a.AQPA109BAX8,P_C_CHRAX5,a.AQPA109BAX8,P_C_CHRAX5),
                      a.AQPA109BAX9 = decode(a.AQPA109BAX9,P_C_CHRAX6,a.AQPA109BAX9,P_C_CHRAX6)                     
                where a.AQPA109BCRI = P_N_NUMAX1;
                              
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109B-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;             
          when trim(P_C_TIPACC) = 'DEL' then
            begin
               delete 
                 from AQPA109B a 
                where a.aqpa109bcri = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '003';
                  p_c_deserr := 'AQPA109A-NO SE ENCONTRARON REGISTROS A ELIMINAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;  
          when trim(P_C_TIPACC) = 'SEL' then   
            begin
               Select a.aqpa109btcp,
                      a.aqpa109bdes,
                      a.aqpa109bfin,
                      a.aqpa109bffi, 
                      a.aqpa109bpri,
                      a.aqpa109best                 
                 into P_N_NUMAX2,
                      P_C_CHRAX1,
                      P_D_DATAX1,
                      P_D_DATAX2,  
                      P_N_NUMAX3,
                      P_C_CHRAX2            
                 from AQPA109B a 
                where a.aqpa109bcri = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109B-NO SE ENCONTRARON REGISTROS A BUSCAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                
          else
            p_c_coderr := '001';
            p_c_deserr := 'AQPA109B-TIPO DE ACCION NO VALIDA';            
        end case;        
      when trim(P_C_NOMTBL) = 'AQPA109C' then   
        case 
          when trim(P_C_TIPACC) = 'INS' then
            begin
               insert into AQPA109C(AQPA109CCAN,AQPA109CDES,AQPA109CFER,AQPA109CUSR,AQPA109CAGR,
                                    AQPA109CFEM,AQPA109CUSM,AQPA109CAGM,AQPA109CAX1,AQPA109CAX2,
                                    AQPA109CAX3,AQPA109CAX4,AQPA109CAX5,AQPA109CAX6,AQPA109CAX7,
                                    AQPA109CAX8,AQPA109CAX9
                                   ) values
                                   (P_N_NUMAX1,P_C_CHRAX1,P_D_DATAX1,P_C_CHRAX2,P_N_NUMAX2,
                                    P_D_DATAX2,P_C_CHRAX3,P_N_NUMAX3,P_N_NUMAX4,P_N_NUMAX5,
                                    P_N_NUMAX6,P_N_NUMAX7,P_D_DATAX3,P_D_DATAX4,P_C_CHRAX4,
                                    P_C_CHRAX5,P_C_CHRAX6                                    
                                   );               
            exception
            when dup_val_on_index then 
              p_c_coderr := '002';
              p_c_deserr := 'AQPA109C-YA EXISTE CRITERIOS X COMISION POR TIPO DE PERSONA';
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;            
          when trim(P_C_TIPACC) = 'UPD' then
            begin
               update AQPA109C a 
                  set a.AQPA109CDES = decode(a.AQPA109CDES,P_C_CHRAX1,a.AQPA109CDES,P_C_CHRAX1),
                      a.AQPA109CFEM = P_D_DATAX1,
                      a.AQPA109CUSM = P_C_CHRAX2,
                      a.AQPA109CAGM = P_N_NUMAX2,
                      a.AQPA109CAX1 = decode(a.AQPA109CAX1,P_N_NUMAX3,a.AQPA109CAX1,P_N_NUMAX3),  
                      a.AQPA109CAX2 = decode(a.AQPA109CAX2,P_N_NUMAX4,a.AQPA109CAX2,P_N_NUMAX4), 
                      a.AQPA109CAX3 = decode(a.AQPA109CAX3,P_N_NUMAX5,a.AQPA109CAX3,P_N_NUMAX5), 
                      a.AQPA109CAX4 = decode(a.AQPA109CAX4,P_N_NUMAX6,a.AQPA109CAX4,P_N_NUMAX6), 
                      a.AQPA109CAX5 = decode(a.AQPA109CAX5,P_D_DATAX2,a.AQPA109CAX5,P_D_DATAX2),
                      a.AQPA109CAX6 = decode(a.AQPA109CAX6,P_D_DATAX3,a.AQPA109CAX6,P_D_DATAX3),
                      a.AQPA109CAX7 = decode(a.AQPA109CAX7,P_C_CHRAX3,a.AQPA109CAX7,P_C_CHRAX3),
                      a.AQPA109CAX8 = decode(a.AQPA109CAX8,P_C_CHRAX4,a.AQPA109CAX8,P_C_CHRAX4),
                      a.AQPA109CAX9 = decode(a.AQPA109CAX9,P_C_CHRAX5,a.AQPA109CAX9,P_C_CHRAX5)                                                        
                where a.AQPA109CCAN = P_N_NUMAX1;
                              
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109C-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;            
          when trim(P_C_TIPACC) = 'DEL' then
            begin
               delete 
                 from AQPA109C a 
                where a.aqpa109ccan = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '003';
                  p_c_deserr := 'AQPA109C-NO SE ENCONTRARON REGISTROS A ELIMINAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end; 
          when trim(P_C_TIPACC) = 'SEL' then   
            begin
               Select a.aqpa109cdes                      
                 into P_C_CHRAX1            
                 from AQPA109C a 
                where a.aqpa109ccan = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109C-NO SE ENCONTRARON REGISTROS A BUSCAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                         
          else
            p_c_coderr := '001';
            p_c_deserr := 'AQPA109C-TIPO DE ACCION NO VALIDA';            
        end case;        
      when trim(P_C_NOMTBL) = 'AQPA109D' then
        case 
          when trim(P_C_TIPACC) = 'INS' then
            begin
               insert into AQPA109D(AQPA109DCCT,AQPA109DCRI,AQPA109DCAN,AQPA109DFER,AQPA109DUSR,
                                    AQPA109DAGR,AQPA109DFEM,AQPA109DUSM,AQPA109DAGM,AQPA109DAX1,
                                    AQPA109DAX2,AQPA109DAX3,AQPA109DAX4,AQPA109DAX5,AQPA109DAX6,
                                    AQPA109DAX7,AQPA109DAX8,AQPA109DAX9
                                   ) values
                                   (P_N_NUMAX1,P_N_NUMAX2,P_N_NUMAX3,P_D_DATAX1,P_C_CHRAX1,
                                    P_N_NUMAX4,P_D_DATAX2,P_C_CHRAX2,P_N_NUMAX5,P_N_NUMAX6,
                                    P_N_NUMAX7,P_N_NUMAX8,P_N_NUMAX9,P_D_DATAX3,P_D_DATAX4,
                                    P_C_CHRAX3,P_C_CHRAX4,P_C_CHRAX5                                    
                                   );               
            exception
            when dup_val_on_index then 
              p_c_coderr := '002';
              p_c_deserr := 'AQPA109D-YA EXISTE CRITERIO-CANAL-TARIFARIO';
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;            
          when trim(P_C_TIPACC) = 'UPD' then
            begin
               update AQPA109D a 
                  set a.AQPA109DCRI = decode(a.AQPA109DCRI,P_N_NUMAX2,a.AQPA109DCRI,P_N_NUMAX2),
                      a.AQPA109DCAN = decode(a.AQPA109DCAN,P_N_NUMAX3,a.AQPA109DCAN,P_N_NUMAX3),                      
                      a.AQPA109DFEM = P_D_DATAX1,
                      a.AQPA109DUSM = P_C_CHRAX1,
                      a.AQPA109DAGM = P_N_NUMAX4,
                      a.AQPA109DAX1  = decode(a.AQPA109DAX1,P_N_NUMAX5,a.AQPA109DAX1,P_N_NUMAX5),  
                      a.AQPA109DAX2  = decode(a.AQPA109DAX2,P_N_NUMAX6,a.AQPA109DAX2,P_N_NUMAX6), 
                      a.AQPA109DAX3  = decode(a.AQPA109DAX3,P_N_NUMAX7,a.AQPA109DAX3,P_N_NUMAX7), 
                      a.AQPA109DAX4  = decode(a.AQPA109DAX4,P_N_NUMAX8,a.AQPA109DAX4,P_N_NUMAX8), 
                      a.AQPA109DAX5  = decode(a.AQPA109DAX5,P_D_DATAX2,a.AQPA109DAX5,P_D_DATAX2),
                      a.AQPA109DAX6  = decode(a.AQPA109DAX6,P_D_DATAX3,a.AQPA109DAX6,P_D_DATAX3),
                      a.AQPA109DAX7  = decode(a.AQPA109DAX7,P_C_CHRAX2,a.AQPA109DAX7,P_C_CHRAX2),
                      a.AQPA109DAX8  = decode(a.AQPA109DAX8,P_C_CHRAX3,a.AQPA109DAX8,P_C_CHRAX3),
                      a.AQPA109DAX9  = decode(a.AQPA109DAX9,P_C_CHRAX4,a.AQPA109DAX9,P_C_CHRAX4)                                                                        
                where a.AQPA109DCCT = P_N_NUMAX1;
                              
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109D-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;         
          when trim(P_C_TIPACC) = 'DEL' then
            begin
               delete 
                 from AQPA109D a 
                where a.aqpa109dcct = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '003';
                  p_c_deserr := 'AQPA109D-NO SE ENCONTRARON REGISTROS A ELIMINAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;   
          when trim(P_C_TIPACC) = 'SEL' then   
            begin
               Select a.aqpa109dcri,
                      a.aqpa109dcan                      
                 into P_N_NUMAX2,
                      P_N_NUMAX3            
                 from AQPA109D a 
                where a.aqpa109dcct = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109D-NO SE ENCONTRARON REGISTROS A BUSCAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                      
          else
            p_c_coderr := '001';
            p_c_deserr := 'AQPA109D-TIPO DE ACCION NO VALIDA';            
        end case;        
      when trim(P_C_NOMTBL) = 'AQPA109E' then   
        case 
          when trim(P_C_TIPACC) = 'INS' then
            begin
               insert into AQPA109E(AQPA109ETAR,AQPA109ECCT,AQPA109EMOD,AQPA109ETOP,AQPA109EMDA,
                                    AQPA109EAGE,AQPA109ETPR,AQPA109EFER,AQPA109EUSR,AQPA109EAGR, 
                                    AQPA109EFEM,AQPA109EUSM,AQPA109EAGM,AQPA109EAX1,AQPA109EAX2,
                                    AQPA109EAX3,AQPA109EAX4,AQPA109EAX5,AQPA109EAX6,AQPA109EAX7,
                                    AQPA109EAX8,AQPA109EAX9
                                   ) values
                                   (P_N_NUMAX1,P_N_NUMAX2,P_N_NUMAX3,P_N_NUMAX4,P_N_NUMAX5,
                                    P_N_NUMAX6,P_N_NUMAX7,P_D_DATAX1,P_C_CHRAX1,P_N_NUMAX8,
                                    P_D_DATAX2,P_C_CHRAX2,P_N_NUMAX9,P_N_NUMA10,P_N_NUMA11,
                                    P_N_NUMA12,P_N_NUMA13,P_D_DATAX3,P_D_DATAX4,P_C_CHRAX3,
                                    P_C_CHRAX4,P_C_CHRAX5
                                   );               
            exception
            when dup_val_on_index then 
              p_c_coderr := '002';
              p_c_deserr := 'AQPA109E-YA EXISTE TARIFARIO';
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                
          when trim(P_C_TIPACC) = 'UPD' then
            begin
               update AQPA109E a 
                  set a.AQPA109ECCT = decode(a.AQPA109ECCT,P_N_NUMAX2,a.AQPA109ECCT,P_N_NUMAX2),
                      a.AQPA109EMOD = decode(a.AQPA109EMOD,P_N_NUMAX3,a.AQPA109EMOD,P_N_NUMAX3),
                      a.AQPA109ETOP = decode(a.AQPA109ETOP,P_N_NUMAX4,a.AQPA109ETOP,P_N_NUMAX4),
                      a.AQPA109EMDA = decode(a.AQPA109EMDA,P_N_NUMAX5,a.AQPA109EMDA,P_N_NUMAX5),
                      a.AQPA109EAGE = decode(a.AQPA109EAGE,P_N_NUMAX6,a.AQPA109EAGE,P_N_NUMAX6),
                      a.AQPA109ETPR = decode(a.AQPA109ETPR,P_N_NUMAX7,a.AQPA109ETPR,P_N_NUMAX7),                                            
                      a.AQPA109EFEM  = P_D_DATAX1,
                      a.AQPA109EUSM  = P_C_CHRAX1,
                      a.AQPA109EAGM  = P_N_NUMAX8,
                      a.AQPA109EAX1  = decode(a.AQPA109EAX1,P_N_NUMAX9,a.AQPA109EAX1,P_N_NUMAX9),  
                      a.AQPA109EAX2  = decode(a.AQPA109EAX2,P_N_NUMA10,a.AQPA109EAX2,P_N_NUMA10), 
                      a.AQPA109EAX3  = decode(a.AQPA109EAX3,P_N_NUMA11,a.AQPA109EAX3,P_N_NUMA11), 
                      a.AQPA109EAX4  = decode(a.AQPA109EAX4,P_N_NUMA12,a.AQPA109EAX4,P_N_NUMA12), 
                      a.AQPA109EAX5  = decode(a.AQPA109EAX5,P_D_DATAX2,a.AQPA109EAX5,P_D_DATAX2),
                      a.AQPA109EAX6  = decode(a.AQPA109EAX6,P_D_DATAX3,a.AQPA109EAX6,P_D_DATAX3),
                      a.AQPA109EAX7  = decode(a.AQPA109EAX7,P_C_CHRAX2,a.AQPA109EAX7,P_C_CHRAX2),
                      a.AQPA109EAX8  = decode(a.AQPA109EAX8,P_C_CHRAX3,a.AQPA109EAX8,P_C_CHRAX3),
                      a.AQPA109EAX9  = decode(a.AQPA109EAX9,P_C_CHRAX4,a.AQPA109EAX9,P_C_CHRAX4)                                                                                 
                where a.AQPA109ETAR = P_N_NUMAX1;
                              
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109E-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;        
          when trim(P_C_TIPACC) = 'DEL' then
            begin
               delete 
                 from AQPA109E a 
                where a.aqpa109etar = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '003';
                  p_c_deserr := 'AQPA109E-NO SE ENCONTRARON REGISTROS A ELIMINAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end; 
          when trim(P_C_TIPACC) = 'SEL' then   
            begin
               Select a.aqpa109ecct,
                      a.aqpa109emod,  
                      a.aqpa109etop,
                      a.aqpa109emda,
                      a.aqpa109eage,
                      a.aqpa109etpr                
                 into P_N_NUMAX2,
                      P_N_NUMAX3,   
                      P_N_NUMAX4,
                      P_N_NUMAX5,                     
                      P_N_NUMAX6,
                      P_N_NUMAX7                                                                 
                 from AQPA109E a 
                where a.aqpa109etar = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109E-NO SE ENCONTRARON REGISTROS A BUSCAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                          
          else
            p_c_coderr := '001';
            p_c_deserr := 'AQPA109E-TIPO DE ACCION NO VALIDA';            
        end case;           
      when trim(P_C_NOMTBL) = 'AQPA109F' then
        case 
          when trim(P_C_TIPACC) = 'INS' then
            begin
               insert into AQPA109F(AQPA109FTAR,AQPA109FMOD,AQPA109FTRX,AQPA109FORD,AQPA109FFER,
                                    AQPA109FUSR,AQPA109FAGR,AQPA109FFEM,AQPA109FUSM,AQPA109FAGM,                                                                        
                                    AQPA109FAX1,AQPA109FAX2,AQPA109FAX3,AQPA109FAX4,AQPA109FAX5,
                                    AQPA109FAX6,AQPA109FAX7,AQPA109FAX8,AQPA109FAX9
                                   ) values
                                   (P_N_NUMAX1,P_N_NUMAX2,P_N_NUMAX3,P_N_NUMAX4,P_D_DATAX1,
                                    P_C_CHRAX1,P_N_NUMAX5,P_D_DATAX2,P_C_CHRAX2,P_N_NUMAX6,
                                    P_N_NUMAX7,P_N_NUMAX8,P_N_NUMAX9,P_N_NUMA10,P_D_DATAX3,
                                    P_D_DATAX4,P_C_CHRAX3,P_C_CHRAX4,P_C_CHRAX5
                                   );               
            exception
            when dup_val_on_index then 
              p_c_coderr := '002';
              p_c_deserr := 'AQPA109F-YA EXISTE DETALLE DE TARIFARIO';
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;             
          when trim(P_C_TIPACC) = 'UPD' then
            begin
               update AQPA109F a 
                  set a.AQPA109FFEM  = P_D_DATAX1,
                      a.AQPA109FUSM  = P_C_CHRAX1,
                      a.AQPA109FAGM  = P_N_NUMAX5,
                      a.AQPA109FAX1  = decode(a.AQPA109FAX1,P_N_NUMAX6,a.AQPA109FAX1,P_N_NUMAX6),  
                      a.AQPA109FAX2  = decode(a.AQPA109FAX2,P_N_NUMAX7,a.AQPA109FAX2,P_N_NUMAX7), 
                      a.AQPA109FAX3  = decode(a.AQPA109FAX3,P_N_NUMAX8,a.AQPA109FAX3,P_N_NUMAX8), 
                      a.AQPA109FAX4  = decode(a.AQPA109FAX4,P_N_NUMAX9,a.AQPA109FAX4,P_N_NUMAX9), 
                      a.AQPA109FAX5  = decode(a.AQPA109FAX5,P_D_DATAX2,a.AQPA109FAX5,P_D_DATAX2),
                      a.AQPA109FAX6  = decode(a.AQPA109FAX6,P_D_DATAX3,a.AQPA109FAX6,P_D_DATAX3),
                      a.AQPA109FAX7  = decode(a.AQPA109FAX7,P_C_CHRAX2,a.AQPA109FAX7,P_C_CHRAX2),
                      a.AQPA109FAX8  = decode(a.AQPA109FAX8,P_C_CHRAX3,a.AQPA109FAX8,P_C_CHRAX3),
                      a.AQPA109FAX9  = decode(a.AQPA109FAX9,P_C_CHRAX4,a.AQPA109FAX9,P_C_CHRAX4)                                                                                 
                where a.AQPA109FTAR = P_N_NUMAX1
                  and a.AQPA109FMOD = P_N_NUMAX2
                  and a.AQPA109FTRX = P_N_NUMAX3
                  and a.AQPA109FORD = P_N_NUMAX4;    
                      
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109F-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';                  
               End If;                     
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;       
          when trim(P_C_TIPACC) = 'DEL' then
            begin
               delete 
                 from AQPA109F a 
                where a.aqpa109ftar = P_N_NUMAX1
                  and a.aqpa109fmod = P_N_NUMAX2
                  and a.aqpa109ftrx = P_N_NUMAX3 
                  and a.aqpa109ford = P_N_NUMAX4;
                
               if sql%notfound then 
                  p_c_coderr := '003';
                  p_c_deserr := 'AQPA109F-NO SE ENCONTRARON REGISTROS A ELIMINAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;   
          when trim(P_C_TIPACC) = 'SEL' then   
            begin
               Select a.aqpa109ftar, 
                      a.aqpa109fmod,  
                      a.aqpa109ftrx,
                      a.aqpa109ford 
                 into P_N_NUMAX1,
                      P_N_NUMAX2,   
                      P_N_NUMAX3,
                      P_N_NUMAX4                     
                 from AQPA109F a 
                where a.aqpa109ftar = P_N_NUMAX1                 
                  and a.aqpa109fmod = P_N_NUMAX2                 
                  and a.aqpa109ftrx = P_N_NUMAX3                 
                  and a.aqpa109ford = P_N_NUMAX4;                                 
                
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109F-NO SE ENCONTRARON REGISTROS A BUSCAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                                        
          else
            p_c_coderr := '001';
            p_c_deserr := 'AQPA109F-TIPO DE ACCION NO VALIDA';            
        end case;        
      when trim(P_C_NOMTBL) = 'AQPA109G' then   
        case 
          when trim(P_C_TIPACC) = 'INS' then
            begin
               insert into AQPA109G(AQPA109GTPR,AQPA109GMOD,AQPA109GCOD,AQPA109GNUM,AQPA109GMON,
                                    AQPA109GFER,AQPA109GUSR,AQPA109GAGR,AQPA109GFEM,AQPA109GUSM,
                                    AQPA109GAGM,AQPA109GAX1,AQPA109GAX2,AQPA109GAX3,AQPA109GAX4,
                                    AQPA109GAX5,AQPA109GAX6,AQPA109GAX7,AQPA109GAX8,AQPA109GAX9,
                                    AQPA109GDES
                                   ) values
                                   (P_N_NUMAX1,P_N_NUMAX2,P_N_NUMAX3,P_N_NUMAX4,P_N_NUMAX5,
                                    P_D_DATAX1,P_C_CHRAX2,P_N_NUMAX6,P_D_DATAX2,P_C_CHRAX3,
                                    P_N_NUMAX7,P_N_NUMAX8,P_N_NUMAX9,P_N_NUMA10,P_N_NUMA11,
                                    P_D_DATAX3,P_D_DATAX4,P_C_CHRAX4,P_C_CHRAX5,P_C_CHRAX6,
                                    P_C_CHRAX1
                                   );               
            exception
            when dup_val_on_index then 
              p_c_coderr := '002';
              p_c_deserr := 'AQPA109G-YA EXISTE TIPO DE PRECIO';
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;              
          when trim(P_C_TIPACC) = 'UPD' then
            begin
               update AQPA109G a 
                  set a.AQPA109GMOD = decode(a.AQPA109GMOD,P_N_NUMAX2,a.AQPA109GMOD,P_N_NUMAX2),
                      a.AQPA109GCOD = decode(a.AQPA109GCOD,P_N_NUMAX3,a.AQPA109GCOD,P_N_NUMAX3),
                      a.AQPA109GNUM = decode(a.AQPA109GNUM,P_N_NUMAX4,a.AQPA109GNUM,P_N_NUMAX4),
                      a.AQPA109GMON = decode(a.AQPA109GMON,P_N_NUMAX5,a.AQPA109GMON,P_N_NUMAX5),
                      a.AQPA109GFEM  = P_D_DATAX1,
                      a.AQPA109GUSM  = P_C_CHRAX2,
                      a.AQPA109GAGM  = P_N_NUMAX6,
                      a.AQPA109GAX1  = decode(a.AQPA109GAX1,P_N_NUMAX7,a.AQPA109GAX1,P_N_NUMAX7),  
                      a.AQPA109GAX2  = decode(a.AQPA109GAX2,P_N_NUMAX8,a.AQPA109GAX2,P_N_NUMAX8), 
                      a.AQPA109GAX3  = decode(a.AQPA109GAX3,P_N_NUMAX9,a.AQPA109GAX3,P_N_NUMAX9), 
                      a.AQPA109GAX4  = decode(a.AQPA109GAX4,P_N_NUMA10,a.AQPA109GAX4,P_N_NUMA10), 
                      a.AQPA109GAX5  = decode(a.AQPA109GAX5,P_D_DATAX2,a.AQPA109GAX5,P_D_DATAX2),
                      a.AQPA109GAX6  = decode(a.AQPA109GAX6,P_D_DATAX3,a.AQPA109GAX6,P_D_DATAX3),
                      a.AQPA109GAX7  = decode(a.AQPA109GAX7,P_C_CHRAX3,a.AQPA109GAX7,P_C_CHRAX3),
                      a.AQPA109GAX8  = decode(a.AQPA109GAX8,P_C_CHRAX4,a.AQPA109GAX8,P_C_CHRAX4),
                      a.AQPA109GAX9  = decode(a.AQPA109GAX9,P_C_CHRAX5,a.AQPA109GAX9,P_C_CHRAX5),
                      a.AQPA109GDES  = decode(a.AQPA109GDES,P_C_CHRAX1,a.AQPA109GDES,P_C_CHRAX1)                                                                                
                where a.AQPA109GTPR = P_N_NUMAX1;
  
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109G-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;        
          when trim(P_C_TIPACC) = 'DEL' then
            begin
               delete 
                 from AQPA109G a 
                where a.aqpa109gtpr = P_N_NUMAX1;
                
               if sql%notfound then 
                  p_c_coderr := '003';
                  p_c_deserr := 'AQPA109g-NO SE ENCONTRARON REGISTROS A ELIMINAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end; 
          when trim(P_C_TIPACC) = 'SEL' then   
            begin
               Select a.aqpa109gmod, 
                      a.aqpa109gcod, 
                      a.aqpa109gnum,
                      a.aqpa109gmon,
                      a.aqpa109gdes
                 into P_N_NUMAX2,
                      P_N_NUMAX3,   
                      P_N_NUMAX4,
                      P_N_NUMAX5,  
                      P_C_CHRAX1                   
                 from AQPA109G a 
                where a.aqpa109gtpr = P_N_NUMAX1;                                                                 
                
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_deserr := 'AQPA109G-NO SE ENCONTRARON REGISTROS A BUSCAR';                  
               End If;                      
            exception
            when others then 
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;              
            end;                                        
                      
          else
            p_c_coderr := '001';
            p_c_deserr := 'AQPA109G-TIPO DE ACCION NO VALIDA';            
        end case;        
      else
        p_c_coderr := '002';
        p_c_deserr := 'TABLA NO RECONOCIDA';                    
    end case;
    commit;
  exception
  when others then
    p_c_coderr := sqlcode;
    p_c_deserr := sqlerrm;
  end sp_ah_abm_comision;                              
  Procedure sp_ah_tipper(P_N_CODPGC IN NUMBER,
                         P_N_NUMCTA IN NUMBER,
                         p_c_codval out varchar2
                         ) is
  cursor c_personas is
    select x.*
      from fsr008 x           
     where x.pgcod  = P_N_CODPGC 
       and x.ctnro  = P_N_NUMCTA;  
       
  lv_fis varchar(1):=null;
  lv_jur varchar(1):=null;                           
  begin
    For i in c_personas loop
       begin
         Select 'F'
           into lv_fis
           from fsd002 a 
          where a.pfpais = i.pepais
            and a.pftdoc = i.petdoc
            and a.pfndoc = i.pendoc;
       exception
       when others then         
           lv_fis := null;
           Exit;
       end;   
    End loop;
    For i in c_personas loop    
       begin
         Select 'J'
           into lv_jur
           from fsd003 a 
          where a.pjpais = i.pepais
            and a.pjtdoc = i.petdoc
            and a.pjndoc = i.pendoc;
       exception
       when others then
         lv_jur := null;
         Exit;          
       end;  
    End loop;
    Case
      When lv_fis is not null and lv_jur is not null then
        p_c_codval := '';
      When lv_fis is null and lv_jur is null then
        p_c_codval := ''; 
      When lv_fis is null and lv_jur is not null then
        p_c_codval := 'J';
      Else
        p_c_codval := 'F';
    End Case;

  Exception
  when others then  
      p_c_codval := null;
  end sp_ah_tipper;            
  Function fn_ah_aplica_comision(P_N_ITMOD  IN NUMBER, 
                                 P_N_ITTRAN IN NUMBER,
                                 P_N_CODCOM IN NUMBER,
                                 P_D_FECPRO IN DATE    
                                 ) return varchar2 is
  lv_indcal varchar2(1):='N';                                 
  begin
    Select 'S'
      into lv_indcal
      from fst198  a,
           aqpa109 b
     where a.tp1cod  = 1
       and a.tp1cod1 = 10825
       and a.tp1corr1 = 95
       and a.tp1corr2 = 1
       and a.tp1nro1  = P_N_ITMOD
       and a.tp1nro2  = P_N_ITTRAN
       and a.tp1nro3 = b.aqpa109com
       and b.aqpa109com = decode(P_N_CODCOM,0,b.aqpa109com,P_N_CODCOM)
       and P_D_FECPRO 
              between 
              b.aqpa109fin and 
              case
                when b.aqpa109ffi = to_date('01/01/0001','dd/mm/rrrr') then
                   to_date('31/12/2099','dd/mm/rrrr')
                when b.aqpa109ffi is null then   
                   to_date('31/12/2099','dd/mm/rrrr')
                else
                   b.aqpa109ffi
              end
       and a.tp1imp2  = 1
       and b.aqpa109est = 'S'
       and rownum <2;
       return lv_indcal;
  exception   
  when others then 
     lv_indcal := 'N';
     return lv_indcal;
  end fn_ah_aplica_comision;      
  Procedure sp_ah_datos_asiento(P_N_PGCOD  IN NUMBER,
                                P_N_ITSUC  IN NUMBER,
                                P_N_ITMOD  IN NUMBER, 
                                P_N_ITTRAN IN NUMBER,
                                P_N_ITNREL IN NUMBER,
                                P_N_ITORD  IN NUMBER,
                                P_N_ITSBO  IN NUMBER,
                                 pn_Pgcod  out number, 
                                 pn_ctnro  out number, 
                                 pn_Itoper out number, 
                                 pn_Itsubo out number, 
                                 pn_Itsucd out number, 
                                 pn_Ittope out number, 
                                 pn_Modulo out number, 
                                 pn_Moneda out number, 
                                 pn_Papel  out number, 
                                 pn_monto  out number, 
                                 pn_indcob out number, 
                                 p_c_coderr out varchar2,
                                 p_c_msgerr out varchar2                                                            
                                ) IS   
    --obtenemos los datos de la cuenta
  begin           
    p_c_coderr := '000';    
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
       into  pn_Pgcod, 
             pn_ctnro,
             pn_Itoper,
             pn_Itsubo,
             pn_Itsucd,
             pn_Ittope,
             pn_Modulo,
             pn_Moneda,
             pn_Papel,
             pn_monto,
             pn_indcob 
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
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;             
  end sp_ah_datos_asiento;   
  function fn_ah_comtipper(P_N_CODCOM IN NUMBER,
                           P_C_TIPPER IN VARCHAR2
                          ) return number is
  ln_aqpa109atcp aqpa109a.aqpa109atcp%type;                          
  begin
    Select a.aqpa109atcp
      into ln_aqpa109atcp
      from aqpa109a a
     where a.aqpa109acom = P_N_CODCOM
       and a.aqpa109atpe = P_C_TIPPER;
     return ln_aqpa109atcp;
  exception
  when others then  
   ln_aqpa109atcp := 0;
   return ln_aqpa109atcp;
  end fn_ah_comtipper;      
  Procedure sp_ah_graba_importe_comisio(P_N_PGCOD  IN NUMBER,
                                        P_N_ITSUC  IN NUMBER,
                                        P_N_ITMOD  IN NUMBER,
                                        P_N_ITTRAN IN NUMBER,
                                        P_N_ITNREL IN NUMBER,
                                        P_N_ITORD  IN NUMBER,
                                        P_N_ITSBO  IN NUMBER,
                                        P_N_CODCOM IN NUMBER,
                                        P_N_MONTO1 IN NUMBER,
                                        P_N_MONTO2 IN NUMBER,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2                                            
                                       ) IS
  PRAGMA AUTONOMOUS_TRANSACTION;                                                                      
  begin
    p_c_coderr := '000';    
    If P_N_CODCOM = 1 then
        Update FSD016
           set Itimp3 = P_N_MONTO1               
         Where Pgcod  = P_N_PGCOD
           and Itsuc  = P_N_ITSUC
           and Itmod  = P_N_ITMOD
           and Ittran = P_N_ITTRAN
           and Itnrel = P_N_ITNREL
           and Itord  = P_N_ITORD;      
    Else
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
    End if;
    if sql%notfound then 
       p_c_coderr := '001';
       p_c_msgerr := 'FSD016-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';         
    End If;  
    commit;         
  exception
  when others then
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;
  end sp_ah_graba_importe_comisio;        
  procedure sp_ah_interplaza(P_N_PGCOD  IN NUMBER,
                             P_N_ITSUC  IN NUMBER,
                             P_N_ITMOD  IN NUMBER, 
                             P_N_ITTRAN IN NUMBER,
                             P_N_ITNREL IN NUMBER,
                             P_N_ITORD  IN NUMBER,
                             P_N_ITSBO  IN NUMBER,
                             P_D_FECPRO IN DATE,
                             PN_PGCOD   IN NUMBER,
                             PN_CTNRO   IN NUMBER,
                             PN_ITOPER  IN NUMBER,
                             PN_ITSUBO  IN NUMBER,
                             PN_ITSUCD  IN NUMBER,
                             PN_ITTOPE  IN NUMBER,
                             PN_MODULO  IN NUMBER,
                             PN_MONEDA  IN NUMBER,
                             PN_MONTO   IN NUMBER,
                             PN_BTCP    IN NUMBER,
                             PN_CODTAR  IN NUMBER,
                             PN_CODPRE  IN NUMBER,
                             PN_CODCOM  IN NUMBER,  
                             PN_PREESP  IN NUMBER, 
                             p_n_moncom out number,
                             p_n_nummov out number,                                                     
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2                                                             
                            ) is
  Pgcod    number(3);
  ctnro    number(9);
  Itoper   number(3);
  Itsubo   number(3); 
  Itsucd   number(3);
  Ittope   number(3); 
  Modulo   number(3);
  Moneda   number(4);
  fecha    date;  
  itimp1   number(17,2);
  v_tipo   number;
  tp1nro1  number;
  v_cuenta number;
  plaza1   number;
  plaza2   number;
  Canal    number;
  PFDSU03  number;
  rpta     number := 0;             
  begin
    p_c_coderr :='000';
    -- registramos la sucrusal.
    pq_ah_new_comision.sp_ah_graba_importe_comisio(p_n_pgcod  => P_N_PGCOD,
                                                   p_n_itsuc  => P_N_ITSUC,
                                                   p_n_itmod  => P_N_ITMOD,
                                                   p_n_ittran => P_N_ITTRAN,
                                                   p_n_itnrel => P_N_ITNREL,
                                                   p_n_itord  => P_N_ITORD,
                                                   p_n_itsbo  => P_N_ITSBO,
                                                   p_n_codcom => 1,--interplaza
                                                   p_n_monto1 => P_N_ITSUC,
                                                   p_n_monto2 => 0,
                                                   p_c_coderr => p_c_coderr,
                                                   p_c_msgerr => p_c_msgerr
                                                  );  
    if p_c_coderr = '000' then

       Pgcod  := PN_PGCOD;
       ctnro  := PN_CTNRO;
       Itoper := PN_ITOPER;
       Itsubo := PN_ITSUBO;
       Itsucd := PN_ITSUCD;
       Ittope := PN_ITTOPE;
       Modulo := PN_MODULO;
       Moneda := PN_MONEDA;
       fecha  := P_D_FECPRO;
       itimp1 := PN_MONTO;

      If Modulo = 122 Or Modulo = 22 then
        Modulo := 22;
      Else
        Modulo := Modulo;
        Itoper := 0;
      End If;      
    
      --verif si es un tipo de cuenta exonerada
      v_tipo := 0; 

      if Modulo = 21 AND PN_BTCP = 0 then
         begin
            Select Tp1nro1
              into tp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10884
               and Tp1corr1 = 1
               and Tp1corr2 = 1;
             
              if Ittope = tp1nro1 then
                 v_tipo := 1;
              end if;           
          exception
          when others then
            tp1nro1 := 0;
          end; 
          tp1nro1 := 0;                            
      end if;          

      if v_tipo = 0 then     
         --verif si es cta exonerada  
          v_cuenta := 0;
          begin
            Select 1
              into v_cuenta
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10884
               and Tp1corr1 = 4
               and Tp1corr2 = 1
               and Tp1corr3 >= 1
               and Tp1nro1 = ctnro;                    
          exception
          when others then
            v_cuenta := 0;
          end;     

          if v_cuenta = 0 then                      
              begin
                Select JAQY657PZA
                  into plaza1
                  from jaqy657
                 Where JAQY657SUC = Itsucd;                                  
              exception
              when others then
                plaza1 := 0;
              end;          

            If P_N_ITSUC = 903 then
                Canal := 3;                
                begin
                  Select PfdSu03
                    into PFDSU03
                    from fsd603
                   where PgCod  = P_N_PGCOD  
                     and Itsuc  = P_N_ITSUC  
                     and Itmod  = P_N_ITMOD  
                     and Ittran = P_N_ITTRAN 
                     and Itnrel = P_N_ITNREL;                           
                exception
                when others then
                  PFDSU03 := 0;
                end;                                
                begin
                  Select JAQY657PZA
                    into plaza2
                    from jaqy657
                   where JAQY657SUC = PFDSU03;                                           
                exception
                when others then
                  plaza2 := 0;
                end;                                               
            end if;

            if P_N_ITSUC = 902 then
               Canal := 2;               
                begin
                  Select PfdSu03
                    into PFDSU03
                    from fsd603
                   where PgCod  = P_N_PGCOD  
                     and Itsuc  = P_N_ITSUC  
                     and Itmod  = P_N_ITMOD  
                     and Ittran = P_N_ITTRAN 
                     and Itnrel = P_N_ITNREL;                           
                exception
                when others then
                  PFDSU03 := 0;
                end;                              
                begin
                  Select JAQY657PZA
                    into plaza2
                    from jaqy657
                   where JAQY657SUC = PFDSU03;                                           
                exception
                when others then
                  plaza2 := 0;
                end;                             
            end if;
            
            if P_N_ITSUC < 801 then
                Canal := 1;                
                begin
                  Select JAQY657PZA
                    into plaza2
                    from jaqy657
                   where JAQY657SUC = P_N_ITSUC;                                           
                exception
                when others then
                  plaza2 := 0;
                end;      
            end if;   

            if plaza1 <> 0 then
                if plaza2 <> 0 then
                    if plaza1 <> plaza2 then
                      If PN_BTCP = 0 then
                        if P_N_ITMOD <> 50 or P_N_ITTRAN <>599 or Canal <> 1 or Moneda <> 101 then --TEMPORAL
                            pq_ah_com_interplaza.sp_ah_verif_tablas16(ln_cuenta  => ctnro,
                                                                      ln_scsuc   => Itsucd,
                                                                      ln_modulo  => Modulo,
                                                                      ln_opera   => Itoper,
                                                                      ln_tipo    => Ittope,
                                                                      ln_moneda  => Moneda,
                                                                      ln_subope  => Itsubo,
                                                                      ln_trans   => P_N_ITTRAN,
                                                                      ln_rel     => P_N_ITNREL,
                                                                      ld_fecha   => fecha,
                                                                      ln_pitsuc  => P_N_ITSUC,
                                                                      ln_pitmod  => P_N_ITMOD,
                                                                      ln_pitord  => P_N_ITORD,
                                                                      ln_pitsbor => P_N_ITSBO,
                                                                      ln_monto   => itimp1,
                                                                      ln_canal   => Canal,
                                                                      ln_plaza1  => plaza1,
                                                                      ln_plaza2  => plaza2,
                                                                      lc_rpta    => rpta
                                                                      );    
                        End if;                                                                                                                                   
                        if rpta = 0 then
                           p_c_coderr := '000';  
                           p_c_msgerr := null;                                                                            
                        end If;  
                      Else
                        pq_ah_new_comision.sp_ah_verif_tablas16(ln_cuenta  => ctnro,
                                                                ln_scsuc   => Itsucd,
                                                                ln_modulo  => Modulo,
                                                                ln_opera   => Itoper,
                                                                ln_tipo    => Ittope,
                                                                ln_moneda  => Moneda,
                                                                ln_subope  => Itsubo,
                                                                ln_trans   => P_N_ITTRAN,
                                                                ln_rel     => P_N_ITNREL,
                                                                ld_fecha   => fecha,
                                                                ln_pitsuc  => P_N_ITSUC,
                                                                ln_pitmod  => P_N_ITMOD,
                                                                ln_pitord  => P_N_ITORD,
                                                                ln_pitsbor => P_N_ITSBO,
                                                                ln_monto   => itimp1,
                                                                lc_rpta    => rpta,
                                                                p_n_codtar => PN_CODTAR,
                                                                p_n_codpre => PN_CODPRE,
                                                                p_n_codcom => PN_CODCOM,
                                                                p_n_preesp => PN_PREESP,
                                                                p_n_moncom => p_n_moncom,
                                                                p_n_nummov => p_n_nummov,
                                                                p_c_coderr => p_c_coderr,
                                                                p_c_msgerr => p_c_msgerr
                                                                );                        
                      End If;                                              
                    end if;           
                end if;       
            end if;        
          End if;
      end if;      
    End if;                                              
  exception
  when others then       
     p_c_coderr := sqlcode;  
     p_c_msgerr := sqlerrm;                                                      
  end sp_ah_interplaza;  
  procedure sp_ah_det_criterio(P_D_FECPRO IN DATE,
                               PN_PGCOD   IN NUMBER,
                               PN_CTNRO   IN NUMBER,
                               PN_ITOPER  IN NUMBER,
                               PN_ITSUBO  IN NUMBER,
                               PN_ITSUCD  IN NUMBER,
                               PN_ITTOPE  IN NUMBER,
                               PN_MODULO  IN NUMBER,
                               PN_MONEDA  IN NUMBER,
                               PN_PAPEL   IN NUMBER,
                               PN_MONTO   IN NUMBER,
                               pn_numcri  in out number,
                               p_c_coderr out varchar2,
                               p_c_msgerr out varchar2
                              ) is  
  begin
    p_c_coderr := '000';    
    case
      --CRITERIO POR DEFAULT PARA INTERPLAZA NO VALIDA NADA
      when pn_numcri = 1 then --interplaza PN
        pn_numcri := 1;
      --CRITERIO POR DEFAULT PARA EXCESO DE RETIROS NO VALIDA NADA
      when pn_numcri = 2 then --exceso retiros PN
        pn_numcri := 2;     
      --CRITERIO POR DEFAULT EXCESO DE DEPOSITOS
      when pn_numcri = 3 then --exceso depósitos PN
        pn_numcri := 3;
      --CRITERIO POR DEFAULT DUPLICADO DE TARJETA
      when pn_numcri = 4 then --duplicado de tarjeta PN
        pn_numcri := 4;  
      when pn_numcri = 5 then --duplicado de tarjeta PJ
        pn_numcri := 5;       
      when pn_numcri = 27 then --COBRO COMISION TRANS INTERBANCARIA ARQUI
        begin
          Select 27
            into pn_numcri 
            from jaql485 a,
                 fsd011  b 
           where a.jaql485pge = b.pgcod  
             and a.jaql485suc = b.scsuc   
             and a.jaql485cta = b.sccta 
             and a.jaql485mod = b.scmod 
             and a.jaql485mda = b.scmda  
             and a.jaql485pap = b.scpap  
             and a.jaql485ope = b.scoper  
             and a.jaql485sbo = b.scsbop   
             and a.jaql485top = b.sctope              
             and a.jaql485pge = PN_PGCOD  
             and a.jaql485suc = PN_ITSUCD   
             and a.jaql485cta = PN_CTNRO 
             and a.jaql485mod = PN_MODULO 
             and a.jaql485mda = PN_MONEDA  
             and a.jaql485pap = PN_PAPEL  
             and a.jaql485ope = PN_ITOPER  
             and a.jaql485sbo = PN_ITSUBO   
             and a.jaql485top = PN_ITTOPE   
             and a.jaql485tco = 6
             and P_D_FECPRO between a.jaql485fei and a.jaql485fef
             and a.jaql485fei >= to_date('01/07/2023','dd/mm/rrrr')
             and a.jaql485fef <= to_date('30/10/2024','dd/mm/rrrr')
             and b.scfval >= to_date('01/07/2023','dd/mm/rrrr')
             and b.scfval <= to_date('30/08/2023','dd/mm/rrrr')             
             and rownum < 2;             
        exception
        when others then
          pn_numcri := 28;          
        End;                  
      Else   
        pn_numcri  := pn_numcri;
        p_c_coderr := '001';
        p_c_msgerr := 'No se encontró criterio aplicacble a producto';
    end Case;
  exception
  when others then
     p_c_coderr := sqlcode;  
     p_c_msgerr := sqlerrm;      
  end sp_ah_det_criterio;   
  
  function fn_ah_crican(P_N_CODCRI IN NUMBER,
                        P_N_CODCAN IN NUMBER
                       ) return number is
  ln_aqpa109dcct aqpa109d.aqpa109dcct%type;                          
  begin
    Select a.aqpa109dcct
      into ln_aqpa109dcct
      from aqpa109d a
     where a.aqpa109dcri = P_N_CODCRI
       and a.aqpa109dcan = P_N_CODCAN;
     return ln_aqpa109dcct;
  exception
  when others then  
   ln_aqpa109dcct := 0;
   return ln_aqpa109dcct;
  end fn_ah_crican;      
  procedure sp_ah_tarifario_comision(PN_CRICAN  IN NUMBER,                                         
                                     PN_ITSUCD  IN NUMBER,
                                     PN_ITTOPE  IN NUMBER,
                                     PN_MODULO  IN NUMBER,
                                     PN_MONEDA  IN NUMBER,                                     
                                     pn_codtar  out number,
                                     pn_codpre  out number,
                                     p_c_coderr out varchar2,
                                     p_c_msgerr out varchar2
                                    ) is
  begin
    p_c_coderr := '000';
    pn_codtar := 0;
    pn_codpre := 0;   
    
    Select a.aqpa109etar,
           a.aqpa109etpr 
      into pn_codtar,
           pn_codpre
      from aqpa109e a 
     where a.aqpa109ecct = PN_CRICAN
       and a.aqpa109emod = PN_MODULO       
       and a.aqpa109etop = PN_ITTOPE
       and a.aqpa109emda = PN_MONEDA
       and a.aqpa109eage = PN_ITSUCD;
  exception
  when no_data_found then
    begin
      Select a.aqpa109etar,
             a.aqpa109etpr 
        into pn_codtar,
             pn_codpre
        from aqpa109e a 
       where a.aqpa109ecct = PN_CRICAN
         and a.aqpa109emod = PN_MODULO       
         and a.aqpa109etop = PN_ITTOPE
         and a.aqpa109emda = PN_MONEDA
         and a.aqpa109eage = 999;
    exception
    when no_data_found then
       p_c_coderr := '003';  
       p_c_msgerr := 'No se encontró tarifario';      
    when others then   
       p_c_coderr := sqlcode;  
       p_c_msgerr := sqlerrm;         
    End;    
  when others then
     p_c_coderr := sqlcode;  
     p_c_msgerr := sqlerrm;    
  end sp_ah_tarifario_comision;   
   
  Procedure sp_ah_det_precio(P_N_CODPRE IN NUMBER,
                             p_n_codmod out number,
                             p_n_codcod out number,
                             p_n_topmov out number,
                             p_n_topsal out number,
                             p_c_coderr out varchar2, 
                             p_c_msgerr out varchar2                             
                            ) is                        
  begin
    Select a.aqpa109gmod,
           a.aqpa109gcod,
           a.aqpa109gnum,
           a.aqpa109gmon
      into p_n_codmod,  
           p_n_codcod, 
           p_n_topmov, 
           p_n_topsal       
      from aqpa109g a
     where a.aqpa109gtpr = P_N_CODPRE;
     p_c_coderr := '000';
     p_c_msgerr := '';
  exception
  when no_data_found then
    p_n_codmod := 0; 
    p_n_codcod := 0; 
    p_n_topmov := 0;
    p_n_topsal := 0;
    p_c_coderr := '005';  
    p_c_msgerr := 'No se encontre detalle para el precio';       
  when others then  
    p_n_codmod := 0; 
    p_n_codcod := 0; 
    p_n_topmov := 0;
    p_n_topsal := 0;
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;
  end sp_ah_det_precio;         
  Function fn_ah_mov_canal(P_D_FECPRO IN DATE,
                           P_N_CODTAR IN NUMBER,
                           P_N_NUMMOV IN NUMBER,
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
  ln_codcan number(9);
  begin
  ld_fecsis := P_D_FECPRO;
  
  select opgval into lc_indoff from fst200 where opgcod=544;  
  
  --obtenemos el canal para evaluar las fechas de exoneración
  begin
   select a.aqpa109dcan
     into ln_codcan
     from aqpa109d a,
          aqpa109e b
     where a.aqpa109dcct = b.aqpa109ecct
       and b.aqpa109etar = P_N_CODTAR;
  Exception
  When others then
    ln_codcan := 0;               
  end;   
  
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
      and JAQL485AX2 = ln_codcan;
      
      if ld_fecini is null then
         ld_fecini := ld_fecsis;         
      end if;
  Exception
  When others then
    ld_fecini := ld_fecsis;               
  end;  

    if lc_indoff = 'S' Then --online
     If ld_fecsis = trunc(sysdate) Then
                   
        If substr(to_char(ld_fecsis,'dd/mm/yyyy'),1,2) = '01' Then        
            ln_totdia := pq_ah_new_comision.fn_ah_mov_dia(p_n_codtar => P_N_CODTAR,
                                                          p_n_nummov => P_N_NUMMOV,
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
          if ld_fecini = ld_fecsis then
             ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
          Else  
             ld_fecini := ld_fecini + 1;
          End If;                
          ld_fecfin := ld_fecsis - 1;                                                                 
          ln_totdia := pq_ah_new_comision.fn_ah_mov_dia(p_n_codtar => P_N_CODTAR,
                                                        p_n_nummov => P_N_NUMMOV,          
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
                     
          ln_tothis := pq_ah_new_comision.fn_ah_mov_his(p_n_codtar => P_N_CODTAR,
                                                        p_n_nummov => P_N_NUMMOV,           
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
          if ld_fecini = ld_fecsis then
             ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
          Else  
             ld_fecini := ld_fecini + 1;
          End If;              
          ld_fecfin := ld_fecsis;                                       
          ln_tothis := pq_ah_new_comision.fn_ah_mov_his(p_n_codtar => P_N_CODTAR,
                                                        p_n_nummov => P_N_NUMMOV,           
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
              ln_totdia := pq_ah_new_comision.fn_ah_mov_dia(p_n_codtar => P_N_CODTAR,
                                                            p_n_nummov => P_N_NUMMOV,               
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
            if ld_fecini = ld_fecsis then
               ld_fecini := to_date('01'||substr(to_char(ld_fecsis,'dd/mm/rrrr'),3,8),'dd/mm/rrrr');
            Else  
               ld_fecini := ld_fecini + 1;
            End If;                  
            ld_fecfin := ld_fecsis - 1;      
            ln_totdia := pq_ah_new_comision.fn_ah_mov_dia(p_n_codtar => P_N_CODTAR,
                                                          p_n_nummov => P_N_NUMMOV, 
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
            ln_tothis := pq_ah_new_comision.fn_ah_mov_his(p_n_codtar => P_N_CODTAR,
                                                          p_n_nummov => P_N_NUMMOV,             
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
            ln_totdia := pq_ah_new_comision.fn_ah_mov_dia(p_n_codtar => P_N_CODTAR,
                                                          p_n_nummov => P_N_NUMMOV,   
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
            ln_totdia := pq_ah_new_comision.fn_ah_mov_dia(p_n_codtar => P_N_CODTAR,
                                                          p_n_nummov => P_N_NUMMOV,   
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
            ln_tothis := pq_ah_new_comision.fn_ah_mov_his(p_n_codtar => P_N_CODTAR,
                                                          p_n_nummov => P_N_NUMMOV,   
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
        ln_tothis := pq_ah_new_comision.fn_ah_mov_his(p_n_codtar => P_N_CODTAR,
                                                      p_n_nummov => P_N_NUMMOV,  
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
                                      
  ln_totmov := ln_totdia + ln_tothis + ln_totoff;    
  return ln_totmov;  
  end fn_ah_mov_canal;     
  Function fn_ah_mov_dia(P_N_CODTAR IN NUMBER,
                         P_N_NUMMOV IN NUMBER,
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
        select nvl(count(1), 0)
          into ln_totdia
          from fsd016 f, fsd015 h, aqpa109f a
         where f.pgcod = h.pgcod
           and f.itsuc = h.itsuc
           and f.itmod = h.itmod
           and h.itmod = a.aqpa109fmod
           and f.ittran = h.ittran
           and h.ittran = a.aqpa109ftrx
           and f.itnrel = h.itnrel
           and f.itord = a.aqpa109ford
           and h.itcorr <> 99
           and h.itcont = 'S'
           and f.pgcod = P_N_PGCOD
           and f.ctnro = P_N_CTNRO
           and f.itoper = P_N_ITOPER
           and f.itsubo = P_N_ITSUBO
           and f.modulo = P_N_MODULO
           and f.itsucd = P_N_SUCDES
           and f.ittope = P_N_ITTOPE
           and f.moneda = P_N_MONEDA
           and f.papel = P_N_PAPEL
           and f.pgcod = 1
           and h.pgcod = 1
           and a.aqpa109ftar = P_N_CODTAR
           and f.Itimp4 = P_N_NUMMOV;
      Exception
      When others then
           ln_totdia := 0;         
      End;     
  return ln_totdia;   
  end fn_ah_mov_dia;
  Function fn_ah_mov_his(P_N_CODTAR IN NUMBER,
                         P_N_NUMMOV IN NUMBER,
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
        select nvl(count(1), 0)
          into ln_tothis
          from fsh016 f, fsh015 h, aqpa109f a
         where f.pgcod = h.pgcod
           and f.hsucor = h.hsucor
           and f.hcmod = h.hcmod
           and h.hcmod = a.aqpa109fmod
           and f.htran = h.htran
           and h.htran = a.aqpa109ftrx
           and f.hnrel = h.hnrel
           and h.hfcon = f.hfcon
           and f.hfcon between P_D_FECINI and P_D_FECFIN
           and f.hcord = a.aqpa109ford
           and h.hccorr <> 99
           and f.pgcod = P_N_PGCOD
           and f.hcta = P_N_CTNRO
           and f.hoper = P_N_ITOPER
           and f.hsubop = P_N_ITSUBO
           and f.hmodul = P_N_MODULO
           and f.hsucur = P_N_SUCDES
           and f.htoper = P_N_ITTOPE
           and f.hmda = P_N_MONEDA
           and f.hpap = P_N_PAPEL
           and f.pgcod = 1
           and h.pgcod = 1
           and a.aqpa109ftar = P_N_CODTAR
           and f.hcimp4 = P_N_NUMMOV;
      Exception
      When others then
           ln_tothis := 0;         
      End;    
  return ln_tothis;    
  end fn_ah_mov_his;  
  Function fn_ah_verif_monto(monto   in number,
                             moneda  in number,
                             fecha   in date,
                             moncol  in number,
                             tipoper in number)  return number is
    ln_rpta   number;
    v_importe number(17, 2);
    t_cambio  number(10,7);
    ult_fecha date;
  Begin
    /*
    select TP1IMP1
      into v_importe
      from fst198
     where TP1COD = 1
       and TP1COD1 = 10884
       and TP1CORR1 = 2
       and TP1CORR2 = 1
       and TP1CORR3 = 1;
       */
     v_importe := moncol;
     if v_importe = 0 then
        ln_rpta := 0;
     Else
       if  moneda = 101 then
          begin
            select tccpa into t_cambio
              from fsd120
             where tcfch = fecha
               and tchor = (select max(tchor) from fsd120  where tcfch = fecha );
           exception
             when no_data_found then
              select max(tcfch)into ult_fecha
              from fsd120;
              select tccpa into t_cambio
              from fsd120
             where tcfch = ult_fecha
               and tchor = (select max(tchor) from fsd120  where tcfch = ult_fecha  );
           end;
       
           v_importe := v_importe / t_cambio;
         
           if monto <= v_importe then
              ln_rpta := 0;
           else
              ln_rpta := 1; 
           end if;
       end if;
       if moneda = 0 then
       
          if monto <= v_importe then
            ln_rpta := 0;
          else
            ln_rpta := 1; 
          end if;
       end if;
     End If;
     return(ln_rpta);
  end fn_ah_verif_monto;

  Function fn_ah_verif_nroope(P_N_CODPRE IN NUMBER, ope in number) return number is
  --v_nro  number;
  v_rpta number;
  ln_codmod    number(3) := 0;
  ln_codcod    number(3) := 0;
  ln_topmov    number(3) := 0;
  ln_topsal    number(17,2) := 0;  
  p_c_coderr   varchar2(400):='';
  p_c_msgerr   varchar2(400):='';
  Begin
-- detalle del precio
  pq_ah_new_comision.sp_ah_det_precio(p_n_codpre => P_N_CODPRE,
                                      p_n_codmod => ln_codmod,
                                      p_n_codcod => ln_codcod,
                                      p_n_topmov => ln_topmov,
                                      p_n_topsal => ln_topsal,
                                      p_c_coderr => p_c_coderr,
                                      p_c_msgerr => p_c_msgerr
                                      ); 
       
       
    if ope <= ln_topmov  then
      v_rpta := 0;
    else
      v_rpta := 1;
    end if;
    return(v_rpta);
  end fn_ah_verif_nroope;
  Function fn_ah_verifica_tar_especial(P_D_FECPRO IN DATE,
                                       P_N_PGCOD  IN NUMBER,
                                       P_N_CTNRO  IN NUMBER,
                                       P_N_ITOPER IN NUMBER,
                                       P_N_ITSUBO IN NUMBER,
                                       P_N_SUCDES IN NUMBER,
                                       P_N_ITTOPE IN NUMBER,
                                       P_N_MODULO IN NUMBER,
                                       P_N_MONEDA IN NUMBER,
                                       P_N_PAPEL  IN NUMBER,
                                       P_N_CODCOM IN NUMBER,   
                                       P_N_CODCAN IN NUMBER                                                      
                                      )return number is
  ln_codpre  number(9):= 0;                                    
  begin
     select b.jaql481coc
       into ln_codpre
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
        and a.jaql482sbo = case
                           when P_N_MODULO = 22 then
                             a.jaql482sbo
                           else
                             P_N_ITSUBO
                           end                                       
        and a.jaql482top = P_N_ITTOPE
        and a.jaql482fei <= P_D_FECPRO
        and a.jaql482fef >= P_D_FECPRO
        and b.jaql481fei <= P_D_FECPRO
        and b.jaql481fef >= P_D_FECPRO
        and b.jaql481ax1 = P_N_CODCAN
        and a.jaql482ax1 = P_N_CODCOM
        and rownum <2;
        return ln_codpre;
  exception 
  when others then  
    return ln_codpre;
  end fn_ah_verifica_tar_especial; 
  Function fn_ah_verifica_exoneracion(P_D_FECPRO IN DATE,
                                      P_N_PGCOD  IN NUMBER,
                                      P_N_CTNRO  IN NUMBER,
                                      P_N_ITOPER IN NUMBER,
                                      P_N_ITSUBO IN NUMBER,
                                      P_N_SUCDES IN NUMBER,
                                      P_N_ITTOPE IN NUMBER,
                                      P_N_MODULO IN NUMBER,
                                      P_N_MONEDA IN NUMBER,
                                      P_N_PAPEL  IN NUMBER,
                                      P_N_CODCOM IN NUMBER,   
                                      P_N_CODCAN IN NUMBER                                                      
                                     )return varchar2 is
  lc_indcob  char(1):='S';
  v_tipo   number;   
  v_cuenta number;
  tp1nro1  number;
  begin    
    if P_N_CODCOM = 1 then --Interplaza      
      if P_N_MODULO = 21 then
          v_tipo := 0; 
          begin
            Select Tp1nro1
              into tp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10884
               and Tp1corr1 = 1
               and Tp1corr2 = 1;
             
              if P_N_ITTOPE = tp1nro1 then
                 v_tipo := 1;
              end if;           
          exception
          when others then
            tp1nro1 := 0;
          end; 
          
          if v_tipo = 0 then     
             --verif si es cta exonerada  
              v_cuenta := 0;
              begin
                Select 1
                  into v_cuenta
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10884
                   and Tp1corr1 = 4
                   and Tp1corr2 = 1
                   and Tp1corr3 >= 1
                   and Tp1nro1 = P_N_CTNRO;                    
              exception
              when others then
                v_cuenta := 0;
              end; 
              if v_cuenta = 0 then --verificamos exoneración por producto   
                begin
                   select 'N'      
                     into lc_indcob
                     from jaql485 
                    where JAQL485PGE  = P_N_PGCOD
                      and JAQL485SUC  = P_N_SUCDES
                      and JAQL485CTA  = P_N_CTNRO
                      and JAQL485MOD  = P_N_MODULO
                      and JAQL485MDA  = P_N_MONEDA
                      and JAQL485PAP  = P_N_PAPEL
                      and JAQL485OPE  = P_N_ITOPER
                      and JAQL485SBO  = case
                                         when P_N_MODULO = 22 then
                                           JAQL485SBO
                                         else
                                           P_N_ITSUBO
                                         end              
                      and JAQL485TOP  = P_N_ITTOPE
                      and JAQL485TCO  = P_N_CODCOM
                      and JAQL485FEI <= P_D_FECPRO
                      and JAQL485FEF >= P_D_FECPRO
                      and JAQL485AX2  = P_N_CODCAN
                      and rownum < 2;
                      return lc_indcob; 
                exception 
                when others then  
                  return lc_indcob;        
                end;
              else
                return lc_indcob;                   
              end if; 
          else
            return lc_indcob;  
          end If;
        else
          begin
             select 'N'      
               into lc_indcob
               from jaql485 
              where JAQL485PGE  = P_N_PGCOD
                and JAQL485SUC  = P_N_SUCDES
                and JAQL485CTA  = P_N_CTNRO
                and JAQL485MOD  = P_N_MODULO
                and JAQL485MDA  = P_N_MONEDA
                and JAQL485PAP  = P_N_PAPEL
                and JAQL485OPE  = P_N_ITOPER
                and JAQL485SBO  = case
                                   when P_N_MODULO = 22 then
                                     JAQL485SBO
                                   else
                                     P_N_ITSUBO
                                   end              
                and JAQL485TOP  = P_N_ITTOPE
                and JAQL485TCO  = P_N_CODCOM
                and JAQL485FEI <= P_D_FECPRO
                and JAQL485FEF >= P_D_FECPRO
                and JAQL485AX2  = P_N_CODCAN
                and rownum < 2;
                return lc_indcob; 
          exception 
          when others then  
            return lc_indcob;        
          end;                                         
        end If;                              
    else
      begin
         select 'N'      
           into lc_indcob
           from jaql485 
          where JAQL485PGE  = P_N_PGCOD
            and JAQL485SUC  = P_N_SUCDES
            and JAQL485CTA  = P_N_CTNRO
            and JAQL485MOD  = P_N_MODULO
            and JAQL485MDA  = P_N_MONEDA
            and JAQL485PAP  = P_N_PAPEL
            and JAQL485OPE  = P_N_ITOPER
            and JAQL485SBO  = case
                               when P_N_MODULO = 22 then
                                 JAQL485SBO
                               else
                                 P_N_ITSUBO
                               end              
            and JAQL485TOP  = P_N_ITTOPE
            and JAQL485TCO  = P_N_CODCOM
            and JAQL485FEI <= P_D_FECPRO
            and JAQL485FEF >= P_D_FECPRO
            and JAQL485AX2  = P_N_CODCAN
            and rownum < 2;
            return lc_indcob; 
      exception 
      when others then  
        return lc_indcob;        
      end;       
    end if;    
  exception 
  when others then  
    return lc_indcob;
  end fn_ah_verifica_exoneracion;  
  Procedure sp_ah_reg_tasesp_ah(P_N_PGCOD  IN NUMBER,
                                P_N_MODULO IN NUMBER,
                                P_N_MONEDA IN NUMBER,
                                P_N_PAPEL  IN NUMBER,
                                P_N_CTNRO  IN NUMBER,
                                P_N_ITSUBO IN NUMBER,
                                P_N_ITTOPE IN NUMBER,
                                P_D_FECINI IN DATE,
                                P_D_FECFIN IN DATE,
                                P_N_TASESP IN NUMBER,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2
                               ) IS 
    petipo    char(1);
    tipo      number(9);
    ctifin    char(1);
    vmodtcli  number(9);    
    lc_existe char(1);                            
  begin
    p_c_coderr := '000';
    begin
      select 'S'
        into ctifin
        from fsd008
       where pgcod = P_N_PGCOD
         and ctnro = P_N_CTNRO
         and seccod in (3, 5);
    exception
      when no_data_found then
        ctifin := 'N';
    end;
  
    begin
      select b.petipo
        into petipo
        from fsr008 a, fsd001 b
       where a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc
         and a.ctnro  = P_N_CTNRO
         and a.ttcod  = 1
         and a.cttfir = 'T';
    exception
      when no_data_found then
        petipo := 'F';
    end;
    
      begin
        select totpiz
          into tipo
          from fst004
         where modulo = 21
           and toeleg = 'S'
           and totope = P_N_ITTOPE;
      exception
        when others then
          tipo := 0;
      end;
      if petipo = 'J' then
        If ctifin = 'S' then        
          vmodtcli := 3;        
        Else
          vmodtcli := 2;
        End If;
      
        begin
          select ModCodn
            into tipo
            from FST100 -- ModCodN
           Where ModTcli = vmodtcli -- 2
             and ModSuc = 0
             and ModCod = tipo;
        exception
          when no_data_found then
            null; -- tipo := 0; 20171025 si no existe para el modificador dejar el de PF
        end;
      end if;
      /*     
      begin
        select 'S'
          into lc_existe
          from (select tastasa
                  from FSR427 t1, fsd427 t2
                 where t1.tasemp  = t2.tasemp
                   and t1.tasmod  = t2.tasmod
                   and t1.taspiz  = t2.taspiz
                   and t1.tascta  = t2.tascta
                   and t1.tassop  = t2.tassop
                   and t1.tasmda  = t2.tasmda
                   and t1.taspap  = t2.taspap
                   and t1.tasfdes = t2.tasfdes
                   and t1.tasmto  = t2.tasmto
                   and t1.tasemp  = P_N_PGCOD
                   and t1.tasmod  = P_N_MODULO
                   and t1.taspiz  = tipo
                   and t1.tascta  = P_N_CTNRO
                   and t1.tassop  = P_N_ITSUBO
                   and t1.tasmda  = P_N_MONEDA
                   and t1.tasmto  >= 999999999999998.99
                   and t1.tasfdes <= P_D_FECINI
                   and t2.tasvig  = 'S'
                   and t1.tastasa = P_N_TASESP
                 order by t1.tasfdes desc, t1.tasmto)
         where rownum = 1;  
      exception when others then    
        lc_existe := 'N';
      end;
      */
      
      /*if lc_existe = 'N' then*/   
          begin
            insert into FSR427(tasemp, 
                               tasmod,
                               taspiz,
                               tascta, 
                               tassop,
                               tasmda, 
                               taspap,
                               tasfdes, 
                               tasmto, 
                               taspzo,
                               tastasa
                               ) 
                        values(P_N_PGCOD,
                               P_N_MODULO,
                               tipo,
                               P_N_CTNRO,
                               P_N_ITSUBO,
                               P_N_MONEDA,
                               P_N_PAPEL,
                               P_D_FECINI,
                               999999999999998.99,
                               99999,
                               P_N_TASESP
                               );
          exception
          When dup_val_on_index then
            update FSR427
               set tastasa = P_N_TASESP
             where tasemp  = P_N_PGCOD
               and tasmod  = P_N_MODULO
               and taspiz  = tipo
               and tascta  = P_N_CTNRO
               and tassop  = P_N_ITSUBO
               and tasmda  = P_N_MONEDA
               and taspap  = P_N_PAPEL
               and tasfdes = P_D_FECINI
               and tasmto  = 999999999999998.99
               and taspzo  = 99999;
          When others then              
            p_c_coderr := '001';
            p_c_msgerr := sqlerrm;                               
          end;
          
          begin
            insert into FSD427(tasemp, 
                               tasmod, 
                               taspiz, 
                               tascta, 
                               tassop, 
                               tasmda, 
                               taspap, 
                               tasfdes,
                               tasmto, 
                               tasttas,
                               tasfinv,
                               tasvig 
                               ) 
                        values(P_N_PGCOD,
                               P_N_MODULO,
                               tipo,
                               P_N_CTNRO,
                               P_N_ITSUBO,
                               P_N_MONEDA,
                               P_N_PAPEL,
                               P_D_FECINI,
                               999999999999998.99,
                               1,
                               99999999-to_number(to_char(P_D_FECINI,'RRRRMMDD')),
                               'S'
                               );
          exception
          When dup_val_on_index then
            update FSD427
               set tasfinv = 99999999-to_number(to_char(P_D_FECINI,'RRRRMMDD'))
             where tasemp  = P_N_PGCOD
               and tasmod  = P_N_MODULO
               and taspiz  = tipo
               and tascta  = P_N_CTNRO
               and tassop  = P_N_ITSUBO
               and tasmda  = P_N_MONEDA
               and taspap  = P_N_PAPEL
               and tasfdes = P_D_FECINI
               and tasmto  = 999999999999998.99;         
          When others then  
            p_c_coderr := '002';
            p_c_msgerr := sqlerrm;                                   
          end;
          
          begin
            insert into FSD328(vtasemp,  
                               vtasmod, 
                               vtaspiz,
                               vtascta,  
                               vtassop,  
                               vtasmda,  
                               vtaspap, 
                               vtasfdes, 
                               vtasfvto 
                               ) 
                        values(P_N_PGCOD,
                               P_N_MODULO,
                               tipo,
                               P_N_CTNRO,
                               P_N_ITSUBO,
                               P_N_MONEDA,
                               P_N_PAPEL,
                               P_D_FECINI,
                               P_D_FECFIN
                               );
          exception
          When dup_val_on_index then
              update FSD328
                 set vtasfvto = P_D_FECFIN
               where VTASEMP  = P_N_PGCOD
                 and VTASMOD  = P_N_MODULO
                 and VTASPIZ  = tipo
                 and VTASCTA  = P_N_CTNRO
                 and VTASSOP  = P_N_ITSUBO
                 and VTASMDA  = P_N_MONEDA
                 and VTASPAP  = P_N_PAPEL
                 and VTASFDES = P_D_FECINI;
          When others then  
            p_c_coderr := '003';
            p_c_msgerr := sqlerrm;                                   
          end; 
          if p_c_coderr = '000' then
             commit;
          Else
             rollback;
          End If;   
          /*      
      else
        p_c_coderr := '00x';  
        p_c_msgerr := 'Ya existe tasa registrada'; 
      end if;
      */
  exception
  when others then          
    p_c_coderr := '003';
    p_c_msgerr := sqlerrm;
  end sp_ah_reg_tasesp_ah;                                                   
  Procedure sp_ah_reg_logcta_ah(P_N_PGCOD  IN NUMBER,
                                P_N_MODULO IN NUMBER,
                                P_N_SUCURS IN NUMBER,
                                P_N_MONEDA IN NUMBER,
                                P_N_PAPEL  IN NUMBER,
                                P_N_CTNRO  IN NUMBER,
                                P_N_OPERAC IN NUMBER,
                                P_N_ITSUBO IN NUMBER,
                                P_N_ITTOPE IN NUMBER,
                                P_D_FECPRO IN DATE,
                                P_N_TASINI IN NUMBER,
                                P_N_TASFIN IN NUMBER,
                                P_C_CODEST IN VARCHAR2,
                                P_C_CODUSU IN VARCHAR2,
                                P_C_DESMSG IN VARCHAR2,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2
                               ) IS   
  ln_codsuc  number(3):=0;                               
  begin       
    p_c_coderr := '000';     
    begin
      Select a.ubsuc
        into ln_codsuc 
        from fst046 a 
       where a.pgcod  = P_N_PGCOD 
         and a.ubuser = rpad(P_C_CODUSU,10,' ');
    exception
    when others then  
      ln_codsuc := 0;
      p_c_coderr := '001';
      p_c_msgerr := 'No existe sucvursal para el usuario - '||trim(P_C_CODUSU);
      return;
    end;   
    insert into jaqz194(jaqz194cor,
                        jaqz194pgc,
                        jaqz194mod,
                        jaqz194suc,
                        jaqz194mda,
                        jaqz194pap,
                        jaqz194cta,
                        jaqz194ope,
                        jaqz194sbo,
                        jaqz194tpo,
                        jaqz194tan,
                        jaqz194tac,
                        jaqz194fec,
                        jaqz194hor,
                        jaqz194usr,
                        jaqz194age,
                        jaqz194est,
                        jaqz194msg
                       ) 
                 values(SQ_AH_ID_LOGCTA.NEXTVAL,
                        P_N_PGCOD,  
                        P_N_MODULO, 
                        P_N_SUCURS,
                        P_N_MONEDA, 
                        P_N_PAPEL,  
                        P_N_CTNRO,  
                        P_N_OPERAC, 
                        P_N_ITSUBO, 
                        P_N_ITTOPE, 
                        P_N_TASINI,
                        P_N_TASFIN,
                        P_D_FECPRO,
                        to_char(sysdate,'HH24:mi:ss'),
                        decode(trim(P_C_CODUSU),null,'BANTOTAL',RPAD(P_C_CODUSU,10,' ')),
                        ln_codsuc,
                        P_C_CODEST,
                        P_C_DESMSG                 
                       );
                       commit;
  exception
  when others then                  
      p_c_coderr := '002';
      p_c_msgerr := sqlerrm;
  end sp_ah_reg_logcta_ah;  
  Procedure sp_ah_del_tasesp_ah(P_N_PGCOD  IN NUMBER,
                                P_N_MODULO IN NUMBER,
                                P_N_MONEDA IN NUMBER,
                                P_N_PAPEL  IN NUMBER,
                                P_N_CTNRO  IN NUMBER,
                                P_N_ITSUBO IN NUMBER,
                                P_N_ITTOPE IN NUMBER,
                                P_D_FECPRO IN DATE,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2
                               ) IS   
    petipo    char(1);
    tipo      number(9);
    ctifin    char(1);
    vmodtcli  number(9);                                  
  begin
    p_c_coderr := '000';
    begin
      select 'S'
        into ctifin
        from fsd008
       where pgcod = P_N_PGCOD
         and ctnro = P_N_CTNRO
         and seccod in (3, 5);
    exception
      when no_data_found then
        ctifin := 'N';
    end;
  
    begin
      select b.petipo
        into petipo
        from fsr008 a, fsd001 b
       where a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc
         and a.ctnro  = P_N_CTNRO
         and a.ttcod  = 1
         and a.cttfir = 'T';
    exception
      when no_data_found then
        petipo := 'F';
    end;
    
      begin
        select totpiz
          into tipo
          from fst004
         where modulo = 21
           and toeleg = 'S'
           and totope = P_N_ITTOPE;
      exception
        when others then
          tipo := 0;
      end;
      if petipo = 'J' then
        If ctifin = 'S' then        
          vmodtcli := 3;        
        Else
          vmodtcli := 2;
        End If;
      
        begin
          select ModCodn
            into tipo
            from FST100 -- ModCodN
           Where ModTcli = vmodtcli -- 2
             and ModSuc = 0
             and ModCod = tipo;
        exception
          when no_data_found then
            null; -- tipo := 0; 20171025 si no existe para el modificador dejar el de PF
        end;
      end if;     
      begin
        delete 
         from FSR427 
        where TASEMP  = P_N_PGCOD 
          and TASMOD  = P_N_MODULO 
          and TASPIZ  = tipo  
          and TASCTA  = P_N_CTNRO  
          and TASSOP  = P_N_ITSUBO  
          and TASMDA  = P_N_MONEDA  
          and TASPAP  = P_N_PAPEL   
          and TASFDES = P_D_FECPRO  
          and TASMTO  = 999999999999998.99 
          and TASPZO  = 99999;     
          if sql%rowcount = 0 then
            p_c_coderr :='001';
            p_c_msgerr := 'FSR427 No se encontró registro a borrar';
            return;
          End If;   
      end;  
      begin 
         delete 
           from FSD427  
          where TASEMP  = P_N_PGCOD
            and TASMOD  = P_N_MODULO
            and TASPIZ  = tipo
            and TASCTA  = P_N_CTNRO
            and TASSOP  = P_N_ITSUBO
            and TASMDA  = P_N_MONEDA
            and TASPAP  = P_N_PAPEL
            and TASFDES = P_D_FECPRO
            and TASMTO  = 999999999999998.99;   
            commit;  
            if sql%rowcount = 0 then
              p_c_coderr :='002';
              p_c_msgerr := 'FSD427 No se encontró registro a borrar';
              return;
            End If;                    
      end;
  exception
  when others then                                 
    p_c_coderr := '003';
    p_c_msgerr := sqlerrm;    
  end sp_ah_del_tasesp_ah; 
  procedure sp_ah_tasa_especial_sub(P_N_PGCOD  IN NUMBER,
                                    P_N_MODULO IN NUMBER,
                                    P_N_MONEDA IN NUMBER,
                                    P_N_PAPEL  IN NUMBER,
                                    P_N_CTNRO  IN NUMBER,
                                    P_N_ITSUBO IN NUMBER,
                                    P_N_ITTOPE IN NUMBER,
                                    P_D_FECPRO IN DATE,
                                    p_d_fecini out date,
                                    p_d_fecfin out date,
                                    p_n_tasesp out number,
                                    p_c_coderr out varchar2,
                                    p_c_msgerr out varchar2
                                   ) IS     
  begin
      p_d_fecini := null;
      p_d_fecfin := null;
      p_n_tasesp := 0;
      p_c_coderr := '000';
  
         select  aa.vtasfdes, aa.vtasfvto, aa.tastasa
           into  p_d_fecini,  p_d_fecfin,  p_n_tasesp 
          from (select t3.vtasfdes, t3.vtasfvto, t1.tastasa
                  from FSR427 t1, fsd427 t2, fsd328 t3  
                 where t1.tasemp = t2.tasemp
                   and t1.tasmod = t2.tasmod
                   and t1.taspiz = t2.taspiz
                   and t1.tascta = t2.tascta
                   and t1.tassop = t2.tassop
                   and t1.tasmda = t2.tasmda
                   and t1.taspap = t2.taspap
                   and t1.tasfdes = t2.tasfdes
                   and t1.tasmto = t2.tasmto
                   and t2.tasemp = t3.vtasemp
                   and t2.tasmod = t3.vtasmod
                   and t2.tascta = t3.vtascta
                   and t2.tassop = t3.vtassop
                   and t2.tasmda = t3.vtasmda
                   and t2.taspap = t3.vtaspap
                   and t2.tasfdes = t3.vtasfdes
                   and t1.tasemp = P_N_PGCOD
                   and t1.tasmod = P_N_MODULO
                   --and t1.taspiz = tipo
                   and t1.tascta = P_N_CTNRO
                   and t1.tassop = P_N_ITSUBO
                   and t1.tasmda = P_N_MONEDA
                   and t1.tasmto >= 999999999999998.99
                   and t1.tasfdes <= P_D_FECPRO
                   and t2.tasvig = 'S'
              order by t1.tasfdes desc, t1.tasmto
              )aa
         where rownum = 1;  
  exception         
  when no_data_found then    
      p_d_fecini := null;
      p_d_fecfin := null;
      p_n_tasesp := 0;
  when others then
      p_d_fecini := null;
      p_d_fecfin := null;
      p_n_tasesp := 0;
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;    
  end sp_ah_tasa_especial_sub;  
  function fn_ah_abono_n_meses(P_D_FECPRO IN DATE,
                               P_N_PGCOD  IN NUMBER,
                               P_N_MODULO IN NUMBER,
                               P_N_SUCDES IN NUMBER,
                               P_N_MONEDA IN NUMBER,
                               P_N_PAPEL  IN NUMBER,
                               P_N_CTNRO  IN NUMBER,
                               P_N_ITOPER IN NUMBER,
                               P_N_ITSUBO IN NUMBER,
                               P_N_ITTOPE IN NUMBER
                               ) return varchar2 is
  ln_meses  number(9):= 0;   
  ld_fecini date;
  ld_fecfin date;      
  ln_sucori number(3):= 0;   
  ld_fecabo  date; 
  ln_modori number(3):= 0;   
  ln_trxori number(3):= 0;   
  ln_relori number(4):= 0;   
  ln_monori number(17,2):= 0;    
  ld_fecape date;                 
  begin
    -- CONSULTAREMOS A LA TABLA DE DLYA LA FECHA DEL ULTIMO ABONO DE REMUNERACIONES   
    -- obtenemos parametrizacion de meses exonerados   
    
    begin
       Select a.tp1nro3*(-1)
         into ln_meses
         from fst198 a 
        where a.tp1cod   = 1 
          and a.tp1cod1  = 10825 
          and a.tp1corr1 = 95 
          and a.tp1corr2 = 2 
          and a.tp1nro1  = P_N_MODULO
          and a.tp1nro2  = P_N_ITTOPE;
    exception
    when others then
      ln_meses := 0;
    end;
    
    if ln_meses > 0 then
      ld_fecini := add_months(P_D_FECPRO,ln_meses);
      --ld_fecini := to_date('01/'||to_char(ld_fecini,'mm')||'/'||to_char(ld_fecini,'rrrr'),'dd/mm/rrrr');
      ld_fecfin := P_D_FECPRO;
      begin
        Select nvl(max(a.jaqn216fac),null)
          into ld_fecabo
          from jaqn216 a
         where a.jaqn216emp = P_N_PGCOD  
           and a.jaqn216mod = P_N_MODULO  
           and a.jaqn216suc = P_N_SUCDES  
           and a.jaqn216mon = P_N_MONEDA  
           and a.jaqn216pap = P_N_PAPEL   
           and a.jaqn216cta = P_N_CTNRO  
           and a.jaqn216ope = P_N_ITOPER  
           and a.jaqn216sop = P_N_ITSUBO  
           and a.jaqn216top = P_N_ITTOPE;  
      exception
      when others then
        ld_fecabo := null;        
      end;
      if ld_fecabo between ld_fecini and ld_fecfin then
         return 'S';
      Else              
         -- OBTENEMOS FECHA DE APERTURA 
         begin
           Select a.scfval
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
         Exception
         when others then
           ld_fecape := null;  
         end;      
         if (ld_fecabo is null) and (ld_fecape between ld_fecini and ld_fecfin) then
           return 'S';            
         Else          
           return 'N';
         End If;
      End if;     
    Else
       return 'S';   
    End if; 
  exception
  when others then 
    return 'S';
  end fn_ah_abono_n_meses;   
  function fn_ah_consulta_stock(P_D_FECPRO IN DATE,
                                P_N_PGCOD  IN NUMBER,
                                P_N_MODULO IN NUMBER,
                                P_N_SUCDES IN NUMBER,
                                P_N_MONEDA IN NUMBER,
                                P_N_PAPEL  IN NUMBER,
                                P_N_CTNRO  IN NUMBER,
                                P_N_ITOPER IN NUMBER,
                                P_N_ITSUBO IN NUMBER,
                                P_N_ITTOPE IN NUMBER
                                ) return date is
  ld_fecmin date;
  ld_fecmax date; 
  ln_numcod number(9):= 0;  
  ld_fecape date;    
  ld_fecret date;
  begin
    begin
      Select to_date(trim(a.tp1desc),'dd/mm/rrrr') 
        into ld_fecret
        from fst198 a 
       where a.tp1cod   = 1 
         and a.tp1cod1  = 10825 
         and a.tp1corr1 = 95 
         and a.tp1corr2 = 5;
    exception
    when others then
      ld_fecret := null;    
    end;
   --CONSULTA EN LA TABLA DE DLYA SI CUENTA DEBE DE RESPETARSE COMISIONES ANTERIORES
   --SI AUN NO SE VENCE SU FECHA DE APLICACION RETORNAR '31/01/2021'
   --SI ES PLAZO FIJO SU FECHA DE APLICACIONES '31/01/2021'
   --SI YA VENCIO SU FECHA DE APLICACIÓN RETORNAR P_D_FECPRO
   --return P_D_FECPRO; 
   -- OBTENEMOS FECHA DE APERTURA SI ES MAYOR IGUAL AL 01/02/2021 DE FRENTE ENVIAMOS DICHA FECHA YA QUE PERTENECEN AL NUEVO TARIFARIO
   begin
     Select a.scfval
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
   Exception
   when others then
     ld_fecape := null;  
   end;
   
   if ld_fecape > ld_fecret then
     ld_fecret := ld_fecape;
   Else
     -- OBTENEMOS LA MAYOR SECUENCIA DE GENERACION PARA DICHA CUENTA
     begin   
        Select max(a.jaqn450cod)
          into ln_numcod
          from jaqn450 a,
               jaqn451 b,
               jaqn452 c
        where a.jaqn450cod = b.jaqn451cod
          and b.jaqn451cod = c.jaqn452cod
          and b.jaqn451pai = c.jaqn452pai
          and b.jaqn451tdo = c.jaqn452tdo
          and b.jaqn451ndo = c.jaqn452ndo 
          and c.jaqn452emp = P_N_PGCOD 
          and c.jaqn452mod = P_N_MODULO
          and c.jaqn452suc = P_N_SUCDES
          and c.jaqn452mda = P_N_MONEDA
          and c.jaqn452pap = P_N_PAPEL 
          and c.jaqn452cta = P_N_CTNRO 
          and c.jaqn452ope = P_N_ITOPER
          and c.jaqn452sbo = P_N_ITSUBO
          and c.jaqn452top = P_N_ITTOPE;            
     exception
     when others then
       return ld_fecret;
     end;  
     if ln_numcod > 0 then
         -- OBTENEMOS FECHA DE APLICACION DE LAS TABLAS DE DLYA  
         begin   
            Select min(b.jaqn451fap),
                   max(b.jaqn451fap) 
              into ld_fecmin,
                   ld_fecmax
              from jaqn450 a,
                   jaqn451 b,
                   jaqn452 c
            where a.jaqn450cod = b.jaqn451cod
              and b.jaqn451cod = c.jaqn452cod
              and b.jaqn451pai = c.jaqn452pai
              and b.jaqn451tdo = c.jaqn452tdo
              and b.jaqn451ndo = c.jaqn452ndo 
              and a.jaqn450cod = ln_numcod
              and c.jaqn452emp = P_N_PGCOD 
              and c.jaqn452mod = P_N_MODULO
              and c.jaqn452suc = P_N_SUCDES
              and c.jaqn452mda = P_N_MONEDA
              and c.jaqn452pap = P_N_PAPEL 
              and c.jaqn452cta = P_N_CTNRO 
              and c.jaqn452ope = P_N_ITOPER
              and c.jaqn452sbo = P_N_ITSUBO
              and c.jaqn452top = P_N_ITTOPE;            
         exception
         when others then
           return ld_fecret;
         end;
         if ld_fecmin is not null 
            and ld_fecmax is not null 
            and ld_fecmin <> to_date('01/01/0001','dd/mm/rrrr') 
            and ld_fecmax <> to_date('01/01/0001','dd/mm/rrrr')
         then            
            if ld_fecmax <= ld_fecret then
               ld_fecret := P_D_FECPRO;  
            Else
               ld_fecmax := last_day(ld_fecmax) + 1;
               if ld_fecmax <= P_D_FECPRO then
                  ld_fecret := P_D_FECPRO;                                                              
               end if;      
            End if;
         End if;  
     End If;  
   End if;
   return ld_fecret;
  exception
  when others then                                
    return ld_fecret;   
  end fn_ah_consulta_stock;  
  function fn_ah_exonera_stock(P_D_FECPRO IN DATE,
                               P_N_PGCOD  IN NUMBER,
                               P_N_MODULO IN NUMBER,
                               P_N_SUCDES IN NUMBER,
                               P_N_MONEDA IN NUMBER,
                               P_N_PAPEL  IN NUMBER,
                               P_N_CTNRO  IN NUMBER,
                               P_N_ITOPER IN NUMBER,
                               P_N_ITSUBO IN NUMBER,
                               P_N_ITTOPE IN NUMBER
                               ) return date is
  ld_fecmin date;
  ld_fecmax date; 
  ln_numcod number(9):= 0;  
  ld_fecape date;    
  ld_fecret date;
  begin
   --CONSULTA EN LA TABLA DE DLYA 
   begin
     Select a.scfval
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
   Exception
   when others then
     ld_fecape := null;  
   end;
   
   if ld_fecape > ld_fecret then
     ld_fecret := P_D_FECPRO;
   Else
     -- OBTENEMOS LA MAYOR SECUENCIA DE GENERACION PARA DICHA CUENTA
     begin   
        Select max(a.jaqn450cod)
          into ln_numcod
          from jaqn450 a,
               jaqn451 b,
               jaqn452 c
        where a.jaqn450cod = b.jaqn451cod
          and b.jaqn451cod = c.jaqn452cod
          and b.jaqn451pai = c.jaqn452pai
          and b.jaqn451tdo = c.jaqn452tdo
          and b.jaqn451ndo = c.jaqn452ndo 
          and c.jaqn452emp = P_N_PGCOD 
          and c.jaqn452mod = P_N_MODULO
          and c.jaqn452suc = P_N_SUCDES
          and c.jaqn452mda = P_N_MONEDA
          and c.jaqn452pap = P_N_PAPEL 
          and c.jaqn452cta = P_N_CTNRO 
          and c.jaqn452ope = P_N_ITOPER
          and c.jaqn452sbo = P_N_ITSUBO
          and c.jaqn452top = P_N_ITTOPE;            
     exception
     when others then
       ld_fecret := null;
     end;  
     if ln_numcod > 0 then
         -- OBTENEMOS FECHA DE APLICACION DE LAS TABLAS DE DLYA  
         begin   
            Select min(b.jaqn451fap),
                   max(b.jaqn451fap) 
              into ld_fecmin,
                   ld_fecmax
              from jaqn450 a,
                   jaqn451 b,
                   jaqn452 c
            where a.jaqn450cod = b.jaqn451cod
              and b.jaqn451cod = c.jaqn452cod
              and b.jaqn451pai = c.jaqn452pai
              and b.jaqn451tdo = c.jaqn452tdo
              and b.jaqn451ndo = c.jaqn452ndo 
              and a.jaqn450cod = ln_numcod
              and c.jaqn452emp = P_N_PGCOD 
              and c.jaqn452mod = P_N_MODULO
              and c.jaqn452suc = P_N_SUCDES
              and c.jaqn452mda = P_N_MONEDA
              and c.jaqn452pap = P_N_PAPEL 
              and c.jaqn452cta = P_N_CTNRO 
              and c.jaqn452ope = P_N_ITOPER
              and c.jaqn452sbo = P_N_ITSUBO
              and c.jaqn452top = P_N_ITTOPE;    
              ld_fecret := ld_fecmax;        
         exception
         when others then
           ld_fecret := null;
         end; 
     End If;  
   End if;
   return ld_fecret;
  exception
  when others then                                
    return ld_fecret;   
  end fn_ah_exonera_stock;   
  Procedure sp_valida_edad_junior(P_N_EDAMIN IN NUMBER,
                                  P_N_EDAMAX IN NUMBER,
                                  P_D_FECNAC IN DATE,
                                  P_D_FECPRO IN DATE,
                                  p_c_valida out varchar2
                                 ) is  
  begin
    begin
        select case
             when months_between(P_D_FECPRO,P_D_FECNAC) >= (P_N_EDAMIN*12) and months_between(P_D_FECPRO,P_D_FECNAC) < (P_N_EDAMAX*12) then
                  'S'
             else
                  'N'
             end meses
        into p_c_valida 
        from dual;        
    exception
    when others then    
      p_c_valida := 'N';
    end;     
  Exception
  when others then
    p_c_valida := 'N';  
  end sp_valida_edad_junior;    
  Procedure sp_ah_exonera_TDV(P_D_FECPRO IN DATE,
                              P_N_CTNRO  IN NUMBER,
                              p_c_exoner out varchar2 
                              ) is 
  ld_fecmin date;
  ld_fecmax date; 
  ln_numcod number(9):= 0;  
  ld_fecape date;    
  ld_fecret date;
  begin
    begin
      Select to_date(trim(a.tp1desc),'dd/mm/rrrr') 
        into ld_fecret
        from fst198 a 
       where a.tp1cod   = 1 
         and a.tp1cod1  = 10825 
         and a.tp1corr1 = 95 
         and a.tp1corr2 = 5;
    exception
    when others then
      ld_fecret := null;    
    end;    
     -- OBTENEMOS LA MAYOR SECUENCIA DE GENERACION PARA DICHA CUENTA
     begin   
        Select max(a.jaqn450cod)
          into ln_numcod
          from jaqn450 a,
               jaqn451 b,
               jaqn452 c
        where a.jaqn450cod = b.jaqn451cod
          and b.jaqn451cod = c.jaqn452cod
          and b.jaqn451pai = c.jaqn452pai
          and b.jaqn451tdo = c.jaqn452tdo
          and b.jaqn451ndo = c.jaqn452ndo 
          and c.jaqn452emp = 1 
          and c.jaqn452mod in (21,22)
          and c.jaqn452pap = 0 
          and c.jaqn452cta = P_N_CTNRO; 
     exception
     when others then
       p_c_exoner := 'N';
       return;
     end;  
     if ln_numcod > 0 then
         -- OBTENEMOS FECHA DE APLICACION DE LAS TABLAS DE DLYA  
         begin   
            Select min(b.jaqn451fap),
                   max(b.jaqn451fap) 
              into ld_fecmin,
                   ld_fecmax
              from jaqn450 a,
                   jaqn451 b,
                   jaqn452 c
            where a.jaqn450cod = b.jaqn451cod
              and b.jaqn451cod = c.jaqn452cod
              and b.jaqn451pai = c.jaqn452pai
              and b.jaqn451tdo = c.jaqn452tdo
              and b.jaqn451ndo = c.jaqn452ndo 
              and a.jaqn450cod = ln_numcod
              and c.jaqn452emp = 1 
              and c.jaqn452mod in(21,22)           
              and c.jaqn452pap = 0 
              and c.jaqn452cta = P_N_CTNRO; 
         exception
         when others then
            p_c_exoner := 'N';
            return;
         end;
         if ld_fecmin is not null 
            and ld_fecmax is not null 
            and ld_fecmin <> to_date('01/01/0001','dd/mm/rrrr') 
            and ld_fecmax <> to_date('01/01/0001','dd/mm/rrrr')
         then            
            if ld_fecmax <= ld_fecret then
               ld_fecret := P_D_FECPRO; 
               p_c_exoner := 'N'; 
            Else
               ld_fecmax := last_day(ld_fecmax) + 1;
               if ld_fecmax <= P_D_FECPRO then
                  ld_fecret := P_D_FECPRO;  
                  p_c_exoner := 'N';                                                            
               Else
                  p_c_exoner := 'S';
               end if;      
            End if;
         Else
           p_c_exoner := 'S';
         End if;  
     Else
        p_c_exoner := 'N';
     End If;  
  exception
  when others then                                
     p_c_exoner := 'N';   
  end sp_ah_exonera_TDV;                              
  Function fn_ah_exonera_trx(P_N_PGCOD  IN NUMBER,
                             P_N_MODULO IN NUMBER,
                             P_N_SUCDES IN NUMBER,  
                             P_N_MONEDA IN NUMBER,
                             P_N_PAPEL  IN NUMBER,
                             P_N_CTNRO  IN NUMBER,
                             P_N_ITOPER IN NUMBER,
                             P_N_ITSUBO IN NUMBER,
                             P_N_ITTOPE IN NUMBER,
                             P_N_ITMOD  IN NUMBER, 
                             P_N_ITTRAN IN NUMBER,
                             P_N_CODCOM IN NUMBER,
                             P_N_CODCAN IN NUMBER
                             ) return varchar2 is
  ld_fecape date;  
  ld_fecapl date;   
  lc_indcob varchar2(1) :='S';
  begin
     begin
       Select a.scfval
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
     Exception
     when others then
       ld_fecape := null;  
     end;   
     --obtenemos fecha de parametrizacion a partir de cuando se cobra
     begin
      Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
        into ld_fecapl
        from fst198 a
       where a.tp1cod   = 1
         and a.tp1cod1  = 10825
         and a.tp1corr1 = 95
         and a.tp1corr2 = 7;
      Exception
      When others then
        ld_fecapl := null;
      end;     
      if ld_fecapl is not null and ld_fecapl <= ld_fecape and ld_fecape is not null then
        --VERIFICAMOS SI LA TRANSACCION ESTA EXONERADA
           begin
            Select 'N'
              into lc_indcob
              from fst198 a
             where a.tp1cod   = 1
               and a.tp1cod1  = 10825
               and a.tp1corr1 = 95
               and a.tp1corr2 = 8
               and a.tp1nro1  = P_N_ITMOD 
               and a.tp1nro2  = P_N_ITTRAN
               and a.tp1nro3  = P_N_CODCOM
               and a.tp1imp1  = P_N_CODCAN;
               return lc_indcob;
            Exception
            When others then
              lc_indcob := 'S';
            end;          
      Else
        return 'S';    
      End if;                        
  Exception
  When Others then
    return 'S';                             
  End fn_ah_exonera_trx;                                                               
                                                                                                                                                                                                                                                                
end PQ_AH_NEW_COMISION;
/

