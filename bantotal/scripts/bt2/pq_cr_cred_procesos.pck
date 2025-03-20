create or replace package pq_cr_cred_procesos is

  -- Author  : KVALENCIAC
  -- Created : 18/10/2017 10:58:25 a.m.
  -- Purpose : 
  -- Author  : KVALENCIAC
  -- Modificado : 29/12/2020
  -- Purpose : Optimización
  
  procedure sp_CreditoMoroso (vd_Pgfape in date,  vn_instancia in number, vc_gcCredMor out varchar2, vc_gcCredMorA out varchar2);
  procedure sp_entidades (vn_instancia in  number, vn_nentidad out number, vn_ncreditos out number);
  procedure sp_UbigeoAlcance (vd_Pgfape date,  vn_instancia number, vc_gcUbigeofa out varchar2);
end pq_cr_cred_procesos;
/

create or replace package body pq_cr_cred_procesos is

procedure sp_CreditoMoroso (vd_Pgfape date,  vn_instancia number, vc_gcCredMor out varchar2, vc_gcCredMorA out varchar2)
  is
vn_sng001cta number(10);
vn_pepais number(3);
vn_petdoc number(2);
vc_pendoc char(12);
vn_cont number(3);
vn_cont1 number(3);
vn_contaval number(3);
vn_tpnro number(9);

cursor clientes is
    select pepais,petdoc,pendoc,cttfir 
    from fsr008 
    where ctnro in (select sng001cta from sng001 where sng001inst = vn_instancia and rownum=1); --son todas los personas del crédito
--26/08/2020
cursor avales(vnl_instancia in number) is 
       select *
       from sng003 b
       where b.sng001inst = vnl_instancia;
--26/08/2020    
begin
  
vc_gcCredMor := 'N';
vc_gcCredMorA := 'N';
 begin 
  select sng001cta into vn_sng001cta 
  from sng001 
  where sng001inst = vn_instancia and rownum=1;
 Exception
        when no_data_found then
          vn_sng001cta := 0;
 end; 
 if (vn_sng001cta <>0 or vn_sng001cta is not null ) then
      begin    
         select tpnro into vn_tpnro from fst098 where pgcod=1 and tpcod=7721 and tpcorr=1;
       Exception
         when no_data_found then
             vn_tpnro:=0;
      end;
      begin
        select pepais,petdoc,pendoc into vn_pepais,vn_petdoc,vc_pendoc from fsr008 where ctnro = vn_sng001cta and TTCOD=1 and Cttfir= 'T' and rownum = 1;
      Exception
         when no_data_found then
         vn_pepais:=0;
         vn_petdoc:=0;
         vc_pendoc:=0;
       end;
           --valida si son créditos morosos
                begin          
                select COUNT(b.aocta) INTO vn_cont
                from fsr008 a,fsd010 b
                 where a.pepais = vn_pepais
                   and a.petdoc = vn_petdoc
                   and a.pendoc = vc_pendoc
                   and a.pgcod = b.pgcod
                   and a.ctnro = b.aocta
                   and b.aostat<>99--no este cancelada
                   and b.aomod in (select modulo from fst111 where dscod = 50)
                   and fn_dias_atraso(vd_Pgfape,b.pgcod,b.aomod,b.aosuc,b.aomda,b.aopap,b.aocta,b.aooper,b.aosbop,b.aotope,b.aostat,b.aofvto)>vn_tpnro ;         
                Exception
                       when no_data_found then
                            vn_cont := 0;               
                end;
                begin
                select COUNT(b.aocta) INTO vn_cont1
                      from fsr008 a,fsd010 b,fsr002 c
                     where c.pepais = vn_pepais
                       and c.petdoc = vn_petdoc
                       and c.pendoc = vc_pendoc
                       and a.pepais = c.rppais
                       and a.petdoc = c.rptdoc
                       and a.pendoc = c.rpndoc
                       and a.pgcod = b.pgcod
                       and a.ctnro = b.aocta
                       and b.aomod in (select modulo from fst111 where dscod = 50)
                       and b.aostat <> '99' 
                       and c.rpccyg = 66 --relación de esposa
                       and fn_dias_atraso(vd_Pgfape,b.pgcod,b.aomod,b.aosuc,b.aomda,b.aopap,b.aocta,b.aooper,b.aosbop,b.aotope,b.aostat,b.aofvto)>vn_tpnro;       
                 Exception
                       when no_data_found then
                            vn_cont1 := 0;               
                 end;
--     end if;  --26/08/2020
           vn_cont := vn_cont + vn_cont1;
    --validad si algun aval tiene crédito moroso los avales
    --26/08/2020
    for i in avales(vn_instancia) loop  
      begin
      select count(c.aocta) into vn_contaval
           from fsd010 c
          where c.pgcod = i.sng003pgc
            and c.aocta= i.sng003cta             
            and c.aomod in (select modulo from fst111 where dscod = 50)
            and c.aostat <> '99'
            and fn_dias_atraso(vd_Pgfape,c.pgcod,c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope,c.aostat,c.aofvto)>vn_tpnro;
            Exception
                 when no_data_found then
                      vn_contaval := 0;
            end; 
    end loop;  
    --26/08/2020 
    /*
     begin
         select count(c.aocta) into vn_contaval
           from sng003 b,fsr008 a,fsd010 c
          where b.sng001inst = vn_instancia
            and b.sng003pgc  = a.pgcod
            and b.sng003cta  = a.ctnro
            and a.pgcod = c.pgcod
            and a.ctnro = c.aocta
            and c.aostat <> '99' 
            and c.aomod in (select modulo from fst111 where dscod = 50)
            and fn_dias_atraso(vd_Pgfape,c.pgcod,c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope,c.aostat,c.aofvto)>vn_tpnro;
            Exception
                 when no_data_found then
                      vn_contaval := 0;
            end; 
        */     
         --valida si son créditos morosos
     --    if ( vn_contaval <> 0 ) then
     --         exit;
     --    end if;         
    -- end loop;     
-----------
 end if;  --26/08/2020
if  vn_cont <> 0  then
   vc_gcCredMor := 'S';
end if;
if  vn_contaval <> 0  then
   vc_gcCredMorA := 'S';
end if;
end sp_CreditoMoroso;

procedure sp_entidades ( vn_instancia number, vn_nentidad out number, vn_ncreditos out number)
  is
vn_sng001cta number(10);
vn_pepais number(3);
vn_petdoc number(2);
vc_pendoc char(12);
vc_pendocC char(12);
vn_contcredT number(3);
vn_contcredC number(3);
vd_fecrcc date;
vn_TipoDni number(2);
vn_TipoRuc number(2);
vn_TipoCex number(2);
vn_C_TDOCID number (2);
vn_C_TDOCIDC number (2);
vn_petdocC number(2);
vv_pendoc varchar(12);
vv_pendocC varchar(12);


begin
  begin
  select sng001cta into vn_sng001cta from sng001 where sng001inst = vn_instancia;
  Exception
          when no_data_found then
            vn_sng001cta := 0;
   end;
   begin     
   select pepais,petdoc,pendoc into vn_pepais,vn_petdoc,vc_pendoc from fsr008 where ctnro =vn_sng001cta and TTCOD=1 and Cttfir= 'T' and rownum = 1;
   Exception
     when no_data_found then
     vn_pepais:=0;
     vn_petdoc:=0;
     vc_pendoc:=0;
   end;
vn_TipoDni := 21;
vn_TipoRuc := 9;
vn_TipoCex := 2;   
  
--fecha RCC     
          begin
                  select to_date(Tpnro,'dd.mm.yyyy') 
                    into vd_fecrcc
                    from Fst098 
                   Where Pgcod = 1 
                     and Tpcod = 7647 
                     and Tpcorr = 12;
           Exception
                when no_data_found then
                vd_fecrcc:='01/01/01';
          end;
     --número de créditos del titular y conyuge a excepción de los pignoráticos (prendario)
          begin
   /*       select COUNT(b.aocta) INTO vn_contcredT
          from fsr008 a,fsd010 b
           where a.ctnro = vn_sng001cta
             and a.pgcod = b.pgcod
             and a.ctnro = b.aocta
             and b.aomod in (select modulo from fst111 where dscod = 50)
             and b.aomod <> 108;--créditos pignoraticios*/
                          
          select COUNT(b.aocta) INTO vn_contcredT
          from fsr008 a,fsd010 b
           where a.pepais = vn_pepais
             and a.petdoc = vn_petdoc
             and a.pendoc = vc_pendoc
             and a.pgcod = b.pgcod
             and a.ctnro = b.aocta
             and b.aostat<>99--no este cancelada
             and b.aomod in (select modulo from fst111 where dscod = 50)
             and a.cttfir = 'T'
             and b.aomod <> 108;--créditos pignoraticios             
           Exception
                 when no_data_found then
                      vn_contcredT := 0;               
           end;
           Begin
           select COUNT(b.aocta) INTO vn_contcredC              
                from fsr008 a,fsd010 b,fsr002 c
               where c.pepais = vn_pepais
                 and c.petdoc = vn_petdoc
                 and c.pendoc = vc_pendoc
                 and a.pepais = c.rppais
                 and a.petdoc = c.rptdoc
                 and a.pendoc = c.rpndoc
                 and a.pgcod = b.pgcod
                 and a.ctnro = b.aocta
                 and b.aomod in (select modulo from fst111 where dscod = 50)
                 and b.aomod <> 108 --créditos pignoraticios  
                 and a.cttfir = 'T'
                 and c.rpccyg = 66 
                 and b.aostat<>99; 
            Exception
                 when no_data_found then
                      vn_contcredC := 0;               
            end;
     vn_ncreditos := vn_contcredT + vn_contcredC;

     --número de entidades del cliente y conyuge   
     begin  
     select c.rptdoc, c.rpndoc
       into vn_petdocC, vc_pendocC
       from fsr002 c
      where c.pepais = vn_pepais
        and c.petdoc = vn_petdoc
        and c.pendoc = vc_pendoc
        and c.rpccyg = 66;
     exception when no_data_found then
       vn_petdocC := '';
       vc_pendocC := '';
     end;
     --cliente
     
     begin -- se adicionó kvalenciac 09/05/2023
     select tp1nro2 into  vn_C_TDOCID
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11111
         and tp1corr1 = 1
         and tp1corr2 = 5
         and tp1nro1 = vn_petdoc;
     exception when no_data_found then
       vn_C_TDOCID:=0;
     end;
     /*
     If vn_petdoc = vn_TipoDni then
         vn_C_TDOCID := '1';
      End If;
      If vn_petdoc = vn_tipocex then
         vn_C_TDOCID := '2';
      End If;
      If vn_petdoc = vn_tiporuc then
         vn_C_TDOCID := '9';
      End If;*/
      --conyuge
     
     begin   -- se adicionó kvalenciac 09/05/2023
     select tp1nro2 into vn_C_TDOCIDC 
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11111
         and tp1corr1 = 1
         and tp1corr2 = 5
         and tp1nro1 = vn_petdocC;
     exception when no_data_found then
       vn_C_TDOCIDC:=0;
     end;
     /* se modifico --kvalenciac 09/05/2023
     If vn_petdocC = vn_TipoDni then
      vn_C_TDOCIDC := '1';
     End If;
     If vn_petdocC = vn_tipocex then
      vn_C_TDOCIDC := '2';
     End If;
     If vn_petdocC = vn_tiporuc then
      vn_C_TDOCIDC := '9';
     End If;
     */
     vv_pendoc := trim(vc_pendoc);
     vv_pendocC := trim(vc_pendocC);  
     if (vn_C_TDOCID=0 or vn_C_TDOCIDC=0) then   --kvalenciac 09/05/2023
         begin
         select count(s.cont)    --inicio kvalenciac 09/05/2023
           into vn_nentidad
           from (select distinct (c_codemp) cont
                   from cldrcci c
                  inner join cldrccs l on l.d_fecpre = c.d_fecpre
                                      and l.c_codsbs = c.c_codsbs
                  where --c.c_tdocid = vn_C_TDOCID and
                     c.c_docide = vv_pendoc
                    and c.d_fecpre = vd_fecrcc
                    and l.c_codemp <> '00104' --que sea diferente de caja arequipa
                 union
                 select distinct (c_codemp) cont
                   from cldrcci c
                  inner join cldrccs l on l.d_fecpre = c.d_fecpre
                                      and l.c_codsbs = c.c_codsbs
                  where --c.c_tdocid = vn_C_TDOCIDC and   
                     c.c_docide = vv_pendocC
                    and c.d_fecpre = vd_fecrcc
                    and l.c_codemp <> '00104' --que sea diferente de caja arequipa
                    ) s
               ;
            exception when no_data_found then
               vn_nentidad := 0;
            end;   --fin kvalenciac 09/05/2023
     else          
       begin
         select count(s.cont)
           into vn_nentidad
           from (select distinct (c_codemp) cont
                   from cldrcci c
                  inner join cldrccs l on l.d_fecpre = c.d_fecpre
                                      and l.c_codsbs = c.c_codsbs
                  where c.c_tdocid = vn_C_TDOCID
                    and c.c_docide = vv_pendoc
                    and c.d_fecpre = vd_fecrcc
                    and l.c_codemp <> '00104' --que sea diferente de caja arequipa
                 union
                 select distinct (c_codemp) cont
                   from cldrcci c
                  inner join cldrccs l on l.d_fecpre = c.d_fecpre
                                      and l.c_codsbs = c.c_codsbs
                  where c.c_tdocid = vn_C_TDOCIDC
                    and c.c_docide = vv_pendocC
                    and c.d_fecpre = vd_fecrcc
                    and l.c_codemp <> '00104' --que sea diferente de caja arequipa
                    ) s
               ;
          exception when no_data_found then
             vn_nentidad := 0;
          end;
     end if;
     -- vn_nentidad := vc_pendoc ;    
end sp_entidades;
-----------------------------------------------------------------------------------------------------
--Procedimiento que valida si el cliente conyuge y aval tiene ubigeo fuera de alcance si uno de los 3 tiene devolvera 'S' bloquante
--Excepción 
----------------------------------------------------------------------------------------------------
procedure sp_UbigeoAlcance (vd_Pgfape date,  vn_instancia number, vc_gcUbigeofa out varchar2)
is
vn_sng001cta number(10);
vn_pepais number(3);
vn_petdoc number(2);
vc_pendoc char(12);
vn_cont number(3);
vn_contaval number(3);
vn_contconyuge number(3);
vn_GarantiaEx number(3);
--  inicio 29/12/2020 KDVC
cursor avales is
select pepais,petdoc,pendoc from fsr008 f
          inner join sng003 g on g.sng003pgc  = f.pgcod and g.sng003cta = f.ctnro and g.sng001inst=vn_instancia; --son todas los personas del crédito
--  fin 29/12/2020 KDVC
begin
vc_gcUbigeofa := 'N';
vn_cont := 0;
vn_contaval := 0;
vn_contconyuge :=0;
--vn_GarantiaEx := 0;
  begin 
   select sng001cta into vn_sng001cta from sng001 where sng001inst = vn_instancia and rownum=1;
  Exception
            when no_data_found then
              vn_sng001cta := 0;
  end;
 begin
  select pepais,petdoc,pendoc into vn_pepais,vn_petdoc,vc_pendoc from fsr008 where ctnro = vn_sng001cta and TTCOD=1 and Cttfir= 'T' and rownum = 1;
 Exception
     when no_data_found then
     vn_pepais:=0;
     vn_petdoc:=0;
     vc_pendoc:=0;
   end;
     --valida si las direcciones del cliente esta dentro de un ubigeo fuera de alcance
          begin
          select count(s.sngc13ugeo) INTO vn_cont from sngc13 s
          inner join jaqz280 j on j.jaqz280cod=s.sngc13ugeo
          where s.sngc13pais=vn_pepais and s.sngc13tdoc=vn_petdoc and s.sngc13ndoc=vc_pendoc
          and s.docod in (1,3) and s.sngc13est = 'H';--sngc13ugeo
          Exception
                 when no_data_found then
                      vn_cont := 0;
          end;
    if ( vn_cont = 0 ) then   
       --valida si las direcciones del aval esta dentro de un ubigeo fuera de alcance
       /*  29/12/2020 kdvc
          Begin
          select count(f.pendoc) into vn_contaval from fsr008 f
          inner join sng003 g on g.sng003pgc  = f.pgcod and g.sng003cta = f.ctnro and g.sng001inst=vn_instancia
          inner join sngc13 s on s.sngc13pais=f.pepais and s.sngc13tdoc=f.petdoc and s.sngc13ndoc=f.pendoc and s.docod in (1,3) and s.sngc13est='H'
          inner join JAQZ280 j on j.jaqz280cod=s.sngc13ugeo;
          --where cttfir<>'T' and f.ctnro in (select sng001cta from sng001 where sng001inst =vn_instancia  and rownum=1);17/01/2018
          Exception
                 when no_data_found then
                      vn_contaval := 0; 
          end;  */
        -- inicio 29/12/2020 KDVC
         for i in avales loop
              Begin
                select count(*) into vn_contaval from sngc13 s --modificado 15/04/2021 kdvc
                inner join JAQZ280 j on j.jaqz280cod=s.sngc13ugeo
                where s.sngc13pais=i.pepais and s.sngc13tdoc=i.petdoc and s.sngc13ndoc=i.pendoc and s.docod in (1,3) and s.sngc13est='H';              
              Exception
                     when no_data_found then
                          vn_contaval := vn_contaval; 
              end; 
         end loop;  
         --fin 29/12/2020 KDVC 
       --valida si las direcciones del conyuge esta dentro de un ubigeo fuera de alcance
       Begin
       select count(r.pendoc) into vn_contconyuge from fsr002 r 
       inner join sngc13 s on s.sngc13pais=r.rppais and s.sngc13tdoc=r.rptdoc and s.sngc13ndoc=r.rpndoc and s.docod in (1,3) and s.sngc13est='H'
       inner join JAQZ280 j on j.jaqz280cod=s.sngc13ugeo
       where r.pepais = vn_pepais
       and r.petdoc = vn_petdoc
       and r.pendoc = vc_pendoc
       and r.rpccyg = 66;
       Exception
                 when no_data_found then
                      vn_contconyuge := 0; 
       end;
       ---créditos con excepción aquellos que tienen DPF o CTS de los avales
     /*  Begin
       select count(sng122inst) into vn_GarantiaEx from sng122 s where s.sng122inst=vn_instancia 
       and sng122tope in (select tpnro from fst098 where pgcod=1 and tpcod=7721 and tpcorr>=100 and tpcorr<200);
       Exception
                 when no_data_found then
                      vn_GarantiaEx := 0; 
       end;*/--- se quito del requerimiento 23112017
    end if;
-----------
if  ( vn_cont>0 or vn_contaval>0 or vn_contconyuge>0 ) then
   vc_gcUbigeofa  := 'S';
end if;
/*if ( vc_gcUbigeofa <> 'S' ) then
  if ( vn_GarantiaEx > 0 and  vn_cont=0 ) then
    vc_gcUbigeofa := 'S';
  end if;
end if;*/--- se quito del requerimiento 23112017
end sp_UbigeoAlcance;

end pq_cr_cred_procesos;
/

