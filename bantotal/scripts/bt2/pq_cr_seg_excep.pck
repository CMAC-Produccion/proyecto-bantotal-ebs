create or replace package PQ_CR_SEG_EXCEP is

  -- Author  : MCANDIA
  -- Created : 19/02/2018 01:32:23 p.m.
  -- Purpose : 

  -- Public type declarations
  Procedure SP_CR_EXCEPCIONES_SEG(Instancia in number,
                                  usuario   in varchar2,
                                  seg_final in varchar2);
  /*
    Procedure SP_CR_CALCULA_MAYOR_SEG(Instancia in number,
                                      segmento  out varchar2);
  */

  Procedure SP_CR_SEGMENTACION(Instancia    in number,
                               segmento     in number,
                               segmentacion out varchar2);
                               
  Procedure SP_CR_SEGMENTACION(Instancia    in number,
                               modulo       in number,
                               segmento     in number,
                               segmentacion out varchar2);

  Procedure SP_CR_VARIABLES_PAE(Instancia in number,
                                item_var  in number,
                                valor     out varchar2);

end PQ_CR_SEG_EXCEP;
/

create or replace package body PQ_CR_SEG_EXCEP is

  procedure SP_CR_EXCEPCIONES_SEG(Instancia number,
                                  usuario   varchar2,
                                  seg_final varchar2) is
  
    lc_flag        char(1);
    lc_flag_existe char(1);
    lc_tip_seg     varchar2(50);
    ld_fecha       date;
    lc_hora        char(8);
    lc_usuario     varchar2(50);
    ln_corr        number := 0;
    fl_cambio      number := 0;
    l_item         number := 0;
  
    cursor Instancia_vuelo is
      select wfitemstsact from wfwrkitems where wfinsprcid = Instancia; --3114156; -- wfitemstsact = 1
  
  begin
    
    --apachecoh 2022.09.13 Flag de cambio de segmentacion nueva
    begin
        select tp1nro1 into fl_cambio from fst198
               where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                 and tp1corr2 = 1 and tp1corr3 = 1;
    exception when others then
         fl_cambio := 0;                                            
    end;  
    if fl_cambio = 1 then
         l_item := 3;      
    else
         l_item := 2;
    end if;
    --apachecoh 2022.09.13 Flag de cambio de segmentacion nueva  
    
    begin
    
      SELECT to_date(SysDate) fecha,
             user,
             TO_CHAR(SysDate, 'HH24:MI:SS') hora
        INTO ld_fecha, lc_usuario, lc_hora
        FROM dual;
    exception
      when no_data_found then
        ld_fecha   := null;
        lc_usuario := null;
        lc_hora    := null;
      
        dbms_output.put_line('[' || ld_fecha || ']');
    end;
  
    for i in Instancia_vuelo loop
    
      if i.wfitemstsact = 1 then
        lc_flag := 'S';
        exit;
      else
        lc_flag := 'N';
      end if;
    
    end loop;
  
    if lc_flag = 'S' then    
      begin
        select substr(v.pae71val, 1, instr(v.pae71val, ':') - 1)
          into lc_tip_seg
          from fpae70 n, fpae71 v
         where n.pae70nro = v.pae70nro
           and v.pae71ite = (select tp1nro1 from fst198
                                        where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                                          and tp1corr2 = 1 and tp1corr3 = l_item)  --apachecoh 2022.09.12 Cambio de segmentacion mype
           and n.pae51eva = v.pae51eva
           and v.pae51eva = 1
           and n.pae70nro =
               (select max(pae70nro) from fpae70 where pae70ins = Instancia); --3114156);
      exception
        when no_data_found then
          lc_tip_seg := null;
      end;
    
      begin
        select 'S'
          into lc_flag_existe
          from jaqz870 a
         where a.jaqz870inst = Instancia
           and a.jaqz870esta = 'S';
      exception
        when no_data_found then
          lc_flag_existe := 'N';
      end;
    
      if lc_flag_existe = 'S' then
        UPDATE jaqz870 a
           SET a.jaqz870esta = 'N'
         WHERE a.jaqz870inst = Instancia
           and a.jaqz870esta = 'S';
        commit;
      end if;
    
      begin
        select max(a.jaqz870corr)
          into ln_corr
          from jaqz870 a
         where a.jaqz870fecp = ld_fecha
         ORDER BY a.jaqz870corr DESC;
      exception
        when others then
          ln_corr := 0;
      end;
    
      if ln_corr is null then
        ln_corr := 1;
      else
        ln_corr := ln_corr + 1;
      end if;
    
      insert into jaqz870
        (jaqz870corr,
         jaqz870fecp,
         JAQZ870HORP,
         jaqz870inst,
         jaqz870usep,
         jaqz870user,
         jaqz870segi,
         jaqz870segf,
         jaqz870tipc,
         jaqz870esta)
      values
        (ln_corr,
         ld_fecha,
         lc_hora,
         Instancia,
         lc_usuario,
         usuario,
         lc_tip_seg,
         seg_final,
         'PYME',
         'S');
      commit;
    end if;
  
  end SP_CR_EXCEPCIONES_SEG;
  
  --Deprecado --apachecoh 2022.09.13
  Procedure SP_CR_SEGMENTACION(Instancia    in number,
                               segmento     in number,
                               segmentacion out varchar2) is
  
    flag varchar2(1) := 'N';
    fl_cambio number := 0;
    l_item number := 0;
  
  begin
  
    begin
      select j.jaqz870segf, 'S'
        into segmentacion, flag
        from jaqz870 j
       where j.jaqz870inst = Instancia
         and j.jaqz870esta = 'S';
    exception
      when no_data_found then
        segmentacion := ' ';
        Flag         := 'N';
    end;
    --apachecoh 2022.09.13 Flag de cambio de segmentacion nueva
    begin
        select tp1nro1 into fl_cambio from fst198
               where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                 and tp1corr2 = 1 and tp1corr3 = 1;
    exception when others then
         fl_cambio := 0;                                            
    end;  
    if fl_cambio = 1 then
         l_item := 3;      
    else
         l_item := 2;
    end if;
    --apachecoh 2022.09.13 Flag de cambio de segmentacion nueva  
    
    if flag = 'N' then
      if segmento = 1 then
        begin
          select substr(p.pae71val, 1, instr(p.pae71val, ':') - 1)
            into segmentacion
            from fpae70 r, fpae71 p
           where r.pae51eva = p.pae51eva
             and r.pae70nro = p.pae70nro
             and r.pae70ins = Instancia
             and p.pae71ite = (select tp1nro1 from fst198
                                        where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                                          and tp1corr2 = 1 and tp1corr3 = l_item)  --apachecoh 2022.09.12 mype
             and r.pae51eva = 1
             and r.pae70nro = (select max(d.pae70nro)
                                 from fpae70 d
                                where d.pae70ins = Instancia
                                  and d.pae51eva = 1);
        exception
          when no_data_found then
            segmentacion := 'NO DEFINIDO';
        end;
      else
        begin
          select  trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(p.pae71val,
                                                                '[0-9]',
                                                                '')),
                                                ':',
                                                '')),
                                       '/',
                                       '')),
                              '.',
                              '')) --substr(p.pae71val, 1, instr(p.pae71val, ':') - 1)
            into segmentacion
            from fpae70 r, fpae71 p
           where r.pae51eva = p.pae51eva
             and r.pae70nro = p.pae70nro
             and r.pae70ins = Instancia
             and p.pae71ite = (select tp1nro1 from fst198
                                        where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                                          and tp1corr2 = 1 and tp1corr3 = 5) --apachecoh 2022.09.12 consumo
             and r.pae51eva = 1
             and r.pae70nro = (select max(d.pae70nro)
                                 from fpae70 d
                                where d.pae70ins = Instancia
                                  and d.pae51eva = 1);
        exception
          when no_data_found then
            segmentacion := 'NO DEFINIDO';
        end;
      end if;
    end if;
  end;
  --
  Procedure SP_CR_SEGMENTACION(Instancia    in number,
                               modulo       in number,
                               segmento     in number,
                               segmentacion out varchar2) is
  
    flag varchar2(1) := 'N';
    fl_cambio number := 0;
    fl_modul number := 0;
    l_item number := 0;
  begin
  
    begin
      select j.jaqz870segf, 'S'
        into segmentacion, flag
        from jaqz870 j
       where j.jaqz870inst = Instancia
         and j.jaqz870esta = 'S';
    exception
      when no_data_found then
        segmentacion := ' ';
        Flag         := 'N';
    end;
    --apachecoh 2022.09.13 Flag de cambio de segmentacion nueva
    /*begin
        select tp1nro1 into fl_cambio from fst198
               where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                 and tp1corr2 = 1 and tp1corr3 = 1;
    exception when others then
         fl_cambio := 0;                                            
    end;*/   
    begin
        select count(*) into fl_modul from fst198
               where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                 and tp1corr2 = 2 and tp1corr3 > 0
                 and tp1nro1 = modulo;
    exception when others then
         fl_modul := 0;                                            
    end; 
    if fl_modul = 1 then
         l_item := 3;      
    else
         l_item := 2;
    end if;
    --apachecoh 2022.09.13 Flag de cambio de segmentacion nueva  
        
    if flag = 'N' then
      if segmento = 1 then
        --apachecoh 2022.06.06 Adicion de Segmentacion Micro
        if modulo = 103 then
          begin
            select p.pae71val
              into segmentacion
              from fpae70 r, fpae71 p
             where r.pae51eva = p.pae51eva
               and r.pae70nro = p.pae70nro
               and r.pae70ins = Instancia
               and p.pae71ite = (select tp1nro1 from fst198
                                        where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                                          and tp1corr2 = 1 and tp1corr3 = 4) --apachecoh 2022.09.12 micro
               and r.pae51eva = 1
               and r.pae70nro = (select max(d.pae70nro)
                                   from fpae70 d
                                  where d.pae70ins = Instancia
                                    and d.pae51eva = 1);
          exception
            when no_data_found then
              segmentacion := 'NO DEFINIDO';
          end;
        else
          begin
            select substr(p.pae71val, 1, instr(p.pae71val, ':') - 1)
              into segmentacion
              from fpae70 r, fpae71 p
             where r.pae51eva = p.pae51eva
               and r.pae70nro = p.pae70nro
               and r.pae70ins = Instancia
               and p.pae71ite = (select tp1nro1 from fst198
                                        where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                                          and tp1corr2 = 1 and tp1corr3 = l_item)  --apachecoh 2022.09.12 mype
               and r.pae51eva = 1
               and r.pae70nro = (select max(d.pae70nro)
                                   from fpae70 d
                                  where d.pae70ins = Instancia
                                    and d.pae51eva = 1);
          exception
            when no_data_found then
              segmentacion := 'NO DEFINIDO';
          end;
        end if;
      else
        begin
          select  trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(p.pae71val,
                                                                '[0-9]',
                                                                '')),
                                                ':',
                                                '')),
                                       '/',
                                       '')),
                              '.',
                              '')) --substr(p.pae71val, 1, instr(p.pae71val, ':') - 1)
            into segmentacion
            from fpae70 r, fpae71 p
           where r.pae51eva = p.pae51eva
             and r.pae70nro = p.pae70nro
             and r.pae70ins = Instancia
             and p.pae71ite = (select tp1nro1 from fst198
                                        where tp1cod = 1 and tp1cod1 = 10823 and tp1corr1 = 55 
                                          and tp1corr2 = 1 and tp1corr3 = 5) --apachecoh 2022.09.12 consumo
             and r.pae51eva = 1
             and r.pae70nro = (select max(d.pae70nro)
                                 from fpae70 d
                                where d.pae70ins = Instancia
                                  and d.pae51eva = 1);
        exception
          when no_data_found then
            segmentacion := 'NO DEFINIDO';
        end;
      end if;
    end if;
  end;
  
  Procedure SP_CR_VARIABLES_PAE(Instancia in number,
                                item_var  in number,
                                valor     out varchar2) is
  
  begin
  
    select pae71val
      into valor
      from fpae70 r, fpae71 p
     where r.pae51eva = p.pae51eva
       and r.pae70nro = p.pae70nro
       and r.pae70ins = Instancia
       and p.pae71ite = item_var
       and r.pae51eva = 1
       and r.pae70nro = (select max(d.pae70nro)
                           from fpae70 d
                          where d.pae70ins = Instancia
                            and d.pae51eva = 1);
  exception
    when no_data_found then
      valor := null;
  end;

end PQ_CR_SEG_EXCEP;
/

