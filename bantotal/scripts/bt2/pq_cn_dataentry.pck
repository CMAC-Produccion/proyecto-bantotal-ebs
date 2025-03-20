create or replace package pq_cn_dataentry is

  -- Author  : FPINTO
  -- Created : 25/05/2023
  -- Purpose : Listado de Instancias por numero de documento
  -- Autor Modificacion:
  -- Fecha Modificacion:
  -- Descripcion Modificacion:
  procedure sp_listado_instancias(pePais in number,
                                  TipDoc in number,
                                  pc_nroDoc in varchar2,
                                  pc_mensaje out varchar2);

end pq_cn_dataentry;
/

create or replace package body pq_cn_dataentry is

  procedure sp_listado_instancias(pePais in number,
                                  TipDoc in number,
                                  pc_nroDoc in varchar2,
                                  pc_mensaje out varchar2) is

  mensaje varchar2(200);
  nrodoc char(20);
  nrodoc2 char(12);
  n1 number; n2 number;
  begin
        nrodoc := rpad(pc_nrodoc,20,' ');
        nrodoc2 := rpad(pc_nrodoc,12,' ');
        --select length(AQPB123NUMDOC) into n1 from aqpb123 where AQPB123CORR=1;
        --select length(nroDoc) into n2 from dual;
        delete from aqpb123 where AQPB123PEPAI = pePais and AQPB123TIPDOC=TipDoc 
        and AQPB123NUMDOC=nroDoc;
        commit;
        insert into AQPB123 (AQPB123CORR, AQPB123PEPAI, AQPB123TIPDOC, AQPB123NUMDOC, 
                        AQPB123EST, AQPB123INST, AQPB123AGEN, AQPB123CTA, 
                        AQPB123MOD, AQPB123TIPOPE, AQPB123OPE, AQPB123SUBOPE) 
                        select /*+ all_rows*/ rownum, y.PEPAIS, y.PETDOC, y.PENDOC, 
                        decode(y.estado,'-','EN FLUJO',y.estado) estado  , 
                        y.xwfprcins instancia, y.agencia, y.xwfcuenta cuenta , y.xwfmodulo modulo, 
                        y.xwftipope tipooperacion, y.xwfoperacion operacion, y.xwfsubope suboperacion 
                           from (select /*+ all_rows*/
                                c.AOSTAT || '-' ||
                                (select e.cenom from fst026 e where e.cecod = c.AOSTAT) estado, 
                                t.xwfprcins,
                                t.xwfsucursal || '-' ||
                                (select a.scnom from fst001 a where a.sucurs = t.xwfsucursal) agencia,
                                t.xwfcuenta,
                                t.xwfmodulo,
                                t.xwftipope,
                                t.xwfoperacion,
                                t.xwfsubope,
                                r.PEPAIS,
                                r.PETDOC,
                                r.PENDOC
                                 from xwf700 t, fsr008 r, fsd010 c
                                  where t.xwfempresa = r.PGCOD
                                    and t.xwfcuenta = r.CTNRO
                                    and t.xwfempresa = c.PGCOD(+)
                                    and t.xwfsucursal = c.AOSUC(+)
                                    and t.xwfmodulo = c.AOMOD(+)
                                    and t.xwfmoneda = c.AOMDA(+)
                                    and t.xwfpapel = c.AOPAP(+)
                                    and t.xwfcuenta = c.AOCTA(+)
                                    and t.xwfoperacion = c.AOOPER(+)
                                    and t.xwfsubope = c.aosbop(+)
                                    and t.xwftipope = c.AOTOPE(+)   
                                    and r.PEPAIS = pePais
                                    and r.PETDOC = TipDoc
                                    and r.PENDOC = nroDoc2) y    
                           where trim(y.estado) not in ('99-CANCELADA', '27-CARTERA VENDIDA');
                                    
     COMMIT;
     mensaje := 'PROCESO CORRECTO';
     pc_mensaje := mensaje;
  end sp_listado_instancias;

end pq_cn_dataentry;
/

