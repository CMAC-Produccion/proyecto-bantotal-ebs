create or replace procedure sp_Reportes_Pago_cuota(P_C_USUARIO IN VARCHAR2,
                                                   P_D_FECINI IN DATE,              
                                                   P_D_FECFIN IN DATE,              
                                                   P_N_NUMAGE IN NUMBER,
                                                   P_C_USUAGE IN VARCHAR2,
                                                   P_C_TIPO   IN VARCHAR2	
                                                   ) is
 cursor  c_diario_ope is 
    select z.jaqz164usu,
           z.scnom, 
           z.ubnom,
           sum(z.total1) total1,
           sum(z.total2) total2,
           sum(z.total3) total3
      from (
            --numero de cuotas debitadas de cuentas afiliadas
            select a.jaqz164usu,
                   f.scnom, 
                   h.ubnom,
                   count(1) total1,
                   0        total2,
                   0        total3
              from jaqz164 a,
                   fsr601  b,
                   fsd015  c,
                   fsd016  d,       
                   fsd602  e,
                   fst001  f,
                   fst046  g,
                   fst746  h
             where a.jaqz164cpg = b.pp3cod
               and a.jaqz164cmo = b.pp3mod
               and a.jaqz164csu = b.pp3suc
               and a.jaqz164cmd = b.pp3mda
               and a.jaqz164cpa = b.pp3pap
               and a.jaqz164cct = b.pp3cta
               and a.jaqz164cop = b.pp3oper
               and a.jaqz164csb = b.pp3sbop
               and a.jaqz164cto = b.pp3tope
               and (a.jaqz164usu = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and a.jaqz164age = g.ubsuc
               and g.ubsuc      = f.sucurs
               and g.ubsuc      = P_N_NUMAGE
               and f.pgcod      = c.pgcod
               and g.ubuser     = a.jaqz164usu
               and a.jaqz164usu = h.ubuser     
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               and c.pgcod   = 1
               and c.itmod   = 35
               and c.ittran  = 60
               and d.Itcodm  <> 55 
               and c.pgcod   = d.pgcod
               and c.itmod   = d.itmod
               and c.itsuc   = d.itsuc
               and c.itsuc  = F.SUCURS
               and c.itsuc  = G.UBSUC               
               and c.ittran  = d.ittran
               and c.itnrel  = d.itnrel
               --and c.hfcon  = d.hfcon   
               --and c.hfcon between P_D_FECINI and P_D_FECFIN
               and d.modulo = b.pp4mod
               and d.ittope = b.pp4tope
               and d.itsucd = b.pp4suc
               and d.moneda = b.pp4mda
               and d.papel  = b.pp4pap
               and d.ctnro  = b.pp4cta
               and d.itoper = b.pp4oper 
               and d.itsubo = b.pp4sbop
               and c.itcorr <> 99   
               and e.d602cd = d.pgcod 
               and e.d602mo = d.itmod
               and e.d602su = d.itsuc
               and e.d602tr = d.ittran
               and e.d602re = d.itnrel
               --and e.d602fc = d.hfcon   
               and e.d602co = 'S'
               and e.pgcod  = d.pgcod 
               and e.ppmod  = b.pp3mod
               and e.ppsuc  = b.pp3suc
               and e.ppmda  = b.pp3mda
               and e.pppap  = b.pp3pap
               and e.ppcta  = b.pp3cta
               and e.ppoper = b.pp3oper
               and e.ppsbop = b.pp3sbop
               and e.pptope = b.pp3tope
            group by a.jaqz164usu,
                     f.scnom, 
                     h.ubnom
            union          
            --numero de desembolsos en cuentas tipo 9 afiliadas diario        
            select a.jaqz164usu,
                   f.scnom, 
                   h.ubnom,
                   0        total1,
                   count(1) total2,
                   0        total3       
              from jaqz164 a,
                   fsr601  b,
                   fsd015  c,
                   fsd016  d,       
                   --fsd602  e,
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where a.jaqz164cpg = b.pp3cod
               and a.jaqz164cmo = b.pp3mod
               and a.jaqz164csu = b.pp3suc
               and a.jaqz164cmd = b.pp3mda
               and a.jaqz164cpa = b.pp3pap
               and a.jaqz164cct = b.pp3cta
               and a.jaqz164cop = b.pp3oper
               and a.jaqz164csb = b.pp3sbop
               and a.jaqz164cto = b.pp3tope
               and (a.jaqz164usu = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and a.jaqz164age = P_N_NUMAGE
               and f.pgcod = c.pgcod
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                   --Para optimizar consulta               
               and g.ubuser = a.jaqz164usu
               and a.jaqz164usu = h.ubuser
               and f.sucurs = g.ubsuc
               and c.itsuc  = F.SUCURS
               and c.itsuc  = G.UBSUC               
               and x.Tp1cod = 1
               and d.Itcodm <> 55 
               and c.pgcod  = x.Tp1cod
               and c.itmod  = x.tp1nro1
               and c.ittran = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.itmod  = d.itmod
               and c.itsuc  = d.itsuc
               and c.ittran = d.ittran
               and c.itnrel = d.itnrel
               --and d.itord  = x.Tp1imp2
               and d.itord  = x.Tp1imp3
               and d.modulo = b.pp4mod
               and d.ittope = b.pp4tope
               and d.itsucd = b.pp4suc
               and d.moneda = b.pp4mda
               and d.papel  = b.pp4pap
               and d.ctnro  = b.pp4cta
               and d.itoper = b.pp4oper 
               and d.itsubo = b.pp4sbop
               and c.itcorr <> 99   
              /* and e.d602cd = d.pgcod 
               and e.d602mo = d.itmod
               and e.d602su = d.itsuc
               and e.d602tr = d.ittran
               and e.d602re = d.itnrel
               and e.d602fc = d.itfval  
               and e.d602co = 'S'
               and e.pgcod  = d.pgcod 
               and e.ppmod  = b.pp3mod
               and e.ppsuc  = b.pp3suc
               and e.ppmda  = b.pp3mda
               and e.pppap  = b.pp3pap
               and e.ppcta  = b.pp3cta
               and e.ppoper = b.pp3oper
               and e.ppsbop = b.pp3sbop
               and e.pptope = b.pp3tope
               and b.pp3tope = 9 */
               and b.pp4tope = 9 
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0            
            group by a.jaqz164usu,
                     f.scnom, 
                     h.ubnom
            union                  
            --numero de desembolsos en cuentas tipo 9 no afiliadas diario
            select c.itucnf,
                   f.scnom, 
                   h.ubnom,
                   0        total1,
                   0        total2,
                   count(1) total3
              from fsd015  c,
                   fsd016  d,       
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where(c.itucnf = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and c.pgcod  = d.pgcod
               and d.pgcod  = f.pgcod  
               and g.ubsuc  = P_N_NUMAGE
               and c.itucnf = g.ubuser
               and g.ubuser = h.ubuser
               and f.sucurs = g.ubsuc
               and c.itsuc  = F.SUCURS
               and c.itsuc  = G.UBSUC               
               and x.Tp1cod = 1
               and d.itcodm <> 55 
               and c.pgcod  = x.Tp1cod
               and c.itmod  = x.tp1nro1
               and c.ittran = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.itmod  = d.itmod
               and c.itsuc  = d.itsuc
               and c.ittran = d.ittran
               and c.itnrel = d.itnrel
               and d.itord  = x.Tp1imp3
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                 --Para optimizar consulta               
               and d.modulo = 21
               and d.ittope = 9
               and c.itcorr <> 99   
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0       
               and not exists (select 1 
                                 from fsr601 y 
                                where y.pp4cod  = c.pgcod 
                                  and y.pp4mod  = d.modulo
                                  and y.pp4suc  = d.itsucd
                                  and y.pp4mda  = d.moneda
                                  and y.pp4pap  = d.papel
                                  and y.pp4cta  = d.ctnro
                                  and y.pp4oper = d.itoper
                                  and y.pp4sbop = d.itsubo
                                  and y.pp4tope = d.ittope  
                              )    
            group by c.itucnf,
                     f.scnom, 
                     h.ubnom
        
            ) z
    group by z.jaqz164usu,                  
             z.scnom, 
             z.ubnom; 
 cursor  c_movimientos_ope_all is 
    select z.jaqz164usu,
           z.scnom, 
           z.ubnom,
           sum(z.total1) total1,
           sum(z.total2) total2,
           sum(z.total3) total3
      from (
            --numero de cuotas debitadas de cuentas afiliadas --siempre debe de estar en el historico
            select a.jaqz164usu,
                   f.scnom, 
                   h.ubnom,
                   count(1) total1,
                   0        total2,
                   0        total3
              from jaqz164 a,
                   fsr601  b,
                   fsh015  c,
                   fsh016  d,       
                   fsd602  e,
                   fst001  f,
                   fst046  g,
                   fst746  h
             where a.jaqz164cpg = b.pp3cod
               and a.jaqz164cmo = b.pp3mod
               and a.jaqz164csu = b.pp3suc
               and a.jaqz164cmd = b.pp3mda
               and a.jaqz164cpa = b.pp3pap
               and a.jaqz164cct = b.pp3cta
               and a.jaqz164cop = b.pp3oper
               and a.jaqz164csb = b.pp3sbop
               and a.jaqz164cto = b.pp3tope
               and (a.jaqz164usu = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and a.jaqz164age = g.ubsuc
               and g.ubsuc      = f.sucurs
               and g.ubsuc      = P_N_NUMAGE                              
               and f.pgcod = c.pgcod               
               and g.ubuser = a.jaqz164usu
               and c.hsucor = F.SUCURS
               and c.hsucor = G.UBSUC               
               and a.jaqz164usu = h.ubuser
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G               
               and c.pgcod  = 1
               and c.hcmod  = 35
               and c.htran  = 60
               and d.hcodmo <> 55 
               and c.pgcod  = d.pgcod
               and c.hcmod  = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran  = d.htran
               and c.hnrel  = d.hnrel
               and c.hfcon  = d.hfcon   
               and c.hfcon between P_D_FECINI and P_D_FECFIN
               and d.hmodul = b.pp4mod
               and d.htoper = b.pp4tope
               and d.hsucur = b.pp4suc
               and d.hmda   = b.pp4mda
               and d.hpap   = b.pp4pap
               and d.hcta   = b.pp4cta
               and d.hoper  = b.pp4oper 
               and d.hsubop = b.pp4sbop
               and c.hccorr <> 99   
               and e.d602cd = d.pgcod 
               and e.d602mo = d.hcmod
               and e.d602su = d.hsucor
               and e.d602tr = d.htran
               and e.d602re = d.hnrel
               and e.d602fc = d.hfcon   
               and e.d602co = 'S'
               and e.pgcod  = d.pgcod 
               and e.ppmod  = b.pp3mod
               and e.ppsuc  = b.pp3suc
               and e.ppmda  = b.pp3mda
               and e.pppap  = b.pp3pap
               and e.ppcta  = b.pp3cta
               and e.ppoper = b.pp3oper
               and e.ppsbop = b.pp3sbop
               and e.pptope = b.pp3tope
            group by a.jaqz164usu,
                     f.scnom, 
                     h.ubnom
            union         
            --numero de desembolsos en cuentas tipo 9 afiliadas         
            select a.jaqz164usu,
                   f.scnom, 
                   h.ubnom,
                   0        total1,
                   count(1) total2,
                   0        total3       
              from jaqz164 a,
                   fsr601  b,
                   fsh015  c,
                   fsh016  d,       
                   --fsd602  e,
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where a.jaqz164cpg = b.pp3cod
               and a.jaqz164cmo = b.pp3mod
               and a.jaqz164csu = b.pp3suc
               and a.jaqz164cmd = b.pp3mda
               and a.jaqz164cpa = b.pp3pap
               and a.jaqz164cct = b.pp3cta
               and a.jaqz164cop = b.pp3oper
               and a.jaqz164csb = b.pp3sbop
               and a.jaqz164cto = b.pp3tope
               and (a.jaqz164usu = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and a.jaqz164age = P_N_NUMAGE
               and f.pgcod = c.pgcod
               and g.ubuser = a.jaqz164usu
               and c.hsucor = F.SUCURS
               and c.hsucor = G.UBSUC               
               and a.jaqz164usu = h.ubuser
               and f.sucurs = g.ubsuc
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                 --Para optimizar consulta               
               and x.Tp1cod = 1
               and d.hcodmo <> 55 
               and c.pgcod  = x.Tp1cod
               and c.hcmod  = x.tp1nro1
               and c.htran  = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.hcmod  = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran  = d.htran
               and c.hnrel  = d.hnrel
               --and d.hcord  = x.Tp1imp2
               and d.hcord  = x.Tp1imp3
               and c.hfcon  = d.hfcon   
               and c.hfcon between P_D_FECINI and P_D_FECFIN
               and d.hmodul = b.pp4mod
               and d.htoper = b.pp4tope
               and d.hsucur = b.pp4suc
               and d.hmda   = b.pp4mda
               and d.hpap   = b.pp4pap
               and d.hcta   = b.pp4cta
               and d.hoper  = b.pp4oper 
               and d.hsubop = b.pp4sbop
               and c.hccorr <> 99   
               /*and e.d602cd = d.pgcod 
               and e.d602mo = d.hcmod
               and e.d602su = d.hsucor
               and e.d602tr = d.htran
               and e.d602re = d.hnrel
               and e.d602fc = d.hfcon   
               and e.d602co = 'S'
               and e.pgcod  = d.pgcod 
               and e.ppmod  = b.pp3mod
               and e.ppsuc  = b.pp3suc
               and e.ppmda  = b.pp3mda
               and e.pppap  = b.pp3pap
               and e.ppcta  = b.pp3cta
               and e.ppoper = b.pp3oper
               and e.ppsbop = b.pp3sbop
               and e.pptope = b.pp3tope
               and b.pp3tope = 9 */
               and b.pp4tope = 9 
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0            
            group by a.jaqz164usu,
                     f.scnom, 
                     h.ubnom
            union                  
            --numero de desembolsos en cuentas tipo 9 no afiliadas
            select c.huscnf,
                   f.scnom, 
                   h.ubnom,
                   0        total1,
                   0        total2,
                   count(1) total3
              from fsh015  c,
                   fsh016  d,       
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where(c.huscnf = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and c.pgcod  = d.pgcod
               and d.pgcod  = f.pgcod  
               and g.ubsuc  = P_N_NUMAGE
               and c.huscnf = g.ubuser
               and g.ubuser = h.ubuser
               and f.sucurs = g.ubsuc
               and c.hsucor = F.SUCURS
               and c.hsucor = G.UBSUC               
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                   --Para optimizar consulta                              
               and x.Tp1cod = 1
               and d.hcodmo <> 55 
               and c.pgcod  = x.Tp1cod
               and c.hcmod  = x.tp1nro1
               and c.htran  = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.hcmod  = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran  = d.htran
               and c.hnrel  = d.hnrel
               and d.hcord  = x.Tp1imp3
               and c.hfcon  = d.hfcon   
               and c.hfcon between P_D_FECINI and P_D_FECFIN
               and d.hmodul = 21
               and d.htoper = 9
               and c.hccorr <> 99   
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0       
               and not exists (select 1 
                                 from fsr601 y 
                                where y.pp4cod  = c.pgcod 
                                  and y.pp4mod  = d.hmodul
                                  and y.pp4suc  = d.hsucur
                                  and y.pp4mda  = d.hmda
                                  and y.pp4pap  = d.hpap
                                  and y.pp4cta  = d.hcta
                                  and y.pp4oper = d.hoper
                                  and y.pp4sbop = d.hsubop
                                  and y.pp4tope = d.htoper  
                              )    
            group by c.huscnf,
                     f.scnom, 
                     h.ubnom
            union                     
            --numero de desembolsos en cuentas tipo 9 afiliadas diario        
            select a.jaqz164usu,
                   f.scnom, 
                   h.ubnom,
                   0        total1,
                   count(1) total2,
                   0        total3       
              from jaqz164 a,
                   fsr601  b,
                   fsd015  c,
                   fsd016  d,       
                   --fsd602  e,
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where a.jaqz164cpg = b.pp3cod
               and a.jaqz164cmo = b.pp3mod
               and a.jaqz164csu = b.pp3suc
               and a.jaqz164cmd = b.pp3mda
               and a.jaqz164cpa = b.pp3pap
               and a.jaqz164cct = b.pp3cta
               and a.jaqz164cop = b.pp3oper
               and a.jaqz164csb = b.pp3sbop
               and a.jaqz164cto = b.pp3tope
               and (a.jaqz164usu = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and a.jaqz164age = P_N_NUMAGE
               and f.pgcod = c.pgcod
               and g.ubuser = a.jaqz164usu
               and a.jaqz164usu = h.ubuser
               and f.sucurs = g.ubsuc
               and c.itsuc = F.SUCURS
               and c.itsuc = G.UBSUC               
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                   --Para optimizar consulta                              
               and x.Tp1cod = 1
               and d.Itcodm <> 55 
               and c.pgcod  = x.Tp1cod
               and c.itmod  = x.tp1nro1
               and c.ittran = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.itmod  = d.itmod
               and c.itsuc  = d.itsuc
               and c.ittran = d.ittran
               and c.itnrel = d.itnrel
               --and d.itord  = x.Tp1imp2
               and d.itord  = x.Tp1imp3
               and d.modulo = b.pp4mod
               and d.ittope = b.pp4tope
               and d.itsucd = b.pp4suc
               and d.moneda   = b.pp4mda
               and d.papel   = b.pp4pap
               and d.ctnro   = b.pp4cta
               and d.itoper  = b.pp4oper 
               and d.itsubo = b.pp4sbop
               and c.itcorr <> 99   
              /* and e.d602cd = d.pgcod 
               and e.d602mo = d.itmod
               and e.d602su = d.itsuc
               and e.d602tr = d.ittran
               and e.d602re = d.itnrel
               and e.d602fc = d.itfval  
               and e.d602co = 'S'
               and e.pgcod  = d.pgcod 
               and e.ppmod  = b.pp3mod
               and e.ppsuc  = b.pp3suc
               and e.ppmda  = b.pp3mda
               and e.pppap  = b.pp3pap
               and e.ppcta  = b.pp3cta
               and e.ppoper = b.pp3oper
               and e.ppsbop = b.pp3sbop
               and e.pptope = b.pp3tope
               and b.pp3tope = 9 */
               and b.pp4tope = 9                
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0            
            group by a.jaqz164usu,
                     f.scnom, 
                     h.ubnom
            union                  
            --numero de desembolsos en cuentas tipo 9 no afiliadas diario
            select c.itucnf,
                   f.scnom, 
                   h.ubnom,
                   0        total1,
                   0        total2,
                   count(1) total3
              from fsd015  c,
                   fsd016  d,       
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where(c.itucnf = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and c.pgcod  = d.pgcod
               and d.pgcod  = f.pgcod  
               and g.ubsuc  = P_N_NUMAGE
               and c.itucnf = g.ubuser
               and g.ubuser = h.ubuser
               and f.sucurs = g.ubsuc
               and c.itsuc  = F.SUCURS
               and c.itsuc  = G.UBSUC	               
               and x.Tp1cod = 1
               and d.itcodm <> 55 
               and c.pgcod  = x.Tp1cod
               and c.itmod  = x.tp1nro1
               and c.ittran = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.itmod  = d.itmod
               and c.itsuc  = d.itsuc
               and c.ittran = d.ittran
               and c.itnrel = d.itnrel
               and d.itord  = x.Tp1imp3
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                 --Para optimizar consulta               
               and d.modulo = 21
               and d.ittope = 9
               and c.itcorr <> 99   
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0       
               and not exists (select 1 
                                 from fsr601 y 
                                where y.pp4cod  = c.pgcod 
                                  and y.pp4mod  = d.modulo
                                  and y.pp4suc  = d.itsucd
                                  and y.pp4mda  = d.moneda
                                  and y.pp4pap  = d.papel
                                  and y.pp4cta  = d.ctnro
                                  and y.pp4oper = d.itoper
                                  and y.pp4sbop = d.itsubo
                                  and y.pp4tope = d.ittope  
                              )    
            group by c.itucnf,
                     f.scnom, 
                     h.ubnom
        
            ) z
    group by z.jaqz164usu,                  
             z.scnom, 
             z.ubnom;
 cursor  c_movimientos_his_ope is  
    select z.jaqz164usu,
           z.scnom, 
           z.ubnom,
           sum(z.total1) total1,
           sum(z.total2) total2,
           sum(z.total3) total3
      from (
            --numero de cuotas debitadas de cuentas afiliadas
            select a.jaqz164usu,
                   f.scnom, 
                   h.ubnom,
                   count(1) total1,
                   0        total2,
                   0        total3
              from jaqz164 a,
                   fsr601  b,
                   fsh015  c,
                   fsh016  d,       
                   fsd602  e,
                   fst001  f,
                   fst046  g,
                   fst746  h
             where a.jaqz164cpg = b.pp3cod
               and a.jaqz164cmo = b.pp3mod
               and a.jaqz164csu = b.pp3suc
               and a.jaqz164cmd = b.pp3mda
               and a.jaqz164cpa = b.pp3pap
               and a.jaqz164cct = b.pp3cta
               and a.jaqz164cop = b.pp3oper
               and a.jaqz164csb = b.pp3sbop
               and a.jaqz164cto = b.pp3tope
               and (a.jaqz164usu = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and a.jaqz164age  = g.ubsuc
               and g.ubsuc       = f.sucurs
               and g.ubsuc       = P_N_NUMAGE     
               and c.hsucor      = F.SUCURS
               and c.hsucor      = G.UBSUC                         
               and f.pgcod       = c.pgcod
               and g.ubuser      = a.jaqz164usu
               and a.jaqz164usu  = h.ubuser
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G               
               and c.pgcod  = 1
               and c.hcmod  = 35
               and c.htran  = 60
               and d.hcodmo <> 55 
               and c.pgcod  = d.pgcod
               and c.hcmod  = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran  = d.htran
               and c.hnrel  = d.hnrel
               and c.hfcon  = d.hfcon   
               and c.hfcon between P_D_FECINI and P_D_FECFIN
               and d.hmodul = b.pp4mod
               and d.htoper = b.pp4tope
               and d.hsucur = b.pp4suc
               and d.hmda   = b.pp4mda
               and d.hpap   = b.pp4pap
               and d.hcta   = b.pp4cta
               and d.hoper  = b.pp4oper 
               and d.hsubop = b.pp4sbop
               and c.hccorr <> 99   
               and e.d602cd = d.pgcod 
               and e.d602mo = d.hcmod
               and e.d602su = d.hsucor
               and e.d602tr = d.htran
               and e.d602re = d.hnrel
               and e.d602fc = d.hfcon   
               and e.d602co = 'S'
               and e.pgcod  = d.pgcod 
               and e.ppmod  = b.pp3mod
               and e.ppsuc  = b.pp3suc
               and e.ppmda  = b.pp3mda
               and e.pppap  = b.pp3pap
               and e.ppcta  = b.pp3cta
               and e.ppoper = b.pp3oper
               and e.ppsbop = b.pp3sbop
               and e.pptope = b.pp3tope
            group by a.jaqz164usu,
                     f.scnom, 
                     h.ubnom
            union         
            --numero de desembolsos en cuentas tipo 9 afiliadas         
            select a.jaqz164usu,
                   f.scnom, 
                   h.ubnom,
                   0        total1,
                   count(1) total2,
                   0        total3       
              from jaqz164 a,
                   fsr601  b,
                   fsh015  c,
                   fsh016  d,       
                   --fsd602  e,
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where a.jaqz164cpg = b.pp3cod
               and a.jaqz164cmo = b.pp3mod
               and a.jaqz164csu = b.pp3suc
               and a.jaqz164cmd = b.pp3mda
               and a.jaqz164cpa = b.pp3pap
               and a.jaqz164cct = b.pp3cta
               and a.jaqz164cop = b.pp3oper
               and a.jaqz164csb = b.pp3sbop
               and a.jaqz164cto = b.pp3tope
               and (a.jaqz164usu = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and a.jaqz164age = P_N_NUMAGE
               and f.pgcod = c.pgcod
               and g.ubuser = a.jaqz164usu
               and a.jaqz164usu = h.ubuser
               and f.sucurs = g.ubsuc
               and c.hsucor = F.SUCURS
               and c.hsucor = G.UBSUC               
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                   --Para optimizar consulta                              
               and x.Tp1cod = 1
               and d.hcodmo <> 55 
               and c.pgcod  = x.Tp1cod
               and c.hcmod  = x.tp1nro1
               and c.htran  = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.hcmod  = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran  = d.htran
               and c.hnrel  = d.hnrel
               --and d.hcord  = x.Tp1imp2
               and d.hcord  = x.Tp1imp3
               and c.hfcon  = d.hfcon   
               and c.hfcon between P_D_FECINI and P_D_FECFIN
               and d.hmodul = b.pp4mod
               and d.htoper = b.pp4tope
               and d.hsucur = b.pp4suc
               and d.hmda   = b.pp4mda
               and d.hpap   = b.pp4pap
               and d.hcta   = b.pp4cta
               and d.hoper  = b.pp4oper 
               and d.hsubop = b.pp4sbop
               and c.hccorr <> 99   
               /*and e.d602cd = d.pgcod 
               and e.d602mo = d.hcmod
               and e.d602su = d.hsucor
               and e.d602tr = d.htran
               and e.d602re = d.hnrel
               and e.d602fc = d.hfcon   
               and e.d602co = 'S'
               and e.pgcod  = d.pgcod 
               and e.ppmod  = b.pp3mod
               and e.ppsuc  = b.pp3suc
               and e.ppmda  = b.pp3mda
               and e.pppap  = b.pp3pap
               and e.ppcta  = b.pp3cta
               and e.ppoper = b.pp3oper
               and e.ppsbop = b.pp3sbop
               and e.pptope = b.pp3tope
               and b.pp3tope = 9 */
               and b.pp4tope = 9                
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0            
            group by a.jaqz164usu,
                     f.scnom, 
                     h.ubnom
            union                  
            --numero de desembolsos en cuentas tipo 9 no afiliadas
            select c.huscnf,
                   f.scnom, 
                   h.ubnom,
                   0        total1,
                   0        total2,
                   count(1) total3
              from fsh015  c,
                   fsh016  d,       
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where(c.huscnf = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and c.pgcod  = d.pgcod
               and d.pgcod  = f.pgcod  
               and g.ubsuc  = P_N_NUMAGE
               and c.huscnf = g.ubuser
               and g.ubuser = h.ubuser
               and f.sucurs = g.ubsuc
               and c.hsucor = F.SUCURS
               and c.hsucor = G.UBSUC               
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                   --Para optimizar consulta                              
               and x.Tp1cod = 1
               and d.hcodmo <> 55 
               and c.pgcod  = x.Tp1cod
               and c.hcmod  = x.tp1nro1
               and c.htran  = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.hcmod  = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran  = d.htran
               and c.hnrel  = d.hnrel
               and d.hcord  = x.Tp1imp3
               and c.hfcon  = d.hfcon   
               and c.hfcon between P_D_FECINI and P_D_FECFIN
               and d.hmodul = 21
               and d.htoper = 9
               and c.hccorr <> 99   
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0       
               and not exists (select 1 
                                 from fsr601 y 
                                where y.pp4cod  = c.pgcod 
                                  and y.pp4mod  = d.hmodul
                                  and y.pp4suc  = d.hsucur
                                  and y.pp4mda  = d.hmda
                                  and y.pp4pap  = d.hpap
                                  and y.pp4cta  = d.hcta
                                  and y.pp4oper = d.hoper
                                  and y.pp4sbop = d.hsubop
                                  and y.pp4tope = d.htoper  
                              )    
            group by c.huscnf,
                     f.scnom, 
                     h.ubnom
            ) z
    group by z.jaqz164usu,                  
             z.scnom, 
             z.ubnom;
             
 cursor c_diario_ana is
    --numero de desembolsos diarios a cuentas de ahorro corriente de creditos de analistas
    select fn_analista_credito(d.modulo,d.itsucd,d.moneda,d.papel,d.ctnro,d.itoper,d.itsubo,d.ittope) jaqz164usu,
           f.scnom, 
           h.ubnom,
           count(1) total1,
           0        total2,
           0        total3
      from fsd015  c,
           fsd016  d,       
           fst001  f,
           fst046  g,
           fst746  h,
           fst198  x
     where (fn_analista_credito(d.modulo,d.itsucd,d.moneda,d.papel,d.ctnro,d.itoper,d.itsubo,d.ittope) = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
       and c.pgcod  = d.pgcod
       and d.pgcod  = f.pgcod  
       and g.ubsuc  = P_N_NUMAGE
       --and c.itucnf = g.ubuser
       and g.ubuser = fn_analista_credito(d.modulo,d.itsucd,d.moneda,d.papel,d.ctnro,d.itoper,d.itsubo,d.ittope)
       and g.ubuser = h.ubuser
       and f.sucurs = g.ubsuc
       and c.itsuc  = F.SUCURS
       and c.itsuc  = G.UBSUC       
       AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
       AND C.PGCOD = 1                   --Para optimizar consulta                      
       and x.Tp1cod = 1
       and d.itcodm <> 55 
       and c.pgcod  = x.Tp1cod
       and c.itmod  = x.tp1nro1
       and c.ittran = x.tp1nro2
       and c.pgcod  = d.pgcod
       and c.itmod  = d.itmod
       and c.itsuc  = d.itsuc
       and c.ittran = d.ittran
       and c.itnrel = d.itnrel
       and d.itord  = x.Tp1imp2
       --and d.modulo = 21
       --and d.ittope = 9
       and c.itcorr <> 99   
       and x.Tp1cod1  = 10825
       and x.Tp1corr1 = 33
       and x.Tp1corr2 = 1
       and x.Tp1imp2  > 0
       and x.Tp1imp3  > 0       
       and exists (select 1 
                     from fsd016 ww
                    where ww.pgcod  = c.pgcod 
                      and ww.itmod  = c.itmod 
                      and ww.itsuc  = c.itsuc 
                      and ww.ittran = c.ittran
                      and ww.itnrel = c.itnrel
                      and ww.itord  = x.Tp1imp3
                      and ww.modulo = 21
                      and ww.ittope = 9
                  )        
    group by fn_analista_credito(d.modulo,d.itsucd,d.moneda,d.papel,d.ctnro,d.itoper,d.itsubo,d.ittope),
           f.scnom, 
           h.ubnom; 
           
 cursor c_movimientos_ana_all is
    select z.itucnf jaqz164usu,
           z.scnom, 
           z.ubnom,
           sum(z.total1) total1,
           sum(z.total2) total2,
           sum(z.total3) total3
      from (
            --numero de desembolsos diarios a cuentas de ahorro corriente de creditos de analistas
            select fn_analista_credito(d.modulo,d.itsucd,d.moneda,d.papel,d.ctnro,d.itoper,d.itsubo,d.ittope) itucnf,
                   f.scnom, 
                   h.ubnom,
                   count(1) total1,
                   0        total2,
                   0        total3
              from fsd015  c,
                   fsd016  d,       
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where (fn_analista_credito(d.modulo,d.itsucd,d.moneda,d.papel,d.ctnro,d.itoper,d.itsubo,d.ittope) = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and c.pgcod  = d.pgcod
               and d.pgcod  = f.pgcod  
               and g.ubsuc  = P_N_NUMAGE
               --and c.itucnf = g.ubuser
               and g.ubuser = fn_analista_credito(d.modulo,d.itsucd,d.moneda,d.papel,d.ctnro,d.itoper,d.itsubo,d.ittope)
               and g.ubuser = h.ubuser
               and f.sucurs = g.ubsuc
               and c.itsuc  = F.SUCURS
               and c.itsuc  = G.UBSUC               
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                   --Para optimizar consulta                              
               and x.Tp1cod = 1
               and d.itcodm <> 55 
               and c.pgcod  = x.Tp1cod
               and c.itmod  = x.tp1nro1
               and c.ittran = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.itmod  = d.itmod
               and c.itsuc  = d.itsuc
               and c.ittran = d.ittran
               and c.itnrel = d.itnrel
               and d.itord  = x.Tp1imp2
               --and d.modulo = 21
               --and d.ittope = 9
               and c.itcorr <> 99   
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0     
               and exists (select 1 
                             from fsd016 ww
                            where ww.pgcod  = c.pgcod 
                              and ww.itmod  = c.itmod 
                              and ww.itsuc  = c.itsuc 
                              and ww.ittran = c.ittran
                              and ww.itnrel = c.itnrel
                              and ww.itord  = x.Tp1imp3
                              and ww.modulo = 21
                              and ww.ittope = 9
                          )                    
          group by fn_analista_credito(d.modulo,d.itsucd,d.moneda,d.papel,d.ctnro,d.itoper,d.itsubo,d.ittope),
                   f.scnom, 
                   h.ubnom
          union               
            --numero de desembolsos historico a cuentas de ahorro corriente de creditos de analistas
            select fn_analista_credito(d.hmodul,d.hsucur,d.hmda,d.hpap,d.hcta,d.hoper,d.hsubop,d.htoper) itucnf,
                   f.scnom, 
                   h.ubnom,
                   count(1) total1,
                   0        total2,
                   0        total3
              from fsh015  c,
                   fsh016  d,       
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where (fn_analista_credito(d.hmodul,d.hsucur,d.hmda,d.hpap,d.hcta,d.hoper,d.hsubop,d.htoper) = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and c.pgcod  = d.pgcod
               and d.pgcod  = f.pgcod  
               and g.ubsuc  = P_N_NUMAGE
               --and c.huscnf = g.ubuser
               and g.ubuser = fn_analista_credito(d.hmodul,d.hsucur,d.hmda,d.hpap,d.hcta,d.hoper,d.hsubop,d.htoper)
               and g.ubuser = h.ubuser
               and f.sucurs = g.ubsuc
               and c.hsucor = F.SUCURS
               and c.hsucor = G.UBSUC               
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                   --Para optimizar consulta                              
               and x.Tp1cod = 1
               and d.hcodmo <> 55 
               and c.pgcod  = x.Tp1cod
               and c.hcmod  = x.tp1nro1
               and c.htran  = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.hcmod  = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran  = d.htran
               and c.hnrel  = d.hnrel
               and c.hfcon  = d.hfcon
               and d.hcord  = x.Tp1imp2             
               and d.hfcon between P_D_FECINI and P_D_FECFIN
               --and d.hmodul = 21
               --and d.htoper = 9
               and c.hccorr <> 99   
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0       
               and exists (select 1 
                             from fsh016 ww
                            where ww.pgcod  = c.pgcod 
                              and ww.hcmod  = c.hcmod 
                              and ww.hsucor = c.hsucor
                              and ww.htran  = c.htran 
                              and ww.hnrel  = c.hnrel 
                              and ww.hfcon  = c.hfcon 
                              and ww.hcord  = x.Tp1imp3
                              and ww.hmodul = 21
                              and ww.htoper = 9
                          )                  
          group by fn_analista_credito(d.hmodul,d.hsucur,d.hmda,d.hpap,d.hcta,d.hoper,d.hsubop,d.htoper),
                   f.scnom, 
                   h.ubnom
          union                
         -- numero de puntos por saldo promedio de cuentas de ahorro corriente afiliadas a debito automático POR MES CERRADO
          select fn_analista_credito(b.pp3mod,b.pp3suc,b.pp3mda,b.pp3pap,b.pp3cta,b.pp3oper,b.pp3sbop,b.pp3tope) itucnf,
                 f.scnom, 
                 h.ubnom,
                 0              total1,
                 sum(c.tp1imp3) total2,
                 0              total3
            from jaql483 a,
                 fsr601  b,
                 fst198  c,      
                 fst001  f,
                 fst046  g,
                 fst746  h                            
           where (fn_analista_credito(b.pp3mod,b.pp3suc,b.pp3mda,b.pp3pap,b.pp3cta,b.pp3oper,b.pp3sbop,b.pp3tope) = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
             and a.jaql483pgo = b.pp4cod
             and a.jaql483mod = b.pp4mod
             and a.jaql483suc = b.pp4suc
             and a.jaql483mda = b.pp4mda
             and a.jaql483pap = b.pp4pap
             and a.jaql483cta = b.pp4cta
             and a.jaql483ope = b.pp4oper
             and a.jaql483sbo = b.pp4sbop
             and a.jaql483tpo = b.pp4tope   
             AND g.PGCOD = C.TP1COD           --Para que tome la PK de la FST046  G
             AND C.TP1COD = 1                   --Para optimizar consulta                                          
             and a.jaql483mod = 21 
             and a.jaql483tpo = 9 
             and a.jaql483fch = last_day(add_months(P_D_FECFIN,-1))
             and f.pgcod      = a.jaql483pgo
             and f.sucurs     = g.ubsuc     
             and g.ubsuc      = P_N_NUMAGE
             and fn_analista_credito(b.pp3mod,b.pp3suc,b.pp3mda,b.pp3pap,b.pp3cta,b.pp3oper,b.pp3sbop,b.pp3tope) = g.ubuser         
             and g.ubuser     = h.ubuser
             and c.tp1nro1    = b.pp3mda
             and a.jaql483ax6 between c.tp1imp1 and c.tp1imp2                   
             and c.Tp1cod1    = 10825
             and c.Tp1corr1   = 45
             and c.Tp1corr2   = 5
        group by fn_analista_credito(b.pp3mod,b.pp3suc,b.pp3mda,b.pp3pap,b.pp3cta,b.pp3oper,b.pp3sbop,b.pp3tope),
                 f.scnom, 
                 h.ubnom
            ) z
    group by z.itucnf,                  
             z.scnom, 
             z.ubnom; 
 cursor c_movimientos_his_ana is
    select z.itucnf jaqz164usu,
           z.scnom, 
           z.ubnom,
           sum(z.total1) total1,
           sum(z.total2) total2,
           sum(z.total3) total3
      from (
            --numero de desembolsos cuentas de ahorro corriente de creditos de analistas his
            select fn_analista_credito(d.hmodul,d.hsucur,d.hmda,d.hpap,d.hcta,d.hoper,d.hsubop,d.htoper) itucnf,
                   f.scnom, 
                   h.ubnom,
                   count(1) total1,
                   0        total2,
                   0        total3
              from fsh015  c,
                   fsh016  d,       
                   fst001  f,
                   fst046  g,
                   fst746  h,
                   fst198  x
             where (fn_analista_credito(d.hmodul,d.hsucur,d.hmda,d.hpap,d.hcta,d.hoper,d.hsubop,d.htoper) = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
               and c.pgcod  = d.pgcod
               and d.pgcod  = f.pgcod  
               and g.ubsuc  = P_N_NUMAGE
               --and c.huscnf = g.ubuser
               and g.ubuser = fn_analista_credito(d.hmodul,d.hsucur,d.hmda,d.hpap,d.hcta,d.hoper,d.hsubop,d.htoper)
               and g.ubuser = h.ubuser
               and f.sucurs = g.ubsuc
               and c.hsucor = F.SUCURS
               and c.hsucor = G.UBSUC               
               AND g.PGCOD = C.PGCOD           --Para que tome la PK de la FST046  G
               AND C.PGCOD = 1                   --Para optimizar consulta                              
               and x.Tp1cod = 1
               and d.hcodmo <> 55 
               and c.pgcod  = x.Tp1cod
               and c.hcmod  = x.tp1nro1
               and c.htran  = x.tp1nro2
               and c.pgcod  = d.pgcod
               and c.hcmod  = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran  = d.htran
               and c.hnrel  = d.hnrel
               and c.hfcon  = d.hfcon
               and d.hcord  = x.Tp1imp2             
               and d.hfcon between P_D_FECINI and P_D_FECFIN
               --and d.hmodul = 21
               --and d.htoper = 9
               and c.hccorr <> 99   
               and x.Tp1cod1  = 10825
               and x.Tp1corr1 = 33
               and x.Tp1corr2 = 1
               and x.Tp1imp2  > 0
               and x.Tp1imp3  > 0       
               and exists (select 1 
                             from fsh016 ww
                            where ww.pgcod  = c.pgcod 
                              and ww.hcmod  = c.hcmod 
                              and ww.hsucor = c.hsucor
                              and ww.htran  = c.htran 
                              and ww.hnrel  = c.hnrel 
                              and ww.hfcon  = c.hfcon 
                              and ww.hcord  = x.Tp1imp3
                              and ww.hmodul = 21
                              and ww.htoper = 9
                          )                  
          group by fn_analista_credito(d.hmodul,d.hsucur,d.hmda,d.hpap,d.hcta,d.hoper,d.hsubop,d.htoper),
                   f.scnom, 
                   h.ubnom
          union                
         -- numero de puntos por saldo promedio de cuentas de ahorro corriente afiliadas a debito automático POR MES CERRADO
          select fn_analista_credito(b.pp3mod,b.pp3suc,b.pp3mda,b.pp3pap,b.pp3cta,b.pp3oper,b.pp3sbop,b.pp3tope) itucnf,
                 f.scnom, 
                 h.ubnom,
                 0              total1,
                 sum(c.tp1imp3) total2,
                 0              total3
            from jaql483 a,
                 fsr601  b,
                 fst198  c,      
                 fst001  f,
                 fst046  g,
                 fst746  h                            
           where (fn_analista_credito(b.pp3mod,b.pp3suc,b.pp3mda,b.pp3pap,b.pp3cta,b.pp3oper,b.pp3sbop,b.pp3tope) = rpad(P_C_USUAGE,10,' ') or trim(P_C_USUAGE) is null) 
             and a.jaql483pgo = b.pp4cod
             and a.jaql483mod = b.pp4mod
             and a.jaql483suc = b.pp4suc
             and a.jaql483mda = b.pp4mda
             and a.jaql483pap = b.pp4pap
             and a.jaql483cta = b.pp4cta
             and a.jaql483ope = b.pp4oper
             and a.jaql483sbo = b.pp4sbop
             and a.jaql483tpo = b.pp4tope    
             AND g.PGCOD = C.TP1COD           --Para que tome la PK de la FST046  G
             AND C.TP1COD = 1                   --Para optimizar consulta                                                                    
             and a.jaql483mod = 21 
             and a.jaql483tpo = 9 
             and a.jaql483fch = last_day(add_months(P_D_FECFIN,-1))
             and f.pgcod      = a.jaql483pgo
             and f.sucurs     = g.ubsuc     
             and g.ubsuc      = P_N_NUMAGE
             and fn_analista_credito(b.pp3mod,b.pp3suc,b.pp3mda,b.pp3pap,b.pp3cta,b.pp3oper,b.pp3sbop,b.pp3tope) = g.ubuser         
             and g.ubuser     = h.ubuser
             and c.tp1nro1    = b.pp3mda
             and a.jaql483ax6 between c.tp1imp1 and c.tp1imp2                   
             and c.Tp1cod1    = 10825
             and c.Tp1corr1   = 45
             and c.Tp1corr2   = 5
        group by fn_analista_credito(b.pp3mod,b.pp3suc,b.pp3mda,b.pp3pap,b.pp3cta,b.pp3oper,b.pp3sbop,b.pp3tope),
                 f.scnom, 
                 h.ubnom
            ) z
    group by z.itucnf,                  
             z.scnom, 
             z.ubnom;   
 cursor c_diario_age is             
   select '' jaqz164usu,
          b.scnom, 
          d.monom ubnom,   
          sum(a.scsdo) total1,
          0            total2,
          0            total3
     from fsd011 a,
          fst001 b,
          fst005 d
    where a.pgcod = b.pgcod
      and a.scsuc = P_N_NUMAGE
      and a.scmda = d.moneda
      and a.pgcod  = 1
      and a.scmod  = 21
      and a.sctope = 9
      and a.scstat <> 99
 group by d.monom,
          b.scnom;
          
 cursor c_historico_age is 
   select '' jaqz164usu,
          b.scnom, 
          d.monom ubnom,   
          sum(c.bcsdmo) total1,
          0             total2,
          0             total3
     from fst001 b,
          fsh012 c,
          fst005 d 
    where b.pgcod  = c.bcemp
      and b.sucurs = c.bcsuc
      and c.bcmda  = d.moneda
      and c.bcemp  = 1
      and c.bcfech = P_D_FECFIN
      and c.bcsuc  = P_N_NUMAGE
      and c.bcmod  = 21
      and c.bctop  = 9
 group by d.monom,
          b.scnom;
          
               
 ln_contador NUMBER;
 ld_fecpro   date;
begin
     ln_contador:= 1;
     delete from JAQZ335 where jaqz335codusu= P_C_USUARIO;
     commit;
     begin
       select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
     end;
     case
     When P_C_TIPO = 'O' then                
         Case
         When P_D_FECINI = P_D_FECFIN and P_D_FECFIN = ld_fecpro then               
           for g in c_diario_ope loop  
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing, --USUARIO
                 jaqz335destra, --AGENCIA
                 JAQZ335AUXC1,  --NOMBRE DEL USUARIO
                 JAQZ335AUXN1,  -- MONTO1
                 JAQZ335AUXN2,  -- MONTO2
                 JAQZ335AUXN3   -- MONTO3
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.jaqz164usu,
                 g.ubnom,
                 g.scnom,
                 g.total1,
                 g.total2,
                 g.total3
                 );
              ln_contador:=ln_contador + 1;
           end loop; 
         When P_D_FECINI <> P_D_FECFIN and P_D_FECFIN = ld_fecpro then        
           for g in c_movimientos_ope_all loop   
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing, --USUARIO
                 jaqz335destra, --AGENCIA
                 JAQZ335AUXC1,  --NOMBRE DEL USUARIO
                 JAQZ335AUXN1,  -- MONTO1
                 JAQZ335AUXN2,  -- MONTO2
                 JAQZ335AUXN3   -- MONTO3
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.jaqz164usu,
                 g.ubnom,
                 g.scnom,
                 g.total1,
                 g.total2,
                 g.total3
                 );
              ln_contador:=ln_contador + 1;
           end loop;                   
         else       
           for g in c_movimientos_his_ope loop   
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing, --USUARIO
                 jaqz335destra, --AGENCIA
                 JAQZ335AUXC1,  --NOMBRE DEL USUARIO
                 JAQZ335AUXN1,  -- MONTO1
                 JAQZ335AUXN2,  -- MONTO2
                 JAQZ335AUXN3   -- MONTO3
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.jaqz164usu,
                 g.ubnom,
                 g.scnom,
                 g.total1,
                 g.total2,
                 g.total3
                 );
              ln_contador:=ln_contador + 1;
           end loop;        
         End Case;      
     When P_C_TIPO = 'A' then
         Case
         When P_D_FECINI = P_D_FECFIN and P_D_FECFIN = ld_fecpro then               
           for g in c_diario_ana loop  
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing, --USUARIO
                 jaqz335destra, --AGENCIA
                 JAQZ335AUXC1,  --NOMBRE DEL USUARIO
                 JAQZ335AUXN1,  -- MONTO1
                 JAQZ335AUXN2,  -- MONTO2
                 JAQZ335AUXN3   -- MONTO3
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.jaqz164usu,
                 g.ubnom,
                 g.scnom,
                 g.total1,
                 g.total2,
                 g.total3
                 );
              ln_contador:=ln_contador + 1;
           end loop; 
         When P_D_FECINI <> P_D_FECFIN and P_D_FECFIN = ld_fecpro then        
           for g in c_movimientos_ana_all loop   
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing, --USUARIO
                 jaqz335destra, --AGENCIA
                 JAQZ335AUXC1,  --NOMBRE DEL USUARIO
                 JAQZ335AUXN1,  -- MONTO1
                 JAQZ335AUXN2,  -- MONTO2
                 JAQZ335AUXN3   -- MONTO3
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.jaqz164usu,
                 g.ubnom,
                 g.scnom,
                 g.total1,
                 g.total2,
                 g.total3
                 );
              ln_contador:=ln_contador + 1;
           end loop;                   
         else       
           for g in c_movimientos_his_ana loop   
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing, --USUARIO
                 jaqz335destra, --AGENCIA
                 JAQZ335AUXC1,  --NOMBRE DEL USUARIO
                 JAQZ335AUXN1,  -- MONTO1
                 JAQZ335AUXN2,  -- MONTO2
                 JAQZ335AUXN3   -- MONTO3
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.jaqz164usu,
                 g.ubnom,
                 g.scnom,
                 g.total1,
                 g.total2,
                 g.total3
                 );
              ln_contador:=ln_contador + 1;
           end loop;        
         End Case;              
     When P_C_TIPO = 'J' then
         Case
         When P_D_FECFIN = ld_fecpro then               
           for g in c_diario_age loop  
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing, --USUARIO
                 jaqz335destra, --AGENCIA
                 JAQZ335AUXC1,  --NOMBRE DEL USUARIO
                 JAQZ335AUXN1,  -- MONTO1
                 JAQZ335AUXN2,  -- MONTO2
                 JAQZ335AUXN3   -- MONTO3
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.jaqz164usu,
                 g.ubnom,
                 g.scnom,
                 g.total1,
                 g.total2,
                 g.total3
                 );
              ln_contador:=ln_contador + 1;
           end loop; 
         When P_D_FECFIN <> ld_fecpro then        
           for g in c_historico_age loop   
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing, --USUARIO
                 jaqz335destra, --AGENCIA
                 JAQZ335AUXC1,  --NOMBRE DEL USUARIO
                 JAQZ335AUXN1,  -- MONTO1
                 JAQZ335AUXN2,  -- MONTO2
                 JAQZ335AUXN3   -- MONTO3
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.jaqz164usu,
                 g.ubnom,
                 g.scnom,
                 g.total1,
                 g.total2,
                 g.total3
                 );
              ln_contador:=ln_contador + 1;
           end loop;                   
         else       
           null;           
         End Case;           
     Else
       null;
     End Case;         
     commit;
end sp_Reportes_Pago_cuota;
/

