create or replace procedure sp_cl_validaafiliacion(P_C_MODO   IN VARCHAR2,
                                                   P_N_CODPAI IN NUMBER,
                                                   P_N_TIPDOC IN NUMBER,
                                                   P_C_NUMDOC IN VARCHAR2,
                                                   P_N_TIPDAT IN NUMBER,--1 CELULAR 2 MAIL
                                                   P_C_VALOR  in out VARCHAR2,
                                                   p_c_coderr in out varchar2,
                                                   p_c_msgerr out varchar2
                                                  ) is
   -- *****************************************************************
    -- Nombre                     : sp_cl_validaafiliacion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/04/2023
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Mantenimiento de celular y correo a notificaciones de ICHANNEL
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 11/03/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó restricciones a querys
    -- Fecha de Modificación      : 01/04/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó validación de titularidad
    -- Fecha de Modificación      : 27/05/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó validación de titularidad faltante
    -- *****************************************************************                                                        
  cursor c_celulares is
    Select distinct trim(a.dotelfp) celular
      from fsr005 a 
     where a.pepais = P_N_CODPAI 
       and a.petdoc = P_N_TIPDOC
       and a.pendoc = rpad(P_C_NUMDOC,12,' ')
       and pq_ah_enviodigital.fn_ah_valida_celular(trim(a.dotelfp),1) = 'S';  
       
  cursor c_mail is
    Select distinct trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1)) mail
      from fsx001 b
     where b.pepais = P_N_CODPAI
       and b.petdoc = P_N_TIPDOC
       and b.pendoc = rpad(P_C_NUMDOC,12,' ')
       and b.txcod = 0
       and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1))) = 'S';       
                                                    
  lv_celular  varchar2(20):= null;
  lv_mail     varchar2(320):= null;   
  ln_numafi   number(9):=0;                                          
begin

  if P_C_MODO = 'INS' then
    p_c_coderr := '0';
    if P_N_TIPDAT = 1 then
        for i in c_celulares loop
          lv_celular := i.celular;
          begin
            select count(1)
              into ln_numafi
              from ichannelalert.clientes_afiliados x
             where x.celular_cliente = lv_celular
               and x.enviar_celular = 'S'
               and ((length(trim(x.codigo_cliente)) = 20 and substr(trim(x.codigo_cliente),10,3) = '021')
                     or 
                    (length(trim(x.codigo_cliente)) = 27 and substr(trim(x.codigo_cliente),10,3) = '022' )
                   )
               and FN_AH_VALINT(to_number(substr(trim(x.codigo_cliente),1,9)),P_N_CODPAI,P_N_TIPDOC,P_C_NUMDOC) = 'S';--validamos integridad
          exception
          when others then
            ln_numafi := 0;
          end;
          if ln_numafi > 0 then
            Exit;
          End If;
        end loop;
        if ln_numafi > 0 then
          p_c_coderr := ln_numafi;
          p_c_msgerr := 'El celular '||lv_celular ||' del cliente esta afiliado a Notificaciones, consultar si desea remplazarlo.';
        End if;
        P_C_VALOR := lv_celular;
    End if;
    if P_N_TIPDAT = 2 then
        for i in c_mail loop
          lv_mail := upper(i.mail);
          begin
            select count(1)
              into ln_numafi
              from ichannelalert.clientes_afiliados x
             where upper(x.mail_cliente) = lv_mail
               and x.enviar_mail = 'S'
               and ((length(trim(x.codigo_cliente)) = 20 and substr(trim(x.codigo_cliente),10,3) = '021')
                     or 
                    (length(trim(x.codigo_cliente)) = 27 and substr(trim(x.codigo_cliente),10,3) = '022' )
                   )
               and FN_AH_VALINT(to_number(substr(trim(x.codigo_cliente),1,9)),P_N_CODPAI,P_N_TIPDOC,P_C_NUMDOC) = 'S';--validamos integridad
          exception
          when others then
            ln_numafi := 0;
          end;
          if ln_numafi > 0 then
            Exit;
          End If;
        end loop;
        if ln_numafi > 0 then
          p_c_coderr := ln_numafi;
          p_c_msgerr := 'El mail '||lv_mail ||' del cliente esta afiliado a Notificaciones, consultar si desea remplazarlo.';
        End if;    
        P_C_VALOR := lv_mail;  
    End if;    
  End if;
  
  if P_C_MODO = 'UPD' then
    if P_N_TIPDAT = 1 then
       BEGIN
           UPDATE ichannelalert.CLIENTES_AFILIADOS x
              SET x.celular_cliente = trim(P_C_VALOR)
            WHERE x.celular_cliente = trim(P_C_NUMDOC)
              and x.enviar_celular = 'S'
              and ((length(trim(x.codigo_cliente)) = 20 and substr(trim(x.codigo_cliente),10,3) = '021')
                    or 
                   (length(trim(x.codigo_cliente)) = 27 and substr(trim(x.codigo_cliente),10,3) = '022' )
                  )
              and FN_AH_VALINT(to_number(substr(trim(x.codigo_cliente),1,9)),P_N_CODPAI,P_N_TIPDOC,p_c_coderr) = 'S';--validamos integridad                            
              commit;
              p_c_coderr :='0';
       EXCEPTION
       WHEN OTHERS THEN
         p_c_coderr:='0';
       END;          
    End if;
    if P_N_TIPDAT = 2 then
       BEGIN
           UPDATE ichannelalert.CLIENTES_AFILIADOS x
              SET x.mail_cliente = trim(P_C_VALOR)
            WHERE upper(x.mail_cliente) = upper(trim(P_C_NUMDOC))
              and x.enviar_mail = 'S'
              and ((length(trim(x.codigo_cliente)) = 20 and substr(trim(x.codigo_cliente),10,3) = '021')
                   or 
                  (length(trim(x.codigo_cliente)) = 27 and substr(trim(x.codigo_cliente),10,3) = '022' )
                  )
              and FN_AH_VALINT(to_number(substr(trim(x.codigo_cliente),1,9)),P_N_CODPAI,P_N_TIPDOC,p_c_coderr) = 'S';--validamos integridad                                  
              commit;
              p_c_coderr :='0';
       EXCEPTION
       WHEN OTHERS THEN
         p_c_coderr :='0';
       END;         
    End if;        
  End if;
  
  if P_C_MODO = 'DEL' then
    p_c_coderr := '0';    
    if P_N_TIPDAT = 1 then
        lv_celular := P_C_VALOR;
        begin
          select count(1)
            into ln_numafi
            from ichannelalert.clientes_afiliados x
           where x.celular_cliente = lv_celular
             and x.enviar_celular = 'S'
             and ((length(trim(x.codigo_cliente)) = 20 and substr(trim(x.codigo_cliente),10,3) = '021')
                   or 
                  (length(trim(x.codigo_cliente)) = 27 and substr(trim(x.codigo_cliente),10,3) = '022' )
                 )
             and FN_AH_VALINT(to_number(substr(trim(x.codigo_cliente),1,9)),P_N_CODPAI,P_N_TIPDOC,P_C_NUMDOC) = 'S';--validamos integridad
        exception
        when others then
          ln_numafi := 0;
        end;
      if ln_numafi > 0 then
        p_c_coderr := ln_numafi;
        p_c_msgerr := 'El celular '||lv_celular ||' del cliente esta afiliado a Notificaciones, primero desafiliarse antes de eliminarlo';
      End if;      
    end if;
    if P_N_TIPDAT = 2 then
        lv_mail := upper(trim(P_C_VALOR));
        begin
          select count(1)
            into ln_numafi
            from ichannelalert.clientes_afiliados x
           where upper(x.mail_cliente) = lv_mail
             and x.enviar_mail = 'S'
             and ((length(trim(x.codigo_cliente)) = 20 and substr(trim(x.codigo_cliente),10,3) = '021')
                   or 
                  (length(trim(x.codigo_cliente)) = 27 and substr(trim(x.codigo_cliente),10,3) = '022' )
                 )
             and FN_AH_VALINT(to_number(substr(trim(x.codigo_cliente),1,9)),P_N_CODPAI,P_N_TIPDOC,P_C_NUMDOC) = 'S';--validamos integridad
        exception
        when others then
          ln_numafi := 0;
        end;

        if ln_numafi > 0 then
          p_c_coderr := ln_numafi;
          p_c_msgerr := 'El mail '||lv_mail ||' del cliente esta afiliado a Notificaciones,  primero desafiliarse antes de eliminarlo';
        End if;            
    end if;        
  end if;    
exception
when others then  
  p_c_coderr := sqlcode;
  p_c_msgerr := sqlerrm;
end sp_cl_validaafiliacion;
/

