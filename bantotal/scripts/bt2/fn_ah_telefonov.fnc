create or replace function FN_AH_TELEFONOV(P_Pais in number,
                                    P_TipDoc in number,
                                    P_NroDoc in varchar2,
                                    P_Tipo_Fono number,
                                    P_Tipo_Ubicacion number) return varchar2 is

/*
P_Tipo_Fono:
   1: Fijo
   2: Celular
   3: Ambos

P_Tipo_Ubicacion
     1 = Domicilio
     2 = C.Correspondencia
     3 = Negocio
     4 = Laboral
     5 = E. Act. Secundaria
     6 = F. Gestion
     7 = G.Camp. Actua. Legal
     8 = H.Camp. Actua. Negoc
     9 = null


*/
lc_Fonos varchar2(3000) := '';

ln_Pais   number := null;
ln_TipDoc number := null;
lc_NroDoc char(12) := null;

   cursor d_fonos(P_Pais in number,
                  P_TipDoc in number,
                  P_NroDoc in varchar2,
                  P_Tipo_Fono number,
                  P_Tipo_Ubicacion number)

    is (select r_05.dotelfp
          from fsr005 r_05
         where r_05.pepais = P_Pais
           and r_05.petdoc = P_TipDoc
           and r_05.pendoc = P_NroDoc
           and r_05.docod  = P_Tipo_Ubicacion);
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

   for d_data in d_fonos(ln_Pais, ln_TipDoc, lc_NroDoc, P_Tipo_Fono, P_Tipo_Ubicacion)
   loop
      case
      when P_Tipo_Fono = 1 and length(trim(d_data.dotelfp)) <> 9 then   -- Fijo
         lc_Fonos := lc_Fonos || trim(coalesce(d_data.dotelfp, '-')) || ' - ' ;
      when P_Tipo_Fono = 2 and length(trim(d_data.dotelfp)) = 9 then    -- Celular
         lc_Fonos := lc_Fonos || trim(coalesce(d_data.dotelfp, '-')) || ' - ' ;
      when P_Tipo_Fono = 3 then                                         -- Ambos
         lc_Fonos := lc_Fonos || trim(coalesce(d_data.dotelfp, '-')) || ' - ' ;
      else
         null;
      end case;
   end loop;
   lc_Fonos := substr(lc_Fonos,1,length(lc_Fonos) -3);
   return lc_Fonos;
end FN_AH_TELEFONOV;
/

