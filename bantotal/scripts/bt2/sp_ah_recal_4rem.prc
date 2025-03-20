create or replace procedure SP_AH_RECAL_4REM(P_D_FECPRO IN DATE,
                                             P_C_CODUSU IN VARCHAR2,
                                             P_N_CTAINI IN NUMBER,
                                             P_N_CTAFIN IN NUMBER
                                             ) is
                                             
cursor c_cuentas is
select * from AQPA129 gg
WHERE gg.sccta >= P_N_CTAINI
  and gg.sccta <= P_N_CTAFIN  ;
/*Select distinct gg.pgcod, gg.scmod, gg.scsuc, gg.scmda, gg.scpap, gg.sccta, gg.scoper, gg.scsbop, gg.sctope
  from fsd011 gg,
      (
        Select distinct qq.CTSPEMP1,
                        qq.CTSTEMP1,
                        qq.CTSNEMP1,
                        qq.CTSPEMP2,
                        qq.CTSTEMP2,
                        qq.CTSNEMP2,
                        qq.CTSCTAE2,
                        qq.CTSTIPRG,
                        qq.CTSFECRG,
                        qq.ctsimprm,
                        nvl(qq.ctsmdarm,0) ctsmdarm,
                        qq.ctsauxn2
          from cts001 qq,
               (Select rr.CTSPEMP1,
                       rr.CTSTEMP1,
                       rr.CTSNEMP1,
                       rr.CTSPEMP2,
                       rr.CTSTEMP2,
                       rr.CTSNEMP2,
                       rr.CTSCTAE2,
                       rr.CTSTIPRG,
                       rr.CTSFECRG,
                       max(rr.CTSHORRG) CTSHORRG
                  from cts001 rr
                 where rr.CTSTIPRG = 1
                   and rr.CTSPEMP1 > 0
                   and trim(rr.CTSNEMP2) is not null
                   and rr.CTSUSURG <> 'BANTOTAL'
                   and rr.CTSFECRG =
                       (Select max(trunc(kk.CTSFECRG))
                          from cts001 kk
                         where kk.CTSTIPRG = 1
                           and kk.CTSPEMP1 > 0
                           and trim(kk.CTSNEMP2) is not null
                           and kk.CTSUSURG <> 'BANTOTAL'
                           and kk.CTSPEMP1 = rr.CTSPEMP1
                           and kk.CTSTEMP1 = rr.CTSTEMP1
                           and kk.CTSNEMP1 = rr.CTSNEMP1
                           and kk.CTSPEMP2 = rr.CTSPEMP2
                           and kk.CTSTEMP2 = rr.CTSTEMP2
                           and kk.CTSNEMP2 = rr.CTSNEMP2
                           and kk.CTSCTAE2 = rr.CTSCTAE2
                           and kk.CTSTIPRG = rr.CTSTIPRG)
                 group by rr.CTSPEMP1,
                          rr.CTSTEMP1,
                          rr.CTSNEMP1,
                          rr.CTSPEMP2,
                          rr.CTSTEMP2,
                          rr.CTSNEMP2,
                          rr.CTSCTAE2,
                          rr.CTSTIPRG,
                          rr.CTSFECRG) ee
         where qq.CTSTIPRG = 1
           and qq.CTSPEMP1 > 0
           and qq.CTSUSURG <> 'BANTOTAL'
           and qq.CTSPEMP1 = ee.CTSPEMP1
           and qq.CTSTEMP1 = ee.CTSTEMP1
           and qq.CTSNEMP1 = ee.CTSNEMP1
           and qq.CTSPEMP2 = ee.CTSPEMP2
           and qq.CTSTEMP2 = ee.CTSTEMP2
           and qq.CTSNEMP2 = ee.CTSNEMP2
           and qq.CTSCTAE2 = ee.CTSCTAE2
           and qq.CTSTIPRG = ee.CTSTIPRG
           and qq.CTSFECRG = ee.CTSFECRG
           and qq.CTSHORRG = ee.CTSHORRG
           and trim(qq.CTSNEMP2) is not null
      ) zz   
where gg.pgcod = 1 
  and gg.scmod = 21
  and gg.scpap = 0  
  and gg.scoper = 0
  and gg.sctope = 2
  and gg.scsbop = trunc(zz.ctsauxn2/1000)    
  and gg.sccta = zz.CTSCTAE2
  and gg.sccta >= P_N_CTAINI
  and gg.sccta <= P_N_CTAFIN  
  and gg.scstat <> 99;--44901
*/ 
ln_mtorem    number(17,2):=0; 
lc_coderr    varchar2(400):=null;
lc_msgerr    varchar2(400):=null;
  
begin
  for i in c_cuentas loop
    ln_mtorem :=0;     
    lc_coderr :='000';   
    lc_msgerr :=null;      
    sp_ah_calculo_4rem(p_d_fecpro => P_D_FECPRO,
                       p_n_monabo => 0,
                       p_n_numcta => i.sccta,
                       p_n_subope => i.scsbop,
                       p_n_codmon => i.scmda,
                       p_n_codmod => 'INS',
                       p_n_mtorem => ln_mtorem,
                       p_c_coderr => lc_coderr,
                       p_c_msgerr => lc_msgerr
                      );  
  BEGIN
    INSERT INTO AQPA117
      (AQPA117PGC,
       AQPA117MOD,
       AQPA117SUC,
       AQPA117MDA,
       AQPA117PAP,
       AQPA117CTA,
       AQPA117OPE,
       AQPA117SBO,
       AQPA117TPO,
       AQPA117FEC,
       AQPA117REM,
       AQPA117COD,
       AQPA117MSG,
       AQPA117USR,
       AQPA117FSI,
       AQPA117HOR)
    VALUES
      (i.pgcod,
       i.scmod,
       i.scsuc,
       i.scmda,
       i.scpap,
       i.sccta,
       i.scoper,
       i.scsbop,
       i.sctope,
       P_D_FECPRO,
       ln_mtorem,
       lc_coderr,
       lc_msgerr,
       P_C_CODUSU,
       trunc(sysdate),
       to_char(sysdate, 'HH24:mi:ss'));
       commit;
  EXCEPTION
  when dup_val_on_index then
    UPDATE AQPA117 
       SET AQPA117REM = ln_mtorem,
           AQPA117COD = lc_coderr,
           AQPA117MSG = lc_msgerr,
           AQPA117USR = P_C_CODUSU,
           AQPA117FSI = trunc(sysdate),
           AQPA117HOR =  to_char(sysdate,'HH24:mi:ss')
     where AQPA117PGC = i.pgcod 
       and AQPA117MOD = i.scmod 
       and AQPA117SUC = i.scsuc
       and AQPA117MDA = i.scmda 
       and AQPA117PAP = i.scpap 
       and AQPA117CTA = i.sccta
       and AQPA117OPE = i.scoper 
       and AQPA117SBO = i.scsbop 
       and AQPA117TPO = i.sctope
       and AQPA117FEC = P_D_FECPRO;
       commit;
  WHEN OTHERS THEN
    NULL;
  END;                             
  end loop;
Exception
when Others then
  null;
end SP_AH_RECAL_4REM;
/

