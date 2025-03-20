CREATE OR REPLACE TRIGGER TG_Z0E478_AU_01
  after update on Z0E478
  for each row

DECLARE
  pd_fecpro fst017.pgfape%type;
  pc_hora   char(8);
  lc_estado   char(1);
  lc_coderr varchar2(4000);
  lc_msgerr varchar2(4000);
  lv_nombre  varchar2(160):= null;
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
            pc_hora := to_char(sysdate,'HH24:mi:ss');
            pd_fecpro := trunc(sysdate);            
             begin
             Select trim(b.pfape1) ||' '|| trim(b.pfape2) ||' , '||trim(b.pfnom1)||' '||trim(b.pfnom2)
               into lv_nombre
               from FSD002 B
              where b.pfpais = :new.z0e478thp  
                and b.pftdoc = :new.z0e478tht  
                and b.pfndoc = :new.z0e478thd;
            exception
            when others then
                 lv_nombre := null;
            end;
            
            if lv_nombre is not null then        
                begin
                  insert into aqpa107
                    (aqpa107tar, aqpa107fec, aqpa107hor, aqpa107usr,aqpa107pai,aqpa107tip, aqpa107num)
                  values
                    (trim(:new.z0e478nro), pd_fecpro, pc_hora, :new.z0e478uau,:new.z0e478thp,:new.z0e478tht,:new.z0e478thd);
                lc_estado := 'S';
                exception
                when others then
                    null;  
                    lc_estado := 'N';
                end;
                if lc_estado = 'S' then --ENVIAR CORREO
                  -- Call the procedure                                               
                  sp_cl_mail_bloqueo_tarjeta(p_n_codpai => :new.z0e478thp,
                                             p_n_tipdoc => :new.z0e478tht,
                                             p_c_numdoc => :new.z0e478thd,
                                             p_c_numtar => trim(:new.z0e478nro),
                                             p_c_coderr => lc_coderr,
                                             p_c_deserr => lc_msgerr);                                     
                                                                                                              
                 -- registrar log de envio y/o error
                 begin
                   insert into aqpa107a(aqpa107atar,
                                        aqpa107afec,
                                        aqpa107ahor,
                                        aqpa107aest,
                                        aqpa107amot
                                       )
                                 values(trim(:new.z0e478nro),
                                        pd_fecpro,
                                        pc_hora,
                                        decode(lc_coderr, '000', 'S', 'N'), 
                                        lc_msgerr
                                        );
                 exception
                 when others then                       
                   null;
                 end;                            
                End if; 
            End If;   
        End If;       
  End IF;   
Exception
When others then
    null;
END TG_Z0E478_AU_01;
/

