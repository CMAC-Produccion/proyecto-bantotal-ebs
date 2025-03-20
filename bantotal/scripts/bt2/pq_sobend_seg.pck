create or replace package PQ_SOBEND_SEG is

  -- Author  : PVARGAS
  -- Created : 20/05/2016 
  -- Purpose : Metodología indentificación de clientes expuestos a  
  --          sobre endeudamiento etapa de seguimiento
  
  -- Modificaciones:
  -- Fecha  : 09/05/2017 11:44 am
  -- Autor  : DRODRIGUEE
  -- Cambios: Requerimiento 4388  
  -- Fecha  : 05/2018
  -- Autor  : DRODRIGUEE
  -- Cambios: Requerimiento 1110
  
  Procedure sp_criterios_dep(PN_NUMCRI in number,
                            PN_VALVA1 in number,
                            PN_VALVA2 in number,
                            PN_VALVA3 in number,
                            PN_VALCRI out number
                           );
                           
  Procedure sp_criterios_ind(PN_NUMCRI in number,
                            PN_NUMSEG in number,          
                            PN_VALVA1 in number,
                            PN_VALVA2 in number,
                            PN_VALCRI out number
                           );
                           
  Procedure sp_criterios_dco(PN_NUMCRI in number,
                            PN_VALVA1 in number,
                            PN_VALVA2 in number,
                            PN_VALCRI out number
                           );
  
  Function fn_soend_act_crit(PN_CODSEG in Number,
                             PN_VALCR1 in Number,
                             PN_VALCR2 in Number,
                             PN_VALCR3 in Number,
                             PN_VALCR4 in Number
                            )
  Return Number;                         
  
  Function fn_garantia_dep(PN_PGCOD  in Number,
                          PN_CODMOD in Number,
                          PN_CODSUC in Number,
                          PN_CODMDA in Number,
                          PN_CODPAP in Number,
                          PN_CODCTA in Number,   
                          PN_CODOPE in Number,
                          PN_CODSOP in Number,
                          PN_CODTOP in Number,
                          PD_FECHA  in Date
                         ) 
  Return number;
  
  Procedure sp_datos_seguim (PD_FECHA in date);
  
  Procedure sp_datos_evaluacion(PN_NUMEVA in number,
                               PN_TIPCAM in number,             
                               PN_TOTING out number,
                               PN_VENTAS out number,
                               PN_OTRING out number,
                               PN_UTINET out number,
                               PN_RESNET out number,
                               PN_TOTPAS out number,
                               PN_TOTPAT out number,
                               PN_EXCMEN out number
                              );     
                              
  Procedure sp_proceso_sobreend (PD_FECHA in date);
  
  Procedure sp_variables_evaluacion(PD_FECHA in Date,
                                   PN_PAIS  in Number,
                                   PN_TDOC  in Number,
                                   PC_NDOC  in Char,
                                   PN_CSEG  in Number,
                                   PN_INST out Number,
                                   PN_NEVA out Number,
                                   PD_FEVA out Date,
                                   PN_SSBR out Number,
                                   PN_SDEP out Number,
                                   PN_FOIN out Number,
                                   PN_TING out Number,
                                   PN_IVEN out Number,
                                   PN_OING out Number,
                                   PN_UNET out Number,
                                   PN_RNET out Number,
                                   PN_TPAS out Number,
                                   PN_TPAT out Number,
                                   PN_CCAJ out Number,
                                   PN_EXCM out Number
                                  );  
                                  
  Function fn_monto_cuota (PN_PGCOD in Number,
                          PN_MOD   in Number,
                          PN_SUC   in Number,
                          PN_MDA   in Number,
                          PN_PAP   in Number,
                          PN_CTA   in Number,
                          PN_OPE   in Number,
                          PN_SBO   in Number,
                          PN_TOP   in Number,
                          PD_FEC   in Date                          
                         )        
  Return Number;  
  
  Procedure sp_seguim_INSEVA(PN_RINI in number, 
                            PN_RFIN in Number,
                            PV_FECHA in Varchar2
                           );
                           
  Procedure sp_sobreend_datcri(PN_RINI  in Number,
                              PN_RFIN  in Number,
                              PV_FECHA in Varchar2
                             );
  
  Procedure sp_cantidad_cuotas (PN_PGCOD in Number,
                               PN_MOD   in Number,
                               PN_MDA   in Number,
                               PN_PAP   in Number,
                               PN_CTA   in Number,
                               PN_OPE   in Number,
                               PN_SBO   in Number,
                               PN_TOP   in Number,
                               PN_NCUO out Number,
                               PF_FVAL out Date,
                               PF_FPAG out Date,
                               PN_DIAS out Number,
                               PN_NMES out Number
                              );                                                                                                       
  Procedure sp_variables_conyuge(PD_FECHA in Date,
                                 PN_PAIS in Number,
                                 PN_TDOC in Number,
                                 PC_NDOC in Char,
                                 PN_PAISC out Number,
                                 PN_TDOCC out Number,
                                 PC_NDOCC out Varchar2,
                                 PC_CSBSC out Varchar2,                                 
                                 PN_CCAJ out Number,
                                 PN_CUOPOT out Number,
                                 PN_CUOSIF out Number,
                                 PN_LINTAR out Number,
                                 PN_DEUTOT out Number,
                                 PN_SALDEU out Number,
                                 PN_SUT out Number,
                                 PN_SUN out Number,                                 
                                 PN_LCN out Number,
                                 PN_LTN out Number,
                                 PN_PMR out Number,
                                 PN_LTP out Number,
                                 PN_LNP out Number
                                 );
                  
  procedure sp_evalua_criterios(PN_TIPSEG in number,
                                PN_VALVAR11 in number,
                                PN_VALVAR12 in number,          
                                PN_VALVAR13 in number,
                                PN_VALVAR14 in number,
                                PN_VALVAR21 in number,
                                PN_VALVAR22 in number,          
                                PN_VALVAR23 in number,
                                PN_VALVAR24 in number,
                                PN_VALVAR31 in number,
                                PN_VALVAR32 in number,          
                                PN_VALVAR33 in number,
                                PN_VALVAR34 in number,
                                PN_VALVAR41 in number,
                                PN_VALVAR42 in number,          
                                PN_VALVAR43 in number,
                                PN_VALVAR44 in number,
                                PN_VALCRI1 out number,
                                PN_VALCRI2 out number,
                                PN_VALCRI3 out number,
                                PN_VALCRI4 out number,
                                PN_VALSOB out number
                                );

  procedure sp_cuotasf_lineatc(PC_CSEG in char,
                               PN_CUOSIF in number,
                               PN_SUN in number,
                               PN_LTN in number,
                               PN_LTP in number,
                               PN_LNP in number,                                                              
                               PN_CUOSFLN out number,
                               PN_CUOPOT out number
                              );

 Procedure sp_cuota_contingente(PD_FECHA in Date,
                                PN_PAIS in Number,
                                PN_TDOC in Number,
                                PC_NDOC in Char,
                                PN_CCON out Number
                               );
                                                                                                          
end PQ_SOBEND_SEG;
/

create or replace package body PQ_SOBEND_SEG is
--modificaciones rmontes: se agrego rubro 0303 en lineas 1342,1343,1344,1346
 Procedure sp_criterios_dep(PN_NUMCRI in number,
                            PN_VALVA1 in number,
                            PN_VALVA2 in number,
                            PN_VALVA3 in number,
                            PN_VALCRI out number
                           )
 Is
   
   ln_ratio number(10,5);
   ln_mxent number(5);
   ln_mxens number(5);
   
 Begin
      PN_VALCRI := 0;
      
      If PN_NUMCRI = 1 Then
         Begin
             Select ratio 
               Into ln_ratio
               From (
                     Select tp1imp1/tp1imp2 ratio
                       From fst198 
                      Where tp1cod=1 
                        and tp1cod1=11000 
                        and tp1corr1=200 
                        and tp1corr2=PN_NUMCRI
                        and tp1nro1 > PN_VALVA1
                      Order by tp1corr3 asc
                     )
              Where rownum = 1;
          Exception When Others Then
             ln_ratio:= 0; 
          End;  
          If ROUND(NVL(PN_VALVA2,0),2) > NVL(ln_ratio,0) Then
             PN_VALCRI := 1; 
          End If;        
      ElsIf PN_NUMCRI = 2 Then 
            
            Select count(*) 
              Into PN_VALCRI
             From fst198 
            Where tp1cod=1 
              And tp1cod1=11000 
              And tp1corr1=200 
              And tp1corr2=PN_NUMCRI
              And PN_VALVA1 between tp1nro1 and tp1nro2
              And PN_VALVA2 between tp1imp1 and tp1imp2;
      
      ElsIf PN_NUMCRI = 3 Then
            
            Select count(*) 
              Into PN_VALCRI
              From fst198 
             Where tp1cod=1 
               And tp1cod1 =11000 
               And tp1corr1=200 
               And tp1corr2=PN_NUMCRI
               And PN_VALVA1 between tp1imp1/tp1imp3 and tp1imp2/tp1imp3
               And ROUND(PN_VALVA2,2) < tp1nro1;
            
            If PN_VALCRI > 1 Then 
               PN_VALCRI:= 1;
            End If;    
               
      ElsIf PN_NUMCRI = 4 Then
            
            Begin
                Select tp1nro2,tp1nro3
                  Into ln_mxent,ln_mxens
                  From (
                        Select tp1nro2,tp1nro3 
                          From fst198 
                         Where tp1cod=1 
                           And tp1cod1 =11000 
                           And tp1corr1=200 
                           And tp1corr2=PN_NUMCRI
                           And PN_VALVA1 < tp1nro1 
                         Order by tp1corr3 asc
                       )
                  Where rownum=1;
            Exception When Others Then
               ln_mxent:=0;
               ln_mxens:=0;
            End;
                
            If ROUND(PN_VALVA2,0) > ln_mxent or PN_VALVA3 > ln_mxens Then
               PN_VALCRI:= 1;
            End If;   
      End If;  
      
 End sp_criterios_dep;    
 
 Procedure sp_criterios_ind(PN_NUMCRI in number,
                            PN_NUMSEG in number,          
                            PN_VALVA1 in number,
                            PN_VALVA2 in number,
                            PN_VALCRI out number
                           )
 Is
 Begin
      PN_VALCRI := 0;
      If PN_NUMCRI = 1 Then
          select count(*) 
            into PN_VALCRI
            from fst198  
           where tp1cod=1 
             and tp1cod1=11000 
             and tp1corr1=100 
             and tp1corr2=PN_NUMCRI --criterio
             and tp1nro1=PN_NUMSEG --segmento
             and PN_VALVA1 between tp1imp1/tp1imp3 and tp1imp2/tp1imp3
             and PN_VALVA2 between tp1nro2 and tp1nro3;
          
          If PN_VALCRI > 1 Then
             PN_VALCRI:= 1;
          End If;  
              
      ElsIf PN_NUMCRI = 2 Then
            select count(*) 
              into PN_VALCRI
              from fst198  
             where tp1cod=1 
               and tp1cod1=11000 
               and tp1corr1=100 
               and tp1corr2=PN_NUMCRI --criterio
               and round(PN_VALVA1,2) between tp1nro2/tp1imp3 and tp1nro3/tp1imp3
               and round(PN_VALVA2,2) between tp1imp1/tp1imp3 and tp1imp2/tp1imp3;
            
            If PN_VALCRI > 1 Then
             PN_VALCRI:= 1;
            End If; 
      
      ElsIf PN_NUMCRI = 3 Then
      
            select count(*)   
              into PN_VALCRI
              from fst198 
             where tp1cod=1 
               and tp1cod1=11000 
               and tp1corr1=100 
               and tp1corr2=PN_NUMCRI --criterio
               and tp1nro1=PN_NUMSEG --segmento
               and PN_VALVA1 between tp1nro2 and tp1nro3
               --and PN_VALVA2 between tp1imp1/tp1imp3 and tp1imp2/tp1imp3;
               and PN_VALVA2 >= tp1imp1/tp1imp3;
               
            If PN_VALCRI > 1 Then
               PN_VALCRI:= 1;
            End If; 
            
      ElsIf PN_NUMCRI = 4 Then
            select count(*) 
              into PN_VALCRI
              from fst198  
             where tp1cod=1 
               and tp1cod1=11000 
               and tp1corr1=100 
               and tp1corr2=PN_NUMCRI --criterio
               and PN_VALVA1 between tp1imp1/tp1imp3 and tp1imp2/tp1imp3; 
            
            If PN_VALCRI > 1 Then
               PN_VALCRI:= 1;
            End If;     
      End If;     
        
 End sp_criterios_ind; 


 Procedure sp_criterios_dco(PN_NUMCRI in number,
                            PN_VALVA1 in number,
                            PN_VALVA2 in number,
                            PN_VALCRI out number
                           )
 Is
   ln_ratdei number(10);
 Begin
      If PN_NUMCRI = 1 Then 
         PN_VALCRI := 0;
         Begin 
               Select tp1nro2
                 Into ln_ratdei
                 From (
                       select tp1nro2 
                        from fst198  
                       where tp1cod=1 
                         and tp1cod1=11000 
                         and tp1corr1=201 
                         and tp1corr2=PN_NUMCRI
                         and tp1nro1 >= PN_VALVA1
                        Order by tp1corr3
                       )
                Where rownum = 1;
         Exception When Others Then
             ln_ratdei := null;
         End;     
         
         If ln_ratdei is not null and ln_ratdei < PN_VALVA2 Then 
            PN_VALCRI := 1;
         End If; 
         
      ElsIf PN_NUMCRI = 2 Then  
            select count(*)
              into PN_VALCRI 
              from fst198  
             where tp1cod=1 
               and tp1cod1=11000 
               and tp1corr1=201 
               and tp1corr2=PN_NUMCRI
               and tp1nro1 = PN_VALVA1
               and tp1imp1 < round(PN_VALVA2,2);
               
            If PN_VALCRI > 1 Then
               PN_VALCRI:= 1;
            End If;  
                 
      End If;        
 End sp_criterios_dco;
 
 Function fn_soend_act_crit(PN_CODSEG in Number,
                            PN_VALCR1 in Number,
                            PN_VALCR2 in Number,
                            PN_VALCR3 in Number,
                            PN_VALCR4 in Number
                           )
 Return Number
 Is 
   ln_sobcri number(1) := 0;
   ln_sumcri number(2);
 Begin
      ln_sumcri:=NVL(PN_VALCR1,0) + NVL(PN_VALCR2,0) + NVL(PN_VALCR3,0) + NVL(PN_VALCR4,0);
      
      select count(*)
        into ln_sobcri
        from fst198  
       where tp1cod=1 
         and tp1cod1=11000 
         and tp1corr1=300 
         and tp1corr2=PN_CODSEG
         and tp1nro1 <= ln_sumcri;
      
      If ln_sobcri > 1 Then
         ln_sobcri := 1;
      End If;
      
      If ln_sobcri = 0 And PN_CODSEG = 1 And PN_VALCR2 = 1 Then
         ln_sobcri := 1;
      End If;
      
      Return ln_sobcri;
      
 End fn_soend_act_crit;                               
 
 Function fn_garantia_dep(PN_PGCOD  in Number,
                          PN_CODMOD in Number,
                          PN_CODSUC in Number,
                          PN_CODMDA in Number,
                          PN_CODPAP in Number,
                          PN_CODCTA in Number,   
                          PN_CODOPE in Number,
                          PN_CODSOP in Number,
                          PN_CODTOP in Number,
                          PD_FECHA  in Date
                         ) 
 Return number
 Is
    ln_gardep number(5) := 0;    
 Begin
       Begin
           Select count(*)
             Into ln_gardep
             From fsr011 r
             Join fsd010 m
               on m.pgcod = r.r2cod
              and m.aomod = r.r2mod
              and m.aomda = r.r2mda
              and m.aopap = r.r2pap
              and m.aocta = r.r2cta
              and m.aooper= r.r2oper
              and m.aosbop= r.r2sbop
              and m.aotope= r.r2tope 
            where relcod  = 50
              and R1COD   = PN_PGCOD
              and R1MOD   = PN_CODMOD
              and R1SUC   = PN_CODSUC
              and R1MDA   = PN_CODMDA
              and R1PAP   = PN_CODPAP
              and R1CTA   = PN_CODCTA
              and R1OPER  = PN_CODOPE
              and R1SBOP  = PN_CODSOP
              and R1TOPE  = PN_CODTOP
              and r2mod   = 70
              and R2TOPE  = 80
              and r.r011co= 'S'
              and (m.aostat <> 99 or 
                   (m.aostat=99 and m.aofe99 > PD_FECHA)
                  ); 
       Exception When Others Then
           ln_gardep := 0;
       End;  
       If ln_gardep = 0 Then
          Begin
             Select count(*)
               Into ln_gardep
               From fsr011 r
               Join fsd010 m
                 on m.pgcod = r.r2cod
                and m.aomod = r.r2mod
                and m.aomda = r.r2mda
                and m.aopap = r.r2pap
                and m.aocta = r.r2cta
                and m.aooper= r.r2oper
                and m.aosbop= r.r2sbop
                and m.aotope= r.r2tope 
              where relcod  = 50
                and R1COD   = PN_PGCOD
                and R1MOD   = PN_CODMOD
                and R1MDA   = PN_CODMDA
                and R1PAP   = PN_CODPAP
                and R1CTA   = PN_CODCTA
                and R1OPER  = PN_CODOPE
                and R1SBOP  = PN_CODSOP
                and R1TOPE  = PN_CODTOP
                and r2mod   = 70
                and R2TOPE  = 80
                and r.r011co= 'S'
                and (m.aostat <> 99 or 
                     (m.aostat=99 and m.aofe99 > PD_FECHA)
                    );
           Exception When Others Then
               ln_gardep := 0;
           End;           
        End If;
        If ln_gardep > 1 Then  
           ln_gardep := 1;
        End If;
     
     Return ln_gardep;        
 End fn_garantia_dep;
 
 
 Procedure sp_datos_seguim (PD_FECHA in date)
 Is
   ln_existe number(1);
   
   x        number(10) := 0;
   ln_max   number(10);
   ln_rango number(10);
   ln_ini   number(10);
   ln_fin   number(10);
   ln_job   number(10) := 0;
   lv_query varchar2(100);
   lv_fecha varchar2(10) := to_char(PD_FECHA,'rrrrmmdd');
   ln_nrojob number(10);
   
   lc_hostname varchar2(64);
    
 Begin
 
      begin
        select host_name into lc_hostname from v$instance;
      end;
      
      -- Limpia tabla temporal jaqy490t
      Select count(*) Into ln_existe From user_tables Where table_name = 'JAQY490T';
      If ln_existe > 0 Then
         Execute immediate 'Truncate table JAQY490T';
         Commit;
         
         -- Inserta datos en temporal
         Insert into JAQY490T(numreg,
                              bcfech,pepais,petdoc,pendoc,ocucod,segcod, 
                              bcemp ,bcmod, bcsuc, bcmda, bcpap, bccta, 
                              bcoper,bcsbop,bctop,bcfval,bcfvto,bcprod, 
                              bcrubr,bcsdmn,bcticu,bcgpo--,numins,gardep
                             )  
         Select rownum,
                h.bcfech,r.pepais,r.petdoc,r.pendoc,n.sngc60ocup,
                case when r.petdoc=9 then 1 else g.segcod end segcod,
                h.bcemp,h.bcmod,h.bcsuc,h.bcmda,h.bcpap,h.bccta,
                h.bcoper,h.bcsbop,h.bctop,h.bcfval,h.bcfvto,h.bcprod,
                h.bcrubr,h.bcsdmn,h.bcticu,
                case when h.bcmod=117 then to_number(substr(h.bcrubr,7,2)) else h.bcgpo end bcgpo    
          From fsh012 h
          Join fsr008 r
            on r.ctnro = h.bccta
           and r.pgcod = h.bcemp
          Left Join sngc60 n
            on n.sngc60pais = r.pepais
           and n.sngc60tdoc = r.petdoc
           and n.sngc60ndoc = r.pendoc
           and n.sngc60corr = 0   
          Left Join sngc07 g
            on g.sngc07cod = n.sngc60ocup 
         Where h.bcfech = PD_FECHA
           and h.bccta <> 999999999
           and h.bcprod<> 99
           and (substr(h.bcrubr,1,4) in (1411,1415,1421,1425,1414,1424) Or  
                (h.bcmod = 117 and h.bcprod <> 7 and h.bcfvto >= h.bcfech) Or
                (h.bcmod = 141) --p1864
               )
           and h.bcmod not in (108/*,141*/)
           and r.cttfir= 'T'
           and r.ttcod = 1;    
         Commit;
         
          
         
         ----------------------------
         --JOBS INSTANCIA EVALUACION
         ----------------------------
         Begin 
            Select max(y.numreg),trunc(max(y.numreg)/250)   
              Into ln_max,ln_rango
              From jaqy490t y
             Where y.bcfech = PD_FECHA
               and y.bcmod <> 141; --p1864
         Exception When Others then
                  ln_max := 0;
                  ln_rango:=0;
         End; 
       
         x:=0;
         While x <= ln_max Loop
               ln_ini := x+1;
               x:= x+ ln_rango;
               ln_fin := x;
               lv_query := ' begin '||'  PQ_SOBEND_SEG.SP_SEGUIM_INSEVA('||ln_ini||','||ln_fin ||',' || lv_fecha || ');'|| ' End; ';
               
               ln_job := ln_job +1;
                
               dbms_scheduler.create_job(job_name=> 'JAQY490T_SEG_'||LPAD(TO_CHAR(ln_job),5,'0'),
                                         job_type=> 'PLSQL_BLOCK',
                                         job_action=> lv_query,
                                         start_date => sysdate+1/(24*180),
                                         enabled => true, 
                                         auto_drop=> TRUE,
                                         comments => 'JAQY490T'
                                        );
                                        
               if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
                 begin        
                   dbms_scheduler.set_attribute('JAQY490T_SEG_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',2);
                 end; 
               else
                 begin
                   dbms_scheduler.set_attribute('JAQY490T_SEG_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',1);
                 end; 
               end if;
                                                       
               commit;
         End Loop; 
         ----------------------------
         
         -- Verifica que ya no existan jobs para ejecución
         ln_nrojob := 0;
         Loop 
             select count(*) 
               into ln_nrojob
               from DBA_SCHEDULER_JOBS 
              where owner = 'BANTPROD'
                and job_name like 'JAQY490T%'; 
         Exit when ln_nrojob = 0;
         End Loop;
         
         PQ_SOBEND_SEG.sp_proceso_sobreend(PD_FECHA);
         
     End If;
 End sp_datos_seguim;          

 Procedure sp_seguim_inseva(PN_RINI in number, 
                            PN_RFIN in Number,
                            PV_FECHA in Varchar2
                           )
 Is
   ld_fecha  date := to_date(PV_FECHA,'rrrrmmdd');
   
   Cursor c_datos
       Is Select h.numreg,h.bcmod,h.bcsuc,h.bcmda,h.bcpap,h.bccta,h.bcoper,h.bcsbop,h.bctop,bcfech,h.bcgpo,h.bcemp
            From JAQY490T h
           Where numreg between pn_rini and pn_rfin
             and bcfech = ld_fecha
             and bcmod <> 141; --p1864
           
   ln_numeva sng021.sng021eval%type; 
   ld_feceva date;
   ln_tipcam number(7,3);
   ln_tcames number(7,3);
   ln_tipmod number(2);
   ln_numins number(9);
   ln_gardep number(1); 
   ln_mtocuo number(12,2); 
   ln_toting number(17,2);
   ln_ingven number(17,2);
   ln_otring number(17,2);
   ln_utinet number(17,2);
   ln_resnet number(17,2);
   ln_totpas number(17,2);
   ln_totpat number(17,2); 
   ln_excmen number(17,2); 
   ln_numcuo number(5);
   ld_fecpag date;
   ld_fecdes date;
   ln_ndiacu number(10);       
   ln_period number(10); 
   ln_nmescu number(10);   
     
 Begin   
   
        -- Obtiene tipo de cambio de mes
         Begin
             Select cotcbi
               Into ln_tcames

               From (
                     Select h.cotcbi
                       from fsh005 h
                      Where h.moneda = 101
                        and h.cofdes <= LD_FECHA
                      Order by h.cofdes desc  
                    )
             Where rownum = 1;   
         Exception When Others Then
            ln_tcames := 0;
         End;                  
         -- Actualiza datos de evaluación
         For x In c_datos Loop
             ln_numins :=fn_instancia_credito(x.bcmod,x.bcsuc,x.bcmda,x.bcpap,x.bccta,x.bcoper,x.bcsbop,x.bctop); 
             ln_gardep :=(Case when x.bcgpo not in (3,2) Then 0 Else
                              pq_sobend_seg.fn_garantia_dep(x.bcemp,x.bcmod,x.bcsuc,x.bcmda,x.bcpap,x.bccta,x.bcoper,x.bcsbop,x.bctop,x.bcfech) 
                          End);         
             ln_mtocuo := pq_sobend_seg.fn_monto_cuota(x.bcemp,x.bcmod,x.bcsuc,x.bcmda,x.bcpap,x.bccta,x.bcoper,x.bcsbop,x.bctop,ld_fecha);
             ln_numeva := null;
             
             -- Datos del cronograma
            pq_sobend_seg.sp_cantidad_cuotas(x.bcemp,x.bcmod,
                                             x.bcmda,x.bcpap,
                                             x.bccta,x.bcoper,
                                             x.bcsbop,x.bctop,
                                             ---------------
                                             ln_numcuo,ld_fecdes,
                                             ld_fecpag,ln_ndiacu,
                                             ln_nmescu
                                            );
             
             If ln_numins Is not null Then
                -- Busca la fecha de evaluación registrada en 120
                Begin
                      Select d.sng120fpag,d.sng120tcbi
                        into ld_feceva,ln_tipcam 
                        from sng120 d
                       where d.sng120ins = ln_numins
                         and d.sng120tsk = 'EVALUACION';
                Exception 
                  When Others Then
                       ld_feceva:=null;
                       ln_tipcam:=null;
                End;            
                
                -- Busca nro. de evaluación
                Begin
                   select sng021eval,e.sng021tmod
                     into ln_numeva,ln_tipmod 
                     from sng021 e
                    where sng021sol=ln_numins;
                Exception When Others Then
                    ln_numeva := null;
                    ln_tipmod := null; 
                End;     
             End If;
             
             If ln_numeva Is Not Null Then
                pq_sobend_seg.sp_datos_evaluacion(ln_numeva,ln_tipcam,
                                                  ln_toting,ln_ingven,
                                                  ln_otring,ln_utinet,
                                                  ln_resnet,ln_totpas,ln_totpat,ln_excmen);
             Else
                ln_toting := 0;
                ln_ingven := 0;
                ln_otring := 0;
                ln_utinet := 0;
                ln_resnet := 0;
                ln_totpas := 0;
                ln_totpat := 0;
                ln_excmen := 0;
             End If;
            
            
            begin

              ln_period := 0;
              
              select o.aoperiod
              into ln_period
              from fsd010 o
              where o.pgcod = x.bcemp
              and o.aomod = x.bcmod              
              and o.aomda = x.bcmda
              and o.aopap = x.bcpap
              and o.aocta = x.bccta
              and o.aooper = x.bcoper
              and o.aosbop = x.bcsbop              
              and o.aotope = x.bctop
              and rownum = 1;

            exception when others then
              ln_period := ln_ndiacu; 
            end;
            
            if ln_period <> 0 then
                ln_mtocuo := ln_mtocuo/(ln_period/30);
            end if;
            
               
            Update JAQY490T y
               Set numeva = ln_numeva,
                   feceva = ld_feceva, 
                   tipcam = ln_tipcam,
                   modeva = ln_tipmod,
                   numins = ln_numins,
                   gardep = nvl(ln_gardep,0),
                   toting = ln_toting,
                   ingven = ln_ingven,
                   otring = ln_otring,
                   utinet = ln_utinet,
                   resnet = ln_resnet,
                   totpas = ln_totpas,
                   totpat = ln_totpat,
                   mtocuo = ln_mtocuo,
                   tcames = ln_tcames,
                   numcuo = ln_numcuo,
                   fecpag = ld_fecpag,
                   fecdes = ld_fecdes,
                   ndiacu = ln_ndiacu,
                   nmescu = ln_nmescu,
                   excmen = ln_excmen
             Where numreg = x.numreg;
             Commit;      
             
          End Loop;                        
                            
 End sp_seguim_inseva;    
 
 Procedure sp_datos_evaluacion(PN_NUMEVA in number,
                               PN_TIPCAM in number,             
                               PN_TOTING out number,
                               PN_VENTAS out number,
                               PN_OTRING out number,
                               PN_UTINET out number,
                               PN_RESNET out number,
                               PN_TOTPAS out number,
                               PN_TOTPAT out number,
                               PN_EXCMEN out number                             
                              )
 Is
 Begin
      PN_TOTING := 0;
      PN_VENTAS := 0;
      PN_OTRING := 0;
      PN_UTINET := 0;
      PN_RESNET := 0;
      PN_TOTPAS := 0;
      PN_TOTPAT := 0;
      PN_EXCMEN := 0;
      
      Begin
          Select Sum(Case when sng026cod = 21 then  sng023mto
                      when sng026cod = 521 then sng023mto * PN_TIPCAM
                     End),
                 Sum(Case when sng026cod = 73 then  sng023mto
                      when sng026cod = 573 then sng023mto * PN_TIPCAM
                     End), 
                 Sum(Case when sng026cod = 53 then  sng023mto
                      when sng026cod = 553 then sng023mto * PN_TIPCAM
                     End),
                 Sum(Case when sng026cod = 84 then  sng023mto
                      when sng026cod = 584 then sng023mto * PN_TIPCAM
                     End),
                 Sum(Case when sng026cod = 40 then  sng023mto
                      when sng026cod = 540 then sng023mto * PN_TIPCAM
                     End),  
                 Sum(Case when sng026cod = 65 then  sng023mto
                      when sng026cod = 565 then sng023mto * PN_TIPCAM
                     End),
                 Sum(Case when sng026cod = 70 then  sng023mto
                      when sng026cod = 570 then sng023mto * PN_TIPCAM
                     End),                        
                 Sum(Case when sng026cod = 27 then  sng023mto
                      when sng026cod = 527 then sng023mto * PN_TIPCAM
                     End)                     
            Into PN_TOTING,PN_VENTAS,PN_OTRING,PN_UTINET,PN_RESNET,PN_TOTPAS,PN_TOTPAT,PN_EXCMEN
            From sng023 h
           Where sng021eval = PN_NUMEVA
            and sng026cod in (21,521,73,573,53,553,84,584,40,540,65,565,70,570,27,527);
      Exception When Others Then
                PN_TOTING := 0;
                PN_VENTAS := 0;
                PN_OTRING := 0;
                PN_UTINET := 0;
                PN_RESNET := 0;
                PN_TOTPAS := 0;
                PN_TOTPAT := 0;
                PN_EXCMEN := 0; 
      End;  
 End sp_datos_evaluacion;                              
 
 
 Procedure sp_proceso_sobreend (PD_FECHA in date)
 Is 
      
   x        number(10) := 0;
   ln_max   number(10);
   ln_rango number(10);
   ln_ini   number(10);
   ln_fin   number(10);
   ln_job   number(10) := 0;
   lv_query varchar2(100);
   lv_fecha varchar2(10) := to_char(PD_FECHA,'rrrrmmdd');
   ln_nrojob number(10);
   
   lc_hostname varchar2(64);
                                      
 Begin
 
   begin
     select host_name into lc_hostname from v$instance;
   end;
   
   -- Pasaje a histórico

   Begin
   Insert into jaqy490h(jaqy490fec,jaqy490pai,jaqy490tdo,jaqy490ndo,jaqy490seg,jaqy490sin,jaqy490ins, 
                        jaqy490nev,jaqy490fev,jaqy490fsb,jaqy490sbs,jaqy490cca,jaqy490csf,jaqy490tin, 
                        jaqy490ulc,jaqy490vsd,jaqy490vne,jaqy490ens,jaqy490cpo,jaqy490ven,jaqy490oin, 
                        jaqy490une,jaqy490rne,jaqy490dto,jaqy490pas,jaqy490pat,jaqy490coc,jaqy490foi, 
                        jaqy490cr1,jaqy490cr2,jaqy490cr3,jaqy490cr4,jaqy490sob,jaqy490mtc,jaqy490nen, 
                        jaqy490nre,
                        jaqy490pac,jaqy490tdc,jaqy490ndc,jaqy490sbc,jaqy490ccc,jaqy490csc,jaqy490cpc
                       )
                 Select jaqy490fec,jaqy490pai,jaqy490tdo,jaqy490ndo,jaqy490seg,jaqy490sin,jaqy490ins, 
                        jaqy490nev,jaqy490fev,jaqy490fsb,jaqy490sbs,jaqy490cca,jaqy490csf,jaqy490tin, 
                        jaqy490ulc,jaqy490vsd,jaqy490vne,jaqy490ens,jaqy490cpo,jaqy490ven,jaqy490oin, 
                        jaqy490une,jaqy490rne,jaqy490dto,jaqy490pas,jaqy490pat,jaqy490coc,jaqy490foi, 
                        jaqy490cr1,jaqy490cr2,jaqy490cr3,jaqy490cr4,jaqy490sob,jaqy490mtc,jaqy490nen, 
                        jaqy490nre,
                        jaqy490pac,jaqy490tdc,jaqy490ndc,jaqy490sbc,jaqy490ccc,jaqy490csc,jaqy490cpc 
                   From jaqy490s;
   Commit;                                 
   Exception When Others Then
       Null;
   End;  
   
   Execute immediate 'Truncate table jaqy490s';
   
   Insert into jaqy490s(jaqy490nre,jaqy490fec,jaqy490pai,jaqy490tdo,jaqy490ndo,jaqy490seg)
               Select Rownum, d.*
                 From (
                        select distinct i.bcfech,i.pepais,i.petdoc,i.pendoc,
                                        case
                                          when (first_value(i.modeva)
                                                over(partition by i.pepais,i.petdoc,i.pendoc 
                                                     order by feceva desc nulls last, numeva desc nulls last)) = 14 then 2
                                          when (first_value(i.modeva)
                                                over(partition by i.pepais,i.petdoc,i.pendoc 
                                                     order by feceva desc nulls last, numeva desc nulls last)) = 13 then 1 else i.segcod
                                        end segmento
                          from jaqy490t i
                         where i.bcfech = PD_FECHA
                           and i.bcmod not in (108, 141)
                           and (i.bcgpo in (4, 13) Or (i.bcgpo in (3, 2) and nvl(i.gardep, 0) <> 1))
                       ) d;
   Commit;  
   
   ----------------------------
   --JOBS INSTANCIA EVALUACION
   ----------------------------
   Begin 
      Select max(y.jaqy490nre),trunc(max(y.jaqy490nre)/250)   
        Into ln_max,ln_rango
        From jaqy490s y
       Where y.jaqy490fec = PD_FECHA;
   Exception When Others then
            ln_max := 0;
            ln_rango:=0;
   End; 
       
   x:=0;
   While x <= ln_max Loop
         ln_ini := x+1;
         x:= x+ ln_rango;
         ln_fin := x;
         lv_query := ' begin '||'  PQ_SOBEND_SEG.SP_SOBREEND_DATCRI('||ln_ini||','||ln_fin ||',' || lv_fecha || ');'|| ' End; ';
               
         ln_job := ln_job +1;
                
         dbms_scheduler.create_job(job_name=> 'JAQY490S_SEG_'||LPAD(TO_CHAR(ln_job),5,'0'),
                                   job_type=> 'PLSQL_BLOCK',
                                   job_action=> lv_query,
                                   start_date => sysdate+1/(24*180),
                                   enabled => true, 
                                   auto_drop=> TRUE,
                                   comments => 'JAQY490S'
                                  );
                                  
         if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
           begin        
             dbms_scheduler.set_attribute('JAQY490S_SEG_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',2);
           end; 
         else
           begin
             dbms_scheduler.set_attribute('JAQY490S_SEG_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',1);
           end; 
         end if;
         
         commit;
   End Loop; 
   
   -- Verifica que no exceda el limite de jobs
   ln_nrojob:=0;
   Loop 
       select count(*) 
         into ln_nrojob
         from DBA_SCHEDULER_JOBS
        where owner = 'BANTPROD'
          and job_name like 'JAQY490S%'; 
   Exit when ln_nrojob = 0;
   End Loop;
   
   ----------------------------
 End sp_proceso_sobreend;
 
 Procedure sp_sobreend_datcri(PN_RINI  in Number,
                              PN_RFIN  in Number,
                              PV_FECHA in Varchar2
                             )
 Is
   Cursor c_deudores (ln_fecpro in Date)
       Is Select * 
            From jaqy490s
           Where jaqy490fec = ln_fecpro
             and jaqy490nre between PN_RINI and PN_RFIN;
           
    
   ln_inst number(9); 
   ln_neva number(9);
   ld_feva date; 
   ln_ssbr number(1);
   ln_sdep number(1); 
   ln_foin number(1);
   ln_ting number(17,2); 
   ln_iven number(17,2);
   ln_oing number(17,2); 
   ln_unet number(17,2);
   ln_rnet number(17,2); 
   ln_tpas number(17,2);
   ln_tpat number(17,2);   
   ln_ccaj number(12,2);
   ln_exmn number(17,2);
   ln_ccon number(17,2);
   ln_cuopot number(20,5); 
   ln_lintar number(20,5);
   ln_lintarcon number(20,5);
   ln_monltc number(20,5); 
   ln_varsde number(20,5);
   ln_varnen number(20,5); 
   ln_numens number(20,5);
   ln_deutot number(20,5);
   ln_deutotcon number(20,5);
   ln_cuooco number(20,5);
   ln_nument number(20,5);
   ln_cuosfi number(20,5);
   ln_saldeu number(20,5);
   ln_saldeucon number(20,5);   
   ln_sut number(20,5);
   ln_sun number(20,5);   
   ln_lcn number(20,5);   
   ln_ltn number(20,5);   
   ln_pmr number(20,5);
   ln_ltp number(20,5);
   ln_lnp number(20,5);      
   ln_sutcon number(20,5);
   ln_suncon number(20,5);   
   ln_lcncon number(20,5);   
   ln_ltncon number(20,5);   
   ln_pmrcon number(20,5);   
   ln_ltpcon number(20,5);   
   ln_lnpcon number(20,5);   
   
   lv_codsbs varchar2(10);
   ld_fecrcc date;
   ld_fecha  date := to_date(PV_FECHA,'rrrrmmdd');
   
   ln_val1_cri1 number(12,2);
   ln_val2_cri1 number(12,2); 
   ln_val1_cri2 number(12,2);
   ln_val2_cri2 number(20,5); 
   ln_val1_cri3 number(12,2);
   ln_val2_cri3 number(20,5);
   ln_val1_cri4 number(12,2);
   ln_val2_cri4 number(12,2);  
   ln_val3_cri4 number(12,2); 
   ln_codseg    number(1);

   ln_rppais fsr002.rppais%type;
   ln_rptdoc fsr002.rptdoc%type;
   lc_rpndoc fsr002.rpndoc%type;   
   lv_csbsc varchar2(10);   
   ln_ccajcon number(17,2);
   ln_cuopotcon number(20,5);
   ln_cuosficon number(20,5);
   
   ln_tipseg fst198.tp1corr1%type;
   ln_valvar11 number(20,5);
   ln_valvar12 number(20,5);          
   ln_valvar13 number(20,5);
   ln_valvar14 number(20,5);
   ln_valvar21 number(20,5);
   ln_valvar22 number(20,5);          
   ln_valvar23 number(20,5);
   ln_valvar24 number(20,5);
   ln_valvar31 number(20,5);
   ln_valvar32 number(20,5);          
   ln_valvar33 number(20,5);
   ln_valvar34 number(20,5);
   ln_valvar41 number(20,5);
   ln_valvar42 number(20,5);          
   ln_valvar43 number(20,5);
   ln_valvar44 number(20,5);
   ln_valcri1 number(1);
   ln_valcri2 number(1);
   ln_valcri3 number(1);
   ln_valcri4 number(1);
   ln_valsob number(1); 
   ln_verest char(1);

 Begin                               
   -- Variables internas y externas
   For x in c_deudores(ld_fecha) Loop
       PQ_SOBEND_SEG.sp_variables_evaluacion(x.jaqy490fec,
                                             x.jaqy490pai,x.jaqy490tdo,
                                             x.jaqy490ndo,x.jaqy490seg,
                                             -------------------------              
                                             ln_inst, ln_neva,
                                             ld_feva, ln_ssbr,
                                             ln_sdep, ln_foin,
                                             ln_ting, ln_iven,
                                             ln_oing, ln_unet,
                                             ln_rnet, ln_tpas,
                                             ln_tpat, ln_ccaj,
                                             ln_exmn
                                            ); 
                                            
       PQ_SOBEND_RCC.sp_retorna_variables_seg(
                                          (case when x.jaqy490seg=1 then x.jaqy490seg
                                               else ln_sdep
                                          end),
                                          x.jaqy490tdo,
                                          trim(x.jaqy490ndo),
                                          ---------------------
                                          ln_cuopot, ln_lintar,
                                          ln_monltc, ln_varsde,
                                          ln_varnen, ln_numens,
                                          ln_deutot, ln_cuooco,
                                          ln_nument, ln_cuosfi, ln_saldeu, ln_sut, ln_sun, ln_lcn, ln_ltn, ln_pmr, ln_ltp, ln_lnp,
                                          lv_codsbs, ld_fecrcc
                                         );

       PQ_SOBEND_RCC.SP_VERIFICA_ESTADO(x.jaqy490tdo,
                                        trim(x.jaqy490ndo),
                                        ln_verest
                                       );
       
       if ln_verest is null then                         

         PQ_SOBEND_SEG.sp_cuotasf_lineatc(x.jaqy490seg,
                                          ln_cuosfi,
                                          ln_sun+ln_pmr,
                                          ln_ltn,
                                          ln_pmr,
                                          ln_lnp,
                                          ln_cuosfi,
                                          ln_cuopot
                                         );

         PQ_SOBEND_RCC.sp_actualiza_variables(x.jaqy490tdo,
                                              trim(x.jaqy490ndo),
                                              ln_cuopot,
                                              ln_cuosfi
                                              );
       end if;
                                         
       PQ_SOBEND_SEG.sp_cuota_contingente(x.jaqy490fec,
                                          x.jaqy490pai,x.jaqy490tdo,x.jaqy490ndo,
                                          ln_ccon
                                          );

       PQ_SOBEND_SEG.sp_variables_conyuge(x.jaqy490fec,
                                          x.jaqy490pai,x.jaqy490tdo,x.jaqy490ndo,
                                          ---------------------------------------
                                          ln_rppais,ln_rptdoc,lc_rpndoc,lv_csbsc,
                                          ln_ccajcon,
                                          ln_cuopotcon,
                                          ln_cuosficon,
                                          ln_lintarcon,
                                          ln_deutotcon,
                                          ln_saldeucon,
                                          ln_sutcon,
                                          ln_suncon,
                                          ln_lcncon,
                                          ln_ltncon,
                                          ln_pmrcon,
                                          ln_ltpcon,
                                          ln_lnpcon);
                                          
                                          ln_deutot := ln_saldeu + nvl(ln_saldeucon,0);
                                          
                                          ln_lintar := (case when (nvl(ln_sut,0) + nvl(ln_lcn,0) + nvl(ln_sutcon,0) + nvl(ln_lcncon,0)) > 0
                                                        then (nvl(ln_sut,0) + nvl(ln_sutcon,0))/(nvl(ln_sut,0) + nvl(ln_lcn,0) + nvl(ln_sutcon,0) + nvl(ln_lcncon,0)) 
                                                        else 0 end);
                                  
       Update jaqy490s
          Set jaqy490sin = (case when x.jaqy490seg=1 then ln_ssbr when x.jaqy490seg=2 then ln_sdep else null end), 
              jaqy490ins = ln_inst, 
              jaqy490nev = ln_neva, 
              jaqy490fev = ld_feva, 
              jaqy490tin = ln_ting,
              jaqy490oin = ln_oing, 
              jaqy490une = ln_unet, 
              jaqy490rne = ln_rnet,
              jaqy490pas = ln_tpas, 
              jaqy490pat = ln_tpat,
              jaqy490foi = ln_foin,
              jaqy490ven = ln_iven,
              jaqy490cca = ln_ccaj, 
              jaqy490csf = ln_cuosfi, 
              jaqy490ulc = ln_lintar, 
              jaqy490vsd = ln_varsde, 
              jaqy490vne = ln_varnen, 
              jaqy490ens = ln_numens, 
              jaqy490cpo = ln_cuopot, 
              jaqy490dto = ln_deutot, 
              jaqy490coc = ln_cuooco,
              jaqy490fsb = ld_fecrcc, 
              jaqy490sbs = lv_codsbs,
              jaqy490nen = ln_nument,
              jaqy490mtc = ln_monltc,
              jaqy490pac = ln_rppais,
              jaqy490tdc = ln_rptdoc,
              jaqy490ndc = lc_rpndoc,
              jaqy490sbc = lv_csbsc,
              jaqy490ccc = ln_ccajcon,
              jaqy490csc = ln_cuosficon,
              jaqy490cpc = ln_cuopotcon, 
              jaqy490exc = ln_exmn,
              jaqy490cex = ln_ccon          
        Where jaqy490fec = x.jaqy490fec 
          and jaqy490pai = x.jaqy490pai 
          and jaqy490tdo = x.jaqy490tdo 
          and jaqy490ndo = x.jaqy490ndo; 

        Commit;                                                               
   End Loop;
   
   --- Activación de criterios e identificación de sobre endeudado
   For x in c_deudores(ld_fecha) Loop 
       If x.jaqy490seg = 1 Then
          ln_val1_cri1 := (case when nvl(x.jaqy490pat,0) <> 0 then nvl(x.jaqy490pas,0)/nvl(x.jaqy490pat,0) else 0 end); 
          ln_val2_cri1 := nvl(x.jaqy490ens,0);
          ln_val1_cri2 := (case when nvl(x.jaqy490rne,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490cpo,0) <> 0
                                then (nvl(x.jaqy490cca,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490ccc,0)+nvl(x.jaqy490csc,0))/(nvl(x.jaqy490rne,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490cpo,0))             
                                else 0 end);
          ln_val2_cri2 := (case when nvl(x.jaqy490une,0)+nvl(x.jaqy490oin,0) <> 0
                                then nvl(x.jaqy490dto,0)/(nvl(x.jaqy490une,0)+nvl(x.jaqy490oin,0))
                                else 0  
                           end);   
          ln_val1_cri3 := nvl(x.jaqy490vne,0);                
          ln_val2_cri3 := nvl(x.jaqy490vsd,0);  
          ln_val1_cri4 := nvl(x.jaqy490ulc,0);
          
          ln_codseg := x.jaqy490seg;


         case x.jaqy490sin
           when 1 then ln_tipseg := 111;
           when 2 then ln_tipseg := 112;
           when 3 then ln_tipseg := 113;
           else ln_tipseg := 0;
         end case;           
         
         ln_valvar11 := (case when (nvl(x.jaqy490rne,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490csc,0)) <> 0
                           then (nvl(x.jaqy490cca,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490cex,0)+nvl(x.jaqy490ccc,0)+nvl(x.jaqy490csc,0)+nvl(x.jaqy490cec,0))/(nvl(x.jaqy490rne,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490csc,0)) --p1864
                           else 0
                         end); 

          Update jaqy490s
            Set jaqy490cec = ln_valvar11          
          Where jaqy490fec = x.jaqy490fec 
            and jaqy490pai = x.jaqy490pai 
            and jaqy490tdo = x.jaqy490tdo 
            and jaqy490ndo = x.jaqy490ndo; 
          Commit;
                                       
         ln_valvar21 := (case when nvl(x.jaqy490pat,0) <> 0 then nvl(x.jaqy490pas,0)/nvl(x.jaqy490pat,0) else 0 end);
         ln_valvar22 := nvl(x.jaqy490ens,0);

         If ln_tipseg = 111 Then
           
           ln_valvar31 := ln_valvar21;
           ln_valvar32 := ln_valvar22;
           ln_valvar33 := nvl(x.jaqy490ulc,0); 
           ln_valvar34 := nvl(x.jaqy490vsd,0);         
            
           ln_valvar41 := ln_valvar21;
           ln_valvar42 := ln_valvar22; 
           ln_valvar43 := ln_valvar33;
           
         Elsif ln_tipseg = 112 Then
         
           ln_valvar31 := ln_valvar21;
           ln_valvar32 := ln_valvar21;
           ln_valvar33 := ln_valvar22;
            
           ln_valvar41 := ln_valvar21;
           ln_valvar42 := ln_valvar22; 
         
         Elsif ln_tipseg = 113 Then
         
           ln_valvar21 := (case when (nvl(x.jaqy490ven,0)+nvl(x.jaqy490oin,0)) <> 0
                             then nvl(x.jaqy490dto,0)/(nvl(x.jaqy490ven,0)+nvl(x.jaqy490oin,0))
                             else 0
                           end);

           ln_valvar31 := (case when nvl(x.jaqy490pat,0) <> 0 then nvl(x.jaqy490pas,0)/nvl(x.jaqy490pat,0) else 0 end);

           ln_valvar32 := ln_valvar22;
           ln_valvar33 := (case when (nvl(x.jaqy490ven,0)+nvl(x.jaqy490oin,0)) <> 0
                             then nvl(x.jaqy490dto,0)/(nvl(x.jaqy490ven,0)+nvl(x.jaqy490oin,0))
                             else 0
                           end);
         
         End If;
          
       ElsIf x.jaqy490seg = 2 Then
          
          ln_val1_cri1 := nvl(x.jaqy490tin,0);  
          ln_val2_cri1 := (case when nvl(x.jaqy490tin,0) <> 0 
                                then (nvl(x.jaqy490cca,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490ccc,0)+nvl(x.jaqy490csc,0))/nvl(x.jaqy490tin,0)
                                else 0
                           end);         
          ln_val1_cri2 := nvl(x.jaqy490vne,0);                  
          ln_val2_cri2 := nvl(x.jaqy490vsd,0);
          ln_val1_cri3 := nvl(x.jaqy490ulc,0);                  
          ln_val2_cri3 := nvl(x.jaqy490mtc,0);
          ln_val1_cri4 := nvl(x.jaqy490tin,0);                  
          ln_val2_cri4 := nvl(x.jaqy490nen,0);
          ln_val3_cri4 := nvl(x.jaqy490ens,0);
          
         ln_codseg := x.jaqy490seg; 

          
         ln_tipseg := 21; 
          
         ln_valvar11 := (case when (nvl(x.jaqy490exc,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490csc,0)) <> 0 
                           then (nvl(x.jaqy490cca,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490cex,0)+nvl(x.jaqy490ccc,0)+nvl(x.jaqy490csc,0)+nvl(x.jaqy490cec,0))/(nvl(x.jaqy490exc,0)+nvl(x.jaqy490csf,0)+nvl(x.jaqy490csc,0)) --p1864
                           else 0
                         end); 

          Update jaqy490s
            Set jaqy490cec = ln_valvar11          
          Where jaqy490fec = x.jaqy490fec 
            and jaqy490pai = x.jaqy490pai 
            and jaqy490tdo = x.jaqy490tdo 
            and jaqy490ndo = x.jaqy490ndo; 
          Commit;
          
         ln_valvar21 := (case when nvl(x.jaqy490tin,0) <> 0 
                           then (nvl(x.jaqy490dto,0)/x.jaqy490tin)
                           else 0
                         end);
         ln_valvar22 := nvl(x.jaqy490ens,0);
         ln_valvar23 := nvl(x.jaqy490ulc,0);
         
         ln_valvar31 := ln_valvar21;
         ln_valvar32 := ln_valvar22;
         ln_valvar33 := ln_valvar23; 
          
         ln_valvar41 := ln_valvar21; 
         ln_valvar42 := ln_valvar22;           
         ln_valvar43 := ln_valvar23; 
       
       Else
           ln_valcri1 := 2; 
           ln_valcri2 := 2; 
           ln_valcri3 := 2; 
           ln_valcri4 := 2; 
           ln_valsob := 0;  
           ln_codseg:= 0;            
       End If;
       
       If x.jaqy490seg = 1 Or x.jaqy490seg = 2 Then
         pq_sobend_seg.sp_evalua_criterios(ln_tipseg,
                                           ln_valvar11,
                                           ln_valvar12,          
                                           ln_valvar13,
                                           ln_valvar14,
                                           ln_valvar21,
                                           ln_valvar22,          
                                           ln_valvar23,
                                           ln_valvar24,
                                           ln_valvar31,
                                           ln_valvar32,          
                                           ln_valvar33,
                                           ln_valvar34,
                                           ln_valvar41,
                                           ln_valvar42,          
                                           ln_valvar43,
                                           ln_valvar44,
                                           ln_valcri1,
                                           ln_valcri2,
                                           ln_valcri3,
                                           ln_valcri4,
                                           ln_valsob
                                           ); 
       End If;
       
       Update jaqy490s l
          set jaqy490cr1 = ln_valcri1,        
              jaqy490cr2 = ln_valcri2, 
              jaqy490cr3 = ln_valcri3, 
              jaqy490cr4 = ln_valcri4, 
              jaqy490sob = ln_valsob 
       Where jaqy490fec = x.jaqy490fec 
          and jaqy490pai = x.jaqy490pai 
          and jaqy490tdo = x.jaqy490tdo 
          and jaqy490ndo = x.jaqy490ndo; 
       
       Commit;
                 
   End Loop;                   
 End sp_sobreend_datcri;        
 
 Procedure sp_variables_evaluacion(PD_FECHA in Date,
                                   PN_PAIS  in Number,
                                   PN_TDOC  in Number,
                                   PC_NDOC  in Char,
                                   PN_CSEG  in Number,
                                   PN_INST out Number,
                                   PN_NEVA out Number,
                                   PD_FEVA out Date,
                                   PN_SSBR out Number,
                                   PN_SDEP out Number,
                                   PN_FOIN out Number,
                                   PN_TING out Number,
                                   PN_IVEN out Number,
                                   PN_OING out Number,
                                   PN_UNET out Number,
                                   PN_RNET out Number,
                                   PN_TPAS out Number,
                                   PN_TPAT out Number,
                                   PN_CCAJ out Number,
                                   PN_EXCM out Number
                                  )   
                                  
 Is
   ln_ingbru number(17,2);
   ln_condir number(17,2);
   ln_concon number(17,2);
   ln_cuocon number(12,2);
   ln_numcre number(10);
   ln_numlin number(10);
   ln_salcap number(12,2);
   
 Begin
 
      
      begin  
        select
        sum(
          case when bcmod=141 then -(decode(bcmda,0,max(cu.bcsdmn),max(cu.bcsdmn)*max(tcames))* 0.01)
               else decode(bcmda,0,max(mtocuo),max(mtocuo)*max(tcames)) 
          end)
        into PN_CCAJ
        from jaqy490t cu
        where bcfech = PD_FECHA
        and pepais = PN_PAIS
        and petdoc = PN_TDOC
        and pendoc = PC_NDOC
        and (cu.bcrubr like '14%' /*or cu.bcmod=141*/) --p1864
        group by cu.bcemp, cu.bcmod, cu.bcsuc, cu.bcmda, cu.bcpap, cu.bccta, cu.bcoper, cu.bcsbop, cu.bctop; 
      exception when others then
         PN_CCAJ := 0;
      end;
      
 
      If PN_CSEG = 1 Then 
         Begin  
               Select * 
                 Into PN_INST, PN_NEVA, PD_FEVA,
                      PN_TING, PN_IVEN, PN_OING, PN_UNET, PN_RNET, PN_TPAS, PN_TPAT,ln_ingbru,
                      ln_numcre,ln_numlin,ln_salcap 
                 From (
                select numins,numeva,feceva,
                       toting, ingven,otring,utinet,resnet,totpas,totpat,
                       nvl(ingven,0)+nvl(otring,0) ingbru,
                       count(*) over (partition by pepais,petdoc,pendoc),
                       sum(case when bcmod=117 then 1 else 0 end) over (partition by pepais,petdoc,pendoc),
                       sum(case when bcmod=117 then bcsdmn else 0 end ) over (partition by pepais,petdoc,pendoc) 
                  from jaqy490t  u
                 where bcfech = PD_FECHA 
                   and pepais = PN_PAIS
                   and petdoc = PN_TDOC
                   and pendoc = PC_NDOC
                   and bcmod <> 141 --p1864
                 Order by feceva desc nulls last, numeva desc nulls last 
                ) 
                Where rownum = 1; 
         Exception When Others Then
             Null;
         End;    
                  

         If nvl(PN_IVEN,0) <= 4800 Then
            PN_SSBR := 1;
         ElsIf nvl(PN_IVEN,0) <= 19800 Then
            PN_SSBR := 2;
         Else 
            PN_SSBR := 3;
         End If;                  
         
      ElsIf PN_CSEG = 2 Then 
            PN_FOIN := 0;
            PN_SDEP := 2;
            Begin
               Select * 
                 Into PN_INST, PN_NEVA, PD_FEVA,
                      PN_TING, PN_IVEN, PN_OING, PN_UNET, PN_RNET, PN_TPAS, PN_TPAT, PN_EXCM,
                      ln_condir,ln_concon, ln_cuocon,
                      ln_numcre,ln_numlin,ln_salcap  
                 From (
                      Select numins,numeva,feceva,toting, ingven,otring,utinet,resnet,totpas,totpat,excmen,
                             -sum(case when bcgpo=3 and bcrubr like '14%' and bcrubr not like '14__030605%' and bcrubr not like '14__030305%'  then bcsdmn else 0 end) over (partition by pepais,petdoc,pendoc)  scondir,  --se grego rubro 0303
                             -sum(case when bcgpo=3 and bcrubr like '14%' and (bcrubr like '14__030605%' or bcrubr like '14__030305%') then bcsdmn else 0 end) over (partition by pepais,petdoc,pendoc)  sconcon, --se agrego rubro 0303
                             sum(case when bcgpo=3 and bcrubr like '14%' and (bcrubr like '14__030605%' or bcrubr like '14__030305%') and nvl(numcuo,0) = 1 and nvl(ndiacu,0)>60 --se agrego rubro 0303
                                      then decode(bcmda,0,mtocuo,mtocuo*tcames)/nvl(nmescu,0) 
                                      when bcgpo=3 and bcrubr like '14%' and (bcrubr like '14__030605%' or bcrubr like '14__030305%' ) --se agrego rubro 0303
                                      then decode(bcmda,0,mtocuo,mtocuo*tcames) else 0 
                                  end) over (partition by pepais,petdoc,pendoc),
                             count(*) over (partition by pepais,petdoc,pendoc),
                             sum(case when bcmod=117 then 1 else 0 end) over (partition by pepais,petdoc,pendoc),
                             sum(case when bcmod=117 then bcsdmn else 0 end) over (partition by pepais,petdoc,pendoc)
                        from jaqy490t 
                       where bcfech = PD_FECHA 
                         and pepais = PN_PAIS
                         and petdoc = PN_TDOC
                         and pendoc = PC_NDOC
                         and bcmod <> 141 --p1864 
                       Order by feceva desc nulls last,numeva desc nulls last
                       ) 
                Where rownum = 1;
            Exception When Others Then
                Null;
            End;  
            
            
            If nvl(ln_condir,0) < nvl(ln_concon,0) Then
               PN_SDEP := 3;
               
            End If;    
            
            If NVL(PN_OING,0) > 0 Then
               PN_FOIN := 1;
            End If;      
      End If;
      
      If nvl(ln_numcre,0) = nvl(ln_numlin,0) Then
            PN_CCAJ := nvl(ln_salcap,0) * 0.09; 
      End If;
       
 End sp_variables_evaluacion; 
 
 Function fn_monto_cuota (PN_PGCOD in Number,
                          PN_MOD   in Number,
                          PN_SUC   in Number,
                          PN_MDA   in Number,
                          PN_PAP   in Number,
                          PN_CTA   in Number,
                          PN_OPE   in Number,
                          PN_SBO   in Number,
                          PN_TOP   in Number,
                          PD_FEC   in Date
                          )
 Return Number
 Is
   ln_mtocuo number(12,2);
   ln_mtoseg number(12,2);
--   ln_suc    number(3);
   ld_fecpag date;
 Begin
      Begin
        Select ppfpag,mtocuo
          Into ld_fecpag,ln_mtocuo
          From (
                select p.ppfpag,nvl(p.ppcap,0) + nvl(p.ppint,0) mtocuo
                  from fsd601 p
                 where p.pgcod = PN_PGCOD
                   and p.ppmod = PN_MOD
                   and p.ppsuc = PN_SUC
                   and p.ppmda = PN_MDA
                   and p.pppap = PN_PAP
                   and p.ppcta = PN_CTA
                   and p.ppoper= PN_OPE
                   and p.ppsbop= PN_SBO
                   and p.pptope= PN_TOP
                   and p.d601co= 'S'
                   and (p.ppcap + p.ppint ) > 0
                   and not exists (Select 1 From fsd602 c
                                     Where c.pgcod = p.pgcod
                                       and c.ppmod = p.ppmod
                                       and c.ppsuc = p.ppsuc
                                       and c.ppmda = p.ppmda
                                       and c.pppap = p.pppap
                                       and c.ppcta = p.ppcta
                                       and c.ppoper= p.ppoper
                                       and c.ppsbop= p.ppsbop
                                       and c.pptope= p.pptope
                                       and c.ppfpag= p.ppfpag
                                       and c.pptipo= p.pptipo
                                       and c.pp1stat= 'T'
                                       and c.d602co = 'S'
                                       and c.d602fc <= PD_FEC)
                 Order by p.ppfpag
                )
        Where Rownum=1;
--        ln_suc := PN_SUC;
      Exception
      When No_Data_Found Then
           Begin
              Select ppfpag,mtocuo
                Into ld_fecpag,ln_mtocuo
                From (
                      select p.ppfpag,nvl(p.ppcap,0) + nvl(p.ppint,0) mtocuo
                        from fsd601 p
                       where p.pgcod = PN_PGCOD
                         and p.ppmod = PN_MOD
                         and p.ppmda = PN_MDA
                         and p.pppap = PN_PAP
                         and p.ppcta = PN_CTA
                         and p.ppoper= PN_OPE
                         and p.ppsbop= PN_SBO
                         and p.pptope= PN_TOP
                         and p.d601co= 'S'
                         and (p.ppcap + p.ppint ) > 0
                         and not exists (Select 1 From fsd602 c
                                           Where c.pgcod = p.pgcod
                                             and c.ppmod = p.ppmod
                                             and c.ppsuc = p.ppsuc
                                             and c.ppmda = p.ppmda
                                             and c.pppap = p.pppap
                                             and c.ppcta = p.ppcta
                                             and c.ppoper= p.ppoper
                                             and c.ppsbop= p.ppsbop
                                             and c.pptope= p.pptope
                                             and c.ppfpag= p.ppfpag
                                             and c.pptipo= p.pptipo
                                             and c.pp1stat= 'T'
                                             and c.d602co = 'S'
                                             and c.d602fc <= PD_FEC)
                       Order by p.ppfpag
                      );
           Exception When Others Then
                ln_mtocuo := 0;
           End;
      When Others Then
         ln_mtocuo := 0;
      End;
/*
      Begin
        select sum(nvl(s.ppimp10,0)+nvl(s.ppimp11,0)+nvl(s.ppimp12,0))
          into ln_mtoseg
          from fsd611 s
         where s.pgcod = PN_PGCOD
           and s.ppmod = PN_MOD
           and s.ppsuc = ln_suc
           and s.ppmda = PN_MDA
           and s.pppap = PN_PAP
           and s.ppcta = PN_CTA
           and s.ppoper= PN_OPE
           and s.ppsbop= PN_SBO
           and s.pptope= PN_TOP
           and s.ppfpag= ld_fecpag;
      Exception When Others Then
         ln_mtoseg := 0;
      End;
*/
      Return (nvl(ln_mtocuo,0) + nvl(ln_mtoseg,0));

 End fn_monto_cuota; 

 Procedure sp_cantidad_cuotas (PN_PGCOD in Number,
                               PN_MOD   in Number,
                               PN_MDA   in Number,
                               PN_PAP   in Number,
                               PN_CTA   in Number,
                               PN_OPE   in Number,
                               PN_SBO   in Number,
                               PN_TOP   in Number,
                               PN_NCUO out Number,
                               PF_FVAL out Date,
                               PF_FPAG out Date,
                               PN_DIAS out Number,
                               PN_NMES out Number
                              )        
 Is
 Begin 
             
      Select count(*), 
        MIN(p.ppfpag) KEEP (DENSE_RANK FIRST ORDER BY p.ppfpag),
        MIN(p.ppfval) KEEP (DENSE_RANK FIRST ORDER BY p.ppfpag)
        Into PN_NCUO,PF_FPAG,PF_FVAL
        from fsd601 p
       where p.pgcod = PN_PGCOD
         and p.ppmod = PN_MOD
         --and p.ppsuc = PN_SUC
         and p.ppmda = PN_MDA
         and p.pppap = PN_PAP
         and p.ppcta = PN_CTA
         and p.ppoper= PN_OPE
         and p.ppsbop= PN_SBO
         and p.pptope= PN_TOP
         and p.d601co= 'S'; 
       
       PN_DIAS := ROUND(PF_FPAG-PF_FVAL,0);
       PN_NMES := ROUND(MONTHS_BETWEEN(PF_FPAG,PF_FVAL),0);   
 End sp_cantidad_cuotas; 
                 
 Procedure sp_variables_conyuge(PD_FECHA in Date,
                                PN_PAIS in Number,
                                PN_TDOC in Number,
                                PC_NDOC in Char,
                                PN_PAISC out Number,
                                PN_TDOCC out Number,
                                PC_NDOCC out Varchar2,
                                PC_CSBSC out Varchar2,
                                PN_CCAJ out Number,
                                PN_CUOPOT out Number,
                                PN_CUOSIF out Number,
                                PN_LINTAR out Number,
                                PN_DEUTOT out Number,
                                PN_SALDEU out Number,
                                PN_SUT out Number,
                                PN_SUN out Number,                                 
                                PN_LCN out Number,
                                PN_LTN out Number,
                                PN_PMR out Number,
                                PN_LTP out Number,
                                PN_LNP out Number
                               )  
 Is
   ln_rppais fsr002.rppais%type;
   ln_rptdoc fsr002.rptdoc%type;
   lc_rpndoc fsr002.rpndoc%type;
   ln_jaqy490seg jaqy490s.jaqy490seg%type;
   ln_jaqy490nre jaqy490s.jaqy490nre%type;
   
   ln_inst number(9); 
   ln_neva number(9);
   ld_feva date; 
   ln_ssbr number(1);
   ln_sdep number(1); 
   ln_foin number(1);
   ln_ting number(17,2); 
   ln_iven number(17,2);
   ln_oing number(17,2); 
   ln_unet number(17,2);
   ln_rnet number(17,2); 
   ln_tpas number(17,2);
   ln_tpat number(17,2);

   ln_monltc number(20,5); 
   ln_varsde number(20,5);
   ln_varnen number(20,5); 
   ln_numens number(20,5);
   ln_cuooco number(20,5);
   ln_nument number(20,5);

   ld_fecrcc date;   
   
   ln_excmen number(17,2); 
   ln_verest char(1);
   
 begin

   PN_CCAJ := 0;
   PN_CUOPOT := 0;
   PN_CUOSIF := 0;
      
   begin  
   
     select rppais, rptdoc, rpndoc
     into ln_rppais, ln_rptdoc, lc_rpndoc      
     from fsr002 r 
     where r.pepais = PN_PAIS 
     and r.petdoc = PN_TDOC 
     and r.pendoc = PC_NDOC 
     and rpccyg = 66;
     
     if ln_rppais is not null then
       
       PN_PAISC := ln_rppais; 
       PN_TDOCC := ln_rptdoc; 
       PC_NDOCC := lc_rpndoc;
     
       begin
         select s.jaqy490seg, s.jaqy490nre
         into ln_jaqy490seg, ln_jaqy490nre
         from jaqy490s s 
         where s.jaqy490fec = PD_FECHA 
         and s.jaqy490pai = ln_rppais 
         and s.jaqy490tdo = ln_rptdoc 
         and s.jaqy490ndo = lc_rpndoc;
       exception when no_data_found then
         select s.jaqy490seg
         into ln_jaqy490seg
         from jaqy490s s 
         where s.jaqy490fec = PD_FECHA 
         and s.jaqy490pai = PN_PAIS 
         and s.jaqy490tdo = PN_TDOC 
         and s.jaqy490ndo = PC_NDOC;         
       end;
            
       if ln_jaqy490seg is not null then
         
         PQ_SOBEND_SEG.sp_variables_evaluacion(PD_FECHA,
                                               ln_rppais,ln_rptdoc,
                                               lc_rpndoc,ln_jaqy490seg,
                                               -------------------------              
                                               ln_inst, ln_neva,
                                               ld_feva, ln_ssbr,
                                               ln_sdep, ln_foin,
                                               ln_ting, ln_iven,
                                               ln_oing, ln_unet,
                                               ln_rnet, ln_tpas,
                                               ln_tpat, PN_CCAJ, ln_excmen);
         if PN_CCAJ is null then
           PN_CCAJ := 0;           
         end if;
         
       end if;
       
       PQ_SOBEND_RCC.sp_retorna_variables_seg((case when ln_jaqy490seg=1 then ln_jaqy490seg
                                              else 2
                                              end),
                                              ln_rptdoc,
                                              trim(lc_rpndoc),
                                              ---------------------                                              
                                              PN_CUOPOT, PN_LINTAR,
                                              ln_monltc, ln_varsde,
                                              ln_varnen, ln_numens,
                                              PN_DEUTOT, ln_cuooco,
                                              ln_nument, PN_CUOSIF, PN_SALDEU, PN_SUT, PN_SUN, PN_LCN, PN_LTN, PN_PMR, PN_LTP, PN_LNP,
                                              PC_CSBSC, ld_fecrcc);

       PQ_SOBEND_RCC.SP_VERIFICA_ESTADO(ln_rptdoc,
                                        trim(lc_rpndoc),
                                        ln_verest
                                       );
       
       if ln_verest is null then

         PQ_SOBEND_SEG.sp_cuotasf_lineatc(ln_jaqy490seg,
                                          PN_CUOSIF,
                                          PN_SUN+PN_PMR,
                                          PN_LTN,
                                          PN_PMR,
                                          PN_LNP,
                                          PN_CUOSIF,
                                          PN_CUOPOT
                                         );
                                         
         PQ_SOBEND_RCC.sp_actualiza_variables(ln_rptdoc,
                                              trim(lc_rpndoc),
                                              PN_CUOPOT,
                                              PN_CUOSIF
                                              );                                       
       end if;
         
     end if;

   exception when others then
     PN_CCAJ := 0;
     PN_CUOPOT := 0;
     PN_CUOSIF := 0;
   end;
 
 end sp_variables_conyuge; 

 procedure sp_evalua_criterios(PN_TIPSEG in number,
                               PN_VALVAR11 in number,
                               PN_VALVAR12 in number,          
                               PN_VALVAR13 in number,
                               PN_VALVAR14 in number,
                               PN_VALVAR21 in number,
                               PN_VALVAR22 in number,          
                               PN_VALVAR23 in number,
                               PN_VALVAR24 in number,
                               PN_VALVAR31 in number,
                               PN_VALVAR32 in number,          
                               PN_VALVAR33 in number,
                               PN_VALVAR34 in number,
                               PN_VALVAR41 in number,
                               PN_VALVAR42 in number,          
                               PN_VALVAR43 in number,
                               PN_VALVAR44 in number,
                               PN_VALCRI1 out number,
                               PN_VALCRI2 out number,
                               PN_VALCRI3 out number,
                               PN_VALCRI4 out number,
                               PN_VALSOB out number
                               )
 is
 
   cursor c_criterios
   is select tp1corr2, tp1corr3, trim(tp1desc) tp1desc, tp1imp1
   from fst198 e 
   where e.tp1cod = 1 and e.tp1cod1 = 11121 and e.tp1corr1 = PN_TIPSEG
   order by e.tp1cod, e.tp1cod1, e.tp1corr1, e.tp1corr2, e.tp1corr3; 
 
   ln_valvar number(20,5);
   ln_cancri1 number(1) := 0;
   ln_cancri2 number(1) := 0;
   ln_cancri3 number(1) := 0;
   ln_cancri4 number(1) := 0;
   ln_vrfcri1 number(1) := 0;
   ln_vrfcri2 number(1) := 0;
   ln_vrfcri3 number(1) := 0;
   ln_vrfcri4 number(1) := 0;   
   lc_vrfcri char(1);
 
 begin

   PN_VALCRI1 := 0;
   PN_VALCRI2 := 0;
   PN_VALCRI3 := 0;
   PN_VALCRI4 := 0;
   PN_VALSOB := 0;

   for x in c_criterios loop
     
     case
       when x.tp1corr2 = 1 and x.tp1corr3 = 1 then ln_valvar := PN_VALVAR11; ln_cancri1 := ln_cancri1 + 1;
       when x.tp1corr2 = 1 and x.tp1corr3 = 2 then ln_valvar := PN_VALVAR12; ln_cancri1 := ln_cancri1 + 1;
       when x.tp1corr2 = 1 and x.tp1corr3 = 3 then ln_valvar := PN_VALVAR13; ln_cancri1 := ln_cancri1 + 1;
       when x.tp1corr2 = 1 and x.tp1corr3 = 4 then ln_valvar := PN_VALVAR14; ln_cancri1 := ln_cancri1 + 1;
       when x.tp1corr2 = 2 and x.tp1corr3 = 1 then ln_valvar := PN_VALVAR21; ln_cancri2 := ln_cancri2 + 1;
       when x.tp1corr2 = 2 and x.tp1corr3 = 2 then ln_valvar := PN_VALVAR22; ln_cancri2 := ln_cancri2 + 1;
       when x.tp1corr2 = 2 and x.tp1corr3 = 3 then ln_valvar := PN_VALVAR23; ln_cancri2 := ln_cancri2 + 1;
       when x.tp1corr2 = 2 and x.tp1corr3 = 4 then ln_valvar := PN_VALVAR24; ln_cancri2 := ln_cancri2 + 1;
       when x.tp1corr2 = 3 and x.tp1corr3 = 1 then ln_valvar := PN_VALVAR31; ln_cancri3 := ln_cancri3 + 1;
       when x.tp1corr2 = 3 and x.tp1corr3 = 2 then ln_valvar := PN_VALVAR32; ln_cancri3 := ln_cancri3 + 1;
       when x.tp1corr2 = 3 and x.tp1corr3 = 3 then ln_valvar := PN_VALVAR33; ln_cancri3 := ln_cancri3 + 1;
       when x.tp1corr2 = 3 and x.tp1corr3 = 4 then ln_valvar := PN_VALVAR34; ln_cancri3 := ln_cancri3 + 1;
       when x.tp1corr2 = 4 and x.tp1corr3 = 1 then ln_valvar := PN_VALVAR41; ln_cancri4 := ln_cancri4 + 1;
       when x.tp1corr2 = 4 and x.tp1corr3 = 2 then ln_valvar := PN_VALVAR42; ln_cancri4 := ln_cancri4 + 1;
       when x.tp1corr2 = 4 and x.tp1corr3 = 3 then ln_valvar := PN_VALVAR43; ln_cancri4 := ln_cancri4 + 1;
       when x.tp1corr2 = 4 and x.tp1corr3 = 4 then ln_valvar := PN_VALVAR44; ln_cancri4 := ln_cancri4 + 1;
     end case;
     
     lc_vrfcri := 'N';
     case x.tp1desc
       when '<' then if ln_valvar < x.tp1imp1 then lc_vrfcri := 'S'; end if;
       when '<=' then if ln_valvar <= x.tp1imp1 then lc_vrfcri := 'S'; end if;
       when '=' then if ln_valvar = x.tp1imp1 then lc_vrfcri := 'S'; end if;
       when '>' then if ln_valvar > x.tp1imp1 then lc_vrfcri := 'S'; end if;
       when '>=' then if ln_valvar >= x.tp1imp1 then lc_vrfcri := 'S'; end if;
     end case;
   
     if lc_vrfcri = 'S' then
       case x.tp1corr2
         when 1 then ln_vrfcri1 := ln_vrfcri1 + 1;
         when 2 then ln_vrfcri2 := ln_vrfcri2 + 1;
         when 3 then ln_vrfcri3 := ln_vrfcri3 + 1;
         when 4 then ln_vrfcri4 := ln_vrfcri4 + 1;                  
       end case;
     end if;
   
   end loop;

   if ln_cancri1 > 0 and ln_cancri1 = ln_vrfcri1 then PN_VALCRI1 := 1; end if;
   if ln_cancri2 > 0 and ln_cancri2 = ln_vrfcri2 then PN_VALCRI2 := 1; end if;
   if ln_cancri3 > 0 and ln_cancri3 = ln_vrfcri3 then PN_VALCRI3 := 1; end if;
   if ln_cancri4 > 0 and ln_cancri4 = ln_vrfcri4 then PN_VALCRI4 := 1; end if;         

   if PN_VALCRI3 + PN_VALCRI4 >= 1 then PN_VALSOB := 2; end if;   
   if PN_VALCRI1 + PN_VALCRI2 >= 1 then PN_VALSOB := 1; end if;
    
 exception when others then
   --dbms_output.put_line(SQLERRM);
   PN_VALCRI1 := 0;
   PN_VALCRI2 := 0;
   PN_VALCRI3 := 0;
   PN_VALCRI4 := 0;
   PN_VALSOB := 0;
 end sp_evalua_criterios;                      

 procedure sp_cuotasf_lineatc(PC_CSEG in char,
                              PN_CUOSIF in number,
                              PN_SUN in number,
                              PN_LTN in number,
                              PN_LTP in number,
                              PN_LNP in number,                              
                              PN_CUOSFLN out number,
                              PN_CUOPOT out number
                              )
 is

   ln_utilin number(20,5);
   ln_facltn number(20,5);
   ln_cuoltn number(20,5);
   ln_cuolta number(20,5);
   
   ln_cuolpr number(20,5);
   ln_utilpr number(20,5);         
  
   cursor c_factores
   is select tp1nro2, tp1nro3, tp1imp1, tp1imp2, tp1imp3 
   from fst198 e where e.tp1cod = 1 and e.tp1cod1 = 11121 and e.tp1corr1 = 1;   
   
   cursor c_factores1
   is select tp1nro2, tp1nro3, tp1imp1, tp1imp2, tp1imp3 
   from fst198 e where e.tp1cod = 1 and e.tp1cod1 = 11121 and e.tp1corr1 = 3;   
 
 begin
   
   begin
     select fac1*fac2*PN_LTN 
     into ln_cuolta
     from (
      select 
      sum((case when e.tp1corr3 = 1 then e.tp1imp1/e.tp1imp2 end)) fac1,
      sum((case when e.tp1corr3 = 2 then e.tp1imp1/e.tp1imp2 end)) fac2
      from fst198 e where e.tp1cod = 1 and e.tp1cod1 = 11000 and e.tp1corr1 = 1 and e.tp1corr2 = 1 and e.tp1corr3 > 0
     );
   exception when others then
     ln_cuolta := 0.044*0.2*PN_LTN;
   end;
   
   ln_utilin := (PN_SUN*100)/(PN_SUN+PN_LTN);
   
   for f in c_factores loop   
     
     if ln_utilin >= f.tp1nro2 and ln_utilin < f.tp1nro3 then
       
        case PC_CSEG
          when '1' then ln_facltn := f.tp1imp3*0.01;
          when '2' then ln_facltn := f.tp1imp2*0.01;
        end case;
        
        ln_cuoltn := (f.tp1imp1*0.001)*ln_facltn*PN_LTN;
        PN_CUOPOT := ln_cuoltn;
        PN_CUOSFLN := PN_CUOSIF - ln_cuolta + ln_cuoltn;
                
        exit;
     end if;   
     
   end loop;
   
   
   ln_utilpr := (PN_LTP*100)/(PN_LTP+PN_LNP);
   
   for f in c_factores1 loop   
     
     if ln_utilpr >= f.tp1nro2 and ln_utilpr < f.tp1nro3 then
       
        case PC_CSEG
          when '1' then ln_facltn := f.tp1imp3*0.01;
          when '2' then ln_facltn := f.tp1imp2*0.01;
        end case;
        
        ln_cuolpr := (f.tp1imp1*0.001)*ln_facltn*PN_LNP;
        PN_CUOSFLN := PN_CUOSIF + ln_cuolpr;
                
        exit;
     end if;   
     
   end loop;      
    
 exception when others then
   PN_CUOSFLN := PN_CUOSIF;
 end sp_cuotasf_lineatc;

 Procedure sp_cuota_contingente(PD_FECHA in Date,
                                PN_PAIS in Number,
                                PN_TDOC in Number,
                                PC_NDOC in Char,
                                PN_CCON out Number
                               )   
                                  
 Is
   ln_numins number(9);
   ln_salcfi number(17,2);
   ln_salava number(17,2);
 Begin
      
   begin  
     select
     max(t.numins)
     into ln_numins
     from jaqy490t t
     where bcfech = PD_FECHA
     and pepais = PN_PAIS
     and petdoc = PN_TDOC
     and pendoc = PC_NDOC;
   exception when others then
     ln_numins := 0;
   end;
 
   pq_cr_resolutor_cappago.sp_cr_CuotaContinCF(ln_numins,PD_FECHA,'C',ln_salcfi);
   pq_cr_resolutor_cappago.sp_cr_CuotaContinAval(ln_numins,PD_FECHA,'C',ln_salava);
 
   PN_CCON := ln_salcfi + ln_salava;
  
 Exception when others then
   PN_CCON := 0;
 End sp_cuota_contingente; 
    
End PQ_SOBEND_SEG;
/

