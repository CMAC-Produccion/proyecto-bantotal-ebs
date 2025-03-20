create or replace package PQ_CR_EVA_PYME_OTROS_DATOS is

  /* ************************************************************************************************************
      -- Nombre                     : Ratio Endeudamiento Patrimonio Resolutor Politica Saldo Pyme
      -- Sistema                    : BANTOTAL
      -- Versión                    : 1.0
      -- Fecha de Creación          : 10/02/2021
      -- Autor de Creación          : Juan Fernando Rodríguez Mamani
      -- Versión                    : 2.0
      -- Fecha de Modificación      : 22/02/2021
      -- Autor de la Modificación   : Juan Fernando Rodríguez Mamani
      -- Descripción de Modificación: Adición de código para procesar el extorno y creación del procedimiento
      --                                 
      --
  * *************************************************************************************************************/

  -- Obtener Fecha de vencimiento de última cuota impaga
  procedure sp_obtener_datos_adic(pn_ins   in number,
                                  pn_sdo   out number, -- Saldo Capital
                                  pn_cuoa  out number, --- Cuota Anterior
                                  pn_cuod  out number, --- Cuota después de repro 
                                  pn_frea  out number, --- Frecuencia anterior  
                                  pn_fren  out number, --- Nueva frecuencia  
                                  pn_fimpa out date, ---  Fecha cuota impaga anterior  
                                  pn_fimpn out date, ---  Fecha cuota impaga nueva  
                                  pn_venca out date, ---  Fecha vencimiento anterior   
                                  pn_vencn out date --- Fecha vencimiento nueva);
                                  );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- Obtener Fecha de vencimiento de última cuota impaga
  procedure sp_obtener_impaga(pn_cod   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pn_fecha out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                
  procedure sp_obtener_sum_fin(pn_ins in number, pn_tot out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  procedure sp_tipo_cambio_fijo(P_FECHA   in date,
                                ln_tipcam out fsh005.cotcbi%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  procedure sp_actualiza_estado_jaqa400(pn_cod   in number,
                                        pn_mod   in number,
                                        pn_suc   in number,
                                        pn_mda   in number,
                                        pn_pap   in number,
                                        pn_cta   in number,
                                        pn_ope   in number,
                                        pn_sbo   in number,
                                        pn_top   in number,
                                        pn_fecha in date,
                                        pn_proc  in VARCHAR2,
                                        pn_esta  in VARCHAR2,
                                        pn_usua  in VARCHAR2,
                                        pn_flag  out VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                       
  /*  
  procedure sp_actualizar_est_FDS011(pn_cod   in number,
                                        pn_mod   in number,
                                        pn_suc   in number,
                                        pn_mda   in number,
                                        pn_pap   in number,
                                        pn_cta   in number,
                                        pn_ope   in number,
                                        pn_sbo   in number,
                                        pn_top   in number,
                                        pn_flag  out VARCHAR2);
  */                                        
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                         
  procedure sp_mensaje_err88(pn_cod   in number,
                                        pn_mod   in number,
                                        pn_suc   in number,
                                        pn_mda   in number,
                                        pn_pap   in number,
                                        pn_cta   in number,
                                        pn_ope   in number,
                                        pn_sbo   in number,
                                        pn_top   in number,
                                        pn_mseg  out VARCHAR2,
                                        pn_flag  out VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                           

end PQ_CR_EVA_PYME_OTROS_DATOS;
/

create or replace package body PQ_CR_EVA_PYME_OTROS_DATOS is

  /* ************************************************************************************************************
      -- Nombre                     : Ratio Endeudamiento Patrimonio Resolutor Politica Saldo Pyme
      -- Sistema                    : BANTOTAL
      -- Versión                    : 1.0
      -- Fecha de Creación          : 10/02/2021
      -- Autor de Creación          : Juan Fernando Rodríguez Mamani
      -- Versión                    : 2.0
      -- Fecha de Modificación      : 22/02/2021
      -- Autor de la Modificación   : Juan Fernando Rodríguez Mamani
      -- Descripción de Modificación: Adición de código para procesar el extorno y creación del procedimiento
      --                                 
      --
  * *************************************************************************************************************/

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

  procedure sp_obtener_datos_adic(pn_ins   in number,
                                  pn_sdo   out number, -- Saldo Capital
                                  pn_cuoa  out number, --- Cuota Anterior
                                  pn_cuod  out number, --- Cuota después de repro 
                                  pn_frea  out number, --- Frecuencia anterior        x054023  suboperacion normal
                                  pn_fren  out number, --- Nueva frecuencia            x054023 suboperacion 609
                                  pn_fimpa out date, ---  Fecha cuota impaga anterior      fsd601 suboperacion normal, minima cuota impaga (fsd601, fsd602)  d601co = S
                                  pn_fimpn out date, ---  Fecha cuota impaga nueva         fsd601 suboperacion 609,  minima fecha ppfpag
                                  pn_venca out date, ---  Fecha vencimiento anterior        fsd601 suboperacion normal, maxima ppfpag  d601co = S
                                  pn_vencn out date --- Fecha vencimiento nueva           fsd601 suboperacion 609, maxima ppfpag
                                  
                                  ) is
  
    pn_cod number(3);
    pn_mod number(3);
    pn_suc number(3);
    pn_mda number(4);
    pn_pap number(4);
    pn_cta number(9);
    pn_ope number(9);
    pn_sbo number(3);
    pn_top number(3);
  
  begin
  
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
        into pn_cod,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_ins
         and x.xwfcar3 = '1';
    exception
      when others then
        pn_cod := null;
        pn_mod := null;
        pn_suc := null;
        pn_mda := null;
        pn_pap := null;
        pn_cta := null;
        pn_ope := null;
        pn_sbo := null;
        pn_top := null;
      
    end;
  
    if pn_cod is not null then
      begin
      
        --  Saldo Capital                     fsd011 suboperacion normal
        begin
          select (nvl(x.scsdo, 0) * -1)
            into pn_sdo
            from fsd011 x
           where x.pgcod = pn_cod
             and x.scmod = pn_mod
             and x.scsuc = pn_suc
             and x.scmda = pn_mda
             and x.scpap = pn_pap
             and x.sccta = pn_cta
             and x.scoper = pn_ope
             and x.scsbop = pn_sbo
             and x.sctope = pn_top;
        exception
          when others then
            pn_sdo := 0;
        end;
      
        --  Cuota Anterior                 pendiente de confirmar
        pn_cuoa := 0;
      
        --  Cuota después de repro              pendiente de confirmar
        pn_cuod := 0;
      
        --  Frecuencia anterior        x054023  suboperacion normal
        begin
          select x.xllperiodo
            into pn_frea
            from x054023 x
           where x.xllpgcod = pn_cod
             and x.xllaomod = pn_mod
             and x.xllaosuc = pn_suc
             and x.xllaomda = pn_mda
             and x.xllaopap = pn_pap
             and x.xllaocta = pn_cta
             and x.xllaooper = pn_ope
             and x.xllaosbop = pn_sbo
             and x.xllaotop = pn_top;
        exception
          when others then
            pn_frea := 0;
        end;
      
        --  Nueva frecuencia            x054023 suboperacion 609
        begin
          select x.xllperiodo
            into pn_fren
            from x054023 x
           where x.xllpgcod = pn_cod
             and x.xllaomod = pn_mod
             and x.xllaosuc = pn_suc
             and x.xllaomda = pn_mda
             and x.xllaopap = pn_pap
             and x.xllaocta = pn_cta
             and x.xllaooper = pn_ope
             and x.xllaosbop = 609
             and --- <=== ES EL ÚNICO CAMBIO
                 x.xllaotop = pn_top;
        exception
          when others then
            pn_fren := 0;
        end;
      
        --  Fecha cuota impaga anterior      fsd601 suboperacion normal, minima cuota impaga (fsd601, fsd602)  d601co = S
        begin
          -- Call the procedure
          pq_cr_eva_pyme_otros_datos.sp_obtener_impaga(pn_cod   => pn_cod,
                                                       pn_mod   => pn_mod,
                                                       pn_suc   => pn_suc,
                                                       pn_mda   => pn_mda,
                                                       pn_pap   => pn_pap,
                                                       pn_cta   => pn_cta,
                                                       pn_ope   => pn_ope,
                                                       pn_sbo   => pn_sbo,
                                                       pn_top   => pn_top,
                                                       pn_fecha => pn_fimpa);
        exception
          when others then
            pn_fimpa := null;
        end;
      
        --  Fecha cuota impaga nueva         fsd601 suboperacion 609,  minima fecha ppfpag
        begin
          -- Call the procedure
          pq_cr_eva_pyme_otros_datos.sp_obtener_impaga(pn_cod   => pn_cod,
                                                       pn_mod   => pn_mod,
                                                       pn_suc   => pn_suc,
                                                       pn_mda   => pn_mda,
                                                       pn_pap   => pn_pap,
                                                       pn_cta   => pn_cta,
                                                       pn_ope   => pn_ope,
                                                       pn_sbo   => 609, ---- <== ÚNICO CAMBIO
                                                       pn_top   => pn_top,
                                                       pn_fecha => pn_fimpn);
        exception
          when others then
            pn_fimpn := null;
        end;
      
        --  Fecha vencimiento anterior        fsd601 suboperacion normal, maxima ppfpag  d601co = S
        begin
          select max(x.ppfpag)
            into pn_venca
            from fsd601 x
           where x.pgcod = pn_cod
             and x.ppmod = pn_mod
             and x.ppsuc = pn_suc
             and x.ppmda = pn_mda
             and x.pppap = pn_pap
             and x.ppcta = pn_cta
             and x.ppoper = pn_ope
             and x.ppsbop = pn_sbo
             and x.pptope = pn_top
             and x.d601co = 'S';
        exception
          when others then
            pn_venca := null;
        end;
      
        --  Fecha vencimiento nueva           fsd601 suboperacion 609, maxima ppfpag
        begin
          select max(x.ppfpag)
            into pn_vencn
            from fsd601 x
           where x.pgcod = pn_cod
             and x.ppmod = pn_mod
             and x.ppsuc = pn_suc
             and x.ppmda = pn_mda
             and x.pppap = pn_pap
             and x.ppcta = pn_cta
             and x.ppoper = pn_ope
             and x.ppsbop = 609
             and -- <=== ÚNICO CAMBIO
                 x.pptope = pn_top
             and x.d601co = 'S';
        exception
          when others then
            pn_vencn := null;
        end;
      
      end;
    end if;
  
  end sp_obtener_datos_adic;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_obtener_impaga(pn_cod   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pn_fecha out date) is
  
    lx_fmax date;
  
  begin
  
    begin
    
      select max(t.ppfpag)
        into lx_fmax
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat in ('T')
         and t.d602co = 'S';
    exception
      when others then
        lx_fmax := null;
    end;
  
    if lx_fmax is not null then
      ----Si se pagó
      begin
        select --nvl(f.ppcap, 0), nvl(f.ppint, 0), 
         f.ppfpag
          into --lx_pcap, lx_pint, 
               pn_fecha
          from (select t.ppfpag
                  from fsd601 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                   and t.ppfpag > lx_fmax
                   and (t.ppcap + t.ppint) <> 0
                   and t.d601co = 'S'
                 order by t.ppfpag asc) f
         where rownum = 1;
      
      exception
        when others then
          pn_fecha := null;
      end;
    
    else
      --No se pagó nada
      begin
        select min(t.ppfpag)
          into pn_fecha
          from fsd601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and (t.ppcap + t.ppint) <> 0
           and t.d601co = 'S';
      exception
        when others then
          pn_fecha := null;
      end;
    
    end if;
  
  end sp_obtener_impaga;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_obtener_sum_fin(pn_ins in number, pn_tot out number) is
  
  begin
  
    begin
    
      select nvl(sum(x.aqpb081gfin), 0)
        into pn_tot
        from aqpb081 x
       where x.aqpb081inst = pn_ins
         and x.aqpb081esta = 'S'
         and x.aqpb081chek = '1';
    exception
      when others then
        pn_tot := 0;
    end;
  
  end sp_obtener_sum_fin;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

  procedure sp_tipo_cambio_fijo(P_FECHA   in date,
                                ln_tipcam out fsh005.cotcbi%type) is
    --ln_tipcam fsh005.cotcbi%type;
  Begin
    Select cotcbi
      Into ln_tipcam
      From (select u.cotcbi
              From fsh005 u
             Where moneda = 101
               And cofdes <= P_FECHA
             Order by cofdes desc)
     Where rownum = 1;
  
  Exception
    when others then
      ln_tipcam := 0;
  end sp_tipo_cambio_fijo;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        
  procedure sp_actualiza_estado_jaqa400(pn_cod   in number,
                                        pn_mod   in number,
                                        pn_suc   in number,
                                        pn_mda   in number,
                                        pn_pap   in number,
                                        pn_cta   in number,
                                        pn_ope   in number,
                                        pn_sbo   in number,
                                        pn_top   in number,
                                        pn_fecha in date,
                                        pn_proc  in VARCHAR2,
                                        pn_esta  in VARCHAR2,
                                        pn_usua  in VARCHAR2,
                                        pn_flag  out VARCHAR2) is
    --ln_tipcam fsh005.cotcbi%type;
  
    --pn_fechasis date;
    lc_count number;
  
    lc_cod   number(3);
    lc_mod   number(3);
    lc_suc   number(3);
    lc_mda   number(4);
    lc_pap   number(4);
    lc_cta   number(9);
    lc_ope   number(9);
    lc_sbo   number(3);
    lc_top   number(3);
    lc_fecha date;
  
  Begin
  
    ---select t.pgfape into pn_fechasis from fst017_scre0204 t;
    ---dbms_output.put_line('pn_fechasis : ' || pn_fechasis);
  
    case pn_proc
      when 'UPD' then
        ---------------------  
        begin
          select count(*)
            into lc_count
            from jaqa400 x
           where x.jaqa400emp = pn_cod
             and x.jaqa400mod = pn_mod
             and x.jaqa400suc = pn_suc
             and x.jaqa400mda = pn_mda
             and x.jaqa400pap = pn_pap
             and x.jaqa400cta = pn_cta
             and x.jaqa400ope = pn_ope
             and x.jaqa400sbo = pn_sbo
             and x.jaqa400top = pn_top
             and x.jaqa400fec = pn_fecha
             and x.jaqa400est = 'E'
             and trim(x.jaqa400uss) = pn_usua;
        Exception
          when others then
            lc_count := 0;
        end;
      
        if lc_count > 0 then
          update jaqa400 x
             set x.jaqa400est = pn_esta
           where x.jaqa400emp = pn_cod
             and x.jaqa400mod = pn_mod
             and x.jaqa400suc = pn_suc
             and x.jaqa400mda = pn_mda
             and x.jaqa400pap = pn_pap
             and x.jaqa400cta = pn_cta
             and x.jaqa400ope = pn_ope
             and x.jaqa400sbo = pn_sbo
             and x.jaqa400top = pn_top
             and x.jaqa400fec = pn_fecha --pn_fecha
             and x.jaqa400est = 'E'
             and trim(x.jaqa400uss) = pn_usua;
          commit;
        
          pn_flag := 'S';
        else
          pn_flag := 'N';
        
        end if;
      
    --------------------
      when 'EXT' then
      
        begin
          select count(*)
            into lc_count
            from jaqa400 x
           where x.jaqa400emp = pn_cod
             and x.jaqa400mod = pn_mod
             and x.jaqa400suc = pn_suc
             and x.jaqa400mda = pn_mda
             and x.jaqa400pap = pn_pap
             and x.jaqa400cta = pn_cta
             and x.jaqa400ope = pn_ope
             and x.jaqa400sbo = pn_sbo
             and x.jaqa400top = pn_top
             and x.jaqa400fec = pn_fecha
             and x.jaqa400est = 'C'
          --and trim(x.jaqa400uss) = pn_usua
          ;
        Exception
          when others then
            lc_count := 0;
        end;
      
        if lc_count > 0 then
          /*
          select
          
           f.jaqa400emp,
           f.jaqa400mod,
           f.jaqa400suc,
           f.jaqa400mda,
           f.jaqa400pap,
           f.jaqa400cta,
           f.jaqa400ope,
           f.jaqa400sbo,
           f.jaqa400top,
           f.jaqa400fec
            into lc_cod,
                 lc_mod,
                 lc_suc,
                 lc_mda,
                 lc_pap,
                 lc_cta,
                 lc_ope,
                 lc_sbo,
                 lc_top,
                 lc_fecha
          
            from (select x.jaqa400emp,
                         x.jaqa400mod,
                         x.jaqa400suc,
                         x.jaqa400mda,
                         x.jaqa400pap,
                         x.jaqa400cta,
                         x.jaqa400ope,
                         x.jaqa400sbo,
                         x.jaqa400top,
                         x.jaqa400fec
                    from jaqa400 x
                   where x.jaqa400emp = pn_cod
                     and x.jaqa400mod = pn_mod
                     and x.jaqa400suc = pn_suc
                     and x.jaqa400mda = pn_mda
                     and x.jaqa400pap = pn_pap
                     and x.jaqa400cta = pn_cta
                     and x.jaqa400ope = pn_ope
                     and x.jaqa400sbo = pn_sbo
                     and x.jaqa400top = pn_top
                     and x.jaqa400est = 'C'
                   order by x.jaqa400fec desc) f
           where rownum = 1;
           */
        
          update jaqa400 x
             set x.jaqa400est = pn_esta
           where x.jaqa400emp = pn_cod
             and x.jaqa400mod = pn_mod
             and x.jaqa400suc = pn_suc
             and x.jaqa400mda = pn_mda
             and x.jaqa400pap = pn_pap
             and x.jaqa400cta = pn_cta
             and x.jaqa400ope = pn_ope
             and x.jaqa400sbo = pn_sbo
             and x.jaqa400top = pn_top
             and x.jaqa400fec = pn_fecha
             and x.jaqa400est = 'C'
          --and trim(x.jaqa400uss) = pn_usua
          ;
          commit;
        
          pn_flag := 'S';
        
        else
          pn_flag := 'N';
        
        end if;
        ---------------------      
    
    --pn_flag := 'S';
    --else
    --   pn_flag := 'N';
    
    --end CASE;      
    
      else
        pn_flag := 'N';
      
    end case;
  
  Exception
    when others then
      pn_flag := 'N';
    
  end sp_actualiza_estado_jaqa400;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
  /*
  procedure sp_actualizar_est_FDS011(pn_cod  in number,
                                     pn_mod  in number,
                                     pn_suc  in number,
                                     pn_mda  in number,
                                     pn_pap  in number,
                                     pn_cta  in number,
                                     pn_ope  in number,
                                     pn_sbo  in number,
                                     pn_top  in number,
                                     pn_flag out VARCHAR2) is
    --ln_tipcam fsh005.cotcbi%type;
    lc_cont number(1);
  
  Begin
  
    ---select t.pgfape into pn_fechasis from fst017_scre0204 t;
    ---dbms_output.put_line('pn_fechasis : ' || pn_fechasis);
  
    begin
      select count(*)
        into lc_cont
        from fsd011 x
       where x.pgcod = pn_cod
         and x.scmod in (417,418)
         --and x.scsuc = pn_suc
         --and x.scrub = '9500095000000'
         and x.scmda = pn_mda
         --and x.scpap = pn_pap
         and x.sccta = pn_cta
         and x.scoper = pn_ope
         --and x.scsbop = pn_sbo
         --and x.sctope = pn_top
         and x.scstat = 0
         ;
    
    Exception
      when others then
        lc_cont := 0;
    end;
  
    if lc_cont > 0 then
      begin
  
      
        update fsd011 x
           set x.scsdo=0,x.scsdoh=0 --x.scstat = 99
         where x.pgcod = pn_cod
           and x.scmod in (417,418)
           --and x.scsuc = pn_suc
           --and x.scrub = '9500095000000'
           and x.scmda = pn_mda
           --and x.scpap = pn_pap
           and x.sccta = pn_cta
           and x.scoper = pn_ope
           --and x.scsbop = pn_sbo
           --and x.sctope = pn_top
           and x.scstat = 0;
        commit;
      
        pn_flag := 'S';
      
      end;
    else
      pn_flag := 'N';
    end if;
  
  Exception
    when others then
      pn_flag := 'N';
    
  end sp_actualizar_est_FDS011;
  */
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
  procedure sp_mensaje_err88(pn_cod  in number,
                             pn_mod  in number,
                             pn_suc  in number,
                             pn_mda  in number,
                             pn_pap  in number,
                             pn_cta  in number,
                             pn_ope  in number,
                             pn_sbo  in number,
                             pn_top  in number,
                             pn_mseg out VARCHAR2,
                             pn_flag out VARCHAR2) is
    --ln_tipcam fsh005.cotcbi%type;
    lc_cont number(1);
  
    lc_emp       number(3);
    lc_suc       number(3);
    lc_mod       number(3);
    lc_trx       number(3);
    lc_rel       number(4);
    lc_fec       date;
    ld_MaxFch088 date;
  
  Begin
  
    begin
      select j.aqpb556temp,
             j.aqpb556tsuc,
             j.aqpb556tmod,
             j.aqpb556ttran,
             j.aqpb556tnrel,
             j.aqpb556tfcon
        into lc_emp, lc_suc, lc_mod, lc_trx, lc_rel, lc_fec
        from aqpb556 j
       where j.aqpb556emp = pn_cod
         and j.aqpb556mod = pn_mod
         and j.aqpb556suc = pn_suc
         and j.aqpb556mda = pn_mda
         and j.aqpb556pap = pn_pap
         and j.aqpb556cta = pn_cta
         and j.aqpb556oper = pn_ope
         and j.aqpb556sbop = pn_sbo
         and j.aqpb556top = pn_top
         and j.aqpb556ehab = 'H'
         and j.aqpb556est = 'A'
         and cast(j.aqpb556fecm as date) =
             (select max(cast(x.aqpb556fecm as date))
                from aqpb556 x
               where x.aqpb556emp = pn_cod
                 and x.aqpb556mod = pn_mod
                 and x.aqpb556suc = pn_suc
                 and x.aqpb556mda = pn_mda
                 and x.aqpb556pap = pn_pap
                 and x.aqpb556cta = pn_cta
                 and x.aqpb556oper = pn_ope
                 and x.aqpb556sbop = pn_sbo
                 and x.aqpb556top = pn_top
                 and x.aqpb556ehab = 'H'
                 and x.aqpb556est = 'A');
    
      pn_mseg := 'Debe extornar la transacción con suc: ' ||
                 to_char(lc_suc) || ', mod: ' || to_char(lc_mod) ||
                 ', trx: ' || to_char(lc_trx) || ', rel: ' ||
                 to_char(lc_rel) || ', fecha: ' ||
                 to_char(lc_fec, 'DD/MM/YYYY') || '.';
      pn_flag := 'S';
    
    exception
      when too_many_rows then
      
        select f.aqpb556temp,
               f.aqpb556tsuc,
               f.aqpb556tmod,
               f.aqpb556ttran,
               f.aqpb556tnrel,
               f.aqpb556tfcon
          into lc_emp, lc_suc, lc_mod, lc_trx, lc_rel, lc_fec
          from (select j.aqpb556temp,
                       j.aqpb556tsuc,
                       j.aqpb556tmod,
                       j.aqpb556ttran,
                       j.aqpb556tnrel,
                       j.aqpb556tfcon
                  from aqpb556 j
                 where j.aqpb556emp = pn_cod
                   and j.aqpb556mod = pn_mod
                   and j.aqpb556suc = pn_suc
                   and j.aqpb556mda = pn_mda
                   and j.aqpb556pap = pn_pap
                   and j.aqpb556cta = pn_cta
                   and j.aqpb556oper = pn_ope
                   and j.aqpb556sbop = pn_sbo
                   and j.aqpb556top = pn_top
                   and j.aqpb556ehab = 'H'
                   and j.aqpb556est = 'A'
                   and cast(j.aqpb556fecm as date) =
                       (select max(cast(x.aqpb556fecm as date))
                          from aqpb556 x
                         where x.aqpb556emp = pn_cod
                           and x.aqpb556mod = pn_mod
                           and x.aqpb556suc = pn_suc
                           and x.aqpb556mda = pn_mda
                           and x.aqpb556pap = pn_pap
                           and x.aqpb556cta = pn_cta
                           and x.aqpb556oper = pn_ope
                           and x.aqpb556sbop = pn_sbo
                           and x.aqpb556top = pn_top
                           and x.aqpb556ehab = 'H'
                           and x.aqpb556est = 'A')) f
         where rownum = 1;
      
        pn_mseg := 'Debe extornar la transacción con suc: ' ||
                   to_char(lc_suc) || ', mod: ' || to_char(lc_mod) ||
                   ', trx: ' || to_char(lc_trx) || ', rel: ' ||
                   to_char(lc_rel) || ', fecha: ' ||
                   to_char(lc_fec, 'DD/MM/YYYY') || '.';
        pn_flag := 'S';
      
      when others then
      
        begin
          select max(a.aqpb088fep)
            into ld_MaxFch088
            from aqpb088 a
           where a.aqpb088emp = pn_cod
             and a.aqpb088mod = pn_mod
             and a.aqpb088suc = pn_suc
             and a.aqpb088mda = pn_mda
             and a.aqpb088pap = pn_pap
             and a.aqpb088cta = pn_cta
             and a.aqpb088ope = pn_ope
             and a.aqpb088sbo = pn_sbo
             and a.aqpb088top = pn_top
             and a.aqpb088est in ('C');
        
          pn_mseg := 'Debe extornar la transacción 98/579 con fecha ' ||
                     to_char(ld_MaxFch088, 'DD/MM/YYYY') || '.';
          pn_flag := 'N';
        
        exception
          when others then
          
            pn_mseg := 'Debe extornar la transacción 98/579.';
            pn_flag := 'N';
          
        end;
    end;
  
  Exception
    when others then
    
      pn_mseg := 'Debe extornar la transacción 98/579.';
      pn_flag := 'N';
    
  end sp_mensaje_err88;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --            

end PQ_CR_EVA_PYME_OTROS_DATOS;
/

