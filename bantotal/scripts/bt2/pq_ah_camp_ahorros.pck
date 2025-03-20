create or replace package PQ_AH_CAMP_AHORROS is

  -- Author  : YLOZADA
  -- Created : 5/11/2018 11:48:32 a. m.
  -- Purpose : 
  

  procedure sp_ah_lanza_camp(P_D_FECPRO IN DATE,
                             P_C_CODUSU IN VARCHAR2,                                            
                             p_c_coderr out varchar2,
                             p_c_deserr out varchar2              
                            );
  procedure sp_ah_cargadata_camp2(P_N_CODCAM IN NUMBER,
                                  P_D_FECPRO IN DATE, 
                                  p_c_coderr out varchar2, 
                                  p_c_deserr out varchar2 
                                 );
  procedure sp_ah_cargadata_camp3(P_N_CODCAM IN NUMBER,
                                  P_D_FECPRO IN DATE, 
                                  p_c_coderr out varchar2, 
                                  p_c_deserr out varchar2 
                                 );                                 
  procedure sp_ah_ejecuta_camp1(P_N_CODCAM IN NUMBER,
                                P_D_FECPRO IN DATE, 
                                P_D_FECINI IN DATE, 
                                P_D_FECFIN IN DATE, 
                                p_c_coderr in out varchar2, 
                                p_c_deserr in out varchar2 
                               );
  procedure sp_ah_ejecuta_camp2(P_N_CODCAM IN NUMBER,
                                P_D_FECPRO IN DATE, 
                                P_D_FECINI IN DATE, 
                                P_D_FECFIN IN DATE,                                 
                                p_c_coderr in out varchar2, 
                                p_c_deserr in out varchar2 
                               );    
  procedure sp_ah_ejecuta_camp3(P_N_CODCAM IN NUMBER,
                                P_D_FECPRO IN DATE, 
                                P_D_FECINI IN DATE, 
                                P_D_FECFIN IN DATE,                                 
                                p_c_coderr in out varchar2, 
                                p_c_deserr in out varchar2 
                               );                                      
  procedure sp_ah_reg_jaqz185(P_D_FECPRO IN DATE,
                              P_C_CODUSU IN VARCHAR2,
                              P_N_CODAGE IN NUMBER,
                              p_c_coderr in out varchar2,
                              p_c_deserr in out varchar2          
                             );                                                                                       
end PQ_AH_CAMP_AHORROS;
/

create or replace package body PQ_AH_CAMP_AHORROS is

  procedure sp_ah_lanza_camp(P_D_FECPRO IN DATE,
                             P_C_CODUSU IN VARCHAR2,                                        
                             p_c_coderr out varchar2,
                             p_c_deserr out varchar2              
                            ) is
  ld_fecini date;                          
  ld_fecfin date;                            
  ld_feccor date;
  ln_numsor number(9):= 0;
  ln_indcar number(9):= 0;
  ln_regcam number(9):= 0;
  ln_sucur  number(3):= 0;
  
  cursor c_campañas is
    Select * 
      from fst198 a 
     where a.TP1COD   = 1 
       and a.TP1COD1  = 10825 
       and a.TP1CORR1 = 80 
       and a.TP1CORR2 = 1 --LISTADO DE CAMPAÑAS AHORROS
       and a.tp1nro3  = 1; --INDICADOR DE CAMPAÑA HABILITADA                           
  begin    
    begin
      Select a.ubsuc 
        into ln_sucur
        from fst046 a 
       where a.pgcod = 1 
         and a.ubuser = rpad(P_C_CODUSU,10,' ');
    exception
    when others then     
      ln_sucur := 0;
    end;
 
    for i in c_campañas loop 
      p_c_coderr := '000';
      p_c_deserr := null;      
      --Verificamos vigencia de la campaña
      begin                    
          Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
            into ld_fecini
            from fst198 a 
           where a.TP1COD   = 1 
             and a.TP1COD1  = 10825 
             and a.TP1CORR1 = 80 
             and a.TP1CORR2 = 2          --fecha de inicio de la campaña 
             and a.tp1nro1  = i.tp1nro1; --código de campaña                   
      exception
      when others then
        p_c_coderr := '001';
        p_c_deserr := 'Campaña: '||trim(upper(i.tp1desc))||'-'||'No existe registrada la fecha de inicio';  
        pq_ah_camp_ahorros.sp_ah_reg_jaqz185(p_d_fecpro => P_D_FECPRO,
                                             p_c_codusu => P_C_CODUSU,
                                             p_n_codage => ln_sucur,
                                             p_c_coderr => p_c_coderr,
                                             p_c_deserr => p_c_deserr
                                             );                        
      end;
      begin                    
          Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
            into ld_fecfin
            from fst198 a 
           where a.TP1COD   = 1 
             and a.TP1COD1  = 10825 
             and a.TP1CORR1 = 80 
             and a.TP1CORR2 = 3          --fecha de fin de la campaña 
             and a.tp1nro1  = i.tp1nro1; --código de campaña                   
      exception
      when others then
        p_c_coderr := '002';
        p_c_deserr := 'Campaña: '||trim(upper(i.tp1desc))||'-'||'No existe registrada la fecha de fin';
        pq_ah_camp_ahorros.sp_ah_reg_jaqz185(p_d_fecpro => P_D_FECPRO,
                                             p_c_codusu => P_C_CODUSU,
                                             p_n_codage => ln_sucur,
                                             p_c_coderr => p_c_coderr,
                                             p_c_deserr => p_c_deserr
                                             );                          
      end;
            
      begin                    
          Select count(1)
            into ln_numsor
            from fst198 a 
           where a.TP1COD   = 1 
             and a.TP1COD1  = 10825 
             and a.TP1CORR1 = 80 
             and a.TP1CORR2 = 4          --fecha de corte de la campaña para sorteos
             and a.tp1nro1  = i.tp1nro1; --código de campaña                   
      exception
      when others then
        p_c_coderr := '003';
        p_c_deserr := 'Campaña: '||trim(upper(i.tp1desc))||'-'||sqlerrm;                                             
      end;
      
      if ln_numsor = 0 then
        p_c_coderr := '003';
        p_c_deserr := 'Campaña: '||trim(upper(i.tp1desc))||'-'||'No existe registrado fechas de corte';
        pq_ah_camp_ahorros.sp_ah_reg_jaqz185(p_d_fecpro => P_D_FECPRO,
                                             p_c_codusu => P_C_CODUSU,
                                             p_n_codage => ln_sucur,
                                             p_c_coderr => p_c_coderr,
                                             p_c_deserr => p_c_deserr
                                             );                              
      End If;  
           
      begin                    
          Select to_date(trim(a.tp1desc),'dd/mm/rrrr'), 
                 a.tp1nro2
            into ld_feccor, 
                 ln_indcar --indicador de carga de data inicial 1= cargar 0 = no cargar
            from fst198 a 
           where a.TP1COD   = 1 
             and a.TP1COD1  = 10825 
             and a.TP1CORR1 = 80 
             and a.TP1CORR2 = 5          --fecha de carga de la data inicial
             and a.tp1nro1  = i.tp1nro1; --código de campaña                   
      exception
      when others then
        p_c_coderr := '004';
        p_c_deserr := 'Campaña: '||trim(upper(i.tp1desc))||'-'||'No existe registrado fecha de carga de la data';
        pq_ah_camp_ahorros.sp_ah_reg_jaqz185(p_d_fecpro => P_D_FECPRO,
                                             p_c_codusu => P_C_CODUSU,
                                             p_n_codage => ln_sucur,
                                             p_c_coderr => p_c_coderr,
                                             p_c_deserr => p_c_deserr
                                             );                                        
      end;      
      
      if P_D_FECPRO >= ld_fecini and P_D_FECPRO <= ld_fecfin then                
        --si todo esta ok invocamos al proceso de carga de data correspondiente
        if p_c_coderr = '000'then             
          if ln_indcar = 1 then
            --Verificamos que no haya data cargada antes de ejecutar el proceso
            begin                    
                Select count(1)
                  into ln_regcam
                  from jaqz167 a 
                 where a.jaqz167cam = i.tp1nro1;
            exception
            when others then
              p_c_coderr := '005';
              p_c_deserr := sqlerrm||'-'||trim(upper(i.tp1desc));                                             
            end;            
            if ln_regcam > 0 then   
               p_c_coderr := '005';
               p_c_deserr := 'Campaña: '||trim(upper(i.tp1desc))||'-'||'Existe data precargada';
               pq_ah_camp_ahorros.sp_ah_reg_jaqz185(p_d_fecpro => P_D_FECPRO,
                                                    p_c_codusu => P_C_CODUSU,
                                                    p_n_codage => ln_sucur,
                                                    p_c_coderr => p_c_coderr,
                                                    p_c_deserr => p_c_deserr
                                                    );                                                  
            else
              --Desactivar el indicador
              update fst198 a 
                 set a.tp1nro2  = 0   
               where a.TP1COD   = 1 
                 and a.TP1COD1  = 10825 
                 and a.TP1CORR1 = 80 
                 and a.TP1CORR2 = 5          --fecha de carga de la data inicial
                 and a.tp1nro1  = i.tp1nro1; --código de campaña                               
            end if;
            
            --CARGAR LA DATA 
                     
               Case
               When i.tp1nro1 = 1 then --CAMPAÑA AHORRO JUVENIL
                    null;
               When i.tp1nro1 = 2 then --CAMPAÑA SABEMOS XQ AHORRAS
                 PQ_AH_CAMP_AHORROS.sp_ah_cargadata_camp2(p_n_codcam => i.tp1nro1,
                                                          p_d_fecpro => ld_feccor,
                                                          p_c_coderr => p_c_coderr,
                                                          p_c_deserr => p_c_deserr
                                                         );
               When i.tp1nro1 = 3 then --CAMPAÑA VIAJA CON CAJA AREQUIPA Y CONOCE EL PERU
                 PQ_AH_CAMP_AHORROS.sp_ah_cargadata_camp3(p_n_codcam => i.tp1nro1,
                                                          p_d_fecpro => ld_feccor,
                                                          p_c_coderr => p_c_coderr,
                                                          p_c_deserr => p_c_deserr
                                                         );                                                         
               Else
                 null;
               End Case; 
               
               if p_c_coderr = '000' then   
                  commit; 
               else
                 p_c_deserr := 'Campaña: '||trim(upper(i.tp1desc))||'-'||p_c_deserr; 
                 pq_ah_camp_ahorros.sp_ah_reg_jaqz185(p_d_fecpro => P_D_FECPRO,
                                                      p_c_codusu => P_C_CODUSU,
                                                      p_n_codage => ln_sucur,
                                                      p_c_coderr => p_c_coderr,
                                                      p_c_deserr => p_c_deserr
                                                      );                                   
               End if;  
          End if;     
          If p_c_coderr = '000' then               
               --EJECUTAMOS EL PROCESO DE LA CAMPAÑA
               if p_c_coderr = '000' then 
                   Case
                   When i.tp1nro1 = 1 then --CAMPAÑA AHORRO JUVENIL
                     PQ_AH_CAMP_AHORROS.sp_ah_ejecuta_camp1(p_n_codcam => i.tp1nro1,
                                                            p_d_fecpro => P_D_FECPRO,
                                                            p_d_fecini => ld_fecini,
                                                            p_d_fecfin => ld_fecfin,
                                                            p_c_coderr => p_c_coderr,
                                                            p_c_deserr => p_c_deserr
                                                           );
                   When i.tp1nro1 = 2 then --CAMPAÑA SABEMOS XQ AHORRAS
                     PQ_AH_CAMP_AHORROS.sp_ah_ejecuta_camp2(p_n_codcam => i.tp1nro1,
                                                            p_d_fecpro => P_D_FECPRO,
                                                            p_d_fecini => ld_fecini,
                                                            p_d_fecfin => ld_fecfin,                                                      
                                                            p_c_coderr => p_c_coderr,
                                                            p_c_deserr => p_c_deserr
                                                           );
                   When i.tp1nro1 = 3 then --CAMPAÑA VIAJA CON CAJA AREQUIPA Y CONOCE EL PERU
                     PQ_AH_CAMP_AHORROS.sp_ah_ejecuta_camp3(p_n_codcam => i.tp1nro1,
                                                            p_d_fecpro => P_D_FECPRO,
                                                            p_d_fecini => ld_fecini,
                                                            p_d_fecfin => ld_fecfin,                                                      
                                                            p_c_coderr => p_c_coderr,
                                                            p_c_deserr => p_c_deserr
                                                           );                                                           
                   Else
                     null;
                   End Case;  
                   
                   if p_c_coderr = '000' then   
                      p_c_deserr := 'Campaña: '||trim(upper(i.tp1desc))||'-'||'Proceso Satisfactorio';      
                   else
                      p_c_deserr := 'Campaña: '||trim(upper(i.tp1desc))||'-'||p_c_deserr;                                                    
                   End if;  
                   pq_ah_camp_ahorros.sp_ah_reg_jaqz185(p_d_fecpro => P_D_FECPRO,
                                                        p_c_codusu => P_C_CODUSU,
                                                        p_n_codage => ln_sucur,
                                                        p_c_coderr => p_c_coderr,
                                                        p_c_deserr => p_c_deserr
                                                        );                    
                 
               End if;       
            End If;            
        End If;  
      End if;        
    end loop;  
  end sp_ah_lanza_camp;     
  Procedure sp_ah_cargadata_camp2(P_N_CODCAM IN NUMBER,
                                  P_D_FECPRO IN DATE, 
                                  p_c_coderr out varchar2, 
                                  p_c_deserr out varchar2 
                                 ) is
  begin
    insert into jaqz167(JAQZ167PGC,JAQZ167SUC,JAQZ167MDA,JAQZ167PAP,JAQZ167CTA,JAQZ167OPE,JAQZ167SBO,JAQZ167TPO,JAQZ167MOD,JAQZ167SDO,JAQZ167FEC,JAQZ167AX5,JAQZ167CAM) 
        select qq.bcemp,qq.bcsuc,qq.bcmda,qq.bcpap,qq.bccta,qq.bcoper,qq.bcsbop,qq.bctop,qq.bcmod,sum(qq.bcsdmo),P_D_FECPRO,max(qq.bcfval),P_N_CODCAM
         from fsh012 qq,
              (
               select z.pgcod,z.ctnro 
                from fsr008 z
               where z.pgcod = 1
                 and z.ttcod = 1
                 and z.cttfir = 'T'
                     minus
                   (  
                   select distinct 
                          x.pgcod,
                          x.ctnro 
                     from fsr008 x,
                          fsd001 y
                    where x.pgcod = 1
                      and x.pepais = y.pepais
                      and x.petdoc = y.petdoc
                      and x.pendoc = y.pendoc
                      and y.petipo = 'J'--44103
                    union 
                   select distinct 
                          a.pgcod,
                          a.ctnro 
                     from fsr008 a,
                          fsd002 b
                    where a.pgcod = 1
                      and a.pepais = b.pfpais
                      and a.petdoc = b.pftdoc
                      and a.pendoc = b.pfndoc
                      and b.pfebco = 'S'
                      and a.ttcod  = 1
                      and a.cttfir = 'T' --trabajadores
                    union
                   select distinct 
                          a.pgcod,
                          a.ctnro 
                     from fsr008 a,
                          fsd002 b,
                          fsr002 c
                    where a.pgcod = 1
                      and a.pepais = c.rppais
                      and a.petdoc = c.rptdoc
                      and a.pendoc = c.rpndoc                
                      and c.pepais = b.pfpais
                      and c.petdoc = b.pftdoc
                      and c.pendoc = b.pfndoc
                      and b.pfebco = 'S'
                      and a.ttcod  = 1
                      and a.cttfir = 'T'
                      and c.rpccyg in (69,71,66,63,70,68,67,75,89) --familiares de trabajadores
                    union
                   select distinct 
                          a.pgcod,
                          a.ctnro 
                     from fsr008 a,
                          fsd002 b,
                          fsr002 c
                    where a.pgcod = 1
                      and a.pepais = c.pepais
                      and a.petdoc = c.petdoc
                      and a.pendoc = c.pendoc
                      and c.rppais = b.pfpais
                      and c.rptdoc = b.pftdoc
                      and c.rpndoc = b.pfndoc
                      and b.pfebco = 'S'
                      and a.ttcod  = 1
                      and a.cttfir = 'T'
                      and c.rpccyg in (69,71,66,63,70,68,67,75,89)  --familiares de trabajadores                    
                   )
              ) ww     
        where qq.bcemp  = ww.pgcod
          and qq.bccta  = ww.ctnro
          and qq.bcfech = P_D_FECPRO
          and qq.bcemp  = 1
          and qq.bcmod  = 21 
          and qq.bctop  = 1 
          and qq.bcoper = 0
          and qq.bcmda  = 0
          and qq.bcpap  = 0  
          and qq.bcsdmo >= 500    
     group by qq.bcemp,qq.bcsuc,qq.bcmda,qq.bcpap,qq.bccta,qq.bcoper,qq.bcsbop,qq.bctop,qq.bcmod;      
     
    p_c_coderr := '000';    
    p_c_deserr := null;         
  exception
  when others then
    rollback;
    p_c_coderr := '00C-1';    
    p_c_deserr := sqlerrm;
  end sp_ah_cargadata_camp2;   
     
  Procedure sp_ah_cargadata_camp3(P_N_CODCAM IN NUMBER,
                                  P_D_FECPRO IN DATE, 
                                  p_c_coderr out varchar2, 
                                  p_c_deserr out varchar2 
                                 ) is
  begin
    insert into jaqz167(JAQZ167PGC,JAQZ167SUC,JAQZ167MDA,JAQZ167PAP,JAQZ167CTA,JAQZ167OPE,JAQZ167SBO,JAQZ167TPO,JAQZ167MOD,JAQZ167SDO,JAQZ167FEC,JAQZ167AX5,JAQZ167CAM) 
        select qq.bcemp,qq.bcsuc,qq.bcmda,qq.bcpap,qq.bccta,qq.bcoper,qq.bcsbop,qq.bctop,qq.bcmod,sum(qq.bcsdmo),P_D_FECPRO,max(qq.bcfval),P_N_CODCAM
         from fsh012 qq,
              (
               select z.pgcod,z.ctnro 
                from fsr008 z
               where z.pgcod = 1
                 and z.ttcod = 1
                 and z.cttfir = 'T'
                     minus
                   (  
                   select distinct 
                          x.pgcod,
                          x.ctnro 
                     from fsr008 x,
                          fsd001 y
                    where x.pgcod = 1
                      and x.pepais = y.pepais
                      and x.petdoc = y.petdoc
                      and x.pendoc = y.pendoc
                      and y.petipo = 'J'--44103
                    union 
                   select distinct 
                          a.pgcod,
                          a.ctnro 
                     from fsr008 a,
                          fsd002 b
                    where a.pgcod = 1
                      and a.pepais = b.pfpais
                      and a.petdoc = b.pftdoc
                      and a.pendoc = b.pfndoc
                      and b.pfebco = 'S'
                      and a.ttcod  = 1
                      and a.cttfir = 'T' --trabajadores
                    union
                   select distinct 
                          a.pgcod,
                          a.ctnro 
                     from fsr008 a,
                          fsd002 b,
                          fsr002 c
                    where a.pgcod = 1
                      and a.pepais = c.rppais
                      and a.petdoc = c.rptdoc
                      and a.pendoc = c.rpndoc                
                      and c.pepais = b.pfpais
                      and c.petdoc = b.pftdoc
                      and c.pendoc = b.pfndoc
                      and b.pfebco = 'S'
                      and a.ttcod  = 1
                      and a.cttfir = 'T'
                      and c.rpccyg in (69,71,66,63,70,68,67,75,89) --familiares de trabajadores
                    union
                   select distinct 
                          a.pgcod,
                          a.ctnro 
                     from fsr008 a,
                          fsd002 b,
                          fsr002 c
                    where a.pgcod = 1
                      and a.pepais = c.pepais
                      and a.petdoc = c.petdoc
                      and a.pendoc = c.pendoc
                      and c.rppais = b.pfpais
                      and c.rptdoc = b.pftdoc
                      and c.rpndoc = b.pfndoc
                      and b.pfebco = 'S'
                      and a.ttcod  = 1
                      and a.cttfir = 'T'
                      and c.rpccyg in (69,71,66,63,70,68,67,75,89)  --familiares de trabajadores                    
                   )
              ) ww     
        where qq.bcemp  = ww.pgcod
          and qq.bccta  = ww.ctnro
          and qq.bcfech = P_D_FECPRO
          and qq.bcemp  = 1
          and qq.bcmod  = 21 
          and qq.bctop  IN (1,6,8,9)
          and qq.bcoper = 0
          and qq.bcmda  = 0
          and qq.bcpap  = 0  
     group by qq.bcemp,qq.bcsuc,qq.bcmda,qq.bcpap,qq.bccta,qq.bcoper,qq.bcsbop,qq.bctop,qq.bcmod;          
    p_c_coderr := '000';    
    p_c_deserr := null;         
  exception
  when others then
    rollback;
    p_c_coderr := '00C-1';    
    p_c_deserr := sqlerrm;
  end sp_ah_cargadata_camp3;  
       
  Procedure sp_ah_ejecuta_camp1(P_N_CODCAM IN NUMBER,
                                P_D_FECPRO IN DATE, 
                                P_D_FECINI IN DATE, 
                                P_D_FECFIN IN DATE, 
                                p_c_coderr in out varchar2, 
                                p_c_deserr in out varchar2 
                               ) is
  ln_monopt number(17,2):=0;     
  ld_feccor date;   
  begin
     --obtenemos el valor del parámetro
      begin
        select x.tp1imp1
          into ln_monopt 
          from fst198 x
         where x.tp1cod   = 1
           and x.tp1cod1  = 10825
           and x.tp1corr1 = 80
           and x.tp1corr2 = 6
           and x.tp1nro1  = P_N_CODCAM;
      exception
      when no_data_found then
        p_c_coderr := '001-'||P_N_CODCAM;
        p_c_deserr := 'No se encontró monto parametrizado para calular opciones';
      when others then
        p_c_coderr := '001-'||P_N_CODCAM;
        p_c_deserr := sqlerrm;       
      end;
      
      if p_c_coderr = '000' then         
         begin  
                  MERGE INTO JAQZ168 D
                  USING (                  
                                select P_N_CODCAM CODCAM,
                                       qq.PGCOD,
                                       qq.SCSUC,
                                       qq.SCMDA,
                                       qq.SCPAP,
                                       qq.SCCTA,
                                       qq.SCOPER,
                                       qq.SCSBOP,
                                       qq.SCTOPE,
                                       qq.SCMOD,
                                       sum(qq.SCSDO)  Saldo,
                                       P_D_FECPRO     Fecpro,
                                       max(qq.scfval) Fecval,
                                       case
                                            when  max(qq.scfval) > P_D_FECINI then
                                              (P_D_FECPRO - max(qq.scfval) + 1)
                                            Else
                                              (P_D_FECPRO - P_D_FECINI + 1)
                                       End Dias                                     
                                  from fsd011 qq,
                                       (Select z.pgcod,z.ctnro 
                                          from fsr008 z,
                                               fsd002 w
                                         where z.pepais = w.pfpais
                                           and z.petdoc = w.pftdoc
                                           and z.pendoc = w.pfndoc
                                           and z.pgcod = 1
                                           and z.ttcod = 1
                                           and z.cttfir = 'T'
                                           and case
                                               when months_between((Select pgfape from fst017 where pgcod=1),w.pffnac) >=  216 and months_between((Select pgfape from fst017 where pgcod=1),w.pffnac) < 312 then
                                                    'S'
                                               when months_between((Select pgfape from fst017 where pgcod=1),w.pffnac) < 216 then
                                                    'N'            
                                               else
                                                    'N'
                                               end = 'S'                                      
                                        minus (select distinct x.pgcod, x.ctnro
                                                from fsr008 x, fsd001 y
                                               where x.pgcod = 1
                                                 and x.pepais = y.pepais
                                                 and x.petdoc = y.petdoc
                                                 and x.pendoc = y.pendoc
                                                 and y.petipo = 'J' --44103
                                              union
                                              select distinct a.pgcod, a.ctnro
                                                from fsr008 a, fsd002 b
                                               where a.pgcod = 1
                                                 and a.pepais = b.pfpais
                                                 and a.petdoc = b.pftdoc
                                                 and a.pendoc = b.pfndoc
                                                 and b.pfebco = 'S'
                                                 and a.ttcod = 1
                                                 and a.cttfir = 'T'
                                              union
                                             select distinct 
                                                    a.pgcod,
                                                    a.ctnro 
                                               from fsr008 a,
                                                    fsd002 b,
                                                    fsr002 c
                                              where a.pgcod = 1
                                                and a.pepais = c.rppais
                                                and a.petdoc = c.rptdoc
                                                and a.pendoc = c.rpndoc                
                                                and c.pepais = b.pfpais
                                                and c.petdoc = b.pftdoc
                                                and c.pendoc = b.pfndoc
                                                and b.pfebco = 'S'
                                                and a.ttcod  = 1
                                                and a.cttfir = 'T'
                                                and c.rpccyg in (69,71,66,63,70,68,67,75,89) --familiares de trabajadores
                                              union
                                             select distinct 
                                                    a.pgcod,
                                                    a.ctnro 
                                               from fsr008 a,
                                                    fsd002 b,
                                                    fsr002 c
                                              where a.pgcod = 1
                                                and a.pepais = c.pepais
                                                and a.petdoc = c.petdoc
                                                and a.pendoc = c.pendoc
                                                and c.rppais = b.pfpais
                                                and c.rptdoc = b.pftdoc
                                                and c.rpndoc = b.pfndoc
                                                and b.pfebco = 'S'
                                                and a.ttcod  = 1
                                                and a.cttfir = 'T'
                                                and c.rpccyg in (69,71,66,63,70,68,67,75,89)  --familiares de trabajadores                                                                 
                                               )
                                       ) ww
                                 where qq.pgcod  = ww.pgcod
                                   and qq.sccta  = ww.ctnro
                                   and qq.pgcod  = 1
                                   and qq.scmod  = 21
                                   and qq.sctope = 1
                                   and qq.scmda  = 0
                                   and qq.scpap  = 0
                                   and qq.scoper = 0
                                   and qq.scstat not in (81, 99)
                                 group by qq.PGCOD,
                                          qq.SCSUC,
                                          qq.SCMDA,
                                          qq.SCPAP,
                                          qq.SCCTA,
                                          qq.SCOPER,
                                          qq.SCSBOP,
                                          qq.SCTOPE,
                                          qq.SCMOD                                        
                        ) S            
                 ON (   D.JAQZ168PGC(+) = S.PGCOD
                    AND D.JAQZ168SUC(+) = S.SCSUC
                    AND D.JAQZ168MDA(+) = S.SCMDA
                    AND D.JAQZ168PAP(+) = S.SCPAP
                    AND D.JAQZ168CTA(+) = S.SCCTA
                    AND D.JAQZ168OPE(+) = S.SCOPER
                    AND D.JAQZ168SBO(+) = S.SCSBOP
                    AND D.JAQZ168TPO(+) = S.SCTOPE
                    AND D.JAQZ168MOD(+) = S.SCMOD   
                    AND D.JAQZ168CAM(+) = S.CODCAM    
                    AND D.JAQZ168CAM    = P_N_CODCAM                                                                                                 
                    )
                WHEN MATCHED THEN
                  UPDATE SET D.JAQZ168SDO = case
                                            when D.JAQZ168MOD = 21 then
                                              D.JAQZ168SDO + S.Saldo
                                            Else
                                              D.JAQZ168SDO
                                            End,  
                             D.JAQZ168FEC = S.Fecpro,
                             D.JAQZ168AX1 = case
                                            when  D.JAQZ168AX5 > P_D_FECINI then
                                              (P_D_FECPRO - D.JAQZ168AX5 + 1)
                                            Else
                                              (P_D_FECPRO - P_D_FECINI + 1)
                                            End  
                WHEN NOT MATCHED THEN                
                  INSERT
                    (D.JAQZ168PGC,
                     D.JAQZ168SUC,
                     D.JAQZ168MDA,
                     D.JAQZ168PAP,
                     D.JAQZ168CTA,
                     D.JAQZ168OPE,
                     D.JAQZ168SBO,
                     D.JAQZ168TPO,
                     D.JAQZ168MOD,
                     D.JAQZ168SDO,
                     D.JAQZ168FEC,
                     D.JAQZ168AX5,
                     D.JAQZ168AX1,
                     D.JAQZ168CAM
                     )
                  VALUES
                    (S.PGCOD,
                     S.SCSUC,
                     S.SCMDA,
                     S.SCPAP,
                     S.SCCTA,
                     S.SCOPER,
                     S.SCSBOP,
                     S.SCTOPE,
                     S.SCMOD,
                     S.Saldo,                
                     S.Fecpro,
                     S.Fecval,
                     S.Dias,
                     S.Codcam                     
                     );                                                             
           commit;                                  
         exception
         when others then
            rollback;
            p_c_coderr := '002-'||P_N_CODCAM;
            p_c_deserr := sqlerrm;  
         end;
      
         --verificamos si fecha de proceso es igual a fecha de corte 
         begin
          select to_date(trim(x.tp1desc),'dd/mm/rrrr')
            into ld_feccor
            from fst198 x
           where x.tp1cod   = 1
             and x.tp1cod1  = 10825
             and x.tp1corr1 = 80
             and x.tp1corr2 = 4
             and x.tp1nro1  = P_N_CODCAM
             and to_date(trim(x.tp1desc),'dd/mm/rrrr') = P_D_FECPRO;       
         exception 
         when others then
          ld_feccor := NULL;
         end;      
          
         if p_c_coderr = '000' then
           -- Calculamos las opciones de sorteo
           begin
                --- MERGE
                MERGE INTO JAQZ169 D
                USING (select b.JAQZ168CAM,
                              b.JAQZ168PGC,
                              b.JAQZ168SUC,
                              b.JAQZ168MDA,
                              b.JAQZ168PAP,
                              b.JAQZ168CTA,
                              b.JAQZ168OPE,
                              b.JAQZ168SBO,
                              b.JAQZ168TPO,
                              b.JAQZ168MOD,
                              b.JAQZ168SDO                              NewSal,
                              nvl(a.jaqz167sdo, 0)*(b.jaqz168ax1)       SalAnt,
                              case
                                when b.JAQZ168MOD = 21 and b.JAQZ168TPO in (1) and (P_D_FECINI <= b.JAQZ168AX5 and JAQZ168AX5 <= P_D_FECFIN) then
                                     2                            
                                else
                                     0
                              end Opciones,    
                              case
                                  when  trunc((b.JAQZ168SDO - nvl(a.jaqz167sdo*(b.jaqz168ax1), 0)) / (b.jaqz168ax1*ln_monopt)) < 0 then
                                         0
                                  when b.JAQZ168MOD = 22 then
                                         0
                                  Else                  
                                        trunc((b.JAQZ168SDO - nvl(a.jaqz167sdo*(b.jaqz168ax1), 0)) / (b.jaqz168ax1*ln_monopt))
                              End Promedio,                                                 
                              P_D_FECPRO   Fecpro,
                              b.jaqz168ax5 Fecval,
                              b.jaqz168ax1 Dias,
                              b.JAQZ168FEC
                         from jaqz167 a, jaqz168 b
                        where a.jaqz167pgc(+) = b.jaqz168pgc
                          and a.jaqz167suc(+) = b.jaqz168suc
                          and a.jaqz167mod(+) = b.jaqz168mod
                          and a.jaqz167mda(+) = b.jaqz168mda
                          and a.jaqz167pap(+) = b.jaqz168pap
                          and a.jaqz167cta(+) = b.jaqz168cta
                          and a.jaqz167ope(+) = b.jaqz168ope
                          and a.jaqz167sbo(+) = b.jaqz168sbo
                          and a.jaqz167tpo(+) = b.jaqz168tpo
                          and a.jaqz167cam(+) = b.jaqz168cam     
                          and b.jaqz168cam    = P_N_CODCAM                                                                                                
                      ) S
                
                ON (    D.JAQZ169PGC = S.JAQZ168PGC 
                    AND D.JAQZ169SUC = S.JAQZ168SUC 
                    AND D.JAQZ169MDA = S.JAQZ168MDA 
                    AND D.JAQZ169PAP = S.JAQZ168PAP 
                    AND D.JAQZ169CTA = S.JAQZ168CTA 
                    AND D.JAQZ169OPE = S.JAQZ168OPE 
                    AND D.JAQZ169SBO = S.JAQZ168SBO 
                    AND D.JAQZ169TPO = S.JAQZ168TPO 
                    AND D.JAQZ169MOD = S.JAQZ168MOD
                    AND D.JAQZ169CAM = S.JAQZ168CAM    
                    AND D.JAQZ169CAM = P_N_CODCAM                                                                                                           
                   )
                WHEN MATCHED THEN
                  UPDATE SET D.JAQZ169OPT = --S.Opciones + S.Promedio,
                                            Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  S.Opciones + S.Promedio
                                             else
                                                  0
                                             end,            
                             D.JAQZ169ANT = nvl(S.SalAnt,0),
                             D.JAQZ169NEW = nvl(S.NewSal,0),
                             D.JAQZ169SOR = Case
                                             when (ld_feccor = P_D_FECPRO) and (S.JAQZ168FEC  = P_D_FECPRO) then
                                                  S.Opciones + S.Promedio
                                             else
                                                  Case
                                                    when S.JAQZ168FEC  = P_D_FECPRO then
                                                         D.JAQZ169SOR
                                                    else
                                                         0
                                                    end
                                             end,                           
                             D.JAQZ169FEC = --S.Fecpro,
                                             Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  S.Fecpro
                                             else
                                                  D.JAQZ169FEC
                                             end,                           
                             D.JAQZ169AX5 = S.Fecval,
                             D.JAQZ169AX1 = S.Dias
                WHEN NOT MATCHED THEN
                  INSERT
                    (D.JAQZ169PGC,
                     D.JAQZ169SUC,
                     D.JAQZ169MDA,
                     D.JAQZ169PAP,
                     D.JAQZ169CTA,
                     D.JAQZ169OPE,
                     D.JAQZ169SBO,
                     D.JAQZ169TPO,
                     D.JAQZ169MOD,
                     D.JAQZ169OPT,
                     D.JAQZ169SOR,
                     D.JAQZ169ANT,
                     D.JAQZ169NEW,
                     D.JAQZ169FEC,
                     D.JAQZ169AX5,
                     D.JAQZ169AX1,
                     D.JAQZ169CAM
                     )
                  VALUES
                    (S.JAQZ168PGC,
                     S.JAQZ168SUC,
                     S.JAQZ168MDA,
                     S.JAQZ168PAP,
                     S.JAQZ168CTA,
                     S.JAQZ168OPE,
                     S.JAQZ168SBO,
                     S.JAQZ168TPO,
                     S.JAQZ168MOD,
                     S.Opciones + S.Promedio,
                     Case
                     when ld_feccor = P_D_FECPRO then
                          S.Opciones + S.Promedio
                     else
                          0
                     end,  
                     nvl(S.SalAnt,0),
                     nvl(S.NewSal,0),
                     S.Fecpro,
                     S.Fecval,
                     S.Dias,
                     S.JAQZ168CAM
                     );                    
           exception
           when others then
             rollback;   
             p_c_coderr := '003-'||P_N_CODCAM;
             p_c_deserr := sqlerrm;      
           end;  
         end if;    
      end if;         
  exception
  when others then
    p_c_coderr := '00E-1';    
    p_c_deserr := sqlerrm;    
  end sp_ah_ejecuta_camp1;
  Procedure sp_ah_ejecuta_camp2(P_N_CODCAM IN NUMBER,
                                P_D_FECPRO IN DATE, 
                                P_D_FECINI IN DATE, 
                                P_D_FECFIN IN DATE,                                 
                                p_c_coderr in out varchar2, 
                                p_c_deserr in out varchar2 
                               ) is
  ln_monopt  number(17,2):=0;     
  ld_feccor  date;   
  ln_tope    number(9):= 0;
  ln_tp1imp1 number(17,2):= 0;
  begin
     --obtenemos el valor del parámetro
      begin
        select x.tp1imp1,
               x.tp1imp2
          into ln_monopt,
               ln_tope 
          from fst198 x
         where x.tp1cod   = 1
           and x.tp1cod1  = 10825
           and x.tp1corr1 = 80
           and x.tp1corr2 = 6
           and x.tp1nro1  = P_N_CODCAM;
      exception
      when no_data_found then
        p_c_coderr := '001-'||P_N_CODCAM;
        p_c_deserr := 'No se encontró monto parametrizado para calular opciones';
      when others then
        p_c_coderr := '001-'||P_N_CODCAM;
        p_c_deserr := sqlerrm;       
      end;
      
      if p_c_coderr = '000' then         
         begin  
                  MERGE INTO JAQZ168 D
                  USING (                  
                                select P_N_CODCAM CODCAM,
                                       qq.PGCOD,
                                       qq.SCSUC,
                                       qq.SCMDA,
                                       qq.SCPAP,
                                       qq.SCCTA,
                                       qq.SCOPER,
                                       qq.SCSBOP,
                                       qq.SCTOPE,
                                       qq.SCMOD,
                                       sum(qq.SCSDO)  Saldo,
                                       P_D_FECPRO     Fecpro,
                                       max(qq.scfval) Fecval,
                                       case
                                            when  max(qq.scfval) > P_D_FECINI then
                                              (P_D_FECPRO - max(qq.scfval) + 1)
                                            Else
                                              (P_D_FECPRO - P_D_FECINI + 1)
                                       End Dias                                     
                                  from fsd011 qq,
                                       (Select z.pgcod,z.ctnro 
                                          from fsr008 z
                                         where z.pgcod = 1
                                           and z.ttcod = 1
                                           and z.cttfir = 'T'                                                                       
                                        minus 
                                        (     select distinct 
                                                     x.pgcod, 
                                                     x.ctnro
                                                from fsr008 x, 
                                                     fsd001 y
                                               where x.pgcod = 1
                                                 and x.pepais = y.pepais
                                                 and x.petdoc = y.petdoc
                                                 and x.pendoc = y.pendoc
                                                 and y.petipo = 'J' --44103
                                              union
                                              select distinct 
                                                     a.pgcod, 
                                                     a.ctnro
                                                from fsr008 a, 
                                                     fsd002 b
                                               where a.pgcod = 1
                                                 and a.pepais = b.pfpais
                                                 and a.petdoc = b.pftdoc
                                                 and a.pendoc = b.pfndoc
                                                 and b.pfebco = 'S'
                                                 and a.ttcod  = 1
                                                 and a.cttfir = 'T'
                                              union
                                             select distinct 
                                                    a.pgcod,
                                                    a.ctnro 
                                               from fsr008 a,
                                                    fsd002 b,
                                                    fsr002 c
                                              where a.pgcod = 1
                                                and a.pepais = c.rppais
                                                and a.petdoc = c.rptdoc
                                                and a.pendoc = c.rpndoc                
                                                and c.pepais = b.pfpais
                                                and c.petdoc = b.pftdoc
                                                and c.pendoc = b.pfndoc
                                                and b.pfebco = 'S'
                                                and a.ttcod  = 1
                                                and a.cttfir = 'T'
                                                and c.rpccyg in (69,71,66,63,70,68,67,75,89) --familiares de trabajadores
                                              union
                                             select distinct 
                                                    a.pgcod,
                                                    a.ctnro 
                                               from fsr008 a,
                                                    fsd002 b,
                                                    fsr002 c
                                              where a.pgcod = 1
                                                and a.pepais = c.pepais
                                                and a.petdoc = c.petdoc
                                                and a.pendoc = c.pendoc
                                                and c.rppais = b.pfpais
                                                and c.rptdoc = b.pftdoc
                                                and c.rpndoc = b.pfndoc
                                                and b.pfebco = 'S'
                                                and a.ttcod  = 1
                                                and a.cttfir = 'T'
                                                and c.rpccyg in (69,71,66,63,70,68,67,75,89)  --familiares de trabajadores                                                                 
                                               )
                                       ) ww
                                 where qq.pgcod  = ww.pgcod
                                   and qq.sccta  = ww.ctnro
                                   and qq.pgcod  = 1
                                   and qq.scmod  = 21
                                   and qq.sctope = 1
                                   and qq.scmda  = 0
                                   and qq.scpap  = 0
                                   and qq.scoper = 0
                                   and qq.scstat <> 99
                                 group by qq.PGCOD,
                                          qq.SCSUC,
                                          qq.SCMDA,
                                          qq.SCPAP,
                                          qq.SCCTA,
                                          qq.SCOPER,
                                          qq.SCSBOP,
                                          qq.SCTOPE,
                                          qq.SCMOD                                        
                        ) S            
                 ON (   D.JAQZ168PGC(+) = S.PGCOD
                    AND D.JAQZ168SUC(+) = S.SCSUC
                    AND D.JAQZ168MDA(+) = S.SCMDA
                    AND D.JAQZ168PAP(+) = S.SCPAP
                    AND D.JAQZ168CTA(+) = S.SCCTA
                    AND D.JAQZ168OPE(+) = S.SCOPER
                    AND D.JAQZ168SBO(+) = S.SCSBOP
                    AND D.JAQZ168TPO(+) = S.SCTOPE
                    AND D.JAQZ168MOD(+) = S.SCMOD 
                    AND D.JAQZ168CAM(+) = S.CODCAM    
                    AND D.JAQZ168CAM    = P_N_CODCAM                                                                                                       
                    )
                WHEN MATCHED THEN
                  UPDATE SET D.JAQZ168SDO = case
                                            when D.JAQZ168MOD = 21 then
                                              D.JAQZ168SDO + S.Saldo
                                            Else
                                              D.JAQZ168SDO
                                            End,  
                             D.JAQZ168FEC = S.Fecpro,
                             D.JAQZ168AX1 = case
                                            when D.JAQZ168AX5 > P_D_FECINI then
                                              (P_D_FECPRO - D.JAQZ168AX5 + 1)
                                            Else
                                              (P_D_FECPRO - P_D_FECINI + 1)
                                            End  
                WHEN NOT MATCHED THEN                
                  INSERT
                    (D.JAQZ168PGC,
                     D.JAQZ168SUC,
                     D.JAQZ168MDA,
                     D.JAQZ168PAP,
                     D.JAQZ168CTA,
                     D.JAQZ168OPE,
                     D.JAQZ168SBO,
                     D.JAQZ168TPO,
                     D.JAQZ168MOD,
                     D.JAQZ168SDO,
                     D.JAQZ168FEC,
                     D.JAQZ168AX5,
                     D.JAQZ168AX1,
                     D.JAQZ168CAM
                     )
                  VALUES
                    (S.PGCOD,
                     S.SCSUC,
                     S.SCMDA,
                     S.SCPAP,
                     S.SCCTA,
                     S.SCOPER,
                     S.SCSBOP,
                     S.SCTOPE,
                     S.SCMOD,
                     S.Saldo,                
                     S.Fecpro,
                     S.Fecval,
                     S.Dias,
                     S.Codcam                     
                     );                                                             
           commit;                                  
         exception
         when others then
            rollback;
            p_c_coderr := '002-'||P_N_CODCAM;
            p_c_deserr := sqlerrm;  
         end;
      
         --verificamos si fecha de proceso es igual a fecha de corte 
         begin
          select to_date(trim(x.tp1desc),'dd/mm/rrrr'),
                 x.tp1imp1
            into ld_feccor,
                 ln_tp1imp1
            from fst198 x
           where x.tp1cod   = 1
             and x.tp1cod1  = 10825
             and x.tp1corr1 = 80
             and x.tp1corr2 = 4
             and x.tp1nro1  = P_N_CODCAM
             and to_date(trim(x.tp1desc),'dd/mm/rrrr') = P_D_FECPRO;       
         exception 
         when others then
          ld_feccor := NULL;
          ln_tp1imp1 := 1;
         end;      
          
         if p_c_coderr = '000' then
           -- Calculamos las opciones de sorteo
           begin
                --- MERGE
                MERGE INTO JAQZ169 D
                USING (select b.JAQZ168CAM,
                              b.JAQZ168PGC,
                              b.JAQZ168SUC,
                              b.JAQZ168MDA,
                              b.JAQZ168PAP,
                              b.JAQZ168CTA,
                              b.JAQZ168OPE,
                              b.JAQZ168SBO,
                              b.JAQZ168TPO,
                              b.JAQZ168MOD,
                              b.JAQZ168SDO                              NewSal,
                              nvl(a.jaqz167sdo, 0)*(b.jaqz168ax1)       SalAnt,
                              case
                                when b.JAQZ168MOD = 21 and b.JAQZ168TPO in (1) and (P_D_FECINI <= b.JAQZ168AX5 and JAQZ168AX5 <= P_D_FECFIN) then
                                     0                            
                                else
                                     0
                              end Opciones, --opciones por apertura   
                              case
                                  when  trunc((b.JAQZ168SDO - nvl(a.jaqz167sdo*(b.jaqz168ax1), 0)) / (b.jaqz168ax1*ln_monopt)) < 0 then
                                         0
                                  when b.JAQZ168MOD = 22 then
                                         0
                                  Else                  
                                        trunc((b.JAQZ168SDO - nvl(a.jaqz167sdo*(b.jaqz168ax1), 0)) / (b.jaqz168ax1*ln_monopt))
                              End Promedio,  --opciones por saldo promedio                                               
                              P_D_FECPRO   Fecpro,
                              b.jaqz168ax5 Fecval,
                              b.jaqz168ax1 Dias,
                              b.JAQZ168FEC
                         from jaqz167 a, jaqz168 b
                        where a.jaqz167pgc = b.jaqz168pgc
                          and a.jaqz167suc = b.jaqz168suc
                          and a.jaqz167mod = b.jaqz168mod
                          and a.jaqz167mda = b.jaqz168mda
                          and a.jaqz167pap = b.jaqz168pap
                          and a.jaqz167cta = b.jaqz168cta
                          and a.jaqz167ope = b.jaqz168ope
                          and a.jaqz167sbo = b.jaqz168sbo
                          and a.jaqz167tpo = b.jaqz168tpo
                          and a.jaqz167cam = b.jaqz168cam
                          and b.jaqz168cam = P_N_CODCAM
                          and (b.jaqz168ax5 < P_D_FECINI 
                               or 
                               b.jaqz168ax5 > P_D_FECFIN
                              )
                      ) S
                
                ON (    D.JAQZ169PGC = S.JAQZ168PGC 
                    AND D.JAQZ169SUC = S.JAQZ168SUC 
                    AND D.JAQZ169MDA = S.JAQZ168MDA 
                    AND D.JAQZ169PAP = S.JAQZ168PAP 
                    AND D.JAQZ169CTA = S.JAQZ168CTA 
                    AND D.JAQZ169OPE = S.JAQZ168OPE 
                    AND D.JAQZ169SBO = S.JAQZ168SBO 
                    AND D.JAQZ169TPO = S.JAQZ168TPO 
                    AND D.JAQZ169MOD = S.JAQZ168MOD
                    AND D.JAQZ169CAM = S.JAQZ168CAM
                    AND D.JAQZ169CAM = P_N_CODCAM
                   )
                WHEN MATCHED THEN
                  UPDATE SET D.JAQZ169OPT = --S.Opciones + S.Promedio,
                                            Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  case
                                                    when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                                      ln_tope*ln_tp1imp1
                                                    else  
                                                      S.Opciones + S.Promedio
                                                    end                                                    
                                             else
                                                  0
                                             end,            
                             D.JAQZ169ANT = nvl(S.SalAnt,0),
                             D.JAQZ169NEW = nvl(S.NewSal,0),
                             D.JAQZ169SOR = Case
                                             when (ld_feccor = P_D_FECPRO) and (S.JAQZ168FEC  = P_D_FECPRO) then
                                                  --D.JAQZ169SOR + S.Opciones + S.Promedio
                                                  case
                                                    when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                                      ln_tope*ln_tp1imp1
                                                    else  
                                                      S.Opciones + S.Promedio
                                                    end                                                   
                                             else
                                                  Case
                                                    when S.JAQZ168FEC  = P_D_FECPRO then
                                                         D.JAQZ169SOR
                                                    else
                                                         0
                                                    end
                                             end,                           
                             D.JAQZ169FEC = --S.Fecpro,
                                             Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  S.Fecpro
                                             else
                                                  D.JAQZ169FEC
                                             end,                           
                             D.JAQZ169AX5 = S.Fecval,
                             D.JAQZ169AX1 = S.Dias
                WHEN NOT MATCHED THEN
                  INSERT
                    (D.JAQZ169PGC,
                     D.JAQZ169SUC,
                     D.JAQZ169MDA,
                     D.JAQZ169PAP,
                     D.JAQZ169CTA,
                     D.JAQZ169OPE,
                     D.JAQZ169SBO,
                     D.JAQZ169TPO,
                     D.JAQZ169MOD,
                     D.JAQZ169OPT,
                     D.JAQZ169SOR,
                     D.JAQZ169ANT,
                     D.JAQZ169NEW,
                     D.JAQZ169FEC,
                     D.JAQZ169AX5,
                     D.JAQZ169AX1,
                     D.JAQZ169CAM
                     )
                  VALUES
                    (S.JAQZ168PGC,
                     S.JAQZ168SUC,
                     S.JAQZ168MDA,
                     S.JAQZ168PAP,
                     S.JAQZ168CTA,
                     S.JAQZ168OPE,
                     S.JAQZ168SBO,
                     S.JAQZ168TPO,
                     S.JAQZ168MOD,
                     Case
                       when S.JAQZ168FEC  = P_D_FECPRO then
                            case
                              when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                ln_tope*ln_tp1imp1
                              else  
                                S.Opciones + S.Promedio
                              end                                                    
                       else
                            0
                     end,                         
                     Case
                       when (ld_feccor = P_D_FECPRO) and (S.JAQZ168FEC  = P_D_FECPRO) then
                            --S.Opciones + S.Promedio
                              case
                              when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                ln_tope*ln_tp1imp1
                              else  
                                S.Opciones + S.Promedio
                              end                            
                       else
                              0   
                     end,                                  
                     nvl(S.SalAnt,0),
                     nvl(S.NewSal,0),
                     S.Fecpro,
                     S.Fecval,
                     S.Dias,
                     S.JAQZ168CAM
                     );                     
           exception
           when others then
             rollback;   
             p_c_coderr := '003-'||P_N_CODCAM;
             p_c_deserr := sqlerrm;      
           end;  
           
           begin
                --- MERGE
                MERGE INTO JAQZ169 D
                USING (select b.JAQZ168CAM,
                              b.JAQZ168PGC,
                              b.JAQZ168SUC,
                              b.JAQZ168MDA,
                              b.JAQZ168PAP,
                              b.JAQZ168CTA,
                              b.JAQZ168OPE,
                              b.JAQZ168SBO,
                              b.JAQZ168TPO,
                              b.JAQZ168MOD,
                              b.JAQZ168SDO                              NewSal,
                              nvl(a.jaqz167sdo, 0)*(b.jaqz168ax1)       SalAnt,
                              case
                                when b.JAQZ168MOD = 21 and b.JAQZ168TPO in (1) and (P_D_FECINI <= b.JAQZ168AX5 and JAQZ168AX5 <= P_D_FECFIN) then
                                     0                            
                                else
                                     0
                              end Opciones, --opciones por apertura   
                              case
                                  when  trunc((b.JAQZ168SDO - nvl(a.jaqz167sdo*(b.jaqz168ax1), 0)) / (b.jaqz168ax1*ln_monopt)) < 0 then
                                         0
                                  when b.JAQZ168MOD = 22 then
                                         0
                                  Else                  
                                        trunc((b.JAQZ168SDO - nvl(a.jaqz167sdo*(b.jaqz168ax1), 0)) / (b.jaqz168ax1*ln_monopt))
                              End Promedio,  --opciones por saldo promedio                                               
                              P_D_FECPRO   Fecpro,
                              b.jaqz168ax5 Fecval,
                              b.jaqz168ax1 Dias,
                              b.JAQZ168FEC
                         from jaqz167 a, jaqz168 b
                        where a.jaqz167pgc(+) = b.jaqz168pgc
                          and a.jaqz167suc(+) = b.jaqz168suc
                          and a.jaqz167mod(+) = b.jaqz168mod
                          and a.jaqz167mda(+) = b.jaqz168mda
                          and a.jaqz167pap(+) = b.jaqz168pap
                          and a.jaqz167cta(+) = b.jaqz168cta
                          and a.jaqz167ope(+) = b.jaqz168ope
                          and a.jaqz167sbo(+) = b.jaqz168sbo
                          and a.jaqz167tpo(+) = b.jaqz168tpo
                          and a.jaqz167cam(+) = b.jaqz168cam
                          and b.jaqz168cam    = P_N_CODCAM
                          and b.jaqz168ax5 between P_D_FECINI and P_D_FECFIN
                      ) S
                
                ON (    D.JAQZ169PGC = S.JAQZ168PGC 
                    AND D.JAQZ169SUC = S.JAQZ168SUC 
                    AND D.JAQZ169MDA = S.JAQZ168MDA 
                    AND D.JAQZ169PAP = S.JAQZ168PAP 
                    AND D.JAQZ169CTA = S.JAQZ168CTA 
                    AND D.JAQZ169OPE = S.JAQZ168OPE 
                    AND D.JAQZ169SBO = S.JAQZ168SBO 
                    AND D.JAQZ169TPO = S.JAQZ168TPO 
                    AND D.JAQZ169MOD = S.JAQZ168MOD
                    AND D.JAQZ169CAM = S.JAQZ168CAM
                    AND D.JAQZ169CAM = P_N_CODCAM
                   )
                WHEN MATCHED THEN
                  UPDATE SET D.JAQZ169OPT = --S.Opciones + S.Promedio,
                                            Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  case
                                                    when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                                      ln_tope*ln_tp1imp1
                                                    else  
                                                      S.Opciones + S.Promedio
                                                    end                                                    
                                             else
                                                  0
                                             end,            
                             D.JAQZ169ANT = nvl(S.SalAnt,0),
                             D.JAQZ169NEW = nvl(S.NewSal,0),
                             D.JAQZ169SOR = Case
                                             when (ld_feccor = P_D_FECPRO) and (S.JAQZ168FEC  = P_D_FECPRO) then
                                                  --D.JAQZ169SOR + S.Opciones + S.Promedio
                                                  case
                                                    when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                                      ln_tope*ln_tp1imp1
                                                    else  
                                                      S.Opciones + S.Promedio
                                                    end                                                     
                                             else
                                                  Case
                                                    when S.JAQZ168FEC  = P_D_FECPRO then
                                                         D.JAQZ169SOR
                                                    else
                                                         0
                                                    end
                                             end,                           
                             D.JAQZ169FEC = --S.Fecpro,
                                             Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  S.Fecpro
                                             else
                                                  D.JAQZ169FEC
                                             end,                           
                             D.JAQZ169AX5 = S.Fecval,
                             D.JAQZ169AX1 = S.Dias
                WHEN NOT MATCHED THEN
                  INSERT
                    (D.JAQZ169PGC,
                     D.JAQZ169SUC,
                     D.JAQZ169MDA,
                     D.JAQZ169PAP,
                     D.JAQZ169CTA,
                     D.JAQZ169OPE,
                     D.JAQZ169SBO,
                     D.JAQZ169TPO,
                     D.JAQZ169MOD,
                     D.JAQZ169OPT,
                     D.JAQZ169SOR,
                     D.JAQZ169ANT,
                     D.JAQZ169NEW,
                     D.JAQZ169FEC,
                     D.JAQZ169AX5,
                     D.JAQZ169AX1,
                     D.JAQZ169CAM
                     )
                  VALUES
                    (S.JAQZ168PGC,
                     S.JAQZ168SUC,
                     S.JAQZ168MDA,
                     S.JAQZ168PAP,
                     S.JAQZ168CTA,
                     S.JAQZ168OPE,
                     S.JAQZ168SBO,
                     S.JAQZ168TPO,
                     S.JAQZ168MOD,
                     Case
                       when S.JAQZ168FEC  = P_D_FECPRO then
                            case
                              when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                ln_tope*ln_tp1imp1
                              else  
                                S.Opciones + S.Promedio
                              end                                                    
                       else
                            0
                     end,                         
                     Case
                       when (ld_feccor = P_D_FECPRO) and (S.JAQZ168FEC  = P_D_FECPRO) then
                            --S.Opciones + S.Promedio
                              case
                              when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                ln_tope*ln_tp1imp1
                              else  
                                S.Opciones + S.Promedio
                              end                             
                       else                              
                              0                          
                     end,                                  
                     nvl(S.SalAnt,0),
                     nvl(S.NewSal,0),
                     S.Fecpro,
                     S.Fecval,
                     S.Dias,
                     S.JAQZ168CAM
                     );                     
           exception
           when others then
             rollback;   
             p_c_coderr := '003A-'||P_N_CODCAM;
             p_c_deserr := sqlerrm;      
           end;                                             
         end if;    
      end if;         
  exception
  when others then
    p_c_coderr := '00E-2';    
    p_c_deserr := sqlerrm;    
  end sp_ah_ejecuta_camp2;                                       
    
  Procedure sp_ah_ejecuta_camp3(P_N_CODCAM IN NUMBER,
                                P_D_FECPRO IN DATE, 
                                P_D_FECINI IN DATE, 
                                P_D_FECFIN IN DATE,                                 
                                p_c_coderr in out varchar2, 
                                p_c_deserr in out varchar2 
                               ) is
  ln_monopt  number(17,2):=0;     
  ld_feccor  date;   
  ld_fecini  date;   
  ln_tope    number(9):= 0;
  ln_tp1imp1 number(17,2):= 0;
  begin
     --obtenemos el valor del parámetro
      begin
        select x.tp1imp1,
               x.tp1imp2
          into ln_monopt,
               ln_tope 
          from fst198 x
         where x.tp1cod   = 1
           and x.tp1cod1  = 10825
           and x.tp1corr1 = 80
           and x.tp1corr2 = 6
           and x.tp1nro1  = P_N_CODCAM;
      exception
      when no_data_found then
        p_c_coderr := '001-'||P_N_CODCAM;
        p_c_deserr := 'No se encontró monto parametrizado para calular opciones';
      when others then
        p_c_coderr := '001-'||P_N_CODCAM;
        p_c_deserr := sqlerrm;       
      end;
      
      if p_c_coderr = '000' then         
         begin  
                  MERGE INTO JAQZ168 D
                  USING (                  
                                select P_N_CODCAM CODCAM,
                                       qq.PGCOD,
                                       qq.SCSUC,
                                       qq.SCMDA,
                                       qq.SCPAP,
                                       qq.SCCTA,
                                       qq.SCOPER,
                                       qq.SCSBOP,
                                       qq.SCTOPE,
                                       qq.SCMOD,
                                       sum(qq.SCSDO)  Saldo,
                                       P_D_FECPRO     Fecpro,
                                       max(qq.scfval) Fecval,
                                       case
                                            when  max(qq.scfval) > P_D_FECINI then
                                              (P_D_FECPRO - max(qq.scfval) + 1)
                                            Else
                                              (P_D_FECPRO - P_D_FECINI + 1)
                                       End Dias                                     
                                  from fsd011
                                       qq,
                                       (Select z.pgcod,z.ctnro 
                                          from fsr008 z
                                         where z.pgcod = 1
                                           and z.ttcod = 1
                                           and z.cttfir = 'T'                                                                       
                                        minus 
                                        (     select distinct 
                                                     x.pgcod, 
                                                     x.ctnro
                                                from fsr008 x, 
                                                     fsd001 y
                                               where x.pgcod = 1
                                                 and x.pepais = y.pepais
                                                 and x.petdoc = y.petdoc
                                                 and x.pendoc = y.pendoc
                                                 and y.petipo = 'J' --44103
                                              union
                                              select distinct 
                                                     a.pgcod, 
                                                     a.ctnro
                                                from fsr008 a, 
                                                     fsd002 b
                                               where a.pgcod = 1
                                                 and a.pepais = b.pfpais
                                                 and a.petdoc = b.pftdoc
                                                 and a.pendoc = b.pfndoc
                                                 and b.pfebco = 'S'
                                                 and a.ttcod  = 1
                                                 and a.cttfir = 'T'
                                              union
                                             select distinct 
                                                    a.pgcod,
                                                    a.ctnro 
                                               from fsr008 a,
                                                    fsd002 b,
                                                    fsr002 c
                                              where a.pgcod = 1
                                                and a.pepais = c.rppais
                                                and a.petdoc = c.rptdoc
                                                and a.pendoc = c.rpndoc                
                                                and c.pepais = b.pfpais
                                                and c.petdoc = b.pftdoc
                                                and c.pendoc = b.pfndoc
                                                and b.pfebco = 'S'
                                                and a.ttcod  = 1
                                                and a.cttfir = 'T'
                                                and c.rpccyg in (69,71,66,63,70,68,67,75,89) --familiares de trabajadores
                                              union
                                             select distinct 
                                                    a.pgcod,
                                                    a.ctnro 
                                               from fsr008 a,
                                                    fsd002 b,
                                                    fsr002 c
                                              where a.pgcod = 1
                                                and a.pepais = c.pepais
                                                and a.petdoc = c.petdoc
                                                and a.pendoc = c.pendoc
                                                and c.rppais = b.pfpais
                                                and c.rptdoc = b.pftdoc
                                                and c.rpndoc = b.pfndoc
                                                and b.pfebco = 'S'
                                                and a.ttcod  = 1
                                                and a.cttfir = 'T'
                                                and c.rpccyg in (69,71,66,63,70,68,67,75,89)  --familiares de trabajadores                                                                 
                                               )
                                       ) ww
                                 where qq.pgcod  = ww.pgcod
                                   and qq.sccta  = ww.ctnro
                                   and qq.pgcod  = 1
                                   and qq.scmod  = 21
                                   and qq.sctope in (1,6,8,9)
                                   and qq.scmda  = 0
                                   and qq.scpap  = 0
                                   and qq.scoper = 0
                                   and qq.scstat <> 99
                                 group by qq.PGCOD,
                                          qq.SCSUC,
                                          qq.SCMDA,
                                          qq.SCPAP,
                                          qq.SCCTA,
                                          qq.SCOPER,
                                          qq.SCSBOP,
                                          qq.SCTOPE,
                                          qq.SCMOD                                        
                        ) S            
                 ON (   D.JAQZ168PGC(+) = S.PGCOD
                    AND D.JAQZ168SUC(+) = S.SCSUC
                    AND D.JAQZ168MDA(+) = S.SCMDA
                    AND D.JAQZ168PAP(+) = S.SCPAP
                    AND D.JAQZ168CTA(+) = S.SCCTA
                    AND D.JAQZ168OPE(+) = S.SCOPER
                    AND D.JAQZ168SBO(+) = S.SCSBOP
                    AND D.JAQZ168TPO(+) = S.SCTOPE
                    AND D.JAQZ168MOD(+) = S.SCMOD 
                    AND D.JAQZ168CAM(+) = S.CODCAM    
                    AND D.JAQZ168CAM    = P_N_CODCAM                                                                                                       
                    )
                WHEN MATCHED THEN
                  UPDATE SET D.JAQZ168SDO = case
                                            when D.JAQZ168MOD = 21 then
                                              D.JAQZ168SDO + S.Saldo
                                            Else
                                              D.JAQZ168SDO
                                            End,  
                             D.JAQZ168FEC = S.Fecpro,
                             D.JAQZ168AX1 = case
                                            when D.JAQZ168AX5 > P_D_FECINI then
                                              (P_D_FECPRO - D.JAQZ168AX5 + 1)
                                            Else
                                              (P_D_FECPRO - P_D_FECINI + 1)
                                            End  
                WHEN NOT MATCHED THEN                
                  INSERT
                    (D.JAQZ168PGC,
                     D.JAQZ168SUC,
                     D.JAQZ168MDA,
                     D.JAQZ168PAP,
                     D.JAQZ168CTA,
                     D.JAQZ168OPE,
                     D.JAQZ168SBO,
                     D.JAQZ168TPO,
                     D.JAQZ168MOD,
                     D.JAQZ168SDO,
                     D.JAQZ168FEC,
                     D.JAQZ168AX5,
                     D.JAQZ168AX1,
                     D.JAQZ168CAM
                     )
                  VALUES
                    (S.PGCOD,
                     S.SCSUC,
                     S.SCMDA,
                     S.SCPAP,
                     S.SCCTA,
                     S.SCOPER,
                     S.SCSBOP,
                     S.SCTOPE,
                     S.SCMOD,
                     S.Saldo,                
                     S.Fecpro,
                     S.Fecval,
                     S.Dias,
                     S.Codcam                     
                     );                                                             
           commit;                                  
         exception
         when others then
            rollback;
            p_c_coderr := '002-'||P_N_CODCAM;
            p_c_deserr := sqlerrm;  
         end;
      
         --verificamos si fecha de proceso es igual a fecha de corte 
         begin
          select min(to_date(trim(x.tp1desc),'dd/mm/rrrr'))                
            into ld_feccor
            from fst198 x
           where x.tp1cod   = 1
             and x.tp1cod1  = 10825
             and x.tp1corr1 = 80
             and x.tp1corr2 = 4
             and x.tp1nro1  = P_N_CODCAM
             and to_date(trim(x.tp1desc),'dd/mm/rrrr') >= P_D_FECPRO;       
         exception 
         when others then
          ld_feccor := NULL;
          ln_tp1imp1 := 1;
         end;    
         
         begin
          select x.tp1imp1
            into ln_tp1imp1
            from fst198 x
           where x.tp1cod   = 1
             and x.tp1cod1  = 10825
             and x.tp1corr1 = 80
             and x.tp1corr2 = 4
             and x.tp1nro1  = P_N_CODCAM
             and to_date(trim(x.tp1desc),'dd/mm/rrrr') = ld_feccor;       
         exception 
         when others then
          ld_feccor := NULL;
          ln_tp1imp1 := 1;
         end;  
         
         if ld_feccor <= to_date('30/09/2019','dd/mm/rrrr')then
           ld_fecini := to_date('01/08/2019','dd/mm/rrrr');
         else
           ld_fecini := to_date('01/10/2019','dd/mm/rrrr');
         end if;                      
          
         if p_c_coderr = '000' then
           -- Calculamos las opciones de sorteo
           --aperturas y promedio          
           begin
                --- MERGE
                MERGE INTO JAQZ169 D
                USING (select b.JAQZ168CAM,
                              b.JAQZ168PGC,
                              b.JAQZ168SUC,
                              b.JAQZ168MDA,
                              b.JAQZ168PAP,
                              b.JAQZ168CTA,
                              b.JAQZ168OPE,
                              b.JAQZ168SBO,
                              b.JAQZ168TPO,
                              b.JAQZ168MOD,
                              b.JAQZ168SDO                              NewSal,
                              nvl(a.jaqz167sdo, 0)*(b.jaqz168ax1)       SalAnt,
                              case
                                when b.JAQZ168MOD = 21 and b.JAQZ168TPO in (6) and (P_D_FECINI <= b.JAQZ168AX5 and JAQZ168AX5 <= P_D_FECFIN) then                                  
                                     2                            
                                when b.JAQZ168MOD = 21 and b.JAQZ168TPO in (1,8,9) and (P_D_FECINI <= b.JAQZ168AX5 and JAQZ168AX5 <= P_D_FECFIN) then
                                     1                                      
                                else
                                     0
                              end Opciones, --opciones por apertura   
                              case
                                  when  trunc((b.JAQZ168SDO - nvl(nvl(a.jaqz167sdo,0)*(b.jaqz168ax1), 0)) / (b.jaqz168ax1*ln_monopt)) < 0 then
                                         0
                                  when b.JAQZ168MOD = 22 then
                                         0
                                  Else                  
                                        trunc((b.JAQZ168SDO - nvl(nvl(a.jaqz167sdo,0)*(b.jaqz168ax1), 0)) / (b.jaqz168ax1*ln_monopt))
                              End Promedio,  --opciones por saldo promedio                                               
                              P_D_FECPRO   Fecpro,
                              b.jaqz168ax5 Fecval,
                              b.jaqz168ax1 Dias,
                              b.JAQZ168FEC
                         from jaqz167 a, jaqz168 b
                        where a.jaqz167pgc(+) = b.jaqz168pgc
                          and a.jaqz167suc(+) = b.jaqz168suc
                          and a.jaqz167mod(+) = b.jaqz168mod
                          and a.jaqz167mda(+) = b.jaqz168mda
                          and a.jaqz167pap(+) = b.jaqz168pap
                          and a.jaqz167cta(+) = b.jaqz168cta
                          and a.jaqz167ope(+) = b.jaqz168ope
                          and a.jaqz167sbo(+) = b.jaqz168sbo
                          and a.jaqz167tpo(+) = b.jaqz168tpo
                          and a.jaqz167cam(+) = b.jaqz168cam
                          and b.jaqz168cam    = P_N_CODCAM
                      ) S
                
                ON (    D.JAQZ169PGC = S.JAQZ168PGC 
                    AND D.JAQZ169SUC = S.JAQZ168SUC 
                    AND D.JAQZ169MDA = S.JAQZ168MDA 
                    AND D.JAQZ169PAP = S.JAQZ168PAP 
                    AND D.JAQZ169CTA = S.JAQZ168CTA 
                    AND D.JAQZ169OPE = S.JAQZ168OPE 
                    AND D.JAQZ169SBO = S.JAQZ168SBO 
                    AND D.JAQZ169TPO = S.JAQZ168TPO 
                    AND D.JAQZ169MOD = S.JAQZ168MOD
                    AND D.JAQZ169CAM = S.JAQZ168CAM
                    AND D.JAQZ169CAM = P_N_CODCAM
                   )
                WHEN MATCHED THEN
                  UPDATE SET D.JAQZ169OPT = --S.Opciones + S.Promedio,
                                            Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  case
                                                    when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                                      ln_tope*ln_tp1imp1
                                                    else  
                                                      S.Opciones + S.Promedio
                                                    end                                                    
                                             else
                                                  0
                                             end,            
                             D.JAQZ169ANT = nvl(S.SalAnt,0),
                             D.JAQZ169NEW = nvl(S.NewSal,0),
                             D.JAQZ169SOR = Case
                                             when (ld_feccor = P_D_FECPRO) and (S.JAQZ168FEC  = P_D_FECPRO) then
                                                  --D.JAQZ169SOR + S.Opciones + S.Promedio
                                                  case
                                                    when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                                      ln_tope*ln_tp1imp1
                                                    else  
                                                      S.Opciones + S.Promedio
                                                    end                                                     
                                             else
                                                  Case
                                                    when S.JAQZ168FEC  = P_D_FECPRO then
                                                         D.JAQZ169SOR
                                                    else
                                                         0
                                                    end
                                             end,                           
                             D.JAQZ169FEC = --S.Fecpro,
                                             Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  S.Fecpro
                                             else
                                                  D.JAQZ169FEC
                                             end,                           
                             D.JAQZ169AX5 = S.Fecval,
                             D.JAQZ169AX1 = S.Dias
                WHEN NOT MATCHED THEN
                  INSERT
                    (D.JAQZ169PGC,
                     D.JAQZ169SUC,
                     D.JAQZ169MDA,
                     D.JAQZ169PAP,
                     D.JAQZ169CTA,
                     D.JAQZ169OPE,
                     D.JAQZ169SBO,
                     D.JAQZ169TPO,
                     D.JAQZ169MOD,
                     D.JAQZ169OPT,
                     D.JAQZ169SOR,
                     D.JAQZ169ANT,
                     D.JAQZ169NEW,
                     D.JAQZ169FEC,
                     D.JAQZ169AX5,
                     D.JAQZ169AX1,
                     D.JAQZ169CAM
                     )
                  VALUES
                    (S.JAQZ168PGC,
                     S.JAQZ168SUC,
                     S.JAQZ168MDA,
                     S.JAQZ168PAP,
                     S.JAQZ168CTA,
                     S.JAQZ168OPE,
                     S.JAQZ168SBO,
                     S.JAQZ168TPO,
                     S.JAQZ168MOD,
                     Case
                       when S.JAQZ168FEC  = P_D_FECPRO then
                            case
                              when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                ln_tope*ln_tp1imp1
                              else  
                                S.Opciones + S.Promedio
                              end                                                    
                       else
                            0
                     end,                         
                     Case
                       when (ld_feccor = P_D_FECPRO) and (S.JAQZ168FEC  = P_D_FECPRO) then
                            --S.Opciones + S.Promedio
                              case
                              when S.Opciones + S.Promedio > ln_tope*ln_tp1imp1 then
                                ln_tope*ln_tp1imp1
                              else  
                                S.Opciones + S.Promedio
                              end                             
                       else                              
                              0                          
                     end,                                  
                     nvl(S.SalAnt,0),
                     nvl(S.NewSal,0),
                     S.Fecpro,
                     S.Fecval,
                     S.Dias,
                     S.JAQZ168CAM
                     );        
                     commit;             
           exception
           when others then
             rollback;   
             p_c_coderr := '003A-'||P_N_CODCAM;
             p_c_deserr := sqlerrm;      
           end;  
             
           --creamos tabla temporal para las compras.                      
/*           begin             
             insert into crdtcap (d_fecha,n_monto1,n_monto2,n_monto3)              
                                   SELECT A.JAQL540FEINI,
                                          A.JAQL540MODUL,
                                          A.JAQL540TRANS,
                                          A.JAQL540RELAC               
                                     FROM JAQL540 A, JAQL539 B
                                    WHERE A.JAQL540FEINI between ld_fecini AND ld_feccor
                                      AND SUBSTR(A.JAQL540COTRX, 1, 2) = '00'
                                      AND A.JAQL540CORES = '00'
                                      AND A.JAQL540COTRA = B.JAQL539COTRA
                                      AND B.JAQL539NUCAM = 4
                                      AND TO_NUMBER(B.JAQL539VALTR) / 100 > 80
                                      AND (SELECT TO_NUMBER(JAQL539VALTR)
                                             FROM JAQL539
                                            WHERE JAQL539COTRA = A.JAQL540COTRA
                                              AND JAQL539NUCAM = 49) = 604;
                                              commit;
                    

           exception
           when others then
             rollback;   
             p_c_coderr := '003Z-'||P_N_CODCAM;
             p_c_deserr := sqlerrm;   
           end;  */ 
           
/*            begin
              DBMS_STATS.gather_table_stats(ownname          => 'bantprod',
                                            tabname          => 'crdtcap',
                                            degree           => 8,
                                            granularity      => 'ALL',
                                            estimate_percent => 100,
                                            cascade          => TRUE);
            end;*/
                             
           --compras           
           begin
                --- MERGE
                MERGE INTO JAQZ169 D
                USING ( select P_N_CODCAM  JAQZ168CAM,
                               d.pgcod     JAQZ168PGC,
                               d.hsucur    JAQZ168SUC,
                               d.hmda      JAQZ168MDA,
                               d.hpap      JAQZ168PAP,
                               d.hcta      JAQZ168CTA,
                               d.hoper     JAQZ168OPE,
                               d.hsubop    JAQZ168SBO,
                               d.htoper    JAQZ168TPO,
                               d.hmodul    JAQZ168MOD,                               
                               0 NewSal,    
                               0 SalAnt,
                               count(1)      Opciones,
                               0             Promedio,                     
                               P_D_FECPRO    Fecpro,
                               P_D_FECPRO    Fecval,
                               1             Dias,
                               P_D_FECPRO    JAQZ168FEC            
                         from fsh015 c,fsh016 d
                        where C.HFCON between ld_fecini and ld_feccor
                          AND C.PGCOD = 1
                          AND C.PGCOD  = D.PGCOD
                          AND C.HSUCOR = D.HSUCOR
                          AND C.HCMOD  = D.HCMOD
                          AND C.HTRAN  = D.HTRAN
                          AND C.HNREL  = D.HNREL                          
                          AND C.HFCON  = D.HFCON
                          AND D.HCORD  = 10
                          AND D.HCIMP1 > 50
                          AND C.HSUCOR = 903
                          AND C.HCMOD  = 66
                          AND C.HTRAN  = 85                          
                          AND PQ_OP_CAMMUNRUS.FN_CL_VALEMPFAM(D.HCTA) = 0
                          AND D.HTOPER IN (1,6,8,9) 
                          AND D.HMODUL = 21
                          AND D.HMDA = 0
                     group by d.pgcod,
                              d.hsucur,
                              d.hmda,
                              d.hpap,
                              d.hcta, 
                              d.hoper,
                              d.hsubop,
                              d.htoper,
                              d.hmodul
                    ) S
                
                ON (    D.JAQZ169PGC = S.JAQZ168PGC 
                    AND D.JAQZ169SUC = S.JAQZ168SUC 
                    AND D.JAQZ169MDA = S.JAQZ168MDA 
                    AND D.JAQZ169PAP = S.JAQZ168PAP 
                    AND D.JAQZ169CTA = S.JAQZ168CTA 
                    AND D.JAQZ169OPE = S.JAQZ168OPE 
                    AND D.JAQZ169SBO = S.JAQZ168SBO 
                    AND D.JAQZ169TPO = S.JAQZ168TPO 
                    AND D.JAQZ169MOD = S.JAQZ168MOD
                    AND D.JAQZ169CAM = S.JAQZ168CAM
                    AND D.JAQZ169CAM = P_N_CODCAM
                   )
                WHEN MATCHED THEN
                  UPDATE SET D.JAQZ169OPT = --S.Opciones + S.Promedio,
                                            Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  case
                                                    when (D.JAQZ169OPT + S.Opciones + S.Promedio) > ln_tope*ln_tp1imp1 then
                                                      ln_tope*ln_tp1imp1
                                                    else  
                                                      D.JAQZ169OPT + S.Opciones + S.Promedio
                                                    end                                                    
                                             else
                                                  0
                                             end,            
                             D.JAQZ169ANT = nvl(S.SalAnt,0),
                             D.JAQZ169NEW = nvl(S.NewSal,0),
                             D.JAQZ169SOR = Case
                                             when (ld_feccor = P_D_FECPRO) and (S.JAQZ168FEC  = P_D_FECPRO) then
                                                  --D.JAQZ169SOR + S.Opciones + S.Promedio
                                                  case
                                                    when (D.JAQZ169OPT + S.Opciones + S.Promedio) > ln_tope*ln_tp1imp1 then
                                                      ln_tope*ln_tp1imp1
                                                    else  
                                                      D.JAQZ169OPT + S.Opciones + S.Promedio
                                                    end                                                     
                                             else
                                                  Case
                                                    when S.JAQZ168FEC  = P_D_FECPRO then
                                                         D.JAQZ169SOR
                                                    else
                                                         0
                                                    end
                                             end,                           
                             D.JAQZ169FEC = --S.Fecpro,
                                             Case
                                             when S.JAQZ168FEC  = P_D_FECPRO then
                                                  S.Fecpro
                                             else
                                                  D.JAQZ169FEC
                                             end,                           
                             D.JAQZ169AX5 = S.Fecval,
                             D.JAQZ169AX1 = S.Dias
                WHEN NOT MATCHED THEN
                  INSERT
                    (D.JAQZ169PGC,
                     D.JAQZ169SUC,
                     D.JAQZ169MDA,
                     D.JAQZ169PAP,
                     D.JAQZ169CTA,
                     D.JAQZ169OPE,
                     D.JAQZ169SBO,
                     D.JAQZ169TPO,
                     D.JAQZ169MOD,
                     D.JAQZ169OPT,
                     D.JAQZ169SOR,
                     D.JAQZ169ANT,
                     D.JAQZ169NEW,
                     D.JAQZ169FEC,
                     D.JAQZ169AX5,
                     D.JAQZ169AX1,
                     D.JAQZ169CAM
                     )
                  VALUES
                    (S.JAQZ168PGC,
                     S.JAQZ168SUC,
                     S.JAQZ168MDA,
                     S.JAQZ168PAP,
                     S.JAQZ168CTA,
                     S.JAQZ168OPE,
                     S.JAQZ168SBO,
                     S.JAQZ168TPO,
                     S.JAQZ168MOD,
                     Case
                       when S.JAQZ168FEC  = P_D_FECPRO then
                            case
                              when (S.Opciones + S.Promedio) > ln_tope*ln_tp1imp1 then
                                ln_tope*ln_tp1imp1
                              else  
                                S.Opciones + S.Promedio
                              end                                                    
                       else
                            0
                     end,                         
                     Case
                       when (ld_feccor = P_D_FECPRO) and (S.JAQZ168FEC  = P_D_FECPRO) then
                            --S.Opciones + S.Promedio
                              case
                              when (S.Opciones + S.Promedio) > ln_tope*ln_tp1imp1 then
                                ln_tope*ln_tp1imp1
                              else  
                                S.Opciones + S.Promedio
                              end                             
                       else                              
                              0                          
                     end,                                  
                     nvl(S.SalAnt,0),
                     nvl(S.NewSal,0),
                     S.Fecpro,
                     S.Fecval,
                     S.Dias,
                     S.JAQZ168CAM
                     );          
                     commit;           
           exception
           when others then
             rollback;   
             p_c_coderr := '003A-'||P_N_CODCAM;
             p_c_deserr := sqlerrm;      
           end;                                                                      
         end if;    
      end if;         
  exception
  when others then
    p_c_coderr := '00E-2';    
    p_c_deserr := sqlerrm;    
  end sp_ah_ejecuta_camp3;  
    
  procedure sp_ah_reg_jaqz185(P_D_FECPRO IN DATE,
                              P_C_CODUSU IN VARCHAR2,
                              P_N_CODAGE IN NUMBER,
                              p_c_coderr in out varchar2,
                              p_c_deserr in out varchar2          
                             ) is
  begin
    --obtenemos el correlativo
    insert into jaqz185(jaqz185cor,
                        jaqz185fec,
                        jaqz185hor,
                        jaqz185usr,
                        jaqz185age,
                        jaqz185cod,
                        jaqz185msg
                        ) 
                values (SQ_AH_ID_LOG_CAMAHO.NEXTVAL,
                        P_D_FECPRO,
                        to_char(sysdate,'hh24:mi:ss'),
                        P_C_CODUSU,
                        P_N_CODAGE,
                        P_C_CODERR,
                        P_C_DESERR                        
                       );
    commit;                       
  exception
  when others then
    rollback;
    p_c_coderr := '00G';    
    p_c_deserr := sqlerrm;           
  end sp_ah_reg_jaqz185;                             
end PQ_AH_CAMP_AHORROS;
/

