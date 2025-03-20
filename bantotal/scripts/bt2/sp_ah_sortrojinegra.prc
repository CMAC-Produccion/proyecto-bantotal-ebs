create or replace procedure SP_AH_SORTROJINEGRA(LN_NROSOR in NUMBER) is
  
CURSOR ORIGEN IS 
      select x.jaql489pai, x.jaql489tpo, x.jaql489nro, sum(x.opciones) total_opciones
        from (select jaql489pai, jaql489tpo, jaql489nro, sum(jaql489opt) opciones
                from jaql489
               where jaql489cmp = 1
                 and jaql489est = 'V'
               group by jaql489pai, jaql489tpo, jaql489nro
              union all
              select jaql489pai, jaql489tpo, jaql489nro, sum(jaql489oct) opciones
                from jaql489
               where jaql489cmp = 1
                 and jaql489est = 'V'
                 and jaql489nso = LN_NROSOR--&sorteo
               group by jaql489pai, jaql489tpo, jaql489nro
               ) x
      group by x.jaql489pai, x.jaql489tpo, x.jaql489nro         
       order by x.jaql489pai, x.jaql489tpo, x.jaql489nro;
  cont number:=0;
  dato varchar2(300);
  NroCupon varchar2(10):= null;
  NroCredito varchar2(10) := null;
  ApellidoNom varchar2(110);
  Tdocumento varchar2(20);
  NroDocumento varchar2(12);
  Telefono varchar2(20);
  Agencia varchar2(50);
  Region varchar2(40);
  FechaPago varchar2(10):= null;
  TipoCredito varchar2(10):= null;
  FecSorteo date;
  direccion varchar2(140);
  vcont varchar(10);
  nroopc number;
begin
  dbms_output.put_line(' '||','||'NRO_CUPON'||','||'NRO_CREDITO'||','||'APELLIDOS_Y_NOMBRES'||','||'TIPO_DOC'||','||'NRO_DOC'||','||'TELEFONO'||','||'AGENCIA'||','||'REGION'||','||'FECHA_PAGO'||','||'TIPO_CREDITO'||','||'FECHA_SORTEO'||','||'DIRECCION');

  for reg in Origen loop
    
    select --trim(f2.penom) as nombres,
            trim( replace(f2.penom,',',' ')) as nombres,
            trim(f4.tdnom) tipodoc,
            f2.pendoc NroDoc,
            f5.dotelfp Telef,
            (select trim(scnom) from fst001 where sucurs = z4.z0e478suc) sucursal,
            (select f8.regnom from fst810 f8, fst811 f81 where f8.regcod = f81.regcod and f81.oficod = z4.z0e478suc and f8.regcod < 40) Reg,  
            (select trunc(sysdate) from dual) fechSor,
            trim(s1.sngc13Dir) dir 
     into   ApellidoNom,
            Tdocumento,
            NroDocumento,
            Telefono,
            Agencia,
            Region,
            FecSorteo,            
            direccion      
     from fsd001 f2,
          fst014 f4,
          fsr005 f5,
          z0e478 z4,
          SNGC13 s1
     where f2.pepais = reg.jaql489pai
      and f2.petdoc = reg.jaql489tpo
       and f2.pendoc = reg.jaql489nro
       and f4.tdocum = f2.petdoc
       and f5.pepais(+) = f2.pepais
       and f5.petdoc(+) = f2.petdoc
       and f5.pendoc(+) = f2.pendoc
       and z4.z0e478thp(+) = f2.pepais
       and z4.z0e478tht(+) = f2.petdoc
       and z4.z0e478thd(+) = f2.pendoc
       and s1.sngc13pais = f2.pepais
       and s1.sngc13tdoc = f2.petdoc
       and s1.sngc13ndoc = f2.pendoc
       and rownum = 1;        
       nroopc := reg.total_opciones;
       for contador in 1..nroopc loop
          cont := cont + 1;
          dato := (NroCupon||','||NroCredito||','||ApellidoNom||','||Tdocumento||','||NroDocumento||','||Telefono||','||Agencia||','||Region||','||FechaPago||','||TipoCredito||','||FecSorteo||','||direccion);
          vcont := to_char(cont);        
          dbms_output.put_line(vcont||','||dato);
       End loop;
  End loop;
  
end SP_AH_SORTROJINEGRA;
/

