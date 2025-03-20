create or replace package pq_cr_campaniaNav2018 is

Procedure Sp_cr_resolutor1_AF (pn_ins in number,
                            pc_flg out char);
Procedure Sp_cr_resolutor2_CT (pn_ins in number,
                            pc_flg out char);                            
Procedure Sp_cr_resolutor3_MTOAF (pn_ins in number,
                            pn_mto out number);   
Procedure sp_cr_resolutor4_SO (pn_pai in number,
                               pn_tdo in number,
                               pc_ndo in char,
                            pn_seg out number);                                                     

Procedure Sp_cr_resolutor5_HRCC (pn_ins in number,
                            pd_fecpro in date,
                            ln_CntAntRcc out number);
Procedure Sp_cr_resolutor6_C18 (pn_ins in number,
                            pc_flg out char);
Procedure Sp_cr_resolutor7_PAS (pn_ins in number,
                            pc_flg out char);
Function Fn_deuda(TipDocSbs in char,
                        pc_ndo in char,
                        pd_fecRcc in date,
                        lc_tiper in char
                        )return number ;
Procedure sp_cr_resolutor8_DPF (pn_ins in number,pn_tasa out number);                                                                                                            
end pq_cr_campaniaNav2018;
/

create or replace package body pq_cr_campaniaNav2018 is

Procedure Sp_cr_resolutor1_AF (pn_ins in number,
                            pc_flg out char) is

ln_pai number(3);
ln_tdo number(2);
lc_doc char(12);
lc_flg char(1) := 'N';

begin
     begin
          select a.sng001pais,
                 a.sng001tdoc,
                 a.sng001ndoc
            into ln_pai,
                 ln_tdo,
                 lc_doc
            from sng001 a
           where a.sng001inst = pn_ins;
     exception
           when others then null;
     end;
     
     begin
           select 'S'
             into lc_flg
             from fsd010 a,fsr008 b
            where a.pgcod  = 1
              and a.aocta  = b.ctnro
              and b.cttfir = 'T'
              and b.pepais = ln_pai
              and b.petdoc = ln_tdo
              and b.pendoc = lc_doc
              and a.aomod  = 102
              and a.aostat <> 99
              and rownum   = 1;
     exception
              when others then 
                   lc_flg := 'N';
     end;
     
     if lc_flg = 'N' then
        begin
               select 'S'
                 into lc_flg
                 from fsd010 a,fsr008 b
                where a.pgcod  = 1
                  and a.aocta  = b.ctnro
                  and b.cttfir = 'T'
                  and b.pepais = ln_pai
                  and b.petdoc = ln_tdo
                  and b.pendoc = lc_doc
                  and a.aomod  = 104
                  and a.aostat <> 99
                  and a.aotope in (select aa.tp1nro1
                                     from fst198 aa
                                    where aa.tp1cod   = 1
                                      and aa.tp1cod1  = 10899
                                      and aa.tp1corr1 = 800
                                      and aa.tp1corr2 = 1)
                  and rownum   = 1;
         exception
                  when others then 
                       lc_flg := 'N';
         end;       
     end if;
     
     pc_flg:= lc_flg;
     
end Sp_cr_resolutor1_AF;

Procedure Sp_cr_resolutor2_CT (pn_ins in number,
                            pc_flg out char) is

ln_pai number(3);
ln_tdo number(2);
lc_doc char(12);
lc_flg char(1) := 'N';

begin
     begin
          select a.sng001pais,
                 a.sng001tdoc,
                 a.sng001ndoc
            into ln_pai,
                 ln_tdo,
                 lc_doc
            from sng001 a
           where a.sng001inst = pn_ins;
     exception
           when others then null;
     end;
     
     begin
           select 'S'
             into lc_flg
             from fsd010 a,fsr008 b
            where a.pgcod  = 1
              and a.aocta  = b.ctnro
              and b.cttfir = 'T'
              and b.pepais = ln_pai
              and b.petdoc = ln_tdo
              and b.pendoc = lc_doc
              and a.aomod  = 101
              and a.aostat <> 99
              and rownum   = 1;
     exception
              when others then 
                   lc_flg := 'N';
     end;
     
     if lc_flg = 'N' then
        begin
               select 'S'
                 into lc_flg
                 from fsd010 a,fsr008 b
                where a.pgcod  = 1
                  and a.aocta  = b.ctnro
                  and b.cttfir = 'T'
                  and b.pepais = ln_pai
                  and b.petdoc = ln_tdo
                  and b.pendoc = lc_doc
                  and a.aomod  = 104
                  and a.aostat <> 99
                  and a.aotope in (select aa.tp1nro1
                                     from fst198 aa
                                    where aa.tp1cod   = 1
                                      and aa.tp1cod1  = 10899
                                      and aa.tp1corr1 = 800
                                      and aa.tp1corr2 = 2)
                  and rownum   = 1;
         exception
                  when others then 
                       lc_flg := 'N';
         end;       
     end if;
     
     pc_flg:= lc_flg;
     
end Sp_cr_resolutor2_CT;

Procedure Sp_cr_resolutor3_MTOAF (pn_ins in number,
                            pn_mto out number) is

ln_pai number(3);
ln_tdo number(2);
lc_doc char(12);
ln_mto number(17,2);

begin
     begin
          select a.sng001pais,
                 a.sng001tdoc,
                 a.sng001ndoc
            into ln_pai,
                 ln_tdo,
                 lc_doc
            from sng001 a
           where a.sng001inst = pn_ins;
     exception
           when others then null;
     end;
     
     begin
           select max(a.aoimp)
             into ln_mto
             from fsd010 a,fsr008 b
            where a.pgcod  = 1
              and a.aocta  = b.ctnro
              and b.cttfir = 'T'
              and b.pepais = ln_pai
              and b.petdoc = ln_tdo
              and b.pendoc = lc_doc
              and a.aomod  = 102
              and a.aostat <> 99;
     exception
              when others then 
                   ln_mto := 0;
     end;
     
     pn_mto := ln_mto;
     
    
     
end Sp_cr_resolutor3_MTOAF;

Procedure sp_cr_resolutor4_SO (pn_pai in number,
                               pn_tdo in number,
                               pc_ndo in char,
                            pn_seg out number) is

lc_segmentacion char(30);

ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);
ld_fecmin date;
ln_instancia number(10);
begin
    
  
    begin
      select min(aofval)
        into ld_fecmin
        from fsd010 a, fsr008 b
       where a.pgcod = 1
         and a.aocta = b.ctnro
         and b.cttfir = 'T'
         and b.pepais = pn_pai
         and b.petdoc = pn_tdo
         and b.pendoc = pc_ndo
         and a.aomod in (select modulo from fst111 where dscod = 50
                          and modulo not in (116,108));
    exception
      when others then
        null;
    end;
    
    begin
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from fsd010 a, fsr008 b
       where a.pgcod  = 1
         and a.aocta  = b.ctnro
         and b.cttfir = 'T'
         and b.pepais = pn_pai
         and b.petdoc = pn_tdo
         and b.pendoc = pc_ndo
         and a.aomod  in (select modulo from fst111 where dscod = 50 
                                 and modulo not in (116,108))
         and a.aofval = ld_fecmin
         and rownum   = 1;
    exception
      when others then
        null;
      
    end;
    
    ln_instancia := fn_instancia_credito(ln_mod,
                                         ln_suc,
                                         ln_mda,
                                         ln_pap,
                                         ln_cta,
                                         ln_ope,
                                         ln_sbo,
                                         ln_top);
    begin
      select substr(pae71val, 1, INSTR(pae71val, ':') - 1)
        into lc_segmentacion
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 380
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 1
         and n.pae70ins = ln_instancia
         and n.pae70nro = (select max(d.pae70nro)
                             from fpae70 d
                            where d.pae70ins = n.pae70ins
                              and d.pae51eva = n.pae51eva);
    exception
      when others then
        null;
    end;
    
    begin
      select a.jaqy067ccal
        into pn_seg
        from jaqy067 a
       where a.jaqy067ncal = trim(lc_segmentacion);
    exception
      when others then
        null;
    end;
          

end sp_cr_resolutor4_SO;


Procedure Sp_cr_resolutor5_HRCC (pn_ins in number,
                            pd_fecpro in date,
                            ln_CntAntRcc out number)is

ln_ic        number(3);
ln_lim       number(9);
ld_fecantrcc date;                      
lc_tiper     char(1);
ln_pai       number(3);
ln_tdo       number(2);
lc_ndo       char(12);
lc_flgEx     char(1);
DocSbsTit    char(1);
DocSbs       number(10);

begin
      
      begin
         select a.sng001pais,
                a.sng001tdoc,
                a.sng001ndoc
           into ln_pai,
                ln_tdo,
                lc_ndo           
           from sng001 a
          where a.sng001inst = pn_ins;
      exception --mod@abr 20181102
          when others then null;
      end;

          --********ANTIGUEDAD RCC********---------
      ln_CntAntRcc := 0;
      ln_ic := 0;
      
      --limite antiguedad rcc
      begin
           select tp1nro1
             into ln_lim
             from fst198 a
            where a.tp1cod = 1
              and Tp1cod1 = 10854 
              and Tp1corr1 = 2 
              and Tp1corr2 = 1 
              and tp1corr3 = 2;
      exception
          when no_data_found then
               ln_lim := null; 
      end;
      
      --tipo de persona
     begin
         select a.petipo
           into lc_tiper
           from fsd001 a
          where a.pepais =ln_pai
            and a.petdoc =ln_tdo
            and a.pendoc =lc_ndo;
     exception
            when no_data_found then
                 lc_tiper:=null;
     end;
     
     --Guia equivalencia tipo de documento
     begin
          select a.tp1corr3
            into DocSbs
            from fst198 a
           where a.tp1cod   = 1
             and a.tp1cod1  = 11111
             and a.tp1corr1 = 1
             and a.tp1corr2 = 3
             and tp1nro1    = ln_tdo;
     exception
           when no_data_found then
                DocSbs := null;
     end;
     DocSbsTit := Trim(to_char(DocSbs));
     
       --fecha rcc
       if pd_fecpro = to_date('30.11.2015','dd.mm.yyyy') then
       ld_fecantrcc := to_date('31.10.2015','dd.mm.yyyy');
       else
          if  pd_fecpro = to_date('31.12.2015','dd.mm.yyyy') then
              ld_fecantrcc := to_date('30.11.2015','dd.mm.yyyy');
              else
                  if pd_fecpro = to_date('31.01.2016','dd.mm.yyyy') then
                     ld_fecantrcc := to_date('31.12.2015','dd.mm.yyyy');
                     else
                          begin
                             select to_date(tpnro,'dd/mm/yyyy')
                               into ld_fecantrcc
                               from fst098
                              where pgcod = 1
                                and tpcod = 7647
                                and tpcorr = 12;
                         exception
                                when no_data_found then
                                     ld_fecantrcc := null;
                         end;
                   end if;
          end if;
       end if;

     
     while ln_ic <= ln_lim loop
        case
           when lc_tiper = 'F' then
                begin
                    select 'S'
                      into lc_flgEx
                      from CLDRCCI
                     Where D_FECPRE = ld_fecantrcc
                       and C_TDOCID = DocSbsTit 
                       and C_DOCIDE = trim(lc_ndo)
                       and rownum = 1;
                exception
                       when no_data_found then
                            lc_flgEx := 'N';
                end;
                if lc_flgEx = 'S' then
                   ln_CntAntRcc := ln_CntAntRcc + 1;
                end if;
           when lc_tiper = 'J' then
                begin
                    select 'S'
                      into lc_flgEx
                      from CLDRCCI
                     Where D_FECPRE = ld_fecantrcc
                       and C_TDOCTR = DocSbsTit 
                       and C_DOCTRI = trim(lc_ndo)
                       and rownum = 1;
                exception
                       when no_data_found then
                            lc_flgEx := 'N';
                end;
                if lc_flgEx = 'S' then
                   ln_CntAntRcc := ln_CntAntRcc + 1;
                end if;
            else
                begin
                    select 'S'
                      into lc_flgEx
                      from CLDRCCI
                     Where D_FECPRE = ld_fecantrcc
                       and C_DOCIDE = trim(lc_ndo)
                       and rownum = 1;
                exception
                       when no_data_found then
                            lc_flgEx := 'N';
                end;
                if lc_flgEx = 'S' then
                   ln_CntAntRcc := ln_CntAntRcc + 1;
                end if;
                
                if lc_flgEx = 'N' then
                   begin
                        select 'S'
                          into lc_flgEx
                          from CLDRCCI
                         Where D_FECPRE = ld_fecantrcc
                           and C_DOCTRI = trim(lc_ndo)
                           and rownum = 1;
                    exception
                           when no_data_found then
                                lc_flgEx := 'N';
                    end;
                    if lc_flgEx = 'S' then
                       ln_CntAntRcc := ln_CntAntRcc + 1;
                    end if;
                end if;

        end case;
        ld_fecantrcc := last_day(add_months(ld_fecantrcc,-1));
        ln_ic := ln_ic + 1;        
                
     end loop;
end Sp_cr_resolutor5_HRCC;

Procedure Sp_cr_resolutor6_C18 (pn_ins in number,
                            pc_flg out char) is

ln_pai number(3);
ln_tdo number(2);
lc_doc char(12);
lc_flg char(1) := 'N';

begin
     begin
          select a.sng001pais,
                 a.sng001tdoc,
                 a.sng001ndoc
            into ln_pai,
                 ln_tdo,
                 lc_doc
            from sng001 a
           where a.sng001inst = pn_ins;
     exception
           when others then null;
     end;
     
     begin
           select 'S'
             into lc_flg
             from fsd010 a,fsr008 b
            where a.pgcod  = 1
              and a.aocta  = b.ctnro
              and b.cttfir = 'T'
              and b.pepais = ln_pai
              and b.petdoc = ln_tdo
              and b.pendoc = lc_doc
              and a.aomod  = 103
              and a.aotope in (select aa.tp1nro1
                                     from fst198 aa
                                    where aa.tp1cod   = 1
                                      and aa.tp1cod1  = 10899
                                      and aa.tp1corr1 = 800
                                      and aa.tp1corr2 = 3)
              and a.aofval >= to_date('01.01.2018','dd.mm.yyyy')
              and a.aostat <> 99
              and rownum   = 1;
     exception
              when others then 
                   lc_flg := 'N';
     end;
     
     
     pc_flg:= lc_flg;
     
end Sp_cr_resolutor6_C18;

Procedure Sp_cr_resolutor7_PAS (pn_ins in number,
                            pc_flg out char) is

ln_pai number(3);
ln_tdo number(2);
lc_doc char(12);
ld_fecmax date;
ld_fecfin date;
DocSbs       number(10);
DocSbsTit    char(1);
lc_tiper     char(1);
ln_mtoAnt    number(17,2);
ln_mtoAct    number(17,2);
fec_rcc      date;
begin
     begin
          select a.sng001pais,
                 a.sng001tdoc,
                 a.sng001ndoc
            into ln_pai,
                 ln_tdo,
                 lc_doc
            from sng001 a
           where a.sng001inst = pn_ins;
     exception
           when others then null;
     end;
     
     begin
      select max(aofval)
        into ld_fecmax
        from fsd010 a, fsr008 b
       where a.pgcod = 1
         and a.aocta = b.ctnro
         and b.cttfir = 'T'
         and b.pepais = ln_pai
         and b.petdoc = ln_tdo
         and b.pendoc = lc_doc
         and a.aomod in (select modulo from fst111 where dscod = 50
                           and modulo not in (116,108));
    exception
      when others then
        null;
    end;
    
    ld_fecfin := last_day(ld_fecmax);
    
    --Guia equivalencia tipo de documento
     begin
          select a.tp1corr3
            into DocSbs
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11111
             and a.tp1corr1 = 1
             and a.tp1corr2 = 3
             and tp1nro1 = ln_tdo;
     exception
           when no_data_found then
                DocSbs := null;
     end;
     DocSbsTit := Trim(to_char(DocSbs));
     
     --tipo de persona
     begin
         select a.petipo
           into lc_tiper
           from fsd001 a
          where a.pepais =ln_pai
            and a.petdoc =ln_tdo
            and a.pendoc =lc_doc;
     exception
            when no_data_found then
                 lc_tiper:=null;
     end;
     --fecha rcc actual
     begin
           select to_date(tpnro,'dd/mm/yyyy')
             into fec_rcc
             from fst098
            where pgcod = 1
              and tpcod = 7647
              and tpcorr = 12;
       exception
              when others then
                   fec_rcc := null;
       end;
       
     if ld_fecmax >  fec_rcc then
        ld_fecfin := fec_rcc;
     end if;      
     ln_mtoAnt := pq_cr_campaniaNav2018.fn_deuda(DocSbsTit,lc_doc,ld_fecfin,lc_tiper);
     ln_mtoAct := pq_cr_campaniaNav2018.fn_deuda(DocSbsTit,lc_doc,fec_rcc,lc_tiper);
     
     if ln_mtoAct > ln_mtoAnt then
        pc_flg := 'S';
        else
               pc_flg := 'N';
     end if;
end Sp_cr_resolutor7_PAS;

Function Fn_deuda(TipDocSbs in char,
                        pc_ndo in char,
                        pd_fecRcc in date,
                        lc_tiper in char
                        )return number is
                     
lc_CodSbs char(10);
ln_mto number(17,2) := 0;
 
              
begin
      begin
          case
             when lc_tiper = 'F' then
                  begin
                     select C_CODSBS
                       into lc_CodSbs
                       from CLDRCCI
                      Where D_FECPRE = pd_fecRcc
                        and C_TDOCID = TipDocSbs 
                        and C_DOCIDE = trim(pc_ndo)
                        and rownum = 1;
                  exception
                        when no_data_found then
                             lc_CodSbs := NULL;
                  end;
             when lc_tiper = 'J' then
                  begin
                     select C_CODSBS
                       into lc_CodSbs
                       from CLDRCCI
                      Where D_FECPRE = pd_fecRcc
                        and C_TDOCTR = TipDocSbs 
                        and C_DOCTRI = trim(pc_ndo)
                        and rownum = 1;
                  exception
                        when no_data_found then
                             lc_CodSbs := NULL;
                  end;
              else
                  begin
                     select C_CODSBS
                       into lc_CodSbs
                       from CLDRCCI
                      Where D_FECPRE = pd_fecRcc
                        and C_DOCIDE = trim(pc_ndo)
                        and rownum = 1;
                  exception
                        when no_data_found then
                             lc_CodSbs := NULL;
                  end;
                  if lc_CodSbs is null then
                     begin
                         select C_CODSBS
                           into lc_CodSbs
                           from CLDRCCI
                          Where D_FECPRE = pd_fecRcc
                            and C_DOCTRI = trim(pc_ndo)
                            and rownum = 1;
                      exception
                            when no_data_found then
                                 lc_CodSbs := NULL;
                      end;        
                  end if;
              
                 
         end case;
         
         begin
             select nvl(sum(n_salcap), 0)
                into ln_mto
                from CLDRCCS
               Where C_CODSBS = lc_CodSbs
                 and C_CODEMP <> '00104'
                 and (C_CUENTA like '14_1%'
                     Or C_CUENTA like '14_3%' 
                     Or C_CUENTA like '14_4%'  
                     Or C_CUENTA like '14_5%' 
                     Or C_CUENTA like '14_6%' 
                     Or C_CUENTA like '14_8%'
                     Or C_CUENTA like '71_1%' 
                     Or C_CUENTA like '71_2%' 
                     Or C_CUENTA like '71_3%' 
                     Or C_CUENTA like '71_4%' 
                     Or C_CUENTA like '81_3%' 
                     Or C_CUENTA like '81_302%'
                     Or C_CUENTA like '72_501%'
                     Or C_CUENTA like '72_502%'
                     Or C_CUENTA like '72_503%'
                     Or C_CUENTA like '72_504%'
                     Or C_CUENTA like '72_505%'
                     Or C_CUENTA like '72_506%'
                     Or C_CUENTA like '72_507%')
                 and D_FECPRE = pd_fecRcc
                 and C_CODEMP <> '00104';
         exception
                 when others then
                      ln_mto := 0;
         end;
         
         
      
      end;
      return ln_mto;

end Fn_deuda;

Procedure sp_cr_resolutor8_DPF (pn_ins in number,pn_tasa out number) is

cursor garantias is
select s.sng122pgc  ln_pgcodGar,
       s.sng122mod  ln_modGar,
       s.sng122suc  ln_sucGar,
       s.sng122mda  ln_mdaGar,
       s.sng122pap  ln_papGar,
       s.sng122cta  ln_ctaGar,
       s.sng122oper ln_operGar,
       s.sng122sbop ln_sbopGar,
       s.sng122tope ln_topeGar
  from sng122 s
 where sng122inst = pn_ins
   and s.sng122tope in (80, 85);
ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);
ln_tasa number(10,6);
ln_tasaFinal number(10,6);
begin
     ln_tasaFinal := 0;   
     for i in garantias loop
         begin
           select r.r1cod,
                  r.r1mod,
                  r.r1suc,
                  r.r1mda,
                  r.r1pap,
                  r.r1cta,
                  r.r1oper,
                  r.r1sbop,
                  r.r1tope
             into ln_emp,
                  ln_mod,
                  ln_suc,
                  ln_mda,
                  ln_pap,
                  ln_cta,
                  ln_ope,   
                  ln_sbo,
                  ln_top
             from fsr011 r, fsd010 f
            where r.r2cod  = i.ln_pgcodGar
              and r.r2mod  = i.ln_modGar
              and r.r2suc  = i.ln_sucGar
              and r.r2mda  = i.ln_mdaGar
              and r.r2pap  = i.ln_papGar
              and r.r2cta  = i.ln_ctaGar
              and r.r2oper = i.ln_operGar
              and r.r2sbop = i.ln_sbopGar
              and r.r2tope = i.ln_topeGar
              and r.relcod = 2
              and r.r1cod  = f.pgcod
              and r.r1mod  = f.aomod
              and r.r1suc  = f.aosuc
              and r.r1mda  = f.aomda
              and r.r1pap  = f.aopap
              and r.r1cta  = f.aocta
              and r.r1oper = f.aooper
              and r.r1sbop = f.aosbop
              and r.r1tope = f.aotope
              and f.aostat <> 99;
         exception
              when others then null;
         end;
         
         pq_segmentacion_clientes_pas.sp_tasa(ln_emp,
                                              ln_suc,
                                              ln_cta,
                                              ln_mda,
                                              ln_pap,
                                              ln_ope,
                                              ln_sbo,
                                              ln_top,
                                              ln_mod,
                                              ln_tasa);
                                              
         if ln_tasa > ln_tasaFinal then
            ln_tasaFinal := ln_tasa;
         end if;                                                                                           
                                              
     end loop;
     pn_tasa := ln_tasaFinal;
end sp_cr_resolutor8_DPF;

end pq_cr_campaniaNav2018;
/

