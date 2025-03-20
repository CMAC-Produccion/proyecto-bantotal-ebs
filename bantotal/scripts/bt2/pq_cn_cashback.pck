create or replace package PQ_CN_CASHBACK is

  -- *****************************************************************
  -- Nombre                     : PQ_CN_CASHBACK
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CANALES
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.05.22
  -- Autor de Creación          : Renzo Cuadros Salazar
  -- Uso                        : Optimizacion del proceso de cashback
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.06.11
  -- Autor de Modificación      : Renzo Cuadros Salazar
  -- Descripción Modificación   : Se agrega transaccion 87 (Paga Rápido) al conteo de compras
  -- Fecha de Modificación      : 
  -- Autor de Modificación      : 
  -- Descripción Modificación   :
  -- *****************************************************************
                                
  procedure sp_obtener_compras( P_N_FECPRO IN DATE,
                                P_C_USUARIO IN VARCHAR2,
                                P_C_MSGRES OUT VARCHAR2
                              );    
  procedure sp_contar_compras( P_N_FECINI IN DATE,
                               P_N_FECFIN IN DATE,
                               P_C_CUENTA IN NUMBER,
                               P_N_CONTEO OUT NUMBER                               
                              );                                                                                
end PQ_CN_CASHBACK;
/

create or replace package body PQ_CN_CASHBACK is

procedure sp_obtener_compras( P_N_FECPRO IN DATE,
                              P_C_USUARIO IN VARCHAR2,
                              P_C_MSGRES OUT VARCHAR2
                             ) is                                     
  begin
    
    delete from AQPC312;
    commit;
    
    insert into AQPC312
    (AQPC312USUREG, AQPC312FECREG, AQPC312NUMCOR, AQPC312PGCOD, AQPC312HCMOD, 
     AQPC312HSUCOR, AQPC312HTRAN, AQPC312HNREL, AQPC312HFCON, AQPC312HCORD, AQPC312HCSUBO, 
     AQPC312HMODUL, AQPC312HTOPER, AQPC312HSUCUR, AQPC312HMDA, AQPC312HPAP, AQPC312HCTA,
     AQPC312HOPER, AQPC312HSUBOP, AQPC312HFVAL, AQPC312HCIMP1, AQPC312HCREF
     )    
    select P_C_USUARIO,P_N_FECPRO, rownum, Pgcod, Hcmod,
       Hsucor, Htran, hnrel, Hfcon, Hcord, Hcsubo,
       Hmodul, Htoper, Hsucur, Hmda, Hpap, Hcta,
       Hoper, Hsubop, hfval, Hcimp1, Hcref       
    from FSH016
    where (Pgcod = 1)
     and (Hcmod = 66)
     and (Hsucor = 903)
     and (Htran IN (55, 60, 62, 85, 87)) -- 2024.06.11 rcuadros
     and (Hfcon = P_N_FECPRO)
     and (Hmodul = 21)
     and (Hcord = 10)
     and (Htoper <> 2)
     and (Hmda = 0)
     and (Hpap = 0)
     and (hcsubo = 1)
     and (Substr(Hcref, 1, 8) = '42615346');
     commit;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      P_C_MSGRES := sqlerrm;  
  end sp_obtener_compras;

procedure sp_contar_compras( P_N_FECINI IN DATE,
                             P_N_FECFIN IN DATE,
                             P_C_CUENTA IN NUMBER,
                             P_N_CONTEO OUT NUMBER                               
                             ) is
p_c_deserr VARCHAR2(1000);
begin
    P_N_CONTEO := 0;
    select count(1) into P_N_CONTEO
    from FSH016
    where pgcod = 1 + UID * 0
     and Hcmod = 66
     and Hsucor = 903
     and Htran IN (55, 60, 62, 85, 87) -- 2024.06.11 rcuadros
     and Hfcon >= P_N_FECINI
     and Hfcon <= P_N_FECFIN
     and Hmodul = 21
     and Hcord = 10
     and Htoper <> 2
     and Hmda = 0
     and Hpap = 0
     and hcsubo = 1
     and hcta = P_C_CUENTA;     
exception
    when others then
      dbms_output.put_line(sqlerrm);
      p_c_deserr := sqlerrm;  
end sp_contar_compras;                               
                                                                             
end PQ_CN_CASHBACK;
/

