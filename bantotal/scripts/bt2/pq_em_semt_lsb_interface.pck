create or replace package PQ_EM_SEMT_LSB_INTERFACE is

  -- Author  : YLOZADA
  -- Created : 24/06/2019 4:46:02 p. m.
  -- Purpose : 
  
  -- Public type declarations
   
  TYPE personas_refcur IS REF CURSOR;  
  TYPE cuentas_refcur  IS REF CURSOR;
  TYPE comisiones_refcur  IS REF CURSOR;  

  
  TYPE typ_rec  IS RECORD  
  (
  NOMBRE_APELLIDOS VARCHAR2(100),
  TIPO_DOCUMENTO   NUMBER(5),
  NRO_DOCUMENTO    VARCHAR2(20),
  DIRECCION        VARCHAR2(100),
  DISTRITO         VARCHAR2(50),
  EMPLEADO         NUMBER(1)
  );
  TYPE typ_dat  IS RECORD   
  ( 
  NRO_CUENTA    VARCHAR2(30),
  DESC_CUENTA   VARCHAR2(50),
  COD_PRODUCTO  NUMBER(3),
  TIP_PRODUCTO  NUMBER(3),
  TPO_PRODUCTO  VARCHAR2(5),
  MONEDA        NUMBER(5),
  SALDO         NUMBER(18,2),
  DESEMBOLSO    NUMBER(18,2),
  FCH_APERTURA  VARCHAR2(10),
  FCH_CIERRE    VARCHAR2(10),
  COD_ESTADO    VARCHAR2(5),
  DESC_ESTADO   VARCHAR2(30) 
  );
  TYPE typ_com  IS RECORD  
  (
  CODIGO          VARCHAR2(30),
  MONEDA          NUMBER(4),
  MTO_COMISION    NUMBER(10,2)
  );  

  TYPE typ_semt  IS RECORD  
  (
  CUENTA_NUMERO     Varchar2(30),
  NOM_CUENTA        Varchar2(50),
  MODULO            Number(3),
  DESC_MODULO       Varchar2(50),
  TIPO_OPERACION    Number(3),
  NRO_OPERACION     Number(10),
  NRO_SUBOPERACION  Number(5),
  TIPO_CUENTA       Varchar2(30),
  NRO_INTEG         Number(2),
  FLAG_GARANTIA     Varchar2(5),
  MONEDA            Number(4),
  SALDO_DISPONIBLE  Number(20,2),
  SALDO_CONTABLE    Number(20,2),
  COD_ESTADO        Varchar2(5),
  DESC_ESTADO       Varchar2(30)
  );  
  
  -- Public function and procedure declarations
  Procedure PRC_BUSCAR_CLIENTE(wFLAG               in  Number,
                               wTIPO_DOCUMENTO     in  Number,
                               wNUMERO_DOCUMENTO   in  Varchar2,
                               wPROCESADO          in  varchar2,
                               wFLAG_PROC          out number,
                               wMSG_PROC           out varchar2,
                               wCLI_REF_CURSOR     out personas_refcur
                              );
  Procedure PRC_LSB_CUENTAS(wTIPO_DOCUMENTO   in  number,
                            wNUMERO_DOCUMENTO in  varchar2,
                            wFLAG_SALDO       in  number,                    
                            wFLAG_PROC        out Number,
                            wMSG_PROC         out varchar2,
                            wCTA_REF_CURSOR   out cuentas_refcur 
                           );     
  Procedure PRC_SEMT_CUENTAS(wTIPO_DOCUMENTO   in  number,
                             wNUMERO_DOCUMENTO in  varchar2,
                             wFLAG_VMCT        out Number,
                             wANALISTA_CREDITO out varchar2,
                             wFLAG_PROC        out Number,
                             wMSG_PROC         out varchar2,
                             wCTA_REF_CURSOR   out cuentas_refcur
                            );       
  Procedure PRC_TIPO_CAMBIO(TIPO_CAMBIO       out Number,
                            wFLAG_PROC        out Number,
                            wMSG_PROC         out varchar2
                           );                                                                        
  Procedure PRC_ITF(PORC_ITF       out Number,
                    wFLAG_PROC     out Number,
                    wMSG_PROC      out varchar2
                   );
  Procedure PRC_COMISIONES(wFLAG_PROC        out Number,
                           wMSG_PROC         out varchar2,
                           wCOMI_REF_CURSOR  out comisiones_refcur
                          );                   
end PQ_EM_SEMT_LSB_INTERFACE;
/

create or replace package body PQ_EM_SEMT_LSB_INTERFACE is

  Procedure PRC_BUSCAR_CLIENTE(wFLAG               in  Number,
                               wTIPO_DOCUMENTO     in  Number,
                               wNUMERO_DOCUMENTO   in  Varchar2,
                               wPROCESADO          in  varchar2,
                               wFLAG_PROC          out number,
                               wMSG_PROC           out varchar2,
                               wCLI_REF_CURSOR     out personas_refcur
                              ) is
  lc_tipo char(1);
  ln_existe number(1):= 0;    
  lc_cadena varchar2(100);    
  v_rec     typ_rec;     
  begin
    wMSG_PROC := null;
    if wFLAG = 1 then
      begin
      Select 1
        into ln_existe
        from FSR008 a
       where a.pgcod = 1
         and a.pepais = 604
         and a.petdoc = wTIPO_DOCUMENTO
         and a.pendoc = rpad(wNUMERO_DOCUMENTO, 12, ' ')
         and rownum < 2;
         wFLAG_PROC := ln_existe;
      exception 
      when no_data_found then
        wFLAG_PROC := 2;
      when others then 
        wFLAG_PROC := 0;   
        wMSG_PROC  := substr(sqlerrm,1,200);
      end;          
              
       if ln_existe = 1 then
         --verificamos si es PJ O PN
         begin
           Select x.petipo
             into lc_tipo 
             from fsd001 x 
            where x.pepais = 604
              and x.petdoc = wTIPO_DOCUMENTO
              and x.pendoc = rpad(wNUMERO_DOCUMENTO, 12, ' ');
         exception 
         when others then
              lc_tipo := null;
         end;
         if lc_tipo = 'F' then    
           --VERIFICAMOS SI ES EMPLEADO Y TRAEMOS SUS DATOS   
           begin
             OPEN wCLI_REF_CURSOR FOR
                 Select trim(substr(trim(y.pfape1)||' '||trim(y.pfape2)||', '||trim(y.pfnom1)||' '||trim(y.pfnom2),1,100))  NOMBRE_APELLIDOS,
                        y.pftdoc                                                                                            TIPO_DOCUMENTO,
                        trim(y.pfndoc)                                                                                      NRO_DOCUMENTO,
                        trim(substr(z.sngc13dir,1,100))                                                                     DIRECCION,
                        trim(w.fst071dsc)                                                                                   DISTRITO,
                        DECODE(nvl(trim(y.pfebco),'N'),'N',0,1)                                                             EMPLEADO
                   from fsd002 y,
                        sngc13 z,
                        fst071 w
                  where y.pfpais = z.sngc13pais                
                    and y.pftdoc = z.sngc13tdoc
                    and y.pfndoc = z.sngc13ndoc
                    and z.sngc13pais = w.fst071pai
                    and z.sngc13dpto = w.fst071dpt(+)
                    and z.sngc13prov = w.fst071loc(+)
                    and z.sngc13dist = w.fst071col(+)
                    and z.docod = 1
                    and z.sngc13est = 'H'
                    and y.pfpais = 604
                    and y.pftdoc = wTIPO_DOCUMENTO
                    and y.pfndoc = rpad(wNUMERO_DOCUMENTO, 12, ' '); 
             LOOP       
             FETCH wCLI_REF_CURSOR INTO  v_rec;
                   if wCLI_REF_CURSOR%NOTFOUND then
                      wFLAG_PROC := 2;
                   Else               
                      wFLAG_PROC := 1;       
                   End If;             
                   EXIT;
             END LOOP;
             CLOSE wCLI_REF_CURSOR;    
                             
             OPEN wCLI_REF_CURSOR FOR
                 Select trim(substr(trim(y.pfape1)||' '||trim(y.pfape2)||', '||trim(y.pfnom1)||' '||trim(y.pfnom2),1,100))  NOMBRE_APELLIDOS,
                        y.pftdoc                                                                                            TIPO_DOCUMENTO,
                        trim(y.pfndoc)                                                                                      NRO_DOCUMENTO,
                        trim(substr(z.sngc13dir,1,100))                                                                     DIRECCION,
                        trim(w.fst071dsc)                                                                                   DISTRITO,
                        DECODE(nvl(trim(y.pfebco),'N'),'N',0,1)                                                             EMPLEADO
                   from fsd002 y,
                        sngc13 z,
                        fst071 w
                  where y.pfpais = z.sngc13pais                
                    and y.pftdoc = z.sngc13tdoc
                    and y.pfndoc = z.sngc13ndoc
                    and z.sngc13pais = w.fst071pai
                    and z.sngc13dpto = w.fst071dpt(+)
                    and z.sngc13prov = w.fst071loc(+)
                    and z.sngc13dist = w.fst071col(+)
                    and z.docod = 1
                    and z.sngc13est = 'H'
                    and y.pfpais = 604
                    and y.pftdoc = wTIPO_DOCUMENTO
                    and y.pfndoc = rpad(wNUMERO_DOCUMENTO, 12, ' ');              
           exception 
           when others then
             wFLAG_PROC := 0;
             wMSG_PROC  := substr(sqlerrm,1,200);
           end;
         end If;
         if lc_tipo = 'J' then                
           begin     
             OPEN wCLI_REF_CURSOR FOR
                 Select trim(substr(trim(y.pjrazs),1,100))  NOMBRE_APELLIDOS,                                                                 
                        y.pjtdoc                            TIPO_DOCUMENTO,                                                                 
                        trim(y.pjndoc)                      NRO_DOCUMENTO,                                                                 
                        trim(substr(z.sngc13dir,1,100))     DIRECCION,                                                                 
                        trim(w.fst071dsc)                   DISTRITO,                                                                 
                        0                                   EMPLEADO                                                                 
                   from fsd003 y,
                        sngc13 z,
                        fst071 w
                  where y.pjpais = z.sngc13pais                
                    and y.pjtdoc = z.sngc13tdoc
                    and y.pjndoc = z.sngc13ndoc
                    and z.sngc13pais = w.fst071pai
                    and z.sngc13dpto = w.fst071dpt(+)
                    and z.sngc13prov = w.fst071loc(+)
                    and z.sngc13dist = w.fst071col(+)
                    and z.docod = 1
                    and z.sngc13est = 'H'
                    and y.pjpais = 604
                    and y.pjtdoc = wTIPO_DOCUMENTO
                    and y.pjndoc = rpad(wNUMERO_DOCUMENTO, 12, ' ');  
             LOOP       
             FETCH wCLI_REF_CURSOR INTO  v_rec;
                   if wCLI_REF_CURSOR%NOTFOUND then
                      wFLAG_PROC := 2;
                   Else               
                      wFLAG_PROC := 1;       
                   End If;             
                   EXIT;
             END LOOP;
             CLOSE wCLI_REF_CURSOR;    
             
             OPEN wCLI_REF_CURSOR FOR
                 Select trim(substr(trim(y.pjrazs),1,100))  NOMBRE_APELLIDOS,                                                                 
                        y.pjtdoc                            TIPO_DOCUMENTO,                                                                 
                        trim(y.pjndoc)                      NRO_DOCUMENTO,                                                                 
                        trim(substr(z.sngc13dir,1,100))     DIRECCION,                                                                 
                        trim(w.fst071dsc)                   DISTRITO,                                                                 
                        0                                   EMPLEADO                                                                 
                   from fsd003 y,
                        sngc13 z,
                        fst071 w
                  where y.pjpais = z.sngc13pais                
                    and y.pjtdoc = z.sngc13tdoc
                    and y.pjndoc = z.sngc13ndoc
                    and z.sngc13pais = w.fst071pai
                    and z.sngc13dpto = w.fst071dpt(+)
                    and z.sngc13prov = w.fst071loc(+)
                    and z.sngc13dist = w.fst071col(+)
                    and z.docod = 1
                    and z.sngc13est = 'H'
                    and y.pjpais = 604
                    and y.pjtdoc = wTIPO_DOCUMENTO
                    and y.pjndoc = rpad(wNUMERO_DOCUMENTO, 12, ' ');                                                                       
           exception 
           when others then
              wFLAG_PROC := 0;
              wMSG_PROC  := substr(sqlerrm,1,200);
           end;
         end If;                  
       End If;  
    End If;
    
    if wFLAG = 2 then -- BUSQUEDA POR PATRON DE TEXTO                     
       --lc_cadena := '%'||replace(wPROCESADO,' ','%')||'%';
       lc_cadena := '%'||trim(wPROCESADO)||'%';
       begin
             OPEN wCLI_REF_CURSOR FOR
             Select trim(substr(trim(y.penom),1,100))                NOMBRE_APELLIDOS,
                    y.petdoc                                         TIPO_DOCUMENTO,
                    trim(y.pendoc)                                   NRO_DOCUMENTO,
                    trim(substr(z.sngc13dir,1,100))                  DIRECCION,
                    trim(w.fst071dsc)                                DISTRITO,
                    DECODE(nvl(trim(q.pfebco),'N'),'N',0,1)          EMPLEADO
               from fsd001 y,
                    sngc13 z,
                    fst071 w,
                    fsd002 q
              where y.pepais = z.sngc13pais                
                and y.petdoc = z.sngc13tdoc
                and y.pendoc = z.sngc13ndoc
                and z.sngc13pais = q.pfpais(+)
                and z.sngc13tdoc = q.pftdoc(+)
                and z.sngc13ndoc = q.pfndoc(+)
                and z.sngc13pais = w.fst071pai
                and z.sngc13dpto = w.fst071dpt(+)
                and z.sngc13prov = w.fst071loc(+)
                and z.sngc13dist = w.fst071col(+)
                and z.docod = 1
                and z.sngc13est = 'H'
                and y.pepais = 604
                and y.penom like lc_cadena;
             LOOP       
             FETCH wCLI_REF_CURSOR INTO  v_rec;
                   if wCLI_REF_CURSOR%NOTFOUND then
                      wFLAG_PROC := 2;
                   Else               
                      wFLAG_PROC := 1;       
                   End If;             
                   EXIT;
             END LOOP;
             CLOSE wCLI_REF_CURSOR;   
            
             OPEN wCLI_REF_CURSOR FOR
             Select trim(substr(trim(y.penom),1,100))                NOMBRE_APELLIDOS,
                    y.petdoc                                         TIPO_DOCUMENTO,
                    trim(y.pendoc)                                   NRO_DOCUMENTO,
                    trim(substr(z.sngc13dir,1,100))                  DIRECCION,
                    trim(w.fst071dsc)                                DISTRITO,
                    DECODE(nvl(trim(q.pfebco),'N'),'N',0,1)          EMPLEADO
               from fsd001 y,
                    sngc13 z,
                    fst071 w,
                    fsd002 q
              where y.pepais = z.sngc13pais                
                and y.petdoc = z.sngc13tdoc
                and y.pendoc = z.sngc13ndoc
                and z.sngc13pais = q.pfpais(+)
                and z.sngc13tdoc = q.pftdoc(+)
                and z.sngc13ndoc = q.pfndoc(+)
                and z.sngc13pais = w.fst071pai
                and z.sngc13dpto = w.fst071dpt(+)
                and z.sngc13prov = w.fst071loc(+)
                and z.sngc13dist = w.fst071col(+)
                and z.docod = 1
                and z.sngc13est = 'H'
                and y.pepais = 604
                and y.penom like lc_cadena;            
       exception 
       when others then
         wFLAG_PROC := 0;
         wMSG_PROC  := substr(sqlerrm,1,200);
       end;    
    End If;                 
  exception
  when others then  
    wFLAG_PROC := 0;
    wMSG_PROC  := substr(sqlerrm,1,200);
  end PRC_BUSCAR_CLIENTE;                              
  Procedure PRC_LSB_CUENTAS(wTIPO_DOCUMENTO   in  number,
                            wNUMERO_DOCUMENTO in  varchar2,
                            wFLAG_SALDO       in  number,                    
                            wFLAG_PROC        out Number,
                            wMSG_PROC         out varchar2,
                            wCTA_REF_CURSOR   out cuentas_refcur 
                           ) is
  ld_fecpro date; 
  v_rec     typ_dat;    
  begin
    wMSG_PROC  := null;
    Select a.pgfape into ld_fecpro from fst017 a where pgcod=1;
    
    OPEN wCTA_REF_CURSOR FOR
       Select trim(lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scsbop,2,'0')||lpad(a.sctope,3,'0')) NRO_CUENTA,
              trim(b.tonom)                                                                                                   DESC_CUENTA,
              a.scmod                                                                                                         COD_PRODUCTO,
              a.sctope                                                                                                        TIP_PRODUCTO,
              'P'                                                                                                             TPO_PRODUCTO,
              a.scmda                                                                                                         MONEDA,
              decode(wFLAG_SALDO,0,0,1,a.scsdo,0)                                                                             SALDO,
              0                                                                                                               DESEMBOLSO,
              to_char(a.scfval,'dd/mm/rrrr')                                                                                  FCH_APERTURA,
              decode(a.scstat,99,to_char(a.scfulm,'dd/mm/rrrr'),null)                                                         FCH_CIERRE,
              trim(to_char(a.scstat))                                                                                         COD_ESTADO,
              trim(c.cenom)                                                                                                   DESC_ESTADO
        from fsd011 a,
             fst004 b,
             fst026 c,
             fsr008 d
       where a.scmod  = b.modulo
         and a.sctope = b.totope
         and a.pgcod  = d.pgcod
         and a.sccta  = d.ctnro
         and d.pepais = 604
         and d.petdoc = wTIPO_DOCUMENTO
         and d.pendoc = rpad(wNUMERO_DOCUMENTO, 12, ' ')
         and a.scstat = c.cecod
         and d.ttcod = 1
         and a.pgcod = 1
         and a.scmod = 21
      union all
       Select trim(lpad(a.aocta,9,'0')||lpad(a.aomod,3,'0')||lpad(a.aomda,3,'0')||lpad(a.aooper,9,'0')||lpad(a.aotope,3,'0')) cuenta,
              trim(b.tonom),
              a.aomod,
              a.aotope,
              'P',
              a.aomda,
              decode(wFLAG_SALDO,0,0,1,
              (Select nvl(sum(x.scsdo),0) 
                 from fsd011 x where x.pgcod  = a.pgcod 
                                 and x.scsuc  = a.aosuc 
                                 and x.scmda  = a.aomda 
                                 and x.scpap  = a.aopap 
                                 and x.sccta  = a.aocta 
                                 and x.scoper = a.aooper
                                 and x.scsbop = a.aosbop
                                 and x.scmod  in (22/*,426*/)
              )
              ,0),
              0,
              to_char(a.aofval,'dd/mm/rrrr'),
              decode(a.aostat,99,to_char(a.aofe99,'dd/mm/rrrr'),null),
              trim(to_char(a.aostat)),
              trim(c.cenom)
        from fsd010 a,
             fst004 b,
             fst026 c,
             fsr008 d
       where a.aomod  = b.modulo
         and a.aotope = b.totope
         and a.pgcod  = d.pgcod
         and a.aocta  = d.ctnro
         and d.pepais = 604
         and d.petdoc = wTIPO_DOCUMENTO
         and d.pendoc = rpad(wNUMERO_DOCUMENTO, 12, ' ')         
         and a.aostat = c.cecod
         and a.pgcod = 1
         and a.aomod = 22
         and d.ttcod = 1
         and case 
             when a.aostat = 99 and a.aofe99 < a.aofval then
               0
             Else
               1
             End > 0    
      union all
       Select trim(lpad(a.aocta,9,'0')||lpad(a.aomda,3,'0')||lpad(a.aooper,9,'0')) cuenta,
              trim(b.tonom),
              a.aomod,
              a.aotope,
              'A',
              a.aomda,
              decode(wFLAG_SALDO,0,0,1,
              (Select nvl(sum(x.scsdo*(-1)),0) 
                 from fsd011 x where x.pgcod  = a.pgcod 
                                 and x.scsuc  = a.aosuc 
                                 and x.scmda  = a.aomda 
                                 and x.scpap  = a.aopap 
                                 and x.sccta  = a.aocta 
                                 and x.scoper = a.aooper
                                 and x.scsbop = a.aosbop
                                 and x.sctope = a.aotope
                                 and x.scmod  = a.aomod 
              )
              ,0),
              a.aoimp,                            
              to_char(a.aofval,'dd/mm/rrrr'),
              decode(a.aostat,99,to_char(a.aofe99,'dd/mm/rrrr'),null),
              trim(to_char(a.aostat)),
              trim(c.cenom)
        from fsd010 a,
             fst004 b,
             fst026 c,
             fsr008 d
       where a.aomod  = b.modulo
         and a.aotope = b.totope
         and a.pgcod  = d.pgcod
         and a.aocta  = d.ctnro
         and d.pepais = 604
         and d.petdoc = wTIPO_DOCUMENTO
         and d.pendoc = rpad(wNUMERO_DOCUMENTO, 12, ' ')         
         and a.aostat = c.cecod
         and a.pgcod = 1
         and d.ttcod = 1
         and a.aomod in (Select modulo from fst111 where dscod = 50);
    LOOP         
    FETCH wCTA_REF_CURSOR INTO  v_rec;
           if wCTA_REF_CURSOR%NOTFOUND then
              wFLAG_PROC := 2;
           Else               
              wFLAG_PROC := 1;       
           End If;             
           EXIT;
     END LOOP;         
         
    OPEN wCTA_REF_CURSOR FOR
       Select trim(lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scsbop,2,'0')||lpad(a.sctope,3,'0')) NRO_CUENTA,
              trim(b.tonom)                                                                                                   DESC_CUENTA,
              a.scmod                                                                                                         COD_PRODUCTO,
              a.sctope                                                                                                        TIP_PRODUCTO,
              'P'                                                                                                             TPO_PRODUCTO,
              a.scmda                                                                                                         MONEDA,
              decode(wFLAG_SALDO,0,0,1,a.scsdo,0)                                                                             SALDO,
              0                                                                                                               DESEMBOLSO,
              to_char(a.scfval,'dd/mm/rrrr')                                                                                  FCH_APERTURA,
              decode(a.scstat,99,to_char(a.scfulm,'dd/mm/rrrr'),null)                                                         FCH_CIERRE,
              trim(to_char(a.scstat))                                                                                         COD_ESTADO,
              trim(c.cenom)                                                                                                   DESC_ESTADO
        from fsd011 a,
             fst004 b,
             fst026 c,
             fsr008 d
       where a.scmod  = b.modulo
         and a.sctope = b.totope
         and a.pgcod  = d.pgcod
         and a.sccta  = d.ctnro
         and d.pepais = 604
         and d.petdoc = wTIPO_DOCUMENTO
         and d.pendoc = rpad(wNUMERO_DOCUMENTO, 12, ' ')
         and a.scstat = c.cecod
         and a.pgcod = 1
         and d.ttcod = 1
         and a.scmod = 21
      union all
       Select trim(lpad(a.aocta,9,'0')||lpad(a.aomod,3,'0')||lpad(a.aomda,3,'0')||lpad(a.aooper,9,'0')||lpad(a.aotope,3,'0')) cuenta,
              trim(b.tonom),
              a.aomod,
              a.aotope,
              'P',
              a.aomda,
              decode(wFLAG_SALDO,0,0,1,
              (Select nvl(sum(x.scsdo),0) 
                 from fsd011 x where x.pgcod  = a.pgcod 
                                 and x.scsuc  = a.aosuc 
                                 and x.scmda  = a.aomda 
                                 and x.scpap  = a.aopap 
                                 and x.sccta  = a.aocta 
                                 and x.scoper = a.aooper
                                 and x.scsbop = a.aosbop
                                 and x.scmod  in (22/*,426*/)
              )
              ,0),
              0,
              to_char(a.aofval,'dd/mm/rrrr'),
              decode(a.aostat,99,to_char(a.aofe99,'dd/mm/rrrr'),null),
              trim(to_char(a.aostat)),
              trim(c.cenom)
        from fsd010 a,
             fst004 b,
             fst026 c,
             fsr008 d
       where a.aomod  = b.modulo
         and a.aotope = b.totope
         and a.pgcod  = d.pgcod
         and a.aocta  = d.ctnro
         and d.pepais = 604
         and d.petdoc = wTIPO_DOCUMENTO
         and d.pendoc = rpad(wNUMERO_DOCUMENTO, 12, ' ')         
         and a.aostat = c.cecod
         and a.pgcod = 1
         and a.aomod = 22
         and d.ttcod = 1
         and case 
             when a.aostat = 99 and a.aofe99 < a.aofval then
               0
             Else
               1
             End > 0    
      union all
       Select trim(lpad(a.aocta,9,'0')||lpad(a.aomda,3,'0')||lpad(a.aooper,9,'0')) cuenta,
              trim(b.tonom),
              a.aomod,
              a.aotope,
              'A',
              a.aomda,
              decode(wFLAG_SALDO,0,0,1,
              (Select nvl(sum(x.scsdo*(-1)),0) 
                 from fsd011 x where x.pgcod  = a.pgcod 
                                 and x.scsuc  = a.aosuc 
                                 and x.scmda  = a.aomda 
                                 and x.scpap  = a.aopap 
                                 and x.sccta  = a.aocta 
                                 and x.scoper = a.aooper
                                 and x.scsbop = a.aosbop
                                 and x.sctope = a.aotope
                                 and x.scmod  = a.aomod 
              )
              ,0),
              a.aoimp,                            
              to_char(a.aofval,'dd/mm/rrrr'),
              decode(a.aostat,99,to_char(a.aofe99,'dd/mm/rrrr'),null),
              trim(to_char(a.aostat)),
              trim(c.cenom)
        from fsd010 a,
             fst004 b,
             fst026 c,
             fsr008 d
       where a.aomod  = b.modulo
         and a.aotope = b.totope
         and a.pgcod  = d.pgcod
         and a.aocta  = d.ctnro
         and d.pepais = 604
         and d.petdoc = wTIPO_DOCUMENTO
         and d.pendoc = rpad(wNUMERO_DOCUMENTO, 12, ' ')         
         and a.aostat = c.cecod
         and a.pgcod = 1
         and d.ttcod = 1
         and a.aomod in (Select modulo from fst111 where dscod = 50);     
  exception
  when no_data_found then  
    wFLAG_PROC := 2;
  when others then      
    wFLAG_PROC := 0;
    wMSG_PROC  := substr(sqlerrm,1,200);
  end PRC_LSB_CUENTAS;                                
  Procedure PRC_SEMT_CUENTAS(wTIPO_DOCUMENTO   in  number,
                             wNUMERO_DOCUMENTO in  varchar2,
                             wFLAG_VMCT        out Number,
                             wANALISTA_CREDITO out varchar2,
                             wFLAG_PROC        out Number,
                             wMSG_PROC         out varchar2,
                             wCTA_REF_CURSOR   out cuentas_refcur
                            ) is     
  cursor c_cuentas is   
       Select Case
              when a.scmod = 21 then
                trim(lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scsbop,2,'0')||lpad(a.sctope,3,'0'))
              Else
                trim(lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scoper,9,'0')||lpad(a.sctope,3,'0')) 
              End                                                                                                             NRO_CUENTA,
              trim(b.tonom)                                                                                                   DESC_CUENTA,
              a.scmod                                                                                                         COD_PRODUCTO,
              e.mdnom                                                                                                         DES_PRODUCTO,
              a.sctope                                                                                                        TIP_PRODUCTO,
              a.scmda                                                                                                         MONEDA,
              trim(to_char(a.scstat))                                                                                         COD_ESTADO,
              trim(c.cenom)                                                                                                   DESC_ESTADO,
              case
                when a.scmod = 21 then
                  a.scsdo 
                Else
                (Select nvl(sum(x.scsdo),0) 
                   from fsd011 x 
                  where x.pgcod  = a.pgcod 
                    and x.scsuc  = a.scsuc 
                    and x.scmda  = a.scmda 
                    and x.scpap  = a.scpap 
                    and x.sccta  = a.sccta 
                    and x.scoper = a.scoper
                    and x.scsbop = a.scsbop
                    and x.scmod  in (22,426)
                )                  
              End                                                                                                             SALDO_CONTABLE,  
              case
                when a.scmod = 21 then
                  0
                Else
                (Select nvl(sum(x.scsdo),0) 
                   from fsd011 x 
                  where x.pgcod  = a.pgcod 
                    and x.scsuc  = a.scsuc 
                    and x.scmda  = a.scmda 
                    and x.scpap  = a.scpap 
                    and x.sccta  = a.sccta 
                    and x.scoper = a.scoper
                    and x.scsbop = a.scsbop
                    and x.scmod  in (426)
                )                  
              End                                                                                                             SALDO_DISPONIBLE,
              a.pgcod,
              a.scsuc,
              a.sccta,
              a.scoper,
              a.scsbop
        from fsd011 a,
             fst004 b,
             fst026 c,
             fsr008 d,
             fst003 e
       where a.scmod  = b.modulo
         and a.sctope = b.totope
         and a.pgcod  = d.pgcod
         and a.sccta  = d.ctnro
         and b.modulo = e.modulo
         and d.pepais = 604
         and d.petdoc = wTIPO_DOCUMENTO
         and d.pendoc = rpad(wNUMERO_DOCUMENTO, 12, ' ')
         and d.ttcod  = 1
         and a.scstat = c.cecod
         and a.pgcod = 1
         and a.scmod in (21,22)
         and a.scstat <> 99 
         and a.scsdo > 0;
         
  cursor c_guia_modulos(ln_pgcod in number, ln_sctope in number) is
    Select *
      from fst198
     Where Tp1cod   = ln_pgcod
       and Tp1cod1  = 10822
       and Tp1corr1 = 2
       and Tp1corr2 = 3
       and Tp1nro3  = ln_sctope;
       
  cursor c_saldos(ln_Pgcod   in number,
                  ln_Tp1nro1 in number,
                  ln_Scmda   in number, 
                  ln_Sccta   in number,
                  ln_Scsuc   in number,
                  ln_Scsbop  in number
                  ) is
     Select *
       from FSD011
      Where PgCod = ln_Pgcod
        and Scmod = ln_Tp1nro1
        and Scmda = ln_Scmda
        and Scpap = 0
        and Sccta = ln_Sccta
        and Scsuc = ln_Scsuc
        and Scsbop = ln_Scsbop;
             
  lc_tipcta        varchar2(20);    
  ln_numtit        number(3);
  tipper           char(1);
  lc_indgar        char(1);    
  ln_SdoDisp       number(17,2):=0;      
  ln_AcumRes       number(17,2):=0;      
  ln_AcumSum       number(17,2):=0;      
  ln_AcumRes2      number(17,2):=0;      
  ln_AcumSum2      number(17,2):=0;      
  ln_Saldo_P       number(17,2):=0;      
  ln_Scmod_SD      number(17,2):=0;    
  ln_Saldo_M       number(17,2):=0;    
  ln_ImpmovD       number(17,2):=0;      
  ln_ImpmovR       number(17,2):=0;      
  ln_cont          number(9):=0;                                                                   
  ln_prelacion     number(3):=0;
  v_rec            typ_semt; 
  begin
    wMSG_PROC  := null;

    --verificamos si tiene deuda vencida en la caja.
    begin
      select /*+parallel(cre,3) parallel(j64,3)*/
             1                                                              
        into wFLAG_VMCT
        from fsd011 cre, 
             jaql964 j64
       where cre.pgcod = 1
         and cre.scrub in (select rubro
                             from fsd014
                            where pcimpu = 'S'
                              and pcnivc in
                                  (select modulo
                                     from fst111
                                    where dscod = 50
                                      and modulo not in (33, 120, 141, 144, 200))
                           ) -- descomentar para obtener solo cartera vencida
           and j64.jaql964suc = cre.scsuc
           and j64.jaql964cta = cre.sccta
           and j64.jaql964mod = cre.scmod
           and j64.jaql964mda = cre.scmda
           and j64.jaql964ope = cre.scoper
           and j64.jaql964sob = cre.scsbop
           and j64.jaql964top = cre.sctope
           and cre.sctope <> 550
           and cre.scstat <> 99 
           and j64.jaql964dia >= 8
           and j64.jaql964mtd > 0
           and j64.jaql964doc = rpad(wNUMERO_DOCUMENTO,12,' ');
    exception
    when no_data_found then 
      wFLAG_VMCT := 0;
    When others then       
        wFLAG_PROC := 0;
        wMSG_PROC  := substr(sqlerrm,1,200);   
        return;              
    end;
    --obtenemos analista de créditos
    begin       
      Select b.sng001ase
        into wANALISTA_CREDITO
        from sng001 b
       where b.sng001inst = (Select max(a.sng001inst)
                              from sng001 a
                             where a.sng001pais = 604
                               and a.sng001tdoc = wTIPO_DOCUMENTO
                               and a.sng001ndoc = rpad(wNUMERO_DOCUMENTO, 12, ' ')
                               and upper(a.sng001ase) <> 'RDSBMOBILE'
                            );         
    exception 
    when no_data_found then  
      wANALISTA_CREDITO := null;
    when others then     
        wFLAG_PROC := 0;
        wMSG_PROC  := substr(sqlerrm,1,200);   
        return;             
    end;
    
    delete from crdtcap where c_descri1 = wNUMERO_DOCUMENTO;
    commit;
    for i in c_cuentas loop
      begin
      select x.petipo
        into tipper
        from fsd001 x, fsr008 y
       where x.pepais = y.pepais
         and x.petdoc = y.petdoc
         and x.pendoc = y.pendoc
         and y.pgcod = i.pgcod
         and y.ctnro = i.sccta
         and y.cttfir = 'T';
      exception
      when others then   
        tipper := 'F';
      end;       
      if tipper = 'J' then
        lc_tipcta := 'INDIVIDUAL';
      Else  
        --obtenemos tipo de cuenta
        lc_tipcta := fn_facultad_cta(vpgcod  => i.pgcod,
                                     vscsuc  => i.scsuc,
                                     vscmda  => i.MONEDA,
                                     vscpap  => 0,
                                     vsccta  => i.sccta,
                                     vscoper => i.scoper,
                                     vscsbop => i.scsbop,
                                     vsctope => i.TIP_PRODUCTO,
                                     vscmod  => i.COD_PRODUCTO
                                     );
      end if;                             
      --obtenemos integrantes
      begin 
        Select count(1)
          into ln_numtit
          from fsr008 a
         where a.pgcod = i.pgcod
           and a.ctnro = i.sccta;
      exception 
      when others then     
        wFLAG_PROC := 0;
        wMSG_PROC  := substr(sqlerrm,1,200);   
        return;      
      end;
      --obtenemos si es garantia
      begin 
        Select 'S'
          into lc_indgar
          from fsr011 a,
               fsd010 b
         where a.r2cod  = b.pgcod
           and a.r2mod  = b.aomod
           and a.r2suc  = b.aosuc
           and a.r2mda  = b.aomda
           and a.r2pap  = b.aopap
           and a.r2cta  = b.aocta
           and a.r2oper = b.aooper
           and a.r2sbop = b.aosbop
           and a.r2tope = b.aotope                
           and a.r1cod  = i.pgcod
           and a.r1mod  = i.COD_PRODUCTO
           and a.r1suc  = i.scsuc
           and a.r1mda  = i.MONEDA
           and a.r1pap  = 0
           and a.r1cta  = i.sccta
           and a.r1oper = i.scoper
           and a.r1sbop = i.scsbop
           and a.r1tope = i.TIP_PRODUCTO
           and a.relcod in (2,25)
           and b.aostat <> 99
           and rownum < 2;
      exception 
      When no_data_found then
        lc_indgar := 'N';
      when others then     
        wFLAG_PROC := 0;
        wMSG_PROC  := substr(sqlerrm,1,200);   
        return;      
      end;      
      --saldo disponible      
      if i.cod_producto = 21 then
        ln_AcumRes  := 0;
        ln_AcumSum  := 0;
        ln_AcumRes2 := 0;
        ln_AcumSum2 := 0;
        ln_Saldo_P  := 0;
        ln_Scmod_SD := 0;            
        ln_SdoDisp  := 0;
        ln_cont:=0;
        For j in c_guia_modulos(i.Pgcod, i.TIP_PRODUCTO) loop      
            ln_cont     := ln_cont + 1; 
            ln_Scmod_SD := j.Tp1nro1;
            ln_Saldo_M  := 0;            
            For k in c_saldos(i.Pgcod,   
                              j.Tp1nro1, 
                              i.MONEDA,   
                              i.Sccta,   
                              i.Scsuc,   
                              i.Scsbop  
              ) loop
            
              If k.Scsdo < 0 then
                  ln_Saldo_P := (-1)*(k.Scsdo);
              Else
                  ln_Saldo_P := k.Scsdo;
              End If;

              If (j.Tp1imp1 = 0) Or (k.Scrub  = j.Tp1imp1) then
                  ln_Saldo_M := ln_Saldo_M + ln_Saldo_P;
              End If;                                    
            End loop;
            If j.Tp1imp3 <> 0 then
                If ln_AcumRes < ln_Saldo_M and j.Tp1nro2 = 1 then
                    ln_AcumSum := ln_Saldo_M;
                Else
                    If ln_AcumRes < ln_Saldo_M and j.Tp1nro2 = 2 then
                        ln_AcumRes := ln_Saldo_M;
                    End If;
                End If;
            Else
                If j.Tp1nro2 = 1 then
                    ln_AcumSum2 := ln_AcumSum2 + ln_Saldo_M;
                Else
                    ln_AcumRes2 := ln_AcumRes2 + ln_Saldo_M;
                End If;
            End If;            
        End loop;
        
        if ln_cont = 0 then
          For j in c_guia_modulos(i.Pgcod, 0) loop      
              ln_Scmod_SD := j.Tp1nro1;
              ln_Saldo_M  := 0;            
              For k in c_saldos(i.Pgcod,   
                                j.Tp1nro1, 
                                i.MONEDA,   
                                i.Sccta,   
                                i.Scsuc,   
                                i.Scsbop  
                ) loop
              
                If k.Scsdo < 0 then
                    ln_Saldo_P := (-1)*(k.Scsdo);
                Else
                    ln_Saldo_P := k.Scsdo;
                End If;

                If (j.Tp1imp1 = 0) Or (k.Scrub  = j.Tp1imp1) then
                    ln_Saldo_M := ln_Saldo_M + ln_Saldo_P;
                End If;                                    
              End loop;
              If j.Tp1imp3 <> 0 then
                  If ln_AcumRes < ln_Saldo_M and j.Tp1nro2 = 1 then
                      ln_AcumSum := ln_Saldo_M;
                  Else
                      If ln_AcumRes < ln_Saldo_M and j.Tp1nro2 = 2 then
                          ln_AcumRes := ln_Saldo_M;
                      End If;
                  End If;
              Else
                  If j.Tp1nro2 = 1 then
                      ln_AcumSum2 := ln_AcumSum2 + ln_Saldo_M;
                  Else
                      ln_AcumRes2 := ln_AcumRes2 + ln_Saldo_M;
                  End If;
              End If;            
          End loop;          
        End If;  


        ln_SdoDisp := ln_AcumSum + ln_AcumSum2 - ln_AcumRes - ln_AcumRes2;

        begin
        Select case
                when JAQL736RET = 0 then
                  JAQL736DEP
                Else
                  0  
                End ImpmovD,
                case
                when JAQL736RET = 0 then
                  0
                Else
                  JAQL736RET  
                End ImpmovR 
          into ln_ImpmovD,
               ln_ImpmovR            
          from jaql736
         Where JAQL736PGC = i.Pgcod
           and JAQL736SUC = i.Scsuc
           and JAQL736MOD = i.COD_PRODUCTO
           and JAQL736MDA = i.MONEDA
           and JAQL736PAP = 0
           and JAQL736SCT = i.Sccta
           and JAQL736SBO = i.Scsbop
           and JAQL736OPE = i.Scoper
           and JAQL736TOP = i.TIP_PRODUCTO
           and JAQL736EST = 'ZZ';
        exception 
        when no_data_found then
          ln_ImpmovD := 0;
          ln_ImpmovR := 0;
        when others then  
            wFLAG_PROC := 0;
            wMSG_PROC  := substr(sqlerrm, 1, 200);          
        end;

        ln_SdoDisp := ln_SdoDisp + ln_ImpmovD - ln_ImpmovR;
        
        If ln_SdoDisp < 0 then
            ln_SdoDisp := 0;
        End If;
      else
        ln_SdoDisp := i.saldo_disponible;
      end If ;
        --INSERTAMOS EN LA TABLA CRDTCAP
        Case
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 1  then
            ln_prelacion := 2;
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 2  then
            ln_prelacion := -1;
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 3  then
            ln_prelacion := 2;
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 5  then
            ln_prelacion := -1;
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 6  then
            ln_prelacion := 0;
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 7  then
            ln_prelacion := -1;
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 8  then
            ln_prelacion := -1;
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 9  then
            ln_prelacion := 1;
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 11 then
            ln_prelacion := -1;
          When i.COD_PRODUCTO = 21 and i.TIP_PRODUCTO = 12 then
            ln_prelacion := 2;
          When i.COD_PRODUCTO = 22 then
            ln_prelacion := 0;           
          Else
            ln_prelacion := 2;
        End Case;      
        BEGIN
          insert into crdtcap(c_descri1,
                              c_descri2,
                              c_descri3,
                              n_monto1,
                              c_descri4,
                              n_monto2,
                              n_monto3,
                              n_monto4,                                                            
                              c_descri5,
                              n_monto5,
                              c_descri6,
                              n_monto6,
                              n_monto7,
                              n_monto8,                              
                              c_descri7,
                              c_descri8,
                              n_monto9--prelación                                                            
                              )
                        values(wNUMERO_DOCUMENTO,
                               i.NRO_CUENTA,
                               i.DESC_CUENTA,
                               i.COD_PRODUCTO,
                               i.DES_PRODUCTO,
                               i.TIP_PRODUCTO,
                               i.scoper,
                               i.scsbop,
                               lc_tipcta,
                               ln_numtit,
                               lc_indgar,
                               i.MONEDA,
                               ln_SdoDisp,
                               i.SALDO_CONTABLE,
                               i.COD_ESTADO,
                               i.DESC_ESTADO,
                               ln_prelacion
                              );
                              commit;
        EXCEPTION
        WHEN OTHERS THEN
          wFLAG_PROC := 0;
          wMSG_PROC  := substr(sqlerrm,1,200);             
          return;
        END; 
        begin
          OPEN wCTA_REF_CURSOR FOR
             Select a.c_descri2, 
                    a.c_descri3,
                    a.n_monto1,
                    a.c_descri4,
                    a.n_monto2,
                    a.n_monto3,
                    a.n_monto4,  
                    a.c_descri5,
                    a.n_monto5,
                    a.c_descri6,
                    a.n_monto6,
                    a.n_monto7,
                    a.n_monto8,  
                    a.c_descri7,
                    a.c_descri8  
            from crdtcap a 
           where a.c_descri1 = wNUMERO_DOCUMENTO
             and a.n_monto9 >= 0;      
           LOOP       
             FETCH wCTA_REF_CURSOR INTO  v_rec;
                   if wCTA_REF_CURSOR%NOTFOUND then
                      wFLAG_PROC := 2;
                   Else               
                      wFLAG_PROC := 1;       
                   End If;             
                   EXIT;
             END LOOP;
             CLOSE wCTA_REF_CURSOR;               
        exception
        when others then
            wFLAG_PROC := 0;
            wMSG_PROC  := substr(sqlerrm, 1, 200);
        end;       
        
        begin
          OPEN wCTA_REF_CURSOR FOR
             Select a.c_descri2  CUENTA_NUMERO,   
                    a.c_descri3  NOM_CUENTA,      
                    a.n_monto1   MODULO,          
                    a.c_descri4  DESC_MODULO,     
                    a.n_monto2   TIPO_OPERACION,  
                    a.n_monto3   NRO_OPERACION,   
                    a.n_monto4   NRO_SUBOPERACION,
                    a.c_descri5  TIPO_CUENTA,     
                    a.n_monto5   NRO_INTEG,       
                    a.c_descri6  FLAG_GARANTIA,   
                    a.n_monto6   MONEDA,          
                    a.n_monto7   SALDO_DISPONIBLE,
                    a.n_monto8   SALDO_CONTABLE,  
                    a.c_descri7  COD_ESTADO,      
                    a.c_descri8  DESC_ESTADO     
            from crdtcap a       
           where a.c_descri1 = wNUMERO_DOCUMENTO
             and a.n_monto9 >= 0      
             order by a.n_monto9 desc,a.n_monto6,decode(a.n_monto6,101,a.n_monto7*fn_tipo_cambio(trunc(sysdate),101,0,500),a.n_monto7) desc;            
        exception
          when others then
            wFLAG_PROC := 0;
            wMSG_PROC  := substr(sqlerrm, 1, 200);
        end;                  
    End loop;         
  Exception  
  when others then      
    wFLAG_PROC := 0;
    wMSG_PROC  := substr(sqlerrm,1,200);    
  end PRC_SEMT_CUENTAS;                           
  Procedure PRC_TIPO_CAMBIO(TIPO_CAMBIO       out Number,
                            wFLAG_PROC        out Number,
                            wMSG_PROC         out varchar2
                           ) is    
  begin
  -- Call the procedure
  sp_tipo_cambio(fecha => trunc(Sysdate),
                 monori => 0,
                 mondes => 101,
                 tipo => 0,
                 tc => TIPO_CAMBIO
                 );    
    if TIPO_CAMBIO = 0 then
       wFLAG_PROC := 2;
    Else
       wFLAG_PROC := 1;
    End If;                    
  exception
  when others then               
    wFLAG_PROC := 0;
    wMSG_PROC  := substr(sqlerrm,1,200);       
  end PRC_TIPO_CAMBIO;  
  Procedure PRC_ITF(PORC_ITF       out Number,
                    wFLAG_PROC     out Number,
                    wMSG_PROC      out varchar2
                   ) is    
  begin
    Select b.coefic*100
      into PORC_ITF
      from fst144 b
     where b.coecod = 7
       and b.coefdes = (Select max(a.coefdes) from fst144 a where a.coecod = 7);      
       
    wFLAG_PROC := 1;
  exception
  When no_data_found then
    wFLAG_PROC := 2;
  when others then               
    wFLAG_PROC := 0;
    wMSG_PROC  := substr(sqlerrm,1,200);    
  end PRC_ITF;      
  Procedure PRC_COMISIONES(wFLAG_PROC        out Number,
                           wMSG_PROC         out varchar2,
                           wCOMI_REF_CURSOR  out comisiones_refcur
                          ) is    
  v_rec     typ_com;                               
  begin
    OPEN wCOMI_REF_CURSOR FOR                              
      Select '169' CODIGO,
             0 MONEDA,
             pq_ah_comision.fn_ah_monto_comision(p_n_modcom => 462,
                                                 p_n_codcom => 169,
                                                 p_n_monmov => 0) MTO_COMISION
        from dual
      union
      Select '170',
             0,
             pq_ah_comision.fn_ah_monto_comision(p_n_modcom => 462,
                                                 p_n_codcom => 170,
                                                 p_n_monmov => 0) MTO_COMISION
        from dual;
    LOOP       
    FETCH wCOMI_REF_CURSOR INTO  v_rec;
       if wCOMI_REF_CURSOR%NOTFOUND then
          wFLAG_PROC := 2;
       Else               
          wFLAG_PROC := 1;       
       End If;             
       EXIT;
    END LOOP;
    CLOSE wCOMI_REF_CURSOR;     
    
    OPEN wCOMI_REF_CURSOR FOR                              
      Select '169' CODIGO,
             0 MONEDA,
             pq_ah_comision.fn_ah_monto_comision(p_n_modcom => 462,
                                                 p_n_codcom => 169,
                                                 p_n_monmov => 0) MTO_COMISION
        from dual
      union
      Select '170',
             0,
             pq_ah_comision.fn_ah_monto_comision(p_n_modcom => 462,
                                                 p_n_codcom => 170,
                                                 p_n_monmov => 0) MTO_COMISION
        from dual;                 
   exception
   when others then                                          
    wFLAG_PROC := 0;
    wMSG_PROC  := substr(sqlerrm,1,200);    
  end PRC_COMISIONES;                                                    
end PQ_EM_SEMT_LSB_INTERFACE;
/

