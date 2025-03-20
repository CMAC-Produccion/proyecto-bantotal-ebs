create or replace package pq_cn_visanet is

  -- Author  : HLAQUI
  -- Created : 27/06/2018
  -- Purpose : Paquete que obtiene reporte Compras VISANET
  -- Autor Modificacion:   
  -- Fecha Modificacion: 
  -- Descripcion Modificacion: 
 
  procedure sp_reporte_compras(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_error out varchar2);
end pq_cn_visanet;
/

create or replace package body pq_cn_visanet is


procedure sp_reporte_compras(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_error out varchar2) is
  begin         
      delete from jaqz333 where jaqz333CodUsu = upper(p_c_Codusu);
      commit;
      insert into  jaqz333 --Reporte de Compras Visanet      
      (jaqz333codusu, jaqz333Corr,  jaqz333fecini, jaqz333fecfin, jaqz333periodo, 
       jaqz333tipdoc, jaqz333numdoc, jaqz333nomcli, 
       jaqz333dircli, jaqz333telcli, jaqz333corcli, jaqz333nomcor, jaqz333moneda, 
       jaqz333monto,  jaqz333feccom, jaqz333horcom )
       
      select   /*+all_rows*/
        upper(p_c_Codusu), rownum, p_d_FecIni, p_d_FecFin, trim(to_char(jaql540feini, 'Month')) ||'-'||trim(to_char(jaql540feini, 'YYYY')),
        tdnom, z0e478thd, trim(z0e478nom),
        trim(sngc13dir), dotelfp, replace(trim(lower(pextxt)), '\',''),
        g.jaql539valtr, case when h.jaql539valtr='604' then 'SOL' else 'DOLAR AMERICADO' end , 
        trim(to_char(to_number(i.jaql539valtr)/100.00, '99999990.99')), jaql540feini, jaql540hoini
                
      from jaql540 a
      inner join z0e478 b on b.z0e478nro = rpad(trim(a.jaql540nutar),19,' ')  
      left outer join sngc13 c on c.sngc13pais = b.z0e478thp and c.sngc13tdoc = b.z0e478tht 
           and c.sngc13ndoc = b.z0e478thd and c.docod = 1 and c.sngc13est = 'H'
      left outer join sngc17 d  on d.sngc17pais = b.Z0E478THP
           and d.sngc17Ndoc = b.Z0E478THD and d.sngc17tdoc = b.Z0E478THT
           and d.sngc16TTel = 1 and d.sngc17dcod=1 and d.sngc17corr=1
      left outer join fsr005 e on e.pepais = d.sngc17pais
           and e.petdoc = d.sngc17tdoc and e.pendoc = d.sngc17ndoc
           and e.docod  = d.sngc17dcod and e.doordp = d.sngc17corr                               
      left outer join fsx001 e on e.pepais = b.z0e478thp and e.petdoc = b.z0e478tht 
           and e.pendoc = b.z0e478thd and e.txcod  = 0 and e.pexren = 1     
      left outer join fst014 f on tdocum = b.z0e478tht
      left outer join jaql539 g on g.jaql539cotra = a.jaql540cotra and g.jaql539nucam=43
      left outer join jaql539 h on h.jaql539cotra = a.jaql540cotra and h.jaql539nucam=49
      left outer join jaql539 i on i.jaql539cotra = a.jaql540cotra and i.jaql539nucam=4 
      where (jaql540cotrx = '000000')
         and (jaql540comsj = 200)
         and (jaql540cores = '00')
         and (jaql540feini >= p_d_FecIni)
         and (jaql540feini <= p_d_FecFin)
      order by jaql540cotra ;        
      commit;
  EXCEPTION
    WHEN OTHERS THEN
      p_c_error := sqlerrm;
end sp_reporte_compras;
end pq_cn_visanet;
/

