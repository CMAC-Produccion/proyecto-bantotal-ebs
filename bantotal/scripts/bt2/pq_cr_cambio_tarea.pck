create or replace package pq_cr_cambio_tarea is

  -- Author  : CCERPA
  -- Created : 26/03/2018 09:49:51 a.m.
  -- Purpose :

  --camibo de tarea
  procedure sp_cambiotarea(p_instancia in number,
                           p_tarea     in number,
                           p_respuesta out number);
  procedure sp_verificarexitencia(p_instancia in number,
                                  p_resptexit out number);
  procedure sp_fechahora(p_instancia in number, p_tarea out number);
  /*procedure sp_AprobarRechazar(
                                 pn_numins number,
                                 pc_accion varchar2,
                                 pc_codusu varchar2,
                                 pc_ipcelu varchar2,
                                 pc_imeieq varchar2,
                                 pc_texcom varchar2,
                                 pc_codrec varchar2);
  
  procedure sp_insertarListaNegra(pn_numins number,
                                    pc_texcom varchar2,
                                    pc_codrec varchar2);  */

  procedure sp_enviocorreo(p_instancia in number);
  procedure sp_enviocorreoRpta(p_instancia in number,p_mensajeCorreo in varchar2);
end pq_cr_cambio_tarea;
/

create or replace package body pq_cr_cambio_tarea is

  procedure sp_cambiotarea(p_instancia in number,
                           p_tarea     in number,
                           p_respuesta out number) is
  
    lc_usuario character(10);
    lc_sigapr  varchar2(30);
    lc_msgerr  varchar2(1000);
    ln_witmid  number;
  begin
  
    begin
      update wfwrkitems c
         set C.WFSTSCOD = 'C', C.WFITEMSTSACT = 0, C.WFITEMEND = SYSDATE
       where wfiteminit = (select max(wfiteminit)
                             from wfwrkitems cc
                            where cc.wfinsprcid = p_instancia);
    end;
  
    begin
      delete from WFWORKLIST f
       where f.wfwrklstitemid =
             (select max(c.wfitemid)
                from wfwrkitems c
               where c.wfinsprcid = p_instancia);
    end;
    begin
      update wfinstprc
         set wfinsprcsta = 'U', wfinsprcosta = 1, wfinsprcend = sysdate
       where wfinsprcid = p_instancia;
      commit;
    end;
  
    if p_tarea = 3 then
      --codigo
    
      begin
        select trim(sng001.sng001ase)
          into lc_usuario
          from sng001
         where sng001.sng001inst = p_instancia;
      exception
        when others then
          dbms_output.put_line('Tarea de solicitud');
          dbms_output.put_line(sqlerrm);
          lc_usuario := 'ERROR';
          return;
      end;
      begin
        INSERT INTO wfwrkitems
          (WFITEMID,
           WFINSPRCID,
           WFITEMUSRCOD,
           WFITEMROLCOD,
           WFTASKCOD,
           WFITEMINIT,
           WFITEMEND,
           WFSTSCOD,
           WFITEMSTSACT,
           WFITEMWRN,
           WFITEMDLN,
           WFITEMWRNTIME,
           WFITEMDLNTIME,
           WFITEMPRCURN,
           WFITEMPRVSTA,
           WFITEMPRVTASK,
           WFITEMPTY,
           WFPRCID)
          SELECT w1.WFITEMID,
                 w1.WFINSPRCID,
                 lc_usuario, --w1.WFITEMUSRCOD,
                 w1.WFITEMROLCOD,
                 7, --w1.WFTASKCOD,
                 sysdate,
                 to_date('01/01/0001', 'dd/mm/yyyy'),
                 'A',
                 1,
                 w1.WFITEMWRN,
                 w1.WFITEMDLN,
                 w1.WFITEMWRNTIME,
                 w1.WFITEMDLNTIME,
                 w1.WFITEMPRCURN,
                 'P',
                 3,
                 w1.WFITEMPTY,
                 w1.WFPRCID
            FROM wfwrkitems w1
           WHERE w1.wfinsprcid = p_instancia
             and w1.wfiteminit =
                 (select max(wfiteminit)
                    from wfwrkitems
                   where wfinsprcid = p_instancia);
        commit;
        p_respuesta := 1;
      exception
        when others then
          dbms_output.put_line('Tarea de solicitud');
          dbms_output.put_line(sqlerrm);
          p_respuesta := 0;
          return;
      end;
      begin
        --//
        select a.wfitemusrcod
          into lc_sigapr
          from wfwrkitems a
         where a.wfinsprcid = p_instancia
           and a.wfitemid = (select max(wfitemid)
                               from wfwrkitems
                              where wfinsprcid = p_instancia)
              
           and rownum <= 1
         order by a.wfitemid desc;
      
      exception
        when others then
          lc_msgerr := 'S-WFWI' || ' -  ' || sqlerrm;
      end;
    
      begin
        SELECT w1.WFITEMID
          into ln_witmid
          FROM wfwrkitems w1
         WHERE w1.wfinsprcid = p_instancia
           and w1.wfitemid =
               (select max(wfitemid)
                  from wfwrkitems
                 where wfinsprcid = p_instancia);
      exception
        when others then
          lc_msgerr := 'S-WFWI' || ' -  ' || sqlerrm;
      end;
      begin
        insert into WFWORKLIST
          (WFWRKLSTITEMID, WFWRKLSTUSRCOD, WFWRKLSTROLCOD)
        values
          (ln_witmid, lc_sigapr, -1);
        commit;
      exception
        when others then
        
          lc_msgerr := 'I-WFWL' || ' -  ' || sqlerrm;
      end;
      --codigo
    else
      if p_tarea = 7 then
        --codigo
        begin
          INSERT INTO wfwrkitems
            (WFITEMID,
             WFINSPRCID,
             WFITEMUSRCOD,
             WFITEMROLCOD,
             WFTASKCOD,
             WFITEMINIT,
             WFITEMEND,
             WFSTSCOD,
             WFITEMSTSACT,
             WFITEMWRN,
             WFITEMDLN,
             WFITEMWRNTIME,
             WFITEMDLNTIME,
             WFITEMPRCURN,
             WFITEMPRVSTA,
             WFITEMPRVTASK,
             WFITEMPTY,
             WFPRCID)
            SELECT w1.WFITEMID,
                   w1.WFINSPRCID,
                   '', --w1.WFITEMUSRCOD,
                   w1.WFITEMROLCOD,
                   11, --w1.WFTASKCOD,
                   sysdate,
                   to_date('01/01/0001', 'dd/mm/yyyy'),
                   'A',
                   1,
                   w1.WFITEMWRN,
                   w1.WFITEMDLN,
                   w1.WFITEMWRNTIME,
                   w1.WFITEMDLNTIME,
                   w1.WFITEMPRCURN,
                   w1.WFITEMPRVSTA,
                   7,
                   w1.WFITEMPTY,
                   w1.WFPRCID
              FROM wfwrkitems w1
             WHERE w1.wfinsprcid = p_instancia
               and w1.wfiteminit =
                   (select max(wfiteminit)
                      from wfwrkitems
                     where wfinsprcid = p_instancia);
          commit;
          p_respuesta := 1;
        exception
          when others then
            dbms_output.put_line('Tarea de Evaluacion Propuesta');
            dbms_output.put_line(sqlerrm);
            p_respuesta := 0;
            return;
        end;
        --codigo
      else
        if p_tarea = 11 then
          --codigo
          begin
            INSERT INTO wfwrkitems
              (WFITEMID,
               WFINSPRCID,
               WFITEMUSRCOD,
               WFITEMROLCOD,
               WFTASKCOD,
               WFITEMINIT,
               WFITEMEND,
               WFSTSCOD,
               WFITEMSTSACT,
               WFITEMWRN,
               WFITEMDLN,
               WFITEMWRNTIME,
               WFITEMDLNTIME,
               WFITEMPRCURN,
               WFITEMPRVSTA,
               WFITEMPRVTASK,
               WFITEMPTY,
               WFPRCID)
              SELECT w1.WFITEMID,
                     w1.WFINSPRCID,
                     '', --w1.WFITEMUSRCOD,
                     w1.WFITEMROLCOD,
                     55, --w1.WFTASKCOD,
                     sysdate,
                     to_date('01/01/0001', 'dd/mm/yyyy'),
                     'R',
                     1,
                     w1.WFITEMWRN,
                     w1.WFITEMDLN,
                     w1.WFITEMWRNTIME,
                     w1.WFITEMDLNTIME,
                     w1.WFITEMPRCURN,
                     w1.WFITEMPRVSTA,
                     11,
                     w1.WFITEMPTY,
                     w1.WFPRCID
                FROM wfwrkitems w1
               WHERE w1.wfinsprcid = p_instancia
                 and w1.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems
                       where wfinsprcid = p_instancia);
            commit;
            p_respuesta := 1;
          exception
            when others then
              dbms_output.put_line('Tarea de Aprobacion');
              dbms_output.put_line(sqlerrm);
              p_respuesta := 0;
              return;
          end;
          --codigo
        else
          p_respuesta := 0;
        end if;
      end if;
    end if;
  end sp_cambiotarea;

  procedure sp_verificarexitencia(p_instancia in number,
                                  p_resptexit out number) is
  
    pn_eva     number;
    pn_nro     number;
    pn_expbloq number;
  begin
    begin
      select fpae70.pae51eva, fpae70.pae70nro
        into pn_eva, pn_nro
        from fpae70
       where fpae70.pae70ins = p_instancia
         and fpae70.pae70time =
             (select max(fpae70.pae70time)
                from fpae70
               where fpae70.pae70ins = p_instancia);
    exception
      when others then
        pn_eva := 0;
        pn_nro := 0;
        return;
    end;
    if pn_eva <> 0 and pn_nro <> 0 then
      begin
        select /*+index(fpae73 SYS_C00976985)*/ count(*)
          into pn_expbloq
          from fpae73
         where fpae73.pae51eva = pn_eva
           and fpae73.pae70nro = pn_nro
           and fpae73.pae73tip = 'E';
      end;
    end if;
    if pn_expbloq = 0 then
      p_resptexit := 1;
    else
      if pn_expbloq > 0 then
        p_resptexit := 0;
      end if;
    end if;
  
  end sp_verificarexitencia;
  procedure sp_fechahora(p_instancia in number, p_tarea out number) is
  
  begin
    begin
    
      select JAQY596.JAQY596ETAP
        into p_tarea
        from JAQY596
       where JAQY596.JAQY596INST = p_instancia
         and JAQY596.JAQY596FECC =
             (select max(JAQY596.JAQY596FECC)
                from JAQY596
               where JAQY596.JAQY596INST = p_instancia)
         and JAQY596.JAQY596HORC =
             (select max(JAQY596.JAQY596HORC)
                from JAQY596
               where JAQY596.JAQY596INST = p_instancia
                 and JAQY596.JAQY596FECC =
                     (select max(JAQY596.JAQY596FECC)
                        from JAQY596
                       where JAQY596.JAQY596INST = p_instancia))
         and jaqy596.jaqy596esta = 'A'
         and rownum = 1;
    exception
      when others then
        p_tarea := -1;
        return;
    end;
  
  end sp_fechahora;

  procedure sp_enviocorreo(p_instancia in number) IS
  
    lv_mensaje VARCHAR2(2000);
  
    cursor c_garantias_usuario is
      SELECT CONCAT(TRIM(VALOR.VAL), '@cajaarequipa.pe') email
        FROM (SELECT distinct (fs.ubuser) VAL
                FROM prfu00 fs
               where fs.prfgcod IN (select fst198.tp1desc
                                      from fst198
                                     Where Tp1cod = 1
                                       and Tp1cod1 = 11105
                                       and Tp1corr1 = 2
                                       AND TP1CORR2 = 2)) VALOR;
  
  begin
    for i in c_garantias_usuario loop
    
      lv_mensaje := '<html><head><style type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
                    '</head><body><br><p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">Estimado.</p>' ||
                    '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                    'Tiene una bloqueante por aprobar de la instancia  ' ||
                    TO_CHAR(p_instancia) ||
                    '.</p> <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                    'Saludos</p></body></html>';
      sys.sp_sy_enviamail_html(pc_aquien  => i.email,
                               pc_de      => 'notificaciones@cajaarequipa.pe',
                               pc_motivo  => 'Autorizacion de Bloqueantes - Nueva Solicitud',
                               pc_mensaje => lv_mensaje);
    
    end loop;
  
  END sp_enviocorreo;

  procedure sp_enviocorreoRpta(p_instancia in number,p_mensajeCorreo in varchar2) IS
  
    lv_mensaje VARCHAR2(2000);
  
    cursor c_garantias_usuario is
      
      SELECT CONCAT(TRIM(sng057sup), '@cajaarequipa.pe') email
        from (select sng057sup
                from sng057
               where sng055emp = 1
                 and sng057usr in
                     (select sng001ase
                        from sng001
                       where sng001inst = p_instancia)
                 and sng057sup is not null
                 and trim(sng057sup) <> ' ')
      UNION
      SELECT CONCAT(TRIM(sng001ase), '@cajaarequipa.pe') email
        from (select sng001ase from sng001 where sng001inst = p_instancia)
      UNION
      SELECT CONCAT(TRIM(fs.UBUSER), '@cajaarequipa.pe') email
        FROM prfu00 fs, fst046 af
       where fs.prfgcod = 'GAGE01'
         and fs.ubuser = af.ubuser
         and ubsuc in (select sng001age from sng001 where sng001inst = p_instancia);
  
  begin
    for i in c_garantias_usuario loop
    
      lv_mensaje := '<html><head><style type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
                    '</head><body><br><p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">Estimado.</p>' ||
                    '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                    p_mensajeCorreo ||
                    '.</p> <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                    'Saludos</p></body></html>';
      sys.sp_sy_enviamail_html(pc_aquien  =>  i.email, 
                               pc_de      => 'notificaciones@cajaarequipa.pe',
                               pc_motivo  => 'Autorizacion de Bloqueantes',
                               pc_mensaje => lv_mensaje);
    end loop;
  
  END sp_enviocorreoRpta;
end pq_cr_cambio_tarea;
/

