create or replace package pq_cn_formik is

  -- Author  : HLAQUI
  -- Created : 29/11/2017
  -- Purpose : Paquete que realiza la migracion de FORMIK
  -- Autor Modificacion:   HLAQUI
  -- Fecha Modificacion:   27/05/2020
  -- Descripcion Modificacion: Se optimiza procedimiento sp_flexible_refrescar
  -- Autor Modificacion:   HLAQUI
  -- Fecha Modificacion:   16/07/2020
  -- Descripcion Modificacion: Se modifica obtencion del usuario de sesion
  
  procedure sp_procesar_migracion(p_c_TipOpe varchar2, p_n_IdRef number, p_c_error out  varchar2);
  procedure sp_registrar_respuestas(p_c_TipOpe varchar2,p_n_CodReq number, p_c_error out  varchar2);
  procedure sp_procesar_respuestas;
  procedure sp_validar_imei(p_c_NumImei varchar2, p_c_Result out  varchar2);
  procedure sp_flexible_refrescar(p_c_NumDoc varchar2, p_c_FlgAtr out varchar2);
  procedure sp_reporte_gestiones(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_error out varchar2);
  procedure sp_reporte_compromisos(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_error out varchar2);
end pq_cn_formik;
/

create or replace package body pq_cn_formik is

Procedure sp_procesar_migracion(p_c_TipOpe varchar2, p_n_IdRef number,  p_c_error out  varchar2) is
  /*
  p_TipOpe:   A: Asignaciones
              C: Cancelaciones
              U: Actualizaciones
              CA: Cancelacion Automatica
              CF: Cancelacion Flexible
  p_n_IdRef: ID de referencia en caso no sea de BI, ( ID de la AQPA156 - Trama respuestas) / CA
             ID de referencia en caso no sea de BI, ( ID de la AQPA159 - Log Flexibles) / CF
              
  */
  ld_fecha   date;
  lv_usuario varchar2(60);
  ln_Id      numeric;
  ln_IdOpe   numeric;
  lv_NumDoc varchar2(20);
  begin
      --Se obtiene el usuario de ejecución
      lv_usuario := TRIM(SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), 1, 60));
      lv_usuario := replace(upper(lv_usuario), 'AREQUIPA\'); --Hlaqui 16/07/2020
      lv_usuario := replace(upper(lv_usuario), 'CMACAQP\'); --Hlaqui 16/07/2020
      --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;
      --Obtener Maximo ID de la AQPA155
      select nvl(max(AQPA155Id),0) into ln_Id from AQPA155;
      select nvl(max(AQPA155IdOpe),0) into ln_IdOpe from AQPA155 where AQPA155TipOpe=trim(p_c_TipOpe);
      
      if p_c_TipOpe='A' then
        Insert into AQPA155
        (aqpa155Id, aqpa155IdOpe, aqpa155TipOpe, aqpa155fecpro, aqpa155ordini, aqpa155ordfin, aqpa155idcli, aqpa155idpro,
        aqpa155ordenes, aqpa155usureg, aqpa155fecreg, aqpa155flgpro, aqpa155coderr, aqpa155msjerr,
        aqpa155horreg, aqpa155flgori)
        select rownum + ln_Id, N_ID_ASIGNACION,p_c_TipOpe, D_FECHA_PROCESO, C_ID_ORDEN_INI, C_ID_ORDEN_FIN, CLIENTID, 
        PRODUCTID, WORKORDERS,lv_usuario,ld_fecha,'N','','', to_char(current_timestamp, 'HH24:MI:SS'), 'M'
        from T_ASIGNACIONES@formik Where N_ID_ASIGNACION > ln_IdOpe ;
        commit;
      end if;
      if p_c_TipOpe='C' then
        Insert into AQPA155
        (aqpa155Id, aqpa155IdOpe, aqpa155TipOpe, aqpa155fecpro, aqpa155ordini, aqpa155ordfin, aqpa155idcli, aqpa155idpro,
        aqpa155ordenes, aqpa155usureg, aqpa155fecreg, aqpa155flgpro, aqpa155coderr, aqpa155msjerr,
        aqpa155horreg, aqpa155flgori)
        select rownum + ln_Id, N_ID_CANCELACION, p_c_TipOpe, D_FECHA_PROCESO, C_ID_ORDEN_INI, C_ID_ORDEN_FIN, CLIENTID, 
        PRODUCTID, WORKORDERS,lv_usuario,ld_fecha,'N','','', to_char(current_timestamp, 'HH24:MI:SS'), 'M'
        from T_CANCELACIONES@formik Where N_ID_CANCELACION > ln_IdOpe ;
        commit;
      end if;
      if p_c_TipOpe='CA' then --Para la cancelacion automatica de las ordenes existentes del cliente.
        select trim(AQPA156IdeDoc) into lv_NumDoc from AQPA156 where AQPA156Id=p_n_IdRef;
                  
        Insert into AQPA155
        (aqpa155Id, aqpa155IdOpe, aqpa155TipOpe, aqpa155fecpro, aqpa155ordini, aqpa155ordfin, aqpa155idcli, aqpa155idpro,
        aqpa155ordenes, aqpa155usureg, aqpa155fecreg, aqpa155flgpro, aqpa155coderr, aqpa155msjerr,
        aqpa155horreg, aqpa155flgori)
        
        select rownum + ln_Id, p_n_IdRef /*Se indica el ID de la AQPA156 (Trama ORIGEN)*/, 'C', D_FECHA_PROCESO, 0, 0, '', 
        '', WORKORDERS,lv_usuario,ld_fecha,'N','','', to_char(current_timestamp, 'HH24:MI:SS'),'A' /*Automatico como respuesta a una AQPA156 (Respuesta Formiik)*/
        from T_ORDENES_CLIENTE@formik Where trim(C_CODIGO_CLIENTE) = trim(lv_NumDoc) ;
        commit;
      end if;
      if p_c_TipOpe='CF' then --Para la cancelacion automatica de las ordenes existentes del cliente.
        select AQPA159Documento into lv_NumDoc from AQPA159 where AQPA159Id=p_n_IdRef;
                  
        Insert into AQPA155
        (aqpa155Id, aqpa155IdOpe, aqpa155TipOpe, aqpa155fecpro, aqpa155ordini, aqpa155ordfin, aqpa155idcli, aqpa155idpro,
        aqpa155ordenes, aqpa155usureg, aqpa155fecreg, aqpa155flgpro, aqpa155coderr, aqpa155msjerr,
        aqpa155horreg, aqpa155flgori)
        
        select rownum + ln_Id, p_n_IdRef /*Se indica el ID de la AQPA159 (JSON Flexible)*/, 'C', D_FECHA_PROCESO, 0, 0, '', 
        '', WORKORDERS,lv_usuario,ld_fecha,'N','','', to_char(current_timestamp, 'HH24:MI:SS'),'F' /*Automatico como respuesta a un Flexible*/
        from T_ORDENES_CLIENTE@formik Where trim(C_CODIGO_CLIENTE) = trim(lv_NumDoc) ;
        commit;
      end if;
          
  EXCEPTION
    WHEN OTHERS THEN
      p_c_error := sqlerrm;
end sp_procesar_migracion;

procedure sp_registrar_respuestas(p_c_TipOpe varchar2, p_n_CodReq number, p_c_error out  varchar2) is
  /*
  p_TipOpe:   R: Recepcion de Respuestas
  */
  ld_fecha   date;
  ld_fechahora   date;
  lc_usuario varchar2(60);
  ln_Id      numeric;
  lc_Id_Orden varchar2(60);
  lc_TipRes   varchar2(60);  
  lc_TipDoc   varchar2(10);
  lc_PaiDoc   varchar2(10);  
  lc_NumDoc   varchar2(12);
  lc_IdeDoc   varchar2(100);  
  lc_CodRea   varchar2(10);
  lc_FinDat   varchar2(30);

  lc_UrlImg   varchar2(500);
  ln_CanReg   numeric; --Cantidad de Registro
  
  ln_Corr     numeric; --Correlativo BI
  lc_Estado   varchar2(30);  
  begin

      --Se obtiene el usuario de ejecución
      lc_usuario := TRIM(SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), 1, 60));
      lc_usuario := replace(upper(lc_usuario), 'AREQUIPA\'); --Hlaqui 16/07/2020
      lc_usuario := replace(upper(lc_usuario), 'CMACAQP\'); --Hlaqui 16/07/2020      
      --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;
      --Obtener Maximo ID de la AQPA156
      --select nvl(max(AQPA156Id),0) + 1 into ln_Id from AQPA156;   
      select SQ_CN_FORMIIK_AQPA156.NEXTVAL into ln_Id from dual;
      ld_fechahora := to_date(to_char(ld_fecha,'dd/mm/yyyy') ||' '|| to_char(current_timestamp, 'HH:MI:SS a.m.'), 'dd/mm/yyyy HH:MI:SS a.m.');
      
      Insert into AQPA156
      (aqpa156id, aqpa156tipope, aqpa156codreq, aqpa156xml, aqpa156fecreg, aqpa156horreg, aqpa156flgpro, aqpa156coderr, aqpa156msjerr, aqpa156codcan, aqpa156codusu)
      select ln_Id, p_c_TipOpe, X9996drqsv, to_lob(X9996evall), ld_fecha, to_char(current_timestamp, 'HH24:MI:SS'),'N', '', '',X9996acnco, lc_usuario
      from X9996e where X9996acnco = 989 and X9996drqsv = p_n_CodReq and X9996edato='FORMIK' ;
      commit;      
      
      if p_c_TipOpe = 'R' then
         select /*substr(Documento, 1, instr(Documento,'-') -1), 
                substr(Documento, instr(Documento,'-') +1),*/
                Documento,
                substr(Documento, 1, instr(Documento,'-') -1), 
                substr(Documento, instr(Documento,'-')+1, instr(Documento,'-',instr(Documento,'-')+1) - instr(Documento,'-')-1),
                substr(Documento, instr(Documento,'-',instr(Documento,'-')+1)+1),
                Reaccion, IdOrden, TipRes, FinDat, UrlImg
                into lc_IdeDoc, lc_PaiDoc, lc_TipDoc, lc_NumDoc, lc_CodRea, lc_Id_Orden, lc_TipRes, lc_FinDat, lc_UrlImg
         from (
         select case when b.TipRes = 'CobranzaJ' 
                  then trim(XMLTYPE(xml).EXTRACT('/Response/CobranzaJ/PesGeneral/IdentificacionTitular/text()').GETSTRINGVAL())
                  else trim(XMLTYPE(xml).EXTRACT('/Response/Cobranza/PesGeneral/IdentificacionTitular/text()').GETSTRINGVAL())
                end Documento, 
                case when b.TipRes = 'CobranzaJ' 
                  then trim(XMLTYPE(xml).EXTRACT('/Response/CobranzaJ/PesGestion/CodigoReaccion/text()').GETSTRINGVAL())
                  else trim(XMLTYPE(xml).EXTRACT('/Response/Cobranza/PesGestion/CodigoReaccion/text()').GETSTRINGVAL())
                end Reaccion, IdOrden, TipRes, FinDat,
                
                case when b.TipRes = 'CobranzaJ' then 
                trim(XMLTYPE(xml).EXTRACT('/Response/CobranzaJ/PesGeneral/CapturaFotoFachadaVisita/text()').GETSTRINGVAL()) 
                else trim(XMLTYPE(xml).EXTRACT('/Response/Cobranza/PesGeneral/CapturaFotoFachadaVisita/text()').GETSTRINGVAL()) end UrlImg
                
         from (
             select trim(ExtractValue(XMLTYPE(a.aqpa156XML), '/Response/@ExternalId')) IdOrden ,
             trim(ExtractValue(XMLTYPE(a.aqpa156XML), '/Response/@ExternalType')) TipRes, 
             trim(ExtractValue(XMLTYPE(a.aqpa156XML), '/Response/@FinalDate')) FinDat, 
             a.aqpa156xml xml
             from AQPA156 a where aqpa156id=ln_Id
              ) b 
              ) c;
         
         --Verificamos si ya existe un registro con el mismo ID orden y Final Date
         select count(1) into ln_CanReg from AQPA156 where AQPA156idord=lc_Id_Orden and AQPA156FinDat=lc_FinDat;
         if ln_CanReg > 0 then
            lc_Estado:='D'; 
         Else
           lc_Estado:='N';
         end if;
         
         update AQPA156
         set AQPA156idord=trim(lc_Id_Orden), AQPA156TipRes=trim(lc_TipRes),
             AQPA156IdeDoc = trim(lc_IdeDoc), AQPA156PaiDoc = trim(lc_PaiDoc),
             AQPA156TipDoc = trim(lc_TipDoc), AQPA156NumDoc = trim(lc_NumDoc), AQPA156CodRea = trim(lc_CodRea),
             AQPA156FinDat = trim(lc_FinDat), aqpa156flgpro = lc_Estado
         where aqpa156id = ln_Id;
         commit; 
         
         select nvl(max(N_ID_RESPUESTA),0) +1 into ln_corr from  t_respuestas@formik;
         /*Insertamos en BI*/
         insert into t_respuestas@formik
         (N_ID_RESPUESTA, D_FECHA_HORA_RESPUESTA, C_TIPO_RESPUESTA, C_ID_ORDEN, RESPUESTA) 
         select ln_corr, current_timestamp , a1.AQPA156TIPRES, a1.aqpa156idord, a1.aqpa156xml from aqpa156 a1 where aqpa156id = ln_Id;
         commit;
      end if;                   
  EXCEPTION
    WHEN OTHERS THEN
      p_c_error := sqlerrm;
      update AQPA156 set AQPA156CodErr = '15609',AQPA156MsjErr = p_c_error                  
      where aqpa156id = ln_Id;
      commit; 
end sp_registrar_respuestas;

procedure sp_procesar_respuestas is
  
  lc_error   varchar2(100);
  ld_fecha   date;
  ln_Id      numeric;
  ln_nroerr  numeric;
  lc_CodRea  varchar2(5);
  lc_etapa   varchar2(100);  
  ln_IdAqpa156   numeric;
  ld_TipRes      varchar2(60);

  cursor Respuestas is
  select * from aqpa156
  where aqpa156flgpro='N' and trim(aqpa156tipres) in ('CobranzaJ', 'Cobranza') ;         
  
  cursor Reacciones is --Reacciones no procesadas
  select * 
  from aqpa157 a 
  inner join aqpa157d b on a.aqpa157id = b.aqpa157did
  where aqpa157flgRea='N';

  begin
      --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;      
      
      For p in Respuestas loop
          ln_IdAqpa156 := p.aqpa156id;
          --Obtener Maximo ID de la AQPA157
          select nvl(max(AQPA157Id),0) + 1 into ln_Id from AQPA157;   
          --Obtenemos el Tipo de Respuesta
          ld_TipRes := '';
          if trim(p.aqpa156tipres) = 'CobranzaJ' then
             ld_TipRes := 'J';
          end if;
          --Obtenemos el codigo de reaccion   
          select AQPA156CodRea into lc_CodRea
          from AQPA156 where  aqpa156id = p.aqpa156id;
          
          --Obtener la Fecha Compromiso/ Num Instancia
          --delete from aqpa157tmp;        
          begin  
            if lc_CodRea in ('10', '19') then
              insert into aqpa157d
              select ln_Id, y.NumIns, y.fecha from (
                select  to_date(x.fecha,'DD/MM/YYYY') Fecha, to_number(x.NumIns) NumIns from (
                  select XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito1/NumeroInstanciaCredito1/text()').GETSTRINGVAL() NumIns
                   ,substr(XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito1/CompromisoCredito1/FormEditResponse/Compromiso'|| ld_TipRes ||'/Compromiso/Fecha/text()').GETSTRINGVAL(),1,10) as Fecha     
                  from  AQPA156 b where b.aqpa156id = p.aqpa156id
                  union all
                  select XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito2/NumeroInstanciaCredito2/text()').GETSTRINGVAL() NumIns
                   ,substr(XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito2/CompromisoCredito2/FormEditResponse/Compromiso'|| ld_TipRes ||'/Compromiso/Fecha/text()').GETSTRINGVAL(),1,10) as Fecha
                  from  AQPA156 b where b.aqpa156id = p.aqpa156id
                  union all
                  select XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito3/NumeroInstanciaCredito3/text()').GETSTRINGVAL() NumIns
                   ,substr(XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito3/CompromisoCredito3/FormEditResponse/Compromiso'|| ld_TipRes ||'/Compromiso/Fecha/text()').GETSTRINGVAL(),1,10) as Fecha
                  from  AQPA156 b where b.aqpa156id = p.aqpa156id
                  union all
                  select XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito4/NumeroInstanciaCredito4/text()').GETSTRINGVAL() NumIns
                   ,substr(XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito4/CompromisoCredito4/FormEditResponse/Compromiso'|| ld_TipRes ||'/Compromiso/Fecha/text()').GETSTRINGVAL(),1,10) as Fecha
                  from  AQPA156 b where b.aqpa156id = p.aqpa156id
                  union all
                  select XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito5/NumeroInstanciaCredito5/text()').GETSTRINGVAL() NumIns
                   ,substr(XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito5/CompromisoCredito5/FormEditResponse/Compromiso'|| ld_TipRes ||'/Compromiso/Fecha/text()').GETSTRINGVAL(),1,10) as Fecha       
                  from  AQPA156 b where b.aqpa156id = p.aqpa156id
                  union all
                  select XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito6/NumeroInstanciaCredito6/text()').GETSTRINGVAL() NumIns
                   ,substr(XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito6/CompromisoCredito6/FormEditResponse/Compromiso'|| ld_TipRes ||'/Compromiso/Fecha/text()').GETSTRINGVAL(),1,10) as Fecha
                  from  AQPA156 b where b.aqpa156id = p.aqpa156id            
                ) x where trim(x.NumIns) is not null
              ) y where y.fecha is not null;
            else
              insert into aqpa157d
              select ln_Id, nvl(to_number(XMLTYPE(aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesCredito1/NumeroInstanciaCredito1/text()').GETSTRINGVAL()),0), null
              from  AQPA156 b where b.aqpa156id = p.aqpa156id;
            end If;
            commit;
          exception
          when others then
            select nvl(max(aqpa157aCorr),0) + 1 into  ln_nroerr from aqpa157a;
            lc_error := sqlerrm;
            insert into aqpa157a
              (aqpa157acorr, aqpa157aid, aqpa157adeserr, aqpa157afecreg, aqpa157ahorreg, aqpa157aetaerr)
            values
              (ln_nroerr, p.aqpa156id, lc_error, sysdate, TO_CHAR(sysdate, 'HH24:MI:SS'), lc_etapa);
            update AQPA156
            set aqpa156flgpro='E'
            where aqpa156id = p.aqpa156id;          
            commit;
          End;
            
          begin
              --Registramos en la AQPA157
              lc_etapa := 'Registrar en AQPA157';   
              insert into AQPA157 (aqpa157id, aqpa157idlog, aqpa157fecrea, aqpa157horrea, /* aqpa157numins, */
                     aqpa157imeieq, aqpa157codusu, aqpa157latitu, aqpa157longit, aqpa157detrea, aqpa157motrea, 
                     aqpa157motnpa, /*aqpa157feccom, */ aqpa157flgrea, aqpa157idord, aqpa157urlimg, aqpa157flgimg, 
                     aqpa157fecreg, aqpa157horreg)
              select  ln_Id, a.aqpa156id,
                      trunc(to_date(ExtractValue(XMLTYPE(a.aqpa156XML), '/Response/@FinalDate'),'YYYYMMDD HH24:MI:SS' )) Fecha,
                      to_char(to_date(ExtractValue(XMLTYPE(a.aqpa156XML), '/Response/@FinalDate'),'YYYYMMDD HH24:MI:SS'),'HH24:MI:SS') Hora,
                      --b.aqpa157numins,
                      trim(XMLTYPE(a.aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesGeneral/IdDispositivo/text()').GETSTRINGVAL()) Imei,
                      upper(ExtractValue(XMLTYPE(a.aqpa156XML), '/Response/@AssignedTo')) usuario,
                      trim(XMLTYPE(a.aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesGeneral/UbicacionVisita/manualLat/text()').GETSTRINGVAL()) Lat,
                      trim(XMLTYPE(a.aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesGeneral/UbicacionVisita/manualLng/text()').GETSTRINGVAL()) Lng,
                      trim(XMLTYPE(a.aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesGestion/Observaciones/text()').GETSTRINGVAL())  DetRea,
                      trim(XMLTYPE(a.aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesGestion/CodigoReaccion/text()').GETSTRINGVAL())  MotRea,
                      trim(XMLTYPE(a.aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesGestion/MotivoNoPago/text()').GETSTRINGVAL())  MotNpa,
                      --b.aqpa157feccom,
                      'N' FlgRea, trim(ExtractValue(XMLTYPE(a.aqpa156XML), '/Response/@ExternalId')) IdOrd,
                      trim(XMLTYPE(a.aqpa156XML).EXTRACT('/Response/Cobranza'|| ld_TipRes ||'/PesGeneral/CapturaFotoFachadaVisita/text()').GETSTRINGVAL())  UrlImg,
                      'N' FlgImg, ld_fecha, to_char(current_timestamp, 'HH24:MI:SS') hora
              from AQPA156 a /*, AQPA157tmp b*/ where  a.aqpa156id = p.aqpa156id;

              lc_etapa := 'Actualizar en AQPA156';
              update AQPA156
              set aqpa156flgpro='P'
              where aqpa156id = p.aqpa156id;          
              commit;
          exception
          when others then
            select nvl(max(aqpa157aCorr),0) + 1 into  ln_nroerr from aqpa157a;
            lc_error := sqlerrm;
            insert into aqpa157a
              (aqpa157acorr, aqpa157aid, aqpa157adeserr, aqpa157afecreg, aqpa157ahorreg, aqpa157aetaerr)
            values
              (ln_nroerr, p.aqpa156id, lc_error, sysdate, TO_CHAR(sysdate, 'HH24:MI:SS'), lc_etapa);

            update AQPA156
            set aqpa156flgpro='E'
            where aqpa156id = p.aqpa156id;          
            commit;
          End;
                     
      end loop;
            
      For p in Reacciones loop
        begin
            --Registrar las reacciones en Bantotal   
            lc_etapa := 'Registrar en JAQL523';       
            Insert into JAQL523
            (d_fecrea, c_horrea, n_numins, c_codusu, c_ipcelu, c_imeieq, 
             c_estreg, n_latitu, n_longit,c_detrea, n_codmot, n_codacc, 
             n_motrea, n_motnpa, d_feccom, c_tiprea, c_coderr, c_msgerr)
             values
             (p.aqpa157fecrea, p.aqpa157horrea, p.aqpa157dnumins, p.aqpa157codusu, '0.0.0.0', p.aqpa157imeieq, 
              '0', p.aqpa157latitu, p.aqpa157longit, p.aqpa157detrea, 5, 1,
              p.aqpa157motrea, p.aqpa157motnpa, p.aqpa157dfeccom, 'M', '0000', 'Proceso ExitosoF');          
            update AQPA157
            set aqpa157flgrea='P'
            where aqpa157id = p.aqpa157id;
            commit; 
        exception
          when others then            
            select nvl(max(aqpa157aCorr),0) + 1 into  ln_nroerr from aqpa157a;
            lc_error := sqlerrm;
            insert into aqpa157a
              (aqpa157acorr, aqpa157aid, aqpa157adeserr, aqpa157afecreg, aqpa157ahorreg, aqpa157aetaerr)
            values
              (ln_nroerr, p.aqpa157id, lc_error, sysdate, TO_CHAR(sysdate, 'HH24:MI:SS'), lc_etapa);
              
            update AQPA157
            set aqpa157flgrea='E', aqpa157ErrRea=lc_error
            where aqpa157id = p.aqpa157id;
            commit;
        end;
      end loop;

  EXCEPTION
    WHEN OTHERS THEN
      select nvl(max(aqpa157aCorr),0) + 1 into  ln_nroerr from aqpa157a;
      lc_error := sqlerrm;
      insert into aqpa157a
        (aqpa157acorr, aqpa157aid, aqpa157adeserr, aqpa157afecreg, aqpa157ahorreg, aqpa157aetaerr)
      values
        (ln_nroerr, ln_IdAqpa156, lc_error, sysdate, TO_CHAR(sysdate, 'HH24:MI:SS'), lc_etapa);      
      commit;
end sp_procesar_respuestas;
  
procedure sp_validar_imei(p_c_NumImei varchar2, p_c_Result out  varchar2) is
  ln_Cant   numeric;  
  lc_error   varchar2(50);  
  lc_ValImei   varchar2(30);  
  begin           
      select trim(tp1desc) into lc_ValImei
      from fst198 
      where tp1cod = 1  and tp1cod1 = 10801
      and tp1corr1 = 38 and tp1corr2 = 19
      and tp1corr3 = 1  and tp1nro1 = 0
      and tp1nro2 = 0   and tp1nro3 = 0;
         
      if trim(lc_ValImei) = 'S' then
        select count(*) into ln_Cant
        from wap.WPLSTEU e, wap.wplsted f
        where e.c_imeieq = f.c_imeieq
        and e.C_IMEIEQ = trim(p_c_NumImei)
        and e.C_ESTADO = 'V';
        
        if ln_Cant = 0 then
           select count(*) into ln_Cant           
           from fst198 t
           where t.tp1cod1 = 10801
           and t.tp1corr1 = 305
           and t.tp1corr2 > 0
           and t.tp1corr3 = 1
           and t.tp1nro1 = 1
           and t.tp1nro2 = 3 --3 Indica IMEI FORMIK
           and t.tp1desc = rpad(p_c_NumImei,30,' ');
        end if;             
        
        if ln_Cant > 0 then
            p_c_Result := 'S';
        else
            p_c_Result := 'N';
        end if;   
     else
        p_c_Result := 'S';
     end if;                    
  EXCEPTION
    WHEN OTHERS THEN
      lc_error := sqlerrm;
end sp_validar_imei;      

procedure sp_flexible_refrescar(p_c_NumDoc varchar2, p_c_FlgAtr out varchar2) is
  /*
  p_c_NumDoc: Esta compuesta por Tipo Documento - Num Documento
  p_FlgCre: Indicador S o N donde indica si el cliente tiene creditos en Mora (S) de lo contrario (N)
  */  
  --p_c_NumDoc:   Tipo Documento - Num Documento
  c1        PQ_CR_CUOTAMORA.detalle_cuota_cur;
  r1        PQ_CR_CUOTAMORA.detalle_cuota_rec;
  ld_fecha   date;
  lc_usuario varchar2(60);
  lc_error varchar2(100);

  ln_PaiDoc   numeric;
  ln_TipDoc   numeric;
  ln_NumPag   numeric;  --Numero de Pago de la cuota
  lc_NumDoc   varchar2(20);
  
  --JSON
  ln_CreMor   numeric;
  ln_CreDia   numeric;
  --html  
  lc_NumCta   varchar2(100);
  lc_NumOpe   varchar2(100);
  lc_NumSob   varchar2(100);
  lc_SalCap   varchar2(50);
  
  lc_DiaAtr   varchar2(10);  
  lc_FecUlt   varchar2(50);
  lc_MonUlt   varchar2(50);
  ln_IntUlt   number(17,2);   --Ultimo Interes Pagado
  lc_TotCuo   varchar2(50);
  lc_TotPag   varchar2(50); 
   
  lc_Oferta   varchar2(200);  
  lc_RelCre   varchar2(50);
  lc_TipCre   varchar2(50);  
  
  lc_Moneda   varchar2(10);  
  
  --html - Tabla
  ln_Contador  number(10); --nro de creditos a listar  
  lc_Margen   varchar2(100);  
  lc_FecCuo   varchar2(20);  
  ln_TMonCuo   number(17,2);   
  ln_TMonCap   number(17,2); 
  ln_TMonInt   number(17,2);
  ln_TCanSeg   number(10);
  ln_TMonSeg   number(17,2);
  ln_TMonMor   number(17,2); 
  --Cuota Pagada  
  ln_TCuoPagCap   number(17,2); --Cuota Pagada Capital
  ln_TCuoPagInt   number(17,2); --Cuota Pagada Interes
   
  --html - Tabla - Totales
  ln_TotMonCap   number(17,2); 
  ln_TotMonInt   number(17,2);
  ln_TotMonSeg   number(17,2);
  ln_TotMonMor   number(17,2); 
  ln_TotMonTot   number(17,2);
  
  --Judicial
  lc_EstAct   varchar2(50);
  lc_FecDem   varchar2(50);
  lc_NomAbo   varchar2(200);  
  lc_FecEnv   varchar2(50);
  
  lc_Html         clob; --HTML Lista de creditos con Mora
  lc_HtmlPagos    clob; --HTML Ultimos Pagos
  lc_Json         clob; --JSON con toda respuesta 
  
  --JSON Extra Datos
  ln_TotCuoVenSoles   number(17,2);
  ln_TotCuoVenDolares   number(17,2);  
  ln_DiaAtrMax          number(17,2);    
  ln_CanCreVig          number(17,2);      
  lc_FecUltPag          varchar2(50);      
  ln_SalCapTot          number(17,2);        
  --Cursores  
  cursor creditos_mora(paidoc in number, tipdoc in number,numdoc in varchar2) is 
  select x.* from (
  select d.*, 'Titular' Relacion from jaql964 d
  where d.jaql964doc = numdoc and d.jaql964TID = tipdoc and d.jaql964pai = paidoc and d.jaql964dia>0 and d.jaql964mod<>108
  union all
  select c.*, 'Aval' Relacion from jaql964 c
  inner join sng003 a on c.jaql964ins= a.sng001inst
  inner join fsr008 b on a.sng003cta= b.ctnro and b.pepais=paidoc and b.petdoc=tipdoc and b.pendoc=numdoc and c.jaql964mod<>108
  ) x
  order by x.jaql964dia desc;

  cursor creditos_mora_saldos(paidoc in number, tipdoc in number,numdoc in varchar2) is 
  select to_date(e.jaql964fdes,'YYYY.MM.DD') FecDes, e.* from jaql964 e
  where e.jaql964doc = numdoc and e.jaql964TID = tipdoc and e.jaql964pai = paidoc 
  and e.jaql964dia>0 and e.jaql964mod<>108
  order by 1 asc;   
   
  cursor ultimos_pagos(NumCuenta in number,NumOperacion in number, NumSubOpe in number, Cantidad in number) is 
  --HTML Ultimos Pagos por Credito
  select NumCuenta Cuenta, NumOperacion Operacion, NumSubOpe SubOpe, z.Pago, z.FecPag 
  from (
  select y.*,  row_number() over (order by y.fecpag desc) orden 
  from (
    select  x.ctnro Cuenta, x.itoper Operacion, x.itsubo SubOpe,  case
            when x.tp1nro1 = 6 then x.itimp6
            when x.tp1nro1 = 3 then x.itimp3
            when x.tp1nro1 = 1 then x.itimp1  end pago, x.itfcon FecPag  
    from (  
          select row_number() over( partition by h.pgcod, h.itsuc, h.itmod, h.ittran, h.itnrel order by h.itsbor asc) orden, 
                 h.*, n.tp1nro1, p.itfcon
          from (
                select distinct pgcod, itsuc, itmod, ittran, itnrel from fsd016 where ctnro = NumCuenta and itoper=NumOperacion) m
                inner join fsd016 h on m.pgcod = h.pgcod and m.itsuc = h.itsuc and  m.itmod = h.itmod 
                and m.ittran = h.ittran and  m.itnrel=h.itnrel    
                inner join fsd015 p on p.pgcod = h.pgcod
                and p.itmod = h.itmod
                and p.itsuc = h.itsuc
                and p.ittran = h.ittran
                and p.itnrel = h.itnrel
                and p.itcorr = 0
                inner join JAQZ511 n on h.pgcod = 1
                and n.tp1cod = h.pgcod
                and n.tp1corr1 = h.itmod
                and n.tp1corr2 = h.ittran
                and n.tp1corr3 = h.itord
          )x where x.orden=1 
    union all
      
    select  x.hcta, x.hoper, x.hcsubo,  case
            when x.tp1nro1 = 6 then x.hcimp6
            when x.tp1nro1 = 3 then x.hcimp3
            when x.tp1nro1 = 1 then x.hcimp1  end pago, x.hfcon FecPag
    from (
          select row_number() over( partition by i.pgcod, i.hcmod, i.hsucor, i.htran, i.hnrel, i.hfcon order by i.hcsubo asc) orden,
          i.*, n.tp1nro1
          from (
--                select distinct j.pgcod, j.hcmod, j.hsucor, j.htran, j.hnrel, j.hfcon 
--                from fsh016 j where j.pgcod=1 and j.hcta = NumCuenta and j.hoper=NumOperacion ) m 
                --27/05/2020 Hlaqui se limita la cantidad de pagos a mostrar
                select p.* 
                from (
                select distinct j.pgcod, j.hcmod, j.hsucor, j.htran, j.hnrel, j.hfcon 
                from fsh016 j 
                inner join JAQZ511 n on j.pgcod = 1
                and n.tp1cod = j.pgcod
                and n.tp1corr1 = j.hcmod
                and n.tp1corr2 = j.htran
                and n.tp1corr3 = j.hcord                   
                where j.pgcod=1 and j.hcta = NumCuenta and j.hoper=NumOperacion order by j.hfcon desc) p where rownum <= 3
                 ) m 
                 
                inner join fsh016 i on m.pgcod = i.pgcod and m.hcmod=i.hcmod 
                and m.hsucor = i.hsucor and m.htran =i.htran and m.hnrel = i.hnrel 
                and m.hfcon=i.hfcon
                inner join fsh015 p on p.pgcod = i.pgcod
                and p.hcmod = i.hcmod
                and p.hsucor = i.hsucor
                and p.htran = i.htran
                and p.hnrel = i.hnrel
                and p.hfcon = i.hfcon
                and p.hccorr = 0
                inner join JAQZ511 n on i.pgcod = 1
                and n.tp1cod = i.pgcod
                and n.tp1corr1 = i.hcmod
                and n.tp1corr2 = i.htran
                and n.tp1corr3 = i.hcord   
          )x where x.orden=1
    )y
  )z where z.orden <= Cantidad;
  
  begin
      --Se obtiene el usuario de ejecución
      lc_usuario := TRIM(SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), 1, 60));
      lc_usuario := replace(upper(lc_usuario), 'AREQUIPA\'); --Hlaqui 16/07/2020
      lc_usuario := replace(upper(lc_usuario), 'CMACAQP\'); --Hlaqui 16/07/2020      
      --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;
      --Se obtiene el Tipo Doc y Num Doc
      /*
      select to_number(substr(p_c_NumDoc, 1, instr(p_c_NumDoc,'-') -1)), 
      rpad(trim(substr(p_c_NumDoc, instr(p_c_NumDoc,'-') +1, 8)), 12,' '), 
      */
      select 
      to_number(substr(p_c_NumDoc, 1, instr(p_c_NumDoc,'-') -1)), 
      to_number(substr(p_c_NumDoc, instr(p_c_NumDoc,'-')+1, instr(p_c_NumDoc,'-',instr(p_c_NumDoc,'-')+1) - instr(p_c_NumDoc,'-')-1)),
      rpad(trim(substr(p_c_NumDoc, instr(p_c_NumDoc,'-',instr(p_c_NumDoc,'-')+1)+1)), 12,' ')                
      into ln_PaiDoc, ln_TipDoc, lc_NumDoc from dual;
     
      --Creditos Mora
      select count(1) into ln_CreMor from jaql964 where jaql964doc = lc_NumDoc and jaql964TID=ln_TipDoc and jaql964pai=604 and jaql964DIA>0;
      --Creditos al día
      select count(1) into ln_CreDia from jaql964 where jaql964doc = lc_NumDoc and jaql964TID=ln_TipDoc and jaql964pai=604 and jaql964DIA=0;
      --Flag Respuesta
      if ln_CreMor>0 then
         p_c_FlgAtr := 'S';
      else
         p_c_FlgAtr := 'N';
      End If;
      --HTML Creditos en Mora
      lc_Html :='<html><head><title></title><meta charset="utf-8" /></head><body>'; --Inicio del Cuerpo
      ln_Contador := 0;
      lc_Margen := '';          
      For p in creditos_mora(ln_PaiDoc, ln_TipDoc, lc_NumDoc) loop
            If p.jaql964mda = 0 then
              lc_Moneda := 'S/ ';
            Else
              lc_Moneda := 'USD ';
            End If;
            lc_Html := lc_Html || '<div>'; --Inicio del tag del credito
            lc_NumOpe := to_char(p.jaql964ope);
            lc_NumCta := to_char(p.jaql964cta);
            lc_NumSob := to_char(p.jaql964sob);
            lc_DiaAtr := to_char(p.jaql964dia);
            lc_SalCap := to_char(abs(p.jaql964sao),'fm999,999,990.90');
            
            --Valor Original de la Cuota         
            ln_TMonCuo := 0;   
            select nvl(y.cuota,0) into ln_TMonCuo from (
            select ppfpag, ppcap + ppint cuota, row_number() over (order by ppfpag asc) orden   
            from fsd601 x where x.ppcta=p.jaql964cta and x.ppoper=p.jaql964ope and ppcap>0
            ) y where y.orden=1;

            --Ultimo Fecha de pago y monto
            /*
            select to_char(m.pp1fech, 'DD/MM/YYYY'), to_char(m.pp1cap + m.pp1int + m.pp1intm + nvl(n.pp1imp11,0) + nvl(n.pp1imp12,0) +  nvl(n.pp1imp13,0) + nvl(n.pp1imp14,0) + nvl(n.pp1imp15,0), 'fm999,999,990.90'), m.pp1nump 
            into lc_FecUlt, lc_MonUlt, ln_NumPag 
            from (
            select * from (
            select row_number() over (order by pp1fech desc) orden, a.* 
            from fsd602 a where pgcod=1 and ppcta = p.jaql964cta and ppoper = p.jaql964ope ) x 
            where x.orden = 1 ) m 
            left outer join fsd612 n  on n.ppcta=p.jaql964cta and n.ppoper=p.jaql964ope and n.pp1nump= m.pp1nump;
            */
            --Ultimo Monto del seguro pagado
            --select pp1imp11 + pp1imp12 +  pp1imp13 + pp1imp14 + pp1imp15 into ln_IntUlt from fsd612 where ppcta=p.jaql964cta and ppoper=p.jaql964ope and pp1nump=ln_NumPag;
            lc_FecUlt := '';
            lc_MonUlt := '';
            For q in ultimos_pagos(p.jaql964cta, p.jaql964ope, p.jaql964sob, 1) loop
                  lc_FecUlt:=  to_char(q.fecpag, 'DD/MM/YYYY');
                  lc_MonUlt:=  to_char(q.pago,'fm999,999,990.90');
            end loop;
            
            --Total Cuotas
            select to_char(count(1)) into lc_TotCuo from fsd601 where pgcod=1 and ppcta = p.jaql964cta and ppoper = p.jaql964ope; 
            --Total pagadas
            select to_char(count(1)) into lc_TotPag from fsd602 where pgcod=1 and ppcta = p.jaql964cta and ppoper = p.jaql964ope and pp1stat='T';
            --Oferta
            lc_Oferta:='';
            --Relación con el crédito
            lc_RelCre:= p.Relacion; --'Titular';
            --Tipo de crédito - Normal, refinanciamiento
            select case when a.sng001ori=0 then 'NORMAL' 
                        when a.sng001ori=1 then 'CARTA FIANZA' 
                        when a.sng001ori=2 then 'NO HABILITADO' 
                        when a.sng001ori=3 then 'REFINANCIACION'                           
                        when a.sng001ori=4 then 'AMPLIACION'
                        when a.sng001ori=7 then 'DESEMBOLSOS PARCIALES' 
                        when a.sng001ori=10 then 'CONVENIOS'
                        when a.sng001ori=11 then 'LINEA CREDITO'
                        when a.sng001ori=12 then 'AMPLIACION LINEAS CREDITO'
                        when a.sng001ori=13 then 'REPROGRAMACION CAMBIO FECHA'
                        when a.sng001ori=14 then 'REPROGRAMACION DESASTRE NATURAL'
                        when a.sng001ori=15 then 'AMPLIACION ESPECIAL'
                        when a.sng001ori=16 then 'REPROGRAMACION CAMPAÑA'                                                                                      
                        end 
                        into lc_TipCre 
            from sng001 a where a.sng001inst = p.jaql964ins;            
            --JUDICIAL
            if p.jaql964mod = 200 or p.jaql964mod = 33 then
              select trim(cenom) into lc_EstAct from fst026 where cepop='S' and cecod=p.jaql964est; --estados
              --Fecha Demanda
              --lc_FecDem := to_char(to_date(p.jaql964fdem,'YYYY.MM.DD'), 'DD/MM/YYYY') ;
              lc_FecDem := to_char(to_date(p.jaql964fadem,'YYYY.MM.DD'), 'DD/MM/YYYY') ;              
              --Nombre Abogado
              lc_NomAbo := trim(p.jaql964abo); 
              --Fecha Envio Recuperacion Legal
              lc_FecEnv := to_char(to_date(p.jaql964firl,'YYYY.MM.DD'), 'DD/MM/YYYY') ;  
            End If;
            
            if ln_Contador > 0 then
              lc_Margen := 'margin-top:20px;';
            End If;
            lc_Html := lc_Html || '<div style="font:bold 16px verdana; background-color:darkblue; color:white; padding:3px 3px 3px 3px;'|| lc_Margen ||'">Crédito '|| trim(lc_NumCta) ||'-'|| trim(lc_NumOpe) ||'-'|| trim(lc_NumSob) || ' (' || lc_DiaAtr ||' días atraso)</div>';
            lc_Html := lc_Html || '<table style="width:100%;">';
            lc_Html := lc_Html || '<tr><td style="width:40%;">Numero operación:</td><td>'|| lc_NumOpe ||'</td></tr>';
            lc_Html := lc_Html || '<tr><td style="width:40%;">Saldo Capital:</td><td>'|| lc_Moneda || lc_SalCap ||'</td></tr>';            
            lc_Html := lc_Html || '<tr><td>Valor original cuota:</td><td>'|| lc_Moneda || to_char(ln_TMonCuo, 'fm999,999,990.90') ||'</td></tr>';
            lc_Html := lc_Html || '<tr><td>Días de mora:</td><td>'|| lc_DiaAtr ||'</td></tr>';
            lc_Html := lc_Html || '<tr><td>Ultima fecha de pago del crédito:</td><td>' || lc_FecUlt  ||'</td></tr>';
            lc_Html := lc_Html || '<tr><td>Valor ultimo monto pagado:</td><td>'|| lc_Moneda || lc_MonUlt ||'</td></tr>';
            lc_Html := lc_Html || '<tr><td>Cuotas pagadas / Pactadas:</td><td>'|| lc_TotPag || '/'|| lc_TotCuo || '</td></tr>';
            lc_Html := lc_Html || '<tr><td>Oferta:</td><td>Ninguna</td></tr>';
            lc_Html := lc_Html || '<tr><td>Relación con el crédito:</td><td>'|| lc_RelCre ||'</td></tr>';
            lc_Html := lc_Html || '<tr><td>Tipo de crédito:</td><td>'|| lc_TipCre ||'</td></tr>';
            
            if p.jaql964mod = 200 or  p.jaql964mod = 33 then --Judicial
               lc_Html := lc_Html || '<tr><td>Estado Actual:</td><td>'|| lc_EstAct ||'</td></tr>';
               lc_Html := lc_Html || '<tr><td>Fecha demanda:</td><td>'|| lc_FecDem ||'</td></tr>';
               lc_Html := lc_Html || '<tr><td>Nombre del abogado:</td><td>'|| lc_NomAbo ||'</td></tr>';
               lc_Html := lc_Html || '<tr><td>Fecha envío recuperación legal:</td><td>'|| lc_FecEnv ||'</td></tr>';
            End If;
            lc_Html := lc_Html || '</table>';
                       
            --Inicio - Tabla Cuotas con MORA
            lc_Html := lc_Html || '<table style="width:100%; border:1px solid black;" border="1">';
            lc_Html := lc_Html || '<tr><th style="width:5%;"># cuota</th> '||
                                      '<th style="width:10%;">Fecha Vencimiento</th>'||
                                      '<th style="width:7%;">Días atraso</th>'||
                                      '<th style="width:10%;">Monto cuota pactada</th>'||
                                      '<th>Capital</th>'||
                                      '<th>Interes</th>'||
                                      '<th>Mora</th>'||
                                      '<th>Otros</th>'||
                                      '<th>Total</th>'||
                                   '</tr>';
            --Totales del cronograma
            ln_TotMonCap := 0;
            ln_TotMonInt := 0;
            ln_TotMonSeg := 0;
            ln_TotMonMor := 0;
            ln_TotMonTot := 0;
            --Detalle Mora - Tabla HTML
            If p.jaql964mod = 200 or  p.jaql964mod = 33 or p.jaql964top=550 then --Judicial y Castigado
               --Totales del cronograma
                ln_TotMonCap:= p.jaql964sao;
                ln_TotMonInt:= p.jaql964int;
                ln_TotMonSeg:= p.jaql964gas;
                ln_TotMonMor:= p.jaql964mor;
                ln_TotMonTot:= p.jaql964mtd;
                --Fecha Vencimiento del credito Judicial - Castigado
                select to_char(r.aofvto,'dd/mm/yyyy') into lc_FecCuo from fsd010 r where r.aocta=p.jaql964cta and r.aooper=p.jaql964ope and r.aomod=p.jaql964mod and r.aosbop=p.jaql964sob;
                
                lc_Html := lc_Html || '<tr>' ||
                      '<td>'||'1'||'</td>'||
                      '<td>'||lc_FecCuo||'</td>'||
                      '<td>'||to_char(p.jaql964dia)||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TMonCuo,'fm999,999,990.90')||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TotMonCap,'fm999,999,990.90')||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TotMonInt,'fm999,999,990.90') ||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TotMonMor,'fm999,999,990.90')||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TotMonSeg,'fm999,999,990.90')||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TotMonTot,'fm999,999,990.90')||'</td>'||
                  '</tr>';             
            Else --Creditos Atrasados   
               c1 := pq_cr_cuotamora.Fn_DetalleCuota(p.jaql964pgcod,
                                        p.jaql964mod,
                                        p.jaql964suc,
                                        p.jaql964mda,
                                        p.jaql964pap,
                                        p.jaql964cta,
                                        p.jaql964ope,
                                        p.jaql964sob,
                                        p.jaql964top,
                                        ld_fecha);
                                        --trunc(sysdate));         
              LOOP 
                FETCH c1
                INTO  r1;
                EXIT WHEN c1%NOTFOUND;
                --Cuota Pagada por fecha segun r1.d_fecuo; 
                ln_TCuoPagCap := 0;  
                ln_TCuoPagInt := 0;                
                select nvl(sum(pp1cap),0), nvl(sum(pp1int),0) into ln_TCuoPagCap, ln_TCuoPagInt
                from fsd602 x 
                where x.pgcod=1 and x.ppcta = p.jaql964cta 
                and x.ppoper = p.jaql964ope
                and x.ppfpag = r1.d_fecuo;
                
                --Cuota Pactada, Capital, Interes
                select x.ppcap + x.ppint, x.ppcap, x.ppint 
                into ln_TMonCuo, ln_TMonCap, ln_TMonInt  
                from fsd601 x 
                where x.pgcod=1 and x.ppcta = p.jaql964cta 
                and x.ppoper = p.jaql964ope
                and x.ppfpag = r1.d_fecuo; 
                
                ln_TMonCuo := ln_TMonCuo - (ln_TCuoPagCap + ln_TCuoPagInt);
                ln_TMonCap := ln_TMonCap -  ln_TCuoPagCap;
                ln_TMonInt := ln_TMonInt -  ln_TCuoPagInt;
                
                --Seguros    
                ln_TMonSeg := 0;          
                select count(1)
                into ln_TCanSeg 
                from fsd611 y
                where y.pgcod = p.jaql964pgcod 
                and y.ppsuc = p.jaql964suc
                and y.ppmda = p.jaql964mda
                and y.pppap = p.jaql964pap
                and y.ppcta = p.jaql964cta 
                and y.ppoper = p.jaql964ope
                and y.ppsbop = p.jaql964sob
                and y.pptope = p.jaql964top
                and y.ppfpag = r1.d_fecuo;              
                if ln_TCanSeg > 0 then
                  select ppimp11 + ppimp12 + ppimp13 + ppimp14 + ppimp15 
                  into ln_TMonSeg 
                  from fsd611 y
                  where y.pgcod = p.jaql964pgcod 
                  and y.ppsuc = p.jaql964suc
                  and y.ppmda = p.jaql964mda
                  and y.pppap = p.jaql964pap
                  and y.ppcta = p.jaql964cta 
                  and y.ppoper = p.jaql964ope
                  and y.ppsbop = p.jaql964sob
                  and y.pptope = p.jaql964top
                  and y.ppfpag = r1.d_fecuo;
                end if;
                --Mora calculada al día
                ln_TMonMor := r1.n_monto - (ln_TMonCap + ln_TMonInt + ln_TMonSeg);
                --Totales del cronograma
                ln_TotMonCap:= ln_TotMonCap + ln_TMonCap;
                ln_TotMonInt:= ln_TotMonInt + ln_TMonInt;
                ln_TotMonSeg:= ln_TotMonSeg + ln_TMonSeg;
                ln_TotMonMor:= ln_TotMonMor + ln_TMonMor;
                ln_TotMonTot:= ln_TotMonTot + r1.n_monto;
              
                lc_Html := lc_Html || '<tr>' ||
                      '<td>'||to_char(r1.n_cuota)||'</td>'||
                      '<td>'||to_char(r1.d_fecuo,'dd/mm/yyyy')||'</td>'||
                      '<td>'||to_char(r1.n_diatr)||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TMonCuo,'fm999,999,990.90')||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TMonCap,'fm999,999,990.90')||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TMonInt,'fm999,999,990.90') ||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TMonMor,'fm999,999,990.90')||'</td>'||
                      '<td>'||lc_Moneda||to_char(ln_TMonSeg,'fm999,999,990.90')||'</td>'||
                      '<td>'||lc_Moneda||to_char(r1.n_monto,'fm999,999,990.90')||'</td>'||
                  '</tr>';                        
              END LOOP;
              CLOSE c1;
            End If;
                                    
            lc_Html := lc_Html || '<tr>'||
                '<td colspan="4" style="text-align:right; font-weight:bold;">Totales</td>' ||
                '<td>'||lc_Moneda||to_char(ln_TotMonCap,'fm999,999,990.90')||'</td>'||
                '<td>'||lc_Moneda||to_char(ln_TotMonInt,'fm999,999,990.90')||'</td>'||
                '<td>'||lc_Moneda||to_char(ln_TotMonMor,'fm999,999,990.90')||'</td>'||
                '<td>'||lc_Moneda||to_char(ln_TotMonSeg,'fm999,999,990.90')||'</td>'||
                '<td>'||lc_Moneda||to_char(ln_TotMonTot,'fm999,999,990.90')||'</td>'||
            '</tr>';
            
            lc_Html := lc_Html || '</table>';      
            --Fin - Tabla Cuotas con MORA                
          lc_Html := lc_Html || '</div>'; --Fin del tag del credito
          ln_Contador :=ln_Contador +1;
      end loop;            
      if ln_Contador = 0 then
         lc_Html := lc_Html || '<div><div style="font:bold 16px verdana; background-color:darkblue; color:white; padding:3px 3px 3px 3px;">Cliente al dia con todas sus obligaciones con Caja Arequipa</div></div>';
      end if;
      lc_Html := lc_Html || '<br><br>';
      lc_Html := lc_Html || '</body></html>'; --Fin cuerpo            
      --HTML Ultimos Pagos Credito
      lc_HtmlPagos := '<html><head><title></title><meta charset="utf-8" /></head><body><div><div style="font:bold 16px verdana; background-color:darkblue; color:white; padding:3px 3px 3px 3px">Ultimos Pagos Cliente</div>';
      lc_HtmlPagos := lc_HtmlPagos || '<table style="width:100%;" border="1"><tr><th style="width:20%;">Crédito</th><th style="width:20%;">Fecha</th><th>Monto</th></tr>';
      For p in creditos_mora_saldos(ln_PaiDoc, ln_TipDoc, lc_NumDoc) loop
        If p.jaql964mda = 0 then
          lc_Moneda := 'S/ ';
        Else
          lc_Moneda := 'USD ';
        End If;
        For q in ultimos_pagos(p.jaql964cta, p.jaql964ope, p.jaql964sob, 3) loop
          lc_HtmlPagos := lc_HtmlPagos || '<tr>';
            lc_HtmlPagos := lc_HtmlPagos || '<td>'|| to_char(q.cuenta) ||'-'|| to_char(q.operacion) ||'-'|| to_char(q.subope)||'</td>';
            lc_HtmlPagos := lc_HtmlPagos || '<td>'|| to_char(q.fecpag, 'DD/MM/YYYY') ||'</td>';
            lc_HtmlPagos := lc_HtmlPagos || '<td>'|| lc_Moneda ||to_char(q.pago,'fm999,999,990.90') ||'</td>';
                    lc_HtmlPagos := lc_HtmlPagos || '</tr>';
        end loop;

      end loop;
      lc_HtmlPagos := lc_HtmlPagos || '</table></div><br><br></body></html>';
             
      --JSON de Respuesta
      lc_Json := '{"UpdateFieldsValues": {'; --Inicio JSON
      lc_Json := lc_Json || '"CantidadCreditosMora": "'|| to_char(ln_CreMor) ||'",';
      lc_Json := lc_Json || '"CantidadCreditosAlDia": "'|| to_char(ln_CreDia) ||'",';
      lc_Json := lc_Json || '"DetalleCreditosMora": "'|| htf.escape_sc(lc_Html) ||'",';
      ln_Contador := 1;
      For p in creditos_mora_saldos(ln_PaiDoc, ln_TipDoc, lc_NumDoc) loop
        If p.jaql964mda = 0 then
          lc_Moneda := 'S/ ';
        Else
          lc_Moneda := 'USD ';
        End If;
        lc_Json := lc_Json || '"SaldoCapital'|| to_char(ln_Contador) ||'": "'||lc_Moneda|| to_char(abs(p.jaql964sao),'fm999,999,990.90') ||'",';
        lc_Json := lc_Json || '"Oferta'|| to_char(ln_Contador) ||'": "No definido",';        
        ln_Contador := ln_Contador + 1;
      end loop;
      lc_Json := lc_Json || '"UltimosPagos": "'|| htf.escape_sc(lc_HtmlPagos) ||'",';
      lc_Json := lc_Json || '"HistorialOfertas": "",';
      
      if ln_CreMor = 0 then --Cliente sin Creditos en Mora
        lc_Json := lc_Json || '},"FormiikReservedWords": [{"ReservedWord": "AlertMessage","Value": "Cliente al día con todos sus créditos. En minutos se cancelará la orden de cobranza ya que no requiere gestión."}]}'; --Fin JSON
      else
        lc_Json := lc_Json || '},"FormiikReservedWords": [{"ReservedWord": "AlertMessage","Value": "Actualización exitosa"}]}'; --Fin JSON
      end if;
      --lc_Json := lc_Json || '},"FormiikReservedWords": [{"ReservedWord": "AlertMessage","Value": "Actualización exitosa"}]}'; --Fin JSON
      
      --Registrar el flexible en la AQPA160
      delete from AQPA160 
      where aqpa160tipdoc = ln_TipDoc and aqpa160numdoc = lc_NumDoc;
      Insert into AQPA160
      (aqpa160tipdoc, aqpa160numdoc, aqpa160detcre, aqpa160detpag, aqpa160detofe, aqpa160resjson, aqpa160flgatr, aqpa160fecreg, aqpa160horreg, aqpa160usureg, aqpa160documento)
      values
      ( ln_TipDoc, lc_NumDoc, lc_Html, lc_HtmlPagos, '', lc_Json, p_c_FlgAtr, ld_fecha,to_char(sysdate, 'HH24:MI:SS'), lc_usuario, p_c_NumDoc);      
      commit;      
      
      
    EXCEPTION
    WHEN OTHERS THEN
      lc_error := sqlerrm;
end sp_flexible_refrescar;

procedure sp_reporte_gestiones(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_error out varchar2) is
  ln_Contador  number(10); --nro de creditos a listar  
  cursor gestiones is 
  select trim(a.aqpa156TipRes) Tipo, a.* from aqpa156 a
  where a.aqpa156fecreg >= p_d_FecIni and a.aqpa156fecreg <= p_d_FecFin and 
  a.aqpa156tipres in ('Cobranza', 'CobranzaJ')  
  and a.aqpa156flgpro <>'D' --and a.aqpa156id=24
  order by 2 asc;   
   
  begin         
      delete from  aqpa161a where aqpa161aCodUsu = p_c_Codusu and aqpa161aTipRep='G';
      ln_Contador:=1;
      For p in gestiones loop
        insert into  aqpa161a --Reporte de Gestiones
        (aqpa161acodusu, aqpa161acorr, aqpa161acorr2, aqpa161acorr3, aqpa161aTipRep, aqpa161afecreg, aqpa161ahorreg, 
         aqpa161aregion, aqpa161azona, aqpa161aagencia, 
         aqpa161anumdoc, aqpa161anomcli, aqpa161adocges, aqpa161anomges, 
         aqpa161acuenta, aqpa161aope, aqpa161amod, aqpa161amoneda, aqpa161afecasi, aqpa161asalasi, 
         aqpa161adiaatr, aqpa161aanares, aqpa161agesasi, aqpa161acargo, aqpa161asalcap, 
         aqpa161atipdir, aqpa161adir, aqpa161adirdep, aqpa161adirpro, aqpa161afecges, 
         aqpa161ahorges, aqpa161adirval, aqpa161acontac, aqpa161atipcon, aqpa161amotinu, 
         aqpa161areacci, aqpa161amotnpa, aqpa161aobs, aqpa161atipges, aqpa161aacecam, aqpa161asujvis)
        select p_c_Codusu, ln_Contador, rownum,1,'G', trunc(CURRENT_DATE), to_char(CURRENT_DATE, 'HH24:MI:SS'),
        trim(f.tp1desc) Region, trim(d.jaql964ren) Zona, trim(d.jaql964nom) Agencia, 
        d.jaql964doc NumDoc, d.jaql964tit NomCli, '', c.NomCto NomGes, 
        d.jaql964cta Cuenta, d.jaql964ope Operacion, d.jaql964mod Modulo, c.Moneda, c.FecReg FecAsi, c.SalCap SalCap, 
        c.DiaMor DiaMor, d.jaql964usu Analista, c.UsuAsi Asignado, '' Cargo, d.jaql964sao SalCapAct, 
        '', c.Direccion, '', c.ProDis, TRUNC(c.FecGes) FecGes, 
        to_char(c.FecGes, 'HH24:MI:SS' ) HorGes, c.DirVal,'', upper(trim(nvl(g.tp1desc,''))) TipCto, upper(trim(nvl(h.tp1desc,''))) MotInu,
        upper(trim(nvl(i.tp1desc,''))) Reaccion, upper(trim(nvl(j.tp1desc,''))) MotNoPag, c.Observaciones, c.Tipges,'', c.SujVis
        from (
          SELECT rpad(trim(b.aqpa156NumDoc),12,' ') NumDoc, b.aqpa156TipDoc TipDoc, b.aqpa156fecreg FecReg,
          to_date(trim(ExtractValue(XMLTYPE(b.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS') FecGes,
          upper(trim(ExtractValue(XMLTYPE(b.aqpa156XML), '/Response/@AssignedTo'))) UsuAsi,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGeneral/DireccionVisita/text()').GETSTRINGVAL()) Direccion,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGeneral/ProvinciaDistritoVisita/text()').GETSTRINGVAL()) ProDis,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGeneral/TipoVisita/text()').GETSTRINGVAL()) Tipges,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGeneral/SujetoVisita/text()').GETSTRINGVAL()) SujVis,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGestion/NombreContactado/text()').GETSTRINGVAL()) NomCto,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGestion/DireccionValida/text()').GETSTRINGVAL()) DirVal,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGestion/TipoContacto/text()').GETSTRINGVAL()) TipCto,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGestion/MotivoInubicabilidad/text()').GETSTRINGVAL()) MotInu,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGestion/Reaccion/text()').GETSTRINGVAL()) Reaccion,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGestion/MotivoNoPago/text()').GETSTRINGVAL()) MotNoPag,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGestion/Observaciones/text()').GETSTRINGVAL()) Observaciones,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGeneral/CodigoDepartamentoNuevaDireccion/text()').GETSTRINGVAL()) CodDep,
          trim(XMLTYPE(b.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesGeneral/CodigoProvinciaNuevaDireccion/text()').GETSTRINGVAL()) CodPro,
          z.NumIns, z.SalCap, z.Moneda, z.DiaMor
          FROM  AQPA156 b
          inner join
          ( select x.* from (
              select y.aqpa156id,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito1/NumeroInstanciaCredito1/text()').GETSTRINGVAL()) NumIns,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito1/SaldoCapital1/text()').GETSTRINGVAL()) SalCap,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito1/Moneda1/text()').GETSTRINGVAL()) Moneda,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito1/DiasMora1/text()').GETSTRINGVAL()) DiaMor
              FROM  AQPA156 y where y.aqpa156id=p.aqpa156id
              union all
              select y.aqpa156id,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito2/NumeroInstanciaCredito2/text()').GETSTRINGVAL()) NumIns,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito2/SaldoCapital2/text()').GETSTRINGVAL()) SalCap,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito2/Moneda2/text()').GETSTRINGVAL()) Moneda,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito2/DiasMora2/text()').GETSTRINGVAL()) DiaMor
              FROM  AQPA156 y where y.aqpa156id=p.aqpa156id
              union all
              select y.aqpa156id,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito3/NumeroInstanciaCredito3/text()').GETSTRINGVAL()) NumIns,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito3/SaldoCapital3/text()').GETSTRINGVAL()) SalCap,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito3/Moneda3/text()').GETSTRINGVAL()) Moneda,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito3/DiasMora3/text()').GETSTRINGVAL()) DiaMor
              FROM  AQPA156 y where y.aqpa156id=p.aqpa156id
              union all
              select y.aqpa156id,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito4/NumeroInstanciaCredito4/text()').GETSTRINGVAL()) NumIns,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito4/SaldoCapital4/text()').GETSTRINGVAL()) SalCap,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito4/Moneda4/text()').GETSTRINGVAL()) Moneda,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito4/DiasMora4/text()').GETSTRINGVAL()) DiaMor
              FROM  AQPA156 y where y.aqpa156id=p.aqpa156id
              union all
              select y.aqpa156id,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito5/NumeroInstanciaCredito5/text()').GETSTRINGVAL()) NumIns,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito5/SaldoCapital5/text()').GETSTRINGVAL()) SalCap,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito5/Moneda5/text()').GETSTRINGVAL()) Moneda,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito5/DiasMora5/text()').GETSTRINGVAL()) DiaMor
              FROM  AQPA156 y where y.aqpa156id=p.aqpa156id
              union all
              select y.aqpa156id,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito6/NumeroInstanciaCredito6/text()').GETSTRINGVAL()) NumIns,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito6/SaldoCapital6/text()').GETSTRINGVAL()) SalCap,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito6/Moneda6/text()').GETSTRINGVAL()) Moneda,
              trim(XMLTYPE(y.aqpa156XML).EXTRACT('/Response/'||p.tipo||'/PesCredito6/DiasMora6/text()').GETSTRINGVAL()) DiaMor
              FROM  AQPA156 y where y.aqpa156id=p.aqpa156id
              ) x where trim(x.NumIns) is not null
            )z  on z.aqpa156id=b.aqpa156id 
            where b.aqpa156id=p.aqpa156id
        ) c 
        inner join jaql964 d on d.jaql964pai=604 and d.jaql964tid=c.TipDoc 
        and d.jaql964doc=c.NumDoc and d.jaql964ins=c.NumIns
        inner join fst811 e on e.oficod = d.jaql964suc and e.regcod < 100 and e.regcod > 0 and e.ofisuc = 'S'
        inner join fst198 f on f.tp1cod = 1 and f.tp1cod1 = 10872 and f.tp1corr1 = 11 and f.tp1nro2 = e.regcod
        left outer join fst198 g on g.tp1cod = 1 and g.tp1cod1 = 10801 and g.tp1corr1 = 38 and g.tp1corr2 = 15 and g.tp1corr3 = to_number(c.TipCto)
        left outer join fst198 h on h.tp1cod = 1 and h.tp1cod1 = 10801 and h.tp1corr1 = 38 and h.tp1corr2 = 16 and h.tp1corr3 = to_number(c.MotInu)
        left outer join fst198 i on i.tp1cod = 1 and i.tp1cod1 = 10801 and i.tp1corr1 = 38 and i.tp1corr2 = 17 and i.tp1corr3 = to_number(c.Reaccion)
        left outer join fst198 j on j.tp1cod = 1 and j.tp1cod1 = 10801 and j.tp1corr1 = 38 and j.tp1corr2 = 18 and j.tp1corr3 = to_number(c.MotNoPag);         
        ln_Contador := ln_Contador+1;
      end loop;
      commit;
  EXCEPTION
    WHEN OTHERS THEN
      p_c_error := sqlerrm;
end sp_reporte_gestiones;

procedure sp_reporte_compromisos(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_error out varchar2) is
  ln_Contador  number(10); --nro de creditos a listar  
  cursor gestiones is 
  select trim(a.aqpa156TipRes) Tipo, a.* from aqpa156 a
  where a.aqpa156fecreg >= p_d_FecIni and a.aqpa156fecreg <= p_d_FecFin and 
  a.aqpa156tipres in ('Cobranza', 'CobranzaJ')  
  and a.aqpa156flgpro <>'D' --and a.aqpa156id=24
  order by 2 asc;   
   
  begin         
      delete from  aqpa161a where aqpa161aCodUsu = p_c_Codusu and aqpa161aTipRep='C';
      ln_Contador:=1;
      For p in gestiones loop
        insert into  aqpa161a --Reporte de Gestiones
        (aqpa161acodusu, aqpa161acorr, aqpa161acorr2, aqpa161acorr3, aqpa161aTipRep, aqpa161afecreg, aqpa161ahorreg, 
         aqpa161aregion, aqpa161azona, aqpa161aagencia, 
         aqpa161acuenta, aqpa161aope, aqpa161amod, aqpa161amoneda,  
         aqpa161afecges, aqpa161ahorges, aqpa161afeccom, aqpa161amoncom )
        
        select	p_c_Codusu,ln_Contador, 1, rownum,'C', trunc(CURRENT_DATE), to_char(CURRENT_DATE, 'HH24:MI:SS'),        
                trim(f.tp1desc) Region, trim(d.jaql964ren) Zona, trim(d.jaql964nom) Agencia, 
                d.jaql964cta Cuenta, d.jaql964ope Operacion, d.jaql964mod Modulo, c.Moneda,  
                TRUNC(c.FecGes) FecGes, to_char(c.FecGes, 'HH24:MI:SS' ) HorGes, to_date(c.FecCom,'DD/MM/YYYY'), c.Monto
        from (
        select trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito1/NumeroInstanciaCredito1/text()').GETSTRINGVAL()) NumIns, 
          trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito1/Moneda1/text()').GETSTRINGVAL()) Moneda,
          trunc(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS')) FecGes,
          to_char(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS'), 'HH24:MI:SS' ),
          (ExtractValue(Value(a), '/Compromiso/Fecha/text()')) FecCom, 
          (ExtractValue(Value(a), '/Compromiso/Monto/text()')) Monto
        FROM  TABLE(XMLSequence(Extract(XMLTYPE(p.aqpa156xml),'/Response/'||trim(p.aqpa156tipres)||'/PesCredito1/CompromisoCredito1/FormEditResponse/Compromiso/Compromiso'))) a
        ) c
        inner join jaql964 d on d.jaql964pai=604 and d.jaql964tid=p.aqpa156tipdoc
        and d.jaql964doc=p.aqpa156numdoc and d.jaql964ins=c.NumIns
        inner join fst811 e on e.oficod = d.jaql964suc and e.regcod < 100 and e.regcod > 0 and e.ofisuc = 'S'
        inner join fst198 f on f.tp1cod = 1 and f.tp1cod1 = 10872 and f.tp1corr1 = 11 and f.tp1nro2 = e.regcod    
        
        union all
        
        select	p_c_Codusu,ln_Contador, 2, rownum,'C', trunc(CURRENT_DATE), to_char(CURRENT_DATE, 'HH24:MI:SS'),        
        trim(f.tp1desc) Region, trim(d.jaql964ren) Zona, trim(d.jaql964nom) Agencia, 
        d.jaql964cta Cuenta, d.jaql964ope Operacion, d.jaql964mod Modulo, c.Moneda,  
        TRUNC(c.FecGes) FecGes, to_char(c.FecGes, 'HH24:MI:SS' ) HorGes, to_date(c.FecCom,'DD/MM/YYYY'), c.Monto
        from (
        select trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito2/NumeroInstanciaCredito2/text()').GETSTRINGVAL()) NumIns, 
          trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito2/Moneda2/text()').GETSTRINGVAL()) Moneda,
          trunc(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS')) FecGes,
          to_char(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS'), 'HH24:MI:SS' ),
          (ExtractValue(Value(a), '/Compromiso/Fecha/text()')) FecCom, 
          (ExtractValue(Value(a), '/Compromiso/Monto/text()')) Monto
        FROM  TABLE(XMLSequence(Extract(XMLTYPE(p.aqpa156xml),'/Response/'||trim(p.aqpa156tipres)||'/PesCredito2/CompromisoCredito2/FormEditResponse/Compromiso/Compromiso'))) a
        ) c
        inner join jaql964 d on d.jaql964pai=604 and d.jaql964tid=p.aqpa156tipdoc
        and d.jaql964doc=p.aqpa156numdoc and d.jaql964ins=c.NumIns
        inner join fst811 e on e.oficod = d.jaql964suc and e.regcod < 100 and e.regcod > 0 and e.ofisuc = 'S'
        inner join fst198 f on f.tp1cod = 1 and f.tp1cod1 = 10872 and f.tp1corr1 = 11 and f.tp1nro2 = e.regcod
        
        union all
        
        select	p_c_Codusu, ln_Contador, 3, rownum,'C', trunc(CURRENT_DATE), to_char(CURRENT_DATE, 'HH24:MI:SS'),        
        trim(f.tp1desc) Region, trim(d.jaql964ren) Zona, trim(d.jaql964nom) Agencia, 
        d.jaql964cta Cuenta, d.jaql964ope Operacion, d.jaql964mod Modulo, c.Moneda,  
        TRUNC(c.FecGes) FecGes, to_char(c.FecGes, 'HH24:MI:SS' ) HorGes, to_date(c.FecCom,'DD/MM/YYYY'), c.Monto
        from (
        select trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito3/NumeroInstanciaCredito3/text()').GETSTRINGVAL()) NumIns, 
          trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito3/Moneda3/text()').GETSTRINGVAL()) Moneda,
          trunc(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS')) FecGes,
          to_char(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS'), 'HH24:MI:SS' ),
          (ExtractValue(Value(a), '/Compromiso/Fecha/text()')) FecCom, 
          (ExtractValue(Value(a), '/Compromiso/Monto/text()')) Monto
        FROM  TABLE(XMLSequence(Extract(XMLTYPE(p.aqpa156xml),'/Response/'||trim(p.aqpa156tipres)||'/PesCredito3/CompromisoCredito3/FormEditResponse/Compromiso/Compromiso'))) a
        ) c
        inner join jaql964 d on d.jaql964pai=604 and d.jaql964tid=p.aqpa156tipdoc
        and d.jaql964doc=p.aqpa156numdoc and d.jaql964ins=c.NumIns
        inner join fst811 e on e.oficod = d.jaql964suc and e.regcod < 100 and e.regcod > 0 and e.ofisuc = 'S'
        inner join fst198 f on f.tp1cod = 1 and f.tp1cod1 = 10872 and f.tp1corr1 = 11 and f.tp1nro2 = e.regcod        
        union all
          
        select	p_c_Codusu, ln_Contador, 4, rownum,'C', trunc(CURRENT_DATE), to_char(CURRENT_DATE, 'HH24:MI:SS'),        
        trim(f.tp1desc) Region, trim(d.jaql964ren) Zona, trim(d.jaql964nom) Agencia, 
        d.jaql964cta Cuenta, d.jaql964ope Operacion, d.jaql964mod Modulo, c.Moneda,  
        TRUNC(c.FecGes) FecGes, to_char(c.FecGes, 'HH24:MI:SS' ) HorGes, to_date(c.FecCom,'DD/MM/YYYY'), c.Monto
        from (
        select trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito4/NumeroInstanciaCredito4/text()').GETSTRINGVAL()) NumIns, 
          trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito4/Moneda4/text()').GETSTRINGVAL()) Moneda,
          trunc(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS')) FecGes,
          to_char(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS'), 'HH24:MI:SS' ),
          (ExtractValue(Value(a), '/Compromiso/Fecha/text()')) FecCom, 
          (ExtractValue(Value(a), '/Compromiso/Monto/text()')) Monto
        FROM  TABLE(XMLSequence(Extract(XMLTYPE(p.aqpa156xml),'/Response/'||trim(p.aqpa156tipres)||'/PesCredito4/CompromisoCredito4/FormEditResponse/Compromiso/Compromiso'))) a
        ) c
        inner join jaql964 d on d.jaql964pai=604 and d.jaql964tid=p.aqpa156tipdoc
        and d.jaql964doc=p.aqpa156numdoc and d.jaql964ins=c.NumIns
        inner join fst811 e on e.oficod = d.jaql964suc and e.regcod < 100 and e.regcod > 0 and e.ofisuc = 'S'
        inner join fst198 f on f.tp1cod = 1 and f.tp1cod1 = 10872 and f.tp1corr1 = 11 and f.tp1nro2 = e.regcod        
        
        union all          
        
        select	p_c_Codusu, ln_Contador, 5, rownum,'C', trunc(CURRENT_DATE), to_char(CURRENT_DATE, 'HH24:MI:SS'),        
        trim(f.tp1desc) Region, trim(d.jaql964ren) Zona, trim(d.jaql964nom) Agencia, 
        d.jaql964cta Cuenta, d.jaql964ope Operacion, d.jaql964mod Modulo, c.Moneda,  
        TRUNC(c.FecGes) FecGes, to_char(c.FecGes, 'HH24:MI:SS' ) HorGes, to_date(c.FecCom,'DD/MM/YYYY'), c.Monto
        from (
        select trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito5/NumeroInstanciaCredito5/text()').GETSTRINGVAL()) NumIns, 
          trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito5/Moneda5/text()').GETSTRINGVAL()) Moneda,
          trunc(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS')) FecGes,
          to_char(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS'), 'HH24:MI:SS' ),
          (ExtractValue(Value(a), '/Compromiso/Fecha/text()')) FecCom, 
          (ExtractValue(Value(a), '/Compromiso/Monto/text()')) Monto
        FROM  TABLE(XMLSequence(Extract(XMLTYPE(p.aqpa156xml),'/Response/'||trim(p.aqpa156tipres)||'/PesCredito5/CompromisoCredito5/FormEditResponse/Compromiso/Compromiso'))) a
        ) c
        inner join jaql964 d on d.jaql964pai=604 and d.jaql964tid=p.aqpa156tipdoc
        and d.jaql964doc=p.aqpa156numdoc and d.jaql964ins=c.NumIns
        inner join fst811 e on e.oficod = d.jaql964suc and e.regcod < 100 and e.regcod > 0 and e.ofisuc = 'S'
        inner join fst198 f on f.tp1cod = 1 and f.tp1cod1 = 10872 and f.tp1corr1 = 11 and f.tp1nro2 = e.regcod
        
        union all          
        
        select	p_c_Codusu, ln_Contador, 6, rownum,'C', trunc(CURRENT_DATE), to_char(CURRENT_DATE, 'HH24:MI:SS'),        
        trim(f.tp1desc) Region, trim(d.jaql964ren) Zona, trim(d.jaql964nom) Agencia, 
        d.jaql964cta Cuenta, d.jaql964ope Operacion, d.jaql964mod Modulo, c.Moneda,  
        TRUNC(c.FecGes) FecGes, to_char(c.FecGes, 'HH24:MI:SS' ) HorGes, to_date(c.FecCom,'DD/MM/YYYY'), c.Monto
        from (
        select trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito6/NumeroInstanciaCredito6/text()').GETSTRINGVAL()) NumIns, 
          trim(XMLTYPE(p.aqpa156XML).EXTRACT('/Response/'||trim(p.aqpa156tipres)||'/PesCredito6/Moneda6/text()').GETSTRINGVAL()) Moneda,
          trunc(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS')) FecGes,
          to_char(to_date(trim(ExtractValue(XMLTYPE(p.aqpa156XML), '/Response/@FinalDate')),'YYYYMMDD HH24:MI:SS'), 'HH24:MI:SS' ),
          (ExtractValue(Value(a), '/Compromiso/Fecha/text()')) FecCom, 
          (ExtractValue(Value(a), '/Compromiso/Monto/text()')) Monto
        FROM  TABLE(XMLSequence(Extract(XMLTYPE(p.aqpa156xml),'/Response/'||trim(p.aqpa156tipres)||'/PesCredito6/CompromisoCredito6/FormEditResponse/Compromiso/Compromiso'))) a
        ) c
        inner join jaql964 d on d.jaql964pai=604 and d.jaql964tid=p.aqpa156tipdoc
        and d.jaql964doc=p.aqpa156numdoc and d.jaql964ins=c.NumIns
        inner join fst811 e on e.oficod = d.jaql964suc and e.regcod < 100 and e.regcod > 0 and e.ofisuc = 'S'
        inner join fst198 f on f.tp1cod = 1 and f.tp1cod1 = 10872 and f.tp1corr1 = 11 and f.tp1nro2 = e.regcod
        ;                               
        ln_Contador := ln_Contador+1;
      end loop;
      commit;
  EXCEPTION
    WHEN OTHERS THEN
      p_c_error := sqlerrm;
end sp_reporte_compromisos;
end pq_cn_formik;
/

