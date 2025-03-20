create or replace package PQ_CR_MIVIVIENDA is
   -- *****************************************************************
    -- Nombre                     : PQ_CR_MIVIVIENDA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bonos(pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pn_SalBBP out number, pn_SalPBP out number, pn_IntBBP out number, pn_IntPBP out number);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
function fn_cr_relacion_rubro(pn_rubro in number, pn_relcod in number) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
function fn_cr_saldos_fsd011(
          pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
          pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number,
          pn_rubro in number) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bono_BMS(pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pn_SalBMS out number,  pn_IntBMS out number);    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bono_BFH(pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pn_SalBFH out number,  pn_IntBFH out number);   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bfh_sponsor(pn_instancia in number, pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pc_indicador out varchar2);                                         
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bono_BFH_rel(pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pn_SalBFH out number,  pn_IntBFH out number, pn_Rubro out number, pn_Relacion out number);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_MIVIVIENDA;
/

create or replace package body PQ_CR_MIVIVIENDA is
   -- *****************************************************************
    -- Nombre                     : PQ_CR_MIVIVIENDA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.12.05
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  --in:&Pgcod, in:&Scsuc, in:&Scmda, in:&Scpap, in:&Sccta, in:&Scoper, in:&Scsbop, in:&Sctope, 
  --in:&Scmod, out:&SalBBP, out:&SalPBP, out:&IntBBP, out:&IntPBP  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bonos(pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pn_SalBBP out number, pn_SalPBP out number, pn_IntBBP out number, pn_IntPBP out number) is
   -- *****************************************************************
    -- Nombre                     : sp_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
ln_rubro fsd011.scrub%type;
ln_sBBP fsr014.rubro%type;
ln_sPBP fsr014.rubro%type;
ln_IBBP fsr014.rubro%type;
ln_IPBP fsr014.rubro%type;

begin

/*
--fsr014 tabla de relaciones de rubros contables
para obtener mi vivienda en calendarios sin cronogramas

buscar el rubro del credito (14) - relacion - ---	rrrubr -- buscar en FSD011 el SALDO
					240	bono 	rubrobono
					241 	premio	rubropremio

buscar con el rubro de rrrubr - relacion - ---	rrrubr 		-- buscar en FSD011 el SALDO
rubrobono				242	Int bono 	rubroIntbono
rubropremio				242 	Int premio	rubroIntpremio


*/

 --
 begin
      select f.scrub
        into ln_rubro
        from fsd011 f
        where f.pgcod = pn_pgcod
          and f.scsuc = pn_scsuc
          and f.scmda = pn_scmda
          and f.scpap = pn_scpap
          and f.sccta = pn_sccta
          and f.scoper = pn_scoper
          and f.scsbop = pn_scsbop
          and f.sctope = pn_sctope
          and f.scmod = pn_scmod;
 exception when others then
      ln_rubro := 0;     
 end;

 if ln_rubro <> 0 then
   
     ln_sBBP := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_rubro, 240); --relacion 240	saldo bono 	rubrobono
     if ln_sBBP <> 0 then
       --SaldoBonoBuenPagador
       begin
    
          pn_SalBBP := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                              pn_scsuc => pn_scsuc,
                                                              pn_scmda => pn_scmda,
                                                              pn_scpap => pn_scpap,
                                                              pn_sccta => pn_sccta,
                                                              pn_scoper => pn_scoper,
                                                              pn_scsbop => pn_scsbop,
                                                              pn_sctope => pn_sctope,
                                                              pn_scmod => pn_scmod,
                                                              pn_rubro => ln_sBBP);
       end;
       
       ln_IBBP := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_sBBP, 242); --relacion 242	Interes bono 	rubrobono
       if ln_IBBP <> 0 then
          --InteresBonoBuenPagador
          begin
      
            pn_IntBBP := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                                pn_scsuc => pn_scsuc,
                                                                pn_scmda => pn_scmda,
                                                                pn_scpap => pn_scpap,
                                                                pn_sccta => pn_sccta,
                                                                pn_scoper => pn_scoper,
                                                                pn_scsbop => pn_scsbop,
                                                                pn_sctope => pn_sctope,
                                                                pn_scmod => pn_scmod,
                                                                pn_rubro => ln_IBBP);
         end;
       end if;     
       
     end if;
       
     ln_sPBP := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_rubro, 241); --relacion 241	saldo PREMIO 	rubrobono
     if ln_sPBP <> 0 then
          --SaldoPremioBuenPagador
          begin
      
            pn_SalPBP := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                                pn_scsuc => pn_scsuc,
                                                                pn_scmda => pn_scmda,
                                                                pn_scpap => pn_scpap,
                                                                pn_sccta => pn_sccta,
                                                                pn_scoper => pn_scoper,
                                                                pn_scsbop => pn_scsbop,
                                                                pn_sctope => pn_sctope,
                                                                pn_scmod => pn_scmod,
                                                                pn_rubro => ln_sPBP);
         end;
         
         ln_IPBP := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_sPBP, 242); --relacion 242	Interes PREMIO 	rubrobono
         if ln_IPBP <> 0 then
              --InteresPremioBuenPagador
              begin
                pn_IntPBP := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                                    pn_scsuc => pn_scsuc,
                                                                    pn_scmda => pn_scmda,
                                                                    pn_scpap => pn_scpap,
                                                                    pn_sccta => pn_sccta,
                                                                    pn_scoper => pn_scoper,
                                                                    pn_scsbop => pn_scsbop,
                                                                    pn_sctope => pn_sctope,
                                                                    pn_scmod => pn_scmod,
                                                                    pn_rubro => ln_IPBP);
             end;
         end if;   
         
      end if;
         
  
      
  
  
     
   
 
 end if;



end sp_cr_bonos;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
function fn_cr_relacion_rubro(pn_rubro in number, pn_relcod in number) return number is
   -- *****************************************************************
    -- Nombre                     : sp_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
ln_rubrosal fsd011.scrub%type;


begin

   --
   begin
        select f.rrrubr
          into ln_rubrosal
          from fsr014 f
          where f.rubro = pn_rubro
            and f.rrcod = pn_relcod;
   exception when others then
        ln_rubrosal := 0;     
   end;

return ln_rubrosal;

end fn_cr_relacion_rubro;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
function fn_cr_saldos_fsd011(
          pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
          pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number,
          pn_rubro in number) return number is
   -- *****************************************************************
    -- Nombre                     : sp_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
ln_saldo fsd011.scsdo%type;


begin

   --
    begin
      select f.scsdo * -1
        into ln_saldo
        from fsd011 f
        where f.pgcod = pn_pgcod
        --  and f.scsuc = pn_scsuc
          and f.scmda = pn_scmda
          and f.scpap = pn_scpap
          and f.sccta = pn_sccta
          and f.scoper = pn_scoper
          and f.scsbop = pn_scsbop
      --    and f.sctope = pn_sctope
      --    and f.scmod = pn_scmod
          and f.scrub = pn_rubro;
 exception when others then
      ln_saldo := 0;     
 end;


return ln_saldo;

end fn_cr_saldos_fsd011;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bono_BMS(pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pn_SalBMS out number,  pn_IntBMS out number) is
   -- *****************************************************************
    -- Nombre                     : sp_cr_bono_BMS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2019.07.05
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Obtiene Bono y Saldo Mi vivienda sostenible Bono Verde
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
ln_rubro fsd011.scrub%type;
ln_sBMS fsr014.rubro%type;
ln_IBMS fsr014.rubro%type;

begin

/*
--fsr014 tabla de relaciones de rubros contables
para obtener mi vivienda en calendarios sin cronogramas BONO VERDE
*/

 --
 begin
      select f.scrub
        into ln_rubro
        from fsd011 f
        where f.pgcod = pn_pgcod
          and f.scsuc = pn_scsuc
          and f.scmda = pn_scmda
          and f.scpap = pn_scpap
          and f.sccta = pn_sccta
          and f.scoper = pn_scoper
          and f.scsbop = pn_scsbop
          and f.sctope = pn_sctope
          and f.scmod = pn_scmod;
 exception when others then
      ln_rubro := 0;     
 end;

 if ln_rubro <> 0 then
   
     ln_sBMS := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_rubro, 246); --relacion 246  saldo bono  rubrobono BMS
     if ln_sBMS <> 0 then
       --SaldoBonoVerde
       begin
    
          pn_SalBMS := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                              pn_scsuc => pn_scsuc,
                                                              pn_scmda => pn_scmda,
                                                              pn_scpap => pn_scpap,
                                                              pn_sccta => pn_sccta,
                                                              pn_scoper => pn_scoper,
                                                              pn_scsbop => pn_scsbop,
                                                              pn_sctope => pn_sctope,
                                                              pn_scmod => pn_scmod,
                                                              pn_rubro => ln_sBMS);
       end;
       
       ln_IBMS := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_sBMS, 242); --relacion 242 Interes bono  rubrobono
       if ln_IBMS <> 0 then
          --InteresBonoVerde
          begin
      
            pn_IntBMS := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                                pn_scsuc => pn_scsuc,
                                                                pn_scmda => pn_scmda,
                                                                pn_scpap => pn_scpap,
                                                                pn_sccta => pn_sccta,
                                                                pn_scoper => pn_scoper,
                                                                pn_scsbop => pn_scsbop,
                                                                pn_sctope => pn_sctope,
                                                                pn_scmod => pn_scmod,
                                                                pn_rubro => ln_IBMS);
         end;
       end if;     
       
     end if;
 
 end if;


end sp_cr_bono_BMS;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bono_BFH(pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pn_SalBFH out number,  pn_IntBFH out number) is
   -- *****************************************************************
    -- Nombre                     : sp_cr_bono_BFH
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2019.08.13
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Obtiene Bono y Saldo Mi vivienda fondo Habitacional BFH
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
ln_rubro fsd011.scrub%type;
ln_sBFH fsr014.rubro%type;
ln_IBFH fsr014.rubro%type;

begin


 --
 begin
      select f.scrub
        into ln_rubro
        from fsd011 f
        where f.pgcod = pn_pgcod
          and f.scsuc = pn_scsuc
          and f.scmda = pn_scmda
          and f.scpap = pn_scpap
          and f.sccta = pn_sccta
          and f.scoper = pn_scoper
          and f.scsbop = pn_scsbop
          and f.sctope = pn_sctope
          and f.scmod = pn_scmod;
 exception when others then
      ln_rubro := 0;     
 end;

 if ln_rubro <> 0 then
   
     ln_sBFH := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_rubro, 247); --relacion 247  saldo bono  rubrobono BFH
     if ln_sBFH <> 0 then
       --SaldoBFH
       begin
    
          pn_SalBFH := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                              pn_scsuc => pn_scsuc,
                                                              pn_scmda => pn_scmda,
                                                              pn_scpap => pn_scpap,
                                                              pn_sccta => pn_sccta,
                                                              pn_scoper => pn_scoper,
                                                              pn_scsbop => pn_scsbop,
                                                              pn_sctope => pn_sctope,
                                                              pn_scmod => pn_scmod,
                                                              pn_rubro => ln_sBFH);
       end;
       
            -----
       if pn_SalBFH = 0 then -- sino existe  247 buscar con relacion 248

         
           ln_sBFH := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_rubro, 248); --relacion 248  saldo bono  rubrobono BFH

           --SaldoBFH
           begin
        
              pn_SalBFH := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                                  pn_scsuc => pn_scsuc,
                                                                  pn_scmda => pn_scmda,
                                                                  pn_scpap => pn_scpap,
                                                                  pn_sccta => pn_sccta,
                                                                  pn_scoper => pn_scoper,
                                                                  pn_scsbop => pn_scsbop,
                                                                  pn_sctope => pn_sctope,
                                                                  pn_scmod => pn_scmod,
                                                                  pn_rubro => ln_sBFH);
           end;
       
       end if;
       -------------------------
       
       ln_IBFH := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_sBFH, 242); --relacion 242 Interes bono  rubrobono
       if ln_IBFH <> 0 then
          --InteresBFH
          begin
      
            pn_IntBFH := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                                pn_scsuc => pn_scsuc,
                                                                pn_scmda => pn_scmda,
                                                                pn_scpap => pn_scpap,
                                                                pn_sccta => pn_sccta,
                                                                pn_scoper => pn_scoper,
                                                                pn_scsbop => pn_scsbop,
                                                                pn_sctope => pn_sctope,
                                                                pn_scmod => pn_scmod,
                                                                pn_rubro => ln_IBFH);
         end;
       end if;     
       
     end if;
 
 end if;


end sp_cr_bono_BFH;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bfh_sponsor(pn_instancia in number, pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pc_indicador out varchar2) is
   -- *****************************************************************
    -- Nombre                     : sp_cr_bfh_sponsor
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2019.08.27
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Retorna indicador de sponsor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************


begin

 --
 begin
      select f.jaqz132spo
        into pc_indicador
        from jaqz132 f
        where f.jaqz132ins = pn_instancia
          and f.jaqz132emp = pn_pgcod
          and f.jaqz132suc = pn_scsuc
          and f.jaqz132mod = pn_scmod
          and f.jaqz132mnd = pn_scmda 
          and f.jaqz132pap = pn_scpap 
          and f.jaqz132cta = pn_sccta 
          and f.jaqz132ope = pn_scoper
          and f.jaqz132sbo = pn_scsbop
          and f.jaqz132top = pn_sctope;
 exception when others then
      pc_indicador := null;     
 end;
 
 null;


end sp_cr_bfh_sponsor;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bono_BFH_rel(pn_pgcod in number, pn_scsuc in number, pn_scmda in number, pn_scpap in number, pn_sccta in number,
                   pn_scoper in number, pn_scsbop in number, pn_sctope in number, pn_scmod in number, 
                   pn_SalBFH out number,  pn_IntBFH out number, pn_Rubro out number, pn_Relacion out number) is
   -- *****************************************************************
    -- Nombre                     : sp_cr_bono_BFH_relacion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2019.11.25
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Obtiene Bono y Saldo Mi vivienda fondo Habitacional BFH , retorna adicionalmente rubro y relacion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
ln_rubro fsd011.scrub%type;
ln_sBFH fsr014.rubro%type;
ln_IBFH fsr014.rubro%type;
ln_relacion number :=0;
ln_rubro_sdo fsd011.scrub%type := 0;

begin


 --
 begin
      select f.scrub
        into ln_rubro
        from fsd011 f
        where f.pgcod = pn_pgcod
          and f.scsuc = pn_scsuc
          and f.scmda = pn_scmda
          and f.scpap = pn_scpap
          and f.sccta = pn_sccta
          and f.scoper = pn_scoper
          and f.scsbop = pn_scsbop
          and f.sctope = pn_sctope
          and f.scmod = pn_scmod;
 exception when others then
      ln_rubro := 0;     
 end;

 if ln_rubro <> 0 then
   
     ln_sBFH := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_rubro, 247); --relacion 247  saldo bono  rubrobono BFH
     if ln_sBFH <> 0 then

       ln_relacion := 247;
       ln_rubro_sdo := ln_sBFH;
       
       --SaldoBFH
       
       begin
    
          pn_SalBFH := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                              pn_scsuc => pn_scsuc,
                                                              pn_scmda => pn_scmda,
                                                              pn_scpap => pn_scpap,
                                                              pn_sccta => pn_sccta,
                                                              pn_scoper => pn_scoper,
                                                              pn_scsbop => pn_scsbop,
                                                              pn_sctope => pn_sctope,
                                                              pn_scmod => pn_scmod,
                                                              pn_rubro => ln_sBFH);
       end;
       
            -----
       if pn_SalBFH = 0 then -- sino existe  247 buscar con relacion 248

         
           ln_sBFH := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_rubro, 248); --relacion 248  saldo bono  rubrobono BFH
           
           ln_relacion := 248;
           ln_rubro_sdo := ln_sBFH;
           
           --SaldoBFH
           begin
        
              pn_SalBFH := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                                  pn_scsuc => pn_scsuc,
                                                                  pn_scmda => pn_scmda,
                                                                  pn_scpap => pn_scpap,
                                                                  pn_sccta => pn_sccta,
                                                                  pn_scoper => pn_scoper,
                                                                  pn_scsbop => pn_scsbop,
                                                                  pn_sctope => pn_sctope,
                                                                  pn_scmod => pn_scmod,
                                                                  pn_rubro => ln_sBFH);
           end;
       
       end if;
       -------------------------
       
       ln_IBFH := pq_cr_mivivienda.fn_cr_relacion_rubro(ln_sBFH, 242); --relacion 242 Interes bono  rubrobono
       if ln_IBFH <> 0 then
          --InteresBFH
          begin
      
            pn_IntBFH := pq_cr_mivivienda.fn_cr_saldos_fsd011(pn_pgcod => pn_pgcod,
                                                                pn_scsuc => pn_scsuc,
                                                                pn_scmda => pn_scmda,
                                                                pn_scpap => pn_scpap,
                                                                pn_sccta => pn_sccta,
                                                                pn_scoper => pn_scoper,
                                                                pn_scsbop => pn_scsbop,
                                                                pn_sctope => pn_sctope,
                                                                pn_scmod => pn_scmod,
                                                                pn_rubro => ln_IBFH);
         end;
       end if;     
       
     end if;
 
     pn_Rubro := ln_rubro_sdo;
     pn_Relacion := ln_relacion; 
     
    
 end if;


end sp_cr_bono_BFH_rel;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_MIVIVIENDA;
/

