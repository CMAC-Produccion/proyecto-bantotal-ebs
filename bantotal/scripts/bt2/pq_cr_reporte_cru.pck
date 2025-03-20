create or replace package PQ_CR_REPORTE_CRU is
  -- *****************************************************************
  -- Nombre                     : paquete para CRU
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 16/11/2018
  -- Autor de Creación          : Cinthya Liz Hernandez Ortega
  -- Uso                        : Realiza Calculos
  -- Estado                     : Activo
  -- Acceso                     : Público 
  --                              
  --
  -- *****************************************************************

  ------------------------------------------------------------------------------
  procedure SP_CR_INSERT_JAQY772(v_Inst  in number,
                                 v_Fecha in date,
                                 v_NuOpe in number);

  procedure SP_CR_BORRADO_JAQY772;

  procedure SP_CR_JAQL546(v_NuOpe  in number,
                          v_Accion out varchar2,
                          v_Respp  out varchar2,
                          v_Score  out number);

  procedure SP_CR_Calif_SBS(v_Cta   in number,
                            v_Calif out number,
                            v_Desc  out varchar2);
  procedure sp_cr_Cal_SBS_Titular(v_Tdoc  in number,
                                  v_Ndoc  in varchar2,
                                  d_Date  in date,
                                  v_Desc1 out varchar2);
  procedure sp_cr_Cal_SBS_Conyugue(v_Tdoc  in number,
                                   v_Ndoc  in varchar2,
                                   v_Desc2 out varchar2);
  -----------------------------------------------------------------------             
end PQ_CR_REPORTE_CRU;
/

create or replace package body PQ_CR_REPORTE_CRU is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  ---------------------------------------------------------------------------------------------
  procedure SP_CR_INSERT_JAQY772(v_Inst  in number,
                                 v_Fecha in date,
                                 v_NuOpe in number) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQY772
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/11/2018
    -- Autor de Creación          : CHERNANDEZ
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    --
    -- *****************************************************************                              
    ln_inst number(9);
  
    ln_num     number(9);
    ln_772inst number(9);
    lc_Sval    char(30);
    ld_Time    TIMESTAMP;
    lc_Hra1    char(20);
    lc_Hra2    char(8);
    lc_Hra3    char(3);
    lc_dia     char(3);
    lc_Hra4    char(3);
    lc_Hra5    char(8);
    lc_HraF    char(8);
  
  Begin
    Begin
      select d.jaqy772inst
        into ln_772inst
        from JAQY772 d
       where d.jaqy772inst = v_Inst;
    Exception
      when no_data_found then
        ln_772inst := 0;
    end;
  
    If ln_772inst = 0 then
      Begin
        Begin
          Begin
            select WFAttSVal
              into lc_Sval
              from Wfattsvalues
             Where WFInsPrcId = v_Inst
               and WFAttSId = 'WRKITEMPRO';
          Exception
            when no_data_found then
              lc_Sval := null;
          end;
        
          select max(PAE70Time)
            into ld_Time
            from Fpae70
           Where PAE70WRI = lc_Sval;
        Exception
          when no_data_found then
            ld_Time := null;
        end;
      
        lc_Hra1 := Trim(Substr(ld_time, 9, 19));
        lc_dia  := Trim(Substr(lc_Hra1, 17, 19));
      
        If lc_dia = 'PM' then
          lc_Hra3 := Trim(Substr(lc_Hra1, 1, 2));
          lc_Hra5 := Trim(Substr(lc_Hra1, 3, 6));
        
          If lc_Hra3 = '01' then
            lc_Hra4 := '13';
          Else
            If lc_Hra3 = '02' then
              lc_Hra4 := '14';
            Else
              If lc_Hra3 = '03' then
                lc_Hra4 := '15';
              Else
                If lc_Hra3 = '04' then
                  lc_Hra4 := '16';
                Else
                  If lc_Hra3 = '05' then
                    lc_Hra4 := '17';
                  Else
                    If lc_Hra3 = '06' then
                      lc_Hra4 := '18';
                    Else
                      If lc_Hra3 = '07' then
                        lc_Hra4 := '19';
                      Else
                        If lc_Hra3 = '08' then
                          lc_Hra4 := '20';
                        Else
                          If lc_Hra3 = '09' then
                            lc_Hra4 := '21';
                          Else
                            If lc_Hra3 = '10' then
                              lc_Hra4 := '22';
                            Else
                              If lc_Hra3 = '11' then
                                lc_Hra4 := '23';
                              Else
                                If lc_Hra3 = '12' then
                                  lc_Hra4 := '24';
                                End If;
                              End If;
                            End If;
                          End If;
                        End If;
                      End If;
                    End If;
                  End If;
                End If;
              End If;
            End If;
          End If;
          lc_HraF := trim(lc_Hra4) || trim(lc_Hra5);
        Else
          lc_HraF := Trim(Substr(lc_Hra1, 1, 8));
        End If;
      
        select max(jaqy599ahor)
          into lc_Hra2
          from jaqy599a
         where jaqy599afec = v_Fecha
           and jaqy599ainst = v_Inst
           and Substr(jaqy599ahor, 1, 5) <= Substr(lc_HraF, 1, 5);
      Exception
        when no_data_found then
          lc_Hra2 := null;
      end;
    
      ln_num  := v_Inst;
      ln_inst := 0;
    
      If ln_inst <> ln_num then
        ln_inst := ln_num;
        Begin
          insert into JAQY772
            (JAQY772Inst, JAQY772Fecha, JAQY772Hora, JAQY772Nuope)
          values
            (ln_inst, v_Fecha, lc_Hra2, v_NuOpe);
          commit;
        end;
      End If;
    
    End If;
  end SP_CR_INSERT_JAQY772;
  ----------------------------------------------------------------------------------------
  procedure SP_CR_BORRADO_JAQY772 is
  begin
    begin
      execute immediate ('truncate table JAQY772');
      commit;
    end;
  
  end SP_CR_BORRADO_JAQY772;
  ----------------------------------------------------------------------------------------
  procedure SP_CR_JAQL546(v_NuOpe  in number,
                          v_Accion out varchar2,
                          v_Respp  out varchar2,
                          v_Score  out number) is
    cursor mensaje(ln_correpar number) is
      select jaqy598accio||','||jaqy598mensa jaqy598mensa
        from jaqy598
       where jaqy598corre = ln_correpar
         and jaqy598accio in ('O', 'R')
         and jaqy598regla <= 1000;
  
    lc_accion varchar2(10);
    lc_respp  varchar2(1000);
    ln_score  number(10, 2);
    ln_corre  number(10);
  
  begin
    begin
    
      select min(aqpa012corre)
        into ln_corre
        from aqpa012
       where aqpa012conec = v_NuOpe;
    
      select jaqy599accio
        into lc_accion
        from jaqy599
       where jaqy599corre = ln_corre
       and jaqy599accio in ('O', 'R');
      lc_respp := '';
      ln_score := 0;
      if lc_accion in ('O', 'R') then
         for i in mensaje(ln_corre) loop
            lc_respp := lc_respp || '@' || i.jaqy598mensa;
        end loop;
      end if;
      
    Exception
      when no_data_found then
        dbms_output.put_line(sqlerrm);
        lc_accion := null;
        lc_respp  := null;
        ln_score  := 0;
        
      when others then
        dbms_output.put_line(sqlerrm);
        lc_accion := null;
        lc_respp  := null;
        ln_score  := 0;
    end;
  
    v_Accion := lc_accion;
    v_Respp  := lc_respp;
    v_Score  := ln_score;
  
  end SP_CR_JAQL546;
  ----------------------------------------------------------------------------------------
  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char is
  
    C_TDOCID char(1);
  
  Begin
    Begin
      C_TDOCID := '0';
    
      If ln_tdoc = 21 then
        C_TDOCID := '1';
      End If;
    
      If ln_tdoc = 9 then
        If Length(lc_tndoc) < 11 then
          C_TDOCID := '2';
        End If;
      
        If Length(lc_tndoc) >= 11 then
          C_TDOCID := '3';
        End If;
      End If;
    
      If ln_tdoc = 2 then
        C_TDOCID := '2';
      End If;
    
      If ln_tdoc = 4 then
        C_TDOCID := '3';
      End If;
    
      If ln_tdoc = 15 then
        C_TDOCID := '4';
      End If;
    
      If ln_tdoc = 5 then
        C_TDOCID := '5';
      End If;
    
      If ln_tdoc = 6 then
        C_TDOCID := '8';
      End If;
    End;
  
    return C_TDOCID;
  
  end fn_Tipo_Doc_SBS;
  ----------------------------------------------------------------------------------------
  procedure SP_CR_Calif_SBS(v_Cta   in number,
                            v_Calif out number,
                            v_Desc  out varchar2) is
  
    ln_FchSBS  number(8);
    D_FECPRE   varchar2(15);
    ln_dia     number(2);
    ln_Mes     number(2);
    ln_Anio    number(4);
    JAQY774Cal number(1);
    ln_cal0    number(5, 2);
    ln_cal1    number(5, 2);
    ln_cal2    number(5, 2);
    ln_cal3    number(5, 2);
    ln_cal4    number(5, 2);
    D_FECPRE1  date;
    PNDOC      char(12);
    ln_tdoc    number(2);
    lc_tndoc   char(12);
    lc_docsbs  char(1);
    lc_desc    varchar2(20);
    ln_tdoc1   number(2);
    lc_pndoc   varchar2(12);
  
  Begin
    Begin
      Begin
        select petdoc, pendoc
          into ln_tdoc, lc_tndoc
          from Fsr008
         Where Pgcod = 1
           and Ctnro = v_Cta
           and Ttcod = 1
           and Cttfir = 'T';
      Exception
        when no_data_found then
          lc_tndoc := null;
          ln_tdoc  := 0;
      End;
    
      ln_tdoc1  := ln_tdoc;
      lc_docsbs := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
      ---------------------------------------------------
      select Tpnro
        into ln_FchSBS
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    
      ln_dia  := SubStr(ln_FchSBS, 1, 2);
      ln_Mes  := SubStr(ln_FchSBS, 3, 2);
      ln_Anio := SubStr(ln_FchSBS, 5, 4);
    
      D_FECPRE  := ln_dia || '/' || ln_Mes || '/' || ln_Anio;
      D_FECPRE1 := to_date(D_FECPRE, 'dd/mm/rrrr');
      PNDOC     := rpad(lc_tndoc, 12, ' ');
      lc_pndoc  := trim(PNDOC);
    Exception
      when no_data_found then
        D_FECPRE1 := null;
        D_FECPRE  := null;
    End;
    ------------------------------------------------------
    If (ln_tdoc1 <> 9) then
      Begin
        select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
        
          into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
          from CLDRCCI
         where D_FECPRE = D_FECPRE1
           and C_TDOCID = lc_docsbs
           and C_DOCIDE = lc_pndoc
           and rownum < 2;
      exception
        when no_data_found then
          ln_cal0 := 0;
          ln_cal1 := 0;
          ln_cal2 := 0;
          ln_cal3 := 0;
          ln_cal4 := 0;
      end;
      If ln_cal0 > 0 then
        JAQY774Cal := 1;
        lc_desc    := '- Normal';
      End If;
    
      If ln_cal1 > 0 then
        JAQY774Cal := 2;
        lc_desc    := '- C.P.P';
      
      End If;
    
      If ln_cal2 > 0 then
        JAQY774Cal := 3;
        lc_desc    := '- Deficiente';
      End If;
    
      If ln_cal3 > 0 then
        JAQY774Cal := 4;
        lc_desc    := '- Dudoso';
      End If;
    
      If ln_cal4 > 0 then
        JAQY774Cal := 5;
        lc_desc    := '- Perdida';
      End If;
    Else
      Begin
        select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
        
          into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
          from CLDRCCI
         where D_FECPRE = D_FECPRE1
           and C_TDOCTR = lc_docsbs
           and C_DOCTRI = lc_pndoc
           and rownum < 2;
      exception
        when no_data_found then
          ln_cal0 := 0;
          ln_cal1 := 0;
          ln_cal2 := 0;
          ln_cal3 := 0;
          ln_cal4 := 0;
      end;
      If ln_cal0 > 0 then
        JAQY774Cal := 1;
        lc_desc    := '- Normal';
      End If;
    
      If ln_cal1 > 0 then
        JAQY774Cal := 2;
        lc_desc    := '- C.P.P';
      
      End If;
    
      If ln_cal2 > 0 then
        JAQY774Cal := 3;
        lc_desc    := '- Deficiente';
      End If;
    
      If ln_cal3 > 0 then
        JAQY774Cal := 4;
        lc_desc    := '- Dudoso';
      End If;
    
      If ln_cal4 > 0 then
        JAQY774Cal := 5;
        lc_desc    := '- Perdida';
      End If;
    End If;
    v_Calif := JAQY774Cal;
    v_Desc  := lc_desc;
  
  end SP_CR_Calif_SBS;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_Cal_SBS_Titular(v_Tdoc  in number,
                                  v_Ndoc  in varchar2,
                                  d_Date  in date,
                                  v_Desc1 out varchar2) is
  
    ln_cal0   number(5, 2);
    ln_cal1   number(5, 2);
    ln_cal2   number(5, 2);
    ln_cal3   number(5, 2);
    ln_cal4   number(5, 2);
    D_FECPRE1 date;
    lc_tndoc  varchar2(12);
    lc_docsbs char(1);
    lc_desc1  varchar2(20);
    ln_tdoc1  number(2);
  
  Begin
  
    ln_tdoc1  := trim(v_Tdoc);
    lc_tndoc  := trim(v_Ndoc);
    lc_docsbs := fn_Tipo_Doc_SBS(v_Tdoc, v_Ndoc);
  
    D_FECPRE1 := d_Date;
  
    If (ln_tdoc1 <> 9) then
      Begin
        select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
        
          into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
          from CLDRCCI
         where D_FECPRE = D_FECPRE1
           and C_TDOCID = lc_docsbs
           and C_DOCIDE = lc_tndoc
           and rownum < 2;
      exception
        when no_data_found then
          ln_cal0  := 0;
          ln_cal1  := 0;
          ln_cal2  := 0;
          ln_cal3  := 0;
          ln_cal4  := 0;
          lc_desc1 := 'Sin Calificacion';
      end;
      If (ln_cal0 = 0 and ln_cal1 = 0 and ln_cal2 = 0 and ln_cal3 = 0 and
         ln_cal4 = 0) then
        lc_desc1 := 'Sin Calificacion';
      Else
        If ln_cal0 > 0 then
          lc_desc1 := 'Normal'; --1
        End If;
      
        If ln_cal1 > 0 then
          lc_desc1 := 'C.P.P'; --2
        
        End If;
      
        If ln_cal2 > 0 then
          lc_desc1 := 'Deficiente'; --3
        End If;
      
        If ln_cal3 > 0 then
          lc_desc1 := 'Dudoso'; --4
        End If;
      
        If ln_cal4 > 0 then
          lc_desc1 := 'Perdida'; --5
        End If;
      End If;
    Else
      Begin
        select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
        
          into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
        
          from CLDRCCI
         where D_FECPRE = D_FECPRE1
           and C_TDOCTR = lc_docsbs
           and C_DOCTRI = lc_tndoc
           and rownum < 2;
      exception
        when no_data_found then
          ln_cal0  := 0;
          ln_cal1  := 0;
          ln_cal2  := 0;
          ln_cal3  := 0;
          ln_cal4  := 0;
          lc_desc1 := 'Sin Calificacion';
      end;
      If ln_cal0 > 0 then
        lc_desc1 := 'Normal'; --1
      End If;
    
      If ln_cal1 > 0 then
        lc_desc1 := 'C.P.P'; --2
      
      End If;
    
      If ln_cal2 > 0 then
        lc_desc1 := 'Deficiente'; --3
      End If;
    
      If ln_cal3 > 0 then
        lc_desc1 := 'Dudoso'; --4
      End If;
    
      If ln_cal4 > 0 then
        lc_desc1 := 'Perdida'; --5
      End If;
    End If;
    v_Desc1 := lc_desc1;
  
  end sp_cr_Cal_SBS_Titular;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_Cal_SBS_Conyugue(v_Tdoc  in number,
                                   v_Ndoc  in varchar2,
                                   v_Desc2 out varchar2) is
  
    ln_cal0   number(5, 2);
    ln_cal1   number(5, 2);
    ln_cal2   number(5, 2);
    ln_cal3   number(5, 2);
    ln_cal4   number(5, 2);
    D_FECPRE1 date;
    lc_tndoc  varchar2(12);
    lc_docsbs char(1);
    lc_desc2  varchar2(20);
    ln_tdoc1  number(2);
    ln_FchSBS number(8);
    ln_dia    number(2);
    ln_Mes    number(2);
    ln_Anio   number(4);
    D_FECPRE  varchar2(15);
    PNDOC     char(12);
    lc_pndoc  varchar2(12);
  
  Begin
    Begin
      ln_tdoc1  := trim(v_Tdoc);
      lc_tndoc  := trim(v_Ndoc);
      lc_docsbs := fn_Tipo_Doc_SBS(v_Tdoc, v_Ndoc);
    
      ---------------------------------------------------
      select Tpnro
        into ln_FchSBS
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    
      ln_dia  := SubStr(ln_FchSBS, 1, 2);
      ln_Mes  := SubStr(ln_FchSBS, 3, 2);
      ln_Anio := SubStr(ln_FchSBS, 5, 4);
    
      D_FECPRE  := ln_dia || '/' || ln_Mes || '/' || ln_Anio;
      D_FECPRE1 := to_date(D_FECPRE, 'dd/mm/rrrr');
      PNDOC     := rpad(lc_tndoc, 12, ' ');
      lc_pndoc  := trim(PNDOC);
    Exception
      when no_data_found then
        D_FECPRE1 := null;
        D_FECPRE  := null;
    End;
    ------------------------------------------------------
  
    If (ln_tdoc1 <> 9) then
      Begin
        select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
        
          into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
          from CLDRCCI
         where D_FECPRE = D_FECPRE1
           and C_TDOCID = lc_docsbs
           and C_DOCIDE = lc_pndoc
           and rownum < 2;
      exception
        when no_data_found then
          ln_cal0  := 0;
          ln_cal1  := 0;
          ln_cal2  := 0;
          ln_cal3  := 0;
          ln_cal4  := 0;
          lc_desc2 := 'Sin Calificacion';
      end;
      If ln_cal0 > 0 then
        lc_desc2 := 'Normal'; --1
      End If;
    
      If ln_cal1 > 0 then
        lc_desc2 := 'C.P.P'; --2
      
      End If;
    
      If ln_cal2 > 0 then
        lc_desc2 := 'Deficiente'; --3
      End If;
    
      If ln_cal3 > 0 then
        lc_desc2 := 'Dudoso'; --4
      End If;
    
      If ln_cal4 > 0 then
        lc_desc2 := 'Perdida'; --5
      End If;
    Else
      Begin
        select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
        
          into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
          from CLDRCCI
         where D_FECPRE = D_FECPRE1
           and C_TDOCTR = lc_docsbs
           and C_DOCTRI = lc_pndoc
           and rownum < 2;
      exception
        when no_data_found then
          ln_cal0  := 0;
          ln_cal1  := 0;
          ln_cal2  := 0;
          ln_cal3  := 0;
          ln_cal4  := 0;
          lc_desc2 := 'Sin Calificacion';
      end;
      If ln_cal0 > 0 then
        lc_desc2 := 'Normal'; --1
      End If;
    
      If ln_cal1 > 0 then
        lc_desc2 := 'C.P.P'; --2
      
      End If;
    
      If ln_cal2 > 0 then
        lc_desc2 := 'Deficiente'; --3
      End If;
    
      If ln_cal3 > 0 then
        lc_desc2 := 'Dudoso'; --4
      End If;
    
      If ln_cal4 > 0 then
        lc_desc2 := 'Perdida'; --5
      End If;
    End If;
    v_Desc2 := lc_desc2;
  
  end sp_cr_Cal_SBS_Conyugue;
  ----------------------------------------------------------------------------------------
end PQ_CR_REPORTE_CRU;
/

