create or replace package PQ_OP_PROCESO_LLENADO is

  Procedure sp_Inserta_Cabecera(pc_uing in varchar2, --usuario
                                --pc_empresa in varchar2, --nombre de la empresa //--> COMENT @MPCA 25/04/2019
                                pn_codemp in number,
                                pn_grupo  in number, --número de grupo
                                dn_nvio   out number);
  Procedure sp_Inserta_FSD011;
  Procedure sp_Inserta_Detalle(pn_nvio in number);
  Procedure sp_Inserta_Temporal;
  Procedure Sp_MiVivienda(pn_emp in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_suc in number,
                         pn_pap in number,
                         pn_sbop in number,
                         pn_mda in number,
                         pn_mod in number,
                         pn_top in number,                         
                         pc_flg out char);--mod@kdvc  2019.09.06
end PQ_OP_PROCESO_LLENADO;
/

create or replace package body PQ_OP_PROCESO_LLENADO is
  -- *****************************************************************
    -- Nombre                     : PROCESO DE LLENADO - VENTA DE CARTERA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.08.12
    -- Autor de Creación          : MSOLARI 
    -- Uso                        : GENERACION DE DATA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 05/05/2019
    -- Autor de la Modificación   : MCANDIA
    -- Descripción de Modificación: Se modifico procedimiento que carga cabecera jaqy952 sp_Inserta_Cabecera    
    -- Fecha de Modificación      : 2019.09.06
    -- Autor de la Modificación   : kvalencia
    -- Descripción de Modificación: Se incluyo un control para no insertar creditos que hayan sido o son
    --                              de MiVivienda
    -- *****************************************************************
  procedure sp_Inserta_Cabecera(pc_uing in varchar2, --usuario
                                --pc_empresa in varchar2, --nombre de la empresa --> COMENT @MPCA 25/04/2019
                                pn_codemp in number,
                                pn_grupo  in number, --número de grupo
                                dn_nvio   out number) is
  
    ln_nvio    number;
    ld_fecha   date;
    lc_hora    char(8);
    lc_usuario char(10);
    -- lc_nomb    varchar2(50); --> COMENT @MPCA 25/04/2019
    lc_nomb  char(70); -- AGREGADO @MPCA 25/04/2019
    ln_grupo number;
    --pn_nvio  number;
  
  Begin
  
    -- AGREGADO @MPCA 25/04/2019
    begin
      select jaqy470k.jaqy470knomadq
        into lc_nomb
        from jaqy470k
       where jaqy470k.jaqy470kcodadq = pn_codemp;
    exception
      when others then
        null;
    end;
  
    Begin
      select max(jaqy952nro) into ln_nvio from jaqy952; --from jaqy952_VC1;
    End;
  
    If ln_nvio is null then
      ln_nvio := 1;
    Else
      ln_nvio := ln_nvio + 1;
    End If;
  
    select to_char(sysdate, 'dd/mm/rrrr') into ld_fecha from dual;
    select to_char(sysdate, 'hh24:mi:ss') into lc_hora from dual;
  
    lc_usuario := Upper(pc_uing);
    -- lc_nomb    := Upper(pc_empresa); --//> @MPCA COMENT 25/04/2019 
    ln_grupo := pn_grupo;
  
    --insert into JAQY952_VC1 (JAQY952NRO, JAQY952FEC, JAQY952EST, JAQY952ESD, JAQY952AUT, JAQY952ESO, JAQY952CNT, JAQY952USR, JAQY952HOR, JAQY952ATR, JAQY952SDO, JAQY952CAD, JAQY952NAD, JAQY952FEV, JAQY952MOD, JAQY952TOP, JAQY952GRU)
    insert into JAQY952
      (JAQY952NRO,
       JAQY952FEC,
       JAQY952EST,
       JAQY952ESD,
       JAQY952AUT,
       JAQY952ESO,
       JAQY952CNT,
       JAQY952USR,
       JAQY952HOR,
       JAQY952ATR,
       JAQY952SDO,
       JAQY952CAD,
       JAQY952NAD,
       JAQY952FEV,
       JAQY952MOD,
       JAQY952TOP,
       JAQY952GRU)
    values
      (ln_nvio,
       ld_fecha,
       'P',
       'PROPUESTA ',
       '',
       1,
       null,
       lc_usuario,
       lc_hora,
       null,
       null,
       pn_codemp, /* 1,*/
       lc_nomb,
       null,
       null,
       null,
       ln_grupo);
  
    begin
      -- pq_op_proceso_llenado.sp_Inserta_Detalle(pn_nvio => ln_nvio); ---
      pq_op_proceso_llenado.sp_Inserta_FSD011;
      pq_op_proceso_llenado.sp_Inserta_Detalle(ln_nvio);
    
    end;
    Commit;
    dn_nvio := ln_nvio;
  
  end sp_Inserta_Cabecera;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Inserta_FSD011 is
  
    cursor cur_inicio_1 is
      select vt.jaqy953cta,
             vt.jaqy953ope,
             vt.jaqy953mda,
             vt.jaqy953mod,
             vt.JAQY953CAP,
             vt.JAQY953INT,
             vt.JAQY953MOR
        from JAQY953_TEMP vt --->>>>>>Tabla temporal 
      minus
      select vn.jaqy953cta,
             vn.jaqy953ope,
             vn.jaqy953mda,
             vn.jaqy953mod,
             vn.JAQY953CAP,
             vn.JAQY953INT,
             vn.JAQY953MOR
        from JAQY953_TEMP vn, fsd011 f11
       where f11.sccta = vn.jaqy953cta
         and f11.scoper = vn.jaqy953ope
         and f11.scmod = vn.jaqy953mod
         and f11.pgcod = 1;
  
    lc_ob1  varchar2(50);
    ln_num1 number := 0;
    ln_cod1 number := 1;
  
  Begin
    Begin
      select max(jaqy952nro) into ln_num1 from jaqy952;
    End;
    lc_ob1 := 'Credito con modo diferente';
  
    for k in cur_inicio_1 loop
      insert into JAQY953_AUX --->>>Tabla auxiliar
        ("JAQY953AUX_NVIO",
         "JAQY953AUX_CTA",
         "JAQY953AUX_OPE",   
         "JAQY953AUX_MDA",
         "JAQY953AUX_MOD",
         "JAQY953AUX_CAP",
         "JAQY953AUX_INT",
         "JAQY953AUX_MOR",
         "JAQY953AUX_DSC",
         "JAQY953AUX_COD")
      values
        (ln_num1,
         k.JAQY953CTA,
         k.JAQY953OPE,
         k.JAQY953MDA,
         k.JAQY953MOD,
         k.JAQY953CAP,
         k.JAQY953INT,
         k.JAQY953MOR,
         lc_ob1,
         ln_cod1);
    end loop;
    commit;
  End sp_Inserta_FSD011;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Inserta_Detalle(pn_nvio in number) is
  
    cursor cur_inicio_2 is
      select vc.jaqy953cta, vc.jaqy953ope, vc.jaqy953mda, vc.jaqy953mod
        from JAQY953_TEMP vc;
  
    cursor cur_venta(ln_cta  number,
                     ln_oper number,
                     ln_mda  number,
                     ln_mod  number) is
      Select a.jaqy952nro JAQY952NRO,
             B.pgcod      JAQY953EMP,
             B.AOSUC      JAQY953SUC,
             B.AOCTA      JAQY953CTA,
             B.AOPAP      JAQY953PAP,
             B.AOOPER     JAQY953OPE,
             B.AOSBOP     JAQY953SBO,
             a.jaqy953mda JAQY953MDA,
             b.aomod      JAQY953MOD,
             B.AOTOPE     JAQY953TOP,
             a.jaqy953sta JAQY953STA,
             a.jaqy953atr JAQY953ATR,
             a.jaqy953cap JAQY953CAP,
             a.jaqy953int JAQY953INT,
             a.jaqy953mor JAQY953MOR,
             a.JAQY953OTR JAQY953OTR,
             --a.JAQY953SMN JAQY953SMN,
             e.scsdo      JAQY953SMN,
             d.pepais     JAQY953PAIS,
             d.pendoc     JAQY953NDOC,
             d.petdoc     JAQY953TDOC,
             a.JAQY953VIG JAQY953VIG,
             e.scrub      JAQY953RUB
      
      --->>>>>>JAQY953_TEMP - Tabla temporal                            
        FROM JAQY953_TEMP a, FSD010 b, fsr008 d, fsd011 e
       Where a.jaqy953cta = ln_cta
         and a.jaqy953ope = ln_oper
         and a.jaqy953mda = ln_mda
         and a.jaqy953mod = ln_mod
         and b.AOCTA = a.JAQY953CTA
         and b.AOOPER = a.JAQY953OPE
         and b.aomod = a.jaqy953mod
         and b.aomda = a.jaqy953mda
         and b.aosbop in (select max(h.aosbop)
                            from fsd010 h
                           where h.pgcod = b.pgcod
                             and h.aomod = b.aomod
                             and h.aomda = b.aomda
                             and h.aocta = b.aocta
                             and h.aooper = b.aooper)
         and b.aotope in (select max(h.aotope)
                            from fsd010 h
                           where h.pgcod = b.pgcod
                             and h.aomod = b.aomod
                             and h.aomda = b.aomda
                             and h.aocta = b.aocta
                             and h.aooper = b.aooper
                             and h.aosbop = b.aosbop)
         and d.ctnro = a.jaqy953cta
         and d.cttfir = 'T'
         and d.ttcod = 1
            -- and d.pendoc     = a.jaqy953ndoc;
         and e.sccta = a.jaqy953cta
         and e.scoper = a.jaqy953ope
         and e.scmod = a.jaqy953mod;
  
    --ln_sbop   number(3);
    --ln_tope   number(3);
    ln_cta    NUMBER(9);
    ln_mod    NUMBER(4);
    ln_mda    NUMBER(3);
    ln_oper   NUMBER(9);
    i         number := 1; ----- 
    --ln_NumCta number(3); -----
    ln_nro    number; --:=0;
    --ln_nvio   number; --:=0;
    ln_emp    number;
    ln_pap    number;
    lc_vig    char(1);
    lc_ob2    varchar2(50);
    lc_cod2   number := 2;
    lc_MiVivienda char(1):='N'; --mod@kdvc  2019.09.06    
  BEGIN
    ln_nro := pn_nvio;
    --For j in cur_inicio loop 
    For j in cur_inicio_2 loop
      ln_cta  := j.jaqy953cta; --aocta;
      ln_oper := j.jaqy953ope; --aooper;
      ln_mda  := j.jaqy953mda; --aomda;
      ln_mod  := j.jaqy953mod; --aomod;
    
      For i in cur_venta(ln_cta, ln_oper, ln_mda, ln_mod) loop
        ln_emp := 1;
        ln_pap := 0;
        lc_vig := 'S';
        pq_op_proceso_llenado.Sp_MiVivienda(ln_emp,i.JAQY953CTA,i.JAQY953OPE,i.JAQY953SUC ,ln_pap,i.JAQY953SBO ,i.JAQY953MDA ,i.JAQY953MOD,i.JAQY953TOP ,lc_MiVivienda);--mod@kdvc 2019.09.06
        If lc_MiVivienda = 'N' then --mod@kdvc 2019.09.06
         If i.JAQY953MOD <> 111 then --mod@kdvc 2019.09.06
           If (i.JAQY953CAP <> 0) or (i.JAQY953INT <> 0) or
            (i.JAQY953MOR <> 0) or (i.JAQY953SMN <> 0) then
           begin
            --insert into JAQY953_VC2 -----Tabla temporal
                  insert into JAQY953
                    ("JAQY952NRO",
                     "JAQY953EMP",
                     "JAQY953SUC",
                     "JAQY953CTA",
                     "JAQY953PAP",
                     "JAQY953OPE",
                     "JAQY953SBO",
                     "JAQY953MDA",
                     "JAQY953MOD",
                     "JAQY953TOP",
                     "JAQY953STA",
                     "JAQY953ATR",
                     "JAQY953CAP",
                     "JAQY953INT",
                     "JAQY953MOR",
                     "JAQY953OTR",
                     "JAQY953SMN",
                     "JAQY953PAIS",
                     "JAQY953NDOC",
                     "JAQY953TDOC",
                     "JAQY953VIG",
                     "JAQY953RUB")
                  values
                    (ln_nro,
                     ln_emp,
                     i.JAQY953SUC,
                     i.JAQY953CTA,
                     ln_pap,
                     i.JAQY953OPE,
                     i.JAQY953SBO,
                     i.JAQY953MDA,
                     i.JAQY953MOD,
                     i.JAQY953TOP,
                     i.JAQY953STA,
                     i.JAQY953ATR,
                     i.JAQY953CAP,
                     i.JAQY953INT,
                     i.JAQY953MOR,
                     i.JAQY953OTR,
                     i.JAQY953SMN,
                     i.JAQY953PAIS,
                     i.JAQY953NDOC,
                     i.JAQY953TDOC,
                     lc_vig,
                     i.jaqy953rub);
                exception
                  when others then
                    begin
                      lc_ob2 := 'Capital,interes,mora y saldo en cero';
                      insert into JAQY953_AUX --->>>Tabla auxiliar
                        ("JAQY953AUX_NVIO",
                         "JAQY953AUX_CTA",
                         "JAQY953AUX_OPE",
                         "JAQY953AUX_MDA",
                         "JAQY953AUX_MOD",
                         "JAQY953AUX_CAP",
                         "JAQY953AUX_INT",
                         "JAQY953AUX_MOR",
                         "JAQY953AUX_SMN",
                         "JAQY953AUX_DSC",
                         "JAQY953AUX_COD")
                      values
                        (ln_nro,
                         i.JAQY953CTA,
                         i.JAQY953OPE,
                         i.JAQY953MDA,
                         i.JAQY953MOD,
                         i.JAQY953CAP,
                         i.JAQY953INT,
                         i.JAQY953MOR,
                         i.JAQY953SMN,
                         lc_ob2,
                         lc_cod2);
                    exception
                      when others then
                        dbms_output.put_line(sqlerrm);
                    end;
                end;
           Else
             begin
                lc_ob2 := 'Capital,interes,mora y saldo en cero';
                insert into JAQY953_AUX --->>>Tabla auxiliar
                  ("JAQY953AUX_NVIO",
                   "JAQY953AUX_CTA",
                   "JAQY953AUX_OPE",
                   "JAQY953AUX_MDA",
                   "JAQY953AUX_MOD",
                   "JAQY953AUX_CAP",
                   "JAQY953AUX_INT",
                   "JAQY953AUX_MOR",
                   "JAQY953AUX_SMN",
                   "JAQY953AUX_DSC",
                   "JAQY953AUX_COD")
                values
                  (ln_nro,
                   i.JAQY953CTA,
                   i.JAQY953OPE,
                   i.JAQY953MDA,
                   i.JAQY953MOD,
                   i.JAQY953CAP,
                   i.JAQY953INT,
                   i.JAQY953MOR,
                   i.JAQY953SMN,
                   lc_ob2,
                   lc_cod2);
            End;
           End If;
          --mod@kdvc  2019.09.06
          else
                   begin
                       lc_ob2 := 'Credito MiVivienda';
                        insert into JAQY953_AUX --->>>Tabla auxiliar
                          ("JAQY953AUX_NVIO",
                           "JAQY953AUX_CTA" ,
                           "JAQY953AUX_OPE" ,
                           "JAQY953AUX_MDA" ,
                           "JAQY953AUX_MOD" ,
                           "JAQY953AUX_CAP" ,
                           "JAQY953AUX_INT" ,
                           "JAQY953AUX_MOR" ,
                           "JAQY953AUX_SMN" ,
                           "JAQY953AUX_DSC" ,
                           "JAQY953AUX_COD")
                        values
                          (ln_nro,
                           i.JAQY953CTA ,
                           i.JAQY953OPE ,
                           i.JAQY953MDA ,
                           i.JAQY953MOD ,
                           i.JAQY953CAP ,
                           i.JAQY953INT ,
                           i.JAQY953MOR ,
                           i.JAQY953SMN ,
                           lc_ob2,
                           lc_cod2);
                       End;
            End If;           
          else
             begin
             lc_ob2 := 'Credito Original MiVivienda';
              insert into JAQY953_AUX --->>>Tabla auxiliar
                ("JAQY953AUX_NVIO",
                 "JAQY953AUX_CTA" ,
                 "JAQY953AUX_OPE" ,
                 "JAQY953AUX_MDA" ,
                 "JAQY953AUX_MOD" ,
                 "JAQY953AUX_CAP" ,
                 "JAQY953AUX_INT" ,
                 "JAQY953AUX_MOR" ,
                 "JAQY953AUX_SMN" ,
                 "JAQY953AUX_DSC" ,
                 "JAQY953AUX_COD")
              values
                (ln_nro,
                 i.JAQY953CTA ,
                 i.JAQY953OPE ,
                 i.JAQY953MDA ,
                 i.JAQY953MOD ,
                 i.JAQY953CAP ,
                 i.JAQY953INT ,
                 i.JAQY953MOR ,
                 i.JAQY953SMN ,
                 lc_ob2,
                 lc_cod2);
             End;
          End If;
          --mod@kdvc  2019.09.06
      End loop;
      commit;
    End loop;  
    begin
      pq_op_proceso_llenado.sp_Inserta_Temporal;
    end;
  end sp_Inserta_Detalle;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Inserta_Temporal is
  
    cursor cur_temp is
      select jaqy953cta,
             jaqy953ope,
             JAQY953MDA,
             JAQY953MOD,
             JAQY953CAP,
             JAQY953INT,
             JAQY953MOR
        from JAQY953_TEMP
       where jaqy953mod <> 33 --->>>>>> Tabla temporal 
      minus
      select jaqy953cta,
             jaqy953ope,
             JAQY953MDA,
             JAQY953MOD,
             JAQY953CAP,
             JAQY953INT,
             JAQY953MOR
        from JAQY953
       where jaqy952nro in (select max(jaqy952nro) from JAQY953);
    --from JAQY953_VC2 where jaqy952nro in (select max(jaqy952nro) from JAQY953_VC2);
  
    lc_ob3  varchar2(50);
    ln_num3 number := 0;
    ln_cod3 number := 3;
  
  Begin
    Begin
      select max(jaqy952nro)
        into ln_num3
      -- from jaqy952_VC1;
        from jaqy952;
    End;
    lc_ob3 := 'Modulo 200 no encontrado en la fsd010';
    for k in cur_temp loop
      insert into JAQY953_AUX --->>>Tabla auxiliar
        ("JAQY953AUX_NVIO",
         "JAQY953AUX_CTA",
         "JAQY953AUX_OPE",
         "JAQY953AUX_MDA",
         "JAQY953AUX_MOD",
         "JAQY953AUX_CAP",
         "JAQY953AUX_INT",
         "JAQY953AUX_MOR",
         "JAQY953AUX_DSC",
         "JAQY953AUX_COD")
      values
        (ln_num3,
         k.JAQY953CTA,
         k.JAQY953OPE,
         k.JAQY953MDA,
         k.JAQY953MOD,
         k.JAQY953CAP,
         k.JAQY953INT,
         k.JAQY953MOR,
         lc_ob3,
         ln_cod3);
    end loop;
    commit;
    execute immediate ('truncate table JAQY953_TEMP'); --->>>>>> Tabla temporal
  end sp_Inserta_Temporal;
 --mod@kdvc  2019.09.06  
 Procedure Sp_MiVivienda(pn_emp in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_suc in number,
                         pn_pap in number,
                         pn_sbop in number,
                         pn_mda in number,
                         pn_mod in number,
                         pn_top in number,                         
                         pc_flg out char)is
 ln_mod number(3);
 Begin
       pc_flg := 'N';
       begin
              select r1mod
                into ln_mod 
              from fsr011 
              where 
                  R2COD = pn_emp
              and R2MOD = pn_mod
              and R2SUC = pn_suc
              and R2MDA  = pn_mda              
              and R2PAP  = pn_pap             
              and R2CTA  = pn_cta
              and R2OPER = pn_ope
              and R2SBOP = pn_sbop
              and R2TOPE = pn_top
              and relcod = 52
              and r011co = 'S'; 
       exception
          when others then null;
       end;       
       if ln_mod = 111 then
          pc_flg := 'S';
          else
              pc_flg := 'N';
       end if;
       
 end Sp_MiVivienda;
 --fin mod@kdvc  2019.09.06  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_OP_PROCESO_LLENADO;
/

