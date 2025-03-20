create or replace package PQ_OCUM_VERIFICACION_TM_TUE_MC is
 
  Procedure SP_Multiples (pd_fecpro in date);
  Function fn_analista ( pn_cta in number) return varchar2 ;
  Function Fn_Ejecutivo (pn_pais in number, pn_tdoc in number, pc_ndoc in char) return varchar2;                      
  Procedure SP_Unicas (PD_FECINI in date, PD_FECFIN in date);
  Procedure SP_MenorCuantia (PD_FECINI in date,PD_FECFIN in date);
  Procedure SP_Consolidar(pd_fecpro in string);
  function fn_actividad (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return char;
  function fn_sector (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return char;
end PQ_OCUM_VERIFICACION_TM_TUE_MC;
/

create or replace package body PQ_OCUM_VERIFICACION_TM_TUE_MC is

Procedure SP_Multiples (pd_fecpro in date) is

--CURSOR QUE ALMACENA LAS OPERACIONES MULTIPLES
cursor trans_multi (ld_fech in date, ln_tipcam in number) is
--create table repom as 
select DISTINCT bc606pais,bc606tdoc,bc606ndoc,bc606fch,bc606treg,bc606impa,
       
       (select c.penom from fsd001 c where bc606pais = c.pepais
              and bc606tdoc = c.petdoc
              and bc606ndoc = c.pendoc)NombreCliente,
       (select f.sngc13dir from sngc13 f where f.sngc13pais = bc606pais 
               and bc606tdoc = f.sngc13tdoc
               and bc606ndoc = f.sngc13ndoc
               and f.docod = 1
               and f.sngc13est = 'H')DireccionCliente,
       (select b.dotelfp from fsr005 b where bc606pais = b.pepais 
              and bc606tdoc = b.petdoc 
              and bc606ndoc = b.pendoc
              and rownum = 1) telefonoCliente,
       (select (trim(d.bc602nom)||' '||trim(d.bc602ape)||' '||trim(d.bc602apem)) from fbc602 d where bc606pais = d.bc602pais
               and bc606tdoc = d.bc602tdoc 
               and bc606ndoc = d.bc602ndoc)NombreNoCliente,--Descripcion del cliente que no tiene cuenta en la Caja
       (select d.bc602dire from fbc602 d where bc606pais = d.bc602pais
               and bc606tdoc = d.bc602tdoc 
               and bc606ndoc = d.bc602ndoc)DireccionNoCliente,
       (select d.bc602telr from fbc602 d where bc606pais = d.bc602pais
               and bc606tdoc = d.bc602tdoc 
               and bc606ndoc = d.bc602ndoc)TelefonoNoCliente,
        
        bc607emp,
        bc607mod,
        bc607suc,
        bc607trn,
        bc607nrel,
        bc607fch
        
                     
from (
--sacar la sucursal de mayor monto sin considerar aun las cuentas
      select bc606tdoc,
             bc606pais,
             bc606ndoc,
             bc606fch,
             bc606treg,
             bc606impa,
             bc607emp,
             bc607mod,
             bc607suc,
             bc607trn,
             bc607nrel,
             bc607fch,
             dense_rank() over(partition by bc606tdoc, bc606ndoc, bc606fch, bc606treg, bc606impa,n_priori order by bc607mod,bc607suc,bc607trn,bc607nrel,bc607fch desc nulls last) n_priori2
        from (select distinct bc606tdoc,
                              bc606pais,
                              bc606ndoc,
                              bc606fch,
                              bc606treg,
                              bc606impa,
                              bc607emp,
                              bc607mod,
                              bc607suc,
                              bc607trn,
                              bc607nrel,
                              bc607fch,
                              dense_rank() over(partition by bc606tdoc, bc606ndoc, bc606fch, bc606treg, bc606impa order by totapro desc nulls last) n_priori
                        from (select distinct t.bc606pais,
                                              t.bc606tdoc,
                                              t.bc606ndoc,
                                              t.bc606fch,
                                              t.bc606treg,
                                              t.bc606impa,
                                              u.bc607emp,
                                              u.bc607mod,
                                              u.bc607suc,
                                              u.bc607trn,
                                              u.bc607nrel,
                                              u.bc607fch,
                                              round(sum(decode(z.bc604mda, 0, z.bc604impmo /ln_tipcam, z.bc604impmo)), 2) totapro
                                from fbc606 t, fbc607 u,fbc604 z
                               where t.bc606pais = u.bc606pais
                                 and t.bc606tdoc = u.bc606tdoc
                                 and t.bc606ndoc = u.bc606ndoc
                                 and t.bc606fch = u.bc606fch
                                 and t.bc606treg = u.bc606treg
                                 and t.bc606fch = ld_fech
                                 and z.bc604emp  = u.bc607emp
                                 and z.bc604mod  = u.bc607mod
                                 and z.bc604suc  = u.bc607suc
                                 and z.bc604trn  = u.bc607trn
                                 and z.bc604nrel = u.bc607nrel
                                 and z.bc604fch  = u.bc607fch
                                 and t.bc606treg = 200 --drodriguee 230216 pry3833

                               group by t.bc606pais,
                                        t.bc606tdoc,
                                        t.bc606ndoc,
                                        t.bc606fch,
                                        t.bc606treg,
                                        bc606impa,
                                        u.bc607emp,
                                        u.bc607mod,
                                        u.bc607suc,
                                        u.bc607trn,
                                        u.bc607nrel,
                                        u.bc607fch))
                        where n_priori = 1)
        Where n_priori2 = 1;

ln_priori  number;
lc_lndes   varchar(100);
ln_list    number;
ld_fech    date;
ln_tipcam  number :=0;
ln_anio    number;
ln_mes     number;
ln_mod     number(3);
ln_suc     number(3);
ln_mda     number(4);
ln_pap     number(4);
ln_cta     number(9);
ln_ope     number(9);
ln_sbo     number(3);
ln_top     number(3);
lc_coderr  varchar2(300);
ln_cantpre number;
ln_sucfin  number(3);
ln_aosuc   number(3);
lc_coderr2 varchar2(300);
lc_dis     char(50);
lc_distrm  char(50);
lc_provin  char(30);
lc_prvtrm  char(30);
lc_dep     char(20);
lc_deptrm  char(20);
lc_rzso    char(50);
lc_empr    char(30);
ln_tiempo  number(4);
lc_ocu     char(30);
ln_ing     number(17,2);

begin
ld_fech := pd_fecpro;--to_date(pd_fecpro,'yyyymmdd');

execute immediate ('truncate table JAQY535');
execute immediate ('truncate table JAQY536');

ln_anio := to_number(to_char(ld_fech,'yyyy'));
ln_mes := to_number(to_char(ld_fech,'mm'));

begin 
    select tccpa
      into ln_tipcam
      from (select tccpa,
                   tchor,
                   dense_rank() over(partition by tcfch order by tchor desc nulls last) n_priori
              from fsD120
             WHERE TCCOD = 999
               AND TCFCH between to_date(to_char(ld_fech,'yyyymm')||'01','yyyymmdd') and ld_fech
               and tccpa > 0)
     where n_priori = 1;
exception  
  when too_many_rows then
       begin
                     select tccpa
                       into ln_tipcam
                       from (select tccpa,
                                    tchor,
                                    tcfch,
                                    dense_rank() over(partition by tccod,tcmda,tcimp order by tcfch,tchor desc nulls last) n_priori
                               from fsD120
                              WHERE TCCOD = 999
                                AND TCFCH between to_date(to_char(ld_fech,'yyyymm')||'01','yyyymmdd') and ld_fech
                                and tccpa > 0)
                      where n_priori = 1;
       exception
                      when others then 
                           ln_tipcam:=1;
       end;   
  when others then 
       ln_tipcam:=1;
end;

dbms_output.put_line(ln_tipcam);
for i in trans_multi (ld_fech, ln_tipcam) loop
ln_priori  := null;
lc_lndes   := null;
ln_list    := null;
ln_mod     := null; 
ln_suc     := null; 
ln_mda     := null; 
ln_pap     := null; 
ln_cta     := null; 
ln_ope     := null; 
ln_sbo     := null; 
ln_top     := null; 
ln_cantpre := null;
ln_aosuc   := null;
ln_sucfin  := null;
lc_coderr2 := null;
ln_cantpre := 1;
lc_dis     := null;
lc_provin  := null;
lc_dep     := null;
lc_rzso    := null;
lc_empr    := null;
ln_tiempo  := null;
lc_ocu     := null;
ln_ing     := null;


        begin
        --Busca los datos del producto
           select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
             into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo
             from fsh016 f, fsh015  g
            where f.pgcod  = i.bc607emp
              and f.hcmod  = i.bc607mod
              and f.hsucor = i.bc607suc
              and f.htran  = i.bc607trn
              and f.hnrel  = i.bc607nrel
              and f.hfcon  = i.bc607fch
              and f.pgcod  = g.pgcod
              and f.hcmod  = g.hcmod
              and f.hsucor = g.hsucor
              and f.htran  = g.htran
              and f.hnrel  = g.hnrel
              and f.hfcon  = g.hfcon
              and g.hccorr <> 99
              and f.hcta <> 0
              and f.hcodmo = 2
              and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
        exception
             
           when too_many_rows then
               begin
                   select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                     into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo
                 from fsh016 f, fsh015  g
                    where f.pgcod  = i.bc607emp 
                      and f.hcmod  = i.bc607mod  
                      and f.hsucor = i.bc607suc 
                      and f.htran  = i.bc607trn  
                      and f.hnrel  = i.bc607nrel  
                      and f.hfcon  = i.bc607fch  
                      and f.hcta <> 0
                      and f.hcodmo = 2
                      and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 )
                      and f.pgcod  = g.pgcod
                      and f.hcmod  = g.hcmod
                      and f.hsucor = g.hsucor
                      and f.htran  = g.htran
                      and f.hnrel  = g.hnrel
                      and f.hfcon  = g.hfcon
                      and g.hccorr <> 99;
                  exception
                    when too_many_rows then
                       begin
                       
                             select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                               into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo     
                                 
                              from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                               dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                              
                             from fsh016 f, fsh015  g
                                where f.pgcod  = i.bc607emp
                                  and f.hcmod  = i.bc607mod 
                                  and f.hsucor = i.bc607suc
                                  and f.htran  = i.bc607trn 
                                  and f.hnrel  = i.bc607nrel 
                                  and f.hfcon  = i.bc607fch
                                  and f.pgcod  = g.pgcod
                                  and f.hcmod  = g.hcmod
                                  and f.hsucor = g.hsucor
                                  and f.htran  = g.htran
                                  and f.hnrel  = g.hnrel
                                  and f.hfcon  = g.hfcon
                                  and g.hccorr <> 99 
                                  and f.hcta <> 0
                                  and f.hcodmo = 2
                                  and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                            where n_priori = 1
                            ;
                        exception
                                when too_many_rows then
                                   dbms_output.put_line ('mas de 1.1: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                
                                when no_data_found then 
                                   dbms_output.put_line ('nohaydata1: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                                       
                                      select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                                             into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo 
                                       from fsh016 f, fsh015  g
                                      where f.pgcod  = 1
                                        and f.hcmod  = 50
                                        and f.hsucor = 21
                                        and f.htran  = 540
                                        and f.hnrel  =  1
                                        and f.hfcon  = to_date('20140306','yyyymmdd')
                                        and f.hcta <> 0
                                        and f.hcodmo = 2
                                      --  and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 )
                                        and f.hcsubo = (select min(ff.hcsubo)
                                                          from fsh016 ff
                                                         where ff.pgcod  = f.pgcod 
                                                           and ff.hcmod  = f.hcmod 
                                                           and ff.hsucor = f.hsucor
                                                           and ff.htran  = f.htran 
                                                           and ff.hnrel  = f.hnrel 
                                                           and ff.hfcon  = f.hfcon 
                                                           and ff.hcord  = f.hcord)
                                        and f.pgcod  = g.pgcod
                                        and f.hcmod  = g.hcmod
                                        and f.hsucor = g.hsucor
                                        and f.htran  = g.htran
                                        and f.hnrel  = g.hnrel
                                        and f.hfcon  = g.hfcon
                                        and g.hccorr <> 99;
                         
                         exception
                                when too_many_rows then
                                   dbms_output.put_line ('mas de 9: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                
                                when no_data_found then 
                                   dbms_output.put_line ('nohaydata9: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);  
                         end;
                    
                                   
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                         into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo
                   from fsh016 f, fsh015  g
                      where f.pgcod  = i.bc607emp 
                        and f.hcmod  = i.bc607mod  
                        and f.hsucor = i.bc607suc 
                        and f.htran  = i.bc607trn  
                        and f.hnrel  = i.bc607nrel  
                        and f.hfcon  = i.bc607fch  
                        and f.pgcod  = g.pgcod
                        and f.hcmod  = g.hcmod
                        and f.hsucor = g.hsucor
                        and f.htran  = g.htran
                        and f.hnrel  = g.hnrel
                        and f.hfcon  = g.hfcon
                        and g.hccorr <> 99
                        and f.hcta <> 0
                        and f.hcodmo = 2;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct f.hmodul,htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                         into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo
                       from fsh016 f, fsh015  g 
                          where f.pgcod  = i.bc607emp 
                            and f.hcmod  = i.bc607mod  
                            and f.hsucor = i.bc607suc 
                            and f.htran  = i.bc607trn  
                            and f.hnrel  = i.bc607nrel  
                            and f.hfcon  = i.bc607fch  
                            and f.pgcod  = g.pgcod
                            and f.hcmod  = g.hcmod
                            and f.hsucor = g.hsucor
                            and f.htran  = g.htran
                            and f.hnrel  = g.hnrel
                            and f.hfcon  = g.hfcon
                            and g.hccorr <> 99
                            and f.hcta <> 0
                            and f.hcodmo = 2
                            and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                                   into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo      
                                     
                                  from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                                   dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                                  
                                 from fsh016 f, fsh015  g
                                  where f.pgcod  = i.bc607emp 
                                    and f.hcmod  = i.bc607mod  
                                    and f.hsucor = i.bc607suc 
                                    and f.htran  = i.bc607trn  
                                    and f.hnrel  = i.bc607nrel  
                                    and f.hfcon  = i.bc607fch 
                                    and f.pgcod  = g.pgcod
                                    and f.hcmod  = g.hcmod
                                    and f.hsucor = g.hsucor
                                    and f.htran  = g.htran
                                    and f.hnrel  = g.hnrel
                                    and f.hfcon  = g.hfcon
                                    and g.hccorr <> 99 
                                    and f.hcta <> 0
                                    and f.hcodmo = 2)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                 ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                 ||'-'||i.bc607nrel||'-'||i.bc607fch);                  
                                  end ;
                             --null;
                             /*dbms_output.put_line ('no data1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                            ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );  */
                     end;
                 when no_data_found then
                      begin
                        select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                          into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo 
                         from fsh016 f, fsh015  g
                            where f.pgcod  = i.bc607emp 
                              and f.hcmod  = i.bc607mod  
                              and f.hsucor = i.bc607suc 
                              and f.htran  = i.bc607trn  
                              and f.hnrel  = i.bc607nrel  
                              and f.hfcon  = i.bc607fch  
                              and f.pgcod  = g.pgcod
                              and f.hcmod  = g.hcmod
                              and f.hsucor = g.hsucor
                              and f.htran  = g.htran
                              and f.hnrel  = g.hnrel
                              and f.hfcon  = g.hfcon
                              and g.hccorr <> 99
                              and f.hcta <> 0
                              and f.hcodmo = 2
                              and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                                   into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo 
                                 from fsh016 f , fsh015  g
                                    where f.pgcod  = i.bc607emp
                                      and f.hcmod  = i.bc607mod 
                                      and f.hsucor = i.bc607suc
                                      and f.htran  = i.bc607trn 
                                      and f.hnrel  = i.bc607nrel 
                                      and f.hfcon  = i.bc607fch 
                                      and f.pgcod  = g.pgcod
                                      and f.hcmod  = g.hcmod
                                      and f.hsucor = g.hsucor
                                      and f.htran  = g.htran
                                      and f.hnrel  = g.hnrel
                                      and f.hfcon  = g.hfcon
                                      and g.hccorr <> 99
                                      and f.hcta <> 0
                                      and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                                   into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo    
                                     
                                  from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                                   dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                                  
                                 from fsh016 f, fsh015  g
                                    where f.pgcod  = i.bc607emp
                                      and f.hcmod  = i.bc607mod
                                      and f.hsucor = i.bc607suc
                                      and f.htran  = i.bc607trn
                                      and f.hnrel  = i.bc607nrel
                                      and f.hfcon  = i.bc607fch
                                      and f.pgcod  = g.pgcod
                                      and f.hcmod  = g.hcmod
                                      and f.hsucor = g.hsucor
                                      and f.htran  = g.htran
                                      and f.hnrel  = g.hnrel
                                      and f.hfcon  = g.hfcon
                                      and g.hccorr <> 99
                                      and f.hcta <> 0)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                 ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                    
                                    when no_data_found then 
                                       begin
                       
                                           select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                                             into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo    
                                               
                                            from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                                             dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                                            
                                           from fsh016 f, fsh015  g
                                              where f.pgcod  = i.bc607emp
                                                and f.hcmod  = i.bc607mod
                                                and f.hsucor = i.bc607suc
                                                and f.htran  = i.bc607trn
                                                and f.hnrel  = i.bc607nrel
                                                and f.hfcon  = i.bc607fch
                                                and f.pgcod  = g.pgcod
                                                and f.hcmod  = g.hcmod
                                                and f.hsucor = g.hsucor
                                                and f.htran  = g.htran
                                                and f.hnrel  = g.hnrel
                                                and f.hfcon  = g.hfcon
                                                and g.hccorr <> 99)
                                        where n_priori = 1
                                                ;
                                            exception
                                              when too_many_rows then
                                                 dbms_output.put_line ('mas de 44: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                           ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                              
                                              when no_data_found then 
                                                 dbms_output.put_line ('nohaydata44: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                           ||'-'||i.bc607nrel||'-'||i.bc607fch);                  
                                            end ;     --null;
                                    /*dbms_output.put_line ('no data2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                                    ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );*/
                                                     
                                  end ;     --null;
                                    /*dbms_output.put_line ('no data2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                                    ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );*/
                             end;       
                     end;       
               end;       
        end;
        
        --ES DE CREDTIOS O AHORROS
        begin
             --si el cliente tiene credito vigente considerar la sucursal donde se desembolsó
               select distinct /*fd10.aomod,*/fd10.aosuc
                 into /*ln_aomod,*/ln_aosuc
                 from fsd010 fd10, fsr008 r
                where fd10.pgcod  = 1
                  --drodriguee mod 1109
                  and r.pgcod = 1
                  and r.pepais = i.bc606pais
                  and r.petdoc = i.bc606tdoc
                  and r.pendoc = i.bc606ndoc
                  and r.cttfir = 'T'
                  and fd10.aocta  = r.ctnro
                  
                  and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo <> 108)--no considerar prendario
                  and fd10.aostat <> 99;
        exception 
                  
                  when too_many_rows then
                  --si hay mas de un credito vigente en dos agencias solo puede darse cuando tiene adicional
                  --un crédito convenio y el que debe ser evaluado es el que NO es convenio
                       begin
                       
                           select distinct fd10.aosuc
                             into ln_aosuc
                             from fsd010 fd10, fsr008 r
                            where fd10.pgcod  = 1
                            --drodriguee mod 1109                                
                            and r.pgcod = 1
                            and r.pepais = i.bc606pais
                            and r.petdoc = i.bc606tdoc
                            and r.pendoc = i.bc606ndoc
                            and r.cttfir = 'T'
                            and fd10.aocta  = r.ctnro

                              and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo not in (107,109,108) )
                              and fd10.aostat <> 99; 
                              
                       exception
                       
                              when no_data_found then
                              --en caso de ser solo convenio tomar la agencia donde se desembolso ese convenio
                                   begin
                       
                                       select distinct fd10.aosuc
                                         into ln_aosuc
                                         from fsd010 fd10, fsr008 r
                                        where fd10.pgcod  = 1
                                        --drodriguee mod 1109                                
                                        and r.pgcod = 1
                                        and r.pepais = i.bc606pais
                                        and r.petdoc = i.bc606tdoc
                                        and r.pendoc = i.bc606ndoc
                                        and r.cttfir = 'T'
                                        and fd10.aocta  = r.ctnro
                                          
                                        and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo in (107,109) )
                                        and fd10.aostat <> 99; 
                                          
                                   exception
                                   
                                          when no_data_found then
                                               dbms_output.put_line ('no hay c1: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                           ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                          when too_many_rows then
                                               dbms_output.put_line ('mas de c1: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                           ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                   end;
                              
                              when too_many_rows then
                                   dbms_output.put_line ('mas de c2: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                           ||'-'||i.bc607nrel||'-'||i.bc607fch);
                       end;       
                
                  when no_data_found then                       
                       --drodriguee mod 1109                  
                       if i.bc607mod = 30 and i.bc607trn = 150 then
                         begin
                           select distinct fd10.aosuc
                           into ln_aosuc
                           from fsd010 fd10
                           where fd10.pgcod  = 1
                           and fd10.aocta  = ln_cta
                           and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo not in (107,109,108) )
                           and rownum = 1;
                         exception when others then
                           ln_cantpre := 0;
                         end;
                       else
                         ln_cantpre := 0;   --indicador de cliente de ahorros o prestamos
                       end if;
        end;
        
        begin
               if ln_cantpre = 0 then--0 Ahorros, 1 Créditos
                  if ln_suc is null then
                     ln_sucfin := i.bc607suc;
                  else
                     ln_sucfin := ln_suc;
                  end if;
               else 
                  ln_sucfin := ln_aosuc;
               end if;
        
        end;
        
        
        --DISTRITO
         begin
            select di.fst071dsc
            into lc_distrm            
            from fst071 di
            inner join fbc602 t
            on di.fst071col = t.bc602udep||t.bc602upro||t.bc602udis
            and t.bc602pais = i.bc606pais
            and t.bc602tdoc = i.bc606tdoc
            and t.bc602ndoc = i.bc606ndoc;
         exception
         when others then
            lc_distrm := null;
         end;        
        
        begin
        
          select xx.fst071dsc
            into lc_dis
            from sngc13 aa, fst071 xx
           where aa.sngc13pais = i.bc606pais
             and aa.sngc13tdoc = i.bc606tdoc
             and aa.sngc13ndoc = i.bc606ndoc
             --and aa.sngc13pais = xx.fst071pai
             and aa.sngc13dpto = xx.fst071dpt
             and aa.sngc13prov = xx.fst071loc
             and aa.sngc13dist = xx.fst071col
             and aa.docod = 1;
             
         exception
             when no_data_found then
                  
                  begin
        
                    select xx.fst071dsc
                      into lc_dis
                      from sngc13 aa, fst071 xx, fbc602 bb
                     where aa.sngc13pais = bb.bc602pais
                       and aa.sngc13tdoc = bb.bc602tdoc
                       and aa.sngc13ndoc = bb.bc602ndoc
                       --and aa.sngc13pais = xx.fst071pai
                       and aa.sngc13dpto = xx.fst071dpt
                       and aa.sngc13prov = xx.fst071loc
                       and aa.sngc13dist = xx.fst071col
                       and aa.docod      = 1
                       and bb.bc602pais  = i.bc606pais
                       and bb.bc602tdoc  = i.bc606tdoc
                       and bb.bc602ndoc  = i.bc606ndoc
                       ;
                       
                   exception
                       when no_data_found then
                            lc_dis := null;
                       when too_many_rows then
                            begin
                            
                                 select fst071dsc
                                   into lc_dis
                                   from(select xx.fst071dsc,
                                               dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                              aa.sngc13ndoc, aa.docod 
                                                                     order by aa.sngc13corr 
                                                                     desc nulls last) n_priori
                                           from sngc13 aa, fst071 xx, fbc602 bb
                                          where aa.sngc13pais = bb.bc602pais
                                            and aa.sngc13tdoc = bb.bc602tdoc
                                            and aa.sngc13ndoc = bb.bc602ndoc
                                            --and aa.sngc13pais = xx.fst071pai
                                            and aa.sngc13dpto = xx.fst071dpt
                                            and aa.sngc13prov = xx.fst071loc
                                            and aa.sngc13dist = xx.fst071col
                                            and aa.docod      = 1
                                            and bb.bc602pais  = i.bc606pais
                                            and bb.bc602tdoc  = i.bc606tdoc
                                            and bb.bc602ndoc  = i.bc606ndoc)
                                 where n_priori = 1    ;
                                    
                            exception
                                 when no_data_found then
                                      lc_dis := null;
                                 when too_many_rows then
                                      dbms_output.put_line ('mas de dis2: '||i.bc606pais||'-'||i.bc606tdoc||'-'||i.bc606ndoc);
                            
                            end;
                       

                   end;
             
             when too_many_rows then
                  begin
                  
                         select fst071dsc
                           into lc_dis
                           from(select xx.fst071dsc,
                                       dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                      aa.sngc13ndoc, aa.docod 
                                                             order by aa.sngc13corr 
                                                             desc nulls last) n_priori
            
                                  
                                  from sngc13 aa, fst071 xx
                                 where aa.sngc13pais = i.bc606pais
                                   and aa.sngc13tdoc = i.bc606tdoc
                                   and aa.sngc13ndoc = i.bc606ndoc
                                   --and aa.sngc13pais = xx.fst071pai
                                   and aa.sngc13dpto = xx.fst071dpt
                                   and aa.sngc13prov = xx.fst071loc
                                   and aa.sngc13dist = xx.fst071col
                                   and aa.docod = 1)
                            where n_priori = 1    ;
                  
                  
                  exception 
                            when no_data_found then
                                 lc_dis := null;
                            when too_many_rows then
                                 dbms_output.put_line ('mas de dis3: '||i.bc606pais||'-'||i.bc606tdoc||'-'||i.bc606ndoc);
                  end;

         end;  
         
         
         --PROVINCIA
         begin
            select p.locnom
            into lc_prvtrm
            from fst070 p 
            inner join fbc602 t
            on p.loccod = t.bc602udep||t.bc602upro
            and t.bc602pais = i.bc606pais
            and t.bc602tdoc = i.bc606tdoc
            and t.bc602ndoc = i.bc606ndoc;
         exception
         when others then
            lc_prvtrm := null;
         end;
                  
         begin

             select xx.locnom
               into lc_provin
               from sngc13 aa, fst070 xx
              where aa.sngc13pais = i.bc606pais
                and aa.sngc13tdoc = i.bc606tdoc
                and aa.sngc13ndoc = i.bc606ndoc
                and aa.sngc13dpto = xx.depcod
                and aa.sngc13prov = xx.loccod
                and aa.docod = 1;

          exception
              when no_data_found then
                   
                   begin

                       select xx.locnom
                         into lc_provin
                         from sngc13 aa, fst070 xx, fbc602 bb
                        where aa.sngc13pais = i.bc606pais
                          and aa.sngc13tdoc = i.bc606tdoc
                          and aa.sngc13ndoc = i.bc606ndoc
                          and aa.sngc13dpto = xx.depcod
                          and aa.sngc13prov = xx.loccod
                          and aa.docod      = 1
                          and aa.sngc13pais = bb.bc602pais
                          and aa.sngc13tdoc = bb.bc602tdoc
                          and aa.sngc13ndoc = bb.bc602ndoc;

                    exception
                        when no_data_found then
                             lc_provin := null;
                        when too_many_rows then
                             
                             begin
                                  
                                  select locnom
                                    into lc_provin
                                    from (select xx.locnom,
                                                 dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                                aa.sngc13ndoc, aa.docod 
                                                                       order by aa.sngc13corr 
                                                                       desc nulls last) n_priori
                                            from sngc13 aa, fst070 xx, fbc602 bb
                                           where aa.sngc13pais = i.bc606pais
                                             and aa.sngc13tdoc = i.bc606tdoc
                                             and aa.sngc13ndoc = i.bc606ndoc
                                             and aa.sngc13dpto = xx.depcod
                                             and aa.sngc13prov = xx.loccod
                                             and aa.docod      = 1
                                             and aa.sngc13pais = bb.bc602pais
                                             and aa.sngc13tdoc = bb.bc602tdoc
                                             and aa.sngc13ndoc = bb.bc602ndoc)
                                   where n_priori = 1;
                                           
                             exception
                                   when no_data_found then
                                       lc_dis := null;
                                   when too_many_rows then
                                       dbms_output.put_line ('mas de prov2: '||i.bc606pais||'-'||i.bc606tdoc||'-'||i.bc606ndoc);
                             end;
                  end;
              
              
              when too_many_rows then
                   begin
                   
                        select locnom
                          into lc_provin
                          from (select xx.locnom,
                                       dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                      aa.sngc13ndoc, aa.docod 
                                                             order by aa.sngc13corr 
                                                             desc nulls last) n_priori
                                  from sngc13 aa, fst070 xx
                                 where aa.sngc13pais = i.bc606pais
                                   and aa.sngc13tdoc = i.bc606tdoc
                                   and aa.sngc13ndoc = i.bc606ndoc
                                   and aa.sngc13dpto = xx.depcod
                                   and aa.sngc13prov = xx.loccod
                                   and aa.docod = 1)
                         where n_priori = 1;
                   exception
                         when no_data_found then
                             lc_provin := null;
                        when too_many_rows then
                             dbms_output.put_line ('mas de prov1: '||i.bc606pais||'-'||i.bc606tdoc||'-'||i.bc606ndoc);
                   end;
         end;
         
         --DEPARTAMENTO
         begin
            select d.depnom 
            into lc_deptrm
            from fst068 d 
            inner join fbc602 t
            on d.depcod = t.bc602udep
            and t.bc602pais = i.bc606pais
            and t.bc602tdoc = i.bc606tdoc
            and t.bc602ndoc = i.bc606ndoc;
         exception
         when others then
            lc_deptrm := null;
         end;
         
         begin

             select xx.depnom
               into lc_dep
               from sngc13 aa, fst068 xx
              where aa.sngc13pais = i.bc606pais
                and aa.sngc13tdoc = i.bc606tdoc
                and aa.sngc13ndoc = i.bc606ndoc
                --and aa.sngc13pais = xx.pais
                and aa.sngc13dpto = xx.depcod
                and aa.docod      = 1;
          exception
                when no_data_found then
                     begin

                         select xx.depnom
                           into lc_dep
                           from sngc13 aa, fst068 xx, fbc602 bb
                          where aa.sngc13pais = i.bc606pais
                            and aa.sngc13tdoc = i.bc606tdoc
                            and aa.sngc13ndoc = i.bc606ndoc
                            --and aa.sngc13pais = xx.pais
                            and aa.sngc13dpto = xx.depcod
                            and aa.docod      = 1
                            and aa.sngc13pais = bb.bc602pais
                            and aa.sngc13tdoc = bb.bc602tdoc
                            and aa.sngc13ndoc = bb.bc602ndoc;
                      exception
                            when no_data_found then
                                 lc_dep := null;
                            when too_many_rows then
                                 
                                 begin
                                      
                                      select depnom
                                        into lc_dep
                                        from (select xx.depnom,
                                                     dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                                    aa.sngc13ndoc, aa.docod 
                                                                           order by aa.sngc13corr 
                                                                           desc nulls last) n_priori
                                                from sngc13 aa, fst068 xx, fbc602 bb
                                               where aa.sngc13pais = i.bc606pais
                                                 and aa.sngc13tdoc = i.bc606tdoc
                                                 and aa.sngc13ndoc = i.bc606ndoc
                                                 --and aa.sngc13pais = xx.pais
                                                 and aa.sngc13dpto = xx.depcod
                                                 and aa.docod      = 1
                                                 and aa.sngc13pais = bb.bc602pais
                                                 and aa.sngc13tdoc = bb.bc602tdoc
                                                 and aa.sngc13ndoc = bb.bc602ndoc)
                                        where n_priori = 1;
                                 exception
                                        when no_data_found then
                                             lc_dep := null;
                                        when too_many_rows then
                                             dbms_output.put_line ('mas de dep2: '||i.bc606pais||'-'||i.bc606tdoc||'-'||i.bc606ndoc);
                                 end;
                      end;
                when too_many_rows then
                     begin
                     
                          select depnom
                            into lc_dep
                            from (select xx.depnom,
                                         dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                        aa.sngc13ndoc, aa.docod 
                                                               order by aa.sngc13corr 
                                                               desc nulls last) n_priori
                                    from sngc13 aa, fst068 xx
                                   where aa.sngc13pais = i.bc606pais
                                     and aa.sngc13tdoc = i.bc606tdoc
                                     and aa.sngc13ndoc = i.bc606ndoc
                                     --and aa.sngc13pais = xx.pais
                                     and aa.sngc13dpto = xx.depcod
                                     and aa.docod      = 1)
                            where n_priori = 1;         
                     exception
                            when no_data_found then
                                 lc_dep := null;
                            when too_many_rows then
                                 dbms_output.put_line ('mas de dep1: '||i.bc606pais||'-'||i.bc606tdoc||'-'||i.bc606ndoc);
                     end;
          end;
          
          --CENTRO DE LABORES||CARGO||TIEMPO_SERVICIOS
          begin
          
          select se.pfxempr,
                 t20.vinom,
                 (case
                   when se.pfxfdes = to_date('01/01/0001','dd/mm/yyyy') then null
                   else floor(MONTHS_BETWEEN(ld_fech,se.pfxfdes)/12) 
                 end)
                   
            into lc_rzso,lc_empr,ln_tiempo
            from fse002 se,fst020 t20
           where se.pfxpais = i.bc606pais
             and se.pfxtdoc = i.bc606tdoc
             and se.pfxndoc = i.bc606ndoc
             and se.vicod   = t20.vicod(+);
             
          exception
             when too_many_rows then
                  dbms_output.put_line ('mas de raz: '||i.bc606pais||'-'||i.bc606tdoc||'-'||i.bc606ndoc);
             when others then null;
          end;
          
          
          --OCUPACION
          begin
          
          select sn07.sngc07dsc
            into lc_ocu
            from sngc60 sn60,sngc07 sn07
           where sn60.sngc60pais = i.bc606pais
             and sn60.sngc60tdoc = i.bc606tdoc
             and sn60.sngc60ndoc = i.bc606ndoc
             and sn60.sngc60ocup = sn07.sngc07cod;
             
          exception
             when too_many_rows then
                  begin
          
                      select sn07.sngc07dsc
                        into lc_ocu
                        from sngc60 sn60,sngc07 sn07
                       where sn60.sngc60pais = i.bc606pais
                         and sn60.sngc60tdoc = i.bc606tdoc
                         and sn60.sngc60ndoc = i.bc606ndoc
                         and sn60.sngc60ocup = sn07.sngc07cod
                         and sn60.sngc60corr = (select min(snn60.sngc60corr)
                                                  from sngc60 snn60
                                                 where snn60.sngc60pais = sn60.sngc60pais
                                                   and snn60.sngc60tdoc = sn60.sngc60tdoc
                                                   and snn60.sngc60ndoc = sn60.sngc60ndoc );
                         
                      exception
                         when too_many_rows then
                              dbms_output.put_line ('mas de ocu: '||i.bc606pais||'-'||i.bc606tdoc||'-'||i.bc606ndoc);
                         when others then null;
                         
                    end;
             when others then null;
          end;             
                       
          --INGRESO PROMEDIO MENSUAL
          begin
          
                    select fe1.pexing
                      into ln_ing
                      from fse101 fe1
                     where fe1.pepais = i.bc606pais
                       and fe1.petdoc = i.bc606tdoc
                       and fe1.pendoc = i.bc606ndoc;
          
          exception
                       when too_many_rows then
                           begin
                                select fe1.pexing
                                  into ln_ing
                                  from fse101 fe1
                                 where fe1.pepais = i.bc606pais
                                   and fe1.petdoc = i.bc606tdoc
                                   and fe1.pendoc = i.bc606ndoc
                                   and fe1.pexfecha = (select min(fee1.pexfecha)
                                                         from fse101 fee1
                                                        where fee1.pepais = fe1.pepais
                                                          and fee1.petdoc = fe1.petdoc
                                                          and fee1.pendoc = fe1.pendoc);
                           exception
                               when too_many_rows then 
                                    dbms_output.put_line ('mas de prom: '||i.bc606pais||'-'||i.bc606tdoc||'-'||i.bc606ndoc);
                               when others then
                                    null;
                             
                           end;   
                        when others then null;                    
          
          
          end;          
   begin
   insert into JAQY535 (JAQY535_BC606PAIS,JAQY535_BC606TDOC,JAQY535_BC606NDOC,JAQY535_BC606FCH,JAQY535_BC606TREG,
                        JAQY535_BC606IMPA,JAQY535_PENOM,JAQY535_DIRECCION,JAQY535_TELEFONO,JAQY535_NROLIST,
                        JAQY535_NROPRIORI,JAQY535_LISTDES,JAQY535_ANOPRO,JAQY535_MESPRO,JAQY535_HMODUL,
                        JAQY535_HTOPER,JAQY535_HMDA,JAQY535_HPAP,JAQY535_HOPER,JAQY535_HSUBOP,JAQY535_HCTA,
                        JAQY535_HSUCUR,JAQY535_SUCFIN,JAQY535_CREDEJE,JAQY535_DISTRITO,JAQY535_PROVINCIA,
                        JAQY535_DEPART,JAQY535_CENLAB,JAQY535_CARGO,JAQY535_TS,JAQY535_OCU,JAQY535_ING)
      values(i.BC606PAIS,i.BC606TDOC,i.BC606NDOC,i.BC606FCH,i.BC606TREG,i.BC606IMPA,nvl(i.NOMBRECLIENTE,i.NOMBRENOCLIENTE),
             nvl(i.DIRECCIONCLIENTE,i.DIRECCIONNOCLIENTE),nvl(i.TELEFONOCLIENTE,i.TELEFONONOCLIENTE),
             ln_list,ln_priori,lc_lndes,ln_anio, ln_mes,ln_mod,ln_top,ln_mda,ln_pap,ln_ope,ln_sbo,ln_cta,
             ln_suc,ln_sucfin,ln_cantpre,nvl(lc_dis,lc_distrm),nvl(lc_provin,lc_prvtrm),nvl(lc_dep,lc_deptrm),lc_rzso,lc_empr,ln_tiempo,lc_ocu,ln_ing);                     
    commit;
    exception
      when others then
        lc_coderr := substr(sqlerrm,1,200);
        dbms_output.put_line(i.BC606NDOC||'-'||lc_coderr);
    end; 
end loop;  

--se graba en esta tabla para tener solo un cliente por registro siempre teniendo en
--cuenta la agencia con mayor monto
begin

    insert into JAQY536 (JAQY536_BC606PAIS,JAQY536_BC606TDOC,JAQY536_BC606NDOC,JAQY536_BC606FCH,
                         JAQY536_PENOM,JAQY536_DIRECCION,JAQY536_TELEFONO,
                         JAQY536_ANOPRO,JAQY536_MESPRO,JAQY536_HCTA,JAQY536_SUCFIN,JAQY536_CREDEJE,
                         JAQY536_DISTRITO,JAQY536_PROVINCIA,JAQY536_DEPART,JAQY536_TIPO,JAQY536_HMODUL,
                         JAQY536_HSUCUR,JAQY536_HMDA,JAQY536_HPAP,JAQY536_HOPER,JAQY536_HTOPE,JAQY536_ASESOR,
                         JAQY536_CENLAB,JAQY536_CARGO,JAQY536_TS,JAQY536_PRIORI,JAQY536_OCU,JAQY536_ING)
    
    select jaqy535_bc606pais,
           jaqy535_bc606tdoc,
           jaqy535_bc606ndoc,
           jaqy535_bc606fch,
           jaqy535_penom,
           jaqy535_direccion,
           jaqy535_telefono,
           jaqy535_anopro,
           jaqy535_mespro,
           jaqy535_hcta,
           jaqy535_sucfin,
           jaqy535_credeje,
           jaqy535_distrito,
           jaqy535_provincia,
           jaqy535_depart,
           'TM',
           jaqy535_hmodul,
           jaqy535_hsucur,
           jaqy535_hmda,
           jaqy535_hpap,
           jaqy535_hoper,
           jaqy535_htoper,
           (CASE
               WHEN jaqy535_credeje = 0 then PQ_OCUM_VERIFICACION_TM_TUE_MC.Fn_Ejecutivo(jaqy535_bc606pais,
                                                                              jaqy535_bc606tdoc,jaqy535_bc606ndoc)
               WHEN jaqy535_credeje = 1 then PQ_OCUM_VERIFICACION_TM_TUE_MC.fn_analista(jaqy535_hcta)
            END),
            jaqy535_cenlab,
            jaqy535_cargo,
            jaqy535_ts,
            1,
            jaqy535_ocu,
            jaqy535_ing
           
      from (select jaqy535_bc606pais,
                   jaqy535_bc606tdoc,
                   jaqy535_bc606ndoc,
                   jaqy535_bc606fch,
                   jaqy535_penom,
                   jaqy535_direccion,
                   jaqy535_telefono,
                   jaqy535_anopro,
                   jaqy535_mespro,
                   jaqy535_hcta,
                   jaqy535_sucfin,
                   jaqy535_credeje,
                   jaqy535_distrito,
                   jaqy535_provincia,
                   jaqy535_depart,
                   jaqy535_hmodul,
                   jaqy535_hsucur,
                   jaqy535_hmda,
                   jaqy535_hpap,
                   jaqy535_hoper,
                   jaqy535_htoper,
                   jaqy535_cenlab,
                   jaqy535_cargo,
                   jaqy535_ts,
                   jaqy535_ocu,
                   jaqy535_ing,
                   dense_rank() over(partition by tr.jaqy535_bc606pais, tr.jaqy535_bc606tdoc, tr.jaqy535_bc606ndoc, tr.jaqy535_bc606fch order by tr.jaqy535_hcta desc nulls last) n_priori
              
              from (select ja35.jaqy535_bc606pais,
                           ja35.jaqy535_bc606tdoc,
                           ja35.jaqy535_bc606ndoc,
                           ja35.jaqy535_bc606fch,
                           ja35.jaqy535_penom,
                           ja35.jaqy535_direccion,
                           ja35.jaqy535_telefono,
                           ja35.jaqy535_anopro,
                           ja35.jaqy535_mespro,
                           ja35.jaqy535_hcta,
                           ja35.jaqy535_sucfin,
                           ja35.jaqy535_credeje,
                           ja35.jaqy535_distrito,
                           ja35.jaqy535_provincia,
                           ja35.jaqy535_depart,
                           ja35.jaqy535_hmodul,
                           ja35.jaqy535_hsucur,
                           ja35.jaqy535_hmda,
                           ja35.jaqy535_hpap,
                           ja35.jaqy535_hoper,
                           ja35.jaqy535_htoper,
                           ja35.jaqy535_cenlab,
                           ja35.jaqy535_cargo,
                           ja35.jaqy535_ts,
                           ja35.jaqy535_ocu,
                           ja35.jaqy535_ing,
                           sum(ja35.jaqy535_bc606impa)
                      from JAQY535 ja35 
                     where ja35.jaqy535_bc606impa = (select max(ja.jaqy535_bc606impa)
                                                       from JAQY535 ja
                                                      where ja.jaqy535_bc606pais = ja35.jaqy535_bc606pais
                                                        and ja.jaqy535_bc606tdoc = ja35.jaqy535_bc606tdoc
                                                        and ja.jaqy535_bc606ndoc = ja35.jaqy535_bc606ndoc)
                  group by ja35.jaqy535_bc606pais,
                           ja35.jaqy535_bc606tdoc,
                           ja35.jaqy535_bc606ndoc,
                           ja35.jaqy535_bc606fch,
                           ja35.jaqy535_penom,
                           ja35.jaqy535_direccion,
                           ja35.jaqy535_telefono,
                           ja35.jaqy535_anopro,
                           ja35.jaqy535_mespro,
                           ja35.jaqy535_hcta,
                           ja35.jaqy535_sucfin,
                           ja35.jaqy535_credeje,
                           ja35.jaqy535_distrito,
                           ja35.jaqy535_provincia,
                           ja35.jaqy535_depart,
                           ja35.jaqy535_hmodul,
                           ja35.jaqy535_hsucur,
                           ja35.jaqy535_hmda,
                           ja35.jaqy535_hpap,
                           ja35.jaqy535_hcta,
                           ja35.jaqy535_hoper,
                           ja35.jaqy535_htoper,
                           ja35.jaqy535_cenlab,
                           ja35.jaqy535_cargo,
                           ja35.jaqy535_ts,
                           ja35.jaqy535_ocu,
                           ja35.jaqy535_ing)tr)
      where n_priori = 1   ;
commit;
    exception
      when others then
        lc_coderr2 := substr(sqlerrm,1,200);
        dbms_output.put_line('Error 2: '||lc_coderr2);

end;



end SP_Multiples;


Function Fn_Ejecutivo (pn_pais in number,pn_tdoc in number,pc_ndoc in char) 
return varchar2
IS


lc_user      varchar2(10);


Begin

    
           
         begin
         
             select a.jaql61user
               into lc_user
               from jaql061 a
              where a.jaql61pgco = 1
                and a.jaql61pais = pn_pais
                and a.jaql61tdoc = pn_tdoc
                and a.jaql61ndoc = pc_ndoc
                and a.jaql61esta = 'S';
          exception 
                when others then
                      lc_user:=null;
          end; 
    
    
          
    return lc_user;

end Fn_Ejecutivo;

Function fn_analista ( pn_cta in number) return varchar2

IS


lc_flag      char(5);
ln_sbop      number(5);
ln_instancia number(20);
lc_analista  varchar(10);
ln_mod       number(5); 
ln_suc       number(5);
ln_mda       number(5);
ln_pap       number(5);
ln_cta       number(12);
ln_oper      number(12);
ln_tope      number(5);

Begin

    --Busca la clave del prestamo para poder sacar la instancia del crédito
    Begin
         select 'S',b.aomod,b.aosuc,b.aomda,b.aopap,b.aocta,b.aooper,b.aosbop,b.aotope 
           into lc_flag,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_oper,ln_sbop,ln_tope
           from fsd010 b
          where b.pgcod  = 1
            and b.aocta  = pn_cta
            and b.aomod  in (select modulo from fst111 f where f.dscod = 50)
            and b.aostat <> 99
            and rownum   = 1;
      exception
           when others then
                lc_flag := 'N';
                         
      end;
                  
      ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_oper,ln_sbop,ln_tope);
          
                    
      if lc_flag = 'S' then
                  
         begin 
           select c.sng001ase
             into lc_analista 
             from sng001 c
            where c.sng001emp = 1
              --and c.sng001cta  = pn_cta
              and c.sng001inst = ln_instancia
              /*and rownum = 1*/;
         exception     
         when others then
              lc_analista := null;
         end;
                 
      end if;
   
          
    return lc_analista;
end fn_analista;


Procedure SP_Unicas (PD_FECINI in date, PD_FECFIN in date) is

--CURSOR QUE ALMACENA LAS OPERACIONES UNICAS
cursor tues (ld_fecini in date, ld_fecfin in date) is
--create table repoue as 
select  a.bc604emp, 
        a.bc604mod, 
        a.bc604suc, 
        a.bc604trn, 
        a.bc604nrel, 
        a.bc604fch,
        a.bc604hor,
        a.bc604ord,
        b.pgcod, 
        b.hfcon,
        b.hcmod , 
        b.hsucor, 
        b.htran, 
        b.hnrel, 
        a.bc604mda,
        a.bc604impmo,
        a.BC604IMP1,
        (select l.bc605pais from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg between 300 and  399 
                and rownum = 1
        )Pais,
        (select l.bc605tdoc from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg between 300 and  399 
                and rownum = 1
        )TipoDoc,
        (select l.bc605ndoc from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg between 300 and  399 
                and rownum = 1
        )numdoc,
        (select l.bc605pais from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
        )Paistramitante,
        (select l.bc605ndoc from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
        )NroDnitramitante,
        (select l.bc605tdoc from fbc605 l/*,fst014 m*/ where /*a.bc604co ='S' --and a.bc604fch between ld_fecini and ld_fecfin 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
                --and l.bc605tdoc     = m.tdocum
        )TDocumento,
        (select n.penom from fbc605 l,fsd001 n where /*a.bc604co ='S' --and a.bc604fch between ld_fecini and ld_fecfin 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
               and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
                and l.bc605ndoc     = n.pendoc
        )Tramitante,
        (select (trim(o.bc602nom)||' '||trim(o.bc602ape)||' '||trim(o.bc602apem)) from fbc605 l,fbc602 o where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2*/
                 a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
                and l.bc605tdoc     = o.bc602tdoc
                and l.bc605ndoc     = o.bc602ndoc
        )TramitanteNoCliente
        
from fbc604 a, fsh015 b
where a.bc604co ='S' and a.bc604fch between ld_fecini and ld_fecfin
and a.bc604emp=1 
and a.BC604EMP      = b.pgcod
and a.BC604MOD      = b.hcmod
and a.BC604SUC      = b.hsucor
and a.BC604TRN      = b.htran
and a.BC604NREL     = b.hnrel
and a.BC604FCH      = b.hfcon
and a.BC604TTrn     in (2,3)--2 y 3 
and b.hccorr <> 99--quitar las extornadas

;

ln_cta     number(9);
ln_oper    number(9);
ln_toper   number(3);
lc_suc     varchar(100);
ln_mod     number(3);
ln_mda     number(4); 
ld_fecini  date;
ld_fecfin  date;
lc_titular repoue.titular%type;
ln_pais    fsd001.pepais%type;
ln_tdoc    fsd001.petdoc%type;
lc_numdoc  fsd001.pendoc%type;
lc_existe  varchar(1);
lc_listneg fst501.tlisde%type;
lc_entfin  varchar(1);
ln_suc     number(3);
ln_pap     number(4);
ln_sbop    number(3);
ln_pri     number;
lc_dir     char(140);
lc_dirtrm  char(140);
ln_tel     char(20);
ln_teltrm  char(20);
lc_coderr  varchar2(300); 
lc_dis     char(50);
lc_distrm  char(50);
lc_provin  char(30);
lc_prvtrm  char(30);
lc_dep     char(20);
lc_deptrm  char(20);
ln_cantpre number(1);
ln_sucfin  number(3);
ln_aosuc   number(3);
lc_rzso    char(50);
lc_empr    char(30);
ln_tiempo  number(4);
ln_anio    number;
ln_mes     number;
lc_ocu     char(30);
ln_ing     number(17,2);
--lc_titular repoue.titular%type;

begin
ld_fecini := PD_FECINI; --to_date(PD_FECINI,'yyyymmdd');
ld_fecfin := PD_FECFIN; --to_date(PD_FECFIN,'yyyymmdd');
ln_anio   := to_number(to_char(ld_fecfin,'yyyy'));
ln_mes    := to_number(to_char(ld_fecfin,'mm'));
execute immediate ('truncate table JAQY537');
execute immediate ('truncate table JAQY538');

for i in tues (ld_fecini, ld_fecfin) loop
ln_cta     := null;
ln_oper    := null;
ln_toper   := null;
lc_suc     := null;
ln_mod     := null;
ln_mda     := null;
lc_titular :=null;
ln_pais    :=null;
ln_tdoc    :=null;
lc_numdoc  :=null;
lc_existe  :=null;
lc_listneg := null;
lc_entfin  := null;
ln_suc     := null;
ln_pap     := null;
ln_sbop    := null;
ln_pri     := null;
lc_dir     := null;
ln_tel     := null;
lc_dis     := null;
lc_provin  := null;
lc_dep     := null;
ln_cantpre := 1;
ln_aosuc   := null;
ln_sucfin  := null;
lc_rzso    := null;
lc_empr    := null;
ln_tiempo  := null;
lc_ocu     := null;
ln_ing     := null;
--lc_titular:= null;
       --Busca los datos del producto        
       begin 
           select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
           from fsh016 c, fsr008 e,fse008 g,fst001 h 
              where c.pgcod  = i.pgcod  
                and c.hcmod  = i.hcmod   
                and c.hsucor = i.hsucor 
                and c.htran  = i.htran   
                and c.hnrel  = i.hnrel   
                and c.hfcon  = i.hfcon 
                and hcta <> 0
                and e.cttfir = 'T'     
                and e.ctnro  = c.hcta
                and c.hcodmo = 2
                and g.ctxcod = 1
                and g.ctxnro = c.hcta
                and g.ctxsuc = h.sucurs
                and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                        e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                    where c.pgcod  = i.pgcod  
                      and c.hcmod  = i.hcmod   
                      and c.hsucor = i.hsucor 
                      and c.htran  = i.htran   
                      and c.hnrel  = i.hnrel   
                      and c.hfcon  = i.hfcon   
                      and hcta <> 0
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.hcta
                      and c.hcodmo = 2
                      and g.ctxcod = 1
                      and g.ctxnro = c.hcta
                      and g.ctxsuc = h.sucurs
                      and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 );
                  exception
                    when too_many_rows then
                       begin
                       
                       select hcta, 
                              hoper, 
                              htoper, 
                              scnom , 
                              hmodul, 
                              hmda,
                              pepais ,
                              petdoc ,
                              pendoc ,
                              hsucur,
                              hpap
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap      
                           
                        from(select distinct c.hcta, 
                                         c.hoper, 
                                         c.htoper, 
                                         h.scnom , 
                                         c.hmodul, 
                                         c.hmda,
                                         e.pepais ,
                                         e.petdoc ,
                                         e.pendoc ,
                                         c.hsucur,
                                         c.hpap,
                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                        
                       from fsh016 c, fsr008 e,fse008 g,fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.cttfir = 'T'     
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            and g.ctxcod = 1
                            and g.ctxnro = c.hcta
                            and g.ctxsuc = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
                        exception
                          when too_many_rows then
                             dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                        end ;
                    
                    when no_data_found then 
                       dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                          e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                   from fsh016 c, fsr008 e,fse008 g,fst001 h 
                      where c.pgcod  = i.pgcod  
                        and c.hcmod  = i.hcmod   
                        and c.hsucor = i.hsucor 
                        and c.htran  = i.htran   
                        and c.hnrel  = i.hnrel   
                        and c.hfcon  = i.hfcon   
                        and hcta <> 0
                        and e.cttfir = 'T'  
                        and e.ctnro  = c.hcta
                        and c.hcodmo = 2
                        and g.ctxcod = 1
                        and g.ctxnro = c.hcta
                        and g.ctxsuc = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                       from fsh016 c, fsr008 e,fse008 g,fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.cttfir = 'T'  
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            and g.ctxcod = 1
                            and g.ctxnro = c.hcta
                            and g.ctxsuc = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select hcta, 
                                        hoper, 
                                        htoper, 
                                        scnom , 
                                        hmodul, 
                                        hmda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        hsucur,
                                        hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap      
                                     
                                  from(select distinct c.hcta, 
                                                   c.hoper, 
                                                   c.htoper, 
                                                   h.scnom , 
                                                   c.hmodul, 
                                                   c.hmda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.hsucur,
                                                   c.hpap,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                                  where c.pgcod  = i.pgcod  
                                    and c.hcmod  = i.hcmod   
                                    and c.hsucor = i.hsucor 
                                    and c.htran  = i.htran   
                                    and c.hnrel  = i.hnrel   
                                    and c.hfcon  = i.hfcon   
                                    and hcta <> 0
                                    and e.cttfir = 'T'  
                                    and e.ctnro  = c.hcta
                                    and c.hcodmo = 2
                                    and g.ctxcod = 1
                                    and g.ctxnro = c.hcta
                                    and g.ctxsuc = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                                  end ;
                            
                     end;
                 when no_data_found then
                      begin
                        select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                               e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                         from fsh016 c, fsr008 e,fse008 g,fst001 h 
                            where c.pgcod  = i.pgcod  
                              and c.hcmod  = i.hcmod   
                              and c.hsucor = i.hsucor 
                              and c.htran  = i.htran   
                              and c.hnrel  = i.hnrel   
                              and c.hfcon  = i.hfcon   
                              and hcta <> 0
                              and e.ctnro  = c.hcta
                              and e.cttfir = 'T'
                              and c.hcodmo = 2
                              and g.ctxcod = 1
                              and g.ctxnro = c.hcta
                              and g.ctxsuc = h.sucurs
                              and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                       e.pepais ,e.petdoc ,e.pendoc,c.hsucur,c.hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      and g.ctxcod = 1
                                      and g.ctxnro = c.hcta
                                      and g.ctxsuc = h.sucurs
                                      and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select hcta, 
                                        hoper, 
                                        htoper, 
                                        scnom , 
                                        hmodul, 
                                        hmda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        hsucur,
                                        hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap      
                                     
                                  from(select distinct c.hcta, 
                                                   c.hoper, 
                                                   c.htoper, 
                                                   h.scnom , 
                                                   c.hmodul, 
                                                   c.hmda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.hsucur,
                                                   c.hpap,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      and g.ctxcod = 1
                                      and g.ctxnro = c.hcta
                                      and g.ctxsuc = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                    
                                    when no_data_found then 
                                       null;
                                       --dbms_output.put_line ('nohaydata33: '||i.BC604MOD||'-'||i.bc604suc||'-'||i.bc604trn||'-'||i.bc604nrel||'-'||i.bc604fch);                  
                                  end ;     
                             end;       
                     end;       
               end;       
         end; 
         
         
         begin
         
         --si el numero de documento es nulo es porque no encontró cuenta por tanto toma la información
         --del tramitante
            if lc_numdoc is null then
            
               ln_pais   := i.Paistramitante;
               ln_tdoc   := i.TDocumento;
               lc_numdoc := i.NroDnitramitante;
               
            end if;
               
         end;
         
         begin
              select j.penom 
                into lc_titular
                from fsd001 j 
               where j.pepais = ln_pais 
                 and j.petdoc = ln_tdoc
                 and j.pendoc = lc_numdoc;
         exception
            when others then 
                 if i.TRAMITANTE is not null then
                    lc_titular:= i.TRAMITANTE;     
                 elsif i.TRAMITANTENOCLIENTE is not null then   
                    lc_titular:= i.TRAMITANTENOCLIENTE; 
                 else
                    lc_titular:= null;   
                 end if;   
         end;
         
         
         --DIRECCION
         begin
            select trim(substr(replace(bc602dire,';',' '),1,140))
            into lc_dirtrm
            from fbc602
            where bc602pais = i.paistramitante
            and bc602tdoc = i.tdocumento
            and bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            lc_dirtrm := null;
         end;
         
         begin
         
                 select f.sngc13dir 
                   into lc_dir
                   from sngc13 f 
                  where f.sngc13pais = ln_pais   
                    and f.sngc13tdoc = ln_tdoc
                    and f.sngc13ndoc = lc_numdoc
                    and f.docod      = 1
                    and f.sngc13est  = 'H';
         
         EXCEPTION
                  when too_many_rows then
                       dbms_output.put_line ('mas de 1dir: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                  when no_data_found then
                       null;
                       --dbms_output.put_line ('no hay 1dir: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                  
                  when others then null;
                    
         end;
         
         --TELEFONO
         begin
            select bc602telr
            into ln_teltrm
            from fbc602
            where bc602pais = i.paistramitante
            and bc602tdoc = i.tdocumento
            and bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            ln_teltrm := null;
         end;
         
         begin
         
                 select b.dotelfp 
                   into ln_tel
                   from fsr005 b 
                  where b.pepais = ln_pais   
                    and b.petdoc = ln_tdoc 
                    and b.pendoc = lc_numdoc
                    and b.docod  = 1
                    and b.doordp = 1;
                    
         
         EXCEPTION
         
                  when too_many_rows then
                       dbms_output.put_line ('mas de 1tel: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);  
                  when no_data_found then
                  
                       begin
                       
                            select b.dotelfp 
                              into ln_tel
                              from fsr005 b 
                             where b.pepais = ln_pais   
                               and b.petdoc = ln_tdoc 
                               and b.pendoc = lc_numdoc
                               /*and b.docod  = 1
                               and b.doordp = 1*/;
                       exception
                               when too_many_rows then
                                    begin
                       
                                          select b.dotelfp 
                                            into ln_tel
                                            from fsr005 b 
                                           where b.pepais = ln_pais   
                                             and b.petdoc = ln_tdoc 
                                             and b.pendoc = lc_numdoc
                                             and b.docod  = (select min(docod)
                                                               from fsr005 bb 
                                                              where bb.pepais = b.pepais 
                                                                and bb.petdoc = b.petdoc
                                                                and bb.pendoc = b.pendoc)
                                             and b.doordp = (select min(doordp)
                                                               from fsr005 bb 
                                                              where bb.pepais = b.pepais 
                                                                and bb.petdoc = b.petdoc
                                                                and bb.pendoc = b.pendoc);
                                     exception
                                             when too_many_rows then
                                                  dbms_output.put_line ('mas de 2tel: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);  
                                             when no_data_found then
                                                  null;
                                                  --dbms_output.put_line ('no hay 2tel: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                                     end;  
                               when no_data_found then
                                    null;
                                    --dbms_output.put_line ('no hay 1tel: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                       end;
                       
                  when others then null;
         end;
         
         
         
         --DISTRITO
         begin
            select di.fst071dsc
            into lc_distrm            
            from fst071 di
            inner join fbc602 t
            on di.fst071col = t.bc602udep||t.bc602upro||t.bc602udis
            and t.bc602pais = i.paistramitante
            and t.bc602tdoc = i.tdocumento
            and t.bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            lc_distrm := null;
         end;        
         
        begin
        
          select xx.fst071dsc
            into lc_dis
            from sngc13 aa, fst071 xx
           where aa.sngc13pais = ln_pais  
             and aa.sngc13tdoc = ln_tdoc 
             and aa.sngc13ndoc = lc_numdoc
             --and aa.sngc13pais = xx.fst071pai
             and aa.sngc13dpto = xx.fst071dpt
             and aa.sngc13prov = xx.fst071loc
             and aa.sngc13dist = xx.fst071col
             and aa.docod = 1;
             
         exception
             when no_data_found then
                  
                  begin
        
                    select xx.fst071dsc
                      into lc_dis
                      from sngc13 aa, fst071 xx, fbc602 bb
                     where aa.sngc13pais = bb.bc602pais
                       and aa.sngc13tdoc = bb.bc602tdoc
                       and aa.sngc13ndoc = bb.bc602ndoc
                       --and aa.sngc13pais = xx.fst071pai
                       and aa.sngc13dpto = xx.fst071dpt
                       and aa.sngc13prov = xx.fst071loc
                       and aa.sngc13dist = xx.fst071col
                       and aa.docod      = 1
                       and bb.bc602pais  = ln_pais  
                       and bb.bc602tdoc  = ln_tdoc 
                       and bb.bc602ndoc  = lc_numdoc
                       ;
                       
                   exception
                       when no_data_found then
                            lc_dis := null;
                       when too_many_rows then
                            begin
                            
                                 select fst071dsc
                                   into lc_dis
                                   from(select xx.fst071dsc,
                                               dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                              aa.sngc13ndoc, aa.docod 
                                                                     order by aa.sngc13corr 
                                                                     desc nulls last) n_priori
                                           from sngc13 aa, fst071 xx, fbc602 bb
                                          where aa.sngc13pais = bb.bc602pais
                                            and aa.sngc13tdoc = bb.bc602tdoc
                                            and aa.sngc13ndoc = bb.bc602ndoc
                                            --and aa.sngc13pais = xx.fst071pai
                                            and aa.sngc13dpto = xx.fst071dpt
                                            and aa.sngc13prov = xx.fst071loc
                                            and aa.sngc13dist = xx.fst071col
                                            and aa.docod      = 1
                                            and bb.bc602pais  = ln_pais  
                                            and bb.bc602tdoc  = ln_tdoc 
                                            and bb.bc602ndoc  = lc_numdoc)
                                 where n_priori = 1    ;
                                    
                            exception
                                 when no_data_found then
                                      lc_dis := null;
                                 when too_many_rows then
                                      dbms_output.put_line ('mas de dis2: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                            
                            end;
                       

                   end;
             
             when too_many_rows then
                  begin
                  
                         select fst071dsc
                           into lc_dis
                           from(select xx.fst071dsc,
                                       dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                      aa.sngc13ndoc, aa.docod 
                                                             order by aa.sngc13corr 
                                                             desc nulls last) n_priori
            
                                  
                                  from sngc13 aa, fst071 xx
                                 where aa.sngc13pais = ln_pais  
                                   and aa.sngc13tdoc = ln_tdoc 
                                   and aa.sngc13ndoc = lc_numdoc
                                   --and aa.sngc13pais = xx.fst071pai
                                   and aa.sngc13dpto = xx.fst071dpt
                                   and aa.sngc13prov = xx.fst071loc
                                   and aa.sngc13dist = xx.fst071col
                                   and aa.docod = 1)
                            where n_priori = 1    ;
                  
                  
                  exception 
                            when no_data_found then
                                 lc_dis := null;
                            when too_many_rows then
                                 dbms_output.put_line ('mas de dis3: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                  end;

         end;  
         
         
         --PROVINCIA
         begin
            select p.locnom
            into lc_prvtrm
            from fst070 p 
            inner join fbc602 t
            on p.loccod = t.bc602udep||t.bc602upro
            and t.bc602pais = i.paistramitante
            and t.bc602tdoc = i.tdocumento
            and t.bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            lc_prvtrm := null;
         end;         
         
         begin

             select xx.locnom
               into lc_provin
               from sngc13 aa, fst070 xx
              where aa.sngc13pais = ln_pais  
                and aa.sngc13tdoc = ln_tdoc 
                and aa.sngc13ndoc = lc_numdoc
                and aa.sngc13dpto = xx.depcod
                and aa.sngc13prov = xx.loccod
                and aa.docod = 1;

          exception
              when no_data_found then
                   
                   begin

                       select xx.locnom
                         into lc_provin
                         from sngc13 aa, fst070 xx, fbc602 bb
                        where aa.sngc13pais = ln_pais  
                          and aa.sngc13tdoc = ln_tdoc 
                          and aa.sngc13ndoc = lc_numdoc
                          and aa.sngc13dpto = xx.depcod
                          and aa.sngc13prov = xx.loccod
                          and aa.docod      = 1
                          and aa.sngc13pais = bb.bc602pais
                          and aa.sngc13tdoc = bb.bc602tdoc
                          and aa.sngc13ndoc = bb.bc602ndoc;

                    exception
                        when no_data_found then
                             lc_provin := null;
                        when too_many_rows then
                             
                             begin
                                  
                                  select locnom
                                    into lc_provin
                                    from (select xx.locnom,
                                                 dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                                aa.sngc13ndoc, aa.docod 
                                                                       order by aa.sngc13corr 
                                                                       desc nulls last) n_priori
                                            from sngc13 aa, fst070 xx, fbc602 bb
                                           where aa.sngc13pais = ln_pais  
                                             and aa.sngc13tdoc = ln_tdoc 
                                             and aa.sngc13ndoc = lc_numdoc
                                             and aa.sngc13dpto = xx.depcod
                                             and aa.sngc13prov = xx.loccod
                                             and aa.docod      = 1
                                             and aa.sngc13pais = bb.bc602pais
                                             and aa.sngc13tdoc = bb.bc602tdoc
                                             and aa.sngc13ndoc = bb.bc602ndoc)
                                   where n_priori = 1;
                                           
                             exception
                                   when no_data_found then
                                       lc_dis := null;
                                   when too_many_rows then
                                       dbms_output.put_line ('mas de prov2: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                             end;
                  end;
              
              
              when too_many_rows then
                   begin
                   
                        select locnom
                          into lc_provin
                          from (select xx.locnom,
                                       dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                      aa.sngc13ndoc, aa.docod 
                                                             order by aa.sngc13corr 
                                                             desc nulls last) n_priori
                                  from sngc13 aa, fst070 xx
                                 where aa.sngc13pais = ln_pais  
                                   and aa.sngc13tdoc = ln_tdoc 
                                   and aa.sngc13ndoc = lc_numdoc
                                   and aa.sngc13dpto = xx.depcod
                                   and aa.sngc13prov = xx.loccod
                                   and aa.docod = 1)
                         where n_priori = 1;
                   exception
                         when no_data_found then
                             lc_provin := null;
                        when too_many_rows then
                             dbms_output.put_line ('mas de prov1: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                   end;
         end;
         
         --DEPARTAMENTO         
         begin
            select d.depnom 
            into lc_deptrm
            from fst068 d 
            inner join fbc602 t
            on d.depcod = t.bc602udep
            and t.bc602pais = i.paistramitante
            and t.bc602tdoc = i.tdocumento
            and t.bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            lc_deptrm := null;
         end;
         
         begin

             select xx.depnom
               into lc_dep
               from sngc13 aa, fst068 xx
              where aa.sngc13pais = ln_pais  
                and aa.sngc13tdoc = ln_tdoc 
                and aa.sngc13ndoc = lc_numdoc
                --and aa.sngc13pais = xx.pais
                and aa.sngc13dpto = xx.depcod
                and aa.docod      = 1;
          exception
                when no_data_found then
                     begin

                         select xx.depnom
                           into lc_dep
                           from sngc13 aa, fst068 xx, fbc602 bb
                          where aa.sngc13pais = ln_pais  
                            and aa.sngc13tdoc = ln_tdoc 
                            and aa.sngc13ndoc = lc_numdoc
                            --and aa.sngc13pais = xx.pais
                            and aa.sngc13dpto = xx.depcod
                            and aa.docod      = 1
                            and aa.sngc13pais = bb.bc602pais
                            and aa.sngc13tdoc = bb.bc602tdoc
                            and aa.sngc13ndoc = bb.bc602ndoc;
                      exception
                            when no_data_found then
                                 lc_dep := null;
                            when too_many_rows then
                                 
                                 begin
                                      
                                      select depnom
                                        into lc_dep
                                        from (select xx.depnom,
                                                     dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                                    aa.sngc13ndoc, aa.docod 
                                                                           order by aa.sngc13corr 
                                                                           desc nulls last) n_priori
                                                from sngc13 aa, fst068 xx, fbc602 bb
                                               where aa.sngc13pais = ln_pais  
                                                 and aa.sngc13tdoc = ln_tdoc 
                                                 and aa.sngc13ndoc = lc_numdoc
                                                 --and aa.sngc13pais = xx.pais
                                                 and aa.sngc13dpto = xx.depcod
                                                 and aa.docod      = 1
                                                 and aa.sngc13pais = bb.bc602pais
                                                 and aa.sngc13tdoc = bb.bc602tdoc
                                                 and aa.sngc13ndoc = bb.bc602ndoc)
                                        where n_priori = 1;
                                 exception
                                        when no_data_found then
                                             lc_dep := null;
                                        when too_many_rows then
                                             dbms_output.put_line ('mas de dep2: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                                 end;
                      end;
                when too_many_rows then
                     begin
                     
                          select depnom
                            into lc_dep
                            from (select xx.depnom,
                                         dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                        aa.sngc13ndoc, aa.docod 
                                                               order by aa.sngc13corr 
                                                               desc nulls last) n_priori
                                    from sngc13 aa, fst068 xx
                                   where aa.sngc13pais = ln_pais  
                                     and aa.sngc13tdoc = ln_tdoc 
                                     and aa.sngc13ndoc = lc_numdoc
                                     --and aa.sngc13pais = xx.pais
                                     and aa.sngc13dpto = xx.depcod
                                     and aa.docod      = 1)
                            where n_priori = 1;         
                     exception
                            when no_data_found then
                                 lc_dep := null;
                            when too_many_rows then
                                 begin
                     
                                      select depnom
                                        into lc_dep
                                        from (select xx.depnom,
                                                     dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                                    aa.sngc13ndoc, aa.docod 
                                                                           order by aa.sngc13corr 
                                                                           desc nulls last) n_priori
                                                from sngc13 aa, fst068 xx
                                               where aa.sngc13pais = ln_pais  
                                                 and aa.sngc13tdoc = ln_tdoc 
                                                 and aa.sngc13ndoc = lc_numdoc
                                                 --and aa.sngc13pais = xx.pais
                                                 and aa.sngc13dpto = xx.depcod
                                                 and aa.docod      = 1
                                                 and xx.pais       = ln_pais)
                                        where n_priori = 1;         
                                 exception
                                        when no_data_found then
                                             lc_dep := null;
                                        when too_many_rows then
                                             dbms_output.put_line ('mas de dep1: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                                 end;
                     end;
          end;
          
          
         
         -- Existe
          begin
            select distinct 'S'   
              into lc_existe
             from fsh016 c 
                where c.pgcod  = i.pgcod  
                  and c.hcmod  = i.hcmod   
                  and c.hsucor = i.hsucor 
                  and c.htran  = i.htran   
                  and c.hnrel  = i.hnrel   
                  and c.hfcon  = i.hfcon
                  and c.hcord  = i.bc604ord ;
         exception 
           when no_data_found then
                lc_existe:='N';
                
         end;
        
         
         -- Es Entidad Financiera
          begin
            select 'S'
              into lc_entfin 
              from fsd004 o 
             where o.ifpais = i.pais 
               and o.iftdoc = i.tipodoc
               and o.ifndoc = i.numdoc;
           
         exception 
           when no_data_found then
              lc_entfin := 'N';
           when others then 
              lc_entfin := 'N'; 
              dbms_output.put_line ('EF : '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);  
         end;       
         
         
         --ES DE CREDTIOS O AHORROS
        begin
               --si el cliente tiene credito vigente considerar la sucursal donde se desembolsó
               select distinct /*fd10.aomod,*/fd10.aosuc
                 into /*ln_aomod,*/ln_aosuc
                 from fsd010 fd10, fsr008 r
                where fd10.pgcod  = 1
                  
                --drodriguee mod 1109                                
                and r.pgcod = 1
                and r.pepais = i.pais
                and r.petdoc = i.tipodoc
                and r.pendoc = i.numdoc
                and r.cttfir = 'T'
                and fd10.aocta  = r.ctnro
                  
                and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo <> 108)
                and fd10.aostat <> 99;
        exception 
                  
                  when too_many_rows then
                  
                       begin
                  --si hay mas de un credito vigente en dos agencias solo puede darse cuando tiene adicional
                  --un crédito convenio y el que debe ser evaluado es el que NO es convenio          
                           select distinct fd10.aosuc
                             into ln_aosuc
                             from fsd010 fd10, fsr008 r
                            where fd10.pgcod  = 1
                  
                            --drodriguee mod 1109                                
                            and r.pgcod = 1
                            and r.pepais = i.pais
                            and r.petdoc = i.tipodoc
                            and r.pendoc = i.numdoc
                            and r.cttfir = 'T'
                            and fd10.aocta  = r.ctnro

                            and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo not in (107,109,108) )
                            and fd10.aostat <> 99; 
                              
                       exception
                       
                              when no_data_found then
                              
                                   begin
                                       --en caso de ser solo convenio tomar la agencia donde se desembolso ese convenio          
                                       select distinct fd10.aosuc
                                         into ln_aosuc
                                         from fsd010 fd10, fsr008 r
                                        where fd10.pgcod  = 1
                  
                                        --drodriguee mod 1109                                
                                        and r.pgcod = 1
                                        and r.pepais = i.pais
                                        and r.petdoc = i.tipodoc
                                        and r.pendoc = i.numdoc
                                        and r.cttfir = 'T'
                                        and fd10.aocta  = r.ctnro

                                        and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo in (107,109) )
                                        and fd10.aostat <> 99; 
                                          
                                   exception
                                   
                                          when no_data_found then
                                               dbms_output.put_line ('no hay c1: '||i.bc604emp||'-'||i.bc604mod||'-'||i.bc604suc||'-'||i.bc604trn
                                                                           ||'-'||i.bc604nrel||'-'||i.bc604fch);
                                          when too_many_rows then
                                               dbms_output.put_line ('mas de c1: '||i.bc604emp||'-'||i.bc604mod||'-'||i.bc604suc||'-'||i.bc604trn
                                                                           ||'-'||i.bc604nrel||'-'||i.bc604fch);
                                   end;
                              
                              when too_many_rows then
                                   dbms_output.put_line ('mas de c2: '||i.bc604emp||'-'||i.bc604mod||'-'||i.bc604suc||'-'||i.bc604trn
                                                                           ||'-'||i.bc604nrel||'-'||i.bc604fch);
                       end;       
                
                  When no_data_found then --indicador de cliente de ahorros o préstamos
                       --drodriguee mod 1109                  
                       if i.bc604mod = 30 and i.bc604trn = 150 then
                         begin
                           select distinct fd10.aosuc
                           into ln_aosuc
                           from fsd010 fd10
                           where fd10.pgcod  = 1
                           and fd10.aocta  = ln_cta
                           and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo not in (107,109,108) )
                           and rownum = 1;
                         exception when others then
                           ln_cantpre := 0;
                         end;
                       else
                         ln_cantpre := 0;   --indicador de cliente de ahorros o préstamos
                       end if;
        end;
        
        begin
          if ln_cantpre = 0 then  --0 Ahorros, 1 Créditos
            if ln_suc is null then
               ln_sucfin := i.bc604suc;
            else
               ln_sucfin := ln_suc;
            end if;            
          else 
            ln_sucfin := ln_aosuc;
          end if;
        end;
        
        --CENTRO DE LABORES||CARGO||TIEMPO_SERVICIOS
          begin
          
          select se.pfxempr,
                 t20.vinom,
                 (case
                   when se.pfxfdes = to_date('01/01/0001','dd/mm/yyyy') then null
                   else floor(MONTHS_BETWEEN(ld_fecfin,se.pfxfdes)/12) 
                 end)
                   
            into lc_rzso,lc_empr,ln_tiempo
            from fse002 se,fst020 t20
           where se.pfxpais = ln_pais  
             and se.pfxtdoc = ln_tdoc 
             and se.pfxndoc = lc_numdoc
             and se.vicod   = t20.vicod(+);
             
          exception
             when too_many_rows then
                  dbms_output.put_line ('mas de raz: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                 
             when others then null;
          end;
          
          
          --OCUPACION
          begin
          
          select sn07.sngc07dsc
            into lc_ocu
            from sngc60 sn60,sngc07 sn07
           where sn60.sngc60pais = ln_pais  
             and sn60.sngc60tdoc = ln_tdoc 
             and sn60.sngc60ndoc = lc_numdoc
             and sn60.sngc60ocup = sn07.sngc07cod;
             
          exception
             when too_many_rows then
                  begin
          
                      select sn07.sngc07dsc
                        into lc_ocu
                        from sngc60 sn60,sngc07 sn07
                       where sn60.sngc60pais = ln_pais  
                         and sn60.sngc60tdoc = ln_tdoc 
                         and sn60.sngc60ndoc = lc_numdoc
                         and sn60.sngc60ocup = sn07.sngc07cod
                         and sn60.sngc60corr = (select min(snn60.sngc60corr)
                                                  from sngc60 snn60
                                                 where snn60.sngc60pais = sn60.sngc60pais
                                                   and snn60.sngc60tdoc = sn60.sngc60tdoc
                                                   and snn60.sngc60ndoc = sn60.sngc60ndoc );
                         
                      exception
                         when too_many_rows then
                              dbms_output.put_line ('mas de ocu: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                         when others then null;
                         
                    end;
             when others then null;
          end;        
          
           --INGRESO PROMEDIO MENSUAL
          begin
          
                    select fe1.pexing
                      into ln_ing
                      from fse101 fe1
                     where fe1.pepais = ln_pais  
                       and fe1.petdoc = ln_tdoc 
                       and fe1.pendoc = lc_numdoc;
          
          exception
                       when too_many_rows then
                           begin
                                select fe1.pexing
                                  into ln_ing
                                  from fse101 fe1
                                 where fe1.pepais = ln_pais  
                                   and fe1.petdoc = ln_tdoc 
                                   and fe1.pendoc = lc_numdoc
                                   and fe1.pexfecha = (select min(fee1.pexfecha)
                                                         from fse101 fee1
                                                        where fee1.pepais = fe1.pepais
                                                          and fee1.petdoc = fe1.petdoc
                                                          and fee1.pendoc = fe1.pendoc);
                           exception
                               when too_many_rows then 
                                    dbms_output.put_line ('mas de prom: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                               when others then
                                    null;
                             
                           end;   
                        when others then null;                    
          
          
          end;  
              
  begin
  insert into JAQY537 (JAQY537_BC604EMP,JAQY537_BC604MOD,JAQY537_BC604SUC,JAQY537_BC604TRN,
                        JAQY537_BC604NREL,JAQY537_BC604FCH,JAQY537_BC604MDA,JAQY537_BC604IMPMO,
                        JAQY537_BC604IMP1,JAQY537_HMODUL,JAQY537_HCTA,JAQY537_HSUCUR,
                        JAQY537_HOPER,JAQY537_PEPAIS,JAQY537_PETDOC,JAQY537_PENDOC,JAQY537_TITULAR,
                        JAQY537_PAISTRAM,JAQY537_TDOCTRAM,JAQY537_NDOCTRAM,JAQY537_HORA,
                        JAQY537_EXTORD,JAQY537_ENTFIN,JAQY537_DIR,JAQY537_TEL,JAQY537_DIST,JAQY537_PROV,
                        JAQY537_DEP,JAQY537_SUCFIN,JAQY537_CREDEJE,JAQY537_CENLAB,JAQY537_CARGO,JAQY537_TS,
                        JAQY537_OCU,JAQY537_ING)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.BC604MDA,
             i.BC604IMPMO,i.BC604IMP1,ln_mod,ln_cta,ln_suc,ln_oper,ln_pais, ln_tdoc, lc_numdoc,
             lc_titular,i.Paistramitante,i.TDOCUMENTO,i.NRODNITRAMITANTE,i.bc604hor,lc_existe,lc_entfin,
             nvl(lc_dir,lc_dirtrm),nvl(ln_tel,ln_teltrm),nvl(lc_dis,lc_distrm),nvl(lc_provin,lc_prvtrm),nvl(lc_dep,lc_deptrm),ln_sucfin,ln_cantpre,lc_rzso,lc_empr,ln_tiempo,
             lc_ocu,ln_ing);
                   
    commit;
    exception
     when others then
           lc_coderr:=sqlerrm;
           dbms_output.put_line ('INSERT : '||lc_coderr);
     end;
end loop;  


begin

--se graba en esta tabla para tener solo un cliente por registro siempre teniendo en
--cuenta la agencia con mayor monto
insert into JAQY538(JAQY538_PEPAIS,JAQY538_PETDOC,JAQY538_PENDOC,JAQY538_CTA,JAQY538_FCH,JAQY538_PENOM,
                    JAQY538_DIR,JAQY538_TEL,JAQY538_DIST,JAQY538_PROV,JAQY538_DEP,JAQY538_SUCFIN,
                    JAQY538_CREDEJE,JAQY538_TIPO,JAQY538_ASESOR,JAQY538_CENLAB,JAQY538_CARGO,JAQY538_TS,
                    JAQY538_ANOPRO,JAQY538_MESPRO,JAQY538_PRIORI,JAQY538_OCU,JAQY538_ING)

select jaqy537_pepais,
               jaqy537_petdoc,
               jaqy537_pendoc,
               jaqy537_hcta,
               jaqy537_bc604fch,
               jaqy537_titular,
               jaqy537_dir,
               jaqy537_tel,
               jaqy537_dist,
               jaqy537_prov,
               jaqy537_dep,
               jaqy537_sucfin,
               jaqy537_credeje,
               'TUE' tipo,
               (CASE
               WHEN jaqy537_credeje = 0 then PQ_OCUM_VERIFICACION_TM_TUE_MC.Fn_Ejecutivo(jaqy537_pepais,
                                                                              jaqy537_petdoc,jaqy537_pendoc)
               WHEN jaqy537_credeje = 1 then PQ_OCUM_VERIFICACION_TM_TUE_MC.fn_analista(jaqy537_hcta)
               END) asesor,
               jaqy537_cenlab,
               jaqy537_cargo,
               jaqy537_ts,
               ln_anio,
               ln_mes,
               2,
               jaqy537_ocu ,
               jaqy537_ing              
          from (select jaqy537_hcta,
                       jaqy537_bc604fch,
                       jaqy537_pepais,
                       jaqy537_petdoc,
                       jaqy537_pendoc,
                       jaqy537_titular,
                       jaqy537_dir,
                       jaqy537_tel,
                       jaqy537_dist,
                       jaqy537_prov,
                       jaqy537_dep,
                       jaqy537_sucfin,
                       jaqy537_credeje,
                       jaqy537_cenlab,
                       jaqy537_cargo,
                       jaqy537_ts,
                       jaqy537_ocu,
                       jaqy537_ing,
                       dense_rank() over(partition by jaqy537_pepais,jaqy537_petdoc,jaqy537_pendoc order by jaqy537_hcta desc nulls last) n_priori3
                  from (select jaqy537_hcta,
                               jaqy537_bc604fch,
                               jaqy537_pepais,
                               jaqy537_petdoc,
                               jaqy537_pendoc,
                               jaqy537_titular,
                               jaqy537_dir,
                               jaqy537_tel,
                               jaqy537_dist,
                               jaqy537_prov,
                               jaqy537_dep,
                               jaqy537_sucfin,
                               jaqy537_credeje,
                               jaqy537_cenlab,
                               jaqy537_cargo,
                               jaqy537_ts,
                               jaqy537_ocu,
                               jaqy537_ing,
                               dense_rank() over(partition by jaqy537_pepais,jaqy537_petdoc,jaqy537_pendoc order by jaqy537_sucfin desc nulls last) n_priori2
                          from (select jaqy537_hcta,
                                       jaqy537_bc604fch,
                                       jaqy537_pepais,
                                       jaqy537_petdoc,
                                       jaqy537_pendoc,
                                       jaqy537_titular,
                                       jaqy537_dir,
                                       jaqy537_tel,
                                       jaqy537_dist,
                                       jaqy537_prov,
                                       jaqy537_dep,
                                       jaqy537_sucfin,
                                       jaqy537_credeje,
                                       jaqy537_cenlab,
                                       jaqy537_cargo,
                                       jaqy537_ts,
                                       jaqy537_ocu,
                                       jaqy537_ing,
                                       dense_rank() over(partition by jaqy537_hcta, jaqy537_pepais,jaqy537_petdoc,jaqy537_pendoc order by jaqy537_bc604fch asc nulls last) n_priori
                                  from (select ja37.jaqy537_hcta,
                                               ja37.jaqy537_bc604fch,
                                               ja37.jaqy537_pepais,
                                               ja37.jaqy537_petdoc,
                                               ja37.jaqy537_pendoc,
                                               ja37.jaqy537_titular,
                                               ja37.jaqy537_dir,
                                               ja37.jaqy537_tel,
                                               ja37.jaqy537_dist,
                                               ja37.jaqy537_prov,
                                               ja37.jaqy537_dep,
                                               ja37.jaqy537_sucfin,
                                               ja37.jaqy537_credeje,
                                               ja37.jaqy537_cenlab,
                                               ja37.jaqy537_cargo,
                                               ja37.jaqy537_ts,
                                               ja37.jaqy537_ocu,
                                               ja37.jaqy537_ing,
                                               sum(ja37.jaqy537_bc604imp1)mto
                                          from JAQY537 ja37
                                         where ja37.jaqy537_bc604imp1 = (select max(jaa37.jaqy537_bc604imp1)
                                                                           from jaqy537 jaa37
                                                                          where jaa37.jaqy537_pepais = ja37.jaqy537_pepais
                                                                            and jaa37.jaqy537_petdoc = ja37.jaqy537_petdoc
                                                                            and jaa37.jaqy537_pendoc = ja37.jaqy537_pendoc)
                                             
                                            
                                        group by ja37.jaqy537_hcta,
                                               ja37.jaqy537_bc604fch,
                                               ja37.jaqy537_pepais,
                                               ja37.jaqy537_petdoc,
                                               ja37.jaqy537_pendoc,
                                               ja37.jaqy537_titular,
                                               ja37.jaqy537_dir,
                                               ja37.jaqy537_tel,
                                               ja37.jaqy537_dist,
                                               ja37.jaqy537_prov,
                                               ja37.jaqy537_dep,
                                               ja37.jaqy537_sucfin,
                                               ja37.jaqy537_credeje,
                                               ja37.jaqy537_cenlab,
                                               ja37.jaqy537_cargo,
                                               ja37.jaqy537_ts,
                                               ja37.jaqy537_ocu,
                                               ja37.jaqy537_ing))
                         where n_priori = 1)
                 where n_priori2 = 1)
         where n_priori3 = 1;
           
 COMMIT;

end;


end SP_Unicas;

Procedure SP_MenorCuantia (PD_FECINI in date, PD_FECFIN in date) is

--CURSOR QUE ALMACENA LAS OPERACIONES DE MENOR CUANTIA
cursor tues (ld_fecini in date, ld_fecfin in date) is
--create table repoue as 
select  a.bc604emp, 
        a.bc604mod, 
        a.bc604suc, 
        a.bc604trn, 
        a.bc604nrel, 
        a.bc604fch,
        a.bc604hor,
        a.bc604ord,
        b.pgcod, 
        b.hfcon,
        b.hcmod , 
        b.hsucor, 
        b.htran, 
        b.hnrel, 
        a.bc604mda,
        a.bc604impmo,
        a.BC604IMP1,
        (select l.bc605pais from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg between 300 and  399 
                and rownum = 1
        )Pais,
        (select l.bc605tdoc from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg between 300 and  399 
                and rownum = 1
        )TipoDoc,
        (select l.bc605ndoc from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg between 300 and  399 
                and rownum = 1
        )numdoc,
        (select l.bc605pais from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
        )Paistramitante,
        (select l.bc605ndoc from fbc605 l where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
        )NroDnitramitante,
        (select l.bc605tdoc from fbc605 l/*,fst014 m*/ where /*a.bc604co ='S' --and a.bc604fch between ld_fecini and ld_fecfin 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
                --and l.bc605tdoc     = m.tdocum
        )TDocumento,
        (select n.penom from fbc605 l,fsd001 n where /*a.bc604co ='S' --and a.bc604fch between ld_fecini and ld_fecfin 
                and a.BC604TTrn     = 2
                and*/ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
               and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
                and l.bc605ndoc     = n.pendoc
        )Tramitante,
        (select (trim(o.bc602nom)||' '||trim(o.bc602ape)||' '||trim(o.bc602apem)) from fbc605 l,fbc602 o where /*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2*/
                 a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
                and l.bc605tdoc     = o.bc602tdoc
                and l.bc605ndoc     = o.bc602ndoc
        )TramitanteNoCliente
        
from fbc604 a, fsh015 b
where a.bc604co ='S' and a.bc604fch between ld_fecini and ld_fecfin
and a.bc604emp=1 
and a.BC604EMP      = b.pgcod
and a.BC604MOD      = b.hcmod
and a.BC604SUC      = b.hsucor
and a.BC604TRN      = b.htran
and a.BC604NREL     = b.hnrel
and a.BC604FCH      = b.hfcon
and a.BC604TTrn     = 1 --transacciones de menor cuantia 
and b.hccorr        <> 99 --quta las extornadas

;

ln_cta     number(9);
ln_oper    number(9);
ln_toper   number(3);
lc_suc     varchar(100);
ln_mod     number(3);
ln_mda     number(4); 
ld_fecini  date;
ld_fecfin  date;
lc_titular repoue.titular%type;
ln_pais    fsd001.pepais%type;
ln_tdoc    fsd001.petdoc%type;
lc_numdoc  fsd001.pendoc%type;
lc_existe  varchar(1);
lc_listneg fst501.tlisde%type;
lc_entfin  varchar(1);
ln_suc     number(3);
ln_pap     number(4);
ln_sbop    number(3);
ln_pri     number;
lc_dir     char(140);
lc_dirtrm  char(140);
ln_tel     char(20);
ln_teltrm  char(20);
lc_coderr  varchar2(300); 
lc_dis     char(50);
lc_distrm  char(50);
lc_provin  char(30);
lc_prvtrm  char(30);
lc_dep     char(20);
lc_deptrm  char(20);
ln_cantpre number(1);
ln_sucfin  number(3);
ln_aosuc   number(3);
lc_rzso    char(50);
lc_empr    char(30);
ln_tiempo  number(4);
ln_anio    number;
ln_mes     number;
lc_ocu     char(30);
ln_ing     number(17,2);
--lc_titular repoue.titular%type;

begin
ld_fecini := PD_FECINI;--to_date(PD_FECINI,'yyyymmdd');
ld_fecfin := PD_FECFIN;--to_date(PD_FECFIN,'yyyymmdd');
ln_anio   := to_number(to_char(ld_fecfin,'yyyy'));
ln_mes    := to_number(to_char(ld_fecfin,'mm'));
execute immediate ('truncate table JAQY539');
execute immediate ('truncate table JAQY540');
execute immediate ('truncate table JAQY542');

for i in tues (ld_fecini, ld_fecfin) loop
ln_cta     := null;
ln_oper    := null;
ln_toper   := null;
lc_suc     := null;
ln_mod     := null;
ln_mda     := null;
lc_titular :=null;
ln_pais    :=null;
ln_tdoc    :=null;
lc_numdoc  :=null;
lc_existe  :=null;
lc_listneg := null;
lc_entfin  := null;
ln_suc     := null;
ln_pap     := null;
ln_sbop    := null;
ln_pri     := null;
lc_dir     := null;
ln_tel     := null;
lc_dis     := null;
lc_provin  := null;
lc_dep     := null;
ln_cantpre := 1;
ln_aosuc   := null;
ln_sucfin  := null;
lc_rzso    := null;
lc_empr    := null;
ln_tiempo  := null;
lc_ocu     := null;
ln_ing     := null;
--lc_titular:= null;

       --Busca los datos del producto    
       begin 
           select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
           from fsh016 c, fsr008 e,fse008 g,fst001 h 
              where c.pgcod  = i.pgcod  
                and c.hcmod  = i.hcmod   
                and c.hsucor = i.hsucor 
                and c.htran  = i.htran   
                and c.hnrel  = i.hnrel   
                and c.hfcon  = i.hfcon 
                and hcta <> 0
                and e.cttfir = 'T'     
                and e.ctnro  = c.hcta
                and c.hcodmo = 2
                and g.ctxcod = 1
                and g.ctxnro = c.hcta
                and g.ctxsuc = h.sucurs
                and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                        e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                    where c.pgcod  = i.pgcod  
                      and c.hcmod  = i.hcmod   
                      and c.hsucor = i.hsucor 
                      and c.htran  = i.htran   
                      and c.hnrel  = i.hnrel   
                      and c.hfcon  = i.hfcon   
                      and hcta <> 0
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.hcta
                      and c.hcodmo = 2
                      and g.ctxcod = 1
                      and g.ctxnro = c.hcta
                      and g.ctxsuc = h.sucurs
                      and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 );
                  exception
                    when too_many_rows then
                       begin
                       
                       select hcta, 
                              hoper, 
                              htoper, 
                              scnom , 
                              hmodul, 
                              hmda,
                              pepais ,
                              petdoc ,
                              pendoc ,
                              hsucur,
                              hpap
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap      
                           
                        from(select distinct c.hcta, 
                                         c.hoper, 
                                         c.htoper, 
                                         h.scnom , 
                                         c.hmodul, 
                                         c.hmda,
                                         e.pepais ,
                                         e.petdoc ,
                                         e.pendoc ,
                                         c.hsucur,
                                         c.hpap,
                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                        
                       from fsh016 c, fsr008 e,fse008 g,fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.cttfir = 'T'     
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            and g.ctxcod = 1
                            and g.ctxnro = c.hcta
                            and g.ctxsuc = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
                        exception
                          when too_many_rows then
                             dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                        end ;
                    
                    when no_data_found then 
                       dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                          e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                   from fsh016 c, fsr008 e,fse008 g,fst001 h 
                      where c.pgcod  = i.pgcod  
                        and c.hcmod  = i.hcmod   
                        and c.hsucor = i.hsucor 
                        and c.htran  = i.htran   
                        and c.hnrel  = i.hnrel   
                        and c.hfcon  = i.hfcon   
                        and hcta <> 0
                        and e.cttfir = 'T'  
                        and e.ctnro  = c.hcta
                        and c.hcodmo = 2
                        and g.ctxcod = 1
                        and g.ctxnro = c.hcta
                        and g.ctxsuc = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                       from fsh016 c, fsr008 e,fse008 g,fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.cttfir = 'T'  
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            and g.ctxcod = 1
                            and g.ctxnro = c.hcta
                            and g.ctxsuc = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select hcta, 
                                        hoper, 
                                        htoper, 
                                        scnom , 
                                        hmodul, 
                                        hmda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        hsucur,
                                        hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap      
                                     
                                  from(select distinct c.hcta, 
                                                   c.hoper, 
                                                   c.htoper, 
                                                   h.scnom , 
                                                   c.hmodul, 
                                                   c.hmda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.hsucur,
                                                   c.hpap,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                                  where c.pgcod  = i.pgcod  
                                    and c.hcmod  = i.hcmod   
                                    and c.hsucor = i.hsucor 
                                    and c.htran  = i.htran   
                                    and c.hnrel  = i.hnrel   
                                    and c.hfcon  = i.hfcon   
                                    and hcta <> 0
                                    and e.cttfir = 'T'  
                                    and e.ctnro  = c.hcta
                                    and c.hcodmo = 2
                                    and g.ctxcod = 1
                                    and g.ctxnro = c.hcta
                                    and g.ctxsuc = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                                  end ;
                            
                     end;
                 when no_data_found then
                      begin
                        select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                               e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                         from fsh016 c, fsr008 e,fse008 g,fst001 h 
                            where c.pgcod  = i.pgcod  
                              and c.hcmod  = i.hcmod   
                              and c.hsucor = i.hsucor 
                              and c.htran  = i.htran   
                              and c.hnrel  = i.hnrel   
                              and c.hfcon  = i.hfcon   
                              and hcta <> 0
                              and e.ctnro  = c.hcta
                              and e.cttfir = 'T'
                              and c.hcodmo = 2
                              and g.ctxcod = 1
                              and g.ctxnro = c.hcta
                              and g.ctxsuc = h.sucurs
                              and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                       e.pepais ,e.petdoc ,e.pendoc,c.hsucur,c.hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      and g.ctxcod = 1
                                      and g.ctxnro = c.hcta
                                      and g.ctxsuc = h.sucurs
                                      and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select hcta, 
                                        hoper, 
                                        htoper, 
                                        scnom , 
                                        hmodul, 
                                        hmda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        hsucur,
                                        hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap      
                                     
                                  from(select distinct c.hcta, 
                                                   c.hoper, 
                                                   c.htoper, 
                                                   h.scnom , 
                                                   c.hmodul, 
                                                   c.hmda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.hsucur,
                                                   c.hpap,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      and g.ctxcod = 1
                                      and g.ctxnro = c.hcta
                                      and g.ctxsuc = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                    
                                    when no_data_found then 
                                       null;
                                       --dbms_output.put_line ('nohaydata33: '||i.BC604MOD||'-'||i.bc604suc||'-'||i.bc604trn||'-'||i.bc604nrel||'-'||i.bc604fch);                  
                                  end ;     
                             end;       
                     end;       
               end;       
         end; 
         
         
         begin
         
            --si el numero de documento es nulo es porque no encontro cuenta por tanto toma la informacion
            --del tramitante
            if lc_numdoc is null then
            
               ln_pais   := i.Paistramitante;
               ln_tdoc   := i.TDocumento;
               lc_numdoc := i.NroDnitramitante;
               
            end if;
               
         end;
         
         begin
              select j.penom 
                into lc_titular
                from fsd001 j 
               where j.pepais = ln_pais 
                 and j.petdoc = ln_tdoc
                 and j.pendoc = lc_numdoc;
         exception
            when others then 
                 if i.TRAMITANTE is not null then
                    lc_titular:= i.TRAMITANTE;     
                 elsif i.TRAMITANTENOCLIENTE is not null then   
                    lc_titular:= i.TRAMITANTENOCLIENTE; 
                 else
                    lc_titular:= null;   
                 end if;   
         end;
         
         
         --DIRECCION
         begin
            select trim(substr(replace(bc602dire,';',' '),1,140))
            into lc_dirtrm
            from fbc602
            where bc602pais = i.paistramitante
            and bc602tdoc = i.tdocumento
            and bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            lc_dirtrm := null;
         end;
         
         begin
         
                 select f.sngc13dir 
                   into lc_dir
                   from sngc13 f 
                  where f.sngc13pais = ln_pais   
                    and f.sngc13tdoc = ln_tdoc
                    and f.sngc13ndoc = lc_numdoc
                    and f.docod      = 1
                    and f.sngc13est  = 'H';
         
         EXCEPTION
                  when too_many_rows then
                       dbms_output.put_line ('mas de 1dir: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                  when no_data_found then
                       null;
                       --dbms_output.put_line ('no hay 1dir: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                  
                  when others then null;
                    
         end;
         
         --TELEFONO
         begin
            select bc602telr
            into ln_teltrm
            from fbc602
            where bc602pais = i.paistramitante
            and bc602tdoc = i.tdocumento
            and bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            ln_teltrm := null;
         end;
         
         begin
         
                 select b.dotelfp 
                   into ln_tel
                   from fsr005 b 
                  where b.pepais = ln_pais   
                    and b.petdoc = ln_tdoc 
                    and b.pendoc = lc_numdoc
                    and b.docod  = 1
                    and b.doordp = 1;
                    
         
         EXCEPTION
         
                  when too_many_rows then
                       dbms_output.put_line ('mas de 1tel: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);  
                  when no_data_found then
                  
                       begin
                       
                            select b.dotelfp 
                              into ln_tel
                              from fsr005 b 
                             where b.pepais = ln_pais   
                               and b.petdoc = ln_tdoc 
                               and b.pendoc = lc_numdoc
                               /*and b.docod  = 1
                               and b.doordp = 1*/;
                       exception
                               when too_many_rows then
                                    begin
                       
                                          select b.dotelfp 
                                            into ln_tel
                                            from fsr005 b 
                                           where b.pepais = ln_pais   
                                             and b.petdoc = ln_tdoc 
                                             and b.pendoc = lc_numdoc
                                             and b.docod  = (select min(docod)
                                                               from fsr005 bb 
                                                              where bb.pepais = b.pepais 
                                                                and bb.petdoc = b.petdoc
                                                                and bb.pendoc = b.pendoc)
                                             and b.doordp = (select min(doordp)
                                                               from fsr005 bb 
                                                              where bb.pepais = b.pepais 
                                                                and bb.petdoc = b.petdoc
                                                                and bb.pendoc = b.pendoc);
                                     exception
                                             when too_many_rows then
                                                  dbms_output.put_line ('mas de 2tel: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);  
                                             when no_data_found then
                                                  null;
                                                  --dbms_output.put_line ('no hay 2tel: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                                     end;  
                               when no_data_found then
                                    null;
                                    --dbms_output.put_line ('no hay 1tel: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                       end;
                       
                  when others then null;
         end;
         
         
         
         --DISTRITO
         begin
            select di.fst071dsc
            into lc_distrm            
            from fst071 di
            inner join fbc602 t
            on di.fst071col = t.bc602udep||t.bc602upro||t.bc602udis
            and t.bc602pais = i.paistramitante
            and t.bc602tdoc = i.tdocumento
            and t.bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            lc_distrm := null;
         end;        
                  
        begin
        
          select xx.fst071dsc
            into lc_dis
            from sngc13 aa, fst071 xx
           where aa.sngc13pais = ln_pais  
             and aa.sngc13tdoc = ln_tdoc 
             and aa.sngc13ndoc = lc_numdoc
             --and aa.sngc13pais = xx.fst071pai
             and aa.sngc13dpto = xx.fst071dpt
             and aa.sngc13prov = xx.fst071loc
             and aa.sngc13dist = xx.fst071col
             and aa.docod = 1;
             
         exception
             when no_data_found then
                  
                  begin
        
                    select xx.fst071dsc
                      into lc_dis
                      from sngc13 aa, fst071 xx, fbc602 bb
                     where aa.sngc13pais = bb.bc602pais
                       and aa.sngc13tdoc = bb.bc602tdoc
                       and aa.sngc13ndoc = bb.bc602ndoc
                       --and aa.sngc13pais = xx.fst071pai
                       and aa.sngc13dpto = xx.fst071dpt
                       and aa.sngc13prov = xx.fst071loc
                       and aa.sngc13dist = xx.fst071col
                       and aa.docod      = 1
                       and bb.bc602pais  = ln_pais  
                       and bb.bc602tdoc  = ln_tdoc 
                       and bb.bc602ndoc  = lc_numdoc
                       ;
                       
                   exception
                       when no_data_found then
                            lc_dis := null;
                       when too_many_rows then
                            begin
                            
                                 select fst071dsc
                                   into lc_dis
                                   from(select xx.fst071dsc,
                                               dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                              aa.sngc13ndoc, aa.docod 
                                                                     order by aa.sngc13corr 
                                                                     desc nulls last) n_priori
                                           from sngc13 aa, fst071 xx, fbc602 bb
                                          where aa.sngc13pais = bb.bc602pais
                                            and aa.sngc13tdoc = bb.bc602tdoc
                                            and aa.sngc13ndoc = bb.bc602ndoc
                                            --and aa.sngc13pais = xx.fst071pai
                                            and aa.sngc13dpto = xx.fst071dpt
                                            and aa.sngc13prov = xx.fst071loc
                                            and aa.sngc13dist = xx.fst071col
                                            and aa.docod      = 1
                                            and bb.bc602pais  = ln_pais  
                                            and bb.bc602tdoc  = ln_tdoc 
                                            and bb.bc602ndoc  = lc_numdoc)
                                 where n_priori = 1    ;
                                    
                            exception
                                 when no_data_found then
                                      lc_dis := null;
                                 when too_many_rows then
                                      dbms_output.put_line ('mas de dis2: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                            
                            end;
                       

                   end;
             
             when too_many_rows then
                  begin
                  
                         select fst071dsc
                           into lc_dis
                           from(select xx.fst071dsc,
                                       dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                      aa.sngc13ndoc, aa.docod 
                                                             order by aa.sngc13corr 
                                                             desc nulls last) n_priori
            
                                  
                                  from sngc13 aa, fst071 xx
                                 where aa.sngc13pais = ln_pais  
                                   and aa.sngc13tdoc = ln_tdoc 
                                   and aa.sngc13ndoc = lc_numdoc
                                   --and aa.sngc13pais = xx.fst071pai
                                   and aa.sngc13dpto = xx.fst071dpt
                                   and aa.sngc13prov = xx.fst071loc
                                   and aa.sngc13dist = xx.fst071col
                                   and aa.docod = 1)
                            where n_priori = 1    ;
                  
                  
                  exception 
                            when no_data_found then
                                 lc_dis := null;
                            when too_many_rows then
                                 dbms_output.put_line ('mas de dis3: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                  end;

         end;  
         
         
         --PROVINCIA
         begin
            select p.locnom
            into lc_prvtrm
            from fst070 p 
            inner join fbc602 t
            on p.loccod = t.bc602udep||t.bc602upro
            and t.bc602pais = i.paistramitante
            and t.bc602tdoc = i.tdocumento
            and t.bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            lc_prvtrm := null;
         end; 
                  
         begin

             select xx.locnom
               into lc_provin
               from sngc13 aa, fst070 xx
              where aa.sngc13pais = ln_pais  
                and aa.sngc13tdoc = ln_tdoc 
                and aa.sngc13ndoc = lc_numdoc
                and aa.sngc13dpto = xx.depcod
                and aa.sngc13prov = xx.loccod
                and aa.docod = 1;

          exception
              when no_data_found then
                   
                   begin

                       select xx.locnom
                         into lc_provin
                         from sngc13 aa, fst070 xx, fbc602 bb
                        where aa.sngc13pais = ln_pais  
                          and aa.sngc13tdoc = ln_tdoc 
                          and aa.sngc13ndoc = lc_numdoc
                          and aa.sngc13dpto = xx.depcod
                          and aa.sngc13prov = xx.loccod
                          and aa.docod      = 1
                          and aa.sngc13pais = bb.bc602pais
                          and aa.sngc13tdoc = bb.bc602tdoc
                          and aa.sngc13ndoc = bb.bc602ndoc;

                    exception
                        when no_data_found then
                             lc_provin := null;
                        when too_many_rows then
                             
                             begin
                                  
                                  select locnom
                                    into lc_provin
                                    from (select xx.locnom,
                                                 dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                                aa.sngc13ndoc, aa.docod 
                                                                       order by aa.sngc13corr 
                                                                       desc nulls last) n_priori
                                            from sngc13 aa, fst070 xx, fbc602 bb
                                           where aa.sngc13pais = ln_pais  
                                             and aa.sngc13tdoc = ln_tdoc 
                                             and aa.sngc13ndoc = lc_numdoc
                                             and aa.sngc13dpto = xx.depcod
                                             and aa.sngc13prov = xx.loccod
                                             and aa.docod      = 1
                                             and aa.sngc13pais = bb.bc602pais
                                             and aa.sngc13tdoc = bb.bc602tdoc
                                             and aa.sngc13ndoc = bb.bc602ndoc)
                                   where n_priori = 1;
                                           
                             exception
                                   when no_data_found then
                                       lc_dis := null;
                                   when too_many_rows then
                                       dbms_output.put_line ('mas de prov2: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                             end;
                  end;
              
              
              when too_many_rows then
                   begin
                   
                        select locnom
                          into lc_provin
                          from (select xx.locnom,
                                       dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                      aa.sngc13ndoc, aa.docod 
                                                             order by aa.sngc13corr 
                                                             desc nulls last) n_priori
                                  from sngc13 aa, fst070 xx
                                 where aa.sngc13pais = ln_pais  
                                   and aa.sngc13tdoc = ln_tdoc 
                                   and aa.sngc13ndoc = lc_numdoc
                                   and aa.sngc13dpto = xx.depcod
                                   and aa.sngc13prov = xx.loccod
                                   and aa.docod = 1)
                         where n_priori = 1;
                   exception
                         when no_data_found then
                             lc_provin := null;
                        when too_many_rows then
                             dbms_output.put_line ('mas de prov1: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                   end;
         end;
         
         --DEPARTAMENTO
         begin
            select d.depnom 
            into lc_deptrm
            from fst068 d 
            inner join fbc602 t
            on d.depcod = t.bc602udep
            and t.bc602pais = i.paistramitante
            and t.bc602tdoc = i.tdocumento
            and t.bc602ndoc = i.nrodnitramitante;
         exception
         when others then
            lc_deptrm := null;
         end;
         
         begin

             select xx.depnom
               into lc_dep
               from sngc13 aa, fst068 xx
              where aa.sngc13pais = ln_pais  
                and aa.sngc13tdoc = ln_tdoc 
                and aa.sngc13ndoc = lc_numdoc
                --and aa.sngc13pais = xx.pais
                and aa.sngc13dpto = xx.depcod
                and aa.docod      = 1;
          exception
                when no_data_found then
                     begin

                         select xx.depnom
                           into lc_dep
                           from sngc13 aa, fst068 xx, fbc602 bb
                          where aa.sngc13pais = ln_pais  
                            and aa.sngc13tdoc = ln_tdoc 
                            and aa.sngc13ndoc = lc_numdoc
                            --and aa.sngc13pais = xx.pais
                            and aa.sngc13dpto = xx.depcod
                            and aa.docod      = 1
                            and aa.sngc13pais = bb.bc602pais
                            and aa.sngc13tdoc = bb.bc602tdoc
                            and aa.sngc13ndoc = bb.bc602ndoc;
                      exception
                            when no_data_found then
                                 lc_dep := null;
                            when too_many_rows then
                                 
                                 begin
                                      
                                      select depnom
                                        into lc_dep
                                        from (select xx.depnom,
                                                     dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                                    aa.sngc13ndoc, aa.docod 
                                                                           order by aa.sngc13corr 
                                                                           desc nulls last) n_priori
                                                from sngc13 aa, fst068 xx, fbc602 bb
                                               where aa.sngc13pais = ln_pais  
                                                 and aa.sngc13tdoc = ln_tdoc 
                                                 and aa.sngc13ndoc = lc_numdoc
                                                 --and aa.sngc13pais = xx.pais
                                                 and aa.sngc13dpto = xx.depcod
                                                 and aa.docod      = 1
                                                 and aa.sngc13pais = bb.bc602pais
                                                 and aa.sngc13tdoc = bb.bc602tdoc
                                                 and aa.sngc13ndoc = bb.bc602ndoc)
                                        where n_priori = 1;
                                 exception
                                        when no_data_found then
                                             lc_dep := null;
                                        when too_many_rows then
                                             dbms_output.put_line ('mas de dep2: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                                 end;
                      end;
                when too_many_rows then
                     begin
                     
                          select depnom
                            into lc_dep
                            from (select xx.depnom,
                                         dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                        aa.sngc13ndoc, aa.docod 
                                                               order by aa.sngc13corr 
                                                               desc nulls last) n_priori
                                    from sngc13 aa, fst068 xx
                                   where aa.sngc13pais = ln_pais  
                                     and aa.sngc13tdoc = ln_tdoc 
                                     and aa.sngc13ndoc = lc_numdoc
                                     --and aa.sngc13pais = xx.pais
                                     and aa.sngc13dpto = xx.depcod
                                     and aa.docod      = 1)
                            where n_priori = 1;         
                     exception
                            when no_data_found then
                                 lc_dep := null;
                            when too_many_rows then
                                 begin
                     
                                      select depnom
                                        into lc_dep
                                        from (select xx.depnom,
                                                     dense_rank() over(partition by aa.sngc13pais, aa.sngc13tdoc, 
                                                                                    aa.sngc13ndoc, aa.docod 
                                                                           order by aa.sngc13corr 
                                                                           desc nulls last) n_priori
                                                from sngc13 aa, fst068 xx
                                               where aa.sngc13pais = ln_pais  
                                                 and aa.sngc13tdoc = ln_tdoc 
                                                 and aa.sngc13ndoc = lc_numdoc
                                                 --and aa.sngc13pais = xx.pais
                                                 and aa.sngc13dpto = xx.depcod
                                                 and aa.docod      = 1
                                                 and xx.pais       = ln_pais)
                                        where n_priori = 1;         
                                 exception
                                        when no_data_found then
                                             lc_dep := null;
                                        when too_many_rows then
                                             dbms_output.put_line ('mas de dep1: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                                 end;
                     end;
          end;
          
          
         
         -- Existe
          begin
            select distinct 'S'   
              into lc_existe
             from fsh016 c 
                where c.pgcod  = i.pgcod  
                  and c.hcmod  = i.hcmod   
                  and c.hsucor = i.hsucor 
                  and c.htran  = i.htran   
                  and c.hnrel  = i.hnrel   
                  and c.hfcon  = i.hfcon
                  and c.hcord  = i.bc604ord ;
         exception 
           when no_data_found then
                lc_existe:='N';
                
         end;
        
         
         -- Es Entidad Financiera
          begin
            select 'S'
              into lc_entfin 
              from fsd004 o 
             where o.ifpais = i.pais 
               and o.iftdoc = i.tipodoc
               and o.ifndoc = i.numdoc;
           
         exception 
           when no_data_found then
              lc_entfin := 'N';
           when others then 
              lc_entfin := 'N'; 
              dbms_output.put_line ('EF : '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);  
         end;       
         
         
         --ES DE CREDTIOS O AHORROS
        begin
              --si el cliente tiene credito vigente considerar la sucursal donde se desembolsó
               select distinct /*fd10.aomod,*/fd10.aosuc
                 into /*ln_aomod,*/ln_aosuc
                 from fsd010 fd10, fsr008 r
                where fd10.pgcod  = 1
                  
                  --drodriguee mod 1109                                
                  and r.pgcod = 1
                  and r.pepais = i.pais
                  and r.petdoc = i.tipodoc
                  and r.pendoc = i.numdoc
                  and r.cttfir = 'T'
                  and fd10.aocta  = r.ctnro

                  and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo <> 108)
                  and fd10.aostat <> 99;
        exception 
                  
                  when too_many_rows then
                  
                       begin
                           --si hay mas de un credito vigente en dos agencias solo puede darse cuando tiene adicional
                           --un crédito convenio y el que debe ser evaluado es el que NO es convenio
                           select distinct fd10.aosuc
                             into ln_aosuc
                             from fsd010 fd10, fsr008 r
                            where fd10.pgcod  = 1
                  
                              --drodriguee mod 1109                                
                              and r.pgcod = 1
                              and r.pepais = i.pais
                              and r.petdoc = i.tipodoc
                              and r.pendoc = i.numdoc
                              and r.cttfir = 'T'
                              and fd10.aocta  = r.ctnro

                              and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo not in (107,109,108) )
                              and fd10.aostat <> 99; 
                              
                       exception
                       
                              when no_data_found then
                              
                                   begin
                                       --en caso de ser solo convenio tomar la agencia donde se desembolso ese convenio          
                                       select distinct fd10.aosuc
                                         into ln_aosuc
                                         from fsd010 fd10, fsr008 r
                                        where fd10.pgcod  = 1
                  
                                          --drodriguee mod 1109                                
                                          and r.pgcod = 1
                                          and r.pepais = i.pais
                                          and r.petdoc = i.tipodoc
                                          and r.pendoc = i.numdoc
                                          and r.cttfir = 'T'
                                          and fd10.aocta  = r.ctnro

                                          and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo in (107,109) )
                                          and fd10.aostat <> 99; 
                                          
                                   exception
                                   
                                          when no_data_found then
                                               dbms_output.put_line ('no hay c1: '||i.bc604emp||'-'||i.bc604mod||'-'||i.bc604suc||'-'||i.bc604trn
                                                                           ||'-'||i.bc604nrel||'-'||i.bc604fch);
                                          when too_many_rows then
                                               dbms_output.put_line ('mas de c1: '||i.bc604emp||'-'||i.bc604mod||'-'||i.bc604suc||'-'||i.bc604trn
                                                                           ||'-'||i.bc604nrel||'-'||i.bc604fch);
                                   end;
                              
                              when too_many_rows then
                                   dbms_output.put_line ('mas de c2: '||i.bc604emp||'-'||i.bc604mod||'-'||i.bc604suc||'-'||i.bc604trn
                                                                           ||'-'||i.bc604nrel||'-'||i.bc604fch);
                       end;       
                
                  When no_data_found then
                       --drodriguee mod 1109                  
                       if i.bc604mod = 30 and i.bc604trn = 150 then
                         begin
                           select distinct fd10.aosuc
                           into ln_aosuc
                           from fsd010 fd10
                           where fd10.pgcod  = 1
                           and fd10.aocta  = ln_cta
                           and fd10.aomod  in (select modulo from fst111 where dscod = 50 and modulo not in (107,109,108) )
                           and rownum = 1;
                         exception when others then
                           ln_cantpre := 0;
                         end;
                       else
                         ln_cantpre := 0;   --indicador de cliente de ahorros o préstamos
                       end if;

        end;
        
        begin
           if ln_cantpre = 0 then   --0 Ahorros, 1 Créditos
             if ln_suc is null then
               ln_sucfin := i.bc604suc;
             else
               ln_sucfin := ln_suc;
             end if;
           else 
             ln_sucfin := ln_aosuc;
           end if;        
        end;
        
        
        --CENTRO DE LABORES||CARGO||TIEMPO_SERVICIOS
          begin
          
          select se.pfxempr,
                 t20.vinom,
                 (case
                   when se.pfxfdes = to_date('01/01/0001','dd/mm/yyyy') then null
                   else floor(MONTHS_BETWEEN(ld_fecfin,se.pfxfdes)/12) 
                 end)
                   
            into lc_rzso,lc_empr,ln_tiempo
            from fse002 se,fst020 t20
           where se.pfxpais = ln_pais  
             and se.pfxtdoc = ln_tdoc 
             and se.pfxndoc = lc_numdoc
             and se.vicod   = t20.vicod(+);
             
          exception
             when too_many_rows then
                  dbms_output.put_line ('mas de raz: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                 
             when others then null;
          end;
          
         --OCUPACION
          begin
          
          select sn07.sngc07dsc
            into lc_ocu
            from sngc60 sn60,sngc07 sn07
           where sn60.sngc60pais = ln_pais  
             and sn60.sngc60tdoc = ln_tdoc 
             and sn60.sngc60ndoc = lc_numdoc
             and sn60.sngc60ocup = sn07.sngc07cod;
             
          exception
             when too_many_rows then
                  begin
          
                      select sn07.sngc07dsc
                        into lc_ocu
                        from sngc60 sn60,sngc07 sn07
                       where sn60.sngc60pais = ln_pais  
                         and sn60.sngc60tdoc = ln_tdoc 
                         and sn60.sngc60ndoc = lc_numdoc
                         and sn60.sngc60ocup = sn07.sngc07cod
                         and sn60.sngc60corr = (select min(snn60.sngc60corr)
                                                  from sngc60 snn60
                                                 where snn60.sngc60pais = sn60.sngc60pais
                                                   and snn60.sngc60tdoc = sn60.sngc60tdoc
                                                   and snn60.sngc60ndoc = sn60.sngc60ndoc );
                         
                      exception
                         when too_many_rows then
                              dbms_output.put_line ('mas de ocu: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                         when others then null;
                         
                    end;
             when others then null;
          end;
          
          --INGRESO PROMEDIO MENSUAL
          begin
          
                    select fe1.pexing
                      into ln_ing
                      from fse101 fe1
                     where fe1.pepais = ln_pais  
                       and fe1.petdoc = ln_tdoc 
                       and fe1.pendoc = lc_numdoc;
          
          exception
                       when too_many_rows then
                           begin
                                select fe1.pexing
                                  into ln_ing
                                  from fse101 fe1
                                 where fe1.pepais = ln_pais  
                                   and fe1.petdoc = ln_tdoc 
                                   and fe1.pendoc = lc_numdoc
                                   and fe1.pexfecha = (select min(fee1.pexfecha)
                                                         from fse101 fee1
                                                        where fee1.pepais = fe1.pepais
                                                          and fee1.petdoc = fe1.petdoc
                                                          and fee1.pendoc = fe1.pendoc);
                           exception
                               when too_many_rows then 
                                    dbms_output.put_line ('mas de prom: '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);
                               when others then
                                    null;
                             
                           end;   
                        when others then null;                    
          
          
          end;     
          
              
  begin
   insert into JAQY539 (JAQY539_BC604EMP,JAQY539_BC604MOD,JAQY539_BC604SUC,JAQY539_BC604TRN,
                        JAQY539_BC604NREL,JAQY539_BC604FCH,JAQY539_BC604MDA,JAQY539_BC604IMPMO,
                        JAQY539_BC604IMP1,JAQY539_HMODUL,JAQY539_HCTA,JAQY539_HSUCUR,
                        JAQY539_HOPER,JAQY539_PEPAIS,JAQY539_PETDOC,JAQY539_PENDOC,JAQY539_TITULAR,
                        JAQY539_PAISTRAM,JAQY539_TDOCTRAM,JAQY539_NDOCTRAM,JAQY539_HORA,
                        JAQY539_EXTORD,JAQY539_ENTFIN,JAQY539_DIR,JAQY539_TEL,JAQY539_DIST,JAQY539_PROV,
                        JAQY539_DEP,JAQY539_SUCFIN,JAQY539_CREDEJE,JAQY539_CENLAB,JAQY539_CARGO,
                        JAQY539_TS,JAQY539_OCU,JAQY539_ING)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.BC604MDA,
             i.BC604IMPMO,i.BC604IMP1,ln_mod,ln_cta,ln_suc,ln_oper,ln_pais, ln_tdoc, lc_numdoc,
             lc_titular,i.Paistramitante,i.TDOCUMENTO,i.NRODNITRAMITANTE,i.bc604hor,lc_existe,lc_entfin,
             nvl(lc_dir,lc_dirtrm),nvl(ln_tel,ln_teltrm),nvl(lc_dis,lc_distrm),nvl(lc_provin,lc_prvtrm),nvl(lc_dep,lc_deptrm),ln_sucfin,ln_cantpre,lc_rzso,lc_empr,ln_tiempo,
             lc_ocu,ln_ing);
    commit;
    exception
     when others then
           lc_coderr:=sqlerrm;
           dbms_output.put_line ('INSERT : '||lc_coderr);
     end;
end loop;  


begin

--se graba en esta tabla para tener solo un cliente por registro siempre teniendo en
--cuenta la agencia con mayor monto
insert into JAQY540(JAQY540_PEPAIS,JAQY540_PETDOC,JAQY540_PENDOC,JAQY540_CTA,JAQY540_FCH,JAQY540_PENOM,
                    JAQY540_DIR,JAQY540_TEL,JAQY540_DIST,JAQY540_PROV,JAQY540_DEP,JAQY540_SUCFIN,
                    JAQY540_CREDEJE,JAQY540_TIPO,JAQY540_ASESOR,JAQY540_MTO,JAQY540_CENLAB,JAQY540_CARGO,
                    JAQY540_TS,JAQY540_OCU,JAQY540_ING)

select jaqy539_pepais,
               jaqy539_petdoc,
               jaqy539_pendoc,
               jaqy539_hcta,
               jaqy539_bc604fch,
               jaqy539_titular,
               jaqy539_dir,
               jaqy539_tel,
               jaqy539_dist,
               jaqy539_prov,
               jaqy539_dep,
               jaqy539_sucfin,
               jaqy539_credeje,
               'MC' tipo,
               (CASE
               WHEN jaqy539_credeje = 0 then PQ_OCUM_VERIFICACION_TM_TUE_MC.Fn_Ejecutivo(jaqy539_pepais,
                                                                              jaqy539_petdoc,jaqy539_pendoc)
               WHEN jaqy539_credeje = 1 then PQ_OCUM_VERIFICACION_TM_TUE_MC.fn_analista(jaqy539_hcta)
               END) asesor,
               mto,
               jaqy539_cenlab,
               jaqy539_cargo,
               jaqy539_ts,
               jaqy539_ocu,
               jaqy539_ing             
          from (select jaqy539_hcta,
                       jaqy539_bc604fch,
                       jaqy539_pepais,
                       jaqy539_petdoc,
                       jaqy539_pendoc,
                       jaqy539_titular,
                       jaqy539_dir,
                       jaqy539_tel,
                       jaqy539_dist,
                       jaqy539_prov,
                       jaqy539_dep,
                       jaqy539_sucfin,
                       jaqy539_credeje,
                       mto,
                       jaqy539_cenlab,
                       jaqy539_cargo,
                       jaqy539_ts,
                       jaqy539_ocu,
                       jaqy539_ing,
                       dense_rank() over(partition by jaqy539_pepais,jaqy539_petdoc,jaqy539_pendoc order by jaqy539_hcta desc nulls last) n_priori3
                  from (select jaqy539_hcta,
                               jaqy539_bc604fch,
                               jaqy539_pepais,
                               jaqy539_petdoc,
                               jaqy539_pendoc,
                               jaqy539_titular,
                               jaqy539_dir,
                               jaqy539_tel,
                               jaqy539_dist,
                               jaqy539_prov,
                               jaqy539_dep,
                               jaqy539_sucfin,
                               jaqy539_credeje,
                               mto,
                               jaqy539_cenlab,
                               jaqy539_cargo,
                               jaqy539_ts,
                               jaqy539_ocu,
                               jaqy539_ing,
                               dense_rank() over(partition by jaqy539_pepais,jaqy539_petdoc,jaqy539_pendoc order by jaqy539_sucfin desc nulls last) n_priori2
                          from (select jaqy539_hcta,
                                       jaqy539_bc604fch,
                                       jaqy539_pepais,
                                       jaqy539_petdoc,
                                       jaqy539_pendoc,
                                       jaqy539_titular,
                                       jaqy539_dir,
                                       jaqy539_tel,
                                       jaqy539_dist,
                                       jaqy539_prov,
                                       jaqy539_dep,
                                       jaqy539_sucfin,
                                       jaqy539_credeje,
                                       mto,
                                       jaqy539_cenlab,
                                       jaqy539_cargo,
                                       jaqy539_ts,
                                       jaqy539_ocu,
                                       jaqy539_ing,
                                       dense_rank() over(partition by jaqy539_hcta, jaqy539_pepais,jaqy539_petdoc,jaqy539_pendoc order by jaqy539_bc604fch asc nulls last) n_priori
                                  from (select ja39.jaqy539_hcta,
                                               ja39.jaqy539_bc604fch,
                                               ja39.jaqy539_pepais,
                                               ja39.jaqy539_petdoc,
                                               ja39.jaqy539_pendoc,
                                               ja39.jaqy539_titular,
                                               ja39.jaqy539_dir,
                                               ja39.jaqy539_tel,
                                               ja39.jaqy539_dist,
                                               ja39.jaqy539_prov,
                                               ja39.jaqy539_dep,
                                               ja39.jaqy539_sucfin,
                                               ja39.jaqy539_credeje,
                                               ja39.jaqy539_cenlab,
                                               ja39.jaqy539_cargo,
                                               ja39.jaqy539_ts,
                                               ja39.jaqy539_ocu,
                                               ja39.jaqy539_ing,
                                               sum(ja39.jaqy539_bc604imp1)mto
                                          from JAQY539 ja39
                                         where ja39.jaqy539_bc604imp1 = (select max(jaa39.jaqy539_bc604imp1)
                                                                           from jaqy539 jaa39
                                                                          where jaa39.jaqy539_pepais = ja39.jaqy539_pepais
                                                                            and jaa39.jaqy539_petdoc = ja39.jaqy539_petdoc
                                                                            and jaa39.jaqy539_pendoc = ja39.jaqy539_pendoc)
                                             
                                            
                                        group by ja39.jaqy539_hcta,
                                               ja39.jaqy539_bc604fch,
                                               ja39.jaqy539_pepais,
                                               ja39.jaqy539_petdoc,
                                               ja39.jaqy539_pendoc,
                                               ja39.jaqy539_titular,
                                               ja39.jaqy539_dir,
                                               ja39.jaqy539_tel,
                                               ja39.jaqy539_dist,
                                               ja39.jaqy539_prov,
                                               ja39.jaqy539_dep,
                                               ja39.jaqy539_sucfin,
                                               ja39.jaqy539_credeje,
                                               ja39.jaqy539_cenlab,
                                               ja39.jaqy539_cargo,
                                               ja39.jaqy539_ts,
                                               ja39.jaqy539_ocu,
                                               ja39.jaqy539_ing))
                         where n_priori = 1)
                 where n_priori2 = 1)
         where n_priori3 = 1
           /*and mto is not null*/;
           
 COMMIT;

end;

--se graba en esta tabla para filtrar segun los rangos establecidos en la jaql412 y jaql413

begin

insert into JAQY542(JAQY542_PEPAIS,JAQY542_PETDOC,JAQY542_PENDOC,JAQY542_CTA,JAQY542_FCH,JAQY542_PENOM,
                    JAQY542_DIR,JAQY542_TEL,JAQY542_DIST,JAQY542_PROV,JAQY542_DEP,JAQY542_SUCFIN,
                    JAQY542_CREDEJE,JAQY542_TIPO,JAQY542_ASESOR,JAQY542_CENLAB,JAQY542_CARGO,JAQY542_TS,
                    JAQY542_ANOPRO,JAQY542_MESPRO,JAQY542_PRIORI,JAQY542_OCU,JAQY542_ING)

select JAQY540_PEPAIS,
       JAQY540_PETDOC,
       JAQY540_PENDOC,
       JAQY540_CTA,
       JAQY540_FCH,
       JAQY540_PENOM,
       JAQY540_DIR,
       JAQY540_TEL,
       JAQY540_DIST,
       JAQY540_PROV,
       JAQY540_DEP,
       JAQY540_SUCFIN,
       JAQY540_CREDEJE,
       JAQY540_TIPO,
       JAQY540_ASESOR,
       JAQY540_CENLAB,
       JAQY540_CARGO,
       JAQY540_TS,
       ln_anio,
       ln_mes,
       3,
       JAQY540_OCU,
       JAQY540_ING                    
  from JAQY540 J540
 where (j540.jaqy540_sucfin in (select j413.jaql412suc 
                                 from jaql413 j413 
                                where j413.jaql412ran = 1)
       and j540.jaqy540_mto between (select j412.jaql412min
                                       from jaql412 j412
                                      where j412.jaql412ran = 1) and (select j412.jaql412max
                                                                        from jaql412 j412
                                                                       where j412.jaql412ran = 1))
   or (j540.jaqy540_sucfin in (select j413.jaql412suc 
                                 from jaql413 j413 
                                where j413.jaql412ran = 2)
       and j540.jaqy540_mto between (select j412.jaql412min
                                       from jaql412 j412
                                      where j412.jaql412ran = 2) and (select j412.jaql412max
                                                                        from jaql412 j412
                                                                       where j412.jaql412ran = 2))
   or (j540.jaqy540_sucfin in (select j413.jaql412suc 
                                 from jaql413 j413 
                                where j413.jaql412ran = 3)
       and j540.jaqy540_mto between (select j412.jaql412min
                                       from jaql412 j412
                                      where j412.jaql412ran = 3) and (select j412.jaql412max
                                                                        from jaql412 j412
                                                                       where j412.jaql412ran = 3))
  or (j540.jaqy540_sucfin in (select j413.jaql412suc 
                                 from jaql413 j413 
                                where j413.jaql412ran = 4)
       and j540.jaqy540_mto between (select j412.jaql412min
                                       from jaql412 j412
                                      where j412.jaql412ran = 4) and (select j412.jaql412max
                                                                        from jaql412 j412
                                                                       where j412.jaql412ran = 4));
  
  Commit;
       


end;


end SP_MenorCuantia;

Procedure SP_Consolidar(pd_fecpro in string) is

ld_fecpro date;
begin
--execute immediate ('truncate table JAQY541');
execute immediate ('truncate table JAQY543');
ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
 
          begin
             --Consolida los tres tipo de operación
             insert into JAQY543(JAQY543_PAIS,JAQY543_TDOC,JAQY543_NDOC,JAQY543_FCH,JAQY543_PENOM,
                              JAQY543_DIR,JAQY543_DIST,JAQY543_PROV,JAQY543_DEP,JAQY543_TEL,
                              JAQY543_CTA,JAQY543_SUC,JAQY543_CREDEJE,JAQY543_ASESOR,JAQY543_CENLAB,
                              JAQY543_CARGO,JAQY543_TS,JAQY543_TIPO,JAQY543_ANOPRO,JAQY543_MESPRO,
                              JAQY543_PRIORI,JAQY543_OCU,JAQY543_ING)
             
             
              select ja36.jaqy536_bc606pais,
                     ja36.jaqy536_bc606tdoc,
                     ja36.jaqy536_bc606ndoc,
                     ja36.jaqy536_bc606fch,
                     ja36.jaqy536_penom,
                     ja36.jaqy536_direccion,
                     ja36.jaqy536_distrito,
                     ja36.jaqy536_provincia,
                     ja36.jaqy536_depart,
                     ja36.jaqy536_telefono,
                     ja36.jaqy536_hcta,
                     ja36.jaqy536_sucfin,
                     ja36.jaqy536_credeje,
                     ja36.jaqy536_asesor,
                     ja36.jaqy536_cenlab,
                     ja36.jaqy536_cargo,
                     ja36.jaqy536_ts,
                     ja36.jaqy536_tipo,
                     ja36.jaqy536_anopro,
                     ja36.jaqy536_mespro,
                     ja36.jaqy536_priori,
                     ja36.jaqy536_ocu,
                     ja36.jaqy536_ing
                from jaqy536 ja36
               where ja36.jaqy536_bc606fch = ld_fecpro  
              union

              select ja38.jaqy538_pepais,
                     ja38.jaqy538_petdoc,
                     ja38.jaqy538_pendoc,
                     ja38.jaqy538_fch,
                     ja38.jaqy538_penom,
                     ja38.jaqy538_dir,
                     ja38.jaqy538_dist,
                     ja38.jaqy538_prov,
                     ja38.jaqy538_dep,
                     ja38.jaqy538_tel,
                     ja38.jaqy538_cta,
                     ja38.jaqy538_sucfin,
                     ja38.jaqy538_credeje,
                     ja38.jaqy538_asesor,
                     ja38.jaqy538_cenlab,
                     ja38.jaqy538_cargo,
                     ja38.jaqy538_ts,
                     ja38.jaqy538_tipo,
                     ja38.jaqy538_anopro,
                     ja38.jaqy538_mespro,
                     ja38.jaqy538_priori,
                     ja38.jaqy538_ocu,
                     ja38.jaqy538_ing
                from jaqy538 ja38
               

              union

              select ja42.jaqy542_pepais,
                     ja42.jaqy542_petdoc,
                     ja42.jaqy542_pendoc,
                     ja42.jaqy542_fch,
                     ja42.jaqy542_penom,
                     ja42.jaqy542_dir,
                     ja42.jaqy542_dist,
                     ja42.jaqy542_prov,
                     ja42.jaqy542_dep,
                     ja42.jaqy542_tel,
                     ja42.jaqy542_cta,
                     ja42.jaqy542_sucfin,
                     ja42.jaqy542_credeje,
                     ja42.jaqy542_asesor,
                     ja42.jaqy542_cenlab,
                     ja42.jaqy542_cargo,
                     ja42.jaqy542_ts,
                     ja42.jaqy542_tipo,
                     ja42.jaqy542_anopro,
                     ja42.jaqy542_mespro,
                     ja42.jaqy542_priori,
                     ja42.jaqy542_ocu,
                     ja42.jaqy542_ing
                from jaqy542 ja42;
               
          commit;
          end;
          
          Begin
          --Se graba esta tabla para filtrar que solo se tome en cuenta la informacion de una
          --operacion en el caso de que haya las 3 se tomara segun la prioridad ya asignada en 
          --las tablas de cada tipo de operacion
          insert into JAQY541(JAQY541_PAIS,JAQY541_TDOC,JAQY541_NDOC,JAQY541_FECREP,JAQY541_PENOM,
                                 JAQY541_DIR,JAQY541_DIST,JAQY541_PROV,JAQY541_DEP,JAQY541_TEL,
                                 JAQY541_CTA,JAQY541_SUC,JAQY541_CREDEJE,JAQY541_ASESOR,JAQY541_CENLAB,
                                 JAQY541_CARGO,JAQY541_TS,JAQY541_TIPO,JAQY541_ANOPRO,JAQY541_MESPRO,
                                 JAQY541_OCU,JAQY541_ING,JAQY541_ACT,JAQY541_SECT,JAQY541_FECAUX)
                              
          select JAQY543_PAIS,
                 JAQY543_TDOC,
                 JAQY543_NDOC,
                 JAQY543_FCH,
                 JAQY543_PENOM,
                 JAQY543_DIR,
                 JAQY543_DIST,
                 JAQY543_PROV,
                 JAQY543_DEP,
                 JAQY543_TEL,
                 JAQY543_CTA,
                 JAQY543_SUC,
                 JAQY543_CREDEJE,
                 JAQY543_ASESOR,
                 JAQY543_CENLAB,
                 JAQY543_CARGO,
                 JAQY543_TS,
                 JAQY543_TIPO,
                 JAQY543_ANOPRO,
                 JAQY543_MESPRO,
                 JAQY543_OCU,
                 JAQY543_ING,
                 PQ_OCUM_VERIFICACION_TM_TUE_MC.fn_actividad(JAQY543_PAIS,JAQY543_TDOC,JAQY543_NDOC),
                 PQ_OCUM_VERIFICACION_TM_TUE_MC.fn_sector(JAQY543_PAIS,JAQY543_TDOC,JAQY543_NDOC),
                 JAQY543_FCH
                  
            from JAQY543 ja43 
           where ja43.jaqy543_priori = (select min(jaa43.jaqy543_priori)
                                           from JAQY543 jaa43
                                          where jaa43.jaqy543_pais = ja43.jaqy543_pais
                                            and jaa43.jaqy543_tdoc = ja43.jaqy543_tdoc
                                            and jaa43.jaqy543_ndoc = ja43.jaqy543_ndoc)  
             and not exists (select jaa41.jaqy541_pais,jaa41.jaqy541_tdoc,jaa41.jaqy541_ndoc
                                                 from jaqy541 jaa41
                                                where jaa41.jaqy541_pais = ja43.jaqy543_pais
                                                  and jaa41.jaqy541_tdoc = ja43.jaqy543_tdoc
                                                  and jaa41.jaqy541_ndoc = ja43.jaqy543_ndoc)  ;
          commit;                
          
          end;
          
          begin
          
          update JAQY541 ja41 set ja41.JAQY541_FECAUX = (select ja43.jaqy543_fch
                                                           from jaqy543 ja43
                                                          where ja43.jaqy543_pais = ja41.jaqy541_pais
                                                            and ja43.jaqy543_tdoc = ja41.jaqy541_tdoc
                                                            and ja43.jaqy543_ndoc = ja41.jaqy541_ndoc
                                                            and ja43.jaqy543_priori = (select min(jx.jaqy543_priori)
                                                                                         from JAQY543 jx
                                                                                        where jx.jaqy543_pais = ja43.jaqy543_pais
                                                                                          and jx.jaqy543_tdoc = ja43.jaqy543_tdoc
                                                                                          and jx.jaqy543_ndoc = ja43.jaqy543_ndoc) );
          
          commit;
          end;
          
end SP_Consolidar;

function fn_actividad (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return char is
lc_activi char(60);
begin
  begin
  select xx.actnom1
    into lc_activi
    from sngc60 aa, fst750 xx
   where aa.sngc60pais = pn_pais
     and aa.sngc60tdoc = pn_tdoc
     and aa.sngc60ndoc = pc_ndoc
     and aa.sngc60corr = 0
     and aa.sngc60acte = xx.actcod1;
  exception
      when no_data_found then
           begin
           
                  select xxx.actnom1
                    into lc_activi
                    from sngc11 cc, fst750 xxx
                   where cc.sngc11pais = pn_pais
                     and cc.sngc11tdoc = pn_tdoc
                     and cc.sngc11ndoc = pc_ndoc
                     and cc.sngc11act2 = xxx.actcod1;
           exception
               when no_data_found then
                    select xxx.actnom1
                    into lc_activi
                    from fse001 cc, fst750 xxx
                   where cc.d511pais = pn_pais
                     and cc.d511tdoc = pn_tdoc
                     and cc.d511ndoc = pc_ndoc
                     and cc.expnins = xxx.actcod1;
           end;
         
      when too_many_rows then
         lc_activi := NULL;
  end;
   return lc_activi;
end fn_actividad;

function fn_sector (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return char is
lc_sector char(60);
begin
  begin
  select xx.actnom3
    into lc_sector
    from sngc60 aa, fst752 xx
   where aa.sngc60pais = pn_pais
     and aa.sngc60tdoc = pn_tdoc
     and aa.sngc60ndoc = pc_ndoc
     and aa.sngc60corr = 0
     and aa.sngc60tipa = xx.actcod3;
  exception
      when no_data_found then
         begin
          select xx.actnom3
            into lc_sector
            from sngc11 cc, fst752 xx
           where cc.sngc11pais = pn_pais
             and cc.sngc11tdoc = pn_tdoc
             and cc.sngc11ndoc = pc_ndoc
             and cc.sngc11tpa2 = xx.actcod3;
          exception
              when others then
                 lc_sector := null;
         end;
      when others then
                 lc_sector := null;
  end;
   return lc_sector;
end fn_sector;

end PQ_OCUM_VERIFICACION_TM_TUE_MC;
/

