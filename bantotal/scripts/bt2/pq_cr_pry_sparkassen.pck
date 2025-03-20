create or replace package pq_cr_pry_sparkassen is

  -- Author  : HSUAREZ
  -- Created : 7/06/2018 12:28:48 p. m.
  -- Purpose : 
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  procedure sp_antiguedad_rcc(vPepais in number,
                    vPetdoc in number, 
                    vPendoc in char,
                    antrcc out number);
  --------------------------------------------
  procedure sp_lista_negra(Pepais in number,
                           Petdoc in number, 
                           Pendoc in char,
                           flag_ln out char, --si o no
                           ds_ln out char   -- descripcion de lista negra.    
                          );
  --------------------------------------------
  procedure  sp_calificacion_rcc(Pepais in number,
                                 Petdoc in number, 
                                 Pendoc in char,
                                 calfrcc out char --si o no
                                );
  --------------------------------------------
  procedure sobreendeudamiento (Pepais in number,
                                Petdoc in number, 
                                Pendoc in char,
                                pc_existe out varchar --si o no
                               );
  --------------------------------------------
  procedure segmentacion(Pepais in number,
                         Petdoc in number, 
                         Pendoc in char                                
                        );
  --------------------------------------------
  function fn_codsbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in char, pn_cta in number) return varchar2;
  --------------------------------------------
  procedure sp_cr_afiliacion_seguro(pgcod    in number,
                                      sucursal in number,
                                      modulo   in number,
                                      moneda   in number,
                                      papel    in number,
                                      cuenta   in number,
                                      operacion in number,
                                      subope   in number,
                                      titope   in number,
                                      sgcod    in number,
                                      FecAfiliacion out date);
  --------------------------------------------
  procedure segmentacion_sbs(ve_pgcod in number,
                               ve_cuenta in number,
                               ve_modulo in number,
                               tpersona in number,
                               vi_TipoCredito out varchar
                               );
  --------------------------------------------  
  procedure ingresos( c_pepais in number,
                         c_petdoc in number,
                         c_pendoc in char,
                         c_segmento in number,
                         Tingresos out number
                       );   
  --------------------------------------------
  procedure sp_cl_edad(P_D_FECSYS IN DATE,
                                       P_D_FECNAC IN DATE, 
                                       p_n_edad out number 
                                       );     
  --------------------------------------------  
  procedure sp_tipo_persona( c_pepais in number,
                                c_petdoc in number,
                                c_pendoc in char,
                                cod_tpersona out number
                              );                   
end pq_cr_pry_sparkassen;
/

create or replace package body pq_cr_pry_sparkassen is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
  --  <LocalVariable> <Datatype>;
  --begin
  --  <Statement>;
  --  return(<Result>);
  --end;

  --begin
  -- Initialization
  --<Statement>;
  function fn_ultimo_rcc
  return date is
  fecha date;  
  begin
    select
        to_date(tpnro,'ddmmyyyy') 
      into
        fecha
      from fst098
     where tpcod = 7647 
       and tpcorr =12; 
    return fecha; 
  end;
  
  procedure sp_antiguedad_rcc(vPepais in number,
                    vPetdoc in number, 
                    vPendoc in char,
                    antrcc out number) is
  vi_ant_rcc number;
  vi_cta number(9);
  vi_cod_sbs char(10);
  vi_nro_mes number;
  cont number;
  temp_anno number;
  aux2 number;
  vi_fecrcc date;
  begin
     begin
       select tpnro        
         into vi_nro_mes
         from fst098
        where pgcod  = 1
          and tpcod  = 7638
          and tpcorr = 88;
     exception
      when no_data_found then
        vi_nro_mes := 0;
     end;     
     begin
        temp_anno := (vi_nro_mes/12);
        aux2:=0;
        vi_fecrcc := pq_cr_pry_sparkassen.fn_ultimo_rcc;
        cont:=0;
        While cont<temp_anno
        loop
        vi_fecrcc := ADD_MONTHS(vi_fecrcc,-12);
        cont := cont + 1;
        end loop;
        temp_anno := (vi_nro_mes)-(cont*12);

        If temp_anno>0 then
           vi_fecrcc := ADD_MONTHS(vi_fecrcc,(-1*temp_anno));
        End if;
      
       select ctnro
         into vi_cta
         from fsr008 f
        where f.pepais = vPepais
          and f.petdoc = vPetdoc
          and f.pendoc = vPendoc
          and f.cttfir = 'T'
          and rownum=1;
          
        vi_cod_sbs   := pq_cr_pry_sparkassen.fn_codsbs(vPepais,vPetdoc,vPendoc,vi_cta);
     exception
     when no_data_found then
        vi_cta := 0;
     end;
     begin
       select count(*)
         into vi_ant_rcc 
         from cldrcci
        where d_fecpre >= vi_fecrcc
          and c_codsbs  = vi_cod_sbs
          and c_tipreg  = '1'
          and c_tipdet  = 'Z';
     exception
     when no_data_found then
        vi_ant_rcc := 0;    
     end;
     antrcc := vi_ant_rcc; 
  end sp_antiguedad_rcc;
  procedure sp_lista_negra(Pepais in number,
                           Petdoc in number, 
                           Pendoc in char,
                           flag_ln out char, --si o no
                           ds_ln out char   -- descripcion de lista negra.    
                          ) is
  vi_codLista number;
  begin 
    begin
      select 'Si',
             tlis
        into flag_ln,
             vi_codLista
        from FSD201
        where lnpais = Pepais
          and lntdoc = Petdoc 
          and lnndoc = Pendoc;
    exception
     when no_data_found then
        vi_codLista := 0;
        flag_ln:='No';
    end;
    begin
       Select
          TLisDe
       into
          ds_ln 
       from fst501
       where Tlis = vi_codLista;      
    exception
     when no_data_found then
        ds_ln := 'No tiene';
    end;    
  end sp_lista_negra;
  procedure  sp_calificacion_rcc(Pepais in number,
                                 Petdoc in number, 
                                 Pendoc in char,
                                 calfrcc out char --si o no
                                ) is
  vi_fecrcc date; 
  
  vi_calif0 number;
  vi_calif1 number;
  vi_calif2 number;
  vi_calif3 number;
  vi_calif4 number;
  
  begin
    begin
       vi_fecrcc := pq_cr_pry_sparkassen.fn_ultimo_rcc;
        if Petdoc <>9 then --RUC
          --Persona natural.
          begin
            select
                n_calif0,
                n_calif1,
                n_calif2,
                n_calif3,
                n_calif4
              into
                vi_calif0,
                vi_calif1,
                vi_calif2,
                vi_calif3,
                vi_calif4
              from cldrcci c 
             where c.D_FECPRE= vi_fecrcc --Fecha del Ultimo RCC
               and c.C_TDOCID= 1            --Tipo de Documento SBS
               and c.C_DOCIDE= Pendoc;      --Numero de Documento
           exception
           when no_data_found then
                vi_calif0:=0;
                vi_calif1:=0;
                vi_calif2:=0;
                vi_calif3:=0;
                vi_calif4:=0;
           end;
        else
          --Persona juridica.
          begin
            select
                n_calif0,
                n_calif1,
                n_calif2,
                n_calif3,
                n_calif4
              into
                vi_calif0,
                vi_calif1,
                vi_calif2,
                vi_calif3,
                vi_calif4
              from cldrcci c 
             where c.D_FECPRE= vi_fecrcc --Fecha del Ultimo RCC
               and c.C_TDOCTR= 2            --Tipo de rubro SBS
               and c.C_DOCTRI= Pendoc;      --RUC
           exception
           when no_data_found then
                vi_calif0:=0;
                vi_calif1:=0;
                vi_calif2:=0;
                vi_calif3:=0;
                vi_calif4:=0;
           end;
        end if;         
        if vi_calif0>0 then
           calfrcc := 'NORMAL'; 
        end if;
        if vi_calif1>0 then
           calfrcc := 'C.P.P.';
        end if;
        if vi_calif2>0 then
           calfrcc := 'DEFICIENTE';
        end if;
        if vi_calif3>0 then
           calfrcc := 'DUDOSO';
        end if;
        if vi_calif4>0 then
           calfrcc := 'PERDIDA';
        end if;
        if vi_calif0=0 and vi_calif1=0 and vi_calif2=0 and vi_calif3=0 and  vi_calif4=0 then
           calfrcc := 'NORMAL';
        end if;
    end;      
  end sp_calificacion_rcc; 
  
  procedure sobreendeudamiento (Pepais in number,
                                Petdoc in number, 
                                Pendoc in char,
                                pc_existe out varchar --si o no
                               )is
    P_SOBREENDEU  varchar2(100); 
    P_DIRECTA     number;
    P_POTENCIAL   number;
    P_TOTAL       number;
    P_RESULTADO   number;
    P_NUMENTIDAD  number;
    p_existe      number;
    begin
        PQ_CR_CENTRAL_RIESGOS.SP_SOBREENDEUDAMIENTO(
                                                    Pepais,
                                                    Petdoc,
                                                    Pendoc,                                                                        
                                                    P_SOBREENDEU,  --OUT VARCHAR2,
                                                    P_DIRECTA,     --OUT NUMBER,
                                                    P_POTENCIAL,   --OUT NUMBER,
                                                    P_TOTAL,       --OUT NUMBER,
                                                    P_RESULTADO,   --OUT NUMBER,
                                                    P_NUMENTIDAD,  --OUT NUMBER,
                                                    p_existe       --OUT number indica si esta con 1 o 0
                                                   );
         if P_SOBREENDEU = 'Cliente expuesto a Riesgo de Sobre endeudamiento' then
            pc_existe:='Si';
         else
            pc_existe:='No';
         end if;                                                   
         /*if p_existe=0 then
           pc_existe:='No';
         else
           pc_existe:='Si';
         end if;*/
     end sobreendeudamiento;

  procedure segmentacion(Pepais in number,
                         Petdoc in number, 
                         Pendoc in char
                                
                        )is
     anno number;
     mes  number;
     dia  number;
     cursor lista_calificacion(c_pepais in number,
                               c_petdoc in number,
                               c_pendoc in char,
                               c_anno   in number,
                               c_mes    in number
                              ) is
      select jaqy066calf
        from jaqy066
       Where jaqy066pano = c_anno 
         and jaqy066pmes = c_mes 
         and jaqy066paic = c_Pepais 
         and jaqy066tdoc = c_Petdoc 
         and jaqy066tndoc= c_Pendoc
         and jaqy066tse  = 'A';      
                         
     
     
     
     vi_calf number(5);
     num_calif number;
     v_ind number;
     vi_pgfapea date;
     vi_pgfape date;
     vi_fec_aux date;
     vi_ncalif varchar2(200);
     vi_invi varchar2(1);
     begin
           begin
             select pgfape
               into vi_pgfape
               from fst017 
               where Pgcod=1;
           end;
           v_ind := 1;
           --vi_pgfapea:= vi_pgfape-1*v_ind;
           select LAST_DAY(ADD_MONTHS(vi_pgfape,-1*v_ind)) 
             into vi_fec_aux
             from dual;  
           
           select to_char(vi_fec_aux, 'YYYY')
             into anno
             from dual;
           select to_char(vi_fec_aux, 'MM') 
             into mes
             from dual;
           select to_char(vi_fec_aux, 'DD') 
             into dia
             from dual;
          begin
            for i in lista_calificacion(Pepais,
                                         Petdoc,
                                         Pendoc,
                                         anno,
                                         mes
                                        )   loop
               begin
                 select jaqy067ncal,
                        jaqy067invi
                   into vi_ncalif,
                        vi_invi
                   from jaqy067
                  where jaqy067ccal = i.jaqy066calf
                    and jaqy067coes = 'S';
                   exit;
               exception 
                 when no_data_found then
                   vi_ncalif := 'NO PRECALIFICA AL '+vi_pgfape;
               end;  
            end loop;
           
                                  
            end;   
          
       end segmentacion;
    function fn_codsbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in char, pn_cta in number) return varchar2
    is
    lc_codsbs varchar2(10);
    begin
      begin

        select lpad(to_char(c.bc739sbs),10,0)
          into lc_codsbs
          from  fbc739 c
         where c.bc739pais = pn_pepais
           and c.bc739tdoc = pn_petdoc
           and c.bc739ndoc = pc_pendoc
           and c.bc739cta  = pn_cta;
      exception
          when others then
             lc_codsbs := null;
      end;
       return lc_codsbs;
    end fn_codsbs;
    procedure sp_cr_afiliacion_seguro(pgcod    in number,
                                      sucursal in number,
                                      modulo   in number,
                                      moneda   in number,
                                      papel    in number,
                                      cuenta   in number,
                                      operacion in number,
                                      subope   in number,
                                      titope   in number,
                                      sgcod    in number,
                                      FecAfiliacion out date) is
      begin
          Select jaqy782fchdes
          into   FecAfiliacion
          from jaqy782
         Where jaqy782pgc = pgcod    
          and jaqy782mod  = modulo 
          and jaqy782suc  = sucursal  
          and jaqy782mda  = moneda   
          and jaqy782pap  = papel    
          and jaqy782cta  = cuenta   
          and jaqy782ope  = operacion
          and jaqy782sbo  = subope   
          and jaqy782top  = titope   
          and jaqy782sgc  = sgcod;   
      exception 
        when no_data_found then
             begin
                   Select jaqm251fec
                      into FecAfiliacion
                      from jaqm251
                     Where jaqm251pgc = pgcod    
                       and jaqm251mod = modulo 
                       and jaqm251suc = sucursal   
                       and jaqm251mda = moneda   
                       and jaqm251pap = papel    
                       and jaqm251cta = cuenta   
                       and jaqm251ope = operacion
                       and jaqm251sbo = subope   
                       and jaqm251top = titope   
                       and jaqm251sgc = sgcod;
             exception
               when no_data_found then
                  begin
                    select min(ppfpag)
                    into FecAfiliacion
                    from fsd612 
                    where pgcod =  pgcod    
                    and   ppmod =  modulo 
                    and   ppsuc =  sucursal 
                    and   ppmda =  moneda   
                    and   pppap =  papel   
                    and   ppcta =  cuenta    
                    and   ppoper=  operacion
                    and   ppsbop=  subope   
                    and   pptope=  titope;   
                  exception 
                    when no_data_found then
                         FecAfiliacion := null;
                  end;               
             end;
      end sp_cr_afiliacion_seguro;        
    procedure segmentacion_sbs(ve_pgcod in number,
                               ve_cuenta in number,
                               ve_modulo in number,
                               tpersona in number,
                               vi_TipoCredito out varchar
                               ) 
                               is
    vi_scgru fsd011.scgru%type;
    vi_scrub fsd011.scrub%type;
    vi_scmod fsd011.scmod%type;
    vi_scmda fsd011.scmda%type;
    vi_sccta fsd011.sccta%type;
    ve_segmento char(30);
    --tpersona number;
    --vi_TipoCredito varchar(100);
    SubScrub varchar(2);
    cod_grupo number;
    Scgru1 number;
      begin
        
            begin
              begin
                select 
                       Scgru, --Tipo de credito
                       Scrub, -- Tipo de credito digitos 5 y 6        
                       scmda,
                       scmod,
                       sccta            
                into 
                       vi_scgru,
                       vi_scrub,
                       vi_scmda,
                       vi_scmod,
                       vi_sccta                     
                from fsd011
                where pgcod  = ve_pgcod
                  and sccta  = ve_cuenta                                 
                  and scmod  = ve_modulo
                  and rownum=1;
               exception 
                 when no_data_found then
                      
                      vi_scgru :=0;  
                      vi_scrub :=0;
               end;
                SubScrub := SubStr(vi_scrub,9,2);   --en el campo rubro (SCRUB) extraer los dígitos 9 y 10, 
                                                 --si es 01 corresponde a Consumo Revolvente, caso contrario 
                                                 --es Consumo No Revolvente
                if vi_scgru  <> 3  then
                    begin
                       select  Tpdesc
                       into    vi_TipoCredito
                       from fst098
                       where tpcod  =3048
                         and tpcorr>=101
                         and tpcorr<=113  
                         and tpimp  = vi_scgru;
                    exception
                      when no_data_found then
                        vi_TipoCredito  := 'No descripción';
                    end;
                    begin
                      if vi_scgru <> 3 then
                         Scgru1 := vi_scgru;
                         
                      end if;
                    end;
                Else
                    If SubScrub = '01' then
                        vi_TipoCredito := 'CONSUMO REVOLVENTE';
                    Else
                        vi_TipoCredito := 'CONSUMO NO REVOLVENTE';
                    End If;
                    
                End If;
                
            end;
            ve_segmento := UPPER(vi_TipoCredito);
            if tpersona = 2 then
              vi_TipoCredito := 'PERSONA';
            else              
                begin
                  select tp1nro2 
                  into   cod_grupo
                  from fst198
                 where tp1cod1  = 11105
                   and tp1corr1 = 6
                   and tp1corr2 = 1
                   --and tp1corr3 > 1
                   and tp1desc  = ve_segmento;
                exception 
                 when no_data_found then
                   cod_grupo := null;
                end;
              
                begin
                  select tp1desc   
                    into vi_TipoCredito
                    from fst198
                   where tp1cod1  = 11105
                     and tp1corr1 = 6
                     and tp1corr2 = 2
                     --and tp1corr3 > 1
                     and tp1nro1  = cod_grupo;
                exception
                  when no_data_found then
                       ve_segmento:='NEGOCIO';
                       vi_TipoCredito := ve_segmento;
                end;
            end if;
            
        end segmentacion_sbs;
     ------------------------------------------------------------------------------
     ------------------------------------------------------------------------------   
     procedure ingresos( c_pepais in number,
                         c_petdoc in number,
                         c_pendoc in char,
                         c_segmento in number,
                         --tpersona in number,
                         Tingresos out number
                       )   
                       is
     vi_eval number;
     vi_instancia number;
     cod_eval number;
     begin
            begin
                 select max(x.xwfprcin)
                   into vi_instancia
                 from xwf070 x where x.xwfprcin in 
                      (select a.sng021sol from sng021 a where a.sng021ndoc = c_pendoc); /*and sng021fec=(select max(sng021fec) from sng021 s where s.sng021ndoc=a.sng021ndoc) and rownum=1);*/
            exception
              when no_data_found then
                vi_instancia :=null;
            ---
            end;
            begin
                select sng021eval
                  into vi_eval  
                  from sng021 
                 where sng021sol = vi_instancia;
            exception
              when no_data_found then
                vi_eval := null;
            ---
            end;
            begin
              select tp1nro2   
                into cod_eval
                from fst198
               where tp1cod1  = 11105
                 and tp1corr1 = 6
                 and tp1corr2 = 3
                 and tp1corr3 > 1
                 and tp1nro1  = c_segmento;
            exception
              when no_data_found then
                cod_eval := null;
            end;
            begin 
                select sng023mto
                  into Tingresos
                  from sng023  
                 where sng021eval = vi_eval
                   and sng026cod  = cod_eval;
            exception
              when no_data_found then
                Tingresos:=0;
            end;                      
                                         
     end ingresos;
     procedure sp_cl_edad(P_D_FECSYS IN DATE,
                                       P_D_FECNAC IN DATE, 
                                       p_n_edad out number 
                                       ) is
      begin
        p_n_edad := trunc(months_between(P_D_FECSYS,P_D_FECNAC)/12,0);
      end sp_cl_edad;
     -----------------------------------------------------------------------
     -----------------------------------------------------------------------
     procedure sp_tipo_persona( c_pepais in number,
                                c_petdoc in number,
                                c_pendoc in char,
                                cod_tpersona out number
                              )
       is
       vi_ocupacion number;
       
       
       begin
         begin
           select sngc60ocup
             into vi_ocupacion
             from sngc60 s 
            where s.sngc60pais = c_pepais
              and s.sngc60tdoc = c_petdoc
              and s.sngc60ndoc = c_pendoc;
         exception
           when no_data_found then
              vi_ocupacion := null;  
         end;
         begin
            select c.Segcod
              into cod_tpersona
              from sngc07 c
             where sngc07cod = vi_ocupacion;
           exception
             when no_data_found then
               cod_tpersona:=2;
           end;     
         --Si cod_tpersona es :
         --2 dependiente
         --1 independiente
       end;
       ---------------------------------------------------------------------
       ---------------------------------------------------------------------
end pq_cr_pry_sparkassen;
/

