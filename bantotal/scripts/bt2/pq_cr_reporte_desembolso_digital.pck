create or replace package PQ_CR_REPORTE_DESEMBOLSO_DIGITAL is
/* ************************************************************************************************************
    -- Nombre                     : PQ_CR_REPORTE_DESEMBOLSO_DIGITAL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : ACTIVAS
    -- Descripción                : Reporte de Desembolso Digital
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.10.25
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -- 
    -- Autor de la Modificación   : -- 
    -- Descripción de Modificación: --
 * *************************************************************************************************************/

procedure sp_cr_desembolso_digital (pd_fecini in date, pd_fecfin in date, pc_sucur in integer, pc_ubuser in varchar2);

function fn_obtener_nsucursal(cod in int, sucursal in int)return varchar2;

function fn_obtener_zona(cod in int,sucursal in int)return varchar2;

function fn_obtener_region(cod in int,sucursal in int)return varchar2;

function fn_tipo_solicitud(lv_type_sol in number)return varchar2;
  
end PQ_CR_REPORTE_DESEMBOLSO_DIGITAL;
/

create or replace package body PQ_CR_REPORTE_DESEMBOLSO_DIGITAL is

procedure sp_cr_desembolso_digital (pd_fecini in date, pd_fecfin in date, pc_sucur in integer, pc_ubuser in varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_desembolso_digital
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.10.26
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Prepara la tabla AQPB902 y guarda los datos del reporte  
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecini ( Fecha Inicio consulta )
    --                              pd_fecfin ( Fecha Fin consulta )
    --                              pc_sucur ( Sucursal consultada )
    --                              pc_ubuser ( Usuario que ejecuta )
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
begin
        delete from AQPB902 where trim(AQPB902USUR) = trim(pc_ubuser);
        commit;
                
            begin         
             insert into AQPB902(AQPB902INS,AQPB902SUC,AQPB902SUCU,AQPB902ZONA,AQPB902REGI,
                                AQPB902ANLS,AQPB902MND,AQPB902CTA,AQPB902PAIS,AQPB902TDOC,
                                AQPB902DOC,AQPB902NCLI,AQPB902MONT,AQPB902APRB,AQPB902CANL,
                                AQPB902DESB,AQPB902OPE,AQPB902MOD,AQPB902TOPE,AQPB902TEL,
                                AQPB902SOLI,AQPB902USUR,AQPB902FECR)
                                
             select   a.wfinsprcid, 
                      b.xwfsucursal CodAgencia,
                      pq_cr_reporte_desembolso_digital.fn_obtener_nsucursal(b.xwfempresa,b.xwfsucursal) Agencia,
                      upper(pq_cr_reporte_desembolso_digital.fn_obtener_zona(b.xwfempresa,b.xwfsucursal)) Zona,
                      pq_cr_reporte_desembolso_digital.fn_obtener_region(b.xwfempresa,b.xwfsucursal) aRegion,
                      fn_analista_credito(b.xwfmodulo,b.xwfsucursal,b.xwfmoneda,b.xwfpapel,b.xwfcuenta,b.xwfoperacion,b.xwfsubope,b.xwftipope) Analista,                                          
                      --decode(b.xwfmoneda,0,'S/.','US$') moneda,
                      b.xwfmoneda Moneda,
                      b.xwfcuenta Cuenta,
                      d.pepais Pais,
                      d.petdoc TipoDoc,
                      d.pendoc Documento,
                      trim(d.penom) Cliente,
                      b.xwfmonto1 Monto,
                      --a.wfiteminit FechaApr,
                      to_date(a.wfitemend,'dd/mm/yy') FechaAprob,
                      case when
                      (select (select count(*) from fsh015 a 
                        inner join fsh016 b on 
                              a.pgcod = b.pgcod and a.hcmod = b.hcmod and 
                              a.htran = b.htran and a.hnrel = b.hnrel and 
                              a.hsucor = b.hsucor and a.hfcon = b.hfcon
                        where a.hcmod = 489 and a.htran in (59,360,800,951) and b.hcord = 10
                              and hcta = e.aocta and hoper = e.aooper and b.hmodul = e.aomod and b.hsucur = e.aosuc                                       
                              and b.htoper = e.aotope and b.hmda = e.aomda and b.hpap = e.aopap and a.pgcod = e.pgcod)
                       +              
                       (select count(*) from fsd015 a
                        inner join fsd016 b on 
                              a.pgcod= b.pgcod and a.itmod = b.itmod and 
                              a.ittran = b.ittran and a.itnrel = b.itnrel and
                              a.itsuc= b.itsuc and b.itord = 10
                        where a.itmod = 489 and a.ittran in (59,360,800,951) and a.itcont='S'
                              and ctnro = e.aocta and itoper = e.aooper and b.modulo = e.aomod and itsucd = e.aosuc                                       
                              and b.ittope = e.aotope and b.moneda = e.aomda and b.papel = e.aopap and a.pgcod = e.pgcod) from dual  
                       ) > 0 then 'APP' when e.aofval is not null then 'AGENCIA' else '' end CanalDesembolso,    
                       e.aofval FechaDesembolso,
                       b.xwfoperacion Operacion,
                       b.xwfmodulo Modulo,
                       b.xwftipope TipOpe,
                       fn_cl_telefonos(c.sng001pais,c.sng001tdoc,c.sng001ndoc) Telefonos,
                       pq_cr_reporte_desembolso_digital.fn_tipo_solicitud(c.sng001ori) TipoSolicitud,
                       pc_ubuser Usuario,
                       TRUNC(SYSDATE) FechaConsulta          
             from (select wfinsprcid, wfstscod, wftaskcod, max(wfitemend) as wfitemend from wfwrkitems a                   
                          where wftaskcod = 11 and wfstscod = 'C' 
             group by wfinsprcid, wfstscod, wftaskcod) a
             inner join xwf700 b on b.xwfprcins = a.wfinsprcid
             inner join sng001 c on c.sng001inst = a.wfinsprcid
             inner join fsd001 d on (d.pepais = c.sng001pais and 
                                     d.petdoc = c.sng001tdoc and
                                     d.pendoc = c.sng001ndoc)
             left join fsd010 e on (e.pgcod = b.xwfempresa  and 
                                     e.aomod = b.xwfmodulo   and
                                     e.aosuc = b.xwfsucursal and
                                     e.aomda = b.xwfmoneda   and
                                     e.aopap = b.xwfpapel      and                             
                                     e.aocta = b.xwfcuenta     and
                                     e.aooper = b.xwfoperacion and
                                     e.aosbop = b.xwfsubope    and                             
                                     e.aotope = b.xwftipope)
             where b.xwfsucursal = pc_sucur and b.xwfcar3 = '1'
             and to_date(a.wfitemend,'dd/mm/yy') between to_date(pd_fecini,'dd/mm/yy') and to_date(pd_fecfin,'dd/mm/yy')             
             and b.xwfsubope = 0;
             
            commit;
            end;
end sp_cr_desembolso_digital;


function fn_obtener_nsucursal(cod in int, sucursal in int)
return varchar2 is
         nsucursal varchar2(100) := '';
         begin
         select t1.scnom into nsucursal from
             fst001 t1 
             where t1.pgcod = cod
               and t1.sucurs= sucursal;                          
         return nsucursal;
end fn_obtener_nsucursal;

function fn_obtener_zona(cod in int,sucursal in int)
return varchar2 is
         nzona varchar2(100) := '';
         begin
         select rs.regnom into nzona from 
             fst001 t1    
             inner join fst811 r on r.pgcod = t1.pgcod
                      and r.oficod = (case when t1.sucurs > 900 then 11 else t1.sucurs end)
                      and r.regcod < 100
             inner join fst810 rs on rs.regcod = r.regcod
                      and r.regcod < 100
             where t1.pgcod = cod
               and t1.sucurs= sucursal;
        return nzona;
        commit;
end fn_obtener_zona;

function fn_obtener_region(cod in int,sucursal in int)
return varchar2 is
         nregion varchar2(100) := '';
         begin           
         select a.tp1desc into nregion from fst198 a
           where tp1cod = cod 
             and tp1cod1= 10872 
             and tp1corr1= 11
             and tp1nro2 = 
            (select r.regcod from fst001 t1    
             inner join fst811 r on r.pgcod = t1.pgcod
                      and r.oficod = (case when t1.sucurs > 900 then 11 else t1.sucurs end)
                      and r.regcod < 100
             inner join fst810 rs on rs.regcod = r.regcod
                      and r.regcod < 100
             where t1.pgcod = cod
               and t1.sucurs= sucursal);
        return nregion;
        commit;
end fn_obtener_region;

function fn_tipo_solicitud(lv_type_sol in number) 
return varchar2 is
     ntiposoli varchar2(100) := '';
     begin
       if lv_type_sol = 0 then
         ntiposoli := 'NORMAL';   
       elsif lv_type_sol = 1 then
         ntiposoli := 'CARTA FIANZA'; 
       elsif lv_type_sol = 2 then
         ntiposoli := 'NO HABILITADO';
       elsif lv_type_sol = 3 then
         ntiposoli := 'REFINANCIACION';   
       elsif lv_type_sol = 4 then
         ntiposoli := 'AMPLIACION';   
       elsif lv_type_sol = 7 then
         ntiposoli := 'DESEMBOLSOS PARCIALES';   
       elsif lv_type_sol = 10 then
         ntiposoli := 'CONVENIO';   
       elsif lv_type_sol = 11 then
         ntiposoli := 'LINEA DE CREDITO';   
       elsif lv_type_sol = 12 then
         ntiposoli := 'AMPLIACION LINEAS DE CREDITO';   
       elsif lv_type_sol = 13 then
         ntiposoli := 'REPROGRAMACION CAMBIO FECHA';   
       elsif lv_type_sol = 14 then
         ntiposoli := 'REPROGRAMACION DESASTRE NATURAL';    
       elsif lv_type_sol = 15 then
         ntiposoli := 'AMPLIACION ESPECIAL';   
       elsif lv_type_sol = 16 then
         ntiposoli := 'REPROGRAMACION CAMPAÑA';     
       else
         ntiposoli := 'NORMAL';    
       end if;
       return ntiposoli;
end fn_tipo_solicitud;

end PQ_CR_REPORTE_DESEMBOLSO_DIGITAL;
/

