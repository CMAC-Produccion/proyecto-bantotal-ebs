create or replace package pq_cr_reprogr_COVID19 is
  -------------------------------------------------------------
  -- Author  : MPOSTIGOC
  -- Modificated : 05.06.2020
  -- Purpose : Se agrego excepciones en el procedimiento sp_cr_cargagrilla INC2595
  --          Sp_reversionXCta, se almacena la fecha y hora del extorno
  --------------------------------------------------------------
  procedure sp_cr_valida(pn_emp   in number,
                         pn_mod   in number,
                         pn_suc   in number,
                         pn_mda   in number,
                         pn_pap   in number,
                         pn_cta   in number,
                         pn_ope   in number,
                         pn_sbo   in number,
                         pn_top   in number,
                         pd_fecBI in date,
                         pn_cor   in number,
                         pc_flg   out varchar2);
  Procedure Sp_post_repro(pn_emp   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pd_fecBI in date,
                          pn_cor   in number,
                          pd_fecIn in date);
  Procedure Sp_cr_ActMora(pn_emp   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pd_fecBI in date,
                          pn_cor   in number);
  procedure Sp_instancia(pn_emp   in number,
                         pn_mod   in number,
                         pn_suc   in number,
                         pn_mda   in number,
                         pn_pap   in number,
                         pn_cta   in number,
                         pn_ope   in number,
                         pn_sbo   in number,
                         pn_top   in number,
                         pd_fecBI in date,
                         pn_cor   in number,
                         pn_ins   out number);
  Procedure Sp_reversion;

  procedure sp_cr_valida2(pn_emp   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pd_fecBI in date,
                          pn_cor   in number,
                          pc_flg   out varchar2);
  Procedure Sp_post_repro2(pn_emp   in number,
                           pn_mod   in number,
                           pn_suc   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_sbo   in number,
                           pn_top   in number,
                           pd_fecBI in date,
                           pn_cor   in number,
                           pd_fecIn in date);
  Procedure Sp_Cr_validaRestric(pn_emp   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pd_fecBI in date,
                                pn_cor   in number,
                                pv_flg   out varchar2);
  --------------------------------------------------------

  Procedure Sp_reversionXCta(ln_pgcod     in number,
                             ln_mod       in number,
                             ln_suc       in number,
                             ln_mda       in number,
                             ln_pap       in number,
                             ln_cta       in number,
                             ln_ope       in number,
                             ln_sbop      in number,
                             ln_top       in number,
                             lc_usuario   in char,
                             lc_Resultado out number);


  ----------------------------------------
  procedure sp_cr_VerfMaxReprg(ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cuenta    in number,
                               ln_operacion in number,
                               ln_sbop      in number,
                               ln_top       in number,
                               lc_Flag      out varchar2,
                               ld_fec       out date,
                               ln_cor       out number);
  ------------------------------------------
  --chernandez 10/07/2020
  procedure sp_cr_CargaGrilla(ln_pgcod     in number,
                              ln_cuenta    in number,
                              ln_operacion in number);
  ------------------------------------------
  Procedure Sp_Up_MailTlfn_698(pn_emp      in number,
                               pn_mod      in number,
                               pn_suc      in number,
                               pn_mda      in number,
                               pn_pap      in number,
                               pn_cta      in number,
                               pn_ope      in number,
                               pn_sbo      in number,
                               pn_top      in number,
                               pd_fec      in date,
                               pv_correo   in varchar2,
                               pv_telefono in varchar2);
  --------------------------------------------------------
  Procedure Sp_backup_ext(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pn_cor in number);
  --------------------------------------------------------

    Procedure Sp_reversionXCta88(ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cta       in number,
                               ln_ope       in number,
                               ln_sbop      in number,
                               ln_top       in number,
                               lc_usuario   in char,
                               lc_Resultado out number);

  ----------------------------------------
  Procedure Sp_backup_ext88(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pn_cor in number);
  --------------------------------------------------------
  Procedure Sp_Up_MailTlfn_088(pn_emp      in number,
                               pn_mod      in number,
                               pn_suc      in number,
                               pn_mda      in number,
                               pn_pap      in number,
                               pn_cta      in number,
                               pn_ope      in number,
                               pn_sbo      in number,
                               pn_top      in number,
                               pd_fec      in date,
                               pv_correo   in varchar2,
                               pv_telefono in varchar2);

  ------------------------------------------
Procedure Sp_Up_AQPB602_088(pn_emp      in number,
                           pn_mod      in number,
                           pn_suc      in number,
                           pn_mda      in number,
                           pn_pap      in number,
                           pn_cta      in number,
                           pn_ope      in number,
                           pn_sbo      in number,
                           pn_top      in number,
                           pd_fec      in date,
                           pn_cor      in number) ;

  ------------------------------------------
Procedure sp_cr_reporte (vi_sucext in number,
                         vi_fchini in date,
                         vi_fchfin in date,
                         vi_usrrpt in varchar2 );
end pq_cr_reprogr_COVID19;
/

create or replace package body pq_cr_reprogr_COVID19 is
  -------------------------------------------------------------
  -- Author  : MPOSTIGOC
  -- Modificated : 05.06.2020
  -- Purpose : Se agrego excepciones en el procedimiento sp_cr_cargagrilla INC2595
  --          Sp_reversionXCta, se almacena la fecha y hora del extorno
  --Autor modificacion: chernandez
  --fecha modificacion: 10/07/2020 12/07/2020
  --Descripcion modificacion: extorno y adicion de backups
  --Autor modificacion: chernandez
  --fecha modificacion: 23/07/2020
  --Descripcion modificacion: modificacion de funcionalidad de jaqa257
  --Autor modificacion: jrodriguej
  --fecha modificacion: 19/02/2021
  --Descripcion modificacion: adición de procedimientos de reprogramación relacionados a la tabla aqpb088
  --Autor modificacion: jrodriguej
  --fecha modificacion: 20/09/2021
  --Descripcion modificacion: adición de procedimientos de reprogramación Sp_Up_AQPB602_088
  --------------------------------------------------------------
  procedure sp_cr_valida(pn_emp   in number,
                         pn_mod   in number,
                         pn_suc   in number,
                         pn_mda   in number,
                         pn_pap   in number,
                         pn_cta   in number,
                         pn_ope   in number,
                         pn_sbo   in number,
                         pn_top   in number,
                         pd_fecBI in date,
                         pn_cor   in number,
                         pc_flg   out varchar2) is

    ld_maxpag date;
    lc_stat   char(1);
    lc_flg    char(1);
    ln_cap    number(17, 2);
    lc_flgCap char(1);
    lc_est    char(1);

    cursor cuotas_parc is
      select *
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = ld_maxpag
         and a.pp1stat = 'P'
         and a.d602co = 'S';
  begin
    --verifica si es parcial
    begin
      select max(a.ppfpag)
        into ld_maxpag
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S';
    exception
      when too_many_rows then
        begin
          select max(a.ppfpag)
            into ld_maxpag
            from fsd602 a
           where a.pgcod = pn_emp
             and a.ppmod = pn_mod
             and a.ppsuc = pn_suc
             and a.ppmda = pn_mda
             and a.pppap = pn_pap
             and a.ppcta = pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
             and a.d602co = 'S'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;

    if ld_maxpag is not null then
      begin
        select 'T'
          into lc_stat
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'T'
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
      if lc_stat = 'T' then
        lc_flg := 'S';
      else
        lc_flg := 'P';
      end if;
    else
      lc_flg := 'S';
    end if;

    ---valida si el pago parcial es de capital
    if lc_flg = 'P' then

      begin
        select sum(a.pp1cap)
          into ln_cap
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;

      if nvl(ln_cap, 0) <> 0 then
        lc_flgCap := 'S';
      else
        lc_flgCap := 'N';
      end if;
    end if;

    if lc_flg = 'P' and lc_flgCap = 'N' then
      lc_est := 'B';
      update jaqz698 a
         set a.jaqz698ind = 'P',
             a.jaqz698ica = 'N', --es parcial sin pago de capital
             a.jaqz698est = lc_est
       where a.jaqz698fep = pd_fecBI
         and a.jaqz698cor = pn_cor
         and a.jaqz698emp = pn_emp
         and a.jaqz698mod = pn_mod
         and a.jaqz698suc = pn_suc
         and a.jaqz698mda = pn_mda
         and a.jaqz698pap = pn_pap
         and a.jaqz698cta = pn_cta
         and a.jaqz698ope = pn_ope
         and a.jaqz698sbo = pn_sbo
         and a.jaqz698top = pn_top;
      commit;

    end if;

    if lc_flg = 'P' and lc_flgCap = 'S' then
      lc_est := 'R';
      update jaqz698 a
         set a.jaqz698ind = 'P',
             a.jaqz698ica = 'S', --es parcial con pago de capital
             a.jaqz698est = lc_est
       where a.jaqz698fep = pd_fecBI
         and a.jaqz698cor = pn_cor
         and a.jaqz698emp = pn_emp
         and a.jaqz698mod = pn_mod
         and a.jaqz698suc = pn_suc
         and a.jaqz698mda = pn_mda
         and a.jaqz698pap = pn_pap
         and a.jaqz698cta = pn_cta
         and a.jaqz698ope = pn_ope
         and a.jaqz698sbo = pn_sbo
         and a.jaqz698top = pn_top;
      commit;

    end if;

    if lc_flg = 'S' then
      lc_est := 'B';
      update jaqz698 a
         set a.jaqz698est = lc_est
       where a.jaqz698fep = pd_fecBI
         and a.jaqz698cor = pn_cor
         and a.jaqz698emp = pn_emp
         and a.jaqz698mod = pn_mod
         and a.jaqz698suc = pn_suc
         and a.jaqz698mda = pn_mda
         and a.jaqz698pap = pn_pap
         and a.jaqz698cta = pn_cta
         and a.jaqz698ope = pn_ope
         and a.jaqz698sbo = pn_sbo
         and a.jaqz698top = pn_top;

      commit;
    end if;

    --actualizo calendario de pago
    delete from jaqz699_fsd602 a
     where a.jaqz699_fec = pd_fecBI
       and a.jaqz699_cor = pn_cor
       and a.jaqz699pgcod = pn_emp
       and a.jaqz699mod = pn_mod
       and a.jaqz699suc = pn_suc
       and a.jaqz699mda = pn_mda
       and a.jaqz699pap = pn_pap
       and a.jaqz699cta = pn_cta
       and a.jaqz699oper = pn_ope
       and a.jaqz699sbop = pn_sbo
       and a.jaqz699tope = pn_top;
    commit;
    begin
      insert into jaqz699_fsd602

        select pd_fecBI, pn_cor, a.*
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';
    end;
    commit;

    if nvl(lc_flgCap, 'N') = 'N' and lc_flg = 'P' then

      for i in cuotas_parc loop

        update fsd602 a
           set a.d602co = 'E'
         where a.pgcod = i.pgcod
           and a.ppmod = i.ppmod
           and a.ppsuc = i.ppsuc
           and a.ppmda = i.ppmda
           and a.pppap = i.pppap
           and a.ppcta = i.ppcta
           and a.ppoper = i.ppoper
           and a.ppsbop = i.ppsbop
           and a.pptope = i.pptope
           and a.pp1nump = i.pp1nump
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';

        commit;

      end loop;

    end if;
    commit;

    pc_flg := lc_est;

  end sp_cr_valida;

  Procedure Sp_post_repro(pn_emp   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pd_fecBI in date,
                          pn_cor   in number,
                          pd_fecIn in date) is

    cursor bk is
      select *
        from jaqz699_fsd602 a
       where a.jaqz699_fec = pd_fecBI
         and a.jaqz699_cor = pn_cor
         and a.jaqz699pgcod = pn_emp
         and a.jaqz699mod = pn_mod
         and a.jaqz699suc = pn_suc
         and a.jaqz699mda = pn_mda
         and a.jaqz699pap = pn_pap
         and a.jaqz699cta = pn_cta
         and a.jaqz699oper = pn_ope
         and a.jaqz699sbop = pn_sbo
         and a.jaqz699tope = pn_top;

    lc_ind char(1);
    lc_ica char(1);
    lc_err char(1) := 'N';
  begin

    -- validar que es parcial y sin capital
    begin
      select a.jaqz698ind, a.jaqz698ica
        into lc_ind, lc_ica
        from jaqz698 a
       where a.jaqz698emp = pn_emp
         and a.jaqz698mod = pn_mod
         and a.jaqz698suc = pn_suc
         and a.jaqz698mda = pn_mda
         and a.jaqz698pap = pn_pap
         and a.jaqz698cta = pn_cta
         and a.jaqz698ope = pn_ope
         and a.jaqz698sbo = pn_sbo
         and a.jaqz698top = pn_top
         and a.jaqz698fep = pd_fecBI
         and a.jaqz698cor = pn_cor;
    exception
      when others then
        lc_err := 'S';
        update jaqz698 a
           set a.jaqz698ca2 = lc_err
         where a.jaqz698emp = pn_emp
           and a.jaqz698mod = pn_mod
           and a.jaqz698suc = pn_suc
           and a.jaqz698mda = pn_mda
           and a.jaqz698pap = pn_pap
           and a.jaqz698cta = pn_cta
           and a.jaqz698ope = pn_ope
           and a.jaqz698sbo = pn_sbo
           and a.jaqz698top = pn_top
           and a.jaqz698fep = pd_fecBI
           and a.jaqz698cor = pn_cor;

        commit;
    end;

    if lc_ind = 'P' and lc_ica = 'N' then
      for i in bk loop

        begin
          update fsd612 a
             set a.ppfpag = pd_fecIn
           where a.pgcod = i.jaqz699pgcod
             and a.ppmod = i.jaqz699mod
             and a.ppsuc = i.jaqz699suc
             and a.ppmda = i.jaqz699mda
             and a.pppap = i.jaqz699pap
             and a.ppcta = i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.pp1nump = i.jaqz699nump;

          commit;
        exception
          when others then
            lc_err := 'S';

            update jaqz698 a
               set a.jaqz698ca2 = lc_err
             where a.jaqz698emp = pn_emp
               and a.jaqz698mod = pn_mod
               and a.jaqz698suc = pn_suc
               and a.jaqz698mda = pn_mda
               and a.jaqz698pap = pn_pap
               and a.jaqz698cta = pn_cta
               and a.jaqz698ope = pn_ope
               and a.jaqz698sbo = pn_sbo
               and a.jaqz698top = pn_top
               and a.jaqz698fep = pd_fecBI
               and a.jaqz698cor = pn_cor;

            commit;
        end;
        begin
          update fsd602 a
             set a.ppfpag = pd_fecIn, a.d602co = 'S'
           where a.pgcod = i.jaqz699pgcod
             and a.ppmod = i.jaqz699mod
             and a.ppsuc = i.jaqz699suc
             and a.ppmda = i.jaqz699mda
             and a.pppap = i.jaqz699pap
             and a.ppcta = i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.pp1nump = i.jaqz699nump
             and a.d602co = 'E';

          commit;
        exception
          when others then
            lc_err := 'S';

            update jaqz698 a
               set a.jaqz698ca2 = lc_err
             where a.jaqz698emp = pn_emp
               and a.jaqz698mod = pn_mod
               and a.jaqz698suc = pn_suc
               and a.jaqz698mda = pn_mda
               and a.jaqz698pap = pn_pap
               and a.jaqz698cta = pn_cta
               and a.jaqz698ope = pn_ope
               and a.jaqz698sbo = pn_sbo
               and a.jaqz698top = pn_top
               and a.jaqz698fep = pd_fecBI
               and a.jaqz698cor = pn_cor;

            commit;
        end;
      end loop;
    end if;
    commit;

  end Sp_post_repro;

  Procedure Sp_cr_ActMora(pn_emp   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pd_fecBI in date,
                          pn_cor   in number) is

    ln_mora    number(17, 2);
    lc_flgMora char(1);
    lc_flgErr  char(1);
    ld_fecMax  date;
    ln_cap     number(17, 2);
    ln_capTot  number(17, 2);
  begin
    begin
      select a.jaqz698mora
        into lc_flgMora
        from jaqz698 a
       where a.jaqz698emp = pn_emp
         and a.jaqz698mod = pn_mod
         and a.jaqz698suc = pn_suc
         and a.jaqz698mda = pn_mda
         and a.jaqz698pap = pn_pap
         and a.jaqz698cta = pn_cta
         and a.jaqz698ope = pn_ope
         and a.jaqz698sbo = pn_sbo
         and a.jaqz698top = pn_top
         and a.jaqz698fep = pd_fecBI
         and a.jaqz698cor = pn_cor;
    exception
      when others then
        lc_flgMora := 'N';
    end;

    If nvl(lc_flgMora, 'N') = 'S' then
      begin
        select a.aqpb001msumac
          into ln_mora
          from AQPB001 a
         where a.aqpb001hpgcod = pn_emp
           and a.aqpb001hmodul = pn_mod
           and a.aqpb001hsucur = pn_suc
           and a.aqpb001hmda = pn_mda
           and a.aqpb001hpap = pn_pap
           and a.aqpb001hcta = pn_cta
           and a.aqpb001hoper = pn_ope
           and a.aqpb001hsubop = pn_sbo
           and a.aqpb001htoper = pn_top
           and a.aqpb001fecha = pd_fecBI
           and a.aqpb001cor = pn_cor;
      exception
        when others then
          lc_flgErr := 'S';
      end;

      if nvl(ln_mora, 0) <> 0 then

        begin
          select max(a.ppfpag)
            into ld_fecMax
            from fsd601 a
           where a.pgcod = pn_emp
             and a.ppmod = pn_mod
             and a.ppsuc = pn_suc
             and a.ppmda = pn_mda
             and a.pppap = pn_pap
             and a.ppcta = pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
             and a.d601co = 'S';
        exception
          when others then
            lc_flgErr := 'S';
        end;
        begin
          select a.ppcap
            into ln_cap
            from fsd601 a
           where a.pgcod = pn_emp
             and a.ppmod = pn_mod
             and a.ppsuc = pn_suc
             and a.ppmda = pn_mda
             and a.pppap = pn_pap
             and a.ppcta = pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
             and a.d601co = 'S'
             and a.ppfpag = ld_fecMax;
        exception
          when others then
            lc_flgErr := 'S';
        end;
        ln_capTot := nvl(ln_cap, 0) + nvl(ln_mora, 0);
        begin
          update fsd601 a
             set a.ppcap = ln_capTot
           where a.pgcod = pn_emp
             and a.ppmod = pn_mod
             and a.ppsuc = pn_suc
             and a.ppmda = pn_mda
             and a.pppap = pn_pap
             and a.ppcta = pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
             and a.d601co = 'S'
             and a.ppfpag = ld_fecMax;
        exception
          when others then
            lc_flgErr := 'S';
        end;
        commit;
      end if;

      if nvl(lc_flgErr, 'N') = 'S' then
        update jaqz698 a
           set a.jaqz698fcap = 'I'
         where a.jaqz698emp = pn_emp
           and a.jaqz698mod = pn_mod
           and a.jaqz698suc = pn_suc
           and a.jaqz698mda = pn_mda
           and a.jaqz698pap = pn_pap
           and a.jaqz698cta = pn_cta
           and a.jaqz698ope = pn_ope
           and a.jaqz698sbo = pn_sbo
           and a.jaqz698top = pn_top
           and a.jaqz698fep = pd_fecBI
           and a.jaqz698cor = pn_cor;
        commit;
      else
        update jaqz698 a
           set a.jaqz698fcap = 'C'
         where a.jaqz698emp = pn_emp
           and a.jaqz698mod = pn_mod
           and a.jaqz698suc = pn_suc
           and a.jaqz698mda = pn_mda
           and a.jaqz698pap = pn_pap
           and a.jaqz698cta = pn_cta
           and a.jaqz698ope = pn_ope
           and a.jaqz698sbo = pn_sbo
           and a.jaqz698top = pn_top
           and a.jaqz698fep = pd_fecBI
           and a.jaqz698cor = pn_cor;
        commit;
      end if;

    end if;
    commit;

  end Sp_cr_ActMora;

  procedure Sp_instancia(pn_emp   in number,
                         pn_mod   in number,
                         pn_suc   in number,
                         pn_mda   in number,
                         pn_pap   in number,
                         pn_cta   in number,
                         pn_ope   in number,
                         pn_sbo   in number,
                         pn_top   in number,
                         pd_fecBI in date,
                         pn_cor   in number,
                         pn_ins   out number) is
    ln_ins number(10);
  begin
    ln_ins := fn_instancia_credito(v_Scmod  => pn_mod,
                                   v_Scsuc  => pn_suc,
                                   v_Scmda  => pn_mda,
                                   v_Scpap  => pn_pap,
                                   v_Sccta  => pn_cta,
                                   v_Scoper => pn_ope,
                                   v_Scsbop => pn_sbo,
                                   v_Sctope => pn_top);
    update jaqz698 a
       set a.jaqz698inst = ln_ins
     where a.jaqz698emp = pn_emp
       and a.jaqz698mod = pn_mod
       and a.jaqz698suc = pn_suc
       and a.jaqz698mda = pn_mda
       and a.jaqz698pap = pn_pap
       and a.jaqz698cta = pn_cta
       and a.jaqz698ope = pn_ope
       and a.jaqz698sbo = pn_sbo
       and a.jaqz698top = pn_top
       and a.jaqz698fep = pd_fecBI
       and a.jaqz698cor = pn_cor;
    commit;

    pn_ins := ln_ins;
  end Sp_instancia;
  --------------------------------------------------------
  Procedure Sp_reversion is

    cursor creditos is
      select *
        from jaqz698 a
       where a.jaqz698est in ('C')
       order by a.jaqz698fep desc;
    --lc_flg    char(1) := 'N';
    ln_001Act number(10);
    ln_001Ant number(10);
    ln_003Act number(10);
    ln_003Ant number(10);
    ln_602Act number(10);
    ln_602Ant number(10);

  begin
    begin
      for i in creditos loop

        begin
          select count(*)
            into ln_602Act
            from fsd602 a
           where a.pgcod = i.jaqz698emp
             and a.ppmod = i.jaqz698mod
             and a.ppsuc = i.jaqz698suc
             and a.ppmda = i.jaqz698mda
             and a.pppap = i.jaqz698pap
             and a.ppcta = i.jaqz698cta
             and a.ppoper = i.jaqz698ope
             and a.ppsbop = i.jaqz698sbo
             and a.pptope = i.jaqz698top
             and a.d602co = 'S';
        exception
          when others then
            null;
        end;

        begin

          select count(*)
            into ln_602Ant
            from JAQZ520_602C t
           where t.pgcod = i.jaqz698emp
             and t.ppmod = i.jaqz698mod
             and t.ppsuc = i.jaqz698suc
             and t.ppmda = i.jaqz698mda
             and t.pppap = i.jaqz698pap
             and t.ppcta = i.jaqz698cta
             and t.ppoper = i.jaqz698ope
             and t.ppsbop = i.jaqz698sbo
             and t.pptope = i.jaqz698top
             and t.d602co = 'S'
             and t.fec = i.jaqz698fep
             and t.cor = i.jaqz698cor;
        exception
          when others then
            null;
        end;

        begin
          select count(*)
            into ln_001Act
            from fpp001 a
           where a.pgcod = i.jaqz698emp
             and a.aomod = i.jaqz698mod
             and a.aosuc = i.jaqz698suc
             and a.aomda = i.jaqz698mda
             and a.aopap = i.jaqz698pap
             and a.aocta = i.jaqz698cta
             and a.aooper = i.jaqz698ope
             and a.aosbop = i.jaqz698sbo
             and a.aotope = i.jaqz698top;
        exception
          when others then
            null;
        end;

        begin
          select count(*)
            into ln_001Ant
            from AQPA004V1 a
           where a.aqpa4cpgcod = i.jaqz698emp
             and a.aqpa4caomod = i.jaqz698mod
             and a.aqpa4caosuc = i.jaqz698suc
             and a.aqpa4caomda = i.jaqz698mda
             and a.aqpa4caopap = i.jaqz698pap
             and a.aqpa4caocta = i.jaqz698cta
             and a.aqpa4caooper = i.jaqz698ope
             and a.aqpa4caosbop = i.jaqz698sbo
             and a.aqpa4caotope = i.jaqz698top
             and a.aqpa4cfep = i.jaqz698fep
             and a.aqpa4ccor = i.jaqz698cor;
        exception
          when others then
            null;
        end;

        begin
          select count(*)
            into ln_003Act
            from fpp003 a, fsd602 b
           where a.pgcod = i.jaqz698emp
             and a.ppmod = i.jaqz698mod
             and a.ppsuc = i.jaqz698suc
             and a.ppmda = i.jaqz698mda
             and a.pppap = i.jaqz698pap
             and a.ppcta = i.jaqz698cta
             and a.ppoper = i.jaqz698ope
             and a.ppsbop = i.jaqz698sbo
             and a.pptope = i.jaqz698top
             and a.pgcod = b.pgcod
             and a.ppmod = b.ppmod
             and a.ppsuc = b.ppsuc
             and a.ppmda = b.ppmda
             and a.pppap = b.pppap
             and a.ppcta = b.ppcta
             and a.ppoper = b.ppoper
             and a.ppsbop = b.ppsbop
             and a.pptope = b.pptope
             and a.pp003nump = b.pp1nump
             and b.d602co = 'S';
        exception
          when others then
            null;
        end;

        begin
          select count(*)
            into ln_003Ant
            from AQPA004D1 a, JAQZ520_602C b
           where a.aqpa4dpgcod = i.jaqz698emp
             and a.aqpa4dmod = i.jaqz698mod
             and a.aqpa4dsuc = i.jaqz698suc
             and a.aqpa4dmda = i.jaqz698mda
             and a.aqpa4dpap = i.jaqz698pap
             and a.aqpa4dcta = i.jaqz698cta
             and a.aqpa4doper = i.jaqz698ope
             and a.aqpa4dsbop = i.jaqz698sbo
             and a.aqpa4dtope = i.jaqz698top
             and a.aqpa4dfep = i.jaqz698fep
             and a.aqpa4dcor = i.jaqz698cor
             and a.aqpa4dpgcod = b.pgcod
             and a.aqpa4dmod = b.ppmod
             and a.aqpa4dsuc = b.ppsuc
             and a.aqpa4dmda = b.ppmda
             and a.aqpa4dpap = b.pppap
             and a.aqpa4dcta = b.ppcta
             and a.aqpa4doper = b.ppoper
             and a.aqpa4dsbop = b.ppsbop
             and a.aqpa4dtope = b.pptope
             and a.aqpa4dfep = b.fec
             and a.aqpa4dcor = b.cor
             and a.aqpa4dnump = b.pp1nump
             and b.d602co = 'S';
        exception
          when others then
            null;
        end;

        if nvl(ln_602Act, 0) = nvl(ln_602Ant, 0) and
           nvl(ln_001Act, 0) = nvl(ln_001Ant, 0) and
           nvl(ln_003Act, 0) = nvl(ln_003Ant, 0) then

          --fsd601
          delete from fsd601 a
           where a.pgcod = i.jaqz698emp
             and a.ppmod = i.jaqz698mod
             and a.ppsuc = i.jaqz698suc
             and a.ppmda = i.jaqz698mda
             and a.pppap = i.jaqz698pap
             and a.ppcta = i.jaqz698cta
             and a.ppoper = i.jaqz698ope
             and a.ppsbop = i.jaqz698sbo
             and a.pptope = i.jaqz698top;
          commit;

          insert into fsd601
            select PGCOD,
                   PPMOD,
                   PPSUC,
                   PPMDA,
                   PPPAP,
                   PPCTA,
                   PPOPER,
                   PPSBOP,
                   PPTOPE,
                   PPFPAG,
                   PPTIPO,
                   PPFVAL,
                   PPFVTO,
                   PPPZO,
                   PPCAP,
                   PPINT,
                   PPINTMEX,
                   PPICAP,
                   PPIINT,
                   PPSTAT,
                   PPNUME,
                   PPFINV,
                   D601CD,
                   D601MO,
                   D601SU,
                   D601TR,
                   D601RE,
                   D601FC,
                   D601OR,
                   D601SB,
                   D601CO
              from JAQZ520_601C t
             where t.pgcod = i.jaqz698emp
               and t.ppmod = i.jaqz698mod
               and t.ppsuc = i.jaqz698suc
               and t.ppmda = i.jaqz698mda
               and t.pppap = i.jaqz698pap
               and t.ppcta = i.jaqz698cta
               and t.ppoper = i.jaqz698ope
               and t.ppsbop = i.jaqz698sbo
               and t.pptope = i.jaqz698top
               and t.fec = i.jaqz698fep
               and t.cor = i.jaqz698cor;

          commit;

          --fsd611
          delete from fsd611 a
           where a.pgcod = i.jaqz698emp
             and a.ppmod = i.jaqz698mod
             and a.ppsuc = i.jaqz698suc
             and a.ppmda = i.jaqz698mda
             and a.pppap = i.jaqz698pap
             and a.ppcta = i.jaqz698cta
             and a.ppoper = i.jaqz698ope
             and a.ppsbop = i.jaqz698sbo
             and a.pptope = i.jaqz698top;

          commit;

          insert into fsd611
            select PGCOD,
                   PPMOD,
                   PPSUC,
                   PPMDA,
                   PPPAP,
                   PPCTA,
                   PPOPER,
                   PPSBOP,
                   PPTOPE,
                   PPFPAG,
                   PPTIPO,
                   PPEXTE,
                   PPIMP1,
                   PPIMP2,
                   PPIMP3,
                   PPIMP4,
                   PPIMP5,
                   PPIMP6,
                   PPIMP7,
                   PPIMP8,
                   PPIMP9,
                   PPIMP10,
                   PPIMP11,
                   PPIMP12,
                   PPIMP13,
                   PPIMP14,
                   PPIMP15,
                   PPIMP16,
                   PPIMP17,
                   PPIMP18,
                   PPIMP19,
                   PPIMP20
              from JAQZ520_611C t
             where t.pgcod = i.jaqz698emp
               and t.ppmod = i.jaqz698mod
               and t.ppsuc = i.jaqz698suc
               and t.ppmda = i.jaqz698mda
               and t.pppap = i.jaqz698pap
               and t.ppcta = i.jaqz698cta
               and t.ppoper = i.jaqz698ope
               and t.ppsbop = i.jaqz698sbo
               and t.pptope = i.jaqz698top
               and t.fec = i.jaqz698fep
               and t.cor = i.jaqz698cor;

          commit;
          --fsd602
          delete from fsd602 a
           where a.pgcod = i.jaqz698emp
             and a.ppmod = i.jaqz698mod
             and a.ppsuc = i.jaqz698suc
             and a.ppmda = i.jaqz698mda
             and a.pppap = i.jaqz698pap
             and a.ppcta = i.jaqz698cta
             and a.ppoper = i.jaqz698ope
             and a.ppsbop = i.jaqz698sbo
             and a.pptope = i.jaqz698top;
          commit;

          insert into fsd602
            select PGCOD,
                   PPMOD,
                   PPSUC,
                   PPMDA,
                   PPPAP,
                   PPCTA,
                   PPOPER,
                   PPSBOP,
                   PPTOPE,
                   PPFPAG,
                   PPTIPO,
                   PP1NUMP,
                   PP1FECH,
                   PP1CAP,
                   PP1INT,
                   PP1INTMEX,
                   PP1INTM,
                   PP1INTMMEX,
                   PP1ICAP,
                   PP1IINT,
                   PP1IINTM,
                   PP1SALCAP,
                   PP1SALINT,
                   PP1SALADE,
                   PP1SALMOR,
                   PP1STAT,
                   PP1SALINTM,
                   PP1SALMORM,
                   PP1SALADEM,
                   D602CD,
                   D602MO,
                   D602SU,
                   D602TR,
                   D602RE,
                   D602FC,
                   D602OR,
                   D602SB,
                   D602CO
              from JAQZ520_602C t
             where t.pgcod = i.jaqz698emp
               and t.ppmod = i.jaqz698mod
               and t.ppsuc = i.jaqz698suc
               and t.ppmda = i.jaqz698mda
               and t.pppap = i.jaqz698pap
               and t.ppcta = i.jaqz698cta
               and t.ppoper = i.jaqz698ope
               and t.ppsbop = i.jaqz698sbo
               and t.pptope = i.jaqz698top
               and t.fec = i.jaqz698fep
               and t.cor = i.jaqz698cor;

          commit;

          --fsd612
          delete from fsd612 a
           where a.pgcod = i.jaqz698emp
             and a.ppmod = i.jaqz698mod
             and a.ppsuc = i.jaqz698suc
             and a.ppmda = i.jaqz698mda
             and a.pppap = i.jaqz698pap
             and a.ppcta = i.jaqz698cta
             and a.ppoper = i.jaqz698ope
             and a.ppsbop = i.jaqz698sbo
             and a.pptope = i.jaqz698top;

          commit;

          insert into fsd612
            select PGCOD,
                   PPMOD,
                   PPSUC,
                   PPMDA,
                   PPPAP,
                   PPCTA,
                   PPOPER,
                   PPSBOP,
                   PPTOPE,
                   PPFPAG,
                   PPTIPO,
                   PP1NUMP,
                   PP1EXTE,
                   PP1IMP1,
                   PP1IMP2,
                   PP1IMP3,
                   PP1IMP4,
                   PP1IMP5,
                   PP1IMP6,
                   PP1IMP7,
                   PP1IMP8,
                   PP1IMP9,
                   PP1IMP10,
                   PP1IMP11,
                   PP1IMP12,
                   PP1IMP13,
                   PP1IMP14,
                   PP1IMP15,
                   PP1IMP16,
                   PP1IMP17,
                   PP1IMP18,
                   PP1IMP19,
                   PP1IMP20,
                   PP1SAL1,
                   PP1SAL2,
                   PP1SAL3,
                   PP1SAL4,
                   PP1SAL5,
                   PP1SAL6,
                   PP1SAL7,
                   PP1SAL8,
                   PP1SAL9,
                   PP1SAL10,
                   PP1SAL11,
                   PP1SAL12,
                   PP1SAL13,
                   PP1SAL14,
                   PP1SAL15,
                   PP1SAL16,
                   PP1SAL17,
                   PP1SAL18,
                   PP1SAL19,
                   PP1SAL20
              from JAQZ520_612C t
             where t.pgcod = i.jaqz698emp
               and t.ppmod = i.jaqz698mod
               and t.ppsuc = i.jaqz698suc
               and t.ppmda = i.jaqz698mda
               and t.pppap = i.jaqz698pap
               and t.ppcta = i.jaqz698cta
               and t.ppoper = i.jaqz698ope
               and t.ppsbop = i.jaqz698sbo
               and t.pptope = i.jaqz698top
               and t.fec = i.jaqz698fep
               and t.cor = i.jaqz698cor;

          commit;

          --fsd010
          update fsd010 u
             set AOFVTO =
                 (select max(AOFVTO)
                    from JAQZ520_010C t
                   where t.pgcod = i.jaqz698emp
                     and t.aomod = i.jaqz698mod
                     and t.aosuc = i.jaqz698suc
                     and t.aomda = i.jaqz698mda
                     and t.aopap = i.jaqz698pap
                     and t.aocta = i.jaqz698cta
                     and t.aooper = i.jaqz698ope
                     and t.aosbop = i.jaqz698sbo
                     and t.aotope = i.jaqz698top
                     and t.fec = i.jaqz698fep
                     and t.cor = i.jaqz698cor),
                 AOPZO =
                 (select max(AOPZO)
                    from JAQZ520_010C t
                   where t.pgcod = i.jaqz698emp
                     and t.aomod = i.jaqz698mod
                     and t.aosuc = i.jaqz698suc
                     and t.aomda = i.jaqz698mda
                     and t.aopap = i.jaqz698pap
                     and t.aocta = i.jaqz698cta
                     and t.aooper = i.jaqz698ope
                     and t.aosbop = i.jaqz698sbo
                     and t.aotope = i.jaqz698top
                     and t.fec = i.jaqz698fep
                     and t.cor = i.jaqz698cor)
           where u.pgcod = i.jaqz698emp
             and u.aomod = i.jaqz698mod
             and u.aosuc = i.jaqz698suc
             and u.aomda = i.jaqz698mda
             and u.aopap = i.jaqz698pap
             and u.aocta = i.jaqz698cta
             and u.aooper = i.jaqz698ope
             and u.aosbop = i.jaqz698sbo
             and u.aotope = i.jaqz698top;

          commit;

          --fsd011

          update fsd011 u
             set scfvto =
                 (select max(scfvto)
                    from JAQZ520_011C t
                   where t.pgcod = i.jaqz698emp
                     and t.scmod = i.jaqz698mod
                     and t.scsuc = i.jaqz698suc
                     and t.scmda = i.jaqz698mda
                     and t.scpap = i.jaqz698pap
                     and t.sccta = i.jaqz698cta
                     and t.scoper = i.jaqz698ope
                     and t.scsbop = i.jaqz698sbo
                     and t.sctope = i.jaqz698top
                     and t.fec = i.jaqz698fep
                     and t.cor = i.jaqz698cor),
                 scpzo =
                 (select max(scpzo)
                    from JAQZ520_011C t
                   where t.pgcod = i.jaqz698emp
                     and t.scmod = i.jaqz698mod
                     and t.scsuc = i.jaqz698suc
                     and t.scmda = i.jaqz698mda
                     and t.scpap = i.jaqz698pap
                     and t.sccta = i.jaqz698cta
                     and t.scoper = i.jaqz698ope
                     and t.scsbop = i.jaqz698sbo
                     and t.sctope = i.jaqz698top
                     and t.fec = i.jaqz698fep
                     and t.cor = i.jaqz698cor)
           where u.pgcod = i.jaqz698emp
             and u.scmod = i.jaqz698mod
             and u.scsuc = i.jaqz698suc
             and u.scmda = i.jaqz698mda
             and u.scpap = i.jaqz698pap
             and u.sccta = i.jaqz698cta
             and u.scoper = i.jaqz698ope
             and u.scsbop = i.jaqz698sbo
             and u.sctope = i.jaqz698top;
          commit;

          --fpp001
          delete from fpp001 a
           where a.pgcod = i.jaqz698emp
             and a.aomod = i.jaqz698mod
             and a.aosuc = i.jaqz698suc
             and a.aomda = i.jaqz698mda
             and a.aopap = i.jaqz698pap
             and a.aocta = i.jaqz698cta
             and a.aooper = i.jaqz698ope
             and a.aosbop = i.jaqz698sbo
             and a.aotope = i.jaqz698top;
          commit;

          insert into fpp001
            select aqpa4cpgcod,
                   aqpa4caomod,
                   aqpa4caosuc,
                   aqpa4caomda,
                   aqpa4caopap,
                   aqpa4caocta,
                   aqpa4caooper,
                   aqpa4caosbop,
                   aqpa4caotope,
                   aqpa4csgcod,
                   --aqpa4cfpro,
                   aqpa4cvc,
                   aqpa4cimp,
                   aqpa4cporc,
                   aqpa4cplus,
                   aqpa4cpart,
                   aqpa4cveh,
                   aqpa4cinm,
                   aqpa4cend,
                   aqpa4cstat,
                   aqpa4cco,
                   aqpa4caux1,
                   aqpa4caux2,
                   aqpa4caux3,
                   aqpa4caux4,
                   aqpa4caux5,
                   aqpa4caux6,
                   aqpa4caux7
              from AQPA004V1 a
             where a.aqpa4cpgcod = i.jaqz698emp
               and a.aqpa4caomod = i.jaqz698mod
               and a.aqpa4caosuc = i.jaqz698suc
               and a.aqpa4caomda = i.jaqz698mda
               and a.aqpa4caopap = i.jaqz698pap
               and a.aqpa4caocta = i.jaqz698cta
               and a.aqpa4caooper = i.jaqz698ope
               and a.aqpa4caosbop = i.jaqz698sbo
               and a.aqpa4caotope = i.jaqz698top
               and a.aqpa4cfep = i.jaqz698fep
               and a.aqpa4ccor = i.jaqz698cor;

          commit;

          --fpp003
          delete from fpp003 a
           where a.pgcod = i.jaqz698emp
             and a.ppmod = i.jaqz698mod
             and a.ppsuc = i.jaqz698suc
             and a.ppmda = i.jaqz698mda
             and a.pppap = i.jaqz698pap
             and a.ppcta = i.jaqz698cta
             and a.ppoper = i.jaqz698ope
             and a.ppsbop = i.jaqz698sbo
             and a.pptope = i.jaqz698top;
          commit;

          insert into fpp003
            select aqpa4dpgcod,
                   aqpa4dmod,
                   aqpa4dsuc,
                   aqpa4dmda,
                   aqpa4dpap,
                   aqpa4dcta,
                   aqpa4doper,
                   aqpa4dsbop,
                   aqpa4dtope,
                   aqpa4dfpag,
                   aqpa4dtipo,
                   aqpa4dnump,
                   aqpa4dprcnc,
                   --aqpa4dfepro,
                   aqpa4dimp,
                   aqpa4dstat,
                   aqpa4daux1,
                   aqpa4daux2,
                   aqpa4daux3

              from AQPA004D1 a
             where a.aqpa4dpgcod = i.jaqz698emp
               and a.aqpa4dmod = i.jaqz698mod
               and a.aqpa4dsuc = i.jaqz698suc
               and a.aqpa4dmda = i.jaqz698mda
               and a.aqpa4dpap = i.jaqz698pap
               and a.aqpa4dcta = i.jaqz698cta
               and a.aqpa4doper = i.jaqz698ope
               and a.aqpa4dsbop = i.jaqz698sbo
               and a.aqpa4dtope = i.jaqz698top
               and a.aqpa4dfep = i.jaqz698fep
               and a.aqpa4dcor = i.jaqz698cor;

          commit;
          --jaqz698
          update jaqz698 a
             set a.jaqz698est = 'V'
           where a.jaqz698emp = i.jaqz698emp
             and a.jaqz698mod = i.jaqz698mod
             and a.jaqz698suc = i.jaqz698suc
             and a.jaqz698mda = i.jaqz698mda
             and a.jaqz698pap = i.jaqz698pap
             and a.jaqz698cta = i.jaqz698cta
             and a.jaqz698ope = i.jaqz698ope
             and a.jaqz698sbo = i.jaqz698sbo
             and a.jaqz698top = i.jaqz698top
             and a.jaqz698fep = i.jaqz698fep
             and a.jaqz698cor = i.jaqz698cor;

          commit;

        end if;

      end loop;
    end;

  end Sp_reversion;

  procedure sp_cr_valida2(pn_emp   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pd_fecBI in date,
                          pn_cor   in number,
                          pc_flg   out varchar2) is

    ld_maxpag date;
    lc_stat   char(1);
    lc_flg    char(1);
    ln_cap    number(17, 2);
    lc_flgCap char(1);
    lc_est    char(1);
    ln_int    number(17, 2);
    ln_mor    number(17, 2);
    ln_seg    number(17, 2);
    ln_pen    number(17, 2);

    cursor cuotas_parc is
      select *
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = ld_maxpag
         and a.pp1stat = 'P'
         and a.d602co = 'S';
  begin
    --verifica si es parcial
    begin
      select max(a.ppfpag)
        into ld_maxpag
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S';
    exception
      when too_many_rows then
        begin
          select max(a.ppfpag)
            into ld_maxpag
            from fsd602 a
           where a.pgcod = pn_emp
             and a.ppmod = pn_mod
             and a.ppsuc = pn_suc
             and a.ppmda = pn_mda
             and a.pppap = pn_pap
             and a.ppcta = pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
             and a.d602co = 'S'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;

    if ld_maxpag is not null then
      begin
        select 'T'
          into lc_stat
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'T'
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
      if lc_stat = 'T' then
        lc_flg := 'S';
      else
        lc_flg := 'P';
      end if;
    else
      lc_flg := 'S';
    end if;

    ---valida si el pago parcial es de MORA
    if lc_flg = 'P' then

      begin
        select nvl(sum(a.pp1cap), 0),
               nvl(sum(a.pp1int), 0),
               nvl(sum(a.pp1intm), 0)
          into ln_cap, ln_int, ln_mor
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;

      begin
        select nvl(sum(a.pp003imp), 0)
          into ln_pen
          from fpp003 a, fsd602 b
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_maxpag
           and a.pp003nump = a.pp003nump
           and prestconc = 3
           and b.pgcod = a.pgcod
           and b.ppmod = a.ppmod
           and b.ppsuc = a.ppsuc
           and b.ppmda = a.ppmda
           and b.pppap = a.pppap
           and b.ppcta = a.ppcta
           and b.ppoper = a.ppoper
           and b.ppsbop = a.ppsbop
           and b.pptope = a.pptope
           and b.ppfpag = a.ppfpag
           and b.pp1stat = 'P'
           and b.d602co = 'S';

      exception
        when others then
          null;

      end;

      --ln_mor := nvl(ln_mor, 0) + nvl(ln_pen, 0);

      begin
        select nvl(sum(c.pp1imp11 + c.pp1imp12 + c.pp1imp13 + c.pp1imp14 +
                       c.pp1imp15),
                   0)
          into Ln_seg
          from fsd602 a, fsd612 c
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_maxpag
           and a.pgcod = c.pgcod
           and a.ppmod = c.ppmod
           and a.ppsuc = c.ppsuc
           and a.ppmda = c.ppmda
           and a.pppap = c.pppap
           and a.ppcta = c.ppcta
           and a.ppoper = c.ppoper
           and a.ppsbop = c.ppsbop
           and a.pptope = c.pptope
           and a.ppfpag = c.ppfpag
           and a.pp1nump = c.pp1nump
           and a.d602co = 'S';
      exception
        when others then
          ln_seg := 0;
      end;

      if nvl(ln_mor, 0) <> 0 then
        lc_flgCap := 'S';
      else
        lc_flgCap := 'N';
      end if;
    end if;

    if lc_flg = 'P' and lc_flgCap = 'N' then
      lc_est := 'B';
      update aqpb002 a
         set a.aqpb002ind  = 'P',
             a.aqpb002ippi = 'N', --es parcial sin pago de mora
             a.aqpb002est  = lc_est
       where a.aqpb002fep = pd_fecBI
         and a.aqpb002cor = pn_cor
         and a.aqpb002emp = pn_emp
         and a.aqpb002mod = pn_mod
         and a.aqpb002suc = pn_suc
         and a.aqpb002mda = pn_mda
         and a.aqpb002pap = pn_pap
         and a.aqpb002cta = pn_cta
         and a.aqpb002ope = pn_ope
         and a.aqpb002sbo = pn_sbo
         and a.aqpb002top = pn_top;
      commit;

    end if;

    if lc_flg = 'P' and lc_flgCap = 'S' then
      --lc_est := 'R';
      lc_est := 'B'; --MOD@ABR 20200331
      update aqpb002 a
         set a.aqpb002ind  = 'P',
             a.aqpb002ippi = 'S', --es parcial con pago de MORA
             a.aqpb002est  = lc_est
       where a.aqpb002fep = pd_fecBI
         and a.aqpb002cor = pn_cor
         and a.aqpb002emp = pn_emp
         and a.aqpb002mod = pn_mod
         and a.aqpb002suc = pn_suc
         and a.aqpb002mda = pn_mda
         and a.aqpb002pap = pn_pap
         and a.aqpb002cta = pn_cta
         and a.aqpb002ope = pn_ope
         and a.aqpb002sbo = pn_sbo
         and a.aqpb002top = pn_top;
      commit;

    end if;

    if lc_flg = 'S' then
      lc_est := 'B';
      update aqpb002 a
         set a.aqpb002est = lc_est
       where a.aqpb002fep = pd_fecBI
         and a.aqpb002cor = pn_cor
         and a.aqpb002emp = pn_emp
         and a.aqpb002mod = pn_mod
         and a.aqpb002suc = pn_suc
         and a.aqpb002mda = pn_mda
         and a.aqpb002pap = pn_pap
         and a.aqpb002cta = pn_cta
         and a.aqpb002ope = pn_ope
         and a.aqpb002sbo = pn_sbo
         and a.aqpb002top = pn_top;

      commit;
    end if;

    --actualizo calendario de pago
    delete from jaqz699_fsd602 a
     where a.jaqz699_fec = pd_fecBI
       and a.jaqz699_cor = pn_cor
       and a.jaqz699pgcod = pn_emp
       and a.jaqz699mod = pn_mod
       and a.jaqz699suc = pn_suc
       and a.jaqz699mda = pn_mda
       and a.jaqz699pap = pn_pap
       and a.jaqz699cta = pn_cta
       and a.jaqz699oper = pn_ope
       and a.jaqz699sbop = pn_sbo
       and a.jaqz699tope = pn_top;
    commit;
    begin
      insert into jaqz699_fsd602

        select pd_fecBI, pn_cor, a.*
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';
    end;
    commit;

    if /*nvl(lc_flgCap, 'N') = 'N' and */
     lc_flg = 'P' then

      for i in cuotas_parc loop

        update fsd602 a
           set a.d602co = 'E'
         where a.pgcod = i.pgcod
           and a.ppmod = i.ppmod
           and a.ppsuc = i.ppsuc
           and a.ppmda = i.ppmda
           and a.pppap = i.pppap
           and a.ppcta = i.ppcta
           and a.ppoper = i.ppoper
           and a.ppsbop = i.ppsbop
           and a.pptope = i.pptope
           and a.pp1nump = i.pp1nump
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';

        commit;

      end loop;

    end if;
    commit;

    update aqpb002 a
       set a.aqpb002cap = ln_cap,
           a.aqpb002int = ln_int,
           a.aqpb002mor = ln_mor,
           a.aqpb002seg = ln_seg,
           a.aqpb002pen = ln_pen
     where a.aqpb002fep = pd_fecBI
       and a.aqpb002cor = pn_cor
       and a.aqpb002emp = pn_emp
       and a.aqpb002mod = pn_mod
       and a.aqpb002suc = pn_suc
       and a.aqpb002mda = pn_mda
       and a.aqpb002pap = pn_pap
       and a.aqpb002cta = pn_cta
       and a.aqpb002ope = pn_ope
       and a.aqpb002sbo = pn_sbo
       and a.aqpb002top = pn_top;
    commit;

    pc_flg := lc_est;

  end sp_cr_valida2;

  Procedure Sp_post_repro2(pn_emp   in number,
                           pn_mod   in number,
                           pn_suc   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_sbo   in number,
                           pn_top   in number,
                           pd_fecBI in date,
                           pn_cor   in number,
                           pd_fecIn in date) is

    cursor bk is
      select *
        from jaqz699_fsd602 a
       where a.jaqz699_fec = pd_fecBI
         and a.jaqz699_cor = pn_cor
         and a.jaqz699pgcod = pn_emp
         and a.jaqz699mod = pn_mod
         and a.jaqz699suc = pn_suc
         and a.jaqz699mda = pn_mda
         and a.jaqz699pap = pn_pap
         and a.jaqz699cta = pn_cta
         and a.jaqz699oper = pn_ope
         and a.jaqz699sbop = pn_sbo
         and a.jaqz699tope = pn_top;

    lc_ind char(1);
    lc_ica char(1);
    lc_err char(1) := 'N';
  begin

    -- validar que es parcial y sin capital
    begin
      select a.aqpb002ind, a.aqpb002ippi
        into lc_ind, lc_ica
        from aqpb002 a
       where a.aqpb002fep = pd_fecBI
         and a.aqpb002cor = pn_cor
         and a.aqpb002emp = pn_emp
         and a.aqpb002mod = pn_mod
         and a.aqpb002suc = pn_suc
         and a.aqpb002mda = pn_mda
         and a.aqpb002pap = pn_pap
         and a.aqpb002cta = pn_cta
         and a.aqpb002ope = pn_ope
         and a.aqpb002sbo = pn_sbo
         and a.aqpb002top = pn_top;
    exception
      when others then
        lc_err := 'S';
        update AQPB002 a
           set a.AQPB002IPPF = lc_err
         where a.aqpb002fep = pd_fecBI
           and a.aqpb002cor = pn_cor
           and a.aqpb002emp = pn_emp
           and a.aqpb002mod = pn_mod
           and a.aqpb002suc = pn_suc
           and a.aqpb002mda = pn_mda
           and a.aqpb002pap = pn_pap
           and a.aqpb002cta = pn_cta
           and a.aqpb002ope = pn_ope
           and a.aqpb002sbo = pn_sbo
           and a.aqpb002top = pn_top;

        commit;
    end;
    --ya no se excluye el parcial con mora ni capital
    if lc_ind = 'P' /*and lc_ica = 'N'*/
     then
      for i in bk loop

        begin
          update fsd612 a
             set a.ppfpag = pd_fecIn, a.pptipo = 'F'
           where a.pgcod = i.jaqz699pgcod
             and a.ppmod = i.jaqz699mod
             and a.ppsuc = i.jaqz699suc
             and a.ppmda = i.jaqz699mda
             and a.pppap = i.jaqz699pap
             and a.ppcta = i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.pp1nump = i.jaqz699nump;

          commit;
        exception
          when others then
            lc_err := 'S';

            update aqpb002 a
               set a.AQPB002IPPF = lc_err
             where a.aqpb002fep = pd_fecBI
               and a.aqpb002cor = pn_cor
               and a.aqpb002emp = pn_emp
               and a.aqpb002mod = pn_mod
               and a.aqpb002suc = pn_suc
               and a.aqpb002mda = pn_mda
               and a.aqpb002pap = pn_pap
               and a.aqpb002cta = pn_cta
               and a.aqpb002ope = pn_ope
               and a.aqpb002sbo = pn_sbo
               and a.aqpb002top = pn_top;

            commit;
        end;

        begin
          update fpp003 a
             set a.ppfpag = pd_fecIn, a.pptipo = 'F'
           where a.pgcod = i.jaqz699pgcod
             and a.ppmod = i.jaqz699mod
             and a.ppsuc = i.jaqz699suc
             and a.ppmda = i.jaqz699mda
             and a.pppap = i.jaqz699pap
             and a.ppcta = i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.pp003nump = i.jaqz699nump
             and prestconc = 3;

          commit;
        exception
          when others then
            lc_err := 'S';

            update aqpb002 a
               set a.AQPB002IPPF = lc_err
             where a.aqpb002fep = pd_fecBI
               and a.aqpb002cor = pn_cor
               and a.aqpb002emp = pn_emp
               and a.aqpb002mod = pn_mod
               and a.aqpb002suc = pn_suc
               and a.aqpb002mda = pn_mda
               and a.aqpb002pap = pn_pap
               and a.aqpb002cta = pn_cta
               and a.aqpb002ope = pn_ope
               and a.aqpb002sbo = pn_sbo
               and a.aqpb002top = pn_top;

            commit;
        end;
        begin
          update fsd602 a
             set a.ppfpag = pd_fecIn, a.d602co = 'S', a.pptipo = 'F'
           where a.pgcod = i.jaqz699pgcod
             and a.ppmod = i.jaqz699mod
             and a.ppsuc = i.jaqz699suc
             and a.ppmda = i.jaqz699mda
             and a.pppap = i.jaqz699pap
             and a.ppcta = i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.pp1nump = i.jaqz699nump
             and a.d602co = 'E';

          commit;
        exception
          when others then
            lc_err := 'S';

            update aqpb002 a
               set a.AQPB002IPPF = lc_err
             where a.aqpb002fep = pd_fecBI
               and a.aqpb002cor = pn_cor
               and a.aqpb002emp = pn_emp
               and a.aqpb002mod = pn_mod
               and a.aqpb002suc = pn_suc
               and a.aqpb002mda = pn_mda
               and a.aqpb002pap = pn_pap
               and a.aqpb002cta = pn_cta
               and a.aqpb002ope = pn_ope
               and a.aqpb002sbo = pn_sbo
               and a.aqpb002top = pn_top;

            commit;
        end;
      end loop;
    end if;
    commit;

  end Sp_post_repro2;

  Procedure Sp_Cr_validaRestric(pn_emp   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pd_fecBI in date,
                                pn_cor   in number,
                                pv_flg   out varchar2) is

    ln_rubro number(16);
    lc_flg   char(1) := 'S';
  begin

    begin
      select a.scrub
        into ln_rubro
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top;
    exception
      when others then
        null;
    end;

    if substr(nvl(ln_rubro, 0), 1, 4) = '1414' or
       substr(nvl(ln_rubro, 0), 1, 4) = '1424' then
      lc_flg := 'R';
    end if;

    if substr(nvl(ln_rubro, 0), 1, 4) = '1416' or
       substr(nvl(ln_rubro, 0), 1, 4) = '1426' then
      lc_flg := 'J';
    end if;
    /*
      if substr(nvl(ln_rubro, 0), 5, 6) = '04' then
        lc_flg := 'H';
      end if;

      if pn_mod = 107 then
        lc_flg := 'C';
      end if;
    */
    update aqpb002 a
       set a.aqpb002ftcre = lc_flg
     where a.aqpb002fep = pd_fecBI
       and a.aqpb002cor = pn_cor
       and a.aqpb002emp = pn_emp
       and a.aqpb002mod = pn_mod
       and a.aqpb002suc = pn_suc
       and a.aqpb002mda = pn_mda
       and a.aqpb002pap = pn_pap
       and a.aqpb002cta = pn_cta
       and a.aqpb002ope = pn_ope
       and a.aqpb002sbo = pn_sbo
       and a.aqpb002top = pn_top;

    commit;
    pv_flg := lc_flg;

  end Sp_Cr_validaRestric;

  /*Procedure sp_cr_UltimaCuota(pn_emp   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pn_ins   in number,
                              pd_fecBI in date,
                              pn_cor   in number)is


  ld_fecpago date;
  ln_ind number(17);
  ln_cap number(17,2);
  ln_Int number(17,2);
  ln_seg number(17,2);
  ln_cuota number(17,2);
  ld_fecpagoI date;
  ln_capI number(17,2);
  ln_IntI number(17,2);
  ln_segI number(17,2);
  ln_cuotaI number(17,2);
  ln_dife number(17,2);
  ln_div  number(17,2);
  ln_tasint    number(10, 5);
  ln_tasaSeg   number(10, 5);
  ln_parcial    number;
  ln_montoPar   number(17, 2);
  ln_montoxtasa number(17, 2);
  ln_mtoapr    number(17, 2);
  ln_newCuotaI number(17,2);
  ln_newCapI number(17,2);
  ln_pzo number(5);
  ln_newCuotanumber(17,2);
  ln_newCap number(17,2);

  begin
         --obtener tasa de interes
         ln_tasint := pq_cr_cuotamora.BT_Tasa_Interes(pn_emp,
                                                      pn_mod,
                                                      pn_suc,
                                                      pn_mda,
                                                      pn_pap,
                                                      pn_cta,
                                                      pn_ope,
                                                      pn_sbo,
                                                      pn_top);


         --obtener tasa de desgravamen

         ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(pn_ins);
         begin
            select 1, sum(sng017mto)
              into ln_parcial, ln_montopar
              from sng001
             Where SNG001Inst = pn_ins
               and sng001ori = 7;
          exception
            when no_data_found then
              ln_parcial := 0;
          end;
          if ln_parcial = 1 and
             ((ln_montopar is not null) and ln_montopar <> 0) then
            ln_montoxtasa := ln_montopar;
          else
            ln_montoxtasa := ln_mtoapr;
          end if;

         ln_tasaSeg := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(pn_emp,
                                                                    pn_mod,
                                                                    pn_suc,
                                                                    pn_mda,
                                                                    pn_pap,
                                                                    pn_cta,
                                                                    pn_ope,
                                                                    pn_sbo,
                                                                    pn_top,
                                                                    ln_montoxtasa);
         --valida si debe aplicar estara en 1
         begin
               select a.jaqz698nu4
                 into ln_ind
                 from jaqz698 a
                where a.jaqz698fep = pd_fecBI
                  and a.jaqz698cor = pn_cor
                  and a.jaqz698emp = pn_emp
                  and a.jaqz698mod = pn_mod
                  and a.jaqz698suc = pn_suc
                  and a.jaqz698mda = pn_mda
                  and a.jaqz698pap = pn_pap
                  and a.jaqz698cta = pn_cta
                  and a.jaqz698ope = pn_ope
                  and a.jaqz698sbo = pn_sbo
                  and a.jaqz698top = pn_top
         exception
                  when others then
                       null;
         end;

         if nvl(ln_ind,0) = 1 then

            --montos ultima cuota
            begin
                 select max(a.ppfpag)
                   into ld_fecpago
                   from fsd601 a
                  where a.pgcod  = pn_emp
                    and a.ppmod  = pn_mod
                    and a.ppsuc  = pn_suc
                    and a.ppmda  = pn_mda
                    and a.pppap  = pn_pap
                    and a.ppcta  = pn_cta
                    and a.ppoper = pn_ope
                    and a.ppsbop = pn_sbo
                    and a.pptope = pn_top
                    and a.d601co = 'S';
           exception
                    when others then
                         null;
           end;

           begin
                 select a.ppcap,a.ppint,a.pppzo
                   into ln_cap, ln_Int, ln_pzo
                   from fsd601 a
                  where a.pgcod  = pn_emp
                    and a.ppmod  = pn_mod
                    and a.ppsuc  = pn_suc
                    and a.ppmda  = pn_mda
                    and a.pppap  = pn_pap
                    and a.ppcta  = pn_cta
                    and a.ppoper = pn_ope
                    and a.ppsbop = pn_sbo
                    and a.pptope = pn_top
                    and a.d601co = 'S'
                    and a.ppfpag = ld_fecpago;
           exception
                    when others then
                         null;
           end;

           begin
                 select a.ppimp11+a.ppimp12+a.ppimp13+a.ppimp14+a.ppimp15
                   into ln_seg
                   from fsd611 a
                  where a.pgcod  = pn_emp
                    and a.ppmod  = pn_mod
                    and a.ppsuc  = pn_suc
                    and a.ppmda  = pn_mda
                    and a.pppap  = pn_pap
                    and a.ppcta  = pn_cta
                    and a.ppoper = pn_ope
                    and a.ppsbop = pn_sbo
                    and a.pptope = pn_top
                    and a.ppfpag = ld_fecpago;
           exception
                    when others then
                         null;
           end;
           ln_cuota := nvl(ln_cap,0) + nvl(ln_Int,0)+nvl(ln_seg,0);

           --montos penultima cuota
           begin
                 select max(a.ppfpag)
                   into ld_fecpagoI
                   from fsd601 a
                  where a.pgcod  = pn_emp
                    and a.ppmod  = pn_mod
                    and a.ppsuc  = pn_suc
                    and a.ppmda  = pn_mda
                    and a.pppap  = pn_pap
                    and a.ppcta  = pn_cta
                    and a.ppoper = pn_ope
                    and a.ppsbop = pn_sbo
                    and a.pptope = pn_top
                    and a.d601co = 'S'
                    and a.ppfpag < ld_fecpago;
           exception
                    when others then
                         null;
           end;

           begin
                 select a.ppcap,a.ppint
                   into ln_capI,ln_IntI
                   from fsd601 a
                  where a.pgcod  = pn_emp
                    and a.ppmod  = pn_mod
                    and a.ppsuc  = pn_suc
                    and a.ppmda  = pn_mda
                    and a.pppap  = pn_pap
                    and a.ppcta  = pn_cta
                    and a.ppoper = pn_ope
                    and a.ppsbop = pn_sbo
                    and a.pptope = pn_top
                    and a.d601co = 'S'
                    and a.ppfpag = ld_fecpagoI;
           exception
                    when others then
                         null;
           end;

           begin
                 select a.ppimp11+a.ppimp12+a.ppimp13+a.ppimp14+a.ppimp15
                   into ln_segI
                   from fsd611 a
                  where a.pgcod  = pn_emp
                    and a.ppmod  = pn_mod
                    and a.ppsuc  = pn_suc
                    and a.ppmda  = pn_mda
                    and a.pppap  = pn_pap
                    and a.ppcta  = pn_cta
                    and a.ppoper = pn_ope
                    and a.ppsbop = pn_sbo
                    and a.pptope = pn_top
                    and a.ppfpag = ld_fecpagoI;
           exception
                    when others then
                         null;
           end;
           ln_cuotaI := nvl(ln_capI,0)+nvl(ln_IntI,0)+nvl(ln_segI,0);


           ln_dife := nvl(ln_cuota,0) - nvl(ln_cuotaI,0);
           ln_div  := nvl(ln_dife,0)/2;

           ln_newCuotaI := nvl(ln_cuotaI,0) + nvl(ln_div,0) ;
           ln_newCapI := nv(ln_newCuotaI,0) - ln_IntI - ln_segI;
           --ln_newCap :=  - ln_newCapI


         end if;


  end sp_cr_UltimaCuota;*/

  ----------------------------------------------------------------------
  -- reversion por cuenta 12.05.2020 mpostigoc
  Procedure Sp_reversionXCta(ln_pgcod     in number,
                             ln_mod       in number,
                             ln_suc       in number,
                             ln_mda       in number,
                             ln_pap       in number,
                             ln_cta       in number,
                             ln_ope       in number,
                             ln_sbop      in number,
                             ln_top       in number,
                             lc_usuario   in char,
                             lc_Resultado out number) is

    cursor creditos_fecha(ld_MaxFch698 date, ld_MaxCorr number) is
      select *
        from jaqz698 a
       where a.jaqz698emp = ln_pgcod
         and a.jaqz698mod = ln_mod
         and a.jaqz698suc = ln_suc
         and a.jaqz698mda = ln_mda
         and a.jaqz698pap = ln_pap
         and a.jaqz698cta = ln_cta
         and a.jaqz698ope = ln_ope
         and a.jaqz698sbo = ln_sbop
         and a.jaqz698top = ln_top
         and a.jaqz698est in ('C')
         and a.jaqz698fep = ld_MaxFch698
         and a.jaqz698cor = ld_MaxCorr;

    cursor creditos_jaqa257 is
      select *
        from jaqa257 a
       where a.jaqa257emp = ln_pgcod
         and a.jaqa257mod = ln_mod
         and a.jaqa257suc = ln_suc
         and a.jaqa257mda = ln_mda
         and a.jaqa257pap = ln_pap
         and a.jaqa257cta = ln_cta
         and a.jaqa257ope = ln_ope
         and a.jaqa257sbo = ln_sbop
         and a.jaqa257tpo = ln_top
         and a.jaqa257est = 'S'
       order by jaqa257fec desc;

    --chernandez 23/07/2020
    cursor creditos_jaqa257Ant(ld_fecvig date) is
      select *
        from (select *
                from jaqa257 a
               where a.jaqa257emp = ln_pgcod
                 and a.jaqa257mod = ln_mod
                 and a.jaqa257suc = ln_suc
                 and a.jaqa257mda = ln_mda
                 and a.jaqa257pap = ln_pap
                 and a.jaqa257cta = ln_cta
                 and a.jaqa257ope = ln_ope
                 and a.jaqa257sbo = ln_sbop
                 and a.jaqa257tpo = ln_top
                 and a.jaqa257est = 'S'
                 and a.jaqa257fec < ld_fecvig
               order by jaqa257fec desc)
       where rownum = 1;

    ln_001Act      number(10);
    ln_001Ant      number(10);
    ln_003Act      number(10);
    ln_003Ant      number(10);
    ln_602Act      number(10);
    ln_602Ant      number(10);
    ld_MaxFch698   date;
    ld_MaxCorr     number;
    ld_FchExtorno  date;
    lc_HoraExtorno char(8) := '00:00:00';
    lc_usuarExtorno char(10);
    ln_sucurExtorno number;

    /*ld_AQPA380FVAL date; 23/07/2020
    ln_aqpa380corr number(10);*/

  begin

    begin
      select max(a.jaqz698fep)
        into ld_MaxFch698
        from jaqz698 a
       where a.jaqz698emp = ln_pgcod
         and a.jaqz698mod = ln_mod
         and a.jaqz698suc = ln_suc
         and a.jaqz698mda = ln_mda
         and a.jaqz698pap = ln_pap
         and a.jaqz698cta = ln_cta
         and a.jaqz698ope = ln_ope
         and a.jaqz698sbo = ln_sbop
         and a.jaqz698top = ln_top
         and a.jaqz698est in ('C');
    exception
      when others then
        null;
    end;

    begin
      select max(a.jaqz698cor)
        into ld_MaxCorr
        from jaqz698 a
       where a.jaqz698emp = ln_pgcod
         and a.jaqz698mod = ln_mod
         and a.jaqz698suc = ln_suc
         and a.jaqz698mda = ln_mda
         and a.jaqz698pap = ln_pap
         and a.jaqz698cta = ln_cta
         and a.jaqz698ope = ln_ope
         and a.jaqz698sbo = ln_sbop
         and a.jaqz698top = ln_top
         and a.jaqz698est in ('C')
         and a.jaqz698fep = ld_MaxFch698;
    exception
      when others then
        ld_MaxCorr := 0;
    end;

    for i in creditos_fecha(ld_MaxFch698, ld_MaxCorr) loop
      --   for i in creditos_corr(j.jaqz698fep) loop

      begin

        select count(*)
          into ln_602Act
          from fsd602 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top
           and a.d602co = 'S';

      exception
        when others then
          null;
      end;

      begin

        select count(*)
          into ln_602Ant
          from JAQZ520_602C t
         where t.pgcod = i.jaqz698emp
           and t.ppmod = i.jaqz698mod
           and t.ppsuc = i.jaqz698suc
           and t.ppmda = i.jaqz698mda
           and t.pppap = i.jaqz698pap
           and t.ppcta = i.jaqz698cta
           and t.ppoper = i.jaqz698ope
           and t.ppsbop = i.jaqz698sbo
           and t.pptope = i.jaqz698top
           and t.d602co = 'S'
           and t.fec = i.jaqz698fep
           and t.cor = i.jaqz698cor;
      exception
        when others then
          null;
      end;

      begin
        select count(*)
          into ln_001Act
          from fpp001 a
         where a.pgcod = i.jaqz698emp
           and a.aomod = i.jaqz698mod
           and a.aosuc = i.jaqz698suc
           and a.aomda = i.jaqz698mda
           and a.aopap = i.jaqz698pap
           and a.aocta = i.jaqz698cta
           and a.aooper = i.jaqz698ope
           and a.aosbop = i.jaqz698sbo
           and a.aotope = i.jaqz698top;
      exception
        when others then
          null;
      end;

      begin
        select count(*)
          into ln_001Ant
          from AQPA004V1 a
         where a.aqpa4cpgcod = i.jaqz698emp
           and a.aqpa4caomod = i.jaqz698mod
           and a.aqpa4caosuc = i.jaqz698suc
           and a.aqpa4caomda = i.jaqz698mda
           and a.aqpa4caopap = i.jaqz698pap
           and a.aqpa4caocta = i.jaqz698cta
           and a.aqpa4caooper = i.jaqz698ope
           and a.aqpa4caosbop = i.jaqz698sbo
           and a.aqpa4caotope = i.jaqz698top
           and a.aqpa4cfep = i.jaqz698fep
           and a.aqpa4ccor = i.jaqz698cor;
      exception
        when others then
          null;
      end;

      begin
        select count(*)
          into ln_003Act
          from fpp003 a, fsd602 b
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top
           and a.pgcod = b.pgcod
           and a.ppmod = b.ppmod
           and a.ppsuc = b.ppsuc
           and a.ppmda = b.ppmda
           and a.pppap = b.pppap
           and a.ppcta = b.ppcta
           and a.ppoper = b.ppoper
           and a.ppsbop = b.ppsbop
           and a.pptope = b.pptope
           and a.pp003nump = b.pp1nump
           and b.d602co = 'S';
      exception
        when others then
          null;
      end;

      begin
        select count(*)
          into ln_003Ant
          from AQPA004D1 a, JAQZ520_602C b
         where a.aqpa4dpgcod = i.jaqz698emp
           and a.aqpa4dmod = i.jaqz698mod
           and a.aqpa4dsuc = i.jaqz698suc
           and a.aqpa4dmda = i.jaqz698mda
           and a.aqpa4dpap = i.jaqz698pap
           and a.aqpa4dcta = i.jaqz698cta
           and a.aqpa4doper = i.jaqz698ope
           and a.aqpa4dsbop = i.jaqz698sbo
           and a.aqpa4dtope = i.jaqz698top
           and a.aqpa4dfep = i.jaqz698fep
           and a.aqpa4dcor = i.jaqz698cor
           and a.aqpa4dpgcod = b.pgcod
           and a.aqpa4dmod = b.ppmod
           and a.aqpa4dsuc = b.ppsuc
           and a.aqpa4dmda = b.ppmda
           and a.aqpa4dpap = b.pppap
           and a.aqpa4dcta = b.ppcta
           and a.aqpa4doper = b.ppoper
           and a.aqpa4dsbop = b.ppsbop
           and a.aqpa4dtope = b.pptope
           and a.aqpa4dfep = b.fec
           and a.aqpa4dcor = b.cor
           and a.aqpa4dnump = b.pp1nump
           and b.d602co = 'S';
      exception
        when others then
          null;
      end;

      if nvl(ln_602Act, 0) = nvl(ln_602Ant, 0) and
         nvl(ln_001Act, 0) = nvl(ln_001Ant, 0) and
         nvl(ln_003Act, 0) = nvl(ln_003Ant, 0) then
        --chernandez 12/07/2020
        PQ_CR_REPROGR_COVID19.Sp_backup_ext(i.jaqz698emp,
                                            i.jaqz698mod,
                                            i.jaqz698suc,
                                            i.jaqz698mda,
                                            i.jaqz698pap,
                                            i.jaqz698cta,
                                            i.jaqz698ope,
                                            i.jaqz698sbo,
                                            i.jaqz698top,
                                            i.jaqz698fep,
                                            i.jaqz698cor);
        --fsd601
        delete from fsd601 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;
        commit;

        insert into fsd601
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PPFVAL,
                 PPFVTO,
                 PPPZO,
                 PPCAP,
                 PPINT,
                 PPINTMEX,
                 PPICAP,
                 PPIINT,
                 PPSTAT,
                 PPNUME,
                 PPFINV,
                 D601CD,
                 D601MO,
                 D601SU,
                 D601TR,
                 D601RE,
                 D601FC,
                 D601OR,
                 D601SB,
                 D601CO
            from JAQZ520_601C t
           where t.pgcod = i.jaqz698emp
             and t.ppmod = i.jaqz698mod
             and t.ppsuc = i.jaqz698suc
             and t.ppmda = i.jaqz698mda
             and t.pppap = i.jaqz698pap
             and t.ppcta = i.jaqz698cta
             and t.ppoper = i.jaqz698ope
             and t.ppsbop = i.jaqz698sbo
             and t.pptope = i.jaqz698top
             and t.fec = i.jaqz698fep
             and t.cor = i.jaqz698cor;

        commit;

        --fsd611
        delete from fsd611 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;

        commit;

        insert into fsd611
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PPEXTE,
                 PPIMP1,
                 PPIMP2,
                 PPIMP3,
                 PPIMP4,
                 PPIMP5,
                 PPIMP6,
                 PPIMP7,
                 PPIMP8,
                 PPIMP9,
                 PPIMP10,
                 PPIMP11,
                 PPIMP12,
                 PPIMP13,
                 PPIMP14,
                 PPIMP15,
                 PPIMP16,
                 PPIMP17,
                 PPIMP18,
                 PPIMP19,
                 PPIMP20
            from JAQZ520_611C t
           where t.pgcod = i.jaqz698emp
             and t.ppmod = i.jaqz698mod
             and t.ppsuc = i.jaqz698suc
             and t.ppmda = i.jaqz698mda
             and t.pppap = i.jaqz698pap
             and t.ppcta = i.jaqz698cta
             and t.ppoper = i.jaqz698ope
             and t.ppsbop = i.jaqz698sbo
             and t.pptope = i.jaqz698top
             and t.fec = i.jaqz698fep
             and t.cor = i.jaqz698cor;

        commit;
        --fsd602
        delete from fsd602 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;
        commit;

        insert into fsd602
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PP1NUMP,
                 PP1FECH,
                 PP1CAP,
                 PP1INT,
                 PP1INTMEX,
                 PP1INTM,
                 PP1INTMMEX,
                 PP1ICAP,
                 PP1IINT,
                 PP1IINTM,
                 PP1SALCAP,
                 PP1SALINT,
                 PP1SALADE,
                 PP1SALMOR,
                 PP1STAT,
                 PP1SALINTM,
                 PP1SALMORM,
                 PP1SALADEM,
                 D602CD,
                 D602MO,
                 D602SU,
                 D602TR,
                 D602RE,
                 D602FC,
                 D602OR,
                 D602SB,
                 D602CO
            from JAQZ520_602C t
           where t.pgcod = i.jaqz698emp
             and t.ppmod = i.jaqz698mod
             and t.ppsuc = i.jaqz698suc
             and t.ppmda = i.jaqz698mda
             and t.pppap = i.jaqz698pap
             and t.ppcta = i.jaqz698cta
             and t.ppoper = i.jaqz698ope
             and t.ppsbop = i.jaqz698sbo
             and t.pptope = i.jaqz698top
             and t.fec = i.jaqz698fep
             and t.cor = i.jaqz698cor;

        commit;

        --fsd612
        delete from fsd612 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;

        commit;

        insert into fsd612
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PP1NUMP,
                 PP1EXTE,
                 PP1IMP1,
                 PP1IMP2,
                 PP1IMP3,
                 PP1IMP4,
                 PP1IMP5,
                 PP1IMP6,
                 PP1IMP7,
                 PP1IMP8,
                 PP1IMP9,
                 PP1IMP10,
                 PP1IMP11,
                 PP1IMP12,
                 PP1IMP13,
                 PP1IMP14,
                 PP1IMP15,
                 PP1IMP16,
                 PP1IMP17,
                 PP1IMP18,
                 PP1IMP19,
                 PP1IMP20,
                 PP1SAL1,
                 PP1SAL2,
                 PP1SAL3,
                 PP1SAL4,
                 PP1SAL5,
                 PP1SAL6,
                 PP1SAL7,
                 PP1SAL8,
                 PP1SAL9,
                 PP1SAL10,
                 PP1SAL11,
                 PP1SAL12,
                 PP1SAL13,
                 PP1SAL14,
                 PP1SAL15,
                 PP1SAL16,
                 PP1SAL17,
                 PP1SAL18,
                 PP1SAL19,
                 PP1SAL20
            from JAQZ520_612C t
           where t.pgcod = i.jaqz698emp
             and t.ppmod = i.jaqz698mod
             and t.ppsuc = i.jaqz698suc
             and t.ppmda = i.jaqz698mda
             and t.pppap = i.jaqz698pap
             and t.ppcta = i.jaqz698cta
             and t.ppoper = i.jaqz698ope
             and t.ppsbop = i.jaqz698sbo
             and t.pptope = i.jaqz698top
             and t.fec = i.jaqz698fep
             and t.cor = i.jaqz698cor;

        commit;

        --fsd010
        update fsd010 u
           set AOFVTO =
               (select max(AOFVTO)
                  from JAQZ520_010C t
                 where t.pgcod = i.jaqz698emp
                   and t.aomod = i.jaqz698mod
                   and t.aosuc = i.jaqz698suc
                   and t.aomda = i.jaqz698mda
                   and t.aopap = i.jaqz698pap
                   and t.aocta = i.jaqz698cta
                   and t.aooper = i.jaqz698ope
                   and t.aosbop = i.jaqz698sbo
                   and t.aotope = i.jaqz698top
                   and t.fec = i.jaqz698fep
                   and t.cor = i.jaqz698cor),
               AOPZO =
               (select max(AOPZO)
                  from JAQZ520_010C t
                 where t.pgcod = i.jaqz698emp
                   and t.aomod = i.jaqz698mod
                   and t.aosuc = i.jaqz698suc
                   and t.aomda = i.jaqz698mda
                   and t.aopap = i.jaqz698pap
                   and t.aocta = i.jaqz698cta
                   and t.aooper = i.jaqz698ope
                   and t.aosbop = i.jaqz698sbo
                   and t.aotope = i.jaqz698top
                   and t.fec = i.jaqz698fep
                   and t.cor = i.jaqz698cor)
         where u.pgcod = i.jaqz698emp
           and u.aomod = i.jaqz698mod
           and u.aosuc = i.jaqz698suc
           and u.aomda = i.jaqz698mda
           and u.aopap = i.jaqz698pap
           and u.aocta = i.jaqz698cta
           and u.aooper = i.jaqz698ope
           and u.aosbop = i.jaqz698sbo
           and u.aotope = i.jaqz698top;

        commit;

        --fsd011

        update fsd011 u
           set scfvto =
               (select max(scfvto)
                  from JAQZ520_011C t
                 where t.pgcod = i.jaqz698emp
                   and t.scmod = i.jaqz698mod
                   and t.scsuc = i.jaqz698suc
                   and t.scmda = i.jaqz698mda
                   and t.scpap = i.jaqz698pap
                   and t.sccta = i.jaqz698cta
                   and t.scoper = i.jaqz698ope
                   and t.scsbop = i.jaqz698sbo
                   and t.sctope = i.jaqz698top
                   and t.fec = i.jaqz698fep
                   and t.cor = i.jaqz698cor),
               scpzo =
               (select max(scpzo)
                  from JAQZ520_011C t
                 where t.pgcod = i.jaqz698emp
                   and t.scmod = i.jaqz698mod
                   and t.scsuc = i.jaqz698suc
                   and t.scmda = i.jaqz698mda
                   and t.scpap = i.jaqz698pap
                   and t.sccta = i.jaqz698cta
                   and t.scoper = i.jaqz698ope
                   and t.scsbop = i.jaqz698sbo
                   and t.sctope = i.jaqz698top
                   and t.fec = i.jaqz698fep
                   and t.cor = i.jaqz698cor)
         where u.pgcod = i.jaqz698emp
           and u.scmod = i.jaqz698mod
           and u.scsuc = i.jaqz698suc
           and u.scmda = i.jaqz698mda
           and u.scpap = i.jaqz698pap
           and u.sccta = i.jaqz698cta
           and u.scoper = i.jaqz698ope
           and u.scsbop = i.jaqz698sbo
           and u.sctope = i.jaqz698top;
        commit;

        --fpp001
        delete from fpp001 a
         where a.pgcod = i.jaqz698emp
           and a.aomod = i.jaqz698mod
           and a.aosuc = i.jaqz698suc
           and a.aomda = i.jaqz698mda
           and a.aopap = i.jaqz698pap
           and a.aocta = i.jaqz698cta
           and a.aooper = i.jaqz698ope
           and a.aosbop = i.jaqz698sbo
           and a.aotope = i.jaqz698top;
        commit;

        insert into fpp001
          select aqpa4cpgcod,
                 aqpa4caomod,
                 aqpa4caosuc,
                 aqpa4caomda,
                 aqpa4caopap,
                 aqpa4caocta,
                 aqpa4caooper,
                 aqpa4caosbop,
                 aqpa4caotope,
                 aqpa4csgcod,
                 --aqpa4cfpro,
                 aqpa4cvc,
                 aqpa4cimp,
                 aqpa4cporc,
                 aqpa4cplus,
                 aqpa4cpart,
                 aqpa4cveh,
                 aqpa4cinm,
                 aqpa4cend,
                 aqpa4cstat,
                 aqpa4cco,
                 aqpa4caux1,
                 aqpa4caux2,
                 aqpa4caux3,
                 aqpa4caux4,
                 aqpa4caux5,
                 aqpa4caux6,
                 aqpa4caux7
            from AQPA004V1 a
           where a.aqpa4cpgcod = i.jaqz698emp
             and a.aqpa4caomod = i.jaqz698mod
             and a.aqpa4caosuc = i.jaqz698suc
             and a.aqpa4caomda = i.jaqz698mda
             and a.aqpa4caopap = i.jaqz698pap
             and a.aqpa4caocta = i.jaqz698cta
             and a.aqpa4caooper = i.jaqz698ope
             and a.aqpa4caosbop = i.jaqz698sbo
             and a.aqpa4caotope = i.jaqz698top
             and a.aqpa4cfep = i.jaqz698fep
             and a.aqpa4ccor = i.jaqz698cor;

        commit;

        --fpp003
        delete from fpp003 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;
        commit;

        insert into fpp003
          select aqpa4dpgcod,
                 aqpa4dmod,
                 aqpa4dsuc,
                 aqpa4dmda,
                 aqpa4dpap,
                 aqpa4dcta,
                 aqpa4doper,
                 aqpa4dsbop,
                 aqpa4dtope,
                 aqpa4dfpag,
                 aqpa4dtipo,
                 aqpa4dnump,
                 aqpa4dprcnc,
                 --aqpa4dfepro,
                 aqpa4dimp,
                 aqpa4dstat,
                 aqpa4daux1,
                 aqpa4daux2,
                 aqpa4daux3

            from AQPA004D1 a
           where a.aqpa4dpgcod = i.jaqz698emp
             and a.aqpa4dmod = i.jaqz698mod
             and a.aqpa4dsuc = i.jaqz698suc
             and a.aqpa4dmda = i.jaqz698mda
             and a.aqpa4dpap = i.jaqz698pap
             and a.aqpa4dcta = i.jaqz698cta
             and a.aqpa4doper = i.jaqz698ope
             and a.aqpa4dsbop = i.jaqz698sbo
             and a.aqpa4dtope = i.jaqz698top
             and a.aqpa4dfep = i.jaqz698fep
             and a.aqpa4dcor = i.jaqz698cor;

        commit;

        --chernandez 10/07/2020
        --verificar jaqa257

        for ff in creditos_jaqa257 loop
          if ff.jaqa257fec >= i.jaqz698fep then
            /*chernandez 23/07/2020
            begin
               select
                max(aqpa380corr)
                 into  ln_aqpa380corr
                 from aqpa380 a
                inner join fsd012 b
                   on aqpa380cod = pgcod
                  and aqpa380mod = aomod
                  and aqpa380suc = aosuc
                  and aqpa380mda = aomda
                  and aqpa380pap = aopap
                  and aqpa380cta = aocta
                  and aqpa380oper = aooper
                  and aqpa380sbop = aosbop
                  and aqpa380tope = aotope
                  and aqpa380tipo = evtipo
                  and aqpa380corr = evcorr
                where aqpa380cod = ln_pgcod
                  and aqpa380mod = ln_mod
                  and aqpa380suc = ln_suc
                  and aqpa380mda = ln_mda
                  and aqpa380pap = ln_pap
                  and aqpa380cta = ln_cta
                  and aqpa380oper = ln_ope
                  and aqpa380sbop = ln_sbop
                  and aqpa380tope = ln_top
                  and aqpa380tipo = 3
                  and aqpa380est = 'H';
               --and d012co = 'S'
             exception
               when others then
                 ld_AQPA380FVAL := ff.jaqa257fre;
                 ln_aqpa380corr := 1;
             end;*/
            if ff.jaqa257nu3 is not null or ff.jaqa257nu3 > 0 then
              --chernandez 09/09/2020 solo considera del proceso de cambio de tasa ya que tambien hay registros de armado de calendario ceci
              update fsd012
                 set d012co = 'E'
               where pgcod = ln_pgcod
                 and aomod = ln_mod
                 and aosuc = ln_suc
                 and aomda = ln_mda
                 and aopap = ln_pap
                 and aocta = ln_cta
                 and aooper = ln_ope
                 and aosbop = ln_sbop
                 and aotope = ln_top
                 and evtipo = 3
                    --and evfval > ld_AQPA380FVAL
                    --and evcorr > ln_aqpa380corr chernandez 23/07/2020
                 and evcorr >= ff.jaqa257nu3;
              --chernandez 09/09/2020
              update fsd012 a
                 set d012co = nvl((select aqpa38012co
                                    from aqpa380
                                   where aqpa380cod = ln_pgcod
                                     and aqpa380mod = ln_mod
                                     and aqpa380suc = ln_suc
                                     and aqpa380mda = ln_mda
                                     and aqpa380pap = ln_pap
                                     and aqpa380cta = ln_cta
                                     and aqpa380oper = ln_ope
                                     and aqpa380sbop = ln_sbop
                                     and aqpa380tope = ln_top
                                     and aqpa380corr = a.evcorr
                                     and aqpa380tipo = a.evtipo
                                     and aqpa380fech = ff.jaqa257fec),
                                  d012co)
               where pgcod = ln_pgcod
                 and aomod = ln_mod
                 and aosuc = ln_suc
                 and aomda = ln_mda
                 and aopap = ln_pap
                 and aocta = ln_cta
                 and aooper = ln_ope
                 and aosbop = ln_sbop
                 and aotope = ln_top
                 and evtipo = 3
                 and evcorr < ff.jaqa257nu3;

              update aqpa380
                 set aqpa380est = 'I'
               where aqpa380cod = ln_pgcod
                 and aqpa380mod = ln_mod
                 and aqpa380suc = ln_suc
                 and aqpa380mda = ln_mda
                 and aqpa380pap = ln_pap
                 and aqpa380cta = ln_cta
                 and aqpa380oper = ln_ope
                 and aqpa380sbop = ln_sbop
                 and aqpa380tope = ln_top
                 and aqpa380fech = ff.jaqa257fec; --chernandez 23/07/2020
              for gg in creditos_jaqa257Ant(ff.jaqa257fec) loop
                update aqpa380
                   set aqpa380est = 'H'
                 where aqpa380cod = ln_pgcod
                   and aqpa380mod = ln_mod
                   and aqpa380suc = ln_suc
                   and aqpa380mda = ln_mda
                   and aqpa380pap = ln_pap
                   and aqpa380cta = ln_cta
                   and aqpa380oper = ln_ope
                   and aqpa380sbop = ln_sbop
                   and aqpa380tope = ln_top
                   and aqpa380fech = gg.jaqa257fec;
              end loop;
            end if;
            update jaqa257
               set jaqa257Est = 'X'
             where jaqa257emp = ln_pgcod
               and jaqa257mod = ln_mod
               and jaqa257suc = ln_suc
               and jaqa257mda = ln_mda
               and jaqa257pap = ln_pap
               and jaqa257cta = ln_cta
               and jaqa257ope = ln_ope
               and jaqa257sbo = ln_sbop
               and jaqa257tpo = ln_top
               and jaqa257fec = ff.jaqa257fec;

          end if;
        end loop;

        -- mpostigoc 05.06.2020
        begin
          select f.pgfape
            into ld_FchExtorno
            from fst017 f
           where f.pgcod = 1;
        exception
          when others then
            null;
        end;

        begin
          select to_char(sysdate, 'HH24:MI:SS')
            into lc_HoraExtorno
            from dual;
        end;

        begin -- agregado 11.10.21 - BBA
           select UBUSER, UBSUC
           into lc_usuarExtorno, ln_sucurExtorno
           from FST046
           where UBUSER = lc_usuario;
        end;

        update jaqz698 a
           set a.jaqz698est  = 'V',
               a.jaqz698fext = ld_FchExtorno,
               a.jaqz698hext = lc_HoraExtorno,
               a.JAQZ698USEXT = lc_usuarExtorno,-- agregado 11.10.21 - BBA
               a.JAQZ698SUEXT = ln_sucurExtorno -- agregado 11.10.21 - BBA
         where a.jaqz698emp = i.jaqz698emp
           and a.jaqz698mod = i.jaqz698mod
           and a.jaqz698suc = i.jaqz698suc
           and a.jaqz698mda = i.jaqz698mda
           and a.jaqz698pap = i.jaqz698pap
           and a.jaqz698cta = i.jaqz698cta
           and a.jaqz698ope = i.jaqz698ope
           and a.jaqz698sbo = i.jaqz698sbo
           and a.jaqz698top = i.jaqz698top
           and a.jaqz698fep = i.jaqz698fep
           and a.jaqz698cor = i.jaqz698cor;
        commit;
        lc_Resultado := 0;
      else
        lc_Resultado := 4;
        if nvl(ln_602Act, 0) <> nvl(ln_602Ant, 0) then
          lc_Resultado := 2;
        else
          if nvl(ln_001Act, 0) <> nvl(ln_001Ant, 0) then
            lc_Resultado := 3;
          else
            if nvl(ln_003Act, 0) <> nvl(ln_003Ant, 0) then
              lc_Resultado := 4;
            end if;
          end if;
        end if;
      end if;
      -- end loop;
    end loop;

  end Sp_reversionXCta;
  --------------------------------------------------------
  /*
  procedure sp_cr_VerfMaxReprg(ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cuenta    in number,
                               ln_operacion in number,
                               ln_sbop      in number,
                               ln_top       in number,
                               lc_Flag      out varchar2,
                               ld_fec       out date,
                               ln_cor       out number) is

    ld_Fch002 date;
    ln_cor002 number(10);
    ld_Fch698 date;
    ln_cor698 number(10);

  begin
    lc_Flag := 'NADA';
    begin
      --select max(a.aqpb002fep)
      --into ld_Fch002
      select aqpb002fep, aqpb002cor
        into ld_Fch002, ln_cor002
        from (select *
                from aqpb002 a
               where a.aqpb002emp = ln_pgcod
                 and a.aqpb002mod = ln_mod
                 and a.aqpb002suc = ln_suc
                 and a.aqpb002mda = ln_mda
                 and a.aqpb002pap = ln_pap
                 and a.aqpb002cta = ln_cuenta
                 and a.aqpb002ope = ln_operacion
                 and a.aqpb002sbo = ln_sbop
                 and a.aqpb002top = ln_top
                 and a.aqpb002est = 'C'
                 and nvl(a.aqpb002revr, 'N') = 'N'
               order by a.aqpb002fep desc)
       where rownum = 1;
    exception
      when others then
        null;
    end;
    begin
      --select max(j.jaqz698fep)
      select jaqz698fep, jaqz698cor
        into ld_Fch698, ln_cor698
        from (select *
                from jaqz698 j
               where j.jaqz698emp = ln_pgcod
                 and j.jaqz698mod = ln_mod
                 and j.jaqz698suc = ln_suc
                 and j.jaqz698mda = ln_mda
                 and j.jaqz698pap = ln_pap
                 and j.jaqz698cta = ln_cuenta
                 and j.jaqz698ope = ln_operacion
                 and j.jaqz698sbo = ln_sbop
                 and j.jaqz698top = ln_top
                 and j.jaqz698est = 'C'
               order by jaqz698fep desc)
       where rownum = 1;
    exception
      when others then
        null;
    end;

    if ld_Fch002 is not null and ld_Fch698 is not null then
      if ld_Fch002 > ld_Fch698 then
        lc_Flag := 'B002';
        ld_fec  := ld_Fch002;
        ln_cor  := ln_cor002;
      else
        if ld_Fch002 < ld_Fch698 then
          lc_Flag := 'Z698';
          ld_fec  := ld_Fch698;
          ln_cor  := ln_cor698;
        else
          if ld_Fch002 = ld_Fch698 then
            lc_Flag := 'NADA';
          end if;
        end if;
      end if;
    else
      if ld_Fch002 is not null and ld_Fch698 is null then
        lc_Flag := 'B002';
        ld_fec  := ld_Fch002;
        ln_cor  := ln_cor002;
      else
        if ld_Fch002 is null and ld_Fch698 is not null then
          lc_Flag := 'Z698';
          ld_fec  := ld_Fch698;
          ln_cor  := ln_cor698;
        end if;
      end if;
    end if;

  end sp_cr_VerfMaxReprg;
  */
  -------------------------------------------------
  --------------------------------------------------------
  procedure sp_cr_VerfMaxReprg(ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cuenta    in number,
                               ln_operacion in number,
                               ln_sbop      in number,
                               ln_top       in number,
                               lc_Flag      out varchar2,
                               ld_fec       out date,
                               ln_cor       out number) is

    ld_Fch002 date;
    ln_cor002 number(10);
    ld_Fch698 date;
    ln_cor698 number(10);
    ld_Fch088 date;
    ln_cor088 number(10);

  begin
    lc_Flag := 'NADA';
    begin
      --select max(a.aqpb002fep)
      --into ld_Fch002
      select aqpb002fep, aqpb002cor
        into ld_Fch002, ln_cor002
        from (select *
                from aqpb002 a
               where a.aqpb002emp = ln_pgcod
                 and a.aqpb002mod = ln_mod
                 and a.aqpb002suc = ln_suc
                 and a.aqpb002mda = ln_mda
                 and a.aqpb002pap = ln_pap
                 and a.aqpb002cta = ln_cuenta
                 and a.aqpb002ope = ln_operacion
                 and a.aqpb002sbo = ln_sbop
                 and a.aqpb002top = ln_top
                 and a.aqpb002est = 'C'
                 and nvl(a.aqpb002revr, 'N') = 'N'
               order by a.aqpb002fep desc)
       where rownum = 1;
    exception
      when others then
        null;
    end;
    begin
      --select max(j.jaqz698fep)
      select jaqz698fep, jaqz698cor
        into ld_Fch698, ln_cor698
        from (select *
                from jaqz698 j
               where j.jaqz698emp = ln_pgcod
                 and j.jaqz698mod = ln_mod
                 and j.jaqz698suc = ln_suc
                 and j.jaqz698mda = ln_mda
                 and j.jaqz698pap = ln_pap
                 and j.jaqz698cta = ln_cuenta
                 and j.jaqz698ope = ln_operacion
                 and j.jaqz698sbo = ln_sbop
                 and j.jaqz698top = ln_top
                 and j.jaqz698est = 'C'
               order by jaqz698fep desc)
       where rownum = 1;
    exception
      when others then
        null;
    end;

    -- jrodriguej 05/02/2021
    begin
      --select max(j.jaqz698fep)
      select aqpb088fep, aqpb088cor
        into ld_Fch088, ln_cor088
        from (select *
                from aqpb088 j
               where j.aqpb088emp = ln_pgcod
                 and j.aqpb088mod = ln_mod
                 and j.aqpb088suc = ln_suc
                 and j.aqpb088mda = ln_mda
                 and j.aqpb088pap = ln_pap
                 and j.aqpb088cta = ln_cuenta
                 and j.aqpb088ope = ln_operacion
                 and j.aqpb088sbo = ln_sbop
                 and j.aqpb088top = ln_top
                 and j.aqpb088est = 'C'
               order by aqpb088fep desc)
       where rownum = 1;
    exception
      when others then
        null;
    end;
    -- jrodriguej 05/02/2021

    if ld_Fch002 is not null and ld_Fch698 is not null and
       ld_Fch088 is not null then
      --- primera condición
      if ld_Fch002 > ld_Fch698 and ld_Fch002 > ld_Fch088 then
        lc_Flag := 'B002';
        ld_fec  := ld_Fch002;
        ln_cor  := ln_cor002;
      else
        if ld_Fch698 > ld_Fch002 and ld_Fch698 > ld_Fch088 then
          lc_Flag := 'Z698';
          ld_fec  := ld_Fch698;
          ln_cor  := ln_cor698;
        else
          if ld_Fch088 > ld_Fch698 and ld_Fch088 > ld_Fch002 then
            lc_Flag := 'B088';
            ld_fec  := ld_Fch088;
            ln_cor  := ln_cor088;
          else

            if ld_Fch002 = ld_Fch698 and ld_Fch698 = ld_Fch088 then
              lc_Flag := 'NADA';
            end if;
          end if;

        end if;
      end if;
      ---
    else
      ---
      if ld_Fch002 is null and ld_Fch698 is null and ld_Fch088 is null then
        -- A: 0    B: 0   C: 0
        lc_Flag := 'NADA';
        ld_fec  := NULL;
        ln_cor  := NULL;
      elsif ld_Fch002 is null and ld_Fch698 is null and
            ld_Fch088 is not null then
        -- A: 0    B: 0   C: 1
        lc_Flag := 'B088';
        ld_fec  := ld_Fch088;
        ln_cor  := ln_cor088;
        --end if;
      elsif ld_Fch002 is null and ld_Fch698 is not null and
            ld_Fch088 is null then
        -- A: 0    B: 1   C: 0
        lc_Flag := 'Z698';
        ld_fec  := ld_Fch698;
        ln_cor  := ln_cor698;
      elsif ld_Fch002 is null and ld_Fch698 is not null and
            ld_Fch088 is not null then
        -- A: 0    B: 1   C: 1

        if ld_Fch698 > ld_Fch088 then
          lc_Flag := 'Z698';
          ld_fec  := ld_Fch698;
          ln_cor  := ln_cor698;
        else
          if ld_Fch088 > ld_Fch698 then
            lc_Flag := 'B088';
            ld_fec  := ld_Fch088;
            ln_cor  := ln_cor088;
          else

            if ld_Fch088 = ld_Fch698 then
              lc_Flag := 'NADA';
            end if;
          end if;
        end if;
        ---
      elsif ld_Fch002 is not null and ld_Fch698 is null and
            ld_Fch088 is null then
        -- A: 1    B: 0   C: 0
        lc_Flag := 'B002';
        ld_fec  := ld_Fch002;
        ln_cor  := ln_cor002;

      elsif ld_Fch002 is not null and ld_Fch698 is null and
            ld_Fch088 is not null then
        -- A: 1    B: 0   C: 1

        if ld_Fch002 > ld_Fch088 then
          lc_Flag := 'B002';
          ld_fec  := ld_Fch002;
          ln_cor  := ln_cor002;
        else
          if ld_Fch088 > ld_Fch002 then
            lc_Flag := 'B088';
            ld_fec  := ld_Fch088;
            ln_cor  := ln_cor088;
          else

            if ld_Fch088 = ld_Fch002 then
              lc_Flag := 'NADA';
            end if;
          end if;
        end if;
        ---

      elsif ld_Fch002 is not null and ld_Fch698 is not null and
            ld_Fch088 is null then
        -- A: 1    B: 1   C: 0

        if ld_Fch002 > ld_Fch698 then
          lc_Flag := 'B002';
          ld_fec  := ld_Fch002;
          ln_cor  := ln_cor002;
        else
          if ld_Fch698 > ld_Fch002 then
            lc_Flag := 'Z698';
            ld_fec  := ld_Fch698;
            ln_cor  := ln_cor698;
          else

            if ld_Fch698 = ld_Fch002 then
              lc_Flag := 'NADA';
            end if;
          end if;
        end if;
        ---

      end if;

    end if;

  end sp_cr_VerfMaxReprg;
  -------------------------------------------------

  --chernandez 10/07/2020 se agrego parametro
  procedure sp_cr_CargaGrilla(ln_pgcod     in number,
                              ln_cuenta    in number,
                              ln_operacion in number) is

    cursor lista_repr is
      select AQPB002SUC ln_sucursal,
             AQPB002CTA ln_cuenta,
             AQPB002OPE ln_operacion,
             AQPB002EMP ln_pgcod,
             AQPB002MOD ln_modulo,
             AQPB002MDA ln_moneda,
             AQPB002PAP ln_papel,
             AQPB002SBO ln_sbop,
             AQPB002TOP ln_toper,
             AQPB002FEP ld_reprog,
             AQPB002COR ld_corr,
             nvl(AQPB002MORA, 'S') lc_mora,
             AQPB002FCTR ld_feccontrol,
             a.aqpb002fei ld_fchori
        from aqpb002 a
       where a.aqpb002emp = ln_pgcod --chernandez 10/07/2020
         and a.aqpb002cta = ln_cuenta
         and a.aqpb002ope = ln_operacion
         and a.aqpb002pro10 = 'S'
         and a.aqpb002pro11 = 'S'
         and a.aqpb002pro601 = 'S'
         and a.aqpb002pro611 = 'S'
         and a.aqpb002est = 'C'
         and nvl(a.aqpb002revr, 'N') = 'N'
         and exists (select *
                from fsd010
               where pgcod = a.aqpb002emp
                 and aomod = a.aqpb002mod
                 and aosuc = a.aqpb002suc
                 and aomda = a.aqpb002mda
                 and aopap = a.aqpb002pap
                 and aocta = a.aqpb002cta
                 and aooper = a.aqpb002ope
                 and aosbop = a.aqpb002sbo
                 and aotope = a.aqpb002top
                 and aostat <> 99)
      union
      select j.jaqz698suc ln_sucursal,
             j.jaqz698cta ln_cuenta,
             j.jaqz698ope ln_operacion,
             j.jaqz698emp ln_pgcod,
             j.jaqz698mod ln_modulo,
             j.jaqz698mda ln_moneda,
             j.jaqz698pap ln_papel,
             j.jaqz698sbo ln_sbop,
             j.jaqz698top ln_toper,
             j.jaqz698fep ld_reprog,
             j.jaqz698cor ld_corr,
             nvl(j.jaqz698mora, 'S') ln_mora,
             j.jaqz698fep ld_feccontrol,
             j.jaqz698fev ld_fchori
        from jaqz698 j
       where j.jaqz698emp = ln_pgcod --chernandez 10/07/2020
         and j.jaqz698cta = ln_cuenta
         and j.jaqz698ope = ln_operacion
         and j.jaqz698est = 'C'
         and exists (select *
                from fsd010
               where pgcod = j.jaqz698emp
                 and aomod = j.jaqz698mod
                 and aosuc = j.jaqz698suc
                 and aomda = j.jaqz698mda
                 and aopap = j.jaqz698pap
                 and aocta = j.jaqz698cta
                 and aooper = j.jaqz698ope
                 and aosbop = j.jaqz698sbo
                 and aotope = j.jaqz698top
                 and aostat <> 99)
      union

      select k.aqpb088suc ln_sucursal,
             k.aqpb088cta ln_cuenta,
             k.aqpb088ope ln_operacion,
             k.aqpb088emp ln_pgcod,
             k.aqpb088mod ln_modulo,
             k.aqpb088mda ln_moneda,
             k.aqpb088pap ln_papel,
             k.aqpb088sbo ln_sbop,
             k.aqpb088top ln_toper,
             k.aqpb088fep ld_reprog,
             k.aqpb088cor ld_corr,
             nvl(k.aqpb088mora, 'S') ln_mora,
             k.aqpb088fep ld_feccontrol,
             k.aqpb088fev ld_fchori
        from aqpb088 k
       where k.aqpb088emp = ln_pgcod --chernandez 10/07/2020
         and k.aqpb088cta = ln_cuenta
         and k.aqpb088ope = ln_operacion
         and k.aqpb088est = 'C'
         and exists (select *
                from fsd010
               where pgcod = k.aqpb088emp
                 and aomod = k.aqpb088mod
                 and aosuc = k.aqpb088suc
                 and aomda = k.aqpb088mda
                 and aopap = k.aqpb088pap
                 and aocta = k.aqpb088cta
                 and aooper = k.aqpb088ope
                 and aosbop = k.aqpb088sbo
                 and aotope = k.aqpb088top
                 and aostat <> 99)

      ;

    ln_pais      number;
    ln_tdoc      number;
    lc_ndoc      varchar2(12);
    lc_nombre    varchar2(150);
    lc_nombage   varchar2(50);
    ln_corr      number := 0;
    ld_fchInsert date;
    lc_hora      char(8) := '00:00:00';

  begin

    begin
      delete aqpa376 a
       where a.aqpa376pgcod = ln_pgcod --chernandez 10/07/2020
         and a.aqpa376cta = ln_cuenta
         and a.aqpa376ope = ln_operacion;
      commit;
    end;

    begin
      begin
        select f.pepais, f.petdoc, f.pendoc
          into ln_pais, ln_tdoc, lc_ndoc
          from fsr008 f
         where f.pgcod = 1
           and f.ctnro = ln_cuenta
           and f.cttfir = 'T';
      exception
        --mpostigoc 05.06.2020
        when others then
          null;
      end;

      begin
        select f.pgfape into ld_fchInsert from fst017 f where f.pgcod = 1;
      exception
        when others then
          null;
      end;

      If ln_tdoc = 21 and ln_pais = 604 then
        begin
          select Trim(Pfape1) || ' ' || Trim(Pfape2) || ' ' || Trim(Pfnom1) || ' ' ||
                 Trim(Pfnom2)
            into lc_nombre
            from FSD002
           Where Pfpais = ln_pais
             and Pftdoc = ln_tdoc
             and Pfndoc = rpad(lc_ndoc,12,' ');
        exception
          when others then
            null;
        end;

      else
        If ln_tdoc = 9 and ln_pais = 604 then
          begin
            select Trim(Pjrazs)
              into lc_nombre
              from fsd003
             Where Pjpais = ln_pais
               and Pjtdoc = ln_tdoc
               and Pjndoc = rpad(lc_ndoc,12,' ');
          exception
            when others then
              null;
          end;
        End If;
      End If;
    end;

    for l in lista_repr loop

      begin
        select max(a.aqpa376corr)
          into ln_corr
          from aqpa376 a
         where a.aqpa376pgcod = ln_pgcod --chernandez 10/07/2020
           and a.aqpa376cta = ln_cuenta
           and a.aqpa376ope = ln_operacion;
      exception
        when others then
          null;
      end;

      ln_corr := nvl(ln_corr, 0);
      begin
        select f.scnom
          into lc_nombage
          from fst001 f
         where f.pgcod = 1
           and f.sucurs = l.ln_sucursal;
      exception
        --mpostigoc 05.06.2020
        when others then
          null;
      end;

      begin
        select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
      end;

      insert into aqpa376
        (aqpa376corr,
         aqpa376pais,
         aqpa376tdoc,
         aqpa376ndoc,
         aqpa376nomb,
         aqpa376pgcod,
         aqpa376mod,
         aqpa376suc,
         aqpa376mda,
         aqpa376pap,
         aqpa376cta,
         aqpa376ope,
         aqpa376sbo,
         aqpa376top,
         aqpa376age,
         aqpa376frep,
         aqpa376corre,
         aqpa376mora,
         aqpa376fctrl,
         aqpa376fori,
         aqpa376finsr,
         aqpa376hinsr)
      values
        (ln_corr + 1,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         lc_nombre,
         l.ln_pgcod,
         l.ln_modulo,
         l.ln_sucursal,
         l.ln_moneda,
         l.ln_papel,
         l.ln_cuenta,
         l.ln_operacion,
         l.ln_sbop,
         l.ln_toper,
         lc_nombage,
         l.ld_reprog,
         l.ld_corr,
         l.lc_mora,
         l.ld_feccontrol,
         l.ld_fchori,
         ld_fchInsert,
         lc_hora);
      commit;
    end loop;
  end sp_cr_CargaGrilla;
  --------------------------------------------------
  Procedure Sp_Up_MailTlfn_698(pn_emp      in number,
                               pn_mod      in number,
                               pn_suc      in number,
                               pn_mda      in number,
                               pn_pap      in number,
                               pn_cta      in number,
                               pn_ope      in number,
                               pn_sbo      in number,
                               pn_top      in number,
                               pd_fec      in date,
                               pv_correo   in varchar2,
                               pv_telefono in varchar2) is
  begin
    update jaqz698 j
       set j.jaqz698mail = pv_correo, j.jaqz698tlfn = pv_telefono
     where j.jaqz698emp = pn_emp
       and j.jaqz698mod = pn_mod
       and j.jaqz698suc = pn_suc
       and j.jaqz698mda = pn_mda
       and j.jaqz698pap = pn_pap
       and j.jaqz698cta = pn_cta
       and j.jaqz698ope = pn_ope
       and j.jaqz698sbo = pn_sbo
       and j.jaqz698top = pn_top
       and j.jaqz698fep = pd_fec
       and j.jaqz698est = 'V';
    commit;

  end Sp_Up_MailTlfn_698;
  --------------------------------------------------
  --chernandez 12/07/2020
  Procedure Sp_backup_ext(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pn_cor in number) is

    -- MODIFCADO : DCASTRO 2017.05.17 Se detallo campos a insertar en JAQZ525_519

  begin
    begin
      delete from jaqz525_010C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from jaqz525_011C a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from jaqz525_601C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from jaqz525_611C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from jaqz525_602C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from jaqz525_612C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from jaqz525_003C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fep = pd_fec
         and a.cor = pn_cor;

      delete from jaqz525_002C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fecha = pd_fec
         and a.corre = pn_cor;

      delete from jaqz525_012C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fecha = pd_fec
         and a.corre = pn_cor;

      delete from jaqz525_001C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fep = pd_fec
         and a.cor = pn_cor;

      insert into jaqz525_010C
        select a.*, pd_fec, pn_cor
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;

      insert into jaqz525_011C
        select a.*, pd_fec, pn_cor
          from fsd011 a
         where a.pgcod = pn_emp
           and a.scmod = pn_mod
           and a.scsuc = pn_suc
           and a.scmda = pn_mda
           and a.scpap = pn_pap
           and a.sccta = pn_cta
           and a.scoper = pn_ope
           and a.scsbop = pn_sbo
           and a.sctope = pn_top;

      insert into jaqz525_601C
        select a.*, pd_fec, pn_cor
          from fsd601 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into jaqz525_611C
        select a.*, pd_fec, pn_cor
          from fsd611 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into jaqz525_602C
        select a.*, pd_fec, pn_cor
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into jaqz525_612C
        select a.*, pd_fec, pn_cor
          from fsd612 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into jaqz525_003C
        select a.*, pd_fec, pn_cor
          from fpp003 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into jaqz525_002C
        select a.*, pd_fec, pn_cor
          from fpp002 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into jaqz525_012C
        select a.*, pd_fec, pn_cor
          from fsd012 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;

      insert into jaqz525_001C
        select a.*, pd_fec, pn_cor
          from fpp001 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
      commit;
    exception
      when others then
        null;
    end;

  end Sp_backup_ext;

  -------------------------------------------------- jrodriguej 06.02.2021
  Procedure Sp_reversionXCta88(ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cta       in number,
                               ln_ope       in number,
                               ln_sbop      in number,
                               ln_top       in number,
                               lc_usuario   in char,
                               lc_Resultado out number) is

    cursor creditos_fecha(ld_MaxFch698 date, ld_MaxCorr number) is
      select *
        from aqpb088 a
       where a.aqpb088emp = ln_pgcod
         and a.aqpb088mod = ln_mod
         and a.aqpb088suc = ln_suc
         and a.aqpb088mda = ln_mda
         and a.aqpb088pap = ln_pap
         and a.aqpb088cta = ln_cta
         and a.aqpb088ope = ln_ope
         and a.aqpb088sbo = ln_sbop
         and a.aqpb088top = ln_top
         and a.aqpb088est in ('C')
         and a.aqpb088fep = ld_MaxFch698
         and a.aqpb088cor = ld_MaxCorr;

    ln_001Act      number(10);
    ln_001Ant      number(10);
    ln_003Act      number(10);
    ln_003Ant      number(10);
    ln_602Act      number(10);
    ln_602Ant      number(10);
    ld_MaxFch698   date;
    ld_MaxCorr     number;
    ld_FchExtorno  date;
    lc_HoraExtorno char(8) := '00:00:00';
    lc_flagExt     varchar2(1);
    --lc_cont12      number;
    lc_contExt     number;

    ln_contador    number;  --20210908
    ln_tasa        number;  --20210908
    ln_habil       number;  --20210908
    lc_usuarExtorno char(10); --
    ln_sucurExtorno number; --
    /*ld_AQPA380FVAL date; 23/07/2020
    ln_aqpa380corr number(10);*/

  begin

    begin
      select max(a.aqpb088fep)
        into ld_MaxFch698
        from aqpb088 a
       where a.aqpb088emp = ln_pgcod
         and a.aqpb088mod = ln_mod
         and a.aqpb088suc = ln_suc
         and a.aqpb088mda = ln_mda
         and a.aqpb088pap = ln_pap
         and a.aqpb088cta = ln_cta
         and a.aqpb088ope = ln_ope
         and a.aqpb088sbo = ln_sbop
         and a.aqpb088top = ln_top
         and a.aqpb088est in ('C');
    exception
      when others then
        null;
    end;

    begin
      select max(a.aqpb088cor)
        into ld_MaxCorr
        from aqpb088 a
       where a.aqpb088emp = ln_pgcod
         and a.aqpb088mod = ln_mod
         and a.aqpb088suc = ln_suc
         and a.aqpb088mda = ln_mda
         and a.aqpb088pap = ln_pap
         and a.aqpb088cta = ln_cta
         and a.aqpb088ope = ln_ope
         and a.aqpb088sbo = ln_sbop
         and a.aqpb088top = ln_top
         and a.aqpb088est in ('C')
         and a.aqpb088fep = ld_MaxFch698;
    exception
      when others then
        ld_MaxCorr := 0;
    end;

    for i in creditos_fecha(ld_MaxFch698, ld_MaxCorr) loop
      --   for i in creditos_corr(j.jaqz698fep) loop

      -- Verificación de casos con registros backups extornados (E) pero en la tabla oficial
      -- manteni+endo un estado vigente (S)
      update AQPB088_602C t
         set t.d602co = 'S'
       where exists (select 'x'
                from fsd602 a
               where a.PGCOD = t.pgcod
                 and a.PPMOD = t.ppmod
                 and a.PPSUC = t.ppsuc
                 and a.PPMDA = t.ppmda
                 and a.PPPAP = t.pppap
                 and a.PPCTA = t.ppcta
                 and a.PPOPER = t.ppoper
                 and a.PPSBOP = t.ppsbop
                 and a.PPTOPE = t.pptope
                 and a.PPTIPO = t.pptipo
                 and a.PP1NUMP = t.pp1nump
                 and a.d602cd = t.d602cd
                 and a.d602mo = t.d602mo
                 and a.d602su = t.d602su
                 and a.d602tr = t.d602tr
                 and a.d602re = t.d602re
                 and a.d602fc = t.d602fc
                 and a.pp1cap = 0
                 and a.d602co = 'S')

         and t.pgcod = i.aqpb088emp
         and t.ppmod = i.aqpb088mod
         and t.ppsuc = i.aqpb088suc
         and t.ppmda = i.aqpb088mda
         and t.pppap = i.aqpb088pap
         and t.ppcta = i.aqpb088cta
         and t.ppoper = i.aqpb088ope
         and t.ppsbop = i.aqpb088sbo
         and t.pptope = i.aqpb088top
         and t.fec = i.aqpb088fep
         and t.cor = i.aqpb088cor
         and t.pp1cap = 0
         and t.d602fc <= i.aqpb088fep
         and t.d602co = 'E';
   commit;

      --- Validaciones

      begin

        select count(*)
          into ln_602Act
          from fsd602 a
         where a.pgcod = i.aqpb088emp
           and a.ppmod = i.aqpb088mod
           and a.ppsuc = i.aqpb088suc
           and a.ppmda = i.aqpb088mda
           and a.pppap = i.aqpb088pap
           and a.ppcta = i.aqpb088cta
           and a.ppoper = i.aqpb088ope
           and a.ppsbop = i.aqpb088sbo
           and a.pptope = i.aqpb088top
           and a.d602co = 'S';

      exception
        when others then
          null;
      end;

      begin

        select count(*)
          into ln_602Ant
          from aqpb088_602c t
         where t.pgcod = i.aqpb088emp
           and t.ppmod = i.aqpb088mod
           and t.ppsuc = i.aqpb088suc
           and t.ppmda = i.aqpb088mda
           and t.pppap = i.aqpb088pap
           and t.ppcta = i.aqpb088cta
           and t.ppoper = i.aqpb088ope
           and t.ppsbop = i.aqpb088sbo
           and t.pptope = i.aqpb088top
           and t.d602co = 'S'
           and t.fec = i.aqpb088fep
           and t.cor = i.aqpb088cor;

      exception
        when others then
          null;
      end;

      begin
        select count(*)
          into ln_001Act
          from fpp001 a
         where a.pgcod = i.aqpb088emp
           and a.aomod = i.aqpb088mod
           and a.aosuc = i.aqpb088suc
           and a.aomda = i.aqpb088mda
           and a.aopap = i.aqpb088pap
           and a.aocta = i.aqpb088cta
           and a.aooper = i.aqpb088ope
           and a.aosbop = i.aqpb088sbo
           and a.aotope = i.aqpb088top;
      exception
        when others then
          null;
      end;

      begin
        select count(*)
          into ln_001Ant
          from AQPB088_001C a -- AQPA004V1 --> AQPB088_001C
         where a.aqpa4cpgcod = i.aqpb088emp
           and a.aqpa4caomod = i.aqpb088mod
           and a.aqpa4caosuc = i.aqpb088suc
           and a.aqpa4caomda = i.aqpb088mda
           and a.aqpa4caopap = i.aqpb088pap
           and a.aqpa4caocta = i.aqpb088cta
           and a.aqpa4caooper = i.aqpb088ope
           and a.aqpa4caosbop = i.aqpb088sbo
           and a.aqpa4caotope = i.aqpb088top
           and a.aqpa4cfep = i.aqpb088fep
           and a.aqpa4ccor = i.aqpb088cor;
      exception
        when others then
          null;
      end;

      begin
        select count(*)
          into ln_003Act
          from fpp003 a, fsd602 b
         where a.pgcod = i.aqpb088emp
           and a.ppmod = i.aqpb088mod
           and a.ppsuc = i.aqpb088suc
           and a.ppmda = i.aqpb088mda
           and a.pppap = i.aqpb088pap
           and a.ppcta = i.aqpb088cta
           and a.ppoper = i.aqpb088ope
           and a.ppsbop = i.aqpb088sbo
           and a.pptope = i.aqpb088top
           and a.pgcod = b.pgcod
           and a.ppmod = b.ppmod
           and a.ppsuc = b.ppsuc
           and a.ppmda = b.ppmda
           and a.pppap = b.pppap
           and a.ppcta = b.ppcta
           and a.ppoper = b.ppoper
           and a.ppsbop = b.ppsbop
           and a.pptope = b.pptope
           and a.pp003nump = b.pp1nump
           and b.d602co = 'S';
      exception
        when others then
          null;
      end;

      begin
        select count(*)
          into ln_003Ant
          from AQPB088_003C a, AQPB088_602C b
         where a.aqpa4dpgcod = i.aqpb088emp
           and a.aqpa4dmod = i.aqpb088mod
           and a.aqpa4dsuc = i.aqpb088suc
           and a.aqpa4dmda = i.aqpb088mda
           and a.aqpa4dpap = i.aqpb088pap
           and a.aqpa4dcta = i.aqpb088cta
           and a.aqpa4doper = i.aqpb088ope
           and a.aqpa4dsbop = i.aqpb088sbo
           and a.aqpa4dtope = i.aqpb088top
           and a.aqpa4dfep = i.aqpb088fep
           and a.aqpa4dcor = i.aqpb088cor
           and a.aqpa4dpgcod = b.pgcod
           and a.aqpa4dmod = b.ppmod
           and a.aqpa4dsuc = b.ppsuc
           and a.aqpa4dmda = b.ppmda
           and a.aqpa4dpap = b.pppap
           and a.aqpa4dcta = b.ppcta
           and a.aqpa4doper = b.ppoper
           and a.aqpa4dsbop = b.ppsbop
           and a.aqpa4dtope = b.pptope
           and a.aqpa4dfep = b.fec
           and a.aqpa4dcor = b.cor
           and a.aqpa4dnump = b.pp1nump
           and b.d602co = 'S';
      exception
        when others then
          null;
      end;

      --- Validación asiento, interes de cambio de tasa or reprogramación gobierno
      --- Esta transaccion debe ser extornada
      begin
        select count(*)
          into lc_contExt
          from fsd011 x
         where x.pgcod = i.aqpb088emp
           and x.scrub = '9500095000000'
           and x.scmda = i.aqpb088mda
           and x.sccta = i.aqpb088cta
           and x.scoper = i.aqpb088ope
           --apachecoh 2023.01.31 Ultima reprogramación realizada
           and x.scfcon = (select max(JAQA400FEC)
                             from jaqa400
                            where JAQA400EMP = i.aqpb088emp
                              and JAQA400MDA = i.aqpb088mda
                              and JAQA400CTA = i.aqpb088cta
                              and JAQA400OPE = i.aqpb088ope
                              and JAQA400EST = 'C');
      exception
        when others then
          lc_contExt := 0;
      end;

      --20210908 dcastro verificar si pagos de backup se extornaron en fsd602
      begin
        select f.tp1nro1
         into ln_habil
        from fst198 f
        where f.tp1cod = 1
          and f.tp1cod1 = 10899
          and f.tp1corr1 = 400000
          and f.tp1corr2 = 300
          and f.tp1corr3 = 1;
      exception when others then
         ln_habil := 0;
      end;

      if ln_habil = 1   then  -- si esta habilitado

          if nvl(ln_602Act, 0) < nvl(ln_602Ant, 0) then --
            begin
                pq_cr_reprogr_covid19.sp_up_aqpb602_088(pn_emp => i.aqpb088emp,
                                                        pn_mod => i.aqpb088mod,
                                                        pn_suc => i.aqpb088suc,
                                                        pn_mda => i.aqpb088mda,
                                                        pn_pap => i.aqpb088pap,
                                                        pn_cta => i.aqpb088cta,
                                                        pn_ope => i.aqpb088ope,
                                                        pn_sbo => i.aqpb088sbo,
                                                        pn_top => i.aqpb088top,
                                                        pd_fec => i.aqpb088fep,
                                                        pn_cor => i.aqpb088cor);
              end;

              --obteniendo nuevamente conteo de pagos en backup
              begin

                select count(*)
                  into ln_602Ant
                  from aqpb088_602c t
                 where t.pgcod =  i.aqpb088emp
                   and t.ppmod =  i.aqpb088mod
                   and t.ppsuc =  i.aqpb088suc
                   and t.ppmda =  i.aqpb088mda
                   and t.pppap =  i.aqpb088pap
                   and t.ppcta =  i.aqpb088cta
                   and t.ppoper = i.aqpb088ope
                   and t.ppsbop = i.aqpb088sbo
                   and t.pptope = i.aqpb088top
                   and t.d602co = 'S'
                   and t.fec = i.aqpb088fep
                   and t.cor = i.aqpb088cor;

              exception
                when others then
                  null;
              end;

          end if;

      end if; -- fin de ln_habil

      --20210908 dcastro verificar si pagos de backup se extornaron en fsd602

      if nvl(ln_602Act, 0) = nvl(ln_602Ant, 0) and
         nvl(ln_001Act, 0) = nvl(ln_001Ant, 0) and
         nvl(ln_003Act, 0) = nvl(ln_003Ant, 0) and
         lc_contExt = 0 then
        --jrodriguej 06/02/2021
        PQ_CR_REPROGR_COVID19.Sp_backup_ext88(i.aqpb088emp,
                                              i.aqpb088mod,
                                              i.aqpb088suc,
                                              i.aqpb088mda,
                                              i.aqpb088pap,
                                              i.aqpb088cta,
                                              i.aqpb088ope,
                                              i.aqpb088sbo,
                                              i.aqpb088top,
                                              i.aqpb088fep,
                                              i.aqpb088cor);
        --fsd601
        delete from fsd601 a
         where a.pgcod = i.aqpb088emp
           and a.ppmod = i.aqpb088mod
           and a.ppsuc = i.aqpb088suc
           and a.ppmda = i.aqpb088mda
           and a.pppap = i.aqpb088pap
           and a.ppcta = i.aqpb088cta
           and a.ppoper = i.aqpb088ope
           and a.ppsbop = i.aqpb088sbo
           and a.pptope = i.aqpb088top;
         commit;

        insert into fsd601
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PPFVAL,
                 PPFVTO,
                 PPPZO,
                 PPCAP,
                 PPINT,
                 PPINTMEX,
                 PPICAP,
                 PPIINT,
                 PPSTAT,
                 PPNUME,
                 PPFINV,
                 D601CD,
                 D601MO,
                 D601SU,
                 D601TR,
                 D601RE,
                 D601FC,
                 D601OR,
                 D601SB,
                 D601CO
            from AQPB088_601C t
           where t.pgcod = i.aqpb088emp
             and t.ppmod = i.aqpb088mod
             and t.ppsuc = i.aqpb088suc
             and t.ppmda = i.aqpb088mda
             and t.pppap = i.aqpb088pap
             and t.ppcta = i.aqpb088cta
             and t.ppoper = i.aqpb088ope
             and t.ppsbop = i.aqpb088sbo
             and t.pptope = i.aqpb088top
             and t.fec = i.aqpb088fep
             and t.cor = i.aqpb088cor;

         commit;

        --fsd611
        delete from fsd611 a
         where a.pgcod = i.aqpb088emp
           and a.ppmod = i.aqpb088mod
           and a.ppsuc = i.aqpb088suc
           and a.ppmda = i.aqpb088mda
           and a.pppap = i.aqpb088pap
           and a.ppcta = i.aqpb088cta
           and a.ppoper = i.aqpb088ope
           and a.ppsbop = i.aqpb088sbo
           and a.pptope = i.aqpb088top;

         commit;

        insert into fsd611
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PPEXTE,
                 PPIMP1,
                 PPIMP2,
                 PPIMP3,
                 PPIMP4,
                 PPIMP5,
                 PPIMP6,
                 PPIMP7,
                 PPIMP8,
                 PPIMP9,
                 PPIMP10,
                 PPIMP11,
                 PPIMP12,
                 PPIMP13,
                 PPIMP14,
                 PPIMP15,
                 PPIMP16,
                 PPIMP17,
                 PPIMP18,
                 PPIMP19,
                 PPIMP20
            from AQPB088_611C t
           where t.pgcod = i.aqpb088emp
             and t.ppmod = i.aqpb088mod
             and t.ppsuc = i.aqpb088suc
             and t.ppmda = i.aqpb088mda
             and t.pppap = i.aqpb088pap
             and t.ppcta = i.aqpb088cta
             and t.ppoper = i.aqpb088ope
             and t.ppsbop = i.aqpb088sbo
             and t.pptope = i.aqpb088top
             and t.fec = i.aqpb088fep
             and t.cor = i.aqpb088cor;

         commit;
        --fsd602
        delete from fsd602 a
         where a.pgcod = i.aqpb088emp
           and a.ppmod = i.aqpb088mod
           and a.ppsuc = i.aqpb088suc
           and a.ppmda = i.aqpb088mda
           and a.pppap = i.aqpb088pap
           and a.ppcta = i.aqpb088cta
           and a.ppoper = i.aqpb088ope
           and a.ppsbop = i.aqpb088sbo
           and a.pptope = i.aqpb088top;
         commit;

        insert into fsd602
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PP1NUMP,
                 PP1FECH,
                 PP1CAP,
                 PP1INT,
                 PP1INTMEX,
                 PP1INTM,
                 PP1INTMMEX,
                 PP1ICAP,
                 PP1IINT,
                 PP1IINTM,
                 PP1SALCAP,
                 PP1SALINT,
                 PP1SALADE,
                 PP1SALMOR,
                 PP1STAT,
                 PP1SALINTM,
                 PP1SALMORM,
                 PP1SALADEM,
                 D602CD,
                 D602MO,
                 D602SU,
                 D602TR,
                 D602RE,
                 D602FC,
                 D602OR,
                 D602SB,
                 D602CO
            from AQPB088_602C t
           where t.pgcod = i.aqpb088emp
             and t.ppmod = i.aqpb088mod
             and t.ppsuc = i.aqpb088suc
             and t.ppmda = i.aqpb088mda
             and t.pppap = i.aqpb088pap
             and t.ppcta = i.aqpb088cta
             and t.ppoper = i.aqpb088ope
             and t.ppsbop = i.aqpb088sbo
             and t.pptope = i.aqpb088top
             and t.fec = i.aqpb088fep
             and t.cor = i.aqpb088cor;

         commit;

        --fsd612
        delete from fsd612 a
         where a.pgcod = i.aqpb088emp
           and a.ppmod = i.aqpb088mod
           and a.ppsuc = i.aqpb088suc
           and a.ppmda = i.aqpb088mda
           and a.pppap = i.aqpb088pap
           and a.ppcta = i.aqpb088cta
           and a.ppoper = i.aqpb088ope
           and a.ppsbop = i.aqpb088sbo
           and a.pptope = i.aqpb088top;

         commit;

        insert into fsd612
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PP1NUMP,
                 PP1EXTE,
                 PP1IMP1,
                 PP1IMP2,
                 PP1IMP3,
                 PP1IMP4,
                 PP1IMP5,
                 PP1IMP6,
                 PP1IMP7,
                 PP1IMP8,
                 PP1IMP9,
                 PP1IMP10,
                 PP1IMP11,
                 PP1IMP12,
                 PP1IMP13,
                 PP1IMP14,
                 PP1IMP15,
                 PP1IMP16,
                 PP1IMP17,
                 PP1IMP18,
                 PP1IMP19,
                 PP1IMP20,
                 PP1SAL1,
                 PP1SAL2,
                 PP1SAL3,
                 PP1SAL4,
                 PP1SAL5,
                 PP1SAL6,
                 PP1SAL7,
                 PP1SAL8,
                 PP1SAL9,
                 PP1SAL10,
                 PP1SAL11,
                 PP1SAL12,
                 PP1SAL13,
                 PP1SAL14,
                 PP1SAL15,
                 PP1SAL16,
                 PP1SAL17,
                 PP1SAL18,
                 PP1SAL19,
                 PP1SAL20
            from AQPB088_612C t
           where t.pgcod = i.aqpb088emp
             and t.ppmod = i.aqpb088mod
             and t.ppsuc = i.aqpb088suc
             and t.ppmda = i.aqpb088mda
             and t.pppap = i.aqpb088pap
             and t.ppcta = i.aqpb088cta
             and t.ppoper = i.aqpb088ope
             and t.ppsbop = i.aqpb088sbo
             and t.pptope = i.aqpb088top
             and t.fec = i.aqpb088fep
             and t.cor = i.aqpb088cor;

         commit;

        --fsd010
        update fsd010 u
           set AOFVTO =
               (select max(AOFVTO)
                  from AQPB088_010C t
                 where t.pgcod = i.aqpb088emp
                   and t.aomod = i.aqpb088mod
                   and t.aosuc = i.aqpb088suc
                   and t.aomda = i.aqpb088mda
                   and t.aopap = i.aqpb088pap
                   and t.aocta = i.aqpb088cta
                   and t.aooper = i.aqpb088ope
                   and t.aosbop = i.aqpb088sbo
                   and t.aotope = i.aqpb088top
                   and t.fec = i.aqpb088fep
                   and t.cor = i.aqpb088cor),
               AOPZO =
               (select max(AOPZO)
                  from AQPB088_010C t
                 where t.pgcod = i.aqpb088emp
                   and t.aomod = i.aqpb088mod
                   and t.aosuc = i.aqpb088suc
                   and t.aomda = i.aqpb088mda
                   and t.aopap = i.aqpb088pap
                   and t.aocta = i.aqpb088cta
                   and t.aooper = i.aqpb088ope
                   and t.aosbop = i.aqpb088sbo
                   and t.aotope = i.aqpb088top
                   and t.fec = i.aqpb088fep
                   and t.cor = i.aqpb088cor)
         where u.pgcod = i.aqpb088emp
           and u.aomod = i.aqpb088mod
           and u.aosuc = i.aqpb088suc
           and u.aomda = i.aqpb088mda
           and u.aopap = i.aqpb088pap
           and u.aocta = i.aqpb088cta
           and u.aooper = i.aqpb088ope
           and u.aosbop = i.aqpb088sbo
           and u.aotope = i.aqpb088top;

         commit;

        --fsd011

        update fsd011 u
           set scfvto =
               (select max(scfvto)
                  from AQPB088_011C t
                 where t.pgcod = i.aqpb088emp
                   and t.scmod = i.aqpb088mod
                   and t.scsuc = i.aqpb088suc
                   and t.scmda = i.aqpb088mda
                   and t.scpap = i.aqpb088pap
                   and t.sccta = i.aqpb088cta
                   and t.scoper = i.aqpb088ope
                   and t.scsbop = i.aqpb088sbo
                   and t.sctope = i.aqpb088top
                   and t.fec = i.aqpb088fep
                   and t.cor = i.aqpb088cor),
               scpzo =
               (select max(scpzo)
                  from AQPB088_011C t
                 where t.pgcod = i.aqpb088emp
                   and t.scmod = i.aqpb088mod
                   and t.scsuc = i.aqpb088suc
                   and t.scmda = i.aqpb088mda
                   and t.scpap = i.aqpb088pap
                   and t.sccta = i.aqpb088cta
                   and t.scoper = i.aqpb088ope
                   and t.scsbop = i.aqpb088sbo
                   and t.sctope = i.aqpb088top
                   and t.fec = i.aqpb088fep
                   and t.cor = i.aqpb088cor)
         where u.pgcod = i.aqpb088emp
           and u.scmod = i.aqpb088mod
           and u.scsuc = i.aqpb088suc
           and u.scmda = i.aqpb088mda
           and u.scpap = i.aqpb088pap
           and u.sccta = i.aqpb088cta
           and u.scoper = i.aqpb088ope
           and u.scsbop = i.aqpb088sbo
           and u.sctope = i.aqpb088top;
       commit;


        --fpp001
        delete from fpp001 a
         where a.pgcod = i.aqpb088emp
           and a.aomod = i.aqpb088mod
           and a.aosuc = i.aqpb088suc
           and a.aomda = i.aqpb088mda
           and a.aopap = i.aqpb088pap
           and a.aocta = i.aqpb088cta
           and a.aooper = i.aqpb088ope
           and a.aosbop = i.aqpb088sbo
           and a.aotope = i.aqpb088top;
         commit;

        insert into fpp001
          select aqpa4cpgcod,
                 aqpa4caomod,
                 aqpa4caosuc,
                 aqpa4caomda,
                 aqpa4caopap,
                 aqpa4caocta,
                 aqpa4caooper,
                 aqpa4caosbop,
                 aqpa4caotope,
                 aqpa4csgcod,
                 --aqpa4cfpro,
                 aqpa4cvc,
                 aqpa4cimp,
                 aqpa4cporc,
                 aqpa4cplus,
                 aqpa4cpart,
                 aqpa4cveh,
                 aqpa4cinm,
                 aqpa4cend,
                 aqpa4cstat,
                 aqpa4cco,
                 aqpa4caux1,
                 aqpa4caux2,
                 aqpa4caux3,
                 aqpa4caux4,
                 aqpa4caux5,
                 aqpa4caux6,
                 aqpa4caux7
            from AQPB088_001C a
           where a.aqpa4cpgcod = i.aqpb088emp
             and a.aqpa4caomod = i.aqpb088mod
             and a.aqpa4caosuc = i.aqpb088suc
             and a.aqpa4caomda = i.aqpb088mda
             and a.aqpa4caopap = i.aqpb088pap
             and a.aqpa4caocta = i.aqpb088cta
             and a.aqpa4caooper = i.aqpb088ope
             and a.aqpa4caosbop = i.aqpb088sbo
             and a.aqpa4caotope = i.aqpb088top
             and a.aqpa4cfep = i.aqpb088fep
             and a.aqpa4ccor = i.aqpb088cor;

         commit;

        --fpp003
        delete from fpp003 a
         where a.pgcod = i.aqpb088emp
           and a.ppmod = i.aqpb088mod
           and a.ppsuc = i.aqpb088suc
           and a.ppmda = i.aqpb088mda
           and a.pppap = i.aqpb088pap
           and a.ppcta = i.aqpb088cta
           and a.ppoper = i.aqpb088ope
           and a.ppsbop = i.aqpb088sbo
           and a.pptope = i.aqpb088top;
       commit;

        insert into fpp003
          select aqpa4dpgcod,
                 aqpa4dmod,
                 aqpa4dsuc,
                 aqpa4dmda,
                 aqpa4dpap,
                 aqpa4dcta,
                 aqpa4doper,
                 aqpa4dsbop,
                 aqpa4dtope,
                 aqpa4dfpag,
                 aqpa4dtipo,
                 aqpa4dnump,
                 aqpa4dprcnc,
                 --aqpa4dfepro,
                 aqpa4dimp,
                 aqpa4dstat,
                 aqpa4daux1,
                 aqpa4daux2,
                 aqpa4daux3

            from AQPB088_003C a
          where a.aqpa4dpgcod = i.aqpb088emp
             and a.aqpa4dmod =  i.aqpb088mod
             and a.aqpa4dsuc =  i.aqpb088suc
             and a.aqpa4dmda =  i.aqpb088mda
             and a.aqpa4dpap =  i.aqpb088pap
             and a.aqpa4dcta =  i.aqpb088cta
             and a.aqpa4doper = i.aqpb088ope
             and a.aqpa4dsbop = i.aqpb088sbo
             and a.aqpa4dtope = i.aqpb088top
             and a.aqpa4dfep =  i.aqpb088fep
             and a.aqpa4dcor =  i.aqpb088cor;

         commit;

        --chernandez 10/07/2020
        --verificar jaqa257
        /*
        for ff in creditos_jaqa257 loop
          if ff.jaqa257fec >= i.aqpb088fep then

            if ff.jaqa257nu3 is not null or ff.jaqa257nu3 > 0 then
              --chernandez 09/09/2020 solo considera del proceso de cambio de tasa ya que tambien hay registros de armado de calendario ceci
              update fsd012
                 set d012co = 'E'
               where pgcod = ln_pgcod
                 and aomod = ln_mod
                 and aosuc = ln_suc
                 and aomda = ln_mda
                 and aopap = ln_pap
                 and aocta = ln_cta
                 and aooper = ln_ope
                 and aosbop = ln_sbop
                 and aotope = ln_top
                 and evtipo = 3
                    --and evfval > ld_AQPA380FVAL
                    --and evcorr > ln_aqpa380corr chernandez 23/07/2020
                 and evcorr >= ff.jaqa257nu3;
              --chernandez 09/09/2020
              update fsd012 a
                 set d012co = nvl((select aqpa38012co
                                    from aqpa380
                                   where aqpa380cod = ln_pgcod
                                     and aqpa380mod = ln_mod
                                     and aqpa380suc = ln_suc
                                     and aqpa380mda = ln_mda
                                     and aqpa380pap = ln_pap
                                     and aqpa380cta = ln_cta
                                     and aqpa380oper = ln_ope
                                     and aqpa380sbop = ln_sbop
                                     and aqpa380tope = ln_top
                                     and aqpa380corr = a.evcorr
                                     and aqpa380tipo = a.evtipo
                                     and aqpa380fech = ff.jaqa257fec),
                                  d012co)
               where pgcod = ln_pgcod
                 and aomod = ln_mod
                 and aosuc = ln_suc
                 and aomda = ln_mda
                 and aopap = ln_pap
                 and aocta = ln_cta
                 and aooper = ln_ope
                 and aosbop = ln_sbop
                 and aotope = ln_top
                 and evtipo = 3
                 and evcorr < ff.jaqa257nu3;

              update aqpa380
                 set aqpa380est = 'I'
               where aqpa380cod = ln_pgcod
                 and aqpa380mod = ln_mod
                 and aqpa380suc = ln_suc
                 and aqpa380mda = ln_mda
                 and aqpa380pap = ln_pap
                 and aqpa380cta = ln_cta
                 and aqpa380oper = ln_ope
                 and aqpa380sbop = ln_sbop
                 and aqpa380tope = ln_top
                 and aqpa380fech = ff.jaqa257fec; --chernandez 23/07/2020
              for gg in creditos_jaqa257Ant(ff.jaqa257fec) loop
                update aqpa380
                   set aqpa380est = 'H'
                 where aqpa380cod = ln_pgcod
                   and aqpa380mod = ln_mod
                   and aqpa380suc = ln_suc
                   and aqpa380mda = ln_mda
                   and aqpa380pap = ln_pap
                   and aqpa380cta = ln_cta
                   and aqpa380oper = ln_ope
                   and aqpa380sbop = ln_sbop
                   and aqpa380tope = ln_top
                   and aqpa380fech = gg.jaqa257fec;
              end loop;
            end if;
            update jaqa257
               set jaqa257Est = 'X'
             where jaqa257emp = ln_pgcod
               and jaqa257mod = ln_mod
               and jaqa257suc = ln_suc
               and jaqa257mda = ln_mda
               and jaqa257pap = ln_pap
               and jaqa257cta = ln_cta
               and jaqa257ope = ln_ope
               and jaqa257sbo = ln_sbop
               and jaqa257tpo = ln_top
               and jaqa257fec = ff.jaqa257fec;

          end if;
        end loop;
        */

        -- jrodriguej 19.02.2021
        -- Procesamiento en FSD012
        /*
        begin
          select count(*)
            into lc_cont12
            from fsd012 x
           where x.pgcod = i.aqpb088emp
             and x.aomod = i.aqpb088mod
             and x.aosuc = i.aqpb088suc
             and x.aomda = i.aqpb088mda
             and x.aopap = i.aqpb088pap
             and x.aocta = i.aqpb088cta
             and x.aooper = i.aqpb088ope
             and x.aosbop = i.aqpb088sbo
             and x.aotope = i.aqpb088top
             and x.evtipo = 3
             and x.d012mo = 98
             and x.d012tr = 579
             and x.d012fc = ld_MaxFch698
          ;
        exception
          when others then
            lc_cont12 := 0;
        end;
        */

        --if lc_cont12 > 0 then
        --  begin
        begin
            update fsd012 x
               set x.d012co = 'E'
             where x.pgcod = i.aqpb088emp
               and x.aomod = i.aqpb088mod
               and x.aosuc = i.aqpb088suc
               and x.aomda = i.aqpb088mda
               and x.aopap = i.aqpb088pap
               and x.aocta = i.aqpb088cta
               and x.aooper = i.aqpb088ope
               and x.aosbop = i.aqpb088sbo
               and x.aotope = i.aqpb088top
               and x.evtipo = 3
               and x.d012mo = 98
               and x.d012tr = 579
               and x.d012fc = ld_MaxFch698;
                 commit;
        exception when others then
           null;
        end;

        /*validar si existe 20210908 dcastro*/
        begin
            select count(*)
            into ln_contador
            from fsd012 x
             where x.pgcod = i.aqpb088emp
               and x.aomod = i.aqpb088mod
               and x.aosuc = i.aqpb088suc
               and x.aomda = i.aqpb088mda
               and x.aopap = i.aqpb088pap
               and x.aocta = i.aqpb088cta
               and x.aooper = i.aqpb088ope
               and x.aosbop = i.aqpb088sbo
               and x.aotope = i.aqpb088top
               and x.evtipo = 3
               and x.d012mo = 98
               and x.d012tr = 579
               and x.d012fc = ld_MaxFch698;
        exception when others then
                  ln_contador := 0;
        end;

        if ln_contador = 0 then
             begin
                select a.aqpa840tasan
                 into ln_tasa
                 from aqpa840 a
               where a.aqpa840emp = i.aqpb088emp
                and a.aqpa840mod =  i.aqpb088mod
                and a.aqpa840suc =  i.aqpb088suc
                and a.aqpa840mda =  i.aqpb088mda
                and a.aqpa840pap =  i.aqpb088pap
                and a.aqpa840cta =  i.aqpb088cta
                and a.aqpa840ope =  i.aqpb088ope
                and a.aqpa840sbo =  i.aqpb088sbo
                and a.aqpa840top =  i.aqpb088top
                and a.aqpa840fecr = i.aqpb088fep;
             exception when others then
                 ln_tasa := 0;
             end;

             if ln_tasa <> 0 then
                begin
                    update fsd012 x
                     set x.d012co = 'E',
                         x.d012or = 98
                   where x.pgcod = i.aqpb088emp
                     and x.aomod = i.aqpb088mod
                     and x.aosuc = i.aqpb088suc
                     and x.aomda = i.aqpb088mda
                     and x.aopap = i.aqpb088pap
                     and x.aocta = i.aqpb088cta
                     and x.aooper = i.aqpb088ope
                     and x.aosbop = i.aqpb088sbo
                     and x.aotope = i.aqpb088top
                     and x.d012fc = ld_MaxFch698
                     and x.evtipo = 3
                     and x.evtasa = ln_tasa;
                    commit;
                exception when others then
                          null;
                end;

             end if; --20210908
             /*validar si existe 20210908 dcastro*/

         end if;

        --  end;
        --end if;

        -- mpostigoc 05.06.2020
        begin
          select f.pgfape
            into ld_FchExtorno
            from fst017 f
           where f.pgcod = 1;
        exception
          when others then
            null;
        end;

        -- confirmar con Darling
        -- select * from jaqa400 j where j.jaqa400cta = 2906485 and j.jaqa400ope = 7842681 for update; -- actualizar estado JAQA400EST = nulo
        -- select * from aqpb556 j where j.aqpb556cta = 2906485 and j.aqpb556oper = 7842681 for update; -- actualizar campo  AQPB556EHAB = 'E'

        begin
          select to_char(sysdate, 'HH24:MI:SS')
            into lc_HoraExtorno
            from dual;
        end;
        begin -- agregado 11.10.21 - BBA
              select UBUSER, UBSUC
              into lc_usuarExtorno, ln_sucurExtorno
              from FST046
              where UBUSER = lc_usuario;
        end;

        update aqpb088 a
           set a.aqpb088est  = 'V',
               a.aqpb088fext = ld_FchExtorno,
               a.aqpb088hext = lc_HoraExtorno,
               a.aqpb088usext = lc_usuarExtorno,
               a.AQPB088SUEXT = ln_sucurExtorno
         where a.aqpb088emp = i.aqpb088emp
           and a.aqpb088mod = i.aqpb088mod
           and a.aqpb088suc = i.aqpb088suc
           and a.aqpb088mda = i.aqpb088mda
           and a.aqpb088pap = i.aqpb088pap
           and a.aqpb088cta = i.aqpb088cta
           and a.aqpb088ope = i.aqpb088ope
           and a.aqpb088sbo = i.aqpb088sbo
           and a.aqpb088top = i.aqpb088top
           and a.aqpb088fep = i.aqpb088fep
           and a.aqpb088cor = i.aqpb088cor;
       commit;

        ---Actualizar estado en JAQA400
        begin
          -- Call the procedure
          pq_cr_eva_pyme_otros_datos.sp_actualiza_estado_jaqa400(pn_cod   => i.aqpb088emp,
                                                                 pn_mod   => i.aqpb088mod,
                                                                 pn_suc   => i.aqpb088suc,
                                                                 pn_mda   => i.aqpb088mda,
                                                                 pn_pap   => i.aqpb088pap,
                                                                 pn_cta   => i.aqpb088cta,
                                                                 pn_ope   => i.aqpb088ope,
                                                                 pn_sbo   => i.aqpb088sbo,
                                                                 pn_top   => i.aqpb088top,
                                                                 pn_fecha => ld_MaxFch698,
                                                                 pn_proc  => 'EXT',
                                                                 pn_esta  => 'V',
                                                                 pn_usua  => '',
                                                                 pn_flag  => lc_flagExt);
        Exception
          when others then
            lc_flagExt := 'N';
        end;

        -- Actualización AQPB556

        update aqpb556 j
           set j.AQPB556EHAB = 'V'
         where j.aqpb556emp = i.aqpb088emp
           and j.aqpb556mod = i.aqpb088mod
           and j.aqpb556suc = i.aqpb088suc
           and j.aqpb556mda = i.aqpb088mda
           and j.aqpb556pap = i.aqpb088pap
           and j.aqpb556cta = i.aqpb088cta
           and j.aqpb556oper = i.aqpb088ope
           and j.aqpb556sbop = i.aqpb088sbo
           and j.aqpb556top = i.aqpb088top
           and j.aqpb556ehab = 'H'
           and j.aqpb556est = 'A'
           and cast(j.aqpb556fecm as date) =
               (select max(cast(x.aqpb556fecm as date))
                  from aqpb556 x
                 where x.aqpb556emp = i.aqpb088emp
                   and x.aqpb556mod = i.aqpb088mod
                   and x.aqpb556suc = i.aqpb088suc
                   and x.aqpb556mda = i.aqpb088mda
                   and x.aqpb556pap = i.aqpb088pap
                   and x.aqpb556cta = i.aqpb088cta
                   and x.aqpb556oper = i.aqpb088ope
                   and x.aqpb556sbop = i.aqpb088sbo
                   and x.aqpb556top = i.aqpb088top
                   and x.aqpb556ehab = 'H'
                   and x.aqpb556est = 'A'

                ) --- maxima fecha ; -- actualizar campo  AQPB556EHAB = 'E'         */
        ;
       commit;

        lc_Resultado := 0;
      else
        lc_Resultado := 4;
        if nvl(ln_602Act, 0) <> nvl(ln_602Ant, 0) then
          lc_Resultado := 2;
        else
          if nvl(ln_001Act, 0) <> nvl(ln_001Ant, 0) then
            lc_Resultado := 3;
          else
            if nvl(ln_003Act, 0) <> nvl(ln_003Ant, 0) then
              lc_Resultado := 4;
            else
              if lc_contExt > 0 then
                lc_Resultado := 5;
              end if;

            end if;
          end if;
        end if;
      end if;
      -- end loop;
    end loop;

  end Sp_reversionXCta88;
  --------------------------------------------------------
  Procedure Sp_backup_ext88(pn_emp in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,
                            pn_top in number,
                            pd_fec in date,
                            pn_cor in number) is

    -- MODIFCADO : DCASTRO 2017.05.17 Se detallo campos a insertar en JAQZ525_519

  begin
    begin
      delete from aqpb089_010C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from aqpb089_011C a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from aqpb089_601C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from aqpb089_611C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from aqpb089_602C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from aqpb089_612C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

      delete from aqpb089_003C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fep = pd_fec
         and a.cor = pn_cor;

      delete from aqpb089_002C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fecha = pd_fec
         and a.corre = pn_cor;

      delete from aqpb089_012C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fecha = pd_fec
         and a.corre = pn_cor;

      delete from aqpb089_001C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fep = pd_fec
         and a.cor = pn_cor;

      ---- Inserción de datos
      insert into aqpb089_010C
        select a.*, pd_fec, pn_cor
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;

      insert into aqpb089_011C
        select a.*, pd_fec, pn_cor
          from fsd011 a
         where a.pgcod = pn_emp
           and a.scmod = pn_mod
           and a.scsuc = pn_suc
           and a.scmda = pn_mda
           and a.scpap = pn_pap
           and a.sccta = pn_cta
           and a.scoper = pn_ope
           and a.scsbop = pn_sbo
           and a.sctope = pn_top;

      insert into aqpb089_601C
        select a.*, pd_fec, pn_cor
          from fsd601 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into aqpb089_611C
        select a.*, pd_fec, pn_cor
          from fsd611 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into aqpb089_602C
        select a.*, pd_fec, pn_cor
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into aqpb089_612C
        select a.*, pd_fec, pn_cor
          from fsd612 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into aqpb089_003C
        select a.*, pd_fec, pn_cor
          from fpp003 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into aqpb089_002C
        select a.*, pd_fec, pn_cor
          from fpp002 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;

      insert into aqpb089_012C
        select a.*, pd_fec, pn_cor
          from fsd012 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;

      insert into aqpb089_001C
        select a.*, pd_fec, pn_cor
          from fpp001 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
      commit;
    exception
      when others then
        null;
    end;

  end Sp_backup_ext88;
  -------------------------------------------------- jrodriguej 06.02.2021
  Procedure Sp_Up_MailTlfn_088(pn_emp      in number,
                               pn_mod      in number,
                               pn_suc      in number,
                               pn_mda      in number,
                               pn_pap      in number,
                               pn_cta      in number,
                               pn_ope      in number,
                               pn_sbo      in number,
                               pn_top      in number,
                               pd_fec      in date,
                               pv_correo   in varchar2,
                               pv_telefono in varchar2) is
  begin
    update aqpb088 j
       set j.aqpb088mail = pv_correo, j.aqpb088tlfn = pv_telefono
     where j.aqpb088emp = pn_emp
       and j.aqpb088mod = pn_mod
       and j.aqpb088suc = pn_suc
       and j.aqpb088mda = pn_mda
       and j.aqpb088pap = pn_pap
       and j.aqpb088cta = pn_cta
       and j.aqpb088ope = pn_ope
       and j.aqpb088sbo = pn_sbo
       and j.aqpb088top = pn_top
       and j.aqpb088fep = pd_fec
       and j.aqpb088est = 'V';
    commit;

  end Sp_Up_MailTlfn_088;
  --------------------------------------------------
Procedure Sp_Up_AQPB602_088(pn_emp      in number,
                           pn_mod      in number,
                           pn_suc      in number,
                           pn_mda      in number,
                           pn_pap      in number,
                           pn_cta      in number,
                           pn_ope      in number,
                           pn_sbo      in number,
                           pn_top      in number,
                           pd_fec      in date,
                           pn_cor      in number) is

  cursor cronograma is
   select * from AQPB088_602C t
       where t.pgcod =  pn_emp
         and t.ppmod =  pn_mod
         and t.ppsuc =  pn_suc
         and t.ppmda =  pn_mda
         and t.pppap =  pn_pap
         and t.ppcta =  pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.fec =    pd_fec
         and t.cor =    pn_cor
         and t.d602co = 'S';

  ln_contador number := 0;
  ln_monto number := 0;
  ln_montoE number := 0;
  ln_existe varchar2(1);

  begin

   for i in cronograma loop

     ln_contador := ln_contador + 1;

     begin
      select 'S'
        into ln_existe
        from fsd602 j
       where j.pgcod = i.pgcod
         and j.ppmod = i.ppmod
         and j.ppsuc = i.ppsuc
         and j.ppmda = i.ppmda
         and j.pppap = i.pppap
         and j.ppcta = i.ppcta
         and j.ppoper = i.ppoper
         and j.ppsbop = i.ppsbop
         and j.pptope = i.pptope
         and j.ppfpag = i.ppfpag
         and j.pp1nump = i.pp1nump
         and j.pp1fech = i.pp1fech
         and j.pp1stat = i.pp1stat
         and j.d602co = i.d602co;
     exception when others then
         --buscar si movimiento fue extornado
         ln_existe := 'N';
     end;

     if ln_existe = 'N' then
       --obtener movimiento
      begin
        select sum(f.hcimp1)
          into ln_monto
          from fsh016 f
        where f.pgcod = i.d602cd
          and f.hcmod = i.d602mo
          and f.hsucor = i.d602su
          and f.htran = i.d602tr
          and f.hnrel = i.d602re
          and f.hfcon = i.d602fc;
      exception when others then
         ln_monto := 0;
      end;

       --buscar extorno
      begin
        select sum(f.hcimp1)
          into ln_montoE
          from fsh016 f
        where f.pgcod = i.d602cd
          and f.hcmod = i.d602mo + 500
          and f.hsucor = i.d602su
          and f.htran = i.d602tr
          and f.hcimp1 = ln_monto;
      exception when others then
         ln_montoE := 0;
      end;

      if ln_monto = ln_montoE then

        begin
          update aqpb088_602c j
            set j.d602co = 'Z' -- indicador de extorno en backup
         where j.pgcod = i.pgcod
           and j.ppmod = i.ppmod
           and j.ppsuc = i.ppsuc
           and j.ppmda = i.ppmda
           and j.pppap = i.pppap
           and j.ppcta = i.ppcta
           and j.ppoper = i.ppoper
           and j.ppsbop = i.ppsbop
           and j.pptope = i.pptope
           and j.ppfpag = i.ppfpag
           and j.pp1nump = i.pp1nump
           and j.pp1fech = i.pp1fech
           and j.d602co = i.d602co
           and j.fec = i.fec
           and j.cor = i.cor;
           commit; ---
        exception when others then
           null;
        end;

      end if;

    end if;

    end loop;

  end Sp_Up_AQPB602_088;
  --------------------------------------------------
  PROCEDURE sp_cr_reporte (vi_sucext in number, vi_fchini in date, vi_fchfin in date, vi_usrrpt in varchar2 ) is
    /* Reporte de reversion de reprogramaciones segun requerimeinto INC.
    * Ing. Bhernard Beisaga Arenas
    *
    */
    lc_rpta       number:=0;
BEGIN
  BEGIN
    DELETE FROM AQPB761 WHERE trim(AQPB761USRPT) = trim(vi_usrrpt);
    commit;
  END;
  BEGIN
      INSERT INTO AQPB761
      WITH REPR_EXTORNADOS AS (SELECT AQPB088FEP AS FEP, AQPB088COR AS COR, AQPB088EMP AS EMP, AQPB088MOD AS MODU, AQPB088SUC AS SUC, AQPB088MDA AS MDA, AQPB088PAP AS PAP,
                                        AQPB088CTA AS CTA, AQPB088OPE AS OPER, AQPB088SBO AS SBOP, AQPB088TOP AS TOP,
                                      'REVERSION DE REPROGRAMACION' AS DES, 'NO' AS EFE,
                                      (SELECT sum(SCSDO * -1) FROM AQPB088_011C WHERE PGCOD = AQPB088EMP AND
                                                                                SCMOD = AQPB088MOD AND
                                                                                SCSUC = AQPB088SUC AND
                                                                                SCMDA = AQPB088MDA AND
                                                                                SCPAP = AQPB088PAP AND
                                                                                SCCTA = AQPB088CTA AND
                                                                                SCOPER = AQPB088OPE AND
                                                                                SCSBOP = AQPB088SBO AND
                                                                                SCTOPE = AQPB088TOP AND
                                                                                COR = AQPB088COR AND
                                                                                FEC = AQPB088FEP) AS SCEX,
                                      AQPB088SUEXT AS SUEXT,
                                      (SELECT LPAD(SUCURS,3,'000') ||'-'|| SCNOM  FROM FST001 WHERE PGCOD = 1  AND SUCURS = AQPB088SUEXT) AS SUCXT,
                                      AQPB088FEXT AS FEXT,
                                      AQPB088HEXT AS HEXT,
                                      AQPB088USEXT AS USEXT,
                                      AQPB088MAIL AS MAIL,
                                      AQPB088TLFN AS TLFN,
                                      AQPB088USRPT AS USRPT
                                      FROM AQPB088 A  WHERE AQPB088EST = 'V'
                                      UNION
                                     SELECT JAQZ698FEP, JAQZ698COR,JAQZ698EMP, JAQZ698MOD, JAQZ698SUC, JAQZ698MDA, JAQZ698PAP, JAQZ698CTA, JAQZ698OPE, JAQZ698SBO, JAQZ698TOP,
                                       'REVERSION DE REPROGRAMACION', 'NO',
                                       (SELECT sum(SCSDO * -1) FROM JAQZ520_011 WHERE PGCOD = JAQZ698EMP AND
                                                                                SCMOD = JAQZ698MOD AND
                                                                                SCSUC = JAQZ698SUC AND
                                                                                SCMDA = JAQZ698MDA AND
                                                                                SCPAP = JAQZ698PAP AND
                                                                                SCCTA = JAQZ698CTA AND
                                                                                SCOPER = JAQZ698OPE AND
                                                                                SCSBOP = JAQZ698SBO AND
                                                                                SCTOPE = JAQZ698TOP) AS MONTO,
                                       JAQZ698SUEXT,
                                      (SELECT LPAD(SUCURS,3,'000') ||'-'|| SCNOM  FROM FST001 WHERE PGCOD = 1  AND SUCURS = JAQZ698SUEXT) AS SUCEXT,
                                      JAQZ698FEXT,
                                      JAQZ698HEXT,
                                      JAQZ698USEXT,
                                      JAQZ698MAIL,
                                      JAQZ698TLFN,
                                      JAQZ698USRPT
                                      FROM JAQZ698 B WHERE JAQZ698EST = 'V'
                                      UNION
                                      SELECT AQPB002FEP, AQPB002COR,AQPB002EMP, AQPB002MOD, AQPB002SUC, AQPB002MDA, AQPB002PAP, AQPB002CTA, AQPB002OPE, AQPB002SBO, AQPB002TOP,
                                       'REVERSION DE REPROGRAMACION', 'NO',
                                      (SELECT sum(AQPA005SDO * -1) FROM AQPA005 WHERE AQPA005COD = AQPB002EMP AND
                                                                       AQPA005MOD = AQPB002MOD AND
                                                                       AQPA005SUC = AQPB002SUC AND
                                                                       AQPA005MDA = AQPB002MDA AND
                                                                       AQPA005PAP = AQPB002PAP AND
                                                                       AQPA005CTA = AQPB002CTA AND
                                                                       AQPA005OPER = AQPB002OPE AND
                                                                       AQPA005SBOP = AQPB002SBO AND
                                                                       AQPA005TOPE = AQPB002TOP AND
                                                                       AQPA005COR = AQPB002COR) AS MONTO,
                                      AQPB002SUEXT,
                                      (SELECT LPAD(SUCURS,3,'000') ||'-'|| SCNOM  FROM FST001 WHERE PGCOD = 1  AND SUCURS = AQPB002SUEXT) AS SUCEXT,
                                      AQPB002FECA,
                                      AQPB002HEXT,
                                      AQPB002USRR,
                                      AQPB002MAIL,
                                      AQPB002ETELEFO,
                                      AQPB002USRPT
                                       FROM AQPB002 C WHERE AQPB002EST = 'V')

                                  SELECT FEP, COR, EMP, MODU, SUC, MDA, PAP, CTA, OPER, SBOP, TOP, DES, EFE, SCEX, SUEXT, SUCXT, FEXT, HEXT, USEXT, MAIL, TLFN, trim(vi_usrrpt)
                                       FROM REPR_EXTORNADOS
                                       WHERE SUEXT = vi_sucext and
                                             FEXT between vi_fchini and vi_fchfin;
                                             COMMIT;
                                             lc_rpta := SQL%ROWCOUNT;
                                             DBMS_OUTPUT.put_line('Filas insertadas: ' || TO_CHAR(lc_rpta));

    END sp_cr_reporte;
END;

end pq_cr_reprogr_COVID19;
/

