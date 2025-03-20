create or replace package PQ_OP_PERMANENCIA_POLIZA is
 
    -- *****************************************************************
    -- Nombre                     : PROCESO DE DESAFILIACION PARTE II
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : CREDITOS
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2016.04.01
    -- Autor de Creaci¿n          : MSOLARI 
    -- Uso                        : MODIFICACION DEL PROCESO DE DESAFILIACION DE SEGUROS
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Fecha de Modificaci¿n      : 06/03/2017
    -- Autor de la Modificaci¿n   : -
    -- Descripci¿n de Modificaci¿n: -
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 Procedure sp_cr_cargaCuoIm_job;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Cuotas_Impagas(lc_digito in varchar2);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Revision_data(lc_digito in varchar2,ld_FchSist in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Anios_70(pn_cod     in number,
                       pn_mod     in number,
                       pn_suc     in number,
                       pn_mda     in number,
                       pn_pap     in number,
                       pn_cta     in number,
                       pn_oper    in number,
                       pn_sbop    in number,
                       pn_tope    in number,
                       ld_FchSist in date,
                       pd_fchnc   in char,
                       p_flag     out varchar2);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Clientes_70(pn_cod     in number,
                          pn_mod     in number,
                          pn_suc     in number,
                          pn_mda     in number,
                          pn_pap     in number,
                          pn_cta     in number,
                          pn_oper    in number,
                          pn_sbop    in number,
                          pn_tope    in number,
                          ld_FchSist in date,
                          pd_fchnc   in char);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Backup_FSD611(pn_cod     in number,
                             pn_mod     in number,
                             pn_suc     in number,
                             pn_mda     in number,
                             pn_pap     in number,
                             pn_cta     in number,
                             pn_oper    in number,
                             pn_sbop    in number,
                             pn_tope    in number,
                             ld_FchSist in date,
                             pc_hrasis  in char);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Backup_FPP001(pn_cod     in number,
                            pn_mod     in number,
                            pn_suc     in number,
                            pn_mda     in number,
                            pn_pap     in number,
                            pn_cta     in number,
                            pn_oper    in number,
                            pn_sbop    in number,
                            pn_tope    in number,
                            ld_FchSist in date,
                            pc_hrasis  in char);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Mover_Eliminar_Seguros(pn_cod     in number,
                                     pn_mod     in number,
                                     pn_suc     in number,
                                     pn_mda     in number,
                                     pn_pap     in number,
                                     pn_cta     in number,
                                     pn_oper    in number,
                                     pn_sbop    in number,
                                     pn_tope    in number,
                                    -- ld_FchSist in date,
                                     pc_descp   in varchar2,
                                     pd_fchpag  in date);      
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_OP_PERMANENCIA_POLIZA;
/

create or replace package body PQ_OP_PERMANENCIA_POLIZA is
    -- *****************************************************************
    -- Nombre                     : PROCESO DE DESAFILIACION DE CR¿DITOS
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : CREDITOS
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2016.07.26
    -- Autor de Creaci¿n          : MSOLARI 
    -- Uso                        : Proceso para desafiliar creditos cuando el 
    --                              cliente cumpla 70 anios de edad (1 anios antes 
    --                              del cumpleanios numero 70) debera eliminar 
    --                              todas las cuotas pendientes de pagos de la 
    --                              tabla FSD611.
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Fecha de Modificaci¿n      : -
    -- Autor de la Modificaci¿n   : -
    -- Descripci¿n de Modificaci¿n: -
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_cargaCuoIm_job is

    lc_variable varchar2(1000);  
    ln_job number := 0;
    lc_hostname varchar2(64);
  
  begin

  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;

  execute immediate ('truncate table JAQY783'); --->>>>>> Tabla temporal
    for x in 0..9 loop

       lc_variable := ' begin ' || ' pq_op_permanencia_poliza.sp_cuotas_impagas(''' ||
                       x || ''');' ||
                       ' End; ';
        ln_job := ln_job + 1;
      
--      if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')   then   
IF SYS.FN_BD_ISRAC='TRUE' THEN
            DBMS_JOB.SUBMIT(job       => ln_job,
                            what      => lc_variable,
                            next_date => sysdate + 1 / (24 * 60),
                            interval  => null,
                            no_parse  => false,
                            -- instance  => 2,  --23032024
                            instance  => 1,
                            force => false);
         else
            DBMS_JOB.SUBMIT(job       => ln_job,
                            what      => lc_variable,
                            next_date => sysdate + 1 / (24 * 60),
                            interval  => null,
                            no_parse  => false,
                            force => false);
         end if;
        commit;
      
      end loop;
  
  end sp_cr_cargaCuoIm_job;
  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Cuotas_Impagas(lc_digito in varchar2) is

   Cursor CImp1  is
      select distinct min(f01.ppfpag) ppfpag,
                     f01.pgcod,
                     f01.ppmod,
                     f01.ppsuc,
                     f01.ppmda,
                     f01.pppap,
                     f01.ppcta,
                     f01.ppoper,
                     f01.ppsbop,
                     f01.pptope
        from fsd601 f01 
        inner join fsd010 a 
           on f01.pgcod  = a.pgcod 
          and f01.ppmod  = a.aomod  
          and f01.ppsuc  = a.aosuc  
          and f01.ppmda  = a.aomda  
          and f01.pppap  = a.aopap  
          and f01.ppcta  = a.aocta  
          and f01.ppoper = a.aooper 
          and f01.ppsbop = a.aosbop 
          and f01.pptope = a.aotope
        inner join fpp001 fp 
           on f01.pgcod  = fp.pgcod 
          and f01.ppmod  = fp.aomod   
          and f01.ppsuc  = fp.aosuc   
          and f01.ppmda  = fp.aomda   
          and f01.pppap  = fp.aopap  
          and f01.ppcta  = fp.aocta 
          and f01.ppoper = fp.aooper
          and f01.ppsbop = fp.aosbop
          and f01.pptope = fp.aotope
          where (a.aomod in (select modulo from fst111 where dscod = 50)) 
          and a.aostat  <> 99
          and fp.sgcod in ((select tp1nro3 
                              from fst198 
                             where Tp1cod   = 1 
                               and Tp1cod1  = 10898 
                               and Tp1corr1 = 18))       
          and f01.ppstat <> 'P'----------------------
          and to_char(substr(trim(f01.ppcta), -1, 1)) = lc_digito --comentado para pruebas
       --   AND f01.ppcta = 2145975---320472 --1398052 --236908 
          group by f01.pgcod, f01.ppmod, f01.ppsuc, f01.ppmda,f01.pppap,
                   f01.ppcta, f01.ppoper, f01.ppsbop, f01.pptope;  
                        
   Cursor CImp2 (ln_cod number, ln_mod number, ln_suc number, ln_mda number, ln_pap number, ln_cta number, ln_oper number, ln_sbop number, ln_tope number, ld_pfpag date)is
       select sum(f611.ppimp11) a11,
              sum(f611.ppimp12) a12,
              sum(f611.ppimp13) a13,
              sum(f611.ppimp14) a14,
              sum(f611.ppimp15) a15,
              count(f611.ppfpag) fch_cuo 
         from fsd611 f611
         where f611.pgcod  = ln_cod 
           and f611.ppmod  = ln_mod  
           and f611.ppsuc  = ln_suc   
           and f611.ppmda  = ln_mda   
           and f611.pppap  = ln_pap  
           and f611.ppcta  = ln_cta 
           and f611.ppoper = ln_oper
           and f611.ppsbop = ln_sbop
           and f611.pptope = ln_tope;

    ln_cod    number(3);
    ln_mod    number(4);
    ln_suc    number(3);
    ln_mda    number(3);
    ln_pap    number(3);
    ln_cta    number(9);
    ln_oper   number(9);
    ln_sbop   number(3);
    ln_tope   number(3);
    ld_pfpag  date;
    ld_fmax   date;
    lc_Stat   varchar2(1);
    lc_FlgF   varchar2(8);
    ld_FchNac char(10);
    ld_FchSist date;
      
   Begin
   
     For a in CImp1 loop
         ln_cod   := a.pgcod; 
         ln_mod   := a.ppmod; 
         ln_suc   := a.ppsuc; 
         ln_mda   := a.ppmda; 
         ln_pap   := a.pppap; 
         ln_cta   := a.ppcta; 
         ln_oper  := a.ppoper; 
         ln_sbop  := a.ppsbop; 
         ln_tope  := a.pptope; 
         ld_pfpag := a.ppfpag;     
         
         For b in CImp2 (ln_cod, ln_mod, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop, ln_tope, ld_pfpag) loop 
            
            Begin
             select max(x.ppfpag)
               into ld_fmax
               from fsd602 x
              where x.pgcod   = ln_cod 
                and x.ppmod   = ln_mod 
                and x.ppsuc   = ln_suc 
                and x.ppmda   = ln_mda 
                and x.pppap   = ln_pap 
                and x.ppcta   = ln_cta 
                and x.ppoper  = ln_oper 
                and x.ppsbop  = ln_sbop 
                and x.pptope  = ln_tope 
                and x.D602Co  = 'S';
             Exception when no_data_found then
                  ld_fmax := null;
             End; 

             If ld_fmax is not null then
               Begin
                 select max(x.pp1stat)
                   into lc_Stat
                   from fsd602 x
                  where x.pgcod   = ln_cod 
                    and x.ppmod   = ln_mod 
                    and x.ppsuc   = ln_suc 
                    and x.ppmda   = ln_mda 
                    and x.pppap   = ln_pap 
                    and x.ppcta   = ln_cta 
                    and x.ppoper  = ln_oper 
                    and x.ppsbop  = ln_sbop 
                    and x.pptope  = ln_tope 
                    and x.ppfpag  = ld_fmax
                    and x.D602Co  = 'S';
                 Exception when no_data_found then
                      lc_Stat := '-';     
                 End;
             Else
                 lc_Stat := '-'; 
             End If;
             
             If ld_fmax is null then 
                   lc_FlgF := 'SinCalen';
             Else
                   lc_FlgF := 'ConCalen';
             End If;
             
             ------------------------------------------
             Begin
                select to_char(f2.Pffnac,'dd/mm/rrrr')
                  into ld_FchNac
                  from fsr008 f8, fsd002 f2
                 Where f2.pfpais = f8.pepais
                   and f2.pftdoc = f8.petdoc
                   and f2.pfndoc = f8.pendoc
                   and f8.ctnro  = ln_cta
                   and f8.pgcod  = ln_cod
                   and f8.ttcod  = 1
                   and f8.cttfir = 'T'
                   and rownum    = 1;
             Exception when no_data_found then
                Begin
                 select to_char(s2.sngc11Dat1,'dd/mm/rrrr')
                   into ld_FchNac
                   from fsr008 f8, sngc11 s2
                  Where s2.sngc11pais = f8.pepais
                    and s2.sngc11tdoc = f8.petdoc
                    and s2.sngc11ndoc = f8.pendoc
                    and f8.ctnro  = ln_cta
                    and f8.pgcod  = ln_cod
                    and f8.ttcod  = 1
                    and f8.cttfir = 'T';  
                    
                  Exception when no_data_found then null;
                  End;      
             End;
             ------------------------------------------
             
             Begin
               select Pgfape
                 into ld_FchSist
                 from fst017
                Where Pgcod = 1; 
             Exception when no_data_found then null;
             End;

             --ld_FchSist := to_date('01/12/1945','dd/mm/yyyy');
             --ld_FchSist := to_date('23/11/2017','dd/mm/yyyy');
             Begin     
                 insert into jaqy783 
                 (    
                      jaqy783cod,   
                      jaqy783mod,   
                      jaqy783suc,   
                      jaqy783mda,   
                      jaqy783pap,   
                      jaqy783cta,   
                      jaqy783oper,  
                      jaqy783sbop,  
                      jaqy783tope,  
                      jaqy783FchMax,  
                      jaqy783imp11,
                      jaqy783imp12,
                      jaqy783imp13,
                      jaqy783imp14,
                      jaqy783imp15,
                      jaqy783NumCuoT,
                      jaqy783FchPag, 
                      jaqy783Est,
                      jaqy783Descp,
                      jaqy783FchNc
                 )
                 values 
                 (    ln_cod,  
                      ln_mod,  
                      ln_suc,  
                      ln_mda,  
                      ln_pap,  
                      ln_cta,  
                      ln_oper, 
                      ln_sbop, 
                      ln_tope, 
                      ld_pfpag,
                      b.a11,
                      b.a12,
                      b.a13,
                      b.a14,
                      b.a15,
                      b.fch_cuo,
                      ld_fmax,
                      lc_Stat, 
                      lc_FlgF,
                      ld_FchNac
                  );
                  commit;
             exception
               when dup_val_on_index then
                 null;
             end;         
         End loop;
       commit;
    End loop;

    Begin
       pq_op_permanencia_poliza.sp_Revision_data(lc_digito, ld_FchSist);
    End; 
    
 End sp_Cuotas_Impagas; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Revision_data(lc_digito in varchar2, ld_FchSist in date) is
 
   Cursor Revs1 is
     select y.*
       from jaqy783 y
      where to_char(substr(trim(y.jaqy783cta), -1, 1)) = lc_digito
        and y.jaqy783est in ('T','-');
        --and y.jaqy783est = 'T';
 
   lc_data   char(1);
   pn_cod    number(3);
   pn_mod    number(4);
   pn_suc    number(3);
   pn_mda    number(3);
   pn_pap    number(3);
   pn_cta    number(9);
   pn_oper   number(9);
   pn_sbop   number(3);
   pn_tope   number(3);
   pd_fchnc  char(10);
   pc_descp  VARCHAR2(8);
   lc_hora   char(8);
   pd_fchpag date;
   flag_mayor70 varchar2(1);
 Begin
 
   For a in Revs1 loop
       
      pn_cod    := a.jaqy783cod;
      pn_mod    := a.jaqy783mod;
      pn_suc    := a.jaqy783suc;
      pn_mda    := a.jaqy783mda;
      pn_pap    := a.jaqy783pap;
      pn_cta    := a.jaqy783cta;
      pn_oper   := a.jaqy783oper;
      pn_sbop   := a.jaqy783sbop;
      pn_tope   := a.jaqy783tope;
      pd_fchnc  := a.jaqy783fchnc;
      pc_descp  := a.jaqy783descp;
      pd_fchpag := a.jaqy783fchpag;
      
     Begin
         select 'S'
           into lc_data
           from jaqy784 j
          where j.jaqy784cod = pn_cod 
            and j.jaqy784mod = pn_mod 
            and j.jaqy784suc = pn_suc 
            and j.jaqy784mda = pn_mda 
            and j.jaqy784pap = pn_pap 
            and j.jaqy784cta = pn_cta 
            and j.jaqy784oper = pn_oper 
            and j.jaqy784sbop = pn_sbop 
            and j.jaqy784tope = pn_tope; 
     Exception
       when no_data_found then
         lc_data := 'N';
     end;
   
     select to_char(sysdate, 'hh24:mi:ss') into lc_hora from dual;
     
     If lc_data = 'N' then
       pq_op_permanencia_poliza.sp_Anios_70(pn_cod,
                                            pn_mod,
                                            pn_suc,
                                            pn_mda,
                                            pn_pap,
                                            pn_cta,
                                            pn_oper,
                                            pn_sbop,
                                            pn_tope,
                                            ld_FchSist,
                                            pd_fchnc,
                                            flag_mayor70);
          if flag_mayor70 = 'S' then                                            
                                                
                 pq_op_permanencia_poliza.sp_Clientes_70(pn_cod,
                                                         pn_mod,
                                                         pn_suc,
                                                         pn_mda,
                                                         pn_pap,
                                                         pn_cta,
                                                         pn_oper,
                                                         pn_sbop,
                                                         pn_tope,
                                                         ld_FchSist,
                                                         pd_fchnc);
                                                         
                 pq_op_permanencia_poliza.sp_Backup_FSD611(pn_cod,
                                                           pn_mod,
                                                           pn_suc,
                                                           pn_mda,
                                                           pn_pap,
                                                           pn_cta,
                                                           pn_oper,
                                                           pn_sbop,
                                                           pn_tope,
                                                           ld_FchSist,
                                                           lc_hora);
                                                           
                 pq_op_permanencia_poliza.sp_Backup_FPP001(pn_cod,
                                                           pn_mod,
                                                           pn_suc,
                                                           pn_mda,
                                                           pn_pap,
                                                           pn_cta,
                                                           pn_oper,
                                                           pn_sbop,
                                                           pn_tope,
                                                           ld_FchSist,
                                                           lc_hora);
                                                           
                 pq_op_permanencia_poliza.sp_Mover_Eliminar_Seguros(pn_cod,
                                                                    pn_mod,
                                                                    pn_suc,
                                                                    pn_mda,
                                                                    pn_pap,
                                                                    pn_cta,
                                                                    pn_oper,
                                                                    pn_sbop,
                                                                    pn_tope,
                                                                    --ld_FchSist,
                                                                    pc_descp,
                                                                    pd_fchpag);
            end if;                                                        
     End If;
   
   End loop;
 
 End sp_Revision_data;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Anios_70(pn_cod     in number,
                       pn_mod     in number,
                       pn_suc     in number,
                       pn_mda     in number,
                       pn_pap     in number,
                       pn_cta     in number,
                       pn_oper    in number,
                       pn_sbop    in number,
                       pn_tope    in number,
                       ld_FchSist in date,
                       pd_fchnc   in char,
                       p_flag     out varchar2) is
 
   ln_diaS   number(2);
   ln_MesS   number(5);
   ln_AnioS  number(4);
   ln_diaN   number(2);
   ln_MesN   number(2);
   ln_AnioN  number(4);
   ln_ResAn  number(4);
   lc_flag   char(1);
   lc_fechaS char(10);
   lc_fechaA char(10);
   lc_fecha1 char(10);
   lc_fecha2 char(10);
   ld_Fnac   char(10);
   ln_ResDi  number(5);
   lc_hora   char(8);
   lc_flgI   char(1);
   lc_flgA1  char(1);
   lc_flgA2  char(1);
 
   ycod     NUMBER(3);
   ymod     NUMBER(3);
   ysuc     NUMBER(3);
   ymda     NUMBER(4);
   ypap     NUMBER(4);
   ycta     NUMBER(9);
   yoper    NUMBER(9);
   ysbop    NUMBER(3);
   ytope    NUMBER(3);
   yfchmax  DATE;
   yimp11   NUMBER(17, 2);
   yimp12   NUMBER(17, 2);
   yimp13   NUMBER(17, 2);
   ymp14    NUMBER(17, 2);
   yimp15   NUMBER(17, 2);
   ynumcuot NUMBER(5);
   yfchpag  DATE;
   yest     VARCHAR2(1);
   ydescp   VARCHAR2(8);
 
 Begin
   lc_fecha1 := to_char(to_date(ld_FchSist, 'dd/mm/rrrr'), 'dd/mm/yyyy');
   lc_fechaS := replace(lc_fecha1, '/', '');
 
   ln_diaS  := SubStr(lc_fechaS, 1, 2);
   ln_MesS  := SubStr(lc_fechaS, 3, 2);
   ln_AnioS := SubStr(lc_fechaS, 5, 4);
   lc_flag  := 'N';
   lc_flgI  := 'A';
 
   select to_char(sysdate, 'hh24:mi:ss') into lc_hora from dual;
 
   ld_Fnac  := pd_fchnc;
   lc_flgA1 := 'N';
   lc_flgA2 := 'N';
 
   If ld_Fnac <> '01/01/0001' then
   
     lc_fecha2 := ld_Fnac;
     lc_fechaA := replace(lc_fecha2, '/', '');
   
     ln_diaN  := SubStr(lc_fechaA, 1, 2);
     ln_MesN  := SubStr(lc_fechaA, 3, 2);
     ln_AnioN := SubStr(lc_fechaA, 5, 4);
   
     ln_ResAn := ln_AnioS - ln_AnioN;
   
     ---------------------------------------
     select jj.jaqy783cod,
            jj.jaqy783mod,
            jj.jaqy783suc,
            jj.jaqy783mda,
            jj.jaqy783pap,
            jj.jaqy783cta,
            jj.jaqy783oper,
            jj.jaqy783sbop,
            jj.jaqy783tope,
            jj.jaqy783fchmax,
            jj.jaqy783imp11,
            jj.jaqy783imp12,
            jj.jaqy783imp13,
            jj.jaqy783imp14,
            jj.jaqy783imp15,
            jj.jaqy783numcuot,
            jj.jaqy783fchpag,
            jj.jaqy783est,
            jj.jaqy783descp
       into ycod,
            ymod,
            ysuc,
            ymda,
            ypap,
            ycta,
            yoper,
            ysbop,
            ytope,
            yfchmax,
            yimp11,
            yimp12,
            yimp13,
            ymp14,
            yimp15,
            ynumcuot,
            yfchpag,
            yest,
            ydescp
       from jaqy783 jj
      where jj.jaqy783cod = pn_cod
        and jj.jaqy783mod = pn_mod
        and jj.jaqy783suc = pn_suc
        and jj.jaqy783mda = pn_mda
        and jj.jaqy783pap = pn_pap
        and jj.jaqy783cta = pn_cta
        and jj.jaqy783oper = pn_oper
        and jj.jaqy783sbop = pn_sbop
        and jj.jaqy783tope = pn_tope;
     ---------------------------------------
     If ln_ResAn = 70 then
       If ln_MesS > ln_MesN then
         lc_flgA1 := 'S';
       Else
         If ln_MesS = ln_MesN and ln_diaS >= ln_diaN then
           lc_flgA1 := 'S';
         End If;
       End If;
     Else
       If ln_ResAn > 70 then
         lc_flgA1 := 'S';
         lc_flgA2 := 'S';
       
         --/////////////////////////////////
         Begin
           insert into jaqy784
             (jaqy784cod,
              jaqy784mod,
              jaqy784suc,
              jaqy784mda,
              jaqy784pap,
              jaqy784cta,
              jaqy784oper,
              jaqy784sbop,
              jaqy784tope,
              jaqy784FchMax,
              jaqy784imp11,
              jaqy784imp12,
              jaqy784imp13,
              jaqy784imp14,
              jaqy784imp15,
              jaqy784NumCuoT,
              jaqy784FchPag,
              jaqy784Est,
              jaqy784Descp,
              jaqy784Anios,
              jaqy784FchNc,
              jaqy784Ident,
              jaqy784FchSis,
              jaqy784HraSis)
           values
             (ycod,
              ymod,
              ysuc,
              ymda,
              ypap,
              ycta,
              yoper,
              ysbop,
              ytope,
              yfchmax,
              yimp11,
              yimp12,
              yimp13,
              ymp14,
              yimp15,
              ynumcuot,
              yfchpag,
              yest,
              ydescp,
              ln_ResAn,
              pd_fchnc,
              lc_flgI,
              ld_FchSist,
              lc_hora
              );
           commit;
         exception
           when dup_val_on_index then
             Begin
               insert into jaqy751
                 (jaqy751cod,
                  jaqy751mod,
                  jaqy751suc,
                  jaqy751mda,
                  jaqy751pap,
                  jaqy751cta,
                  jaqy751oper,
                  jaqy751sbop,
                  jaqy751tope,
                  jaqy751FchMax,
                  jaqy751imp11,
                  jaqy751imp12,
                  jaqy751imp13,
                  jaqy751imp14,
                  jaqy751imp15,
                  jaqy751NumCuoT,
                  jaqy751FchPag,
                  jaqy751Est,
                  jaqy751Descp,
                  jaqy751Anios,
                  jaqy751FchNc,
                  jaqy751Ident,
                  jaqy751FchSis,
                  jaqy751HraSis)
               values
                 (ycod,
                  ymod,
                  ysuc,
                  ymda,
                  ypap,
                  ycta,
                  yoper,
                  ysbop,
                  ytope,
                  yfchmax,
                  yimp11,
                  yimp12,
                  yimp13,
                  ymp14,
                  yimp15,
                  ynumcuot,
                  yfchpag,
                  yest,
                  ydescp,
                  ln_ResAn,
                  pd_fchnc,
                  lc_flgI,
                  ld_FchSist,
                  lc_hora
                  );
               Commit;
             exception
               when dup_val_on_index then
                 null;  
             End;
         End;
         ln_ResDi := 0;
       End If;
     End If;
    p_flag := lc_flgA1;
     If lc_flgA1 = 'S' and lc_flgA2 = 'N' then
     
       If to_date(lc_fecha2, 'DD/MM/YYYY') <= to_date(lc_fecha1, 'DD/MM/YYYY') then
       
         If ln_diaS < ln_diaN then
           ln_ResDi := ln_diaN - ln_diaS;
         Else
           ln_ResDi := ln_diaS - ln_diaN;
         End If;
       
         If ln_ResDi >= 0 /*1*/
          then
           lc_flag := 'S';
           Begin
             insert into jaqy784
               (jaqy784cod,
                jaqy784mod,
                jaqy784suc,
                jaqy784mda,
                jaqy784pap,
                jaqy784cta,
                jaqy784oper,
                jaqy784sbop,
                jaqy784tope,
                jaqy784FchMax,
                jaqy784imp11,
                jaqy784imp12,
                jaqy784imp13,
                jaqy784imp14,
                jaqy784imp15,
                jaqy784NumCuoT,
                jaqy784FchPag,
                jaqy784Est,
                jaqy784Descp,
                jaqy784Anios,
                jaqy784FchNc,
                jaqy784Ident,
                jaqy784FchSis,
                jaqy784HraSis)
             values
               (
                ycod,
                ymod,
                ysuc,
                ymda,
                ypap,
                ycta,
                yoper,
                ysbop,
                ytope,
                yfchmax,
                yimp11,
                yimp12,
                yimp13,
                ymp14,
                yimp15,
                ynumcuot,
                yfchpag,
                yest,
                ydescp,
                ln_ResAn,
                pd_fchnc,
                lc_flgI,
                ld_FchSist,
                lc_hora
                );
             commit;
           exception
             when dup_val_on_index then
               Begin
                 insert into jaqy751
                   (jaqy751cod,
                    jaqy751mod,
                    jaqy751suc,
                    jaqy751mda,
                    jaqy751pap,
                    jaqy751cta,
                    jaqy751oper,
                    jaqy751sbop,
                    jaqy751tope,
                    jaqy751FchMax,
                    jaqy751imp11,
                    jaqy751imp12,
                    jaqy751imp13,
                    jaqy751imp14,
                    jaqy751imp15,
                    jaqy751NumCuoT,
                    jaqy751FchPag,
                    jaqy751Est,
                    jaqy751Descp,
                    jaqy751Anios,
                    jaqy751FchNc,
                    jaqy751Ident,
                    jaqy751FchSis,
                    jaqy751HraSis)
                 values
                   (
                    ycod,
                    ymod,
                    ysuc,
                    ymda,
                    ypap,
                    ycta,
                    yoper,
                    ysbop,
                    ytope,
                    yfchmax,
                    yimp11,
                    yimp12,
                    yimp13,
                    ymp14,
                    yimp15,
                    ynumcuot,
                    yfchpag,
                    yest,
                    ydescp,
                    ln_ResAn,
                    pd_fchnc,
                    lc_flgI,
                    ld_FchSist,
                    lc_hora
                    );
                 commit;
               exception
                 when dup_val_on_index then
                   null;  
               End;
           End;
         End If;
         ln_ResDi := 0;
       End If;
     End If;
   End If;
 
   ln_ResAn  := 0;
   lc_hora   := null;
   ld_Fnac   := null;
   lc_fecha2 := null;
   lc_fechaA := null;
   ln_diaN   := 0;
   ln_MesN   := 0;
   ln_AnioN  := 0;
 
 End sp_Anios_70;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Clientes_70(pn_cod     in number,
                          pn_mod     in number,
                          pn_suc     in number,
                          pn_mda     in number,
                          pn_pap     in number,
                          pn_cta     in number,
                          pn_oper    in number,
                          pn_sbop    in number,
                          pn_tope    in number,
                          ld_FchSist in date,
                          pd_fchnc   in char) is
 
   ln_diaS   number(2);
   ln_MesS   number(5);
   ln_AnioS  number(4);
   ln_diaN   number(2);
   ln_MesN   number(2);
   ln_AnioN  number(4);
   ln_ResAn  number(4);
   lc_flag   char(1);
   lc_fechaS char(10);
   lc_fechaA char(10);
   lc_fecha1 char(10);
   lc_fecha2 char(10);
   ld_Fnac   char(10);
   ln_ResDi  number(5);
   lc_flgI   char(1);
   lc_hora   char(8);
 
   ycod     NUMBER(3);
   ymod     NUMBER(3);
   ysuc     NUMBER(3);
   ymda     NUMBER(4);
   ypap     NUMBER(4);
   ycta     NUMBER(9);
   yoper    NUMBER(9);
   ysbop    NUMBER(3);
   ytope    NUMBER(3);
   yfchmax  DATE;
   yimp11   NUMBER(17, 2);
   yimp12   NUMBER(17, 2);
   yimp13   NUMBER(17, 2);
   ymp14    NUMBER(17, 2);
   yimp15   NUMBER(17, 2);
   ynumcuot NUMBER(5);
   yfchpag  DATE;
   yest     VARCHAR2(1);
   ydescp   VARCHAR2(8);
 
 Begin
 
   lc_fecha1 := to_char(to_date(ld_FchSist, 'dd/mm/rrrr'), 'dd/mm/yyyy');
   lc_fechaS := replace(lc_fecha1, '/', '');
 
   ln_diaS  := SubStr(lc_fechaS, 1, 2);
   ln_MesS  := SubStr(lc_fechaS, 3, 2);
   ln_AnioS := SubStr(lc_fechaS, 5, 4);
   lc_flgI  := 'B';
 
   select to_char(sysdate, 'hh24:mi:ss') into lc_hora from dual;
 
   ld_Fnac := pd_fchnc;
 
   If ld_Fnac <> '01/01/0001' then
   
     lc_fecha2 := ld_Fnac;
     lc_fechaA := replace(lc_fecha2, '/', '');
   
     ln_diaN  := SubStr(lc_fechaA, 1, 2);
     ln_MesN  := SubStr(lc_fechaA, 3, 2);
     ln_AnioN := SubStr(lc_fechaA, 5, 4);
   
     ln_ResAn := ln_AnioS - ln_AnioN;
   
     ---------------------------------------
     select jj.jaqy783cod,
            jj.jaqy783mod,
            jj.jaqy783suc,
            jj.jaqy783mda,
            jj.jaqy783pap,
            jj.jaqy783cta,
            jj.jaqy783oper,
            jj.jaqy783sbop,
            jj.jaqy783tope,
            jj.jaqy783fchmax,
            jj.jaqy783imp11,
            jj.jaqy783imp12,
            jj.jaqy783imp13,
            jj.jaqy783imp14,
            jj.jaqy783imp15,
            jj.jaqy783numcuot,
            jj.jaqy783fchpag,
            jj.jaqy783est,
            jj.jaqy783descp
       into ycod,
            ymod,
            ysuc,
            ymda,
            ypap,
            ycta,
            yoper,
            ysbop,
            ytope,
            yfchmax,
            yimp11,
            yimp12,
            yimp13,
            ymp14,
            yimp15,
            ynumcuot,
            yfchpag,
            yest,
            ydescp
       from jaqy783 jj
      where jj.jaqy783cod = pn_cod
        and jj.jaqy783mod = pn_mod
        and jj.jaqy783suc = pn_suc
        and jj.jaqy783mda = pn_mda
        and jj.jaqy783pap = pn_pap
        and jj.jaqy783cta = pn_cta
        and jj.jaqy783oper = pn_oper
        and jj.jaqy783sbop = pn_sbop
        and jj.jaqy783tope = pn_tope;
     ---------------------------------------
   
     If ln_ResAn = 70 and ln_MesS = ln_MesN then
       If to_date(lc_fecha1, 'DD/MM/YYYY') >
          to_date(lc_fecha2, 'DD/MM/YYYY') then
       
         ln_ResDi := ln_diaS - ln_diaN;
       
         If ln_ResDi = -1 then
           lc_flag := 'S';
           begin
             insert into jaqy784
               (jaqy784cod,
                jaqy784mod,
                jaqy784suc,
                jaqy784mda,
                jaqy784pap,
                jaqy784cta,
                jaqy784oper,
                jaqy784sbop,
                jaqy784tope,
                jaqy784FchMax,
                jaqy784imp11,
                jaqy784imp12,
                jaqy784imp13,
                jaqy784imp14,
                jaqy784imp15,
                jaqy784NumCuoT,
                jaqy784FchPag,
                jaqy784Est,
                jaqy784Descp,
                jaqy784Anios,
                jaqy784FchNc,
                jaqy784Ident,
                jaqy784FchSis,
                jaqy784HraSis)
             values
               (ycod,
                ymod,
                ysuc,
                ymda,
                ypap,
                ycta,
                yoper,
                ysbop,
                ytope,
                yfchmax,
                yimp11,
                yimp12,
                yimp13,
                ymp14,
                yimp15,
                ynumcuot,
                yfchpag,
                yest,
                ydescp,
                ln_ResAn,
                pd_fchnc,
                lc_flgI,
                ld_FchSist,
                lc_hora);
             commit;
           exception
             when dup_val_on_index then
               begin
                 insert into jaqy751
                   (jaqy751cod,
                    jaqy751mod,
                    jaqy751suc,
                    jaqy751mda,
                    jaqy751pap,
                    jaqy751cta,
                    jaqy751oper,
                    jaqy751sbop,
                    jaqy751tope,
                    jaqy751FchMax,
                    jaqy751imp11,
                    jaqy751imp12,
                    jaqy751imp13,
                    jaqy751imp14,
                    jaqy751imp15,
                    jaqy751NumCuoT,
                    jaqy751FchPag,
                    jaqy751Est,
                    jaqy751Descp,
                    jaqy751FchNc,
                    jaqy751FchSis,
                    jaqy751HraSis)
                 values
                   (ycod,
                    ymod,
                    ysuc,
                    ymda,
                    ypap,
                    ycta,
                    yoper,
                    ysbop,
                    ytope,
                    yfchmax,
                    yimp11,
                    yimp12,
                    yimp13,
                    ymp14,
                    yimp15,
                    ynumcuot,
                    yfchpag,
                    yest,
                    ydescp,
                    pd_fchnc,
                    ld_FchSist,
                    lc_hora);
               commit;
               exception
                 when dup_val_on_index then
                   null;
               end;     
           end;
         End If;
         ln_ResDi := 0;
       End If;
     End If;
   End If;
   ln_ResAn  := 0;
   lc_hora   := null;
   ld_Fnac   := null;
   lc_fecha2 := null;
   lc_fechaA := null;
   ln_diaN   := 0;
   ln_MesN   := 0;
   ln_AnioN  := 0;
 
 End sp_Clientes_70;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Backup_FSD611(pn_cod     in number,
                             pn_mod     in number,
                             pn_suc     in number,
                             pn_mda     in number,
                             pn_pap     in number,
                             pn_cta     in number,
                             pn_oper    in number,
                             pn_sbop    in number,
                             pn_tope    in number,
                             ld_FchSist in date,
                             pc_hrasis  in char) is


    Cursor Fsdata2 is
      select fs.*
        from fsd611 fs
       where fs.pgcod  = pn_cod
         and fs.ppmod  = pn_mod
         and fs.ppsuc  = pn_suc
         and fs.ppmda  = pn_mda
         and fs.pppap  = pn_pap
         and fs.ppcta  = pn_cta
         and fs.ppoper = pn_oper
         and fs.ppsbop = pn_sbop
         and fs.pptope = pn_tope;

  BEGIN
    
      For d in Fsdata2 loop
      
        Begin
        
          insert into jaqy785
            (jaqy785cod,
             jaqy785mod,
             jaqy785suc,
             jaqy785mda,
             jaqy785pap,
             jaqy785cta,
             jaqy785oper,
             jaqy785sbop,
             jaqy785tope,
             jaqy785fpag,
             jaqy785tipo,
             jaqy785exte,
             jaqy785imp1,
             jaqy785imp2,
             jaqy785imp3,
             jaqy785imp4,
             jaqy785imp5,
             jaqy785imp6,
             jaqy785imp7,
             jaqy785imp8,
             jaqy785imp9,
             jaqy785imp10,
             jaqy785imp11,
             jaqy785imp12,
             jaqy785imp13,
             jaqy785imp14,
             jaqy785imp15,
             jaqy785imp16,
             jaqy785imp17,
             jaqy785imp18,
             jaqy785imp19,
             jaqy785imp20,
             jaqy785fsist,
             jaqy785HraSis)
          values
            (d.pgcod,
             d.ppmod,
             d.ppsuc,
             d.ppmda,
             d.pppap,
             d.ppcta,
             d.ppoper,
             d.ppsbop,
             d.pptope,
             d.ppfpag,
             d.pptipo,
             d.ppexte,
             d.ppimp1,
             d.ppimp2,
             d.ppimp3,
             d.ppimp4,
             d.ppimp5,
             d.ppimp6,
             d.ppimp7,
             d.ppimp8,
             d.ppimp9,
             d.ppimp10,
             d.ppimp11,
             d.ppimp12,
             d.ppimp13,
             d.ppimp14,
             d.ppimp15,
             d.ppimp16,
             d.ppimp17,
             d.ppimp18,
             d.ppimp19,
             d.ppimp20,
             ld_FchSist,
             pc_hrasis);
          commit;
        exception
          when dup_val_on_index then
            null;  
        End;
      End loop;
      commit;
      --ln_CtaTm := ln_cta;

  End sp_Backup_FSD611;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Backup_FPP001(pn_cod     in number,
                            pn_mod     in number,
                            pn_suc     in number,
                            pn_mda     in number,
                            pn_pap     in number,
                            pn_cta     in number,
                            pn_oper    in number,
                            pn_sbop    in number,
                            pn_tope    in number,
                            ld_FchSist in date,
                            pc_hrasis  in char) is
  
           
   Cursor Fpdata2 is 
    select fp.*
      from fpp001 fp
     where fp.pgcod   = pn_cod 
       and fp.aomod   = pn_mod  
       and fp.aosuc   = pn_suc 
       and fp.aomda   = pn_mda 
       and fp.aopap   = pn_pap 
       and fp.aocta   = pn_cta 
       and fp.aooper  = pn_oper
       and fp.aosbop  = pn_sbop
       and fp.aotope  = pn_tope;  
     
BEGIN  
 
       For d in Fpdata2 loop 

       Begin    
             insert into jaqy786 
             (    
                  jaqy786pgcod, 
                  jaqy786mod, 
                  jaqy786suc, 
                  jaqy786mda, 
                  jaqy786pap, 
                  jaqy786cta, 
                  jaqy786oper,
                  jaqy786sbop,
                  jaqy786tope,
                  jaqy786sgcod, 
                  jaqy786vc,    
                  jaqy786imp,   
                  jaqy786porc,  
                  jaqy786plus,  
                  jaqy786part,  
                  jaqy786veh,   
                  jaqy786inm,   
                  jaqy786end,   
                  jaqy786stat,  
                  jaqy786co,    
                  jaqy786aux1,  
                  jaqy786aux2,  
                  jaqy786aux3,  
                  jaqy786aux4,  
                  jaqy786aux5,  
                  jaqy786aux6,  
                  jaqy786aux7,
                  jaqy786fsist,
                  jaqy786HraSis
             ) 
             values 
             (   
                  d.pgcod,
                  d.aomod,
                  d.aosuc,
                  d.aomda,
                  d.aopap,
                  d.aocta,
                  d.aooper,
                  d.aosbop,
                  d.aotope,
                  d.sgcod,
                  d.pp001vc,
                  d.pp001imp,
                  d.pp001porc,
                  d.pp001plus,
                  d.pp001part,
                  d.pp001veh,
                  d.pp001inm,
                  d.pp001end,
                  d.pp001stat,
                  d.pp001co,
                  d.pp001aux1,
                  d.pp001aux2,
                  d.pp001aux3,
                  d.pp001aux4,
                  d.pp001aux5,
                  d.pp001aux6,
                  d.pp001aux7,
                  ld_FchSist,
                  pc_hrasis
              );     
              commit; 
          exception
            when dup_val_on_index then
              null;    
          End;        
       End loop;
       commit;
       --ln_CtaTm := ln_cta;  
       
 End sp_Backup_FPP001; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Mover_Eliminar_Seguros(pn_cod     in number,
                                     pn_mod     in number,
                                     pn_suc     in number,
                                     pn_mda     in number,
                                     pn_pap     in number,
                                     pn_cta     in number,
                                     pn_oper    in number,
                                     pn_sbop    in number,
                                     pn_tope    in number,
                                     --ld_FchSist in date,
                                     pc_descp   in varchar2,
                                     pd_fchpag  in date) is
 
    
    Cursor Move2 is 
                          
     select q.*
       from fpp001 q  
      where q.pgcod  = pn_cod
        and q.aomod  = pn_mod 
        and q.aosuc  = pn_suc
        and q.aomda  = pn_mda
        and q.aopap  = pn_pap 
        and q.aocta  = pn_cta 
        and q.aooper = pn_oper
        and q.aosbop = pn_sbop
        and q.aotope = pn_tope;
                
    ln_seg    number(9); 
    ln_imp    number(17,2);
    ln_contsg number(3);
    lc_flgV   char(3);
    --ln_fpag   date;
    
    ln_posic1  number(3);
    ln_posic2  number(3);
    ln_posic3  number(3);
    ln_posic4  number(3);
    ln_posic5  number(3);
    ln_codseg1 number(9);
    ln_codseg2 number(9);
    ln_codseg3 number(9);
    ln_codseg4 number(9);
    ln_codseg5 number(9);
    
BEGIN     
         
         ln_contsg := 0;   
         
         ln_codseg1 := 0;
         ln_codseg2 := 0;
         ln_codseg3 := 0;
         ln_codseg4 := 0;
         ln_codseg5 := 0; 
         ln_posic1  := 1;
         ln_posic2  := 2;
         ln_posic3  := 3;
         ln_posic4  := 4;
         ln_posic5  := 5;        
         
         For y in Move2 loop
         
         ln_seg    := y.sgcod; 
         ln_imp    := y.pp001imp;
         ln_contsg := ln_contsg + 1;
 
        begin 
         select 'V/F' 
           into lc_flgV
           from fst098 f
          where f.pgcod = 6
            and f.tpcod = 7665
            and f.tpimp = ln_seg;
         exception when others then 
             lc_flgV := null;
             Case
                when ln_posic1 = ln_contsg then
                     ln_codseg1 := ln_seg;
                when ln_posic2 = ln_contsg then
                     ln_codseg2 := ln_seg;
                when ln_posic3 = ln_contsg then
                     ln_codseg3 := ln_seg;
                when ln_posic4 = ln_contsg then
                     ln_codseg4 := ln_seg;
                when ln_posic5 = ln_contsg then
                     ln_codseg5 := ln_seg;
            End Case;
         end;
            
       End loop; 
       
            If ln_codseg5 = 0 then   
       
               If pc_descp = 'ConCalen' then
                 Update fsd611 t 
                    set t.ppimp15 = 0.00
                  where t.ppcta   = pn_cta --x.jaqy784cta
                    and t.ppoper  = pn_oper --x.jaqy784oper
                    and t.ppfpag  > pd_fchpag; --ln_fpag; --x.jaqy784fchpag;
                commit; 
               Else
                  If pc_descp = 'Sin Calen' then
                     Update fsd611 t 
                        set t.ppimp15 = 0.00
                      where t.ppcta   = pn_cta --x.jaqy784cta
                        and t.ppoper  = pn_oper; --x.jaqy784oper;
                    commit; 
                  End If; 
               End If; 
            End If;
               
            If ln_codseg4 = 0 then 
            
               If pc_descp = 'ConCalen' then
                     Update fsd611 t 
                        set t.ppimp14 = t.ppimp15,
                            t.ppimp15 = 0.00
                      where t.ppcta   = pn_cta --x.jaqy784cta
                        and t.ppoper  = pn_oper -- x.jaqy784oper
                        and t.ppfpag  > pd_fchpag; --ln_fpag; --x.jaqy784fchpag;
                     commit; 
               Else
                      Update fsd611 t 
                         set t.ppimp14 = t.ppimp15,
                             t.ppimp15 = 0.00
                       where t.ppcta   = pn_cta --x.jaqy784cta
                         and t.ppoper  = pn_oper; --x.jaqy784oper;
                      commit; 
               End If;   
             End If;
                    
             If ln_codseg3 = 0 then 
                
                If pc_descp = 'ConCalen' then
                     Update fsd611 t 
                        set t.ppimp13 = t.ppimp14,
                            t.ppimp14 = t.ppimp15,
                            t.ppimp15 = 0.00
                      where t.ppcta   = pn_cta --x.jaqy784cta
                        and t.ppoper  = pn_oper --x.jaqy784oper
                        and t.ppfpag  > pd_fchpag; --ln_fpag; --x.jaqy784fchpag;
                     commit; 
                Else
                      Update fsd611 t 
                         set t.ppimp13 = t.ppimp14,
                             t.ppimp14 = t.ppimp15,
                             t.ppimp15 = 0.00
                       where t.ppcta   = pn_cta --x.jaqy784cta
                         and t.ppoper  = pn_oper; --x.jaqy784oper;
                      commit; 
                End If;   
             End If;
                 
             If ln_codseg2 = 0 then 
                
                If pc_descp = 'ConCalen' then
                     Update fsd611 t 
                        set t.ppimp12 = t.ppimp13,
                            t.ppimp13 = t.ppimp14,
                            t.ppimp14 = t.ppimp15,
                            t.ppimp15 = 0.00
                      where t.ppcta   = pn_cta --x.jaqy784cta
                        and t.ppoper  = pn_oper --x.jaqy784oper
                        and t.ppfpag  > pd_fchpag; --ln_fpag; --x.jaqy784fchpag;
                     commit; 
                Else
                      Update fsd611 t 
                         set t.ppimp12 = t.ppimp13,
                             t.ppimp13 = t.ppimp14,
                             t.ppimp14 = t.ppimp15,
                             t.ppimp15 = 0.00
                       where t.ppcta   = pn_cta --x.jaqy784cta
                         and t.ppoper  = pn_oper; --x.jaqy784oper;
                      commit; 
                End If;   
             End If;
             
             If ln_codseg1 = 0 then 
                
                If pc_descp = 'ConCalen' then
                     Update fsd611 t 
                        set t.ppimp11 = t.ppimp12,
                            t.ppimp12 = t.ppimp13,
                            t.ppimp13 = t.ppimp14,
                            t.ppimp14 = t.ppimp15,
                            t.ppimp15 = 0.00
                      where t.ppcta   = pn_cta --x.jaqy784cta
                        and t.ppoper  = pn_oper --x.jaqy784oper
                        and t.ppfpag  > pd_fchpag; --ln_fpag; --x.jaqy784fchpag;
                     commit; 
                Else
                      Update fsd611 t 
                         set t.ppimp11 = t.ppimp12,
                             t.ppimp12 = t.ppimp13,
                             t.ppimp13 = t.ppimp14,
                             t.ppimp14 = t.ppimp15,
                             t.ppimp15 = 0.00
                       where t.ppcta   = pn_cta --x.jaqy784cta
                         and t.ppoper  = pn_oper; --x.jaqy784oper;
                      commit; 
                End If; 
            End If;  
            
         delete from fpp001 t   
          where t.pgcod  = pn_cod 
            and t.aomod  = pn_mod 
            and t.aosuc  = pn_suc 
            and t.aomda  = pn_mda 
            and t.aopap  = pn_pap 
            and t.aocta  = pn_cta 
            and t.aooper = pn_oper 
            and t.aosbop = pn_sbop 
            and t.aotope = pn_tope 
            --and t.sgcod in (120,121,122,200,201,202);
            and (t.sgcod in (select tp1nro3 
                              from fst198 
                             where Tp1cod   = 1 
                               and Tp1cod1  = 10898 
                               and Tp1corr1 = 18)    ---or t.sgcod in (116,117,118)
            ); 
           commit;
   -- End loop; 
    
    
 End sp_Mover_Eliminar_Seguros;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
End PQ_OP_PERMANENCIA_POLIZA;
/

