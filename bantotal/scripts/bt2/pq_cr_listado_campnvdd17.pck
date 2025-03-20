create or replace package PQ_CR_LISTADO_CAMPNVDD17 is

  -- Author  : MPOSTIGOC
  -- Created : 28/09/2017 06:44:01 p.m.
  -- Purpose : 
  procedure sp_cr_inicio(lc_digito in varchar2);
  procedure sp_cr_DeudaPyme(ln_Petdoc          in number,
                            ln_Pendoc          in varchar2,
                            ld_FechaDesembolso in date,
                            ln_EndeudDesemb    out number,
                            ln_EndeudActual    out number);
  procedure sp_Tipo_Doc_SBS(ln_tdoc  in number,
                            lc_tndoc in varchar2,
                            C_TDOCID out varchar);
  Procedure sp_cr_cargaCuoIm_job;

end PQ_CR_LISTADO_CAMPNVDD17;
/

create or replace package body PQ_CR_LISTADO_CAMPNVDD17 is

  procedure sp_cr_inicio(lc_digito in varchar2) is
  
    cursor listado is
    
      select *
        from jaqz801 j
       where to_char(substr(trim(jaqz801cta), -1, 1)) = lc_digito;
    -- where j.jaqz801inst = 1873838;
  
    --ln_instancia          number;
    ld_fchsist               date;
    ln_tipocamb              number;
    LN_CapCaja               number;
    ln_SaldExter             number;
    ln_ResNeto               number;
    ln_Ratio                 number(17, 6);
    ld_fchdesem              date;
    ln_EndeudDesemb          number;
    ln_EndeudActual          number;
    ln_SegmentacionMicro     number;
    Lc_NroDoc                character(12);
    valor1                   number := 0.8;
    ln_MntPrpst              number;
    nvalor                   number;
    nratio                   number;
    ln_mnt1                  number;
    ln_MntAdicional          number;
    ln_MntActFijo            number;
    ln_MntActFijo12          number;
    ln_MntCapTrabj           number;
    lc_DescSegmentacionMicro varchar2(50);
    lc_sexo                  varchar2(2);
    ln_TipVivienda           number;
    lc_DescTipViv            varchar2(25);
    ln_MntCrdPnt             number;
    ln_MntCrdOfi             number;
    ln_MntSupMjr             number;
  
  begin
    for l in listado loop
    
      ln_MntAdicional := 0;
      ln_MntActFijo   := 0;
      ln_MntActFijo12 := 0;
      ln_MntCapTrabj  := 0;
    
      begin
        -- Fecha de Sistema
        select pgfape into ld_fchsist from fst017 where pgcod = 1;
      end;
    
      begin
        -- Tipo de Cambio
        select s.sng120tcbi
          into ln_tipocamb
          from sng120 s
         where s.sng120ins = l.jaqz801inst
           and s.SNG120Tsk = 'EVALUACION';
      exception
        when others then
          ln_tipocamb := 0;
      end;
    
      begin
        -- Calculo Ratio
        pq_cr_resolutor_cappago.sp_cuentas(ln_Pepais     => l.jaqz801pais,
                                           ln_Petdoc     => l.jaqz801petdoc,
                                           ln_Pendoc     => l.jaqz801ndoc,
                                           tipocambio    => ln_tipocamb,
                                           Instancia     => l.jaqz801inst,
                                           pd_fecpro     => ld_fchsist,
                                           lc_prgm       => 'NAVIDAD',
                                           ln_captotcaja => LN_CapCaja,
                                           saldo_externo => ln_SaldExter,
                                           ResultNeto    => ln_ResNeto,
                                           ln_captotal   => ln_Ratio);
      end;
    
      begin
        -- Fecha de Desembolso
        select f.aofval
          into ld_fchdesem
          from fsd010 f
         where f.pgcod = l.jaqz801pgcod
           and f.aomod = l.jaqz801mod
           and f.aosuc = l.jaqz801suc
           and f.aomda = l.jaqz801mda
           and f.aopap = l.jaqz801pap
           and f.aocta = l.jaqz801cta
           and f.aooper = l.jaqz801oper
           and f.aosbop = l.jaqz801sbop
           and f.aotope = l.jaqz801tope;
      exception
        when others then
          null;
      end;
    
      begin
        -- Calcula Endeudamiento Pyme en el Desembolso y Actual
        PQ_CR_LISTADO_CAMPNVDD17.sp_cr_DeudaPyme(ln_Petdoc          => l.jaqz801petdoc,
                                                 ln_Pendoc          => l.jaqz801ndoc,
                                                 ld_FechaDesembolso => ld_fchdesem,
                                                 ln_EndeudDesemb    => ln_EndeudDesemb,
                                                 ln_EndeudActual    => ln_EndeudActual);
      
      end; -- Fin Calcula Endeudamiento Pyme en el Desembolso y Actual
    
      Lc_NroDoc := rpad(l.jaqz801ndoc, 12, ' ');
    
      begin
      
        begin
          begin
            -- Call the procedure
            pq_cr_segmentacion_micro.sp_carga_data(pd_fecpro => ld_fchsist, --IN:fecha de proceso
                                                   pn_pai    => l.jaqz801pais, --IN:pais
                                                   pn_tdo    => l.jaqz801petdoc, --IN:tipo de documento
                                                   pc_doc    => l.jaqz801ndoc, --IN:numero de documento
                                                   pc_usr    => 'BANTPROD'); --IN:usuario logeado
          end;
          begin
            select j.jaqz657calf, h.jaqz658ncal
              into ln_SegmentacionMicro, lc_DescSegmentacionMicro
              from JAQZ657 j, JAQZ658 h
             where j.jaqz657paic = l.jaqz801pais
               and j.jaqz657tdoc = l.jaqz801petdoc
               and j.jaqz657tndoc = l.jaqz801ndoc
               and j.jaqz657calf = h.jaqz658ccal;
          exception
            when others then
              null;
          end;
        end;
      end;
      -- Sexo
      begin
        select PFCANT
          into lc_sexo
          from fsd002 f
         where f.pfpais = l.jaqz801pais
           and f.pftdoc = l.jaqz801petdoc
           and f.pfndoc = l.jaqz801ndoc;
      exception
        when others then
          null;
        
      end;
    
      begin
      
        select to_number(c.sngc12vivc) --,d.sngc12dsc -- Tipo de Vivienda Legal
          into ln_TipVivienda --, lc_DescTipViv
          from sngc13 c, sngc12 d
         where c.sngc13pais = l.jaqz801pais
           and c.sngc13tdoc = l.jaqz801petdoc
           and c.sngc13ndoc = l.jaqz801ndoc
           and c.docod = 1
           and c.sngc13est = 'H'
           and c.sngc12vivc = d.sngc12vivc;
      exception
        when others then
          null;
      end;
    
      nvalor  := nvl(valor1, 0);
      nratio  := nvl(ln_Ratio, 0);
      ln_mnt1 := nvalor - nratio;
    
      if ln_Ratio >= 0 and ln_Ratio <= 0.6 then
      
        begin
          -- Monto Propuesto        
          -- ln_MntPrpst := valor1 * ln_ResNeto * 18;  --victor lo pidio a 15 emses 13/09/18
          ln_MntPrpst := valor1 * ln_ResNeto * 15;
        
        end;
      
      else
        ln_MntPrpst := 0;
      end if;
    
      /*  ln_mnt1       := nvalor - nratio;
        ln_MntActFijo := valor1 * ln_ResNeto * 15;
      
        -- Monto Capital de Trabajo
      
        ln_mnt1        := nvalor - nratio;
        ln_MntCapTrabj := valor1 * ln_ResNeto * 15;
      
        --    end if;
      */
      if lc_sexo = 'F' and ln_TipVivienda in (1, 6, 7) then
        -- Femenino Familiar
        lc_DescTipViv := 'FAMILIAR';
        if ln_SegmentacionMicro = 4 then
          -- Nuevo
          if ln_MntPrpst > 4000 then
            ln_MntCrdPnt := 4000;
            ln_MntCrdOfi := 4000;
            ln_MntSupMjr := 4000;
          else
            ln_MntCrdPnt := ln_MntPrpst;
            ln_MntCrdOfi := ln_MntPrpst;
            ln_MntSupMjr := ln_MntPrpst;
          
          end if;
        
          /* if ln_MntPrpst > 3500 then
            -- CrediPuntualito        
            ln_MntCrdPnt := 3500;
            --ln_MntPrpst  := 3500;
          else
            ln_MntCrdPnt := ln_MntPrpst;
          end if;
          
          if ln_MntPrpst > 3500 then
            -- CrediOficio
            ln_MntCrdOfi := 3500;
            --ln_MntActFijo := 3500;
          else
            ln_MntCrdOfi := ln_MntPrpst;
          end if;
          
          if ln_MntPrpst > 2500 then
            -- Superate Mujer
            ln_MntSupMjr := 2500;
          else
            ln_MntSupMjr := ln_MntPrpst;
          end if;*/
        
        else
          if ln_SegmentacionMicro = 3 then
            -- Recurrente
            if ln_MntPrpst > 6000 then
              ln_MntCrdPnt := 6000;
              ln_MntCrdOfi := 6000;
              ln_MntSupMjr := 6000;
            else
              ln_MntCrdPnt := ln_MntPrpst;
              ln_MntCrdOfi := ln_MntPrpst;
              ln_MntSupMjr := ln_MntPrpst;
            
            end if;
          
            /*if ln_MntPrpst > 1500 then
              -- CrediPuntualito        
              ln_MntCrdPnt := 1500;
              --  ln_MntPrpst  := 1500;
            else
              ln_MntCrdPnt := ln_MntPrpst;
            end if;
            
            if ln_MntPrpst > 6000 then
              -- CrediOficio
              ln_MntCrdOfi := 6000;
              --  ln_MntActFijo := 6000;
            else
              ln_MntCrdOfi := ln_MntPrpst;
            end if;
            
            if ln_MntPrpst > 4500 then
              -- Superate Mujer
              ln_MntSupMjr := 4500;
            else
              ln_MntSupMjr := ln_MntPrpst;
            end if;*/
          
          else
            if ln_SegmentacionMicro = 2 then
              -- Preferencial
              if ln_MntPrpst > 8000 then
                ln_MntCrdPnt := 8000;
                ln_MntCrdOfi := 8000;
                ln_MntSupMjr := 8000;
              else
                ln_MntCrdPnt := ln_MntPrpst;
                ln_MntCrdOfi := ln_MntPrpst;
                ln_MntSupMjr := ln_MntPrpst;
              
              end if;
              /*
              if ln_MntPrpst > 7000 then
                -- CrediPuntualito        
                ln_MntCrdPnt := 7000;
                --   ln_MntPrpst  := 7000;
              else
                ln_MntCrdPnt := ln_MntPrpst;
              end if;
              
              if ln_MntPrpst > 6500 then
                -- CrediOficio
                ln_MntCrdOfi := 6500;
                --  ln_MntActFijo := 6500;
              else
                ln_MntCrdOfi := ln_MntPrpst;
              end if;
              
              if ln_MntPrpst > 7500 then
                -- Superate Mujer
                ln_MntSupMjr := 7500;
              else
                ln_MntSupMjr := ln_MntPrpst;
              end if;*/
            
            else
              if ln_SegmentacionMicro = 1 then
                -- Premium
                if ln_MntPrpst > 15000 then
                  ln_MntCrdPnt := 15000;
                  ln_MntCrdOfi := 15000;
                  ln_MntSupMjr := 15000;
                else
                  ln_MntCrdPnt := ln_MntPrpst;
                  ln_MntCrdOfi := ln_MntPrpst;
                  ln_MntSupMjr := ln_MntPrpst;
                
                end if;
                /*if ln_MntPrpst > 15000 then
                  -- CrediPuntualito        
                  ln_MntCrdPnt := 15000;
                  --    ln_MntPrpst  := 15000;
                else
                  ln_MntCrdPnt := ln_MntPrpst;
                end if;
                
                if ln_MntPrpst > 12000 then
                  -- CrediOficio
                  ln_MntCrdOfi := 12000;
                  --  ln_MntActFijo := 12000;
                else
                  ln_MntCrdOfi := ln_MntPrpst;
                end if;
                
                if ln_MntPrpst > 11000 then
                  -- Superate Mujer
                  ln_MntSupMjr := 11000;
                else
                  ln_MntSupMjr := ln_MntPrpst;
                end if;*/
              
              end if;
            end if;
          end if;
        end if;
      end if;
    
      if lc_sexo = 'M' and ln_TipVivienda in (1, 6, 7) then
        -- Femenino Familiar
        lc_DescTipViv := 'FAMILIAR';
        if ln_SegmentacionMicro = 4 then
          -- Nuevo
          if ln_MntPrpst > 4000 then
            ln_MntCrdPnt := 4000;
            ln_MntCrdOfi := 4000;
            ln_MntSupMjr := 0;
          else
            ln_MntCrdPnt := ln_MntPrpst;
            ln_MntCrdOfi := ln_MntPrpst;
            ln_MntSupMjr := 0;
          
          end if;
          /* if ln_MntPrpst > 3500 then
            -- CrediPuntualito        
            ln_MntCrdPnt := 3500;
            -- ln_MntPrpst  := 3500;
          else
            ln_MntCrdPnt := ln_MntPrpst;
          end if;
          
          if ln_MntPrpst > 3500 then
            -- CrediOficio
            ln_MntCrdOfi := 3500;
            -- ln_MntActFijo := 3500;
          else
            ln_MntCrdOfi := ln_MntPrpst;
          end if;
          
          if ln_MntPrpst > 2500 then
            -- Superate Mujer
            ln_MntSupMjr := 0;
          else
            ln_MntSupMjr := 0;
          end if;*/
        
        else
          if ln_SegmentacionMicro = 3 then
            -- Recurrente
            if ln_MntPrpst > 6000 then
              ln_MntCrdPnt := 6000;
              ln_MntCrdOfi := 6000;
              ln_MntSupMjr := 0;
            else
              ln_MntCrdPnt := ln_MntPrpst;
              ln_MntCrdOfi := ln_MntPrpst;
              ln_MntSupMjr := 0;
            
            end if;
            /* if ln_MntPrpst > 1500 then
              -- CrediPuntualito        
              ln_MntCrdPnt := 1500;
              --   ln_MntPrpst  := 1500;
            else
              ln_MntCrdPnt := ln_MntPrpst;
            end if;
            
            if ln_MntPrpst > 6000 then
              -- CrediOficio
              ln_MntCrdOfi := 6000;
              --   ln_MntActFijo := 6000;
            else
              ln_MntCrdOfi := ln_MntPrpst;
            end if;
            
            if ln_MntPrpst > 4500 then
              -- Superate Mujer
              ln_MntSupMjr := 0;
            else
              ln_MntSupMjr := 0;
            end if;*/
          
          else
            if ln_SegmentacionMicro = 2 then
              -- Preferencial
              if ln_MntPrpst > 8000 then
                ln_MntCrdPnt := 8000;
                ln_MntCrdOfi := 8000;
                ln_MntSupMjr := 0;
              else
                ln_MntCrdPnt := ln_MntPrpst;
                ln_MntCrdOfi := ln_MntPrpst;
                ln_MntSupMjr := 0;
              
              end if;
              /*if ln_MntPrpst > 7000 then
                -- CrediPuntualito        
                ln_MntCrdPnt := 7000;
                --     ln_MntPrpst  := 7000;
              else
                ln_MntCrdPnt := ln_MntPrpst;
              end if;
              
              if ln_MntPrpst > 6500 then
                -- CrediOficio
                ln_MntCrdOfi := 6500;
                --   ln_MntActFijo := 6500;
              else
                ln_MntCrdOfi := ln_MntPrpst;
              end if;
              
              if ln_MntPrpst > 7500 then
                -- Superate Mujer
                ln_MntSupMjr := 0;
              else
                ln_MntSupMjr := 0;
              end if;*/
            
            else
              if ln_SegmentacionMicro = 1 then
                -- Premium
                if ln_MntPrpst > 15000 then
                  ln_MntCrdPnt := 15000;
                  ln_MntCrdOfi := 15000;
                  ln_MntSupMjr := 0;
                else
                  ln_MntCrdPnt := ln_MntPrpst;
                  ln_MntCrdOfi := ln_MntPrpst;
                  ln_MntSupMjr := 0;
                
                end if;
                /*if ln_MntPrpst > 15000 then
                  -- CrediPuntualito        
                  ln_MntCrdPnt := 15000;
                  --  ln_MntPrpst  := 15000;
                else
                  ln_MntCrdPnt := ln_MntPrpst;
                end if;
                
                if ln_MntPrpst > 12000 then
                  -- CrediOficio
                  ln_MntCrdOfi := 12000;
                  --  ln_MntActFijo := 12000;
                else
                  ln_MntCrdOfi := ln_MntPrpst;
                end if;
                
                if ln_MntPrpst > 11000 then
                  -- Superate Mujer
                  ln_MntSupMjr := 0;
                else
                  ln_MntSupMjr := 0;
                end if;*/
              
              end if;
            end if;
          end if;
        end if;
      end if;
    
      if lc_sexo = 'F' and ln_TipVivienda in (2, 3, 4) then
        -- Femenino Familiar
        lc_DescTipViv := 'INQUILINO';
        if ln_SegmentacionMicro = 4 then
          -- Nuevo
          if ln_MntPrpst > 2000 then
            ln_MntCrdPnt := 2000;
            ln_MntCrdOfi := 2000;
            ln_MntSupMjr := 2000;
          else
            ln_MntCrdPnt := ln_MntPrpst;
            ln_MntCrdOfi := ln_MntPrpst;
            ln_MntSupMjr := ln_MntPrpst;
          
          end if;
          /*if ln_MntPrpst > 2500 then
              -- CrediPuntualito        
              ln_MntCrdPnt := 2500;
              -- ln_MntPrpst  := 2500;
            else
              ln_MntCrdPnt := ln_MntPrpst;
            end if;
          
            if ln_MntPrpst > 2000 then
              -- CrediOficio
              ln_MntCrdOfi := 2000;
              --  ln_MntActFijo := 2000;
            else
              ln_MntCrdOfi := ln_MntPrpst;
            end if;
          
            if ln_MntPrpst > 2000 then
              -- Superate Mujer
              ln_MntSupMjr := 2000;
            else
              ln_MntSupMjr := ln_MntPrpst;
            end if;
          */
        else
          if ln_SegmentacionMicro = 3 then
            -- Recurrente
            if ln_MntPrpst > 4000 then
              ln_MntCrdPnt := 4000;
              ln_MntCrdOfi := 4000;
              ln_MntSupMjr := 4000;
            else
              ln_MntCrdPnt := ln_MntPrpst;
              ln_MntCrdOfi := ln_MntPrpst;
              ln_MntSupMjr := ln_MntPrpst;
            
            end if;
          
            /*if ln_MntPrpst > 3000 then
              -- CrediPuntualito        
              ln_MntCrdPnt := 3000;
              --  ln_MntPrpst  := 3000;
            else
              ln_MntCrdPnt := ln_MntPrpst;
            end if;
            
            if ln_MntPrpst > 3000 then
              -- CrediOficio
              ln_MntCrdOfi := 3000;
              -- ln_MntActFijo := 3000;
            else
              ln_MntCrdOfi := ln_MntPrpst;
            end if;
            
            if ln_MntPrpst > 2500 then
              -- Superate Mujer
              ln_MntSupMjr := 2500;
            else
              ln_MntSupMjr := ln_MntPrpst;
            end if;*/
          
          else
            if ln_SegmentacionMicro = 2 then
              -- Preferencial
              if ln_MntPrpst > 5000 then
                ln_MntCrdPnt := 5000;
                ln_MntCrdOfi := 5000;
                ln_MntSupMjr := 5000;
              else
                ln_MntCrdPnt := ln_MntPrpst;
                ln_MntCrdOfi := ln_MntPrpst;
                ln_MntSupMjr := ln_MntPrpst;
              
              end if;
              /*
                if ln_MntPrpst > 4000 then
                  -- CrediPuntualito        
                  ln_MntCrdPnt := 4000;
                  --   ln_MntPrpst  := 4000;
                else
                  ln_MntCrdPnt := ln_MntPrpst;
                end if;
              
                if ln_MntPrpst > 3500 then
                  -- CrediOficio
                  ln_MntCrdOfi := 3500;
                  -- ln_MntActFijo := 3500;
                else
                  ln_MntCrdOfi := ln_MntPrpst;
                end if;
              
                if ln_MntPrpst > 2500 then
                  -- Superate Mujer
                  ln_MntSupMjr := 2500;
                else
                  ln_MntSupMjr := ln_MntPrpst;
                end if;
              */
            else
              if ln_SegmentacionMicro = 1 then
                -- Premium
                if ln_MntPrpst > 10000 then
                  ln_MntCrdPnt := 10000;
                  ln_MntCrdOfi := 10000;
                  ln_MntSupMjr := 10000;
                else
                  ln_MntCrdPnt := ln_MntPrpst;
                  ln_MntCrdOfi := ln_MntPrpst;
                  ln_MntSupMjr := ln_MntPrpst;
                
                end if;
                /*
                  if ln_MntPrpst > 10000 then
                    -- CrediPuntualito        
                    ln_MntCrdPnt := 10000;
                    -- ln_MntPrpst  := 10000;
                  else
                    ln_MntCrdPnt := ln_MntPrpst;
                  end if;
                
                  if ln_MntPrpst > 9500 then
                    -- CrediOficio
                    ln_MntCrdOfi := 9500;
                    -- ln_MntActFijo := 9500;
                  else
                    ln_MntCrdOfi := ln_MntPrpst;
                  end if;
                
                  if ln_MntPrpst > 8000 then
                    -- Superate Mujer
                    ln_MntSupMjr := 8000;
                  else
                    ln_MntSupMjr := ln_MntPrpst;
                  end if;
                */
              end if;
            end if;
          end if;
        end if;
      end if;
    
      if lc_sexo = 'M' and ln_TipVivienda in (2, 3, 4) then
        -- Femenino Familiar
        lc_DescTipViv := 'INQUILINO';
        if ln_SegmentacionMicro = 4 then
          -- Nuevo
          if ln_MntPrpst > 2000 then
            ln_MntCrdPnt := 2000;
            ln_MntCrdOfi := 2000;
            ln_MntSupMjr := 0;
          else
            ln_MntCrdPnt := ln_MntPrpst;
            ln_MntCrdOfi := ln_MntPrpst;
            ln_MntSupMjr := 0;
          
          end if;
          /*
            if ln_MntPrpst > 2500 then
              -- CrediPuntualito        
              ln_MntCrdPnt := 2500;
              --  ln_MntPrpst  := 2500;
            else
              ln_MntCrdPnt := ln_MntPrpst;
            end if;
          
            if ln_MntPrpst > 2000 then
              -- CrediOficio
              ln_MntCrdOfi := 2000;
              -- ln_MntActFijo := 2000;
            else
              ln_MntCrdOfi := ln_MntPrpst;
            end if;
          
            if ln_MntPrpst > 2000 then
              -- Superate Mujer
              ln_MntSupMjr := 0;
            else
              ln_MntSupMjr := 0;
            end if;
          */
        else
          if ln_SegmentacionMicro = 3 then
            -- Recurrente
          
            if ln_MntPrpst > 4000 then
              ln_MntCrdPnt := 4000;
              ln_MntCrdOfi := 4000;
              ln_MntSupMjr := 0;
            else
              ln_MntCrdPnt := ln_MntPrpst;
              ln_MntCrdOfi := ln_MntPrpst;
              ln_MntSupMjr := 0;
            
            end if;
            /*
            if ln_MntPrpst > 3000 then
               -- CrediPuntualito        
               ln_MntCrdPnt := 3000;
               --  ln_MntPrpst  := 3000;
             else
               ln_MntCrdPnt := ln_MntPrpst;
             end if;
            
             if ln_MntPrpst > 3000 then
               -- CrediOficio
               ln_MntCrdOfi := 3000;
               -- ln_MntActFijo := 3000;
             else
               ln_MntCrdOfi := ln_MntPrpst;
             end if;
            
             if ln_MntPrpst > 2500 then
               -- Superate Mujer
               ln_MntSupMjr := 0;
             else
               ln_MntSupMjr := 0;
             end if;
             */
          
          else
            if ln_SegmentacionMicro = 2 then
              -- Preferencial
              if ln_MntPrpst > 5000 then
                ln_MntCrdPnt := 5000;
                ln_MntCrdOfi := 5000;
                ln_MntSupMjr := 0;
              else
                ln_MntCrdPnt := ln_MntPrpst;
                ln_MntCrdOfi := ln_MntPrpst;
                ln_MntSupMjr := 0;
              
              end if;
              /*
                if ln_MntPrpst > 4000 then
                  -- CrediPuntualito        
                  ln_MntCrdPnt := 4000;
                  --   ln_MntPrpst  := 4000;
                else
                  ln_MntCrdPnt := ln_MntPrpst;
                end if;
              
                if ln_MntPrpst > 3500 then
                  -- CrediOficio
                  ln_MntCrdOfi := 3500;
                  --  ln_MntActFijo := 3500;
                else
                  ln_MntCrdOfi := ln_MntPrpst;
                end if;
              
                if ln_MntPrpst > 2500 then
                  -- Superate Mujer
                  ln_MntSupMjr := 0;
                else
                  ln_MntSupMjr := 0;
                end if;
              */
            else
              if ln_SegmentacionMicro = 1 then
                -- Premium
                if ln_MntPrpst > 10000 then
                  ln_MntCrdPnt := 10000;
                  ln_MntCrdOfi := 10000;
                  ln_MntSupMjr := 0;
                else
                  ln_MntCrdPnt := ln_MntPrpst;
                  ln_MntCrdOfi := ln_MntPrpst;
                  ln_MntSupMjr := 0;
                
                end if;
                /*
                  if ln_MntPrpst > 10000 then
                    -- CrediPuntualito        
                    ln_MntCrdPnt := 10000;
                    --  ln_MntPrpst  := 10000;
                  else
                    ln_MntCrdPnt := ln_MntPrpst;
                  end if;
                
                  if ln_MntPrpst > 9500 then
                    -- CrediOficio
                    ln_MntCrdOfi := 9500;
                    --  ln_MntActFijo := 9500;
                  else
                    ln_MntCrdOfi := ln_MntPrpst;
                  end if;
                
                  if ln_MntPrpst > 8000 then
                    -- Superate Mujer
                    ln_MntSupMjr := 0;
                  else
                    ln_MntSupMjr := 0;
                  end if;
                */
              end if;
            end if;
          end if;
        end if;
      end if;
    
      begin
        update jaqz801 j
           set j.jaqz801fchprc    = ld_fchsist,
               j.jaqz801fdesmb    = ld_fchdesem,
               j.jaqz801dactual   = ln_EndeudActual,
               j.jaqz801ddesemb   = ln_EndeudDesemb,
               j.jaqz801resneto   = ln_ResNeto,
               j.jaqz801ratio     = ln_Ratio,
               j.jaqz801ultsegmnt = ln_SegmentacionMicro,
               j.jaqz801mntprp    = ln_MntPrpst,
               -- j.jaqz801mntactf   = ln_MntActFijo,
               ---  j.jaqz801mntactf12 = ln_MntActFijo12,
               -- j.jaqz801captrabj   = ln_MntCapTrabj,
               j.jaqz801descsegm   = lc_DescSegmentacionMicro,
               J.JAQZ801SEXO       = lc_sexo,
               J.JAQZ801MNTSUPMUJR = ln_MntSupMjr,
               J.JAQZ801MNTCRDPNTL = ln_MntCrdPnt,
               J.JAQZ801MNTCRDOFIC = ln_MntCrdOfi,
               j.jaqz801tipviv     = ln_TipVivienda,
               j.jaqz801dtipviv    = lc_DescTipViv,
               J.JAQZ801CAPCAJA    = LN_CapCaja,
               J.JAQZ801SLDEXT     = ln_SaldExter
         where j.jaqz801pgcod = l.jaqz801pgcod
           and j.jaqz801mod = l.jaqz801mod
           and j.jaqz801suc = l.jaqz801suc
           and j.jaqz801mda = l.jaqz801mda
           and j.jaqz801pap = l.jaqz801pap
           and j.jaqz801cta = l.jaqz801cta
           and j.jaqz801oper = l.jaqz801oper
           and j.jaqz801sbop = l.jaqz801sbop
           and j.jaqz801tope = l.jaqz801tope;
        commit;
      end;
    
    end loop;
  
  end sp_cr_inicio;
  -----------------------------------------------------------------------------
  -- Deuda Pyme del Mes de Desembolso

  procedure sp_cr_DeudaPyme(ln_Petdoc          in number,
                            ln_Pendoc          in varchar2,
                            ld_FechaDesembolso in date,
                            ln_EndeudDesemb    out number,
                            ln_EndeudActual    out number) is
  
    ln_FchRCC          number;
    D_FECPRE           varchar2(10);
    D_FECPRE1          date;
    ln_dia             number;
    ln_Mes             number;
    ln_Anio            number;
    ld_MesVeriFchDesem date;
    lc_codsbs          varchar2(10);
    ln_capital1        number;
    ln_capital2        number;
    lc_C_TDOCID        varchar2(2);
  
  begin
  
    begin
      -- Fecha RCC
      select Tpnro
        into ln_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    
      ln_dia  := SubStr(ln_FchRCC, 1, 2);
      ln_Mes  := SubStr(ln_FchRCC, 3, 2);
      ln_Anio := SubStr(ln_FchRCC, 5, 4);
    
      D_FECPRE  := ln_dia || '/' || ln_Mes || '/' || ln_Anio;
      D_FECPRE1 := to_date(D_FECPRE, 'dd/mm/rrrr');
    
    end;
  
    pq_cr_listado_campnvdd17.sp_Tipo_Doc_SBS(ln_Petdoc,
                                             ln_Pendoc,
                                             lc_C_TDOCID);
  
    begin
      select C_CODSBS -- para sacar el CodSBS
        into lc_codsbs
        from cldrcci
       where /*D_FECPRE = D_FECPRE1
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               and*/
       c_docide = ln_Pendoc
       and C_TDOCID = lc_C_TDOCID
       and rownum = 1;
    exception
      when others then
        null;
    end;
  
    ld_MesVeriFchDesem := last_day(ld_FechaDesembolso);
  
    begin
      --Calcula la Deuda RCC en el mes del Desembolso
      begin
        select nvl(sum(case
                         when substr(C_CUENTA, 1, 4) in
                              (1411,
                               1413,
                               1414,
                               1415,
                               1416,
                               1421,
                               1423,
                               1424,
                               1425,
                               1426,
                               7111,
                               7112,
                               7113,
                               7114,
                               7121,
                               7122,
                               7123,
                               7124) then
                          N_SALCAP
                       end),
                   0)
          into ln_capital1
          from CLDRCCS
         where D_FECPRE = ld_MesVeriFchDesem
           and c_codsbs = lc_codsbs
           and C_CRETIP in (select trim(tp1desc)
                              from FST198
                             Where Tp1cod = 1
                               and Tp1cod1 = 10871
                               and Tp1corr1 = 7
                               and tp1corr2 = 14); --  Micro y Pequeña Empresa
      end;
    
      begin
        select nvl(sum(case
                         when substr(C_CUENTA, 1, 6) in
                              (291101, 291102, 291104, 292101, 292102, 292104) then
                          N_SALCAP
                       end),
                   0)
          into ln_capital2
          from CLDRCCS
         where D_FECPRE = ld_MesVeriFchDesem
           and c_codsbs = lc_codsbs
           and C_TIPREG = 2
           and C_TIPDET = 'Z';
      end;
    
      ln_EndeudDesemb := ln_capital1 - ln_capital2;
    end; -- Fin Calcula la Deuda RCC en el mes del Desembolso
  
    begin
      -- Calcula la Deuda RCC Actual
      begin
        select nvl(sum(case
                         when substr(C_CUENTA, 1, 4) in
                              (1411,
                               1413,
                               1414,
                               1415,
                               1416,
                               1421,
                               1423,
                               1424,
                               1425,
                               1426,
                               7111,
                               7112,
                               7113,
                               7114,
                               7121,
                               7122,
                               7123,
                               7124) then
                          N_SALCAP
                       end),
                   0)
          into ln_capital1
          from CLDRCCS
         where D_FECPRE = D_FECPRE1
           and c_codsbs = lc_codsbs
           and C_CRETIP in (select trim(tp1desc)
                              from FST198
                             Where Tp1cod = 1
                               and Tp1cod1 = 10871
                               and Tp1corr1 = 7
                               and tp1corr2 = 14); --  Micro y Pequeña Empresa
      end;
    
      begin
        select nvl(sum(case
                         when substr(C_CUENTA, 1, 6) in
                              (291101, 291102, 291104, 292101, 292102, 292104) then
                          N_SALCAP
                       end),
                   0)
          into ln_capital2
          from CLDRCCS
         where D_FECPRE = D_FECPRE1
           and c_codsbs = lc_codsbs
           and C_TIPREG = 2
           and C_TIPDET = 'Z';
      end;
    
      ln_EndeudActual := ln_capital1 - ln_capital2;
    end; -- Fin Calcula la Deuda RCC Actual
  
  end sp_cr_DeudaPyme;
  ------------------------------------------------------------------------
  procedure sp_Tipo_Doc_SBS(ln_tdoc  in number,
                            lc_tndoc in varchar2,
                            C_TDOCID out varchar) is
  
    --  C_TDOCID char(1);
  
  Begin
    Begin
      C_TDOCID := '0';
    
      If ln_tdoc = 21 then
        C_TDOCID := '1';
      End If;
    
      If ln_tdoc = 9 then
        If Length(lc_tndoc) < 11 then
          C_TDOCID := '2';
        End If;
      
        If Length(lc_tndoc) >= 11 then
          C_TDOCID := '3';
        End If;
      End If;
    
      if C_TDOCID = '0' then
      
        If ln_tdoc = 2 then
          C_TDOCID := '2';
        ELSE
          If ln_tdoc = 4 then
            C_TDOCID := '3';
          else
            If ln_tdoc = 15 then
              C_TDOCID := '4';
            else
              If ln_tdoc = 5 then
                C_TDOCID := '5';
              else
                If ln_tdoc = 6 then
                  C_TDOCID := '8';
                End If;
              End If;
            End If;
          End If;
        End If;
      End If;
    
    End;
  
  end sp_Tipo_Doc_SBS;

  --------------------------------------------------------
  Procedure sp_cr_cargaCuoIm_job is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_LISTADO_CAMPNVDD17.sp_cr_inicio(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
--      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
IF SYS.FN_BD_ISRAC='TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_cargaCuoIm_job;

end PQ_CR_LISTADO_CAMPNVDD17;
/

