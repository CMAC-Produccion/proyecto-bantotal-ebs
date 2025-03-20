create or replace package PQ_OP_DESEMBOLSO is
 
    -- *****************************************************************
    -- Nombre                     :PROCESO DE REGULARIZACION CUPONES - CAMPAÑA NAVIDAD 2015
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.11.20
    -- Autor de Creación          : MSOLARI 
    -- Uso                        : GENERACION DE DATA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_Verificacion_Fecha( pc_uing in varchar2,pd_fecha in date);
 Procedure sp_Inserta(pc_uing in varchar2, pd_fecha in date);
 Procedure sp_Excepciones(modulo in number,ln_suc1 in number,ln_mda1 in number,ln_cta1 in number,ln_oper1 in number,ln_sbop1 in number,ittope in number,ln_scrub1 in number,ln_scstat1 in number, FlgIncl out char);
 function fn_Tipocliente(pd_fecha in date)return date;
 function fn_Calificacion(ln_paic in number, ln_tdoc in number, lc_tndoc in char, ld_cliente in date)return number;
 function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char;
 function fn_Calif_SBS_Cliente(lc_docsbs in char,lc_tndoc in char) return number;
                               
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_OP_DESEMBOLSO;
/

create or replace package body PQ_OP_DESEMBOLSO is
    -- *****************************************************************
    -- Nombre                     : PROCESO DE REGULARIZACION CUPONES - CAMPAÑA NAVIDAD 2015
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.11.20
    -- Autor de Creación          : MSOLARI 
    -- Uso                        : GENERACION DE DATA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_Verificacion_Fecha( pc_uing in varchar2,pd_fecha in date) is
 
 ld_FchI date;
 ld_FchF date;
 
 Begin
   Begin
   --************************** cambiar formato ******************
     select '0'||Tp1nro1 ||'/'||'0'|| Tp1nro2 ||'/'|| Tp1nro3, --fech_inicio,
            --Tp1imp1 ||'/'||'0'|| Tp1imp2 ||'/'|| Tp1imp3 --fech_fin +
              Tp1imp1 ||'/'||Tp1imp2 ||'/'|| Tp1imp3
    --************************** cambiar formato ******************              
       into ld_FchI, ld_FchF          
       from FST198
       Where Tp1cod   = 1
         and Tp1cod1  = 10871
         and Tp1corr1 = 4
         and Tp1corr2 = 1
         and Tp1corr3 = 1;
         
      If (pd_fecha >= ld_FchI and pd_fecha >= ld_FchI) then
           pq_op_desembolso.sp_Inserta(pc_uing,pd_fecha);
           
      End If;
   End;
 end sp_Verificacion_Fecha; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_Excepciones(modulo in number, ln_suc1 in number, ln_mda1 in number, ln_cta1 in number, ln_oper1 in number, ln_sbop1 in number, ittope in number, ln_scrub1 in number,ln_scstat1 in number, FlgIncl out char) is
 
 ld_FchI date;
 ld_FchF date;
 ln_rcta number(9);
 
 Begin
   Begin   
    
    FlgIncl := 'S' ;  
    
    ---créditos prendarios
    If modulo = 108 And ittope= 1 then
        FlgIncl := 'N' ;
    End If;

    --créditos judiciales
    If modulo = 200 then
        FlgIncl := 'N' ;
    End If;

    --créditos administrativos
    If modulo = 106 And ( ittope = 30 Or ittope = 31 ) then
        FlgIncl := 'N' ;
    End If;

    --consumo para trabajadores -- Tipos de Operacion de Trabajador CMAC Arequipa.
    If modulo = 106 And ( ittope = 10 Or ittope = 11 Or ittope = 32 Or ittope = 33 Or ittope = 34 ) then
       FlgIncl := 'N' ;
    End If;

    --créditos hipotecarios para trabajadores c/cts s/cts -- Tipos de Operacion de Trabajador CMAC Arequipa.
    If modulo = 110 And ( ittope = 20 Or ittope = 21 Or ittope = 22 Or ittope = 23 Or ittope = 24 Or ittope = 25 Or ittope = 26 Or ittope = 27 Or ittope = 84 Or ittope = 85 Or ittope = 86 Or ittope = 87) then
       FlgIncl := 'N' ;
    End If;

    --créditos reprogramados 
    begin
        select distinct R2cta
        into ln_rcta
        from FSR011
        Where R1cod  = 1 
        and R1mod  = modulo
        and R1suc  = ln_suc1
        and R1mda  = ln_mda1
        and R1pap  = 0
        and R1cta  = ln_cta1
        and R1oper = ln_oper1 
        and R1sbop = ln_sbop1
        and R1tope = ittope
        and Relcod in (860, 870) --Reprog. Cambio de Fecha-860 / Reprog. Desastres Naturales-870
        and R2mod  = modulo;
             FlgIncl := 'N' ;
       exception when no_data_found then 
             ln_rcta := 0;
             FlgIncl := 'S' ; 
     end; 
                 
     begin
        --créditos con garantía de plazo fijo o cts
        Select distinct R2cta
        into ln_rcta
        from FSR011
        Where R1cod  = 1 
        and R1mod  = modulo
        and R1suc  = ln_suc1
        and R1mda  = ln_mda1
        and R1pap  = 0
        and R1cta  = ln_cta1
        and R1oper = ln_oper1 
        and R1sbop = ln_sbop1
        and R1tope = ittope
        and Relcod = 50
        and R2mod  = 70
        /*and ( R2tope = 80 Or R2tope = 85 );*/
        and R2tope in (80, 85 )
        and rownum<2;
            FlgIncl := 'N' ;
       exception when no_data_found then 
            ln_rcta := 0;
            FlgIncl := 'S' ;          
     end;       
    --créditos consumo convenios
   /* If Scgru = 3 And modulo = 107 then
         FlgIncl := 'N' ;
    End If;*/

    --créditos refinanciados
    If Trim(ln_scrub1) like '14_4%' And ln_scstat1 = 61 then
         FlgIncl := 'N' ;
    End If;

    --creditos Vehicular Nvo Trabajador c/CTS  ---Tipos de Operacion de Trabajador CMAC Arequipa.
    If modulo = 112 And ( ittope = 65 Or ittope = 66 Or ittope = 70 Or ittope = 71 ) then
         FlgIncl := 'N' ;
    End If;
      
   End;
 end sp_Excepciones; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_Inserta(pc_uing in varchar2, pd_fecha in date) is

 ln_tran number:=951;
 ln_modu number:=30;
 
  
 Cursor data1 is 

      select /*+all_rows*/
             distinct f10.aomod,
                      f10.aosuc,
                      f10.aomda,
                      f10.aocta,
                      f10.aooper,
                      f10.aosbop,
                      f10.aotope,
                      f8.pepais,
                      f8.petdoc,
                      f8.pendoc,
                      f11.scrub,
                      f11.scstat
      from fsd010 f10, fsd011 f11, Fsr008 f8, fst111 fs11
      where f10.pgcod  =1
      and f11.pgcod  = f10.pgcod 
      and f10.aomod  = fs11.modulo
      and f11.scmod  = f10.aomod
      and f11.scsuc  = f10.aosuc 
      and f11.scmda  = f10.aomda 
      and f11.scpap  = f10.aopap
      and f11.sccta  = f10.aocta 
      and f11.scoper = f10.aooper
      and f11.scsbop = f10.aosbop
      and f11.sctope = f10.aotope
      and f10.aofval = pd_fecha
      and (f10.aomod in (select modulo
                         from fst111
                         where dscod = 50))
      and f11.scgru in ( 2, 3 , 4 , 12 , 13 )-- //micro, consumo, hipotecario, mediana, pequeña empresa
      and f8.ctnro  = f11.sccta
      and f8.cttfir = 'T'
      and fs11.dscod = 50;     

    Cursor data2 (ln_mod number, ln_suc number, ln_mda number, ln_cta number, ln_oper number, ln_sbop number, ln_tope number)is
         select h.hmodul JAQY774Mod,
                h.hsucur JAQY774Suc,
                h.hmda   JAQY774Mda,
                h.hcta   JAQY774Cta,
                h.hoper  JAQY774Ope,
                h.hcsubo JAQY774Sbo,
                h.htoper JAQY774Top,
                h.htran  JAQY774TTRAN,
                h.hcmod  JAQY774TMOD,
                h.hnrel  JAQY774TNREL,
                h.hcord  JAQY774TORD,
                h.hsucor JAQY774TSUC,
                h.hcsubo JAQY774TSBOR,
                h.pgcod  JAQY774PGC,
                h.hpap   JAQY774PAP,
                lpad(trim(to_char(h.hcta)), 9, '0') ||
                            lpad(trim(to_char(h.hcmod)), 3, '0') ||
                            lpad(trim(to_char(h.hoper)), 9, '0') CREDITO,
                (select r2.regcod
                  from fst810 r2, fst811 r
                  where r2.pgcod  = r.pgcod
                   and r2.regcod = r.regcod
                   and r.pgcod = 1 
                   and r.oficod = h.hsucur
                   and r2.regcod<100)REGION
          from fsh016 h
         where h.pgcod  = 1
           and h.hcmod  = ln_modu
           and h.htran  = ln_tran
           and h.hmodul = ln_mod
           and h.hsucur = ln_suc
           and h.hmda   = ln_mda
           and h.hcta   = ln_cta
           and h.hoper  = ln_oper
           and h.hsubop = ln_sbop
           and h.htoper = ln_tope;
            
    ln_sbop number(3);
    ln_tope number(3);  
    ln_cta  NUMBER(9);
    ln_mod  NUMBER(4);
    ln_mda  NUMBER(3);
    ln_oper NUMBER(9); 
    ln_suc  number(3);
    
    lc_Est     char(1);
    lc_Ant     char(1);
    ln_Atr     NUMBER(10);
    lc_Tip     char(1);
    lc_EXCUP   char(5);
    ld_fecha   date;
    lc_usuario char(10);
    FlgInc     char(1);
    
     modulo     number(3);
     ittope     number(3);
     ln_suc1    number(3);
     ln_mda1    number(4);
     ln_cta1    number(9);
     ln_oper1   number(9);
     ln_sbop1   number(3);
     ld_cliente date;
     
     ln_paic    number(3);
     ln_tdoc    number(2);
     lc_tndoc   char(12);
     ln_opcion  number(5);
     ln_scrub   number(16);
     ln_scstat  number(2);
     lc_docsbs  char(1);
     ln_calific number(10);
     ln_NUMP    NUMBER(9);
     ln_CUPNUM  NUMBER(10);
           
BEGIN     
    For j in data1 loop
         ln_mod  := j.aomod;
         ln_suc  := j.aosuc;
         ln_mda  := j.aomda; 
         ln_cta  := j.aocta; 
         ln_oper := j.aooper; 
         ln_sbop := j.aosbop;
         ln_tope := j.aotope;
         ln_scrub := j.scrub;
         
         ln_paic  := j.pepais;
         ln_tdoc  := j.petdoc;
         lc_tndoc := j.pendoc;
         ln_scstat := j.scstat;
         
      pq_op_desembolso.sp_Excepciones(ln_mod, ln_suc, ln_mda, ln_cta, ln_oper, ln_sbop, ln_tope,ln_scrub,ln_scstat,FlgInc );
      
      If FlgInc <> 'N' then
      ld_cliente := fn_Tipocliente( pd_fecha);
      ln_opcion  := fn_Calificacion(ln_paic, ln_tdoc, lc_tndoc, ld_cliente);
      
      If ln_opcion <>0 then
      
      lc_docsbs  := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
      ln_calific := fn_Calif_SBS_Cliente(lc_docsbs,lc_tndoc);
     
      If FlgInc <> 'N' and ln_calific = 1/*and ln_opcion <>0*/ then
      
       For i in data2 (ln_mod, ln_suc, ln_mda, ln_cta, ln_oper, ln_sbop, ln_tope) loop 
           lc_Tip   := 'D'; --&JAQY774Tip = 'D'
           lc_Est   := 'S'; --&JAQY774Est = 'S'
           lc_Ant   := 'N'; --&JAQY774Ant = 'N'
           lc_EXCUP := 'C';--&JAQY774ExCup = 'C'
           ln_Atr   := 0;
           --lc_usuario := 'm';--Upper(pc_uing); 
           ln_NUMP   := 0;
           ln_CUPNUM := 1;
           
           select to_char(sysdate,'dd/mm/rrrr')
            into ld_fecha
           from dual;               
       begin
           insert into JAQY774
           (    JAQY774Cup,
                JAQY774PGC,
                JAQY774Mod,
                JAQY774Suc,
                JAQY774Mda,
                JAQY774PAP,
                JAQY774Cta,
                JAQY774Ope,
                JAQY774Sbo,
                JAQY774Top,
                JAQY774CRE,
                JAQY774FEC,
                JAQY774FOP,
                JAQY774EST,
                JAQY774USR,
                JAQY774AGE,
                JAQY774DPT,
                JAQY774ANT,
                JAQY774ATR,
                JAQY774CAL,
                JAQY774TIP,
                JAQY774EXCUP,
                JAQY774TSBOR,
                JAQY774TORD,
                JAQY774TNREL,
                JAQY774TTRAN,
                JAQY774TMOD,
                JAQY774TSUC,
                JAQY774FCTA,
                JAQY774NUMP,
                JAQY774CUPNUM,
                JAQY774OPC)
            values 
            (   SQ_AH_JAQY774_1.NEXTVAL,
                i.jaqy774pgc,
                i.JAQY774Mod,
                i.JAQY774Suc,
                i.JAQY774Mda,
                i.jaqy774pap,
                i.JAQY774Cta,
                i.JAQY774Ope,
                i.JAQY774Sbo,
                i.JAQY774Top,
                i.credito,
                ld_fecha,
                pd_fecha,
                lc_Est,
                UPPER(pc_uing),
                i.JAQY774Suc,
                i.region,
                lc_Ant,
                ln_Atr,
                ln_calific,
                lc_Tip,
                lc_EXCUP,
                i.jaqy774tsbor,
                i.jaqy774tord,
                i.jaqy774tnrel,
                i.jaqy774ttran,
                i.jaqy774tmod,
                i.jaqy774tsuc,
                ld_fecha,
                ln_NUMP,
                ln_CUPNUM,
                ln_opcion);
          End; 
          commit;
       End loop;
       commit;
       End If;
       End If;
       End If;
     End loop;            
 end sp_Inserta; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 function fn_Tipocliente( pd_fecha in date) return date is
 
 ld_FProc date;
 
 Begin
   Begin
 /*  If pd_fecha >= '01/03/15' And pd_fecha <= '01/04/15' then --------Quitar
                 ld_FProc := '01/03/2015'; --- trabaja con el &Jaqy066pmes = 9
        Else
        If pd_fecha >= '02/04/15' And pd_fecha <= '01/05/15' then --------Quitar
                 ld_FProc := '01/04/2015'; --- trabaja con el &Jaqy066pmes = 9
        Else
        If pd_fecha >= '02/05/15' And pd_fecha <= '01/06/15' then --------Quitar
                 ld_FProc := '01/05/2015'; --- trabaja con el &Jaqy066pmes = 9
        Else*/
        
       If pd_fecha >= '01/09/15' And pd_fecha <= '01/10/15' then
                 ld_FProc := '01/09/2015'; --- trabaja con el &Jaqy066pmes = 9
       Else
         If pd_fecha >= '02/10/15' And pd_fecha <= '01/11/15' then
                   ld_FProc := '01/10/2015'; --- trabaja con el &Jaqy066pmes = 9
          Else
              If pd_fecha >= '02/11/15' And pd_fecha <= '01/12/15' then
                   ld_FProc := '01/11/2015'; --- trabaja con el &Jaqy066pmes = 10
              Else
                  If pd_fecha >= '02/12/15' And pd_fecha <= '01/01/16' then
                     ld_FProc := '01/12/2015'; --- trabaja con el &Jaqy066pmes = 11

                  End If;
              End If;
           End If;  
        End If;
/*      End If;
      End If;
      End If;*/
   End;
   return ld_FProc;
   
 end fn_Tipocliente; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 function fn_Calificacion(ln_paic in number, ln_tdoc in number, lc_tndoc in char, ld_cliente in date) return number is
 
 FlagC2  char(1);
 ln_calf number(5);
 ln_pano number(4);
 ln_pmes number(2);
 ln_cli  number(5);
 ln_nro1 number(9);
 ln_corr3 number:=0; --(9);
  
 --FlagC2  := 'N';
 Begin
 Begin
  Begin
  select jaqy066calf,
         jaqy066pano,
         jaqy066pmes
    into ln_calf,
         ln_pano,
         ln_pmes
    from Jaqy066
    Where jaqy066paic   = ln_paic
      and jaqy066tdoc   = ln_tdoc
      and jaqy066tndoc  = lc_tndoc
      and Jaqy066fecp   = ld_cliente; --ctod(&fecha99) --&FProc
      exception when no_data_found then 
          ln_pano := 0;      
      end;
                
        If ln_pano = 2015 then
           Begin
            select Tp1corr3
              into ln_corr3  
              from FST198
             Where Tp1cod   = 1
               and Tp1cod1  = 10871
               and Tp1corr1 = 1
               and Tp1corr2 > 5
               and Tp1nro1  = ln_calf;
            exception when no_data_found then 
                  ln_corr3 := 0; 
           end;
           ln_cli   := ln_corr3;
        End If;
         
   End; 
        
    return ln_cli;
         
  end fn_Calificacion;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char is
  
  C_TDOCID char(1);
  Petdoc number(3);
  Pendoc char(12);
  
 Begin
  Begin  
      C_TDOCID := '0';
      
      If ln_tdoc  = 21 then
        C_TDOCID := '1';
      End If;
      
      If ln_tdoc = 9 then
          If Length(lc_tndoc) < 11 then
            C_TDOCID := '2';
          End If;
          
          If Length(lc_tndoc) >= 11 then
            C_TDOCID := '3';
          End If;
      End If;

      If ln_tdoc = 2 then
        C_TDOCID := '2';
      End If;
      
      If ln_tdoc = 4 then
        C_TDOCID := '3';
      End If;
      
      If ln_tdoc = 15 then
        C_TDOCID := '4';
      End If;
      
      If ln_tdoc = 5 then
        C_TDOCID := '5';
      End If;
      
      If ln_tdoc = 6 then
        C_TDOCID := '8';
      End If;
  End;
  return C_TDOCID;
  end fn_Tipo_Doc_SBS; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 function fn_Calif_SBS_Cliente(lc_docsbs in char,lc_tndoc in char) return number is
 
 ln_FchSBS number(8);
 D_FECPRE  varchar2(15);
 ln_dia  number(2);
 ln_Mes  number(2);
 ln_Anio number(4);
 JAQY774Cal number(10);
 ln_cal0 number(5,2);
 ln_cal1 number(5,2);
 ln_cal2 number(5,2);
 ln_cal3 number(5,2);
 ln_cal4 number(5,2);
 D_FECPRE1 date;
 PNDOC    char(12);
 
 Begin
 Begin
   Begin
    select Tpnro      
      into ln_FchSBS          
      from FST098
     Where Pgcod  = 1
       and Tpcod  = 7647
       and Tpcorr = 12;
        
        ln_dia  := SubStr(ln_FchSBS,1,2);
        ln_Mes  := SubStr(ln_FchSBS,3,2);
        ln_Anio := SubStr(ln_FchSBS,5,4);
        
        D_FECPRE := ln_dia||'/'||ln_Mes||'/'||ln_Anio;
        D_FECPRE1:= to_date(D_FECPRE,'dd/mm/rrrr');
        PNDOC    := rpad(lc_tndoc,12,' ');
    select N_CALIF0,
           N_CALIF1,
           N_CALIF2,
           N_CALIF3,
           N_CALIF4
           
      into ln_cal0,
           ln_cal1,
           ln_cal2,
           ln_cal3,
           ln_cal4
    from CLDRCCI
	  where D_FECPRE = D_FECPRE1
      and C_TDOCID = lc_docsbs
	    and C_DOCIDE = trim(PNDOC)
      and rownum<2; --lc_tndoc;
     exception when no_data_found then 
          ln_cal0 := 0;
           ln_cal1 := 0;
           ln_cal2 := 0;
           ln_cal3 := 0;
           ln_cal4 := 0;   
    end;
           
   If ln_cal0 > 0 then
		    JAQY774Cal := 1;
   /*Else
        Exit;*/
   End If;
        
   /*If ln_cal1 > 0 then
		    JAQY774Cal := 2;
   End If;
   
   If ln_cal2 > 0 then
		    JAQY774Cal := 3;
   End If;
   			
	 If ln_cal3 > 0 then
       JAQY774Cal := 4;
   End If;
        
   If ln_cal4 > 0 then
		   JAQY774Cal := 5;
   End If;*/
   
 End;
 
 return JAQY774Cal;
 
 end fn_Calif_SBS_Cliente; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end PQ_OP_DESEMBOLSO;
/

