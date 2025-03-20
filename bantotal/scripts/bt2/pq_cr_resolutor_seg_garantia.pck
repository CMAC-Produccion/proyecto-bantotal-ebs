create or replace package PQ_CR_RESOLUTOR_SEG_GARANTIA is

  -- Author  : SMARQUEZ
  -- Created : 23/02/2023 10:49:30
  -- Purpose : Creacion de variables para el seguro de GArantia

  Procedure Sp_codigo_seg_garantia(pn_emp in number,
                                   pn_mod in number,
                                   pn_suc in number,
                                   pn_mda in number,
                                   pn_pap in number,
                                   pn_cta in number,
                                   pn_ope in number,
                                   pn_sbo in number,
                                   pn_top in number,
                                   pn_ins in number,
                                   pn_seg out number,
                                   pc_tsg out varchar2,
                                   pc_mdif out varchar2,
                                   pn_mto1 out number,
                                   pn_mto2 out number,
                                   pn_cant out number);

end PQ_CR_RESOLUTOR_SEG_GARANTIA;
/

create or replace package body PQ_CR_RESOLUTOR_SEG_GARANTIA is

 Procedure  Sp_codigo_seg_garantia(pn_emp in number,
                                   pn_mod in number,
                                   pn_suc in number,
                                   pn_mda in number,
                                   pn_pap in number,
                                   pn_cta in number,
                                   pn_ope in number,
                                   pn_sbo in number,
                                   pn_top in number,
                                   pn_ins in number,
                                   pn_seg out number,
                                   pc_tsg out varchar2,                                  -- pn_nro out number,
                                   pc_mdif out varchar2,
                                   pn_mto1 out number,
                                   pn_mto2 out number,
                                   pn_cant out number) is
                                   
cursor garantia is
 select sng122cta cuenta,sng122oper operacion
   from sng122 
  where sng122inst= pn_ins;                                   
                                   
 Mto_ing number(17,3):= 0;
 Mto_Edif2 number(17,3):= 0;
 Mto_Edif number(17,3):= 0;
 tipcambio number(17,3) :=0;
 fecha date;
 fecha1 date;
 fecha2 date;
 moneda number :=0;
 pn_contador number:=0;
 operacion number;
 cuenta number;
 begin
        Begin
               select a.sgcod, 'S'
                 into pn_seg, pc_tsg
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
                  and a.sgcod in (select tp1nro1 -- seguros garantia inscrita
                                    from fst198
                                   Where Tp1cod   = 1
                                     and Tp1cod1  = 10875
                                     and Tp1corr1 = 10);
         exception
            when too_many_rows then
                begin
                   select a.sgcod ,'S'
                     into pn_seg, pc_tsg
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
                                         from fst198
                                        Where Tp1cod   = 1
                                          and Tp1cod1  = 10875
                                          and Tp1corr1 = 10)
                     and rownum = 1;
                 exception
                    when others then null;

                 end;
             when others then
               pn_seg := 0;
               pc_tsg := 'N';
         end;

     begin
       select pp001vc
         into Mto_ing
         from fpp001
        where pgcod  = pn_emp
          and aomod  = pn_mod
          and aosuc  = pn_suc
          and aomda  = pn_mda
          and aopap  = pn_pap
          and aocta  = pn_cta
          and aooper = pn_ope
          and aosbop = pn_sbo
          and aotope = pn_top
          and sgcod  = pn_seg;
     exception
       when no_data_found then
         Mto_ing := 0;
     end;
    
       moneda := pn_mda;
   /*  BEgin
       select sng122cta,sng122oper  
         into cuenta ,operacion
         from sng122 
         where sng122inst= pn_ins;
     exception
       when   no_data_found then
         operacion :=0 ;
     end;*/
     --carga de las garantias para sumar montos edificacion
     For g in garantia loop
         if moneda = 0 then
            select last_day(add_months(pgfape, -1)),pgfape,add_months(pgfape, -1)
              into fecha, fecha1, fecha2 from fst017 where pgcod = 1;

             tipcambio := fn_tipo_cambio_fijo(fecha);
             BEgin
                select ppg004DATO * tipcambio-- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta --- pn_cta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)  
                   and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                   and ppg004cdat = 67);
                  -- AND PPG004CDAT = 67 ;
             exception
               when no_data_found then
                 Mto_Edif2 := 0;
               when too_many_rows then
                  select ppg004DATO * tipcambio-- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67              
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)  
                   and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta
                                       and ppg004ope = g.operacion);
                                       ---AND PPG004CDAT = 67) ;
             end;
         else
             BEgin
                select ppg004DATO -- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67  
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67) 
                    and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta =g.cuenta
                                       and ppg004ope = g.operacion);
    --               AND PPG004CDAT = 67 
             exception
               when no_data_found then
                 Mto_Edif2 := 0;
               when too_many_rows then
                  select ppg004DATO -- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67                       
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)         
                   and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta
                                       and ppg004ope = g.operacion);
                                      --- AND PPG004CDAT = 67) ;
             end;
         end if;
         Mto_Edif := Mto_Edif + Mto_Edif2;
     end loop;
     pn_mto1 := Mto_ing;
     pn_mto2 := Mto_Edif;

     if Mto_ing = Mto_Edif then
       pc_mdif := 'S' ;
     else
       pc_mdif := 'N';
     end if;

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
                             and Tp1corr1 = 10);

        if pn_contador is null then
          pn_cant := 0;
        else
          pn_cant := pn_contador;
        end if;

  end Sp_codigo_seg_garantia;
end PQ_CR_RESOLUTOR_SEG_GARANTIA;
/

