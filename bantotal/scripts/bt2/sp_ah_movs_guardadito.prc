create or replace procedure sp_ah_movs_guardadito(P_C_USUARIO IN VARCHAR2,
                                                  P_N_CUENTA  IN NUMBER,
                                                  P_N_SUBOPE  IN NUMBER,
                                                  P_N_OPERAC  IN NUMBER,             
                                                  P_D_FECINI  IN DATE,
                                                  P_D_FECFIN  IN DATE
                                                 ) is
 cursor  c_diario is 
   select a.ituing Husing,
          a.itucnf Huscnf,
          b.itmod  Hcmod,
          b.ittran Htran,
          c.trnom  Trnom,
          a.itfcon Hfcon,
          a.ithora Hhora,
          b.moneda Hmda,
          b.itimp1 Hcimp1,         
          b.itoper Hoper,
          b.itnrel hnrel,          
          b.ctnro  hcta,          
          d.tp1imp1,
          b.itsuc  hsucor,
          b.itord  hcord, 
          b.itsbor hcsubo 
    from fsd015 a, 
         fsd016 b,
         fst034 c,
         fst198 d
   where a.pgcod    = b.pgcod
     and b.pgcod    = c.pgcod
     and a.itsuc    = b.itsuc
     and a.itmod    = b.itmod
     and b.itmod    = c.trmod
     and c.trmod    = d.Tp1nro1    
     and a.ittran   = b.ittran
     and b.ittran   = c.trnro
     and c.trnro    = d.Tp1nro2
     and a.itnrel   = b.itnrel
     and b.modulo   = d.Tp1nro3
     and b.rubro    = to_number(trim(d.tp1desc))
     and b.ctnro    = P_N_CUENTA
     and b.itsubo   = P_N_SUBOPE
     and b.itoper   = decode(P_N_OPERAC,0,b.itoper,P_N_OPERAC) 
     and a.itcont   = 'S'
     and b.pgcod    = 1
     and d.Tp1cod1  = 10825
     and d.Tp1corr1 = 53
     and d.Tp1corr2 = 1  
     and a.itcorr <> 99     
     ; 
 cursor c_movimientos_his is  
   select a.Husing Husing,
          a.Huscnf Huscnf,
          b.Hcmod  Hcmod,
          b.Htran  Htran,
          c.Trnom  Trnom,
          a.Hfcon  Hfcon,
          a.Hhora  Hhora,
          b.Hmda   Hmda,
          b.Hcimp1 Hcimp1,            
          b.hoper  Hoper,
          b.hnrel  hnrel,          
          b.hcta,    
          d.tp1imp1,
          b.hsucor hsucor,
          b.hcord  hcord,
          b.hcsubo hcsubo          
    from fsh015 a, 
         fsh016 b,
         fst034 c,
         fst198 d
   where a.pgcod    = b.pgcod
     and b.pgcod    = c.pgcod
     and c.pgcod    = d.tp1cod
     and a.hsucor   = b.hsucor
     and a.hcmod    = b.hcmod
     and b.hcmod    = c.trmod
     and c.trmod    = d.Tp1nro1                       
     and a.htran    = b.htran
     and b.htran    = c.trnro
     and c.trnro    = d.Tp1nro2
     and a.hnrel    = b.hnrel
     and a.hfcon    = b.hfcon
     and b.hmodul   = Tp1nro3
     and b.hrubro   = to_number(trim(d.tp1desc))
     and b.hcta     = P_N_CUENTA
     and b.hsubop   = P_N_SUBOPE
     and b.hoper    = decode(P_N_OPERAC,0,b.hoper,P_N_OPERAC)      
     and b.pgcod    = 1
     and d.Tp1cod1  = 10825
     and d.Tp1corr1 = 53
     and d.Tp1corr2 = 1  
     and a.Hfcon    > P_D_FECINI
     and a.Hfcon    < P_D_FECFIN;                                                      
     
 cursor c_movimientos_all is  
   select a.Husing Husing,
          a.Huscnf Huscnf,
          b.Hcmod  Hcmod,
          b.Htran  Htran,
          c.Trnom  Trnom,
          a.Hfcon  Hfcon,
          a.Hhora  Hhora,
          b.Hmda   Hmda,
          b.Hcimp1 Hcimp1,           
          b.hoper  Hoper,
          b.hnrel  hnrel,          
          b.hcta,    
          d.tp1imp1,
          b.hsucor hsucor,
          b.hcord  hcord,
          b.hcsubo hcsubo                     
    from fsh015 a, 
         fsh016 b,
         fst034 c,
         fst198 d
   where a.pgcod    = b.pgcod
     and b.pgcod    = c.pgcod
     and c.pgcod    = d.tp1cod
     and a.hsucor   = b.hsucor
     and a.hcmod    = b.hcmod
     and b.hcmod    = c.trmod
     and c.trmod    = d.Tp1nro1                       
     and a.htran    = b.htran
     and b.htran    = c.trnro
     and c.trnro    = d.Tp1nro2
     and a.hnrel    = b.hnrel
     and a.hfcon    = b.hfcon
     and b.hmodul   = Tp1nro3
     and b.hrubro   = to_number(trim(d.tp1desc))
     and b.hcta     = P_N_CUENTA
     and b.hsubop   = P_N_SUBOPE
     and b.hoper    = decode(P_N_OPERAC,0,b.hoper,P_N_OPERAC)           
     and b.pgcod    = 1
     and d.Tp1cod1  = 10825
     and d.Tp1corr1 = 53
     and d.Tp1corr2 = 1  
     and a.Hfcon    > P_D_FECINI
     and a.Hfcon    < P_D_FECFIN    
   Union
   select a.ituing Husing,
          a.itucnf Huscnf,
          b.itmod  Hcmod,
          b.ittran Htran,
          c.trnom  Trnom,
          a.itfcon Hfcon,
          a.ithora Hhora,
          b.moneda Hmda,
          b.itimp1 Hcimp1,         
          b.itoper Hoper,
          b.itnrel hnrel,          
          b.ctnro  hcta,          
          d.tp1imp1,
          b.itsuc  hsucor,
          b.itord  hcord,
          b.itsbor hcsubo            
    from fsd015 a, 
         fsd016 b,
         fst034 c,
         fst198 d
   where a.pgcod    = b.pgcod
     and b.pgcod    = c.pgcod
     and a.itsuc    = b.itsuc
     and a.itmod    = b.itmod
     and b.itmod    = c.trmod
     and c.trmod    = d.Tp1nro1    
     and a.ittran   = b.ittran
     and b.ittran   = c.trnro
     and c.trnro    = d.Tp1nro2
     and a.itnrel   = b.itnrel
     and b.modulo   = d.Tp1nro3
     and b.rubro    = to_number(trim(d.tp1desc))
     and b.ctnro    = P_N_CUENTA
     and b.itsubo   = P_N_SUBOPE
     and b.itoper   = decode(P_N_OPERAC,0,b.itoper,P_N_OPERAC)      
     and a.itcont   = 'S'
     and b.pgcod    = 1
     and d.Tp1cod1  = 10825
     and d.Tp1corr1 = 53
     and d.Tp1corr2 = 1  
     and a.itcorr <> 99          
     ; 
     
  
 ln_contador NUMBER;
 ld_fecpro date;
begin
     ln_contador:= 1;
     delete from JAQZ335 where jaqz335codusu= P_C_USUARIO;
     commit;
     begin
       select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
     end;
         Case
         When P_D_FECINI = P_D_FECFIN and P_D_FECFIN = ld_fecpro then               
           for g in c_diario loop  
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing,
                 jaqz335usucon,
                 jaqz335codmod,
                 jaqz335codtra,
                 jaqz335destra,
                 jaqz335fectra,
                 jaqz335hortra,
                 jaqz335mdatra,
                 jaqz335montra,
                 jaqz335auxn3,
                 jaqz335rela,
                 jaqz335cta,
                 jaqz335subope,
                 jaqz335auxn2,
                 JAQZ335AUXC3,
                 JAQZ335AUXC2
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.Husing,
                 g.Huscnf,
                 g.Hcmod,
                 g.Htran,
                 g.Trnom,
                 g.Hfcon,
                 g.Hhora,
                 g.Hmda,
                 g.Hcimp1,
                 g.Hoper,
                 g.hnrel,
                 g.hcta,
                 g.tp1imp1,
                 g.hsucor,
                 g.hcord,
                 g.hcsubo
                 );
              ln_contador:=ln_contador + 1;
           end loop; 
         When P_D_FECINI <> P_D_FECFIN and P_D_FECFIN = ld_fecpro then        
           for g in c_movimientos_all loop   
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing,
                 jaqz335usucon,
                 jaqz335codmod,
                 jaqz335codtra,
                 jaqz335destra,
                 jaqz335fectra,
                 jaqz335hortra,
                 jaqz335mdatra,
                 jaqz335montra,
                 jaqz335auxn3,
                 jaqz335rela,
                 jaqz335cta,
                 jaqz335subope,
                 jaqz335auxn2,
                 JAQZ335AUXC3,
                 JAQZ335AUXC2                                  
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.Husing,
                 g.Huscnf,
                 g.Hcmod,
                 g.Htran,
                 g.Trnom,
                 g.Hfcon,
                 g.Hhora,
                 g.Hmda,
                 g.Hcimp1,
                 g.Hoper,
                 g.hnrel,
                 g.hcta,
                 g.tp1imp1,
                 g.hsucor,
                 g.hcord,
                 g.hcsubo                           
                 );
              ln_contador:=ln_contador + 1;
           end loop;                   
         else       
           for g in c_movimientos_his loop   
              insert into JAQZ335
                (
                 jaqz335codusu,
                 jaqz335corr,
                 jaqz335usuing,
                 jaqz335usucon,
                 jaqz335codmod,
                 jaqz335codtra,
                 jaqz335destra,
                 jaqz335fectra,
                 jaqz335hortra,
                 jaqz335mdatra,
                 jaqz335montra,
                 jaqz335auxn3,
                 jaqz335rela,
                 jaqz335cta,
                 jaqz335subope,
                 jaqz335auxn2,
                 JAQZ335AUXC3,
                 JAQZ335AUXC2                 
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.Husing,
                 g.Huscnf,
                 g.Hcmod,
                 g.Htran,
                 g.Trnom,
                 g.Hfcon,
                 g.Hhora,
                 g.Hmda,
                 g.Hcimp1,
                 g.Hoper,
                 g.hnrel,
                 g.hcta,
                 g.tp1imp1,
                 g.hsucor,
                 g.hcord,
                 g.hcsubo                 
                 );
              ln_contador:=ln_contador + 1;
           end loop;        
         End Case;      
     commit;
end sp_ah_movs_guardadito;
/

