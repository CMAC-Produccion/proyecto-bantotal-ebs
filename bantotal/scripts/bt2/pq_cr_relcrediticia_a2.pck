create or replace package PQ_CR_RELCREDITICIA_A2 is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_RELCREDITICIA_A2 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 29/04/2022
  -- Autor de Creación          : YYAMPI
  -- Uso                        : Paquete de procedimientos y funciones, para el calculo de relacion crediticia en dias
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   :  
  -- Descripción de Modificación: 
  -- *****************************************************************
  Procedure Sp_carga_data(pd_fecpro in date) ;
  Function Fn_DiaPago(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                    pn_top in number,pn_est in number,pd_fec in date) return date;
Function Fn_hipotecario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                    pn_top in number,ln_instancia number) return character;                    
  Procedure Sp_cr_Inserta (pd_fecpro in date);
  Function fn_inserta(pn_pai in number,pn_tdo in number,pc_ndo in char,pn_anio in number,pn_mes in number)return number ;
  Procedure Sp_cr_historial (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                             pd_fecpro in date,
                          ln_contador out number,
                          ln_aostat out number,ln_emp out number,ln_mod out number,ln_suc out number,
                          ln_mda out number,ln_pap out number,ln_cta out number,ln_ope out number,
                          ln_sbo out number,ln_top out number,ld_feccan out date);
Procedure Sp_cr_ReCalcula(pn_pais in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                          ln_contador out number);
Procedure Sp_cr_InsNuevo (pn_pais in number,pn_tdo in number,pc_ndo in char,
                          pd_fecpro in date,pd_fecini in date,ln_contador out number) ;                                                    
Procedure Sp_cr_histNuevo (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                           pd_fecpro in date,
                          ln_contador out number);   
Procedure Sp_carga_data_MENSUAL(pd_fecpro in date);
Procedure Sp_cr_Inserta_MENSUAL (pd_fecpro in date);                       
procedure sp_cr_relacioncre2017_job(P_D_FECPRO IN DATE);
procedure sp_cr_relacioncre2017( digito varchar2);
/*procedure sp_cr_relcre2017_job_mensual(P_D_FECPRO IN DATE);*/
 end PQ_CR_RELCREDITICIA_A2;
/

create or replace package body PQ_CR_RELCREDITICIA_A2 is
Procedure Sp_carga_data(pd_fecpro in date) is
  ld_fecini date;
  ln_vig number(9);
begin

      begin
          select tp1nro1
            into ln_vig
            from fst198
           where tp1cod = 1
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 1;
      exception
             when others then ln_vig := 60;--cambiar en produccion

      end;

      ld_fecini:=add_months(pd_fecpro,-ln_vig);
      execute immediate ('truncate table jaqz739');
      execute immediate ('truncate table jaqz740');
     --- execute immediate ('truncate table jaqz734');
      begin

          insert into jaqz739 (jaqz739PGCOD,jaqz739AOMOD,jaqz739AOSUC,jaqz739AOMDA,
          jaqz739AOPAP,jaqz739AOCTA,jaqz739AOOPER,jaqz739AOSBOP,jaqz739AOTOPE,jaqz739AOFVAL,
                                   jaqz739AOFVTO,jaqz739AOFE99,jaqz739AOSTAT,jaqz739flag,
                                   jaqz739hipo,jaqz739INSTANCIA)
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
                           PQ_CR_RELCREDITICIA_A2.Fn_DiaPago(PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,a.aofe99),
                           --a.aofe99,
                           a.aostat,
                           (case when aofe99 = to_date('0001.01.01','yyyy.mm.dd') and aostat = 99 and aofval <ld_fecini then 'N'
                                else 'S'
                           end),
                           /*Case
                              when aomod = 110 and aotope not in (30,31,40) then 'N'
                              else 'S'
                           end*/
                           ' ',
                           --PQ_CR_RELCREDITICIA_A2.Fn_hipotecario(PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE)
                           NVL(fn_instancia_credito(   PGCOD ,
                                                   AOSUC ,
                                                   AOMDA ,
                                                   AOPAP ,
                                                   AOCTA ,
                                                   AOOPER,
                                                   AOSBOP,
                                                   AOTOPE),0)
                      from fsd010 a
	                     where  (aomod in (select modulo from fst111 where dscod = 50 and modulo not in (select fst098.tpnro from fst098 where fst098.tpcod=7722 and fst098.tpimp=1)))
                       and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                       and aotope <> 550 and aocta<>999999999;
              commit;


      end;
     /* begin
       PQ_CR_RELCREDITICIA_A2.sp_cr_relacioncre2017_job(pd_fecpro);
      end;*/


      commit;

      --PQ_CR_RELCREDITICIA_A2.Sp_cr_Inserta(pd_fecpro,ld_fecini);
end Sp_carga_data;
--------------------------------------------------------------------------------------------
Function Fn_hipotecario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                    pn_top in number,ln_instancia number/*,pn_est in number,pd_fec in date*/) return character is
--ln_instancia number;
flag character;
begin
flag:='S';
       
       begin                                                                                               
       select 'N' into flag from wfattsvalues where  wfattsvalues.wfinsprcid=ln_instancia  AND substr(wfattsvalues.wfattsval,0,2)='4;';
       exception
                     when others then null;
                          begin
                              select 'N' INTO flag from fsd011 where fsd011.pgcod=pn_emp and 
                              fsd011.scsuc=pn_suc and fsd011.scmda=pn_mda and fsd011.scpap=pn_pap and 
                              fsd011.sccta=pn_cta and fsd011.scoper=pn_ope and fsd011.scsbop=pn_sbo and 
                              fsd011.sctope=pn_top and fsd011.scmod=pn_mod
                              AND substr(fsd011.scrub,5,2)='04' and rownum=1; --CONSULTAR
                              exception
                              when others then null;
                                   begin
                                     IF pn_mod = 110 and pn_top not in (30,31,40) 
                                               then
                                                 
                                                  flag:='N';
                                              else
                                                 flag:='S';-- CONSULTAR
                                     End IF;
                                   end;
                          END;
        end;
       return flag;
      --return ld_fecpag;
end Fn_hipotecario;
-------------------------------------------------------------------------------------------
Function Fn_DiaPago(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                    pn_top in number,pn_est in number,pd_fec in date) return date is
ld_fecpag date;

begin

       begin
          if pn_est = 99 then
             if pd_fec = to_date('01.01.0001','dd.mm.yyyy') or pd_fec is null then
                begin

                          Select max(pp1fech)
                            into ld_fecpag
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
                             and (a.pp1cap+a.pp1int)<>0
                             and a.pp1stat = 'T';
                     exception
                             when no_data_found then
                                  ld_fecpag := to_date('01.01.0001','dd.mm.yyyy');

                     end;
                     else
                         ld_fecpag := pd_fec;
               end if;

               else
                   ld_fecpag := to_date('01.01.0001','dd.mm.yyyy');
          end if;
          /*
          if pn_est = 0 then
             ld_fecpag := to_date('01.01.0001','dd.mm.yyyy');
             else
                  if pd_fec = to_date('01.01.0001','dd.mm.yyyy') or  then
                     begin

                          Select max(pp1fech)
                            into ld_fecpag
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
                             and a.pp1stat = 'T';
                     exception
                             when no_data_found then
                                  ld_fecpag := to_date('01.01.0001','dd.mm.yyyy');

                     end;
                     else
                         ld_fecpag := pd_fec;
                  end if;
          end if;*/
       end;
       return ld_fecpag;
end Fn_DiaPago;
       Procedure Sp_cr_Inserta (pd_fecpro in date) is

cursor creditos is
select * from jaqz740 a;
ln_contador number(5);
ln_ins number(1);
ln_anio number(4);
ln_mes number(2);
ln_inserta char(1);
ld_feccan date;
ln_estado number(2);
ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);

ld_fecini date;
ln_vig number(9);
ld_fec date;
LN_AUX NUMBER(9);
pd_fecini date;
begin
   begin
          select tp1nro1
            into ln_vig
            from fst198
           where tp1cod = 1
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 1;
      exception
             when others then ln_vig := 60;--cambiar en produccion

      end;
 ld_fecini:=add_months(pd_fecpro,-ln_vig);  

     begin

          insert into jaqz740 (jaqz740PGCOD,jaqz740AOMOD,jaqz740AOSUC,jaqz740AOMDA,jaqz740AOPAP,jaqz740AOCTA,
          jaqz740AOOPER,jaqz740AOSBOP,jaqz740AOTOPE,jaqz740AOFVAL,
                                   jaqz740AOFVTO,jaqz740AOFE99,jaqz740AOSTAT,jaqz740PEPAIS,jaqz740PETDOC,jaqz740PENDOC)

                      select a.jaqz739pgcod,
                             a.jaqz739aomod,
                             a.jaqz739aosuc,
                             a.jaqz739aomda,
                             a.jaqz739aopap,
                             a.jaqz739aocta,
                             a.jaqz739aooper,
                             a.jaqz739aosbop,
                             a.jaqz739aotope,
                             a.jaqz739aofval,
                             a.jaqz739aofvto,
                             a.jaqz739aofe99,
                             a.jaqz739aostat,
                             b.pepais,
                             b.petdoc,
                             b.pendoc
                        from jaqz739 a,
                             fsr008 b
                       where b.ctnro = a.jaqz739aocta
                         and b.cttfir = 'T'
                         AND A.JAQZ739FLAG = 'S'
                         and a.jaqz739hipo = 'S';


          commit;

      end;
      Begin

         ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
         ln_mes := to_number(to_char(pd_fecpro,'mm'));
       --  pd_fecini:=ld_fecini;
         pd_fecini := to_date(to_char(ld_fecini,'yyyymm')||'01','yyyymmdd')   ;
         for i in creditos loop
             ln_contador := null;
             ln_inserta  := NULL;
             ln_ins := PQ_CR_RELCREDITICIA_A2.fn_inserta(i.jaqz740pepais,i.jaqz740petdoc,i.jaqz740pendoc,ln_anio,ln_mes);

             if ln_ins = 0 then
                --pq_cr_relcrediticia.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
                --                                     ld_feccan);
                --if ln_inserta = 'S' then
                    PQ_CR_RELCREDITICIA_A2.Sp_cr_historial(i.jaqz740pepais,i.jaqz740petdoc,i.jaqz740pendoc,pd_fecini,pd_fecpro,
                                                        ln_contador,
                                                        ln_estado,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,
                                                        ln_cta,ln_ope,ln_sbo,ln_top,ld_fec);

                    insert into jaqz734(jaqz734PAI,jaqz734TDO,jaqz734NDO,jaqz734ANI,jaqz734MES,
                                        jaqz734FEP,jaqz734his,jaqz734FCN,jaqz734est,jaqz734pgc,
                                        jaqz734mod,jaqz734suc,jaqz734mda,jaqz734pap,jaqz734cta,
                                        jaqz734ope,jaqz734sbo,jaqz734top,jaqz734FEC)

                    values(i.jaqz740pepais,i.jaqz740petdoc,i.jaqz740pendoc,ln_anio,ln_mes,pd_fecpro,ln_contador,ld_feccan,
                           ln_estado,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,
                                                        ln_cta,ln_ope,ln_sbo,ln_top,ld_fec);



                    commit;


                --end if;

             end if;
             commit;

         end loop;

          LN_AUX :=to_number(to_char(pd_fecpro,'ddmmyyyy'));
                    UPDATE FST198 set tp1nro1 = LN_AUX---ojito
                    where tp1cod1 = 11108--10823
                      and tp1corr1 = 1--8
                      and tp1corr2 = 1;--1;
                      commit;

         commit;
      end;


end Sp_cr_Inserta;
    Function fn_inserta(pn_pai in number,pn_tdo in number,pc_ndo in char,pn_anio in number,pn_mes in number)return number is
ln_existe number(1);

begin

         begin
              select 1
                into ln_existe
                from jaqz734 a
               where a.jaqz734pai = pn_pai
                 and a.jaqz734tdo = pn_tdo
                 and a.jaqz734ndo = pc_ndo
                 and a.jaqz734ani = pn_anio
                 and a.jaqz734mes = pn_mes;

         exception
                 when others then
                      ln_existe := 0;
         end;

         if ln_existe is null then
            ln_existe := 0;
         end if;
         return ln_existe;
end fn_inserta;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
Procedure Sp_cr_historial (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                           pd_fecpro in date,
                          ln_contador out number,
                          ln_aostat out number,ln_emp out number,ln_mod out number,ln_suc out number,
                          ln_mda out number,ln_pap out number,ln_cta out number,ln_ope out number,
                          ln_sbo out number,ln_top out number,ld_feccan out date) is

cursor creditos is
 select *
   from jaqz740 a
  where a.jaqz740pepais= pn_pai
    and a.jaqz740petdoc = pn_tdo
    and a.jaqz740pendoc = pc_ndo
order by jaqz740aofval;

cursor creditos_i is
 select *
   from jaqz740 a
  where a.jaqz740pepais = pn_pai
    and a.jaqz740petdoc = pn_tdo
    and a.jaqz740pendoc = pc_ndo
order by jaqz740aostat,jaqz740aofe99 desc;

--ln_contador number(5);
ld_fecantD date;
ld_fecantC date;
--ln_aux number(4);
ln_mesac number(2);
ln_aniac number(4);
ln_mesan number(2);
ln_anian number(4);
ln_suma number(5);

ld_aofval date;
ld_aofe99 date;
--ld_dia number(2);

ld_sysdate date;

ln_sw number(1);
begin

   begin
    ln_contador := 0;
    ld_fecantD := null;
    ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    ld_sysdate := last_day(pd_fecpro );
    For i in creditos loop
      ln_sw := 0;
      if (i.jaqz740aofe99 is null or i.jaqz740aofe99 = to_date('0001.01.01','yyyy.mm.dd'))and i.jaqz740aostat = 99 then
         ln_sw := 1;
      end if;
      if ln_sw = 0 then

        ln_mesac := to_number(to_char(i.jaqz740aofval,'mm'));
        ln_aniac := to_number(to_char(i.jaqz740aofval,'yyyy'));
        ln_suma := null;
        ld_aofval := i.jaqz740aofval;
        ld_aofe99 := last_day(i.jaqz740aofe99);

        if ld_aofval < pd_fecini then
           ld_aofval := pd_fecini;
        end if;

        if ld_fecantD is null then
              if i.jaqz740aostat = 99 then
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
                     if i.jaqz740aostat= 99 then
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
                             if i.jaqz740aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                   if ln_suma <0 then
                                      ln_suma := 0;
                                   end if;
                                   /*if ln_aux > ln_suma then
                                      ln_suma := 0;
                                      ln_aux  := 0;
                                   end if;*/
                                  ln_contador := ln_contador + ln_suma;-- - ln_aux;

                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval));
                                     if ln_suma <0 then
                                        ln_suma := 0;
                                     end if;
                                     /*if ln_aux > ln_suma then
                                        ln_suma := 0;
                                        ln_aux  := 0;
                                     end if; */
                                    ln_contador := ln_contador + ln_suma;-- - ln_aux;
                              end if;



                          end if;

                          if ld_aofval > ld_fecantC then

                             if i.jaqz740aostat = 99 then
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

        if i.jaqz740aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
           if ld_fecantC > i.jaqz740aofval then
              ld_aofval := ld_fecantC;
           end if;
           ld_fecantC := pd_fecpro;-- trunc(sysdate);
        end if;

        if i.jaqz740aofe99 > ld_fecantC then
                    --ld_fecantD := ld_aofval;
                     ld_fecantC := i.jaqz740aofe99;

        end if;
        ld_fecantD := ld_aofval;




        ln_mesan := to_number(to_char(ld_fecantC,'mm'));
        ln_anian := to_number(to_char(ld_fecantC,'yyyy'));

      end if;
    end loop;


    For j in creditos_i loop

       ln_emp := j.jaqz740pgcod;
       ln_mod := j.jaqz740aomod;
       ln_suc := j.jaqz740aosuc;
       ln_mda := j.jaqz740aomda;
       ln_pap := j.jaqz740aopap;
       ln_cta := j.jaqz740aocta;
       ln_ope := j.jaqz740aooper;
       ln_sbo := j.jaqz740aosbop;
       ln_top := j.jaqz740aotope;
       ln_aostat := j.jaqz740aostat;
       ld_feccan := j.jaqz740aofe99;
       exit;
    end loop;
   end;

end Sp_cr_historial;


Procedure Sp_cr_ReCalcula(pn_pais in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                          ln_contador out number) is
ld_fecini date;
ln_vig number(9);
begin
     begin
          select tp1nro1 
            into ln_vig
            from fst198 
           where tp1cod = 1 
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 1;
      exception
             when others then ln_vig := 60;
      
      end;


     ld_fecini :=add_months(pd_fecpro,-ln_vig);    
     delete from  jaqz735 a where a.JAQZ735pepais = pn_pais and a.JAQZ735petdoc = pn_tdo and a.JAQZ735pendoc = pc_ndo;
     commit;
     --execute immediate('truncate table jaqz735');
     begin
     
      insert into jaqz735(JAQZ735PGCOD,JAQZ735AOMOD,JAQZ735AOSUC,JAQZ735AOMDA,JAQZ735AOPAP,JAQZ735AOCTA,
      JAQZ735AOOPER,JAQZ735AOSBOP,JAQZ735AOTOPE,JAQZ735AOFVAL,JAQZ735AOFVTO,JAQZ735AOFE99,JAQZ735AOSTAT,JAQZ735PEPAIS,JAQZ735PETDOC,JAQZ735PENDOC) 
          select pgcod,
                 aomod,
                 aosuc,
                 aomda,
                 aopap,
                 aocta,
                 aooper,
                 aosbop,
                 aotope,
                 aofval,
                 aofvto,
                 aofe99,
                 aostat, 
                 pepais,
                 petdoc,
                 pendoc
           from (
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
                 PQ_CR_RELCREDITICIA_A2.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,a.aofe99)aofe99,
                 a.aostat, 
                 b.pepais,
                 b.petdoc,
                 b.pendoc,
                 (case when aofe99 = to_date('0001.01.01','yyyy.mm.dd') and aostat = 99 and aofval <ld_fecini then 'N'
                                else 'S'
                  end) flag,
                 /* Case 
                      when aomod = 110 and aotope not in (30,31,40) then 'N'
                      else 'S'
                  PQ_CR_RELCREDITICIA_A2.Fn_hipotecario(PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE)                        
                   end*/ 
                    PQ_CR_RELCREDITICIA_A2.Fn_hipotecario(a.PGCOD,a.AOMOD,a.AOSUC,a.AOMDA,a.AOPAP,a.AOCTA,a.AOOPER,a.AOSBOP,a.AOTOPE,NVL(fn_instancia_credito( a.PGCOD ,
                                                   a.AOSUC ,
                                                   a.AOMDA ,
                                                   a.AOPAP ,
                                                   a.AOCTA ,
                                                   a.AOOPER,
                                                   a.AOSBOP,
                                                   a.AOTOPE),0)) hipo
            from fsr008 b, fsd010 a
           where b.pgcod = 1
             and b.pepais = pn_pais
             and b.petdoc = pn_tdo
             and b.pendoc = pc_ndo
             and b.cttfir = 'T'
             and a.pgcod = b.pgcod
             and a.aocta = b.ctnro
             and aomod in (select modulo from fst111 where dscod = 50 and modulo not in (select fst098.tpnro from fst098 where fst098.tpcod=7722 and fst098.tpimp=1)) 
              and a.aostat<>550    
             and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd')))
            where flag = 'S' 
             and hipo = 'S';
             
             commit;
     
     end;

     PQ_CR_RELCREDITICIA_A2.Sp_cr_InsNuevo(pn_pais,pn_tdo,pc_ndo,pd_fecpro,ld_fecini,ln_contador);
     
     
                                                 
end Sp_cr_ReCalcula;
Procedure Sp_cr_InsNuevo (pn_pais in number,pn_tdo in number,pc_ndo in char,
                          pd_fecpro in date,pd_fecini in date,ln_contador out number) is

cursor creditos is
select * from jaqz735 a
where a.JAQZ735pepais = pn_pais
  and a.JAQZ735petdoc = pn_tdo
  and a.JAQZ735pendoc = pc_ndo;

--ln_ins number(1);
--ln_anio number(4);
--ln_mes number(2);
begin

      Begin
            
         --ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
         --ln_mes := to_number(to_char(pd_fecpro,'mm'));
            
         for i in creditos loop
             ln_contador := null;
             PQ_CR_RELCREDITICIA_A2.Sp_cr_histNuevo(i.jaqz735pepais,i.JAQZ735petdoc,i.JAQZ735pendoc,pd_fecini,pd_fecpro,
                                                 ln_contador);
       
         end loop;
         commit;
      end;


end Sp_cr_InsNuevo;

Procedure Sp_cr_histNuevo (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                           pd_fecpro in date,
                          ln_contador out number) is


cursor creditos is
 select *
   from jaqz735 a
  where a.JAQZ735pepais = pn_pai
    and a.JAQZ735petdoc = pn_tdo
    and a.JAQZ735pendoc = pc_ndo
order by a.JAQZ735aofval;

--ln_contador number(5);    
ld_fecantD date;
ld_fecantC date;
--ln_aux number(4);
ln_mesac number(2);
ln_aniac number(4);
ln_mesan number(2);
ln_anian number(4);
ln_suma number(5);

ld_aofval date;
ld_aofe99 date;
--ld_dia number(2);

ln_sw number(1);
ld_sysdate date;
begin
   
   begin
    ln_contador := 0;  
    ld_fecantD := null;
    ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    ld_sysdate := pd_fecpro; --last_day(pd_fecpro );
    For i in creditos loop
      ln_sw := 0;
      if i.jaqz735aofe99 is null and i.JAQZ735aostat = 99 then
         ln_sw := 1;
      end if;
      if ln_sw = 0 then
      
        ln_mesac := to_number(to_char(i.JAQZ735aofval,'mm'));
        ln_aniac := to_number(to_char(i.JAQZ735aofval,'yyyy'));
        ln_suma := null;
        ld_aofval := i.JAQZ735aofval;
        ld_aofe99 := i.JAQZ735aofe99; --last_day(i.JAQZ735aofe99);
        
        if ld_aofval < pd_fecini then
           ld_aofval := pd_fecini;
        end if;
        
        if ld_fecantD is null then
              if i.JAQZ735aostat = 99 then
                 --ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                 ln_suma := ld_aofe99 - ld_aofval;
                 if ln_suma <0 then 
                    ln_suma := 0;
                 end if;
                 ln_contador := ln_contador + ln_suma;
                 else 
                     --ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                     ln_suma := ld_sysdate - ld_aofval;
                     if ln_suma <0 then 
                        ln_suma := 0;
                     end if;
                     ln_contador := ln_contador + ln_suma;
                 
              end if;
              
              Else
                   
                  if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                     if i.JAQZ735aostat = 99 then
                          --ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                           ln_suma := ld_aofe99 - ld_aofval;
                           if ln_suma <0 then 
                              ln_suma := 0;
                           end if;       
                          ln_contador := ln_contador + ln_suma;
                          
                          else
                            --ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                            ln_suma := ld_sysdate - ld_aofval;
                             if ln_suma <0 then 
                                ln_suma := 0;
                             end if;          
                            ln_contador := ln_contador + ln_suma;
                      end if;
                      
                      else
                          if ld_aofval < ld_fecantC then
                             --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                             ld_aofval :=  ld_fecantC;
                             if i.JAQZ735aostat = 99 then
                                  --ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                  ln_suma := ld_aofe99 - ld_aofval;
                                   if ln_suma <0 then 
                                      ln_suma := 0;
                                   end if;  
                                   /*if ln_aux > ln_suma then
                                      ln_suma := 0;
                                      ln_aux  := 0;
                                   end if;*/
                                  ln_contador := ln_contador + ln_suma;-- - ln_aux;
                                  
                                  else
                                    --ln_suma := trunc(months_between(ld_sysdate,ld_aofval));
                                     ln_suma := ld_sysdate - ld_aofval;
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;        
                                     /*if ln_aux > ln_suma then
                                        ln_suma := 0;
                                        ln_aux  := 0;
                                     end if; */   
                                    ln_contador := ln_contador + ln_suma;-- - ln_aux;
                              end if;
                                  
                          
                          
                          end if;
                          
                          if ld_aofval > ld_fecantC then
                             
                             if i.JAQZ735aostat = 99 then
                                  --ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                   ln_suma := ld_aofe99 - ld_aofval;
                                   if ln_suma <0 then 
                                      ln_suma := 0;
                                   end if;  
                                  ln_contador := ln_contador + ln_suma;
                                  
                                  else
                                    --ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                                     ln_suma := ld_sysdate - ld_aofval;
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;  
                                    ln_contador := ln_contador + ln_suma;
                              end if;
                                  
                          
                          
                          end if;
                      
                  
                  end if;
              
        end if;
        
        if i.JAQZ735aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
           if ld_fecantC > i.JAQZ735aofval then
              ld_aofval := ld_fecantC;
           end if;
           ld_fecantC := pd_fecpro; --trunc(sysdate);
        end if;
        
        if i.JAQZ735aofe99 > ld_fecantC then
                    --ld_fecantD := ld_aofval;
                     ld_fecantC := i.JAQZ735aofe99;
        
        end if;
        ld_fecantD := ld_aofval;
        
        
        
        
        ln_mesan := to_number(to_char(ld_fecantC,'mm'));
        ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
        
      end if;
    end loop;
    
    end;    

end Sp_cr_histNuevo;

Procedure Sp_carga_data_MENSUAL(pd_fecpro in date) is
ld_fecini date;
ln_vig number(9);
begin

      begin
          select tp1nro1 
            into ln_vig
            from fst198 
           where tp1cod = 1 
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 1;
      exception
             when others then ln_vig := 60;--cambiar en produccion
      
      end;
      
      ld_fecini:=add_months(pd_fecpro,-ln_vig);    
      execute immediate ('truncate table jaqz739');
      execute immediate ('truncate table jaqz740');
      --execute immediate ('truncate table jaqz734');
      begin
      
          insert into jaqz739 (jaqz739PGCOD,jaqz739AOMOD,jaqz739AOSUC,jaqz739AOMDA,jaqz739AOPAP,jaqz739AOCTA,jaqz739AOOPER,jaqz739AOSBOP,jaqz739AOTOPE,jaqz739AOFVAL,
                                   jaqz739AOFVTO,jaqz739AOFE99,jaqz739AOSTAT,jaqz739flag,jaqz739hipo,jaqz739instancia)
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
                           pq_cr_relcrediticia.Fn_DiaPago(PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,a.aofe99),
                           --a.aofe99,
                           a.aostat,
                           (case when aofe99 = to_date('0001.01.01','yyyy.mm.dd') and aostat = 99 and aofval <ld_fecini then 'N'
                                else 'S'
                           end),
                             /*Case 
                            when aomod = 110 and aotope not in (30,31,40) then 'N'
                              else 'S'
                           end*/
                  	        '',--      PQ_CR_RELCREDITICIA_A2.Fn_hipotecario(PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE)                        
                              NVL(fn_instancia_credito(    PGCOD ,
                                                           AOSUC ,
                                                           AOMDA ,
                                                           AOPAP ,
                                                           AOCTA ,
                                                           AOOPER,
                                                           AOSBOP,
                                                           AOTOPE),0)                            
                      from fsd010 a
                     where (aomod in (select modulo from fst111 where dscod = 50 and modulo not in (select fst098.tpnro from fst098 where fst098.tpcod=7722 and fst098.tpimp=1)))
                       and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                       and aotope <> 550 and aocta<>999999999 ;

              commit;                
          
      
      end;
      
      
      commit;
      
--      PQ_CR_RELCREDITICIA_A2.Sp_cr_Inserta_MENSUAL(pd_fecpro,ld_fecini);
end Sp_carga_data_MENSUAL;

Procedure Sp_cr_Inserta_MENSUAL (pd_fecpro in date) is

cursor creditos is
select * from jaqz740 a ;
ln_contador number(5);
ln_ins number(1);
ln_anio number(4);
ln_mes number(2);
ln_inserta char(1);
ld_feccan date;
ln_estado number(2);
ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);

ld_fecini date;

ld_fec date;
LN_AUX NUMBER(9);

ld_fecguia date;
ln_histAnt number(5);
ln_estAnt number(2);
ln_empAnt number(3);
ln_modAnt number(3);
ln_sucAnt number(3);
ln_mdaAnt number(4);
ln_papAnt number(4);
ln_ctaAnt number(9);
ln_opeAnt number(9);
ln_sboAnt number(3);
ln_topAnt number(3);
ld_fecAnt date;

ln_estPro number(2);
ln_empPro number(3);
ln_modPro number(3);
ln_sucPro number(3);
ln_mdaPro number(4);
ln_papPro number(4);
ln_ctaPro number(9);
ln_opePro number(9);
ln_sboPro number(3);
ln_topPro number(3);
ld_fecPro date;
ln_contPro number(5);
ln_vig number(9);
ld_fectmp date;
ld_fecvac date;
pd_fecini date;
begin
  
     begin
          select tp1nro1
            into ln_vig
            from fst198
           where tp1cod = 1
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 1;
      exception
             when others then ln_vig := 60;--cambiar en produccion

      end;
      ld_fecini:=add_months(pd_fecpro,-ln_vig);  
     
      begin
      
          insert into jaqz740(jaqz740PGCOD,jaqz740AOMOD,jaqz740AOSUC,jaqz740AOMDA,jaqz740AOPAP,jaqz740AOCTA,jaqz740AOOPER,jaqz740AOSBOP,jaqz740AOTOPE,jaqz740AOFVAL,
                                   jaqz740AOFVTO,jaqz740AOFE99,jaqz740AOSTAT,jaqz740PEPAIS,jaqz740PETDOC,jaqz740PENDOC)
                                   
                      select a.jaqz739pgcod,
                             a.jaqz739aomod,
                             a.jaqz739aosuc,
                             a.jaqz739aomda,
                             a.jaqz739aopap,
                             a.jaqz739aocta,
                             a.jaqz739aooper,
                             a.jaqz739aosbop,
                             a.jaqz739aotope,
                             a.jaqz739aofval,
                             a.jaqz739aofvto,
                             a.jaqz739aofe99,
                             a.jaqz739aostat, 
                             b.pepais,
                             b.petdoc,
                             b.pendoc
                        from jaqz739 a,
                             fsr008 b
                       where b.ctnro = a.jaqz739aocta
                         and b.cttfir = 'T'
                         AND A.jaqz739FLAG = 'S'
                         and a.jaqz739hipo = 'S' 
                         ;             
          commit;
          
      end;


      Begin
          pd_fecini:=ld_fecini;
         ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
         ln_mes := to_number(to_char(pd_fecpro,'mm'));
         
         ld_fecini := to_date(to_char(pd_fecini,'yyyymm')||'01','yyyymmdd')   ;
         
         ld_fectmp := to_date(to_char(add_months(pd_fecpro,-12),'yyyymm')||'01','yyyymmdd');
         ld_fecvac := to_date('0001.01.01','yyyy.mm.dd');
         
         
         begin
             select to_date(a.tp1nro1,'ddmmyyyy')--actulizar
               into ld_fecguia
               from fst198 a
              where a.tp1cod = 1
                and a.tp1cod1 = 11108--10823
                and a.tp1corr1 = 1--8
                and a.tp1corr2 =1;--1; 
         exception 
                when no_data_found then
                     ld_fecguia := null;
         end;
         
                  
         for i in creditos loop
             ln_contador := null;
             ln_inserta  := NULL;
             ln_estado := null;
             ln_emp    := null;
             ln_mod    := null;
             ln_suc    := null;
             ln_mda    := null;
             ln_pap    := null;
             ln_cta    := null;
             ln_ope    := null;
             ln_sbo    := null;
             ln_top    := null;
             ld_feC    := null;
             ln_ins := PQ_CR_RELCREDITICIA_A2.fn_inserta(i.jaqz740pepais,i.jaqz740petdoc,i.jaqz740pendoc,ln_anio,ln_mes); 
             
             begin
                    select a.jaqz734his,
                           a.jaqz734est,
                           a.jaqz734pgc,
                           a.jaqz734mod,
                           a.jaqz734suc,
                           a.jaqz734mda,
                           a.jaqz734pap,
                           a.jaqz734cta,
                           a.jaqz734ope,
                           a.jaqz734sbo,
                           a.jaqz734top,
                           a.jaqz734fec
                      into ln_histAnt,
                           ln_estAnt, 
                           ln_empAnt,
                           ln_modAnt,
                           ln_sucAnt,
                           ln_mdaAnt,
                           ln_papAnt,
                           ln_ctaAnt,
                           ln_opeAnt,
                           ln_sboAnt,
                           ln_topAnt,
                           ld_fecAnt
                      from jaqz734 a
                     where a.jaqz734pai = i.jaqz740pepais
                       and a.jaqz734tdo = i.jaqz740petdoc
                       and a.jaqz734ndo = i.jaqz740pendoc
                       and a.jaqz734fep = ld_fecguia;
                       
             exception
                  when no_data_found then
                       ln_histAnt := null;
                       ln_estAnt := null;
             end;
                        
             if ln_ins = 0 then
                --pq_cr_relcrediticia.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
                --                                     ld_feccan);
                --if ln_inserta = 'S' then
                     PQ_CR_RELCREDITICIA_A2.Sp_cr_historial(i.jaqz740pepais,i.jaqz740petdoc,i.jaqz740pendoc,ld_fecini,pd_fecpro,
                                                        ln_contPro,
                                                        ln_estPro,ln_empPro,ln_modPro,ln_sucPro,ln_mdaPro,
                                                        ln_papPro,ln_ctaPro,ln_opePro,ln_sboPro,ln_topPro,
                                                        ld_fecPro);
                     if ln_estAnt is not null then     --mod 2016.03.30                              
                       if ln_estAnt <> 99 or ln_estPro <> 99 then
                          ln_contador := ln_histAnt + 1 ;
                          ln_estado := ln_estPro;
                          ln_emp    := ln_empPro;
                          ln_mod    := ln_modPro;
                          ln_suc    := ln_sucPro;
                          ln_mda    := ln_mdaPro;
                          ln_pap    := ln_papPro;
                          ln_cta    := ln_ctaPro;
                          ln_ope    := ln_opePro;
                          ln_sbo    := ln_sboPro;
                          ln_top    := ln_topPro;
                          ld_feC    := ld_fecPro;
                          
                       end if;
                     end if;
                     
                     if ln_estAnt is null then
                        ln_contador := ln_contPro;
                        ln_estado := ln_estPro;
                        ln_emp := ln_empPro;
                        ln_mod := ln_modPro;
                        ln_suc := ln_sucPro;
                        ln_mda := ln_mdaPro;
                        ln_pap := ln_papPro;
                        ln_cta := ln_ctaPro;
                        ln_ope := ln_opePro;
                        ln_sbo := ln_sboPro;
                        ln_top := ln_topPro;
                        ld_feC := ld_fecPro;
                    
                     end if;
                     
                     if ln_estAnt = 99 and ln_estPro = 99 then --mod 2016.03.30
                        if ld_fecvac = ld_fecAnt or ld_fecAnt >= ld_fectmp then
                           ln_contador := ln_histAnt;
                           ln_estado := ln_estPro;
                           ln_emp    := ln_empPro;
                           ln_mod    := ln_modPro;
                           ln_suc    := ln_sucPro;
                           ln_mda    := ln_mdaPro;
                           ln_pap    := ln_papPro;
                           ln_cta    := ln_ctaPro;
                           ln_ope    := ln_opePro;
                           ln_sbo    := ln_sboPro;
                           ln_top    := ln_topPro;   
                           ld_feC    := ld_fecPro;
                           
                           else
                                  ln_contador := ln_contPro;
                                  ln_estado := ln_estPro;
                                  ln_emp := ln_empPro;
                                  ln_mod := ln_modPro;
                                  ln_suc := ln_sucPro;
                                  ln_mda := ln_mdaPro;
                                  ln_pap := ln_papPro;
                                  ln_cta := ln_ctaPro;
                                  ln_ope := ln_opePro;
                                  ln_sbo := ln_sboPro;
                                  ln_top := ln_topPro;   
                                  ld_feC := ld_fecPro;                   
                           
                        end if;
                     end if;
                     
                    
                    insert into jaqz734(jaqz734PAI,jaqz734TDO,jaqz734NDO,jaqz734ANI,jaqz734MES,
                                        jaqz734FEP,jaqz734his,jaqz734FCN,jaqz734est,jaqz734pgc,
                                        jaqz734mod,jaqz734suc,jaqz734mda,jaqz734pap,jaqz734cta,
                                        jaqz734ope,jaqz734sbo,jaqz734top,jaqz734FEC)
                    
                    values(i.jaqz740pepais,i.jaqz740petdoc,i.jaqz740pendoc,ln_anio,ln_mes,pd_fecpro,ln_contador,ld_feccan,
                           ln_estado,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,
                                                        ln_cta,ln_ope,ln_sbo,ln_top,ld_fec);
                                                        
                                                       
                    
                    commit;
                    
                    
                --end if;
                 end if;
             commit;
             
         end loop;
                      
         commit;
         
         LN_AUX :=to_number(to_char(pd_fecpro,'ddmmyyyy'));--actulizar
                    UPDATE FST198 set tp1nro1 = LN_AUX
                    where tp1cod1 = 11108--10823
                      and tp1corr1 = 1--8
                      and tp1corr2 = 1;--1;
                      commit;
      end;


end Sp_cr_Inserta_MENSUAL;
procedure sp_cr_relacioncre2017_job(P_D_FECPRO IN DATE) is
 
      
     cursor c_relacioncre2017_job is 
		
     select substr(trim(j.jaqz739aocta), -1, 1) digito
     from jaqz739 j
     where j.jaqz739aofval <= P_D_FECPRO
     and substr(trim(j.jaqz739aocta), -1, 1) is not null
     group by substr(trim(j.jaqz739aocta), -1, 1); 
      lc_hostname  varchar2(64);
      lc_variable varchar2(1000);
       ln_job number:=0;
      ln_inst number(1):=2;--cambio de 1 a 2
      ln_cont number(5):=0;
      begin
        begin
          select host_name
            into lc_hostname
            from v$instance;
        end;   
              /*  delete Tab_jobs where  c_Codage = 'CCC';
              commit;*/
           for job in c_relacioncre2017_job loop
              --lc_variable := ' begin '||
              --'PQ_CR_RELCREDITICIA_A2.sp_cr_relacioncre2017('''||job.digito||''');'||
              --                                                                   ' End; ';
           lc_variable := ' begin '|| ' PQ_CR_RELCREDITICIA_A2.sp_cr_relacioncre2017('||''''||job.digito||'''' ||');'|| ' End; ';
            ln_cont := ln_cont +1;
                     
           /*   if(ln_cont>=5) then
                  ln_inst:=2;    
              end if;*/
                ln_job:=ln_job+1;    
--                  If  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
                           DBMS_JOB.SUBMIT(job => ln_job, 
                                        what => lc_variable,
                                        next_date => sysdate+1/(24*60),
                                        interval => null,
                                        no_parse => false,
                                       instance => ln_inst,
                                        force => false
                                        );
                  else
                          DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
                  end if;     
                   INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
                    VALUES('CCC',job.digito,lc_variable);
            commit;                                                                                                                                          
         end loop;
         exception
          when others then
--       lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CCC',lc_variable, TRUNC(SYSDATE));
           COMMIT;
       --p_c_error:=  lc_variable;      
       end sp_cr_relacioncre2017_job;



procedure sp_cr_relacioncre2017(digito varchar2) is
 
     cursor c_relacioncre_digito is 		
     select j.jaqz739pgcod,j.jaqz739aomod,j.jaqz739aosuc,
     j.jaqz739aomda,j.jaqz739aopap,j.jaqz739aocta,j.jaqz739aooper,j.jaqz739aosbop,j.jaqz739aotope,j.jaqz739instancia
     from jaqz739 j
     where  substr(trim(j.jaqz739aocta), -1, 1)=trim(digito);    
   begin
        for ractulizar in c_relacioncre_digito loop
          
     update jaqz739 
     set jaqz739.jaqz739hipo=trim(PQ_CR_RELCREDITICIA_A2.Fn_hipotecario(
         ractulizar.jaqz739pgcod,
         ractulizar.jaqz739aomod,
         ractulizar.jaqz739aosuc,
         ractulizar.jaqz739aomda,
         ractulizar.jaqz739aopap,
         ractulizar.jaqz739aocta,
         ractulizar.jaqz739aooper,
         ractulizar.jaqz739aosbop,
         ractulizar.jaqz739aotope,
         ractulizar.jaqz739instancia))

     where jaqz739.jaqz739pgcod=ractulizar.jaqz739pgcod
     and jaqz739.jaqz739aomod=ractulizar.jaqz739aomod
     and jaqz739.jaqz739aosuc=ractulizar.jaqz739aosuc
     and jaqz739.jaqz739aomda=ractulizar.jaqz739aomda
     and jaqz739.jaqz739aopap=ractulizar.jaqz739aopap
     and jaqz739.jaqz739aocta=ractulizar.jaqz739aocta
     and jaqz739.jaqz739aooper=ractulizar.jaqz739aooper
     and jaqz739.jaqz739aosbop=ractulizar.jaqz739aosbop         
     and jaqz739.jaqz739aotope=ractulizar.jaqz739aotope;
--   and jaqz739.instancia=ractulizar.instancia;
     commit;                
   end loop;
     update tab_jobs g
           set g.d_fecfin = sysdate
         where g.n_numer1 =  digito
           and g.c_codage = 'CCC';
        commit;
   end sp_cr_relacioncre2017;
-------------------------------
/*procedure sp_cr_relcre2017_job_mensual(P_D_FECPRO IN DATE) is
     cursor c_relacioncre2017_job is 
     select substr(trim(j.aocta), -1, 1) digito
     from jaqz739 j
     where j.aofval <= P_D_FECPRO
     and substr(trim(j.aocta), -1, 1) is not null
     group by substr(trim(j.aocta), -1, 1); 
      lc_hostname  varchar2(64);
      lc_variable varchar2(1000);
       ln_job number:=0;
      ln_inst number(1):=1;
      ln_cont number(5):=0;
      begin
        begin
          select host_name
            into lc_hostname
            from v$instance;
        end;   
                delete Tab_jobs where  c_Codage = 'CCC';
              commit;
           for job in c_relacioncre2017_job loop
              --lc_variable := ' begin '||
              --'PQ_CR_RELCREDITICIA_A2.sp_cr_relacioncre2017('''||job.digito||''');'||
              --                                                                   ' End; ';
           lc_variable := ' begin '|| ' PQ_CR_RELCREDITICIA_A2.sp_cr_relacioncre2017('||''''||job.digito||'''' ||');'|| ' End; ';
            ln_cont := ln_cont +1;
                     
              if(ln_cont>=5) then
                  ln_inst:=2;    
              end if;
                ln_job:=ln_job+1;    
                  If  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
                           DBMS_JOB.SUBMIT(job => ln_job, 
                                        what => lc_variable,
                                        next_date => sysdate+1/(24*60),
                                        interval => null,
                                        no_parse => false,
                                       instance => ln_inst,
                                        force => false
                                        );
                  else
                          DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
                  end if;     
                   INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
                    VALUES('CCC',job.digito,lc_variable);
            commit;                                                                                                                                          
         end loop;
         exception
          when others then
--       lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CCC',lc_variable, TRUNC(SYSDATE));
           COMMIT;
       --p_c_error:=  lc_variable;      
       end sp_cr_relcre2017_job_mensual;   */
end PQ_CR_RELCREDITICIA_A2;
/

