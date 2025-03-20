create or replace package pq_cr_Facturacion_mail is

  -- Author  : RMOGROVEJO
  -- Created : 27/06/2018 11:48:29 a.m.
  -- Purpose : 
                            
PROCEDURE sp_envio_factura(PC_envio out VARCHAR2);

PROCEDURE sp_envio_nota_credito(PC_envio out VARCHAR2);
  
end pq_cr_Facturacion_mail;
/

create or replace package body pq_cr_Facturacion_mail is

PROCEDURE sp_envio_factura(PC_envio out VARCHAR2) is
 
pn_sucursal number;
pc_serie char(4);
pn_correlativo number(8);
pd_fecha date;
pc_receptor VARCHAR2(70);
pc_correo  VARCHAR2(16):='@cajaarequipa.pe';
pn_dia_atr date;
lv_mensaje VARCHAR2(2000);  
lc_usuario char(20);
ln_perfil number;
SERIE CHAR(4);
CORRE NUMBER;
                   
cursor aqpa465 is 

     select * from aqpa465 a 
         where a.aqpa465est in ('E','R');
         
cursor fst198 is 

    select tp1corr3 
     from fst198 a 
     where a.tp1cod= 1 
     and a.tp1cod1=11120 
     and a.tp1corr1=1
     and a.tp1corr2=700
     and a.tp1corr3 >0;
     
cursor fst046 is 

     select a.ubuser from fst046 a
     inner join sng057 b on trim(a.ubuser)=trim(b.sng057usr)
      where a.ubsuc= pn_sucursal and b.sng055car=ln_perfil;

begin
  begin   
    
  for p in aqpa465 loop   
     pn_sucursal:= p.aqpa465sucor;
     pc_serie := p.aqpa465serie;
     pn_correlativo :=p.aqpa465corr;
     pd_fecha := p.aqpa465fec;    
     SERIE:=P.AQPA465SERIE;
     CORRE:=P.AQPA465CORR;
     
      for b in fst198 loop 
         ln_perfil := b.tp1corr3;

        for a in  fst046 loop 
           lc_usuario := trim(a.ubuser);
               
  --  pc_receptor:=CONCAT(TRIM(LOWER(p.aqpa465usu)),pc_correo);
    pc_receptor:=CONCAT(TRIM(LOWER(lc_usuario)),pc_correo);
 

    pn_dia_atr:= P.AQPA465CON+7;
    
           lv_mensaje:='<html><head>	<style type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style></head><body>         <br>
           <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">Estimado.</p><p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">
           El documento  '||TO_CHAR(p.aqpa465serie)||'-'||TO_CHAR(p.aqpa465corr)|| ' con fecha '||TO_CHAR(p.aqpa465con)||' se encuentra pendiente de mantenimiento.'||
           '</p> <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">La fecha limite de envio a SUNAT es '||TO_CHAR(pn_dia_atr)|| '.'||
           '</p> <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">
           Gracias y Saludos.</p></body></html>';



         sys.sp_sy_enviamail_html(pc_aquien =>pc_receptor,--- sys.sp_sy_enviamail_html_silvia
                                  pc_de => 'FacturacionElectronica@cajaarequipa.pe',
                                  pc_motivo => 'Alerta de envio Factura Electronica',
                                  pc_mensaje => lv_mensaje
                                 );   
  

     End loop;
  
  End loop;  
  
End loop;  
   PC_envio:= pc_receptor;
   --pc_receptor :=pc_receptor;
                            
end;                     
                            
END sp_envio_factura;    

PROCEDURE sp_envio_nota_credito(PC_envio out VARCHAR2) is
 
pn_sucursal number;
pc_serie char(4);
pn_correlativo number(8);
pd_fecha date;
pc_receptor VARCHAR2(70);
pc_correo  VARCHAR2(16):='@cajaarequipa.pe';
pn_dia_atr date;
lv_mensaje VARCHAR2(2000);  
lc_usuario char(20);
ln_perfil number;
SERIE CHAR(4);
CORRE NUMBER;
                   
cursor aqpa466 is 

     select * from aqpa466 a 
         where a.aqpa466est in ('E','R');
         
cursor fst198 is 

    select tp1corr3 
     from fst198 a 
     where a.tp1cod= 1 
     and a.tp1cod1=11120 
     and a.tp1corr1=1
     and a.tp1corr2=700
     and a.tp1corr3 >0;
     
cursor fst046 is 

     select a.ubuser from fst046 a
     inner join sng057 b on trim(a.ubuser)=trim(b.sng057usr)
      where a.ubsuc= pn_sucursal and b.sng055car=ln_perfil;

begin
  begin   
    
  for p in aqpa466 loop   
     pn_sucursal:= p.aqpa466sucor;
     pc_serie := p.aqpa466serie;
     pn_correlativo :=p.aqpa466corr;
     pd_fecha := p.aqpa466fec;    
     SERIE:=P.AQPA466SERIE;
     CORRE:=P.AQPA466CORR;
     
      for b in fst198 loop 
         ln_perfil := b.tp1corr3;

        for a in  fst046 loop 
           lc_usuario := trim(a.ubuser);
               
  --  pc_receptor:=CONCAT(TRIM(LOWER(p.aqpa465usu)),pc_correo);
    pc_receptor:=CONCAT(TRIM(LOWER(lc_usuario)),pc_correo);
 

    pn_dia_atr:= P.AQPA466CON+7;
    
           lv_mensaje:='<html><head>	<style type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style></head><body>         <br>
           <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">Estimado.</p><p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">
           El documento  '||TO_CHAR(p.aqpa466serie)||'-'||TO_CHAR(p.aqpa466corr)|| ' con fecha '||TO_CHAR(p.aqpa466con)||' se encuentra pendiente de mantenimiento.'||
           '</p> <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">La fecha limite de envio a SUNAT es '||TO_CHAR(pn_dia_atr)|| '.'||
           '</p> <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">
           Gracias y Saludos.</p></body></html>';



         sys.sp_sy_enviamail_html(pc_aquien =>pc_receptor,--- sys.sp_sy_enviamail_html_silvia
                                  pc_de => 'FacturacionElectronica@cajaarequipa.pe',
                                  pc_motivo => 'Alerta de envio Factura Electronica',
                                  pc_mensaje => lv_mensaje
                                 );   
  

     End loop;
  
  End loop;  
  
End loop;  
   PC_envio:= pc_receptor;
   --pc_receptor :=pc_receptor;
                            
end;                     
                            
END sp_envio_nota_credito;                                  

end pq_cr_Facturacion_mail;
/

