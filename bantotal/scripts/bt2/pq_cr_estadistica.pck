create or replace package PQ_CR_ESTADISTICA is
  procedure sp_cr_procesa_estadistica(PD_FECINI  IN DATE,
                                      PD_FECFIN  IN DATE,
                                      pc_coderr  out varchar2,
                                      pc_deserr  out varchar2
                                      );
                                      
  procedure sp_cr_genera_data(PC_IDCONEX IN VARCHAR2, 
                              PC_USUARIO IN VARCHAR2, 
                              PD_FECINI  IN DATE,
                              PD_FECFIN  IN DATE,
                              PC_TIPPRO  IN VARCHAR2,
                              pc_coderr  out varchar2,
                              pc_deserr  out varchar2
                              );
                                    
  procedure sp_cr_data_analista(PC_USUARIO IN CHAR, 
                                PD_FECINI  IN DATE,
                                PD_FECFIN  IN DATE,
                                PN_NIVEL   IN NUMBER,
                                PC_JEFANT  IN CHAR, 
                                PC_IDCONEX IN VARCHAR2, 
                                pc_coderr  out varchar2,
                                pc_deserr  out varchar2
                                );
                                                     
  procedure sp_cr_data_senior(PC_USUARIO IN CHAR, 
                              PD_FECINI  IN DATE,
                              PD_FECFIN  IN DATE,
                              PN_NIVEL   IN NUMBER,
                              PC_JEFANT  IN CHAR, 
                              PC_IDCONEX IN VARCHAR2, 
                              pc_coderr  out varchar2,
                              pc_deserr  out varchar2
                             );
                             
  procedure sp_cr_data_jefereg(PC_USUARIO IN CHAR, 
                               PD_FECINI  IN DATE,
                               PD_FECFIN  IN DATE,
                               PN_NIVEL   IN NUMBER,
                               PC_JEFANT  IN CHAR, 
                               PC_IDCONEX IN VARCHAR2, 
                               pc_coderr  out varchar2,
                               pc_deserr  out varchar2
                              );         
                              
  procedure sp_cr_data_gerereg(PC_USUARIO IN CHAR, 
                               PD_FECINI  IN DATE,
                               PD_FECFIN  IN DATE,
                               PN_NIVEL   IN NUMBER,
                               PC_JEFANT  IN CHAR, 
                               PC_IDCONEX IN VARCHAR2, 
                               pc_coderr  out varchar2,
                               pc_deserr  out varchar2
                             );                                                  

end PQ_CR_ESTADISTICA;
/

create or replace package body PQ_CR_ESTADISTICA is

  procedure sp_cr_procesa_estadistica(PD_FECINI  IN DATE,
                                      PD_FECFIN  IN DATE,
                                      pc_coderr  out varchar2,
                                      pc_deserr  out varchar2
                                     ) is
  cursor c_gerentes is
   select a.sng057usr sng057usr
     from sng057 a
    where a.sng055car = 220
    union
   select a.sng057sup sng057usr
     from sng057 a
    where trim(a.sng057sup) is not null;
        
  begin    
    pc_coderr := '0000';
  
    begin
      delete from jaqz154 where jaqz154idc = to_char(PD_FECFIN,'dd/mm/rrrr');
      commit;
    Exception
    When others then    
      pc_coderr := sqlcode;
      pc_deserr := sqlerrm;     
    end;  
    
    for i in c_gerentes loop
    -- Call the procedure
    pq_cr_estadistica.sp_cr_genera_data(pc_idconex => to_char(PD_FECFIN,'dd/mm/rrrr'),
                                        pc_usuario => i.sng057usr,
                                        pd_fecini  => PD_FECINI,
                                        pd_fecfin  => PD_FECFIN,
                                        pc_tippro  => 'B',--BATCH
                                        pc_coderr  => pc_coderr,
                                        pc_deserr  => pc_deserr
                                       );
     if pc_coderr <> '0000' then 
        exit;
     end if;  
   end loop;                                               
   
  Exception
  When others then    
    pc_coderr := sqlcode;
    pc_deserr := sqlerrm;                                              
  end sp_cr_procesa_estadistica;                                     

  procedure sp_cr_genera_data(PC_IDCONEX IN VARCHAR2, 
                              PC_USUARIO IN VARCHAR2, 
                              PD_FECINI  IN DATE,
                              PD_FECFIN  IN DATE,
                              PC_TIPPRO  IN VARCHAR2,
                              pc_coderr  out varchar2,
                              pc_deserr  out varchar2
                             ) is                                                      
  lc_usujef char(10);                                                     
  ln_codcar number(3):=0;
  lc_usuario char(10);     
  begin   
    
    IF PC_TIPPRO = 'L' then --EN LINEA        
        begin
          delete from jaqz154 where jaqz154idc = PC_IDCONEX;
          commit;
        Exception
        When others then    
          pc_coderr := sqlcode;
          pc_deserr := sqlerrm;     
        end;  
    End if;
      
    lc_usuario := rpad(PC_USUARIO,10,' ');    
    begin
       select a.sng055car, 
              a.sng057jef 
         into ln_codcar,
              lc_usujef
         from sng057 a
        where a.sng057usr = lc_usuario;
    Exception
    When others then    
      pc_coderr := sqlcode;
      pc_deserr := sqlerrm;  
    end;
  

      Case 
        When ln_codcar = 220 then  --gerente regional el + x cada region los senior
         begin
            -- Call the procedure
            pq_cr_estadistica.sp_cr_data_gerereg(pc_usuario => lc_usuario,
                                                 pd_fecini  => PD_FECINI,
                                                 pd_fecfin  => PD_FECFIN,
                                                 pn_nivel   => 1,
                                                 pc_jefant  => lc_usujef,
                                                 pc_idconex => PC_IDCONEX,
                                                 pc_coderr  => PC_CODERR,
                                                 pc_deserr  => PC_DESERR
                                                );
          end; 
        When ln_codcar = 202 then  --gerente de agencia o jefe zonal el + seniors + analistas
         begin
            -- Call the procedure
            pq_cr_estadistica.sp_cr_data_jefereg(pc_usuario => lc_usuario,
                                                 pd_fecini  => PD_FECINI,
                                                 pd_fecfin  => PD_FECFIN,
                                                 pn_nivel   => 2,
                                                 pc_jefant  => lc_usujef,
                                                 pc_idconex => PC_IDCONEX,
                                                 pc_coderr  => PC_CODERR,
                                                 pc_deserr  => PC_DESERR
                                                );
          end;                    
        When ln_codcar = 201 then  --analista senior --el + el comite
         begin
            -- Call the procedure
            pq_cr_estadistica.sp_cr_data_senior(pc_usuario => lc_usuario,
                                                pd_fecini  => PD_FECINI,
                                                pd_fecfin  => PD_FECFIN,
                                                pn_nivel   => 3,
                                                pc_jefant  => lc_usujef,
                                                pc_idconex => PC_IDCONEX,
                                                pc_coderr  => PC_CODERR,
                                                pc_deserr  => PC_DESERR
                                               );
          end;               

        When ln_codcar = 200 then                     
          begin
            -- Call the procedure
            pq_cr_estadistica.sp_cr_data_analista(pc_usuario => lc_usuario,
                                                  pd_fecini  => PD_FECINI,
                                                  pd_fecfin  => PD_FECFIN,
                                                  pn_nivel   => 4,
                                                  pc_jefant  => lc_usujef,
                                                  pc_idconex => PC_IDCONEX,
                                                  pc_coderr  => PC_CODERR,
                                                  pc_deserr  => PC_DESERR
                                                  );
          end;                                                     
        Else          
          begin
            -- Call the procedure
            pq_cr_estadistica.sp_cr_data_analista(pc_usuario => lc_usuario,
                                                  pd_fecini  => PD_FECINI,
                                                  pd_fecfin  => PD_FECFIN,
                                                  pn_nivel   => 5,
                                                  pc_jefant  => lc_usujef,
                                                  pc_idconex => PC_IDCONEX,
                                                  pc_coderr  => PC_CODERR,
                                                  pc_deserr  => PC_DESERR
                                                  );
          end;                    
      End Case;
      commit;
  Exception
  When others then    
    pc_coderr := sqlcode;
    pc_deserr := sqlerrm;  
  end sp_cr_genera_data; 
  procedure sp_cr_data_analista(PC_USUARIO IN CHAR, 
                                PD_FECINI  IN DATE,
                                PD_FECFIN  IN DATE,
                                PN_NIVEL   IN NUMBER,
                                PC_JEFANT  IN CHAR,                                 
                                PC_IDCONEX IN VARCHAR2, 
                                pc_coderr  out varchar2,
                                pc_deserr  out varchar2
                                ) is
    cursor c_analista(lc_usuario in char) is
    select x.usuario,
           x.tarea, 
           count(1) total,      
           /* 
           avg(x.tiempo) promedio_tiempo,
           max(x.tiempo) max_tarea,
           min(x.tiempo) min_tarea
           */
           substr('0' || floor((avg(x.tiempo)) * 24),-2) || ':' ||
                     substr('0' || round((((avg(x.tiempo)) * 24) -
                                         (floor((avg(x.tiempo)) * 24))) * 60,
                                         0),
                            -2) promedio_tiempo_hm,       
           substr('0' || floor((max(x.tiempo)) * 24),-2) || ':' ||
                     substr('0' || round((((max(x.tiempo)) * 24) -
                                         (floor((max(x.tiempo)) * 24))) * 60,
                                         0),
                            -2) max_tarea_hm,
           substr('0' || floor((min(x.tiempo)) * 24),-2) || ':' ||
                     substr('0' || round((((min(x.tiempo)) * 24) -
                                         (floor((min(x.tiempo)) * 24))) * 60,
                                         0),
                            -2) min_tarea_hm                                                           
     from (
        select a.wfinsprcid   solicitud,
               a.wftaskcod    tarea,
               a.wfitemusrcod usuario,
               --round(sum(decode(a.wfitemend,to_date('01/01/0001','dd/mm/rrrr'),sysdate,a.wfitemend)- a.wfiteminit)*60*24,2) tiempo
               sum(decode(a.wfitemend,to_date('01/01/0001','dd/mm/rrrr'),sysdate,a.wfitemend)- a.wfiteminit) tiempo               
          from wfwrkitems a, 
               xwf700     b,
               fsd010     c 
         where a.wfinsprcid   = b.xwfprcins   
           and b.xwfcar3      = '1'
           and a.wftaskcod    in (3,7,11,55)
           and b.xwfempresa   = c.pgcod
           and b.xwfsucursal  = c.aosuc
           and b.xwfmodulo    = c.aomod
           and b.xwfmoneda    = c.aomda
           and b.xwfpapel     = c.aopap
           and b.xwfcuenta    = c.aocta
           and b.xwfoperacion = c.aooper
           and b.xwfsubope    = c.aosbop
           and b.xwftipope    = c.aotope
           and a.wfitemusrcod = lc_usuario
           and TRUNC(a.wfiteminit) >= PD_FECINI
           and TRUNC(a.wfitemend)  <= PD_FECFIN
           and c.aofval between PD_FECINI and PD_FECFIN
      group by a.wfinsprcid,a.wftaskcod,a.wfitemusrcod   
            ) x
    group by x.usuario, x.tarea;    

    cursor c_total(lc_usuario in char) is
        select count(distinct a.wfinsprcid)   total_sol
          from wfwrkitems a, 
               xwf700     b,
               fsd010     c 
         where a.wfinsprcid   = b.xwfprcins   
           and b.xwfcar3      = '1'
           and a.wftaskcod    in (3,7,11,55)
           and b.xwfempresa   = c.pgcod
           and b.xwfsucursal  = c.aosuc
           and b.xwfmodulo    = c.aomod
           and b.xwfmoneda    = c.aomda
           and b.xwfpapel     = c.aopap
           and b.xwfcuenta    = c.aocta
           and b.xwfoperacion = c.aooper
           and b.xwfsubope    = c.aosbop
           and b.xwftipope    = c.aotope
           and a.wfitemusrcod = lc_usuario
           and TRUNC(a.wfiteminit) >= PD_FECINI
           and TRUNC(a.wfitemend)  <= PD_FECFIN
           and c.aofval between PD_FECINI and PD_FECFIN;       
                           
  lc_usuario char(10);
  lc_tprsol char(5):='';
  lc_tmisol char(5):='';
  lc_tmasol char(5):='';
  lc_tpreva char(5):='';
  lc_tmieva char(5):='';
  lc_tmaeva char(5):='';  
  lc_tprapr char(5):='';
  lc_tmiapr char(5):='';
  lc_tmaapr char(5):='';  
  lc_tprdes char(5):='';
  lc_tmides char(5):='';
  lc_tmades char(5):='';    
  ln_totsol number(12,2):=0;       
  ln_toteva number(12,2):=0;      
  ln_totapr number(12,2):=0;    
  ln_totdes number(12,2):=0;           
  ln_total  number(12,2):=0;     
                                         
begin
  pc_coderr := '0000';
  lc_usuario := PC_USUARIO;
  for i in c_analista(lc_usuario) loop   
    case
      when i.tarea = 3  then --solicitud
           lc_tprsol := i.promedio_tiempo_hm;
           lc_tmisol := i.min_tarea_hm;
           lc_tmasol := i.max_tarea_hm;
           ln_totsol := i.total;           
      when i.tarea = 7  then --evaluacion
           lc_tpreva := i.promedio_tiempo_hm;
           lc_tmieva := i.min_tarea_hm;
           lc_tmaeva := i.max_tarea_hm;
           ln_toteva := i.total;
           
      when i.tarea = 11 then --aprobacion
           lc_tprapr := i.promedio_tiempo_hm;
           lc_tmiapr := i.min_tarea_hm;
           lc_tmaapr := i.max_tarea_hm;
           ln_totapr := i.total;           
      when i.tarea = 55 then --desembolso
           lc_tprdes := i.promedio_tiempo_hm;
           lc_tmides := i.min_tarea_hm;
           lc_tmades := i.max_tarea_hm;
           ln_totdes := i.total;           
    end case;
  End loop; 

  for i in c_total(lc_usuario) loop
    ln_total := i.total_sol;
  End loop;
  --if ln_total > 0 then
    begin
      insert into jaqz154
        (
         jaqz154idc, jaqz154usr, jaqz154jef, jaqz154nvl, 
         jaqz154des, jaqz154spr, jaqz154smx, jaqz154smi, jaqz154sto, 
         jaqz154dee, jaqz154epr, jaqz154emx, jaqz154emi, jaqz154eto, 
         jaqz154dea, jaqz154apr, jaqz154amx, jaqz154ami, jaqz154ato, 
         jaqz154ded, jaqz154dpr, jaqz154dmx, jaqz154dmi, jaqz154dto, 
         jaqz154tos            
        )
      values
        (PC_IDCONEX,  lc_usuario, PC_JEFANT, PN_NIVEL, 
        'SOLICITUD',  lc_tprsol,  lc_tmisol, lc_tmasol, ln_totsol, 
        'EVALUACION', lc_tpreva,  lc_tmieva, lc_tmaeva, ln_toteva, 
        'APROBACION', lc_tprapr,  lc_tmiapr, lc_tmaapr, ln_totapr, 
        'DESEMBOLSO', lc_tprdes,  lc_tmides, lc_tmades, ln_totdes, 
        ln_total
        );
    exception
    when others then    
      /*
      pc_coderr := sqlcode;
      */
      pc_deserr := sqlerrm||' - '||lc_usuario||' - '||PC_JEFANT||' - '||PN_NIVEL;
        
/*        insert into log_error_bandeja(n_nro,
                                      c_codbdj,
                                      c_deserr,
                                      d_fecerr
                                     ) 
                              values(9999,
                                     'STADI',
                                     pc_deserr||' - '||trim(PC_IDCONEX),
                                     trunc(sysdate)--TO_DATE(PC_IDCONEX,'DD/MM/RRRR')
                                     );*/
        pc_deserr := null;                                   
    end;            
  --end if;
  exception
  when others then    
    pc_coderr := sqlcode;
    pc_deserr := sqlerrm;       
  end sp_cr_data_analista;  

  procedure sp_cr_data_senior(PC_USUARIO IN CHAR, 
                              PD_FECINI  IN DATE,
                              PD_FECFIN  IN DATE,
                              PN_NIVEL   IN NUMBER,
                              PC_JEFANT  IN CHAR, 
                              PC_IDCONEX IN VARCHAR2, 
                              pc_coderr  out varchar2,
                              pc_deserr  out varchar2
                             ) is
  cursor c_senior (lc_usuario in char) is
   select a.sng055car, 
          a.sng057usr
     from sng057 a
    where a.sng057jef = lc_usuario;
                                          
  begin
    pc_coderr := '0000';
    begin
      -- Call the procedure
      pq_cr_estadistica.sp_cr_data_analista(pc_usuario => PC_USUARIO,
                                            pd_fecini  => PD_FECINI,
                                            pd_fecfin  => PD_FECFIN,
                                            pn_nivel   => PN_NIVEL,
                                            pc_jefant  => PC_JEFANT,
                                            pc_idconex => PC_IDCONEX,
                                            pc_coderr  => PC_CODERR,
                                            pc_deserr  => PC_DESERR
                                            );
    end;         
    for i in c_senior(PC_USUARIO) loop
      pq_cr_estadistica.sp_cr_data_analista(pc_usuario => i.sng057usr,
                                            pd_fecini  => PD_FECINI,
                                            pd_fecfin  => PD_FECFIN,
                                            pn_nivel   => 4,
                                            pc_jefant  => PC_USUARIO,
                                            pc_idconex => PC_IDCONEX,
                                            pc_coderr  => PC_CODERR,
                                            pc_deserr  => PC_DESERR
                                            );      
    end loop;      
  exception
  when others then    
    pc_coderr := sqlcode;
    pc_deserr := sqlerrm;                                   
  end sp_cr_data_senior;                                    
  
  procedure sp_cr_data_jefereg(PC_USUARIO IN CHAR, 
                               PD_FECINI  IN DATE,
                               PD_FECFIN  IN DATE,
                               PN_NIVEL   IN NUMBER,
                               PC_JEFANT  IN CHAR, 
                               PC_IDCONEX IN VARCHAR2, 
                               pc_coderr  out varchar2,
                               pc_deserr  out varchar2
                             ) is
  cursor c_jefes (lc_usuario in char) is
   select a.sng055car, 
          a.sng057usr
     from sng057 a
    where a.sng057jef = lc_usuario;
                                          
  begin
    pc_coderr := '0000';    
    begin
      -- Call the procedure
      pq_cr_estadistica.sp_cr_data_analista(pc_usuario => PC_USUARIO,
                                            pd_fecini  => PD_FECINI,
                                            pd_fecfin  => PD_FECFIN,
                                            pn_nivel   => PN_NIVEL,
                                            pc_jefant  => PC_JEFANT,
                                            pc_idconex => PC_IDCONEX,
                                            pc_coderr  => PC_CODERR,
                                            pc_deserr  => PC_DESERR
                                            );
    end; 
            
    for i in c_jefes(PC_USUARIO) loop      
      begin
        pq_cr_estadistica.sp_cr_data_senior(pc_usuario => i.sng057usr,
                                            pd_fecini  => PD_FECINI,
                                            pd_fecfin  => PD_FECFIN,
                                            pn_nivel   => 3,
                                            pc_jefant  => PC_USUARIO,
                                            pc_idconex => PC_IDCONEX,
                                            pc_coderr  => PC_CODERR,
                                            pc_deserr  => PC_DESERR
                                           );      
      end;                                            
    end loop;   
  exception
  when others then    
    pc_coderr := sqlcode;
    pc_deserr := sqlerrm;                                      
  end sp_cr_data_jefereg;      
  
  procedure sp_cr_data_gerereg(PC_USUARIO IN CHAR, 
                               PD_FECINI  IN DATE,
                               PD_FECFIN  IN DATE,
                               PN_NIVEL   IN NUMBER,
                               PC_JEFANT  IN CHAR, 
                               PC_IDCONEX IN VARCHAR2, 
                               pc_coderr  out varchar2,
                               pc_deserr  out varchar2
                             ) is
  cursor c_gerente (lc_usuario in char) is
   select a.sng055car, 
          a.sng057usr
     from sng057 a
    where a.sng057jef = lc_usuario;
                                           
  begin
    pc_coderr := '0000';
    begin
      -- Call the procedure
      pq_cr_estadistica.sp_cr_data_analista(pc_usuario => PC_USUARIO,
                                            pd_fecini  => PD_FECINI,
                                            pd_fecfin  => PD_FECFIN,
                                            pn_nivel   => PN_NIVEL,
                                            pc_jefant  => PC_JEFANT,
                                            pc_idconex => PC_IDCONEX,
                                            pc_coderr  => PC_CODERR,
                                            pc_deserr  => PC_DESERR
                                            );
    end; 
            
    for i in c_gerente(PC_USUARIO) loop      
      begin
        pq_cr_estadistica.sp_cr_data_jefereg(pc_usuario => i.sng057usr,
                                             pd_fecini  => PD_FECINI,
                                             pd_fecfin  => PD_FECFIN,
                                             pn_nivel   => 2,
                                             pc_jefant  => PC_USUARIO,
                                             pc_idconex => PC_IDCONEX,
                                             pc_coderr  => PC_CODERR,
                                             pc_deserr  => PC_DESERR
                                            );      
      end;                                            
    end loop;       
  exception
  when others then    
    pc_coderr := sqlcode;
    pc_deserr := sqlerrm;                                  
  end sp_cr_data_gerereg;     
                                   
end PQ_CR_ESTADISTICA;
/

