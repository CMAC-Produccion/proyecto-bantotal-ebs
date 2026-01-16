create or replace package PQ_CR_RESOLUTOR_SPASIVAS is

  -- Author  : SMARQUEZ
  -- Created : 17/03/2025 16:59:10
  -- Purpose : VARIABLES DE SEGUROS PASIVAS

  -- Public type declarations
   Procedure Sp_valida_periodo_SEGUROS(pn_ins in number,
                                       pc_FAMPRO_A  out varchar2,
                                       PN_CFAMPRO_A out number,
                                       pc_ONCOTRA_A out varchar2,
                                       pn_CONCOTRA_A out number,
                                       pc_VIDACAJA_A out varchar2,
                                       pn_CVIDACAJA_A out number,
                                       pc_ONCOINDEM_A out varchar2,
                                       pn_CONCOINDEM_A out number,
                                       pc_ASISTE_M out varchar2,
                                       pn_CASISTE_M out number,
                                       pc_FAMPRO_M  out varchar2,
                                       PN_CFAMPRO_M out number,
                                       pc_ONCOTRA_M out varchar2,
                                       pn_CONCOTRA_M out number,
                                       pc_VIDACAJA_M out varchar2,
                                       pn_CVIDACAJA_M out number,
                                       pc_ONCOINDEM_M out varchar2,
                                       pn_CONCOINDEM_M out number,
                                       pc_PERIODO_PAS out NUMBER,
                                       pn_mes out number,
                                       pn_mes2 out number
                                       );
   PROCEDURE Sp_contador_seguro(pn_ins   in number,
                                pn_cont  out number);

end PQ_CR_RESOLUTOR_SPASIVAS;
/
create or replace package body PQ_CR_RESOLUTOR_SPASIVAS is
    -- *****************************************************************
    -- Nombre                     :  VARIABLES DE SEGUROS PASIVAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 17/03/2025 16:59:10
    -- Autor de Creación          : SILVIA MARQUEZ
    -- Uso                        : Realiza cálculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Modificacion               : SMARQUEZ 20260112 adicion control 
    --                              seguro Asistencia
    --
    --
    -- *****************************************************************

  Procedure  Sp_valida_periodo_SEGUROS(pn_ins in number,
                                       pc_FAMPRO_A  out varchar2,
                                       PN_CFAMPRO_A out number,
                                       pc_ONCOTRA_A out varchar2,
                                       pn_CONCOTRA_A out number,
                                       pc_VIDACAJA_A out varchar2,
                                       pn_CVIDACAJA_A out number,
                                       pc_ONCOINDEM_A out varchar2,
                                       pn_CONCOINDEM_A out number,
                                       pc_ASISTE_M out varchar2,
                                       pn_CASISTE_M out number,
                                       pc_FAMPRO_M  out varchar2,
                                       PN_CFAMPRO_M out number,
                                       pc_ONCOTRA_M out varchar2,
                                       pn_CONCOTRA_M out number,
                                       pc_VIDACAJA_M out varchar2,
                                       pn_CVIDACAJA_M out number,
                                       pc_ONCOINDEM_M out varchar2,
                                       pn_CONCOINDEM_M out number,
                                       pc_PERIODO_PAS out NUMBER,
                                       pn_mes out number,
                                       pn_mes2 out number
                                       )is

  CURSOR SEGPAS_ANUALES IS
   select *
      from jaqm65 b , jaqm66 a
     where b.jaqm65tad > 2--- pn_tipo ---1 Agricola, 2 desemplero
       and b.jaqm65ins = pn_ins
       and a.jaqm66ins = b.jaqm65ins
       and a.jaqm66est <>'E';

   CURSOR SEGPAS_MES(CTA IN NUMBER, OPER IN NUMBER) IS
    select * from FPP001 WHERE PGCOD = 1 AND AOCTA = CTA AND AOOPER = OPER
    AND SGCOD IN (select sgcod from FST300 where sgcod between 120 and 129
                   union
                  select sgcod from FST300 where sgcod between 511 and 590);
   cuenta  number:=0;
   operacion number:=0;
   fvalor date;
   fcuotauno date;
   nrocuotas number:=0;
   periodo1 number:=0;
   fecha date;
   nro_dias number:=0;
   nro_meses1 number:=0;
   nro_meses2 number:=0;
   nro_meses3 number:=0;
   meses number:=0;
   nro_dias1 number:=0;
   nro_meses11 number:=0;
   nro_meses12 number:=0;
   nro_meses13 number:=0;
   meses1 number:=0;
bEGIN
    pc_FAMPRO_A  :='N';
    PN_CFAMPRO_A := 0;
    pc_ONCOTRA_A :='N';
    pn_CONCOTRA_A := 0;
    pc_VIDACAJA_A :='N';
    pn_CVIDACAJA_A := 0;
    pc_ONCOINDEM_A :='N';
    pn_CONCOINDEM_A := 0;

    pc_ASISTE_M :='N';
    pn_CASISTE_M := 0;
    pc_FAMPRO_M  :='N';
    PN_CFAMPRO_M  := 0;
    pc_ONCOTRA_M :='N';
    pn_CONCOTRA_M  := 0;
    pc_VIDACAJA_M :='N';
    pn_CVIDACAJA_M  := 0;
    pc_ONCOINDEM_M :='N';
    pn_CONCOINDEM_M  := 0;
    meses := 0;
    meses1 := 0;
    for reg in  SEGPAS_ANUALES loop
      if reg.JAQM65TAD = 3 then
        pc_VIDACAJA_A := 'S';
        pn_CVIDACAJA_A := reg.JAQM65COD;
      elsif reg.JAQM65TAD = 4 then
        pc_ONCOINDEM_A :='S';
        pn_CONCOINDEM_A := reg.JAQM65COD;
      elsif reg.JAQM65TAD = 5 then
        pc_FAMPRO_A  :='S';
        PN_CFAMPRO_A := reg.JAQM65COD;
      elsif reg.JAQM65TAD = 6 then
        pc_ONCOTRA_A :='S';
        pn_CONCOTRA_A := reg.JAQM65COD;
      end if;
    end loop;
    cuenta := 0;
    operacion := 0;
    begin
      select xwfcuenta,xwfoperacion
        into cuenta  , operacion
        from xwf700 where xwfprcins = pn_ins and xwfcar3 ='1';
    exception
      when no_data_found then
        cuenta := 0;
        operacion := 0;
    end;
    for r1 in  SEGPAS_MES(cuenta,operacion) LOOP
      if r1.sgcod >=120 and r1.sgcod <=129 then
         pc_VIDACAJA_M :='S';
         pn_CVIDACAJA_M  := r1.sgcod;
      elsif r1.sgcod >=511 and r1.sgcod <=515 then
         pc_ONCOINDEM_M :='S';
         pn_CONCOINDEM_M  := r1.sgcod;
      elsif r1.sgcod >=521 and r1.sgcod <=535 then
         pc_FAMPRO_M  :='S';
         PN_CFAMPRO_M  := r1.sgcod;
      elsif r1.sgcod >=541 and r1.sgcod <=555 then
         pc_ONCOTRA_M :='S';
         pn_CONCOTRA_M  := r1.sgcod;
      elsif r1.sgcod >=556 and r1.sgcod <=590 then
          pc_ASISTE_M :='S';
          pn_CASISTE_M := r1.sgcod;

      end if;
    end loop;

    begin -- PERIODO
       select b.jaqm65per
        into pc_periodo_PAS
        from jaqm65 b , jaqm66 a
       where b.jaqm65tad > 2--- pn_tipo ---1 Agricola, 2 desemplero
         and b.jaqm65ins = pn_ins
         and a.jaqm66ins = b.jaqm65ins
         and a.jaqm66est <>'E';
    exception
      when no_data_found then
        pc_periodo_PAS := 0;
      when others then
        select b.jaqm65per
        into pc_periodo_PAS
        from jaqm65 b , jaqm66 a
       where b.jaqm65tad > 2 ---= pn_tipo ---1 Agricola, 2 desemplero
         and b.jaqm65ins = pn_ins
         and a.jaqm66ins = b.jaqm65ins
         and a.jaqm66est <>'E'
         and rownum = 1;
    end;

   ------------------------mes 1---------------------------------------
     Begin
       select a.xllfvalor, a.xllfprimpa, a.xllcantcuo, a.xllperiodo,b.xwffec1
         into fvalor, fcuotauno, nrocuotas, periodo1,fecha
         from x054023 a,xwf700 b
        where b.xwfprcins = pn_ins
          and b.xwfcar3 = '1'
          and a.xllpgcod = 1
          and a.xllaomod = b.xwfmodulo
          and a.xllaosuc = b.xwfsucursal
          and a.xllaomda = b.xwfmoneda
          and a.xllaopap = b.xwfpapel
          and a.xllaocta = b.xwfcuenta
          and a.xllaooper = b.xwfoperacion
          and a.xllaosbop = b.xwfsubope
          and a.xllaotop = b.xwftipope ;
      BEgin
         select fecha - fvalor,
                trunc((fecha - fvalor) / 31),
                trunc((fcuotauno - fvalor) / 31),
                trunc((fecha - fcuotauno) / 31)
           into nro_dias, nro_meses1, nro_meses2, nro_meses3
           from dual;
       if (nro_dias /31) > trunc((nro_dias /31)) then
         meses := trunc((nro_dias /31)) + 1;
       else
          meses := trunc((nro_dias /31));
       end if;

       pn_mes :=  meses;--round(nro_dias /31);---(nro_meses2+ nro_meses3);

  --     if nro_meses1 = (nro_meses2+ nro_meses3) then
  --       pc_flag:= 'S';
  --     ----  pc_periodo := (nro_meses2+ nro_meses3);
  --     else
  --       pc_flag := 'N';
  --     end if;
      exception
        when no_data_found then
         pn_mes := 0;
     end;
   exception
     when no_data_found then
       null;
   end;
   ---------------- mes 2------------------------
   BEgin
         select fecha - fvalor,
                trunc((fecha - fvalor) / 30.6),
                trunc((fcuotauno - fvalor) / 30.6),
                trunc((fecha - fcuotauno) / 30.6)
           into nro_dias1, nro_meses11, nro_meses12, nro_meses13
           from dual;
         if (nro_dias1 /30.6) > trunc((nro_dias1 /30.6)) then
           meses1 := trunc((nro_dias1 /30.6)) + 1;
         else
            meses1 := trunc((nro_dias1 /30.6));
         end if;

         pn_mes2 :=  meses1;--round(nro_dias /31);---(nro_meses2+ nro_meses3);

--         if nro_meses1 = (nro_meses2+ nro_meses3) then
--           pc_flag:= 'S';
--         ----  pc_periodo := (nro_meses2+ nro_meses3);
---         else
--           pc_flag := 'N';
--         end if;
        exception
          when no_data_found then
            pn_mes2:= 0;
       end;


  end Sp_valida_periodo_SEGUROS;

  PROCEDURE Sp_contador_seguro(pn_ins   in number,
                               pn_cont  out number) is
  pn_contador number:=0;
  pn_contador1 number:=0;
  pn_contador2 number:=0;
  pn_contadorDos number:=0;
  pc_flgVC char(1) := 'N';
  lc_seg char(25):= '%ASISTENCIA%';
  pn_pais number:=0;
  pn_tdoc number:=0;
  pc_ndoc char(12);
--  instancia number;
  begin
    --instancia:= pn_ins;

       select count(*)
       into pn_contador
       from fpp001 gg,
            xwf700 xx,
            wfwrkitems  ww
      where gg.pgcod = 1
        and gg.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50)
        and gg.aocta in (SELECT NVL (B1.CTNRO, B1.CTNRO)---15022017
                           from SNG001 A,
                                FSR008 B1
                          WHERE A.SNG001PAIS = B1.PEPAIS
                            AND A.SNG001TDOC = B1.PETDOC
                            AND A.SNG001NDOC = B1.PENDOC
                            AND A.SNG001INST = pn_ins) --pn_inst )
        and gg.sgcod  in (select SGCOD
                            from fst300
                           Where SGCOD BETWEEN 556 AND 635)
         and xx.xwfempresa = gg.pgcod
         and xx.xwfsucursal = gg.aosuc
         and xx.xwfmodulo = gg.aomod
         and xx.XWFMONEDA = gg.aomda
         and xx.Xwfpapel  = gg.aopap
         and xx.XWFCUENTA  = gg.aocta
         and xx.XWFOPERACION = gg.aooper
         and xx.XWFSUBOPE = gg.aosbop
         and xx.XWFTIPOPE = gg.aotope
         and xx.XWFPRCINS <>  pn_ins ---pn_inst
         and xx.xwfcar3 = '1' --14/10/2021 sma
         and ww.wfinsprcid = xx.xwfprcins
         and ww.wfitemstsact = 1;

        select count(*)
          into pn_contador1
          from xwf700 a ,
               fpp001 b,
               sng001 c
         where c.sng001inst = pn_ins --pn_inst
           and c.sng001ori not in (4,3,13)
           and a.xwfprcins = c.sng001inst
      ---   where a.xwfprcins =
           and a.xwfcar3='1'
           and b.pgcod = a.xwfempresa
           and b.aomod = a.xwfmodulo
           and b.aosuc = a.xwfsucursal
           and b.aomda = a.xwfmoneda
           and b.aopap = a.xwfpapel
           and b.aocta = a.xwfcuenta
           and b.aooper = a.xwfoperacion
           and b.aosbop = a.xwfsubope
           and b.aotope = a.xwftipope
           and b.sgcod in (select SGCOD
                            from fst300
                           Where SGCOD BETWEEN 556 AND 560);
       /**********************************************************/
       select count(*)
          into pn_contadorDos
          from xwf700 a ,
               fpp001 b,
               sng001 c
         where c.sng001inst = pn_ins --pn_inst
           and c.sng001ori in (4,3,13)
           and a.xwfprcins = c.sng001inst
      ---   where a.xwfprcins =
           and a.xwfcar3='1'
           and b.pgcod = a.xwfempresa
           and b.aomod = a.xwfmodulo
           and b.aosuc = a.xwfsucursal
           and b.aomda = a.xwfmoneda
           and b.aopap = a.xwfpapel
           and b.aocta = a.xwfcuenta
           and b.aooper = a.xwfoperacion
           and b.aosbop = a.xwfsubope
           and b.aotope = a.xwftipope
           and b.sgcod in (select SGCOD
                            from fst300
                           Where SGCOD BETWEEN 556 AND 560);
           if  pn_contadorDos <> 0 then
             pn_contadorDos := pn_contadorDos -1;
           else
             pn_contadorDos := 0;
           end if;


     begin
       select sng001pais, sng001tdoc, sng001ndoc
         into pn_pais,pn_tdoc,pc_ndoc
       from sng001  where sng001inst = pn_ins; --pn_inst;
     exception
       when no_data_found then
         pn_pais := 0;
     end;
     if pn_pais <> 0 then
       Begin
          pQ_CR_CREDITOS_ALERTAS.SP_CR_TIENE_SEGURO(pn_pais,pn_tdoc,pc_ndoc,lc_seg,pc_flgVC);
       end;
       if pc_flgVC ='S' then
         pn_contador2 := 1;
       end if ;

     end if;
--        and rownum<=1;
     if pn_contador is null then
       pn_contador :=0;
     end if;
      if pn_contador1 is null then
       pn_contador1 :=0;
     end if;
      if pn_contador2 is null then
       pn_contador2 :=0;
     end if;
        pn_cont := pn_contador + pn_contador1 + pn_contador2 + pn_contadorDos;

     exception
     when others then
       pn_cont := 0;
   end  Sp_contador_seguro;
end PQ_CR_RESOLUTOR_SPASIVAS;
/
