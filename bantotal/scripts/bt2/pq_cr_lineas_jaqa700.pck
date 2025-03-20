create or replace package PQ_CR_LINEAS_JAQA700 is

/* ************************************************************************************************************
    -- Nombre                     : PQ_CR_LINEAS_JAQA700
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Descripción                : Backup tabla por cambio de lineas en panel JAQA700 _AQPB251
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.10.03
    -- Autor de Creación          : DCASTRO
    -- Versión                    : 1.0
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
* *************************************************************************************************************/

 Procedure Sp_CR_CARGA_BACKUP(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pd_fec in date,
                               pn_cor in number,                               
                               pc_usu in varchar2);


  Procedure Sp_CR_BACKUP_AQPB251(pn_emp in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number,
                                 pd_fec in date,
                                 pn_cor in number,
                                 pc_usu in varchar2);

Procedure Sp_CR_EXTORNO_AQPB251(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pd_fec in date,
                               pn_cor in number,                               
                               pc_usu in varchar2);
end PQ_CR_LINEAS_JAQA700;
/

create or replace package body PQ_CR_LINEAS_JAQA700 is

 Procedure Sp_CR_CARGA_BACKUP(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pd_fec in date,
                               pn_cor in number,
                               pc_usu in varchar2) is


Begin

-- ACTUALIZAR EN JAQA700 ESTADO S ---OJO
   begin
      pq_cr_lineas_jaqa700.sp_cr_backup_aqpb251(pn_emp => pn_emp,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pd_fec => pd_fec,
                                                pn_cor => pn_cor,
                                                pc_usu => pc_usu);
    end;


 end Sp_CR_CARGA_BACKUP;
   
  Procedure Sp_CR_BACKUP_AQPB251(pn_emp in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number,
                                 pd_fec in date,
                                 pn_cor in number,
                                 pc_usu in varchar2) is
  
  pc_coderr varchar2(1000);
  pc_deserr varchar2(1000);

  
  begin
    begin
      delete from AQPB251C a
       where a.aqpb251cod = pn_emp
         and a.aqpb251mod = pn_mod
         and a.aqpb251suc = pn_suc
         and a.aqpb251mda = pn_mda
         and a.aqpb251pap = pn_pap
         and a.aqpb251cta = pn_cta
         and a.aqpb251oper = pn_ope
         and a.aqpb251sbop = pn_sbo
         and a.aqpb251tope = pn_top
         and a.aqpb251fec = pd_fec
         and a.aqpb251cor = pn_cor;



      delete from AQPB251_010C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB251_011C a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB251_601C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB251_611C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB251_602C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB251_612C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB251_003C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB251_002C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB251_012C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB251_001C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;

   
      insert into AQPB251C
      (aqpb251cod, aqpb251mod, aqpb251suc, aqpb251mda, aqpb251pap, aqpb251cta,
       aqpb251oper, aqpb251sbop, aqpb251tope, aqpb251fec, aqpb251cor, aqpb251usu, aqpb251stat)
        select a.pgcod, a.aomod, a.aosuc, a.aomda, a.aopap, a.aocta, a.aooper,
               a.aosbop, a.aotope, pd_fec, pn_cor, pc_usu, 'S'
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;

    
      insert into AQPB251_010C
        select a.*, pd_fec, pn_cor
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
    
      insert into AQPB251_011C
        select a.*, pd_fec, pn_cor
          from fsd011 a
         where a.pgcod = pn_emp
           and a.scmod = pn_mod
           and a.scsuc = pn_suc
           and a.scmda = pn_mda
           and a.scpap = pn_pap
           and a.sccta = pn_cta
           and a.scoper = pn_ope
           and a.scsbop = pn_sbo
           and a.sctope = pn_top;
    
      insert into AQPB251_601C
        select a.*, pd_fec, pn_cor
          from fsd601 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB251_611C
        select a.*, pd_fec, pn_cor
          from fsd611 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB251_602C
        select a.*, pd_fec, pn_cor
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB251_612C
        select a.*, pd_fec, pn_cor
          from fsd612 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB251_003C
        select a.*, pd_fec, pn_cor
          from fpp003 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB251_002C
        select a.*, pd_fec, pn_cor
          from fpp002 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB251_012C
        select a.*, pd_fec, pn_cor
          from fsd012 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
    
      insert into AQPB251_001C
        select a.*, pd_fec, pn_cor
          from fpp001 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
           
            --Actualiza estado
                update AQPB251C a
                   set a.aqpb251010 = 'S',
                       a.aqpb251011 = 'S',
                       a.aqpb251601 = 'S',
                       a.aqpb251611 = 'S',
                       a.aqpb251602 = 'S',
                       a.aqpb251612 = 'S',
                       a.aqpb251001 = 'S',                                                                                            
                       a.aqpb251002 = 'S',                                                                                            
                       a.aqpb251003 = 'S',                                                                                            
                       a.aqpb251012 = 'S'                                                                                            
                 where a.aqpb251cod =  pn_emp
                   and a.AQPB251mod =  pn_mod
                   and a.AQPB251suc =  pn_suc
                   and a.AQPB251mda =  pn_mda
                   and a.AQPB251pap =  pn_pap
                   and a.aqpb251cta =  pn_cta
                   and a.aqpb251oper = pn_ope
                   and a.aqpb251sbop = pn_sbo
                   and a.aqpb251tope = pn_top
                   and a.aqpb251fec  = pd_fec
                   and a.aqpb251cor  = pn_cor;       
                   
                update JAQA700 a
                  set a.jaqa700ch1 = 'S'
                where a.jaqa700emp = pn_emp
                  and a.jaqa700mod = pn_mod
                  and a.jaqa700suc = pn_suc
                  and a.jaqa700mon = pn_mda
                  and a.jaqa700pap = pn_pap
                  and a.jaqa700cta = pn_cta
                  and a.jaqa700ope = pn_ope
                  and a.jaqa700sbo = pn_sbo
                  and a.jaqa700top = pn_top
                  and a.jaqa700fdp = pd_fec
                  and a.jaqa700cor = pn_cor;


      commit;
    exception
      when others then
          pc_coderr :=sqlcode;
          pc_deserr := sqlerrm; 
    end;
  
  end Sp_CR_BACKUP_AQPB251;


Procedure Sp_CR_EXTORNO_AQPB251(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pd_fec in date,
                               pn_cor in number,                               
                               pc_usu in varchar2) 
                               is
  
  
    ld_fvto11    date;
    ln_pzo11     number(5);
    ld_fvto10    date;
    ln_pzo10     number(5);
    contPagos    number(5);
    contSeguros  number(5);
    ln_602Ant    number(5);
    ln_pp1nump   number(5);
    Pn_ind       number := 0;

    pc_coderr varchar2(1000);
    pc_deserr varchar2(1000);
    
    ln_salant   number;
    ln_salact   number;
    
  BEGIN

    begin
      select 0 -- 0 si no se ha revertido aun, 1 si ya se revirtio o no existe
        into pn_ind
        from AQPB251C b
       where 
           b.aqpb251cod = pn_emp
       and b.AQPB251mod = pn_mod
       and b.AQPB251suc = pn_suc
       and b.aqpb251mda = pn_mda
       and b.aqpb251pap = pn_pap
       and b.aqpb251cta = pn_cta
       and b.aqpb251oper = pn_ope
       and b.aqpb251sbop = pn_sbo
       and b.aqpb251tope = pn_top
       and b.AQPB251fec = pd_fec
       and b.AQPB251cor = pn_cor
       and nvl(b.AQPB251010, 'S') = 'S'
       and nvl(b.AQPB251011, 'S') = 'S'
       and nvl(b.AQPB251601, 'S') = 'S'
       and nvl(b.AQPB251611, 'S') = 'S';
    exception
      when others then
        pn_ind := 1;
    end;


         begin
        select a.scsdo
          into ln_salant
          from AQPB251_011C a
         where a.pgcod =  pn_emp
           and a.scmod =  pn_mod
           and a.scsuc =  pn_suc
           and a.scmda =  pn_mda
           and a.scpap =  pn_pap
           and a.sccta =  pn_cta
           and a.scoper = pn_ope
           and a.scsbop = pn_sbo
           and a.sctope = pn_top
           and a.fec = pd_fec
           and a.cor = pn_cor;
     exception when others then
       ln_salant := 0; 
     end;
              
    begin     
        select a.scsdo
         into ln_salact
         from fsd011 a
         where a.pgcod =  pn_emp
           and a.scmod =  pn_mod
           and a.scsuc =  pn_suc
           and a.scmda =  pn_mda
           and a.scpap =  pn_pap
           and a.sccta =  pn_cta
           and a.scoper = pn_ope
           and a.scsbop = pn_sbo
           and a.sctope = pn_top;
     exception when others then
       ln_salact := 0; 
     end;

     if ln_salant <> ln_salact then
         pn_ind := 1;
     end if;
  
    If pn_ind = 0 then

      begin
          --valido que no tenga pagos vigentes luego de la reprogramación
          select count(*)
            into contPagos
            from fsd602 a
           where a.pgcod =  pn_emp
             and a.ppmod =  pn_mod
             and a.ppsuc =  pn_suc
             and a.ppmda =  pn_mda
             and a.pppap =  pn_pap
             and a.ppcta =  pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
             and a.d602co = 'S';
        
          select count(*)
            into ln_602Ant
            from AQPB251_602C a
           where a.pgcod =  pn_emp
             and a.ppmod =  pn_mod
             and a.ppsuc =  pn_suc
             and a.ppmda =  pn_mda
             and a.pppap =  pn_pap
             and a.ppcta =  pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
             and a.fec = pd_fec
             and a.cor = pn_cor
             and a.d602co = 'S';
        
          --tiene pagos posteriores y estaba o estaría en mora
          if contPagos <> ln_602Ant  then
            pn_ind := 2;
          else
            --valido si agregó o desafilió seguros
          
            select count(*)
              into contSeguros
              from fpp001 o
              full join AQPB251_001C p
                on P.PGCOD =  O.PGCOD
               and P.AOMOD =  O.AOMOD
               and P.AOSUC =  O.AOSUC
               and P.AOMDA =  O.AOMDA
               and P.AOPAP =  O.AOPAP
               and P.AOCTA =  O.AOCTA
               and P.AOOPER = O.AOOPER
               and P.AOSBOP = O.AOSBOP
               and P.AOTOPE = O.AOTOPE
               and P.SGCOD =  O.SGCOD
               and P.FEC = pd_fec
               and P.COR = pn_cor
             where P.pgcod =  pn_emp
               and P.AOMOD =  pn_mod
               and P.AOSUC =  pn_suc
               and P.AOMDA =  pn_mda
               and P.AOPAP =  pn_pap
               and P.aocta =  pn_cta
               and P.aooper = pn_ope
               and P.aosbop = pn_sbo
               and P.aotope = pn_top
               and (O.aocta is null or P.AOCTA is null); --graba afilian seguros
            if contSeguros > 0 then
              pn_ind := 3;
            else
              
                select nvl(max(pp1nump), 0)
                  into ln_pp1nump
                  from AQPB251_602C a
                 where a.pgcod =  pn_emp
                   and a.ppmod =  pn_mod
                   and a.ppsuc =  pn_suc
                   and a.ppmda =  pn_mda
                   and a.pppap =  pn_pap
                   and a.ppcta =  pn_cta
                   and a.ppoper = pn_ope
                   and a.ppsbop = pn_sbo
                   and a.pptope = pn_top
                   and a.fec = pd_fec
                   and a.cor = pn_cor;
              
             --FSD602
                delete from fsd602 a
                 where a.pgcod =  pn_emp
                   and a.ppmod =  pn_mod
                   and a.ppsuc =  pn_suc
                   and a.ppmda =  pn_mda
                   and a.pppap =  pn_pap
                   and a.ppcta =  pn_cta
                   and a.ppoper = pn_ope
                   and a.ppsbop = pn_sbo
                   and a.pptope = pn_top
                   and a.pp1nump <= ln_pp1nump;
              
                insert into fsd602
                  select 
                    pgcod, 
                    ppmod, 
                    ppsuc, 
                    ppmda, 
                    pppap, 
                    ppcta, 
                    ppoper, 
                    ppsbop, 
                    pptope, 
                    ppfpag, 
                    pptipo, 
                    pp1nump, 
                    pp1fech, 
                    pp1cap, 
                    pp1int, 
                    pp1intmex, 
                    pp1intm, 
                    pp1intmmex, 
                    pp1icap, 
                    pp1iint, 
                    pp1iintm, 
                    pp1salcap, 
                    pp1salint, 
                    pp1salade, 
                    pp1salmor, 
                    pp1stat, 
                    pp1salintm, 
                    pp1salmorm, 
                    pp1saladem, 
                    d602cd, 
                    d602mo, 
                    d602su, 
                    d602tr, 
                    d602re, 
                    d602fc, 
                    d602or, 
                    d602sb, 
                    d602co
                    from AQPB251_602C a
                   where a.pgcod =  pn_emp
                     and a.ppmod =  pn_mod
                     and a.ppsuc =  pn_suc
                     and a.ppmda =  pn_mda
                     and a.pppap =  pn_pap
                     and a.ppcta =  pn_cta
                     and a.ppoper = pn_ope
                     and a.ppsbop = pn_sbo
                     and a.pptope = pn_top
                     and a.fec = pd_fec
                     and a.cor = pn_cor;

              --FSD612
                delete from fsd612 a
                 where a.pgcod =  pn_emp
                   and a.ppmod =  pn_mod
                   and a.ppsuc =  pn_suc
                   and a.ppmda =  pn_mda
                   and a.pppap =  pn_pap
                   and a.ppcta =  pn_cta
                   and a.ppoper = pn_ope
                   and a.ppsbop = pn_sbo
                   and a.pptope = pn_top
                   and a.pp1nump <= ln_pp1nump;
              
                insert into fsd612
                  select 
                    pgcod, 
                    ppmod, 
                    ppsuc, 
                    ppmda, 
                    pppap, 
                    ppcta, 
                    ppoper, 
                    ppsbop, 
                    pptope, 
                    ppfpag, 
                    pptipo, 
                    pp1nump, 
                    pp1exte, 
                    pp1imp1, 
                    pp1imp2, 
                    pp1imp3, 
                    pp1imp4, 
                    pp1imp5, 
                    pp1imp6, 
                    pp1imp7, 
                    pp1imp8, 
                    pp1imp9, 
                    pp1imp10, 
                    pp1imp11, 
                    pp1imp12, 
                    pp1imp13, 
                    pp1imp14, 
                    pp1imp15, 
                    pp1imp16, 
                    pp1imp17, 
                    pp1imp18, 
                    pp1imp19, 
                    pp1imp20, 
                    pp1sal1, 
                    pp1sal2, 
                    pp1sal3, 
                    pp1sal4, 
                    pp1sal5, 
                    pp1sal6, 
                    pp1sal7, 
                    pp1sal8, 
                    pp1sal9, 
                    pp1sal10, 
                    pp1sal11, 
                    pp1sal12, 
                    pp1sal13, 
                    pp1sal14, 
                    pp1sal15, 
                    pp1sal16, 
                    pp1sal17, 
                    pp1sal18, 
                    pp1sal19, 
                    pp1sal20
                    from AQPB251_612C a
                   where a.pgcod =  pn_emp
                     and a.ppmod =  pn_mod
                     and a.ppsuc =  pn_suc
                     and a.ppmda =  pn_mda
                     and a.pppap =  pn_pap
                     and a.ppcta =  pn_cta
                     and a.ppoper = pn_ope
                     and a.ppsbop = pn_sbo
                     and a.pptope = pn_top
                     and a.fec = pd_fec
                     and a.cor = pn_cor;

                --FPP003                   
                delete from fpp003 a
                 where a.pgcod =  pn_emp
                   and a.ppmod =  pn_mod
                   and a.ppsuc =  pn_suc
                   and a.ppmda =  pn_mda
                   and a.pppap =  pn_pap
                   and a.ppcta =  pn_cta
                   and a.ppoper = pn_ope
                   and a.ppsbop = pn_sbo
                   and a.pptope = pn_top
                   and a.pp003nump <= ln_pp1nump;
              
                insert into fpp003
                SELECT 
                  pgcod, 
                  ppmod, 
                  ppsuc, 
                  ppmda, 
                  pppap, 
                  ppcta, 
                  ppoper, 
                  ppsbop, 
                  pptope, 
                  ppfpag, 
                  pptipo, 
                  pp003nump, 
                  prestconc, 
                  pp003imp, 
                  pp003stat, 
                  pp003aux1, 
                  pp003aux2, 
                  pp003aux3
                    from AQPB251_003C a
                   where a.pgcod =  pn_emp
                     and a.ppmod =  pn_mod
                     and a.ppsuc =  pn_suc
                     and a.ppmda =  pn_mda
                     and a.pppap =  pn_pap
                     and a.ppcta =  pn_cta
                     and a.ppoper = pn_ope
                     and a.ppsbop = pn_sbo
                     and a.pptope = pn_top
                     and a.fec = pd_fec
                     and a.cor = pn_cor;
              
             
               --FPP002
                delete from fpp002 a
                 where a.pgcod =  pn_emp
                   and a.ppmod =  pn_mod
                   and a.ppsuc =  pn_suc
                   and a.ppmda =  pn_mda
                   and a.pppap =  pn_pap
                   and a.ppcta =  pn_cta
                   and a.ppoper = pn_ope
                   and a.ppsbop = pn_sbo
                   and a.pptope = pn_top;
              
                insert into fpp002 a
                  select 
                    pgcod, 
                    ppmod, 
                    ppsuc, 
                    ppmda, 
                    pppap, 
                    ppcta, 
                    ppoper, 
                    ppsbop, 
                    pptope, 
                    ppfpag, 
                    pptipo, 
                    prestconc, 
                    pp002imp, 
                    pp002stat, 
                    pp002aux1, 
                    pp002aux2, 
                    pp002aux3
                    from AQPB251_002C a
                   where a.pgcod =  pn_emp
                     and a.ppmod =  pn_mod
                     and a.ppsuc =  pn_suc
                     and a.ppmda =  pn_mda
                     and a.pppap =  pn_pap
                     and a.ppcta =  pn_cta
                     and a.ppoper = pn_ope
                     and a.ppsbop = pn_sbo
                     and a.pptope = pn_top
                     and a.fec = pd_fec
                     and a.cor = pn_cor;
                     

                --FSD601                   
                delete from fsd601 a
                 where a.pgcod =  pn_emp
                   and a.ppmod =  pn_mod
                   and a.ppsuc =  pn_suc
                   and a.ppmda =  pn_mda
                   and a.pppap =  pn_pap
                   and a.ppcta =  pn_cta
                   and a.ppoper = pn_ope
                   and a.ppsbop = pn_sbo
                   and a.pptope = pn_top;
              
                insert into fsd601 a
                  select 
                    pgcod, 
                    ppmod, 
                    ppsuc, 
                    ppmda, 
                    pppap, 
                    ppcta, 
                    ppoper, 
                    ppsbop, 
                    pptope, 
                    ppfpag, 
                    pptipo, 
                    ppfval, 
                    ppfvto, 
                    pppzo, 
                    ppcap, 
                    ppint, 
                    ppintmex, 
                    ppicap, 
                    ppiint, 
                    ppstat, 
                    ppnume, 
                    ppfinv, 
                    d601cd, 
                    d601mo, 
                    d601su, 
                    d601tr, 
                    d601re, 
                    d601fc, 
                    d601or, 
                    d601sb, 
                    d601co
                    from AQPB251_601C a
                   where a.pgcod =  pn_emp
                     and a.ppmod =  pn_mod
                     and a.ppsuc =  pn_suc
                     and a.ppmda =  pn_mda
                     and a.pppap =  pn_pap
                     and a.ppcta =  pn_cta
                     and a.ppoper = pn_ope
                     and a.ppsbop = pn_sbo
                     and a.pptope = pn_top
                     and a.fec = pd_fec
                     and a.cor = pn_cor;
                     
                
              --FSD611
                delete from fsd611 a
                 where a.pgcod =  pn_emp
                   and a.ppmod =  pn_mod
                   and a.ppsuc =  pn_suc
                   and a.ppmda =  pn_mda
                   and a.pppap =  pn_pap
                   and a.ppcta =  pn_cta
                   and a.ppoper = pn_ope
                   and a.ppsbop = pn_sbo
                   and a.pptope = pn_top;
              
                insert into fsd611 a
                  select 
                    pgcod, 
                    ppmod, 
                    ppsuc, 
                    ppmda, 
                    pppap, 
                    ppcta, 
                    ppoper, 
                    ppsbop, 
                    pptope, 
                    ppfpag, 
                    pptipo, 
                    ppexte, 
                    ppimp1, 
                    ppimp2, 
                    ppimp3, 
                    ppimp4, 
                    ppimp5, 
                    ppimp6, 
                    ppimp7, 
                    ppimp8, 
                    ppimp9, 
                    ppimp10, 
                    ppimp11, 
                    ppimp12, 
                    ppimp13, 
                    ppimp14, 
                    ppimp15, 
                    ppimp16, 
                    ppimp17, 
                    ppimp18, 
                    ppimp19, 
                    ppimp20
                    from AQPB251_611C a
                   where a.pgcod =  pn_emp
                     and a.ppmod =  pn_mod
                     and a.ppsuc =  pn_suc
                     and a.ppmda =  pn_mda
                     and a.pppap =  pn_pap
                     and a.ppcta =  pn_cta
                     and a.ppoper = pn_ope
                     and a.ppsbop = pn_sbo
                     and a.pptope = pn_top
                     and a.fec = pd_fec
                     and a.cor = pn_cor;
              
              
              --FSD010
                select aofvto, aopzo
                  into ld_fvto10, ln_pzo10
                  from AQPB251_010C a
                 where a.pgcod =  pn_emp
                   and a.aomod =  pn_mod
                   and a.aosuc =  pn_suc
                   and a.aomda =  pn_mda
                   and a.aopap =  pn_pap
                   and a.aocta =  pn_cta
                   and a.aooper = pn_ope
                   and a.aosbop = pn_sbo
                   and a.aotope = pn_top
                   and a.fec = pd_fec
                   and a.cor = pn_cor;
              
                update fsd010 a
                   set a.aofvto = ld_fvto10, a.aopzo = ln_pzo10
                 where a.pgcod =  pn_emp
                   and a.aomod =  pn_mod
                   and a.aosuc =  pn_suc
                   and a.aomda =  pn_mda
                   and a.aopap =  pn_pap
                   and a.aocta =  pn_cta
                   and a.aooper = pn_ope
                   and a.aosbop = pn_sbo
                   and a.aotope = pn_top;
              
                --FSD011              
                select a.scfvto, a.scpzo
                  into ld_fvto11, ln_pzo11
                  from AQPB251_011C a
                 where a.pgcod =  pn_emp
                   and a.scmod =  pn_mod
                   and a.scsuc =  pn_suc
                   and a.scmda =  pn_mda
                   and a.scpap =  pn_pap
                   and a.sccta =  pn_cta
                   and a.scoper = pn_ope
                   and a.scsbop = pn_sbo
                   and a.sctope = pn_top
                   and a.fec = pd_fec
                   and a.cor = pn_cor;
              
                update fsd011 a
                   set a.scfvto = ld_fvto11, a.scpzo = ln_pzo11
                 where a.pgcod =  pn_emp
                   and a.scmod =  pn_mod
                   and a.scsuc =  pn_suc
                   and a.scmda =  pn_mda
                   and a.scpap =  pn_pap
                   and a.sccta =  pn_cta
                   and a.scoper = pn_ope
                   and a.scsbop = pn_sbo
                   and a.sctope = pn_top;

             --FSD012      
                delete from fsd012 a
                 where a.pgcod =  pn_emp
                   and a.aomod =  pn_mod
                   and a.aosuc =  pn_suc
                   and a.aomda =  pn_mda
                   and a.aopap =  pn_pap
                   and a.aocta =  pn_cta
                   and a.aooper = pn_ope
                   and a.aosbop = pn_sbo
                   and a.aotope = pn_top;
              
                insert into fsd012 a
                  select 
                  pgcod, 
                  aomod, 
                  aosuc, 
                  aomda, 
                  aopap, 
                  aocta, 
                  aooper, 
                  aosbop, 
                  aotope, 
                  evcorr, 
                  evtipo, 
                  evfval, 
                  evfvto, 
                  evimp, 
                  evttas, 
                  evtasa, 
                  evcap, 
                  evint, 
                  evmor, 
                  evscap, 
                  evsint, 
                  evsmor, 
                  evintc, 
                  evmorc, 
                  evcd01, 
                  evcd02, 
                  evinv, 
                  evper, 
                  evtcbi, 
                  evtcbi1, 
                  evarb, 
                  evarb1, 
                  evmd, 
                  evmd1, 
                  evpre, 
                  evpre1, 
                  d012cd, 
                  d012mo, 
                  d012su, 
                  d012tr, 
                  d012re, 
                  d012fc, 
                  d012or, 
                  d012sb, 
                  d012co
                  from AQPB251_012C a
                   where a.pgcod =  pn_emp
                     and a.aomod =  pn_mod
                     and a.aosuc =  pn_suc
                     and a.aomda =  pn_mda
                     and a.aopap =  pn_pap
                     and a.aocta =  pn_cta
                     and a.aooper = pn_ope
                     and a.aosbop = pn_sbo
                     and a.aotope = pn_top
                     and a.fec = pd_fec
                     and a.cor = pn_cor;              

            --FPP001         
             delete from fpp001 p
             where P.pgcod =  pn_emp
               and P.AOMOD =  pn_mod
               and P.AOSUC =  pn_suc
               and P.AOMDA =  pn_mda
               and P.AOPAP =  pn_pap
               and P.aocta =  pn_cta
               and P.aooper = pn_ope
               and P.aosbop = pn_sbo
               and P.aotope = pn_top;
               
             
             insert into  fpp001 
              select
              pgcod, 
              aomod, 
              aosuc, 
              aomda, 
              aopap, 
              aocta, 
              aooper, 
              aosbop, 
              aotope, 
              sgcod, 
              pp001vc, 
              pp001imp, 
              pp001porc, 
              pp001plus, 
              pp001part, 
              pp001veh, 
              pp001inm, 
              pp001end, 
              pp001stat, 
              pp001co, 
              pp001aux1, 
              pp001aux2, 
              pp001aux3, 
              pp001aux4, 
              pp001aux5, 
              pp001aux6, 
              pp001aux7
             from AQPB251_001C p
             where P.pgcod =  pn_emp
               and P.AOMOD =  pn_mod
               and P.AOSUC =  pn_suc
               and P.AOMDA =  pn_mda
               and P.AOPAP =  pn_pap
               and P.aocta =  pn_cta
               and P.aooper = pn_ope
               and P.aosbop = pn_sbo
               and P.aotope = pn_top
               and p.fec = pd_fec
               and p.cor = pn_cor;              
               
              
                --Actualiza estado, fecha y usuario que hizo la reversion
                update AQPB251C a
                   set a.AQPB251stat = 'E',
                       a.AQPB251fex = pd_fec,
                       a.AQPB251Uex = pc_usU
                 where a.aqpb251cod =  pn_emp
                   and a.AQPB251mod =  pn_mod
                   and a.AQPB251suc =  pn_suc
                   and a.AQPB251mda =  pn_mda
                   and a.AQPB251pap =  pn_pap
                   and a.aqpb251cta =  pn_cta
                   and a.aqpb251oper = pn_ope
                   and a.aqpb251sbop = pn_sbo
                   and a.aqpb251tope = pn_top
                   and a.aqpb251fec  = pd_fec
                   and a.aqpb251cor  = pn_cor;
                   
               update JAQA700 a
                  set a.jaqa700est = 'E',
                      a.jaqa700ch1 = 'E'
                where a.jaqa700emp = pn_emp
                  and a.jaqa700mod = pn_mod
                  and a.jaqa700suc = pn_suc
                  and a.jaqa700mon = pn_mda
                  and a.jaqa700pap = pn_pap
                  and a.jaqa700cta = pn_cta
                  and a.jaqa700ope = pn_ope
                  and a.jaqa700sbo = pn_sbo
                  and a.jaqa700top = pn_top
                  and a.jaqa700fdp = pd_fec
                  and a.jaqa700cor = pn_cor;
                   
              
--              end if;
            end if;
          end If;
        commit;
        
        if pn_ind <> 0 then
               rollback;
                   
               update JAQA700 a
                  set a.jaqa700ch1 = 'X'
                where a.jaqa700emp = pn_emp
                  and a.jaqa700mod = pn_mod
                  and a.jaqa700suc = pn_suc
                  and a.jaqa700mon = pn_mda
                  and a.jaqa700pap = pn_pap
                  and a.jaqa700cta = pn_cta
                  and a.jaqa700ope = pn_ope
                  and a.jaqa700sbo = pn_sbo
                  and a.jaqa700top = pn_top
                  and a.jaqa700fdp = pd_fec
                  and a.jaqa700cor = pn_cor;
                  commit;
         end if;
                  
      exception
        when others then
          pc_coderr :=sqlcode;
          pc_deserr := sqlerrm; 
          rollback;
          null;
      End;
    else 
       update JAQA700 a
          set a.jaqa700ch1 = 'X'
        where a.jaqa700emp = pn_emp
          and a.jaqa700mod = pn_mod
          and a.jaqa700suc = pn_suc
          and a.jaqa700mon = pn_mda
          and a.jaqa700pap = pn_pap
          and a.jaqa700cta = pn_cta
          and a.jaqa700ope = pn_ope
          and a.jaqa700sbo = pn_sbo
          and a.jaqa700top = pn_top
          and a.jaqa700fdp = pd_fec
          and a.jaqa700cor = pn_cor;
          commit;
      
    End if;
  end Sp_CR_EXTORNO_AQPB251;
                               

end PQ_CR_LINEAS_JAQA700;
/

