CREATE OR REPLACE TRIGGER TG_Z0E478_BU_01
  before update on Z0E478
  for each row

DECLARE
  lv_nombre  varchar2(160):= null;
  lc_sexo    char(1);
  lv_celular varchar(20);
  lv_user    char(10);
  lc_flag    char(1);
BEGIN

  If  :new.z0e463cod in (5,9) Then
        lv_user := :new.z0e478uau;
        if :new.z0e463cod = 9 then
            begin
              Select 'S'
                 into lc_flag
                from PRFU00
               WHERE UBUSER = lv_user
                 AND PRFGCOD = 'CIERRE'
                 AND ROWNUM <2;
            exception
            when no_data_found then
              lc_flag := 'N';
            when others then
              lc_flag := 'S';
            end;
        else  
          if trim(lv_user) = 'USRMOVIL' then
            lc_flag := 'N';
          Else  
            begin
              Select 'N'
                 into lc_flag
                from PRFU00
               WHERE UBUSER = lv_user
                 AND PRFGCOD = 'UNIBANCA01'
                 AND ROWNUM <2;
            exception
            when others then
              lc_flag := 'S';
            end;
          end if;
        End if;
        if lc_flag = 'N' then
            begin
             Select trim(b.pfape1) ||' '|| trim(b.pfape2) ||' , '||trim(b.pfnom1)||' '||trim(b.pfnom2),
                    b.pfcant
               into lv_nombre,
                    lc_sexo
               from FSD002 B
              where b.pfpais = :new.z0e478thp  
                and b.pftdoc = :new.z0e478tht  
                and b.pfndoc = :new.z0e478thd;
            exception
            when others then
                 lv_nombre := null;
                 lc_sexo   := null;                  
            end;
            
            if lv_nombre is not null then
                --buscamos el celular en la direccion de correspondencia
                begin 
                  Select trim(a.dotelfp)
                    into lv_celular 
                    from fsr005 a 
                   where a.pepais = :new.z0e478thp    
                     and a.petdoc = :new.z0e478tht  
                     and a.pendoc = :new.z0e478thd
                     and a.docod  = 2
                     and a.doordp = 99;
                exception
                when no_data_found then  
                  begin--si no hay como correspondencia buscamos otro asociado a esta dirección
                    Select trim(a.dotelfp)
                      into lv_celular 
                      from fsr005 a 
                     where a.pepais = :new.z0e478thp    
                       and a.petdoc = :new.z0e478tht  
                       and a.pendoc = :new.z0e478thd
                       and a.docod  = 2
                       and a.doordp = (
                                          Select max(a.doordp)              
                                            from fsr005 a 
                                           where a.pepais = :new.z0e478thp    
                                             and a.petdoc = :new.z0e478tht  
                                             and a.pendoc = :new.z0e478thd
                                             and a.docod  = 2                 
                                         );         
                  exception
                  when no_data_found then  
                    begin--si no hay ninguno de correspondencia buscamos el mayor registrado en la dirección legal
                      Select trim(a.dotelfp)
                        into lv_celular 
                        from fsr005 a 
                       where a.pepais = :new.z0e478thp    
                         and a.petdoc = :new.z0e478tht  
                         and a.pendoc = :new.z0e478thd
                         and a.docod  = 1
                         and a.doordp = (
                                          Select max(a.doordp)              
                                            from fsr005 a 
                                           where a.pepais = :new.z0e478thp    
                                             and a.petdoc = :new.z0e478tht  
                                             and a.pendoc = :new.z0e478thd
                                             and a.docod  = 1                 
                                         );
                    exception
                    when others then  
                      lv_celular := null;
                    end;            
                  end;          
                end;
                if  lv_celular is not null then
                   BEGIN --inicio afiliacion                          
                     INSERT INTO ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                                  nombre_cliente,
                                                                  mail_cliente,
                                                                  celular_cliente,
                                                                  sexo_cliente,
                                                                  enviar_celular,
                                                                  enviar_mail)
                                                           values('T'||lpad(trim(to_char(:new.z0e478thp)),3,'0')||lpad(trim(to_char(:new.z0e478tht)),2,'0')||lpad(trim(to_char(:new.z0e478thd)),12,'0'),
                                                                  substr(lv_nombre,1,150),
                                                                  null,
                                                                  to_number(trim(lv_celular)),
                                                                  lc_sexo,
                                                                  'S',
                                                                  'N'
                                                                  );
                   EXCEPTION
                   WHEN DUP_VAL_ON_INDEX THEN  
                       BEGIN                          
                           UPDATE ichannelalert.CLIENTES_AFILIADOS
                              SET celular_cliente = to_number(trim(lv_celular))
                            WHERE codigo_cliente  = 'T'||lpad(trim(to_char(:new.z0e478thp)),3,'0')||lpad(trim(to_char(:new.z0e478tht)),2,'0')||lpad(trim(to_char(:new.z0e478thd)),12,'0');
                       EXCEPTION
                       WHEN OTHERS THEN
                         null;
                       END; 
                   WHEN OTHERS THEN
                     null;          
                   END;--fin afiliación
               End if; 
           End If;
       End if;
  End IF;   
Exception
When others then
    null;
END TG_Z0E478_BU_01;
/

