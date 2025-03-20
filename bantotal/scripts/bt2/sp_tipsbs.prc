CREATE OR REPLACE PROCEDURE SP_tipSBS ( pn_cta in number,
                                        pn_ope in number,
                                        pn_mod in number, 
                                        pc_sbs in varchar2, 
                                        cod_tipsbs OUT varchar2 ) is
                    
lc_tipsbs char(30);
lc_codsbs char(2);
ld_fecrcc date;
ln_TipoDni number(2);
ln_TipoRuc number(2);
ln_TipoCex number(2);
lc_C_TDOCID char(1);
cod_sbs VARCHAR2(10);
ln_rubtmp number(6);  --kvalenciac 02/06/2023 number(4)

begin

    ln_TipoDni := 21;
    ln_TipoRuc := 9;
    ln_TipoCex := 2 ;
    lc_codsbs := null;

    begin
      select to_date(Tpnro,'dd.mm.yyyy')
      into ld_fecrcc
      from fst098
      where Pgcod = 1
      and Tpcod = 7647
      and Tpcorr = 12;
    end;

    begin
          select distinct a.c_cretip
            into lc_codsbs
            from cldrccs a
           where a.c_codsbs =pc_sbs
             and a.d_fecpre =ld_fecrcc;
    exception
           when no_data_found then
                lc_codsbs := null;
           when too_many_rows then
                begin
                      select distinct a.c_cretip
                          into lc_codsbs
                          from cldrccs a
                         where a.c_codsbs =pc_sbs
                           and a.d_fecpre =ld_fecrcc
                           and substr(a.c_cuenta,1,4) in (select jaqz109rub from jaqz109)
                           and a.c_codemp = '00104';
                exception
                when too_many_rows then
                     begin
                          select substr(a.jaqy953rub,1,6)--kvalenciac 02/06/2023   substr(a.jaqy953rub,1,4)
                            into ln_rubtmp
                            from jaqy953 a
                           where a.jaqy953cta =pn_cta
                             and a.jaqy953ope =pn_ope;
                     end;

                     begin
                      select distinct a.c_cretip
                          into lc_codsbs
                          from cldrccs a
                         where a.c_codsbs =pc_sbs
                           and a.d_fecpre =ld_fecrcc
                           and a.c_codemp = '00104'
                           and substr(a.c_cuenta,1,6)=to_char(ln_rubtmp)  --kvalenciac 02/06/2023  substr(a.c_cuenta,1,4)=to_char(ln_rubtmp)
                           and rownum=1;
                     exception
                           when too_many_rows then
                                lc_codsbs := null;
                     end;


                when no_data_found then
                    lc_codsbs := null;
                end;
    end;

    cod_tipsbs := lc_codsbs;
    
    if lc_codsbs is null then
      cod_tipsbs := '99';
    end if;

end sp_tipSBS;
/

