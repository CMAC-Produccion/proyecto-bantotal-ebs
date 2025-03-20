create or replace package PQ_OP_PAGOS_CREDITOS is

  -- *****************************************************************
  -- Nombre                     : ASIENTOS - MOVIMIENTOS FSD015 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2015.05.20
  -- Autor de Creación          : DCASTRO 
  -- Uso                        : GENERACION PAGOS PARA ALERTAS DE CREDITOS 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 24/11/2017
  -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
  -- Descripción de Modificación: Se cambió la concatenacion de mensajes.
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_Inserta_Pagos(pn_cor      in number, --numero correlativo
                             pn_pgcod    in number, --pgcod
                             pn_hcmod    in number, --hcmod
                             pn_hsucor   in number, --hsucor
                             pn_htran    in number, --htran
                             pn_hnrel    in number, --hnrel         
                             pd_fecpro   in date, -- fecha transaccion
                             pc_uing     in varchar2, --usuario ingreso
                             pc_hora     in varchar2, --hora
                             pn_ctnro    in number, --cuenta
                             pn_itoper   in number, --operacion
                             pn_modulo   in number, --modulo
                             pn_moneda   in number, --moneda
                             pn_itsubo   in number, --suboperacion                                                                                                            
                             pn_ittope   in number, --tipo operacion                           
                             pn_totpago  in number, --total pago
                             pn_mtogas   in number, --gasto
                             pn_mtocap   in number, --capital
                             pn_mtoint   in number, --interes
                             pn_mtomor   in number, --mora
                             pn_dias     in number, --dias atraso
                             pn_dias_act in number -- dias de traso despues del pago
                             );
  Procedure sp_Genera_Mensaje(pd_fecha    in date,
                              pc_hora_ini in varchar2,
                              pc_hora_fin in varchar2);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_OP_PAGOS_CREDITOS;
/

create or replace package body PQ_OP_PAGOS_CREDITOS is
  -- *****************************************************************
  -- Nombre                     : PQ_OP_PAGOS_CREDITOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.10.30
  -- Autor de Creación          : DCASTRO
  -- Uso                        : CARGA DATOS OPERACIONES CREDITOS - JAQL989-JAQL980A-JAQL980-FSD016
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2015.05.20
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: 
  -- Fecha de Modificación      : 24/11/2017
  -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
  -- Descripción de Modificación: Se cambió la concatenacion de mensajes.
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_Inserta_Pagos(pn_cor      in number, --numero correlativo
                             pn_pgcod    in number, --pgcod
                             pn_hcmod    in number, --hcmod
                             pn_hsucor   in number, --hsucor
                             pn_htran    in number, --htran
                             pn_hnrel    in number, --hnrel         
                             pd_fecpro   in date, -- fecha transaccion
                             pc_uing     in varchar2, --usuario ingreso
                             pc_hora     in varchar2, --hora
                             pn_ctnro    in number, --cuenta
                             pn_itoper   in number, --operacion
                             pn_modulo   in number, --modulo
                             pn_moneda   in number, --moneda
                             pn_itsubo   in number, --suboperacion                                                                                                            
                             pn_ittope   in number, --tipo operacion                           
                             pn_totpago  in number, --total pago
                             pn_mtogas   in number, --gasto
                             pn_mtocap   in number, --capital
                             pn_mtoint   in number, --interes
                             pn_mtomor   in number, --mora
                             pn_dias     in number, --dias atraso
                             pn_dias_act in number --dias de traso despues del pago
                             ) is
  
    lc_titular varchar2(30);
    lc_numdoc  varchar2(12);
    ln_saldo   number;
    ln_mtodeu  number;
    lc_usuario varchar2(10);
    lc_asesor  varchar2(30);
    lc_agencia varchar2(30);
    lc_pais    jaql964.jaql964pai%type;
    lc_tipdoc  jaql964.jaql964tid%type;
    ln_dif     number;
  
  begin
  
    begin
      select jaql964pai,
             jaql964tid,
             jaql964usu,
             jaql964doc,
             jaql964sao,
             jaql964mtd,
             jaql964nom
        into lc_pais,
             lc_tipdoc,
             lc_usuario,
             lc_numdoc,
             ln_saldo,
             ln_mtodeu,
             lc_Agencia
        from jaql964 j
       where j.jaql964cta = pn_ctnro
         and j.jaql964ope = pn_itoper
         and j.jaql964mod = pn_modulo
         and j.jaql964mda = pn_moneda
         and j.jaql964sob = pn_itsubo
         and j.jaql964top = pn_ittope;
    exception
      when others then
        lc_pais    := null;
        lc_tipdoc  := null;
        lc_usuario := null;
        lc_numdoc  := null;
        ln_saldo   := null;
        ln_mtodeu  := null;
        lc_Agencia := null;
    end;
    --nombre cliente
    begin
      select trim(pfnom1) || ',' || trim(pfape1)
        into lc_titular
        from fsd002
       where pfpais = lc_pais
         and pftdoc = lc_tipdoc
         and pfndoc = lc_numdoc;
    exception
      when no_Data_found then
        begin
          select trim(pjrazs)
            into lc_titular
            from fsd003
           where pjpais = lc_pais
             and pjtdoc = lc_tipdoc
             and pjndoc = lc_numdoc;
        exception
          when no_Data_found then
            lc_titular := null;
        end;
    end;
  
    --nombre analista         
    begin
      select ubnom
        into lc_asesor
        from fst746
       where ubuser = rpad(lc_usuario, 10, ' ');
    exception
      when others then
        lc_asesor := null;
    end;
  
    --ln_dif := pn_dias;
  
    lc_asesor := substr(lc_asesor, 1, 40);
  
    insert into JAQL989
      (jaql989cor,
       jaql989fec,
       jaql989hor,
       jaql989usu,
       jaql989ase,
       jaql989doc,
       jaql989cta,
       jaql989mod,
       jaql989mda,
       jaql989ope,
       jaql989dia,
       jaql989sao,
       jaql989tit,
       jaql989mtd,
       jaql989gas,
       jaql989mor,
       jaql989int,
       jaql989cuo,
       jaql989pag,
       jaql989age,
       JAQL989DIF)
    values
      (pn_cor,
       pd_fecpro,
       pc_hora,
       lc_usuario,
       lc_asesor,
       lc_numdoc,
       pn_ctnro,
       pn_modulo,
       pn_moneda,
       pn_itoper,
       pn_dias,
       ln_saldo,
       lc_titular,
       ln_mtodeu,
       pn_mtogas,
       pn_mtomor,
       pn_mtoint,
       pn_mtocap,
       pn_totpago,
       lc_Agencia,
       pn_dias_act);
    begin
      insert into jaqy595
        (jaqy595corr,
         jaqy595pcod,
         jaqy595hmod,
         jaqy595hsuc,
         jaqy595htra,
         jaqy595hrel,
         jaqy595hfec)
      values
        (pn_cor,
         pn_pgcod,
         pn_hcmod,
         pn_hsucor,
         pn_htran,
         pn_hnrel,
         pd_fecpro);
    exception
      when others then
        null;
    end;
  
  end sp_Inserta_Pagos;

  --*****************************20052015 parte II  
  ------------------------------------------------
  Procedure sp_Genera_Mensaje(pd_fecha    in date,
                              pc_hora_ini in varchar2,
                              pc_hora_fin in varchar2) is
  
    --chernandez 24/11/2017
    Cursor usuario3 is
      Select *
        from jaql989
       where jaql989fec = pd_fecha
         and jaql989hor >= pc_hora_ini
         and jaql989hor <= pc_hora_fin;
  
    Cursor transaccion(cta numeric, oper numeric, modu numeric, mone numeric, fecha date, corr numeric) is
      select pp1stat, count(*) cant
        from fsd602 c, jaqy595 d
       where pgcod = 1
         and ppmod = modu
         and ppmda = mone
         and pppap = 0
         and ppcta = cta
         and ppoper = oper
         and pp1fech = fecha
         and c.d602cd = d.jaqy595pcod
         and c.d602mo = d.jaqy595hmod
         and c.d602su = d.jaqy595hsuc
         and c.d602tr = d.jaqy595htra
         and c.d602re = d.jaqy595hrel
         and c.d602fc = d.jaqy595hfec
         and d.jaqy595corr = corr
       group by pp1stat;
  
    lc_usuario1 varchar2(10);
    lc_titular  varchar2(40); /*(20)*/
    ln_longitud number := 0;
  
    ld_fec  date;
    lc_hor  VARCHAR2(10);
    lc_usu  VARCHAR2(10);
    lc_ase  VARCHAR2(50);
    lc_doc  CHAR(12);
    ln_cta  NUMBER(9);
    ln_mod  NUMBER(4);
    ln_mda  NUMBER(3);
    ln_ope  NUMBER(9);
    ln_dia  NUMBER(9);
    ln_sao  NUMBER(16, 2);
    ln_sao1 NUMBER(16, 2); ---
    lc_tit  VARCHAR2(30);
    ln_mtd  NUMBER(16, 2);
    ln_gas  NUMBER(16, 2);
    ln_mor  NUMBER(16, 2);
    ln_int  NUMBER(16, 2);
    ln_cuo  NUMBER(16, 2);
    ln_pag  NUMBER(16, 2);
    lc_age  VARCHAR2(50);
    -----------
    lc_parrafo    varchar2(17); --20
    lc_msn_1      varchar2(68); /*(48);*/ --(160);-- ******
    lc_msn_2      varchar2(160); --(160); --126 ---20052015 ******
    lc_msn_3      varchar2(160); --(160); --126 ---20052015 *****
    lc_msn_4      varchar2(160); --(160); --126 ---20052015 *****
    lc_msn_5      varchar2(160); --(160); --126 ---20052015 *****
    lc_msj        varchar2(160); --(160); --126 --varchar2(160); *******
    ln_cont       number := 0;
    ln_num        number := 0;
    ln_total_long number := 0;
    Flg_Msn       varchar2(1);
    ln_dias       NUMBER(16, 2);
    lc_pago1      varchar2(160);
    ln_long_msn_3 number := 0;
    ln_tot_msn_3  number := 0;
    ln_cad_3      number := 0;
    ln_canTot     number := 0;
    ln_canPar     number := 0;
  
  Begin
    If (to_char(trunc(sysdate, 'HH24'), 'HH24') between '08' and '21') then
      --a partir de 8am
    
      --For a in usuario3 loop
      For i in usuario3 loop
        lc_usuario1 := i.jaql989usu;
      
        ln_longitud   := 0;
        lc_msn_1      := null;
        lc_msn_2      := null;
        lc_msn_3      := null;
        lc_msn_4      := null;
        lc_msn_5      := null;
        lc_msj        := null;
        ln_total_long := 0;
        ln_num        := 1;
        Flg_Msn       := 'N';
      
        lc_titular := trim(i.jaql989tit);
      
        ld_fec := i.jaql989fec;
        lc_hor := i.jaql989hor;
        lc_usu := i.jaql989usu;
        lc_ase := i.jaql989ase;
        lc_doc := i.jaql989doc;
        ln_cta := i.jaql989cta;
        ln_mod := i.jaql989mod;
        ln_mda := i.jaql989mda;
        ln_ope := i.jaql989ope;
        ln_dia := i.jaql989dia;
        --ln_sao := (i.jaql989sao)*-1; 
        ln_sao1 := i.jaql989sao;
        lc_tit  := i.jaql989tit;
        ln_mtd  := i.jaql989mtd;
        ln_gas  := i.jaql989gas;
        ln_mor  := i.jaql989mor;
        ln_int  := i.jaql989int;
        ln_cuo  := i.jaql989cuo;
        ln_pag  := i.jaql989pag;
        lc_age  := trim(i.jaql989age);
        ln_dias := i.JAQL989DIF;
      
        If Substr(ln_sao1, 1, 1) = '-' then
          ln_sao := ln_sao1 * -1;
        Else
          ln_sao := ln_sao1;
        End If;
      
        lc_parrafo := 'El cliente '; --'Pago Cred. Mora: ';
        ln_canTot  := 0;
        ln_canPar  := 0;
        ln_cont    := 0;
        For n in transaccion(i.jaql989cta,
                             i.jaql989ope,
                             i.jaql989mod,
                             i.jaql989mda,
                             i.jaql989fec,
                             i.jaql989cor) loop
          ln_cont := ln_cont + 1;
          if n.pp1stat = 'T' then
            ln_canTot := n.cant;
          else
            ln_canPar := n.cant;
          End if;
        end loop;
      
        if ln_cont = 1 then
          if ln_canTot <> 0 then
            lc_pago1 := ' realizó ' || ln_canTot ||
                        ' Pago Total de su cuota(s) en Mora. Queda con ' ||
                        ln_dias || ' días de atraso.';
          else
            lc_pago1 := ' realizó Pago Parcial de su cuota en Mora. Queda con ' ||
                        ln_dias || ' días de atraso.';
          end if;
        else
          lc_pago1 := ' realizó ' || ln_canTot ||
                      ' Pago Total de su cuota(s) en Mora y ' || ln_canPar ||
                      ' Pago Parcial. Queda con ' || ln_dias ||
                      ' días de atraso.';
        end if;
      
        lc_msj := lc_age||'- '|| lc_parrafo || lc_titular || lc_pago1;
      
        begin
          insert into JAQY770
            (jaqy770cor,
             jaqy770fec,
             jaqy770hor,
             jaqy770usu,
             jaqy770ase,
             jaqy770doc,
             jaqy770cta,
             jaqy770mod,
             jaqy770mda,
             jaqy770ope,
             jaqy770dia,
             jaqy770sao,
             jaqy770tit,
             jaqy770mtd,
             jaqy770gas,
             jaqy770mor,
             jaqy770int,
             jaqy770cuo,
             jaqy770pag,
             jaqy770age,
             jaqy770msg)
          values
            (SQ_AH_JAQY770.nextval,
             ld_fec,
             lc_hor,
             lc_usu,
             lc_ase,
             lc_doc,
             ln_cta,
             ln_mod,
             ln_mda,
             ln_ope,
             ln_dia,
             ln_sao,
             lc_tit,
             ln_mtd,
             ln_gas,
             ln_mor,
             ln_int,
             ln_cuo,
             ln_pag,
             lc_age,
             lc_msj);
        exception
          when others then
            null;
        end;
      
        commit;
        lc_msj := null;
      End loop;
    End If;
  exception
    when others then
      Begin
        insert into JAQY770_AUX --->>>Tabla auxiliar
          (jaqy770cor,
           jaqy770fec,
           jaqy770hor,
           jaqy770usu,
           jaqy770ase,
           jaqy770doc,
           jaqy770cta,
           jaqy770mod,
           jaqy770mda,
           jaqy770ope,
           jaqy770dia,
           jaqy770sao,
           jaqy770tit,
           jaqy770mtd,
           jaqy770gas,
           jaqy770mor,
           jaqy770int,
           jaqy770cuo,
           jaqy770pag,
           jaqy770age,
           jaqy770msg, ---
           jaqy770usu1,
           jaqy770tit1,
           jaqy770tlon,
           jaqy770long,
           jaqy770msn1,
           jaqy770msn2,
           jaqy770msn3,
           jaqy770cont,
           jaqy770tmsn3,
           jaqy770cad3,
           jaqy770msn4,
           jaqy770msn5,
           jaqy770lmsn3)
        values
          (SQ_AH_JAQY770_AUX.nextval,
           ld_fec,
           lc_hor,
           lc_usu,
           lc_ase,
           lc_doc,
           ln_cta,
           ln_mod,
           ln_mda,
           ln_ope,
           ln_dia,
           ln_sao,
           lc_tit,
           ln_mtd,
           ln_gas,
           ln_mor,
           ln_int,
           ln_cuo,
           ln_pag,
           lc_age,
           lc_msj, ----
           lc_usuario1,
           lc_titular,
           ln_total_long,
           ln_longitud,
           lc_msn_1,
           lc_msn_2,
           lc_msn_3,
           ln_cont,
           ln_tot_msn_3,
           ln_cad_3,
           lc_msn_4,
           lc_msn_5,
           ln_long_msn_3);
        commit;
      end;
  end sp_Genera_Mensaje;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end PQ_OP_PAGOS_CREDITOS;
/

