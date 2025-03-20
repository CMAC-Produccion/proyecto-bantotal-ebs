create or replace package PQ_SEGMENTA_AGENCIAS is

  -- Author  : MARAUJO
  -- Created : 06/04/2015 10:54:51 a.m.
  -- Purpose : Nueva segmentación de agencias

  procedure Inicio(pd_fecpro date);

  procedure Datos_Iniciales_Job(pd_fecpro date, pn_cambio number);

  procedure Datos_Iniciales_Det(vpgcod    number,
                                pn_sucur  number,
                                pc_fecpro varchar2,
                                pc_cambio varchar2);

  procedure Clientes_Job(pd_fecpro date, pn_cambio number);

  procedure Clientes_Det(vpgcod    number,
                         TDcd      number,
                         TDch      number,
                         TNcd      varchar2,
                         TNch      varchar2,
                         pc_fecpro varchar2,
                         pc_cambio varchar2);

  procedure Intermediacion(pd_fecpro date);

  procedure Participacion(pd_fecpro date);

  procedure Productividad(pd_fecpro date);

  procedure Clientes(pd_fecpro date);

  procedure Final(pd_fecpro date);

  function fn_mg_verifica_tarea(pi_vc2_nomjob IN VARCHAR2,
                                pi_vc2_nomusr IN VARCHAR2) RETURN NUMBER;

end PQ_SEGMENTA_AGENCIAS;
/

create or replace package body PQ_SEGMENTA_AGENCIAS is

  procedure Inicio(pd_fecpro date) is
    tipo_cambio number;
  
  begin
    tipo_cambio := fn_tipo_cambio(pd_fecpro, 101, 0, 0);
  
    delete from jaql710 where jaql710fepr = pd_fecpro;
    commit;
  
    execute immediate 'truncate table temp_clie';
  
    Datos_Iniciales_Job(pd_fecpro, tipo_cambio);
    Clientes_Job(pd_fecpro, tipo_cambio);
  
    Intermediacion(pd_fecpro);
    Participacion(pd_fecpro);
    Productividad(pd_fecpro);
    Clientes(pd_fecpro);
    Final(pd_fecpro);
  end;
  -----------------------------------------------------------
  procedure Datos_Iniciales_Job(pd_fecpro date, pn_cambio number) is
  
    lc_variable   varchar2(4000);
    hoyC          char(8);
    TcbioC        varchar2(15);
    NUM_JOB_FIN   NUMBER(10);
    pi_vc2_nomjob VARCHAR2(65);
  
    identi varchar2(50) := 'DA' || to_char(sysdate, 'rrrrmmdd_hh24miss');
    numage number;
  
    cursor age is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800;
  
    vagencia fst001.sucurs%type;
    vpgcod   number := 1;
  
  begin
  
    for i in age loop
      vagencia := i.sucurs;
    
      hoyC          := to_char(pd_fecpro, 'ddmmyyyy');
      TcbioC        := replace(to_char(pn_cambio), ',', '.');
      pi_vc2_nomjob := identi || '_' || trim(to_char(vagencia));
    
      lc_variable := ' begin ' ||
                     ' pq_segmenta_agencias.Datos_Iniciales_Det(' || vpgcod || ',' ||
                     vagencia || ',' || '''' || hoyC || '''' || ',' || '''' ||
                     tcbioC || '''' || ');' || ' End; ';
    
      dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                job_type   => 'PLSQL_BLOCK',
                                job_action => lc_variable,
                                start_date => sysdate, -- + 1 / (24 * 180),
                                enabled    => true,
                                auto_drop  => TRUE,
                                comments   => 'Datos agencia');
    
      commit;
    
    end loop;
  
    select count(1)
      into numage
      from fst001
     where pgcod = 1
       and sucurs < 800;
  
    NUM_JOB_FIN := FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => identi,
                                        pi_vc2_nomusr => USER);
  
    WHILE NUM_JOB_FIN < numage LOOP
    
      NUM_JOB_FIN := FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => identi,
                                          pi_vc2_nomusr => USER);
    end loop;
  
  end;

  -----------------------------------------------------------

  procedure Datos_Iniciales_Det(vpgcod    number,
                                pn_sucur  number,
                                pc_fecpro varchar2,
                                pc_cambio varchar2) is
  
    coloca   number;
    capta    number;
    personal number;
    clientes number;
  
    pd_fecpro date;
    pn_cambio number;
  
  begin
  
    pd_fecpro := to_date(pc_fecpro, 'ddmmyyyy');
    pn_cambio := to_number(pc_cambio, '999999999.999990');
  
    begin
      select sum(decode(a.aomda, 0, a.aoimp, pn_cambio * a.aoimp))
        into coloca
        from fsd010 a, fst111 b
       where a.pgcod = vpgcod
         and b.dscod = 50
         and a.aomod = b.modulo
         and a.aostat <> 99
         and a.aofval <= pd_fecpro
         and a.aosuc = pn_sucur;
    exception
      when no_data_found then
        coloca := 0;
    end;
  
    begin
      select sum(decode(a.scmda, 0, a.scsdo, pn_cambio * a.scsdo))
        into capta
        from fsd011 a, fst111 b
       where a.pgcod = vpgcod
         and b.dscod in (2, 3)
         and a.scmod = b.modulo
         and a.scstat <> 99
         and a.scfval <= pd_fecpro
         and a.scsuc = pn_sucur;
    exception
      when no_data_found then
        capta := 0;
    end;
  
    begin
      select count(distinct u.ubuser)
        into personal
        from prfu00 p, fst046 u, fst198 g
       where p.pgcod = vpgcod
         and u.pgcod = vpgcod
         and p.ubuser = u.ubuser
         and g.tp1cod = vpgcod
         and g.tp1cod1 = 10819
         and g.tp1corr1 = 15
         and g.tp1corr2 = 1
         and p.prfgcod = g.tp1desc
         and trim(p.prfgcod) = trim(g.tp1desc)
         and u.ubsuc = pn_sucur;
    exception
      when no_data_found then
        personal := 0;
    end;
  
    /*    begin
      select count(*)
        into clientes
        from (select distinct c.pendoc
                from fsd011 a, fst111 b, fsr008 c
               where a.pgcod = 1
                 and b.dscod in (2, 3)
                 and a.scmod = b.modulo
                 and a.scstat <> 99
                 and a.scfval <= pd_fecpro
                 and c.pgcod = 1
                 and a.sccta = c.ctnro
                 and c.ttcod = 1
                 and c.cttfir = 'T'
                 and a.scsuc = pn_sucur);
    exception
      when no_data_found then
        clientes := 0;
    end;*/
  
    insert into jaql710
      (JAQL710SUCU,
       JAQL710FEPR,
       JAQL710COLO,
       JAQL710CAPT,
       JAQL710PECA,
       JAQL710NUCL,
       JAQL710AU01,
       JAQL710AU07)
    values
      (pn_sucur,
       pd_fecpro,
       nvl(coloca, 0),
       nvl(capta, 0),
       nvl(personal, 0),
       0,
       clientes,
       to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss'));
  
    commit;
  
  end;

  -----------------------------------------------------------
  procedure Clientes_Job(pd_fecpro date, pn_cambio number) is
  
    lc_variable   varchar2(4000);
    hoyC          char(8);
    TcbioC        varchar2(15);
    NUM_JOB_FIN   NUMBER(10);
    pi_vc2_nomjob VARCHAR2(65);
  
    identi varchar2(25) := 'CA_' || to_char(sysdate, 'rrrrmmdd_hh24miss');
  
    cursor doc is
      select * from fsr101 where pbnsec = 601;
  
    numhilos number;
  
    TNcd varchar2(8);
    TNch varchar2(8);
  
    vpgcod number := 1;
  
  begin
  
    insert into temp_clie
      (n_monto1, n_monto2, c_descri)
      select distinct c.pepais, c.petdoc, c.pendoc
        from fsd011 a, fst111 b, fsr008 c
       where a.pgcod = 1
         and b.dscod in (2, 3)
         and a.scmod = b.modulo
         and a.scstat <> 99
         and a.scfval <= pd_fecpro
         and c.pgcod = 1
         and c.ctnro = a.sccta
         and c.ttcod = 1
         and c.cttfir = 'T';
  
    commit;
  
    for i in doc loop
    
      If i.pbd1 = 21 then
        if i.pbd2 = 0 then
          TNcd := lpad(i.pbd2, 8, '0');
        else
          TNcd := lpad(i.pbd2 - 1, 8, '0');
        end if;
      
        if i.pbh2 = 99999999 then
          TNch := lpad(i.pbh2, 8, '0');
        else
          TNch := lpad(i.pbh2 + 1, 8, '0');
        end if;
      
      else
        TNcd := '0';
        TNch := '0';
      End If;
    
      hoyC          := to_char(pd_fecpro, 'ddmmyyyy');
      TcbioC        := replace(to_char(pn_cambio), ',', '.');
      pi_vc2_nomjob := identi || '_' || trim(to_char(i.pbd1)) || '_' ||
                       trim(TNcd);
    
      lc_variable := ' begin ' || ' pq_segmenta_agencias.clientes_det(' ||
                     vpgcod || ',' || i.pbd1 || ',' || i.pbh1 || ',' || '''' || tncd || '''' || ',' || '''' || tnch || '''' || ',' || '''' || hoyC || '''' || ',' || '''' ||
                     tcbioC || '''' || ');' || ' End; ';
    
      dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                job_type   => 'PLSQL_BLOCK',
                                job_action => lc_variable,
                                start_date => sysdate, -- + 1 / (24 * 180),
                                enabled    => true,
                                auto_drop  => TRUE,
                                comments   => 'Clientes por agencia');
    
      commit;
    
    end loop;
  
    select count(1) into numhilos from fsr101 where pbnsec = 601;
  
    NUM_JOB_FIN := FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => identi,
                                        pi_vc2_nomusr => USER);
  
    WHILE NUM_JOB_FIN < numhilos LOOP
    
      NUM_JOB_FIN := FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => identi,
                                          pi_vc2_nomusr => USER);
    end loop;
  end;

  -----------------------------------------------------------  
  procedure Clientes_Det(vpgcod    number,
                         TDcd      number,
                         TDch      number,
                         TNcd      varchar2,
                         TNch      varchar2,
                         pc_fecpro varchar2,
                         pc_cambio varchar2) is
  
    cursor clientes is
      select n_monto1 pais, n_monto2 tipdoc, c_descri numdoc
        from temp_clie
       where n_monto1 >= 1
         and n_monto1 <= 999
         and n_monto2 >= TDcd
         and n_monto2 <= TDch
         and c_descri >= decode(TNcd, '0', c_descri, TNcd)
         and c_descri <= decode(TNch, '0', c_descri, TNch);
  
    pd_fecpro date;
    pn_cambio number;
  
    vpendoc fsr008.pendoc%type;
  
    vsucur fst001.sucurs%type;
  
  begin
  
    pd_fecpro := to_date(pc_fecpro, 'ddmmyyyy');
    pn_cambio := to_number(pc_cambio, '999999999.999990');
  
    for i in clientes loop
    
      vpendoc := i.numdoc;
    
      select scsuc
        into vsucur
        from (select a.scsuc,
                     decode(a.scmda, 0, a.scsdo, pn_cambio * a.scsdo) monto
                from fsd011 a, fst111 b, fsr008 c
               where a.pgcod = vpgcod
                 and b.dscod in (2, 3)
                 and a.scmod = b.modulo
                 and a.scstat <> 99
                 and a.scfval <= pd_fecpro
                 and c.pgcod = vpgcod
                 and c.ctnro = a.sccta
                 and c.ttcod = 1
                 and c.cttfir = 'T'
                 and c.pepais = i.pais
                 and c.petdoc = i.tipdoc
                 and c.pendoc = vpendoc
               order by 2 desc)
       where rownum = 1;
    
      update jaql710
         set JAQL710NUCL = nvl(JAQL710NUCL, 0) + 1
       where JAQL710SUCU = vsucur;
      commit;
    
    end loop;
  end;

  -----------------------------------------------------------  
  procedure Intermediacion(pd_fecpro date) is
  
    interme number;
    tipo    char(1);
  
    tot_a number;
    tot_b number;
    tot_c number;
    tot_d number;
    tope  number;
  
    cursor inte is
      select * from jaql710 where jaql710fepr = pd_fecpro;
  
  begin
  
    update jaql710
       set jaql710inte = decode(jaql710colo,
                                0,
                                0,
                                (jaql710capt / jaql710colo) * 100)
     where jaql710fepr = pd_fecpro;
  
    select (sum(jaql710capt) / sum(jaql710colo)) * 100
      into interme
      from jaql710
     where jaql710fepr = pd_fecpro;
  
    update fst198
       set tp1imp2 = interme
     where TP1COD = 1
       and tp1cod1 = 10819
       and tp1corr1 = 15
       and tp1corr2 = 2
       and trim(tp1desc) = 'B';
  
    for i in inte loop
    
      tot_a := 0;
      tot_b := 0;
      tot_c := 0;
      tot_d := 0;
    
      If i.jaql710inte > interme then
        tipo := 'A';
        tope := interme;
      Else
        begin
          select trim(tp1desc), tp1imp1
            into tipo, tope
            from fst198
           where TP1COD = 1
             and tp1cod1 = 10819
             and tp1corr1 = 15
             and tp1corr2 = 2
             and i.jaql710inte between tp1imp1 and tp1imp2;
        exception
          when no_data_found then
            tipo := 'D';
        end;
      end if;
    
      case
        when tipo = 'A' then
          tot_a := 1;
        when tipo = 'B' then
          tot_b := 1;
        when tipo = 'C' then
          tot_c := 1;
        else
          tot_d := 1;
      end case;
    
      update jaql710
         set jaql710tiin = tipo,
             jaql710tope = tope,
             jaql710au03 = nvl(jaql710au03, 0) + tot_a,
             jaql710au04 = nvl(jaql710au04, 0) + tot_b,
             jaql710au05 = nvl(jaql710au05, 0) + tot_c,
             jaql710au06 = nvl(jaql710au06, 0) + tot_d
       where jaql710fepr = pd_fecpro
         and jaql710sucu = i.jaql710sucu;
    end loop;
  
    commit;
  
  end;

  -----------------------------------------------------------  
  procedure Participacion(pd_fecpro date) is
  
    sum_cap number;
    tipo    char(1);
    tope    number;
  
    tot_a number;
    tot_b number;
    tot_c number;
    tot_d number;
  
    cursor parti is
      select *
        from jaql710
       where jaql710fepr = pd_fecpro
         and trim(jaql710tipa) is null
       order by jaql710part desc;
  
    suma  number;
    salir char(1);
cont number :=0;  
  begin
  
    select sum(jaql710capt)
      into sum_cap
      from jaql710
     where jaql710fepr = pd_fecpro;
  
    update jaql710
       set jaql710part = decode(sum_cap,
                                0,
                                0,
                                (jaql710capt * 100) / sum_cap)
     where jaql710fepr = pd_fecpro;
  
    tipo := 'A';
  
    select tp1imp1
      into tope
      from fst198
     where TP1COD = 1
       and tp1cod1 = 10819
       and tp1corr1 = 15
       and tp1corr2 = 3
       and trim(tp1desc) = tipo;
  
    salir := 'N';
  
    WHILE salir = 'N' LOOP

cont := cont +1; 
insert into temp_segage
VALUES (sysdate, suma,salir,'DENTRO DEL WHILE',cont);
    
      for i in parti loop
        tot_a := 0;
        tot_b := 0;
        tot_c := 0;
        tot_d := 0;
      
        case
          when tipo = 'A' then
            tot_a := 1;
          when tipo = 'B' then
            tot_b := 1;
          when tipo = 'C' then
            tot_c := 1;
          else
            tot_d := 1;
        end case;
      
        suma := nvl(suma, 0) + i.jaql710part;
      
        If tope = 100 then
        
          update jaql710
             set jaql710paac = suma,
                 jaql710tipa = tipo,
                 jaql710au03 = nvl(jaql710au03, 0) + tot_a,
                 jaql710au04 = nvl(jaql710au04, 0) + tot_b,
                 jaql710au05 = nvl(jaql710au05, 0) + tot_c,
                 jaql710au06 = nvl(jaql710au06, 0) + tot_d
           where jaql710fepr = pd_fecpro
             and jaql710sucu = i.jaql710sucu;
        else
        
          if suma >= tope then
            suma := nvl(suma, 0) - i.jaql710part;
            exit;
          end if;
        
          update jaql710
             set jaql710paac = suma,
                 jaql710tipa = tipo,
                 jaql710au03 = nvl(jaql710au03, 0) + tot_a,
                 jaql710au04 = nvl(jaql710au04, 0) + tot_b,
                 jaql710au05 = nvl(jaql710au05, 0) + tot_c,
                 jaql710au06 = nvl(jaql710au06, 0) + tot_d
           where jaql710fepr = pd_fecpro
             and jaql710sucu = i.jaql710sucu;
        end if;
      
      end loop;
    
      If round(suma, 3) >= 100 then
        salir := 'S';
      else
        begin
          select tp1desc, tp1imp1
            into tipo, tope
            from (select trim(tp1desc) tp1desc, tp1imp1
                    from fst198
                   where TP1COD = 1
                     and tp1cod1 = 10819
                     and tp1corr1 = 15
                     and tp1corr2 = 3
                     and trim(tp1desc) > tipo
                   order by tp1imp1)
           where rownum = 1;
        exception
          when others then
            null;
        end;
      end if;
    
    end loop;
    commit;
  
  end;

  -----------------------------------------------------------  
  procedure Productividad(pd_fecpro date) is
  
    produc number;
    tipo   char(1);
  
    tot_a number;
    tot_b number;
    tot_c number;
    tot_d number;
  
    cursor produ is
      select * from jaql710 where jaql710fepr = pd_fecpro;
  
  begin
  
    update jaql710
       set jaql710prod = decode(jaql710peca,
                                0,
                                0,
                                (jaql710capt / jaql710peca))
     where jaql710fepr = pd_fecpro;
  
    select sum(jaql710capt) / sum(jaql710peca)
      into produc
      from jaql710
     where jaql710fepr = pd_fecpro;
  
    update jaql710
       set jaql710secu = round(decode(produc,
                                      0,
                                      0,
                                      (jaql710prod / produc)) * 100)
     where jaql710fepr = pd_fecpro;
  
    commit;
  
    for i in produ loop
    
      tot_a := 0;
      tot_b := 0;
      tot_c := 0;
      tot_d := 0;
    
      select trim(tp1desc)
        into tipo
        from fst198
       where TP1COD = 1
         and tp1cod1 = 10819
         and tp1corr1 = 15
         and tp1corr2 = 4
         and i.jaql710secu between tp1imp1 and tp1imp2;
    
      case
        when tipo = 'A' then
          tot_a := 1;
        when tipo = 'B' then
          tot_b := 1;
        when tipo = 'C' then
          tot_c := 1;
        else
          tot_d := 1;
      end case;
    
      update jaql710
         set jaql710tipr = tipo,
             jaql710au03 = nvl(jaql710au03, 0) + tot_a,
             jaql710au04 = nvl(jaql710au04, 0) + tot_b,
             jaql710au05 = nvl(jaql710au05, 0) + tot_c,
             jaql710au06 = nvl(jaql710au06, 0) + tot_d
       where jaql710fepr = pd_fecpro
         and jaql710sucu = i.jaql710sucu;
    
    end loop;
    commit;
  
  end;

  -----------------------------------------------------------  
  procedure Clientes(pd_fecpro date) is
  
    sum_cli number;
    tipo    char(1);
    tope    number;
  
    tot_a number;
    tot_b number;
    tot_c number;
    tot_d number;
  
    cursor clie is
      select *
        from jaql710
       where jaql710fepr = pd_fecpro
         and trim(jaql710ticl) is null
       order by jaql710clie desc;
  
    suma  number;
    salir char(1);
  
  begin
  
    select sum(jaql710nucl)
      into sum_cli
      from jaql710
     where jaql710fepr = pd_fecpro;
  
    update jaql710
       set jaql710clie = decode(sum_cli,
                                0,
                                0,
                                (jaql710nucl * 100) / sum_cli)
     where jaql710fepr = pd_fecpro;
  
    tipo := 'A';
  
    select tp1imp1
      into tope
      from fst198
     where TP1COD = 1
       and tp1cod1 = 10819
       and tp1corr1 = 15
       and tp1corr2 = 5
       and trim(tp1desc) = tipo;
  
    salir := 'N';
  
    WHILE salir = 'N' LOOP
    
      for i in clie loop
      
        tot_a := 0;
        tot_b := 0;
        tot_c := 0;
        tot_d := 0;
      
        case
          when tipo = 'A' then
            tot_a := 1;
          when tipo = 'B' then
            tot_b := 1;
          when tipo = 'C' then
            tot_c := 1;
          else
            tot_d := 1;
        end case;
      
        suma := nvl(suma, 0) + i.jaql710clie;
      
        If tope = 100 then
        
          update jaql710
             set jaql710clac = suma,
                 jaql710ticl = tipo,
                 jaql710au03 = nvl(jaql710au03, 0) + tot_a,
                 jaql710au04 = nvl(jaql710au04, 0) + tot_b,
                 jaql710au05 = nvl(jaql710au05, 0) + tot_c,
                 jaql710au06 = nvl(jaql710au06, 0) + tot_d
           where jaql710fepr = pd_fecpro
             and jaql710sucu = i.jaql710sucu;
        else
        
          if suma >= tope then
            suma := nvl(suma, 0) - i.jaql710clie;
            exit;
          end if;
        
          update jaql710
             set jaql710clac = suma,
                 jaql710ticl = tipo,
                 jaql710au03 = nvl(jaql710au03, 0) + tot_a,
                 jaql710au04 = nvl(jaql710au04, 0) + tot_b,
                 jaql710au05 = nvl(jaql710au05, 0) + tot_c,
                 jaql710au06 = nvl(jaql710au06, 0) + tot_d
           where jaql710fepr = pd_fecpro
             and jaql710sucu = i.jaql710sucu;
        end if;
      
      end loop;
    
      If round(suma, 3) >= 100 then
        salir := 'S';
      else
        begin
          select tp1desc, tp1imp1
            into tipo, tope
            from (select trim(tp1desc) tp1desc, tp1imp1
                    from fst198
                   where TP1COD = 1
                     and tp1cod1 = 10819
                     and tp1corr1 = 15
                     and tp1corr2 = 5
                     and trim(tp1desc) > tipo
                   order by tp1imp1)
           where rownum = 1;
        exception
          when others then
            null;
        end;
      end if;
    
    end loop;
    commit;
  
  end;

  -----------------------------------------------------------  
  procedure Final(pd_fecpro date) is
  
    tipo char(1);
  
    cursor fin is
      select * from jaql710 where jaql710fepr = pd_fecpro;
  
  begin
  
    for i in fin loop
    
      begin
      
        select trim(tp1desc)
          into tipo
          from fst198
         where TP1COD = 1
           and tp1cod1 = 10819
           and tp1corr1 = 15
           and tp1corr2 = 6
           and tp1nro1 = i.jaql710au03
           and tp1nro2 = i.jaql710au04
           and tp1nro3 = i.jaql710au05
           and tp1imp1 = i.jaql710au06;
      exception
        when no_data_found then
          tipo := 'X';
      end;
    
      update jaql710
         set jaql710tipo = tipo
       where jaql710fepr = pd_fecpro
         and jaql710sucu = i.jaql710sucu;
    
    end loop;
    commit;
  
  end;

  ------------------------------------------------

  FUNCTION fn_mg_verifica_tarea(pi_vc2_nomjob IN VARCHAR2,
                                pi_vc2_nomusr IN VARCHAR2) RETURN NUMBER IS
  
    num_job NUMBER(10);
  
  BEGIN
  
    SELECT COUNT(1)
      INTO num_job
      FROM DBA_SCHEDULER_JOB_RUN_DETAILS job
--     WHERE owner = pi_vc2_nomusr
     WHERE owner = 'BANTPROD'--HMEV 02.08.2016
       AND job.job_name LIKE pi_vc2_nomjob || '%';
  
    RETURN num_job;
  
  END;

end PQ_SEGMENTA_AGENCIAS;
/

