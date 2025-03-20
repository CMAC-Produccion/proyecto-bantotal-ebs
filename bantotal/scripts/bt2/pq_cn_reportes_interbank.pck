create or replace package pq_cn_reportes_interbank is

  -- Author  : HLAQUI
  -- Created : 30/12/2019
  -- Purpose : Paquete que obtiene reportes para canales
  -- Autor Modificacion:   FPINTO
  -- Fecha Modificacion:   12/03/2021
  -- Descripcion Modificacion: Se aumenta las tranasacciones denegadas para reporte.
  procedure sp_reporte_interbank(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_TipRep varchar2, p_c_error out varchar2);  
end pq_cn_reportes_interbank;
/

create or replace package body pq_cn_reportes_interbank is

procedure sp_reporte_interbank(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_TipRep varchar2,p_c_error out varchar2) is
  begin         
            
      If p_c_TipRep = '1' then --1 resumen
          delete from aqpa707a where aqpa707aCodUsu = upper(p_c_Codusu);
          commit;
          insert into aqpa707a --Reporte de Límites
          (aqpa707acodusu, aqpa707acorr, aqpa707afecini, aqpa707afecfin, aqpa707afecreg, 
           aqpa707atipope, aqpa707aauxc1, aqpa707atotal  , aqpa707aimpope, aqpa707aauxn2        
          )        
          --select * from aqpa707a             
          
          select upper(p_c_Codusu), rownum,  p_d_FecIni, p_d_FecFin, Fecha, 
          case when jaql540cotrx = '011100' then 'Retiro Ahorros'
               when jaql540cotrx = '011200' then 'Retiro CTS'
               when jaql540cotrx = '311100' then 'Consulta Saldos Ahorros'
               when jaql540cotrx = '311200' then 'Consulta Saldos CTS'
               when jaql540cotrx = '391100' then 'Consulta Movimientos Ahorros'  
               when jaql540cotrx = '391200' then 'Consulta Movimientos CTS'    
               when jaql540cotrx = '920000' then 'Cambio de Clave'        
               else 'No Identificado'
           end tipope,
          case when jaql540cores <> '00' then 'Denegadas' 
               else 'Aprobado'
          end Estado,                
          cantidad, 
          monto, moneda from (          
          select p_d_FecIni, p_d_FecFin, jaql540feini Fecha, 
          jaql540cotrx, count(1) Cantidad, sum(to_number(d.jaql539valtr,'999999999999')/100) monto, 
          case when trim(c.jaql539valtr) = '604' then 0 else 101 end moneda, jaql540cores
          from jaql540 a
          inner join jaql539 b on a.jaql540cotra = b.jaql539cotra and b.jaql539nucam = 32 and jaql539valtr='06890606'
          inner join jaql539 c on a.jaql540cotra = c.jaql539cotra and c.jaql539nucam = 49
          inner join jaql539 d on a.jaql540cotra = d.jaql539cotra and d.jaql539nucam = 4
          Where jaql540feini between p_d_FecIni and p_d_FecFin 
          group by jaql540feini, jaql540cotrx, c.jaql539valtr,jaql540cores
          order by jaql540feini, jaql540cotrx, c.jaql539valtr, jaql540cores)
              
          commit;
      end if;
      If p_c_TipRep = '2' then --2 Detallado        
          delete from aqpa707a where aqpa707aCodUsu = upper(p_c_Codusu);
          commit;
          insert into aqpa707a --Reporte de Límites
          (aqpa707acodusu, aqpa707acorr, aqpa707afecini, aqpa707afecfin, aqpa707afecreg, aqpa707ahorreg, 
          aqpa707anumope, aqpa707atipope, aqpa707anumtar, aqpa707anumcta, aqpa707aimpope, aqpa707amodulo, 
          aqpa707atransa, aqpa707arelaci, aqpa707asucurs, AQPA707AAUXC1, AQPA707AAUXC2,  aqpa707aauxn2 
          )
          select upper(p_c_Codusu), rownum, p_d_FecIni, p_d_FecFin, x.fecha, x.hora, x.numope, 
                 x.tipope, x.tarjeta, x.cuenta, x.importe, x.modulo, x.transaccion, x.relacion, x.sucursal,
                 x.terminal, x.documento, x.moneda
          from                     
          (                    
            select jaql540feini fecha, jaql540hoini hora, 
            jaql540nutra numope,           
            case when jaql540cotrx = '011100' then 'Retiro Ahorros'
                 when jaql540cotrx = '011200' then 'Retiro CTS'
                 when jaql540cotrx = '311100' then 'Consulta Saldos Ahorros'
                 when jaql540cotrx = '311200' then 'Consulta Saldos CTS'
                 when jaql540cotrx = '391100' then 'Consulta Movimientos Ahorros'  
                 when jaql540cotrx = '391200' then 'Consulta Movimientos CTS'    
                 when jaql540cotrx = '920000' then 'Cambio de Clave'     
                 else 'No Identificado'
             end tipope,           
            substr(jaql540nutar,1,6) || '******' || substr(jaql540nutar,13,4) tarjeta,           
            lpad(e.z0e479cta,9,'0') || lpad(e.z0e479mod,3,'0') || lpad(e.z0e479mon,3,'0') || lpad(e.z0e479sct,2,'0') || lpad(e.z0e479top,3,'0') Cuenta,
            to_number(d.jaql539valtr)/100 importe, a.jaql540modul Modulo, 
            a.jaql540trans transaccion, a.jaql540relac Relacion , a.jaql540auxn1 Sucursal,
            a.jaql540coter terminal, g.z0e478thd documento,
            case when trim(f.jaql539valtr) = '604' then 0 else 101 end moneda            
            from jaql540 a
            inner join jaql539 b on a.jaql540cotra = b.jaql539cotra and b.jaql539nucam = 32 and jaql539valtr='06890606'
            inner join jaql539 c on a.jaql540cotra = c.jaql539cotra and c.jaql539nucam = 102
            inner join jaql539 d on a.jaql540cotra = d.jaql539cotra and d.jaql539nucam = 4
            inner join z0e479 e on trim(e.z0e478nro) = trim(a.jaql540nutar) 
            and lpad(substr(to_char(e.z0e479cta),-6),6,'0')  = substr(c.jaql539valtr,3,6)
            and e.z0e479sct = to_number(substr(c.jaql539valtr,15,2))
            inner join jaql539 f on a.jaql540cotra = f.jaql539cotra and f.jaql539nucam = 49          
            inner join z0e478  g on trim(g.z0e478nro) = trim(a.jaql540nutar) 
            Where jaql540feini between p_d_FecIni and p_d_FecFin and jaql540cores='00'
            Order by jaql540feini, jaql540hoini desc                    
          ) x                     
          ;    
          commit;
      end if;
      If p_c_TipRep = '3' then --3 Diferencias
          delete from aqpa707a where aqpa707aCodUsu = upper(p_c_Codusu);
          commit;
          insert into aqpa707a --Reporte de Límites
          (aqpa707acodusu, aqpa707acorr, aqpa707afecini, aqpa707afecfin, aqpa707afecreg, aqpa707ahorreg, 
          aqpa707anumope, aqpa707atipope, aqpa707anumtar, aqpa707aimpope, aqpa707aflag, AQPA707AAUXC2,
          aqpa707amodulo, aqpa707atransa, aqpa707arelaci, aqpa707asucurs
          )  
      
         select upper(p_c_Codusu), rownum, p_d_FecIni, p_d_FecFin, x.fecha, x.hora, x.numope, x.tipope,
          x.tarjeta, x.importe, x.flag, x.documento, x.modulo, x.transaccion, x.relacion, x.sucursal from
          (                                      
            select jaql540feini fecha , jaql540hoini hora, jaql540nutra numope,           
            case when jaql540cotrx = '011100' then 'Retiro Ahorros'
                 when jaql540cotrx = '011200' then 'Retiro CTS'
                 when jaql540cotrx = '311100' then 'Consulta Saldos Ahorros'
                 when jaql540cotrx = '311200' then 'Consulta Saldos CTS'
                 when jaql540cotrx = '391100' then 'Consulta Movimientos Ahorros'  
                 when jaql540cotrx = '391200' then 'Consulta Movimientos CTS'    
                 when jaql540cotrx = '920000' then 'Cambio de Clave'     
                 else 'No Identificado'
             end tipope, 
            substr(jaql540nutar,1,6) || '******' || substr(jaql540nutar,13,4) tarjeta,
            to_number(d.jaql539valtr)/100 importe, 
            case when c.jaql638fepro is null then 'N' else 'S' end flag, 
            g.z0e478thd documento,
            a.jaql540modul Modulo, a.jaql540trans transaccion, a.jaql540relac Relacion , a.jaql540auxn1 Sucursal
            from jaql540 a
            inner join jaql539 b on a.jaql540cotra = b.jaql539cotra and b.jaql539nucam = 32 and b.jaql539valtr='06890606'
            inner join jaql539 d on a.jaql540cotra = d.jaql539cotra and d.jaql539nucam = 4      
            inner join jaql539 e on a.jaql540cotra = e.jaql539cotra and e.jaql539nucam = 17 --Fecha de Interbank
            left outer join jaql638 c 
                  on trim(c.jaql638cmp07)  = trim(a.jaql540nutar)
                  and substr(trim(c.jaql638cmp18),3,4) /*MMDD*/ = trim(e.jaql539valtr) /*MMDD*/
                  and trim(c.jaql638cmp04) = trim(a.jaql540coter)
                  and trim((               (case when substr(c.jaql638cmp28,1,2)='10' then '01'
                                                 when substr(c.jaql638cmp28,1,2)='30' then '31'
                                                   else '94' end )    || c.jaql638cmp29 || c.jaql638cmp30)) = trim(a.jaql540cotrx) 
                  and trim(c.jaql638cmp23) = lpad(trim(a.jaql540nutra),12,'0')
                  and jaql638cmp07 is not null
                  and trim(jaql638cmp41) = '00'
            inner join z0e478  g on trim(g.z0e478nro) = trim(a.jaql540nutar) 
            Where jaql540feini between p_d_FecIni and p_d_FecFin and jaql540cores='00'
            Order by jaql540feini, jaql540hoini desc          
          
          ) x;
          
          commit;
      end if;        
      
  EXCEPTION
    WHEN OTHERS THEN
      p_c_error := sqlerrm;
end sp_reporte_interbank;

end pq_cn_reportes_interbank;
/

