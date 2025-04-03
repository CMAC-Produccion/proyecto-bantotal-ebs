create or replace package PQ_CR_TRANSFGASTO is

  -- Author  : SMARQUEZ
  -- Created : 23/09/2020 3:40:10 p. m.
  -- Purpose : Pase de creditos prejudiales al gasto  
  -- Public type declarations  
  -- Public function and procedure declarations
  -- Modificación: SMARQUEZ 16/09/2024 Optimización proceso de estado 64
  procedure SP_CargaDatos;
  function FN_DiasAtraso(v_Pgfape in date, --fecha de proceso
                         v_Pgcod  in number,
                         v_Scmod  in number,
                         v_Scsuc  in number,
                         v_Scmda  in number,
                         v_Scpap  in number,
                         v_Sccta  in number,
                         v_Scoper in number,
                         v_Scsbop in number,
                         v_Sctope in number,                        
                         v_fecven in date) return number;
                         
   function FN_Reprogramado( v_Pgcod  in number,
                             v_Scmod  in number,
                             v_Scsuc  in number,
                             v_Scmda  in number,
                             v_Scpap  in number,
                             v_Sccta  in number,
                             v_Scoper in number,
                             v_Scsbop in number,
                             v_Sctope in number)return char;     
  procedure SP_DATOS_TRANSGASTO(pn_emp    in number,
                                pn_mod    in number,
                                pn_suc    in number,
                                pn_mda    in number,
                                pn_pap    in number,
                                pn_cta    in number,
                                pn_ope    in number,
                                pn_sbo    in number,
                                pn_top    in number,
                                pd_fecpro in date,
                                pd_fecha  in date,
                                pn_saldo  out number,
                                pn_mondes out number,
                                pc_estado out varchar2,
                                pd_fechapago  out date);                                                 
                         

end PQ_CR_TRANSFGASTO;
/
create or replace package body PQ_CR_TRANSFGASTO is
  -- Author  : SMARQUEZ
  -- Created : 23/09/2020 3:40:10 p. m.
  -- Purpose : Pase de creditos prejudiales al gasto  
  -- Modificacion: Integracion de Datos para el Reporte de control
  -- Fecha Modificacion: 16/11/2020 11:58 a.m.
  -- Modificación: SMARQUEZ 16/09/2024 Optimización proceso de estado 64 Judiciales
  -- Modificación: SMARQUEZ 25/03/2025 Eliminacion de el paso a gasto 
  -- de los solidarios negativoas negativos
  
  procedure SP_CargaDatos is
    cursor DATOS is     ---Prejudicial Menor
       select b.*,c.sgcod,a.scrub, a.scsdo
         from fsd010 b,  fpp001 c ,fsd011 a 
         where b.aomod in (select modulo from fst111 where dscod =50 ) 
          and b.aostat in(select tp1nro1
                            from fst198
                           where tp1cod = 1
                             and tp1cod1 = 10884
                             and tp1corr1 = 40
                             and tp1corr2 = 2)
                            
          and c.pgcod = b.pgcod
          and c.aomod  = b.aomod
          and c.aosuc = b.aosuc
          and c.aomda = b.aomda 
          and c.aopap = b.aopap
          and c.aocta = b.aocta
          and c.aooper = b.aooper
          and c.aosbop = b.AOSBOP
          and c.sgcod  in (SELECT SGCOD FROM FST300 WHERE SGSN02 =5 )    
          and a.pgcod =  c.pgcod
          and a.scsuc = c.aosuc
          and a.scrub = 2514020000005
          and a.scsdo <0
          and a.scmod = 260
          and a.scpap = c.aopap
          and a.sccta = c.aocta
          and a.scoper = c.aooper;

          
   cursor DATOS1 is ---Judiciales
       select b.*,(select sgcod from fpp001 
                    where aocta = a.sccta 
                      and aooper = a.scoper 
                      and sgcod in (select sgcod from fst300 where SGSN02 =5) 
                      and aosbop = (select max(aosbop) from fpp001 
                                     where aocta = a.sccta 
                                       and aooper = a.scoper 
                                       AND aosbop <> 609 )
                      and rownum = 1) sgcod,
         a.scrub, a.scsdo,a.scfulm
         from fsd010 b,  fsd011 a 
         where b.aomod in (select modulo from fst111 where dscod =50 ) 
          and b.aostat in(select tp1nro1
                            from fst198
                           where tp1cod = 1
                             and tp1cod1 = 10884
                             and tp1corr1 = 40
                             and tp1corr2 = 3)      
          and a.pgcod =  b.pgcod
          and a.scsuc = b.aosuc
          and a.sccta <> 999999999
          and a.scrub = 2514020000005
          and a.scsdo <0
          and a.scmod = 260
          and a.scpap = b.aopap
          and a.sccta = b.aocta
          and a.scoper = b.aooper;
   
  ld_fecha date ;
  ld_pgfape date;
  ln_diaatra number:= 0;

  diaatraso number := 0;
  lc_reprog char(1):= 'N';
  ln_monto1 number(17,2):=0;
  modulo number; 
  suboper number;
  tope number;
  Existe char(2);
  seguro number;
  begin
  Execute immediate ('truncate table jaqz592');  
  delete jaqz592HI where jaqz592hau8 ='N';
  COMMIT;

    select pgfape 
      into ld_pgfape
      from fst017
     where pgcod = 1; 
      
     select tp1nro1
       into diaatraso
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10884
         and tp1corr1 = 40
         and tp1corr2 = 1;
    
    ld_fecha := ld_pgfape - diaatraso;

    for reg in Datos loop
      
      ln_diaatra := FN_diasatraso(ld_pgfape,-- fecha proceso
                                  reg.pgcod,
                                  reg.aomod,
                                  reg.aosuc,
                                  reg.aomda,
                                  reg.aopap,
                                  reg.aocta,
                                  reg.aooper,
                                  reg.aosbop,
                                  reg.aotope,                                
                                  ld_fecha); --fecha - 90 dias
                                  
      lc_reprog := FN_Reprogramado(reg.pgcod,
                                   reg.aomod,
                                   reg.aosuc,
                                   reg.aomda,
                                   reg.aopap,
                                   reg.aocta,
                                   reg.aooper,
                                   reg.aosbop,
                                   reg.aotope);
                                   
      if  ln_diaatra > diaatraso and lc_reprog ='N' then
        begin
          ln_monto1 := ABS(reg.scsdo);
          insert into jaqz592(jaqz592pgc,
                              jaqz592suc,
                              jaqz592mda, 
                              jaqz592pap, 
                              jaqz592cta, 
                              jaqz592ope, 
                              jaqz592sbop, 
                              jaqz592tope, 
                              jaqz592mod,
                              jaqz592fpag,
                              jaqz592seg, 
                              jaqz592rub, 
                              jaqz592est, 
                              --jaqz592dest,
                              jaqz592fpro, 
                              jaqz592mto, 
                              jaqz592diat,
                              jaqz592au8)
                      values (reg.pgcod,                                
                              reg.aosuc,
                              reg.aomda,
                              reg.aopap,
                              reg.aocta,
                              reg.aooper,
                              reg.aosbop,
                              reg.aotope,
                              reg.aomod,
                              ld_pgfape, ---fecha pago
                              reg.sgcod,
                              reg.scrub,
                              reg.aostat,
                              ld_pgfape,
                              ln_monto1,--- reg.scsdo,
                              ln_diaatra,
                              'N' ); 
            insert into jaqz592HI(jaqz592hpgc,
                                  jaqz592hsuc,
                                  jaqz592hmda, 
                                  jaqz592hpap, 
                                  jaqz592hcta, 
                                  jaqz592hope, 
                                  jaqz592hsbop, 
                                  jaqz592htope, 
                                  jaqz592hmod,
                                  jaqz592hfpag,
                                  jaqz592hseg, 
                                  jaqz592hrub, 
                                  jaqz592hest, 
                                  --jaqz592dest,
                                  jaqz592hfpro, 
                                  jaqz592hmto, 
                                  jaqz592hdiat,
                                  jaqz592hau8)
                          values (reg.pgcod,                                
                                  reg.aosuc,
                                  reg.aomda,
                                  reg.aopap,
                                  reg.aocta,
                                  reg.aooper,
                                  reg.aosbop,
                                  reg.aotope,
                                  reg.aomod,
                                  ld_pgfape, ---fecha pago
                                  reg.sgcod,
                                  reg.scrub,
                                  reg.aostat,
                                  ld_pgfape,
                                  ln_monto1, --reg.scsdo,
                                  ln_diaatra,
                                  'N' );                   
           commit;                                                    
        exception
          when dup_Val_on_index then
            null;
        end;
      
        end if;
      
    end loop;
     For reg1 in datos1 loop
    --  ln_diaatra := ld_pgfape - reg1.scfulm;
     /* lc_reprog := FN_Reprogramado(reg1.pgcod,
                                   reg1.aomod,
                                   reg1.aosuc,
                                   reg1.aomda,
                                   reg1.aopap,
                                   reg1.aocta,
                                   reg1.aooper,
                                   reg1.aosbop,
                                   reg1.aotope);*/
    --  if  ln_diaatra > diaatraso then ---and lc_reprog ='N' then
        --------------------- Adicion de Optimizacion -----------------  
          --  dbms_output.put_line(a.jaqz592cta||' '||a.jaqz592ope);
           Begin
              select aomod ,aosbop, aotope
                into modulo, suboper,tope
                from fsd010 
                where aocta = reg1.aocta
                  and aooper = reg1.aooper
                  and aomod <> 200
                  and aomod in (select modulo from fst111 where dscod = 50)
                  and aosbop = reg1.aosbop - 1;
          exception
            when no_data_found then
              modulo:= 0;
              suboper:= 0;
              tope := 0;
          end;
      --    dbms_output.put_line(modulo||' '||suboper||' '||tope);   
         Begin
          select 'Si', sgcod
            into Existe, seguro
            from fpp001
           where aocta = reg1.aocta
             and aooper = reg1.aooper
             and aomod = modulo
             and aosbop = suboper
             and aotope = tope
             and sgcod in (select sgcod from fst300 where SGSN02 = '5');
          delete fpp001
           where aocta = reg1.aocta
             and aooper = reg1.aooper 
             and aomod = modulo
             and aosbop = suboper
             and aotope = tope
             and sgcod = seguro;
          exception
            when no_data_found then
              Begin
                select 'Si', sgcod
                  into Existe, seguro
                  from fpp001
                 where aocta = reg1.aocta
                   and aooper = reg1.aooper
                   and aomod = modulo
                   and aosbop = suboper - 1
                   and aotope = tope
                   and sgcod in (select sgcod from fst300 where SGSN02 = '5');
                delete fpp001
                 where aocta = reg1.aocta
                   and aooper = reg1.aooper
                   and aomod = modulo
                   and aosbop = suboper - 1
                   and aotope = tope
                   and sgcod = seguro;
                   
              exception
                when no_data_found then
                   begin   
                    select 'Si', sgcod
                      into Existe, seguro
                      from fpp001
                     where aocta = reg1.aocta
                       and aooper = reg1.aooper
                       and aomod = modulo
                       and aosbop = 0
                       and sgcod in
                           (select sgcod from fst300 where SGSN02 = '5');
                    --    dbms_output.put_line(reg1.aocta||' '||reg1.aooper||' '||modulo||' '||suboper||' '||tope||' '||Existe||' '||seguro); 
                    delete fpp001
                     where aocta = reg1.aocta
                       and aooper = reg1.aooper
                       and aomod = modulo
                       and aosbop = 0                     
                       and sgcod = seguro;
                  exception
                    when no_data_found then
                      existe:='No';
                      seguro:= 0;
                  
                  ---   dbms_output.put_line(reg1.aocta||' '||reg1.aooper||' '||modulo||' '||suboper||' '||tope||' '||Existe||' '||seguro); 
                 end;
              end;
          end;
      
        ---------------------------------------------------------------
        begin
          ln_monto1 := ABS(reg1.scsdo);
          --modulo||' '||suboper||' '||tope||' '||Existe||' '||seguro);
          insert into jaqz592(jaqz592pgc,
                              jaqz592suc,
                              jaqz592mda, 
                              jaqz592pap, 
                              jaqz592cta, 
                              jaqz592ope, 
                              jaqz592sbop, 
                              jaqz592tope, 
                              jaqz592mod,
                              jaqz592fpag,
                              jaqz592seg, 
                              jaqz592rub, 
                              jaqz592est,                              
                              jaqz592fpro, 
                              jaqz592mto, 
                              jaqz592diat,
                              jaqz592au8)
                      values (reg1.pgcod,                                
                              reg1.aosuc,
                              reg1.aomda,
                              reg1.aopap,
                              reg1.aocta,
                              reg1.aooper,
                              suboper,
                              tope,
                              modulo,
                              ld_pgfape, ---fecha pago
                              seguro,
                              reg1.scrub,
                              reg1.aostat,
                              ld_pgfape,
                              ln_monto1,--- reg1.scsdo,
                              ln_diaatra,
                              'N' ); 
            insert into jaqz592HI(jaqz592hpgc,
                                  jaqz592hsuc,
                                  jaqz592hmda, 
                                  jaqz592hpap, 
                                  jaqz592hcta, 
                                  jaqz592hope, 
                                  jaqz592hsbop, 
                                  jaqz592htope, 
                                  jaqz592hmod,
                                  jaqz592hfpag,
                                  jaqz592hseg, 
                                  jaqz592hrub, 
                                  jaqz592hest,                                   
                                  jaqz592hfpro, 
                                  jaqz592hmto, 
                                  jaqz592hdiat,
                                  jaqz592hau8)
                          values (reg1.pgcod,                                
                                  reg1.aosuc,
                                  reg1.aomda,
                                  reg1.aopap,
                                  reg1.aocta,
                                  reg1.aooper,
                                  suboper,
                                  tope,
                                  modulo,
                                  ld_pgfape, ---fecha pago
                                  seguro,
                                  reg1.scrub,
                                  reg1.aostat,
                                  ld_pgfape,
                                  ln_monto1, --reg1.scsdo,
                                  ln_diaatra,
                                  'N' );                   
           commit;                                                    
        exception
          when dup_Val_on_index then
            null;
        end;
     -- end if;
    end loop;    

  end SP_CargaDatos;

  function FN_diasatraso(v_Pgfape in date, --fecha de proceso
                         v_Pgcod  in number,
                         v_Scmod  in number,
                         v_Scsuc  in number,
                         v_Scmda  in number,
                         v_Scpap  in number,
                         v_Sccta  in number,
                         v_Scoper in number,
                         v_Scsbop in number,
                         v_Sctope in number,                        
                         v_fecven in date) return number is --fecha menos 90

      ln_diatr number;   
    begin

      If v_Scmod in (200,33,141) Then   --se agrego carta fianza

         ln_diatr := v_Pgfape - v_fecven;

         If ln_diatr < 0 then
            ln_diatr := 0 ;
         End if;

      Else
          begin
            --vigente y refinanciado
            /*SELECT (v_Pgfape - min(a.Ppfpag))
              into ln_diatr
              FROM FSD601 a
              left join FSD602 b on b.Pgcod = a.Pgcod
                                and b.Ppmod = a.Ppmod
                                and b.Ppsuc = a.Ppsuc
                                and b.Ppmda = a.Ppmda
                                and b.Pppap = a.Pppap
                                and b.Ppcta = a.Ppcta
                                and b.Ppoper = a.Ppoper
                                and b.Ppsbop = a.Ppsbop
                                and b.Pptope = a.Pptope
                                and b.Ppfpag = a.Ppfpag
                                and b.Pptipo = a.Pptipo
                                and b.Pp1stat = 'T'
                                and b.D602co = 'S'
                                   --and b.pptipo  <> 'K'
                                and b.pp1fech <= v_Pgfape
             where a.Pgcod = v_Pgcod
               and a.Ppmod = v_Scmod
               and a.Ppsuc = v_Scsuc
               and a.Ppmda = v_Scmda
               and a.Pppap = v_Scpap
               and a.Ppcta = v_Sccta
               and a.Ppoper = v_Scoper
               and a.Ppsbop = v_Scsbop
               and a.Pptope = v_Sctope
               and a.Ppfpag <= v_Pgfape
               and a.D601co = 'S'
               and (a.ppcap + a.ppint) > 0 --se agrego por cuotas de gracia 2013.09.06
               and b.D602co is null;*/
               SELECT (v_Pgfape - max(Ppfpag))   
                 into ln_diatr            
                 from FSD602 b 
                where b.Pgcod = v_Pgcod
                  and b.Ppmod = v_Scmod
                  and b.Ppsuc = v_Scsuc
                  and b.Ppmda = v_Scmda
                  and b.Pppap = v_Scpap
                  and b.Ppcta = v_Sccta
                  and b.Ppoper = v_Scoper
                  and b.Ppsbop = v_Scsbop
                  and b.Pptope = v_Sctope              
                  and b.Pp1stat = 'T'
                  and b.D602co = 'S'
                  and b.pp1fech <= v_Pgfape;
               
          exception
            when no_data_found then
              Begin
                select (v_Pgfape - min(d.Ppfpag))
                  into ln_diatr
                  from fsd601 d
                 where d.Pgcod = v_Pgcod
                   and d.Ppmod = v_Scmod
                   and d.Ppsuc = v_Scsuc
                   and d.Ppmda = v_Scmda
                   and d.Pppap = v_Scpap
                   and d.Ppcta = v_Sccta
                   and d.Ppoper = v_Scoper
                   and d.Ppsbop = v_Scsbop
                   and d.Pptope = v_Sctope
                   and d.Ppfpag <= v_Pgfape
                   and (d.ppcap + d.ppint) > 0;
              exception
                  when no_data_found then
                       ln_diatr := 0;
              End;
          end;
      End IF;
    return(NVL(ln_diatr,0));
  end FN_diasatraso;
  
  function FN_Reprogramado(v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number) return char is
  tipoRE char(1):='N';
  tipo1 number:=0;
  ln_instancia number(10):= 0;
  begin  
    ln_instancia := fn_instancia_credito(v_Scmod,
                                         v_Scsuc,
                                         v_Scmda,
                                         v_Scpap,
                                         v_Sccta,
                                         v_Scoper,
                                         v_Scsbop,
                                         v_Sctope);
     --- verifica reprogramaciones
           Begin
            select 'S', 1
              into tipoRE,tipo1
              from aqpb002 b
             where aqpb002fep > to_date('30/03/2020','dd/mm/yyyy') --and ld_fechafin
               and b.aqpb002emp = v_pgcod
               and b.aqpb002mod = v_Scmod
               and b.aqpb002suc = v_Scsuc
               and b.aqpb002mda = v_Scmda
               and b.aqpb002pap = v_Scpap
               and b.aqpb002cta = v_Sccta
               and b.aqpb002ope = v_Scoper
               and b.aqpb002sbo = v_Scsbop
               and b.aqpb002top = v_Sctope
               and b.aqpb002est = 'C'
               and nvl(b.aqpb002revr, 'N')  <> 'S'
               and rownum = 1;-- reprogramacion masiva
          exception
            when no_data_found then
              tipo1 := 0;
              Begin
                select 'S',2
                  into tipoRE, tipo1
                  from sng001 s
                 where s.sng001inst = ln_instancia
                   and s.sng014cod = 4
                   and s.sng001fin > to_Date('01/01/2020','dd/mm/yyyy')
                   and s.sng001ori =14
                   and rownum = 1; --reprogramacion por el flujo
              exception
                when no_data_found then
                  begin
                     select 'S',3
                       into tipoRE, tipo1
                       from jaqz698
                      where jaqz698fep > to_Date('23/03/2020','dd/mm/yyyy')
                        and jaqz698emp = v_pgcod
                        AND jaqz698mod = v_Scmod
                        and jaqz698suc = v_Scsuc
                        and jaqz698mda = v_Scmda
                        and jaqz698pap = v_Scpap
                        and jaqz698cta = v_Sccta
                        and jaqz698ope = v_Scoper
                        and jaqz698sbo = v_Scsbop
                        and jaqz698top = v_Sctope
                        AND jaqz698est in ('X','C')
                        and rownum = 1;
                  exception
                    when no_data_found then
                      tipoRE:= 'N'; -- no reprogramado
                  end;
              End;
          End;
    
      return(tipoRE);
  end FN_reprogramado;
  
  procedure SP_DATOS_TRANSGASTO(pn_emp    in number,
                                pn_mod    in number,
                                pn_suc    in number,
                                pn_mda    in number,
                                pn_pap    in number,
                                pn_cta    in number,
                                pn_ope    in number,
                                pn_sbo    in number,
                                pn_top    in number,
                                pd_fecpro in date,
                                pd_fecha  in date,
                                pn_saldo  out number,
                                pn_mondes out number,
                                pc_estado out varchar2,
                                pd_fechapago  out date) is
  saldo  number(17,2):=0;
  monto  number(17,2):=0;
  estado varchar2(30);
  fechapago date;
  Begin
      saldo := pq_cr_tramdesgra.Fn_scap_calendario(pn_emp,
                                                    pn_mod,
                                                    pn_suc,
                                                    pn_mda,
                                                    pn_pap,
                                                    pn_cta,
                                                    pn_ope,
                                                    pn_sbo,
                                                    pn_top,
                                                    pd_fecpro,
                                                    pd_fecha);
         pn_saldo := saldo;
     --fecha de desembolso,monto desembolsado,periodo
          begin
            select aoimp,
                   (Select cenom from fst026 where cecod = aostat) estado
               into monto,estado --pn_mondes,  pc_estado
               from fsd010 a
              where a.pgcod = pn_EMP
                and a.aomod = pn_MOD
                and a.aosuc = pn_SUC
                and a.aomda = pn_MDA
                and a.aopap = pn_PAP
                and a.aocta = pn_CTA
                and a.aooper = pn_OPE
                and a.aosbop = pn_SBO
                and a.aotope = pn_TOP;

          exception
            when no_data_found then
              begin
                select aoimp,
                       (select cenom from fst026 where cecod = aostat) estado
                  into monto,estado-- pn_mondes, pc_estado
                  from fsd010 a
                 where a.pgcod = pn_EMP
                   and a.aomod = pn_MOD
                   and a.aosuc  = pn_SUC
                   and a.aomda = pn_MDA
                   and a.aopap = pn_PAP
                   and a.aocta = pn_CTA
                   and a.aooper = pn_OPE
                   and a.aosbop = pn_SBO
                   and a.aotope = pn_TOP;

              exception
                when no_data_found then
                  monto  := 0;
                  estado  := 'Sin Estado';
              end;
           end;
           pn_mondes := monto;
           pc_estado := estado;
        ---
        begin
          select MAx(ppfpag)
            into fechapago
            from fsd602 o
           where o.pgcod = pn_emp
             and o.ppmod = pn_mod
             and o.ppsuc = pn_suc
             and o.ppmda = pn_mda
             and o.pppap = pn_pap
             and o.ppcta = pn_cta
             and o.ppoper = pn_ope
             and o.ppsbop = pn_sbo
             and o.pptope = pn_top
--             and o.ppfpag = pn_fpag
             and o.pp1fech <= pd_fecpro
             and o.pp1stat = 'T'
             and o.d602co = 'S'
             and ((o.pp1cap  + o.pp1int) <> 0);
        exception
          when no_DATA_FOUND THEN
            fechapago := pd_fecha;
        end;
        pd_fechapago := fechapago;

  end SP_DATOS_TRANSGASTO;
end PQ_CR_TRANSFGASTO;
/
