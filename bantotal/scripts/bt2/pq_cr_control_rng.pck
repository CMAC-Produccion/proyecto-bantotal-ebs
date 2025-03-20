create or replace package PQ_CR_CONTROL_RNG is

  -- Author  : HSUAREZ
  -- Created : 17/07/2018 7:19:59 p. m.
  -- Purpose : 
  
  -- Public type declarations
  procedure sp_cr_inicio_actividades( ve_pais  in fsr008.pepais%type,
                                      ve_ptdoc in fsr008.petdoc%type,
                                      ve_pndoc in char,
                                      ve_fecing out fsd002.pffibc%type);
  procedure Sp_cr_avales_mora ( ln_Instancia in number,
                                vd_Pgfape in date,
                                ln_respuesta out char);

end PQ_CR_CONTROL_RNG;
/

create or replace package body PQ_CR_CONTROL_RNG is
  --------------------------------------------------------------------------------------
  procedure sp_cr_inicio_actividades( ve_pais  in fsr008.pepais%type,
                                      ve_ptdoc in fsr008.petdoc%type,
                                      ve_pndoc in char,
                                      ve_fecing out fsd002.pffibc%type) is
   
  tmp_fecing date;
  vi_fingreso_empresa  date;
  vi_fingreso_empleado date;
  vi_ruc sngc60.sngc60erut%type;
  begin    
    begin
      select PFFIBC
        into tmp_fecing 
        from fsd002 
       where pfpais = ve_pais
         and pftdoc = ve_ptdoc 
         and pfndoc = ve_pndoc
         and pfebco = 'S';
    exception
      when others then
        null;
        --tmp_fecing := '01/01/1800';
    end; 
    if tmp_fecing is null then
       begin
         select s6.sngc60erut,
                s6.sngc60fine,
                s6.sngc60fini  
           into vi_ruc,
                vi_fingreso_empresa,
                vi_fingreso_empleado  
         from sngc60 s6
         where s6.sngc60pais = ve_pais 
          and  s6.sngc60tdoc = ve_ptdoc
          and  s6.sngc60ndoc = ve_pndoc
          and  rownum=1; 
       exception
         when others then
--             null;     
             vi_fingreso_empresa  := TO_DATE('01011800','DDMMYYYY');
             vi_fingreso_empleado := TO_DATE('01011800','DDMMYYYY');
       end;
       if vi_fingreso_empresa is not null/*> '01/01/1900'*/ then
          ve_fecing :=  vi_fingreso_empresa;
       end if;
       if vi_fingreso_empleado is not null/*> '01/01/1900'*/ then
          ve_fecing :=  vi_fingreso_empleado;
       end if;
       if tmp_fecing is not null/*> '01/01/1900'*/ then
          ve_fecing :=  tmp_fecing;
       end if;
    else
        ve_fecing :=  tmp_fecing;
    end if;
  end;
  -------------------------------------------------------------------------------------------------
 
 procedure Sp_cr_avales_mora ( ln_Instancia in number,
                                vd_Pgfape in date,
                                ln_respuesta out char)is
  
  lc_nrodoc fsr008.pendoc%type;
  cont_avales number;
  vn_tpnro number;   
   cursor lista_Integrantes (vcuentas in number) is
      select distinct (trim(f.pendoc)) documento,
                      f.pepais pais,
                      f.petdoc tipodocumento
       from fsr008 f
       where f.ctnro = vcuentas;
   cursor lista_cuentas_int (ln_pais in number,ln_petd in number,ln_pnd in char) is
          select distinct ctnro
                     from fsr008 f  
                     where pepais = ln_pais
                       and petdoc = ln_petd
                       and pendoc = ln_pnd;                                 
   cursor lista_avales is
      select distinct (trim(f.pendoc)) avaldocumento,
                      f.pepais avalpais,
                      f.petdoc avaltipodocumento
       from fsr008 f
       where f.ctnro in (select d.sng003cta
                           from sng003 d
                          where d.sng001inst = ln_Instancia);
   begin
     begin
        select tpnro into vn_tpnro from fst098 where pgcod=1 and tpcod=7721 and tpcorr=1;                  
     end;
     for a in lista_avales loop
                 lc_nrodoc := trim(A.AVALDOCUMENTO);
              begin
                    select count(*) 
                    into cont_avales from fsd010,(
                      select fsr008.ctnro from fsr008     
                        where fsr008.pepais=a.avalpais
                        and fsr008.petdoc  =a.avaltipodocumento
                        and fsr008.pendoc  =lc_nrodoc
                        /*and fsr008.cttfir='T'*/) cuentas
                        where fsd010.pgcod=1 
                        and fsd010.aocta=cuentas.ctnro
                        and fsd010.aostat<>99 --in (select fst026.cecod from fst026 where fst026.cenom like '%REFINA%')
                        and fn_dias_atraso(vd_Pgfape,aocta,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,aostat,aofvto)>vn_tpnro
                        and rownum=1;
                        
                     if cont_avales<>0 then
                       ln_respuesta:='S';
                         exit;
                     end if; 
               exception 
                 when no_data_found then
                        cont_avales := 0;
               end;
               
               begin 
                 if cont_avales = 0 then
                    for avc in lista_cuentas_int(a.avalpais,a.avaltipodocumento,a.avaldocumento) loop
                        for itg in lista_Integrantes(avc.ctnro) loop
                                lc_nrodoc := trim(itg.documento);
                                begin
                                  select count(*) 
                                  into cont_avales from fsd010,(
                                    select fsr008.ctnro from fsr008     
                                      where fsr008.pepais=itg.pais
                                      and fsr008.petdoc  =itg.tipodocumento
                                      and fsr008.pendoc  =lc_nrodoc
                                      /*and fsr008.cttfir='T'*/) cuentas
                                      where fsd010.pgcod=1 
                                      and fsd010.aocta=cuentas.ctnro
                                      and fsd010.aostat<>99 --in (select fst026.cecod from fst026 where fst026.cenom like '%REFINA%')
                                      and fn_dias_atraso(vd_Pgfape,aocta,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,aostat,aofvto)>vn_tpnro
                                      and rownum=1;
                                  end;
                          end loop;
                      end loop;
                   end if;
                 exception 
                    when no_data_found then
                      cont_avales := 0;
               end;
            end loop;
            begin
                if cont_avales>0 then
                   ln_respuesta := 'S';
                else
                   ln_respuesta := 'N';
                end if;
                  
            end;
     end Sp_cr_avales_mora;
     ------------------------------------------------------------------------------------------------------------
     
end PQ_CR_CONTROL_RNG;
/

