create or replace package PQ_CR_RATIOS_REPROCAP is

  -- Author  : MPOSTIGOC
  -- Created : 6/02/2021 11:03:48 a. m.
  -- Purpose : 

  -- Public type declarations

  procedure sp_cr_inicio(ln_instancia  in number,
                         ld_fecha      in date,
                         lc_usuario    in varchar2,
                         ln_ratiopyme  out number,
                         ln_ratioconsm out number);
  ------------------------------------------------------
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number);

  --------------------------------------------
  procedure sp_cr_ratio(ln_Instancia     in number,
                        lc_SegmntoActual in number,
                        lc_indicador     out varchar2);
  PROCEDURE SP_VALIDAR_CIUU(VE_INSTANCIA number,
                            VE_RPTA out varchar
                            );
end PQ_CR_RATIOS_REPROCAP;
/

create or replace package body PQ_CR_RATIOS_REPROCAP is

  procedure sp_cr_inicio(ln_instancia  in number,
                         ld_fecha      in date,
                         lc_usuario    in varchar2,
                         ln_ratiopyme  out number,
                         ln_ratioconsm out number) is
  
    lc_segmntoactual number := 0;
    ln_pais          number := 0;
    ln_tdoc          number := 0;
    lc_ndoc          varchar2(12);
    ld_tipocamb      number := 0.00;
    ln_deudacmac     number(17, 2) := 0.00;
    ln_deudaifis     number(17, 2) := 0.00;
    ln_ResultNeto    number(17, 2) := 0.00;
    ln_ExcdMensual   number(17, 2) := 0.00;
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    ld_tipocamb := fn_tipo_cambio_fijo(P_FECHA => ld_fecha);
  
    ln_pais := nvl(ln_pais, 0);
  
    pq_cr_ratios_reprocap.sp_cr_SegmntoActual(ln_instancia,
                                              lc_segmntoactual);
  
    if lc_segmntoactual = 1 and ln_pais > 0 then
      pq_cr_ratiopyme_neval.sp_InicioRatio(ln_Pepais     => ln_pais,
                                           ln_Petdoc     => ln_tdoc,
                                           ln_Pendoc     => lc_ndoc,
                                           tipocambio    => ld_tipocamb,
                                           Instancia     => ln_instancia,
                                           pd_fecpro     => ld_fecha,
                                           lc_Usuario    => lc_usuario,
                                           ln_captotcaja => ln_deudacmac,
                                           saldo_externo => ln_deudaifis,
                                           ResultNeto    => ln_ResultNeto,
                                           ln_captotal   => ln_ratiopyme);
      ln_ratioconsm := 0;
    else
      if lc_segmntoactual = 2 then
      
        pq_cr_ratiocnsm_neval.sp_CalculoRatio(ln_Pepais        => ln_pais,
                                              ln_Petdoc        => ln_tdoc,
                                              ln_Pendoc        => lc_ndoc,
                                              tipocambio       => ld_tipocamb,
                                              Instancia        => ln_instancia,
                                              pd_fecpro        => ld_fecha,
                                              ln_Usuario       => lc_usuario,
                                              ln_captotcaja    => ln_deudacmac,
                                              saldo_externo    => ln_deudaifis,
                                              ln_ExcdntMensual => ln_ExcdMensual,
                                              ln_RatioConsumo  => ln_ratioconsm);
        ln_ratiopyme := 0;
      end if;
    end if;
  end sp_cr_inicio;

  --------------------------------------------
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number) is
  
    ln_pais   number;
    ln_tdoc   number;
    lc_nrodoc char(12);
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_nrodoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    end;
  
    if ln_tdoc <> 9 then
    
      begin
        select to_number(trim(b.segcod))
          into lc_SegmntoActual
          from sngc60 a, sngc07 b
         where a.sngc60pais = ln_pais
           and a.sngc60tdoc = ln_tdoc
           and a.sngc60ndoc = lc_nrodoc
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select to_number(trim(b.segcod))
              into lc_SegmntoActual
              from sngc60 a, sngc07 b
             where a.sngc60pais = ln_pais
               and a.sngc60tdoc = ln_tdoc
               and a.sngc60ndoc = lc_nrodoc
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = ln_pais
                       and a.sngc60tdoc = ln_tdoc
                       and a.sngc60ndoc = lc_nrodoc
                       and a.sngc60ocup = b.sngc07cod);
          end;
        when others then
          null;
        
      end;
    
    else
      if ln_tdoc = 9 then
        lc_SegmntoActual := 1;
      end if;
    end if;
  
  end sp_cr_SegmntoActual;

  --------------------------------------------
  procedure sp_cr_ratio(ln_Instancia     in number,
                        lc_SegmntoActual in number,
                        lc_indicador     out varchar2) is
  
    ln_ratio     number(10, 6) := 0.00;
    ln_nreg      number := 0;
    ln_pais      number := 0;
    ln_tdoc      number := 0;
    ln_ndoc      varchar2(12);
    ld_fsist     date;
    ln_tipocamb  number(10, 6) := 1;
    ln_capcaja   number(17, 2) := 0.00;
    ln_deudaifis number(17, 2) := 0.00;
    ln_resneto   number(17, 2) := 0.00;
    ln_nroExcp   number := 0;
    ln_VALIDAR_CIUU varchar(3);
  
  begin
  
    lc_indicador := 'N';
    --return;
  
    if lc_SegmntoActual = 1 then
    
      begin
        select count(*)
          into ln_nreg
          from jaqy140b j
         where j.jaqy140inst = ln_Instancia
           and j.jaqy140est = 'H';
        --valor debe ser menor de 0.8
      exception
        when others then
          ln_nreg := 0;
      end;
    
      if ln_nreg > 0 then
      
        begin
          select j.jaqy140ratio
            into ln_ratio
            from jaqy140b j
           where j.jaqy140inst = ln_Instancia
             and j.jaqy140est = 'H';
          --valor debe ser menor de 0.8
        exception
          when others then
            lc_indicador := 'S';
        end;
        -- 30.03.2022 - HSUAREZ AGREGANDO VALIDACION SEGMENTACION 0.75
        PQ_CR_RATIOS_REPROCAP.SP_VALIDAR_CIUU(ln_Instancia,
                                                  ln_VALIDAR_CIUU
                                                  );  
        if (ln_ratio > 0.75 or ln_ratio <= 0) AND ln_VALIDAR_CIUU='S' then
              begin
                select count(*)
                  into ln_nroExcp
                  from fst198
                 where Tp1cod = 1
                   and Tp1cod1 = 10823
                   and Tp1corr1 = 9
                   and Tp1corr2 = 4
                   and Tp1nro1 = ln_Instancia;
              end;
            
              if ln_nroExcp = 0 then
                lc_indicador := 'S';
                RETURN;
              else
                lc_indicador := 'N';
              end if;
            else
              lc_indicador := 'N';
            
        end if;
        --FIN 30.03.2022
        
        if ln_ratio > 0.8 or ln_ratio <= 0 then
        
          begin
            select count(*)
              into ln_nroExcp
              from fst198
             where Tp1cod = 1
               and Tp1cod1 = 10823
               and Tp1corr1 = 9
               and Tp1corr2 = 4
               and Tp1nro1 = ln_Instancia;-- mpostigoc INC3755
          end;
        
          if ln_nroExcp = 0 then
            lc_indicador := 'S';
          else
            lc_indicador := 'N';
          end if;
        else
          lc_indicador := 'N';
        end if;
      
      else
        if ln_nreg = 0 then
        
          begin
            select s.sng001pais, s.sng001tdoc, s.sng001ndoc
              into ln_pais, ln_tdoc, ln_ndoc
              from sng001 s
             where s.sng001inst = ln_Instancia;
          end;
        
          begin
            select f.pgfape into ld_fsist from fst017 f where f.pgcod = 1;
          end;
        
          begin
            ln_tipocamb := fn_tipo_cambio_fijo(P_FECHA => ld_fsist);
          end;
        
          if ln_pais > 0 then
            pq_cr_ratiopyme_neval.sp_InicioRatio(ln_Pepais     => ln_pais,
                                                 ln_Petdoc     => ln_tdoc,
                                                 ln_Pendoc     => ln_ndoc,
                                                 tipocambio    => ln_tipocamb,
                                                 Instancia     => ln_Instancia,
                                                 pd_fecpro     => ld_fsist,
                                                 lc_Usuario    => 'BANTPROD',
                                                 ln_captotcaja => ln_capcaja,
                                                 saldo_externo => ln_deudaifis,
                                                 ResultNeto    => ln_resneto,
                                                 ln_captotal   => ln_ratio);
            -- 30.03.2022 - HSUAREZ AGREGANDO VALIDACION SEGMENTACION 0.75
            PQ_CR_RATIOS_REPROCAP.SP_VALIDAR_CIUU(ln_Instancia,
                                                  ln_VALIDAR_CIUU
                                                  );  
            if (ln_ratio > 0.75 or ln_ratio <= 0)  AND ln_VALIDAR_CIUU='S' then
              begin
                select count(*)
                  into ln_nroExcp
                  from fst198
                 where Tp1cod = 1
                   and Tp1cod1 = 10823
                   and Tp1corr1 = 9
                   and Tp1corr2 = 4
                   and Tp1nro1 = ln_Instancia;
              end;
            
              if ln_nroExcp = 0 then
                lc_indicador := 'S';
                RETURN;
              else
                lc_indicador := 'N';
              end if;
            else
              lc_indicador := 'N';
            
            end if;
            --FIN 30.03.2022  
                                                                                    
            if ln_ratio > 0.8 or ln_ratio <= 0 then
              begin
                select count(*)
                  into ln_nroExcp
                  from fst198
                 where Tp1cod = 1
                   and Tp1cod1 = 10823
                   and Tp1corr1 = 9
                   and Tp1corr2 = 4
                   and Tp1nro1 = ln_Instancia;
              end;
            
              if ln_nroExcp = 0 then
                lc_indicador := 'S';
              else
                lc_indicador := 'N';
              end if;
            else
              lc_indicador := 'N';
            
            end if;
          end if;
        end if;
      end if;
    
    elsif lc_SegmntoActual = 2 then
    
      begin
        select count(*)
          into ln_nreg
          from jaqz821b j
         where j.jaqz821inst = ln_Instancia
           and j.jaqz821est = 'H';
        --valor debe ser menor de 0.9
      exception
        when others then
          ln_nreg := 0;
      end;
    
      if ln_nreg > 0 then
      
        begin
          select j.jaqz821ratio
            into ln_ratio
            from jaqz821b j
           where j.jaqz821inst = ln_Instancia
             and j.jaqz821est = 'H';
          --valor debe ser menor de 0.9
        exception
          when others then
            lc_indicador := 'S';
        end;
        -- 30.03.2022 - HSUAREZ AGREGANDO VALIDACION SEGMENTACION 0.75
        PQ_CR_RATIOS_REPROCAP.SP_VALIDAR_CIUU(ln_Instancia, 
                                                  ln_VALIDAR_CIUU
                                                  );  
        if (ln_ratio > 0.75 or ln_ratio <= 0)  AND ln_VALIDAR_CIUU='S' then --
              begin
                select count(*)
                  into ln_nroExcp
                  from fst198
                 where Tp1cod = 1
                   and Tp1cod1 = 10823
                   and Tp1corr1 = 9
                   and Tp1corr2 = 4
                   and Tp1nro1 = ln_Instancia;
              end;
            
              if ln_nroExcp = 0 then
                lc_indicador := 'S';
                RETURN;
              else
                lc_indicador := 'N';
              end if;
            else
              lc_indicador := 'N';
            
        end if;
        -- FIN. 30.03.2022
            
        if ln_ratio > 0.9 or ln_ratio <= 0 then
          begin
            select count(*)
              into ln_nroExcp
              from fst198
             where Tp1cod = 1
               and Tp1cod1 = 10823
               and Tp1corr1 = 9
               and Tp1corr2 = 4
               and Tp1nro1 = ln_Instancia;
          end;
        
          if ln_nroExcp = 0 then
            lc_indicador := 'S';
          else
            lc_indicador := 'N';
          end if;
        else
          lc_indicador := 'N';
        end if;
      
      else
        if ln_nreg = 0 then
        
          begin
            select s.sng001pais, s.sng001tdoc, s.sng001ndoc
              into ln_pais, ln_tdoc, ln_ndoc
              from sng001 s
             where s.sng001inst = ln_Instancia;
          end;
        
          begin
            select f.pgfape into ld_fsist from fst017 f where f.pgcod = 1;
          end;
        
          begin
            ln_tipocamb := fn_tipo_cambio_fijo(P_FECHA => ld_fsist);
          end;
        
          if ln_pais > 0 then
            pq_cr_ratiocnsm_neval.sp_CalculoRatio(ln_Pepais        => ln_pais,
                                                  ln_Petdoc        => ln_tdoc,
                                                  ln_Pendoc        => ln_ndoc,
                                                  tipocambio       => ln_tipocamb,
                                                  Instancia        => ln_Instancia,
                                                  pd_fecpro        => ld_fsist,
                                                  ln_Usuario       => 'BANTPROD',
                                                  ln_captotcaja    => ln_capcaja,
                                                  saldo_externo    => ln_deudaifis,
                                                  ln_ExcdntMensual => ln_resneto,
                                                  ln_RatioConsumo  => ln_ratio);
            -- 30.03.2022 - HSUAREZ AGREGANDO VALIDACION SEGMENTACION 0.75                                                  
            PQ_CR_RATIOS_REPROCAP.SP_VALIDAR_CIUU(ln_Instancia,
                                                  ln_VALIDAR_CIUU
                                                  );  
            if (ln_ratio > 0.75 or ln_ratio <= 0)  AND ln_VALIDAR_CIUU='S' then
              begin
                select count(*)
                  into ln_nroExcp
                  from fst198
                 where Tp1cod = 1
                   and Tp1cod1 = 10823
                   and Tp1corr1 = 9
                   and Tp1corr2 = 4
                   and Tp1nro1 = ln_Instancia;
              end;
            
              if ln_nroExcp = 0 then
                lc_indicador := 'S';
                RETURN;
              else
                lc_indicador := 'N';
              end if;
            else
              lc_indicador := 'N';
            
            end if;  
            --FIN 30.03.2022                                                                                      
            if ln_ratio > 0.9 or ln_ratio <= 0 then
            
              begin
                select count(*)
                  into ln_nroExcp
                  from fst198
                 where Tp1cod = 1
                   and Tp1cod1 = 10823
                   and Tp1corr1 = 9
                   and Tp1corr2 = 4
                   and Tp1nro1 = ln_Instancia;
              end;
            
              if ln_nroExcp = 0 then
                lc_indicador := 'S';
              else
                lc_indicador := 'N';
              end if;
            else
              lc_indicador := 'N';
            end if;
          end if;
        end if;
      end if;
    
    else
      lc_indicador := 'S';
    end if;
  
  end sp_cr_ratio;
  --OBTENER DOCUMENTO TITULAR
  PROCEDURE SP_VALIDAR_CIUU(VE_INSTANCIA number,
                            VE_RPTA out varchar
                            ) is
  VI_CUENTA fsr008.ctnro%type;
  vi_PEPAIS fsr008.pepais%type;
  vi_PETDOC fsr008.petdoc%type;
  vi_PENDOC fsr008.pendoc%type;
  vi_cantidad NUMBER;                           
  BEGIN
       --OBTENER CUENTA
       BEGIN
         SELECT  XWFCUENTA
           INTO  VI_CUENTA
           FROM  XWF700
          WHERE  XWFPRCINS = VE_INSTANCIA
           AND XWFCAR3='1';
       END;
       --OBTENER DOCUMENTOS
       BEGIN
         SELECT PEPAIS, PETDOC, PENDOC
           INTO vi_PEPAIS,vi_PETDOC,vi_PENDOC
           FROM FSR008
          WHERE CTNRO = VI_CUENTA
           AND CTTFIR = 'T';
       END;
       --VALIDAR RATIO
       IF vi_PETDOC = 9 THEN
           ---juridica - Poli 174: Ratio hasta 75% MYPE
           vi_cantidad := 0;
           BEGIN
            select count(*)
            into vi_cantidad
            from fst198 f
            where f.tp1cod   = 1 
              and f.tp1cod1  = 11157
              and f.tp1corr1 = 2
              and f.tp1corr2 = 1
              and f.tp1nro1  = 1
              and f.tp1nro2 in 
                   (Select e.expnins--, e.* -- ciuu empresa
                    From fse001 e, sng001 s
                   Where s.sng001inst = VE_INSTANCIA
                     and e.d511pais = s.sng001pais
                     And e.d511tdoc = s.sng001tdoc
                     And e.d511ndoc = s.sng001ndoc);
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
        ELSE    
            --fisica - Poli 174: Ratio hasta 75% MYPE
            vi_cantidad  := 0;
            BEGIN
              select count(*)
              into vi_cantidad
              from fst198 f
              where f.tp1cod   = 1 
                and f.tp1cod1  = 11157
                and f.tp1corr1 = 2
                and f.tp1corr2 = 1
                and f.tp1nro1  = 1
                and f.tp1nro2 in 
                    (Select c60.sngc60acte--, c60.* --
                      From sngc60 c60, sng001 s
                     Where s.sng001inst = VE_INSTANCIA
                       and c60.sngc60pais = s.sng001pais
                       And c60.sngc60tdoc = s.sng001tdoc
                       And c60.sngc60ndoc = s.sng001ndoc
                       And c60.sngc60corr in (
                            Select max(c.sngc60corr)
                                  From sngc60 c, sng001 t
                                 Where t.sng001inst = s.sng001inst
                                   and c.sngc60pais = t.sng001pais
                                   And c.sngc60tdoc = t.sng001tdoc
                                   And c.sngc60ndoc = t.sng001ndoc));
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
        END IF;
        if vi_cantidad > 0 then
           VE_RPTA := 'S';
        ELSE
           VE_RPTA := 'N';   
        end if;     
  END;                            

end PQ_CR_RATIOS_REPROCAP;
/

