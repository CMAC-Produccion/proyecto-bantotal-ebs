CREATE OR REPLACE FUNCTION FN_CR_REPORTE25_TIPCRE(
                                                  BNJ096SUC IN NUMBER,
                                                  BNJ096MDA IN NUMBER,
                                                  BNJ096PAP IN NUMBER,
                                                  BNJ096CTA IN NUMBER,
                                                  BNJ096OPE IN NUMBER,
                                                  BNJ096SUB IN NUMBER,
                                                  BNJ096MOD IN NUMBER,
                                                  BNJ096TOP IN NUMBER
                                                  ) RETURN NUMBER
IS

    p_c_pas char(1);
    p_c_tcr jaql114.jaql114tcrd%type;
    p_n_j096sub number(3);
    p_n_j096TOp number(3);
    p_n_j096suc number(3);
    p_n_j096Cta number(9);
    p_n_j096Ope number(9);
    p_n_j096Mda number(4);
    p_n_j096mod number(3);
    p_n_j096Pap number(4);

    ld_fecrcc date;
    lc_ndoc varchar2(12);
    lc_codsbs varchar2(10);
    cod_tipsbs char(2);

    P_N_GPO NUMBER(2);

BEGIN

     lc_codsbs := null;

     begin

       select to_date(Tpnro,'dd.mm.yyyy')
       into ld_fecrcc
       from fst098
       where Pgcod = 1
       and Tpcod = 7647
       and Tpcorr = 12;

       select trim(pendoc)
       into lc_ndoc
       from fsr008
       where ctnro = BNJ096CTA
       and cttfir = 'T';

       begin
       select c_codsbs
       into lc_codsbs
       from cldrcci
       where d_fecpre = ld_fecrcc
       and c_docide = lc_ndoc;
       exception
       when no_data_found then
            select c_codsbs
            into lc_codsbs
            from cldrcci
            where d_fecpre = ld_fecrcc
            and c_doctri = lc_ndoc;
       end;

       if lc_codsbs is not null then
          SP_tipSBS ( BNJ096CTA,
                      BNJ096OPE,
                      BNJ096MOD,
                      lc_codsbs,
                      cod_tipsbs);
       end if;

     exception when others then
       cod_tipsbs := null;
     end;


    if cod_tipsbs <> 99 and cod_tipsbs is not null then

      P_N_GPO := 0;

      if cod_tipsbs = '10' then
         P_N_GPO := 2;
      else
        if cod_tipsbs = '09' then
           P_N_GPO := 13;
        else
          if cod_tipsbs = '11' or cod_tipsbs = '12' then
             P_N_GPO := 3;
          else
            if cod_tipsbs = '13' then
               P_N_GPO := 4;
            else
              if cod_tipsbs = '08' then
                 P_N_GPO := 12;
              else
                 P_N_GPO := 0;
              end if;
            end if;
          end if;
        end if;
      end if;

    else

      P_N_GPO := 0;

      p_n_j096sub := BNJ096SUB;
      p_n_j096TOp := BNJ096TOP;
      p_n_j096suc := BNJ096SUC;
      p_n_j096Cta := BNJ096CTA;
      p_n_j096Ope := BNJ096OPE;
      p_n_j096Mda := BNJ096MDA;
      p_n_j096mod := BNJ096MOD;
      p_n_j096Pap := BNJ096PAP;

      begin
        select t.jaql114tcrd
        into p_c_tcr
        from fsr011 r
        inner join jaql114 t
        on r.R1COD = t.jaql114emp
        and r.R1SUC = t.jaql114suc
        and r.R1CTA = t.jaql114cta
        and r.R1OPER = t.jaql114oper
        and r.R1MDA = t.jaql114mda
        and r.R1MOD = t.jaql114mod
        and r.R1SBOP = t.jaql114sbop
        and r.R1TOPE = t.jaql114top
        and r.R1PAP = t.jaql114pap
        where RELCOD = 33
        and R2COD = 1
        and R2SUC = p_n_j096suc
        and R2CTA = p_n_j096Cta
        and R2OPER = p_n_j096Ope
        and R2MDA = p_n_j096Mda
        and R2MOD = p_n_j096mod
        and R2SBOP = p_n_j096sub
        and R2TOPE = p_n_j096TOp
        and R2PAP = p_n_j096Pap
        and rownum = 1;
      exception
      when no_data_found then
        p_c_tcr := null;
      when others then
        p_c_tcr := null;
      end;

      if (p_c_tcr is not null) then

        if substr(trim(p_c_tcr),1,3) = 'MIC' then
           P_N_GPO := 2;
        else
          if substr(trim(p_c_tcr),1,3) = 'PEQ' then
             P_N_GPO := 13;
          else
            if substr(trim(p_c_tcr),1,3) = 'CON' then
               P_N_GPO := 3;
            else
              if substr(trim(p_c_tcr),1,3) = 'HIP' then
                 P_N_GPO := 4;
              else
                if substr(trim(p_c_tcr),1,3) = 'MED' then
                   P_N_GPO := 12;
                else
                   P_N_GPO := 0;
                end if;
              end if;
            end if;
          end if;
        end if;

      else

        begin
          select bnj096pas
          into p_c_pas
          from bnj096
          where bnj096suc = p_n_j096suc
          and bnj096Cta = p_n_j096Cta
          and bnj096Ope = p_n_j096Ope
          and bnj096Mda = p_n_j096Mda
          and bnj096mod = p_n_j096mod
          and bnj096sub = p_n_j096sub
          and bnj096TOp = p_n_j096TOp
          and bnj096Pap = p_n_j096Pap
          and rownum = 1;
        exception
        when no_data_found then
          p_c_pas := null;
        when others then
          p_c_pas := null;
        end;

        if (p_c_pas is not null) then

          if (p_c_pas = 1) then
            P_N_GPO := 9;
          end if;
          if (p_c_pas = 2) then
            P_N_GPO := 3;
          end if;
          if (p_c_pas = 7) then
            P_N_GPO := 3;
          end if;
          if (p_c_pas = 3) then
            P_N_GPO := 2;
          end if;
          if (p_c_pas = 4) then
            P_N_GPO := 4;
          end if;
          if (p_c_pas = 8) then
            P_N_GPO := 12;
          end if;
          if (p_c_pas = 6) then
            P_N_GPO := 11;
          end if;
          if (p_c_pas = 5) then
            P_N_GPO := 13;
          end if;

        else
          P_N_GPO := 0;
        end if;
      end if;

    end if;

    return P_N_GPO;

EXCEPTION

WHEN OTHERS THEN
    P_N_GPO := 0;
END;
/

