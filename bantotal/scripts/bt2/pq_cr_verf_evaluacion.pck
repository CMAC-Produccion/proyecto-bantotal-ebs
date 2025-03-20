create or replace package PQ_CR_VERF_EVALUACION is
  -- *****************************************************************
  -- Nombre                     : Paquete Verificar componentes de la Evaluacion
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 4/12/2024 11:05:33
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Paquete Verificar componentes de la Evaluacion
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 11/12/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modifico el procedimeinto que verifica conceptos
  -- Fecha de Modificación      : 13/12/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modifico la consulta que verifica gastos financieros cuando se mantene eval.
  -- *****************************************************************

  procedure sp_cr_VerfConceptos(ln_Instancia  in number,
                                lc_VerEvalChk out varchar2);
  -----------------------------------------------------------------
  procedure sp_Cr_Log_AQPB185(ln_ins      in number,
                              ln_neval    in number,
                              ln_meval    in number,
                              lc_chkeval  in varchar2,
                              ln_gfmsorl  in number,
                              ln_gfmsobt  in number,
                              ln_gfmdorl  in number,
                              ln_gfmdobt  in number,
                              ln_gffmsorl in number,
                              ln_gffmsobt in number,
                              ln_gffmdorl in number,
                              ln_gffmdobt in number,
                              ln_gffnsorl in number,
                              ln_gffnsobt in number,
                              ln_gffndorl in number,
                              ln_gffndobt in number,
                              ln_difisrat in number,
                              ln_gfinsobt in number,
                              ln_gfindobt in number,
                              ln_gfinto   in number);

end PQ_CR_VERF_EVALUACION;
/

create or replace package body PQ_CR_VERF_EVALUACION is

  procedure sp_cr_VerfConceptos(ln_Instancia  in number,
                                lc_VerEvalChk out varchar2) is
  
    ln_NroEval        number;
    ln_ModEval        number;
    ln_GFamSolRl      number(17, 2) := 0.00;
    ln_GFamSolBT      number(17, 2) := 0.00;
    ln_GFamDolRl      number(17, 2) := 0.00;
    ln_GFamDolBT      number(17, 2) := 0.00;
    ln_PSDSol         number(17, 2) := 0.00;
    ln_PSDDol         number(17, 2) := 0.00;
    ln_GFinanSolBT    number(17, 2) := 0.00;
    ln_GFinanDolBT    number(17, 2) := 0.00;
    lc_GastFamChk     varchar2(5) := 'S';
    lc_GstFinanChk    varchar2(5) := 'S';
    ln_GastFFamPSDol  number(17, 2) := 0.00;
    ln_GastFFamPSDSol number(17, 2) := 0.00;
    ln_GstFinanPSDSol number(17, 2) := 0.00;
    ln_GstFinanPSDol  number(17, 2) := 0.00;
    ln_GstFinanBTSol  number(17, 2) := 0.00;
    ln_GstFinanBTDol  number(17, 2) := 0.00;
    ln_GastFFamBTSol  number(17, 2) := 0.00;
    ln_GastFFamBTDol  number(17, 2) := 0.00;
    ln_HayInfoPSD     number := 0;
    ln_DIFISRat       number(17, 2) := 0.00;
    ln_TipCamb        number(14, 6) := 0.00000;
    ln_GFinTotal      number(17, 2) := 0.00;
    ln_GFSoles        number(17, 2) := 0.00;
    ln_CPSoles        number(17, 2) := 0.00;
    ln_GFDolar        number(17, 2) := 0.00;
    ln_GFSolesFam     number(17, 2) := 0.00;
    ln_CPSolesFam     number(17, 2) := 0.00;
  
  begin
  
    lc_VerEvalChk  := 'S';
    lc_GastFamChk  := 'S';
    lc_GstFinanChk := 'S';
  
    begin
      update aqpb185 a
         set a.aqpb185est = 'I'
       where a.aqpb185ins = ln_Instancia;
      commit;
    end;
  
    begin
      select s.sng021eval, s.sng021tmod
        into ln_NroEval, ln_ModEval
        from sng021 s
       where s.sng021sol = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_NroEval > 0 and ln_ModEval = 13 then
      -- Verifica la suma de todos los compomentes de gastos familiares en Evaluacion Independiente.
      begin
        begin
          select sum(s.sng023mto)
            into ln_GFamSolRl
            from sng023 s
           where s.sng021eval = ln_NroEval
             and s.sng026cod in (13, 14, 15, 16, 17, 18, 19, 20);
        exception
          when others then
            ln_GFamSolRl := 0;
        end;
      
        ln_GFamSolRl := nvl(ln_GFamSolRl, 0);
      
        begin
          select s.sng023mto
            into ln_GFamSolBT
            from sng023 s
           where s.sng021eval = ln_NroEval
             and s.sng026cod = 54;
        exception
          when others then
            ln_GFamSolBT := 0;
        end;
      
        ln_GFamSolBT := nvl(ln_GFamSolBT, 0);
      
        begin
          select sum(s.sng023mto)
            into ln_GFamDolRl
            from sng023 s
           where s.sng021eval = ln_NroEval
             and s.sng026cod in (513, 514, 515, 516, 517, 518, 519, 520);
        exception
          when others then
            ln_GFamDolRl := 0;
        end;
      
        ln_GFamDolRl := nvl(ln_GFamDolRl, 0);
      
        begin
          select s.sng023mto
            into ln_GFamDolBT
            from sng023 s
           where s.sng021eval = ln_NroEval
             and s.sng026cod = 554;
        
        exception
          when others then
            ln_GFamDolBT := 0;
        end;
      
        ln_GFamDolBT := nvl(ln_GFamDolBT, 0);
      
        if ln_GFamSolRl <> ln_GFamSolBT or ln_GFamDolRl <> ln_GFamDolBT then
          lc_GastFamChk := 'N';
        end if;
      
        if lc_GastFamChk = 'N' then
          lc_VerEvalChk := 'GFAM';
        end if;
      end;
    
      if lc_VerEvalChk = 'S' then
        -- Primero Verifica si hay data registrada en el Panel Saldo Deudor (PSD)
        begin
          select count(*)
            into ln_HayInfoPSD
            from jaqy327 j
           where j.jaqy327inst = ln_Instancia
             and j.jaqy327esta = 'S'
             and j.jaqy327chek = '1';
        exception
          when others then
            ln_HayInfoPSD := 0;
        end;
      
        if ln_HayInfoPSD > 0 then
        
          --Verifica los Gastos Financieros Familiares (Consumo /Hipotecario) y Gastos Financieros Ganancias (Pyme)
          begin
            select s.sng023mto
              into ln_GastFFamBTSol
              from sng023 s
             where s.sng021eval = ln_NroEval
               and s.sng026cod = 19;
          exception
            when others then
              ln_GastFFamBTSol := 0;
          end;
        
          ln_GastFFamBTSol := nvl(ln_GastFFamBTSol, 0);
        
          begin
            select s.sng023mto
              into ln_GastFFamBTDol
              from sng023 s
             where s.sng021eval = ln_NroEval
               and s.sng026cod = 519;
          exception
            when others then
              ln_GastFFamBTDol := 0;
          end;
        
          ln_GastFFamBTDol := nvl(ln_GastFFamBTDol, 0);
        
          begin
            select s.sng023mto
              into ln_GstFinanBTSol
              from sng023 s
             where s.sng021eval = ln_NroEval
               and s.sng026cod = 79;
          exception
            when others then
              ln_GstFinanBTSol := 0;
          end;
        
          ln_GstFinanBTSol := nvl(ln_GstFinanBTSol, 0);
        
          begin
            select s.sng023mto
              into ln_GstFinanBTDol
              from sng023 s
             where s.sng021eval = ln_NroEval
               and s.sng026cod = 579;
          exception
            when others then
              ln_GstFinanBTDol := 0;
          end;
        
          ln_GstFinanBTDol := nvl(ln_GstFinanBTDol, 0);
        
          begin
            select nvl(sum(j.jaqy327gfin), 0)
              into ln_GFSoles
              from jaqy327 j
             where j.jaqy327inst = ln_Instancia
               and j.jaqy327esta = 'S'
               and j.jaqy327chek = '1'
               and j.jaqy327cent <> '00104'
               and j.jaqy327tcre = 'Pymes S/.';
          exception
            when others then
              ln_GFSoles := 0;
          end;
        
          begin
            select nvl(sum(j.jaqy327cptn), 0)
              into ln_CPSoles
              from jaqy327 j
             where j.jaqy327inst = ln_Instancia
               and j.jaqy327esta = 'S'
               and j.jaqy327chek = '1'
               and j.jaqy327tcre in ('Pymes S/.', 'Pymes US$');
          exception
            when others then
              ln_CPSoles := 0;
          end;
        
          ln_GstFinanPSDSol := nvl(ln_GFSoles, 0) + nvl(ln_CPSoles, 0);
        
          begin
            select nvl(sum(j.jaqy327gfin), 0)
              into ln_GFDolar
              from jaqy327 j
             where j.jaqy327inst = ln_Instancia
               and j.jaqy327esta = 'S'
               and j.jaqy327chek = '1'
               and j.jaqy327cent <> '00104'
               and j.jaqy327tcre = 'Pymes US$';
          exception
            when others then
              ln_GFDolar := 0;
          end;
        
          ln_GstFinanPSDol := nvl(ln_GFDolar, 0);
        
          begin
            select nvl(sum(j.jaqy327gfin), 0)
              into ln_GFSolesFam
              from jaqy327 j
             where j.jaqy327inst = ln_Instancia
               and j.jaqy327esta = 'S'
               and j.jaqy327chek = '1'
               and j.jaqy327cent <> '00104'
               and j.jaqy327tcre in ('Consumo S/.', 'Hipotecario S/.');
          exception
            when others then
              ln_GFSolesFam := 0;
          end;
        
          begin
            select nvl(sum(j.jaqy327cptn), 0)
              into ln_CPSolesFam
              from jaqy327 j
             where j.jaqy327inst = ln_Instancia
               and j.jaqy327esta = 'S'
               and j.jaqy327chek = '1'
               and j.jaqy327tcre in ('Consumo S/.',
                                     'Hipotecario S/.',
                                     'Consumo US$',
                                     'Hipotecario US$');
          exception
            when others then
              ln_CPSolesFam := 0;
          end;
        
          ln_GastFFamPSDSol := nvl(ln_GFSolesFam, 0) +
                               nvl(ln_CPSolesFam, 0);
        
          begin
            select nvl(sum(j.jaqy327gfin), 0)
              into ln_GastFFamPSDol
              from jaqy327 j
             where j.jaqy327inst = ln_Instancia
               and j.jaqy327esta = 'S'
               and j.jaqy327chek = '1'
               and j.jaqy327cent <> '00104'
               and j.jaqy327tcre in ('Consumo US$', 'Hipotecario US$');
          exception
            when others then
              ln_GastFFamPSDol := 0;
          end;
        
          ln_GastFFamPSDol := nvl(ln_GastFFamPSDol, 0);
        
          if ln_GastFFamBTSol <> ln_GastFFamPSDSol or
             ln_GastFFamBTDol <> ln_GastFFamPSDol or
             ln_GstFinanBTSol <> ln_GstFinanPSDSol or
             ln_GstFinanBTDol <> ln_GstFinanPSDol then
          
            lc_GstFinanChk := 'N';
          
          end if;
        
          if lc_GstFinanChk = 'N' then
            lc_VerEvalChk := 'GFIN';
          end if;
        
        else
          if ln_HayInfoPSD = 0 then
          
            begin
              select j.jaqy140sldext, j.jaqy140tcamb
                into ln_DIFISRat, ln_TipCamb
                from jaqy140 j
               where j.jaqy140inst = ln_Instancia
                 and j.jaqy140est = 'H'
                 and j.jaqy140tarea = 7;
            exception
              when others then
                ln_DIFISRat := 0;
            end;
          
            begin
              select sum(s.sng023mto)
                into ln_GstFinanBTSol
                from sng023 s
               where s.sng021eval = ln_NroEval
                 and s.sng026cod in (19, 79);
            exception
              when others then
                ln_GstFinanBTSol := 0;
            end;
          
            ln_GstFinanBTSol := nvl(ln_GstFinanBTSol, 0);
          
            begin
              select sum(s.sng023mto)
                into ln_GstFinanBTDol
                from sng023 s
               where s.sng021eval = ln_NroEval
                 and s.sng026cod in (519, 579);
            exception
              when others then
                ln_GstFinanBTDol := 0;
            end;
          
            ln_GstFinanBTDol := nvl(ln_GstFinanBTDol, 0);
          
            ln_GFinTotal := ln_GstFinanBTSol +
                            (ln_GstFinanBTDol * ln_TipCamb);
          
            if ln_DIFISRat <> ln_GFinTotal then
              lc_GstFinanChk := 'N';
            end if;
          
            if lc_GstFinanChk = 'N' then
              lc_VerEvalChk := 'GFIN';
            end if;
          end if;
        end if;
      end if;
    
      pq_cr_verf_evaluacion.sp_Cr_Log_AQPB185(ln_ins      => ln_Instancia,
                                              ln_neval    => ln_NroEval,
                                              ln_meval    => ln_ModEval,
                                              lc_chkeval  => lc_VerEvalChk,
                                              ln_gfmsorl  => ln_GFamSolRl,
                                              ln_gfmsobt  => ln_GFamSolBT,
                                              ln_gfmdorl  => ln_GFamDolRl,
                                              ln_gfmdobt  => ln_GFamDolBT,
                                              ln_gffmsorl => ln_GastFFamPSDSol,
                                              ln_gffmsobt => ln_GastFFamBTSol,
                                              ln_gffmdorl => ln_GastFFamPSDol,
                                              ln_gffmdobt => ln_GastFFamBTDol,
                                              ln_gffnsorl => ln_GstFinanPSDSol,
                                              ln_gffnsobt => ln_GstFinanBTSol,
                                              ln_gffndorl => ln_GstFinanPSDol,
                                              ln_gffndobt => ln_GstFinanBTDol,
                                              ln_difisrat => ln_DIFISRat,
                                              ln_gfinsobt => ln_GstFinanBTSol,
                                              ln_gfindobt => ln_GstFinanBTDol,
                                              ln_gfinto   => ln_GFinTotal);
    
    else
      if ln_ModEval = 14 then
        -- Verifica Gastos Financieros Resumen vs PSD    
      
        begin
          select sum(j.JAQZ862gfin)
            into ln_PSDSol
            from JAQZ862 j
           where j.JAQZ862inst = ln_Instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.jaqz862cent <> '00104'
             and j.JAQZ862tcre in
                 ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.');
        exception
          when others then
            ln_PSDSol := 0.00;
        end;
      
        ln_PSDSol := nvl(ln_PSDSol, 0);
      
        begin
          select s.sng023mto
            into ln_GFinanSolBT
            from sng023 s
           where s.sng021eval = ln_NroEval
             and s.sng026cod = 30;
        exception
          when others then
            ln_GFinanSolBT := 0;
        end;
      
        ln_GFinanSolBT := nvl(ln_GFinanSolBT, 0);
      
        begin
          select sum(j.JAQZ862gfin)
            into ln_PSDDol
            from JAQZ862 j
           where j.JAQZ862inst = ln_Instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.jaqz862cent <> '00104'
             and j.JAQZ862tcre in
                 ('Pymes US$', 'Consumo US$', 'Hipotecario US$');
        exception
          when others then
            ln_PSDDol := 0.00;
        end;
      
        ln_PSDDol := nvl(ln_PSDDol, 0);
      
        begin
          select s.sng023mto
            into ln_GFinanDolBT
            from sng023 s
           where s.sng021eval = ln_NroEval
             and s.sng026cod = 530;
        exception
          when others then
            ln_GFinanDolBT := 0;
        end;
      
        ln_GFinanDolBT := nvl(ln_GFinanDolBT, 0);
      
        if ln_PSDSol <> ln_GFinanSolBT or ln_PSDDol <> ln_GFinanDolBT then
          lc_GstFinanChk := 'N';
        end if;
      
        if lc_GstFinanChk = 'N' then
          lc_VerEvalChk := 'GFIN';
        
        end if;
      
        pq_cr_verf_evaluacion.sp_Cr_Log_AQPB185(ln_ins      => ln_Instancia,
                                                ln_neval    => ln_NroEval,
                                                ln_meval    => ln_ModEval,
                                                lc_chkeval  => lc_VerEvalChk,
                                                ln_gfmsorl  => ln_GFamSolRl,
                                                ln_gfmsobt  => ln_GFamSolBT,
                                                ln_gfmdorl  => ln_GFamDolRl,
                                                ln_gfmdobt  => ln_GFamDolBT,
                                                ln_gffmsorl => ln_GastFFamPSDSol,
                                                ln_gffmsobt => ln_GastFFamBTSol,
                                                ln_gffmdorl => ln_GastFFamPSDol,
                                                ln_gffmdobt => ln_GastFFamBTDol,
                                                ln_gffnsorl => ln_PSDSol,
                                                ln_gffnsobt => ln_GFinanSolBT,
                                                ln_gffndorl => ln_PSDDol,
                                                ln_gffndobt => ln_GFinanDolBT,
                                                ln_difisrat => ln_DIFISRat,
                                                ln_gfinsobt => ln_GstFinanBTSol,
                                                ln_gfindobt => ln_GstFinanBTDol,
                                                ln_gfinto   => ln_GFinTotal);
      end if;
    end if;
  
  end sp_cr_VerfConceptos;
  --------------------------------------------------------------------------------------------
  procedure sp_Cr_Log_AQPB185(ln_ins      in number,
                              ln_neval    in number,
                              ln_meval    in number,
                              lc_chkeval  in varchar2,
                              ln_gfmsorl  in number,
                              ln_gfmsobt  in number,
                              ln_gfmdorl  in number,
                              ln_gfmdobt  in number,
                              ln_gffmsorl in number,
                              ln_gffmsobt in number,
                              ln_gffmdorl in number,
                              ln_gffmdobt in number,
                              ln_gffnsorl in number,
                              ln_gffnsobt in number,
                              ln_gffndorl in number,
                              ln_gffndobt in number,
                              ln_difisrat in number,
                              ln_gfinsobt in number,
                              ln_gfindobt in number,
                              ln_gfinto   in number) is
  
    ln_cor  number := 0;
    ld_fch  date;
    lc_hora varchar2(10) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpb185cor)
        into ln_cor
        from aqpb185 a
       where a.aqpb185ins = ln_ins;
    exception
      when others then
        null;
    end;
    ln_cor := nvl(ln_cor, 0);
  
    begin
      select f.pgfape into ld_fch from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb185
        (aqpb185cor,
         aqpb185fch,
         aqpb185hora,
         aqpb185ins,
         aqpb185neval,
         aqpb185meval,
         aqpb185chkeval,
         aqpb185gfmsorl,
         aqpb185gfmsobt,
         aqpb185gfmdorl,
         aqpb185gfmdobt,
         aqpb185gffmsorl,
         aqpb185gffmsobt,
         aqpb185gffmdorl,
         aqpb185gffmdobt,
         aqpb185gffnsorl,
         aqpb185gffnsobt,
         aqpb185gffndorl,
         aqpb185gffndobt,
         aqpb185difisrat,
         aqpb185gfinsobt,
         aqpb185gfindobt,
         aqpb185gfinto,
         aqpb185est)
      values
        (ln_cor + 1,
         ld_fch,
         lc_hora,
         ln_ins,
         ln_neval,
         ln_meval,
         lc_chkeval,
         ln_gfmsorl,
         ln_gfmsobt,
         ln_gfmdorl,
         ln_gfmdobt,
         ln_gffmsorl,
         ln_gffmsobt,
         ln_gffmdorl,
         ln_gffmdobt,
         ln_gffnsorl,
         ln_gffnsobt,
         ln_gffndorl,
         ln_gffndobt,
         ln_difisrat,
         ln_gfinsobt,
         ln_gfindobt,
         ln_gfinto,
         'H');
      commit;
    end;
  end sp_Cr_Log_AQPB185;

end PQ_CR_VERF_EVALUACION;
/

