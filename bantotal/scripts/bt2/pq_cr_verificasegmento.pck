create or replace package PQ_CR_VERIFICASEGMENTO is

  -- Author  : MPOSTIGOC
  -- Created : 06/03/2018 08:57:33 a.m.
  -- Purpose : 

  procedure sp_cr_VerifSegmnto(ln_Instancia         in number,
                               lc_SegmntoEvaluacion out number,
                               lc_SegmntoActual     out number,
                               lc_CambSegmnto       out varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_VerifSegmEvaluacion(ln_Instancia         in number,
                                      lc_SegmntoEvaluacion out number);
  ----------------------------------------------------------------                                    
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number);
  ---------------------------------------------------------------
  /*procedure sp_cr_CuotaAprobacion(ln_Operacion in number,
  ln_NroCuotas in number,
  ln_Cuoimp    out number);*/
  ---------------------------------------------------------------------
  procedure sp_cr_VerificaDatos(ln_Instancia  in number,
                                ln_CapSip     out number,
                                ln_Cap054     out number,
                                ln_NroCuotSip out number,
                                ln_NroCuot054 out number);

end PQ_CR_VERIFICASEGMENTO;
/

create or replace package body PQ_CR_VERIFICASEGMENTO is

  procedure sp_cr_VerifSegmnto(ln_Instancia         in number,
                               lc_SegmntoEvaluacion out number,
                               lc_SegmntoActual     out number,
                               lc_CambSegmnto       out varchar2) is
  
  begin
  
    lc_CambSegmnto := 'N';
  
    -- Segmento de la etapa de Evaluacion / Propuesta
    PQ_CR_VERIFICASEGMENTO.sp_cr_VerifSegmEvaluacion(ln_Instancia,
                                                     lc_SegmntoEvaluacion);
  
    -- Segmento Actual
    PQ_CR_VERIFICASEGMENTO.sp_cr_SegmntoActual(ln_Instancia,
                                               lc_SegmntoActual);
  
    if lc_SegmntoActual <> lc_SegmntoEvaluacion then
      lc_CambSegmnto := 'S';
    end if;
  
  end sp_cr_VerifSegmnto;

  -------------------------------------------------------------------------------
  procedure sp_cr_VerifSegmEvaluacion(ln_Instancia         in number,
                                      lc_SegmntoEvaluacion out number) is
  begin
  
    begin
      select to_number(trim(g.pae71val))
        into lc_SegmntoEvaluacion
        from fpae70 f, fpae71 g
       where f.pae51eva = g.pae51eva
         and f.pae70nro = g.pae70nro
         and f.pae70ins = ln_Instancia
         and f.pae51eva = 2
         and g.pae71ite = 43;
    exception
      when too_many_rows then
        begin
          select trim(g.pae71val)
            into lc_SegmntoEvaluacion
            from fpae70 f, fpae71 g
           where f.pae51eva = g.pae51eva
             and f.pae70nro = g.pae70nro
             and f.pae70ins = ln_Instancia
             and f.pae51eva = 2
             and g.pae71ite = 43
             and f.pae70nro = (select max(f.pae70nro)
                                 from fpae70 f
                                where f.pae70ins = ln_Instancia
                                  and f.pae51eva = 2);
        end;
      when others then
        null;
    end;
  
  end sp_cr_VerifSegmEvaluacion;
  --------------------------------------------------------------------------------
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number) is
  
    ln_pais   number;
    ln_tdoc   number;
    lc_nrodoc char(12);
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_nrodoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception when others then
        lc_SegmntoActual := 1; ---se agrego cambio.
    end;
  
    if ln_tdoc <> 9 then
    
      begin
        select to_number(trim(b.segcod))
          into lc_SegmntoActual
          from sngc60 a, sngc07 b
         where a.sngc60pais = ln_pais
           and a.sngc60tdoc = ln_tdoc
           and a.sngc60ndoc = lc_nrodoc
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select to_number(trim(b.segcod))
              into lc_SegmntoActual
              from sngc60 a, sngc07 b
             where a.sngc60pais = ln_pais
               and a.sngc60tdoc = ln_tdoc
               and a.sngc60ndoc = lc_nrodoc
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = ln_pais
                       and a.sngc60tdoc = ln_tdoc
                       and a.sngc60ndoc = lc_nrodoc
                       and a.sngc60ocup = b.sngc07cod);
          end;
        when others then
          null;
        
      end;
    
    else
      if ln_tdoc = 9 then
        lc_SegmntoActual := 1;
      end if;
    end if;
  
  end sp_cr_SegmntoActual;
  ------------------------------------------------------------------------------

  /*procedure sp_cr_CuotaAprobacion(ln_Operacion in number,
                                    ln_NroCuotas in number,
                                    ln_Cuoimp    out number) is
    
      cursor CorrSip03 is
        select sip3corr ln_CorrSip from sip003 where sip3oper = ln_Operacion;
    
      ln_Var1     number := 1;
      ln_Var2     number := 261;
      ln_cont     number := 1;
      ld_FchCuota date;
      ln_Monto1   varchar2(19);
      ln_Monto2   varchar2(19);
      ln_Monto3   varchar2(19);
      ln_Monto4   varchar2(19);
      ln_Monto5   varchar2(19);
      ln_Monto6   varchar2(19);
      ln_Monto7   varchar2(19);
      ln_Monto8   varchar2(19);
      ln_Monto9   varchar2(19);
      ln_Monto10  varchar2(19);
      ln_Monto11  varchar2(19);
      ln_Monto12  varchar2(19);
      ln_Monto13  varchar2(19);
      ln_Monto14  varchar2(19);
      ln_mnt1     number;
      ln_mnt2     number;
      ln_CorrSip  number;
    
    begin
    
      begin
        delete from jaqz803 where jaqz803oper = ln_Operacion;
        commit;
      end;
    
      begin
        select min(sip3corr)
          into ln_CorrSip
          from sip003
         where sip3oper = ln_Operacion;
      exception
        when others then
          null;
        
      end;
    
      for C in CorrSip03 loop
        ln_Var1 := 1;
      
        while ln_cont <= ln_NroCuotas loop
        
          if ln_cont = 1 then
            begin
              SELECT to_date(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                  DBMS_LOB.getlength(s.sip3txt),
                                                                  ln_Var1),
                                                  '[^@]+',
                                                  1,
                                                  1),
                                    1,
                                    9),
                             'DD/MM/YY')
                into ld_FchCuota
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_corrsip; -- Fecha de Cuota
            end;
            begin
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 9,
                                 18))
                into ln_Monto1
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Primer Monto
            end;
            begin
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 27,
                                 18))
                into ln_Monto2
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Segundo Monto
            end;
            begin
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 45,
                                 12))
                into ln_Monto3
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Tercer Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 57,
                                 12))
                into ln_Monto4
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Cuarto Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 69,
                                 12))
                into ln_Monto5
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Quinto Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 81,
                                 12))
                into ln_Monto6
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Sexto Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 93,
                                 12))
                into ln_Monto7
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Septimo Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 105,
                                 12))
                into ln_Monto8
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Octavo Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 117,
                                 12))
                into ln_Monto9
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Noveno Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 129,
                                 12))
                into ln_Monto10
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Decimo Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 141,
                                 12))
                into ln_Monto11
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- onceavo Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 153,
                                 12))
                into ln_Monto12
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Doceavo Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 165,
                                 12))
                into ln_Monto13
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Treceavo Monto
            end;
            begin
            
              SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                               DBMS_LOB.getlength(s.sip3txt),
                                                               ln_Var1),
                                               '[^@]+',
                                               1,
                                               1),
                                 177,
                                 12))
                into ln_Monto14
                from sip003 s
               where s.sip3oper = ln_Operacion
                 and s.sip3corr = c.ln_CorrSip; -- Decimo Cuarto Monto
            end;
          
          else
            if ln_cont > 1 then
            
              begin
                SELECT to_date(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                    DBMS_LOB.getlength(s.sip3txt),
                                                                    ln_Var1),
                                                    '[^@]+',
                                                    1,
                                                    1),
                                      1,
                                      9),
                               'DD/MM/YY')
                  into ld_FchCuota
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Fecha de Cuota
              end;
              begin
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   9,
                                   18))
                  into ln_Monto1
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Primer Monto
              end;
              begin
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   27,
                                   18))
                  into ln_Monto2
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Segundo Monto
              end;
              begin
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   45,
                                   12))
                  into ln_Monto3
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Tercer Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   57,
                                   12))
                  into ln_Monto4
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Cuarto Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   69,
                                   12))
                  into ln_Monto5
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Quinto Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   81,
                                   12))
                  into ln_Monto6
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Sexto Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   93,
                                   12))
                  into ln_Monto7
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Septimo Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   105,
                                   12))
                  into ln_Monto8
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Octavo Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   117,
                                   12))
                  into ln_Monto9
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Noveno Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   129,
                                   12))
                  into ln_Monto10
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Decimo Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   141,
                                   12))
                  into ln_Monto11
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- onceavo Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   153,
                                   12))
                  into ln_Monto12
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Doceavo Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   165,
                                   12))
                  into ln_Monto13
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Treceavo Monto
              end;
              begin
              
                SELECT trim(SUBSTR(regexp_substr(DBMS_LOB.substr(s.sip3txt,
                                                                 DBMS_LOB.getlength(s.sip3txt),
                                                                 ln_Var1),
                                                 '[^@]+',
                                                 1,
                                                 1),
                                   177,
                                   12))
                  into ln_Monto14
                  from sip003 s
                 where s.sip3oper = ln_Operacion
                   and s.sip3corr = c.ln_CorrSip; -- Decimo Cuarto Monto
              end;
            
            end if;
          end if;
        
          ln_mnt1 := TO_NUMBER(ln_Monto1, '999999999.99');
          ln_mnt2 := TO_NUMBER(ln_Monto2, '999999999.99');
        
          if ln_mnt1 > 0 and ln_mnt2 > 0 then
            ln_cont := ln_cont + 1;
            ln_Var1 := ln_Var1 + ln_Var2;
          else
            ln_cont := 1;
            ln_Var1 := ln_Var1 + ln_Var2;
          end if;
        
          if ln_mnt1 is null or ln_mnt2 is null then
            exit;
          end if;
        
          begin
            insert into jaqz803
              (jaqz803oper,
               jaqz803fchcuo,
               jaqz803mnt1,
               jaqz803mnt2,
               jaqz803mnt3,
               jaqz803mnt4,
               jaqz803mnt5,
               jaqz803mnt6,
               jaqz803mnt7,
               jaqz803mnt8,
               jaqz803mnt9,
               jaqz803mnt10,
               jaqz803mnt11,
               jaqz803mnt12,
               jaqz803mnt13,
               jaqz803mnt14)
            values
              (ln_Operacion,
               ld_FchCuota,
               ln_Monto1,
               ln_Monto2,
               ln_Monto3,
               ln_Monto4,
               ln_Monto5,
               ln_Monto6,
               ln_Monto7,
               ln_Monto8,
               ln_Monto9,
               ln_Monto10,
               ln_Monto11,
               ln_Monto12,
               ln_Monto13,
               ln_Monto14);
            commit;
          end;
        
        end loop;
      end loop;
    
      begin
        select max(TO_NUMBER(j.jaqz803mnt1, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt2, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt3, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt4, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt5, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt6, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt7, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt8, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt9, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt10, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt11, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt12, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt13, '999999999.99') +
                   TO_NUMBER(j.jaqz803mnt14, '999999999.99'))
          into ln_Cuoimp
          from jaqz803 j
         where j.jaqz803oper = ln_Operacion;
      exception
        when others then
          ln_Cuoimp := 0;
      end;
    
    end sp_cr_CuotaAprobacion;
  */
  ------------------------------------------------------------------------------

  procedure sp_cr_VerificaDatos(ln_Instancia  in number,
                                ln_CapSip     out number,
                                ln_Cap054     out number,
                                ln_NroCuotSip out number,
                                ln_NroCuot054 out number) is
  
    ln_pgcod number;
    ln_suc   number;
    ln_mod   number;
    ln_mda   number;
    ln_pap   number;
    ln_cta   number;
    ln_oper  number;
    ln_subop number;
    ln_tope  number;
  
  begin
  
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_suc,
             ln_mod,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_oper,
             ln_subop,
             ln_tope
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_pgcod is not null then
    
      begin
        select sum(f.ppcap)
          into ln_CapSip
          from fsd601 f
         where f.pgcod = ln_pgcod
           and f.ppmod = ln_mod
           and f.ppsuc = ln_suc
           and f.ppmda = ln_mda
           and f.pppap = ln_pap
           and f.ppcta = ln_cta
           and f.ppoper = ln_oper
           and f.ppsbop = ln_subop
           and f.pptope = ln_tope
           and f.d601co = 'X';
      exception
        when others then
          null;
      end;
    
      begin
        select x.xllcapital
          into ln_Cap054
          from x054023 x
         where x.xllpgcod = ln_pgcod
           and x.xllaomod = ln_mod
           and x.xllaosuc = ln_suc
           and x.xllaomda = ln_mda
           and x.xllaopap = ln_pap
           and x.xllaocta = ln_cta
           and x.xllaooper = ln_oper
           and x.xllaosbop = ln_subop
           and x.xllaotop = ln_tope;
      exception
        when others then
          null;
      end;
    
      begin
        select max(s.sng120cuo)
          into ln_NroCuotSip
          from sng120 s
         where s.sng120ins = ln_Instancia
           and s.sng120tsk like 'PROPUESTA%';
      exception
        when others then
          null;
      end;
    
      begin
        select x.xllcantcuo
          into ln_NroCuot054
          from x054023 x
         where x.xllpgcod = ln_pgcod
           and x.xllaomod = ln_mod
           and x.xllaosuc = ln_suc
           and x.xllaomda = ln_mda
           and x.xllaopap = ln_pap
           and x.xllaocta = ln_cta
           and x.xllaooper = ln_oper
           and x.xllaosbop = ln_subop
           and x.xllaotop = ln_tope;
      exception
        when others then
          null;
      end;
    
    else
    
      ln_CapSip     := 0;
      ln_Cap054     := 0;
      ln_NroCuotSip := 0;
      ln_NroCuot054 := 0;
    
    end if;
  
  end sp_cr_VerificaDatos;
  -------------------------------------------------------------------------------

end PQ_CR_VERIFICASEGMENTO;
/

