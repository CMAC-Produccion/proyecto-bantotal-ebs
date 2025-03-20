create or replace procedure sp_ah_rep_tesoreria(P_D_FECINI IN DATE,
                                                P_D_FECFIN IN DATE,
                                                P_C_CODUSU IN VARCHAR2,              
                                                p_c_coderr out varchar2,
                                                p_c_msgerr out varchar2
                                                ) is
  cursor c_teso is
    Select b.ctnom,
           a.AOCTA,
           a.AOOPER,
           a.AOMDA, 
           a.AOSBOP, 
           a.AOFVAL,
           a.AOFVTO,
           a.AOFE99,
           a.AOPZO,
           a.AOTASA,
           a.AOIMP,
           a.AONUME interes_pactado,
           a.AOIMP+a.AONUME total_pactado,
           (Select nvl(sum(x.SCSDO),0) from fsd011 x where x.PGCOD = a.PGCOD and x.SCCTA = a.aocta and x.SCOPER = a.AOOPER and x.scmod = 426 and x.SCSBOP = a.AOSBOP) interes_acumulado,
           (a.AOIMP + (Select nvl(sum(x.SCSDO),0) from fsd011 x where x.PGCOD = a.PGCOD and x.SCCTA = a.aocta and x.SCOPER = a.AOOPER and x.scmod = 426 and x.SCSBOP = a.AOSBOP)) Saldo_actual,
           decode(a.AOSTAT,99,'Cancelado','Vigente') estado,
           a.aosuc,
           a.aomod,
           a.aotope,
           a.AOPAP
           /*,
           DECODE((select 'S'
              from jaql478 y
             where y.jaql478EST = 'A'
               and y.jaql478cta = a.aocta
               and y.jaql478ope = a.aooper
               and rownum = 1
           ),NULL,'N','S') AFILIADO       */             
      from fsd010 a,
           fsd008 b
     where a.PGCOD = b.pgcod
       and a.AOCTA = b.ctnro  
       and a.pgcod = 1 
       and a.aomod = 22 
       and (a.aosuc = 904 or (a.AOCTA = 538187 and a.aosuc = 11))--sedapar no es sucursal 904
       and a.AOFVAL between P_D_FECINI and P_D_FECFIN
  order by a.AOFVAL,b.ctnom,a.AOCTA,a.AOOPER,a.AOSBOP;      
  /*                                            
  Cursor c_saldos is
   Select decode(X.BCMDA,0,'SOLES','DOLARES AMERICANOS') moneda,
          case
            when (x.bcmod = 21 and x.bctop = 2) or (x.bcmod = 201 and x.bctop = 0)then
             'CTS'
            when x.bcmod = 21 and x.bctop <> 2 then
             'AHORROS'
            when x.bcmod = 22 then
             'PLAZO FIJO'
            else
             null
          end producto,
          round(SUM(x.bcsdmo)/1000,0) saldo_en_miles
     from FSH012 X
    WHERE X.BCEMP = 1
      AND (X.BCMOD in (21, 22)
           or  
           (x.bcmod = 201 and x.bctop = 0)
          )
      and x.bcmda in (0, 101)
      AND X.BCSUC <> 904
      and x.bccta <> 999999999 
      AND X.BCFECH = P_D_FECFIN
      and (x.bccta, x.bcoper) not in
           (              
           select cc.jaql478cta, cc.jaql478ope
             from jaql478 cc                                                          
            where cc.jaql478MOD = x.bcmod
              and cc.jaql478EST = 'A'              
              )
    group by decode(X.BCMDA,0,'SOLES','DOLARES AMERICANOS'),
             case
               when (x.bcmod = 21 and x.bctop = 2) or (x.bcmod = 201 and x.bctop = 0)then
                'CTS'
               when x.bcmod = 21 and x.bctop <> 2 then
                'AHORROS'
               when x.bcmod = 22 then
                'PLAZO FIJO'
               else
                null
             end
order by  1 desc,2;   
*/  
ln_cont number(9):=0;
ln_tasa number(10,6):=0;
begin
  delete from jaqz187 where jaqz187usu = rpad(P_C_CODUSU,10,' ');
  COMMIT;
  ln_cont := 0;    
  for i in c_teso loop
    ln_cont := ln_cont + 1;
    begin
      -- Call the procedure
      pq_ah_productividad.tasa(vpgcod => 1,
                               vscsuc => i.aosuc,
                               vsccta => i.AOCTA,
                               vscmda => i.AOMDA,
                               vscpap => i.AOPAP,
                               vscoper => i.AOOPER,
                               vscsbop => i.AOSBOP,
                               vsctope => i.AOTOPE,
                               vscmod => i.AOMOD,
                               vsfval => i.aofval,
                               vmonto => i.aoimp,
                               vplazo => i.aopzo,
                               tasa => ln_tasa
                               );
    end;
    
    begin
      insert into jaqz187(jaqz187usu,
                          jaqz187cor,
                          jaqz187fec,
                          jaqz187hor,
                          jaqz187emp,
                          jaqz187cta,
                          jaqz187ope,
                          jaqz187mda,
                          jaqz187sbo,
                          jaqz187fva,
                          jaqz187ven,
                          jaqz187can,
                          jaqz187pzo,
                          jaqz187tas,
                          jaqz187imp,
                          jaqz187int,
                          jaqz187acu,
                          jaqz187est,
                          jaqz187ax1
                         )
                  values(P_C_CODUSU,
                         ln_cont,
                         trunc(sysdate),
                         to_char(sysdate,'HH24:mi:ss'),
                         i.ctnom,
                         i.AOCTA,
                         i.AOOPER,
                         i.AOMDA, 
                         i.AOSBOP, 
                         i.AOFVAL,
                         i.AOFVTO,
                         i.AOFE99,
                         i.AOPZO,
                         ln_tasa,
                         i.AOIMP,
                         i.interes_pactado,
                         i.interes_acumulado,
                         i.estado,
                         1
                         );
    exception
    when others then                     
      p_c_coderr := '001';
      p_c_msgerr := 'ERROR:'||SQLERRM;
      rollback;
      return;
    end;
  end loop;
  /*
  for j in c_saldos loop  
    ln_cont := ln_cont + 1;
    begin
      insert into jaqz187(jaqz187usu,
                          jaqz187cor,
                          jaqz187fec,
                          jaqz187hor,
                          jaqz187ax7,
                          jaqz187ax8,
                          jaqz187ax3,
                          jaqz187ax1
                         )
                  values(P_C_CODUSU,
                         ln_cont,
                         trunc(sysdate),
                         to_char(sysdate,'HH24:mi:ss'),
                         j.moneda,
                         j.producto,
                         j.saldo_en_miles,
                         2
                         );
    exception
    when others then                     
      p_c_coderr := '002';
      p_c_msgerr := 'ERROR:'||SQLERRM;
      rollback;
      return;                         
    end;    
  end loop;
  */
  commit;
exception
when others then                     
     p_c_coderr := '003';
     p_c_msgerr := 'ERROR:'||SQLERRM;
     rollback;
     return;  
end sp_ah_rep_tesoreria;
/

