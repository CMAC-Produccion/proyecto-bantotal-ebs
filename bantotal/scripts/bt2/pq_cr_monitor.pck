create or replace package PQ_CR_MONITOR is

  -- ************************************************************************************
  -- Nombre                     : TRAMA PARA EL BURO MONITOR
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.12.12
  -- Autor de Creación          : MPOSTIGOC
  -- Uso                        : TRAMAS PARA LLENAR DATA SOLICITADA POR EL BURO: MONITOR
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2017.12.01
  -- Autor de la Modificación   : ROCÍO MILAGROS LIVISI RAMOS 
  -- Descripción de Modificación: CREACIÓN DE TRAMA 1: 917-CONSULTAS AL BURO EXPERIAN Y OTROS
  --                            : CREACIÓN DE TRAMA 2: 533-CAMBIO DE CRÉDITOS
  --                            : MODIFICACIÓN DE TRAMA 3: 915-SOLICITUDES DE CRÉDITO   
  -- **********************************************************************************

  PROCEDURE SP_CR_SOLICITUDESDECREDITO(pc_sucurs in varchar2,
                                       pd_fecpro in date);
  -----------------------------------------------------------
  procedure sp_cr_soli_clientes(LN_PGCOD         in number,
                                LN_CUENTA        in number,
                                JAQY842TIDCL     out VARCHAR2,
                                ln_pais1         out varchar2,
                                ln_tdoc1         out varchar2,
                                lc_ndoc1         out varchar2,
                                pc_tippers       out varchar2,
                                lc_priape        out varchar2,
                                lc_segape        out varchar2,
                                lc_prinom        out varchar2,
                                lc_segnom        out varchar2,
                                lc_nomcom        out varchar2,
                                ln_fchnaci       out NUMBER,
                                lc_sexo          out varchar2,
                                lc_nomcomcy      out varchar2,
                                ln_fchnacicy     out NUMBER,
                                lc_EstCivil      out varchar2,
                                lc_DirecTit      out varchar2,
                                lc_DatDirec      out varchar2,
                                ln_pais          out number,
                                ln_tdoc          out number,
                                lc_ndoc          out varchar2,
                                ln_CodProf       out number,
                                lc_NomCentroLab  out varchar2, ---23.03.2018---RLIVISI
                                lc_tlfncelular   out varchar2,
                                lc_tlfnfijo      out varchar2,
                                lc_tlfncy        out varchar2,
                                lc_flgtrabajador out varchar2);

  -----------------------------------------------------------------------------------
  procedure sp_cr_Usuarios(ln_instancia   in number,
                           lc_asesor      out varchar2,
                           lc_usuario     out varchar2,
                           lc_usuarioconf out varchar2); ---11.05.2018--RLIVISI                       
  -----------------------------------------------------------------------------------
  procedure sp_cr_TipoSolicitud(ln_instancia in number,
                                ln_TipoSoli  out number); --08.03.2018 --RLIVISI
  ---------------------------------------------------------------------------------------  
  procedure sp_cr_EstadoSolicitud(ln_instancia    in number,
                                  ln_EstSolicitud out number); --19.03.2018--RLIVISI
  ----------------------------------------------------------------------------------------
  procedure sp_cr_CodRptaSoli(ln_instancia   in number,
                              lc_CodRptaSoli out char); ---20.03.2018---RLIVISI
  ---------------------------------------------------------------------------------------------
  procedure sp_cr_RptaSoli(ln_CodRptaSoli in char, lc_RptaSoli out char); --20.03.2018---RLIVISI
  ---------------------------------------------------------------------------------------------
  procedure sp_cr_MontoSolicitado(ln_instancia     in number,
                                  ln_MtoSolicitado out number); ---14.03.2018 --RLIVISI  
  -------------------------------------------------------------------------------------                                
  procedure sp_cr_MontoAprobado(ln_instancia       in number,
                                ln_MtoAprobado     out number,
                                ln_MdaMtoAprbNuevo out number); --26.09.2018--RLIVISI                                                     
  -----------------------------------------------------------------------------------
  procedure sp_cr_DatosClienteTrabajCaja(ln_pgcod    in number,
                                         ln_pais     in number,
                                         ln_tdoc     in number,
                                         lc_ndoc     in char,
                                         lc_CodCargo out number /*sng055.sng055dsc%type*/,
                                         /*lc_nombemprsa out varchar2,*/
                                         /*lc_nombagenc      out varchar2,                                                                                                                                                                                                          lc_tlfnage        out varchar2,*/
                                         lc_UsuTrab        out character,
                                         lc_datosdirectrab out varchar2);
  -------------------------------------------------------------------------------------
  procedure sp_cr_RelLabClienteTrabCaja(ln_pais         in number,
                                        ln_tdoc         in number,
                                        lc_ndoc         in char,
                                        ln_fechrellabcj out number);
  -------------------------------------------------------------------------------------  

  procedure sp_cr_RelLabClienteExterno(ln_pais          in number,
                                       ln_tdoc          in number,
                                       lc_ndoc          in char,
                                       ln_fechrellabext out number);

  --------------------------------------------------------------------------------------
  procedure sp_cr_activEconoCliente(ln_pais        in number,
                                    ln_tdoc        in number,
                                    lc_ndoc        in char,
                                    ln_IndDepen    out number,
                                    ln_codactecono out number);
  ------------------------------------------------------------------------------------
  procedure sp_cr_insertaJAQY842(lc_tndoc     in varchar2,
                                 lc_tdoc      in varchar2,
                                 lc_ndoc      in varchar2,
                                 lc_tpers     in varchar2,
                                 lc_tsoli     in varchar2,
                                 ln_instancia in number,
                                 lc_ncred     in varchar2,
                                 ln_cta10     in number, ---RLIVISI---10.05.2018 
                                 ln_FCHING    in number,
                                 ln_HORING    in number,
                                 ln_SUC       in number,
                                 lc_ASE       in varchar2,
                                 lc_USU       in varchar2,
                                 lc_usuconf   in varchar2, ---11.05.2018--RLIVISI
                                 lc_PNOMB     in varchar2,
                                 lc_SNOMB     in varchar2,
                                 lc_PAPE      in varchar2,
                                 lc_SAPE      in varchar2,
                                 lc_NOMBC     in varchar2,
                                 lc_PAIS      in varchar2,
                                 /*lc_IDTRIB         in varchar2,*/
                                 lc_DIREC            in varchar2,
                                 lc_DDIR             in varchar2,
                                 lc_NTRAB            in varchar2,
                                 lc_DIRTRAB          in varchar2,
                                 lc_DDIRTRA          in varchar2,
                                 lc_FONOD            in varchar2,
                                 lc_FONOT            in varchar2,
                                 lc_CELUL            in varchar2,
                                 ln_FCHRLLB          in number,
                                 ln_PROFE            in number,
                                 lc_ESTCIV           in varchar2,
                                 ln_FNACI            in number,
                                 lc_SEXO             in varchar2,
                                 lc_NCONY            in varchar2,
                                 ln_FNCONY           in number,
                                 lc_tlfncy           in varchar2, ---10.05.2018--RLIVISI
                                 lc_CARGO            in varchar2,
                                 ld_fechproc         in date,
                                 ln_MtoSolic         in number,
                                 ln_MtoAprob         in number,
                                 ln_MdaMtoAprobNuevo in number, --07/05/2018--RLIVISI
                                 lc_CodProd          in varchar2,
                                 lc_flgtrab          in varchar2,
                                 ln_EstSoli          in number,
                                 lc_CodRptaSolic     in char,
                                 lc_RptaSolic        in char,
                                 /*ln_IndDependiente in number,*/
                                 ln_codactecono    in number,
                                 lc_CanalSolicitud in varchar2); ----13/11/2018 ---RLIVISI
  ---------------------------------------------------------------------------------                          

  procedure sp_cr_variablecambio(lc_digito in char, pd_fecpro in date); ----21.03.2018---RLIVISI
  ---------------------------------------------------------------------------------
  procedure sp_cr_insertaJAQY840(lc_Entidad     in varchar2, --jaqy840entidad
                                 lc_TipNroDoc   in VARCHAR2, --jaqy840tndoc
                                 lc_CodCliCaja  in VARCHAR2, --jaqy840idclien
                                 lc_CodProd     in VARCHAR2, --jaqy840codprod
                                 lc_CodTran     in VARCHAR2, --jaqy840codtran                 
                                 lc_UsuAprb     in VARCHAR2, --jaqy840usu
                                 ln_CargUsu     in number, --jaqy840cargusu
                                 lc_NroIP       in VARCHAR2, --jaqy840ip---19.11.2018--RLIVISI
                                 ln_DatoAntNov  in number, --jaqy840dantnov
                                 ln_DatoPosNov  in number, --jaqy840dposnov
                                 ln_FecNovedad  in number, --jaqy840fecnov
                                 ln_HoraNovedad in number, --jaqy840horanov                                 
                                 ld_FechProc    in date); --jaqy840fecproc  ---26.02.2018 RLIVISI                      

  ---------------------------------------------------------------------------------
  procedure sp_cr_obtenDataExper(lc_digito in varchar2, pd_fecpro in date); ---01/12/2017 --21.03.2018---RLIVISI    
  ---------------------------------------------------------------------------------

  procedure sp_cr_insertaJAQY841(lc_TipNroDoc in VARCHAR2, --jaqy841tndoc
                                 lc_TipDoc    in VARCHAR2, --jaqy841tdoc
                                 lc_NroDoc    in VARCHAR2, --jaqy841ndoc
                                 ln_FecEnv    in number, --jaqy841fecenv
                                 /*lc_NroIP       in VARCHAR2, --jaqy841ip*/ --02.05.2018
                                 ln_HoraEnv     number, --jaqy841horenv
                                 lc_UsuConsulta in VARCHAR2, --jaqy841usucons
                                 ln_CodBuro     in NUMBER, --jaqy841codburo
                                 lc_NroCta      in VARCHAR2,
                                 ld_fecproc     in date);
  -----------------------------------------------------------------------------------------------------                                
  procedure sp_cr_obtenSdoRubroContable(lc_digito in varchar2,
                                        pd_fecpro in date); --26.06.2018-RLIVISI*/

  -----------------------------------------------------------------------------------------------------
  procedure sp_cr_ObtenFechas(ld_hfcon            in date,
                              ln_cDiaAnt_fecproc  out date,
                              ln_cdia_fecproc     out number,
                              ln_cmes_fecproc     out number,
                              ln_canio_fecproc    out number,
                              ln_canioAnt_fecproc out number,
                              ln_amlreg           out number,
                              ln_amdlreg          out number); ---124.04.2019--RLIVISI
  -----------------------------------------------------------------------------------------------------
  procedure sp_cr_creaRubro(ln_rubroc      in number,
                            ln_fecCreaCta  out number,
                            ln_horaCreaCta out number,
                            lc_usucrearub  out varchar2); --16.07.2018 --RLIVISI
  ------------------------------------------------------------------------------------------------  

  procedure sp_cr_SdoInicioDia(ln_diaant_fecproc in date, --10.07.2018--RLIVISI                               
                               ln_rubrocons      in number,
                               ln_sdoIniDia      out number);

  ---------------------------------------------------------------------------------------------------------------------------
  procedure sp_cr_EvalMesAnio(ln_MesFechProc  in number,
                              ln_AnioFechProc in number,
                              ln_aniocons     out number,
                              ln_mescons      out number); ---20/07/2018--RLIVISI
  -------------------------------------------------------------------------------------------------------------------------
  procedure sp_cr_SdoCieMes(ln_rubrocons     in number,
                            ln_anioconsfinal in number,
                            ln_mesconsfinal  in number,
                            pn_SdoCieMes     out number); ---24.07.2018 --RLIVISI                         

  ---------------------------------------------------------------------------------------------------------------------------
  procedure sp_cr_SdoIniAnio(ln_AnioAntFechProc in number,
                             ln_rubrocons       in number,
                             ln_SdoIniAnio      out number); ------20/07/2018--RLIVISI                                                                    

  ---------------------------------------------------------------------------------------------------------------------------
  procedure sp_cr_insertaJAQY844(ln_jaqy844pais    in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844pgcod   in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844suc     in number, --25.04.2019 --RLIVISI
                                 ln_jaqy844ctacble in number, --05.07.2018 --RLIVISI
                                 lc_jaqy844desccta in char, --12.07.2018--RLIVISI
                                 lc_jaqy844ftotdet in char, --25.04.2019 --RLIVISI
                                 lc_jaqy844tipsdo  in char, --05.07.2018 --RLIVISI                          
                                 ln_jaqy844tipcta  in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844subtcta in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844faux    in number, --25.04.2019 --RLIVISI
                                 ln_jaqy844fccost  in number, --25.04.2019 --RLIVISI
                                 ln_jaqy844fpresup in number, --25.04.2019 --RLIVISI
                                 ln_jaqy844fecccta in number, --05.07.2018 --RLIVISI                                
                                 ln_jaqy844horccta in number, --05.07.2018 --RLIVISI
                                 lc_jaqy844usuccta in varchar2, --05.07.2018 --RLIVISI
                                 ln_jaqy844sdoidia in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844sdoimes in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844sdoiano in number, --05.07.2018 --RLIVISI
                                 lc_jaqy844stscta  in char, --05.07.2018 --RLIVISI
                                 ln_jaqy844mdacont in number, --25.04.2019--RLIVISI
                                 ln_jaqy844amlreg  in number, --25.04.2019 ---RLIVISI                                 
                                 ln_jaqy844feclreg in number, --25.04.2019 --RLIVISI                                                              
                                 lc_jaqy844inderr  in char, --05.07.2018 --RLIVISI
                                 ld_fecproc        in date); --12.07.2018---RLIVISI
  -----------------------------------------------------------------------------------------------------

  Procedure sp_cr_job_buro(pd_fecpro in date); ----21.03.2018---RLIVISI
  ----------------------------------------------------------------------------------                                
  procedure sp_cr_job_solcred(pd_fecpro in date); ---30.04.2018---RLIVISI

  ----------------------------------------------------------------------------------
  Procedure sp_cr_job_varcambio(pd_fecpro in date); ----21.03.2018----RLIVISI
  ----------------------------------------------------------------------------------  
  procedure sp_cr_obtenDataSentinel(lc_digito in varchar2,
                                    pd_fecpro in date);
  ---------------------------------------------------------------------------------- 
  procedure sp_cr_job_rubro(pd_fecpro in date); ---16.07.2018 --RLIVISI
----------------------------------------------------------------------------------   

end PQ_CR_MONITOR;
/

create or replace package body PQ_CR_MONITOR is
  -- ******************************************************************************************
  -- Nombre                     : TRAMA PARA EL BURO MONITOR
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.12.12
  -- Autor de Creación          : MPOSTIGOC/RLIVISI
  -- Uso                        : TRAMAS PARA LLENAR DATA SOLICITADA POR EL BURO: MONITOR
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2017.12.01
  -- Autor de la Modificación   : ROCÍO MILAGROS LIVISI RAMOS 
  -- Descripción de Modificación: CREACIÓN DE TRAMA 1: 917-CONSULTAS AL BURO EXPERIAN Y OTROS
  --                            : CREACIÓN DE TRAMA 2: 533-CAMBIO DE CRÉDITOS
  --                            : MODIFICACIÓN DE TRAMA 3: 915-SOLICITUDES DE CRÉDITO   
  -- ******************************************************************************************

  PROCEDURE SP_CR_SOLICITUDESDECREDITO(pc_sucurs in varchar2,
                                       pd_fecpro in date) IS
    ---Registro 915-SOLICITUDES DE CREDITO
    ---DURANTE --EN VUELO--05.03.2018 
    ---RLIVISI --TABLA DE INSERCION JAQY842
  
    cursor solicitudes is
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal JAQY842SUCSOL, --JAQZ805SUCSOL, ----20.12.2017---RLIVISI
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             lpad(trim(to_char(x.xwfcuenta)), 9, '0') ||
             lpad(trim(to_char(x.xwfmodulo)), 3, '0') ||
             lpad(trim(to_char(x.xwfoperacion)), 9, '0') NROCREDITO,
             x.xwfprcins JAQY842INS, --JAQZ805INS, --20.12.2017---RLIVISI
             x.xwfmonto1 JAQY842MNTSOL, --JAQZ805MNTSOL,  ----20.12.2017---RLIVISI           
             to_char(g.sng001fin, 'YYYY/MM/DD') JAQY842FCHING, -- 01012017 JAQY842FCHING,-- to_number(to_char(to_date(w.wfiteminit,'DD/MM/YYYY HH:MM:SS'))) JAQY842FCHING,--JAQZ805FECH, ----20.12.2017---RLIVISI ----01012017 JAQY842FECH,
             TO_CHAR(w.wfiteminit, 'HH24:MI:SS') JAQY842HORING, --/*'30012018' JAQY842HORA*/ --TO_CHAR(w.wfiteminit, 'HH24:MI:SS') JAQY842HORA --JAZQ805HORA  ----20.12.2017---RLIVISI
             to_char(x.xwfmodulo) Modulo,
             to_char(x.xwftipope) TipOper
      
        from xwf700 x, sng001 g, sng120 sg, wfwrkitems w ---Se habilita acceso a sng120 --14.03.2018 --RLIVISI
      
       WHERE x.xwfempresa = 1
         and g.sng001inst = x.xwfprcins
         and g.sng001inst = w.wfinsprcid
         and x.xwfprcins = w.wfinsprcid --w.wfinsprcid = x.xwfprcins
         and g.sng001fin = pd_fecpro
         and g.sng001inst = sg.sng120ins ---14.03.2018--RLIVISI 
         and w.WFINSPRCID = sg.sng120ins --14.03.2018--RLIVISI       
         and w.wfitemstsact = 1
         and x.xwfcar3 = '1'
         and x.xwfsucursal = pc_sucurs ---09.03.2018--RLIVISI
      --- and FALTA PASAR LA FECHA----
      -- and x.xwffec1 =  
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope, --sg.sng120fval, 
                x.xwfprcins,
                x.xwfmonto1,
                g.sng001fin,
                w.wfiteminit;
  
    lc_TIDCL VARCHAR2(18);
    ln_pais1 varchar2(3);
    ln_tdoc1 varchar2(3);
    lc_ndoc1 varchar2(15);
  
    pc_tippers varchar2(1);
  
    lc_priape varchar2(25);
    lc_segape varchar2(25);
    lc_prinom varchar2(25);
    lc_segnom varchar2(25);
    lc_nomcom varchar2(150); ---18.07.2019---RLIVISI
  
    ln_fchnaci number; --date; --20.12.2017---RLIVISI
    lc_sexo    varchar2(1);
  
    lc_nomcomcy  varchar2(100);
    ln_fchnacicy number; --date; --20.12.2017---RLIVISI
  
    lc_EstCivil varchar2(1);
  
    lc_DirecTit varchar2(50);
    lc_DatDirec varchar2(80);
  
    ln_pais number(3); ---19.03.2018---RLIVISI
    ln_tdoc number(2); ---19.03.2018---RLIVISI
    lc_ndoc varchar2(12);
    --ln_CodProf        varchar2(5);
  
    lc_tlfncelular varchar2(20); --27.04.2018
    lc_tlfnfijo    varchar2(20); --27.04.2018
  
    --lc_tlfncelularcy varchar2(20); --27.04.2018--10.07.2018--RLIVISI
    --lc_tlfnfijocy    varchar2(20); --27.04.2018--10.07.2018--RLIVISI
    lc_tlfncy varchar2(20); ---10.05.2018 
  
    lc_flgtrabajador varchar2(2);
    ------------------------------    
    lc_asesor      varchar2(10);
    lc_usuario     varchar2(10);
    lc_usuarioconf varchar2(10); ----11.05.2018---RLIVISI
  
    lc_cargo       varchar2(30);
    ln_CodTipoSoli number(2); -----08.03.2018--RLIVISI
  
    lc_nombagenc varchar2(50);
    lc_diragen   varchar2(50);
    --lc_tlfnage        varchar2(12);
  
    lc_datosdirectrab varchar2(80);
    lc_datosdireagen  varchar2(100); -----19.03.2018---RLIVISI    
    lc_CodCargo       number;
    --lc_nombemprsa     varchar2(50); ---10.07.2018---RLIVISI
    lc_UsuTrab character(10);
  
    ln_ciudagen fst001.scciud%type; -- character(20);
    ln_deptagen character(15);
    lc_diragen1 character(25);
    lc_diragen2 number;
    lc_tlfnage  varchar2(20);
  
    lc_HH            varchar2(2); ---20.12.2017---RLIVISI
    lc_MM            varchar2(2); ---20.12.2017---RLIVISI
    lc_SS            varchar2(2); ---20.12.2017---RLIVISI
    lc_horaSinPuntos varchar2(6); ---20.12.2017---RLIVISI
    ln_horaSinPuntos number(6); ---20.12.2017---RLIVISI  
    lc_YYYY          varchar2(4); ---06/03/2018 --RLIVISI
    lc_MMe           varchar2(2); ---06/03/2018 --RLIVISI
    lc_DD            varchar2(2); ---06/03/2018 --RLIVISI
    lc_fechSinSlash  varchar2(8); ---06/03/2018 --RLIVISI
    ln_fechSinSlash  number(8); ---12/03/2018 --RLIVISI
  
    ln_MtoSolicitado    number(17, 2); ---14/03/2018 --RLIVISI
    ln_MtoAprobado      number(17, 2); ---14/03/2018 ----RLIVISI
    ln_MdaMtoAprobNuevo number(17, 2); ----20.11.2018 ---RLIVISI
    ln_MdaMtoAprb       number(4); -----15/03/2018---RLIVISI    
    lc_CodProducto      varchar2(6); ---15/03/2018 --RLIVISI
    ln_MdaMtoAprbNuevo  number(4); ----26/09/2018----RLIVISI
    lc_CanalSolicitud   varchar2(11) := 'Agencia'; --Próx. Solicitudes ingreso 'Web' ---13/11/2018 --RLIVISI
  
    --lc_flgtrab varchar2(1); ---16/03/2018---RLIVISI--10.07.2018---RLIVISI
  
    --ln_pfxpais number(3); ---16/03/2018 ---RLIVISI---17/07/2018--RLIVISI
    --ln_pfxtdoc number(2); ---16/03/2018----RLIVISI --17/07/2018--RLIVISI
    --lc_pfxndoc varchar(12); ---16/03/2018----RLIVISI--17/07/2018--RLIVISI
  
    --lc_nombEmpresa varchar(50); ---16/03/2018----RLIVISI--17/07/2018--RLIVISI
    ln_vicod number(2); ---16/03/2018----RLIVISI  
    --ld_IniRellab date; ---16/03/2018----RLIVISI --17/07/2018--RLIVISI  
    --ln_IniRellab number(8); ---19/03/2018--RLIVISI--17/07/2018--RLIVISI
    --ln_FchRelLab number; --date;  --20.12.2017---RLIVISI --17/07/2018--RLIVISI
  
    ln_CodProf number(3); ---16/03/2018----RLIVISI---23.03.2018
  
    ln_EstSolicitud NUMBER(4); ---20/03/2018---RLIVISI
  
    lc_CodRptaSoli CHAR(1); ---20/03/2018---RLIVISI
    lc_RptaSoli    char(20); -----20/03/2018----RLIVISI
  
    ln_vicod        number(2); ----20/03/2018---RLIVISI    
    ln_IndDepen     NUMBER(5); ----20.03.2018---RLIVISI 
    lc_nomCentroLab CHAR(50); ----20/03/2018---RLIVISI 
  
    --ld_FechIng date; ----20/03/2018---RLIVISI----17/07/2018--RLIVISI
    --ln_FechIng number(8); ------20/03/2018---RLIVISI---17/07/2018--RLIVISI
    --lc_digito  varchar2(1); -----22/03/2018----RLIVISI---17/07/2018--RLIVISI
  
    ln_codactecono number(11); ----26.03.2018---RLVISI
  
    ln_fechrellabext number(8); ----26.03.2018---RLIVISI
    ln_fechrellabcj  number(8); -----26.03.2018---RLIVISI
    ln_cta10         number(9); -------10.05.2018---RLIVISI
  
  begin
    for l in solicitudes loop
      lc_HH            := substr(l.jaqy842horing, 1, 2); --20/12/2017---RLIVISI
      lc_MM            := substr(l.jaqy842horing, 4, 2); --20/12/2017---RLIVISI
      lc_SS            := substr(l.jaqy842horing, 7, 2); --20/12/2017---RLIVISI
      lc_horaSinPuntos := concat(concat(lc_HH, lc_MM), lc_SS); --20/12/2017---RLIVISI
      ln_horaSinPuntos := to_number(lc_horaSinPuntos); --20/12/2017---RLIVISI
    
      lc_YYYY := substr(l.jaqy842fching, 1, 4); ---06/03/2018 ---RLIVISI --1,4
      lc_MMe  := substr(l.jaqy842fching, 6, 2); ---06/03/2018 ---RLIVISI --6,2
      lc_DD   := substr(l.jaqy842fching, 9, 2); ---06/03/2018 ---RLIVISI --9,2    
    
      lc_fechSinSlash := concat(concat(lc_YYYY, lc_MMe), lc_DD); ---06/03/2018 ---RLIVISI  
      ln_fechSinSlash := to_number(lc_fechSinSlash); ---06/03/2018 ---RLIVISI 
      lc_CodProducto  := concat(l.modulo, l.tipoper); ----18/03/2018 ---RLIVISI
    
      --------------------------------------------------------------------------------------------
      pq_cr_monitor.sp_cr_soli_clientes(LN_PGCOD         => l.ln_pgcod10,
                                        LN_CUENTA        => l.ln_cta10,
                                        JAQY842TIDCL     => lc_TIDCL,
                                        ln_pais1         => ln_pais1,
                                        ln_tdoc1         => ln_tdoc1,
                                        lc_ndoc1         => lc_ndoc1,
                                        pc_tippers       => pc_tippers,
                                        lc_priape        => lc_priape,
                                        lc_segape        => lc_segape,
                                        lc_prinom        => lc_prinom,
                                        lc_segnom        => lc_segnom,
                                        lc_nomcom        => lc_nomcom,
                                        ln_fchnaci       => ln_fchnaci,
                                        lc_sexo          => lc_sexo,
                                        lc_nomcomcy      => lc_nomcomcy,
                                        ln_fchnacicy     => ln_fchnacicy,
                                        lc_EstCivil      => lc_EstCivil,
                                        lc_DirecTit      => lc_DirecTit,
                                        lc_DatDirec      => lc_DatDirec,
                                        ln_pais          => ln_pais,
                                        ln_tdoc          => ln_tdoc,
                                        lc_ndoc          => lc_ndoc,
                                        ln_CodProf       => ln_CodProf,
                                        lc_NomCentroLab  => lc_NomCentroLab, ---23.03.2018---RLIVISI
                                        lc_tlfncelular   => lc_tlfncelular,
                                        lc_tlfnfijo      => lc_tlfnfijo,
                                        lc_tlfncy        => lc_tlfncy,
                                        lc_flgtrabajador => lc_flgtrabajador);
    
      pq_cr_monitor.sp_cr_Usuarios(l.jaqy842ins,
                                   lc_asesor,
                                   lc_usuario,
                                   lc_usuarioconf);
    
      pq_cr_monitor.sp_cr_TipoSolicitud(l.jaqy842ins, ln_CodTipoSoli); ---08.03.2018--RLIVISI
    
      pq_cr_monitor.sp_cr_EstadoSolicitud(l.jaqy842ins, ln_Estsolicitud); ---20.03.2018---RLIVISI
    
      pq_cr_monitor.sp_cr_CodRptaSoli(l.jaqy842ins, lc_CodRptaSoli); ---20.03.2018---RLIVISI
    
      pq_cr_monitor.sp_cr_RptaSoli(lc_CodRptaSoli, lc_RptaSoli); ---20.03.2018--RLIVISI
    
      pq_cr_monitor.sp_cr_MontoSolicitado(l.jaqy842ins, ln_MtoSolicitado); --14/03/2018--RLIVISI
    
      pq_cr_monitor.sp_cr_MontoAprobado(l.jaqy842ins,
                                        ln_MtoAprobado,
                                        ln_MdaMtoAprbNuevo); ---20.11.2018--RLIVISI                             
    
      pq_cr_monitor.sp_cr_activEconoCliente(ln_pais,
                                            ln_tdoc,
                                            lc_ndoc,
                                            ln_IndDepen,
                                            ln_codactecono); --26.03.2018--RLIVISI
    
      if lc_flgtrabajador = 'S' then
      
        pq_cr_monitor.sp_cr_DatosClienteTrabajCaja(l.ln_pgcod10,
                                                   ln_pais,
                                                   ln_tdoc,
                                                   lc_ndoc,
                                                   lc_CodCargo,
                                                   /*lc_nombemprsa,*/
                                                   lc_UsuTrab, /* lc_nombagenc,  lc_tlfnage,*/
                                                   lc_datosdirectrab);
      
        pq_cr_monitor.sp_cr_RelLabClienteTrabCaja(ln_pais,
                                                  ln_tdoc,
                                                  lc_ndoc,
                                                  ln_fechrellabcj);
      
        begin
        
          select g.sng055dsc
            into lc_cargo
            from sng055 g
           where g.sng055emp = l.ln_pgcod10
             and g.sng055car = lc_CodCargo;
        exception
          when no_data_found then
            lc_cargo := null;
          
        end;
      
        begin
          -- Direccion del Lugar en donde trabaja
          begin
            select t.scnom, t.scciud, t.scdept, t.sccall, t.scnro, t.sctelf
              into lc_nombagenc,
                   ln_ciudagen,
                   ln_deptagen,
                   lc_diragen1,
                   lc_diragen2,
                   lc_tlfnage
            
              from fst046 f, fst001 t
             where f.ubuser = lc_UsuTrab
               and f.ubsuc = t.sucurs;
          
          exception
            when no_data_found then
              lc_nombagenc := null; --27.02.2018---RLIVISI
              ln_ciudagen  := 0; --27.02.2018---RLIVISI
              ln_deptagen  := 0; --27.02.2018---RLIVISI
              lc_diragen1  := null; --27.02.2018---RLIVISI
              lc_diragen2  := null; --27.02.2018---RLIVISI
              lc_tlfnage   := null; --27.02.2018---RLIVISI           
          end;
        
          begin
            select st.locnom || ', ' || f.depnom
              into lc_datosdirectrab
              from fst068 f, fst070 st --cambio de t por st--20.12.2017--RLIVISI
             where f.depcod = ln_deptagen
               and st.depcod = f.depcod
               and st.loccod = ln_ciudagen;
          
          exception
            when no_data_found then
              lc_datosdirectrab := null;
          end;
        
          lc_diragen := trim(lc_diragen1) || ',' ||
                        trim(to_char(lc_diragen2));
          -- lc_tlfnage := trim(lc_tlfnage1);        
        end;
      
        pq_cr_monitor.sp_cr_insertaJAQY842(lc_tndoc     => lc_TIDCL,
                                           lc_tdoc      => ln_tdoc1,
                                           lc_ndoc      => lc_ndoc1,
                                           lc_tpers     => pc_tippers,
                                           lc_tsoli     => ln_CodTipoSoli, --'2',--08.03.2018--RLIVISI
                                           ln_instancia => l.jaqy842ins, --s.jaqz805ins,
                                           lc_ncred     => l.nrocredito, --S.NROCREDITO,
                                           ln_cta10     => l.ln_cta10, --ln_cta10, ---RLIVISI---10.05.2018                                             
                                           ln_FCHING    => ln_fechSinSlash, --s.jaqz805fech,--Date por number
                                           ln_HORING    => ln_horaSinPuntos, --l.jaqy842hora,--s.jazq805hora,--Date por number
                                           ln_SUC       => l.jaqy842sucsol, --s.jaqz805sucsol,
                                           lc_ASE       => lc_asesor,
                                           lc_USU       => lc_usuario,
                                           lc_usuconf   => lc_usuarioconf, ---11.05.2018--RLIVISI
                                           lc_PNOMB     => lc_prinom,
                                           lc_SNOMB     => lc_segnom,
                                           lc_PAPE      => lc_priape,
                                           lc_SAPE      => lc_segape,
                                           lc_NOMBC     => lc_nomcom,
                                           lc_PAIS      => ln_pais1,
                                           /*lc_IDTRIB         => 'NN',*/
                                           lc_DIREC            => lc_DirecTit,
                                           lc_DDIR             => lc_DatDirec,
                                           lc_NTRAB            => lc_NomCentroLab, ---23.03.2018 RLIVISI
                                           lc_DIRTRAB          => lc_diragen,
                                           lc_DDIRTRA          => lc_datosdireagen,
                                           lc_FONOD            => lc_tlfnfijo,
                                           lc_FONOT            => lc_tlfnage,
                                           lc_CELUL            => lc_tlfncelular,
                                           ln_FCHRLLB          => ln_fechrellabcj, ---26.03.2018--RLIVISI                                                                                    
                                           ln_PROFE            => ln_CodProf,
                                           lc_ESTCIV           => lc_EstCivil,
                                           ln_FNACI            => ln_fchnaci, --Cambiar DATE por number
                                           lc_SEXO             => lc_sexo,
                                           lc_NCONY            => lc_nomcomcy,
                                           ln_FNCONY           => ln_fchnacicy, --Cambiar DATE por number
                                           lc_tlfncy           => lc_tlfncy, ---10.05.2018--RLIVISI                                                                                 
                                           lc_CARGO            => lc_cargo,
                                           ld_fechproc         => pd_fecpro,
                                           ln_MtoSolic         => ln_MtoSolicitado, --14/03/2018--RLIVISI
                                           ln_MtoAprob         => ln_MtoAprobado,
                                           ln_MdaMtoAprobNuevo => ln_MdaMtoAprbNuevo, --26/09/2018 --RLIVISI
                                           lc_CodProd          => lc_CodProducto,
                                           lc_flgtrab          => lc_flgtrabajador, --14/03/2018--RLIVISI
                                           ln_EstSoli          => ln_EstSolicitud,
                                           lc_CodRptaSolic     => lc_CodRptaSoli,
                                           lc_RptaSolic        => lc_RptaSoli,
                                           /*ln_IndDependiente => ln_IndDepen,*/
                                           ln_codactecono    => ln_codactecono,
                                           lc_CanalSolicitud => lc_CanalSolicitud); --19.03.2018--RLIVISI
      
      else
      
        if lc_flgtrabajador = 'N' then
          ---cualquier cliente
        
          pq_cr_monitor.sp_cr_RelLabClienteExterno(ln_pais,
                                                   ln_tdoc,
                                                   lc_ndoc,
                                                   ln_fechrellabext);
        
          --end if;
        
          pq_cr_monitor.sp_cr_insertaJAQY842(lc_tndoc     => lc_TIDCL,
                                             lc_tdoc      => ln_tdoc1,
                                             lc_ndoc      => lc_ndoc1,
                                             lc_tpers     => pc_tippers,
                                             lc_tsoli     => ln_CodTipoSoli,
                                             ln_instancia => l.jaqy842ins,
                                             lc_ncred     => l.nrocredito,
                                             ln_cta10     => l.ln_cta10, --ln_cta10, ---RLIVISI---10.05.2018  
                                             ln_FCHING    => ln_fechSinSlash,
                                             ln_HORING    => ln_horaSinPuntos,
                                             ln_SUC       => l.jaqy842sucsol,
                                             lc_ASE       => lc_asesor,
                                             lc_USU       => lc_usuario,
                                             lc_usuconf   => lc_usuarioconf, ---11.05.2018--RLIVISI
                                             lc_PNOMB     => lc_prinom,
                                             lc_SNOMB     => lc_segnom,
                                             lc_PAPE      => lc_priape,
                                             lc_SAPE      => lc_segape,
                                             lc_NOMBC     => lc_nomcom,
                                             lc_PAIS      => ln_pais1,
                                             /*lc_IDTRIB         => 'NN',*/
                                             lc_DIREC            => lc_DirecTit,
                                             lc_DDIR             => lc_DatDirec,
                                             lc_NTRAB            => lc_NomCentroLab, -----23.03.2018 RLIVISI
                                             lc_DIRTRAB          => lc_diragen,
                                             lc_DDIRTRA          => lc_datosdireagen,
                                             lc_FONOD            => lc_tlfnfijo,
                                             lc_FONOT            => lc_tlfnage,
                                             lc_CELUL            => lc_tlfncelular,
                                             ln_FCHRLLB          => ln_fechrellabext, ---26.03.2018--RLIVISI                                                                                          
                                             ln_PROFE            => ln_CodProf,
                                             lc_ESTCIV           => lc_EstCivil,
                                             ln_FNACI            => ln_fchnaci, --Cambiar DATE por number
                                             lc_SEXO             => lc_sexo,
                                             lc_NCONY            => lc_nomcomcy,
                                             ln_FNCONY           => ln_fchnacicy, --Cambiar DATE por number
                                             lc_tlfncy           => lc_tlfncy, ---10.05.2018--RLIVISI                                                                                   
                                             lc_CARGO            => lc_cargo,
                                             ld_fechproc         => pd_fecpro,
                                             ln_MtoSolic         => ln_MtoSolicitado, --14/03/2018--RLIVISI
                                             ln_MtoAprob         => ln_MtoAprobado,
                                             ln_MdaMtoAprobNuevo => ln_MdaMtoAprbNuevo, --26/09/2018--RLIVISI 
                                             lc_CodProd          => lc_CodProducto,
                                             lc_flgtrab          => lc_flgtrabajador, --14/03/2018--RLIVISI
                                             ln_EstSoli          => ln_EstSolicitud,
                                             lc_CodRptaSolic     => lc_CodRptaSoli,
                                             lc_RptaSolic        => lc_RptaSoli,
                                             /*ln_IndDependiente => ln_IndDepen,*/
                                             ln_codactecono    => ln_codactecono, --19.03.2018--RLIVISI
                                             lc_CanalSolicitud => lc_CanalSolicitud); --13/11/2018---RLIVISI
        
        end if; --Reubicación de esta sentencia ---24.04.2018--RLIVISI
      
      end if;
    
      commit; ----09.03.2018
    
    end loop;
  
  END SP_CR_SOLICITUDESDECREDITO;
  ----------------------------------------------------------------------------------
  procedure sp_cr_soli_clientes(LN_PGCOD     in number,
                                LN_CUENTA    in number,
                                JAQY842TIDCL out VARCHAR2,
                                ln_pais1     out varchar2,
                                ln_tdoc1     out varchar2,
                                lc_ndoc1     out varchar2,
                                pc_tippers   out varchar2,
                                lc_priape    out varchar2,
                                lc_segape    out varchar2,
                                lc_prinom    out varchar2,
                                lc_segnom    out varchar2,
                                lc_nomcom    out varchar2,
                                ln_fchnaci   out NUMBER,
                                lc_sexo      out varchar2,
                                lc_nomcomcy  out varchar2,
                                ln_fchnacicy out NUMBER,
                                lc_EstCivil  out varchar2,
                                /*ln_FchRelLab     out NUMBER,*/ --23.03.2018--RLIVISI
                                lc_DirecTit      out varchar2,
                                lc_DatDirec      out varchar2,
                                ln_pais          out number,
                                ln_tdoc          out number,
                                lc_ndoc          out varchar2,
                                ln_CodProf       out number,
                                lc_NomCentroLab  out varchar2, ---23.03.2018---RLIVISI
                                lc_tlfncelular   out varchar2,
                                lc_tlfnfijo      out varchar2,
                                lc_tlfncy        out varchar2,
                                lc_flgtrabajador out varchar2) is
  
    cursor telefonos is
    
      select dotelfp lc_tlfn, length(trim(dotelfp)) ln_longitud
        from fsr005 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.docod = 1;
  
    ln_paiscy number(5);
    ln_tdoccy number(5);
    lc_ndoccy char(12);
    --lc_ndoccyFin varchar2(12); 
  
    lc_flag   varchar(1) := 'N';
    lc_pendoc character(12);
  
    lc_distrito  character(30);
    lc_provnc    character(30);
    lc_departmnt character(20);
  
    ln_CodEstCivil number;
    --lc_tlfncelular varchar2(12);
    -- lc_tlfnfijo varchar2(12);
    ln_longitud      number;
    ln_longitudcy    number; ----28.03.2018---RLIVISI
    lc_tlfncelularcy varchar(20); -----24.04.2018--RLIVISI
    lc_tlfnfijocy    varchar(20); -----24.04.2018--RLIVISI
  
    -----ld_FchRelLab date; ---21.12.2017---RLIVISI
    ld_fchnaci   date; ---21.12.2017---RLIVISI
    ld_fchnacicy date; ---21.12.2017----RLIVISI
    lc_pfebco    varchar2(2) := 'N';
    --lc_tlfncy    varchar2(20) := null; -----28.03.2018---RLIVISI ya tipificacion en par
  
  begin
  
    lc_flgtrabajador := null; --'N';
    begin
      select d.pfebco /*'S'*/, /*D.PFFIBC,*/ d.pfeciv ---16.03.2018---RLIVISI
        into lc_pfebco, /*ld_FchRelLab,*/ ln_CodEstCivil
        from fsd002 d, fsr008 sr
       where d.pfpais = sr.pepais
         and d.pftdoc = sr.petdoc
         and d.pfndoc = sr.pendoc
         and sr.ctnro = LN_CUENTA
         and sr.pgcod = LN_PGCOD
         and sr.cttfir = 'T';
    
    exception
      when no_data_found then
        lc_pfebco := 'N'; ----27.02.2018---RLIVISI
        --ld_FchRelLab     := null; ----27.02.2018---RLIVISI
        ln_CodEstCivil := 0; ----27.02.2018---RLIVISI     
    
    end;
  
    --ln_FchRelLab := to_number(to_char(ld_FchRelLab, 'YYYYMMDD')); ---210.12.2017---RLIVISI
  
    if lc_pfebco = 'S' then
      lc_flgtrabajador := 'S'; ---trabajador de Caja AQP ---23.03.2018 --RLIVISI
    else
      lc_flgtrabajador := 'N'; ---cliente externo ---23.03.2018 --RLIVISI    
    end if;
  
    -- if lc_flgtrabajador = 'S' then
  
    if ln_CodEstCivil = 1 then
      lc_EstCivil := 'C'; --  Casado 
    else
      if ln_CodEstCivil = 2 then
        lc_EstCivil := 'D'; -- Divorciado
      else
        if ln_CodEstCivil = 3 then
          lc_EstCivil := 'U'; -- Conviviente  
        else
          if ln_CodEstCivil = 4 then
            lc_EstCivil := 'S'; --  Soltero   
          else
            if ln_CodEstCivil = 5 then
              lc_EstCivil := 'V'; -- Viudo          
            else
              if ln_CodEstCivil = 6 then
                lc_EstCivil := 'P'; --  Separado                 
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_tdoc, lc_ndoc
        from fsr008 f
       where f.pgcod = LN_PGCOD
         and f.ctnro = LN_CUENTA
         and f.cttfir = 'T';
    exception
      when no_data_found then
        ln_pais := 0; --27.02.2018 ---RLIVISI
        ln_tdoc := 0; --27.02.2018 ---RLIVISI
        lc_ndoc := null; --27.02.2018 ---RLIVISI       
    end;
  
    lc_pendoc := RPAD(lc_ndoc, 12, ' ');
  
    begin
    
      select f.petipo
        into pc_tippers
        from fsd001 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_pendoc;
    exception
      when no_data_found then
        pc_tippers := null; --27.02.2018 ---RLIVISI     
    end;
  
    begin
      -- Direccion del Titular domicilio
    
      select gc.sngc13dir, f.fst071dsc, t.locnom, c.depnom
        into lc_DirecTit, lc_distrito, lc_provnc, lc_departmnt
      
        from sngc13 gc, fst071 f, fst070 t, fst068 c
       where gc.sngc13pais = ln_pais
         and gc.sngc13tdoc = ln_tdoc
         and gc.sngc13ndoc = lc_pendoc
         and gc.docod = 1
         and gc.sngc13est = 'H'
         and gc.sngc13dist = f.fst071col
         and gc.sngc13prov = t.loccod
         and gc.sngc13dpto = c.depcod
         and gc.sngc13prov = f.fst071loc
         and gc.sngc13dpto = f.fst071dpt;
      lc_DatDirec := trim(lc_distrito) || ', ' || trim(lc_provnc) || ', ' ||
                     trim(lc_departmnt);
    
    exception
      when no_data_found then
        lc_DirecTit  := null; --27.02.2018 ---RLIVISI
        lc_distrito  := null; --27.02.2018 ---RLIVISI
        lc_provnc    := null; --27.02.2018 ---RLIVISI
        lc_departmnt := null; --27.02.2018 ---RLIVISI  
      WHEN OTHERS THEN
        lc_DirecTit  := null; --27.02.2018 ---RLIVISI
        lc_distrito  := null; --27.02.2018 ---RLIVISI
        lc_provnc    := null; --27.02.2018 ---RLIVISI
        lc_departmnt := null; --27.02.2018 ---RLIVISI    
    end;
  
    --lc_DatDirec := trim(lc_distrito) || ', ' || trim(lc_provnc) || ', ' ||
    -- trim(lc_departmnt);
  
    begin
      -- Datos del Titular
      select f.pfape1,
             f.pfape2,
             f.pfnom1,
             f.pfnom2,
             trim(f.pfape1) || ' ' || trim(f.pfape2) || ' ' ||
             trim(f.pfnom1) || ' ' || trim(f.pfnom2),
             f.pffnac,
             f.pfcant
        into lc_priape,
             lc_segape,
             lc_prinom,
             lc_segnom,
             lc_nomcom,
             ld_fchnaci,
             lc_sexo ---21.12.2017---RLVISI
        from fsd002 f
       where f.pfpais = ln_pais
         and f.pftdoc = ln_tdoc
         and trim(f.pfndoc) = trim(lc_ndoc);
    
      ln_fchnaci := to_number(to_char(ld_fchnaci, 'YYYYMMDD')); --24.04.2018----1236 RLIVISI - MOVIDO
    
    exception
      when no_data_found then
        lc_priape  := null; --27.02.2018 ---RLIVISI
        lc_segape  := null; --18.07.2019 ---RLIVISI
        lc_prinom  := null; --18.07.2019---RLIVISI
        lc_segnom  := null; --18.07.2019 ---RLIVISI   
        lc_nomcom  := null; --18.07.2019 ---RLIVISI
        ld_fchnaci := null; --27.02.2018 ---RLIVISI
        lc_sexo    := null; --27.02.2018 ---RLIVISI
    
    end;
  
    -- Telefono / Celular del Cliente
    --substr(telefono,1,1)
    begin
      for t in telefonos loop
        if t.ln_longitud = 9 then
          lc_tlfncelular := trim(t.lc_tlfn);
        else
          if T.ln_longitud = 6 then
            lc_tlfnfijo := trim(t.lc_tlfn);
          end if;
        end if;
      end loop;
    end;
  
    begin
      -- Profesion y Datos del Centro Laboral
      select PROFCOD, e.pfxempr
        INTO ln_CodProf, lc_NomCentroLab ----23.03.2018---RLIVISI
        from FSE002 e
       where PFXPAIS = ln_pais
         AND PFXTDOC = ln_tdoc
         AND PFXNDOC = lc_ndoc; -- Relacion de Profesiones con la Persona  PROFCOD
    
    exception
      when no_data_found then
        ln_CodProf      := 0; --27.02.2018 ---RLIVISI
        lc_NomCentroLab := null;
      
    end;
  
    begin
      -- Verifica si tiene Conyuge
      begin
        select r.rppais, r.rptdoc, r.rpndoc, 'S'
          into ln_paiscy, ln_tdoccy, lc_ndoccy, lc_flag
          from fsr002 r
         where r.pepais = ln_pais
           and r.petdoc = ln_tdoc
           and trim(r.pendoc) = trim(lc_ndoc)
           and r.rpccyg = 66;
      exception
        when no_data_found then
          ln_paiscy := 0; --27.02.2018 ---RLIVISI
          ln_tdoccy := 0; --27.02.2018 ---RLIVISI
          lc_ndoccy := null; --27.02.2018 ---RLIVISI
          lc_flag   := null; --27.02.2018 ---RLIVISI
        --null; ---QUE ADA
      end;
    
      if lc_flag = 'S' then
        --UYYYYY
        begin
          -- Datos del Conyuge
          select trim(f.pfape1) || ' ' || trim(f.pfape2) || ' ' ||
                 trim(f.pfnom1) || ' ' || trim(f.pfnom2),
                 f.pffnac
            into lc_nomcomcy, ld_fchnacicy ---20.12.2017--RLIVISI
            from fsd002 f
           where f.pfpais = ln_paiscy
             and f.pftdoc = ln_tdoccy
             and f.pfndoc = lc_ndoccy;
        
          ln_fchnacicy := to_number(to_char(ld_fchnacicy, 'YYYYMMDD')); --COMENTADO ---24.04.2018 --RLIVISI
        
        exception
          when no_data_found then
            lc_nomcomcy  := null; ---27.02.2018--RLIVISI
            ld_fchnacicy := null; ---27.02.2018--RLIVISI 
            ln_fchnacicy := 0; ----19.03.2018---RLIVISI
        end;
        --ln_fchnacicy := to_number(to_char(ld_fchnacicy, 'YYYYMMDD'));
      
        begin
          select dotelfp, length(trim(dotelfp)) ---27.03.2018--RLIVISI
            into lc_tlfncy, ln_longitudcy
            from fsr005 tl
           where tl.pepais = ln_paiscy
             and tl.petdoc = ln_tdoccy
             and tl.pendoc = lc_ndoccy
             and tl.docod = 1;
        exception
          when no_data_found then
            lc_tlfncy     := null;
            ln_longitudcy := 0;
          when too_many_rows then
            begin
              select dotelfp, length(trim(dotelfp)) ---27.03.2018--RLIVISI
                into lc_tlfncy, ln_longitudcy
                from fsr005 tl
               where tl.pepais = ln_paiscy
                 and tl.petdoc = ln_tdoccy
                 and tl.pendoc = lc_ndoccy
                 and tl.docod = 1
                 and rownum = 1;
            end;
        end;
      
        if ln_longitudcy = 9 then
          lc_tlfncelularcy := trim(lc_tlfncy);
        else
          if ln_longitudcy = 6 then
            lc_tlfnfijocy := trim(lc_tlfncy);
          
          end if; ---27.03.2018--RLIVISI
        end if; ----24.04.2018---RLIVISI            
      
      end if;
    
      JAQY842TIDCL := lpad(trim(to_char(ln_tdoc)), 3, '0') ||
                      lpad(trim(to_char(lc_ndoc)), 15, '0');
    
      ln_pais1 := to_char(ln_pais);
      ln_tdoc1 := to_char(ln_tdoc);
      lc_ndoc1 := to_char(lc_ndoc);
    
    end;
  end sp_cr_soli_clientes;

  ----------------------------------------------------------------------------------------
  procedure sp_cr_Usuarios(ln_instancia   in number,
                           lc_asesor      out varchar2,
                           lc_usuario     out varchar2,
                           lc_usuarioconf out varchar2) is
  
  begin
    select sng001usi, sng001ase, sng001usc ---SE INTERCAMBIA ASESOR Y USUARIO--19.11.2018--RLIVISI
      into lc_asesor, lc_usuario, lc_usuarioconf
      from sng001
     where sng001inst = ln_instancia;
  exception
    when no_data_found then
      lc_asesor      := null; ----27.02.2018---RLIVISI
      lc_usuario     := null; ----27.02.2018---RLIVISI      
      lc_usuarioconf := null; ---11.05.2018---RLIVISI 
  end sp_cr_Usuarios;

  -----------------------------------------------------------------------------------------
  procedure sp_cr_TipoSolicitud(ln_instancia in number,
                                ln_TipoSoli  out number) is
  
  begin
    select sng001ori
      into ln_TipoSoli
      from sng001
     where sng001inst = ln_instancia;
  exception
    when no_data_found then
      ln_TipoSoli := '99'; ---99-No existe en Tipos de Solicitud---08.03.2018--RLIVISI    
  
  end sp_cr_TipoSolicitud;

  ---------------------------------------------------------------------------------------   
  procedure sp_cr_EstadoSolicitud(ln_instancia    in number,
                                  ln_EstSolicitud out number) is
  begin
    select a.wftaskcod
      into ln_EstSolicitud
      from wfwrkitems a
     where a.wfinsprcid = ln_instancia
       and a.wfitemstsact = 1;
  exception
    when no_data_found then
      ln_EstSolicitud := 0; ---verificar que 0 no significa nada
  
  end sp_cr_EstadoSolicitud; ---14/03/2018----RLIVISI

  ---------------------------------------------------------------------------------------     
  procedure sp_cr_CodRptaSoli(ln_instancia   in number,
                              lc_CodRptaSoli out char) is
  
  begin
    select b.wfstscod
      into lc_CodRptaSoli
      from wfwrkitems b
     where b.wfinsprcid = ln_instancia
       and b.wfitemstsact = 1;
  
  exception
    when no_data_found then
      lc_CodRptaSoli := null;
    
  end sp_cr_CodRptaSoli; -----20/03/2018----RLIVISI  
  ---------------------------------------------------------------------------------------
  procedure sp_cr_RptaSoli(ln_CodRptaSoli in char, lc_RptaSoli out char) is
  
  begin
    select c.wfstsdsc
      into lc_RptaSoli
      from wfstate1 c
     where c.wfstscod = ln_CodRptaSoli
       and c.wflngid = 'spa';
  
  exception
    when no_data_found then
      lc_RptaSoli := null;
  end sp_cr_RptaSoli; -----20/03/2018--RLIVISI  

  ----------------------------------------------------------------------------------------
  procedure sp_cr_MontoSolicitado(ln_instancia     in number,
                                  ln_MtoSolicitado out number) is
  
  begin
    select sng120mto
      into ln_MtoSolicitado
      from sng120 a
     where a.sng120ins = ln_instancia
       and a.sng120tsk = 'SOLICITUD';
  exception
  
    when no_data_found then
      ln_MtoSolicitado := 0;
  end sp_cr_MontoSolicitado; -----14/03/2018----RLIVISI    

  ----------------------------------------------------------------------------------------
  procedure sp_cr_MontoAprobado(ln_instancia       in number,
                                ln_MtoAprobado     out number,
                                ln_MdaMtoAprbNuevo out number) is
    ln_MdaMtoAprb number(4); ---26/09/2018--RLIVISI
  begin
    select sng120mto, sng120mda
      into ln_MtoAprobado, ln_MdaMtoAprb
      from sng120 b
     where b.sng120ins = ln_instancia
       and b.sng120tsk = 'APROBACION';
  exception
    when no_data_found then
      ln_MtoAprobado := 0;
      ln_MdaMtoAprb  := 99; --no existe data ---08.05.2018---RLIVISI
    
      if ln_MdaMtoAprb = 0 then
        ln_MdaMtoAprbNuevo := 604;
      else
        if ln_MdaMtoAprb = 101 then
          ln_MdaMtoAprbNuevo := 840;
        end if;
      end if; ---26/09/2018---RLIVISI       
  
  end sp_cr_MontoAprobado; -----14/03/2018----RLIVISI 

  ----------------------------------------------------------------------------------------
  procedure sp_cr_DatosClienteTrabajCaja(ln_pgcod    in number,
                                         ln_pais     in number,
                                         ln_tdoc     in number,
                                         lc_ndoc     in char,
                                         lc_CodCargo out number, /*sng055.sng055dsc%type,*/
                                         /*lc_nombemprsa     out varchar2,*/ /*lc_nombagenc out varchar2,    lc_diragen    out varchar2,                                                                                                                                                                                                            lc_tlfnage    out varchar2,*/
                                         lc_UsuTrab        out character,
                                         lc_datosdirectrab out varchar2) is
  
    --ln_ciudagen fst001.scciud%type; -- character(20); -17/07/2018--RLIVISI
    --ln_deptagen character(15); --17/07/2018--RLIVISI
    --lc_diragen1 character(25); -17/07/2018--RLIVISI
    --lc_diragen2 number; -17/07/2018--RLIVISI
    --lc_tlfnage1 varchar2(20); -17/07/2018--RLIVISI
  
  begin
    begin
    
      begin
      
        select s.sng057usr, s.sng055car
          INTO lc_UsuTrab, lc_CodCargo
          from sng057 s, jaqn002 j
         where JAQN002PGC = ln_pgcod
           and JAQN002PAI = ln_pais
           AND JAQN002TDO = ln_tdoc
           AND JAQN002NDO = lc_ndoc
           and s.SNG057USR = J.JAQN002USR; --cargo
      exception
        when no_data_found then
          lc_UsuTrab  := null; ----27.02.2018---RLIVISI
          lc_CodCargo := null; ----27.02.2018---RLIVISI  
      end;
    
      begin
      
        select s.sng057usr, s.sng055car
          INTO lc_UsuTrab, lc_CodCargo
          from sng057 s, jaqn002 j
         where JAQN002PGC = ln_pgcod
           and JAQN002PAI = ln_pais
           AND JAQN002TDO = ln_tdoc
           AND JAQN002NDO = lc_ndoc
           and s.SNG057USR = J.JAQN002USR; --cargo
      exception
        when no_data_found then
          lc_UsuTrab  := null; ----27.02.2018---RLIVISI
          lc_CodCargo := null; ----27.02.2018---RLIVISI  
      end;
    
      /*      begin
        select f.pgnom
          into lc_nombemprsa
          from fst017 f
         where pgcod = ln_pgcod;
      exception
        when no_data_found then
          lc_nombemprsa := null; ----27.02.2018---RLIVISI
      
      end;*/
    
      --  lc_cargo := substr(lc_cargo1,1,25);
    end;
  
  end sp_cr_DatosClienteTrabajCaja;

  --------------------------------------------------------------------------
  procedure sp_cr_RelLabClienteTrabCaja(ln_pais         in number,
                                        ln_tdoc         in number,
                                        lc_ndoc         in char,
                                        ln_fechrellabcj out number) is
  
    -- ld_fechrellabo date := null;
  begin
  
    select to_number(to_char(dd.pffibc, 'YYYYMMDD')) --dd.pffibc
      into ln_fechrellabcj
      from fsd002 dd
     where dd.pfpais = ln_pais
       and dd.pftdoc = ln_tdoc
       and dd.pfndoc = lc_ndoc;
    /*       
    if  dd.pffibc = '1/01/0001' THEN
      ln_fechrellabcj:=null; ----10.05.2018 ---RLIVISI
    endif;    */ ---10.05.2018----OPTIMIZAR MAS AUN
  
  exception
    when no_data_found then
      ln_fechrellabcj := null;
    
  end sp_cr_RelLabClienteTrabCaja;
  --------------------------------------------------------------------------
  procedure sp_cr_RelLabClienteExterno(ln_pais          in number,
                                       ln_tdoc          in number,
                                       lc_ndoc          in char,
                                       ln_fechrellabext out number) is
  
    --ld_fechrellaboral date := null;
  begin
    select to_number(to_char(ee.sngc60fine, 'YYYYMMDD')) --to_number(to_char(to_date(ee.pfxfdes, 'YYYYMMDD')))--ee.pfxfdes
      into ln_fechrellabext
      from sngc60 ee --fse002 ee
     where ee.sngc60pais = ln_pais --ee.pfxpais = ln_pais
       and ee.sngc60tdoc = ln_tdoc --ee.pfxtdoc = ln_tdoc
       and ee.sngc60ndoc = lc_ndoc --ee.pfxndoc = lc_ndoc;
       and ee.sngc60corr = 0; -----10.05.2018---RLIVISI
  
  exception
    when no_data_found then
      ln_fechrellabext := null;
      --when many_rows then
    --   ln_fechrellabext:=  ---10.05.2018 ---RLIVISI
  
    --ln_fechrellabext := to_number(to_char(ld_fechrellaboral, 'YYYYMMDD'));
  
  end sp_cr_RelLabClienteExterno;
  --------------------------------------------------------------------------
  procedure sp_cr_activEconoCliente(ln_pais        in number,
                                    ln_tdoc        in number,
                                    lc_ndoc        in char,
                                    ln_IndDepen    out number,
                                    ln_codactecono out number) is
  
  begin
    select l.sngc60ocup, l.sngc60acte
      into ln_IndDepen, ln_codactecono
      from sngc60 l
     where l.sngc60pais = ln_pais
       and l.sngc60tdoc = ln_tdoc
       and l.sngc60ndoc = lc_ndoc
       and l.sngc60ocup in (1, 2);
  
  exception
    when no_data_found then
      ln_IndDepen    := 0;
      ln_codactecono := 0;
    when too_many_rows then
      begin
        select l.sngc60ocup, l.sngc60acte
          into ln_IndDepen, ln_codactecono
          from sngc60 l
         where l.sngc60pais = ln_pais
           and l.sngc60tdoc = ln_tdoc
           and l.sngc60ndoc = lc_ndoc
           and l.sngc60ocup in (1, 2)
           and l.sngc60corr =
               (select max(l.sngc60corr)
                  from sngc60 l
                 where l.sngc60pais = ln_pais
                   and l.sngc60tdoc = ln_tdoc
                   and l.sngc60ndoc = lc_ndoc
                   and l.sngc60ocup in (1, 2));
      end;
    
  end sp_cr_activEconoCliente;

  --------------------------------------------------------------------------

  procedure sp_cr_insertaJAQY842(lc_tndoc     in varchar2,
                                 lc_tdoc      in varchar2,
                                 lc_ndoc      in varchar2,
                                 lc_tpers     in varchar2,
                                 lc_tsoli     in varchar2,
                                 ln_instancia in number,
                                 lc_ncred     in varchar2, /*ln_MNTSOL    in number,*/
                                 ln_cta10     in number, ---RLIVISI---10.05.2018 
                                 ln_FCHING    in number,
                                 ln_HORING    in number,
                                 ln_SUC       in number,
                                 lc_ASE       in varchar2,
                                 lc_USU       in varchar2,
                                 lc_usuconf   in varchar2, ---11.05.2018--RLIVISI
                                 lc_PNOMB     in varchar2,
                                 lc_SNOMB     in varchar2,
                                 lc_PAPE      in varchar2,
                                 lc_SAPE      in varchar2,
                                 lc_NOMBC     in varchar2,
                                 lc_PAIS      in varchar2,
                                 /*lc_IDTRIB         in varchar2,*/
                                 lc_DIREC            in varchar2,
                                 lc_DDIR             in varchar2,
                                 lc_NTRAB            in varchar2,
                                 lc_DIRTRAB          in varchar2,
                                 lc_DDIRTRA          in varchar2,
                                 lc_FONOD            in varchar2,
                                 lc_FONOT            in varchar2,
                                 lc_CELUL            in varchar2,
                                 ln_FCHRLLB          in number,
                                 ln_PROFE            in number,
                                 lc_ESTCIV           in varchar2,
                                 ln_FNACI            in number,
                                 lc_SEXO             in varchar2,
                                 lc_NCONY            in varchar2,
                                 ln_FNCONY           in number,
                                 lc_tlfncy           in varchar2, ---10.05.2018--RLIVISI
                                 lc_CARGO            in varchar2,
                                 ld_fechproc         in date,
                                 ln_MtoSolic         in number,
                                 ln_MtoAprob         in number,
                                 ln_MdaMtoAprobNuevo in number, --07/05/2018--RLIVISI
                                 lc_CodProd          in varchar2,
                                 lc_flgtrab          in varchar2,
                                 ln_EstSoli          in number,
                                 lc_CodRptaSolic     in char,
                                 lc_RptaSolic        in char,
                                 /*ln_IndDependiente in number,*/
                                 ln_codactecono    in number,
                                 lc_CanalSolicitud in varchar2 --13/11/2018 --RLIVISI
                                 ) is
  
    ln_corr number; ----RLIVISI---01.03.2018--1737
  begin
  
    begin
      select count(*) into ln_corr from jaqY842;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
  
    insert into jaqY842 j
    /* (JAQY842CORR,    JAQY842TNDOC,  JAQY842TDOC,    JAQY842NDOC,    JAQY842TPERS, 
    JAQY842TSOLI,   JAQY842INS,    JAQY842NCRED,   JAQY842MNTSOL,  JAQY842FCHING,
    JAQY842HORING,  JAQY842SUC,    JAQY842ASE,     JAQY842USU,      JAQY842PNOMB,
    JAQY842SNOMB,   JAQY842PAPE,   JAQY842SAPE,    
    JAQY842NOMBC,   JAQY842PAIS,
    JAQY842IDTRIB,  JAQY842DIREC,  JAQY842DDIR,    JAQY842NTRAB,   JAQY842DIRTRAB,       
    JAQY842FONOD,   JAQY842FONOT,  JAQY842CELUL,                   JAQY842PROFE, 
    JAQY842ESTCIV,  JAQY842FNACI,   JAQY842SEXO,   JAQY842NCONY,   JAQY842FNCONY, 
    JAQY842FCHRLLB, JAQY842CARGO)*/
    
      (jaqy842corr,
       jaqy842tndoc,
       jaqy842tdoc,
       jaqy842ndoc,
       jaqy842tpers,
       jaqy842tsoli,
       jaqy842ins,
       jaqy842ncred,
       jaqy842ctnro,
       jaqy842fching,
       jaqy842horing,
       jaqy842suc,
       jaqy842ase,
       jaqy842usu,
       jaqy842usuaprb,
       jaqy842pnomb,
       jaqy842snomb,
       jaqy842pape,
       jaqy842sape,
       jaqy842nombc,
       jaqy842pais, /*jaqy842idtrib,*/
       jaqy842direc,
       jaqy842ddir,
       jaqy842ntrab,
       jaqy842dirtrab,
       jaqy842ddirtra,
       jaqy842fonod,
       jaqy842fonot,
       jaqy842celul,
       jaqy842fchrllb,
       jaqy842profe,
       jaqy842estciv,
       jaqy842fnaci,
       jaqy842sexo,
       jaqy842ncony,
       jaqy842fncony,
       jaqy842celcony,
       jaqy842cargo,
       jaqy842fecpro,
       jaqy842mntsol,
       jaqy842mtoaprb,
       jaqy842mdacta,
       jaqy842codprod,
       jaqy842ftrabcj,
       jaqy842stasoli,
       jaqy842codrpta,
       jaqy842desrpta, /*jaqy842segtrab,*/
       jaqy842codacte,
       jaqy842canalso)
    
    values
      (ln_corr + 1,
       lc_tndoc,
       lc_tdoc,
       lc_ndoc,
       lc_tpers,
       lc_tsoli,
       ln_instancia,
       lc_ncred,
       ln_cta10,
       ln_FCHING,
       ln_HORING,
       ln_SUC,
       lc_ASE,
       lc_USU,
       lc_usuconf,
       lc_PNOMB,
       lc_SNOMB,
       lc_PAPE,
       lc_SAPE,
       lc_NOMBC,
       lc_PAIS, /*lc_IDTRIB,*/
       lc_DIREC,
       lc_DDIR,
       lc_NTRAB,
       lc_DIRTRAB,
       lc_DDIRTRA,
       lc_FONOD,
       lc_FONOT,
       lc_CELUL,
       ln_FCHRLLB,
       ln_PROFE,
       lc_ESTCIV,
       ln_FNACI,
       lc_SEXO,
       lc_NCONY,
       ln_FNCONY,
       lc_tlfncy,
       lc_CARGO,
       ld_fechproc,
       ln_MtoSolic,
       ln_MtoAprob,
       ln_MdaMtoAprobNuevo,
       lc_CodProd,
       lc_flgtrab,
       ln_EstSoli,
       lc_CodRptaSolic,
       lc_RptaSolic, /* ln_IndDependiente,*/
       ln_codactecono,
       lc_CanalSolicitud);
  
    --Se actualiza la tabla JAQZ805 por JAQY842 con sus respectivos campos  
    --    
  
    commit;
  
  end sp_cr_insertaJAQY842;

  ----------------------------------------------------------------------------------
  procedure sp_cr_variablecambio(lc_digito in char, pd_fecpro in date) is
    ---Registro 533-Cambio de Creditos - 
    ---Cupos de Creditos
    ---DESPUES DEL DESEMBOLSO
    ---TABLA DE INSERCION: JAQY840
  
    --- Registro 533--Variable Cambio de Credito---Trama 2  ---RLIVISI
  
    cursor creditos is
      select to_char(ff.PGCOD) COD_ENTIDAD, ---Codigo de Entidad ---21.02.2018--RLIVISI
             ff.AOCTA CUENTA,
             lpad(trim(to_char(ff.AOCTA)), 9, '0') COD_CLIENTE, ---13.11.2018--RLIVISI                                                                lpad(trim(to_char(ff.AOTOPE)), 3, '0')*/ COD_CLIENTE, ---13.11.2018---RLIVISI
             ff.AOMOD COD_PRODUCTO, --Codigo del Producto ---21.02.2018--RLIVISI
             ww.*,
             ss.sng001ori,
             ww.xwfprcins INSTANCIA,
             ww.xwfcar3 car3
        from fsd010 ff, xwf700 ww, sng001 ss, wfwrkitems y, xwf070 x
       where ff.PGCOD = ww.xwfempresa
         and ff.AOMOD = ww.xwfmodulo
         and ff.AOSUC = ww.xwfsucursal
         and ff.AOMDA = ww.xwfmoneda
         and ff.AOPAP = ww.xwfpapel
         and ff.AOCTA = ww.xwfcuenta
         and ff.AOOPER = ww.xwfoperacion
         and ff.AOSBOP = ww.xwfsubope
         and ff.AOTOPE = ww.xwftipope
         and ww.xwfprcins = ss.sng001inst
         and ss.sng001inst = y.wfinsprcid
         and y.wftaskcod = 55 --desembolsados
         and y.wfitemid = x.xwfwrkite
         and ss.sng001ori in (3, 4, 13, 14, 15, 16)
         and ff.PGCOD = 1
         and ff.aostat <> 99
         and ff.aomod in (select modulo from fst111 where dscod = 50)
         and ff.aofval = pd_fecpro --ld_fecha--; --fecha valor en la FSD010-----------FECHA DE LA FSD010
            --and to_char(substr(to_char(ss.sng001inst), -1, 1))) = lc_digito;--('20/06/2017'); ----este
            -- and to_char(substr(trim(ss.sng001inst), -1, 1)) = lc_digito;---
            --select (substr(to_char(sng001inst), -1, 1)) from sng001_22032018;
         and substr(to_char(ss.sng001inst), -1, 1) = lc_digito;
  
    lc_ConcTipNroDoc varchar2(18); --Tipo de Documento + Nro de Identificacion
    ln_pgcodtrans    number(3); --Pgcod de la Transaccion
    ln_modtrans      number(3); --Modulo de la Transaccion
    ln_sucortrans    number(3); --Sucursal de la Transaccion   
    ln_transaccion   number(3); --Transaccion
    ln_reltrans      number(4); --Relacion de la Transaccion
    ld_fchtrans      date; --Fecha de la Transaccion
    lc_UsuAprbNov    varchar2(10); --Cod de Usuario que aprueba la Novedad ----26.02.2018--RLIVISI
    ld_fechNovedad   date; --Fecha de la Novedad (Date)--------26.02.2018--RLIVISI
    ln_fechNov       number(8); --Fecha de la Novedad --N(8)-- ---26/02/2018--RLIVISI  
    lc_horaNovedad   varchar2(8); --Hora de la Novedad C(8)--------26.02.2018--RLIVISI 
    lc_ipPcIngNov    varchar2(15); ---IP de la PC donde se ingresó la Novedad ---19.11.2018 --RLIVISI
  
    ln_CodCargUsuAprbNov number; --Cod. del Cargo del Usuario que aprueba la Novedad
    lc_HH_nov            varchar2(2); ---26/02/2018--RLIVISI
    lc_MM_nov            varchar2(2); ---26/02/2018--RLIVISI
    lc_SS_nov            varchar2(2); ---26/02/2018--RLIVISI
    lc_horaSinPuntos_nov varchar2(6); ---26/02/2018--RLIVISI
    ln_horaSinPuntos_nov number(6); ---26/02/2018--RLIVISI
    ln_NroCuotasANov     number(10); ---26/02/2018 ---RLIVISI --Nro Cuotas ANTES DE NOVEDAD
    ln_NroCuotasDNov     number(10); ---26/02/2018 ---RLIVISI --Nro Cuotas DESPUES DE NOVEDAD
    ln_empre700          number(3);
    ln_sucur700          number(3);
    ln_mod700            number(3);
    ln_mda700            number(4);
    ln_pap700            number(4);
    ln_cta700            number(9);
    ln_oper700           number(9);
    ln_subop700          number(3);
    ln_tipope700         number(3);
    ln_inst700           number(10); ---10.05.2018 --RLIVISI
    lc_concmodtran       varchar(6); ----14.05.2018--RLIVISI
  
  begin
  
    for c in creditos loop
      ------------------------------------ 
      begin
        begin
          begin
            --if c.xwfcar3 <> '1' then
            select xf.xwfempresa,
                   xf.xwfsucursal,
                   xf.xwfmodulo,
                   xf.xwfmoneda,
                   xf.xwfpapel,
                   xf.xwfcuenta,
                   xf.xwfoperacion,
                   xf.xwfsubope,
                   xf.xwftipope,
                   xf.xwfprcins
              into ln_empre700,
                   ln_sucur700,
                   ln_mod700,
                   ln_mda700,
                   ln_pap700,
                   ln_cta700,
                   ln_oper700,
                   ln_subop700,
                   ln_tipope700,
                   ln_inst700
            
              from xwf700 xf
             where xf.xwfprcins = c.instancia
               and xf.xwfcar3 <> '1';
          exception
            when no_data_found then
              ln_empre700  := 0;
              ln_sucur700  := 0;
              ln_mod700    := 0;
              ln_mda700    := 0;
              ln_pap700    := 0;
              ln_cta700    := 0;
              ln_oper700   := 0;
              ln_subop700  := 0;
              ln_tipope700 := 0;
              ln_inst700   := 0; ----10.05.2018 --RLIVISI
          
            when others then
              begin
                select xf.xwfempresa,
                       xf.xwfsucursal,
                       xf.xwfmodulo,
                       xf.xwfmoneda,
                       xf.xwfpapel,
                       xf.xwfcuenta,
                       xf.xwfoperacion,
                       xf.xwfsubope,
                       xf.xwftipope,
                       xf.xwfprcins
                  into ln_empre700,
                       ln_sucur700,
                       ln_mod700,
                       ln_mda700,
                       ln_pap700,
                       ln_cta700,
                       ln_oper700,
                       ln_subop700,
                       ln_tipope700,
                       ln_inst700
                
                  from xwf700 xf
                 where xf.xwfprcins = c.instancia
                   and xf.xwfcar3 <> '1'
                   and rownum = 1;
              exception
                when others then
                  null;
                
                --when others then
              
                --insert into jaqy840_prueba
                --(jaqy840pcta, jaqy840poper, jaqy840pinst)
              
                -- values
                -- (ln_cta700, ln_oper700,ln_inst700);
              
                --commit; ---RLIVISI----26.02.2018 
              
              end;
            
          end; ------04.05.2018---RLIVISI 
        
          begin
            select count(*)
              into ln_NroCuotasANov
              from fsd601 cron
             where cron.pgcod = ln_empre700 --c.xwfempresa
               and cron.ppmod = ln_mod700 ------c.xwfmodulo
               and cron.ppsuc = ln_sucur700 --c.xwfsucursal--08.05.2018--RLIVISI
               and cron.ppmda = ln_mda700 --c.xwfmoneda 
               and cron.pppap = ln_pap700 --c.xwfpapel
               and cron.ppcta = ln_cta700 --c.xwfcuenta
               and cron.ppoper = ln_oper700 --c.xwfoperacion
               and cron.ppsbop = ln_subop700 --c.xwfsubope
               and cron.pptope = ln_tipope700 --c.xwftipope
               and cron.d601co = 'S';
            --and c.xwfcar3 <> '1'; ------ANTES DE LA NOVEDAD ---CONTAR NRO DE CUOTAS          
          
          exception
            when no_data_found then
              ln_NroCuotasANov := 0;
          end;
        end; --Ahi abarca a los 2
      
        if c.xwfcar3 = '1' then
          begin
            select count(*)
              into ln_NroCuotasDNov
              from fsd601 crono
             where crono.pgcod = c.xwfempresa
               and crono.ppcta = c.xwfcuenta
               and crono.ppmod = c.xwfmodulo
               and crono.ppsuc = c.xwfsucursal
               and crono.ppmda = c.xwfmoneda
               and crono.pppap = c.xwfpapel
               and crono.ppoper = c.xwfoperacion
               and crono.ppsbop = c.xwfsubope
               and crono.pptope = c.xwftipope
               and crono.d601co = 'S';
            --and c.xwfcar3 = '1'; ------DESPUES DE LA NOVEDAD ---CONTAR NRO DE CUOTAS --01.03.2018---RLIVISI         
          
          exception
            when no_data_found then
              ln_NroCuotasDNov := 0;
          end;
        end if;
      end;
    
      -----------------       
    
      begin
        select trim(to_char(f8.petdoc)) || trim(f8.pendoc)
          into lc_ConcTipNroDoc --Concatenado TipoDeDocumento+NroDeDocumento
          from fsr008 f8
         where f8.ctnro = c.xwfcuenta
           and f8.cttfir = 'T';
      exception
        when no_data_found then
          lc_ConcTipNroDoc := null;
      end;
    
      begin
        select h.pgcod,
               h.hcmod,
               h.hsucor,
               h.htran,
               h.hnrel,
               h.hfcon,
               concat(to_char(h.hcmod), to_char(h.htran))
          into ln_pgcodtrans, --pogcod de la Transaccion
               ln_modtrans, --Modulo de la transaccion
               ln_sucortrans, --Sucursal de la Transaccion               
               ln_transaccion, --Transaccion
               ln_reltrans, --Nro de Relacion 
               ld_fchtrans, --Fecha de Relacion--
               lc_concmodtran --concatenado Modulo transaccion
          from fsh016 h
        /*where h.hfcon  = ld_fecha       
        and h.hcta   = c.xwfcuenta   ---Cuenta de la XWF700           
        and h.hoper  = c.xwfoperacion ---Operacion de la XWF700
        and h.pgcod  = c.xwfempresa   ---Empresa de la XWF700
        and h.hsucur = c.xwfsucursal  ---Sucursal de la XWF700
        and h.hmodul = c.xwfmodulo    ---Modulo de la XWF700
        and h.htoper = c.xwftipope    ---Tipo de Operacion de la XWF700
        and h.hmda   = c.xwfmoneda    ---Moneda de la XWF700
        and h.hpap   = c.xwfpapel     ---Papel de la XWF700
        and h.hsubop = c.xwfsubope;   ---Suboperacion de la XWF700 */
        
         where h.pgcod = c.xwfempresa --1  ---Empresa de la XWF700
           and h.hsucur = c.xwfsucursal -- 11 ---Sucursal de la XWF700
           and h.hmodul = c.xwfmodulo --106  ---Modulo de la XWF700
           and h.hmda = c.xwfmoneda --0 ---Moneda de la XWF700
           and h.hpap = c.xwfpapel --0 ---Papel de la XWF700
           and h.hcta = c.xwfcuenta --257195   ---Cuenta de la XWF700                         
           and h.hoper = c.xwfoperacion --3521920 ---Operacion de la XWF700
           and h.hsubop = c.xwfsubope --0 ---Suboperacion de la XWF700          
           and h.htoper = c.xwftipope --40 --Tipo de Operacion de la XWF700    
           and h.hcord = 10 --- Considerar solo ordinal 10-- 09/10/2018 RLIVISI-MPOSTIGOC
           and h.hcmod <> 98 -- Excluir transaccions batch --09/10/2018 RLIVISI-MPOSTIGOC
           and h.hfcon = pd_fecpro; --'01.04.2017'; ---fecha valor en la FSD010---fecha de contabilizado en la FSH016         
      exception
        when no_data_found then
          ln_pgcodtrans  := 0; --pogcod de la Transaccion
          ln_modtrans    := 0; --Modulo de la transaccion
          ln_sucortrans  := 0; --Sucursal de la Transaccion               
          ln_transaccion := 0; --Transaccion
          ln_reltrans    := 0; --Nro de Relacion 
          ld_fchtrans    := null; --Fecha de Relacion--
          lc_concmodtran := null; ----14.05.2048 ---RLIVISI
        when others then
          DBMS_OUTPUT.PUT_LINE(c.instancia);
        
      end;
    
      begin
        select f15.huscnf, f15.hwsing, f15.hfcon, f15.hhora -- HWSING C(15)--IP pc que ingresa novedad---19.11.2018--RLIVISI
          into lc_UsuAprbNov, --Cod de Usuario que aprueba la Novedad ---HUSCNF C(10) RLIVISI
               lc_ipPcIngNov, --IP de PC donde se ingresa la Novedad ---HWSING C(15) RLIVISI--19.11.2018
               ld_fechNovedad, --Fecha de la Novedad  (Date) RLIVISI
               lc_horaNovedad --Hora de la Novedad   C(8) RLIVISI
          from fsh015 f15
         where f15.pgcod = ln_pgcodtrans
           and f15.hcmod = ln_modtrans
           and f15.hsucor = ln_sucortrans
           and f15.htran = ln_transaccion
           and f15.hnrel = ln_reltrans
           and f15.hfcon = ld_fchtrans; -- 58070 -
      exception
        when no_data_found then
          lc_UsuAprbNov  := null;
          ld_fechNovedad := null;
          lc_horaNovedad := null;
      end;
    
      ln_fechNov           := to_number(to_char(ld_fechNovedad, 'yyyymmdd')); --26/02/2018---RLIVISI 
      lc_HH_nov            := substr(lc_horaNovedad, 1, 2); --26/02/2018---RLIVISI
      lc_MM_nov            := substr(lc_horaNovedad, 4, 2); --26/02/2018---RLIVISI
      lc_SS_nov            := substr(lc_horaNovedad, 7, 2); --26/02/2018---RLIVISI
      lc_horaSinPuntos_nov := concat(concat(lc_HH_nov, lc_MM_nov),
                                     lc_SS_nov); --26/02/2018---RLIVISI
      ln_horaSinPuntos_nov := to_number(lc_horaSinPuntos_nov); --26/02/2018---RLIVISI 
    
      begin
        select s57.sng055car
          into ln_CodCargUsuAprbNov ---Codigo de Cargo de Usuario que aprueba la Novedad --N(3)
          from sng057 s57
         where s57.sng055emp = 1
           and s57.sng057usr = lc_UsuAprbNov;
      exception
        when no_data_found then
          ln_CodCargUsuAprbNov := 0;
      end;
    
      pq_cr_monitor.sp_cr_insertaJAQY840(lc_Entidad     => c.cod_entidad,
                                         lc_TipNroDoc   => lc_ConcTipNroDoc, --Concatenado TipoDocumentoNroDoc
                                         lc_CodCliCaja  => c.cod_cliente,
                                         lc_CodProd     => c.cod_producto, --Cod del Producto
                                         lc_CodTran     => lc_concmodtran, --ln_transaccion, --Cod de Transacción
                                         lc_UsuAprb     => lc_UsuAprbNov, --Cod. Usuario que aprueba la Novedad
                                         ln_CargUsu     => ln_CodCargUsuAprbNov, --Cod. del Cargo del Usuario que aprueba la Novedad
                                         lc_NroIP       => lc_ipPcIngNov, -- IP de PC que ingresa la novedad --RLIVISI---19.11.2018  
                                         ln_DatoAntNov  => ln_NroCuotasANov,
                                         ln_DatoPosNov  => ln_NroCuotasDNov,
                                         ln_FecNovedad  => ln_fechNov, --26.02.2018--RLIVISI 
                                         ln_HoraNovedad => ln_horaSinPuntos_nov, --26.02.2018--RLIVISI 
                                         ld_FechProc    => pd_fecpro); ----Actualizado---26.02.2018--RLIVISI  
    
    end loop;
  end sp_cr_variablecambio; --sp_cr_variablecambio;

  /*------
    adas --MPOSTIGO-RP ----29.11.2017      
    select *--f.huscnf,f.hfcon, f.hhora
    from fsh015 f
    where f.pgcod = 1
     and f.hcmod = 30
     and f.hsucor = 44
     and f.htran = 360
     and f.hnrel = 1
     and f.hfcon = '15/04/2017'; -- 58070,58075,58076
     
  select s.sng055car from sng057 s where s.sng055emp = 1 and s.sng057usr = 'LBARRIONUE'; -- cod cargo 58071
  select * from sng055 d where d.sng055emp = 1 and d.sng055car = 51; -- descrip del cargo diccionario de los puestos
  
    
  select * from xwf700 where xwfprcins = 2783664 and xwfcar3 <> '1'; -- Clave del credito anterior a la novedad
  
  select count(*)
    from fsd601 f
  where f.pgcod = 1
     and f.ppmod = 106
     and f.ppsuc = 44
     and f.ppmda = 0
     and f.pppap = 0
     and f.ppcta = 1196239
     and f.ppoper = 2020810
     and f.ppsbop = 0
     and f.pptope = 1
     and d601co = 'S'; -- Dato anterior a la novedad
     
  select * from xwf700 where xwfprcins = 2783664 and xwfcar3 = '1'; -- Clave del credito posterior a la novedad 
  
  select count(*)
    from fsd601 f
  where f.pgcod = 1
     and f.ppmod = 106
     and f.ppsuc = 44
     and f.ppmda = 0
     and f.pppap = 0
     and f.ppcta = 1196239
     and f.ppoper = 3630369
     and f.ppsbop = 0
     and f.pptope = 1
     and d601co = 'S'; -- Dato anterior a la novedad        
    */

  ----------------------------------------------------------------------------------
  procedure sp_cr_insertaJAQY840(lc_Entidad     in varchar2, --jaqy840entidad--V4)
                                 lc_TipNroDoc   in VARCHAR2, --jaqy840tndoc --V(18)
                                 lc_CodCliCaja  in VARCHAR2, --jaqy840idclien --V(27) 
                                 lc_CodProd     in VARCHAR2, --jaqy840codprod --Cod Producto --V(5)
                                 lc_CodTran     in VARCHAR2, --jaqy840codtran --Cod Transaccion--V(5)                         
                                 lc_UsuAprb     in VARCHAR2, --jaqy840usu     --Cod Usuario aprueba--V(20) 
                                 ln_CargUsu     in number, --jaqy840cargusu --Cod Cargo de Usuario N(5)
                                 lc_NroIP       in VARCHAR2, --*/ --jaqy840ip      --IP realizo la Novedad V(15)
                                 ln_DatoAntNov  in number, --jaqy840dantnov --NroCuotas AntesDelCambio V(60)
                                 ln_DatoPosNov  in number, --jaqy840dposnov --NroCupotas DespuesDelCambio V(60)
                                 ln_FecNovedad  in number, --jaqy840fecnov  --FechaDeNovedad N(8)
                                 ln_HoraNovedad in number, --jaqy840horanov --HoraDeNovedad N(6)                                 
                                 ld_FechProc    in date) is
    --jaqy840fecproc --Fecha de Proceso (Date)
  
    ln_corr number;
  begin
  
    begin
      select count(*)
        into ln_corr
        from jaqy840 c
       where c.jaqy840fecproc = ld_FechProc; -----21.12.2017---RLIVISI
    exception
      when no_data_found then
        ln_corr := 0;
    end;
  
    insert into jaqy840
      (jaqy840corr,
       jaqy840entidad,
       jaqy840tndoc,
       jaqy840idclien,
       jaqy840codprod,
       jaqy840codtran,
       jaqy840usu,
       jaqy840cargusu,
       jaqy840ip, ---19.11.2018 ---RLIVISI
       jaqy840dantnov,
       jaqy840dposnov,
       jaqy840fecnov,
       jaqy840horanov,
       jaqy840fecproc)
    
    values
      (ln_corr + 1,
       lc_Entidad,
       lc_TipNroDoc,
       lc_CodCliCaja,
       lc_CodProd,
       lc_CodTran,
       lc_UsuAprb,
       ln_CargUsu,
       lc_NroIP, ----19.11.2018---RLIVISI
       ln_DatoAntNov,
       ln_DatoPosNov,
       ln_FecNovedad,
       ln_HoraNovedad,
       ld_FechProc);
  
    commit; ---RLIVISI----26.02.2018
  
  end sp_cr_insertaJAQY840; ---19Dic2017---RLIVISI  
  ----------------------------------------------------------------------------------
  ----///------Desde aqui
  procedure sp_cr_obtenDataExper(lc_digito in varchar2, pd_fecpro in date) is
    ----TRAMA EXPERIAN---REGISTRO 917---TABLA DE INSERCION: JAQY841 
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_TipoSolicitud
    -- Sistema                    : BANTOTAL0
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 08/03/2018
    -- Autor de Creación          : RLIVISI 
    -- Uso                        : RETORNA CODIGO DE TIPO DE SOLICITUD
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : sng001inst
    -- Parámetros de Salida       : CODIGO DE TIPO DE SOLICITUD 
    --                            : 
    -- Fecha de Modificación      : 06.06.2019
    -- Autor de la Modificación   : RLIVISI
    -- Descripción de Modificación: Se omite acceso a tabla JAQY728 para reemplazarse
    --                            : por AQPA011L-JAQY599A para la obtención de instancia. 
    -- ************************************************************************************  
    cursor exper is
    
      SELECT CONCAT(to_char(A.JAQL546TIDOB), A.JAQL546NUDOC) ln_TipoNroDoc,
             A.JAQL546TIDOB ln_TipDoc,
             A.JAQL546NUDOC ln_NroDoc,
             to_number(to_char(JAQL546FEENV, 'yyyymmdd')) ln_FchEnvio,
             JAQL546FEENV ld_FchEnvio,
             JAQL546HOENV lh_HraEnv,
             JAQL546USCOD lc_Usuario,
             JAQL546SERIAL lc_Serial,
             a.JAQL546NUCOn ln_Nucon
        FROM JAQL546 A
       where a.jaql546feenv = pd_fecpro --ld_fecha      
       and to_char(substr(trim(a.jaql546nudoc), -1, 1)) = lc_digito; ----21.03.2018--RLIVISI
       /*and a.JAQL546NUCOn = B.JAQY728NUOPE*/
  
    ln_instan        number(9) := 0; ------sng001
    ln_NroCuenta     number(9);
    lc_Cuenta        varchar2(9);
    lc_HH            varchar2(2); ---12/12/2017--RLIVISI
    lc_MM            varchar2(2); ---12/12/2017--RLIVISI
    lc_SS            varchar2(2); ---12/12/2017--RLIVISI
    lc_horaSinPuntos varchar2(6); ---12/12/2017--RLIVISI
    ln_horaSinPuntos number(6);
    ln_nucon_nuevo   number(10); -----06.06.2019 --RLIVISI
  
  begin
    --DELETE FROM JAQY841 D Where d.jaqy841fecpro = ld_fecha;---22.03.2018--RLIVISI
  
    for e in exper loop
      ln_NroCuenta := 0;
      ln_instan := 0;
    
      if e.ln_nucon <> 0 then
        --begin ---- //----06.06.2019 ---RLIVISI
      
        --/////--------------------------06.06.2019-------------a comentar 
        /*        begin
          select distinct j.jaqy728inst
            into ln_instan --variable definida fuera 
            from jaqy728 j
           where j.jaqy728nuope = e.ln_nucon
             and j.jaqy728fec = e.ld_fchenvio;
        exception
          when others then
            ln_instan := 0;
          
        end;*/
        -----/////------------------------06.06.2019------------
        ---Agregado desde aca---06.06.2019 ---RLIVISI
        /*begin
          select max(l.aqpa011lnucon)
            into ln_nucon_nuevo
            from AQPA011L L
           where l.aqpa011ltdoc = e.ln_tipdoc
             and l.aqpa011lndoc = e.ln_nrodoc
             and l.aqpa011lburo = 1 --EXPERIAN
             and l.aqpa011lseria = e.lc_serial;
        exception
          when others then
            ln_nucon_nuevo := 0;
        end;*/
        ln_nucon_nuevo := e.ln_nucon;
        begin
        
          select JAQY599ainst
            into ln_instan ---variable objetivo--06.06.2019 ---RLIVISI 
            from (select *
                    from jaqy599A Y
                   where Y.JAQY599ANUOPE = ln_nucon_nuevo
                   order by y.jaqy599afec desc, y.jaqy599ahor desc)
           where rownum = 1;
        
        exception
          when others then
            ln_instan := 0;
        end;
      
        ---Agregado hasta aca---06.06.2019 ---RLIVISI
        ---instancia 
        if ln_instan <> 0 then
        
          begin
            ---cuenta
            select g.sng001cta
              into ln_NroCuenta
              from sng001 g
             where g.sng001inst = ln_instan;
          exception
            when others then
              ln_NroCuenta := 0;
          end;
        end if;
      
        lc_HH            := substr(e.lh_hraenv, 1, 2); --12/12/2017---RLIVISI
        lc_MM            := substr(e.lh_hraenv, 4, 2); --12/12/2017---RLIVISI
        lc_SS            := substr(e.lh_hraenv, 7, 2); --12/12/2017---RLIVISI
        lc_horaSinPuntos := concat(concat(lc_HH, lc_MM), lc_SS); --12/12/2017--RLIVISI
        ln_horaSinPuntos := to_number(lc_horaSinPuntos);
      
        if ln_NroCuenta <> 0 then
        
          lc_Cuenta := to_char(ln_NroCuenta);
        
          pq_cr_monitor.sp_cr_insertaJAQY841(lc_TipNroDoc => e.ln_tiponrodoc,
                                             lc_TipDoc    => e.ln_tipdoc,
                                             lc_NroDoc    => e.ln_nrodoc,
                                             ln_FecEnv    => e.ln_FchEnvio,
                                             /*lc_NroIP       => '000',*/ --02.05.2018
                                             ln_HoraEnv     => ln_horaSinPuntos, --e.lh_hraenv,
                                             lc_UsuConsulta => e.lc_usuario,
                                             ln_CodBuro     => 1, --'EXPERIAN'--e.lc_serial,
                                             lc_NroCta      => lc_Cuenta,
                                             ld_fecproc     => pd_fecpro);
        
          commit; --10.05.2018 ---RLIVISI
        end if;
      
      else
        if e.ln_nucon = 0 then
          begin
            select r.ctnro --g.sng001cta
              into ln_NroCuenta --nrocta_sng001
              from fsr008 r --sng001 g
             where r.petdoc = e.ln_tipdoc --g.sng001tdoc = e.ln_tipdoc
               and r.pendoc = e.ln_nrodoc
               and r.cttfir = 'T'
               and rownum = 1; --g.sng001ndoc = e.ln_nrodoc;
          exception
            when others then
              ln_NroCuenta := 0;
          end;
        end if;
      
        if ln_NroCuenta <> 0 then
        
          lc_Cuenta := to_char(ln_NroCuenta);
          pq_cr_monitor.sp_cr_insertaJAQY841(lc_TipNroDoc => e.ln_tiponrodoc,
                                             lc_TipDoc    => e.ln_tipdoc,
                                             lc_NroDoc    => e.ln_nrodoc,
                                             ln_FecEnv    => e.ln_FchEnvio,
                                             /*lc_NroIP       => '000',*/ --02.05.2018
                                             ln_HoraEnv     => ln_horaSinPuntos, --e.lh_hraenv,
                                             lc_UsuConsulta => e.lc_usuario,
                                             ln_CodBuro     => 1, --'EXPERIAN'--e.lc_serial,
                                             lc_NroCta      => lc_Cuenta,
                                             ld_fecproc     => pd_fecpro);
        
          commit; --10.05.2018 ---RLIVISI      
        end if;
        --end; ----06.06.2019 ---RLIVISI
      end if;
    
    end loop;
  
  end sp_cr_obtenDataExper;

  ---///-------Hasta aqui

  -------------------------------------------------------------------------------

  procedure sp_cr_insertaJAQY841(lc_TipNroDoc in VARCHAR2, --jaqy841tndoc
                                 lc_TipDoc    in VARCHAR2, --jaqy841tdoc
                                 lc_NroDoc    in VARCHAR2, --jaqy841ndoc
                                 ln_FecEnv    in number, --jaqy841fecenv
                                 /*lc_NroIP       in VARCHAR2, --jaqy841ip  */ --02.05.2018                            
                                 ln_HoraEnv     in number, --jaqy841horenv--26.02.2018--RLIVISI
                                 lc_UsuConsulta in VARCHAR2, --jaqy841usucons
                                 ln_CodBuro     in NUMBER, --jaqy841codburo
                                 lc_NroCta      in VARCHAR2, --jaqy841ctnro---26.02.208--RLIVISI
                                 ld_fecproc     in date) is
  
    ln_corr number;
  begin
  
    begin
      select count(*)
        into ln_corr
        from jaqy841 b
       where b.jaqy841fecpro = ld_fecproc;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
  
    insert into jaqy841 j
      (jaqy841corr,
       jaqy841tndoc,
       jaqy841tdoc,
       jaqy841ndoc,
       jaqy841fecenv,
       /*jaqy841ip, */
       jaqy841horenv,
       jaqy841usucons,
       jaqy841codburo,
       jaqy841ctnro,
       JAQY841FECPRO)
    
    values
      (ln_corr + 1,
       lc_TipNroDoc,
       lc_TipDoc,
       lc_NroDoc,
       ln_FecEnv,
       /*lc_NroIP,*/
       ln_HoraEnv,
       lc_UsuConsulta,
       ln_CodBuro,
       lc_NroCta,
       ld_fecproc);
  
    commit;
  
  end sp_cr_insertaJAQY841; ---19Dic2017---RLIVISI
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  procedure sp_cr_obtenSdoRubroContable(lc_digito in varchar2,
                                        pd_fecpro in date) is
    ----TRAMA CONTABLE---REGISTRO 640---TABLA DE INSERCION: JAQY844   
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtenSdoRubroContable
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/06/2018
    -- Autor de Creación          : RLIVISI 
    -- Uso                        : RETORNA SALDOS DE RUBROS CONTABLES
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : FECHA DE CONTABILIZACION
    -- Parámetros de Salida       : SALDOS DE RUBROS CONTABLES
    --                            : 
    -- *****************************************************************  
  
    cursor rubrocont is
      SELECT HFCON  ld_cfechproc, ---06.07.2018---RLIVISI     
             HRUBRO ln_crubro
        FROM FSH016
       where HFCON = pd_fecpro -- Fecha de Procesamiento.            
         --and substr(to_char(HRUBRO), -1, 1) = lc_digito ----18/07/2018--RLIVISI---06.06.2019 --RLIVISI PARA PRUEBAS    
       group by HRUBRO, HFCON;
  
    lc_nomrubro char(40); ---26.06.2018 --RLIVISI
    ln_titulo   number(1); ---26.06.2018 --RLIVISI       
    lc_AcreDeu  char(1); ---26.06.2018 --RLIVISI
    lc_Impu     char(1); ---26.06.2018 --RLIVISI
  
    ln_tipCta    number(1); --05.07.2018  --RLIVISI
    ln_SubTipCta number(2); ---05.07.2018 ---RLIVISI
    lc_tipSdo    char(1); --26.06.2018 ---RLIVISI        
    lc_imputable char(1); ---12.07.2018 --RLIVISI 
    ln_pais      number(3) := 604; --604
    ln_cPGCOD    number(3) := 1; --23.07.2018---RLIVISI
    ln_sdoIniDia number(17, 2); --17/07/2018 --RLIVISI  
  
    ln_fecCreaCta  number(8); ---20.07.2018--RLIVISI
    ln_horaCreaCta number(6); ---20.07.2018--RLIVISI    
    lc_usucrearub  varchar2(50); --20.07.2018--RLIVISI
  
    ln_aniocons number(4); ---20.07.2018 ---RLIVISI
    ln_mescons  number(2); ---20.07.2018 ---RLIVISI
  
    ln_anioconsfinal number(4); --24.07.2018---RLIVISI
    ln_mesconsfinal  number(2); ---24.07.2018---RLIVISI
  
    --ln_SdoIniMes number(17,2);  ---25.07.2018 ---RLIVISI
    ln_SdoIniAnio number(17, 2); ---20.07.2018 ---RLIVISI
    pn_SdoCieMes  number(17, 2); ---24.07.2018  ---RLIVISI 
  
    --ln_SdoIniMes number(17,2); -----25.07.2018 ---RLIVISI   
  
    ln_cDiaAnt_fecproc  date; ---23.07.2018 ---RLIVISI
    ln_cdia_fecproc     number(2); ---23.07.2018 ---RLIVISI
    ln_cmes_fecproc     number(2); ---23.07.2018 ---RLIVISI
    ln_canio_fecproc    number(4); ---23.07.2018 ---RLIVISI
    ln_canioAnt_fecproc number(4); ---23.07.2018 ---RLIVISI
  
    ln_amlreg  number(6); ---25.04.2019 --RLIVISI      ln_jaqy844amlreg
    ln_amdlreg number(8); ---25.04.2019 --RLIVISI   ln_jaqy844feclreg
  
    --ln_jaqy844fecrant number(8);  ---25.04.2019 --RLIVISI
  
    --lc_diafp char(2); ---25.04.2019 --RLIVISI
    --lc_mesfp char(2); ---25.04.2019 --RLIVISI
    --lc_aniofp char(4); ---25.04.2019 --RLIVISI
  
  begin
    pq_cr_monitor.sp_cr_ObtenFechas(pd_fecpro,
                                    ln_cDiaAnt_fecproc,
                                    ln_cdia_fecproc,
                                    ln_cmes_fecproc,
                                    ln_canio_fecproc,
                                    ln_canioAnt_fecproc,
                                    ln_amlreg,
                                    ln_amdlreg); ---24.04.2019 ---RLIVISI          
    for r in rubrocont loop
      begin
        select D.PCNOMR, D.PMTIT, D.PCSIGP, D.PCIMPU
          into lc_nomrubro, ln_titulo, lc_AcreDeu, lc_Impu
          from FSD014 D
         where D.RUBRO = r.ln_crubro;
      exception
        when no_data_found then
          lc_nomrubro := null;
          ln_titulo   := 0;
          lc_AcreDeu  := null;
          lc_Impu     := null; --12.07.2018---RLIVISI 
      
        when others then
          lc_nomrubro := null;
          ln_titulo   := 0;
          lc_AcreDeu  := null;
          lc_Impu     := null; --28.06.2018---RLIVISI                     
      end;
    
      if (ln_titulo = 1 or ln_titulo = 2 or ln_titulo = 3 or ln_titulo = 4 or
         ln_titulo = 5 or ln_titulo = 6) then
        --Tipo de Cuenta ----05.07.2018 RLIVISI
        ln_tipCta := 1; ---Balance y Resultados
      else
        if (ln_titulo = 7 or ln_titulo = 8) then
          ln_tipCta := 2; ---Orden y Registro
        end if;
      end if;
    
      if ln_titulo = 1 then
        -----Sub Tipo de Cuenta       
        ln_SubTipCta := 1; --Activo
      else
        if ln_titulo = 2 then
          ln_SubTipCta := 2; --Pasivo
        else
          if ln_titulo = 3 then
            ln_SubTipCta := 3; --Capital
          else
            if ln_titulo = 4 then
              ln_SubTipCta := 4; --Ingresos
            else
              if ln_titulo = 5 then
                ln_SubTipCta := 5; --Egresos
              end if;
            end if;
          end if;
        end if;
      end if;
    
      if lc_AcreDeu = 'S' then
        ---Tipo de Saldo 
        lc_tipSdo := 'A'; --Acreedor
      else
        if lc_AcreDeu = 'N' then
          lc_tipSdo := 'D'; --Deudor
        end if;
      end if;
    
      if lc_Impu = 'S' then
        --Estado de la cuenta ---05.07.2018---RLIVISI
        lc_imputable := 'A'; --Activo
      else
        if lc_Impu = 'N' then
          lc_imputable := 'I'; --Inactiva
        end if;
      end if;
      --end;     
    
      pq_cr_monitor.sp_cr_creaRubro(r.ln_crubro,
                                    ln_fecCreaCta,
                                    ln_horaCreaCta,
                                    lc_usucrearub); ---16.07.2018 --RLIVISI*/                               
    
      pq_cr_monitor.sp_cr_SdoInicioDia(ln_cdiaant_fecproc,
                                       r.ln_crubro,
                                       ln_sdoIniDia);
    
      begin
        pq_cr_monitor.sp_cr_EvalMesAnio(ln_cmes_fecproc,
                                        ln_canio_fecproc,
                                        ln_aniocons,
                                        ln_mescons); -- ---20.07.2018 ---RLIVISI  
      
        pq_cr_monitor.sp_cr_SdoCieMes(ln_rubrocons     => r.ln_crubro,
                                      ln_anioconsfinal => ln_aniocons,
                                      ln_mesconsfinal  => ln_mescons,
                                      pn_SdoCieMes     => pn_SdoCieMes); ---20/07/2018--RLIVISI       
      end;
    
      pq_cr_monitor.sp_cr_SdoIniAnio(ln_canioant_fecproc,
                                     r.ln_crubro,
                                     ln_SdoIniAnio); ---20.07.2018 ---RLIVISI                  
    
      pq_cr_monitor.sp_cr_insertaJAQY844(ln_jaqy844pais    => ln_pais, --05.07.2018 --RLIVISI
                                         ln_jaqy844pgcod   => ln_cpgcod, --05.07.2018 --RLIVISI
                                         ln_jaqy844suc     => 11, --r.ln_csuctran, --05.07.2018 --RLIVISI
                                         ln_jaqy844ctacble => r.ln_crubro, --05.07.2018 --RLIVISI
                                         lc_jaqy844desccta => lc_nomrubro, --12.07.2018--RLIVISI
                                         lc_jaqy844ftotdet => 'T', --25.04.2019 --RLIVISI
                                         lc_jaqy844tipsdo  => lc_tipSdo, --05.07.2018 --RLIVISI 
                                         ln_jaqy844tipcta  => ln_tipCta, --05.07.2018 --RLIVISI  
                                         ln_jaqy844subtcta => ln_SubTipCta, --05.07.2018 --RLIVISI
                                         ln_jaqy844faux    => 2, --25.04.2019 --RLIVISI
                                         ln_jaqy844fccost  => 2, --25.04.2019 --RLIVISI 
                                         ln_jaqy844fpresup => 2, --25.04.2019 --RLIVISI                                      
                                         ln_jaqy844fecccta => ln_fecCreaCta, --10.07.2018 --RLIVISI
                                         ln_jaqy844horccta => ln_horaCreaCta, --10.07.2018 --RLIVISI
                                         lc_jaqy844usuccta => lc_usucrearub, --05.07.2018 --RLIVISI
                                         ln_jaqy844sdoidia => ln_sdoIniDia, --"1",           --05.07.2018 --RLIVISI
                                         ln_jaqy844sdoimes => pn_SdoCieMes, --ln_SdoCieMes,--"2",           --05.07.2018 --RLIVISI
                                         ln_jaqy844sdoiano => ln_SdoIniAnio, --"3",           --05.07.2018 --RLIVISI
                                         lc_jaqy844stscta  => lc_imputable, --05.07.2018 --RLIVISI                                         
                                         ln_jaqy844mdacont => 604, --ln_moneda, --25.04.2019 ---RLIVISI
                                         ln_jaqy844amlreg  => ln_amlreg, --25.04.2019 ---RLIVISI
                                         ln_jaqy844feclreg => ln_amdlreg, --25.04.2019 --RLIVISI                                        
                                         lc_jaqy844inderr  => 'N', --05.07.2018 --RLIVISI                                         
                                         ld_fecproc        => pd_fecpro); ---11.07.2018 --RLIVISI         
    
      commit; --10.05.2018 ---RLIVISI 
    end loop;
    --end; --if;  
  end sp_cr_obtenSdoRubroContable;

  ------------------------------------------------------------------------------------
  procedure sp_cr_ObtenFechas(ld_hfcon            in date,
                              ln_cDiaAnt_fecproc  out date,
                              ln_cdia_fecproc     out number,
                              ln_cmes_fecproc     out number,
                              ln_canio_fecproc    out number,
                              ln_canioAnt_fecproc out number,
                              ln_amlreg           out number,
                              ln_amdlreg          out number) is
  
   -- lc_diafp  char(2); ---25.04.2019 --RLIVISI
   -- lc_mesfp  char(2); ---25.04.2019 --RLIVISI
   -- lc_aniofp char(4); ---25.04.2019 --RLIVISI
  
   -- lc_jaqy844amlreg  char(6); ----25.04.2019 --RLIVISI
   -- lc_jaqy844feclreg char(8); ---25.04.20196--RLIVISI
    
    lc_fecproc  char(10); ---06.06.2019 ---RLIVISI
    lc_YYYY     char(4); ---06.06.2019---RLIVISI
    lc_MM       char(2); ---06.06.2019---RLIVISI
    lc_DD       char(2); ---06.06.2019---RLIVISI
    
    lc_amdlreg char(8); --06.06.2019 ---RLIVISI 
    --ln_amdlreg number(8); --06.06.2019 ---RLIVISI
    
    lc_amlreg  char(6); --06.06.2019 --RLIVISI
    --ln_amdlreg number(8); --06.06.2019 ---RLIVISI
   
  begin
  
   /* --06.06.2019 ---RLIVISI
    ln_cDiaAnt_fecproc  := ld_hfcon - 1; ---23.07.2018 --RLIVISI
    ln_cdia_fecproc     := to_number(EXTRACT(DAY FROM ld_hfcon)); -- ln_cdia_fecproc, ---23.07.2018 --RLIVISI
    ln_cmes_fecproc     := to_number(EXTRACT(MONTH FROM ld_hfcon)); --ln_cmes_fecproc, ---23.07.2018 --RLIVISI             
    ln_canio_fecproc    := to_number(EXTRACT(YEAR FROM ld_hfcon)); --ln_canio_fecproc,  ---23.07.2018 --RLIVISI
    ln_canioAnt_fecproc := to_number(EXTRACT(YEAR FROM ld_hfcon)) - 1; --ln_canioAnt_fecproc, -23.07.2018 --RLIVISI
  
    lc_diafp  := to_char(ln_cdia_fecproc); ---25.04.2019 --RLIVISI
    lc_mesfp  := to_char(ln_cmes_fecproc); ---25.04.2019 --RLIVISI
    lc_aniofp := to_char(ln_canio_fecproc); ---25.04.2019 --RLIVISI
  
    lc_jaqy844amlreg  := concat(lc_aniofp, lc_mesfp); ---25.04.2019 --RLIVISI
    ln_amlreg         := to_number(lc_jaqy844amlreg); --25.04.2019 --RLIVISI
    lc_jaqy844feclreg := concat(lc_jaqy844amlreg, lc_diafp); --25.04.2019 --RLIVISI
    ln_amdlreg        := to_number(lc_jaqy844feclreg); --25.04.2019 --RLIVISI
  
    --lc_jaqy844fecrant:=concat(lc_aniofp, lc_mesfp,lc_diafp); --25.04.2019 --RLIVISI
    --ln_jaqy844fecrant:= to_number(ln_jaqy844fecrant); ---25.04.2019 ----RLIVISI
  
    */
    ln_cDiaAnt_fecproc  := ld_hfcon - 1; ---06.06.2019 --RLIVISI
    
    lc_fecproc     := to_char(ld_hfcon, 'YYYY/MM/DD');  ---06.06.2019 ---RLIVISI 
        
    lc_DD          := substr(lc_fecproc, 9, 2); ---06.06.2019 ---RLIVISI    
    ln_cdia_fecproc:= to_number(lc_DD); ---06.06.2019 ---RLIVISI

    lc_MM           := substr(lc_fecproc, 6, 2); ---06.06.2019 ---RLIVISI
    ln_cmes_fecproc := to_number(lc_MM); --06.06.2019  ---RLIVISI 
        
    lc_YYYY         := substr(lc_fecproc, 1, 4); ---06.06.2019 ---RLIVISI
    ln_canio_fecproc:= to_number(lc_YYYY); ----06.06.2019 --RLIVISI    
        
    ln_canioAnt_fecproc := to_number(EXTRACT(YEAR FROM ld_hfcon)) - 1; --06.06.2019 ---RLIVISI
    
    lc_amdlreg := concat(concat(lc_YYYY, lc_MM), lc_DD); --06.06.2019 ---RLIVISI 
    ln_amdlreg := to_number(lc_amdlreg); --06.06.2019 ---RLIVISI

    lc_amlreg:=  concat(lc_YYYY, lc_MM); --06.06.2019 --RLIVISI
    ln_amlreg:= to_number(lc_amlreg); --06.06.2019 ---RLIVISI
        
  end sp_cr_ObtenFechas;

  ------------------------------------------------------------------------------------
  procedure sp_cr_creaRubro(ln_rubroc      in number,
                            ln_fecCreaCta  out number,
                            ln_horaCreaCta out number,
                            lc_usucrearub  out varchar2) is --10.07.2018---RLIVISI
  
  begin
    begin
      select to_number(to_char(d14.aud_fsd014_uon, 'YYYYMMDD')),
             to_number(to_char(d14.aud_fsd014_uon, 'HH24MMSS')),
             d14.aud_fsd014_ubu
        into ln_fecCreaCta, --fecha crea cta
             ln_horaCreaCta, --hora crea cta
             lc_usucrearub --usu crea cta
        from aud_fsd014_audit D14
       where d14.aud_new_rubro = ln_rubroc
         and d14.aud_fsd014_uas = 'I'; ---03.12.2018 ---RLIVISI
      --and max(d14.aud_fsd014_uon); --máxima fecha--24.07.2018--RLIVISI;    
    
    exception
      when no_data_found then
        ln_fecCreaCta  := 0; ---12.07.2018---RLIVISI
        ln_horaCreaCta := 0; ---12.07.2018---RLIVISI
        lc_usucrearub  := null; ---12.07.2018---RLIVISI
    
      when TOO_MANY_ROWS then
        begin
          select to_number(to_char(d14.aud_fsd014_uon, 'YYYYMMDD')),
                 to_number(to_char(d14.aud_fsd014_uon, 'HH24MMSS')),
                 d14.aud_fsd014_ubu
            into ln_fecCreaCta, --fecha crea cta
                 ln_horaCreaCta, --hora crea cta
                 lc_usucrearub --usu crea cta
            from aud_fsd014_audit D14
           where d14.aud_new_rubro = ln_rubroc
             and d14.aud_fsd014_uon =
                 (select max(x.aud_fsd014_uon)
                    from aud_fsd014_audit x
                   where x.aud_new_rubro = ln_rubroc);
        
        end;
    end;
  
  end sp_cr_creaRubro;

  -----------------------------------------------------------------------------------
  procedure sp_cr_SdoInicioDia(ln_diaant_fecproc in date, --10.07.2018--RLIVISI                             
                               ln_rubrocons      in number,
                               ln_sdoIniDia      out number) is
  begin
    select sum(h31.drsdmn)
      into ln_sdoIniDia ---25.04.2019 --RLIVISI
      from fsh031 h31
     where h31.drfch = ln_diaant_fecproc -----10.07.2018 --RLIVISI 
          /* and    h31.drsuc = ln_succons ---18/07/2018---RLIVISI */
       and h31.drrub = ln_rubrocons;
  
  exception
    when no_data_found then
      ln_sdoIniDia := 0;
      /*when others then
      ln_sdoIniDia:=0;   */
    -- end;            
  end sp_cr_SdoInicioDia;

  -----------------------------------------------------------------------------------
  procedure sp_cr_EvalMesAnio(ln_MesFechProc  in number,
                              ln_AnioFechProc in number,
                              ln_aniocons     out number,
                              ln_mescons      out number) is ---20/07/2018--RLIVISI
  begin
    if (ln_MesFechProc >= 2 and ln_MesFechProc <= 12) then
      ln_mescons  := ln_MesFechProc - 1;
      ln_aniocons := ln_AnioFechProc;
    else
      if (ln_MesFechProc = 1) then
        ln_mescons  := ln_MesFechProc + 11; --12; ---24.07.2018---RLIVISI
        ln_aniocons := ln_AnioFechProc - 1;
      end if;
    end if;
  
  end sp_cr_EvalMesAnio;

  ----------------------------------------------------------------------------------
  procedure sp_cr_SdoCieMes(ln_rubrocons     in number,
                            ln_anioconsfinal in number,
                            ln_mesconsfinal  in number,
                            pn_SdoCieMes     out number) is
    ---24.07.2018 --RLIVISI
  
    ln_SdoCieEne number(17, 2) := 0;
    ln_SdoCieFeb number(17, 2) := 0;
    ln_SdoCieMar number(17, 2) := 0;
    ln_SdoCieAbr number(17, 2) := 0;
    ln_SdoCieMay number(17, 2) := 0;
    ln_SdoCieJun number(17, 2) := 0;
    ln_SdoCieJul number(17, 2) := 0;
    ln_SdoCieAgo number(17, 2) := 0;
    ln_SdoCieSet number(17, 2) := 0;
    ln_SdoCieOct number(17, 2) := 0;
    ln_SdoCieNov number(17, 2) := 0;
    ln_SdoCieDic number(17, 2) := 0;
    ln_SdoCieMes number(17, 2) := 0;
  
  begin
  
    begin
      select sum(n.hrsd01),
             sum(n.hrsd02),
             sum(n.hrsd03),
             sum(n.hrsd04),
             sum(n.hrsd05),
             sum(n.hrsd06),
             sum(n.hrsd07),
             sum(n.hrsd08),
             sum(n.hrsd09),
             sum(n.hrsd10),
             sum(n.hrsd11),
             sum(n.hrsd12)
      
        into ln_SdoCieEne,
             ln_SdoCieFeb,
             ln_SdoCieMar,
             ln_SdoCieAbr,
             ln_SdoCieMay,
             ln_SdoCieJun,
             ln_SdoCieJul,
             ln_SdoCieAgo,
             ln_SdoCieSet,
             ln_SdoCieOct,
             ln_SdoCieNov,
             ln_SdoCieDic
      
        from fsh013 n
       where n.hrrub = ln_rubrocons
         and n.hranio = ln_anioconsfinal;
    exception
      when no_data_found then
        ln_SdoCieEne := 0;
        ln_SdoCieFeb := 0;
        ln_SdoCieMar := 0;
        ln_SdoCieAbr := 0;
        ln_SdoCieMay := 0;
        ln_SdoCieJun := 0;
        ln_SdoCieJul := 0;
        ln_SdoCieAgo := 0;
        ln_SdoCieSet := 0;
        ln_SdoCieOct := 0;
        ln_SdoCieNov := 0;
        ln_SdoCieDic := 0;
    end;
    if ln_mesconsfinal = 1 then
      ln_SdoCieMes := ln_SdoCieEne;
    else
      if ln_mesconsfinal = 2 then
        ln_SdoCieMes := ln_SdoCieFeb;
      else
        if ln_mesconsfinal = 3 then
          ln_SdoCieMes := ln_SdoCieMar;
        else
          if ln_mesconsfinal = 4 then
            ln_SdoCieMes := ln_SdoCieAbr;
          else
            if ln_mesconsfinal = 5 then
              ln_SdoCieMes := ln_SdoCieMay;
            else
              if ln_mesconsfinal = 6 then
                ln_SdoCieMes := ln_SdoCieJun;
              else
                if ln_mesconsfinal = 7 then
                  ln_SdoCieMes := ln_SdoCieJul;
                else
                  if ln_mesconsfinal = 8 then
                    ln_SdoCieMes := ln_SdoCieAgo;
                  else
                    if ln_mesconsfinal = 9 then
                      ln_SdoCieMes := ln_SdoCieSet;
                    else
                      if ln_mesconsfinal = 10 then
                        ln_SdoCieMes := ln_SdoCieOct;
                      else
                        if ln_mesconsfinal = 11 then
                          ln_SdoCieMes := ln_SdoCieNov;
                        else
                          if ln_mesconsfinal = 12 then
                            ln_SdoCieMes := ln_SdoCieDic;
                          end if;
                        end if;
                      end if;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
    /*   case
    when ln_mesconsfinal = 1 then
         ln_SdoCieMes := ln_SdoCieEne;
         
    when ln_mesconsfinal = 2 then
         ln_SdoCieMes:= ln_SdoCieFeb;
    
    when ln_mesconsfinal = 3 then
         ln_SdoCieMes:= ln_SdoCieMar;  
    
    when ln_mesconsfinal = 4 then
         ln_SdoCieMes:= ln_SdoCieAbr; 
             
     when ln_mesconsfinal = 5 then
          ln_SdoCieMes:= ln_SdoCieMay;
          
     when ln_mesconsfinal = 6 then
          ln_SdoCieMes:= ln_SdoCieJun; 
     
     when ln_mesconsfinal = 7 then
          ln_SdoCieMes:= ln_SdoCieJul; 
          
      when ln_mesconsfinal = 8 then
           ln_SdoCieMes:= ln_SdoCieAgo;
           
      when ln_mesconsfinal = 9 then
           ln_SdoCieMes:= ln_SdoCieSet; 
           
      when ln_mesconsfinal = 10 then
           ln_SdoCieMes:= ln_SdoCieOct;  
           
      when ln_mesconsfinal = 11 then
           ln_SdoCieMes:= ln_SdoCieNov; 
      
      when ln_mesconsfinal = 12 then
           ln_SdoCieMes:= ln_SdoCieDic;
      else                          
            ln_SdoCieMes:=0;
    end case;*/
  
    pn_SdoCieMes := ln_SdoCieMes;
  
  end sp_cr_SdoCieMes;

  -----------------------------------------------------------------------------------
  procedure sp_cr_SdoIniAnio(ln_AnioAntFechProc in number,
                             ln_rubrocons       in number,
                             ln_SdoIniAnio      out number) is
  
    --ln_mesFinAnio number(2):=12;                              
  begin
    select sum(g.hrsd12) -- ln_AnioAntFechProc
      into ln_SdoIniAnio
      from fsh013 g
     where g.hrrub = ln_rubrocons
       and g.hranio = ln_AnioAntFechProc;
  exception
    when no_data_found then
      ln_SdoIniAnio := 0;
      --when others then 
    --ln_SdoIniAnio:=0;                                          
  end sp_cr_SdoIniAnio;

  -----------------------------------------------------------------------------------

  procedure sp_cr_insertaJAQY844(ln_jaqy844pais    in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844pgcod   in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844suc     in number, --25.04.2019 --RLIVISI
                                 ln_jaqy844ctacble in number, --05.07.2018 --RLIVISI
                                 lc_jaqy844desccta in char, --12.07.2018--RLIVISI
                                 lc_jaqy844ftotdet in char, --25.04.2019 --RLIVISI
                                 lc_jaqy844tipsdo  in char, --05.07.2018 --RLIVISI                          
                                 ln_jaqy844tipcta  in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844subtcta in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844faux    in number, --25.04.2019 --RLIVISI
                                 ln_jaqy844fccost  in number, --25.04.2019 --RLIVISI
                                 ln_jaqy844fpresup in number, --25.04.2019 --RLIVISI
                                 ln_jaqy844fecccta in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844horccta in number, --05.07.2018 --RLIVISI
                                 lc_jaqy844usuccta in varchar2, --05.07.2018 --RLIVISI
                                 ln_jaqy844sdoidia in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844sdoimes in number, --05.07.2018 --RLIVISI
                                 ln_jaqy844sdoiano in number, --05.07.2018 --RLIVISI
                                 lc_jaqy844stscta  in char, --05.07.2018 --RLIVISI
                                 ln_jaqy844mdacont in number, ---25.04.2019 --RLIVISI 
                                 ln_jaqy844amlreg  in number, --25.04.2019 ---RLIVISI
                                 ln_jaqy844feclreg in number, --25.04.2019 --RLIVISI                                                             
                                 lc_jaqy844inderr  in char, --05.07.2018 --RLIVISI
                                 ld_fecproc        in date) is
    --06.07.2018 -RLIVISI
  
    ln_corr number;
  begin
    begin
      select count(*)
        into ln_corr
        from jaqy844 b
       where b.jaqy844fecpro = ld_fecproc;
    exception
      when no_data_found then
        ln_corr := 0;
      when others then
        ln_corr := 0;
    end;
  
    insert into jaqy844
      (jaqy844corr,
       jaqy844pais,
       jaqy844pgcod,
       jaqy844suc, --25.04.2019 --RLIVISI
       jaqy844ctacble,
       jaqy844desccta,
       jaqy844ftotdet, --25.04.25019 --RLIVISI
       jaqy844tipsdo,
       jaqy844tipcta,
       jaqy844subtcta,
       jaqy844faux, ---25.04.2019 ---RLIVISI
       jaqy844fccost, --25.04.2019 ---RLIVISI
       jaqy844fpresup, --25.04.2019 --RLIVISI
       jaqy844fecccta,
       jaqy844horccta,
       jaqy844usuccta,
       jaqy844sdoidia,
       jaqy844sdoimes,
       jaqy844sdoiano,
       jaqy844stscta,
       jaqy844mdacont,
       jaqy844amlreg, --25.04.2019 --RLIVISI
       jaqy844feclreg, --25.04.2019 --RLIVISI       
       jaqy844inderr,
       jaqy844fecpro)
    
    values
      (ln_corr + 1,
       ln_jaqy844pais,
       ln_jaqy844pgcod,
       ln_jaqy844suc, --25.04.2019 --RLIVISI
       ln_jaqy844ctacble,
       lc_jaqy844desccta,
       lc_jaqy844ftotdet, --25.04.25019 --RLIVISI
       lc_jaqy844tipsdo,
       ln_jaqy844tipcta,
       ln_jaqy844subtcta,
       ln_jaqy844faux, --25.04.2019 --RLIVISI
       ln_jaqy844fccost,
       ln_jaqy844fpresup, --25.04.2019 --RLIVISI
       ln_jaqy844fecccta,
       ln_jaqy844horccta,
       lc_jaqy844usuccta,
       ln_jaqy844sdoidia,
       ln_jaqy844sdoimes,
       ln_jaqy844sdoiano,
       lc_jaqy844stscta,
       ln_jaqy844mdacont, ---25.04.2019 --RLIVISI
       ln_jaqy844amlreg, --25.04.2019 --RLIVISI
       ln_jaqy844feclreg, --25.04.2019 --RLIVISI      
       lc_jaqy844inderr,
       ld_fecproc);
  
    commit;
  
  end sp_cr_insertaJAQY844; ---27/06/2018---RLIVISI 

  --HASTA ACA

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_job_solcred(pd_fecpro in date) is
  
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    --ld_finmes   date; --17/07/2018--RLIVISI
    lc_hostname varchar2(64);
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    delete from jaqy842 a where a.jaqy842fecpro = pd_fecpro; ----09.03.2018---RLIVISI
  
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := 'begin ' ||
                     '  pq_cr_monitor.SP_CR_SOLICITUDESDECREDITO(' ||
                     ln_ini || ',TO_DATE(''' || lc_fecpro ||
                     ''',''RRRR.MM.DD'') );' || ' End;';
      ln_job      := ln_job + 1;
      
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then       
       IF SYS.FN_BD_ISRAC='TRUE' THEN  -- 18.07.2019 ---RLIVISI               
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        -- instance => 2, --SE CAMBIO : 2-produccion  1-desa2  03.02.2015
                        instance => 2,
                        force    => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      
      end if;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('PRD', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  end sp_cr_job_solcred;

  -----------------------------------------------------------------------------------  
  Procedure sp_cr_job_buro(pd_fecpro in date) is
    ---ld_fecha in date, lc_digito in char
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance; ---queda
    end;
  
    delete from jaqy841 a where a.jaqy841fecpro = pd_fecpro;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' || ' PQ_CR_MONITOR.sp_cr_obtenDataExper(''' || x || '''' || ',' || '''' ||
                     pd_fecpro || ''');' || ' End; ';
    
      ln_job := ln_job + 1; --queda
    
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then

        IF SYS.FN_BD_ISRAC='TRUE' THEN --18.07.2019 ---RLIVISI
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false); ---queda
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false); ---queda
      end if;
      /*INSERT INTO Tab_jobs
      (c_Codage, n_Numer1, c_detjob)
      VALUES
      ('PRD', ln_ini, lc_variable);*/
    
      commit; ---10.05.2018 ---RLIVISI
    
    end loop;
  
    --CARGA SENTINEL
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_MONITOR.sp_cr_obtenDataSentinel(''' || x || '''' || ',' || '''' ||
                     pd_fecpro || ''');' || ' End; ';
    
      ln_job := ln_job + 1; --queda
    
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
       IF SYS.FN_BD_ISRAC='TRUE' THEN --18.07.2019 ---RLIVISI
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false); ---queda
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false); ---queda
      end if;
    
      commit; ---10.05.2018 ---RLIVISI    
    end loop;
  end sp_cr_job_buro;
  ---------------------------------------------------------------------------------------------
  Procedure sp_cr_job_varcambio(pd_fecpro in date) is
    ---ld_fecha in date, lc_digito in char
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
    begin
      select host_name into lc_hostname from v$instance; ---queda
    end;
  
    delete from jaqy840 a where a.jaqy840fecproc = pd_fecpro;
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' || ' PQ_CR_MONITOR.sp_cr_variablecambio(''' || x || '''' || ',' || '''' ||
                     pd_fecpro || ''');' || ' End; ';
    
      ln_job := ln_job + 1; --queda
    
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
       IF SYS.FN_BD_ISRAC='TRUE' THEN  -- 18.07.2019 ---RLIVISI
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false); ---queda
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false); ---queda
      end if;
      /*INSERT INTO Tab_jobs
      (c_Codage, n_Numer1, c_detjob)
      VALUES
      ('PRD', ln_ini, lc_variable);*/
      commit;
    end loop;
  
  end sp_cr_job_varcambio;

  ------------------------------------------------------------------------------------

  procedure sp_cr_obtenDataSentinel(lc_digito in varchar2,
                                    pd_fecpro in date) is
    ----TRAMA SENTINEL---REGISTRO 917---TABLA DE INSERCION: JAQY841 
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtenDataSentinel
    -- Sistema                    : BANTOTAL0
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 08/03/2018
    -- Autor de Creación          : RLIVISI 
    -- Uso                        : RETORNA CODIGO DE TIPO DE SOLICITUD
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : sng001inst
    -- Parámetros de Salida       : CODIGO DE TIPO DE SOLICITUD 
    --                            : 
    -- Fecha de Modificación      : 06.06.2019
    -- Autor de la Modificación   : RLIVISI
    -- Descripción de Modificación: Se omite acceso a tabla JAQY593 para reemplazarse
    --                            : por AQPA011L-JAQY599A para la obtención de instancia. 
    -- ***********************************************************************************  
  
    cursor SENTINEL is
      SELECT CONCAT(to_char(A.JAQZ236TIDOB), A.JAQZ236NUDOC) ln_TipoNroDoc,
             A.JAQZ236TIDOB ln_TipDoc,
             A.JAQZ236NUDOC ln_NroDoc,
             to_number(to_char(JAQZ236FEENV, 'yyyymmdd')) ln_FchEnvio,
             JAQZ236FEENV ld_FchEnvio,
             JAQZ236HOENV lh_HraEnv,
             JAQZ236USCOD lc_Usuario,
             JAQZ236SERIAL lc_Serial,
             a.JAQZ236NUCOn ln_Nucon
        FROM JAQZ236 A
       where a.JAQZ236feenv = pd_fecpro --ld_fecha        
         and to_char(substr(trim(a.JAQZ236nudoc), -1, 1)) = lc_digito; ----21.03.2018--RLIVISI
    /*and a.JAQL546NUCOn = B.JAQY728NUOPE*/
  
    ln_instan        number(9) := 0; ------sng001
    ln_NroCuenta     number(9);
    lc_Cuenta        varchar2(9);
    lc_HH            varchar2(2); ---12/12/2017--RLIVISI
    lc_MM            varchar2(2); ---12/12/2017--RLIVISI
    lc_SS            varchar2(2); ---12/12/2017--RLIVISI
    lc_horaSinPuntos varchar2(6); ---12/12/2017--RLIVISI
    ln_horaSinPuntos number(6);
    ln_nucon_nuevo   NUMBER(10); ----06.06.2019 --RLIVISI
  
  begin
    --DELETE FROM JAQY841 D Where d.jaqy841fecpro = ld_fecha;---22.03.2018--RLIVISI
  
    for e in SENTINEL loop
      ln_NroCuenta := 0;
    
      if e.ln_nucon <> 0 then
        ---instancia 
        /*  begin
          select distinct j.jaqy593inst
            into ln_instan --variable definida fuera 
            from jaqy593 j
           where j.jaqy593nuope = e.ln_nucon
             and j.jaqy593fec = e.ld_fchenvio;
        exception
          when others then
            ln_instan := 0;
          
        end;*/
        --Agregado desde aca---06.06.2019 ---RLIVISI
      
        begin
          select max(l.aqpa011lnucon)
            into ln_nucon_nuevo
            from AQPA011L L
           where l.aqpa011ltdoc = e.ln_tipdoc
             and l.aqpa011lndoc = e.ln_nrodoc
             and l.aqpa011lburo = 2 --SENTINEL
             and l.aqpa011lseria = e.lc_serial;
        exception
          when others then
            ln_nucon_nuevo := 0;
        end;
      
        begin
          select MAX(Y.JAQY599AINST)
            into ln_instan ---variable objetivo--06.06.2019 ---RLIVISI
            from jaqy599A Y
           where Y.JAQY599ANUOPE = ln_nucon_nuevo
           order by y.jaqy599afec, y.jaqy599ahor;
          --exit;
        exception
          when others then
            ln_instan := 0;
        end;
      
        ---Agregado hasta aca---06.06.2019 ---RLIVISI
      
        if ln_instan <> 0 then
        
          begin
            ---cuenta
            select g.sng001cta
              into ln_NroCuenta
              from sng001 g
             where g.sng001inst = ln_instan;
          exception
            when others then
              ln_NroCuenta := 0;
          end;
        end if;
      
        lc_HH            := substr(e.lh_hraenv, 1, 2); --12/12/2017---RLIVISI
        lc_MM            := substr(e.lh_hraenv, 4, 2); --12/12/2017---RLIVISI
        lc_SS            := substr(e.lh_hraenv, 7, 2); --12/12/2017---RLIVISI
        lc_horaSinPuntos := concat(concat(lc_HH, lc_MM), lc_SS); --12/12/2017--RLIVISI
        ln_horaSinPuntos := to_number(lc_horaSinPuntos);
      
        if ln_NroCuenta <> 0 then
        
          lc_Cuenta := to_char(ln_NroCuenta);
        
          PQ_CR_MONITOR.sp_cr_insertaJAQY841(lc_TipNroDoc => e.ln_tiponrodoc,
                                             lc_TipDoc    => e.ln_tipdoc,
                                             lc_NroDoc    => e.ln_nrodoc,
                                             ln_FecEnv    => e.ln_FchEnvio,
                                             /*lc_NroIP       => '000',*/ --02.05.2018
                                             ln_HoraEnv     => ln_horaSinPuntos, --e.lh_hraenv,
                                             lc_UsuConsulta => e.lc_usuario,
                                             ln_CodBuro     => 2, --'SENTINEL'--e.lc_serial,
                                             lc_NroCta      => lc_Cuenta,
                                             ld_fecproc     => pd_fecpro);
        
          commit; --                                  
        end if;
      
      else
        if e.ln_nucon = 0 then
          begin
            select r.ctnro --g.sng001cta
              into ln_NroCuenta --nrocta_sng001
              from fsr008 r --sng001 g
             where r.petdoc = e.ln_tipdoc --g.sng001tdoc = e.ln_tipdoc
               and r.pendoc = e.ln_nrodoc
               and r.cttfir = 'T'
               and rownum = 1; --g.sng001ndoc = e.ln_nrodoc;
          exception
            when others then
              ln_NroCuenta := 0;
          end;
        end if;
      
        if ln_NroCuenta <> 0 then
        
          lc_Cuenta := to_char(ln_NroCuenta);
          PQ_CR_MONITOR.sp_cr_insertaJAQY841(lc_TipNroDoc => e.ln_tiponrodoc,
                                             lc_TipDoc    => e.ln_tipdoc,
                                             lc_NroDoc    => e.ln_nrodoc,
                                             ln_FecEnv    => e.ln_FchEnvio,
                                             /*lc_NroIP       => '000',*/ --02.05.2018
                                             ln_HoraEnv     => ln_horaSinPuntos, --e.lh_hraenv,
                                             lc_UsuConsulta => e.lc_usuario,
                                             ln_CodBuro     => 2, --'SENTINEL'--e.lc_serial,
                                             lc_NroCta      => lc_Cuenta,
                                             ld_fecproc     => pd_fecpro);
        
          commit; --
        end if;
      end if;
    
    end loop;
  
  end sp_cr_obtenDataSentinel;
  ------------------------------------------------------------------------------------
  Procedure sp_cr_job_rubro(pd_fecpro in date) is
    ---ld_fecha in date, lc_digito in char
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance; ---queda
    end;
  
    delete from jaqy844 where jaqy844fecpro = pd_fecpro;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_MONITOR.sp_cr_obtenSdoRubroContable(''' || x || '''' || ',' || '''' ||
                     pd_fecpro || ''');' || ' End; ';
    
      ln_job := ln_job + 1; --queda
    
      
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
        IF SYS.FN_BD_ISRAC='TRUE' THEN  ---18.07.2019 ---RLIVISI
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false); ---queda
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false); ---queda
      end if;
      /*INSERT INTO Tab_jobs
      (c_Codage, n_Numer1, c_detjob)
      VALUES
      ('PRD', ln_ini, lc_variable);*/
    
      commit; ---10.05.2018 ---RLIVISI
    
    end loop;
  
  end sp_cr_job_rubro; ----16/07/2018---RLIVISI
------------------------------------------------------------------------------------
end PQ_CR_MONITOR;
/

