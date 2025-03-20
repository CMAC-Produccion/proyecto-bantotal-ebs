CREATE OR REPLACE PROCEDURE sp_urie_datos_codeudor (co_pais in number,co_tdoc in number,
                    co_ndoc in varchar2,co_campo in number, co_valor OUT varchar2)is
ld_fecrcc date;  --si va
co_ndocs char(12);
co_codigos char(40);
co_situacion varchar2 (2);
co_genero varchar2(2);
begin
        --fecha RCC
          co_ndocs := co_ndoc;
          begin
                  select to_date(Tpnro,'dd.mm.yyyy')
                    into ld_fecrcc
                    from Fst098
                   Where Pgcod = 1
                     and Tpcod = 7647
                     and Tpcorr = 12;
          end;
          
          case co_campo
          When 4 then --codigo de deudor
            --select c_codsbs into co_valor from cldrccI where c_tdocid=FN_TDOC_SBS(co_tdoc,co_ndoc) and c_docide=co_ndoc;
            begin
            select TO_CHAR(BC739SBS) into co_valor from FBC739  where BC739pais=co_pais and BC739tdoc=co_tdoc and BC739ndoc= co_ndocs  and rownum=1;
            exception
            when no_data_found then
              Begin
                if(co_tdoc=21)then
                  select c_codsbs into co_valor from cldrccI where  c_docide=co_ndoc and d_fecpre=ld_fecrcc and rownum=1 ;--;
                else
                  select c_codsbs into co_valor from cldrccI where  c_doctri=co_ndoc and d_fecpre=ld_fecrcc and rownum=1;--;
                end if;
                exception
                when no_data_found then
                      co_valor := '0000000000';
                End;
            when others then
              co_valor := '0000000000';
            end;
          When 8 then --tipo de documento tributario
             if ( co_tdoc = 9 ) then --si es ruc
               if ( LENGTH (rtrim(co_ndoc)) = 8 ) then
                 co_valor := '2';
               else
                 co_valor := '3';
               end if;
             end if;
          When 10 then -- tipo de documento de identidad
              IF co_tdoc = 21 THEN
               co_valor :='1';           
              ELSIF co_tdoc = 2 THEN
               co_valor := '2';           
              ELSIF co_tdoc = 5 THEN
               co_valor :='5';           
              ELSE
                co_valor :='';
              END IF;        
              --co_valor := to_char(FN_TDOC_SBS(co_tdoc));
          When 15 then  --accionista de la empresa
              ---si es accionista (tipo de vinculo segun tabla maestra codigo 425 ) retornar 1
              begin
              select '1' into co_valor from FSE002 s
                     inner join FBC206 b on s.vicod=b.bc206id1 and b.bc205cod=425
                     where pfxpais=co_pais and PFxTDOc=co_tdoc and PFXNDOC=co_ndocs;
              exception 
              when no_data_found then
                  begin
                    select '2' into co_valor from Fsr002 fsr
                    inner join (select pfxpais,PFxTDOc,PFXNDOC,s.vicod from FSE002 s
                    inner join FBC206 b on s.vicod=b.bc206id1 and b.bc205cod=425) acc on acc.pfxpais=fsr.pepais and acc.pfxtdoc=fsr.petdoc and acc.pfxndoc=fsr.pendoc
                    where fsr.rppais=co_pais and fsr.rptdoc=co_tdoc and fsr.rpndoc=co_ndocs;
                    exception 
                  when no_data_found then
                      co_valor := '0';
                  end;
              end;
          When 18 then  --genero
              begin
              select (case PETIPO when 'F' then p.pfcant
                   when 'J' then '0'
                   end) PETIPO into co_valor
              from FSD001 f
              inner join (select pfpais,pftdoc,pfndoc,pfcant from FSD002 ) p on p.pfpais=f.pepais and p.pftdoc=f.petdoc and p.pfndoc=f.pendoc
              where pepais=co_pais  and petdoc=co_tdoc and pendoc=co_ndocs;
              exception
              when no_data_found then
                co_valor := '0';
              end;
          When 19 then --estado civil
              begin
              select (case PETIPO when 'F' then p.PFECIV
                                 when 'J' then '0'                                 
                     end) into co_valor
              from FSD001 f
              inner join (select pfpais,pftdoc,pfndoc,
              (case PFECIV when '1' then 'C' when '2' then 'D' when '3' then 'C' when '4' then 'S' when '5' then 'V' when '6' then 'C' end) PFECIV
              from FSD002 ) p on f.pepais= p.pfpais and p.pftdoc=f.petdoc and p.pfndoc=f.pendoc
              where pepais=co_pais  and petdoc=co_tdoc and pendoc=co_ndocs;
              exception
              when no_data_found then
                co_valor := '0';
              end;
          When 22 then  -- apellido de casada
             co_genero:='';
             co_situacion:='';
             IF co_tdoc = 21 THEN
              begin
              select pfcant ,
              (case PFECIV when '1' then 'C' when '2' then 'D' when '3' then 'C' when '4' then 'S' when '5' then 'V' when '6' then 'C' else '' end) into co_genero,co_situacion
              from FSD002 where pfpais=co_pais and pftdoc=co_tdoc and pfndoc=co_ndocs;
              exception
              when no_data_found then
                co_genero:= '';
                co_situacion := '';
              end;
             End if;
              if (  co_genero = 'F' and co_situacion='C' )  then           
                co_codigos := concat(to_char(co_pais),concat(to_char(co_tdoc),co_ndoc));
                begin
                select BC530CHR1 into co_valor from FBC530 where bc530clv= co_codigos and rownum=1 order by bc530fch;
                exception
                when no_data_found then
                     Begin
                     select replace(d.pfape1,'Ñ','#') into co_valor from fsd002 d 
                      inner join fsr002 r on r.rppais=d.pfpais and r.rptdoc=d.pftdoc and r.rpndoc=d.pfndoc and rpccyg = 66
                      where r.pepais= co_pais and r.petdoc = co_tdoc and r.pendoc = co_ndocs;
                     exception
                     when no_data_found then
                                co_valor := '';
                     when others then
                         co_valor := '';
                     end;
                when others then
                         co_valor := '';                                                          
                End;
               Else
                 co_valor := '';
               End if;
          When 25 then  -- fecha de nacimiento
              begin
                select (case PETIPO when 'F' then to_char(p.Pffnac,'yyyy//mm/dd')
                     when 'J' then '0'
                     end) into co_valor
                from FSD001 f
                inner join (select pfpais,pftdoc,pfndoc,Pffnac from FSD002 ) p on p.pfpais=f.pepais and p.pftdoc=f.petdoc and p.pfndoc=f.pendoc
                where pepais=co_pais  and petdoc=co_tdoc and pendoc=co_ndocs;
              exception
              when no_data_found then
                co_valor := '';
              when others then
                co_valor := '';
              end;
              co_valor := replace(co_valor,'/','');
          END case;

end sp_urie_datos_codeudor;
/

