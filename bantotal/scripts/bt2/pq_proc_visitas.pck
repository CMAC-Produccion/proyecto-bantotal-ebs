create or replace package PQ_PROC_VISITAS is

  procedure SP_Fec_Proximo_vto (PN_EMP IN NUMBER,PN_MOD IN NUMBER,PN_SUC IN NUMBER,
                                PN_MDA IN NUMBER,PN_PAP IN NUMBER,PN_CTA IN  NUMBER,
                                PN_OPER IN NUMBER,PN_SBOP IN NUMBER,PN_TOP IN NUMBER,
                                PD_FECPRO IN DATE,pd_fecpxv OUT DATE);

 Procedure SP_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date,
                             ln_numcuotas out number );
 Procedure SP_Saldo_relacion(pn_emp in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pd_fecpro in date, pn_nrorel in number, 
                           pn_rubro in number, ln_saldo out number)         ;
 Procedure SP_PorcProv (pn_emp in number, pn_mod in number, /*pn_suc in number,*/ pn_mda in number,
                       pn_pap in number, pn_cta in number, pn_oper in number,
                       pn_sbop in number,pn_top in number, ln_porprov out number );                                               
 Procedure SP_cuotas_pendientes (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                                pn_pap in number, pn_cta in number, pn_oper in number,
                                pn_sbop in number,pn_top in number, pd_fecpro in date,
                                ln_cuotas out number );
 Procedure SP_categoria (pn_emp in number, pn_cta in number, pn_codcat in number,
                        lc_categoria out char, ld_fecCateg out Date ) ;                                                       

 Procedure SP_pa_instancia(pn_mod in number, pn_suc in number, pn_mda in number,
                         pn_pap in number, pn_cta in number, pn_oper in number,
                         pn_sbop in number,pn_top in number, ln_instancia out number) ;
 Procedure SP_dias_atraso(v_Pgfape in date,v_Pgcod  in number,v_Scmod  in number,
                         v_Scsuc  in number,v_Scmda  in number,v_Scpap  in number,
                         v_Sccta  in number,v_Scoper in number,v_Scsbop in number,
                         v_Sctope in number,v_Scstat in number,v_fecven in date,
                         ln_diatr out number
                       )           ;      
 Procedure SP_analista_credito(v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number,
                              lc_analista out varchar2
                             );
 Procedure SP_instancia_credito(v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               ln_instancia out sng001.sng001inst%type
                             ) ;    
 Procedure SP_cuotas_calen (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number,ln_numcuotas out number);
 Procedure SP_PromedioMora (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date,
                           ln_promM out number);
 Procedure SP_evaluacion (pn_instancia in number, pn_codigo in number, pn_tipo in number,
                         ln_valor out number);
 Procedure SP_NumAutorizacion (pn_instancia in number, ln_valor out number);      
 Procedure sp_ultima_evaluacion (pn_pais in number, pn_tdoc in number, pc_ndoc in char,
                                pd_feceva out date);    
 Procedure sp_sector_credito (v_fecpro in date,
                             v_pgcod  in number,
                             v_Scmod  in number,
                             v_Scsuc  in number,
                             v_Scmda  in number,
                             v_Scpap  in number,
                             v_Sccta  in number,
                             v_Scoper in number,
                             v_Scsbop in number,
                             v_Sctope in number,
                             sector   out number);  
  Procedure SP_fec_resolucion (pn_instancia in number,ld_fecreso out date);
  Procedure SP_FecSolicitud (pn_instancia in number,ld_fecsol out date);                                                                                                                                                                                       
end PQ_PROC_VISITAS;
/

create or replace package body PQ_PROC_VISITAS is

procedure SP_Fec_Proximo_vto 
(
PN_EMP       IN  NUMBER,
PN_MOD       IN  NUMBER,
PN_SUC       IN  NUMBER,
PN_MDA       IN  NUMBER,
PN_PAP       IN  NUMBER,
PN_CTA       IN  NUMBER,
PN_OPER      IN  NUMBER,
PN_SBOP      IN  NUMBER,
PN_TOP       IN  NUMBER,
PD_FECPRO    IN  DATE,
pd_fecpxv    OUT DATE

)
as


begin

  
  
  begin
          
    
    select /*+ parallel(n,2,1)*/
           min(n.ppfpag)
      into pd_fecpxv
      from fsd601 n
     where n.pgcod  = pn_emp
       and n.ppcta  = pn_cta
       and n.ppmda  = pn_mda
       and n.ppsuc  = pn_suc
       and n.pppap  = pn_pap
       and n.ppoper = pn_oper
       and n.ppsbop = pn_sbop
       and n.pptope = pn_top
       and n.ppmod  = pn_mod
       and n.d601co = 'S'
       and not exists
                (select ppmod, ppcta,ppoper, pptope,ppfpag
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T'
                    and o.d602co  = 'S');
  exception
      when no_data_found then
         pd_fecpxv := null;
      when too_many_rows then
         pd_fecpxv := null;
  end;
  
end SP_Fec_Proximo_vto;


Procedure SP_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date,
                             ln_numcuotas out number )as

begin
  begin
    select /*+parallel(o,2,1)*/  
            sum(count(*))
       into ln_numcuotas     
       from fsd602 o
      where o.pgcod   = pn_emp
        and o.ppmod   = pn_mod
        and o.ppsuc   = pn_suc 
        and o.ppmda   = pn_mda 
        and o.pppap   = pn_pap 
        and o.ppcta   = pn_cta 
        and o.ppoper  = pn_oper 
        and o.ppsbop  = pn_sbop 
        and o.pptope  = pn_top 
        and o.pp1fech  <= pd_fecpro
        and o.pp1stat = 'T' 
        and o.d602co  = 'S'
      group by o.PGCOD,
           o.PPMOD,
           o.PPSUC,
           o.PPMDA,
           o.PPPAP,
           o.PPCTA,
           o.PPOPER,
           o.PPSBOP,
           o.PPTOPE,
           o.PPFPAG;
  exception 
      when no_data_found then 
         ln_numcuotas := null;
      when too_many_rows then
         ln_numcuotas := -1;
      when others then
         ln_numcuotas := -0;
  end;   
   
end SP_cuotas_pagadas;

Procedure SP_Saldo_relacion(pn_emp in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pd_fecpro in date, pn_nrorel in number, 
                           pn_rubro in number, ln_saldo out number) is

begin
  begin
   select s.scsdo
     into ln_saldo
     from fsr014 r, fsd011 s
    where s.pgcod = pn_emp
      and s.scsuc = pn_suc
      and r.rubro = pn_rubro
      and r.rrrubr= s.scrub
      and r.rrcod = pn_nrorel
      and s.scmda = pn_mda
      and s.scpap = pn_pap
      and s.sccta = pn_cta
      and s.scoper= pn_oper
      and s.scsbop= pn_sbop;
  exception
      When no_data_found then
           If pn_nrorel = 35 then
               begin
                 select s.scsdo
                   into ln_saldo
                   from fsr014 r, fsd011 s
                  where s.pgcod = pn_emp
                    and s.scsuc = pn_suc
                    and r.rubro = pn_rubro
                    and r.rrrubr= s.scrub
                    and r.rrcod = 335
                    and s.scmda = pn_mda
                    and s.scpap = pn_pap
                    and s.sccta = pn_cta
                    and s.scoper= pn_oper
                    and s.scsbop= pn_sbop;
                exception
                    when others then
                       ln_saldo := null;
                end;
                
                else
                       ln_saldo := null;
            end if;
      
      when others then
         ln_saldo := null;
  end;
  
     
end SP_Saldo_relacion;

Procedure SP_PorcProv (pn_emp in number, pn_mod in number, /*pn_suc in number, */pn_mda in number,
                       pn_pap in number, pn_cta in number, pn_oper in number,
                       pn_sbop in number,pn_top in number, ln_porprov out number )as

begin
  begin
    select /*+parallel(o,2,1)*/  
            ri105coef
       into ln_porprov     
       from fri105 fri
      where fri.ri105cod      = pn_emp
        --and fri.ri105suc      = pn_suc
        and fri.ri105mod      = pn_mod
        and fri.ri105mda      = pn_mda 
        and fri.ri105pap      = pn_pap 
        and fri.ri105cta      = pn_cta 
        and fri.ri105oper     = pn_oper
        and fri.ri105sbop     = pn_sbop
        and fri.ri105tope     = pn_top ;
  exception 
      when no_data_found then 
         ln_porprov := null;
      when too_many_rows then
         ln_porprov := -1;
      when others then
         ln_porprov := -0;
  end;   
   
end SP_PorcProv;


Procedure SP_cuotas_pendientes (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                                pn_pap in number, pn_cta in number, pn_oper in number,
                                pn_sbop in number,pn_top in number, pd_fecpro in date,
                                ln_cuotas out number ) is

begin
  begin
    select /*+parallel(n,2,1)*/  
           count(n.ppfpag) 
      into ln_cuotas   
      from fsd601 n 
     where n.pgcod  = pn_emp     
       and n.ppcta  = pn_cta     
       and n.ppmda  = pn_mda    
       and n.ppsuc  = pn_suc    
       and n.pppap  = pn_pap    
       and n.ppoper = pn_oper  
       and n.ppsbop = pn_sbop  
       and n.pptope = pn_top  
       and n.ppmod  = pn_mod    
       and n.d601co = 'S'
       and n.ppfpag < pd_fecpro
       and not exists 
                (select /*+parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag 
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T' 
                    and o.d602co  = 'S');
  exception 
      when no_data_found then 
         ln_cuotas := null;
      when too_many_rows then
         ln_cuotas := null;
  end;   
   
end SP_cuotas_pendientes;

Procedure SP_categoria (pn_emp in number, pn_cta in number, pn_codcat in number,
                        lc_categoria out char, ld_fecCateg out Date ) 
is

begin

  begin
    select max(catfchdes)
      into ld_fecCateg
      from fsd212 l 
     where l.pgcod     = pn_emp
       and l.catcta    = pn_cta
       and l.catcod    = pn_codcat;
  exception 
      when no_data_found then 
         ld_fecCateg := null;
      when too_many_rows then
         ld_fecCateg := null;
  end;  
  
  begin
    select l.catcateg 
      into lc_categoria
      from fsd212 l 
     where l.pgcod     = pn_emp
       and l.catcta    = pn_cta
       and l.catfchdes = ld_fecCateg
       and l.catcod    = pn_codcat;
  exception 
      when no_data_found then 
         lc_categoria := null;
      when too_many_rows then
         lc_categoria := null;
  end;   
   
end SP_categoria;

Procedure SP_pa_instancia(pn_mod in number, pn_suc in number, pn_mda in number,
                         pn_pap in number, pn_cta in number, pn_oper in number,
                         pn_sbop in number,pn_top in number, ln_instancia out number) 
                         is

        
  begin
    case when pn_mod = 116 then -- lineas buscar relacion 
            begin 
               select distinct d.xwfprcins 
                 into ln_instancia
                from fsr011 hh, xwf700 d 
                where relcod = 46
                       and hh.r2cod  = d.xwfempresa   
                       and hh.r2mod  = d.xwfmodulo
                       and hh.r2suc  = d.xwfsucursal
                       and hh.r2mda  = d.xwfmoneda
                       and hh.r2pap  = d.xwfpapel
                       and hh.r2cta  = d.xwfcuenta
                       and hh.r2oper = d.xwfoperacion
                       and hh.r2sbop = d.xwfsubope
                       and hh.r2tope = d.xwftipope
                       and hh.r1cod  = 1
                       and hh.r1mod  = pn_mod
                       and hh.r1suc  = pn_suc
                       and hh.r1mda  = pn_mda
                       and hh.r1pap  = pn_pap
                       and hh.r1cta  = pn_cta
                       and hh.r1oper = pn_oper
                       and hh.r1sbop = pn_sbop
                       and hh.r1tope = pn_top;
             exception
                when no_data_found then
                     begin 
                           select distinct d.xwfprcins 
                             into ln_instancia
                            from fsr011 hh, xwf700 d 
                            where relcod = 46
                                   and hh.r2cod  = d.xwfempresa   
                                   and hh.r2mod  = d.xwfmodulo
                                   and hh.r2suc  = d.xwfsucursal
                                   and hh.r2mda  = d.xwfmoneda
                                   and hh.r2pap  = d.xwfpapel
                                   and hh.r2cta  = d.xwfcuenta
                                   and hh.r2oper = d.xwfoperacion
                                   and hh.r2sbop = d.xwfsubope
                                   and hh.r2tope = d.xwftipope
                                   and hh.r1cod  = 1
                                   and hh.r1mod  = pn_mod
                                   and hh.r1suc  = pn_suc
                                   and hh.r1mda  = pn_mda
                                   and hh.r1pap  = pn_pap
                                   and hh.r1cta  = pn_cta
                                   and hh.r1oper = pn_oper
                                   --and hh.r1sbop = pn_sbop
                                   and hh.r1tope = pn_top;
                     exception
                        when no_data_found then
                                ln_instancia := null;
                        when too_many_rows then    
                            begin 
                                 select distinct d.xwfprcins 
                                   into ln_instancia
                                  from fsr011 hh, xwf700 d 
                                  where relcod = 46
                                         and hh.r2cod  = d.xwfempresa   
                                         and hh.r2mod  = d.xwfmodulo
                                         and hh.r2suc  = d.xwfsucursal
                                         and hh.r2mda  = d.xwfmoneda
                                         and hh.r2pap  = d.xwfpapel
                                         and hh.r2cta  = d.xwfcuenta
                                         and hh.r2oper = d.xwfoperacion
                                         and hh.r2sbop = d.xwfsubope
                                         and hh.r2tope = d.xwftipope
                                         and hh.r1cod  = 1
                                         and hh.r1mod  = pn_mod
                                         and hh.r1suc  = pn_suc
                                         and hh.r1mda  = pn_mda
                                         and hh.r1pap  = pn_pap
                                         and hh.r1cta  = pn_cta
                                         and hh.r1oper = pn_oper
                                         --and hh.r1sbop = pn_sbop
                                         and hh.r1tope = pn_top
                                         and rownum = 1;
                           exception
                                  when others then
                                          ln_instancia := null;
                           end; 
                     end; 
                when too_many_rows then    
                     ln_instancia := 0;
             end; 
         when pn_mod in (200,33) then -- cartera judicial, castigados
              begin
               select sol.xwfprcins 
                 into ln_instancia
                 from xwf700 sol   
               where sol.xwfmodulo   = pn_mod    
                 and sol.xwfsucursal = pn_suc 
                 and sol.xwfmoneda   = pn_mda 
                 and sol.xwfpapel    = pn_pap 
                 and sol.xwfcuenta   = pn_cta 
                 and sol.xwfoperacion= pn_oper
                 and sol.xwfsubope   = pn_sbop
                 and sol.xwftipope   = pn_top 
                 and sol.xwfcar3 = '1' ;
            exception
               when no_data_found then
                    begin
                       select xwfprcins 
                         into ln_instancia
                        from xwf700 sol  
                       where sol.xwfsucursal = pn_suc 
                         and sol.xwfmoneda   = pn_mda 
                         and sol.xwfpapel    = pn_pap 
                         and sol.xwfcuenta   = pn_cta 
                         and sol.xwfoperacion= pn_oper
                         and sol.xwfcar3 = '1' ;
                    exception
                       when no_data_found then
                          ln_instancia := null;
                       when too_many_rows then    
                           begin
                             select min(xwfprcins) 
                               into ln_instancia
                              from xwf700 sol  
                             where sol.xwfsucursal = pn_suc 
                               and sol.xwfmoneda   = pn_mda 
                               and sol.xwfpapel    = pn_pap 
                               and sol.xwfcuenta   = pn_cta 
                               and sol.xwfoperacion= pn_oper
                               and sol.xwfcar3 = '1' ;
                          exception
                             when no_data_found then
                                ln_instancia := null;
                             when too_many_rows then    
                                begin
                                   select min(xwfprcins) 
                                     into ln_instancia
                                    from xwf700 sol  
                                   where sol.xwfsucursal = pn_suc 
                                     and sol.xwfmoneda   = pn_mda 
                                     and sol.xwfpapel    = pn_pap 
                                     and sol.xwfcuenta   = pn_cta 
                                     and sol.xwfoperacion= pn_oper
                                     and sol.xwfcar3 = '1' 
                                     and rownum = 1;
                                exception
                                   when others then
                                      ln_instancia := null;
                                end;
                          end;
                    end;   
               
               when too_many_rows then    
                   begin
                     select min(xwfprcins)
                       into ln_instancia
                       from xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       and sol.xwfcar3 = '1' ;
                  exception
                     when no_data_found then
                        ln_instancia := null;
                     when too_many_rows then    
                         begin
                           select min(xwfprcins)
                             into ln_instancia
                             from xwf700 sol  
                           where sol.xwfmodulo   = pn_mod    
                             and sol.xwfsucursal = pn_suc 
                             and sol.xwfmoneda   = pn_mda 
                             and sol.xwfpapel    = pn_pap 
                             and sol.xwfcuenta   = pn_cta 
                             and sol.xwfoperacion= pn_oper
                             and sol.xwfsubope   = pn_sbop
                             and sol.xwftipope   = pn_top 
                             and sol.xwfcar3 = '1' 
                             and rownum = 1;
                        exception
                           when others then
                              ln_instancia := null;
                        end;
                  end;
            end;
         
         when pn_top = 550 then -- prejudicial con demanda
            begin
               select xwfprcins 
                 into ln_instancia
                from xwf700 sol  
               where sol.xwfmodulo   = pn_mod    
                 and sol.xwfsucursal = pn_suc 
                 and sol.xwfmoneda   = pn_mda 
                 and sol.xwfpapel    = pn_pap 
                 and sol.xwfcuenta   = pn_cta 
                 and sol.xwfoperacion= pn_oper
                 and sol.xwfsubope   = pn_sbop
                 and sol.xwftipope   = pn_top 
                 and sol.xwfcar3 = '1' ;
            exception
               when no_data_found then
                    begin
                       select xwfprcins 
                         into ln_instancia
                       from xwf700 sol   
                       where sol.xwfmodulo   = pn_mod    
                         and sol.xwfsucursal = pn_suc 
                         and sol.xwfmoneda   = pn_mda 
                         and sol.xwfpapel    = pn_pap 
                         and sol.xwfcuenta   = pn_cta 
                         and sol.xwfoperacion= pn_oper
                         and sol.xwfcar3 = '1' ;
                    exception
                       when no_data_found then
                          ln_instancia := null;
                       when too_many_rows then    
                           begin
                             select min(xwfprcins) 
                               into ln_instancia
                             from xwf700 sol   
                             where sol.xwfmodulo   = pn_mod    
                               and sol.xwfsucursal = pn_suc 
                               and sol.xwfmoneda   = pn_mda 
                               and sol.xwfpapel    = pn_pap 
                               and sol.xwfcuenta   = pn_cta 
                               and sol.xwfoperacion= pn_oper
                               and sol.xwfcar3 = '1' ;
                          exception
                             when no_data_found then
                                ln_instancia := null;
                             when too_many_rows then    
                                begin
                                   select min(xwfprcins) 
                                     into ln_instancia
                                   from xwf700 sol   
                                   where sol.xwfmodulo   = pn_mod    
                                     and sol.xwfsucursal = pn_suc 
                                     and sol.xwfmoneda   = pn_mda 
                                     and sol.xwfpapel    = pn_pap 
                                     and sol.xwfcuenta   = pn_cta 
                                     and sol.xwfoperacion= pn_oper
                                     and sol.xwfcar3 = '1' ;
                                exception
                                   when others then
                                      ln_instancia := null;
                                   
                                end;
                          end;
                    end;   
               
               when too_many_rows then    
                   begin
                     select min(xwfprcins) 
                       into ln_instancia
                      from xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       and sol.xwfcar3 = '1' ;
                  exception
                     when no_data_found then
                        ln_instancia := null;
                     when too_many_rows then    
                        begin
                         select min(xwfprcins) 
                           into ln_instancia
                          from xwf700 sol  
                         where sol.xwfmodulo   = pn_mod    
                           and sol.xwfsucursal = pn_suc 
                           and sol.xwfmoneda   = pn_mda 
                           and sol.xwfpapel    = pn_pap 
                           and sol.xwfcuenta   = pn_cta 
                           and sol.xwfoperacion= pn_oper
                           and sol.xwfsubope   = pn_sbop
                           and sol.xwftipope   = pn_top 
                           and sol.xwfcar3 = '1' 
                           and rownum = 1;
                        exception
                          when others then 
                            ln_instancia := null;
                        end;
                  end;
            end;
         
         else -- prestamos normales
            begin
               select xwfprcins 
                 into ln_instancia
                from xwf700 sol  
               where sol.xwfmodulo   = pn_mod    
                 and sol.xwfsucursal = pn_suc 
                 and sol.xwfmoneda   = pn_mda 
                 and sol.xwfpapel    = pn_pap 
                 and sol.xwfcuenta   = pn_cta 
                 and sol.xwfoperacion= pn_oper
                 and sol.xwfsubope   = pn_sbop
                 and sol.xwftipope   = pn_top 
                 and sol.xwfcar3 = '1' ;
            exception
               when no_data_found then
                  begin
                     select xwfprcins 
                       into ln_instancia
                      from xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       /*and sol.xwfcar3 = '1'*/ ;
                  exception
                    when others then
                       ln_instancia := null;
                  end;  
            
               when too_many_rows then    
                  begin
                     select min(xwfprcins) 
                       into ln_instancia
                      from xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       and sol.xwfcar3 = '1' ;
                  exception
                     when no_data_found then
                        ln_instancia := null;
                     when too_many_rows then    
                        begin
                           select min(xwfprcins) 
                             into ln_instancia
                            from xwf700 sol  
                           where sol.xwfmodulo   = pn_mod    
                             and sol.xwfsucursal = pn_suc 
                             and sol.xwfmoneda   = pn_mda 
                             and sol.xwfpapel    = pn_pap 
                             and sol.xwfcuenta   = pn_cta 
                             and sol.xwfoperacion= pn_oper
                             and sol.xwfsubope   = pn_sbop
                             and sol.xwftipope   = pn_top 
                             and sol.xwfcar3 = '1' 
                             and rownum = 1;
                        exception
                          when others then 
                             ln_instancia := null;
                        end;
                  end;
            end;
        end case;
     
   

end SP_pa_instancia;

Procedure SP_dias_atraso(v_Pgfape in date, --fecha de proceso
                         v_Pgcod  in number,
                         v_Scmod  in number,
                         v_Scsuc  in number,
                         v_Scmda  in number,
                         v_Scpap  in number,
                         v_Sccta  in number,
                         v_Scoper in number,
                         v_Scsbop in number,
                         v_Sctope in number,
                         v_Scstat in number,
                         v_fecven in date,
                         ln_diatr out number
                       ) is
    
begin
                   
    ln_diatr := fn_dias_atraso(v_Pgfape , --fecha de proceso
                               v_Pgcod  ,
                               v_Scmod  ,
                               v_Scsuc  ,
                               v_Scmda  ,
                               v_Scpap  ,
                               v_Sccta  ,
                               v_Scoper ,
                               v_Scsbop ,
                               v_Sctope ,
                               v_Scstat ,
                               v_fecven );
 
end SP_dias_atraso;

Procedure SP_analista_credito(v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number,
                              lc_analista out varchar2
                             )  is
                             
begin                             
      lc_analista := fn_analista_credito(v_Scmod  ,
                                         v_Scsuc  ,
                                         v_Scmda  ,
                                         v_Scpap  ,
                                         v_Sccta  ,
                                         v_Scoper ,
                                         v_Scsbop ,
                                         v_Sctope 
                                             );
      
    
end SP_analista_credito; 


Procedure SP_instancia_credito(v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               ln_instancia out sng001.sng001inst%type
                             )  is


  begin

       ln_instancia := fn_instancia_credito(v_Scmod  ,
                                            v_Scsuc  ,
                                            v_Scmda  ,
                                            v_Scpap  ,
                                            v_Sccta  ,
                                            v_Scoper ,
                                            v_Scsbop ,
                                            v_Sctope 
                                             );      
 
  
end SP_instancia_credito;


Procedure SP_cuotas_calen (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number,ln_numcuotas out number)  is

begin
  begin
    select /*+ parallel(o,2,1)*/  
            sum(count(*))
       into ln_numcuotas     
       from fsd601 o
      where o.pgcod   = pn_emp
        and o.ppmod   = pn_mod
        and o.ppsuc   = pn_suc 
        and o.ppmda   = pn_mda 
        and o.pppap   = pn_pap 
        and o.ppcta   = pn_cta 
        and o.ppoper  = pn_oper 
        and o.ppsbop  = pn_sbop 
        and o.pptope  = pn_top 
        
      group by o.PGCOD,
           o.PPMOD,
           o.PPSUC,
           o.PPMDA,
           o.PPPAP,
           o.PPCTA,
           o.PPOPER,
           o.PPSBOP,
           o.PPTOPE,
           o.PPFPAG;
  exception 
      when no_data_found then 
         ln_numcuotas := null;
      when too_many_rows then
         ln_numcuotas := -1;
      when others then
         ln_numcuotas := -0;
  end;   

end SP_cuotas_calen;


Procedure SP_PromedioMora (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date,
                           ln_promM out number)is
                           
ln_mora number;
ld_fecmor date;
Cursor Mora is
select  /*+all_rows parallel(d601,2,1)*/
       FD601.PGCOD,
       fd601.ppmod,
       fd601.ppsuc, 
       fd601.ppmda,
       fd601.pppap, 
       fd601.ppcta, 
       fd601.ppoper,
       fd601.ppsbop,
       fd601.pptope,
       fd601.ppfpag                                              
  from fsd601 fd601
 where fd601.pgcod  = pn_emp
   and fd601.ppmod  = pn_mod
   and fd601.ppsuc  = pn_suc 
   and fd601.ppmda  = pn_mda 
   and fd601.pppap  = pn_pap 
   and fd601.ppcta  = pn_cta 
   and fd601.ppoper = pn_oper
   and fd601.ppsbop = pn_sbop
   and fd601.pptope = pn_top ;


                          
Begin

   execute immediate ('truncate table Mora_Aux');
   For i in Mora loop
   ln_mora   := null;
   ld_fecmor := null;
   
       Begin
       
       select /*+all_rows parallel(d602,2,1)*/
              max(d602.pp1fech)
         into ld_fecmor
         from fsd602 d602
        where d602.pgcod    = i.pgcod 
          and d602.ppmod    = i.ppmod 
          and d602.ppsuc    = i.ppsuc 
          and d602.ppmda    = i.ppmda 
          and d602.pppap    = i.pppap 
          and d602.ppcta    = i.ppcta 
          and d602.ppoper   = i.ppoper
          and d602.ppsbop   = i.ppsbop
          and d602.pptope   = i.pptope
          and d602.ppfpag   = i.ppfpag
          and d602.pp1fech  <= pd_fecpro
          and d602.pp1stat  = 'T' 
          and d602.d602co   = 'S';
          
       exception
       
          when no_data_found then 
             ld_fecmor := null;
          when too_many_rows then
             ld_fecmor := null;
          when others then
             ld_fecmor := null;
       end;
       begin
             if ld_fecmor is null then
                ln_mora := pd_fecpro - i.ppfpag;
                
                else
                        ln_mora := ld_fecmor - i.ppfpag;
             end if;
       end;
       
       
       begin
       
           if ln_mora < 0 then
              ln_mora := 0;
           end if; 
       end;
       
       insert into Mora_Aux(pgcod,ppmod,ppsuc,ppmda,pppap,ppcta,ppoper,ppsbop,pptope,ppfpag,diasmor,Pp1fech)
       Values(i.pgcod,i.ppmod,i.ppsuc,i.ppmda,i.pppap,i.ppcta,i.ppoper,i.ppsbop,i.pptope,i.ppfpag,ln_mora,ld_fecmor);
       commit;
   end loop;
   
   
   --Recorro la tabla MOra_Aux
   begin
   
   Select sum(a.diasmor)
     into ln_promM
     from Mora_Aux a;
   exception
    When others then
         null;
   end;
                              
/*Begin

   Begin
   
   
   select 
         sum(cal.diam) 
         into ln_promM
         from (select  
                       FD601.PGCOD,
                       fd601.ppmod,
                       fd601.ppsuc, 
                       fd601.ppmda,
                       fd601.pppap, 
                       fd601.ppcta, 
                       fd601.ppoper,
                       fd601.ppsbop,
                       fd601.pptope,
                       ((select 
                                max(d602.pp1fech)
                         from fsd602 d602
                        where d602.pgcod    = fd601.pgcod 
                          and d602.ppmod    = fd601.ppmod 
                          and d602.ppsuc    = fd601.ppsuc 
                          and d602.ppmda    = fd601.ppmda 
                          and d602.pppap    = fd601.pppap 
                          and d602.ppcta    = fd601.ppcta 
                          and d602.ppoper   = fd601.ppoper
                          and d602.ppsbop   = fd601.ppsbop
                          and d602.pptope   = fd601.pptope
                          and d602.ppfpag   = fd601.ppfpag
                          and d602.pp1fech  <= pd_fecpro
                          and d602.pp1stat  = 'T' 
                          and d602.d602co   = 'S') - fd601.ppfpag)diam            
                                               
                  from fsd601 fd601
                 where fd601.pgcod  = pn_emp
                   and fd601.ppmod  = pn_mod
                   and fd601.ppsuc  = pn_suc 
                   and fd601.ppmda  = pn_mda 
                   and fd601.pppap  = pn_pap 
                   and fd601.ppcta  = pn_cta 
                   and fd601.ppoper = pn_oper
                   and fd601.ppsbop = pn_sbop
                   and fd601.pptope = pn_top 
                   --and fd601.pptipo <> 'K'
                   --AND fd601.PPFPAG - pd_fecval < 190
                   ) cal
                                          
                group by cal.PGCOD,
                   cal.ppmod,
                   cal.ppsuc, 
                   cal.ppmda,
                   cal.pppap, 
                   cal.ppcta, 
                   cal.ppoper,
                   cal.ppsbop,
                   cal.pptope
               ;
   exception
   
      when no_data_found then 
         ln_promM := null;
      when too_many_rows then
         ln_promM := -1;
      when others then
         ln_promM := -0;
   end;
   */
end SP_PromedioMora;


Procedure SP_evaluacion (pn_instancia in number, pn_codigo in number, pn_tipo in number,
                         ln_valor out number)is


begin
 
  begin
    select distinct f.sng023mto
           into ln_valor
          from sng021 e, sng023 f
         where e.sng021sol = pn_instancia
           and e.sng021tmod = pn_tipo
           and e.sng021eval = f.sng021eval
           and f.sng026cod = pn_codigo
           and rownum = 1
   
       ;
  exception 
      when no_data_found then 
         ln_valor := null;
      when too_many_rows then
         ln_valor := null;
  end;   

end SP_evaluacion;

Procedure SP_NumAutorizacion (pn_instancia in number, ln_valor out number)is


begin
 
  begin
    select max (a.sng091aut)
           into ln_valor
          from sng091 a
         where a.sng001inst = pn_instancia
           and a.sng091num = 0
           
       ;
  exception 
      when no_data_found then 
         ln_valor := null;
      when too_many_rows then
         ln_valor := null;
  end;   

end SP_NumAutorizacion;

Procedure sp_ultima_evaluacion (pn_pais in number, pn_tdoc in number, pc_ndoc in char,
                                pd_feceva out date)is


begin

          begin
            select max(f.sng021fec) 
              into pd_feceva
              from SNG021 f 
             where f.sng021pdoc = pn_pais
               and f.sng021tdoc = pn_tdoc 
               and f.sng021ndoc = pc_ndoc
                   
               ;
          exception 
              when no_data_found then 
                 pd_feceva := null;
              when too_many_rows then
                 pd_feceva := null;
          end;
          

end sp_ultima_evaluacion;

Procedure sp_sector_credito (v_fecpro in date,
                             v_pgcod  in number,
                             v_Scmod  in number,
                             v_Scsuc  in number,
                             v_Scmda  in number,
                             v_Scpap  in number,
                             v_Sccta  in number,
                             v_Scoper in number,
                             v_Scsbop in number,
                             v_Sctope in number,
                             sector   out number)is 
                

begin
        sector := fn_sector_credito(v_fecpro ,
                                    v_pgcod  ,
                                    v_Scmod  ,
                                    v_Scsuc  ,
                                    v_Scmda  ,
                                    v_Scpap  ,
                                    v_Sccta  ,
                                    v_Scoper ,
                                    v_Scsbop ,
                                    v_Sctope );

end;

Procedure SP_fec_resolucion (pn_instancia in number,ld_fecreso out date) is

begin
  begin
    select b.wfiteminit
      into ld_fecreso
      from wfwrkitems b
     where b.wfinsprcid = pn_instancia
       and b.wftaskcod = 55
       and b.wfstscod = 'C'
       and b.wfitemid = (select max(bb.wfitemid)
                           from wfwrkitems bb
                          where bb.wfinsprcid = b.wfinsprcid
                            and bb.wftaskcod  = b.wftaskcod
                            and bb.wfstscod   = b.wfstscod)
       ;
  exception
      when too_many_rows then
           ld_fecreso := null;
      when no_data_found then
           ld_fecreso := null;


  end;

end SP_fec_resolucion;

Procedure SP_FecSolicitud (pn_instancia in number,ld_fecsol out date) is

begin
  begin
    select b.sng001fin
      into ld_fecsol
      from sng001 b
     where b.sng001inst = pn_instancia
       and rownum = 1
       ;
  exception
      when too_many_rows then
           ld_fecsol := null;
      when no_data_found then
           ld_fecsol := null;


  end;

end SP_FecSolicitud;


end PQ_PROC_VISITAS;
/

