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
                                                  P_N_ITSBOR IN NUMBER) IS
                                                 
CUENTA   CHAR(32);
OPERADOR CHAR(10);
HORA     CHAR(8);
AGENCIA  CHAR(30);
correo   varchar2(50):= null;
usuario1 char(10);
lv_mensaje VARCHAR2(1000);---32767
lv_motivo  varchar2(100) := 'Cancelacion de DPF';
l_crlf     char(2) := Chr(13)||Chr(10);
NOMBRE     CHAR(30);
PLAZO      number;
moneda     char(4):= '';
tranx      varchar2(40);
lv_user    char(10):='';
lc_fecape  char(10);
lv_coderr  VARCHAR2(4000):='000'; 
lv_deserr  VARCHAR2(4000):='';
ln_pais    NUMBER(3):=0;
ln_tipo    NUMBER(2):=0;   
lc_numero  CHAR(12) :='';

--pragma autonomous_transaction;
begin
  CUENTA :=Lpad(trim(to_char(P_N_SCCTA)),9,'0') ||'-'|| Lpad(trim(to_char(P_N_SCMOD)),3,'0')  ||'-'||
           Lpad(trim(to_char(P_N_SCMDA)),3,'0') ||'-'|| Lpad(trim(to_char(P_N_SCOPER)),9,'0') ||'-'||
           Lpad(trim(to_char(P_N_SCTOPE)),3,'0');
           
  tranx  := Lpad(trim(to_char(P_N_PGCOD)),3,'0') ||'-'|| Lpad(trim(to_char(P_N_ITSUC)),3,'0')  ||'-'||
           Lpad(trim(to_char(P_N_ITMOD)),3,'0') ||'-'|| Lpad(trim(to_char(P_N_ITTRAN)),3,'0') ||'-'||
           Lpad(trim(to_char(P_N_ITNREL)),4,'0')||'-'|| Lpad(trim(to_char(P_N_ITORD)),3,'0') ||'-'|| 
           Lpad(trim(to_char(P_N_ITSBOR)),3,'0')||'-'||TRIM(TO_CHAR(P_D_FECCAN,'DDMMYYYY')) ;     
  Begin
    select scpzo
      into plazo
      from fsd011
     where pgcod = P_N_PGCOD
       and scsuc = P_N_SCSUC
       and scmda = P_N_SCMDA
       and scpap = P_N_SCPAP
       and sccta = P_N_SCCTA
       and scoper = P_N_SCOPER
       and scsbop = P_N_SCSBOP
       and sctope = P_N_SCTOPE
       and scmod = P_N_SCMOD ;
  exception
      when no_data_found then
        null;
  End;

  bEGIN
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
      Select yy.aqpa134usr
        into lv_user
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
      lv_user := null;
    END;  
      
    if lv_user is not null then     
        usuario1  := lv_user;
        CORREO    := trim(trim(lower(lv_user))||'@cajaarequipa.pe');
       
        BEGIN
          SELECT UBNOM 
            into NOMBRE 
            FROM FST746 
           WHERE UBUSER = lv_user;
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
  
  -------------------------------------------
   lv_mensaje := 'Estimado(a)'||NOMBRE||l_crlf;
   lv_mensaje := lv_mensaje|| l_crlf;
   lv_mensaje := lv_mensaje ||'Se cancelo la cuenta de DPF: '||CUENTA||l_crlf;
   lv_mensaje := lv_mensaje ||'Operacion: '||P_N_SCOPER||l_crlf;
   lv_mensaje := lv_mensaje ||'Fecha Cancelacion:'||P_D_FECCAN||l_crlf;
   lv_mensaje := lv_mensaje ||'Hora Cancelacion:'||HORA||l_crlf;
   lv_mensaje := lv_mensaje ||'Monto Cancelación:'||TO_CHAR(P_N_MONTO)||l_crlf;
   lv_mensaje := lv_mensaje ||'TEA asignada:'||TO_CHAR(P_N_TASINT)||l_crlf;
   lv_mensaje := lv_mensaje ||'Plazo:'||TO_CHAR(plazo)||l_crlf;
   lv_mensaje := lv_mensaje ||'Operador de Cancelacion:'||OPERADOR||l_crlf;
   lv_mensaje := lv_mensaje ||'Agencia Cancelación:'||AGENCIA||l_crlf;
   lv_mensaje := lv_mensaje|| l_crlf;
   lv_mensaje := lv_mensaje ||'Atentamente'|| l_crlf;
   lv_mensaje := lv_mensaje ||l_crlf;
   lv_mensaje := lv_mensaje ||'Caja Arequipa'|| l_crlf;
 --    lv_mensaje := trim(lv_mensaje);
--      mensaje := lv_mensaje;

   if correo <> '0' then


/*     sys.SP_SY_ENVIAMAIL(pc_aquien => Correo,--- sys.sp_sy_enviamail_html_silvia ---sys.sp_sy_enviamail_html
                                  pc_de => 'notificacionesbantotal@cajaarequipa.pe',--'bsanchez@cajaarequipa.pe',
                                  pc_motivo => lv_motivo,
                                  pc_mensaje => lv_mensaje-- ll_mensaje  mensaje --
                                  );---*/
                                  
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
     End If;                                                                        
                                   
     bEGIN
        if P_N_SCMDA = 0 then
          moneda := 'S./';
        else
          moneda :='U$./';
        end if;
    --    select to_char(sysdate,'HH24:mm:ss') into hora from dual;
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
                            jaqz551a5                   
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
                             P_N_TASINT,
                             plazo,
                             usuario1,
                             cuenta,
                             P_N_SCOPER,
                             agencia,
                             tranx,
                             operador,
                             lv_deserr
                             );   
                           
      EXCEPTION
        when dup_val_on_index then
          null;
      END;
                                          
   end if;
---commit; 
exception
  when others then
    null;
end SP_AH_ALERTDPFCANCEL;
/

