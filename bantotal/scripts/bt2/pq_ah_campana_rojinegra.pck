create or replace package PQ_AH_CAMPANA_ROJINEGRA is

  Procedure sp_ah_reg_cliente_tar(P_D_FECACT IN DATE,           
                                  P_N_CODPAI IN NUMBER,
                                  P_N_CODTPD IN NUMBER,
                                  P_C_NUMDOC IN VARCHAR2,
                                  P_N_NUMOPT IN NUMBER,
                                  P_N_NUMOCT IN NUMBER            
                                 );
  Procedure sp_ah_reg_bloque_tar(P_D_FECACT IN DATE,           
                                 P_N_CODPAI IN NUMBER,
                                 P_N_CODTPD IN NUMBER,
                                 P_C_NUMDOC IN VARCHAR2
                                );                                                        
  Procedure sp_ah_genera_opciones(P_D_FECPRO IN DATE);
  Function fn_ah_valida_tarjeta(P_C_NUMTAR IN VARCHAR2)  return varchar2;
  
  Function fn_ah_valida_tarper(P_N_CODPAI IN NUMBER,
                               P_N_CODTPD IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2
                              ) return varchar2;
                               
  Function fn_ah_num_opciones(P_N_PGCOD  IN NUMBER,
                              P_N_SCSUC  IN NUMBER,
                              --P_N_SCRUB  IN NUMBER,
                              P_N_SCMDA  IN NUMBER,
                              P_N_SCPAP  IN NUMBER,                              
                              P_N_SCCTA  IN NUMBER,
                              P_N_SCOPER IN NUMBER,                              
                              P_N_SCSBOP IN NUMBER,
                              P_N_SCTOPE IN NUMBER,
                              P_N_SCMOD  IN NUMBER,
                              P_N_NUMSOR IN NUMBER,
                              P_N_FECAPE IN NUMBER
                             ) RETURN NUMBER;
  Function fn_ah_saldo_fsh014(P_N_PGCOD  IN NUMBER,
                              P_N_SCSUC  IN NUMBER,
--                              P_N_SCRUB  IN NUMBER,
                              P_N_SCMDA  IN NUMBER,
                              P_N_SCPAP  IN NUMBER, 
                              P_N_SCCTA  IN NUMBER,
                              P_N_SCOPER IN NUMBER, 
                              P_N_SCSBOP IN NUMBER,
                              P_N_SCTOPE IN NUMBER,
                              P_N_SCMOD  IN NUMBER,
                              P_D_FECPRO IN DATE
                             ) return number;             
  Function fn_ah_valida_region(P_N_SCSUC IN NUMBER,
                               P_N_CODPAI IN NUMBER,
                               P_N_CODTPD IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2
                              ) return varchar2;        
  Function fn_ah_opciones_web(P_N_CODPAI IN NUMBER,
                              P_N_CODTPD IN NUMBER,
                              P_C_NUMDOC IN VARCHAR2
                              ) return number;                              
end PQ_AH_CAMPANA_ROJINEGRA;
/

create or replace package body PQ_AH_CAMPANA_ROJINEGRA is

  Procedure sp_ah_reg_cliente_tar(P_D_FECACT IN DATE,           
                                  P_N_CODPAI IN NUMBER,
                                  P_N_CODTPD IN NUMBER,
                                  P_C_NUMDOC IN VARCHAR2,
                                  P_N_NUMOPT IN NUMBER,
                                  P_N_NUMOCT IN NUMBER            
                                 ) is
                                          
  ln_correl number(9):= 0;
  ln_codcam number(9):= 1;
  ln_fecha  number(8):= 0;
  ln_numsor number(9):= 0;
  ln_indexi number(1):= 0;
  ln_numopt number(9):= 0;
  ln_numoct number(9):= 0;
  lc_codest char(1)  := 'V';
  
  begin
  ln_numopt := P_N_NUMOPT;
  ln_numoct := P_N_NUMOCT;

  ln_fecha := to_number(to_char(P_D_FECACT,'rrrrmmdd'));  

  begin
   select Tp1imp1
     into ln_numsor 
     from FST198
    Where Tp1cod1 = 10825 
      and Tp1corr1 = 12
      and Tp1corr2 = 1
      and ln_fecha between tp1nro1 and tp1nro2;
  Exception    
  when others then
       ln_numsor := 0;      
  end;
  If ln_numsor <> 0 then
      begin
        select 1
          into ln_indexi
          from JAQL489
         where JAQL489PAI = P_N_CODPAI
           and JAQL489TPO = P_N_CODTPD
           and JAQL489NRO = P_C_NUMDOC
           and JAQL489CMP = ln_codcam
           and JAQL489NSO = ln_numsor;
        --actualizamos   
        If ln_indexi = 1 then
          update JAQL489
             set JAQL489OPT = decode(JAQL489OPT,1,JAQL489OPT,ln_numopt),
                 JAQL489OCT = ln_numoct,
                 JAQL489EST = lc_codest
           where JAQL489PAI = P_N_CODPAI
             and JAQL489TPO = P_N_CODTPD
             and JAQL489NRO = P_C_NUMDOC
             and JAQL489CMP = ln_codcam
             and JAQL489NSO = ln_numsor;
        End If;   
      Exception
      When no_data_Found then
        --insertamos
        begin
          select nvl(max(JAQL489COR),0) into ln_correl from JAQL489;    
        Exception
        When no_data_found then  
             ln_correl:= 0;     
        end;
        ln_correl := ln_correl + 1;                   
              
           begin
              insert into JAQL489
                (JAQL489COR,
                 JAQL489CMP,
                 JAQL489NSO,
                 JAQL489PAI,
                 JAQL489TPO,
                 JAQL489NRO,
                 JAQL489OPT,
                 JAQL489OCT,
                 JAQL489EST)
              VALUES
                (ln_correl,
                 ln_codcam,
                 ln_numsor,
                 P_N_CODPAI,
                 P_N_CODTPD,
                 P_C_NUMDOC,
                 ln_numopt,
                 ln_numoct,
                 lc_codest
                );
          Exception
          When others then      
            null;
          End;      
      end;
  commit;    
  End If;   
   
  Exception  
  When Others then
       null;      
  End sp_ah_reg_cliente_tar;
  
  Procedure sp_ah_reg_bloque_tar(P_D_FECACT IN DATE,           
                                 P_N_CODPAI IN NUMBER,
                                 P_N_CODTPD IN NUMBER,
                                 P_C_NUMDOC IN VARCHAR2
                                ) is
  ln_codcam number(9):= 1; 
  ln_fecha  number(8):= 0;
  ln_numsor number(9):= 0;    
  lc_codest char(1) := 'N';                         
  lc_estact char(1) := 'V';                         
  begin  
  ln_fecha := to_number(to_char(P_D_FECACT,'rrrrmmdd'));          
  begin
   select Tp1imp1
     into ln_numsor 
     from FST198
    Where Tp1cod1 = 10825 
      and Tp1corr1 = 12
      and Tp1corr2 = 1
      and ln_fecha between tp1nro1 and tp1nro2;
  Exception    
  when others then
    ln_numsor := 0;      
  end;
        
  If ln_numsor <> 0 then    
      update JAQL489
         set JAQL489OPT = 0,
             JAQL489EST = lc_codest
       where JAQL489PAI = P_N_CODPAI
         and JAQL489TPO = P_N_CODTPD
         and JAQL489NRO = P_C_NUMDOC
         and JAQL489CMP = ln_codcam
         and JAQL489EST = lc_estact;
  commit;       
  End If;
  Exception
  When others then
    null;  
  End sp_ah_reg_bloque_tar;    
                                
  Procedure sp_ah_genera_opciones(P_D_FECPRO IN DATE) is
  cursor c_personas(ln_codcam in number, ld_fecpro in date)  is
    select distinct 
           a.jaql489pai,
           a.jaql489tpo,
           a.jaql489nro,
           b.z0e478fau
      from jaql489 a,
           z0e478  b
     where a.jaql489pai = b.z0e478thp
       and a.jaql489tpo = b.z0e478tht
       and a.jaql489nro = b.z0e478thd
       and b.z0e478fal  < ld_fecpro
       and a.jaql489cmp = ln_codcam
       and b.z0e463cod in (1,7)
       and a.jaql489est = 'V';
       
  cursor c_cuentas(ln_pais in number, ln_tipo in number, lc_numero in varchar2) is  
    select a.z0e478nro,a.z0e478thp,a.z0e478tht,a.z0e478thd,x.scfval,x.pgcod,x.scsuc,x.scrub,x.scmda,x.scpap,x.sccta,x.scoper,x.scsbop, x.sctope, x.scmod
      from Z0E478 a,
           Z0E479 b,
           FSD011 x
     where a.z0e478nro = b.z0e478nro
       and a.z0e478thp = ln_pais
       and a.z0e478tht = ln_tipo
       and a.z0e478thd = lc_numero
       and x.pgcod     = 1
       and b.z0e479suc = x.scsuc
       and b.z0e479cta = x.sccta
       and b.z0e479sct = x.scsbop
       and b.z0e479mod = x.scmod
       and b.z0e479mon = x.scmda
       and b.z0e479pap = x.scpap
       and b.z0e479top = x.sctope
       and b.z0e479ope = x.scoper
       and x.sctope    = 1
       and x.scstat not in (99,81)
       and a.z0e463cod in (1,7);
  

  ln_codcam number(9):= 1;
  ln_fecha  number(8):= 0;
  ln_numsor number(9):= 0;
  ln_fecape number(9):= 0;
  ln_numopc number(9):= 0;
  ln_totopc number(9):= 0;  
  lc_valido Char(1)  := 'N';

  begin 
  ln_fecha := to_number(to_char(P_D_FECPRO,'rrrrmmdd'));  
    begin   
       select Tp1imp1
         into ln_numsor
         from FST198
        Where Tp1cod1 = 10825 
          and Tp1corr1 = 12
          and Tp1corr2 = 1
          and Tp1nro3  = ln_fecha;   
    Exception
    when others then      
      ln_numsor := 0;  
    end;      
    If ln_numsor <> 0 then  
       For i in c_personas (ln_codcam,P_D_FECPRO) loop
           --VERIFICAR QUE LA TARJETA ACTIVA SEA ROJINEGRA Y NO SEA DE PERSONA QUE NO PARTICIPA
           --lc_valido := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_valida_tarper(i.jaql489pai,i.jaql489tpo,i.jaql489nro); --validamos tarjeta activa y personas no aptas          
           --If lc_valido = 'S' then
               For j in c_cuentas(i.jaql489pai,i.jaql489tpo,i.jaql489nro) loop
                  --VERIFICAR QUE LAS CUENTAS ASOCIADAS SEAN DE AQP Y PROPIETARIO RESIDA EN AQP  
                  lc_valido := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_valida_region(j.scsuc,i.jaql489pai,i.jaql489tpo,i.jaql489nro);
                  If lc_valido = 'S' then
                     ln_fecape := to_number(to_char(j.scfval,'rrrrmmdd'));  
                     ln_numopc := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_num_opciones(j.pgcod,j.scsuc,/*j.scrub,*/j.scmda,j.scpap,j.sccta,j.scoper,j.scsbop,j.sctope,j.scmod,
                                                                             ln_numsor,ln_fecape
                                                                             );
                     ln_totopc := ln_totopc + ln_numopc;
                  End If;  
               End Loop; 
               
               If ln_totopc > 0 then 
               --actualizamos su numero de opciones por cuentas
                pq_ah_campana_rojinegra.sp_ah_reg_cliente_tar(p_d_fecact => P_D_FECPRO - 1,
                                                              p_n_codpai => i.jaql489pai,
                                                              p_n_codtpd => i.jaql489tpo,
                                                              p_c_numdoc => i.jaql489nro,
                                                              p_n_numopt => 0,
                                                              p_n_numoct => ln_totopc
                                                              );
               ln_totopc := 0;
               ln_numopc := 0;
               End If;
           --End If;          
       End Loop;  
       commit;           
    End If;
  End sp_ah_genera_opciones;    
      
  Function fn_ah_valida_tarjeta(P_C_NUMTAR IN VARCHAR2)  return varchar2 is
  cursor c_rangos is
     select Tp1corr3,Tp1desc
       from FST198
      Where Tp1cod1 = 10825 
        and Tp1corr1 = 12
        and Tp1corr2 = 3;    
  ln_tarini number(16);
  ln_tarfin number(16);          
  ln_numtar number(16);      
  lc_indval char(1) := 'N'; 

  begin
 
   for i in c_rangos loop
      if i.Tp1corr3 = 1 then
        ln_tarini := to_number(trim(i.Tp1desc));
      Else
        ln_tarfin := to_number(trim(i.Tp1desc));
      End If;      
    End Loop;      
  ln_numtar := to_number(trim(P_C_NUMTAR));
  
  If ln_tarini <= ln_numtar and ln_numtar <= ln_tarfin Then   
     lc_indval := 'S';
  Else
     lc_indval := 'N';   
  End If;
       
  return lc_indval;     
  Exception
  When others then
    lc_indval := 'N';   
    return lc_indval;     
  End fn_ah_valida_tarjeta;  
  
  Function fn_ah_valida_tarper(P_N_CODPAI IN NUMBER,
                               P_N_CODTPD IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2
                              ) return varchar2 is
 
  lc_indval char(1) := 'N'; 
  --lc_numtar char(19);      
  ln_pais   number; 
  ln_tipo   number; 
  ln_numero char(12);                         
  begin                              
  -- verificamos si la tarjeta es valida
/*      begin
        select x.z0e478nro 
          into lc_numtar 
          from z0e478 x 
         where x.z0e478thp = P_N_CODPAI
           and x.z0e478tht = P_N_CODTPD
           and x.z0e478thd = P_C_NUMDOC
           and x.z0e463cod in (1,7);
      Exception
      when others then     
        lc_numtar := null;
      end;
    
   lc_indval := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_valida_tarjeta(lc_numtar);
   
   If lc_indval = 'N' then
     return lc_indval;
   End If;*/
   
  --verificamos si es trabajador o familiar
   begin
     select 'N'
       into lc_indval
       from fsd002 t2
      where t2.pfpais = P_N_CODPAI
        and t2.pftdoc = P_N_CODTPD
        and t2.pfndoc = P_C_NUMDOC
        and t2.pfebco = 'S'; 
     return lc_indval;
   Exception
   When others then   
       lc_indval := 'S';
   end;            
   --VERIFICAMOS SI ES FAMILIAR DE ALGUIEN     
   begin
     select 'N', f2.rppais,f2.rptdoc,f2.rpndoc
       into lc_indval, ln_pais, ln_tipo, ln_numero
       from fsr002 f2
      where f2.pepais = P_N_CODPAI
        and f2.petdoc = P_N_CODTPD
        and f2.pendoc = P_C_NUMDOC
        and rownum = 1;
     --return lc_indval;        
   exception   
   when others then
     lc_indval := 'S';
   end;
   
   If lc_indval = 'N' then
     begin
       select 'N'
         into lc_indval
         from fsd002 t2
        where t2.pfpais = ln_pais
          and t2.pftdoc = ln_tipo
          and t2.pfndoc = ln_numero
          and t2.pfebco = 'S'; 
       return lc_indval;
     Exception
     When others then   
         lc_indval := 'S';
     end;      
   End If;
   
  
  begin                       
    select 'N',fs.rppais,fs.rptdoc,fs.rpndoc
      into lc_indval, ln_pais, ln_tipo, ln_numero
      from fsr002 fs
     where fs.rppais = P_N_CODPAI
       and fs.rptdoc = P_N_CODTPD
       and fs.rpndoc = P_C_NUMDOC
       and rownum = 1;
     --return lc_indval;    
   exception   
   when others then
     lc_indval := 'S';
   end;   
   
   If lc_indval = 'N' then
     begin
       select 'N'
         into lc_indval
         from fsd002 t2
        where t2.pfpais = ln_pais
          and t2.pftdoc = ln_tipo
          and t2.pfndoc = ln_numero
          and t2.pfebco = 'S'; 
       return lc_indval;
     Exception
     When others then   
         lc_indval := 'S';
     end;      
   End If;   
  --verificamos en tabla de otras personas exoneradas    
  begin
    select 'N'
      into lc_indval 
      from JAQL468 
     Where JAQL468PAI = P_N_CODPAI
       and JAQL468TDO = P_N_CODTPD
       and JAQL468NDO = P_C_NUMDOC
       and JAQL468TCM = 1;
    return lc_indval;         
  Exception
  When others then   
    lc_indval := 'S';
  End;
  
  return lc_indval;
  Exception
  When others then
    lc_indval := 'N';
    return lc_indval;
  End fn_ah_valida_tarper;  
           
  Function fn_ah_num_opciones(P_N_PGCOD  IN NUMBER,
                              P_N_SCSUC  IN NUMBER,
--                              P_N_SCRUB  IN NUMBER,
                              P_N_SCMDA  IN NUMBER,
                              P_N_SCPAP  IN NUMBER,                              
                              P_N_SCCTA  IN NUMBER,
                              P_N_SCOPER IN NUMBER,                              
                              P_N_SCSBOP IN NUMBER,
                              P_N_SCTOPE IN NUMBER,
                              P_N_SCMOD  IN NUMBER,
                              P_N_NUMSOR IN NUMBER,
                              P_N_FECAPE IN NUMBER
                             ) RETURN NUMBER IS
                               
  cursor c_opciones(ln_monto in NUMBER) IS   
     select Tp1imp3
       from FST198
      Where Tp1cod1 = 10825 
        and Tp1corr1 = 12
        and Tp1corr2 = 2
        and ln_monto between Tp1imp1  and Tp1imp2;  
        
  cursor c_sorteo(ln_numsor in NUMBER) IS
       select Tp1nro1,Tp1nro2
         from FST198
        Where Tp1cod1 = 10825 
          and Tp1corr1 = 12
          and Tp1corr2 = 1
          and Tp1imp1  = ln_numsor;       
          
  cursor c_sorteo_ant(ln_numsor in NUMBER) IS
       select Tp1nro1,Tp1nro2
         from FST198
        Where Tp1cod1 = 10825 
          and Tp1corr1 = 12
          and Tp1corr2 = 1
          and Tp1imp1  = ln_numsor;                
          
  ln_numopc number(9):=0;    
  ln_opcgui number(9):=0;   
  ld_feccor date;  
  ld_fecape date;  
  ld_fecpro date;  
  ln_salcor number(18,2):=0;
  ln_salhis number(18,2):=0;
  cont number(5):=0;
  --lc_error varchar2(1000);
  begin    
    --opciones por monto en la cuenta 
    For i in c_sorteo (P_N_NUMSOR) Loop
      ld_feccor := to_date(to_char(i.Tp1nro2),'rrrrmmdd'); --fecfin
      ln_salcor := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_saldo_fsh014(P_N_PGCOD,P_N_SCSUC,/*P_N_SCRUB,*/P_N_SCMDA,P_N_SCPAP,P_N_SCCTA,P_N_SCOPER,P_N_SCSBOP,P_N_SCTOPE,P_N_SCMOD,ld_feccor+1);
      For j in c_opciones(ln_salcor) loop
        ln_opcgui := j.Tp1imp3;
      End loop;  
      If ln_opcgui > 0 then
          --opciones por incremento mayor al 50% respecto al sorteo anterior o a la fecha de apertura
          If P_N_FECAPE >= i.Tp1nro1 AND P_N_FECAPE <= i.Tp1nro2 then
            ld_fecape := to_date(to_char(P_N_FECAPE),'yyyymmdd');
            ln_salhis := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_saldo_fsh014(P_N_PGCOD,P_N_SCSUC,/*P_N_SCRUB,*/P_N_SCMDA,P_N_SCPAP,P_N_SCCTA,P_N_SCOPER,P_N_SCSBOP,P_N_SCTOPE,P_N_SCMOD,ld_fecape+1);
          Else
            For k in c_sorteo_ant(P_N_NUMSOR-1) Loop
              cont := cont + 1;
              ld_fecpro := to_date(to_char(k.Tp1nro2),'yyyymmdd');
              ln_salhis := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_saldo_fsh014(P_N_PGCOD,P_N_SCSUC,/*P_N_SCRUB,*/P_N_SCMDA,P_N_SCPAP,P_N_SCCTA,P_N_SCOPER,P_N_SCSBOP,P_N_SCTOPE,P_N_SCMOD,ld_fecpro+1);
            End Loop;
            If cont  = 0 then
              ld_fecpro := to_date(to_char(i.Tp1nro1),'yyyymmdd');
              ln_salhis := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_saldo_fsh014(P_N_PGCOD,P_N_SCSUC,/*P_N_SCRUB,*/P_N_SCMDA,P_N_SCPAP,P_N_SCCTA,P_N_SCOPER,P_N_SCSBOP,P_N_SCTOPE,P_N_SCMOD,ld_fecpro+1);          
            End If;                  
          End If;  
          
          If ln_salcor >= ln_salhis*2 Then
             ln_opcgui := ln_opcgui*2;       
          End If;                   
      End If;
    End Loop;
   
  ln_numopc := ln_numopc + ln_opcgui;    
  return ln_numopc;
  Exception
  when others then
    --lc_error := sqlerrm;
    return ln_numopc;  
  End fn_ah_num_opciones;  
  
  Function fn_ah_saldo_fsh014(P_N_PGCOD  IN NUMBER,
                              P_N_SCSUC  IN NUMBER,
--                              P_N_SCRUB  IN NUMBER,
                              P_N_SCMDA  IN NUMBER,
                              P_N_SCPAP  IN NUMBER, 
                              P_N_SCCTA  IN NUMBER,
                              P_N_SCOPER IN NUMBER, 
                              P_N_SCSBOP IN NUMBER,
                              P_N_SCTOPE IN NUMBER,
                              P_N_SCMOD  IN NUMBER,
                              P_D_FECPRO IN DATE
                             ) return number is
  ln_salhis number(18,2):=0;  
  begin
   /*select y.bcsdmo
     into ln_salhis 
     from fsh012 y 
    where y.bcemp  = P_N_PGCOD
      and y.bcsuc  = P_N_SCSUC
      and y.bcrubr = P_N_SCRUB
      and y.bcmda  = P_N_SCMDA
      and y.bcpap  = P_N_SCPAP
      and y.bccta  = P_N_SCCTA
      and y.bcoper = P_N_SCOPER
      and y.bcsbop = P_N_SCSBOP
      and y.bctop  = P_N_SCTOPE
      and y.bcfech = P_D_FECPRO
      and y.bcmod  = P_N_SCMOD; */
           
      -- funcion MERSALI 
      begin
        -- Call the procedure
        sp_saldo_origen_cv(vpgcod  => P_N_PGCOD,
                           vscsuc  => P_N_SCSUC,
                           vscmod  => P_N_SCMOD,
                           vscmda  => P_N_SCMDA,
                           vscpap  => P_N_SCPAP,
                           vsccta  => P_N_SCCTA,
                           vscoper => P_N_SCOPER,
                           vscsbop => P_N_SCSBOP,
                           vsctope => P_N_SCTOPE,
                           vfecini => P_D_FECPRO,
                           vsdoor  => ln_salhis
                           );
      end;      

      
      
    return ln_salhis;
  Exception    
  When others then
    ln_salhis := 0;    
    return ln_salhis;
  end fn_ah_saldo_fsh014;      
                 
  Function fn_ah_valida_region(P_N_SCSUC IN NUMBER,
                               P_N_CODPAI IN NUMBER,
                               P_N_CODTPD IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2
                              ) return varchar2 is
  lc_indreg char(1):='N';  
  begin
      begin
        select 'N'
          into lc_indreg
          from fst810 a,
               fst811 b
         where a.pgcod  = b.pgcod
           and a.regcod = b.regcod
           and a.regcod < 100
           and b.regcod < 100
           and b.oficod = P_N_SCSUC
           and a.regcod not in (1,11,12);
        return lc_indreg;    
      Exception  
      When others then
        lc_indreg := 'S';
      End;  
      --verificamos residencia
      begin
         select 'N'
           into lc_indreg
           from sngc13
          where sngc13pais = P_N_CODPAI
            and sngc13tdoc = P_N_CODTPD
            and sngc13ndoc = P_C_NUMDOC
            and docod      = 1
            and sngc13est  = 'H'
            and sngc13dpto <> 4;
        return lc_indreg;                
      Exception
      When others then  
        lc_indreg := 'S';
      end;
    return lc_indreg;       
  Exception
  When others then
    lc_indreg := 'N';
    return lc_indreg;        
  End fn_ah_valida_region;
  Function fn_ah_opciones_web(P_N_CODPAI IN NUMBER,
                              P_N_CODTPD IN NUMBER,
                              P_C_NUMDOC IN VARCHAR2
                              ) return number is
  ln_codcam number(9):= 1;
  ln_numopc number(9):= 0;          
  ln_totopc number(9):= 0;          
  ln_fecha  number(8):= 0;    
  ln_numsor number(9):= 0;        
  lc_codest char(1)  := 'V';        
  begin
    begin
      select sum(jaql489opt)
        into ln_numopc
        from jaql489
       where jaql489cmp = ln_codcam
         and jaql489pai = P_N_CODPAI
         and jaql489tpo = P_N_CODTPD
         and jaql489nro = RPAD(P_C_NUMDOC,12,' ')
         and jaql489est = lc_codest
       group by jaql489pai, jaql489tpo, jaql489nro;  
    Exception
    When others then   
      ln_numopc := 0;
    end;
    ln_totopc := ln_totopc + ln_numopc;
    ln_fecha := to_number(to_char(trunc(sysdate),'rrrrmmdd'));
    
    begin
    select Tp1imp1
      into ln_numsor 
      from FST198
     Where Tp1cod1 = 10825 
       and Tp1corr1 = 12
       and Tp1corr2 = 1
       --and ln_fecha between tp1nro1 and tp1nro2;
       and Tp1nro3  = ln_fecha;
    Exception    
    when others then
      ln_numsor := 0;      
    end;      
    
    begin
      select sum(jaql489oct)
        into ln_numopc
        from jaql489
       where jaql489cmp = ln_codcam
         and jaql489pai = P_N_CODPAI
         and jaql489tpo = P_N_CODTPD
         and jaql489nro = RPAD(P_C_NUMDOC,12,' ')       
         and jaql489est = lc_codest
         and jaql489nso = ln_numsor
       group by jaql489pai, jaql489tpo, jaql489nro;
    Exception
    When Others then   
      ln_numopc := 0;  
    End;
    ln_totopc := ln_totopc + ln_numopc;  
    
    return ln_totopc;
  Exception
  When others then  
    ln_totopc := 0;
    return ln_totopc;  
  end fn_ah_opciones_web;
      
  end PQ_AH_CAMPANA_ROJINEGRA;
/

