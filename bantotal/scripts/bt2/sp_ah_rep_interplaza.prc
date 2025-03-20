create or replace procedure SP_AH_REP_INTERPLAZA(P_FECHAC IN DATE,
                                                 P_USUARIO IN VARCHAR2)is

 CURSOR DATOS (SUCURSAL IN NUMBER, FINICIAL DATE, FFINAL DATE) IS
  select h.hfcon,
       (select penom
          from fsd001
         where pepais = (select pepais from fsr008 where ctnro = f.hcta and ttcod = 1 and cttfir ='T' ) 
           and petdoc =  (select petdoc from fsr008 where ctnro = f.hcta and ttcod = 1 and cttfir ='T' ) 
           and pendoc = (select pendoc from fsr008 where ctnro = f.hcta and ttcod = 1 and cttfir ='T' ) 
       ) nombre,
       (select pendoc from fsr008 where ctnro = f.hcta and ttcod = 1 and cttfir ='T' ) DNI,
       (select scnom from fst001 where pgcod =1 and sucurs = h.hsucor) agencia,
       m.jaqy670mco comision,
       m.jaqy670mto monto,
       decode(a.tp1imp3,1,'Ventanilla','Agente') tipoCanal,
       f.hcta cuenta,
       f.pgcod pcod, 
       f.hcmod hmod,
       f.hsucor hsuc,
       f.htran htran,
       f.hnrel hrel,
       f.hfcon hfec
    from fsh016 f,
         fsh015 h,
         (select distinct tp1cod,tp1cod1,TP1NRO1,TP1NRO2,tp1imp3 
           from fst198 
          where tp1cod   = 1 
            and tp1cod1  = 10884
            and tp1corr1 = 3) a,
         jaqy670 m
   where h.pgcod = a.tp1cod 
     and h.hcmod = a.tp1nro1
     and h.hsucor = SUCURSAL  ---ingresar sucursal
     and h.htran = a.tp1nro2
     and h.hfcon  between FINICIAL and FFINAL --ingresar fecha
     and h.hccorr <> 99          ---PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, HCORD, HCSUBO---PGCOD, HSUCUR, HRUBRO, HFVCO
     and f.pgcod  = h.pgcod  
     and f.hcmod  = h.hcmod
     and f.hsucor = h.hsucor
     and f.htran  = h.htran
     and f.hnrel  = h.hnrel
     and f.hfcon = h.hfcon
     and f.hrubro in(5212290000074 ,5222290000074)---JAQY670PGC, JAQY670SUC, JAQY670MOD, JAQY670TRX, JAQY670REL, JAQY670FEC
     and m.jaqy670pgc = f.pgcod 
     and m.jaqy670suc = f.hsucor
     and m.jaqy670mod = f.hcmod
     and m.jaqy670trx = f.htran
     and m.jaqy670rel = f.hnrel
     and m.jaqy670fec = f.hfcon
     and m.jaqy670mco <> 0
     order by h.hfcon;
  cursor sucur is
  select sucurs, scnom from fst001 where pgcod = 1 
 --- and sucurs = 60
  Order by sucurs;
  
  /*cursor Datos_Historicos(modulo in number, agencia in number, tran in number, rel in number, fechac in date) is 
      select a.hmodul, a.htoper, a.hcsubo, a.htoper, a.hsucur, a.hmda, a.hpap, a.hcta
        from fsh016 a,
             fst198 b         
       where a.pgcod  = 1
         and a.hcmod  = modulo
         and a.hsucor = agencia
         and a.htran  = tran
         and a.hnrel  = rel
         and a.hfcon  = fechac
         and a.hmodul in (22,21)
         and b.tp1cod = 1
         and b.tp1cod1 = 10884
         and b.tp1corr1 = 3
         and b.tp1nro1 = a.hcmod
         and b.tp1nro2 = a.htran
         and b.tp1nro3 = a.hcord;*/
         
  ld_fini DATE;
  ld_Ffin  date;
  lc_CadenaCta varchar2(35);
  ln_monto    number(17,2);  
  lc_TipCta   varchar2(30);
 --- lc_usuario  varchar2(12);
  ln_salcie   number(17,2);
  ln_saldopro number(17,2);
  lc_moneda   varchar2(20);
  REGION      varchar2(40);
  begin
     
    select to_date('01'||TO_CHAR(P_FECHAC,'MM')|| TO_CHAR(P_FECHAC,'YYYY'),'dd/mm/yyyy') INTO LD_Fini FROM DUAL;
    select last_day(P_FECHAC)INTO LD_FFIN FROM DUAL;
    
    /*para pruebas
    LD_Fini := to_date('02/06/2016','dd/mm/yyyy');
    LD_FFIN := to_date('02/06/2016','dd/mm/yyyy');*/    
  --  lc_usuario := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);
  
    delete jaqy696 where jaqy696aux4 = P_usuario;
    commit;
    
    for age in sucur loop  
      Begin
        select f2.regnom 
          INTO REGION
          from fst811 f1,
               fst810 f2
          where f1.oficod = age.sucurs
            and f1.regcod < 100
            and f2.pgcod = 1
            and f2.regcod = f1.regcod
            and f2.regcod < 100;
      exception
        when no_data_found then
          region := to_char(age.sucurs)||' '|| age.scnom;      
      end;      
      
      for reg in DATOS(age.sucurs, ld_fini, ld_ffin) loop
        BEgin
            select --a.hmodul, a.htoper, a.hcsubo, a.htoper, a.hsucur, a.hmda, a.hpap, a.hcta, a.hoper
                   decode(a.hmodul,22, (Lpad(trim(to_char(a.hcta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( a.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(a.hoper)),9,'0') ||'-'|| Lpad(trim(to_char(a.htoper)),3,'0')),
                            (Lpad(trim(to_char(a.hcta)),9,'0') ||'-'|| Lpad(trim(to_char(a.hmodul)),3,'0') ||'-'|| Lpad(trim(to_char( a.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(a.hsubop)),2,'0') ||'-'|| Lpad(trim(to_char(a.htoper)),3,'0'))),
                   a.hcimp1,
                   (SELECT TONOM FROM FST004 WHERE MODULO =a.hmodul AND TOTOPE = a.htoper) tonom,
                   c.sbsdo saldo,
                   decode(a.hmda,101,'Dolares','Soles') moneda
              into lc_CadenaCta,
                   ln_monto,
                   lc_TipCta,
                   ln_salcie,
                   lc_moneda
              from fsh016 a,
                   fst198 b,
                   fsh021 c         
             where a.pgcod  = 1
               and a.hcmod  = reg.hmod
               and a.hsucor = reg.hsuc
               and a.htran  = reg.htran
               and a.hnrel  = reg.hrel
               and a.hfcon  = reg.hfcon
               and a.hmodul in (22,21)
               and b.tp1cod = 1
               and b.tp1cod1 = 10884
               and b.tp1corr1 = 3
               and b.tp1nro1 = a.hcmod
               and b.tp1nro2 = a.htran
               and b.tp1nro3 = a.hcord
               and c.sbcod(+)  = a.pgcod
               and c.sbmod(+) = a.hmodul
               and c.sbsuc(+) = a.hsucur
               and c.sbmda(+) = a.hmda
               and c.sbpap(+) = a.hpap
               and c.sbcta(+) = a.hcta
               and c.sboper(+) = a.hoper
               and c.sbtope(+) = a.htoper
               and c.sbsbop(+) = a.hcsubo
               and c.sbfech(+) = a.hfcon
               and rownum = 1;
         Exception
           when no_Data_found then
             lc_CadenaCta:= 'Sin cuenta';
                   ln_monto:= 0; 
         end;    
         BEgin
            select c.jaql483tot
              into ln_saldopro
              from fsh016 a,
                   fst198 b,
                   jaql483 c         
             where a.pgcod  = 1
               and a.hcmod  = reg.hmod
               and a.hsucor = reg.hsuc
               and a.htran  = reg.htran
               and a.hnrel  = reg.hrel
               and a.hfcon  = reg.hfcon
               and a.hmodul in (22,21)
               and b.tp1cod = 1
               and b.tp1cod1 = 10884
               and b.tp1corr1 = 3
               and b.tp1nro1 = a.hcmod
               and b.tp1nro2 = a.htran
               and b.tp1nro3 = a.hcord
               and c.jaql483pgo = a.pgcod
               and c.jaql483mod = a.hmodul
               and c.jaql483suc = a.hsucur
               and c.jaql483mda = a.hmda
               and c.jaql483pap = a.hpap
               and c.jaql483cta = a.hcta
               and c.jaql483ope = a.hoper
               and c.jaql483tpo = a.htoper
               and c.jaql483sbo = a.hsubop
               and c.jaql483fch = (select last_day(P_FECHAC) FROM DUAL)
               and rownum = 1;
         Exception
           when no_Data_found then
                   ln_saldopro:= 0; 
         end;    
         
         INSERT INTO JAQY696 (jaqy696cod,
                              jaqy696cta,
                              jaqy696fec,
                              jaqy696cli,
                              jaqy696dni,
                              jaqy696suc,
                              jaqy696tcta,
                              jaqy696com,
                              jaqy696mop,
                              jaqy696tcan,
                              jaqy696scie,
                              jaqy696spro,
                              jaqy696aux4,
                              jaqy696aux5,
                              jaqy696aux6)
                     VALUES (SQ_AH_JAQY696.NEXTVAL,
                             lc_CadenaCta,
                             reg.hfcon,
                             reg.nombre,
                             reg.dni,
                             reg.agencia,
                             lc_TipCta,
                             reg.comision,
                             ln_monto,
                             reg.tipocanal,
                             ln_salcie,
                             ln_saldopro,
                             P_usuario,
                             Region,
                             lc_moneda);
       commit;                     
         
      end loop;  
    end loop;  
 
end SP_AH_REP_INTERPLAZA;
/

