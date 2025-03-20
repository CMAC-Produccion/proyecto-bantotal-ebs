create or replace function FN_AH_DIRECCIONV(P_Pais in number,
                                        P_TipDoc in number,
                                        P_NroDoc in varchar2,
                                        P_Tipo in number,
                                        P_Dato in number) return varchar2 is
/*
---> Tipo de Dirección
     1 = Domicilio
     2 = C.Correspondencia
     3 = Negocio
     4 = Laboral
     5 = E. Act. Secundaria
     6 = F. Gestion
     7 = G.Camp. Actua. Legal
     8 = H.Camp. Actua. Negoc
     9 = null
---> P_Dato
    -- 0 : Toda la Dirección
    -- 1 : Sólo Descripción
    -- 2 : Sólo Departamento
    -- 3 : Sólo Provincia
    -- 4 : Sólo Distrito
    -- 5 : UBIGEO
*/
----------------------------
ln_Pais   number := null;
ln_TipDoc number := null;
lc_NroDoc char(12) := null;

pc_Direccion    varchar2(1000);
pc_Departamento varchar2(1000);
pc_Provincia    varchar2(1000);
pc_Distrito     varchar2(1000);
pc_UBIGEO       char(6);
pc_Completo     varchar2(1000);
pn_Dato         number(1);

begin


   ln_Pais   := P_Pais;
   ln_TipDoc := P_TipDoc;
   lc_NroDoc := P_NroDoc;
   if lc_NroDoc is null then -- Se pasó en Pais la Emp y en Tipo la Cta Cliente.
      begin
         select r_008.pepais
           into ln_Pais
           from fsr008 r_008
          where r_008.pgcod = 1
            and r_008.ctnro = P_TipDoc
            and r_008.cttfir = 'T';
         select r_008.petdoc
           into ln_TipDoc
           from fsr008 r_008
          where r_008.pgcod = 1
            and r_008.ctnro = P_TipDoc
            and r_008.cttfir = 'T';
         select r_008.pendoc
           into lc_NroDoc
           from fsr008 r_008
          where r_008.pgcod = 1
            and r_008.ctnro = P_TipDoc
            and r_008.cttfir = 'T';

      exception
      when others then
          ln_Pais   := null;
          ln_TipDoc := null;
          lc_NroDoc := null;
      end;
   end if;

   pn_Dato := nvl(P_Dato,0);
   if pn_Dato in (0,1) then
       begin
          select g_c13.sngc13dir Direccion
            into pc_Direccion
            from sngc13 g_c13
           where g_c13.sngc13pais = ln_Pais
             and g_c13.sngc13tdoc = ln_TipDoc
             and g_c13.sngc13ndoc = lc_NroDoc
             and g_c13.docod = P_Tipo
             and g_c13.sngc13est = 'H'
             and g_c13.sngc13corr = (select max(g_c13a.sngc13corr)
                                       from sngc13 g_c13a
                                      where g_c13a.sngc13pais = ln_Pais
                                        and g_c13a.sngc13tdoc = ln_TipDoc
                                        and g_c13a.sngc13ndoc = lc_NroDoc
                                        and g_c13a.sngc13est = 'H'
                                        and g_c13a.docod = P_Tipo);
       exception
       when others then
          pc_Direccion := null;
       end;
   end if;
   if pn_Dato in (0,2) then
       begin
          select ubig_01.DEPNOM Departamento
            into pc_Departamento
            from sngc13 g_c13,
                 fst068 ubig_01,
                 fst070 ubig_02,
                 fst071 ubig_03
           where g_c13.sngc13pais = ln_Pais
             and g_c13.sngc13tdoc = ln_TipDoc
             and g_c13.sngc13ndoc = lc_NroDoc
             and TO_NUMBER(substr(g_c13.sngc13ugeo,1,2),999999) = ubig_01.depcod    -- Departamento
             and TO_NUMBER(substr(g_c13.sngc13ugeo,1,4),999999) = ubig_02.loccod    -- Provincia
             and TO_NUMBER(substr(g_c13.sngc13ugeo,1,6),999999) = ubig_03.fst071col -- Distrito
             and g_c13.docod = P_Tipo
             and g_c13.sngc13est = 'H'
             and g_c13.sngc13corr = (select max(g_c13a.sngc13corr)
                                       from sngc13 g_c13a
                                      where g_c13a.sngc13pais = ln_Pais
                                        and g_c13a.sngc13tdoc = ln_TipDoc
                                        and g_c13a.sngc13ndoc = lc_NroDoc
                                        and g_c13a.docod = P_Tipo
                                        and g_c13a.sngc13est = 'H');
       exception
       when others then
          pc_Departamento := null;
       end;
   end if;
   if pn_Dato in (0,3) then
       begin
          select ubig_02.LOCNOM Provincia
            into pc_Provincia
            from sngc13 g_c13,
                 fst068 ubig_01,
                 fst070 ubig_02,
                 fst071 ubig_03
           where g_c13.sngc13pais = ln_Pais
             and g_c13.sngc13tdoc = ln_TipDoc
             and g_c13.sngc13ndoc = lc_NroDoc
             and TO_NUMBER(substr(g_c13.sngc13ugeo,1,2),999999) = ubig_01.depcod    -- Departamento
             and TO_NUMBER(substr(g_c13.sngc13ugeo,1,4),999999) = ubig_02.loccod    -- Provincia
             and TO_NUMBER(substr(g_c13.sngc13ugeo,1,6),999999) = ubig_03.fst071col -- Distrito
             and g_c13.docod = P_Tipo
             and g_c13.sngc13est = 'H'
             and g_c13.sngc13corr = (select max(g_c13a.sngc13corr)
                                       from sngc13 g_c13a
                                      where g_c13a.sngc13pais = ln_Pais
                                        and g_c13a.sngc13tdoc = ln_TipDoc
                                        and g_c13a.sngc13ndoc = lc_NroDoc
                                        and g_c13a.docod = P_Tipo
                                        and g_c13a.sngc13est = 'H');
       exception
       when others then
          pc_Provincia := null;
       end;
   end if;
   if pn_Dato in (0,4) then
       begin
          select ubig_03.FST071DSC Distrito
            into pc_Distrito
            from sngc13 g_c13,
                 fst068 ubig_01,
                 fst070 ubig_02,
                 fst071 ubig_03
           where g_c13.sngc13pais = ln_Pais
             and g_c13.sngc13tdoc = ln_TipDoc
             and g_c13.sngc13ndoc = lc_NroDoc
             and TO_NUMBER(substr(g_c13.sngc13ugeo,1,2),999999) = ubig_01.depcod    -- Departamento
             and TO_NUMBER(substr(g_c13.sngc13ugeo,1,4),999999) = ubig_02.loccod    -- Provincia
             and TO_NUMBER(substr(g_c13.sngc13ugeo,1,6),999999) = ubig_03.fst071col -- Distrito
             and g_c13.docod = P_Tipo
             and g_c13.sngc13est = 'H'
             and g_c13.sngc13corr = (select max(g_c13a.sngc13corr)
                                       from sngc13 g_c13a
                                      where g_c13a.sngc13pais = ln_Pais
                                        and g_c13a.sngc13tdoc = ln_TipDoc
                                        and g_c13a.sngc13ndoc = lc_NroDoc
                                        and g_c13a.docod = P_Tipo
                                        and g_c13a.sngc13est = 'H');
       exception
       when others then
          pc_Distrito := null;
       end;
   end if;
   if pn_Dato in (5) then
         begin
            select g_c13.sngc13ugeo UBIGEO
              into pc_UBIGEO
              from sngc13 g_c13
             where g_c13.sngc13pais = ln_Pais
               and g_c13.sngc13tdoc = ln_TipDoc
               and g_c13.sngc13ndoc = lc_NroDoc
               and g_c13.docod = P_Tipo
               and g_c13.sngc13est = 'H'
               and g_c13.sngc13corr = (select max(g_c13a.sngc13corr)
                                         from sngc13 g_c13a
                                        where g_c13a.sngc13pais = ln_Pais
                                          and g_c13a.sngc13tdoc = ln_TipDoc
                                          and g_c13a.sngc13ndoc = lc_NroDoc
                                          and g_c13a.docod = P_Tipo
                                          and g_c13a.sngc13est = 'H');
         exception
         when others then
            pc_UBIGEO := null;
         end;
   end if;
   pc_Direccion := replace(pc_Direccion,'NO CONSIGNADO ','');
   case
     when pn_Dato = 0 then
          pc_Completo := trim(pc_Direccion) || '|_ ' || trim(nvl(pc_Departamento,' ')) || ' _ ' || trim(nvl(pc_Provincia,' ')) || ' _ ' || trim(nvl(pc_Distrito,' '));
     when pn_Dato = 1 then
          pc_Completo := trim(pc_Direccion);
     when pn_Dato = 2 then
          pc_Completo := trim(nvl(pc_Departamento,' '));
     when pn_Dato = 3 then
          pc_Completo := trim(nvl(pc_Provincia,' '));
     when pn_Dato = 4 then
          pc_Completo := trim(nvl(pc_Distrito,' '));
     when pn_Dato = 5 then
          pc_Completo := pc_UBIGEO;
     end case;
   if pc_Completo = '|_  _  _ ' then
      pc_Completo := null;
   end if;
   return pc_Completo;

end FN_AH_DIRECCIONV;
/

