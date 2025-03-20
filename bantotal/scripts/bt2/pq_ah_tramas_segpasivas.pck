create or replace package PQ_AH_TRAMAS_SEGPASIVAS is
  -- ***********************************************************************
  -- Author  : SMARQUEZ
  -- Created : 23/05/2024 09:43:52
  -- Purpose : TRAMAS ONCOAUNA
  -- Acceso  :
  --***********************************************************************
  procedure SP_AH_TRAMA_ONCOAUNA(P_FECHA IN DATE);
  procedure SP_AH_COBROS_ONCOAUNA(P_FECHA IN DATE);
  
end PQ_AH_TRAMAS_SEGPASIVAS;
/

create or replace package body PQ_AH_TRAMAS_SEGPASIVAS is

  procedure SP_AH_TRAMA_ONCOAUNA(P_FECHA IN DATE) is
   -- *****************************************************************
  -- Nombre                     : SP_AH_TRAMA_ONCOAUNA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : AHORROS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 21/05/2024
  -- Autor de Creación          : SILVIA MARQUEZ
  -- Uso                        : TRMAS ONCOLOGICAS TEMPORALES
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : FECHA
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************

  cursor data (fecha1 in date, fecha2 in date) is
   select *
     from jaql099
    where JAQL99FEPR between fecha1 and fecha2
      and codproductocobro99 ='0056'
      and NUMCUOTACOBRO99 = '0000'
      and CODERROR99 = '00';



 cursor correo (pais number,tdoc number,ndoc char) is
        select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
          from fsx001
         where pepais = pais
           and petdoc = tdoc
           and pendoc = ndoc
           and txcod = 0 --x_08.txcod = 0
           and pextxt <> 'SI'
           and pextxt Like '%@%'
           and rownum = 1;
 fechauno date;
 fechados date;
 cuenta   number;
 pais     number;
 tdoc     number;
 ndoc     char(12);
 tele     char(10);
 ln_cont1 number;
 mail     char(50);
 cont     number:= 0;
 corre    char(2);
 MONTO    NUMBER(17,2);
 MONTO1   NUMBER;
 PROGRAMA CHAR(10);
 prima    char(8);
begin
   Execute immediate ('truncate table aqpa565');
  fechauno := trunc(p_fecha,'MM');
  fechados  := last_day(p_fecha);
  For a in data(fechauno, fechados) loop
    MONTO := 0;
    MONTO1 := 0;
    cuenta := substr(a.numcta99,1,16);
    cont := cont + 1;
    corre :=  lpad(cont,2,'0');
    MONTO := A.MONTOPRIMACUOTA99/100;
    MONTO1 := A.MONTOPRIMACUOTA99;
    Begin
      select LPAD(TP1NRO3,8,'0')
        INTO PRIMA
        from fsT198      
       where tp1cod = 1
         and tp1cod1 =10884
         and tp1corr1 = 78
         AND TP1NRO1 = MONTO1;
    exception
      WHEN NO_DATA_FOUND THEN
        PRIMA:= '00000000';
    end;
    
    
    IF MONTO < 100 THEN
     PROGRAMA := '107010201 '; ---plan mensual
    /* if monto = 10.78 then 
       prima := '00000502';
     elsif monto = 16.83 then
       prima := '00000785';
     elsif monto = 19.27 then
       prima:= '00000898';
     end if;*/
    ELSE
     PROGRAMA := '107010101 ';
    /* if monto = 122.79 then
       prima := '00005724';
     elsif monto = 191.81 then
       prima := '00008940';
     elsif monto = 219.42 then
       prima:= '00010236';
     end if;*/
    END IF; 
    
    Begin
      select pepais, petdoc ,pendoc
        into pais, tdoc,ndoc
      from fsd001 where pendoc = a.idtitularcta99;
    exception
      when no_data_found then
      pais := 0;
      tdoc := 0;
    end;
     BEgin
       select trim(dotelfp)
         into tele
          from fsr005
         where pepais = pais
           and petdoc = tdoc
           and pendoc = ndoc
           and docod = 1
           and doordp = 2;
     exception
       when no_data_found then
         BEGIN
          select trim(dotelfp)
           into tele
            from fsr005
           where pepais = pais
             and petdoc = tdoc
             and pendoc = ndoc
             and docod = 2
             and doordp = 99;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
              BEgin
                 select trim(dotelfp)
                   into tele
                    from fsr005
                   where pepais = pais
                     and petdoc = tdoc
                     and pendoc = ndoc
                     and docod = 1
                     and doordp = 1;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  TELE:='999999998';
              END;
         END;
     end;
     
     mail := null;
     
     For c in correo(pais,tdoc,ndoc)loop
        if ln_cont1 = 0 then
          mail := trim(c.mail);
        else
      --    if  (length(c.mail) + length(mail)) <= 50 then
             mail := substr((trim(mail)||' '||trim(c.mail)),1,50);
       --   end if;
        end if;
       ln_cont1 := ln_cont1 + 1;
    end loop;
    
    mail := trim(mail);
    
    Begin
      insert into aqpa565(aqpa565cod,
                  aqpa565cta,
                  aqpa565dni,
                  aqpa565fec,
                  aqpa565nro,
                  aqpa565emp,
                  aqpa565pro,
                  aqpa565cert,
                  aqpa565app,
                  aqpa565apm,
                  aqpa565nom1,
                  aqpa565nom2,
                  aqpa565sexo,
                  aqpa565fnac,
                  aqpa565tdoc,
                  aqpa565ndoc,
                  aqpa565ccua,
                  aqpa565cat,
                  aqpa565fven,
                  aqpa565fafi,
                  aqpa565prg,
                  aqpa565edad,
                  aqpa565fuma,
                  aqpa565mto,
                  aqpa565dir,
                  aqpa565ugeo,
                  aqpa565cpos,
                  aqpa565tel,
                  aqpa565cel,
                  aqpa565corr,
                  aqpa565tdv,
                  aqpa565ape1c,
                  aqpa565ape2c,
                  aqpa565nom1c,
                  aqpa565nom2c,
                  aqpa565sexc,
                  aqpa565fnacc,
                  aqpa565tdocc,
                  aqpa565ndocc,
                  aqpa565rzonc,
                  aqpa565ruc,
                  aqpa565direcc,
                  aqpa565ugeoc,
                  aqpa565copc,
                  aqpa565telc,
                  aqpa565celc,
                  aqpa565corrc,
                  aqpa565eetar,
                  aqpa565epro,
                  aqpa565tpro,
                  aqpa565ntar,
                  aqpa565fvtar,
                  aqpa565titar,
                  aqpa565cven,
                  aqpa565csup,
                  aqpa565agen,
                  aqpa565ven )
      select  1,
             to_number(substr(a.numcta99,1,16)),
             f.pfndoc,
             trunc(sysdate),
             1,
             '343',--codigo empresa aqui empieza
             PROGRAMA,--'107010201',-- producto procedencia 107--010201 mensual
             'C'||a.numcertificadocobro99,
             f.pfape1,
             f.pfape2,
             f.pfnom1,
             nvl(f.pfnom2,'                                                  '),
             f.pfcant, --sxo
             to_char(f.pffnac,'yyyymmdd'),
             decode(f.pftdoc, 21,'01',2,'03',5,'04','05'),
             f.pfndoc,
             'C'||a.numcertificadocobro99||corre,--CUA
             '01',
             to_char(a.JAQL99FEPR,'yyyymmdd'), --fecha venta cambiar por JAQL99FEPR
             to_char(a.JAQL99FEPR,'yyyymmdd'), --fecha afiliacion cambiar por JAQL99FEPR
             '57',
             trunc(months_between(sysdate,f.pffnac)/12,0),
             '0',
              prima,---lpad(a.MONTOPRIMACUOTA99,8,'0'), --aqui hay cambiar por el monto/*
              (select SNGC13DIR from sngc13 where sngc13pais = f.pfpais and sngc13tdoc = f.pftdoc and sngc13ndoc =f.pfndoc and sngc13est ='H' and docod = 1),
              (select sngc13ugeo  from sngc13 where sngc13pais = f.pfpais and sngc13tdoc = f.pftdoc and sngc13ndoc =f.pfndoc and sngc13est ='H' and docod = 1),
              '04011',
              tele,
              tele,
              mail,
              '01', --boleta duracel DATOS CONRATANTE
              f.pfape1,
              f.pfape2,
              f.pfnom1,
              nvl(f.pfnom2,'                                                  '),
              f.pfcant, --sxo
              to_char(f.pffnac,'yyyymmdd'),
              decode(f.pftdoc, 21,'01',2,'03',5,'04','05'),
              f.pfndoc,
              '                                                                                                                  ',
              '      ',
              (select SNGC13DIR from sngc13 where sngc13pais = f.pfpais and sngc13tdoc = f.pftdoc and sngc13ndoc =f.pfndoc and sngc13est ='H' and docod = 1),
              (select sngc13ugeo  from sngc13 where sngc13pais = f.pfpais and sngc13tdoc = f.pftdoc and sngc13ndoc =f.pfndoc and sngc13est ='H' and docod = 1),
              '04011',
              tele,
              tele,
              mail,
              '09',
              '37',
              '002',
              ' ',
              ' ',
              substr((trim(f.pfape1)||' '||trim(f.pfape2)||' '||trim(f.pfnom1)||' '||trim(f.pfnom2)),1,150),
              '',
              '',
              ' ',
              'ven'
        from fsd002 f
       where f.pfndoc = a.idtitularcta99;
       commit;
    exception
      when dup_val_on_index then
        null;
    end;

  end loop;

  end SP_AH_TRAMA_ONCOAUNA;
  ---*****************************************************************************  
  procedure SP_AH_COBROS_ONCOAUNA(P_FECHA IN DATE) IS
    cursor data (fecha1 in date, fecha2 in date) is
     select *
       from jaql099
      where JAQL99FEPR between fecha1 and fecha2
        and codproductocobro99 ='0056'
      --  and NUMCUOTACOBRO99 <> '0001'
        and CODERROR99 = '00';

 
   fechauno date;
   fechados date;
   cuenta   number;
   pais     number;
   tdoc     number;
   ndoc     char(12);
   tele     char(10);
   ln_cont1 number;
   mail     char(50);
   cont     number:= 0;
   corre    char(2);
   nrocuota number:=0;
   ope      char(3);
   monto    number(17,2);
   MONTO1   NUMBER;
   prima    char(8);
   programa char(10);
   
  begin
     Execute immediate ('truncate table aqpa569');
    fechauno := trunc(p_fecha,'MM');
    fechados  := last_day(p_fecha);
    For a in data(fechauno, fechados) loop
      cuenta := substr(a.numcta99,1,16);
      cont := cont + 1;
      corre :=  lpad(cont,2,'0');
      nrocuota := a.numcuotacobro99;
      MONTO := A.MONTOPRIMACUOTA99/100;
      MONTO1 := A.MONTOPRIMACUOTA99;
      Begin
        select LPAD(TP1NRO3,8,'0')
          INTO PRIMA
          from fsT198      
         where tp1cod = 1
           and tp1cod1 =10884
           and tp1corr1 = 78
           AND TP1NRO1 = MONTO1;
      exception
        WHEN NO_DATA_FOUND THEN
          PRIMA:= '00000000';
      end;
      
      IF MONTO < 100 THEN
       PROGRAMA := '107010201 '; ---plan mensual
     /*  if monto = 10.78 then 
         prima := '00000502';
       elsif monto = 16.83 then
         prima := '00000785';
       elsif monto = 19.27 then
         prima:= '00000898';
       end if;*/
      ELSE
       PROGRAMA := '107010101 ';
/*       if monto = 122.79 then
         prima := '00005724';
       elsif monto = 191.81 then
         prima := '00008940';
       elsif monto = 219.42 then
         prima:= '00010236';
       end if;*/
      END IF; 
      if nrocuota = 0 then
        ope:= 'AFI';
      else
        ope:= 'REN';
      end if;
      Begin
        select pepais, petdoc ,pendoc
          into pais, tdoc,ndoc
        from fsd001 where pendoc = a.idtitularcta99;
      exception
        when no_data_found then
        pais := 0;
        tdoc := 0;
      end;
       BEgin
         select trim(dotelfp)
           into tele
            from fsr005
           where pepais = pais
             and petdoc = tdoc
             and pendoc = ndoc
             and docod = 1
             and doordp = 2;
       exception
         when no_data_found then
           BEGIN
            select trim(dotelfp)
             into tele
              from fsr005
             where pepais = pais
               and petdoc = tdoc
               and pendoc = ndoc
               and docod = 2
               and doordp = 99;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
                BEgin
                   select trim(dotelfp)
                     into tele
                      from fsr005
                     where pepais = pais
                       and petdoc = tdoc
                       and pendoc = ndoc
                       and docod = 1
                       and doordp = 1;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    TELE:='999999998';
                END;
           END;
       end;

      Begin
        insert into aqpa569(aqpa569cod,
                            aqpa569cta,
                            aqpa569dni,
                            aqpa569fpro,
                            aqpa569emp,
                            aqpa569pro,
                            aqpa569cert,
                            aqpa569cua,
                            aqpa569fnac,
                            aqpa569pgm,
                            aqpa569edad,
                            aqpa569fum,
                            aqpa569fcar,
                            aqpa569mto,
                            aqpa569per,
                            aqpa569ope,
                            aqpa569epro,
                            aqpa569fec,
                            aqpa569ncuo)
        select  1,
               to_number(substr(a.numcta99,1,16)),
               f.pfndoc,
               trunc(sysdate),            
               '343',--codigo empresa aqui empieza
               programa,---'107010201',-- producto procedencia 107--010201 mensual
               'C'||a.numcertificadocobro99,
               'C'||a.numcertificadocobro99||corre,              
               to_char(f.pffnac,'yyyymmdd'),
               '57',
               trunc(months_between(sysdate,f.pffnac)/12,0),
               '0',
               to_Char(a.jaql99fepr,'yyyymmdd'),
               prima, ---lpad(a.MONTOPRIMACUOTA99,8,'0'), 
               to_Char(a.jaql99fepr,'yyyymm'),
               ope,
               '37',
               to_char(a.jaql99fepr,'yyyymmdd'),
               a.numcuotacobro99
          from fsd002 f
         where f.pfndoc = a.idtitularcta99;
         commit;
      exception
        when dup_val_on_index then
          null;
      end;
    end loop;
  END SP_AH_COBROS_ONCOAUNA;
end PQ_AH_TRAMAS_SEGPASIVAS;
/

