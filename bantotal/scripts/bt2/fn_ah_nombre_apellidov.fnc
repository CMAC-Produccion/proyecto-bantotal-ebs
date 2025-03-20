create or replace function FN_AH_NOMBRE_APELLIDOV(P_Pais   in number,
                                              P_TipDoc in number,
                                              P_NroDoc in varchar2,
                                              P_Tipo   in number) return varchar2 is

-- P_Tipo
 --> 0 = Apellidos y Nombres
 --> 1 = Apellidos
 --> 2 = Nombres
 --> 3 = Paterno
 --> 4 = Materno
 --> 5 = Primer Nombre
 --> 6 = Segundo Nombre

ln_Pais   number := null;
ln_TipDoc number := null;
lc_NroDoc char(12) := null;
lc_Nombre varchar2(120) := null;

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
            and r_008.ttcod = 1
            and r_008.cttfir = 'T';
         select r_008.petdoc
           into ln_TipDoc
           from fsr008 r_008
          where r_008.pgcod = 1
            and r_008.ctnro = P_TipDoc
            and r_008.ttcod = 1
            and r_008.cttfir = 'T';
         select r_008.pendoc
           into lc_NroDoc
           from fsr008 r_008
          where r_008.pgcod = 1
            and r_008.ctnro = P_TipDoc
            and r_008.ttcod = 1
            and r_008.cttfir = 'T';

      exception
      when others then
          ln_Pais   := null;
          ln_TipDoc := null;
          lc_NroDoc := null;
      end;
   end if;
   begin


      case
         when P_Tipo = 0 then
            select trim(trim(d_002.pfape1) || ' ' ||
                   trim(d_002.pfape2) || ' ' ||
                   trim(d_002.pfnom1) || ' ' ||
                   trim(d_002.pfnom2))
              into lc_Nombre
              from fsd002 d_002
             where d_002.pfpais = ln_Pais
               and d_002.pftdoc = ln_TipDoc
               and d_002.pfndoc = lc_NroDoc;
         when P_Tipo = 1 then
            select trim(trim(d_002.pfape1) || ' ' ||
                   trim(d_002.pfape2))
              into lc_Nombre
              from fsd002 d_002
             where d_002.pfpais = ln_Pais
               and d_002.pftdoc = ln_TipDoc
               and d_002.pfndoc = lc_NroDoc;
         when P_Tipo = 2 then
            select trim(d_002.pfnom1) || ' ' ||
                   trim(d_002.pfnom2)
              into lc_Nombre
              from fsd002 d_002
             where d_002.pfpais = ln_Pais
               and d_002.pftdoc = ln_TipDoc
               and d_002.pfndoc = lc_NroDoc;
         when P_Tipo = 3 then
            select trim(d_002.pfape1)
              into lc_Nombre
              from fsd002 d_002
             where d_002.pfpais = ln_Pais
               and d_002.pftdoc = ln_TipDoc
               and d_002.pfndoc = lc_NroDoc;
         when P_Tipo = 4 then
            select trim(d_002.pfape2)
              into lc_Nombre
              from fsd002 d_002
             where d_002.pfpais = ln_Pais
               and d_002.pftdoc = ln_TipDoc
               and d_002.pfndoc = lc_NroDoc;
         when P_Tipo = 5 then
            select trim(d_002.pfnom1)
              into lc_Nombre
              from fsd002 d_002
             where d_002.pfpais = ln_Pais
               and d_002.pftdoc = ln_TipDoc
               and d_002.pfndoc = lc_NroDoc;
         when P_Tipo = 6 then
            select trim(d_002.pfnom2)
              into lc_Nombre
              from fsd002 d_002
             where d_002.pfpais = ln_Pais
               and d_002.pftdoc = ln_TipDoc
               and d_002.pfndoc = lc_NroDoc;
       end case;
   exception
     when no_data_found then
          begin
             select trim(d_003.pjrazs)
               into lc_Nombre
               from fsd003 d_003
              where d_003.pjpais = ln_Pais
                and d_003.pjtdoc = ln_TipDoc
                and d_003.pjndoc = lc_NroDoc;
          exception
          when others then
               lc_Nombre := null;
          end;
     when others then
        lc_Nombre := null;
   end;

   return trim(lc_Nombre);
end FN_AH_NOMBRE_APELLIDOV;
/

