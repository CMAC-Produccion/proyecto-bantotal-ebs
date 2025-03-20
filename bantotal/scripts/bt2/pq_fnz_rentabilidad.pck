create or replace package pq_fnz_rentabilidad is

  procedure sp_actualiza_rubros;
  procedure sp_tasa_producto(pd_fecprc date,
                             pn_tipcam number);

end pq_fnz_rentabilidad;
/

create or replace package body pq_fnz_rentabilidad is

  procedure sp_actualiza_rubros is
  
    cursor cur_conceptos is
    select 
    a.jaqz259ades descripcion,
    a.jaqz259acod codigo    
    from  jaqz259a a 
    where jaqz259aope='-';
  
    d_fecpro date;
  
  begin
  
    execute immediate('truncate table jaqz259d');
    
    d_fecpro := sysdate();
  
    insert into jaqz259d(jaqz259drub,jaqz259dcodc,jaqz259ddes,jaqz259dope,jaqz259dusu,jaqz259dfec)
    (
      select d4.rubro,a.jaqz259acod,d4.pcnomr,jaqz259aope,'BANTOTAL',d_fecpro
      from jaqz259a a
      join fsd014 d4
      on trim(d4.rubro) like trim(a.jaqz259ades)
      where jaqz259aope='+'
    );
    commit;
         
    for i in cur_conceptos loop                
      begin
        delete from jaqz259d d
        where trim(d.jaqz259drub) like trim(i.descripcion)
        and d.jaqz259dcodc = i.codigo;           
      end;
    end loop;
    commit;
    
  end;

  procedure sp_tasa_producto(pd_fecprc date,
                             pn_tipcam number) is
  
    c_period varchar2(6);
  
  begin
  
    c_period := to_char(pd_fecprc,'MM') || to_char(pd_fecprc,'YYYY');

    insert into JAQZ259
    select 
      fecha,
      concepto,
      sucursal,
      (case when sum(SalMN) <> 0 then sum(SalTas)/sum(SalMN) else 0 end) as tasa,
      c_period periodo,
      'G0053' grupo,
      'BANTOTAL' usuario,
      sysdate,
      0   
    from
    (
      select 
      h012.bcfech fecha,
      h012.bcsuc sucursal,
      case when h012.bcgpo = 2 then 'C00457'   
           when h012.bcgpo = 3 and substr(h012.bcrubr,11,3)='015' then 'C00452' 
           when h012.bcgpo = 3 and substr(h012.bcrubr,11,3)<>'015' then 'C00451'  
           when h012.bcgpo = 4 then 'C00455'
           when h012.bcgpo = 12 then 'C00456'
           when h012.bcgpo = 13 then 'C00458'  
           else 'C00453'
      end concepto,
      decode(h012.bcmda,0,h012.bcsdmo,h012.bcsdmo*pn_tipcam) SalMN,
      (decode(h012.bcmda,0,h012.bcsdmo,h012.bcsdmo*pn_tipcam) * decode(h012.bctasa,0,fn_tasa_opeact(h012.bcemp,h012.bcmod,h012.bcsuc,h012.bcmda,
                                                                                              h012.bcpap,h012.bccta,h012.bcoper,h012.bcsbop,
                                                                                              h012.bctop),h012.bctasa)) SalTas
      from fsh012 h012
      where h012.bcfech = pd_fecprc
      and substr(h012.bcrubr,1,4) in (1411,1415,1414,1421,1425,1424,1416,1426) 
      and h012.bccta <> 999999999 
      and h012.bcprod <> 99
      and h012.bcmod not in (33,141)
    )  
    group by fecha, sucursal, concepto;  
    
    insert into JAQZ259
    select 
      fecha,
      concepto,
      1000 sucursal,
      (case when sum(SalMN) <> 0 then sum(SalTas)/sum(SalMN) else 0 end) as tasa,
      c_period periodo,
      'G0053' grupo,
      'BANTOTAL' usuario,
      sysdate,
      0   
    from
    (
      select 
      h012.bcfech fecha,
      case when h012.bcgpo = 2 then 'C00457'   
           when h012.bcgpo = 3 and substr(h012.bcrubr,11,3)='015' then 'C00452' 
           when h012.bcgpo = 3 and substr(h012.bcrubr,11,3)<>'015' then 'C00451'  
           when h012.bcgpo = 4 then 'C00455'
           when h012.bcgpo = 12 then 'C00456'
           when h012.bcgpo = 13 then 'C00458'  
           else 'C00453'
      end concepto,
      decode(h012.bcmda,0,h012.bcsdmo,h012.bcsdmo*pn_tipcam) SalMN,
      (decode(h012.bcmda,0,h012.bcsdmo,h012.bcsdmo*pn_tipcam) * decode(h012.bctasa,0,fn_tasa_opeact(h012.bcemp,h012.bcmod,h012.bcsuc,h012.bcmda,
                                                                                              h012.bcpap,h012.bccta,h012.bcoper,h012.bcsbop,
                                                                                              h012.bctop),h012.bctasa)) SalTas
      from fsh012 h012
      where h012.bcfech = pd_fecprc
      and substr(h012.bcrubr,1,4) in (1411,1415,1414,1421,1425,1424,1416,1426) 
      and h012.bccta <> 999999999 
      and h012.bcprod <> 99
      and h012.bcmod not in (33,141)
    )  
    group by fecha, concepto;    
        
    commit;
  
  end;
  
end pq_fnz_rentabilidad;
/

