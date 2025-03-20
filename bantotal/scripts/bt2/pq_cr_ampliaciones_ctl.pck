create or replace package pq_cr_ampliaciones_ctl is
  -- *****************************************************************
  -- Nombre                     : pq_cr_ampliaciones_ctl 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2021.05.21
  -- Autor de Creación          : DCASTRO
  -- Uso                        : CONTROL AMPLIACIONES - AQPB264
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de Modificación      : 
  -- Descripción de Modificación: 
  --
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure  sp_es_ampliacion (pn_instancia  in number,
                              pc_ind out varchar2);
      
procedure  sp_es_ampliacion_dni (pn_instancia  in number,
                                 pc_ind out varchar2); 
                              
end pq_cr_ampliaciones_ctl;
/

create or replace package body pq_cr_ampliaciones_ctl is


procedure  sp_es_ampliacion (pn_instancia  in number,
                             pc_ind out varchar2) is
 
pc_varchar2 varchar2(1);
 pn_emp fsd010.pgcod%type;      
 pn_suc fsd010.aosuc%type;
 pn_mod fsd010.aomod%type;
 pn_mda fsd010.aomda%type;
 pn_pap fsd010.aopap%type;
 pn_cta fsd010.aocta%type;
 pn_ope fsd010.aooper%type;
 pn_sbo fsd010.aosbop%type;
 pn_top fsd010.aotope%type;
 ld_fecha date;
 lc_coderr varchar2(100);
 lc_msgerr varchar2(100);
                     
Begin
  pc_ind  := 'N';

    --obtener credito nuevo
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 <> '1';
    exception
      when others then
        pc_ind := 'N';
    end;

    ---obtiene maxima fecha
    begin
       select max(a.aqpb264fec)
        into ld_fecha
        from aqpb264 a;
    end;
    --buscar credito a ampliar en aqpb264
    begin
      select 'S'
        into pc_ind
        from aqpb264 a
       where a.aqpb264emp = pn_emp
         and a.aqpb264mod = pn_mod
         and a.aqpb264suc = pn_suc 
         and a.aqpb264mda = pn_mda
         and a.aqpb264pap = pn_pap
         and a.aqpb264cta = pn_cta
         and a.aqpb264ope = pn_ope
         and a.aqpb264sbo = pn_sbo
         and a.aqpb264tpo = pn_top
         and a.aqpb264fec = ld_fecha
         and a.aqpb264est = 'S';
    exception when others then
         lc_coderr := sqlcode;
         lc_msgerr := sqlerrm;
         pc_ind := 'N';  
    end;
                              
end sp_es_ampliacion;

procedure  sp_es_ampliacion_dni (pn_instancia  in number,
                                 pc_ind out varchar2) is
 
 pc_varchar2 varchar2(1);
 pn_pais sng001.sng001pais%type;
 pn_tdoc sng001.sng001tdoc%type;
 pn_ndoc sng001.sng001ndoc%type;
 ld_fecha date;
                     
Begin
  pc_ind  := 'N';

    --obtener credito nuevo
    begin
      select x.sng001pais, x.sng001tdoc, x.sng001ndoc
        into pn_pais, pn_tdoc, pn_ndoc
        from sng001 x
       where x.sng001inst = pn_instancia;
    exception
      when others then
        pc_ind := 'N';
    end;

    ---obtiene maxima fecha
    begin
       select max(a.aqpb264dfec)
        into ld_fecha
        from aqpb264d a;
    end;
    --buscar credito a ampliar en aqpb264
    begin
      select 'S'
        into pc_ind
        from aqpb264d a
       where a.aqpb264dfec = ld_fecha
       and a.aqpb264dpai = pn_pais
       and a.aqpb264dtip = pn_tdoc
       and a.aqpb264ddoc = rpad(pn_ndoc,12,' ')
       and a.aqpb264dest = 'S';
    exception when others then
         pc_ind := 'N';  
    end;

        
                              
end sp_es_ampliacion_dni;



end pq_cr_ampliaciones_ctl;
/

