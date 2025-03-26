create or replace package PQ_OP_ASIENTOS_MPLUS is
 
    -- *****************************************************************
    -- Nombre                     : ASIENTOS - MOVIMIENTOS FSD015 PARA CARGA TABLAS ANTIFRAUDES -  MPLUS 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.10.24
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER MOVIMIENTOS PARA SISTEMA ANTIFRAUDES -MPUS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2025.02.24
    -- Autor de la Modificación   : RCUADROS
    -- Descripción de Modificación: Se adicionaron nuevos campos a la tabla JAQL977
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación:     
    -- *****************************************************************
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_ah_trx_ori_off(pn_hcmod    in number,
                              pn_htran    in number,
                              pn_tiptr    in number,                                                          
                              pn_hcmod_ori  out number,
                              pn_htran_ori  out number
                             );
  function fn_ah_tot_movimientos_off(pc_numtar  in varchar2, 
                                     pd_fecpro  in date,
                                     pn_moncta  in number
                                    ) return number;
  procedure sp_ah_datos_trx_ori_off(pn_numtar in varchar2,
                                    pn_codtra in number,
                                    pd_fecpro in date,                                                                      
                                    pn_traori out number
                                   );
  procedure sp_ah_datos_ter_off(pn_codtra in number,
                                pc_idterm out varchar2,  
                                pc_locali out varchar2,  
                                pc_valant out varchar2,  
                                pc_valact out varchar2,  
                                pc_numero out varchar2       
                               ); 
  procedure sp_ah_datos_trx_off(pc_numtar in varchar2, 
                                pn_codtra in number,  
                                pd_fecpro in date, 
                                pn_indtrx in number,
                                pn_monto  out number,
                                pn_ctacli out number,
                                pn_modulo out number,
                                pn_moncta out number,
                                pn_subope out number,
                                pn_operac out number,
                                pn_tipope out number,
                                pn_sucurs out number,                                  
                                pn_monope out number
                               );
  procedure sp_ah_trx_offline(pn_codtra   in number,
                              pd_fecpro   in date,
                              pc_numtar   in varchar2,
                              pn_pgcod    out number, 
                              pn_hcmod    out number,
                              pn_hsucor   out number,
                              pn_htran    out number,
                              pn_hnrel    out number 
                              );
  procedure sp_ah_datos_trx_ori(pn_pgcod    in number, 
                                pn_hcmod    in number,
                                pn_hsucor   in number,
                                pn_htran    in number,
                                pn_hnrel    in number, 
                                pd_fecpro   in date,
                                pc_numtar   in varchar2,
                                pc_jaql97787516 out varchar2,                               
                                pc_jaql97787531 out varchar2,                               
                                pc_jaql97787528 out varchar2,                               
                                pc_jaql97787518 out varchar2,
                                pn_traori       out number                                                               
                               );
  procedure sp_ah_trx_ori(pn_pgcod    in number, 
                          pn_hcmod    in number,
                          pn_hsucor   in number,
                          pn_htran    in number,
                          pn_hnrel    in number, 
                          pd_fecpro   in date, 
                          pn_hcmod_o  out number,
                          pn_hnrel_o  out number,                           
                          pd_fecpro_o out date                         
                         );
  function fn_ah_desc_sucur(pn_pgcod  in number, 
                            pn_hcsuc  in number
                            ) return varchar2;
                            
  Procedure sp_ah_estado_ope(pn_pgcod  in number, 
                            pn_hcmod  in number,
                            pn_hcmda  in number,
                            pn_hccta  in number,
                            pn_hsbop  in number,
                            pn_operac in number,
                            pd_fecpro in date,
                            pn_estado out number,
                            pn_saldo  out number,
                            pn_tipop  out number                                                      
                            );
  Procedure sp_ah_datos_tarjhabiente(PN_NUMTAR in varchar2,
                                     pn_suctar out number,
                                     pc_loccli out varchar2,
                                     pc_prinom out varchar2,
                                     pc_segnom out varchar2,
                                     pc_priape out varchar2,
                                     pc_segape out varchar2,
                                     pn_telfij out number,         
                                     pn_telcel out number,
                                     pn_pais   out number,
                                     pn_tipo   out number,
                                     pc_numero out varchar2
                                    );
  Procedure sp_ah_valida_trx(pn_pgcod  in number, 
                             pn_hcmod  in number,
                             pn_htran  in number,
                             pn_indvig out number,
                             pn_tipmon out number
                             );
  Procedure sp_ah_datos_contacto_com(pn_pgcod  in number, 
                                     pn_hcmod  in number,
                                     pn_htran  in number,
                                     pn_idterm in varchar2,
                                     pc_cocom  in varchar2,
                                     pc_coterm in varchar2,
                                     pd_fecpro in varchar2,
                                     pc_nomcon out varchar2,
                                     pc_telcon out varchar2
                                    );
  Procedure sp_ah_datos_comercio(pn_pgcod  in number, 
                                 pn_hcmod  in number,
                                 pn_htran  in number,
                                 pc_idterm in varchar2,
                                 pc_nomcom out varchar2,
                                 pc_dircom out varchar2,
                                 pc_telcom out varchar2,
                                 pc_locali out varchar2,
                                 pc_ruccom out varchar2                                 
                                );

  Procedure sp_ah_id_terminal(pn_pgcod  in number, 
                              pn_hcmod  in number,
                              pn_hsucor in number,
                              pn_htran  in number,
                              pn_hnrel  in number,         
                              pd_fecpro in date,
                              pc_uing   in varchar2,                              
                              pc_numtar in varchar2,
                              pc_idterm out varchar2,
                              pc_locali out varchar2,
                              pc_cocom  out varchar2                              
                             );
                            
  procedure sp_ah_datos_trama(pn_pgcod  in number, --pgcod
                              pn_hcmod  in number, --hcmod
                              pn_hsucor in number, --hsucor
                              pn_htran  in number, --htran
                              pn_hnrel  in number, --hnrel         
                              pd_fecpro in date, -- fecha transaccion
                              pn_tipo2  in number,
                              pn_codpet out number,
                              pc_coderr out varchar2,
                              pc_deserr out varchar2
                             );    
  procedure sp_ah_param_trx(pn_pgcod  in number, 
                            pn_hcmod  in number,
                            pn_htran  in number,
                            pn_tipo1  out number,
                            pn_tipo2  out number
                           );
  function fn_ah_fecven_tarj(pc_numtar  in varchar2
                            ) return date;
                            
  Procedure sp_ah_moneda_trx(pn_pgcod  in number, 
                            pn_hcmod  in number,
                            pn_hsucor in number,
                            pn_htran  in number,
                            pn_hnrel  in number,                            
                            pn_moncta in number,
                            pn_monope out number,
                            pc_indtic out varchar2                            
                            );
  procedure sp_ah_datos_trx(pn_pgcod  in number, --pgcod
                            pn_hcmod  in number, --hcmod
                            pn_hsucor in number, --hsucor
                            pn_htran  in number, --htran
                            pn_hnrel  in number, --hnrel         
                            pn_monto  out number,
                            pn_ctacli out number,
                            pn_modulo out number,
                            pn_moncta out number,
                            pn_subope out number,
                            pn_operac out number,
                            pn_tipope out number,
                            pn_sucurs out number,
                            pn_numchq out number,
                            pn_codord out number                                                        
                           );
                           
  procedure sp_ah_titcuenta(pn_pgcod  in number, 
                            pn_ctacli in number,
                            pn_pais   out number,
                            pn_tipo   out number,
                            pc_numero out varchar2
                           );
                                                         
   function fn_ah_numtarjeta(pn_pgcod in number, 
                             pn_hcmod in number,
                             pn_hsucor in number,
                             pn_htran in number,
                             pn_hnrel in number,         
                             pd_fecpro in date) return varchar2 ; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ah_doctarjeta(pn_pais   number, 
                            pn_tipo   number,
                            pc_numero varchar2,
                            pd_fecpro date
                           ) return varchar2;  
  procedure sp_op_carga_JAQL979( pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2                                 
                              );                           
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   procedure sp_op_carga_JAQL977(pn_cor in number,
                                 pn_pgcod in number, 
                                 pn_hcmod in number,
                                 pn_hsucor in number,
                                 pn_htran in number,
                                 pn_hnrel in number,         
                                 pd_fecpro in date,
                                 pc_uing in varchar2,
                                 pc_hora in varchar2,
                                 pc_cont in varchar2,
                                 pn_corr in number,
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                                 );
 procedure sp_op_carga_JAQL978(pn_cor in number, --numero correlativo
                               pd_fecpro in date,
                               pc_hora   in varchar2,
                               pc_codrec in varchar2,
                               pn_numrec in number,
                               pd_fecreg in date, 
                               pd_fecsol in date,
                               pc_usureg in varchar2,
                               pc_ususol in varchar2,
                               pc_numero in varchar2,
                               pc_detrec in varchar2,
                               pc_canrec in number,
                               pc_solrec in varchar2                               
                              );                             
                                 
  procedure sp_op_carga_JAQL976( pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2                                 
                              );
   procedure sp_op_registra_JAQL977A(pn_pgcod in number, 
                                     pn_hcmod in number,
                                     pn_hsucor in number,
                                     pn_htran in number,
                                     pn_hnrel in number,         
                                     pd_fecpro in date,
                                     pc_uing in varchar2,
                                     pc_hora in varchar2,
                                     pc_cont in varchar2,
                                     pn_corr in number,
                                     pn_pais in number,
                                     pn_tipo in number,
                                     pc_numero in varchar2,
                                     pc_valant in varchar2,
                                     pc_valact in varchar2                                 
                                    );
   procedure sp_op_carga_JAQL493(pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pc_cont in varchar2,  --estado contable 
                                 pn_corr in number, --itcorr - (99-extornado)
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              );

   procedure sp_op_carga_JAQL494(pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pc_cont in varchar2,  --estado contable 
                                 pn_corr in number, --itcorr - (99-extornado)
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              );

   procedure sp_op_carga_JAQL495(pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pc_cont in varchar2,  --estado contable 
                                 pn_corr in number, --itcorr - (99-extornado)
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              );
                                    
   procedure sp_op_carga_JAQL496(pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pc_cont in varchar2,  --estado contable 
                                 pn_corr in number, --itcorr - (99-extornado)
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              );

   procedure sp_op_carga_JAQL497(pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pc_cont in varchar2,  --estado contable 
                                 pn_corr in number, --itcorr - (99-extornado)
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              );
  procedure sp_ah_datos_jaql493(pn_ctacli     in number,
                                PN_PETDOC     OUT NUMBER,
                                PC_PENDOC     OUT VARCHAR2,
                                PC_PETIPO     OUT VARCHAR2,
                                PC_CTNOM      OUT VARCHAR2,
                                PC_SNGC13DIR  OUT VARCHAR2,
                                PC_DOTELFP    OUT VARCHAR2,
                                PC_DOTELFP1   OUT VARCHAR2,
                                PC_PEXTXT     OUT VARCHAR2,
                                PN_JAQL60CALI OUT VARCHAR2,
                                PN_PFFNAC     OUT NUMBER,
                                PC_PFLNAC     OUT VARCHAR2,
                                PC_PFCANT     OUT VARCHAR2,
                                PC_PFECIV     OUT VARCHAR2,
                                PC_SNGC60ACTE OUT VARCHAR2   
                               );                       
  procedure sp_tasa(vpgcod  number,
                    vScsuc  number,
                    vSccta  number,
                    vScmda  number,
                    vScpap  number,
                    vScoper number,
                    vScsbop number,
                    vSctope number,
                    vScmod  number,
                    tasa    out number);                               
  procedure sp_datos_producto(vpgcod  in number,
                              vScsuc  in number,
                              vSccta  in number,
                              vScmda  in number,
                              vScpap  in number,
                              vScoper in number,
                              vScsbop in number,
                              vSctope in out number,
                              vScmod  in number,
                              pn_plazo  out number,
                              pd_fecven out date,
                              pc_ejecut out varchar2,
                              pn_estado out number,
                              pn_saldo  out number,
                              pd_fecape out date,
                              pd_fecori out date,
                              pd_feculm out date
                             );  
                             
  Procedure sp_datos_transferencia(pn_pgcod  in number, --pgcod
                                   pn_hcmod  in number, --hcmod
                                   pn_hsucor in number, --hsucor
                                   pn_htran  in number, --htran
                                   pn_hnrel  in number,  --hnrel 
                                   pd_fecpro in date,    
                                   pc_indemd out varchar2,
                                   pc_codcld out varchar2,    
                                   pc_sucapd out varchar2,    
                                   pc_nomtid out varchar2,
                                   pc_idclid out varchar2,
                                   pc_ctades out varchar2,
                                   pc_bcodes out varchar2,
                                   pc_sucdes out varchar2                                            
                                  );                             
  Procedure sp_cl_cliente(PN_CTACLI IN NUMBER,
                          pn_pais   out number,
                          pn_tipo   out number,
                          pc_numero out char, 
                          pc_nombre out char        
                         );

  function fn_cl_estrabajador(pn_pais   in number,
                              pn_tipo   in number,
                              pc_numero in char
                              ) return char;                         
                              
  Procedure sp_cl_datos_cliente(PN_PAIS   IN NUMBER,
                                PN_TIPO   IN NUMBER,
                                PC_NUMERO IN CHAR,
                                pc_tipper out char,
                                pc_direcc out char,
                                pc_mail   out char,
                                pc_telef1 out char,
                                pc_telef2 out char,
                                pc_segmen out char,
                                pn_fecalt out number
                              );                              
  function fn_cl_es_trabajador(P_N_CTACLI IN NUMBER) return varchar2;        
  FUNCTION fn_ah_ip_usuario(P_C_IPHEX IN VARCHAR2) RETURN VARCHAR2;                      
  FUNCTION hex2dec (hexnum IN CHAR) RETURN NUMBER;
end PQ_OP_ASIENTOS_MPLUS;
/
create or replace package body PQ_OP_ASIENTOS_MPLUS is
    -- *****************************************************************
    -- Nombre                     : PQ_OP_ASIENTOS_MPLUS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.18
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS PARA REPORTE VARIACION DE SALDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2025.02.24
    -- Autor de la Modificación   : RCUADROS
    -- Descripción de Modificación: Se adicionaron nuevos campos a la tabla JAQL977
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  procedure sp_ah_trx_ori_off(pn_hcmod    in number,
                              pn_htran    in number,
                              pn_tiptr    in number,                                                          
                              pn_hcmod_ori  out number,
                              pn_htran_ori  out number
                             ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  begin

    begin
       select b.tp1imp2,b.tp1imp3
         into pn_hcmod_ori, pn_htran_ori
         from fst198 b
        where b.TP1COD   = 1
          and b.TP1COD1  = 10864
          and b.TP1CORR1 = 4
          and b.tp1nro1  = pn_hcmod
          and b.tp1nro2  = pn_htran
          and b.tp1imp1  = 2;
    Exception 
    when no_data_found then
       null;
    end;  
 Exception
 When Others then
   null;  
 end sp_ah_trx_ori_off;   
  function fn_ah_tot_movimientos_off(pc_numtar  in varchar2, 
                                     pd_fecpro  in date,
                                     pn_moncta  in number
                                    ) return number is
  ln_saldoori number(17,2);                                    
  ln_saldorev number(17,2);                                    
  begin
    select sum(
                 case
                 when (Z0E4GCMda <> pn_moncta) and pn_moncta = 0 then
                      round(Z0E4GCImD*fn_tipo_cambio(pd_fecpro,0,0,0),2)
                 when (Z0E4GCMda <> pn_moncta) and pn_moncta = 101 then
                      round(Z0E4GCImD/fn_tipo_cambio(pd_fecpro,0,0,0),2)
                 Else
                      Z0E4GCImD
                 end
               )       
       into ln_saldoori
      from z0e4gc
     where z0e4gctar = rpad(pc_numtar,19,' ')
       and z0e4gcesm = 1
       and z0e4gcfim = pd_fecpro;
       
    select sum(
                 case
                 when (Z0E4GCMda <> pn_moncta) and pn_moncta = 0 then
                      round(Z0E4GCImD*fn_tipo_cambio(pd_fecpro,0,0,0),2)
                 when (Z0E4GCMda <> pn_moncta) and pn_moncta = 101 then
                      round(Z0E4GCImD/fn_tipo_cambio(pd_fecpro,0,0,0),2)
                 Else
                      Z0E4GCImD
                 end
               )       
       into ln_saldorev
      from z0e4gc
     where z0e4gctar = rpad(pc_numtar,19,' ')
       and z0e4gcesm = 3
       and z0e4gcfim = pd_fecpro;       
       
     return nvl(ln_saldoori,0) - nvl(ln_saldorev,0);  
  exception
  when others then
    return 0;
  end;                            
                                
  procedure sp_ah_datos_trx_ori_off(pn_numtar in varchar2,
                                    pn_codtra in number,
                                    pd_fecpro in date,                                                                      
                                    pn_traori out number
                                   ) is
  ln_numtra number;                                   
  begin
      begin                             
        select jaql540nutra 
          into ln_numtra
          from jaql540
         where jaql540feini = pd_fecpro
           and jaql540comsj = '400'
           and jaql540cotra = pn_codtra
           and jaql540nutar = pn_numtar;
      exception 
      when others then   
        return;
      end;
      begin
        select jaql540cotra 
          into pn_traori
          from jaql540
         where jaql540feini = pd_fecpro
           and jaql540comsj = '200'
           and jaql540nutra = ln_numtra
           and jaql540nutar = pn_numtar;  
      exception 
      when others then   
        return;
      end;         
  exception 
  when others then
    null; 
  end sp_ah_datos_trx_ori_off;  
                                       
  procedure sp_ah_datos_ter_off(pn_codtra in number,
                                pc_idterm out varchar2,  
                                pc_locali out varchar2,  
                                pc_valant out varchar2,  
                                pc_valact out varchar2,  
                                pc_numero out varchar2       
                               ) is
  cursor c_terminal is
    select *
      from jaql539
     where jaql539cotra = pn_codtra
       and jaql539nucam in (18, 41, 42,43);                                    
  begin
       for j in c_terminal Loop
          If j.jaql539nucam = 18 Then
             pc_numero := trim(j.jaql539valtr); 
          ElsIf j.jaql539nucam = 41 Then
             pc_valant := trim(j.jaql539valtr);  
             pc_idterm := trim(j.jaql539valtr);             
          ElsIf j.jaql539nucam = 42 Then
             pc_valact := trim(j.jaql539valtr);  
          ElsIf j.jaql539nucam = 43 Then
             pc_locali := trim(j.jaql539valtr);                          
          End If;
       End Loop; 
  exception
  when others then
    null;            
  end sp_ah_datos_ter_off;                                   
  procedure sp_ah_datos_trx_off(pc_numtar in varchar2, 
                                pn_codtra in number,   
                                pd_fecpro in date,
                                pn_indtrx in number,
                                pn_monto  out number,
                                pn_ctacli out number,
                                pn_modulo out number,
                                pn_moncta out number,
                                pn_subope out number,
                                pn_operac out number,
                                pn_tipope out number,
                                pn_sucurs out number,                                                                                               
                                pn_monope out number
                               ) is 
  ln_jaql539valtr number(15);
  begin
    If pn_indtrx = 1 then
        begin
          select to_number(jaql539valtr)
            into ln_jaql539valtr
            from jaql539
           where jaql539cotra = pn_codtra
             and jaql539nucam = 38;
        exception
        when others then
             return;     
        end;
        
        begin
         select Z0E4GCDMD,
                Z0E4GCDMO,
                Z0E4GCDCT,
                Z0E4GCDSC,
                Z0E4GCDOP,
                Z0E4GCImD, --importe
                Z0E4GCMda,  --moneda del movimiento     
                Z0E4GCDTo,
                Z0E4GCDSU
           into pn_modulo,
                pn_moncta,
                pn_ctacli,
                pn_subope,
                pn_operac,
                pn_monto,
                pn_monope,
                pn_tipope,
                pn_sucurs
           from  z0e4gc  c
          where c.z0e4gctar = rpad(pc_numtar,19,' ')
            and c.z0e4gcfim = pd_fecpro
            and c.z0e4gcnse = ln_jaql539valtr;
        exception
        when others then
         return;    
        end;         
    Else
    begin
          select to_number(jaql539valtr)
            into ln_jaql539valtr
            from jaql539
           where jaql539cotra = pn_codtra
             and jaql539nucam = 37;
        exception
        when others then
             return;     
        end;   
        begin
             select Z0E4GEDMD,
                    Z0E4GEDMO,
                    Z0E4GEDCT,
                    Z0E4GEDSC,
                    Z0E4GEDOP,
                    Z0E4GEImD, --importe
                    Z0E4GEMda,  --moneda del movimiento     
                    Z0E4GEDTO,
                    Z0E4GEDSU
               into pn_modulo,
                    pn_moncta,
                    pn_ctacli,
                    pn_subope,
                    pn_operac,
                    pn_monto,
                    pn_monope,
                    pn_tipope,
                    pn_sucurs                    
               from  z0e4ge  c
              where c.z0e4getar = rpad(pc_numtar,19,' ')
                and c.z0e4gefim = pd_fecpro
                and c.z0e4gesec = ln_jaql539valtr;
            exception
            when others then
             return;    
            end;          
    End If;
   
  end sp_ah_datos_trx_off;    
                           
  procedure sp_ah_trx_offline(pn_codtra   in number,
                              pd_fecpro   in date,
                              pc_numtar   in varchar2,
                              pn_pgcod    out number, 
                              pn_hcmod    out number,
                              pn_hsucor   out number,
                              pn_htran    out number,
                              pn_hnrel    out number 
                              ) is    
  begin
    select b.tp1nro1, b.tp1nro2 into
           pn_hcmod,pn_htran
      from jaql539 a, 
           fst198  b, 
           z0e4gc  c
     where a.jaql539valtr = c.z0e4gcnse
       and c.z0e4gctop    = b.tp1nro3
       and c.z0e4gctar    = rpad(pc_numtar,19,' ')
       and c.z0e4gcfim    = pd_fecpro
       and a.jaql539cotra = pn_codtra
       and a.jaql539nucam = 38
       and b.TP1IMP1      = 1  -- original
       and b.TP1COD       = 1
       and b.TP1COD1      = 10864
       and b.TP1CORR1     = 4;  
       
       pn_pgcod  := 1;
       pn_hsucor := 903;
       pn_hnrel  := 0;
  Exception
  When no_data_found then
       begin
          select b.tp1nro1, b.tp1nro2 into
                 pn_hcmod,pn_htran
            from jaql539 a, 
                 fst198  b, 
                 z0e4ge  c
           where a.jaql539valtr = c.z0e4gesec
             and c.z0e4getop    = b.tp1nro3
             and c.z0e4getar    = rpad(pc_numtar,19,' ')
             and c.z0e4gefim    = pd_fecpro
             and a.jaql539cotra = pn_codtra
             and a.jaql539nucam = 37
             and b.TP1IMP1      = 2  -- reverso
             and b.TP1COD       = 1
             and b.TP1COD1      = 10864
             and b.TP1CORR1     = 4;  
             
             pn_pgcod  := 1;
             pn_hsucor := 903;
             pn_hnrel  := 0;   
        Exception     
        When others then
          null;
        end;            
  end;                              
  
  procedure sp_ah_datos_trx_ori(pn_pgcod    in number, 
                                pn_hcmod    in number,
                                pn_hsucor   in number,
                                pn_htran    in number,
                                pn_hnrel    in number, 
                                pd_fecpro   in date,
                                pc_numtar   in varchar2,
                                pc_jaql97787516 out varchar2,                               
                                pc_jaql97787531 out varchar2,                               
                                pc_jaql97787528 out varchar2,                               
                                pc_jaql97787518 out varchar2,
                                pn_traori       out number                               
                               ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  ln_cortrx number;
  ln_trxori number;
  ln_relori number;
  lc_jaql97787516 jaql977.jaql97787516%type;
  lc_jaql97787531 jaql977.jaql97787531%type;
  lc_jaql97787528 jaql977.jaql97787528%type;
  lc_jaql97787518 jaql977.jaql97787518%type;
    
  begin

    begin
      select b.z0e4getrn,b.z0e4gerel  
        into ln_trxori,ln_relori
        from z0e4ge a,
             z0e4ge b
       where a.z0e4geemp = b.z0e4geemp 
         and a.z0e4gefec = b.z0e4gefec
         and a.z0e4gehor = b.z0e4gehor
         and a.z0e4gefne = b.z0e4gefne 
         and a.z0e4getar = b.z0e4getar 
         and a.z0e4gesuc = pn_hsucor 
         and a.z0e4gemod = pn_hcmod 
         and a.z0e4getrn = pn_htran 
         and a.z0e4gerel = pn_hnrel
         and a.z0e4gefim = pd_fecpro
         and b.z0e4getar = rpad(pc_numtar,19,' ')
         and b.z0e4geemp = pn_pgcod 
         and b.z0e4gemen = 1 ; 
    Exception 
    when no_data_found then
       ln_trxori := null;
       ln_relori := null;
       return;
    end;  
    
    begin
      select c.jaql977acor
        into ln_cortrx
        from jaql977a c
       where c.jaql977acod  = pn_pgcod
         and c.jaql977asuc  = pn_hsucor 
         and c.jaql977amod  = pn_hcmod 
         and c.jaql977atran = ln_trxori 
         and c.jaql977anrel = ln_relori
         and c.jaql977afcon = pd_fecpro;
    Exception 
    when no_data_found then
       ln_cortrx := null;
       return;
    end;   
    
    begin
      select jaql97787516,jaql97787531,jaql97787528,jaql97787518
        into lc_jaql97787516,lc_jaql97787531,lc_jaql97787528,lc_jaql97787518
        from jaql977 c
       where c.jaql977cor = ln_cortrx;        
    Exception 
    when no_data_found then
       lc_jaql97787516 := null;
       lc_jaql97787531 := null;
       lc_jaql97787528 := null;
       lc_jaql97787518 := null;
       return;
    end;
    pc_jaql97787516 := lc_jaql97787516;
    pc_jaql97787531 := lc_jaql97787531;
    pc_jaql97787528 := lc_jaql97787528;
    pc_jaql97787518 := lc_jaql97787518;   
    pn_traori       := ln_trxori;              
  Exception
  When Others then
    null;  
  end sp_ah_datos_trx_ori;          
  procedure sp_ah_trx_ori(pn_pgcod    in number, 
                          pn_hcmod    in number,
                          pn_hsucor   in number,
                          pn_htran    in number,
                          pn_hnrel    in number, 
                          pd_fecpro   in date, 
                          pn_hcmod_o  out number,
                          pn_hnrel_o  out number,                           
                          pd_fecpro_o out date                         
                         ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  cursor c_datos is
   select a.*
     from FSX015 a
    Where a.Pgcod  = pn_pgcod
      and a.Hcmod  = pn_hcmod
      and a.Hsucor = pn_hsucor
      and a.Htran  = pn_htran
      and a.Hnrel  = pn_hnrel
      and a.Hfcon  = pd_fecpro
      and a.Txcod  = 0; 
  begin

    begin
      For i in c_datos loop
        If i.Txreng   = 1 Then
            pn_hnrel_o  := to_number(trim(i.Txtext));
        ElsIf i.Txreng   = 2 Then
            pd_fecpro_o := to_date(trim(i.Txtext),'dd/mm/yy');
        End If;
      End loop;         
      pn_hcmod_o := pn_hcmod - 500;      
    Exception 
    when no_data_found then
       null;
    end;  
 Exception
 When Others then
   null;  
 end sp_ah_trx_ori;      
  function fn_ah_desc_sucur(pn_pgcod  in number, 
                            pn_hcsuc  in number
                            ) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  lc_dessuc  fst001.scnom%type;
  begin
    select a.scnom
      into lc_dessuc
      from fst001 a
     where a.pgcod  = pn_pgcod
       and a.sucurs = pn_hcsuc;
  return lc_dessuc;     
  Exception 
  when no_data_found then 
       return null;
  end fn_ah_desc_sucur;      
  Procedure sp_ah_estado_ope(pn_pgcod  in number, 
                            pn_hcmod  in number,
                            pn_hcmda  in number,
                            pn_hccta  in number,
                            pn_hsbop  in number,
                            pn_operac in number,
                            pd_fecpro in date,
                            pn_estado out number,
                            pn_saldo  out number,
                            pn_tipop  out number                                                      
                            )  is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  begin
     If pn_hcmod = 21 Then 
           begin
            select a.scstat, a.scsdo, a.sctope
              into pn_estado, pn_saldo, pn_tipop
              from fsd011 a
             where a.pgcod  = pn_pgcod
               and a.scmda  = pn_hcmda
               and a.scmod  = pn_hcmod
               and a.sccta  = pn_hccta
               and a.scsbop = pn_hsbop
               and a.scoper = pn_operac
               and a.scpap = 0;
           Exception
           When too_many_rows then
             begin
                select a.scstat, a.scsdo, a.sctope
                  into pn_estado, pn_saldo, pn_tipop
                  from fsd011 a
                 where a.pgcod  = pn_pgcod
                   and a.scmda  = pn_hcmda
                   and a.scmod  = pn_hcmod
                   and a.sccta  = pn_hccta
                   and a.scsbop = pn_hsbop
                   and a.scoper = pn_operac
                   and a.scpap = 0
                   and a.scstat <> 99
                   and a.scfulm >= pd_fecpro;    
              end; 
           End;            
    Else
           begin
            select a.scstat, a.sctope
              into pn_estado, pn_tipop
              from fsd011 a
             where a.pgcod  = pn_pgcod
               and a.scmda  = pn_hcmda
               and a.scmod  = pn_hcmod
               and a.sccta  = pn_hccta
               and a.scsbop = pn_hsbop
               and a.scoper = pn_operac
               and a.scpap = 0;
           Exception
           When too_many_rows then
             begin
                select a.scstat, a.sctope
                  into pn_estado, pn_tipop
                  from fsd011 a
                 where a.pgcod  = pn_pgcod
                   and a.scmda  = pn_hcmda
                   and a.scmod  = pn_hcmod
                   and a.sccta  = pn_hccta
                   and a.scsbop = pn_hsbop
                   and a.scoper = pn_operac
                   and a.scpap  = 0
                   and a.scstat <> 99
                   and a.scfulm >= pd_fecpro;    
              end;       
           End;  
           
           If pn_estado = 99 then
              pn_saldo := 0;
           Else
               begin
                select sum(a.scsdo)
                  into pn_saldo
                  from fsd011 a
                 where a.pgcod  = pn_pgcod
                   and a.scmda  = pn_hcmda
                   and a.scmod  in (22,426)
                   and a.sccta  = pn_hccta
                   and a.scsbop = pn_hsbop
                   and a.scoper = pn_operac
                   and a.scpap = 0;
               Exception
               When too_many_rows then
                 begin
                    select sum(a.scsdo)
                      into pn_saldo
                      from fsd011 a
                     where a.pgcod  = pn_pgcod
                       and a.scmda  = pn_hcmda
                       and a.scmod  in (22,426)
                       and a.sccta  = pn_hccta
                       and a.scsbop = pn_hsbop
                       and a.scoper = pn_operac
                       and a.scpap  = 0
                       and a.scstat <> 99
                       and a.scfulm >= pd_fecpro;    
                  end;       
               End;              
           End If;
    End If;          
  Exception   
  when no_data_found then 
       pn_estado := 99 ;       
       pn_saldo := 0;
  end sp_ah_estado_ope;          
  Procedure sp_ah_datos_tarjhabiente(PN_NUMTAR in varchar2,
                                     pn_suctar out number,
                                     pc_loccli out varchar2,
                                     pc_prinom out varchar2,
                                     pc_segnom out varchar2,
                                     pc_priape out varchar2,
                                     pc_segape out varchar2,
                                     pn_telfij out number,         
                                     pn_telcel out number,
                                     pn_pais   out number,
                                     pn_tipo   out number,
                                     pc_numero out varchar2
                                    )  is
  ln_pais number(3);
  ln_tipo number(2);
  ln_numero varchar2(12);
  begin
    begin
      select a.z0e478thp,a.z0e478tht,a.z0e478thd,a.z0e478suc 
        into ln_pais,ln_tipo,ln_numero,pn_suctar
        from Z0e478 a 
       where a.z0e478nro = rpad(PN_NUMTAR,19,' ');
    exception
    When Others then
     return;  
    end;
    pn_pais   := ln_pais;  
    pn_tipo   := ln_tipo;
    pc_numero := ln_numero;
    begin
      select b.locnom
        into pc_loccli
        from sngc13 a,
             fst070 b
       where a.sngc13pais = b.pais
         and a.sngc13prov = b.loccod
         and a.docod=1
         and a.sngc13pais = ln_pais 
         and a.sngc13tdoc = ln_tipo
         and a.sngc13ndoc = ln_numero;
    exception
    When Others then
         pc_loccli := null;  
    end;
    
    begin
      select a.pfnom1,a.pfnom2,a.pfape1,a.pfape2 
        into pc_prinom,pc_segnom,pc_priape,pc_segape
        from fsd002 a 
       where a.pfpais = ln_pais 
         and a.pftdoc = ln_tipo
         and a.pfndoc = ln_numero;
    exception
    When Others then
      pc_prinom := null;
      pc_segnom := null;
      pc_priape := null;
      pc_segape := null;   
    end;
       
    begin
      select to_number(trim(a.dotelfp))
        into pn_telfij
        from FSR005 A, SNGC17 B
       where a.pepais = b.sngc17pais
         and a.petdoc = b.sngc17tdoc
         and a.pendoc = b.sngc17ndoc
         and a.docod = b.sngc17dcod
         and a.doordp = b.sngc17corr
         and a.pepais = ln_pais
         and a.petdoc = ln_tipo
         and a.pendoc = ln_numero
         and b.sngc16ttel = 2 -- 2=fijo 
         and a.docod = 1
         and rownum = 1;
    exception
    When Others then
     pn_telfij := null;  
    end;
           
    begin
      select to_number(trim(a.dotelfp))
        into pn_telcel
        from FSR005 A, SNGC17 B
       where a.pepais = b.sngc17pais
         and a.petdoc = b.sngc17tdoc
         and a.pendoc = b.sngc17ndoc
         and a.docod = b.sngc17dcod
         and a.doordp = b.sngc17corr
         and a.pepais = ln_pais
         and a.petdoc = ln_tipo
         and a.pendoc = ln_numero
         and b.sngc16ttel <> 2 -- celular
         and a.docod = 1
         and rownum = 1;
    exception
    When Others then
     pn_telcel := null;  
    end;        
                                    
  Exception
  When others then
  null;
  end;                                    
  Procedure sp_ah_valida_trx(pn_pgcod  in number, 
                             pn_hcmod  in number,
                             pn_htran  in number,
                             pn_indvig out number,
                             pn_tipmon out number
                             ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************

  begin
    select tp1nro3,TP1CORR3 
      into pn_indvig,pn_tipmon
      from FST198
     WHERE TP1COD = pn_pgcod
       AND TP1COD1 = 10864
       AND TP1CORR1 = 2
       and tp1nro1 = pn_hcmod
       and tp1nro2 = pn_htran;
  Exception 
  when no_data_found then 
    pn_indvig := 0;
    
  end sp_ah_valida_trx;    
  Procedure sp_ah_datos_contacto_com(pn_pgcod  in number, 
                                     pn_hcmod  in number,
                                     pn_htran  in number,
                                     pn_idterm in varchar2,
                                     pc_cocom  in varchar2,
                                     pc_coterm in varchar2,
                                     pd_fecpro in varchar2,
                                     pc_nomcon out varchar2,
                                     pc_telcon out varchar2
                                    ) is
  PRAGMA AUTONOMOUS_TRANSACTION;                                      
  pn_tipo1 number;
  pn_tipo2 number;
  ln_numcta number;
  begin
   
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => pn_pgcod,
                                           pn_hcmod => pn_hcmod,
                                           pn_htran => pn_htran,
                                           pn_tipo1 => pn_tipo1,
                                           pn_tipo2 => pn_tipo2
                                           );
    end; 
                                     
    Case                                 
    When pn_tipo2 in (2,5) Then  
        --ATMS
        begin
          pc_nomcon := null;
          pc_telcon := null;
        end;
    When pn_tipo2 = 3 Then    
        begin
          --CAJEROS CORRESPONSALES   
          select substr(c.ctnom,1,30),c.ctnro
            into pc_nomcon, ln_numcta
            from jaql002 b,
                 fsd008 c
           where b.jaql2coter = rpad(pc_coterm,20,' ')
             and c.pgcod = 1
             and c.ctnro = b.jaql2crcta
/*             and a.jaql9nuele = pn_idterm
             and a.jaql4cocom = rpad(pc_cocom,20,' ')
             and a.jaql9fealt = pd_fecpro*/
             ;
        exception when no_data_found then
           pc_nomcon := null;             
        end;
        
        begin
          select substr(y.dotelfp,1,15) into pc_telcon
            from fsr008 x,
                 fsr005 y
           where x.pepais = y.pepais
             and x.petdoc = y.petdoc
             and x.pendoc = y.pendoc
             and x.pgcod = 1
             and x.ctnro = ln_numcta
             and x.ttcod = 1
             and x.cttfir = 'T'
             and rownum = 1;
        exception when no_data_found then
           pc_telcon := null;             
        end;    
    Else
    null;
    End Case;
  End sp_ah_datos_contacto_com;   
      
  Procedure sp_ah_datos_comercio(pn_pgcod  in number, 
                                 pn_hcmod  in number,
                                 pn_htran  in number,
                                 pc_idterm in varchar2,
                                 pc_nomcom out varchar2,
                                 pc_dircom out varchar2,
                                 pc_telcom out varchar2,
                                 pc_locali out varchar2,
                                 pc_ruccom out varchar2
                                ) is
  PRAGMA AUTONOMOUS_TRANSACTION;                                
  pn_tipo1 number;
  pn_tipo2 number;  
  ln_ubgcod number;
  begin
   
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => pn_pgcod,
                                           pn_hcmod => pn_hcmod,
                                           pn_htran => pn_htran,
                                           pn_tipo1 => pn_tipo1,
                                           pn_tipo2 => pn_tipo2
                                           );
    end; 
                                     
    Case                                 
    /*When pn_tipo2 in (2,5) Then  
        begin
          -- ATMS 
          select substr(z0e475dsc,1,40) nombre, 
                 substr(z0e475ubi,1,50) direccion, 
                 null, 
                 null
            into pc_nomcom, pc_dircom, pc_telcom,pc_locali                 
            from z0e475
           where z0e475cod = rpad(pc_idterm,16,' ');
        exception when no_data_found then
           pc_nomcom := null; 
           pc_dircom := null; 
           pc_telcom := null;
           pc_locali := null;
        end;*/
    When pn_tipo2 = 3 Then    
        begin
          --CAJEROS CORRESPONSALES   
          select substr(jaql4nocom,1,40) nombre,
                 substr(jaql4direc,1,50) direccion,
                 substr(jaql4telef,1,15) telefono,
                 jaql4provi ubigeo,
                 jaql4nuruc 
            into pc_nomcom, pc_dircom, pc_telcom,ln_ubgcod,pc_ruccom
            from jaql004
           where jaql4cocom = rpad(pc_idterm,20,' ');
        exception when no_data_found then
           pc_nomcom := null; 
           pc_dircom := null; 
           pc_telcom := null;
        end;
        
        begin
          select substr(Locnom,1,13)
            into pc_locali
            from fst070
           where pais = 604
             and Loccod = ln_ubgcod;
        exception when no_data_found then
           pc_locali := null;             
        end;    
    Else
    null;
    End Case;
  End sp_ah_datos_comercio;    
  
  Procedure sp_ah_id_terminal(pn_pgcod  in number, 
                              pn_hcmod  in number,
                              pn_hsucor in number,
                              pn_htran  in number,
                              pn_hnrel  in number,         
                              pd_fecpro in date,
                              pc_uing   in varchar2,
                              pc_numtar in varchar2,
                              pc_idterm out varchar2,
                              pc_locali out varchar2,
                              pc_cocom  out varchar2
                             ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  PRAGMA AUTONOMOUS_TRANSACTION;
  pn_tipo1 number;
  pn_tipo2 number;
  ln_ubgcod number;
  begin
   
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => pn_pgcod,
                                           pn_hcmod => pn_hcmod,
                                           pn_htran => pn_htran,
                                           pn_tipo1 => pn_tipo1,
                                           pn_tipo2 => pn_tipo2
                                           );
    end;  
    
    case
    When pn_tipo2 = 1 Then
        -- SI ES VENTANILLA
        
        begin
          select ubsuc||ubncaj
            into pc_idterm 
            from fst046
           where pgcod = pn_pgcod
             and Ubuser = RPAD(pc_uing, 10, ' ');    
        Exception
        When Others then
             pc_idterm := pn_hsucor||'0';
        end;
        
        begin
          select trim(b.locnom) into pc_locali
            from fst001 a, fst070 b
           where b.LocCod = trim(a.scciud)
             and b.Pais = 604
             and a.pgcod = 1
             and a.sucurs = pn_hsucor;
           
        end;
    When pn_tipo2 in (2,5) Then  
        begin
          -- ATMS Y COMPRAS
          select substr(trim(f.jaqy254noter),1,15),trim(f.jaqy254ubtra)
            into pc_idterm,pc_locali      
            from jaqy254 f
           where f.jaqy254pgctr = pn_pgcod
             and f.jaqy254modtr = pn_hcmod
             and f.jaqy254suctr = pn_hsucor         
             and f.jaqy254codtr = pn_htran
             and f.jaqy254reltr = pn_hnrel
             --and f.jaqy254fetra = pd_fecpro;                  
             and f.jaqy254feini = pd_fecpro;
        exception when no_data_found then
           pc_idterm := null;
           pc_locali := null;
        end;
        If trim(pc_idterm) is null then
          begin
            -- ATMS RED UNIBANCA               
            select substr(trim(f.jaql540coter),1,15)
              into pc_idterm
              from jaql540 f
             where f.jaql540nutar = pc_numtar
               and f.jaql540trans = pn_htran
               and f.jaql540modul = pn_hcmod
               and f.jaql540relac = pn_hnrel
               and f.jaql540fetra = pd_fecpro;                                           
          exception when no_data_found then
             pc_idterm := null;
          end;        
        End If;       
        
    When pn_tipo2 = 3 Then    
        begin
          --CAJEROS CORRESPONSALES   
          select to_char(f.jaql9nuele),h.jaql4provi,g.jaql4cocom
            into pc_idterm,ln_ubgcod,pc_cocom      
            from jaql006 f,
                 jaql009 g,
                 jaql004 h
           where f.jaql6ctcod = pn_pgcod
             and f.jaql6ctmod = pn_hcmod
             and f.jaql6ctsuc = pn_hsucor
             and f.jaql6cttra = pn_htran
             and f.jaql6ctrel = pn_hnrel
             and f.jaql6ctfco = pd_fecpro
             and g.jaql9nuele = f.jaql9nuele
             and g.jaql4cocom = h.jaql4cocom
             ; 
        exception when no_data_found then
           pc_idterm := null;
        end;
        
        begin
          select trim(Locnom)
            into pc_locali
            from fst070
           where pais = 604
             and Loccod = ln_ubgcod;
        exception when no_data_found then
           pc_locali := null;             
        end;
    When pn_tipo2 = 4 Then    
        begin
          -- HOME BANKING
          select substr(f.x9996drqws,1,15),'BANCAINTERNET'
            into pc_idterm, pc_locali      
            from x9996d f
           where f.x9996drpgc = pn_pgcod
             and f.x9996drmod = pn_hcmod
             and f.x9996drsuc = pn_hsucor        
             and f.x9996drtrn = pn_htran
             and f.x9996drrel = pn_hnrel
             and f.x9996dfesv = pd_fecpro
             --and f.x9996grsco = 'OK11H'
             and f.x9996grsco = 'OK'
             and f.x9996acnco = 5;
        exception when no_data_found then
           pc_idterm := null; 
           pc_locali := null;          
        end;
     Else
        pc_idterm := null;    
        pc_locali := null;      
     End Case;   

/* exception
 when others then
   lc_error:= sqlerrm;
*/ end sp_ah_id_terminal;  
  procedure sp_ah_datos_trama(pn_pgcod  in number, --pgcod
                              pn_hcmod  in number, --hcmod
                              pn_hsucor in number, --hsucor
                              pn_htran  in number, --htran
                              pn_hnrel  in number, --hnrel         
                              pd_fecpro in date,   -- fecha transaccion
                              pn_tipo2  in number,
                              pn_codpet out number,
                              pc_coderr out varchar2,
                              pc_deserr out varchar2
                             ) is 

  begin 
      If pn_tipo2 in (2,5) Then
      -- si es cajero o compras
      -- CODIGO DE AUTORIZACION Y DE RESPUESTA
          begin
            select f.jaqy254gesec,lpad(f.jaqy254comsg,3,'0'),substr(f.jaqy254ubtra,45)
              into pn_codpet,pc_coderr,pc_deserr
              from jaqy254 f
             where f.jaqy254pgctr = pn_pgcod
               and f.jaqy254modtr = pn_hcmod
               and f.jaqy254suctr = pn_hsucor
               and f.jaqy254codtr = pn_htran
               and f.jaqy254reltr = pn_hnrel
               --and f.jaqy254fetra = pd_fecpro;
               and f.jaqy254feini = pd_fecpro;
          Exception
          When Others then
             pn_codpet := pn_hnrel;
             pc_coderr := '000';
             pc_deserr := 'Aprobado';
          end;     
      Else  
        --otros
        --MENSAJE DE ERROR
          begin
            select pn_hnrel,lpad(b.mncod,3,'0'),substr(trim(b.mntxt),1,45)
              into pn_codpet,pc_coderr,pc_deserr            
              from fsx015 a,
                   fst702 b
             where a.pgcod  = pn_pgcod
               and a.hcmod  = pn_hcmod
               and a.hsucor = pn_hsucor
               and a.htran  = pn_htran
               and a.hnrel  = pn_hnrel
               and a.hfcon  = pd_fecpro
               and a.txcod  = 666
               and to_number(trim(a.txtext)) = b.mncod;
          Exception
          When Others then
               pn_codpet := pn_hnrel;
               pc_coderr := '000';
               pc_deserr := 'Aprobado';       
          end;   
      End If; 
      
      If  pc_coderr = '000' Then
          pc_deserr := 'Aprobado';  
      End If;
  Exception
  When others then
   null;
  end sp_ah_datos_trama; 
      
  procedure sp_ah_param_trx(pn_pgcod  in number, 
                            pn_hcmod  in number,
                            pn_htran  in number,
                            pn_tipo1  out number,
                            pn_tipo2  out number
                           ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
 
  begin

    begin
    select tp1imp1, tp1imp2 into pn_tipo1, pn_tipo2
      from FST198
     WHERE TP1COD   = pn_pgcod
       AND TP1COD1  = 10864
       AND TP1CORR1 = 2
       and tp1nro1  = pn_hcmod
       and tp1nro2  = pn_htran;
    Exception 
    when no_data_found then
       null;
    end;  
 Exception
 When Others then
   null;  
 end sp_ah_param_trx;
     
  function fn_ah_fecven_tarj(pc_numtar  in varchar2
                            ) return date is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************

  ld_fecven date;
  begin

    begin
      select f.z0e478fvt
         into ld_fecven
          from z0e478 f 
        where f.z0e478nro = rpad(pc_numtar,19,' ');
        return ld_fecven;
    exception 
    when no_data_found then
       return null;
    end;     
 end fn_ah_fecven_tarj; 
     
  Procedure sp_ah_moneda_trx(pn_pgcod  in number, 
                             pn_hcmod  in number,
                             pn_hsucor in number,
                             pn_htran  in number,
                             pn_hnrel  in number,
                             pn_moncta in number,
                             pn_monope out number,
                             pc_indtic out varchar2
                             ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************

  lc_indtic varchar2(1):= 'N';
  begin
  pc_indtic := lc_indtic;
    begin
      select 'S'
         into lc_indtic
          from fsd016 f 
        where f.pgcod = pn_pgcod
          and f.itmod = pn_hcmod
          and f.itsuc = pn_hsucor
          and f.ittran = pn_htran
          and f.itnrel= pn_hnrel
          and f.ittcbi > 0
          and rownum = 1;
          
       pc_indtic := lc_indtic;
          
       If pn_moncta = 0 then
          pn_monope := 101;
       Else   
          pn_monope := 0;
       End If;     
    exception 
    when no_data_found then
       pn_monope := pn_moncta;
    end;     
 end sp_ah_moneda_trx;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_ah_titcuenta(pn_pgcod  in number, 
                            pn_ctacli in number,
                            pn_pais   out number,
                            pn_tipo   out number,
                            pc_numero out varchar2
                           ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
 
  begin

    begin
      select f.pepais, f.petdoc, f.pendoc  
         into pn_pais, pn_tipo, pc_numero
          from fsr008 f 
        where f.pgcod = pn_pgcod
          and f.ctnro = pn_ctacli
          and f.ttcod = 1
          and f.cttfir = 'T';
    Exception 
    when no_data_found then
       null;
    end;
  
 Exception
 When Others then
   null;  
 end sp_ah_titcuenta;
     
  procedure sp_ah_datos_trx(pn_pgcod  in number, --pgcod
                            pn_hcmod  in number, --hcmod
                            pn_hsucor in number, --hsucor
                            pn_htran  in number, --htran
                            pn_hnrel  in number, --hnrel         
                            pn_monto  out number,
                            pn_ctacli out number,
                            pn_modulo out number,
                            pn_moncta out number,
                            pn_subope out number,
                            pn_operac out number,
                            pn_tipope out number,
                            pn_sucurs out number,
                            pn_numchq out number,
                            pn_codord out number
                           ) is 
  pn_tipo3 number;
  begin 
  
    begin
    select tp1imp3 into pn_tipo3
      from FST198
     WHERE TP1COD   = pn_pgcod
       AND TP1COD1  = 10864
       AND TP1CORR1 = 2
       and tp1nro1  = pn_hcmod
       and tp1nro2  = pn_htran;
    Exception 
    when no_data_found then
       null;
    end;    
    begin
      select distinct a.ctnro, decode(a.modulo,426,22,a.modulo), a.moneda, a.itsubo, a.itoper, a.ittope, a.itsucd, a.itord, a.itcheq  
        into pn_ctacli, pn_modulo, pn_moncta, pn_subope, pn_operac, pn_tipope, pn_sucurs, pn_codord, pn_numchq
        from fsd016 a
       where a.pgcod = pn_pgcod
         and a.itsuc = pn_hsucor
         and a.itmod = pn_hcmod
         and a.ittran = pn_htran
         and a.itnrel = pn_hnrel
         and a.itdbha = pn_tipo3--1
         and a.ctnro > 0
         and itcodm not in (181,182,83,55)
         and a.itimp1 > 0         
         and a.modulo in (21,426);
    exception
    when no_data_found then    
        begin
          select distinct a.ctnro, decode(a.modulo,426,22,a.modulo), a.moneda, a.itsubo, a.itoper, a.ittope, a.itsucd, a.itord,a.itcheq    
            into pn_ctacli, pn_modulo, pn_moncta, pn_subope, pn_operac, pn_tipope, pn_sucurs, pn_codord,pn_numchq
            from fsd016 a
           where a.pgcod = pn_pgcod
             and a.itsuc = pn_hsucor
             and a.itmod = pn_hcmod
             and a.ittran = pn_htran
             and a.itnrel = pn_hnrel
             and a.itdbha = pn_tipo3--1
             and a.ctnro > 0
             and itcodm not in (181,182,83,55)
             and a.itimp1 > 0         
             and a.modulo in (22);
        exception
        when no_data_found then
          --**** se agrego monitor interno para aperturas   ***---
          begin
              select distinct a.ctnro, decode(a.modulo,122,22,a.modulo), a.moneda, a.itsubo, a.itoper, a.ittope,a.itsucd, a.itord,a.itcheq       
                into pn_ctacli, pn_modulo, pn_moncta, pn_subope, pn_operac, pn_tipope, pn_sucurs, pn_codord,pn_numchq
                from fsd016 a
               where a.pgcod = pn_pgcod
                 and a.itsuc = pn_hsucor
                 and a.itmod = pn_hcmod
                 and a.ittran = pn_htran
                 and a.itnrel = pn_hnrel
                 and a.itdbha = pn_tipo3--1
                 and a.ctnro > 0
                 and itcodm not in (181,182,83,55)
                 and a.itimp1 > 0         
                 and a.modulo = 122;            
            exception
            when no_data_found then
                 pn_ctacli := 0;            
            end;         
            --***fin***---
          return;
        when others then 
          pn_ctacli := null;     
        end;            
    when others then 
      pn_ctacli := null;     
    end;
    
    begin
      select sum(case
                   when itcodm in (83, 181) and (pn_hcmod = 50 and pn_htran=599 ) then
                    itimp1 / 2
                   else
                    itimp1
                 end) monto
        into pn_monto
        from fsd016 a
       where a.pgcod = pn_pgcod
         and a.itsuc = pn_hsucor
         and a.itmod = pn_hcmod
         and a.ittran = pn_htran
         and a.itnrel = pn_hnrel
         and a.itdbha = pn_tipo3--1
         --and a.ctnro > 0
         and a.modulo not in (496,497,174,175)
         and a.itord <> case 
                        when pn_hcmod = 30 and pn_htran=100 then
                             55
                        else
                             0
                        End
         ;         
    exception
    when others then
      pn_monto := 0;      
    end;
        
  Exception
  When others then
   null;
  end sp_ah_datos_trx; 
  
                                
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ah_numtarjeta(pn_pgcod  in number, 
                            pn_hcmod  in number,
                            pn_hsucor in number,
                            pn_htran  in number,
                            pn_hnrel  in number,         
                            pd_fecpro in date
                           ) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************

  lc_numtar varchar2(65);
  pn_tipo1 number;
  pn_tipo2 number;
  begin
   
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => pn_pgcod,
                                           pn_hcmod => pn_hcmod,
                                           pn_htran => pn_htran,
                                           pn_tipo1 => pn_tipo1,
                                           pn_tipo2 => pn_tipo2
                                           );
    end;  
    
    case
    When pn_tipo2 = 1 Then
        begin
          -- SI ES VENTANILLA
          select distinct nvl(max(txtord),NULL)
             into lc_numtar
              from fsx016 f 
            where f.pgcod  = pn_pgcod
              and f.hcmod  = pn_hcmod
              and f.hsucor = pn_hsucor
              and f.htran  = pn_htran
              and f.hnrel  = pn_hnrel
              and f.hfcon  = pd_fecpro
              and f.txcod  = 601;
        exception when no_data_found then
           lc_numtar := null;
        end;
    When pn_tipo2 in (2,5) Then  
        If  pn_hcmod <> 66 Then
          begin
            -- ATMS Y COMPRAS
            select f.jaqy254nutar
              into lc_numtar      
              from jaqy254 f
             where f.jaqy254pgctr = pn_pgcod
               and f.jaqy254modtr = pn_hcmod
               and f.jaqy254suctr = pn_hsucor         
               and f.jaqy254codtr = pn_htran
               and f.jaqy254reltr = pn_hnrel
               --and f.jaqy254fetra = pd_fecpro;                  
               and f.jaqy254feini = pd_fecpro;
          exception when no_data_found then
             lc_numtar := null;
          end;
        Else
          begin
            -- ATMS REVERSOS
            select f.z0e4getar
              into lc_numtar          
              from z0e4ge f  --OJO ESTA HACIENDO FULL A LA TABLA
             where f.z0e4geemp = pn_pgcod
               and f.z0e4gesuc = pn_hsucor
               and f.z0e4gemod = pn_hcmod
               and f.z0e4getrn = pn_htran
               and f.z0e4gerel = pn_hnrel
               and f.z0e4gefsv = pd_fecpro;
          exception when no_data_found then
            if pn_htran in (50,55) then
               lc_numtar := '4261530000000000';
            Else
               lc_numtar := null;
            End if;
          end;        
        End If;
    When pn_tipo2 = 3 Then    
        begin
          --CAJEROS CORRESPONSALES   
          select f.jaql6nutar
            into lc_numtar      
            from jaql006 f
           where f.jaql6ctcod = pn_pgcod
             and f.jaql6ctmod = pn_hcmod
             and f.jaql6ctsuc = pn_hsucor
             and f.jaql6cttra = pn_htran
             and f.jaql6ctrel = pn_hnrel
             and f.jaql6ctfco = pd_fecpro; 
        exception when no_data_found then
           lc_numtar := null;
        end;
    When pn_tipo2 = 4 Then    
        begin
          -- HOME BANKING
          select substr(f.x9996drqcl,1,16)
            into lc_numtar      
            from x9996d f
           where f.x9996drpgc = pn_pgcod
             and f.x9996drmod = pn_hcmod
             and f.x9996drsuc = pn_hsucor        
             and f.x9996drtrn = pn_htran
             and f.x9996drrel = pn_hnrel
             and f.x9996dfesv = pd_fecpro
             --and f.x9996grsco = 'OK11H'
             and f.x9996grsco = 'OK'
             and f.x9996acnco = 5;
        exception when no_data_found then
           lc_numtar := null;           
        end;
     Else
        lc_numtar := null;          
     End Case;   
  return TRIM(lc_numtar);
/* exception
 when others then
   lc_error:= sqlerrm;
*/ end fn_ah_numtarjeta;
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ah_doctarjeta(pn_pais   number, 
                            pn_tipo   number,
                            pc_numero varchar2,
                            pd_fecpro date
                           ) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  PRAGMA AUTONOMOUS_TRANSACTION;
  lc_numtar varchar2(65); 

  begin
            
    begin    
      select f.z0e478nro
        into lc_numtar
        from z0e478 f
       where f.z0e478thp = pn_pais
         and f.z0e478tht = pn_tipo
         and f.z0e478thd = RPAD(pc_numero,12,' ')
         and f.z0e463cod = 1;
    exception
      when no_data_found then
        begin
          select distinct f.z0e478nro
            into lc_numtar
            from z0e478 f
           where f.z0e478thp = pn_pais
             and f.z0e478tht = pn_tipo
             and f.z0e478thd = RPAD(pc_numero,12,' ')
             and f.z0e478fmd = pd_fecpro
             and rownum = 1;
        exception
          when no_data_found then
            begin
               select a.z0e478nro
                 into lc_numtar            
                 from (
                        select z0e478nro

                          from z0e478 f
                         where f.z0e478thp = pn_pais
                           and f.z0e478tht = pn_tipo
                           and f.z0e478thd = RPAD(pc_numero,12,' ')
                           order by f.z0e478fmd desc
                       ) a
                where rownum = 1;                      
            exception
              when others then
                lc_numtar := null;
            end;
        end;
    end;
    
  return lc_numtar;
  
 EXCEPTION
 WHEN OTHERS THEN
     return lc_numtar; 
 end fn_ah_doctarjeta;
 
  procedure sp_op_carga_JAQL979( pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2                                 
                              ) is          

  lc_JAQL979BYTEI jaql979.JAQL979BYTEI%type := 'ByteI';
  lc_JAQL979CONS  jaql979.JAQL979CONS%type  := 'N';
  lc_jaql979cod   jaql979.jaql979cod%type   := '08740'; --constante "08740"
  lc_jaql979use   jaql979.jaql979use%type; 
  ln_JAQL979FDIA  jaql979.JAQL979FDIA%type; 
  ln_JAQL979FMES  jaql979.JAQL979FMES%type; 
  ln_JAQL979FANI  jaql979.JAQL979FANI%type;
  ln_JAQL979HORA  jaql979.JAQL979HORA%type; 
  ln_JAQL979MIN   jaql979.JAQL979MIN%type; 
  lc_JAQL97987530 jaql979.JAQL97987530%type; 
  lc_JAQL97987531 jaql979.JAQL97987531%type; 
  pc_nomcom varchar2(40);
  pc_dircom varchar2(50);
  pc_telcom varchar2(15);
  pc_locali varchar2(13);
  
  lc_JAQL97987518 jaql979.JAQL97987518%type;
  lc_JAQL97987907 jaql979.JAQL97987907%type;
  lc_JAQL97987908 jaql979.JAQL97987908%type;
  lc_JAQL97987528 jaql979.JAQL97987528%type;   
  
  lc_JAQL97987910 jaql979.JAQL97987910%type;
  lc_JAQL97987911 jaql979.JAQL97987911%type;
  ln_JAQL97987510 jaql979.JAQL97987510%type;
  lc_JAQL97987913 jaql979.JAQL97987913%type;
  lc_JAQL97987914 jaql979.JAQL97987914%type;
  lc_JAQL97987915 jaql979.JAQL97987915%type;
  lc_JAQL97987916 jaql979.JAQL97987916%type;
  ln_JAQL97987922 jaql979.JAQL97987922%type;
  ln_JAQL97987923 jaql979.JAQL97987923%type;
  ln_JAQL97987924 jaql979.JAQL97987924%type;
  ln_JAQL97987928 jaql979.JAQL97987928%type;
  ln_JAQL97987929 jaql979.JAQL97987929%type; 
  ln_JAQL97987930 jaql979.JAQL97987930%type;  
  ln_JAQL97987931 jaql979.JAQL97987931%type; 
  ln_JAQL97987932 jaql979.JAQL97987932%type; 
  ln_JAQL97987933 jaql979.JAQL97987933%type; 
  ln_JAQL97987934 jaql979.JAQL97987934%type;  
  ln_JAQL97987935 jaql979.JAQL97987935%type; 
  ln_JAQL97987936 jaql979.JAQL97987936%type; 
  ln_JAQL97987937 jaql979.JAQL97987937%type; 
  ln_JAQL97987938 jaql979.JAQL97987938%type; 
  ln_JAQL97987939 jaql979.JAQL97987939%type; 
  ln_JAQL97987940 jaql979.JAQL97987940%type; 
  ln_JAQL97987941 jaql979.JAQL97987941%type; 
  ln_JAQL97987942 jaql979.JAQL97987942%type;  
  ln_JAQL97987943 jaql979.JAQL97987943%type;  
  ln_JAQL97987944 jaql979.JAQL97987944%type;  
  ln_JAQL97987945 jaql979.JAQL97987945%type;  
  lc_JAQL97987952 jaql979.JAQL97987952%type;  
  lc_JAQL97987953 jaql979.JAQL97987953%type;  
  lc_JAQL97987954 jaql979.JAQL97987954%type;  
  lc_JAQL97987955 jaql979.JAQL97987955%type;  
    
  pc_nomcon varchar2(30);
  pc_telcon varchar2(15); 
  
  lc_JAQL97987962 jaql979.JAQL97987962%type;
  ln_JAQL97987963 jaql979.JAQL97987963%type;
  ln_JAQL97987964 jaql979.JAQL97987964%type; 
  pn_tipo1 number;
  pn_tipo2 number;
  lc_ruccom varchar2(12);
  
  Begin
   --dia
   ln_jaql979fdia := to_number(to_char(pd_fecpro,'dd'));   
   --mes
   ln_jaql979fmes := to_number(to_char(pd_fecpro,'mm'));
   --año
   ln_jaql979fani := to_number(to_char(pd_fecpro,'yyyy'));
   --hora
   ln_jaql979hora := to_number(substr(pc_hora,1,2));
   --minuto
   ln_jaql979min  := to_number(substr(pc_hora,4,2));
   
   --usuario
   lc_jaql979use := pc_uing;
   
  
   --agencia
   --lc_JAQL97987531 := pn_hsucor;
   
   --nombre comercio, direccion, telefono, localidad
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_ah_datos_comercio(pn_pgcod => pn_pgcod,
                                                pn_hcmod => pn_hcmod,
                                                pn_htran => pn_htran,
                                                pc_idterm => pc_numero,
                                                pc_nomcom => pc_nomcom,
                                                pc_dircom => pc_dircom,
                                                pc_telcom => pc_telcom,
                                                pc_locali => pc_locali,
                                                pc_ruccom => lc_ruccom
                                                );
                                                    
    end; 
    
   --id comercio   
   lc_JAQL97987530 := lc_ruccom;
    
   If pn_htran = 200 Then
      lc_JAQL97987531 := pn_tipo;
   Else
      lc_JAQL97987531 := pc_numero;
   End If;    
    
    If pn_htran = 200 Then
      lc_JAQL97987518 := pc_nomcom;
      lc_JAQL97987907 := pc_dircom;
    Else
      lc_JAQL97987518 := pc_valant;
      lc_JAQL97987907 := pc_valact;    
    End If;
    
    
    lc_JAQL97987908 := pc_telcom;
    lc_JAQL97987528 := pc_locali;
        
    --tipo de persona
    lc_JAQL97987910 := 'J';
    
    --FECHA DE CONSITUCION
    lc_JAQL97987911 := NULL;
      
    
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => pn_pgcod,
                                           pn_hcmod => pn_hcmod,
                                           pn_htran => pn_htran,
                                           pn_tipo1 => pn_tipo1,
                                           pn_tipo2 => pn_tipo2);
    end;    
    --MMC
    If pn_tipo2 = 3 Then
       ln_JAQL97987510:= 6011;
    ElsIf pn_tipo2 = 2 Then
       ln_JAQL97987510:= 6010;
    Else
       ln_JAQL97987510:= 0;
    End If;
    
    --Venta autorizada pos
    lc_JAQL97987913 := 'S';
    lc_JAQL97987914 := 'N';
    lc_JAQL97987915 := 'N';
    lc_JAQL97987916 := 'N';
    
    --FECHA DE AFILIACION
    
    If pn_htran = 200  then
       ln_JAQL97987922 := pn_pais;     -- ahi vienne la fecha en formato numerico
    Else
       ln_JAQL97987922 := to_number(to_char(pd_fecpro,'rrrrmmdd'));
    End If;
     
    ln_JAQL97987923 := pn_hsucor;   
    ln_JAQL97987924 := 0;  
    
    If pn_htran = 200 Then
      --Horario de atención
      ln_JAQL97987928 := 090000;
      ln_JAQL97987929 := 210000;
      ln_JAQL97987930 := 090000;
      ln_JAQL97987931 := 210000;
      ln_JAQL97987932 := 090000;
      ln_JAQL97987933 := 210000;
      ln_JAQL97987934 := 090000;
      ln_JAQL97987935 := 210000;
      ln_JAQL97987936 := 090000;
      ln_JAQL97987937 := 210000;
      ln_JAQL97987938 := 090000;
      ln_JAQL97987939 := 210000;
      ln_JAQL97987940 := 090000;
      ln_JAQL97987941 := 210000;
    Else
    --Horario de atención
      ln_JAQL97987928 := 000000;
      ln_JAQL97987929 := 235959;
      ln_JAQL97987930 := 000000;
      ln_JAQL97987931 := 235959;
      ln_JAQL97987932 := 000000;
      ln_JAQL97987933 := 235959;
      ln_JAQL97987934 := 000000;
      ln_JAQL97987935 := 235959;
      ln_JAQL97987936 := 000000;
      ln_JAQL97987937 := 235959;
      ln_JAQL97987938 := 000000;
      ln_JAQL97987939 := 235959;
      ln_JAQL97987940 := 000000;
      ln_JAQL97987941 := 235959;    
    End If;
    --trx estimadas x mes
      ln_JAQL97987942 := 0;    
      ln_JAQL97987943 := 0;
      ln_JAQL97987944 := 0;
      ln_JAQL97987945 := 0;
    
    --Nombre ,puesto, telefono de contacto  
      lc_JAQL97987952 := 'N';
      
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_datos_contacto_com(pn_pgcod  => pn_pgcod,
                                                      pn_hcmod  => pn_hcmod,
                                                      pn_htran  => pn_htran,
                                                      pn_idterm => pn_tipo,
                                                      pc_cocom  => pc_numero,
                                                      pc_coterm => pc_valant,
                                                      pd_fecpro => pd_fecpro,
                                                      pc_nomcon => pc_nomcon,
                                                      pc_telcon => pc_telcon
                                                      );
      end;      
            
      lc_JAQL97987953 := pc_nomcon;
      lc_JAQL97987954 := null;
      lc_JAQL97987955 := pc_telcon;
      
      lc_JAQL97987962 := pc_telcon;      
      ln_JAQL97987963 := null;--0 
      ln_JAQL97987964 := null;--0


    insert into JAQL979(jaql979cor, 
                        jaql979bytei, 
                        jaql979cons, 
                        jaql979fdia,
                        jaql979fmes,
                        jaql979fani, 
                        jaql979hora,
                        jaql979min,     
                        jaql979cod,       
                        jaql979use,
                        
                        JAQL97987530,
                        JAQL97987531,
                        JAQL97987518,
                        JAQL97987907, 
                        JAQL97987908,
                        JAQL97987528,
                        JAQL97987910,
                        JAQL97987911,
                        JAQL97987510,
                        JAQL97987913,
                        JAQL97987914,
                        JAQL97987915,
                        JAQL97987916,
                        JAQL97987922,
                        JAQL97987923,
                        JAQL97987924,
                        JAQL97987928, 
                        JAQL97987929,
                        JAQL97987930,  
                        JAQL97987931, 
                        JAQL97987932,  
                        JAQL97987933,  
                        JAQL97987934,  
                        JAQL97987935,  
                        JAQL97987936,  
                        JAQL97987937,  
                        JAQL97987938,  
                        JAQL97987939,  
                        JAQL97987940,  
                        JAQL97987941,
                        JAQL97987942,
                        JAQL97987943,
                        JAQL97987944,
                        JAQL97987945,
                        JAQL97987952,
                        JAQL97987953,
                        JAQL97987954,
                        JAQL97987955,
                        JAQL97987962,
                        JAQL97987963,
                        JAQL97987964                        
                        )
                  values(pn_cor, 
                         lc_jaql979bytei, 
                         lc_jaql979cons,
                         ln_jaql979fdia,
                         ln_jaql979fmes,
                         ln_jaql979fani, 
                         ln_jaql979hora,
                         ln_jaql979min,                 
                         lc_jaql979cod,         
                         lc_jaql979use,
                         
                         lc_JAQL97987530,
                         lc_JAQL97987531,
                         lc_JAQL97987518,
                         lc_JAQL97987907,
                         lc_JAQL97987908,
                         lc_JAQL97987528,
                         lc_JAQL97987910,
                         lc_JAQL97987911,
                         ln_JAQL97987510,
                         lc_JAQL97987913,
                         lc_JAQL97987914,
                         lc_JAQL97987915,
                         lc_JAQL97987916,
                         ln_JAQL97987922,
                         ln_JAQL97987923,
                         ln_JAQL97987924,
                         ln_JAQL97987928, 
                         ln_JAQL97987929,
                         ln_JAQL97987930,  
                         ln_JAQL97987931, 
                         ln_JAQL97987932,  
                         ln_JAQL97987933,  
                         ln_JAQL97987934,  
                         ln_JAQL97987935,  
                         ln_JAQL97987936,  
                         ln_JAQL97987937,  
                         ln_JAQL97987938,  
                         ln_JAQL97987939,  
                         ln_JAQL97987940,  
                         ln_JAQL97987941,
                         ln_JAQL97987942,
                         ln_JAQL97987943,
                         ln_JAQL97987944,
                         ln_JAQL97987945,
                         lc_JAQL97987952,
                         lc_JAQL97987953,
                         lc_JAQL97987954,
                         lc_JAQL97987955,
                         lc_JAQL97987962,
                         ln_JAQL97987963,
                         ln_JAQL97987964                                                                               
                        );   
  /*
  JAQL979COR   NUMBER(18) not null,
  JAQL979BYTEI CHAR(5),
  JAQL979CONS  NUMBER(1),
  JAQL979FDIA  NUMBER(2),
  JAQL979FMES  NUMBER(2),
  JAQL979FANI  NUMBER(4),
  JAQL979HORA  NUMBER(2),
  JAQL979MIN   NUMBER(2),
  JAQL979COD   CHAR(5),
  JAQL979USE   CHAR(10),
  JAQL97987530 CHAR(15),
  JAQL97987531 CHAR(15),
  JAQL97987518 CHAR(40),
  JAQL9798793A CHAR(35),
  JAQL97987907 CHAR(50),
  JAQL97987908 CHAR(15),
  JAQL97987528 CHAR(13),
  JAQL97987909 CHAR(25),
  JAQL97987910 CHAR(1),
  JAQL97987911 NUMBER(8),
  JAQL97987912 CHAR(15),
  JAQL97987510 NUMBER(4),
  JAQL97987913 CHAR(1),
  JAQL97987914 CHAR(1),
  JAQL97987915 CHAR(1),
  JAQL97987916 CHAR(1),
  JAQL97987917 CHAR(1),
  JAQL97987918 CHAR(1),
  JAQL97987919 CHAR(1),
  JAQL97987920 CHAR(1),
  JAQL97987921 CHAR(1),
  JAQL97987922 NUMBER(8),
  JAQL97987923 NUMBER(5),
  JAQL97987924 NUMBER(4),
  JAQL97987925 CHAR(14),
  JAQL97987926 CHAR(1),
  JAQL97987927 NUMBER(12,2),
  JAQL97987928 NUMBER(6),
  JAQL97987929 NUMBER(6),
  JAQL97987930 NUMBER(6),
  JAQL97987931 NUMBER(6),
  JAQL97987932 NUMBER(6),
  JAQL97987933 NUMBER(6),
  JAQL97987934 NUMBER(6),
  JAQL97987935 NUMBER(6),
  JAQL97987936 NUMBER(6),
  JAQL97987937 NUMBER(6),
  JAQL97987938 NUMBER(6),
  JAQL97987939 NUMBER(6),
  JAQL97987940 NUMBER(6),
  JAQL97987941 NUMBER(6),
  JAQL97987942 NUMBER(8),
  JAQL97987943 NUMBER(12,2),
  JAQL97987944 NUMBER(12,2),
  JAQL97987945 NUMBER(12,2),
  JAQL97987946 NUMBER(12,2),
  JAQL97987947 NUMBER(12,2),
  JAQL97987948 NUMBER(5),
  JAQL97987949 CHAR(1),
  JAQL97987950 NUMBER(8),
  JAQL97987951 NUMBER(5),
  JAQL97987952 CHAR(1),
  JAQL97987953 CHAR(30),
  JAQL97987954 CHAR(20),
  JAQL97987955 CHAR(15),
  JAQL97987956 CHAR(30),
  JAQL97987957 CHAR(20),
  JAQL97987958 CHAR(15),
  JAQL97987959 CHAR(30),
  JAQL97987960 CHAR(20),
  JAQL97987961 CHAR(15),
  JAQL97987962 CHAR(15),
  JAQL97987963 NUMBER(12,2),
  JAQL97987964 NUMBER(12,2),
  JAQL97987965 NUMBER(3,2),
  JAQL97987966 NUMBER(12,2),
  JAQL97987967 CHAR(1),
  JAQL97987968 CHAR(1),
  JAQL97987969 CHAR(1),
  JAQL97987970 CHAR(20),
  JAQL97987971 CHAR(20),
  JAQL97987972 CHAR(15),
  JAQL97987973 CHAR(1),
  JAQL97987974 NUMBER(5)  
  */
  End sp_op_carga_JAQL979;     
                            
  procedure sp_op_carga_JAQL976( pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2                                 
                              ) is
  lc_modtra varchar2(6);          
  lc_numtar varchar2(65);


  lc_JAQL976BYTEI jaql976.JAQL976BYTEI%type := 'ByteI';
  lc_JAQL976CONS  jaql976.JAQL976CONS%type  := 'N';
  lc_JAQL976BYTEF jaql976.JAQL976BYTEF%type := 'ByteF';
  lc_jaql976cod   jaql976.jaql976cod%type   := '08630'; --constante "08630"
  lc_jaql976use   jaql976.jaql976use%type;
  lc_JAQL97687516 jaql976.JAQL97687516%type;
  lc_JAQL97687531 jaql976.JAQL97687531%type;
  
  ln_JAQL976FDIA  jaql976.JAQL976FDIA%type; 
  ln_JAQL976FMES  jaql976.JAQL976FMES%type; 
  ln_JAQL976FANI  jaql976.JAQL976FANI%type;
  ln_JAQL976HORA  jaql976.JAQL976HORA%type; 
  ln_JAQL976MIN   jaql976.JAQL976MIN%type; 
  lc_JAQL97687584  varchar2(15);
  ln_JAQL97687506 jaql976.JAQL97687506%type;
  ln_JAQL97687507 jaql976.JAQL97687507%type;
  lc_valact       jaql976.JAQL97687692%type;
   
 begin
  
   --dia
   ln_jaql976fdia := to_number(to_char(pd_fecpro,'dd'));   
   --mes
   ln_jaql976fmes := to_number(to_char(pd_fecpro,'mm'));
   --año
   ln_jaql976fani := to_number(to_char(pd_fecpro,'yyyy'));
   --hora
   ln_jaql976hora := to_number(substr(pc_hora,1,2));
   --minuto
   ln_jaql976min  := to_number(substr(pc_hora,4,2));
   
   --usuario
   lc_jaql976use := pc_uing;

   --87549 tipo MSJ 
   
   ----87584
   lc_JAQL97687584 := pc_numero;
   

   
   ----
   /*
    begin --87642
      lc_numtar := pq_op_asientos_mplus.fn_ah_numtarjeta(pn_pgcod  => pn_pgcod,
                                                         pn_hcmod  => pn_hcmod,
                                                         pn_hsucor => pn_hsucor,
                                                         pn_htran  => pn_htran,
                                                         pn_hnrel  => pn_hnrel,
                                                         pd_fecpro => pd_fecpro
                                                         );
                                                              
    end;
    

    begin
      If lc_numtar is null Then   
      */
         --lc_numtar := pq_op_asientos_mplus.fn_ah_doctarjeta(pn_pais,pn_tipo,pc_numero,pd_fecpro);                                                        
     /*    
      End If;
    end;*/
    If pn_hcmod = 800 and pn_htran in (100,101) Then    
       lc_numtar := substr(pc_valact,1,16);
       lc_valact := substr(pc_valact,17,length(pc_valact)-16);
    Else
       lc_numtar := pq_op_asientos_mplus.fn_ah_doctarjeta(pn_pais,pn_tipo,pc_numero,pd_fecpro);
       lc_valact := pc_valact;
    End If;
    
    lc_modtra := lpad(pn_hcmod,3,'0')||lpad(pn_htran,3,'0');   --87750

   
   --87506 hora trx
   ln_JAQL97687506 := to_number(replace(pc_hora,':',''));
   --87507 fecha trx 
   
   ln_JAQL97687507 := to_number(to_char(pd_fecpro,'rrrrmmdd'));
   --sucursal
   lc_JAQL97687531 := pn_hsucor;
   
   If pn_hcmod = 800  then
     lc_JAQL97687516 := pn_hsucor;
   End If;
   ---insercion

   
    insert into JAQL976
      (
      JAQL976COR   ,  
      JAQL976BYTEI ,     
      JAQL976CONS  ,    
      JAQL976FDIA  ,      
      JAQL976FMES  ,      
      JAQL976FANI  ,      
      JAQL976HORA  ,      
      JAQL976MIN   ,      
      JAQL976COD   ,      
      JAQL976USE   ,      
      JAQL97687584 ,      
      JAQL97687862 ,      
      JAQL97687550 ,      
      JAQL97687506 ,      
      JAQL97687507 ,      
      JAQL97687516 ,      
      JAQL97687691 ,      
      JAQL97687692 ,      
      JAQL97687531 ,      
      JAQL976BYTEF       
      )
   values
      ( pn_cor, 
        lc_JAQL976BYTEI,
        lc_JAQL976CONS,
        ln_JAQL976FDIA,         
        ln_JAQL976FMES,       
        ln_JAQL976FANI, 
        ln_JAQL976HORA, 
        ln_JAQL976MIN,
        lc_jaql976cod,
        lc_jaql976use,
        lc_JAQL97687584,
        lc_numtar,
        lc_modtra,   
        ln_JAQL97687506,
        ln_JAQL97687507,
        lc_JAQL97687516,
        pc_valant,
        lc_valact,/*pc_valact*/
        lc_JAQL97687531,
        lc_JAQL976BYTEF        
        ); 
 end sp_op_carga_JAQL976; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_op_carga_JAQL977(  pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pc_cont in varchar2,  --estado contable 
                                 pn_corr in number, --itcorr - (99-extornado)
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              ) is
  lc_modtra varchar2(6);          
  lc_numtar varchar2(65);
  lc_jaql977bytei jaql977.jaql977bytei%type := 'ByteI';
  lc_jaql977cons  jaql977.jaql977cons%type  := 'N';
  lc_jaql977bytef jaql977.jaql977bytef%type := 'ByteF';
  lc_jaql977cod   jaql977.jaql977cod%type   := '08650'; --constante "08650"
  lc_jaql977use   jaql977.jaql977use%type;
  lc_jaql977rev   char(1);
  ln_jaql97787505 jaql977.jaql97787505%type;
  
  ln_jaql977fdia  jaql977.jaql977fdia%type; 
  ln_jaql977fmes  jaql977.jaql977fmes%type; 
  ln_jaql977fani  jaql977.jaql977fani%type;
  ln_jaql977hora  jaql977.jaql977hora%type; 
  ln_jaql977min   jaql977.jaql977min%type; 
  lc_jaql97787549 jaql977.jaql97787549%type;
  lc_jaql97787550 jaql977.jaql97787550%type;
  ln_jaql97787503 jaql977.jaql97787503%type;
  
  pn_monto  number(12,2):=0;
  pn_ctacli number(9);
  pn_modulo number(3); 
  pn_numchq fsd016.itcheq%type;
  
  ln_pais number(3);
  ln_tipo number(2);  
  lc_numero char(12);
  pn_moncta fsd016.moneda%type;
  ln_monope fsd016.moneda%type; 
  pn_subope fsd016.itsubo%type;
  ln_jaql97787560 jaql977.jaql97787560%type;
  ln_jaql97787506 jaql977.jaql97787506%type;
  ln_jaql97787507 jaql977.jaql97787507%type;
  ln_jaql97787508 jaql977.jaql97787508%type;
  ln_jaql97787510 jaql977.jaql97787510%type;
  ln_jaql97787543 jaql977.jaql97787543%type := 604; --ojo este es el codigo de pais para trx internacionales hay q buscar el pais!!!!
  lc_jaql97787511 jaql977.jaql97787511%type;
  pn_tipo1 number;
  pn_tipo2 number;
  lc_JAQL97787579 jaql977.JAQL97787579%type;
  ln_jaql97787512 jaql977.jaql97787512%type;
  ln_jaql97787513 jaql977.jaql97787513%type;
  ln_jaql97787546 jaql977.jaql97787546%type;
  ln_jaql97787633 jaql977.jaql97787633%type;
  ln_jaql97787514 jaql977.jaql97787514%type;
  lc_jaql97787515 jaql977.jaql97787515%type;  
  
  pn_codpet number(10);
  pc_coderr char(3);
  pc_deserr char(45);
  lc_jaql97787562 jaql977.jaql97787562%type;
  lc_jaql97787531 jaql977.jaql97787531%type; 
  lc_jaql97787516 jaql977.jaql97787516%type;
  lc_jaql97787528 jaql977.jaql97787528%type;
  lc_jaql97787519 jaql977.jaql97787519%type;
  ln_jaql97787547 jaql977.jaql97787547%type;
  lc_jaql97787535 jaql977.jaql97787535%type;
  lc_jaql97787524 jaql977.jaql97787524%type;
  ln_jaql97787554 jaql977.jaql97787554%type;
  pc_idterm varchar2(15);
  pc_locali varchar2(100); 
  pc_locali1 varchar2(100);
  ln_jaql97787564 jaql977.jaql97787564%type;  
  ln_jaql97787544 jaql977.jaql97787544%type;  
  pc_cocom varchar2(20) ;
  pc_nomcom varchar2(40);
  pc_dircom varchar2(50);
  pc_telcom varchar2(15);  
  
  lc_jaql97787518 jaql977.jaql97787518%type;  
  ln_jaql97787548 jaql977.jaql97787548%type;
  lc_jaql97787580 jaql977.jaql97787580%type;
  
  ln_suctar fst001.sucurs%type;
  lc_loccli fst070.locnom%type;
  lc_prinom fsd002.pfnom1%type;
  lc_segnom fsd002.pfnom2%type;
  lc_priape fsd002.pfape1%type;
  lc_segape fsd002.pfape2%type;
  ln_telfij fsr005.dotelfp%type;
  ln_telcel fsr005.dotelfp%type; 
 
  lc_jaql97787583 jaql977.jaql97787583%type;  
  lc_jaql97787536 jaql977.jaql97787536%type;  
  lc_jaql97787575 jaql977.jaql97787575%type;  
  lc_jaql97787576 jaql977.jaql97787576%type;  
  lc_jaql97787577 jaql977.jaql97787577%type;  
  lc_jaql97787578 jaql977.jaql97787578%type;    
  lc_jaql97787584 jaql977.jaql97787584%type;    
  ln_jaql97787589 jaql977.jaql97787589%type;  
  ln_jaql97787590 jaql977.jaql97787590%type;  
  ln_jaql97787591 jaql977.jaql97787591%type;    
  lc_jaql97787552 jaql977.jaql97787552%type;  
  lc_jaql97787712 jaql977.jaql97787712%type;  
  lc_jaql97787713 jaql977.jaql97787713%type;  
  lc_jaql97787714 jaql977.jaql97787714%type;  
  lc_ruccom varchar2(12);
  
  pn_hcmod_o number(3);
  pn_hnrel_o number(4); 
  pd_fecpro_o date;
  ln_valida number;
  pn_operac fsd011.scoper%type;
  ln_htran number;
  
  ln_jaql97787527 jaql977.jaql97787527%type;
  
  ln_pgcod   number;
  ln_hcmod   number;
  ln_hsucor  number;
  --ln_modulo  number;
  --ln_htran   number;
  ln_hnrel   number; 
  lc_indoff  char(1) := 'N'; 
  pn_monope  number; 
  
  lc_idterm varchar2(100);
  lc_locali varchar2(100);
  lc_valant varchar2(100);
  lc_valact varchar2(100);
  pn_condtra_ori number;
  lc_MMC  varchar2(20);
  ln_totmov number(17,2):=0;
  
  ln_tipope number:=0;
  pn_tipope number:=0;
  lc_cuenta varchar2(27):='';
  LC_JAQL97787716 jaql977.JAQL97787716%type;  
  pn_codord fsd016.itord%type;
  pn_sucurs fsd016.itsucd%type;
  ln_null number;
  lc_indtic char(1);
  ln_jaql97787504 jaql977.jaql97787504%type;  

 begin
  
   --dia
   ln_jaql977fdia := to_number(to_char(pd_fecpro,'dd'));   
   --mes
   ln_jaql977fmes := to_number(to_char(pd_fecpro,'mm'));
   --año
   ln_jaql977fani := to_number(to_char(pd_fecpro,'yyyy'));
   --hora
   ln_jaql977hora := to_number(substr(pc_hora,1,2));
   --minuto
   ln_jaql977min  := to_number(substr(pc_hora,4,2));
   
   --usuario
   lc_jaql977use := pc_uing;

   --87549 tipo MSJ 
   ----
   
  If pn_pgcod = 0 and pn_pais = 1 then
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_trx_offline(pn_codtra => pn_tipo, --ahi viene el codtra para offline
                                               pd_fecpro => pd_fecpro,
                                               pc_numtar => pc_cont,
                                               pn_pgcod  => ln_pgcod,
                                               pn_hcmod  => ln_hcmod,
                                               pn_hsucor => ln_hsucor,
                                               pn_htran  => ln_htran,
                                               pn_hnrel  => ln_hnrel
                                               );
      end;   
      
      
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_valida_trx(pn_pgcod  => ln_pgcod,
                                              pn_hcmod  => ln_hcmod,
                                              pn_htran  => ln_htran,
                                              pn_indvig => ln_valida,
                                              pn_tipmon => ln_null
                                              );
      end;                        
      lc_indoff := 'S';
  Else 
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_valida_trx(pn_pgcod  => pn_pgcod,
                                              pn_hcmod  => pn_hcmod,
                                              pn_htran  => pn_htran,
                                              pn_indvig => ln_valida,
                                              pn_tipmon => ln_null
                                              );
      end;         
      lc_indoff := 'N';
  End If;
   
   If ln_valida <> 2 Then
      lc_jaql97787549 := 210;--pn_hnrel;
   ELse
      lc_jaql97787549 := 420;--pn_hnrel;
   End IF;
   ----
    
   --obtener la cuenta
    If lc_indoff = 'N' Then
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trx(pn_pgcod  => pn_pgcod,
                                               pn_hcmod  => pn_hcmod,
                                               pn_hsucor => pn_hsucor,
                                               pn_htran  => pn_htran,
                                               pn_hnrel  => pn_hnrel,
                                               pn_monto  => pn_monto,
                                               pn_ctacli => pn_ctacli,
                                               pn_modulo => pn_modulo,
                                               pn_moncta => pn_moncta,
                                               pn_subope => pn_subope,
                                               pn_operac => pn_operac,
                                               pn_tipope => pn_tipope,
                                               pn_sucurs => pn_sucurs,      
                                               pn_numchq => pn_numchq,                                         
                                               pn_codord => pn_codord
                                              );
        end;      
    Else
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trx_off(pc_numtar => pc_cont, --tarjeta
                                                   pn_codtra => pn_tipo,  --codtra 
                                                   pd_fecpro => pd_fecpro,
                                                   pn_indtrx => ln_valida,
                                                   pn_monto  => pn_monto,
                                                   pn_ctacli => pn_ctacli,
                                                   pn_modulo => pn_modulo,
                                                   pn_moncta => pn_moncta,
                                                   pn_subope => pn_subope,
                                                   pn_operac => pn_operac,
                                                   pn_tipope => pn_tipope,
                                                   pn_sucurs => pn_sucurs,                                                    
                                                   pn_monope => pn_monope
                                                  );
        end;        
    End If;
    /*
    If pn_hcmod >= 500 Then
      pq_op_asientos_mplus.sp_ah_trx_ori(pn_pgcod    => pn_pgcod,
                                         pn_hcmod    => pn_hcmod,
                                         pn_hsucor   => pn_hsucor,
                                         pn_htran    => pn_htran,
                                         pn_hnrel    => pn_hnrel,
                                         pd_fecpro   => pd_fecpro,
                                         pn_hcmod_o  => pn_hcmod_o,
                                         pn_hnrel_o  => pn_hnrel_o,
                                         pd_fecpro_o => pd_fecpro_o
                                        );
      lc_numtar := pq_op_asientos_mplus.fn_ah_numtarjeta(pn_pgcod  => pn_pgcod,
                                                         pn_hcmod  => pn_hcmod_o,
                                                         pn_hsucor => pn_hsucor,
                                                         pn_htran  => pn_htran,
                                                         pn_hnrel  => pn_hnrel_o,
                                                         pd_fecpro => pd_fecpro_o
                                                         );       
    
    Else         
    lc_numtar := pq_op_asientos_mplus.fn_ah_numtarjeta(pn_pgcod  => pn_pgcod,
                                                       pn_hcmod  => pn_hcmod,
                                                       pn_hsucor => pn_hsucor,
                                                       pn_htran  => pn_htran,
                                                       pn_hnrel  => pn_hnrel,
                                                       pd_fecpro => pd_fecpro
                                                       );
    End If;                                                       
    */
    If lc_indoff = 'N' Then
       lc_numtar := pc_numtar;
    Else
       lc_numtar := pc_cont;    
    End If;                                                   
  --obtener datos del dueño de la tarjeta      
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_ah_datos_tarjhabiente(pn_numtar => lc_numtar,
                                                    pn_suctar => ln_suctar,
                                                    pc_loccli => lc_loccli,
                                                    pc_prinom => lc_prinom,
                                                    pc_segnom => lc_segnom,
                                                    pc_priape => lc_priape,
                                                    pc_segape => lc_segape,
                                                    pn_telfij => ln_telfij,
                                                    pn_telcel => ln_telcel,
                                                    pn_pais   => ln_pais,
                                                    pn_tipo   => ln_tipo,
                                                    pc_numero => lc_numero);
    end;                                                            
   --obtener titular principal de la cuenta         
/*    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_ah_titcuenta(pn_pgcod  => pn_pgcod,
                                           pn_ctacli => pn_ctacli,
                                           pn_pais   => ln_pais,
                                           pn_tipo   => ln_tipo,
                                           pc_numero => lc_numero
                                           );
    end;     */    
                                                    
/*    If lc_numtar is null then
      
         
    lc_numtar := pq_op_asientos_mplus.fn_ah_doctarjeta(pn_pais   => pn_pais,
                                                       pn_tipo   => pn_tipo,
                                                       pc_numero => pc_numero,
                                                       pd_fecpro => pd_fecpro
                                                      );         
    End If;
*/

  If lc_indoff = 'N' Then
    If ln_valida = 2 Then
       If pn_hcmod > 500 Then
          lc_modtra := lpad(pn_hcmod-500,3,'0')||lpad(pn_htran,3,'0');   --87750
       Else
          lc_modtra := lpad(pn_hcmod,3,'0')||lpad(pn_htran,3,'0');   --87750       
       End If;
    Else
       lc_modtra := lpad(pn_hcmod,3,'0')||lpad(pn_htran,3,'0');   --87750    
    End If;
  Else
    If ln_valida = 2 Then
       If ln_hcmod > 500 Then
          lc_modtra := lpad(ln_hcmod-500,3,'0')||lpad(ln_htran,3,'0');   --87750
       Else
          lc_modtra := lpad(ln_hcmod,3,'0')||lpad(ln_htran,3,'0');   --87750       
       End If;
    Else
       lc_modtra := lpad(ln_hcmod,3,'0')||lpad(ln_htran,3,'0');   --87750    
    End If;  
  End If;
    
    

    lc_jaql97787550 := lc_modtra;
    
    
    
   --87502 indicador reverso 
   if ln_valida = 2 then
      lc_jaql977rev := 'S';
   else
      lc_jaql977rev := 'N';
   end if;
   --
   
   --87503 monto moneda local
   --Para obtener el monto en moneda local analizamos en que moneda se realizo la operacion fsd016
   
   If lc_indoff = 'N' Then
      pq_op_asientos_mplus.sp_ah_moneda_trx(pn_pgcod  => pn_pgcod,
                                            pn_hcmod  => pn_hcmod,
                                            pn_hsucor => pn_hsucor,
                                            pn_htran  => pn_htran,
                                            pn_hnrel  => pn_hnrel,
                                            pn_moncta => pn_moncta,
                                            pn_monope => ln_monope,
                                            pc_indtic => lc_indtic
                                            );   
   Else   
       ln_monope := pn_monope;  
   End If;
   
   
   If ln_monope = 101 and lc_indtic = 'N' then   

      ln_jaql97787503 := round(pn_monto* fn_tipo_cambio(fecha  => pd_fecpro,
                                                        monori => 0,
                                                        mondes => ln_monope,
                                                        tipo   => 500
                                                        ),2);     
      ln_jaql97787504 := pn_monto; --monto en moneda de la trx
   ElsiF ln_monope = 101 and lc_indtic = 'S' then 
      ln_jaql97787503 := pn_monto;
      ln_jaql97787504 := round(pn_monto/ fn_tipo_cambio(fecha  => pd_fecpro,
                                                        monori => 0,
                                                        mondes => ln_monope,
                                                        tipo   => 500
                                                        ),2);--monto en moneda de la trx
   ElsiF ln_monope = 0 and lc_indtic = 'S' then 

      ln_jaql97787503 := round(pn_monto* fn_tipo_cambio(fecha  => pd_fecpro,
                                                        monori => 101,
                                                        mondes => ln_monope,
                                                        tipo   => 500
                                                        ),2); 
      ln_jaql97787504 := ln_jaql97787503;--monto en moneda de la trx
   Else  
      ln_jaql97787503 := pn_monto;
      ln_jaql97787504 := pn_monto;--monto en moneda de la trx
   End If;
   
   
   --87560 fecha hora transmision
   If lc_indoff = 'N' Then
      ln_jaql97787560  := to_number(to_char(pd_fecpro,'rrrrmmdd')||replace(pc_hora,':',''));
   Else
      ln_jaql97787560  := to_number(to_char(trunc(sysdate),'rrrrmmdd')||replace(pc_hora,':',''));
   End If;
   --87505 numero transaccion 
   ln_jaql97787505 := pn_hnrel;
   
   --87506 hora trx
   ln_jaql97787506 := to_number(replace(pc_hora,':',''));
           
   --87507 fecha trx 
   If lc_indoff = 'N' Then
      ln_jaql97787507 :=  to_number(to_char(pd_fecpro,'rrrrmmdd'));  
   Else
      ln_jaql97787507 :=  to_number(to_char(trunc(sysdate),'rrrrmmdd'));
   End If;
   --87508 fecha vencimiento
   ln_jaql97787508 := to_number(substr(to_char(fn_ah_fecven_tarj(lc_numtar),'ddmmyy'),3,4));
   
   If lc_indoff = 'N' Then
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => pn_pgcod,
                                             pn_hcmod => pn_hcmod,
                                             pn_htran => pn_htran,
                                             pn_tipo1 => pn_tipo1,
                                             pn_tipo2 => pn_tipo2
                                            );
      end;   
   Else
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => ln_pgcod,
                                             pn_hcmod => ln_hcmod,
                                             pn_htran => ln_htran,
                                             pn_tipo1 => pn_tipo1,
                                             pn_tipo2 => pn_tipo2
                                            );
      end;      
   End If;
   
   --entry mode     
   If lc_numtar is null then
      lc_jaql97787511 := '01';
   Else
      lc_jaql97787511 := '02';
   End If;
   --- pin entry capability
   
 
    lc_JAQL97787579 := lpad(to_char(pn_tipo1),2,'0');  
    
    If pn_tipo2 = 1 then 
       ln_jaql97787512 := 0;
    Else
       ln_jaql97787512 := 2; -- o puede ser 1 = tarjetahabiente no presente
    End If;
    
    --bin adquiriente
    ln_jaql97787513 := SUBSTR(nvl(lc_numtar,'426153'),1,6);    
    --id empresa RUC
    ln_jaql97787546 := 20100209641;--426153;
    -- find
    ln_jaql97787633 := 426153;--803;
    --numero autorizacion
    If lc_indoff = 'N' Then
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trama(pn_pgcod  => pn_pgcod,
                                                 pn_hcmod  => pn_hcmod,
                                                 pn_hsucor => pn_hsucor,
                                                 pn_htran  => pn_htran,
                                                 pn_hnrel  => pn_hnrel,
                                                 pd_fecpro => pd_fecpro,
                                                 pn_tipo2  => pn_tipo2,
                                                 pn_codpet => pn_codpet,
                                                 pc_coderr => pc_coderr,
                                                 pc_deserr => pc_deserr
                                                 );
        end;  
    Else
        pn_codpet := pn_tipo;
        pc_coderr := '000';
        pc_deserr := 'Aprobado';
    End If;        
      
    ln_jaql97787514 := pn_codpet;    
    --codigo rpta
    lc_jaql97787515 := pc_coderr;   
    lc_jaql97787562 := pc_deserr;
    
    --id de terminal
      -- Call the procedure
       If lc_indoff = 'N' Then   
          If ln_valida = 2 and pn_hcmod > 500 then
              
              PQ_OP_ASIENTOS_MPLUS.sp_ah_trx_ori(pn_pgcod    => pn_pgcod,
                                                 pn_hcmod    => pn_hcmod,
                                                 pn_hsucor   => pn_hsucor,
                                                 pn_htran    => pn_htran,
                                                 pn_hnrel    => pn_hnrel,
                                                 pd_fecpro   => pd_fecpro,
                                                 pn_hcmod_o  => pn_hcmod_o,
                                                 pn_hnrel_o  => pn_hnrel_o,
                                                 pd_fecpro_o => pd_fecpro_o
                                                );
                                                      
              
              PQ_OP_ASIENTOS_MPLUS.sp_ah_id_terminal(pn_pgcod  => pn_pgcod,
                                                     pn_hcmod  => pn_hcmod_o,
                                                     pn_hsucor => pn_hsucor,
                                                     pn_htran  => pn_htran,
                                                     pn_hnrel  => pn_hnrel_o,
                                                     pd_fecpro => pd_fecpro_o,
                                                     pc_uing   => pc_uing,  
                                                     pc_numtar => lc_numtar,                                           
                                                     pc_idterm => pc_idterm,
                                                     pc_locali => pc_locali,
                                                     pc_cocom  => pc_cocom
                                                     );
        Else                                             
            PQ_OP_ASIENTOS_MPLUS.sp_ah_id_terminal(pn_pgcod  => pn_pgcod,
                                                   pn_hcmod  => pn_hcmod,
                                                   pn_hsucor => pn_hsucor,
                                                   pn_htran  => pn_htran,
                                                   pn_hnrel  => pn_hnrel,
                                                   pd_fecpro => pd_fecpro,
                                                   pc_uing   => pc_uing,  
                                                   pc_numtar => lc_numtar,                                           
                                                   pc_idterm => pc_idterm,
                                                   pc_locali => pc_locali,
                                                   pc_cocom  => pc_cocom
                                                   );    
        end If;   
      Else
        If ln_valida = 2 then
            --buscamos trx original de offline
            PQ_OP_ASIENTOS_MPLUS.sp_ah_datos_trx_ori_off(pn_numtar => lc_numtar,
                                                         pn_codtra => pn_tipo,
                                                         pd_fecpro => pd_fecpro,                                                                      
                                                         pn_traori => pn_condtra_ori
                                                         );
            PQ_OP_ASIENTOS_MPLUS.sp_ah_datos_ter_off(pn_codtra => pn_condtra_ori,
                                                     pc_idterm => lc_idterm,  
                                                     pc_locali => lc_locali,
                                                     pc_valant => lc_valant,
                                                     pc_valact => lc_valact,
                                                     pc_numero => lc_MMC        
                                                     );                                                           
        Else
            PQ_OP_ASIENTOS_MPLUS.sp_ah_datos_ter_off(pn_codtra => pn_tipo,
                                                     pc_idterm => lc_idterm,  
                                                     pc_locali => lc_locali,
                                                     pc_valant => lc_valant,
                                                     pc_valact => lc_valact,
                                                     pc_numero => lc_MMC       
                                                     );        
        End If;                                                     
            
      End If;
        
   --MMC
   
   If pn_tipo2 in (2,3) Then
      ln_jaql97787510 := 6011;
   ElsIf pn_tipo2 = 1  Then
      ln_jaql97787510 := 6010;
   Else
      If lc_indoff = 'N' then
         ln_jaql97787510 := to_number(trim(pc_numero));
      Else
         ln_jaql97787510 := to_number(trim(lc_MMC));      
      End If;
   End If;      
      
      
    If lc_indoff = 'N' Then   
      If pn_tipo2 <> 5 then
         lc_jaql97787516 := pc_idterm;    
      Else
         lc_jaql97787516 := trim(pc_valant);    
      End If;
      -- agencia
      --lc_jaql97787531 := pn_hsucor;
       If pn_tipo2 = 3 Then  --corresponsal
          lc_jaql97787531 := TRIM(pc_cocom); 
       Elsif pn_tipo2 = 2 Then --atm
          lc_jaql97787531 := TRIM(pc_idterm);--
       Elsif pn_tipo2 = 1 Then --ventanilla
          lc_jaql97787531 := pn_hsucor;--
       Else
          lc_jaql97787531 := trim(pc_valact);--
       End If;      
    Else
      If pn_tipo2 <> 5 then
         lc_jaql97787516 := lc_idterm;    
      Else
         lc_jaql97787516 := trim(lc_valant);    
      End If;  
      -- agencia
      --lc_jaql97787531 := pn_hsucor;
       If pn_tipo2 = 3 Then  --corresponsal
          lc_jaql97787531 := TRIM(pc_cocom); 
       Elsif pn_tipo2 = 2 Then --atm
          lc_jaql97787531 := TRIM(lc_idterm);--
       Elsif pn_tipo2 = 1 Then --ventanilla
          lc_jaql97787531 := ln_hsucor;--
       Else
          lc_jaql97787531 := trim(lc_valact);--
       End If;           
    End If;          

       
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_ah_datos_comercio(pn_pgcod  => pn_pgcod,
                                                pn_hcmod  => pn_hcmod,
                                                pn_htran  => pn_htran,
                                                pc_idterm => pc_cocom,--pc_idterm, --ojoa cambiar en produccion!!!
                                                pc_nomcom => pc_nomcom,
                                                pc_dircom => pc_dircom,
                                                pc_telcom => pc_telcom,
                                                pc_locali => pc_locali1,
                                                pc_ruccom => lc_ruccom
                                                );
    end;   
   
    --nombre del comercio
    If pn_tipo2 = 3 Then
       lc_jaql97787518 := TRIM(pc_nomcom);
    ElsIf pn_tipo2 in (2,5) Then
       If lc_indoff = 'N' then   
          lc_jaql97787518 := substr(trim(pc_locali),1,40);--trim(pc_valant);
       Else
          lc_jaql97787518 := substr(trim(lc_locali),1,40);--trim(pc_valant);       
       End If;
    ElsIf pn_tipo2 = 1 Then
       lc_jaql97787518 := TRIM(fn_ah_desc_sucur(pn_pgcod,pn_hsucor));--desc agencia
    Else
       lc_jaql97787518 := null;    
    End If;   
       
    --localidad del comercio
    If lc_indoff = 'N' then  
       lc_jaql97787528 := substr(trim(pc_locali),1,13);
    Else
       lc_jaql97787528 := substr(trim(lc_locali),1,13);    
    End If;
    
    lc_jaql97787519 := 'PER';    
    
    --moneda de la operacion trx
    If ln_monope = 0 Then
      ln_jaql97787547 := 604;
    Else
      ln_jaql97787547 := 840;
    End If;
    --moneda de la cuenta
    If pn_moncta = 0 Then
      ln_jaql97787548 := 604;
    Else
      ln_jaql97787548 := 840;
    End If;    
    
    
    --bin
    lc_jaql97787535 := '426153';    
    -- tipo documento
    ln_jaql97787554 := ln_tipo;
    -- codigo cliente
    lc_jaql97787524 := '604'||LPAD(ln_tipo,3,'0')||TRIM(lc_numero);
    
    ln_jaql97787564 := 604; 
    ln_jaql97787544 := 604; 

    -- organizacion
    lc_jaql97787580 := '604803';    
    
    -- datos del titular de la tarjeta    
    lc_jaql97787583 := ln_suctar;
    lc_jaql97787536 := substr(lc_loccli,1,13);
    lc_jaql97787575 := lc_prinom;
    lc_jaql97787576 := lc_segnom;
    lc_jaql97787577 := lc_priape;
    lc_jaql97787578 := lc_segape;
    
    lc_jaql97787584 := lc_numero;
    
    ln_jaql97787589 := to_number(substr(ln_telfij,1,12));
    ln_jaql97787590 := null;
    ln_jaql97787591 := to_number(substr(ln_telcel,1,12));
    
    If lc_indoff = 'N' then      
        PQ_OP_ASIENTOS_MPLUS.sp_ah_estado_ope(pn_pgcod  => pn_pgcod,
                                              pn_hcmod  => pn_modulo,
                                              pn_hcmda  => pn_moncta,
                                              pn_hccta  => pn_ctacli,
                                              pn_hsbop  => pn_subope,
                                              pn_operac => pn_operac,
                                              pd_fecpro => pd_fecpro,
                                              pn_estado => lc_jaql97787552,
                                              pn_saldo  => ln_jaql97787527,
                                              pn_tipop  => ln_tipope                                              
                                              );
    Else
       --rutina para calcular el saldo offline
       
        PQ_OP_ASIENTOS_MPLUS.sp_ah_estado_ope(pn_pgcod  => ln_pgcod,
                                              pn_hcmod  => pn_modulo,
                                              pn_hcmda  => pn_moncta,
                                              pn_hccta  => pn_ctacli,
                                              pn_hsbop  => pn_subope,
                                              pn_operac => pn_operac,
                                              pd_fecpro => pd_fecpro,
                                              pn_estado => lc_jaql97787552,
                                              pn_saldo  => ln_jaql97787527,
                                              pn_tipop  => ln_tipope                                              
                                              );   
      -- obtenemos el monto de movimientos realzados en el offline                                               
      ln_totmov := pq_op_asientos_mplus.fn_ah_tot_movimientos_off(pc_numtar => lc_numtar,
                                                                  pd_fecpro => pd_fecpro,
                                                                  pn_moncta => pn_moncta
                                                                  );   
      ln_jaql97787527 := ln_jaql97787527 - ln_totmov;                                                                    
      
    End If;                                                                                                
    
    lc_jaql97787712 := 'N';
    lc_jaql97787713 := 'N'; 
    lc_jaql97787714 := 'N'; 
    
    -- concatenamos el producto
    If pn_modulo = 21 Then
       lc_cuenta := lpad(pn_ctacli,9,'0')||lpad(pn_modulo,3,'0')||lpad(pn_moncta,3,'0')||lpad(pn_subope,2,'0')||lpad(ln_tipope,3,'0');
    ElsIf pn_modulo = 22 Then
       lc_cuenta := lpad(pn_ctacli,9,'0')||lpad(pn_modulo,3,'0')||lpad(pn_moncta,3,'0')||lpad(pn_operac,9,'0')||lpad(ln_tipope,3,'0');
    Else
       lc_cuenta := null;
    End If;
    --UTILIZAMOS EL CAMPO  JAQL977
    LC_JAQL97787716 := lc_cuenta;
    
    If ln_valida = 2 and pn_hcmod < 500 Then
        If lc_indoff = 'N' Then
          begin
            -- Call the procedure
            pq_op_asientos_mplus.sp_ah_datos_trx_ori(pn_pgcod  => pn_pgcod,
                                                     pn_hcmod  => pn_hcmod,
                                                     pn_hsucor => pn_hsucor,
                                                     pn_htran  => pn_htran,
                                                     pn_hnrel  => pn_hnrel,
                                                     pd_fecpro => pd_fecpro,
                                                     pc_numtar => lc_numtar,
                                                     pc_jaql97787516 => lc_jaql97787516,
                                                     pc_jaql97787531 => lc_jaql97787531,
                                                     pc_jaql97787528 => lc_jaql97787528,
                                                     pc_jaql97787518 => lc_jaql97787518,
                                                     pn_traori =>  ln_htran
                                                     );
          end;
          lc_modtra := lpad(pn_hcmod,3,'0')||lpad(ln_htran,3,'0');   --87750  
        Else
          begin
            -- Call the procedure
            pq_op_asientos_mplus.sp_ah_trx_ori_off(pn_hcmod => ln_hcmod,
                                                   pn_htran => ln_htran,
                                                   pn_tiptr => ln_valida,
                                                   pn_hcmod_ori => ln_hcmod,
                                                   pn_htran_ori => ln_htran);
           lc_modtra := lpad(ln_hcmod,3,'0')||lpad(ln_htran,3,'0');   --87750                                                   
          end;
        End If;
        
        lc_jaql97787550 := lc_modtra;
    End If;
    
    
    if pn_ctacli <> 0 and pn_ctacli is not null then
      
    insert into JAQL977
      (
      jaql977cor, 
      jaql977bytei, 
      jaql977cons, 
      jaql977fdia,
      jaql977fmes,
      jaql977fani, 
      jaql977hora,
      jaql977min,     
      jaql977cod,       
      jaql977use,      
      jaql97787549, 
      jaql97787642,
      jaql97787550,
      jaql97787502,
      jaql97787503,
      jaql97787504,
      jaql97787560,
      jaql97787505,
      jaql97787506, 
      jaql97787507,  
      jaql97787508,
      jaql97787510,
      jaql97787543,
      jaql97787511,
      JAQL97787579,
      jaql97787512,
      jaql97787513,
      jaql97787546,
      jaql97787633,
      jaql97787514,           
      jaql97787515,            
      jaql97787562,
      jaql97787516,
      jaql97787531,
      jaql97787528, 
      jaql97787519,
      jaql97787547,
      jaql97787535,
      jaql97787554,      
      jaql97787524,
      jaql97787862,
      jaql977bytef,
      jaql97787564, 
      jaql97787544,
      jaql97787518,
      jaql97787548,
      jaql97787580,
      jaql97787583,       
      jaql97787536,      
      jaql97787575,
      jaql97787576,    
      jaql97787577,       
      jaql97787578,            
      jaql97787584,             
      jaql97787589,       
      jaql97787590,       
      jaql97787591,             
      jaql97787552,       
      jaql97787712,       
      jaql97787713,       
      jaql97787714,
      jaql97787527,
      JAQL97787716,
      JAQL977SUC, -- RCUADROS 2025.02.24
      JAQL977MOD,
      JAQL977TRA,
      JAQL977REL,
      JAQL977FCO
      )
   values
      ( pn_cor, 
        lc_jaql977bytei, 
        lc_jaql977cons,
        ln_jaql977fdia,
        ln_jaql977fmes,
        ln_jaql977fani, 
        ln_jaql977hora,
        ln_jaql977min,                 
        lc_jaql977cod,         
        lc_jaql977use, 
        lc_jaql97787549,
        lc_numtar,
        lc_jaql97787550,
        lc_jaql977rev,
        ln_jaql97787503,
        ln_jaql97787504,
        to_number(to_char(trunc(sysdate),'rrrrmmdd')||replace(pc_hora,':','')),--aqui   ln_jaql97787560     
        ln_jaql97787505,
        ln_jaql97787506, 
        to_number(to_char(trunc(sysdate),'rrrrmmdd')),--aqui   ln_jaql97787507     
        ln_jaql97787508,
        ln_jaql97787510, --MMC
        ln_jaql97787543,
        lc_jaql97787511,
        lc_JAQL97787579,
        ln_jaql97787512,
        ln_jaql97787513,
        ln_jaql97787546,
        ln_jaql97787633,        
        ln_jaql97787514,
        lc_jaql97787515,        
        lc_jaql97787562,
        lc_jaql97787516,
        lc_jaql97787531,
        lc_jaql97787528, 
        lc_jaql97787519,    
        ln_jaql97787547,
        lc_jaql97787535,
        ln_jaql97787554,
        lc_jaql97787524,
        lc_numtar, 
        lc_jaql977bytef,
        ln_jaql97787564, 
        ln_jaql97787544,
        lc_jaql97787518,
        ln_jaql97787548,
        lc_jaql97787580,
        
        lc_jaql97787583,       
        lc_jaql97787536,       
        lc_jaql97787575,       
        lc_jaql97787576,       
        lc_jaql97787577,       
        lc_jaql97787578,            
        lc_jaql97787584,             
        ln_jaql97787589,      
        ln_jaql97787590,       
        ln_jaql97787591,             
        lc_jaql97787552,       
        lc_jaql97787712,       
        lc_jaql97787713,       
        lc_jaql97787714,
        ln_jaql97787527,
        LC_JAQL97787716,
        pn_hcmod, -- RCUADROS 2025.02.24
        pn_hsucor,
        pn_htran,
        pn_hnrel,
        pd_fecpro
      );
     
      End If;
   /*
    insert into JAQL977
      (
      jaql977cor, 
      jaql977bytei, 
      jaql977cons, 
      jaql977fdia, 
      jaql977fmes, 
      jaql977fani, 
      jaql977hora, 
      jaql977min, 
      jaql977cod, 
      jaql977use, 
      jaql97787549, 
      jaql97787642, 
      jaql97787550, 
      jaql97787501, 
      jaql97787502, 
      jaql97787503, 
      jaql97787504, 
      jaql97787553, 
      jaql97787560, 
      jaql97787561, 
      jaql97787505, 
      jaql97787506, 
      jaql97787507, 
      jaql97787508, 
      jaql97787606, 
      jaql97787509, 
      jaql97787563, 
      jaql97787510, 
      jaql97787543, 
      jaql97787564, 
      jaql97787544, 
      jaql97787511, 
      jaql97787579, 
      jaql97787545, 
      jaql97787512, 
      jaql97787513, 
      jaql97787546, 
      jaql97787558, 
      jaql97787633, 
      jaql97787514, 
      jaql97787515, 
      jaql97787562, 
      jaql97787529, 
      jaql97787516, 
      jaql97787531, 
      jaql97787518, 
      jaql97787607, 
      jaql97787528, 
      jaql97787519, 
      jaql97787530, 
      jaql97787537, 
      jaql97787631, 
      jaql97787632, 
      jaql97787567, 
      jaql97787520, 
      jaql97787525, 
      jaql97787547, 
      jaql97787548, 
      jaql97787527, 
      jaql97787568, 
      jaql97787569, 
      jaql97787570, 
      jaql97787571, 
      jaql97787572, 
      jaql97787595, 
      jaql97787654, 
      jaql97787655, 
      jaql97787762, 
      jaql97787763, 
      jaql97787580, 
      jaql97787535, 
      jaql97787521, 
      jaql97787522, 
      jaql97787523, 
      jaql97787581, 
      jaql97787582, 
      jaql97787583, 
      jaql97787536, 
      jaql97787554, 
      jaql97787524, 
      jaql97787575, 
      jaql97787576, 
      jaql97787577, 
      jaql97787578, 
      jaql97787584, 
      jaql97787585, 
      jaql97787586, 
      jaql97787587, 
      jaql97787588, 
      jaql97787589, 
      jaql97787590, 
      jaql97787591, 
      jaql97787552, 
      jaql97787555, 
      jaql97787557, 
      jaql97787559, 
      jaql97787601, 
      jaql97787602, 
      jaql97787645, 
      jaql97787646, 
      jaql97787647, 
      jaql97787648, 
      jaql97787635, 
      jaql97787636, 
      jaql97787637, 
      jaql97787608, 
      jaql97787605, 
      jaql97787693, 
      jaql97787694, 
      jaql97787651, 
      jaql97787652, 
      jaql97787653, 
      jaql97787712, 
      jaql97787713, 
      jaql97787714, 
      jaql97787715, 
      jaql97787716, 
      jaql97787853, 
      jaql97787854, 
      jaql97787855, 
      jaql97787856, 
      jaql97787857, 
      jaql97787858, 
      jaql97787859, 
      jaql97787860, 
      jaql97787862, 
      jaql977bytef
      )
   values
      ( pn_cor, 
        lc_jaql977bytei, 
        lc_jaql977cons, 
        ln_jaql977fdia, 
        ln_jaql977fmes, 
        ln_jaql977fani, 
        jaql977hora, 
        jaql977min, 
        lc_jaql977cod, 
        lc_jaql977use, 
        jaql97787549, 
        lc_numtar, 
        jaql97787550, 
        jaql97787501, 
        ln_jaql977rev, 
        jaql97787503, 
        jaql97787504, 
        jaql97787553, 
        jaql97787560, 
        jaql97787561, 
        ln_jaql97787505, 
        jaql97787506, 
        jaql97787507, 
        jaql97787508, 
        jaql97787606, 
        jaql97787509, 
        jaql97787563, 
        jaql97787510, 
        jaql97787543, 
        jaql97787564, 
        jaql97787544, 
        jaql97787511, 
        jaql97787579, 
        jaql97787545, 
        jaql97787512, 
        jaql97787513, 
        jaql97787546, 
        jaql97787558, 
        jaql97787633, 
        jaql97787514, 
        jaql97787515, 
        jaql97787562, 
        jaql97787529, 
        jaql97787516, 
        jaql97787531, 
        jaql97787518, 
        jaql97787607, 
        jaql97787528, 
        jaql97787519, 
        jaql97787530, 
        jaql97787537, 
        jaql97787631, 
        jaql97787632, 
        jaql97787567, 
        jaql97787520, 
        jaql97787525, 
        jaql97787547, 
        jaql97787548, 
        jaql97787527, 
        jaql97787568, 
        jaql97787569, 
        jaql97787570, 
        jaql97787571, 
        jaql97787572, 
        jaql97787595, 
        jaql97787654, 
        jaql97787655, 
        jaql97787762, 
        jaql97787763, 
        jaql97787580, 
        jaql97787535, 
        jaql97787521, 
        jaql97787522, 
        jaql97787523, 
        jaql97787581, 
        jaql97787582, 
        jaql97787583, 
        jaql97787536, 
        jaql97787554, 
        jaql97787524, 
        jaql97787575, 
        jaql97787576, 
        jaql97787577, 
        jaql97787578, 
        jaql97787584, 
        jaql97787585, 
        jaql97787586, 
        jaql97787587, 
        jaql97787588, 
        jaql97787589, 
        jaql97787590, 
        jaql97787591, 
        jaql97787552, 
        jaql97787555, 
        jaql97787557, 
        jaql97787559, 
        jaql97787601, 
        jaql97787602, 
        jaql97787645, 
        jaql97787646, 
        jaql97787647, 
        jaql97787648, 
        jaql97787635, 
        jaql97787636, 
        jaql97787637, 
        jaql97787608, 
        jaql97787605, 
        jaql97787693, 
        jaql97787694, 
        jaql97787651, 
        jaql97787652, 
        jaql97787653, 
        jaql97787712, 
        jaql97787713, 
        jaql97787714, 
        jaql97787715, 
        jaql97787716, 
        jaql97787853, 
        jaql97787854, 
        jaql97787855, 
        jaql97787856, 
        jaql97787857, 
        jaql97787858, 
        jaql97787859, 
        jaql97787860, 
        lc_numtar, 
        lc_jaql977bytef
      );

               
 
*/

 
 end sp_op_carga_JAQL977;
 procedure sp_op_carga_JAQL978(pn_cor in number, --numero correlativo
                               pd_fecpro in date,
                               pc_hora   in varchar2,
                               pc_codrec in varchar2,
                               pn_numrec in number,
                               pd_fecreg in date, 
                               pd_fecsol in date,
                               pc_usureg in varchar2,
                               pc_ususol in varchar2,
                               pc_numero in varchar2,
                               pc_detrec in varchar2,
                               pc_canrec in number,
                               pc_solrec in varchar2                               
                              ) is          
  lc_JAQL978BYTEI jaql976.JAQL976BYTEI%type := 'ByteI';
  lc_JAQL978CONS  jaql976.JAQL976CONS%type  := 'N';
  lc_JAQL978BYTEF jaql976.JAQL976BYTEF%type := 'ByteF';
  lc_jaql978cod   jaql976.jaql976cod%type   := '08765'; --constante 
  lc_jaql978use   jaql976.jaql976use%type;
  
  ln_JAQL978FDIA  jaql976.JAQL976FDIA%type; 
  ln_JAQL978FMES  jaql976.JAQL976FMES%type; 
  ln_JAQL978FANI  jaql976.JAQL976FANI%type;
  ln_JAQL978HORA  jaql976.JAQL976HORA%type; 
  ln_JAQL978MIN   jaql976.JAQL976MIN%type; 
  ln_sucreg number(3); 
  ln_cor number(18);
  ln_cont number(10);
  --lc_error varchar2(400);
  
  CURSOR C_RECLAMOS(pc_codrec in varchar2) IS
  select a.jaql480sccta,
         a.jaql480nutar,
         a.jaql480aux05,
         a.jaql480femov,
         a.jaql480hora,
         a.jaql480monto
    from jaql480 a 
   where a.jaql480corec = RPAD(pc_codrec, 20, ' ')
     and a.jaql480aux07 = 1;
   
   
 begin
  
   --dia
   ln_jaql978fdia := to_number(to_char(pd_fecpro,'dd'));   
   --mes
   ln_jaql978fmes := to_number(to_char(pd_fecpro,'mm'));
   --año
   ln_jaql978fani := to_number(to_char(pd_fecpro,'yyyy'));
   --hora
   ln_jaql978hora := to_number(substr(pc_hora,1,2));
   --minuto
   ln_jaql978min  := to_number(substr(pc_hora,4,2));
   
   --usuario
   lc_jaql978use := pc_ususol;

   -- sucursal usuario registro
   
    begin
      select ubsuc
        into ln_sucreg
        from fst046
       where ubuser = rpad(pc_usureg,10,' ');
    Exception
    When others then
       ln_sucreg := 0;
    end;
   
      ---insercion
  ln_cont := 0;
   for i in c_reclamos (pc_codrec) loop
     ln_cont := ln_cont + 1;
     
     if ln_cont = 1 Then
        ln_cor := pn_cor;
     Else
        select SEQ_JAQL977A.NEXTVAL INTO ln_cor from DUAL;
     End If;
   
          insert into JAQL978
            (
              JAQL978COR  ,
              JAQL978BYTEI,     
              JAQL978CONS ,    
              JAQL978FDIA ,   
              JAQL978FMES ,      
              JAQL978FANI ,      
              JAQL978HORA ,      
              JAQL978MIN  ,      
              JAQL978COD  ,      
              JAQL978USE  ,      
              JAQL97887871,      
              JAQL97887872,      
              JAQL97887873,      
              JAQL97887874,      
              JAQL97887875,            
              JAQL97887877,      
              JAQL97887878,                       
              JAQL97887881,      
              JAQL97887882,      
              JAQL97887883,      
              JAQL97887884,      
              JAQL97887885,      
              JAQL97887886,      
              JAQL97887887,      
              JAQL97887888,      
              JAQL97887889,      
              JAQL97887890,      
              JAQL97887891,      
              JAQL97887892,                   
              JAQL97887894,                    
              JAQL978BYTEF      
            )
         values
            (ln_cor,
            lc_JAQL978BYTEI,
            lc_JAQL978CONS,
            ln_jaql978fdia,
            ln_jaql978fmes,
            ln_jaql978fani,
            ln_jaql978hora,
            ln_jaql978min,    
            lc_jaql978cod,
            lc_jaql978use,
            pc_codrec,
            pn_numrec,
            pc_usureg,
            ln_sucreg,
            to_number(TO_CHAR(pd_fecreg,'rrrrmmdd')),
            substr(pc_detrec,1,200),
            pc_canrec,
            8750,
            pc_numero,
            i.jaql480sccta||'/'||trim(i.jaql480nutar)||'/'||trim(i.jaql480aux05),
            to_number(TO_CHAR(i.jaql480femov,'rrrrmmdd')),
            to_number(replace(i.jaql480hora,':','')),
            i.jaql480monto,
            pn_cor,
            '000',
            1,
            1,
            substr(pc_solrec,1,200),
            pc_ususol,
            to_number(TO_CHAR(pd_fecsol,'rrrrmmdd')),
            lc_JAQL978BYTEF            
                        );
    end loop;    
 exception          
 when others then
 --lc_error := sqlerrm;
 null;
 end sp_op_carga_JAQL978; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   procedure sp_op_registra_JAQL977A(pn_pgcod  in number, 
                                     pn_hcmod  in number,
                                     pn_hsucor in number,
                                     pn_htran  in number,
                                     pn_hnrel  in number,         
                                     pd_fecpro in date,
                                     pc_uing   in varchar2,
                                     pc_hora   in varchar2,
                                     pc_cont   in varchar2,
                                     pn_corr   in number,
                                     pn_pais   in number,
                                     pn_tipo   in number,
                                     pc_numero in varchar2,
                                     pc_valant in varchar2,
                                     pc_valact in varchar2                                     
                                    ) IS

  LN_SECUENCIA NUMBER(15);
  ln_valida number := 0;
  lc_numtar varchar2(65);
  --lc_error varchar2(400);
  lc_usuario varchar2(10);
  pn_hcmod_o  number(3);
  pn_hnrel_o  number(4);  
  pd_fecpro_o date; 
  lc_offline CHAR(1) := 'N';
  pn_numchq fsd016.itcheq%type;
  
  ln_pgcod   number := 0;
  ln_hcmod   number := 0;
  ln_hsucor  number := 0;
  ln_htran   number := 0;
  ln_hnrel   number:=0;
  pn_tipo1 number;
  pn_tipo2 number;
  
  pn_monto  number(12,2):=0;
  pn_ctacli number(9);
  pn_modulo number(3); 
  pn_moncta fsd016.moneda%type;
  pn_operac fsd016.itoper%type; 
  pn_subope fsd016.itsubo%type;
  pn_tipope fsd016.ittope%type;
  pn_codord fsd016.itord%type;
  pn_monope  number; 
  pn_sucurs fsd016.itsucd%type;
  ln_tipmon number := 0;
  ln_null   number;
   
  BEGIN
  
  If pn_pgcod = 0 and  pn_pais = 1 then --es offline
     
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_trx_offline(pn_codtra => pn_tipo, --ahi viene el codtra para offline
                                               pd_fecpro => pd_fecpro,
                                               pc_numtar => pc_cont,
                                               pn_pgcod  => ln_pgcod,
                                               pn_hcmod  => ln_hcmod,
                                               pn_hsucor => ln_hsucor,
                                               pn_htran  => ln_htran,
                                               pn_hnrel  => ln_hnrel
                                               );
      end;  
      begin
            -- Call the procedure
            pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => ln_pgcod,
                                                 pn_hcmod => ln_hcmod,
                                                 pn_htran => ln_htran,
                                                 pn_tipo1 => pn_tipo1,
                                                 pn_tipo2 => pn_tipo2
                                                 );
      end;    
  
  
     lc_offline := 'S';    
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_valida_trx(pn_pgcod  => ln_pgcod,
                                              pn_hcmod  => ln_hcmod,
                                              pn_htran  => ln_htran,
                                              pn_indvig => ln_valida,
                                              pn_tipmon => ln_null
                                              );
      end;        
     
  Else  
      begin
            -- Call the procedure
            pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => pn_pgcod,
                                                 pn_hcmod => pn_hcmod,
                                                 pn_htran => pn_htran,
                                                 pn_tipo1 => pn_tipo1,
                                                 pn_tipo2 => pn_tipo2
                                                 );
      end;      
  
     lc_offline := 'N';
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_valida_trx(pn_pgcod  => pn_pgcod,
                                              pn_hcmod  => pn_hcmod,
                                              pn_htran  => pn_htran,
                                              pn_indvig => ln_valida,
                                              pn_tipmon => ln_tipmon
                                              );
      end;        
  End If;
  
    
  
  If pn_hcmod <> 800 Then
      If pn_hcmod >= 500 then 
          pq_op_asientos_mplus.sp_ah_trx_ori(pn_pgcod    => pn_pgcod,
                                             pn_hcmod    => pn_hcmod,
                                             pn_hsucor   => pn_hsucor,
                                             pn_htran    => pn_htran,
                                             pn_hnrel    => pn_hnrel,
                                             pd_fecpro   => pd_fecpro,
                                             pn_hcmod_o  => pn_hcmod_o,
                                             pn_hnrel_o  => pn_hnrel_o,
                                             pd_fecpro_o => pd_fecpro_o
                                            );
      lc_numtar := pq_op_asientos_mplus.fn_ah_numtarjeta(pn_pgcod  => pn_pgcod,
                                                         pn_hcmod  => pn_hcmod_o,
                                                         pn_hsucor => pn_hsucor,
                                                         pn_htran  => pn_htran,
                                                         pn_hnrel  => pn_hnrel_o,
                                                         pd_fecpro => pd_fecpro_o
                                                         );        
      
      Else
          If lc_offline = 'S' Then
             lc_numtar := pc_cont;  -- pn_pais ahi vienne la tarjeta para trx offline
          Else
            lc_numtar := pq_op_asientos_mplus.fn_ah_numtarjeta(pn_pgcod  => pn_pgcod,
                                                               pn_hcmod  => pn_hcmod,
                                                               pn_hsucor => pn_hsucor,
                                                               pn_htran  => pn_htran,
                                                               pn_hnrel  => pn_hnrel,
                                                               pd_fecpro => pd_fecpro
                                                               );                            
          End If;                                                                                            
      End IF;                                                         
   End If;
  
  If ln_valida <> 0 /*and (lc_numtar is not null  or  pn_hcmod = 800) */ Then
          
          If pn_hcmod = 140 Then
             lc_usuario := 'HB01';     
          Else
             lc_usuario := pc_uing;   
          End If;
                
          
          select SEQ_JAQL977A.NEXTVAL INTO LN_SECUENCIA from DUAL;
                     begin
                       insert into JAQL977A
                          (
                          jaql977acor,
                          jaql977acod,
                          jaql977asuc,
                          jaql977amod,
                          jaql977atran,
                          jaql977anrel,
                          jaql977afcon,
                          jaql977auing,
                          jaql977ahora,
                          jaql977acont,
                          JAQL977acorr
                          )
                       values
                          (LN_SECUENCIA,
                           decode(pn_pgcod,0,ln_pgcod,pn_pgcod),
                           decode(pn_hsucor,0,ln_hsucor,pn_hsucor),
                           decode(pn_hcmod,0,ln_hcmod,pn_hcmod),
                           decode(pn_htran,0,ln_htran,pn_htran),
                           decode(pn_hnrel,0,ln_hnrel,pn_hnrel),
                           pd_fecpro,
                           lc_usuario,--pc_uing,
                           pc_hora,
                           case
                           when pn_tipo2 in (2,5)then
                                decode(pn_pais,1,'S','N')
                           Else
                               'S' 
                           End,      
                           pn_corr
                           );
                     Exception
                     When others then 
                         null;
                         --LC_ERROR := SQLERRM;
                     End;
                     
                    -- 
                    --antifraude externo
                    --                     
                     If pn_hcmod = 800 and pn_htran between 100 and 199  and ln_tipmon = 1 Then--bloqueo activacion tarjeta direccion telefono etc.
                       -- REGISTRA TABLA DE NOVEDADES 
                          -- Call the procedure
                          pq_op_asientos_mplus.sp_op_carga_jaql976(pn_cor    => LN_SECUENCIA,
                                                                   pn_pgcod  => pn_pgcod,
                                                                   pn_hcmod  => pn_hcmod,
                                                                   pn_hsucor => pn_hsucor,
                                                                   pn_htran  => pn_htran,
                                                                   pn_hnrel  => pn_hnrel,
                                                                   pd_fecpro => pd_fecpro,
                                                                   pc_uing   => lc_usuario,--pc_uing,
                                                                   pc_hora   => pc_hora,
                                                                   pn_pais   => pn_pais,
                                                                   pn_tipo   => pn_tipo,
                                                                   pc_numero => pc_numero,
                                                                   pc_valant => pc_valant, 
                                                                   pc_valact => pc_valact                                                            
                                                                   );               
                     End IF;
                     
                     If pn_hcmod = 800 and pn_htran between 200 and 299 and ln_tipmon = 1 Then --registro de corresponsal y ATM

                            pq_op_asientos_mplus.sp_op_carga_jaql979(pn_cor    => LN_SECUENCIA,
                                                                     pn_pgcod  => pn_pgcod,
                                                                     pn_hcmod  => pn_hcmod,
                                                                     pn_hsucor => pn_hsucor,
                                                                     pn_htran  => pn_htran,
                                                                     pn_hnrel  => pn_hnrel,
                                                                     pd_fecpro => pd_fecpro,
                                                                     pc_uing   => lc_usuario,--pc_uing,
                                                                     pc_hora   => pc_hora,
                                                                     pn_pais   => pn_pais,
                                                                     pn_tipo   => pn_tipo,
                                                                     pc_numero => pc_numero,
                                                                     pc_valant => pc_valant, 
                                                                     pc_valact => pc_valact                                                            
                                                                     );              

                     End if;
                     
                     If pn_hcmod <> 800 and lc_numtar is not null and ln_tipmon in (1,3)  then
                       -- REGISTRA TRAMA DE DETALLE DE TRANSACCIONES  AHORROS Y DPFS            
                       begin
                          -- Call the procedure
                          pq_op_asientos_mplus.sp_op_carga_jaql977(pn_cor    => LN_SECUENCIA,
                                                                   pn_pgcod  => pn_pgcod,
                                                                   pn_hcmod  => pn_hcmod,
                                                                   pn_hsucor => pn_hsucor,
                                                                   pn_htran  => pn_htran,
                                                                   pn_hnrel  => pn_hnrel,
                                                                   pd_fecpro => pd_fecpro,
                                                                   pc_uing   => lc_usuario,--pc_uing,
                                                                   pc_hora   => pc_hora,
                                                                   pc_cont   => pc_cont,
                                                                   pn_corr   => pn_corr,
                                                                   pn_pais   => pn_pais,
                                                                   pn_tipo   => pn_tipo,
                                                                   pc_numero => pc_numero,
                                                                   pc_valant => pc_valant, 
                                                                   pc_valact => pc_valact,
                                                                   pc_numtar => lc_numtar                                                               
                                                                   );
                       end;
                     End If;   
                     
                     
                    -- 
                    --antifraude interno
                    --                                       
                    If ((pn_hcmod = 22 and pn_htran in (600,800) and lc_numtar is null) 
                        or 
                       (pn_hcmod = 800 and pn_htran = 400)) and ln_tipmon = 2
                    then --aperturas de ahorros y DPF
                        begin
                          -- Call the procedure
                          pq_op_asientos_mplus.sp_op_carga_jaql493(pn_cor    => LN_SECUENCIA,
                                                                   pn_pgcod  => pn_pgcod,
                                                                   pn_hcmod  => pn_hcmod,
                                                                   pn_hsucor => pn_hsucor,
                                                                   pn_htran  => pn_htran,
                                                                   pn_hnrel  => pn_hnrel,
                                                                   pd_fecpro => pd_fecpro,
                                                                   pc_uing   => lc_usuario,--pc_uing,
                                                                   pc_hora   => pc_hora,
                                                                   pc_cont   => pc_cont,
                                                                   pn_corr   => pn_corr,
                                                                   pn_pais   => pn_pais,
                                                                   pn_tipo   => pn_tipo,
                                                                   pc_numero => pc_numero,
                                                                   pc_valant => pc_valant, 
                                                                   pc_valact => pc_valact,
                                                                   pc_numtar => lc_numtar                                                               
                                                                   );
                        end;                           
                    End If;                    
                                        
                    If pn_hcmod = 800 and pn_htran between 500 and 599 and ln_tipmon = 2 then --novedades de productos ahorros y dpfs                    
                        begin
                          -- Call the procedure
                          pq_op_asientos_mplus.sp_op_carga_jaql494(pn_cor    => LN_SECUENCIA,
                                                                   pn_pgcod  => pn_pgcod,
                                                                   pn_hcmod  => pn_hcmod,
                                                                   pn_hsucor => pn_hsucor,
                                                                   pn_htran  => pn_htran,
                                                                   pn_hnrel  => pn_hnrel,
                                                                   pd_fecpro => pd_fecpro,
                                                                   pc_uing   => lc_usuario,--pc_uing,
                                                                   pc_hora   => pc_hora,
                                                                   pc_cont   => pc_cont,
                                                                   pn_corr   => pn_corr,
                                                                   pn_pais   => pn_pais,
                                                                   pn_tipo   => pn_tipo,
                                                                   pc_numero => pc_numero,
                                                                   pc_valant => pc_valant, 
                                                                   pc_valact => pc_valact,
                                                                   pc_numtar => lc_numtar                                                               
                                                                   );
                        end;                           
                    End If;  
                                        
                    If pn_hcmod <> 800 and ln_tipmon in (2,3) then                      
                        If lc_offline = 'N' Then
                                begin
                                  -- Call the procedure
                                  pq_op_asientos_mplus.sp_ah_datos_trx(pn_pgcod  => pn_pgcod,
                                                                       pn_hcmod  => pn_hcmod,
                                                                       pn_hsucor => pn_hsucor,
                                                                       pn_htran  => pn_htran,
                                                                       pn_hnrel  => pn_hnrel,
                                                                       pn_monto  => pn_monto,
                                                                       pn_ctacli => pn_ctacli,
                                                                       pn_modulo => pn_modulo,
                                                                       pn_moncta => pn_moncta,
                                                                       pn_subope => pn_subope,
                                                                       pn_operac => pn_operac,
                                                                       pn_tipope => pn_tipope,
                                                                       pn_sucurs => pn_sucurs,
                                                                       pn_numchq => pn_numchq,
                                                                       pn_codord => pn_codord
                                                                      );
                                end;      
                            Else
                                begin
                                  -- Call the procedure
                                  pq_op_asientos_mplus.sp_ah_datos_trx_off(pc_numtar => lc_numtar, --tarjeta
                                                                           pn_codtra => pn_tipo,  --codtra 
                                                                           pd_fecpro => pd_fecpro,
                                                                           pn_indtrx => ln_valida,
                                                                           pn_monto  => pn_monto,
                                                                           pn_ctacli => pn_ctacli,
                                                                           pn_modulo => pn_modulo,
                                                                           pn_moncta => pn_moncta,
                                                                           pn_subope => pn_subope,
                                                                           pn_operac => pn_operac,
                                                                           pn_tipope => pn_tipope,
                                                                           pn_sucurs => pn_sucurs,                                                                            
                                                                           pn_monope => pn_monope
                                                                          );
                                end;        
                            End If;
                       
                       if pn_modulo = 21  then --registro trx ahorros
                          begin
                            -- Call the procedure
                            pq_op_asientos_mplus.sp_op_carga_jaql495(pn_cor    => LN_SECUENCIA,
                                                                     pn_pgcod  => pn_pgcod,
                                                                     pn_hcmod  => pn_hcmod,
                                                                     pn_hsucor => pn_hsucor,
                                                                     pn_htran  => pn_htran,
                                                                     pn_hnrel  => pn_hnrel,
                                                                     pd_fecpro => pd_fecpro,
                                                                     pc_uing   => lc_usuario,--pc_uing,
                                                                     pc_hora   => pc_hora,
                                                                     pc_cont   => pc_cont,
                                                                     pn_corr   => pn_corr,
                                                                     pn_pais   => pn_pais,
                                                                     pn_tipo   => pn_tipo,
                                                                     pc_numero => pc_numero,
                                                                     pc_valant => pc_valant, 
                                                                     pc_valact => pc_valact,
                                                                     pc_numtar => lc_numtar                                                               
                                                                     );
                          end;                         
                       end if;   
                       if pn_modulo = 22 then  --registro trx plazo fijo
                          begin 
                            -- Call the procedure
                            pq_op_asientos_mplus.sp_op_carga_jaql496(pn_cor    => LN_SECUENCIA,
                                                                     pn_pgcod  => pn_pgcod,
                                                                     pn_hcmod  => pn_hcmod,
                                                                     pn_hsucor => pn_hsucor,
                                                                     pn_htran  => pn_htran,
                                                                     pn_hnrel  => pn_hnrel,
                                                                     pd_fecpro => pd_fecpro,
                                                                     pc_uing   => lc_usuario,--pc_uing,
                                                                     pc_hora   => pc_hora,
                                                                     pc_cont   => pc_cont,
                                                                     pn_corr   => pn_corr,
                                                                     pn_pais   => pn_pais,
                                                                     pn_tipo   => pn_tipo,
                                                                     pc_numero => pc_numero,
                                                                     pc_valant => pc_valant, 
                                                                     pc_valact => pc_valact,
                                                                     pc_numtar => lc_numtar                                                               
                                                                     );
                          end;                         
                       end if;                                                 
                    End If;  
                    
                    If pn_hcmod = 800 and pn_htran = 600 and ln_tipmon = 2 then --registro de solicitud de chequeras
                        begin
                          -- Call the procedure
                          pq_op_asientos_mplus.sp_op_carga_jaql497(pn_cor    => LN_SECUENCIA,
                                                                   pn_pgcod  => pn_pgcod,
                                                                   pn_hcmod  => pn_hcmod,
                                                                   pn_hsucor => pn_hsucor,
                                                                   pn_htran  => pn_htran,
                                                                   pn_hnrel  => pn_hnrel,
                                                                   pd_fecpro => pd_fecpro,
                                                                   pc_uing   => lc_usuario,--pc_uing,
                                                                   pc_hora   => pc_hora,
                                                                   pc_cont   => pc_cont,
                                                                   pn_corr   => pn_corr,
                                                                   pn_pais   => pn_pais,
                                                                   pn_tipo   => pn_tipo,
                                                                   pc_numero => pc_numero,
                                                                   pc_valant => pc_valant, 
                                                                   pc_valact => pc_valact,
                                                                   pc_numtar => lc_numtar                                                               
                                                                   );
                        end;                           
                    End If;                      

  End If;                                              
  
  Exception
    when others then
      --lc_error := sqlerrm;
      null;
  end sp_op_registra_JAQL977A;           
 procedure sp_op_carga_JAQL493(  pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pc_cont in varchar2,  --estado contable 
                                 pn_corr in number, --itcorr - (99-extornado)
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              ) is       

  vJAQL493CORR  NUMBER(18);
  vJAQL4933507  VARCHAR2(14);
  vJAQL4933533  NUMBER(8);
  vJAQL4933510  NUMBER(6);
  vJAQL4933532  VARCHAR2(1);
  vJAQL4933540  VARCHAR2(27);--25
  vJAQL4933502  VARCHAR2(2);
  vJAQL4933566  VARCHAR2(3);
  vJAQL4933505  NUMBER(5);
  vJAQL4933519  VARCHAR2(10);
  vJAQL4933518  VARCHAR2(20);
  vJAQL4933554  VARCHAR2(2);
  vJAQL4933523  VARCHAR2(40);
  vJAQL4933557  VARCHAR2(35);
  vJAQL4933558  VARCHAR2(12);
  vJAQL4933559  VARCHAR2(12);
  vJAQL4933560  VARCHAR2(12);
  vJAQL4933561  VARCHAR2(40);
  vJAQL4933620  NUMBER(4);
  vJAQL4933626  NUMBER(8);
  vJAQL4933627  VARCHAR2(30);
  vJAQL4933628  VARCHAR2(1);
  vJAQL4933629  VARCHAR2(1);
  vJAQL4933630  VARCHAR2(5);--OJO
  vJAQL4933536  VARCHAR2(12);
  vJAQL4933522  VARCHAR2(12);
  vJAQL4933506  VARCHAR2(30);
  vJAQL4933750  VARCHAR2(30);
  vJAQL4933752  NUMBER(14,2);
  vJAQL4933753  NUMBER(14,2);
  
  
  pn_monto  number(12,2):=0;
  pn_ctacli number(9);
  pn_modulo number(3); 
  
  pn_moncta fsd016.moneda%type;
  pn_subope fsd016.itsubo%type;           
  pn_operac fsd016.itoper%type;  
  pn_numchq fsd016.itcheq%type;
  
  --LN_PGCOD  FSD011.PGCOD%type;
  LN_SCSUC  FSD011.SCSUC%type;
  LN_SCMOD  FSD011.SCMOD%type;
  LN_SCMDA  FSD011.SCMDA%type;
  --LN_SCPAP  FSD011.SCPAP%type;
  LN_SCCTA  FSD011.SCCTA%type;
  LN_SCSBOP FSD011.SCSBOP%type;
  LN_SCOPER FSD011.SCOPER%type;
  LN_SCTOPE FSD011.SCTOPE%type;
  
  pn_petdoc fsr008.petdoc%type;
  pc_pendoc fsr008.pendoc%type;
  --lc_error varchar2(400); 
  pn_tipope fsd016.ittope%type;
  pn_codord fsd016.itord%type;
  pn_sucurs fsd016.itsucd%type;  
  
  lc_indtra char(1):='N';
  begin
      vJAQL493CORR := pn_cor;   
       
      begin
       select a.ubsuc 
         into ln_scsuc
         from fst046 a
        where a.pgcod = pn_pgcod 
          and a.ubuser= rpad(pc_uing,10,' ');
      exception
      when others then
         null;     
      end;
               
      If pn_hcmod <> 800 then   
      --datos basicos         
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trx(pn_pgcod  => pn_pgcod,
                                               pn_hcmod  => pn_hcmod,
                                               pn_hsucor => pn_hsucor,
                                               pn_htran  => pn_htran,
                                               pn_hnrel  => pn_hnrel,
                                               pn_monto =>  pn_monto,
                                               pn_ctacli => pn_ctacli,
                                               pn_modulo => pn_modulo,
                                               pn_moncta => pn_moncta,
                                               pn_subope => pn_subope,
                                               pn_operac => pn_operac,
                                               pn_tipope => pn_tipope,
                                               pn_sucurs => pn_sucurs,
                                               pn_numchq => pn_numchq,
                                               pn_codord => pn_codord
                                              );
        end;      
      Else       
          pn_modulo := 21;
          pn_moncta := to_number(substr(pc_numero,13,3));         
          pn_operac := 0;          
          pn_ctacli := to_number(substr(pc_numero,1,9));
          pn_subope := to_number(substr(pc_numero,10,3)); 
          pn_tipope := to_number(substr(pc_numero,16,3));                
      End If;
      
       --ln_pgcod  := pn_pgcod; 
       ln_scsuc  := ln_scsuc; 
       ln_scmod  := pn_modulo;  
       ln_scmda  := pn_moncta;  
       --ln_scpap  := 0;  
       ln_sccta  := pn_ctacli;  
       ln_scsbop := pn_subope;                                                  
       ln_scoper := pn_operac;                                                  
       ln_sctope := pn_tipope;                                                   
      
       --datos a llenar monitor
       
       --validacion de trabajador
       lc_indtra  := pq_op_asientos_mplus.fn_cl_es_trabajador(ln_sccta);
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_datos_jaql493(pn_ctacli     => pn_ctacli,
                                                 pn_petdoc     => pn_petdoc,
                                                 pc_pendoc     => pc_pendoc,
                                                 pc_petipo     => vJAQL4933532,
                                                 pc_ctnom      => vJAQL4933523,
                                                 pc_sngc13dir  => vJAQL4933557,
                                                 pc_dotelfp    => vJAQL4933558,
                                                 pc_dotelfp1   => vJAQL4933560,
                                                 pc_pextxt     => vJAQL4933561,
                                                 pn_jaql60cali => vJAQL4933620,
                                                 pn_pffnac     => vJAQL4933626,
                                                 pc_pflnac     => vJAQL4933627,
                                                 pc_pfcant     => vJAQL4933628,
                                                 pc_pfeciv     => vJAQL4933629,
                                                 pc_sngc60acte => vJAQL4933630
                                                 );
      Exception
      when others then
           --lc_error := sqlerrm;                                                        
           null;
      end;      
      vJAQL4933507:= lpad(trim(to_char(pn_petdoc)),3,'0') || lpad(trim(pc_pendoc),11,'0');
      vJAQL4933510:=  to_number(replace(pc_hora,':',''));    
      
      if ln_scmod = 21 then
         vJAQL4933540 := lpad(ln_sccta,9,'0')||lpad(ln_scmod,3,'0')||lpad(ln_scmda,3,'0')||lpad(ln_scsbop,2,'0')||lpad(ln_sctope,3,'0');
         vJAQL4933502 := to_char(ln_scmod);       
      else  
         vJAQL4933540 := lpad(ln_sccta,9,'0')||lpad(ln_scmod,3,'0')||lpad(ln_scmda,3,'0')||lpad(ln_scoper,9,'0')||lpad(ln_sctope,3,'0');                
         vJAQL4933502 := to_char(ln_scmod);
      End if;
      vJAQL4933566 := to_char(ln_sctope);
      vJAQL4933505 := ln_scsuc;
      vJAQL4933518 := pc_uing;
      vJAQL4933533 := to_number(to_char(pd_fecpro,'rrrrmmdd'));
      vJAQL4933522 := lpad(trim(pc_pendoc),12,'0'); 
      vJAQL4933519 := to_char(ln_scsuc);
      
      if lc_indtra = 'S' then  
          begin
            insert into JAQL493(jaql493corr,
                                jaql4933507,
                                jaql4933533,
                                jaql4933510,
                                jaql4933532,
                                jaql4933540,
                                jaql4933502,
                                jaql4933566,
                                jaql4933505,
                                jaql4933519,
                                jaql4933518,
                                jaql4933554,
                                jaql4933523,
                                jaql4933557,
                                jaql4933558,
                                jaql4933559,
                                jaql4933560,
                                jaql4933561,
                                jaql4933620,
                                jaql4933626,
                                jaql4933627,
                                jaql4933628,
                                jaql4933629,
                                jaql4933630,
                                jaql4933536,
                                jaql4933522,
                                jaql4933506,
                                jaql4933750,
                                jaql4933752,
                                jaql4933753
                                )
                         values(vJAQL493CORR,
                                vjaql4933507,
                                vjaql4933533,
                                vjaql4933510,
                                vjaql4933532,
                                vjaql4933540,
                                vjaql4933502,
                                vjaql4933566,
                                vjaql4933505,
                                vjaql4933519,
                                vjaql4933518,
                                vjaql4933554,
                                vjaql4933523,
                                vjaql4933557,
                                vjaql4933558,
                                vjaql4933559,
                                vjaql4933560,
                                vjaql4933561,
                                vjaql4933620,
                                vjaql4933626,
                                vjaql4933627,
                                vjaql4933628,
                                vjaql4933629,
                                vjaql4933630,
                                vjaql4933536,
                                vjaql4933522,
                                vjaql4933506,
                                vjaql4933750,
                                vjaql4933752,
                                vjaql4933753
                                );
          Exception
          When others then
            --lc_error := sqlerrm;                               
            null;
          end;
      end if;
  Exception
  When others then
    --lc_error := sqlerrm;   
    null;
  end sp_op_carga_JAQL493;           
  
 procedure sp_op_carga_JAQL494(  pn_cor    in number, --numero correlativo
                                 pn_pgcod  in number, --pgcod
                                 pn_hcmod  in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran  in number, --htran
                                 pn_hnrel  in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing   in varchar2, --usuario ingreso
                                 pc_hora   in varchar2, --hora
                                 pc_cont   in varchar2,  --estado contable 
                                 pn_corr   in number, --itcorr - (99-extornado)
                                 pn_pais   in number,
                                 pn_tipo   in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              ) is    
  vJAQL494CORR  NUMBER(18); 
  vJAQL4943522  VARCHAR2(12);
  vJAQL4943523  VARCHAR2(40);
  vJAQL4943540  VARCHAR2(27);--25
  vJAQL4943501  VARCHAR2(6);
  vJAQL4943503  VARCHAR2(3);
  vJAQL4943509  NUMBER(8); 
  vJAQL4943510  NUMBER(6); 
  vJAQL4943519  VARCHAR2(10);
  vJAQL4943518  VARCHAR2(20);
  vJAQL4943536  VARCHAR2(12);
  vJAQL4943502  VARCHAR2(2);
  vJAQL4943566  VARCHAR2(3);
  vJAQL4943556  VARCHAR2(15);
  vJAQL4943591  NUMBER(11); 
  vJAQL4943592  NUMBER(11); 
  vJAQL4943605  VARCHAR2(1);
  vJAQL4943517  VARCHAR2(1);
  vJAQL4943597  VARCHAR2(1);
  vJAQL4943521  NUMBER(14,2); 
  vJAQL4943515  VARCHAR2(1);
  vJAQL4943505  NUMBER(5); 
  vJAQL4943537  NUMBER(5); 
  vJAQL4943520  VARCHAR2(30);
  vJAQL4943600  VARCHAR2(45);
  vJAQL4943601  VARCHAR2(45);
  vJAQL4943607  VARCHAR2(3);
  vJAQL4943610  VARCHAR2(16);
  vJAQL4943587  VARCHAR2(1);
  vJAQL4943563  VARCHAR2(20);
  vJAQL4943514  NUMBER(8); 
  vJAQL4943614  VARCHAR2(4);
  vJAQL4943615  VARCHAR2(4);
  vJAQL4943534  VARCHAR2(15);
  vJAQL4943529  VARCHAR2(1);
  vJAQL4943530  NUMBER(3); 
  vJAQL4943645  NUMBER(2); 
  vJAQL4943646  NUMBER(6); 
  vJAQL4943507  VARCHAR2(14);
  vJAQL4943647  VARCHAR2(14);
  vJAQL4943533  NUMBER(8); 
  vJAQL4943506  VARCHAR2(30);
  vJAQL4943750  VARCHAR2(30);
  vJAQL4943752  NUMBER(14,2); 
  vJAQL4943753  NUMBER(14,2);       
  
  LN_PGCOD  FSD011.PGCOD%type;
  LN_SCSUC  FSD011.SCSUC%type;
  LN_SCMOD  FSD011.SCMOD%type;
  LN_SCMDA  FSD011.SCMDA%type;
  LN_SCPAP  FSD011.SCPAP%type;
  LN_SCCTA  FSD011.SCCTA%type;
  LN_SCSBOP FSD011.SCSBOP%type;
  LN_SCOPER FSD011.SCOPER%type;
  LN_SCTOPE FSD011.SCTOPE%type;
  
  ln_pais   fsr008.pepais%type;  
  ln_tipo   fsr008.petdoc%type;
  lc_docu   fsr008.pendoc%type;     
  ln_chetcn number;
  --lc_error varchar2(300);
  ln_tipope fsd011.sctope%type;     
  tasa      number(10,6):=0;
  
  lc_indtra char(1):='N';
                                  
  begin
  vJAQL494CORR := pn_cor;
    --datos de la cuenta
    if length(trim(substr(pc_valant,1,27))) < 27 then --ahorros
      LN_PGCOD  := pn_pgcod;
      LN_SCSUC  := to_number(pc_valact);
      LN_SCMOD  := to_number(substr(pc_valant,10,3));
      LN_SCMDA  := to_number(substr(pc_valant,13,3));
      LN_SCPAP  := 0;
      LN_SCCTA  := to_number(substr(pc_valant,1,9));
      LN_SCSBOP := to_number(substr(pc_valant,16,2));
      LN_SCOPER := 0;
      LN_SCTOPE := to_number(substr(pc_valant,18,3));
    Else
      LN_PGCOD  := pn_pgcod;
      LN_SCSUC  := to_number(pc_valact);
      LN_SCMOD  := to_number(substr(pc_valant,10,3));
      LN_SCMDA  := to_number(substr(pc_valant,13,3));
      LN_SCPAP  := 0;
      LN_SCCTA  := to_number(substr(pc_valant,1,9));
      LN_SCSBOP := nvl(to_number(pc_numero),0);
      LN_SCOPER := to_number(substr(pc_valant,16,9));
      LN_SCTOPE := to_number(substr(pc_valant,25,3));                  
    End if;

    --validacion de trabajador
    lc_indtra  := pq_op_asientos_mplus.fn_cl_es_trabajador(LN_SCCTA);
    
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_cl_cliente(pn_ctacli => LN_SCCTA,
                                         pn_pais   => ln_pais,
                                         pn_tipo   => ln_tipo,
                                         pc_numero => lc_docu,
                                         pc_nombre => vJAQL4943523
                                         );
    end;         

    vJAQL4943522 := /*lpad(trim(to_char(ln_tipo)),3,'0') || */lpad(trim(lc_docu),12,'0');
    vJAQL4943540 := substr(pc_valant,1,27);
    vJAQL4943501 := to_char(pn_hcmod)||to_char(pn_htran);
    vJAQL4943503 := '001'; --ventanilla
    vJAQL4943509 := to_number(to_char(pd_fecpro,'rrrrmmdd'));         
    vJAQL4943510 := to_number(replace(pc_hora,':',''));          
    vJAQL4943519 := pn_hsucor;
    vJAQL4943518 := pc_uing;
    vJAQL4943536 := null;
    vJAQL4943502 := to_char(LN_SCMOD); 
    vJAQL4943566 := to_char(LN_SCTOPE); 
    --vJAQL4943556 := pn_hsucor;
    vJAQL4943556 := trim(substr(pc_valant,28,15));
    
    If pn_htran = 502 then
      -- invocar rutira que obtienne estos valores de sch003 y fsd230
      --valor anterior y actual
      begin
        select a.sch002dsc
          into vJAQL4943600
          from sch002 a
         where a.sch002est = pn_tipo;
      exception   
      when others then
        vJAQL4943600 := null;     
      end; --anterior
      begin
        select a.sch002dsc
          into vJAQL4943601
          from sch002 a
         where a.sch002est = pn_pais;
      exception   
      when others then
        vJAQL4943601 := null;              
      end;--actual
      
      begin
         select nvl(REGEXP_COUNT(trim(a.chelst),'0'),0)
           into vJAQL4943646
           from fsd230 a 
          where a.checod = LN_PGCOD
            and a.checta = LN_SCCTA            
            and a.chemod = LN_SCMOD
            and a.chesuc = LN_SCSUC
            and a.chemda = LN_SCMDA
            and a.chepap = LN_SCPAP
            and a.cheope = LN_SCOPER
            and a.chesbo = LN_SCSBOP
            and a.chetop = LN_SCTOPE                   
            and nvl(REGEXP_COUNT(trim(a.chelst),'0'),0) > 0;          
      exception
      when others then
        vJAQL4943646 := 0;
      end;      
      
      begin
        select a.chetcn
          into ln_chetcn
          from fst231 a
         where a.chetpo = to_number(substr(pc_numero,6,3));         
      exception
      when others then   
        ln_chetcn := to_number(substr(pc_numero,1,5));
      end;
      vJAQL4943645 := round(to_number(substr(pc_numero,1,5))/ln_chetcn);               
      vJAQL4943591 := to_number(substr(pc_numero,9,9));
      vJAQL4943592 := to_number(substr(pc_numero,9,9)) + ln_chetcn - 1;
      vJAQL4943605 := to_number(substr(pc_numero,6,3));             
    Else
      vJAQL4943591 := '';
      vJAQL4943592 := '';
      vJAQL4943605 := '';
      vJAQL4943645 := '';
      vJAQL4943646 := '';      
     --valor anterior y actual
      If pn_htran = 503 then
         begin 
           select upper(a.cenom) 
             into vJAQL4943600 
             from fst026 a 
            where a.cecod = pn_pais;
         exception
         when others then
           vJAQL4943600 := null;
         end;
         begin 
           select upper(a.cenom) 
             into vJAQL4943601 
             from fst026 a 
            where a.cecod = pn_tipo;
         exception
         when others then
           vJAQL4943601 := null;
         end;                  
      end if;

      if pn_htran in (500,501) then
        
        if pn_pais = 0 then 
          begin
            --valor anterior y actual
            pq_op_asientos_mplus.sp_tasa(vpgcod  => LN_PGCOD,
                                         vscsuc  => LN_SCSUC,
                                         vsccta  => LN_SCCTA,
                                         vscmda  => LN_SCMDA,
                                         vscpap  => LN_SCPAP,
                                         vscoper => LN_SCOPER,
                                         vscsbop => LN_SCSBOP,
                                         vsctope => LN_SCTOPE,
                                         vscmod  => LN_SCMOD,
                                         tasa    => tasa);
            vJAQL4943600 := trim(to_char(tasa,'990.900000'));                                                     
          end;      
        else
          vJAQL4943600 := trim(to_char(pn_pais,'990.900000'));          
        end if;
        vJAQL4943601 := trim(to_char(pn_tipo,'990.900000'));
      End if;
    End If;

    PQ_OP_ASIENTOS_MPLUS.sp_ah_estado_ope(pn_pgcod  => LN_PGCOD,
                                          pn_hcmod  => LN_SCMOD,
                                          pn_hcmda  => LN_SCMDA,
                                          pn_hccta  => LN_SCCTA,
                                          pn_hsbop  => LN_SCSBOP, 
                                          pn_operac => LN_SCOPER,
                                          pd_fecpro => pd_fecpro,
                                          pn_estado => vJAQL4943517,
                                          pn_saldo  => vJAQL4943521,
                                          pn_tipop  => ln_tipope     --NO SE USA                                         
                                         );              
                                                                                  
   If LN_SCMOD = 21 Then 
           begin
            select sum(a.scsdo)
              into vJAQL4943521
              from fsd011 a
             where a.pgcod  = LN_PGCOD
               and a.scmda  = LN_SCMDA
               and a.scmod in (21,157,136)
               and a.sccta  = LN_SCCTA
               and a.scsuc  = LN_SCSUC
               and a.scsbop = LN_SCSBOP
               and a.scoper = LN_SCOPER
               and a.scpap  = LN_SCPAP;
           Exception
           When others then
             vJAQL4943521 := 0;
           End;            
           
           begin
            select a.scstat, to_number(to_char(a.scfval,'rrrrmmdd'))         
              into vJAQL4943517, vJAQL4943533
              from fsd011 a
             where a.pgcod  = LN_PGCOD
               and a.scmda  = LN_SCMDA
               and a.scmod  = LN_SCMOD
               and a.scsuc  = LN_SCSUC
               and a.sccta  = LN_SCCTA
               and a.scsbop = LN_SCSBOP
               and a.scoper = LN_SCOPER
               and a.scpap  = LN_SCPAP;
           Exception
           When others then
             vJAQL4943533 := null;
             vJAQL4943517 := 99;
           end;
           
    Else
           begin
            select sum(a.scsdo)            
              into vJAQL4943521
              from fsd011 a
             where a.pgcod  = LN_PGCOD
               and a.scmda  = LN_SCMDA
               and a.scsuc  = LN_SCSUC
               and a.scmod  in (22,426)
               and a.sccta  = LN_SCCTA
               and a.scoper = LN_SCOPER
               and a.scpap  = LN_SCPAP;
          Exception
          When others then      
               vJAQL4943521 := 0;       
          end;
          
          begin
            select to_number(to_char(min(a.aofval),'rrrrmmdd'))         
              into vJAQL4943533
              from fsd010 a
             where a.pgcod  = LN_PGCOD
               and a.aomda  = LN_SCMDA
               and a.aomod  = LN_SCMOD
               and a.aosuc  = LN_SCSUC
               and a.aocta  = LN_SCCTA
               and a.aooper = LN_SCOPER
               and a.aopap  = LN_SCPAP;                        
          Exception
          When others then
             vJAQL4943533 := null;
          end;          
   End If; 
    
    vJAQL4943597 := '+';
    
    -- es trabajador?
    vJAQL4943515 := pq_op_asientos_mplus.fn_cl_estrabajador(pn_pais   => ln_pais,
                                                            pn_tipo   => ln_tipo,
                                                            pc_numero => lc_docu
                                                            );    
    vJAQL4943505 := pn_hsucor;
    vJAQL4943537 := LN_SCSUC;
    
     begin
         select substr(b.locnom,1,30) 
           into vJAQL4943520
           from fst001 a,
                fst070 b
          where a.pgcod  = LN_PGCOD
            and b.pais   = 604
            and a.sucurs = pn_hsucor
            and a.scciud = b.loccod
            and a.scdept = b.depcod;        
     exception
     when others then
       vJAQL4943520 := null;
     end;        
    
    vJAQL4943607 := pn_htran;
    
    begin
      select substr(trim(a.ubnom),1,16) 
        into vJAQL4943610 
        from fst746 a 
       where a.ubuser = rpad(trim(pc_uing),10,' ');
    exception      
    when others then  
      vJAQL4943610 := null;
    end;

    vJAQL4943587 := null;
    
    vJAQL4943563 := to_char(pn_cor); --correaltivo unico
    vJAQL4943514 := null;
    vJAQL4943614 := null;
    vJAQL4943615 := null;
    vJAQL4943534 := null;
    vJAQL4943529 := '0';
    vJAQL4943530 := null;
    vJAQL4943507 := lpad(trim(to_char(ln_tipo)),2,'0') || lpad(trim(lc_docu),12,'0');
    vJAQL4943647 := lpad(trim(to_char(ln_tipo)),2,'0') || lpad(trim(lc_docu),12,'0');
    
    vJAQL4943506 := null;
    vJAQL4943750 := null;
    vJAQL4943752 := null;
    vJAQL4943753 := null;

    if lc_indtra = 'S' then
        begin
          insert into jaql494(JAQL494CORR,
                              JAQL4943522,
                              JAQL4943523,
                              JAQL4943540,
                              JAQL4943501,
                              JAQL4943503,
                              JAQL4943509,
                              JAQL4943510,
                              JAQL4943519,
                              JAQL4943518,
                              JAQL4943536,
                              JAQL4943502,
                              JAQL4943566,
                              JAQL4943556,
                              JAQL4943591,
                              JAQL4943592,
                              JAQL4943605,
                              JAQL4943517,
                              JAQL4943597,
                              JAQL4943521,
                              JAQL4943515,
                              JAQL4943505,
                              JAQL4943537,
                              JAQL4943520,
                              JAQL4943600,
                              JAQL4943601,
                              JAQL4943607,
                              JAQL4943610,
                              JAQL4943587,
                              JAQL4943563,
                              JAQL4943514,
                              JAQL4943614,
                              JAQL4943615,
                              JAQL4943534,
                              JAQL4943529,
                              JAQL4943530,
                              JAQL4943645,
                              JAQL4943646,
                              JAQL4943507,
                              JAQL4943647,
                              JAQL4943533,
                              JAQL4943506,
                              JAQL4943750,
                              JAQL4943752,
                              JAQL4943753
                             )
                      values(vJAQL494CORR,
                             vJAQL4943522,
                             vJAQL4943523,
                             vJAQL4943540,
                             vJAQL4943501,
                             vJAQL4943503,
                             vJAQL4943509,
                             vJAQL4943510,
                             vJAQL4943519,
                             vJAQL4943518,
                             vJAQL4943536,
                             vJAQL4943502,
                             vJAQL4943566,
                             vJAQL4943556,
                             vJAQL4943591,
                             vJAQL4943592,
                             vJAQL4943605,
                             vJAQL4943517,
                             vJAQL4943597,
                             vJAQL4943521,
                             vJAQL4943515,
                             vJAQL4943505,
                             vJAQL4943537,
                             vJAQL4943520,
                             vJAQL4943600,
                             vJAQL4943601,
                             vJAQL4943607,
                             vJAQL4943610,
                             vJAQL4943587,
                             vJAQL4943563,
                             vJAQL4943514,
                             vJAQL4943614,
                             vJAQL4943615,
                             vJAQL4943534,
                             vJAQL4943529,
                             vJAQL4943530,
                             vJAQL4943645,
                             vJAQL4943646,
                             vJAQL4943507,
                             vJAQL4943647,
                             vJAQL4943533,
                             vJAQL4943506,
                             vJAQL4943750,
                             vJAQL4943752,
                             vJAQL4943753
                             );
        Exception
        When others then
          --lc_error := sqlerrm;                      
          null;
        end;
    end if;
  Exception
  When others then
    --lc_error := sqlerrm;         
    null;
  end sp_op_carga_JAQL494;                                            
  
 procedure sp_op_carga_JAQL495(  pn_cor in number, --numero correlativo
                                 pn_pgcod in number, --pgcod
                                 pn_hcmod in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran in number, --htran
                                 pn_hnrel in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing in varchar2, --usuario ingreso
                                 pc_hora in varchar2, --hora
                                 pc_cont in varchar2,  --estado contable 
                                 pn_corr in number, --itcorr - (99-extornado)
                                 pn_pais in number,
                                 pn_tipo in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              ) is 
  vJAQL495CORR  NUMBER(18);  
  vJAQL4953507  VARCHAR2(14);
  vJAQL4953545  VARCHAR2(4);
  vJAQL4953501  VARCHAR2(6);
  vJAQL4953505  NUMBER(5);  
  vJAQL4953546  NUMBER(3);  
  vJAQL4953502  VARCHAR2(2);
  vJAQL4953566  VARCHAR2(3);
  vJAQL4953548  VARCHAR2(11); 
  vJAQL4953527  NUMBER(4);  
  vJAQL4953532  VARCHAR2(1);
  vJAQL4953511  VARCHAR2(1);
  vJAQL4953509  NUMBER(8);  
  vJAQL4953510  NUMBER(6);  
  vJAQL4953614  VARCHAR2(4);
  vJAQL4953516  VARCHAR2(3);
  vJAQL4953508  NUMBER(15,2);  
  vJAQL4953567  NUMBER(15,2);  
  vJAQL4953549  NUMBER(15,2);  
  vJAQL4953550  NUMBER(15,2);  
  vJAQL4953540  VARCHAR2(25);
  vJAQL4953504  VARCHAR2(25);
  vJAQL4953503  VARCHAR2(3);
  vJAQL4953512  NUMBER(12);  
  vJAQL4953605  VARCHAR2(1);
  vJAQL4953515  VARCHAR2(1);
  vJAQL4953538  VARCHAR2(1);
  vJAQL4953640  VARCHAR2(15);
  vJAQL4953544  VARCHAR2(1);
  vJAQL4953517  VARCHAR2(1);
  vJAQL4953597  VARCHAR2(1);
  vJAQL4953521  NUMBER(14,2);  
  vJAQL4953520  VARCHAR2(30);
  vJAQL4953533  NUMBER(8);  
  vJAQL4953519  VARCHAR2(15);--10
  vJAQL4953522  VARCHAR2(12);
  vJAQL4953539  VARCHAR2(12); 
  vJAQL4953537  NUMBER(5);  
  vJAQL4953596  NUMBER(5);  
  vJAQL4953518  VARCHAR2(20);
  vJAQL4953536  VARCHAR2(20);
  vJAQL4953552  NUMBER(15,2);  
  vJAQL4953553  VARCHAR2(2);
  vJAQL4953554  VARCHAR2(2);
  vJAQL4953525  VARCHAR2(1);
  vJAQL4953543  VARCHAR2(31);
  vJAQL4953555  VARCHAR2(21);
  vJAQL4953556  VARCHAR2(15);
  vJAQL4953523  VARCHAR2(40);
  vJAQL4953524  VARCHAR2(40);
  vJAQL4953557  VARCHAR2(35);
  vJAQL4953558  VARCHAR2(12);
  vJAQL4953559  VARCHAR2(12);
  vJAQL4953560  VARCHAR2(12);
  vJAQL4953561  VARCHAR2(40);
  vJAQL4953535  NUMBER(8);  
  vJAQL4953620  NUMBER(4);  
  vJAQL4953563  VARCHAR2(20);
  vJAQL4953564  VARCHAR2(6);
  vJAQL4953760  VARCHAR2(15);
  vJAQL4953761  VARCHAR2(15);
  vJAQL4953762  VARCHAR2(15);
  vJAQL4953763  VARCHAR2(15);
  vJAQL4953568  NUMBER(4);  
  vJAQL4953569  NUMBER(10);  --6
  vJAQL4953570  VARCHAR2(3);
  vJAQL4953571  VARCHAR2(2);
  vJAQL4953572  NUMBER(8);  
  vJAQL4953573  VARCHAR2(6);
  vJAQL4953576  VARCHAR2(10);
  vJAQL4953579  VARCHAR2(1);
  vJAQL4953587  VARCHAR2(1);
  vJAQL4953588  NUMBER(11);  
  vJAQL4953589  NUMBER(11);  
  vJAQL4953590  NUMBER(11);  
  vJAQL4953591  NUMBER(11);  
  vJAQL4953592  NUMBER(11);  
  vJAQL4953593  NUMBER(11);  
  vJAQL4953598  VARCHAR2(14);
  vJAQL4953506  VARCHAR2(30);
  vJAQL4953750  VARCHAR2(30);
  vJAQL4953751  VARCHAR2(30);
  vJAQL4953752  NUMBER(14,2);  
  vJAQL4953753  NUMBER(14,2);  
  vJAQL4953754  NUMBER(14,2);  
  vJAQL4953514  NUMBER(8);  
  vJAQL4953529  VARCHAR2(1);
  vJAQL4953530  NUMBER(3);  
  vJAQL4953534  VARCHAR2(15);
  vJAQL4953641  NUMBER(8);  
  vJAQL4953755  VARCHAR2(9);
  vJAQL4953756  NUMBER(3);  
  vJAQL4953757  VARCHAR2(9);
  vJAQL4953758  VARCHAR2(30);
  vJAQL4953759  NUMBER(3,2);  
  vJAQL4953764  NUMBER(5,2);  
  vJAQL4953765  VARCHAR2(30);
  vJAQL4953766  VARCHAR2(15);
  vJAQL4953767  VARCHAR2(2);  
  
  --lc_error      varchar2(400);     
  ln_valida     number;
  ln_htran      number;
  ln_pgcod      number;
  ln_hcmod      number;
  ln_hsucor     number;
  ln_hnrel      number; 
  lc_indoff     char(1) := 'N';   
  pn_operac     fsd011.scoper%type;  
  pn_moncta     fsd016.moneda%type;
  pn_subope     fsd016.itsubo%type;  
  ln_monope     fsd016.moneda%type;   
  pn_monope     number;   
  pn_tipope     number:=0;
  pn_monto      number(12,2):=0;
  pn_ctacli     number(9);
  pn_modulo     number(3);       
  ln_pais       fsr008.pepais%type;  
  ln_tipo       fsr008.petdoc%type;
  lc_docu       fsr008.pendoc%type;     
    
  pn_tipo1      number;
  pn_tipo2      number;
  pn_codpet     number(10);
  pc_coderr     char(3);
  pc_deserr     char(45);    
  pn_sucurs     fsd016.itsucd%type;
  pn_codord     fsd016.itord%type;       
  

  ld_fecven     date;  
  ld_fecape     date;    
  ld_fecori     date;    
  ld_fecult     date;  
  lc_pfebco     fsd002.pfebco%type;
  
  lc_indemd     fsd002.pfebco%type;
  lc_codcld     char(12);
  lc_sucapd     number(3);
  lc_nomtid     varchar2(40);     
  lc_idclid     char(14);
  lc_nombre     fsd008.ctnom%type;  
  lc_null       char(40);    
  lc_modtra     varchar2(6); 
  ln_null       number;
  lc_ctades     char(20);
  pn_numchq     fsd016.itcheq%type;
  lc_numtar     char(30);
  lc_cciori     char(20);    
  
  pn_hcmod_o number(3);
  pn_hnrel_o number(4); 
  pd_fecpro_o date;
  lc_idterm varchar2(100);
  lc_locali varchar2(100);
  lc_valant varchar2(100);
  lc_valact varchar2(100);
  pn_condtra_ori number;
  lc_MMC  varchar2(20);    
  pc_idterm varchar2(15);
  pc_locali varchar2(100); 
  
  pc_cocom varchar2(20) ;  
  ln_estado number(2);
  lc_indtic char(1);
  
  lc_indtra char(1):='N';
  
  begin
  vJAQL495CORR := pn_cor;
  If pn_pgcod = 0 and pn_pais = 1 then
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_trx_offline(pn_codtra => pn_tipo, --ahi viene el codtra para offline
                                               pd_fecpro => pd_fecpro,
                                               pc_numtar => pc_cont,
                                               pn_pgcod  => ln_pgcod,
                                               pn_hcmod  => ln_hcmod,
                                               pn_hsucor => ln_hsucor,
                                               pn_htran  => ln_htran,
                                               pn_hnrel  => ln_hnrel
                                               );
      end;   
      
      begin
        pq_op_asientos_mplus.sp_ah_valida_trx(pn_pgcod  => ln_pgcod,
                                              pn_hcmod  => ln_hcmod,
                                              pn_htran  => ln_htran,
                                              pn_indvig => ln_valida,
                                              pn_tipmon => ln_null
                                              );      
      end;                                              
      lc_indoff := 'S';
  Else 
      
      begin
        pq_op_asientos_mplus.sp_ah_valida_trx(pn_pgcod  => pn_pgcod,
                                              pn_hcmod  => pn_hcmod,
                                              pn_htran  => pn_htran,
                                              pn_indvig => ln_valida,
                                              pn_tipmon => ln_null
                                              );      
      end;                                              
      
      lc_indoff := 'N';
  End If;
   
   
   --obtener la cuenta
    If lc_indoff = 'N' Then
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trx(pn_pgcod  => pn_pgcod,
                                               pn_hcmod  => pn_hcmod,
                                               pn_hsucor => pn_hsucor,
                                               pn_htran  => pn_htran,
                                               pn_hnrel  => pn_hnrel,
                                               pn_monto  => pn_monto,
                                               pn_ctacli => pn_ctacli,
                                               pn_modulo => pn_modulo,
                                               pn_moncta => pn_moncta,
                                               pn_subope => pn_subope,
                                               pn_operac => pn_operac,
                                               pn_tipope => pn_tipope,
                                               pn_sucurs => pn_sucurs,
                                               pn_numchq => pn_numchq,
                                               pn_codord => pn_codord
                                              );
        end;      
    Else
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trx_off(pc_numtar => pc_cont, --tarjeta
                                                   pn_codtra => pn_tipo,  --codtra 
                                                   pd_fecpro => pd_fecpro,
                                                   pn_indtrx => ln_valida,
                                                   pn_monto  => pn_monto,
                                                   pn_ctacli => pn_ctacli,
                                                   pn_modulo => pn_modulo,
                                                   pn_moncta => pn_moncta,
                                                   pn_subope => pn_subope,
                                                   pn_operac => pn_operac,
                                                   pn_tipope => pn_tipope,
                                                   pn_sucurs => pn_sucurs,                                                    
                                                   pn_monope => pn_monope                                                   
                                                  );
        end;        
    End If;
     
    --validacion de trabajador
    lc_indtra  := pq_op_asientos_mplus.fn_cl_es_trabajador(pn_ctacli);    
    
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_cl_cliente(pn_ctacli => pn_ctacli,
                                         pn_pais   => ln_pais,
                                         pn_tipo   => ln_tipo,
                                         pc_numero => lc_docu,
                                         pc_nombre => lc_nombre
                                         );
    end;      
    
    vJAQL4953507 := lpad(trim(to_char(ln_tipo)),2,'0') || lpad(trim(lc_docu),12,'0');        
    vJAQL4953545 := 1;

    If lc_indoff = 'N' Then
      If ln_valida = 2 Then
         If pn_hcmod > 500 Then
            lc_modtra := lpad(pn_hcmod-500,3,'0')||lpad(pn_htran,3,'0');   --87750
         Else
            lc_modtra := lpad(pn_hcmod,3,'0')||lpad(pn_htran,3,'0');   --87750       
         End If;
      Else
         lc_modtra := lpad(pn_hcmod,3,'0')||lpad(pn_htran,3,'0');   --87750    
      End If;
    Else
      If ln_valida = 2 Then
         If ln_hcmod > 500 Then
            lc_modtra := lpad(ln_hcmod-500,3,'0')||lpad(ln_htran,3,'0');   --87750
         Else
            lc_modtra := lpad(ln_hcmod,3,'0')||lpad(ln_htran,3,'0');   --87750       
         End If;
      Else
         lc_modtra := lpad(ln_hcmod,3,'0')||lpad(ln_htran,3,'0');   --87750    
      End If;  
    End If;    
    
    vJAQL4953501 := lc_modtra;
              
    
    --region de la sucursal
    begin
      select a.regcod 
        into vJAQL4953546
        from fst810 a, 
             fst811 b       
       where a.pgcod  = b.pgcod
         and a.regcod = b.regcod  
         and a.regcod < 100
         and b.regcod < 100
         and b.oficod = pn_hsucor;
    exception
    when others then     
      vJAQL4953546 := 0;
    end;
    
    vJAQL4953502 := to_char(pn_modulo); 
    vJAQL4953566 := to_char(pn_tipope); 
    vJAQL4953548 := substr(to_char(pn_cor),1,11);
    
    If lc_indoff = 'N' Then
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => pn_pgcod,
                                             pn_hcmod => pn_hcmod,
                                             pn_htran => pn_htran,
                                             pn_tipo1 => pn_tipo1,
                                             pn_tipo2 => pn_tipo2
                                            );
      end;   
   Else
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => ln_pgcod,
                                             pn_hcmod => ln_hcmod,
                                             pn_htran => ln_htran,
                                             pn_tipo1 => pn_tipo1,
                                             pn_tipo2 => pn_tipo2
                                            );
      end;      
   End If;
    If lc_indoff = 'N' Then
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trama(pn_pgcod  => pn_pgcod,
                                                 pn_hcmod  => pn_hcmod,
                                                 pn_hsucor => pn_hsucor,
                                                 pn_htran  => pn_htran,
                                                 pn_hnrel  => pn_hnrel,
                                                 pd_fecpro => pd_fecpro,
                                                 pn_tipo2  => pn_tipo2,
                                                 pn_codpet => pn_codpet,
                                                 pc_coderr => pc_coderr,
                                                 pc_deserr => pc_deserr
                                                 );
        end;  
    Else
        pc_coderr := '0';
    End If;        
    vJAQL4953527 := to_number(pc_coderr);
    
    
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_cl_datos_cliente(pn_pais   => ln_pais,
                                               pn_tipo   => ln_tipo,
                                               pc_numero => lc_docu,
                                               pc_tipper => vJAQL4953532,
                                               pc_direcc => vJAQL4953557,
                                               pc_mail   => vJAQL4953561,
                                               pc_telef1 => vJAQL4953558,
                                               pc_telef2 => vJAQL4953559,
                                               pc_segmen => vJAQL4953620,
                                               pn_fecalt => vJAQL4953535
                                               );
    end;
               
   -- indicador reverso 
    if ln_valida = 2 then
       vJAQL4953511 := 'S';
    else
       vJAQL4953511 := 'N';
    end if;    
    
   --fecha hora transmision
   If lc_indoff = 'N' Then
      vJAQL4953509 := to_number(to_char(pd_fecpro,'rrrrmmdd'));          
   Else
      vJAQL4953509 := to_number(to_char(trunc(sysdate),'rrrrmmdd'));          
   End If;        
     
    vJAQL4953510 := to_number(replace(pc_hora,':',''));                
    
   If lc_indoff = 'N' Then
      pq_op_asientos_mplus.sp_ah_moneda_trx(pn_pgcod  => pn_pgcod,
                                            pn_hcmod  => pn_hcmod,
                                            pn_hsucor => pn_hsucor,
                                            pn_htran  => pn_htran,
                                            pn_hnrel  => pn_hnrel,
                                            pn_moncta => pn_moncta,
                                            pn_monope => ln_monope,
                                            pc_indtic => lc_indtic                                                          
                                            );   
   Else   
       ln_monope := pn_monope;  
   End If;
   
    --moneda de la operacion trx
   If ln_monope = 0 Then
      vJAQL4953516 := 604;
   Else
      vJAQL4953516 := 840;
   End If;   
  
   If ln_monope = 101 and lc_indtic = 'N' then   

      vJAQL4953508 := pn_monto; --monto en moneda de la trx
      
   ElsiF ln_monope = 101 and lc_indtic = 'S' then 
      vJAQL4953508 := round(pn_monto/ fn_tipo_cambio(fecha  => pd_fecpro,
                                                     monori => 0,
                                                     mondes => ln_monope,
                                                     tipo   => 500
                                                     ),2);--monto en moneda de la trx

   ElsiF ln_monope = 0 and lc_indtic = 'S' then       

      vJAQL4953508 := round(pn_monto* fn_tipo_cambio(fecha  => pd_fecpro,
                                                     monori => 101,
                                                     mondes => ln_monope,
                                                     tipo   => 500
                                                     ),2);          
   Else
      vJAQL4953508 := pn_monto;  
   End If;
      
   --vJAQL4953508 := pn_monto; 
    
   
   
   vJAQL4953518 := pc_uing; 
   
   If ((pn_codord = 7 or (pn_hcmod = 50 and pn_htran = 540)) and pn_tipo2 = 1) then --ordinal y canal
      vJAQL4953567 := pn_monto;
   Else
      vJAQL4953567 := 0;
   End if; 
   
   vJAQL4953549 := 0; 
   
   if (pn_hcmod = 50 and pn_htran = 540) then --monto cheque de otro banco
       vJAQL4953550 := pn_monto;
   else    
       vJAQL4953550 := 0;
   end if;
   --cta origen
   if pn_modulo = 21 then
      vJAQL4953540 := lpad(pn_ctacli,9,'0')||lpad(pn_modulo,3,'0')||lpad(pn_moncta,3,'0')||lpad(pn_subope,2,'0')||lpad(pn_tipope,3,'0');
   else  
      vJAQL4953540 := lpad(pn_ctacli,9,'0')||lpad(pn_modulo,3,'0')||lpad(pn_moncta,3,'0')||lpad(pn_operac,9,'0')||lpad(pn_tipope,3,'0');                
   End if;    
   vJAQL4953503 := pn_tipo2 ;--canal
   vJAQL4953597 := '+';
   
    -- es trabajador?
    lc_pfebco := pq_op_asientos_mplus.fn_cl_estrabajador(pn_pais   => ln_pais,
                                                         pn_tipo   => ln_tipo,
                                                         pc_numero => lc_docu
                                                        );
    
    if lc_pfebco = 'S' then
      vJAQL4953640 := lpad(trim(to_char(ln_tipo)),3,'0') || lpad(trim(lc_docu),12,'0');    
    else
      vJAQL4953640 := null;
    end if;    
    
    if pn_tipo1 = 1 then
       vJAQL4953544 := 'D';
    elsif pn_tipo2 = 2 then
       vJAQL4953544 := 'C';     
    else
       vJAQL4953544 := 'O';  
    end if; 
      
     begin
         select substr(b.locnom,1,30) 
           into vJAQL4953520
           from fst001 a,
                fst070 b
          where a.pgcod  = 1
            and b.pais   = 604
            and a.sucurs = pn_hsucor
            and a.scciud = b.loccod
            and a.scdept = b.depcod;        
     exception
     when others then
       vJAQL4953520 := null;
     end;   
         
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_datos_producto(vpgcod    => 1,
                                             vscsuc    => pn_sucurs,
                                             vsccta    => pn_ctacli,
                                             vscmda    => pn_moncta,
                                             vscpap    => 0,
                                             vscoper   => pn_operac,
                                             vscsbop   => pn_subope,
                                             vsctope   => pn_tipope,
                                             vscmod    => pn_modulo,
                                             pn_plazo  => ln_null,
                                             pd_fecven => ld_fecven,--vJAQL4963675,
                                             pc_ejecut => lc_null,
                                             pn_estado => ln_estado,
                                             pn_saldo  => vJAQL4953521,
                                             pd_fecape => ld_fecape,--vJAQL4963533,
                                             pd_fecori => ld_fecori,--vJAQL4963681,
                                             pd_feculm => ld_fecult --vJAQL4963641
                                             );
    end;      
    
    if ln_estado = 99 then
       vJAQL4953517 := 'C';
    Elsif ln_estado = 81 then
       vJAQL4953517 := 'I';
    Else
       vJAQL4953517 := 'A';
    end if; 
    
    
    vJAQL4953533 := to_number(to_char(ld_fecape,'rrrrmmdd'));         
      
    --id de terminal
      -- Call the procedure
       If lc_indoff = 'N' Then   
          If ln_valida = 2 and pn_hcmod > 500 then
              
              PQ_OP_ASIENTOS_MPLUS.sp_ah_trx_ori(pn_pgcod    => pn_pgcod,
                                                 pn_hcmod    => pn_hcmod,
                                                 pn_hsucor   => pn_hsucor,
                                                 pn_htran    => pn_htran,
                                                 pn_hnrel    => pn_hnrel,
                                                 pd_fecpro   => pd_fecpro,
                                                 pn_hcmod_o  => pn_hcmod_o,
                                                 pn_hnrel_o  => pn_hnrel_o,
                                                 pd_fecpro_o => pd_fecpro_o
                                                );
                                                      
              
              PQ_OP_ASIENTOS_MPLUS.sp_ah_id_terminal(pn_pgcod  => pn_pgcod,
                                                     pn_hcmod  => pn_hcmod_o,
                                                     pn_hsucor => pn_hsucor,
                                                     pn_htran  => pn_htran,
                                                     pn_hnrel  => pn_hnrel_o,
                                                     pd_fecpro => pd_fecpro_o,
                                                     pc_uing   => pc_uing,  
                                                     pc_numtar => lc_numtar,                                           
                                                     pc_idterm => pc_idterm,
                                                     pc_locali => pc_locali,
                                                     pc_cocom  => pc_cocom
                                                     );
        Else                                             
            PQ_OP_ASIENTOS_MPLUS.sp_ah_id_terminal(pn_pgcod  => pn_pgcod,
                                                   pn_hcmod  => pn_hcmod,
                                                   pn_hsucor => pn_hsucor,
                                                   pn_htran  => pn_htran,
                                                   pn_hnrel  => pn_hnrel,
                                                   pd_fecpro => pd_fecpro,
                                                   pc_uing   => pc_uing,  
                                                   pc_numtar => lc_numtar,                                           
                                                   pc_idterm => pc_idterm,
                                                   pc_locali => pc_locali,
                                                   pc_cocom  => pc_cocom
                                                   );    
        end If;   
      Else
        If ln_valida = 2 then
            --buscamos trx original de offline
            PQ_OP_ASIENTOS_MPLUS.sp_ah_datos_trx_ori_off(pn_numtar => lc_numtar,
                                                         pn_codtra => pn_tipo,
                                                         pd_fecpro => pd_fecpro,                                                                      
                                                         pn_traori => pn_condtra_ori
                                                         );
            PQ_OP_ASIENTOS_MPLUS.sp_ah_datos_ter_off(pn_codtra => pn_condtra_ori,
                                                     pc_idterm => lc_idterm,  
                                                     pc_locali => lc_locali,
                                                     pc_valant => lc_valant,
                                                     pc_valact => lc_valact,
                                                     pc_numero => lc_MMC        
                                                     );                                                           
        Else
            PQ_OP_ASIENTOS_MPLUS.sp_ah_datos_ter_off(pn_codtra => pn_tipo,
                                                     pc_idterm => lc_idterm,  
                                                     pc_locali => lc_locali,
                                                     pc_valant => lc_valant,
                                                     pc_valact => lc_valact,
                                                     pc_numero => lc_MMC       
                                                     );        
        End If;                                                     
            
      End If;    
      
    If lc_indoff = 'N' Then   
      If pn_tipo2 <> 5 then
         vJAQL4953519 := pc_idterm;    
      Else
         vJAQL4953519 := trim(pc_valant);    
      End If;
      -- agencia
       If pn_tipo2 = 3 Then  --corresponsal
          vJAQL4953505 := TRIM(pc_cocom); 
       Elsif pn_tipo2 = 2 Then --atm
          vJAQL4953505 := TRIM(pc_idterm);--
       Elsif pn_tipo2 = 1 Then --ventanilla
          vJAQL4953505 := pn_hsucor;--
       Else
          vJAQL4953505 := trim(pc_valact);--
       End If;      
    Else
      If pn_tipo2 <> 5 then
         vJAQL4953519 := lc_idterm;    
      Else
         vJAQL4953519 := trim(lc_valant);    
      End If;  
      -- agencia
       If pn_tipo2 = 3 Then  --corresponsal
          vJAQL4953505 := TRIM(pc_cocom); 
       Elsif pn_tipo2 = 2 Then --atm
          vJAQL4953505 := TRIM(lc_idterm);--
       Elsif pn_tipo2 = 1 Then --ventanilla
          vJAQL4953505 := ln_hsucor;--
       Else
          vJAQL4953505 := trim(lc_valact);--
       End If;           
    End If;     

    
    vJAQL4953576 := pc_uing; --confirma
    vJAQL4953529 := '0';
    vJAQL4953563 := to_char(pd_fecpro,'rrmmdd')||lpad(to_char(pn_hcmod),3,'0')||lpad(to_char(pn_htran),3,'0')||lpad(to_char(pn_hsucor),3,'0')||lpad(to_char(pn_hnrel),4,'0');              
    vJAQL4953515 := lc_pfebco;
    vJAQL4953522 := lpad(trim(lc_docu),12,'0');
    vJAQL4953537 := pn_sucurs;   
    vJAQL4953523 := lc_nombre;--nombre origen
    vJAQL4953641 := to_number(to_char(ld_fecult,'rrrrmmdd'));

    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_datos_transferencia(pn_pgcod  => pn_pgcod,
                                                  pn_hcmod  => pn_hcmod,
                                                  pn_hsucor => pn_hsucor,
                                                  pn_htran  => pn_htran,
                                                  pn_hnrel  => pn_hnrel,
                                                  pd_fecpro => pd_fecpro,
                                                  pc_indemd => lc_indemd,
                                                  pc_codcld => lc_codcld,
                                                  pc_sucapd => lc_sucapd,
                                                  pc_nomtid => lc_nomtid,
                                                  pc_idclid => lc_idclid,
                                                  pc_ctades => lc_ctades,  
                                                  pc_bcodes => vJAQL4953570,
                                                  pc_sucdes => vJAQL4953573                                                
                                                  );
    end;    
    vJAQL4953538 := lc_indemd;
    vJAQL4953539 := lc_codcld;
    vJAQL4953596 := lc_sucapd;
    vJAQL4953524 := lc_nomtid;
    vJAQL4953598 := lc_idclid;
    vJAQL4953504 := lc_ctades;
    
    vJAQL4953552 := 0;
    vJAQL4953553 := 'No';
    
   
   If ln_valida <> 2 Then
      vJAQL4953568 := 210;--pn_hnrel;
   ELse
      vJAQL4953568 := 420;--pn_hnrel;
   End IF;    
   
      
   --ESTA REGSITRADO PARA OPERACIONES X INTERNET??
   begin --obtenemos tarjeta vigente
      select a.z0e478nro 
        into lc_numtar
       from z0e478 a,
            z0e479 b
      where a.z0e478nro = b.z0e478nro
        and b.z0e479suc = pn_sucurs  
        and b.z0e479cta = pn_ctacli
        and b.z0e479sct = pn_subope
        and b.z0e479mod = pn_modulo
        and b.z0e479mon = pn_moncta
        and b.z0e479pap = 0
        and b.z0e479top = pn_tipope
        and b.z0e479ope = pn_operac
        and a.z0e463cod in (1,7);
   exception
   when others then  
     lc_numtar := null;
   end;  
      
   if lc_numtar is not null then
       lc_numtar := rpad(lc_numtar,30,' ');
       begin 
         select 'S'
           into vJAQL4953525
           from cnl002 a
          where a.cnl000cod = 5
            and a.cnl001adm = lc_numtar
            and a.cnl001usu = lc_numtar
            and a.cnl002pgc = 1
            and a.cnl002mod = pn_modulo
            and a.cnl002suc = pn_sucurs  
            and a.cnl002mda = pn_moncta
            and a.cnl002pap = 0
            and a.cnl002ope = pn_operac
            and a.cnl002top = pn_tipope
            and a.cnl002cta = pn_ctacli
            and a.cnl002sbo = pn_subope
            and a.cnl008cod = 0
            and a.cnl002ima > 0
            and rownum = 1 ;  
       exception
       when others then  
         --lc_numtar    := null;
         vJAQL4953525 := 'N';      
       end;
   else
       vJAQL4953525 := 'N';      
   end if;
   --clave transf interban
   begin
      select se115ccior 
        into lc_cciori
        from fse115 a
       where a.se115cd = pn_pgcod
         and a.se115su = pn_hsucor   
         and a.se115md = pn_hcmod   
         and a.se115tr = pn_htran   
         and a.se115re = pn_hnrel    
         and a.se115fc = pd_fecpro;      
         
      select a.ID_NUMOPE
        into vJAQL4953543
        from jaql380 a
       where a.fch_reg  = pd_fecpro
         and a.cci_ori  = lc_cciori
         and a.hora_reg = (select max(b.hora_reg)
                             from jaql380 b
                            where b.fch_reg = pd_fecpro
                              and b.cci_ori = lc_cciori
                          );         
   exception
   when others then
      vJAQL4953543 := null;
   end;
   vJAQL4953555 := to_char(pd_fecpro,'rrrrmmdd')||LPAD(pn_hcmod,3,'0')||LPAD(pn_htran,3,'0')||LPAD(pn_hnrel,4,'0')||LPAD(pn_hsucor,3,0);
   
   -- pago de servicio
   begin
     select lpad(a.jaql515coent,3,'0')||lpad(a.jaql515cotsv,3,'0') , substr(b.jaql508abent,1,15)
       into vJAQL4953564,vJAQL4953760
       from jaql515 a,
            jaql508 b 
      where a.jaql515coent = b.jaql508coent
        and a.jaql515pgcod = pn_pgcod
        and a.jaql515pgsuc = pn_hsucor 
        and a.jaql515scmod = pn_hcmod
        and a.jaql515stran = pn_htran
        and a.jaql515snrel = pn_hnrel 
        and a.jaql515femov = pd_fecpro;     
   exception   
   when others then
     vJAQL4953564 := null;
     vJAQL4953760 := null;
   end;
   
   --codigo de recarga
   
   begin
     select a.jaqy584drqsv
       into vJAQL4953569
       from jaqy584 a
      where a.jaqy584itsuc = pn_hsucor
        and a.jaqy584itmod = pn_hcmod
        and a.jaqy584ttran = pn_htran
        and a.jaqy584itrel = pn_hnrel
        and a.jaqy584feape = pd_fecpro;     
   exception   
   when others then
     vJAQL4953569 := null;
   end;
   --cheque y fecha valorizacion cheque
   if pn_hcmod = 50 and pn_htran = 540 then
       begin
         select to_number(to_char(a.itfvto,'rrrrmmdd')), a.itcheq
           into vJAQL4953572, vJAQL4953512
           from fsd016 a
          where a.pgcod  = pn_pgcod
            and a.itsuc  = pn_hsucor
            and a.itmod  = pn_hcmod
            and a.ittran = pn_htran
            and a.itnrel = pn_hnrel
            and a.modulo = 19;
       exception   
       when others then
         vJAQL4953572 := null;
         vJAQL4953512 := null;
       end;   
   end if;
   --datos de la chequera de la orden de pago
   if pn_hcmod = 50 and pn_htran = 30 then --retiro con orden de pago
       vJAQL4953593 := pn_numchq;
       begin
          select a.cheini, (a.cheini + a.checnt - 1) chefin, to_char(a.chetpo)
            into vJAQL4953591, vJAQL4953592,vJAQL4953605
            from fsd230 a 
           where a.checod = pn_pgcod
             and a.chemod = pn_modulo
             and a.chesuc = pn_sucurs
             and a.chemda = pn_moncta
             and a.chepap = 0
             and a.checta = pn_ctacli
             and a.cheope = pn_operac
             and a.chesbo = pn_subope
             and a.chetop = pn_tipope
             and pn_numchq between a.cheini and  (a.cheini + a.checnt - 1);         
       Exception   
       when others then
         vJAQL4953591 := null; 
         vJAQL4953592 := null;
         vJAQL4953605 := null;
       end;                
   end if;   
  
    if lc_indtra = 'S' then
        begin
          insert into jaql495(JAQL495CORR,
                              JAQL4953507,
                              JAQL4953545,
                              JAQL4953501,
                              JAQL4953505,
                              JAQL4953546,
                              JAQL4953502,
                              JAQL4953566,
                              JAQL4953548,
                              JAQL4953527,
                              JAQL4953532,
                              JAQL4953511,
                              JAQL4953509,
                              JAQL4953510,
                              JAQL4953614,
                              JAQL4953516,
                              JAQL4953508,
                              JAQL4953567,
                              JAQL4953549,
                              JAQL4953550,
                              JAQL4953540,
                              JAQL4953504,
                              JAQL4953503,
                              JAQL4953512,
                              JAQL4953605,
                              JAQL4953515,
                              JAQL4953538,
                              JAQL4953640,
                              JAQL4953544,
                              JAQL4953517,
                              JAQL4953597,
                              JAQL4953521,
                              JAQL4953520,
                              JAQL4953533,
                              JAQL4953519,
                              JAQL4953522,
                              JAQL4953539,
                              JAQL4953537,
                              JAQL4953596,
                              JAQL4953518,
                              JAQL4953536,
                              JAQL4953552,
                              JAQL4953553,
                              JAQL4953554,
                              JAQL4953525,
                              JAQL4953543,
                              JAQL4953555,
                              JAQL4953556,
                              JAQL4953523,
                              JAQL4953524,
                              JAQL4953557,
                              JAQL4953558,
                              JAQL4953559,
                              JAQL4953560,
                              JAQL4953561,
                              JAQL4953535,
                              JAQL4953620,
                              JAQL4953563,
                              JAQL4953564,
                              JAQL4953760,
                              JAQL4953761,
                              JAQL4953762,
                              JAQL4953763,
                              JAQL4953568,
                              JAQL4953569,
                              JAQL4953570,
                              JAQL4953571,
                              JAQL4953572,
                              JAQL4953573,
                              JAQL4953576,
                              JAQL4953579,
                              JAQL4953587,
                              JAQL4953588,
                              JAQL4953589,
                              JAQL4953590,
                              JAQL4953591,
                              JAQL4953592,
                              JAQL4953593,
                              JAQL4953598,
                              JAQL4953506,
                              JAQL4953750,
                              JAQL4953751,
                              JAQL4953752,
                              JAQL4953753,
                              JAQL4953754,
                              JAQL4953514,
                              JAQL4953529,
                              JAQL4953530,
                              JAQL4953534,
                              JAQL4953641,
                              JAQL4953755,
                              JAQL4953756,
                              JAQL4953757,
                              JAQL4953758,
                              JAQL4953759,
                              JAQL4953764,
                              JAQL4953765,
                              JAQL4953766,
                              JAQL4953767
                             )
                      values(vJAQL495CORR,
                             vJAQL4953507,
                             vJAQL4953545,
                             vJAQL4953501,
                             vJAQL4953505,
                             vJAQL4953546,
                             vJAQL4953502,
                             vJAQL4953566,
                             vJAQL4953548,
                             vJAQL4953527,
                             vJAQL4953532,
                             vJAQL4953511,
                             vJAQL4953509,
                             vJAQL4953510,
                             vJAQL4953614,
                             vJAQL4953516,
                             vJAQL4953508,
                             vJAQL4953567,
                             vJAQL4953549,
                             vJAQL4953550,
                             vJAQL4953540,
                             vJAQL4953504,
                             vJAQL4953503,
                             vJAQL4953512,
                             vJAQL4953605,
                             vJAQL4953515,
                             vJAQL4953538,
                             vJAQL4953640,
                             vJAQL4953544,
                             vJAQL4953517,
                             vJAQL4953597,
                             vJAQL4953521,
                             vJAQL4953520,
                             vJAQL4953533,
                             vJAQL4953519,
                             vJAQL4953522,
                             vJAQL4953539,
                             vJAQL4953537,
                             vJAQL4953596,
                             vJAQL4953518,
                             vJAQL4953536,
                             vJAQL4953552,
                             vJAQL4953553,
                             vJAQL4953554,
                             vJAQL4953525,
                             vJAQL4953543,
                             vJAQL4953555,
                             vJAQL4953556,
                             vJAQL4953523,
                             vJAQL4953524,
                             vJAQL4953557,
                             vJAQL4953558,
                             vJAQL4953559,
                             vJAQL4953560,
                             vJAQL4953561,
                             vJAQL4953535,
                             vJAQL4953620,
                             vJAQL4953563,
                             vJAQL4953564,
                             vJAQL4953760,
                             vJAQL4953761,
                             vJAQL4953762,
                             vJAQL4953763,
                             vJAQL4953568,
                             vJAQL4953569,
                             vJAQL4953570,
                             vJAQL4953571,
                             vJAQL4953572,
                             vJAQL4953573,
                             vJAQL4953576,
                             vJAQL4953579,
                             vJAQL4953587,
                             vJAQL4953588,
                             vJAQL4953589,
                             vJAQL4953590,
                             vJAQL4953591,
                             vJAQL4953592,
                             vJAQL4953593,
                             vJAQL4953598,
                             vJAQL4953506,
                             vJAQL4953750,
                             vJAQL4953751,
                             vJAQL4953752,
                             vJAQL4953753,
                             vJAQL4953754,
                             vJAQL4953514,
                             vJAQL4953529,
                             vJAQL4953530,
                             vJAQL4953534,
                             vJAQL4953641,
                             vJAQL4953755,
                             vJAQL4953756,
                             vJAQL4953757,
                             vJAQL4953758,
                             vJAQL4953759,
                             vJAQL4953764,
                             vJAQL4953765,
                             vJAQL4953766,
                             vJAQL4953767
                             );
        Exception
        When others then
          --lc_error := sqlerrm;                               
          null;
        end;
    end if;
  Exception
  When others then
    --lc_error := sqlerrm;                                                                             
    null;
  end sp_op_carga_JAQL495;    
  
 procedure sp_op_carga_JAQL496(  pn_cor    in number, --numero correlativo
                                 pn_pgcod  in number, --pgcod
                                 pn_hcmod  in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran  in number, --htran
                                 pn_hnrel  in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing   in varchar2, --usuario ingreso
                                 pc_hora   in varchar2, --hora
                                 pc_cont   in varchar2,  --estado contable 
                                 pn_corr   in number, --itcorr - (99-extornado)
                                 pn_pais   in number,
                                 pn_tipo   in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              ) is       
  vJAQL496CORR  NUMBER(18);  
  vJAQL4963507  VARCHAR2(14);
  vJAQL4963545  VARCHAR2(4);
  vJAQL4963501  VARCHAR2(6);
  vJAQL4963505  NUMBER(5);  
  vJAQL4963614  VARCHAR2(4);
  vJAQL4963546  NUMBER(3);  
  vJAQL4963502  VARCHAR2(2);
  vJAQL4963566  VARCHAR2(3);
  vJAQL4963548  VARCHAR2(11);
  vJAQL4963527  NUMBER(4); 
  vJAQL4963532  VARCHAR2(1);
  vJAQL4963511  VARCHAR2(1);
  vJAQL4963509  NUMBER(8); 
  vJAQL4963510  NUMBER(6); 
  vJAQL4963516  VARCHAR2(3);
  vJAQL4963508  NUMBER(15,2); 
  vJAQL4963518  VARCHAR2(20);
  vJAQL4963567  NUMBER(15,2); 
  vJAQL4963549  NUMBER(15,2); 
  vJAQL4963550  NUMBER(15,2); 
  vJAQL4963540  VARCHAR2(27);--25
  vJAQL4963670  VARCHAR2(27);--25
  vJAQL4963671  VARCHAR2(15);
  vJAQL4963672  NUMBER(8,4); 
  vJAQL4963673  VARCHAR2(1);
  vJAQL4963674  VARCHAR2(1);
  vJAQL4963675  NUMBER(8); 
  vJAQL4963676  NUMBER(8); 
  vJAQL4963677  VARCHAR2(20);
  vJAQL4963678  VARCHAR2(20);
  vJAQL4963503  VARCHAR2(3);
  vJAQL4963515  VARCHAR2(1);
  vJAQL4963538  VARCHAR2(1);
  vJAQL4963640  VARCHAR2(15);
  vJAQL4963544  VARCHAR2(1);
  vJAQL4963517  VARCHAR2(1);--1
  vJAQL4963597  VARCHAR2(1);
  vJAQL4963521  NUMBER(14,2); 
  vJAQL4963520  VARCHAR2(30);
  vJAQL4963533  NUMBER(8); 
  vJAQL4963681  NUMBER(8); 
  vJAQL4963519  VARCHAR2(15);--10
  vJAQL4963522  VARCHAR2(12);
  vJAQL4963539  VARCHAR2(12);
  vJAQL4963537  NUMBER(5); 
  vJAQL4963596  NUMBER(5); 
  vJAQL4963615  VARCHAR2(4);
  vJAQL4963536  VARCHAR2(12);
  vJAQL4963554  VARCHAR2(2);
  vJAQL4963556  VARCHAR2(15);
  vJAQL4963523  VARCHAR2(40);
  vJAQL4963524  VARCHAR2(40);
  vJAQL4963557  VARCHAR2(35);
  vJAQL4963558  VARCHAR2(12);
  vJAQL4963559  VARCHAR2(12);
  vJAQL4963560  VARCHAR2(12);
  vJAQL4963561  VARCHAR2(40);
  vJAQL4963535  NUMBER(8); 
  vJAQL4963620  NUMBER(4); 
  vJAQL4963563  VARCHAR2(20);
  vJAQL4963576  VARCHAR2(10);
  vJAQL4963579  VARCHAR2(1);
  vJAQL4963598  VARCHAR2(14);
  vJAQL4963529  VARCHAR2(1);
  vJAQL4963530  NUMBER(3); 
  vJAQL4963534  VARCHAR2(15);
  vJAQL4963641  NUMBER(8); 
  vJAQL4963506  VARCHAR2(30);
  vJAQL4963750  VARCHAR2(30);
  vJAQL4963751  VARCHAR2(30);
  vJAQL4963752  NUMBER(14,2); 
  vJAQL4963753  NUMBER(14,2); 
  vJAQL4963754  NUMBER(14,2); 
  --vJAQL496BYTEF VARCHAR2(5);    
  
  --lc_error      varchar2(400);     
  ln_valida     number;
  ln_htran      number;
  ln_pgcod      number;
  ln_hcmod      number;
  ln_hsucor     number;
  ln_hnrel      number; 
  lc_indoff     char(1) := 'N';   
  pn_operac     fsd011.scoper%type;  
  pn_moncta     fsd016.moneda%type;
  pn_subope     fsd016.itsubo%type;  
  ln_monope     fsd016.moneda%type;   
  pn_monope     number;   
  pn_tipope     number:=0;
  pn_monto      number(12,2):=0;
  pn_ctacli     number(9);
  pn_modulo     number(3);       
  ln_pais       fsr008.pepais%type;  
  ln_tipo       fsr008.petdoc%type;
  lc_docu       fsr008.pendoc%type; 
  lc_numtar     char(30);    
  
  ln_paisb      fsr008.pepais%type;  
  ln_tipob      fsr008.petdoc%type;
  lc_docub      fsr008.pendoc%type;       
  
  pn_tipo1      number;
  pn_tipo2      number;
  pn_codpet     number(10);
  pc_coderr     char(3);
  pc_deserr     char(45);    
  pn_sucurs     fsd016.itsucd%type;
  pn_codord     fsd016.itord%type;       
  
  ln_i2mod      fsd011.scmod%type;       
  ln_i2suc      fsd011.scsuc%type;       
  ln_i2mda      fsd011.scmda%type;       
  ln_i2pap      fsd011.scpap%type;       
  ln_i2cta      fsd011.sccta%type;       
  ln_i2oper     fsd011.scoper%type;       
  ln_i2sbop     fsd011.scsbop%type;       
  ln_i2tope     fsd011.sctope%type;       

  ld_fecven     date;  
  ld_fecape     date;    
  ld_fecori     date;    
  ld_fecult     date;  
  lc_pfebco     fsd002.pfebco%type;
  
  lc_indemd     fsd002.pfebco%type;
  lc_codcld     char(12);
  lc_sucapd     number(3);
  lc_nomtid     varchar2(40);     
  lc_idclid     char(14);
  lc_nombre     fsd008.ctnom%type;  
  lc_null       char(40);   
  lc_modtra     varchar2(6);    
  pn_numchq     fsd016.itcheq%type;    
  ln_null       number;  
  
  pn_hcmod_o number(3);
  pn_hnrel_o number(4); 
  pd_fecpro_o date;
  lc_idterm varchar2(100);
  lc_locali varchar2(100);
  lc_valant varchar2(100);
  lc_valact varchar2(100);
  pn_condtra_ori number;
  lc_MMC  varchar2(20);    
  pc_idterm varchar2(15);
  pc_locali varchar2(100); 
  --pc_locali1 varchar2(100);
  --ln_jaql97787564 jaql977.jaql97787564%type;  
  --ln_jaql97787544 jaql977.jaql97787544%type;  
  pc_cocom varchar2(20) ;  
  ln_estado number(2);
  lc_indtic char(1);  
  
  lc_indtra char(1):='N';
    
  begin
  vJAQL496CORR := pn_cor;
  If pn_pgcod = 0 and pn_pais = 1 then
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_trx_offline(pn_codtra => pn_tipo, --ahi viene el codtra para offline
                                               pd_fecpro => pd_fecpro,
                                               pc_numtar => pc_cont,
                                               pn_pgcod  => ln_pgcod,
                                               pn_hcmod  => ln_hcmod,
                                               pn_hsucor => ln_hsucor,
                                               pn_htran  => ln_htran,
                                               pn_hnrel  => ln_hnrel
                                               );
      end;   

      begin
        pq_op_asientos_mplus.sp_ah_valida_trx(pn_pgcod  => ln_pgcod,
                                              pn_hcmod  => ln_hcmod,
                                              pn_htran  => ln_htran,
                                              pn_indvig => ln_valida,
                                              pn_tipmon => ln_null
                                              );      
      end;                                              
      
      lc_indoff := 'S';
  Else 
      begin
        pq_op_asientos_mplus.sp_ah_valida_trx(pn_pgcod  => pn_pgcod,
                                              pn_hcmod  => pn_hcmod,
                                              pn_htran  => pn_htran,
                                              pn_indvig => ln_valida,
                                              pn_tipmon => ln_null
                                              );      
      end;                                                     
      lc_indoff := 'N';
  End If;
   
   
   --obtener la cuenta
    If lc_indoff = 'N' Then
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trx(pn_pgcod  => pn_pgcod,
                                               pn_hcmod  => pn_hcmod,
                                               pn_hsucor => pn_hsucor,
                                               pn_htran  => pn_htran,
                                               pn_hnrel  => pn_hnrel,
                                               pn_monto  => pn_monto,
                                               pn_ctacli => pn_ctacli,
                                               pn_modulo => pn_modulo,
                                               pn_moncta => pn_moncta,
                                               pn_subope => pn_subope,
                                               pn_operac => pn_operac,
                                               pn_tipope => pn_tipope,
                                               pn_sucurs => pn_sucurs,
                                               pn_numchq => pn_numchq,
                                               pn_codord => pn_codord
                                              );
        end;      
    Else
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trx_off(pc_numtar => pc_cont, --tarjeta
                                                   pn_codtra => pn_tipo,  --codtra 
                                                   pd_fecpro => pd_fecpro,
                                                   pn_indtrx => ln_valida,
                                                   pn_monto  => pn_monto,
                                                   pn_ctacli => pn_ctacli,
                                                   pn_modulo => pn_modulo,
                                                   pn_moncta => pn_moncta,
                                                   pn_subope => pn_subope,
                                                   pn_operac => pn_operac,
                                                   pn_tipope => pn_tipope,
                                                   pn_sucurs => pn_sucurs,                                                    
                                                   pn_monope => pn_monope                                                   
                                                  );
        end;        
    End If;
     

    --validacion de trabajador
    lc_indtra  := pq_op_asientos_mplus.fn_cl_es_trabajador(pn_ctacli);    
    
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_cl_cliente(pn_ctacli => pn_ctacli,
                                         pn_pais   => ln_pais,
                                         pn_tipo   => ln_tipo,
                                         pc_numero => lc_docu,
                                         pc_nombre => lc_nombre
                                         );
    end;      
    
    vJAQL4963507 := lpad(trim(to_char(ln_tipo)),2,'0') || lpad(trim(lc_docu),12,'0');
    vJAQL4963545 := 1;      

    If lc_indoff = 'N' Then
      If ln_valida = 2 Then
         If pn_hcmod > 500 Then
            lc_modtra := lpad(pn_hcmod-500,3,'0')||lpad(pn_htran,3,'0');   --87750
         Else
            lc_modtra := lpad(pn_hcmod,3,'0')||lpad(pn_htran,3,'0');   --87750       
         End If;
      Else
         lc_modtra := lpad(pn_hcmod,3,'0')||lpad(pn_htran,3,'0');   --87750    
      End If;
    Else
      If ln_valida = 2 Then
         If ln_hcmod > 500 Then
            lc_modtra := lpad(ln_hcmod-500,3,'0')||lpad(ln_htran,3,'0');   --87750
         Else
            lc_modtra := lpad(ln_hcmod,3,'0')||lpad(ln_htran,3,'0');   --87750       
         End If;
      Else
         lc_modtra := lpad(ln_hcmod,3,'0')||lpad(ln_htran,3,'0');   --87750    
      End If;  
    End If;    
    
    --vJAQL4963501 := to_char(pn_hcmod)||to_char(pn_htran);
    vJAQL4963501 := lc_modtra;
                   
    --region de la sucursal
    begin
      select a.regcod 
        into vJAQL4963546
        from fst810 a, 
             fst811 b       
       where a.pgcod  = b.pgcod
         and a.regcod = b.regcod  
         and a.regcod < 100
         and b.regcod < 100
         and b.oficod = pn_hsucor;
    exception
    when others then     
      vJAQL4963546 := 0;
    end;
    
    
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_datos_producto(vpgcod    => 1,
                                             vscsuc    => pn_sucurs,
                                             vsccta    => pn_ctacli,
                                             vscmda    => pn_moncta,
                                             vscpap    => 0,
                                             vscoper   => pn_operac,
                                             vscsbop   => pn_subope,
                                             vsctope   => pn_tipope, --in/out
                                             vscmod    => pn_modulo,
                                             pn_plazo  => vJAQL4963676,
                                             pd_fecven => ld_fecven,--vJAQL4963675,
                                             pc_ejecut => vJAQL4963677,
                                             pn_estado => ln_estado,
                                             pn_saldo  => vJAQL4963521,
                                             pd_fecape => ld_fecape,--vJAQL4963533,
                                             pd_fecori => ld_fecori,--vJAQL4963681,
                                             pd_feculm => ld_fecult--vJAQL4963641
                                             );
    end;      
    if ln_estado = 99 then
       vJAQL4963517 := 'C';
    Elsif ln_estado = 81 then
       vJAQL4963517 := 'I';
    Else
       vJAQL4963517 := 'A';
    end if; 
    vJAQL4963675 := to_number(to_char(ld_fecven,'rrrrmmdd'));         
    vJAQL4963533 := to_number(to_char(ld_fecape,'rrrrmmdd'));         
    vJAQL4963681 := to_number(to_char(ld_fecori,'rrrrmmdd'));         
    vJAQL4963641 := to_number(to_char(ld_fecult,'rrrrmmdd'));        
    
    
    vJAQL4963502 := to_char(pn_modulo); 
    vJAQL4963566 := to_char(pn_tipope); 
    vJAQL4963548 := substr(to_char(pn_cor),1,11);
    
    If lc_indoff = 'N' Then
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => pn_pgcod,
                                             pn_hcmod => pn_hcmod,
                                             pn_htran => pn_htran,
                                             pn_tipo1 => pn_tipo1,
                                             pn_tipo2 => pn_tipo2
                                            );
      end;   
   Else
      begin
        -- Call the procedure
        pq_op_asientos_mplus.sp_ah_param_trx(pn_pgcod => ln_pgcod,
                                             pn_hcmod => ln_hcmod,
                                             pn_htran => ln_htran,
                                             pn_tipo1 => pn_tipo1,
                                             pn_tipo2 => pn_tipo2
                                            );
      end;      
   End If;
    If lc_indoff = 'N' Then
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_ah_datos_trama(pn_pgcod  => pn_pgcod,
                                                 pn_hcmod  => pn_hcmod,
                                                 pn_hsucor => pn_hsucor,
                                                 pn_htran  => pn_htran,
                                                 pn_hnrel  => pn_hnrel,
                                                 pd_fecpro => pd_fecpro,
                                                 pn_tipo2  => pn_tipo2,
                                                 pn_codpet => pn_codpet,
                                                 pc_coderr => pc_coderr,
                                                 pc_deserr => pc_deserr
                                                 );
        end;  
    Else
        pc_coderr := '0';
    End If;        
    vJAQL4963527 := to_number(pc_coderr);
    
    
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_cl_datos_cliente(pn_pais   => ln_pais,
                                               pn_tipo   => ln_tipo,
                                               pc_numero => lc_docu,
                                               pc_tipper => vJAQL4963532,
                                               pc_direcc => vJAQL4963557,
                                               pc_mail   => vJAQL4963561,
                                               pc_telef1 => vJAQL4963558,
                                               pc_telef2 => vJAQL4963559,
                                               pc_segmen => vJAQL4963620,
                                               pn_fecalt => vJAQL4963535
                                               );
    end;
               
   -- indicador reverso 
    if ln_valida = 2 then
       vJAQL4963511 := 'S';
    else
       vJAQL4963511 := 'N';
    end if;    
    
   --fecha hora transmision
   If lc_indoff = 'N' Then
      vJAQL4963509 := to_number(to_char(pd_fecpro,'rrrrmmdd'));          
   Else
      vJAQL4963509 := to_number(to_char(trunc(sysdate),'rrrrmmdd'));          
   End If;        
     
    vJAQL4963510 := to_number(replace(pc_hora,':',''));                
    
   If lc_indoff = 'N' Then

      pq_op_asientos_mplus.sp_ah_moneda_trx(pn_pgcod  => pn_pgcod,
                                            pn_hcmod  => pn_hcmod,
                                            pn_hsucor => pn_hsucor,
                                            pn_htran  => pn_htran,
                                            pn_hnrel  => pn_hnrel,
                                            pn_moncta => pn_moncta,
                                            pn_monope => ln_monope,
                                            pc_indtic => lc_indtic                                                          
                                            );                                                             
   Else   
       ln_monope := pn_monope;  
   End If;
   
    --moneda de la operacion trx
   If ln_monope = 0 Then
      vJAQL4963516 := 604;
   Else
      vJAQL4963516 := 840;
   End If;      
   
   If ln_monope = 101 and lc_indtic = 'N' then   

      vJAQL4963508 := pn_monto; --monto en moneda de la trx
      
   ElsiF ln_monope = 101 and lc_indtic = 'S' then 
      vJAQL4963508 := round(pn_monto/ fn_tipo_cambio(fecha  => pd_fecpro,
                                                     monori => 0,
                                                     mondes => ln_monope,
                                                     tipo   => 500
                                                     ),2);--monto en moneda de la trx
   ElsiF ln_monope = 0 and lc_indtic = 'S' then       

      vJAQL4963508 := round(pn_monto* fn_tipo_cambio(fecha  => pd_fecpro,
                                                     monori => 101,
                                                     mondes => ln_monope,
                                                     tipo   => 500
                                                     ),2);          
   Else
      vJAQL4963508 := pn_monto;  
   End If;   
   
   
  -- vJAQL4963508 := pn_monto; 
   vJAQL4963518 := pc_uing; 
   
   If ((pn_codord = 7 or (pn_hcmod = 50 and pn_htran = 540)) and pn_tipo2 = 1) then --ordinal y canal
      vJAQL4963567 := pn_monto;
   Else
      vJAQL4963567 := 0;
   End if; 
   
   vJAQL4963549 := 0; 
   
   if (pn_hcmod = 50 and pn_htran = 540) then --monto cheque de otro banco
       vJAQL4963550 := pn_monto;
   else    
       vJAQL4963550 := 0;
   end if;
   
   if pn_modulo = 21 then
      vJAQL4963540 := lpad(pn_ctacli,9,'0')||lpad(pn_modulo,3,'0')||lpad(pn_moncta,3,'0')||lpad(pn_subope,2,'0')||lpad(pn_tipope,3,'0');
   else  
      vJAQL4963540 := lpad(pn_ctacli,9,'0')||lpad(pn_modulo,3,'0')||lpad(pn_moncta,3,'0')||lpad(pn_operac,9,'0')||lpad(pn_tipope,3,'0');                
   End if;
   if pn_tipope = 2 then
       begin 
          select i2mod, 
                 i2suc,
                 i2mda, 
                 i2pap, 
                 i2cta, 
                 i2oper,
                 i2sbop,
                 i2tope
            into ln_i2mod, 
                 ln_i2suc,
                 ln_i2mda, 
                 ln_i2pap, 
                 ln_i2cta, 
                 ln_i2oper,
                 ln_i2sbop,
                 ln_i2tope
            from fsr111 a 
           where a.inscod = 7
             and i1cod  = 1
             and i1mod  = pn_modulo
             and i1suc  = pn_sucurs
             and i1mda  = pn_moncta
             and i1pap  = 0
             and i1cta  = pn_ctacli
             and i1oper = pn_operac  
             and i1sbop = pn_subope 
             and i1tope = pn_tipope;
             
           vJAQL4963670 := lpad(ln_i2cta,9,'0')||lpad(ln_i2mod,3,'0')||lpad(ln_i2mda,3,'0')||lpad(ln_i2sbop,2,'0')||lpad(ln_i2tope,3,'0'); 
        exception 
        when others then     
         vJAQL4963670 := vJAQL4963540;  
        end;
        vJAQL4963674 := '1';
    else
        vJAQL4963670 := vJAQL4963540; 
        vJAQL4963674 := '3';  
    end if;
    
    if  pn_ctacli <> ln_i2cta then  
      
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_cl_cliente(pn_ctacli => ln_i2cta,
                                             pn_pais   => ln_paisb,
                                             pn_tipo   => ln_tipob,
                                             pc_numero => lc_docub,
                                             pc_nombre => lc_null
                                             );
        end;      
        
        vJAQL4963671 := lpad(trim(to_char(ln_tipob)),3,'0') || lpad(trim(lc_docub),12,'0');    
    else
       vJAQL4963671 := lpad(trim(to_char(ln_tipo)),3,'0') || lpad(trim(lc_docu),12,'0');      
    end if;
    
    begin
    --tasa de interes del dpf 
    pq_segmentacion_clientes_pas.sp_tasa(vpgcod  => 1,
                                         vscsuc  => pn_sucurs,
                                         vsccta  => pn_ctacli,
                                         vscmda  => pn_moncta,
                                         vscpap  => 0,
                                         vscoper => pn_operac,
                                         vscsbop => pn_subope,
                                         vsctope => pn_tipope,
                                         vscmod  => pn_modulo,
                                         tasa    => vJAQL4963672
                                         );    
    end;                                         

    begin 
          select '2'--no
            into vJAQL4963673
            from fsr111 a 
           where a.inscod in (4,6)
             and i1cod  = 1
             and i1mod  = pn_modulo
             and i1suc  = pn_sucurs
             and i1mda  = pn_moncta
             and i1pap  = 0
             and i1cta  = pn_ctacli
             and i1oper = pn_operac  
             and i1sbop = pn_subope 
             and i1tope = pn_tipope
             and a.i2mod = 21;   --significa que no renueva automaticamente                     
    exception 
    when others then     
       vJAQL4963673 := '1'; --si
    end;    
             
    vJAQL4963503 := pn_tipo2;
    vJAQL4963597 := '+';

    -- es trabajador?
    lc_pfebco := pq_op_asientos_mplus.fn_cl_estrabajador(pn_pais   => ln_pais,
                                                         pn_tipo   => ln_tipo,
                                                         pc_numero => lc_docu
                                                        );
    
    if lc_pfebco = 'S' then
      vJAQL4963640 := lpad(trim(to_char(ln_tipo)),3,'0') || lpad(trim(lc_docu),12,'0');    
    else
      vJAQL4963640 := null;
    end if;    
    
    if pn_tipo1 = 1 then
       vJAQL4963544 := 'D';
    elsif pn_tipo2 = 2 then
       vJAQL4963544 := 'C';     
    else
       vJAQL4963544 := 'O';  
    end if; 
      
     begin
         select substr(b.locnom,1,30) 
           into vJAQL4963520
           from fst001 a,
                fst070 b
          where a.pgcod  = 1
            and b.pais   = 604
            and a.sucurs = pn_hsucor
            and a.scciud = b.loccod
            and a.scdept = b.depcod;        
     exception
     when others then
       vJAQL4963520 := null;
     end;     
     
    --id de terminal
      -- Call the procedure
       If lc_indoff = 'N' Then   
          If ln_valida = 2 and pn_hcmod > 500 then
              
              PQ_OP_ASIENTOS_MPLUS.sp_ah_trx_ori(pn_pgcod    => pn_pgcod,
                                                 pn_hcmod    => pn_hcmod,
                                                 pn_hsucor   => pn_hsucor,
                                                 pn_htran    => pn_htran,
                                                 pn_hnrel    => pn_hnrel,
                                                 pd_fecpro   => pd_fecpro,
                                                 pn_hcmod_o  => pn_hcmod_o,
                                                 pn_hnrel_o  => pn_hnrel_o,
                                                 pd_fecpro_o => pd_fecpro_o
                                                );
                                                      
              
              PQ_OP_ASIENTOS_MPLUS.sp_ah_id_terminal(pn_pgcod  => pn_pgcod,
                                                     pn_hcmod  => pn_hcmod_o,
                                                     pn_hsucor => pn_hsucor,
                                                     pn_htran  => pn_htran,
                                                     pn_hnrel  => pn_hnrel_o,
                                                     pd_fecpro => pd_fecpro_o,
                                                     pc_uing   => pc_uing,  
                                                     pc_numtar => lc_numtar,                                           
                                                     pc_idterm => pc_idterm,
                                                     pc_locali => pc_locali,
                                                     pc_cocom  => pc_cocom
                                                     );
        Else                                             
            PQ_OP_ASIENTOS_MPLUS.sp_ah_id_terminal(pn_pgcod  => pn_pgcod,
                                                   pn_hcmod  => pn_hcmod,
                                                   pn_hsucor => pn_hsucor,
                                                   pn_htran  => pn_htran,
                                                   pn_hnrel  => pn_hnrel,
                                                   pd_fecpro => pd_fecpro,
                                                   pc_uing   => pc_uing,  
                                                   pc_numtar => lc_numtar,                                           
                                                   pc_idterm => pc_idterm,
                                                   pc_locali => pc_locali,
                                                   pc_cocom  => pc_cocom
                                                   );    
        end If;   
      Else
        If ln_valida = 2 then
            --buscamos trx original de offline
            PQ_OP_ASIENTOS_MPLUS.sp_ah_datos_trx_ori_off(pn_numtar => lc_numtar,
                                                         pn_codtra => pn_tipo,
                                                         pd_fecpro => pd_fecpro,                                                                      
                                                         pn_traori => pn_condtra_ori
                                                         );
            PQ_OP_ASIENTOS_MPLUS.sp_ah_datos_ter_off(pn_codtra => pn_condtra_ori,
                                                     pc_idterm => lc_idterm,  
                                                     pc_locali => lc_locali,
                                                     pc_valant => lc_valant,
                                                     pc_valact => lc_valact,
                                                     pc_numero => lc_MMC        
                                                     );                                                           
        Else
            PQ_OP_ASIENTOS_MPLUS.sp_ah_datos_ter_off(pn_codtra => pn_tipo,
                                                     pc_idterm => lc_idterm,  
                                                     pc_locali => lc_locali,
                                                     pc_valant => lc_valant,
                                                     pc_valact => lc_valact,
                                                     pc_numero => lc_MMC       
                                                     );        
        End If;                                                     
            
      End If;    

    If lc_indoff = 'N' Then   
      If pn_tipo2 <> 5 then
         vJAQL4963519 := pc_idterm;    
      Else
         vJAQL4963519 := trim(pc_valant);    
      End If;
      -- agencia
       If pn_tipo2 = 3 Then  --corresponsal
          vJAQL4963505 := TRIM(pc_cocom); 
       Elsif pn_tipo2 = 2 Then --atm
          vJAQL4963505 := TRIM(pc_idterm);--
       Elsif pn_tipo2 = 1 Then --ventanilla
          vJAQL4963505 := pn_hsucor;--
       Else
          vJAQL4963505 := trim(pc_valact);--
       End If;      
    Else
      If pn_tipo2 <> 5 then
         vJAQL4963519 := lc_idterm;    
      Else
         vJAQL4963519 := trim(lc_valant);    
      End If;  
      -- agencia
       If pn_tipo2 = 3 Then  --corresponsal
          vJAQL4963505 := TRIM(pc_cocom); 
       Elsif pn_tipo2 = 2 Then --atm
          vJAQL4963505 := TRIM(lc_idterm);--
       Elsif pn_tipo2 = 1 Then --ventanilla
          vJAQL4963505 := ln_hsucor;--
       Else
          vJAQL4963505 := trim(lc_valact);--
       End If;           
    End If;         
    
    vJAQL4963576 := pc_uing;
    vJAQL4963529 := '0';
    vJAQL4963563 := to_char(pd_fecpro,'rrmmdd')||lpad(to_char(pn_hcmod),3,'0')||lpad(to_char(pn_htran),3,'0')||lpad(to_char(pn_hsucor),3,'0')||lpad(to_char(pn_hnrel),4,'0');              
    vJAQL4963515 := lc_pfebco;
    vJAQL4963522 := lpad(trim(lc_docu),12,'0');
    vJAQL4963537 := pn_sucurs;   
    vJAQL4963523 := lc_nombre;--nombre origen

    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_datos_transferencia(pn_pgcod  => pn_pgcod,
                                                  pn_hcmod  => pn_hcmod,
                                                  pn_hsucor => pn_hsucor,
                                                  pn_htran  => pn_htran,
                                                  pn_hnrel  => pn_hnrel,
                                                  pd_fecpro => pd_fecpro,
                                                  pc_indemd => lc_indemd,
                                                  pc_codcld => lc_codcld,
                                                  pc_sucapd => lc_sucapd,
                                                  pc_nomtid => lc_nomtid,
                                                  pc_idclid => lc_idclid,
                                                  pc_ctades => lc_null,
                                                  pc_bcodes => lc_null,
                                                  pc_sucdes => lc_null             
                                                  );
    end;    
    
    vJAQL4963538 := lc_indemd;
    vJAQL4963539 := lc_codcld;
    vJAQL4963596 := lc_sucapd;
    vJAQL4963524 := lc_nomtid;
    vJAQL4963598 := lc_idclid;
    --vJAQL496BYTEF := 'ByteF';
    
    if lc_indtra = 'S' then
        begin
          insert into jaql496(JAQL496CORR, 
                              JAQL4963507,
                              JAQL4963545,
                              JAQL4963501, 
                              JAQL4963505, 
                              JAQL4963614, 
                              JAQL4963546, 
                              JAQL4963502, 
                              JAQL4963566, 
                              JAQL4963548, 
                              JAQL4963527, 
                              JAQL4963532, 
                              JAQL4963511, 
                              JAQL4963509, 
                              JAQL4963510, 
                              JAQL4963516, 
                              JAQL4963508, 
                              JAQL4963518, 
                              JAQL4963567, 
                              JAQL4963549, 
                              JAQL4963550, 
                              JAQL4963540, 
                              JAQL4963670, 
                              JAQL4963671, 
                              JAQL4963672, 
                              JAQL4963673, 
                              JAQL4963674, 
                              JAQL4963675, 
                              JAQL4963676, 
                              JAQL4963677, 
                              JAQL4963678, 
                              JAQL4963503, 
                              JAQL4963515, 
                              JAQL4963538, 
                              JAQL4963640, 
                              JAQL4963544, 
                              JAQL4963517, 
                              JAQL4963597, 
                              JAQL4963521, 
                              JAQL4963520, 
                              JAQL4963533, 
                              JAQL4963681, 
                              JAQL4963519, 
                              JAQL4963522, 
                              JAQL4963539, 
                              JAQL4963537, 
                              JAQL4963596, 
                              JAQL4963615, 
                              JAQL4963536, 
                              JAQL4963554, 
                              JAQL4963556, 
                              JAQL4963523, 
                              JAQL4963524, 
                              JAQL4963557, 
                              JAQL4963558, 
                              JAQL4963559, 
                              JAQL4963560, 
                              JAQL4963561, 
                              JAQL4963535, 
                              JAQL4963620, 
                              JAQL4963563, 
                              JAQL4963576, 
                              JAQL4963579, 
                              JAQL4963598, 
                              JAQL4963529, 
                              JAQL4963530, 
                              JAQL4963534, 
                              JAQL4963641, 
                              JAQL4963506, 
                              JAQL4963750, 
                              JAQL4963751, 
                              JAQL4963752, 
                              JAQL4963753, 
                              JAQL4963754/*, 
                              JAQL496BYTEF */
                             )
                      values(vJAQL496CORR, 
                             vJAQL4963507,
                             vJAQL4963545,
                             vJAQL4963501, 
                             vJAQL4963505, 
                             vJAQL4963614, 
                             vJAQL4963546, 
                             vJAQL4963502, 
                             vJAQL4963566, 
                             vJAQL4963548, 
                             vJAQL4963527, 
                             vJAQL4963532, 
                             vJAQL4963511, 
                             vJAQL4963509, 
                             vJAQL4963510, 
                             vJAQL4963516, 
                             vJAQL4963508, 
                             vJAQL4963518, 
                             vJAQL4963567, 
                             vJAQL4963549, 
                             vJAQL4963550, 
                             vJAQL4963540, 
                             vJAQL4963670, 
                             vJAQL4963671, 
                             vJAQL4963672, 
                             vJAQL4963673, 
                             vJAQL4963674, 
                             vJAQL4963675, 
                             vJAQL4963676, 
                             vJAQL4963677, 
                             vJAQL4963678, 
                             vJAQL4963503, 
                             vJAQL4963515, 
                             vJAQL4963538, 
                             vJAQL4963640, 
                             vJAQL4963544, 
                             vJAQL4963517, 
                             vJAQL4963597, 
                             vJAQL4963521, 
                             vJAQL4963520, 
                             vJAQL4963533, 
                             vJAQL4963681, 
                             vJAQL4963519, 
                             vJAQL4963522, 
                             vJAQL4963539, 
                             vJAQL4963537, 
                             vJAQL4963596, 
                             vJAQL4963615, 
                             vJAQL4963536, 
                             vJAQL4963554, 
                             vJAQL4963556, 
                             vJAQL4963523, 
                             vJAQL4963524, 
                             vJAQL4963557, 
                             vJAQL4963558, 
                             vJAQL4963559, 
                             vJAQL4963560, 
                             vJAQL4963561, 
                             vJAQL4963535, 
                             vJAQL4963620, 
                             vJAQL4963563, 
                             vJAQL4963576, 
                             vJAQL4963579, 
                             vJAQL4963598, 
                             vJAQL4963529, 
                             vJAQL4963530, 
                             vJAQL4963534, 
                             vJAQL4963641, 
                             vJAQL4963506, 
                             vJAQL4963750, 
                             vJAQL4963751, 
                             vJAQL4963752, 
                             vJAQL4963753, 
                             vJAQL4963754/*, 
                             vJAQL496BYTEF*/
                             );
        Exception
        When others then
          --lc_error := sqlerrm;                               
          null;
        end;
    end if;
    
  Exception
  When others then
    --lc_error := sqlerrm;                             
    null;
  end sp_op_carga_JAQL496;    
  
 procedure sp_op_carga_JAQL497(  pn_cor    in number, --numero correlativo
                                 pn_pgcod  in number, --pgcod
                                 pn_hcmod  in number, --hcmod
                                 pn_hsucor in number, --hsucor
                                 pn_htran  in number, --htran
                                 pn_hnrel  in number, --hnrel         
                                 pd_fecpro in date, -- fecha transaccion
                                 pc_uing   in varchar2, --usuario ingreso
                                 pc_hora   in varchar2, --hora
                                 pc_cont   in varchar2,  --estado contable 
                                 pn_corr   in number, --itcorr - (99-extornado)
                                 pn_pais   in number,
                                 pn_tipo   in number,
                                 pc_numero in varchar2,
                                 pc_valant in varchar2,
                                 pc_valact in varchar2,
                                 pc_numtar in varchar2                                                                    
                              ) is    
  vJAQL497CORR  NUMBER(18); 
  vJAQL4979000  VARCHAR2(18);
  vJAQL4979001  VARCHAR2(3);
  vJAQL4979002  VARCHAR2(15);
  vJAQL4979017  VARCHAR2(70);
  vJAQL4979067  VARCHAR2(15);
  vJAQL4979115  NUMBER(10); 
  vJAQL4979116  NUMBER(3); 
  vJAQL4979117  NUMBER(8); 
  vJAQL4979118  VARCHAR2(27);--20
  vJAQL4979119  NUMBER(5); 
  vJAQL4979010  VARCHAR2(20);
  vJAQL4979121  VARCHAR2(20);
  vJAQL4979122  NUMBER(8); 
  vJAQL4979123  NUMBER(6); 
  vJAQL4979124  VARCHAR2(2);
  vJAQL4979089  VARCHAR2(1);
  vJAQL4979125  VARCHAR2(1);
  vJAQL4979126  VARCHAR2(15);
  vJAQL4979127  VARCHAR2(10);
  vJAQL4979128  VARCHAR2(1);
  vJAQL4979129  VARCHAR2(3);
  vJAQL4979130  VARCHAR2(20);
  vJAQL4979180  NUMBER(4); 
  vJAQL4979181  VARCHAR2(1);
  vJAQL4979152  VARCHAR2(1);
  vJAQL4979155  VARCHAR2(1);
  vJAQL4979184  NUMBER(2); 
  vJAQL4979198  VARCHAR2(40);
  vJAQL4979199  VARCHAR2(40); 
  vJAQL4979200  VARCHAR2(40);
  vJAQL4979201  VARCHAR2(40);
  vJAQL4979202  VARCHAR2(40);
  vJAQL4979203  NUMBER(14,2); 
  vJAQL4979204  NUMBER(14,2); 
  vJAQL4979205  NUMBER(14,2); 
  vJAQL4979206  NUMBER(14,2); 
  vJAQL4979207  NUMBER(14,2);      
  
  ln_pais   fsr008.pepais%type;  
  ln_tipo   fsr008.petdoc%type;
  lc_docu   fsr008.pendoc%type;     
  ln_chetcn number;
  --lc_error varchar2(400); 
  
  LN_PGCOD  FSD011.PGCOD%type;
  LN_SCSUC  FSD011.SCSUC%type;
  LN_SCMOD  FSD011.SCMOD%type;
  LN_SCMDA  FSD011.SCMDA%type;
  LN_SCPAP  FSD011.SCPAP%type;
  LN_SCCTA  FSD011.SCCTA%type;
  LN_SCSBOP FSD011.SCSBOP%type;
  LN_SCOPER FSD011.SCOPER%type;
  LN_SCTOPE FSD011.SCTOPE%type;                              
 
  lc_indtra char(1):='N';
  lc_itwing char(10):=null;
  ln_codemp number(3);
  ln_codmod number(3);
  ln_codsuc number(3);
  ln_codtrx number(3);
  ln_codrel number(4);  
  
  begin
    vJAQL497CORR := pn_cor;
    --datos de la cuenta
    LN_PGCOD  := pn_pgcod;
    LN_SCSUC  := to_number(pc_valact);
    LN_SCMOD  := to_number(substr(pc_valant,10,3));
    LN_SCMDA  := to_number(substr(pc_valant,13,3));
    LN_SCPAP  := 0;
    LN_SCCTA  := to_number(substr(pc_valant,1,9));
    LN_SCSBOP := to_number(substr(pc_valant,16,2));
    LN_SCOPER := 0;
    LN_SCTOPE := to_number(substr(pc_valant,18,3));
    
    --validacion de trabajador
    lc_indtra  := pq_op_asientos_mplus.fn_cl_es_trabajador(LN_SCCTA);                 
    
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_cl_cliente(pn_ctacli => LN_SCCTA,
                                         pn_pais   => ln_pais,
                                         pn_tipo   => ln_tipo,
                                         pc_numero => lc_docu,
                                         pc_nombre => vJAQL4979017
                                         );
    end;  
       
      
      vJAQL4979000 := lpad(trim(to_char(ln_tipo)),3,'0') || lpad(trim(lc_docu),11,'0');
      vJAQL4979001 := lpad(trim(to_char(ln_tipo)),3,'0');
      vJAQL4979002 := lpad(trim(lc_docu),11,'0');
      vJAQL4979067 := lpad(trim(to_char(ln_tipo)),3,'0') || lpad(trim(lc_docu),11,'0');
      vJAQL4979115 := pn_pais;
      begin
        select a.chetcn
          into ln_chetcn
          from fst231 a
         where a.chetpo = to_number(pc_numero);         
      exception
      when others then   
        ln_chetcn := pn_tipo;
      end;
      vJAQL4979116 := round(pn_tipo/ln_chetcn);
           
      begin
        select to_number(to_char(a.scfval,'rrrrmmdd')) 
          into vJAQL4979117
          from fsd011 a
         where a.pgcod  = LN_PGCOD
           and a.scsuc  = LN_SCSUC
           and a.scmda  = LN_SCMDA
           and a.scpap  = LN_SCPAP
           and a.sccta  = LN_SCCTA
           and a.scoper = LN_SCOPER
           and a.scsbop = LN_SCSBOP
           and a.sctope = LN_SCTOPE
           and a.scmod  = LN_SCMOD;
      Exception
      when others then
          null;     
      end;
      
      vJAQL4979118 := substr(pc_valant,1,27);
      vJAQL4979119 := pn_hsucor;
      vJAQL4979010 := pc_uing;
      
      begin
         select substr(b.locnom,1,20) 
           into vJAQL4979121
           from fst001 a,
                fst070 b
          where a.pgcod  = LN_PGCOD
            and b.pais   = 604
            and a.sucurs = pn_hsucor
            and a.scciud = b.loccod
            and a.scdept = b.depcod;        
      exception
      when others then
        null;
      end;
      
      vJAQL4979122 := to_number(to_char(pd_fecpro,'rrrrmmdd')); 
      vJAQL4979123 := to_number(replace(pc_hora,':',''));          
      
      -- es trabajador?
      vJAQL4979089 := pq_op_asientos_mplus.fn_cl_estrabajador(pn_pais   => ln_pais,
                                                              pn_tipo   => ln_tipo,
                                                              pc_numero => lc_docu
                                                             );            
      vJAQL4979125 := substr(pc_numero,1,1);
      --vJAQL4979126 := pn_hsucor;  
      
      --obtenemos datos de la transaccion para ir a obtener el ip del usuario
      ln_codemp := to_number(substr(pc_valant,28,3));
      ln_codmod := to_number(substr(pc_valant,31,3));
      ln_codsuc := to_number(substr(pc_valant,34,3));
      ln_codtrx := to_number(substr(pc_valant,37,3));
      ln_codrel := to_number(substr(pc_valant,40,4));
      
      begin
        select a.itwing 
          into lc_itwing
          from fsd015 a 
         where a.pgcod  = ln_codemp
           and a.itsuc  = ln_codsuc 
           and a.itmod  = ln_codmod
           and a.ittran = ln_codtrx
           and a.itnrel = ln_codrel;
      exception
      when others then     
        lc_itwing := null;
      end;
      vJAQL4979126 := substr(pq_op_asientos_mplus.fn_ah_ip_usuario(lc_itwing),1,15);  
      --fin
      
      vJAQL4979127 := 1;
      vJAQL4979128 := 'N';
      vJAQL4979129 := lpad(to_char(LN_SCMDA),3,'0');
      
      begin
         select nvl(sum(REGEXP_COUNT(trim(a.chelst),'0')),0), count(1) 
           into vJAQL4979180,vJAQL4979184
           from fsd230 a 
          where a.checod = LN_PGCOD
            and a.checta = LN_SCCTA
            and nvl(REGEXP_COUNT(trim(a.chelst),'0'),0) > 0;          
      exception
      when others then
        vJAQL4979180 := 0;
        vJAQL4979184 := 0;
      end;
      
      vJAQL4979181 := 'N';
      vJAQL4979152 := 'N';
      
      If ln_pais <> 604 then
         vJAQL4979155 := 'S';
      else
         vJAQL4979155 := 'N';        
      end if;
      if lc_indtra = 'S' then
          begin
            insert into JAQL497(JAQL497CORR,
                                JAQL4979000,
                                JAQL4979001,
                                JAQL4979002,
                                JAQL4979017,
                                JAQL4979067,
                                JAQL4979115,
                                JAQL4979116,
                                JAQL4979117,
                                JAQL4979118,
                                JAQL4979119,
                                JAQL4979010,
                                JAQL4979121,
                                JAQL4979122,
                                JAQL4979123,
                                JAQL4979124,
                                JAQL4979089,
                                JAQL4979125,
                                JAQL4979126,
                                JAQL4979127,
                                JAQL4979128,
                                JAQL4979129,
                                JAQL4979130,
                                JAQL4979180,
                                JAQL4979181,
                                JAQL4979152,
                                JAQL4979155,
                                JAQL4979184,
                                JAQL4979198,
                                JAQL4979199,
                                JAQL4979200,
                                JAQL4979201,
                                JAQL4979202,
                                JAQL4979203,
                                JAQL4979204,
                                JAQL4979205,
                                JAQL4979206,
                                JAQL4979207
                               )
                        values(vJAQL497CORR,
                               vJAQL4979000,
                               vJAQL4979001,
                               vJAQL4979002,
                               vJAQL4979017,
                               vJAQL4979067,
                               vJAQL4979115,
                               vJAQL4979116,
                               vJAQL4979117,
                               vJAQL4979118,
                               vJAQL4979119,
                               vJAQL4979010,
                               vJAQL4979121,
                               vJAQL4979122,
                               vJAQL4979123,
                               vJAQL4979124,
                               vJAQL4979089,
                               vJAQL4979125,
                               vJAQL4979126,
                               vJAQL4979127,
                               vJAQL4979128,
                               vJAQL4979129,
                               vJAQL4979130,
                               vJAQL4979180,
                               vJAQL4979181,
                               vJAQL4979152,
                               vJAQL4979155,
                               vJAQL4979184,
                               vJAQL4979198,
                               vJAQL4979199,
                               vJAQL4979200,
                               vJAQL4979201,
                               vJAQL4979202,
                               vJAQL4979203,
                               vJAQL4979204,
                               vJAQL4979205,
                               vJAQL4979206,
                               vJAQL4979207
                               );      
          Exception
          When others then
            --lc_error := sqlerrm;           
            null;
          end;    
      end if;  
      
  Exception
  When others then
    --lc_error := sqlerrm;       
    null;
  end sp_op_carga_JAQL497;    
  
  procedure sp_ah_datos_jaql493(pn_ctacli     in number,
                                PN_PETDOC     OUT NUMBER,
                                PC_PENDOC     OUT VARCHAR2,
                                PC_PETIPO     OUT VARCHAR2,
                                PC_CTNOM      OUT VARCHAR2,
                                PC_SNGC13DIR  OUT VARCHAR2,
                                PC_DOTELFP    OUT VARCHAR2,
                                PC_DOTELFP1   OUT VARCHAR2,
                                PC_PEXTXT     OUT VARCHAR2,
                                PN_JAQL60CALI OUT VARCHAR2,
                                PN_PFFNAC     OUT NUMBER,
                                PC_PFLNAC     OUT VARCHAR2,
                                PC_PFCANT     OUT VARCHAR2,
                                PC_PFECIV     OUT VARCHAR2,
                                PC_SNGC60ACTE OUT VARCHAR2   
                               ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_numtarjeta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
       
  ln_pais   fsr008.pepais%type;  
  ln_tipo   fsr008.petdoc%type;
  lc_docu   fsr008.pendoc%type;
  lc_pflnac fsd002.pflnac%type;
  pn_null   number;
  begin
    
   begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_cl_cliente(pn_ctacli => pn_ctacli,
                                         pn_pais   => ln_pais,
                                         pn_tipo   => ln_tipo,
                                         pc_numero => lc_docu,
                                         pc_nombre => PC_CTNOM
                                         );
    end;      
    
    PN_PETDOC := ln_tipo;
    PC_PENDOC := lc_docu;
    
    begin
      -- Call the procedure
      pq_op_asientos_mplus.sp_cl_datos_cliente(pn_pais   => ln_pais,
                                               pn_tipo   => ln_tipo,
                                               pc_numero => lc_docu,
                                               pc_tipper => PC_PETIPO,
                                               pc_direcc => PC_SNGC13DIR,
                                               pc_mail   => PC_PEXTXT,
                                               pc_telef1 => PC_DOTELFP,
                                               pc_telef2 => PC_DOTELFP1,
                                               pc_segmen => PN_JAQL60CALI,
                                               pn_fecalt => pn_null
                                               );
    end;       
    
    if PC_PETIPO = 'N' then
        begin
          select to_number(to_char(a.pffnac,'rrrrmmdd')),
                 a.pfcant,
                 a.pflnac,
                 case
                   when a.pfeciv IN ('1', '3') then
                    'C'
                   when a.pfeciv = '2' then
                    'D'
                   when a.pfeciv IN ('4', '6') then
                    'S'
                   when a.pfeciv = '5' then
                    'V'
                   else
                    'N'
                 end          
            into PN_PFFNAC, PC_PFCANT, lc_pflnac, PC_PFECIV
            from fsd002 a
           where a.pfpais = ln_pais
             and a.pftdoc = ln_tipo
             and a.pfndoc = lc_docu;
             
           if trim(lc_pflnac) is null  then
              begin
                select substr(c.locnom,1,30)
                  into PC_PFLNAC
                  from sngc11 b,
                       FST070 c
                 where b.sngc11pais = c.pais
                   and b.sngc11dpto = c.depcod
                   and b.sngc11prov = c.loccod
                   and b.sngc11pais = ln_pais 
                   and b.sngc11tdoc = ln_tipo 
                   and b.sngc11ndoc = lc_docu
                   and rownum =1;
              exception
              when others then  
                 null;       
              end;                       
           end If;
        exception
        when others then  
           null;       
        end;          
    else
        begin
          select to_number(to_char(a.pjfcon,'rrrrmmdd'))
            into PN_PFFNAC
            from fsd003 a
           where a.pjpais = ln_pais 
             and a.pjtdoc = ln_tipo 
             and a.pjndoc = lc_docu;             
        exception
        when others then  
           null;       
        end;                
        
        begin
          select substr(c.locnom,1,30)
            into PC_PFLNAC
            from sngc11 b,
                 FST070 c
           where b.sngc11pais = c.pais
             and b.sngc11dpto = c.depcod
             and b.sngc11prov = c.loccod
             and b.sngc11pais = ln_pais 
             and b.sngc11tdoc = ln_tipo 
             and b.sngc11ndoc = lc_docu
             and rownum =1;
        exception
        when others then  
           null;       
        end;        
    end if;
    
    begin
      select a.SNGC60ACTE
        into PC_SNGC60ACTE
        from sngc60 a
       where a.sngc60pais = ln_pais 
         and a.sngc60tdoc = ln_tipo 
         and a.sngc60ndoc = lc_docu;             
    exception
    when others then  
       null;       
    end;            

  Exception
  When Others then
   null;  
  end sp_ah_datos_jaql493;
  procedure sp_tasa(vpgcod  number,
                    vScsuc  number,
                    vSccta  number,
                    vScmda  number,
                    vScpap  number,
                    vScoper number,
                    vScsbop number,
                    vSctope number,
                    vScmod  number,
                    tasa    out number) is
  
  PRAGMA AUTONOMOUS_TRANSACTION;                                                                      
  begin

  -- Call the procedure
  pq_segmentacion_clientes_pas.sp_tasa(vpgcod  => vpgcod,
                                       vscsuc  => vscsuc,
                                       vsccta  => vsccta,
                                       vscmda  => vscmda,
                                       vscpap  => vscpap,
                                       vscoper => vscoper,
                                       vscsbop => vscsbop,
                                       vsctope => vsctope,
                                       vscmod  => vscmod,
                                       tasa    => tasa
                                       );
  exception
  when others then
    tasa := 0;
  end sp_tasa;   
  procedure sp_datos_producto(vpgcod  in number,
                              vScsuc  in number,
                              vSccta  in number,
                              vScmda  in number,
                              vScpap  in number,
                              vScoper in number,
                              vScsbop in number,
                              vSctope in out number,
                              vScmod  in number,
                              pn_plazo  out number,
                              pd_fecven out date,
                              pc_ejecut out varchar2,
                              pn_estado out number,
                              pn_saldo  out number,
                              pd_fecape out date,
                              pd_fecori out date,
                              pd_feculm out date
                             ) is
  ld_fecval   date;
  ld_feccon   date;
  tipo        char(2);
  ln_suc      number(3);
                             
  begin
    
      begin
        select a.scfval, 
               a.scfval, 
               0, 
               null,                
               a.scstat,
               a.scfulm,
               a.scfval,
               a.scfcon,
               a.sctope               
          into pd_fecape, 
               pd_fecori, 
               pn_plazo, 
               pd_fecven, 
               pn_estado,
               pd_feculm,
               ld_fecval,
               ld_feccon,
               vSctope
          from fsd011 a
         where a.pgcod  = vpgcod
           and a.scsuc  = vScsuc
           and a.scmda  = vScmda
           and a.scpap  = vScpap
           and a.sccta  = vSccta
           and a.scoper = vScoper
           and a.scsbop = vScsbop
           --and a.sctope = vSctope
           and a.scmod  = vScmod;
      end;
    if vScmod = 22 then   
        select a.Aofval, 
               a.aopzo, 
               a.aofvto,
               a.aostat
          into pd_fecape, 
               pn_plazo, 
               pd_fecven, 
               pn_estado
          from fsd010 a
         where a.pgcod  = vpgcod
           and a.aosuc  = vScsuc
           and a.aomda  = vScmda
           and a.aopap  = vScpap
           and a.aocta  = vSccta
           and a.aooper = vScoper
           and a.aosbop = vScsbop
           and a.aotope = vSctope
           and a.aomod  = vScmod;      
    end if;
    
    If vScmod = 21 Then 
           begin
            select sum(a.scsdo)
              into pn_saldo
              from fsd011 a
             where a.pgcod  = vpgcod
               and a.scmda  = vScmda
               and a.scmod in (21,157,136)
               and a.sccta  = vSccta
               and a.scsuc  = vScsuc
               and a.scsbop = vScsbop
               and a.scoper = vScoper
               and a.scpap  = vScpap
               and a.scstat <> 99;
           Exception
           When others then
             pn_saldo := 0;
           End;            
                                 
    Else
           begin
            select sum(a.scsdo)
              into pn_saldo
              from fsd011 a
             where a.pgcod  = vpgcod
               and a.scmda  = vScmda
               and a.scsuc  = vScsuc
               and a.scmod  = 426
               and a.sccta  = vSccta
               and a.scoper = vScoper
               and a.scpap  = vScpap
               and a.scstat <> 99;
          Exception
          When others then      
               pn_saldo := 0;       
          end;
                             
          begin
            select min(a.aofval)         
              into pd_fecori
              from fsd010 a
             where a.pgcod  = vpgcod
               and a.aomda  = vScmda
               and a.aomod  = vScmod
               and a.aosuc  = vScsuc
               and a.aocta  = vSccta
               and a.aooper = vScoper
               and a.aopap  = vScpap;
          Exception
          When others then
             null;
          end;          
   End If;    
   
  if ld_fecval <> ld_feccon then
    tipo := 'AC';
  else
    tipo := 'AP';
  End if;   
    
  
  -- Call the procedure
  productividad_pasiva.agente(vpgcod      => vpgcod,
                              vscmod      => vscmod,
                              vscsuc      => vscsuc,
                              vscmda      => vscmda,
                              vscpap      => vscpap,
                              vsccta      => vsccta,
                              vscoper     => vscoper,
                              vscsbop     => vscsbop,
                              vsctope     => vsctope,
                              vscfval     => ld_fecval,
                              tipo        => tipo,
                              vjaql61user => pc_ejecut,
                              vubsuc      => ln_suc
                              );    
  exception
  when others then                            
    null;
  end sp_datos_producto; 
  Procedure sp_datos_transferencia(pn_pgcod  in number, --pgcod
                                   pn_hcmod  in number, --hcmod
                                   pn_hsucor in number, --hsucor
                                   pn_htran  in number, --htran
                                   pn_hnrel  in number,  --hnrel    
                                   pd_fecpro in date, 
                                   pc_indemd out varchar2,
                                   pc_codcld out varchar2,    
                                   pc_sucapd out varchar2,    
                                   pc_nomtid out varchar2,
                                   pc_idclid out varchar2,
                                   pc_ctades out varchar2,
                                   pc_bcodes out varchar2,
                                   pc_sucdes out varchar2  
                                  ) is
  ln_ctades fsd011.sccta%type; 
  ln_sucdes fsd011.scsuc%type;      
  ln_pais   fsr008.pepais%type;      
  ln_tipo   fsr008.petdoc%type;      
  lc_docu   fsr008.pendoc%type;   
  lc_pfebco fsd002.pfebco%type;              
  lc_nombre fsd008.ctnom%type;   
  ln_moneda fsd011.scmda%type; 
  ln_subo   fsd011.scsbop%type; 
  ln_tope   fsd011.sctope%type;         
  begin
    if pn_hcmod = 50 and pn_htran = 599 then --ventanilla
      begin
        select a.ctnro, a.itsucd, a.moneda, a.itsubo, a.ittope
          into ln_ctades, ln_sucdes, ln_moneda, ln_subo, ln_tope  
          from fsd016 a 
         where a.pgcod  = pn_pgcod
           and a.itsuc  = pn_hsucor
           and a.itmod  = pn_hcmod
           and a.ittran = pn_htran
           and a.itnrel = pn_hnrel
           and a.itord  = 26;
      exception
      when others then  
        ln_ctades := 0;
        ln_sucdes := 0;
        ln_moneda := 0; 
        ln_subo   := 0;
      end;
      
    end if;
    if (pn_hcmod = 140 and pn_htran in (10,15)) --HB
        or  
       (pn_hcmod = 66 and pn_htran in (30,33)) --cajeros
        or
       (pn_hcmod = 489 and pn_htran in (10,15)) --movil
    then
      begin
        select a.ctnro, a.itsucd, a.moneda, a.itsubo, a.ittope
          into ln_ctades, ln_sucdes, ln_moneda, ln_subo , ln_tope  
          from fsd016 a 
         where a.pgcod  = pn_pgcod
           and a.itsuc  = pn_hsucor
           and a.itmod  = pn_hcmod
           and a.ittran = pn_htran
           and a.itnrel = pn_hnrel
           and a.itord  = 20;        
      exception
      when others then  
        ln_ctades := 0;
        ln_sucdes := 0;
        ln_moneda := 0; 
        ln_subo   := 0;        
      end;      
    end if;    
    
    if ln_ctades <> 0 then
      
        begin
          -- Call the procedure
          pq_op_asientos_mplus.sp_cl_cliente(pn_ctacli => ln_ctades,
                                             pn_pais   => ln_pais,
                                             pn_tipo   => ln_tipo,
                                             pc_numero => lc_docu,
                                             pc_nombre => lc_nombre
                                             );
        end;      
    
        -- es trabajador?
        lc_pfebco := pq_op_asientos_mplus.fn_cl_estrabajador(pn_pais   => ln_pais,
                                                             pn_tipo   => ln_tipo,
                                                             pc_numero => lc_docu
                                                            );    
   
    
        pc_indemd := lc_pfebco;
        pc_codcld := lpad(trim(lc_docu),12,'0');
        pc_sucapd := ln_sucdes;
        pc_nomtid := lc_nombre;
        pc_idclid := lpad(trim(to_char(ln_tipo)),2,'0') || lpad(trim(lc_docu),12,'0');
        pc_ctades := lpad(ln_ctades,9,'0')||lpad('21',3,'0')||lpad(ln_moneda,3,'0')||lpad(ln_subo,2,'0')||lpad(ln_tope,3,'0');        
        
        begin
            select to_char(a.se115bcods),
                   to_char(a.se115bsuds)
              into pc_bcodes, 
                   pc_sucdes
              from fse115 a
             where a.se115cd = pn_pgcod
               and a.se115su = pn_hsucor   
               and a.se115md = pn_hcmod   
               and a.se115tr = pn_htran   
               and a.se115re = pn_hnrel    
               and a.se115fc = pd_fecpro; 
        exception
        when others then  
          pc_bcodes := '0';        
          pc_sucdes := '0';
        end;
    end if;
  exception
  when others then
    null;    
  end sp_datos_transferencia;                                                                        
  
  Procedure sp_cl_cliente(PN_CTACLI IN NUMBER,
                          pn_pais   out number,
                          pn_tipo   out number,
                          pc_numero out char, 
                          pc_nombre out char        
                         ) is
  begin
    select a.pepais,a.PETDOC,a.PENDOC, b.ctnom
      into pn_pais,pn_tipo,pc_numero, pc_nombre
      from fsr008 a,
           fsd008 b
     where a.pgcod = b.pgcod
       and a.ctnro = b.ctnro
       and a.pgcod = 1
       and a.ctnro = pn_ctacli
       and a.ttcod = 1
       and a.cttfir = 'T';
  exception
  when others then
     pn_pais   := 0;
     pn_tipo   := 0;
     pc_numero := 0;
     pc_nombre := null;
  end sp_cl_cliente; 
  function fn_cl_estrabajador(pn_pais   in number,
                              pn_tipo   in number,
                              pc_numero in char
                              ) return char is
  lc_pfebco fsd002.pfebco%type;                              
  begin
      select nvl(trim(A.PFEBCO),'N')      
        into lc_pfebco
        from fsd002 a 
       where a.pfpais = pn_pais
         and a.pftdoc = pn_tipo
         and a.pfndoc = pc_numero;
  return lc_pfebco;
  exception
  when others then     
    lc_pfebco := 'N'; 
    return lc_pfebco;
  end fn_cl_estrabajador;    
      
  Procedure sp_cl_datos_cliente(PN_PAIS   IN NUMBER,
                                PN_TIPO   IN NUMBER,
                                PC_NUMERO IN CHAR,
                                pc_tipper out char,
                                pc_direcc out char,
                                pc_mail   out char,
                                pc_telef1 out char,
                                pc_telef2 out char,
                                pc_segmen out char,
                                pn_fecalt out number
                              ) is
  cursor c_telefonos(pn_pais in number,pn_tipo in number,pc_docu in char) is 
    select a.docod,b.sngc16ttel, a.dotelfp 
      from fsr005 a, 
           sngc17 b
     where a.pepais = b.sngc17pais
       and a.petdoc = b.sngc17tdoc
       and a.pendoc = b.sngc17ndoc
       and a.docod  = b.sngc17dcod
       and a.doordp = b.sngc17corr
       and a.pepais = pn_pais
       and a.petdoc = pn_tipo
       and a.pendoc = pc_docu
  order by a.docod;  
  begin
    for i in c_telefonos(PN_PAIS,PN_TIPO,PC_NUMERO) loop
      if i.docod = 1 and i.sngc16ttel = 2 then
         pc_telef1 := substr(trim(i.dotelfp),1,12);
      end if;
      if i.sngc16ttel <> 2 and nvl(pc_telef1,'X') <> substr(trim(i.dotelfp),1,12) then
         pc_telef2 := substr(trim(i.dotelfp),1,12);
      end if;           
    end loop;
       
    begin
      select substr(a.pextxt,1,instr(a.pextxt,'\',1)-1) 
        into pc_mail
        from fsx001 a
       where a.pepais = PN_PAIS 
         and a.petdoc = PN_TIPO 
         and a.pendoc = PC_NUMERO
         and a.txcod  = 0;         
    exception
    when others then  
       null;       
    end;
    
    begin
      select CASE
             When a.jaql60cali = 'A' then
               1
             When a.jaql60cali = 'B' then
               2
             When a.jaql60cali = 'C' then
               3
             When a.jaql60cali = 'D' then
               4
             Else
               5
             End        
        into pc_segmen
        from jaql060 a
       where a.jaql60pgco = 1
         and a.jaql60pais = PN_PAIS 
         and a.jaql60tdoc = PN_TIPO 
         and a.jaql60ndoc = PC_NUMERO;
    exception
    when others then  
       null;       
    end;    
    begin
      select substr(a.sngc13dir,1,35)
        into pc_direcc
        from sngc13 a
       where a.sngc13pais = PN_PAIS
         and a.sngc13tdoc = PN_TIPO
         and a.sngc13ndoc = PC_NUMERO
         and a.docod      = 1
         and a.sngc13est  = 'H';
    exception
    when others then  
       null; 
    end;    
    begin
      select decode(a.petipo,'F','N',a.petipo),to_number(to_char(a.pefalt,'rrrrmmdd')) 
        into pc_tipper, pn_fecalt
        from fsd001 a
       where a.pepais = PN_PAIS
         and a.petdoc = PN_TIPO
         and a.pendoc = PC_NUMERO;
    exception
    when others then  
       null; 
    end;   
  exception
  when others then     
    null;
  end sp_cl_datos_cliente;  
        
  function fn_cl_es_trabajador(P_N_CTACLI IN NUMBER) return varchar2 is    
    lc_indtra char(1):='N';  
  begin                                      
     select nvl(trim(b.pfebco),'N')
       into lc_indtra 
       from fsr008 a,
            fsd002 b 
      where a.pepais = b.pfpais
--        and b.pftdoc = b.pftdoc
        and a.petdoc = b.pftdoc--01062020
        and a.pendoc = b.pfndoc
        and a.pgcod  = 1
        and a.ctnro  = P_N_CTACLI;
    return lc_indtra;                                    
  exception
  when others then
    return 'N';                      
  end fn_cl_es_trabajador; 
  
  FUNCTION fn_ah_ip_usuario(P_C_IPHEX IN VARCHAR2) RETURN VARCHAR2 IS
    lv_ipusr varchar2(15):=null;
    lv_ip  varchar2(2):=null;
  BEGIN
    for i in 1..length(P_C_IPHEX) loop
      if substr(P_C_IPHEX,i,1) <> '.' then
         lv_ip := lv_ip ||substr(P_C_IPHEX,i,1);
      else
         lv_ipusr := lv_ipusr||pq_op_asientos_mplus.hex2dec(lv_ip)||'.';
         lv_ip    := null;
      end if;    
    end loop;
    if lv_ip is not null then
       lv_ipusr := lv_ipusr||pq_op_asientos_mplus.hex2dec(lv_ip);
    End If;  
    return lv_ipusr;
  Exception 
  when others then
    lv_ipusr := null;  
    return lv_ipusr;
  END fn_ah_ip_usuario;  
  
  FUNCTION hex2dec (hexnum IN CHAR) RETURN NUMBER IS
    i                 NUMBER;
    digits            NUMBER;
    result            NUMBER := 0;
    current_digit     CHAR(1);
    current_digit_dec NUMBER;
  BEGIN
    digits := LENGTH(hexnum);
    FOR i IN 1..digits LOOP
       current_digit := SUBSTR(hexnum, i, 1);
       IF current_digit IN ('A','B','C','D','E','F') THEN
          current_digit_dec := ASCII(current_digit) - ASCII('A') + 10;
       ELSE
          current_digit_dec := TO_NUMBER(current_digit);
       END IF;
       result := (result * 16) + current_digit_dec;
    END LOOP;
    RETURN result;
  END hex2dec;                       
end PQ_OP_ASIENTOS_MPLUS;
/
