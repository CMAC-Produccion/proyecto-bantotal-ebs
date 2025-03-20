create or replace procedure sp_ah_conichannel(P_D_FECPRO IN DATE,
                                              P_C_CODUSU IN VARCHAR2,           
                                              P_N_NUMCEL IN NUMBER,
                                              P_N_TIPALE IN NUMBER,
                                              p_c_hora   out varchar2,
                                              p_c_estado out varchar2         
                                             ) is
   -- *****************************************************************
    -- Nombre                     : sp_ah_conichannel
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/04/2024
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Consulta data de ichannel
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 12/04/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó mas canales 
    -- *****************************************************************                                           
  lv_fecha  varchar2(10):=null;
  ln_numcel number(11):=0;                                         
  ln_canal  number(9):=0;                                       
begin
  lv_fecha  := to_char(P_D_FECPRO,'dd.mm.rrrr');
  ln_numcel := to_number('51'||trim(to_char(P_N_NUMCEL)));
  
/*  if P_N_TIPALE in(1,2,3)  then
    ln_canal:= 1029;
  End if;  
  if P_N_TIPALE = 4 then
    ln_canal:= 1030;
  End if;  */
  
  begin
    select x.tp1nro2
      into ln_canal 
      from fst198 x 
     where x.tp1cod   = 1 
       and x.tp1cod1  = 10825 
       and x.tp1corr1 = 126 
       and x.tp1corr2 = 7
       and x.tp1nro1  = P_N_TIPALE;
  exception
  when others then
    ln_canal := 0; 
  end;
  
  begin    
    select substr(AQPA146FIN, 12,8),'S'
      into p_c_hora,p_c_estado
      from aqpa146
     where AQPA146USU = rpad(P_C_CODUSU,10,' ')
       and substr(AQPA146FIN, 1,10) = lv_fecha
       and AQPA146CAN   = ln_canal
       and AQPA146DES = ln_numcel
       and AQPA146EST  = 'T'
       and rownum =1;
  Exception
  when others then
    p_c_estado := 'N';      
    p_c_hora := NULL;    
  end;
exception
when others then
  p_c_estado := 'N';      
  p_c_hora := NULL;
end sp_ah_conichannel;
/

