create or replace package PQ_AH_CONTROL_OPE is

  -- Author  : YLOZADA
  -- Created : 7/07/2023 08:39:59
  -- Purpose : 
  

  procedure SP_AH_VALTIME(P_C_TIME1  IN VARCHAR2,
                          P_C_TIME2  IN VARCHAR2,
                          P_N_NUMMIN IN NUMBER,
                          p_c_flag   out varchar2          
                          );
  procedure sp_ah_mail_notjpla(P_D_FECPRO IN DATE,
                               P_C_HORA   IN VARCHAR2,                               
                               P_N_CODSUC IN NUMBER,
                               P_N_NUMOPE IN NUMBER,
                               P_N_TOTMIN IN NUMBER,  
                               P_N_PGCOD  IN NUMBER,  
                               P_N_SCSUC  IN NUMBER,  
                               P_N_SCMOD  IN NUMBER,  
                               P_N_SCMDA  IN NUMBER,  
                               P_N_SCPAP  IN NUMBER,  
                               P_N_SCCTA  IN NUMBER,  
                               P_N_SCOPER IN NUMBER,  
                               P_N_SCSBOP IN NUMBER,  
                               P_N_SCTOPE IN NUMBER,  
                               p_c_coderr out varchar2,
                               p_c_deserr out varchar2
                               );
  procedure sp_ah_reg_aqpa143(P_N_PGE IN NUMBER,
                              P_N_ITS IN NUMBER,
                              P_N_ITM IN NUMBER,
                              P_N_ITX IN NUMBER,
                              P_N_ITR IN NUMBER,
                              P_N_ORD IN NUMBER,
                              P_D_FEC IN DATE,
                              P_N_PGC IN NUMBER,
                              P_N_SUC IN NUMBER,
                              P_N_MOD IN NUMBER,
                              P_N_MDA IN NUMBER,
                              P_N_PAP IN NUMBER,
                              P_N_CTA IN NUMBER,
                              P_N_OPE IN NUMBER,
                              P_N_SBO IN NUMBER,
                              P_N_TPO IN NUMBER,
                              P_N_MTO IN NUMBER,
                              P_C_HOR IN VARCHAR2,
                              P_N_TCA IN NUMBER,
                              P_C_USU IN VARCHAR2 
                              );     
  procedure SP_AH_REPORTE(P_C_CODUSE  IN VARCHAR2,
                          P_N_CODAGE  IN VARCHAR2,
                          P_D_FECINI  IN DATE,
                          P_D_FECFIN  IN DATE
                          );                                                                                 
end PQ_AH_CONTROL_OPE;
/

create or replace package body PQ_AH_CONTROL_OPE is

  procedure SP_AH_VALTIME(P_C_TIME1  IN VARCHAR2,
                          P_C_TIME2  IN VARCHAR2,
                          P_N_NUMMIN IN NUMBER,
                          p_c_flag   out varchar2          
                          ) is
    ln_numseg number(18):=0;                                          
  begin
    Select (to_date(P_C_TIME1,'HH24:mi:ss')  - to_date(P_C_TIME2,'HH24:mi:ss'))*24*60*60 Into ln_numseg from dual;--segundos 
    if ln_numseg/60 > P_N_NUMMIN then
       p_c_flag := 'N';
    Else
       p_c_flag := 'S';
    End If;
  exception
  when others then  
    p_c_flag := 'N';
  end SP_AH_VALTIME;
  procedure sp_ah_mail_notjpla(P_D_FECPRO IN DATE,
                               P_C_HORA   IN VARCHAR2,
                               P_N_CODSUC IN NUMBER,
                               P_N_NUMOPE IN NUMBER,
                               P_N_TOTMIN IN NUMBER,  
                               P_N_PGCOD  IN NUMBER,  
                               P_N_SCSUC  IN NUMBER,  
                               P_N_SCMOD  IN NUMBER,  
                               P_N_SCMDA  IN NUMBER,  
                               P_N_SCPAP  IN NUMBER,  
                               P_N_SCCTA  IN NUMBER,  
                               P_N_SCOPER IN NUMBER,  
                               P_N_SCSBOP IN NUMBER,  
                               P_N_SCTOPE IN NUMBER,  
                               p_c_coderr out varchar2,
                               p_c_deserr out varchar2
                               ) is
  cursor c_operaciones is
  Select a.*,trim(UPPER(d.trnom)) operacion,trim(c.mosign)||' '||to_char(a.aqpa143mto,'9,999,999.90') lc_monto, a.aqpa143hor ithora
    from aqpa143 a,         
         fst198  b,
         fst005  c,
         fst034  d   
   Where AQPA143FEC = P_D_FECPRO
     and AQPA143PGC = P_N_PGCOD
     and AQPA143SUC = P_N_SCSUC
     and AQPA143MOD = P_N_SCMOD
     and AQPA143MDA = P_N_SCMDA
     and AQPA143PAP = P_N_SCPAP
     and AQPA143CTA = P_N_SCCTA
     and AQPA143OPE = P_N_SCOPER
     and AQPA143SBO = P_N_SCSBOP
     and AQPA143TPO = P_N_SCTOPE
     and AQPA143PGE = b.Tp1cod
     and AQPA143ITM = b.Tp1nro1
     and AQPA143ITX = b.Tp1nro2
     --and AQPA143ITS = P_N_CODSUC
     --and AQPA143USU = rpad(P_C_CODUSU,10,' ')
     and c.moneda = a.aqpa143mda
     and d.pgcod = a.aqpa143pge
     and d.trmod = b.tp1nro1
     and d.trnro = b.tp1nro2
     and b.tp1cod = 1
     and b.tp1cod1 = 10825
     and b.tp1corr1 = 127
     and b.tp1corr2 = 1
order by a.aqpa143hor desc;
                                                         
  lv_destinos     varchar2(400):= '';     
  lv_archivo      varchar2(21) := '';  
  lv_remitente    varchar2(100); 
  lv_asunto       varchar2(100);   
  lv_directorio   varchar2(100);    
  ll_mensaje      CLOB;
  lv_mensaje      VARCHAR2(32767);  
                                     
  lc_usrori       char(10);
  lc_usrsup       char(10); 
  lv_sucursal     varchar2(30);
  lc_hora         char(8);    
  lv_nombre       varchar2(30):='';
  ln_cont         number(9):= P_N_NUMOPE;
  lv_time1        varchar2(8):='';
  lv_time2        varchar2(8):='';  
  lv_flag         varchar2(1):='';  
  
  begin
  p_c_coderr := '000';                                             
  lv_destinos := '';            
  lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
  lv_asunto    := 'Alerta Operación consecutiva en efectivo';
        
  -- ARMADO DEL CUERPO        
  dbms_lob.createtemporary(ll_mensaje, TRUE);              
  lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) Usuario</p>'||  
               '<p "font-family: Arial, sans-serif; font-size: 14px;">Se informa sobre la OPERACION CONSECUTIVA N° '||P_N_NUMOPE||' realizada en el transcurso de '||P_N_TOTMIN||' minutos, en el sistema Bantotal.</p>';          
  lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);  
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
  
   lv_mensaje := --ll_mensaje ||                                                
              '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
              '<table cellspacing=0 cellpadding=2 width=800>';
   dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);               
              
        for i in c_operaciones loop     
            lc_hora  :=trim(i.ithora);--HORA FSD015 POST COMMIT       
            lv_time1 := TRIM(P_C_HORA);
            lv_time2 := TRIM(i.AQPA143HOR);
            pq_ah_control_ope.sp_ah_valtime(p_c_time1  => lv_time1,
                                            p_c_time2  => lv_time2,
                                            p_n_nummin => P_N_TOTMIN,
                                            p_c_flag   => lv_flag
                                            );   
    
            --obtenemos descripccion de la sucursal donde se hizo
            begin
              select trim(a.scnom)
                into lv_sucursal
                from fst001 a
               where a.pgcod  = 1
                 and a.sucurs = i.aqpa143its;
            exception
            when others then     
              lv_sucursal := '';
            end;      
          
            begin
              select trim(a.ubnom)
                into lv_nombre
                from FST746 a
               where a.ubuser = rpad(i.aqpa143usu,'10',' ');
            exception
            when others then     
              lv_nombre := '';
            end;                                                               
                
            If lv_flag = 'S' then
                if P_N_NUMOPE >= ln_cont and ln_cont >0 then
                    lv_mensaje :=               
                    '  <tr>'||
                    '    <td width="200" style="border-bottom: 1px solid black;"><b>Operación('||ln_cont||'):</b></td>'||
                    '    <td width="600" style="border-bottom: 1px solid black;"><b></b></td>'||
                    '  </tr>          ';
                    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);  
                    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);       
                   
                    lv_mensaje := 
                    '  <tr>'||
                    '    <td align="left">'||'Nombre:'||'</td>'||
                    '    <td align="left">'||trim(i.operacion)||'</td>'||
                    '  </tr>                ';       
                    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);             

                    lv_mensaje := 
                    '  <tr>'||
                    '    <td align="left">'||'Monto:'||'</td>'||
                    '    <td align="left">'||i.lc_monto||'</td>'||
                    '  </tr>                ';       
                    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
                                
                    lv_mensaje := 
                    '  <tr>'||
                    '    <td align="left">'||'Sucursal:'||'</td>'||
                    '    <td align="left">'||lv_sucursal||'</td>'||
                    '  </tr>                ';       
                    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                 
                    
                    lv_mensaje := 
                    '  <tr>'||
                    '    <td align="left">'||'Operador:'||'</td>'||
                    '    <td align="left">'||trim(i.aqpa143usu)||'-'||lv_nombre||'</td>'||
                    '  </tr>                ';       
                    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);           
                        
                    lv_mensaje := 
                    '  <tr>'||
                    '    <td align="left">'||'Fecha-Hora:'||'</td>'||
                    '    <td align="left">'||to_char(i.aqpa143fec,'dd/mm/rrrr')||' '||lc_hora||'</td>'||
                    '  </tr>                ';       
                    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
                Else
                  Exit;
                End If; 
                ln_cont := ln_cont -1 ;              
            End If;                                                                    
        End loop;
        
        lv_mensaje := 
        '</table>'||
        '<br/>'||
        '<br/>';      
                     
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
  lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';                                          
  lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
  
      --Obtenemos el correo del jefe de plataforma de la agencia correspondiente    
      begin                  
        Select b.sng057usr, b.sng057sup
          into lc_usrori, 
               lc_usrsup
          from fst046 a, 
               sng057 b 
         where a.pgcod     = b.sng055emp
           and a.ubuser    = b.sng057usr
           and a.ubsuc     = P_N_CODSUC
           and b.sng055car = 50 --JEFE DE PLATAFORMA                   
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
                   and c.ubsuc     = P_N_CODSUC
                   and d.sng055car = 50
               )
           and rownum < 2;
      exception
      when others then       
        lc_usrori := '';
        lc_usrsup := '';
      end;  
                     
    if trim(lc_usrori) is not null then        
      --Enviamos el correo
      CASE
      WHEN trim(lc_usrsup) is not null THEN
        lv_destinos := lower(trim(lc_usrori))||'@cajaarequipa.pe'||';'||lower(trim(lc_usrsup))||'@cajaarequipa.pe';
      ELSE
        lv_destinos := lower(trim(lc_usrori))||'@cajaarequipa.pe';
      END CASE; 
      
       --ENVIO MAIL
        begin
                -- Call the procedure
                pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                 p_destinatarioscc   => '',
                                                 p_destinatariosbcc  => '',
                                                 p_mensaje           => ll_mensaje,
                                                 p_remitente         => lv_remitente,
                                                 p_asunto            => lv_asunto,
                                                 p_tipomensaje       => 'HTML',
                                                 p_directorio        => lv_directorio,
                                                 p_archivosadjuntos  => lv_archivo,
                                                 p_c_coderr          => p_c_coderr,
                                                 p_c_deserr          => p_c_deserr
                                                 );
        exception
        when others then  
             p_c_coderr := '00x';
             p_c_deserr := sqlerrm;                                                   
        end; 
        if p_c_coderr = '000' then
           p_c_deserr := 'ENVIO SATISFACTORIO';       
        End If; 
      Else
        p_c_deserr := 'NO SE ENCONTRO USUARIO DE JPLA PARA ENVIO DE ARCHIVO';        
      End If;      
 
  dbms_lob.freetemporary(ll_mensaje);                  
  exception
  when others then  
    p_c_coderr := sqlcode;
    p_c_deserr := sqlerrm;       
  end sp_ah_mail_notjpla; 
  procedure sp_ah_reg_aqpa143(P_N_PGE IN NUMBER,
                              P_N_ITS IN NUMBER,
                              P_N_ITM IN NUMBER,
                              P_N_ITX IN NUMBER,
                              P_N_ITR IN NUMBER,
                              P_N_ORD IN NUMBER,
                              P_D_FEC IN DATE,
                              P_N_PGC IN NUMBER,
                              P_N_SUC IN NUMBER,
                              P_N_MOD IN NUMBER,
                              P_N_MDA IN NUMBER,
                              P_N_PAP IN NUMBER,
                              P_N_CTA IN NUMBER,
                              P_N_OPE IN NUMBER,
                              P_N_SBO IN NUMBER,
                              P_N_TPO IN NUMBER,
                              P_N_MTO IN NUMBER,
                              P_C_HOR IN VARCHAR2,
                              P_N_TCA IN NUMBER,
                              P_C_USU IN VARCHAR2 
                              ) is
  pragma autonomous_transaction;
  begin
      insert into AQPA143(AQPA143PGE,
                          AQPA143ITS,
                          AQPA143ITM,
                          AQPA143ITX,
                          AQPA143ITR,
                          AQPA143FEC,
                          AQPA143PGC,
                          AQPA143SUC,
                          AQPA143MOD,
                          AQPA143MDA,
                          AQPA143PAP,
                          AQPA143CTA,
                          AQPA143OPE,
                          AQPA143SBO,
                          AQPA143TPO,
                          AQPA143MTO,
                          AQPA143HOR,
                          AQPA143TCA,
                          AQPA143USU,
                          AQPA143ORD
                         ) values
                         (P_N_PGE, 
                          P_N_ITS,
                          P_N_ITM,
                          P_N_ITX, 
                          P_N_ITR, 
                          P_D_FEC, 
                          P_N_PGC, 
                          P_N_SUC, 
                          P_N_MOD, 
                          P_N_MDA, 
                          P_N_PAP, 
                          P_N_CTA, 
                          P_N_OPE, 
                          P_N_SBO, 
                          P_N_TPO, 
                          P_N_MTO, 
                          P_C_HOR, 
                          P_N_TCA, 
                          P_C_USU,
                          P_N_ORD 
                         );
                         commit;
  exception
  when others then
    null;  
  end sp_ah_reg_aqpa143;       
                            
  procedure SP_AH_REPORTE(P_C_CODUSE  IN VARCHAR2,
                          P_N_CODAGE  IN VARCHAR2,
                          P_D_FECINI  IN DATE,
                          P_D_FECFIN  IN DATE
                          ) is
  cursor c_data is
  select a.aqpa143fec,
         a.aqpa143pgc, 
         a.aqpa143suc,
         a.aqpa143mod, 
         a.aqpa143mda,
         a.aqpa143pap, 
         a.aqpa143cta, 
         a.aqpa143ope, 
         a.aqpa143sbo, 
         a.aqpa143tpo, 
         count(1) TOTAL 
    from aqpa143 a 
   where a.aqpa143pge = 1 
     and a.aqpa143its = decode(P_N_CODAGE,0,a.aqpa143its,P_N_CODAGE)                          
     and a.aqpa143fec >= P_D_FECINI
     and a.aqpa143fec <= P_D_FECFIN
  group by a.aqpa143fec,
           a.aqpa143pgc,
           a.aqpa143suc,
           a.aqpa143mod,
           a.aqpa143mda,
           a.aqpa143pap,
           a.aqpa143cta,
           a.aqpa143ope,
           a.aqpa143sbo,
           a.aqpa143tpo  
  having count(1) >= 2
  order by a.aqpa143fec,a.aqpa143cta,a.aqpa143sbo;
  
  
  cursor c_operaciones(ld_aqpa143fec in date,
                       ln_aqpa143pgc in number,
                       ln_aqpa143suc in number,
                       ln_aqpa143mod in number,
                       ln_aqpa143mda in number,
                       ln_aqpa143pap in number,
                       ln_aqpa143cta in number,
                       ln_aqpa143ope in number,
                       ln_aqpa143sbo in number,
                       ln_aqpa143tpo in number
                       ) is
  select a.* 
    from aqpa143 a 
   where a.aqpa143pge = 1 
     and a.aqpa143its = decode(P_N_CODAGE,0,a.aqpa143its,P_N_CODAGE)      
     and a.aqpa143fec = ld_aqpa143fec       
     and a.aqpa143pgc = ln_aqpa143pgc
     and a.aqpa143suc = ln_aqpa143suc
     and a.aqpa143mod = ln_aqpa143mod
     and a.aqpa143mda = ln_aqpa143mda
     and a.aqpa143pap = ln_aqpa143pap
     and a.aqpa143cta = ln_aqpa143cta
     and a.aqpa143ope = ln_aqpa143ope
     and a.aqpa143sbo = ln_aqpa143sbo
     and a.aqpa143tpo = ln_aqpa143tpo  
     and a.aqpa143fec = ld_aqpa143fec
  order by a.aqpa143hor DESC;
    
  cursor c_validos(ld_aqpa143fec in date,
                   ln_aqpa143pgc in number,
                   ln_aqpa143suc in number,
                   ln_aqpa143mod in number,
                   ln_aqpa143mda in number,
                   ln_aqpa143pap in number,
                   ln_aqpa143cta in number,
                   ln_aqpa143ope in number,
                   ln_aqpa143sbo in number,
                   ln_aqpa143tpo in number,
                   lc_aqpa143hor in varchar2
                   ) is
  select a.* 
    from aqpa143 a 
   where a.aqpa143pge = 1 
     and a.aqpa143its = decode(P_N_CODAGE,0,a.aqpa143its,P_N_CODAGE)      
     and a.aqpa143fec = ld_aqpa143fec       
     and a.aqpa143pgc = ln_aqpa143pgc
     and a.aqpa143suc = ln_aqpa143suc
     and a.aqpa143mod = ln_aqpa143mod
     and a.aqpa143mda = ln_aqpa143mda
     and a.aqpa143pap = ln_aqpa143pap
     and a.aqpa143cta = ln_aqpa143cta
     and a.aqpa143ope = ln_aqpa143ope
     and a.aqpa143sbo = ln_aqpa143sbo
     and a.aqpa143tpo = ln_aqpa143tpo  
     and ((to_date(lc_aqpa143hor,'HH24:mi:ss')  - to_date(a.aqpa143hor,'HH24:mi:ss'))*24*60<= 15 
           and 
          (to_date(lc_aqpa143hor,'HH24:mi:ss')  - to_date(a.aqpa143hor,'HH24:mi:ss'))*24*60 > 0 
         )
     --and  pq_ah_control_ope.fn_ah_valtime(lc_aqpa143hor,a.aqpa143hor,15) = 'S'
     and not exists (select 1 
                       from aqpa144 x 
                      where x.aqpa144pge = a.aqpa143pge
                        and x.aqpa144its = a.aqpa143its      
                        and x.aqpa144itm = a.aqpa143itm
                        and x.aqpa144itx = a.aqpa143itx
                        and x.aqpa144itr = a.aqpa143itr
                        and x.aqpa144fec = a.aqpa143fec
                        and x.aqpa144ord = a.aqpa143ord
                        and x.aqpa144use = rpad(P_C_CODUSE,10,' ')
                    )
  order by a.aqpa143hor;
  LN_CONT  NUMBER(10):=0;   
  begin
    delete from aqpa144 x where x.aqpa144use = rpad(P_C_CODUSE,10,' ');
    commit;
    
    For i in c_data loop
      For j in c_operaciones(i.aqpa143fec,
                             i.aqpa143pgc,
                             i.aqpa143suc,
                             i.aqpa143mod,
                             i.aqpa143mda,
                             i.aqpa143pap,
                             i.aqpa143cta,
                             i.aqpa143ope,
                             i.aqpa143sbo,
                             i.aqpa143tpo
                             ) loop
        LN_CONT := 0;                     
        For k in c_validos(j.aqpa143fec,
                           j.aqpa143pgc,
                           j.aqpa143suc,
                           j.aqpa143mod,
                           j.aqpa143mda,
                           j.aqpa143pap,
                           j.aqpa143cta,
                           j.aqpa143ope,
                           j.aqpa143sbo,
                           j.aqpa143tpo,
                           j.aqpa143hor        
                          ) loop
           LN_CONT := LN_CONT + 1;               
           begin
             insert into aqpa144(aqpa144use,
                                 aqpa144pge,
                                 aqpa144its,
                                 aqpa144itm,
                                 aqpa144itx,
                                 aqpa144itr,
                                 aqpa144fec,
                                 aqpa144pgc,
                                 aqpa144suc,
                                 aqpa144mod,
                                 aqpa144mda,
                                 aqpa144pap,
                                 aqpa144cta,
                                 aqpa144ope,
                                 aqpa144sbo,
                                 aqpa144tpo,
                                 aqpa144mto,
                                 aqpa144hor,
                                 aqpa144tca,
                                 aqpa144usu,
                                 aqpa144ord
                                 ) values
                                 (P_C_CODUSE,
                                  k.aqpa143pge,
                                  k.aqpa143its,
                                  k.aqpa143itm,
                                  k.aqpa143itx,
                                  k.aqpa143itr,
                                  k.aqpa143fec,
                                  k.aqpa143pgc,
                                  k.aqpa143suc,
                                  k.aqpa143mod,
                                  k.aqpa143mda,
                                  k.aqpa143pap,
                                  k.aqpa143cta,
                                  k.aqpa143ope,
                                  k.aqpa143sbo,
                                  k.aqpa143tpo,
                                  k.aqpa143mto,
                                  k.aqpa143hor,
                                  k.aqpa143tca,
                                  k.aqpa143usu,
                                  k.aqpa143ord
                                 );
                                 commit;
           exception
           when others then
             null;
           end;                          
        End Loop;  
        IF LN_CONT > 0 then
           begin
             insert into aqpa144(aqpa144use,
                                 aqpa144pge,
                                 aqpa144its,
                                 aqpa144itm,
                                 aqpa144itx,
                                 aqpa144itr,
                                 aqpa144fec,
                                 aqpa144pgc,
                                 aqpa144suc,
                                 aqpa144mod,
                                 aqpa144mda,
                                 aqpa144pap,
                                 aqpa144cta,
                                 aqpa144ope,
                                 aqpa144sbo,
                                 aqpa144tpo,
                                 aqpa144mto,
                                 aqpa144hor,
                                 aqpa144tca,
                                 aqpa144usu,
                                 aqpa144ord
                                 ) values
                                 (P_C_CODUSE,
                                  j.aqpa143pge,
                                  j.aqpa143its,
                                  j.aqpa143itm,
                                  j.aqpa143itx,
                                  j.aqpa143itr,
                                  j.aqpa143fec,
                                  j.aqpa143pgc,
                                  j.aqpa143suc,
                                  j.aqpa143mod,
                                  j.aqpa143mda,
                                  j.aqpa143pap,
                                  j.aqpa143cta,
                                  j.aqpa143ope,
                                  j.aqpa143sbo,
                                  j.aqpa143tpo,
                                  j.aqpa143mto,
                                  j.aqpa143hor,
                                  j.aqpa143tca,
                                  j.aqpa143usu,
                                  j.aqpa143ord
                                 );
                                 commit;  
           exception
           when others then
             null;
           end;                                           
        End iF;                                
      End Loop;
    End Loop;  
  exception
  when others then  
    null;
  end SP_AH_REPORTE;                              
end PQ_AH_CONTROL_OPE;
/

