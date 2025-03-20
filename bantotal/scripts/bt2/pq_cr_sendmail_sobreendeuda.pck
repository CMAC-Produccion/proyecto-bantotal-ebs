create or replace package pq_cr_sendmail_sobreendeuda is

  -- Author  : RMONTESR
  -- Created : 7/02/2022 09:18:32
  -- Purpose : paquete para enviar correos a analistas sobreendeudamiento

  procedure sp_enviar_mail(pd_fechacorte in date, pn_tipo in number, pn_mailsenv out number);

end pq_cr_sendmail_sobreendeuda;
/

create or replace package body pq_cr_sendmail_sobreendeuda is

  procedure sp_enviar_mail(pd_fechacorte in date, pn_tipo in number, pn_mailsenv out number) is
  
    cursor lista_envio(ld_fec in date) is
      select distinct jaqa77cda from jaqa77 a where a.jaqa77fch = ld_fec;

    CURSOR lista_gerente(ld_fape   in date,
                         viagencia in number,
                         vicargo   in number) is
      select b.sng057usr
        from sng057 b, fst046 d
       where b.sng057usr = d.ubuser
         and b.sng055emp = d.pgcod
         and b.sng055emp = 1
         and b.sng055car = vicargo
         and (not (b.sng057ini <= ld_fape and b.sng057fin >= ld_fape AND
              b.sng057sup IS NOT NULL))
         and d.ubsuc = viagencia;
  
    ld_fecha date;
    vagencia fst046.ubsuc%type;
    --vubuser    fst046.ubuser%type := rpad(P_V_UBUSER, 10, ' ');
    vcargog   number(3) := 202;
    vanalista fst046.ubuser%type;
    vgerente  fst046.ubuser%type;
    vgerente2 fst046.ubuser%type;
  
    p_c_coderr varchar2(3);
    p_c_msgerr varchar2(100);
  
    lv_correog  VARCHAR2(4000) := '';
    lv_correog2 VARCHAR2(1000) := '';
    lv_cont     number := 0;
  
    lv_correoa VARCHAR2(4000) := '';
  
    lv_remitente VARCHAR2(90);
    lv_asunto    VARCHAR2(200);
    lv_mensaje   varchar2(500);
    
    ln_conta number;
    ln_maxcorr number;
  
  begin
    begin
      select max(w.aqpb396correl) into ln_maxcorr from aqpb396 w;
    exception
          when others then
            ln_maxcorr := 0;            
    end;
    
    ln_maxcorr := nvl(ln_maxcorr, 0)+1;
    begin
      select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
    end;
    if pn_tipo = 1 then
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados </p> <p>Ya se ejecutó el proceso de sobreendeudamiento línea correspondiente al  '||to_char(pd_fechacorte,'DD/MM/YYYY')||', por favor ingresar los formatos de  sobreendeudamiento en Bantotal. </p>';
      lv_asunto := 'Inicio del proceso de automatización de sobreendeudamiento linea';
    else
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Tener en cuenta que la fecha límite de registro del formato en bantotal es hasta fin de mes. En caso ya lo haya realizado obviar este mail.</p>';
      lv_asunto := 'Recordatorio del proceso de automatización de sobreendeudamiento linea';
    end if;
    lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    ln_conta:=0;
    for i in lista_envio(pd_fechacorte) loop
      begin
        --busca agencia de analista
      
        p_c_coderr := '00';
        vanalista := i.jaqa77cda;
        begin
          select a.ubsuc
            into vagencia
            from fst046 a
           where a.pgcod = 1
             and a.ubuser = i.jaqa77cda;
        exception
          when others then
            p_c_coderr := '01';
            p_c_msgerr := 'No se encontró agencia';
        end;
      
        if p_c_coderr = '00' then
        
          -- busca a gerente de agencia
        
          begin
            select b.sng057usr
              into vgerente
              from sng057 b, fst046 d, prfu00 p
             where b.sng057usr = d.ubuser
               and b.sng055emp = d.pgcod
               and b.sng055emp = 1
               and b.sng055car = vcargog
               and p.ubuser = d.ubuser
               and p.prfgcod not in ('CESADO')
               and d.ubsuc <> 904
               and (not (b.sng057ini <= ld_fecha and b.sng057fin >= ld_fecha AND
                    b.sng057sup IS NOT NULL))
               and d.ubsuc = vagencia;
          exception
            when too_many_rows then
              BEGIN
                lv_correog2 := '';
                lv_cont     := 1;
                FOR i in lista_gerente(ld_fecha, vagencia, vcargog) LOOP
                  BEGIN
                    vgerente2 := i.sng057usr;
                  
                    begin
                      select wfusremail
                        into lv_correog
                        from WFUSERS
                       where wfusrcod = vgerente2;
                    exception
                      when others then
                        p_c_coderr := '05';
                        p_c_msgerr := 'No se encontró correo gerente';
                    end;
                    if trim(lv_correog) <> '' or lv_correog is not null then
                      if lv_cont > 1 and lv_correog2 is not null and
                         trim(lv_correog2) <> '' then
                        lv_correog2 := trim(lv_correog2) || ';' ||
                                       trim(lv_correog);
                      else
                        lv_correog2 := trim(lv_correog);
                      end if;
                    end if;
                    lv_correog := '';
                    lv_cont    := lv_cont + 1;
                  END;
                END LOOP;
              END;
            when no_data_found then
              BEGIN
                select b.sng057sup
                  into vgerente
                  from sng057 b, fst046 d
                 where b.sng057usr = d.ubuser
                   and b.sng055emp = d.pgcod
                   and b.sng055emp = 1
                   and b.sng055car = vcargog
                   and b.sng057ini <= ld_fecha
                   and b.sng057fin >= ld_fecha
                   and d.ubsuc = vagencia;
              EXCEPTION
                WHEN OTHERS THEN
                  p_c_coderr := '02';
                  p_c_msgerr := 'No se encontró gerente SUPLENTE';
              END;
            when others then
              p_c_coderr := '02';
              p_c_msgerr := 'No se encontró gerente';
          end;
        end if;
        if vagencia = 904 then
          p_c_coderr := '00';
          vgerente   := 'GAGE01';
        end if;
      
        
        
      
        if p_c_coderr = '00' then
          if lv_correog2 is not null OR lv_correog2 <> '' then
            lv_correog := lv_correog2;
          else
            begin
              select wfusremail
                into lv_correog
                from WFUSERS
               where wfusrcod = vgerente;
            exception
              when others then
                p_c_coderr := '05';
                p_c_msgerr := 'No se encontró correo gerente';
            end;
          end if;
        end if;
      
        if p_c_coderr = '00' then
        
          begin
            select wfusremail
              into lv_correoa
              from WFUSERS
             where wfusrcod = vanalista;
          exception
            when others then
              p_c_coderr := '05';
              p_c_msgerr := 'No se encontró correo analista';
          end;
        end if;
      
        --if ln_conta<1 then
        begin
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_correoa,--'rmontesr@cajaarequipa.pe', 
                                           p_destinatarioscc   => '',
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => lv_mensaje,
                                           p_remitente         => lv_remitente,
                                           p_asunto            => lv_asunto,
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => 'DIR_EVALUACCRPRTE',
                                           p_archivosadjuntos  => '',
                                           p_c_coderr          => p_c_coderr,
                                           p_c_deserr          => p_c_msgerr);
        exception
            when others then
              null;
        end;
        --end if;
        insert into aqpb396
          (aqpb396usur,
           aqpb396ase,
           aqpb396fproc,
           aqpb396fcr,
           aqpb396hcr,
           aqpb396dest,
           aqpb396destcc,
           aqpb396destbcc,
           aqpb396mens,
           aqpb396coderr,
           aqpb396deserr,
           aqpb396mailg,
           aqpb396correl)
        values
          ('BANTPROD',
           vanalista,
           pd_fechacorte,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'),
           lv_correoa,
           '',
           '',
           substr(lv_mensaje,1,200),
           p_c_coderr,
           p_c_msgerr,
           lv_correog,
           ln_maxcorr);
        commit;
        ln_conta := ln_conta+1;
      end;
    end loop;
    --envio a gerentes
    for j in (select distinct aqpb396mailg from aqpb396 where aqpb396correl = ln_maxcorr) loop
      begin
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => j.aqpb396mailg,--'rmontesr@cajaarequipa.pe',--
                                           p_destinatarioscc   => '',
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => lv_mensaje,
                                           p_remitente         => lv_remitente,
                                           p_asunto            => lv_asunto,-- + ' gerentes' + j.aqpb396mailg,
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => 'DIR_EVALUACCRPRTE',
                                           p_archivosadjuntos  => '',
                                           p_c_coderr          => p_c_coderr,
                                           p_c_deserr          => p_c_msgerr);
       exception
            when others then
              null;
       end;
    end loop;
    -- envio a usuarios en guia
    for j in (select trim(tp1desc) correo_guia from fst198 a where a.tp1cod = 1 and a.tp1cod1= 7610 and a.tp1corr1 = 30) loop
      begin
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => j.correo_guia||'@cajaarequipa.pe',--'rmontesr@cajaarequipa.pe',--
                                           p_destinatarioscc   => '',
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => lv_mensaje,
                                           p_remitente         => lv_remitente,
                                           p_asunto            => lv_asunto,-- + ' guia',
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => 'DIR_EVALUACCRPRTE',
                                           p_archivosadjuntos  => '',
                                           p_c_coderr          => p_c_coderr,
                                           p_c_deserr          => p_c_msgerr);
       exception
            when others then
              null;
       end;
    end loop;
    pn_mailsenv := ln_conta;
  end;
end pq_cr_sendmail_sobreendeuda;
/

