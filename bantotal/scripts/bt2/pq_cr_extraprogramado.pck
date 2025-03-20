create or replace package PQ_CR_EXTRAPROGRAMADO is
 
    -- *****************************************************************
    -- Nombre                     : 
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
    --                              
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
PROCEDURE SP_VALIDA_AP( 
                        v_instancia in number,
                        v_fecape in date,
                        v_sdo out number,
                        v_mto out number,
                        v_dia out number,
                        v_ind out varchar2                        
                        );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                       
end PQ_CR_EXTRAPROGRAMADO;
/

create or replace package body PQ_CR_EXTRAPROGRAMADO is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_EXTRAPROGRAMADO
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
      
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
PROCEDURE SP_VALIDA_AP( 
                        v_instancia in number,
                        v_fecape in date,
                        v_sdo out number,
                        v_mto out number,
                        v_dia out number,
                        v_ind out varchar2
                       ) is
    -- *****************************************************************
    -- Nombre                     : SP_VALIDA_AP
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2022.09.15
    -- Autor de Creacion          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Par¿metros de Entrada      : instancia
    -- Fecha                      : 
    -- Modificado                 :                            
    -- Descripcion                : 
    --                              
    -- ***************************************************************** 

cursor creditos (ln_dias in number) is

    select jaqz157pgg, jaqz157mog, jaqz157sug, jaqz157mdg, jaqz157pag, jaqz157ctg, jaqz157opg, jaqz157sbg,
           jaqz157tog, jaqz157pai, jaqz157tpo, jaqz157num, jaqz157est, jaqz157fre, jaqz157tip, jaqz157mto,
           jaqz157faf, jaqz157fdf
      from jaqz157 j, sng001 s
     where j.jaqz157num = s.sng001ndoc
       and j.jaqz157est = 'A'
       and j.jaqz157ax8 in ('T', 'P')
       and v_fecape - j.jaqz157faf > ln_dias
       and s.sng001inst = v_instancia --- vigentes
    --   and j.jaqz157num in (73079070 /*,10418857,46953980,43114393 */)
      union 
     select jaqz157pgg, jaqz157mog, jaqz157sug, jaqz157mdg, jaqz157pag, jaqz157ctg, jaqz157opg, jaqz157sbg,
           jaqz157tog, jaqz157pai, jaqz157tpo, jaqz157num, jaqz157est, jaqz157fre, jaqz157tip, jaqz157mto,
           jaqz157faf, jaqz157fdf
      from jaqz157 j, sng001 s
     where j.jaqz157num = s.sng001ndoc
       and j.jaqz157est = 'D'
       and j.jaqz157ax8 in ('T', 'P')
       and to_date(JAQZ157FDF, 'DD/MM/RRRR') - j.jaqz157faf > ln_dias
      and s.sng001inst = v_instancia; -- desafiliados
--              and j.jaqz157num in (73079070 /*,10418857,46953980,43114393 */);


cursor pagos(
              pjaqz157pgg in number,
              pjaqz157mog in number, 
              pjaqz157sug in number, 
              pjaqz157mdg in number, 
              pjaqz157pag in number, 
              pjaqz157ctg in number, 
              pjaqz157opg in number, 
              pjaqz157sbg in number,
              pjaqz157tog in number
              ) is
  --obtiene cuotas pagadas en orden descendente
  -- se realiza conteo por cada cuota pagada, si no paga en alguna cuota retorna conteo a 0
  --si fecha pago supera ultimo dia del mes de fecha de vencimiento de la cuota no se cuenta,	contador se inicializa en 0
    select * 
      from jaqz157A j 
     where j.jaqz157apgc = pjaqz157pgg 
       and j.jaqz157amog = pjaqz157mog
       and j.jaqz157asug = pjaqz157sug
       and j.jaqz157amdg = pjaqz157mdg
       and j.jaqz157apag = pjaqz157pag
       and j.jaqz157actg = pjaqz157ctg
       and j.jaqz157aopg = pjaqz157opg
       and j.jaqz157asbg = pjaqz157sbg
       and j.jaqz157atog = pjaqz157tog
       and j.jaqz157aest = 'C'
       order by jaqz157afvf desc ;


ln_monto number(18,2) := 0;
ln_montoT number(18,2):= 0;
ln_sdo number(18,2)  := 0;
ln_sdoT number(18,2) := 0;
ln_dia number := 0;
ln_contador number := 0;
ln_dAFI number := 0;
ld_fAFI date;
ld_fuafi date;

ln_plazo  number;
ln_cpcuota number;
ln_cpfecha number;
lc_indicador char(1);




BEGIN
   
   begin
      SELECT f.tp1imp1
        into ln_plazo
        FROM FST198 F
        WHERE TP1COD = 1
          AND TP1COD1 = 10899
          AND TP1CORR1 >= 410000 
          AND TP1CORR2 = 1 
          AND TP1CORR3 > 0;

   exception when others then
      ln_plazo := 0 ;          
   end;          

   for i in creditos( ln_plazo ) loop

   ld_fAFI := i.jaqz157faf;
   
   ---cuotas pagadas en la fecha
   begin 
     select count(*) 
      into ln_cpcuota -- cuotas pagadas en la  fecha vencimiento
      from jaqz157A j 
     where j.jaqz157apgc = i.jaqz157pgg 
       and j.jaqz157amog = i.jaqz157mog
       and j.jaqz157asug = i.jaqz157sug
       and j.jaqz157amdg = i.jaqz157mdg
       and j.jaqz157apag = i.jaqz157pag
       and j.jaqz157actg = i.jaqz157ctg
       and j.jaqz157aopg = i.jaqz157opg
       and j.jaqz157asbg = i.jaqz157sbg
       and j.jaqz157atog = i.jaqz157tog
       and j.jaqz157aest = 'C' 
       and j.jaqz157afcc <= j.jaqz157afvf ;
    exception when others then
         ln_cpcuota := 0;
    end; 

  ---cuotas pagadas fuera de fecha
   begin 
     select count(*) 
      into ln_cpfecha -- cuotas pagadas fuera de fecha vencimiento
      from jaqz157A j 
      where j.jaqz157apgc = i.jaqz157pgg 
       and j.jaqz157amog = i.jaqz157mog
       and j.jaqz157asug = i.jaqz157sug
       and j.jaqz157amdg = i.jaqz157mdg
       and j.jaqz157apag = i.jaqz157pag
       and j.jaqz157actg = i.jaqz157ctg
       and j.jaqz157aopg = i.jaqz157opg
       and j.jaqz157asbg = i.jaqz157sbg
       and j.jaqz157atog = i.jaqz157tog
       and j.jaqz157aest = 'C' 
       and j.jaqz157afcc > last_day(j.jaqz157afvf);
    exception when others then
         ln_cpfecha := 0;
    end; 
        
    if ln_cpcuota - ln_cpfecha >= 6 then
      lc_indicador := 'S'; --supera meses de plazo, verificar continuidad 
    else
      lc_indicador := 'N'; -- no cumple criterio
    end if;  
   
    if  lc_indicador = 'S' then --verificar cumplimiento de continuidad
    
     --monto cobrado 
      ln_contador := 0;
      ln_dia      := 0;
      ln_monto    := 0;
      for j in pagos (i.jaqz157pgg, i.jaqz157mog, i.jaqz157sug, i.jaqz157mdg, i.jaqz157pag, i.jaqz157ctg, 
          i.jaqz157opg, i.jaqz157sbg, i.jaqz157tog) loop
        
          if j.jaqz157afcc <= last_day(j.jaqz157afvf) then
             ln_contador := ln_contador + 1;
             ln_monto    := j.jaqz157amto; ---monto cobrado
             ln_montoT   := nvl(ln_montoT,0)  + ln_monto;  --acumula monto
             --ln_dia      := nvl(ln_dia,0) + (j.jaqz157afvf - j.JAQZ157AFVI); --plazo dias en cada cuota
             v_ind       := 'S';
             
             if ln_contador = 1 then
               ld_fuafi := j.JAQZ157AFVI;
             end if;
          else
                ln_contador := 0;
                ln_montoT := 0;
                ln_dia    := 0;
                v_ind     := 'N';                
          end if;       
          --ld_fuafi := j.JAQZ157AFVI;
    
      end loop;
      
      ln_dAFI := ld_fuafi - ld_fAFI; --- obteniendo los dias desde la afiliacion a primera cuota
      ln_dia  := ln_dia + ln_dAFI; --- se agrega dias de fecha de afiliacion
      
      
     --retornar saldo FSD011
     begin
       select f.scsdo 
         into ln_sdo
         from fsd011 f
         where pgcod  =  i.JAQZ157PGG
            and scsuc  = i.JAQZ157SUG
            and scmda  = i.JAQZ157MDG
            and scpap  = i.JAQZ157PAG
            and sccta  = i.JAQZ157CTG
            and scoper = i.JAQZ157OPG
            and scsbop = i.JAQZ157SBG
            and sctope = i.JAQZ157TOG
            and scmod  = i.JAQZ157MOG
            and scrub  = 9300071900000;
      exception when others then
         ln_sdo := 0;
      end;
      
     
      ln_sdoT := nvl(ln_sdoT,0) + ln_sdo;
      
    end if; --  
                  
   end loop;
   
   v_sdo := ln_sdoT;
   v_mto := ln_montoT;
   v_dia := ln_dia;
 
END SP_VALIDA_AP;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_EXTRAPROGRAMADO;
/

