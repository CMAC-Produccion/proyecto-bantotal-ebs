create or replace package PQ_CR_JAQY767_CanceladoSD is
 
    -- *****************************************************************
    -- Nombre                     : PQ_CR_JAQY767_CanceladoSD
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.07.18
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Para insertar data en tabla jaqy767.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
                                
 procedure sp_cr_inserta_datos( pn_codreg in number,
                                pn_codsuc in number,
                                pc_usuario in varchar2,
                                pd_fecini in date, 
                                pd_fecfin in date,
                                pd_fape in date);                                
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 Function fn_cr_agencia( pn_codagen in number) return varchar2;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 Function fn_cr_moneda( pn_codmda in number) return varchar2;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
/* Function fn_cr_instancia(pn_pgcod in number,          
          pn_aomod in number,
          pn_aomda in number,
          pn_aopap in number,
          pn_aocta in number,
          pn_aosuc in number,
          pn_aooper in number,
          pn_aosbop in number,
          pn_aotope in number
                        
         ) return number;*/
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
 Function fn_cr_codreg( pn_codsuc in number) return number; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 
 Function fn_cr_nomreg( pn_codreg in number) return varchar2;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 Function fn_cr_credito( pn_cta in number, pn_mda in number, pn_oper in number) return varchar2; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_tipnro_doc( pn_cta in number, pn_codpais out number, pn_tipdoc out number, pc_nrodoc out char);
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_nombre_doc( pn_codpais in number, pn_tipdoc in number, pc_nrodoc in character, pc_nombre out char, pc_nrodocu out char);
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_fechanac( pn_codpais in number, pn_tipdoc in number, pc_nrodoc in character) return date;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_analista( pn_codanalista in fst046.ubuser%type) return char;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 /*procedure sp_cr_excepdesgra( pn_pais in number, pn_tipdoc in number, pc_nrodoc in char,
                             pn_instancia in number, pn_tipsolexcdesgra out number, pc_tipolizaexcep out char);*/
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 
    end PQ_CR_JAQY767_CanceladoSD;
/

create or replace package body PQ_CR_JAQY767_CanceladoSD  is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_JAQY767_CanceladoSD
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 18.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Para insertar data en tabla jaqy767.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_inserta_datos( pn_codreg in number,
                                pn_codsuc in number,
                                pc_usuario in varchar2,
                                pd_fecini in date, 
                                pd_fecfin in date,
                                pd_fape in date) is
                                --pc_codusu in varchar2,                                
                               
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 18.07.2016 
    -- Autor de Creación          : RLIVISI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 26.07.2016
    -- Autor de la Modificación   : RLIVISI
    -- Descripción de Modificación: Adición de parámetros: código de región, código de sucursal,
    --                              usuario que se loguea y fecha del sistema. 
    -- *****************************************************************

 cursor datos (ln_codregion varchar2, ln_codsucursal varchar2) is --01/08/2016 --insercion de dos variables al cursor
    
 select a.aopzo,
        a.aofval,
        a.aofe99,
       --a.aofe99 - 1,
        a.pgcod, 
        a.aomod, 
        a.aosuc, --as suc, 
        a.aomda, 
        a.aopap, 
        a.aocta, 
        a.aooper,
        a.aosbop,
        a.aotope, 
        b.sgcod,
        c.tp1imp1,
        a.aoimp
   from fsd010 a, fpp001 b, fst198 c, fst810 d, fst811 e ----se insertan dos tablas mas para region y sucursal respectivamete.
  where a.pgcod = b.pgcod
    and a.aomod = b.aomod
    and a.aosuc = b.aosuc
    and a.aomda = b.aomda
    and a.aopap = b.aopap
    and a.aocta = b.aocta
    and a.aooper = b.aooper
    and a.aosbop = b.aosbop
    --and a.aopap = 0
    and a.aostat = 99
    and c.tp1cod = 1
    and c.tp1cod1 = 10898
    and c.tp1corr1 = 8
    and b.sgcod = c.tp1imp1 -- 18.07.2016
    and a.aofe99 >= pd_fecini --to_date('2015.11.01','yyyy.mm.dd')--pd_fecini --to_date('2015.11.01','yyyy.mm.dd')
    and a.aofe99 <= pd_fecfin -- to_date('2015.11.30','yyyy.mm.dd');--pd_fecfin; --to_date('2015.11.30','yyyy.mm.dd')
    and d.regcod < 100 ----01/08/2016
    and d.regcod = e.regcod ---01/08/2016
    and e.oficod = a.aosuc
    and d.regcod like ln_codregion and e.oficod like ln_codsucursal; ----01/08/2016
    --'%'||lc_analista||'%' 
    
        /*select * \*b.oficod*\ from fst810 a, fst811 b
        where a.regcod < 100
        and a.regcod = b.regcod 
        and a.regcod like &lc_region and b.oficod like &lc_sucursal--= 0*/

     
 
 lc_credito varchar2(50); 
 ln_numero number := 0;
 lc_nomagencia varchar2(40);
 lc_nomoneda varchar2(30);
 ln_codreg number(3);
 lc_nomreg varchar2(40);
 --ln_grupo number;

 lc_cadenacred varchar2(30);
 ln_codpais number(3);
 ln_tipdoc number(2);
 lc_nrodoc char(12); 
 lc_nombrecliente char(30);
 lc_nrodocucliente char(12);
 ld_fechanac date;
 --pc_analista varchar2;
 lc_analista fst046.ubuser%type;
 lc_nomanalista char(30);
 ln_numinstancia number(10);---27/07/2016
 ln_tipsolucion number(4);
 lc_tipolizadesgraexcep char(30);
 ln_tipsolexcdesgra number(4); ----25/07/2016
 lc_tipolizaexcep char(30);  ----25/07/2016
 ln_periodomeses number(30); ---27/07/2016
 lc_usuarioce char(10); ----27/07/2016 usuario con espacios
 ln_grup number(2):=0;  -----01/08/2016 tipo de grupo  inicializando a cero
 lc_producto varchar2(40):= null; ---01/08/2016 --producto donde tipo grupo es diferente de 0
 lc_tip varchar(40):= null; ------01/08/2016 --producto donde tipo grupo = 0
 ln_codsucursal varchar2(10); ----01/08/2016
 ln_codregion varchar2(10); ----01/08/2016
 lc_poliza varchar2(10);
 
 
 begin


     lc_usuarioce :=rpad(trim(pc_usuario), 10, ' '); ---adicionando usuario con espacios---22.07.2016   
     delete from jaqy767 where jaqy767usulog = lc_usuarioce;--pc_usuario;
     commit;   -----27/07/2016

       
      if nvl(pn_codreg,0) = 0 then
         ln_codregion:= '%';--'''%''';
         else
         ln_codregion:= pn_codreg;--'''||pn_codreg||''';
      end if; -----01/08/2016
         
      if nvl(pn_codsuc,0) = 0 then
         ln_codsucursal:= '%';--'''%''';
         else
          ln_codsucursal:= pn_codsuc;
      end if; ----01/08/2016    
          
           for i in datos(ln_codregion, ln_codsucursal) loop ---se añadió las dos variables inicializadas en el cursor
        ----llamar a funciones
              
               lc_poliza:='Interna';   
               lc_nomagencia := pq_cr_jaqy767_canceladosd.fn_cr_agencia(pn_codagen => i.aosuc); 
               lc_nomoneda:= pq_cr_jaqy767_canceladosd.fn_cr_moneda( pn_codmda =>i.aomda);
               
               ln_codreg:= pq_cr_jaqy767_canceladosd.fn_cr_codreg( pn_codsuc =>i.aosuc);                                                         
               
               lc_nomreg:= pq_cr_jaqy767_canceladosd.fn_cr_nomreg( ln_codreg);            
              
               ln_periodomeses:=trunc(i.aopzo/30); ---para el periodo en meses--27.07.2016
               
               lc_cadenacred:= pq_cr_jaqy767_canceladosd.fn_cr_credito(pn_cta => i.aocta,
                                                                       pn_mda => i.aomda,
                                                                       pn_oper => i.aooper);
                
              
              
              begin
              pq_cr_jaqy767_canceladosd.sp_tipnro_doc(pn_cta => i.aocta,
                                          pn_codpais => ln_codpais,
                                          pn_tipdoc => ln_tipdoc,
                                          pc_nrodoc => lc_nrodoc);
              end;
              
              
              
              begin

              pq_cr_jaqy767_canceladosd.sp_nombre_doc(pn_codpais => ln_codpais,
                                          pn_tipdoc => ln_tipdoc,
                                          pc_nrodoc => lc_nrodoc,
                                          pc_nombre => lc_nombrecliente,
                                          pc_nrodocu => lc_nrodocucliente);
               end;
              
              ld_fechanac :=pq_cr_jaqy767_canceladosd.fn_cr_fechanac( pn_codpais => ln_codpais,
                                                                      pn_tipdoc => ln_tipdoc,
                                                                      pc_nrodoc => lc_nrodoc);
              
              
              begin
              
              sp_analista_credito(i.aomod, /*v_Scmod  in number,*/
                                  i.aosuc, /*v_Scsuc  in number,*/
                                  i.aomda, /*v_Scmda  in number, */
                                  i.aopap, /*v_Scpap  in number,*/
                                  i.aocta, /*v_Sccta  in number,*/
                                  i.aooper, /*v_Scoper in number,*/
                                  i.aosbop, /*v_Scsbop in number,*/
                                  i.aotope, /*v_Sctope in number,*/
                                  lc_analista );
              end; 
              
            lc_nomanalista:=pq_cr_jaqy767_canceladosd.fn_cr_analista( pn_codanalista => lc_analista);
              
                                                                                       
/*            ln_numinstancia:= pq_cr_jaqy767_canceladosd.fn_cr_instancia(pn_pgcod => i.pgcod,
                                                       pn_aomod => i.aomod,
                                                       pn_aomda => i.aomda,
                                                       pn_aopap => i.aopap,
                                                       pn_aocta => i.aocta,
                                                       pn_aosuc => i.aosuc,
                                                       pn_aooper => i.aooper,
                                                       pn_aosbop => i.aosbop,
                                                       pn_aotope => i.aotope); */
                                                       
                                                                    
       /*      begin
                
             pq_cr_jaqy767_canceladosd.sp_cr_excepdesgra( pn_pais => ln_codpais,
                                                          pn_tipdoc => ln_tipdoc,
                                                          pc_nrodoc => lc_nrodoc,
                                                          pn_instancia => ln_numinstancia,
                                                          pn_tipsolexcdesgra => ln_tipsolexcdesgra,
                                                          pc_tipolizaexcep => lc_tipolizaexcep);
             end;  */
             
             
             --------------Desde aca
  
              
             begin
             
              pq_cr_tramdesgra.sp_tiposbs(pn_emp => i.pgcod,
                                            pn_mod => i.aomod,
                                            pn_suc => i.aosuc,
                                            pn_mda => i.aomda,
                                            pn_pap => i.aopap,
                                            pn_cta => i.aocta,
                                            pn_ope => i.aooper,
                                            pn_sbo => i.aosbop,
                                            pn_top => i.aotope,
                                            ln_grup => ln_grup);
             end;   
                                         
            If (ln_grup = 2) then 
              lc_producto:='MICROEMPRESA';              
            else if (ln_grup = 3) then
              lc_producto:='CONSUMO';
            else if (ln_grup = 4) then  
                 lc_producto:='HIPOTECARIO';
            else if (ln_grup in (5,6,7,8,9)) then      
                 lc_producto:='CORPORATIVO';           
            else if (ln_grup = 12) then      
                 lc_producto:='MEDIANA EMPRESA';
            else if (ln_grup = 13) then      
                 lc_producto:='PEQUEÑA EMPRESA';              
            else if (ln_grup is null) then
            
               
                begin
                pq_cr_tramdesgra.sp_tiposbs_2(pn_emp => i.pgcod,
                                              pn_mod => i.aomod,
                                              pn_suc => i.aosuc,
                                              pn_mda => i.aomda,
                                              pn_pap => i.aopap,
                                              pn_cta => i.aocta,
                                              pn_ope => i.aooper,
                                              pn_sbo => i.aosbop,
                                              pn_top => i.aotope,
                                              lc_tip => lc_tip);                                             
                    
                                              
                end; 
                
                 lc_producto:= lc_tip;  
                        
             end if;
             end if;
             end if;
             end if;
             end if;
             end if;
             end if;  
 
           
              ------ hasta aca
              
              --insertar registros
                ln_numero := ln_numero +1;
                insert into JAQY767(JAQY767COR,JAQY767REG,  JAQY767AGEN, JAQY767NCRE,JAQY767CLI,JAQY767DOC,
                JAQY767FNAC,JAQY767ANA,JAQY767TCRE, JAQY767MDAD, JAQY767MTOD,JAQY767FECDE,JAQY767FECCAN,
                JAQY767PDIA,JAQY767PMES,JAQY767TPZA,JAQY767PGCOD,JAQY767MOD,JAQY767SUC,JAQY767MDA,
                JAQY767PAP,JAQY767CTA,JAQY767OPER,JAQY767SBOP,JAQY767TOPE,
                JAQY767CODREG , JAQY767CODSUC,
                JAQY767USULOG, JAQY767FECPRO)/**\\*JAQY767NROIP,*\\**\  *\ *\*/
                
                values (ln_numero, lc_nomreg,  lc_nomagencia, lc_cadenacred,lc_nombrecliente,lc_nrodocucliente,  
                        ld_fechanac,lc_nomanalista,lc_producto, lc_nomoneda, i.aoimp,i.aofval,i.aofe99,
                        i.aopzo, ln_periodomeses, lc_poliza,/*(i.aopzo /30)*/ i.pgcod, i.aomod, i.aosuc, i.aomda,
                        i.aopap, i.aocta, i.aooper, i.aosbop, i.aotope,
                        ln_codreg,i.aosuc,
                        pc_usuario, pd_fape);
                                
                
               commit;    
             -- end if; 
          --end if;
                   
                                 
      end loop;


   
 end sp_cr_inserta_datos;


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
Function fn_cr_agencia( pn_codagen in number) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_cr_agencia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna el nombre de la agencia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
 lc_nomagen varchar2(40); 
/*    
Sub 'Agencia'

    For Each Pgcod, Sucurs //--> FST001
        Where Pgcod = &Pgcod
        Where Sucurs = &Aosuc
            &Scnom = Scnom
    EndFor

EndSub // 'Agencia'*/

        
  begin  
    begin
       select scnom
         into lc_nomagen
         from fst001
       where  Sucurs = pn_codagen;
       
       exception 
          when no_data_found then
              lc_nomagen :=null; 
          when too_many_rows then
             lc_nomagen :=null;      
       
    end;
   
    return  lc_nomagen;
    
  end fn_cr_agencia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
Function fn_cr_moneda( pn_codmda in number) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_cr_agencia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna el nombre de la moneda
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
 lc_nomoneda varchar2(40); 
 
/*Sub 'Moneda'

    For Each //--FST005
    Where Moneda = &Aomda
    Defined By Mosign
        &lc_moneda = Monom
    EndFor

EndSub // 'Moneda'*/
        
  begin  
    begin
       select Monom
         into lc_nomoneda
         from fst005
       where  moneda = pn_codmda;
       
       exception 
          when no_data_found then
              lc_nomoneda :=null; 
          when too_many_rows then
             lc_nomoneda :=null;      
       
    end;
   
    return  lc_nomoneda;
    
  end fn_cr_moneda;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  
/*Function fn_cr_instancia(pn_pgcod in number,          
          pn_aomod in number,
          pn_aomda in number,
          pn_aopap in number,
          pn_aocta in number,
          pn_aosuc in number,
          pn_aooper in number,
          pn_aosbop in number,
          pn_aotope in number
                        
         ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_instancia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna la instancia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
 ln_instancia number(10); 
\* 
Sub 'Instancia'
   For Each XWfEmpresa, XWfSucursal, XWfModulo, XWfMoneda, XWfPapel, XWfCuenta, XWfOperacion, XWfSubope, XWfTipOpe, XWFPRCINS //-->XWF700
         Where XWfEmpresa    =  &Pgcod  
         Where XWfSucursal   =  &Aomod  
         Where XWfModulo     =  &Aosuc  
         Where XWfMoneda     =  &Aomda  
         Where XWfPapel      =  &Aopap  
         Where XWfCuenta     =  &Aocta  
         Where XWfOperacion  =  &Aooper
         Where XWfSubope     =  &Aosbop
         Where XWfTipOpe     =  &Aotope
              &Instancia =  XWFPRCINS 
     EndFor 
EndSub // 'Instancia'*\
        
  begin  
    begin
       select XWFPRCINS
         into ln_instancia
         from xwf700       
         where XWfEmpresa   =  pn_pgcod 
         and   XWfSucursal  =  pn_aosuc  
         and   XWfModulo    =  pn_aomod 
         and   XWfMoneda    =  pn_aomda 
         and   XWfPapel     =  pn_aopap 
         and   XWfCuenta    =  pn_aocta 
         and   XWfOperacion =  pn_aooper
         and   XWfSubope    =  pn_aosbop
         and   XWfTipOpe    =  pn_aotope;
       
       exception 
          when no_data_found then
              ln_instancia :=null; 
          when too_many_rows then
             ln_instancia :=null;      
       
    end;
   
    return  ln_instancia;
    
  end fn_cr_instancia;*/
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
Function fn_cr_codreg( pn_codsuc in number) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_codreg
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna el código de región
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
 ln_codreg number(3); 
 

/*Sub 'RegionDeSucursal'
 For Each Pgcod, OfiCod  //fst811
	Where Pgcod = &Pgcod
    Where OfiCod = &Aosuc
	Where RegCod < 100		
	Where OfiSuc = 'S'
	&RegCodDesuc = RegCod
 EndFor

EndSub // 'RegionDeSucursal'*/
        
  begin  
    begin
       select regcod
         into ln_codreg
         from fst811
       where oficod = pn_codsuc
       and   regcod <100
       and   ofisuc = 'S';
       
       exception 
          when no_data_found then
              ln_codreg :=null; 
          when too_many_rows then
             ln_codreg :=null;      
       
    end;
   
    return  ln_codreg;
    
  end fn_cr_codreg;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
Function fn_cr_nomreg( pn_codreg in number) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_cr_nomreg
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna el nombre de la región
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
 lc_nomreg varchar2(40); 
 
 
/* Sub 'nomRegion'
For Each Pgcod, RegCod //fst810
	    Where Pgcod = &Pgcod
		Where RegCod = &RegCodDesuc
        Where RegCod <100		
		&nomregion = RegNom
 EndFor   		

EndSub // 'nomRegion'
*/



        
  begin  
    begin
       select regnom
         into  lc_nomreg
         from fst810
       where regcod = pn_codreg
       and   regcod <100;
              
       exception 
          when no_data_found then
              lc_nomreg :=null; 
          when too_many_rows then
             lc_nomreg :=null;      
       
    end;
   
    return   lc_nomreg;
    
  end fn_cr_nomreg;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


Function fn_cr_credito( pn_cta in number, pn_mda in number, pn_oper in number) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_cr_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna una cadena de crédito concatenado:cta-mda-oper
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
 lc_cadena_credito varchar2(30); 
 
/* select aocta,  lpad(aocta,9, '0'),lpad(aomda,3, '0'),lpad(aooper,9, '0'), 
lpad(aocta,9, '0')||lpad(aomda,3, '0')||lpad(aooper,9, '0'),
 aooper, aomda, aotope
 from fsd010 where aomod = 115 and aocta = 34403;*/
 
        
  begin  
    begin
       select lpad(aocta,9,'0')||'-'||lpad(aomda,3,'0')||'-'||lpad(aooper,9,'0')
         into   lc_cadena_credito
         from fsd010
       where aocta = pn_cta
       and   aomda = pn_mda
       and   aooper= pn_oper;
              
       exception 
          when no_data_found then
               lc_cadena_credito :=null; 
          when too_many_rows then
              lc_cadena_credito :=null;      
       
    end;
   
    return    lc_cadena_credito;
    
  end fn_cr_credito;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


Procedure sp_tipnro_doc( pn_cta in number, pn_codpais out number, pn_tipdoc out number, pc_nrodoc out char) is
    -- *****************************************************************
    -- Nombre                     : sp_tipnro_doc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna el CodPais-TipoDocumento-NroDocumento
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
        
  begin  
    begin
       select  pepais, petdoc, pendoc
         into   pn_codpais, pn_tipdoc, pc_nrodoc 
         from fsr008
       where ctnro = pn_cta
       and ttcod = 1
       and cttfir = 'T';   
              
       exception 
          when no_data_found then
               pn_codpais :=null;
               pn_tipdoc :=null;
               pc_nrodoc:=null; 
          when too_many_rows then
               pn_codpais :=null;
               pn_tipdoc :=null;
               pc_nrodoc:=null;   
       
    end;
   
    
  end sp_tipnro_doc;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Procedure sp_nombre_doc( pn_codpais in number, pn_tipdoc in number, pc_nrodoc in character, pc_nombre out char, pc_nrodocu out char) is
    -- *****************************************************************
    -- Nombre                     : sp_tipnro_doc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna el Nombre de cliente y NroDocumento
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
        
  begin  
    begin
       select  penom, pendoc
         into   pc_nombre, pc_nrodocu
         from fsd001
       where pepais = pn_codpais
       and petdoc  =  pn_tipdoc 
       and pendoc = pc_nrodoc;
         
              
       exception 
          when no_data_found then
               pc_nombre :=null;
               pc_nrodocu :=null;
              
          when too_many_rows then
               pc_nombre :=null;
                pc_nrodocu :=null;
            
       
    end;
   
    
  end sp_nombre_doc;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
Function fn_cr_fechanac( pn_codpais in number, pn_tipdoc in number, pc_nrodoc in character) return date is
    -- *****************************************************************
    -- Nombre                     : fn_cr_fechanac
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna la fecha de nacimiento del cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
 ld_fechanac date; 
 
        
  begin  
    begin
       select pffnac
         into  ld_fechanac
         from fsd002
       where pfpais = pn_codpais
       and   pftdoc = pn_tipdoc
       and   pfndoc = pc_nrodoc;
              
       exception 
          when no_data_found then
              ld_fechanac :=null; 
          when too_many_rows then
             ld_fechanac :=null;      
       
    end;
   
    return   ld_fechanac;
    
  end fn_cr_fechanac;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
Function fn_cr_analista( pn_codanalista in fst046.ubuser%type) return char is
    -- *****************************************************************
    -- Nombre                     : fn_cr_analista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna el nombre del analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
   
 lc_analista char(30); 
 
        
  begin  
    begin
       select ubnom
         into lc_analista
         from fst746
       where ubuser = pn_codanalista;

              
       exception 
          when no_data_found then
              lc_analista :=null; 
          when too_many_rows then
             lc_analista :=null;      
       
    end;
   
    return   lc_analista;
    
  end fn_cr_analista;


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
/*procedure sp_cr_excepdesgra( pn_pais in number, pn_tipdoc in number, pc_nrodoc in char,
                             pn_instancia in number, pn_tipsolexcdesgra out number, pc_tipolizaexcep out char) is

    -- ************************************************************************************
    -- Nombre                     : fn_cr_excepdesgra
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 26.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna el tipo de poliza de excepción de desgravamen
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- ************************************************************************************
   
 \*Sub 'TipoPoliza'
 If &lc_flag = 'S'
    &TipPoliza = 'Interna'   
 Else
    
    
     For Each  JAQZ053PAI, JAQZ053TDO, JAQZ053NDO, JAQZ053INS, JAQZ053COR//--> JAQZ053
         Where JAQZ053PAI = &Pepais 
         Where JAQZ053TDO = &Petdoc 
         Where JAQZ053NDO = &Pendoc 
         Where JAQZ053INS = &Instancia
         Where JAQZ053EST = 'S'
               &JAQZ053Tso =  JAQZ053TSO         
     
     *\
  
        
  begin  
    begin
       select jaqz053tso, tp1desc
         into pn_tipsolexcdesgra, pc_tipolizaexcep
         from jaqz053, fst198
         where jaqz053pai = pn_pais
         and  jaqz053tdo = pn_tipdoc
         and  jaqz053ndo = pc_nrodoc
         and  jaqz053ins = pn_instancia          
         and jaqz053est = 'S'
         and tp1cod = 1
         and tp1cod1 = 10898
         and tp1corr1 = 1
         and tp1corr1 = jaqz053tso;
                      
       exception 
          when no_data_found then
              pn_tipsolexcdesgra :=null;
              pc_tipolizaexcep := null; 
          when too_many_rows then
              pn_tipsolexcdesgra :=null;
              pc_tipolizaexcep := null;      
       
    end;
          
  end sp_cr_excepdesgra;*/
   
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
   
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
end PQ_CR_JAQY767_CanceladoSD;
/

