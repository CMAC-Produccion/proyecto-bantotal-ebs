create or replace function FN_Fonos_Celular(P_Pais in number,
                                            P_TipDoc in number,
                                            P_NroDoc in varchar2) return varchar2 is


   lc_Fonos varchar2(100) := '';
   lc_NroDoc varchar2(12) := '';

   cursor d_fonos(P_Pais in number,
                  P_TipDoc in number,
                  P_NroDoc in varchar2)

    is (select distinct r_05.dotelfp
          from fsr005 r_05
         where r_05.pepais = P_Pais
           and r_05.petdoc = P_TipDoc
           and r_05.pendoc = P_NroDoc
           and length(trim(r_05.dotelfp)) = 9);
begin

   lc_NroDoc := rpad(P_NroDoc,12,' ');
   for d_data in d_fonos(P_Pais, P_TipDoc, lc_NroDoc)
   loop

      lc_Fonos := lc_Fonos || trim(d_data.dotelfp) || ' - ' ;
   end loop;
   lc_Fonos := substr(lc_Fonos,1,length(lc_Fonos) -3);
   return lc_Fonos;
end FN_Fonos_Celular;
/

