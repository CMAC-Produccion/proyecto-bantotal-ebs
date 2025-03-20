create or replace procedure sp_ah_arqueo_notify_email is
    -- *****************************************************************
    -- Nombre                     : sp_ah_arqueo_notify_email
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.07.25
    -- Autor de Creación          : 
    -- Uso                        : Notifica arqueos pendientes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 12/06/2024
    -- Autor de la Modificación   : Ylozada
    -- Descripción de Modificación: Se adicionó filtro de solo 1 arqueo de boveda por día.
    --
    -- *****************************************************************    
  ld_fecpro     date;
  ld_diafpr     number(2):= 0;
  ld_mesfpr     number(2):= 0;
  ld_anofpr     number(4):= 0;
  ln_numaqb     number(9):= 0;
  ln_numaqa     number(9):= 0;
  ln_arbnum     number(9):= 0;
  ln_aranum     number(9):= 0;
  ln_numatm     number(9):= 0;
  ld_finibo     date;
  ld_ffinbo     date;
  ld_finiat     date;
  ld_ffinat     date;
  lc_indvab     char(1):= 'N';
  lc_indvaa     char(1):= 'N';
  lc_coderr     varchar2(400):= null;
  lc_deserr     varchar2(400):= null;
  lc_usrori     char(10):= null;
  lc_usrsup     char(10):= null;
  lc_indbov     char(1) := 'N';
  lc_indatm     char(1) := 'N';
  ll_mensaje    clob;
  lv_mensaje    varchar2(32767);   
  lv_arqueos    varchar2(40):= null;
  lv_arqueos2   varchar2(40):= null;
  lv_contacto   varchar2(30):= null;
  lc_estado     char(1) := 'N';
  lv_destinos   varchar2(800);
  ln_dia        number(2):=0;
  ln_codreg     number(9):=0;
  ln_codzon     number(9):=0;
  lc_indcar     char(1):='';
  ln_dias       number(9):=0;  
  ln_ubsuc      number(3):=0;

  cursor c_agencias is
    Select x.* 
      from fst001 x 
     where x.pgcod  = 1
       --and x.sucurs = 905;        
       and x.sucurs < 500;
  
  --OBTENEMOS LOS JEFES REGIONALES Y ZONALES       
  cursor c_gerentes is
    Select b.sng057usr,a.ubsuc       
      from fst046 a, 
           sng057 b
     where a.pgcod     = b.sng055emp
       and a.ubuser    = b.sng057usr               
       and b.sng055car = 220
       --and a.ubsuc = 905;       
       and a.ubsuc < 500;       

   cursor c_listado(ln_codreg in number,ln_codzon in number) is  
    Select upper(a.REGNOM)       REGNOM,
           upper(a.DESZON)       DESZON,
           upper(a.SCNOM)        SCNOM,
           upper(b.jaqz187aax8)  PENDIENTE
      from REGSUC   a,
           jaqz187a b
     where b.jaqz187afep = ld_fecpro - 1
       and b.jaqz187asuc = a.sucurs     
       and a.regcod > 0
       --and a.SUCURS = 905
       and a.SUCURS < 500
       and b.jaqz187aax1 = 202
       and b.jaqz187aax7 = 'N'
       and a.regcod = decode(ln_codreg,0,a.regcod,ln_codreg)
       and a.codzon = decode(ln_codzon,0,a.codzon,ln_codzon)
  order by REGNOM,DESZON,SCNOM;   
  
begin
  --Fecha del sistema
  begin
       Select x.pgfape - 1
         into ld_fecpro 
         from fst017 x 
        where x.pgcod = 1;
  exception
  when others then       
    ld_fecpro := trunc(sysdate);
  end;
  
  --OBTENEMOS LA CANTIDAD DE DIAS A RESTAR  
  begin
       Select x.tp1nro1
         into ln_dias
         from fst198 x 
        where x.tp1cod = 1
          and x.tp1cod1 = 10825
          and x.tp1corr1 = 82
          and x.tp1corr2 = 4;
  exception
  when others then       
    ln_dias := 0;
  end;  
  ld_diafpr := substr(to_char(ld_fecpro,'dd/mm/rrrr'),1,2);
  ld_mesfpr := substr(to_char(ld_fecpro,'dd/mm/rrrr'),4,2);
  ld_anofpr := substr(to_char(ld_fecpro,'dd/mm/rrrr'),7,4); 
  

  -- Recorremos para todas las agencias
  for i in c_agencias loop
    lc_coderr := '000';  
    --Obtenemos si el día a procesar es válido para verificación de arqueo
    lc_indvab := 'N';
    ln_numaqb := 0;
    ld_finibo := null;
    ld_ffinbo := null;
    ln_arbnum := 0;    
    lc_indvaa := 'N';
    ln_numatm := 0;
    ln_numaqa := 0;
    ld_finiat := null;
    ld_ffinat := null;
    ln_aranum := 0;
    lc_usrori := ''; 
    lc_usrsup := '';  
    lv_arqueos  := '';
    lv_arqueos2  := '';
    lv_contacto := '';
    lc_estado   := 'N';
    lv_destinos := null;
    begin
         Select 'S'
           into lc_indvab 
           from fst198 x 
          where x.tp1cod = 1
            and x.tp1cod1 = 10825
            and x.tp1corr1 = 82
            and x.tp1corr2 = 3
            and x.tp1nro1  = 1 --bóveda
            and ld_diafpr between x.tp1nro2 and x.tp1nro3; 
    exception
    when others then       
      lc_indvab := 'N';
    end;     
    --if lc_indvab = 'S' then
      --obtenemos número de arqueos a validar para bóveda
      begin
           Select x.tp1nro2
             into ln_numaqb 
             from fst198 x 
            where x.tp1cod = 1
              and x.tp1cod1 = 10825
              and x.tp1corr1 = 82
              and x.tp1corr2 = 1
              and x.tp1nro1  = 1; --bóveda
      exception
      when others then       
        ln_numaqb := 0;
      end;    
      --validamos rango de fechas a verificar para boveda
      begin
           Select to_date('01/'||lpad(x.tp1nro2,2,'0')||'/'||ld_anofpr,'dd/mm/rrrr'),
                  last_day(to_date('01/'||lpad(x.tp1nro3,2,'0')||'/'||ld_anofpr,'dd/mm/rrrr')) - ln_dias 
             into ld_finibo,
                  ld_ffinbo
             from fst198 x 
            where x.tp1cod = 1
              and x.tp1cod1 = 10825
              and x.tp1corr1 = 82
              and x.tp1corr2 = 2
              and x.tp1nro1  = 1 --bóveda
              and ld_mesfpr between x.tp1nro2 and x.tp1nro3;
      exception
      when others then       
        ld_finibo := null;
        ld_ffinbo := null;
      end;     
      --verificamos los arqueo de bóveda que hay tenido para el rango de días
      begin
         Select count(distinct 
                a.mbccfch
                )
           into ln_arbnum
           from mbc004 a,
                mbc010 b,
                sng057 c            
          where a.mbccemp   = b.mbc10emp
            and a.mbccsuc   = b.mbc10suc 
            and a.mbccusu   = b.mbc10usr  
            and a.mbcccaj   = b.mbc10caj  
            and a.mbccfch   = b.mbc10fech  
            and a.mbcchra   = b.mbc10hra 
            and b.mbc10emp  = c.sng055emp
            and b.mbc10spr  = c.sng057usr
            and c.sng055car = 202
            and a.mbccemp   = i.pgcod 
            and a.mbccsuc   = i.sucurs
            and a.mbcccaj   = 0  --boveda
            --and a.mbccest   <> 'C'
            --and trim(a.mbccest) is null
            and a.mbccfch between ld_finibo and ld_ffinbo;  
      exception
      when others then       
        ln_arbnum := 0;
      end;   
      
      if ln_arbnum < ln_numaqb then         
         lc_indbov := 'S';         
      else                
         lc_indbov := 'N';             
      end if;            
    --end if;
    
    --Obtenemos si el día a procesar es válido para notificar de arqueo de ATM
    begin
         Select 'S'
           into lc_indvaa 
           from fst198 x 
          where x.tp1cod = 1
            and x.tp1cod1 = 10825
            and x.tp1corr1 = 82
            and x.tp1corr2 = 3
            and x.tp1nro1  = 2 --atm
            and ld_diafpr between x.tp1nro2 and x.tp1nro3; 
    exception
    when others then       
      lc_indvaa := 'N';
    end;     
    --if lc_indvaa = 'S' then 
      --obtenemos el número de atms asignados a la agencia
      begin
           Select count(1)
             into ln_numatm 
             from z0e475 x 
            where x.z0e475pgc = i.pgcod
              and x.z0e475suc = i.sucurs
              and x.z0e475tip = 'A';
      exception
      when others then       
        ln_numatm := 0;
      end;    
      if ln_numatm > 0 then    
          --obtenemos número de arqueos a validar para ATM
          begin
               Select x.tp1nro2
                 into ln_numaqa 
                 from fst198 x 
                where x.tp1cod = 1
                  and x.tp1cod1 = 10825
                  and x.tp1corr1 = 82
                  and x.tp1corr2 = 1
                  and x.tp1nro1  = 2; --atm
          exception
          when others then       
            ln_numaqa := 0;
          end;   
          --validamos rango de fechas a verificar para ATM     
          begin
               Select to_date('01/'||lpad(x.tp1nro2,2,'0')||'/'||ld_anofpr,'dd/mm/rrrr'),
                      last_day(to_date('01/'||lpad(x.tp1nro3,2,'0')||'/'||ld_anofpr,'dd/mm/rrrr')) - ln_dias
                 into ld_finiat,
                      ld_ffinat
                 from fst198 x 
                where x.tp1cod = 1
                  and x.tp1cod1 = 10825
                  and x.tp1corr1 = 82
                  and x.tp1corr2 = 2
                  and x.tp1nro1  = 2 --atm
                  and ld_mesfpr between x.tp1nro2 and x.tp1nro3;
          exception
          when others then       
            ld_finiat := null;
            ld_ffinat := null;
          end;    
          --verificamos los arqueo de ATM que hay tenido para el rango de días
          begin
             Select count(1)
               into ln_aranum
               from jaql527 a,
                    sng057  b,
                    z0e475  c             
              where b.sng055emp    = c.z0e474cod
                and c.z0e474cod    = i.pgcod
                and substr(a.jaql527usuej,1,10)  = b.sng057usr
                and b.sng055car    = 202
                and a.jaql527agarq = c.z0e475suc
                and a.jaql527atarq = c.z0e475cod
                and c.z0e475suc    = i.sucurs
                --and a.jaql527dspdo = 0 
                --and a.jaql527dspso = 0
                and c.z0e475tip    = 'A'
                and a.jaql527confi = 'SI'
                and a.jaql527fearq between ld_finiat and ld_ffinat;  
          exception
          when others then       
            ln_aranum := 0;
          end;   
          if ln_aranum < ln_numaqa then         
             lc_indatm := 'S';         
          else                
             lc_indatm := 'N';             
          end if;
      else
         lc_indatm := 'N';   
      end if;             
    --end if;
    
    --obtenemos el correo del gerente de agencia
      begin
        Select b.sng057usr, 
               b.sng057sup
          into lc_usrori,
               lc_usrsup                        
          from fst046 a, 
               sng057 b
         where a.pgcod     = b.sng055emp
           and a.ubuser    = b.sng057usr
           and a.ubsuc     = i.sucurs
           and b.sng055car = 202
           and decode(b.sng057fin, null, to_date('01/01/0001','dd/mm/rrrr'),b.sng057fin) =
               (Select decode(max(d.sng057fin),
                              null,
                              to_date('01/01/0001','dd/mm/rrrr'),
                              max(d.sng057fin)
                              )
                  from fst046 c, 
                       sng057 d
                 where c.pgcod     = d.sng055emp
                   and c.ubuser    = d.sng057usr
                   and c.ubsuc     = i.sucurs
                   and d.sng055car = 202
               )
           and rownum < 2;               
      exception
      when others then       
        lc_usrori := '';
        lc_usrsup := '';
      end;   
      
      --armamos el mail para el gerente de agencia
      --ARMAMOS EL CUERPO DEL MENSAJE
      case
        when lc_indbov = 'S' and  lc_indatm = 'N' then
          lv_arqueos := 'Bóveda';
          lv_arqueos2 := 'la Bóveda';
        when lc_indbov = 'N' and  lc_indatm = 'S' then
          lv_arqueos := 'ATM';
          lv_arqueos2 := 'el ATM';
        when lc_indbov = 'S' and  lc_indatm = 'S' then
          lv_arqueos := 'Bóveda y ATM';
          lv_arqueos2 := 'el ATM y Bóveda';
        when lc_indbov = 'N' and  lc_indatm = 'N' then
          lv_arqueos := null;
          lv_arqueos2 := null;
        else
          lv_arqueos := null;
          lv_arqueos2 := null;
      end case;
              
      begin
        Select trim(a.ubnom)
          into lv_contacto
          from fst746 a
         where a.ubuser = lc_usrori;
      exception
      when others then       
        lc_usrori := '';
        lc_usrsup := '';
      end;               
              
      dbms_lob.createtemporary(ll_mensaje, TRUE);              
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): '||lv_contacto||'</p>' ||  
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Por medio de la presente, se le comunica que hasta el momento Ud. no ha realizado el(los) arqueo(s) inopinado(s) de '||lv_arqueos||'. Por tal motivo agradeceremos realizarlo a la brevedad posible y de esta manera cumplir con lo establecido en las normas vigentes. El no cumplimiento está sujeto a sanciones.</p>'; 
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                                  
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);               
              
      lv_mensaje := 
      '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
  

                   
  --ENVIO DE EMAIL GERENTE DE AGENCIA
    if (lc_indbov = 'S' or lc_indatm = 'S') and (lc_indvab = 'S' or lc_indvaa = 'S') then
        --enviar mail a gerente de agencia                  
                           
              if trim(lc_usrori) is not null then    
                  lv_destinos := trim(lower(lc_usrori))||'@cajaarequipa.pe';
                  if trim(lc_usrsup) is not null then
                    lv_destinos := trim(lv_destinos) ||';' ||trim(lower(lc_usrsup))||'@cajaarequipa.pe';
                  End If;                    
                                             
                  begin           
                    -- Call the procedure
                    pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(lc_usrori)||'@cajaarequipa.pe',
                                                     p_destinatarioscc   => CASE
                                                                              WHEN trim(lc_usrsup) is not null THEN
                                                                                trim(lc_usrsup)||'@cajaarequipa.pe'
                                                                              ELSE
                                                                                ''
                                                                              END,
                                                     p_destinatariosbcc  => '',
                                                     p_mensaje           => ll_mensaje,
                                                     p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                                     p_asunto            => 'Alerta de Arqueos',
                                                     p_tipomensaje       => 'HTML',
                                                     p_directorio        => '',
                                                     p_archivosadjuntos  => '',
                                                     p_c_coderr          => lc_coderr,
                                                     p_c_deserr          => lc_deserr
                                                     );

                  end; 
              else
                lc_coderr := '00c';                                      
                lc_deserr := 'No existe usuario Gerente de agencia para la sucursal';           
                lv_destinos := null;
              end if;
              
              if lc_coderr = '000' then
                 lc_estado := 'S';    
                 lc_deserr := 'Envío Satisfactorio';             
              Else
                 lc_estado := 'N';
              End If;
    Else
      lc_estado := 'N';    
      lc_deserr := 'No corresponde notificar o ya cumplio arqueos';                        
    end if;                            
      
    --registramos log de envios a gerente de Agencia
    begin                  
        insert into jaqz187a(jaqz187afep,
                             jaqz187asuc,
                             jaqz187ahop,
                             jaqz187ausp,
                             jaqz187aest,
                             jaqz187amot,
                             jaqz187acue,
                             jaqz187amai,
                             jaqz187aax1,
                             jaqz187aax7,
                             jaqz187aax8
                             )
                       values(ld_fecpro,
                              i.sucurs,
                              to_char(sysdate,'HH24:mi:ss'), 
                              'BANTOTAL',
                              lc_estado,
                              lc_deserr,
                              ll_mensaje,
                              lv_destinos,
                              202,
                              decode(lv_arqueos,null,'S','N'),
                              lv_arqueos                         
                              );
                              commit;
    exception
    when dup_val_on_index then
        update jaqz187a a
           set a.jaqz187ahop = to_char(sysdate,'HH24:mi:ss'),
               a.jaqz187ausp = 'BANTOTAL',
               a.jaqz187aest = lc_estado,
               a.jaqz187amot = lc_deserr,
               a.jaqz187acue = ll_mensaje,
               a.jaqz187amai = lv_destinos
         where a.jaqz187afep = ld_fecpro
           and a.jaqz187asuc = i.sucurs
           and a.jaqz187aax1 = 202;
           commit;
    when others then                        
        null;
    end;      
    
        lc_usrori := '';
        lc_usrsup := '';    
    -- OBTENEMOS LAS SIGLAS DEL JEFE DE PLATAFORMA
      begin
        Select b.sng057usr, 
               b.sng057sup
          into lc_usrori,
               lc_usrsup                        
          from fst046 a, 
               sng057 b
         where a.pgcod     = b.sng055emp
           and a.ubuser    = b.sng057usr
           and a.ubsuc     = i.sucurs
           and b.sng055car = 50
           and decode(b.sng057fin, null, to_date('01/01/0001','dd/mm/rrrr'),b.sng057fin) =
               (Select decode(max(d.sng057fin),
                              null,
                              to_date('01/01/0001','dd/mm/rrrr'),
                              max(d.sng057fin)
                              )
                  from fst046 c, 
                       sng057 d
                 where c.pgcod     = d.sng055emp
                   and c.ubuser    = d.sng057usr
                   and c.ubsuc     = i.sucurs
                   and d.sng055car = 50 --JEFE DE PLATAFORMA
               )
           and rownum < 2;               
      exception
      when others then       
        lc_usrori := '';
        lc_usrsup := '';
      end;     
      
      --OBTENEMOS EL NOMBRE
      begin
        Select trim(a.ubnom)
          into lv_contacto
          from fst746 a
         where a.ubuser = lc_usrori;
      exception
      when others then       
        lc_usrori := '';
        lc_usrsup := '';
      end;  
          
      dbms_lob.freetemporary(ll_mensaje);           
      --ARMAMOS EL CORREO       
      dbms_lob.createtemporary(ll_mensaje, TRUE);              
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): '||lv_contacto||'</p>' ||  
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Por medio de la presente, se le comunica que hasta el momento '||lv_arqueos2||' a su cargo, no registran arqueo(s) inopinado(s). Por tal motivo agradeceremos, ponerse en contacto con el Gerente de Agencia a fin de que lo ejecute a la brevedad posible y de esta manera cumplir con las normas vigentes.</p>'; 
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                                  
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);               
              
      lv_mensaje := 
      '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
      
              
    --ENVIO DE EMAIL
    if (lc_indbov = 'S' or lc_indatm = 'S') and (lc_indvab = 'S' or lc_indvaa = 'S') then
        --enviar mail a jefe de plataforma            
                           
              if trim(lc_usrori) is not null then    
                  lv_destinos := trim(lower(lc_usrori))||'@cajaarequipa.pe';
                  if trim(lc_usrsup) is not null then
                    lv_destinos := trim(lv_destinos) ||';' ||trim(lower(lc_usrsup))||'@cajaarequipa.pe';
                  End If;                    
                                             
                  begin           
                    -- Call the procedure
                    pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(lc_usrori)||'@cajaarequipa.pe',
                                                     p_destinatarioscc   => CASE
                                                                              WHEN trim(lc_usrsup) is not null THEN
                                                                                trim(lc_usrsup)||'@cajaarequipa.pe'
                                                                              ELSE
                                                                                ''
                                                                              END,
                                                     p_destinatariosbcc  => '',
                                                     p_mensaje           => ll_mensaje,
                                                     p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                                     p_asunto            => 'Alerta de Arqueos',
                                                     p_tipomensaje       => 'HTML',
                                                     p_directorio        => '',
                                                     p_archivosadjuntos  => '',
                                                     p_c_coderr          => lc_coderr,
                                                     p_c_deserr          => lc_deserr
                                                     );

                  end; 
              else
                lc_coderr := '00c';                                      
                lc_deserr := 'No existe usuario Jefe de Plataforma para la sucursal';           
                lv_destinos := null;
              end if;
              
              if lc_coderr = '000' then
                 lc_estado := 'S';    
                 lc_deserr := 'Envío Satisfactorio';             
              Else
                 lc_estado := 'N';
              End If;
    Else
      lc_estado := 'N';    
      lc_deserr := 'No corresponde notificar';                        
    end if;          
        
    --registramos log de envios a jefe de plataforma
    begin                  
        insert into jaqz187a(jaqz187afep,
                             jaqz187asuc,
                             jaqz187ahop,
                             jaqz187ausp,
                             jaqz187aest,
                             jaqz187amot,
                             jaqz187acue,
                             jaqz187amai,
                             jaqz187aax1,
                             jaqz187aax7,
                             jaqz187aax8
                             )
                       values(ld_fecpro,
                              i.sucurs,
                              to_char(sysdate,'HH24:mi:ss'), 
                              'BANTOTAL',
                              lc_estado,
                              lc_deserr,
                              ll_mensaje,
                              lv_destinos,
                              50,
                              decode(lv_arqueos,null,'S','N'),
                              lv_arqueos                             
                              );
                              commit;
    exception
    when dup_val_on_index then
        update jaqz187a a
           set a.jaqz187ahop = to_char(sysdate,'HH24:mi:ss'),
               a.jaqz187ausp = 'BANTOTAL',
               a.jaqz187aest = lc_estado,
               a.jaqz187amot = lc_deserr,
               a.jaqz187acue = ll_mensaje,
               a.jaqz187amai = lv_destinos
         where a.jaqz187afep = ld_fecpro
           and a.jaqz187asuc = i.sucurs
           and a.jaqz187aax1 = 50;
           commit;
    when others then                        
        null;
    end;                                            
    dbms_lob.freetemporary(ll_mensaje);    
  end loop;
  --
  -- VERIFICAMOS SI CORRESPONDE ENVIO A JEFE ZONAL/GERENTE REGIONAL Y JEFE DE OPERACIONES (TODOS LOS LUNES Y FIN DE MES)
  --
  --Fecha del sistema
  begin
   Select x.pgfape
     into ld_fecpro 
     from fst017 x 
    where x.pgcod = 1;
  exception
  when others then       
    ld_fecpro := trunc(sysdate);
  end;
  --obtenemos dia de la semana
  begin
    Select to_number(to_char(ld_fecpro,'D')) 
      into ln_dia
      from DUAL;
  exception
  when others then       
    ln_dia := 0;
  end;    
  --SI ES LUNES o si es fin de mes - x días
  if ln_dia = 1 or ld_fecpro = last_day(ld_fecpro)- ln_dias then
     For i in c_gerentes loop
      --DETERMINAMOS SI ES GERENTE O JEFE ZONAL POR LOS PERFILES
      begin
        Select 'G'
          into lc_indcar 
         from prfu00 a 
        where a.pgcod = 1 
          and a.ubuser = i.sng057usr 
          and a.prfgcod = 'GREG01'; --GERENTE REGIONAL                                        
      exception
      when others then
        lc_indcar := 'Z';
      end;
      --determinamos el codigo de region y de zona
      if lc_indcar = 'G' then
        begin
           Select a.regcod
             into ln_codreg
            from REGSUC a 
           where sucurs = i.ubsuc;                                     
        exception
        when others then
          ln_codreg := 0;
        end;   
        ln_codzon := 0;
      else
        begin
           Select a.codzon
             into ln_codzon
            from REGSUC a 
           where sucurs = i.ubsuc;                                     
        exception
        when others then
          ln_codzon := 0;
        end;  
        ln_codreg := 0;
      end if;             
      
      dbms_lob.createtemporary(ll_mensaje, TRUE);              
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a).</p>' ||  
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Por medio de la presente, se le comunica que hasta el momento no se ha realizado el(los) arqueo(s) inopinado(s) de Bóveda y/o ATM. Por tal motivo agradecemos realizar la supervisión y seguimiento a los Gerentes de agencia a su cargo para que lo realicen a la brevedad posible. El no cumplimiento está sujeto a sanciones por la no ejecución y por la falta de supervisión.</p>';                              
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                            
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
               
      lv_mensaje := 
      '<p "font-family: Arial, sans-serif; font-size: 14px;">Detallamos el listado de Agencias:</p>'; 
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);               
      
      lv_mensaje :=                                              
              '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
              '<table cellspacing=0 cellpadding=3 width=900>';
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                 

              
      if lc_indcar = 'G' then     
        lv_mensaje :=         
        '  <tr>'||
        '    <td width="300" style="border-bottom: 1px solid black;"><b>Nombre Región:</b></td>'||
        '    <td width="300" style="border-bottom: 1px solid black;"><b>Nombre Zona:</b></td>'||
        '    <td width="300" style="border-bottom: 1px solid black;"><b>Nombre Sucursal:</b></td>'||        
        '    <td width="300" style="border-bottom: 1px solid black;"><b>Pendiente:</b></td>'||                 
        '  </tr>          ';                                   
      Else
        lv_mensaje :=         
        '  <tr>'||
        '    <td width="300" style="border-bottom: 1px solid black;"><b>Nombre Zona:</b></td>'||
        '    <td width="300" style="border-bottom: 1px solid black;"><b>Nombre Sucursal:</b></td>'||    
        '    <td width="300" style="border-bottom: 1px solid black;"><b>Pendiente:</b></td>'||                       
        '  </tr>          ';      
      End if;
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);    
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
          
      For j in c_listado(ln_codreg,ln_codzon) loop        
        if lc_indcar = 'G' then
          lv_mensaje := 
          '  <tr>'||
          '    <td width="300" align="left">'||j.REGNOM||'</td>'||        
          '    <td width="300" align="left">'||j.DESZON||'</td>'||
          '    <td width="300" align="left">'||j.SCNOM||'</td>'||
          '    <td width="300" align="left">'||j.PENDIENTE||'</td>'||          
          '  </tr>                ';               
        Else
          lv_mensaje := 
          '  <tr>'||        
          '    <td width="300" align="left">'||j.DESZON||'</td>'||
          '    <td width="300" align="left">'||j.SCNOM||'</td>'||
          '    <td width="300" align="left">'||j.PENDIENTE||'</td>'||                    
          '  </tr>                ';               
        End if;
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);    
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
     End loop; 
     lv_mensaje := 
     '</table>'||
     '<br/>'||
     '<br/>'||         
     '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';    
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
      
      --Enviamos el correo al GERENTE O JEFE ZONAL
      --obtenemos el correo 
      lc_usrori := '';
      lc_usrsup := '';
      lv_destinos:= '';
      begin
        Select b.sng057usr, 
               b.sng057sup
          into lc_usrori,
               lc_usrsup                        
          from fst046 a, 
               sng057 b
         where a.pgcod     = b.sng055emp
           and a.ubuser    = b.sng057usr
           and a.ubsuc     = i.ubsuc
           and b.sng055car = 220
           and decode(b.sng057fin, null, to_date('01/01/0001','dd/mm/rrrr'),b.sng057fin) =
               (Select decode(max(d.sng057fin),
                              null,
                              to_date('01/01/0001','dd/mm/rrrr'),
                              max(d.sng057fin)
                              )
                  from fst046 c, 
                       sng057 d
                 where c.pgcod     = d.sng055emp
                   and c.ubuser    = d.sng057usr
                   and c.ubsuc     = i.ubsuc
                   and d.sng055car = 220
               )
           and rownum < 2;               
      exception
      when others then       
        lc_usrori := '';
        lc_usrsup := '';
      end; 
      
      if trim(lc_usrori) is not null then    
          lv_destinos := trim(lower(lc_usrori))||'@cajaarequipa.pe';
          if trim(lc_usrsup) is not null then
            lv_destinos := trim(lv_destinos) ||';' ||trim(lower(lc_usrsup))||'@cajaarequipa.pe';
          End If;                    
                                             
          begin           
            -- Call the procedure
            pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(lc_usrori)||'@cajaarequipa.pe',
                                             p_destinatarioscc   => CASE
                                                                      WHEN trim(lc_usrsup) is not null THEN
                                                                        trim(lc_usrsup)||'@cajaarequipa.pe'
                                                                      ELSE
                                                                        ''
                                                                     END,
                                             p_destinatariosbcc  => '',
                                             p_mensaje           => ll_mensaje,
                                             p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                             p_asunto            => 'Alerta de Arqueos',
                                             p_tipomensaje       => 'HTML',
                                             p_directorio        => '',
                                             p_archivosadjuntos  => '',
                                             p_c_coderr          => lc_coderr,
                                             p_c_deserr          => lc_deserr
                                             );

          end; 
      else
        lc_coderr := '00d';                                      
        lc_deserr := 'No existe usuario Gerente Regional/Gerente Zonal';           
        lv_destinos := null;
      end if;
              
      if lc_coderr = '000' then
         lc_estado := 'S';    
         lc_deserr := 'Envío Satisfactorio';             
      Else
         lc_estado := 'N';
      End If;  
            
      --registramos log de envios a gerente regional/Zonal
      begin                  
          insert into jaqz187b(jaqz187bfep,
                               jaqz187bsuc,
                               jaqz187bhop,
                               jaqz187busp,
                               jaqz187best,
                               jaqz187bmot,
                               jaqz187bcue,
                               jaqz187bmai,
                               JAQZ187BAX7
                               )
                         values(ld_fecpro,
                                i.ubsuc,
                                to_char(sysdate,'HH24:mi:ss'), 
                                i.sng057usr,
                                lc_estado,
                                lc_deserr,
                                ll_mensaje,
                                lv_destinos,
                                lc_indcar                          
                                );
                                commit;
      exception
      when dup_val_on_index then
          update jaqz187b a
             set a.jaqz187bhop = to_char(sysdate,'HH24:mi:ss'),
                 a.jaqz187busp = i.sng057usr,
                 a.jaqz187best = lc_estado,
                 a.jaqz187bmot = lc_deserr,
                 a.jaqz187bcue = ll_mensaje,
                 a.jaqz187bmai = lv_destinos
           where a.jaqz187bfep = ld_fecpro
             and a.jaqz187bsuc = i.ubsuc
             and a.jaqz187busp = i.sng057usr
             and a.JAQZ187BAX7 = lc_indcar;
             commit;
      when others then                        
          null;
      end;                             
      dbms_lob.freetemporary(ll_mensaje);                                    
     End loop;
     
     --ARMAMOS MAIL PARA EL JEFE DE OPERACIONES
      dbms_lob.createtemporary(ll_mensaje, TRUE);              
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a).</p>' ||  
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Por medio de presente, se le comunica que hasta el momento no se ha realizado el(los) arqueos(s) inopinado(s) de ATM y/o Bóveda. Por tal motivo agracedemos la supervisión y seguimiento a los Supervisores Regionales para que las agencias a su cargo, el Jefe de Plataforma en coordinación con el Gerente de Agencia, lo realicen a la brevedad posible y de esta manera cumplir con las normas vigentes.</p>';                                                                    
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);         
                   
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);               
      lv_mensaje := 
      '<p "font-family: Arial, sans-serif; font-size: 14px;">Detallamos el listado de Agencias:</p>'; 
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);               
      
      lv_mensaje :=                                              
              '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
              '<table cellspacing=0 cellpadding=3 width=900>';
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                 
      lv_mensaje :=         
      '  <tr>'||
      '    <td width="300" style="border-bottom: 1px solid black;"><b>Nombre Región:</b></td>'||
      '    <td width="300" style="border-bottom: 1px solid black;"><b>Nombre Zona:</b></td>'||
      '    <td width="300" style="border-bottom: 1px solid black;"><b>Nombre Sucursal:</b></td>'||        
      '    <td width="300" style="border-bottom: 1px solid black;"><b>Pendiente:</b></td>'||                 
      '  </tr>          ';                                   
      
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);    
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
          
      For j in c_listado(0,0) loop        
        lv_mensaje := 
        '  <tr>'||
        '    <td width="300" align="left">'||j.REGNOM||'</td>'||        
        '    <td width="300" align="left">'||j.DESZON||'</td>'||
        '    <td width="300" align="left">'||j.SCNOM||'</td>'||
        '    <td width="300" align="left">'||j.PENDIENTE||'</td>'||          
        '  </tr>                ';      
        
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                     
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
     End loop; 
     lv_mensaje := 
     '</table>'||
     '<br/>'||
     '<br/>'||         
     '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';    
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 

      --Enviamos el correo al JEFE DE OPERACIONES
      --obtenemos el correo 
      lc_usrori := '';
      lc_usrsup := '';
      lv_destinos:= '';   
      
      --OBTENEMOS EL USUARIO JEFE DE OPERACIONES DE LA GUIA
      begin
           Select trim(x.tp1desc)           
             into lc_usrori
             from fst198 x 
            where x.tp1cod = 1
              and x.tp1cod1 = 10825
              and x.tp1corr1 = 82
              and x.tp1corr2 = 5;
      exception
      when others then       
        lc_usrori := null;
      end;        
      
      --OBTENEMOS LA SUCURSAL DEL USUARIO
      begin
        Select a.ubsuc
          into ln_ubsuc 
          from fst046 a 
         where a.pgcod = 1 
           and a.ubuser = lc_usrori;
      exception
      when others then
        ln_ubsuc := 0;
      end;  
      
      if trim(lc_usrori) is not null then    
          lv_destinos := trim(lower(lc_usrori))||'@cajaarequipa.pe';
          if trim(lc_usrsup) is not null then
            lv_destinos := trim(lv_destinos) ||';' ||trim(lower(lc_usrsup))||'@cajaarequipa.pe';
          End If;                    
                                             
          begin           
            -- Call the procedure
            pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(lc_usrori)||'@cajaarequipa.pe',
                                             p_destinatarioscc   => CASE
                                                                      WHEN trim(lc_usrsup) is not null THEN
                                                                        trim(lc_usrsup)||'@cajaarequipa.pe'
                                                                      ELSE
                                                                        ''
                                                                     END,
                                             p_destinatariosbcc  => '',
                                             p_mensaje           => ll_mensaje,
                                             p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                             p_asunto            => 'Alerta de Arqueos',
                                             p_tipomensaje       => 'HTML',
                                             p_directorio        => '',
                                             p_archivosadjuntos  => '',
                                             p_c_coderr          => lc_coderr,
                                             p_c_deserr          => lc_deserr
                                             );

          end; 
      else
        lc_coderr := '00d';                                      
        lc_deserr := 'No existe usuario Jefe de Operaciones';           
        lv_destinos := null;
      end if;
              
      if lc_coderr = '000' then
         lc_estado := 'S';    
         lc_deserr := 'Envío Satisfactorio';             
      Else
         lc_estado := 'N';
      End If;  
            
      --registramos log de envios a JEFE DE OPERACIONES
      begin                  
          insert into jaqz187b(jaqz187bfep,
                               jaqz187bsuc,
                               jaqz187bhop,
                               jaqz187busp,
                               jaqz187best,
                               jaqz187bmot,
                               jaqz187bcue,
                               jaqz187bmai,
                               jaqz187bax7
                               )
                         values(ld_fecpro,
                                ln_ubsuc,
                                to_char(sysdate,'HH24:mi:ss'), 
                                lc_usrori,
                                lc_estado,
                                lc_deserr,
                                ll_mensaje,
                                lv_destinos,
                                'J'                          
                                );
                                commit;
      exception
      when dup_val_on_index then
          update jaqz187b a
             set a.jaqz187bhop = to_char(sysdate,'HH24:mi:ss'),
                 a.jaqz187busp = lc_usrori,
                 a.jaqz187best = lc_estado,
                 a.jaqz187bmot = lc_deserr,
                 a.jaqz187bcue = ll_mensaje,
                 a.jaqz187bmai = lv_destinos
           where a.jaqz187bfep = ld_fecpro
             and a.jaqz187bsuc = ln_ubsuc
             and a.jaqz187busp = lc_usrori
             and a.jaqz187bax7  = 'J';
             commit;
      when others then                        
          null;
      end;                             
      dbms_lob.freetemporary(ll_mensaje);                                         
  End if;  
exception
when others then  
  null;
end sp_ah_arqueo_notify_email;
/

