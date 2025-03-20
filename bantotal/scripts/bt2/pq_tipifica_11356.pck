create or replace package pq_tipifica_11356 is

  -- Author  : PVARGAS
  -- Created : 02/11/2015 13:47:53
  -- Purpose : Tipificacion cartera de créditos (Res. SBS N| 11356)
  
  -- Public type declarations
  /*type <TypeName> is <;>;
  
  -- Public constant declarations
  <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  <VariableName> <Datatype>;

  -- Public function and procedure declarations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;*/
  Procedure sp_datos_desembolso(PD_FECDES in date);
  Procedure sp_base_juridica_hipotec (P_FECRCC in date);
  Procedure sp_crea_base (pd_feccie in date);
  Procedure sp_actualiza_modulo(PN_TIPCAM in number);
  Procedure sp_cli_recurrentenuevo(PD_FECDES in date, pd_feccie in date);
  Procedure sp_tipifica_base ( pd_fecrcc in date);
  Procedure sp_instancia_segmento;
  Procedure sp_tipificacion_mensual(PD_FECDES in date);
  Procedure sp_reclasificacion;
  
end pq_tipifica_11356;
/

create or replace package body pq_tipifica_11356 is

  /*-- Private type declarations
  type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  <ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  <VariableName> <Datatype>;

  -- Function and procedure implementations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    <LocalVariable> <Datatype>;
  begin
    <Statement>;
    return(<Result>);
  end;*/

--begin
  Procedure sp_datos_desembolso(PD_FECDES in date)
  -- Nro de Instancia, tipo cliente, segmento
  Is
    cursor c_desem (Fecdes in  date)
        is select bcemp,bcsuc,bcmod,bcpap, bcmda,bccta,bcoper,bcsbop,bctop,bcctao,bcopero,bcmodo,bctopo,bcsbopo,
                  pepais, petdoc, pendoc, petipo,
                  case when bcmodo = 116 then deslin else bcfval end bcfval
             from tipcre
            where deslin >= Fecdes
              and bcmodo <> 117;
              
    ld_fecdes date := PD_FECDES;
    ln_numins number(9);    
    ln_segsol number(2);
    ln_clisol number(2);
    ln_nrocre number(5);
    ln_tipcre number(2);
    lv_destcr varchar2(25); 
    ln_sector number(1); 
    ln_pgcod  number(3);
   ln_aomod  number(3);
   ln_aomda  number(4);
   ln_aopap  number(3);
   ln_aocta  number(9);
   ln_aooper number(9);
   ln_aosbop number(3);
   ln_aotope number(3);
   ln_aostat number(3);
   ld_aofe99 date;
   ld_fechis date;
   ln_creant number(2);
   
      
 Begin
      For x in c_desem(ld_fecdes) Loop
        ln_numins := null;
        ln_segsol:= null;
        ln_clisol:= null;
        ln_nrocre := null;
        ln_tipcre := null;
        lv_destcr := null;
        ln_sector := null;
        ln_pgcod  := null;
         ln_aomod  := null;
         ln_aomda  := null;
         ln_aopap  := null;
         ln_aocta  := null;
         ln_aooper := null;
         ln_aosbop := null;
         ln_aotope := null;
         ln_aostat := null;
         ld_aofe99 := null;
         ld_fechis := null;
         ln_creant := null;     
        
        If x.bcmodo = 108 Then -- Es Pignoraticio
           ln_tipcre := 3;
           lv_destcr := 'CONSUMO NO REVOLVENTE';
        Else   
              
                 If (x.bcmod in (116,200) or  x.bctop <> 550) Then 
                     --Buscar datos para instancia
                    Begin 
                        Select x700.xwfprcins Into ln_numins
                          From xwf700 x700
                         Where x700.xwfempresa  = x.bcemp
                           and x700.xwfmodulo   = x.bcmodo
                           and x700.xwfmoneda   = x.bcmda
                           and x700.xwfpapel    = x.bcpap
                           and x700.xwfcuenta   = x.bccta
                           and x700.xwfoperacion= x.bcopero
                           and x700.xwfsubope   = x.bcsbopo
                           and x700.xwftipope   = x.bctopo
                           and x700.xwfcar3     = '1';
                     Exception When Others Then
                       Select max(x700.xwfprcins) Into ln_numins
                          From xwf700 x700
                         Where x700.xwfempresa  = x.bcemp
                           and x700.xwfmodulo   = x.bcmodo
                           and x700.xwfmoneda   = x.bcmda
                           and x700.xwfpapel    = x.bcpap
                           and x700.xwfcuenta   = x.bccta
                           and x700.xwfoperacion= x.bcopero
                           and x700.xwfsubope   = x.bcsbopo
                           and x700.xwftipope   = x.bctopo;
                    End;           
                Else
                      --Begin
                      Begin
                          Select x700.xwfprcins Into ln_numins
                            from xwf700 x700
                           where x700.xwfempresa  = x.bcemp
                             and x700.xwfmodulo   = x.bcmod
                             and x700.xwfmoneda   = x.bcmda
                             and x700.xwfpapel    = x.bcpap
                             and x700.xwfcuenta   = x.bccta
                             and x700.xwfoperacion= x.bcoper
                             and x700.xwfsubope   = x.bcsbop
                             and x700.xwftipope   = x.bctop
                             and x700.xwfcar3     = '1';
                     Exception When too_many_rows Then
                                    Select max(x700.xwfprcins) Into ln_numins
                                      from xwf700 x700
                                     where x700.xwfempresa  = x.bcemp
                                       and x700.xwfmodulo   = x.bcmod
                                       and x700.xwfmoneda   = x.bcmda
                                       and x700.xwfpapel    = x.bcpap
                                       and x700.xwfcuenta   = x.bccta
                                       and x700.xwfoperacion= x.bcoper
                                       and x700.xwfsubope   = x.bcsbop
                                       and x700.xwftipope   = x.bctop
                                       and x700.xwfcar3     = '1';
                               When Others Then
                                    ln_numins := null; 
                     End;                       

                  End IF;
 
              --Segmento y tipo cliente de solicitud
              If ln_numins is not null Then
                 Begin
                       Select sng001seg, sng001tpcr
                         Into ln_segsol, ln_clisol
                         From sng001
                        Where sng001inst = ln_numins; 
                 Exception When Others Then
                   ln_segsol := null; 
                   ln_clisol := null;
                 End;   
                 -- Tipo de crédito y sector
                 Begin
                     select to_number(substr(wfattsval,1,instr(wfattsval,';')-1)),
                            trim(substr(wfattsval,instr(wfattsval,';')+1)) 
                       into ln_tipcre, lv_destcr      
                      from wfattsvalues where wfinsprcid = ln_numins
                       and trim(wfattsid) = 'TIPO_CREDITO'; 
                 Exception When Others Then
                           ln_tipcre := null;
                           lv_destcr := null;
                 End;
                 
                 If ln_tipcre = 13 Then  
                    Begin               
                       select to_number(trim(wfattsval)) 
                         into ln_sector      
                        from wfattsvalues where wfinsprcid = ln_numins
                         and trim(wfattsid) = 'SECTOR'; 
                    Exception When Others Then
                        ln_sector := null;
                    End;     
                 End If;
              End If;
           --End If;
           -- Tipo de Cliente Calculado
           select count(aooper)into ln_nrocre
             from (
                   select d10.aooper
                     from fsr008 r08 join fsd010 d10 on d10.pgcod = r08.pgcod
                                                    and d10.aocta = r08.ctnro
                    where r08.pgcod = x.bcemp
                      and r08.pepais = x.pepais
                      and r08.petdoc = x.petdoc
                      and r08.pendoc = x.pendoc
                      and r08.ttcod  = 1
                      and r08.cttfir = 'T'
                      and d10.aomod in (select modulo 
                                          from fst111 where dscod = 50 and modulo not in (29,120)
                                               union all
                                        select 117 from dual 
                                               union all
                                        select 141 from dual             
                                       )
                      and d10.aofval < x.bcfval
                          UNION ALL 
                   select d10.aooper
                     from fsr008 r08 join fsd010 d10 on d10.pgcod = r08.pgcod
                                                    and d10.aocta = r08.ctnro
                    where r08.pgcod = x.bcemp
                      and r08.pepais = x.pepais
                      and r08.petdoc = x.petdoc
                      and r08.pendoc = x.pendoc
                      and r08.ttcod  = 1
                      and r08.cttfir = 'T'
                      and d10.aomod in (select modulo 
                                          from fst111 where dscod = 50 and modulo not in (29,120)
                                               union all
                                        select 117 from dual 
                                               union all
                                        select 141 from dual             
                                       )
                      and d10.aofval = x.bcfval 
                      and d10.aooper < x.bcopero
                  );
               
          --- Tipo de Crédito y Segmento Anterior
          /*Begin
                Select pgcod,aomod,aomda,aopap,aocta,aooper,aosbop,aotope,aostat,aofe99
                  Into ln_pgcod,ln_aomod,ln_aomda,ln_aopap,ln_aocta,ln_aooper,ln_aosbop,ln_aotope,ln_aostat,ld_aofe99
                  From (
                        Select d10.pgcod,d10.aomod,d10.aomda,d10.aopap,d10.aocta,d10.aooper,d10.aosbop,d10.aotope,
                               d10.aostat,d10.aofe99
                          From fsr008 r08 join fsd010 d10 on d10.pgcod = r08.pgcod
                                                         and d10.aocta = r08.ctnro
                                                          
                         Where r08.pepais = x.pepais
                           and r08.petdoc = x.petdoc
                           and r08.pendoc = x.pendoc 
                           and r08.ttcod  = 1
                           and r08.cttfir = 'T'
                           and d10.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120)
                                             union all
                                             select 117 from dual
                                             union all
                                             select 141 from dual
                                            ) 
                           and (d10.aostat <> 99 or (d10.aostat=99 and d10.aofe99=x.bcfval))
                           and d10.aofval <= x.bcfval
                           and not (d10.pgcod = x.bcemp and
                                    d10.aomod = x.bcmodo and
                                    d10.aomda = x.bcmda and
                                    d10.aopap = x.bcpap and
                                    d10.aocta = x.bccta and
                                    d10.aooper= x.bcopero and
                                    d10.aosbop= x.bcsbopo and
                                    d10.aotope= x.bctopo 
                                   )       
                           and d10.aooper < x.bcopero
                           Order by d10.aofval desc
                          ) Where rownum=1;
                   
                   Begin
                       If ln_aostat <> 99 Then
                          Select bcgpo Into ln_creant
                            From tipcre
                           Where bcemp = x.bcemp 
                             and bcpap = x.bcpap 
                             and bcmda = x.bcmda 
                             and bcmod = x.bcmod 
                             and bccta = x.bccta 
                             and bcoper= x.bcoper
                             and bcsbop= x.bcsbop 
                             and bctop = x.bctop;
                       Else
                           -- Buscar en FSH012
                           ld_fechis := ld_aofe99 - 1;
                           Select h12.bcgpo
                             into ln_creant
                             from fsh012 h12
                            where h12.bcemp = ln_pgcod
                              and h12.bcmda = ln_aomda
                              and h12.bcpap = ln_aopap
                              and h12.bccta = ln_aocta
                              and h12.bcoper= ln_aooper
                              and h12.bcsbop= ln_aosbop
                              and h12.bctop = ln_aotope
                              and h12.bcfech= ld_fechis
                              and h12.bcmod = ln_aomod
                              and rownum = 1; 
                       End If;   
                   Exception When Others Then
                       ln_creant := null;
                   End;           
                Exception When Others Then
                   ln_creant := null;
                End;    */
          End If;    
          
          If ln_tipcre = 2    Then lv_destcr := 'MICROEMPRESA';
          Elsif ln_tipcre = 3  Then
              If x.bcmod = 116 Then lv_destcr := 'CONSUMO REVOLVENTE';
              Else ln_tipcre := 31; lv_destcr := 'CONSUMO NO REVOLVENTE';
              End If;
          Elsif ln_tipcre = 9  Then lv_destcr := 'CORPORATIVO-SIS.FIN.';
          Elsif ln_tipcre = 10 Then lv_destcr := 'CORPORATIVO';
          Elsif ln_tipcre = 11 Then lv_destcr := 'GRANDE EMPRESA';
          Elsif ln_tipcre = 12 Then lv_destcr := 'MEDIANA EMPRESA';
          Elsif ln_tipcre = 13 Then lv_destcr := 'PEQUEÑA EMPRESA';
          Elsif ln_tipcre = 4  Then lv_destcr := 'HIPOTECARIO';
          End If;
          
          If x.petipo = 'J' Then
             ln_segsol := 1; 
          End If;                      
          --- Actualiza Campos
          Update tipcre set numins=ln_numins, segcli=ln_segsol, sng001tpcr=ln_clisol,
                            cnuevo = (case when ln_nrocre>0 then 'N' else 'S' end),
                            tcrdes =ln_tipcre, tdcrde=upper(lv_destcr), dessec=ln_sector/*,
                            creant = ln_creant*/
           where bcemp = x.bcemp 
             and bcsuc = x.bcsuc 
             and bcpap = x.bcpap 
             and bcmda = x.bcmda 
             and bccta = x.bccta 
             and bcoper= x.bcoper
             and bcsbop= x.bcsbop
             and bctop = x.bctop
             and bcmod = x.bcmod;
         commit;    
   End loop;
  End sp_datos_desembolso;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_base_juridica_hipotec (P_FECRCC in date) --Fecha RCC
  Is
   Cursor c_pers
       is select pepais, petdoc, pendoc,petipo,
                 bcemp,bcsuc,bcpap,bcmda,bccta,bcoper,bcsbop,bctop,bcmod,bcsdmn saldomn,
                 bcmodo, bctopo,bcsbopo,bcopero,numins, nvl(fin.codfin,'P') codfin,
                 Case when bcmod = 116 then deslin else bcfval end bcfval, bcfech 
            from tipcre cred left join profin fin on fin.modulo = cred.bcmodo
                                                 and fin.tipope = cred.bctopo   
           where cred.bcmod <> 117
             and (cred.petipo ='J'
                  or (cred.petipo ='F' and nvl(fin.codfin,'P') in ('HC','HP'))
                 );

   Cursor c_deud (lv_sbs in varchar2, ld_fec in date)
       is select d_fecpre,
                 sum(case when substr(c_cuenta,1,1) not like '2%' then n_salcap else 0 end) n_salcap,
                 sum(case when substr(c_cuenta,1,1) like '2%' then n_salcap else 0 end) n_salint
            from cldrccs
           where c_codsbs = lv_sbs and d_fecpre = ld_fec
             and (substr(c_cuenta,1,4) in ('1411','1413','1414','1415','1416',
                                           '1421','1423','1424','1425','1426',
                                           '7111','7112','7113','7114',
                                           '7121','7122','7123','7124'
                                          )
                  or
                  substr(c_cuenta,1,6) in ('291101','292101','291102','292102') -- Ing.interes y comisiones
                 )
             and c_cretip <> '13' --Eliminar creditos hipotecarios
           Group By c_codsbs,d_fecpre;


  Cursor c_venta (n_numeva in number, n_tipcam in number)
      is  select decode(g023.sng026cod,538,38,539,39,g023.sng026cod) Codigo,
                  sum(case when g023.sng026cod=538 then g023.sng023mto*n_tipcam
                       when g023.sng026cod=38 then g023.sng023mto
                       when g023.sng026cod=539 then g023.sng023mto*n_tipcam
                       when g023.sng026cod=39 then g023.sng023mto
                       else 0
                      end) Monto
             from sng023 g023
            where g023.sng021eval = n_numeva
              and g023.sng026cod in (39,539,38,538)
            Group By decode(g023.sng026cod,538,38,539,39,g023.sng026cod);

       lv_codsbs varchar2(10);
       lv_numdoc varchar2(15);
       ld_fecrcc date := P_FECRCC;
       ln_hisrcc number(2);
       ld_minrcc date := add_months(ld_fecrcc,-5);
       ln_deu1 number(12,2);
       ln_deu2 number(12,2);
       ln_deu3 number(12,2);
       ln_deu4 number(12,2);
       ln_deu5 number(12,2);
       ln_deu6 number(12,2);
       ln_deud1 number(12,2);
       ln_deud2 number(12,2);
       ln_deud3 number(12,2);
       ln_deud4 number(12,2);
       ln_deud5 number(12,2);
       ln_deud6 number(12,2);
       ln_numhip number(5);
       ln_acttip number(1);
       ln_insfin number(1);
       ln_tipcor number(1);
       ln_venan1 number(12,2);
       ln_venan2 number(12,2);
       ln_numins number(10);
       ln_numeva number(10);
       ln_tipcam number(7,4);
       ld_rccdes date;
       ld_mindes date;
       lv_garhip varchar2(1);
       ln_bcmod number(3);
       ln_bctop number(3);
       lv_codfin varchar2(2);
       lv_tipdoc varchar2(1);
       ln_salpym number(12,2);
       lv_deupym varchar2(1);
       lv_pymdes varchar2(1);
       ld_fecha  date;
       lv_hisdes varchar2(1);
Begin
  -- Abrir Cursor
  For x in c_pers Loop
    lv_garhip := null;
    ln_acttip := 0;
    ln_bcmod  := x.bcmod;
    ln_bctop  := x.bctop;
    lv_numdoc := trim(x.pendoc);
    lv_codsbs := null;
    ln_hisrcc := 0;
    ln_deu1   := 0; ln_deu2 := 0; ln_deu3 := 0;
    ln_deu4   := 0; ln_deu5 := 0; ln_deu6 := 0;
    ln_deud1   := 0; ln_deud2 := 0; ln_deud3 := 0;
    ln_deud4   := 0; ln_deud5 := 0; ln_deud6 := 0;
    ln_numhip := 0;
    ln_insfin := 0;
    ln_numins := x.numins;
    ln_tipcam := null;
    ln_numeva := null;
    ln_venan1 := null;
    ln_venan2 := null;
    lv_tipdoc := null;
    ln_salpym := 0;
    lv_deupym := 'N';
    lv_pymdes := 'N';
    ln_tipcor := 0;
    lv_hisdes := null;
    lv_codfin := x.codfin;

    If x.petipo = 'F' and lv_codfin in ('HP','HC') then
       -- Revisar si existe garantia hipotecario
       Select count(*) Into ln_numhip
         From fsr011 r11
        where r11.r1cod = x.bcemp
          and r11.r1suc = x.bcsuc 
          and r11.r1mod = x.bcmod
          and r11.r1mda = x.bcmda
          and r11.r1pap = x.bcpap
          and r11.r1cta = x.bccta
          and r11.r1oper= x.bcoper
          and r11.r1sbop= x.bcsbop
          and r11.r1tope= x.bctop
          and r11.relcod= 50
          and r11.r2mod = 70
          and r11.r2tope in (10,15)
          and r11.r011co= 'S';
       If ln_numhip > 0 Then
          lv_garhip := 'S';
        End If;
    End If;

    If x.petipo = 'J' Then
        -- Es institución financiera
        Select count(*) into ln_insfin
          From fsd004
         where ifpais = x.pepais
           and iftdoc = x.petdoc
           and ifndoc = x.pendoc;
        If ln_insfin = 0 Then
           -- Tipo cliente credito corporativo
           Begin
           Select g11.sngc11cmb2 into ln_tipcor
             From sngc11 g11
            Where g11.sngc11pais = x.pepais
              and g11.sngc11tdoc = x.petdoc
              and g11.sngc11ndoc = x.pendoc;
           Exception When Others Then ln_tipcor := null;
           End;
        Else
            ln_tipcor := 4;
        End If;
        
        If nvl(ln_tipcor,0) in (0,6) Then
           -- Nivel de Ventas
           -- Obtiene Instancia
           Begin
             If ln_numins is null Then
                 If (x.bcmod in (116,200) or  x.bctop <> 550) Then --Buscar datos para instancia
                     --Begin
                        Select x700.xwfprcins Into ln_numins
                          From xwf700 x700
                         Where x700.xwfempresa  = x.bcemp
                           and x700.xwfmodulo   = x.bcmodo
                           and x700.xwfmoneda   = x.bcmda
                           and x700.xwfpapel    = x.bcpap
                           and x700.xwfcuenta   = x.bccta
                           and x700.xwfoperacion= x.bcopero
                           and x700.xwfsubope   = x.bcsbopo
                           and x700.xwftipope   = x.bctopo
                           and x700.xwfcar3     = '1';
           
                  Else
                      --Begin
                          Select x700.xwfprcins Into ln_numins
                            from xwf700 x700
                           where x700.xwfempresa  = x.bcemp
                             and x700.xwfmodulo   = x.bcmod
                             and x700.xwfmoneda   = x.bcmda
                             and x700.xwfpapel    = x.bcpap
                             and x700.xwfcuenta   = x.bccta
                             and x700.xwfoperacion= x.bcoper
                             and x700.xwfsubope   = x.bcsbop
                             and x700.xwftipope   = x.bctop
                             and x700.xwfcar3     = '1';
               End IF;
              End If;
                 -- Tipo de cambio
                 Begin
                      select sng120tcbi Into ln_tipcam
                        from sng120 g120
                       where g120.sng120ins = ln_numins
                         and g120.sng120tsk = 'EVALUACION';
                 Exception When Others Then
                     ln_tipcam := 0;
                 End;

                 -- Nro. de Evaluación
                 Begin
                    select g021.sng021eval into ln_numeva
                      from sng021 g021
                     where g021.sng021sol = ln_numins;
                 Exception when others then
                     ln_numeva := null;
                 End;
                 --dbms_output.put_line('Evaluación:'||to_char(ln_numeva));
                 For v in c_venta (ln_numeva,ln_tipcam) Loop
                     If v.codigo = 38 then ln_venan1 := v.monto; end If;
                     If v.codigo = 39 then ln_venan2 := v.monto; end If;
                 End Loop;

            Exception When Others Then
                       ln_numins := null;
            End;
        End If;
     End If;

     -- Actualiza endeudamiento Sist.Financ.
     -- Busca CodSbs
     If x.petipo = 'F' and x.bcmod <> 108 and nvl(lv_garhip,'N') <> 'S' Then
          If x.petdoc = 21 Then
             lv_tipdoc := '1';
          Elsif x.petdoc = 2 Then
                lv_tipdoc := '2';
          Elsif x.petdoc = 5 Then
                lv_tipdoc := '5';
          End If;
           ---modifica hasta encontrar historial
           ld_fecha := ld_fecrcc;
           Loop
               Begin
                 Select c_codsbs into lv_codsbs
                   From cldrcci
                  Where c_tdocid=lv_tipdoc and c_docide = lv_numdoc
                    and d_fecpre = ld_fecha;
                 If lv_codsbs is not null Then
                    ln_hisrcc := 1;
                    ld_fecha  := last_day(add_months(ld_minrcc,-1));
                    Exit;
                 End If;
               Exception when others then
                         ln_hisrcc := 0;
                         lv_codsbs := null;
                         ld_fecha  := last_day(add_months(ld_fecha,-1));
               End;
           Exit When ld_fecha < ld_minrcc;
           End Loop;

       ElsIf x.petipo <> 'F' Then
           ld_fecha := ld_fecrcc;
           Loop
               Begin
                 Select c_codsbs into lv_codsbs
                   From cldrcci
                  Where c_doctri=lv_numdoc
                    and d_fecpre = ld_fecha;
                 If lv_codsbs is not null Then
                    ln_hisrcc := 1;
                    ld_fecha  := last_day(add_months(ld_minrcc,-1));
                    Exit;
                 End If;
               Exception when others then
                         ln_hisrcc := 0;
                         lv_codsbs := null;
                         ld_fecha  := last_day(add_months(ld_fecha,-1));
               End;
           Exit When ld_fecha < ld_minrcc;
           End Loop;

       End If;

       If lv_codsbs is not null Then
          ld_fecha := ld_minrcc;
          Loop
              For z in c_deud(lv_codsbs,ld_fecha) Loop
                  If z.d_fecpre = ld_minrcc Then ln_deu1 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                  Elsif z.d_fecpre = last_day(add_months(ld_minrcc,1)) Then ln_deu2 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                  Elsif z.d_fecpre = last_day(add_months(ld_minrcc,2)) Then ln_deu3 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                  Elsif z.d_fecpre = last_day(add_months(ld_minrcc,3)) Then ln_deu4 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                  Elsif z.d_fecpre = last_day(add_months(ld_minrcc,4)) Then ln_deu5 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                  Elsif z.d_fecpre = ld_fecrcc Then ln_deu6 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                  End If;
              End Loop;
              ld_Fecha := add_months(ld_fecha,1);
          Exit When ld_fecha > ld_fecrcc;
          End Loop;
          
          If nvl(ln_deu1,0)+nvl(ln_deu2,0)+nvl(ln_deu3,0)+nvl(ln_deu4,0)+nvl(ln_deu5,0)+
             nvl(ln_deu6,0)> 0
            Then ln_hisrcc := 1;
          Else ln_hisrcc := 0;
          End If;  

          If lv_codfin in ('C','HC') Then
              --Revisa si Consumo tiene deuda Pyme
              ld_fecha  := ld_fecrcc;
              lv_deupym := 'N';
              
              --Loop
                  Select sum(n_salcap) into ln_salpym
                    from cldrccs
                   where c_codsbs = lv_codsbs
                     and d_fecpre = ld_fecha
                     and substr(c_cuenta,1,4) in ('1411','1413','1414','1415','1416',
                                                  '1421','1423','1424','1425','1426',
                                                  '7111','7112','7113','7114',
                                                  '7121','7122','7123','7124'
                                                  )
                     and c_cretip in ('09','10'); --Eliminar creditos hipotecarios

                  If ln_salpym > 0 Then
                     lv_deupym := 'S';
                     /*ld_fecha  := last_day(add_months(ld_minrcc,-1));
                  Else
                     ld_fecha  := last_day(add_months(ld_fecha,-1));*/
                  End If;
              --Exit When ld_fecha < ld_minrcc;
              --End Loop;
          Else
              lv_deupym := 'S';
          End If;

          --- Endeudamiento al momento del desembolso desde 01/Jul/2013
          --- Antes del 25 2 meses aneriores, depués 1 mes anterior
          --If x.bcfval >= ld_fecmig Then
          If to_char(x.bcfval,'MM') = to_char(x.bcfech,'MM')  Then
             If to_number(to_char(x.bcfval,'DD')) > 25 Then
                ld_rccdes := last_day(add_months(x.bcfval,-1));
             Else
                ld_rccdes := last_day(add_months(x.bcfval,-2));
             End If;
             
             ld_mindes := add_months(ld_rccdes,-5);

              ld_fecha := ld_mindes;
              Loop
                  For z in c_deud(lv_codsbs,ld_fecha) Loop
                     If z.d_fecpre = ld_mindes Then ln_deud1 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                     Elsif z.d_fecpre = last_day(add_months(ld_mindes,1)) Then ln_deud2 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                     Elsif z.d_fecpre = last_day(add_months(ld_mindes,2)) Then ln_deud3 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                     Elsif z.d_fecpre = last_day(add_months(ld_mindes,3)) Then ln_deud4 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                     Elsif z.d_fecpre = last_day(add_months(ld_mindes,4)) Then ln_deud5 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                     Elsif z.d_fecpre = ld_rccdes Then ln_deud6 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                     End If;
                  End Loop;
                  ld_Fecha := add_months(ld_fecha,1);
              Exit When ld_fecha > ld_rccdes;
              End Loop;

              If nvl(ln_deud1,0)+nvl(ln_deud2,0)+nvl(ln_deud3,0)+nvl(ln_deud4,0)+nvl(ln_deud5,0)+
                 nvl(ln_deud6,0)> 0
                Then lv_hisdes := 'S';
              Else lv_hisdes := 'N';
              End If; 
            
             If lv_codfin in ('C','HC') Then
               
                ln_salpym := 0;
                 --Revisa si Consumo tiene deuda Pyme
                  ld_fecha  := ld_rccdes;
                  lv_pymdes := 'N';
                  --Loop
                      Select sum(n_salcap) into ln_salpym
                        from cldrccs
                       where c_codsbs = lv_codsbs
                         and d_fecpre = ld_fecha
                         and substr(c_cuenta,1,4) in ('1411','1413','1414','1415','1416',
                                                      '1421','1423','1424','1425','1426',
                                                      '7111','7112','7113','7114',
                                                      '7121','7122','7123','7124'
                                                      )
                         and c_cretip in ('09','10'); --Eliminar creditos hipotecarios

                      If ln_salpym > 0 Then
                         lv_pymdes := 'S';
                      End If;   
                         /*ld_fecha  := last_day(add_months(ld_mindes,-1));
                      Else
                         ld_fecha  := last_day(add_months(ld_fecha,-1));
                      End If;*/
                  --Exit When ld_fecha < ld_mindes;
                  --End Loop;

              Else
                  lv_pymdes := 'S';
              End If;

          End If;
       End If;
        
          Update tipcre set deumes1=ln_deu1,deumes2=ln_deu2,deumes3=ln_deu3,deumes4=ln_deu4,deumes5=ln_deu5,
                            deumes6=ln_deu6,ultrcc=ld_fecrcc,prircc=ld_minrcc,hisrcc=decode(ln_hisrcc,0,'N','S'),
                            codfin = lv_codfin,codsbs = lv_codsbs,
                            venact = ln_venan1, venant=ln_venan2,numins=ln_numins,deupym=lv_deupym,
                            deudem1=ln_deud1,deudem2=ln_deud2,deudem3=ln_deud3,deudem4=ln_deud4,deudem5=ln_deud5,
                            deudem6=ln_deud6,pymdes=lv_pymdes, garhip=lv_garhip,tipcor = ln_tipcor,
                            insfin = decode(ln_insfin,0,'N','S'),
                            hisdes = lv_hisdes, regact=1
                            
           where bcemp = x.bcemp
             and bcsuc = x.bcsuc
             and bcpap = x.bcpap
             and bcmda = x.bcmda
             and bccta = x.bccta
             and bcoper= x.bcoper
             and bcsbop= x.bcsbop
             and bctop = x.bctop
             and bcmod = x.bcmod;
     --End If;
     Commit;
  End Loop;
End sp_base_juridica_hipotec;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure sp_crea_base (pd_feccie in date)
 Is
   ln_existe number(1)   := 0;
   lv_tabla varchar2(15) := 'TIPCRE';
   lv_scrip varchar2(2000);
 Begin
      --
      -- Elimina Tablade Productos
      --
      lv_scrip:= 'Select count(*) From user_tables Where table_name = ''PROFIN''';
      Execute Immediate lv_scrip into ln_existe;

      If ln_existe > 0 Then
         Begin 
            lv_scrip:= 'drop table PROFIN purge';
            execute immediate lv_scrip;
         Exception When Others Then
             null;
         End;   
      End If;
      
      --
      -- Crea Tabla Maestra de Tipificacion
      --
      lv_scrip:= 'Create Table profin (modulo number(3), tipope number(3),desmod varchar2(100),'||
                 'destop varchar2(100), codfin varchar2(2))'; 
      execute immediate lv_scrip;
      
      lv_scrip := 'insert into profin '||
                  'Select * from( '||
                    'select t03.modulo,t04.totope,upper(trim(t03.mdnom)),upper(trim(t04.tonom)), '||
                           'case when t03.modulo = 107 then ''C'' '||
                                'when t03.modulo = 108 then ''C'' '||
                                'when t03.modulo = 106 and upper(t04.tonom) not like ''%PYM%'' then ''C'' '|| 
                                'when t03.modulo = 110 and upper(t04.tonom) like ''%PYM%'' then ''HP'' '||
                                'when t03.modulo = 110 and upper(t04.tonom) like ''%CAJA%CONSTRU%'' and upper(t04.tonom) NOT like ''%CONSUM%'' '||  
                                     'then ''HP'' '||  
                                'when t03.modulo = 110 and upper(t04.tonom) NOT like ''%PYM%'' then ''HC''  '||
                                'when t03.modulo = 111 then ''HC'' '|| 
                                'when t03.modulo = 112 and (upper(t04.tonom)  like ''%CONS%'' OR upper(t04.tonom) like ''%TRABAJAD%'' '|| 
                                     'OR upper(t04.tonom) like ''%PERSO%'') then ''C''  '||  
                                'when t03.modulo = 115 and upper(t04.tonom) like ''%CONS%'' and upper(t04.tonom) not like ''%CONST%'' then ''C'' '||
                                'when t03.modulo = 116 and (upper(t04.tonom) like ''%DPF%'' or upper(t04.tonom) like ''%CTS%'') then ''C'' '||   
                           'end as codfin '||
                      'from fst003 t03 join fst004 t04 on t04.modulo = t03.modulo '||
                                      'join fst111 t11 on t11.modulo = t03.modulo '||
                    'where t11.dscod = 50 '||
                      'and not (t03.modulo  in (29,33,120,200) '||
                      'or t04.totope = 550) '||
                        'UNION ALL '||  
                    'select t03.modulo,t04.totope,upper(trim(t03.mdnom)),upper(trim(t04.tonom)), '||
                           'null as codpro '|| 
                       'from fst003 t03 join fst004 t04 on t04.modulo = t03.modulo '||
                       'where t03.modulo = 141 '||
                       ')a where not exists (select 1 from profin where modulo = a.modulo and tipope=a.totope)';
     execute immediate lv_scrip;
     commit;

     -- crea indices
     lv_scrip := 'create index ix_profin_1 on profin(modulo,tipope)';
     execute immediate lv_scrip;

      --
      -- Elimina Tabla Maestra de Tipificacion
      --
      lv_scrip:= 'Select count(*) From user_tables Where table_name = '''||upper(lv_tabla)||'''';
      Execute Immediate lv_scrip into ln_existe;

      If ln_existe > 0 Then
         Begin 
            lv_scrip:= 'drop table '||upper(lv_tabla)||' purge';
            execute immediate lv_scrip;
         Exception When Others Then
             null;
         End;   
      End If;
      
      --
      -- Crea Tabla Maestra de Tipificacion
      --
      lv_scrip:= 'Create table TipCre (bcfech date, pepais number(3), petdoc number(2), pendoc char(12),'||
                 'petipo char(1), penom  char(30), bccate char(15), bcemp  number(3), bcsuc  number(3),'||
                 'bcmda  number(4), bcpap  number(4), bcmod  number(3), bccta  number(9), bcoper number(9),'||
                 'bcsbop number(3), bctop  number(3), bcfval date, bcfvto date, bctasa number(10,6), '||
                 'bcsdmn number(17,2), bcsdmo number(17,2),codfin varchar2(2), deupym varchar2(1), '||
                 'garhip varchar2(1),ultrcc date, prircc date,hisrcc varchar2(1), insfin varchar2(1), '|| 
                 'tipcor number(1),venact number(12,2),venant number(12,2),deumes1 number(12,2),'|| 
                 'deumes2 number(12,2),deumes3 number(12,2),deumes4 number(12,2),deumes5 number(12,2),'|| 
                 'deumes6 number(12,2),codsbs  varchar2(10),numins  number(10),bcgpo number(2),'||
                 'tipcre  number(2),destcr  varchar2(25),deudem1 number(12,2),deudem2 number(12,2),'|| 
                 'deudem3 number(12,2),deudem4 number(12,2),deudem5 number(12,2),deudem6 number(12,2),'||
                 'bcmodo  number(3),bctopo  number(3),bcsbopo number(3),pymdes varchar2(1),tipcred number(2),'||
                 'destcrd varchar2(25),bcctao number(9),bcopero number(9),hisdes varchar(1),mtolin number(12,2),'||
                 'deslin date,cnuevo varchar2(1),sector number(1),secdes number(1),tcrdes number(2),'||
                 'tdcrde varchar2(30),segcli number(2),hordes varchar2(10),sng001tpcr number(2),tcrant number(2),'||
                 'secant number(1),ctaant number(9),opeant number(9),sboant number(3),modant number(3),'||
                 'topant number(3), mdaant number(4),dessec number(1),regact number(1),tcdant varchar2(25),'||
                 'actant varchar2(1),recreg varchar2(1))';  
      Execute Immediate lv_scrip;            
      
      --
      -- Inserta Saldos
      -- 

      Insert into tipcre(bcfech,pepais,petdoc,pendoc,petipo,penom,bccate,
                         bcemp,bcsuc,bcmda,bcpap,bcmod,bccta,bcoper,bcsbop,bctop,  
                         bcfval,bcfvto,bctasa,bcgpo,bcsdmn,bcsdmo)  
      Select h12.bcfech,r08.pepais,r08.petdoc,r08.pendoc,d01.petipo,d01.penom, h12.bccate,
             h12.bcemp,h12.bcsuc,h12.bcmda,h12.bcpap,h12.bcmod,h12.bccta,h12.bcoper,h12.bcsbop,h12.bctop, 
             h12.bcfval,h12.bcfvto,h12.bctasa,
             case when bcrubr like '7%' then to_number(substr(bcrubr,7,2)) else h12.bcgpo end bcgpo, 
             -sum(h12.bcsdmn),-sum(bcsdmo) 
        From fsh012 h12 left join fsr008 r08 on r08.ctnro = h12.bccta
                                            and r08.ttcod = 1
                                            and r08.cttfir = 'T' 
                        left join fsd001 d01 on d01.pepais = r08.pepais
                                            and d01.petdoc = r08.petdoc
                                            and d01.pendoc = r08.pendoc                 
       where bcemp = 1
         and bcfech = pd_feccie --to_date('20170630','rrrrmmdd')
         and substr(bcrubr,1,4) in (1411,1414,1415,1416,
                                    1421,1424,1425,1426,7112,7122)
         and bccta <> 999999999
         and bcprod <> 99 
       Group By h12.bcfech,r08.pepais,r08.petdoc,r08.pendoc,d01.petipo,d01.penom, h12.bccate,
             h12.bcemp,h12.bcsuc,h12.bcmda,h12.bcpap,h12.bcmod,h12.bccta,h12.bcoper,h12.bcsbop,h12.bctop, 
             h12.bcfval,h12.bcfvto,h12.bctasa,
             case when bcrubr like '7%' then to_number(substr(bcrubr,7,2)) else h12.bcgpo end;

      commit;

      Insert into tipcre(bcfech,pepais,petdoc,pendoc,petipo,penom,bccate,
                         bcemp,bcsuc,bcmda,bcpap,bcmod,bccta,bcoper,bcsbop,bctop,  
                         bcfval,bcfvto,bctasa,bcgpo,bcsdmn,bcsdmo)  
      Select h12.bcfech,r08.pepais,r08.petdoc,r08.pendoc,d01.petipo,d01.penom, h12.bccate,
             h12.bcemp,h12.bcsuc,h12.bcmda,h12.bcpap,h12.bcmod,h12.bccta,h12.bcoper,h12.bcsbop,h12.bctop, 
             h12.bcfval,h12.bcfvto,h12.bctasa,substr(h12.bcrubr,7,2), 
             -sum(h12.bcsdmn),-sum(bcsdmo) 
        From fsh012 h12 left join fsr008 r08 on r08.ctnro = h12.bccta
                                            and r08.ttcod = 1
                                            and r08.cttfir = 'T' 
                        left join fsd001 d01 on d01.pepais = r08.pepais
                                            and d01.petdoc = r08.petdoc
                                            and d01.pendoc = r08.pendoc                 
       where bcemp = 1
         and bcfech = pd_feccie --to_date('20170630','rrrrmmdd')
         and bcmod = 117
         and bcrubr like '7%'                      
         and bccta <> 999999999
         and bcprod <> 99 
       Group By h12.bcfech,r08.pepais,r08.petdoc,r08.pendoc,d01.petipo,d01.penom, h12.bccate,
             h12.bcemp,h12.bcsuc,h12.bcmda,h12.bcpap,h12.bcmod,h12.bccta,h12.bcoper,h12.bcsbop,h12.bctop, 
             h12.bcfval,h12.bcfvto,h12.bctasa,substr(h12.bcrubr,7,2);

      commit;
      
      --
      -- Crea indices
      --
      lv_scrip:= 'create index ix_tipcre1 on tipcre (pepais,petdoc,pendoc)'; 
      execute immediate lv_scrip;
      lv_scrip:= 'create index ix_tipcre2 on tipcre (petipo)';  
      execute immediate lv_scrip;
      lv_scrip:= 'create index ix_tipcre3 on tipcre (bcemp,bcsuc,bcpap,bcmda,bccta,bcoper,bcsbop,bctop,bcmod)';
      execute immediate lv_scrip;
      
 End sp_crea_base;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Procedure sp_actualiza_modulo(PN_TIPCAM in number)
is
Cursor c_cred
       is select bcemp,bcsuc,bcpap,bcmda,bccta,bcoper,bcsbop,bctop,bcmod,bcfval,bcsdmn
            from tipcre
            where bcmodo is null;
           /*where bcmod in (200,116)
              or bctop= 550 ; */
   ln_bcmod  number(3);
   ln_bctop  number(3);
   ln_subop  number(3);
   ln_existe number(1) := 0;
   lv_scrip varchar2(200);
   ln_bccta number(9);
   ln_bcope number(9);
   ld_fecdes date;
   ln_mtodes number(12,2);
   ln_tipcam number(7,3) := PN_TIPCAM;
Begin
  -- Indice
  lv_scrip:= 'Select count(*) From user_indexes Where index_name = ''IX_TIPCRE4''';
  Execute Immediate lv_scrip into ln_existe;
  If ln_existe > 0 Then
     Begin
         lv_scrip:= 'drop index ''IX_TIPCRE4''';
         execute immediate lv_scrip;
     Exception When Others Then
         null;
     End;
  Else
    lv_scrip:= 'create index ix_tipcre4 on tipcre (bcemp,bcsuc,bcpap,bcmda,bccta,bcoper,bcsbop,bctop,bcmod,bcmodo,bctopo,bcsbopo,bcctao,bcopero)';
    Execute Immediate lv_scrip;
  End If;
  
  For x In c_cred Loop
    -- Busca Instancia y Modulo-TipoOperacion Origen
    ln_bcmod := null;
    ln_bctop := null;
    ln_subop := null;
    If x.bcmod in (200,116) or x.bctop= 550 Then
    Begin
      Select r11.r2mod,r11.r2tope,r11.r2sbop,r11.r2cta,r11.r2oper,d10.aofval,
             decode(d10.aomda,0,d10.aoimp,d10.aoimp*ln_tipcam)
        Into ln_bcmod, ln_bctop,ln_subop,ln_bccta,ln_bcope,ld_fecdes,ln_mtodes
        From fsr011 r11 join fsd010 d10 on d10.pgcod = r11.r2cod
                                       and d10.aomod = r11.r2mod
                                       and d10.aomda = r11.r2mda
                                       and d10.aopap = r11.r2pap
                                       and d10.aocta = r11.r2cta
                                       and d10.aooper= r11.r2oper
                                       and d10.aosbop= r11.r2sbop
                                       and d10.aotope= r11.r2tope 
       Where r11.r1cod = x.bcemp
         --and r11.r1suc = x.bcsuc
         and r11.r1mod = x.bcmod
         and r11.r1mda = x.bcmda
         and r11.r1pap = x.bcpap
         and r11.r1cta = x.bccta
         and r11.r1oper= x.bcoper
         and r11.r1sbop= x.bcsbop
         and r11.r1tope= x.bctop
         and r11.relcod= 46
         and r11.r011co= 'S';
     Exception When too_many_rows Then 
            Begin
               Select r11.r2mod,r11.r2tope,r11.r2sbop,r11.r2cta,r11.r2oper,d10.aofval,
                       decode(d10.aomda,0,d10.aoimp,d10.aoimp*ln_tipcam)
                    Into ln_bcmod, ln_bctop,ln_subop,ln_bccta,ln_bcope,ld_fecdes,ln_mtodes
                    From fsr011 r11 join fsd010 d10 on d10.pgcod = r11.r2cod
                                                 and d10.aomod = r11.r2mod
                                                 and d10.aomda = r11.r2mda
                                                 and d10.aopap = r11.r2pap
                                                 and d10.aocta = r11.r2cta
                                                 and d10.aooper= r11.r2oper
                                                 and d10.aosbop= r11.r2sbop
                                                 and d10.aotope= r11.r2tope 
                    Where r11.r1cod = x.bcemp
                    --and r11.r1suc = x.bcsuc
                    and r11.r1mod = x.bcmod
                    and r11.r1mda = x.bcmda
                    and r11.r1pap = x.bcpap
                    and r11.r1cta = x.bccta
                    and r11.r1oper= x.bcoper
                    and r11.r1sbop= x.bcsbop
                    and r11.r1tope= x.bctop
                    and r11.relcod= 46
                    and r11.r011co= 'S'
                    and rownum=1;   
            Exception When Others Then
               ln_mtodes := null;
               ld_fecdes := null;
            End;           
     When Others Then
        IF x.bcmod <> 116 Then
           Begin
              Select r11.r1mod,r11.r1tope,r11.r1sbop,r11.r1cta,r11.r1oper,d10.aofval,
                     decode(d10.aomda,0,d10.aoimp,d10.aoimp*ln_tipcam)
                Into ln_bcmod, ln_bctop,ln_subop,ln_bccta,ln_bcope,ld_fecdes,ln_mtodes
                From fsr011 r11 join fsd010 d10 on d10.pgcod = r11.r1cod
                                               and d10.aomod = r11.r1mod
                                               and d10.aomda = r11.r1mda
                                               and d10.aopap = r11.r1pap
                                               and d10.aocta = r11.r1cta
                                               and d10.aooper= r11.r1oper
                                               and d10.aosbop= r11.r1sbop
                                               and d10.aotope= r11.r1tope
               Where r11.r2cod = x.bcemp
                 --and r11.r2suc = x.bcsuc
                 and r11.r2mod = x.bcmod
                 and r11.r2mda = x.bcmda
                 and r11.r2pap = x.bcpap
                 and r11.r2cta = x.bccta
                 and r11.r2oper= x.bcoper
                 --and r11.r2sbop= x.bcsbop
                 and r11.r2tope= x.bctop
                 and r11.relcod= 52
                 and r11.r011co= 'S';
           Exception when too_many_rows then
                    Begin
                      Select r11.r1mod,r11.r1tope,r11.r1sbop,r11.r1cta,r11.r1oper,d10.aofval,
                         decode(d10.aomda,0,d10.aoimp,d10.aoimp*ln_tipcam)
                    Into ln_bcmod, ln_bctop,ln_subop,ln_bccta,ln_bcope,ld_fecdes,ln_mtodes
                    From fsr011 r11 join fsd010 d10 on d10.pgcod = r11.r1cod
                                                   and d10.aomod = r11.r1mod
                                                   and d10.aomda = r11.r1mda
                                                   and d10.aopap = r11.r1pap
                                                   and d10.aocta = r11.r1cta
                                                   and d10.aooper= r11.r1oper
                                                   and d10.aosbop= r11.r1sbop
                                                   and d10.aotope= r11.r1tope
                   Where r11.r2cod = x.bcemp
                     --and r11.r2suc = x.bcsuc
                     and r11.r2mod = x.bcmod
                     and r11.r2mda = x.bcmda
                     and r11.r2pap = x.bcpap
                     and r11.r2cta = x.bccta
                     and r11.r2oper= x.bcoper
                     --and r11.r2sbop= x.bcsbop
                     and r11.r2tope= x.bctop
                     and r11.relcod= 52
                     and r11.r011co= 'S'
                     and rownum=1;
                Exception When Others then
                    ln_mtodes := null;
                    ld_fecdes := null;
                End;    
           When Others Then
               ln_mtodes := null;
               ld_fecdes := null;
           End;
        Else
           Begin
              Select r11.r2mod,r11.r2tope,r11.r2sbop,r11.r2cta,r11.r2oper,d10.aofval,
                     decode(d10.aomda,0,d10.aoimp,d10.aoimp*ln_tipcam)
                Into ln_bcmod, ln_bctop,ln_subop,ln_bccta,ln_bcope,ld_fecdes,ln_mtodes
                From fsr011 r11 join fsd010 d10 on d10.pgcod = r11.r2cod
                                               and d10.aomod = r11.r2mod
                                               and d10.aomda = r11.r2mda
                                               and d10.aopap = r11.r2pap
                                               and d10.aocta = r11.r2cta
                                               and d10.aooper= r11.r2oper
                                               and d10.aosbop= r11.r2sbop
                                               and d10.aotope= r11.r2tope 
               Where r11.r1cod = x.bcemp
                 --and r11.r1suc = x.bcsuc
                 and r11.r1mod = x.bcmod
                 and r11.r1mda = x.bcmda
                 and r11.r1pap = x.bcpap
                 and r11.r1cta = x.bccta
                 and r11.r1oper= x.bcoper
                 --and r11.r1sbop= x.bcsbop
                 and r11.r1tope= x.bctop
                 and r11.relcod= 46
                 and r11.r011co= 'S';
           Exception When Too_Many_Rows Then
                Begin
                  Select r11.r2mod,r11.r2tope,r11.r2sbop,r11.r2cta,r11.r2oper,d10.aofval,
                         decode(d10.aomda,0,d10.aoimp,d10.aoimp*ln_tipcam)
                    Into ln_bcmod, ln_bctop,ln_subop,ln_bccta,ln_bcope,ld_fecdes,ln_mtodes
                    From fsr011 r11 join fsd010 d10 on d10.pgcod = r11.r2cod
                                                   and d10.aomod = r11.r2mod
                                                   and d10.aomda = r11.r2mda
                                                   and d10.aopap = r11.r2pap
                                                   and d10.aocta = r11.r2cta
                                                   and d10.aooper= r11.r2oper
                                                   and d10.aosbop= r11.r2sbop
                                                   and d10.aotope= r11.r2tope 
                   Where r11.r1cod = x.bcemp
                     --and r11.r1suc = x.bcsuc
                     and r11.r1mod = x.bcmod
                     and r11.r1mda = x.bcmda
                     and r11.r1pap = x.bcpap
                     and r11.r1cta = x.bccta
                     and r11.r1oper= x.bcoper
                     --and r11.r1sbop= x.bcsbop
                     and r11.r1tope= x.bctop
                     and r11.relcod= 46
                     and r11.r011co= 'S'
                     and rownum=1;
                Exception When Others Then
                    ln_mtodes := null;
                    ld_fecdes := null;
                End;    
           When Others Then
               ln_mtodes := null;
               ld_fecdes := null;
           End;
        End If;
     End;
     Else
         ln_bcmod := x.bcmod;
         ln_bctop := x.bctop;
         ln_subop := x.bcsbop;
         ln_bccta := x.bccta;
         ln_bcope := x.bcoper;
         ld_fecdes:= x.bcfval;
         ln_mtodes:= x.bcsdmn;
     End If;
     
     If x.bcmod = 116 and ln_bcmod is null Then
        ln_bcmod := 117;
        ln_bctop := x.bctop;
     End If;     
     
     Update tipcre set bcmodo=ln_bcmod, bctopo = ln_bctop, bcsbopo = ln_subop,
                       bcctao=ln_bccta, bcopero= ln_bcope, deslin = ld_fecdes,
                       mtolin=ln_mtodes 
      Where bcemp = x.bcemp
        and bcsuc = x.bcsuc
        and bcpap = x.bcpap
        and bcmda = x.bcmda
        and bccta = x.bccta
        and bcoper= x.bcoper
        and bcsbop= x.bcsbop
        and bctop = x.bctop
        and bcmod = x.bcmod;
     Commit;
  End Loop;
  end sp_actualiza_modulo; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure sp_cli_recurrentenuevo(PD_FECDES in date, pd_feccie in date)
 Is 
     cursor c_desrec
         is select * 
              from tipcre 
             where deslin >= PD_FECDES and nvl(cnuevo,'N') <> 'S' and bcmod not in (108,117);
             --and pendoc='29256698    ';
             --and bccta=14660;-- and bcoper =1842154;
     ln_descan date; 
     ln_tcrcan number(2);
     ln_desvig date; 
     ln_tcrvig number(2);
     ln_sector number(1);
     ln_tipcre number(2);
     ld_fecdes date;
     lv_destcr varchar2(25);
     
     ln_modvig number(3);
     ln_mdavig number(4);
     ln_ctavig number(9);
     ln_opevig number(9);
     ln_sbovig number(3);
     ln_topvig number(3);
     
     ln_modcan number(3);
     ln_mdacan number(4);
     ln_ctacan number(9);
     ln_opecan number(9);
     ln_sbocan number(3);
     ln_topcan number(3);
     
     ln_mod number(3);
     ln_mda number(4);
     ln_cta number(9);
     ln_ope number(9);
     ln_sbo number(3);
     ln_top number(3);
     --lv_err varchar2(200);
Begin
    For x in c_desrec Loop
       ln_descan := null;
       ln_tcrcan := null;
       ln_desvig := null;
       ln_tcrvig := null;
       ln_tipcre := null;
       ln_sector := null;
       lv_destcr := null;
       ln_mod := null;
       ln_mda := null;
       ln_cta := null;
       ln_ope := null;
       ln_sbo := null;
       ln_top := null;
       
       -- Créditos Pymes Vigentes 
       Begin 
         --dbms_output.put_line('Cta:'||to_char(x.bcctao)||'  Ope:'||to_char(x.bcopero)); 
         Select deslin,bcgpo,bcmodo,bcmda,bccta,bcopero,bcsbopo,bctopo,secdes
           Into ln_desvig, ln_tcrvig,
                ln_modvig,ln_mdavig,ln_ctavig,ln_opevig,ln_sbovig,ln_topvig,ln_sector
           From (  
                 Select tcr.deslin,tcr.bcgpo,tcr.bcmodo,tcr.bcmda,tcr.bccta,tcr.bcopero,tcr.bcsbopo,tcr.bctopo,tcr.secdes
                   From fsr008 r08 join fsd010 d10 on d10.pgcod = r08.pgcod
                                                   and d10.aocta = r08.ctnro
                                   join tipcre tcr on tcr.bcemp = d10.pgcod
                                                  and tcr.bcmda = d10.aomda               
                                                  and tcr.bcpap = d10.aopap
                                                  and tcr.bcmod = d10.aomod
                                                  and tcr.bccta = d10.aocta
                                                  and tcr.bcoper= d10.aooper
                                                  and tcr.bcsbop= d10.aosbop
                                                  and tcr.bctop = d10.aotope 
                  Where r08.pepais = x.pepais
                    and r08.petdoc = x.petdoc
                    and r08.pendoc = x.pendoc
                    and r08.ttcod  = 1
                    and r08.cttfir = 'T'
                    and d10.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120,116)
                                      union all
                                      select 117 from dual
                                      union all
                                      select 141 from dual
                                     ) 
                    and d10.aostat <> 99
                    and d10.aofval <= x.deslin
                    and not (d10.pgcod = x.bcemp and
                             d10.aomod = x.bcmodo and
                             d10.aomda = x.bcmda and
                             d10.aopap = x.bcpap and
                             d10.aocta = x.bcctao and
                             d10.aooper= x.bcopero and
                             d10.aosbop= x.bcsbopo and
                             d10.aotope= x.bctopo
                            ) 
                    and tcr.bcgpo not in (3,4)
                    Order by tcr.deslin desc
                  )  
                  Where rownum = 1;
                  --dbms_output.put_line('Algo'||to_char(ln_ctavig));
       Exception When Others Then
           ln_desvig:=null; ln_tcrvig:=null;
           --lv_err := substr(sqlerrm,1,200);
           --dbms_output.put_line('ErrVig:'||lv_err);
       End;  
       --dbms_output.put_line('Vig:'||to_char(ln_opevig));  
       Begin       
       -- Créditos Pymes Cancelados el mismo dia del desembolso    
          Select aofval, tipcr,aomod,aomda,aocta,aooper,aosbop,aotope
            Into ln_descan, ln_tcrcan,
                 ln_modcan,ln_mdacan,ln_ctacan,ln_opecan,ln_sbocan,ln_topcan
            From (   
            Select d10.aofval,substr(h16.hrubro,5,2) tipcr,
                   d10.aomod,d10.aomda,d10.aocta,d10.aooper,d10.aosbop,d10.aotope
                   From fsr008 r08 join fsd010 d10 on d10.pgcod = r08.pgcod
                                                  and d10.aocta = r08.ctnro
                                   join fsd602 d62 on d62.pgcod = d10.pgcod
                                                  and d62.ppmod = d10.aomod
                                                  and d62.ppsuc = d10.aosuc
                                                  and d62.ppmda = d10.aomda
                                                  and d62.pppap = d10.aopap
                                                  and d62.ppcta = d10.aocta
                                                  and d62.ppoper= d10.aooper
                                                  and d62.ppsbop= d10.aosbop
                                                  and d62.pptope= d10.aotope
                                                  and d62.pp1fech=d10.aofe99
                                                  and d62.d602co= 'S'
                                                  and d62.pp1nump=(select max(d602.pp1nump)
                                                                     from fsd602 d602 
                                                                    where d602.pgcod  =d62.pgcod 
                                                                      and d602.ppmod  =d62.ppmod 
                                                                      and d602.ppsuc  =d62.ppsuc 
                                                                      and d602.ppmda  =d62.ppmda 
                                                                      and d602.pppap  =d62.pppap 
                                                                      and d602.ppcta  =d62.ppcta 
                                                                      and d602.ppoper =d62.ppoper
                                                                      and d602.ppsbop =d62.ppsbop
                                                                      and d602.pptope =d62.pptope
                                                                      and d602.pp1fech=d62.pp1fech
                                                                      and d602.d602co='S'
                                                                  )  
                                   join fsh016 h16 on h16.pgcod = d62.pgcod
                                                  and h16.hcmod = d62.d602mo
                                                  and h16.hsucor= d62.d602su
                                                  and h16.htran = d62.d602tr
                                                  and h16.hnrel = d62.d602re
                                                  and h16.hfcon = d62.d602fc
                                                  and h16.hcord = d62.d602or
                                                  and h16.hcsubo= d62.d602sb                   
                  Where r08.pepais = x.pepais
                    and r08.petdoc = x.petdoc
                    and r08.pendoc = x.pendoc
                    and r08.ttcod  = 1
                    and r08.cttfir = 'T'
                    and d10.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120,116)
                                      union all
                                      select 141 from dual
                                     ) 
                    and d10.aostat = 99
                    and d10.aofe99 = x.deslin
                    and not (d10.pgcod = x.bcemp   and
                             d10.aomod = x.bcmodo  and
                             d10.aomda = x.bcmda   and
                             d10.aopap = x.bcpap   and
                             d10.aocta = x.bcctao   and
                             d10.aooper= x.bcopero and
                             d10.aosbop= x.bcsbopo and
                             d10.aotope= x.bctopo 
                            )     
                     and substr(h16.hrubro,5,2) not in (3,4)  
                     UNION ALL
                 Select d10.aofval,substr(h16.hrubro,7,2) tipcr,
                        d10.aomod,d10.aomda,d10.aocta,d10.aooper,d10.aosbop,d10.aotope
                   From fsr008 r08 join fsd010 d10 on d10.pgcod = r08.pgcod
                                                  and d10.aocta = r08.ctnro
                                   join fsh016 h16 on h16.pgcod = d10.pgcod
                                                  and h16.hmodul = d10.aomod
                                                  and h16.hsucur= d10.aosuc
                                                  and h16.htoper= d10.aotope
                                                  and h16.hmda  = d10.aomda
                                                  and h16.hpap  = d10.aopap
                                                  and h16.hcta  = d10.aocta
                                                  and h16.hoper = d10.aooper
                                                  and h16.hsubop= d10.aosbop
                                                  and h16.hfcon = d10.aofe99                  
                  Where r08.pepais = x.pepais
                    and r08.petdoc = x.petdoc
                    and r08.pendoc = x.pendoc
                    and r08.ttcod  = 1
                    and r08.cttfir = 'T'
                    and d10.aomod  = 117 
                    and d10.aostat = 99
                    and d10.aofe99 = x.deslin
                    and not (d10.pgcod = x.bcemp   and
                             d10.aomod = x.bcmodo  and
                             d10.aomda = x.bcmda   and
                             d10.aopap = x.bcpap   and
                             d10.aocta = x.bcctao  and
                             d10.aooper= x.bcopero and
                             d10.aosbop= x.bcsbopo and
                             d10.aotope= x.bctopo 
                            )     
                     and substr(h16.hrubro,7,2) not in (3,4)             
                  Order By 1
               ) Where Rownum=1;          
       Exception When Others Then
           ln_descan:=null; ln_tcrcan:=null;
           --lv_err := substr(sqlerrm,1,200);
           --dbms_output.put_line('ErrCan:'||lv_err);
       End; 
       --dbms_output.put_line('Can:'||to_char(ln_opecan));  
       If ln_descan is null and ln_desvig is null Then
          ln_tipcre := null;
       ElsIf ln_descan is null and ln_desvig is not null Then
          ln_tipcre := ln_tcrvig;
          ld_fecdes := ln_desvig;
          ln_mod:=ln_modvig;ln_mda:=ln_mdavig;ln_cta:=ln_ctavig;ln_ope:=ln_opevig;ln_sbo:=ln_sbovig;ln_top:=ln_topvig;
       ElsIf ln_descan is not null and ln_desvig is null Then
          ln_tipcre := ln_tcrcan;
          ld_fecdes := ln_descan;
          ln_mod:=ln_modcan;ln_mda:=ln_mdacan;ln_cta:=ln_ctacan;ln_ope:=ln_opecan;ln_sbo:=ln_sbocan;ln_top:=ln_topcan;
       ElsIf ln_descan is not null and ln_desvig is not null Then
             If ln_descan > ln_desvig Then
                ln_tipcre := ln_tcrcan;
                ld_fecdes := ln_descan;
                ln_mod:=ln_modcan;ln_mda:=ln_mdacan;ln_cta:=ln_ctacan;ln_ope:=ln_opecan;ln_sbo:=ln_sbocan;ln_top:=ln_topcan;
             Else
                ln_tipcre := ln_tcrvig;
                ld_fecdes := ln_desvig;
                ln_mod:=ln_modvig;ln_mda:=ln_mdavig;ln_cta:=ln_ctavig;ln_ope:=ln_opevig;ln_sbo:=ln_sbovig;ln_top:=ln_topvig;
             End If;    
       End If;         
       
       If nvl(ln_tipcre,0) = 13 Then
          -- Sector tabla de fin de mes
--          If ld_fecdes < to_date('20160131','rrrrmmdd') Then
          If ld_fecdes < pd_feccie Then
            
              Begin
              Select jaql101scl
                Into ln_sector 
                From(
                    Select j01.jaql101scl
                      From jaql101 j01 
                     where j01.jaql101pgc = x.bcemp
                       and j01.jaql101mod = ln_mod
                       and j01.jaql101mon = ln_mda
                       and j01.jaql101pap = 0
                       and j01.jaql101cta = ln_cta
                       and j01.jaql101ope = ln_ope
                       and j01.jaql101sop = ln_sbo
                       and j01.jaql101top = ln_top
                       and j01.jaql101fch = (select max(jaql101fch)
                                               from jaql101 j10 
                                              where j10.jaql101pgc = j01.jaql101pgc
                                                and j10.jaql101mod = j01.jaql101mod
                                                and j10.jaql101mon = j01.jaql101mon
                                                and j10.jaql101pap = 0
                                                and j10.jaql101cta = j01.jaql101cta
                                                and j10.jaql101ope = j01.jaql101ope
                                                and j10.jaql101sop = j01.jaql101sop
                                                and j10.jaql101top = j01.jaql101top
                                                and j10.jaql101fch < x.deslin )
                       Order By j01.jaql101fch desc
                     ) Where rownum = 1;  
               Exception When Others Then
                 ln_sector := null;
               End;
          End If;           
       End If; 
       
       If ln_tipcre is not null Then
            If ln_tipcre = 2    Then lv_destcr := 'MICROEMPRESA';
            Elsif ln_tipcre = 3  Then
                  If ln_mod = 116 Then lv_destcr := 'CONSUMO REVOLVENTE';
                  Else ln_tipcre := 31; lv_destcr := 'CONSUMO NO REVOLVENTE';
                  End If;
            Elsif ln_tipcre = 9  Then lv_destcr := 'CORPORATIVO-SIS.FIN.';
            Elsif ln_tipcre = 10 Then lv_destcr := 'CORPORATIVO';
            Elsif ln_tipcre = 11 Then lv_destcr := 'GRANDE EMPRESA';
            Elsif ln_tipcre = 12 Then lv_destcr := 'MEDIANA EMPRESA';
            Elsif ln_tipcre = 13 Then lv_destcr := 'PEQUEÑA EMPRESA';
            Elsif ln_tipcre = 4  Then lv_destcr := 'HIPOTECARIO';
            End If;
       End If;  
       
       Update tipcre set tcrant = ln_tipcre,secant=ln_sector,tdcrde=null,
                         ctaant=ln_cta,opeant=ln_ope,sboant=ln_sbo,modant=ln_mod,topant=ln_top,mdaant=ln_mda,
                         tcdant=lv_destcr,actant='O'       
           where bcemp = x.bcemp
             and bcsuc = x.bcsuc
             and bcpap = x.bcpap
             and bcmda = x.bcmda
             and bccta = x.bccta
             and bcoper= x.bcoper
             and bcsbop= x.bcsbop
             and bctop = x.bctop
             and bcmod = x.bcmod;
        commit;     
    End Loop;  
 End sp_cli_recurrentenuevo;                
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 Procedure sp_tipifica_base ( pd_fecrcc in date)
 Is
   Cursor c_pers
       is select pepais, petdoc, pendoc,petipo,
                 bcemp,bcsuc,bcpap,bcmda,bccta,bcoper,bcsbop,bctop,bcmod,bcsdmn saldomn,
                 bcmodo, bctopo,bcsbopo,bcfval
            from tipcre cred
           where bcmod <> 117
             and not(petipo = 'J' or
                     (petipo = 'F' and nvl(codfin,'N') in ('HC','HP'))
                    );
                
   --Cursor c_deud (lv_sbs in varchar2, ld_fini in date, ld_ffin in date)
   Cursor c_deud (lv_sbs in varchar2, ld_fec in date)
       is select d_fecpre,
                 sum(case when substr(c_cuenta,1,1) not like '2%' then n_salcap else 0 end) n_salcap,
                 sum(case when substr(c_cuenta,1,1) like '2%' then n_salcap else 0 end) n_salint
            from cldrccs 
           where c_codsbs = lv_sbs and d_fecpre = ld_fec 
             and (substr(c_cuenta,1,4) in ('1411','1413','1414','1415','1416',
                                           '1421','1423','1424','1425','1426',
                                           '7111','7112','7113','7114',
                                           '7121','7122','7123','7124'
                                          )
                  or    
                  substr(c_cuenta,1,6) in ('291101','292101','291102','292102') -- Ing.interes y comisiones
                 )                      
             and c_cretip <> '13' --Eliminar creditos hipotecarios                            
           Group By c_codsbs,d_fecpre
           Order By 1;  
       
       
  Cursor c_venta (n_numeva in number, n_tipcam in number)
      is  select decode(g023.sng026cod,538,38,539,39,g023.sng026cod) Codigo,
                  sum(case when g023.sng026cod=538 then g023.sng023mto*n_tipcam 
                       when g023.sng026cod=38 then g023.sng023mto 
                       when g023.sng026cod=539 then g023.sng023mto*n_tipcam
                       when g023.sng026cod=39 then g023.sng023mto 
                       else 0 
                      end) Monto       
             from sng023 g023
            where g023.sng021eval = n_numeva
              and g023.sng026cod in (39,539,38,538) 
            Group By decode(g023.sng026cod,538,38,539,39,g023.sng026cod);
            
       lv_codsbs varchar2(10);
       lv_numdoc varchar2(15);
       ld_fecrcc date := pd_fecrcc; --to_date('20160531','rrrrmmdd');
       ln_hisrcc number(2);
       ld_minrcc date := add_months(ld_fecrcc,-5); 
       ln_deu1 number(12,2);
       ln_deu2 number(12,2);
       ln_deu3 number(12,2);
       ln_deu4 number(12,2);
       ln_deu5 number(12,2);
       ln_deu6 number(12,2);
       ln_deud1 number(12,2);
       ln_deud2 number(12,2);
       ln_deud3 number(12,2);
       ln_deud4 number(12,2);
       ln_deud5 number(12,2);
       ln_deud6 number(12,2);
       ln_tipc number(2);
       lv_desc varchar2(25);
       ln_numhip number(5);
       ln_acttip number(1);
       ln_insfin number(1);
       ln_tipcor number(1);
       ln_venan1 number(12,2);
       ln_venan2 number(12,2);
       ln_numins number(10);
       ln_numeva number(10);
       ln_tipcam number(7,4);
       ld_fecmig date := to_date('20130701','rrrrmmdd');
       ld_rccdes date;
       ld_mindes date;
       lv_garhip varchar2(1);
       ln_bcmod number(3);
       ln_bctop number(3);
       lv_codfin varchar2(2);
       lv_tipdoc varchar2(1);
       ln_salpym number(12,2);
       lv_deupym varchar2(1);
       lv_pymdes varchar2(1);
       ld_fecha  date;
Begin
  -- Abrir Cursor
  For x in c_pers Loop
    lv_garhip := null;
    ln_acttip := 0;
    ln_bcmod  := x.bcmod;
    ln_bctop  := x.bctop;
    lv_numdoc := trim(x.pendoc);
    lv_codsbs := null;
    ln_hisrcc := 0;
    ln_deu1   := 0; ln_deu2 := 0; ln_deu3 := 0;
    ln_deu4   := 0; ln_deu5 := 0; ln_deu6 := 0;
    ln_deud1   := 0; ln_deud2 := 0; ln_deud3 := 0;
    ln_deud4   := 0; ln_deud5 := 0; ln_deud6 := 0;
    ln_numhip := 0;
    lv_garhip := null;
    ln_acttip := 0;
    ln_insfin := 0;
    ln_numins := null;
    ln_tipcam := null;
    ln_numeva := null;
    ln_venan1 := null;
    ln_venan2 := null;
    lv_tipdoc := null;
    ln_salpym := 0;
    lv_deupym := 'N';
    lv_pymdes := 'N';
    -- Codigo de Financiamiento C=Consumo/Nulo=Pyme/HP=Hipotec.Pyme/HC=Hipotec.Consumo
    If x.bcmod = 200 or x.bctop = 550 Then 
       If x.bcmodo = 117 Then
          ln_bcmod := 116; 
       Else
          ln_bcmod := x.bcmodo;
       End If;    
       
       ln_bctop := x.bctopo;
    End If;
    Begin
         Select nvl(codfin,'P')
           Into lv_codfin
           From profin
          Where modulo = ln_bcmod
            and tipope = ln_bctop; 
    Exception When Others Then
          lv_codfin := null;
    End;  
      
    If x.petipo = 'F' and lv_codfin in ('HP','HC') then
       -- Revisar si existe garantia hipotecario
       Select count(*) Into ln_numhip
         From fsr011 r11 
        where r11.r1cod = x.bcemp
          and r11.r1suc = x.bcsuc -- add
          and r11.r1mod = x.bcmod
          and r11.r1mda = x.bcmda
          and r11.r1pap = x.bcpap
          and r11.r1cta = x.bccta
          and r11.r1oper= x.bcoper
          and r11.r1sbop= x.bcsbop
          and r11.r1tope= x.bctop
          and r11.relcod= 50
          and r11.r2mod = 70
          and r11.r2tope in (10,15)
          and r11.r011co= 'S'; 
       If ln_numhip > 0 Then 
          -- Hipotecario para vivienda
          /*lv_garhip := 'S';
          ln_acttip := 1;*/
          update tipcre set garhip=lv_garhip, codfin = lv_codfin, regact = 'S'
           where bcemp = x.bcemp 
             and bcsuc = x.bcsuc 
             and bcpap = x.bcpap 
             and bcmda = x.bcmda 
             and bccta = x.bccta 
             and bcoper= x.bcoper
             and bcsbop= x.bcsbop
             and bctop = x.bctop
             and bcmod = x.bcmod;
        End If;     
    End If;    
    
    If x.petipo = 'J' Then
        /*ln_insfin := 0;
        ln_numins := null;
        ln_tipcam := null;
        ln_numeva := null;
        ln_venan1 := null;
        ln_venan2 := null;*/
        --dbms_output.put_line('PJ');
        -- Es institución financiera
        Select count(*) into ln_insfin
          From fsd004 
         where ifpais = x.pepais
           and iftdoc = x.petdoc
           and ifndoc = x.pendoc;
        If ln_insfin = 0 Then
           -- Tipo cliente credito corporativo
           Begin
           Select g11.sngc11cmb2 into ln_tipcor
             From sngc11 g11
            Where g11.sngc11pais = x.pepais
              and g11.sngc11tdoc = x.petdoc 
              and g11.sngc11ndoc = x.pendoc; 
           Exception When Others Then ln_tipcor := null;
           End;   
        Else
            ln_tipcor := 4;
        End If; 
        --dbms_output.put_line('Tipo Corp.:'||to_char(ln_tipcor));
        If nvl(ln_tipcor,0) in (0,6) Then 
           -- Nivel de Ventas 
           -- Obtiene Instancia
           --dbms_output.put_line('Nivel Ventas');
           Begin
             If (x.bcmod not in (116,200) or x.bctop <> 550) Then --Buscar datos para instancia
                Select x700.xwfprcins Into ln_numins
                  from xwf700 x700 
                 where x700.xwfempresa  = x.bcemp
                   and x700.xwfmodulo   = x.bcmod
                   and x700.xwfmoneda   = x.bcmda
                   and x700.xwfpapel    = x.bcpap
                   and x700.xwfcuenta   = x.bccta
                   and x700.xwfoperacion= x.bcoper
                   and x700.xwfsubope   = x.bcsbop
                   and x700.xwftipope   = x.bctop
                   and x700.xwfcar3     = '1';
              Else 
                Select x700.xwfprcins Into ln_numins
                  From xwf700 x700 
                 Where x700.xwfempresa  = x.bcemp
                   and x700.xwfmodulo   = x.bcmodo
                   and x700.xwfmoneda   = x.bcmda
                   and x700.xwfpapel    = x.bcpap
                   and x700.xwfcuenta   = x.bccta
                   and x700.xwfoperacion= x.bcoper
                   and x700.xwfsubope   = x.bcsbopo
                   and x700.xwftipope   = x.bctopo
                   and x700.xwfcar3     = '1';                                 
              End IF;     
                 -- Tipo de cambio
                 --dbms_output.put_line('Instancia:'||to_char(ln_numins));
                 Begin
                      select sng120tcbi Into ln_tipcam
                        from sng120 g120 
                       where g120.sng120ins = ln_numins
                         and g120.sng120tsk = 'EVALUACION';
                 Exception When Others Then
                     ln_tipcam := 0;
                 End;    
                 
                 -- Nro. de Evaluación
                 Begin
                    select g021.sng021eval into ln_numeva
                      from sng021 g021
                     where g021.sng021sol = ln_numins;
                 Exception when others then
                     ln_numeva := null;
                 End;  
                 --dbms_output.put_line('Evaluación:'||to_char(ln_numeva));
                 For v in c_venta (ln_numeva,ln_tipcam) Loop
                     If v.codigo = 38 then ln_venan1 := v.monto; end If; 
                     If v.codigo = 39 then ln_venan2 := v.monto; end If; 
                 End Loop;
                     
            Exception When Others Then
                       ln_numins := null;
            End;           
        End If;
          /* Update fsh012_140ct u set u.insfin = decode(ln_insfin,0,'N','S'), u.codfin = ln_codfin,
                                     u.tipcor=ln_tipcor, u.venact = ln_venan1, u.venant=ln_venan2,
                                     u.numins=ln_numins
           where bcemp = x.bcemp 
             and bcsuc = x.bcsuc 
             and bcpap = x.bcpap 
             and bcmda = x.bcmda 
             and bccta = x.bccta 
             and bcoper= x.bcoper
             and bcsbop= x.bcsbop
             and bctop = x.bctop,
             and bcmod = x.bcmod; */
                     
     End If;      
         
     If ln_acttip = 0 Then   
       -- Actualiza endeudamiento Sist.Financ.
       /*lv_numdoc := trim(x.pendoc);
       lv_codsbs := null;
       ln_hisrcc := 0;
       ln_deu1 := 0; ln_deu2 := 0; ln_deu3 := 0;
       ln_deu4 := 0; ln_deu5 := 0; ln_deu6 := 0;*/
       -- Busca CodSbs
       If x.petipo = 'F' and x.bcmod <> 108 Then
          
          If x.petdoc = 21 Then
             lv_tipdoc := '1';
          Elsif x.petdoc = 2 Then
                lv_tipdoc := '2';
          Elsif x.petdoc = 5 Then
                lv_tipdoc := '5';
          End If;      
           ---modifica hasta encontrar historial 
           ld_fecha := ld_fecrcc;
           Loop             
               Begin
                 --select c_codsbs ,count(*) into lv_codsbs,ln_hisrcc
                 Select c_codsbs into lv_codsbs
                   From cldrcci 
                  Where c_tdocid=lv_tipdoc and c_docide = lv_numdoc 
                    --and d_fecpre between ld_minrcc and ld_fecrcc
                    and d_fecpre = ld_fecha;
                 --group by c_codsbs; 
                 If lv_codsbs is not null Then
                    ln_hisrcc := 1; 
                    ld_fecha  := last_day(add_months(ld_minrcc,-1));
                    Exit;
                 End If;  
               Exception when others then
                         ln_hisrcc := 0;
                         lv_codsbs := null;
                         ld_fecha  := last_day(add_months(ld_fecha,-1));
               End; 
           Exit When ld_fecha < ld_minrcc;
           End Loop;
           
       ElsIf x.petipo <> 'F' Then 
       
          /*begin
             select c_codsbs ,count(*) into lv_codsbs,ln_hisrcc
               from cldrcci where c_doctri = lv_numdoc and d_fecpre between ld_minrcc and ld_fecrcc
             group by c_codsbs; 
           exception when others then
              ln_hisrcc := 0;
           end; */
           ld_fecha := ld_fecrcc;
           Loop             
               Begin
                 --select c_codsbs ,count(*) into lv_codsbs,ln_hisrcc
                 Select c_codsbs into lv_codsbs
                   From cldrcci 
                  Where c_doctri=lv_numdoc  
                    --and d_fecpre between ld_minrcc and ld_fecrcc
                    and d_fecpre = ld_fecha;
                 --group by c_codsbs; 
                 If lv_codsbs is not null Then
                    ln_hisrcc := 1; 
                    ld_fecha  := last_day(add_months(ld_minrcc,-1));
                    Exit;
                 End If;  
               Exception when others then
                         ln_hisrcc := 0;
                         lv_codsbs := null;
                         ld_fecha  := last_day(add_months(ld_fecha,-1));
               End; 
           Exit When ld_fecha < ld_minrcc;
           End Loop;
           
       End If;      
       
       If ln_hisrcc <> 0 Then
          /*For z in c_deud(lv_codsbs,ld_minrcc,ld_fecrcc) Loop
              If z.d_fecpre = ld_minrcc Then ln_deu1 := z.n_salcap-nvl(z.n_salint,0);
              Elsif z.d_fecpre = last_day(add_months(ld_minrcc,1)) Then ln_deu2 := z.n_salcap-nvl(z.n_salint,0); 
              Elsif z.d_fecpre = last_day(add_months(ld_minrcc,2)) Then ln_deu3 := z.n_salcap-nvl(z.n_salint,0); 
              Elsif z.d_fecpre = last_day(add_months(ld_minrcc,3)) Then ln_deu4 := z.n_salcap-nvl(z.n_salint,0); 
              Elsif z.d_fecpre = last_day(add_months(ld_minrcc,4)) Then ln_deu5 := z.n_salcap-nvl(z.n_salint,0); 
              Elsif z.d_fecpre = ld_fecrcc Then ln_deu6 := z.n_salcap-nvl(z.n_salint,0); 
              End If;  
          End Loop;  */
          ld_fecha := ld_minrcc;
          Loop
              For z in c_deud(lv_codsbs,ld_fecha) Loop
                  If z.d_fecpre = ld_minrcc Then ln_deu1 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                  Elsif z.d_fecpre = last_day(add_months(ld_minrcc,1)) Then ln_deu2 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                  Elsif z.d_fecpre = last_day(add_months(ld_minrcc,2)) Then ln_deu3 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                  Elsif z.d_fecpre = last_day(add_months(ld_minrcc,3)) Then ln_deu4 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                  Elsif z.d_fecpre = last_day(add_months(ld_minrcc,4)) Then ln_deu5 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                  Elsif z.d_fecpre = ld_fecrcc Then ln_deu6 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                  End If;  
              End Loop;
              ld_Fecha := add_months(ld_fecha,1);
          Exit When ld_fecha > ld_fecrcc;
          End Loop;
          
          
          If lv_codfin in ('C','HC') Then
              --Revisa si Consumo tiene deuda Pyme
             /*Select sum(n_salcap) into ln_salpym
               from cldrccs 
              where c_codsbs = lv_codsbs and d_fecpre between ld_minrcc and ld_fecrcc 
               and substr(c_cuenta,1,4) in ('1411','1413','1414','1415','1416',
                                            '1421','1423','1424','1425','1426',
                                            '7111','7112','7113','7114',
                                            '7121','7122','7123','7124'
                                           )
               and c_cretip not in ('13','11','12'); --Eliminar creditos hipotecarios */
              ld_fecha  := ld_fecrcc;
              lv_deupym := 'N';
              Loop
                  Select sum(n_salcap) into ln_salpym
                    from cldrccs 
                   where c_codsbs = lv_codsbs 
                     and d_fecpre = ld_fecha 
                     and substr(c_cuenta,1,4) in ('1411','1413','1414','1415','1416',
                                                  '1421','1423','1424','1425','1426',
                                                  '7111','7112','7113','7114',
                                                  '7121','7122','7123','7124'
                                                  )
                     and c_cretip not in ('13','11','12'); --Eliminar creditos hipotecarios
                  
                  If ln_salpym > 0 Then
                     lv_deupym := 'S';
                     ld_fecha  := last_day(add_months(ld_minrcc,-1));
                  Else
                     ld_fecha  := last_day(add_months(ld_fecha,-1));   
                  End If;  
              Exit When ld_fecha < ld_minrcc;
              End Loop;   
          Else
              lv_deupym := 'S';
          End If;  
          
          --- Endeudamiento al momento del desembolso desde 01/Jul/2013
          --- Antes del 25 2 meses aneriores, depués 1 mes anterior
          If x.bcfval >= ld_fecmig Then
             If to_number(to_char(x.bcfval,'DD')) > 25 Then
                ld_rccdes := last_day(add_months(x.bcfval,-1));
             Else
                ld_rccdes := last_day(add_months(x.bcfval,-2));
             End If;   
             ld_mindes := add_months(ld_rccdes,-5);
             
             /*For z in c_deud(lv_codsbs,ld_mindes,ld_rccdes) Loop
                 If z.d_fecpre = ld_mindes Then ln_deud1 := z.n_salcap-nvl(z.n_salint,0);
                 Elsif z.d_fecpre = last_day(add_months(ld_mindes,1)) Then ln_deud2 := z.n_salcap-nvl(z.n_salint,0); 
                 Elsif z.d_fecpre = last_day(add_months(ld_mindes,2)) Then ln_deud3 := z.n_salcap-nvl(z.n_salint,0); 
                 Elsif z.d_fecpre = last_day(add_months(ld_mindes,3)) Then ln_deud4 := z.n_salcap-nvl(z.n_salint,0); 
                 Elsif z.d_fecpre = last_day(add_months(ld_mindes,4)) Then ln_deud5 := z.n_salcap-nvl(z.n_salint,0); 
                 Elsif z.d_fecpre = ld_rccdes Then ln_deud6 := z.n_salcap-nvl(z.n_salint,0); 
                 End If;  
             End Loop; */
              ld_fecha := ld_mindes;
              Loop
                  For z in c_deud(lv_codsbs,ld_fecha) Loop
                     If z.d_fecpre = ld_mindes Then ln_deud1 := nvl(z.n_salcap,0)-nvl(z.n_salint,0);
                     Elsif z.d_fecpre = last_day(add_months(ld_mindes,1)) Then ln_deud2 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                     Elsif z.d_fecpre = last_day(add_months(ld_mindes,2)) Then ln_deud3 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                     Elsif z.d_fecpre = last_day(add_months(ld_mindes,3)) Then ln_deud4 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                     Elsif z.d_fecpre = last_day(add_months(ld_mindes,4)) Then ln_deud5 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                     Elsif z.d_fecpre = ld_rccdes Then ln_deud6 := nvl(z.n_salcap,0)-nvl(z.n_salint,0); 
                     End If; 
                  End Loop;
                  ld_Fecha := add_months(ld_fecha,1);
              Exit When ld_fecha > ld_rccdes;
              End Loop;
           
             
             If lv_codfin in ('C','HC') Then
                ln_salpym := 0; 
                 --Revisa si Consumo tiene deuda Pyme
                 /*Select sum(n_salcap) into ln_salpym
                   from cldrccs 
                  where c_codsbs = lv_codsbs and d_fecpre between ld_mindes and ld_rccdes 
                   and substr(c_cuenta,1,4) in ('1411','1413','1414','1415','1416',
                                                '1421','1423','1424','1425','1426',
                                                '7111','7112','7113','7114',
                                                '7121','7122','7123','7124'
                                               )
                   and c_cretip not in ('13','11','12'); --Eliminar creditos hipotecarios 
                  
                  If ln_salpym > 0 Then
                     lv_pymdes := 'S';
                  Else
                     lv_pymdes := 'N';    
                  End If;  */
                  ld_fecha  := ld_rccdes;
                  lv_deupym := 'N';
                  Loop
                      Select sum(n_salcap) into ln_salpym
                        from cldrccs 
                       where c_codsbs = lv_codsbs 
                         and d_fecpre = ld_fecha 
                         and substr(c_cuenta,1,4) in ('1411','1413','1414','1415','1416',
                                                      '1421','1423','1424','1425','1426',
                                                      '7111','7112','7113','7114',
                                                      '7121','7122','7123','7124'
                                                      )
                         and c_cretip not in ('13','11','12'); --Eliminar creditos hipotecarios
                      
                      If ln_salpym > 0 Then
                         lv_deupym := 'S';
                         ld_fecha  := last_day(add_months(ld_mindes,-1));
                      Else
                         ld_fecha  := last_day(add_months(ld_fecha,-1));   
                      End If;  
                  Exit When ld_fecha < ld_mindes;
                  End Loop; 
              
              Else
                  lv_pymdes := 'S';
              End If; 
            
          End If;  
       
          /*Update fsh012_140ct set deumes1=ln_deu1,deumes2=ln_deu2,deumes3=ln_deu3,deumes4=ln_deu4,deumes5=ln_deu5,
                                  deumes6=ln_deu6,ultrcc=ld_fecrcc,prircc=ld_minrcc,hisrcc=decode(ln_hisrcc,0,'N','S'),
                                  tipcre=ln_tipc, destcr = lv_desc, codfin = x.codfin,codsbs = lv_codsbs,
                                  venact = ln_venan1, venant=ln_venan2,numins=ln_numins
           where bcemp = x.bcemp 
             and bcsuc = x.bcsuc 
             and bcpap = x.bcpap 
             and bcmda = x.bcmda 
             and bccta = x.bccta 
             and bcoper= x.bcoper
             and bcsbop= x.bcsbop
             and bctop = x.bctop;*/
       End If;
       
       
       
       
       --Else
          Update tipcre set deumes1=ln_deu1,deumes2=ln_deu2,deumes3=ln_deu3,deumes4=ln_deu4,deumes5=ln_deu5,
                            deumes6=ln_deu6,ultrcc=ld_fecrcc,prircc=ld_minrcc,hisrcc=decode(ln_hisrcc,0,'N','S'),
                            tipcre=ln_tipc, destcr = lv_desc, codfin = lv_codfin,codsbs = lv_codsbs,
                            venact = ln_venan1, venant=ln_venan2,numins=ln_numins,deupym=lv_deupym,
                            deudem1=ln_deud1,deudem2=ln_deud2,deudem3=ln_deud3,deudem4=ln_deud4,deudem5=ln_deud5,
                            deudem6=ln_deud6,pymdes=lv_pymdes--, regact = 'S'
           where bcemp = x.bcemp 
             and bcsuc = x.bcsuc 
             and bcpap = x.bcpap 
             and bcmda = x.bcmda 
             and bccta = x.bccta 
             and bcoper= x.bcoper
             and bcsbop= x.bcsbop
             and bctop = x.bctop
             and bcmod = x.bcmod;
       --End If;  
     End If;
     Commit;    
  End Loop;  
 End sp_tipifica_base;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 Procedure sp_instancia_segmento
 Is
 
   cursor c_datos
       is select bcemp,bcsuc,bcmda,bcpap, bccta,bcoper,bcsbop,bctop,bcmod,
                 bcmodo, bctopo, bcsbopo, bcopero, petipo
            from tipcre
           where numins is null
             and bcmod not in (108,117); 
   ln_numins number(9);
   ln_seccli number(2);
begin
   for x in c_datos loop
       ln_numins := null;
       ln_seccli := null;
       -- Nro.Instancia
       --ln_numins := fn_instancia_credito(x.bcmodo,x.bcsuc,x.bcmda,x.bcpap,x.bccta,x.bcoper,x.bcsbopo,x.bctopo);
       If (x.bcmod in (116,200) or  x.bctop <> 550) Then 
           
                    Begin 
                        Select x700.xwfprcins Into ln_numins
                          From xwf700 x700
                         Where x700.xwfempresa  = x.bcemp
                           and x700.xwfmodulo   = x.bcmodo
                           and x700.xwfmoneda   = x.bcmda
                           and x700.xwfpapel    = x.bcpap
                           and x700.xwfcuenta   = x.bccta
                           and x700.xwfoperacion= x.bcopero
                           and x700.xwfsubope   = x.bcsbopo
                           and x700.xwftipope   = x.bctopo
                           and x700.xwfcar3     = '1';
                     Exception When Others Then
                       Select max(x700.xwfprcins) Into ln_numins
                          From xwf700 x700
                         Where x700.xwfempresa  = x.bcemp
                           and x700.xwfmodulo   = x.bcmodo
                           and x700.xwfmoneda   = x.bcmda
                           and x700.xwfpapel    = x.bcpap
                           and x700.xwfcuenta   = x.bccta
                           and x700.xwfoperacion= x.bcopero
                           and x700.xwfsubope   = x.bcsbopo
                           and x700.xwftipope   = x.bctopo;
                    End;           
       Else
                      --Begin
                      Begin
                          Select x700.xwfprcins Into ln_numins
                            from xwf700 x700
                           where x700.xwfempresa  = x.bcemp
                             and x700.xwfmodulo   = x.bcmod
                             and x700.xwfmoneda   = x.bcmda
                             and x700.xwfpapel    = x.bcpap
                             and x700.xwfcuenta   = x.bccta
                             and x700.xwfoperacion= x.bcoper
                             and x700.xwfsubope   = x.bcsbop
                             and x700.xwftipope   = x.bctop
                             and x700.xwfcar3     = '1';
                     Exception When too_many_rows Then
                                    Select max(x700.xwfprcins) Into ln_numins
                                      from xwf700 x700
                                     where x700.xwfempresa  = x.bcemp
                                       and x700.xwfmodulo   = x.bcmod
                                       and x700.xwfmoneda   = x.bcmda
                                       and x700.xwfpapel    = x.bcpap
                                       and x700.xwfcuenta   = x.bccta
                                       and x700.xwfoperacion= x.bcoper
                                       and x700.xwfsubope   = x.bcsbop
                                       and x700.xwftipope   = x.bctop
                                       and x700.xwfcar3     = '1';
                               When Others Then
                                    ln_numins := null; 
                     End;                       
       End IF;
       
       Begin
           Select sng001seg
             Into ln_seccli
             From sng001
            Where sng001inst = ln_numins;   
       Exception When Others Then
           ln_seccli := null;
       End;    
       
       If ln_seccli is null Then
          --Segmento de cuenta cliente
          Begin
              select ctsegm
                into ln_seccli
                from fsd008
               where pgcod = x.bcemp
                 and ctnro = x.bccta; 
          Exception When Others Then
              ln_seccli := null;
          End;
        End If;   
        
        If x.petipo = 'J' and ln_seccli is null Then
           ln_seccli := 1;
        End If;
           
        Update tipcre set numins=ln_numins,segcli=ln_seccli
           where bcemp = x.bcemp
             and bcsuc = x.bcsuc
             and bcpap = x.bcpap
             and bcmda = x.bcmda
             and bccta = x.bccta
             and bcoper= x.bcoper
             and bcsbop= x.bcsbop
             and bctop = x.bctop
             and bcmod = x.bcmod;        
        Commit;
     End Loop;
 End sp_instancia_segmento;              
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 Procedure sp_tipificacion_mensual(PD_FECDES in date)
 Is
 
   Cursor c_cred
       is select pepais, petdoc, pendoc,petipo,bcemp,bcsuc,bcpap,bcmda,bccta,bcoper,
                 bcsbop,bctop,bcmod,
                 codfin, hisdes, insfin, tipcor, venact, venant,
                 deumes1, deumes2, deumes3, deumes4, deumes5, deumes6,deupym,codsbs,
                 deudem1, deudem2, deudem3, deudem4, deudem5, deudem6,pymdes,bcgpo,garhip,
                 mtolin, deslin,
                 case when bcmod = 116 then deslin else bcfval end bcfval ,
                 case when bcmod = 116 then mtolin else bcsdmn end saldomn, cnuevo,
                 segcli, bcctao, bcopero, bcsbopo, bctopo, bcmodo,
                 tcrant,tcdant,secant    
            from tipcre
           where bcmod <> 117;
           
   ln_tipcre number(2);
   lv_destcr varchar2(25);
   ln_secdes number(2);
   ln_indica number(1);
   ln_deusal number(12,2);
   --ln_indmed number(1);
   ld_fecmig date := PD_FECDES;
   ln_pgcod  number(3);
   ln_aomod  number(3);
   ln_aomda  number(4);
   ln_aopap  number(3);
   ln_aocta  number(9);
   ln_aooper number(9);
   ln_aosbop number(3);
   ln_aotope number(3);
   ln_aostat number(3);
   ld_aofe99 date;
   ld_fechis date;
Begin
     For x in c_cred Loop
         ln_tipcre := null;
         lv_destcr := null;
         ln_indica := 0;
         ln_secdes := null;
         ln_pgcod  := null;
         ln_aomod  := null;
         ln_aomda  := null;
         ln_aopap  := null;
         ln_aocta  := null;
         ln_aooper := null;
         ln_aosbop := null;
         ln_aotope := null;
         ln_aostat := null;
         ld_aofe99 := null;
         ld_fechis := null;
         
         If x.bcfval < ld_fecmig Then  --Desembolso anterior a fecha de revisión
            ln_tipcre := x.bcgpo;
            ln_indica := 1;
            If ln_tipcre = 2    Then lv_destcr := 'MICROEMPRESA';
            Elsif ln_tipcre = 3  Then
                  If x.bcmod = 116 Then lv_destcr := 'CONSUMO REVOLVENTE';
                  Else ln_tipcre := 31; lv_destcr := 'CONSUMO NO REVOLVENTE';
                  End If;
            Elsif ln_tipcre = 9  Then lv_destcr := 'CORPORATIVO-SIS.FIN.';
            Elsif ln_tipcre = 10 Then lv_destcr := 'CORPORATIVO';
            Elsif ln_tipcre = 11 Then lv_destcr := 'GRANDE EMPRESA';
            Elsif ln_tipcre = 12 Then lv_destcr := 'MEDIANA EMPRESA';
            Elsif ln_tipcre = 13 Then lv_destcr := 'PEQUEÑA EMPRESA';
            Elsif ln_tipcre = 4  Then lv_destcr := 'HIPOTECARIO';
            End If;
            -- Sector
            If ln_tipcre = 13 Then
               Begin
                   Select j14.jaql114sect
                     Into ln_secdes 
                     From jaql114 j14
                    Where j14.jaql114fech = last_day(PD_FECDES)
                      and j14.jaql114emp  = x.bcemp
                      and j14.jaql114mod  = x.bcmod
                      and j14.jaql114suc  = x.bcsuc
                      and j14.jaql114mda  = x.bcmda
                      and j14.jaql114pap  = x.bcpap
                      and j14.jaql114cta  = x.bccta
                      and j14.jaql114oper = x.bcoper
                      and j14.jaql114sbop = x.bcsbop
                      and j14.jaql114top  = x.bctop;
               Exception When Others Then
                   ln_secdes := null;
               End;      
            End If; 
         ElsIf x.bcmod = 108 Then  --Pignoraticio
                ln_indica := 1;
                ln_tipcre := 3;
                lv_destcr := 'CONSUMO NO REVOLVENTE'; 
         ElsIf x.petipo = 'F' and x.codfin in ('HC','HP') and nvl(x.garhip,'N') = 'S' Then  --Hipotecario
                  ln_indica := 1;
                  ln_tipcre := 4;
                  lv_destcr := 'HIPOTECARIO';  
         ElsIf x.petipo = 'F' and (x.codfin in ('C','HC') or (x.codfin not in ('C','HC') and x.segcli=2))Then
                  ln_indica := 1;
                  If x.bcmod = 116 then
                     ln_tipcre := 31;
                     lv_destcr := 'CONSUMO REVOLVENTE';
                  Else
                     ln_tipcre := 3;
                     lv_destcr := 'CONSUMO NO REVOLVENTE';
                  End If;
         ElsIf nvl(x.cnuevo,'N') = 'N' Then --Cliente Recurrente
             If x.petipo = 'J' or (x.petipo = 'F' and x.codfin not in ('C','HC'))
                  and x.tcrant is not null Then
                  ln_indica := 1;
                  ln_tipcre := x.tcrant;
                  lv_destcr := x.tcdant;  
                  If x.tcrant = 13 Then
                     ln_secdes:= x.secant;
                  End If;      
             End If;     
         End If;      

         If ln_indica = 0 Then
            
            If x.petipo = 'J' Then
                -- Revisar si es algún tipo de corporativo
                If x.tipcor is not null and x.tipcor in (1,2,3,4,5) Then
                   ln_indica := 1;
                   If x.tipcor = 1 Then ln_tipcre := 6; lv_destcr := 'CORPORATIVO-SOBERANO';
                   Elsif x.tipcor = 2 Then ln_tipcre := 7; lv_destcr := 'CORPORATIVO-SEC.PUBL.';
                   Elsif x.tipcor = 3 Then ln_tipcre := 5; lv_destcr := 'CORPORATIVO-BANC.MUL.';
                   Elsif x.tipcor = 4 Then ln_tipcre := 9; lv_destcr := 'CORPORATIVO-SIS.FIN.';
                   Elsif x.tipcor = 5 Then ln_tipcre := 8; lv_destcr := 'CORPORATIVO-INT.VAL.';
                   End If;
                ElsIf (nvl(x.venact,0) > 200000000 and nvl(x.venant,0) > 200000000) Then
                   ln_tipcre := 10;
                   lv_destcr := 'CORPORATIVO';
                   ln_indica := 1;
                ElsIf nvl(x.venact,0) >= 20000000 and nvl(x.venant,0) >= 20000000 Then
                      ln_tipcre := 11;
                      lv_destcr := 'GRANDE EMPRESA';
                      ln_indica := 1;
                End If;      
            Else 
                  ln_deusal:= 0;
                  If nvl(x.deudem1,0) + nvl(x.deudem2,0) + nvl(x.deudem3,0) + 
                     nvl(x.deudem4,0) + nvl(x.deudem5,0) + nvl(x.deudem6,0) <= 0 
                     Then 
                         ln_deusal := x.saldomn;
                  Else
                      If nvl(x.deudem1,0) > 0 Then ln_deusal := x.deudem1; end IF;
                      If (ln_deusal <=0 and nvl(x.deudem2,0) > 0) Or 
                         (ln_deusal > 0 and nvl(x.deudem2,0) > 0 and nvl(x.deudem2,0) <= ln_deusal) 
                         Then ln_deusal := x.deudem2; end IF;
                      If (ln_deusal <=0 and nvl(x.deudem3,0) > 0) Or
                         (ln_deusal > 0 and nvl(x.deudem3,0) > 0 and nvl(x.deudem3,0) <= ln_deusal) 
                         Then ln_deusal := x.deudem3; end IF;
                      If (ln_deusal <=0 and nvl(x.deudem4,0) > 0) Or
                         (ln_deusal > 0 and nvl(x.deudem4,0) > 0 and nvl(x.deudem4,0) <= ln_deusal) 
                         Then ln_deusal := x.deudem4; end IF;
                      If (ln_deusal <=0 and nvl(x.deudem5,0) > 0) Or
                         (ln_deusal > 0 and nvl(x.deudem5,0) > 0 and nvl(x.deudem5,0) <= ln_deusal) 
                         Then ln_deusal := x.deudem5; end IF;
                      If (ln_deusal <=0 and nvl(x.deudem6,0) > 0) Or
                         (ln_deusal > 0 and nvl(x.deudem6,0) > 0 and nvl(x.deudem6,0) <= ln_deusal) 
                        Then ln_deusal := x.deudem6; end IF;
                  End IF;

                  If ln_deusal <= 20000 Then
                     ln_tipcre := 2;
                     lv_destcr := 'MICROEMPRESA';
                     ln_indica := 1;
                  ElsIf ln_deusal > 20000 and ln_deusal <=300000 Then
                     ln_tipcre := 13;
                     lv_destcr := 'PEQUEÑA EMPRESA';
                     ln_indica := 1;
                  ElsIf ln_deusal > 300000 Then
                     ln_tipcre := 12;
                     lv_destcr := 'MEDIANA EMPRESA';
                     ln_indica := 1;
                  End If;
                  
                  If ln_tipcre = 13 Then
                     If ln_deusal > 20000 and ln_deusal<= 75000 Then
                           ln_secdes := 3;
                     Elsif ln_deusal > 75000 and ln_deusal<= 150000 Then 
                           ln_secdes := 2;
                     Elsif ln_deusal > 150000 and ln_deusal<= 300000 Then
                           ln_secdes := 1;
                     End If;   
                  End If;  
            End If;
         End If;

         IF ln_indica = 1 Then --Actualiza tipo de crédito
            update tipcre set tipcred=ln_tipcre, destcrd = lv_destcr, secdes =ln_secdes,actant='T'
             where bcemp = x.bcemp
               and bcsuc = x.bcsuc
               and bcpap = x.bcpap
               and bcmda = x.bcmda
               and bccta = x.bccta
               and bcoper= x.bcoper
               and bcsbop= x.bcsbop
               and bctop = x.bctop
               and bcmod = x.bcmod;
         End If;

         Commit;
     End Loop;
 End sp_tipificacion_mensual;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 Procedure sp_reclasificacion
 Is

   Cursor c_cred
       is select pepais, petdoc, pendoc,petipo,bcemp,bcsuc,bcpap,bcmda,bccta,bcoper,bcsbop,bctop,bcmod,bcfval,
                 bcsdmn saldomn,codfin, hisrcc, insfin, tipcor, venact, venant,
                 deumes1, deumes2, deumes3, deumes4, deumes5, deumes6,deupym,codsbs,
                 tipcred, destcrd, garhip, secdes, mtolin,segcli,actant
            from tipcre
           where bcmod <> 117;--  and pendoc = '23977091    ';
   ln_tipcre number(2);
   lv_destcr varchar2(25);
   ln_indica number(1);
   ln_deusal number(12,2);
   ln_indmed number(1);
   ln_contad number(1);
   ln_indmic number(1);
   ln_indpeq number(1);
   ln_indsec number(1);
   ln_indse1 number(1);
   ln_indse2 number(1);
   ln_indse3 number(1);
   lv_indrec varchar2(1);
Begin
     For x in c_cred Loop
         ln_tipcre := x.tipcred;
         lv_destcr := x.destcrd;
         ln_indica := 0;
         ln_indsec := x.secdes;
         lv_indrec := 'T'; 
         
         If x.bcmod = 108 Then
               ln_indica := 1;
               ln_tipcre := x.tipcred;
               lv_destcr := x.destcrd;
         ElsIf x.petipo = 'F' and x.codfin in ('HC','HP') and nvl(x.garhip,'N') = 'S' Then
               ln_indica := 1;
               ln_tipcre := x.tipcred;
               lv_destcr := x.destcrd;
         ElsIf x.petipo = 'F' and x.codfin = 'HC' and nvl(x.garhip,'N') <> 'S' and nvl(x.deupym,'N') = 'N' Then
               ln_indica := 1;
               ln_tipcre := 3;
               lv_destcr := 'CONSUMO NO REVOLVENTE';  
               lv_indrec := 'R';    
         ElsIf x.petipo='F' and nvl(x.deupym,'N') = 'N'
               and (x.codfin = 'C' or (x.codfin not in ('C','HC') and x.segcli=2))
               Then     
               ln_indica := 1;
               ln_tipcre := x.tipcred;
               lv_destcr := x.destcrd;
         ElsIf x.petipo='F' and nvl(x.deupym,'N') = 'S'
               and (x.codfin = 'C' or 
                    (x.codfin not in ('C','HC') and x.segcli=2) or
                    (x.codfin = 'HC' and nvl(x.garhip,'N') <> 'S')
                   )
               Then
                  ln_indmed := 0; 
                  ln_indica := 1;   
                  If nvl(x.deumes1,0) > 300000 Then
                     ln_indmed := ln_indmed + 1;
                  End If;
                  If nvl(x.deumes2,0) > 300000 Then
                     ln_indmed := ln_indmed + 1;
                  End If;
                  If nvl(x.deumes3,0) > 300000 Then
                     ln_indmed := ln_indmed + 1;
                  End If;
                  If nvl(x.deumes4,0) > 300000 Then
                     ln_indmed := ln_indmed + 1;
                  End If;
                  If nvl(x.deumes5,0) > 300000 Then
                     ln_indmed := ln_indmed + 1;
                  End If;
                  If nvl(x.deumes6,0) > 300000 Then
                     ln_indmed := ln_indmed + 1;
                  End If;
                  
                  If nvl(ln_indmed,0) >= 6 then
                     ln_tipcre := 12;
                     lv_destcr := 'MEDIANA EMPRESA';
                     If ln_tipcre <> x.tipcred Then
                        lv_indrec := 'R';
                     End If;   
                  Else
                     If x.codfin = 'HC' and nvl(x.garhip,'N') <> 'S' Then
                         ln_tipcre := 3;
                         lv_destcr := 'CONSUMO REVOLVENTE';
                         lv_indrec := 'R';
                     Else  
                         ln_tipcre := x.tipcred;
                         lv_destcr := x.destcrd;
                     End If;
                  End If;          
         ElsIf x.petipo = 'J' Then
            -- Revisar si es algún tipo de corporativo
            If x.tipcor is not null and x.tipcor in (1,2,3,4,5) Then
               ln_indica := 1;
               ln_indsec := null;
               --lv_indrec := 'R';
               If    x.tipcor = 1 Then ln_tipcre := 6; lv_destcr := 'CORPORATIVO-SOBERANO';
               Elsif x.tipcor = 2 Then ln_tipcre := 7; lv_destcr := 'CORPORATIVO-SEC.PUBL.';
               Elsif x.tipcor = 3 Then ln_tipcre := 5; lv_destcr := 'CORPORATIVO-BANC.MUL.';
               Elsif x.tipcor = 4 Then ln_tipcre := 9; lv_destcr := 'CORPORATIVO-SIS.FIN.';
               Elsif x.tipcor = 5 Then ln_tipcre := 8; lv_destcr := 'CORPORATIVO-INT.VAL.';
               End If;
            ElsIf (nvl(x.venact,0) > 200000000 and nvl(x.venant,0) > 200000000) Then
               ln_tipcre := 10;
               lv_destcr := 'CORPORATIVO';
               ln_indica := 1;
               ln_indsec := null;
               --lv_indrec := 'R';
            ElsIf nvl(x.venact,0) >= 20000000 and nvl(x.venant,0) >= 20000000 Then
                  ln_tipcre := 11;
                  lv_destcr := 'GRANDE EMPRESA';
                  ln_indica := 1;
                  ln_indsec := null;
            End If;
            If ln_tipcre <> x.tipcred Then
               lv_indrec := 'R';
            End If;   
         End If;
         
         If ln_indica = 0 Then
            ln_indica := 1;
                        
             If nvl(x.deumes1,0)+ nvl(x.deumes2,0)+ nvl(x.deumes3,0)+nvl(x.deumes4,0)+ nvl(x.deumes5,0)+ nvl(x.deumes6,0)>0 
                Then 
                     ln_deusal := 0;
                     ln_contad := 1;
                     ln_indmic := 0;
                     ln_indpeq := 0;
                     ln_indmed := 0;
                     Loop
                         If    ln_contad = 1 Then ln_deusal:= nvl(x.deumes1,0);
                         ElsIf ln_contad = 2 Then ln_deusal:= nvl(x.deumes2,0);
                         ElsIf ln_contad = 3 Then ln_deusal:= nvl(x.deumes3,0);
                         ElsIf ln_contad = 4 Then ln_deusal:= nvl(x.deumes4,0);
                         ElsIf ln_contad = 5 Then ln_deusal:= nvl(x.deumes5,0);
                         ElsIf ln_contad = 6 Then ln_deusal:= nvl(x.deumes6,0);
                         End If; 
                         -- Evalúa Endeudamiento
                         If ln_deusal > 0 and ln_deusal <= 20000 Then
                             ln_indmic := ln_indmic + 1;
                         ElsIf ln_deusal > 0 and ln_deusal > 20000 and ln_deusal <=300000 Then
                             ln_indpeq := ln_indpeq + 1;
                         ElsIf ln_deusal > 0 and ln_deusal > 300000 Then
                             ln_indmed := ln_indmed + 1;
                         End If;
                         ln_contad := ln_contad + 1; 
                     Exit When ln_contad > 6;
                     End Loop;    
                     
                     If ln_indmic >= 6 and ln_indpeq = 0 and ln_indmed = 0 Then
                        ln_tipcre := 2;
                        lv_destcr := 'MICROEMPRESA';
                        ln_indsec := null;
                        --lv_indrec := 'R';
                     ElsIf ln_indmic = 0 and ln_indpeq >= 6 and ln_indmed = 0 Then
                        ln_tipcre := 13;
                        lv_destcr := 'PEQUEÑA EMPRESA';
                        ln_indica := 1;   
                        --lv_indrec := 'R';
                     ElsIf ln_indmic = 0 and ln_indpeq = 0 and ln_indmed >= 6 Then
                        ln_tipcre := 12;
                        lv_destcr := 'MEDIANA EMPRESA';
                        ln_indica := 1;
                        ln_indsec := null;
                        --lv_indrec := 'R';
                     Else
                        ln_tipcre := x.tipcred;
                        lv_destcr := x.destcrd;
                        ln_indica := 1;
                     End If;     
                  Else
                      ln_tipcre := x.tipcred;
                      lv_destcr := x.destcrd;
                      ln_indica := 1;
                  End IF; 
                  If ln_tipcre <> x.tipcred Then
                     lv_indrec := 'R'; 
                  End If;  
            /*Else
                      ln_tipcre := x.tipcred;
                      lv_destcr := x.destcrd;
                      ln_indica := 1;
            End IF;   */   
         End If;

         If ln_indica = 1 Then
           
                  -- Sector de Pequeña Empresa
                  If ln_tipcre = 13 and lv_indrec = 'R' Then  --Endeudamiento Mínimo
                     ln_indsec := 0;
                     If nvl(x.deumes1,0) > 0 Then ln_deusal:= nvl(x.deumes1,0); End If;
                     If (ln_deusal=0 and nvl(x.deumes2,0) >= 0) Or
                        (ln_deusal>0 and nvl(x.deumes2,0)>0 and nvl(x.deumes2,0)<ln_deusal)
                        Then ln_deusal:= nvl(x.deumes2,0);
                     End If;
                     If (ln_deusal=0 and nvl(x.deumes3,0) >= 0) Or
                        (ln_deusal>0 and nvl(x.deumes3,0)>0 and nvl(x.deumes3,0)<ln_deusal)
                        Then ln_deusal:= nvl(x.deumes3,0);
                     End If; 
                     If (ln_deusal=0 and nvl(x.deumes4,0) >= 0) Or
                        (ln_deusal>0 and nvl(x.deumes4,0)>0 and nvl(x.deumes4,0)<ln_deusal)
                        Then ln_deusal:= nvl(x.deumes4,0);
                     End If; 
                     If (ln_deusal=0 and nvl(x.deumes5,0) >= 0) Or
                        (ln_deusal>0 and nvl(x.deumes5,0)>0 and nvl(x.deumes5,0)<ln_deusal)
                        Then ln_deusal:= nvl(x.deumes5,0);
                     End If;    
                     If (ln_deusal=0 and nvl(x.deumes6,0) >= 0) Or
                        (ln_deusal>0 and nvl(x.deumes6,0)>0 and nvl(x.deumes6,0)<ln_deusal)
                        Then ln_deusal:= nvl(x.deumes6,0);
                     End If; 
                     If ln_deusal > 20000 and ln_deusal <= 75000 Then
                        ln_indsec := 3; 
                     ElsIf ln_deusal > 75000 and ln_deusal <=150000 Then
                        ln_indsec := 2; 
                     ElsIf ln_deusal > 150000 and ln_deusal <=300000 Then
                        ln_indsec := 1; 
                     End If;
                  ElsIf ln_tipcre = 13 and nvl(lv_indrec,'X') <> 'R' Then --Endeudamiento Consecutivo 
                     ln_contad := 1;
                     ln_indsec := 0;
                     ln_indse1 := 0;
                     ln_indse2 := 0;
                     ln_indse3 := 0;
                     If nvl(x.deumes1,0) + nvl(x.deumes2,0) + nvl(x.deumes3,0) +
                        nvl(x.deumes4,0) + nvl(x.deumes5,0) + nvl(x.deumes6,0) <= 0 
                        Then ln_deusal := x.mtolin;
                             ln_indsec := 0; 
                     Else   
                         Loop
                             If ln_contad = 1 Then    ln_deusal:= nvl(x.deumes1,0);
                             ElsIf ln_contad = 2 Then ln_deusal:= nvl(x.deumes2,0);
                             ElsIf ln_contad = 3 Then ln_deusal:= nvl(x.deumes3,0);
                             ElsIf ln_contad = 4 Then ln_deusal:= nvl(x.deumes4,0);
                             ElsIf ln_contad = 5 Then ln_deusal:= nvl(x.deumes5,0);
                             ElsIf ln_contad = 6 Then ln_deusal:= nvl(x.deumes6,0);
                             End If; 
                             -- Evalúa Endeudamiento Sector
                             If ln_deusal > 20000 and ln_deusal <= 75000 Then
                                 ln_indse3 := ln_indse3 + 1;
                             ElsIf ln_deusal > 75000 and ln_deusal <=150000 Then
                                 ln_indse2 := ln_indse2 + 1;
                             ElsIf ln_deusal > 150000 and ln_deusal <= 300000 Then
                                 ln_indse1 := ln_indse1 + 1;
                             End If;
                             ln_contad := ln_contad + 1; 
                          Exit When ln_contad > 6;
                          End Loop; 
                          IF ln_indse3 >= 6 and ln_indse2 = 0 and ln_indse1 = 0 Then
                             ln_indsec := 3;
                          ElsIf ln_indse2 >= 6 and ln_indse3 = 0 and ln_indse1 = 0 Then
                             ln_indsec := 2;   
                          ElsIf ln_indse1 >= 6 and ln_indse3 = 0 and ln_indse2 = 0 Then
                             ln_indsec := 1; 
                          Else
                              ln_indsec := x.secdes;
                              --lv_indrec := 'S';
                          End If;      
                          If ln_indsec <> x.secdes Then 
                             lv_indrec := 'S'; 
                          End If;   
                     End If;
                  End If;
         
            update tipcre set tipcre=ln_tipcre, destcr = lv_destcr, sector = ln_indsec, actant=lv_indrec,recreg='S'
             where bcemp = x.bcemp
               and bcsuc = x.bcsuc
               and bcpap = x.bcpap
               and bcmda = x.bcmda
               and bccta = x.bccta
               and bcoper= x.bcoper
               and bcsbop= x.bcsbop
               and bctop = x.bctop
               and bcmod = x.bcmod;
         End If;

         Commit;
     End Loop;
 End sp_reclasificacion;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
end pq_tipifica_11356;
/

