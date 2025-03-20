CREATE OR REPLACE TRIGGER TG_Z0E481_BD_01
  after delete on z0e481  
  for each row   
    declare
    usuario    varchar2(60);
    agencia    number;
    mensaje    varchar(1000);
    correo     varchar2(30);
    nomage     varchar2(30);
begin    
    usuario := SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), 1, 60);
    select ubsuc into agencia from fst046 where ubuser=rpad(trim(usuario),10,' ');     
    select scnom into nomage from fst001 where sucurs=agencia;
    select trim(tp1desc) into correo from fst198 where tp1cod=1 and tp1cod1=10801 and tp1corr1=37 and tp1corr2=2;
    
    mensaje := 'Nro Tarjeta: ' ||  trim(:old.z0e481nro) || CHR(13) ||
          'Usuario: ' || trim(usuario) || CHR(13) ||
          'Cod Agencia: ' || agencia || CHR(13) ||
          'Nom Agencia: ' || trim(nomage) || CHR(13) ||          
          'Fecha: ' || to_char(sysdate,'DD-MM-RRRR') || CHR(13) ||
          'Hora: ' || to_char(sysdate,'HH24:MI:SS') || CHR(13);                                          
      sys.sp_sy_enviamail(correo,
                          correo,
                          'RECHAZO ALTA DE TARJETA: ' || :old.z0e481nro,
                          mensaje
                          );  
exception
  when others then 
    null;                          
end TG_Z0E481_BD_01;
/

