CREATE OR REPLACE PROCEDURE SP_AH_TIPO_CREDITO(ln_pepais in number,
                                               ln_petdoc in number,
                                               lc_pendoc in varchar2,
                                               ld_fecref in date,
                                               v_tipo out varchar2
                                             )  is
resultado number(3);
documento varchar2(12);
                                             
BEGIN
     documento := rpad(lc_pendoc,12,' ');
     select (case
                when count(*) = 0 then 1 -- nuevo
                when count(*) = 1 then 1 -- nuevo
                else 2 -- recurrente
           end)
      into resultado
      from fsd010 des
           inner join fsr008 pers
                  on pers.pgcod = des.pgcod
                 and pers.ctnro = des.aocta
                 and pers.ttcod = 1
                 and pers.CTTFIR = 'T'
     where
           des.aomod in (select modulo from fst111 where dscod=50 and modulo not in (29,120,142,144) union all select 117 from dual)

       and pers.pepais = ln_pepais
       and pers.petdoc = ln_petdoc
       and pers.pendoc = documento
       and des.aofval <= ld_fecref;
       
       if resultado = 1 then
          v_tipo := 'NUEVO';  
       else 
          v_tipo := 'RECURRENTE';
       end if;   

END SP_AH_TIPO_CREDITO;
/

