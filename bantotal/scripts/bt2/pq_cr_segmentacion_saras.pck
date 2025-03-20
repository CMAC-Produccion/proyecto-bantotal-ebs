create or replace package PQ_CR_SEGMENTACION_SARAS is

  -- Author  : MPOSTIGOC
  -- Created : 22/08/2023 18:19:02
  -- Purpose : 

  procedure sp_cr_inicio(ln_instancia    in number,
                         lc_segmentsaras out varchar2);
  ------------------------------------------------------------
  procedure sp_Cr_LogAQPB169(ln_inst     in number,
                             ln_pais     in number,
                             ln_tdoc     in number,
                             lc_ndoc     in varchar2,
                             ln_ciiu     in number,
                             ln_tcred    in number,
                             lc_tabla    in varchar2,
                             ld_ftabla   in date,
                             lc_segrisk  in varchar2,
                             ln_modeva   in number,
                             ln_dpto     in number,
                             lc_sgsaras  in varchar2,
                             ld_fsgsaras in date,
                             lc_hsgsaras in varchar2);

end PQ_CR_SEGMENTACION_SARAS;
/

create or replace package body PQ_CR_SEGMENTACION_SARAS is

  procedure sp_cr_inicio(ln_instancia    in number,
                         lc_segmentsaras out varchar2) is
  
    cursor Integrantes(ln_cuenta number) is
      select f.pepais, f.petdoc, f.pendoc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_cuenta;
  
    ln_tdoc            number;
    ln_pais            number;
    lc_ndoc            varchar2(12);
    ln_CodTipoCred     number;
    lc_segmtrisk       varchar2(15);
    ln_ciiu            number;
    ln_modeval         number;
    ln_dpto            number;
    lc_TablaSR         varchar2(10);
    ld_ftabla          date;
    ld_fch640          date;
    ld_fch639          date;
    ld_fsegmsaras      date;
    lc_hsegmsaras      varchar2(8);
    ln_CnsmConsiderado number;
    ln_cuenta          number;
  
  begin
  
    begin
      update aqpb169 a
         set a.aqpb169est = 'I'
       where a.aqpb169inst = ln_instancia;
      commit;
    end;
  
    begin
      select s.sng001cta
        into ln_cuenta
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
    begin
      select to_number(g.pae71val)
        into ln_CodTipoCred
        from fpae71 g
       where g.pae51eva = 2
         and g.pae70nro = (select max(f.pae70nro)
                             from fpae70 f
                            where f.pae70ins = ln_instancia
                              and f.pae51eva = 2)
         and g.pae71ite = 101;
    exception
      when others then
        ln_CodTipoCred := 0;
    end;
  
    if ln_CodTipoCred = 3 then
    
      begin
        select count(regexp_substr(w.wfattsval,
                                   'CONSUMO NO REVOLVENTE',
                                   1,
                                   1,
                                   'i'))
          into ln_CnsmConsiderado
          from wfattsvalues w
         where w.wfinsprcid = ln_instancia
           and w.wfattsid = 'TIPO_CREDITO';
      exception
        when others then
          null;
      end;
    
      if ln_CnsmConsiderado > 0 then
        ln_CodTipoCred := 3;
      else
        ln_CodTipoCred := 999;
      end if;
    end if;
  
    begin
      select max(a.jaql640fepre) into ld_fch640 from jaql640 a;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.jaql639fepre) into ld_fch639 from jaql639 a;
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng021tmod
        into ln_modeval
        from sng021 s
       where s.sng021sol = ln_instancia;
    exception
      when others then
        null;
    end;
  
    for i in Integrantes(ln_cuenta) loop
    
      ln_pais         := i.pepais;
      ln_tdoc         := i.petdoc;
      lc_ndoc         := trim(i.pendoc);
      ln_dpto         := null;
      ln_ciiu         := null;
      lc_segmtrisk    := null;
      lc_segmentsaras := null;
      ld_fsegmsaras   := null;
      lc_hsegmsaras   := null;
    
      begin
        Pq_Cr_Modulo_Campanias.sp_cr_ciuu(i.pepais,
                                          i.petdoc,
                                          lc_ndoc,
                                          ln_ciiu);
      exception
        when others then
          null;
      end;
    
      begin
        select jaql640segmen
          into lc_segmtrisk
          from jaql640 j
         where j.jaql640ptdoc = i.petdoc
           and j.jaql640pndoc = rpad(lc_ndoc, 12, ' ')
           and j.jaql640ticre in
               (select trim(f.tp1desc)
                  from fst198 f
                 where f.tp1cod = 1
                   and f.tp1cod1 = 10899
                   and f.tp1corr1 = 124
                   and f.tp1corr2 = 2
                   and f.tp1nro3 = ln_CodTipoCred)
           and j.jaql640fepre = ld_fch640;
      exception
        when others then
          null;
      end;
    
      if lc_segmtrisk is not null then
        lc_TablaSR := 'JAQL640';
        ld_ftabla  := ld_fch640;
      end if;
    
      if lc_segmtrisk is null then
      
        if i.petdoc in (21, 2, 5) then
        
          if ln_CodTipoCred in (2, 13) then
            begin
              select j.jaql639segmyp
                into lc_segmtrisk
                from jaql639 j
               where j.jaql639nuide = lc_ndoc
                 and j.jaql639fepre =
                     (select max(a.jaql639fepre) from jaql639 a);
            exception
              when others then
                null;
              
            end;
          else
            if ln_CodTipoCred = 3 then
              begin
                select j.jaql639segcon
                  into lc_segmtrisk
                  from jaql639 j
                 where j.jaql639nuide = lc_ndoc
                   and j.jaql639fepre =
                       (select max(a.jaql639fepre) from jaql639 a);
              exception
                when others then
                  null;
                
              end;
            end if;
          end if;
        else
          if i.petdoc = 9 then
            if ln_CodTipoCred in (2, 13) then
            
              begin
                select j.jaql639segmyp
                  into lc_segmtrisk
                  from jaql639 j
                 where j.jaql639nuruc = lc_ndoc
                   and j.jaql639fepre =
                       (select max(a.jaql639fepre) from jaql639 a);
              exception
                when others then
                  null;
                
              end;
            else
              if ln_CodTipoCred = 3 then
                begin
                  select j.jaql639segcon
                    into lc_segmtrisk
                    from jaql639 j
                   where j.jaql639nuruc = lc_ndoc
                     and j.jaql639fepre =
                         (select max(a.jaql639fepre) from jaql639 a);
                exception
                  when others then
                    null;
                  
                end;
              end if;
            end if;
          end if;
        end if;
      
        if lc_segmtrisk is not null then
          lc_TablaSR := 'JAQL639';
          ld_ftabla  := ld_fch639;
        end if;
      end if;
    
      if ln_modeval = 13 then
        begin
          select s.sngc13dpto
            into ln_dpto
            from sngc13 s
           where s.sngc13pais = i.pepais
             and s.sngc13tdoc = i.petdoc
             and s.sngc13ndoc = rpad(lc_ndoc, 12, ' ')
             and s.docod = 3
             and s.sngc13est = 'H';
        exception
          when others then
            begin
              select s.sngc13dpto
                into ln_dpto
                from sngc13 s
               where s.sngc13pais = i.pepais
                 and s.sngc13tdoc = i.petdoc
                 and s.sngc13ndoc = rpad(lc_ndoc, 12, ' ')
                 and s.docod = 1
                 and s.sngc13est = 'H';
            exception
              when others then
                null;
            end;
        end;
      else
        if ln_modeval = 14 then
          begin
            select s.sngc13dpto
              into ln_dpto
              from sngc13 s
             where s.sngc13pais = i.pepais
               and s.sngc13tdoc = i.petdoc
               and s.sngc13ndoc = rpad(lc_ndoc, 12, ' ')
               and s.docod = 1
               and s.sngc13est = 'H';
          exception
            when others then
              null;
          end;
        end if;
      end if;
    
      begin
        select a.aqpb168sgm960, a.aqpb168fecha, a.AQPB168HORA
          into lc_segmentsaras, ld_fsegmsaras, lc_hsegmsaras
          from aqpb168 a
         where a.aqpb168segmrisk = lc_segmtrisk
           and a.aqpb168ciiu = ln_ciiu
           and a.aqpb168coddpto = ln_dpto
           and a.aqpb168fecha = (select max(q.aqpb168fecha) from aqpb168 q);
      exception
        when others then
          null;
      end;
    
      if lc_segmentsaras is not null then
        exit;
      end if;
    
      if ln_CodTipoCred = 999 then
      
        lc_segmentsaras := 'SINSEGMENTACION';
      
      end if;
    end loop;
  
    if lc_segmentsaras is null then
      lc_segmentsaras := 'SINSEGMENTACION';
    end if;
  
    if lc_segmentsaras is not null then
    
      begin
        Pq_Cr_Segmentacion_Saras.sp_Cr_LogAQPB169(ln_inst     => ln_instancia,
                                                  ln_pais     => ln_pais,
                                                  ln_tdoc     => ln_tdoc,
                                                  lc_ndoc     => lc_ndoc,
                                                  ln_ciiu     => ln_ciiu,
                                                  ln_tcred    => ln_CodTipoCred,
                                                  lc_tabla    => lc_TablaSR,
                                                  ld_ftabla   => ld_ftabla,
                                                  lc_segrisk  => lc_segmtrisk,
                                                  ln_modeva   => ln_modeval,
                                                  ln_dpto     => ln_dpto,
                                                  lc_sgsaras  => lc_segmentsaras,
                                                  ld_fsgsaras => ld_fsegmsaras,
                                                  lc_hsgsaras => lc_hsegmsaras);
      
      end;
    end if;
  
  end sp_cr_inicio;
  -------------------------------------------------------------
  procedure sp_Cr_LogAQPB169(ln_inst     in number,
                             ln_pais     in number,
                             ln_tdoc     in number,
                             lc_ndoc     in varchar2,
                             ln_ciiu     in number,
                             ln_tcred    in number,
                             lc_tabla    in varchar2,
                             ld_ftabla   in date,
                             lc_segrisk  in varchar2,
                             ln_modeva   in number,
                             ln_dpto     in number,
                             lc_sgsaras  in varchar2,
                             ld_fsgsaras in date,
                             lc_hsgsaras in varchar2) is
  
    ln_corr number := 0;
    lc_hora varchar2(8) := '00:00:00';
    ld_fch  date;
  
  begin
  
    begin
      select max(a.aqpb169corr)
        into ln_corr
        from aqpb169 a
       where a.aqpb169inst = ln_inst;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
    begin
      select f.pgfape into ld_fch from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb169
        (aqpb169corr,
         aqpb169inst,
         aqpb169fch,
         aqpb169hora,
         aqpb169pais,
         aqpb169tdoc,
         aqpb169ndoc,
         aqpb169ciiu,
         aqpb169tcred,
         aqpb169tabla,
         aqpb169ftabla,
         aqpb169segrisk,
         aqpb169modeva,
         aqpb169dpto,
         aqpb169sgsaras,
         aqpb169fsgsaras,
         aqpb169hsgsaras,
         aqpb169est)
      values
        (ln_corr + 1,
         ln_inst,
         ld_fch,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_ciiu,
         ln_tcred,
         lc_tabla,
         ld_ftabla,
         lc_segrisk,
         ln_modeva,
         ln_dpto,
         lc_sgsaras,
         ld_fsgsaras,
         lc_hsgsaras,
         'H');
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_Cr_LogAQPB169;
  ---------------------------------------------------
end PQ_CR_SEGMENTACION_SARAS;
/

