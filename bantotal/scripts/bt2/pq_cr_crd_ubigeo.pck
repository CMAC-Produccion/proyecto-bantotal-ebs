create or replace package pq_cr_crd_ubigeo is

  -- Author  : HSUAREZ
  -- Created : 06/07/2017 04:23:53 p.m.
  -- Purpose : OBTIENE DIRECCION DEL CLIENTE.

  Procedure sp_cr_validar_direc(instancia in number, flag_ubi out varchar2);
  Procedure sp_cr_Ubigeo_recurrente(instancia in number,
                                    flag_ubi  out varchar2);

end pq_cr_crd_ubigeo;
/

create or replace package body pq_cr_crd_ubigeo is

  ---------------------------------------------------------------
  -- Author  : HSUAREZ
  -- Created : 06/07/2017 04:23:53 p.m.
  -- Purpose : OBTIENE DIRECCION DEL CLIENTE.
  -- Autor de modificacion: ABERNEDO
  -- Fecha de modificacion: 05/07/2019
  -- Modificacion: Se modifico validacion de cliente nuevo
  --               Se agrego proceso de validacion de ubigeo de cliente recurrente

  ---------------------------------------------------------------

  Procedure sp_cr_validar_direc(instancia in number, flag_ubi out varchar2) is
  
    cursor dni_cliente(cuenta number) is
      select pepais, petdoc, pendoc from fsr008 where ctnro = cuenta;
  
    cursor direcciones_cl_indp(vpais number, vtdoc number, vndoc char) is
      select sngc13ugeo, sngc13dpto, sngc13prov, sngc13dist
        from sngc13 s
       where s.docod in (select tp1nro1
                           from fst198 t
                          where t.tp1cod = 1
                            and t.tp1cod1 = 11102
                            and t.tp1corr1 = 2
                            and t.tp1corr2 = 1
                            and t.tp1corr3 > 0)
         and s.sngc13est = 'H'
         and s.sngc13pais = vpais
         and s.sngc13tdoc = vtdoc
         and s.sngc13ndoc = vndoc;
  
    -- 14.02.18 mpostigoc Direccion para Dependiente (No se considera la Direccion Laboral)                  
    cursor direcciones_cl_dpnd(vpais number, vtdoc number, vndoc char) is
      select sngc13ugeo, sngc13dpto, sngc13prov, sngc13dist
        from sngc13 s
       where s.docod in (select tp1nro1
                           from fst198 t
                          where t.tp1cod = 1
                            and t.tp1cod1 = 11102
                            and t.tp1corr1 = 2
                            and t.tp1corr2 = 2
                            and t.tp1corr3 > 0)
         and s.sngc13est = 'H'
         and s.sngc13pais = vpais
         and s.sngc13tdoc = vtdoc
         and s.sngc13ndoc = vndoc;
  
    -- 14.02.18 mpostigoc Direccion para Dependiente (No se considera la Direccion Laboral)                  
  
    cursor Ubigeos_Especiales(ln_Depart number,
                              ln_Prov   number,
                              ln_Dist   number) is
    
      select t.tp1imp1 ln_NewAgencia, t.tp1nro1 ln_Depart
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11102
         and t.tp1corr1 = 2
         and t.tp1nro1 = ln_Depart
         and t.tp1nro2 = ln_Prov
         and t.tp1nro3 = ln_Dist;
  
    ln_cuenta        number;
    ln_agencia       number;
    ln_dpto_suc      number;
    tmp_prv          number;
    ln_prv_suc       number;
    ln_dpto_cl       number;
    ln_prv_cl        number;
    tp_pais          number;
    tp_petd          number;
    tp_pend          varchar(12);
    ln_SegLinea      NUMBER;
    lc_FlagExtUbgEsp varchar2(2) := 'N';
    -------------------------------------------------------------------------
  begin
    ----------------------------------------------
    begin
      select s.sng001cta, S.SNG001AGE
        into ln_cuenta, ln_agencia
        from sng001 s
       where s.sng001inst = instancia;
    
    exception
      when others then
        null;
    end;
    ---------------------------------------------
  
    flag_ubi := 'S';
    ---------------------------------------------
  
    begin
      select scciud, scdept
        into tmp_prv, ln_dpto_suc
        from fst001 f
       where f.pgcod = 1
         and f.sucurs = ln_agencia;
    exception
      when others then
        null;
    end;
    ----------------------------------------------
    begin
      begin
        select f.pepais, f.petdoc, f.pendoc
          into tp_pais, tp_petd, tp_pend
          from fsr008 f
         where f.ctnro = ln_cuenta
           and f.cttfir = 'T';
      exception
        when others then
          null;
      end;
      -------------------------------------
    
      -------------------------------------
      --mod@abr 20190705 
      --for x in cuentas_cliente(tp_pais, tp_petd, tp_pend) loop
      --  begin
      --    select 'S', 'N'
      --      into flag_fsd010, flag_ubi
      --      from fsd010 fd
      --     where fd.aocta = x.ctnro
      --       and (fd.aomod in
      --           ((select f.modulo from fst111 f where f.dscod = 50)) or
      --           fd.aomod = 117)
      --       and rownum = 1;
      --  exception
      --    when others then
      --      null;
      --  end;
      --end loop;
      --mod@abr 20190705
    end;
    ----------------------------------------------
    SELECT SUBSTR(tmp_prv, -2) into ln_prv_suc FROM DUAL;
    ----------------------------------------------     
    begin
      flag_ubi := 'S';
      --if flag_fsd010 = 'N' then --mod@abr 20190705 no se validara por programa
      --si el cliente es nuevo
    
      for ct in dni_cliente(ln_cuenta) loop
      
        if CT.PETDOC <> 9 then
        
          begin
            --14.02.18 mpostigoc
            select b.segcod
              into ln_SegLinea
              from sngc60 a, sngc07 b
             where a.sngc60pais = CT.PEPAIS
               and a.sngc60tdoc = CT.PETDOC
               and a.sngc60ndoc = CT.PENDOC
               and a.sngc60ocup = b.sngc07cod;
          exception
            when too_many_rows then
              begin
                select b.segcod
                  into ln_SegLinea
                  from sngc60 a, sngc07 b
                 where a.sngc60pais = CT.PEPAIS
                   and a.sngc60tdoc = CT.PETDOC
                   and a.sngc60ndoc = CT.PENDOC
                   and a.sngc60ocup = b.sngc07cod
                   and a.sngc60corr =
                       (select min(a.sngc60corr) -- INC2051 21/10/2019 MPOSTIGOC
                          from sngc60 a, sngc07 b
                         where a.sngc60pais = CT.PEPAIS
                           and a.sngc60tdoc = CT.PETDOC
                           and a.sngc60ndoc = CT.PENDOC
                           and a.sngc60ocup = b.sngc07cod);
              
              end;
            when no_data_found then
              null;
          end;
        
        else
          -- 01/03/2018 MPOSTIGOC
          if CT.PETDOC = 9 then
            ln_SegLinea := 1;
          
          end if;
        end if;
      
        if ln_SegLinea = 1 then
          --14.02.18 mpostigoc
        
          for dc in direcciones_cl_indp(ct.pepais, ct.petdoc, ct.pendoc) loop
          
            -- mpostigoc 240518
            --departamento
            ln_dpto_cl := dc.sngc13dpto;
            --provincia
            SELECT SUBSTR(dc.sngc13prov, -2) into ln_prv_cl FROM DUAL;
            ---------------------
            if ln_dpto_cl = ln_dpto_suc then
              if ln_prv_cl = ln_prv_suc then
                flag_ubi := 'N';
                return;
              end if;
            end if;
          
            if flag_ubi = 'S' then
              begin
              
                select 'S'
                  into lc_FlagExtUbgEsp
                  from fst198 t
                 where t.tp1cod = 1
                   and t.tp1cod1 = 11102
                   and t.tp1corr1 = 2
                   and t.tp1nro1 = dc.sngc13dpto
                   and t.tp1nro2 = dc.sngc13prov
                   and t.tp1nro3 = dc.sngc13dist
                   and rownum = 1;
              exception
                when others then
                  lc_FlagExtUbgEsp := 'N';
              end;
            
              if lc_FlagExtUbgEsp = 'S' then
                -- mpostigoc 1402017
              
                for ue in Ubigeos_Especiales(dc.sngc13dpto,
                                             dc.sngc13prov,
                                             dc.sngc13dist) loop
                
                  begin
                    select scciud, scdept
                      into tmp_prv, ln_dpto_cl
                      from fst001 f
                     where f.pgcod = 1
                       and f.sucurs = ue.ln_NewAgencia;
                  exception
                    when others then
                      null;
                  end;
                
                  SELECT SUBSTR(tmp_prv, -2) into ln_prv_cl FROM DUAL;
                
                  if ln_dpto_cl = ln_dpto_suc then
                    if ln_prv_cl = ln_prv_suc then
                      flag_ubi := 'N';
                      return;
                    end if;
                  end if;
                end loop;
              end if;
            
            end if;
          end loop;
        
        else
          if ln_SegLinea = 2 then
            --14.02.18 mpostigoc
            for dc in direcciones_cl_dpnd(ct.pepais, ct.petdoc, ct.pendoc) loop
            
              -- mpostigoc 240518
              --departamento
              ln_dpto_cl := dc.sngc13dpto;
              --provincia
              SELECT SUBSTR(dc.sngc13prov, -2) into ln_prv_cl FROM DUAL;
              ---------------------
              if ln_dpto_cl = ln_dpto_suc then
                if ln_prv_cl = ln_prv_suc then
                  flag_ubi := 'N';
                  return;
                end if;
              end if;
            
              if flag_ubi = 'S' then
              
                begin
                  select 'S'
                    into lc_FlagExtUbgEsp
                    from fst198 t
                   where t.tp1cod = 1
                     and t.tp1cod1 = 11102
                     and t.tp1corr1 = 2
                     and t.tp1nro1 = dc.sngc13dpto
                     and t.tp1nro2 = dc.sngc13prov
                     and t.tp1nro3 = dc.sngc13dist
                     and rownum = 1;
                exception
                  when others then
                    lc_FlagExtUbgEsp := 'N';
                end;
              
                if lc_FlagExtUbgEsp = 'S' then
                  -- mpostigoc 1402017
                
                  for ue in Ubigeos_Especiales(dc.sngc13dpto,
                                               dc.sngc13prov,
                                               dc.sngc13dist) loop
                  
                    begin
                      select scciud, scdept
                        into tmp_prv, ln_dpto_cl
                        from fst001 f
                       where f.pgcod = 1
                         and f.sucurs = ue.ln_NewAgencia;
                    exception
                      when others then
                        null;
                    end;
                  
                    SELECT SUBSTR(tmp_prv, -2) into ln_prv_cl FROM DUAL;
                  
                    if ln_dpto_cl = ln_dpto_suc then
                      if ln_prv_cl = ln_prv_suc then
                        flag_ubi := 'N';
                        return;
                      end if;
                    end if;
                  end loop;
                end if;
              end if;
            end loop;
          
          END IF;
        end if;
      
      end loop;
      --else --mod@abr 20190705
      --flag_ubi := 'N'; --mod@abr 20190705
      --return; --mod@abr 20190705
      --end if; --mod@abr 20190705
    exception
      when others then
        null;
    end;
  end sp_cr_validar_direc;

  Procedure sp_cr_Ubigeo_recurrente(instancia in number,
                                    flag_ubi  out varchar2) is
  
    cursor dni_cliente(cuenta number) is
      select pepais, petdoc, pendoc from fsr008 where ctnro = cuenta;
  
    cursor direcciones_cl_indp(vpais number, vtdoc number, vndoc char) is
      select sngc13ugeo, sngc13dpto, sngc13prov, sngc13dist
        from sngc13 s
       where s.docod in (select tp1nro1
                           from fst198 t
                          where t.tp1cod = 1
                            and t.tp1cod1 = 11102
                            and t.tp1corr1 = 2
                            and t.tp1corr2 = 1
                            and t.tp1corr3 > 0)
         and s.sngc13est = 'H'
         and s.sngc13pais = vpais
         and s.sngc13tdoc = vtdoc
         and s.sngc13ndoc = vndoc;
  
    cursor excepciones(cn_ubigeo in number) is
      select * from jaqz686 a where a.jaqz686prv = cn_ubigeo;
  
    ln_cuenta   number;
    ln_agencia  number;
    ln_dpto_suc number;
    tmp_prv     number;
    --ln_prv_suc  number;
    ln_dpto_cl number;
    --ln_prv_cl   number;
    tp_pais number;
    tp_petd number;
    tp_pend varchar(12);
    --ln_dpto_exc number;
    ln_prv_exc number;
    -------------------------------------------------------------------------
  begin
    ----------------------------------------------
    begin
      select s.sng001cta, S.SNG001AGE
        into ln_cuenta, ln_agencia
        from sng001 s
       where s.sng001inst = instancia;
    
    exception
      when others then
        null;
    end;
  
    flag_ubi := 'S';
  
    ---------------------------------------------
  
    begin
      select scciud, scdept
        into tmp_prv, ln_dpto_suc
        from fst001 f
       where f.pgcod = 1
         and f.sucurs = ln_agencia;
    exception
      when others then
        null;
    end;
    ----------------------------------------------
    begin
      begin
        select f.pepais, f.petdoc, f.pendoc
          into tp_pais, tp_petd, tp_pend
          from fsr008 f
         where f.ctnro = ln_cuenta
           and f.cttfir = 'T';
      exception
        when others then
          null;
      end;
    
    end;
    ----------------------------------------------
    --SELECT SUBSTR(tmp_prv, -2) into ln_prv_suc FROM DUAL;
    ----------------------------------------------     
    begin
      flag_ubi := 'S';
      --if flag_fsd010 = 'N' then --mod@abr 20190705 no se validara por programa
      --si el cliente es nuevo
    
      for ct in dni_cliente(ln_cuenta) loop
      
        for dc in direcciones_cl_indp(ct.pepais, ct.petdoc, ct.pendoc) loop
          --departamento
          ln_dpto_cl := dc.sngc13dpto;
          --provincia
          --SELECT SUBSTR(dc.sngc13prov, -2) into ln_prv_cl FROM DUAL;
          ---------------------
          if ln_dpto_cl = ln_dpto_suc then
            --if dc.sngc13prov = tmp_prv then
            flag_ubi := 'N';
            exit;
            --end if;
          end if;
        
          if flag_ubi = 'S' then
          
            for i in excepciones(dc.sngc13prov) loop
            
              begin
                select scciud --, 
                --scdept
                  into ln_prv_exc --, 
                --ln_dpto_exc
                  from fst001 f
                 where f.pgcod = 1
                   and f.sucurs = i.jaqz686suc;
              exception
                when others then
                  null;
              end;
              --ln_dpto_cl := ln_dpto_exc;
            
              --if ln_dpto_cl = ln_dpto_suc then
              if ln_prv_exc = tmp_prv then
                flag_ubi := 'N';
                exit;
              end if;
              --end if;
            
            end loop;
            if flag_ubi = 'N' then
              exit;
            end if;
          
          end if;
        
        end loop;
        if flag_ubi = 'N' then
          exit;
        end if;
      end loop;
    exception
      when others then
        null;
    end;
  end sp_cr_Ubigeo_recurrente;

end pq_cr_crd_ubigeo;
/

