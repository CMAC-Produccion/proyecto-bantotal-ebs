create or replace function fn_sector_credito(v_fecpro in date,
                                             v_pgcod  in number,
                                             v_Scmod  in number,
                                             v_Scsuc  in number,
                                             v_Scmda  in number,
                                             v_Scpap  in number,
                                             v_Sccta  in number,
                                             v_Scoper in number,
                                             v_Scsbop in number,
                                             v_Sctope in number
                                             ) return number is

    ln_sector jaql101.jaql101scl%type;
    ln_instancia  wfattsvalues.wfinsprcid%type;

    ln_pgcodCu  fsd010.pgcod%type;
    ln_scmodCu  fsd010.aomod%type;
    ln_ScsucCu  fsd010.aosuc%type;
    ln_ScmdaCu  fsd010.aomda%type;
    ln_ScpapCu  fsd010.aopap%type;
    ln_ScctaCu  fsd010.aocta%type;
    ln_ScoperCu fsd010.aooper%type;
    ln_ScsbopCu fsd010.aosbop%type;
    ln_SctopeCu fsd010.aotope%type;
    ld_aofval fsd010.aofval%type;

begin

    IF v_Scmod = 116 then
      begin
        SELECT R2COD, R2MOD, R2SUC, R2MDA, R2PAP,R2CTA, R2OPER, R2SBOP, R2TOPE
               into ln_pgcodCu, ln_scmodCu, ln_ScsucCu, ln_ScmdaCu, ln_ScpapCu,
                    ln_ScctaCu, ln_ScoperCu, ln_ScsbopCu, ln_SctopeCu
          FROM fsr011 r11
         where relcod = 46
           and r11.R1COD  = v_pgcod
           and r11.R1MOD  = v_Scmod
           and r11.R1SUC  = v_Scsuc
           and r11.R1MDA  = v_Scmda
           and r11.R1PAP  = v_Scpap
           and r11.R1CTA  = v_Sccta
           and r11.R1OPER = v_Scoper
           and r11.R1SBOP = v_Scsbop
           and r11.R1TOPE = v_Sctope;
      exception
          when others then
             null;
      end;
    END IF;

    --Los fines de mes se tiene que obtener de la jaql101
    IF v_fecpro = last_day(v_fecpro) THEN

      begin
        select /*+all rows*/distinct l.jaql101scl
          into ln_sector
          from jaql101 l
          where l.jaql101pgc = 1
            and l.jaql101suc = v_Scsuc
            and l.jaql101mon = v_Scmda
            and l.jaql101pap = v_Scpap
            and l.jaql101cta = v_Sccta
            and l.jaql101ope = v_Scoper
            and l.jaql101sop = v_Scsbop
            and l.jaql101top = v_Sctope
            and l.jaql101mod = v_Scmod
            and l.jaql101fch = v_fecpro
            AND l.jaql101cor = (SELECT MAX(jaql101cor)
                                  FROM /*bantprod.*/jaql101
                                 WHERE jaql101suc  = l.jaql101suc
                                    and jaql101mon = l.jaql101mon
                                    and jaql101pap = l.jaql101pap
                                    and jaql101cta = l.jaql101cta
                                    and jaql101ope = l.jaql101ope
                                    and jaql101sop = l.jaql101sop
                                    and jaql101top = l.jaql101top
                                    and jaql101mod = l.jaql101mod
                                    AND jaql101fch = l.jaql101fch
                               )
            and rownum = 1;
      exception
          when others then
             ln_sector := null;
      end;

    ELSE --Otros dias
      begin
          select distinct JAQL101Scl
           into ln_sector
            from jaql101 a
           where a.jaql101pgc = v_pgcod
             and a.jaql101cta = v_Sccta
             and a.jaql101ope = v_Scoper
             and a.jaql101fch = (select max(j.jaql101fch)
                                   from JAQL101 j
                                  where JAQL101Pgc = v_pgcod
                                    and JAQL101Cta = v_Sccta
                                    and JAQL101Ope = v_Scoper
                                    and j.jaql101fch>=last_day(add_months(v_fecpro,-1))--ultimo cierre antes de fecha de proceso
                                    and j.jaql101fch<=v_fecpro
                                 )
            AND a.jaql101cor = (SELECT MAX(jaql101cor)
                                  FROM /*bantprod.*/jaql101 b
                                WHERE b.jaql101suc = a.jaql101suc
                                  and b.jaql101mon = a.jaql101mon
                                  and b.jaql101pap = a.jaql101pap
                                  and b.jaql101cta = a.jaql101cta
                                  and b.jaql101ope = a.jaql101ope
                                  and b.jaql101sop = a.jaql101sop
                                  and b.jaql101top = a.jaql101top
                                  and b.jaql101mod = a.jaql101mod
                                  AND b.jaql101fch = a.jaql101fch
                                  )
            and rownum=1;

      exception
        when no_data_found then
             BEGIN
                  IF ln_pgcodCu is not null THEN --Para lineas consultar el cupo
                    begin
                        select distinct JAQL101Scl
                         into ln_sector
                          from jaql101 a
                         where a.jaql101pgc = ln_pgcodCu
                           and a.jaql101cta = ln_ScctaCu
                           and a.jaql101ope = ln_ScoperCu
                           and a.jaql101fch = (select max(j.jaql101fch)
                                                 from JAQL101 j
                                                where JAQL101Pgc = ln_pgcodCu
                                                  and JAQL101Cta = ln_ScctaCu
                                                  and JAQL101Ope = ln_ScoperCu
                                                  and j.jaql101fch>=last_day(add_months(v_fecpro,-1))--ultimo cierre antes de fecha de proceso
                                                  and j.jaql101fch<=v_fecpro
                                               )
                          AND a.jaql101cor = (SELECT MAX(jaql101cor)
                                                FROM /*bantprod.*/jaql101 b
                                              WHERE b.jaql101suc = a.jaql101suc
                                                and b.jaql101mon = a.jaql101mon
                                                and b.jaql101pap = a.jaql101pap
                                                and b.jaql101cta = a.jaql101cta
                                                and b.jaql101ope = a.jaql101ope
                                                and b.jaql101sop = a.jaql101sop
                                                and b.jaql101top = a.jaql101top
                                                and b.jaql101mod = a.jaql101mod
                                                AND b.jaql101fch = a.jaql101fch
                                                )
                          and rownum=1;
                    exception
                      when others then
                          ln_sector := null;
                    end;
                  END IF;

                  IF  ln_sector is null THEN

                      begin
                        SELECT d10.aofval
                               into ld_aofval
                          FROM fsd010 d10
                         where
                               d10.PGCOD  = v_pgcod
                           and d10.AOMOD  = v_Scmod
                           and d10.AOSUC  = v_Scsuc
                           and d10.AOMDA  = v_Scmda
                           and d10.AOPAP  = v_Scpap
                           and d10.AOCTA  = v_Sccta
                           and d10.AOOPER = v_Scoper
                           and d10.AOSBOP = v_Scsbop
                           and d10.AOTOPE = v_Sctope;
                      exception
                          when others then
                             ld_aofval:=null;
                      end;

                      begin
                        ln_instancia := fn_instancia_credito(v_scmod, v_scsuc, v_scmda, v_scpap, v_sccta, v_scoper, v_scsbop, v_sctope);
                      exception
                        when others then
                            ln_instancia := null;
                      end;

                      IF last_day(ld_aofval)=last_day(v_fecpro) THEN --desembolso en el mes de proceso
                          begin
                               select trim(wv.WFAttSVal)
                                 into ln_sector
                                 from wfattsvalues wv
                                where WFINSPRCID = ln_instancia--v_instancia
                                  and WFAttSId   = 'SECTOR'
                                  and exists (
                                              SELECT 1
                                                FROM wfwrkitems u
                                                where
                                                       u.wftaskcod = 55
                                                   and u.wfitemid = (select max(s.wfitemid) from wfwrkitems s where s.wfinsprcid=u.wfinsprcid and s.wftaskcod = 55)
                                                   and u.wfinsprcid=ln_instancia--v_instancia
                                             );
                          exception
                            when others then
                                 ln_sector := null;
                          end;
                      END IF;
                  END IF;
             END;
        when others then
             ln_sector := null;
       end;
    END IF;
    return ln_sector;

end fn_sector_credito;
/

