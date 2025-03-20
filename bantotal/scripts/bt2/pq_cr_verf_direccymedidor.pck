create or replace package PQ_CR_VERF_DIRECCYMEDIDOR is

  -- Author  : MPOSTIGOC
  -- Created : 21/02/2018 04:54:57 p.m.
  -- Purpose : 

  ------------------------------------------------------------------
  PROCEDURE sp_cr_buscar(ln_Instancia in number,
                         lc_Direccion out varchar2,
                         lc_Medidor   out varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_verif_cambmedi(ln_Instancia    in number,
                                 lc_CambioEstMed out varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_VerifMedDesembolso(ln_Instancia   in number,
                                     lc_CambMedidor out varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_VerifRepRCCMedidor(ln_Instancia          in number,
                                     ln_VerifRepRCCMedidor out varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_NroCantDirecMedid(ln_Instancia     in number,
                                    ln_NroCoincDirec out number,
                                    ln_NroCoincMedid out number);
  ------------------------------------------------------------------                                     
end PQ_CR_VERF_DIRECCYMEDIDOR;
/

create or replace package body PQ_CR_VERF_DIRECCYMEDIDOR is

  PROCEDURE sp_cr_buscar(ln_Instancia in number,
                         lc_Direccion out varchar2,
                         lc_Medidor   out varchar2) is
  
    cursor lista_Integrantes is
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia);
   
    /* union
    select distinct (trim(f.pendoc)) ln_doc,
                    f.pepais ln_pais,
                    f.petdoc ln_petdoc
      from fsr008 f
     where f.ctnro in (select d.sng003cta
                         from sng003 d
                        where d.sng001inst = ln_Instancia);*/
  
    cursor lista_Docods(ln_SegLinea in number) is
      select tp1nro2 ln_Docod
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10899
         and tp1corr1 = 300
         and tp1corr2 = 1
         and tp1nro1 = ln_SegLinea;
  
    cursor lista_avales is
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select d.sng003cta
                           from sng003 d
                          where d.sng001inst = ln_Instancia);
  
    /* cursor lista_Medidores(ln_SegLinea in number) is
    select tp1nro2 ln_MediDocod
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10899
       and tp1corr1 = 300
       and tp1corr2 = 1
       and tp1nro3 = 1
       and tp1nro1 = ln_SegLinea;*/
  
    ln_SegLinea           number;
    Flag_ExistDirecc      varchar2(2) := 'N';
    Flag_ExistMedidor     varchar2(2) := 'N';
    Flag_ExistMedidorDJ   varchar2(2) := 'N';
    lc_nrodoc             char(12);
    ln_NroCorrDirec       number;
    Flag_VerfMedidor      varchar2(2) := 'N';
    Flg_TieneAval         varchar2(2) := 'N';
    Flag_ExistMedidorAval varchar2(2) := 'N';
  
  begin
    for l in lista_Integrantes loop
    
      lc_nrodoc := trim(l.ln_doc);
    
      if l.ln_petdoc <> 9 then
      
        begin
          select b.segcod
            into ln_SegLinea
            from sngc60 a, sngc07 b
           where a.sngc60pais = l.ln_pais
             and a.sngc60tdoc = l.ln_petdoc
             and a.sngc60ndoc = lc_nrodoc
             and a.sngc60ocup = b.sngc07cod;
          --   and a.sngc60corr=0;
        exception
          when too_many_rows then
            begin
              select b.segcod
                into ln_SegLinea
                from sngc60 a, sngc07 b
               where a.sngc60pais = l.ln_pais
                 and a.sngc60tdoc = l.ln_petdoc
                 and a.sngc60ndoc = lc_nrodoc
                 and a.sngc60ocup = b.sngc07cod
                 and a.sngc60corr =
                     (select min(a.sngc60corr)
                        from sngc60 a, sngc07 b
                       where a.sngc60pais = l.ln_pais
                         and a.sngc60tdoc = l.ln_petdoc
                         and a.sngc60ndoc = lc_nrodoc
                         and a.sngc60ocup = b.sngc07cod);
            
            end;
          when no_data_found then
            null;
        end;
      
      else
        if l.ln_petdoc = 9 then
          ln_SegLinea := 1;
        end if;
      end if;
    
      for d in lista_Docods(ln_SegLinea) loop
      
        begin
          select 'S', s.sngc13corr
            into Flag_ExistDirecc, ln_NroCorrDirec
            from sngc13 s
           where s.sngc13pais = l.ln_pais
             and s.sngc13tdoc = l.ln_petdoc
             and s.sngc13ndoc = lc_nrodoc
             and s.docod = d.ln_docod
             and s.sngc13est = 'H'
             and rownum = 1;
        exception
          when others then
            Flag_ExistDirecc := 'N';
        end;
      
        if Flag_ExistDirecc = 'S' then
          lc_Direccion := 'S';
        
          -- for m in lista_Medidores(ln_SegLinea) loop
        
          begin
            select 'S'
              into Flag_VerfMedidor
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10899
               and tp1corr1 = 300
               and tp1corr2 = 1
               and tp1nro3 = 1
               and tp1nro1 = ln_SegLinea
               and tp1nro2 = d.ln_docod
               and rownum = 1;
          exception
            when others then
              Flag_VerfMedidor := 'N';
          end;
        
          if Flag_VerfMedidor = 'S' then
            begin
              select 'S'
                into Flag_ExistMedidor
                from jaqz750 j
               where j.jaqz750pai = l.ln_pais
                 and j.jaqz750tdo = l.ln_petdoc
                 and j.jaqz750ndo = lc_nrodoc
                 and j.jaqz750docod = d.ln_docod
                 and j.jaqz750corr = ln_NroCorrDirec
                 and j.jaqz750est = 1
                 and j.jaqz750tmed <> 5
                 and rownum = 1;
            exception
              when others then
                Flag_ExistMedidor := 'N';
            end;
          
            if Flag_ExistMedidor = 'S' then
              lc_Medidor := 'S';
              --exit;
            else
              if Flag_ExistMedidor = 'N' then
              
                begin
                  select 'S'
                    into Flag_ExistMedidorDJ
                    from jaqz750 j
                   where j.jaqz750pai = l.ln_pais
                     and j.jaqz750tdo = l.ln_petdoc
                     and j.jaqz750ndo = lc_nrodoc
                     and j.jaqz750docod = d.ln_docod
                     and j.jaqz750corr = ln_NroCorrDirec
                     and j.jaqz750est = 1
                     and j.jaqz750tmed = 5
                     and rownum = 1;
                exception
                  when others then
                    Flag_ExistMedidorDJ := 'N';
                end;
              
                if Flag_ExistMedidorDJ = 'N' then
                  lc_Medidor := 'N';
                  exit;
                else
                  lc_Medidor := 'S';
                end if;
              end if;
            end if;
          end if;
          -- end loop;
        
        else
          if Flag_ExistDirecc = 'N' then
            lc_Direccion := 'N';
            lc_Medidor   := 'N';
            exit;
          
          end if;
        end if;
      
        if lc_Medidor = 'N' then
          exit;
        end if;
      end loop;
    
      if lc_Medidor = 'N' then
        exit;
      end if;
    
    end loop;
  
    begin
    
      select 'S'
        into Flg_TieneAval
        from sng003 s
       where s.sng001inst = ln_Instancia
         and rownum = 1;
    exception
      when others then
        Flg_TieneAval := 'N';
    end;
  
    if Flg_TieneAval = 'S' then
      if lc_Medidor = 'S' and lc_Direccion = 'S' then
        for p in lista_avales loop
        
          lc_nrodoc := trim(p.ln_doc);
        
          begin
            select 'S', s.sngc13corr
              into Flag_ExistDirecc, ln_NroCorrDirec
              from sngc13 s
             where s.sngc13pais = p.ln_pais
               and s.sngc13tdoc = p.ln_petdoc
               and s.sngc13ndoc = lc_nrodoc
               and s.docod in (select fst198.tp1nro1
                                 from fst198
                                where fst198.tp1cod1 = 10899
                                  and fst198.tp1corr1 = 300
                                  and fst198.tp1corr2 = 2)
               and s.sngc13est = 'H'
               and rownum = 1;
          exception
            when others then
              Flag_ExistDirecc := 'N';
          end;
          begin
          
            select 'S'
              into Flag_ExistMedidorAval
              from jaqz750 j
             where j.jaqz750pai = p.ln_pais
               and j.jaqz750tdo = p.ln_petdoc
               and j.jaqz750ndo = lc_nrodoc
               and j.jaqz750docod in
                   (select fst198.tp1nro1
                      from fst198
                     where fst198.tp1cod1 = 10899
                       and fst198.tp1corr1 = 300
                       and fst198.tp1corr2 = 2)
               and j.jaqz750corr = ln_NroCorrDirec
               and j.jaqz750est = 1
               and j.jaqz750tmed in
                   (select fst198.tp1nro1
                      from fst198
                     where fst198.tp1cod1 = 11109
                       and fst198.tp1corr1 = 4
                       and fst198.tp1corr3 = 1)
               and rownum = 1;
          exception
            when others then
              Flag_ExistMedidorAval := 'N';
            
          end;
          if Flag_ExistMedidorAval = 'N' then
            lc_Medidor := 'N';
          end if;
        
          if Flag_ExistDirecc = 'N' then
            lc_Direccion := 'N';
          end if;
        
        end loop;
      end if;
    end if;
  
  end sp_cr_buscar;
  
  ------------------------------------------------------------------------------
  -- Verifica si todos los integrantes y avales de la solicitud tienen un registro en S el campo
  -- jaqz750ind, si existe alguno lo actualizan a N.
  ---
  procedure sp_cr_verif_cambmedi(ln_Instancia    in number,
                                 lc_CambioEstMed out varchar2) is
  
    cursor lista_Integrantes is
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
      union
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select d.sng003cta
                           from sng003 d
                          where d.sng001inst = ln_Instancia);
  
    lc_nrodoc     char(12);
    lc_FlagCambio varchar2(2) := 'N';
  
  begin
  
    begin
      lc_CambioEstMed := 'N';
    
      for l in lista_Integrantes loop
      
        lc_nrodoc := trim(l.ln_doc);
      
        begin
          select 'S'
            into lc_FlagCambio
            from jaqz750 j
           where j.jaqz750pai = l.ln_pais
             and j.jaqz750tdo = l.ln_petdoc
             and j.jaqz750ndo = lc_nrodoc
             and j.jaqz750ind = 'S'
             and rownum = 1;
        exception
          when others then
            lc_FlagCambio := 'N';
        end;
      
        if lc_FlagCambio = 'S' then
        
          begin
            update jaqz750 j
               set j.jaqz750ind = 'N'
             where j.jaqz750pai = l.ln_pais
               and j.jaqz750tdo = l.ln_petdoc
               and j.jaqz750ndo = lc_nrodoc
               and j.jaqz750ind = 'S';
          end;
          commit;
        
          lc_CambioEstMed := 'S';
        
        end if;
      
      end loop;
    end;
  
  end sp_cr_verif_cambmedi;
  ------------------------------------------------------------------------------
  procedure sp_cr_VerifMedDesembolso(ln_Instancia   in number,
                                     lc_CambMedidor out varchar2) is
  
    cursor lista_Integrantes is
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
      union
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select d.sng003cta
                           from sng003 d
                          where d.sng001inst = ln_Instancia);
  
    lc_nrodoc     char(12);
    lc_FlagCambio varchar2(2) := 'N';
  
  begin
  
    begin
    
      for l in lista_Integrantes loop
      
        lc_nrodoc := trim(l.ln_doc);
      
        begin
          select 'S'
            into lc_FlagCambio
            from jaqz750 j
           where j.jaqz750pai = l.ln_pais
             and j.jaqz750tdo = l.ln_petdoc
             and j.jaqz750ndo = lc_nrodoc
             and j.jaqz750ind = 'S'
             and rownum = 1;
        exception
          when others then
            lc_FlagCambio := 'N';
        end;
      
        if lc_FlagCambio = 'S' then
        
          lc_CambMedidor := 'S';
          exit;
        
        else
          if lc_FlagCambio = 'N' then
            lc_CambMedidor := 'N';
          end if;
        end if;
      
      end loop;
    end;
  
  end sp_cr_VerifMedDesembolso;

  ------------------------------------------------------------------------------
  --Verifica si la Fecha y Hora del Reporte RCC para los integrandtes y avales de 
  -- la solicitud es mayor a la fecha de registro del medidor, si es menor devuelve S
  -- y bloquea la solicitud, de lo contrario N

  procedure sp_cr_VerifRepRCCMedidor(ln_Instancia          in number,
                                     ln_VerifRepRCCMedidor out varchar2) is
  
    cursor lista_Integrantes is
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
      union
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select d.sng003cta
                           from sng003 d
                          where d.sng001inst = ln_Instancia);
  
    lc_nrodoc         char(12);
    lc_HoraRegMedidor char(8);
    lc_HoraRepRCC     char(8);
    ld_FchRegMedidor  date;
    ld_FchRepRCC      date;
  
  begin
  
    ln_VerifRepRCCMedidor := 'N';
    begin
    
      for l in lista_Integrantes loop
      
        lc_nrodoc := trim(l.ln_doc);
      
        begin
          -- Revisa la fecha y Hora del Ultimo Reporte RCC Extraido
          begin
            select max(j.jaql715fech)
              into ld_FchRepRCC
              from JAQL715 j
             where j.jaql715pais = l.ln_pais
               and j.jaql715tdoc = l.ln_petdoc
               and j.jaql715ndoc = lc_nrodoc;
          end;
          begin
            select max(j.jaql715hora)
              into lc_HoraRepRCC
              from JAQL715 j
             where j.jaql715pais = l.ln_pais
               and j.jaql715tdoc = l.ln_petdoc
               and j.jaql715ndoc = lc_nrodoc
               and j.jaql715fech = ld_FchRepRCC;
          end;
        end;
      
        begin
        
          begin
            select max(j.jaqz750fcn)
              into ld_FchRegMedidor
              from jaqz750 j
             where j.jaqz750pai = l.ln_pais
               and j.jaqz750tdo = l.ln_petdoc
               and j.jaqz750ndo = lc_nrodoc
               and j.jaqz750est = 1
            /* and rownum = 1*/
            ;
          exception
            when others then
              ld_FchRegMedidor := '00:00:00';
          end;
        
          begin
            select max(j.jaqz750hor)
              into lc_HoraRegMedidor
              from jaqz750 j
             where j.jaqz750pai = l.ln_pais
               and j.jaqz750tdo = l.ln_petdoc
               and j.jaqz750ndo = lc_nrodoc
               and j.jaqz750est = 1
               and j.jaqz750fcn = ld_FchRegMedidor
            /*and rownum = 1*/
            ;
          exception
            when others then
              lc_HoraRegMedidor := '00:00:00';
          end;
        
        end;
      
        if ld_FchRepRCC < ld_FchRegMedidor then
          ln_VerifRepRCCMedidor := 'S';
          exit;
        
        else
          if ld_FchRepRCC = ld_FchRegMedidor then
          
            if lc_HoraRepRCC < lc_HoraRegMedidor then
              ln_VerifRepRCCMedidor := 'S';
              exit;
            else
              if lc_HoraRepRCC >= lc_HoraRegMedidor then
                ln_VerifRepRCCMedidor := 'N';
              end if;
            end if;
          
          else
            if ld_FchRepRCC > ld_FchRegMedidor then
              ln_VerifRepRCCMedidor := 'N';
            end if;
          end if;
        end if;
      end loop;
    end;
  
  end sp_cr_VerifRepRCCMedidor;
  -------------------------------------------------------------------------------
  procedure sp_cr_NroCantDirecMedid(ln_Instancia     in number,
                                    ln_NroCoincDirec out number,
                                    ln_NroCoincMedid out number) is
    cursor lista_Integrantes is
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
      union
      select distinct (trim(f.pendoc)) ln_doc,
                      f.pepais ln_pais,
                      f.petdoc ln_petdoc
        from fsr008 f
       where f.ctnro in (select d.sng003cta
                           from sng003 d
                          where d.sng001inst = ln_Instancia);
  
    lc_nrodoc           char(12);
    lc_HoraRepRCC       char(8);
    ld_FchRepRCC        date;
    ln_NroCoincDirecAux number;
    ln_NroCoincMedidAux number;
  
  begin
  
    ln_NroCoincDirec := 0;
    ln_NroCoincMedid := 0;
  
    for l in lista_Integrantes loop
    
      ln_NroCoincDirecAux := 0;
      ln_NroCoincMedidAux := 0;
    
      lc_nrodoc := trim(l.ln_doc);
    
      begin
        -- Revisa la fecha y Hora del Ultimo Reporte RCC Extraido
        begin
          select max(j.jaql715fech)
            into ld_FchRepRCC
            from JAQL715 j
           where j.jaql715pais = l.ln_pais
             and j.jaql715tdoc = l.ln_petdoc
             and j.jaql715ndoc = lc_nrodoc;
        exception
          when others then
            null;
        end;
      
        begin
          select max(j.jaql715hora)
            into lc_HoraRepRCC
            from JAQL715 j
           where j.jaql715pais = l.ln_pais
             and j.jaql715tdoc = l.ln_petdoc
             and j.jaql715ndoc = lc_nrodoc
             and j.jaql715fech = ld_FchRepRCC;
        exception
          when others then
            null;
        end;
      end;
    
      begin
        select JAQL715AU05, JAQL715AU06
          into ln_NroCoincDirecAux, ln_NroCoincMedidAux
          from JAQL715 j
         where j.jaql715pais = l.ln_pais
           and j.jaql715tdoc = l.ln_petdoc
           and j.jaql715ndoc = lc_nrodoc
           and j.jaql715fech = ld_FchRepRCC
           and j.jaql715hora = lc_HoraRepRCC;
      exception
        when others then
          null;
      end;
      ln_NroCoincDirec := ln_NroCoincDirec + ln_NroCoincDirecAux;
      ln_NroCoincMedid := ln_NroCoincMedid + ln_NroCoincMedidAux;
    
    end loop;
  
  end sp_cr_NroCantDirecMedid;

-------------------------------------------------------------------------------  
end PQ_CR_VERF_DIRECCYMEDIDOR;
/

