create or replace package PQ_CR_MODULO_ABMPAGARES is
  --------------------------------------------------------------------------
  -- Author  : SMARQUEZ
  -- Created : 16/02/2018 15:34:32
  -- Purpose : MODULO ADMINISTRATIVO PAGARES
  --------------------------------------------------------------------------
  Procedure SP_CR_InicioJob;
  --------------------------------------------------------------------------
  Procedure sp_carga_datos(lc_digito in varchar2,
                           ld_fecha  in date);
  ---------------------------------sma11122018-----------------------------------------
  procedure sp_usuario(p_pgcod in number,
                    p_aosuc in number,
                    p_aomod in number,
                    p_aomda in number,
                    p_aopap in number,
                    p_aocta in number,
                    p_aooper in number,
                    p_aosbop in number,
                    p_aotope in number,
                    p_aofval in date,
                    p_agencia out number,
                    p_usuario out varchar2,
                    p_observa out varchar2);
 ---------------------------------sma1912018--------------------------------------------
  procedure sp_verif_tran(p_pgcod in number,
                          p_aosuc in number,
                          p_aomod in number,
                          p_aomda in number,
                          p_aopap in number,
                          p_aocta in number,
                          p_aooper in number,
                          p_aosbop in number,
                          p_aotope in number,
                          p_aof99  in date,
                          p_agencia out number,
                          P_usuario out varchar2,
                          p_vercan  out varchar2,
                          p_observa out varchar2);

end PQ_CR_MODULO_ABMPAGARES;
/

create or replace package body PQ_CR_MODULO_ABMPAGARES is
-----------------------------------------------------------------------
-- Fecha Modificación : 09/01/2020
-- Modificacion       : Adición de Guías para el estado en guia deben 
--                      estar 99,34 y las que se pidan posteriormente
-- Autor              : Silvia Marquez Avendaño
------------------------------------------------------------------------
  Procedure SP_CR_InicioJob is
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    ld_Fecha    date;
  begin

    begin
      select host_name into lc_hostname from v$instance;
    end;

   -- execute immediate ('truncate table JAQz560_AUX'); --->>>>>> Tabla temporal
   --    execute immediate ('truncate table JAQz562_AUX'); --->>>>>> Tabla temporal
   --sma 02052019 adicion de parametro de fecha
   select pgfape - 1 into ld_Fecha from fst017 where pgcod = 1;
--(select (pgfape - 1) from fst017 where pgcod = 1)
    for x in 0 .. 9 loop

      lc_variable := ' begin ' ||
                     ' PQ_CR_MODULO_ABMPAGARES.sp_carga_DATOS(' || x ||''||',to_Date('''||ld_fecha||''',''dd/mm/rr''));' || 'End; ';

      ln_job      := ln_job + 1;
--      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
IF SYS.FN_BD_ISRAC='TRUE' THEN
      DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                       -- instance  => 2,---pruebas 02/07/2024
                        instance  => 1,---pruebas
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;

    end loop;

  end SP_CR_InicioJob;

  Procedure sp_carga_datos(lc_digito in varchar2,
                           ld_fecha in date ) is
    cursor datos is
    select *
      from fsd010
     Where PgCod = 1
       and aomod in (select tp1nro1
                        from fst198
                       Where Tp1cod = 1
                         and Tp1cod1 = 10897
                         and Tp1corr1 = 700
                         and Tp1corr2 = 1
                         and tp1nro1 not in (select tp1nro1
                                               from fst198
                                              Where Tp1cod = 1
                                                and Tp1cod1 = 10897
                                                and Tp1corr1 = 750
                                                and Tp1corr2 = 1))
       and aosuc not in (select tpnro
                           from fst098
                          where TPCOD=7681
--                            and tpnro not in (151,104,130,129,107,142,123,41,101,128,106))
                            and tpnro not in (select tp1nro1
                                                from fst198
                                               where tp1cod = 1
                                                 and tp1cod1 = 10884
                                                 and TP1CORR1 = 16
                                                 and tp1corr2 = 0))--sma.13.12.2018
       and aomda in (0,101)
       and aopap = 0                                                   
       and Aofval = ld_fecha--sma.03/05/2019(select (pgfape - 1) from fst017 where pgcod = 1) --sma.13.12.2018
       and Aostat not in (select tp1nro1
                            from fst198
                           Where Tp1cod = 1
                             and Tp1cod1 = 10897
                             and Tp1corr1 = 760
                             and Tp1corr2 = 1)--<> 99
       
       and to_char(substr(trim(aocta), -1, 1)) = lc_digito
       and not exists (select 1
                         from jaqz560
                        where jaqz560pgc = pgcod
                          and jaqz560mod = aomod
                          and jaqz560suc = aosuc
                          and jaqz560mda = aomda
                          and jaqz560pap = aopap
                          and jaqz560cta = aocta
                          and jaqz560ope = aooper
                          and jaqz560sbo = aosbop
                          and jaqz560top = aotope
                          and jaqz560fvl = aofval);
    cursor cancelados is
    select * --PGCOD, AOSUC, AOMOD, AOMDA, AOPAP, AOCTA, AOFE99
      from fsd010
     Where PgCod = 1      
       and aomod in (select tp1nro1
                        from fst198
                       Where Tp1cod = 1
                         and Tp1cod1 = 10897
                         and Tp1corr1 = 700
                         and Tp1corr2 = 1
                         and tp1nro1 not in (select tp1nro1
                                               from fst198
                                              Where Tp1cod = 1
                                                and Tp1cod1 = 10897
                                                and Tp1corr1 = 750
                                                and Tp1corr2 = 1))
       and aomda in (0,101)
       and aopap = 0
       and Aofe99  = ld_fecha--sma.03/05/2019 (select (pgfape - 1) from fst017 where pgcod = 1)--sma.13.12.2018
       and Aostat = 99                                                
       and to_char(substr(trim(aocta), -1, 1)) = lc_digito
       and not exists (select 1
                         from jaqz562
                        where jaqz562pgc = pgcod
                          and jaqz562mod = aomod
                          and jaqz562suc = aosuc
                          and jaqz562mda = aomda
                          and jaqz562pap = aopap
                          and jaqz562cta = aocta
                          and jaqz562ope = aooper
                          and jaqz562sbo = aosbop
                          and jaqz562top = aotope
                          and jaqz562fca  = Aofe99);

  hora  char(10);
  fecha date;
  pepais1 number;
  petdoc1 number;
  pendoc1 char(12);
  agencia1 number;
  agencia number;
  observacion varchar2(30);
  USUDES CHAR(10);
  VERCAN VARCHAR2(1);

  Begin
    select TO_CHAR((pgfape-1), 'HH24:MI:SS'), ld_fecha--sma.03/05/2019(pgfape-1)
      into hora, fecha
      FROM fst017
     where pgcod = 1;
    For reg in datos loop
      begin
        select pepais, petdoc, pendoc
          into pepais1, petdoc1, pendoc1
          from fsr008
         where ctnro = reg.aocta
           and ttcod = 1
           and cttfir = 'T' ;
      exception
        when no_data_found then
          null;
      end ;
      sp_usuario(reg.pgcod,
                 reg.aosuc,
                 reg.aomod,
                 reg.aomda,
                 reg.aopap,
                 reg.aocta,
                 reg.aooper,
                 reg.aosbop,
                 reg.aotope,
                 reg.aofval,
                 agencia,
                 usudes,
                 observacion);
      begin
        insert into jaqz560_aux
                      (jaqz560xpgc,
                       jaqz560xmod,
                       jaqz560xsuc,
                       jaqz560xmda,
                       jaqz560xpap,
                       jaqz560xcta,
                       jaqz560xope,
                       jaqz560xsbo,
                       jaqz560xtop,
                       jaqz560xfvl,
                       jaqz560xhra,
                       jaqz560xusr,
                       jaqz560xpai,
                       jaqz560xtdc,
                       jaqz560xdoc,
                       jaqz560xest,
                       jaqz560xobs,
                       jaqz560xau1)
--                       jaqz560xau6)--usuario desembolso
                values(reg.pgcod,
                       reg.aomod,
                       agencia, --AGENCIA DESEMBOLSO
                       reg.aomda,
                       reg.aopap,
                       reg.aocta,
                       reg.aooper,
                       reg.aosbop,
                       reg.aotope,
                       reg.aofval,
                       hora,
                       USUDES, --usuario desembolso
                       pepais1,
                       petdoc1,
                       pendoc1,
                       'D',
                       OBSERVACION,---OBSEERVACION
                       reg.aosuc);
              commit;
      exception
        when dup_val_on_index then
          null;
      end;
    end loop;
    For ca in cancelados loop
      begin
        select pepais, petdoc, pendoc
          into pepais1, petdoc1, pendoc1
          from fsr008
         where ctnro = ca.aocta
           and ttcod = 1
           and cttfir = 'T' ;
      exception
        when no_data_found then
          null;
      end ;
      sp_usuario(ca.pgcod,
                 ca.aosuc,
                 ca.aomod,
                 ca.aomda,
                 ca.aopap,
                 ca.aocta,
                 ca.aooper,
                 ca.aosbop,
                 ca.aotope,
                 ca.aofval,
                 agencia1,
                 usudes,
                 observacion);
        sp_verif_tran(ca.pgcod,
                      ca.aosuc,
                      ca.aomod,
                      ca.aomda,
                      ca.aopap,
                      ca.aocta,
                      ca.aooper,
                      ca.aosbop,
                      ca.aotope,
                      ca.aofe99,
                      agencia,
                      usudes,
                      vercan,
                      observacion);
      If vercan = 'S' then
          begin
            insert into jaqz562_aux
                          (jaqz562xpgc,
                           jaqz562xmod,
                           jaqz562xsuc,
                           jaqz562xmda,
                           jaqz562xpap,
                           jaqz562xcta,
                           jaqz562xope,
                           jaqz562xsbo,
                           jaqz562xtop,
                           jaqz562xfvl,
                           jaqz562xhra,
                           jaqz562xusr,
                           jaqz562xins,
                           jaqz562xpai,
                           jaqz562xtdc,
                           jaqz562xdoc,
                           jaqz562xest)
                    values(ca.pgcod,
                           ca.aomod,
                           agencia1, --agencia desembolso
                           ca.aomda,
                           ca.aopap,
                           ca.aocta,
                           ca.aooper,
                           ca.aosbop,
                           ca.aotope,
                           ca.Aofe99,
                           hora,
                           usudes,--usuario cacelacion
                           ca.aosuc,---agencia original
                           pepais1,
                           petdoc1,
                           pendoc1,
                           'C');
                  commit;
          exception
            when dup_val_on_index then
              null;
          end;
       end if;
    end loop;
  end sp_carga_datos;
  ---------------------------------------sma 11122018--------------------------------------------

  procedure sp_usuario(p_pgcod in number,
                    p_aosuc in number,
                    p_aomod in number,
                    p_aomda in number,
                    p_aopap in number,
                    p_aocta in number,
                    p_aooper in number,
                    p_aosbop in number,
                    p_aotope in number,
                    p_aofval in date,
                    p_agencia out number,
                    p_usuario out varchar2,
                    p_observa out varchar2)is

  cursor modulo_transaccion is
    select tp1nro1 MODULO,
           tp1nro2 TRANSACCION
      from fst198
     where TP1COD = 1
       AND tp1cod1 = 10884
       AND TP1CORR1 = 15;

  --observacion varchar2(12);
  begin
       if p_aomod <> 117 then
            p_USUario := null;
            For a in modulo_transaccion loop
                BEGIN
                  select xwftsuc,
                       (select husing usu
                         from fsh015
                        where pgcod = 1
                          and hcmod = xwftmod
                          and hsucor = xwftsuc
                          and htran = xwfttran
                          and hnrel = xwfnrel
                          and hfcon = xwffcon
                         union
                         select ituing  usu
                         from fsd015
                        where pgcod = 1
                          and itmod = xwftmod
                          and itsuc = xwftsuc
                          and ittran = xwfttran
                          and itnrel = xwfnrel
                          and itfcon = xwffcon) usu1
                    into p_agencia,
                         p_usuario
                    FROM xwf070
                   where xwfprcin = (select xwfprcins
                                       from xwf700
                                      where xwfempresa = p_pgcod
                                        and xwfsucursal = p_aosuc
                                        and xwfmodulo = p_aomod
                                        and xwfmoneda = p_aomda
                                        and xwfpapel = p_aopap
                                        and xwfcuenta = p_aocta
                                        and xwfoperacion = p_aooper
                                        and xwfsubope = p_aosbop
                                        and xwftipope = p_aotope
                                        and xwfcar3 = '1'
                                        and rownum= 1)
                     and xwftmod = a.modulo --30
                     and xwfttran = a.transaccion -- 951
                     and xwffcon = p_aofval
                     and xwfcont = 'S'
                     and rownum = 1;
                     if p_agencia <>  p_aosuc then
                       p_observa :='OTRA AGENCIA';
                     else
                       p_observa := null;
                     End if;
                  exit when p_usuario is not null;
                Exception
                  when no_data_found then
                     p_agencia := p_aosuc;
                     p_observa := null;
                     p_usuario := null;

                End;
          end loop;
      else
        Begin
        select xwftsuc,
             (select husing usu
               from fsh015
              where pgcod = 1
                and hcmod = xwftmod
                and hsucor = xwftsuc
                and htran = xwfttran
                and hnrel = xwfnrel
                and hfcon = xwffcon
               union
               select ituing  usu
               from fsd015
              where pgcod = 1
                and itmod = xwftmod
                and itsuc = xwftsuc
                and ittran = xwfttran
                and itnrel = xwfnrel
                and itfcon = xwffcon) usu1
          into p_agencia,
               p_usuario --USUDES
          FROM xwf070
         where xwfprcin = (select xwfprcins
                             from xwf700
                            where xwfempresa = p_pgcod
                              and xwfsucursal = p_aosuc
                              and xwfmodulo = p_aomod
                              and xwfmoneda = p_aomda
                              and xwfpapel = p_aopap
                              and xwfcuenta = p_aocta
                              and xwfoperacion = p_aooper
                              and xwfsubope = p_aosbop
                              and xwftipope = p_aotope
                              and xwfcar3 = '1'
                              and rownum = 1)
           and xwftmod = 117
           and xwfttran = 10
           and xwffcon = p_aofval
           and xwfcont = 'S'
           and rownum = 1;
           if p_agencia <>  p_aosuc then
             p_observa :='OTRA AGENCIA';
           else
             p_observa := null;
           End if;
      Exception
        when no_data_found then
          p_agencia := p_aosuc;
          p_observa := null;
          p_usuario := null;
      End;
      end if;
  end sp_usuario;
  ---------------------------------------sma 11122018--------------------------------------------

  procedure sp_verif_tran(p_pgcod in number,
                          p_aosuc in number,
                          p_aomod in number,
                          p_aomda in number,
                          p_aopap in number,
                          p_aocta in number,
                          p_aooper in number,
                          p_aosbop in number,
                          p_aotope in number,
                          p_aof99  in date,
                          p_agencia out number,
                          P_usuario out varchar2,
                          p_vercan  out varchar2,
                          p_observa out varchar2)is

 /* cursor modulo_transaccion is
    select tp1nro1 MODULO,
           tp1nro2 TRANSACCION
      from fst198
     where TP1COD = 1
       AND tp1cod1 = 10884
       AND TP1CORR1 = 15
       and tp1corr3 not in (4,5,6);*/

 -- p_observa varchar2(12);
  begin
       if p_aomod <> 117 then
            p_usuario := null;
            /*For a in modulo_transaccion loop
                BEGIN
                  select f5.hsucor, f5.husing ,'S'
                    into p_agencia, p_usuario, p_vercan
                    from fsh015 f5,
                         fsh016 f6
                   where f6.pgcod = p_pgcod
                     and f6.hmodul = p_aomod
                     and f6.htoper = p_aotope
                     and f6.hsucur = p_aosuc
                     and f6.hmda = p_aomda
                     and f6.hpap = p_aopap
                     and f6.hcta = p_aocta
                     and f6.hoper = p_aooper
                     and f6.hsubop = p_aosbop
                     and f6.hcord = 10
                     and f6.hfcon = p_aof99
                     and f5.pgcod = f6.pgcod
                     and f5.hcmod = f6.hcmod
                     and f5.hsucor = f6.hsucor
                     and f5.htran = f6.htran
                     and f5.hnrel = f6.hnrel
                     and f5.hfcon = f6.hfcon
                     and f5.hcmod = a.modulo
                     and f5.htran = a.transaccion
                     and f5.hccorr = 0;

                     if p_agencia <>  p_aosuc then
                       p_observa :='OTRA AGENCIA';
                     else
                       p_observa := null;
                     End if;
                  exit when p_usuario is not null;
                Exception
                  when no_data_found then
                     p_agencia := p_aosuc;
                     p_observa := null;
                     p_usuario := null;
                     p_vercan := 'N';
                End;
          end loop;*/
          -------
          Begin
             select 'N'
               into p_vercan
               from fsr011
              where R2cod  = p_pgcod
                and R2mod  = p_aomod
                and R2suc  = p_aosuc
                and R2mda  = p_aomda
                and R2pap  = p_aopap
                and R2cta  = p_aocta
                and R2oper = p_aooper
                and R2sbop = p_aosbop
                and R2tope = p_aotope
                and Relcod in (33,34,35,36,52,120,860,870,890)
                and R011co = 'S'
                and rownum = 1;
            exception
              when no_data_found then
                Begin
                   select 'N'
                     into p_vercan
                     from fsr011
                    where R1cod  = p_pgcod
                      and R1mod  = p_aomod
                      and R1suc  = p_aosuc
                      and R1mda  = p_aomda
                      and R1pap  = p_aopap
                      and R1cta  = p_aocta
                      and R1oper = p_aooper
                      and R1sbop = p_aosbop
                      and R1tope = p_aotope
                      and Relcod in (33,34,35,36,52,120,860,870,890)
                      and R011co = 'S'
                      and rownum = 1;
                exception
                  when no_data_found then
                     p_vercan := 'S';
                End;
          end;
      else
        Begin
           select  f5.hsucor, f5.husing ,'S'
            into p_agencia, p_usuario, p_vercan
            from fsh015 f5,
                 fsh016 f6
           where f6.pgcod = p_pgcod
             and f6.hmodul = p_aomod
             and f6.htoper = p_aotope
             and f6.hsucur = p_aosuc
             and f6.hmda = p_aomda
             and f6.hpap = p_aopap
             and f6.hcta = p_aocta
             and f6.hoper = p_aooper
             and f6.hsubop = p_aosbop
             and f6.hcord = 10
             and f5.pgcod = f6.pgcod
             and f5.hcmod = f6.hcmod
             and f5.hsucor = f6.hsucor
             and f5.htran = f6.htran
             and f5.hnrel = f6.hnrel
             and f5.hfcon = f6.hfcon
             and f5.hcmod = 117
             and f5.htran = 100
             and f5.hfcon = p_aof99
             and f5.hccorr = 0;
           if p_agencia <>  p_aosuc then
             p_observa :='OTRA AGENCIA';
           else
             p_observa := null;
           End if;
      Exception
        when no_data_found then
          p_agencia := p_aosuc;
          p_observa := null;
          p_usuario := null;
          p_vercan := 'N';
      End;
      end if;
  end sp_verif_tran;
end PQ_CR_MODULO_ABMPAGARES;
/

