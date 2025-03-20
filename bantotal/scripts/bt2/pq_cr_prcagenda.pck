create or replace package PQ_CR_PRCAGENDA is

  -- Author  : LLLOSA
  -- Created : 15/03/2017 05:10:55 p.m.
  -- Purpose : 02/06/2017
  Procedure Sp_CargaBase ;
  Procedure sp_datos_cliente (pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2,
                            pd_fecnac out date, pc_genero out varchar2 , pc_email out varchar2, 
                            pc_telef out varchar2, pn_codseg out number, pc_desseg out varchar2);
  procedure sp_Datos_Cre (pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2,pn_estado in number,
                        pd_feccan out date, pn_mtocr out number, pn_moneda out number);
                          
  Procedure sp_datos_direccion (pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2,pn_tipo in number,
                                pn_dist out number, pn_provin out number, pn_dpto out number, pn_codubi out number,
                                pc_direcc out varchar2);
  Procedure sp_lat_Long (pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2,pn_tipo in number,
                         pc_latitu out varchar2, pc_longit out varchar2);
  
  
  Procedure Sp_CargaTabla(P_C_IDCONX IN VARCHAR2,
                          P_C_CODUSU IN VARCHAR2,
                          P_N_CODBAS IN NUMBER,
                          P_N_CODACT IN NUMBER,
                          --
                          P_N_CODSEG IN NUMBER, -- Codigo segmento 
                          P_N_RMTODES IN NUMBER, -- Rango Monto Desembolsado
                          P_C_NOMBRE IN VARCHAR2, -- Nombre Cliente
                         /* P_N_DPTO   IN NUMBER, -- Departamento
                          P_N_PROV   IN NUMBER, -- Provincia
                          P_N_DIST   IN NUMBER, -- Distrito*/
                          P_C_CODUBI IN NUMBER --Codigo Ubigueo
                          ); 
  procedure sp_lista_resultado;
  
  procedure sp_reg_resultado(ps_codpai in number  ,ps_tipdoc in number, ps_numdoc varchar2,
                           ps_codusu in varchar2,ps_codres varchar2, ps_desobs varchar2,
                           ps_codvis varchar2,ps_codtas varchar2, ps_codser varchar2,
                           ps_codate varchar2,ps_otrres varchar2 );
                                                                                                                                                                                                                                     
end PQ_CR_PRCAGENDA;
/

create or replace package body PQ_CR_PRCAGENDA is
Procedure Sp_CargaBase is
 
 BEGIN 
   EXECUTE IMMEDIATE ('TRUNCATE TABLE JAQL130');
 
   INSERT INTO JAQL130 ( JAQL130CBAS, JAQL130CACT, JAQL130DBAS)
   select NCODBAS , NCODACT , 
          CASE WHEN NCODBAS = 4 THEN 'POR CANCELAR' 
               WHEN NCODBAS = 7 THEN 'REFERIDOS'
               ELSE CNOMACT END 
    from AcTBASE
   WHERE NCODBAS IN (1,4,7)
     AND NCODACT = 1
   union all
   select 99,1,'CUMPLEAÑOS' FROM DUAL  ;      
   EXCEPTION
     WHEN OTHERS THEN NULL;
                       
end;                        
Procedure sp_datos_cliente (pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2,
                            pd_fecnac out date, pc_genero out varchar2 , pc_email out varchar2, 
                            pc_telef out varchar2, pn_codseg out number, pc_desseg out varchar2) is 
-- pn_tipo = 1 Legal 3(NEgocio)
ld_fecnac date;
lc_genero varchar2(2);
lc_email varchar2(300);
lv_pendoc2 char(12);
lv_telefonos varchar2(50);
lc_desseg varchar2(50);
ln_codseg varchar2(50);

cursor c_tele_pers is
   select Dotelfp
     from Fsr005
    Where Pepais = pn_pais
      and Petdoc = pn_tipdoc
      and Pendoc = lv_pendoc2
      and Docod  = 1;
      
cursor email_pers is 
  select pextxt
   into lc_email
   from fsx001 
  where pepais = pn_pais
    and petdoc = pn_tipdoc
    and pendoc = lv_pendoc2
    and txcod  in (0,202)
    and pexren = 1;

            
begin
   lv_pendoc2 := TRIM(pc_numdoc);
   -- email
   BEGIN
      for j in email_pers  loop
          lc_email := lc_email || trim(j.pextxt);
      end loop;
      lc_email := substr(lc_email, 1, length(lc_email));
   EXCEPTION
      when others then
         lc_email := null;
   end;
   
   -- Telefono
  BEGIN
      for i in c_tele_pers  loop
          lv_telefonos := lv_telefonos || trim(i.Dotelfp)|| '|';
      end loop;
      lv_telefonos := substr(lv_telefonos, 1, length(lv_telefonos) - 1);
  EXCEPTION
    when others then
         lv_telefonos := null;
  end; 
  --   
  -- Cumpleaños
  begin 
      select pffnac , pfcant 
        into ld_fecnac, lc_genero
        from fsd002 
       where PFPAIS = pn_pais
         and PFTDOC = pn_tipdoc
         and PFNDOC = lv_pendoc2;
  exception
     when others then
        ld_fecnac := null;
        lc_genero := null;
  end;   
  -- Segmento
   begin 
     select t.segcod, d.segnom       
        into ln_codseg, lc_desseg
        from sngc60 s , sngc07 t, fst041 d
       where s.sngc60pais = pn_pais
         and s.sngc60tdoc = pn_tipdoc
         and s.sngc60ndoc = lv_pendoc2
         and s.sngc60ocup = t.sngc07cod
         and t.segcod = d.segcod;
         
  exception
     When too_many_rows then
       select segcod,segnom 
         into ln_codseg, lc_desseg
       from (select t.segcod, d.segnom,
                    dense_rank() over(order by s.sngc60corr desc nulls last) n_priori              
               from sngc60 s , sngc07 t, fst041 d
              where s.sngc60pais  = pn_pais
                and s.sngc60tdoc  = pn_tipdoc
                and s.sngc60ndoc  = lv_pendoc2
                and s.sngc60ocup = t.sngc07cod
                and t.segcod = d.segcod)
        where n_priori = 1;
     when others then
        ln_codseg := null;
        lc_desseg := null;
  end;   
 /* if trim(lc_email) is null then  
     lc_email := 'lllosar@hotmail.com';
  end if;*/
  --              
     pd_fecnac := ld_fecnac;
     pc_genero := lc_genero;
     pc_email  := lc_email;
     pc_telef  := lv_telefonos;
     pn_codseg := ln_codseg;
     pc_desseg := lc_desseg;
 end;
Procedure sp_datos_direccion (pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2,pn_tipo in number,
                              pn_dist out number, pn_provin out number, pn_dpto out number, pn_codubi out number,
                              pc_direcc out varchar2) is 
-- pn_tipo = 1 Legal 3(NEgocio)
ln_dis     sngc13.sngc13dist%type; 
ln_provin  sngc13.sngc13prov%type;
ln_dpto    sngc13.sngc13dpto%type;
lc_codubi  sngc13.sngc13ugeo%type;
lc_direcc  sngc13.sngc13dir%type;
lv_pendoc2 fsd001.pendoc%type;
begin
  lv_pendoc2 := pc_numdoc;
  begin
  select sngc13dist,sngc13prov,sngc13dpto,sngc13ugeo,
         sngc13dir--, sngc13ref,sngc13ref1
    into ln_dis,ln_provin,ln_dpto, lc_codubi,
         lc_direcc
    from sngc13 aa
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tipdoc
     and aa.sngc13ndoc = lv_pendoc2
     and aa.docod = pn_tipo
     and aa.sngc13corr < 500;
     
  exception 
      when no_data_found then 
         ln_dis    := null;
         ln_provin := null;
         ln_dpto   := null;
         lc_codubi := null;
         lc_direcc := null;
      when too_many_rows then
         begin
        select sngc13dist,sngc13prov,sngc13dpto,sngc13ugeo,
               sngc13dir--, sngc13ref,sngc13ref1
          into ln_dis,ln_provin,ln_dpto, lc_codubi,
               lc_direcc
          from sngc13 aa
         where aa.sngc13pais = pn_pais
           and aa.sngc13tdoc = pn_tipdoc
           and aa.sngc13ndoc = lv_pendoc2
           and aa.docod = pn_tipo
           and aa.sngc13corr < 500
           and aa.sngc13est = 'H'
           and rownum = 1;
        exception 
            when no_data_found then 
               ln_dis    := null;
               ln_provin := null;
               ln_dpto   := null;
               lc_codubi := null;
               lc_direcc := null;
           end;   
     end;   
     pn_dist   := ln_dis;
     pn_provin := ln_provin;
     pn_dpto   := ln_dpto;
     pn_codubi := lc_codubi;
     pc_direcc := lc_direcc;
 end;
 
 Procedure sp_lat_Long (pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2,pn_tipo in number,
                        pc_latitu out varchar2, pc_longit out varchar2) is 
-- pn_tipo = 1 Legal 3(NEgocio)

lc_latitu varchar2(140);
lc_longit varchar2(140);
lv_pendoc2 fsd001.pendoc%type;
--ln_ran number;
begin
  lv_pendoc2 := pc_numdoc;
  begin
  select sngc13ref,sngc13ref1
    into lc_latitu, lc_longit
    from sngc13 aa
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tipdoc
     and aa.sngc13ndoc = lv_pendoc2
     and aa.docod = pn_tipo
     and aa.sngc13corr = 500;
     
  exception 
      when no_data_found then 
         lc_latitu := null;
         lc_longit := null;
      when too_many_rows then
         begin
        select sngc13ref,sngc13ref1
          into lc_latitu, lc_longit
          from sngc13 aa
         where aa.sngc13pais = pn_pais
           and aa.sngc13tdoc = pn_tipdoc
           and aa.sngc13ndoc = lv_pendoc2
           and aa.docod = pn_tipo
           and aa.sngc13corr = 500
           and rownum = 1;
        exception 
            when no_data_found then 
              lc_latitu := null;
              lc_longit := null;
           end;   
     end;   
     /*if lc_latitu is null then 
        select round(dbms_random.value(-1.0,-2.0),7) 
          into ln_ran
          from dual;
        lc_latitu := -16.4244759 + ln_ran;
        lc_longit := -71.5331058 + ln_ran;
     end if;    */
     pc_latitu := lc_latitu;
     pc_longit := lc_longit;
 end;

procedure sp_Datos_Cre (pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2,pn_estado in number,
                        pd_feccan out date, pn_mtocr out number, pn_moneda out number) is 

ld_feccan date;
ln_mtocr  number;
ln_moneda varchar2(20);
lv_pendoc2 fsd001.pendoc%type;
BEGIN
begin
  lv_pendoc2 := pc_numdoc;
  if pn_estado = 99 then 
      select aofe99, aoimp,aomda--decode(aomda,0,'S/.','USD') 
        into ld_feccan, ln_mtocr, ln_moneda 
        from (
              select dense_rank() over(order by c.aostat, c.aofe99 desc nulls last) n_priori,
                     c.aofe99, c.aoimp, c.aomda, c.aocta, c.aooper , c.aostat
                from fsd010 c, fsr008 b 
               where b.pepais = pn_pais
                 and b.petdoc = pn_tipdoc
                 and b.pendoc = lv_pendoc2
                 and b.cttfir ='T'
                 and c.pgcod = 1
                 and c.aocta = b.ctnro
                 and c.aomod in (select modulo from fst111 where dscod =50 and modulo not in (120,29,144))
                 and c.aostat = pn_estado)
      where  n_priori = 1;
  else -- Por cancelar
     select aofvto, aoimp,aomda --decode(aomda,0,'S/.','USD') 
       into ld_feccan, ln_mtocr, ln_moneda 
        from (
              select dense_rank() over(order by c.aostat, c.aofvto desc nulls last) n_priori,
                     c.aofvto, c.aoimp, c.aomda, c.aocta, c.aooper , c.aostat
                from fsd010 c, fsr008 b 
               where b.pepais = pn_pais
                 and b.petdoc = pn_tipdoc
                 and b.pendoc = lv_pendoc2
                 and b.cttfir ='T'
                 and c.pgcod = 1
                 and c.aocta = b.ctnro
                 and c.aomod in (select modulo from fst111 where dscod =50 and modulo not in (120,29,144))
                 and c.aostat <> 99)
      where  n_priori = 1;
  end if;    
exception 
  when others then 
      ld_feccan := null;
      ln_mtocr  := null;
      ln_moneda := null;
END;
 pd_feccan := ld_feccan;
 pn_mtocr  := NVL(ln_mtocr,0);
 pn_moneda := ln_moneda;
      
end;  
                  
                        
Procedure Sp_CargaTabla(P_C_IDCONX IN VARCHAR2,
                        P_C_CODUSU IN VARCHAR2,
                        P_N_CODBAS IN NUMBER,
                        P_N_CODACT IN NUMBER,
                        --
                        P_N_CODSEG IN NUMBER, -- Codigo segmento 
                        P_N_RMTODES IN NUMBER, -- Rango Monto Desembolsado
                        P_C_NOMBRE IN VARCHAR2, -- Nombre Cliente
                       /* P_N_DPTO   IN NUMBER, -- Departamento
                        P_N_PROV   IN NUMBER, -- Provincia
                        P_N_DIST   IN NUMBER, -- Distrito*/
                        P_C_CODUBI IN NUMBER --Codigo Ubigueo
                        )is

cursor Agenda (ln_coding in number) is
 select A.NCODING , A.NCODACT , A.NCODBAS , A.NPAICLI , A.NTIPDOC ,
       A.CNUMDOC , upper(A.CCLINOM)CCLINOM , A.CCODSBS , 
       A.CZONFIJ , A.CDIRFIJ , A.CZONNEG , 
       A.CDIRNEG , A.CTELMOV , A.CSEGCLI , 
       A.NCODAGE , A.NCODANA , A.CUSUING , B.ccodusu,
       A.CNOMSEC , B.ncorcli, C.ncorasi, c.dfecvis
 from ACDEVAL A, AcDasig  B, AcDagen C
   WHERE A.CCODCAL IN (1, 2) -- caLIFICACION FINAL 1 APROBADO 2 REQUIERE ANALISTA acdatri NCODTAB =5
     AND A.NINDCIER = 0
     AND A.NCODING = ln_coding
     AND A.NCODACT = P_N_CODACT
     AND A.NCODBAS = P_N_CODBAS --REFERIDOS
     and trim(B.ccodusu)  = P_C_CODUSU
     AND A.ncorcli = B.ncorcli
     AND B.ncorasi = C.ncorasi (+);

cursor cumple (ln_suc in number, ln_tica in number, lc_codusu IN VARCHAR2 )is 
select PGCOD, SCSUC,  SCCTA, max(SCFVTO)SCFVTO, sum(decode(scmda,0,SCSDO,SCSDO*ln_tica)) scsdo, pepais, petdoc, pendoc,analista
  from (select a.PGCOD, a.SCSUC, a.SCMDA, a.SCCTA, a.SCFVTO, a.SCSDO, b.pepais, b.petdoc, b.pendoc,
               fn_analista_credito(Scmod,Scsuc,Scmda,Scpap,Sccta,Scoper,Scsbop,Sctope) analista
          from fsd011 a, fsr008 b, fsd002 c
         where a.pgcod = 1
           and a.scrub in
               (select rubro
                  from fsd014 d
                 where pcimpu = 'S'
                   and pmtit= 1
                   and pcnivc in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (29, 33, 120, 144, 200)))
           and a.scstat <> 99
           and a.scsuc = ln_suc              
           and a.scmod in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (29, 33, 120, 144, 200))
           and a.scsdo <> 0
           and a.pgcod = b.pgcod
           and a.sccta = b.ctnro
           and b.cttfir = 'T'
           and to_char(pffnac,'mmdd') in ( to_char(trunc(sysdate),'mmdd'),
           to_char(trunc(sysdate + 1),'mmdd'))
           and b.pepais = c.pfpais
           and b.petdoc = c.pftdoc
           and b.pendoc = c.pfndoc
           )
 where trim(analista) = lc_codusu 
 group by PGCOD, SCSUC, SCCTA, pepais, petdoc, pendoc,analista;
 /*select PGCOD, SCSUC, SCCTA, SCFVTO, (decode(scmda,0,SCSDO,SCSDO*ln_tica)) scsdo, 
        a.pfpais pepais,a.pftdoc petdoc, a.pfndoc pendoc, lc_codusu analista
   from fsd002 a, sng001 b, fsd011 c where to_char(pffnac,'mmdd') in ( to_char(trunc(sysdate),'mmdd'),
        to_char(trunc(sysdate + 1),'mmdd'))
    and trim(sng001ase) = lc_codusu
    and b.sng001pais = a.pfpais
    and b.sng001tdoc = a.pftdoc
    and b.sng001ndoc = a.pfndoc
    and c.pgcod = 1
    and c.scsuc = ln_suc
    and c.sccta = b.sng001cta
    and c.scrub in (select rubro
                      from fsd014 d
                     where pcimpu = 'S'
                       and pmtit= 1
                       and pcnivc in
                           (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (29, 33, 120, 144, 200)))
    and c.scstat <> 99;*/
 -- pOR cANCELAR
 cursor cancelado (ln_suc in number, ln_tica in number, lc_codusu IN VARCHAR2 ) is 
 select c.PGCOD, SCSUC, SCCTA, SCFVTO, (decode(scmda,0,SCSDO,SCSDO*ln_tica)) scsdo, d.pepais pepais, 
        d.petdoc petdoc, d.pendoc pendoc, lc_codusu analista,
        fn_analista_credito(scmod,scsuc,scmda,scpap,sccta,
                                     scoper,scsbop,sctope)
   from fsd011 c, fsr008 d
  where c.pgcod = 1
    and c.scsuc = ln_suc
    and c.scrub in   (select rubro
                        from fsd014 d
                       where pcimpu = 'S'
                         and pmtit = 1
                         and pcnivc in (select modulo
                                          from fst111
                                         where dscod = 50
                                           and modulo not in (29, 33, 120, 144, 200)))
    and c.scstat not in (99, 90, 64)
    and c.scfvto between trunc(sysdate) and ADD_MONTHS(trunc(sysdate), 2)
    and d.pgcod = c.pgcod
    and d.ctnro = c.sccta
    and d.cttfir = 'T'
    and trim(fn_analista_credito(scmod,scsuc,scmda,scpap,sccta,
                             scoper,scsbop,sctope)) = lc_codusu;
  
ld_fecpro date :=null;
ld_feccan date;
ln_mtocr  number;
lc_moneda varchar2(20);
ln_moneda number;
ln_ncoding number;
ln_estado number;
--
ln_latdir SNGC13.sngc13ref%TYPE;
ln_londir SNGC13.sngc13ref1%TYPE;
ln_latneg SNGC13.sngc13ref%TYPE;
ln_lonneg SNGC13.sngc13ref1%TYPE;
lc_email  varchar2(100);
lc_dirleg varchar2(200);
lc_dirneg varchar2(200);
ln_ubileg number;
ln_ubineg number;
lc_telefo varchar2(100);
lc_genero varchar2(1);
ld_feccum date;
ln_distl  number;
ln_provinl number;
ln_dptol number;
ln_distn  number;
ln_provinn number;
ln_dpton number;
lc_inserta varchar2(1);
--ln_cosseg number;
ln_rango number;
ln_mtosol number;
ln_tipcam number;
ln_codseg number;
lc_desseg varchar2(50);
lc_dtipdo varchar2(50);
lc_pais  varchar2(50);
ln_codsuc number;
lc_nombre fsd001.penom%type;
lc_texto varchar2(300);
 begin
    if p_n_codbas = 7 then 
       ln_ncoding := 3;
    else 
       ln_ncoding := 1;  
    end if;   
    begin
       select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
    end;
    
    ln_tipcam := fn_tipo_cambio_fijo(ld_fecpro);
  
    delete from JAQL131
     where JAQL131IDC = P_C_IDCONX
       and TRIM(JAQL131USU) = P_C_CODUSU/*
       and JAQL131CBA = P_N_CODBAS
       and JAQL131CAC = P_N_CODACT
       and JAQL131CIN = ln_ncoding*/;
    commit;
   
  -- Identifica consulta-
    if P_N_CODBAS = 99 then -- = '1' then -- Cumpleaños 
        begin 
          select ubsuc 
            into ln_codsuc
            from fst046 
           where trim(ubuser) = P_C_CODUSU;
        exception
          when others then 
            null;
        end;
        
         for j in cumple (ln_codsuc,ln_tipcam, p_c_codusu ) loop
            pq_cr_prcagenda.sp_datos_cliente(j.pepais, j.petdoc,j.pendoc, 
            ld_feccum, lc_genero, lc_email, lc_telefo, ln_codseg, lc_desseg);
            /*if to_number(to_char(ld_feccum, 'ddmm')) in
              (to_number(to_char(trunc(sysdate), 'ddmm')),
               to_number(to_char(trunc(sysdate + 1), 'ddmm')))  then*/
               pq_cr_prcagenda.sp_datos_direccion (j.pepais, j.petdoc,j.pendoc, 1,
               ln_distl, ln_provinl ,ln_dptol,ln_ubileg ,lc_dirleg );
               pq_cr_prcagenda.sp_lat_Long (j.pepais, j.petdoc,j.pendoc, 1,
               ln_latdir,ln_londir );
                
               pq_cr_prcagenda.sp_datos_direccion (j.pepais, j.petdoc,j.pendoc, 3,
               ln_distn, ln_provinn ,ln_dpton,ln_ubineg ,lc_dirneg );
               pq_cr_prcagenda.sp_lat_Long (j.pepais, j.petdoc,j.pendoc,3,
               ln_latneg,ln_lonneg );
               
               -- Obtener descripcion del pais y tipo de documento
               begin
                 select panom 
                   into lc_pais
                   from fst013 
                  where pais = j.pepais;
               exception
                   when others then 
                      lc_pais := 'PERÚ';
               end; 
               begin
                  select tdnom 
                    into lc_dtipdo
                    from fst014 
                   where tdocum = j.petdoc;
               exception
                   when others then 
                      lc_dtipdo := 'DNI/LE';
               end;
              ------------------------------------- 
               Case when ln_moneda = 101 then
                 lc_moneda :='USD';
                 when ln_moneda = 0 then
                 lc_moneda :='S/.';
                 else 
                 lc_moneda :='S/.';
               end case; 
               begin
                  select a.penom
                    into lc_nombre
                    from fsd001 a 
                   where a.pepais = j.pepais
                     and a.petdoc = j.petdoc
                     and a.pendoc = j.pendoc;
               exception
                   when others then 
                      lc_nombre := null;
               end;
            
               insert into JAQL131(JAQL131CIN, JAQL131CAC, JAQL131CBA, JAQL131PAI, JAQL131TDO,
                                JAQL131NDO, JAQL131NOM, JAQL131CSB, JAQL131NFI, JAQL131RFI, 
                                JAQL131CZN, JAQL131DNE, JAQL131TLF, JAQL131SEG, JAQL131AGE, 
                                JAQL131ANA, JAQL131USU, JAQL131SEC, JAQL131FEC, JAQL131MDA,
                                JAQL131MTO, JAQL131IDC, JAQL131CSE, JAQL131LTD, JAQL131LGD,
                                JAQL131LTN,JAQL131LGN,JAQL131MAI,
                                JAQL131FNA,JAQL131DPA ,JAQL131DTD ,JAQL131SEX )
                          values(1 , 1 , 99 , j.pepais, j.petdoc, 
                                 j.pendoc  , lc_nombre , null , ln_ubileg , lc_dirleg , 
                                 ln_ubineg , lc_dirneg , lc_telefo , null , j.scsuc , 
                                 j.analista , P_C_CODUSU , lc_desseg , to_char(j.SCFVTO,'dd/mm/yyyy') , lc_moneda ,
                                 abs(j.scsdo)  , P_C_IDCONX, ln_codseg, ln_latdir , ln_londir,
                                 ln_latneg , ln_lonneg , lc_email ,
                                 to_char(ld_feccum,'DD/MM/YYYY') , lc_pais   , lc_dtipdo, lc_genero);   
              commit;
            /*else 
               null;
            end if; */  
        end loop; 
    elsif P_N_CODBAS = 4 then -- = '1' then -- Cancelados
        begin 
          select ubsuc 
            into ln_codsuc
            from fst046 
           where trim(ubuser) = P_C_CODUSU;
        exception
          when others then 
            null;
        end;
        for h in cancelado (ln_codsuc,ln_tipcam, p_c_codusu ) loop
            lc_texto:= 'Cliente Cancelacion en 2 meses o menor';   
            pq_cr_prcagenda.sp_datos_cliente(h.pepais, h.petdoc,h.pendoc, 
            ld_feccum, lc_genero, lc_email, lc_telefo, ln_codseg, lc_desseg);
            pq_cr_prcagenda.sp_datos_direccion (h.pepais, h.petdoc,h.pendoc, 1,
            ln_distl, ln_provinl ,ln_dptol,ln_ubileg ,lc_dirleg );
            pq_cr_prcagenda.sp_lat_Long (h.pepais, h.petdoc,h.pendoc, 1,
            ln_latdir,ln_londir );
                
            pq_cr_prcagenda.sp_datos_direccion (h.pepais, h.petdoc,h.pendoc, 3,
            ln_distn, ln_provinn ,ln_dpton,ln_ubineg ,lc_dirneg );
            pq_cr_prcagenda.sp_lat_Long (h.pepais, h.petdoc,h.pendoc,3,
            ln_latneg,ln_lonneg );
            begin
                select a.penom
                  into lc_nombre
                  from fsd001 a 
                 where a.pepais = h.pepais
                   and a.petdoc = h.petdoc
                   and a.pendoc = h.pendoc;
             exception
                 when others then 
                    lc_nombre := null;
             end;
            --
            -- Verifica condiciones para insertar los campos.
            if NVL(P_N_CODSEG,0) <> 0 then 
               if ln_codseg = P_N_CODSEG then 
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';  
               end if;
            else       
               lc_inserta := 'S';
            end if;
            if P_N_CODBAS  <> 7 then 
                if P_N_RMTODES <> 10 then  -- 10 TODOS
                   if ln_rango = P_N_RMTODES then 
                      lc_inserta := 'S';
                   else 
                      lc_inserta := 'N';  
                   end if;
                else       
                   if lc_inserta is null or lc_inserta ='S' then
                      lc_inserta := 'S';
                   else 
                      lc_inserta := 'N';
                   end if;     
                end if;
            end if;    
            if upper(trim(P_C_NOMBRE)) is not null  then 
               if lc_nombre like '%'||upper(P_C_NOMBRE)||'%' and (lc_inserta is null or lc_inserta ='S') then 
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';  
               end if;
            else       
               if lc_inserta is null or lc_inserta ='S' then
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';
               end if;
            end if;
            if NVL(P_C_CODUBI,0) <> 0  then 
               if (ln_ubileg = P_C_CODUBI or  ln_ubineg = P_C_CODUBI )
                   and (lc_inserta is null or lc_inserta ='S')  then 
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';  
               end if;
            else       
               if lc_inserta is null or lc_inserta ='S' then
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';
               end if;
            end if;
               
            -- Obtener descripcion del pais y tipo de documento
             begin
               select panom 
                 into lc_pais
                 from fst013 
                where pais = h.pepais;
             exception
                 when others then 
                    lc_pais := 'PERÚ';
             end; 
             begin
                select tdnom 
                  into lc_dtipdo
                  from fst014 
                 where tdocum = h.petdoc;
             exception
                 when others then 
                    lc_dtipdo := 'DNI/LE';
             end;
            ------------------------------------- 
             Case when ln_moneda = 101 then
               lc_moneda :='USD';
               when ln_moneda = 0 then
               lc_moneda :='S/.';
               else 
               lc_moneda :='S/.';
             end case; 
             
            
            if lc_inserta = 'S' then   
              insert into JAQL131(JAQL131CIN, JAQL131CAC, JAQL131CBA, JAQL131PAI, JAQL131TDO,
                                  JAQL131NDO, JAQL131NOM, JAQL131CSB, JAQL131NFI, JAQL131RFI, 
                                  JAQL131CZN, JAQL131DNE, JAQL131TLF, JAQL131SEG, JAQL131AGE, 
                                  JAQL131ANA, JAQL131USU, JAQL131SEC, JAQL131FEC, JAQL131MDA,
                                  JAQL131MTO, JAQL131IDC, JAQL131CSE, JAQL131LTD, JAQL131LGD,
                                  JAQL131LTN,JAQL131LGN,JAQL131MAI,
                                  JAQL131FNA,JAQL131DPA ,JAQL131DTD ,JAQL131SEX, JAQL131TXT/*,
                                  JAQL131FVI, JAQL131HOR*/  )
                            values(1 , 1 , 4 , h.pepais, h.petdoc, 
                                 h.pendoc  , lc_nombre , null , ln_ubileg , lc_dirleg , 
                                 ln_ubineg , lc_dirneg , lc_telefo , null , h.scsuc , 
                                 h.analista , P_C_CODUSU , lc_desseg , to_char(h.SCFVTO,'dd/mm/yyyy') , lc_moneda ,
                                 abs(h.scsdo)  , P_C_IDCONX, ln_codseg, ln_latdir , ln_londir,
                                 ln_latneg , ln_lonneg , lc_email ,
                                 to_char(ld_feccum,'dd/mm/yyyy') , lc_pais   , lc_dtipdo, lc_genero, lc_texto/*,
                                 null, null*/);   
              commit;
           end if;  
        end loop;         
    else 
         
          
        For i in agenda (ln_ncoding)loop
            lc_inserta := null;
            Case when P_N_CODBAS  = 1 and P_N_CODACT = 1 then 
                      ln_estado:=0;
                      pq_cr_prcagenda.sp_Datos_Cre(i.npaicli , i.ntipdoc ,i.cnumdoc,ln_estado,
                                                ld_feccan, ln_mtocr, ln_moneda);
                      lc_texto:= 'Cliente Inactivo despues de 14 dias de cancelado el prestamo';
                 when P_N_CODBAS  = 4 and P_N_CODACT = 1 then
                      ln_estado:=99;
                      pq_cr_prcagenda.sp_Datos_Cre(i.npaicli , i.ntipdoc ,i.cnumdoc,ln_estado,
                                                ld_feccan, ln_mtocr, ln_moneda);
                      lc_texto:= 'Cliente Cancelacion en 2 meses o menor';                          
                 when P_N_CODBAS  = 7 and P_N_CODACT = 1 then
                      ln_estado:=null;
                      lc_texto:= null;
            end case;
            -- Determina el rango
            Case when ln_moneda = 101 then
                 lc_moneda :='USD';
                 ln_mtosol := ln_mtocr * ln_tipcam;
                 when ln_moneda = 0 then
                 lc_moneda :='S/.';
                 ln_mtosol := ln_mtocr ;
                 else 
                 lc_moneda :=null;  
            end case; 
            if lc_moneda is not null then
                begin 
                    select jaql132npar 
                      into ln_rango
                      from jaql132  
                     where jaql132cpar = 1 -- rango monto
                       and jaql132vmin <= ln_mtosol
                       and jaql132vmax >= ln_mtosol;
                exception
                  when no_data_found then
                       ln_rango := 10;  
                end;
            else
               ln_rango := 0;        
            end if;    
              
            pq_cr_prcagenda.sp_datos_direccion (i.npaicli , i.ntipdoc ,i.cnumdoc ,1,
            ln_distl, ln_provinl ,ln_dptol,ln_ubileg ,lc_dirleg );
            pq_cr_prcagenda.sp_lat_Long (i.npaicli , i.ntipdoc ,i.cnumdoc ,1,
            ln_latdir,ln_londir );
            
            pq_cr_prcagenda.sp_datos_direccion (i.npaicli , i.ntipdoc ,i.cnumdoc ,3,
            ln_distn, ln_provinn ,ln_dpton,ln_ubineg ,lc_dirneg );
            pq_cr_prcagenda.sp_lat_Long (i.npaicli , i.ntipdoc ,i.cnumdoc ,3,
            ln_latneg,ln_lonneg );
             
            pq_cr_prcagenda.sp_datos_cliente(i.npaicli , i.ntipdoc ,i.cnumdoc, 
            ld_feccum, lc_genero, lc_email, lc_telefo, ln_codseg, lc_desseg);
            -- Verifica condiciones para insertar los campos.
            if NVL(P_N_CODSEG,0) <> 0 then 
               if ln_codseg = P_N_CODSEG then 
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';  
               end if;
            else       
               lc_inserta := 'S';
            end if;
            if P_N_CODBAS  <> 7 then 
                if P_N_RMTODES <> 10 then  -- 10 TODOS
                   if ln_rango = P_N_RMTODES then 
                      lc_inserta := 'S';
                   else 
                      lc_inserta := 'N';  
                   end if;
                else       
                   if lc_inserta is null or lc_inserta ='S' then
                      lc_inserta := 'S';
                   else 
                      lc_inserta := 'N';
                   end if;     
                end if;
            end if;    
            if upper(trim(P_C_NOMBRE)) is not null  then 
               if i.CCLINOM like '%'||upper(P_C_NOMBRE)||'%' and (lc_inserta is null or lc_inserta ='S') then 
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';  
               end if;
            else       
               if lc_inserta is null or lc_inserta ='S' then
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';
               end if;
            end if;
            if NVL(P_C_CODUBI,0) <> 0  then 
               if (ln_ubileg = P_C_CODUBI or  ln_ubineg = P_C_CODUBI )
                   and (lc_inserta is null or lc_inserta ='S')  then 
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';  
               end if;
            else       
               if lc_inserta is null or lc_inserta ='S' then
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';
               end if;
            end if;
            /*if P_N_DPTO is not null  then 
               if ln_dptol = P_N_DPTO or ln_dpton = P_N_DPTO then 
                  lc_inserta := 'S';
                  if P_N_PROV is not null  then 
                     if ln_provinl = P_N_PROV or ln_provinn = P_N_PROV then 
                        lc_inserta := 'S';
                        if P_N_DIST is not null  then 
                           if ln_distl = P_N_DIST or ln_distn = P_N_DIST then 
                              lc_inserta := 'S';
                           else 
                              lc_inserta := 'N';  
                           end if;
                        else       
                           if lc_inserta is null or lc_inserta ='S' then
                              lc_inserta := 'S';
                           else 
                              lc_inserta := 'N';
                           end if;
                        end if;  
                     else 
                        lc_inserta := 'N';  
                     end if;
                  else       
                     if lc_inserta is null or lc_inserta ='S' then
                        lc_inserta := 'S';
                     else 
                        lc_inserta := 'N';
                     end if;
                  end if;   
               else 
                  lc_inserta := 'N';  
               end if;
            else       
               if lc_inserta is null or lc_inserta ='S' then
                  lc_inserta := 'S';
               else 
                  lc_inserta := 'N';
               end if;
            end if; */
          -- Obtener descripcion del pais y tipo de documento
          begin
            select panom 
              into lc_pais
              from fst013 
             where pais = i.npaicli;
          exception
              when others then 
                 lc_pais := 'PERÚ';
          end; 
          begin
             select tdnom 
               into lc_dtipdo
               from fst014 
              where tdocum = i.ntipdoc;
          exception
              when others then 
                 lc_dtipdo := 'DNI/LE';
          end;
          ------------------------------------- 
          if lc_inserta = 'S' then   
            insert into JAQL131(JAQL131CIN, JAQL131CAC, JAQL131CBA, JAQL131PAI, JAQL131TDO,
                                JAQL131NDO, JAQL131NOM, JAQL131CSB, JAQL131NFI, JAQL131RFI, 
                                JAQL131CZN, JAQL131DNE, JAQL131TLF, JAQL131SEG, JAQL131AGE, 
                                JAQL131ANA, JAQL131USU, JAQL131SEC, JAQL131FEC, JAQL131MDA,
                                JAQL131MTO, JAQL131IDC, JAQL131CSE, JAQL131LTD, JAQL131LGD,
                                JAQL131LTN,JAQL131LGN,JAQL131MAI,
                                JAQL131FNA,JAQL131DPA ,JAQL131DTD ,JAQL131SEX, JAQL131TXT )
                          values(i.ncoding , i.ncodact , i.ncodbas , i.npaicli , i.ntipdoc ,
                                 i.cnumdoc , i.cclinom , i.ccodsbs , ln_ubileg , lc_dirleg , 
                                 ln_ubineg , lc_dirneg , lc_telefo , lc_desseg , i.ncodage , 
                                 i.ncodana , i.ccodusu , i.cnomsec , to_char(ld_feccan,'dd/mm/yyyy') , lc_moneda ,
                                 ln_mtocr  , P_C_IDCONX, ln_codseg, ln_latdir , ln_londir,
                                 ln_latneg , ln_lonneg , lc_email ,
                                 to_char(ld_feccum,'dd/mm/yyyy') , lc_pais   , lc_dtipdo, lc_genero, lc_texto);   
            commit;
          end if;  
        end loop;
    end if;
    commit;
   
end ;
-- Registra resultados
procedure sp_lista_resultado is
begin
 EXECUTE IMMEDIATE ('TRUNCATE TABLE JAQL133');
 insert into jaql133  (jaql133cres,jaql133dres)
 select ncodres jaql133cres, cnomres jaql133dres  
   from acdresu
  where cestado = '1';
end;
 

procedure sp_reg_resultado(ps_codpai in number  ,ps_tipdoc in number, ps_numdoc varchar2,
                           ps_codusu in varchar2,ps_codres varchar2, ps_desobs varchar2,
                           ps_codvis varchar2,ps_codtas varchar2, ps_codser varchar2,
                           ps_codate varchar2,ps_otrres varchar2 ) is 

ld_feccan date;
ln_mtocr  number;
ln_moneda varchar2(20);
lv_pendoc2 fsd001.pendoc%type;

begin
  /* PQ_AGENDA_COMERCIAL.sp_insvis@DBAGECOM(ps_codpai ,ps_tipdoc , ps_numdoc ,
                                          ps_codusu ,ps_codres , ps_desobs ,
                                          ps_codvis ,ps_codtas , ps_codser ,
                                          ps_codate ,ps_otrres );*/
   null;                                       
exception 
  when others then 
      ld_feccan := null;
      ln_mtocr  := null;
      ln_moneda := null;
end;  

end PQ_CR_PRCAGENDA;
/

