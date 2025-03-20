create or replace package pq_datos_dwh is

  -- Author  : YLOZADA
  -- Created : 2012.10.17 10:45:20
  -- Purpose : 
  
 function fn_tip_plazo(p_c_numcre IN VARCHAR2) RETURN VARCHAR2 ;
 function fn_tip_garantia(P_C_NUMCRE in varchar2) return varchar2;
 function fn_prod_cast(pn_mod in number,
                                        pn_top in number,
                                        pn_suc in number,
                                        pn_mda in number,
                                        pn_pap in number,
                                        pn_cta in number,
                                        pn_oper in number,
                                        pn_sbop in number, 
                                        pd_fech in date
                                       ) return varchar2;
 function fn_rub_prod(pn_mod in number,
                                        pn_top in number,
                                        pn_suc in number,
                                        pn_mda in number,
                                        pn_pap in number,
                                        pn_cta in number,
                                        pn_oper in number,
                                        pn_sbop in number, 
                                        pd_fech in date
                                       ) return number ;
 function fn_prod_ebs(P_C_RUBRO   number,
                                       P_N_MODULO  number,
                                       P_N_TIPOPER number,
                                       P_N_SUCURS  number,
                                       P_N_MONEDA  number,
                                       P_N_PAPEL   number,
                                       P_N_CUENTA  number,
                                       P_N_OPERAC  number,
                                       P_N_SUBOP   number)return varchar2;                                       
 function fn_rub_prod_tc(pn_mod in number,
                                        pn_top in number,
                                        pn_suc in number,
                                        pn_mda in number,
                                        pn_pap in number,
                                        pn_cta in number,
                                        pn_oper in number,
                                        pn_sbop in number, 
                                        pd_fech in date
                                       ) return number ;
 FUNCTION fn_tip_cre (pn_mod in number,
                     pn_top in number,
                     pn_suc in number,
                     pn_mda in number,
                     pn_pap in number,
                     pn_cta in number,
                     pn_oper in number,
                     pn_sbop in number, 
                     pd_fech in date) RETURN number;

procedure sp_job_inser_FH_MOVPASIVA (p_d_fecpro in varchar2) ;
procedure sp_inser_FH_MOVPASIVA (pn_ctaini in number, pn_ctafin in number, pd_fecpro in varchar2 );                     
procedure sp_inser_jaql123 ;                     
end pq_datos_dwh;
/

create or replace package body pq_datos_dwh is

function fn_tip_plazo(p_c_numcre IN VARCHAR2) RETURN VARCHAR2 IS
  -- ***************************************************************************************
  -- RETORNAR LA CUENTA CONTABLE CORRESPONDIENTE AL PLAZO DE CREDITOS
  -- ***************************************************************************************
 

    lc_tipcre varchar2(1); -- comercial, consumo, mes
    lc_clacon varchar2(1); -- revolvente, no revolvente
    lc_conven char(1); -- es convenio o libre diponibilidad
    lc_codpro char(2);
    lc_tipcon char(1);
    lc_codest char(1);
    lc_codccr char(1);
    lc_lincre char(1);
    lc_tipdes char(1);
    --
   

  begin
    begin
      select cre.bnj096pac,
             cre.bnj096pas,
             cre.bnj096lin,
             cre.bnj096est
        into lc_codpro,
             lc_tipcre,
             lc_clacon,
             lc_codest     
        from bnj096 cre 
       where cre.bnj096sor = p_c_numcre;
                   
      /*select distinct substr(c_codpac, 2, 2),
             c_codpas,
             nvl(lin.c_tipdes,'N') c_tdesli,
             c_codest
        into lc_codpro,
             lc_tipcre,
             lc_clacon,
             lc_codest     
        from crmcred@consulta cre, crtslcr@consulta lin 
                 where cre.c_codfuf = lin.c_codfuf
                   and cre.c_codlfi = lin.c_codlfi
                   and cre.c_codlcr = lin.c_codlcr
                   and cre.c_codsli = lin.c_codsli
                   and cre.c_numcre = p_c_numcre;*/
    exception
      when others then
        lc_codpro := null;
        lc_tipcre := null;
        lc_clacon := null;
        lc_codest := null;
        return('09');
    end;
    
    if nvl(lc_clacon,'N') = 'L' /*or lc_lincre = 'S' or */ then
      return('01');
    end if;
      if lc_tipcre not in ('2','7') and nvl(lc_clacon,'N') = 'N' then
        -- comercial y  mes no revolvente
        return('02');
      end if;
    --> FIN: RES.11356
    if lc_tipcre = '2' then
       begin
          select 'S' 
            into lc_conven
            from bnj096 a 
           where a.bnj096sor = p_c_numcre
             and a.bnj096lcr = '08'
             and a.bnj096pas = '2'
             and a.bnj096ccr <> 'A';
          /*select 'S'
            into lc_conven
            from crmcred@consulta c, crtslcr@consulta cr--, crdreci@migra2 re
           where \*c.c_indpri = 'S'
             and*\ c.c_codccr <> 'A'
             and c.c_codfuf = cr.c_codfuf
             and c.c_codlfi = cr.c_codlfi
             and c.c_codlcr = cr.c_codlcr
             and c.c_codsli = cr.c_codsli
             and c.c_codpas = '2'
             --and cr.c_lincon = 'S'-- consulta
             and c.c_codlcr = '08'
             --and c.c_codper = re.c_codcli
             --and re.c_numcre = c.c_numcre
             and c.c_numcre = p_c_numcre;*/
       exception
          when others then
            lc_conven := 'N';
       end;

        if lc_conven = 'S' then
          --convenio
          --return('04');  2012.03.20 convenio no elegible
          return('05');
        else
              
          return('03'); --libre disponibilidad
        
        end if;
    else
        return('01'); --linea/Revolvente
    end if;
    
    --> FIN: RES.11356
    return('09');
  end fn_tip_plazo;
function fn_tip_garantia(P_C_NUMCRE in varchar2) return varchar2
  -- ***************************************************************************************
  -- RETORNAR LA CUENTA CONTABLE CORRESPONDIENTE AL TIPO DE GARANTIA DE CREDITOS 
  -- ***************************************************************************************
 
  is
    lc_tipgar varchar2(2);
    ln_tipgar number;
  begin
    -- nuevo modulo garantias
    select t_gara.bnj096gar
      into ln_tipgar --lc_tipgar
      from bnj096 t_gara
     where t_gara.bnj096sor = P_C_NUMCRE;
       
    /*select distinct (max(case
                           when upper(t_gara.c_indins) = 'N' then
                            1--'02'
                           when upper(t_gara.c_indins) = 'S' then
                            2--'01'
                           else
                            0--'0'
                         end)) garantia
      into ln_tipgar --lc_tipgar
      from crdptcr@consulta t_gara
     where t_gara.c_numcre = P_C_NUMCRE
       and t_gara.c_estreg = 'S'
       and t_gara.c_estgar = 'A';*/
       
    if ln_tipgar = '2' then    
       lc_tipgar := '01';
    else
       lc_tipgar := '02'; --x mientras 01
    end if;   
    lc_tipgar :=/* nvl(lc_tipgar, '01'); --*/nvl(lc_tipgar, '02'); --x mientras 01
    
    return lc_tipgar;

  exception
    when others then
      return '02';
  end;

 function fn_prod_cast(pn_mod in number,
                                        pn_top in number,
                                        pn_suc in number,
                                        pn_mda in number,
                                        pn_pap in number,
                                        pn_cta in number,
                                        pn_oper in number,
                                        pn_sbop in number, 
                                        pd_fech in date
                                       ) return varchar2 is
-- ****************************************************************
-- Nombre                     : fn_prod_cast
-- Sistema                    : SORFY
-- Modulo                     : Creditos
-- Version                    : 1.0
-- Fecha de Creacion          : 15/06/2003
-- Autor de Creacion          : COMMIT S.A.C.
-- Uso                        : RETORNA LA TASA EFECTIVA ANUAL ( TEA ).
-- Estado                     : Activo
-- Acceso                     : Publico
-- Descripcion de Modificacion:
-- ****************************************************************
ln_rubro number;
ln_mod   number;
ln_tope  number;
ln_suc   number;
ln_mda   number;
ln_pap   number;
ln_cta   number;
ln_oper  number;
ln_sbop  number;
lc_error varchar2(300);
lc_codigo varchar2(20); 
lc_monext varchar2(1);
lc_codest varchar2(1);
lc_cccsbs varchar2(2);
lc_numcre varchar2(17);
lc_moneda  varchar2(1);
lc_codrub  varchar2(13);
lc_tippla  varchar2(2);
begin
  if pn_mod = 33 then 
    begin
       select /*+index(a FSR011_IDX_20) index(b FSH01204)*/b.bcrubr, b.bcmod,b.bctop,b.bcsuc,b.bcmda,b.bcpap, b.bccta,b.bcoper,b.bcsbop
         into ln_rubro, ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
         from fsr011 a, fsh012 b
        where a.RELCOD = 52
          and a.R2MOD   = pn_mod
          and a.R2CTA   = pn_cta
          and a.R2OPER = pn_oper
          and a.R2SBOP = pn_sbop
          and a.R2COD   = 1
          and a.R2SUC   = pn_suc
          and a.R2MDA   = pn_mda
          and a.R2PAP   = pn_pap
          and a.R2TOPE = pn_top
          and b.bcemp = 1
          and b.bcsuc = a.R1SUC
          and b.bcmda = a.R1MDA
          and b.bcpap = a.R1PAP
          and b.bccta = a.R1CTA
          and b.bcoper= a.R1OPER
          and b.bcrubr in (SELECT RUBRO FROM jaql123 /*select rubro from fsd014 
                            where pcimpu ='S' 
                              and pcnivc in ( select modulo from fst111 
                                               where dscod = 50 
                                                 and modulo not in (33,29,144,120))*/)
          and b.bcfech = last_day(add_months(pd_fech,-1));
    exception
      when too_many_rows then 
           begin
               select b.bcrubr, b.bcmod,b.bctop,b.bcsuc,b.bcmda,b.bcpap, b.bccta,b.bcoper,b.bcsbop
                 into ln_rubro, ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
                 from fsr011 a, fsh012 b
                where RELCOD = 52
                  and R2MOD   = pn_mod
                  and R2CTA   = pn_cta
                  and R2OPER = pn_oper
                  and R2SBOP = pn_sbop
                  and R2COD   = 1
                  and R2SUC   = pn_suc
                  and R2MDA   = pn_mda
                  and R2PAP   = pn_pap
                  and R2TOPE = pn_top
                  and b.bcemp = 1
                  and b.bcsuc = R1SUC
                  and b.bcmda = R1MDA
                  and b.bcpap = R1PAP
                  and b.bccta = R1CTA
                  and b.bcoper= R1OPER
                  and b.bcrubr in (SELECT RUBRO FROM jaql123/*select rubro from fsd014 
                                    where pcimpu ='S' 
                                      and pcnivc in ( select modulo from fst111 
                                                       where dscod = 50 
                                                         and modulo not in (33,29,144,120))*/)
                  and b.bcfech = last_day(add_months(pd_fech,-1))
                  and rownum = 1;     
           
           end;
      when no_data_found then
           begin
               select R1MOD,R1TOPE,R1SUC,R1MDA,R1PAP,R1CTA,R1OPER,R1SBOP
                 into ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
                 from fsr011 a
                where RELCOD = 52
                  --and R2MOD   = pn_mod
                  and R2CTA   = pn_cta
                  and R2OPER = pn_oper
                  --and R2SBOP = pn_sbop
                  and R2COD   = 1
                  and R2SUC   = pn_suc
                  and R2MDA   = pn_mda
                  and R2PAP   = pn_pap
                  --and R2TOPE = pn_top
                  and rownum = 1;
               if ln_mda  = 0 then
                  lc_monext := 'N';
               else
                  lc_monext := 'S';
               end if; 
               
               select rubro 
                 into ln_rubro
                 from fsd014 
                where pcimpu = 'S' 
                  and pcnivc = ln_mod
                  and pcmext = lc_monext
                  and rownum = 1;
           exception 
              when others then
                   null;
           end;
      when others then
           null;
    end;
  elsif pn_mod  = 117 then
     begin
         select R1MOD,R1TOPE,R1SUC,R1MDA,R1PAP,R1CTA,R1OPER,R1SBOP
           into ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
           from fsr011 a
          where RELCOD = 46
            and R2MOD  = pn_mod
            and R2CTA  = pn_cta
            and R2OPER = pn_oper
            and R2SBOP = pn_sbop
            and R2COD  = 1
            and R2SUC  = pn_suc
            and R2MDA  = pn_mda
            and R2PAP  = pn_pap
            and R2TOPE = pn_top
            and rownum = 1;
         if ln_mda  = 0 then
            lc_monext := 'N';
         else
            lc_monext := 'S';
         end if; 
               
         select rubro 
           into ln_rubro
           from fsd014 
          where pcimpu = 'S' 
            and pcnivc = ln_mod
            and pcmext = lc_monext
            and pmpzo  = 1
            and rownum = 1;
     exception 
        when others then
             null;
     end;
     
  end if;  
  
  BEGIN
   trans_ebsbt.pq_migra_bt_ebs2.sp_gl_obtieneproducto(ln_rubro,
                                                     ln_mod  ,
                                                     ln_tope ,
                                                     ln_suc  ,
                                                     ln_mda  ,
                                                     ln_pap  ,
                                                     ln_cta  ,
                                                     ln_oper ,
                                                     ln_sbop ,
                                                         ---------
                                                     lc_codigo  ,
                                                     lc_error  ); 
  
    
    if nvl(lc_codigo,'0') = '0' then
    
       begin
        select a.bnj096est, a.bnj096tcr,a.bnj096sor, decode(a.bnj096mda,0,'1','2'),
               a.bnj096moo, a.bnj096too, a.bnj096suc, a.bnj096mda, a.bnj096pap,
               a.bnj096sub, substr(d.rubro,11,3)
          into lc_codest, lc_cccsbs, lc_numcre, lc_moneda, 
               ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_sbop,
               lc_codrub     
          from bnj096 a,  fsd014 d   
         where a.bnj096cta = pn_cta
           and a.bnj096ope = pn_oper
           and d.pcnivc   = a.bnj096moo
           and d.pmgru = to_number(a.bnj096tcr) 
           and pmtit = 1 and pmpzo = 1;
        exception
          when others then 
             null;
             
        end ;
        if lc_cccsbs <> '04' then 
           lc_tippla := fn_tip_plazo(lc_numcre);
           if lc_tippla = '03' and ln_mod in (112,113) then
              lc_tippla := '02';
           elsif lc_tippla = '03' and ln_mod in (110) and ln_tope in (30,40,50,60) then
              lc_tippla := '09';   
           end if; 
        else
           lc_tippla := fn_tip_garantia(lc_numcre);
        end if;
        
        
        case when lc_codest = 'J' then 
             ln_rubro :='14'||lc_moneda||'6'||lc_cccsbs||'06'||lc_tippla||nvl(lc_codrub,'999');
             when lc_codest = 'N' then
             ln_rubro :='14'||lc_moneda||'1'||lc_cccsbs||'06'||lc_tippla||nvl(lc_codrub,'999');
             else 
             ln_rubro :='14'||lc_moneda||'5'||lc_cccsbs||'06'||lc_tippla||nvl(lc_codrub,'999');
--             lc_codigo := '14'||lc_moneda||'5'||lc_cccsbs||'06'||lc_tippla||nvl(lc_codrub,'999');
        end case;     
              
        lc_codigo:= fn_prod_ebs(ln_rubro,ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, 
        pn_cta,pn_oper,ln_sbop);
        -- obtiene producto y sub producto
        --return lc_codpro;
    end if;
    return(lc_codigo);
   end;
end fn_prod_cast;
 function fn_rub_prod(pn_mod in number,
                                        pn_top in number,
                                        pn_suc in number,
                                        pn_mda in number,
                                        pn_pap in number,
                                        pn_cta in number,
                                        pn_oper in number,
                                        pn_sbop in number, 
                                        pd_fech in date
                                       ) return number is
-- ****************************************************************
-- Nombre                     : fn_prod_cast
-- Sistema                    : SORFY
-- Modulo                     : Creditos
-- Version                    : 1.0
-- Fecha de Creacion          : 15/06/2003
-- Autor de Creacion          : COMMIT S.A.C.
-- Uso                        : RETORNA LA TASA EFECTIVA ANUAL ( TEA ).
-- Estado                     : Activo
-- Acceso                     : Publico
-- Descripcion de Modificacion:
-- ****************************************************************
ln_rubro number;
ln_mod   number;
ln_tope  number;
ln_suc   number;
ln_mda   number;
ln_pap   number;
ln_cta   number;
ln_oper  number;
ln_sbop  number;
lc_error varchar2(300);
lc_codigo varchar2(20); 
lc_monext varchar2(1);
begin
  if pn_mod  = 33 then 
    begin
       select /*+index(a FSR011_IDX_20) index(b FSH01204)*/b.bcrubr, b.bcmod,b.bctop,b.bcsuc,b.bcmda,b.bcpap, b.bccta,b.bcoper,b.bcsbop
         into ln_rubro, ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
         from fsr011 a, fsh012 b
        where a.RELCOD = 52
          and a.R2MOD  = pn_mod
          and a.R2CTA  = pn_cta
          and a.R2OPER = pn_oper
          and a.R2SBOP = pn_sbop
          and a.R2COD  = 1
          and a.R2SUC  = pn_suc
          and a.R2MDA  = pn_mda
          and a.R2PAP  = pn_pap
          and a.R2TOPE = pn_top
          and b.bcemp = 1
          and b.bcsuc = a.R1SUC
          and b.bcmda = a.R1MDA
          and b.bcpap = a.R1PAP
          and b.bccta = a.R1CTA
          and b.bcoper= a.R1OPER
          and b.bcrubr in (SELECT RUBRO FROM jaql123/*select rubro from fsd014 
                            where pcimpu ='S' 
                              and pcnivc in ( select modulo from fst111 
                                               where dscod = 50 
                                                 and modulo not in (33,29,144,120))*/)
          and b.bcfech = last_day(add_months(pd_fech,-1));
    exception
      when too_many_rows then 
           begin
               select b.bcrubr, b.bcmod,b.bctop,b.bcsuc,b.bcmda,b.bcpap, b.bccta,b.bcoper,b.bcsbop
                 into ln_rubro, ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
                 from fsr011 a, fsh012 b
                where RELCOD = 52
                  and R2MOD  = pn_mod
                  and R2CTA  = pn_cta
                  and R2OPER = pn_oper
                  and R2SBOP = pn_sbop
                  and R2COD  = 1
                  and R2SUC  = pn_suc
                  and R2MDA  = pn_mda
                  and R2PAP  = pn_pap
                  and R2TOPE = pn_top
                  and b.bcemp = 1
                  and b.bcsuc = R1SUC
                  and b.bcmda = R1MDA
                  and b.bcpap = R1PAP
                  and b.bccta = R1CTA
                  and b.bcoper= R1OPER
                  and b.bcrubr in (SELECT RUBRO FROM jaql123/*select rubro from fsd014 
                                    where pcimpu ='S' 
                                      and pcnivc in ( select modulo from fst111 
                                                       where dscod = 50 
                                                         and modulo not in (33,29,144,120))*/)
                  and b.bcfech = last_day(add_months(pd_fech,-1))
                  and rownum = 1;     
           
           end;
      when no_data_found then
           begin
               select R1MOD,R1TOPE,R1SUC,R1MDA,R1PAP,R1CTA,R1OPER,R1SBOP
                 into ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
                 from fsr011 a
                where RELCOD = 52
                  --and R2MOD  = pn_mod
                  and R2CTA  = pn_cta
                  and R2OPER = pn_oper
                  --and R2SBOP = pn_sbop
                  and R2COD  = 1
                  and R2SUC  = pn_suc
                  and R2MDA  = pn_mda
                  and R2PAP  = pn_pap
                  --and R2TOPE = pn_top
                  and rownum = 1;
               if ln_mda  = 0 then
                  lc_monext := 'N';
               else
                  lc_monext := 'S';
               end if; 
               
               select rubro 
                 into ln_rubro
                 from fsd014 
                where pcimpu = 'S' 
                  and pcnivc = ln_mod
                  and pcmext = lc_monext
                  and rownum = 1;
           exception 
              when others then
                   null;
           end;
      when others then
           null;
    end;
  elsif pn_mod  = 117 then
     begin
         select R1MOD,R1TOPE,R1SUC,R1MDA,R1PAP,R1CTA,R1OPER,R1SBOP
           into ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
           from fsr011 a
          where RELCOD = 46
            and R2MOD  = pn_mod
            and R2CTA  = pn_cta
            and R2OPER = pn_oper
            and R2SBOP = pn_sbop
            and R2COD  = 1
            and R2SUC  = pn_suc
            and R2MDA  = pn_mda
            and R2PAP  = pn_pap
            and R2TOPE = pn_top
            and rownum = 1;
         if ln_mda  = 0 then
            lc_monext := 'N';
         else
            lc_monext := 'S';
         end if; 
               
         select rubro 
           into ln_rubro
           from fsd014
          where pcimpu = 'S' 
            and pcnivc = ln_mod
            and pcmext = lc_monext
            and pmpzo  = 1
            and rownum = 1;
     exception 
        when others then
             null;
     end;
  end if;  
    return(ln_rubro);
  end;

 function fn_prod_ebs(P_C_RUBRO   number,
                                       P_N_MODULO  number,
                                       P_N_TIPOPER number,
                                       P_N_SUCURS  number,
                                       P_N_MONEDA  number,
                                       P_N_PAPEL   number,
                                       P_N_CUENTA  number,
                                       P_N_OPERAC  number,
                                       P_N_SUBOP   number)
    return varchar2  IS
  
    -- ****************************************************************
    -- Nombre                     : FN_AH_MODULO10
    -- Sistema                    : SORFY
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/08/2009
    -- Autor de Creación          : Mersalí Araujo
    -- Uso                        : Módulo 10 para dígitos de chequeo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_C_CODIGO
    --                              P_C_FACTOR
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de Modificación      : 
    -- Descripción de Modificación: 
    -- ************************************************************************    
    lc_codigo varchar2(50);
    lc_error  varchar2(300);
    
  BEGIN
   trans_ebsbt.pq_migra_bt_ebs2.sp_gl_obtieneproducto(P_C_RUBRO   ,
                                                      P_N_MODULO  ,
                                                      P_N_TIPOPER ,
                                                      P_N_SUCURS  ,
                                                      P_N_MONEDA  ,
                                                      P_N_PAPEL   ,
                                                      P_N_CUENTA  ,
                                                      P_N_OPERAC  ,
                                                      P_N_SUBOP   ,
                                                         ---------
                                                      lc_codigo  ,
                                                      lc_error  ); 
  
    return(lc_codigo);
  
  end fn_prod_ebs;

function fn_rub_prod_tc(pn_mod in number,
                                        pn_top in number,
                                        pn_suc in number,
                                        pn_mda in number,
                                        pn_pap in number,
                                        pn_cta in number,
                                        pn_oper in number,
                                        pn_sbop in number, 
                                        pd_fech in date
                                       ) return number is
-- ****************************************************************
-- Nombre                     : fn_prod_cast
-- Sistema                    : SORFY
-- Modulo                     : Creditos
-- Version                    : 1.0
-- Fecha de Creacion          : 15/06/2003
-- Autor de Creacion          : COMMIT S.A.C.
-- Uso                        : RETORNA LA TASA EFECTIVA ANUAL ( TEA ).
-- Estado                     : Activo
-- Acceso                     : Publico
-- Descripcion de Modificacion:
-- ****************************************************************
ln_rubro number;
ln_mod   number;
ln_tope  number;
ln_suc   number;
ln_mda   number;
ln_pap   number;
ln_cta   number;
ln_oper  number;
ln_sbop  number;
lc_error varchar2(300);
lc_codigo varchar2(20); 
lc_monext varchar2(1);
begin
      
    begin
       select /*+index(a FSR011_IDX_20) index(b FSH01204)*/b.bcrubr, b.bcmod,b.bctop,b.bcsuc,b.bcmda,b.bcpap, b.bccta,b.bcoper,b.bcsbop
         into ln_rubro, ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
         from fsr011 a, fsh012 b
        where a.RELCOD = 52
          and a.R2MOD  = pn_mod
          and a.R2CTA  = pn_cta
          and a.R2OPER = pn_oper
          and a.R2SBOP = pn_sbop
          and a.R2COD  = 1
          and a.R2SUC  = pn_suc
          and a.R2MDA  = pn_mda
          and a.R2PAP  = pn_pap
          and a.R2TOPE = pn_top
          and b.bcemp = 1
          and b.bcsuc = R1SUC
          and b.bcmda = R1MDA
          and b.bcpap = R1PAP
          and b.bccta = R1CTA
          and b.bcoper= R1OPER
          and b.bcrubr in (SELECT RUBRO FROM jaql123/*SELECT \*+parallel(FSD014,2)*\ RUBRO 
                             FROM FSD014 
                            WHERE PCIMPU = 'S' 
                              AND EXISTS (SELECT 1 
                                            FROM FST111 
                                           WHERE DSCOD = 50 
                                             AND MODULO NOT IN (33, 29, 144, 120) 
                                             AND MODULO = FSD014.PCNIVC)*/) 
                                      /*(select rubro from fsd014 
                            where pcimpu ='S' 
                              and pcnivc in ( select modulo from fst111 
                                               where dscod = 50 
                                                 and modulo not in (33,29,144,120)))*/
                                                 
          and b.bcfech = last_day(add_months(pd_fech,-1));
    exception
      when too_many_rows then 
           begin
               select b.bcrubr, b.bcmod,b.bctop,b.bcsuc,b.bcmda,b.bcpap, b.bccta,b.bcoper,b.bcsbop
                 into ln_rubro, ln_mod, ln_tope, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop
                 from fsr011 a, fsh012 b
                where RELCOD = 52
                  and R2MOD  = pn_mod
                  and R2CTA  = pn_cta
                  and R2OPER = pn_oper
                  and R2SBOP = pn_sbop
                  and R2COD  = 1
                  and R2SUC  = pn_suc
                  and R2MDA  = pn_mda
                  and R2PAP  = pn_pap
                  and R2TOPE = pn_top
                  and b.bcemp = 1
                  and b.bcsuc = R1SUC
                  and b.bcmda = R1MDA
                  and b.bcpap = R1PAP
                  and b.bccta = R1CTA
                  and b.bcoper= R1OPER
                  and b.bcrubr in (SELECT RUBRO FROM jaql123/*SELECT \*+parallel(FSD014,2)*\ RUBRO 
                                     FROM FSD014 
                                    WHERE PCIMPU = 'S' 
                                      AND EXISTS (SELECT 1 
                                                   FROM FST111 
                                                  WHERE DSCOD = 50 
                                                    AND MODULO NOT IN (33, 29, 144, 120) 
                                                    AND MODULO = FSD014.PCNIVC)*/) 
                                      /*(select rubro from fsd014 
                                    where pcimpu ='S' 
                                      and pcnivc in ( select modulo from fst111 
                                                       where dscod = 50 
                                                         and modulo not in (33,29,144,120)))*/
                  and b.bcfech = last_day(add_months(pd_fech,-1))
                  and rownum = 1;     
           
           end;
      when no_data_found then 
           if pn_mod in (33,65) then
              begin 
              select hrubro
                into ln_rubro
                from fsh016
               where pgcod = 1
                 and hfcon = pd_fech
                 and hcmod = 98
                 and htran = 310
                 and hcta  = pn_cta
                 and hoper = pn_oper
                 and hcodmo = 2;
               exception 
                 when no_data_found then
                    begin 
                      select hrubro
                        into ln_rubro
                        from fsh016
                       where pgcod = 1
                         and hcmod = 98
                         and htran = 310
                         and hcta  = pn_cta
                         and hoper = pn_oper
                         and hcodmo = 2
                         and hrubro like '14%' ;
                       exception 
                         when others then null;
                     end;     
                 
                 when others then null;
               end;    
           end if;
      when others then
           null;
    end;
  
    return(ln_rubro);
  end;

FUNCTION fn_tip_cre (pn_mod in number,
                     pn_top in number,
                     pn_suc in number,
                     pn_mda in number,
                     pn_pap in number,
                     pn_cta in number,
                     pn_oper in number,
                     pn_sbop in number, 
                     pd_fech in date) RETURN number IS
  
  ln_tipcre NUMBER;
  ln_rubro number;
begin  
        ln_rubro :=  pq_datos_dwh.fn_rub_prod_tc(pn_mod,
                                        pn_top,
                                        pn_suc,
                                        pn_mda,
                                        pn_pap,
                                        pn_cta,
                                        pn_oper,
                                        pn_sbop, 
                                        pd_fech);
       
            if ln_rubro is null then 
                BEGIN
                 /*select c.c_cccsbs
                    into ln_tipcre        
                    from bnj096 a, crmcred@consulta b, crteqtc@consulta c   
                   where a.bnj096cta = pn_cta
                     and a.bnj096ope = pn_oper
--                     and a.c_indpri = 'S'
                     and a.bnj096sor = b.c_numcre
                     and b.c_codpas = c.c_codpas;*/
                     
                  select to_number(a.bnj096tcr)
                    into ln_tipcre        
                    from bnj096 a   
                   where a.bnj096cta = pn_cta
                     and a.bnj096ope = pn_oper;   
                  exception
                    when others then 
                       --null;
                       begin 
                            -- Venta de cartera
                            select pmgru
                              into ln_tipcre
                              from jaqy953 a, fsd014
                             where JAQY953CTA = pn_cta
                               and JAQY953OPE = pn_oper
                               and JAQY953RUB = rubro;
                        end;  
                  end ; 
            else
               begin 
                 select pmgru 
                   into  ln_tipcre
                   from fsd014 where rubro = ln_rubro;
               exception 
                 when others then 
                   ln_tipcre:=0;
               end;      
            end if;      
  
    RETURN ln_tipcre;
  
  END;
  procedure sp_job_inser_FH_MOVPASIVA (p_d_fecpro in varchar2) is
  lc_msgerr varchar2(200);
  --P_D_FECPRO date;
  p_n_tipcam number;
  ln_max number;
  ln_rango number;
  x number;
  ln_ini number;
  ln_fin number;
  lc_variable varchar2(1000);
  ln_job number;
  lc_fecpro varchar2(20);
  NUM_JOB_PENDIENTES NUMBER;
  lc_existe varchar2(1);
  
  begin 
     --p_d_fecpro := PQ_TMP_EXTRAE_FUENTES.fn_lee_fecha_cierre;
     lc_fecpro := p_d_fecpro; --to_char(p_d_fecpro,'yyyymmdd');
     begin 
         execute immediate('truncate table FH_MOVPASIVA'); 
         begin 
             select max(ctnro),trunc(max(ctnro)/300)   
               into ln_max,ln_rango
               from fsd008
              where ctnro <> 999999999;
         exception 
               when no_data_found then
                    ln_max := 0;
                    ln_rango:=0;
         end;          
         x:=0;
         ln_job := 0;
         while x <= ln_max loop
              ln_ini := x+1;
              x:= x+ ln_rango;
              ln_fin := x;
              lc_variable := ' begin '||'  PQ_datos_dwh.sp_inser_FH_MOVPASIVA('||ln_ini||','||ln_fin ||',' || lc_fecpro || ');'|| ' End; ';
              ln_job := ln_job +1;
                 
               /*dbms_scheduler.create_job(
                 job_name=> 'TAB_FSH016'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lc_variable,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'TAB_FSH016'
                 );*/
                 DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
--                      instance => 2,
                      instance => 1,
                      force => false
                      );
              INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
              VALUES('FH16',ln_ini,lc_variable);
              COMMIT;
          
          end loop;
      end;       
    end;  
    
   ----------------
   procedure sp_inser_FH_MOVPASIVA (pn_ctaini in number, pn_ctafin in number, pd_fecpro in varchar2 ) is
   
   lc_msgerr VARCHAR2(200);
   ld_fecpro date;
   ln_sucurs number;
   ln_moneda number;
   cursor agencia is
   select sucurs from fst001 where pgcod = 1;
   cursor monedas is
   select moneda from fst005 where moneda in (0,101);
   
   begin
     
   execute immediate 'alter session set "_optimizer_batch_table_access_by_rowid" =false';
      update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = pn_ctaini
         and g.c_codage = 'FH16';
      commit; 
      ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
      ln_sucurs := 0;
      for i in agencia loop
         ln_sucurs := i.sucurs;
         ln_moneda := 0;
         for j in monedas loop
           ln_moneda := j.moneda;  --hint index 2023.03.17
           execute immediate 'INSERT  INTO   FH_MOVPASIVA (HSUCOR,HFVC,HCMOD,HTRAN,HNREL,
                                                                HCIMP1,PGCOD,HSUCUR,HMODUL,HMDA,
                                                                HPAP,HCTA,HOPER,HSUBOP,HTOPER)
                           select /*+index (e fsh01612)*/
                                  e.hsucor, g.hfvc, e.hcmod, e.htran, e.hnrel, e.Hcimp1, e.Pgcod, e.Hsucur, e.Hmodul,e.Hmda,
                                  e.Hpap,e.Hcta,e.Hoper,e.Hsubop,e.Htoper
                            from fsh016 e, fsh015 g, fst198 h
                           where e.pgcod = g.pgcod
                             and e.hsucor = g.hsucor
                             and e.hcmod = g.hcmod
                             and e.htran = g.htran
                             and e.hnrel = g.hnrel
                             and e.hfvco = g.hfvc
                             and g.hccorr <> 99
                             and h.tp1cod = e.Pgcod
                             and h.Tp1cod1 = 10820
                             and h.Tp1corr1 = 4
                             and e.Pgcod = 1
                             and e.Hsucur = :ln_sucurs
                             and e.Hmodul in (21,22)
                             and e.Hpap = 0
                             and e.hmda = :ln_moneda
                             and e.Hcta between :pn_ctaini and :pn_ctafin
                             and e.Hcmod = h.tp1nro1
                             and e.Htran = h.tp1nro2
                             and  e.hrubro in (select rubro from fsd014 where pcimpu =''S'' and pcnivc in (21,22,122)GROUP BY rubro)
                             and e.Hfvco = ( select max(Hfvco) from fsh016 x 
                                              where x.pgcod = e.Pgcod 
                                                and x.Hsucur  = e.Hsucur 
                                                and x.Hmodul = e.Hmodul 
                                                and x.Hmda = e.Hmda 
                                                and x.Hpap = e.Hpap 
                                                and x.Hcta = e.Hcta 
                                                and x.Hoper = e.Hoper 
                                                and x.Hsubop = e.Hsubop 
                                                and x.Htoper = e.Htoper
                                                and x.Hfvco <= :ld_fecpro) '
                using  ln_sucurs,ln_moneda,pn_ctaini,pn_ctafin,ld_fecpro;
                commit; 
           end loop; 
        end loop; 
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_ctaini
       and g.c_codage = 'FH16';
    commit;       
   exception
      when others then
           lc_msgerr:= sqlerrm;  
           insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
           values (1,'FH_MOVPASIVA','Insert '||lc_msgerr, TRUNC(SYSDATE)); 
           COMMIT;  
   end;  
procedure sp_inser_jaql123 is
   lc_msgerr VARCHAR2(200);
   begin
      execute immediate('truncate table JAQL123');    
      execute immediate 'INSERT  INTO   jaql123 (rubro)
                         select rubro from fsd014 
                            where pcimpu =''S'' 
                              and pcnivc in ( select modulo from fst111 
                                               where dscod = 50 
                                                 and modulo not in (33,29,144,120))';
       commit; 
              
   exception
      when others then
           lc_msgerr:= sqlerrm;  
           insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
           values (1,'JAQL123','Insert '||lc_msgerr, TRUNC(SYSDATE)); 
           COMMIT;  
   end;    
  
end pq_datos_dwh;
/

