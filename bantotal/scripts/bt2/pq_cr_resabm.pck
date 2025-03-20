create or replace package PQ_CR_RESABM is

  -- Author  : ABERNEDO
  -- Created : 10/06/2016 04:56:23 p.m.
  -- Purpose :
  -- Modificado : 07/06/2018 Se modifico por optimizacion sp_cant_cred_vig, sp_cant_cred_vig_ABM
  -- SMARQUEZ
  -- Modificado : 13/11/2019 Adicion de  Procedimiento de Edad Asistencia Médica

  type tp_nomvar is table of varchar2(30) index by binary_integer;
  type tp_valvar is table of varchar2(30) index by binary_integer;
  type tp_regla is record ( RNG49COD FRNG51.RNG49COD%type,
                            RNG50GRP FRNG51.RNG50GRP%type,
                            RNG51COD FRNG51.RNG51COD%type,
                            RNG68COD FRNG51.RNG68COD%type,
                            RNG51OPE FRNG51.RNG51OPE%type,
                            RNG51VAL FRNG51.RNG51VAL%type,
                            RNG68ATR FRNG68.RNG68ATR%type,
                            RNG68TDA FRNG68.RNG68TDA%type,
                            RNG50Ret FRNG50.RNG50RET%type  );
  type tb_reglas is table of tp_regla index by binary_integer;
  Procedure Sp_cr_edad(pn_pai in number,pn_tdo in number,pc_doc in char,pd_fecpro in date,
                     pc_flag out varchar2);
  Procedure Sp_cr_gracia(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pd_fecpro in date,
                       pn_ins in number,
                       pc_flag out varchar2);
  Procedure Sp_Tipo_Cliente(pn_pai in number,
                          pn_tdo in number,
                          pc_ndo in char,
                          pc_flag out varchar2);
  Procedure Sp_tipo_credito (pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pc_flg out varchar2);
  Procedure Sp_frecPago (pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pn_seg in number,
                       pc_flg out varchar2);
  Procedure Sp_Cant_Cred_Vig(pn_ins in number,
                            pc_flgF out varchar2,
                           pc_flgV out varchar2);
  Procedure Sp_Cant_Cred_Vig_ABM(pn_ins in number,
                           pc_flgV out varchar2,
                           pc_flgF out varchar2);
  Procedure Sp_PrimaMensual(pn_ins in number,pc_flg out varchar2);
  Function Fn_Seg_Imp_VC(pn_mda in number,pn_seg in number,pn_imp in number) return char;
  Function Fn_Seg_Imp_FS(pn_mda in number,pn_seg in number,pn_imp in number) return char;
  Procedure Sp_tipo_Seguro (pn_seg in number,pc_flgFS out varchar2,pc_flgVC out varchar2);
  Procedure Sp_Seguro_Ahorro(pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char,
                           pc_flgVC out varchar2);
  Procedure Sp_codigo_seguro(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pn_seg out number);
  Procedure Sp_Resolutores_Ant (pn_ins in number,
                              pc_impseg out varchar2,
                              pn_segaso out number,
                              pn_canfse out number,
                              pn_vidciv out number);

  procedure sp_cr_RNG1900( P_D_FECPRO in date,PN_PAIS IN NUMBER,PN_TDOC IN NUMBER,
                          PC_NDOC IN VARCHAR2,PC_USR IN VARCHAR2 );
  procedure sp_cr_cargar_variables( P_D_FECPRO IN DATE,
                                    P_N_PAIS IN jaqz099.jaqz099PAIS%type,
                                    P_N_TDOC IN jaqz099.jaqz099TDOC%type,
                                    P_C_NDOC IN jaqz099.jaqz099NDOC%type,
                                    P_C_USR  IN jaqz099.jaqz099USR%type,
                                    p_a_nomvar out pq_cr_resabm.tp_nomvar,
                                    p_a_valvar out pq_cr_resabm.tp_valvar,
                                    p_n_var out number );
  procedure sp_cr_evalua_clientes_1( P_N_REGLA IN NUMBER,
                                     P_A_NOMVAR IN pq_cr_resabm.tp_nomvar,
                                     P_A_VALVAR IN pq_cr_resabm.tp_valvar,
                                     P_N_VAR IN number,
                                     P_A_REGLAS in pq_cr_resabm.tb_reglas,
                                     P_N_REG in number,
                                     p_c_retorno out varchar2);
  Procedure Sp_maximaFecha(pn_ins in number,pd_fec out date);
  Procedure Sp_IndicadorFlujo(pn_ins in number,lc_flg out varchar2);
  Procedure Sp_Historial(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date,
                         ln_contador out number);
  Procedure Sp_SegVinc(pn_ins in number,pc_flg out varchar2) ;
  --------------------------------sma 13/11/2019------------------------------------------
  Procedure Sp_Edad_AsisMedica(pn_pai    in number,
                               pn_tdo    in number,
                               pc_doc    in char,
                               pd_fecpro in date,
                               pc_flag   out varchar2);

   Procedure Sp_codigo_seguro_multi(pn_emp in number,
                                     pn_mod in number,
                                     pn_suc in number,
                                     pn_mda in number,
                                     pn_pap in number,
                                     pn_cta in number,
                                     pn_ope in number,
                                     pn_sbo in number,
                                     pn_top in number,
                                     pn_seg out number);
  Procedure Sp_Tiene_Multiriesgo (pn_ins in number,
                                  pc_flg out varchar2) ;
  Procedure Sp_Cantidad_Multiriesgo (pn_ins in number,
                                     pn_contador out number) ;
------ Seguro con Garantia SMA 27/09/2023
  Procedure Sp_codigo_seguro_garantia(pn_emp in number,
                                     pn_mod in number,
                                     pn_suc in number,
                                     pn_mda in number,
                                     pn_pap in number,
                                     pn_cta in number,
                                     pn_ope in number,
                                     pn_sbo in number,
                                     pn_top in number,
                                     pn_seg out number);
end PQ_CR_RESABM;
/

create or replace package body PQ_CR_RESABM is

  -- Private type declarations
Procedure Sp_cr_edad(pn_pai in number,pn_tdo in number,pc_doc in char,pd_fecpro in date,
                     pc_flag out varchar2)is
ld_fec date;
ln_edad number(5);---mod@abr 20180810
begin
  begin
    select a.pffnac
    into ld_fec
    from fsd002 a
    where a.pfpais = pn_pai
    and a.pftdoc = pn_tdo
    and a.pfndoc = pc_doc;
  exception
    when others then null;
  end;
  if ld_fec is not null then
    ln_edad := floor(MONTHS_BETWEEN(pd_fecpro,ld_fec)/12);
    if ln_edad >= 18 and ln_edad < 65  then
       pc_flag := 'S';
       else
           pc_flag := 'N';
    end if;
    else
      pc_flag := 'S';
 end if;


end Sp_cr_edad;

Procedure Sp_cr_gracia(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pd_fecpro in date,
                       pn_ins in number,
                       pc_flag out varchar2)is
lc_flg number(1);
ln_dif number(5);
ld_fecpag date;
ld_fecdes date;
lc_des char(1);
begin
  lc_flg := 0;
  --Si se consideran pagos parciales
  begin
    select 1
      into lc_flg
      from fsd602 a
     where a.pgcod  = pn_emp
       and a.ppmod  = pn_mod
       and a.ppsuc  = pn_suc
       and a.ppmda  = pn_mda
       and a.pppap  = pn_pap
       and a.ppcta  = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top
       and a.pp1stat = 'T'
       and a.d602co = 'S'
       ;
  exception
       when others then lc_flg := 0;
  end;


  --lc_flg = 0 sin cuotas pagadas
  if lc_flg = 0 then

     --validar si ya esta desembolsado
      lc_des :='N';
      begin
           select 'S'
             into lc_des
             from fsd010 a
            where a.pgcod  = pn_emp
              and a.aomod  = pn_mod
              and a.aosuc  = pn_suc
              and a.aomda  = pn_mda
              and a.aopap  = pn_pap
              and a.aocta  = pn_cta
              and a.aooper = pn_ope
              and a.aosbop = pn_sbo
              and a.aotope = pn_top;
      exception when others then lc_des :='N';
      end;


     if lc_des  = 'S' then
        begin
          select aofval
            into ld_fecdes
            from fsd010 a
           where a.pgcod  = pn_emp
             and a.aomod  = pn_mod
             and a.aosuc  = pn_suc
             and a.aomda  = pn_mda
             and a.aopap  = pn_pap
             and a.aocta  = pn_cta
             and a.aooper = pn_ope
             and a.aosbop = pn_sbo
             and a.aotope = pn_top;
        exception
          when others then null;
        end;

        begin
           select min(a.ppfpag)
             into ld_fecpag
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
         when too_many_rows then
              begin
                 select min(a.ppfpag)
                   into ld_fecpag
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
                    and rownum = 1;
             exception
               when others then null;
             end;
         when others then null;
       end;

        else
          begin
               select max(a.wfiteminit)
                 into ld_fecdes
                 from wfwrkitems a
                where a.wfinsprcid = pn_ins;
          exception
                when too_many_rows then
                     begin
                           select max(a.wfiteminit)
                             into ld_fecdes
                             from wfwrkitems a
                            where a.wfinsprcid = pn_ins
                              and rownum = 1;
                      exception
                            when others then null;

                      end;
          end;

          begin
               select min(a.ppfpag)
                 into ld_fecpag
                 from fsd601 a,fsd611 b
                where a.pgcod  = pn_emp
                  and a.ppmod  = pn_mod
                  and a.ppsuc  = pn_suc
                  and a.ppmda  = pn_mda
                  and a.pppap  = pn_pap
                  and a.ppcta  = pn_cta
                  and a.ppoper = pn_ope
                  and a.ppsbop = pn_sbo
                  and a.pptope = pn_top
                  --and a.d601co='S'
                  and (a.ppcap+a.ppint)<>0
                  and a.pgcod  = b.pgcod
                  and a.ppmod  = b.ppmod
                  and a.ppsuc  = b.ppsuc
                  and a.ppmda  = b.ppmda
                  and a.pppap  = b.pppap
                  and a.ppcta  = b.ppcta
                  and a.ppoper = b.ppoper
                  and a.ppsbop = b.ppsbop
                  and a.pptope = b.pptope
                  and (b.ppimp11+b.ppimp12+b.ppimp13+b.ppimp14+b.ppimp15)<>0;
           exception
             when too_many_rows then
                  begin
                     select min(a.ppfpag)
                       into ld_fecpag
                       from fsd601 a,fsd611 b
                      where a.pgcod  = pn_emp
                        and a.ppmod  = pn_mod
                        and a.ppsuc  = pn_suc
                        and a.ppmda  = pn_mda
                        and a.pppap  = pn_pap
                        and a.ppcta  = pn_cta
                        and a.ppoper = pn_ope
                        and a.ppsbop = pn_sbo
                        and a.pptope = pn_top
                        --and a.d601co='S'
                        and (a.ppcap+a.ppint)<>0
                        and a.pgcod  = b.pgcod
                        and a.ppmod  = b.ppmod
                        and a.ppsuc  = b.ppsuc
                        and a.ppmda  = b.ppmda
                        and a.pppap  = b.pppap
                        and a.ppcta  = b.ppcta
                        and a.ppoper = b.ppoper
                        and a.ppsbop = b.ppsbop
                        and a.pptope = b.pptope
                        and (b.ppimp11+b.ppimp12+b.ppimp13+b.ppimp14+b.ppimp15)<>0
                        and rownum = 1;
                 exception
                   when others then null;
                 end;
             when others then null;
           end;

     end if;

     ln_dif := ld_fecpag - ld_fecdes;

     if ln_dif <= 60 then
        pc_flag := 'N';
        else
          pc_flag := 'S';
     end if;


  end if;

  --lc_flg = 1 con cuotas pagadas
  if lc_flg = 1 then
    begin
        select /*+ parallel(n,2,1)*/
               min(n.ppfpag)
          into ld_fecpag
          from fsd601 n
         where n.pgcod  = pn_emp
           and n.ppcta  = pn_cta
           and n.ppmda  = pn_mda
           and n.ppsuc  = pn_suc
           and n.pppap  = pn_pap
           and n.ppoper = pn_ope
           and n.ppsbop = pn_sbo
           and n.pptope = pn_top
           and n.ppmod  = pn_mod
           and n.d601co = 'S'
           and (n.ppcap+n.ppint)<>0
           and not exists
                    (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                       from fsd602 o
                      where o.pgcod   = n.pgcod
                        and o.ppmod   = n.ppmod
                        and o.ppsuc   = n.ppsuc
                        and o.ppmda   = n.ppmda
                        and o.pppap   = n.pppap
                        and o.ppcta   = n.ppcta
                        and o.ppoper  = n.ppoper
                        and o.ppsbop  = n.ppsbop
                        and o.pptope  = n.pptope
                        and o.ppfpag  = n.ppfpag
                        --and o.ppfpag  <= pd_fecpro
                        and o.pp1fech  <= pd_fecpro
                        --and o.pp1stat = 'T' si se consideran pagos parciales
                        and o.d602co  = 'S'
                        and (o.pp1cap+o.pp1int)<>0);
      exception
          when no_data_found then
             ld_fecpag := null;
          when too_many_rows then
             ld_fecpag := null;
      end;

      begin
             select a.jaqy782fchdes
               into ld_fecdes
               from jaqy782 a
              where a.jaqy782pgc = pn_emp
                and a.jaqy782mod = pn_mod
                and a.jaqy782suc = pn_suc
                and a.jaqy782mda = pn_mda
                and a.jaqy782pap = pn_pap
                and a.jaqy782cta = pn_cta
                and a.jaqy782ope = pn_ope
                and a.jaqy782sbo = pn_sbo
                and a.jaqy782top = pn_top;
      exception
        when others then null;
      end;

      if ld_fecdes is null then
         begin
           select aofval
             into ld_fecdes
             from fsd010 a
            where a.pgcod  = pn_emp
              and a.aomod  = pn_mod
              and a.aosuc  = pn_suc
              and a.aomda  = pn_mda
              and a.aopap  = pn_pap
              and a.aocta  = pn_cta
              and a.aooper = pn_ope
              and a.aosbop = pn_sbo
              and a.aotope = pn_top;
         exception
           when others then null;
         end;
      end if;

      ln_dif := ld_fecdes - ld_fecpag;

      if ln_dif <= 60 then
         pc_flag := 'N';
         else
           pc_flag := 'S';
      end if;

  end if;
end Sp_cr_gracia;

Procedure Sp_Tipo_Cliente(pn_pai in number,
                          pn_tdo in number,
                          pc_ndo in char,
                          pc_flag out varchar2) is


begin

     pc_flag := 'N';

     begin
           select 'S'
             into pc_flag
             from fsd001 a
            where a.pepais = pn_pai
              and a.petdoc = pn_tdo
              and a.pendoc = pc_ndo
              and a.petipo = 'F';
      exception
      when others then
           pc_flag := 'N';
      end;




end Sp_Tipo_Cliente;

Procedure Sp_tipo_credito (pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pc_flg out varchar2) is
lc_tipV char(1);
lc_tipF char(1);
lc_tipM char(1);
begin
      pc_flg := 'N';
      lc_tipV := 'N';
      lc_tipF := 'N';
      lc_tipM := 'N';

      --vida caja
      begin
           select 'S'
             into lc_tipV
             from fpp001 a,x054011 b
            where a.pgcod  = pn_emp
              and a.aomod  = pn_mod
              and a.aosuc  = pn_suc
              and a.aomda  = pn_mda
              and a.aopap  = pn_pap
              and a.aocta  = pn_cta
              and a.aooper = pn_ope
              and a.aosbop = pn_sbo
              and a.aotope = pn_top
              and a.sgcod in (select b.tp1nro3
                                from fst198 b
                               Where Tp1cod = 1
                                 and Tp1cod1 = 10898
                                 and Tp1corr1  = 18
                                 and tp1corr3=1)--vida caja
              and a.aomod= b.xpremod
              and a.sgcod = b.sgcod
              and rownum = 1;
      exception
        when no_data_found then
             begin
                 select 'S'
                   into lc_tipV
                   from jaqy771 a,x054011 b
                  where a.jaqy771pgc = pn_emp
                    and a.jaqy771mod = pn_mod
                    and a.jaqy771suc = pn_suc
                    and a.jaqy771mda = pn_mda
                    and a.jaqy771pap = pn_pap
                    and a.jaqy771cta = pn_cta
                    and a.jaqy771ope = pn_ope
                    and a.jaqy771sbo = pn_sbo
                    and a.jaqy771top = pn_top
                    and a.jaqy771sgc in(select b.tp1nro3
                                          from fst198 b
                                         Where Tp1cod = 1
                                           and Tp1cod1 = 10898
                                           and Tp1corr1  = 18
                                           and tp1corr3=1)---vida caja
                    and a.jaqy771mod= b.xpremod
                    and a.jaqy771sgc = b.sgcod
                    and rownum = 1;
            exception
            when others then lc_tipV := 'N';
            end;
       -- when others then lc_tipV := 'N';
      end;

      --familia segura
      begin
           select 'S'
             into lc_tipF
             from fpp001 a ,x054011 b
            where a.pgcod  = pn_emp
              and a.aomod  = pn_mod
              and a.aosuc  = pn_suc
              and a.aomda  = pn_mda
              and a.aopap  = pn_pap
              and a.aocta  = pn_cta
              and a.aooper = pn_ope
              and a.aosbop = pn_sbo
              and a.aotope = pn_top
              and a.sgcod in (select b.tp1nro3
                                from fst198 b
                               Where Tp1cod = 1
                                 and Tp1cod1 = 10898
                                 and Tp1corr1  = 18
                                 and tp1corr3=2)--familia segura
              and a.aomod= b.xpremod
              and a.sgcod = b.sgcod
              and rownum = 1;
      exception
        when no_data_found then
             begin
                 select 'S'
                   into lc_tipF
                   from jaqy771 a, x054011 b
                  where a.jaqy771pgc = pn_emp
                    and a.jaqy771mod = pn_mod
                    and a.jaqy771suc = pn_suc
                    and a.jaqy771mda = pn_mda
                    and a.jaqy771pap = pn_pap
                    and a.jaqy771cta = pn_cta
                    and a.jaqy771ope = pn_ope
                    and a.jaqy771sbo = pn_sbo
                    and a.jaqy771top = pn_top
                    and a.jaqy771sgc in (select b.tp1nro3
                                           from fst198 b
                                          Where Tp1cod = 1
                                            and Tp1cod1 = 10898
                                            and Tp1corr1 = 18
                                            and tp1corr3 = 2)
                    and a.jaqy771mod = b.xpremod
                    and a.jaqy771sgc = b.sgcod
                    and rownum = 1;
            exception
            when others then lc_tipF := 'N';
            end;
        --when others then lc_tipF := 'N';
      end;

      -- Multiriesgo
      begin
           select 'S'
             into lc_tipM
             from fpp001 a ,x054011 b
            where a.pgcod  = pn_emp
              and a.aomod  = pn_mod
              and a.aosuc  = pn_suc
              and a.aomda  = pn_mda
              and a.aopap  = pn_pap
              and a.aocta  = pn_cta
              and a.aooper = pn_ope
              and a.aosbop = pn_sbo
              and a.aotope = pn_top
              and a.sgcod in (select b.tp1nro1
                                from fst198 b
                               Where Tp1cod = 1
                                 and Tp1cod1 = 10875
                                 and Tp1corr1 = 9
                                 and tp1corr2 = 1)--familia multiriesgo
              and a.aomod= b.xpremod
              and a.sgcod = b.sgcod
              and rownum = 1;
      exception
        when no_data_found then
             begin
                 select 'S'
                   into lc_tipM
                   from jaqy771 a, x054011 b
                  where a.jaqy771pgc = pn_emp
                    and a.jaqy771mod = pn_mod
                    and a.jaqy771suc = pn_suc
                    and a.jaqy771mda = pn_mda
                    and a.jaqy771pap = pn_pap
                    and a.jaqy771cta = pn_cta
                    and a.jaqy771ope = pn_ope
                    and a.jaqy771sbo = pn_sbo
                    and a.jaqy771top = pn_top
                    and a.jaqy771sgc in (select b.tp1nro1
                                            from fst198 b
                                           Where Tp1cod = 1
                                             and Tp1cod1 = 10875
                                             and Tp1corr1 = 9
                                             and tp1corr2 = 1)--familia multiriesgo
                    and a.jaqy771mod = b.xpremod
                    and a.jaqy771sgc = b.sgcod
                    and rownum = 1;
            exception
            when others then lc_tipF := 'N';
            end;
        --when others then lc_tipF := 'N';
      end;


      If lc_tipF = 'S' or lc_tipV = 'S' or lc_tipM = 'S' then
         pc_flg :='S';
      Else
         pc_flg := 'N';
      end if;

end Sp_tipo_credito;

Procedure Sp_frecPago (pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pn_seg in number,
                       pc_flg out varchar2)is
ln_periodo number(5);

begin
      pc_flg := 'N';
      begin
            select a.aoperiod
              into ln_periodo
              from fsd010 a
             where a.pgcod  = pn_emp
               and a.aomod  = pn_mod
               and a.aosuc  = pn_suc
               and a.aomda  = pn_mda
               and a.aopap  = pn_pap
               and a.aocta  = pn_cta
               and a.aooper = pn_ope
               and a.aosbop = pn_sbo
               and a.aotope = pn_top;

       exception when others then null;
       end;

       begin
            select 'S'
              into pc_flg
              from fst198 a
             where a.tp1cod   = 1
               and a.tp1cod1  = 10899
               and a.tp1corr1 = 22
               and a.tp1corr2 = 3
               and a.tp1nro1  = ln_periodo
               and a.tp1nro2  = pn_seg;
       exception when others then pc_flg := 'N';
       end;

       if pc_flg <> 'S' then
           begin
             select 'S'
               into pc_flg
               from fst198 b
              Where Tp1cod   = 1
                and Tp1cod1  = 10898
                and Tp1corr1 = 18
                and tp1corr3 = 2
                and tp1nro3  = pn_seg;
           exception
             when others then pc_flg := 'N';
           end;
       end if;


end Sp_frecPago;

Procedure Sp_Cant_Cred_Vig(pn_ins in number,
                           pc_flgF out varchar2,
                           pc_flgV out varchar2)is
pn_cantV number(5);
pn_cantF number(5);
pn_cantVV number(5);
pn_cantFV number(5);
pn_cantVVS number(5);
pn_cantFVS number(5);
begin


     --Vida Caja
     begin

     select count(*)
       into pn_cantV
       from fsd010 ff,
            fpp001 gg
      where ff.pgcod  = gg.pgcod
        and ff.aomod  = gg.aomod
        and ff.aosuc  = gg.aosuc
        and ff.aomda  = gg.aomda
        and ff.aopap  = gg.aopap
        and ff.aocta  = gg.aocta
        and ff.aooper = gg.aooper
        and ff.aosbop = gg.aosbop
        and ff.aotope = gg.aotope
        and ff.aocta in (SELECT NVL (B1.CTNRO, B1.CTNRO)---15022017
                           from SNG001 A,
                                FSR008 B1
                          WHERE A.SNG001PAIS = B1.PEPAIS
                            AND A.SNG001TDOC = B1.PETDOC
                            AND A.SNG001NDOC = B1.PENDOC
                            AND A.SNG001INST = pn_ins)
        and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50)
        and ff.aostat <>99
        and gg.sgcod  in (select b2.tp1nro3
                            from fst198 b2
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 = 1)
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfprcins =pn_ins and xwfcar3 <> '1');
     exception
     when others then null;
     end;

     --solicitudes en vuelo
     begin
     select count(*)
       into pn_cantVV
       from fpp001 gg,xwf700 h,wfwrkitems i
      where
      --gg.aocta in (SELECT NVL (B1.CTNRO, B1.CTNRO)---20180607 se comento y reemplazo por H.XWFCUENTA IN (SELECT NVL(B1.CTNRO, B1.CTNRO)
      H.XWFCUENTA IN (SELECT NVL(B1.CTNRO, B1.CTNRO)
                           from SNG001 A,
                                FSR008 B1
                          WHERE A.SNG001PAIS = B1.PEPAIS
                            AND A.SNG001TDOC = B1.PETDOC
                            AND A.SNG001NDOC = B1.PENDOC
                            AND A.SNG001INST = pn_ins)
        --and gg.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50) ---20180607 se comento y reemplazo por AND H.XWFMODULO IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
        AND H.XWFMODULO IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
        and gg.sgcod  in (select b2.tp1nro3
                            from fst198 b2
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 = 1)
        and gg.pgcod  = h.xwfempresa
        and gg.aomod  = h.xwfmodulo
        and gg.aosuc  = h.xwfsucursal
        and gg.aomda  = h.xwfmoneda
        and gg.aopap  = h.xwfpapel
        and gg.aocta  = h.xwfcuenta
        and gg.aooper = h.xwfoperacion
        and gg.aosbop = h.xwfsubope
        and gg.aotope = h.xwftipope
        and h.xwfcar3 = '1'
        and i.wfinsprcid = h.xwfprcins
        and i.wfitemstsact = 1
        and i.wfinsprcid <> pn_ins
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfprcins =pn_ins and xwfcar3 <> '1');
     exception
     when others then null;
     end;

     --Misma solicitud mas de 1 seguro
     begin
     select count(*)
       into pn_cantVVS
       from fpp001 gg,xwf700 h
      where gg.sgcod  in (select b.tp1nro3
                            from fst198 b
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 = 1)
        and gg.pgcod  = h.xwfempresa
        and gg.aomod  = h.xwfmodulo
        and gg.aosuc  = h.xwfsucursal
        and gg.aomda  = h.xwfmoneda
        and gg.aopap  = h.xwfpapel
        and gg.aocta  = h.xwfcuenta
        and gg.aooper = h.xwfoperacion
        and gg.aosbop = h.xwfsubope
        and gg.aotope = h.xwftipope
        and h.xwfcar3 = '1'
        and h.xwfprcins = pn_ins
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfprcins =pn_ins and xwfcar3 <> '1');
     exception
     when others then null;
     end;
     --Familia segura
     begin

     select count(*)
       into pn_cantF
       from fsd010 ff,
            fpp001 gg
      where ff.pgcod  = gg.pgcod
        and ff.aomod  = gg.aomod
        and ff.aosuc  = gg.aosuc
        and ff.aomda  = gg.aomda
        and ff.aopap  = gg.aopap
        and ff.aocta  = gg.aocta
        and ff.aooper = gg.aooper
        and ff.aosbop = gg.aosbop
        and ff.aotope = gg.aotope
        and ff.aocta in ( SELECT NVL (B1.CTNRO, B1.CTNRO)---15022017
                            from SNG001 A,
                                 FSR008 B1
                           WHERE A.SNG001PAIS = B1.PEPAIS
                             AND A.SNG001TDOC = B1.PETDOC
                             AND A.SNG001NDOC = B1.PENDOC
                             AND A.SNG001INST = pn_ins)
        and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50)
        and ff.aostat <>99
        and gg.sgcod  in (select b2.tp1nro3
                            from fst198 b2
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 =2)
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfprcins =pn_ins and xwfcar3 <> '1');
    exception
    when others then null;
    end;

    --solicitudes en vuelo
    begin

     select count(*)
       into pn_cantFV
       from fpp001 gg,xwf700 h,wfwrkitems i
      where
      --gg.aocta in (SELECT NVL (B1.CTNRO, B1.CTNRO)---20180607 se comento y reemplazo por H.XWFCUENTA IN (SELECT NVL(B1.CTNRO, B1.CTNRO)
      H.XWFCUENTA IN (SELECT NVL(B1.CTNRO, B1.CTNRO)
                            from SNG001 A,
                                 FSR008 B1
                           WHERE A.SNG001PAIS = B1.PEPAIS
                             AND A.SNG001TDOC = B1.PETDOC
                             AND A.SNG001NDOC = B1.PENDOC
                             AND A.SNG001INST = pn_ins)

       --and gg.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50) ---20180607 se comento y reemplazo por AND H.XWFMODULO IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
        AND H.XWFMODULO IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
        and gg.sgcod  in (select b2.tp1nro3
                            from fst198 b2
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 =2)

        and gg.pgcod  = h.xwfempresa
        and gg.aomod  = h.xwfmodulo
        and gg.aosuc  = h.xwfsucursal
        and gg.aomda  = h.xwfmoneda
        and gg.aopap  = h.xwfpapel
        and gg.aocta  = h.xwfcuenta
        and gg.aooper = h.xwfoperacion
        and gg.aosbop = h.xwfsubope
        and gg.aotope = h.xwftipope
        and h.xwfcar3 = '1'
        and i.wfinsprcid = h.xwfprcins
        and i.wfitemstsact = 1
        and i.wfinsprcid <> pn_ins
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfprcins =pn_ins and xwfcar3 <> '1');
    exception
    when others then null;
    end;
    --Misma solicitud mas de 1 seguro
     begin

     select count(*)
       into pn_cantFVS
       from fpp001 gg,xwf700 h
      where gg.sgcod  in (select b.tp1nro3
                            from fst198 b
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 =2)

        and gg.pgcod  = h.xwfempresa
        and gg.aomod  = h.xwfmodulo
        and gg.aosuc  = h.xwfsucursal
        and gg.aomda  = h.xwfmoneda
        and gg.aopap  = h.xwfpapel
        and gg.aocta  = h.xwfcuenta
        and gg.aooper = h.xwfoperacion
        and gg.aosbop = h.xwfsubope
        and gg.aotope = h.xwftipope
        and h.xwfcar3 = '1'
        AND H.XWFPRCINS = PN_INS
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfprcins =pn_ins and xwfcar3 <> '1');
    exception
    when others then null;
    end;
    if pn_cantF >= 1 OR pn_cantFV >=1 or pn_cantFVS >=2 then
       pc_flgF := 'S';
       else
          pc_flgF := 'N';
    END IF;

    IF pn_cantV >= 1 OR pn_cantVV >=1 or pn_cantVVS >=2 then
         pc_flgV := 'S';
         else
           pc_flgV := 'N';
    end if;


end Sp_Cant_Cred_Vig;

Procedure Sp_Cant_Cred_Vig_ABM(pn_ins in number,
                           pc_flgV out varchar2,
                           pc_flgF out varchar2)is
pn_cantV number(5);
pn_cantF number(5);

begin
     pc_flgV := 'N';
     pc_flgF := 'N';

     --Vida Caja
     begin

     select count(*)
       into pn_cantV
       from fsd010 ff,
            fpp001 gg
      where ff.pgcod  = gg.pgcod
        and ff.aomod  = gg.aomod
        and ff.aosuc  = gg.aosuc
        and ff.aomda  = gg.aomda
        and ff.aopap  = gg.aomda
        and ff.aocta  = gg.aocta
        and ff.aooper = gg.aooper
        and ff.aosbop = gg.aosbop
        and ff.aotope = gg.aotope
        and ff.aocta in (select B.CTNRO
                           from SNG001 A,
                                FSR008 B
                          WHERE A.SNG001PAIS = B.PEPAIS
                            AND A.SNG001TDOC = B.PETDOC
                            AND A.SNG001NDOC = B.PENDOC
                            AND A.SNG001INST = pn_ins)
        and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50)
        and ff.aostat <>99
        and gg.sgcod  in (select b.tp1nro3
                            from fst198 b
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 = 1);
     exception
     when others then null;
     end;


     --Familia segura
     begin

     select count(*)
       into pn_cantF
       from fsd010 ff,
            fpp001 gg
      where ff.pgcod  = gg.pgcod
        and ff.aomod  = gg.aomod
        and ff.aosuc  = gg.aosuc
        and ff.aomda  = gg.aomda
        and ff.aopap  = gg.aomda
        and ff.aocta  = gg.aocta
        and ff.aooper = gg.aooper
        and ff.aosbop = gg.aosbop
        and ff.aotope = gg.aotope
        and ff.aocta in ( select B.CTNRO
                            from SNG001 A,
                                 FSR008 B
                           WHERE A.SNG001PAIS = B.PEPAIS
                             AND A.SNG001TDOC = B.PETDOC
                             AND A.SNG001NDOC = B.PENDOC
                             AND A.SNG001INST = pn_ins)
        and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50)
        and ff.aostat <>99
        and gg.sgcod  in (select b.tp1nro3
                            from fst198 b
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 =2);
    exception
    when others then null;
    end;

    if pn_cantF >= 1 then
       pc_flgF := 'S';
    end if;
    if pn_cantV >= 1 then
       pc_flgV := 'S';
    end if;

end Sp_Cant_Cred_Vig_ABM;

Procedure Sp_PrimaMensual(pn_ins in number,pc_flg out varchar2)is
pc_flgFM char(1);
pc_flgVC char(1);
begin

     --Familia Segura SEG_FAMILIA_OK
     begin
       select pq_cr_resabm.Fn_Seg_Imp_FS(aomda,a.sgcod,a.pp001imp)
         into pc_flgFM
         from FPP001 a, xwf700 b
        where a.pgcod     = b.xwfempresa
          and a.aomod     = b.xwfmodulo
          and a.aosuc     = b.xwfsucursal
          and a.aomda     = b.xwfmoneda
          and a.aopap     = b.xwfpapel
          and a.aocta     = b.xwfcuenta
          and a.aooper    = b.xwfoperacion
          and a.aosbop    = b.xwfsubope
          and a.aotope    = b.xwftipope
          and b.xwfcar3   = '1'
          and b.xwfprcins = pn_ins
          and sgcod in (select a.tp1nro3
                          from fst198 a
                         Where Tp1cod   = 1
                           and Tp1cod1  = 10898
                           and Tp1corr1 = 18
                           and tp1corr3 = 2);
     exception
       when others then null;

     end;

     --Vida Caja VIDA_CAJA_OK
     begin
     select pq_cr_resabm.Fn_Seg_Imp_VC(aomda,a.sgcod,a.pp001imp)
       into pc_flgVC
       from FPP001 a, xwf700 b
      where a.pgcod     = b.xwfempresa
        and a.aomod     = b.xwfmodulo
        and a.aosuc     = b.xwfsucursal
        and a.aomda     = b.xwfmoneda
        and a.aopap     = b.xwfpapel
        and a.aocta     = b.xwfcuenta
        and a.aooper    = b.xwfoperacion
        and a.aosbop    = b.xwfsubope
        and a.aotope    = b.xwftipope
        and b.xwfcar3   = '1'
        and b.xwfprcins = pn_ins
        and sgcod in (select a.tp1nro3
                          from fst198 a
                         Where Tp1cod   = 1
                           and Tp1cod1  = 10898
                           and Tp1corr1 = 18
                           and tp1corr3 = 1);
     exception
       when others then null;
     End;

     If pc_flgVC = 'S' or pc_flgFM = 'S'then
        pc_flg := 'S';
        else
          pc_flg := 'N';
     end if;


end Sp_PrimaMensual;

Function Fn_Seg_Imp_VC(pn_mda in number,pn_seg in number,pn_imp in number) return char is
  cursor guia is
   select *
      from fst198 a
     Where Tp1cod   = 1
       and Tp1cod1  = 10898
       and Tp1corr1 = 18
       and tp1corr3 = 1
       and tp1nro1 = 1
       and tp1nro3 =  pn_seg;

lc_flg char(1);
/*ln_seg11 number(9);
ln_seg12 number(9);
ln_seg13 number(9);
ln_ims11 number(17,2);
ln_ims12 number(17,2);
ln_ims13 number(17,2);
ln_imd11 number(17,2);
ln_imd12 number(17,2);
ln_imd13 number(17,2);*/
begin


     --Obtener valores de la guia de proceso
  /*  begin
         select a.tp1nro3
           into ln_seg11
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 1
            and tp1corr2 = 1;
    exception when others then null;
    end;

    begin
         select a.tp1nro3
           into ln_seg12
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 1
            and tp1corr2 = 2;
    exception when others then null;
    end;

    begin
         select a.tp1nro3
           into ln_seg13
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 1
            and tp1corr2 = 3;
    exception when others then null;
    end;

    begin
         select a.tp1imp1
           into ln_ims11
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 1
            and tp1corr2 = 1;
    exception when others then null;
    end;

    begin
         select a.tp1imp1
           into ln_ims12
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 1
            and tp1corr2 = 2 ;
    exception when others then null;
    end;

    begin
         select a.tp1imp1
           into ln_ims13
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 1
            and tp1corr2 = 3 ;
    exception when others then null;
    end;

    begin
         select a.tp1imp2
           into ln_imd11
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 1
            and tp1corr2 = 1;
    exception when others then null;
    end;

    begin
         select a.tp1imp2
           into ln_imd12
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 1
            and tp1corr2 = 2;
    exception when others then null;
    end;

    begin
         select a.tp1imp2
           into ln_imd13
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 1
            and tp1corr2 = 3 ;
    exception when others then null;
    end;
    --------------------------------------------

    begin


        if pn_mda = 0 then
           CASE
               WHEN pn_seg = ln_seg11 and
                    pn_imp = ln_ims11
               THEN lc_flg := 'N';

               WHEN pn_seg = ln_seg12 and
                    pn_imp = ln_ims12
               THEN lc_flg := 'N';
               WHEN pn_seg = ln_seg13 and
                    pn_imp = ln_ims13
               THEN lc_flg := 'N';
               ELSE lc_flg := 'S';
             end case;
        else

             CASE
               WHEN pn_seg = ln_seg11 and
                    pn_imp = ln_imd11
               THEN lc_flg :='N';
               WHEN pn_seg = ln_seg12 and
                    pn_imp = ln_imd12
               THEN lc_flg :='N';
               WHEN pn_seg = ln_seg13 and
                    pn_imp = ln_imd13
               THEN lc_flg :='N' ;
               ELSE lc_flg :='S';
             end case ;
        end if;

    end;*/

    begin

      for g in guia loop

        if pn_mda = 0 then
           CASE
               WHEN pn_seg = g.tp1nro3 and  pn_imp = g.tp1imp1  THEN lc_flg := 'N';
               ELSE lc_flg := 'S';
           end case;
        else
             CASE
               WHEN pn_seg = g.tp1nro3 and  pn_imp = g.tp1imp2   THEN lc_flg :='N';
               ELSE lc_flg :='S';
             end case ;
        end if;
      end loop;
    end;
    return lc_flg;
end Fn_Seg_Imp_VC;

Function Fn_Seg_Imp_FS(pn_mda in number,pn_seg in number,pn_imp in number) return char is

  cursor guia1 is
   select *
      from fst198 a
     Where Tp1cod   = 1
       and Tp1cod1  = 10898
       and Tp1corr1 = 18
       and tp1corr3 = 2
       and tp1nro1 = 1
       and tp1nro3 =  pn_seg;
lc_flg char(1);
/*ln_seg24 number(9);
ln_seg25 number(9);
ln_seg26 number(9);
ln_ims24 number(17,2);
ln_ims25 number(17,2);
ln_ims26 number(17,2);
ln_imd24 number(17,2);
ln_imd25 number(17,2);
ln_imd26 number(17,2);
*/
begin

  /*  --Obtener valores de la guia de proceso
    begin
         select a.tp1nro3
           into ln_seg24
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 2
            and tp1corr2 = 4;
    exception when others then null;
    end;

    begin
         select a.tp1nro3
           into ln_seg25
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 2
            and tp1corr2 = 5;
    exception when others then null;
    end;

    begin
         select a.tp1nro3
           into ln_seg26
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 2
            and tp1corr2 = 6;
    exception when others then null;
    end;

    begin
         select a.tp1imp1
           into ln_ims24
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 2
            and tp1corr2 = 4;
    exception when others then null;
    end;

    begin
         select a.tp1imp1
           into ln_ims25
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 2
            and tp1corr2 = 5 ;
    exception when others then null;
    end;

    begin
         select a.tp1imp1
           into ln_ims26
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 2
            and tp1corr2 = 6 ;
    exception when others then null;
    end;

    begin
         select a.tp1imp2
           into ln_imd24
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 2
            and tp1corr2 = 4;
    exception when others then null;
    end;

    begin
         select a.tp1imp2
           into ln_imd25
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 2
            and tp1corr2 = 5;
    exception when others then null;
    end;

    begin
         select a.tp1imp2
           into ln_imd26
           from fst198 a
          Where Tp1cod   = 1
            and Tp1cod1  = 10898
            and Tp1corr1 = 18
            and tp1corr3 = 2
            and tp1corr2 = 6 ;
    exception when others then null;
    end;
    --------------------------------------------

    begin
        if pn_mda = 0 then
           CASE
               WHEN pn_seg = ln_seg24 and
                    pn_imp = ln_ims24
               THEN lc_flg := 'N';

               WHEN pn_seg = ln_seg25 and
                    pn_imp = ln_ims25
               THEN lc_flg := 'N';
               WHEN pn_seg = ln_seg26 and
                    pn_imp = ln_ims26
               THEN lc_flg := 'N';
               ELSE lc_flg := 'S';
             end case;
           else

             CASE
               WHEN pn_seg = ln_seg24 and
                    pn_imp = ln_imd24
               THEN lc_flg :='N';
               WHEN pn_seg = ln_seg25 and
                    pn_imp = ln_imd25
               THEN lc_flg :='N';
               WHEN pn_seg = ln_seg26 and
                    pn_imp = ln_imd26
               THEN lc_flg :='N' ;
               ELSE lc_flg :='S';
             end case ;
         end if;

    end;
    return lc_flg;*/
     begin

      for g in guia1 loop

        if pn_mda = 0 then
           CASE
               WHEN pn_seg = g.tp1nro3 and  pn_imp = g.tp1imp1  THEN lc_flg := 'N';
               ELSE lc_flg := 'S';
           end case;
        else
             CASE
               WHEN pn_seg = g.tp1nro3 and  pn_imp = g.tp1imp2   THEN lc_flg :='N';
               ELSE lc_flg :='S';
             end case ;
        end if;
      end loop;
      return lc_flg;
    end;

end Fn_Seg_Imp_FS;

Procedure Sp_tipo_Seguro (pn_seg in number,pc_flgFS out varchar2,pc_flgVC out varchar2)is

begin

     pc_flgFS := 'N';
     pc_flgVC := 'N';

     --Familia Segura
     begin
          select 'S'
            into pc_flgFS
            from fst198 a
           Where Tp1cod   = 1
             and Tp1cod1  = 10898
             and Tp1corr1 = 18
             and tp1corr3 = 2
             and tp1nro3  = pn_seg;
     exception
       when others then pc_flgFS := 'N';
     end;

     --Vida Caja
     begin
          select 'S'
            into pc_flgVC
            from fst198 a
           Where Tp1cod   = 1
             and Tp1cod1  = 10898
             and Tp1corr1 = 18
             and tp1corr3 = 1
             and tp1nro3  = pn_seg;
     exception
       when others then pc_flgVC := 'N';
     end;

end Sp_tipo_Seguro;

Procedure Sp_Seguro_Ahorro(pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char,
                           pc_flgVC out varchar2)is

lc_seg varchar2(50);

begin
     pc_flgVC := 'N';
     lc_seg := 'VIDA CAJA AHORROS%';
     begin
          pQ_CR_CREDITOS_ALERTAS.SP_CR_TIENE_SEGURO(pn_pai,pn_tdo,pc_ndo,lc_seg,pc_flgVC);


     end;
end Sp_Seguro_Ahorro;

Procedure Sp_codigo_seguro(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pn_seg out number)is

lc_des char(1);
begin
     lc_des := 'N';
     begin
          select 'S'
            into lc_des
            from fsd010 a
           where a.pgcod  = pn_emp
             and a.aomod  = pn_mod
             and a.aosuc  = pn_suc
             and a.aomda  = pn_mda
             and a.aopap  = pn_pap
             and a.aocta  = pn_cta
             and a.aooper = pn_ope
             and a.aosbop = pn_sbo
             and a.aotope = pn_top
             and rownum = 1;
     Exception
         when no_data_found then
              lc_des := 'N';
     end;

     if lc_des = 'S' then
        begin
                 select a.jaqy771sgc
                   into pn_seg
                   from jaqy771 a
                  where a.jaqy771pgc = pn_emp
                    and a.jaqy771mod = pn_mod
                    and a.jaqy771suc = pn_suc
                    and a.jaqy771mda = pn_mda
                    and a.jaqy771pap = pn_pap
                    and a.jaqy771cta = pn_cta
                    and a.jaqy771ope = pn_ope
                    and a.jaqy771sbo = pn_sbo
                    and a.jaqy771top = pn_top
                    and a.jaqy771estd = 'S'
                    ;
            exception
              when too_many_rows then
                   begin
                         select a.jaqy771sgc
                           into pn_seg
                           from jaqy771 a
                          where a.jaqy771pgc = pn_emp
                            and a.jaqy771mod = pn_mod
                            and a.jaqy771suc = pn_suc
                            and a.jaqy771mda = pn_mda
                            and a.jaqy771pap = pn_pap
                            and a.jaqy771cta = pn_cta
                            and a.jaqy771ope = pn_ope
                            and a.jaqy771sbo = pn_sbo
                            and a.jaqy771top = pn_top
                            and a.jaqy771estd = 'S'
                            and a.jaqy771fech = (select max(aa.jaqy771fech)
                                                   from jaqy771 aa
                                                  where aa.jaqy771pgc = a.jaqy771pgc
                                                    and aa.jaqy771mod = a.jaqy771mod
                                                    and aa.jaqy771suc = a.jaqy771suc
                                                    and aa.jaqy771mda = a.jaqy771mda
                                                    and aa.jaqy771pap = a.jaqy771pap
                                                    and aa.jaqy771cta = a.jaqy771cta
                                                    and aa.jaqy771ope = a.jaqy771ope
                                                    and aa.jaqy771sbo = a.jaqy771sbo
                                                    and aa.jaqy771top = a.jaqy771top
                                                    and aa.jaqy771estd = 'S'
                                                  )
                            ;
                    exception
                      when too_many_rows then
                           begin
                                 select a.jaqy771sgc
                                   into pn_seg
                                   from jaqy771 a
                                  where a.jaqy771pgc = pn_emp
                                    and a.jaqy771mod = pn_mod
                                    and a.jaqy771suc = pn_suc
                                    and a.jaqy771mda = pn_mda
                                    and a.jaqy771pap = pn_pap
                                    and a.jaqy771cta = pn_cta
                                    and a.jaqy771ope = pn_ope
                                    and a.jaqy771sbo = pn_sbo
                                    and a.jaqy771top = pn_top
                                    and a.jaqy771estd = 'S'
                                    and a.jaqy771fech = (select max(aa.jaqy771fech)
                                                           from jaqy771 aa
                                                          where aa.jaqy771pgc = a.jaqy771pgc
                                                            and aa.jaqy771mod = a.jaqy771mod
                                                            and aa.jaqy771suc = a.jaqy771suc
                                                            and aa.jaqy771mda = a.jaqy771mda
                                                            and aa.jaqy771pap = a.jaqy771pap
                                                            and aa.jaqy771cta = a.jaqy771cta
                                                            and aa.jaqy771ope = a.jaqy771ope
                                                            and aa.jaqy771sbo = a.jaqy771sbo
                                                            and aa.jaqy771top = a.jaqy771top
                                                            and aa.jaqy771estd = 'S'
                                                          )
                                    and rownum = 1
                                    ;
                            exception
                               when others then null;
                            end;
                    when others then null;
                    end;
            when no_data_found then
               begin
                     select a.sgcod
                       into pn_seg
                       from fpp001 a
                      where a.pgcod  = pn_emp
                        and a.aomod  = pn_mod
                        and a.aosuc  = pn_suc
                        and a.aomda  = pn_mda
                        and a.aopap  = pn_pap
                        and a.aocta  = pn_cta
                        and a.aooper = pn_ope
                        and a.aosbop = pn_sbo
                        and a.aotope = pn_top
                        and a.sgcod in (select tp1nro3
                                          from fst198 a
                                         Where Tp1cod   = 1
                                           and Tp1cod1  = 10898
                                           and Tp1corr1 = 18
                                           and tp1corr3 in (1,2))
                        and rownum = (select max(rownum)
                                        from fpp001 j
                                        where j.pgcod  = pn_emp
                                          and j.aomod  = pn_mod
                                          and j.aosuc  = pn_suc
                                          and j.aomda  = pn_mda
                                          and j.aopap  = pn_pap
                                          and j.aocta  = pn_cta
                                          and j.aooper = pn_ope
                                          and j.aosbop = pn_sbo
                                          and j.aotope = pn_top
                                          and j.sgcod in (select tp1nro3
                                                            from fst198 a
                                                           Where Tp1cod   = 1
                                                             and Tp1cod1  = 10898
                                                             and Tp1corr1 = 18
                                                             and tp1corr3 in (1,2))
                                       );
               exception

                  when others then null;
               end;

            end;
          else

               begin
                     select a.sgcod
                       into pn_seg
                       from fpp001 a
                      where a.pgcod  = pn_emp
                        and a.aomod  = pn_mod
                        and a.aosuc  = pn_suc
                        and a.aomda  = pn_mda
                        and a.aopap  = pn_pap
                        and a.aocta  = pn_cta
                        and a.aooper = pn_ope
                        and a.aosbop = pn_sbo
                        and a.aotope = pn_top
                        and a.sgcod in (select tp1nro3
                                          from fst198 a
                                         Where Tp1cod   = 1
                                           and Tp1cod1  = 10898
                                           and Tp1corr1 = 18
                                           and tp1corr3 in (1,2))
                         and rownum = (select max(rownum)
                                        from fpp001 j
                                        where j.pgcod  = pn_emp
                                          and j.aomod  = pn_mod
                                          and j.aosuc  = pn_suc
                                          and j.aomda  = pn_mda
                                          and j.aopap  = pn_pap
                                          and j.aocta  = pn_cta
                                          and j.aooper = pn_ope
                                          and j.aosbop = pn_sbo
                                          and j.aotope = pn_top
                                          and j.sgcod in (select tp1nro3
                                                            from fst198 a
                                                           Where Tp1cod   = 1
                                                             and Tp1cod1  = 10898
                                                             and Tp1corr1 = 18
                                                             and tp1corr3 in (1,2))
                                       );
               exception
                  when others then null;
               end;
      end if;

      if pn_seg is null or pn_seg = 0 then
         begin
               select a.sgcod
                 into pn_seg
                 from fpp001 a
                where a.pgcod  = pn_emp
                  and a.aomod  = pn_mod
                  and a.aosuc  = pn_suc
                  and a.aomda  = pn_mda
                  and a.aopap  = pn_pap
                  and a.aocta  = pn_cta
                  and a.aooper = pn_ope
                  and a.aosbop = pn_sbo
                  and a.aotope = pn_top
                  and a.sgcod in (select tp1nro1
                                    from fst198 a
                                   Where Tp1cod   = 1
                                     and Tp1cod1  = 10875
                                     and Tp1corr1 = 9);
         exception

            when too_many_rows then
                 begin
                         select a.sgcod
                           into pn_seg
                           from fpp001 a
                          where a.pgcod  = pn_emp
                            and a.aomod  = pn_mod
                            and a.aosuc  = pn_suc
                            and a.aomda  = pn_mda
                            and a.aopap  = pn_pap
                            and a.aocta  = pn_cta
                            and a.aooper = pn_ope
                            and a.aosbop = pn_sbo
                            and a.aotope = pn_top
                            and a.sgcod  in (select tp1nro1
                                               from fst198 a
                                              Where Tp1cod   = 1
                                                and Tp1cod1  = 10875
                                                and Tp1corr1 = 9)
                           and rownum = 1;
                   exception

                      when others then null;
                   end;
             when others then null;
         end;
      end if;
end Sp_codigo_seguro;

Procedure Sp_Resolutores_Ant (pn_ins in number,
                              pc_impseg out varchar2,
                              pn_segaso out number,
                              pn_canfse out number,
                              pn_vidciv out number)is

begin
     --IMPORTE_SEG_CERO
     pc_impseg := 'N';
     begin
          SELECT CASE WHEN COUNT(*) = 0 THEN 'N' ELSE 'S' END
            into pc_impseg
            FROM FPP001 a, xwf700 b
           where a.pgcod     = b.xwfempresa
             and a.aomod     = b.xwfmodulo
             and a.aosuc     = b.xwfsucursal
             and a.aomda     = b.xwfmoneda
             and a.aopap     = b.xwfpapel
             and a.aocta     = b.xwfcuenta
             and a.aooper    = b.xwfoperacion
             and a.aosbop    = b.xwfsubope
             and a.aotope    = b.xwftipope
             and b.xwfcar3   = '1'
             and a.pp001imp  = 0
             and b.xwfprcins = pn_ins;
      exception
             when others then pc_impseg := 'N';
      end;

      --SEGUROS_ASOCIADOS
      begin
           SELECT sgcod
             into pn_segaso
             FROM FPP001 a, xwf700 b
            where a.pgcod     = b.xwfempresa
              and a.aomod     = b.xwfmodulo
              and a.aosuc     = b.xwfsucursal
              and a.aomda     = b.xwfmoneda
              and a.aopap     = b.xwfpapel
              and a.aocta     = b.xwfcuenta
              and a.aooper    = b.xwfoperacion
              and a.aosbop    = b.xwfsubope
              and a.aotope    = b.xwftipope
              and b.xwfcar3   = '1'
              and b.xwfprcins = pn_ins;
       exception
          when others then null;
       end;

       --CANT_F_SEG_SOL  4000-59
       begin
            select count(*)
              into pn_canfse
              from FPP001 a, xwf700 b
             where a.pgcod     = b.xwfempresa
               and a.aomod     = b.xwfmodulo
               and a.aosuc     = b.xwfsucursal
               and a.aomda     = b.xwfmoneda
               and a.aopap     = b.xwfpapel
               and a.aocta     = b.xwfcuenta
               and a.aooper    = b.xwfoperacion
               and a.aosbop    = b.xwfsubope
               and a.aotope    = b.xwftipope
               and b.xwfcar3   = '1'
               and b.xwfprcins = pn_ins
               and sgcod in (select tp1nro3
                               from fst198
                              Where Tp1cod   = 1
                                and Tp1cod1  = 10898
                                and Tp1corr1 = 18
                                and tp1corr3 = 2);--familia segura
       exception
         when others then null;
       end;

       --VIDA_CAJA_PLAN_IV  4000-63
       begin
            select count(*)
              into pn_vidciv
              from FPP001 a, xwf700 b
             where a.pgcod     = b.xwfempresa
               and a.aomod     = b.xwfmodulo
               and a.aosuc     = b.xwfsucursal
               and a.aomda     = b.xwfmoneda
               and a.aopap     = b.xwfpapel
               and a.aocta     = b.xwfcuenta
               and a.aooper    = b.xwfoperacion
               and a.aosbop    = b.xwfsubope
               and a.aotope    = b.xwftipope
               and b.xwfcar3   = '1'
               and b.xwfprcins = pn_ins
               and sgcod in (select tp1nro3
                               from fst198
                              Where Tp1cod   = 1
                                and Tp1cod1  = 10898
                                and Tp1corr1 = 18
                                and tp1corr3 = 1);

        exception
          when others then null;
        end;
end Sp_Resolutores_Ant;

procedure sp_cr_RNG1900( P_D_FECPRO in date,PN_PAIS IN NUMBER,PN_TDOC IN NUMBER,
                          PC_NDOC IN VARCHAR2,PC_USR IN VARCHAR2 )
  IS

     cursor c_clientes is
        select /*+all_rows index_ss(l)*/
               JAQZ099pais, JAQZ099tdoc, JAQZ099ndoc
          from JAQZ099 l
         where /*JAQZ099fech = p_fecpro
           and */l.JAQZ099pais = PN_PAIS
           and l.JAQZ099tdoc = PN_TDOC
           and l.JAQZ099ndoc = PC_NDOC--p_ndoc
           and l.JAQZ099usr  = PC_USR
           ;
--and jaqy162ndoc = '43716599';

     cursor c_reglas is


 select /*+ALL_ROWS*/ g.RNG50ORD,
                t.RNG49COD,
                t.RNG50GRP,
                t.RNG51COD,
                t.RNG68COD,
                t.RNG51OPE,
                t.RNG51VAL,
                a.RNG68ATR,
                a.RNG68TDA,
                g.RNG50Ret
           from FRNG50 g
          inner join frng51 t on g.rng49cod = t.rng49cod
                             and g.rng50grp = t.rng50grp
          inner join frng68 a on t.rng49cod = a.rng49cod
                             and t.rng68cod = a.rng68cod
--          where t.RNG49Cod in (1611, 1612, 1613, 1614, 1617)
          where t.RNG49Cod in (1900)
          order by g.RNG49COD, g.RNG50ORD, t.RNG50GRP, t.RNG51COD;


     cursor c_guia is
      select a.jaqz100ccod,a.jaqz100nreg,a.jaqz100ncal
       from jaqz100 a;

     Regla frng51.rng49cod%type;
     RptaRegla frng50.rng50ret%type;
     la_nomvar PQ_CR_RESABM.tp_nomvar;
     la_valvar PQ_CR_RESABM.tp_valvar;
     la_nomnul PQ_CR_RESABM.tp_nomvar;
     la_valnul PQ_CR_RESABM.tp_valvar;
     ln_var number(3) := 0;
     Tp1desc jaqz100.jaqz100nreg%type;
     cod_rng jaqz100.jaqz100ccod%type;
     --l_jaqy066pano  jaqy066.jaqy066pano%type;
     --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
     l_JAQZ503paic  JAQZ503.JAQZ503paic%type;
     l_JAQZ503tdoc  JAQZ503.JAQZ503tdoc%type;
     l_JAQZ503tndoc JAQZ503.JAQZ503tndoc%type;
     l_JAQZ503calf  JAQZ503.JAQZ503calf%type;
     --l_jaqy066fecp  jaqy066.jaqy066fecp%type;
     --l_jaqy066horp  jaqy066.jaqy066horp%type;

     TYPE tp_pais IS TABLE OF JAQZ099.JAQZ099pais%type INDEX BY BINARY_INTEGER;
     TYPE tp_tdoc IS TABLE OF JAQZ099.JAQZ099tdoc%type INDEX BY BINARY_INTEGER;
     TYPE tp_ndoc IS TABLE OF JAQZ099.JAQZ099ndoc%type INDEX BY BINARY_INTEGER;

     la_JAQZ099pais tp_pais;
     la_JAQZ099tdoc tp_tdoc;
     la_JAQZ099ndoc tp_ndoc;
     la_reglas PQ_CR_RESABM.tb_reglas;
     ln_reg number(5);

     --p_ndoc char(12);
     --ln_tamdoc number(2);
  BEGIN

     execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
     execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS';         --jflor 2014.01.17
     execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';       --jflor 2014.05.05

     --ln_tamdoc := length(trim(PC_NDOC));

     /*case
         when ln_tamdoc = 6 then
              p_ndoc := PC_NDOC||'      ';
         when ln_tamdoc = 7 then
              p_ndoc := PC_NDOC||'     ';
         when ln_tamdoc = 8 then
              p_ndoc := PC_NDOC||'    ';
         when ln_tamdoc = 9 then
              p_ndoc := PC_NDOC||'   ';
         when ln_tamdoc = 10 then
              p_ndoc := PC_NDOC||'  ';
         when ln_tamdoc = 11 then
              p_ndoc := PC_NDOC||' ';
         --else p_ndoc := PC_NDOC;
     end case;*/

     delete from JAQZ503 a where a.JAQZ503paic =PN_PAIS and a.JAQZ503tdoc = PN_TDOC
     and a.JAQZ503tndoc = PC_NDOC and a.JAQZ503usr = PC_USR ;
     commit;
     --l_jaqy066fecp := P_D_FECPRO;
     --l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
     --l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM'));



     Regla := 1900;

     -- Cargar reglas
     ln_reg := 0;
     for r in c_reglas loop
         ln_reg := ln_reg + 1;
         la_reglas(ln_reg).RNG49COD := r.rng49cod;
         la_reglas(ln_reg).RNG50GRP := r.rng50grp;
         la_reglas(ln_reg).RNG51COD := r.rng51cod;
         la_reglas(ln_reg).RNG68COD := r.rng68cod;
         la_reglas(ln_reg).RNG51OPE := r.rng51ope;
         la_reglas(ln_reg).RNG51VAL := r.rng51val;
         la_reglas(ln_reg).RNG68ATR := r.rng68atr;
         la_reglas(ln_reg).RNG68TDA := r.rng68tda;
         la_reglas(ln_reg).RNG50Ret := r.rng50ret;
     end loop;

     OPEN c_clientes;  -- Clientes Bulk
     FETCH c_clientes BULK COLLECT INTO la_JAQZ099pais, la_JAQZ099tdoc, la_JAQZ099ndoc;

     IF la_JAQZ099ndoc.count > 0 THEN
        FOR c IN la_JAQZ099ndoc.FIRST..la_JAQZ099ndoc.LAST LOOP


            la_nomvar := la_nomnul;
            la_valvar := la_valnul;
            pq_cr_resabm.sp_cr_cargar_variables( P_D_FECPRO => P_D_FECPRO,
                                                               P_N_PAIS => la_JAQZ099pais(c),
                                                               P_N_TDOC => la_JAQZ099tdoc(c),
                                                               P_C_NDOC => la_JAQZ099ndoc(c),
                                                               P_C_USR  => PC_USR,
                                                               p_a_nomvar => la_nomvar,
                                                               p_a_valvar => la_valvar,
                                                               p_n_var => ln_var);
            RptaRegla := null;
            pq_cr_resabm.sp_cr_evalua_clientes_1( P_N_REGLA => Regla,
                                                                 P_A_NOMVAR => la_nomvar,
                                                                 P_A_VALVAR => la_valvar,
                                                                 P_N_VAR => ln_var,
                                                                 P_A_REGLAS => la_reglas,
                                                                 P_N_REG => ln_reg,
                                                                 p_c_retorno => RptaRegla);


            Tp1desc := Trim(RptaRegla);
            cod_rng := null;

            For g in c_guia  loop
                If g.jaqz100nreg = Tp1desc Then
                   cod_rng := g.jaqz100ccod;
                End If;
            End Loop;

            If cod_rng is not null then -- Califica
               l_jaqz503paic := la_JAQZ099pais(c);
               l_jaqz503tdoc := la_JAQZ099tdoc(c);
               l_JAQZ503tndoc := la_JAQZ099ndoc(c);
               l_JAQZ503calf := cod_rng;

               insert into JAQZ503 (JAQZ503PAIC, JAQZ503TDOC, JAQZ503TNDOC,
                                   JAQZ503CALF, JAQZ503usr)
               values (l_JAQZ503paic, l_JAQZ503tdoc, l_JAQZ503tndoc,
                      l_JAQZ503calf, PC_USR);
               commit;

           End If;

        END LOOP; -- clientes
    END IF;

End sp_cr_RNG1900;

procedure sp_cr_cargar_variables( P_D_FECPRO IN DATE,
                                    P_N_PAIS IN jaqz099.jaqz099PAIS%type,
                                    P_N_TDOC IN jaqz099.jaqz099TDOC%type,
                                    P_C_NDOC IN jaqz099.jaqz099NDOC%type,
                                    P_C_USR  IN jaqz099.jaqz099USR%type,
                                    p_a_nomvar out pq_cr_resabm.tp_nomvar,
                                    p_a_valvar out pq_cr_resabm.tp_valvar,
                                    p_n_var out number )
  is

     cursor c_cliente is
      select JAQZ099fech, JAQZ099pais, JAQZ099tdoc, JAQZ099ndoc, JAQZ099var1,
               JAQZ099var2, JAQZ099var3, JAQZ099var4, JAQZ099var5, JAQZ099var6,
               JAQZ099var7, JAQZ099var8, JAQZ099var9, JAQZ099var10, JAQZ099var11,
               JAQZ099var12, JAQZ099var13, JAQZ099var14, JAQZ099var15, JAQZ099var16,
               JAQZ099var17, JAQZ099var18, JAQZ099var19, JAQZ099var20, JAQZ099var21,
               JAQZ099var22, JAQZ099var23, JAQZ099var24, JAQZ099var25, JAQZ099var26,
               JAQZ099var27, JAQZ099var28, JAQZ099var29, JAQZ099var30, JAQZ099var31,
               JAQZ099var32, JAQZ099var33, JAQZ099var34, JAQZ099var35, JAQZ099var36,
               JAQZ099var37, JAQZ099var38, JAQZ099var39, JAQZ099var40
          from jaqz099
         where JAQZ099fech = P_D_FECPRO
           and JAQZ099pais = P_N_PAIS
           and JAQZ099tdoc = P_N_TDOC
           and JAQZ099ndoc = P_C_NDOC
           and JAQZ099usr  = P_C_USR;
    ln_tmpnum number(3);

  begin

     for cli in c_cliente loop
         -- Cargando Variables Resuletas
         if trim(cli.JAQZ099var1) is not null then
            p_n_var := 1;
            ln_tmpnum := instr(cli.JAQZ099var1, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var1, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var1, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var2) is not null then
            p_n_var := 2;
            ln_tmpnum := instr(cli.JAQZ099var2, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var2, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var2, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var3) is not null then
            p_n_var := 3;
            ln_tmpnum := instr(cli.JAQZ099var3, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var3, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var3, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var4) is not null then
            p_n_var := 4;
            ln_tmpnum := instr(cli.JAQZ099var4, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var4, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var4, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var5) is not null then
            p_n_var := 5;
            ln_tmpnum := instr(cli.JAQZ099var5, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var5, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var5, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var6) is not null then
            p_n_var := 6;
            ln_tmpnum := instr(cli.JAQZ099var6, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var6, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var6, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var7) is not null then
            p_n_var := 7;
            ln_tmpnum := instr(cli.JAQZ099var7, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var7, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var7, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var8) is not null then
            p_n_var := 8;
            ln_tmpnum := instr(cli.JAQZ099var8, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var8, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var8, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var9) is not null then
            p_n_var := 9;
            ln_tmpnum := instr(cli.JAQZ099var9, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var9, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var9, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var10) is not null then
            p_n_var := 10;
            ln_tmpnum := instr(cli.JAQZ099var10, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var10, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var10, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var11) is not null then
            p_n_var := 11;
            ln_tmpnum := instr(cli.JAQZ099var11, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var11, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var11, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var12) is not null then
            p_n_var := 12;
            ln_tmpnum := instr(cli.JAQZ099var12, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var12, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var12, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var13) is not null then
            p_n_var := 13;
            ln_tmpnum := instr(cli.JAQZ099var13, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var13, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var13, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var14) is not null then
            p_n_var := 14;
            ln_tmpnum := instr(cli.JAQZ099var14, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var14, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var14, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var15) is not null then
            p_n_var := 15;
            ln_tmpnum := instr(cli.JAQZ099var15, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var15, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var15, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var16) is not null then
            p_n_var := 16;
            ln_tmpnum := instr(cli.JAQZ099var16, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var16, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var16, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var17) is not null then
            p_n_var := 17;
            ln_tmpnum := instr(cli.JAQZ099var17, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var17, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var17, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var18) is not null then
            p_n_var := 18;
            ln_tmpnum := instr(cli.JAQZ099var18, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var18, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var18, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var19) is not null then
            p_n_var := 19;
            ln_tmpnum := instr(cli.JAQZ099var19, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var19, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var19, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var20) is not null then
            p_n_var := 20;
            ln_tmpnum := instr(cli.JAQZ099var20, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var20, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var20, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var21) is not null then
            p_n_var := 21;
            ln_tmpnum := instr(cli.JAQZ099var21, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var21, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var21, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var22) is not null then
            p_n_var := 22;
            ln_tmpnum := instr(cli.JAQZ099var22, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var22, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var22, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var23) is not null then
            p_n_var := 23;
            ln_tmpnum := instr(cli.JAQZ099var23, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var23, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var23, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var24) is not null then
            p_n_var := 24;
            ln_tmpnum := instr(cli.JAQZ099var24, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var24, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var24, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var25) is not null then
            p_n_var := 25;
            ln_tmpnum := instr(cli.JAQZ099var25, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var25, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var25, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var26) is not null then
            p_n_var := 26;
            ln_tmpnum := instr(cli.JAQZ099var26, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var26, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var26, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var27) is not null then
            p_n_var := 27;
            ln_tmpnum := instr(cli.JAQZ099var27, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var27, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var27, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var28) is not null then
            p_n_var := 28;
            ln_tmpnum := instr(cli.JAQZ099var28, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var28, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var28, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var29) is not null then
            p_n_var := 29;
            ln_tmpnum := instr(cli.JAQZ099var29, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var29, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var29, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var30) is not null then
            p_n_var := 30;
            ln_tmpnum := instr(cli.JAQZ099var30, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var30, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var30, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var31) is not null then
            p_n_var := 31;
            ln_tmpnum := instr(cli.JAQZ099var31, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var31, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var31, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var32) is not null then
            p_n_var := 32;
            ln_tmpnum := instr(cli.JAQZ099var32, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var32, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var32, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var33) is not null then
            p_n_var := 33;
            ln_tmpnum := instr(cli.JAQZ099var33, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var33, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var33, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var34) is not null then
            p_n_var := 34;
            ln_tmpnum := instr(cli.JAQZ099var34, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var34, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var34, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var35) is not null then
            p_n_var := 35;
            ln_tmpnum := instr(cli.JAQZ099var35, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var35, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var35, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var36) is not null then
            p_n_var := 36;
            ln_tmpnum := instr(cli.JAQZ099var36, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var36, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var36, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var37) is not null then
            p_n_var := 37;
            ln_tmpnum := instr(cli.JAQZ099var37, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var37, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var37, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var38) is not null then
            p_n_var := 38;
            ln_tmpnum := instr(cli.JAQZ099var38, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var38, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var38, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var39) is not null then
            p_n_var := 39;
            ln_tmpnum := instr(cli.JAQZ099var39, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var39, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var39, ln_tmpnum + 1);
         end if;

         if trim(cli.JAQZ099var40) is not null then
            p_n_var := 40;
            ln_tmpnum := instr(cli.JAQZ099var40, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ099var40, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ099var40, ln_tmpnum + 1);
         end if;

     end loop;

end sp_cr_cargar_variables;

procedure sp_cr_evalua_clientes_1( P_N_REGLA IN NUMBER,
                                     P_A_NOMVAR IN pq_cr_resabm.tp_nomvar,
                                     P_A_VALVAR IN pq_cr_resabm.tp_valvar,
                                     P_N_VAR IN number,
                                     P_A_REGLAS in pq_cr_resabm.tb_reglas,
                                     P_N_REG in number,
                                     p_c_retorno out varchar2)
  IS


     cursor c_lista(p_RNG49Cod number, p_RNG50Grp number, p_RNG51COD number) is
        select RNG49Cod, RNG50Grp, RNG51COD, RNG67COR, RNG67VAL
          from FRNG67
         where RNG49Cod = p_RNG49Cod
           and RNG50Grp = p_RNG50Grp
           and RNG51COD = p_RNG51COD
         order by RNG67COR;

     ExisteGrupo char(1) := null;
     ResReglaGrupo char(1) := null;
     ResReglaLista char(1) := null;
     Regla frng51.rng49cod%type;
     --Regla2 frng51.rng49cod%type;
     l_RNG50Grp frng51.rng50grp%type;
     l_RNG50Ret frng50.rng50ret%type;
     la_nomvar pq_cr_resabm.tp_nomvar;
     la_valvar pq_cr_resabm.tp_valvar;
     ln_var number(3) := 0;
     lc_valResuelto varchar2(30);
     i number(5);
     ln_NumTmp1 number(10,2);
     ln_NumTmp2 number(10,2);
     --l_RNG68Tda frng68.rng68tda%type;
     --SegmentoRegla2 frng51.rng51val%type;
     l_RNG51Val varchar2(30);
     l_RNG67val varchar2(30);
     l_RNG51OPE varchar2(2);
     la_reglas pq_cr_resabm.tb_reglas;
     ln_reg number(5);
     ln_ind number(5);

  BEGIN

     Regla := nvl(P_N_REGLA, 0);
     la_nomvar := p_a_nomvar;
     la_valvar := p_a_valvar;
     ln_var    := nvl(p_n_var, 0);
     la_reglas := P_A_REGLAS;
     ln_reg    := nvl(P_N_REG, 0);

     For reg in 1..ln_reg loop
        If la_reglas(reg).RNG49COD = Regla then
            l_RNG50Ret := la_reglas(reg).RNG50Ret;
            l_RNG50Grp := la_reglas(reg).RNG50GRP;
            ExisteGrupo := 'S';
            ln_ind := reg;
            Exit;
        End If;
     End loop;

     If ExisteGrupo = 'S' then --existe grupo

        -- Evaluando Variables
        ResReglaGrupo := 'S';


        WHILE la_reglas(ln_ind).RNG49COD = Regla LOOP

                If la_reglas(ln_ind).RNG50GRP <> l_RNG50Grp then --evaluar cambio de grupo
                    --Msg('Diferente grupo')
                    If ResReglaGrupo = 'N' And la_reglas(ln_ind).RNG50GRP = 999 then --Retorno Default (Condición ELSE)
                        --Msg('Retorno Default (Condición ELSE)')
                        p_c_retorno := la_reglas(ln_ind).RNG50Ret;
                        --ResReglaGrupo := 'S';
                        --Msg(p_c_retorno)
                        Exit;
                    End If;

                    If ResReglaGrupo = 'S' then --se cumple la regla para el grupo anterior
                        --Msg('grupo cumplido')
                        p_c_retorno := l_RNG50Ret ;
                        --ResReglaGrupo := 'S';
                        --Msg(p_c_retorno)
                        Exit;
                    Else --evaluar el siguiente grupo de la regla
                        --Msg('cambio de grupo')
                        l_RNG50Grp := la_reglas(ln_ind).RNG50GRP;
                        l_RNG50Ret := la_reglas(ln_ind).RNG50Ret;
                        --Msg('grupo : '+Str(RNG50Grp))
                        ResReglaGrupo := 'S';
                        --Do 'Limpiar VExpresion'
                    End If;
                End If;

                -- Encontrar valor resuelto de atributo
                lc_valResuelto := '0';
                For i in 1..ln_var loop
                    If la_nomvar(i) = trim(la_reglas(ln_ind).RNG68ATR) then
                        lc_valResuelto := trim(la_valvar(i));
                        Exit;
                    End If;
                End loop;

                -- Resolver Regla anidada Nivel 2
--                If la_reglas(ln_ind).RNG68ATR in ('EXP1612','EXP1613','EXP1614','EXP1617') then
                --If la_reglas(ln_ind).RNG68ATR = 'EXP1621' then

                    --Regla2 := to_number(substr(la_reglas(ln_ind).RNG68ATR,4,4));
                    --Msg('rutina regla anidada ' + Str(&Regla2))
                    --SegmentoRegla2 := null;
                    --PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_2_NS( P_N_REGLA => Regla2,
                    --                                                     P_A_NOMVAR => la_nomvar,
                    --                                                     P_A_VALVAR => la_valvar,
                     --                                                    P_N_VAR => ln_var,
                     --                                                    P_A_REGLAS => la_reglas,
                     --                                                    P_N_REG => ln_reg,
                     --                                                    p_c_retorno => SegmentoRegla2);
                    --lc_valResuelto := Trim(SegmentoRegla2);

               -- End If;

                -- Evaluacion de condiciones
                l_RNG51Val := nvl(trim(la_reglas(ln_ind).RNG51VAL),'0');

                if lc_valResuelto = '100' then
                   lc_valResuelto := '100.00';
                end if;
                if l_RNG51Val = '100' then
                   l_RNG51Val := '100.00';
                end if;

                l_RNG51OPE := trim(la_reglas(ln_ind).RNG51OPE);
                Case l_RNG51OPE
                When '>=' then
                    --Msg('es mayor igual que ' + l_RNG51Val)
                    --Msg(ValResuelto)
                    ln_NumTmp1 := to_number(lc_valResuelto);
                    ln_NumTmp2 := to_number(l_RNG51Val);
                    If ln_NumTmp1 < ln_NumTmp2 then
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;

                When '>' then
                    --Msg('es mayor que ' + l_RNG51Val)
                    --Msg(lc_lc_valResuelto)
                    ln_NumTmp1 := to_number(lc_valResuelto);
                    ln_NumTmp2 := to_number(l_RNG51Val);
                    If ln_NumTmp1 <= ln_NumTmp2 then
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;

                When '<=' then
                    --Msg('es menor igual que ' + l_RNG51Val)
                    --Msg(lc_valResuelto)
                    ln_NumTmp1 := to_number(lc_valResuelto);
                    ln_NumTmp2 := to_number(l_RNG51Val);
                    If ln_NumTmp1 > ln_NumTmp2  then --to_number(lc_valResuelto) > to_number(l_RNG51Val)
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;

                When '<' then
                    --Msg('es menor que ' + l_RNG51Val)
                    --Msg(lc_valResuelto)
                    ln_NumTmp1 := to_number(lc_valResuelto);
                    ln_NumTmp2 := to_number(l_RNG51Val);
                    If ln_NumTmp1 >= ln_NumTmp2 then --to_number(lc_valResuelto) >= to_number(reg.RNG51VAL)
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;

                When '=' then
                    --Msg('es igual que ' + VeRNG51VAL(j))
                    --Msg(ValResuelto)
                    If lc_valResuelto <> l_RNG51Val then
                        --Msg('no cumple ' + VeRNG68ATR(j))
                        ResReglaGrupo := 'N';
                    End If;


                When '<>' then
                    --Msg('es diferente que ' + VeRNG51VAL(j))
                    --Msg(ValResuelto)

                    If lc_valResuelto = l_RNG51Val then
                         --Msg('no cumple ' + VeRNG68ATR(j))
                        ResReglaGrupo := 'N';
                     End If;


                When 'EN' then
                     ResReglaLista := 'N';
                     -- valores de evaluacion lista
                     For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop
                         --Msg('esta EN ' + MVaLista(i, 4))
                         l_RNG67val := trim(lis.rng67val);
                         If lc_valResuelto = l_RNG67val then
                             ResReglaLista := 'S';
                             Exit;
                         End If;
                     End Loop;
                     --Msg(lc_valResuelto)
                     If ResReglaLista = 'N' then
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                     End If;

                When 'NE' then
                    ResReglaLista := 'N';
                    For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop
                        --Msg('NO esta EN ' + MVaLista(i, 4))
                        l_RNG67val := trim(lis.rng67val);
                        If lc_valResuelto = l_RNG67val then
                           ResReglaLista := 'S';
                           Exit;
                        End If;
                    End Loop;
                    --Msg(lc_valResuelto)
                    If ResReglaLista = 'S' then
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;

                Else
                    ResReglaGrupo := 'N'; --faltan variaciones de like y not like

                End Case;

             --END IF; -- regla evaluada
             ln_ind := ln_ind + 1;

          END LOOP; -- reglas

     End If; -- existe grupo

END sp_cr_evalua_clientes_1;


Procedure Sp_maximaFecha(pn_ins in number,pd_fec out date)is
begin
     begin
         select max(a.wfiteminit)
           into pd_fec
           from wfwrkitems a
          where a.wfinsprcid = pn_ins
            and a.wfiteminit >= to_date('2013.07.01','yyyy.mm.dd');
     exception
            when too_many_rows then
                 begin
                     select max(a.wfiteminit)
                       into pd_fec
                       from wfwrkitems a
                      where a.wfinsprcid = pn_ins
                        and a.wfiteminit >= to_date('2013.07.01','yyyy.mm.dd')
                        and rownum = 1;
                 exception
                        when others then null;

                 end;
             when others then null;
     end;
end Sp_maximaFecha;

Procedure Sp_IndicadorFlujo(pn_ins in number,lc_flg out varchar2)is
pd_fec date;
begin
     pq_cr_resabm.Sp_maximaFecha(pn_ins,pd_fec);
     lc_flg := 'N';
     begin
          select 'S'
            into lc_flg
            from wfwrkitems a
           where WFInsPrcId = pn_ins
             and WFStsCod not in ('C', 'D', 'B', 'E', 'T')
             and WFItemInit >= pd_fec
             and WFTaskCod = 55
             and WFItemInit >= to_date('2013.07.01','yyyy.mm.dd')
             and rownum = 1;
     exception
       when others then
         lc_flg := 'N';
     end;


end;

Procedure Sp_Historial(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date,
                         ln_contador out number)  is

cursor creditos is
select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       a.aofval,
       a.aofvto,
       --a.aofe99,
       pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,aofe99)aofe99,
       a.aostat
  from fsd010 a, fsr008 b
 where aomod in (select modulo from fst111 where dscod = 50 and modulo not in (200,33,108))
   --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
   and aotope <> 550
   and a.pgcod = 1
   and a.pgcod = b.pgcod
   and a.aocta = b.ctnro
   and b.pepais = pn_pai
   and b.petdoc = pn_tdo
   and b.pendoc = pc_ndo
   and b.cttfir = 'T'
   and b.ttcod = 1
order by aofval;

ld_fecantD date;
ld_fecantC date;

ln_mesac number(2);
ln_aniac number(4);
ln_mesan number(2);
ln_anian number(4);
ln_suma number(5);

ld_aofval date;
ld_aofe99 date;
ld_sysdate DATE;

ln_sw number(1);
begin


    begin
    ln_contador := 0;
    ld_fecantD := null;
    ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    ld_sysdate := last_day(pd_fecpro );
    For i in creditos loop

    ln_sw := 0;
      if (i.aofe99 is null or i.aofe99 = to_date('0001.01.01','yyyy.mm.dd'))and i.aostat = 99 then
         ln_sw := 1;

      end if;
      if ln_sw = 0 then

        ln_mesac := to_number(to_char(i.aofval,'mm'));
        ln_aniac := to_number(to_char(i.aofval,'yyyy'));
        ln_suma := null;
        ld_aofval := i.aofval;
        ld_aofe99 := last_day(i.aofe99);


        if ld_fecantD is null then
              if i.aostat = 99 then
                 ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                 if ln_suma <0 then
                    ln_suma := 0;
                 end if;
                 ln_contador := ln_contador + ln_suma;
                 else
                     ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                     if ln_suma <0 then
                        ln_suma := 0;
                     end if;
                     ln_contador := ln_contador + ln_suma;

              end if;

              Else

                  if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                     if i.aostat = 99 then
                          ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                           if ln_suma <0 then
                              ln_suma := 0;
                           end if;
                          ln_contador := ln_contador + ln_suma;

                          else
                            ln_suma := trunc(months_between(ld_sysdate,
                                                               ld_aofval));
                             if ln_suma <0 then
                                ln_suma := 0;
                             end if;
                            ln_contador := ln_contador + ln_suma;
                      end if;

                      else
                          if ld_aofval < ld_fecantC then
                             --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));
                             ld_aofval :=  ld_fecantC;
                             if i.aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                   if ln_suma <0 then
                                      ln_suma := 0;
                                   end if;

                                  ln_contador := ln_contador + ln_suma;-- - ln_aux;

                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval));
                                     if ln_suma <0 then
                                        ln_suma := 0;
                                     end if;

                                    ln_contador := ln_contador + ln_suma;-- - ln_aux;
                              end if;



                          end if;

                          if ld_aofval > ld_fecantC then

                             if i.aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                   if ln_suma <0 then
                                      ln_suma := 0;
                                   end if;
                                  ln_contador := ln_contador + ln_suma;

                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                                     if ln_suma <0 then
                                        ln_suma := 0;
                                     end if;
                                    ln_contador := ln_contador + ln_suma;
                              end if;



                          end if;


                  end if;

        end if;

        if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
           if ld_fecantC > i.aofval then
              ld_aofval := ld_fecantC;
           end if;
           ld_fecantC := pd_Fecpro;--trunc(sysdate);
        end if;

        if i.aofe99 > ld_fecantC then
                    --ld_fecantD := ld_aofval;
                     ld_fecantC := i.aofe99;

        end if;
        ld_fecantD := ld_aofval;




        ln_mesan := to_number(to_char(ld_fecantC,'mm'));
        ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
      end if;
    end loop;

    END;



end Sp_Historial;

Procedure Sp_SegVinc(pn_ins in number,pc_flg out varchar2) is
pn_countDes number(5);
pn_countMov number(5);
pn_countGar number(5);
begin
--Misma solicitud mas de 1 seguro
     --desgravamen
     begin
     select count(*)
       into pn_countDes
       from fpp001 gg,xwf700 h
      where gg.sgcod  in (select a.sgcod
                            from fst300 a
                           where a.sgsn02 = 5)
        and gg.pgcod  = h.xwfempresa
        and gg.aomod  = h.xwfmodulo
        and gg.aosuc  = h.xwfsucursal
        and gg.aomda  = h.xwfmoneda
        and gg.aopap  = h.xwfpapel
        and gg.aocta  = h.xwfcuenta
        and gg.aooper = h.xwfoperacion
        and gg.aosbop = h.xwfsubope
        and gg.aotope = h.xwftipope
        and h.xwfcar3 = '1'
        and h.xwfprcins = pn_ins
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfprcins =pn_ins and xwfcar3 <> '1');
     exception
     when others then null;
     end;

     --movigas
     begin
     select count(*)
       into pn_countMov
       from fpp001 gg,xwf700 h
      where gg.sgcod  in (select a.sgcod
                            from fst300 a
                           where a.sgsn02 = 2)
        and gg.pgcod  = h.xwfempresa
        and gg.aomod  = h.xwfmodulo
        and gg.aosuc  = h.xwfsucursal
        and gg.aomda  = h.xwfmoneda
        and gg.aopap  = h.xwfpapel
        and gg.aocta  = h.xwfcuenta
        and gg.aooper = h.xwfoperacion
        and gg.aosbop = h.xwfsubope
        and gg.aotope = h.xwftipope
        and h.xwfcar3 = '1'
        and h.xwfprcins = pn_ins
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfprcins =pn_ins and xwfcar3 <> '1');
     exception
     when others then null;
     end;

     --garantia
     begin
     select count(*)
       into pn_countGar
       from fpp001 gg,xwf700 h
      where gg.sgcod  in (select a.sgcod
                            from fst300 a
                           where a.sgsn02 = 3)
        and gg.pgcod  = h.xwfempresa
        and gg.aomod  = h.xwfmodulo
        and gg.aosuc  = h.xwfsucursal
        and gg.aomda  = h.xwfmoneda
        and gg.aopap  = h.xwfpapel
        and gg.aocta  = h.xwfcuenta
        and gg.aooper = h.xwfoperacion
        and gg.aosbop = h.xwfsubope
        and gg.aotope = h.xwftipope
        and h.xwfcar3 = '1'
        and h.xwfprcins = pn_ins
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfprcins =pn_ins and xwfcar3 <> '1');
     exception
     when others then null;
     end;

     if pn_countGar  >=2 or pn_countMov>=2 or pn_countDes>=2 then
       pc_flg := 'S';
       else
          pc_flg := 'N';
    END IF;

end Sp_SegVinc;
Procedure Sp_Edad_AsisMedica(pn_pai    in number,
                             pn_tdo    in number,
                             pc_doc    in char,
                             pd_fecpro in date,
                             pc_flag   out varchar2) is
  ld_fec  date;
  ln_edad number(5);
begin
  begin
    select a.pffnac
      into ld_fec
      from fsd002 a
     where a.pfpais = pn_pai
       and a.pftdoc = pn_tdo
       and a.pfndoc = pc_doc;
  exception
    when others then
      null;
  end;
  if ld_fec is not null then
    ln_edad := floor(MONTHS_BETWEEN(pd_fecpro, ld_fec) / 12);
    if ln_edad >= 18 and ln_edad < 66 then
      pc_flag := 'S';
    else
      pc_flag := 'N';
    end if;
  else
    pc_flag := 'S';
  end if;

end Sp_Edad_AsisMEdica;
Procedure Sp_codigo_seguro_multi(pn_emp in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number,
                                 pn_seg out number)is

lc_des char(1);
begin
   /*  lc_des := 'N';
     begin
          select 'S'
            into lc_des
            from fsd010 a
           where a.pgcod  = pn_emp
             and a.aomod  = pn_mod
             and a.aosuc  = pn_suc
             and a.aomda  = pn_mda
             and a.aopap  = pn_pap
             and a.aocta  = pn_cta
             and a.aooper = pn_ope
             and a.aosbop = pn_sbo
             and a.aotope = pn_top
             and rownum = 1;
     Exception
         when no_data_found then
              lc_des := 'N';
     end;

     if lc_des = 'S' then*/

         begin
               select a.sgcod
                 into pn_seg
                 from fpp001 a
                where a.pgcod  = pn_emp
                  and a.aomod  = pn_mod
                  and a.aosuc  = pn_suc
                  and a.aomda  = pn_mda
                  and a.aopap  = pn_pap
                  and a.aocta  = pn_cta
                  and a.aooper = pn_ope
                  and a.aosbop = pn_sbo
                  and a.aotope = pn_top
                  and a.sgcod in (select tp1nro1
                                    from fst198 a
                                   Where Tp1cod   = 1
                                     and Tp1cod1  = 10875
                                     and Tp1corr1 = 9);
         exception
            when no_Data_Found then
               pn_seg:=0;
            when too_many_rows then
                 begin
                         select a.sgcod
                           into pn_seg
                           from fpp001 a
                          where a.pgcod  = pn_emp
                            and a.aomod  = pn_mod
                            and a.aosuc  = pn_suc
                            and a.aomda  = pn_mda
                            and a.aopap  = pn_pap
                            and a.aocta  = pn_cta
                            and a.aooper = pn_ope
                            and a.aosbop = pn_sbo
                            and a.aotope = pn_top
                            and a.sgcod  in (select tp1nro1
                                               from fst198 a
                                              Where Tp1cod   = 1
                                                and Tp1cod1  = 10875
                                                and Tp1corr1 = 9)
                           and rownum = 1;
                   exception

                      when others then  pn_seg:=0;
                   end;
             when others then  pn_seg:=0;
         end;
    --  end if;
end Sp_codigo_seguro_multi;

Procedure Sp_Tiene_Multiriesgo (pn_ins in number,
                                pc_flg out varchar2)is

existe number;
begin

     begin
     select 1
       into existe
       from xwf700 h , fpp001 gg
      where h.xwfprcins = pn_ins
        and h.xwfcar3 = '1'
        and gg.pgcod  = h.xwfempresa
        and gg.aomod  = h.xwfmodulo
        and gg.aosuc  = h.xwfsucursal
        and gg.aomda  = h.xwfmoneda
        and gg.aopap  = h.xwfpapel
        and gg.aocta  = h.xwfcuenta
        and gg.aooper = h.xwfoperacion
        and gg.aosbop = h.xwfsubope
        and gg.aotope = h.xwftipope
        and gg.sgcod  in (select tp1nro1
                            from fst198 a
                           Where Tp1cod = 1
                             and Tp1cod1 = 10875
                             and Tp1corr1 = 9);


     exception
     when no_data_found  then
       existe:= 0;
     when too_many_rows then
       existe:= 1;
     end;

     if existe = 1 then
       pc_flg := 'S';
     else
       pc_flg := 'N';
     end if;

end Sp_Tiene_Multiriesgo;

  Procedure Sp_Cantidad_Multiriesgo (pn_ins in number,
                                     pn_contador out number) is

  begin

     select count(*)
       into pn_contador
       from xwf700 h , fpp001 gg
      where h.xwfprcins = pn_ins
        and h.xwfcar3 = '1'
        and gg.pgcod  = h.xwfempresa
        and gg.aomod  = h.xwfmodulo
        and gg.aosuc  = h.xwfsucursal
        and gg.aomda  = h.xwfmoneda
        and gg.aopap  = h.xwfpapel
        and gg.aocta  = h.xwfcuenta
        and gg.aooper = h.xwfoperacion
        and gg.aosbop = h.xwfsubope
        and gg.aotope = h.xwftipope
        and gg.sgcod  in (select tp1nro1
                            from fst198 a
                           Where Tp1cod = 1
                             and Tp1cod1 = 10875
                             and Tp1corr1 = 9);

        if pn_contador is null then
          pn_contador := 0;
        end if;
  end Sp_Cantidad_Multiriesgo;
  Procedure Sp_codigo_seguro_garantia(pn_emp in number,
                                       pn_mod in number,
                                       pn_suc in number,
                                       pn_mda in number,
                                       pn_pap in number,
                                       pn_cta in number,
                                       pn_ope in number,
                                       pn_sbo in number,
                                       pn_top in number,
                                       pn_seg out number)is

  lc_des char(1);
  begin

        begin
             select a.sgcod
               into pn_seg
               from fpp001 a
              where a.pgcod  = pn_emp
                and a.aomod  = pn_mod
                and a.aosuc  = pn_suc
                and a.aomda  = pn_mda
                and a.aopap  = pn_pap
                and a.aocta  = pn_cta
                and a.aooper = pn_ope
                and a.aosbop = pn_sbo
                and a.aotope = pn_top
                and a.sgcod in (select tp1nro1
                                  from fst198 a
                                 Where Tp1cod   = 1
                                   and Tp1cod1  = 10875
                                   and Tp1corr1 = 10);
       exception
         when no_Data_Found then

		 pn_seg := 0;
          when too_many_rows then
               begin
                       select a.sgcod
                         into pn_seg
                         from fpp001 a
                        where a.pgcod  = pn_emp
                          and a.aomod  = pn_mod
                          and a.aosuc  = pn_suc
                          and a.aomda  = pn_mda
                          and a.aopap  = pn_pap
                          and a.aocta  = pn_cta
                          and a.aooper = pn_ope
                          and a.aosbop = pn_sbo
                          and a.aotope = pn_top
                          and a.sgcod  in (select tp1nro1
                                             from fst198 a
                                            Where Tp1cod   = 1
                                              and Tp1cod1  = 10875
                                              and Tp1corr1 = 10)
                         and rownum = 1;
                 exception

                    when others then
                     pn_seg := 0;
                 end;
           when others then  pn_seg := 0;
       end;
end Sp_codigo_seguro_garantia;

end PQ_CR_RESABM;
/

