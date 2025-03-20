create or replace package PQ_CR_TRANSF_60DIASJUDCAS is

  -- Author  : SMARQUEZ
  -- Created : 22/01/2018 15:22:36
  -- Purpose : TRANSFERENCIA OTES  CREDITOS MORA MAY 60 DIAS ,JUDICIAL, CASTIGADOS

  -- Public type declarations
  PROCEDURE SP_CR_CARGADATA_JOB;

  PROCEDURE SP_LLENA_SEGUROS(PD_FECHA IN DATE);

  PROCEDURE DESAFILIACION (P_SUC IN NUMBER,
                           P_MDA IN NUMBER,
                           P_PAP IN NUMBER,
                           P_CTA IN NUMBER,
                           P_OPE IN NUMBER,
                           P_SBO IN NUMBER,
                           P_SEG IN NUMBER,
                           FLAGD OUT CHAR,
                           S_SEG OUT NUMBER,
                           S_TSG OUT NUMBER,
                           S_DES OUT VARCHAR2,
                           S_RUB OUT NUMBER,
                           S_SDO OUT NUMBER);

  PROCEDURE VERIFICA_SALDO(P_SUC IN NUMBER,
                           P_MDA IN NUMBER,
                           P_PAP IN NUMBER,
                           P_CTA IN NUMBER,
                           P_OPE IN NUMBER,
                           P_TIP IN NUMBER,
                           FLAGD OUT CHAR,
                           S_RUB OUT NUMBER,
                           S_SDO OUT NUMBER);
end PQ_CR_TRANSF_60DIASJUDCAS;
/

create or replace package body PQ_CR_TRANSF_60DIASJUDCAS is

PROCEDURE SP_CR_CARGADATA_JOB is

    lc_variable varchar2(1000);
    ln_job number := 0;
    lc_hostname varchar2(64);
Begin

  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;

  execute immediate ('truncate table JAQZ559'); --->>>>>> Tabla temporal
  delete  jaqz559h where jaqz559mdh is  null ;
  commit;
   

       lc_variable := ' begin ' || ' PQ_CR_TRANSF_60DIASJUDCAS.SP_LLENA_SEGUROS' ||
                       ' End; ';
        ln_job := ln_job + 1;

--        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','PPDB1051')   then
          IF SYS.FN_BD_ISRAC='TRUE' THEN
            DBMS_JOB.SUBMIT(job       => ln_job,
                            what      => lc_variable,
                            next_date => sysdate + 1 / (24 * 60),
                            interval  => null,
                            no_parse  => false,
                            instance  => 1, --- 2, solo pruebas
                            force => false);
         else
            DBMS_JOB.SUBMIT(job  => ln_job,
                            what => lc_variable,
                            next_date => sysdate,
                            interval => null,
                            no_parse => false,
                            force => false );

         end if;
        commit;

 

 end SP_CR_CARGADATA_JOB;

 PROCEDURE SP_LLENA_SEGUROS (PD_FECHA IN DATE) is
  -- CURSOR SEGUROS(TIPO_SEGURO IN NUMBER)
  cursor estado200_33(p_fecha in date) is
      select r.hcta cta, r.hoper oper, r.hmodul modulo1, q.jaql166scmod modulo, q.jaql166scsuc suc,
              q.jaql166scmda mda, q.jaql166scpap pap,q.jaql166scsbo sbo, q.jaql166sctop top, s.sgcod seguro,
              (select tp1desc
                 from fst198
                where tp1cod = 1
                  and tp1cod1 = 10875
                  and tp1corr1 = 4
                  and tp1corr2 = 1
                  and tp1nro1 = s.sgcod) descri,
              (select tp1nro2
                 from fst198
                where tp1cod = 1
                  and tp1cod1 = 10875
                  and tp1corr1 = 4
                  and tp1corr2 = 1
                  and tp1nro1 = s.sgcod) tipo
        from fsh016 r,
             fsh015 f15,
             jaql166 q,--
             fpp001 s,
             fsd010 p
       where r.pgcod = 1
         and r.hsucor = q.d166su
         and r.hcmod = q.d166mo
         and r.htran = q.d166tr
         and r.hnrel = q.d166re
         and r.hfcon  = q.jaql166scfvl --
         and r.hcta = q.jaql166sccta
         and r.hoper = q.jaql166scope
         and r.hfcon = p_fecha
         and r.hcord = 10
         and q.jaql166scmod in (33,200)
         and s.pgcod = r.pgcod
         and s.aomod = r.hmodul
         and s.aosuc = r.hsucur
         and s.aomda = r.hmda
         and s.aopap = r.hpap
         and s.aocta = r.hcta
         and s.aooper = r.hoper
        -- and s.aocta = 1123595---pruebas
         and s.sgcod in (select tp1nro1 from fst198 where tp1cod=1 and tp1cod1=10875 and tp1corr1= 4 and tp1corr2=1)
         and q.jaql166pgcod = p.pgcod
         and q.jaql166scmod = p.aomod
         and q.jaql166scsuc = p.aosuc
         and q.jaql166scmda = p.aomda
         and q.jaql166scpap = p.aopap
         and q.jaql166sccta = p.aocta
         and q.jaql166scope = p.aooper
         and q.jaql166scsbo = p.aosbop
         and q.jaql166sctop = p.aotope
         and p.aostat <> 99
         AND f15.pgcod = 1
         and f15.hsucor = q.d166su
         and f15.hcmod = q.d166mo
         and f15.htran = q.d166tr
         and f15.hnrel = q.d166re
         and f15.hfcon  = q.jaql166scfvl
         and f15.hccorr = 0 ;

   cursor desafilia60d(p_fecha in date) is
      select *
        from jaqy701;
        
 ld_fecha  date;
 motivo    varchar2(30);
 codigo    varchar2(1);
 seguro    number;
 tiposeg   number;
 descripcion char(30);
 flagEx    char(1);
 flagVS    char(1);
 rubro     number;
 saldo     number(17,2);


 begin
   
  execute immediate ('truncate table JAQZ559'); --->>>>>> Tabla temporal
  delete  jaqz559h where jaqz559mdh is  null;  
  commit;

  -- Select pgfape into ld_fecha from fst017 where pgcod = 1;
   ld_fecha := PD_FECHA;
   For b in estado200_33(ld_fecha) loop
      rubro := 0;
      saldo := 0;
      Verifica_Saldo(b.suc,                  
                     b.mda,
                     b.pap,
                     b.cta,
                     b.oper,
                     b.tipo,
                     flagVS,
                     rubro,
                     saldo);

     if flagVS = 'S' then

          motivo := 'Estados Judiacial/Castigado';
          codigo := '3';
          Begin
            insert into JAQZ559(jaqz559pgc,
                                jaqz559mod,
                                jaqz559suc,
                                jaqz559mda,
                                jaqz559pap,
                                jaqz559cta,
                                jaqz559ope,
                                jaqz559sbo,
                                jaqz559top,
                                jaqz559fec,
                                jaqz559seg,
                                jaqz559tip,
                                jaqz559dsc,
                                jaqz559mot,
                                jaqz559cod,
                                jaqz559rub,
                                jaqz559sdo)
                         VALUES(1,
                                b.modulo,
                                b.suc,
                                b.mda,
                                b.pap,
                                b.cta,
                                b.oper,
                                b.sbo,
                                b.top,
                                ld_fecha,
                                b.seguro,
                                b.tipo,
                                b.descri,
                                motivo,
                                codigo,
                                rubro,
                                saldo);
               commit;
          exception
            when dup_val_on_index then
              null;
          end;
          begin
           insert into JAQZ559H(jaqz559pgch,
                                jaqz559modh,
                                jaqz559such,
                                jaqz559mdah,
                                jaqz559paph,
                                jaqz559ctah,
                                jaqz559opeh,
                                jaqz559sboh,
                                jaqz559toph,
                                jaqz559fech,
                                jaqz559segh,
                                jaqz559tiph,
                                jaqz559dsch,
                                jaqz559moth,
                                jaqz559codh,
                                jaqz559rubh,
                                jaqz559sdoh)
                         VALUES(1,
                                b.modulo,
                                b.suc,
                                b.mda,
                                b.pap,
                                b.cta,
                                b.oper,
                                b.sbo,
                                b.top,
                                ld_fecha,
                                b.seguro,
                                b.tipo,
                                b.descri,
                                motivo,
                                codigo,
                                rubro,
                                saldo);

                      commit;
        exception
          when dup_val_on_index then          
               null;
        end;
     end if;

   end loop;

   For a in desafilia60d(ld_fecha) loop

     DESAFILIACION (a.jaqy701suc,
                    a.jaqy701mda,
                    a.jaqy701pap,
                    a.jaqy701cta,
                    a.jaqy701oper,
                    a.jaqy701sbop,
                    a.jaqy701sgcod,
                    flagEx ,
                    seguro,
                    tiposeg,
                    descripcion,
                    rubro,
                    saldo);

     if  flagEx = 'S' then

          motivo := 'Desafiliacion 60 DIAS';
          codigo := '1';
         Begin
            insert into JAQZ559(jaqz559pgc,
                                jaqz559mod,
                                jaqz559suc,
                                jaqz559mda,
                                jaqz559pap,
                                jaqz559cta,
                                jaqz559ope,
                                jaqz559sbo,
                                jaqz559top,
                                jaqz559fec,
                                jaqz559seg,
                                jaqz559tip,
                                jaqz559dsc,
                                jaqz559mot,
                                jaqz559cod,
                                jaqz559rub,
                                jaqz559sdo)
                         VALUES(1,
                                a.jaqy701mod,
                                a.jaqy701suc,
                                a.jaqy701mda,
                                a.jaqy701pap,
                                a.jaqy701cta,
                                a.jaqy701oper,
                                a.jaqy701sbop,
                                a.jaqy701tope,
                                ld_fecha,
                                seguro,
                                tiposeg,
                                descripcion,
                                motivo,
                                codigo,
                                rubro,
                                saldo
                                );
         commit;
         exception
             when dup_val_on_index then
               null;
         end;
         Begin
           insert into JAQZ559h(jaqz559pgch,
                                jaqz559modh,
                                jaqz559such,
                                jaqz559mdah,
                                jaqz559paph,
                                jaqz559ctah,
                                jaqz559opeh,
                                jaqz559sboh,
                                jaqz559toph,
                                jaqz559fech,
                                jaqz559segh,
                                jaqz559tiph,
                                jaqz559dsch,
                                jaqz559moth,
                                jaqz559codh,
                                jaqz559rubh,
                                jaqz559sdoh)
                         VALUES(1,
                                a.jaqy701mod,
                                a.jaqy701suc,
                                a.jaqy701mda,
                                a.jaqy701pap,
                                a.jaqy701cta,
                                a.jaqy701oper,
                                a.jaqy701sbop,
                                a.jaqy701tope,
                                ld_fecha,
                                seguro,
                                tiposeg,
                                descripcion,
                                motivo,
                                codigo,
                                rubro,
                                saldo
                                );
                      commit;
        exception
          when dup_val_on_index then
             null;
        end;
     end if;
   End loop;
 END SP_LLENA_SEGUROS;
 
 PROCEDURE DESAFILIACION (P_SUC IN NUMBER,
                           P_MDA IN NUMBER,
                           P_PAP IN NUMBER,
                           P_CTA IN NUMBER,
                           P_OPE IN NUMBER,
                           P_SBO IN NUMBER,
                           P_SEG IN NUMBER,
                           FLAGD OUT CHAR,
                           S_SEG OUT NUMBER,
                           S_TSG OUT NUMBER,
                           S_DES OUT VARCHAR2,
                           S_RUB OUT NUMBER,
                           S_SDO OUT NUMBER) IS
  flagseg     char(1) := 'N';
  Begin
    Begin
       Select tp1nro1,tp1nro2,tp1desc
         into S_SEG, S_TSG, S_DES

         from fst198
        where tp1cod = 1
          and tp1cod1 = 10875
          and tp1corr1 = 4
          and tp1corr2 = 1
          and tp1nro1 = P_SEG;
          flagseg := 'S';
     exception
       when no_data_found then
         null;
     end;
     flagD :='N';
     if flagseg  = 'S' and S_TSG = 1 then
       begin
         Select scrub, scsdo
           into S_RUB, S_SDO
           from fsd011
          where pgcod = 1
            and scsuc = P_SUC
            and scrub in (2514020000008, 2524020000008)
            and scmda = P_MDA
            and scpap = P_PAP
            and sccta = P_CTA
            and scoper = P_OPE
            and scsbop = P_SBO
            and sctope = 0
            and scmod  = 260
            and scsdo > 0;
            flagD:= 'S';
        exception
          when no_Data_found then
            S_RUB := 0;
            S_SDO := 0;
        end;
     else
       if flagseg = 'S' and S_TSG = 2 then
         begin
           Select scrub, scsdo
             into S_RUB, S_SDO
             from fsd011
            where pgcod = 1
              and scsuc = P_SUC
              and scrub in (2514020000013, 2524020000013)
              and scmda = P_MDA
              and scpap = P_PAP
              and sccta = P_CTA
              and scoper = P_OPE
              and scsbop = P_SBO
              and sctope = 0
              and scmod  = 260
              and scsdo > 0;
              flagD := 'S';
         exception
           when no_Data_found then
             S_RUB := 0;
             S_SDO := 0;
         end;
       end if;
     end if;
 end DESAFILIACION;

 Procedure Verifica_Saldo (P_SUC IN NUMBER,
                           P_MDA IN NUMBER,
                           P_PAP IN NUMBER,
                           P_CTA IN NUMBER,
                           P_OPE IN NUMBER,
                           P_TIP IN NUMBER,
                           FLAGD OUT CHAR,
                           S_RUB OUT NUMBER,
                           S_SDO OUT NUMBER)IS

 Begin
   case
     WHEN P_TIP = 1 THEN
            Begin
               Select scrub, scsdo
                 into S_RUB, S_SDO
                 from fsd011
                where pgcod = 1
                  and scsuc = P_SUC
                  and scrub in (2514020000008, 2524020000008)
                  and scmda = P_MDA
                  and scpap = P_PAP
                  and sccta = P_CTA
                  and scoper = P_OPE
                  and scsbop = 0
                  and sctope = 0
                  and scmod  = 260
                  and scsdo > 0;
                  flagD:= 'S';
             exception
               when no_data_found then
                  flagD:= 'N';
                  S_RUB:= 0;
                  S_SDO:= 0;
             end ;
     WHEN P_TIP = 2 THEN
            Begin
               Select scrub, scsdo
                 into S_RUB, S_SDO
                 from fsd011
                where pgcod = 1
                  and scsuc = P_SUC
                  and scrub in (2514020000013, 2524020000013)
                  and scmda = P_MDA
                  and scpap = P_PAP
                  and sccta = P_CTA
                  and scoper = P_OPE
                  and scsbop = 0
                  and sctope = 0
                  and scmod  = 260
                  and scsdo > 0;
                  flagD:= 'S';
             exception
               when no_data_found then
                 flagD:= 'N';
                  S_RUB:= 0;
                  S_SDO:= 0;
             end ;
     WHEN P_TIP = 3 THEN
            Begin
               Select scrub, scsdo
                 into S_RUB, S_SDO
                 from fsd011
                where pgcod = 1
                  and scsuc = P_SUC
                  and scrub in (2514020000002, 2524020000002)
                  and scmda = P_MDA
                  and scpap = P_PAP
                  and sccta = P_CTA
                  and scoper = P_OPE
                  and scsbop = 0
                  and sctope = 0
                  and scmod  = 260
                  and scsdo > 0;
                  flagD:= 'S';
             exception
               when no_data_found then
                flagD:= 'N';
                  S_RUB:= 0;
                  S_SDO:= 0;
             end ;
      WHEN P_TIP = 4 THEN
            Begin
               Select scrub, scsdo
                 into S_RUB, S_SDO
                 from fsd011
                where pgcod = 1
                  and scsuc = P_SUC
                  and scrub in (2514020000007, 2524020000007)
                  and scmda = P_MDA
                  and scpap = P_PAP
                  and sccta = P_CTA
                  and scoper = P_OPE
                  and scsbop = 0
                  and sctope = 0
                  and scmod  = 260
                  and scsdo > 0;
                  flagD:= 'S';
             exception
               when no_data_found then
                 flagD:= 'N';
                  S_RUB:= 0;
                  S_SDO:= 0;
             end ;
     WHEN P_TIP = 5 THEN
            Begin
               Select scrub, scsdo
                 into S_RUB, S_SDO
                 from fsd011
                where pgcod = 1
                  and scsuc = P_SUC
                  and scrub in (2514020000014, 2524020000014)
                  and scmda = P_MDA
                  and scpap = P_PAP
                  and sccta = P_CTA
                  and scoper = P_OPE
                  and scsbop = 0
                  and sctope = 0
                  and scmod  = 260
                  and scsdo > 0;
                  flagD:= 'S';
             exception
               when no_data_found then
                 flagD:= 'N';
                  S_RUB:= 0;
                  S_SDO:= 0;
             end ;
   WHEN P_TIP = 6 THEN
            Begin
               Select scrub, scsdo
                 into S_RUB, S_SDO
                 from fsd011
                where pgcod = 1
                  and scsuc = P_SUC
                  and scrub in (2514020000015, 2524020000015)
                  and scmda = P_MDA
                  and scpap = P_PAP
                  and sccta = P_CTA
                  and scoper = P_OPE
                  and scsbop = 0
                  and sctope = 0
                  and scmod  = 260
                  and scsdo > 0;
                  flagD:= 'S';
             exception
               when no_data_found then
                 flagD:= 'N';
                  S_RUB:= 0;
                  S_SDO:= 0;
             end ;
   end case;
 End Verifica_Saldo;

end PQ_CR_TRANSF_60DIASJUDCAS;
/

