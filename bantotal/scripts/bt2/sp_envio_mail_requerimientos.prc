create or replace procedure sp_envio_mail_requerimientos
is
    mensaje long;
    asunto varchar(150);
    agencia_anterior number (3);
    correo_agencia varchar(150);
begin
  agencia_anterior:= 0;
  mensaje:='<html><head>
      <title>Alerta de Bantotal: </title>
    </head>
    <body>
      <font size = 4 color=darkblue><br><i>
         <b>Alerta de Bantotal:</i></b><hr color=darkblue><br>
         <font color=darkblue size = 4 >Estimado representante de la Agencia, se le informa que tiene pendiente la atención de los siguientes requerimientos:<br><br>
      <font size = 4 color=black>
     <table BORDER= "1" CELLPADDING=2 width="95%" font-size:12px">
     <tr >
      <td  bgcolor="#038ED6" align="center"><b>Fecha de Recepción</b></center></td>
      <td  bgcolor="#038ED6" align="center"><b>N de Reclamo</b></center></td>
      <td  bgcolor="#038ED6" align="center"><b>Nombre de Cliente</i></b></center></td>
      <td  bgcolor="#038ED6" align="center"><b>Días</b></center></td>
      <td  bgcolor="#038ED6" align="center"><b>Estado</b></center></td>
     </tr>';

  DECLARE
     CURSOR C2 IS select to_char(JAQY290_rfcr,'MM/DD/YYYY'), jaqy290_RCOD, case jaqy290_rapp when ' ' then jaqy290_rnoj else concat(concat(concat(concat(rtrim(jaqy290_rapp),' '),rtrim(jaqy290_rapm)),' '),trim(jaqy290_rnom)) end  as nombre,
to_char(round(sysdate-JAQY290_rfcr,0)),case jaqy290_resr when 1 then 'Asignado' when 2 then 'En Trámite' end as estado, jaqy290_rage
from Jaqy290_r  where jaqy290_resr in (1,2)
and round(sysdate-JAQY290_rfcr,0) >=2 and jaqy290_rage=18
order by jaqy290_rage;
     fecha varchar(10);
     codigo varchar(20);
     nombre varchar (150);
     dias varchar(3);
     estado varchar(10);
     agencia number(3);
    BEGIN
     OPEN C2;
     LOOP
       FETCH C2 INTO fecha,codigo,nombre,dias,estado,agencia;
       EXIT WHEN C2%NOTFOUND;
       if ( agencia_anterior = 0) then
         agencia_anterior:=agencia;
       End If;
       if ( agencia_anterior<>agencia ) then
          select replace(replace(scnom, 'SN', 'SAN'),' ','') into correo_agencia from FST001 where sucurs=agencia_anterior;
          if (correo_agencia ='LIMA') then
           correo_agencia :='LIMACENTRO';
   End if;

          correo_agencia := concat('AO_',correo_agencia);
          correo_agencia := concat(correo_agencia,'@cajaarequipa.pe');
          mensaje := concat( mensaje,'</tr></table></font><br><br> Saludos Cordiales <br><b>Administrador Bantotal</b></font>
    </body>
    </html>');
          asunto:=concat ('Notificación de Atención de Requerimientos ',correo_agencia);
          send_mail(correo_agencia,'nbantotal@cajaarequipa.pe', asunto,mensaje);  -- ennvia al correo de la agencia
          mensaje:= '<html><head>
                      <title>Alerta de Bantotal: </title>
                    </head>
                    <body>
                      <font size = 4 color=darkblue><br><i>
                         <b>Alerta de Bantotal:</i></b><hr color=darkblue><br>
                         <font color=darkblue size = 4 >Estimado representante de la Agencia, se le informa que tiene pendiente la atención de los siguientes requerimientos:<br><br>
                      <font size = 4 color=black>
                     <table BORDER= "1" CELLPADDING=2 width="95%" font-size:12px">
                     <tr >
                      <td  bgcolor="#038ED6" align="center"><b>Fecha de Recepción</b></center></td>
                      <td  bgcolor="#038ED6" align="center"><b>N de Reclamo</b></center></td>
                      <td  bgcolor="#038ED6" align="center"><b>Nombre de Cliente</i></b></center></td>
                      <td  bgcolor="#038ED6" align="center"><b>Días</b></center></td>
                      <td  bgcolor="#038ED6" align="center"><b>Estado</b></center></td>
                     </tr>';
       End If;
          mensaje:= concat(mensaje,'<tr><td align="center">');
          mensaje:= concat(mensaje,fecha);
          mensaje:= concat(mensaje,'</center></td><td align="center">');
          mensaje:= concat(mensaje,codigo);
          mensaje:= concat(mensaje,'</center></td><td align="center">');
          mensaje:= concat(mensaje,nombre);
          mensaje:= concat(mensaje,'</center></td><td align="center">');
          mensaje:= concat(mensaje,dias);
          mensaje:= concat(mensaje,'</center></td><td align="center">');
          mensaje:= concat(mensaje,estado);
          mensaje:= concat(mensaje,'</center></td></tr>');
       agencia_anterior:=agencia;
     END LOOP;
     CLOSE C2;
   END;
   --este es para el caso del último registro que no se le envió el correo
   if ( agencia_anterior <> 0) then
      select replace(replace(scnom, 'SN', 'SAN'),' ','') into correo_agencia from FST001 where sucurs=agencia_anterior;
      if (correo_agencia ='LIMA') then
         correo_agencia :='LIMACENTRO';
      End if;

      correo_agencia := concat('AO_',correo_agencia);
      correo_agencia := concat(correo_agencia,'@cajaarequipa.pe');
      mensaje := concat( mensaje,'</tr></table></font><br><br> Saludos Cordiales <br><b>Administrador Bantotal</b></font>
    </body>
    </html>');
      asunto:=concat ('Notificación de Atención de Requerimientos ',correo_agencia);
      --asunto:='Notificación de Atención de Requerimientos ';
      send_mail(correo_agencia,'nbantotal@cajaarequipa.pe', asunto,mensaje);
    End if;
end sp_envio_mail_requerimientos;
/

