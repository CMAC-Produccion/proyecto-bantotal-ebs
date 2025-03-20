create or replace package PQ_CR_RCC_Resolutor is

  -- Author  : HSUAREZ
  -- Created : 05/10/2020 10:42:13 a. m.
  -- Purpose : 

  -- Public type declarations

  procedure sp_cr_maximo_monto(ln_Instancia      in number,
                               ve_DeudaRCCMaxima out number);
                               --ve_FechaRCCMaxima out date);
  -------------------------------------------------------
  function fn_equivalenviaDoc(p_tdoc in number) return varchar2;
  -------------------------------------------------------
end PQ_CR_RCC_Resolutor;
/

create or replace package body PQ_CR_RCC_Resolutor is

  -----------------------------------------------------
   procedure sp_cr_maximo_monto(ln_Instancia      in number,
                                 ve_DeudaRCCMaxima out number) is
                                 --ve_FechaRCCMaxima out date) is
  
    cursor Lista_CredRCC(ln_CodSBS varchar2, ld_FchRCCDesemb date) is
    
      select s.n_salcap ln_DeudaRCCAct, s.c_cuenta ln_RubroRCC
        from cldrccs s
       where s.c_codsbs = ln_CodSBS
         and s.d_fecpre = ld_FchRCCDesemb;
  
    ln_pais         number;
    ln_tdoc         number;
    lc_ndoc         varchar2(12);
    ld_FchRCCDesemb date;
    ln_CodSBS       varchar2(10);
    lc_subcuenta    varchar2(10);
    lc_subcuenta2   varchar2(10);
    lc_subcuenta3   varchar2(10);
    lc_subcuenta4   varchar2(10);
    ld_FchRCC       date;
    ln_DeudaRCCAct  number(17,2);
    ve_FechaRCCMaxima date;
    vi_meses        number;
    vi_tdoc         number;
  begin
  
    ln_DeudaRCCAct := 0;
    vi_meses := 12;
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
    --ld_FchRCC:= to_date('31/07/2020','DD/MM/YYYY');
    if ln_tdoc <> 9 then
      vi_tdoc := pq_cr_rcc_resolutor.fn_equivalenviaDoc(ln_tdoc);
      begin
        select c.c_codsbs
          into ln_CodSBS
          from cldrcci c
         where c.c_docide = trim(lc_ndoc)
           and c.c_tdocid = vi_tdoc
           and c.d_fecpre = ld_FchRCC;
      exception
        when others then
          null;
      end;
    
    else
      if ln_tdoc = 9 then
        begin
          select c.c_codsbs
            into ln_CodSBS
            from cldrcci c
           where c.c_doctri = trim(lc_ndoc)
             and c.d_fecpre = ld_FchRCC;
        exception
          when others then
            null;
        end;
      
      end if;
    
    end if;
    
    --comentario
    ve_DeudaRCCMaxima := 0;
    begin
      --GUIA ESPECIAL DE PROCESO PARA DETERMINAR LA CANTIDAD DE MESES
      select tp1imp1
        into vi_meses
        from fst198 t
       where t.tp1cod1 = 11127
         and tp1corr1 = 7
         and tp1corr2 = 1
         and tp1corr3 = 1;
    end;
    --codigo propio
    if ln_CodSBS is not null then
    for i IN 0..vi_meses LOOP --PARA RECCORRE LOS ULTIMOS X MESES
      --dbms_output.put_line('ANTES:'||ld_FchRCC);
      SELECT ADD_MONTHS(ld_FchRCC,-1)
      INTO ld_FchRCC
      FROM DUAL;
      --dbms_output.put_line('DESPUES:'||ld_FchRCC);
      for l in Lista_CredRCC(ln_CodSBS, ld_FchRCC) loop
      
        lc_subcuenta  := SUBSTR(l.ln_rubrorcc, 1, 4);
        lc_subcuenta2 := SUBSTR(l.ln_rubrorcc, 1, 6);
        lc_subcuenta3 := SUBSTR(l.ln_rubrorcc, 7, 2);
        lc_subcuenta4 := SUBSTR(l.ln_rubrorcc, 5, 2);
        If ((lc_subcuenta = '1411') Or (lc_subcuenta = '1413') Or
            (lc_subcuenta = '1414') Or (lc_subcuenta = '1415') Or
            (lc_subcuenta = '1416') Or (lc_subcuenta = '1421') Or
            (lc_subcuenta = '1423') Or (lc_subcuenta = '1424') Or
            (lc_subcuenta = '1425') Or (lc_subcuenta = '1426') Or
            (lc_subcuenta = '8113') Or (lc_subcuenta = '8123') Or
            (lc_subcuenta = '7112') Or (lc_subcuenta = '7122') OR
            (lc_subcuenta2 = '811302') Or (lc_subcuenta2 = '812302')) AND lc_subcuenta4<>'03' then
        
          ln_DeudaRCCAct := ln_DeudaRCCAct + l.ln_DeudaRCCAct;        
        end if;
      end loop;    
      ln_DeudaRCCAct := nvl(ln_DeudaRCCAct, 0);
      --dbms_output.put_line('DESPUES:'||ln_DeudaRCCAct);
      if ve_DeudaRCCMaxima<ln_DeudaRCCAct then
        ve_DeudaRCCMaxima :=ln_DeudaRCCAct;
        ve_FechaRCCMaxima :=ld_FchRCC;
         --dbms_output.put_line('ve_DeudaRCCMaxima:'||ve_DeudaRCCMaxima);
         --dbms_output.put_line('ve_FechaRCCMaxima:'||ve_FechaRCCMaxima);
      end if;
      ln_DeudaRCCAct:=0;
    END LOOP; -- FONfin del recorrido de consulta
    ELSE
      ln_DeudaRCCAct := 0;
    END IF;
  
  end sp_cr_maximo_monto;
  -------------------------------------------------------
  function fn_equivalenviaDoc(p_tdoc in number) return varchar2 is
    cursor datos is
      select tp1nro2
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11111
         and tp1corr1 = 1
         and tp1corr2 = 5
         and tp1nro1 = p_tdoc;
    resp  number(5);
    respc varchar2(1);
  begin
    resp := 1;
    for i in datos loop
      resp := i.tp1nro2;
    end loop;
    respc := to_char(resp);
    return respc;
  end fn_equivalenviaDoc; 
  -------------------------------------------------------
end PQ_CR_RCC_Resolutor;
/

