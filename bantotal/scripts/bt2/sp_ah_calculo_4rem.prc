create or replace procedure sp_ah_calculo_4rem(P_D_FECPRO IN DATE,
                                               P_N_MONABO IN NUMBER,
                                               P_N_NUMCTA IN NUMBER,
                                               P_N_SUBOPE IN NUMBER, 
                                               P_N_CODMON IN NUMBER,
                                               P_N_CODMOD IN VARCHAR2,
                                               p_n_mtorem out number,
                                               p_c_coderr out varchar2,
                                               p_c_msgerr out varchar2
                                               ) is
  ln_ctaemp  number(9):= 0;
  ln_pais    number(3):= 0;
  ln_tipo    number(2):= 0;
  lc_numero  char(12) := null;
  ln_pais1   number(3):= 0;
  ln_tipo1   number(2):= 0;
  lc_numero1 char(12) := null;  
  cursor c_remuneraciones(LN_PEPAIS1 in number,
                          LN_PETDOC1 in number,
                          LN_PENDOC1 in char,
                          LN_PEPAIS  in number,
                          LN_PETDOC  in number,
                          LN_PENDOC  in char)   
   is
    select /*nvl(round(case
             when ctsmdarm = P_N_CODMON then
               ctsimprm
             when ctsmdarm <> P_N_CODMON and ctsmdarm = 0 then
              ctsimprm * fn_tipo_cambio(P_D_FECPRO,P_N_CODMON,ctsmdarm,0)
             when ctsmdarm <> P_N_CODMON and ctsmdarm = 101 then
              ctsimprm / fn_tipo_cambio(P_D_FECPRO,P_N_CODMON,ctsmdarm,0)
             else
              ctsimprm
           end,2),0) remuneracion,*/
           nvl(round(ctsimprm,2),0)  remuneracion,
           nvl(ctsmdarm,0) moneda_rem
      from (Select kk.CTSPEMP1,
                   kk.CTSTEMP1,
                   kk.CTSNEMP1,
                   kk.CTSPEMP2,
                   kk.CTSTEMP2,
                   kk.CTSNEMP2,
                   kk.CTSCTAE2,
                   kk.CTSTIPRG,
                   kk.CTSFECRG,
                   kk.ctsimprm,
                   kk.ctsmdarm,
                   kk.ctsauxn2
              from cts001 kk
             where kk.CTSTIPRG = 1
               and kk.CTSPEMP1 > 0
               and trim(kk.CTSNEMP2) is not null
               and kk.CTSUSURG <> 'BANTOTAL'
               and kk.CTSCTAE2 = P_N_NUMCTA
               and trunc(kk.ctsauxn2 / 1000) = P_N_SUBOPE
               and kk.ctsauxn2 - (P_N_SUBOPE * 1000) = P_N_CODMON
               and kk.CTSPEMP1 = LN_PEPAIS1
               and kk.CTSTEMP1 = LN_PETDOC1
               and kk.CTSNEMP1 = LN_PENDOC1
               and kk.CTSPEMP2 = LN_PEPAIS
               and kk.CTSTEMP2 = LN_PETDOC
               and kk.CTSNEMP2 = LN_PENDOC
          order by CTSFECRG desc, CTSHORRG desc
           )
     where rownum <2;   
      
  cursor c_retiros(ln_ctaemp in number, ln_mdarem in number,ld_fecret in date) is
     select --nvl(sum(b.hcimp1),0) retiros 
            nvl(sum(round(case
                   when ln_mdarem = a.scmda then
                    b.hcimp1
                   when ln_mdarem <> a.scmda and ln_mdarem = 0 then                    
                    b.hcimp1 * fn_tipo_cambio(P_D_FECPRO,a.scmda,ln_mdarem,0)
                   when ln_mdarem <> a.scmda and ln_mdarem = 101 then
                    b.hcimp1 / fn_tipo_cambio(P_D_FECPRO,a.scmda,ln_mdarem,0)
                   else
                    b.hcimp1
                   end,2)),0) retiros    
       from fsd011 a,
            fsh016 b,
            fsh015 d,
            fsr011 c
      where a.pgcod  = c.r1cod
        and a.scmda  = c.r2mda
        and a.scpap  = c.r2pap
        and a.sccta  = c.r2cta
        and a.scoper = c.r2oper
        and a.scsbop = c.r2sbop
        and a.scsuc  = c.r2suc
        and a.sctope = c.r2tope
        and a.scmod  = c.r2mod
        and b.pgcod  = d.pgcod
        and b.hcmod  = d.hcmod
        and b.hsucor = d.hsucor
        and b.htran  = d.htran
        and b.hnrel  = d.hnrel
        and b.hfcon  = d.hfcon 
        and d.hccorr <> 99       
        and c.r011co = 'S'
        and c.relcod = 45
        and c.r1cta  = ln_ctaemp
        and b.hfcon >= ld_fecret 
        and b.hmodul = 21 
        and b.hcodmo = 1
        and b.pgcod  = a.pgcod
        and b.htoper = a.sctope
        and b.hsucur = a.scsuc
        and b.hrubro = a.SCRUB
        and b.hmda   = a.SCMDA
        and b.hpap   = a.scpap
        and b.hcta   = a.sccta
        and b.hoper  = a.scoper
        and b.hsubop = a.SCSBOP 
        and a.pgcod  = 1
        --and a.scsbop = P_N_SUBOPE
        and a.sccta  = P_N_NUMCTA
        --and a.scmda  = P_N_CODMON
        and a.scoper = 0
        and a.scpap  = 0
        and a.sctope = 2
        and a.scmod  = 21
union all
     select --nvl(sum(c.itimp1),0) interes
            nvl(sum(round(case
                   when ln_mdarem = d.scmda then
                     c.itimp1
                   when ln_mdarem <> d.scmda and ln_mdarem = 0 then
                    c.itimp1 * fn_tipo_cambio(P_D_FECPRO,d.scmda,ln_mdarem,0)
                   when ln_mdarem <> d.scmda and ln_mdarem = 101 then
                    c.itimp1 / fn_tipo_cambio(P_D_FECPRO,d.scmda,ln_mdarem,0)
                   else
                    c.itimp1
                   end,2)),0) retiros    
       from fsd011 d,
            fsd016 c,
            fsd015 g,
            fsr011 e
      where d.pgcod  = e.r1cod
        and d.scmda  = e.r2mda
        and d.scpap  = e.r2pap
        and d.sccta  = e.r2cta
        and d.scoper = e.r2oper
        and d.scsbop = e.r2sbop
        and d.scsuc  = e.r2suc
        and d.sctope = e.r2tope
        and d.scmod  = e.r2mod
        and c.pgcod  = g.pgcod
        and c.itmod  = g.itmod
        and c.itsuc  = g.itsuc
        and c.ittran = g.ittran
        and c.itnrel = g.itnrel
        and g.itcont = 'S'
        and g.itcorr <> 99                   
        and e.r011co = 'S'
        and e.relcod = 45
        and e.r1cta  = ln_ctaemp
        --and g.itfcon = ld_fecret
        and c.modulo = 21 
        and c.itdbha = 1
        and c.pgcod  = d.pgcod
        and c.ittope = d.sctope
        and c.itsucd = d.scsuc
        and c.rubro  = d.SCRUB
        and c.moneda = d.SCMDA
        and c.papel  = d.scpap
        and c.ctnro  = d.sccta
        and c.itoper = d.scoper
        and c.itsubo = d.SCSBOP 
        and d.pgcod  = 1
        --and d.scsbop = P_N_SUBOPE
        and d.sccta  = P_N_NUMCTA
        --and d.scmda  = P_N_CODMON
        and d.scoper = 0
        and d.scpap  = 0
        and d.sctope = 2
        ; 
  cursor c_exoneraciones(ln_pais in number, ln_tipo in number, lc_numero in char, ln_mdarem in number) is
   Select --nvl(sum(a.tp1imp1),0) 
          nvl(sum(round(case
                 when ln_mdarem = 0 then
                   a.tp1imp1
                 when ln_mdarem = 101 then                
                  a.tp1imp1 / fn_tipo_cambio(P_D_FECPRO,0,ln_mdarem,0)
                 else
                  a.tp1imp1
                 end,2)),0) exoneracion                
     from fst198 a
    where a.tp1cod = 1
      and a.tp1cod1 = 10825
      and a.tp1corr1 = 96
      and a.tp1corr2 = 2 --estos montos estan en soles
   union all     
   Select --nvl(sum(b.aqpa116rem ),0)
          nvl(sum(case
                    When nvl(c.aqpa116aax3, 0) = 0 then
                     nvl(b.aqpa116rem, 0)
                    Else
                     nvl(c.aqpa116aax3, 0)
                  End
                 ),
              0)
     from aqpa116 b, aqpa116a c
    where b.aqpa116pai = c.aqpa116apai
      and b.aqpa116tpo = c.aqpa116atpo
      and b.aqpa116num = c.aqpa116anum
      and b.aqpa116fec = c.aqpa116afec
      and b.aqpa116pai = ln_pais
      and b.aqpa116tpo = ln_tipo
      and b.aqpa116num = lc_numero
      and b.aqpa116est = 'S'
      and c.aqpa116aest = 'E'
      and b.aqpa116rem > 0;
      
   ln_monrem number(17,2):=0;   
   ln_monret number(17,2):=0;  
   ln_salcon number(17,2):=0; 
   ln_monexo number(17,2):=0;  
   ln_mo4rem number(17,2):=0;  
   ln_mdarem number(4):=0;
   ln_mtoabo number(17,2):=0; 
   ln_mongob number(17,2):=0; 
   ld_fecret date;
begin
  p_c_coderr := '000';
  --obtenemos empleador vigente de la cuenta cliente del trabajador
  begin
    Select a.r1cta
      into ln_ctaemp
      from fsr011 a
     where a.r1cod  = 1
       and a.relcod = 45
       and a.r2mod  = 21
       and a.r2cta  = P_N_NUMCTA
       and a.r2oper = 0
       and a.r2sbop = P_N_SUBOPE
       and a.r2cod  = 1
       and a.r2pap  = 0
       and a.r2tope = 2
       and a.r011co = 'S';
  exception
  when others then
    ln_ctaemp := 0;
    p_c_coderr := '001';
    p_c_msgerr := 'No se encontró cuenta cliente del empleador';
    return;
  end;
  if ln_ctaemp  > 0 then
    --obtenemos pais tipo y numero del empleado
    begin
     Select a.pepais, a.petdoc, a.pendoc
       into ln_pais, ln_tipo, lc_numero     
       from fsr008 a
      where a.pgcod = 1
        and a.ctnro = P_N_NUMCTA
        and a.ttcod = 1
        and a.cttfir = 'T';
    exception
    when others then
      ln_pais   := 0;
      ln_tipo   := 0;
      lc_numero := 0;
      p_c_coderr := '002';
      p_c_msgerr := 'No se encontró documento del empleado';
      return;      
    end;    
    --obtenemos pais tipo y numero del empleador
    begin
       Select a.pepais, a.petdoc, a.pendoc
         into ln_pais1, ln_tipo1, lc_numero1
         from fsr008 a
        where a.pgcod = 1
          and a.ctnro = ln_ctaemp
          and a.ttcod = 1
          and a.cttfir = 'T';
    exception
    when others then
      ln_pais1   := 0;
      ln_tipo1   := 0;
      lc_numero1 := 0;
      p_c_coderr := '003';
      p_c_msgerr := 'No se encontró documento del empleador';
      return;      
    end;
    if ln_pais >0 and ln_pais1 >0 then
      -- OBTENEMOS ULTIMO MONTO DE 4 REMUNERACIONES
      ln_monrem := 0;
      ln_mdarem := 0;
      For i in c_remuneraciones(ln_pais1,ln_tipo1,lc_numero1,ln_pais,ln_tipo,lc_numero) loop
        ln_monrem := i.remuneracion;
        ln_mdarem := i.moneda_rem;
      End Loop;
      
      if ln_monrem = 0 then
         ln_mdarem := P_N_CODMON;
      End if;
      
      begin
       Select --nvl(sum(a.tp1imp1),0) 
              nvl(sum(round(case
                     when ln_mdarem = 0 then
                       a.tp1imp1
                     when ln_mdarem = 101 then                
                      a.tp1imp1 / fn_tipo_cambio(P_D_FECPRO,0,ln_mdarem,0)
                     else
                      a.tp1imp1
                     end,2)),0) exoneracion  
         into ln_mongob              
         from fst198 a
        where a.tp1cod = 1
          and a.tp1cod1 = 10825
          and a.tp1corr1 = 96
          and a.tp1corr2 = 2 ;  
      exception
      when others then  
        ln_mongob := 0;      
      end;
      
      if ln_mongob = 0 then
         begin
           Select b.aqpa116fec
             into ld_fecret
             from aqpa116  b,
                  aqpa116a c
            where b.aqpa116pai  = c.aqpa116apai
              and b.aqpa116tpo  = c.aqpa116atpo
              and b.aqpa116num  = c.aqpa116anum
              and b.aqpa116fec  = c.aqpa116afec
              and b.aqpa116pai  = ln_pais
              and b.aqpa116tpo  = ln_tipo
              and b.aqpa116num  = lc_numero
              and b.aqpa116est  = 'S'
              and c.aqpa116aest = 'E'
              and b.aqpa116rem  > 0
              ;
         exception
         when others then
           ld_fecret := null;          
         end;
      Else
        ld_fecret := to_date('28/03/2020','dd/mm/rrrr'); 
      End If;
      
      if ld_fecret is not null then
        --OBTENEMOS MONTO DE RETIROS
        ln_monret := 0;
        For i in c_retiros(ln_ctaemp,ln_mdarem,ld_fecret) loop
          ln_monret := ln_monret + i.retiros;
        End Loop;  
      Else
        ln_monret := 0;
      end if;
      --OBTENEMOS EL MONTO ADICIONAL EXONERADO
      ln_monexo := 0;
      For i in c_exoneraciones(ln_pais, ln_tipo, lc_numero,ln_mdarem) loop
        ln_monexo := ln_monexo + i.exoneracion;
      End Loop;  
      --OBTENEMOS EL SALDO DE LA FSD011
      ln_salcon := 0;
      begin
         Select   nvl(round(sum(case
                             when ln_mdarem = a.scmda then
                               a.scsdo
                             when ln_mdarem <> a.scmda and ln_mdarem = 0 then                               
                              a.scsdo * fn_tipo_cambio(P_D_FECPRO,a.scmda,ln_mdarem,0)
                             when ln_mdarem <> a.scmda and ln_mdarem = 101 then
                              a.scsdo / fn_tipo_cambio(P_D_FECPRO,a.scmda,ln_mdarem,0)
                             else
                              a.scsdo
                             end
                             )
                        ,2),0)
           into ln_salcon
           from fsd011 a,
                fsr011 b
          where a.pgcod  = b.r1cod
            and a.scmda  = b.r2mda
            and a.scpap  = b.r2pap
            and a.sccta  = b.r2cta
            and a.scoper = b.r2oper
            and a.scsbop = b.r2sbop
            and a.scsuc  = b.r2suc
            and a.sctope = b.r2tope
            and a.scmod  = b.r2mod
            and b.r011co = 'S'
            and b.relcod = 45
            and b.r1cta  = ln_ctaemp
            and a.pgcod  = 1
            and a.scmod  = 21
            and a.scpap  = 0
            and a.scoper = 0
            and a.sctope = 2
            and a.sccta  = P_N_NUMCTA
            and a.scsdo <> 0
            and a.scstat <> 99;
            --and a.scsbop = P_N_SUBOPE
            --and a.scmda  = P_N_CODMON;
      Exception
      when no_data_found then
        ln_salcon := 0;        
        p_c_coderr := '004';
        p_c_msgerr := 'No se encontró fsd011 para subcuenta';
        return;                
      when others then
        ln_salcon := 0;
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
        return;        
      end; 
      if ln_mdarem = P_N_CODMON then        
         ln_mtoabo := P_N_MONABO;
      Else
         if ln_mdarem = 0 then
            ln_mtoabo := P_N_MONABO * fn_tipo_cambio(P_D_FECPRO,P_N_CODMON,ln_mdarem,0);
         Else
            ln_mtoabo := P_N_MONABO / fn_tipo_cambio(P_D_FECPRO,P_N_CODMON,ln_mdarem,0);
         End If;
      End If;
      if ln_monrem = 0 then
         ln_monrem := ln_salcon + ln_mtoabo;
      End if;
      
      If (ln_salcon + ln_mtoabo) < (ln_monexo-ln_monret) then        
           ln_mo4rem := 0.01;
      Else
        if ((ln_salcon + ln_mtoabo) - (ln_monexo-ln_monret)) > ln_monrem and ln_monrem>0 then
             ln_mo4rem := ln_monrem - (ln_monexo-ln_monret);
        else
           If (ln_salcon + ln_mtoabo) - ln_monrem > 0 then
             ln_mo4rem := ln_monrem - ln_monexo;            
           Else
             ln_mo4rem := (ln_salcon + ln_mtoabo) - (ln_monexo-ln_monret);
           End if;                    
        end if;
      End if;
      if ln_mo4rem > ln_monrem then
         ln_mo4rem := ln_monrem;
      End if;      
      if ln_mo4rem <=0 then
         ln_mo4rem := 0.01;
      End if;      
      
      p_n_mtorem := ln_mo4rem;
      if P_N_CODMOD = 'INS' then --registramos los nuevos 4 sueldos
        begin
          insert into cts001
            (CTSPEMP1,
             CTSTEMP1,
             CTSNEMP1,
             CTSPEMP2,
             CTSTEMP2,
             CTSNEMP2,
             CTSCTAE2,
             CTSTIPRG,
             CTSFECRG,
             CTSHORRG,
             CTSUSURG,
             CTSSUCRG,
             CTSMDARM,
             CTSIMPRM,
             CTSEMBPJ, --=0
             CTSEMBOP, --=0
             CTSAUXN2,
             CTSMDACB,
             CTSFECBJ, --DATE
             CTSSUCBJ, --0
             CTSAUXD1,
             CTSAUXD2,
             CTSAUXN1             
             )
          values
            (ln_pais1,
             ln_tipo1,
             lc_numero1,
             ln_pais,
             ln_tipo,
             lc_numero,
             P_N_NUMCTA,
             1,
             P_D_FECPRO,
             to_char(sysdate, 'HH24:mi:ss'),
             'BANTOTAL',
             904,
             ln_mdarem,
             ln_mo4rem,
             0,
             0,
             (P_N_SUBOPE*1000)+P_N_CODMON,
             ln_mdarem,
             to_date('01/01/0001','dd/mm/rrrr'),
             0,
             to_date('01/01/0001','dd/mm/rrrr'),
             to_date('01/01/0001','dd/mm/rrrr'),
             0
             );
             commit;
        exception
        when others then
          p_c_coderr := sqlcode;
          p_c_msgerr := sqlerrm;
          return;            
        end;
      End if;
      if P_N_CODMOD = 'LIB' then --LIBERACION 100%
        begin
          insert into cts001
            (CTSPEMP1,
             CTSTEMP1,
             CTSNEMP1,
             CTSPEMP2,
             CTSTEMP2,
             CTSNEMP2,
             CTSCTAE2,
             CTSTIPRG,
             CTSFECRG,
             CTSHORRG,
             CTSUSURG,
             CTSSUCRG,
             CTSMDARM,
             CTSIMPRM,
             CTSEMBPJ, --=0
             CTSEMBOP, --=0
             CTSAUXN2,
             CTSMDACB,
             CTSFECBJ, --DATE
             CTSSUCBJ, --0
             CTSAUXD1,
             CTSAUXD2,
             CTSAUXN1             
             )
          values
            (ln_pais1,
             ln_tipo1,
             lc_numero1,
             ln_pais,
             ln_tipo,
             lc_numero,
             P_N_NUMCTA,
             1,
             P_D_FECPRO,
             to_char(sysdate, 'HH24:mi:ss'),
             'BANTOTAL',
             904,
             ln_mdarem,
             0.01,
             0,
             0,
             (P_N_SUBOPE*1000)+P_N_CODMON,
             ln_mdarem,
             to_date('01/01/0001','dd/mm/rrrr'),
             0,
             to_date('01/01/0001','dd/mm/rrrr'),
             to_date('01/01/0001','dd/mm/rrrr'),
             0
             );
             commit;
        exception
        when others then
          p_c_coderr := sqlcode;
          p_c_msgerr := sqlerrm;
          return;            
        end;                  
      End if;      
    Else
      p_c_coderr := '005';
      p_c_msgerr := 'Código de pais no puede ser cero';      
    End if;
  Else
      p_c_coderr := '006';
      p_c_msgerr := 'Cuenta del empleador es cero';     
  End If;
Exception
when others then
  p_c_coderr := sqlcode;
  p_c_msgerr := sqlerrm;
  return;  
end sp_ah_calculo_4rem;
/

