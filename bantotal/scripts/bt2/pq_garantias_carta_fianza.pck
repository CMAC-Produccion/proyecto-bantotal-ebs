CREATE OR REPLACE PACKAGE pq_garantias_carta_fianza is
  -- *****************************************************************
  -- Nombre                     : pq_garantias_carta_fianza
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020.01.30
  -- Autor de Creación          : JRODRIGUEJ
  -- Uso                        : Procesos para el envío de mails de alerta
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   :  
  -- Descripción de Modificación: 
  -- *****************************************************************
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_PROCESAR_GARANTIAS;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_OBTENER_FORMULARIO( pa_pgcod number,
                                pa_pgmod number,
                                pa_pgsuc number,
                                pa_pgmda number,
                                pa_pgpap number,
                                pa_pgcta number,
                                pa_pgope number,
                                pa_pgsbo number,
                                pa_pgtop number                        
                               ) return number ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end pq_garantias_carta_fianza;
/

CREATE OR REPLACE PACKAGE BODY pq_garantias_carta_fianza is
-- *****************************************************************
  -- Nombre                     : pq_garantias_carta_fianza
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020.01.30
  -- Autor de Creación          : JRODRIGUEJ
  -- Uso                        : Procesos para el envío de mails de alerta
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 05/07/2022
  -- Autor de la Modificación   : Smarquez
  -- Descripción de Modificación: Adicion de Exception ln 134 y  modificacion del return = 0
  -- *****************************************************************
--==================================================================
procedure SP_PROCESAR_GARANTIAS is

pa_form number(10) := 0;
pa_fecha_ven varchar(10);
pa_fecha_sis date;
pa_cantidad number(10) := 0;
asunto varchar(150);
mensaje long := '';
diferencia number :=0;
verificar number :=0;


pa_pgcod number(5) := 1;
pa_tpcod number(5) := 7737;
pa_modulo number(5) := 470;
pa_atributo number(5) := 167;

--Cursor: obtención de datos de garantías
cursor cur_pj_garantia
is

select
       y.pgcod sng122pgc 
       ,y.aomod sng122mod
       ,y.aosuc sng122suc
       ,y.aopap sng122pap
       ,y.aocta sng122cta        
       ,y.aooper sng122oper       
       ,y.aosbop sng122sbop        
       ,y.aotope sng122tope 
       ,concat(concat(to_char(y.aotope),'-'),d.tpdesc) TipoOperacion
       ,s.scnom
       ,y.aomda sng122mda
       ,f.mosign

from
       fst098 d
       ,fst001 s
       ,fst005 f
       ,fsd010 y
where
       d.pgcod = y.pgcod
       and d.tpnro = y.aotope
       and s.pgcod = y.pgcod
       and s.sucurs = y.aosuc
       and f.moneda = y.aomda
       and y.aomod = 70
       and y.aostat <> 99 
       and d.pgcod = 1
       and d.tpcod = 7737
       and d.tpcorr > 0 and d.tpcorr < 100
       ;

       
       
--Cursor: Obtención de lista de correos parametrizadas
cursor cur_pj_correos
is

select 
       concat(trim(t.tpdesc),'@cajaarequipa.pe') tpdesc 
from 
       fst098 t
where 
       t.pgcod = pa_pgcod 
       and t.tpcod = pa_tpcod 
       and t.tpcorr >= 200 
       and t.tpcorr <= 299
       ;
       
begin
  
    --================================================================
    --Fecha del sistema
    select t.pgfape into pa_fecha_sis from Fst017 t where t.pgcod = pa_pgcod;
    --Cantidad de días de vencimiento
    select t.tpnro into pa_cantidad from fst098 t where t.pgcod = pa_pgcod and t.tpcod = pa_tpcod and t.tpcorr = 100;
    
    --================================================================
       mensaje:='<html><head>
      <title>Alerta de Bantotal: </title>
    </head>
    <body>
      <font size = 4 color=darkblue><br><i>
         <b>Alerta de Bantotal:</i></b><hr color=darkblue><br>
         <font color=darkblue size = 4 >
               Estimados usuarios.
               <br><br>
               Estas son las garantías que están por vencer:
               <br><br>
      <font size = 4 color=black>
     <table BORDER= "1" CELLPADDING=2 width="95%" font-size:12px">
     <tr >
      <td  bgcolor="#038ED6" align="center"><b>Cuenta Garantía</b></center></td>
      <td  bgcolor="#038ED6" align="center"><b>Operación Garantía</b></center></td>
      <td  bgcolor="#038ED6" align="center"><b>Tipo de Operación Garantía</i></b></center></td>
      <td  bgcolor="#038ED6" align="center"><b>Moneda Garantía</b></center></td>
      <td  bgcolor="#038ED6" align="center"><b>Sucursal Garantía</b></center></td>
      <td  bgcolor="#038ED6" align="center"><b>Fecha Vencimiento Carta Fianza</b></center></td>
     </tr>';
       --===============================================
       for rec_pj_garantia in cur_pj_garantia loop
           
           pa_form := pq_garantias_carta_fianza.FN_OBTENER_FORMULARIO(
                                           rec_pj_garantia.sng122pgc,
                                           pa_modulo, --Módulo
                                           rec_pj_garantia.sng122suc,
                                           rec_pj_garantia.sng122mda,
                                           rec_pj_garantia.sng122pap,
                                           rec_pj_garantia.sng122cta,
                                           rec_pj_garantia.sng122oper,
                                           rec_pj_garantia.sng122sbop,
                                           rec_pj_garantia.sng122tope);   ----Tipo de Operación
           Begin                                
               select nvl(to_char(t.ppg002dato, 'DD/MM/YYYY'), '01/01/0001')
                 into pa_fecha_ven
                 from PPG002 t
                where t.ppg002cod = rec_pj_garantia.sng122pgc
                  and t.ppg002mod = pa_modulo --Módulo
                  and t.ppg002suc = rec_pj_garantia.sng122suc
                  and t.ppg002mda = rec_pj_garantia.sng122mda
                  and t.ppg002pap = rec_pj_garantia.sng122pap
                  and t.ppg002cta = rec_pj_garantia.sng122cta
                  and t.ppg002ope = rec_pj_garantia.sng122oper
                  and t.ppg002sbo = rec_pj_garantia.sng122sbop
                  and t.ppg002top = rec_pj_garantia.sng122tope
                  and t.ppg002frm = pa_form
                  and t.ppg002cdat = pa_atributo;
           exception ---sma 05072022
             when no_data_found then
               pa_fecha_ven := to_char('01/01/0001');
           end;
           if pa_fecha_ven <> '01/01/0001' then
             
              select round((to_date(pa_fecha_ven,'DD/MM/YYYY'))- pa_fecha_sis,0) into diferencia from dual;
              
              if diferencia >= 0 and diferencia <=  pa_cantidad then
                
                  mensaje := concat( mensaje,'<tr>
                                            <td>');
                  mensaje := concat( mensaje,to_char(rec_pj_garantia.sng122cta));    
                  mensaje := concat( mensaje,'</td>
                                              <td>'); 
                  mensaje := concat( mensaje,to_char(rec_pj_garantia.sng122oper));    
                  mensaje := concat( mensaje,'</td>
                                              <td>'); 
                  mensaje := concat( mensaje,rec_pj_garantia.tipooperacion);    
                  mensaje := concat( mensaje,'</td>
                                              <td>'); 
                  mensaje := concat( mensaje,rec_pj_garantia.mosign);    
                  mensaje := concat( mensaje,'</td>
                                              <td>'); 
                  mensaje := concat( mensaje,rec_pj_garantia.scnom);  
                  mensaje := concat( mensaje,'</td>
                                              <td>');  
                  mensaje := concat( mensaje,pa_fecha_ven);  
                  mensaje := concat( mensaje,'</td>
                                            </tr>');  
                                            
                  verificar := 1;
              
                end if;
           end if;  
       end loop;
       
      mensaje := concat( mensaje,'</table>
                                     </font>
                                         <br><br> 
                                         Saludos Cordiales 
                                         <br>
                                         <b>Administrador Bantotal</b>
                                    </body>
                                    </html>');
                                    
    ---Enviar mail
    if verificar=1 then
      
      asunto:='Alerta De Vencimiento de Garantía de Carta Fianza';
      
      for rec_pj_correos in cur_pj_correos loop
        send_mail(rec_pj_correos.tpdesc,'notificacionesgarantias@cajaarequipa.pe', asunto,mensaje);  -- ennvia al correo de la agencia
      end loop;
     

    end if;
      
    --DBMS_OUTPUT.PUT_LINE(mensaje);    
end;
--==================================================================
function FN_OBTENER_FORMULARIO( pa_pgcod number,
                           pa_pgmod number,
                           pa_pgsuc number,
                           pa_pgmda number,
                           pa_pgpap number,
                           pa_pgcta number,
                           pa_pgope number,
                           pa_pgsbo number,
                           pa_pgtop number                        
                           ) return number IS
                           
pr_form number(10) := 0;

begin
        
        select 
                  ppg000frm 
                   
                   into pr_form
        from 
                   ppg000 p 
        where 
                  p.ppg000pgc = pa_pgcod and 
                  p.ppg000mod = pa_pgmod and 
                  p.ppg000suc = pa_pgsuc and 
                  p.ppg000mda = pa_pgmda and 
                  p.ppg000pap = pa_pgpap and 
                  p.ppg000cta = pa_pgcta and 
                  p.ppg000ope = pa_pgope and     --Nro Operacion 
                  p.ppg000sbo = pa_pgsbo and 
                  p.ppg000top = pa_pgtop and     --Tipo de Operacion
                  p.ppg000tco = 'S'; 
                  
                  
        return pr_form;
        
exception when others then   
  --dbms_output.put_line('ERROR SP_CREAR_GRUPO '||sqlerrm );
  return 0;--'N'; --sma 05/07/2022
     
end;
--==================================================================

end pq_garantias_carta_fianza;
/

