create or replace procedure SP_AH_GENERA_PRODUCTO_AH(P_D_FECPRO IN DATE,
                                                     P_C_CODUSU IN VARCHAR2,
                                                     P_N_CTACLI IN NUMBER, 
                                                     P_N_MDACTA IN NUMBER,  
                                                     P_N_TIPOPE IN NUMBER,  
                                                     P_N_CODAGE IN NUMBER,    
                                                     P_N_CUEEMP IN NUMBER,  
                                                     P_C_DESCUE IN VARCHAR2,
                                                     P_N_CODPRO IN NUMBER,
                                                     P_N_TIPGEN IN NUMBER,                                                    
                                                     P_N_COMMIT IN NUMBER,                   
                                                     p_n_tipape out number,
                                                     p_n_pgcod  out number,                                                     
                                                     p_n_scmod  out number,
                                                     p_n_scsuc  out number,
                                                     p_n_scmda  out number,
                                                     p_n_scpap  out number,
                                                     p_n_sccta  out number,
                                                     p_n_scoper out number,
                                                     p_n_scsbop out number,
                                                     p_n_sctope out number,
                                                     p_c_deserr out varchar2
                                                    ) is
   -- *****************************************************************
    -- Nombre                     : SP_AH_GENERA_PRODUCTO_AH
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/01/2022
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Apertura de cuentas de Ahorros
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 12/04/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó parametro en alerta de experiencia al cliente
    -- Fecha de Modificación      : 15/09/2025
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se modificó el orden en los integrantes de la cuenta cliente
    -- *****************************************************************                                                    
                                                    
cursor c_integrantes is
    select * 
     from fsr008 a 
    where a.pgcod = 1 
      and a.ctnro = P_N_CTACLI
      and a.ttcod = 1
 order by a.cttfir desc;--a.pepais,a.petdoc,a.pendoc;
 
cursor c_comisiones is
Select * 
  from aqpa109 a 
 where a.aqpa109est = 'S' 
   and a.aqpa109com not in (2,4,5,7); 
   
cursor c_canales is
Select * from aqpa109c a;

cursor c_comisiones_cam is
Select * 
  from aqpa109 a 
 where a.aqpa109est = 'S' 
   and a.aqpa109com = 6; 
   
cursor c_canales_cam is
Select * 
  from aqpa109c a 
 where a.aqpa109ccan in (1,2);
                                                      
ln_codseg fsd008.ctsegm %type;
ln_scsuc  fsd011.scsuc%type;
lc_sector varchar2(2);
lc_moneda varchar2(1);
ln_totint number(3);
ln_grupo   number(3);
ln_grupox  number(3);
ld_fecpro date;
ld_Pgfcie date;
lc_descue char(15);
lc_prd1cspr  char(1);              
lc_prd1csmo  char(1);  
lc_prd1cchq  char(1);  
lc_prd1pint  char(1);  
lc_prd1cint  char(1);  
lc_prd1cbga  char(1);  
lc_prd1caut  char(1);  
ln_prd1cestc number;
lc_prd1pmi   char(1);      
lc_prd1tces  char(1);     
lc_indtra    char(2);   
lc_pais      number(3);
lc_tipo      number(2);
lc_numero    char(12);     
ln_lisneg    char(1) := 'N';

ln_pmtit     number(2);
ln_pmcap     number(1);
ln_pmpzo     number(1);
ln_pmgru     number(2); 
ld_FecIni    date;
ld_fecfin    date;
--lv_valida    varchar2(1):= 'N';
lc_usuario   char(10);
ln_pais      number(3);
ln_petdoc    number(2);
lc_pendoc    char(12);
ln_varMes    number(9):= 0;
ln_AgteCod   number(7):= 0;
lc_texto1    char(100);
lc_numtar    char(26) := '';
lc_flag      char(1)  := 'N';
ld_fecdes    date;
ln_R1cta     number(9);
Flag2        char(1):='N';
lc_coderr    varchar2(400);
lc_msgerr    varchar2(400);

estrab number := 0;  
cantidad number := 0;   
FECHA_COMP TIMESTAMP;  

lv_canal   char(30):='';


---***
P_MOD NUMBER(3);
P_SUC NUMBER(3);
P_MDA NUMBER(4);
P_PAP NUMBER(4);
P_CTA NUMBER(9);
P_OPER NUMBER(9);
P_SOPE NUMBER(3);
P_TOPE NUMBER(3);
P_GUITRX NUMBER(3);
P_MONTRX NUMBER(18,2);
P_FECTRX DATE;
P_RESULT VARCHAR(4);
P_RESMSG VARCHAR(240);
P_ERRCOD VARCHAR(3);
P_ERRMSG VARCHAR(200);
---***

begin
  p_c_deserr := null;
  p_n_scmda  := P_N_MDACTA;
  p_n_sccta  := P_N_CTACLI;
  p_n_sctope := P_N_TIPOPE;
  p_n_scsuc  := P_N_CODAGE;  

  p_n_pgcod  := 1; 
  p_n_scmod  := 21;   
  p_n_scpap  := 0; 
  p_n_scoper := 0;  
  p_n_scsbop := 0;



  ---*** Verificamos si persona esta en lista ONU-OFAC
   begin
   ---***
   begin 
     select UBSUC INTO P_SUC from fst046 where UBUSER = RPAD(P_C_CODUSU, 10, ' ');
   exception
   when others then
     P_SUC := 0;
   end;
   ---***
   P_MOD := 0;
   P_MDA := P_N_MDACTA;
   P_PAP := 0;
   P_CTA := P_N_CTACLI;
   P_OPER := 0;
   P_SOPE := 0;
   P_TOPE := P_N_TIPOPE;
   P_GUITRX := 0;
   P_MONTRX := 0;
   P_FECTRX := P_D_FECPRO;

   P_RESULT := '';
   P_RESMSG := '';
   P_ERRCOD := '';
   P_ERRMSG := ''; 
   
   -- Call the procedure
  SP_AH_CRUCE_ONU_OFAC_CTA_M(P_MOD, P_SUC, P_MDA, P_PAP, P_CTA, P_OPER, P_SOPE, P_TOPE, P_GUITRX, P_MONTRX, P_FECTRX
  , P_RESULT, P_RESMSG, P_ERRCOD, P_ERRMSG);
  
  IF(P_RESULT IN ('ONUB', 'OFAB')) THEN
  p_c_deserr := 'N-'||'Persona en base Negativa / ONU-OFAC';    
        return;
  END IF;  
  
  exception
   when others then
     null;
  end;
  ---*** 
  
  --Verificamos si persona esta en lista negra
   begin
     select 'S'
       into ln_lisneg
       from fsd201 x, 
            fsr008 y
      where x.lnpais = y.pepais
        and x.lntdoc = y.petdoc
        and x.lnndoc = y.pendoc
        and x.tlis in (1,3)
        and y.pgcod = 1
        and y.ctnro = P_N_CTACLI
        and y.ttcod = 1
        and rownum < 2;
        p_c_deserr := 'N-'||'Persona en base Negativa / OFAC';    
        return;
   exception
   when others then
     null;
   end;    
  
  if P_N_TIPOPE not in (2,6) then  
    if P_N_TIPOPE <> 12 or (P_N_TIPOPE = 13 and TRIM(P_C_CODUSU) = 'BANTOTAL') then
        begin
          select a.pgcod,  
                 a.scmod,
                 a.scsuc,
                 a.scmda,
                 a.scpap,
                 a.sccta,
                 a.scoper,
                 a.scsbop,
                 a.sctope
            into p_n_pgcod, 
                 p_n_scmod, 
                 p_n_scsuc, 
                 p_n_scmda, 
                 p_n_scpap, 
                 p_n_sccta, 
                 p_n_scoper,
                 p_n_scsbop,
                 p_n_sctope           
            from fsd011 a 
           where a.pgcod  = 1 
             and a.scmod  = 21 
             and a.scsuc  = P_N_CODAGE
             and a.scmda  = P_N_MDACTA 
             and a.scpap  = 0 
             and a.sccta  = P_N_CTACLI 
             and a.sctope = P_N_TIPOPE
             and a.scstat <> 99
             and rownum < 2;
        exception 
        when others then  
          p_n_pgcod  := 1; 
          p_n_scmod  := 21;   
          p_n_scsuc  := P_N_CODAGE;    
          p_n_scmda  := P_N_MDACTA; 
          p_n_scpap  := 0; 
          p_n_sccta  := P_N_CTACLI; 
          p_n_scoper := 0;
          p_n_sctope := P_N_TIPOPE;     
          p_n_scsbop := 0;
        end;
    end if;
  Else
        begin
          select a.pgcod,  
                 a.scmod,
                 a.scsuc,
                 a.scmda,
                 a.scpap,
                 a.sccta,
                 a.scoper,
                 a.scsbop,
                 a.sctope
            into p_n_pgcod, 
                 p_n_scmod, 
                 p_n_scsuc, 
                 p_n_scmda, 
                 p_n_scpap, 
                 p_n_sccta, 
                 p_n_scoper,
                 p_n_scsbop,
                 p_n_sctope           
            from fsd011 a, 
                 fsr011 b
           where a.pgcod = b.r2cod
             and a.scsuc = b.r2suc
             and a.scmda = b.r2mda
             and a.scpap = b.r2pap
             and a.sccta = b.r2cta
             and a.scoper = b.r2oper
             and a.scsbop = b.r2sbop
             and a.sctope = b.r2tope
             and a.scmod = b.r2mod
             and b.r1cta = P_N_CUEEMP
             and b.relcod = 45
             and b.r011co = 'S'
             and a.pgcod  = 1 
             and a.scmod  = 21 
             and a.scmda  = P_N_MDACTA 
             and a.scpap  = 0 
             and a.sccta  = P_N_CTACLI 
             and a.sctope = P_N_TIPOPE
             and a.scstat <> 99
             and rownum < 2;
        exception 
        when others then  
          p_n_pgcod  := 1; 
          p_n_scmod  := 21;   
          p_n_scsuc  := P_N_CODAGE;    
          p_n_scmda  := P_N_MDACTA; 
          p_n_scpap  := 0; 
          p_n_sccta  := P_N_CTACLI; 
          p_n_scoper := 0;
          p_n_sctope := P_N_TIPOPE;     
          p_n_scsbop := 0;
        end;
  End If;
  
  if p_n_scsbop = 0 then    
      begin
        select z.pgfape, z.Pgfcie into ld_fecpro, ld_Pgfcie from fst017 z where z.pgcod = 1;
      exception 
      when others then      
        p_c_deserr := substr('0-'||sqlerrm,1,100);    
        return;
      end;  
      ld_fecpro  := P_D_FECPRO;  
          
      begin
        select nvl(max(a.scsbop),0) + 1  
          into p_n_scsbop 
          from fsd011 a 
         where a.pgcod  = 1 
           and a.scmod  = 21 
           and a.scpap  = 0 
           and a.sccta  = P_N_CTACLI;
      exception 
      when others then      
        p_n_scsbop := 0;
      end; 
   --Verificamos que sucursal exista
   begin
     select x.sucurs
       into ln_scsuc 
       from fst001 x 
      where x.pgcod = 1
        and x.sucurs = P_N_CODAGE
        and P_N_CODAGE > 0 and P_N_CODAGE < 400;
   exception
   when others then
      p_c_deserr := '1-'||'Agencia no autorizada a generar productos';    
      return;
   end;  
   --obtenemos sector de la cuenta cliente para armar el rubro
   begin
     select lpad(y.seccod,2,'0')
       into lc_sector
       from fsd008 y 
      where y.pgcod = p_n_pgcod
        and y.ctnro = P_N_CTACLI;  
         
        If lc_sector = '04' then
           lc_sector := '01';
        End If;  
        if lc_sector = '03' or lc_sector = '05' then   
          p_c_deserr := '2-'||'Sector inválido';    
          return;      
        End if;
   exception
   when others then
      p_c_deserr := substr('3-'||sqlerrm,1,100);    
      return;
   end;
   if P_N_MDACTA = 0 then
     lc_moneda := '1';
   else
     lc_moneda := '2';
   end if;    
   --obtenemos el segmento
        begin
          select y.CTSEGM,
                 decode(trim(P_C_DESCUE),'',substr(y.ctnom,1,15),P_C_DESCUE)
            into ln_codseg,
                 lc_descue
            from fsd008 y
           where y.pgcod = 1
             and y.ctnro = P_N_CTACLI;
        Exception
        When others then
          p_c_deserr := substr('4-'||sqlerrm,1,100);    
          return;
        end;      
   --consultamos si es trabajador
   if P_N_TIPOPE = 2 then
     BEGIN
        For i in c_integrantes loop 
          lc_pais   := i.pepais;
          lc_tipo   := i.petdoc;
          lc_numero := i.pendoc;
        End Loop; 
        begin
          select '02'  
            into lc_indtra
            from fsd002 a 
           where a.pfpais = lc_pais  
             and a.pftdoc = lc_tipo
             and a.pfndoc = lc_numero
             and a.pfebco = 'S';       
        exception
        when others then   
          lc_indtra := '01';  
        end;
     EXCEPTION
     WHEN OTHERS THEN
       lc_indtra:= '01';  
     END;                     
   end if;
   --obtenemos datos del grupo
   begin
     Select a.pmtit,
            a.pmcap,
            a.pmpzo,
            a.pmgru
       into ln_pmtit,
            ln_pmcap,
            ln_pmpzo,
            ln_pmgru 
      from fsd014 a 
     where a.rubro = decode(P_N_TIPOPE,2,to_number('21'||lc_moneda||'305'||lc_indtra||'00001'),to_number('21'||lc_moneda||'201'||lc_sector||'00001'));
   exception 
   when others then
        ln_pmtit := 2;
        ln_pmcap := 1;
        ln_pmpzo := 2;
        ln_pmgru := 1;    
   end;
   --realizamos la apertura   
    begin
      insert into fsd011(pgcod, 
                         scsuc, 
                         scrub, 
                         scmda, 
                         scpap, 
                         sccta, 
                         scoper,
                         scsbop,
                         sctope,
                         scmod, 
                         scfcon,
                         scfval,
                         scfvto,
                         scfulm,
                         scpzo, 
                         scsdo,
                         scsdoh,
                         scsegm,
                         scfunc,
                         scstat,
                         sccc,  
                         sctit, 
                         sccap, 
                         scplzo,
                         scgru                   
                         )
                   values(1,
                          ln_scsuc,
                          decode(P_N_TIPOPE,2,to_number('21'||lc_moneda||'305'||lc_indtra||'00001'),to_number('21'||lc_moneda||'201'||lc_sector||'00001')),
                          P_N_MDACTA,
                          0,
                          P_N_CTACLI,
                          0,
                          p_n_scsbop,
                          P_N_TIPOPE,
                          21,
                          ld_fecpro,
                          ld_fecpro,
                          to_date('01/01/0001','dd/mm/rrrr'),
                          to_date('01/01/0001','dd/mm/rrrr'),
                          0,
                          0,
                          0,
                          ln_codseg,0,
                          decode(P_N_TIPOPE,2,4,6,1,13,2,7),--estado parametrizable se cambio a 1 para tipo 6
                          0,
                          ln_pmtit,--2,
                          ln_pmcap,--1,
                          ln_pmpzo,--2,
                          ln_pmgru--1
                         ); 
    exception
    when others then
      p_c_deserr := substr('5-'||sqlerrm,1,100);    
      return;
    end;
    
    -- Registramos el motivo del bloqueo en tabla de cambios de estado FSD450
    if P_N_TIPOPE not in (2,6,13) then 
      if TRIM(P_C_CODUSU) not in ('USRMOVIL','BANTOTAL','NSBTUSER','USRQRCAM') then /*Hlaqui 11/11/2019*/
         begin
         insert into fsd450(Cbieemp, 
                             Cbiemod,
                             Cbiesuc, 
                             Cbiemda, 
                             Cbiepap, 
                             Cbiecta, 
                             Cbieope, 
                             Cbiesub, 
                             Cbietop, 
                             Cbiefec, 
                             Cbierel, 
                             Cbieant, 
                             Cbietxt1,
                             Cbietxt2,
                             Cbietxt3
                             )
                       values(1,
                              21,
                              ln_scsuc,
                              P_N_MDACTA,
                              0,
                              P_N_CTACLI,
                              0,
                              p_n_scsbop,
                              P_N_TIPOPE,
                              ld_fecpro,
                              1,
                              0,
                              SUBSTR(TRIM(P_C_CODUSU),1,10),
                              'APERTURA DE CUENTA',
                              'BLOQ./DESBL.POR FALTA REG. DOC APERT'
                             );
        exception
        when others then
          p_c_deserr := substr('5.1-'||sqlerrm,1,100);    
          return;
        end;
      End if; /*Hlaqui 11/11/2019*/                            
    End if;  
    
    --insertamos en la FSE113
    begin
    insert into FSE113(pgcod,    
                       cv1mod,   
                       cv1mda,  
                       cv1pap,   
                       cv1cta,   
                       cv1suc,   
                       cv1oper,  
                       cv1sbop,  
                       cv1tope,  
                       cv1frec,  
                       cv1folio, 
                       cv1ultf,  
                       cv1impre, 
                       cv1tdeb,  
                       cv1sdoant,
                       cv1aux4,  
                       cv1aux5,  
                       cv1aux6,  
                       cv1aux7  
                      ) 
               values(1,
                      21,
                      P_N_MDACTA,
                      0,
                      P_N_CTACLI,
                      ln_scsuc,
                      0, 
                      p_n_scsbop,
                      P_N_TIPOPE,
                      8,
                      0,
                      ld_Pgfcie,
                      'N',
                      0,
                      0,
                      'N',
                      0,
                      SUBSTR(TRIM(P_C_CODUSU),1,10),
                      to_date('01/01/0001','dd/mm/rrrr')
                      );
    exception
    when others then                        
      p_c_deserr := substr('6-'||sqlerrm,1,100);    
      return;
    end;                
    --obtenemos datos de la parametrización del producto
    begin
      select prd1cspr,   
             prd1csmo,   
             prd1cchq,   
             prd1pint,   
             prd1cint,   
             prd1cbga,   
             prd1caut,  
             P_N_TIPGEN prd1cestc, --apertura en campo 1 y en agencia 0 P_N_TIPGEN
             prd1pmi,    
             prd1tces
             into
             lc_prd1cspr,   
             lc_prd1csmo,  
             lc_prd1cchq,   
             lc_prd1pint,   
             lc_prd1cint,   
             lc_prd1cbga,   
             lc_prd1caut,   
             ln_prd1cestc,
             lc_prd1pmi,    
             lc_prd1tces
        from prd001 
       where pgcod  = 1 
         and modulo = 21 
         and totope = P_N_TIPOPE 
         and papel  = 0 
         and moneda = P_N_MDACTA;     
    exception
    when others then  
      p_c_deserr := substr('6a-'||sqlerrm,1,100);    
      return;        
    end;
         
    --insertamos en la FSE013
    begin
      insert into fse013(pgcod,  
                         cvmod, 
                         cvmda,  
                         cvpap,  
                         cvcta,  
                         cvsuc,  
                         cvoper, 
                         cvsbop, 
                         cvtope, 
                         cvcspr, 
                         cvcsmo, 
                         cvcchq, 
                         cvpint, 
                         cvcint, 
                         cvsbga, 
                         cvcaut, 
                         cvestc, 
                         cvpmi,  
                         cvnom,  
                         cvfcbj, 
                         cvusbj, 
                         cvwsbj, 
                         cvtces, 
                         cvfolio
                         ) 
                  values (1,
                          21,
                          P_N_MDACTA,
                          0,
                          P_N_CTACLI,
                          ln_scsuc,
                          0, 
                          p_n_scsbop,
                          P_N_TIPOPE,
                          lc_prd1cspr,                   
                          lc_prd1csmo,                   
                          lc_prd1cchq,                   
                          lc_prd1pint,                   
                          lc_prd1cint,                   
                          lc_prd1cbga,                   
                          lc_prd1caut,                   
                          ln_prd1cestc,                  
                          lc_prd1pmi,                    
                          lc_descue,
                          to_date('01/01/0001','dd/mm/rrrr'),
                          null,
                          null,
                          lc_prd1tces,
                          0                                    
                         );
    exception
    when others then  
      p_c_deserr := substr('6b-'||sqlerrm,1,100);    
      return;      
    end;
    -- registramos el proposito de la cuenta
    begin
      insert into fse413(se413cod,
                         se413suc,
                         se413mod,
                         se413mda,
                         se413pap,
                         se413cta,
                         se413ope,
                         se413sbo,
                         se413top,
                         se413fte,
                         se413prm,
                         se413prc,
                         se413tx1,
                         se413tx2,
                         se413tx3,
                         se413tx4,
                         se413fc1,
                         se413fc2,
                         se413fc3,
                         se413fc4,
                         se413im1,
                         se413im2,
                         se413im3,
                         se413im4
                        ) 
                  values(1,
                         ln_scsuc,
                         21,
                         P_N_MDACTA,
                         0,
                         P_N_CTACLI,
                         0, 
                         p_n_scsbop,
                         9,
                         decode(P_N_CODPRO,0,20,P_N_CODPRO),--P_N_CODPRO
                         0,
                         0,
                         'N',
                         null,
                         null,
                         null,
                         to_date('01/01/0001','dd/mm/rrrr'),
                         to_date('01/01/0001','dd/mm/rrrr'),
                         to_date('01/01/0001','dd/mm/rrrr'),
                         to_date('01/01/0001','dd/mm/rrrr'),
                         0,
                         0,
                         0,
                         0
                        );
    exception  
    when others then                        
      p_c_deserr := substr('6c-'||sqlerrm,1,100);    
      return;                        
    end;
    
    --verificamos integrantes de la cuenta
    begin
      select count(1) into ln_totint from fsr008 c where c.pgcod=1 and c.ctnro = P_N_CTACLI;
    exception  
    when others then                        
      p_c_deserr := substr('7-'||sqlerrm,1,100);    
      return;
    end; 
    
    if P_N_TIPOPE in (2,6) then       
      if ln_totint = 1 then
         ln_grupox := 1;
      else
         ln_grupox := 511;
      End if;        
    Else
      if P_N_CUEEMP = 0 or P_N_CUEEMP is null then    
        if ln_totint = 1 then
           ln_grupox := 1;
        else
           ln_grupox := 511;
        End if;               
      Else
        if P_N_CUEEMP = 1 then
           ln_grupox := 1;
        End if;
        if P_N_CUEEMP = 2 then
           ln_grupox := 501;
        End if;
        if P_N_CUEEMP = 3 then
           ln_grupox := 511;
        End if;        
      End If;    
    End If;
   
   
    --verificamos si ya existe la facultad en la fse130
    begin
      select decode(max(c.ctfecdes),null,0,1), max(c.ctfecdes)
        into ln_totint, 
             ld_fecdes
        from fse130 c
       where c.pgcod    = 1
         and c.ctnro    = P_N_CTACLI
         and c.faccod   = 1
         and c.ctfaccor = ln_grupox;
    exception  
    when others then                        
      ln_totint := 0;
    end;
    
    if ln_totint = 0 then 
        ln_grupo := ln_grupox;    
        if ln_grupo in (1,511) then
            begin
            insert into FSE130(pgcod,     
                               ctnro,     
                               faccod,    
                               ctfaccor,  
                               ctfecdes,  
                               ctfaclim,  
                               ctfacvig,  
                               ctfaclimmn
                              ) 
                       values(1,
                              P_N_CTACLI,
                              1,
                              ln_grupo,
                              ld_fecpro,
                              999999999999.00,
                              'S',
                              999999999999.00               
                              );
                 
            ln_grupo := ln_grupo + 1;    

            exception
            when others then                        
              p_c_deserr := substr('8-'||sqlerrm,1,100);    
              return;
            end; 
        Else    
            ln_grupo := ln_grupox;    
            For x in c_integrantes loop        
                --insertamos en la FSE130
                begin
                insert into FSE130(pgcod,     
                                   ctnro,     
                                   faccod,    
                                   ctfaccor,  
                                   ctfecdes,  
                                   ctfaclim,  
                                   ctfacvig,  
                                   ctfaclimmn
                                  ) 
                           values(1,
                                  P_N_CTACLI,
                                  1,
                                  ln_grupo,
                                  ld_fecpro,
                                  999999999999.00,
                                  'S',
                                  999999999999.00               
                                  );
                     
                ln_grupo := ln_grupo + 1;    
                if ln_grupo = 511 then
                   ln_grupo := ln_grupo + 1;    
                End If;          
                exception
                when others then                        
                  p_c_deserr := substr('8a-'||sqlerrm,1,100);    
                  return;
                end;   
            End Loop;                             
        End If;  
           
        ln_grupo := ln_grupox;                    
        For i in c_integrantes loop        
          --insertamos en la FSR130
          begin
          insert into FSR130(pgcod,    
                             ctnro,    
                             faccod,   
                             ctfaccor, 
                             ctfecdes, 
                             pfpai2,   
                             pftdo2,   
                             pfndo2   
                            ) 
                     values(1,
                            P_N_CTACLI,
                            1,
                            ln_grupo,
                            ld_fecpro,
                            i.pepais,
                            i.petdoc,
                            i.pendoc
                            );
          if ln_grupox <> 511 then                  
            ln_grupo := ln_grupo + 1;    
            
            if ln_grupo = 511 then
               ln_grupo := ln_grupo + 1;    
            End If;                                
          End If;
          exception
          when others then                        
            p_c_deserr := substr('9-'||sqlerrm,1,100);    
            return;
          end;     
        End loop; 
    Else    
        ln_grupo := ln_grupox; 
        For x in c_integrantes loop
            begin
            insert into FSE130(pgcod,     
                               ctnro,     
                               faccod,    
                               ctfaccor,  
                               ctfecdes,  
                               ctfaclim,  
                               ctfacvig,  
                               ctfaclimmn
                              ) 
                       values(1,
                              P_N_CTACLI,
                              1,
                              ln_grupo,
                              ld_fecdes,
                              999999999999.00,
                              'S',
                              999999999999.00               
                              );                           
            Exception
            When dup_val_on_index then
              null;
            when others then                        
              p_c_deserr := substr('8b-'||sqlerrm,1,100);    
              return;
            end;   
            ln_grupo := ln_grupo + 1;    
            if ln_grupo = 511 then
               ln_grupo := ln_grupo + 1;    
            End If;                 
        End loop;  
        
        ln_grupo := ln_grupox; 
        For i in c_integrantes loop        
          --insertamos en la FSR130
          begin
          insert into FSR130(pgcod,    
                             ctnro,    
                             faccod,   
                             ctfaccor, 
                             ctfecdes, 
                             pfpai2,   
                             pftdo2,   
                             pfndo2   
                            ) 
                     values(1,
                            P_N_CTACLI,
                            1,
                            ln_grupo,
                            ld_fecdes,
                            i.pepais,
                            i.petdoc,
                            i.pendoc
                            );                          
          exception
          When dup_val_on_index then
              null;            
          when others then                        
            p_c_deserr := substr('9a-'||sqlerrm,1,100);    
            return;
          end;     
          if ln_grupox <> 511 then
            ln_grupo := ln_grupo + 1;    
            if ln_grupo = 511 then
               ln_grupo := ln_grupo + 1;    
            End If;            
          End If;            
        End loop;                                                              
    End if;     
    
    if ln_totint = 0 then 
      ld_fecdes := ld_fecpro;
    Else
      ld_fecdes := ld_fecdes;
    End If;       
    ln_grupo := ln_grupox;     
    if ln_grupo = 511 then               
        --insertamos en la FSR011
        begin
        insert into FSR011(r1cod, 
                           r1mod, 
                           r1suc, 
                           r1mda, 
                           r1pap, 
                           r1cta, 
                           r1oper,
                           r1sbop,
                           r1tope,
                           relcod,
                           r2mod, 
                           r2cta, 
                           r2oper,
                           r2sbop,
                           r1rub, 
                           r2cod, 
                           r2suc, 
                           r2mda, 
                           r2pap, 
                           r2tope,
                           r2rub, 
                           r011cd,
                           r011mo,
                           r011su,
                           r011tr,
                           r011re,
                           r011fc,
                           r011or,
                           r011sb,
                           r011co
                          ) 
                   values(1,
                          21,
                          ln_scsuc,
                          P_N_MDACTA,
                          0,
                          P_N_CTACLI,
                          0,
                          p_n_scsbop,
                          P_N_TIPOPE,
                          5,
                          1,
                          P_N_CTACLI,
                          to_number(to_char(ld_fecdes,'rrrrmmdd')),
                          ln_grupo,
                          0,
                          1,
                          0,0,0,0,0,0,0,0,0,0,
                          ld_fecpro,
                          0,
                          0,
                          'S'
                          );
        exception
        when others then                        
          p_c_deserr := substr('10-'||sqlerrm,1,100);    
          return;
        end;
    End If;        
    ln_grupo := ln_grupox;    
    If ln_grupo not in (1,511) then       
       For x in c_integrantes loop
          --insertamos en la FSR011
          begin
          insert into FSR011(r1cod, 
                             r1mod, 
                             r1suc, 
                             r1mda, 
                             r1pap, 
                             r1cta, 
                             r1oper,
                             r1sbop,
                             r1tope,
                             relcod,
                             r2mod, 
                             r2cta, 
                             r2oper,
                             r2sbop,
                             r1rub, 
                             r2cod, 
                             r2suc, 
                             r2mda, 
                             r2pap, 
                             r2tope,
                             r2rub, 
                             r011cd,
                             r011mo,
                             r011su,
                             r011tr,
                             r011re,
                             r011fc,
                             r011or,
                             r011sb,
                             r011co
                            ) 
                     values(1,
                            21,
                            ln_scsuc,
                            P_N_MDACTA,
                            0,
                            P_N_CTACLI,
                            0,
                            p_n_scsbop,
                            P_N_TIPOPE,
                            5,
                            1,
                            P_N_CTACLI,
                            to_number(to_char(ld_fecdes,'rrrrmmdd')),
                            ln_grupo,
                            0,
                            1,
                            0,0,0,0,0,0,0,0,0,0,
                            ld_fecpro,
                            0,
                            0,
                            'S'
                            );
          ln_grupo := ln_grupo + 1;
          if ln_grupo = 511 then                   
             ln_grupo := ln_grupo + 1;
          End if;  
          exception
          when others then                        
            p_c_deserr := substr('10a-'||sqlerrm,1,100);    
            return;
          end;  
        end loop;              
    end if; 
      
    --registramos empleador
    if P_N_TIPOPE in (2,6) then
       --insertamos en la FSR011
        begin
        insert into FSR011(r1cod, 
                           r1mod, 
                           r1suc, 
                           r1mda, 
                           r1pap, 
                           r1cta, 
                           r1oper,
                           r1sbop,
                           r1tope,
                           relcod,
                           r2mod, 
                           r2cta, 
                           r2oper,
                           r2sbop,
                           r1rub, 
                           r2cod, 
                           r2suc, 
                           r2mda, 
                           r2pap, 
                           r2tope,
                           r2rub, 
                           r011cd,
                           r011mo,
                           r011su,
                           r011tr,
                           r011re,
                           r011fc,
                           r011or,
                           r011sb,
                           r011co
                          ) 
                   values(1,
                          0,
                          0,
                          0,
                          0,
                          P_N_CUEEMP,
                          0,
                          0,
                          0,
                          45,
                          p_n_scmod,
                          p_n_sccta,
                          p_n_scoper,
                          p_n_scsbop,
                          null,
                          p_n_pgcod,
                          p_n_scsuc,
                          p_n_scmda,
                          p_n_scpap,
                          p_n_sctope,
                          to_number('21'||lc_moneda||'201'||lc_sector||'00001'),--rubro
                          0,0,0,0,0,ld_fecpro,0,0,
                          'S'
                          );
        exception
        when others then                        
          p_c_deserr := substr('11-'||sqlerrm,1,100);    
          return;
        end;      
    End If;  
    /*
    --verificamos si es 18-25 años y es apertura tipo 1
    if P_N_TIPOPE = 1 then
      begin
        -- Call the procedure
        pq_ah_comision.sp_valida_edad_18_25(p_n_codpgc => p_n_pgcod,
                                            p_n_numcta => p_n_sccta,
                                            p_c_valida => lv_valida,
                                            p_d_fecfin => ld_fecfin
                                            );
      Exception
      when others then                                      
           p_c_deserr := substr('12-'||sqlerrm,1,100);    
           return;      
      end;
      if lv_valida = 'S' then
       begin
         insert into JAQL485(JAQL485PGE,
                             JAQL485SUC,
                             JAQL485CTA,
                             JAQL485MOD,
                             JAQL485MDA,
                             JAQL485PAP,
                             JAQL485OPE,
                             JAQL485SBO,
                             JAQL485TOP,
                             JAQL485TCO,
                             JAQL485CNV,
                             JAQL485CNA,
                             JAQL485CNC,
                             JAQL485CNH,
                             JAQL485FEI,
                             JAQL485FEF,
                             JAQL485FEC,
                             JAQL485USC,
                             JAQL485HCR,
                             JAQL485AX1
                            ) 
                      values(p_n_pgcod,  
                             p_n_scsuc,  
                             p_n_sccta,
                             p_n_scmod,  
                             p_n_scmda,  
                             p_n_scpap,                                 
                             p_n_scoper, 
                             p_n_scsbop, 
                             p_n_sctope,
                             2,
                             1,
                             1,
                             1,
                             0,
                             ld_fecpro,
                             ld_fecfin,
                             ld_fecpro,
                             P_C_CODUSU,
                             to_char(sysdate,'HH24:mi:ss'),
                             4
                            );
       exception
       when dup_val_on_index then   
         update JAQL485 
            set JAQL485FEF = ld_fecfin,
                JAQL485FEM = ld_fecpro,
                JAQL485USM = P_C_CODUSU,
                JAQL485HMD = to_char(sysdate,'HH24:mi:ss'),
                JAQL485AX1 = 4
          where JAQL485PGE = p_n_pgcod                                   
            and JAQL485SUC = p_n_scsuc                               
            and JAQL485CTA = p_n_sccta                               
            and JAQL485MOD = p_n_scmod                             
            and JAQL485MDA = p_n_scmda                                
            and JAQL485PAP = p_n_scpap                                  
            and JAQL485OPE = p_n_scoper                               
            and JAQL485SBO = p_n_scsbop                                 
            and JAQL485TOP = p_n_sctope                                
            and JAQL485TCO = 2; --COMISION POR MANTENIMIENTO 
       When Others then  
           p_c_deserr := substr('13-'||sqlerrm,1,100);    
           return;           
       end;
        --ACTUALIZAMOS FSE013
        begin
          update FSE013 
             set Cvcspr = 'N'
           where PgCod  = p_n_pgcod     
             and Cvsuc  = p_n_scsuc        
             and Cvcta  = p_n_sccta       
             and Cvmod  = p_n_scmod       
             and Cvmda  = p_n_scmda      
             and Cvpap  = p_n_scpap    
             and Cvoper = p_n_scoper       
             and Cvsbop = p_n_scsbop     
             and Cvtope = p_n_sctope;                
        end;       
      End IF;  
    End If;
    */
    
    --BUSCAMOS EJECUTIVO
    Begin
     Select Tpnro
       into ln_VarMes 
       from fst098
      Where PgCod  = p_n_pgcod
        and Tpcod  = 7636
        and Tpcorr = 2;      
    Exception
    When No_data_found then
      ln_VarMes := 0;  
    When others then 
         p_c_deserr := substr('14-'||sqlerrm,1,100);    
         return;        
    End;
    ln_VarMes := ln_VarMes*-1;
    ld_FecIni := Add_months(ld_fecpro, ln_VarMes);
    
    --VERIFICAMOS PARA CADA TITULAR SI ALGUNO HA SIDO CONTACTADO
    For i in c_integrantes  loop
      if i.ttcod = 1 then
        lc_usuario := 'X';
        ln_pais    := i.pepais;
        ln_petdoc  := i.petdoc;
        lc_pendoc  := i.pendoc;
        
        begin
          Select qq.JAQL108Usu
            into lc_usuario
            from (
                    Select *             
                      from jaql108 
                     where JAQL108Pai = ln_pais
                       and JAQL108Ptd = ln_petdoc
                       and JAQL108Doc = lc_pendoc
                       and JAQL108Fch between ld_FecIni and ld_fecpro
                  order by JAQL108Pai, 
                           JAQL108Ptd, 
                           JAQL108Doc, 
                           JAQL108Fch, 
                           JAQL108Hra
                 ) qq
            where rownum < 2;                          
        exception
        when no_data_found then
           lc_usuario := 'X';
        when others then    
           p_c_deserr := substr('15-'||sqlerrm,1,100);    
           return;           
        end;
        
        if trim(lc_usuario) <> 'X' then
          exit;
        end if;        
      End If;  
    End loop;
    if trim(lc_usuario) <> 'X' then
      begin
        Select AgteCod
          into ln_AGTECOD 
          from fst156
         where AgteUsr = lc_usuario;
      exception
      when others then  
        ln_AGTECOD := 0;
      end;      
    End If;  
    
    if P_N_TIPOPE <> 9 then
      if ln_AgteCod <> 0 then
        begin
          insert into fsr012(P1cod, 
                             P1mod,
                             P1suc,
                             P1mda,
                             P1pap, 
                             P1cta, 
                             P1oper,
                             P1sbop,
                             P1tope,
                             Relcod,
                             P1pais,
                             P1tdoc,
                             P1ndoc,
                             P1porc
                            )                                                         
                     values (p_n_pgcod, 
                             p_n_scmod, 
                             p_n_scsuc,                                                          
                             p_n_scmda, 
                             p_n_scpap, 
                             p_n_sccta,                               
                             p_n_scoper,
                             p_n_scsbop,
                             p_n_sctope,
                             77,
                             0,
                             0,
                             to_char(ln_AgteCod),
                             0
                             );
        exception 
        when others then 
           p_c_deserr := substr('16-'||sqlerrm,1,100);    
           return;              
        end;
      end if; 
      begin
/*        -- Call the procedure
        sp_ah_apercuenta(ln_cuenta => p_n_sccta,
                         ln_supope => p_n_scsbop,
                         ln_tipope => p_n_sctope,
                         ln_sucurs => p_n_scsuc,
                         ln_modulo => p_n_scmod,
                         ln_moneda => p_n_scmda,
                         ln_papel  => p_n_scpap,
                         ln_oper   => p_n_scoper,
                         ln_agente => ln_AgteCod
                         );*/
                         
          select count(*) 
            into estrab 
            from fsr008 
           where pgcod = 1 
             and ctnro = p_n_sccta 
             and  EXISTS(SELECT 1 from fsd009 where tgcod=4 and grnro=22001 and pgcod=1  and ctnro=p_n_sccta) ;


          if estrab>0 then
            
            select count(*) into cantidad from fsr008 where pgcod=1 and ctnro = p_n_sccta;
            
            if cantidad = 1 then
                     
                    insert into jaql482
                      (JAQL482CCT,
                       JAQL482PGE,
                       JAQL482SUC,
                       JAQL482CTA,
                       JAQL482MOD,
                       JAQL482MDA,
                       JAQL482PAP,
                       JAQL482OPE,
                       JAQL482SBO,
                       JAQL482TOP,
                       JAQL482FEI,
                       JAQL482FEF,
                       JAQL482FEC,
                       JAQL482FEM,
                       JAQL482USC,
                       JAQL482USM,
                       JAQL482HCR,
                       JAQL482HMD,
                       JAQL482AX1,
                       JAQL482AX2,
                       JAQL482AX3,
                       JAQL482AX4,
                       JAQL482AX5,
                       JAQL482AX6,
                       JAQL482AX7,
                       JAQL482AX8,
                       JAQL482AX9)
                      select 4,
                             a.pgcod,
                             a.scsuc,
                             a.sccta,
                             a.scmod,
                             a.scmda,
                             a.scpap,
                             a.scoper,
                             a.scsbop,
                             a.sctope,
                             trunc(sysdate),
                             trunc(sysdate + 2),
                             trunc(sysdate),
                             to_date('01010001', 'ddmmyyyy'),
                             'BANTOTAL',
                             null,
                             to_char(systimestamp, 'hh24:mi:ss'),
                             null,
                             1,
                             0,
                             0.00,
                             0.00,
                             to_date('01010001', 'ddmmyyyy'),
                             to_date('01010001', 'ddmmyyyy'),
                             null,
                             null,
                             null
                        from fsd011 a
                       where pgcod = 1
                         and scmod = 21
                         and sccta = p_n_sccta
                         and scsbop = p_n_scsbop
                         and sctope = p_n_sctope
                         and scstat < 99;
                    
                    insert into jaql482
                      (JAQL482CCT,
                       JAQL482PGE,
                       JAQL482SUC,
                       JAQL482CTA,
                       JAQL482MOD,
                       JAQL482MDA,
                       JAQL482PAP,
                       JAQL482OPE,
                       JAQL482SBO,
                       JAQL482TOP,
                       JAQL482FEI,
                       JAQL482FEF,
                       JAQL482FEC,
                       JAQL482FEM,
                       JAQL482USC,
                       JAQL482USM,
                       JAQL482HCR,
                       JAQL482HMD,
                       JAQL482AX1,
                       JAQL482AX2,
                       JAQL482AX3,
                       JAQL482AX4,
                       JAQL482AX5,
                       JAQL482AX6,
                       JAQL482AX7,
                       JAQL482AX8,
                       JAQL482AX9)
                      select 5,
                             a.pgcod,
                             a.scsuc,
                             a.sccta,
                             a.scmod,
                             a.scmda,
                             a.scpap,
                             a.scoper,
                             a.scsbop,
                             a.sctope,
                             trunc(sysdate),
                             trunc(sysdate + 2),
                             trunc(sysdate),
                             to_date('01010001', 'ddmmyyyy'),
                             'BANTOTAL',
                             null,
                             to_char(systimestamp, 'hh24:mi:ss'),
                             null,
                             1,
                             0,
                             0.00,
                             0.00,
                             to_date('01010001', 'ddmmyyyy'),
                             to_date('01010001', 'ddmmyyyy'),
                             null,
                             null,
                             null
                        from fsd011 a
                       where pgcod = 1
                         and scmod = 21
                         and sccta = p_n_sccta
                         and scsbop = p_n_scsbop
                         and sctope = p_n_sctope
                         and scstat < 99;
                
                    insert into jaql482
                      (JAQL482CCT,
                       JAQL482PGE,
                       JAQL482SUC,
                       JAQL482CTA,
                       JAQL482MOD,
                       JAQL482MDA,
                       JAQL482PAP,
                       JAQL482OPE,
                       JAQL482SBO,
                       JAQL482TOP,
                       JAQL482FEI,
                       JAQL482FEF,
                       JAQL482FEC,
                       JAQL482FEM,
                       JAQL482USC,
                       JAQL482USM,
                       JAQL482HCR,
                       JAQL482HMD,
                       JAQL482AX1,
                       JAQL482AX2,
                       JAQL482AX3,
                       JAQL482AX4,
                       JAQL482AX5,
                       JAQL482AX6,
                       JAQL482AX7,
                       JAQL482AX8,
                       JAQL482AX9)
                      select 6,
                             a.pgcod,
                             a.scsuc,
                             a.sccta,
                             a.scmod,
                             a.scmda,
                             a.scpap,
                             a.scoper,
                             a.scsbop,
                             a.sctope,
                             trunc(sysdate),
                             trunc(sysdate + 2),
                             trunc(sysdate),
                             to_date('01010001', 'ddmmyyyy'),
                             'BANTOTAL',
                             null,
                             to_char(systimestamp, 'hh24:mi:ss'),
                             null,
                             1,
                             0,
                             0.00,
                             0.00,
                             to_date('01010001', 'ddmmyyyy'),
                             to_date('01010001', 'ddmmyyyy'),
                             null,
                             null,
                             null
                        from fsd011 a
                       where pgcod = 1
                         and scmod = 21
                         and sccta = p_n_sccta
                         and scsbop = p_n_scsbop
                         and sctope = p_n_sctope
                         and scstat < 99;

            end if;
          end if;
          bEGIN
            SELECT SYSDATE INTO FECHA_COMP FROM DUAL;
                INSERT INTO JAQY679 (JAQY679MOD,
                                    JAQY679SUC,
                                    JAQY679MDA,
                                    JAQY679PAP,
                                    JAQY679CTA,
                                    JAQY679OPER,
                                    JAQY679SBOP,
                                    JAQY679TOPE,
                                    JAQY679FECH,
                                    JAQY679AGEN)
                             VALUES(p_n_scmod,
                                    p_n_scsuc,
                                    p_n_scmda,
                                    p_n_scpap,
                                    p_n_sccta,
                                    p_n_scoper,
                                    p_n_scsbop,
                                    p_n_sctope,
                                    FECHA_COMP,
                                    ln_AgteCod                            
                                    );
                       COMMIT;             
                                   
          EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
              NULL;
          END;                          
      end; 
      lc_texto1 := to_char(ld_fecini,'dd/mm/rrrr')||' '||to_char(ld_fecpro,'dd/mm/rrrr')||' '||'Valor:'||' '||'Usu:'||lc_usuario;      
      begin
          update jaqy679 
             set JAQY679AUX4 = lc_texto1
           where JAQY679MOD  = p_n_scmod
             and JAQY679SUC  = p_n_scsuc
             and JAQY679MDA  = p_n_scmda
             and JAQY679PAP  = p_n_scpap
             and JAQY679CTA  = p_n_sccta
             and JAQY679OPER = p_n_scoper
             and JAQY679SBOP = p_n_scsbop
             and JAQY679TOPE = p_n_sctope;        
      end;
    End If;  
    
    --ADICIONAMOS LA CUENTA A LA TABLA DE HOME BANKING ASOCIADA A LA TARJETA VIGENTE
    For i in c_integrantes  loop    
      ln_pais    := i.pepais;
      ln_petdoc  := i.petdoc;
      lc_pendoc  := i.pendoc;      
      begin
        Select Z0E478NRO 
          into lc_numtar
          from z0e478 
         where Z0E478THP = ln_pais
           and Z0E478THT = ln_petdoc
           and Z0E478THD = lc_pendoc   
           and Z0E478EST = 'AC';                     
           lc_flag := 'S';
      Exception
      When no_data_found then
         lc_flag := 'N'; 
      When others then  
         lc_numtar := '';  
         lc_flag   := 'N';
      end;
      if lc_flag = 'S' then
          begin
             insert into CNL002(CNL000Cod,
                                CNL001Adm,
                                CNL001Usu,
                                CNL002PGC,        
                                CNL002MOD,
                                CNL002TOP,
                                CNL002SUC,
                                CNL002MDA,
                                CNL002PAP,
                                CNL002OPE,   
                                CNL002CTA,
                                CNL002SBO,
                                CNL008Cod,    
                                CNL002HAB,
                                CNL002IMa,
                                CNL002NCT
                                )
                          values(5,
                                lc_numtar,
                                lc_numtar,
                                p_n_pgcod,
                                p_n_scmod,
                                p_n_sctope,
                                p_n_scsuc,
                                p_n_scmda,
                                p_n_scpap,
                                p_n_scoper,
                                p_n_sccta,                            
                                p_n_scsbop,
                                0,
                                'S',
                                0,
                                ''
                                );                  
          Exception
          When others then  
               p_c_deserr := substr('17-'||sqlerrm,1,100);    
               return;     
          end;  
      end if;          
    end loop;
    
    p_n_tipape := 1; --nuevo
    if P_N_TIPOPE = 6 then  
      lc_indtra := '06';
    End If;     
    if P_N_TIPOPE = 2 or P_N_TIPOPE = 6 then   
      if lc_indtra = '02' or lc_indtra = '06' then     
         if lc_indtra = '06' then
          --Obtener pais, tipo documento y numero de documento
          begin 
            select g.Pepais,
            g.Petdoc,
            g.Pendoc
            into 
            lc_pais,
            lc_tipo,
            lc_numero
            from fsr008 g
            where g.pgcod = p_n_pgcod
            and g.ctnro   = P_N_CTACLI
            and g.cttfir  = 'T';
          end;
         End If;           
    	   --Obtener parametrizacion de moneda y empleador          
         begin
           select z.Tp1nro2
             into ln_R1cta
             from fst198 z
            where z.Tp1cod   = 1
              and z.Tp1cod1  = 10825
              and z.Tp1corr1 = 103
              and z.Tp1corr2 = 1
              and z.Tp1nro1  = p_n_scmda;  
         exception 
         when others then      
           ln_R1cta := 0;  
         end;
         --verificamos el empleador    
           
         begin
           select 'S'
             into Flag2
             from FSR011 c
            Where c.R2cod   = p_n_pgcod
              and c.R2mod   = p_n_scmod
              and c.R2suc   = p_n_scsuc
              and c.R2mda   = p_n_scmda
              and c.R2pap   = p_n_scpap
              and c.R2cta   = p_n_sccta
              and c.R2oper  = p_n_scoper
              and c.R2sbop  = p_n_scsbop
              and c.R2tope  = p_n_sctope
              and c.Relcod  = 45
              and c.R1cod   = p_n_pgcod
              and c.R1cta   = ln_R1cta
              and c.R011co  = 'S';
         exception 
         when others then      
           Flag2 := 'N';   
         end;
       
        if Flag2 = 'S' then     
          sp_ah_envio_adenda(p_n_pgcod  => p_n_pgcod,
                             p_n_scmod  => p_n_scmod,
                             p_n_scsuc  => p_n_scsuc,
                             p_n_scmda  => p_n_scmda,
                             p_n_scpap  => p_n_scpap,
                             p_n_sccta  => p_n_sccta,
                             p_n_scoper => p_n_scoper,
                             p_n_scsbop => p_n_scsbop,
                             p_n_sctope => p_n_sctope,
                             p_n_codpai => lc_pais,   
                             p_n_tipdoc => lc_tipo,   
                             p_c_numdoc => trim(lc_numero), 
                             p_c_codest => 'X',
                             p_d_fecpro => P_D_FECPRO,
                             p_c_codusu => trim(P_C_CODUSU),
                             p_n_codage => P_N_CODAGE,
                             p_c_coderr => lc_coderr,
                             p_c_msgerr => lc_msgerr
                             ); 
        End if;                           
      End if;                              
    End If; 
    --CAMPAÑA APERTURA POR QR
    if P_N_TIPOPE in (12) then --DIGITAL
      if TRIM(P_C_CODUSU)  = 'USRQRCAM' then /*YLOZADA 31/02/2021*/   
        --OBTENEMOS FECHA FIN DE EXONERACION DE COMISIONES
        begin
          Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
            into ld_fecfin
            from fst198 a
           where a.tp1cod   = 1
             and a.tp1cod1  = 11147
             and a.tp1corr1 = 1
             and a.tp1corr2 = 4
             and a.tp1corr3 = 2;
        exception
        when others then
          ld_fecfin := null;      
        end;    
        if ld_fecfin is not null then     
          --EXONERAMOS COMISIONES DE INTERPLAZA Y EXCESO DE OPERACIONES
          for i in c_comisiones loop
            for j in c_canales loop
              begin
               insert into JAQL485(JAQL485PGE, 
                                   JAQL485SUC,
                                   JAQL485CTA,
                                   JAQL485MOD,
                                   JAQL485MDA,
                                   JAQL485PAP,
                                   JAQL485OPE,
                                   JAQL485SBO,
                                   JAQL485TOP,
                                   JAQL485TCO,
                                   JAQL485CNV,
                                   JAQL485CNA,
                                   JAQL485CNC,
                                   JAQL485CNH,
                                   JAQL485FEI,
                                   JAQL485FEF,
                                   JAQL485FEC,
                                   JAQL485USC,
                                   JAQL485HCR,
                                   JAQL485AX1,
                                   JAQL485AX2
                                   )
                            values(p_n_pgcod, 
                                   p_n_scsuc, 
                                   p_n_sccta,
                                   p_n_scmod,                                    
                                   p_n_scmda, 
                                   p_n_scpap,                                     
                                   p_n_scoper,
                                   p_n_scsbop,
                                   p_n_sctope,
                                   i.aqpa109com,
                                   0,
                                   0,
                                   0,
                                   0,
                                   P_D_FECPRO,
                                   ld_fecfin,
                                   P_D_FECPRO,
                                   decode(trim(P_C_CODUSU),null,'BANTOTAL',RPAD(P_C_CODUSU,10,' ')),
                                   TO_CHAR(sysdate,'HH24:mi:ss'),
                                   1,
                                   j.aqpa109ccan                                 
                                   );  
              exception
              when others then
                null;
              end;   
            end loop;
          end loop;
        end if;
      End if;
    end if;
    
    --CAMPAÑA APERTURA DIGITAL 14/06/2021
    if P_N_TIPOPE in (12) then --DIGITAL
      if TRIM(P_C_CODUSU)  in ('USRMOVIL','NSBTUSER') then /*YLOZADA 10/06/2021*/   
        IF P_N_MDACTA = 0 THEN
          --OBTENEMOS RANGOS DE FECHA DE APERTURAS
          begin
            Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
              into ld_fecini
              from fst198 a
             where a.tp1cod   = 1
               and a.tp1cod1  = 10801
               and a.tp1corr1 = 62
               and a.tp1corr2 = 2
               and a.tp1corr3 = 2;
          exception
          when others then
            ld_fecini := null;      
          end; 
          
          begin
            Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
              into ld_fecfin
              from fst198 a
             where a.tp1cod   = 1
               and a.tp1cod1  = 10801
               and a.tp1corr1 = 62
               and a.tp1corr2 = 3
               and a.tp1corr3 = 2;
          exception
          when others then
            ld_fecfin := null;      
          end; 
        ELSE
          --OBTENEMOS RANGOS DE FECHA DE APERTURAS
          begin
            Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
              into ld_fecini
              from fst198 a
             where a.tp1cod   = 1
               and a.tp1cod1  = 10801
               and a.tp1corr1 = 62
               and a.tp1corr2 = 12
               and a.tp1corr3 = 2;
          exception
          when others then
            ld_fecini := null;      
          end; 
          
          begin
            Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
              into ld_fecfin
              from fst198 a
             where a.tp1cod   = 1
               and a.tp1cod1  = 10801
               and a.tp1corr1 = 62
               and a.tp1corr2 = 13
               and a.tp1corr3 = 2;
          exception
          when others then
            ld_fecfin := null;      
          end;                     
        END IF;
        
        if P_D_FECPRO BETWEEN ld_fecini and ld_fecfin then               
            IF P_N_MDACTA = 0 THEN
              begin
                Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
                  into ld_fecfin
                  from fst198 a
                 where a.tp1cod   = 1
                   and a.tp1cod1  = 10801
                   and a.tp1corr1 = 62
                   and a.tp1corr2 = 14
                   and a.tp1corr3 = 2;
              exception
              when others then
                ld_fecfin := null;      
              end;    
            ELSE
              begin
                Select to_date(trim(a.tp1desc),'dd/mm/rrrr')
                  into ld_fecfin
                  from fst198 a
                 where a.tp1cod   = 1
                   and a.tp1cod1  = 10801
                   and a.tp1corr1 = 62
                   and a.tp1corr2 = 4
                   and a.tp1corr3 = 2;
              exception
              when others then
                ld_fecfin := null;      
              end;                
            END IF;
            if ld_fecfin is not null then     
              --EXONERAMOS COMISION DE EXCESO DE OPERACIONES
              for i in c_comisiones_cam loop
                for j in c_canales_cam loop
                  begin
                   insert into JAQL485(JAQL485PGE, 
                                       JAQL485SUC,
                                       JAQL485CTA,
                                       JAQL485MOD,
                                       JAQL485MDA,
                                       JAQL485PAP,
                                       JAQL485OPE,
                                       JAQL485SBO,
                                       JAQL485TOP,
                                       JAQL485TCO,
                                       JAQL485CNV,
                                       JAQL485CNA,
                                       JAQL485CNC,
                                       JAQL485CNH,
                                       JAQL485FEI,
                                       JAQL485FEF,
                                       JAQL485FEC,
                                       JAQL485USC,
                                       JAQL485HCR,
                                       JAQL485AX1,
                                       JAQL485AX2
                                       )
                                values(p_n_pgcod, 
                                       p_n_scsuc, 
                                       p_n_sccta,
                                       p_n_scmod,                                    
                                       p_n_scmda, 
                                       p_n_scpap,                                     
                                       p_n_scoper,
                                       p_n_scsbop,
                                       p_n_sctope,
                                       i.aqpa109com,
                                       0,
                                       0,
                                       0,
                                       0,
                                       P_D_FECPRO,
                                       ld_fecfin,
                                       P_D_FECPRO,
                                       decode(trim(P_C_CODUSU),null,'BANTOTAL',RPAD(P_C_CODUSU,10,' ')),
                                       TO_CHAR(sysdate,'HH24:mi:ss'),
                                       4,
                                       j.aqpa109ccan                                 
                                       );  
                  exception
                  when others then
                    null;
                  end;   
                end loop;
              end loop;
            end if;
          End if;
        End if;  
    End if;      
    if P_N_COMMIT = 1 then
       commit;
    end if;
    --
    --VALIDAMOS ALERTA PARA EXPERIENCIA AL CLIENTE
    --    
    -- Call the procedure
    /*
    --
    --Verificamos tabla AQPA705 para saber que tipo de apertura fue, si HB, APP,KIOSKO, MASIVA
    --
   
    begin
      select a.pepais,a.petdoc,a.pendoc       
        into ln_pais,ln_petdoc,lc_pendoc      
       from fsr008 a 
      where a.pgcod = 1 
        and a.ctnro = P_N_CTACLI
        and a.ttcod = 1
        and a.cttfir = 'T'; 
    Exception
    when others then 
      ln_pais   := 604;
      ln_petdoc := 21;
      lc_pendoc := '';
    end;    
        
    begin
      select decode(trim(substr(trim(x.aqpa705auxv5),1,30)),'APP','CAJA MOVIL','HB','BCA INTERNET',trim(substr(trim(x.aqpa705auxv5),1,30)))
        into lv_canal             
        from aqpa705 x
       where x.aqpa705pdoc   = ln_pais
         and x.aqpa705tdoc   = ln_petdoc
         and x.aqpa705ndoc   = lc_pendoc
         and x.aqpa705tipope = 'A'
         and x.aqpa705fectra = P_D_FECPRO
         and x.aqpa705ctaori = lpad(P_N_CTACLI,9,'0')||lpad(p_n_scmod,3,'0')||lpad(p_n_scmda,3,'0')||lpad(p_n_scsbop,2,'0')||lpad(p_n_sctope,3,'0')
         and rownum <2;
    Exception
    when others then 
      lv_canal := 'VENTANILLA';
    end;
    */
    if TRIM(P_C_CODUSU) in ('USRMOVIL','NSBTUSER','USRQRCAM') THEN
      lv_canal := 'DIGITAL';
    Else
      lv_canal := 'VENTANILLA';
    End If;
    pq_cl_alertas.sp_cl_alertas(p_n_numcta => P_N_CTACLI,
                                p_d_fecpro => P_D_FECPRO,
                                p_c_tippro => 'A',
                                P_C_CANAL  => lv_canal,
                                P_C_CODUSU => P_C_CODUSU                                                                
                                );    
   --FIN EXPERIENCIA AL CLIENTE                                
  else
    p_n_tipape := 2; --existente  
  End if;

exception
when others then
      p_c_deserr := substr('18-'||sqlerrm,1,100);    
      return;
end SP_AH_GENERA_PRODUCTO_AH;
/
