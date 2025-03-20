create or replace procedure sp_ah_gen_opt_dupaho(P_D_FECPRO IN DATE,
                                                 p_c_coderr out varchar2,
                                                 p_c_deserr out varchar2              
                                                 ) is
  ln_monopt number(17,2):=0;     
  ld_feccor date;   
  ld_fecini date;   
  ld_fecfin date;    
  ln_numsor number(9):=0;       
                                         
begin
            
  --
  --validaciones previas
  --
  
  --validamos rango de fechas para la campaña
  begin
    select to_date(trim(x.tp1desc),'dd/mm/rrrr')
      into ld_fecini
      from fst198 x
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 60
       and x.tp1corr2 = 1
       and x.tp1nro1  = 1; --fecha de inicio
       
    select to_date(trim(x.tp1desc),'dd/mm/rrrr')
      into ld_fecfin
      from fst198 x
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 60
       and x.tp1corr2 = 1
       and x.tp1nro1  = 2; --fecha de fin              
  exception 
  when others then
    rollback;
    p_c_coderr := '001';
    p_c_deserr := 'No estan parametrizadas las fechas de inicio o fin de la campaña';
    return;
  end;  
  
  if P_D_FECPRO >= ld_fecini and P_D_FECPRO <= ld_fecfin then 
        
      --obtenemos el valor del parámetro
      begin
        select x.tp1imp1
          into ln_monopt 
          from fst198 x
         where x.tp1cod   = 1
           and x.tp1cod1  = 10825
           and x.tp1corr1 = 60
           and x.tp1corr2 = 2;
      exception
      when no_data_found then
        rollback;   
        p_c_coderr := '003';
        p_c_deserr := 'No se encontró monto parametrizado para calular opciones';
        return;
      when others then
        rollback;
        p_c_coderr := '003';
        p_c_deserr := sqlerrm;       
        return; 
      end;
      
      --verificamos las fechas de corte de los sorteos
      begin
        select COUNT(1)
          into ln_numsor
          from fst198 x
         where x.tp1cod   = 1
           and x.tp1cod1  = 10825
           and x.tp1corr1 = 60
           and x.tp1corr2 = 3;
           
           if ln_numsor = 0 then
              rollback;
              p_c_coderr := '004';
              p_c_deserr := 'No estan parametrizadas las fechas de corte de los sorteos';
              return;
           end if;                 
      exception 
      when others then
        rollback;
        p_c_coderr := '004';
        p_c_deserr := 'No estan parametrizadas las fechas de corte de los sorteos';
        return;
      end;    
                     
      p_c_coderr := '000';
      p_c_deserr := 'Proceso Satisfactorio';         
      
      --eliminamos datos antes de procesar                                               
      --EXECUTE IMMEDIATE ('truncate table jaqz168');
      begin  
              MERGE INTO JAQZ168 D
              USING (                  
                            select qq.PGCOD,
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
                                        when  max(qq.scfval) > ld_fecini then
                                          (P_D_FECPRO - max(qq.scfval) + 1)
                                        Else
                                          (P_D_FECPRO - ld_fecini + 1)
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
                                                'S'            
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
                                        when  D.JAQZ168AX5 > ld_fecini then
                                          (P_D_FECPRO - D.JAQZ168AX5 + 1)
                                        Else
                                          (P_D_FECPRO - ld_fecini + 1)
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
                 D.JAQZ168AX1
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
                 S.Dias                     
                 );                                                             
       commit;                                  
      exception
      when others then
        rollback;
        p_c_coderr := '005';
        p_c_deserr := sqlerrm;  
        return;
      end;
      
      --verificamos si fecha de proceso es igual a fecha de corte de sorteo
      begin
        select to_date(trim(x.tp1desc),'dd/mm/rrrr')
          into ld_feccor
          from fst198 x
         where x.tp1cod   = 1
           and x.tp1cod1  = 10825
           and x.tp1corr1 = 60
           and x.tp1corr2 = 3
           and to_date(trim(x.tp1desc),'dd/mm/rrrr') = P_D_FECPRO;       
      exception 
      when others then
        ld_feccor := NULL;
      end;      
      
      -- Calculamos las opciones de sorteo
      begin
            --- MERGE
            MERGE INTO JAQZ169 D
            USING (select b.JAQZ168PGC,
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
                            when b.JAQZ168MOD = 21 and b.JAQZ168TPO in (1) and (ld_fecini <= b.JAQZ168AX5 and JAQZ168AX5 <= ld_fecfin) then
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
                 D.JAQZ169AX1
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
                 S.Dias
                 );
                 commit;
        exception
        when others then
          rollback;   
          p_c_coderr := '006';
          p_c_deserr := trim(sqlcode)||'-'||sqlerrm;      
          return;
        end;   
       
  else
    p_c_coderr := '002';
    p_c_deserr := 'Campaña no se encuentra vigente para la fecha de proceso';
    return;     
  end If;        
exception    
when others then
  rollback;   
  p_c_coderr := '007';
  p_c_deserr := trim(sqlcode)||'-'||sqlerrm;      
  return; 
end sp_ah_gen_opt_dupaho;
/

