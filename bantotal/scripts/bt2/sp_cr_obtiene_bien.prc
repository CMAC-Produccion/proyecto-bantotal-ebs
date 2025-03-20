CREATE OR REPLACE PROCEDURE SP_CR_OBTIENE_BIEN(
  -- *****************************************************************
  -- Nombre                     : sp_cr_obtiene_bien.prc
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de MODIFICACION      : 2024.07.12
  -- Autor de MODIFICACION      : SMARQUEZ
  -- Uso                        : DATOS POLIZA MULTIRIESGO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- MODIFICACION               : IMPRESION CORRECTA DE DATOS DIRECCION
  -- MODIFICACION               : 2024.07.16 SMARQUEZ CONTROL DE LOGITUD DE UBIGEO  
  -- MODIFICACION		: SMARQUEZ 2024.09.11 CONTROL DE IMPRESION SOLO GARANTIA TITULAR
  -- MODIFICACION   : SMARQUEZ 2024.11.18 ACTUALIZACION TASA
  -- *****************************************************************

                                                    EMPRESA IN NUMBER,
                                                    MODULO IN NUMBER,
                                                    SUCURSAL IN NUMBER,
                                                    MONEDA IN NUMBER,
                                                    PAPEL IN NUMBER,
                                                    CUENTA IN NUMBER,
                                                    OPERACION IN NUMBER,
                                                    SUBOPERACION IN NUMBER,
                                                    TIPOOPERACION IN NUMBER,
                                                    INSTANCIA IN NUMBER,
                                                    NROBIEN IN OUT NUMBER,
                                                    DIRECCION OUT CHAR,
                                                    DEPARTAMENTO OUT CHAR,
                                                    PROVICIA OUT CHAR,
                                                    DISTRITO OUT CHAR,
                                                    GIRO OUT CHAR,
                                                    OCUPACION OUT CHAR,
                                                    RESTRINGIDO OUT CHAR,
                                                    NROPISO OUT NUMBER,
                                                    NROSONTANO OUT NUMBER,
                                                    FABRICA OUT NUMBER,
                                                    CONTRUCCION OUT NUMBER,
                                                    USO OUT CHAR,
                                                    TIPOCONSTRUCCION OUT CHAR)
                                                    IS
long_var number;
V_OPER   NUMBER;
tipoper  char(1);
/*GIRO1 CHAR(150);
OCUPACION1 CHAR(150);
RESTRINGIDO1 CHAR(50);*/

BEGIN
  ----- tipo persona para consultar tablas de CIU
  BEgin
    select f1.petipo
      into tipoper -- F natutal J juridica
      from fsd001 f1, fsr008 f8
     where f1.pepais = f8.pepais
       and f1.petdoc = f8.petdoc
       and f1.pendoc = f8.pendoc                                  
       and f8.ctnro = CUENTA
       and f8.ttcod = 1
       and f8.cttfir ='T';
  exception
    when no_data_found then
      tipoper := 'F';
  end;
  
  begin    
    select length(t_adic.PPG008CIP) 
      into long_var
      from  sng122 w,
            ppg008 t_adic
    where W.SNG122CTA = cuenta	--17560791	0	104	
      and w.sng122oper = operacion
      AND W.SNG122INST = instancia
      and w.SNG122TOPE = 90
      and t_adic.ppg008pgc(+) = w.sng122pgc
      and t_adic.ppg008mod(+) = w.sng122mod
      and t_adic.ppg008suc(+) = w.sng122suc
      and t_adic.ppg008mda(+) = w.sng122mda
      and t_adic.ppg008pap(+) = w.sng122pap
      and t_adic.ppg008cta(+) = w.sng122cta
      and t_adic.ppg008ope(+) = w.sng122oper
      and t_adic.ppg008sbo(+) = w.sng122sbop
      and t_adic.ppg008top(+) = w.sng122tope
      and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
      and t_adic.ppg008cdat(+) = 58;
    exception
      when no_data_found then
        Begin
           select length(t_adic.PPG008CIP) 
              into long_var
              from  sng122 w,
                    ppg008 t_adic
            where W.SNG122CTA = cuenta	--17560791	0	104	
              and w.sng122oper = operacion
              AND W.SNG122INST = instancia
              and w.SNG122TOPE = 10
              and t_adic.ppg008pgc(+) = w.sng122pgc
              and t_adic.ppg008mod(+) = w.sng122mod
              and t_adic.ppg008suc(+) = w.sng122suc
              and t_adic.ppg008mda(+) = w.sng122mda
              and t_adic.ppg008pap(+) = w.sng122pap
              and t_adic.ppg008cta(+) = w.sng122cta
              and t_adic.ppg008ope(+) = w.sng122oper
              and t_adic.ppg008sbo(+) = w.sng122sbop
              and t_adic.ppg008top(+) = w.sng122tope
              and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
              and t_adic.ppg008cdat(+) = 58;
        exception
          when no_data_found then
            long_var := 0;
        end;
    end;
    
    -----------Modificaciones
    if tipoper = 'F' then
        BEgin
          select  (SELECT A1.AQPA558DGIRO FROM FST198 F1, AQPA558 A1
            WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = s.sngc60acte AND
            A1.AQPA558COD = F1.TP1IMP1 )GIRO, --ocupacion
            (SELECT A1.AQPA558ACT FROM FST198 F1, AQPA558 A1
            WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = s.sngc60acte AND
            A1.AQPA558COD = F1.TP1IMP1 )aCTIVIDAD, --Giro
             (SELECT F1.TP1DESC FROM FST198 F1, AQPA558 A1
              WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = s.sngc60acte AND
              A1.AQPA558COD = F1.TP1IMP1 )
            into GIRO, OCUPACION,RESTRINGIDO
            from fsd001 f1, fsr008 f8, sngc60 s
           where f1.pepais = f8.pepais
             and f1.petdoc = f8.petdoc
             and f1.pendoc = f8.pendoc                                  
             and f8.ctnro = CUENTA
             and f8.ttcod = 1
             and f8.cttfir ='T'
             and s.sngc60pais = f1.pepais
             and s.sngc60tdoc = f1.petdoc
             and s.sngc60ndoc = f1.pendoc;
        exception
          when no_data_found then
            GIRO:= 'SIN HOMOLOGAR';
            OCUPACION:='SIN HOMOLOGAR';
          WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
        end;      
       
        if long_var = 6 or long_var = 4  then
          begin
            select 
            t_dire.ppg001dato, -- direccion
            t_dept.depnom Dpto_1, ---junin
            t_prov.locnom Provincia_1,-- huancayo
            t_dist.fst071dsc Distrito_1, --distrito          
            t_nume.ppg003dato Nro_Piso,
            nvl(t_nume1.ppg003dato,'0') Nro_Sótano,
            t_nume2.ppg003dato A_Fabrica,
            t_nume3.ppg003dato A_Constru
            INTO DIRECCION, DEPARTAMENTO, PROVICIA, DISTRITO,/* GIRO, OCUPACION, RESTRINGIDO,*/ NROPISO, NROSONTANO, FABRICA, CONTRUCCION
            from
            sng122 w,
            ppg008 t_adic,
            fst071 t_dist,
            fst070 t_prov,
            fst068 t_dept,
            ppg001 t_dire,
            ppg003 t_nume,
            ppg003 t_nume1,
            ppg003 t_nume2,
            ppg003 t_nume3 
            where  W.SNG122CTA = CUENTA
            and w.sng122oper = OPERACION
            AND W.SNG122INST = INSTANCIA
            and w.SNG122TOPE = 90
            and t_adic.ppg008pgc(+) = w.sng122pgc
            and t_adic.ppg008mod(+) = w.sng122mod
            and t_adic.ppg008suc(+) = w.sng122suc
            and t_adic.ppg008mda(+) = w.sng122mda
            and t_adic.ppg008pap(+) = w.sng122pap
            and t_adic.ppg008cta(+) = w.sng122cta
            and t_adic.ppg008ope(+) = w.sng122oper
            and t_adic.ppg008sbo(+) = w.sng122sbop
            and t_adic.ppg008top(+) = w.sng122tope
            and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
            and t_adic.ppg008cdat(+) = 58
            and t_dept.pais(+) = 604
            and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,2) --SMA 120724
            and t_prov.pais(+) = 604
            and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,2) --SMA 120724
            and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,4)--SMA 120724
            and t_dist.fst071pai(+) = 604
            and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,2)--SMA 120724
            and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,4)--SMA 120724
            and t_dist.fst071col(+) = t_adic.ppg008cip
            and t_dire.ppg001cod(+) = w.sng122pgc
            and t_dire.ppg001mod(+) = w.sng122mod
            and t_dire.ppg001suc(+) = w.sng122suc
            and t_dire.ppg001mda(+) = w.sng122mda
            and t_dire.ppg001pap(+) = w.sng122pap
            and t_dire.ppg001cta(+) = w.sng122cta
            and t_dire.ppg001ope(+) = w.sng122oper
            and t_dire.ppg001sbo(+) = w.sng122sbop
            and t_dire.ppg001top(+) = w.sng122tope
            and t_dire.ppg001cdat(+) = 41
            and t_nume.ppg003cod(+) = w.sng122pgc
            and t_nume.ppg003mod(+) = w.sng122mod
            and t_nume.ppg003suc(+) = w.sng122suc
            and t_nume.ppg003mda(+) = w.sng122mda
            and t_nume.ppg003pap(+) = w.sng122pap
            and t_nume.ppg003cta(+) = w.sng122cta
            and t_nume.ppg003ope(+) = w.sng122oper
            and t_nume.ppg003sbo(+) = w.sng122sbop
            and t_nume.ppg003top(+) = w.sng122tope
            and t_nume.ppg003frm(+) = 0---t_cgar.ppg000frm
            and t_nume.ppg003cdat(+) = 84
            and t_nume1.ppg003cod(+) = w.sng122pgc
            and t_nume1.ppg003mod(+) = w.sng122mod
            and t_nume1.ppg003suc(+) = w.sng122suc
            and t_nume1.ppg003mda(+) = w.sng122mda
            and t_nume1.ppg003pap(+) = w.sng122pap
            and t_nume1.ppg003cta(+) = w.sng122cta
            and t_nume1.ppg003ope(+) = w.sng122oper
            and t_nume1.ppg003sbo(+) = w.sng122sbop
            and t_nume1.ppg003top(+) = w.sng122tope
            and t_nume1.ppg003frm(+) = 0---t_cgar.ppg000frm
            and t_nume1.ppg003cdat(+) = 75
            and t_nume2.ppg003cod(+) = w.sng122pgc
            and t_nume2.ppg003mod(+) = w.sng122mod
            and t_nume2.ppg003suc(+) = w.sng122suc
            and t_nume2.ppg003mda(+) = w.sng122mda
            and t_nume2.ppg003pap(+) = w.sng122pap
            and t_nume2.ppg003cta(+) = w.sng122cta
            and t_nume2.ppg003ope(+) = w.sng122oper
            and t_nume2.ppg003sbo(+) = w.sng122sbop
            and t_nume2.ppg003top(+) = w.sng122tope
            and t_nume2.ppg003frm(+) = 0--t_cgar.ppg000frm
            and t_nume2.ppg003cdat(+) = 70
            and t_nume3.ppg003cod(+) = w.sng122pgc
            and t_nume3.ppg003mod(+) = w.sng122mod
            and t_nume3.ppg003suc(+) = w.sng122suc
            and t_nume3.ppg003mda(+) = w.sng122mda
            and t_nume3.ppg003pap(+) = w.sng122pap
            and t_nume3.ppg003cta(+) = w.sng122cta
            and t_nume3.ppg003ope(+) = w.sng122oper
            and t_nume3.ppg003sbo(+) = w.sng122sbop
            and t_nume3.ppg003top(+) = w.sng122tope
            and t_nume3.ppg003frm(+) = 0--t_cgar.ppg000frm
            and t_nume3.ppg003cdat(+) = 76
            and rownum= 1
            ;
         Exception
           when no_data_found then
             Begin
                select 
                  t_dire.ppg001dato, -- direccion
                  t_dept.depnom Dpto_1, ---junin
                  t_prov.locnom Provincia_1,-- huancayo
                  t_dist.fst071dsc Distrito_1, --distrito
                  t_nume.ppg003dato Nro_Piso,
                  nvl(t_nume1.ppg003dato,'0') Nro_Sótano,
                  t_nume2.ppg003dato A_Fabrica,
                  t_nume3.ppg003dato A_Constru
                  INTO DIRECCION, DEPARTAMENTO, PROVICIA, DISTRITO, NROPISO, NROSONTANO, FABRICA, CONTRUCCION
                  from
                  sng122 w,
                  ppg008 t_adic,
                  fst071 t_dist,
                  fst070 t_prov,
                  fst068 t_dept,
                  ppg001 t_dire,
                  ppg003 t_nume,
                  ppg003 t_nume1,
                  ppg003 t_nume2,
                  ppg003 t_nume3 
                  where  W.SNG122CTA = CUENTA
                  and w.sng122oper = OPERACION
                  AND W.SNG122INST = INSTANCIA
                  and w.SNG122TOPE = 10
                  and t_adic.ppg008pgc(+) = w.sng122pgc
                  and t_adic.ppg008mod(+) = w.sng122mod
                  and t_adic.ppg008suc(+) = w.sng122suc
                  and t_adic.ppg008mda(+) = w.sng122mda
                  and t_adic.ppg008pap(+) = w.sng122pap
                  and t_adic.ppg008cta(+) = w.sng122cta
                  and t_adic.ppg008ope(+) = w.sng122oper
                  and t_adic.ppg008sbo(+) = w.sng122sbop
                  and t_adic.ppg008top(+) = w.sng122tope
                  and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
                  and t_adic.ppg008cdat(+) = 58
                  and t_dept.pais(+) = 604
                  and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,2) --SMA 120724
                  and t_prov.pais(+) = 604
                  and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,2) --SMA 120724
                  and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,4)--SMA 120724
                  and t_dist.fst071pai(+) = 604
                  and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,2)--SMA 120724
                  and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,4)--SMA 120724
                  and t_dist.fst071col(+) = t_adic.ppg008cip
                  and t_dire.ppg001cod(+) = w.sng122pgc
                  and t_dire.ppg001mod(+) = w.sng122mod
                  and t_dire.ppg001suc(+) = w.sng122suc
                  and t_dire.ppg001mda(+) = w.sng122mda
                  and t_dire.ppg001pap(+) = w.sng122pap
                  and t_dire.ppg001cta(+) = w.sng122cta
                  and t_dire.ppg001ope(+) = w.sng122oper
                  and t_dire.ppg001sbo(+) = w.sng122sbop
                  and t_dire.ppg001top(+) = w.sng122tope
                  and t_dire.ppg001cdat(+) = 41
                  and t_nume.ppg003cod(+) = w.sng122pgc
                  and t_nume.ppg003mod(+) = w.sng122mod
                  and t_nume.ppg003suc(+) = w.sng122suc
                  and t_nume.ppg003mda(+) = w.sng122mda
                  and t_nume.ppg003pap(+) = w.sng122pap
                  and t_nume.ppg003cta(+) = w.sng122cta
                  and t_nume.ppg003ope(+) = w.sng122oper
                  and t_nume.ppg003sbo(+) = w.sng122sbop
                  and t_nume.ppg003top(+) = w.sng122tope
                  and t_nume.ppg003frm(+) = 0---t_cgar.ppg000frm
                  and t_nume.ppg003cdat(+) = 84
                  and t_nume1.ppg003cod(+) = w.sng122pgc
                  and t_nume1.ppg003mod(+) = w.sng122mod
                  and t_nume1.ppg003suc(+) = w.sng122suc
                  and t_nume1.ppg003mda(+) = w.sng122mda
                  and t_nume1.ppg003pap(+) = w.sng122pap
                  and t_nume1.ppg003cta(+) = w.sng122cta
                  and t_nume1.ppg003ope(+) = w.sng122oper
                  and t_nume1.ppg003sbo(+) = w.sng122sbop
                  and t_nume1.ppg003top(+) = w.sng122tope
                  and t_nume1.ppg003frm(+) = 0---t_cgar.ppg000frm
                  and t_nume1.ppg003cdat(+) = 75
                  and t_nume2.ppg003cod(+) = w.sng122pgc
                  and t_nume2.ppg003mod(+) = w.sng122mod
                  and t_nume2.ppg003suc(+) = w.sng122suc
                  and t_nume2.ppg003mda(+) = w.sng122mda
                  and t_nume2.ppg003pap(+) = w.sng122pap
                  and t_nume2.ppg003cta(+) = w.sng122cta
                  and t_nume2.ppg003ope(+) = w.sng122oper
                  and t_nume2.ppg003sbo(+) = w.sng122sbop
                  and t_nume2.ppg003top(+) = w.sng122tope
                  and t_nume2.ppg003frm(+) = 0--t_cgar.ppg000frm
                  and t_nume2.ppg003cdat(+) = 70
                  and t_nume3.ppg003cod(+) = w.sng122pgc
                  and t_nume3.ppg003mod(+) = w.sng122mod
                  and t_nume3.ppg003suc(+) = w.sng122suc
                  and t_nume3.ppg003mda(+) = w.sng122mda
                  and t_nume3.ppg003pap(+) = w.sng122pap
                  and t_nume3.ppg003cta(+) = w.sng122cta
                  and t_nume3.ppg003ope(+) = w.sng122oper
                  and t_nume3.ppg003sbo(+) = w.sng122sbop
                  and t_nume3.ppg003top(+) = w.sng122tope
                  and t_nume3.ppg003frm(+) = 0--t_cgar.ppg000frm
                  and t_nume3.ppg003cdat(+) = 76
                  and rownum= 1
                  ;
             exception
               when no_data_found then
                   DIRECCION:= null; 
                   DEPARTAMENTO:= null; 
                   PROVICIA:= null; 
                   DISTRITO:= null; 
                   GIRO:= null; 
                   OCUPACION:= null; 
                   RESTRINGIDO:= null; 
                   NROPISO:= null; 
                   NROSONTANO:= null; 
                   FABRICA:= null; 
                   CONTRUCCION:= null;
             end;
         end;    
       else
         Begin
             select 
                t_dire.ppg001dato, -- direccion
                t_dept.depnom Dpto_1, ---junin
                t_prov.locnom Provincia_1,-- huancayo
                t_dist.fst071dsc Distrito_1, --distrito               
                t_nume.ppg003dato Nro_Piso,
                t_nume1.ppg003dato Nro_Sótano,
                t_nume2.ppg003dato A_Fabrica,
                t_nume3.ppg003dato A_Constru
                INTO DIRECCION, DEPARTAMENTO, PROVICIA, DISTRITO, NROPISO, NROSONTANO, FABRICA, CONTRUCCION
                from  sng122 w,
                      ppg008 t_adic,
                      fst071 t_dist,
                      fst070 t_prov,
                      fst068 t_dept,
                      ppg001 t_dire,                     
                      ppg003 t_nume,
                      ppg003 t_nume1,
                      ppg003 t_nume2,
                      ppg003 t_nume3 
                where  W.SNG122CTA = CUENTA
                  and w.sng122oper = OPERACION
                  AND W.SNG122INST = INSTANCIA
                  and w.SNG122TOPE = 90
                  and t_adic.ppg008pgc(+) = w.sng122pgc
                  and t_adic.ppg008mod(+) = w.sng122mod
                  and t_adic.ppg008suc(+) = w.sng122suc
                  and t_adic.ppg008mda(+) = w.sng122mda
                  and t_adic.ppg008pap(+) = w.sng122pap
                  and t_adic.ppg008cta(+) = w.sng122cta
                  and t_adic.ppg008ope(+) = w.sng122oper
                  and t_adic.ppg008sbo(+) = w.sng122sbop
                  and t_adic.ppg008top(+) = w.sng122tope
                  and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
                  and t_adic.ppg008cdat(+) = 58
                  and t_dept.pais(+) = 604
                  and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,1) --SMA 120724
                  and t_prov.pais(+) = 604
                  and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,1) --SMA 120724
                  and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,3)--SMA 120724
                  and t_dist.fst071pai(+) = 604
                  and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,1)--SMA 120724
                  and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,3)--SMA 120724
                  and t_dist.fst071col(+) = t_adic.ppg008cip
                  and t_dire.ppg001cod(+) = w.sng122pgc
                  and t_dire.ppg001mod(+) = w.sng122mod
                  and t_dire.ppg001suc(+) = w.sng122suc
                  and t_dire.ppg001mda(+) = w.sng122mda
                  and t_dire.ppg001pap(+) = w.sng122pap
                  and t_dire.ppg001cta(+) = w.sng122cta
                  and t_dire.ppg001ope(+) = w.sng122oper
                  and t_dire.ppg001sbo(+) = w.sng122sbop
                  and t_dire.ppg001top(+) = w.sng122tope
                  and t_dire.ppg001cdat(+) = 41
                  and t_nume.ppg003cod(+) = w.sng122pgc
                  and t_nume.ppg003mod(+) = w.sng122mod
                  and t_nume.ppg003suc(+) = w.sng122suc
                  and t_nume.ppg003mda(+) = w.sng122mda
                  and t_nume.ppg003pap(+) = w.sng122pap
                  and t_nume.ppg003cta(+) = w.sng122cta
                  and t_nume.ppg003ope(+) = w.sng122oper
                  and t_nume.ppg003sbo(+) = w.sng122sbop
                  and t_nume.ppg003top(+) = w.sng122tope
                  and t_nume.ppg003frm(+) = 0---t_cgar.ppg000frm
                  and t_nume.ppg003cdat(+) = 84
                  and t_nume1.ppg003cod(+) = w.sng122pgc
                  and t_nume1.ppg003mod(+) = w.sng122mod
                  and t_nume1.ppg003suc(+) = w.sng122suc
                  and t_nume1.ppg003mda(+) = w.sng122mda
                  and t_nume1.ppg003pap(+) = w.sng122pap
                  and t_nume1.ppg003cta(+) = w.sng122cta
                  and t_nume1.ppg003ope(+) = w.sng122oper
                  and t_nume1.ppg003sbo(+) = w.sng122sbop
                  and t_nume1.ppg003top(+) = w.sng122tope
                  and t_nume1.ppg003frm(+) = 0---t_cgar.ppg000frm
                  and t_nume1.ppg003cdat(+) = 75
                  and t_nume2.ppg003cod(+) = w.sng122pgc
                  and t_nume2.ppg003mod(+) = w.sng122mod
                  and t_nume2.ppg003suc(+) = w.sng122suc
                  and t_nume2.ppg003mda(+) = w.sng122mda
                  and t_nume2.ppg003pap(+) = w.sng122pap
                  and t_nume2.ppg003cta(+) = w.sng122cta
                  and t_nume2.ppg003ope(+) = w.sng122oper
                  and t_nume2.ppg003sbo(+) = w.sng122sbop
                  and t_nume2.ppg003top(+) = w.sng122tope
                  and t_nume2.ppg003frm(+) = 0--t_cgar.ppg000frm
                  and t_nume2.ppg003cdat(+) = 70
                  and t_nume3.ppg003cod(+) = w.sng122pgc
                  and t_nume3.ppg003mod(+) = w.sng122mod
                  and t_nume3.ppg003suc(+) = w.sng122suc
                  and t_nume3.ppg003mda(+) = w.sng122mda
                  and t_nume3.ppg003pap(+) = w.sng122pap
                  and t_nume3.ppg003cta(+) = w.sng122cta
                  and t_nume3.ppg003ope(+) = w.sng122oper
                  and t_nume3.ppg003sbo(+) = w.sng122sbop
                  and t_nume3.ppg003top(+) = w.sng122tope
                  and t_nume3.ppg003frm(+) = 0--t_cgar.ppg000frm
                  and t_nume3.ppg003cdat(+) = 76
                  and rownum = 1;
               Exception
                 when no_data_found then
                   begin
                     select 
                      t_dire.ppg001dato, -- direccion
                      t_dept.depnom Dpto_1, ---junin
                      t_prov.locnom Provincia_1,-- huancayo
                      t_dist.fst071dsc Distrito_1, --distrito
                      t_nume.ppg003dato Nro_Piso,
                      t_nume1.ppg003dato Nro_Sótano,
                      t_nume2.ppg003dato A_Fabrica,
                      t_nume3.ppg003dato A_Constru
                      INTO DIRECCION, DEPARTAMENTO, PROVICIA, DISTRITO, NROPISO, NROSONTANO, FABRICA, CONTRUCCION
                      from  sng122 w,
                            ppg008 t_adic,
                            fst071 t_dist,
                            fst070 t_prov,
                            fst068 t_dept,
                            ppg001 t_dire,                          
                            ppg003 t_nume,
                            ppg003 t_nume1,
                            ppg003 t_nume2,
                            ppg003 t_nume3 
                      where  W.SNG122CTA = CUENTA
                        and w.sng122oper = OPERACION
                        AND W.SNG122INST = INSTANCIA
                        and w.SNG122TOPE = 10
                        and t_adic.ppg008pgc(+) = w.sng122pgc
                        and t_adic.ppg008mod(+) = w.sng122mod
                        and t_adic.ppg008suc(+) = w.sng122suc
                        and t_adic.ppg008mda(+) = w.sng122mda
                        and t_adic.ppg008pap(+) = w.sng122pap
                        and t_adic.ppg008cta(+) = w.sng122cta
                        and t_adic.ppg008ope(+) = w.sng122oper
                        and t_adic.ppg008sbo(+) = w.sng122sbop
                        and t_adic.ppg008top(+) = w.sng122tope
                        and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
                        and t_adic.ppg008cdat(+) = 58
                        and t_dept.pais(+) = 604
                        and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,1) --SMA 120724
                        and t_prov.pais(+) = 604
                        and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,1) --SMA 120724
                        and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,3)--SMA 120724
                        and t_dist.fst071pai(+) = 604
                        and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,1)--SMA 120724
                        and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,3)--SMA 120724
                        and t_dist.fst071col(+) = t_adic.ppg008cip
                        and t_dire.ppg001cod(+) = w.sng122pgc
                        and t_dire.ppg001mod(+) = w.sng122mod
                        and t_dire.ppg001suc(+) = w.sng122suc
                        and t_dire.ppg001mda(+) = w.sng122mda
                        and t_dire.ppg001pap(+) = w.sng122pap
                        and t_dire.ppg001cta(+) = w.sng122cta
                        and t_dire.ppg001ope(+) = w.sng122oper
                        and t_dire.ppg001sbo(+) = w.sng122sbop
                        and t_dire.ppg001top(+) = w.sng122tope
                        and t_dire.ppg001cdat(+) = 41
                        and t_nume.ppg003cod(+) = w.sng122pgc
                        and t_nume.ppg003mod(+) = w.sng122mod
                        and t_nume.ppg003suc(+) = w.sng122suc
                        and t_nume.ppg003mda(+) = w.sng122mda
                        and t_nume.ppg003pap(+) = w.sng122pap
                        and t_nume.ppg003cta(+) = w.sng122cta
                        and t_nume.ppg003ope(+) = w.sng122oper
                        and t_nume.ppg003sbo(+) = w.sng122sbop
                        and t_nume.ppg003top(+) = w.sng122tope
                        and t_nume.ppg003frm(+) = 0---t_cgar.ppg000frm
                        and t_nume.ppg003cdat(+) = 84
                        and t_nume1.ppg003cod(+) = w.sng122pgc
                        and t_nume1.ppg003mod(+) = w.sng122mod
                        and t_nume1.ppg003suc(+) = w.sng122suc
                        and t_nume1.ppg003mda(+) = w.sng122mda
                        and t_nume1.ppg003pap(+) = w.sng122pap
                        and t_nume1.ppg003cta(+) = w.sng122cta
                        and t_nume1.ppg003ope(+) = w.sng122oper
                        and t_nume1.ppg003sbo(+) = w.sng122sbop
                        and t_nume1.ppg003top(+) = w.sng122tope
                        and t_nume1.ppg003frm(+) = 0---t_cgar.ppg000frm
                        and t_nume1.ppg003cdat(+) = 75
                        and t_nume2.ppg003cod(+) = w.sng122pgc
                        and t_nume2.ppg003mod(+) = w.sng122mod
                        and t_nume2.ppg003suc(+) = w.sng122suc
                        and t_nume2.ppg003mda(+) = w.sng122mda
                        and t_nume2.ppg003pap(+) = w.sng122pap
                        and t_nume2.ppg003cta(+) = w.sng122cta
                        and t_nume2.ppg003ope(+) = w.sng122oper
                        and t_nume2.ppg003sbo(+) = w.sng122sbop
                        and t_nume2.ppg003top(+) = w.sng122tope
                        and t_nume2.ppg003frm(+) = 0--t_cgar.ppg000frm
                        and t_nume2.ppg003cdat(+) = 70
                        and t_nume3.ppg003cod(+) = w.sng122pgc
                        and t_nume3.ppg003mod(+) = w.sng122mod
                        and t_nume3.ppg003suc(+) = w.sng122suc
                        and t_nume3.ppg003mda(+) = w.sng122mda
                        and t_nume3.ppg003pap(+) = w.sng122pap
                        and t_nume3.ppg003cta(+) = w.sng122cta
                        and t_nume3.ppg003ope(+) = w.sng122oper
                        and t_nume3.ppg003sbo(+) = w.sng122sbop
                        and t_nume3.ppg003top(+) = w.sng122tope
                        and t_nume3.ppg003frm(+) = 0--t_cgar.ppg000frm
                        and t_nume3.ppg003cdat(+) = 76
                        and rownum = 1;
                   exception
                      when no_data_found then
                       DIRECCION:= null; 
                       DEPARTAMENTO:= null; 
                       PROVICIA:= null; 
                       DISTRITO:= null; 
                       GIRO:= null; 
                       OCUPACION:= null; 
                       RESTRINGIDO:= null; 
                       NROPISO:= null; 
                       NROSONTANO:= null; 
                       FABRICA:= null; 
                       CONTRUCCION:= null;
                   end;
             end;    
       end if;
  else --- PEROSNA JURIDICA
       BEgin
          select  (SELECT A1.AQPA558DGIRO FROM FST198 F1, AQPA558 A1
            WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = s.expnins AND
            A1.AQPA558COD = F1.TP1IMP1 )GIRO, --ocupacion
            (SELECT A1.AQPA558ACT FROM FST198 F1, AQPA558 A1
            WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = s.expnins AND
            A1.AQPA558COD = F1.TP1IMP1 )aCTIVIDAD, --Giro
             (SELECT F1.TP1DESC FROM FST198 F1, AQPA558 A1
              WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = s.expnins AND
              A1.AQPA558COD = F1.TP1IMP1 )
            into GIRO, OCUPACION,RESTRINGIDO
            from fsd001 f1, fsr008 f8, fse001 s
           where f1.pepais = f8.pepais
             and f1.petdoc = f8.petdoc
             and f1.pendoc = f8.pendoc                                  
             and f8.ctnro = CUENTA
             and f8.ttcod = 1
             and f8.cttfir ='T'
             and s.d511pais = f1.pepais
             and s.d511tdoc = f1.petdoc
             and s.d511ndoc = f1.pendoc;
        exception
          when no_data_found then
            GIRO:= 'SIN HOMOLOGAR';
            OCUPACION:='SIN HOMOLOGAR';
          WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
        end;   
       if long_var = 6 or long_var = 4  then
        begin
          select 
          t_dire.ppg001dato, -- direccion
          t_dept.depnom Dpto_1, ---junin
          t_prov.locnom Provincia_1,-- huancayo
          t_dist.fst071dsc Distrito_1, --distrito
          t_nume.ppg003dato Nro_Piso,
          nvl(t_nume1.ppg003dato,'0') Nro_Sótano,
          t_nume2.ppg003dato A_Fabrica,
          t_nume3.ppg003dato A_Constru
          INTO DIRECCION, DEPARTAMENTO, PROVICIA, DISTRITO,  NROPISO, NROSONTANO, FABRICA, CONTRUCCION
          from
          sng122 w,
          ppg008 t_adic,
          fst071 t_dist,
          fst070 t_prov,
          fst068 t_dept,
          ppg001 t_dire,
          ppg003 t_nume,
          ppg003 t_nume1,
          ppg003 t_nume2,
          ppg003 t_nume3 
          where  W.SNG122CTA = CUENTA
          and w.sng122oper = OPERACION
          AND W.SNG122INST = INSTANCIA
          and w.SNG122TOPE = 90
          and t_adic.ppg008pgc(+) = w.sng122pgc
          and t_adic.ppg008mod(+) = w.sng122mod
          and t_adic.ppg008suc(+) = w.sng122suc
          and t_adic.ppg008mda(+) = w.sng122mda
          and t_adic.ppg008pap(+) = w.sng122pap
          and t_adic.ppg008cta(+) = w.sng122cta
          and t_adic.ppg008ope(+) = w.sng122oper
          and t_adic.ppg008sbo(+) = w.sng122sbop
          and t_adic.ppg008top(+) = w.sng122tope
          and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
          and t_adic.ppg008cdat(+) = 58
          and t_dept.pais(+) = 604
          and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,2) --SMA 120724
          and t_prov.pais(+) = 604
          and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,2) --SMA 120724
          and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,4)--SMA 120724
          and t_dist.fst071pai(+) = 604
          and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,2)--SMA 120724
          and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,4)--SMA 120724
          and t_dist.fst071col(+) = t_adic.ppg008cip
          and t_dire.ppg001cod(+) = w.sng122pgc
          and t_dire.ppg001mod(+) = w.sng122mod
          and t_dire.ppg001suc(+) = w.sng122suc
          and t_dire.ppg001mda(+) = w.sng122mda
          and t_dire.ppg001pap(+) = w.sng122pap
          and t_dire.ppg001cta(+) = w.sng122cta
          and t_dire.ppg001ope(+) = w.sng122oper
          and t_dire.ppg001sbo(+) = w.sng122sbop
          and t_dire.ppg001top(+) = w.sng122tope
          and t_dire.ppg001cdat(+) = 41
          and t_nume.ppg003cod(+) = w.sng122pgc
          and t_nume.ppg003mod(+) = w.sng122mod
          and t_nume.ppg003suc(+) = w.sng122suc
          and t_nume.ppg003mda(+) = w.sng122mda
          and t_nume.ppg003pap(+) = w.sng122pap
          and t_nume.ppg003cta(+) = w.sng122cta
          and t_nume.ppg003ope(+) = w.sng122oper
          and t_nume.ppg003sbo(+) = w.sng122sbop
          and t_nume.ppg003top(+) = w.sng122tope
          and t_nume.ppg003frm(+) = 0---t_cgar.ppg000frm
          and t_nume.ppg003cdat(+) = 84
          and t_nume1.ppg003cod(+) = w.sng122pgc
          and t_nume1.ppg003mod(+) = w.sng122mod
          and t_nume1.ppg003suc(+) = w.sng122suc
          and t_nume1.ppg003mda(+) = w.sng122mda
          and t_nume1.ppg003pap(+) = w.sng122pap
          and t_nume1.ppg003cta(+) = w.sng122cta
          and t_nume1.ppg003ope(+) = w.sng122oper
          and t_nume1.ppg003sbo(+) = w.sng122sbop
          and t_nume1.ppg003top(+) = w.sng122tope
          and t_nume1.ppg003frm(+) = 0---t_cgar.ppg000frm
          and t_nume1.ppg003cdat(+) = 75
          and t_nume2.ppg003cod(+) = w.sng122pgc
          and t_nume2.ppg003mod(+) = w.sng122mod
          and t_nume2.ppg003suc(+) = w.sng122suc
          and t_nume2.ppg003mda(+) = w.sng122mda
          and t_nume2.ppg003pap(+) = w.sng122pap
          and t_nume2.ppg003cta(+) = w.sng122cta
          and t_nume2.ppg003ope(+) = w.sng122oper
          and t_nume2.ppg003sbo(+) = w.sng122sbop
          and t_nume2.ppg003top(+) = w.sng122tope
          and t_nume2.ppg003frm(+) = 0--t_cgar.ppg000frm
          and t_nume2.ppg003cdat(+) = 70
          and t_nume3.ppg003cod(+) = w.sng122pgc
          and t_nume3.ppg003mod(+) = w.sng122mod
          and t_nume3.ppg003suc(+) = w.sng122suc
          and t_nume3.ppg003mda(+) = w.sng122mda
          and t_nume3.ppg003pap(+) = w.sng122pap
          and t_nume3.ppg003cta(+) = w.sng122cta
          and t_nume3.ppg003ope(+) = w.sng122oper
          and t_nume3.ppg003sbo(+) = w.sng122sbop
          and t_nume3.ppg003top(+) = w.sng122tope
          and t_nume3.ppg003frm(+) = 0--t_cgar.ppg000frm
          and t_nume3.ppg003cdat(+) = 76
          and rownum= 1
          ;
       Exception
         when no_data_found then
           Begin
              select 
                t_dire.ppg001dato, -- direccion
                t_dept.depnom Dpto_1, ---junin
                t_prov.locnom Provincia_1,-- huancayo
                t_dist.fst071dsc Distrito_1, --distrito
                t_nume.ppg003dato Nro_Piso,
                nvl(t_nume1.ppg003dato,'0') Nro_Sótano,
                t_nume2.ppg003dato A_Fabrica,
                t_nume3.ppg003dato A_Constru
                INTO DIRECCION, DEPARTAMENTO, PROVICIA, DISTRITO, NROPISO, NROSONTANO, FABRICA, CONTRUCCION
                from
                sng122 w,
                ppg008 t_adic,
                fst071 t_dist,
                fst070 t_prov,
                fst068 t_dept,
                ppg001 t_dire,
                ppg003 t_nume,
                ppg003 t_nume1,
                ppg003 t_nume2,
                ppg003 t_nume3 
                where  W.SNG122CTA = CUENTA
                and w.sng122oper = OPERACION
                AND W.SNG122INST = INSTANCIA
                and w.SNG122TOPE = 10
                and t_adic.ppg008pgc(+) = w.sng122pgc
                and t_adic.ppg008mod(+) = w.sng122mod
                and t_adic.ppg008suc(+) = w.sng122suc
                and t_adic.ppg008mda(+) = w.sng122mda
                and t_adic.ppg008pap(+) = w.sng122pap
                and t_adic.ppg008cta(+) = w.sng122cta
                and t_adic.ppg008ope(+) = w.sng122oper
                and t_adic.ppg008sbo(+) = w.sng122sbop
                and t_adic.ppg008top(+) = w.sng122tope
                and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
                and t_adic.ppg008cdat(+) = 58
                and t_dept.pais(+) = 604
                and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,2) --SMA 120724
                and t_prov.pais(+) = 604
                and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,2) --SMA 120724
                and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,4)--SMA 120724
                and t_dist.fst071pai(+) = 604
                and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,2)--SMA 120724
                and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,4)--SMA 120724
                and t_dist.fst071col(+) = t_adic.ppg008cip
                and t_dire.ppg001cod(+) = w.sng122pgc
                and t_dire.ppg001mod(+) = w.sng122mod
                and t_dire.ppg001suc(+) = w.sng122suc
                and t_dire.ppg001mda(+) = w.sng122mda
                and t_dire.ppg001pap(+) = w.sng122pap
                and t_dire.ppg001cta(+) = w.sng122cta
                and t_dire.ppg001ope(+) = w.sng122oper
                and t_dire.ppg001sbo(+) = w.sng122sbop
                and t_dire.ppg001top(+) = w.sng122tope
                and t_dire.ppg001cdat(+) = 41
                and t_nume.ppg003cod(+) = w.sng122pgc
                and t_nume.ppg003mod(+) = w.sng122mod
                and t_nume.ppg003suc(+) = w.sng122suc
                and t_nume.ppg003mda(+) = w.sng122mda
                and t_nume.ppg003pap(+) = w.sng122pap
                and t_nume.ppg003cta(+) = w.sng122cta
                and t_nume.ppg003ope(+) = w.sng122oper
                and t_nume.ppg003sbo(+) = w.sng122sbop
                and t_nume.ppg003top(+) = w.sng122tope
                and t_nume.ppg003frm(+) = 0---t_cgar.ppg000frm
                and t_nume.ppg003cdat(+) = 84
                and t_nume1.ppg003cod(+) = w.sng122pgc
                and t_nume1.ppg003mod(+) = w.sng122mod
                and t_nume1.ppg003suc(+) = w.sng122suc
                and t_nume1.ppg003mda(+) = w.sng122mda
                and t_nume1.ppg003pap(+) = w.sng122pap
                and t_nume1.ppg003cta(+) = w.sng122cta
                and t_nume1.ppg003ope(+) = w.sng122oper
                and t_nume1.ppg003sbo(+) = w.sng122sbop
                and t_nume1.ppg003top(+) = w.sng122tope
                and t_nume1.ppg003frm(+) = 0---t_cgar.ppg000frm
                and t_nume1.ppg003cdat(+) = 75
                and t_nume2.ppg003cod(+) = w.sng122pgc
                and t_nume2.ppg003mod(+) = w.sng122mod
                and t_nume2.ppg003suc(+) = w.sng122suc
                and t_nume2.ppg003mda(+) = w.sng122mda
                and t_nume2.ppg003pap(+) = w.sng122pap
                and t_nume2.ppg003cta(+) = w.sng122cta
                and t_nume2.ppg003ope(+) = w.sng122oper
                and t_nume2.ppg003sbo(+) = w.sng122sbop
                and t_nume2.ppg003top(+) = w.sng122tope
                and t_nume2.ppg003frm(+) = 0--t_cgar.ppg000frm
                and t_nume2.ppg003cdat(+) = 70
                and t_nume3.ppg003cod(+) = w.sng122pgc
                and t_nume3.ppg003mod(+) = w.sng122mod
                and t_nume3.ppg003suc(+) = w.sng122suc
                and t_nume3.ppg003mda(+) = w.sng122mda
                and t_nume3.ppg003pap(+) = w.sng122pap
                and t_nume3.ppg003cta(+) = w.sng122cta
                and t_nume3.ppg003ope(+) = w.sng122oper
                and t_nume3.ppg003sbo(+) = w.sng122sbop
                and t_nume3.ppg003top(+) = w.sng122tope
                and t_nume3.ppg003frm(+) = 0--t_cgar.ppg000frm
                and t_nume3.ppg003cdat(+) = 76
                and rownum= 1
                ;
           exception
             when no_data_found then
                 DIRECCION:= null; 
                 DEPARTAMENTO:= null; 
                 PROVICIA:= null; 
                 DISTRITO:= null; 
                 GIRO:= null; 
                 OCUPACION:= null; 
                 RESTRINGIDO:= null; 
                 NROPISO:= null; 
                 NROSONTANO:= null; 
                 FABRICA:= null; 
                 CONTRUCCION:= null;
           end;
       end;    
     else
       Begin
           select 
              t_dire.ppg001dato, -- direccion
              t_dept.depnom Dpto_1, ---junin
              t_prov.locnom Provincia_1,-- huancayo
              t_dist.fst071dsc Distrito_1, --distrito
              t_nume.ppg003dato Nro_Piso,
              t_nume1.ppg003dato Nro_Sótano,
              t_nume2.ppg003dato A_Fabrica,
              t_nume3.ppg003dato A_Constru
              INTO DIRECCION, DEPARTAMENTO, PROVICIA, DISTRITO,  NROPISO, NROSONTANO, FABRICA, CONTRUCCION
              from  sng122 w,
                    ppg008 t_adic,
                    fst071 t_dist,
                    fst070 t_prov,
                    fst068 t_dept,
                    ppg001 t_dire,
                    ppg003 t_nume,
                    ppg003 t_nume1,
                    ppg003 t_nume2,
                    ppg003 t_nume3 
              where  W.SNG122CTA = CUENTA
                and w.sng122oper = OPERACION
                AND W.SNG122INST = INSTANCIA
                and w.SNG122TOPE = 90
                and t_adic.ppg008pgc(+) = w.sng122pgc
                and t_adic.ppg008mod(+) = w.sng122mod
                and t_adic.ppg008suc(+) = w.sng122suc
                and t_adic.ppg008mda(+) = w.sng122mda
                and t_adic.ppg008pap(+) = w.sng122pap
                and t_adic.ppg008cta(+) = w.sng122cta
                and t_adic.ppg008ope(+) = w.sng122oper
                and t_adic.ppg008sbo(+) = w.sng122sbop
                and t_adic.ppg008top(+) = w.sng122tope
                and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
                and t_adic.ppg008cdat(+) = 58
                and t_dept.pais(+) = 604
                and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,1) --SMA 120724
                and t_prov.pais(+) = 604
                and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,1) --SMA 120724
                and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,3)--SMA 120724
                and t_dist.fst071pai(+) = 604
                and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,1)--SMA 120724
                and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,3)--SMA 120724
                and t_dist.fst071col(+) = t_adic.ppg008cip
                and t_dire.ppg001cod(+) = w.sng122pgc
                and t_dire.ppg001mod(+) = w.sng122mod
                and t_dire.ppg001suc(+) = w.sng122suc
                and t_dire.ppg001mda(+) = w.sng122mda
                and t_dire.ppg001pap(+) = w.sng122pap
                and t_dire.ppg001cta(+) = w.sng122cta
                and t_dire.ppg001ope(+) = w.sng122oper
                and t_dire.ppg001sbo(+) = w.sng122sbop
                and t_dire.ppg001top(+) = w.sng122tope
                and t_dire.ppg001cdat(+) = 41
                and t_nume.ppg003cod(+) = w.sng122pgc
                and t_nume.ppg003mod(+) = w.sng122mod
                and t_nume.ppg003suc(+) = w.sng122suc
                and t_nume.ppg003mda(+) = w.sng122mda
                and t_nume.ppg003pap(+) = w.sng122pap
                and t_nume.ppg003cta(+) = w.sng122cta
                and t_nume.ppg003ope(+) = w.sng122oper
                and t_nume.ppg003sbo(+) = w.sng122sbop
                and t_nume.ppg003top(+) = w.sng122tope
                and t_nume.ppg003frm(+) = 0---t_cgar.ppg000frm
                and t_nume.ppg003cdat(+) = 84
                and t_nume1.ppg003cod(+) = w.sng122pgc
                and t_nume1.ppg003mod(+) = w.sng122mod
                and t_nume1.ppg003suc(+) = w.sng122suc
                and t_nume1.ppg003mda(+) = w.sng122mda
                and t_nume1.ppg003pap(+) = w.sng122pap
                and t_nume1.ppg003cta(+) = w.sng122cta
                and t_nume1.ppg003ope(+) = w.sng122oper
                and t_nume1.ppg003sbo(+) = w.sng122sbop
                and t_nume1.ppg003top(+) = w.sng122tope
                and t_nume1.ppg003frm(+) = 0---t_cgar.ppg000frm
                and t_nume1.ppg003cdat(+) = 75
                and t_nume2.ppg003cod(+) = w.sng122pgc
                and t_nume2.ppg003mod(+) = w.sng122mod
                and t_nume2.ppg003suc(+) = w.sng122suc
                and t_nume2.ppg003mda(+) = w.sng122mda
                and t_nume2.ppg003pap(+) = w.sng122pap
                and t_nume2.ppg003cta(+) = w.sng122cta
                and t_nume2.ppg003ope(+) = w.sng122oper
                and t_nume2.ppg003sbo(+) = w.sng122sbop
                and t_nume2.ppg003top(+) = w.sng122tope
                and t_nume2.ppg003frm(+) = 0--t_cgar.ppg000frm
                and t_nume2.ppg003cdat(+) = 70
                and t_nume3.ppg003cod(+) = w.sng122pgc
                and t_nume3.ppg003mod(+) = w.sng122mod
                and t_nume3.ppg003suc(+) = w.sng122suc
                and t_nume3.ppg003mda(+) = w.sng122mda
                and t_nume3.ppg003pap(+) = w.sng122pap
                and t_nume3.ppg003cta(+) = w.sng122cta
                and t_nume3.ppg003ope(+) = w.sng122oper
                and t_nume3.ppg003sbo(+) = w.sng122sbop
                and t_nume3.ppg003top(+) = w.sng122tope
                and t_nume3.ppg003frm(+) = 0--t_cgar.ppg000frm
                and t_nume3.ppg003cdat(+) = 76
                and rownum = 1;
             Exception
             when no_data_found then
               begin
                 select 
              t_dire.ppg001dato, -- direccion
              t_dept.depnom Dpto_1, ---junin
              t_prov.locnom Provincia_1,-- huancayo
              t_dist.fst071dsc Distrito_1, --distrito
              t_nume.ppg003dato Nro_Piso,
              t_nume1.ppg003dato Nro_Sótano,
              t_nume2.ppg003dato A_Fabrica,
              t_nume3.ppg003dato A_Constru
              INTO DIRECCION, DEPARTAMENTO, PROVICIA, DISTRITO, NROPISO, NROSONTANO, FABRICA, CONTRUCCION
              from  sng122 w,
                    ppg008 t_adic,
                    fst071 t_dist,
                    fst070 t_prov,
                    fst068 t_dept,
                    ppg001 t_dire,                   
                    ppg003 t_nume,
                    ppg003 t_nume1,
                    ppg003 t_nume2,
                    ppg003 t_nume3 
              where  W.SNG122CTA = CUENTA
                and w.sng122oper = OPERACION
                AND W.SNG122INST = INSTANCIA
                and w.SNG122TOPE = 10
                and t_adic.ppg008pgc(+) = w.sng122pgc
                and t_adic.ppg008mod(+) = w.sng122mod
                and t_adic.ppg008suc(+) = w.sng122suc
                and t_adic.ppg008mda(+) = w.sng122mda
                and t_adic.ppg008pap(+) = w.sng122pap
                and t_adic.ppg008cta(+) = w.sng122cta
                and t_adic.ppg008ope(+) = w.sng122oper
                and t_adic.ppg008sbo(+) = w.sng122sbop
                and t_adic.ppg008top(+) = w.sng122tope
                and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
                and t_adic.ppg008cdat(+) = 58
                and t_dept.pais(+) = 604
                and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,1) --SMA 120724
                and t_prov.pais(+) = 604
                and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,1) --SMA 120724
                and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,3)--SMA 120724
                and t_dist.fst071pai(+) = 604
                and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,1)--SMA 120724
                and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,3)--SMA 120724
                and t_dist.fst071col(+) = t_adic.ppg008cip
                and t_dire.ppg001cod(+) = w.sng122pgc
                and t_dire.ppg001mod(+) = w.sng122mod
                and t_dire.ppg001suc(+) = w.sng122suc
                and t_dire.ppg001mda(+) = w.sng122mda
                and t_dire.ppg001pap(+) = w.sng122pap
                and t_dire.ppg001cta(+) = w.sng122cta
                and t_dire.ppg001ope(+) = w.sng122oper
                and t_dire.ppg001sbo(+) = w.sng122sbop
                and t_dire.ppg001top(+) = w.sng122tope
                and t_dire.ppg001cdat(+) = 41                
                and t_nume.ppg003cod(+) = w.sng122pgc
                and t_nume.ppg003mod(+) = w.sng122mod
                and t_nume.ppg003suc(+) = w.sng122suc
                and t_nume.ppg003mda(+) = w.sng122mda
                and t_nume.ppg003pap(+) = w.sng122pap
                and t_nume.ppg003cta(+) = w.sng122cta
                and t_nume.ppg003ope(+) = w.sng122oper
                and t_nume.ppg003sbo(+) = w.sng122sbop
                and t_nume.ppg003top(+) = w.sng122tope
                and t_nume.ppg003frm(+) = 0---t_cgar.ppg000frm
                and t_nume.ppg003cdat(+) = 84
                and t_nume1.ppg003cod(+) = w.sng122pgc
                and t_nume1.ppg003mod(+) = w.sng122mod
                and t_nume1.ppg003suc(+) = w.sng122suc
                and t_nume1.ppg003mda(+) = w.sng122mda
                and t_nume1.ppg003pap(+) = w.sng122pap
                and t_nume1.ppg003cta(+) = w.sng122cta
                and t_nume1.ppg003ope(+) = w.sng122oper
                and t_nume1.ppg003sbo(+) = w.sng122sbop
                and t_nume1.ppg003top(+) = w.sng122tope
                and t_nume1.ppg003frm(+) = 0---t_cgar.ppg000frm
                and t_nume1.ppg003cdat(+) = 75
                and t_nume2.ppg003cod(+) = w.sng122pgc
                and t_nume2.ppg003mod(+) = w.sng122mod
                and t_nume2.ppg003suc(+) = w.sng122suc
                and t_nume2.ppg003mda(+) = w.sng122mda
                and t_nume2.ppg003pap(+) = w.sng122pap
                and t_nume2.ppg003cta(+) = w.sng122cta
                and t_nume2.ppg003ope(+) = w.sng122oper
                and t_nume2.ppg003sbo(+) = w.sng122sbop
                and t_nume2.ppg003top(+) = w.sng122tope
                and t_nume2.ppg003frm(+) = 0--t_cgar.ppg000frm
                and t_nume2.ppg003cdat(+) = 70
                and t_nume3.ppg003cod(+) = w.sng122pgc
                and t_nume3.ppg003mod(+) = w.sng122mod
                and t_nume3.ppg003suc(+) = w.sng122suc
                and t_nume3.ppg003mda(+) = w.sng122mda
                and t_nume3.ppg003pap(+) = w.sng122pap
                and t_nume3.ppg003cta(+) = w.sng122cta
                and t_nume3.ppg003ope(+) = w.sng122oper
                and t_nume3.ppg003sbo(+) = w.sng122sbop
                and t_nume3.ppg003top(+) = w.sng122tope
                and t_nume3.ppg003frm(+) = 0--t_cgar.ppg000frm
                and t_nume3.ppg003cdat(+) = 76
                and rownum = 1;
               exception
                  when no_data_found then
                   DIRECCION:= null; 
                   DEPARTAMENTO:= null; 
                   PROVICIA:= null; 
                   DISTRITO:= null; 
                   GIRO:= null; 
                   OCUPACION:= null; 
                   RESTRINGIDO:= null; 
                   NROPISO:= null; 
                   NROSONTANO:= null; 
                   FABRICA:= null; 
                   CONTRUCCION:= null;
               end;
           end;    
     end if;
   end if;

  bEGIN
    select ppg008cip INTO USO
     from ppg008 t_adic1
          where t_adic1.ppg008pgc(+) = EMPRESA
          and t_adic1.ppg008mod(+) = MODULO
          and t_adic1.ppg008suc(+) = SUCURSAL
          and t_adic1.ppg008mda(+) = MONEDA
          and t_adic1.ppg008pap(+) = PAPEL
          and t_adic1.ppg008cta(+) = CUENTA
          and t_adic1.ppg008ope(+) = OPERACION
          and t_adic1.ppg008sbo(+) = SUBOPERACION
          and t_adic1.ppg008top(+) = TIPOOPERACION  --V_OPER---
          and t_adic1.ppg008cdat(+) = 120
          and rownum = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       USO :='0';
  END;   
  bEGIN    
  select ppg008cip INTO TIPOCONSTRUCCION
   from ppg008 t_adic1
        where t_adic1.ppg008pgc(+) = EMPRESA
        and t_adic1.ppg008mod(+) = MODULO
        and t_adic1.ppg008suc(+) = SUCURSAL
        and t_adic1.ppg008mda(+) = MONEDA
        and t_adic1.ppg008pap(+) = PAPEL
        and t_adic1.ppg008cta(+) = CUENTA
        and t_adic1.ppg008ope(+) = OPERACION
        and t_adic1.ppg008sbo(+) = SUBOPERACION
        and t_adic1.ppg008top(+) = TIPOOPERACION
        and t_adic1.ppg008cdat(+) = 105
        and rownum = 1;    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       TIPOCONSTRUCCION :='0';
  END;   
  
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

