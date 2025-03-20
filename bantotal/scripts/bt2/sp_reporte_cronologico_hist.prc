create or replace procedure sp_Reporte_Cronologico_Hist(P_C_USUARIO IN VARCHAR2,
                                                        P_D_FECPRO IN DATE,              
                                                        P_N_NUMAGE IN NUMBER,
                                                        P_C_USUAGE IN VARCHAR2,
                                                        P_C_TIPO   IN VARCHAR2	
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
              max((select 
                    max(
                    Case 
                    When d.tp1imp2 = 1 then
                         sum(x.itimp1) 
                    When d.tp1imp2 = 2 then
                         sum(x.itimp2) 
                    When d.tp1imp2 = 3 then
                         sum(x.itimp3) 
                    When d.tp1imp2 = 4 then
                         sum(x.itimp4) 
                    When d.tp1imp2 = 5 then
                         sum(x.itimp5) 
                    When d.tp1imp2 = 6 then
                         sum(x.itimp6) 
                    Else
                         0
                    End 
                    )     
                 from fsd016 x
                where x.pgcod  = b.pgcod 
                  and x.itsuc  = b.itsuc 
                  and x.itmod  = b.itmod 
                  and x.ittran = b.ittran 
                  and x.itnrel = b.itnrel 
                  --and x.itord  = d.tp1imp1 
                  and (x.itsbor,x.itord)  in ( Select yy.tp1corr3,yy.Tp1imp1 
                                      from fst198 yy 
                                     where yy.Tp1cod   = x.pgcod
                                       and yy.Tp1nro1  = x.itmod        
                                       and yy.Tp1nro2  = x.ittran                                     
                                       and yy.Tp1cod1  = 10801 
                                       and yy.Tp1corr1 = 31 
                                       and yy.Tp1corr2 > 0  
                                       and yy.Tp1cod   = 1
                                   )
             group by d.tp1imp2                  
               )) Hcimp1,         
          ''       Detalle,
          0        Hsubop,
          b.itnrel hnrel,          
          b.ctnro  hcta,  
          max(        
              case
               when b.modulo = 21 then
                  lpad(b.ctnro,9,'0')||lpad(b.modulo,3,'0')||lpad(b.moneda,3,'0')||lpad(b.itsubo,2,'0')||lpad(b.ittope,3,'0')
               when b.modulo = 22 then
                 lpad(b.ctnro,9,'0')||lpad(b.modulo,3,'0')||lpad(b.moneda,3,'0')||lpad(b.itoper,9,'0')||lpad(b.ittope,3,'0')               
               when ((b.modulo in (select modulo from fst111 where dscod=50)) or (b.modulo in (117, 141, 65))) then    
                 lpad(b.ctnro,9,'0')||lpad(b.moneda,3,'0')||lpad(b.itoper,9,'0')
               else
                 null
              end
          ) concatenado,          
         decode(a.itcorr,99,'S','N') extorno
    from fsd015 a, 
         fsd016 b,
         fst034 c,
         fst198 d
   where a.pgcod    = b.pgcod
     and b.pgcod    = c.pgcod
     and c.pgcod    = d.tp1cod                  
     and a.itsuc    = b.itsuc
     and a.itmod    = b.itmod
     and b.itmod    = c.trmod
     and c.trmod    = d.Tp1nro1    
     and a.ittran   = b.ittran
     and b.ittran   = c.trnro
     and c.trnro    = d.Tp1nro2
     and a.itnrel   = b.itnrel
     and b.itord    = d.Tp1nro3
     and a.itcont   = 'S'
     and b.pgcod    = 1
     and d.Tp1cod1  = 10801 
     and d.Tp1corr1 = 31 
     and d.Tp1corr2 > 0  
     and a.itsuc  = P_N_NUMAGE
     and (
          ((trim(a.Ituing) = trim(P_C_USUAGE) or trim(P_C_USUAGE) is null) 
             and 
            d.tp1imp3 = 1
          )
           OR 
          ((trim(a.Itucnf) = trim(P_C_USUAGE) or trim(P_C_USUAGE) is null)  
             and 
            d.tp1imp3 = 2
          )
         )     
 group by a.ituing,
          a.itucnf,
          b.itmod ,
          b.ittran,
          c.trnom ,
          a.itfcon,
          a.ithora,
          b.moneda,
          b.itnrel,
          b.ctnro,     
         decode(a.itcorr,99,'S','N')
order by ithora asc
     ; 
                                                    
 cursor c_movimientos is  --reporte cronologico 
   select a.Husing Husing,
          a.Huscnf Huscnf,
          b.Hcmod  Hcmod,
          b.Htran  Htran,
          c.Trnom  Trnom,
          a.Hfcon  Hfcon,
          a.Hhora  Hhora,
          b.Hmda   Hmda,
              max((select 
                      max(
                      Case 
                      When d.tp1imp2 = 1 then
                           sum(x.Hcimp1) 
                      When d.tp1imp2 = 2 then
                           sum(x.Hcimp2) 
                      When d.tp1imp2 = 3 then
                           sum(x.Hcimp3) 
                      When d.tp1imp2 = 4 then
                           sum(x.Hcimp4) 
                      When d.tp1imp2 = 5 then
                           sum(x.Hcimp5) 
                      When d.tp1imp2 = 6 then
                           sum(x.Hcimp6) 
                      Else
                           0
                      End       
                      )
                 from fsh016 x 
                where x.pgcod  = b.pgcod 
                  and x.hsucor = b.hsucor 
                  and x.hcmod  = b.hcmod 
                  and x.htran  = b.htran 
                  and x.hnrel  = b.hnrel 
                  and x.hfcon  = P_D_FECPRO
                  --and x.hcord  = d.tp1imp1 
                  and (x.hcsubo,x.hcord)  in ( Select yy.tp1corr3,yy.Tp1imp1 
                                      from fst198 yy 
                                     where yy.Tp1cod   = x.pgcod
                                       and yy.Tp1nro1  = x.hcmod        
                                       and yy.Tp1nro2  = x.htran                                     
                                       and yy.Tp1cod1  = 10801 
                                       and yy.Tp1corr1 = 31 
                                       and yy.Tp1corr2 > 0  
                                       and yy.Tp1cod   = 1
                                   )
             group by d.tp1imp2                  
               ))   Hcimp1,                   
          ''       Detalle,
          0        Hsubop,
          b.hnrel  hnrel,
          b.hcta,
          max(    
              case
               when b.hmodul = 21 then
                  lpad(b.hcta,9,'0')||lpad(b.hmodul,3,'0')||lpad(b.hmda,3,'0')||lpad(b.hsubop,2,'0')||lpad(b.htoper,3,'0')
               when b.hmodul = 22 then
                 lpad(b.hcta,9,'0')||lpad(b.hmodul,3,'0')||lpad(b.hmda,3,'0')||lpad(b.hoper,9,'0')||lpad(b.htoper,3,'0')               
               when ((b.hmodul in (select modulo from fst111 where dscod=50)) or (b.hmodul in (117, 141, 65))) then    
                 lpad(b.hcta,9,'0')||lpad(b.hmda,3,'0')||lpad(b.hoper,9,'0')
               else
                 null
              end
             ) concatenado,                            
         decode(a.hccorr,99,'S','N') extorno
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
     and b.hcord    = Tp1nro3
     and b.pgcod    = 1
     and d.Tp1cod1  = 10801 
     and d.Tp1corr1 = 31 
     and d.Tp1corr2 > 0  
     and a.Hsucor   = P_N_NUMAGE
     and a.Hfcon    = P_D_FECPRO  
     and (
          ((trim(a.Husing) = trim(P_C_USUAGE) or trim(P_C_USUAGE) is null) 
             and 
            d.tp1imp3 = 1
          )
           OR 
          ((trim(a.Huscnf) = trim(P_C_USUAGE) or trim(P_C_USUAGE) is null)  
             and 
            d.tp1imp3 = 2
          )
         )   
 group by a.Husing,
          a.Huscnf,
          b.Hcmod ,
          b.Htran ,
          c.Trnom ,
          a.Hfcon ,
          a.Hhora ,
          b.Hmda  ,
          b.hnrel ,
          b.hcta,    
         decode(a.hccorr,99,'S','N')                     
order by Hhora asc
     ; 
     
 cursor  c_diario_con is 
    select qq.Hfcon Hfcon,
           qq.Hcmod Hcmod,
           qq.Htran Htran,
           qq.Trnom Trnom,
           qq.Hmda  Hmda,
           sum(decode(nvl(qq.Hcimp1,0),0,0,1)) Hnrel,       
           sum(nvl(qq.Hcimp1,0))               Hcimp1              
      from
          (  
           select a.ituing Husing,
                  a.itucnf Huscnf,
                  b.itmod  Hcmod,
                  b.ittran Htran,
                  c.trnom  Trnom,
                  a.itfcon Hfcon,
                  a.ithora Hhora,
                  b.moneda Hmda,
                      max((select 
                            max(
                            Case 
                            When d.tp1imp2 = 1 then
                                 sum(x.itimp1) 
                            When d.tp1imp2 = 2 then
                                 sum(x.itimp2) 
                            When d.tp1imp2 = 3 then
                                 sum(x.itimp3) 
                            When d.tp1imp2 = 4 then
                                 sum(x.itimp4) 
                            When d.tp1imp2 = 5 then
                                 sum(x.itimp5) 
                            When d.tp1imp2 = 6 then
                                 sum(x.itimp6) 
                            Else
                                 0
                            End 
                            )     
                         from fsd016 x
                        where x.pgcod  = b.pgcod 
                          and x.itsuc  = b.itsuc 
                          and x.itmod  = b.itmod 
                          and x.ittran = b.ittran 
                          and x.itnrel = b.itnrel 
                          --and x.itord  = d.tp1imp1 
                          and (x.itsbor,x.itord)  in ( Select yy.tp1corr3,yy.Tp1imp1                           
                                              from fst198 yy 
                                             where yy.Tp1cod   = x.pgcod
                                               and yy.Tp1nro1  = x.itmod        
                                               and yy.Tp1nro2  = x.ittran                                     
                                               and yy.Tp1cod1  = 10801 
                                               and yy.Tp1corr1 = 31 
                                               and yy.Tp1corr2 > 0  
                                               and yy.Tp1cod   = 1
                                           )
                     group by d.tp1imp2                          
                       )) Hcimp1,         
                  ''       Detalle,
                  0        Hsubop,
                  b.itnrel hnrel,          
                  b.ctnro  hcta,  
                  max(        
                      case
                       when b.modulo = 21 then
                          lpad(b.ctnro,9,'0')||lpad(b.modulo,3,'0')||lpad(b.moneda,3,'0')||lpad(b.itsubo,2,'0')||lpad(b.ittope,3,'0')
                       when b.modulo = 22 then
                         lpad(b.ctnro,9,'0')||lpad(b.modulo,3,'0')||lpad(b.moneda,3,'0')||lpad(b.itoper,9,'0')||lpad(b.ittope,3,'0')               
                       when ((b.modulo in (select modulo from fst111 where dscod=50)) or (b.modulo in (117, 141, 65))) then    
                         lpad(b.ctnro,9,'0')||lpad(b.moneda,3,'0')||lpad(b.itoper,9,'0')
                       else
                         null
                      end
                  ) concatenado,          
                 decode(a.itcorr,99,'S','N') extorno
            from fsd015 a, 
                 fsd016 b,
                 fst034 c,
                 fst198 d
           where a.pgcod    = b.pgcod
             and b.pgcod    = c.pgcod
             and c.pgcod    = d.tp1cod             
             and a.itsuc    = b.itsuc
             and a.itmod    = b.itmod
             and b.itmod    = c.trmod
             and c.trmod    = d.Tp1nro1    
             and a.ittran   = b.ittran
             and b.ittran   = c.trnro
             and c.trnro    = d.Tp1nro2
             and a.itnrel   = b.itnrel
             and b.itord    = d.Tp1nro3
             and a.itcont   = 'S'
             and b.pgcod    = 1
             and d.Tp1cod1  = 10801 
             and d.Tp1corr1 = 31 
             and d.Tp1corr2 > 0  
             and a.itsuc    = P_N_NUMAGE
             and a.itcorr  <> 99
             and (
                  ((trim(a.Ituing) = trim(P_C_USUAGE) or trim(P_C_USUAGE) is null) 
                     and 
                    d.tp1imp3 = 1
                  )
                   OR 
                  ((trim(a.Itucnf) = trim(P_C_USUAGE) or trim(P_C_USUAGE) is null)  
                     and 
                    d.tp1imp3 = 2
                  )
                 )     
         group by a.ituing,
                  a.itucnf,
                  b.itmod ,
                  b.ittran,
                  c.trnom ,
                  a.itfcon,
                  a.ithora,
                  b.moneda,
                  b.itnrel,
                  b.ctnro,     
                 decode(a.itcorr,99,'S','N')
          ) qq 
  group by qq.Hfcon, 
           qq.Hcmod, 
           qq.Htran, 
           qq.Trnom, 
           qq.Hmda
  order by 2, 3, 5;     
  
 cursor c_movimientos_con is  --reporte cronologico 
    select qq.Hfcon Hfcon,
           qq.Hcmod Hcmod,
           qq.Htran Htran,
           qq.Trnom Trnom,
           qq.Hmda  Hmda,
           sum(decode(nvl(qq.Hcimp1,0),0,0,1)) Hnrel,       
           sum(nvl(qq.Hcimp1,0))               Hcimp1              
      from
          ( 
           select a.Husing Husing,
                  a.Huscnf Huscnf,
                  b.Hcmod  Hcmod,
                  b.Htran  Htran,
                  c.Trnom  Trnom,
                  a.Hfcon  Hfcon,
                  a.Hhora  Hhora,
                  b.Hmda   Hmda,
                     max((select 
                              max(
                              Case 
                              When d.tp1imp2 = 1 then
                                   sum(x.Hcimp1) 
                              When d.tp1imp2 = 2 then
                                   sum(x.Hcimp2) 
                              When d.tp1imp2 = 3 then
                                   sum(x.Hcimp3) 
                              When d.tp1imp2 = 4 then
                                   sum(x.Hcimp4) 
                              When d.tp1imp2 = 5 then
                                   sum(x.Hcimp5) 
                              When d.tp1imp2 = 6 then
                                   sum(x.Hcimp6) 
                              Else
                                   0
                              End       
                              )
                         from fsh016 x 
                        where x.pgcod  = b.pgcod 
                          and x.hsucor = b.hsucor 
                          and x.hcmod  = b.hcmod 
                          and x.htran  = b.htran 
                          and x.hnrel  = b.hnrel 
                          and x.hfcon  = P_D_FECPRO
                          --and x.hcord  = d.tp1imp1 
                          and (x.hcsubo,x.hcord)  in ( Select yy.tp1corr3,yy.Tp1imp1                           
                                              from fst198 yy 
                                             where yy.Tp1cod   = x.pgcod
                                               and yy.Tp1nro1  = x.hcmod        
                                               and yy.Tp1nro2  = x.htran                                     
                                               and yy.Tp1cod1  = 10801 
                                               and yy.Tp1corr1 = 31 
                                               and yy.Tp1corr2 > 0  
                                               and yy.Tp1cod   = 1
                                           )
                     group by d.tp1imp2                          
                       ))   Hcimp1,                   
                  ''       Detalle,
                  0        Hsubop,
                  b.hnrel  hnrel,
                  b.hcta,    
                 max( case
                   when b.hmodul = 21 then
                      lpad(b.hcta,9,'0')||lpad(b.hmodul,3,'0')||lpad(b.hmda,3,'0')||lpad(b.hsubop,2,'0')||lpad(b.htoper,3,'0')
                   when b.hmodul = 22 then
                     lpad(b.hcta,9,'0')||lpad(b.hmodul,3,'0')||lpad(b.hmda,3,'0')||lpad(b.hoper,9,'0')||lpad(b.htoper,3,'0')               
                   when ((b.hmodul in (select modulo from fst111 where dscod=50)) or (b.hmodul in (117, 141, 65))) then    
                     lpad(b.hcta,9,'0')||lpad(b.hmda,3,'0')||lpad(b.hoper,9,'0')
                   else
                     null
                  end) concatenado,                            
                 decode(a.hccorr,99,'S','N') extorno
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
             and b.hcord    = Tp1nro3
             and b.pgcod    = 1
             and d.Tp1cod1  = 10801 
             and d.Tp1corr1 = 31 
             and d.Tp1corr2 > 0  
             and a.Hsucor   = P_N_NUMAGE
             and a.Hfcon    = P_D_FECPRO
             and a.hccorr  <> 99
             and (
                  ((trim(a.Husing) = trim(P_C_USUAGE) or trim(P_C_USUAGE) is null) 
                     and 
                    d.tp1imp3 = 1
                  )
                   OR 
                  ((trim(a.Huscnf) = trim(P_C_USUAGE) or trim(P_C_USUAGE) is null)  
                     and 
                    d.tp1imp3 = 2
                  )
                 )               
         group by a.Husing,
                  a.Huscnf,
                  b.Hcmod ,
                  b.Htran ,
                  c.Trnom ,
                  a.Hfcon ,
                  a.Hhora ,
                  b.Hmda  ,
                  b.hnrel ,
                  b.hcta,    
                 decode(a.hccorr,99,'S','N')
          ) qq
  group by qq.Hfcon, 
           qq.Hcmod, 
           qq.Htran, 
           qq.Trnom, 
           qq.Hmda
  order by 2, 3, 5;
        
 ln_contador NUMBER;
begin
     ln_contador:= 1;
     delete from JAQZ335 where jaqz335codusu= P_C_USUARIO;
     commit;
     if P_C_TIPO = 'D' then
         if P_D_FECPRO <> to_date('01/01/0001','dd/mm/rrrr') then
           for g in c_movimientos loop  
             if g.Hcimp1 > 0 then    
              insert into JAQZ335
                (jaqz335codusu,
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
                 jaqz335dettra,
                 jaqz335subope,
                 jaqz335rela,
                 jaqz335cta,
                 jaqz335ctapr,
                 jaqz335indext
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
                 g.Detalle,
                 g.Hsubop,
                 g.hnrel,
                 g.hcta,
                 g.concatenado,
                 g.extorno
                 );
              end if;
              ln_contador:=ln_contador + 1;
           end loop; 
         else       
           for g in c_diario loop   
             if g.Hcimp1 > 0 then       
              insert into JAQZ335
                (jaqz335codusu,
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
                 jaqz335dettra,
                 jaqz335subope,
                 jaqz335rela,
                 jaqz335cta,
                 jaqz335ctapr,
                 jaqz335indext             
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
                 g.Detalle,
                 g.Hsubop,
                 g.hnrel,
                 g.hcta,
                 g.concatenado,
                 g.extorno             
                 );
               end if;
              ln_contador:=ln_contador + 1;
           end loop;        
         End if; 
     else --CONSOLIDADO
         if P_D_FECPRO <> to_date('01/01/0001','dd/mm/rrrr') then
           for g in c_movimientos_con loop      
              insert into JAQZ335
                (jaqz335codusu,
                 jaqz335corr,
                 jaqz335codmod,
                 jaqz335codtra,
                 jaqz335destra,
                 jaqz335fectra,
                 jaqz335mdatra,
                 jaqz335montra,
                 jaqz335rela
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.Hcmod,
                 g.Htran,
                 g.Trnom,
                 g.Hfcon,
                 g.Hmda,
                 g.Hcimp1,
                 g.hnrel
                 );
              ln_contador:=ln_contador + 1;
           end loop; 
         else       
           for g in c_diario_con loop      
              insert into JAQZ335
                (jaqz335codusu,
                 jaqz335corr,
                 jaqz335codmod,
                 jaqz335codtra,
                 jaqz335destra,
                 jaqz335mdatra,
                 jaqz335montra,
                 jaqz335rela
                 )
              values
                (P_C_USUARIO,
                 ln_contador,
                 g.Hcmod,
                 g.Htran,
                 g.Trnom,
                 g.Hmda,
                 g.Hcimp1,
                 g.hnrel
                 );
              ln_contador:=ln_contador + 1;
           end loop;        
         End if;            
     End If;     
     commit;
end sp_Reporte_Cronologico_Hist;
/

