create or replace package PQ_CR_CAMPANA_NORMALIZATE is

  -- Author  : MCANDIA
  -- Created : 06/12/2018  05:43:28 PM.
  -- Purpose : 
  -- Public type declarations

  procedure sp_cr_update_jaqy971(ld_fecProc in date);

  procedure sp_cr_procesa_jaqy971(ld_fecProc in date);

end PQ_CR_CAMPANA_NORMALIZATE;
/

create or replace package body PQ_CR_CAMPANA_NORMALIZATE is

  procedure sp_cr_update_jaqy971(ld_fecProc in date) is
  
    ld_fecha date := ld_fecProc - 1;
  
    cursor jaqy971 is
    
      select *
        from jaqy971
       where jaqy971.jaqy971usur = 'MASIVO'
         and jaqy971.jaqy971habi = 'S'
         and jaqy971.jaqy971fecr = ld_fecha
         and (jaqy971.jaqy971esta not in ('S', 'E') or
             jaqy971.jaqy971esta is null);
  
  begin
  
    for i in jaqy971 loop
      UPDATE jaqy971
         SET jaqy971.jaqy971usud = 'MASIVO',
             jaqy971.jaqy971fecd = ld_fecProc,
             jaqy971.jaqy971sucd = 2,
             jaqy971.jaqy971habi = 'N'
       WHERE JAQY971.JAQY971NCTA = i.jaqy971ncta
         and jaqy971.jaqy971oper = i.jaqy971oper
         and jaqy971.jaqy971fecr = i.jaqy971fecr;
    
      COMMIT;
    
    end loop;
  
    pq_cr_campana_normalizate.sp_cr_procesa_jaqy971(ld_fecProc);
  
  end sp_cr_update_jaqy971;

  procedure sp_cr_procesa_jaqy971(ld_fecProc in date) is
  
    ln_corr number := 0;
  
    cursor jaqy971_carga is
    
      select *
        from jaqy971
       where jaqy971.jaqy971usud = 'MASIVO'
         and jaqy971.jaqy971usur = 'MASIVO'
         and jaqy971.jaqy971fecr = ld_fecProc - 1;
  begin
  
    for i in jaqy971_carga loop
    
      begin
        select max(a.jaqy971corr)
          into ln_corr
          from jaqy971 a
         where a.jaqy971fecr = ld_fecProc
         ORDER BY a.jaqy971corr DESC;
      exception
        when others then
          ln_corr := 0;
      end;
    
      if ln_corr is null then
        ln_corr := 1;
      else
        ln_corr := ln_corr + 1;
      end if;
    
      insert into jaqy971
        (jaqy971fecr,
         jaqy971corr,
         jaqy971pgco,
         jaqy971mod,
         jaqy971sucu,
         jaqy971mda,
         jaqy971pape,
         jaqy971ncta,
         jaqy971oper,
         jaqy971sbop,
         jaqy971tope,
         jaqy971esta,
         jaqy971habi,
         jaqy971fect,
         jaqy971pgtr,
         jaqy971modt,
         jaqy971suct,
         jaqy971tran,
         jaqy971relt,
         jaqy971usur,
         jaqy971sucr,
         jaqy971usud,
         jaqy971fecd,
         jaqy971sucd,
         jaqy971mtop,
         jaqy971scap,
         jaqy971stat,
         jaqy971tipo)
      values
        (ld_fecProc,
         ln_corr,
         i.jaqy971pgco,
         i.jaqy971mod,
         i.jaqy971sucu,
         i.jaqy971mda,
         i.jaqy971pape,
         i.jaqy971ncta,
         i.jaqy971oper,
         i.jaqy971sbop,
         i.jaqy971tope,
         i.jaqy971esta,
         'S',
         i.jaqy971fect,
         i.jaqy971pgtr,
         i.jaqy971modt,
         i.jaqy971suct,
         i.jaqy971tran,
         i.jaqy971relt,
         i.jaqy971usur,
         i.jaqy971sucr,
         ' ',
         '01/01/0001',
         0,
         i.jaqy971mtop,
         i.jaqy971scap,
         i.jaqy971stat,
         i.jaqy971tipo);
      commit;
    end loop;
  
  end sp_cr_procesa_jaqy971;

end PQ_CR_CAMPANA_NORMALIZATE;
/

