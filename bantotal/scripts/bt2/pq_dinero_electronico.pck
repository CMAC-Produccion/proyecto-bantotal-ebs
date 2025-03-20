create or replace package PQ_DINERO_ELECTRONICO is

  -- Author  : HLAQUI
  -- Created : 05/04/2016 17:50:45 a.m.
  -- Purpose : Paquete que realiza la migracion de clientes de Dinero Electronico  
  -- Public type declarations
  -- Autor Modificacion: HLAQUI  
  -- Fecha Modificacion: 31/05/2017
  -- Descripcion Modificacion: Se agrega lógica del Lugar de Nacimiento, Actividad y Tipo Act
  --                           y Direccion
  -- Autor Modificacion: HLAQUI  
  -- Fecha Modificacion: 26/06/2017
  -- Descripcion Modificacion: Se agrega lógica del ingreso de direcciones
  -- Autor Modificacion: FPINTO  
  -- Fecha Modificacion: 16/10/2024
  -- Descripcion Modificacion: Se comenta accesos a bdlink deval en sp_procesar_migracion_personas
  
  procedure sp_procesar_migracion_personas;
  procedure sp_procesar_migracion_cuentas;
  Procedure sp_crear_cuenta_integrantes (p_n_NumCorr number);
  procedure sp_enviar_correo_deposito(p_n_CodDep number);
  Function fn_valida_persona(P_N_PAIS IN NUMBER,
                             P_N_TIPO IN NUMBER, 
                             P_C_NUMERO IN VARCHAR2
                             )return number;  
  Function fn_valida_cuenta(P_N_PAIS IN NUMBER,
                             P_N_TIPO IN NUMBER, 
                             P_C_NUMERO IN VARCHAR2
                             )return number;                               
end PQ_DINERO_ELECTRONICO;
/

create or replace package body PQ_DINERO_ELECTRONICO is

Procedure sp_procesar_migracion_personas is
  cursor c1 is
  select * from jaqz311 a 
  --left outer join jaqz341 b on trim(a.jaqz311numdoc) = trim(b.JAQZ341NUMDOC) --HLAQUI 31/05/2017
  where a.jaqz311fgcli = 0;
  
  cursor c2(cp_numdoc in varchar2) is
  select * from jaqz341d a 
  where a."JAQZ341dNUMDOC" = cp_numdoc; --HLAQUI 31/05/2017
  /*
  cursor c2 (numdoc in  varchar2) is    
  select * from jaqz341 b
  where b.JAQZ341NUMDOC = numdoc;
 */    
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_indexi number := 0;
  ld_fecha         date;
  ln_nroerr number := 0;
  begin
      --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;        

      --Se eliminan los registros de las bandejas.
      begin
        DELETE FROM bandejas.bjd001;
        DELETE FROM bandejas.bjd002;
        DELETE FROM bandejas.bjd003;
        DELETE FROM bandejas.bjd004;
        DELETE FROM bandejas.bjr001;
        DELETE FROM bandejas.bjr002;
        DELETE FROM bandejas.bjr003;
        DELETE FROM bandejas.bjr004;
        DELETE FROM bandejas.bjx001;    
        DELETE FROM bandejas.bjd201;    
        DELETE FROM bandejas.bngc60;          
        DELETE FROM bandejas.bnjti1;        
        DELETE FROM bandejas.bnjti2;        
        DELETE FROM bandejas.bje101;        
        DELETE FROM bandejas.bje102;  

        DELETE FROM bandejas.bjd005;
        DELETE FROM bandejas.bjr005;
        DELETE FROM bandejas.bngc13;
        DELETE FROM bandejas.bngc11;              
        
        commit;
      exception
        when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BANDEJAS', 'DELETE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
      End;

      --Se recorre la tabla JAQZ311 cuto estado sea 0         
      for i in c1 loop   
      --Se validan cada persona antes de registrar en bandejas.     
      ln_indexi:= pq_dinero_electronico.fn_valida_persona(p_n_pais   => 604,
                                                              p_n_tipo   => 21,
                                                              p_c_numero => i.jaqz311numdoc
                  
                                                  );                                                                                                                                        
      --ln_indexi := 0;                                                                                                    
      If ln_indexi = 0 then                                                            
        ln_cuenta := ln_cuenta + 1;      

        begin --BJD001
          insert into BJD001
            (BD001Pais,--1
             BD001Tdoc,
             BD001Ndoc,
             BD001Tipo,
             BD001Nom,--5
             BD001Falt,
             BD001Exent,
             BD001ResIn,
             BD001ResNo,
             BD001NoRes,--10
             BD001ConsF,
             BD001BceAj,
             BD001IngBr,
             BD001ImpIn,
             BD001NroBr,--15
             BD001NroIn,
             BD001Rg312,
             BD001Rg333,
             BD001Rg278,
             BD001InstF,--20
             BD001Pesn0,
             BE001SCnd,
             BE001SJur,
             BE001GCnd,
             BE001Prov,--25
             BE001TAlt,
             BE001ICod,
             BE001OCod,
             BE001DstCo,
             BD001Est,
             BD001VTORGNAC               
             )--30
          values
            (604,--1
             21,
             substr(i.jaqz311numdoc,1,12),
             'F',
             substr(i.jaqz311apepat || ' ' || i.jaqz311apemat || ', '|| i.jaqz311prinom || ' ' || i.jaqz311segnom,1,30),--5
             ld_fecha,
             null,
             null,
             null,
             null,--10
             null,
             null,
             null,
             null,
             0,--15
             null,--i.jaqz341ingmen, --HLAQUI 31/05/2017 --fpinto se comenta 16/10/2024
             null,
             null,
             null,
             'N', --20
             'N',
             null,
             null,
             null,
             null,--25
             1,--Normal
             null,
             0,
             14,
             'P',               
             null
             );                            
          
        exception
          when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BANDEJAS', 'DELETE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
        end;
          
        begin --BNJTI1
          insert into  bandejas.bnjti1 (
                                BT1PAIS,
                                BT1TDOC,
                                BT1NDOC,
                                BT1IMPC,
                                BT1CORR,
                                BT1BAND,
                                BT1COND,
                                BT1EST
                               ) 
                         values(604,--1
                                21,
                                substr(i.jaqz311numdoc,1,12),
                                9,
                                1,
                                150,
                                1,
                                'P'
                                );

          insert into  bandejas.bnjti1 (
                                BT1PAIS,
                                BT1TDOC,
                                BT1NDOC,
                                BT1IMPC,
                                BT1CORR,
                                BT1BAND,
                                BT1COND,
                                BT1EST 
                               )
                         values(604,--1
                                21,
                                substr(i.jaqz311numdoc,1,12),
                                9,
                                2,
                                150,
                                1,
                                'P'
                                );
                                  
          insert into  bandejas.bnjti1 (
                                BT1PAIS,
                                BT1TDOC,
                                BT1NDOC,
                                BT1IMPC,
                                BT1CORR,
                                BT1BAND,
                                BT1COND,
                                BT1EST 
                               )
                         values(604,--1
                                21,
                                substr(i.jaqz311numdoc,1,12),
                                9,
                                6,
                                150,
                                1,
                                'P'
                                );      

        exception
          when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BANDEJAS', 'DELETE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
        end;
          
        begin --BJD002
        insert  /*+append*/ into BANDEJAS.BJD002
                  (BD002Pais,
                   BD002Tdoc,
                   BD002Ndoc,
                   BD002Ape1,
                   BD002Ape2,
                   BD002Nom1,
                   BD002Nom2,
                   BD002Ebco,
                   BD002Fibc,
                   BD002Cant,
                   BD002Fnac,
                   BD002Eciv,
                   BD002Pnac,
                   BD002Lnac,
                   BD002Cleg,
                   BE002HobC,
                   BE002Club,
                   BE002NIns,
                   BE002PCod,
                   BE002PDde,
                   BE002OCod,
                   BE002VCod,
                   BE002Empr,
                   BE002CHij,
                   BE002PaiX,
                   BE002FIni,
                   BE002TVnd,
                   BE002TRes,
                   BE002NArr,
                   BE002TArr,
                   BE002DAn1,
                   BE002DAn2,
                   BE002TAnt,
                   BE002PAnt,
                   BE002AntT,
                   BE002CAnt,
                   BE002AInd,
                   BE002Fing,
                   BE002EAct,
                   BE002CAct,
                   BE002DAc1,
                   BE002DAc2,
                   BE002TAct,
                   BE002IngM,
                   BE002IngS,
                   BE002IngO,
                   BE002IngR,
                   BE002SalC,
                   BE002OtrC,
                   BE002RefC,
                   BE002IEgr,
                   BE002Hipo,
                   BE002SHip,
                   BE002CHip,
                   BE002STar,
                   BE002CTar,
                   BE002SPre,
                   BE002CPre,
                   BE002GAlq,
                   BE002GFam,
                   BE002GOtr,
                   BE002GRef,
                   BE002TInm,
                   BE002TVeh,
                   BE002TAcO,
                   BE002OAcR,
                   BE002PrdAp,
                   BE002PrdNo,
                   BE002MrdAp,
                   BE002MrdNo,
                   BE002ConAp,
                   BE002ConNo,
                   BE002ConOc,
                   BE002AxC1,
                   BE002FFal,
                   BD002Est)
                values
                  (604,
                   21,
                   substr(i.jaqz311numdoc,1,12),
                   substr(i.jaqz311apepat,1,30),
                   substr(i.jaqz311apemat,1,30),
                   substr(i.jaqz311prinom,1,25),
                   substr(i.jaqz311segnom,1,25),
                   'N',
                   null,
                   i.jaqz311sexo,
                   i.jaqz311fecnac,
                   i.jaqz311estciv, --fpinto se coloca directo la variable del cursor 16/10/2024
                   --nvl( nullif(i.jaqz341estciv,'0'),i.jaqz311estciv), --Se graba EstCiv de la JAQZ341 --fpinto se comenta 16/10/2024
                   604,--i.pais, se cambio yessenia 2013.06.07
                   substr(i.jaqz311nacdep,1,20), --No se ingresa 'Lugar de Nacimiento'
                   'S',
                   99, --Correspondiente a OTROS en tabla FST108
                   999, --Usar el codigo 999 correspondiente a "NO DEFINIDO" (FST109)
                   null,
                   null,--i.jaqz341clipro, --Profesion --HLAQUI 31/05/2017 --fpinto se comenta 16/10/2024
                   null,
                   null,--i.jaqz341cliocu, --Ocupacion --HLAQUI 31/05/2017 --fpinto se comenta 16/10/2024
                   null,--ln_vicod,
                   null,
                   null, --  ****aqui deben de ir los hijos ****
                   604,
                   null, --Fecha inicio
                   null,
                   0,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   0, --Es el monto del Alquiler, si es Arrendado
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null, -- Apellido del padre
                   null, -- Nombre del padre
                   null, -- Apellido de la madre
                   null, -- Nombre de la madre
                   null,
                   null,
                   null,
                   null,
                   null,
                   'P');                                        
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BJD002', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));            
        end;
        
        begin --BJD005        
         insert into BANDEJAS.BJD005
                    (BD005Pais,
                     BD005TDoc,
                     BD005NDoc,
                     BD005DCod,
                     BD005Call,
                     BD005Nro,
                     BD005Apar,
                     BD005Ciud,
                     BD005PaiD,
                     BD005CPos,
                     BD005CCor,
                     BD005CDep,
                     BD005Ciudp,
                     BD005Axn1,
                     BD005Deptp,
                     BD005Est,
                     BD005Ref1,
                     BD005Ref2,
                     BD005APo,
                     BD005Upo
                     )
                  values
                    (604,
                     21,
                     i.jaqz311numdoc,
                     1,--tipo de direccion 1 legal 3 es negocio analizar si se va a llenar los 2??
                     null,
                     null,
                     null,
                     null,
                     604,
                     null,
                     null,
                     i.jaqz311dirdep,
                     i.jaqz311dirpro,
                     i.jaqz311dirdis,
                     null,
                     'P',
                     null,
                     null,
                     null,
                     null);                
            
          exception
            when others then             
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJD005', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
          end;
        /*Hlaqui 26/06/2017 - Se agrega Logica para la direccion del cliente*/  
        --fpinto se comenta condicion y se deja solo insert de cursor c1 16/10/2024
        /*If i.jaqz341numdoc is not null then
          --Se aplica cuando se ingresaron los datos a traves del dataEntry y 
          --se procede a obtener los datos de la JAQZ341d (Direcciones del Cliente)
            for p in c2(i.jaqz341numdoc) loop               
              begin --BNGC13                
                insert into BANDEJAS.BNGC13
                (BNGC13PAIS, --1
                 BNGC13TDOC, --2
                 BNGC13NDOC, --3
                 DOCOD,       --4 
                 BNGC13CORR, --5
                 BNGC13PDOC, --6
                 BNGC12VIVC, --7
                 BNGC01ID, --8
                 BNGC02ID, --9
                 BNGC03ID, --10
                 BNGC04ID, --11
                 BNGC05ID, --12
                 BNGC06ID, --13
                 BNGC13DSC1, --14
                 BNGC13DSC2, --15
                 BNGC13DSC3, --16
                 BNGC13DSC4, --17
                 BNGC13DSC5, --18
                 BNGC13DSC6, --19
                 BNGC13UGEO, --20
                 BNGC13DPTO, --21
                 BNGC13PROV, --22
                 BNGC13DIST, --23
                 BNGC13CNEG, --24
                 BNGC13REF, --25
                 BNGC13REF1, --26
                 BNGC13DIR, --27
                 BNGC13RDES, --28
                 BNGC13ARR, --29
                 BNGC13ATEL,--30
                 BNGC13FHAB,--31
                 BNGC13DEST,--32
                 BNGC13EST,--33
                 BNGC13FDIR,--34
                 BNGC13USER,--35
                 BNGC13MEST)--36
              values
                (604, --1
                 21, --2
                 p."JAQZ341dNUMDOC",  --3
                 p."JAQZ341dDOCOD",  --4
                 1, --5
                 p."JAQZ341dPDOC",-- pais de direccion6
                 p."JAQZ341dVIVC", -- codigo tipo de vivienda 7
                 p."JAQZ341dID01", -- codigo tipo de via   8
                 p."JAQZ341dID02", -- codigo via          9        
                 p."JAQZ341dID03", -- codigo detalle de via10
                 p."JAQZ341dID04",--0,11
                 p."JAQZ341dID05",--0,12
                 p."JAQZ341dID06",--0,  13             
                 substr(p."JAQZ341dDSC1",1,30), -- descripcion de via  14
                 substr(p."JAQZ341dDSC2",1,30), --15
                 substr(p."JAQZ341dDSC3",1,30), --16
                 substr(p."JAQZ341dDSC4",1,30), --17
                 substr(p."JAQZ341dDSC5",1,30), --18
                 substr(p."JAQZ341dDSC6",1,30), --19
                 lpad(trim(p."JAQZ341dUGEO"),6,'0'), --20 - Ubigeo
                 p."JAQZ341dDPTO", --21  - Departamento
                 p."JAQZ341dPROV", --22  - Provincia
                 p."JAQZ341dDIST", --23  - Distrito
                 p."JAQZ341dCNEG", --24
                 null, --25
                 substr(p."JAQZ341dREF1",1,200), -- referencia26
                 substr(p."JAQZ341dDIR",1,140),--null, --27
                 ld_fecha,--null, --28
                 null, --29
                 null, --30
                 null, --31
                 2, --32
                 'H', --33
                 null, --34
                 null, --35
                 'P'--36
                 ); 
              exception
                when others then
                select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
                lc_error := sqlerrm;
                insert into jaqz311a
                  (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
                values
                  (ln_nroerr, 'BNGC13', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
              end;  
              --Migracion de telefonos del cliente
              If p."JAQZ341dNUMDOC" is not null then
                begin --BJR005
                 insert  /*+ append *//* into BANDEJAS.BJR005
                    (BR005Pais,
                     BR005TDoc,
                     BR005NDoc,
                     BR005DCod,
                     BR005DOrd,
                     BR005Telf,
                     BR005Tlex,
                     BR005Fax,
                     BR005Est
                     )
                  values
                    (604,
                     21,
                     p."JAQZ341dNUMDOC",
                     p."JAQZ341dDOCOD",--tipo de direccion 1 legal 3 es negocio analizar si se va a llenar los 2??
                     1,
                     p."JAQZ341dTELF",
                     p."JAQZ341dTLEX",
                     p."JAQZ341dFAX",
                     'P'
                     );               
                exception
                  when others then
                  select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
                  lc_error := sqlerrm;
                  insert into jaqz311a
                    (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
                  values
                    (ln_nroerr, 'BNGC13', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
                end;  
              end If;
            End Loop;
        else*/  --fpinto se comenta 16/10/2024          
            begin --BNGC13
              insert into BANDEJAS.BNGC13
              (BNGC13PAIS, --1
               BNGC13TDOC, --2
               BNGC13NDOC, --3
               DOCOD,       --4 
               BNGC13CORR, --5
               BNGC13PDOC, --6
               BNGC12VIVC, --7
               BNGC01ID, --8
               BNGC02ID, --9
               BNGC03ID, --10
               BNGC04ID, --11
               BNGC05ID, --12
               BNGC06ID, --13
               BNGC13DSC1, --14
               BNGC13DSC2, --15
               BNGC13DSC3, --16
               BNGC13DSC4, --17
               BNGC13DSC5, --18
               BNGC13DSC6, --19
               BNGC13UGEO, --20
               BNGC13DPTO, --21
               BNGC13PROV, --22
               BNGC13DIST, --23
               BNGC13CNEG, --24
               BNGC13REF, --25
               BNGC13REF1, --26
               BNGC13DIR, --27
               BNGC13RDES, --28
               BNGC13ARR, --29
               BNGC13ATEL,--30
               BNGC13FHAB,--31
               BNGC13DEST,--32
               BNGC13EST,--33
               BNGC13FDIR,--34
               BNGC13USER,--35
               BNGC13MEST)--36
            values
              (604, --1
               21, --2
               i.jaqz311numdoc,  --3
               1,  --4
               1, --5
               604,-- pais de direccion6
               null, -- codigo tipo de vivienda 7
               19, -- codigo tipo de via   8
               null, -- codigo via          9        
               null, -- codigo detalle de via10
               null,--0,11
               null,--0,12
               null,--0,  13             
               substr(i.jaqz311dirdes,1,30), -- descripcion de via  14
               null, --15
               null, --16
               null, --17
               null, --18
               null, --19
               lpad(trim(i.jaqz311dirdis),6,'0'), --20 - Ubigeo
               i.jaqz311dirdep, --21  - Departamento
               i.jaqz311dirpro, --22  - Provincia
               i.jaqz311dirdis, --23  - Distrito
               null, --24
               null, --25
               substr(' / ' || i.jaqz311dirdes,1,200), -- referencia26
               substr(i.jaqz311dirdes,1,140),--null, --27
               ld_fecha,--null, --28
               null, --29
               null, --30
               null, --31
               2, --32
               'H', --33
               null, --34
               null, --35
               'P'); --36
            exception
              when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BNGC13', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
            end;
            
        --end If; --fpinto se comenta 16/10/2024
        /*Hlaqui 26/06/2017 - Se agrega conyuge*/
        --fpinto se comenta condicion 16/10/2024
        /*If trim(i.jaqz341nudoco) is not null then
           begin --BJR002
                insert /*+ append *//* into BANDEJAS.BJR002
                  (BR002Pais,
                   BR002TDoc,
                   BR002NDoc,
                   BR002CCyg,
                   BR002PPais,
                   BR002PTdoc,
                   BR002PNDoc,
                   BR002Prpat,
                   BR002Est,
                   BR002CORR)
                values
                  (604,
                   21,
                   i.jaqz311numdoc,
                   '66',-- case when i.jaqz341estciv = '1' then '66' else '91' end
                   604,
                   21,
                   i.jaqz341nudoco,                          
                   null,
                   'P',
                   0);
            exception
              when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BJR002', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
            end;  
        end if;*/
        
        /*Hlaqui 31/05/2017 - Se agrega Logica para la actividad y Tipo de Actividad*/
        --fpinto se comenta condicion 16/10/2024
        /*If i.jaqz341numdoc is not null then
          If i.jaqz341cliocu = 1 then --Si es EMPLEADO         
            begin --BNGC60
                insert into bandejas.BNGC60
                (BNGC60PAIS,
                 BNGC60TDOC,
                 BNGC60NDOC,
                 BNGC60CORR,
                 BNGC60VCOD,
                 BNGC60OCUP,
                 BNGC60RUTE,
                 BNGC60RZSO,
                 BNGC60RUTP,
                 BNGC60ERUT,
                 BNGC60FINE,
                 BNGC60FINI,
                 BNGC60NOME,
                 BNGC60UBIC,
                 BNGC60TIPA,
                 BNGC60ACTE,
                 BNGC60EST)
              values
                (604,
                 21,
                 i.jaqz311numdoc,
                 0, --Correlativo 0 Indica Actividad Laboral Principal
                 i.jaqz341clicar, --i."Vcod",--null,
                 i.jaqz341cliocu, --i."Ocud",--por defecto 4 cuando no tenga
                 null, --i."RuTe",
                 null, --i."RzSo",
                 null, --i."RuTp",
                 null, --i."ErUt",
                 null, --i."Fine",
                 null, --i."Fini",
                 null, --i."Nome",
                 null, --i."Ubic",
                 i.jaqz341tipact,--ln_actcod3,
                 i.jaqz341acteco,--ln_actcod1,
                 'P');
            exception
              when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BNGC60', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
            end;
          Else --Si NO es EMPLEADO
            begin --BNGC60
                insert into bandejas.BNGC60
                (BNGC60PAIS,
                 BNGC60TDOC,
                 BNGC60NDOC,
                 BNGC60CORR,
                 BNGC60VCOD,
                 BNGC60OCUP,
                 BNGC60RUTE,
                 BNGC60RZSO,
                 BNGC60RUTP,
                 BNGC60ERUT,
                 BNGC60FINE,
                 BNGC60FINI,
                 BNGC60NOME,
                 BNGC60UBIC,
                 BNGC60TIPA,
                 BNGC60ACTE,
                 BNGC60EST)
              values
                (604,
                 21,
                 i.jaqz311numdoc,
                 0, --Correlativo 0 Indica Actividad Laboral Principal
                 null, --i."Vcod",--null,
                 i.jaqz341cliocu, --i."Ocud",--por defecto 4 cuando no tenga
                 null, --i."RuTe",
                 null, --i."RzSo",
                 null, --i."RuTp",
                 null, --i."ErUt",
                 null, --i."Fine",
                 null, --i."Fini",
                 i.jaqz341nomest, --i."Nome",
                 i.jaqz341ubiest, --i."Ubic",
                 i.jaqz341tipact,--ln_actcod3,
                 i.jaqz341acteco,--ln_actcod1,
                 'P');
            exception
              when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BNGC60', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
            end;  
          End If;
        end If;*/
                               
        /*Hlaqui 22/05/2017: Se agrega logica para el Lugar de Nacimiento*/
        begin --BNGC11
               insert into bandejas.BNGC11
              (BNGC11PAIS,
               BNGC11TDOC,
               BNGC11NDOC,
               BNGC11COND,
               BNGC11NREG,
               BNGC11EST,
               BNGC11ACAS,
               BNGC11DPTO,
               BNGC11PROV,
               BNGC11DIST,
               BNGC11UGEO,
               BNGC11NEST,
               BNGC11CONP,
               BNGC11COTD,
               BNGC11CO1N,
               BNGC11AUX,     ----BUSCAR DE DONDE SE JALA CAMPO SIGLAS DE JURIDICAS
               BNGC11CAPS,
               BNGC11TPA2,
               BNGC11ACT2,
               BNGC11TXT1, -- sujeto obligado
               BNGC11TXT2,
               BNGC11CMB1,
               BNGC11CMB2,
               BNGC11DAT1,
               BNGC11DAT2,
               BNGC11NUM1,-- actividad sujeto obligado
               BNGC11NUM2
               )
            values
              (604,
               21,
               i.jaqz311numdoc,
               null,
               null,
               'P',
               null,
               i.jaqz311ubidep,
               i.jaqz311ubipro,
               i.jaqz311ubidis,                      
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               'N',
               null,
               null,
               null,
               null,
               null,
               null,
               null                       
               );
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BNGC11', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
        end;
        /*Hlaqui 22/05/2017: Fin*/
        
        begin --JAQZ311
              update jaqz311 a
              set a.jaqz311fgcli = 1
              Where a.jaqz311numdoc = i.jaqz311numdoc;
        exception
          when others then            
            select nvl(max(JAQZ311aNro),0) + 1 into ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'JAQZ311', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                 
        end;
        
      End If;          
      End Loop;  
      commit; 
      
      -- Generamos el registro de las personas en BANTOTAL
      begin
        bandejas.mig_personas_datos(1000);
        bandejas.mig_personas_domicilios(1000);
      end;   
      
end sp_procesar_migracion_personas;

Procedure sp_procesar_migracion_cuentas is
  cursor c1 is
  --Hlaqui 12/12/2022 - Se agrega indicador de SEGCOD (Segmento Dependiente, Independiente,Otros)
  select a.*, d.segcod from jaqz311 a 
  left outer join FSD002 b on b.pfpais=604 and b.pftdoc=21 and rpad(trim(a.jaqz311numdoc),12,' ') = b.pfndoc
  left outer join FSE002 c on b.pfpais = c.pfxpais and b.pftdoc = c.pfxtdoc and  b.pfndoc = c.pfxndoc
  left outer join SNGC07 d on d.SNGC07cod = c.ocucod
  where a.jaqz311fgcta = 0;  
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_indexi number := 0;
  ld_fecha         date;
  ln_nroerr number := 0;
  lc_nomcli  varchar2(400);

begin
   --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;        

      --Se eliminan los registros de las bandejas.
      begin
        DELETE FROM bandejas.bjd008;
        DELETE FROM bandejas.bjr008;
        DELETE FROM bandejas.bjx008;      
        DELETE FROM bandejas.bje108; 

        DELETE FROM bandejas.bjd006;
        DELETE FROM bandejas.bjr006;
        DELETE FROM bandejas.bngc13;        
        commit;
      exception
        when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BANDEJAS-CUENTAS', 'DELETE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
      End;

      --Se recorre la tabla JAQZ311 cuto estado sea 0         
      for i in c1 loop   
      --Se validan cada persona antes de registrar en bandejas.     
      ln_indexi:= pq_dinero_electronico.fn_valida_cuenta(p_n_pais   => 604,
                                                              p_n_tipo   => 21,
                                                              p_c_numero => i.jaqz311numdoc
                                                              );                                                                                                                                        
      If ln_indexi <> 1 then     
                                                                              
        --ln_cuenta := ln_cuenta + 1;      
        If i.jaqz311apepat is null then
           lc_nomcli := trim(i.jaqz311prinom);
        Else
           lc_nomcli := trim(i.jaqz311apepat) || ' ' || trim(i.jaqz311apemat) || ', ' || trim(i.jaqz311prinom) || ' ' || trim(i.jaqz311segnom);
        End if;
          
        begin --BNJTI1
          select ngnum + 1 into ln_cuenta 
          from fsn999 
          where pgcod=1 and ngsuc=11 and ngtipo=3;
          
          update fsn999
          set ngnum = ngnum + 1
          where pgcod=1 and ngsuc=11 and ngtipo=3;
       
        exception
          when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'CORRELATIVO CUENTA', 'UPDATE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
        end;
                              
        begin --BJD008
         insert /*+ append */ into bandejas.BJD008
          (BD008ECod,
           BD008NCta,
           BD008CNom,
           BD008Resi,
           BD008CCla, 
           BD008FAlt,
           BD008RCor,
           BD008SCod,
           BD008IFin,
           BD008Empl,
           BD008Prov,
           BD008SegM,
           BE008Suc,
           BE008FvClf,
           BD008Est,
           BD008Ctnro)
        values
          (1,
           ln_cuenta,           
           substr(lc_nomcli,1,35),
           'S', --Residencia Se cambia de N a S
           1, --no es obligatorio, y es un GAP
           ld_fecha,
           'S',
           1,
           'N',
           'N',
           'N',
           nvl(i.segcod, 3), --Hlaqui 12/12/2022 - Se agrega segmento
           904,
           ADD_MONTHS(ld_fecha, 120),--DLYA asigna en programa de carga una fecha valida.
           'P',
           99
           );                          
          
        exception          
           when others then
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJD008', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                               
        end;
                        
        begin --BJD006
          insert /*+ append */ into bandejas.BJD006
            (BD006ECod,
             BD006NCta,
             BD006DCod,
             BD006Call,
             BD006Nro,
             BD006Apar,
             BD006Ciud, -- codigo de localidad
             BD006Pais,
             BD006CPos,
             BD006CCor,
             BD006Sucu,
             BD006CDep, -- coidgo de departamento
             BD006Dept,
             BD006Est,
             BD006Ref1,
             BD006Ref2,
             BD006APo,
             BD006Upo)
          values
            (1,
             ln_cuenta,
             1, --Tipo de domicilio: LEGAL
             '',
             '',
             '',
             i.jaqz311dirpro, --lc_desdis,
             604,
             null,
             null,
             null,
             i.jaqz311dirdep,
             null,
             'P',
             substr(i.jaqz311dirdes,1,35),
             null,
             null,
             null);
             
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BJD006', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));            
        end;
     
        begin --BNGC13
            insert into bandejas.BNGC13
              (BNGC13PAIS,
               BNGC13TDOC,
               BNGC13NDOC,
               DOCOD,
               BNGC13CORR,
               BNGC13PDOC,
               BNGC12VIVC,
               BNGC01ID,
               BNGC02ID,
               BNGC03ID,
               BNGC04ID,
               BNGC05ID,
               BNGC06ID,
               BNGC13DSC1,
               BNGC13DSC2,
               BNGC13DSC3,
               BNGC13DSC4,
               BNGC13DSC5,
               BNGC13DSC6,
               BNGC13UGEO,
               BNGC13DPTO,
               BNGC13PROV,
               BNGC13DIST,
               BNGC13CNEG,
               BNGC13REF,
               BNGC13REF1,
               BNGC13DIR,
               BNGC13RDES,
               BNGC13ARR,
               BNGC13ATEL,
               BNGC13FHAB,
               BNGC13DEST,
               BNGC13EST,
               BNGC13FDIR,
               BNGC13USER,
               BNGC13MEST)
            values
              (0,
               0,
               ln_cuenta,
               1,
               1,
               604, -- pais de direccion
               null, -- codigo tipo de vivienda 
               19, -- codigo tipo de via
               null, -- codigo via
               null, -- codigo detalle de via 
               null,
               null,
               null,
               substr(i.jaqz311dirdes, 1, 30), -- descripcion de via 
               null,
               null,
               null,
               null,
               null,
               lpad(trim(i.jaqz311dirdis),6,'0'), --20 - Ubigeo
               i.jaqz311dirdep, --21  - Departamento
               i.jaqz311dirpro, --22  - Provincia
               i.jaqz311dirdis, --23  - Distrito
               null,
               null,
               substr(null || ' / ' || i.jaqz311dirdes, 1, 200), -- referencia
               substr(i.jaqz311dirdes, 1, 140), --null,-- direccion concatenada
               ld_fecha,
               null,
               null,
               null,
               2,
               'H',
               null,
               null,
               'P');
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BNGC13', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
        end;
        
        begin --BJE108
           insert into bandejas.BJE108
            (BE108Cod,
             BE108Cta,
             BE108Fch,
             BE108Hora,
             BE108Usu,
             BE108Wrk,
             BE108Hab,
             BE108Est)
           values
            (1,
             ln_cuenta,
             ld_fecha,--to_date(to_char(i."Fch",'dd/mm/rrrr'),'dd/mm/rrrr'),
             TO_CHAR(sysdate, 'HH:MI:SS'),--to_char(i."Hora",'hh24:mi:ss'),
             'BANTOTAL',
             null,
             'S',
             'P'); 
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BJE108', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
        end;
        
        begin --BJR008
            insert into bandejas.BJR008
              (BR008ECod,
               BR008NCta,
               BR008Pais,
               BR008TDoc,
               BR008NDoc,
               BR008TCod,
               BR008TFir,
               BR008Est)
            values
              (1,
               ln_cuenta,
               604,
               21,
               i.jaqz311numdoc,
               1,--1,
               'T',
               'P'); 
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BJR008', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
        end;
        
        
        begin --JAQZ311
              update jaqz311 a
              set a.jaqz311fgcta = 1
              Where a.jaqz311numdoc = i.jaqz311numdoc;
        exception
          when others then            
            select nvl(max(JAQZ311aNro),0) + 1 into ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'JAQZ311', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                 
        end;        
      End If;          
      End Loop;  
      commit; 
      
      -- Generamos el registro de las cuentas en BANTOTAL
      begin
        bandejas.mig_cuentas_datos(1000);
        bandejas.mig_cuentas_domicilios(1000);
      end;   
      
end sp_procesar_migracion_cuentas;
  
Procedure sp_crear_cuenta_integrantes (p_n_NumCorr number) is
  cursor c1 is
  --HLAQUI 26/06/2017 - Se agrega logica para que las cuentas se creen tomando la direccion del cliente de la SNGC13
  select a.jaqz311tfir, a.jaqz311numdoc, b.*, d.segcod, e.* from jaqz311 a
  left outer join FSD002 b on b.pfpais=604 and b.pftdoc=21 and rpad(trim(a.jaqz311numdoc),12,' ') = b.pfndoc
  left outer join FSE002 c on b.pfpais = c.pfxpais and b.pftdoc = c.pfxtdoc and  b.pfndoc = c.pfxndoc
  left outer join SNGC07 d on d.SNGC07cod = c.ocucod
  left outer join sngc13 e on e.sngc13pais=604 and e.sngc13tdoc=b.pftdoc and e.sngc13ndoc= b.pfndoc  and e.docod= 1 and e.sngc13est='H' and e.sngc13pais <>0  
  where a.jaqz311fgcta = 0 and a.jaqz311nro=p_n_NumCorr; 
  
  /*
  select * from jaqz311 a 
  left outer join jaqz341 b on trim(a.jaqz311numdoc) = trim(b.JAQZ341NUMDOC) --HLAQUI 31/05/2017
  left outer join SNGC07 c on SNGC07cod = jaqz341cliocu
  where a.jaqz311fgcta = 0 and a.jaqz311nro=p_n_NumCorr; 
  */
  
  cursor c2(cp_numdoc in varchar2) is
  select * from sngc13 b 
  where b.sngc13pais=604 and b.sngc13tdoc=21 and sngc13ndoc=rpad(trim(cp_numdoc),12,' ') and b.sngc13est='H' and b.sngc13pais <>0;
  /*select * from jaqz341d a 
  where a."JAQZ341dNUMDOC" = cp_numdoc;-- and a."JAQZ341dDOCOD" = 1; --HLAQUI 31/05/2017
   */
   
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_indexi number := 0;
  ld_fecha         date;
  ln_nroerr number := 0;
  lc_nomcli  varchar2(400);

begin
   --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;        

      --Se eliminan los registros de las bandejas.
      begin        
        
        DELETE FROM bandejas.bjd008;
        DELETE FROM bandejas.bjr008;
        DELETE FROM bandejas.bjx008;      
        DELETE FROM bandejas.bje108; 

        DELETE FROM bandejas.bjd006;
        DELETE FROM bandejas.bjr006;
        DELETE FROM bandejas.bngc13;
        
        commit;
      exception
        when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BANDEJAS-CUENTAS', 'DELETE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
      End;
      --Se obtiene el Nro de Cuenta - El siguiente Valor
       begin --BNJTI1
          select ngnum + 1 into ln_cuenta 
          from fsn999 
          where pgcod=1 and ngsuc=11 and ngtipo=3;
            
          update fsn999
          set ngnum = ngnum + 1
          where pgcod=1 and ngsuc=11 and ngtipo=3;
         
        exception
          when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'CORRELATIVO CUENTA', 'UPDATE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
        end;
        
      --Se recorre la tabla JAQZ311 cuto estado sea 0         
      for i in c1 loop         
        If i.pfape1 is null then
           lc_nomcli := trim(i.pfnom1);
        Else
           lc_nomcli := trim(i.pfape1) || ' ' || trim(i.pfape2) || ', ' || trim(i.pfnom1) || ' ' || trim(i.pfnom2);
        End if;
            
       
                                                                        
        If i.jaqz311tfir='T'then --Titular de la cuenta
          begin --BJD008
           insert /*+ append */ into bandejas.BJD008
            (BD008ECod,
             BD008NCta,
             BD008CNom,
             BD008Resi,
             BD008CCla, 
             BD008FAlt,
             BD008RCor,
             BD008SCod,
             BD008IFin,
             BD008Empl,
             BD008Prov,
             BD008SegM,
             BE008Suc,
             BE008FvClf,
             BD008Est,
             BD008Ctnro)
          values
            (1,
             ln_cuenta,           
             substr(lc_nomcli,1,35),
             'S', --Residencia Se cambia de N a S
             1, --no es obligatorio, y es un GAP
             ld_fecha,
             'S',
             1,
             'N',
             'N',
             'N',
             nvl(i.segcod, 3),--Se obtiene el segmento, si no se coloca el segmento Otros
             904,
             ADD_MONTHS(ld_fecha, 120),--DLYA asigna en programa de carga una fecha valida.
             'P',
             99
             );                          
            
          exception          
             when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BJD008', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                               
          end;
                          
          begin --BJD006
            insert /*+ append */ into bandejas.BJD006
              (BD006ECod,
               BD006NCta,
               BD006DCod,
               BD006Call,
               BD006Nro,
               BD006Apar,
               BD006Ciud, -- codigo de localidad
               BD006Pais,
               BD006CPos,
               BD006CCor,
               BD006Sucu,
               BD006CDep, -- coidgo de departamento
               BD006Dept,
               BD006Est,
               BD006Ref1,
               BD006Ref2,
               BD006APo,
               BD006Upo)
            values
              (1,
               ln_cuenta,
               1, --Tipo de domicilio: LEGAL
               '',
               '',
               '',
               i.sngc13prov, --lc_desdis,
               604,
               null,
               null,
               null,
               i.sngc13dpto,
               null,
               'P',
               substr(i.sngc13dir,1,35),
               null,
               null,
               null);
               
          exception
            when others then
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJD006', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));            
          end;

          /*Hlaqui 18/08/2017 - Se agrega Logica para la direccion del cliente*/            
          --Se obtienen los datos de la SNGC13 para el registro de la direccion.
          for p in c2(i.jaqz311numdoc) loop         
               begin --BNGC13                
                insert into BANDEJAS.BNGC13
                (BNGC13PAIS, --1
                 BNGC13TDOC, --2
                 BNGC13NDOC, --3
                 DOCOD,       --4 
                 BNGC13CORR, --5
                 BNGC13PDOC, --6
                 BNGC12VIVC, --7
                 BNGC01ID, --8
                 BNGC02ID, --9
                 BNGC03ID, --10
                 BNGC04ID, --11
                 BNGC05ID, --12
                 BNGC06ID, --13
                 BNGC13DSC1, --14
                 BNGC13DSC2, --15
                 BNGC13DSC3, --16
                 BNGC13DSC4, --17
                 BNGC13DSC5, --18
                 BNGC13DSC6, --19
                 BNGC13UGEO, --20
                 BNGC13DPTO, --21
                 BNGC13PROV, --22
                 BNGC13DIST, --23
                 BNGC13CNEG, --24
                 BNGC13REF, --25
                 BNGC13REF1, --26
                 BNGC13DIR, --27
                 BNGC13RDES, --28
                 BNGC13ARR, --29
                 BNGC13ATEL,--30
                 BNGC13FHAB,--31
                 BNGC13DEST,--32
                 BNGC13EST,--33
                 BNGC13FDIR,--34
                 BNGC13USER,--35
                 BNGC13MEST)--36
              values
                (0, --1
                 0, --2
                 ln_cuenta,  --3
                 p.docod,  --4
                 p.sngc13corr, --5
                 p.sngc13pdoc, -- pais de direccion6
                 p.sngc12vivc, -- codigo tipo de vivienda 7
                 p.sngc01id, -- codigo tipo de via   8
                 p.sngc02id, -- codigo via          9        
                 p.sngc03id, -- codigo detalle de via10
                 p.sngc04id,--0,11
                 p.sngc05id,--0,12
                 p.sngc06id,--0,  13             
                 substr(p.sngc13dsc1,1,30), -- descripcion de via  14
                 substr(p.sngc13dsc2,1,30), --15
                 substr(p.sngc13dsc3,1,30), --16
                 substr(p.sngc13dsc4,1,30), --17
                 substr(p.sngc13dsc5,1,30), --18
                 substr(p.sngc13dsc6,1,30), --19
                 p.sngc13ugeo, --20 - Ubigeo
                 p.sngc13dpto, --21  - Departamento
                 p.sngc13prov, --22  - Provincia
                 p.sngc13dist, --23  - Distrito
                 p.sngc13cneg, --24
                 p.sngc13ref, --25
                 p.sngc13ref1, -- referencia26
                 p.sngc13dir,--null, --27
                 p.sngc13rdes ,--null, --28
                 null, --29
                 null, --30
                 null, --31
                 p.sngc13dest, --32
                 p.sngc13est, --33
                 null, --34
                 null, --35
                 'P'--36
                 ); 
              exception
                when others then
                select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
                lc_error := sqlerrm;
                insert into jaqz311a
                  (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
                values
                  (ln_nroerr, 'BNGC13', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
              end;  

           end loop;

          
          begin --BJE108
             insert into bandejas.BJE108
              (BE108Cod,
               BE108Cta,
               BE108Fch,
               BE108Hora,
               BE108Usu,
               BE108Wrk,
               BE108Hab,
               BE108Est)
             values
              (1,
               ln_cuenta,
               ld_fecha,--to_date(to_char(i."Fch",'dd/mm/rrrr'),'dd/mm/rrrr'),
               TO_CHAR(sysdate, 'HH:MI:SS'),--to_char(i."Hora",'hh24:mi:ss'),
               'BANTOTAL',
               null,
               'S',
               'P'); 
          exception
            when others then
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJE108', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
          end;
          
          begin --BJR008
              insert into bandejas.BJR008
                (BR008ECod,
                 BR008NCta,
                 BR008Pais,
                 BR008TDoc,
                 BR008NDoc,
                 BR008TCod,
                 BR008TFir,
                 BR008Est)
              values
                (1,
                 ln_cuenta,
                 604,
                 21,
                 i.jaqz311numdoc,
                 1,--1,
                 'T',
                 'P'); 
          exception
            when others then
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJR008', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
          end;
                    
          begin --JAQZ311
                update jaqz311 a
                set a.jaqz311fgcta = 1
                Where a.jaqz311numdoc = i.jaqz311numdoc;
          exception
            when others then            
              select nvl(max(JAQZ311aNro),0) + 1 into ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'JAQZ311', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                 
          end;        
        Else --Integrantes de la cuenta
          begin --BJR008
              insert into bandejas.BJR008
                (BR008ECod,
                 BR008NCta,
                 BR008Pais,
                 BR008TDoc,
                 BR008NDoc,
                 BR008TCod,
                 BR008TFir,
                 BR008Est)
              values
                (1,
                 ln_cuenta,
                 604,
                 21,
                 i.jaqz311numdoc,
                 1,--1,
                 ' ', -- 25/07/2017 - Se agrega el espacio por que de lo contrario no se muestra en el contrato de desembolso.
                 'P'); 
          exception
            when others then
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJR008', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
          end;
          begin --JAQZ311
                update jaqz311 a
                set a.jaqz311fgcta = 1
                Where a.jaqz311numdoc = i.jaqz311numdoc;
          exception
            when others then            
              select nvl(max(JAQZ311aNro),0) + 1 into ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'JAQZ311', i.jaqz311numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                 
          end;            
        End If;          
      End Loop;  
        
      commit; 
      
      -- Generamos el registro de las cuentas en BANTOTAL
      begin
        bandejas.mig_cuentas_datos(1000);
        bandejas.mig_cuentas_domicilios(1000);

      end;   
      
end sp_crear_cuenta_integrantes;

procedure sp_enviar_correo_deposito(p_n_CodDep number) is        
    p_c_msgerr varchar2(1000);
    lv_mensaje    VARCHAR2(32767);
    ll_mensaje    CLOB; 
    cursor deta is       
    select jaqz309nomage agente, jaqz309numcel celular, 
       jaqz309mondep monto, jaqz309fecdep fecha, jaqz309hordep hora,
       b.jaqz310cuenta cuenta, b.jaqz310modulo modulo, b.jaqz310moneda moneda, 
       b.jaqz310subope subope, b.jaqz310tipope tipope
    from jaqz309 a
    inner join jaqz310 b on a.jaqz309numdni = trim(b.jaqz310numdoc) 
    and a.jaqz309numcel = trim(b.jaqz310numcel)
    where jaqz309coddep = p_n_coddep;

    cursor destinatarios is
    select trim(tp1desc) tp1desc
    from fst198
    where tp1cod1 = 10801
    and Tp1corr1 = 18
    and Tp1corr2 = 102         
    and Tp1corr3 > 0;
                
    v_From        VARCHAR2(80);
    v_Subject     VARCHAR2(200);
    vhost_name    VARCHAR2(100);
    remitente     varchar2(30);
    fecha         date;
    mensaje       Varchar(1000);
    v_found number;
		
  BEGIN
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;     
    SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);
   
--    IF  UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052','DSBD1051') THEN    
--  IF UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051'/*DGLIMA*/) then      
--    if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
    if v_found =1 then
    select trim(tp1desc) tp1desc
        into remitente
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 22
         and Tp1corr2 = 3
         and tp1corr3 = 1;
           
      v_From      := remitente;
      --v_Recipient := 'hlaqui@cajaarequipa.pe';      
      v_Subject := 'DINERO ELECTRONICO - Depósito a Agente: ';
      For det in deta loop
          v_Subject := v_Subject || det.agente || ' - ' || to_char(det.fecha,'DD-MM-RRRR');
      end loop;        
      For det in deta loop        
          dbms_lob.createtemporary(ll_mensaje, TRUE);
          lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Se informa sobre el depósito realizado al Agente BIM.</p>';  
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
          
          lv_mensaje := --ll_mensaje ||                                                
          '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
          '<table cellspacing=0 cellpadding=2 width=450>'||
          '  <tr>'||
          '    <td width="200" style="border-bottom: 1px solid black;"><b>Datos:</b></td>'||
          '    <td width="200" style="border-bottom: 1px solid black;"><b></b></td>'||
          '  </tr>          ';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 

          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Agente:'||'</td>'||
          '    <td align="left">'||to_char(det.agente)||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
          
           lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Celular:'||'</td>'||
          '    <td align="left">'||to_char(det.celular)||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
          
           lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Monto:'||'</td>'||
          '    <td align="left">'||to_char(det.monto)||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
          
           lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Fecha:'||'</td>'||
          '    <td align="left">'||to_char(det.fecha,'DD-MM-RRRR')||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
          
           lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Hora:'||'</td>'||
          '    <td align="left">'||to_char(det.hora)||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
        
          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Cuenta:'||'</td>'||
          '    <td align="left">'||to_char(det.cuenta)||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
          
          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Módulo:'||'</td>'||
          '    <td align="left">'||to_char(det.modulo)||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Moneda:'||'</td>'||
          '    <td align="left">'||to_char(det.moneda)||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);          
          

          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Sub Ope:'||'</td>'||
          '    <td align="left">'||to_char(det.subope)||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
          
          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Tip Ope:'||'</td>'||
          '    <td align="left">'||to_char(det.tipope)||'</td>'||
          '  </tr>                ';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
                    
          lv_mensaje := 
          '</table>'||
          '<br/>'||
          '<br/>'||         
          '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>';                         
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                
          /*
          mensaje := 'Agente: ' || det.agente || CHR(13) ||
                    'Celular: ' || det.celular || CHR(13) ||
                    'Monto: ' || det.monto || CHR(13) ||
                    'Fecha: ' || to_char(det.fecha,'DD-MM-RRRR') || CHR(13) ||
                    'Hora: ' || det.hora || CHR(13) ||
                    'Cuenta: ' || det.cuenta || CHR(13) ||
                    'Módulo: ' || det.modulo || CHR(13) ||
                    'Moneda: ' || det.moneda || CHR(13) ||                                        
                    'Sub Ope: ' || det.subope || CHR(13) ||                                        
                    'Tip Ope: ' || det.tipope || CHR(13);                                                
                    */
      End loop;
      for dest in destinatarios loop
          begin
          sys.sp_sy_enviamail_html(pc_aquien => dest.tp1desc,
                                        pc_de => v_From,
                                        pc_motivo => v_Subject,
                                        pc_mensaje => ll_mensaje
                                        ); 
          Exception
          when others then                             
          null;
          end;                   
      end loop;     
    END IF;
  
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
END sp_enviar_correo_deposito;  
    
Function fn_valida_persona(P_N_PAIS IN NUMBER,
                           P_N_TIPO IN NUMBER, 
                           P_C_NUMERO IN VARCHAR2
                           ) return number is
  lc_numero char(12);                           
  ln_indexi number:=0;
  begin
  lc_numero := rpad(trim(P_C_NUMERO),12,' ');
    begin
      select 1 
        into ln_indexi
        from fsd001/*@produ*/ a 
       where a.pepais = P_N_PAIS
         and a.petdoc = P_N_TIPO
         and a.pendoc = lc_numero;
    Exception
    when others then
        return 0;     
    end;
  return ln_indexi;  
  Exception  
  when others then
       return 0;         
End fn_valida_persona;

Function fn_valida_cuenta(P_N_PAIS IN NUMBER,
                           P_N_TIPO IN NUMBER, 
                           P_C_NUMERO IN VARCHAR2
                           ) return number is
  ln_indexi number:=0;
  lc_numero char(12);
  begin
    lc_numero := rpad(trim(P_C_NUMERO),12,' ');
    begin
    
      select 1 into ln_indexi 
      from fsr008 c 
      where c.pendoc = lc_numero
      and c.pepais = P_N_PAIS
      and c.petdoc = P_N_TIPO          
      and c.cttfir = 'T'      
      and (select count(1) 
           from fsr008 d 
           where d.ctnro = c.ctnro) = 1;    
    Exception
    when others then
        return 0;     
    end;
  return ln_indexi;  
  Exception  
  when others then
       return 0;         
End fn_valida_cuenta;


end PQ_DINERO_ELECTRONICO;
/

