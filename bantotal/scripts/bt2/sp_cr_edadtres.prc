create or replace procedure SP_CR_EDADTRES(pc_user in varchar2,
                                           pc_tipo in varchar2) is

 cursor clientes (fecha in date,age1 in number, age2 in number)is
   SELECT G.PFFNAC fecha1,
          trunc((MONTHS_BETWEEN(fecha,G.pffnac)/12)) Age,
          trunc(mod((MONTHS_BETWEEN(fecha,G.pffnac)),12)) Mes,
        --  TRUNC(sysdate - add_months(G.pffnac,trunc((MONTHS_BETWEEN(sysdate,G.pffnac))))) DIA
          TRUNC(fecha-(add_months(G.pffnac,trunc((MONTHS_BETWEEN(fecha,G.pffnac)))))) DIA ,
          TRIM(g.pfape1)||' '||trim(g.pfape2)||' '||trim(g.pfnom1)||' '||trim(g.pfnom2) nombre,
          f.jaql964ins inst,
          g.pfpais pais,
          g.pftdoc tdoc,
          (select tdnom from fst014 where tdocum = g.pftdoc)tipodoc,
          g.pfndoc documento,
          (f.jaql964sao * (-1)) saldo,
          f.jaql964pgcod emp,
          f.jaql964mod modulo,
          f.jaql964suc sucur,
          f.jaql964mda mda,
          f.jaql964pap pap,
          f.jaql964cta cuenta,
          f.jaql964ope oper,
          f.jaql964sob subop,
          f.jaql964top tope
     FROM JAQL964 F
    INNER JOIN FSD002 G
       ON (F.Jaql964pai = G.PFPAIS AND F.JAQL964Tid = G.PFTDOC AND F.JAQL964DOC = G.PFNDOC)
    WHERE trunc((MONTHS_BETWEEN(fecha,G.pffnac)/12))>= AGE1--70
      and trunc((MONTHS_BETWEEN(fecha,G.pffnac)/12))< AGE2 --71
      and  f.jaql964ins is not null;



 fecha date;
 credito varchar(21);
 saldo number(17,2);
 nombre char(100);
 direccion char(140);

 departamento char(100);
 provincia char(100);
 distrito char(100);
 tasa number(10,3);
 mtoapr number(17,2);
 tipodoc char(20);
 verif number;
 usuario char(12);
 --codigo number;
 seguro number;
 lc_Stat char(1);
 edad varchar(50);
 age1 number;
 age2 number;
 fechaBan date;
 Begin
   usuario := pc_user;
   delete jaqz570;--- where jaqz570usr = usuario;se quito
   commit;
   select pgfape into fechaBan from fst017 where pgcod = 1;
   fecha := fechaBan;-- trunc(last_day(fechaBan )); SMA.210819
   if pc_tipo = 1 then
     age1 := 70;
     age2 := 71;
   else
     age1 := 75;
     age2 := 76;
   end if;

   For cl in clientes(fecha,age1,age2) loop
      if pc_tipo = 1 then
          -- codigo := 7;
           Begin
           select 1,p1.sgcod
             into verif, seguro
             from fpp001 p1,
                  fst198 f9
            where p1.pgcod = cl.emp
              and p1.aomod = cl.modulo
              and p1.aosuc = cl.sucur
              and p1.aomda = cl.mda
              and p1.aopap = cl.pap
              and p1.aocta = cl.cuenta
              and p1.aooper = cl.oper
              and p1.aosbop = cl.subop
              and p1.aotope = cl.tope
              and p1.sgcod = f9.tp1nro1
              and f9.tp1cod = 1
              and f9.Tp1cod1  = 10884
              and f9.Tp1corr1 = 7--codigo
              and f9.tp1corr2 = 0;
         exception
           when no_data_found then
             verif := 0;
         end;
     else
       --codigo := 8;          
           Begin
           select 1,p1.sgcod
             into verif, seguro
             from fpp001 p1,
                  fst198 f9
            where p1.pgcod = cl.emp
              and p1.aomod = cl.modulo
              and p1.aosuc = cl.sucur
              and p1.aomda = cl.mda
              and p1.aopap = cl.pap
              and p1.aocta = cl.cuenta
              and p1.aooper = cl.oper
              and p1.aosbop = cl.subop
              and p1.aotope = cl.tope
              and p1.sgcod = f9.tp1nro1
              and f9.tp1cod = 1
              and f9.Tp1cod1  = 10884
              and f9.Tp1corr1 in (7,8)--codigo
              and f9.tp1corr2 = 0;
         exception
           when no_data_found then
             verif := 0;
         end;
     end if;     
     Begin
         select max(pp1stat)
           into lc_Stat
           from fsd602
          where pgcod   = cl.emp
            and ppmod   = cl.modulo
            and ppsuc   = cl.sucur
            and ppmda   = cl.mda
            and pppap   = cl.pap
            and ppcta   = cl.cuenta
            and ppoper  = cl.oper
            and ppsbop  = cl.subop
            and pptope  = cl.tope
            and D602Co  = 'S'
            and ppfpag = (select max(x.ppfpag)
                               from fsd602 x
                              where x.pgcod   = cl.emp
                                and x.ppmod   = cl.modulo
                                and x.ppsuc   = cl.sucur
                                and x.ppmda   = cl.mda
                                and x.pppap   = cl.pap
                                and x.ppcta   = cl.cuenta
                                and x.ppoper  = cl.oper
                                and x.ppsbop  = cl.subop
                                and x.pptope  = cl.tope
                                and x.D602Co  = 'S');
       exception
         when no_data_found then
           lc_stat :='O';
       end;
     if verif = 1 and lc_stat ='T' then
       credito:= LPAD(to_char(cl.cuenta),9,'0')||LPAD(to_char(cl.oper),9,'0')||LPAD(to_char(cl.subop),3,'0');
          begin
             select c.sngc13dir dir,
                    (select DepNom from FST068 Where Pais = c.sngc13pdoc and DepCod = c.sngc13dpto) depto,
                    (select LocNom from FST070 Where Pais = c.sngc13pdoc and LocCod = c.sngc13prov) prov,
                    (select Fst071Dsc from FST071 Where Fst071Pai = c.sngc13pdoc and Fst071Col = c.sngc13dist) dist
               into direccion,
                    departamento,
                    provincia,
                    distrito
               from sngc13 c
              where c.sngc13pais = cl.pais
                and c.sngc13tdoc = cl.tdoc
                and c.sngc13ndoc = cl.documento
                and c. Docod = 1
                and c.sngc13Est = 'H';
           exception
             when no_Data_found then
               direccion := ' ';
               departamento := ' ';
               provincia := ' ';
               distrito := ' ';
           end;
         --monto aprobado
            mtoapr := pq_cr_tramdesgra.fn_montoAprobado(cl.inst);
            --tasa
            tasa := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(cl.emp,cl.modulo,cl.sucur,cl.mda,cl.pap,cl.cuenta,
                                                                cl.oper,cl.subop,cl.tope,mtoapr);
            edad := to_Char(cl.AGE)||'Años,'|| TO_CHAR(CL.MES)||' Meses y '||TO_CHAR(CL.DIA)||' Dias';
            Begin
               insert into jaqz570(jaqz570cred,
                                   jaqz570cta,
                                   jaqz570oper,
                                   jaqz570sldo,
                                   jaqz570tasa,
                                   jaqz570tipo,
                                   jaqz570ndo,
                                   jaqz570nom,
                                   jaqz570fnac,
                                   jaqz570dir,
                                   jaqz570dist,
                                   jaqz570prov,
                                   jaqz570depto,
                                   jaqz570usr,
                                   jaqz570SGCOD,
                                   jaqz570EDAD )
                            values (credito,cl.cuenta,cl.oper,cl.saldo,tasa,cl.tipodoc,
                                    cl.documento,cl.nombre,cl.fecha1,direccion,distrito,
                                    provincia,departamento,pc_user,seguro,edad);
            exception
              when dup_val_on_index then
                null;
            end;
          commit;
       end if;
   end loop;
end SP_CR_EDADTRES;
/

