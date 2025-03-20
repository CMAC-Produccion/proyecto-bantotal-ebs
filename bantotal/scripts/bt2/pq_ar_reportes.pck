create or replace package pq_ar_reportes is

  -- Sistema : BANTOTAL 
  -- Modulo : Reportes
  -- Version : 1.0
  -- Author  : FRANK PINTO
  -- Created : 03/03/2020
  -- Purpose : Paquete que obtiene datos para reportes
  -- Estado : Diseño
  -- Autor Modificacion:   Frank Pinto
  -- Fecha Modificacion:  17/10/2022
  -- Descripcion Modificacion: Se cambia varible para obtener codigo de sucursal de TDV
  procedure sp_reporte_actdv(p_d_FecDia date);

end pq_ar_reportes;
/

create or replace package body pq_ar_reportes is

  procedure sp_reporte_actdv(p_d_FecDia date) is
    ldfecha date;
  
  begin
    --SI NO SE INGRESA FECHA TOMA EL VALOR DE LA TABLA FST017       
    if p_d_FecDia is null then
      select pgfape into ldfecha from fst017 where pgcod = 1;
    else
      ldfecha := p_d_FecDia;
    end if;
  
    delete from aqpb101 where aqpb101Fecdi = ldfecha;
    commit;
  
    insert into aqpb101 --datos de la tabla AQPB101 
      (aqpb101corr,
       aqpb101fecdi,
       aqpb101numtar,
       aqpb101agen,
       aqpb101codpa,
       aqpb101tipdoc,
       aqpb101nrodoc,
       aqpb101op1res,
       aqpb101op2asi,
       aqpb101op3act,
       aqpb101feuatm,
       aqpb101feucor,
       aqpb101feucam,
       aqpb101feukas,
       aqpb101feuven,
       aqpb101actasi,
       aqpb101ctainc)
    
    --SELECCIONA DATOS DE TABLAS PRINCIPALES Z0E478, FSR008 Y TDW041
      select /*+ all_rows */
       rownum,
       ldfecha,
       Trim(z.z0e478nro),
       trim(f.scnom),
       z.z0e478thp,
       z.z0e478tht,
       trim(z.z0e478thd),
       trim(a.aqpb101bpro),
       trim(z.z0e478umd),
       trim(z.z0e478uau),
       --INICIA UNA CONSULTA CASE PARA OBTENER MAYOR FECHA ENTRE ULTIMAS OPERACIONES
       
       (select to_date(replace(to_char(nvl(max(z2.z0e478fuu), to_date('01/01/1901','dd-mm-yyyy')),'dd-mm-yyyy'),'0001','1901'),'dd-mm-yyyy') 
             from z0e478 z2 
             where z2.z0e478fvt<SYSDATE 
             and z2.z0e478thd=z.z0e478thd) atm, --FECHA DE ATM
       (select to_date(replace(to_char(nvl(max(j2.jaql6fetra), to_date('01/01/1901','dd-mm-yyyy')),'dd-mm-yyyy'),'0001','1901'),'dd-mm-yyyy')
             from jaql006 j2 , z0e478 z2
             where j2.jaql6fetra>=z2.z0e478fuu
             and z2.z0e478thd=z.z0e478thd 
             and z2.z0e478fvt<SYSDATE 
             and j2.jaql3cored=2 
             and j2.jaql9nuele=508 
             and z2.z0e478nro=j2.jaql6nutar) corresp, --FECHA DE CORRESPONSAL
       nvl((select to_date(replace(to_char(max(j3.jaqz205feult), 'dd-mm-yyyy'), '0001', '1901'), 'dd-mm-yyyy')
             from jaqz205 j3, z0e478 z2
             where z2.z0e478fvt < SYSDATE
             and z2.z0e478nro = j3.jaqz205nutar
             and z2.z0e478thd = z.z0e478thd),to_date('01/01/1901', 'dd-mm-yyyy')) cajamovil, --FECHA DE CAJAMOVIL
       (select to_date(replace(to_char(nvl(max(j2.jaql6fetra), to_date('01/01/1901','dd-mm-yyyy')),'dd-mm-yyyy'),'0001','1901'),'dd-mm-yyyy')
             from jaql006 j2 , z0e478 z2
             where j2.jaql6fetra>=z2.z0e478fuu
             and z2.z0e478thd=z.z0e478thd 
             and z2.z0e478fvt<SYSDATE 
             and j2.jaql3cored=2 
             and j2.jaql9nuele=508 
             and z2.z0e478nro=j2.jaql6nutar) kasnet, --FECHA DE KASNET
       (select to_date(replace(to_char(nvl(max(z2.z0e478fuu), to_date('01/01/1901','dd-mm-yyyy')),'dd-mm-yyyy'),'0001','1901'),'dd-mm-yyyy') 
             from z0e478 z2 
             where z2.z0e478fvt<SYSDATE 
             and z2.z0e478thd=z.z0e478thd) vent, --FECHA DE VENTANILLA 
       (select distinct --INICIA CONSULTA PARA OBTENER SI TDV SE ACTIVO EN EL MISMO DIA DE ASIGNACION
                        case
                          when max(f6.cbiefec) = max(z5.z0e478fmd) then
                           'si'
                          when max(f6.cbiefec) <> max(z5.z0e478fmd) then
                           'no'
                          when max(f6.cbiefec) is null then
                           'no'
                        end
          from z0e478 z5
         inner join fsr008 f2
            on f2.pendoc = z5.z0e478thd
           and f2.pepais = z5.z0e478thp
           and f2.petdoc = z5.z0e478tht
         inner join fsd450 f6
            on f6.cbiecta = f2.ctnro
           and f6.hcmod = 499
           and f6.hsucor = 11
           and f6.htran = 1
           and f6.hcord = 1
           and f6.hcsubo = 1
           and f6.excod = 0
         where f6.pgcod = 1
           and f6.cbieant = 81
           and z5.z0e478nro = z.z0e478nro) activo,
       (select count(f2.ctnro)
          from fsr008 f2 --CONSULTA CTA INACTIVAS DEL CLIENTE
         inner join fsd011 f
            on f.sccta = f2.ctnro
           and f.pgcod = 1
         where f.scstat = '81'
           and f.scmod = 21
           and f2.pendoc = z.z0e478thd) CTAINAC
        from z0e478 z
       /*inner join fst046 p
          on p.ubuser = z.z0e478umd*/  --fpinto 17/10/2022 se comenta ingreso a esta tabla
       inner join fst001 f
          on f.sucurs = z.z0e478pls --fpinto 17/10/2020 se cambia variable de sucursal
        left outer join aqpb101b a
          on a.aqpb101btar = z.z0e478nro
       where z.z0e478fal = ldfecha;
  
    commit;
  
  end sp_reporte_actdv;

end pq_ar_reportes;
/

