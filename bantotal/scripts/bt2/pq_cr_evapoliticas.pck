create or replace package pq_cr_evapoliticas is

  -- Author  : CCERPA
  -- Created : 26/05/2018
  -- Purpose :
  --pq_cr_evapoliticas.sp_ANTIGNEGOCIO pq_cr_evapoliticas.SP_CTACTS  
  --
  --camibo de tarea
  procedure sp_ANTIGNEGOCIO(ln_pepais in number,
                            ln_petdoc in number,
                            lc_ndoc   IN varchar2,
                            ln_result out number);
  procedure SP_CTACTS(ln_pepais in number,
                      ln_petdoc in number,
                      lc_ndoc   IN varchar2,
                      ln_result out number);
  procedure SP_tipocliente(ln_instancia in number, ln_result out number);
  procedure sp_deudarcc(ln_instancia in number, ln_result out number);

end pq_cr_evapoliticas;
/

CREATE OR REPLACE PACKAGE BODY pq_cr_evapoliticas is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_ANTIGNEGOCIO(ln_pepais in number,
                            ln_petdoc in number,
                            lc_ndoc   IN varchar2,
                            ln_result out number) is
    -- *****************************************************************
    -- Nombre                     : SP_ANTIGNRGOCIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Versión                    :
    -- Fecha de Creación          :17/05/2018
    -- Autor de Creación          : CCERPA
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ln_pepais (pais)
    --                              ln_petdoc (tipo documento)
    --                              lc_ndoc   (numero documento)
    -- Parámetros de Salida       : ln_result ()
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación:
    -- *****************************************************************
  
    lc_pendoc      char(12);
    ld_inicio      date;
    --lc_rute        CHAR(12);
    ld_fin         date;
    ln_mes         number;
    ln_yearenmeses number;
    ln_mesfin      number;
    ln_mesinicio   number;
    ln_yearfin     number;
    ln_yearinicio  number;
    ln_diafin      number;
    ln_diainicio   number;
  begin
    
    lc_pendoc := RPAD(lc_ndoc, 12, ' ');
    if ln_petdoc <> 9 then
      begin
        select sngc60.sngc60fini--, sngc60.sngc60rute
          into ld_inicio--, lc_rute
          from sngc60
         where sngc60.sngc60pais = ln_pepais
           and sngc60.sngc60tdoc = ln_petdoc
           and sngc60.sngc60ndoc = lc_pendoc
           and sngc60.sngc60corr=0
           and rownum = 1;
      exception
        When others then
          ld_inicio := TO_DATE('01/01/0001', 'dd/mm/yyyy');
       --   lc_rute   := '-1';
      end;
    end if;
    if ln_petdoc = 9 then
      begin
       -- lc_rute := '1';
        select fsd003.pjfcon
          into ld_inicio
          from fsd003
         where fsd003.pjpais = ln_pepais
           and fsd003.pjtdoc = ln_petdoc
           and fsd003.pjndoc = lc_pendoc
           and rownum = 1;
      exception
        When others then
          ld_inicio := TO_DATE('01/01/0001', 'dd/mm/yyyy');
          --lc_rute   := '-1';
      end;
    end if;
  
    begin
      select fst017.pgfape into ld_fin from fst017 where fst017.pgcod = 1;
    exception
      When others then
        ld_fin := TO_DATE('01/01/0001', 'dd/mm/yyyy');
    end;
    if ld_inicio <> TO_DATE('01/01/0001', 'dd/mm/yyyy') then
   /*   if (ld_fin >= ld_inicio and
         ld_fin <> TO_DATE('01/01/0001', 'dd/mm/yyyy')) then*/
        -----------MESES-------
        begin
          select to_char(ld_fin, 'MM') into ln_mesfin from dual;
        exception
          When others then
            ln_mesfin := 99;
        end;
        begin
          select to_char(ld_inicio, 'MM') into ln_mesinicio from dual;
        exception
          When others then
            ln_mesinicio := 99;
        end;
        -----------AÑO-------        
        begin
          select to_char(ld_fin, 'YYYY') into ln_yearfin from dual;
        exception
          When others then
            ln_yearfin := 99;
        end;
        begin
          select to_char(ld_inicio, 'YYYY') into ln_yearinicio from dual;
        exception
          When others then
            ln_yearinicio := 99;
        end;
        -----------DIA-------                
        begin
          select to_char(ld_fin, 'DD') into ln_diafin from dual;
        exception
          When others then
            ln_yearfin := 99;
        end;
        begin
          select to_char(ld_inicio, 'DD') into ln_diainicio from dual;
        exception
          When others then
            ln_yearinicio := 99;
        end;
        -------------------------------------------     
        if ln_mesfin <> 99 and ln_mesinicio <> 99 then
          ln_mes := ln_mesfin - ln_mesinicio;
        end if;
        if ln_yearfin <> 99 and ln_yearinicio <> 99 then
          ln_yearenmeses := (ln_yearfin - ln_yearinicio) * 12;
        end if;
        ln_result := ln_yearenmeses + ln_mes;
        if ln_diafin <> 99 and ln_diainicio <> 99 then
          if (ln_diafin - ln_diainicio) < 0 then
            ln_result := ln_result - 1;
          end if;
        end if;
      
     -- end if;
    else
      ln_result := 0;
    end if;
  end sp_ANTIGNEGOCIO;
  procedure SP_CTACTS(ln_pepais in number,
                      ln_petdoc in number,
                      lc_ndoc   IN varchar2,
                      ln_result out number) is
    -- *****************************************************************
    -- Nombre                     : SP_CTACTS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Versión                    :
    -- Fecha de Creación          :17/05/2018
    -- Autor de Creación          : CCERPA
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ln_pepais (pais)
    --                              ln_petdoc (tipo documento)
    --                              lc_ndoc   (numero documento)
    -- Parámetros de Salida       : ln_result (cantidad de conisdecia de modulo y tipo de dicha persona por cuentas)
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación:
    -- *****************************************************************   
    cursor listado_cuentas(cln_pais   number,
                           cln_tipdoc number,
                           cln_ndoc   char) is
      select fsr008.ctnro
        from fsr008
       where fsr008.pepais = cln_pais
         and fsr008.petdoc = cln_tipdoc
         and fsr008.pendoc = cln_ndoc
         and fsr008.cttfir = 'T';
  
    lc_pendoc    char(12);
    lc_resultado number;
  
  begin
    ln_result := 0;
    lc_pendoc := RPAD(lc_ndoc, 12, ' ');
    for cta in listado_cuentas(ln_pepais, ln_petdoc, lc_pendoc) loop
    
      begin
        select count(*)
          into lc_resultado
          from dual,
               (select fsr008.pepais pais,
                       fsr008.petdoc tdc,
                       fsr008.pendoc doc
                  from fsr008,
                       (select FSR011.R1CTA cuen
                          from fsd011
                         inner join fsr011
                            on fsd011.pgcod = fsr011.r2cod
                           and fsd011.scmod = fsr011.r2mod
                           and fsd011.scsuc = fsr011.r2suc
                           and fsd011.scmda = fsr011.r2mda
                           and fsd011.scpap = fsr011.r2pap
                           and fsd011.sccta = fsr011.r2cta
                           and fsd011.scoper = fsr011.r2oper
                           and fsd011.scsbop = fsr011.r2sbop
                           and fsd011.sctope = fsr011.r2tope
                         where fsd011.pgcod = 1
                           and fsd011.sccta = cta.ctnro
                           and fsd011.SCSTAT <> 99
                           and (fsd011.scmod, fsd011.sctope) in
                               (select fst198.tp1nro1, fst198.tp1nro2
                                  from fst198
                                 where fst198.tp1cod = 1
                                   and fst198.tp1cod1 = 11109
                                   and fst198.tp1corr1 = 50
                                   and fst198.tp1corr2=1)) cuentas
                 where fsr008.ctnro = cuentas.cuen) caso
         where (caso.pais, caso.tdc, caso.doc) in
               (select 604, fst098.tpnro, fst098.tpdesc
                  from fst098
                 where fst098.pgcod = 1
                   and fst098.tpcod = 1301);
        if lc_resultado > 0 then
          ln_result := lc_resultado;
          exit;
        else
          ln_result := 0;
        
        end if;
      end;
    end loop;
  
  end SP_CTACTS;

  procedure SP_tipocliente(ln_instancia in number, ln_result out number) is
    -- *****************************************************************
    -- Nombre                     : SP_CTACTS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Versión                    :
    -- Fecha de Creación          :17/05/2018
    -- Autor de Creación          : CCERPA
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ln_instancia (insntancia)
    -- Parámetros de Salida       : ln_result (cantidad de conisdecia de modulo y tipo de dicha persona por cuentas)
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación:
    -- *****************************************************************      
  
    lc_pendoc char(12);
    ln_cuenta number;
    ln_pais   number;
    ln_tipdoc number;
    cont_cli  number:=0;
  begin
  
    begin
      select sng001.sng001cta
        into ln_cuenta
        from sng001
       where sng001.sng001inst = ln_instancia;
    exception
      When others then
        ln_cuenta := 0;
    end;
    IF ln_cuenta > 0 THEN
      begin
        select FSR008.PEPAIS, FSR008.PETDOC, FSR008.PENDOC
          INTO ln_pais, ln_tipdoc, lc_pendoc
          from fsr008
         where fsr008.pgcod = 1
           and fsr008.ctnro = ln_cuenta
           and fsr008.ttcod = 1
           and fsr008.cttfir = 'T'
           and rownum = 1;
      exception
        When others then
          ln_pais   := 0;
          ln_tipdoc := 0;
          lc_pendoc := '0';
      end;
    END IF;
    if ln_pais > 0 and ln_tipdoc > 0 and lc_pendoc <> '0' then
      begin
        select count(*)
          into cont_cli
          from fsd010
         where fsd010.aomod in
               (select fst111.modulo from fst111 where fst111.dscod = 50)
           and fsd010.pgcod = 1
           and fsd010.aocta in (select fsr008.ctnro
                                  from fsr008
                                 where fsr008.pgcod = 1
                                   and fsr008.pepais = ln_pais
                                   and fsr008.petdoc = ln_tipdoc
                                   and fsr008.pendoc = lc_pendoc
                                   and fsr008.ttcod = 1);
      exception
        When others then
          cont_cli := 0;
      end;
    
    end if;
    if cont_cli>0 then
       cont_cli:=1;
    end if;
    ln_result := cont_cli;
    
  end SP_tipocliente;
  ---------------------------------------------------
  -- Nombre                     : SP_CTACTS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    :
  -- Fecha de Creación          :17/05/2018
  -- Autor de Creación          : CCERPA
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : ln_instancia (insntancia)
  -- Parámetros de Salida       : ln_result (cantidad de conisdecia de modulo y tipo de dicha persona por cuentas)
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación:

  ---------------------------------------------------
  procedure sp_deudarcc(ln_instancia in number, ln_result out number) is
    -- *****************************************************************
    -- Nombre                     : sp_deudarcc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Versión                    :
    -- Fecha de Creación          :17/05/2018
    -- Autor de Creación          : CCERPA
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ln_instancia (insntancia)
    -- Parámetros de Salida       : ln_result (cantidad de conisdecia de modulo y tipo de dicha persona por cuentas)
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación:
    -- *****************************************************************      
    cursor listado_codsbs(cln_codigosbs varchar2, cln_fecharcc date) is
      select cldrccs.c_codemp
        from cldrccs
       where cldrccs.c_codsbs = cln_codigosbs
         and cldrccs.d_fecpre = cln_fecharcc
       group by cldrccs.c_codemp;
  
    cursor listado_porbanca(cln_empresa   varchar2,
                            cln_codigosbs varchar2,
                            cln_fecharcc  date) is
      select cldrccs.c_cuenta, cldrccs.n_salcap
        from cldrccs
       where cldrccs.c_codsbs = cln_codigosbs
         and cldrccs.d_fecpre = cln_fecharcc
         and cldrccs.c_codemp = cln_empresa;
    cursor lista_cuentas is
      select sng001.sng001pais, sng001.sng001tdoc, sng001.sng001ndoc
        from sng001
       where sng001.sng001inst = ln_instancia
      union
      select fsr002.rppais, fsr002.rptdoc, fsr002.rpndoc
        from fsr002
       inner join sng001
          on fsr002.pepais = sng001.sng001pais
         and fsr002.petdoc = sng001.sng001tdoc
         and fsr002.pendoc = sng001.sng001ndoc
       where sng001.sng001inst = ln_instancia
         and fsr002.rpccyg = 66
      union
      select fsr002.pepais, fsr002.petdoc, fsr002.pendoc
        from fsr002
       inner join sng001
          on fsr002.rppais = sng001.sng001pais
         and fsr002.rptdoc = sng001.sng001tdoc
         and fsr002.rpndoc = sng001.sng001ndoc
       where sng001.sng001inst = ln_instancia
         and fsr002.rpccyg = 66;
  
    ln_pais         number;
    ln_pendoc       number;
    ln_dni          char(12);
    Lv_dni          varchar2(12);
    fecharcc        date;
    lc_prgm         varchar2(5) := 'otros';
    codigosbs       varchar2(10);
    responsabilidad number := 0;
    utilizacion     number := 0;
    valortemp       number;
    resultadoline   number := 0;
    deudaexterna    number := 0;
    totalcaja       number := 0;
    tipocambio2     number;
    fechanterior    date;
    fechaproceso    date;
    noconcidero     number := 0;
  begin
  
    /*begin
      select sng001.sng001pais, sng001.sng001tdoc,sng001.sng001ndoc 
        into ln_pais,ln_tipdoc,lc_pendoc
      from sng001
      where    sng001.sng001inst=ln_instancia;
        exception 
                      When others then
                  ln_pais:=0;
                  ln_tipdoc:=0;
                  lc_pendoc:='0';
    end;*/
    begin
      select fst017.pgfape
        into fechaproceso
        from fst017
       where fst017.pgcod = 1;
    exception
      When others then
        fechaproceso := to_date('01/01/0001', 'dd/mm/YYYY');
    end;
    begin
      select fst017.pgfape - 1
        into fechanterior
        from fst017
       where fst017.pgcod = 1;
    exception
      When others then
        fechanterior := to_date('01/01/0001', 'dd/mm/YYYY');
    end;
    begin
      select to_date(a.tpnro, 'dd/mm/YYYY')
        into fecharcc
        from fst098 a
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      When others then
        fecharcc := to_date('01/01/0001', 'dd/mm/YYYY');
    end;
  
    for cuenta in lista_cuentas loop
      Lv_dni := TRIM(cuenta.sng001ndoc);
    
      if cuenta.sng001tdoc <> 9 then
        BEGIN
          select cldrcci.c_codsbs
            INTO codigosbs
            from cldrcci
           where cldrcci.d_fecpre = fecharcc
             and cldrcci.c_docide = Lv_dni;
        exception
          When others then
            codigosbs := '0';
        END;
      else
      
        BEGIN
          select cldrcci.c_codsbs
            INTO codigosbs
            from cldrcci
           where cldrcci.d_fecpre = fecharcc
             and cldrcci.c_doctri = Lv_dni;
        exception
          When others then
            codigosbs := '0';
        END;
      end if;
    
      if codigosbs <> '0' then
        resultadoline := 0;
        for cod_sbsfec in listado_codsbs(codigosbs, fecharcc) loop
          if cod_sbsfec.c_codemp <> '00104' then
            for detallebanca in listado_porbanca(cod_sbsfec.c_codemp,
                                                 codigosbs,
                                                 fecharcc) loop
              ------linea otorgada
              /* begin
              valortemp:=0;
              select count(*)into valortemp from fst198
                                                            Where Tp1cod = 1
                                                            and Tp1cod1 = 10899
                                                            and Tp1corr1 = 13
                                                            and Tp1corr2 = 10
                                                            and TRIM(fst198.tp1desc)=TRIM(substr(detallebanca.c_cuenta,1,4));
                 if  valortemp>0 then 
                   ---resultado linea
                     resultadoline:=resultadoline+detallebanca.n_salcap;
                   ---resultado linea                 
                 end if;                                                     
              end;*/
              valortemp := 0;
              ------utilizacion
              begin
                select count(*)
                  into valortemp
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 8
                   and TRIM(fst198.tp1desc) =
                       TRIM(substr(detallebanca.c_cuenta, 1, 4));
              
                if valortemp > 0 then
                  ---resultado utilizacion
                  valortemp := 0;
                  select count(*)
                    into valortemp
                    from fst198
                   Where Tp1cod = 1
                     and Tp1cod1 = 10899
                     and Tp1corr1 = 13
                     and Tp1corr2 = 11
                     and TRIM(fst198.tp1desc) =
                         TRIM(substr(detallebanca.c_cuenta, 7, 2));
                  if valortemp > 0 then
                
                      utilizacion := utilizacion + detallebanca.n_salcap;
                 
                  
                  end if;
                  ---resultado Utilizacion           
                end if;
              end;
              ------responsabilidad
              begin
                valortemp := 0;
                select count(*)
                  into valortemp
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 9
                   and TRIM(fst198.tp1desc) =
                       TRIM(substr(detallebanca.c_cuenta, 1, 6));
              
                if valortemp > 0 then
                  ---resultado responsabilidad 
                 
                    responsabilidad := responsabilidad +
                                       detallebanca.n_salcap;
                
                
                  ---resultado responsabilidad           
                end if;
              end;
              begin
                valortemp := 0;
                --rubros de 4 digitos
                select count(*)
                  into valortemp
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 6
                   and TRIM(fst198.tp1desc) =
                       TRIM(substr(detallebanca.c_cuenta, 1, 4));
              
                if valortemp > 0 then
                  -----no tarjeta
               if substr(detallebanca.c_cuenta, 7, 2) = '02' then
                      noconcidero := noconcidero + 1;
               else
                   if substr(detallebanca.c_cuenta, 7, 2) = '19' then
                      noconcidero := noconcidero + 1;                     
                   else 
                      deudaexterna := deudaexterna +
                                              detallebanca.n_salcap;
                   end if;
               end if;
                 /*
                    if substr(detallebanca.c_cuenta, 7, 2) = '02' and
                       substr(detallebanca.c_cuenta, 1, 4) = '1411' then
                      noconcidero := noconcidero + 1;
                    else
                      if substr(detallebanca.c_cuenta, 7, 2) = '02' and
                         substr(detallebanca.c_cuenta, 1, 4) = '1421' then
                        noconcidero := noconcidero + 1;
                      else
                        if substr(detallebanca.c_cuenta, 7, 2) = '19' and
                           substr(detallebanca.c_cuenta, 1, 4) = '1421' then
                          noconcidero := noconcidero + 1;
                        else
                          if substr(detallebanca.c_cuenta, 7, 2) = '19' and
                             substr(detallebanca.c_cuenta, 1, 4) = '1411' then
                            noconcidero := noconcidero + 1;
                          else
                          
                              deudaexterna := deudaexterna +
                                              detallebanca.n_salcap;
                           
                          end if;
                        end if;
                      end if;
                    end if;
                */
                  -----no tarjeta                    
                end if;
              end;
            
              begin
                valortemp := 0;
                --rubros de 6 digitos
                select count(*)
                  into valortemp
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 7
                   and TRIM(fst198.tp1desc) =
                       TRIM(substr(detallebanca.c_cuenta, 1, 6));
              
                if valortemp > 0 then
                  -----no tarjeta
                 
                    deudaexterna := deudaexterna + detallebanca.n_salcap;
                 
                
                  -----no tarjeta                    
                end if;
              end;
            
            end loop;
          end if;
        end loop;
      end if;
    end loop;
    lc_prgm := 'otros';
    begin
      select sng001.sng001pais, sng001.sng001tdoc, sng001.sng001ndoc
        into ln_pais, ln_pendoc, ln_dni
        from sng001
       where sng001.sng001inst = ln_instancia;
    exception
      When others then
        ln_pais   := 0;
        ln_pendoc := 0;
        ln_dni    := '0';
    end;
    begin
      select fn_tipo_cambio(fechanterior, 101, 0, 0)
        into tipocambio2
        from dual;
    exception
      When others then
        tipocambio2 := 0;
    end;
  
    PQ_CR_Deudacajatitular.sp_cuentas(ln_pais,
                                      ln_pendoc,
                                      ln_dni,
                                      tipocambio2,
                                      ln_instancia,
                                      fechaproceso,
                                      lc_prgm,
                                      totalcaja);
  
    ln_result := responsabilidad + utilizacion + deudaexterna + totalcaja;
    /*begin 
      insert into aqpa265 (aqpa265inst,aqpa265resut,aqpa265fcha)
      values (ln_instancia,ln_result,SYSDATE );
       commit;      
    end;     */
  end sp_deudarcc;

end pq_cr_evapoliticas;
/

