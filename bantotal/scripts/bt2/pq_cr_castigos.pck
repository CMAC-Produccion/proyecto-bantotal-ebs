create or replace package pq_cr_castigos is

  -- Author  : KVALENCIAC
  -- Created : 13/10/2023 16:11:35
  -- Purpose : Paquete de castigos
  -- Author  : KVALENCIAC
  -- Created : 03/09/2024
  -- Purpose : Paquete de castigos se adiciono actualización de numero de propuesto en guía para procesar la contabilización 
  
  procedure sp_otrosdatos(  pn_opcion number,
                            pd_fecha in date,
                            pn_cod  in number,
                            pn_mod  in number,
                            pn_suc  in number,
                            pn_mda  in number,
                            pn_pap  in number,
                            pn_cta  in number,
                            pn_ope  in number,
                            pn_sbo  in number,
                            pn_top  in number,
                            pn_prov out number,
                            pn_pprov out number,
                            pn_calif out number,
                            pc_codsbs out varchar2,
                            pn_intdif out number,
                            pn_estado out number,
                            pc_tipcred out varchar2,
                            pn_garantias out varchar2,
                            pn_montogar out varchar2); 
  procedure sp_provision(pd_FecUltCierre in date,
                        pn_saldo in number, 
                        pn_cod  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_ope  in number,
                        pn_sbo  in number,
                        pn_top  in number,
                        pn_Provision out number, 
                        pn_ProvisionP out number) ;                             
 procedure sp_Calificacion(pd_FecUltCierre date,
                           pn_cod  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_ope  in number,
                           pn_sbo  in number,
                           pn_top  in number,
                           pn_Calificacion out number,
                           pv_calificacion out varchar2); 
procedure sp_ActualizaGuia( pn_codemp in number,
                            pn_propuesta  in number);                           
end pq_cr_castigos;
/

create or replace package body pq_cr_castigos is

procedure sp_otrosdatos(pn_opcion number,
                        pd_fecha in date,
                        pn_cod  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_ope  in number,
                        pn_sbo  in number,
                        pn_top  in number,
                        pn_prov out number,--provision
                        pn_pprov out number,--porcentaje de provisión
                        pn_calif out number,
                        pc_codsbs out varchar2,--este modfiqué estaba numérico
                        pn_intdif out number,
                        pn_estado out number,
                        pc_tipcred out varchar2,--este modifiqué a varchar estaba numerico
                        pn_garantias out varchar2,
                        pn_montogar out varchar2
                        ) is
cursor garantias_job is
select R2COD, R2MOD, R2SUC, R2MDA, R2PAP, R2CTA, R2OPER, R2SBOP, R2TOPE  
        from fsr011 j
       where R1COD = pn_cod 
       and   R1MOD = pn_mod 
       and   R1SUC = pn_suc 
       and   R1MDA = pn_mda 
       and   R1PAP = pn_pap 
       and   R1CTA = pn_cta 
       and   R1OPER= pn_ope 
       and   R1SBOP= pn_sbo 
       and   R1TOPE= pn_top 
       and   RELCOD=50 
       and   R011CO='S'
       and   R2TOPE in (select tp1nro1 from fst198 where tp1cod1=10881 and tp1corr1=2 and tp1corr2=2)
union
select SNG122PGC, SNG122MOD, SNG122SUC, SNG122MDA, SNG122PAP, SNG122CTA, SNG122OPER, SNG122SBOP, SNG122TOPE
from sng122 where sng122inst in 
      (select x.xwfprcins from xwf700 x where 
        x.xwfempresa   = pn_cod 
       and x.xwfmodulo    = pn_mod 
       and x.xwfsucursal  = pn_suc 
       and x.xwfmoneda    = pn_mda 
       and x.xwfpapel     = pn_pap 
       and x.xwfcuenta    = pn_cta 
       and x.xwfoperacion = pn_ope 
       and x.xwfsubope    = pn_sbo 
       and x.xwftipope    = pn_top
       and xwfcar3=1)
       and SNG122TOPE in (select tp1nro1 from fst198 where tp1cod1=10881 and tp1corr1=2 and tp1corr2=2);
        
ld_FecUltCierre date;
ln_estadoc number(2);
ln_saldo number(18,2);
ln_rubro number(16);
ln_Provision number(18,2);
ln_ProvisionP number(6,2);
ln_Calificacion number;
lv_Calificacion varchar (15);
ln_Pepais number;
ln_Petdoc number;
lc_Pendoc char(12);
lc_JAQL175CODSBS varchar(10);
lc_JAQL175TIPCRE varchar(3);
ln_rubrotipo number(2);
ln_JAQL175INTDIF number(18,2);
ld_fecpre date;
lc_rubro varchar2(2);
ln_montogar number(18,2);
lc_ngarantia varchar2(300);
ln_bcrubr number(16);
lc_montogar varchar(20);
lc_Cadenagarantias varchar(300);
lc_cadenagarantiasm varchar(300);
begin 
  select last_day(add_months(pd_fecha,-1)) into ld_FecUltCierre from dual;
  ln_saldo:=0;
  ln_rubro:=0;
  ln_estadoc:=0;
    begin 
    select scsdo, scrub, scstat
       into ln_saldo,ln_rubro, ln_estadoc
    from  fsd011 d  
        where d.pgcod  = pn_cod 
          and d.scmod  = pn_mod         
          and d.SCMDA  = pn_mda 
          and d.SCPAP  = pn_pap 
          and d.SCCTA  = pn_cta 
          and d.SCSUC  = pn_suc 
          and d.SCOPER = pn_ope  
          and d.SCSBOP = pn_sbo
          and d.SCTOPE = pn_top;
    exception
         when no_data_found then
           ln_saldo:=0;
           ln_rubro:=0;
           ln_estadoc:=9;
    end; 
    IF ( ln_saldo<0 ) then
      ln_saldo:= ln_saldo * -1;
    end if; 
    if (pn_opcion = 1 ) then 
         --busca provisión JAQL175PROV - saldo de provisión y JAQL175PROVP 
         --obtiene  provisión y porcentaje de provisión
          pq_cr_castigos.sp_provision(  pd_FecUltCierre=> ld_FecUltCierre,
                                             pn_saldo => ln_saldo,
                                             pn_cod => pn_cod,
                                             pn_mod => pn_mod,
                                             pn_suc => pn_suc,
                                             pn_mda => pn_mda,
                                             pn_pap => pn_pap,
                                             pn_cta => pn_cta,
                                             pn_ope => pn_ope,
                                             pn_sbo => pn_sbo,
                                             pn_top => pn_top,
                                             pn_Provision  => ln_Provision,
                                             pn_ProvisionP => ln_provisionP );   
          --verifica calificación  JAQL175CAL
          pn_prov  := ln_Provision;
          pn_pprov := ln_provisionP;
          pq_cr_castigos.sp_Calificacion(     pd_FecUltCierre=> ld_FecUltCierre,
                                                    pn_cod => pn_cod,
                                                    pn_mod => pn_mod,
                                                    pn_suc => pn_suc,
                                                    pn_mda => pn_mda,
                                                    pn_pap => pn_pap,
                                                    pn_cta => pn_cta,
                                                    pn_ope => pn_ope,
                                                    pn_sbo => pn_sbo,
                                                    pn_top => pn_top,
                                                    pn_Calificacion  => pn_calif,
                                                    pv_calificacion => lv_Calificacion
                                                    );                                             

          
          -- Obtengo el código de la SBS JAQL175CODSBS
          begin
             select Pepais,Petdoc,Pendoc 
                   into ln_Pepais,ln_Petdoc,lc_Pendoc 
             from FSR008  --:Titular Cuenta
             Where PgCod  = pn_cod
             and Ctnro  = pn_cta
             and Ttcod  = 1
             and Cttfir = 'T';
          exception 
            when others then
              ln_Pepais:=0;
              ln_Petdoc:=0;
              lc_Pendoc:='';
          end;
          begin
              select c_codsbs  
                  into lc_JAQL175CODSBS
              from cldrcci
              where c_docide = lc_Pendoc 
              and rownum=1
              order by d_fecpre desc; --sacar al última fecha obtengo el codsbs
          exception
            when no_data_found then
               begin
                  select lpad(to_char(c.bc739sbs), 10, 0)
                  into lc_JAQL175CODSBS
                  from fbc739 c
                 where c.bc739pais = ln_Pepais
                   and c.bc739tdoc = ln_Petdoc 
                   and c.bc739ndoc = lc_Pendoc
                   and c.bc739cta = pn_cta;
                exception
                 when no_data_found then
                   lc_JAQL175CODSBS:=0;
                 end;
          end;
          pc_codsbs := lc_JAQL175CODSBS;
     --Obtener el Tipo de Crédito  &JAQL175TIPCRE
          --si lo obtengo del último rcc
          /*
          begin
            select d_fecpre
            into ld_fecpre
            from cldrcci
            where c_docide = lc_Pendoc 
            and rownum=1
            order by d_fecpre desc;
          exception
            when others then
              ld_fecpre:= null;
          end;
          lc_rubro := to_char(ln_rubro);
          begin
            select distinct a.c_cretip
                                  into lc_JAQL175TIPCRE
                                  from cldrccs a
                                 where a.c_codsbs = lc_JAQL175CODSBS
                                   and a.d_fecpre = ld_fecpre
                                   and a.c_codemp = '00104'
                                   and substr(a.c_cuenta,1,4)=to_char(substr(lc_rubro,1,4))--- rubro del crédito
                                   and rownum=1;---obtengo c_cretip
           exception 
             when others then
                lc_JAQL175TIPCRE:='';
         end;
         */
         -- si lo ontengo de la fsh012 o fsd011 obtengo el rubro del crédito y obtengo el 5 y 6 dígito
         --si es de la fsd011
         --ln_rubrotipo := substr(lc_rubro,5,2);
         --lo obtengo de la fsh012 del cierre del mes anterior
         begin
         select /*+index(FSH012 FSH01204)*/ bcgpo,bcrubr into ln_rubrotipo, ln_bcrubr ---BCEMP, BCFECH, BCRUBR, BCCTA
             from fsh012 
             where BCEMP=1 
             and bcfech = ld_FecUltCierre 
             and ( BCRUBR like '14_1%' or BCRUBR like '14_4%' or BCRUBR like '14_5%' or BCRUBR like '14_6%') 
             and bccta  = pn_cta
             and bcoper = pn_ope
             and bcmda  = pn_mda;             
        exception
          when others then
            ln_rubrotipo :=0;
            ln_bcrubr :=0;
        end;
         case
           when ln_rubrotipo = 2 then
            lc_JAQL175TIPCRE:= '10';--'MICROEMPRESAS'
           when ln_rubrotipo = 3 and substr(ln_bcrubr, 11, 3) = '015' then
            lc_JAQL175TIPCRE:= '12';--'CONSUMO REVOLVENTE'
           when ln_rubrotipo = 3 and substr(ln_bcrubr, 11, 3) <> '015' then
            lc_JAQL175TIPCRE:= '11';--'CONSUMO NO REVOLVENTE'
           when ln_rubrotipo = 4 then
            lc_JAQL175TIPCRE:= '13';--'HIPOTECARIO'
           when ln_rubrotipo = 12 then
            lc_JAQL175TIPCRE:= '08';--'MEDIANA EMPRESA'
           when ln_rubrotipo = 13 then
            lc_JAQL175TIPCRE:= '09';--'PEQUEÑA EMPRESA'
           when ln_rubrotipo in (5, 6, 7, 8, 9) then
            lc_JAQL175TIPCRE:= '06';--'CORPORATIVO'
           else
             lc_JAQL175TIPCRE:= to_char(ln_rubrotipo);
         end case;
         
         pc_tipcred := lc_JAQL175TIPCRE;
         
   end if;      
   if (pn_opcion=2) then     
    -- Para hallar el interes diferido &JAQL175INTDIF
      ln_JAQL175INTDIF:=0;
      begin
         select scsdo  -- índice PGCOD, SCRUB, SCCTA
              into ln_JAQL175INTDIF
         from  fsd011 d  
         where d.pgcod  = pn_cod 
          and d.scrub like '2911%'
          and d.SCCTA  = pn_cta 
          and d.Scoper = pn_ope
          and d.scmod  = 419;         
       exception
         when no_data_found then
           ln_JAQL175INTDIF:=0;
      end; 
      pn_intdif:= ln_JAQL175INTDIF;
     -- para guardar el estado del  crédito antes de castigar &JAQL175ESTC 
     pn_estado := ln_estadoc;
     --búsqueda de sus garantías solo las garantías reales
     --&JAQL175GARD 
     --&JAQL175GARM
     lc_Cadenagarantias:=' ';
     lc_cadenagarantiasm:=' ';
     BEGIN
      For i in garantias_job loop
        lc_ngarantia:='';
        ln_montogar:=0;
       begin
         select rtrim(tonom) into lc_ngarantia from fst004 where modulo=i.R2MOD and totope=i.R2TOPE;
        exception 
           when others then
              lc_ngarantia:='';
        end;
        begin 
          select scsdo into ln_montogar
          from fsd011 
          where  PGCOD = i.R2COD
             and SCMOD = i.R2MOD
             and SCMDA = i.R2MDA
             and SCPAP = i.R2PAP
             and SCCTA = i.R2CTA
             and SCSUC = i.R2SUC
             and SCOPER= i.R2OPER
             and SCSBOP= i.R2SBOP
             and SCTOPE= i.R2TOPE;
        exception
          when others then
            ln_montogar:=0;
        end;
                 
        lc_Cadenagarantias := concat(lc_Cadenagarantias , lc_ngarantia);
        lc_montogar := rtrim(ltrim(to_char(ln_montogar,'999999999.99')));
        lc_cadenagarantiasm :=  concat(lc_cadenagarantiasm, lc_montogar);
        
        if (lc_ngarantia<>' ') then
          lc_Cadenagarantias := concat(lc_Cadenagarantias, ' , ');
        end if;
        if (ln_montogar<>0) then
          lc_cadenagarantiasm := concat(lc_cadenagarantiasm,' , ');
        end if;  
        
      end loop;
     exception
          when others then
            null; 
     END;
     pn_garantias := lc_Cadenagarantias;
     pn_montogar := lc_cadenagarantiasm;
   end if;

end sp_otrosdatos; 
procedure sp_provision(  pd_FecUltCierre date,
                         pn_saldo number, 
                         pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number,
                         pn_Provision out number, 
                         pn_ProvisionP out number ) is 
          
   ln_provision number;
   ln_ProvConstituida number;
   ln_PProvision number; 

  begin
       ln_provision:=0;
        begin
        select /*+index(FSH012 FSH01204)*/ sum(bcsdmo) into ln_provision ---BCEMP, BCFECH, BCRUBR, BCCTA
             from fsh012 
             where BCEMP=1 
             and bcfech = pd_FecUltCierre 
             and BCRUBR in ( select rubro
                          from fsd014
                         where pcnivc in (404))
             and bccta  = pn_cta
             and bcoper = pn_ope
             and bcmda  = pn_mda;
            -- and bcmod  = 404; 
        exception
          when no_data_found then
            ln_provision :=0;
        end;
        begin
        ln_ProvConstituida :=0;
        select /*+index(FSH012 FSH01204)*/ sum(bcsdmo) into ln_ProvConstituida 
             from fsh012 
             where BCEMP=1 
             and bcfech = pd_FecUltCierre 
             and BCRUBR in ( select rubro
                          from fsd014
                         where pcnivc in (419))
             and bccta  = pn_cta
             and bcoper = pn_ope
             and bcmda  = pn_mda; 
             --and bcmod  = 419; 
        exception
          when no_data_found then
            ln_ProvConstituida :=0;
        end;
        if ( ln_provision is null ) then
           ln_provision :=0;
        end if;
        if ( ln_ProvConstituida is null ) then
           ln_ProvConstituida :=0;
        end if;
        if ((pn_saldo-ln_ProvConstituida)>0) then 
          ln_PProvision := round(( ln_provision / (pn_saldo-ln_ProvConstituida) ) * 100 ,2);                      
        else
          ln_PProvision :=0;
        end if;
        pn_Provision := ln_provision;
        pn_ProvisionP := ln_PProvision;
end sp_provision;
procedure sp_Calificacion( pd_FecUltCierre date,
                         pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number,
                         pn_Calificacion out number,
                         pv_calificacion out varchar2
                         ) is
   ln_Calificacion number;
   ln_ncal number;
   lv_bccate varchar(15);
  begin
    ln_Calificacion:=0;
    begin
        select /*+index(FSH012 FSH01204)*/ bccate into lv_bccate
             from fsh012 
             where BCEMP = pn_cod 
             and bcfech  = pd_FecUltCierre 
              and BCRUBR in ( select rubro
                          from fsd014
                         where pcnivc in (select MODULO
                                            from fst111
                                           Where Dscod = 50
                                             and Modulo <> 29
                                             and Modulo <> 120
                                             and Modulo <> 144))
             and bccta  = pn_cta
             and bcoper = pn_ope
             and bcmda  = pn_mda 
           --  and bccate like '4%'
             and rownum=1;
        exception
          when no_data_found then
            lv_bccate :='';
        end; 
        ln_Calificacion:=0;
        if ( lv_bccate is not null ) then
          ln_Calificacion:= to_number(substr(lv_bccate,0,1));
          lv_bccate := substr(lv_bccate,3,12);
          --select to_number(substr(lv_bccate,0,1)) into ln_ncal from dual;
          /*if ( ln_ncal <> 4 ) then            
             ln_Calificacion:=1; -- Su califaición es diferente de pérdida 
          end if;*/
        end if;
        pn_Calificacion  :=ln_Calificacion;
        pv_calificacion :=lv_bccate;
end sp_Calificacion; 
procedure sp_ActualizaGuia( pn_codemp in number,
                            pn_propuesta  in number)is   
  Begin 
    ---actuliza guía con el número de propuesta creada para que proceda a la vinculación de garantías
    update fst198 t  set Tp1nro1=pn_propuesta
    where Tp1cod1  = 10853
    and Tp1corr1 = 10
    and Tp1corr2 = 1
    and Tp1corr3 = 1 ;
    commit;     
end sp_ActualizaGuia;         
end pq_cr_castigos;
/

