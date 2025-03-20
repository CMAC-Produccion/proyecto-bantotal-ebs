create or replace package PQ_CR_DEURCC is

  -- Author  : MCANDIA
  -- Created : 26/12/2017 12:24:48 p.m.
  -- Purpose : 

  Procedure sp_cr_RCC(ln_pais    in number,
                      ln_tdoc    in number,
                      ln_ndoc    in char,
                      ln_CantEnt out number);

  Procedure sp_cr_RCC1(pepais     in number,
                       petdoc     in number,
                       pendoc     in char,
                       MesRcc     in number,
                       ln_CantEnt out number);

  Function Fn_cr_RCC2_Prestamo(CodSbs in char, FechActRCC in date)
    return number;

  Function Fn_cr_RCC2_Linea(CodSbs in char, FechActRCC in date) return number;

end PQ_CR_DEURCC;
/

create or replace package body PQ_CR_DEURCC is

  procedure sp_cr_RCC(ln_pais    in number,
                      ln_tdoc    in number,
                      ln_ndoc    in char,
                      ln_CantEnt out number) is
  
    cursor documentos2 is
    
      select distinct (trim(f.pendoc)) ln_ndoc,
                      f.pepais ln_pais,
                      f.petdoc ln_tdoC
        from fsr008 f
       where f.cttfir = 'T'
         and f.petdoc = ln_tdoc
         and f.pendoc = ln_ndoc
         and f.pepais = ln_pais
      
      union
      
      select distinct (trim(g.rpndoc)) ln_ndoc,
                      g.rppais ln_pais,
                      g.rptdoc ln_tdoc
        from fsr002 g
       where g.pepais = ln_pais
         and g.petdoc = ln_tdoc
         and g.pendoc = ln_ndoc
         and g.rpccyg = 66
      
      union
      select distinct (trim(g.pendoc)) ln_ndoc,
                      g.pepais ln_pais,
                      g.petdoc ln_tdoc
        from fsr002 g
       where g.rppais = ln_pais
         and g.rptdoc = ln_tdoc
         and g.rpndoc = ln_ndoc
         and g.rpccyg = 66;
  
    MesRCC        number;
    ln_CantEntAux number := 0;
  
  begin
  
    --Meses a evaluar RCC
    begin
      select tpnro
        into MesRcc
        from fst098
       where pgcod = 1
         and tpcod = 7702
         and tpcorr = 15;
    exception
      when no_data_found then
        MesRcc := null;
    end;
  
    ln_CantEnt := 0;
  
    for i in documentos2 loop   

      PQ_CR_DEURCC.sp_cr_RCC1(i.ln_pais,
                              i.ln_tdoc,
                              i.ln_ndoc,
                              MesRcc,
                              ln_CantEntAux);      
    
    end loop;
  ln_CantEnt := ln_CantEnt + ln_CantEntAux; -- acumulo entidades de titular y conyugue
  end sp_cr_RCC;

  procedure sp_cr_RCC1(pepais     in number,
                       petdoc     in number,
                       pendoc     in char,
                       MesRcc     in number,
                       ln_CantEnt out number) is
  
    ln_i                number;
    CodSbs              char(10);
    ld_FchRCC           date;
    FechActRCC          date;
    lc_tiper            char(1);
    ln_CantEntAux       number := 0;
    ln_CantEntAux_Linea number := 0;
  
  begin
  
    ln_CantEnt := 0;
  
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper
        from fsd001 a
       where a.pepais = pepais
         and a.petdoc = petdoc
         and a.pendoc = pendoc
         and rownum = 1;
    exception
      when no_data_found then
        lc_tiper := null;
    end;
  
    begin
      --fecha Ult. RCC
      select to_date(to_char(Tpnro), 'dd/mm/yyyy')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      ln_i := 1;
      while ln_i <= MesRcc loop
      
        begin
          case
            when lc_tiper = 'F' then
              begin
                select c_CodSbs, a.d_fecpre
                  into CodSbs, FechActRCC
                  from cldrcci a
                 where D_FECPRE = ld_FchRCC
                   and C_TDOCID = petdoc
                   and C_DOCIDE = trim(pendoc)
                   and rownum = 1;
              exception
                when no_data_found then
                  CodSbs     := null;
                  FechActRCC := null;
              end;
              if CodSbs is null then
                begin
                  select c_CodSbs, a.d_fecpre
                    into CodSbs, FechActRCC
                    from cldrcci a
                   where D_FECPRE = ld_FchRCC
                     and C_DOCIDE = trim(pendoc)
                     and rownum = 1;
                exception
                  when no_data_found then
                    CodSbs     := null;
                    FechActRCC := null;
                end;
              end if;
            
            when lc_tiper = 'J' then
              begin
                select c_CodSbs, a.d_fecpre
                  into CodSbs, FechActRCC
                  from cldrcci a
                 where D_FECPRE = ld_FchRCC
                   and C_TDOCTR = petdoc
                   and C_DOCTRI = trim(pendoc)
                   and rownum = 1;
              exception
                when no_data_found then
                  CodSbs     := null;
                  FechActRCC := null;
              end;
            
              if CodSbs is null then
                begin
                  select c_CodSbs, a.d_fecpre
                    into CodSbs, FechActRCC
                    from cldrcci a
                   Where D_FECPRE = ld_FchRCC
                     and C_DOCTRI = trim(pendoc)
                     and rownum = 1;
                exception
                  when no_data_found then
                    CodSbs     := null;
                    FechActRCC := null;
                end;
              
              end if;
            
          end case;
        end;
      
        if CodSbs is not null then
        
          if ln_CantEntAux = 0 then
            ln_CantEntAux := PQ_CR_DEURCC.Fn_cr_RCC2_Prestamo(CodSbs,
                                                              FechActRCC);
            ln_CantEnt    := ln_CantEnt + ln_CantEntAux;
          end if;
        
          ln_CantEntAux_Linea := PQ_CR_DEURCC.Fn_cr_RCC2_Linea(CodSbs,
                                                               FechActRCC);
        
          if ln_CantEntAux_Linea = 0 then
          
            ld_FchRCC := last_day(add_months(ld_FchRCC, -1));
            ln_i      := ln_i + 1;
          
          else
            ln_CantEnt := ln_CantEnt + ln_CantEntAux_Linea;
            exit;
          end if;
        
        else
          exit;
        
        end if;
      end loop;
    
    end;
  end sp_cr_RCC1;

  Function Fn_cr_RCC2_Prestamo(CodSbs in char, FechActRCC in date)
    return number is
  
    cursor entidad is
    
      select distinct C_CODEMP lc_emp
        from CLDRCCS
       Where C_CODSBS = CodSbs
         and C_CODEMP <> '00104'
         and D_FECPRE = FechActRCC
         and C_CRETIP not in (select tp1nro1
                                from fst198 a
                               Where Tp1cod = 1
                                 and Tp1cod1 = 20001
                                 and Tp1corr1 = 1
                                 and Tp1corr2 = 1205);
  
    cursor deu_cre(lc_emp in varchar2) is
    
      select distinct C_CUENTA lc_rubro, N_SALCAP ln_saldo
        from CLDRCCS
       Where C_CODSBS = CodSbs
         and C_CODEMP <> '00104'
         and D_FECPRE = FechActRCC
         and C_CODEMP = lc_emp
         and C_CRETIP not in (select tp1nro1
                                from fst198 a
                               Where Tp1cod = 1
                                 and Tp1cod1 = 20001
                                 and Tp1corr1 = 1
                                 and Tp1corr2 = 1205);
  
    lc_rubcta   varchar2(4);
    lc_rubcta1  varchar2(6);
    lc_rubcta2  varchar2(2);
    lc_existe_4 character(1);
    lc_existe_5 character(1);
    ln_NumEnt   number(10);
  
  begin
  
    ln_NumEnt := 0;
  
    for i in entidad loop
    
      lc_existe_4 := 'N';
      lc_existe_5 := 'N';
    
      for j in deu_cre(i.lc_emp) loop
      
        lc_rubcta  := SUBSTR(j.lc_rubro, 1, 4);
        lc_rubcta1 := SUBSTR(j.lc_rubro, 1, 6);
        lc_rubcta2 := SUBSTR(j.lc_rubro, 7, 2);
      
        begin
          -- lc_existe_4 = PRESTAMO
          select 'S'
            into lc_existe_4
            from fst198
           Where Tp1cod = 1
             and Tp1cod1 = 10899
             and Tp1corr1 = 13
             and Tp1corr2 = 6
             and TRIM(fst198.tp1desc) = lc_rubcta
             and lc_rubcta2 not in
                 (select trim(a.tp1desc)
                    from fst198 a
                   Where a.Tp1cod = 1
                     and a.Tp1cod1 = 10899
                     and a.Tp1corr1 = 13
                     and a.Tp1corr2 = 11);
        exception
          when others then
            null;
          
        end;
      
        begin
          -- lc_existe_5 = PRESTAMO
          select 'S'
            into lc_existe_5
            from fst198
           Where Tp1cod = 1
             and Tp1cod1 = 10899
             and Tp1corr1 = 13
             and Tp1corr2 = 7
             and TRIM(fst198.tp1desc) = lc_rubcta1;
        exception
          when others then
            null;
        end;
      
        if lc_existe_5 = 'S' or lc_existe_4 = 'S' then
          ln_NumEnt := ln_NumEnt + 1;
        end if;
        exit;
      
      end loop;
    end loop;
  
    return ln_NumEnt;
  end;

  Function Fn_cr_RCC2_Linea(CodSbs in char, FechActRCC in date) return number is
  
    cursor entidad is
    
      select distinct C_CODEMP lc_emp
        from CLDRCCS
       Where C_CODSBS = CodSbs
         and C_CODEMP <> '00104'
         and D_FECPRE = FechActRCC
         and C_CRETIP not in (select tp1nro1
                                from fst198 a
                               Where Tp1cod = 1
                                 and Tp1cod1 = 20001
                                 and Tp1corr1 = 1
                                 and Tp1corr2 = 1205);
  
    cursor deu_cre(lc_emp in varchar2) is
    
      select distinct C_CUENTA lc_rubro, N_SALCAP ln_saldo
        from CLDRCCS
       Where C_CODSBS = CodSbs
         and C_CODEMP <> '00104'
         and D_FECPRE = FechActRCC
         and C_CODEMP = lc_emp
         and C_CRETIP not in (select tp1nro1
                                from fst198 a
                               Where Tp1cod = 1
                                 and Tp1cod1 = 20001
                                 and Tp1corr1 = 1
                                 and Tp1corr2 = 1205);
  
    lc_rubro           VARCHAR2(14);
    lc_rubcta          varchar2(4);
    lc_rubcta2         varchar2(2);
    lc_rubcta1         varchar2(6);
    lc_rubcta3         varchar2(2);
    lc_existe_1        character(1);
    lc_existe_2        character(1);
    lc_existe_3        character(1);
    lc_Flag_Uso        character(1);
    ln_linea           NUMBER(18, 2) := 0.00;
    ln_responsabilidad NUMBER(18, 2) := 0.00;
    ln_NumEnt          number(10);
  
  begin
  
    for i in entidad loop
    
      lc_existe_1 := 'N';
      lc_existe_2 := 'N';
      lc_existe_3 := 'N';
    
      for j in deu_cre(i.lc_emp) loop
      
        lc_rubcta  := SUBSTR(j.lc_rubro, 1, 4);
        lc_rubcta1 := SUBSTR(j.lc_rubro, 1, 6);
        lc_rubcta2 := SUBSTR(j.lc_rubro, 7, 2);
        lc_rubcta3 := SUBSTR(j.lc_rubro, 5, 2);
      
        begin
          -- lc_existe_1 = LINEA TARJETA
          select 'S'
            into lc_existe_1
            from fst198
           Where fst198.Tp1cod = 1
             and fst198.Tp1cod1 = 10899
             and fst198.Tp1corr1 = 13
             and fst198.Tp1corr2 = 10
             and trim(fst198.tp1desc) = lc_rubcta
             and lc_rubcta3 not in
                 (select trim(a.tp1desc)
                    from fst198 a
                   Where a.Tp1cod = 1
                     and a.Tp1cod1 = 10899
                     and a.Tp1corr1 = 13
                     and a.Tp1corr2 = 16);
        exception
          when others then
            null;
        end;
      
        begin
          -- lc_existe_2 = UTILIZACION TARJETA
          select 'S'
            into lc_existe_2
            from fst198
           Where fst198.Tp1cod = 1
             and fst198.Tp1cod1 = 10899
             and fst198.Tp1corr1 = 13
             and fst198.Tp1corr2 = 8
             and trim(fst198.tp1desc) = lc_rubcta
             and lc_rubcta2 in (select trim(a.tp1desc)
                                  from fst198 a
                                 Where a.Tp1cod = 1
                                   and a.Tp1cod1 = 10899
                                   and a.Tp1corr1 = 13
                                   and a.Tp1corr2 = 11);
        exception
          when others then
          
            null;
        end;
      
        begin
          -- lc_existe_3 = RESPONSABILIDAD TARJETA
          select 'S'
            into lc_existe_3
            from fst198
           Where fst198.Tp1cod = 1
             and fst198.Tp1cod1 = 10899
             and fst198.Tp1corr1 = 13
             and fst198.Tp1corr2 = 9
             and trim(fst198.tp1desc) = lc_rubcta1;
        exception
          when others then
            null;
        end;
      
        if lc_existe_1 = 'S' then
          ln_linea := ln_linea + j.ln_saldo;
        else
          if lc_existe_3 = 'S' then
            ln_responsabilidad := ln_responsabilidad + j.ln_saldo;
          end if;
        end if;
      
      end loop;
    
      lc_Flag_Uso := 'N';
    
      case
      
        when lc_existe_2 = 'S' and lc_existe_1 = 'S' and lc_existe_3 = 'S' then
          lc_Flag_Uso := 'S';
        
        when lc_existe_2 = 'S' and lc_existe_1 = 'N' and lc_existe_3 = 'S' then
          lc_Flag_Uso := 'S';
        
        when lc_existe_2 = 'S' and lc_existe_1 = 'S' and lc_existe_3 = 'N' then
          lc_Flag_Uso := 'S';
        
        when lc_existe_1 = 'N' and lc_existe_2 = 'N' and lc_existe_3 = 'S' then
          lc_Flag_Uso := 'N';
        
        when lc_existe_1 = 'S' and lc_existe_2 = 'N' and lc_existe_3 = 'S' then
        
          if ln_linea - ln_responsabilidad = 0 then
            lc_Flag_Uso := 'N';
          else
            lc_Flag_Uso := 'S';
          end if;
        
        when lc_existe_1 = 'S' and lc_existe_2 = 'N' and lc_existe_3 = 'N' then
          lc_Flag_Uso := 'N';
        
        else
          lc_Flag_Uso := 'N';
        
      end case;
    
      ln_NumEnt := 0;
    
      if lc_Flag_Uso = 'S' then
        ln_NumEnt := ln_NumEnt + 1;
        exit;
      else
        ln_NumEnt := 0;
      end if;
    
    end loop;
  
    return ln_NumEnt;
  end;

end PQ_CR_DEURCC;
/

