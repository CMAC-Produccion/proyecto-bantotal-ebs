create or replace package pq_cr_reporte_segmentacion is

  Procedure Sp_procesa(pd_fecpro in date, pc_usr in varchar2);

end pq_cr_reporte_segmentacion;
/

create or replace package body pq_cr_reporte_segmentacion is

  Procedure Sp_procesa(pd_fecpro in date, pc_usr in varchar2) is
  
    cursor clientes is
      select *
        from jaqz664 a
       where a.jaqz664fec = pd_fecpro
      -- and a.jaqz664ndo = '25562315'
      ;
  
    ln_seg     number(5);
    ln_segCons number(5);
  begin
  
    for i in clientes loop
    
      pq_cr_segmentacion_aplic.Sp_Carga_data(pd_fecpro => pd_fecpro,
                                             pn_pai    => i.jaqz664pai,
                                             pn_tdo    => i.jaqz664tdo,
                                             pc_doc    => i.jaqz664ndo,
                                             pc_usr    => pc_usr);
    
      begin
        -- Call the procedure
        pq_cr_segment_cons_aplic.sp_carga_data(pd_fecpro => pd_fecpro,
                                               pn_pai    => i.jaqz664pai,
                                               pn_tdo    => i.jaqz664tdo,
                                               pc_doc    => i.jaqz664ndo,
                                               pc_usr    => pc_usr);
      end;
    
      begin
        select a.jaqz086calf
          into ln_seg
          from jaqz086_APL a
         where a.jaqz086paic = i.jaqz664pai
           and a.jaqz086tdoc = i.jaqz664tdo
           and a.jaqz086tndoc = i.jaqz664ndo
           and a.jaqz086usR = pc_usr;
      exception
        when others then
          null;
      end;
    
      begin
        select a.jaqz663calf
          into ln_segCons
          from jaqz663_APL a
         where a.jaqz663paic = i.jaqz664pai
           and a.jaqz663tdoc = i.jaqz664tdo
           and a.jaqz663tndoc = i.jaqz664ndo
           and a.jaqz663usr = pc_usr;
      exception
        when others then
          null;
      end;
    
      update jaqz664 a
         set a.jaqz664seg = ln_seg, a.jaqz664sec = ln_segCons
       where a.jaqz664pai = i.jaqz664pai
         and a.jaqz664tdo = i.jaqz664tdo
         and a.jaqz664ndo = i.jaqz664ndo
         and a.jaqz664fec = pd_fecpro;
      commit;
    end loop;
  
  end Sp_procesa;

end pq_cr_reporte_segmentacion;
/

