create or replace package PQ_CR_RESOLUTOR_CREDITOS is

  -- Author  : SMARQUEZ
  -- Created : 17/01/2022 12:30:50
  -- Purpose : OBSERVACIONES DE LA EVALUACION EN EL FLUJO DE CREDITOS

  procedure sp_cr_montogastofam(pn_insta in number, pn_rpta out number);
  -- Author  : SMARQUEZ
  -- Created : 17/01/2022 12:30:50
  -- Purpose : OBSERVACIONES SOBRE INGRESOS DIFERIDOS

   procedure sp_cr_ingdiferido(pn_instancia in number,
                               pn_pgcod out number,
                               pn_aomod out number,
                               pn_aosuc out number,
                               pn_aomda out number,
                               pn_aopap out number,                               
                               pn_aocta out number,
                               pn_aooper out number,
                               pn_aosbop out number,
                               pn_aotope out number,
                               pv_rpta out varchar2);
  -- Author  : SMARQUEZ
  -- Created : 22/09/2022 09:30:50
  -- Purpose : OBSERVACIONES SOBRE INGRESOS DIFERIDOS

   procedure sp_cr_CONTADOR(   pn_pgcod IN number,
                               pn_aomod IN number,
                               pn_aosuc IN number,
                               pn_aomda IN number,
                               pn_aopap IN number,                               
                               pn_aocta IN number,
                               pn_aooper IN number,
                               pn_aosbop IN number,
                               pn_aotope IN number,
                               pn_vc out number,
                               pn_fs out number,
                               pn_mg out number,
                               pn_ve out number,
                               pn_csl out number,
                               pn_csl1 out number,
                               pn_multi out number,
                               pn_des out number,
                               pn_flag out varchar2);
  -- Author  : SMARQUEZ
  -- Created : 19/10/2022 09:30:50
  -- Purpose : OBSERVACIONES SOBRE INGRESOS DIFERIDOS
   procedure sp_cr_CONTADOR_DUPLICADO(pn_instancia in number,
                                      pn_flag out varchar2);

                               
                              
end PQ_CR_RESOLUTOR_CREDITOS;
/

create or replace package body PQ_CR_RESOLUTOR_CREDITOS is

   procedure sp_cr_montogastofam(pn_insta in number, pn_rpta out number)is

     cursor suma(evaluacion in number) is
       select * from sng023
        where sng021eval = evaluacion
       and sng026cod in (54,554,19);

   cod_eval number;
   monto number(17,2):=0;
   monto1 number(17,2):=0;
   tipo_cam number(14,8):= 0;
   fecha date;
   Begin
       Begin
         select pgfape into fecha from fst017 where pgcod = 1;
         Begin
           select cotcbi
             into tipo_cam
             from fsh005 f
            where cofdes in (select max(cofdes)
                               from fsh005 g
                              where g.cofdes <= last_day(add_months(fecha, -1))
                                and moneda = 101)
              and moneda =101;
          exception
            when no_Data_found then null;
            when too_many_rows then null;
          end;
           select sng021eval
                   into cod_eval
                   from sng021
                  where sng021sol = pn_insta;


         exception
          when no_Data_found then null;
          when too_many_rows then null;
         end;

         for a in suma(cod_eval) loop
           Monto1 := a.sng023mto;
           if a.sng026cod = 54 then
             monto := monto + Monto1;--- a.sng023mto;
           elsif  a.sng026cod = 554 then
             monto := monto + (Monto1 * tipo_cam);--(a.sng023mto * tipo_cam);
           else
             monto := monto - Monto1;--a.sng023mto;
           end if;
           Monto1 := 0;
         end loop;
         pn_rpta := monto;
   end sp_cr_montogastofam;

   procedure sp_cr_ingdiferido(pn_instancia in number,
                               pn_pgcod out number,
                               pn_aomod out number,
                               pn_aosuc out number,
                               pn_aomda out number,
                               pn_aopap out number,
                               pn_aocta out number,
                               pn_aooper out number,
                               pn_aosbop out number,
                               pn_aotope out number,
                               pv_rpta   out varchar2) is
   instancia number;
   fecha date;
   fechacan date;
   fechaCero date;

   begin
     fechaCero := to_date('1/01/0001','dd/mm/yyyy');
     select pgfape  into fecha from fst017 where pgcod =1;
     begin
       select jaqy800pgcd, jaqy800mod, jaqy800suc, jaqy800mda, jaqy800pap, jaqy800cta, jaqy800ope, jaqy800sbop, jaqy800tope,  jaqy800ins2
         into pn_pgcod ,pn_aomod ,pn_aosuc ,pn_aomda , pn_aopap ,  pn_aocta ,pn_aooper ,pn_aosbop ,pn_aotope,instancia --intancia antigua
         from jaqy800
        where jaqy800ins  = pn_instancia -- instancia nueva
          and jaqy800vinc= 'S'
          and jaqy800ufec  = (SELECT max(jaqy800ufec) 

                                     FROM jaqy800 
                                     WHERE jaqy800ins = pn_instancia);-- vinculado
          --and  jaqy800tpc = ??
          Begin
            select b.aofe99
              into fechacan
              from xwf700 a,
                   fsd010 b
             where a.xwfprcins  = instancia
               and a.xwfcar3 = '1'
               and b.pgcod = a.xwfempresa
               and b.aomod = a.xwfmodulo
               and b.aosuc = a.xwfsucursal
               and b.aomda = a.xwfmoneda
               and b.aopap = a.xwfpapel
               and b.aocta = a.xwfcuenta
               and b.aooper = a.xwfoperacion
               and b.aosbop = a.xwfsubope
               and b.aotope = a.xwftipope
               ;

              if fechacan <= fecha AND fechacan <> fechacero then
                 pv_rpta :='S';
               elsif fechacan = fechacero then
                 pv_rpta := 'V';
               end if;
          exception
              when no_Data_found then null;
              when too_many_rows then null;
          end;
     exception
          when no_Data_found then 
             pv_rpta := 'N';
             begin
               select jaqy800pgcd, jaqy800mod, jaqy800suc, jaqy800mda, jaqy800pap, jaqy800cta, jaqy800ope, jaqy800sbop, jaqy800tope,  jaqy800ins2
                 into pn_pgcod ,pn_aomod ,pn_aosuc ,pn_aomda , pn_aopap ,  pn_aocta ,pn_aooper ,pn_aosbop ,pn_aotope,instancia --intancia antigua
                 from jaqy800
                where jaqy800ins  = pn_instancia -- instancia nueva
                  and jaqy800vinc= 'N'
                  and jaqy800ufec  = (SELECT max(jaqy800ufec) 
                                        FROM jaqy800 
                                       WHERE jaqy800ins = pn_instancia);
             EXCEPTION
               when no_Data_found then 
                 pv_rpta := 'N';
                 pn_pgcod := 0;
                 pn_aomod := 0;
                 pn_aosuc := 0;
                 pn_aomda := 0; 
                 pn_aopap := 0;  
                 pn_aocta := 0;
                 pn_aooper := 0;
                 pn_aosbop := 0;
                 pn_aotope := 0;
               when too_many_rows then null;
             end;
          when too_many_rows 
            then null;
     end;
   end sp_cr_ingdiferido;
   procedure sp_cr_CONTADOR(   pn_pgcod IN number,
                               pn_aomod IN number,
                               pn_aosuc IN number,
                               pn_aomda IN number,
                               pn_aopap IN number,                               
                               pn_aocta IN number,
                               pn_aooper IN number,
                               pn_aosbop IN number,
                               pn_aotope IN number,
                               pn_vc out number,
                               pn_fs out number,
                               pn_mg out number,
                               pn_ve out number,
                               pn_csl out number,
                               pn_csl1 out number,
                               pn_multi out number,
                               pn_des out number,
                               pn_flag out varchar2) is
   cursor seguros is
     select * from fpp001 
     where pgcod = pn_pgcod
       and aomod = pn_aomod
       and aosuc = pn_aosuc
       and aomda = pn_aomda
       and aopap = pn_aopap
       and aocta = pn_aocta
       and aooper = pn_aooper
       and aosbop = pn_aosbop
       and aotope = pn_aotope
       order by sgcod ;
   cursor vidacaja (segcod in number) is
     SELECT * FROM fst198 
      where  TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =1;-- vida caja
      
   Cursor FamiliaSegura (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =2;  --fsm
      
    cursor Movigas (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =3;-- mg
      
    Cursor vehicular (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =4;  
      
    Cursor MicroCSL (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =5;  --fsm
      
    cursor MultiCSL (segcod in number) is
     SELECT * FROM fst198 
      where  TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =6;-- mg
      
    Cursor Multiriesgo (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 9 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =0;  
    
     Cursor Desgravamen (segcod in number) is
     SELECT * FROM fst300 
      where sgcod = segcod
        and sgsn02 ='5';  
   contvc number:=0;
   contfs number:=0;
   contmg number:=0;
   contve number:=0;
   contmi number:=0;
   contmu number:=0;
   contmul number:=0;
   contde number:=0;
   Begin
     For s in Seguros loop
       For vc in vidacaja(s.sgcod) loop
         contvc := contvc + 1;
       end loop;
    end loop;
    For s in Seguros loop
       For fs in FamiliaSegura(s.sgcod) loop
         contfs := contfs + 1;
       end loop;
    end loop;
    For s in Seguros loop
       For mg in Movigas(s.sgcod) loop
         contmg := contmg + 1;
       end loop;
    end loop;
    For s in Seguros loop
       For ve in vehicular(s.sgcod) loop
         contve := contve + 1;
       end loop;
    end loop;
    For s in Seguros loop
       For mi in MicroCSL(s.sgcod) loop
         contmi := contmi + 1;
       end loop;
    end loop;
    For s in Seguros loop
       For mu in MultiCSL(s.sgcod) loop
         contmu := contmu + 1;
       end loop;
    end loop;
    For s in Seguros loop
       For mul in Multiriesgo(s.sgcod) loop
         contmul := contmul + 1;
       end loop;
    end loop;
    For s in Seguros loop
       For de in Desgravamen(s.sgcod) loop
         contde := contde + 1;
       end loop;
    end loop;
        
    -- end loop;
     pn_vc := contvc;
     pn_fs := contfs;
     pn_mg := contmg;
     pn_ve := contve;
     pn_csl := contmi;
     pn_csl1 := contmu;
     pn_multi := contmul;
     pn_des:= contde;

     pn_flag :='N';
     
     if  contvc > 1 then
       pn_flag :='S';       
     end if;     
     if contfs >  1 then
       pn_flag :='S';
     end if;
      if  contmg > 1 then
       pn_flag :='S';
     end if;
     if contve >  1 then
       pn_flag :='S';
     end if;
      if  contmi > 1 then
       pn_flag :='S';
     end if;
     if contmu >  1 then
       pn_flag :='S';
     end if;
      if  contmul > 1 then
       pn_flag :='S';
     end if;
     if contde >  1 then
       pn_flag :='S';
     end if;

   end sp_cr_CONTADOR;
   
   procedure sp_cr_CONTADOR_DUPLICADO(pn_instancia in number,
                                      pn_flag out varchar2) is
   cursor seguros is
     select * 
       from fpp001 a,
            xwf700 b
     where b.xwfprcins = pn_instancia
       and b.xwfcar3 = '1'
       and a.pgcod = b.xwfempresa 
       and a.aomod = b.xwfmodulo 
       and a.aosuc = b.xwfsucursal 
       and a.aomda = b.xwfmoneda 
       and a.aopap = b.xwfpapel 
       and a.aocta = b.xwfcuenta
       and a.aooper = b.xwfoperacion
       and a.aosbop = b.xwfsubope
       and a.aotope = b.xwftipope
       order by a.sgcod ;
 /*  cursor vidacaja (segcod in number) is
     SELECT * FROM fst198 
      where  TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =1;-- vida caja*/
      
   Cursor FamiliaSegura (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =2;  --fsm
      
    cursor Movigas (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =3;-- mg
      
    Cursor vehicular (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =4;  
      
    Cursor MicroCSL (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =5;  --fsm
      
    cursor MultiCSL (segcod in number) is
     SELECT * FROM fst198 
      where  TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 4 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =6;-- mg
      
    Cursor Multiriesgo (segcod in number) is
     SELECT * FROM fst198 
      where TP1COD = 1
      AND tp1cod1 =10875 
      and tp1corr1 = 9 
      and tp1corr2 = 1 
      and tp1nro1 = segcod
      and tp1nro2 =0;  
    
     Cursor Desgravamen (segcod in number) is
     SELECT * FROM fst300 
      where sgcod = segcod
        and sgsn02 ='5';  
   contvc number:=0;
   contfs number:=0;
   contmg number:=0;
   contve number:=0;
   contmi number:=0;
   contmu number:=0;
   contmul number:=0;
   contde number:=0;
   flagNo varchar(1);
  

   Begin
     For s in Seguros loop
      /* For vc in vidacaja(s.sgcod) loop
         contvc := contvc + 1;
       end loop;*/
   
       For fs in FamiliaSegura(s.sgcod) loop
         contfs := contfs + 1;
       end loop;
   
       For mg in Movigas(s.sgcod) loop
         contmg := contmg + 1;
       end loop;
   
       For ve in vehicular(s.sgcod) loop
         contve := contve + 1;
       end loop;
   
       For mi in MicroCSL(s.sgcod) loop
         contmi := contmi + 1;
       end loop;
   
       For mu in MultiCSL(s.sgcod) loop
         contmu := contmu + 1;
       end loop;
   
       For mul in Multiriesgo(s.sgcod) loop
         contmul := contmul + 1;
       end loop;
   
       For de in Desgravamen(s.sgcod) loop
         contde := contde + 1;
       end loop;
    end loop;
        
    -- end loop;
  /*   pn_vc := contvc;
     pn_fs := contfs;
     pn_mg := contmg;
     pn_ve := contve;
     pn_csl := contmi;
     pn_csl1 := contmu;
     pn_multi := contmul;
     pn_des:= contde;*/

     pn_flag :='N';
 
     
     --- verifica Vida Caja
    pq_cr_resolutor_seg_vidacaja.sp_cr_contador_segvidacaja(pn_instancia,contvc);
    if  contvc > 1 then
       pn_flag :='S'; 
     end if;  
     if contfs >  1 then
       pn_flag :='S';
     end if;
      if  contmg > 1 then
       pn_flag :='S';
     end if;
     if contve >  1 then
       pn_flag :='S';
     end if;
      if  contmi > 1 then
       pn_flag :='S';
     end if;
     if contmu >  1 then
       pn_flag :='S';
     end if;
      if  contmul > 1 then
       pn_flag :='S';
     end if;
     if contde >  1 then
       pn_flag :='S';
     end if;

   end sp_cr_CONTADOR_DUPLICADO;
end PQ_CR_RESOLUTOR_CREDITOS;
/

