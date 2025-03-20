create or replace package pq_cr_aqpa842 is

  -- Author  : CHERNANDEZ
  -- Created : 17/11/2020 12:35:28
  -- Purpose : 
  -- Author  : DCASTRO
  -- Created : 07/12/2020
  -- Purpose : Se creo nuevos procedimientos para leer tablas de CRM que obtiene tasa de reprogramados por reprogramacion 
  -- dcastro 2020.12.20 se agrego variable lc_rpta sp_cont_mod, sp_cont_top
  
  procedure sp_cont_modI(pn_instancia numeric, pv_rpta out varchar2);
  procedure sp_cont_topI(pn_instancia numeric, pv_rpta out varchar2);
  procedure sp_cont_mod(pn_instancia numeric, pv_rpta out varchar2);
  procedure sp_cont_top(pn_instancia numeric, pv_rpta out varchar2);

end pq_cr_aqpa842;
/

create or replace package body pq_cr_aqpa842 is

  procedure sp_cont_modI(pn_instancia numeric, pv_rpta out varchar2) is
    cursor creditos(lln_cuenta numeric) is
      select *
        from aqpa842 a
       where a.aqpa842cta = lln_cuenta
      /*and exists (select *
       from fsd010 b
      where b.pgcod = a.aqpa842emp
        and b.aomod = a.aqpa842mod
        --and b.aosuc = a.aqpa842suc
        and b.aomda = a.aqpa842mda
        and b.aopap = a.aqpa842pap
        and b.aocta = a.aqpa842cta
        and b.aooper = a.aqpa842ope
        --and b.aosbop = a.aqpa842sbo
        and b.aotope = a.aqpa842top
        and b.aostat <> 99)*/
      ;
  
    ln_cuenta numeric(9);
    ln_cont   numeric(5);
  begin
    begin
      select sng001cta
        into ln_cuenta
        from sng001 a
       where a.sng001inst = pn_instancia;
      ln_cont := 0;
      for i in creditos(ln_cuenta) loop
        if i.aqpa842mod <> 116 then
          if ln_cont = 0 then
            pv_rpta := pv_rpta || Trim(to_char(i.aqpa842mod));
            ln_cont := 1;
          else
            pv_rpta := pv_rpta || ';' || Trim(to_char(i.aqpa842mod));
          end if;
        end if;
      end loop;
    exception
      when others then
        pv_rpta := '';
    end;
  end sp_cont_modI;

  procedure sp_cont_topI(pn_instancia numeric, pv_rpta out varchar2) is
    cursor creditos(lln_cuenta numeric) is
      select *
        from aqpa842 a
       where a.aqpa842cta = lln_cuenta
      /*and exists (select *
       from fsd010 b
      where b.pgcod = a.aqpa842emp
        and b.aomod = a.aqpa842mod
        --and b.aosuc = a.aqpa842suc
        and b.aomda = a.aqpa842mda
        and b.aopap = a.aqpa842pap
        and b.aocta = a.aqpa842cta
        and b.aooper = a.aqpa842ope
        --and b.aosbop = a.aqpa842sbo
        and b.aotope = a.aqpa842top
        and b.aostat <> 99)*/
      ;
  
    ln_cuenta numeric(9);
    ln_cont   numeric(5);
  begin
    begin
      select sng001cta
        into ln_cuenta
        from sng001 a
       where a.sng001inst = pn_instancia;
      ln_cont := 0;
      for i in creditos(ln_cuenta) loop
        if i.aqpa842mod <> 116 then
          if ln_cont = 0 then
            pv_rpta := pv_rpta || Trim(to_char(i.aqpa842top));
            ln_cont := 1;
          else
            pv_rpta := pv_rpta || ';' || Trim(to_char(i.aqpa842top));
          end if;
        end if;
      end loop;
    exception
      when others then
        pv_rpta := '';
    end;
  end sp_cont_topI;

  procedure sp_cont_mod(pn_instancia numeric, pv_rpta out varchar2) is
  --dcastro 2020.12.20 se agrego variable lc_rpta.
    
  cursor creditos(lln_cuenta numeric) is
     SELECT
       F.MODULO aqpa842mod
    FROM LEY31050 L
    INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
    WHERE L.ESTADOSOLICITUD = 'BT' 
        AND L.TIPOFACILIDAD = 'CAJA'
        AND F.FACILIDAD like 'Exoneraci%'
        AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = lln_cuenta;
  
    ln_cuenta numeric(9);
    ln_cont   numeric(5);
    lc_rpta   varchar2(100);
  begin
    begin
      select sng001cta
        into ln_cuenta
        from sng001 a
       where a.sng001inst = pn_instancia;
      ln_cont := 0;
      
       
      for i in creditos(ln_cuenta) loop
        if i.aqpa842mod <> 116 then
          if ln_cont = 0 then
            pv_rpta := pv_rpta || Trim(to_char(i.aqpa842mod));
            ln_cont := 1;
          else
            pv_rpta := pv_rpta || ';' || Trim(to_char(i.aqpa842mod));
          end if;
        else
           begin          
            select f.tp1nro1
              into lc_rpta-- modulo
             from fst198 f 
            where f.tp1cod = 1 
              and f.tp1cod1 = 11145
              and f.tp1corr1 =  5
              and f.tp1corr2 =  1
              and f.tp1corr3 =  1;
           exception when others then
             null;
           end;   
           if ln_cont = 0 then
              pv_rpta := pv_rpta || Trim(to_char(lc_rpta));
              ln_cont := 1;
           else           
              pv_rpta := pv_rpta || ';' || Trim(to_char(lc_rpta)); 
           end if;
        end if;
      end loop;
    exception
      when others then
        pv_rpta := '';
    end;
  end sp_cont_mod;

  procedure sp_cont_top(pn_instancia numeric, pv_rpta out varchar2) is
    cursor creditos(lln_cuenta numeric) is
  --dcastro 2020.12.20 se agrego variable lc_rpta.  
    
    
     SELECT
     F.MODULO aqpa842mod,
     F.TIPOOPERACION aqpa842top   
     FROM LEY31050 L
    INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
    WHERE L.ESTADOSOLICITUD = 'BT' 
        AND L.TIPOFACILIDAD = 'CAJA'
        AND F.FACILIDAD like 'Exoneraci%'
        AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = lln_cuenta;
  
    ln_cuenta numeric(9);
    ln_cont   numeric(5);
    lc_rpta   varchar2(100);
    
  begin
    begin
      select sng001cta
        into ln_cuenta
        from sng001 a
       where a.sng001inst = pn_instancia;
      ln_cont := 0;
        for i in creditos(ln_cuenta) loop
        if i.aqpa842mod <> 116 then
          if ln_cont = 0 then
            pv_rpta := pv_rpta || Trim(to_char(i.aqpa842top));
            ln_cont := 1;
          else
            pv_rpta := pv_rpta || ';' || Trim(to_char(i.aqpa842top));
            end if;
        else
          
           begin          
            select f.tp1nro1
              into lc_rpta-- tipooperacion
             from fst198 f 
            where f.tp1cod = 1 
              and f.tp1cod1 = 11145
              and f.tp1corr1 =  6
              and f.tp1corr2 =  1
              and f.tp1corr3 =  1;
           exception when others then
             null;
           end;   
           
           if ln_cont = 0 then
              pv_rpta := pv_rpta || Trim(to_char(lc_rpta));
              ln_cont := 1;
           else           
              pv_rpta := pv_rpta || ';' || Trim(to_char(lc_rpta)); 
           end if;

        end if;
      end loop;
    exception
      when others then
        pv_rpta := '';
    end;
  end sp_cont_top;

end pq_cr_aqpa842;
/

