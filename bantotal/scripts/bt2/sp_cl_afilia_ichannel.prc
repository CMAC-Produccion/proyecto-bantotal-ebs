create or replace procedure sp_cl_afilia_ichannel(P_N_CODPAI IN NUMBER,
                                                  P_N_TIPDOC IN NUMBER,
                                                  P_C_NUMDOC IN VARCHAR2,                                                  
                                                  P_C_NUMCEL IN VARCHAR2,
                                                  P_C_EMAIL  IN VARCHAR2,         
                                                  p_c_coderr out varchar2,
                                                  p_c_deserr out varchar2
                                                  ) is
  lc_usuario char(10);       
  lc_nombre  varchar2(150);        
  lc_sexo    char(1);        
  cursor c_afiliaciones is
  select 'A'||lpad(b.sccta,9,'0')||lpad(b.scmod,3,'0')||lpad(b.scmda,3,'0')||lpad(b.scsbop,2,'0')||lpad(b.sctope,3,'0') c_cliente
    from fsr011 a,
         fsd011 b,
         fsr008 c        
   where a.r2cod  = b.pgcod
     and a.r2mod  = b.scmod
     and a.r2cta  = b.sccta
     and a.r2oper = b.scoper
     and a.r2sbop = b.scsbop
     and a.r2suc  = b.scsuc
     and a.r2mda  = b.scmda
     and a.r2pap  = b.scpap
     and a.r2tope = b.sctope
     and a.r1cod  = 1
     and c.pgcod  = b.pgcod
     and b.sccta  = c.ctnro
     and c.pepais = P_N_CODPAI 
     and c.petdoc = P_N_TIPDOC
     and c.pendoc = rpad(P_C_NUMDOC,12,' ')
     and a.relcod = 45 
     and a.r1cta  = 450603
     and c.ttcod  = 1
     and c.cttfir = 'T'
     union all
  select lc_usuario 
    from dual;
                             
begin
  p_c_coderr := '000';
  -- VERIFICAMOS SI ES TRABAJADOR
  begin
     select a.jaqn002usr
       into lc_usuario 
       from JAQN002 a
      where a.jaqn002pgc = 1
        and a.jaqn002pai = P_N_CODPAI
        and a.jaqn002tdo = P_N_TIPDOC
        and a.jaqn002ndo = rpad(P_C_NUMDOC,12,' ');
  exception
  when others then  
    lc_usuario := null;
  end;

  if lc_usuario is not null then
    
     Begin
       select trim(upper(x.pfape1))||' '||trim(upper(x.pfape2))||' , '||trim(upper(x.pfnom1))||' '||trim(upper(x.pfnom2)),
              decode(x.Pfcant,null,'M',x.Pfcant)
         into lc_nombre,
              lc_sexo
         from fsd002 x 
        where x.pfpais = P_N_CODPAI
          and x.pftdoc = P_N_TIPDOC
          and x.pfndoc = rpad(P_C_NUMDOC,12,' ');            
     Exception
     When others then  
          lc_nombre := null;       
     End;
     For i in c_afiliaciones loop          
         BEGIN                          
              INSERT INTO /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                      nombre_cliente,
                                                      mail_cliente,
                                                      celular_cliente,
                                                      sexo_cliente,
                                                      enviar_celular,
                                                      enviar_mail)
                                               values(trim(upper(i.c_cliente)),
                                                      lc_nombre,
                                                      trim(upper(P_C_EMAIL)),
                                                      to_number(trim(P_C_NUMCEL)),
                                                      lc_sexo,
                                                      decode(trim(P_C_NUMCEL),null,'N','S'),
                                                      decode(trim(P_C_EMAIL),null,'N','S')
                                                      );
         EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN  
             BEGIN                          
                 UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
                    SET mail_cliente    = decode(trim(upper(P_C_EMAIL)),null,mail_cliente,trim(upper(P_C_EMAIL))),
                        celular_cliente = decode(trim(P_C_NUMCEL),null,celular_cliente,trim(P_C_NUMCEL)),
                        enviar_celular  = decode(trim(P_C_NUMCEL),null,enviar_celular,'S'),
                        enviar_mail     = decode(trim(upper(P_C_EMAIL)),null,enviar_mail,'S')
                  WHERE codigo_cliente  = trim(upper(i.c_cliente));
             EXCEPTION
             WHEN OTHERS THEN
                p_c_coderr := '001';
                p_c_deserr := sqlerrm;           
             END;       
         END;
     End Loop;
     
  End If;
exception
when others then    
  p_c_coderr := '00x';
  p_c_deserr := sqlerrm;
end sp_cl_afilia_ichannel;
/

