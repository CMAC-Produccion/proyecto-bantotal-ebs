create or replace function FN_AH_TIPO_CTAV(vpgcod  number,
                                           vscsuc  number,
                                           vscmda  number,
                                           vscpap  number,
                                           vsccta  number,
                                           vscoper number,
                                           vscsbop number,
                                           vsctope number,
                                           vscmod  number) return varchar2 is
  facultad varchar2(12);
  tipper   char(1);
begin

  select x.petipo
    into tipper
    from fsd001 x, fsr008 y
   where x.pepais = y.pepais
     and x.petdoc = y.petdoc
     and x.pendoc = y.pendoc
     and y.pgcod = vpgcod
     and y.ctnro = vsccta
--     and y.ttcod = 1   --- Ojo, existen Cuentas con tipo 2
     and y.cttfir = 'T'
     AND ROWNUM = 1;

  if tipper in ('F', 'J') then
    begin

      select Case R2sbop
               when 1 then
                'INDIVIDUAL'
               when 511 then
                'MANCOMUNADA'
               else --501 and R2sbop <= 510
                'INDISTINTA'
             end
        into facultad
        from fsr011
       Where Relcod = 5
         and R1cod = vpgcod
         and R1mod = vscmod
         and R1suc = vscsuc
         and R1mda = vscmda
         and R1pap = vscpap
         and R1cta = vsccta
         and R1oper = vscoper
         and R1sbop = vscsbop
         and R1tope = vsctope
         and rownum = 1;

      return(facultad);
    exception
      when no_data_found then
        begin
          select Case ctfaccor
                   when 1 then
                    'INDIVIDUAL'
                   when 511 then
                    'MANCOMUNADA'
                   else --501 and R2sbop <= 510
                    'INDISTINTA'
                 end
            into facultad
            from fse130
           where pgcod = vpgcod
             and ctnro = vsccta
             and rownum = 1;
        exception
          when no_data_found then
            facultad := 'INDIVIDUAL';
        end;
        return(facultad);
    end;

  else
    facultad := null;
    return(facultad);
  end if;

end FN_AH_TIPO_CTAV;
/

