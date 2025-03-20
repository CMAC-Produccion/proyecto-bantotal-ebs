create or replace package pq_cre_saldopendiente is

  -- Author  : KVALENCIAC
  -- Created : 07/04/2020 
  -- Purpose : 
  -- Author  : KVALENCIAC
  -- Created : 24/06/2021
  -- Purpose : Se está adicionando un nuevo rubro de los interes devengados pendientes 
  -- Author Modificación : KVALENCIAC
  -- Fecha Modificación : 23/08/2022
procedure sp_verificasaldo (vn_Ppgcod in number, 
                            vn_cta in number, 
                            vn_ope in number, 
                            vn_mda in number,  
                            rpta out number, 
                            ln_saldo out number);

procedure sp_Fec_Proximo_vto (pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_oper   in number,
                              pn_sbop   in number,
                              pn_top    in number,
                              pd_fecpro in date,
                              ld_fecvto out  date);
--inicio kvalenciac 23/08/2022                              
procedure sp_verificasaldop (vn_Ppgcod in number,   
                            vn_cta in number, 
                            vn_ope in number, 
                            vn_mda in number,  
                            rpta out number, 
                            ln_saldo out number);
procedure sp_verificasaldoi (vn_Ppgcod in number, 
                            vn_cta in number, 
                            vn_ope in number, 
                            vn_mda in number,  
                            rpta out number, 
                            ln_saldo out number); 
--fin kvalenciac 23/08/2022                                                           
end pq_cre_saldopendiente;
/

create or replace package body pq_cre_saldopendiente is

procedure sp_verificasaldo(vn_Ppgcod in number, vn_cta in number, vn_ope in number, vn_mda in number,  rpta out number, ln_saldo out number)
  is
begin  
   ln_saldo :=0;
   rpta := 0;
   begin        
        select  
        sum(scsdo) into ln_saldo
        from fsd011
        where
        pgcod = vn_Ppgcod and
        sccta = vn_cta and
        scrub in (9500092000000,9500093000000,9500094000000,9500095000000) and   --16/06/2021 se adicionó 9500095000000  no adicionar crear otro proceso diferente que se adicione
        scoper = vn_ope and     
        scmda = vn_mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_saldo:=0;
    end;   
    if (ln_saldo<0) then
       ln_saldo := ln_saldo*-1;
    end if;
    if (ln_saldo>0) then
      rpta := 1;
    end if;
    --	9500092000000: Saldo Pendiente Int Moratorio.
--	9500093000000: Saldo Pendiente Penalidad.
--	9500094000000: Saldo Pendiente Int Comp Venc.
end sp_verificasaldo;


procedure sp_Fec_Proximo_vto (pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_oper   in number,
                              pn_sbop   in number,
                              pn_top    in number,
                              pd_fecpro in date,
                              ld_fecvto out  date)
is
begin
  begin
      --    select /*+ parallel(n,2,1)*/
      select /*+index(n FSD60107)*/
       min(n.ppfpag)
        into ld_fecvto
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_oper
         and n.ppsbop = pn_sbop
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists
      --                (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
       (select /*+index(o SYS_C00978743)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                 and o.pp1fech <= pd_fecpro
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when no_data_found then
        ld_fecvto := null;
      when too_many_rows then
        ld_fecvto := null;
    end;    
end sp_Fec_Proximo_vto;
procedure sp_verificasaldop(vn_Ppgcod in number, vn_cta in number, vn_ope in number, vn_mda in number,  rpta out number, ln_saldo out number)
  is
begin  
   ln_saldo :=0;
   rpta := 0;
   begin        
        select  
        sum(scsdo) into ln_saldo
        from fsd011
        where
        pgcod = vn_Ppgcod and
        sccta = vn_cta and
        scrub in ( 9500092000000,9500093000000,9500094000000 ) and  
        scoper = vn_ope and     
        scmda = vn_mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_saldo:=0;
    end;   
    if (ln_saldo<0) then
       ln_saldo := ln_saldo*-1;
    end if;
    if (ln_saldo>0) then
      rpta := 1;
    end if;
end sp_verificasaldop;
procedure sp_verificasaldoi( vn_Ppgcod in number, vn_cta in number, vn_ope in number, vn_mda in number,  rpta out number, ln_saldo out number)
  is
ld_pgfape date;
begin
   rpta := 0;
   ln_saldo :=0;
   begin        
        select  
        sum(scsdo) into ln_saldo
        from fsd011
        where
        pgcod = vn_Ppgcod and
        sccta = vn_cta and
        scrub in (9500095000000) and   --9500095000000- Inventario devengado pendiente
        scoper = vn_ope and     
        scmda = vn_mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_saldo:=0;
    end;   
    if (ln_saldo<0) then
       ln_saldo := ln_saldo*-1;
    end if;
    if (ln_saldo>0) then
      rpta := 1;
    end if;
end sp_verificasaldoi;
                              
end pq_cre_saldopendiente;
/

