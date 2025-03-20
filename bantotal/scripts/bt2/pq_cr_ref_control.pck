create or replace package pq_cr_ref_control is

  -- Author : KVALENCIAC
  -- Created : 24/09/2020 
  -- Proyecto : Devuelve los controles de créditos refinanciados con exoneración
  -- Public type declarations
  --Modificado por: Kvalenciac
  --Fecha MOdifiación: 27/01/2021
  --Descripción: se cambióa la búsqueda de G a X en la JAQN870
   --Modificado por: Kvalenciac
  --Fecha MOdifiación: 28/04/2021
  --Descripción: Se adicionó sp_controles2
   --Modificado por: Kvalenciac
  --Fecha MOdifiación: 18/05/2021
  --Descripción: Se modificó sp_controles  solo con estado X
   --Modificado por: Kvalenciac
  --Fecha MOdifiación: 01/10/2021
  --Descripción: Se modificó sp_controles  solo con estado X
   procedure sp_controles (vd_Pgfape in date, 
                           vn_instancia in number, 
                           vn_tipocambio in number, 
                           vn_tipoexoneracion out number, 
                           vn_montoingresado out number, 
                           vn_saldocapital out number, 
                           vn_existe out number,
                           vn_TotDifAjuste out number,
                           vn_contador out number,
                           vn_aplica out number);
    procedure sp_controles2 (vd_Pgfape in date, 
                           vn_instancia in number,                             
                           vn_existe out number
                          );
--inicio 01/10/2021  kdvc                         
    procedure sp_esreprog_exonerado (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vn_ppfpag in date, 
                                   ln_Indicador out number);
--fin 01/10/2021 kdvc                                  

end pq_cr_ref_control;
/

create or replace package body pq_cr_ref_control is

  procedure sp_controles (vd_Pgfape in date, 
                          vn_instancia in number, 
                          vn_tipocambio in number, 
                          vn_tipoexoneracion out number, 
                          vn_montoingresado out number, 
                          vn_saldocapital out number, 
                          vn_existe out number,
                          vn_TotDifAjuste out number,
                          vn_contador out number,
                          vn_aplica out number)
  is  
  ln_jaqn870tip number;
  ln_contador number(2);-- cantidad de créditos asociados a la instancia
  ln_existe number(2); -- cantidad de créditos con exoneración
  ln_Porcentaje number;
  ln_JAQN870MDA number (4);
  ln_JAQN870MDA_TOT number;
  ln_MontoIngr number;
  ln_MDA_MontoIngr number(4);   
  ln_SaldoCapitalTot number;
  ln_SaldoCapital number;
  ln_XWfMoneda number(4);
  ln_deudasinAjuste number;
  ln_deudaconAjuste number;
  ln_DifAjuste number;
  ln_TotDifAjuste number;
  cursor creditos is
    select * 
    from xwf700
    where  XWFPRCINS=vn_instancia and XWFPRCINS>0
    and XWFCar3<>'1'; 
  
 begin
 vn_tipoexoneracion := 0 ;
 vn_montoingresado := 0;
 vn_saldocapital:= 0;
 ln_MontoIngr := 0;
 ln_contador :=0;
 vn_aplica := 0;
 ln_existe := 0;
 ln_JAQN870MDA_TOT := 0;
 ln_SaldoCapitalTot:=0;
 ln_TotDifAjuste := 0;
   begin
     select XWFMONTO1, XWfMoneda into ln_MontoIngr,ln_MDA_MontoIngr --monto de la instancia creada
     from xwf700
      where  XWFPRCINS=vn_instancia
         and XWFCar3='1'; 
     exception
      when others then
              ln_MontoIngr := 0;              
   end;
   ln_JAQN870MDA_TOT := ln_JAQN870MDA_TOT + ln_MDA_MontoIngr;
    for j in creditos loop        
        ln_contador := ln_contador +1;
        begin
          select JAQN870MDA,jaqn870tip into ln_JAQN870MDA,ln_jaqn870tip
          from JAQN870
          where JAQN870EMP = j.XWfEmpresa  
               and JAQN870MOD = j.XWfModulo
               and JAQN870SUC = j.XWfSucursal   
               and JAQN870MDA = j.XWfMoneda   
               and JAQN870PAP = j.XWfPapel    
               and JAQN870CTA = j.XWfCuenta   
               and JAQN870OPE = j.XWfOperacion
               and JAQN870SBO = j.XWfSubope
               and JAQN870TOP = j.xwftipope
               and JAQN870EST in ('X');--18/05/2021 se eliminnó 'I' --'X' 28/04/2021;  --'G';  kdvc 27/01/2021
        Exception
             when others then
               ln_jaqn870tip := 0;
        End;
        if ( ln_jaqn870tip <> 0 ) then -- si tiene ingresado tipo de exoneración continua        
            ln_existe := ln_existe +1;            
        end if;
        ln_JAQN870MDA_TOT := ln_JAQN870MDA_TOT + ln_JAQN870MDA;   
    End loop;
    
    if ( ln_JAQN870MDA_TOT <> ( ln_MDA_MontoIngr * ( ln_existe + 1 ) ) ) then
         vn_aplica := 1 ;
    end if;
    for i in creditos loop  
        begin        
         select jaqn870tip,
                jaqn870CAP+jaqn870INT+jaqn870SEG+jaqn870PEN+jaqn870MOR+jaqn870ICV,
                jaqn870CAA+jaqn870INA+jaqn870PEA+jaqn870MOA+jaqn870ICA
                into ln_jaqn870tip,
                ln_deudasinAjuste,
                ln_deudaconAjuste
         from JAQN870
         where JAQN870EMP = i.XWfEmpresa  
             and JAQN870MOD = i.XWfModulo
             and JAQN870SUC = i.XWfSucursal   
             and JAQN870MDA = i.XWfMoneda   
             and JAQN870PAP = i.XWfPapel    
             and JAQN870CTA = i.XWfCuenta   
             and JAQN870OPE = i.XWfOperacion
             and JAQN870SBO = i.XWfSubope
             and JAQN870TOP = i.xwftipope
             and JAQN870EST in ('X');--18/05/2021 se eliminnó 'I' --'X' 28/04/2021;  --'G';  kdvc 27/01/2021
        Exception
             when no_data_found then
               ln_jaqn870tip := 0;               
        end;
         
        if ( ln_jaqn870tip <> 0 ) then-- si tiene ingresado tipo de exoneración continua                    
            if ( ln_jaqn870tip > vn_tipoexoneracion ) then
              vn_tipoexoneracion := ln_jaqn870tip;
            end if;
            begin
            select TP1IMP1 into ln_Porcentaje 
            from  fst198
            where Tp1cod  = 1 
                  and Tp1cod1  = 11140 
                  and Tp1corr1 = 3 
                  and tp1corr2 = 2 
                  and tp1corr3 > 0
                  and tp1nro1 = ln_jaqn870tip;
             exception
               when no_data_found then
                 ln_Porcentaje := 0;
             End;
              --obtengo deuda sin ajuste - la deuda con ajuste de cada crédito
              ln_DifAjuste := ln_deudasinAjuste - ln_deudaconAjuste;
              --obtengo el saldo capital del crédito que estamos revisando
              ln_SaldoCapital := i.XWFMONTO1;
              ln_XWfMoneda := i.XWfMoneda;
              --verifico el tipo de moneda si algún  caso tiene diferente moneda entonces todo se convierte en soles
              if ( vn_aplica = 1 ) then
                if ( ln_XWfMoneda = 101 ) then
                   ln_SaldoCapital := ln_SaldoCapital * vn_tipocambio;
                   ln_DifAjuste := ln_DifAjuste * vn_tipocambio;
                end if;
              end if;
              ln_SaldoCapital := ( ln_SaldoCapital * ln_Porcentaje )/ 100 ;
              ln_SaldoCapitalTot := ln_SaldoCapitalTot + ln_SaldoCapital;
              ln_TotDifAjuste := ln_TotDifAjuste + ln_DifAjuste;              
         end if;
     End loop; 
   vn_montoingresado := ln_MontoIngr;
   vn_saldocapital:= ln_SaldoCapitalTot;
   vn_existe := ln_existe;  
   vn_TotDifAjuste := ln_TotDifAjuste; 
   vn_contador := ln_contador;         
 end sp_controles;
 procedure sp_controles2 (vd_Pgfape in date, 
                          vn_instancia in number,                          
                          vn_existe out number
                          )
  is 
  ln_contador number(2);
  ln_existe number(2);
  cursor creditos is
    select * 
    from xwf700
    where  XWFPRCINS=vn_instancia 
    and XWFCar3<>'1'; 
  
 begin
    vn_existe:=0;
   -- si es de n a 1
    for j in creditos loop        
        ln_contador := ln_contador +1;
        begin
          select count(*)
              into ln_existe
          from JAQN870
          where JAQN870EMP = j.XWfEmpresa  
               and JAQN870MOD = j.XWfModulo
               and JAQN870SUC = j.XWfSucursal   
               and JAQN870MDA = j.XWfMoneda   
               and JAQN870PAP = j.XWfPapel    
               and JAQN870CTA = j.XWfCuenta   
               and JAQN870OPE = j.XWfOperacion
               and JAQN870SBO = j.XWfSubope
               and JAQN870TOP = j.xwftipope
               and JAQN870EST in ( select trim(tp1desc) from fst198 where tp1cod = 1 and tp1cod1 = 11123 and tp1corr1 = 7 and tp1corr2=1 and tp1corr3>0);
        Exception
             when others then
               ln_existe := 0;
        End;
        if   (ln_existe>0) then
          vn_existe:=1;
        end if;                  
    End loop;
    
 end sp_controles2; 
 --inicio 01/10/2021 kdvc
 procedure sp_esreprog_exonerado (vn_Pgcod in number, vn_ppmod in number, vn_ppsuc in number, vn_ppmda in number, vn_pppap in number,
   vn_ppcta in number, vn_ppoper in number,vn_ppsbop in number, vn_pptope in number,vn_ppfpag in date, ln_Indicador out number)
is
begin
  ln_Indicador:=0;
  begin
      select 1 into ln_Indicador
      from AQPB408
      where AQPB408COD = vn_Pgcod
      and AQPB408MOD = vn_ppmod
      and AQPB408SUC = vn_ppsuc
      and AQPB408MDA = vn_ppmda
      and AQPB408PAP = vn_pppap
      and AQPB408CTA = vn_ppcta
      and AQPB408OPE = vn_ppoper
      and AQPB408SBO = vn_ppsbop
      and AQPB408TPO = vn_pptope
      and AQPB408EST  ='C';
   exception 
      when others then
        ln_Indicador :=0;
   end;       
end  sp_esreprog_exonerado;  
--fin 01/10/2021 kdvc
end pq_cr_ref_control;
/

