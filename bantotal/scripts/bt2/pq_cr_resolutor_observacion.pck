create or replace package pq_cr_resolutor_observacion is

    -- *****************************************************************
    -- Nombre                     : PAQUETES PARA EVALUAR Y OBTENER EL RATIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.10.11
    -- Autor de Creación          : CRISTHIAN CERPA
    -- Uso                        : Realiza cálculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --                            : 2018.07.27  DCASTRO se agrego condicion tp1nro en consulta de guia de proceso especial FST198 

    -- *****************************************************************


   procedure sp_credhipotecario( ln_instancia     in number,
                                 ln_respuesta     out number);
   Procedure SP_CR_RESOLUTOR_verifmda( ln_instancia   in number,
                                       ln_respuesta   out number);
   Procedure SP_CR_RESOLUTOR_cuotreprog( ln_instancia   in number,
                                         ln_respuesta   out number) ;      
   Procedure SP_CR_RESOLUTOR_FRECCRED( ln_instancia   in number,
                                       ln_respuesta   out number);                                                                                                             
  Procedure sp_cr_codactiv (ln_intancia in number,respuesta out number ) ;
  Procedure sp_cr_codactvprecagri(ln_intancia in number,respuesta_a out number,respuesta_p out number ) ;

end pq_cr_resolutor_observacion;
/

create or replace package body pq_cr_resolutor_observacion is
   -- *****************************************************************
    -- Nombre                     : sp_resultadonetolinea
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : CRISTHIAN CERPA
    -- Uso                        : EVALUA EL OTORGAMIENTO DEUN CREDITO HIPOTECARIO cAJA.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    -- Retorno                    :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --                            : 2018.07.27  DCASTRO se agrego condicion tp1nro en consulta de guia de proceso especial FST198    --
	-- Fecha de Modificación      : 26/09/2018
  -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
  -- Descripción de Modificación: se cambio la guia de proceso para la obtencion de actividades prihibidas
    -- *****************************************************************

    procedure sp_credhipotecario( ln_instancia     in number,
                                 ln_respuesta     out number) is

     Begin
ln_respuesta:=0;

            begin
              SELECT 1 into ln_respuesta  FROM SNG001 
                INNER JOIN FSR008 
                ON FSR008.PEPAIS=SNG001.SNG001PAIS
                AND SNG001.SNG001TDOC=FSR008.PETDOC 
                AND SNG001.SNG001NDOC=FSR008.PENDOC
                INNER JOIN  FSD010 
                ON FSR008.CTNRO=FSD010.AOCTA
                 and fsr008.pgcod=FSD010.PGCOD                  --23/07/2018
                WHERE SNG001.SNG001INST=ln_instancia 
                AND FSD010.AOMOD=110 
                AND FSD010.AOSTAT<>99
                and ROWNUM =1;
                exception
                     when others then
                       ln_respuesta:=0;
                null;
             ENd;


    End sp_credhipotecario;
    Procedure SP_CR_RESOLUTOR_verifmda( ln_instancia   in number,
                                        ln_respuesta   out number) is
lc_temp character(1);
  
 
     begin 
       select 'N' into lc_temp
          from sng122 a,fsr011 b,fsd011 c,xwf700 d where a.sng122inst =ln_instancia 
          and a.sng122pgc  = b.r2cod
          and a.sng122mod  = b.r2mod
          and a.sng122suc  = b.r2suc
          and a.sng122mda  = b.r2mda
          and a.sng122pap  = b.r2pap
          and a.sng122cta  = b.r2cta
          and a.sng122oper = b.r2oper
          and a.sng122sbop = b.r2sbop
          and a.sng122tope = b.r2tope
          and b.relcod     = 2
          and b.r1cod      = c.pgcod
          and b.r1mod      = c.scmod
          and b.r1suc      = c.scsuc
          and b.r1mda      = c.scmda
          and b.r1pap      = c.scpap
          and b.r1cta      = c.sccta
          and b.r1oper     = c.scoper
          and b.r1sbop     = c.scsbop
          and b.r1tope     = c.sctope
          and d.xwfprcins  = a.sng122inst
          and d.xwfcar3    = '1'
          and b.r1mda      <> d.xwfmoneda
          and rownum       = 1;
          exception
         
          when no_data_found then
           begin             
          lc_temp:='S';
       end;
         
        if lc_temp='N' then
          ln_respuesta:=0;
        else
          ln_respuesta:=1;
        end if;

    end SP_CR_RESOLUTOR_verifmda;
    -----------------------------------------
 Procedure SP_CR_RESOLUTOR_cuotreprog( ln_instancia   in number,
                                       ln_respuesta   out number) is
          empresa     number(3);
          sucursal    number(3);
          modulo      number(3);
          moneda      NUMBER(4);
          papel       NUMBER(4);
          cuenta      NUMBER(9);
          operacion   NUMBER(9);
          suboper     NUMBER(3);
          tipope      NUMBER(3);
          valorcap    NUMBER(17,2);
          contador    NUMBER(10);
        begin
          begin
          select xwf700.xwfempresa,
          xwf700.xwfsucursal,
          xwf700.xwfmodulo,
          xwf700.xwfmoneda,
          xwf700.xwfpapel,
          xwf700.xwfcuenta,
          xwf700.xwfoperacion,
          xwf700.xwfsubope,
          xwf700.xwftipope into 
          empresa,  
          sucursal,  
          modulo,   
          moneda,    
          papel,           
          cuenta,    
          operacion,
          suboper,   
          tipope    
           from xwf700  
           where xwf700.xwfprcins=ln_instancia 
           and xwf700.xwfcar3<>'1';
            exception
                  when others then
                    null;
        END;        
          select count(*) into contador
             from fsd602  where fsd602.pp1stat='T' and fsd602.pgcod=empresa
             and fsd602.ppsuc=sucursal and fsd602.ppmod=modulo   and fsd602.ppmda=moneda 
             and fsd602.pppap=papel and fsd602.ppcta=cuenta and fsd602.ppoper=operacion
             and fsd602.ppsbop=suboper and fsd602.pptope=tipope  AND fsd602.d602co='S';
             
        if contador>0 then 
          begin
          select SUM(fsd602.pp1icap + fsd602.pp1cap) into valorcap
             from fsd602  where fsd602.pp1stat='T' and fsd602.pgcod=empresa
             and fsd602.ppsuc=sucursal and fsd602.ppmod=modulo   and fsd602.ppmda=moneda 
             and fsd602.pppap=papel and fsd602.ppcta=cuenta and fsd602.ppoper=operacion
             and fsd602.ppsbop=suboper and fsd602.pptope=tipope  AND fsd602.d602co='S';
--          Exception others then null;
            exception
                  when others then
                    valorcap:=0;     
          end;
             if valorcap>0 then 
                   ln_respuesta:=1;
             else 
                   ln_respuesta:=0; 
             end if;
             
        else 
            ln_respuesta:=0;
        end if ; 

          
end SP_CR_RESOLUTOR_cuotreprog;
------------------------------------------------------------------------------------
Procedure SP_CR_RESOLUTOR_FRECCRED( ln_instancia   in number,
                                    ln_respuesta   out number) is
    ---Creditos orginales
      creorpgcod  number;
      creoraomod  number;
      creoraosuc  number;
      creoraomda  number;
      creoraopap  number;
      creoraocta  number;
      creoraooper number;
      creoraosbop number;
      creoraotop  number;
    ---frecuencia de reporgramados
      frerepgcod  number;
      frereaomod  number;
      frereaosuc  number;
      frereaomda  number;
      frereaopap  number;
      frereaocta  number;
      frereaooper number;
      frereaosbop number;
      frereaotop  number;
      contarcreor number;
      contarfrere number;

      periodofsd010 number;
      periodoz054023 number;
      exitereprogramado char;
    begin
      contarcreor:=0;
      contarfrere:=0;
      
      exitereprogramado :='N';
      begin
      select 'S' into exitereprogramado from sng001  where sng001.sng001inst=ln_instancia and sng001.sng001ori=13;
      exception when others then
         exitereprogramado :='N';
    end;
      if exitereprogramado='S' then
            select count(*) into contarcreor from xwf700 where  xwf700.xwfcar3<>'1' AND XWF700.XWFPRCINS=ln_instancia ;
            if contarcreor>0 then
              select xwf700.xwfempresa,xwf700.xwfsucursal,xwf700.xwfmodulo,xwf700.xwfmoneda
              ,xwf700.xwfpapel,xwf700.xwfcuenta,xwf700.xwfoperacion,xwf700.xwfsubope,xwf700.xwftipope
              into creorpgcod,creoraosuc,creoraomod,creoraomda,creoraopap,creoraocta,creoraooper,creoraosbop,creoraotop
              from xwf700 where  xwf700.xwfcar3<>'1' AND XWF700.XWFPRCINS=ln_instancia;

              select fsd010.aoperiod into periodofsd010 from fsd010 where fsd010.pgcod=creorpgcod
              and fsd010.aomod=creoraomod and fsd010.aosuc=creoraosuc and fsd010.aomda=creoraomda and fsd010.aopap=creoraopap
              and fsd010.aocta=creoraocta and fsd010.aooper=creoraooper and fsd010.aosbop=creoraosbop and fsd010.aotope=creoraotop;

            end if;

            select count(*) into contarfrere from xwf700 where  xwf700.xwfcar3='1' AND XWF700.XWFPRCINS=ln_instancia ;
            if   contarfrere>0 then
              select xwf700.xwfempresa,xwf700.xwfmodulo,xwf700.xwfsucursal,xwf700.xwfmoneda
              ,xwf700.xwfpapel,xwf700.xwfcuenta,xwf700.xwfoperacion,xwf700.xwfsubope,xwf700.xwftipope into
              frerepgcod,frereaomod ,frereaosuc,frereaomda,frereaopap,frereaocta,frereaooper,frereaosbop,frereaotop
              from xwf700 where  xwf700.xwfcar3='1' AND XWF700.XWFPRCINS=ln_instancia ;

              select x054023.xllperiodo into periodoz054023 from x054023 where x054023.xllpgcod=frerepgcod and x054023.xllaomod=frereaomod and x054023.xllaosuc=frereaosuc
              and x054023.xllaomda=frereaomda and x054023.xllaopap=frereaopap and x054023.xllaocta=frereaocta and x054023.xllaooper=frereaooper
              and x054023.xllaosbop=frereaosbop and x054023.xllaotop=frereaotop;
            end if;
                  if contarcreor>0 and contarfrere>0 then
                      if periodofsd010< periodoz054023 then--OJITO SE CAMBIO EL SIHGNO A OPUESTO
                           ln_respuesta:=1;
                       else
                           ln_respuesta:=0;
                      end if;
                  else
                      if contarcreor>0 then
                         ln_respuesta:=1;
                      end if;

                      if contarfrere>0 then
                        ln_respuesta:=0;
                      end if;
                  end if;
      else
            ln_respuesta:=0;              
      end if;
    


end SP_CR_RESOLUTOR_FRECCRED;
---------------------------------------------------------------------------------------

Procedure sp_cr_codactiv(ln_intancia in number, respuesta out number) is
    pn_pais   number;
    pn_tdoc   number;
    pc_ndoc   character(12);
    ln_activi number;
  
  begin
  
    begin
      select sng001.sng001pais, sng001.sng001tdoc, sng001.sng001ndoc
        into pn_pais, pn_tdoc, pc_ndoc
        from sng001
       where sng001.sng001inst = ln_intancia;
        exception                     --31/07/2018
            when others then 
            pn_pais := 0;
            pn_tdoc := 0;
            pc_ndoc :='0';             --31/07/2018
    
    end;
  
    begin
      select xx.actcod1
        into ln_activi
        from sngc60 aa, fst750 xx
       where aa.sngc60pais = pn_pais
         and aa.sngc60tdoc = pn_tdoc
         and aa.sngc60ndoc = pc_ndoc
         and aa.sngc60corr = 0
         and aa.sngc60acte = xx.actcod1;
    exception
      when no_data_found then
        begin
        
          select xxx.actcod1
            into ln_activi
            from sngc11 cc, fst750 xxx
           where cc.sngc11pais = pn_pais
             and cc.sngc11tdoc = pn_tdoc
             and cc.sngc11ndoc = pc_ndoc
             and cc.sngc11act2 = xxx.actcod1;
        exception
          when no_data_found then
            begin
            
              select xxx.actcod1
                into ln_activi
                from fse001 cc, fst750 xxx
               where cc.d511pais = pn_pais
                 and cc.d511tdoc = pn_tdoc
                 and cc.d511ndoc = pc_ndoc
                 and cc.expnins = xxx.actcod1;
            exception
              when others then
                ln_activi := 0;
            end;
        end;
      
      when too_many_rows then
        ln_activi := 0;
      
    end;
    begin
      select count(a.tp1nro1)
        into respuesta
        from fst198 a
       where a.tp1cod1 = 11109
         and a.tp1corr1 = 5
         and a.tp1nro1 = ln_activi; --chernandez 26/09/2018
         
    end;
    if respuesta = 0 then
      respuesta := 0;
    else
      respuesta := 1;
    end if;
    --   return ln_activi;
  end sp_cr_codactiv;
---------------------------------------------------------------------------------------

 Procedure sp_cr_codactvprecagri(ln_intancia in number,respuesta_a out number,respuesta_p out number ) is
   pn_pais number;
   pn_tdoc  number;
   pc_ndoc character(12);
   ln_activi number;
   ln_agropecuario number;
   ln_pecuario number;
begin
 
    
 begin 
    select sng001.sng001pais,sng001.sng001tdoc,sng001.sng001ndoc 
    into pn_pais,pn_tdoc,pc_ndoc from sng001 where sng001.sng001inst=ln_intancia;
     exception                                --31/07/2018
            when others then 
            pn_pais := 0;
            pn_tdoc := 0;                     
            pc_ndoc :='0';                    --31/07/2018
  end; 
    begin
      select xx.actcod1
        into ln_activi
        from sngc60 aa, fst750 xx
       where aa.sngc60pais = pn_pais
         and aa.sngc60tdoc = pn_tdoc
         and aa.sngc60ndoc = pc_ndoc
         and aa.sngc60corr = 0
         and aa.sngc60acte = xx.actcod1;
      exception
          when no_data_found then
               begin
               
                      select xxx.actcod1
                        into ln_activi
                        from sngc11 cc,fst750 xxx
                       where cc.sngc11pais = pn_pais
                         and cc.sngc11tdoc = pn_tdoc
                         and cc.sngc11ndoc = pc_ndoc
                         and cc.sngc11act2 = xxx.actcod1;
               exception
                   when no_data_found then
                        begin
                            
                            select xxx.actcod2
                            into ln_activi
                            from fse001 cc, fst750 xxx
                           where cc.d511pais = pn_pais
                             and cc.d511tdoc = pn_tdoc
                             and cc.d511ndoc = pc_ndoc
                             and cc.expnins = xxx.actcod1;
                        exception
                             when others then 
                                  ln_activi := 0;
                        end;
               end;
      
          when too_many_rows then
             ln_activi := 0;
             
      end;

if ln_activi>0 then
----------Pecuario---------------
    begin 
        select count(*) into ln_pecuario 
        from fst198 
        where fst198.tp1cod=1 and fst198.tp1cod1=11109 
        and fst198.tp1corr1=10 and fst198.tp1corr3=2 
        and fst198.tp1nro1=ln_activi;
       exception
            when others then 
            ln_agropecuario := 0;
    end ;

----------Pecuario---------------
----------Agricola---------------
  begin 
      select count(*) into ln_agropecuario
      from fst198 
      where fst198.tp1cod=1 and fst198.tp1cod1=11109 
      and fst198.tp1corr1=10 and fst198.tp1corr3=1 
      and fst198.tp1nro1=ln_activi;
     exception
          when others then 
          ln_agropecuario := 0;
  end ;
----------Agricola---------------
--   return ln_activi;
    if ln_agropecuario>0 then 
        respuesta_a:=1;
    else
        respuesta_a:=0;
    end if;
    if ln_pecuario>0 then 
        respuesta_p:=1;
    else
        respuesta_p:=0;
    end if;
else
  respuesta_a:=0;
  respuesta_p:=0;
end if;


end sp_cr_codactvprecagri;


---------------------------------------------------------------------------------------
end pq_cr_resolutor_observacion;
/

