create or replace package pq_cr_importa_eva is

  Procedure Sp_tieneCampania(pn_ins in number, pc_flg out char);
  procedure sp_importa(pn_ins in number, p_error out char);
end pq_cr_importa_eva;
/

create or replace package body pq_cr_importa_eva is

  Procedure Sp_tieneCampania(pn_ins in number, pc_flg out char) is
  
    ld_fec date;
    lc_flg char(1);
  begin
  
    begin
    
      select trunc(min(a.wfiteminit))
        into ld_fec
        from wfwrkitems a
       where a.wftaskcod = 3
         and a.wfinsprcid = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_flg
        from xwf700 a, sng001 b, jaqz697 c
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1'
         and a.xwfprcins = b.sng001inst
         and b.sng001cta = c.jaqz697cta
         and b.sng001pais = c.jaqz697pai
         and b.sng001tdoc = c.jaqz697tdo
         and b.sng001ndoc = c.jaqz697ndo
         and a.xwfmodulo = c.jaqz697mod
         and a.xwftipope = c.jaqz697top
         and c.jaqz697fan = ld_fec
         and c.jaqz697au5 = 'G'
         and rownum = 1;
    exception
      WHEN no_data_found THEN
        lc_flg := 'N';
        return;
        --when others then null;
    end;
  
    pc_flg := lc_flg;
  end Sp_tieneCampania;

  procedure sp_importa(pn_ins in number, p_error out char) is
  
    ld_fec     date;
    ln_eva     number(10);
    ln_nroeval number(10);
    ln_tmod    number(4);
    --p_error    char(100);
    ld_fecBDJ date;
    ln_moeBDJ number(4);
    ln_NumCor number(10);
  
  begin
  
    begin
      select trunc(min(a.wfiteminit))
        into ld_fec
        from wfwrkitems a
       where a.wftaskcod = 3
         and a.wfinsprcid = pn_ins;
    exception
      when others then
        null;
    end;
  
    --obtener ultima evaluacion
  
    BEGIN
      p_error := 'IMPORTACION EXITOSA';
    
      --debe retornar maxima evaluacion
      select c.sng021eval, c.sng021tmod
        into ln_nroeval, ln_tmod
        from sng021 c
       where c.sng021sol = pn_ins
         and c.sng021eval in (select max(d.sng021eval)
                                from sng021 d
                               where d.sng021sol = pn_ins);
    
    EXCEPTION
      WHEN no_data_found THEN
        p_error := 'No hay evaluacion registrada en Bantotal';
        return;
    END;
  
    begin
      select distinct c.jaqz697eva
        into ln_eva
        from xwf700 a, sng001 b, jaqz697 c
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1'
         and a.xwfprcins = b.sng001inst
         and b.sng001cta = c.jaqz697cta
         and b.sng001pais = c.jaqz697pai
         and b.sng001tdoc = c.jaqz697tdo
         and b.sng001ndoc = c.jaqz697ndo
         and a.xwfmodulo = c.jaqz697mod
         and a.xwftipope = c.jaqz697top
         and c.jaqz697fan = ld_fec
         and c.jaqz697au5 = 'G';
    exception
      WHEN no_data_found THEN
        p_error := 'No hay evaluacion registrada en Panel de Aprobados';
        return;
        --when others then null;
    end;
  
    begin
      select a.aqpa190afec, a.aqpa190atmod
        into ld_fecBDJ, ln_moeBDJ
        from aqpa190a_bdj a
       where a.aqpa190aeval = ln_eva;
    exception
      when others then
        null;
    end;
  
    if ln_moeBDJ = ln_tmod then
    
      delete from sng023 where sng021eval = ln_nroeval;
      commit;
    
      insert into sng023
        select ln_nroeval, a.aqpa190bcod, a.aqpa190bmto
          from aqpa190b_bdj a
         where a.aqpa190beval = ln_eva;
      commit;
    
      update sng021 a
         set a.sng021fec = ld_fecBDJ
       where a.sng021eval = ln_nroeval;
      commit;
    
      update SNG120
         set sng120fpag = ld_fecBDJ ---??
       where sng120ins = pn_ins
         and SNG120Tsk = 'EVALUACION';
      commit;
    
      if ln_tmod = 13 then
      
        delete from jaqy327 a where a.jaqy327inst = pn_ins;
        commit;
      
        select nvl(max(a.jaqy327corr), 1)
          into ln_NumCor
          from jaqy327 a
         where a.jaqy327fech = ld_fecBDJ;
      
        Insert into JAQY327
          (JAQY327CORR,
           JAQY327FECH,
           JAQY327HORA,
           JAQY327INST,
           JAQY327NEVA,
           JAQY327PAIS,
           JAQY327TDOC,
           JAQY327NDOC,
           JAQY327RUBR,
           JAQY327ESTA,
           JAQY327ENTI,
           JAQY327TCRE,
           JAQY327SDEU,
           JAQY327PLAZ,
           JAQY327TAZA,
           JAQY327CCALC,
           JAQY327GFIN,
           JAQY327FRCC,
           JAQY327DORI,
           JAQY327CHEK,
           JAQY327PERS,
           JAQY327RELA,
           JAQY327LINE,
           JAQY327AUX1,
           JAQY327AUX2,
           JAQY327AUX3,
           JAQY327AUX4,
           JAQY327AUX5,
           JAQY327AUX6,
           JAQY327AUX7,
           JAQY327AUX8,
           JAQY327AUX9,
           JAQY327MDA,
           JAQY327TLIN,
           JAQY327UTIL,
           JAQY327FLIN,
           JAQY327CPTN,
           JAQY327FAC1,
           JAQY327FAC2,
           JAQY327FAC3,
           JAQY327CENT)
        
          select ln_NumCor + rownum,
                 ld_fecBDJ,
                 a.jaqy327hora,
                 pn_ins,
                 ln_nroeval,
                 a.jaqy327pais,
                 a.jaqy327tdoc,
                 a.jaqy327ndoc,
                 a.jaqy327rubr,
                 a.jaqy327esta,
                 a.jaqy327enti,
                 a.jaqy327tcre,
                 a.jaqy327sdeu,
                 a.jaqy327plaz,
                 a.jaqy327taza,
                 a.jaqy327ccalc,
                 a.jaqy327gfin,
                 a.jaqy327frcc,
                 a.jaqy327dori,
                 a.jaqy327chek,
                 a.jaqy327pers,
                 a.jaqy327rela,
                 a.jaqy327line,
                 a.jaqy327aux1,
                 a.jaqy327aux2,
                 a.jaqy327aux3,
                 a.jaqy327aux4,
                 a.jaqy327aux5,
                 a.jaqy327aux6,
                 a.jaqy327aux7,
                 a.jaqy327aux8,
                 a.jaqy327aux9,
                 a.jaqy327mda,
                 a.jaqy327tlin,
                 a.jaqy327util,
                 a.jaqy327flin,
                 a.jaqy327cptn,
                 a.jaqy327fac1,
                 a.jaqy327fac2,
                 a.jaqy327fac3,
                 a.jaqy327cent
            from jaqy327_bdj a
           where a.jaqy327inst = ln_eva;
      
        commit;
      
      else
      
        delete from sng028 a where a.sng021eval = ln_nroeval;
        commit;
      
        insert into sng028
          select ln_nroeval,
                 a.aqpa190ccod,
                 a.aqpa190clin,
                 a.aqpa190cmto1,
                 a.aqpa190cmto2,
                 a.aqpa190cmto3,
                 a.aqpa190cmto4,
                 a.aqpa190cmda1,
                 a.aqpa190cmda2,
                 a.aqpa190cmda3,
                 a.aqpa190cmda4,
                 a.aqpa190ctxt1,
                 a.aqpa190ctxt2,
                 a.aqpa190ctxt3,
                 a.aqpa190ccon1,
                 a.aqpa190ccon2,
                 a.aqpa190ccon3,
                 a.aqpa190ccan1,
                 a.aqpa190ccan2,
                 a.aqpa190ccan3,
                 a.aqpa190ccan4,
                 a.aqpa190ctxl1,
                 a.aqpa190ctxl2,
                 a.aqpa190ctxl3
            from aqpa190c_bdj a
           where a.aqpa190ceval = ln_eva;
        commit;
      
        select nvl(max(Jaqz862Corr), 1)
          into ln_NumCor
          from Jaqz862
         where jaqz862Fech = ld_fecBDJ;
      
        Insert into JAQZ862
          (Jaqz862corr,
           Jaqz862fech,
           Jaqz862hora,
           Jaqz862inst,
           Jaqz862neva,
           Jaqz862pais,
           Jaqz862tdoc,
           Jaqz862ndoc,
           Jaqz862rubr,
           Jaqz862esta,
           Jaqz862enti,
           Jaqz862tcre,
           Jaqz862sdeu,
           Jaqz862plaz,
           Jaqz862taza,
           Jaqz862ccalc,
           Jaqz862gfin,
           Jaqz862frcc,
           Jaqz862dori,
           Jaqz862chek,
           Jaqz862pers,
           Jaqz862rela,
           Jaqz862line,
           Jaqz862aux1,
           Jaqz862aux2,
           Jaqz862aux3,
           Jaqz862aux4,
           Jaqz862aux5,
           Jaqz862aux6,
           Jaqz862aux7,
           Jaqz862aux8,
           Jaqz862aux9,
           Jaqz862mda,
           Jaqz862tlin,
           Jaqz862util,
           Jaqz862flin)
        
          select ln_NumCor + rownum,
                 ld_fecBDJ,
                 a.jaqy327hora,
                 pn_ins,
                 ln_nroeval,
                 a.jaqy327pais,
                 a.jaqy327tdoc,
                 a.jaqy327ndoc,
                 a.jaqy327rubr,
                 a.jaqy327esta,
                 a.jaqy327enti,
                 a.jaqy327tcre,
                 a.jaqy327sdeu,
                 a.jaqy327plaz,
                 a.jaqy327taza,
                 a.jaqy327ccalc,
                 a.jaqy327gfin,
                 a.jaqy327frcc,
                 a.jaqy327dori,
                 a.jaqy327chek,
                 a.jaqy327pers,
                 a.jaqy327rela,
                 a.jaqy327line,
                 a.jaqy327aux1,
                 a.jaqy327aux2,
                 a.jaqy327aux3,
                 a.jaqy327aux4,
                 a.jaqy327aux5,
                 a.jaqy327aux6,
                 a.jaqy327aux7,
                 a.jaqy327aux8,
                 a.jaqy327aux9,
                 a.jaqy327mda,
                 a.jaqy327tlin,
                 a.jaqy327util,
                 a.jaqy327flin
            from jaqy327_bdj a
           where a.jaqy327inst = ln_eva;
      
        commit;
      
      end if;
    
    else
      p_error := 'El modelo de evaluacion cargado es diferente al de la solicitud';
      return;
    end if;
  
  end sp_importa;

/*Procedure Sp_compara(pn_ins in number, pc_flg out char) is
  
    ld_fec date;
    lc_flg char(1);
  begin
  
    begin
      select trunc(min(a.wfiteminit))
        into ld_fec
        from wfwrkitems a
       where a.wfstscod = 3
         and a.wfinsprcid = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_flg
        from xwf700 a, sng001 b, jaqz697 c
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1'
         and a.xwfprcins = b.sng001inst
         and b.sng001cta = c.jaqz697cta
         and b.sng001pais = c.jaqz697pai
         and b.sng001tdoc = c.jaqz697tdo
         and b.sng001ndoc = c.jaqz697ndo
         and a.xwfmodulo = c.jaqz697mod
         and a.xwftipope = c.jaqz697top
         and c.jaqz697fan = ld_fec
         and c.jaqz697au5 = 'G'
         and rownum = 1;
    exception
      WHEN no_data_found THEN
        lc_flg := 'N';
        return;
        --when others then null;
    end;
  
    pc_flg := lc_flg;
  end Sp_tieneCampania;
*/
end pq_cr_importa_eva;
/

