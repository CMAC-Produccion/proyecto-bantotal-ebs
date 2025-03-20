create or replace package pq_categoria_provision
is
  procedure sp_crea_base(PD_FECHA in date);
  Procedure sp_ingreso_diferido;
  Procedure sp_estado_diasatr(PD_FECHA in date);
  Procedure sp_catprv_bantotal(PD_FECHA in date);
  Procedure sp_categoria_atraso(PD_FECHA in date);
  Procedure sp_unifica_categoria (PN_3UIT in number);
  Procedure sp_alineamiento(PD_FECRCC in date);
  Procedure sp_categoria_manual(PD_FECHA in date);
  Procedure sp_categoria_def_per;
  Procedure sp_provision_gen_esp(PD_FECHA in date,PV_PROCICLICA in varchar2,PV_SOBREENDEU in varchar2);
  Procedure sp_linea_no_utilizada(PD_FECHA in date);
  Function fn_porcentaje_provision(PN_CATEGO in number,
                                   PN_TIPCRE in number)  Return Number;

end pq_categoria_provision;
/

create or replace package body pq_categoria_provision
is
  procedure sp_crea_base(PD_FECHA in date)
  is
    lv_scrip varchar2(2000);
    ln_exist number(2);
    lv_fecha varchar2(10):= to_char(PD_FECHA,'rrrrmmdd');
  begin
       select count(*) into ln_exist from user_tables where table_name = 'CATDEU';
       If ln_exist > 0 Then
          lv_scrip := 'Drop table CATDEU purge';
          execute immediate lv_scrip;
       End If;

       lv_scrip := 'Create table catdeu tablespace bantprod_b as '||
                   'Select h12.bcfech,r08.pepais,r08.petdoc,r08.pendoc,d01.petipo,d01.penom,h12.bccate,'||
                   'h12.bcemp,h12.bcsuc,h12.bcmda,h12.bcpap,h12.bcmod,h12.bccta,h12.bcoper,h12.bcsbop,h12.bctop,'||
                   'h12.bcfval,h12.bcfvto,-sum(h12.bcsdmn) SaldoMN,-sum(bcsdmo) Saldo,'||
                   'case when substr(bcrubr,1,2) in (''71'',''72'') then to_number(substr(bcrubr,7,2)) else h12.bcgpo end bcgpo,'||
                   'min(bcrubr) rubro, max(bcprod) bcprod '||
                   'From fsh012 h12 left join fsr008 r08 on r08.ctnro = h12.bccta '||
                   'and r08.ttcod = 1 '||
                   'and r08.cttfir = ''T'' '||
                   'left join fsd001 d01 on d01.pepais = r08.pepais '||
                   'and d01.petdoc = r08.petdoc '||
                   'and d01.pendoc = r08.pendoc '||
                   'Where bcemp = 1 and bcfech=to_date('''||lv_fecha||''',''rrrrmmdd'') '||
                   'and (substr(bcrubr,1,4) in (1411,1414,1415,1416,1421,1424,1425,1426,7112,7122) '||
                       'or bcmod in (117,33)) '||
                   'and bccta <> 999999999 '||
                   'and bcprod <> 99 '||
                   'Group By h12.bcfech,r08.pepais,r08.petdoc,r08.pendoc,d01.petipo,d01.penom, h12.bccate, '||
                   'h12.bcemp,h12.bcsuc,h12.bcmda,h12.bcpap,h12.bcmod,h12.bccta,h12.bcoper,h12.bcsbop,h12.bctop,'||
                   'h12.bcfval,h12.bcfvto,case when substr(bcrubr,1,2) in (''71'',''72'') then to_number(substr(bcrubr,7,2)) else h12.bcgpo end';
       --dbms_output.put_line(lv_scrip);
       execute immediate lv_scrip;

       lv_scrip := 'alter table catdeu add estcre varchar2(3)';
       execute immediate lv_scrip;
       lv_scrip := 'alter table catdeu add diaatr number(5)';
       execute immediate lv_scrip;
       lv_scrip := 'create index ix_catde_1 on catdeu(bcfech, bcemp,bcsuc,bcmda,bcpap,bcmod,bccta,bcoper,bcsbop,bctop) tablespace bantprod_b_idx';
       execute immediate lv_scrip;
  end sp_crea_base;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_estado_diasatr(PD_FECHA in date)
  Is
    lv_scrip varchar2(200);
    TYPE tp_credit IS REF CURSOR;
    c_credit tp_credit;

    ld_bcfech date;
    ln_bcemp number(3);
    ln_bcsuc number(3);
    ln_bcmda number(4);
    ln_bcpap number(3);
    ln_bcmod number(3);
    ln_bccta number(9);
    ln_bcoper number(9);
    ln_bcsbop number(3);
    ln_bctop number(3);
    ln_rubro number(16);
    ln_bcprod number(5);
    ld_fecven date;

    lv_estcre varchar2(3);
    ln_diaatr number(5);
  Begin
    lv_scrip := 'select bcfech, bcemp,bcsuc,bcmda,bcpap,bcmod,bccta,bcoper,bcsbop,bctop,rubro,bcprod,bcfvto '||
                'from catdeu where bcfech = :f';
    OPEN c_credit FOR lv_scrip USING PD_FECHA;
    LOOP
        FETCH c_credit
        /*BULK COLLECT*/ INTO ld_bcfech,ln_bcemp,ln_bcsuc,ln_bcmda,ln_bcpap,ln_bcmod,ln_bccta,
                          ln_bcoper,ln_bcsbop,ln_bctop,ln_rubro,ln_bcprod,ld_fecven;-- LIMIT 10000;
        EXIT WHEN c_credit%NOTFOUND;

        Case When substr(ln_rubro,1,4) in (1411,1421,7112,7122) Then
             lv_estcre := 'VIG';
             When substr(ln_rubro,1,4) in (1416,1426) Then
             lv_estcre := 'JUD';
             When ln_bcmod = 117 Then
             lv_estcre := 'LIN';
             When substr(ln_rubro,1,2) = 81 Then
             lv_estcre := 'CAS';
             When substr(ln_rubro,1,4) in (1414,1424) and ln_bcprod = 33 Then
             lv_estcre := 'TRA';
             When substr(ln_rubro,1,4) in (1414,1424) and ln_bcprod <> 33 Then
             lv_estcre := 'REF';
             When substr(ln_rubro,1,4) in (1415,1425) and substr(ln_rubro,7,2) = 19 and ln_bcprod = 33 Then
             lv_estcre := 'TVE';
             When substr(ln_rubro,1,4) in (1415,1425) and substr(ln_rubro,7,2) = 19 and ln_bcprod <> 33 Then
             lv_estcre := 'RVE';
             When substr(ln_rubro,1,4) in (1415,1425) and substr(ln_rubro,7,2) <> 19 Then
             lv_estcre := 'VEN';
             
        End Case;

        If ln_bcmod = 141 Then
           ln_diaatr := PD_FECHA -ld_fecven;
           if ln_diaatr < 0 Then ln_diaatr:=0; end If;
        Elsif ln_bcmod <> 117 Then
            Begin
                Select jaql114datr
                  Into ln_diaatr
                  From jaql114 c
                 Where c.jaql114fech= ld_bcfech
                   and c.jaql114emp = ln_bcemp
                   and c.jaql114mod = ln_bcmod
                   and c.jaql114suc = ln_bcsuc
                   and c.jaql114mda = ln_bcmda
                   and c.jaql114pap = ln_bcpap
                   and c.jaql114cta = ln_bccta
                   and c.jaql114oper= ln_bcoper
                   and c.jaql114sbop= ln_bcsbop
                   and c.jaql114top = ln_bctop;
            Exception
              When too_many_rows Then
                Select jaql114datr
                  Into ln_diaatr
                  From jaql114 c
                 Where c.jaql114fech= ld_bcfech
                   and c.jaql114emp = ln_bcemp
                   and c.jaql114mod = ln_bcmod
                   and c.jaql114suc = ln_bcsuc
                   and c.jaql114mda = ln_bcmda
                   and c.jaql114pap = ln_bcpap
                   and c.jaql114cta = ln_bccta
                   and c.jaql114oper= ln_bcoper
                   and c.jaql114sbop= ln_bcsbop
                   and c.jaql114top = ln_bctop
                   and rownum=1;
              When Others Then
                ln_diaatr := null;
            End;
        End If;

        lv_scrip := 'Update catdeu Set estcre=:1, diaatr=:2 '||
                    'Where bcfech=:3 and bcemp=:4 and bcsuc=:5 and bcmda=:6 and bcpap=:7 and bcmod=:8 '||
                    'and bccta=:9 and bcoper=:10 and bcsbop=:11 and bctop=:12';
        execute immediate lv_scrip using lv_estcre,ln_diaatr,ld_bcfech,ln_bcemp,ln_bcsuc,ln_bcmda,ln_bcpap,ln_bcmod,
                                         ln_bccta,ln_bcoper,ln_bcsbop,ln_bctop;
        commit;
    END LOOP;
    CLOSE c_credit;
  End sp_estado_diasatr;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_categoria_atraso(PD_FECHA in date)
  Is
    lv_scrip varchar2(1000);
    ln_exist number(2);

    Type tp_credit IS REF CURSOR;
    c_credit tp_credit;

    ld_bcfech date;
    ln_bcemp number(3);
    ln_bcsuc number(3);
    ln_bcmda number(4);
    ln_bcpap number(3);
    ln_bcmod number(3);
    ln_bccta number(9);
    ln_bcoper number(9);
    ln_bcsbop number(3);
    ln_bctop number(3);
    ln_bcgpo number(5);
    lv_estcre varchar2(3);
    ln_diaatr number(5);
    ln_catdeu number(1);
    --ln_cattmp number(1);
    ln_modcre number(1);

    ln_dias number(5);
    ld_fecori date;
    ld_fecval date;
    --ln_diaref number(5);
    --ld_fecdes date;
    ln_nromes number(2);
    ld_fecmes date;
    lv_cuopag varchar2(1);
    -- Cursoe de Refinanciados
    Cursor c_atrref (pn_bcemp in number,pn_bcmod in number,pn_bcmda in number, pn_bcpap in number,
                     pn_bccta in number,pn_bcoper in number, pn_bcsbop in number, pn_bctop in number,
                     pf_fecha in date)
        Is Select nvl(d602.pp1fech,PD_FECHA) - d601.ppfpag AtrPag,d601.ppfpag,
                  trim(nvl(d602.pp1stat,'N')) pp1stat
           From fsd601 d601
                   Left Join fsd602 d602 on d602.pgcod = d601.pgcod
                                        and d602.ppmod = d601.ppmod
                                        and d602.ppsuc = d601.ppsuc
                                        and d602.ppmda = d601.ppmda
                                        and d602.pppap = d601.pppap
                                        and d602.ppcta = d601.ppcta
                                        and d602.ppoper= d601.ppoper
                                        and d602.ppsbop= d601.ppsbop
                                        and d602.pptope= d601.pptope
                                        and d602.ppfpag= d601.ppfpag
                                        and d602.pp1stat= 'T'
                                        and d602.d602co= 'S'
                                        and d602.pp1fech <= pf_fecha
                   Where d601.pgcod = pn_bcemp
                       and d601.ppmod = pn_bcmod
                       and d601.ppmda = pn_bcmda
                       and d601.pppap = pn_bcpap
                       and d601.ppcta = pn_bccta
                       and d601.ppoper= pn_bcoper
                       and d601.ppsbop= pn_bcsbop
                       and d601.pptope= pn_bctop
                       and d601.d601co = 'S'
                       and d601.ppcap > 0
                       and d601.ppfpag <= pf_fecha
                       Order by d601.ppfpag;
  Begin

    select count(*) into ln_exist from user_tab_columns where table_name = 'CATDEU' and column_name = 'MODCRE';
    If ln_exist <= 0 then
       lv_scrip := 'Alter table catdeu add modcre number(1)';
       execute immediate lv_scrip;
    End If;

    select count(*) into ln_exist from user_tab_columns where table_name = 'CATDEU' and column_name = 'CATATR';
    If ln_exist <= 0 then
       lv_scrip := 'Alter table catdeu add catatr number(1)';
       execute immediate lv_scrip;
    End If;

    select count(*) into ln_exist from user_tab_columns where table_name = 'CATDEU' and column_name = 'FECORI';
    If ln_exist <= 0 then
       lv_scrip := 'Alter table catdeu add fecori date';
       execute immediate lv_scrip;
    End If;

    select count(*) into ln_exist from user_tab_columns where table_name = 'CATDEU' and column_name = 'REFATR';
    If ln_exist <= 0 then
       lv_scrip := 'Alter table catdeu add refatr number(5)';
       execute immediate lv_scrip;
    End If;

    lv_scrip := 'Select bcfech, bcemp,bcsuc,bcmda,bcpap,bcmod,bccta,bcoper,bcsbop,bctop,bcgpo,estcre,diaatr,bcfval '||
                'From catdeu where bcfech = :f and bcfval <> to_date(''01/01/0001'',''dd/mm/rrrr'') '||
                'and estcre not in (''LIN'') and saldomn <> 0';-- and bccta=22141';-- and bccta in (2329,1297,990)';
                --/*bcfech = :f and*/
    OPEN c_credit FOR lv_scrip USING PD_FECHA;
    LOOP
        FETCH c_credit
        /*BULK COLLECT*/ INTO ld_bcfech,ln_bcemp,ln_bcsuc,ln_bcmda,ln_bcpap,ln_bcmod,ln_bccta,
                              ln_bcoper,ln_bcsbop,ln_bctop,ln_bcgpo,lv_estcre,ln_dias,ld_fecval;-- LIMIT 10000;
        EXIT WHEN c_credit%NOTFOUND;

        ln_diaatr := ln_dias;
        ld_fecori := null;
        ln_catdeu := null;
        If lv_estcre = 'CAS' Then
           ln_catdeu := 4;
        
        ElsIf lv_estcre in ('REF','TRA','RVE','TVE') Then--and ld_fecval < to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd') Then
            
                 
                    
              
              If ld_fecval < to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd') Then
                
              
                --DBMS_output.put_line('Ref.Meses Anteriores:Cta:'||ln_bccta);
                ---- Categoria de la fecha de refinanciación.
                Begin
                   Select to_number(substr(d.catcateg,1,1)) Into ln_catdeu
                     From fsd212 d
                    Where d.pgcod = ln_bcemp
                      and d.catcta= ln_bccta
                      and d.catcod= 4
                      and d.catfchdes = last_day(add_months(ld_fecval,-1));
                Exception When Others Then
                       ln_catdeu := null;
                End ; 
                If ln_catdeu = 0 Then ln_catdeu:=1; End If;
                
                -- Revisa si existen meses de gracia
                Begin
                    Select max(d601.ppfpag)
                      Into ld_fecmes
                      From fsd601 d601
                     Where d601.pgcod = ln_bcemp
                       and d601.ppmod = ln_bcmod
                       and d601.ppmda = ln_bcmda
                       and d601.pppap = ln_bcpap
                       and d601.ppcta = ln_bccta
                       and d601.ppoper= ln_bcoper
                       and d601.ppsbop= ln_bcsbop
                       and d601.pptope= ln_bctop
                       and d601.ppcap < 0
                       and d601.d601co = 'S';
                Exception When Others Then
                     ld_fecmes := last_day(ld_fecval);
                End;
                IF ld_fecmes is null then ld_fecmes := last_day(ld_fecval); End If;
                
                ln_nromes := 0;
                --DBMS_output.put_line('Ini--> Mes:'||ln_nromes||'  CatDeu:'||ln_catdeu||
                --                     '  FecMes:'||to_char(ld_fecmes,'rrrr.mm.dd'));
                --DBMS_output.put_line('----------');                      
                --- Recorre calendario de pagos hasta fecha de proceso   
                For c in c_atrref(ln_bcemp,ln_bcmod,ln_bcmda,ln_bcpap,ln_bccta,ln_bcoper,ln_bcsbop,ln_bctop,PD_FECHA) Loop
                    ld_fecmes := last_day(add_months(ld_fecmes,1));
                    lv_cuopag := c.pp1stat;
                    If c.ppfpag > ld_fecmes Then
                      --DBMS_output.put_line('Cuota > FecMes:'||to_char(c.ppfpag,'rrrr.mm.dd')
                      --                     ||'---'||to_char(ld_fecmes,'rrrr.mm.dd')); 
                       While ld_fecmes < c.ppfpag Loop
                       Exit When ld_fecmes >= c.ppfpag; 
                            ln_nromes:= ln_nromes +1;
                            --DBMS_output.put_line('NroMes:'||ln_nromes); 
                            --DBMS_output.put_line('Cuota:'||to_char(c.ppfpag,'rrrr.mm.dd')
                            --                     ||'  FecMes:'||to_char(ld_fecmes,'rrrr.mm.dd')); 
                             If ln_nromes = 6 Then
                                ln_nromes := 0;
                                If ln_catdeu > 0 Then
                                   ln_catdeu := ln_catdeu -1;
                                End If;
                             End If;  
                             ld_fecmes := last_day(add_months(ld_fecmes,1)); 
                       End Loop; 
                       --DBMS_output.put_line('Sale Loop: Cuota:'||to_char(c.ppfpag,'rrrr.mm.dd')
                       --                          ||'  FecMes:'||to_char(ld_fecmes,'rrrr.mm.dd')); 
                            
                    End If;  
                    --DBMS_output.put_line('Fecha No Mayor');
                    If c.ppfpag >= to_date(to_char(ld_fecmes,'rrrrmm')||'01','rrrrmmdd') and
                       c.ppfpag <= ld_fecmes Then 
                      --DBMS_output.put_line('En Fecha');
                      --DBMS_output.put_line('Cuota <= FecMes'||to_char(c.ppfpag,'rrrr.mm.dd')
                      --                     ||'---'||to_char(ld_fecmes,'rrrr.mm.dd')); 
                      --DBMS_output.put_line('DiaAtr:'||c.atrpag); 
                       If c.atrpag <= 8 Then
                          ln_nromes := ln_nromes + 1;
                       Else
                          ln_nromes := 0;
                          If ln_catdeu < 4 Then
                             ln_catdeu := ln_catdeu + 1;
                         End If;
                      End If;
                      If ln_nromes = 6 Then
                         ln_nromes := 0;
                         If ln_catdeu > 0 Then
                            ln_catdeu := ln_catdeu -1;
                         End If;
                      End If;  
                    Else 
                        --DBMS_output.put_line('Fuera Fecha');
                        ld_fecmes := c.ppfpag;
                        If c.atrpag > 8 Then
                           If ln_catdeu < 4 Then
                             ln_catdeu := ln_catdeu + 1;
                           End If;
                        End If;  
                    End If;   
                    --DBMS_output.put_line('CatDeu:'||ln_catdeu);               
                End Loop;  
                
                If ld_fecmes < PD_FECHA Then
                   
                   
                   --While ld_fecmes <= PD_FECHA 
                   Loop
                   Exit When ld_fecmes >= PD_FECHA; 
                     ld_fecmes := last_day(add_months(ld_fecmes,1));
                     ln_nromes := ln_nromes + 1;
                     
                       If ln_diaatr > 8 and lv_cuopag <> 'T' Then
                          ln_nromes := 0;
                          If ln_catdeu < 4 Then
                             ln_catdeu := ln_catdeu + 1;
                          End If;
                       ElsIf (ln_diaatr > 8 and lv_cuopag = 'T') or (ln_diaatr <= 8) Then 
                             ln_diaatr := 0;
                       End IF;
                             
                       IF ln_nromes = 6 Then
                          ln_nromes := 0;
                          If ln_catdeu > 0 Then
                            ln_catdeu := ln_catdeu -1;
                         End If;
                       End If;   
                       --DBMS_output.put_line('NroMes:'||ln_nromes); 
                       --DBMS_output.put_line('FecMes:'||to_char(ld_fecmes,'rrrr.mm.dd')); 
                       --DBMS_output.put_line('DiaAtr:'||ln_diaatr);      
                   End Loop; 
                   --DBMS_output.put_line('CatDeu:'||ln_catdeu);  
                End If;  
              Else   
                 -- Relacion de Refinanciado y categoría del mes anterior
                    -- Categoría del mes Anterior
                 Begin
                 Select to_number(substr(d.catcateg,1,1)) Into ln_catdeu
                   From fsd212 d
                  Where d.pgcod = ln_bcemp
                    and d.catcta= ln_bccta
                    and d.catcod= 4
                    and d.catfchdes = last_day(add_months(PD_FECHA,-1));
                 Exception When Others Then
                     ln_catdeu := null;
                 End ;
                 If ln_catdeu = 0 Then
                    ln_catdeu := 1;
                 End If;
                 --dbms_output.put_line('Categ.(desem):'||ln_catdeu);
              End If;
              
        /*ElsIf lv_estcre in ('TRA','TVE') and ld_fecval >= to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd') Then
              -- Buscar la última fecha de envío de judicial
              Begin
                  Select d10.aofvto
                    Into ld_fecori
                    From fsd010 d10
                   Where d10.pgcod = ln_bcemp
                     and d10.aomod = 200
                     and d10.aomda = ln_bcmda
                     and d10.aopap = ln_bcpap
                     and d10.aocta = ln_bccta
                     and d10.aooper= ln_bcoper
                     and d10.aosbop= ln_bcsbop - 1
                     and d10.aotope= 1;

              ln_diaatr := ld_fecval-ld_fecori;

              Exception When Others Then
                 ld_fecori := null;
                 ln_diaatr := ln_dias;
              End;*/

        End If;

        --dbms_output.put_line(to_char(ln_bcgpo)||'---'||to_char(ln_diaatr));
        If ln_catdeu is null then
            If ln_bcgpo = 4 Then --Hipotecario
                  Case
                      When ln_diaatr <= 30 Then ln_catdeu := 0;
                      When ln_diaatr <= 60 Then ln_catdeu := 1;
                      When ln_diaatr <= 120 Then ln_catdeu := 2;
                      When ln_diaatr <= 365 Then ln_catdeu := 3;
                      When ln_diaatr > 365 Then ln_catdeu := 4;
                  End Case;
            ElsIf ln_bcgpo in (2,3,13) Then --Minoristas
                  Case
                      When ln_diaatr <= 8 Then ln_catdeu := 0;
                      When ln_diaatr <= 30 Then ln_catdeu := 1;
                      When ln_diaatr <= 60 Then ln_catdeu := 2;
                      When ln_diaatr <= 120 Then ln_catdeu := 3;
                      When ln_diaatr > 120 Then ln_catdeu := 4;
                  End Case;
            Else -- No Minoristas
                 Case
                      When ln_diaatr <= 8 Then ln_catdeu := 0;
                      When ln_diaatr <= 60 Then ln_catdeu := 1;
                      When ln_diaatr <= 120 Then ln_catdeu := 2;
                      When ln_diaatr <= 365 Then ln_catdeu := 3;
                      When ln_diaatr > 365 Then ln_catdeu := 4;
                  End Case;
            End If;
        End If;

        /*If lv_estcre in ('REF','TRA') and ln_catdeu = 0 Then
           ln_catdeu := 1;
        End If;*/
        --dbms_output.put_line(to_char(ln_catdeu));

        -- Modalidad del crédito
        Case
          When ln_bcmod = 141 Then ln_modcre := 2; --Indirecto
          When ln_bcmod = 116 Then ln_modcre := 3; --Recurrente
          When ln_bcmod = 108 Then ln_modcre := 4; --Pignoraticio
          When ln_bcmod = 111 Then ln_modcre := 5; --Mi Vivienda
          Else ln_modcre := 1; --Directo
        End Case;

        lv_scrip := 'Update catdeu Set catatr=:1,fecori=:2,refatr=:13,modcre=:14 '||
                    'Where bcfech=:3 and bcemp=:4 and bcsuc=:5 and bcmda=:6 and bcpap=:7 and bcmod=:8 '||
                    'and bccta=:9 and bcoper=:10 and bcsbop=:11 and bctop=:12';
        execute immediate lv_scrip using ln_catdeu,ld_fecori,ln_diaatr,ln_modcre,ld_bcfech,ln_bcemp,ln_bcsuc,
                                         ln_bcmda,ln_bcpap,ln_bcmod,ln_bccta,ln_bcoper,ln_bcsbop,ln_bctop;
        commit;

    END LOOP;
    CLOSE c_credit;
  End sp_categoria_atraso;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_unifica_categoria (PN_3UIT in number)
  Is

     Type tp_clicas IS REF CURSOR;
     c_clicas tp_clicas;

     Type tp_tipcre IS REF CURSOR;
     c_tipcre tp_tipcre;

     lv_scrip varchar2(2000);
     ln_exist number(2);
     ln_pepais fsd001.pepais%type;
     ln_petdoc fsd001.petdoc%type;
     lc_pendoc fsd001.pendoc%type;
     ln_catatr number(1);

     ln_tope   number(12,2);
     ln_saldo  number(12,2);
     ln_catuni number(1);
     ln_bcgpo  fsh012.bcgpo%type;

  Begin

    Select count(*) Into ln_exist From user_tab_columns where TABLE_NAME='CATDEU' and COLUMN_NAME='CATUNI';
    If ln_exist = 0 Then
       lv_scrip := 'Alter table CATDEU add CATUNI number(1)';
       execute immediate lv_scrip;
    End If;

    select count(*) Into ln_exist from user_indexes where table_name='CATDEU' and index_name = 'IX_CATDEU_PERS';
    If ln_exist = 0 Then
       lv_scrip := 'Create Index IX_CATDEU_PERS on CATDEU (pepais,petdoc,pendoc)';
       execute immediate lv_scrip;
    End If;

    select count(*) Into ln_exist from user_indexes where table_name='CATDEU' and index_name = 'IX_CATDEU_TCRE';
    If ln_exist = 0 Then
       lv_scrip := 'Create Index IX_CATDEU_TCRE on CATDEU (pepais,petdoc,pendoc,bcgpo)';
       execute immediate lv_scrip;
    End If;

    -- Unifica categoria de clientes con créditos castigados
    lv_scrip  := 'Select pepais,petdoc,pendoc,max(catatr) From catdeu a '||
                 'Where exists (select 1 from catdeu b '||
                                'where b.pepais=a.pepais '||
                                  'and b.petdoc=a.petdoc '||
                                  'and b.pendoc=a.pendoc '||
                                  'and b.estcre = ''CAS'') Group By pepais,petdoc,pendoc';
    OPEN c_clicas FOR lv_scrip;
    LOOP
        FETCH c_clicas INTO ln_pepais, ln_petdoc, lc_pendoc, ln_catatr;
        EXIT WHEN c_clicas%NOTFOUND;
             --dbms_output.put_line(ln_catatr);
             lv_scrip := 'Update CatDeu Set catuni=:1 '||
                        'Where pepais = :2 '||
                          'And petdoc = :3 '||
                          'And pendoc = :4';
             execute immediate lv_scrip using ln_catatr,ln_pepais,ln_petdoc,lc_pendoc;
             Commit;
    END LOOP;
    CLOSE c_clicas;

    -- Unifica Categoria de clientes sin castigo
    lv_scrip := 'Select pepais,petdoc,pendoc,sum(saldomn) Saldo From catdeu a '||
                 'Where not exists (select 1 from catdeu b '||
                                    'where b.pepais=a.pepais '||
                                      'and b.petdoc=a.petdoc '||
                                      'and b.pendoc=a.pendoc '||
                                      'and b.estcre = ''CAS'')  and estcre <> ''LIN'' Group By pepais,petdoc,pendoc';
    OPEN c_clicas FOR lv_scrip;
    LOOP
         FETCH c_clicas INTO ln_pepais,ln_petdoc,lc_pendoc,ln_saldo;
         EXIT WHEN c_clicas%NOTFOUND;
         -- Estable limite mínimo de saldo
         
         ln_tope := round(ln_saldo/100,2);
         IF ln_tope > PN_3UIT Then
            ln_tope := PN_3UIT;
         End IF;
         ln_catuni := null;
         lv_scrip := 'Select bcgpo,sum(saldomn) From catdeu '||
                      'Where pepais = :1 '||
                        'and petdoc = :2 '||
                        'and pendoc = :3 '||
                        'Group By bcgpo Having sum(saldomn) >= :4';
         OPEN c_tipcre FOR lv_scrip USING ln_pepais,ln_petdoc,lc_pendoc,ln_tope;
         LOOP
           
             FETCH c_tipcre INTO ln_bcgpo,ln_saldo;
             EXIT WHEN c_tipcre%NOTFOUND;
             --dbms_output.put_line('Ingresa');
                  ln_catatr := null;
                  lv_scrip := 'Select max(catatr) From catdeu '||
                               'Where pepais = :1 '||
                                 'and petdoc = :2 '||
                                 'and pendoc = :3 '||
                                 'and bcgpo  = :4 '||
                                 'and saldomn > :5';
                  Begin
                    execute immediate lv_scrip INTO ln_catatr USING ln_pepais,ln_petdoc,lc_pendoc,ln_bcgpo,100;
                  Exception When Others Then
                    ln_catatr := null;
                  End;

                  If ln_catatr is not null Then
                     If ln_catuni is null Then
                        ln_catuni := ln_catatr;
                     ElsIf ln_catuni is not null and ln_catatr > ln_catuni Then
                           ln_catuni := ln_catatr;
                     End If;
                  End If;
         END LOOP;
         CLOSE c_tipcre;
         -- Si no se tiene categoria
         If ln_catuni Is Null Then
           --dbms_output.put_line('Ingresa2');
            lv_scrip := 'Select max(catatr) From catdeu '||
                               'Where pepais = :1 '||
                                 'and petdoc = :2 '||
                                 'and pendoc = :3 ';
            execute immediate lv_scrip INTO ln_catuni USING ln_pepais,ln_petdoc,lc_pendoc;
         End If;
         --- Graba categoría unificada
         lv_scrip := 'Update catdeu set catuni = :1 '||
                      'Where pepais = :2 '||
                        'and petdoc = :3 '||
                        'and pendoc = :4 ';
         execute immediate lv_scrip USING ln_catuni,ln_pepais,ln_petdoc,lc_pendoc;
         commit;
    END LOOP;
    CLOSE c_clicas;
  End sp_unifica_categoria;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_alineamiento(PD_FECRCC in date)
  Is

    lv_scrip varchar2(2000);
    ln_exist number(1);

    Type tp_cursor IS REF CURSOR;
    c_cursor tp_cursor;

    Type tp_catrcc IS Ref Cursor;
    c_catrcc tp_catrcc;

    ln_pepais fsd001.pepais%type;
    ln_petdoc fsd001.petdoc%type;
    lc_pendoc fsd001.pendoc%type;
    ln_deudor number(1);
    ln_catuni number(1);
    lv_tipdoc varchar2(1);
    lv_numdoc varchar2(12);
    lv_codsbs varchar2(10);
    lv_empali varchar2(5);
    lv_emptmp varchar2(5);
    ln_cattmp number(1);
    ln_endtot number(12,2);
    ln_endcat number(12,2);
    ln_catrcc number(1);
    ln_catali number(1);
    ln_porend number(5,2);
  Begin

    Select count(*) into ln_exist from user_tab_columns where table_name='CATDEU' and column_name='CODSBS';
    If ln_exist = 0 Then
       lv_scrip := 'Alter table catdeu add codsbs varchar2(10)';
       execute immediate lv_scrip;
    End If;

    Select count(*) into ln_exist from user_tab_columns where table_name='CATDEU' and column_name='FECRCC';
    If ln_exist = 0 Then
       lv_scrip := 'Alter table catdeu add fecrcc date';
       execute immediate lv_scrip;
    End If;

    Select count(*) into ln_exist from user_tab_columns where table_name='CATDEU' and column_name='CATALI';
    If ln_exist = 0 Then
       lv_scrip := 'Alter table catdeu add catali number(1)';
       execute immediate lv_scrip;
    End If;

    Select count(*) into ln_exist from user_tab_columns where table_name='CATDEU' and column_name='EMPALI';
    If ln_exist = 0 Then
       lv_scrip := 'Alter table catdeu add empali varchar2(5)';
       execute immediate lv_scrip;
    End If;

    -- Personas por tipo de endeudamiento y categoria
    lv_scrip := 'Select pepais,petdoc,pendoc,'||
                       'max(case when bcgpo in (2,3,4,13) then 2 else 1 end),'||
                       'max(catuni) '||
                  'From catdeu '||
                 'Where estcre <> ''LIN'' '||--and pendoc = ''01203388    '' '||
                 'Group By pepais,petdoc,pendoc';
    Open c_cursor FOR lv_scrip;
    Loop
       Fetch c_cursor Into ln_pepais,ln_petdoc,lc_pendoc,ln_deudor,ln_catuni;
       Exit When c_cursor%NotFound;
       -- Buscar Codigo SBS
       Case
           When ln_petdoc = 2 Then lv_tipdoc:='2';
           When ln_petdoc = 5 Then lv_tipdoc:='5';
           When ln_petdoc = 9 Then lv_tipdoc:='3';
           When ln_petdoc =21 Then lv_tipdoc:='1';
           Else lv_tipdoc := '1';
       End Case;
       lv_numdoc:=trim(lc_pendoc);

       lv_scrip := 'Select c_codsbs From cldrcci where d_fecpre=:1 ';
       If ln_petdoc <> 9 Then
          lv_scrip := lv_scrip||'and c_tdocid=:2 and c_docide=:3';
       Else
          lv_scrip := lv_scrip||'and c_tdoctr=:2 and c_doctri=:3';
       End If;

       Begin
            execute immediate lv_scrip into lv_codsbs using PD_FECRCC,lv_tipdoc,lv_numdoc;
       Exception When Others Then
            lv_codsbs:=null;
       End;

       -- Si tiene historial en RCC, evaluar alineamiento
       If lv_codsbs is not null then
          lv_scrip := 'Select distinct to_number(c_calvig),c_codemp From cldrccs '||
                       'Where d_fecpre =:1 and c_codsbs =:2 and to_number(c_calvig)>:3 and c_calvig <> ''8'' '||
                         'and c_codemp <> ''00104'' '||
                         'and (substr(c_cuenta,1,4) in (''1411'',''1412'',''1413'',''1414'',''1415'',''1416'','||
                                                       '''1421'',''1422'',''1423'',''1424'',''1425'',''1426'') '||
                               'or substr(c_cuenta,1,6) in (''811302'',''812302'') '||
                               'or c_cuenta in (''71110000000000'',''71120000000000'',''71130000000000'',''71140000000000'','||
                                               '''71210000000000'',''71220000000000'',''71230000000000'',''71240000000000'') '||
                             ') ';
          If ln_deudor = 2 Then -- Deudor Minorista
             lv_scrip := lv_scrip||'and c_calvig in (''3'',''4'') and n_diaatr <=1800';
          End If;

          ln_catrcc:=null;
          lv_emptmp:=null;
          ln_catali:=null;
          ln_cattmp:=null;
          lv_empali:=null;
          ln_porend:=null;

          Open c_catrcc For lv_scrip Using PD_FECRCC,lv_codsbs,ln_catuni;
          Loop
              Fetch c_catrcc Into ln_catrcc,lv_emptmp;
              Exit When c_catrcc%Notfound;
            --dbms_output.put_line('Emp:'||lv_emptmp);
            --dbms_output.put_line('Cat rcc:'||ln_catrcc);
            --dbms_output.put_line('Cat tmp:'||ln_cattmp);
              If ln_catali is null Or ln_catrcc>ln_catali Then
                 ln_cattmp:=ln_catrcc;  --Revisa % de Endeudamiento
               --dbms_output.put_line('Tmp:'||ln_cattmp);
                 lv_scrip:='Select sum(n_salcap) From cldrccs '||
                           'Where d_fecpre =:1 and c_codsbs =:2 '||
                           'and (substr(c_cuenta,1,4) in (''1411'',''1412'',''1413'',''1414'',''1415'',''1416'','||
                                                       '''1421'',''1422'',''1423'',''1424'',''1425'',''1426'') '||
                               'or substr(c_cuenta,1,6) in (''811302'',''812302'') '||
                               'or c_cuenta in (''71110000000000'',''71120000000000'',''71130000000000'',''71140000000000'','||
                                               '''71210000000000'',''71220000000000'',''71230000000000'',''71240000000000'') '||
                             ') ';
                 If ln_deudor = 2 Then -- Deudor Minorista
                    lv_scrip := lv_scrip||'and n_diaatr <=1800 ';
                 End If;
                 execute immediate lv_scrip into ln_endtot using PD_FECRCC,lv_codsbs;

                 -- Endeudamiento de la categoria y excluir Caja Aqp
                 lv_scrip := lv_scrip||'and c_codemp<>''00104'' and c_calvig=:3';
                 execute immediate lv_scrip into ln_endcat using PD_FECRCC,lv_codsbs,to_char(ln_cattmp);

               --dbms_output.put_line('tot:'||ln_endtot);
               --dbms_output.put_line('cat:'||ln_endcat);
               ln_porend := round((ln_endcat/ln_endtot)*100,2);
               --dbms_output.put_line('%:'||ln_porend);
                 If ln_porend >= 20 Then
                    ln_catali:=ln_cattmp;
                    lv_empali:=lv_emptmp;
                 End IF;   
                 
                 ln_cattmp := null;
                 
                 --dbms_output.put_line('tali:'||ln_catali);
                --dbms_output.put_line('emp:'||lv_empali);
              End If;
              
          End Loop;
          Close c_catrcc;
          -- Actualiza categoria
        --dbms_output.put_line('Upd:'||ln_catali||'-'||lv_empali||'-'||lv_codsbs);
          lv_scrip:='Update catdeu set catali=:1,empali=:2,fecrcc=:3,codsbs=:4 '||
                     'Where pepais=:5 '||
                       'and petdoc=:6 '||
                       'and pendoc=:7';
          execute immediate lv_scrip using ln_catali,lv_empali,PD_FECRCC,lv_codsbs,ln_pepais,ln_petdoc,lc_pendoc;
          commit;
       End If;

    End Loop;
    Close c_cursor;
  End sp_alineamiento;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_ingreso_diferido
  Is
    lv_scrip varchar2(2000);
    ln_exist number(1);

    Type tp_ingdif is Ref Cursor;
    c_ingdif tp_ingdif;

    Type tp_bcfech is table of fsh012.bcfech%type;
    Type tp_bcemp  is table of fsh012.bcemp%type;
    Type tp_bcsuc  is table of fsh012.bcsuc%type;
    Type tp_bcmda  is table of fsh012.bcmda%type;
    Type tp_bcpap  is table of fsh012.bcpap%type;
    Type tp_bcmod  is table of fsh012.bcmod%type;
    Type tp_bccta  is table of fsh012.bccta%type;
    Type tp_bcoper is table of fsh012.bcoper%type;
    Type tp_bcsbop is table of fsh012.bcsbop%type;
    Type tp_bctop  is table of fsh012.bctop%type;
    Type tp_mtodif is table of number index by pls_integer;

    ld_bcfech tp_bcfech;
    ln_bcemp  tp_bcemp ;
    ln_bcsuc  tp_bcsuc ;
    ln_bcmda  tp_bcmda ;
    ln_bcpap  tp_bcpap ;
    ln_bcmod  tp_bcmod ;
    ln_bccta  tp_bccta ;
    ln_bcoper tp_bcoper;
    ln_bcsbop tp_bcsbop;
    ln_bctop  tp_bctop ;
    ln_ingdif tp_mtodif;
  Begin
       select count(*) into ln_exist from user_tab_columns where table_name='CATDEU' and column_name='INGDIF';
       If ln_exist = 0 Then
          lv_scrip:='Alter table catdeu add ingdif number(12,2)';
          execute immediate lv_scrip;
       End If;
       lv_scrip := 'Select c.bcfech, c.bcemp,c.bcsuc,c.bcmda,c.bcpap,c.bcmod,c.bccta,c.bcoper,c.bcsbop,c.bctop,sum(h.bcsdmn) '||
                     'From catdeu c join fsr014 r on r.rubro = c.rubro '||
                                                'and r.rrcod in (330,430) '||
                                    'join fsh012 h on h.bcemp = c.bcemp '||
                                                 'and h.bcsuc = c.bcsuc '||
                                                 'and h.bcrubr= r.rrrubr '||
                                                 'and h.bcmda = c.bcmda '||
                                                 'and h.bcpap = c.bcpap '||
                                                 'and h.bccta = c.bccta '||
                                                 'and h.bcoper= c.bcoper '||
                                                 'and h.bcfech= c.bcfech '||
                    'Where estcre not in (''CAS'',''LIN'') and saldomn > 0 '||
                    'Group By c.bcfech, c.bcemp,c.bcsuc,c.bcmda,c.bcpap,c.bcmod,c.bccta,c.bcoper,c.bcsbop,c.bctop';
        Open c_ingdif For lv_scrip;
        Loop
            Fetch c_ingdif bulk collect Into ld_bcfech,ln_bcemp,ln_bcsuc,ln_bcmda,ln_bcpap,ln_bcmod,ln_bccta,ln_bcoper,
                                             ln_bcsbop,ln_bctop,ln_ingdif limit 1000;
            EXIT WHEN ln_bcemp.COUNT <= 0;
            For x in ln_bcemp.first .. ln_bcemp.last Loop
                           lv_scrip := 'Update catdeu Set ingdif=:1 '||
                        'Where bcfech=:2 and bcemp=:3 and bcsuc=:4 and bcmda=:5 and bcpap=:6 and bcmod=:7 '||
                          'and bccta=:8 and bcoper=:9 and bcsbop=:10 and bctop=:11';
            execute immediate lv_scrip using ln_ingdif(x),ld_bcfech(x),ln_bcemp(x),ln_bcsuc(x),ln_bcmda(x),ln_bcpap(x),
                                             ln_bcmod(x),ln_bccta(x),ln_bcoper(x),ln_bcsbop(x),ln_bctop(x);
            commit;
            End Loop;
        End Loop;
        Close c_ingdif;

        /*For x IN ln_bcemp.FIRST .. ln_bcemp.LAST Loop

        End Loop; */
  End sp_ingreso_diferido;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_categoria_manual(PD_FECHA in date)
  Is
    ln_exist number(1);
    lv_scrip varchar2(500);

    Type tp_cursor is Ref Cursor;
    c_cursor tp_cursor;

    ln_pepais fsd001.pepais%type;
    ln_petdoc fsd001.petdoc%type;
    lc_pendoc fsd001.pendoc%type;
    ln_catman number(1);
  Begin
        select count(*) Into ln_exist From user_tab_columns Where table_name='CATDEU' and column_name='CATMAN';
        If ln_exist = 0 Then
           lv_scrip := 'Alter table catdeu add catman number(1)';
           execute immediate lv_scrip;
        End If;

        lv_scrip := 'Select c.pepais,c.petdoc,c.pendoc,max(to_number(substr(d.catcateg,1,1))) '||
                      'From catdeu c join fsd212 d on d.pgcod = c.bcemp '||
                                                 'and d.catcta= c.bccta '||
                                                 'and to_char(d.catfchdes,''rrrrmm'') = to_char(c.bcfech,''rrrrmm'') '||
                     'Where c.bcfech = :1 '||
                       'and d.catcod = 5 and estcre <> ''LIN'' '||
                     'Group By c.pepais,c.petdoc,c.pendoc';
        Open c_cursor For lv_scrip Using PD_FECHA;
        Loop
             Fetch c_cursor Into ln_pepais,ln_petdoc,lc_pendoc,ln_catman;
             Exit When c_cursor%Notfound;

             lv_scrip := 'Update catdeu Set catman =:1 '||
                         'Where pepais =:2 and petdoc =:3 and pendoc =:4';
             Execute Immediate lv_scrip Using ln_catman,ln_pepais,ln_petdoc,lc_pendoc;
             commit;
        End Loop;
        Close c_cursor;
  End sp_categoria_manual;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_categoria_def_per
  Is
    ln_exist number(1);
    lv_scrip varchar2(500);

    Type tp_cursor is Ref Cursor;
    c_cursor tp_cursor;

    Type tp_catcon is Ref Cursor;
    c_catcon tp_catcon;

    type tp_fecha  is table of fsh012.bcfech%type;
    Type tp_pepais is table of fsd001.pepais%type;
    Type tp_petdoc is table of fsd001.petdoc%type;
    Type tp_pendoc is table of fsd001.pendoc%type;
    Type tp_catego is table of number index by pls_integer;

    ln_pepais tp_pepais;
    ln_petdoc tp_petdoc;
    lc_pendoc tp_pendoc;
    ln_catego tp_catego;
    ld_fecha  tp_fecha;

    ld_fectmp date;
    ln_mescon number(2);
    ln_cont   number(2);
    ln_nummes number(2);
    lv_catmes varchar2(1);
  Begin
        select count(*) Into ln_exist From user_tab_columns Where table_name='CATDEU' and column_name='DEFPER';
        If ln_exist = 0 Then
           lv_scrip := 'Alter table catdeu add DEFPER number(2)';
           execute immediate lv_scrip;
        End If;

        lv_scrip:='Select distinct bcfech,pepais,petdoc,pendoc,nvl(catali,catuni) '||
                  'From catdeu '||
                  'Where nvl(catali,catuni)> 2 '||
                  'and estcre not in (''CAS'',''LIN'') '||
                  'and saldomn > 0';
                  --'and pendoc like ''29525273%''';
        Open c_cursor For lv_scrip;
        Loop
            Fetch c_cursor bulk collect Into ld_fecha,ln_pepais,ln_petdoc,lc_pendoc,ln_catego limit 1000;
            Exit When ln_pepais.count <= 0;

            For x in ln_pepais.FIRST .. ln_pepais.LAST Loop
                ld_fectmp:= add_months(ld_fecha(x),-1);
                ln_mescon:= 0;
                ln_cont  := 0;

                if ln_catego(x) = '3' Then
                   ln_nummes := 36;
                Else
                   ln_nummes := 24;
                End If;

                Loop
                    --ln_cont   := ln_cont + 1;
                    ld_fectmp := add_months(ld_fectmp,-1);

                    lv_scrip := 'Select max(to_number(substr(r.catcateg,1,1))) '||
                                'From catdeu c '||
                                'Join fsd212 r on r.pgcod = c.bcemp '||
                                             'and r.catcta= c.bccta '||
                                             'and r.catcod= 4 '||
                                             'and to_char(r.catfchdes,''rrrrmm'') = :1 '||
                                'Where pepais=:2 and petdoc=:3 and pendoc=:4';
                    Open c_catcon For lv_scrip Using to_char(ld_fectmp,'rrrrmm'),ln_pepais(x),ln_petdoc(x),lc_pendoc(x);
                    Loop
                        Fetch c_catcon Into lv_catmes;
                        If c_catcon%rowcount <= 0 Then
                           ld_fectmp := add_months(ld_fecha(x),-(ln_nummes+1));
                        End If;
                        Exit When c_catcon%NotFound;
                        --DBMS_OUTPUT.put_line(to_char(ld_fectmp,'rrrr.mm.dd')||' - '||lv_catmes);
                        If to_number(lv_catmes) = ln_catego(x) Then
                           ln_mescon := ln_mescon + 1;
                        Else
                           ld_fectmp := add_months(ld_fecha(x),-(ln_nummes+1));
                           --DBMS_OUTPUT.put_line('Exit:'||to_char(ld_fectmp,'rrrr.mm.dd'));
                           Exit;
                        End If;
                    End Loop;
                    Close c_catcon;
                Exit When ld_fectmp < add_months(ld_fecha(x),-ln_nummes);
                End Loop;

                --DBMS_OUTPUT.put_line('Meses:'||ln_mescon);

                --If (ln_catego(x) = '3' and ln_mescon = 36) or (ln_catego(x) = '4' and ln_mescon = 24) Then

                   ln_mescon := ln_mescon + 1;
                   lv_scrip := 'Update catdeu Set defper =:1 '||
                               'Where pepais = :2 and petdoc =:3 and pendoc =:4';
                   execute immediate lv_scrip using ln_mescon, ln_pepais(x), ln_petdoc(x), lc_pendoc(x);
                   commit;
                --End If;
            End Loop;

        End Loop;
        Close c_cursor;

  End sp_categoria_def_per;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_provision_gen_esp(PD_FECHA in date,
                                 PV_PROCICLICA in varchar2,
                                 PV_SOBREENDEU in varchar2)
  Is
    ln_exist number(1);
    lv_scrip varchar2(1000);

    Type tp_cursor is Ref Cursor;
    c_cursor tp_cursor;

    Type tp_bcfech is table of fsh012.bcfech%type;
    Type tp_bcemp  is table of fsh012.bcemp%type;
    Type tp_bcsuc  is table of fsh012.bcsuc%type;
    Type tp_bcmda  is table of fsh012.bcmda%type;
    Type tp_bcpap  is table of fsh012.bcpap%type;
    Type tp_bcmod  is table of fsh012.bcmod%type;
    Type tp_bccta  is table of fsh012.bccta%type;
    Type tp_bcoper is table of fsh012.bcoper%type;
    Type tp_bcsbop is table of fsh012.bcsbop%type;
    Type tp_bctop  is table of fsh012.bctop%type;
    Type tp_bcgpo  is table of fsh012.bcgpo%type;
    Type tp_bcfvto is table of fsh012.bcfvto%type;
    Type tp_diaatr is table of number index by pls_integer;
    Type tp_categ  is table of number index by pls_integer;
    Type tp_saldo  is table of number index by pls_integer;
    Type tp_ingdif is table of number index by pls_integer;
    Type tp_nummes is table of number index by pls_integer;
    Type tp_catman is table of number index by pls_integer;
    Type tp_catatr is table of number index by pls_integer;
    Type tp_catali is table of number index by pls_integer;
    Type tp_catuni is table of number index by pls_integer;
    Type tp_lindis is table of number index by pls_integer;
    
    ld_bcfech tp_bcfech;
    ln_bcemp  tp_bcemp ;
    ln_bcsuc  tp_bcsuc ;
    ln_bcmda  tp_bcmda ;
    ln_bcpap  tp_bcpap ;
    ln_bcmod  tp_bcmod ;
    ln_bccta  tp_bccta ;
    ln_bcoper tp_bcoper;
    ln_bcsbop tp_bcsbop;
    ln_bctop  tp_bctop ;
    ln_ingdif tp_ingdif;
    ln_bcgpo  tp_bcgpo;
    ln_catego tp_categ;
    ln_saldo  tp_saldo;
    ln_diaatr tp_diaatr;
    ln_nummes tp_nummes;
    ln_catman tp_catman;
    ln_catatr tp_catatr;
    ln_catali tp_catali;
    ln_catuni tp_catuni;
    ln_lindis tp_lindis;
    ld_bcfvto tp_bcfvto;

    ln_porprv number(7,2);
    ln_porprc number(7,2);
    ln_porsob number(7,2);
    ln_porpes number(7,2);
    ln_porinc number(7,2);
    ln_porsev number(7,2);
    ln_ppratr number(7,2);
    ln_ppruni number(7,2);
    ln_pprali number(7,2);
    ln_pprman number(7,2);
    lv_garhip varchar2(1);
    ln_saldop  number(12,2);
    ln_mtoprv number(12,2);
    ln_mtoprc number(12,2);
    ln_mtoprs number(12,2);
    ln_prvatr number(12,2);
    ln_prvuni number(12,2);
    ln_prvali number(12,2);
    ln_prvman number(12,2);

  Begin
       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='CATFIN';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add catfin number(1)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PORPRV';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add porprv number(7,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PORPRC';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add porprc number(7,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PERESP';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add peresp number(7,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PORSOB';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add porsob number(7,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='MTOPRV';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add mtoprv number(12,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='MTOPRC';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add mtoprc number(12,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='MTOPRS';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add mtoprs number(12,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='GARHIP';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add garhip varchar2(1)';
          execute immediate lv_scrip;
       End If;
       
       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PPRATR';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add ppratr number(7,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PROATR';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add proatr number(12,2)';
          execute immediate lv_scrip;
       End If;
       
       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PPRUNI';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add ppruni number(7,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PROUNI';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add prouni number(12,2)';
          execute immediate lv_scrip;
       End If;
       
       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PPRALI';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add pprali number(7,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PROALI';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add proali number(12,2)';
          execute immediate lv_scrip;
       End If;
       
       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PPRMAN';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add pprman number(7,2)';
          execute immediate lv_scrip;
       End If;

       select count(*) Into ln_exist From user_tab_columns Where Table_Name = 'CATDEU' and Column_Name='PROMAN';
       If ln_exist = 0 Then
          lv_scrip := 'Alter Table catdeu add proman number(12,2)';
          execute immediate lv_scrip;
       End If;
       
       lv_scrip := 'Select bcfech,bcemp,bcsuc,bcmda,bcpap,bcmod,bccta,bcoper,bcsbop,bctop,bcgpo,'||
                           'nvl(catman,nvl(catali,catuni)),nvl(saldomn,0),nvl(ingdif,0),diaatr,defper,catman,'||
                           'catatr,catuni,catali,lindis,bcfvto '||
                   'From catdeu '||
                   'Where estcre <> ''CAS'' '||
                   'and saldomn <> 0 '||
                   'and bcfech = :1';
       Open c_cursor For lv_scrip using PD_FECHA;
       Loop
           Fetch c_cursor bulk collect Into ld_bcfech,ln_bcemp,ln_bcsuc,ln_bcmda,ln_bcpap,ln_bcmod,ln_bccta,ln_bcoper,ln_bcsbop,
                                            ln_bctop,ln_bcgpo,ln_catego,ln_saldo,ln_ingdif,ln_diaatr,ln_nummes,ln_catman,
                                            ln_catatr,ln_catuni,ln_catali,ln_lindis,ld_bcfvto Limit 10000;

           For x In ln_bcemp.First .. ln_bcemp.Last Loop
               ln_porprc:=null;
               ln_porsob:=null;
               ln_mtoprc:=null;
               ln_mtoprs:=null;
               ln_porpes:=null;
               ln_prvatr:=null;
               ln_prvuni:=null;
               ln_prvali:=null;
               ln_prvman:=null;
               
               If ln_bcmod(x) = 117 and ln_catego(x) is null then
                 ln_porprv:=pq_categoria_provision.fn_porcentaje_provision(0,ln_bcgpo(x)); 
               Else   
                 ln_porprv:=pq_categoria_provision.fn_porcentaje_provision(ln_catego(x),ln_bcgpo(x));
                 ln_ppratr:=pq_categoria_provision.fn_porcentaje_provision(ln_catatr(x),ln_bcgpo(x));
                 ln_ppruni:=pq_categoria_provision.fn_porcentaje_provision(ln_catuni(x),ln_bcgpo(x));
                 ln_pprali:=pq_categoria_provision.fn_porcentaje_provision(ln_catali(x),ln_bcgpo(x));
                 ln_pprman:=pq_categoria_provision.fn_porcentaje_provision(ln_catman(x),ln_bcgpo(x));
               End If;
               
               If PV_PROCICLICA = 'S' and ln_catego(x) = 0 Then
                  Case
                       When ln_bcgpo(x)= 4 Then ln_porprc:=0.4;  --Hipotecario
                       When ln_bcgpo(x)= 3 and ln_bcmod(x) <> 116 Then ln_porprc:=1;    --Consumo No Revolvente
                       When ln_bcgpo(x)= 3 and ln_bcmod(x) =  116 Then ln_porprc:=1.5;    --Consumo No Revolvente
                       When ln_bcgpo(x)= 2 Then ln_porprc:=0.5;    --Microempresa
                       When ln_bcgpo(x)=13 Then ln_porprc:=0.5;    --Pequeña Empresa
                       When ln_bcgpo(x)=12 Then ln_porprc:=0.3;    --Mediana Empresa
                       When ln_bcgpo(x)=11 Then ln_porprc:=0.45;  --Grande Empresa
                       Else ln_porprc:=0.40;          --Corporativo
                   End Case;
               End If;
               
               --Categoría del deudor Pérdida más de 24 meses o Dudoso más de 36 meses
               If ln_catego(x) = 3 and ln_nummes(x) > 36 and ln_catman(x) is null Then
                  ln_porprv := 60;
               Elsif ln_catego(x) = 4 and ln_nummes(x) > 24 and ln_catman(x) is null Then
                  ln_porprv := 100;
               End IF;

               If PV_SOBREENDEU='S' And ln_catego(x) = 0 And ln_bcgpo(x) in (2,3,13) and ln_bcmod(x) not in (141,117) Then
                      -- Provision por sobreendeudamiento Consumo,Micro y Pequeña créditos directos
                     ln_porsob := 1;
               ElsIf PV_SOBREENDEU='S' and ln_bcgpo(x) in (2,3,13) and 
                     (ln_bcmod(x) = 141 or
                      ((ln_bcmod(x) = 117 and ld_bcfvto(x)>=ld_bcfech(x)) Or 
                       (ln_bcmod(x) = 117 and ld_bcfvto(x)<ld_bcfech(x) and ln_saldo(x)-ln_lindis(x)>0)
                      )
                     )
                     Then
                     ln_porsob := 0.20 * ln_porprv;
               End If;

               -- Evaluar Crédits No Minoristas e Hipotecarios con más de 90 días para Pérdida Esperada
               If ln_bcgpo(x) not in (2,3,13) and ln_diaatr(x) > 90 Then
                  -- Confirmar garantía hipotecaria
                  Begin
                      Select distinct 'S' Into lv_garhip
                        from fsr011 r11
                        where r11.r1cod = ln_bcemp(x)
                          and r11.r1mod = ln_bcmod(x)
                          and r11.r1mda = ln_bcmda(x)
                          and r11.r1pap = ln_bcpap(x)
                          and r11.r1cta = ln_bccta(x)
                          and r11.r1oper= ln_bcoper(x)
                          and r11.r1sbop= ln_bcsbop(x)
                          and r11.r1tope= ln_bctop(x)
                          and r11.relcod= 50
                          and r11.r011co= 'S'
                          and r11.r2mod = 70
                          and r11.r2tope in (10,15);
                   Exception When Others Then
                      lv_garhip := null;
                   End;

                   If lv_garhip is not null Then
                      ln_porinc := 100;
                      ln_porsev := 50;
                   Else
                      ln_porinc := 100;
                      ln_porsev := 70;
                   End If;
                   ln_porpes := ((ln_porinc*ln_porsev*ln_saldo(x))/(ln_saldo(x)-ln_ingdif(x)))/100;
               End If;

               ln_saldop := ln_saldo(x);
               If ln_bcmod(x) = 141 Then
                  ln_saldop := (ln_saldo(x)*0.5);
               End If;

               If nvl(ln_porpes,0)> ln_porprv Then
                  -- Provisiona con Pérdida Esperada
                  ln_mtoprv := (ln_porpes * (ln_saldop-ln_ingdif(x)))/100;
               Else
                  ln_mtoprv := (ln_porprv * (ln_saldop-ln_ingdif(x)))/100;
               End If;
               
               -- Provisiones Previas
               ln_prvatr := (ln_ppratr * (ln_saldop-ln_ingdif(x)))/100;
               ln_prvuni := (ln_ppruni * (ln_saldop-ln_ingdif(x)))/100;
               ln_prvali := (ln_pprali * (ln_saldop-ln_ingdif(x)))/100;
               ln_prvman := (ln_pprman * (ln_saldop-ln_ingdif(x)))/100;
               
               -- Provisión Proíclica
               If ln_porprc is not null Then
                  ln_mtoprc := (ln_porprc * (ln_saldop-ln_ingdif(x)))/100;
               End If;
               -- Provisión por Sobreendeudamiento
               If ln_porsob is not null Then
                  If ln_bcmod(x) = 117 Then
                     ln_mtoprs := (ln_lindis(x) * ln_porsob)/100;
                  Else  
                     ln_mtoprs := ((ln_saldop-ln_ingdif(x)) * ln_porsob)/100;
                  End If;   
               End If;
               
               -- Actualiza Datos
               lv_scrip:='Update catdeu Set catfin=:1,porprv=:2,mtoprv=:3,porprc=:4,mtoprc=:5,porsob=:6,mtoprs=:7,peresp=:8,garhip=:9,'||
                                           'ppratr=:18,proatr=:19,ppruni=:20,prouni=:21,pprali=:22,proali=:23,pprman=:24,proman=:25 '||
                          'Where bcfech=:8 and bcemp=:9 and bcsuc=:10 and bcmda=:11 and bcpap=:12 and bcmod=:13 '||
                            'and bccta=:14 and bcoper=:15 and bcsbop=:16 and bctop=:17';
               execute immediate lv_scrip using ln_catego(x),ln_porprv,ln_mtoprv,ln_porprc,ln_mtoprc,ln_porsob,ln_mtoprs,ln_porpes,lv_garhip,
                                                ln_ppratr,ln_prvatr,ln_ppruni,ln_prvuni,ln_pprali,ln_prvali,ln_pprman,ln_prvman,
                                                ld_bcfech(x),ln_bcemp(x),ln_bcsuc(x),ln_bcmda(x),ln_bcpap(x),
                                                ln_bcmod(x),ln_bccta(x),ln_bcoper(x),ln_bcsbop(x),ln_bctop(x);
            commit;

           End Loop;
           Exit when c_cursor%notfound;
       End Loop;
       Close c_cursor;


  End sp_provision_gen_esp;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_catprv_bantotal(PD_FECHA in date)
  Is
    lv_scrip varchar2(1000);
    ln_exist number(1);

    Type tp_cursor is Ref Cursor;
    c_cursor tp_cursor;

    Type tp_bcfech is table of fsh012.bcfech%type;
    Type tp_bcemp  is table of fsh012.bcemp%type;
    Type tp_bcsuc  is table of fsh012.bcsuc%type;
    Type tp_bcmda  is table of fsh012.bcmda%type;
    Type tp_bcpap  is table of fsh012.bcpap%type;
    Type tp_bcmod  is table of fsh012.bcmod%type;
    Type tp_bccta  is table of fsh012.bccta%type;
    Type tp_bcoper is table of fsh012.bcoper%type;
    Type tp_bcsbop is table of fsh012.bcsbop%type;
    Type tp_bctop  is table of fsh012.bctop%type;
    Type tp_rubro  is table of fsh012.bcrubr%type;
    Type tp_bcgpo  is table of fsh012.bcgpo%type;

    ld_bcfech tp_bcfech;
    ln_bcemp  tp_bcemp ;
    ln_bcsuc  tp_bcsuc ;
    ln_bcmda  tp_bcmda ;
    ln_bcpap  tp_bcpap ;
    ln_bcmod  tp_bcmod ;
    ln_bccta  tp_bccta ;
    ln_bcoper tp_bcoper;
    ln_bcsbop tp_bcsbop;
    ln_bctop  tp_bctop ;
    ln_rubro  tp_rubro;
    ln_bcgpo  tp_bcgpo; 

    ln_catres number(1);
    ln_impprv number(12,2);
    ln_impprc number(12,2);
    ln_impprs number(12,2);
    
    ln_imppcv number(12,2);
    ln_imppcc number(12,2);
    ln_imppcs number(12,2);

  Begin
       Select count(*) Into ln_exist From user_tab_columns Where table_name='CATDEU' and column_name='CATRES';
       If ln_exist = 0 Then
          lv_scrip := 'Alter table catdeu add catres number(1)';
          execute immediate lv_scrip;
       End If;

       Select count(*) Into ln_exist From user_tab_columns Where table_name='CATDEU' and column_name='IMPPRV';
       If ln_exist = 0 Then
          lv_scrip := 'Alter table catdeu add impprv number(12,2)';
          execute immediate lv_scrip;
       End If;

       Select count(*) Into ln_exist From user_tab_columns Where table_name='CATDEU' and column_name='IMPPRC';
       If ln_exist = 0 Then
          lv_scrip := 'Alter table catdeu add impprc number(12,2)';
          execute immediate lv_scrip;
       End If;

       Select count(*) Into ln_exist From user_tab_columns Where table_name='CATDEU' and column_name='IMPPRS';
       If ln_exist = 0 Then
          lv_scrip := 'Alter table catdeu add impprs number(12,2)';
          execute immediate lv_scrip;
       End If;

       lv_scrip := 'Select bcfech,bcemp,bcsuc,bcmda,bcpap,bcmod,bccta,bcoper,bcsbop,bctop,'||
                          'case when bcmod=117 Then rubdis else rubro end, bcgpo '||
                     'From catdeu Where saldomn <> 0 and estcre <> ''CAS''';-- Where bccta=269345';--||
                     --'Where pendoc in('||
                     --'''02388715    '',''29238617    '',''29476836    '',''20490599143 '',''20454121059 '',''20490484915 '',''20455000395 '')';

       --dbms_output.put_line(lv_scrip);
       Open c_cursor For lv_scrip;
       Loop
           Fetch c_cursor bulk collect Into ld_bcfech,ln_bcemp,ln_bcsuc,ln_bcmda,ln_bcpap,ln_bcmod,
                                            ln_bccta,ln_bcoper,ln_bcsbop,ln_bctop,ln_rubro,ln_bcgpo Limit 10000;
           --dbms_output.put_line('z');
           For x in ln_bcemp.FIRST .. ln_bcemp.LAST Loop
           -- Obtiene categoría resultante
           ln_catres:= null;
           Begin
              --dbms_output.put_line('X');
                --Select Max(to_number(substr(catcateg,1,1))) Into ln_catres
                Select to_number(substr(catcateg,1,1)) Into ln_catres
                  From fsd212
                 Where pgcod=ln_bcemp(x)
                   --and to_char(catfchdes,'rrrrmm')=to_char(PD_FECHA,'rrrrmm')
                   and catfchdes = PD_FECHA
                   and catcta = ln_bccta(x)
                   and catcod = 5;
           Exception
              When No_Data_Found Then
                   --If ln_catres is null Then
                   Begin
                      --Select Max(to_number(substr(catcateg,1,1))) Into ln_catres
                      Select to_number(substr(catcateg,1,1)) Into ln_catres
                        From fsd212
                       Where pgcod=ln_bcemp(x)
                         --and to_char(catfchdes,'rrrrmm')=to_char(PD_FECHA,'rrrrmm')
                         and catfchdes = PD_FECHA
                         and catcta = ln_bccta(x)
                         and catcod = 4;
                   --End If;
                   Exception When Others Then
                      ln_catres := null;
                   End;
              When Others Then
                   ln_catres := null;
           End;     
           --dbms_output.put_line(ln_catres);
           -- Obtiene importes de provisión
           Begin
               
                 Select sum(case when r14.rrcod in (35,335) then h12.bcsdmn else 0 end),
                        sum(case when r14.rrcod = 635 then h12.bcsdmn else 0 end),
                        sum(case when r14.rrcod = 735 then h12.bcsdmn else 0 end)
                   Into ln_impprv,ln_impprc,ln_impprs
                   From fsh012 h12
                   join fsr014 r14 on r14.rrrubr = h12.bcrubr
                                  and r14.rubro  = ln_rubro(x)
                                  and r14.rrcod in (335,35,635,735)
                  Where h12.bcemp = ln_bcemp(x)
                    and h12.bcsuc = ln_bcsuc(x)
                    and h12.bcmda = ln_bcmda(x)
                    and h12.bccta = ln_bccta(x)
                    and h12.bcoper= ln_bcoper(x)
                    and h12.bcsbop= ln_bcsbop(x)
                    and h12.bcfech= PD_FECHA;
           Exception When Others Then
               ln_impprv := null;
               ln_impprc := null;
               ln_impprs := null;
           End;
           If ln_bcgpo(x) in (3,4) Then --Consumo e Hipotecario: Provisión Cuota Vencida
              Begin
                  Select sum(case when r14.rrcod in (35,335) then h12.bcsdmn else 0 end),
                         sum(case when r14.rrcod = 635 then h12.bcsdmn else 0 end),
                         sum(case when r14.rrcod = 735 then h12.bcsdmn else 0 end)
                    Into ln_imppcv,ln_imppcc,ln_imppcs
                    From fsh012 h12
                    join fsr014 v14 on v14.rubro  = ln_rubro(x) 
                                   and v14.rrcod  = 471
                    join fsr014 r14 on r14.rubro  = v14.rrrubr
                                   and r14.rrcod  in (35,335,635,735)   
                                   and r14.rrrubr = h12.bcrubr            
                  Where h12.bcemp = ln_bcemp(x)
                    and h12.bcsuc = ln_bcsuc(x)
                    and h12.bcmda = ln_bcmda(x)
                    and h12.bccta = ln_bccta(x)
                    and h12.bcoper= ln_bcoper(x)
                    and h12.bcsbop= ln_bcsbop(x)
                    and h12.bcfech= PD_FECHA;
               Exception When Others Then
                   ln_imppcv := null;
                   ln_imppcc := null;
                   ln_imppcs := null;
               End; 
               ln_impprv := nvl(ln_impprv,0) + nvl(ln_imppcv,0);
               ln_impprc := nvl(ln_impprc,0) + nvl(ln_imppcc,0);
               ln_impprs := nvl(ln_impprs,0) + nvl(ln_imppcs,0);   
           End If;  
           -- Actualiza Datos
           lv_scrip := 'Update catdeu Set catres=:1, impprv=:2, impprc=:3, impprs=:4 '||
                       'Where bcfech=:5 and bcemp=:6 and bcsuc=:7 and bcmda=:8 and bcpap=:9 and bcmod=:1' ||
                         'and bccta=:10 and bcoper=:11 and bcsbop=:12 and bctop=:13';
           execute immediate lv_scrip using ln_catres,ln_impprv,ln_impprc,ln_impprs,
                                            ld_bcfech(x),ln_bcemp(x),ln_bcsuc(x),ln_bcmda(x),ln_bcpap(x),ln_bcmod(x),
                                            ln_bccta(x),ln_bcoper(x),ln_bcsbop(x),ln_bctop(x);
           commit;
           End Loop;
           Exit When c_cursor%Notfound;
       End Loop;
       Close c_cursor;

  End sp_catprv_bantotal;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_linea_no_utilizada(PD_FECHA in date)
  Is
    lv_scrip varchar2(2000);
    ln_exist number(1);

    Type tp_lindis is Ref Cursor;
    c_lindis tp_lindis;

    Type tp_bcfech is table of fsh012.bcfech%type;
    Type tp_bcemp  is table of fsh012.bcemp%type;
    Type tp_bcsuc  is table of fsh012.bcsuc%type;
    Type tp_bcmda  is table of fsh012.bcmda%type;
    Type tp_bcpap  is table of fsh012.bcpap%type;
    Type tp_bcmod  is table of fsh012.bcmod%type;
    Type tp_bccta  is table of fsh012.bccta%type;
    Type tp_bcoper is table of fsh012.bcoper%type;
    Type tp_bcsbop is table of fsh012.bcsbop%type;
    Type tp_bctop  is table of fsh012.bctop%type;
    Type tp_dislin is table of number index by pls_integer;
    Type tp_rubdis is table of fsh012.bcrubr%type;

    ld_bcfech tp_bcfech;
    ln_bcemp  tp_bcemp ;
    ln_bcsuc  tp_bcsuc ;
    ln_bcmda  tp_bcmda ;
    ln_bcpap  tp_bcpap ;
    ln_bcmod  tp_bcmod ;
    ln_bccta  tp_bccta ;
    ln_bcoper tp_bcoper;
    ln_bcsbop tp_bcsbop;
    ln_bctop  tp_bctop ;
    ln_lindis tp_dislin;
    ln_rubdis tp_rubdis;
    ln_disln  fsh012.bcsdmn%type;
    ln_rubro  fsh012.bcrubr%type;
    
  Begin
       select count(*) into ln_exist from user_tab_columns where table_name='CATDEU' and column_name='LINDIS';
       If ln_exist = 0 Then
          lv_scrip:='Alter table catdeu add lindis number(12,2)';
          execute immediate lv_scrip;
       End If;
       
       select count(*) into ln_exist from user_tab_columns where table_name='CATDEU' and column_name='RUBDIS';
       If ln_exist = 0 Then
          lv_scrip:='Alter table catdeu add rubdis number(13)';
          execute immediate lv_scrip;
       End If;
       
       lv_scrip := 'Select c.bcfech, c.bcemp,c.bcsuc,c.bcmda,c.bcpap,c.bcmod,c.bccta,c.bcoper,'||
                     'c.bcsbop,c.bctop,r.rrrubr,-sum(h.bcsdmn) '||
                     'From catdeu c join fsr014 r on r.rubro = c.rubro '||
                                                'and r.rrcod = 18 '||
                                    'join fsh012 h on h.bcemp = c.bcemp '||
                                                 'and h.bcsuc = c.bcsuc '||
                                                 'and h.bcrubr= r.rrrubr '||
                                                 'and h.bcmda = c.bcmda '||
                                                 'and h.bcpap = c.bcpap '||
                                                 'and h.bccta = c.bccta '||
                                                 'and h.bcoper= c.bcoper '||
                                                 'and h.bcfech= c.bcfech '||
                    'Where estcre = ''LIN'' '||
                    'and c.bcfech = :1 '||
                    'Group By c.bcfech, c.bcemp,c.bcsuc,c.bcmda,c.bcpap,c.bcmod,c.bccta,c.bcoper,c.bcsbop,c.bctop,r.rrrubr';
        Open c_lindis For lv_scrip using PD_FECHA;
        Loop
            Fetch c_lindis bulk collect Into ld_bcfech,ln_bcemp,ln_bcsuc,ln_bcmda,ln_bcpap,ln_bcmod,ln_bccta,ln_bcoper,
                                             ln_bcsbop,ln_bctop,ln_rubdis,ln_lindis limit 1000;
            
            For x in ln_bcemp.first .. ln_bcemp.last Loop
            lv_scrip := 'Update catdeu Set lindis=:1,rubdis=:2,saldomn=-saldomn,saldo=-saldo '||
                        'Where bcfech=:2 and bcemp=:3 and bcsuc=:4 and bcmda=:5 and bcpap=:6 and bcmod=:7 '||
                          'and bccta=:8 and bcoper=:9 and bcsbop=:10 and bctop=:11';
            execute immediate lv_scrip using ln_lindis(x),ln_rubdis(x),ld_bcfech(x),ln_bcemp(x),ln_bcsuc(x),ln_bcmda(x),ln_bcpap(x),
                                             ln_bcmod(x),ln_bccta(x),ln_bcoper(x),ln_bcsbop(x),ln_bctop(x);
            commit;
            End Loop;
            EXIT WHEN c_lindis%notfound;
        End Loop;
        Close c_lindis;

        -- Lineas con contra cuenta incorrecta
        lv_scrip := 'Select c.bcfech, c.bcemp,c.bcsuc,c.bcmda,c.bcpap,c.bcmod,c.bccta,c.bcoper,'||
                     'c.bcsbop,c.bctop '||
                     'From catdeu c '||
                    'Where c.estcre = ''LIN'' and c.rubdis is null and c.bcfech=:1';
        Open c_lindis For lv_scrip using PD_FECHA;
        Loop
            Fetch c_lindis bulk collect Into ld_bcfech,ln_bcemp,ln_bcsuc,ln_bcmda,ln_bcpap,ln_bcmod,ln_bccta,ln_bcoper,
                                             ln_bcsbop,ln_bctop limit 1000;
            
            For x in ln_bcemp.first .. ln_bcemp.last Loop
            Begin
                 Select h.bcrubr,-h.bcsdmn Into ln_rubro,ln_disln
                   From fsh012 h
                  Where h.bcemp = ln_bcemp(x)
                    and h.bcsuc = ln_bcsuc(x)
                    and h.bcmda = ln_bcmda(x)
                    and h.bcpap = ln_bcpap(x)
                    and h.bccta = ln_bccta(x)
                    and h.bcoper= ln_bcoper(x)
                    and h.bcfech= ld_bcfech(x)
                    and h.bcmod = 442; 
            Exception When Others Then
              ln_rubro := null;
              ln_disln := null;        
            End;   
            
            lv_scrip := 'Update catdeu Set lindis=:1,rubdis=:2,saldomn=-saldomn,saldo=-saldo '||
                        'Where bcfech=:2 and bcemp=:3 and bcsuc=:4 and bcmda=:5 and bcpap=:6 and bcmod=:7 '||
                          'and bccta=:8 and bcoper=:9 and bcsbop=:10 and bctop=:11';
            execute immediate lv_scrip using ln_disln,ln_rubro,ld_bcfech(x),ln_bcemp(x),ln_bcsuc(x),ln_bcmda(x),ln_bcpap(x),
                                             ln_bcmod(x),ln_bccta(x),ln_bcoper(x),ln_bcsbop(x),ln_bctop(x);
            commit;
            End Loop; 
            Exit When c_lindis%notfound;
        End Loop;
        Close c_lindis;    
        /*For x IN ln_bcemp.FIRST .. ln_bcemp.LAST Loop

        End Loop; */
  End sp_linea_no_utilizada;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_porcentaje_provision(PN_CATEGO in number,
                                   PN_TIPCRE in number) 
  Return Number
  Is
    ln_porprv number(7,2);
  Begin
             If PN_CATEGO = 0 Then  --Provision Genérica
                  Case PN_TIPCRE
                       When  4 Then ln_porprv:=0.7;  --Hipotecario
                       When  3 Then ln_porprv:=1;    --Consumo
                       When  2 Then ln_porprv:=1;    --Microempresa
                       When 13 Then ln_porprv:=1;    --Pequeña Empresa
                       When 12 Then ln_porprv:=1;    --Mediana Empresa
                       When 11 Then ln_porprv:=0.7;  --Grande Empresa
                       Else ln_porprv:=0.7;          --Corporativo
                   End Case;
             Else  --Tabla 1
                  Case Nvl(PN_CATEGO,0)
                       When  0 Then ln_porprv:=0;     --CPP
                       When  1 Then ln_porprv:=5;     --CPP
                       When  2 Then ln_porprv:=25;    --Deficiente
                       When  3 Then ln_porprv:=60;    --Dudoso
                       When  4 Then ln_porprv:=100;   --Pérdida
                  End Case;
             End If;
      return ln_porprv;       
  End fn_porcentaje_provision;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end pq_categoria_provision;
/

