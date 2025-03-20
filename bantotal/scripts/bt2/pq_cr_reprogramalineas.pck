create or replace package pq_cr_reprogramalineas is

  -- Author  : KVALENCIAC
  -- Created : 10/12/2021
  -- Purpose : Proceso graba el crédito de reprogramación en las tablas de reprogrmaciones

  procedure sp_inserta(      v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_UbuserAct in varchar,
                             v_Pgfape in date,                             
                             ln_rpta out number
                             ) ;
end pq_cr_reprogramalineas;
/

create or replace package body pq_cr_reprogramalineas is
procedure sp_inserta(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number, 
                             v_UbuserAct in varchar,
                             v_Pgfape in date,                            
                             ln_rpta  out number
                             ) is  
    ln_jaqy800ins number;                           
    ln_jaqy800ins2 number;
    ln_XWFEMPRESA number;
    ln_XWFSUCURSAL number;
    ln_XWFMODULO number;
    ln_XWFMONEDA number;
    ln_XWFPAPEL number;
    ln_XWFCUENTA number;
    ln_XWFOPERACION number;
    ln_XWFSUBOPE number;
    ln_XWFTIPOPE number;
    ln_AQPB904CFACI number;
    ln_AQPB904MNTD number;
    --me envia la clave del crédito que se está procesando es el de la FSD016 ordinal 10
    Begin
      ln_jaqy800ins :=0;
      ln_jaqy800ins2 :=0;
         begin 
            select xwfprcins into ln_jaqy800ins
            from xwf700
            where XWFEMPRESA = v_pgcod 
              and XWFSUCURSAL= v_Scsuc  
              and XWFMODULO  = v_Scmod 
              and XWFMONEDA  = v_Scmda 
              and XWFPAPEL   = v_Scpap 
              and XWFCUENTA  = v_Sccta 
              and XWFOPERACION=v_Scoper
              and XWFSUBOPE  = v_Scsbop
              and XWFTIPOPE  = v_Sctope
              and xwfcar3 = '1';
         exception
           when others then
               ln_jaqy800ins :=0;
         end;
         begin
           select jaqy800ins2 into ln_jaqy800ins2 from jaqy800 
           where jaqy800ins=ln_jaqy800ins; --instancia del nuevo crédito  obtengo la instancia del crédito original
         exception
           when others then
               ln_jaqy800ins2 :=0;
         end;
         if ( ln_jaqy800ins2 > 0) then
           begin 
             select XWFEMPRESA,
                    XWFSUCURSAL,
                    XWFMODULO,
                    XWFMONEDA,
                    XWFPAPEL,
                    XWFCUENTA,
                    XWFOPERACION,
                    XWFSUBOPE,
                    XWFTIPOPE
                    into
                    ln_XWFEMPRESA,
                    ln_XWFSUCURSAL, 
                    ln_XWFMODULO,
                    ln_XWFMONEDA,
                    ln_XWFPAPEL,
                    ln_XWFCUENTA,
                    ln_XWFOPERACION,
                    ln_XWFSUBOPE,
                    ln_XWFTIPOPE
             from xwf700
             where xwfprcins = ln_jaqy800ins2  
             and xwfcar3 = '1';
           exception
           when others then
               ln_XWFCUENTA :=0;
           end; 
           ln_AQPB904CFACI := 0;
           if ( ln_XWFCUENTA > 0 ) then
               Begin
                 select AQPB904CFACI, AQPB904MNTD  INTO 
                        ln_AQPB904CFACI, ln_AQPB904MNTD
                 from AQPB904
                 where AQPB904COD = ln_XWFEMPRESA
                   and AQPB904MOD = ln_XWFSUCURSAL
                   and AQPB904SUC = ln_XWFMODULO
                   and AQPB904MDA = ln_XWFMONEDA
                   and AQPB904PAP = ln_XWFPAPEL
                   and AQPB904CTA = ln_XWFCUENTA
                   and AQPB904OPER =ln_XWFOPERACION
                   and AQPB904SBOP =ln_XWFSUBOPE
                   and AQPB904TOPE =ln_XWFTIPOPE
                   and AQPB904ESTA = 'G'
                   and AQPB904EHAB = 'H';
               Exception
               when others then
                 ln_AQPB904CFACI := 0;
               end;
               if ( ln_AQPB904CFACI = 1 ) then  -- Reduccion de Tasa(AQPA840) 
                 update AQPA840 set   AQPA840EST = 'E'
                   where AQPA840EMP = v_pgcod 
                   and   AQPA840MOD = v_Scmod 
                   and   AQPA840SUC = v_Scsuc 
                   and   AQPA840MDA = v_Scmda  
                   and   AQPA840PAP = v_Scpap 
                   and   AQPA840CTA = v_Sccta 
                   and   AQPA840OPE = v_Scoper
                   and  AQPA840SBO = v_Scsbop
                   and  AQPA840TOP = v_Sctope
                   and  AQPA840TIP = 1;
                 begin
                   update AQPA840 set AQPA840TIP = 1,
                                      AQPA840RUB = null,
                                      AQPA840INS = ln_jaqy800ins,
                                      AQPA840SDO = null,
                                      AQPA840EST   = 'C',
                                      AQPA840ITFCON= v_Pgfape,
                                      AQPA840ITHOR  = null,
                                      AQPA840ITUCNF = v_UbuserAct,
                                      AQPA840COML  ='Linea'
                   where                          
                        AQPA840EMP = v_pgcod and
                        AQPA840MOD = v_Scmod and
                        AQPA840SUC = v_Scsuc and
                        AQPA840MDA = v_Scmda  and
                        AQPA840PAP = v_Scpap and
                        AQPA840CTA = v_Sccta and
                        AQPA840OPE = v_Scoper and
                        AQPA840SBO = v_Scsbop and
                        AQPA840TOP = v_Sctope and
                        AQPA840FECR = v_Pgfape;
                  Exception
                  when others then
                   insert into aqpa840 (
                                  AQPA840EMP,
                                  AQPA840MOD,
                                  AQPA840SUC,
                                  AQPA840MDA,
                                  AQPA840PAP,
                                  AQPA840CTA, 
                                  AQPA840OPE, 
                                  AQPA840SBO,
                                  AQPA840TOP, 
                                  AQPA840FECR,                                               
                                  AQPA840TIP, 
                                  AQPA840RUB, 
                                  AQPA840INS, 
                                  AQPA840SDO, 
                                  AQPA840EST,                                                
                                  AQPA840ITFCON,
                                  AQPA840ITHOR, 
                                  AQPA840ITUCNF,
                                  AQPA840COML)
                        values
                                (v_pgcod, 
                                 v_Scmod ,
                                 v_Scsuc ,
                                 v_Scmda, 
                                 v_Scpap, 
                                 v_Sccta, 
                                 v_Scoper,
                                 v_Scsbop,
                                 v_Sctope,
                                 v_Pgfape,
                                  1,
                                  null,
                                  ln_jaqy800ins,
                                  null,
                                 'C',
                                 v_Pgfape,
                                 null,
                                 v_UbuserAct,
                                 'Linea');
                  end;                                                
               end if;
               if ( ln_AQPB904CFACI = 5 ) then  -- Tasa Juntos (AQPA840)
                   update AQPA840 set   AQPA840EST = 'E'
                   where AQPA840EMP = v_pgcod 
                   and AQPA840MOD = v_Scmod 
                   and AQPA840SUC = v_Scsuc 
                   and AQPA840MDA = v_Scmda  
                   and AQPA840PAP = v_Scpap 
                   and AQPA840CTA = v_Sccta 
                   and AQPA840OPE = v_Scoper
                   and AQPA840SBO = v_Scsbop
                   and AQPA840TOP = v_Sctope
                   and AQPA840TIP = 5;
                 begin
                   update AQPA840 set    AQPA840TIP   = 5,
                                         AQPA840RUB   = null,
                                         AQPA840INS   = ln_jaqy800ins,
                                         AQPA840SDO   = null,
                                         AQPA840EST   = 'C',
                                         AQPA840ITFCON= v_Pgfape,
                                         AQPA840ITHOR = null,
                                         AQPA840ITUCNF= v_UbuserAct,
                                         AQPA840COML  = 'Linea'
                   where                          
                        AQPA840EMP = v_pgcod and
                        AQPA840MOD = v_Scmod and
                        AQPA840SUC = v_Scsuc and
                        AQPA840MDA = v_Scmda  and
                        AQPA840PAP = v_Scpap and
                        AQPA840CTA = v_Sccta and
                        AQPA840OPE = v_Scoper and
                        AQPA840SBO = v_Scsbop and
                        AQPA840TOP = v_Sctope and
                        AQPA840FECR = v_Pgfape;
                  Exception
                  when others then
                   insert into aqpa840 (
                                  AQPA840EMP,
                                  AQPA840MOD,
                                  AQPA840SUC,
                                  AQPA840MDA,
                                  AQPA840PAP,
                                  AQPA840CTA, 
                                  AQPA840OPE, 
                                  AQPA840SBO,
                                  AQPA840TOP, 
                                  AQPA840FECR,                                               
                                  AQPA840TIP, 
                                  AQPA840RUB, 
                                  AQPA840INS, 
                                  AQPA840SDO, 
                                  AQPA840EST,                                                
                                  AQPA840ITFCON,
                                  AQPA840ITHOR, 
                                  AQPA840ITUCNF,
                                  AQPA840COML)
                        values
                                (v_pgcod, 
                                 v_Scmod ,
                                 v_Scsuc ,
                                 v_Scmda, 
                                 v_Scpap, 
                                 v_Sccta, 
                                 v_Scoper,
                                 v_Scsbop,
                                 v_Sctope,
                                 v_Pgfape,
                                  5,
                                  null,
                                  ln_jaqy800ins,
                                  null,
                                 'C',
                                 v_Pgfape,
                                 null,
                                 v_UbuserAct,
                                 'Linea');
                  end;          
               end if;
               if ( ln_AQPB904CFACI = 6 ) then  -- Exoneracion de Capitalizacion - Caja Exoneración (AQPB411)
                 begin
                     update AQPB411 set AQPB411EST   = 'P',
                                        AQPB411USUACT= v_UbuserAct,
                                        AQPB411FECACT= v_Pgfape,
                                        AQPB411FECEXT= null,
                                        aqpb411COML =  'Linea',
                                        aqpb411AUX02=  ln_AQPB904MNTD
                     where AQPB411COD = v_pgcod and
                           AQPB411MOD = v_Scmod and
                           AQPB411SUC = v_Scsuc and
                           AQPB411MDA = v_Scmda and
                           AQPB411PAP = v_Scpap and
                           AQPB411CTA = v_Sccta and
                           AQPB411OPE = v_Scoper and
                           AQPB411SBO = v_Scsbop and
                           AQPB411TPO = v_Sctope;
                  Exception
                  when others then
                     insert into AQPB411 (AQPB411COD,  
                                      AQPB411MOD,
                                      AQPB411SUC,
                                      AQPB411MDA,
                                      AQPB411PAP,
                                      AQPB411CTA,
                                      AQPB411OPE,
                                      AQPB411SBO,
                                      AQPB411TPO,
                                      AQPB411EST,
                                      AQPB411USUACT,
                                      AQPB411FECACT,
                                      aqpb411COML,                                      
                                      aqpb411AUX02)
                       values
                               (  v_pgcod, 
                                  v_Scmod,
                                  v_Scsuc,                                     
                                  v_Scmda, 
                                  v_Scpap, 
                                  v_Sccta, 
                                  v_Scoper,
                                  v_Scsbop,
                                  v_Sctope,
                                  'P',
                                  v_UbuserAct,
                                  v_Pgfape,
                                  'Linea',
                                  ln_AQPB904MNTD
                                  );
                  end;  
               end if;
               if ( ln_AQPB904CFACI = 7 ) then  -- 7 Amortizacion Anticipada(AQPB411)
                 begin
                     update AQPB411 set AQPB411EST   = 'P',
                                        AQPB411TIPO  = 'C', --indica que es amortizacion anticipada      
                                        AQPB411USUACT= v_UbuserAct,
                                        AQPB411FECACT= v_Pgfape,
                                        AQPB411FECEXT= null,
                                        aqpb411COML  = 'Linea',
                                        aqpb411AUX02 = ln_AQPB904MNTD
                     where AQPB411COD = v_pgcod and
                           AQPB411MOD = v_Scmod and
                           AQPB411SUC = v_Scsuc and
                           AQPB411MDA = v_Scmda and
                           AQPB411PAP = v_Scpap and
                           AQPB411CTA = v_Sccta and
                           AQPB411OPE = v_Scoper and
                           AQPB411SBO = v_Scsbop and
                           AQPB411TPO = v_Sctope;
                  Exception
                  when others then
                     insert into AQPB411 (AQPB411COD,  
                                      AQPB411MOD,
                                      AQPB411SUC,
                                      AQPB411MDA,
                                      AQPB411PAP,
                                      AQPB411CTA,
                                      AQPB411OPE,
                                      AQPB411SBO,
                                      AQPB411TPO,
                                      AQPB411EST,
                                      AQPB411TIPO,
                                      AQPB411USUACT,
                                      AQPB411FECACT,
                                      aqpb411COML,
                                      aqpb411AUX02)
                       values
                               (  v_pgcod, 
                                  v_Scmod,
                                  v_Scsuc,                                     
                                  v_Scmda, 
                                  v_Scpap, 
                                  v_Sccta, 
                                  v_Scoper,
                                  v_Scsbop,
                                  v_Sctope,
                                  'P',
                                  'C', --indica que es amortizacion anticipada
                                  v_UbuserAct,
                                  v_Pgfape,                                  
                                  'Linea',
                                  ln_AQPB904MNTD
                                  );
                  end;  
               end if;  
          end if;   
         end if;
end sp_inserta;
/*
procedure sp_extornaCMR(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number                             
                             ) is
     ln_id number;
     ld_pgfape date;
     lc_facilidad varchar(30); --06/05/2021  kdvc
    --Retorna S si se encuentra habilitado
   Begin
      ln_id :=0;
      select pgfape into ld_pgfape from fst017 where pgcod=v_pgcod;
      Begin
      select L.IDLEY31050,F.facilidad into ln_id,lc_facilidad --L.IDLEY31050 into ln_id  --06/05/2021  kdvc
        FROM LEY31050 L --obtengo  l.idley3150
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE --L.ESTADOSOLICITUD = 'AP'  AND
             L.TIPOFACILIDAD in ( 'CAJA') --'CAJA',
            AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
            AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
            AND F.EMPRESA  = v_pgcod
            AND F.SUCURSAL = v_Scsuc
            AND F.MODULO =  v_Scmod
            AND F.MONEDA =  v_Scmda
            AND F.PAPEL  =  v_Scpap
           -- AND F.SUBOPERACION  = v_Scsbop
            AND F.TIPOOPERACION = v_Sctope; 
      exception
        when no_data_found then
          ln_id :=0;
      end;
       if ( ln_id <> 0 ) then

          update LEY31050_CREDITOSFACILIDAD F set PROCESADOBT='E', NUEVOCRONOGRAMA = null
          WHERE F.IDLEY31050 = ln_id
              AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod
              AND F.SUCURSAL = v_Scsuc
              AND F.MODULO =  v_Scmod
              AND F.MONEDA =  v_Scmda
              AND F.PAPEL  =  v_Scpap
             -- AND F.SUBOPERACION  = v_Scsbop
              AND F.TIPOOPERACION = v_Sctope;
          commit;
          --inicio kdvc 08/01/2020   esto es para el extorno de los casos que tienen doble registro por que uno de los titulares falleció
          update LEY31050_CREDITOSFACILIDAD F set PROCESADOBT='E', NUEVOCRONOGRAMA = null
          WHERE F.IDLEY31050 = ln_id
             -- AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod;
          commit;          
          --fin kdvc 08/01/2020
          update LEY31050 L 
             set  ESTADOSOLICITUD='BT' , FECHAENPARAAPROBACION=null
             WHERE  L.IDLEY31050 =  ln_id;
                -- and L.ESTADOSOLICITUD = 'BT' 
--                AND L.TIPOFACILIDAD = 'CAJA' ;  --para que funciona para caja y gobierno se comentó                          
          commit;
       end if;
       
       if ( ltrim(lc_facilidad) = 'Exoneración de capitalización'  or  ltrim(lc_facilidad) = 'Exoneracion de capitalizacion' ) then  --13/08/2021 kdvc --06/05/2021  kdvc
           ---extorno tabla AQPB411
           update AQPB411 set AQPB411EST='E', AQPB411FECEXT=ld_pgfape
           where AQPB411COD = v_pgcod  
           and AQPB411MOD =  v_Scmod  
           and AQPB411SUC =  v_Scsuc  
           and AQPB411MDA =  v_Scmda  
           and AQPB411PAP =  v_Scpap  
           and AQPB411CTA =  v_Sccta  
           and AQPB411OPE =  v_Scoper 
           and AQPB411SBO =  v_Scsbop 
           and AQPB411TPO =  v_Sctope ;
           commit;  
        end if ;
        if ( lc_facilidad = 'Reducción de tasa' ) or ( lc_facilidad = 'Reduccion de tasa' ) then  --13/08/2021 kdvc --06/05/2021  kdvc  inicio
          update AQPA840 set AQPA840EST='E', AQPA840FECEXT=ld_pgfape
           where AQPA840EMP = v_pgcod  
           and AQPA840MOD =  v_Scmod  
           and AQPA840SUC =  v_Scsuc  
           and AQPA840MDA =  v_Scmda  
           and AQPA840PAP =  v_Scpap  
           and AQPA840CTA =  v_Sccta  
           and AQPA840OPE =  v_Scoper 
           and AQPA840SBO =  v_Scsbop 
           and AQPA840TOP =  v_Sctope 
           and AQPA840TIP = 1;
            commit;  
        end if;    --06/05/2021  kdvc  fin
       if ( ltrim(lc_facilidad) = 'Amortizacion Anticipada' ) then  --13/08/2021 kdvc --09/08/2021  kdvc
           ---extorno tabla AQPB411
           update AQPB411 set AQPB411EST='E', AQPB411FECEXT=ld_pgfape
           where AQPB411COD = v_pgcod  
           and AQPB411MOD =  v_Scmod  
           and AQPB411SUC =  v_Scsuc  
           and AQPB411MDA =  v_Scmda  
           and AQPB411PAP =  v_Scpap  
           and AQPB411CTA =  v_Sccta  
           and AQPB411OPE =  v_Scoper 
           and AQPB411SBO =  v_Scsbop 
           and AQPB411TPO =  v_Sctope ;
           commit;  
        end if ;  --09/08/2021  kdvc  fin
end sp_extornaCMR;
procedure sp_eliminareprogExonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_msg out varchar                             
                             ) is    
ld_pgfape date; 
ln_id number;                       
begin
  select pgfape into ld_pgfape from fst017 where pgcod= v_pgcod; 
  begin    
    update AQPB411 
    set aqpb411est = 'I', 
        aqpb411fecext = ld_pgfape,
        aqpb411aux01 = 1    
    where aqpb411cod = v_pgcod
      and aqpb411mod = v_Scmod
      and aqpb411suc = v_Scsuc
      and aqpb411mda = v_Scmda
      and aqpb411pap = v_Scpap
      and aqpb411cta = v_Sccta
      and aqpb411ope = v_Scoper
      and aqpb411sbo = v_Scsbop
      and aqpb411tpo = v_Sctope
      and aqpb411est = 'P' ;
  exception
    when others then
          v_msg:='No se ha encontrado este crédito, como un crédito de reprogramación de exoneración de última cuota.';
  end;
  
  Begin
    ln_id:=0;
      select L.IDLEY31050 into ln_id 
        FROM LEY31050 L --obtengo  l.idley3150
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE L.ESTADOSOLICITUD = 'AP'  AND
             L.TIPOFACILIDAD in ( 'CAJA') --'CAJA',
            AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
            AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
            AND F.EMPRESA  = v_pgcod
            AND F.SUCURSAL = v_Scsuc
            AND F.MODULO =  v_Scmod
            AND F.MONEDA =  v_Scmda
            AND F.PAPEL  =  v_Scpap
            AND F.SUBOPERACION  = v_Scsbop
            AND F.TIPOOPERACION = v_Sctope; 
      exception
        when no_data_found then
          ln_id :=0;
      end;
       if ( ln_id <> 0 ) then

          update LEY31050_CREDITOSFACILIDAD F set PROCESADOBT='E', NUEVOCRONOGRAMA = null
          WHERE F.IDLEY31050 = ln_id
              AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod
              AND F.SUCURSAL = v_Scsuc
              AND F.MODULO =  v_Scmod
              AND F.MONEDA =  v_Scmda
              AND F.PAPEL  =  v_Scpap
             -- AND F.SUBOPERACION  = v_Scsbop
              AND F.TIPOOPERACION = v_Sctope;
          commit;                 
          --fin kdvc 08/01/2020
          update LEY31050 L 
             set  ESTADOSOLICITUD='BT' , FECHAENPARAAPROBACION=null
             WHERE  L.IDLEY31050 =  ln_id;
          commit;
       end if;
 */
                               
end   pq_cr_reprogramalineas;
/

