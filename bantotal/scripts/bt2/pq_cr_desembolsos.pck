create or replace package PQ_CR_DESEMBOLSOS is
-- *****************************************************************
-- Nombre                     : PAQUETES PARA GENERAR REPORTES
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 2015.03.23
-- Autor de Creación          : ABERNEDO
-- Uso                        : Genera Reportes
-- Estado                     : Activo
-- Acceso                     : Público
-- *****************************************************************
  Procedure SP_CR_DESEMBOLSO (PD_FECINI IN DATE, PS_FECFIN IN DATE, pc_ubuser in varchar2);
  Procedure SP_CR_EVALUACION (PD_FECINI IN DATE, PS_FECFIN IN DATE, pc_ubuser in varchar2) ;
  Procedure SP_CR_SOLICITUD (PD_FECINI IN DATE, PS_FECFIN IN DATE, pc_ubuser in varchar2);

end PQ_CR_DESEMBOLSOS;
/

create or replace package body PQ_CR_DESEMBOLSOS is
Procedure SP_CR_DESEMBOLSO (PD_FECINI IN DATE, PS_FECFIN IN DATE, pc_ubuser in varchar2) 
-- *****************************************************************
-- Nombre                     : SP_CR_DESEMBOLSO
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 
-- Autor de Creación          : ABERNEDO
-- Uso                        : Genera reporte desembolsos
-- Estado                     : Activo
-- Acceso                     : Público
-- Parámetros de Entrada      : PD_FECINI, PS_FECFIN, pc_ubuser
-- Retorno                    : 
-- Fecha de Modificación      : 15/11/2023
-- Autor de la Modificación   : MILTON CORDOVA
-- Descripción de Modificación: Se modifica filtro (TRIM)
-- *****************************************************************
  IS
BEGIN
        delete from aqpc224 where AQPC224USU = rpad(pc_ubuser, 10, ' ');
        delete from JAQZ054 where JAQZ054USR = rpad(pc_ubuser, 10, ' ');
        COMMIT;
           
        begin
        
        insert into JAQZ054(JAQZ054INS,JAQZ054USC,JAQZ054FDI,JAQZ054EST,JAQZ054CRE,
                            JAQZ054REG,JAQZ054CSU,JAQZ054SUC,JAQZ054ANA,JAQZ054MOD,
                            JAQZ054MDA,JAQZ054CTA,JAQZ054OPE,JAQZ054SBO,JAQZ054TOP,
                            JAQZ054MTO,JAQZ054PAI,JAQZ054TDC,JAQZ054NDC,JAQZ054NOM,
                            JAQZ054TEL,JAQZ054TSO,JAQZ054USR,JAQZ054ZON)
        
        select a.wfinsprcid, 
               a.wfitemusrcod asignado,
               a.wfiteminit ingdes,
               a.wfstscod||'-'||trim(s.wfstsdsc) estado,
               c.regcod,
               c.regnom region,
               r.sucurs,
               r.scnom sucursal,
               f.sng001ase analista,
               b.xwfmodulo modulo,
               decode(b.xwfmoneda,0,'S/.','US$') moneda,
               b.xwfcuenta cuenta,
               b.xwfoperacion operacion,
               b.xwfsubope SubOpe,
               b.xwftipope TipOpe,
               f.sng017mto monto,
               f.sng001pais,
               f.sng001tdoc,
               f.sng001ndoc Numdoc,
               d1.penom Cliente,
               fn_cl_telefonos(f.sng001pais,f.sng001tdoc,f.sng001ndoc) Telefonos,
               case when f.sng001ori = 0 then 'NORMAL'         
                    when f.sng001ori = 1 then 'CARTA FIANZA'
                    when f.sng001ori = 2 then 'NO HABILITADO'
                    when f.sng001ori = 3 then 'REFINANCIACION'
                    when f.sng001ori = 4 then 'AMPLIACION'
                    when f.sng001ori = 7 then 'DESEMBOLSOS PARCIALES'
                    when f.sng001ori = 10 then 'CONVENIO'
                    when f.sng001ori = 11 then 'LINEA DE CREDITO'
                    when f.sng001ori = 12 then 'AMPLIACION LINEAS DE CREDITO'
                    when f.sng001ori = 13 then 'REPROGRAMACION CAMBIO FECHA'              
                    when f.sng001ori = 14 then 'REPROGRAMACION DESASTRE NATURAL'    
                    when f.sng001ori = 15 then 'AMPLIACION ESPECIAL'    
                    when f.sng001ori = 16 then 'REPROGRAMACION CAMPAÑA'    
                    else 'NORMAL'                                                                                                  
               end "TIPO SOLICITUD",
               pc_ubuser,
               (select tp1nro1
                  from fst198 a
                 where tp1cod = 1 
                   and tp1cod1= 10872 
                   and tp1corr1= 11
                   and tp1nro2 = c.regcod)
          from wfwrkitems a, 
               xwf700 b, 
               fst810 c,
               fst811 cc,
               fst001 r, 
               sng001 f, 
               fsd001 d1,
               WFState1 s 
        where a.wfinsprcid=b.xwfprcins
          and b.xwfsucursal=cc.oficod
          and cc.regcod<100
          AND C.REGCOD <100
          and c.regcod = cc.regcod
          and b.xwfsucursal = r.sucurs
          --and a.wftaskcod=55 and a.wfstscod not in ('C','D')
          and a.wftaskcod=55 and a.WFITEMSTSACT = 1
          and a.wfitemid = (select max(m.wfitemid)
                               from wfwrkitems m 
                              where m.wfinsprcid = a.wfinsprcid
                            )
          and to_date(a.wfiteminit,'dd/mm/yy') between to_date(PD_FECINI,'dd/mm/yy')
          and to_date(PS_FECFIN,'dd/mm/yy')
          and f.sng001inst=a.wfinsprcid
          and b.xwfcar3='1'
          and d1.pepais = f.sng001pais
          and d1.petdoc = f.sng001tdoc
          and d1.pendoc = f.sng001ndoc
          and s.wfstscod = a.wfstscod
          and s.wflngid = 'spa';        
        commit;       
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
            END;
END SP_CR_DESEMBOLSO;

Procedure SP_CR_EVALUACION (PD_FECINI IN DATE, PS_FECFIN IN DATE, pc_ubuser in varchar2)
-- *****************************************************************
-- Nombre                     : SP_CR_EVALUACION
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 
-- Autor de Creación          : ABERNEDO
-- Uso                        : Genera reporte desembolsos
-- Estado                     : Activo
-- Acceso                     : Público
-- Parámetros de Entrada      : PD_FECINI, PS_FECFIN, pc_ubuser
-- Retorno                    : 
-- Fecha de Modificación      : 28/11/2023
-- Autor de la Modificación   : MILTON CORDOVA
-- Descripción de Modificación: Se modifica filtro
-- *****************************************************************  
 IS

BEGIN
        delete from aqpc224 where AQPC224USU = rpad(pc_ubuser, 10, ' ');
        delete from JAQZ055 where JAQZ055USR = rpad(pc_ubuser, 10, ' ');
        COMMIT;

        begin
        
        insert into JAQZ055(JAQZ055INS,JAQZ055USC,JAQZ055FDI,JAQZ055EST,JAQZ055CRE,
                            JAQZ055REG,JAQZ055CSU,JAQZ055SUC,JAQZ055ANA,JAQZ055MOD,
                            JAQZ055MDA,JAQZ055CTA,JAQZ055OPE,JAQZ055SBO,JAQZ055TOP,
                            JAQZ055MTO,JAQZ055PAI,JAQZ055TDC,JAQZ055NDC,JAQZ055NOM,
                            JAQZ055TEL,JAQZ055TSO,JAQZ055USR,JAQZ055ZON)
        
        select a.wfinsprcid, 
               trim(a.wfitemusrcod)||'-'||trim(initcap(u.ubnom)) asignado,    
               a.wfiteminit ingdes,
               a.wfstscod||'-'||trim(s.wfstsdsc) estado,
               c.regcod,
               c.regnom region,
               r.sucurs,
               R.scnom sucursal,
               f.sng001ase analista,
               b.xwfmodulo modulo,
               decode(b.xwfmoneda,0,'S/.','US$') moneda,
               b.xwfcuenta cuenta,
               b.xwfoperacion operacion,
               b.xwfsubope SubOpe,
               b.xwftipope TipOpe,
               f.sng017mto monto,
               trim(f.sng001pais),
               trim(f.sng001tdoc),
               trim(f.sng001ndoc) Numdoc,
               trim(d1.penom) Cliente,
               fn_cl_telefonos(f.sng001pais,f.sng001tdoc,f.sng001ndoc) Telefonos,
               case when f.sng001ori = 0 then 'NORMAL'         
                    when f.sng001ori = 1 then 'CARTA FIANZA'
                    when f.sng001ori = 2 then 'NO HABILITADO'
                    when f.sng001ori = 3 then 'REFINANCIACION'
                    when f.sng001ori = 4 then 'AMPLIACION'
                    when f.sng001ori = 7 then 'DESEMBOLSOS PARCIALES'
                    when f.sng001ori = 10 then 'CONVENIO'
                    when f.sng001ori = 11 then 'LINEA DE CREDITO'
                    when f.sng001ori = 12 then 'AMPLIACION LINEAS DE CREDITO'
                    when f.sng001ori = 13 then 'REPROGRAMACION CAMBIO FECHA'              
                    when f.sng001ori = 14 then 'REPROGRAMACION DESASTRE NATURAL'    
                    when f.sng001ori = 15 then 'AMPLIACION ESPECIAL'    
                    when f.sng001ori = 16 then 'REPROGRAMACION CAMPAÑA'    
                    else 'NORMAL'                                                                                                  
               end "TIPO SOLICITUD",
               pc_ubuser,
               (select tp1nro1
                  from fst198 a
                 where tp1cod = 1 
                   and tp1cod1= 10872 
                   and tp1corr1= 11
                   and tp1nro2 =c.regcod)
          from wfwrkitems a, 
               xwf700 b, 
               FST810 c, 
               fst811 cc,
               sng001 f,
               fst001 r, 
               fsd001 d1,
               WFState1 s,
               fst746 u 
        where a.wfinsprcid=b.xwfprcins
            and b.xwfsucursal=cc.oficod
            and c.regcod = cc.regcod
            and cc.regcod < 100
            and c.regcod < 100
            and r.sucurs = b.xwfsucursal
            and a.wftaskcod=11 and a.wfstscod not in ('C','D')
            and a.wfitemid = (select max(m.wfitemid)
                                 from wfwrkitems m 
                                where m.wfinsprcid = a.wfinsprcid
                              )
            and to_date(a.wfiteminit,'dd/mm/yy') between to_date(PD_FECINI,'dd/mm/yy')
            and to_date(PS_FECFIN,'dd/mm/yy')
            and f.sng001inst=a.wfinsprcid
            and b.xwfcar3='1'
            and d1.pepais = f.sng001pais
            and d1.petdoc = f.sng001tdoc
            and d1.pendoc = f.sng001ndoc
            and s.wfstscod = a.wfstscod
            and s.wflngid = 'spa'
            and u.ubuser(+) = a.wfitemusrcod; 
        commit;
           EXCEPTION
          WHEN OTHERS THEN
            NULL;
            END;
END SP_CR_EVALUACION;

Procedure SP_CR_SOLICITUD (PD_FECINI IN DATE, PS_FECFIN IN DATE, pc_ubuser in varchar2) 
-- *****************************************************************
-- Nombre                     : SP_CR_SOLICITUD
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 
-- Autor de Creación          : ABERNEDO
-- Uso                        : Genera reporte desembolsos
-- Estado                     : Activo
-- Acceso                     : Público
-- Parámetros de Entrada      : PD_FECINI, PS_FECFIN, pc_ubuser
-- Retorno                    : 
-- Fecha de Modificación      : 28/11/2023
-- Autor de la Modificación   : MILTON CORDOVA
-- Descripción de Modificación: Se modifica filtro
-- ***************************************************************** 
  IS

BEGIN
        delete from aqpc224 where AQPC224USU = rpad(pc_ubuser, 10, ' ');
        delete from JAQZ065 where JAQZ065USR = rpad(pc_ubuser, 10, ' ');
        COMMIT;

        begin
        
        insert into JAQZ065(JAQZ065INS,JAQZ065USC,JAQZ065FDI,JAQZ065EST,JAQZ065CRE,
                            JAQZ065REG,JAQZ065CSU,JAQZ065SUC,JAQZ065ANA,JAQZ065MOD,
                            JAQZ065MDA,JAQZ065CTA,JAQZ065OPE,JAQZ065SBO,JAQZ065TOP,
                            JAQZ065MTO,JAQZ065PAI,JAQZ065TDC,JAQZ065NDC,JAQZ065NOM,
                            JAQZ065TEL,JAQZ065TSO,JAQZ065USR,JAQZ065ZON)
        
        select a.wfinsprcid, 
               trim(a.wfitemusrcod)||'-'||trim(initcap(u.ubnom)) asignado,    
               a.wfiteminit ingdes,
               a.wfstscod||'-'||trim(s.wfstsdsc) estado,
               c.regcod,
               c.regnom region,
               r.sucurs,
               R.scnom sucursal,
               f.sng001ase analista,
               b.xwfmodulo modulo,
               decode(b.xwfmoneda,0,'S/.','US$') moneda,
               b.xwfcuenta cuenta,
               b.xwfoperacion operacion,
               b.xwfsubope SubOpe,
               b.xwftipope TipOpe,
               f.sng017mto monto,
               trim(f.sng001pais),
               trim(f.sng001tdoc),
               trim(f.sng001ndoc) Numdoc,
               trim(d1.penom) Cliente,
               fn_cl_telefonos(f.sng001pais,f.sng001tdoc,f.sng001ndoc) Telefonos,
               case when f.sng001ori = 0 then 'NORMAL'         
                    when f.sng001ori = 1 then 'CARTA FIANZA'
                    when f.sng001ori = 2 then 'NO HABILITADO'
                    when f.sng001ori = 3 then 'REFINANCIACION'
                    when f.sng001ori = 4 then 'AMPLIACION'
                    when f.sng001ori = 7 then 'DESEMBOLSOS PARCIALES'
                    when f.sng001ori = 10 then 'CONVENIO'
                    when f.sng001ori = 11 then 'LINEA DE CREDITO'
                    when f.sng001ori = 12 then 'AMPLIACION LINEAS DE CREDITO'
                    when f.sng001ori = 13 then 'REPROGRAMACION CAMBIO FECHA'              
                    when f.sng001ori = 14 then 'REPROGRAMACION DESASTRE NATURAL'    
                    when f.sng001ori = 15 then 'AMPLIACION ESPECIAL'    
                    when f.sng001ori = 16 then 'REPROGRAMACION CAMPAÑA'    
                    else 'NORMAL'                                                                                                  
               end "TIPO SOLICITUD",
               pc_ubuser,
               (select tp1nro1
                  from fst198 a
                 where tp1cod = 1 
                   and tp1cod1= 10872 
                   and tp1corr1= 11
                   and tp1nro2 =c.regcod)
          from wfwrkitems a, 
               xwf700 b, 
               FST810 c, 
               fst811 cc,
               sng001 f,
               fst001 r, 
               fsd001 d1,
               WFState1 s,
               fst746 u 
        where a.wfinsprcid=b.xwfprcins
            and b.xwfsucursal=cc.oficod
            and c.regcod = cc.regcod
            and cc.regcod < 100
            and c.regcod < 100
            and r.sucurs = b.xwfsucursal
            and a.wftaskcod=3 and a.wfstscod not in ('C','D')
            and a.wfitemid = (select max(m.wfitemid)
                                 from wfwrkitems m 
                                where m.wfinsprcid = a.wfinsprcid
                              )
            and to_date(a.wfiteminit,'dd/mm/yy') between to_date(PD_FECINI,'dd/mm/yy')
            and to_date(PS_FECFIN,'dd/mm/yy')
            and f.sng001inst=a.wfinsprcid
            and b.xwfcar3='1'
            and d1.pepais = f.sng001pais
            and d1.petdoc = f.sng001tdoc
            and d1.pendoc = f.sng001ndoc
            and s.wfstscod = a.wfstscod
            and s.wflngid = 'spa'
            and u.ubuser(+) = a.wfitemusrcod;      
        commit;
           EXCEPTION
          WHEN OTHERS THEN
            NULL;
            END;
END SP_CR_SOLICITUD;
end PQ_CR_DESEMBOLSOS;
/

