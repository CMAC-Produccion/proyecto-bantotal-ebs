CREATE OR REPLACE PACKAGE PQ_CR_BUSQUEDA_PLACA is
-- *****************************************************************
-- Nombre                     : PQ_CR_BUSQUEDA_PLACA
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 2015.11.27
-- Autor de Creación          : CMAC-MSOLARI
-- Uso                        : Extrae información para reporte del RCC
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      : 
-- Autor de Modificación      : 
-- Descripción de Modificación: 
-- 
--  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_limpiar_placas(ln_pgmod in number, ln_pgsuc in number, ln_pgmda in number, ln_pgpap in number,
                                 ln_pgcta in number, ln_pgope in number, ln_pgsbo in number, ln_pgtop in number,
                                 ln_pgcor in number, ln_pgfrm in number, ln_pgcdat in number);  
  Procedure sp_cr_buscar_coincidencias(P_NDOC  in varchar2,P_USU in varchar2, P_MAQUINA in varchar2, PTDOC in number, PPAIS in number);
  Procedure sp_cuenta_coincidencias(lc_dato in char,ln_cta2 in number,
                                      P_USU in varchar2, P_MAQUINA in varchar2);
  function fn_Marca_T( ln_mod2 in number, ln_suc2 in number, ln_mda2 in number,
                       ln_pap2 in number, ln_cta2 in number, ln_ope2 in number,
                       ln_sbo2 in number, ln_top2 in number ) return varchar2;
  function fn_Modelo_T(ln_mod2 in number, ln_suc2 in number, ln_mda2 in number,
                       ln_pap2 in number, ln_cta2 in number, ln_ope2 in number,
                       ln_sbo2 in number, ln_top2 in number ) return varchar2;
  Procedure sp_cr_borrado(P_USU in varchar2, P_MAQUINA in varchar2);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end  PQ_CR_BUSQUEDA_PLACA;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_BUSQUEDA_PLACA is
  -- *****************************************************************
-- Nombre                     : PQ_CR_BUSQUEDA_PLACA
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 2015.11.27
-- Autor de Creación          : CMAC-MSOLARI
-- Uso                        : Extrae información para reporte del RCC
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      : 
-- Autor de Modificación      : 
-- Descripción de Modificación:  
-- *****************************************************************
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  Procedure sp_cr_limpiar_placas (ln_pgmod in number,ln_pgsuc in number,ln_pgmda in number,ln_pgpap in number,
                                  ln_pgcta in number,ln_pgope in number,ln_pgsbo in number,ln_pgtop in number,
                                  ln_pgcor in number,ln_pgfrm in number,ln_pgcdat in number) is
  
   cursor cur_placa is
        select distinct j7.ppg001dato, 
                        j7.ppg001cod,
                        j7.ppg001mod,
                        j7.ppg001suc,
                        j7.ppg001mda,
                        j7.ppg001pap,
                        j7.ppg001cta,
                        j7.ppg001ope,
                        j7.ppg001sbo,
                        j7.ppg001top,
                        j7.ppg001cor,
                        j7.ppg001frm,
                        j7.ppg001cdat,
                        j7.ppg001au1,
                        j7.ppg001au2,
                        j7.ppg001au3,
                        j7.ppg001au4,
                        j7.ppg001au5,
                        j7.ppg001au6,
                        j7.ppg001au7
        from jaqy776 j7
        where j7.ppg001cod  = 1
          and j7.ppg001mod  = ln_pgmod
          and j7.ppg001suc  = ln_pgsuc
          and j7.ppg001mda  = ln_pgmda
          and j7.ppg001pap  = ln_pgpap
          and j7.ppg001cta  = ln_pgcta
          and j7.ppg001ope  = ln_pgope
          and j7.ppg001sbo  = ln_pgsbo
          and j7.ppg001top  = ln_pgtop
          and j7.ppg001cor  = ln_pgcor
          and j7.ppg001frm  = ln_pgfrm
          and j7.ppg001cdat = ln_pgcdat;
        
     lc_dato1  varchar2(50);
     lc_letra1 char(1);
     lc_letra2 char(1);
     lc_letra3 char(1);
     lc_letra4 char(1);
     lc_letra5 char(1);
     lc_letra6 char(1);
     lc_letra7 char(1);
     
     ln_Extn  number:=0;
     lc_dato  varchar2(50);
     lc_nom   varchar2(50);
     dato     varchar2(50);
     
     lc_part1 char(1);
     lc_part2 char(1);
     lc_part3 char(1); 
     lc_placa1 varchar2(25);
     lc_placa2 varchar2(25);
     lc_placaF varchar2(50);
     lc_placaI varchar2(50);
     lc_corte  varchar2(30);
     ln_long   number :=0;
     ln_longN  number :=0;
     ln_longC  number :=0;
     ln_longT  number :=0;
     ln_longF  number :=0;
   
     LN_FLAG   NUMBER(1);
     CONT      NUMBER(2);
     LC_CAD    varchar2(50);
     lc_long1  char(4);
     lc_long2  char(6);
     lc_cadena varchar2(50);
     FlgC      char(1);
     
     ln_long11 number :=0;
     ln_T      number :=0;
     LC_CAD1   varchar2(50);
     lc_NewCad varchar2(50);
     
     ln_lg     number :=0;
     ln_Total  number :=0;
     FlgLong   char(1);
     lc_Cad2   varchar2(50);
     ln_in     number :=0;
     ln_fi     number :=0;

   Begin
         FlgLong  := 'N';
         ln_longF := 1;
         ln_long11:= 1;
      
         For a in cur_placa  loop 
             lc_nom:= UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(a.ppg001dato),'.',''),'-',''),'''',''),',',''),')',''),'(',''),'=',''),'#',''),'°',''),'00',''),'º',''),'/',''),' ',''),'<',''),'{',''),'|',''),'_',''),'+',''),'¿',''),'$',''));     
                
             lc_letra1 := null;
             lc_letra2 := null;
             lc_letra3 := null;
             lc_letra4 := null;
             lc_letra5 := null;
             lc_letra6 := null;
             lc_letra7 := null;
             lc_placa1 := null;
             lc_placa2 := null;
             lc_cadena := null;
             lc_placaF := null;
             ln_longC  := 0;
             
             ln_longC := length(TRIM(lc_nom));
             If ln_longC >=6 then

             IF REGEXP_LIKE(lc_nom,'^[A-Z]+[A-Z]+[A-Z]+[A-Z]+[A-Z]+[A-Z]') THEN
                 FlgC:='S' ;
             Else
                 FlgC:='N' ; 
             End If;

             If FlgC='N' then                
              
                If ln_longC = 6 then
                   FlgLong := 'S';
                   lc_cadena := lc_nom;
                Else
                    If  ln_longC <> 0 then
                     ln_Total := round(ln_longC/6);
                     ln_in := 1;
                     ln_fi := 6;
                     
                     FOR I IN 1..ln_Total LOOP
                       lc_letra1 := null;
                       lc_letra2 := null;
                       lc_letra3 := null;
                       lc_letra4 := null;
                       lc_letra5 := null;
                       lc_letra6 := null;
                       lc_letra7 := null;
                       lc_placa1 := null;
                       lc_placa2 := null;
                       lc_cadena := null;
                       lc_placaF := null;
               
                       lc_Cad2   := SubStr(trim(lc_nom),ln_in,ln_fi);
                       lc_cadena := trim(lc_Cad2);                         
                                         
                       lc_letra1 := Substr(lc_cadena,1,1); --posición 1
                        
                        ---////////////////// Parte 1 - Placa 
                        If(lc_letra1 = 'A' or lc_letra1 = 'B' or lc_letra1 = 'C' or lc_letra1 = 'D' or lc_letra1 = 'E' or lc_letra1 = 'F' or lc_letra1 = 'P' or lc_letra1 = 'M'or lc_letra1 = 'S' or lc_letra1 = 'L' or lc_letra1 = 'T'or lc_letra1 = 'U' or lc_letra1 = 'H' or lc_letra1 = 'W'or lc_letra1 = 'X' or lc_letra1 = 'Y' or lc_letra1 = 'V'  or lc_letra1 = 'Z') THEN
                           lc_part1 := lc_letra1;
                           lc_letra2 := Substr(lc_cadena,2,1); --posición 2
                           
                           If(lc_letra2 = '0' or lc_letra2 = '1' or lc_letra2 = '2' or lc_letra2 = '3' or lc_letra2 = '4' or lc_letra2 = '5' or lc_letra2 = '6' or lc_letra2 = '7' or lc_letra2 = '8' or lc_letra2 = '9') THEN
                                lc_part2  := lc_letra2;
                                lc_letra3 := Substr(lc_cadena,3,1); --posición 3
                                
                                If(lc_letra3 = '0' or lc_letra3 = '1' or lc_letra3 = '2' or lc_letra3 = '3' or lc_letra3 = '4' or lc_letra3 = '5' or lc_letra3 = '6' or lc_letra3 = '7' or lc_letra3 = '8' or lc_letra3 = '9') THEN
                                    lc_part3  := lc_letra3;
                                    lc_placa1 := lc_part1 || lc_part2 || lc_part3 || '-' ;
                                Else
                                    lc_part3  := lc_letra3; 
                                    lc_placa1 := lc_part1 || lc_part2 || lc_part3 || '-';
                                End If;
                           Else
                                lc_part2 := lc_letra2;
                                lc_letra3 := Substr(lc_cadena,3,1); --posición 3
                                
                                If(lc_letra3 = '0' or lc_letra3 = '1' or lc_letra3 = '2' or lc_letra3 = '3' or lc_letra3 = '4' or lc_letra3 = '5' or lc_letra3 = '6' or lc_letra3 = '7' or lc_letra3 = '8' or lc_letra3 = '9') THEN
                                    lc_part3  := lc_letra3;
                                    lc_placa1 := lc_part1 || lc_part2 || '-'|| lc_part3 ;
                                Else
                                    lc_part3  := lc_letra3; 
                                    lc_placa1 := lc_part1 || lc_part2 || lc_part3 || '-';
                                End If;
                           End If;     
                            
                           lc_part1 := null;
                           lc_part2 := null;
                           lc_part3 := null;
                         
                        ---////////////////// Parte 2 - Placa 
                            lc_letra4 := Substr(lc_cadena,4,1); --posición 4                       
                            If(lc_letra4 = '0' or lc_letra4 = '1' or lc_letra4 = '2' or lc_letra4 ='3' or lc_letra4 = '4' or lc_letra4 = '5' or lc_letra4 = '6'or lc_letra4 ='7' or lc_letra4 = '8' or lc_letra4 = '9') THEN
                                lc_part1 := lc_letra4;
                                lc_letra5 := Substr(lc_cadena,5,1); --posición 5
                                            
                                If(lc_letra5 = '0' or lc_letra5 = '1' or lc_letra5 = '2' or lc_letra5 ='3' or lc_letra5 = '4' or lc_letra5 = '5' or lc_letra5 = '6'or lc_letra5 ='7' or lc_letra5 = '8' or lc_letra5 = '9') THEN
                                    lc_part2 := lc_letra5;
                                    lc_letra6 := Substr(lc_cadena,6,1);  --posición 6
                                                
                                    If(lc_letra6 = '0' or lc_letra6 = '1' or lc_letra6 = '2' or lc_letra6 ='3' or lc_letra6 = '4' or lc_letra6 = '5' or lc_letra6 = '6'or lc_letra6 ='7' or lc_letra6 = '8' or lc_letra6 = '9') THEN
                                        lc_part3 := lc_letra6;
                                        lc_placa2 := lc_part1 || lc_part2 || lc_part3;
                                    End If;
                                 End If;
                             End If;
                          End If; 
                         
                       ---////////////////// Parte 3 - Placa 
                        lc_placaF := lc_placa1 || lc_placa2;
                        ln_longF  := length(trim(lc_placaF));
                        
                        If ln_longF = 7 then
                          insert into JAQY776_A
                          ( JAQY776_ACOD,
                            JAQY776_AMOD,
                            JAQY776_ASUC,
                            JAQY776_AMDA,
                            JAQY776_APAP,
                            JAQY776_ACTA,
                            JAQY776_AOPE,
                            JAQY776_ASBO,
                            JAQY776_ATOP,
                            JAQY776_ACOR,
                            JAQY776_AFRM,
                            JAQY776_ACDAT,
                            JAQY776_ADATO,
                            JAQY776_AAU1,
                            JAQY776_AAU2,
                            JAQY776_AAU3,
                            JAQY776_AAU4,
                            JAQY776_AAU5,
                            JAQY776_AAU6,
                            JAQY776_AAU7)
                          values
                          (a.ppg001cod,
                           a.ppg001mod,
                           a.ppg001suc,
                           a.ppg001mda,
                           a.ppg001pap,
                           a.ppg001cta,
                           a.ppg001ope,
                           a.ppg001sbo,
                           a.ppg001top,
                           a.ppg001cor,
                           a.ppg001frm,
                           a.ppg001cdat,
                           lc_placaF,
                           a.ppg001au1,
                           a.ppg001au2,
                           a.ppg001au3,
                           a.ppg001au4,
                           a.ppg001au5,
                           a.ppg001au6,
                           a.ppg001au7);
                          commit;
                        End If;   
                           
                        ln_in := ln_in +6;
                        -- ln_fi := ln_fi +6;
                    End Loop; 
                    FlgLong := 'N';
                 End If;
              End If;   
                    
                   --<<paso1>>
                If FlgLong = 'S' THEN                          
                                       
                      lc_letra1 := Substr(lc_cadena,1,1); --posición 1
                      
                      ---////////////////// Parte 1 - Placa 
                      
                      If(lc_letra1 = 'A' or lc_letra1 = 'B' or lc_letra1 = 'C' or lc_letra1 = 'D' or lc_letra1 = 'E' or lc_letra1 = 'F' or lc_letra1 = 'P' or lc_letra1 = 'M'or lc_letra1 = 'S' or lc_letra1 = 'L' or lc_letra1 = 'T'or lc_letra1 = 'U' or lc_letra1 = 'H' or lc_letra1 = 'W'or lc_letra1 = 'X' or lc_letra1 = 'Y' or lc_letra1 = 'V'  or lc_letra1 = 'Z') THEN
                         lc_part1 := lc_letra1;
                         lc_letra2 := Substr(lc_cadena,2,1); --posición 2
                         
                         If(lc_letra2 = '0' or lc_letra2 = '1' or lc_letra2 = '2' or lc_letra2 = '3' or lc_letra2 = '4' or lc_letra2 = '5' or lc_letra2 = '6' or lc_letra2 = '7' or lc_letra2 = '8' or lc_letra2 = '9') THEN
                              lc_part2  := lc_letra2;
                              lc_letra3 := Substr(lc_cadena,3,1); --posición 3
                              
                              If(lc_letra3 = '0' or lc_letra3 = '1' or lc_letra3 = '2' or lc_letra3 = '3' or lc_letra3 = '4' or lc_letra3 = '5' or lc_letra3 = '6' or lc_letra3 = '7' or lc_letra3 = '8' or lc_letra3 = '9') THEN
                                  lc_part3  := lc_letra3;
                                  lc_placa1 := lc_part1 || lc_part2 || lc_part3 || '-' ;
                              Else
                                  lc_part3  := lc_letra3; 
                                  lc_placa1 := lc_part1 || lc_part2 || lc_part3 || '-';
                              End If;
                         Else
                              lc_part2 := lc_letra2;
                              lc_letra3 := Substr(lc_cadena,3,1); --posición 3
                              
                              If(lc_letra3 = '0' or lc_letra3 = '1' or lc_letra3 = '2' or lc_letra3 = '3' or lc_letra3 = '4' or lc_letra3 = '5' or lc_letra3 = '6' or lc_letra3 = '7' or lc_letra3 = '8' or lc_letra3 = '9') THEN
                                  lc_part3  := lc_letra3;
                                  lc_placa1 := lc_part1 || lc_part2 || '-'|| lc_part3 ;
                              Else
                                  lc_part3  := lc_letra3; 
                                  lc_placa1 := lc_part1 || lc_part2 || lc_part3 || '-';
                              End If;
                          End If;
                       --End If;      
                          
                       lc_part1 := null;
                       lc_part2 := null;
                       lc_part3 := null;
                       
                       ---////////////////// Parte 2 - Placa 
                       
                       lc_letra4 := Substr(lc_cadena,4,1); --posición 4                  
                            If(lc_letra4 = '0' or lc_letra4 = '1' or lc_letra4 = '2' or lc_letra4 ='3' or lc_letra4 = '4' or lc_letra4 = '5' or lc_letra4 = '6'or lc_letra4 ='7' or lc_letra4 = '8' or lc_letra4 = '9') THEN
                                lc_part1 := lc_letra4;
                                lc_letra5 := Substr(lc_cadena,5,1); --posición 5
                                          
                                If(lc_letra5 = '0' or lc_letra5 = '1' or lc_letra5 = '2' or lc_letra5 ='3' or lc_letra5 = '4' or lc_letra5 = '5' or lc_letra5 = '6'or lc_letra5 ='7' or lc_letra5 = '8' or lc_letra5 = '9') THEN
                                    lc_part2 := lc_letra5;
                                    lc_letra6 := Substr(lc_cadena,6,1);  --posición 6
                                              
                                    If(lc_letra6 = '0' or lc_letra6 = '1' or lc_letra6 = '2' or lc_letra6 ='3' or lc_letra6 = '4' or lc_letra6 = '5' or lc_letra6 = '6'or lc_letra6 ='7' or lc_letra6 = '8' or lc_letra6 = '9') THEN
                                        lc_part3 := lc_letra6;
                                        lc_placa2 := lc_part1 || lc_part2 || lc_part3;
                                    End If;
                                 End If;
                             End If;
                          --End If;
                       End If;   
                       
                      ---////////////////// Parte 3 - Placa 
                      lc_placaF := lc_placa1 || lc_placa2;
                      ln_longF  := length(trim(lc_placaF));
                        
                      If ln_longF = 7 then
                         insert into JAQY776_A
                          ( JAQY776_ACOD,
                            JAQY776_AMOD,
                            JAQY776_ASUC,
                            JAQY776_AMDA,
                            JAQY776_APAP,
                            JAQY776_ACTA,
                            JAQY776_AOPE,
                            JAQY776_ASBO,
                            JAQY776_ATOP,
                            JAQY776_ACOR,
                            JAQY776_AFRM,
                            JAQY776_ACDAT,
                            JAQY776_ADATO,
                            JAQY776_AAU1,
                            JAQY776_AAU2,
                            JAQY776_AAU3,
                            JAQY776_AAU4,
                            JAQY776_AAU5,
                            JAQY776_AAU6,
                            JAQY776_AAU7)
                          values
                          (a.ppg001cod,
                           a.ppg001mod,
                           a.ppg001suc,
                           a.ppg001mda,
                           a.ppg001pap,
                           a.ppg001cta,
                           a.ppg001ope,
                           a.ppg001sbo,
                           a.ppg001top,
                           a.ppg001cor,
                           a.ppg001frm,
                           a.ppg001cdat,
                           lc_placaF,
                           a.ppg001au1,
                           a.ppg001au2,
                           a.ppg001au3,
                           a.ppg001au4,
                           a.ppg001au5,
                           a.ppg001au6,
                           a.ppg001au7);
                        commit; 
                      End If;
                 End If;
            End If;
          End If;
      end loop;   
  end sp_cr_limpiar_placas; 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
 Procedure sp_cr_buscar_coincidencias(P_NDOC in varchar2, P_USU in varchar2, P_MAQUINA in varchar2, PTDOC in number, PPAIS in number )IS
 
        Cursor cuenta1 (PNDOC in char,PUSU in char,PMAQUINA in char,PTDOC in number, PPAIS in number)is   
   
        select pp1.jaqy776_Adato,
               pp1.jaqy776_amod,
               pp1.jaqy776_asuc,
               pp1.jaqy776_amda,
               pp1.jaqy776_apap,
               pp1.jaqy776_Acta,
               pp1.jaqy776_aope,
               pp1.jaqy776_asbo,
               pp1.jaqy776_atop,
               f8.pepais,
               f8.petdoc,
               f8.pendoc,
               fd.penom
        from fsr011 r11, jaqy776_A pp1, fsr008 f8, fsd001 fd 
        where r11.r1cta   = f8.ctnro --ln_cta
        and pp1.jaqy776_Acod = r11.r2cod
        and pp1.jaqy776_Amod = r11.r2mod
        and pp1.jaqy776_Asuc = r11.r2suc
        and pp1.jaqy776_Amda = r11.r2mda
        and pp1.jaqy776_Apap = r11.r2pap
        and pp1.jaqy776_Acta = r11.r2cta
        and pp1.jaqy776_Aope = r11.r2oper
        and pp1.jaqy776_Asbo = r11.r2sbop
        and pp1.jaqy776_Atop = r11.r2tope
        and pp1.jaqy776_Acor = 0
        and pp1.jaqy776_Afrm in (select max(jaqy776_Afrm)
                              from jaqy776_A p1 --ppg001 p1
                              where p1.jaqy776_Acod = r11.r2cod
                                and p1.jaqy776_Amod = r11.r2mod
                                and p1.jaqy776_Asuc = r11.r2suc
                                and p1.jaqy776_Amda = r11.r2mda
                                and p1.jaqy776_Apap = r11.r2pap
                                and p1.jaqy776_Acta = r11.r2cta
                                and p1.jaqy776_Aope = r11.r2oper
                                and p1.jaqy776_Asbo = r11.r2sbop
                                and p1.jaqy776_Atop = r11.r2tope )
       and fd.pepais  = f8.pepais
       and fd.petdoc  = f8.petdoc
       and fd.pendoc  = f8.pendoc
       and pp1.jaqy776_Acdat = 23 --in (23,122,124) --placa/marca/modelo
       and r11.relcod = 50
       and r11.r2mod  = 70
       and f8.pepais  = PPAIS 
       and f8.petdoc  = PTDOC 
       and f8.pendoc  = PNDOC
       and f8.ttcod   = 1
       and f8.cttfir  = 'T';
     

  lc_modelo1 varchar2(50);
  ln_cta    NUMBER(9);
  Extn      NUMBER(9);
  lc_dato   char(50);
  ln_num    number:=0;
  ln_cta1   NUMBER(9);
  lc_dato1  varchar2(50);
  lc_ndoc1  char(12);
  ln_pais1  NUMBER(3);
  ln_tdoc1  NUMBER(3);
  lc_nomb1  char(30);
  --flgP      char(1);
  ln_cta2   NUMBER(9);
  lc_ndoc2  char(12);
  ln_pais2  NUMBER(3);
  ln_tdoc2  NUMBER(3);
  lc_nomb2  char(30);
  PNDOC     char(12);
  PUSU      char(30);
  PMAQUINA  char(12);
  ln_ope2   NUMBER(9);
  ln_sbo2   NUMBER(3);
  ln_top2   NUMBER(3);
  ln_mod2   NUMBER(3);
  lc_marca2 varchar2(50);
  ln_suc2   NUMBER(3);
  ln_mda2   NUMBER(4);
  ln_pap2   NUMBER(4);
  lc_modelo2 varchar2(50);
  
  ln_ope1   NUMBER(9);
  ln_sbo1   NUMBER(3);
  ln_top1   NUMBER(3);
  ln_mod1   NUMBER(3);
  lc_marca1 varchar2(50);
  ln_suc1   NUMBER(3);
  ln_mda1   NUMBER(4);
  ln_pap1   NUMBER(4);
  
 Begin    
  Begin
  
  PNDOC    := rpad(P_NDOC,12,' ');
  PUSU     := rpad(P_USU,30,' ');
  PMAQUINA := rpad(P_MAQUINA,12,' ');
  
    For j in cuenta1 (PNDOC,PUSU,PMAQUINA, PTDOC, PPAIS)loop 
          lc_dato  := j.jaqy776_Adato; 
          ln_cta2  := j.jaqy776_Acta;
          lc_ndoc2 := j.pendoc;
          ln_pais2 := j.pepais;
          ln_tdoc2 := j.petdoc;
          lc_nomb2 := j.penom;
          ln_mod2  := j.jaqy776_amod;
          ln_suc2  := j.jaqy776_asuc;
          ln_mda2  := j.jaqy776_amda;
          ln_pap2  := j.jaqy776_apap;
          ln_ope2  := j.jaqy776_aope;
          ln_sbo2  := j.jaqy776_asbo;
          ln_top2  := j.jaqy776_atop;
          
          lc_marca2  := fn_Marca_T(ln_mod2,ln_suc2,ln_mda2,ln_pap2,ln_cta2,ln_ope2,ln_sbo2,ln_top2);
          lc_modelo2 := fn_Modelo_T(ln_mod2,ln_suc2,ln_mda2,ln_pap2,ln_cta2,ln_ope2,ln_sbo2,ln_top2);
          
          select count(*)
          into ln_num
          from jaqy776_A  
          where jaqy776_Adato = lc_dato
           and  jaqy776_Acta <> ln_cta2;
          
          If ln_num <> 0  then
             insert into JAQY777
              ( JAQY777PAI,
                JAQY777TDOC,
                JAQY777NDOC,
                JAQY777USU,
                JAQY777MAQ,
                JAQY777PLA,
                JAQY777NOM,
                JAQY777CTA,
                JAQY777MAR,
                JAQY777MOD,
                JAQY777SUC,
                /*JAQY777ANIO*/
                JAQY777OPER,
                JAQY777MODU,
                --JAQY777SUCU,
                JAQY777MDA,
                JAQY777PAP,
                JAQY777SBOP,
                JAQY777TOP )
              values
                (ln_pais2,
                 ln_tdoc2,
                 PNDOC, 
                 PUSU, 
                 PMAQUINA, 
                 lc_dato,
                 lc_nomb2,
                 ln_cta2,
                 lc_marca2,
                 lc_modelo2,
                 j.jaqy776_asuc,
                 j.jaqy776_aope,
                 j.jaqy776_amod,
                -- j.jaqy776_asuc,
                 j.jaqy776_amda,
                 j.jaqy776_apap,
                 j.jaqy776_asbo,
                 j.jaqy776_atop
                 );
              commit;
               pq_cr_busqueda_placa.sp_cuenta_coincidencias(lc_dato,ln_cta2,P_USU, P_MAQUINA);
           End If;
     End loop;  
     commit;  
   End;
End sp_cr_buscar_coincidencias;           
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 Procedure sp_cr_borrado(P_USU in varchar2, P_MAQUINA in varchar2)IS
 
  PUSU1      char(30);
  PMAQUINA1  char(12);
 begin
   begin
   
  execute immediate 'DELETE FROM JAQY777 WHERE JAQY777USU ='||''''||P_USU||''''||' AND JAQY777MAQ='||''''||P_MAQUINA||'''';
  commit;
   
   End;
End sp_cr_borrado;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_Marca_T( ln_mod2 in number, ln_suc2 in number, ln_mda2 in number,
                       ln_pap2 in number, ln_cta2 in number, ln_ope2 in number,
                       ln_sbo2 in number, ln_top2 in number ) return varchar2 is

  lc_marc2 varchar2(50);
  
 Begin
  Begin  
      select A1.ppg001dato
        into lc_marc2
      from jaqy776 A1 
      where A1.ppg001cod = 1
        and A1.ppg001mod = ln_mod2
        and A1.ppg001suc = ln_suc2
        and A1.ppg001mda = ln_mda2
        and A1.ppg001pap = ln_pap2
        and A1.ppg001cta = ln_cta2
        and A1.ppg001ope = ln_ope2
        and A1.ppg001sbo = ln_sbo2
        and A1.ppg001top = ln_top2
        and A1.ppg001cdat   = 122
        and A1.ppg001frm in (select max(ppg001frm)
                                  from jaqy776 A2 
                                where A2.ppg001cod = 1
                                  and A2.ppg001mod = ln_mod2
                                  and A2.ppg001suc = ln_suc2
                                  and A2.ppg001mda = ln_mda2
                                  and A2.ppg001pap = ln_pap2
                                  and A2.ppg001cta = ln_cta2
                                  and A2.ppg001ope = ln_ope2
                                  and A2.ppg001sbo = ln_sbo2
                                  and A2.ppg001top = ln_top2
                                  and A2.ppg001cdat =122 );
        exception
         WHEN no_data_found THEN lc_marc2 := '-';
  End;
  return lc_marc2;
  end fn_Marca_T;   
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_Modelo_T( ln_mod2 in number, ln_suc2 in number, ln_mda2 in number,
                       ln_pap2 in number, ln_cta2 in number, ln_ope2 in number,
                       ln_sbo2 in number, ln_top2 in number ) return varchar2 is

  lc_model2 varchar2(50);
  
 Begin
  Begin  
      select B1.ppg001dato
        into lc_model2
      from jaqy776 B1 
      where B1.ppg001cod = 1
        and B1.ppg001mod = ln_mod2
        and B1.ppg001suc = ln_suc2
        and B1.ppg001mda = ln_mda2
        and B1.ppg001pap = ln_pap2
        and B1.ppg001cta = ln_cta2
        and B1.ppg001ope = ln_ope2
        and B1.ppg001sbo = ln_sbo2
        and B1.ppg001top = ln_top2
        and B1.ppg001cdat = 124
        and B1.ppg001frm in (select max(ppg001frm)
                                  from jaqy776 B2 
                                where B2.ppg001cod = 1
                                  and B2.ppg001mod = ln_mod2
                                  and B2.ppg001suc = ln_suc2
                                  and B2.ppg001mda = ln_mda2
                                  and B2.ppg001pap = ln_pap2
                                  and B2.ppg001cta = ln_cta2
                                  and B2.ppg001ope = ln_ope2
                                  and B2.ppg001sbo = ln_sbo2
                                  and B2.ppg001top = ln_top2
                                  and B2.ppg001cdat = 124 );
       exception
         WHEN no_data_found THEN lc_model2 := '-';
  End;
  return lc_model2;
  end fn_Modelo_T;     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
 Procedure sp_cuenta_coincidencias(lc_dato in char,ln_cta2 in number,
                                      P_USU in varchar2, P_MAQUINA in varchar2)IS
 flgP      char(1);
 
  cursor busqueda is
  
    select distinct aux.jaqy776_Acta,
                   aux.jaqy776_Adato,
                   fr8.pendoc,
                   fr8.pepais,
                   fr8.petdoc,
                   fs1.penom,
                   aux.jaqy776_amod,
                   aux.jaqy776_asuc,
                   aux.jaqy776_amda,
                   aux.jaqy776_apap,
                   aux.jaqy776_aope,
                   aux.jaqy776_asbo,
                   aux.jaqy776_atop   

            from jaqy776_A  aux, fsr008 fr8, fsd001 fs1
            where aux.jaqy776_Adato = lc_dato
              and aux.jaqy776_Acta <>ln_cta2
              and aux.jaqy776_acdat = 23
              and fr8.ctnro  = aux.jaqy776_Acta
              and fs1.pepais = fr8.pepais
              and fs1.petdoc = fr8.petdoc
              and fs1.pendoc = fr8.pendoc
              and fr8.ttcod  = 1
              and fr8.cttfir = 'T';
  
  ln_ope2   NUMBER(9);
  ln_sbo2   NUMBER(3);
  ln_top2   NUMBER(3);
  ln_mod2   NUMBER(3);
  lc_marca1 varchar2(50);
  ln_suc2   NUMBER(3);
  ln_mda2   NUMBER(4);
  ln_pap2   NUMBER(4);
  lc_modelo1 varchar2(50);
  
  Begin    
  Begin                  
     For i in busqueda loop                          
 
          lc_marca1  := fn_Marca_T(i.jaqy776_amod,i.jaqy776_asuc,i.jaqy776_amda,i.jaqy776_apap,i.jaqy776_acta,i.jaqy776_aope,i.jaqy776_asbo,i.jaqy776_atop);
          lc_modelo1 := fn_Modelo_T(i.jaqy776_amod,i.jaqy776_asuc,i.jaqy776_amda,i.jaqy776_apap,i.jaqy776_acta,i.jaqy776_aope,i.jaqy776_asbo,i.jaqy776_atop);
          

              insert into JAQY777
              ( JAQY777PAI,
                JAQY777TDOC,
                JAQY777NDOC,
                JAQY777USU,
                JAQY777MAQ,
                JAQY777PLA,
                JAQY777NOM,
                JAQY777CTA,
                JAQY777MAR,
                JAQY777MOD,
                JAQY777SUC,
                /*JAQY777ANIO*/
                JAQY777OPER,
                JAQY777MODU,
                --JAQY777SUCU  NUMBER(3),
                JAQY777MDA,
                JAQY777PAP,
                JAQY777SBOP,
                JAQY777TOP)
              values
              (i.pepais,
               i.petdoc,
               i.pendoc,
               P_USU,
               P_MAQUINA,
               i.jaqy776_Adato,
               i.penom,
               i.jaqy776_acta,
               lc_marca1,
               lc_modelo1,
               i.jaqy776_asuc,
               i.jaqy776_aope,
               i.jaqy776_amod,
               i.jaqy776_amda,
               i.jaqy776_apap,
               i.jaqy776_asbo,
               i.jaqy776_atop);
              commit;    
          end loop;        
  end;
 end sp_cuenta_coincidencias;           
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        
end PQ_CR_BUSQUEDA_PLACA;
/

