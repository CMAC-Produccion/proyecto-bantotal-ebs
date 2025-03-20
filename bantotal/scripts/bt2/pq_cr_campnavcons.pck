create or replace package PQ_CR_CAMPNAVCONS is
  -- *****************************************************************
  -- Nombre                     : Resolutores Campaña Navidad Consumo 2017
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 09/10/2017 06:45:00 p.m.
  -- Autor de Creación          : ABERNEDO
  -- Uso                        : Resolutores para la campaña Navidad Consumo 2017
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   :  
  -- Descripción de Modificación: 
  -- *****************************************************************

  Procedure Sp_carga_data(pd_fecpro in date) ;
  Procedure Sp_cr_historial (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                             pd_fecpro in date,      
                            ln_contador out number,
                             ln_aostat out number,ln_emp out number,ln_mod out number,ln_suc out number,
                          ln_mda out number,ln_pap out number,ln_cta out number,ln_ope out number,
                          ln_sbo out number,ln_top out number,ld_feccan out date);
  Procedure Sp_cr_Inserta (pd_fecpro in date,pd_fecini in date);
  Function fn_inserta(pn_pai in number,pn_tdo in number,pc_ndo in char,pn_anio in number,pn_mes in number)return number ;
  Procedure Sp_carga_data_MENSUAL(pd_fecpro in date);                          
  Procedure Sp_cr_Inserta_MENSUAL (pd_fecpro in date,pd_fecini in date);    
  Function Fn_GarantiaDPFCTS(pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number) return char ;
  Procedure Sp_cr_ReCalcula(pn_pais in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                          ln_contador out number) ;
  Procedure Sp_cr_InsNuevo (pn_pais in number,pn_tdo in number,pc_ndo in char,
                          pd_fecpro in date,pd_fecini in date,ln_contador out number) ;
  Procedure Sp_cr_histNuevo (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                           pd_fecpro in date,
                          ln_contador out number);                                                                               
end PQ_CR_CAMPNAVCONS;
/

create or replace package body PQ_CR_CAMPNAVCONS is


Procedure Sp_cr_historial (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                           pd_fecpro in date,
                          ln_contador out number,
                          ln_aostat out number,ln_emp out number,ln_mod out number,ln_suc out number,
                          ln_mda out number,ln_pap out number,ln_cta out number,ln_ope out number,
                          ln_sbo out number,ln_top out number,ld_feccan out date) is

cursor creditos is
 select *
   from jaqz540_aux_ii a
  where a.pepais = pn_pai
    and a.petdoc = pn_tdo
    and a.pendoc = pc_ndo
order by aofval;

cursor creditos_i is
 select *
   from jaqz540_aux_ii a
  where a.pepais = pn_pai
    and a.petdoc = pn_tdo
    and a.pendoc = pc_ndo
order by aostat,aofe99 desc;

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
      if (i.aofe99 is null or i.aofe99 = to_date('0001.01.01','yyyy.mm.dd'))and i.aostat = 99 then
         ln_sw := 1;
      end if;
      if ln_sw = 0 then
      
        ln_mesac := to_number(to_char(i.aofval,'mm'));
        ln_aniac := to_number(to_char(i.aofval,'yyyy'));
        ln_suma := null;
        ld_aofval := i.aofval;
        ld_aofe99 := last_day(i.aofe99);
        
        if ld_aofval < pd_fecini then
           ld_aofval := pd_fecini;
        end if;
        
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
           ld_fecantC := pd_fecpro;-- trunc(sysdate);
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
    
   
    For j in creditos_i loop
    
       ln_emp := j.pgcod;
       ln_mod := j.aomod;
       ln_suc := j.aosuc;
       ln_mda := j.aomda;
       ln_pap := j.aopap;
       ln_cta := j.aocta;
       ln_ope := j.aooper;
       ln_sbo := j.aosbop;
       ln_top := j.aotope;
       ln_aostat := j.aostat;
       ld_feccan := j.aofe99;
       exit;
    end loop;
   end;        

end Sp_cr_historial;

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
      execute immediate ('truncate table JAQZ540_AUX');
      execute immediate ('truncate table JAQZ540_AUX_II');
      delete from JAQZ540 a where a.jaqz540fep = pd_fecpro;
      commit;
      begin
      
          insert into JAQZ540_AUX (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,AOFVAL,
                                   AOFVTO,AOFE99,AOSTAT,flag,hipo)
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
                           pq_cr_campnavcons.fn_garantiaDPFCTS(AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE)
                       
                      from fsd010 a
                     where (aomod in (select modulo from fst111 where dscod = 50 and modulo not in ( select tp1nro1
                                                                                                       from fst198 
                                                                                                      where tp1cod = 1 
                                                                                                        and tp1cod1 = 10899
                                                                                                        and tp1corr1=500 
                                                                                                        and tp1corr2 = 1 )))
                       and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                       and aotope <> 550
                    ;
              commit;                
          
      
      end;
      
      begin
      
          insert into JAQZ540_AUX_II (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,AOFVAL,
                                   AOFVTO,AOFE99,AOSTAT,PEPAIS,PETDOC,PENDOC)
                                   
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
                             a.aofe99,
                             a.aostat, 
                             b.pepais,
                             b.petdoc,
                             b.pendoc
                        from JAQZ540_AUX a,
                             fsr008 b
                       where b.ctnro = a.aocta
                         and b.cttfir = 'T'
                         AND A.FLAG = 'S'
                         and hipo <> 'S';             
          commit;
          
      end;

      commit;
      
      PQ_CR_CAMPNAVCONS.Sp_cr_Inserta(pd_fecpro,ld_fecini);
end Sp_carga_data;

Procedure Sp_cr_Inserta (pd_fecpro in date,pd_fecini in date) is

cursor creditos is
select * from JAQZ540_AUX_II ;
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
begin

      Begin
            
         ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
         ln_mes := to_number(to_char(pd_fecpro,'mm'));
         
         ld_fecini := to_date(to_char(pd_fecini,'yyyymm')||'01','yyyymmdd')   ;
         for i in creditos loop
             ln_contador := null;
             ln_inserta  := NULL;
             ln_ins := PQ_CR_CAMPNAVCONS.fn_inserta(i.pepais,i.petdoc,i.pendoc,ln_anio,ln_mes); 
                        
             if ln_ins = 0 then
                --pq_cr_relcrediticia.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
                --                                     ld_feccan);
                --if ln_inserta = 'S' then
                    PQ_CR_CAMPNAVCONS.Sp_cr_historial(i.pepais,i.petdoc,i.pendoc,ld_fecini,pd_fecpro,
                                                        ln_contador,
                                                        ln_estado,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,
                                                        ln_cta,ln_ope,ln_sbo,ln_top,ld_fec);
                    
                    insert into JAQZ540(JAQZ540PAI,JAQZ540TDO,JAQZ540NDO,JAQZ540ANI,JAQZ540MES,
                                        JAQZ540FEP,JAQZ540his,JAQZ540FCN,JAQZ540est,JAQZ540pgc,
                                        JAQZ540mod,JAQZ540suc,JAQZ540mda,JAQZ540pap,JAQZ540cta,
                                        JAQZ540ope,JAQZ540sbo,JAQZ540top,JAQZ540FEC)
                    
                    values(i.pepais,i.petdoc,i.pendoc,ln_anio,ln_mes,pd_fecpro,ln_contador,ld_feccan,
                           ln_estado,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,
                                                        ln_cta,ln_ope,ln_sbo,ln_top,ld_fec);
                                                        
                                                       
                    
                    commit;
                    
                    
                --end if;
                
             end if;
             commit;
             
         end loop;
         
         LN_AUX :=to_number(to_char(pd_fecpro,'ddmmyyyy'));
                    UPDATE FST198 set tp1nro1 = LN_AUX
                    where tp1cod  = 1
                      and tp1cod1 = 10899
                      and tp1corr1 = 500
                      and tp1corr2 = 3;
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
                from JAQZ540 a
               where a.JAQZ540pai = pn_pai
                 and a.JAQZ540tdo = pn_tdo
                 and a.JAQZ540ndo = pc_ndo
                 and a.JAQZ540ani = pn_anio
                 and a.JAQZ540mes = pn_mes;
                 
         exception
                 when others then 
                      ln_existe := 0;
         end;

         if ln_existe is null then
            ln_existe := 0;
         end if;
         return ln_existe;
end fn_inserta;


Procedure Sp_carga_data_MENSUAL(pd_fecpro in date) is
ld_fecini date;
ln_vig number(9);
ld_fecmax date;
ln_fecmax NUMBER(9);
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
      execute immediate ('truncate table jaqz540_aux');
      execute immediate ('truncate table jaqz540_aux_ii');
      delete from JAQZ540 a where a.jaqz540fep = pd_fecpro;
      commit;
      
      begin
        select max(jaqz540fep)
          into ld_fecmax
          from jaqz540;
      exception 
          when too_many_rows then 
               begin
                  select max(jaqz540fep)
                    into ld_fecmax
                    from jaqz540
                   where rownum = 1;
                exception 
                    when others then null;
                end;
           when others then null;
      end;
      
      ln_fecmax :=to_number(to_char(ld_fecmax,'ddmmyyyy'));
                   
                      UPDATE FST198 set tp1nro1 = ln_fecmax
                    where tp1cod  = 1
                      and tp1cod1 = 10899
                      and tp1corr1 = 500
                      and tp1corr2 = 3;
                      commit;
                      
      begin
      
          insert into jaqz540_aux (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,AOFVAL,
                                   AOFVTO,AOFE99,AOSTAT,flag,hipo)
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
                           pq_cr_campnavcons.fn_garantiaDPFCTS(AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE)
                      from fsd010 a
                     where (aomod in (select modulo from fst111 where dscod = 50 and modulo not in (select tp1nro1
                                                                                                       from fst198 
                                                                                                      where tp1cod = 1 
                                                                                                        and tp1cod1 = 10899
                                                                                                        and tp1corr1=500 
                                                                                                        and tp1corr2 = 1)))
                       and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                       and aotope <> 550
                    ;
              commit;                
          
      
      end;
      
      begin
      
          insert into jaqz540_aux_ii (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,AOFVAL,
                                   AOFVTO,AOFE99,AOSTAT,PEPAIS,PETDOC,PENDOC)
                                   
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
                             a.aofe99,
                             a.aostat, 
                             b.pepais,
                             b.petdoc,
                             b.pendoc
                        from jaqz540_aux a,
                             fsr008 b
                       where b.ctnro = a.aocta
                         and b.cttfir = 'T'
                         AND A.FLAG = 'S'
                         and hipo <> 'S';             
          commit;
          
      end;

      commit;
      
      pq_cr_campnavcons.Sp_cr_Inserta_MENSUAL(pd_fecpro,ld_fecini);
end Sp_carga_data_MENSUAL;

Procedure Sp_cr_Inserta_MENSUAL (pd_fecpro in date,pd_fecini in date) is

cursor creditos is
select * from JAQZ540_AUX_II ;
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

ld_fectmp date;
ld_fecvac date;

begin

      Begin
            
         ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
         ln_mes := to_number(to_char(pd_fecpro,'mm'));
         
         ld_fecini := to_date(to_char(pd_fecini,'yyyymm')||'01','yyyymmdd')   ;
         
         ld_fectmp := to_date(to_char(add_months(pd_fecpro,-12),'yyyymm')||'01','yyyymmdd');
         ld_fecvac := to_date('0001.01.01','yyyy.mm.dd');
         
         
         begin
             select to_date(a.tp1nro1,'ddmmyyyy')
               into ld_fecguia
               from fst198 a
              where tp1cod  = 1
                and tp1cod1 = 10899
                and tp1corr1 = 500
                and tp1corr2 = 3; 
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
             ln_ins := pq_cr_campnavcons.fn_inserta(i.pepais,i.petdoc,i.pendoc,ln_anio,ln_mes); 
             
             begin
                    select a.JAQZ540his,
                           a.JAQZ540est,
                           a.JAQZ540pgc,
                           a.JAQZ540mod,
                           a.JAQZ540suc,
                           a.JAQZ540mda,
                           a.JAQZ540pap,
                           a.JAQZ540cta,
                           a.JAQZ540ope,
                           a.JAQZ540sbo,
                           a.JAQZ540top,
                           a.JAQZ540fec
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
                      from JAQZ540 a
                     where a.JAQZ540pai = i.pepais
                       and a.JAQZ540tdo = i.petdoc
                       and a.JAQZ540ndo = i.pendoc
                       and a.JAQZ540fep = ld_fecguia;
                       
             exception
                  when no_data_found then
                       ln_histAnt := null;
                       ln_estAnt := null;
             end;
                        
             if ln_ins = 0 then
                --pq_cr_relcrediticia.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
                --                                     ld_feccan);
                --if ln_inserta = 'S' then
                     pq_cr_campnavcons.Sp_cr_historial(i.pepais,i.petdoc,i.pendoc,ld_fecini,pd_fecpro,
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
                     
                    
                    insert into jaqz540(JAQZ540PAI,JAQZ540TDO,JAQZ540NDO,JAQZ540ANI,JAQZ540MES,
                                        JAQZ540FEP,JAQZ540his,JAQZ540FCN,JAQZ540est,JAQZ540pgc,
                                        JAQZ540mod,JAQZ540suc,JAQZ540mda,JAQZ540pap,JAQZ540cta,
                                        JAQZ540ope,JAQZ540sbo,JAQZ540top,JAQZ540FEC)
                    
                    values(i.pepais,i.petdoc,i.pendoc,ln_anio,ln_mes,pd_fecpro,ln_contador,ld_feccan,
                           ln_estado,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,
                                                        ln_cta,ln_ope,ln_sbo,ln_top,ld_fec);
                                                        
                                                       
                    
                    commit;
                    
                    
                --end if;
                
             end if;
             commit;
             
         end loop;
                      
         commit;
         
         LN_AUX :=to_number(to_char(pd_fecpro,'ddmmyyyy'));
                   
                      UPDATE FST198 set tp1nro1 = LN_AUX
                    where tp1cod  = 1
                      and tp1cod1 = 10899
                      and tp1corr1 = 500
                      and tp1corr2 = 3;
                      commit;
      end;


end Sp_cr_Inserta_MENSUAL;


-----------------------------------------------------------------------
Function Fn_GarantiaDPFCTS(pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number) return char is
ln_instancia number(10);
lc_flg char(1);
begin
     ln_instancia := fn_instancia_credito(pn_mod,
                                          pn_suc,
                                          pn_mda,
                                          pn_pap,
                                          pn_cta,
                                          pn_ope,
                                          pn_sbo,
                                          pn_top);
     
     lc_flg := 'N';
     begin
          select 'S'
            into lc_flg
            from sng122 a
           where a.sng122inst = ln_instancia
             and a.sng122tope in ( select tp1nro1
                                     from fst198 
                                    where tp1cod = 1 
                                      and tp1cod1 = 10899
                                      and tp1corr1=500 
                                      and tp1corr2 = 2 )
             and rownum = 1;
     exception
         when others then 
              lc_flg := 'N';
     end;
       
     return lc_flg;
end Fn_GarantiaDPFCTS;

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
     delete from  JAQZ540_R a where a.pepais = pn_pais and a.petdoc = pn_tdo and a.pendoc = pc_ndo;
     commit;
     
     begin
     
      insert into JAQZ540_R(PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,AOFVAL,
                                   AOFVTO,AOFE99,AOSTAT,PEPAIS,PETDOC,PENDOC) 
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
                 pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,a.aofe99)aofe99,
                 a.aostat, 
                 b.pepais,
                 b.petdoc,
                 b.pendoc,
                 (case when aofe99 = to_date('0001.01.01','yyyy.mm.dd') and aostat = 99 and aofval <ld_fecini then 'N'
                                else 'S'
                  end) flag,
                  pq_cr_campnavcons.fn_garantiaDPFCTS(AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE) hipo
            from fsr008 b, fsd010 a
           where b.pgcod = 1
             and b.pepais = pn_pais
             and b.petdoc = pn_tdo
             and b.pendoc = pc_ndo
             and b.cttfir = 'T'
             and a.pgcod = b.pgcod
             and a.aocta = b.ctnro
             and aomod in (select modulo from fst111 where dscod = 50 and modulo not in ( select tp1nro1
                                                                                           from fst198 
                                                                                          where tp1cod = 1 
                                                                                            and tp1cod1 = 10899
                                                                                            and tp1corr1=500 
                                                                                            and tp1corr2 = 1 )) 
                  
             and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd')))
            where flag = 'S' 
              and hipo <> 'S';
             
             commit;
     
     end;

     PQ_CR_CAMPNAVCONS.Sp_cr_InsNuevo(pn_pais,pn_tdo,pc_ndo,pd_fecpro,ld_fecini,ln_contador);
     
     
                                                 
end Sp_cr_ReCalcula;

Procedure Sp_cr_InsNuevo (pn_pais in number,pn_tdo in number,pc_ndo in char,
                          pd_fecpro in date,pd_fecini in date,ln_contador out number) is

cursor creditos is
select * from JAQZ540_R a
where a.pepais = pn_pais
  and a.petdoc = pn_tdo
  and a.pendoc = pc_ndo;


begin

      Begin
            
         for i in creditos loop
             ln_contador := null;
             PQ_CR_CAMPNAVCONS.Sp_cr_histNuevo(i.pepais,i.petdoc,i.pendoc,pd_fecini,pd_fecpro,
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
   from JAQZ540_R a
  where a.pepais = pn_pai
    and a.petdoc = pn_tdo
    and a.pendoc = pc_ndo
order by a.aofval;

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
    ld_sysdate := last_day(pd_fecpro );
    For i in creditos loop
      ln_sw := 0;
      if i.aofe99 is null and i.aostat = 99 then
         ln_sw := 1;
      end if;
      if ln_sw = 0 then
      
        ln_mesac := to_number(to_char(i.aofval,'mm'));
        ln_aniac := to_number(to_char(i.aofval,'yyyy'));
        ln_suma := null;
        ld_aofval := i.aofval;
        ld_aofe99 := last_day(i.aofe99);
        
        if ld_aofval < pd_fecini then
           ld_aofval := pd_fecini;
        end if;
        
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
           ld_fecantC := trunc(sysdate);
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
    
    end;

end Sp_cr_histNuevo;

end PQ_CR_CAMPNAVCONS;
/

