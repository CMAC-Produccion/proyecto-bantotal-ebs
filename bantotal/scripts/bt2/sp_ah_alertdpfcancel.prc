create or replace procedure SP_AH_ALERTDPFCANCEL(P_N_PGCOD  IN number,
                                                 P_N_SCSUC  IN number,
                                                 P_N_SCMDA  IN number,
                                                 P_N_SCPAP  IN number,
                                                 P_N_SCCTA  IN number,
                                                 P_N_SCOPER IN number,
                                                 P_N_SCSBOP IN number,
                                                 P_N_SCTOPE IN number,
                                                 P_N_SCMOD  IN number,
                                                 P_N_TASINT IN number,
                                                 P_D_FECCAN IN date,
                                                 P_N_MONTO  IN NUMBER,
                                                 P_N_ITSUC  IN NUMBER,
                                                 P_N_ITMOD  IN NUMBER,
                                                 P_N_ITTRAN IN NUMBER,
                                                 P_N_ITNREL IN NUMBER,
                                                 P_N_ITORD  IN NUMBER,
                                                 P_N_ITSBOR IN NUMBER
                                                 ) IS
   -- *****************************************************************
    -- Nombre                     : SP_AH_ALERTDPFCANCEL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/01/2022
    -- Autor de Creación          : Silvia Marquez
    -- Uso                        : Notificaciones ejecutivos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 02/05/2025
    -- Autor de la Modificación   : Yrving Lozada  
    -- Modificación               : Se adicionó notificaciones para operaciones de Ahorros
    -- Fecha de Modificación      : 07/05/2025
    -- Autor de la Modificación   : Yrving Lozada  
    -- Modificación               : Se corrigió variable usuario
    -- Fecha de Modificación      : 08/05/2025
    -- Autor de la Modificación   : Yrving Lozada  
    -- Modificación               : Se agregó validación de usuario    
    -- *****************************************************************                                                    
                                                 
CUENTA   CHAR(32);
OPERADOR CHAR(10);
HORA     CHAR(8);
AGENCIA  CHAR(30);
correo   varchar2(50):= null;
usuario1 char(10);
lv_mensaje VARCHAR2(1000);---32767
lv_motivo  varchar2(100) := '';
l_crlf     char(2) := Chr(13)||Chr(10);
NOMBRE     CHAR(30);
PLAZO      number;
moneda     VARCHAR(5):= '';
tranx      varchar2(40);
lc_fecape  char(10);
lv_coderr  VARCHAR2(4000):='000'; 
lv_deserr  VARCHAR2(4000):='';
ln_pais    NUMBER(3):=0;
ln_tipo    NUMBER(2):=0;   
lc_numero  CHAR(12) :='';
ln_tiptrx  number(9):=0;
ln_Tasa    number(10,6):=0;
lc_tipo    varchar2(100):=0;
ln_limite  number(17,2):=0;

--pragma autonomous_transaction;
begin
  --
  -- VALIDAMOS PARAMETRIA PARA VERIFICAR SI APLICA O NO LA NOTIFICACIÓN
  --
  begin
    select x.tp1desc,x.tp1corr3, x.tp1imp3 
      into lv_motivo, ln_tiptrx, ln_limite
      from fst198 x 
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 132
       and x.tp1imp3  < P_N_MONTO 
       and x.tp1nro3  = P_N_SCMDA
       and x.tp1imp1  = P_N_SCMOD
       and x.tp1imp2  = P_N_SCTOPE       
       and x.tp1nro1  = P_N_ITMOD
       and x.tp1nro2  = P_N_ITTRAN;
  exception
  when others then     
    ln_tiptrx := 0;
    ln_limite := 0;
    lv_motivo := '';    
  end;
  --fin
  
  --
  -- SOLO SE NOTIFICA SI ESTA EN LA PARAMETRIA 
  --
  if ln_tiptrx > 0 then
      IF P_N_SCMOD = 22 THEN --CODIGO PARA DPF (CANCELACIONES)
          CUENTA :=Lpad(trim(to_char(P_N_SCCTA)),9,'0') ||'-'|| Lpad(trim(to_char(P_N_SCMOD)),3,'0')  ||'-'||
                   Lpad(trim(to_char(P_N_SCMDA)),3,'0') ||'-'|| Lpad(trim(to_char(P_N_SCOPER)),9,'0') ||'-'||
                   Lpad(trim(to_char(P_N_SCTOPE)),3,'0');
      ELSE
          CUENTA :=Lpad(trim(to_char(P_N_SCCTA)),9,'0') ||'-'|| Lpad(trim(to_char(P_N_SCMOD)),3,'0')  ||'-'||
                   Lpad(trim(to_char(P_N_SCMDA)),3,'0') ||'-'|| Lpad(trim(to_char(P_N_SCSBOP)),2,'0') ||'-'||
                   Lpad(trim(to_char(P_N_SCTOPE)),3,'0');        
      END IF;
                                        
      tranx  := Lpad(trim(to_char(P_N_PGCOD)),3,'0') ||'-'|| Lpad(trim(to_char(P_N_ITSUC)),3,'0')  ||'-'||
               Lpad(trim(to_char(P_N_ITMOD)),3,'0') ||'-'|| Lpad(trim(to_char(P_N_ITTRAN)),3,'0') ||'-'||
               Lpad(trim(to_char(P_N_ITNREL)),4,'0')||'-'|| Lpad(trim(to_char(P_N_ITORD)),3,'0') ||'-'|| 
               Lpad(trim(to_char(P_N_ITSBOR)),3,'0')||'-'||TRIM(TO_CHAR(P_D_FECCAN,'DDMMYYYY')) ;     

      --
      -- OPERADOR - HORA- AGENCIA
      --         
      BEGIN
        SELECT ITUING,
               ITHORA,
               (SELECT SCNOM FROM FST001 WHERE SUCURS = ITSUC)
          INTO OPERADOR,
               HORA,
               AGENCIA
          FROM FSD015
         WHERE PGCOD = P_N_PGCOD
           AND ITSUC = P_N_ITSUC
           AND ITMOD = P_N_ITMOD
           AND ITTRAN = P_N_ITTRAN
           AND ITNREL = P_N_ITNREL ;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
          
      --VERIFICAMOS SI ES UN CLIENTE CARTERIZADO
      BEGIN
          SELECT (SELECT UBNOM FROM FST746 WHERE UBUSER =B.jaql61user),
                 B.jaql61user ,
                 trim(trim(lower(B.jaql61user))||'@cajaarequipa.pe')
            into NOMBRE,
                 usuario1,
                 correo
            FROM FSR008 A,
                 JAQL061 B
           WHERE A.PGCOD  = 1
             AND A.CTNRO  = P_N_SCCTA
             AND A.TTCOD  = 1
             AND A.CTTFIR = 'T'
             AND B.JAQL61PGCO = A.PGCOD
             AND B.JAQL61PAIS = A.PEPAIS
             AND B.JAQL61TDOC = A.PETDOC
             AND B.JAQL61NDOC = A.PENDOC
             and b.jaql61esta ='S';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          CORREO := '0';     
        When others then
          CORREO := '0';    
      END;
          
      --
      -- SI NO ES CARTERIZADO
      --
      if CORREO = '0' then
        --OBTENENMOS FECHA DE LA APERTURA PARA SABER A QUIEN NOTIFICAR
        BEGIN
          Select to_char(z.aofval,'dd/mm/rrrr')
            into lc_fecape 
            from fsd010 z 
           where z.pgcod  = P_N_PGCOD    
             and z.aomod  = P_N_SCMOD
             and z.aosuc  = P_N_SCSUC
             and z.aomda  = P_N_SCMDA 
             and z.aopap  = P_N_SCPAP 
             and z.aocta  = P_N_SCCTA 
             and z.aooper = P_N_SCOPER
             and z.aosbop = P_N_SCSBOP
             and z.aotope = P_N_SCTOPE; 
        EXCEPTION
        WHEN OTHERS THEN
          lc_fecape := null;
        END;
            
        --VERIFICAMOS SI ES UN CLIENTE REFERIDO      
        BEGIN
            SELECT A.PEPAIS,
                   A.PETDOC,
                   A.PENDOC
              into ln_pais,
                   ln_tipo,
                   lc_numero
              FROM FSR008 A              
             WHERE A.PGCOD  = 1
               AND A.CTNRO  = P_N_SCCTA
               AND A.TTCOD  = 1
               AND A.CTTFIR = 'T';         
        EXCEPTION
        WHEN others THEN
          ln_pais   := 0;  
          ln_tipo   := 0;
          lc_numero := '';
        END;    
            
        BEGIN
          Select trim(trim(lower(yy.aqpa134usr))||'@cajaarequipa.pe')
            into CORREO
            from (Select xx.*
                    from (Select x.aqpa134fer,
                                 x.aqpa134pai,
                                 x.aqpa134tpo,
                                 x.aqpa134num,
                                 x.aqpa134usr
                            from AQPA134 x
                           where x.aqpa134est = 'P'
                           union all
                           Select y.jaql108fch,
                                  y.jaql108pai,
                                  y.jaql108ptd, 
                                  y.jaql108doc,
                                  y.jaql108usu
                             from jaql108 y
                         ) xx
                   where xx.aqpa134fer between to_date('01/' || substr(lc_fecape,4,2) || '/' ||substr(lc_fecape,7,4),'dd/mm/rrrr') and to_date(lc_fecape,'dd/mm/rrrr')
                     and xx.aqpa134pai = ln_pais
                     and xx.aqpa134tpo = ln_tipo
                     and xx.aqpa134num = lc_numero
                order by xx.aqpa134fer desc
                   )yy
           where rownum = 1;
        EXCEPTION
        WHEN OTHERS THEN
          CORREO := '0';
        END;  
              
        if CORREO = '0' then                    
            BEGIN
              SELECT UBNOM 
                into NOMBRE 
                FROM FST746 
               WHERE UBUSER = usuario1;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NOMBRE := '';     
              When others then
                NOMBRE := '';    
            END;
        End if;
            
        if CORREO = '0' then --SI NO ES CARTERIZADO NI GESTIONADO
            --OBTENEMOS DE LA GUIA
            BEGIN
              Select trim(trim(lower(z.tp1desc))||'@cajaarequipa.pe')
                into CORREO
                from fst198 z 
               where z.tp1cod   = 1
                 and z.tp1cod1  = 10825
                 and z.tp1corr1 = 120
                 and z.tp1corr2 = 1;
                     
                 NOMBRE := 'BUZON';
                 usuario1  := 'BUZON';
            EXCEPTION
            WHEN OTHERS THEN
              CORREO := '0';
            END;
        End if;         
      End if;
      
      if P_N_SCMDA = 0 then
        moneda := 'S./ ';
      else
        moneda :='U$./ ';
      end if;      
      --
      -- ARMAMOS EL CUERPO DEL MENSAJE PARA EL MAIL
      --   
          if ln_tiptrx = 1 then --CANCELACION  DPF     
          -------------------------------------------
           lv_mensaje := 'Estimado(a) '||NOMBRE||l_crlf;
           lv_mensaje := lv_mensaje|| l_crlf;           
           lv_mensaje := lv_mensaje ||'MODULO '||P_N_SCMOD||l_crlf;
           lv_mensaje := lv_mensaje ||'Se CANCELO la cuenta de DPF: '||CUENTA||l_crlf;
           lv_mensaje := lv_mensaje ||'Operacion: '||P_N_SCOPER||l_crlf;
           lv_mensaje := lv_mensaje ||'Fecha CANCELACION:'||trim(to_char(P_D_FECCAN,'dd/mm/rrrr'))||l_crlf;
           lv_mensaje := lv_mensaje ||'Hora CANCELACION:'||HORA||l_crlf;
           lv_mensaje := lv_mensaje ||'Monto CANCELACION:'||trim(TO_CHAR(P_N_MONTO,'99,999,990.90'))||l_crlf;
           lv_mensaje := lv_mensaje ||'TEA asignada:'||trim(TO_CHAR(P_N_TASINT,'990.90'))||'%'||l_crlf;
           lv_mensaje := lv_mensaje ||'Operador de CANCELACION:'||OPERADOR||l_crlf;
           lv_mensaje := lv_mensaje ||'Agencia CANCELACION:'||AGENCIA||l_crlf;
           lv_mensaje := lv_mensaje|| l_crlf;
           lv_mensaje := lv_mensaje ||'Atentamente'|| l_crlf;
           lv_mensaje := lv_mensaje ||l_crlf;
           lv_mensaje := lv_mensaje ||'Caja Arequipa'|| l_crlf;
          End If;
          
          if ln_tiptrx = 2 then --CANCELACION AHORROS      
            
              PQ_AH_PRODUCTIVIDAD.Tasa(vpgcod  => P_N_PGCOD,       
                                       vScsuc  => P_N_SCSUC,       
                                       vSccta  => P_N_SCCTA,       
                                       vScmda  => P_N_SCMDA,       
                                       vScpap  => P_N_SCPAP,       
                                       vScoper => P_N_SCOPER,     
                                       vScsbop => P_N_SCSBOP,     
                                       vSctope => P_N_SCTOPE,     
                                       vScmod  => P_N_SCMOD,       
                                       vSfval  => P_D_FECCAN,
                                       vmonto  => P_N_MONTO,
                                       vplazo  => 0,
                                       Tasa => ln_Tasa
                                       );           
          -------------------------------------------
           lv_mensaje := 'Estimado(a) '||NOMBRE||l_crlf;
           lv_mensaje := lv_mensaje|| l_crlf;           
           lv_mensaje := lv_mensaje ||'MODULO '||P_N_SCMOD||l_crlf;
           lv_mensaje := lv_mensaje ||'Se CANCELO la cuenta de AH: '||CUENTA||l_crlf;
           lv_mensaje := lv_mensaje ||'Operacion: '||tranx||l_crlf;
           lv_mensaje := lv_mensaje ||'Fecha CANCELACION:'||trim(to_char(P_D_FECCAN,'dd/mm/rrrr'))||l_crlf;
           lv_mensaje := lv_mensaje ||'Hora CANCELACION:'||HORA||l_crlf;
           lv_mensaje := lv_mensaje ||'Monto CANCELACION:'||trim(TO_CHAR(P_N_MONTO,'99,999,990.90'))||l_crlf;
           lv_mensaje := lv_mensaje ||'TEA asignada:'||trim(TO_CHAR(ln_Tasa,'990.90'))||'%'||l_crlf;
           lv_mensaje := lv_mensaje ||'Operador de CANCELACION:'||OPERADOR||l_crlf;
           lv_mensaje := lv_mensaje ||'Agencia CANCELACION:'||AGENCIA||l_crlf;
           lv_mensaje := lv_mensaje|| l_crlf;
           lv_mensaje := lv_mensaje ||'Atentamente'|| l_crlf;
           lv_mensaje := lv_mensaje ||l_crlf;
           lv_mensaje := lv_mensaje ||'Caja Arequipa'|| l_crlf;
          End If;       
          
          if ln_tiptrx in (3,4) then --RETIRO/TRANSFERENCIA    
              PQ_AH_PRODUCTIVIDAD.Tasa(vpgcod  => P_N_PGCOD,       
                                       vScsuc  => P_N_SCSUC,       
                                       vSccta  => P_N_SCCTA,       
                                       vScmda  => P_N_SCMDA,       
                                       vScpap  => P_N_SCPAP,       
                                       vScoper => P_N_SCOPER,     
                                       vScsbop => P_N_SCSBOP,     
                                       vSctope => P_N_SCTOPE,     
                                       vScmod  => P_N_SCMOD,       
                                       vSfval  => P_D_FECCAN,
                                       vmonto  => 0,
                                       vplazo  => 0,
                                       Tasa => ln_Tasa
                                       );  
            if ln_tiptrx = 3 then
               lc_tipo := 'RETIRO';
            End If;                                                                               
            if ln_tiptrx = 4 then
               lc_tipo := 'TRANSFERENCIA';
            End If;            
          -------------------------------------------
           lv_mensaje := 'Estimado(a) ' ||NOMBRE||l_crlf;
           lv_mensaje := lv_mensaje|| l_crlf;           
           lv_mensaje := lv_mensaje|| 'MODULO '||P_N_SCMOD||l_crlf;
           lv_mensaje := lv_mensaje ||'Se hizo '||TRIM(lc_tipo)||' de la cuenta de AH: '||CUENTA||l_crlf;
           lv_mensaje := lv_mensaje ||'Operacion: '||tranx||l_crlf;
           lv_mensaje := lv_mensaje ||'Fecha '||trim(lc_tipo)||':'||trim(to_char(P_D_FECCAN,'dd/mm/rrrr'))||l_crlf;
           lv_mensaje := lv_mensaje ||'Hora '||trim(lc_tipo)||':'||HORA||l_crlf;
           lv_mensaje := lv_mensaje ||'Monto '||trim(lc_tipo)||':'||' Mayor a '||MONEDA||trim(to_char(ln_limite,'99,999,990.90'))||l_crlf;
           lv_mensaje := lv_mensaje ||'TEA asignada:'||trim(TO_CHAR(ln_Tasa,'990.90'))||'%'||l_crlf;
           lv_mensaje := lv_mensaje ||'Operador de '||trim(lc_tipo)||':'||OPERADOR||l_crlf;
           lv_mensaje := lv_mensaje ||'Agencia '||trim(lc_tipo)||':'||AGENCIA||l_crlf;
           lv_mensaje := lv_mensaje|| l_crlf;
           lv_mensaje := lv_mensaje ||'Atentamente'|| l_crlf;
           lv_mensaje := lv_mensaje ||l_crlf;
           lv_mensaje := lv_mensaje ||'Caja Arequipa'|| l_crlf;
          End If;              

           --Correo:= 'ylozada@cajaarequipa.pe';
           if correo <> '0' and trim(usuario1) is not null then                                         
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => Correo,
                                               p_destinatarioscc   => '',
                                               p_destinatariosbcc  => '',
                                               p_mensaje           => lv_mensaje,
                                               p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                               p_asunto            => lv_motivo,
                                               p_tipomensaje       => 'TEXT',
                                               p_directorio        => '',
                                               p_archivosadjuntos  => '',
                                               p_c_coderr          => lv_coderr,
                                               p_c_deserr          => lv_deserr
                                               );   
             If lv_coderr = '000' then
                lv_deserr := 'ENVIO SATISFACTORIO';
             Else
                lv_deserr := substr(lv_deserr,1,40);   
                --
                -- REGISTRAMOS EL RENVIO
                --
                PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 5,
                                                          P_C_ASUNTO => lv_motivo,
                                                          P_C_DESPAR => Correo,
                                                          P_C_DESCOC => '',
                                                          P_C_DESCCO => '',
                                                          P_C_MENSAJ => lv_mensaje,
                                                          P_C_REMITE => 'notificacionesbantotal@cajaarequipa.pe',
                                                          P_C_DIRECT => '',
                                                          P_C_ADJUNT => '',
                                                          P_N_AUX001 => NULL,
                                                          P_N_AUX002 => NULL,
                                                          P_N_AUX003 => NULL,
                                                          P_N_AUX004 => NULL,
                                                          P_D_AUX005 => NULL,
                                                          P_D_AUX006 => NULL,
                                                          P_C_AUX007 => '',
                                                          P_C_AUX008 => '',
                                                          P_C_AUX009 => CUENTA,
                                                          p_c_coderr => lv_coderr,
                                                          p_c_msgerr => lv_deserr
                                                          );                                
             End If;                                                                        
                                           
             BEGIN

                
                --
                --LOG DE ENVIO DE CORREO
                --
                INSERT INTO JAQZ551(jaqz551pgc, 
                                    jaqz551isuc1, 
                                    jaqz551mod, 
                                    jaqz551tran, 
                                    jaqz551rel, 
                                    jaqz551ord, 
                                    jaqz551sord,
                                    jaqz551fech,
                                    jaqz551hora,
                                    jaqz551mto,
                                    jaqz551mda,
                                    jaqz551tasa,
                                    jaqz551plz,
                                    jaqz551usu,
                                    jaqz551cta,
                                    jaqz551ope,
                                    jaqz551suc,
                                    jaqz551trax ,
                                    jaqz551a4,
                                    jaqz551a5,
                                    jaqz551a1,   ---subope
                                    jaqz551a3,   ---modulo
                                    jaqz551a8,   ---tipope
                                    jaqz551a9    ---codigo tipo de transaccion                                                        
                                    )
                              Values(P_N_PGCOD,
                                     P_N_ITSUC,
                                     P_N_ITMOD,
                                     P_N_ITTRAN,
                                     P_N_ITNREL,
                                     P_N_ITORD,
                                     P_N_ITSBOR,                         
                                     P_D_FECCAN,
                                     HORA,
                                     P_N_MONTO,
                                     moneda,                         
                                     decode(P_N_TASINT,0,ln_Tasa,P_N_TASINT),
                                     plazo,
                                     usuario1,
                                     cuenta,
                                     P_N_SCOPER,
                                     agencia,
                                     tranx,
                                     operador,
                                     lv_deserr,
                                     P_N_SCSBOP,
                                     P_N_SCMOD,                                     
                                     P_N_SCTOPE,
                                     ln_tiptrx                                                 
                                     );   
                                   
              EXCEPTION
                when dup_val_on_index then
                  null;
              END;
                                                  
           end if;
       End If;           
exception
  when others then
    null;
end SP_AH_ALERTDPFCANCEL;
/
