create or replace package pq_cr_Segmentacion_variable is


Function fn_verificaSdo(ld_fecRCC in date,
                        pn_pai in number,
                        pn_tdo in number,
                        pc_ndo in char) return char;
                        
Procedure Sp_cr_saldo3(pn_pai in number,
                       pn_tdo in number,
                       pc_ndo in char,
                       pc_flgTit out char,
                       pc_flgCyg out char);                        
                        
end pq_cr_Segmentacion_variable;
/

create or replace package body pq_cr_Segmentacion_variable is

Procedure Sp_cr_saldo3(pn_pai in number,
                       pn_tdo in number,
                       pc_ndo in char,
                       pc_flgTit out char,
                       pc_flgCyg out char)is
                       
ld_fecRCC date;
ln_Rpccyg number(4);
lc_flgTit char(1) := 'N';
ln_paiC number(3);
ln_tdoC number(2);
lc_ndoC char(12);
lc_flgCyg char(1) := 'N';
begin
     
     
     
     begin
         select to_date(tpnro,'dd/mm/yyyy') 
           into ld_fecRCC
           from fst098
          where pgcod = 1
            and tpcod = 7647
            and tpcorr = 12;
     exception
            when no_data_found then
                 ld_fecRCC := null;
     end;
     
     
     
     --vinculo conyugue
     begin
         select a.tp1nro1 
           into ln_Rpccyg
           from fst198 a 
          where a.tp1cod = 1 
           and a.tp1cod1 = 10823 
           and Tp1corr1  = 20
           and Tp1corr2  = 2;
     exception
            when no_data_found then
                 ln_Rpccyg := null;
     end;
     
     lc_flgTit := pq_Cr_segmentacion_variable.fn_verificaSdo(ld_fecRCC,
                                                             pn_pai,
                                                             pn_tdo,
                                                             pc_ndo
                                                            );
     
     if ln_Rpccyg is not null then
        begin
              select a.rppais,
                     a.rptdoc,
                     a.rpndoc
                into ln_paiC,
                     ln_tdoC,
                     lc_ndoC
                from fsr002 a
               where a.pepais = pn_pai
                 and a.petdoc = pn_tdo
                 and a.pendoc = pc_ndo
                 and a.rpccyg = ln_Rpccyg
                 and rownum   = 1;
       exception 
                 when no_data_found then
                      ln_paiC :=null;
                      ln_tdoC :=null;
                      lc_ndoC :=null;
       end;
       
       lc_flgCyg := pq_Cr_segmentacion_variable.fn_verificaSdo(ld_fecRCC,
                                                               ln_paiC,
                                                               ln_tdoC,
                                                               lc_ndoC
                                                            );
                                                            
     end if;
     
     pc_flgTit := lc_flgTit;
     pc_flgCyg := lc_flgCyg;

end Sp_cr_saldo3;

Function fn_verificaSdo(ld_fecRCC in date,
                        pn_pai in number,
                        pn_tdo in number,
                        pc_ndo in char) return char is
ln_MesRcc number(4);
ln_i number(5);
lc_tiper char(1);
lc_CodSbs char(10);
ld_fecRccTmp date;
ln_mto number(17,2);
lc_DocSbsTit char(1); 
lc_flg char(1) := 'N';

ln_mtoAnt number(17,2);
begin

     ln_i := 1;
     --Meses a evaluar RCC
     begin
         select a.tp1nro1
           into ln_MesRcc
           from fst198 a
          where a.tp1cod   = 1
            and a.tp1cod1  = 10823
            and a.tp1corr1 = 20
            and a.tp1corr2 = 3;
     exception
            when no_data_found then
                 ln_MesRcc := null;
     end;
     --Guia equivalencia tipo de documento
     begin
          select Trim(to_char(a.tp1corr3)) 
            into lc_DocSbsTit
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11111
             and a.tp1corr1 = 1
             and a.tp1corr2 = 3
             and tp1nro1 = pn_tdo;
     exception
           when no_data_found then
                lc_DocSbsTit := null;
     end;
     --tipo de persona
     begin
         select a.petipo
           into lc_tiper
           from fsd001 a
          where a.pepais =pn_pai
            and a.petdoc =pn_tdo
            and a.pendoc =pc_ndo;
     exception
            when no_data_found then
                 lc_tiper:=null;
     end;
     
     --codigo sbs
     case 
      when lc_tiper = 'F' then
           begin
                select c_CodSbs
                  into lc_CodSbs
                  from cldrcci a
                 where D_FECPRE = ld_fecRCC
                   and C_TDOCID = lc_DocSbsTit
                   and C_DOCIDE = trim(pc_ndo)
                   and rownum = 1;
           exception
                when no_data_found then
                     lc_CodSbs := null;
           end;
    
      when lc_tiper = 'J' then      
           begin
                select c_CodSbs
                  into lc_CodSbs
                  from cldrcci a
                 where D_FECPRE = ld_fecRCC
                   and C_TDOCTR = lc_DocSbsTit
                   and C_DOCTRI = trim(pc_ndo)
                   and rownum = 1;
           exception
                when no_data_found then
                     lc_CodSbs := null;
           end;
             
      else
           begin
                select c_CodSbs
                  into lc_CodSbs
                  from cldrcci a
                 where D_FECPRE = ld_fecRCC
                   and C_DOCIDE = trim(pc_ndo)
                   and rownum = 1;
           exception
                when no_data_found then
                     lc_CodSbs := null;
           end;
                       
           if lc_CodSbs is null then
              begin
                  select c_CodSbs
                    into lc_CodSbs
                    from cldrcci a
                   where D_FECPRE = ld_fecRCC
                     and C_DOCTRI = trim(pc_ndo)
                     and rownum = 1;
             exception
                  when no_data_found then
                       lc_CodSbs := null;
             end;
             
           end if;
  
        
      end case;
      
      --saldo
      
      ld_fecRccTmp := add_months(ld_fecRCC,-(ln_MesRcc));
      while ln_i <= ln_MesRcc+1 loop
        ln_mto := 0;
        begin
        
           select nvl(sum(a.n_salcap),0)
             into ln_mto
             from cldrccs a 
            where a.c_codsbs = lc_CodSbs
              and a.d_fecpre = ld_fecRccTmp
              and C_CODEMP <> '00104'
              and (C_CUENTA like '14_1%'
                  Or C_CUENTA like '14_2%'  
                  Or C_CUENTA like '14_3%' 
                  Or C_CUENTA like '14_4%'  
                  Or C_CUENTA like '14_5%' 
                  Or C_CUENTA like '14_6%' 
                  Or C_CUENTA like '71_1%' 
                  Or C_CUENTA like '71_2%' 
                  Or C_CUENTA like '71_3%' 
                  Or C_CUENTA like '71_4%' 
                  Or C_CUENTA like '81_302%')
              and C_CRETIP not in (select tp1nro1
                                     from fst198 a
                                    Where Tp1cod   = 1
                                      and Tp1cod1  = 20001
                                      and Tp1corr1 = 1
                                      and Tp1corr2 = 1205);
            
        exception
            when others then
                 ln_mto := 0;
        end;
        if ln_i > 1 then
           if ln_mto > ln_mtoAnt then
              lc_flg := 'S';
              exit;
              else
                  lc_flg := 'N';   
           end if;
        end if;
        
        ln_i := ln_i + 1 ;
        ld_fecRccTmp := Add_months(ld_fecRccTmp,1);
        ld_fecRccTmp := last_day(ld_fecRccTmp);
        ln_mtoAnt    := ln_mto;
      end loop;
    
      
      return lc_flg;
      
end fn_verificaSdo;

end pq_cr_Segmentacion_variable;
/

