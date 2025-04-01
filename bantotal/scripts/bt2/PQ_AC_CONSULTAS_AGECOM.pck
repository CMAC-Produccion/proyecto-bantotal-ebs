create or replace package agecombt.PQ_AC_CONSULTAS_AGECOM is
   TYPE lc_liscur IS REF CURSOR; 
   procedure SP_AC_CLICAJ(ps_tipper char,pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                       ps_nomcli out varchar2,ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_CTACLI(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    pn_ctacli out number,ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_FECRCC(pd_fecrcc out date,ps_coderr out char,ps_msgerr out varchar2);    
   procedure SP_AC_TOTCRE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                     ps_clicaj out char,pn_crevig out number,pn_crecan out number,
                     pn_linvig out number,ps_coderr out char,ps_msgerr out varchar2);                
   procedure SP_AC_CONCLI(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_nomcon out varchar2,pn_tipcon out number,pn_paicon out number,
                    ps_doccon out varchar2,ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_LISNEG(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_lisneg out varchar2, ps_coderr out char,
                    ps_msgerr out varchar2);  
   procedure SP_AC_CONCREPRO(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                             ps_estcre out varchar ,ps_anasol out varchar,ps_sucsol out varchar,
                             ps_fecsol out varchar2,
                             ps_coderr out char, ps_msgerr out varchar2);
   procedure SP_AC_LISCRE(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                        pc_liscre out lc_liscur , ps_coderr out char, ps_msgerr out varchar2);              
   procedure SP_AC_RCCCLI(ps_codsbs in varchar2,pc_calrcc out lc_liscur,ps_coderr out char,
                       ps_msgerr out varchar2);
   procedure SP_AC_CALCLI(ps_codsbs in varchar2,pc_calrcc out lc_liscur,ps_coderr out char,
                         ps_msgerr out varchar2);
   procedure SP_AC_CABRCC(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,ps_coderr out char,
                       ps_msgerr out varchar2);
   procedure SP_AC_CLISOB(pn_codpai in number,pn_tipdoc in number,ps_numdoc in char,
                       ps_estsob out varchar2,ps_dessob out varchar,ps_coderr out char,
                       ps_msgerr out varchar2);
   --procedure sp_clirec(ps_numdoc in char,pd_fecpro in date,ps_tiprol in char,ps_estrec out varchar2,
     --                  ps_desrec out varchar2,ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_INDCAL(ps_codsbs in varchar,ps_indnor out varchar2,ps_indcpp out varchar2,
                       ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_DIRCLI(pn_codpai in number,pn_tipdoc in number,ps_numdoc in varchar,
                   pn_tipviv in number, ps_dircli out varchar2, ps_dirref out varchar2, ps_dirubi out varchar2) ;
   procedure SP_AC_EVACLI(ps_tipper varchar2,pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,ps_tiprol varchar2,
                     ps_indcon out varchar2,ps_paicon out varchar2, ps_tipcon out varchar2,
                     ps_doccon out varchar2,ps_sbscli out varchar2, ps_sbscon out varchar2,
                     --ps_nomcli out varchar2,
                     ps_nomcon out varchar2,ps_clineg out varchar2,ps_conneg out varchar2,
                     ps_estsob out varchar2,ps_dessob out varchar2,ps_estrec out varchar2,
                     ps_desrec out varchar2,ps_nument out varchar2,ps_conent out varchar2,
                     ps_clijud out varchar2,ps_conjud out varchar2,ps_clicas out varchar2,
                     ps_concas out varchar2,ps_clinor out varchar2,ps_clicpp out varchar2,
                     ps_connor out varchar2,ps_concpp out varchar2,ps_calgen out varchar2,
                     ps_calcli out varchar2,ps_calcon out varchar2,ps_escosb out varchar2,
                     ps_decosb out varchar2,ps_segcli out varchar2,
                     ps_nomcli out varchar2,ps_dirdom out varchar2,ps_dirneg out varchar2,
                     ps_acteco out varchar2,ps_estcre out varchar2,ps_fecdes out varchar2,
                     ps_codana out varchar2,ps_codage out varchar2,ps_telcli out varchar2,
                     ps_refviv out varchar2,ps_refneg out varchar2,ps_ubicli out varchar2,
                     ps_ubineg out varchar2,ps_tipcli out varchar2,ps_numina out varchar2,
                     ps_crecon out varchar2,ps_descon out varchar2,ps_prosbs out varchar2,
                     ps_conpro out varchar2,ps_segcon out varchar2,ps_actcli out varchar2,
                     ps_actcon out varchar2,ps_tipcny out varchar2,ps_inacon out varchar2,
                     ps_fecnac out varchar2,ps_naccon out varchar2,ps_nomsec out varchar2,
                     pn_mondes out varchar2,ps_desmon out varchar2,ps_nomana out varchar2,
                     ps_anasol out varchar2,ps_sucsol out varchar2,ps_fecsol out varchar2,
                     --ps_vivcli out varchar2,ps_negcli out varchar2,
                     ps_despro out varchar2,ps_nomage out varchar2,ps_solvig out varchar2,
                     ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_INGCTA(pn_codpai number,pn_tipdoc number, ps_numdoc varchar2,
                       ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_DETRCC(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                       ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_BUSREF(ps_tipper varchar2,pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_nomcli out varchar2, ps_dirdom out varchar2,ps_dirneg out varchar2,
                    ps_acteco out varchar2,ps_nomcon out varchar2,ps_tipcon out varchar2,
                    ps_paicon out varchar2,ps_doccon out varchar2,ps_estcre out varchar2,
                    ps_fecdes out varchar2,ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_ESTCRE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_estcre out varchar2, ps_fecdes out varchar2,          
                    ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_ANAAGE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_codana out varchar2, ps_codage out varchar2,          
                    ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_CLIREC(ps_numdoc in varchar2, ps_tipdoc in varchar2,pd_fecpro in date,
                     ps_tipcli out char, ps_numina out integer,ps_estrec out varchar2,ps_desrec out varchar2);
   procedure SP_AC_DATCRE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,pd_fecpro date,
                       pn_codemp out fsd010.pgcod%type,pn_codmod out fsd010.aomod%type,
                       pn_codage out fsd010.aosuc%type,pn_codmon out fsd010.aomda%type,
                       pn_codpap out fsd010.aopap%type,pn_codcta out fsd010.aocta%type,
                       pn_codope out fsd010.aooper%type,pn_subope out fsd010.aosbop%type,
                       pn_tipope out fsd010.aotope%type,pn_estado out fsd010.aostat%type,
                       pd_fecdes out fsd010.aofval%type,pd_feccan out fsd010.aofe99%type,
                       pn_mondes out fsd010.aoimp%type,ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_AC_CONDATAVA(pn_codemp fsd010.pgcod%type,pn_codmod fsd010.aomod%type,
                            pn_codage fsd010.aosuc%type,pn_codmon fsd010.aomda%type,
                            pn_codpap fsd010.aopap%type,pn_codcta fsd010.aocta%type,
                            pn_codope fsd010.aooper%type,pn_subope fsd010.aosbop%type,
                            pn_tipope fsd010.aotope%type,pn_tipdoc out number,pn_codpai out number,
                            ps_numdoc out varchar2,ps_nomava out varchar2,ps_dirava out varchar2,
                            ps_refava out varchar2,ps_ubiava out varchar2,ps_telava out varchar2,
                            ps_coderr out char,ps_msgerr out varchar2);                       
    procedure SP_AC_CONDATCRE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                            pd_fecdes out varchar2,pd_feccan out varchar2,ps_estcre out varchar2,ps_despro out varchar2,
                            ps_desmon out varchar2,pn_mondes out varchar2,ps_nomage out varchar2,ps_nomana out varchar2,
                            pn_atracu out varchar2,pn_atrmax out varchar2,ps_clicaj out varchar2,pn_crevig out varchar2,
                            pn_crecan out varchar2,pn_linvig out varchar2,pd_ultpag out varchar2,pn_moncuv out varchar2,
                            pn_cappag out varchar2,ps_codcta out varchar2,pn_tipdav out varchar2,pn_codpav out varchar2,
                            ps_numdav out varchar2,ps_nomava out varchar2,ps_dirava out varchar2,ps_refava out varchar2,
                            ps_ubiava out varchar2,ps_telava out varchar2,ps_coderr out char,ps_msgerr out varchar2);
    procedure SP_AC_CAREVAAPR(pn_idebas number,pn_idepro number,pn_coding number,pn_codact number,pn_codbas number,
                            ps_estado varchar2,ps_codusu varchar2,pd_fecini date,pd_fecfin date,pn_codpro number,
                            pn_codage number,ps_coderr out char,ps_msgerr out varchar2);
    procedure SP_AC_CARMORANA(pn_idebas number,pn_idepro number,pn_coding number,pn_codact number,pn_codbas number,
                              ps_estado varchar2,ps_codusu varchar2,pn_codage number,ps_coddia varchar2,ps_codsal varchar2,
                              pn_codzon number,ps_coderr out char,ps_msgerr out varchar2);  
    procedure SP_AC_DETRCCACU(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                            ps_fecpro out varchar2,ps_desemp out varchar2,ps_tipcre out varchar2,
                            ps_diaatr out varchar2,ps_descal out varchar2,ps_salcap out varchar2,
                            ps_calif0 out varchar2,ps_calif1 out varchar2,ps_calif2 out varchar2,
                            ps_calif3 out varchar2,ps_calif4 out varchar2,ps_nument out varchar2,
                            ps_fecrcc out varchar2,ps_linusu out varchar2,ps_coderr out char,ps_msgerr out varchar2);
    procedure SP_AC_CONDETRCC(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                            pn_conpai number,pn_tipcon number,ps_condoc varchar2,
                            ps_fecpro out varchar2,ps_desemp out varchar2,ps_tipcre out varchar2,
                            ps_diaatr out varchar2,ps_descal out varchar2,ps_salcap out varchar2,
                            ps_calif0 out varchar2,ps_calif1 out varchar2,ps_calif2 out varchar2,
                            ps_calif3 out varchar2,ps_calif4 out varchar2,ps_nument out varchar2, 
                            ps_feccon out varchar2,ps_conemp out varchar2,ps_concre out varchar2,
                            ps_conatr out varchar2,ps_concal out varchar2,ps_concap out varchar2,
                            ps_conca0 out varchar2,ps_conca1 out varchar2,ps_conca2 out varchar2,
                            ps_conca3 out varchar2,ps_conca4 out varchar2,ps_conent out varchar2,
                            ps_fecrcc out varchar2,ps_conrcc out varchar2,ps_linusu out varchar2,
                            ps_conusu out varchar2,ps_coderr out char,ps_msgerr out varchar2);                   
     procedure SP_AC_EVACLI2(ps_tipper varchar2,pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,ps_tiprol varchar2,
                     ps_codrol varchar2,
                     ps_indcon out varchar2,ps_paicon out varchar2, ps_tipcon out varchar2,
                     ps_doccon out varchar2,ps_sbscli out varchar2, ps_sbscon out varchar2,
                     --ps_nomcli out varchar2,
                     ps_nomcon out varchar2,ps_clineg out varchar2,ps_conneg out varchar2,
                     ps_estsob out varchar2,ps_dessob out varchar2,ps_estrec out varchar2,
                     ps_desrec out varchar2,ps_nument out varchar2,ps_conent out varchar2,
                     ps_clijud out varchar2,ps_conjud out varchar2,ps_clicas out varchar2,
                     ps_concas out varchar2,ps_clinor out varchar2,ps_clicpp out varchar2,
                     ps_connor out varchar2,ps_concpp out varchar2,ps_calgen out varchar2,
                     ps_calcli out varchar2,ps_calcon out varchar2,ps_escosb out varchar2,
                     ps_decosb out varchar2,ps_segcli out varchar2,
                     ps_nomcli out varchar2,ps_dirdom out varchar2,ps_dirneg out varchar2,
                     ps_acteco out varchar2,ps_estcre out varchar2,ps_fecdes out varchar2,
                     ps_codana out varchar2,ps_codage out varchar2,ps_telcli out varchar2,
                     ps_refviv out varchar2,ps_refneg out varchar2,ps_ubicli out varchar2,
                     ps_ubineg out varchar2,ps_tipcli out varchar2,ps_numina out varchar2,
                     ps_crecon out varchar2,ps_descon out varchar2,ps_prosbs out varchar2,
                     ps_conpro out varchar2,ps_segcon out varchar2,ps_actcli out varchar2,
                     ps_actcon out varchar2,ps_tipcny out varchar2,ps_inacon out varchar2,
                     ps_fecnac out varchar2,ps_naccon out varchar2,ps_nomsec out varchar2,
                     pn_mondes out varchar2,ps_desmon out varchar2,ps_nomana out varchar2,
                     ps_anasol out varchar2,ps_sucsol out varchar2,ps_fecsol out varchar2,
                     --ps_vivcli out varchar2,ps_negcli out varchar2,
                     ps_despro out varchar2,ps_nomage out varchar2,ps_solvig out varchar2,
                     ps_coderr out char,ps_msgerr out varchar2);
                     
       procedure SP_AC_CLIREC2(ps_numdoc in varchar2, ps_tipdoc in varchar2,pd_fecpro in date,
                     ps_codrol varchar2, ps_tipcli out char, ps_numina out integer,
                     ps_estrec out varchar2,ps_desrec out varchar2);         
                                                                                                                              
end PQ_AC_CONSULTAS_AGECOM;
/
create or replace package body agecombt.PQ_AC_CONSULTAS_AGECOM is

procedure SP_AC_CLICAJ(ps_tipper char,pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_nomcli out varchar2,ps_coderr out char,ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_AC_CLICAJ
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 28/09/2016
  -- Autor de Creación          : WCRW
  -- Uso                        : Nombre de la persona
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

   ls_numdoc char(12);
   begin
      ls_numdoc := ps_numdoc;
      select f1.penom into ps_nomcli from fsd001 f1
       where f1.Pepais = pn_codpai
         and f1.Petdoc = pn_tipdoc
         and f1.Pendoc = ls_numdoc
         and f1.petipo = ps_tipper;
         ps_coderr := '00000';
      exception
      when no_data_found then
         ps_nomcli := 'NO EXISTE 999';
         ps_coderr := '00011';
         ps_msgerr := 'NO HAY DATOS';
         --commit;
         --rollback;
      when others then
         ps_coderr := '00099';
         ps_msgerr := SQLERRM;
         --commit;
         --rollback;
end SP_AC_CLICAJ;

procedure SP_AC_CONCLI(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_nomcon out varchar2,pn_tipcon out number,pn_paicon out number,
                    ps_doccon out varchar2,ps_coderr out char,ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_AC_CONCLI
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 07/10/2016
  -- Autor de Creación          : WCRW
  -- Uso                        : Datos del Conyugue
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

   ls_numdoc char(12);
   ls_doccon char(12);
   begin
      ls_numdoc := trim(ps_numdoc);        
         
select case when f2.rpndoc = ls_numdoc then f2.Petdoc  else f2.rptdoc end rptdoc,
       case when f2.rpndoc = ls_numdoc then f2.Pepais  else f2.rppais end rppais,
       case when f2.rpndoc = ls_numdoc then trim(f2.Pendoc)   else trim(f2.rpndoc) end  as rpndoc
       into pn_tipcon,pn_paicon,ps_doccon 
        from fsr002 f2      
       where ((f2.Pepais = pn_codpai
         and f2.Petdoc = pn_tipdoc
         and f2.Pendoc = ls_numdoc)
         or 
         (f2.rppais = pn_codpai
         and f2.rptdoc = pn_tipdoc
         and f2.rpndoc = ls_numdoc)
           )
         and f2.rpccyg = 66
         and rownum=1;
       
       ls_doccon:= trim(ps_doccon);
       select f1.penom into ps_nomcon from fsd001 f1
       where f1.Pepais = pn_paicon
         and f1.Petdoc = pn_tipcon
         and f1.Pendoc = ls_doccon
         and f1.petipo = 'F';
         ps_coderr := '00000';
      exception
      when no_data_found then
         ps_coderr := '00011';
         ps_msgerr := 'NO TIENE CONYUGE';
         --commit;
         --rollback;
      when others then
         ps_coderr := '00099';
         ps_msgerr := SQLERRM;
         --commit;
         --rollback;
end SP_AC_CONCLI;



procedure SP_AC_CTACLI(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    pn_ctacli out number,ps_coderr out char,ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_AC_CTACLI
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 05/10/2016
  -- Autor de Creación          : WCRW
  -- Uso                        : Cuenta Cliente
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

   ls_numdoc char(12);
   begin
      ls_numdoc := ps_numdoc;
      select f8.ctnro into pn_ctacli from fsr008 f8
       where f8.Pepais = pn_codpai
         and f8.Petdoc = pn_tipdoc
         and f8.Pendoc = ls_numdoc
         and f8.ttcod  = 1
         and f8.cttfir = 'T';
         ps_coderr := '00000';
      exception
      when no_data_found then
         ps_coderr := '00011';
         ps_msgerr := 'NO HAY DATOS';
         --commit;
         --rollback;
      when others then
         ps_coderr := '00099';
         ps_msgerr := SQLERRM;
         --commit;
         --rollback;
end SP_AC_CTACLI;

procedure SP_AC_FECRCC(pd_fecrcc out date,ps_coderr out char,ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_AC_FECRCC
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 06/10/2016
  -- Autor de Creación          : WCRW
  -- Uso                        : Fecha de último RCC
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

   ld_ultrcc date;
   begin
      select to_date(tpnro,'ddmmrrrr') Into ld_ultrcc
        from fst098 
       where tpcod=7647 
         and tpcorr=12;
      pd_fecrcc := ld_ultrcc;
      ps_coderr := '00000';
      exception
      when no_data_found then
         ps_coderr := '00011';
         ps_msgerr := 'NO HAY DATOS';
         --commit;
         --rollback;
      when others then
         ps_coderr := '00099';
         ps_msgerr := SQLERRM;
         --commit;
         --rollback;
end SP_AC_FECRCC;

procedure SP_AC_TOTCRE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                     ps_clicaj out char,pn_crevig out number,pn_crecan out number,
                     pn_linvig out number,ps_coderr out char,ps_msgerr out varchar2)
is
  -- *****************************************************************
  -- Nombre                     : SP_AC_TOTCRE
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 20/10/2016
  -- Autor de Creación          : WCRW
  -- Uso                        : Número de Creditos Vigentes / Cancelados / Linea de Crédito
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

ls_numdoc char(12);
begin
  ls_numdoc := ps_numdoc; 
  begin
      select count(case when d10.aomod <> 117 and d10.aostat <> 99 then 1 end),
             count(case when d10.aomod <> 117 and d10.aostat = 99 then 1 end ),
             count(case when d10.aomod = 117  and d10.aofvto > trunc(sysdate) and d10.aostat <> 99 then 1 end )
             into pn_crevig,pn_crecan,pn_linvig
        from fsr008 r08,fsd010 d10
       where r08.pepais = pn_codpai
         and r08.petdoc = pn_tipdoc
         and r08.pendoc = ls_numdoc
         and d10.pgcod = r08.pgcod
         and d10.aocta = r08.ctnro
         and d10.aomod in (select f111.modulo
                             from fst111 f111
                            where f111.dscod = 50
                              and f111.modulo not in (29,120) union all select 117 from dual);
  exception
     when no_data_found then
        ps_coderr := '00011';
        ps_msgerr := 'NO HAY DATOS';
        pn_crevig := 0;
        pn_crecan := 0;
        pn_linvig := 0;
     when others then
        ps_coderr := '00099';
        ps_msgerr := SQLERRM;
  end;
  if pn_crevig > 0 or pn_crecan > 0 or pn_linvig > 0 then
     ps_clicaj := 'S';
  else
     ps_clicaj := 'N';
  end if;
end SP_AC_TOTCRE;

procedure SP_AC_LISNEG(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_lisneg out varchar2, ps_coderr out char,
                    ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_AC_LISNEG
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 10/10/2016
  -- Autor de Creación          : WCRW
  -- Uso                        : Lista Negra
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
   pc_lisneg lc_liscur;
   ls_numdoc char(12);
   ln_numreg integer;
   begin
      ls_numdoc := ps_numdoc;
      ps_lisneg := 'N';
      ln_numreg := 0;
      begin
      select count(*) into ln_numreg   
        from fsd201 f201,fst501 f501
       where f201.LnPais = pn_codpai
         and f201.LnTdoc = pn_tipdoc
         and f201.LnNdoc = ls_numdoc
         and f201.TLis <> 2
         and f201.TLis = f501.Tlis;
      if ln_numreg > 0 then
         open pc_lisneg for
         select f501.Tlisde
           from fsd201 f201,fst501 f501
          where f201.LnPais = pn_codpai
            and f201.LnTdoc = pn_tipdoc
            and f201.LnNdoc = ls_numdoc
            and f201.TLis <> 2
            and f201.TLis = f501.Tlis;
         ps_lisneg := 'S';   
      end if;     
      ps_coderr := '00000';
      exception
      when no_data_found then
         ps_coderr := '00011';
         ps_msgerr := 'NO HAY DATOS';
         --commit;
         --rollback;
      when others then
         ps_coderr := '00099';
         ps_msgerr := SQLERRM;
         --commit;
         --rollback;
      end;
end SP_AC_LISNEG;

procedure SP_AC_CONCREPRO(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                          ps_estcre out varchar ,ps_anasol out varchar,ps_sucsol out varchar,
                          ps_fecsol out varchar2,
                          ps_coderr out char, ps_msgerr out varchar2) is
-- *****************************************************************
  -- Nombre                     : SP_AC_CONCREPRO
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 20/10/2016
  -- Autor de Creación          : WCRW
  -- Uso                        : Consulta Estado de proceso de credito
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************                       
ls_numdoc char(12);
begin
  ls_numdoc := ps_numdoc; 
  begin                  
      
    select PQ_AC_FUN_AGECOM.FN_AC_NUMSOL(xwfmodulo,xwfsucursal,xwfmoneda,xwfpapel,xwfcuenta,xwfoperacion,xwfsubope,xwftipope),
           PQ_AC_FUN_AGECOM.FN_SOLANA(xwfmodulo,xwfsucursal,xwfmoneda,xwfpapel,xwfcuenta,xwfoperacion,xwfsubope,xwftipope),     
           to_char(PQ_AC_FUN_AGECOM.FN_FECSOL(1,xwfmodulo,xwfsucursal,xwfmoneda,xwfpapel,xwfcuenta,xwfoperacion,xwfsubope,xwftipope,3),'DD/MM/YYYY')  
      into ps_estcre,ps_anasol,ps_fecsol
      from (
    select f700.xwfempresa,
           f700.xwfsucursal,
           f700.xwfmodulo,
           f700.xwfmoneda,
           f700.xwfpapel,
           f700.xwfcuenta,
           f700.xwfoperacion,
           f700.xwfsubope,
           f700.xwftipope           
      from wfwrkitems wfwr, xwf700 f700, fsr008 r08
     where wfwr.wfinsprcid = f700.xwfprcins
       and f700.xwfempresa = r08.pgcod
       and f700.xwfcuenta = r08.ctnro
       and r08.ttcod = 1
       and (wfwr.WFTaskCod = 3 Or wfwr.WFTaskCod = 7 Or wfwr.WFTaskCod = 11 Or wfwr.WFTaskCod = 55 Or wfwr.WFTaskCod = 351)
       and wfwr.wfstscod in ('A','P', 'R', 'T', 'L', 'S', 'Z')
       and f700.xwfcar3 = '1'
       and r08.pepais = pn_codpai
       and r08.petdoc = pn_tipdoc
       and r08.pendoc = ls_numdoc
     order by wfwr.wfitemend desc
     ) where rownum=1;
     
     select suc.scnom,
            nom.ubnom
       into ps_sucsol,
            ps_anasol
      from sng057 usu
     inner join fst746 nom
        on usu.sng057usr = nom.ubuser
     inner join fst046 tmp
        on tmp.ubuser = nom.ubuser
     inner join fst001 suc
        on suc.sucurs = tmp.ubsuc
     where nom.ubuser = ps_anasol;
 
  exception
     when no_data_found then
        ps_coderr := '00011';
        ps_msgerr := 'NO HAY DATOS';
        ps_estcre := 0;
        ps_anasol := ' ';
        ps_sucsol := ' ';
        ps_fecsol := ' ';
     when others then
        ps_coderr := '00099';
        ps_msgerr := SQLERRM;
        ps_estcre := 0;
        ps_anasol := ' ';
        ps_sucsol := ' ';
        ps_fecsol := ' ';
  end;       
end SP_AC_CONCREPRO;  

procedure SP_AC_LISCRE(pn_codpai number,pn_tipdoc number, ps_numdoc varchar2,
                     pc_liscre out lc_liscur ,ps_coderr out char, ps_msgerr out varchar2) is
  -- *****************************************************************
  -- Nombre                     : SP_AC_LISCRE
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Lista de créditos
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Modificación      : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ls_numdoc varchar2(12);
  begin
    ls_numdoc:=trim(ps_numdoc);
    open pc_liscre for
    select cre.pgcod as icodemp,
           cre.aomod as icodmod,-- producto
           cre.aosuc as icodage,
           cre.aomda as icodmon,
           cre.aopap as icodpap,
           cre.aocta as icodcta,
           cre.aooper as icodope,--operacion
           cre.aosbop as icodsop,-- sub operacion
           cre.aotope as icodtip,-- Tipo de Operación
           cre.aostat as icodest,
           t2.SNG001Ase as vcodana,
           sal.Scfval  as dfecdes,
           cre.aofvto as dfecven,
           sal.Scgru as iprosbs,
           cre.Aoimp as imondes,
           coalesce(sal.scsdo*-1,0) as isalcap,
           pq_ac_fun_agecom.fn_ac_cuocre(cre.aocta,cre.aooper,cre.aotope,cre.aosbop,cre.aomod,cre.aosuc,cre.aomda) as imoncuo,
           pq_ac_fun_agecom.fn_ac_nrocuo(cre.pgcod,cre.aomod,cre.aosuc,cre.aomda,cre.aopap,cre.aocta,cre.aooper,cre.aosbop,cre.aotope) as inumcuo,
           pq_ac_fun_agecom.fn_ac_cuopen(cre.pgcod,cre.aomod,cre.aosuc,cre.aomda,cre.aopap,cre.aocta,cre.aooper,cre.aosbop,cre.aotope,pq_ac_fun_agecom.fn_ac_fecsis(cre.pgcod)) as icuopen,
           pq_ac_fun_agecom.fn_ac_atracu(cre.pgcod,cre.aomod,cre.aosuc,cre.aomda,cre.aopap,cre.aocta,cre.aooper,cre.aosbop,cre.aotope,pq_ac_fun_agecom.fn_ac_fecsis(cre.pgcod),cre.aofvto) as iatracu,
           pq_ac_fun_agecom.fn_ac_atrmax(cre.pgcod,cre.aomod,cre.aosuc,cre.aomda,cre.aopap,cre.aocta,cre.aooper,cre.aosbop,cre.aotope,pq_ac_fun_agecom.fn_ac_fecsis(cre.pgcod),cre.aofvto) as iatrmax,
           pq_ac_fun_agecom.fn_ac_atrdoc((case when cre.aostat = 99 then cre.aofe99 else trunc(sysdate) end),add_months((case when cre.aostat = 99 then cre.aofe99 else trunc(sysdate) end), -12) + 1, cre.pgcod, cre.aomod, cre.aosuc, cre.aomda, cre.aopap, cre.aocta, cre.aooper, cre.aosbop, cre.aotope) as iatru12,
           pq_ac_fun_agecom.fn_ac_estref(cli.pepais,cli.petdoc,cli.pendoc) as cindref,
           pq_ac_fun_agecom.fn_ac_judcas(cli.pepais,cli.petdoc,cli.pendoc) as cindjc,
           cre.aotasa as imonttasa,
           cre.aofe99 as dfeccan
      from fsr008 cab
     inner join fsd001 cli
        on cli.pepais  = cab.pepais 
       and cli.petdoc  = cab.petdoc 
       and cli.pendoc  = cab.pendoc
     inner join fsr011 pue
        on pue.relcod = 50 
       and pue.r2mod  = 70  
       and pue.r1cta  = cab.ctnro
     inner join fsd010 cre
        on cre.pgcod=pue.r1cod 
       and pue.r1mod=cre.aomod 
       and pue.r1suc=cre.aosuc 
       and pue.r1mda = cre.aomda 
       and pue.r1pap = cre.aopap 
       and pue.r1cta= cre.aocta 
       and pue.r1oper = cre.aooper 
       and pue.r1sbop = cre.aosbop 
       and pue.r1tope = cre.aotope
      left join FSD011 sal
        on cre.pgcod=sal.pgcod  
       and sal.scsuc=cre.aosuc 
       and sal.scmda = cre.aomda 
       and sal.scpap = cre.aopap 
       and sal.sccta= cre.aocta 
       and sal.scoper = cre.aooper 
       and sal.scsbop = cre.aosbop 
       and sal.sctope = cre.aotope
     inner join Xwf700 t1
        on t1.xwfempresa  = cre.pgcod 
       and t1.xwfsucursal = cre.aosuc 
       and t1.xwfmodulo = cre.aomod 
       and t1.xwfmoneda = cre.aomda 
       and t1.xwfpapel = cre.aopap 
       and t1.xwfcuenta  =cre.aocta 
       and t1.xwfoperacion = cre.aooper 
       and t1.xwfsubope =cre.aosbop 
       and t1.xwftipope =cre.aotope 
       and t1.xwfcar3  ='1'
     inner join sng001 t2
        on t2.sng001inst = t1.xwfprcins
     where cab.pepais = pn_codpai
       and cab.petdoc = pn_tipdoc
       and cab.ttcod  = 1
       and cab.cttfir = 'T'--Titular
       and pue.r2oper in (7430,617197)
       and cab.pendoc = cast(ls_numdoc as char(12))
     order by cre.aostat ,sal.scfval desc;
 exception
 when no_data_found then
          ps_coderr := '00011';
          ps_msgerr := 'NO HAY DATOS';
 when        others then
          ps_coderr := '00099';
          ps_msgerr := SQLERRM;
end SP_AC_LISCRE;


procedure SP_AC_RCCCLI(ps_codsbs in varchar2, pc_calrcc out lc_liscur, ps_coderr out char,
                     ps_msgerr out varchar2) is
-- *****************************************************************
  -- Nombre                     : SP_AC_RCCCLI
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Detalle del RCC de los últimos 6 meses mostrando 
  --                              el nombre de las entidades y el saldo por cada una de ellas.
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  begin
  declare
  ld_fecrcc date;
  ld_fecini date;
  ls_deserr char(100);
  ls_desmen varchar2(1000);
  ls_codsbs varchar2(10);
     begin
       ls_codsbs := trim(ps_codsbs);
     sp_ac_fecrcc(ld_fecrcc,ls_deserr,ls_desmen);
     select add_months(ld_fecrcc,-5) 
       into ld_fecini 
       from dual;
       open pc_calrcc for
     select d_fecpre as dfecrcc,  
            substr(to_char(to_date(to_char(d_fecpre,'mm'),'mm'),'Month'),1,3) ||' - '|| to_char(d_fecpre,'YYYY') as vfecdes,
            ent.tp1desc as vdesent,
            sum(n_salcap) as imonsal
      from cldrccs rcc
      left join fst198 ent
        on cast(rcc.c_codemp as int)  = cast(ent.tp1corr2 as int)  and ent.tp1cod1= 10849 and ent.tp1corr1=10
     where c_codsbs = ls_codsbs
           and (
               (substr(c_cuenta,1,4) = '1411')   or (substr(c_cuenta,1,4) = '1413' )  or (substr(c_cuenta,1,4) = '1414')   or (substr(c_cuenta,1,4) = '1415')   or (substr(c_cuenta,1,4) = '1416')   or (substr(c_cuenta,1,4) = '1418')
            or (substr(c_cuenta,1,4) = '1421')   or (substr(c_cuenta,1,4) = '1423')   or (substr(c_cuenta,1,4) = '1424')   or (substr(c_cuenta,1,4) = '1425')   or (substr(c_cuenta,1,4) = '1426')   or (substr(c_cuenta,1,4) = '1428')
            or (substr(c_cuenta,1,4) = '7111')   or (substr(c_cuenta,1,4) = '7112')   or (substr(c_cuenta,1,4) = '7113')   or (substr(c_cuenta,1,4) = '7114') 
            or (substr(c_cuenta,1,4) = '7121')   or (substr(c_cuenta,1,4) = '7122')   or (substr(c_cuenta,1,4) = '7123')   or (substr(c_cuenta,1,4) = '7124') 
            or (substr(c_cuenta,1,4) = '8113')   or (substr(c_cuenta,1,4) = '8123')
            or (substr(c_cuenta,1,6) = '811302') or (substr(c_cuenta,1,6) = '812302') 
            or (substr(c_cuenta,1,6) = '721501') or (substr(c_cuenta,1,6) = '721502') or (substr(c_cuenta,1,6) = '721503') or (substr(c_cuenta,1,6) = '721504') or (substr(c_cuenta,1,6) = '721505') or (substr(c_cuenta,1,6) = '721506') or (substr(c_cuenta,1,6) = '721507')  
            or (substr(c_cuenta,1,6) = '722501') or (substr(c_cuenta,1,6) = '722502') or (substr(c_cuenta,1,6) = '722503') or (substr(c_cuenta,1,6) = '722504') or (substr(c_cuenta,1,6) = '722505') or (substr(c_cuenta,1,6) = '722506') or (substr(c_cuenta,1,6) = '722507')
                )
           and d_fecpre between ld_fecini and ld_fecrcc
         group by ent.tp1desc,D_fecpre
         order by 1;
     exception
     when no_data_found then
              ps_coderr := '00011';
              ps_msgerr := 'NO HAY DATOS';
     when        others then
              ps_coderr := '00099';
              ps_msgerr := SQLERRM;
  end;
end SP_AC_RCCCLI;

procedure SP_AC_CALCLI(ps_codsbs in varchar2, pc_calrcc out lc_liscur, ps_coderr out char,
                     ps_msgerr out varchar2) is
  -- *****************************************************************
  -- Nombre                     : SP_AC_CALCLI
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Calificación de los últimos 6 meses, 
  --                              además muestra el número de entidades y el saldo acumulado por meses.
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  begin
  declare
  ld_fecrcc date;
  ld_fecini date;
  ls_deserr char(100);
  ls_desmen varchar2(1000);
  begin
    sp_ac_fecrcc(ld_fecrcc,ls_deserr,ls_desmen);
    select add_months(ld_fecrcc,-5) 
      into ld_fecini 
      from dual;
      open pc_calrcc for
    select det.d_fecpre,  
           substr(to_char(to_date(to_char(det.d_fecpre,'mm'),'mm'),'Month'),1,3) ||' - '|| to_char(det.D_fecpre,'YYYY') as fecdes,
           cab.n_calif0 as calnor,
           cab.n_calif1 as calcPP,
           cab.n_calif2 as caldef,
           cab.n_calif3 as caldud,
           cab.n_calif4 as calper,
           sum(n_salcap)as monto,
           count(distinct c_codemp) as nument
      from cldrccs det
     inner join cldrcci cab
        on det.c_codsbs =cab.c_codsbs
     where det.c_codsbs=ps_codsbs 
       and ( 
           (substr(c_cuenta,1,4) = '1411')   or (substr(c_cuenta,1,4) = '1413' )  or (substr(c_cuenta,1,4) = '1414')   or (substr(c_cuenta,1,4) = '1415')  or (substr(c_cuenta,1,4) = '1416')   or (substr(c_cuenta,1,4) = '1418')
        or (substr(c_cuenta,1,4) = '1421')   or (substr(c_cuenta,1,4) = '1423')   or (substr(c_cuenta,1,4) = '1424')   or (substr(c_cuenta,1,4) = '1425')  or (substr(c_cuenta,1,4) = '1426')   or (substr(c_cuenta,1,4) = '1428')
        or (substr(c_cuenta,1,4) = '7111')   or (substr(c_cuenta,1,4) = '7112')   or (substr(c_cuenta,1,4) = '7113')   or (substr(c_cuenta,1,4) = '7114') 
        or (substr(c_cuenta,1,4) = '7121')   or (substr(c_cuenta,1,4) = '7122')   or (substr(c_cuenta,1,4) = '7123')   or (substr(c_cuenta,1,4) = '7124') 
        or (substr(c_cuenta,1,4) = '8113')   or (substr(c_cuenta,1,4) = '8123')
        or (substr(c_cuenta,1,6) = '811302') or (substr(c_cuenta,1,6) = '812302') 
        or (substr(c_cuenta,1,6) = '721501') or (substr(c_cuenta,1,6) = '721502') or (substr(c_cuenta,1,6) = '721503') or (substr(c_cuenta,1,6) = '721504') or (substr(c_cuenta,1,6) = '721505') or (substr(c_cuenta,1,6) = '721506') or (substr(c_cuenta,1,6) = '721507')  
        or (substr(c_cuenta,1,6) = '722501') or (substr(c_cuenta,1,6) = '722502') or (substr(c_cuenta,1,6) = '722503') or (substr(c_cuenta,1,6) = '722504') or (substr(c_cuenta,1,6) = '722505') or (substr(c_cuenta,1,6) = '722506') or (substr(c_cuenta,1,6) = '722507')
            )       
       and det.d_fecpre between ld_fecini and ld_fecrcc
     group by det.d_fecpre,
              cab.n_calif0,
              cab.n_calif1,
              cab.n_calif2,
              cab.n_calif3,
              cab.n_calif4
     order by 1;
 exception
 when no_data_found then
          ps_coderr := '00011';
          ps_msgerr := 'NO HAY DATOS';
 when others then
          ps_coderr := '00099';
          ps_msgerr := SQLERRM;
  end;
end SP_AC_CALCLI;

procedure SP_AC_CABRCC(pn_codpai number,  pn_tipdoc number, ps_numdoc varchar2,
                     ps_coderr out char,ps_msgerr out varchar2) is
-- *****************************************************************
  -- Nombre                     : SP_AC_CABRCC
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Guarda la calificación del RCC de la persona.
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
begin
  Declare
  ld_fecrcc date;
  ld_fecini date;
  ls_codsbs char(60);
  ls_deserr char(100);
  ls_desmen varchar2(1000);
  begin
    sp_ac_fecrcc(ld_fecrcc,ls_deserr,ls_desmen);
    select add_months(ld_fecrcc,-5),
           pq_ac_fun_agecom.fn_ac_codsbs(pn_tipdoc, trim(ps_numdoc))
      into ld_fecini,ls_codsbs 
      from dual;
    delete acdcrcc 
     where 
     ncodpai = pn_codpai and
     ntipdoc = pn_tipdoc and
     cnumdoc = ps_numdoc;
    insert 
      into acdcrcc
    select pn_codpai,
           pn_tipdoc,
           ps_numdoc,
           sum(n_salcap),
           count(distinct c_codemp),
           cab.n_calif0,
           cab.n_calif1,
           cab.n_calif2,
           cab.n_calif3,
           cab.n_calif4,
           det.d_fecpre 
      from cldrccs det
     inner join cldrcci cab
        on det.c_codsbs = cab.c_codsbs
     where det.c_codsbs = cast(ls_codsbs as VARCHAR2(10))
       and(
             (substr(c_cuenta,1,4) = '1411') or (substr(c_cuenta,1,4) = '1413') or (substr(c_cuenta,1,4) = '1414') or (substr(c_cuenta,1,4) = '1415') or (substr(c_cuenta,1,4) = '1416') or (substr(c_cuenta,1,4) = '1418')
          or (substr(c_cuenta,1,4) = '1421') or (substr(c_cuenta,1,4) = '1423') or (substr(c_cuenta,1,4) = '1424') or (substr(c_cuenta,1,4) = '1425') or (substr(c_cuenta,1,4) = '1426') or (substr(c_cuenta,1,4) = '1428')
          or (substr(c_cuenta,1,4) = '7111') or (substr(c_cuenta,1,4) = '7112') or (substr(c_cuenta,1,4) = '7113') or (substr(c_cuenta,1,4) = '7114') 
          or (substr(c_cuenta,1,4) = '7121') or (substr(c_cuenta,1,4) = '7122') or (substr(c_cuenta,1,4) = '7123') or (substr(c_cuenta,1,4) = '7124') 
          or (substr(c_cuenta,1,4) = '8113') or (substr(c_cuenta,1,4) = '8123')
          or (substr(c_cuenta,1,6) = '811302') or (substr(c_cuenta,1,6) = '812302') 
          or (substr(c_cuenta,1,6) = '721501') or (substr(c_cuenta,1,6) = '721502') or (substr(c_cuenta,1,6) = '721503') or (substr(c_cuenta,1,6) = '721504') or (substr(c_cuenta,1,6) = '721505') or (substr(c_cuenta,1,6) = '721506') or (substr(c_cuenta,1,6) = '721507')  
          or (substr(c_cuenta,1,6) = '722501') or (substr(c_cuenta,1,6) = '722502') or (substr(c_cuenta,1,6) = '722503') or (substr(c_cuenta,1,6) = '722504') or (substr(c_cuenta,1,6) = '722505') or (substr(c_cuenta,1,6) = '722506') or (substr(c_cuenta,1,6) = '722507')
        )       
      and det.d_fecpre between ld_fecini and ld_fecrcc
    group by det.d_fecpre,
             cab.n_calif0,
             cab.n_calif1,
             cab.n_calif2,
             cab.n_calif3,
             cab.n_calif4,
             det.c_codsbs
    order by 1;
   exception
   when no_data_found then
            ps_coderr := '00011';
            ps_msgerr := 'NO HAY DATOS';
   when others then
           ps_coderr := '00099';
           ps_msgerr := SQLERRM;
   end;
end SP_AC_CABRCC;

procedure SP_AC_CLISOB(pn_codpai in number, pn_tipdoc in number  ,ps_numdoc in char,
                     ps_estsob out varchar2 , ps_dessob out varchar,ps_coderr out char,
                     ps_msgerr out varchar2) is
  -- *****************************************************************
  -- Nombre                     : SP_AC_CLISOB
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 13/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Indicador de Sobreendeudado, S: Si es sobreendeudado N: No es sobreendeudado, 
  --                              además muestra la descripción del sobreendeudamiento.
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Modificación      : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ln_numano number;
  ln_nummes number;
  begin
    begin
      select max(jaql157ani) 
        into ln_numano 
        from JAQL157;
      select max(jaql157mes)    
        into ln_nummes
        from JAQL157
       where jaql157ani = ln_numano;
      select case 
                when j157.jaql157sob in ('E','S') then 'S'
                else 'N' 
             end,
             case 
                when j157.jaql157sob in ('N','E','S','I') then j157.jaql157sob 
                else 'SI' end if
        into ps_estsob,ps_dessob
        from jaql157 j157
       where j157.jaql157pai = pn_codpai
         and j157.jaql157tdo = pn_tipdoc
         and j157.jaql157ndo = ps_numdoc
         and j157.jaql157ani = ln_numano
         and j157.jaql157mes = ln_nummes;
   exception
   when no_data_found then
            ps_estsob :='N';
            ps_dessob :='N';
            ps_coderr := '00011';
            ps_msgerr := 'NO HAY DATOS';
   when        others then
            ps_coderr := '00099';
            ps_msgerr := SQLERRM;
    end;

end SP_AC_CLISOB;

procedure SP_AC_INDCAL(ps_codsbs in varchar,ps_indnor out varchar2, ps_indcpp out varchar2,
                     ps_coderr out char,ps_msgerr out varchar2) is
  -- *****************************************************************
  -- Nombre                     : SP_AC_INDCAL
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 17/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Indicador Si tiene una calificación mayor a 10% CPP  S:Si es mayor N:Menor o igual a 10 % CPP
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ln_pornor int;
  ln_porcpp int;
  ln_pordef int;
  ln_pordud int;
  ln_porper int;
  ld_fecrcc date;
  ld_fecini date;
  ls_errfec char(100);
  ls_errmen varchar2(1000);
  begin
     begin
       sp_ac_fecrcc(ld_fecrcc,ls_errfec,ls_errmen);
       select add_months(ld_fecrcc,-5) 
         into ld_fecini 
         from dual;
       select sum(cab.n_calif0) / count(*),
              sum(cab.n_calif1) / count(*),
              sum(cab.n_calif2) / count(*),
              sum(cab.n_calif3) / count(*),
              sum(cab.n_calif4) / count(*)
         into ln_pornor,ln_porcpp,ln_pordef,ln_pordud,ln_porper
         from cldrcci cab
        where cab.c_codsbs = ps_codsbs       
          and cab.d_fecpre between ld_fecini and ld_fecrcc
          and (cab.n_calif0 != 0 or
               cab.n_calif1 != 0 or
               cab.n_calif2 != 0 or
               cab.n_calif3 != 0 or
               cab.n_calif4 != 0);
       ps_indnor:= 'N';
       if ln_pornor <> 100 then 
          ps_indnor := 'S';
       end if;
       ps_indcpp:='N';
       if ln_pornor < 100 and (ln_porcpp > 10 or ln_pordef >0 or ln_pordud >0 or ln_porper >0)  then 
          ps_indcpp:='S';
       end if;
    exception
    when no_data_found then
             ps_indnor :='S';
             ps_coderr := '00011';
             ps_msgerr := 'NO HAY DATOS';
    when        others then
             ps_coderr := '00099';
             ps_msgerr := SQLERRM;
     end;
end SP_AC_INDCAL;

procedure SP_AC_DIRCLI(pn_codpai in number,pn_tipdoc in number,ps_numdoc in varchar,
                   pn_tipviv in number, ps_dircli out varchar2, ps_dirref out varchar2,
                   ps_dirubi out varchar2) is
  -- *****************************************************************
  -- Nombre                     : SP_AC_DIRCLI
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Dirección del cliente --Domicilio = 1 y Negocio=3
  -- Estado                     : Activo
  -- Fecha Modificación         :
  -- Autor de Modificación      :
  -- Descripcion Modificacion   :
  -- *****************************************************************
 ls_numdoc char(12);
  begin
     begin
       ls_numdoc := trim(ps_numdoc);
        select sngc13ref1,
               sngc13dir,
               sngc13dist
          into ps_dirref,
               ps_dircli,
               ps_dirubi
          from sngc13
         where sngc13pais = pn_codpai
           and sngc13tdoc = pn_tipdoc
           and sngc13Ndoc = ls_numdoc
           and docod      = pn_tipviv
           and sngc13Est  = 'H'
	   and sngc13corr = 1
           and rownum     = 1;
    
  if SUBSTRB(trim(ps_dirref),0,2) ='/ ' then
   ps_dirref:= trim(SUBSTRB(trim(ps_dirref),2,LENGTH(trim(ps_dirref))));
 else
   ps_dirref := trim(ps_dirref);
 end if;
            
     exception 
     when others then
       ps_dirref := '';
       ps_dircli := '';
       ps_dirubi := '';
     end;
end SP_AC_DIRCLI;


procedure SP_AC_EVACLI(ps_tipper varchar2,pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,ps_tiprol varchar2,
                     ps_indcon out varchar2,ps_paicon out varchar2, ps_tipcon out varchar2,
                     ps_doccon out varchar2,ps_sbscli out varchar2, ps_sbscon out varchar2,
                     --ps_nomcli out varchar2,
                     ps_nomcon out varchar2,ps_clineg out varchar2,ps_conneg out varchar2,
                     ps_estsob out varchar2,ps_dessob out varchar2,ps_estrec out varchar2,
                     ps_desrec out varchar2,ps_nument out varchar2,ps_conent out varchar2,
                     ps_clijud out varchar2,ps_conjud out varchar2,ps_clicas out varchar2,
                     ps_concas out varchar2,ps_clinor out varchar2,ps_clicpp out varchar2,
                     ps_connor out varchar2,ps_concpp out varchar2,ps_calgen out varchar2,
                     ps_calcli out varchar2,ps_calcon out varchar2,ps_escosb out varchar2,
                     ps_decosb out varchar2,ps_segcli out varchar2,
                     ps_nomcli out varchar2,ps_dirdom out varchar2,ps_dirneg out varchar2,
                     ps_acteco out varchar2,ps_estcre out varchar2,ps_fecdes out varchar2,
                     ps_codana out varchar2,ps_codage out varchar2,ps_telcli out varchar2,
                     ps_refviv out varchar2,ps_refneg out varchar2,ps_ubicli out varchar2,
                     ps_ubineg out varchar2,ps_tipcli out varchar2,ps_numina out varchar2,
                     ps_crecon out varchar2,ps_descon out varchar2,ps_prosbs out varchar2,
                     ps_conpro out varchar2,ps_segcon out varchar2,ps_actcli out varchar2,
                     ps_actcon out varchar2,ps_tipcny out varchar2,ps_inacon out varchar2,
                     ps_fecnac out varchar2,ps_naccon out varchar2,ps_nomsec out varchar2,
                     pn_mondes out varchar2,ps_desmon out varchar2,ps_nomana out varchar2,
                     ps_anasol out varchar2,ps_sucsol out varchar2,ps_fecsol out varchar2,
                     --ps_vivcli out varchar2,ps_negcli out varchar2,
                     ps_despro out varchar2,ps_nomage out varchar2,ps_solvig out varchar2,
                     ps_coderr out char,ps_msgerr out varchar2) is
-- *****************************************************************
  -- Nombre                     : SP_AC_EVACLI
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 19/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Evaluación de clientes obteniedno todos los parametros y guardando 
  --                              el resultado de la evaluación en la tabla ACDEVAL
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

  ls_errcon char(5);
  ls_numdoc char(12);
  ln_numano number;
  ln_nummes number;
  ln_tipcon number;
  ln_paicon number;
  ln_numina number;
  ln_inacon number;
  ld_fecpro date;
  ln_codemp fsd010.pgcod%type;
  ln_codmod fsd010.aomod%type;
  ln_codage fsd010.aosuc%type;
  ln_codmon fsd010.aomda%type;
  ln_codpap fsd010.aopap%type;
  ln_codcta fsd010.aocta%type;
  ln_codope fsd010.aooper%type;
  ln_subope fsd010.aosbop%type;
  ln_tipope fsd010.aotope%type;
  ln_estado fsd010.aostat%type;
  ld_fecdes date;
  ld_feccan date;
  ln_mondes number(14,2);
  begin
     begin
       ps_indcon := 'N';
       ls_numdoc := trim(ps_numdoc);
       ps_calgen := '1';
       ps_calcli := '1';
       ps_calcon := '1';
       select to_number(to_char(pgfape,'yyyy')),
              to_number(to_char(pgfape,'mm'))
         into ln_numano,ln_nummes
         from FST017
        where pgcod=1;
       if ln_nummes = 1 then
          ln_nummes:=12;
          ln_numano:=ln_numano-1;
       else
          ln_nummes:=ln_nummes-1;
       end if;
       sp_ac_concli(pn_tipdoc,pn_codpai,ls_numdoc,ps_nomcon,ln_tipcon,ln_paicon,ps_doccon,ls_errcon,ps_msgerr);
       if ps_nomcon = 'NO EXISTE 999' then
              select  pq_ac_fun_agecom.fn_ac_nomper(ln_paicon,ln_tipcon,trim(ps_doccon)) into ps_nomcli from dual;
       end if;
       ps_tipcon := nvl(to_char(ln_tipcon),'NO EXISTE 999');
       ps_paicon := nvl(to_char(ln_paicon),'NO EXISTE 999');
       ps_nomcon := nvl(ps_nomcon,'NO EXISTE 999');
       ps_doccon := nvl(ps_doccon,'NO EXISTE 999');
       select pq_ac_fun_agecom.fn_ac_codsbs(pn_tipdoc,trim(ls_numdoc)),
              pq_ac_fun_agecom.fn_ac_segcli(pn_tipdoc,pn_codpai,trim(ls_numdoc)),
              --pq_ac_fun_agecom.fn_nomper(pn_codpai,pn_tipdoc,trim(ls_numdoc)),
              --pq_ac_fun_agecom.fn_dircli(pn_codpai,pn_tipdoc,trim(ls_numdoc),1),
              --pq_ac_fun_agecom.fn_dircli(pn_codpai,pn_tipdoc,trim(ls_numdoc),1)
              
              pq_ac_fun_agecom.fn_ac_procli(pn_codpai,pn_tipdoc,trim(ls_numdoc)),
              pq_ac_fun_agecom.fn_ac_actcli(pn_codpai,pn_tipdoc,trim(ls_numdoc))
         into ps_sbscli,ps_segcli,ps_prosbs,ps_actcli --ps_nomcli,ps_vivcli,ps_negcli
         from dual;
       ps_fecnac := '01/01/0001';  
       if ps_tipper = 'F' then
           select pq_ac_fun_agecom.fn_ac_fecnac(pn_codpai,pn_tipdoc,trim(ls_numdoc))
         into ps_fecnac
         from dual;
       end if;  
       sp_ac_lisneg(pn_tipdoc,pn_codpai,ls_numdoc,ps_clineg,ps_coderr,ps_msgerr);
       sp_ac_clisob(pn_codpai,pn_tipdoc,ls_numdoc,ps_estsob, ps_dessob,ps_coderr,ps_msgerr);
       --sp_clirec(ls_numdoc,sysdate,'P',ps_estrec,ps_desrec,ps_coderr,ps_msgerr);
       sp_ac_clirec (ps_numdoc,pn_tipdoc,sysdate,ps_tipcli,ln_numina,ps_estrec,ps_desrec);
              
       select pq_ac_fun_agecom.fn_ac_nument(trim(ps_sbscli)),
              pq_ac_fun_agecom.fn_ac_indjud(pn_codpai,pn_tipdoc,ls_numdoc),
              pq_ac_fun_agecom.fn_ac_indcas(pn_codpai,pn_tipdoc,ls_numdoc)
         into ps_nument,ps_clijud,ps_clicas
         from dual;
       sp_ac_indcal(trim(ps_sbscli),ps_clinor,ps_clicpp,ps_coderr,ps_msgerr);
       if ps_clineg = 'S' or 
          ps_estsob = 'S' or 
         (ps_estrec = 'S' and ps_nument>5) or 
         (ps_estrec = 'N' and ps_nument>4) or
          ps_clijud = 'S' or
          ps_clicas = 'S'
           then
         ps_calcli := '3';
        end if;
       if ps_doccon <> 'NO EXISTE 999' then
           ps_naccon := '01/01/0001';
           ps_indcon := 'S';
           select pq_ac_fun_agecom.fn_ac_codsbs(ps_tipcon,ps_doccon),
                  pq_ac_fun_agecom.fn_ac_nomper(ps_paicon,ps_tipcon,trim(ps_doccon)),
                  pq_ac_fun_agecom.fn_ac_procli(ps_paicon,ps_tipcon,trim(ps_doccon)),
                  pq_ac_fun_agecom.fn_ac_segcli(ps_tipcon,ps_paicon,trim(ps_doccon)),
                  pq_ac_fun_agecom.fn_ac_actcli(ps_paicon,pn_tipdoc,trim(ps_doccon)),
                  pq_ac_fun_agecom.fn_ac_fecnac(ps_paicon,pn_tipdoc,trim(ps_doccon))
             into ps_sbscon,ps_nomcon ,ps_conpro,ps_segcon,ps_actcon,ps_naccon
             from dual;
           --Falta validar si no existe conyugue bantotal o RCC no hacer llamado a funciones  
           sp_ac_lisneg(ps_tipcon,ps_paicon,ps_doccon,ps_conneg,ps_coderr,ps_msgerr);
           select pq_ac_fun_agecom.fn_ac_nument(trim(ps_sbscon)),
                  pq_ac_fun_agecom.fn_ac_indjud(ps_paicon,ps_tipcon,ps_doccon),
                  pq_ac_fun_agecom.fn_ac_indcas(ps_paicon,ps_tipcon,ps_doccon)
             into ps_conent,ps_conjud,ps_concas
             from dual;
           sp_ac_clisob(ps_paicon,ps_tipcon,ps_doccon,ps_escosb,ps_decosb,ps_coderr,ps_msgerr); 
           sp_ac_estcre(ps_tipcon,ps_paicon,ps_doccon,ps_crecon,ps_descon,ps_coderr,ps_msgerr);   
           --sp_clirec (ps_doccon,ps_tipcon,sysdate,ps_tipcny,ln_inacon);   
           sp_ac_clirec (ps_doccon,ps_tipcon,sysdate,ps_tipcny,ln_inacon,ps_estrec,ps_desrec);
           ps_tipcny:= trim(ps_tipcny);
           ps_inacon:= to_char(ln_inacon); 
           sp_ac_indcal(trim(ps_sbscon),ps_connor,ps_concpp,ps_coderr,ps_msgerr);
           if ps_conneg = 'S' or
              ps_conjud = 'S' or
              ps_concas = 'S' or 
              ps_escosb = 'S' then
              ps_calcon:= '3';
           end if;
         if (ps_indcon='S' and ps_calcon = '1' and ps_connor = 'S' )then
             if ps_concpp = 'N' then
                ps_calcon:='2';
             else
                ps_calcon:='3';
             end if;
         end if;
       else 
         ps_calcon := '0';
         ps_sbscon := 'NO EXISTE 999';
         ps_nomcon := 'NO EXISTE 999';
         ps_conent := 0;
         ps_conjud := 'N';
         ps_concas := 'N';
         ps_conneg := 'N';
         ps_escosb := 'N';
         ps_decosb :='NO EXISTE 999';
         ps_connor := 'N';
         ps_concpp := 'N';
         ps_crecon := 'N';
         ps_descon := 'N';
         ps_conpro := 'NO EXISTE 999';
         ps_segcon := 'NO EXISTE 999';
         ps_actcon := 'NO EXISTE 999';
       end if;
       if (ps_calcli = '1' and ps_clinor = 'S' )then --Revision
          if  ps_clicpp = 'N' then
              ps_calcli:='2';
          else
              ps_calcli:='3';
          end if;
       end if;
       
       if ps_calcli > ps_calcon then
          ps_calgen:= ps_calcli;
       else
          ps_calgen:= ps_calcon;
       end if;
       if ps_calcon = '0' then
          ps_calcon:= 'NO EXISTE 999';
       end if;    
     ld_fecpro := pq_ac_fun_agecom.fn_ac_fecsis(1);
     sp_ac_clicaj(ps_tipper,pn_tipdoc,pn_codpai,ps_numdoc,ps_nomcli,ps_coderr,ps_msgerr);
     if ps_nomcli = 'NO EXISTE 999' then
        select pq_ac_fun_agecom.fn_ac_nomper(pn_codpai,pn_tipdoc,trim(ps_numdoc)) into ps_nomcli from dual;
     else
        SP_AC_DATCRE(pn_tipdoc,pn_codpai,trim(ps_numdoc),ld_fecpro,ln_codemp,ln_codmod,
                    ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,ln_subope,
                    ln_tipope,ln_estado,ld_fecdes,ld_feccan,ln_mondes,ps_coderr,ps_msgerr);
        pn_mondes := to_char(ln_mondes,'99999999999.99');             
        if ps_coderr <> '00011' then
           ps_despro := pq_ac_fun_agecom.fn_ac_nompro(ln_codmod);
           ps_desmon := pq_ac_fun_agecom.fn_ac_desmon(ln_codmon);
           ps_nomage := pq_ac_fun_agecom.fn_ac_nomage(ln_codage);
           ps_nomana := nvl(fn_analista_credito(ln_codmod,ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,ln_subope,ln_tipope),'999');   
           if trim(ps_nomana) = '999'  then
              ps_nomana := 'NO EXISTE 999';
           end if;   
         else
           pn_mondes := '0.00';
           ps_despro := 'NO EXISTE 999';
           ps_desmon := 'NO EXISTE 999';
           ps_nomage := 'NO EXISTE 999';
           ps_nomana := 'NO EXISTE 999';
        end if;   
     end if;      
     select pq_ac_fun_agecom.fn_ac_nomact(pn_codpai,pn_tipdoc,trim(ps_numdoc)),
            pq_ac_fun_agecom.fn_ac_telcli(pn_codpai,pn_tipdoc,trim(ps_numdoc)),
            pq_ac_fun_agecom.fn_ac_nomsec(pn_codpai,pn_tipdoc,trim(ps_numdoc))           
       into ps_acteco,ps_telcli,ps_nomsec
       from dual;
     sp_ac_estcre(pn_tipdoc,pn_codpai,ps_numdoc,ps_estcre,ps_fecdes,ps_coderr,ps_msgerr);
     sp_ac_anaage(pn_tipdoc,pn_codpai,ps_numdoc,ps_codana,ps_codage,ps_coderr,ps_msgerr);
     sp_ac_dircli(pn_codpai,pn_tipdoc,ps_numdoc,1,ps_refviv,ps_dirdom,ps_ubicli);
     sp_ac_dircli(pn_codpai,pn_tipdoc,ps_numdoc,3,ps_refneg,ps_dirneg,ps_ubineg);
     --sp_clirec (ps_numdoc,pn_tipdoc,sysdate,ps_tipcli,ln_numina); ---
     ps_tipcli:= trim(ps_tipcli);
     ps_numina:=to_char(ln_numina);
     SP_AC_CONCREPRO(pn_codpai,pn_tipdoc,ps_numdoc,ps_solvig,ps_anasol,ps_sucsol,ps_fecsol,ps_coderr,ps_msgerr);
    --Estaba el Insert
    exception
    when no_data_found then
             ps_coderr := '00011';
             ps_msgerr := 'NO HAY DATOS';
    when        others then
             ps_coderr := '00099';
             ps_msgerr := SQLERRM;
     end;
end SP_AC_EVACLI;

procedure SP_AC_INGCTA(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                    ps_coderr out char,ps_msgerr out varchar2) is
  -- *****************************************************************
  -- Nombre                     : SP_AC_INGCTA
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 21/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Procedimiento que carga los créditos a la tabla ACDCTAS
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Modificación      : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ld_dfecpro date;
  ls_numdoc varchar2(12);
  begin
    ls_numdoc := trim(ps_numdoc);
    select pq_ac_fun_agecom.fn_ac_fecsis(1) 
      into ld_dfecpro 
      from dual;
    delete acdctas 
     where ncodpai = pn_codpai
       and ntipdoc = pn_tipdoc
       and vnumdoc = ls_numdoc;
    begin
      insert into acdctas (
      ncodpai,ntipdoc,vnumdoc,ncodemp,nmodulo,ncodage,nmoneda,ncodpap,ncodcta,ncodope,nsubope,ntipope,nestcre,
      vcodana,dfecdes,dfecven,nprosbs,nmondes,nsalcap,nmoncuo,nnumcuo,ncuopen,natracu,natrmax,natru12,cindref,nmontas,dfeccan
       )
       select cab.pepais,
              cab.petdoc,
              trim(cab.pendoc),
              cre.pgcod,
              cre.aomod,
              cre.aosuc,
              cre.aomda,
              cre.aopap,
              cre.aocta,
              cre.aooper,
              cre.aosbop,
              cre.aotope,
              cre.aostat,
              t2.SNG001Ase,
              sal.Scfval,
              cre.aofvto,
              sal.Scgru,
              cre.Aoimp,
              coalesce(sal.scsdo*-1,0),
              pq_ac_fun_agecom.fn_ac_cuocre(cre.aocta,cre.aooper,cre.aotope,cre.aosbop,cre.aomod,cre.aosuc,cre.aomda),
              pq_ac_fun_agecom.fn_ac_nrocuo(cre.pgcod,cre.aomod,cre.aosuc,cre.aomda,cre.aopap,cre.aocta,cre.aooper,cre.aosbop,cre.aotope),
              pq_ac_fun_agecom.fn_ac_cuopen(cre.pgcod,cre.aomod,cre.aosuc,cre.aomda,cre.aopap,cre.aocta,cre.aooper,cre.aosbop,cre.aotope,ld_dfecpro),
              pq_ac_fun_agecom.fn_ac_atracu(cre.pgcod,cre.aomod,cre.aosuc,cre.aomda,cre.aopap,cre.aocta,cre.aooper,cre.aosbop,cre.aotope,ld_dfecpro,cre.aofvto),
              pq_ac_fun_agecom.fn_ac_atrmax(cre.pgcod,cre.aomod,cre.aosuc,cre.aomda,cre.aopap,cre.aocta,cre.aooper,cre.aosbop,cre.aotope,ld_dfecpro,cre.aofvto),
              pq_ac_fun_agecom.fn_ac_atrdoc((case when cre.aostat = 99 then cre.aofe99 else trunc(ld_dfecpro) end),add_months((case when cre.aostat = 99 then cre.aofe99 else trunc(ld_dfecpro) end), -12) + 1, cre.pgcod, cre.aomod, cre.aosuc, cre.aomda, cre.aopap, cre.aocta, cre.aooper, cre.aosbop, cre.aotope),
              pq_ac_fun_agecom.fn_ac_estref(cli.pepais,cli.petdoc,cli.pendoc),
              cre.aotasa,
              cre.aofe99
         from fsr008 cab
        inner join fsd001 cli
           on cli.pepais = cab.pepais 
          and cli.petdoc = cab.petdoc 
          and cli.pendoc = cab.pendoc
        inner join fsr011 pue
           on pue.relcod = 50 
          and pue.r2mod  = 70  
          and pue.r1cta  = cab.ctnro
        inner join fsd010 cre
           on cre.pgcod  = pue.r1cod 
          and pue.r1mod  = cre.aomod 
          and pue.r1suc  = cre.aosuc 
          and pue.r1mda  = cre.aomda 
          and pue.r1pap  = cre.aopap 
          and pue.r1cta  = cre.aocta 
          and pue.r1oper = cre.aooper 
          and pue.r1sbop = cre.aosbop 
          and pue.r1tope = cre.aotope
         left join FSD011 sal
           on cre.pgcod  = sal.pgcod  
          and sal.scsuc  = cre.aosuc 
          and sal.scmda  = cre.aomda 
          and sal.scpap  = cre.aopap 
          and sal.sccta  = cre.aocta 
          and sal.scoper = cre.aooper 
          and sal.scsbop = cre.aosbop 
          and sal.sctope = cre.aotope
        inner join Xwf700 t1
           on t1.xwfempresa  = cre.pgcod 
          and t1.xwfsucursal = cre.aosuc 
          and t1.xwfmodulo   = cre.aomod 
          and t1.xwfmoneda   = cre.aomda 
          and t1.xwfpapel    = cre.aopap 
          and t1.xwfcuenta   = cre.aocta 
          and t1.xwfoperacion= cre.aooper 
          and t1.xwfsubope   = cre.aosbop 
          and t1.xwftipope   = cre.aotope 
          and t1.xwfcar3     = '1'
        inner join sng001 t2
           on t2.sng001inst   = t1.xwfprcins
        where cab.pepais      = pn_codpai
          and cab.petdoc      = pn_tipdoc
          and cab.pendoc      = cast(ls_numdoc as char(12))
          and cab.ttcod       = 1
          and cab.cttfir      = 'T'
          and pue.r2oper      in (7430,617197);
    exception
    when no_data_found then
        
           ps_coderr := '00011';
           ps_msgerr := 'NO HAY DATOS';
    when        others then
         
           ps_coderr := '00099';
           ps_msgerr := SQLERRM;
   end;
end SP_AC_INGCTA;

procedure SP_AC_DETRCC(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                    ps_coderr out char,ps_msgerr out varchar2) is
  -- *****************************************************************
  -- Nombre                     : SP_AC_DETRCC
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 21/10/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Procedimiento que inserta valores del detalle del RCC por entidades
  --                              en la tabla ACDDRCC
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Modificación      : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ld_fecrcc date;
  ld_fecini date;
  ls_codsbs varchar(60);
     begin
       sp_ac_fecrcc(ld_fecrcc,ps_coderr,ps_msgerr);
     select add_months(ld_fecrcc,-5),
            pq_ac_fun_agecom.fn_ac_codsbs(pn_tipdoc,trim(ps_numdoc))
       into ld_fecini, 
            ls_codsbs
       from dual;
       
    delete acddrcc 
     where ncodpai = pn_codpai
       and ntipdoc = pn_tipdoc
       and vnumdoc = ps_numdoc;
    begin
      
    insert into acddrcc
    select pn_codpai,
           pn_tipdoc,
           ps_numdoc,
           ent.tp1desc,
           sum(n_salcap),
           rcc.c_calvig,
           d_fecpre
      from cldrccs rcc
      left join fst198 ent
        on cast(rcc.c_codemp as int)  = cast(ent.tp1corr2 as int)  and ent.tp1cod1= 10849 and ent.tp1corr1=10
     where  c_codsbs=cast(ls_codsbs as VARCHAR2(10)) 
       and d_fecpre between ld_fecini and ld_fecrcc
       and (
           (substr(c_cuenta,1,4) = '1411')   or (substr(c_cuenta,1,4) = '1413' )  or (substr(c_cuenta,1,4) = '1414')   or (substr(c_cuenta,1,4) = '1415')   or (substr(c_cuenta,1,4) = '1416')   or (substr(c_cuenta,1,4) = '1418')
        or (substr(c_cuenta,1,4) = '1421')   or (substr(c_cuenta,1,4) = '1423')   or (substr(c_cuenta,1,4) = '1424')   or (substr(c_cuenta,1,4) = '1425')   or (substr(c_cuenta,1,4) = '1426')   or (substr(c_cuenta,1,4) = '1428')
        or (substr(c_cuenta,1,4) = '7111')   or (substr(c_cuenta,1,4) = '7112')   or (substr(c_cuenta,1,4) = '7113')   or (substr(c_cuenta,1,4) = '7114') 
        or (substr(c_cuenta,1,4) = '7121')   or (substr(c_cuenta,1,4) = '7122')   or (substr(c_cuenta,1,4) = '7123')   or (substr(c_cuenta,1,4) = '7124') 
        or (substr(c_cuenta,1,4) = '8113')   or (substr(c_cuenta,1,4) = '8123')
        or (substr(c_cuenta,1,6) = '811302') or (substr(c_cuenta,1,6) = '812302') 
        or (substr(c_cuenta,1,6) = '721501') or (substr(c_cuenta,1,6) = '721502') or (substr(c_cuenta,1,6) = '721503') or (substr(c_cuenta,1,6) = '721504') or (substr(c_cuenta,1,6) = '721505') or (substr(c_cuenta,1,6) = '721506') or (substr(c_cuenta,1,6) = '721507')  
        or (substr(c_cuenta,1,6) = '722501') or (substr(c_cuenta,1,6) = '722502') or (substr(c_cuenta,1,6) = '722503') or (substr(c_cuenta,1,6) = '722504') or (substr(c_cuenta,1,6) = '722505') or (substr(c_cuenta,1,6) = '722506') or (substr(c_cuenta,1,6) = '722507')
           )
        group by  ent.tp1desc,
                  d_fecpre,
                  rcc.c_calvig,
                  pn_codpai,
                  pn_tipdoc,
                  ps_numdoc;
        
    exception
    when no_data_found then
        
           ps_coderr := '00011';
           ps_msgerr := 'NO HAY DATOS';
    when        others then
         
           ps_coderr := '00099';
           ps_msgerr := SQLERRM;
   end;
end SP_AC_DETRCC;

procedure SP_AC_BUSREF(ps_tipper varchar2,pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_nomcli out varchar2, ps_dirdom out varchar2,ps_dirneg out varchar2,
                    ps_acteco out varchar2,ps_nomcon out varchar2,ps_tipcon out varchar2,
                    ps_paicon out varchar2,ps_doccon out varchar2,ps_estcre out varchar2,
                    ps_fecdes out varchar2,ps_coderr out char,ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_AC_BUSREF
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 28/09/2016
  -- Autor de Creación          : WCRW
  -- Uso                        : Mostrar datos de los referidos
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

   ln_tipcon number;
   ln_paicon number;
   begin
       
     sp_ac_clicaj(ps_tipper,pn_tipdoc,pn_codpai,ps_numdoc,
             ps_nomcli,ps_coderr,ps_msgerr);
             
     select pq_ac_fun_agecom.fn_ac_dircli(pn_codpai,pn_tipdoc,trim(ps_numdoc),1),
            pq_ac_fun_agecom.fn_ac_dircli(pn_codpai,pn_tipdoc,trim(ps_numdoc),3),
            pq_ac_fun_agecom.fn_ac_nomact(pn_codpai,pn_tipdoc,trim(ps_numdoc))
       into ps_dirdom,
            ps_dirneg,
            ps_acteco
       from dual;
     sp_ac_concli(pn_tipdoc,pn_codpai,ps_numdoc,ps_nomcon,ln_tipcon,ln_paicon,ps_doccon,ps_coderr,ps_msgerr);
     ps_tipcon := nvl(to_char(ln_tipcon),'NO EXISTE 999');
     ps_paicon := nvl(to_char(ln_paicon),'NO EXISTE 999');
     ps_nomcon := nvl(ps_nomcon,'NO EXISTE 999');
     ps_doccon := nvl(ps_doccon,'NO EXISTE 999'); 
     sp_ac_estcre(pn_tipdoc,pn_codpai,ps_numdoc,ps_estcre,ps_fecdes,ps_coderr,ps_msgerr);
      exception
      when no_data_found then
         ps_coderr := '00011';
         ps_msgerr := 'NO HAY DATOS';
         --commit;
         --rollback;
      when others then
         ps_coderr := '00099';
         ps_msgerr := SQLERRM;
         --commit;
         --rollback;
end SP_AC_BUSREF;

procedure SP_AC_ESTCRE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_estcre out varchar2, ps_fecdes out varchar2,          
                    ps_coderr out char,ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_AC_ESTCRE
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 28/09/2016
  -- Autor de Creación          : WCRW
  -- Uso                        : Muestra el estado del crédito y el último desembolso vigente
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
ln_numvig number;
ls_numdoc char(12);
   begin
     
     select 
--       case when  d10.aostat <> 99 then 'Vigente' 
--            else 'Cancelado' end ,
--       case when  d10.aostat <> 99 then 'Si' 
--            else 'No' end ,
            to_char(max(d10.Aofval),'dd/mm/yyyy')
       into ps_fecdes
       from fsr008 r08,fsd010 d10
      where r08.pepais = pn_codpai
        and r08.petdoc = pn_tipdoc
        and r08.pendoc = cast(ps_numdoc as char(12))
        and d10.pgcod = r08.pgcod
        and d10.aocta = r08.ctnro
        and d10.aomod in (select f111.modulo
       from fst111 f111
      where f111.dscod = 50
        and f111.modulo not in (29,120) union all select 117 from dual)
        and d10.aomod <> 117;
        
      ls_numdoc :=ps_numdoc;
      
    select count(case 
           when d.aostat <> 99 or (d.aostat = 99 and d.aofe99> sysdate) then 1 
             end) n_crevig
      into ln_numvig
      from fsr008 r 
      join fsd010 d on d.pgcod = r.pgcod
       and d.aocta = r.ctnro
       and d.aomod in (select modulo 
                         from fst111 
                        where dscod = 50
                       union all 
                        select 117 
                          from dual)
       and r.ttcod = 1 
       and r.cttfir = 'T' 
     where r.pendoc = ls_numdoc 
       and r.petdoc = pn_tipdoc
       and d.aofval < sysdate;
      --ps_tipcon:= to_char(ln_tipcon);  
      --ps_paicon:= to_char(ln_paicon);      
      if (ln_numvig>0) then
         ps_estcre := 'Si';
      else
         ps_estcre := 'No';
      end if;
      exception
      when no_data_found then
         ps_estcre := 'No';
         ps_fecdes := 'NO EXISTE 999';
         ps_coderr := '00011';
         ps_msgerr := 'NO HAY DATOS';
         --commit;
         --rollback;
      when others then
         ps_coderr := '00099';
         ps_estcre := 'No';
         ps_msgerr := SQLERRM;
         --commit;
         --rollback;
end SP_AC_ESTCRE;

procedure SP_AC_ANAAGE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                    ps_codana out varchar2, ps_codage out varchar2,          
                    ps_coderr out char,ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_AC_ANAAGE
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 28/11/2016
  -- Autor de Creación          : EBDC
  -- Uso                        : Retorna el código de agencia y el código de analista del cliente.
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

   ls_numdoc varchar2(15);
   begin
     ls_numdoc := trim(ps_numdoc);
     select sng001ase,
            sng001age
       into ps_codana,
            ps_codage
  from (
  select sng001ase,
         sng001fin,
         sng001age
    from sng001
   where sng001pais = pn_codpai and
         sng001tdoc = pn_tipdoc  and
         sng001ndoc = cast(ls_numdoc as char(12))
   order by sng001fin desc)
   where rownum <= 1;
   ps_codage := to_char(ps_codage);
      exception
      when no_data_found then
         ps_codana := 'NO EXISTE';
         ps_codage := '0';
         ps_coderr := '00011';
         ps_msgerr := 'NO HAY DATOS';
         --commit;
         --rollback;
      when others then
         ps_coderr := '00099';
         ps_msgerr := SQLERRM;
         --commit;
         --rollback;
end SP_AC_ANAAGE;

procedure SP_AC_CLIREC(ps_numdoc in varchar2, ps_tipdoc in varchar2,pd_fecpro in date,
                     ps_tipcli out char, ps_numina out integer,ps_estrec out varchar2,
                     ps_desrec out varchar2) is
  -- *****************************************************************
  -- Nombre                     : SP_AC_CLIREC
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 28/11/2016
  -- Autor de Creación          : EBDC
  -- Uso                        : Retorna el tipo de cliente, días de inactividad.
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ln_crecan number(4);
  ln_crevig number(4);
  ld_feccan date;
  ls_numdoc char(12);
  ls_doccon char(12);
  begin
    begin
       ls_numdoc := trim(ps_numdoc);
       begin
         select r.rpndoc into ls_doccon from fsr002 r where r.pendoc = ls_numdoc and rpccyg = 66;
         exception 
           when no_data_found then
             ls_doccon := ' ';
           when others then
             ls_doccon := ' ';
       end;
        select count(case 
                        when d.aostat = 99 and d.aofe99<=pd_fecpro then 1 
                     end) n_crecan,
               count(case 
                        when d.aostat <> 99 or (d.aostat = 99 and d.aofe99>pd_fecpro) then 1 
                     end) n_crevig,
               max(d.aofe99) d_maxcan
          into ln_crecan,ln_crevig,ld_feccan
          from fsr008 r 
          join fsd010 d on d.pgcod = r.pgcod
                       and d.aocta = r.ctnro
                       and d.aomod in (
                               select modulo 
                                 from fst111 
                                 where dscod = 50 
                                   --and modulo not in (29,120) 
                                 union all 
                               select 117 
                                 from dual
                                 )
                       and r.ttcod = 1 --Sólo titular representativo 2017.01.03
                       and r.cttfir = 'T' --Sólo titular representativo 2017.01.03
         --where trim(r.pendoc) in (ls_tmpdoc,ls_tmpcon) --Se evalúa también al cónyuge 2017.01.03
         where r.pendoc in (ls_numdoc,ls_doccon) --Se evalúa también al cónyuge 2017.01.03
           and r.petdoc = ps_tipdoc
           and d.aofval < pd_fecpro;
     exception 
     when others then
       ln_crecan := 0;
       ln_crevig := 0;
       ld_feccan := null;
    end;
    if    ln_crevig = 0 and  ln_crecan>0 and pd_fecpro - ld_feccan >=15 then
          ps_tipcli:= '3';
          ps_numina:= pd_fecpro - ld_feccan;
          ps_estrec:= 'N';
          ps_desrec:= 'I';
    elsif ln_crevig = 0 and  ln_crecan>0 and pd_fecpro - ld_feccan<15 then
          ps_tipcli:= '2';
          ps_numina:= pd_fecpro - ld_feccan;
          ps_estrec:= 'S';
          ps_desrec:= 'R';
    elsif ln_crevig = 0 and ln_crecan = 0 then
          ps_tipcli:= '1';
          ps_numina:= 0;
          ps_estrec:= 'N';
          ps_desrec:= 'N';
    elsif ln_crevig >0  then
          ps_tipcli:= '2';
          ps_numina:= 0;
          ps_estrec:= 'S';
          ps_desrec:= 'R';
    end if;
    if (ps_numina<0) then
      ps_numina:= 0;
    end if;
      
  exception
  when no_data_found then
           ps_estrec := '1';
  when        others then
           ps_estrec := '1';
end SP_AC_CLIREC;

procedure SP_AC_DATCRE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,pd_fecpro date,
                       pn_codemp out fsd010.pgcod%type,pn_codmod out fsd010.aomod%type,
                       pn_codage out fsd010.aosuc%type,pn_codmon out fsd010.aomda%type,
                       pn_codpap out fsd010.aopap%type,pn_codcta out fsd010.aocta%type,
                       pn_codope out fsd010.aooper%type,pn_subope out fsd010.aosbop%type,
                       pn_tipope out fsd010.aotope%type,pn_estado out fsd010.aostat%type,
                       pd_fecdes out fsd010.aofval%type,pd_feccan out fsd010.aofe99%type,
                       pn_mondes out fsd010.aoimp%type,ps_coderr out char,ps_msgerr out varchar2) 
  is
  -- *****************************************************************
  -- Nombre                     : SP_AC_DATCRE
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 27/01/2017
  -- Autor de Creación          : WCRW
  -- Uso                        : Retorna datos del último credito desembolsado sin considerar prendario
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ls_numdoc char(12);
  begin
     ps_coderr := '00000';
     ls_numdoc := ps_numdoc;
     begin 
        Select pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,aostat,
               aofval,aofe99,aoimp                     
          into pn_codemp,pn_codmod,pn_codage,pn_codmon,pn_codpap,pn_codcta,
               pn_codope,pn_subope,pn_tipope,pn_estado,pd_fecdes,pd_feccan,pn_mondes
          from (select                           
                        a.pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,
                        aostat,aofval,aofe99,aoimp                     
                   from fsd010 a join fsr008 r8 on r8.pgcod = a.pgcod
                                  and r8.ctnro = a.aocta
                                  and r8.pepais = pn_codpai
                                  and r8.petdoc = pn_tipdoc
                                  and r8.pendoc = ls_numdoc
                                  and r8.ttcod = 1
                                  and r8.cttfir = 'T'
                   where a.aomod in (select modulo from fst111 where dscod=50 and modulo not in (29,120) union all select 117 from dual) 
                     and a.aomod <> 120
                     and a.aomod <> 108
                     and a.aofval <= pd_fecpro
                 order by a.aofval desc               
                 )
              WHERE rownum = 1;              
          exception when others then
               ps_coderr := '00011';
               ps_msgerr := 'NO HAY DATOS';
          end;             
  end SP_AC_DATCRE;
  
  procedure SP_AC_CONDATAVA(pn_codemp fsd010.pgcod%type,pn_codmod fsd010.aomod%type,
                            pn_codage fsd010.aosuc%type,pn_codmon fsd010.aomda%type,
                            pn_codpap fsd010.aopap%type,pn_codcta fsd010.aocta%type,
                            pn_codope fsd010.aooper%type,pn_subope fsd010.aosbop%type,
                            pn_tipope fsd010.aotope%type,pn_tipdoc out number,pn_codpai out number,
                            ps_numdoc out varchar2,ps_nomava out varchar2,ps_dirava out varchar2,
                            ps_refava out varchar2,ps_ubiava out varchar2,ps_telava out varchar2,
                            ps_coderr out char,ps_msgerr out varchar2)
  is
  -- *****************************************************************
  -- Nombre                     : SP_AC_CONDATAVA
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 01/02/2017
  -- Autor de Creación          : WCRW
  -- Uso                        : Consulta Datos del Aval último crédito
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ls_numdoc char(12);
  ls_coderr char(5);
  ls_msgerr varchar2(200);
  begin
     ls_numdoc := ps_numdoc;
     begin
        select f08.pepais,f08.petdoc,f08.pendoc 
          into pn_codpai,pn_tipdoc,ps_numdoc
          from fsr011 f11,fsr008 f08
         where f11.r1cod = pn_codemp
           and f11.r1mod = pn_codmod
           and f11.r1suc = pn_codage
           and f11.r1mda = pn_codmon
           and f11.r1pap = pn_codpap
           and f11.r1cta = pn_codcta
           and f11.r1oper = pn_codope
           and f11.r1sbop = pn_subope
           and f11.r1tope = pn_tipope
           and f11.relcod = 50 
           and f11.r2mod = 70 
           and f11.r2tope = 91
           and f11.r2cta = f08.ctnro
           and f08.pgcod = 1
           and f08.ttcod = 1
           and f08.cttfir = 'T';  
     exception when others then
        ps_numdoc := 'NO EXISTE 999';   
     end;   
     SP_AC_CLICAJ('F',pn_tipdoc,pn_codpai,ps_numdoc,ps_nomava,ls_coderr,ls_msgerr);
     sp_ac_dircli(pn_codpai,pn_tipdoc,ps_numdoc,1,ps_refava,ps_dirava,ps_ubiava);
     ps_telava := pq_ac_fun_agecom.FN_AC_TELCLI(pn_codpai,pn_tipdoc,ps_numdoc);
  end SP_AC_CONDATAVA;
  
  procedure SP_AC_CONDATCRE(pn_tipdoc number,pn_codpai number,ps_numdoc varchar2,
                            pd_fecdes out varchar2,pd_feccan out varchar2,ps_estcre out varchar2,ps_despro out varchar2,
                            ps_desmon out varchar2,pn_mondes out varchar2,ps_nomage out varchar2,ps_nomana out varchar2,
                            pn_atracu out varchar2,pn_atrmax out varchar2,ps_clicaj out varchar2,pn_crevig out varchar2,
                            pn_crecan out varchar2,pn_linvig out varchar2,pd_ultpag out varchar2,pn_moncuv out varchar2,
                            pn_cappag out varchar2,ps_codcta out varchar2,pn_tipdav out varchar2,pn_codpav out varchar2,
                            ps_numdav out varchar2,ps_nomava out varchar2,ps_dirava out varchar2,ps_refava out varchar2,
                            ps_ubiava out varchar2,ps_telava out varchar2,ps_coderr out char,ps_msgerr out varchar2)
  is
  -- *****************************************************************
  -- Nombre                     : SP_AC_CONDATCRE
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 01/02/2017
  -- Autor de Creación          : WCRW
  -- Uso                        : Consulta Datos del último crédito
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ls_numdoc char(12);
  ln_codemp fsd010.pgcod%type;
  ln_codmod fsd010.aomod%type;
  ln_codage fsd010.aosuc%type;
  ln_codmon fsd010.aomda%type;
  ln_codpap fsd010.aopap%type;
  ln_codcta fsd010.aocta%type;
  ln_codope fsd010.aooper%type;
  ln_subope fsd010.aosbop%type;
  ln_tipope fsd010.aotope%type;
  ln_estado fsd010.aostat%type;
  ld_fecdes date;
  ld_feccan date;
  ld_fecpro date;
  ln_crevig number(3);
  ln_crecan number(3);
  ln_linvig number(3);
  ln_mondes number(14,2);
  ln_tipdav number(3);
  ln_codpav number(3);
  ls_coderr char(5);
  ls_msgerr varchar2(200);
  begin
     ls_numdoc := ps_numdoc;
     begin 
       ld_fecpro := pq_ac_fun_agecom.fn_ac_fecsis(1);
       SP_AC_DATCRE(pn_tipdoc,pn_codpai,ps_numdoc,ld_fecpro,ln_codemp,ln_codmod,
                    ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,ln_subope,
                    ln_tipope,ln_estado,ld_fecdes,ld_feccan,ln_mondes,ls_coderr,ls_msgerr);
       pn_mondes := to_char(ln_mondes,'99999999999.99');             
       pd_fecdes := to_char(ld_fecdes,'DD/MM/YYYY');             
       pd_feccan := to_char(ld_feccan,'DD/MM/YYYY');
       if ls_coderr <> '00011' then
          ps_codcta := to_char(ln_codcta,'999999999999');
          ps_estcre := pq_ac_fun_agecom.fn_ac_estcre(ln_estado);
          ps_despro := pq_ac_fun_agecom.fn_ac_nompro(ln_codmod);
          ps_desmon := pq_ac_fun_agecom.fn_ac_desmon(ln_codmon);
          ps_nomage := pq_ac_fun_agecom.fn_ac_nomage(ln_codage);
          ps_nomana := fn_analista_credito(ln_codmod,ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,ln_subope,ln_tipope);
          pn_atracu := to_char(pq_ac_fun_agecom.fn_ac_atracu(ln_codemp,ln_codmod,ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,
                                                     ln_subope,ln_tipope,ld_fecpro,ld_fecpro),'999');
          pn_atrmax := to_char(pq_ac_fun_agecom.fn_ac_atrmax(ln_codemp,ln_codmod,ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,
                                                     ln_subope,ln_tipope,ld_fecpro,ld_fecpro),'999');
          pd_ultpag := to_char(pq_ac_fun_agecom.FN_AC_ULTFECPAG(ld_fecpro,ln_codemp,ln_codmod,ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,
                                                     ln_subope,ln_tipope),'DD/MM/YYYY');
          pd_ultpag := nvl(pd_ultpag,to_char(ld_fecpro,'DD/MM/YYYY'));                                                     
          pn_moncuv := to_char(pq_ac_fun_agecom.FN_AC_MONCUOVEN(ln_codemp,ln_codmod,ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,
                                                     ln_subope,ln_tipope,to_date(pd_ultpag,'DD/MM/YYYY')),'999999999999.99');                                                    
          pn_cappag := to_char(pq_ac_fun_agecom.FN_AC_CAPPAG(ln_codemp,ln_codmod,ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,
                                                     ln_subope,ln_tipope,ld_fecpro),'999999999999.99');                                                       
          SP_AC_TOTCRE(pn_tipdoc,pn_codpai,ps_numdoc,ps_clicaj,ln_crevig,ln_crecan,ln_linvig,ls_coderr,ls_msgerr);
          pn_crevig := to_char(ln_crevig,'9999');
          pn_crecan := to_char(ln_crecan,'9999');
          pn_linvig := to_char(ln_linvig,'9999');
          SP_AC_CONDATAVA(ln_codemp,ln_codmod,ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,
                          ln_subope,ln_tipope,ln_tipdav,ln_codpav,ps_numdav,ps_nomava,ps_dirava,
                          ps_refava,ps_ubiava,ps_telava,ls_coderr,ls_msgerr);
          if ps_numdav = 'NO EXISTE 999' then
             pn_tipdav := 'NOX';
             pn_codpav := 'NOX';
             ps_numdav := 'NO EXISTE 999';
             ps_nomava := 'NO EXISTE 999';
             ps_dirava := 'NO EXISTE 999';
             ps_refava := 'NO EXISTE 999';
             ps_ubiava := 'NO EXISTE 999';
             ps_telava := 'NO EXISTE 999';
          else                   
             pn_tipdav := to_char(ln_tipdav,'999');                
             pn_codpav := to_char(ln_codpav,'999');                
          end if;   
       end if;   
     end;
     pd_feccan := nvl(pd_feccan,'01/01/0001');             
  end SP_AC_CONDATCRE;
  
  procedure SP_AC_CAREVAAPR(pn_idebas number,pn_idepro number,pn_coding number,pn_codact number,pn_codbas number,
                            ps_estado varchar2,ps_codusu varchar2,pd_fecini date,pd_fecfin date,pn_codpro number,
                            pn_codage number,ps_coderr out char,ps_msgerr out varchar2)
  is
  -- *****************************************************************
  -- Nombre                     : SP_AC_CAREVAAPR
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 15/02/2017
  -- Autor de Creación          : WCRW
  -- Uso                        : Actualiza ACDBASE Cartera en evaluación / aprobación
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  begin
     begin
     ps_coderr := '00000';
    delete acdbase_temp
    where cusuing = ps_codusu
      and nidebas = 2  
      and nidepro = 9
      and ncoding = pn_coding 
      and ncodact = pn_codact
      and ncodbas = pn_codbas
      and cestado = 3;
      commit;
       
     insert into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                          cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                          dfecing,ncodpri,ncodsol,nmonsol,cmonsol,cdespro,cestpro,cusupro,cdesmod,cinipro,cfinpro)
                   select pn_idebas,pn_idepro,pn_coding,pn_codact,pn_codbas,trim(ps_estado),s1.sng001pais,s1.sng001tdoc,s1.sng001ndoc,0,0,'',
                          f1.penom,s13.sngc13dist,s13.sngc13dir,upper(trim(replace(s13.sngc13ref1,'/',''))),'','','',
                          pq_ac_fun_agecom.fn_ac_telcli(s1.sng001pais,s1.sng001tdoc,s1.sng001ndoc),'',s1.sng001age,'',ps_codusu,
                          sysdate,2,s1.sng001inst,s1.sng017mto,decode(x7.xwfmoneda ,0, 'S/.', 'US$'),
                          case when wf.wftaskcod = 3 then 'SOLICITUD'
                               when wf.wftaskcod = 7 then 'EVALUACION'
                               when wf.wftaskcod = 11 then 'APROBACION'
                               when wf.wftaskcod = 55 then 'DESEMBOLSO'
                          else ' '
                          end,
                          case when wf.wfstscod = 'A' then 'ASIGNADO'
                               when wf.wfstscod = 'C' then 'CERRADO'
                               when wf.wfstscod = 'P' then 'PENDIENTE'
                               when wf.wfstscod = 'R' then 'EN PROCESO'  
                               when wf.wfstscod = 'D' then 'DELEGADO'  
                          else ' ' 
                          end,
                          trim(substr(wf.wfitemusrcod,1,10)),f3.mdnom,
                          case when wf.wfiteminit = to_date('01/01/0001','dd/mm/yyyy') then ' ' else to_char(wf.wfiteminit,'dd/mm/yyyy HH24:MI') end cinipro,
                          case when wf.wfitemend = to_date('01/01/0001','dd/mm/yyyy') then ' ' else to_char(wf.wfitemend,'dd/mm/yyyy HH24:MI') end cfinpro
                     from sng001 s1,fst001 t1,xwf700 x7,fst003 f3,WFWRKITEMS wf,sng090 s90,
                          sng091 s91,sng065 s65,fsd001 f1,sngc13 s13
                    where (s1.sng001fin >= pd_fecini
                      and s1.sng001fin <= pd_fecfin)
                      and t1.pgcod = 1
                      and t1.sucurs = s1.sng001age
                      and x7.xwfprcins = s1.sng001inst
                      and x7.xwfcar3 = '1'
                      and f3.modulo = x7.xwfmodulo
                      and s1.sng001age = pn_CodAge
                      and wf.wfinsprcid(+) = s1.sng001inst
                      and wf.wftaskcod(+) = pn_codpro
                      and s90.sng001inst(+) = wf.wfinsprcid
                      and s90.sng090ite(+) = wf.wfitemid
               --     and s90.sng090tpo(+) = 'C'
                      and s91.sng001inst(+) = s90.sng001inst
                      and s91.sng090pqt(+) = s90.sng090pqt
                      and s65.sng062aut(+) = s91.sng091aut
                      and f1.Pepais = s1.sng001pais
                      and f1.Petdoc = s1.sng001tdoc
                      and f1.Pendoc = s1.sng001ndoc
                      and s13.sngc13pais = s1.sng001pais
                      and s13.sngc13tdoc = s1.sng001tdoc
                      and s13.sngc13Ndoc = s1.sng001ndoc
                      and s13.docod      = 1
                      and s13.sngc13Est  = 'H'
             --       and rownum     = 1
            order by s1.sng001inst,wf.wfitemid,wf.wftaskcod,s91.sng091aut,s65.sng065ord;
            commit;
     insert into acdbase       
     select * from acdbase_temp
    where cusuing = ps_codusu
      and nidebas = 2  
      and nidepro = 9
      and ncoding = pn_coding 
      and ncodact = pn_codact
      and ncodbas = pn_codbas
      and cestado = 3;
      commit;
      
     exception when others then
        ps_coderr := '00099';
        ps_msgerr := SQLERRM;
     end;          
  end SP_AC_CAREVAAPR;
  
  procedure SP_AC_CARMORANA(pn_idebas number,pn_idepro number,pn_coding number,pn_codact number,pn_codbas number,
                            ps_estado varchar2,ps_codusu varchar2,pn_codage number,ps_coddia varchar2,ps_codsal varchar2,
                            pn_codzon number,ps_coderr out char,ps_msgerr out varchar2)
  is
  -- *****************************************************************
  -- Nombre                     : SP_AC_CARMORANA
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 15/02/2017
  -- Autor de Creación          : WCRW
  -- Uso                        : Actualiza ACDBASE Cartera Morosa por Analista
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  pc_morana lc_liscur;
  ln_numins number(10);
  ls_codusu varchar2(30);
  ls_titcre varchar2(200);
  ls_dirdeu varchar2(200);
  ls_ubigeo varchar2(10);
  ls_teldeu varchar2(50);
  ls_codatv varchar2(200);
  ls_dirneg varchar2(200);
  ln_atrmax number(17,2);
  ln_salkco number(16,2);
  ls_segmen varchar2(100);
  ls_califi varchar2(50);
  ls_desmod varchar2(100);
  ls_destop varchar2(100);
  ls_nrocre varchar2(50);
  ln_moneda number(3);
  ln_mtoapr number(17,2);
  ln_salcap number(17,2);
  ls_nomsuc varchar2(100);
  ln_cuoimp varchar2(100);
  ln_diaatr number(10);
  ld_fecact varchar2(10);
  ls_refina varchar2(10);
  ls_lisneg varchar2(10);
  ln_codpai number(3);
  ln_tipdoc number(3);
  ls_numdoc varchar2(12);
  ln_ctacli number(10);
  ln_operac number(10);
  ln_mtodeu number(17,2);
  ls_tipsbs varchar2(100);
  ls_dessbs varchar2(50);
  ls_codest varchar2(100);
  ls_desest varchar2(200); 
  ls_disdeu varchar2(200);
  ls_refdeu varchar2(200);
  ls_nomava varchar2(200);
  ls_dirava varchar2(200);
  ls_telava varchar2(50);
  ln_latitu varchar2(200);
  ln_longit varchar2(200);
  ln_nucrmo varchar2(50);
  ld_feulre varchar2(10);
  ls_ultrea varchar2(10);
  ls_detrea varchar2(10);
  ls_mordet varchar2(1000);
  ld_feulpa date;
  ld_fevecr date;
  ls_flapri varchar2(1);
  begin
     
     begin
        ps_coderr := '00000';
        delete acdbase_temp
        where cusuing = ps_codusu
          and nidebas = 2  
          and nidepro = 9
          and ncoding = pn_coding 
          and ncodact = pn_codact
          and ncodbas = pn_codbas
          and cestado = 3;
      commit;
        wap.pq_gn_wap.sp_GeoBuscarClMora(pc_morana,ps_codusu,ps_coddia,ps_codsal,pn_codzon); 
        LOOP
        FETCH pc_morana INTO ln_numins,ls_codusu,ls_titcre,ls_dirdeu,ls_ubigeo,ls_teldeu,ls_codatv,ls_dirneg,ln_atrmax,
                             ln_salkco,ls_segmen,ls_califi,ls_desmod,ls_destop,ls_nrocre,ln_moneda,ln_mtoapr,ln_salcap,
                             ls_nomsuc,ln_cuoimp,ln_diaatr,ld_fecact,ls_refina,ls_lisneg,ln_codpai,ln_tipdoc,ls_numdoc,
                             ln_ctacli,ln_operac,ln_mtodeu,ls_tipsbs,ls_dessbs,ls_codest,ls_desest,ls_disdeu,ls_refdeu,
                             ls_nomava,ls_dirava,ls_telava,ln_latitu,ln_longit,ln_nucrmo,ld_feulre,ls_ultrea,ls_detrea,
                             ls_mordet,ld_feulpa,ld_fevecr,ls_flapri;
        EXIT WHEN pc_morana%NOTFOUND;
           --dbms_output.put_line('Cursor: ' || ls_titcre);
           insert into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                dfecing,ncodpri,nmoneda,nmonapr,nsalcap,cdesmod,cmordet,cnumcre)
                values (pn_idebas,pn_idepro,pn_coding,pn_codact,pn_codbas,ps_estado,ln_codpai,ln_tipdoc,ls_numdoc,0,0,'',
                        ls_titcre,ls_ubigeo,ls_dirdeu,ls_refdeu,'','','',ls_teldeu,'',pn_codage,ps_codusu,ps_codusu, 
                        sysdate,2,ln_moneda,ln_mtoapr,ln_salcap,ls_desmod,ls_mordet,ls_nrocre); 
           commit;             
        END LOOP;
        CLOSE pc_morana;

     insert into acdbase       
     select * from acdbase_temp
      where cusuing = ps_codusu
        and nidebas = 2  
        and nidepro = 9
        and ncoding = pn_coding 
        and ncodact = pn_codact
        and ncodbas = pn_codbas
        and cestado = 3;
      commit;
     exception when others then
        ps_coderr := '00099';
        ps_msgerr := SQLERRM;
     end;          
  end SP_AC_CARMORANA;
  
  procedure SP_AC_DETRCCACU(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                            ps_fecpro out varchar2,ps_desemp out varchar2,ps_tipcre out varchar2,
                            ps_diaatr out varchar2,ps_descal out varchar2,ps_salcap out varchar2,
                            ps_calif0 out varchar2,ps_calif1 out varchar2,ps_calif2 out varchar2,
                            ps_calif3 out varchar2,ps_calif4 out varchar2,ps_nument out varchar2,
                            ps_fecrcc out varchar2,ps_linusu out varchar2,ps_coderr out char,ps_msgerr out varchar2)
  is
  -- *****************************************************************
  -- Nombre                     : SP_AC_DETRCCACU
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 07/03/2017
  -- Autor de Creación          : WCRW
  -- Uso                        : Detalle RCC 6 Meses
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  Begin
  Declare
  ld_fecrcc date;
  ld_fecini date;
  ls_codsbs varchar2(10);
  ls_coderr varchar2(5);
  ls_msgerr varchar2(1000);
  cursor c_rccdet is
     select f.d_fecpre,f.c_codsbs,f.c_desemp,f.c_destcr,to_char(f.n_diaatr,'999999') c_diaatr,f.c_descal,to_char((f.n_salcap),'fm999,999,990.90') c_salcap,
            to_char(g.n_calif0,'999.99') c_calif0,to_char(g.n_calif1,'999.99') c_calif1,to_char(g.n_calif2,'999.99') c_calif2,
            to_char(g.n_calif3,'999.99') c_calif3,to_char(g.n_calif4,'999.99') c_calif4,to_char(g.n_canent,'999') c_canent,c_cretip,c_codemp
       from (select d_fecpre,c_codsbs || nvl(c_desemp, 'ENTIDAD') || c_destcr c_codsbs,nvl(c_desemp, 'ENTIDAD')c_desemp,
                    (select upper(tp1desc)
                       from fst198
                      where tp1cod = 1
                        and tp1cod1 = 10832
                        and tp1corr1 = 6
                        and tp1corr2 = c_cretip) c_destcr,n_diaatr,c_descal,c_cretip,c_codemp,sum(n_salcap) n_salcap
               from (select a.d_fecpre,a.c_cretip,c_codemp,decode(substr(a.c_cuenta,1,4),
                            '1411',a.c_codsbs,'1413',a.c_codsbs,'1414',a.c_codsbs,
                            '1415',a.c_codsbs,'1416',a.c_codsbs,'1418',a.c_codsbs,
                            '1421',a.c_codsbs,'1423',a.c_codsbs,'1424',a.c_codsbs,
                            '1425',a.c_codsbs,'1426',a.c_codsbs,'1428',a.c_codsbs,
                            '7111',a.c_codsbs,'7112',a.c_codsbs,'7113',a.c_codsbs,
                            '7114',a.c_codsbs,'7121',a.c_codsbs,'7122',a.c_codsbs,
                            '7123',a.c_codsbs,'7124',a.c_codsbs,'8113',a.c_codsbs,
                            '8123',a.c_codsbs,decode(substr(a.c_cuenta,1,6),
                            '811302',a.c_codsbs,'812302',a.c_codsbs,'721501',a.c_codsbs,
                            '721502',a.c_codsbs,'721503',a.c_codsbs,'721504',a.c_codsbs,
                            '721505',a.c_codsbs,'721506',a.c_codsbs,'721507',a.c_codsbs,
                            '722501',a.c_codsbs,'722502',a.c_codsbs,'722503',a.c_codsbs,
                            '722504',a.c_codsbs,'722505',a.c_codsbs,'722506',a.c_codsbs,
                            '722507',a.c_codsbs)) c_codsbs,decode(substr(a.c_cuenta,1,4),
                            '1411',b.c_desabr,'1413',b.c_desabr,'1414',b.c_desabr,
                            '1415',b.c_desabr,'1416',b.c_desabr,'1418',b.c_desabr,
                            '1421',b.c_desabr,'1423',b.c_desabr,'1424',b.c_desabr,
                            '1425',b.c_desabr,'1426',b.c_desabr,'1428',b.c_desabr,
                            '7111',b.c_desabr,'7112',b.c_desabr,'7113',b.c_desabr,
                            '7114',b.c_desabr,'7121',b.c_desabr,'7122',b.c_desabr,
                            '7123',b.c_desabr,'7124',b.c_desabr,'8113',b.c_desabr,
                            '8123',b.c_desabr,decode(substr(a.c_cuenta,1,6),
                            '811302',b.c_desabr,'812302',b.c_desabr,'721501',b.c_desabr,
                            '721502',b.c_desabr,'721503',b.c_desabr,'721504',b.c_desabr,
                            '721505',b.c_desabr,'721506',b.c_desabr,'721507',b.c_desabr,
                            '722501',b.c_desabr,'722502',b.c_desabr,'722503',b.c_desabr,
                            '722504',b.c_desabr,'722505',b.c_desabr,'722506',b.c_desabr,
                            '722507',b.c_desabr)) c_desemp,decode(substr(a.c_cuenta,1,4),
                            '1411',d.tp1desc,'1413',d.tp1desc,'1414',d.tp1desc,'1415',d.tp1desc,
                            '1416',d.tp1desc,'1418',d.tp1desc,'1421',d.tp1desc,'1423',d.tp1desc,
                            '1424',d.tp1desc,'1425',d.tp1desc,'1426',d.tp1desc,'1428',d.tp1desc,
                            '7111',d.tp1desc,'7112',d.tp1desc,'7113',d.tp1desc,'7114',d.tp1desc,
                            '7121',d.tp1desc,'7122',d.tp1desc,'7123',d.tp1desc,'7124',d.tp1desc,
                            '8113',d.tp1desc,'8123',d.tp1desc,decode(substr(a.c_cuenta,1,6),
                            '811302',d.tp1desc,'812302',d.tp1desc,'721501',d.tp1desc,
                            '721502',d.tp1desc,'721503',d.tp1desc,'721504',d.tp1desc,
                            '721505',d.tp1desc,'721506',d.tp1desc,'721507',d.tp1desc,
                            '722501',d.tp1desc,'722502',d.tp1desc,'722503',d.tp1desc,
                            '722504',d.tp1desc,'722505',d.tp1desc,'722506',d.tp1desc,
                            '722507',d.tp1desc)) c_destcr,decode(substr(a.c_cuenta,1,4),
                            '1411',to_char(e.rubro),'1413',to_char(e.rubro),'1414',to_char(e.rubro),
                            '1415',to_char(e.rubro),'1416',to_char(e.rubro),'1418',to_char(e.rubro),
                            '1421',to_char(e.rubro),'1423',to_char(e.rubro),'1424',to_char(e.rubro),
                            '1425',to_char(e.rubro),'1426',to_char(e.rubro),'1428',to_char(e.rubro),
                            '7111',to_char(e.rubro),'7112',to_char(e.rubro),'7113',to_char(e.rubro),
                            '7114',to_char(e.rubro),'7121',to_char(e.rubro),'7122',to_char(e.rubro),
                            '7123',to_char(e.rubro),'7124',to_char(e.rubro),'8113',to_char(e.rubro),
                            '8123',to_char(e.rubro),decode(substr(a.c_cuenta,1,6),
                            '811302',to_char(e.rubro),'812302',to_char(e.rubro),'721501',to_char(e.rubro),
                            '721502',to_char(e.rubro),'721503',to_char(e.rubro),'721504',to_char(e.rubro),
                            '721505',to_char(e.rubro),'721506',to_char(e.rubro),'721507',to_char(e.rubro),
                            '722501',to_char(e.rubro),'722502',to_char(e.rubro),'722503',to_char(e.rubro),
                            '722504',to_char(e.rubro),'722505',to_char(e.rubro),'722506',to_char(e.rubro),
                            '722507',to_char(e.rubro))) c_descta,decode(substr(a.c_cuenta,1,4),
                            '1411',a.n_diaatr,'1413',a.n_diaatr,'1414',a.n_diaatr,'1415',a.n_diaatr,
                            '1416',a.n_diaatr,'1418',a.n_diaatr,'1421',a.n_diaatr,'1423',a.n_diaatr,
                            '1424',a.n_diaatr,'1425',a.n_diaatr,'1426',a.n_diaatr,'1428',a.n_diaatr,
                            '7111',a.n_diaatr,'7112',a.n_diaatr,'7113',a.n_diaatr,'7114',a.n_diaatr,
                            '7121',a.n_diaatr,'7122',a.n_diaatr,'7123',a.n_diaatr,'7124',a.n_diaatr,
                            '8113',a.n_diaatr,'8123',a.n_diaatr,decode(substr(a.c_cuenta,1,6),
                            '811302',a.n_diaatr,'812302',a.n_diaatr,'721501',a.n_diaatr,
                            '721502',a.n_diaatr,'721503',a.n_diaatr,'721504',a.n_diaatr,
                            '721505',a.n_diaatr,'721506',a.n_diaatr,'721507',a.n_diaatr,
                            '722501',a.n_diaatr,'722502',a.n_diaatr,'722503',a.n_diaatr,
                            '722504',a.n_diaatr,'722505',a.n_diaatr,'722506',a.n_diaatr,
                            '722507',a.n_diaatr)) n_diaatr,decode(substr(a.c_cuenta,1,4),
                            '1411',a.n_salcap,'1413',a.n_salcap,'1414',a.n_salcap,'1415',a.n_salcap,
                            '1416',a.n_salcap,'1418',a.n_salcap,'1421',a.n_salcap,'1423',a.n_salcap,
                            '1424',a.n_salcap,'1425',a.n_salcap,'1426',a.n_salcap,'1428',a.n_salcap,
                            '7111',a.n_salcap,'7112',a.n_salcap,'7113',a.n_salcap,'7114',a.n_salcap,
                            '7121',a.n_salcap,'7122',a.n_salcap,'7123',a.n_salcap,'7124',a.n_salcap,
                            '8113',a.n_salcap,'8123',a.n_salcap,decode(substr(a.c_cuenta,1,6),
                            '811302',a.n_salcap,'812302',a.n_salcap,'721501',a.n_salcap,
                            '721502',a.n_salcap,'721503',a.n_salcap,'721504',a.n_salcap,
                            '721505',a.n_salcap,'721506',a.n_salcap,'721507',a.n_salcap,
                            '722501',a.n_salcap,'722502',a.n_salcap,'722503',a.n_salcap,
                            '722504',a.n_salcap,'722505',a.n_salcap,'722506',a.n_salcap,
                            '722507',a.n_salcap)) n_salcap,decode(substr(a.c_cuenta,1,4),
                            '1411',c.c_desabr,'1413',c.c_desabr,'1414',c.c_desabr,'1415',c.c_desabr,
                            '1416',c.c_desabr,'1418',c.c_desabr,'1421',c.c_desabr,'1423',c.c_desabr,
                            '1424',c.c_desabr,'1425',c.c_desabr,'1426',c.c_desabr,'1428',c.c_desabr,
                            '7111',c.c_desabr,'7112',c.c_desabr,'7113',c.c_desabr,'7114',c.c_desabr,
                            '7121',c.c_desabr,'7122',c.c_desabr,'7123',c.c_desabr,'7124',c.c_desabr,
                            '8113',c.c_desabr,'8123',c.c_desabr,decode(substr(a.c_cuenta,1,6),
                            '811302',c.c_desabr,'812302',c.c_desabr,'721501',c.c_desabr,
                            '721502',c.c_desabr,'721503',c.c_desabr,'721504',c.c_desabr,
                            '721505',c.c_desabr,'721506',c.c_desabr,'721507',c.c_desabr,
                            '722501',c.c_desabr,'722502',c.c_desabr,'722503',c.c_desabr,
                            '722504',c.c_desabr,'722505',c.c_desabr,'722506',c.c_desabr,
                            '722507',c.c_desabr)) c_descal
                       from cldrccs a
                       join ahtbanc b on (b.c_codefi = a.c_codemp) 
                                --and a.d_fecpre = ld_fecrcc 
                                --and b.c_codefi <> '00104')
                       join crtcali c on (c.c_codcal = a.c_calvig)
                       join fst198 d on (a.c_cretip = d.tp1corr2)
                       left join fsd014 e On (substr(a.c_cuenta,1,2) = substr(to_char(e.rubro),1,2) and
                                             (to_number(a.c_cuenta) / 10) = e.rubro)
                  where a.c_codsbs = ls_codsbs
                    and a.d_fecpre between ld_fecini and ld_fecrcc
                    and tp1cod = 1
                    and tp1cod1 = 10832
                    and tp1corr1 = 6)
          where c_codsbs is not null
          group by d_fecpre,c_cretip,c_codsbs,c_desemp,c_destcr,n_diaatr,c_descal,c_cretip,c_codemp
          order by d_fecpre,c_cretip,c_desemp) f, cldrcci g
    where substr(f.c_codsbs,1,10) = g.c_codsbs
      and f.d_fecpre = g.d_fecpre
    order by f.d_fecpre;
    begin
       ps_fecpro := '';
       ps_desemp := '';
       ps_tipcre := '';
       ps_diaatr := '';
       ps_descal := '';
       ps_salcap := '';
       ps_calif0 := '';
       ps_calif1 := '';
       ps_calif2 := '';
       ps_calif3 := '';
       ps_calif4 := '';
       ps_nument := '';
       ps_coderr := '00000';
       sp_ac_fecrcc(ld_fecrcc,ls_coderr,ls_msgerr);
       ps_fecrcc := to_char(ld_fecrcc,'DD/MM/YYYY');
       ls_codsbs := pq_ac_fun_agecom.fn_ac_codsbs(pn_tipdoc, trim(ps_numdoc));
       --ld_fecini := add_months(ld_fecrcc,-5);
       ld_fecini := add_months(ld_fecrcc,-11); --WCRW 07/06/2022 12 ultimos meses
       For x in c_rccdet Loop
          ps_fecpro := ps_fecpro || to_char(x.d_fecpre,'DD/MM/YYYY') || '||';
          ps_desemp := ps_desemp || trim(x.c_desemp) || '||';
          ps_tipcre := ps_tipcre || trim(x.c_destcr) || '||';
          ps_diaatr := ps_diaatr || trim(x.c_diaatr) || '||';
          ps_descal := ps_descal || trim(x.c_descal) || '||';
          ps_salcap := ps_salcap || trim(x.c_salcap) || '||';
          ps_calif0 := ps_calif0 || trim(x.c_calif0) || '||';
          ps_calif1 := ps_calif1 || trim(x.c_calif1) || '||';
          ps_calif2 := ps_calif2 || trim(x.c_calif2) || '||';
          ps_calif3 := ps_calif3 || trim(x.c_calif3) || '||';
          ps_calif4 := ps_calif4 || trim(x.c_calif4) || '||';
          ps_nument := ps_nument || trim(x.c_canent) || '||';
          ps_linusu := ps_linusu || to_char(pq_ac_fun_agecom.FN_AC_ENDRCC(substr(x.c_codsbs,1,10),x.c_cretip,x.c_codemp,x.d_fecpre),'fm999,999,990.90') || '||';
       End Loop; 
       if ps_desemp is null then
          ps_fecpro := 'NO EXISTE 999';
          ps_desemp := 'NO EXISTE 999';
          ps_tipcre := 'NO EXISTE 999';
          ps_diaatr := 'NO EXISTE 999';
          ps_descal := 'NO EXISTE 999';
          ps_salcap := 'NO EXISTE 999';
          ps_calif0 := 'NO EXISTE 999';
          ps_calif1 := 'NO EXISTE 999';
          ps_calif2 := 'NO EXISTE 999';
          ps_calif3 := 'NO EXISTE 999';
          ps_calif4 := 'NO EXISTE 999';
          ps_nument := 'NO EXISTE 999';
          ps_linusu := 'NO EXISTE 999';
          ps_coderr := '00099';
       end if;
    end;
  end SP_AC_DETRCCACU;
  
  procedure SP_AC_CONDETRCC(pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,
                            pn_conpai number,pn_tipcon number,ps_condoc varchar2,
                            ps_fecpro out varchar2,ps_desemp out varchar2,ps_tipcre out varchar2,
                            ps_diaatr out varchar2,ps_descal out varchar2,ps_salcap out varchar2,
                            ps_calif0 out varchar2,ps_calif1 out varchar2,ps_calif2 out varchar2,
                            ps_calif3 out varchar2,ps_calif4 out varchar2,ps_nument out varchar2, 
                            ps_feccon out varchar2,ps_conemp out varchar2,ps_concre out varchar2,
                            ps_conatr out varchar2,ps_concal out varchar2,ps_concap out varchar2,
                            ps_conca0 out varchar2,ps_conca1 out varchar2,ps_conca2 out varchar2,
                            ps_conca3 out varchar2,ps_conca4 out varchar2,ps_conent out varchar2,
                            ps_fecrcc out varchar2,ps_conrcc out varchar2,ps_linusu out varchar2,
                            ps_conusu out varchar2,ps_coderr out char,ps_msgerr out varchar2)
  is
  -- *****************************************************************
  -- Nombre                     : SP_AC_CONDETRCC
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 10/03/2017
  -- Autor de Creación          : WCRW
  -- Uso                        : Consulta Detalle RCC 6 Meses Titular / Conyugue
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
  ls_coderr varchar2(5);
  ls_msgerr varchar2(1000);
  Begin   
     SP_AC_DETRCCACU(pn_codpai,pn_tipdoc,ps_numdoc,ps_fecpro,ps_desemp,ps_tipcre,
                     ps_diaatr,ps_descal,ps_salcap,ps_calif0,ps_calif1,ps_calif2,
                     ps_calif3,ps_calif4,ps_nument,ps_fecrcc,ps_linusu,ls_coderr,ps_msgerr);
     if pn_conpai = 0 then
        ps_feccon := 'NO EXISTE 999';
        ps_conemp := 'NO EXISTE 999';
        ps_concre := 'NO EXISTE 999';
        ps_conatr := 'NO EXISTE 999';
        ps_concal := 'NO EXISTE 999';
        ps_concap := 'NO EXISTE 999';                
        ps_conusu := 'NO EXISTE 999';                
     else
        SP_AC_DETRCCACU(pn_conpai,pn_tipcon,ps_condoc,ps_feccon,ps_conemp,ps_concre,
                        ps_conatr,ps_concal,ps_concap,ps_conca0,ps_conca1,ps_conca2,
                        ps_conca3,ps_conca4,ps_conent,ps_conrcc,ps_conusu,ls_coderr,ps_msgerr);
     end if;      
     
  end SP_AC_CONDETRCC;
  
  procedure SP_AC_EVACLI2(ps_tipper varchar2,pn_codpai number,pn_tipdoc number,ps_numdoc varchar2,ps_tiprol varchar2,
                     ps_codrol varchar2,
                     ps_indcon out varchar2,ps_paicon out varchar2, ps_tipcon out varchar2,
                     ps_doccon out varchar2,ps_sbscli out varchar2, ps_sbscon out varchar2,
                     --ps_nomcli out varchar2,
                     ps_nomcon out varchar2,ps_clineg out varchar2,ps_conneg out varchar2,
                     ps_estsob out varchar2,ps_dessob out varchar2,ps_estrec out varchar2,
                     ps_desrec out varchar2,ps_nument out varchar2,ps_conent out varchar2,
                     ps_clijud out varchar2,ps_conjud out varchar2,ps_clicas out varchar2,
                     ps_concas out varchar2,ps_clinor out varchar2,ps_clicpp out varchar2,
                     ps_connor out varchar2,ps_concpp out varchar2,ps_calgen out varchar2,
                     ps_calcli out varchar2,ps_calcon out varchar2,ps_escosb out varchar2,
                     ps_decosb out varchar2,ps_segcli out varchar2,
                     ps_nomcli out varchar2,ps_dirdom out varchar2,ps_dirneg out varchar2,
                     ps_acteco out varchar2,ps_estcre out varchar2,ps_fecdes out varchar2,
                     ps_codana out varchar2,ps_codage out varchar2,ps_telcli out varchar2,
                     ps_refviv out varchar2,ps_refneg out varchar2,ps_ubicli out varchar2,
                     ps_ubineg out varchar2,ps_tipcli out varchar2,ps_numina out varchar2,
                     ps_crecon out varchar2,ps_descon out varchar2,ps_prosbs out varchar2,
                     ps_conpro out varchar2,ps_segcon out varchar2,ps_actcli out varchar2,
                     ps_actcon out varchar2,ps_tipcny out varchar2,ps_inacon out varchar2,
                     ps_fecnac out varchar2,ps_naccon out varchar2,ps_nomsec out varchar2,
                     pn_mondes out varchar2,ps_desmon out varchar2,ps_nomana out varchar2,
                     ps_anasol out varchar2,ps_sucsol out varchar2,ps_fecsol out varchar2,
                     --ps_vivcli out varchar2,ps_negcli out varchar2,
                     ps_despro out varchar2,ps_nomage out varchar2,ps_solvig out varchar2,
                     ps_coderr out char,ps_msgerr out varchar2) is
-- *****************************************************************
  -- Nombre                     : SP_AC_EVACLI2
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 18/03/2025
  -- Autor de Creación          : SGAMERO
  -- Uso                        : Evaluación de clientes obteniedno todos los parametros y guardando 
  --                              el resultado de la evaluación en la tabla ACDEVAL, se añade codrol
  -- Estado                     : Activo
  -- *****************************************************************

  ls_errcon char(5);
  ls_numdoc char(12);
  ln_numano number;
  ln_nummes number;
  ln_tipcon number;
  ln_paicon number;
  ln_numina number;
  ln_inacon number;
  ld_fecpro date;
  ln_codemp fsd010.pgcod%type;
  ln_codmod fsd010.aomod%type;
  ln_codage fsd010.aosuc%type;
  ln_codmon fsd010.aomda%type;
  ln_codpap fsd010.aopap%type;
  ln_codcta fsd010.aocta%type;
  ln_codope fsd010.aooper%type;
  ln_subope fsd010.aosbop%type;
  ln_tipope fsd010.aotope%type;
  ln_estado fsd010.aostat%type;
  ld_fecdes date;
  ld_feccan date;
  ln_mondes number(14,2);
  begin
     begin
       ps_indcon := 'N';
       ls_numdoc := trim(ps_numdoc);
       ps_calgen := '1';
       ps_calcli := '1';
       ps_calcon := '1';
       select to_number(to_char(pgfape,'yyyy')),
              to_number(to_char(pgfape,'mm'))
         into ln_numano,ln_nummes
         from FST017
        where pgcod=1;
       if ln_nummes = 1 then
          ln_nummes:=12;
          ln_numano:=ln_numano-1;
       else
          ln_nummes:=ln_nummes-1;
       end if;
       sp_ac_concli(pn_tipdoc,pn_codpai,ls_numdoc,ps_nomcon,ln_tipcon,ln_paicon,ps_doccon,ls_errcon,ps_msgerr);
       if ps_nomcon = 'NO EXISTE 999' then
              select  pq_ac_fun_agecom.fn_ac_nomper(ln_paicon,ln_tipcon,trim(ps_doccon)) into ps_nomcli from dual;
       end if;
       ps_tipcon := nvl(to_char(ln_tipcon),'NO EXISTE 999');
       ps_paicon := nvl(to_char(ln_paicon),'NO EXISTE 999');
       ps_nomcon := nvl(ps_nomcon,'NO EXISTE 999');
       ps_doccon := nvl(ps_doccon,'NO EXISTE 999');
       select pq_ac_fun_agecom.fn_ac_codsbs(pn_tipdoc,trim(ls_numdoc)),
              pq_ac_fun_agecom.fn_ac_segcli(pn_tipdoc,pn_codpai,trim(ls_numdoc)),
              --pq_ac_fun_agecom.fn_nomper(pn_codpai,pn_tipdoc,trim(ls_numdoc)),
              --pq_ac_fun_agecom.fn_dircli(pn_codpai,pn_tipdoc,trim(ls_numdoc),1),
              --pq_ac_fun_agecom.fn_dircli(pn_codpai,pn_tipdoc,trim(ls_numdoc),1)
              
              pq_ac_fun_agecom.fn_ac_procli(pn_codpai,pn_tipdoc,trim(ls_numdoc)),
              pq_ac_fun_agecom.fn_ac_actcli(pn_codpai,pn_tipdoc,trim(ls_numdoc))
         into ps_sbscli,ps_segcli,ps_prosbs,ps_actcli --ps_nomcli,ps_vivcli,ps_negcli
         from dual;
       ps_fecnac := '01/01/0001';  
       if ps_tipper = 'F' then
           select pq_ac_fun_agecom.fn_ac_fecnac(pn_codpai,pn_tipdoc,trim(ls_numdoc))
         into ps_fecnac
         from dual;
       end if;  
       sp_ac_lisneg(pn_tipdoc,pn_codpai,ls_numdoc,ps_clineg,ps_coderr,ps_msgerr);
       sp_ac_clisob(pn_codpai,pn_tipdoc,ls_numdoc,ps_estsob, ps_dessob,ps_coderr,ps_msgerr);
       --sp_clirec(ls_numdoc,sysdate,'P',ps_estrec,ps_desrec,ps_coderr,ps_msgerr);
       sp_ac_clirec2 (ps_numdoc,pn_tipdoc,sysdate,ps_codrol,ps_tipcli,ln_numina,ps_estrec,ps_desrec);
              
       select pq_ac_fun_agecom.fn_ac_nument(trim(ps_sbscli)),
              pq_ac_fun_agecom.fn_ac_indjud(pn_codpai,pn_tipdoc,ls_numdoc),
              pq_ac_fun_agecom.fn_ac_indcas(pn_codpai,pn_tipdoc,ls_numdoc)
         into ps_nument,ps_clijud,ps_clicas
         from dual;
       sp_ac_indcal(trim(ps_sbscli),ps_clinor,ps_clicpp,ps_coderr,ps_msgerr);
       if ps_clineg = 'S' or 
          ps_estsob = 'S' or 
         (ps_estrec = 'S' and ps_nument>5) or 
         (ps_estrec = 'N' and ps_nument>4) or
          ps_clijud = 'S' or
          ps_clicas = 'S'
           then
         ps_calcli := '3';
        end if;
       if ps_doccon <> 'NO EXISTE 999' then
           ps_naccon := '01/01/0001';
           ps_indcon := 'S';
           select pq_ac_fun_agecom.fn_ac_codsbs(ps_tipcon,ps_doccon),
                  pq_ac_fun_agecom.fn_ac_nomper(ps_paicon,ps_tipcon,trim(ps_doccon)),
                  pq_ac_fun_agecom.fn_ac_procli(ps_paicon,ps_tipcon,trim(ps_doccon)),
                  pq_ac_fun_agecom.fn_ac_segcli(ps_tipcon,ps_paicon,trim(ps_doccon)),
                  pq_ac_fun_agecom.fn_ac_actcli(ps_paicon,pn_tipdoc,trim(ps_doccon)),
                  pq_ac_fun_agecom.fn_ac_fecnac(ps_paicon,pn_tipdoc,trim(ps_doccon))
             into ps_sbscon,ps_nomcon ,ps_conpro,ps_segcon,ps_actcon,ps_naccon
             from dual;
           --Falta validar si no existe conyugue bantotal o RCC no hacer llamado a funciones  
           sp_ac_lisneg(ps_tipcon,ps_paicon,ps_doccon,ps_conneg,ps_coderr,ps_msgerr);
           select pq_ac_fun_agecom.fn_ac_nument(trim(ps_sbscon)),
                  pq_ac_fun_agecom.fn_ac_indjud(ps_paicon,ps_tipcon,ps_doccon),
                  pq_ac_fun_agecom.fn_ac_indcas(ps_paicon,ps_tipcon,ps_doccon)
             into ps_conent,ps_conjud,ps_concas
             from dual;
           sp_ac_clisob(ps_paicon,ps_tipcon,ps_doccon,ps_escosb,ps_decosb,ps_coderr,ps_msgerr); 
           sp_ac_estcre(ps_tipcon,ps_paicon,ps_doccon,ps_crecon,ps_descon,ps_coderr,ps_msgerr);   
           --sp_clirec (ps_doccon,ps_tipcon,sysdate,ps_tipcny,ln_inacon);   
           sp_ac_clirec2 (ps_doccon,ps_tipcon,sysdate,ps_codrol,ps_tipcny,ln_inacon,ps_estrec,ps_desrec);
           ps_tipcny:= trim(ps_tipcny);
           ps_inacon:= to_char(ln_inacon); 
           sp_ac_indcal(trim(ps_sbscon),ps_connor,ps_concpp,ps_coderr,ps_msgerr);
           if ps_conneg = 'S' or
              ps_conjud = 'S' or
              ps_concas = 'S' or 
              ps_escosb = 'S' then
              ps_calcon:= '3';
           end if;
         if (ps_indcon='S' and ps_calcon = '1' and ps_connor = 'S' )then
             if ps_concpp = 'N' then
                ps_calcon:='2';
             else
                ps_calcon:='3';
             end if;
         end if;
       else 
         ps_calcon := '0';
         ps_sbscon := 'NO EXISTE 999';
         ps_nomcon := 'NO EXISTE 999';
         ps_conent := 0;
         ps_conjud := 'N';
         ps_concas := 'N';
         ps_conneg := 'N';
         ps_escosb := 'N';
         ps_decosb :='NO EXISTE 999';
         ps_connor := 'N';
         ps_concpp := 'N';
         ps_crecon := 'N';
         ps_descon := 'N';
         ps_conpro := 'NO EXISTE 999';
         ps_segcon := 'NO EXISTE 999';
         ps_actcon := 'NO EXISTE 999';
       end if;
       if (ps_calcli = '1' and ps_clinor = 'S' )then --Revision
          if  ps_clicpp = 'N' then
              ps_calcli:='2';
          else
              ps_calcli:='3';
          end if;
       end if;
       
       if ps_calcli > ps_calcon then
          ps_calgen:= ps_calcli;
       else
          ps_calgen:= ps_calcon;
       end if;
       if ps_calcon = '0' then
          ps_calcon:= 'NO EXISTE 999';
       end if;    
     ld_fecpro := pq_ac_fun_agecom.fn_ac_fecsis(1);
     sp_ac_clicaj(ps_tipper,pn_tipdoc,pn_codpai,ps_numdoc,ps_nomcli,ps_coderr,ps_msgerr);
     if ps_nomcli = 'NO EXISTE 999' then
        select pq_ac_fun_agecom.fn_ac_nomper(pn_codpai,pn_tipdoc,trim(ps_numdoc)) into ps_nomcli from dual;
     else
        SP_AC_DATCRE(pn_tipdoc,pn_codpai,trim(ps_numdoc),ld_fecpro,ln_codemp,ln_codmod,
                    ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,ln_subope,
                    ln_tipope,ln_estado,ld_fecdes,ld_feccan,ln_mondes,ps_coderr,ps_msgerr);
        pn_mondes := to_char(ln_mondes,'99999999999.99');             
        if ps_coderr <> '00011' then
           ps_despro := pq_ac_fun_agecom.fn_ac_nompro(ln_codmod);
           ps_desmon := pq_ac_fun_agecom.fn_ac_desmon(ln_codmon);
           ps_nomage := pq_ac_fun_agecom.fn_ac_nomage(ln_codage);
           ps_nomana := nvl(fn_analista_credito(ln_codmod,ln_codage,ln_codmon,ln_codpap,ln_codcta,ln_codope,ln_subope,ln_tipope),'999');   
           if trim(ps_nomana) = '999'  then
              ps_nomana := 'NO EXISTE 999';
           end if;   
         else
           pn_mondes := '0.00';
           ps_despro := 'NO EXISTE 999';
           ps_desmon := 'NO EXISTE 999';
           ps_nomage := 'NO EXISTE 999';
           ps_nomana := 'NO EXISTE 999';
        end if;   
     end if;      
     select pq_ac_fun_agecom.fn_ac_nomact(pn_codpai,pn_tipdoc,trim(ps_numdoc)),
            pq_ac_fun_agecom.fn_ac_telcli(pn_codpai,pn_tipdoc,trim(ps_numdoc)),
            pq_ac_fun_agecom.fn_ac_nomsec(pn_codpai,pn_tipdoc,trim(ps_numdoc))           
       into ps_acteco,ps_telcli,ps_nomsec
       from dual;
     sp_ac_estcre(pn_tipdoc,pn_codpai,ps_numdoc,ps_estcre,ps_fecdes,ps_coderr,ps_msgerr);
     sp_ac_anaage(pn_tipdoc,pn_codpai,ps_numdoc,ps_codana,ps_codage,ps_coderr,ps_msgerr);
     sp_ac_dircli(pn_codpai,pn_tipdoc,ps_numdoc,1,ps_refviv,ps_dirdom,ps_ubicli);
     sp_ac_dircli(pn_codpai,pn_tipdoc,ps_numdoc,3,ps_refneg,ps_dirneg,ps_ubineg);
     --sp_clirec (ps_numdoc,pn_tipdoc,sysdate,ps_tipcli,ln_numina); ---
     ps_tipcli:= trim(ps_tipcli);
     ps_numina:=to_char(ln_numina);
     SP_AC_CONCREPRO(pn_codpai,pn_tipdoc,ps_numdoc,ps_solvig,ps_anasol,ps_sucsol,ps_fecsol,ps_coderr,ps_msgerr);
    --Estaba el Insert
    exception
    when no_data_found then
             ps_coderr := '00011';
             ps_msgerr := 'NO HAY DATOS';
    when        others then
             ps_coderr := '00099';
             ps_msgerr := SQLERRM;
     end;
end SP_AC_EVACLI2;

procedure SP_AC_CLIREC2(ps_numdoc in varchar2, ps_tipdoc in varchar2,pd_fecpro in date,
                     ps_codrol varchar2,
                     ps_tipcli out char, ps_numina out integer,ps_estrec out varchar2,
                     ps_desrec out varchar2) is
  -- *****************************************************************
  -- Nombre                     : SP_AC_CLIREC2
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 18/03/2025
  -- Autor de Creación          : EBDC
  -- Uso                        : Retorna el tipo de cliente, días de inactividad.
  -- Estado                     : Activo
  -- *****************************************************************
  ln_crecan number(4);
  ln_crevig number(4);
  ld_feccan date;
  ls_numdoc char(12);
  ls_doccon char(12);
  begin
    begin
       ls_numdoc := trim(ps_numdoc);
       begin
         select r.rpndoc into ls_doccon from fsr002 r where r.pendoc = ls_numdoc and rpccyg = 66;
         exception 
           when no_data_found then
             ls_doccon := ' ';
           when others then
             ls_doccon := ' ';
       end;
        select count(case 
                        when d.aostat = 99 and d.aofe99<=pd_fecpro then 1 
                     end) n_crecan,
               count(case 
                        when d.aostat <> 99 or (d.aostat = 99 and d.aofe99>pd_fecpro) then 1 
                     end) n_crevig,
               max(d.aofe99) d_maxcan
          into ln_crecan,ln_crevig,ld_feccan
          from fsr008 r 
          join fsd010 d on d.pgcod = r.pgcod
                       and d.aocta = r.ctnro
                       and d.aomod in (
                               select modulo 
                                 from fst111 
                                 where dscod = 50 
                                   --and modulo not in (29,120) 
                                 union all 
                               select 117 
                                 from dual
                                 )
                       and r.ttcod = 1 --Sólo titular representativo 2017.01.03
                       and r.cttfir = 'T' --Sólo titular representativo 2017.01.03
         --where trim(r.pendoc) in (ls_tmpdoc,ls_tmpcon) --Se evalúa también al cónyuge 2017.01.03
         where r.pendoc in (ls_numdoc,ls_doccon) --Se evalúa también al cónyuge 2017.01.03
           and r.petdoc = ps_tipdoc
           and d.aofval < pd_fecpro;
     exception 
     when others then
       ln_crecan := 0;
       ln_crevig := 0;
       ld_feccan := null;
    end;
    
   if ps_codrol = '101' or ps_codrol='105' then
       if ln_crevig = 0 and  ln_crecan>0 and pd_fecpro - ld_feccan >=30 then
          ps_tipcli:= '3';
          ps_numina:= pd_fecpro - ld_feccan;
          ps_estrec:= 'N';
          ps_desrec:= 'I';
       elsif ln_crevig = 0 and  ln_crecan>0 and pd_fecpro - ld_feccan<30 then
          ps_tipcli:= '2';
          ps_numina:= pd_fecpro - ld_feccan;
          ps_estrec:= 'S';
          ps_desrec:= 'R';
       elsif ln_crevig = 0 and ln_crecan = 0 then
          ps_tipcli:= '1';
          ps_numina:= 0;
          ps_estrec:= 'N';
          ps_desrec:= 'N';
       elsif ln_crevig >0  then
          ps_tipcli:= '2';
          ps_numina:= 0;
          ps_estrec:= 'S';
          ps_desrec:= 'R';
       end if;
    else
      if ln_crevig = 0 and  ln_crecan>0 and pd_fecpro - ld_feccan >=90 then
          ps_tipcli:= '3';
          ps_numina:= pd_fecpro - ld_feccan;
          ps_estrec:= 'N';
          ps_desrec:= 'I';
      elsif ln_crevig = 0 and  ln_crecan>0 and pd_fecpro - ld_feccan<90 then
          ps_tipcli:= '2';
          ps_numina:= pd_fecpro - ld_feccan;
          ps_estrec:= 'S';
          ps_desrec:= 'R';
      elsif ln_crevig = 0 and ln_crecan = 0 then
          ps_tipcli:= '1';
          ps_numina:= 0;
          ps_estrec:= 'N';
          ps_desrec:= 'N';
      elsif ln_crevig >0  then
          ps_tipcli:= '2';
          ps_numina:= 0;
          ps_estrec:= 'S';
          ps_desrec:= 'R';
      end if;
    end if;
    
    if (ps_numina<0) then
      ps_numina:= 0;
    end if;
      
  exception
  when no_data_found then
           ps_estrec := '1';
  when        others then
           ps_estrec := '1';
end SP_AC_CLIREC2;
  
end PQ_AC_CONSULTAS_AGECOM;
/
