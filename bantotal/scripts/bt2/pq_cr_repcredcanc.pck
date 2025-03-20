create or replace package pq_cr_RepCredCanc is

  -- Author  : MPOSTIGOC
  -- Created : 15/07/2016 01:53:00 p.m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_vigente(ln_pepais  in number,
                          ln_petdoc  in number,
                          ln_pendoc  in char,
                          lc_vigente out varchar2);
procedure sp_cr_num_vigente(ln_pepais  in number,
                          ln_petdoc  in number,
                          ln_pendoc  in char,
                          lc_crenumvigente out number,
                          lc_num_credi_vigente out number,
                          lc_linnumvigente out number);
  procedure sp_cr_calificacionsbs(ln_pendoc in char,
                                  sbs_cal_0 out varchar2,
                                  sbs_cal_1 out varchar2,
                                  sbs_cal_2 out varchar2,
                                  sbs_cal_3 out varchar2,
                                  sbs_cal_4 out varchar2);
  procedure sp_cr_segmentacion(ln_pepais  in number,
                               ln_petdoc  in number,
                               ln_pendoc  in char,
                               lc_descseg out varchar2);
  procedure sp_cr_padrejaqy970(ln_pepais  in number,
                               ln_petdoc  in number,
                               ln_pendoc  in char,
                               lc_vigente out varchar2,
                               lc_descseg out varchar2,
                               sbs_cal_0  out varchar2,
                               sbs_cal_1  out varchar2,
                               sbs_cal_2  out varchar2,
                               sbs_cal_3  out varchar2,
                               sbs_cal_4  out varchar2,
                               lc_crenumvigente out number,
                               lc_num_credi_vigente out number,
                                lc_linnumvigente out number);

end pq_cr_RepCredCanc;
/

create or replace package body pq_cr_RepCredCanc is

  procedure sp_cr_vigente(ln_pepais  in number,
                          ln_petdoc  in number,
                          ln_pendoc  in char,
                          lc_vigente out varchar2) is
  begin
    begin
      ---1
      select 'S'
        into lc_vigente
        from fsd010 f
       where PGCOD = 1
         and AOCTA in (select ctnro
                         from fsr008
                        where PGCOD = 1
                          and PEPAIS = ln_pepais --604
                          and PETDOC = ln_petdoc --21
                          and PENDOC = ln_pendoc --'29214497'
                          and ttcod = 1
                          and cttfir = 'T')
         and AOMOD in (select modulo
                         from fst111
                        where dscod = 50
                          and Modulo <> 29
                          and Modulo <> 120
                          and Modulo <> 144)
         and aostat <> 99
         and rownum = 1;
    exception
      when others then
        lc_vigente := 'N';
      
    end;
  
  end sp_cr_vigente;
  -------------------------------------------------------------------------
   procedure sp_cr_num_vigente(ln_pepais  in number,
                          ln_petdoc  in number,
                          ln_pendoc  in char,
                          lc_crenumvigente out number,
                          lc_num_credi_vigente out number,
                          lc_linnumvigente out number) is
  begin
   begin
    select count(case when d.aomod <> 117 and d.aostat <> 99 then 1 end) Vig,  
           count(case when d.aomod <> 117 and d.aostat = 99 then 1 end) Can,
           count(case when d.aomod = 117  and d.aofvto > trunc(sysdate) and d.aostat <> 99 then 1 end ) LVig 
           into lc_crenumvigente,lc_num_credi_vigente, lc_linnumvigente
      from fsr008 r join fsd010 d on d.pgcod = r.pgcod
                                 and d.aocta = r.ctnro
                                 and d.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120) union all select 117 from dual)
     where r.pepais = ln_pepais
       and r.petdoc = ln_petdoc
       and r.pendoc = ln_pendoc
       and r.ttcod = 1
       and r.cttfir = 'T';
  exception When Others Then
       lc_crenumvigente := 0;
       lc_num_credi_vigente:= 0;
       lc_linnumvigente:=0;
  end;

  
  end sp_cr_num_vigente;
  
  -------------------------------------------------------------------------
  procedure sp_cr_calificacionsbs(ln_pendoc in char,
                                  sbs_cal_0 out varchar2,
                                  sbs_cal_1 out varchar2,
                                  sbs_cal_2 out varchar2,
                                  sbs_cal_3 out varchar2,
                                  sbs_cal_4 out varchar2) is
  
    fecrcc varchar2(8);
  
  begin
  
    begin
      select tpnro
        into fecrcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      --2 
    
      select
      /*case
       when n_calif0=100
      then 'Normal'
      else
         'NULL'
      end
      ,
      case when n_calif1<>0
      then 'CPP'
      else
            'NULL'
      end
      , 
      
      case when n_calif2<>0
      then 'DUDOSO'
      else
                    'NULL'
      end
      ,
      
      case when n_calif3<>0
      then 'DEFICIENTE'
      else
                  'NULL'
      end,
      
      case when n_calif4<>0
      then 'PERDIDA'
      else
                   'NULL'
      end*/
       n_calif0, n_calif1, n_calif2, n_calif3, n_calif4
        into sbs_cal_0, sbs_cal_1, sbs_cal_2, sbs_cal_3, sbs_cal_4
 from CLDRCCI
       where d_fecpre = to_date(fecrcc, 'ddmmyyyy')
         and c_docide = ln_pendoc;
    exception
      when others then
        null;
      
    end;
    /* begin
    
      SELECT CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(sbs_cal_0,
                                                                            ' - '),
                                                                     sbs_cal_1),
                                                              ' - '),
                                                       sbs_cal_2),
                                                ' - '),
                                         sbs_cal_3),
                                  ' - '),
                           sbs_cal_4),
                    '  ')
        into lc_sbs_calfinal
        FROM DUAL;
    
    end;*/
  
  end sp_cr_calificacionsbs;

  --------------------------------------------------------------------------
  procedure sp_cr_segmentacion(ln_pepais  in number,
                               ln_petdoc  in number,
                               ln_pendoc  in char,
                               lc_descseg out varchar2) is
  
    --3
  
  begin
    begin
      select JAQY067NCAL
        into lc_descseg
        from jaqy067 ja067,
             (select Jaqy066calf
                from jaqy066
               where JAQY066PAIC = ln_pepais
                 and JAQY066TDOC = ln_petdoc
                 and jaqy066tndoc = ln_pendoc
                 AND jaqy066fecp = (select to_date(tp1nro1, 'ddmmyyyy')
                                      from fst198
                                     where tp1cod = 1
                                       and tp1cod1 = 10823
                                       and tp1corr1 = 8
                                       and tp1corr2 = 1
                                       and tp1corr3 = 1)
              
               order by jaqy066fecp desc) JAQ066
       where JA067.jaqy067ccal = JAQ066.Jaqy066calf;
    exception
      when others then
        null;
    end;
  end sp_cr_segmentacion;

  -----------------------------------------------------------------------------------
  procedure sp_cr_padrejaqy970(ln_pepais  in number,
                               ln_petdoc  in number,
                               ln_pendoc  in char,
                               lc_vigente out varchar2,
                               lc_descseg out varchar2,
                               sbs_cal_0  out varchar2,
                               sbs_cal_1  out varchar2,
                               sbs_cal_2  out varchar2,
                               sbs_cal_3  out varchar2,
                               sbs_cal_4  out varchar2,
                                lc_crenumvigente out number,
                               lc_num_credi_vigente out number,
                                lc_linnumvigente out number) is
  begin
    pq_cr_repcredcanc.sp_cr_vigente(ln_pepais,
                                    ln_petdoc,
                                    ln_pendoc,
                                    lc_vigente);
     pq_cr_repcredcanc.sp_cr_num_vigente(ln_pepais,
                          ln_petdoc,
                          ln_pendoc,
                          lc_crenumvigente,
                          lc_num_credi_vigente,
                          lc_linnumvigente);  
  
    pq_cr_repcredcanc.sp_cr_calificacionsbs(ln_pendoc,
                                            sbs_cal_0,
                                            sbs_cal_1,
                                            sbs_cal_2,
                                            sbs_cal_3,
                                            sbs_cal_4);
    pq_cr_repcredcanc.sp_cr_segmentacion(ln_pepais,
                                         ln_petdoc,
                                         ln_pendoc,
                                         lc_descseg);
                                         
                                       
                                         
  end sp_cr_padrejaqy970;

-------------------------------------------------------------------

end pq_cr_RepCredCanc;
/

