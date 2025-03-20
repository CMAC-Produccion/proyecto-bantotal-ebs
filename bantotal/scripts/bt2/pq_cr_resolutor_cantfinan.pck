create or replace package pq_cr_resolutor_cantfinan is

  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA EVALUAR Y OBTENER EL RATIO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2017.10.11
  -- Autor de Creación          : CRISTHIAN CERPA
  -- Uso                        : Realiza cálculos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :

  -- *****************************************************************
  Procedure sp_cr_cantidadproductos(ln_intancia in number,
                                    respuesta   out number);
  ------------------------------------------                                    
  Procedure sp_cr_cantidadprodcursos(pn_pais      in number,
                                     pn_tdoc      in number,
                                     pc_ndoc      in character,
                                     pn_mod       in number,
                                     pn_instancia in number,
                                     pn_flag      in number,
                                     respuesta    out number);

  --------------------------------------------
  procedure sp_cr_ClienteMicro(ln_Instancia   in number,
                               ln_CTSupMujer  out number,
                               ln_AFSupMujer  out number,
                               ln_CTCredPunt  out number,
                               ln_AFCredPunt  out number,
                               ln_AFCrediOf   out number,
                               ln_CTCrediOf   out number,
                               ln_AFBienvnd   out number,
                               ln_CTBienvnd   out number,
                               ln_AFEmprenddr out number,
                               ln_CTEmprenddr out number);
  -------------------------------------------------                               
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2);
  --------------------------------------------         
  procedure sp_cr_RefiReproLinea(ln_pgcod10  in number,
                                 ln_mod10    in number,
                                 ln_suc10    in number,
                                 ln_mda10    in number,
                                 ln_pap10    in number,
                                 ln_cta10    in number,
                                 ln_oper10   in number,
                                 lc_fgRefLin out varchar2);

end pq_cr_resolutor_cantfinan;
/

create or replace package body pq_cr_resolutor_cantfinan is
  -- *****************************************************************
  -- Nombre                     : sp_resultadonetolinea
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          :
  -- Autor de Creación          : CRISTHIAN CERPA
  -- Uso                        : EVALUA EL OTORGAMIENTO DEUN CREDITO HIPOTECARIO cAJA.
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************

  ---------------------------------------------------------------------------------------

  Procedure sp_cr_cantidadprodcursos(pn_pais      in number,
                                     pn_tdoc      in number,
                                     pc_ndoc      in character,
                                     pn_mod       in number,
                                     pn_instancia in number,
                                     pn_flag      in number,
                                     respuesta    out number) is
  
    --evaluarcardif  number;
    condwfwritem1  number;
    condsng122     number;
    condfsd010cont number;
    --xwf700noconsiderar number := 0;
    --fsd010noconsiderar number := 0;
    --wfwrkitemsnoconsiderar number := 0;
    soloconsiderar number := 0;
    contador       number := 0;
    --sng122noconsiderar     number := 0;
  
    cursor c_total_instancias is
      select distinct XWF700.XWFEMPRESA,
                      XWF700.XWFSUCURSAL,
                      XWF700.XWFMODULO,
                      XWF700.XWFMONEDA,
                      XWF700.XWFPAPEL,
                      XWF700.XWFCUENTA,
                      XWF700.XWFOPERACION,
                      XWF700.XWFSUBOPE,
                      XWF700.XWFTIPOPE,
                      XWF700.XWFCAR3,
                      max(XWF700.xwfprcins) ln_Instancia
        from sng001
       inner join xwf700
          on sng001.sng001inst = xwf700.xwfprcins
       where sng001.sng001pais = pn_pais
         and sng001.sng001tdoc = pn_tdoc
         and sng001.sng001ndoc = pc_ndoc
         and xwf700.xwfmodulo = pn_mod
         and xwf700.xwfcar3 = '1'
         and sng001.sng001inst not in (pn_instancia)
       group by XWF700.XWFEMPRESA,
                XWF700.XWFSUCURSAL,
                XWF700.XWFMODULO,
                XWF700.XWFMONEDA,
                XWF700.XWFPAPEL,
                XWF700.XWFCUENTA,
                XWF700.XWFOPERACION,
                XWF700.XWFSUBOPE,
                XWF700.XWFTIPOPE,
                XWF700.XWFCAR3;
  
  begin
    if pn_flag = 1 then
      begin
      
        for item in c_total_instancias loop
          contador   := contador + 1;
          condsng122 := 0;
        
          begin
            -- Verifica si el credito esta vigente
            select count(*)
              into condfsd010cont
              from fsd010
             where fsd010.pgcod = item.xwfempresa
               and fsd010.aomod = item.xwfmodulo
               and fsd010.aosuc = item.xwfsucursal
               and fsd010.aomda = item.xwfmoneda
               and fsd010.aopap = item.xwfpapel
               and fsd010.aocta = item.xwfcuenta
               and fsd010.aooper = item.xwfoperacion
               and fsd010.aosbop = item.xwfsubope
               and fsd010.aotope = item.xwftipope
               and fsd010.aostat <> 99;
          end;
          if condfsd010cont <> 0 then
            --fsd010noconsiderar:=fsd010noconsiderar+1;
          
            begin
              select count(*)
                into condsng122
                from sng122
               where sng122.sng122inst = item.ln_Instancia
                 and sng122.sng122tope in
                     (select fst198.tp1nro1
                        from fst198
                       where fst198.tp1cod = 1
                         and fst198.tp1cod1 = 11108
                         and fst198.tp1corr1 = 3);
            end;
            if condsng122 = 0 then
              soloconsiderar := soloconsiderar + 1;
            end if;
          else
          
            begin
              select count(*)
                into condwfwritem1
                from wfwrkitems
               where wfwrkitems.wfinsprcid = item.ln_Instancia
                 and wfwrkitems.wfitemstsact = 1;
            end;
            if condwfwritem1 = 1 then
              --   wfwrkitemsnoconsiderar:=wfwrkitemsnoconsiderar+1;
              begin
                select count(*)
                  into condsng122
                  from sng122
                 where sng122.sng122inst = item.ln_Instancia
                   and sng122.sng122tope in
                       (select fst198.tp1nro1
                          from fst198
                         where fst198.tp1cod = 1
                           and fst198.tp1cod1 = 11108
                           and fst198.tp1corr1 = 3);
              end;
              if condsng122 = 0 then
                soloconsiderar := soloconsiderar + 1;
              end if; -- soloconsiderar :=soloconsiderar+1; 
            
            end if;
            -- end if;
          end if;
        end loop;
      end;
      respuesta := soloconsiderar;
    
    end if;
  end sp_cr_cantidadprodcursos;
  ---------------------------------------------------------------------------------------
  Procedure sp_cr_cantidadproductos(ln_intancia in number,
                                    respuesta   out number) is
  
    pn_modulo  number;
    pn_contmod number;
    pn_tdoc    number;
    pc_ndoc    character(12);
    pn_pais    number;
    pn_paisII  number;
    pn_tdocII  number;
    pc_ndocII  character(12);
    respuesta1 number := 0;
    respuesta2 number := 0;
  
  begin
    begin
      select xwf700.xwfmodulo
        into pn_modulo
        from xwf700
       where xwf700.xwfprcins = ln_intancia
         and xwf700.xwfcar3 = '1'
         and rownum = 1; ---03/08/2018
    exception
      when others then
        pn_modulo := 0; ---03/08/2018 
    end;
    begin
      select count(x.xwfmodulo)
        into pn_contmod
        from xwf700 x
       where x.xwfprcins = ln_intancia
         and x.xwfcar3 = '1';
    end;
    if pn_contmod <> 0 then
    
      begin
      
        select s.sng001pais, s.sng001tdoc, s.sng001ndoc
          into pn_pais, pn_tdoc, pc_ndoc
          from sng001 s
         where s.sng001inst = ln_intancia;
      exception
        ---03/08/2018
        when others then
          pn_pais := 0;
          pn_tdoc := 0;
          pc_ndoc := '0'; ---03/08/2018
      end;
    
      begin
        -- MPOSTIGOC 16/07/18      
        -- Datos del Conyugue
        select f.rppais, f.rptdoc, f.rpndoc
          into pn_paisII, pn_tdocII, pc_ndocII
          from fsr002 f
         where f.pepais = pn_pais
           and f.petdoc = pn_tdoc
           and f.pendoc = pc_ndoc
           and f.rpccyg = 66;
      exception
        when others then
          null;
        
      end;
    
      pq_cr_resolutor_cantfinan.sp_cr_cantidadprodcursos(pn_pais,
                                                         pn_tdoc,
                                                         pc_ndoc,
                                                         pn_modulo,
                                                         ln_intancia,
                                                         1,
                                                         respuesta1);
      if pn_paisII is not null then
        -- MPOSTIGOC 16/07/18
        pq_cr_resolutor_cantfinan.sp_cr_cantidadprodcursos(pn_paisII,
                                                           pn_tdocII,
                                                           pc_ndocII,
                                                           pn_modulo,
                                                           ln_intancia,
                                                           1,
                                                           respuesta2);
      end if;
    
      respuesta := respuesta1 + respuesta2;
    
    end if;
  
  end sp_cr_cantidadproductos;

  -------------------------------------
  --MPOSTIGOC 16/07/18
  procedure sp_cr_ClienteMicro(ln_Instancia   in number,
                               ln_CTSupMujer  out number,
                               ln_AFSupMujer  out number,
                               ln_CTCredPunt  out number,
                               ln_AFCredPunt  out number,
                               ln_AFCrediOf   out number,
                               ln_CTCrediOf   out number,
                               ln_AFBienvnd   out number,
                               ln_CTBienvnd   out number,
                               ln_AFEmprenddr out number,
                               ln_CTEmprenddr out number) is
  
    cursor lista_credvig(ln_pais number, ln_tdoc number, lc_doc varchar2) is
    
      select r.pgcod  ln_pgcod,
             r.aomod  ln_modulo,
             r.aosuc  ln_sucursal,
             r.aomda  ln_moneda,
             r.aopap  ln_papel,
             r.aocta  ln_cuenta,
             r.aooper ln_operacion,
             r.aosbop ln_suboperacion,
             r.aotope ln_tipoperacion
        from fsd010 r
       where r.pgcod = 1
         and r.aomod = 103
         and r.aocta in (select ctnro
                           from fsr008 f
                          where f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_doc)
         and r.aostat <> 99
      union
      select r.pgcod  ln_pgcod,
             r.aomod  ln_modulo,
             r.aosuc  ln_sucursal,
             r.aomda  ln_moneda,
             r.aopap  ln_papel,
             r.aocta  ln_cuenta,
             r.aooper ln_operacion,
             r.aosbop ln_suboperacion,
             r.aotope ln_tipoperacion
        from fsr008 a, fsd010 r, fsr002 c
       where r.pgcod = 1
         and r.aomod = 103
         and c.pepais = ln_pais
         and c.petdoc = ln_tdoc
         and c.pendoc = lc_doc
         and r.aostat <> 99
         and a.ctnro = r.aocta
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor lista_CredVuelo(ln_pais number, ln_tdoc number, lc_doc varchar2) is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10
        from xwf700 x
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_pais
                                and Petdoc = ln_tdoc
                                and pendoc = lc_doc)
            
         and x.xwfmodulo = 103
            
         and (x.XWFPRCINS in
             (select wfinsprcid
                 from wfwrkitems wf
                where wf.wfinsprcid = x.xwfprcins
                  and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                  and wf.wfiteminit =
                      (select max(wfiteminit)
                         from wfwrkitems w
                        where w.wfinsprcid = x.xwfprcins
                          and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                          and w.wfitemstsact = 1
                          and w.wfiteminit >=
                              to_date('2013.07.01', 'yyyy.mm.dd')) --20160519                     
                  and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) /*and
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     x.xwfprcins not in ln_Instancia*/
             ) --20160519
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope
      union
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10
        from xwf700 x, fsr002 c, fsr008 a
       where x.xwfempresa = 1
         and c.pepais = ln_pais
         and c.petdoc = ln_tdoc
         and c.pendoc = lc_doc
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and x.xwfmodulo = 103
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope;
  
    lc_FlagExiste varchar2(2) := 'N';
    ln_pais       number;
    ln_tdoc       number;
    lc_doc        varchar2(12);
  
    ln_SuperMujer     number := 0;
    ln_CredPuntual    number := 0;
    ln_CredOficioExt  number := 0;
    lc_FlagAmp        varchar2(2) := 'N';
    lc_FlagRefRepr    varchar2(2) := 'N';
    ln_CredBienvAux   number := 0;
    ln_CredEmprendAux number := 0;
  
  begin
  
    begin
      -- Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_doc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    ln_CTSupMujer := 0;
    ln_AFSupMujer := 0;
    ln_CTCredPunt := 0;
    ln_AFCredPunt := 0;
    --ln_CrediOficio := 0;
    ln_AFCrediOf   := 0;
    ln_CTCrediOf   := 0;
    ln_AFBienvnd   := 0;
    ln_CTBienvnd   := 0;
    ln_AFEmprenddr := 0;
    ln_CTEmprenddr := 0;
  
    for cv in lista_credvig(ln_pais, ln_tdoc, lc_doc) loop
    
      pq_cr_resolutor_cantfinan.Sp_ampliados_CK(ln_emp10  => cv.ln_pgcod,
                                                ln_mod10  => cv.ln_modulo,
                                                ln_suc10  => cv.ln_sucursal,
                                                ln_mda10  => cv.ln_moneda,
                                                ln_pap10  => cv.ln_papel,
                                                ln_cta10  => cv.ln_cuenta,
                                                ln_oper10 => cv.ln_operacion,
                                                ln_sbop10 => cv.ln_suboperacion,
                                                ln_tope10 => cv.ln_tipoperacion,
                                                Pc_flag   => lc_FlagAmp);
    
      pq_cr_resolutor_cantfinan.sp_cr_RefiReproLinea(ln_pgcod10  => cv.ln_pgcod,
                                                     ln_mod10    => cv.ln_modulo,
                                                     ln_suc10    => cv.ln_sucursal,
                                                     ln_mda10    => cv.ln_moneda,
                                                     ln_pap10    => cv.ln_papel,
                                                     ln_cta10    => cv.ln_cuenta,
                                                     ln_oper10   => cv.ln_operacion,
                                                     lc_fgRefLin => lc_FlagRefRepr);
    
      if lc_FlagAmp = 'N' and lc_FlagRefRepr = 'N' then
      
        begin
          select 'S'
            into lc_FlagExiste
            from fst198 g
           where g.tp1cod = 1
             and g.tp1cod1 = 11108
             and g.tp1corr1 = 4
             and g.tp1nro2 = cv.ln_modulo
             and g.tp1nro3 = cv.ln_tipoperacion;
        exception
          when others then
            lc_FlagExiste := 'N';
          
        end;
      
        if lc_FlagExiste = 'S' then
          begin
            -- Superate Mujer
            select g.tp1imp1
              into ln_SuperMujer
              from fst198 g
             where g.tp1cod = 1
               and g.tp1cod1 = 11108
               and g.tp1corr1 = 4
               and g.tp1corr2 = 1
               and g.tp1nro2 = cv.ln_modulo
               and g.tp1nro3 = cv.ln_tipoperacion;
          exception
            when others then
              ln_SuperMujer := 0;
          end;
        
          begin
            -- CrediPuntualito
            select g.tp1imp1
              into ln_CredPuntual
              from fst198 g
             where g.tp1cod = 1
               and g.tp1cod1 = 11108
               and g.tp1corr1 = 4
               and g.tp1corr2 = 2
               and g.tp1nro2 = cv.ln_modulo
               and g.tp1nro3 = cv.ln_tipoperacion;
          exception
            when others then
              ln_CredPuntual := 0;
          end;
        
          begin
            -- CrediOficios
            select g.tp1imp1
              into ln_CredOficioExt
              from fst198 g
             where g.tp1cod = 1
               and g.tp1cod1 = 11108
               and g.tp1corr1 = 4
               and g.tp1corr2 = 3
               and g.tp1nro2 = cv.ln_modulo
               and g.tp1nro3 = cv.ln_tipoperacion;
          exception
            when others then
              ln_CredOficioExt := 0;
          end;
        
          begin
            -- Bienvenido
            select g.tp1imp1
              into ln_CredBienvAux
              from fst198 g
             where g.tp1cod = 1
               and g.tp1cod1 = 11108
               and g.tp1corr1 = 4
               and g.tp1corr2 = 4
               and g.tp1nro2 = cv.ln_modulo
               and g.tp1nro3 = cv.ln_tipoperacion;
          exception
            when others then
              null;
          end;
        
          begin
            -- Emprendedor
            select g.tp1imp1
              into ln_CredEmprendAux
              from fst198 g
             where g.tp1cod = 1
               and g.tp1cod1 = 11108
               and g.tp1corr1 = 4
               and g.tp1corr2 = 5
               and g.tp1nro2 = cv.ln_modulo
               and g.tp1nro3 = cv.ln_tipoperacion;
          exception
            when others then
              null;
            
          end;
        
          if ln_SuperMujer <> 0 then
          
            if ln_SuperMujer = 1 then
              ln_AFSupMujer := ln_AFSupMujer + 1;
            else
              ln_CTSupMujer := ln_CTSupMujer + 1;
            end if;
          
          else
            if ln_CredPuntual <> 0 then
            
              if ln_CredPuntual = 1 then
                ln_AFCredPunt := ln_AFCredPunt + 1;
              else
                ln_CTCredPunt := ln_CTCredPunt + 1;
              end if;
            
            else
              if ln_CredOficioExt <> 0 then
                -- ln_CrediOficio := ln_CrediOficio + 1;
                if ln_CredOficioExt = 1 then
                  ln_AFCrediOf := ln_AFCrediOf + 1;
                else
                  ln_CTCrediOf := ln_CTCrediOf + 1;
                end if;
              
              else
                if ln_CredBienvAux <> 0 then
                  if ln_CredBienvAux = 1 then
                    ln_AFBienvnd := ln_AFBienvnd + 1;
                  else
                    ln_CTBienvnd := ln_CTBienvnd + 1;
                  end if;
                
                else
                  if ln_CredEmprendAux <> 0 then
                    if ln_CredEmprendAux = 1 then
                      ln_AFEmprenddr := ln_AFEmprenddr + 1;
                    else
                      ln_CTEmprenddr := ln_CTEmprenddr + 1;
                    end if;
                  
                  end if;
                end if;
              
              end if;
            
            end if;
          
          end if;
        
        end if;
      
      end if;
    
    end loop;
  
    for cvl in lista_CredVuelo(ln_pais, ln_tdoc, lc_doc) loop
    
      begin
        select 'S'
          into lc_FlagExiste
          from fst198 g
         where g.tp1cod = 1
           and g.tp1cod1 = 11108
           and g.tp1corr1 = 4
           and g.tp1nro2 = cvl.ln_mod10
           and g.tp1nro3 = cvl.ln_tope10;
      exception
        when others then
          lc_FlagExiste := 'N';
      end;
    
      if lc_FlagExiste = 'S' then
        begin
          -- Superate Mujer
          select g.tp1imp1
            into ln_SuperMujer
            from fst198 g
           where g.tp1cod = 1
             and g.tp1cod1 = 11108
             and g.tp1corr1 = 4
             and g.tp1corr2 = 1
             and g.tp1nro2 = cvl.ln_mod10
             and g.tp1nro3 = cvl.ln_tope10;
        exception
          when others then
            ln_SuperMujer := 0;
        end;
      
        begin
          -- CrediPuntualito
          select g.tp1imp1
            into ln_CredPuntual
            from fst198 g
           where g.tp1cod = 1
             and g.tp1cod1 = 11108
             and g.tp1corr1 = 4
             and g.tp1corr2 = 2
             and g.tp1nro2 = cvl.ln_mod10
             and g.tp1nro3 = cvl.ln_tope10;
        exception
          when others then
            ln_CredPuntual := 0;
        end;
      
        begin
          -- CrediOficios
          select g.tp1imp1
            into ln_CredOficioExt
            from fst198 g
           where g.tp1cod = 1
             and g.tp1cod1 = 11108
             and g.tp1corr1 = 4
             and g.tp1corr2 = 3
             and g.tp1nro2 = cvl.ln_mod10
             and g.tp1nro3 = cvl.ln_tope10;
        exception
          when others then
            ln_CredOficioExt := 0;
        end;
      
        begin
          -- Bienvenido
          select g.tp1imp1
            into ln_CredBienvAux
            from fst198 g
           where g.tp1cod = 1
             and g.tp1cod1 = 11108
             and g.tp1corr1 = 4
             and g.tp1corr2 = 4
             and g.tp1nro2 = cvl.ln_mod10
             and g.tp1nro3 = cvl.ln_tope10;
        exception
          when others then
            null;
        end;
      
        begin
          -- Emprendedor
          select g.tp1imp1
            into ln_CredEmprendAux
            from fst198 g
           where g.tp1cod = 1
             and g.tp1cod1 = 11108
             and g.tp1corr1 = 4
             and g.tp1corr2 = 5
             and g.tp1nro2 = cvl.ln_mod10
             and g.tp1nro3 = cvl.ln_tope10;
        exception
          when others then
            null;
          
        end;
      
        if ln_SuperMujer <> 0 then
        
          if ln_SuperMujer = 1 then
            ln_AFSupMujer := ln_AFSupMujer + 1;
          else
            ln_CTSupMujer := ln_CTSupMujer + 1;
          end if;
        
        else
          if ln_CredPuntual <> 0 then
          
            if ln_CredPuntual = 1 then
              ln_AFCredPunt := ln_AFCredPunt + 1;
            else
              ln_CTCredPunt := ln_CTCredPunt + 1;
            end if;
          
          else
            if ln_CredOficioExt <> 0 then
              -- ln_CrediOficio := ln_CrediOficio + 1;
              if ln_CredOficioExt = 1 then
                ln_AFCrediOf := ln_AFCrediOf + 1;
              else
                ln_CTCrediOf := ln_CTCrediOf + 1;
              end if;
            
            else
              if ln_CredBienvAux <> 0 then
                if ln_CredBienvAux = 1 then
                  ln_AFBienvnd := ln_AFBienvnd + 1;
                else
                  ln_CTBienvnd := ln_CTBienvnd + 1;
                end if;
              
              else
                if ln_CredEmprendAux <> 0 then
                  if ln_CredEmprendAux = 1 then
                    ln_AFEmprenddr := ln_AFEmprenddr + 1;
                  else
                    ln_CTEmprenddr := ln_CTEmprenddr + 1;
                  end if;
                
                end if;
              end if;
            end if;
          
          end if;
        end if;
      end if;
    
    end loop;
  
  end sp_cr_ClienteMicro;
  -------------------------------------
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2) is --mod 2016.04.12
  
  begin
  
    begin
    
      select 'S'
        into Pc_flag
        from xwf700 a, sng001 s /* xwf070 w,*/, wfwrkitems x
       where a.xwfempresa = ln_emp10
         and a.xwfsucursal = ln_suc10
         and a.xwfmodulo = ln_mod10
         and a.xwfmoneda = ln_mda10
         and a.xwfpapel = ln_pap10
         and a.xwfcuenta = ln_cta10
         and a.xwfoperacion = ln_oper10
         and a.xwfsubope = ln_sbop10
         and a.xwftipope = ln_tope10
         and a.xwfprcins = s.sng001inst
         and s.sng001ori in (4, 15) -- Ampliaciones Normales, Ampliaciones Especiales
         and s.sng001inst = x.wfinsprcid
         and x.wfitemstsact = 1
         and rownum = 1;
    exception
      when no_data_found then
        Pc_flag := 'N';
    end;
  
  end Sp_ampliados_CK;
  --------------------------------------------------------- 
  procedure sp_cr_RefiReproLinea(ln_pgcod10  in number,
                                 ln_mod10    in number,
                                 ln_suc10    in number,
                                 ln_mda10    in number,
                                 ln_pap10    in number,
                                 ln_cta10    in number,
                                 ln_oper10   in number,
                                 lc_fgRefLin out varchar2) is
  
  begin
    if ln_mod10 = 117 then
    
      begin
        select 'S'
          into lc_fgRefLin
          from fsr011 f, xwf700 w
         where f.r1cod = w.xwfempresa
           and f.r1mod = w.xwfmodulo
           and f.r1suc = w.xwfsucursal
           and f.r1mda = w.xwfmoneda
           and f.r1pap = w.xwfpapel
           and f.r1cta = w.xwfcuenta
           and w.xwfcar3 = 'R'
           and f.r2cod = ln_pgcod10
           and f.r2mod = ln_mod10
           and f.r2suc = ln_suc10
           and f.R2MDA = ln_mda10
           and f.R2PAP = ln_pap10
           and f.r2cta = ln_cta10
           and f.r2oper = ln_oper10
           and f.relcod = 46
           and rownum = 1; --2017.03.28
      exception
        when no_data_found then
          lc_fgRefLin := 'N';
      end;
    
    else
    
      begin
        select 'S'
          into lc_fgRefLin
          from xwf700 a, sng001 s, wfwrkitems x
         where a.xwfempresa = ln_pgcod10
           and a.xwfsucursal = ln_suc10
           and a.xwfmodulo = ln_mod10
           and a.xwfmoneda = ln_mda10
           and a.xwfpapel = ln_pap10
           and a.xwfcuenta = ln_cta10
           and a.xwfoperacion = ln_oper10
              
           and a.xwfprcins = s.sng001inst
           and s.sng001ori in (3, 13, 14) -- Refinanciaciones, Reprogramaciones
           and s.sng001inst = x.wfinsprcid
           and x.wfitemstsact = 1
           and rownum = 1;
      
      exception
        when no_data_found then
          lc_fgRefLin := 'N';
        
      end;
    end if;
  
  end sp_cr_RefiReproLinea;
  -------------------------------------

end pq_cr_resolutor_cantfinan;
/

