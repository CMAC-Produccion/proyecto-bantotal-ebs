CREATE OR REPLACE TRIGGER TG_WFWRKITEMS_AI_01
  after insert on WFWRKITEMS
  for each row

  -- *******************************************************************************************************
  -- Nombre                     : TG_WFWRKITEMS_INS_RATIO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2018.08.28
  -- Autor de Creación          : Maria Caridad Postigo Condori - CAJA AREQUIPA
  -- Uso                        : Ejecucion de Ratios al momento de ingresar la instancia a la tarea de Desembolso
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- ********************************************************************************************************

DECLARE

  lc_SegmntoActual number;
  ln_Instancia     number;

  ld_fchsist    date;
  ln_cuotprop   number;
  ln_cuotaprob  number;
  ln_NewCuota   number;
  ln_pgcod      number;
  ln_suc        number;
  ln_mod        number;
  ln_mda        number;
  ln_pap        number;
  ln_cta        number;
  ln_oper       number;
  ln_subop      number;
  ln_toper      number;
  ld_FchMaxCuot date;
  ln_NewCapCaja number;
  ln_MntSegur   number;
  ln_MntCapCuot number;
  lc_hora       char(8);

BEGIN

  If :new.wftaskcod = 55 and :new.wfitemstsact = 1 and
     :new.wfitemprvtask = 11 then
  
    ln_Instancia := :new.wfinsprcid;
    lc_hora      := to_char(sysdate, 'HH24:MI:SS');
  
    begin
      select pgfape into ld_fchsist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    /*begin
      insert into jaqz830
        (jaqz830corr,
         jaqz830pais,
         jaqz830tdoc,
         jaqz830ndoc,
         jaqz830inst,
         jaqz830fec,
         jaqz830hora)
      values
        (:new.wftaskcod,
         :new.wfitemstsact,
         :new.wfitemprvtask,
         'ENTRASTE',
         ln_Instancia,
         ld_fchsist,
         lc_hora);
    end;*/
  
    begin
      PQ_CR_VERIFICASEGMENTO.sp_cr_SegmntoActual(ln_Instancia,
                                                 lc_SegmntoActual); --mpostigoc 08/03/2018
    
    end;
  
    begin
      select max(S.SNG120CUO)
        into ln_cuotprop
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk like 'PROPUEST%'; -- En tarea de Propuesta
    exception
      when others then
        ln_cuotprop := 0;
    end;
  
    begin
      select c.xllcantcuo
        into ln_cuotaprob
        from xwf700 x, x054023 c
       where x.xwfempresa = c.xllpgcod
         and x.xwfsucursal = c.xllaosuc
         and x.xwfmodulo = c.xllaomod
         and x.xwfmoneda = c.xllaomda
         and x.xwfpapel = c.xllaopap
         and x.xwfcuenta = c.xllaocta
         and x.xwfoperacion = c.xllaooper
         and x.xwfsubope = c.xllaosbop
         and x.xwftipope = c.xllaotop
         and x.xwfcar3 = '1'
         and x.xwfprcins = ln_Instancia; -- ultimo nro de cuotas modificado
    exception
      when others then
        null;
    end;
  
    if lc_SegmntoActual = 1 then
    
      if ln_cuotprop = ln_cuotaprob then
      
        begin
          update jaqz832
             set jaqz832est = 'I'
           where jaqz832inst = ln_Instancia
             and jaqz832est = 'H';
        end;
        begin
          update jaqz833
             set jaqz833est = 'I'
           where jaqz833inst = ln_Instancia
             and jaqz833est = 'H';
          -- commit;
        end;
      
        begin
          insert into jaqz832
            (jaqz832corr,
             jaqz832pais,
             jaqz832tdoc,
             jaqz832ndoc,
             jaqz832tcamb,
             jaqz832inst,
             jaqz832fec,
             jaqz832capcaja,
             jaqz832sldext,
             jaqz832resnet,
             jaqz832ratio,
             jaqz832ind,
             jaqz832est,
             jaqz832hora,
             jaqz832user)
            select J.JAQY140CORR,
                   J.JAQY140PAIS,
                   J.JAQY140TDOC,
                   J.JAQY140NDOC,
                   J.JAQY140TCAMB,
                   J.JAQY140INST,
                   ld_fchsist,
                   J.JAQY140CAPCAJA,
                   J.JAQY140SLDEXT,
                   J.JAQY140RESNET,
                   J.JAQY140RATIO,
                   '1',
                   J.JAQY140EST,
                   to_char(sysdate, 'HH24:MI:SS'),
                   J.JAQY140USER
              from jaqy140 j
             where j.jaqy140inst = ln_Instancia
               and j.jaqy140est = 'H';
        end; -- Cabecera
      
        begin
          insert into jaqz833
            (jaqz833corr,
             jaqz833fec,
             jaqz833hora,
             jaqz833pais,
             jaqz833tdoc,
             jaqz833ndoc,
             jaqz833tcamb,
             jaqz833inst,
             jaqz833segm,
             jaqz833pgcod,
             jaqz833mod,
             jaqz833suc,
             jaqz833mda,
             jaqz833pap,
             jaqz833cta,
             jaqz833ope,
             jaqz833sbop,
             jaqz833tope,
             jaqz833perio,
             jaqz833nrcuo,
             jaqz833tsoli,
             jaqz833flcj,
             jaqz833cuoimp,
             jaqz833seguro,
             jaqz833capfc,
             jaqz833caplin,
             jaqz833capcuo,
             jaqz833indic,
             jaqz833est,
             jaqz833user)
            select j.jaqy142corr,
                   ld_fchsist,
                   to_char(sysdate, 'HH24:MI:SS'),
                   j.jaqy142pais,
                   j.jaqy142tdoc,
                   j.jaqy142ndoc,
                   j.jaqy142tcamb,
                   j.jaqy142inst,
                   1,
                   j.jaqy142pgcod,
                   j.jaqy142mod,
                   j.jaqy142suc,
                   j.jaqy142mda,
                   j.jaqy142pap,
                   j.jaqy142cta,
                   j.jaqy142ope,
                   j.jaqy142sbop,
                   j.jaqy142tope,
                   j.jaqy142perio,
                   j.jaqy142nrcuo,
                   j.jaqy142tsoli,
                   j.jaqy142flcj,
                   j.jaqy142cuoimp,
                   j.jaqy142seguro,
                   j.jaqy142capfc,
                   j.jaqy142caplin,
                   j.jaqy142capcuo,
                   j.jaqy142indic,
                   j.jaqy142est,
                   j.jaqy142user
              from jaqy142 j
             where j.jaqy142inst = ln_Instancia
               and j.jaqy142est = 'H';
        end; --detalle
      
      else
        if ln_cuotprop <> ln_cuotaprob then
        
          begin
            update jaqz832
               set jaqz832est = 'I'
             where jaqz832inst = ln_Instancia
               and jaqz832est = 'H';
            -- commit;
          end;
        
          begin
            update jaqz833
               set jaqz833est = 'I'
             where jaqz833inst = ln_Instancia
               and jaqz833est = 'H';
            -- commit;
          end;
        
          begin
            insert into jaqz832
              (jaqz832corr,
               jaqz832pais,
               jaqz832tdoc,
               jaqz832ndoc,
               jaqz832tcamb,
               jaqz832inst,
               jaqz832fec,
               jaqz832capcaja,
               jaqz832sldext,
               jaqz832resnet,
               jaqz832ratio,
               jaqz832ind,
               jaqz832est,
               jaqz832hora,
               jaqz832user)
              select J.JAQY140CORR,
                     J.JAQY140PAIS,
                     J.JAQY140TDOC,
                     J.JAQY140NDOC,
                     J.JAQY140TCAMB,
                     J.JAQY140INST,
                     ld_fchsist,
                     J.JAQY140CAPCAJA,
                     J.JAQY140SLDEXT,
                     J.JAQY140RESNET,
                     J.JAQY140RATIO,
                     '1',
                     J.JAQY140EST,
                     to_char(sysdate, 'HH24:MI:SS'),
                     J.JAQY140USER
                from jaqy140 j
               where j.jaqy140inst = ln_Instancia
                 and j.jaqy140est = 'H';
          end; --cabecera
        
          begin
            insert into jaqz833
              (jaqz833corr,
               jaqz833fec,
               jaqz833hora,
               jaqz833pais,
               jaqz833tdoc,
               jaqz833ndoc,
               jaqz833tcamb,
               jaqz833inst,
               jaqz833segm,
               jaqz833pgcod,
               jaqz833mod,
               jaqz833suc,
               jaqz833mda,
               jaqz833pap,
               jaqz833cta,
               jaqz833ope,
               jaqz833sbop,
               jaqz833tope,
               jaqz833perio,
               jaqz833nrcuo,
               jaqz833tsoli,
               jaqz833flcj,
               jaqz833cuoimp,
               jaqz833seguro,
               jaqz833capfc,
               jaqz833caplin,
               jaqz833capcuo,
               jaqz833indic,
               jaqz833est,
               jaqz833user)
            
              select j.jaqy142corr,
                     ld_fchsist,
                     to_char(sysdate, 'HH24:MI:SS'),
                     j.jaqy142pais,
                     j.jaqy142tdoc,
                     j.jaqy142ndoc,
                     j.jaqy142tcamb,
                     j.jaqy142inst,
                     1,
                     j.jaqy142pgcod,
                     j.jaqy142mod,
                     j.jaqy142suc,
                     j.jaqy142mda,
                     j.jaqy142pap,
                     j.jaqy142cta,
                     j.jaqy142ope,
                     j.jaqy142sbop,
                     j.jaqy142tope,
                     j.jaqy142perio,
                     j.jaqy142nrcuo,
                     j.jaqy142tsoli,
                     j.jaqy142flcj,
                     j.jaqy142cuoimp,
                     j.jaqy142seguro,
                     j.jaqy142capfc,
                     j.jaqy142caplin,
                     j.jaqy142capcuo,
                     j.jaqy142indic,
                     j.jaqy142est,
                     j.jaqy142user
                from jaqy142 j
               where j.jaqy142inst = ln_Instancia
                 and j.jaqy142est = 'H';
          end; --detalle
        
          begin
            select max(c.ppcap + c.ppint),
                   c.pgcod,
                   c.ppsuc,
                   c.ppmod,
                   c.ppmda,
                   c.pppap,
                   c.ppcta,
                   c.ppoper,
                   c.ppsbop,
                   c.pptope
              into ln_NewCuota,
                   ln_pgcod,
                   ln_suc,
                   ln_mod,
                   ln_mda,
                   ln_pap,
                   ln_cta,
                   ln_oper,
                   ln_subop,
                   ln_toper
              from xwf700 x, fsd601 c
             where x.xwfempresa = c.pgcod
               and x.xwfsucursal = c.ppsuc
               and x.xwfmodulo = c.ppmod
               and x.xwfmoneda = c.ppmda
               and x.xwfpapel = c.pppap
               and x.xwfcuenta = c.ppcta
               and x.xwfoperacion = c.ppoper
               and x.xwfsubope = c.ppsbop
               and x.xwftipope = c.pptope
               and x.xwfcar3 = '1'
               and x.xwfprcins = ln_Instancia
             group by c.pgcod,
                      c.ppmod,
                      c.ppsuc,
                      c.ppmda,
                      c.pppap,
                      c.ppcta,
                      c.ppoper,
                      c.ppsbop,
                      c.pptope;
          exception
            when others then
              null;
          end;
        
          begin
            select max(f.ppfpag)
              into ld_FchMaxCuot
              from fsd601 f
             where f.pgcod = ln_pgcod
               and f.ppmod = ln_mod
               and f.ppsuc = ln_suc
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_oper
               and f.ppsbop = ln_subop
               and f.pptope = ln_toper
               and (f.ppcap + f.ppint) = ln_NewCuota; -- Fecha de la Maxima Cuota
          exception
            when others then
              null;
          end;
        
          begin
            select max(f.ppimp11 + f.ppimp12 + f.ppimp13 + f.ppimp14 +
                       f.ppimp15)
              into ln_MntSegur
              from fsd611 f
             where f.pgcod = ln_pgcod
               and f.ppmod = ln_mod
               and f.ppsuc = ln_suc
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_oper
               and f.ppsbop = ln_subop
               and f.pptope = ln_toper
               and f.ppfpag = ld_FchMaxCuot; -- Monto del seguro para la Maxima fecha
          exception
            when others then
              null;
          end;
        
          ln_MntCapCuot := nvl(ln_NewCuota, 0) + nvl(ln_MntSegur, 0);
        
          begin
            --Actualiza nuevos valores a la solicitud en vuelo
            update jaqz833 j
               set j.jaqz833nrcuo  = ln_cuotaprob,
                   j.jaqz833cuoimp = ln_NewCuota,
                   j.jaqz833seguro = ln_MntSegur,
                   j.jaqz833capcuo = ln_MntCapCuot
             where j.jaqz833pgcod = ln_pgcod
               and j.jaqz833mod = ln_mod
               and j.jaqz833suc = ln_suc
               and j.jaqz833mda = ln_mda
               and j.jaqz833pap = ln_pap
               and j.jaqz833cta = ln_cta
               and j.jaqz833ope = ln_oper
               and j.jaqz833sbop = ln_subop
               and j.jaqz833tope = ln_toper;
          end;
        
          begin
            select sum(j.jaqz833capcuo)
              into ln_NewCapCaja
              from jaqz833 j
             where j.jaqz833inst = ln_Instancia
               and j.jaqz833est = 'H';
          end;
        
          begin
            update jaqz832 j
               set j.jaqz832capcaja = ln_NewCapCaja
             where j.jaqz832inst = ln_Instancia
               and j.jaqz832est = 'H';
          end;
        
          begin
            update jaqz832 j
               set j.jaqz832ratio =
                   (j.jaqz832capcaja + j.jaqz832sldext) /
                   (j.jaqz832resnet + j.jaqz832sldext)
             where j.jaqz832inst = ln_Instancia
               and j.jaqz832est = 'H';
          end; -- Nuevo calculo del Ratio
        
        end if;
      
      end if;
    
    else
      if lc_SegmntoActual = 2 then
      
        if ln_cuotprop = ln_cuotaprob then
        
          begin
            update jaqz832
               set jaqz832est = 'I'
             where jaqz832inst = ln_Instancia
               and jaqz832est = 'H';
            -- commit;
          end;
        
          begin
            update jaqz833
               set jaqz833est = 'I'
             where jaqz833inst = ln_Instancia
               and jaqz833est = 'H';
            -- commit;
          end;
        
          begin
            insert into jaqz832
              (jaqz832corr,
               jaqz832pais,
               jaqz832tdoc,
               jaqz832ndoc,
               jaqz832tcamb,
               jaqz832inst,
               jaqz832fec,
               jaqz832capcaja,
               jaqz832sldext,
               jaqz832resnet,
               jaqz832ratio,
               jaqz832ind,
               jaqz832est,
               jaqz832hora,
               jaqz832user)
              select J.JAQZ821CORR,
                     J.JAQZ821PAIS,
                     J.JAQZ821TDOC,
                     J.JAQZ821NDOC,
                     J.JAQZ821TCAMB,
                     J.JAQZ821INST,
                     ld_fchsist,
                     J.JAQZ821CAPCAJA,
                     J.JAQZ821SLDEXT,
                     J.JAQZ821EXDMENS,
                     J.JAQZ821RATIO,
                     '1',
                     J.JAQZ821EST,
                     to_char(sysdate, 'HH24:MI:SS'),
                     J.JAQZ821USER
                from JAQZ821 j
               where j.JAQZ821inst = ln_Instancia
                 and j.JAQZ821est = 'H';
          end; -- Cabecera
        
          begin
            insert into jaqz833
              (jaqz833corr,
               jaqz833fec,
               jaqz833hora,
               jaqz833pais,
               jaqz833tdoc,
               jaqz833ndoc,
               jaqz833tcamb,
               jaqz833inst,
               jaqz833segm,
               jaqz833pgcod,
               jaqz833mod,
               jaqz833suc,
               jaqz833mda,
               jaqz833pap,
               jaqz833cta,
               jaqz833ope,
               jaqz833sbop,
               jaqz833tope,
               jaqz833perio,
               jaqz833nrcuo,
               jaqz833tsoli,
               jaqz833flcj,
               jaqz833cuoimp,
               jaqz833seguro,
               jaqz833capfc,
               jaqz833caplin,
               jaqz833capcuo,
               jaqz833indic,
               jaqz833est,
               jaqz833user)
              select j.JAQZ822corr,
                     ld_fchsist,
                     to_char(sysdate, 'HH24:MI:SS'),
                     j.JAQZ822pais,
                     j.JAQZ822tdoc,
                     j.JAQZ822ndoc,
                     j.JAQZ822tcamb,
                     j.JAQZ822inst,
                     2,
                     j.JAQZ822pgcod,
                     j.JAQZ822mod,
                     j.JAQZ822suc,
                     j.JAQZ822mda,
                     j.JAQZ822pap,
                     j.JAQZ822cta,
                     j.JAQZ822ope,
                     j.JAQZ822sbop,
                     j.JAQZ822tope,
                     j.JAQZ822perio,
                     j.JAQZ822nrcuo,
                     j.JAQZ822tsoli,
                     j.JAQZ822flcj,
                     j.JAQZ822cuoimp,
                     j.JAQZ822seguro,
                     j.JAQZ822capfc,
                     j.JAQZ822caplin,
                     j.JAQZ822capcuo,
                     j.JAQZ822indic,
                     j.JAQZ822est,
                     j.JAQZ822user
                from JAQZ822 j
               where j.JAQZ822inst = ln_Instancia
                 and j.JAQZ822est = 'H';
          end; --detalle
        
        else
          if ln_cuotprop <> ln_cuotaprob then
          
            begin
              update jaqz832
                 set jaqz832est = 'I'
               where jaqz832inst = ln_Instancia
                 and jaqz832est = 'H';
              -- commit;
            end;
          
            begin
              update jaqz833
                 set jaqz833est = 'I'
               where jaqz833inst = ln_Instancia
                 and jaqz833est = 'H';
              -- commit;
            end;
          
            begin
              insert into jaqz832
                (jaqz832corr,
                 jaqz832pais,
                 jaqz832tdoc,
                 jaqz832ndoc,
                 jaqz832tcamb,
                 jaqz832inst,
                 jaqz832fec,
                 jaqz832capcaja,
                 jaqz832sldext,
                 jaqz832resnet,
                 jaqz832ratio,
                 jaqz832ind,
                 jaqz832est,
                 jaqz832hora,
                 jaqz832user)
                select J.JAQZ821CORR,
                       J.JAQZ821PAIS,
                       J.JAQZ821TDOC,
                       J.JAQZ821NDOC,
                       J.JAQZ821TCAMB,
                       J.JAQZ821INST,
                       ld_fchsist,
                       J.JAQZ821CAPCAJA,
                       J.JAQZ821SLDEXT,
                       J.JAQZ821EXDMENS,
                       J.JAQZ821RATIO,
                       '2',
                       J.JAQZ821EST,
                       to_char(sysdate, 'HH24:MI:SS'),
                       J.JAQZ821USER
                  from JAQZ821 j
                 where j.JAQZ821inst = ln_Instancia
                   and j.JAQZ821est = 'H';
            end; --cabecera
          
            begin
              insert into jaqz833
                (jaqz833corr,
                 jaqz833fec,
                 jaqz833hora,
                 jaqz833pais,
                 jaqz833tdoc,
                 jaqz833ndoc,
                 jaqz833tcamb,
                 jaqz833inst,
                 jaqz833segm,
                 jaqz833pgcod,
                 jaqz833mod,
                 jaqz833suc,
                 jaqz833mda,
                 jaqz833pap,
                 jaqz833cta,
                 jaqz833ope,
                 jaqz833sbop,
                 jaqz833tope,
                 jaqz833perio,
                 jaqz833nrcuo,
                 jaqz833tsoli,
                 jaqz833flcj,
                 jaqz833cuoimp,
                 jaqz833seguro,
                 jaqz833capfc,
                 jaqz833caplin,
                 jaqz833capcuo,
                 jaqz833indic,
                 jaqz833est,
                 jaqz833user)
              
                select j.JAQZ822corr,
                       ld_fchsist,
                       to_char(sysdate, 'HH24:MI:SS'),
                       j.JAQZ822pais,
                       j.JAQZ822tdoc,
                       j.JAQZ822ndoc,
                       j.JAQZ822tcamb,
                       j.JAQZ822inst,
                       2,
                       j.JAQZ822pgcod,
                       j.JAQZ822mod,
                       j.JAQZ822suc,
                       j.JAQZ822mda,
                       j.JAQZ822pap,
                       j.JAQZ822cta,
                       j.JAQZ822ope,
                       j.JAQZ822sbop,
                       j.JAQZ822tope,
                       j.JAQZ822perio,
                       j.JAQZ822nrcuo,
                       j.JAQZ822tsoli,
                       j.JAQZ822flcj,
                       j.JAQZ822cuoimp,
                       j.JAQZ822seguro,
                       j.JAQZ822capfc,
                       j.JAQZ822caplin,
                       j.JAQZ822capcuo,
                       j.JAQZ822indic,
                       j.JAQZ822est,
                       j.JAQZ822user
                  from JAQZ822 j
                 where j.JAQZ822inst = ln_Instancia
                   and j.JAQZ822est = 'H';
            end; --detalle
          
            begin
              select max(c.ppcap + c.ppint),
                     c.pgcod,
                     c.ppmod,
                     c.ppsuc,
                     c.ppmda,
                     c.pppap,
                     c.ppcta,
                     c.ppoper,
                     c.ppsbop,
                     c.pptope
                into ln_NewCuota,
                     ln_pgcod,
                     ln_mod,
                     ln_suc,
                     ln_mda,
                     ln_pap,
                     ln_cta,
                     ln_oper,
                     ln_subop,
                     ln_toper
                from xwf700 x, fsd601 c
               where x.xwfempresa = c.pgcod
                 and x.xwfsucursal = c.ppsuc
                 and x.xwfmodulo = c.ppmod
                 and x.xwfmoneda = c.ppmda
                 and x.xwfpapel = c.pppap
                 and x.xwfcuenta = c.ppcta
                 and x.xwfoperacion = c.ppoper
                 and x.xwfsubope = c.ppsbop
                 and x.xwftipope = c.pptope
                 and x.xwfcar3 = '1'
                 and x.xwfprcins = ln_Instancia
               group by c.pgcod,
                        c.ppmod,
                        c.ppsuc,
                        c.ppmda,
                        c.pppap,
                        c.ppcta,
                        c.ppoper,
                        c.ppsbop,
                        c.pptope;
            exception
              when others then
                null;
            end;
          
            begin
              select max(f.ppfpag)
                into ld_FchMaxCuot
                from fsd601 f
               where f.pgcod = ln_pgcod
                 and f.ppmod = ln_mod
                 and f.ppsuc = ln_suc
                 and f.ppmda = ln_mda
                 and f.pppap = ln_pap
                 and f.ppcta = ln_cta
                 and f.ppoper = ln_oper
                 and f.ppsbop = ln_subop
                 and f.pptope = ln_toper
                 and (f.ppcap + f.ppint) = ln_NewCuota; -- Fecha de la Maxima Cuota
            exception
              when others then
                null;
            end;
          
            begin
              select max(f.ppimp11 + f.ppimp12 + f.ppimp13 + f.ppimp14 +
                         f.ppimp15)
                into ln_MntSegur
                from fsd611 f
               where f.pgcod = ln_pgcod
                 and f.ppmod = ln_mod
                 and f.ppsuc = ln_suc
                 and f.ppmda = ln_mda
                 and f.pppap = ln_pap
                 and f.ppcta = ln_cta
                 and f.ppoper = ln_oper
                 and f.ppsbop = ln_subop
                 and f.pptope = ln_toper
                 and f.ppfpag = ld_FchMaxCuot; -- Monto del seguro para la Maxima fecha
            exception
              when others then
                null;
            end;
          
            ln_MntCapCuot := nvl(ln_NewCuota, 0) + nvl(ln_MntSegur, 0);
          
            begin
              --Actualiza nuevos valores a la solicitud en vuelo
              update jaqz833 j
                 set j.jaqz833nrcuo  = ln_cuotaprob,
                     j.jaqz833cuoimp = ln_NewCuota,
                     j.jaqz833seguro = ln_MntSegur,
                     j.jaqz833capcuo = ln_MntCapCuot
               where j.jaqz833pgcod = ln_pgcod
                 and j.jaqz833mod = ln_mod
                 and j.jaqz833suc = ln_suc
                 and j.jaqz833mda = ln_mda
                 and j.jaqz833pap = ln_pap
                 and j.jaqz833cta = ln_cta
                 and j.jaqz833ope = ln_oper
                 and j.jaqz833sbop = ln_subop
                 and j.jaqz833tope = ln_toper;
            end;
          
            begin
              select sum(j.jaqz833capcuo)
                into ln_NewCapCaja
                from jaqz833 j
               where j.jaqz833inst = ln_Instancia
                 and j.jaqz833est = 'H';
            end;
          
            begin
              update jaqz832 j
                 set j.jaqz832capcaja = ln_NewCapCaja
               where j.jaqz832inst = ln_Instancia
                 and j.jaqz832est = 'H';
            end;
          
            begin
              update jaqz832 j
                 set j.jaqz832ratio =
                     (j.jaqz832capcaja + j.jaqz832sldext) /
                     (j.jaqz832resnet + j.jaqz832sldext)
               where j.jaqz832inst = ln_Instancia
                 and j.jaqz832est = 'H';
            end; -- Nuevo calculo del Ratio
          
          end if;
        END IF;
      END IF;
    END IF;
  END IF;

exception
  when others then
    null;
  
END TG_WFWRKITEMS_INS_RATIO;
/

