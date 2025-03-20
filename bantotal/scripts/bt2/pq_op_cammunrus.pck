create or replace package PQ_OP_CAMMUNRUS is

  PROCEDURE SP_REG_OPC_COMPRA(PD_FECINI DATE,PD_FECFIN DATE);
  FUNCTION FN_CL_VALEMPFAM (P_N_NUMCTA IN number) RETURN number;
  PROCEDURE SP_CAMBIO_TARJETA(PD_FECINI DATE,PD_FECFIN DATE);
  FUNCTION FN_AH_VALCTA (P_C_NUMTAR IN varchar2
                      ) RETURN number;
  FUNCTION FN_CL_VALCTA (P_C_NUMTAR IN varchar2
                      ) RETURN number;                      
  FUNCTION FN_AH_VALCTACOM (P_N_CODSUC IN number,
                          P_N_CODCTA IN number,
                          P_N_CODMON IN number,
                          P_N_CODPAP IN number,
                          P_N_CODOPE IN number,
                          P_N_CODTOP IN number,
                          P_N_CODMOD IN number
                      ) RETURN number;
end PQ_OP_CAMMUNRUS;
/

create or replace package body PQ_OP_CAMMUNRUS is


PROCEDURE SP_REG_OPC_COMPRA(PD_FECINI DATE,PD_FECFIN DATE) AS
  -- *****************************************************************
  -- Nombre                     : SP_REG_OPC_COMPRA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CAMPAÑA RUSIA 2018
  -- Versión                    : 1.0
  -- Fecha de Creación          : 17/04/2018
  -- Autor de Creación          : WCRW
  -- Uso                        : Registra Opciones por compra mayor a S/.80
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Modificación      : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

BEGIN
  insert into jaql406 (JAQL406CUP,JAQL406PGC,JAQL406MOD,JAQL406SUC,JAQL406MDA,JAQL406PAP,JAQL406CTA,
                     JAQL406OPE,JAQL406SBO,JAQL406TOP,JAQL406CRE,JAQL406FEC,JAQL406FOP,JAQL406EST,
                     JAQL406USR,JAQL406AGE,JAQL406DPT,JAQL406ANT,JAQL406ATR,JAQL406CAL,JAQL406TIP,
                     JAQL406EXCUP,JAQL406TSBOR,JAQL406TORD,JAQL406TNREL,JAQL406TTRAN,JAQL406TMOD,
                     JAQL406TSUC,JAQL406FCTA,JAQL406NUMP,JAQL406CUPNUM,JAQL406OPC)
     select SQ_CR_JAQL406_1.NEXTVAL,r.pgcod,r.hmodul,r.hsucur,0,0,r.hctad,
            r.hoperd,r.hsubop,r.htoper,r.jaql540nutar,r.jaql540feini,r.hfcon,'S',
            r.huscnf,903,'','N',0,0,'C',
            'C',0,0,r.jaql540relac,r.jaql540trans,r.jaql540modul,903,'01/01/0001',0,1,1 
       from (select d.pgcod,d.hmodul,d.hsucur,d.hcta hctad,d.hoper hoperd,
                    d.hsubop,d.htoper,a.jaql540nutar,a.jaql540feini,d.hfcon,c.huscnf,
                    a.jaql540modul,a.jaql540trans,a.jaql540relac
               from jaql540 a,jaql539 b,fsh015 c,fsh016 d
              where a.jaql540feini >= PD_FECINI
                and a.jaql540feini <= PD_FECFIN
                and substr(a.jaql540cotrx,1,2) = '00'
                and a.jaql540cores = '00'
                and a.jaql540cotra = b.jaql539cotra
                and b.jaql539nucam = 4
                and to_number(b.jaql539valtr) / 100 > 80
                and (select to_number(jaql539valtr) 
                       from jaql539 
                      where jaql539cotra = a.jaql540cotra
                        and jaql539nucam = 49) = 604
                and c.pgcod = 1
                and c.pgcod= d.pgcod
                and c.hsucor = d.hsucor
                and c.hcmod= d.hcmod
                and c.htran = d.htran
                and c.hnrel = d.hnrel
                and c.hfcon = d.hfval
                and d.hcord = 10
                and c.hfcon = a.jaql540feini
                and c.hsucor = 903
                and c.hcmod= a.jaql540modul
                and c.htran = a.jaql540trans
                and c.hnrel = a.jaql540relac
                and PQ_OP_CAMMUNRUS.FN_CL_VALEMPFAM (d.hcta) = 0
                and (d.pgcod,d.hmodul,d.hsucur,d.hcta,d.hoper,
                         d.hsubop,d.htoper,a.jaql540nutar,a.jaql540feini,
                         a.jaql540modul,a.jaql540trans,a.jaql540relac) not in
                    (select jaql406pgc,jaql406mod,jaql406suc,jaql406cta,jaql406ope,jaql406sbo,jaql406top,
                            jaql406cre,jaql406fec,jaql406tmod,jaql406ttran,jaql406tnrel
                       from jaql406
                      where jaql406pgc = d.pgcod 
                        and jaql406mod = d.hmodul
                        and jaql406suc = d.hsucur
                        and jaql406cta = d.hcta
                        and jaql406ope = d.hoper
                        and jaql406sbo = d.hsubop
                        and jaql406top = d.htoper
                        and jaql406cre = a.jaql540nutar
                        and jaql406fec = a.jaql540feini
                        and jaql406tmod = a.jaql540modul
                        and jaql406ttran = a.jaql540trans
                        and jaql406tnrel = a.jaql540relac
                        and jaql406tip = 'C')
             order by a.jaql540cotra) r;
   commit;
END SP_REG_OPC_COMPRA;

FUNCTION FN_CL_VALEMPFAM (P_N_NUMCTA IN number
                                     ) RETURN number is
  ln_numcta number := 0;
  ln_codemp integer := 0;
begin
   
   begin
   --Juridica
      select distinct x.pgcod, x.ctnro
        into ln_codemp,ln_numcta
        from fsr008 x, fsd001 y
       where x.pgcod = 1
        and x.ctnro = P_N_NUMCTA
        and x.pepais = y.pepais
        and x.petdoc = y.petdoc
        and x.pendoc = y.pendoc
        and y.petipo = 'J'; --
   EXCEPTION WHEN NO_DATA_FOUND then
       ln_numcta := 0;
   end;                     
   if ln_numcta <> 0 then
      RETURN ln_numcta;
   end if;   
   begin
      select distinct m.pgcod, m.ctnro
        into ln_codemp,ln_numcta
        from fsr008 m, fsd002 n
       where m.pgcod = 1
         and m.ctnro = P_N_NUMCTA
         and m.pepais = n.pfpais
         and m.petdoc = n.pftdoc
         and m.pendoc = n.pfndoc
         and n.pfebco = 'S'
         and m.ttcod = 1
         and m.cttfir = 'T';
   EXCEPTION WHEN NO_DATA_FOUND then
       ln_numcta := 0;
   end;    
   if ln_numcta <> 0 then
      RETURN ln_numcta;
   end if;                  
   begin
      select distinct m.pgcod,m.ctnro 
        into ln_codemp,ln_numcta
        from fsr008 m,fsd002 n,fsr002 o
       where m.pgcod = 1
         and m.ctnro = P_N_NUMCTA
         and m.pepais = o.rppais
         and m.petdoc = o.rptdoc
         and m.pendoc = o.rpndoc                
         and o.pepais = n.pfpais
         and o.petdoc = n.pftdoc
         and o.pendoc = n.pfndoc
         and n.pfebco = 'S'
         and m.ttcod  = 1
         and m.cttfir = 'T'
         and o.rpccyg in (69,71,66,63,70,68,67,75,89); --familiares de trabajadores
   EXCEPTION WHEN NO_DATA_FOUND then
       ln_numcta := 0;
   end;    
   if ln_numcta <> 0 then
      RETURN ln_numcta;
   end if;              
   begin
      select distinct m.pgcod,m.ctnro 
        into ln_codemp,ln_numcta
        from fsr008 m,fsd002 n,fsr002 o
       where m.pgcod = 1
         and m.ctnro = P_N_NUMCTA
         and m.pepais = o.pepais
         and m.petdoc = o.petdoc
         and m.pendoc = o.pendoc
         and o.rppais = n.pfpais
         and o.rptdoc = n.pftdoc
         and o.rpndoc = n.pfndoc
         and n.pfebco = 'S'
         and m.ttcod  = 1
         and m.cttfir = 'T'
         and o.rpccyg in (69,71,66,63,70,68,67,75,89); --familiares de trabajadores
   EXCEPTION WHEN NO_DATA_FOUND then
       ln_numcta := 0;
   end;    
   RETURN ln_numcta;
end FN_CL_VALEMPFAM;

procedure SP_CAMBIO_TARJETA(PD_FECINI DATE,PD_FECFIN DATE) is
  -- *****************************************************************
  -- Nombre                     : SP_CAMBIO_TARJETA
  -- Sistema                    : CAMPAÑA PERU RUMBO A RUSIA
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 21/03/2018
  -- Autor de Creación          : EBDC
  -- Uso                        : Clientes que han cambiado su tarjeta de Banda a Chip
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************
begin
  insert into jaql406 (JAQL406CUP,JAQL406PGC,JAQL406MOD,JAQL406SUC,JAQL406MDA,JAQL406PAP,JAQL406CTA,
                     JAQL406OPE,JAQL406SBO,JAQL406TOP,JAQL406CRE,JAQL406FEC,JAQL406FOP,JAQL406EST,
                     JAQL406USR,JAQL406AGE,JAQL406DPT,JAQL406ANT,JAQL406ATR,JAQL406CAL,JAQL406TIP,
                     JAQL406EXCUP,JAQL406TSBOR,JAQL406TORD,JAQL406TNREL,JAQL406TTRAN,JAQL406TMOD,
                     JAQL406TSUC,JAQL406FCTA,JAQL406NUMP,JAQL406CUPNUM,JAQL406OPC)
     select SQ_CR_JAQL406_1.NEXTVAL,1,0,0,0,0,0,
            0,0,0,r.z0e478nro,r.z0e478fal,r.z0e478fal,'S',
            r.z0e478uau,r.z0e478suc,'','N',0,0,'T',
            'C',0,0,0,0,0,r.z0e478suc,'01/01/0001',0,1,1 
       from (select a.z0e478nro,a.z0e478fal,a.z0e478uau,a.z0e478suc
               from z0e478 a 
              where a.z0e478est = 'AC'
                and a.z0e478fal >= PD_FECINI --'02/04/2018'
                and a.z0e478fal <= PD_FECFIN --'30/06/2018'
                and a.z0e468cod = 'E'
                and (a.z0e478thp,a.z0e478tht,a.z0e478thd) not in
                    (select z0e478thp, z0e478tht, z0e478thd
                       from z0e478
                      where z0e478fal between '01/01/2015' and '01/04/2018'
                        and z0e468cod = 'E')
                and (a.z0e478thp,a.z0e478tht,a.z0e478thd) in
                    (select z0e478thp, z0e478tht, z0e478thd
                       from z0e478
                      where z0e478fal < '01/01/2015'
                        and z0e468cod = 'E')
                and PQ_OP_CAMMUNRUS.FN_AH_VALCTA(a.z0e478nro) <> 0
                and (a.z0e478nro,a.z0e478fal,a.z0e478usr,a.z0e478suc) not in
                    (select jaql406cre,jaql406fec,jaql406usr,jaql406age
                       from jaql406
                      where jaql406pgc = 1
                        and jaql406mod = 0
                        and jaql406suc = 0
                        and jaql406cta = 0
                        and jaql406ope = 0
                        and jaql406sbo = 0
                        and jaql406top = 0
                        and jaql406cre = a.z0e478nro
                        and jaql406fec = a.z0e478fal
                        and jaql406usr = a.z0e478usr
                        and jaql406suc = a.z0e478suc
                        and jaql406tip = 'T')) r;
   commit;                        
end SP_CAMBIO_TARJETA;

FUNCTION FN_AH_VALCTA (P_C_NUMTAR IN varchar2
                      ) RETURN number is
  ln_numcta number := 0;
  ln_codemp integer := 1;
  ln_codres integer := 1;
begin
   
   begin
      
   select distinct a.z0e479cta
       into ln_numcta
     from z0e479 a,fsd011 b
    where a.z0e478nro = P_C_NUMTAR
      and b.pgcod = ln_codemp
      and b.scsuc = a.z0e479suc
      and b.sccta = a.z0e479cta
      and b.scmda = a.z0e479mon
      and b.scpap = a.z0e479pap
      and b.scoper = a.z0e479ope
      and b.sctope = a.z0e479top
      and b.scmod = a.z0e479mod
      and b.scstat <> 99
      and ROWNUM = 1;
   EXCEPTION WHEN NO_DATA_FOUND then
       ln_numcta := 0;
   end;
   if ln_numcta <> 0 then
      ln_codres := PQ_OP_CAMMUNRUS.FN_CL_VALEMPFAM(ln_numcta);                    
      if ln_codres <> 0 then
         ln_numcta := 0;
      end if;
   end if;                        
   RETURN ln_numcta;
end FN_AH_VALCTA;

FUNCTION FN_CL_VALCTA (P_C_NUMTAR IN varchar2
                      ) RETURN number is
  ln_numcta number := 0;
  ln_codemp integer := 1;
  ln_codres integer := 1;
begin
   
   begin
      
   select distinct a.z0e479cta
       into ln_numcta
     from z0e479 a
    where ROWNUM = 1;
   EXCEPTION WHEN NO_DATA_FOUND then
       ln_numcta := 0;
   end; 
   ln_codres := PQ_OP_CAMMUNRUS.FN_CL_VALEMPFAM(ln_numcta);                    
   RETURN ln_codres;
end FN_CL_VALCTA;

FUNCTION FN_AH_VALCTACOM (P_N_CODSUC IN number,
                          P_N_CODCTA IN number,
                          P_N_CODMON IN number,
                          P_N_CODPAP IN number,
                          P_N_CODOPE IN number,
                          P_N_CODTOP IN number,
                          P_N_CODMOD IN number
                      ) RETURN number is
  ln_numcta number := 0;
  ln_codemp integer := 1;
begin
   
   begin
      
   select distinct a.sccta
       into ln_numcta
     from fsd011 a
    where a.pgcod = ln_codemp
      and a.scsuc = P_N_CODSUC
      and a.sccta = P_N_CODCTA
      and a.scmda = P_N_CODMON
      and a.scpap = P_N_CODPAP
      and a.scoper = P_N_CODOPE
      and a.sctope = P_N_CODTOP
      and a.scmod = P_N_CODMOD
      and a.scstat <> 99;
   EXCEPTION WHEN NO_DATA_FOUND then
       ln_numcta := 0;
   end;                     
   RETURN ln_numcta;
end FN_AH_VALCTACOM;


end PQ_OP_CAMMUNRUS;
/

