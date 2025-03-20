create or replace package PQ_AH_EMAIL_TRX is

  -- Author  : YLOZADA
  -- Created : 21/05/2018 12:47:13 p. m.
  -- Purpose : 
  
  procedure sp_ah_envio(P_N_PGCOD  IN NUMBER,
                        P_N_ITSUC  IN NUMBER,
                        P_N_ITMOD  IN NUMBER, 
                        P_N_ITTRAN IN NUMBER,
                        P_N_ITNREL IN NUMBER,
                        P_N_ITORD  IN NUMBER,
                        P_N_ITSBO  IN NUMBER,
                        p_c_coderr out varchar2,
                        p_c_deserr out varchar2                             
                       );
  procedure sp_ah_pago_cred_agente(P_N_PGCOD  IN NUMBER,
                                   P_N_SCSUC  IN NUMBER,
                                   P_N_SCMOD  IN NUMBER,
                                   P_N_SCMDA  IN NUMBER,
                                   P_N_SCPAP  IN NUMBER,
                                   P_N_SCCTA  IN NUMBER,
                                   P_N_SCOPER IN NUMBER,
                                   P_N_SCSBOP IN NUMBER,
                                   P_N_SCTOPE IN NUMBER, 
                                   P_N_TIPMAI IN NUMBER, 
                                   P_D_FECPRO IN DATE,
                                   P_C_HORPRO IN VARCHAR2,
                                   P_C_DESTIN IN VARCHAR2,  
                                   P_N_ITSUC  IN NUMBER,
                                   P_N_ITMOD  IN NUMBER, 
                                   P_N_ITTRAN IN NUMBER,
                                   P_N_ITNREL IN NUMBER,
                                   p_c_coderr out varchar2,
                                   p_c_deserr out varchar2   
                                  );      
  function fn_ah_replace_tildes(P_C_CADENA in varchar2) return varchar2;                                             

  Procedure sp_deuda_fecha (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpxv in date, pn_mtocuo out number                               
                            );
end PQ_AH_EMAIL_TRX;
/

create or replace package body PQ_AH_EMAIL_TRX is

 procedure sp_ah_envio(P_N_PGCOD  IN NUMBER,
                       P_N_ITSUC  IN NUMBER,
                       P_N_ITMOD  IN NUMBER, 
                       P_N_ITTRAN IN NUMBER,
                       P_N_ITNREL IN NUMBER,
                       P_N_ITORD  IN NUMBER,
                       P_N_ITSBO  IN NUMBER,
                       p_c_coderr out varchar2,
                       p_c_deserr out varchar2   
                       ) is
  ln_tp1nro3 number(9):=0;    
  lv_mail    varchar2(100):= '';   
  
  ln_Pgcod   number(3);                              
  ln_ctnro   number(9);                             
  ln_Itoper  number(9);                             
  ln_Itsubo  number(3);                             
  ln_Itsucd  number(3);                             
  ln_Ittope  number(3);                             
  ln_Modulo  number(3);                             
  ln_Moneda  number(4);                             
  ln_Papel   number(4);         
  lv_hora    varchar2(8):='';   
  ld_fecpro  date;    
  begin
    p_c_coderr := '000';
    --Fecha de proceso
    begin
      Select a.pgfape
        into ld_fecpro
        from fst017 a
       where a.pgcod = P_N_PGCOD;
    exception
    when others then        
      ld_fecpro := trunc(sysdate);
    end;    
    --verificamos si la transacción esta autorizada para envío de constancia x email                       
    begin
      Select a.tp1nro3 
        into ln_tp1nro3
        from fst198 a 
        where a.tp1cod   = 1 
          and a.tp1cod1  = 10825 
          and a.tp1corr1 = 74 
          and a.tp1corr2 = 1
          and a.tp1nro1  = P_N_ITMOD
          and a.tp1nro2  = P_N_ITTRAN;
    exception
    when others then  
      ln_tp1nro3 := 0;
    end;
    if ln_tp1nro3 > 0 then
      --obtenemos los datos de la cuenta
      begin           
        select y.Pgcod,
               y.Ctnro,
               y.Itoper,
               y.Itsubo,
               y.Itsucd,
               y.Ittope,
               y.Modulo,
               y.Moneda,
               y.Papel,
               x.ithora
         into  ln_Pgcod, 
               ln_ctnro,
               ln_Itoper,
               ln_Itsubo,
               ln_Itsucd,
               ln_Ittope,
               ln_Modulo,
               ln_Moneda,
               ln_Papel,
               lv_hora
         from  FSD015 x,
               FSD016 y
        Where x.pgcod = y.pgcod
          and x.itsuc = y.itsuc
          and x.itmod = y.itmod
          and x.ittran = y.ittran
          and x.itnrel = y.itnrel
          and y.Pgcod   = P_N_PGCOD
          and y.Itsuc   = P_N_ITSUC
          and y.Itmod   = P_N_ITMOD
          and y.Ittran  = P_N_ITTRAN
          and y.Itnrel  = P_N_ITNREL
          and y.Itord   = P_N_ITORD
          and y.Itsbor  = P_N_ITSBO;
      Exception
      When others then
        ln_Pgcod  := 0;       
        ln_ctnro  := 0;    
        ln_Itoper := 0;    
        ln_Itsubo := 0;    
        ln_Itsucd := 0;    
        ln_Ittope := 0;    
        ln_Modulo := 0;    
        ln_Moneda := 0;    
        ln_Papel  := 0;    
        lv_hora   := '';     
      End;            
      --Dependiendo del tipo de trx invocamos al procedimiento correspondiente    
      case
        when ln_tp1nro3 = 2 then --pago de credito en agente
          if ln_ctnro > 0 then
            --Verificamos si esta afiliados para envío de email para dicho crédito
            begin
              Select trim(a.jaqy660afi) 
                into lv_mail
                from jaqy660 a 
                where a.jaqy660tip = 'C'
                  and a.jaqy660pgo = ln_Pgcod
                  and a.jaqy660suc = ln_Itsucd
                  and a.jaqy660mod = ln_Modulo
                  and a.jaqy660mda = ln_Moneda
                  and a.jaqy660cta = ln_ctnro
                  and a.jaqy660pap = ln_Papel
                  and a.jaqy660ope = ln_Itoper
                  and a.jaqy660sub = ln_Itsubo
                  and a.jaqy660top = ln_Ittope
                  and nvl(trim(a.jaqy660tme),'N') IN ('M','A');          
            exception
            when others then  
              lv_mail := null;
            end;  
            if lv_mail is not null then
              -- Call the procedure
              pq_ah_email_trx.sp_ah_pago_cred_agente(p_n_pgcod  => ln_Pgcod,
                                                     p_n_scsuc  => ln_Itsucd,
                                                     p_n_scmod  => ln_Modulo,
                                                     p_n_scmda  => ln_Moneda,
                                                     p_n_scpap  => ln_Papel,
                                                     p_n_sccta  => ln_ctnro,
                                                     p_n_scoper => ln_Itoper,
                                                     p_n_scsbop => ln_Itsubo,
                                                     p_n_sctope => ln_Ittope,
                                                     p_n_tipmai => ln_tp1nro3,
                                                     p_d_fecpro => ld_fecpro,
                                                     p_c_horpro => lv_hora,
                                                     p_c_destin => lv_mail,
                                                     p_n_itsuc  => P_N_ITSUC,
                                                     p_n_itmod  => P_N_ITMOD,
                                                     p_n_ittran => P_N_ITTRAN,
                                                     p_n_itnrel => P_N_ITNREL,
                                                     p_c_coderr => p_c_coderr,
                                                     p_c_deserr => p_c_deserr
                                                    );              
            end if;        
          Else
             p_c_coderr := '001';
             p_c_deserr := p_c_coderr||'-'||'No se encontro la cuenta cliente';
          End If;           
        Else 
          p_c_coderr := '002';
          p_c_deserr := 'No se encontró parametrización para envío de constancia por mail';
      end case;      
    else
      p_c_coderr := '003';
      p_c_deserr := 'Transacción no habilitada a envío de constancia por mail';      
    end if;            
  exception
  when others then    
    p_c_coderr := '004';
    p_c_coderr := p_c_coderr ||'-'||sqlerrm;    
  end sp_ah_envio;                       
  procedure sp_ah_pago_cred_agente(P_N_PGCOD  IN NUMBER,
                                   P_N_SCSUC  IN NUMBER,
                                   P_N_SCMOD  IN NUMBER,
                                   P_N_SCMDA  IN NUMBER,
                                   P_N_SCPAP  IN NUMBER,
                                   P_N_SCCTA  IN NUMBER,
                                   P_N_SCOPER IN NUMBER,
                                   P_N_SCSBOP IN NUMBER,
                                   P_N_SCTOPE IN NUMBER, 
                                   P_N_TIPMAI IN NUMBER,
                                   P_D_FECPRO IN DATE,
                                   P_C_HORPRO IN VARCHAR2,
                                   P_C_DESTIN IN VARCHAR2,                                   
                                   P_N_ITSUC  IN NUMBER,
                                   P_N_ITMOD  IN NUMBER, 
                                   P_N_ITTRAN IN NUMBER,
                                   P_N_ITNREL IN NUMBER,
                                   p_c_coderr out varchar2,
                                   p_c_deserr out varchar2   
                                  ) is  
  cursor c_datos(ln_tp1nro1 in number) is
    Select a.*
      from fst198 a 
      where a.tp1cod   = 1 
        and a.tp1cod1  = 10825 
        and a.tp1corr1 = 74 
        and a.tp1corr2 = P_N_TIPMAI
        and a.tp1nro1  = ln_tp1nro1
   order by 1,2,3,4,6,5,7; 
   
   cursor c_valores(lv_rubro in varchar2) is
    select trim(a.tp1desc)  rubro, 
           trim(b.tp1desc)  descri,
           a.tp1nro2        tiprub, 
           a.tp1nro2        tipseg
      from fst198 a,
           fst198 b
     Where a.tp1cod   = b.tp1cod
       and a.tp1cod1  = b.tp1cod1
       and a.tp1corr1 = b.tp1corr1
       and a.tp1corr3 = b.tp1corr3
       and a.tp1nro1  = b.tp1nro1
       and a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 75 
       and a.Tp1corr2 = 2
       and b.Tp1cod   = 1
       and b.Tp1cod1  = 10825
       and b.Tp1corr1 = 75 
       and b.Tp1corr2 = 3
       and instr(lv_rubro,trim(a.tp1desc)) > 0;
       
  cursor c_asiento(ln_indbah in number) is         
      Select a.itord,a.rubro,sum(a.itimp1) itimp1
       from fsd016 a
      where a.pgcod  = P_N_PGCOD
        and a.itsuc  = P_N_ITSUC
        and a.itmod  = P_N_ITMOD
        and a.ittran = P_N_ITTRAN 
        and a.itnrel = P_N_ITNREL 
        and a.itimp1 > 0
        and a.itdbha = ln_indbah
        and a.itord <> case
                       when ln_indbah = 1 then
                            55
                       when ln_indbah = 2 then
                            60
                       else
                            0 
                       end                           
   group by a.itord,a.rubro;
   
  
                 
  lv_remitente  varchar2(100)   := ''; 
  lv_destinos   varchar2(4000)  := '';
  lv_asunto     varchar2(200)   := ''; 
  lv_pie        varchar2(32767) := ''; 
  lv_mensaje    varchar2(32767) := ''; 
  lv_texto      varchar2(32767) := ''; 
  ll_mensaje    CLOB;  
  ln_tp1nro1    number(9)       := 0;
  ln_tp1nro2    number(9)       := 0;
  
  --variables para los datos
  lv_titular       varchar2(200)   := ''; 
  lv_credito       varchar2(200)   := ''; 
  lv_fecha         varchar2(200)   := ''; 
  lv_operacion     varchar2(200)   := ''; 
  lv_capital       varchar2(200)   := ''; 
  lv_interes       varchar2(200)   := ''; 
  lv_mora          varchar2(200)   := ''; 
  lv_seg           varchar2(200)   := ''; 
  lv_totpag        varchar2(200)   := ''; 
  lv_salcap        varchar2(200)   := ''; 
  lv_cuocan        varchar2(200)   := ''; 
  lv_prxven        varchar2(200)   := ''; 
  lv_nomana        varchar2(200)   := ''; 
  lv_celana        varchar2(200)   := ''; 
  lv_agente        varchar2(200)   := ''; 
  lv_dirage        varchar2(200)   := ''; 
  lv_itf           varchar2(200)   := ''; 
  lv_pena          varchar2(200)   := ''; 
  lv_otr           varchar2(200)   := ''; 
  lv_icv           varchar2(200)   := '';     
  
  lv_moneda        varchar2(4)     := ''; 
  ld_fecprx        date;
  ln_monprx        number(17,2)    := 0;    
  --ln_moninx        number(17,2)    := 0; 
  --ln_moncax        number(17,2)    := 0;    
  ln_salcap        number(17,2)    := 0;    
  ln_saltot        number(17,2)    := 0;    
  ln_cuocan        number(9)       := 0;
  ln_cuopag        number(9)       := 0;
  
  lv_tipo          varchar2(1)     := '';  
  ln_pais          number(3)       := 0;
  ln_tipdoc        number(2)       := 0;
  lc_numdoc        char(12)        := '';
  ln_paiana        number(3)       := 0;
  ln_tipana        number(2)       := 0;
  lc_numana        char(12)        := '';
  lc_usuario       char(10)        := '';
  lv_rubro         varchar2(16)    := '';
  ln_indbah        number(9)       := 0; 
  
  begin

    --obtenemos el correo origen que enviará el mail
    ln_tp1nro1 := 1;
    for i in c_datos(ln_tp1nro1) loop
      lv_remitente := lv_remitente || substr(i.tp1desc,1,i.tp1nro3);
    End loop; 
    if P_N_ITMOD > 500 then
        -- obtenemos el asunto del mensaje en caso de extorno
        ln_tp1nro1 := 3;
        for i in c_datos(ln_tp1nro1) loop
          lv_asunto := lv_asunto || substr(i.tp1desc,1,i.tp1nro3);
        End loop;           
    else
      -- obtenemos el asunto del mensaje
      ln_tp1nro1 := 2;
      for i in c_datos(ln_tp1nro1) loop
        lv_asunto := lv_asunto || substr(i.tp1desc,1,i.tp1nro3);
      End loop;     
    end if;      
        
  --obtener los datos      
    --Moneda del crédito
    begin
      Select a.mosign
        into lv_moneda 
        from fst005 a
       where Moneda = P_N_SCMDA;
    exception
    when others then        
      lv_moneda := '';
    end;
    
    --Titular del crédito
    begin
      Select a.pepais,
             a.petdoc, 
             a.pendoc
        into ln_pais, 
             ln_tipdoc, 
             lc_numdoc
        from fsr008 a
       where a.pgcod  = P_N_PGCOD
         and a.ctnro  = P_N_SCCTA
         and a.ttcod  = 1
         and a.cttfir = 'T';
    exception
    when others then        
      ln_pais   := 0;            
      ln_tipdoc := 0;     
      lc_numdoc := '';       
    end;       
    --obtenemos tipo
    begin
      Select a.petipo
        into lv_tipo
        from fsd001 a
       where a.pepais = ln_pais
         and a.petdoc = ln_tipdoc
         and a.pendoc = lc_numdoc; 
    exception
    when others then        
         lv_tipo:= '';
    end;  
       
    if lv_tipo = 'F' then
      --obtenemos el nombre 
      begin
        Select trim(a.pfape1)||' '||trim(a.pfape2)||', '||trim(a.pfnom1)||' '||trim(a.pfnom2)
          into lv_titular
          from fsd002 a
         where a.pfpais = ln_pais
           and a.pftdoc = ln_tipdoc
           and a.pfndoc = lc_numdoc; 
      exception
      when others then        
           lv_titular:= '';
      end;        
    Else
      --obtenemos el nombre 
      begin
        Select trim(a.pjrazs)
          into lv_titular
          from fsd003 a
         where a.pjpais = ln_pais
           and a.pjtdoc = ln_tipdoc
           and a.pjndoc = lc_numdoc; 
      exception
      when others then        
           lv_titular:= '';
      end;        
    End If;  
    lv_titular := fn_ah_replace_tildes(lv_titular);  
    
    lv_credito    := lpad(P_N_SCCTA,9,'0')||lpad(P_N_SCMDA,3,'0')||lpad(P_N_SCOPER,9,'0');
    --Armamos cabecera del mensaje    
    dbms_lob.createtemporary(ll_mensaje, TRUE);        
       
    lv_fecha      := to_char(P_D_FECPRO,'dd-mm-rrrr')||' '||P_C_HORPRO;
    lv_operacion  := to_char(P_D_FECPRO,'rrmmdd')||lpad(P_N_ITSUC,3,'0')||lpad(P_N_ITMOD,3,'0')||lpad(P_N_ITTRAN,3,'0')||lpad(P_N_ITNREL,4,'0');       
    --obtenemos saldo capital
    begin
      Select a.scsdo*(-1)
        into ln_salcap
        from fsd011 a
       where a.pgcod  = P_N_PGCOD
         and a.scsuc  = P_N_SCSUC
         and a.scmda  = P_N_SCMDA
         and a.scpap  = P_N_SCPAP
         and a.sccta  = P_N_SCCTA
         and a.scoper = P_N_SCOPER
         and a.scsbop = P_N_SCSBOP
         and a.sctope = P_N_SCTOPE
         and a.scmod  = P_N_SCMOD;
    exception
    when others then        
         ln_salcap := 0;
    end;  
    
    --obtenemos analista del credito
    begin
      -- Call the function
      lc_usuario := fn_analista_credito(v_scmod  => P_N_SCMOD,
                                        v_scsuc  => P_N_SCSUC,
                                        v_scmda  => P_N_SCMDA,
                                        v_scpap  => P_N_SCPAP,
                                        v_sccta  => P_N_SCCTA,
                                        v_scoper => P_N_SCOPER,
                                        v_scsbop => P_N_SCSBOP,
                                        v_sctope => P_N_SCTOPE
                                        );
    end;    
   
    --obtenemos el nombre del analista
    begin
      Select a.ubnom
        into lv_nomana
        from fst746 a
       where a.ubuser = lc_usuario;
    exception
    when others then        
      lv_nomana := '';
    end;     
     
    --obtenemos celular del analista
    begin
      Select a.jaqn002pai,
             a.jaqn002tdo,
             a.jaqn002ndo
        into ln_paiana,
             ln_tipana, 
             lc_numana
        from jaqn002 a
       where a.jaqn002pgc = P_N_PGCOD
         and a.jaqn002usr = lc_usuario;
    exception
    when others then        
      ln_paiana := 0;
      ln_tipana := 0; 
      lc_numana := '';
    end;  
        
    begin
      Select trim(a.dotelfp)
        into lv_celana
        from fsr005 a,
             sngc17 b
       where a.pepais = b.sngc17pais
         and a.petdoc = b.sngc17tdoc
         and a.pendoc = b.sngc17ndoc
         and a.docod  = b.sngc17dcod
         and a.pepais = ln_paiana
         and a.petdoc = ln_tipana
         and a.pendoc = lc_numana
         and b.sngc16ttel = 6
         and rownum < 2;
    exception
    when no_data_found then          
        begin
          Select a.jaql708tlf
            into lv_celana
            from jaql708 a
           where a.jaql708usr = lc_usuario;             
        exception
        when others then        
          lv_celana := '';
        end;       
    when others then        
      lv_celana:= '';
    end;   
    
    -- datos del agente
    begin
       select c.jaql2deter, 
              c.jaql2direc 
         into lv_agente,
              lv_dirage
         from jaql006 a,
              jaql009 b,
              jaql002 c
        where a.jaql9nuele = b.jaql9nuele
          and b.jaql2coter = c.jaql2coter
          and a.jaql6ctcod = P_N_PGCOD
          and a.jaql6ctmod = P_N_ITMOD
          and a.jaql6ctsuc = P_N_ITSUC
          and a.jaql6cttra = P_N_ITTRAN
          and a.jaql6ctrel = P_N_ITNREL
          and a.jaql6ctfco = P_D_FECPRO;
    exception
    when others then        
      lv_agente := '';
      lv_dirage := '';
    end;     
                 
    --Fecha próximo vencimiento
    begin
      -- Call the function
      ld_fecprx := pq_datos_acl.fn_fec_proximo_vto(pn_emp    => P_N_PGCOD,
                                                   pn_mod    => P_N_SCMOD,
                                                   pn_suc    => P_N_SCSUC,
                                                   pn_mda    => P_N_SCMDA,
                                                   pn_pap    => P_N_SCPAP,
                                                   pn_cta    => P_N_SCCTA,
                                                   pn_oper   => P_N_SCOPER,
                                                   pn_sbop   => P_N_SCSBOP,
                                                   pn_top    => P_N_SCTOPE,
                                                   pd_fecpro => P_D_FECPRO
                                                   );
    end;
    
    
/*    --Interes
    begin
      -- Call the function
      ln_moninx := pq_datos_acl.fn_interes_proximo_vto(pn_emp    => P_N_PGCOD,
                                                       pn_mod    => P_N_SCMOD,
                                                       pn_suc    => P_N_SCSUC,
                                                       pn_mda    => P_N_SCMDA,
                                                       pn_pap    => P_N_SCPAP,
                                                       pn_cta    => P_N_SCCTA,
                                                       pn_oper   => P_N_SCOPER,
                                                       pn_sbop   => P_N_SCSBOP,
                                                       pn_top    => P_N_SCTOPE,
                                                       pd_fecpro => P_D_FECPRO
                                                       );
    end;

    --Capital
    begin
      -- Call the function
      ln_moncax := pq_datos_acl.fn_monto_pagado(pn_emp    => P_N_PGCOD,
                                                pn_mod    => P_N_SCMOD,
                                                pn_suc    => P_N_SCSUC,
                                                pn_mda    => P_N_SCMDA,
                                                pn_pap    => P_N_SCPAP,
                                                pn_cta    => P_N_SCCTA,
                                                pn_oper   => P_N_SCOPER,
                                                pn_sbop   => P_N_SCSBOP,
                                                pn_top    => P_N_SCTOPE,
                                                pd_fecpro => P_D_FECPRO
                                                );
    end;    
    ln_monprx := ln_moninx + ln_moncax;    
    */    
    
    --Monto a pagar al próximo vencimiento
    begin
      -- Call the procedure
      pq_ah_email_trx.sp_deuda_fecha(pn_emp    => P_N_PGCOD,
                                     pn_mod    => P_N_SCMOD,
                                     pn_suc    => P_N_SCSUC,
                                     pn_mda    => P_N_SCMDA,
                                     pn_pap    => P_N_SCPAP,
                                     pn_cta    => P_N_SCCTA,
                                     pn_oper   => P_N_SCOPER,
                                     pn_sbop   => P_N_SCSBOP,
                                     pn_top    => P_N_SCTOPE,
                                     pd_fecpxv => ld_fecprx,
                                     pn_mtocuo => ln_monprx
                                     );
    end;
    
    
    
    --Cuotas canceladas
    begin
      -- Call the function
      ln_cuocan := pq_datos_acl.fn_cuotas_pagadas(pn_emp    => P_N_PGCOD,
                                                  pn_mod    => P_N_SCMOD,
                                                  pn_suc    => P_N_SCSUC,
                                                  pn_mda    => P_N_SCMDA,
                                                  pn_pap    => P_N_SCPAP,
                                                  pn_cta    => P_N_SCCTA,
                                                  pn_oper   => P_N_SCOPER,
                                                  pn_sbop   => P_N_SCSBOP,
                                                  pn_top    => P_N_SCTOPE,
                                                  pd_fecpro => P_D_FECPRO
                                                  );
     end;                                       

    --total cuotas
    begin
      -- Call the function
      ln_cuopag := pq_datos_acl.fn_cuotas_calen(pn_emp    => P_N_PGCOD,
                                                pn_mod    => P_N_SCMOD,
                                                pn_suc    => P_N_SCSUC,
                                                pn_mda    => P_N_SCMDA,
                                                pn_pap    => P_N_SCPAP,
                                                pn_cta    => P_N_SCCTA,
                                                pn_oper   => P_N_SCOPER,
                                                pn_sbop   => P_N_SCSBOP,
                                                pn_top    => P_N_SCTOPE
                                                );
     end;                                     
    -- fin datos  
         
    lv_salcap     := lv_moneda||' '||trim(to_char(ln_salcap,'9,999,990.00'));
    lv_cuocan     := ln_cuocan||'/'||ln_cuopag;
    lv_prxven     := to_char(ld_fecprx,'rrrr.mm.dd')||' - ' ||lv_moneda||' '||trim(to_char(ln_monprx,'9,999,990.00'));

          
  if P_N_ITMOD > 500 then                       
        lv_mensaje := '<p><FONT SIZE=3>'||'CONSTANCIA DE EXTORNO PAGO DE CREDITO - AGENTE CORRESPONSAL'||'</font></p>';             
  else
        lv_mensaje := '<p><FONT SIZE=3>'||'CONSTANCIA DE PAGO DE CREDITO - AGENTE CORRESPONSAL'||'</font></p>';         
  end if;             
   dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);     
     
   lv_mensaje := ' <table width="1000" height="54" border="0">
                    <tbody>                                  
                      <tr>
                        <td><FONT SIZE=3>Titular del cr&eacute;dito: <strong>'||lv_titular||'</strong></font></td>'||'
                      </tr>
                      <tr>
                        <td><FONT SIZE=3>Nro. de cr&eacute;dito: '||lv_credito||'</font></td>'||'                      
                      </tr>
                      <tr>
                        <td><FONT SIZE=3>Fecha y hora: '||lv_fecha||'</font></td>'||'
                      </tr>
                      <tr>
                        <td><FONT SIZE=3> <strong>N&uacute;mero de operaci&oacute;n: '||lv_operacion||'</strong></font></td>'||'                      
                      </tr>
                      <tr>
                        <td></td>'||'
                      </tr>';
  if P_N_ITMOD < 500 then  
    ln_indbah := 2;
  Else
    ln_indbah := 1;
  End If;                                            
    -- datos del asiento
    lv_texto := '';
    lv_pie   := '';
    for i in c_asiento(ln_indbah) loop
      ln_saltot := ln_saltot + i.itimp1;
      lv_rubro := substr(i.rubro,1,2)||'_'||substr(i.rubro,4,length(i.rubro)-3);
      for j in c_valores(lv_rubro) loop        
        lv_pie := fn_ah_replace_tildes(j.descri);
        case
          when j.tiprub = 1 then --capital
               lv_capital := lv_pie||': '||lv_moneda||' '||trim(to_char(i.itimp1,'9,999,990.00'));               
          when j.tiprub = 2 then --interes
               lv_interes := lv_pie||': '||lv_moneda||' '||trim(to_char(i.itimp1,'9,999,990.00'));
          when j.tiprub = 3 and i.itord = 20 then --Int.Com.Ven.
               lv_icv := 'Int.Com.Ven.'||': '||lv_moneda||' '||trim(to_char(i.itimp1,'9,999,990.00'));
          when j.tiprub = 3 and i.itord <> 20 then --mora
               lv_mora := lv_pie||': '||lv_moneda||' '||trim(to_char(i.itimp1,'9,999,990.00'));               
          when j.tiprub = 4 then --seguro
               lv_seg := lv_pie||': '||lv_moneda||' '||trim(to_char(i.itimp1,'9,999,990.00'));
               lv_texto := lv_texto || '
                 <tr>
                   <td><FONT SIZE=3>Seguro '||lv_seg||'</font></td>'||'
                 </tr>';
          when j.tiprub = 5 then --itf
               lv_itf := lv_pie||': '||lv_moneda||' '||trim(to_char(i.itimp1,'9,999,990.00'));
          when j.tiprub = 6 then --penalidad
               lv_pena := lv_pie||': '||lv_moneda||' '||trim(to_char(i.itimp1,'9,999,990.00'));               
          Else   
               lv_otr := 'Otros'||': '||lv_moneda||' '||trim(to_char(i.itimp1,'9,999,990.00'));               
        end case;    
      End Loop;  
    end loop; 
    
    lv_totpag     := lv_moneda||' '||trim(to_char(ln_saltot,'9,999,990.00')); 
    if lv_capital is null then
       lv_capital := 'Capital'||': '||lv_moneda||' '||trim(to_char(0,'9,999,990.00'));
    End if;    
    if lv_interes is null then
       lv_interes := 'Inter&eacute;s compensatorio'||': '||lv_moneda||' '||trim(to_char(0,'9,999,990.00'));
    End if;  
    if lv_mora is null then
       lv_mora := 'Mora'||': '||lv_moneda||' '||trim(to_char(0,'9,999,990.00'));
    End if;               
    lv_mensaje := lv_mensaje || '
                      <tr>
                        <td><FONT SIZE=3>'||lv_capital||'</font></td>
                      </tr>
                      <tr>
                        <td><FONT SIZE=3>'||lv_interes||'</font></td>
                      </tr>                                                          
                      <tr>
                        <td><FONT SIZE=3>'||lv_mora||'</font></td>
                      </tr>';
                                                
                      if lv_icv is not null then
                        lv_mensaje := lv_mensaje || '
                        <tr>
                          <td><FONT SIZE=3>'||lv_icv||'</font></td>
                        </tr> ';      
                      end if;
                      if lv_pena is not null then
                        lv_mensaje := lv_mensaje || '
                        <tr>
                          <td><FONT SIZE=3>'||lv_pena||'</font></td>
                        </tr> ';      
                      end if;
                      if lv_itf is not null then
                        lv_mensaje := lv_mensaje || '
                        <tr>
                          <td><FONT SIZE=3>'||lv_itf||'</font></td>
                        </tr> ';      
                      end if;    
                      if lv_otr is not null then
                        lv_mensaje := lv_mensaje || '
                        <tr>
                          <td><FONT SIZE=3>'||lv_otr||'</font></td>
                        </tr> ';      
                      end if;                                                                 
                      lv_mensaje := lv_mensaje || lv_texto;
                      
                      lv_mensaje := lv_mensaje || '                                    
                      <tr>
                        <td><FONT SIZE=3><strong>Total Pago: '||lv_totpag||'</strong></font></td>'||'
                      </tr>
                      <tr>
                        <td></td>
                      </tr>                                            
                      <tr>
                        <td><FONT SIZE=3>Saldo Capital: '||lv_salcap||'</font></td>'||'                      
                      </tr>                      	  
                      <tr>
                        <td><FONT SIZE=3>Cuotas canceladas: '||lv_cuocan||'</font></td>'||'
                      </tr>
                      <tr>
                        <td><FONT SIZE=3>Pr&oacute;ximo vencimiento: '||lv_prxven||'</font></td>'||'                      
                      </tr>                      	                                      	  
                      <tr>
                        <td></td>'||'
                      </tr>                                            
                      <tr>
                        <td><FONT SIZE=3>Analista: '||lv_nomana||'</font></td>'||'
                      </tr>
                      <tr>
                        <td><FONT SIZE=3>Celular analista: '||lv_celana||'</font></td>'||'                      
                      </tr>                      	  
                      <tr>
                        <td></td>'||'
                      </tr>                                            
                      <tr>
                        <td><FONT SIZE=3>Agente: '||lv_agente||'</font></td>'||'
                      </tr>
                      <tr>
                        <td><FONT SIZE=3>Ubicaci&oacute;n: '||lv_dirage||'</font></td>'||'                      
                      </tr>                      	
                      <tr>
                        <td></td>'||'
                      </tr> ';
  
   lv_mensaje := lv_mensaje || '</tbody></table>';               
   dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
    
    lv_mensaje := 
    '<p><FONT SIZE=3><strong>Saludos cordiales,<br/>Caja Arequipa</strong></font></p>';                                         
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                
   
    --Unimos con el pie del mensaje 
    ln_tp1nro1 := 4;
    ln_tp1nro2 := 0;
    lv_mensaje := '<p><FONT SIZE=2>';
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    lv_pie := '';
    for i in c_datos(ln_tp1nro1) loop
      if (ln_tp1nro2 = i.tp1nro2) or (ln_tp1nro2 = 0) then
         lv_pie := lv_pie || substr(i.tp1desc,1,i.tp1nro3);
      Else
         --registramos la parte del codigo en htmal al clob
         lv_pie := lv_pie||'<br/>';      
         lv_pie := fn_ah_replace_tildes(lv_pie);   
         dbms_lob.writeappend(ll_mensaje, length(lv_pie), lv_pie);
         --limpiamos el pie
         lv_pie := '';
         lv_pie := lv_pie || substr(i.tp1desc,1,i.tp1nro3);
      End If;
      ln_tp1nro2 := i.tp1nro2;
    End loop; 
    if lv_pie is not null then
         --registramos la parte del codigo en htmal al clob
         lv_pie := lv_pie||'<br/>';
         lv_pie := fn_ah_replace_tildes(lv_pie);
         dbms_lob.writeappend(ll_mensaje, length(lv_pie), lv_pie);         
    End If; 
    lv_mensaje := '</font></p>';
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
    
    --enviamos el mail
    lv_destinos := P_C_DESTIN;          
    begin
    -- Call the procedure
    pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                     p_destinatarioscc   => '',
                                     p_destinatariosbcc  => '',
                                     p_mensaje           => ll_mensaje,
                                     p_remitente         => lv_remitente,
                                     p_asunto            => lv_asunto,
                                     p_tipomensaje       => 'HTML',
                                     p_directorio        => '',
                                     p_archivosadjuntos  => '',
                                     p_c_coderr          => p_c_coderr,
                                     p_c_deserr          => p_c_deserr
                                     );
    exception
    when others then  
         p_c_coderr := '00x';
         p_c_deserr := sqlerrm;                                                   
    end;  
    dbms_lob.freetemporary(ll_mensaje);  
  exception
  when others then    
    p_c_coderr := '00z';
    p_c_coderr := p_c_coderr ||'-'||sqlerrm;        
  end sp_ah_pago_cred_agente;                                  
  Function fn_ah_replace_tildes(P_C_CADENA IN VARCHAR2) return VARCHAR2 is
    lv_cadena varchar2(32767);
    lv_car1   varchar2(30);
    lv_car2   varchar2(30);    
  cursor c_caracteres is
    Select a.*
      from fst198 a 
      where a.tp1cod   = 1 
        and a.tp1cod1  = 10825 
        and a.tp1corr1 = 75 
        and a.tp1corr2 = 1
   order by 1,2,3,4,6,5,7;     
  begin
    lv_cadena := P_C_CADENA;    
    for i in c_caracteres loop
      lv_car1 := substr(trim(i.tp1desc),1,1);
      lv_car2 := substr(trim(i.tp1desc),3,length(trim(i.tp1desc))-2);
      lv_cadena := replace(lv_cadena,lv_car1,lv_car2);
    End loop;    
    return lv_cadena;
  exception 
  when others then   
    return P_C_CADENA;              
  end fn_ah_replace_tildes;  
  Procedure sp_deuda_fecha (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpxv in date, pn_mtocuo out number
                           )  is
  begin
    
      begin
        select /*+ parallel(n,2,1)*/
               pq_cr_cuotamora.fn_monto_cuota(a.pgcod ,
                                              a.ppmod ,
                                              a.ppsuc ,
                                              a.ppmda ,
                                              a.pppap ,
                                              a.ppcta ,
                                              a.ppoper,
                                              a.ppsbop,
                                              a.pptope,
                                              a.ppfpag,
                                              a.ppcap,
                                              a.ppint,
                                              pd_fecpxv
                                              )
          into pn_mtocuo                                              
          from fsd601 a
         where a.pgcod  = pn_emp
           and a.ppcta  = pn_cta
           and a.ppmda  = pn_mda
           and a.ppsuc  = pn_suc
           and a.pppap  = pn_pap
           and a.ppoper = pn_oper
           and a.ppsbop = pn_sbop
           and a.pptope = pn_top
           and a.ppmod  = pn_mod
           and a.ppfpag = pd_fecpxv
           and a.d601co = 'S';
      exception
      when others then
           pn_mtocuo := 0;
      end;    
  exception
  when others then                                                  
    pn_mtocuo := 0;  
  end sp_deuda_fecha;                           
end PQ_AH_EMAIL_TRX;
/

