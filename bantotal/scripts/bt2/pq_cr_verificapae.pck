create or replace package pq_Cr_verificaPAE is

  Procedure Sp_Cr_verifica(pn_ins in number, pc_err out char);

end pq_Cr_verificaPAE;
/

create or replace package body pq_Cr_verificaPAE is

  Procedure Sp_Cr_verifica(pn_ins in number, pc_err out char) is
  
    ln_codtarea number(4) := 0;
    ln_codeje   number(1) := 0;
    lc_err      varchar2(1) := 'N';
    ln_wrkitem  number;
    ln_pae70    number := 0;
    ln_pae71    number := 0;
  
  begin
    lc_err := 'N';
  
    begin
      select a.wftaskcod
        into ln_codtarea
        from wfwrkitems a
       where a.wfinsprcid = pn_ins
         and a.wfitemstsact = 1;
    exception
      when others then
        ln_codtarea := 0;
    end;
  
    if ln_codtarea = 7 then
      -- En Evaluacion Propuesta, Verifica el PAE de Solicitud
    
      ln_codeje := 1;
    
      begin
        select v.wfattsval
          into ln_wrkitem
          from wfattsvalues v
         where v.wfinsprcid = pn_ins
           and v.wfattsid = 'WRKITEMSOL';
      exception
        when others then
          ln_wrkitem := 0;
      end;
    end if;
  
    if ln_codtarea = 11 then
      -- En Aprobacion, Verifica el PAE de Evaluacion Propuesta
    
      ln_codeje := 2;
    
      begin
        select v.wfattsval
          into ln_wrkitem
          from wfattsvalues v
         where v.wfinsprcid = pn_ins
           and v.wfattsid = 'WRKITEMPRO';
      exception
        when others then
          ln_wrkitem := 0;
      end;
    end if;
  
    if ln_codtarea = 55 then
      -- En desembolso, Verifica el PAE de Aprobacion
    
      ln_codeje := 3;
    
      begin
        select v.wfattsval
          into ln_wrkitem
          from wfattsvalues v
         where v.wfinsprcid = pn_ins
           and v.wfattsid = 'WRKITEMAPR';
      exception
        when others then
          ln_wrkitem := 0;
      end;
    
    end if;
  
    if pn_ins > 0 and ln_codeje > 0 and ln_wrkitem > 0 then
    
      begin
      
        begin
          select max(f.pae70nro)
            into ln_pae70
            from fpae70 f
           where f.pae51eva = ln_codeje
             and f.pae70ins = pn_ins
             and f.pae70wri = ln_wrkitem;
        exception
          when others then
            ln_pae70 := 0;
        end;
      
        begin
          select count(*)
            into ln_pae71
            from fpae71 f
           where f.pae51eva = ln_codeje
             and f.pae70nro = ln_pae70;
        exception
          when others then
            ln_pae71 := 0;
        end;
      
        if ln_pae71 > 0 then
          lc_err := 'S';
        else
          lc_err := 'N';
        end if;
      end;
    
    end if;
  
    pc_err := lc_err;
  
  end Sp_Cr_verifica;

end pq_Cr_verificaPAE;
/

