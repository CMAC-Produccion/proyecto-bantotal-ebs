CREATE OR REPLACE PACKAGE PQ_CR_BUSQUEDA_DIRECCION_2e  is
-- *****************************************************************
-- Nombre                     : PQ_CR_EXPERIAN
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 2014.04.27
-- Autor de Creación          : CMAC-SFERNANDEM
-- Uso                        : Extrae
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      :
-- Autor de Modificación      :
-- Descripción de Modificación:
--
--  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  type table_vc is table of varchar2(4000);
  Function fn_espacios(texto in varchar2) return varchar2;
  function fn_split(cadena in varchar2, delimitador in varchar2 default ' ') return table_vc;
  Procedure sp_cr_volcado_palabras2(P_BUSQUEDA in varchar2,
                                    P_PAIS in NUMBER,
                                    P_DPTO in NUMBER,
                                    P_PROVINCIA in NUMBER,
                                    P_UBIGEO in VARCHAR2,
                                    P_USU in varchar2,
                                    P_MAQUINA in varchar2,
                                    P_TOT_CON2 out number);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end  PQ_CR_BUSQUEDA_DIRECCION_2e;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_BUSQUEDA_DIRECCION_2e is

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_espacios(texto in varchar2)
 RETURN VARCHAR2 IS
  RPTA VARCHAR2(4000);
  NUM_DOB_ESP NUMBER;
BEGIN
    RPTA := REPLACE(TEXTO,'  ',' ');
    SELECT INSTR(RPTA,'  ')
    INTO NUM_DOB_ESP
    FROM DUAL;
    IF(NUM_DOB_ESP > 0) THEN
      RETURN FN_ESPACIOS(RPTA);
    ELSE
      RETURN RPTA;
    END IF;
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_split(cadena in varchar2, delimitador in varchar2 default ' ')
return table_vc as
  splitted table_vc := table_vc();
  i pls_integer := 0;
  cadena_ varchar2(4000) := cadena;
begin
  loop
    i := instr(cadena_, delimitador);
    if i > 0 then
      splitted.extend(1);
      splitted(splitted.last) := substr(cadena_, 1, i - 1);
      cadena_ := substr(cadena_, i + length(delimitador));
    else
      splitted.extend(1);
      splitted(splitted.last) := cadena_;
      return splitted;
    end if;
  end loop;
end;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Procedure sp_cr_volcado_palabras2(P_BUSQUEDA in varchar2,
                                  P_PAIS in number,--no se utiliza
                                  P_DPTO in number,
                                  P_PROVINCIA in number,
                                  P_UBIGEO in varchar2,
                                  P_USU in varchar2,
                                  P_MAQUINA in varchar2,
                                  P_TOT_CON2 out number)
  IS
    lc_query varchar2(4000);
    l_cursor SYS_REFCURSOR;
    l_tpnro fst098.tpnro%type;    
    l_pais JAQY735.jaqy735pais%type;
    l_tdoc JAQY735.jaqy735tdoc%type;
    l_ndoc JAQY735.jaqy735ndoc%type;
    l_docod JAQY735.jaqy735docod%type;
    l_corr JAQY735.jaqy735corr%type;
    l_dir JAQY735.JAQY735DIR%type;
    l_cont number;
    LC_NOMBRE FSD001.PENOM%type;
    LIM NUMBER(3);
    CONT number(3);
  BEGIN
    execute immediate 'TRUNCATE TABLE JAQY734';
    --establece el limite de registros máximos a considerar
    select tpnro into l_tpnro from fst098 where pgcod=1 and tpcod=7689 and tpcorr=1;
    --determina el numero de palabras útiles para la búsqueda/comparación
    execute immediate
    'select count(*)
     from table(fn_split(upper(fn_espacios(regexp_replace('||P_BUSQUEDA||',''( *[[:punct:]])'','' '')))))
     where not exists (select 1 from fst098 where pgcod = 1 and tpcod = 7688 and trim(tpdesc) = trim(COLUMN_VALUE))'
    into CONT;
    --establece el umbra o límite
    LIM := FLOOR((CONT/2))+3;
    IF(LIM > CONT) THEN
      LIM := CONT;
    END IF ;          
    --consulta que realiza la búsqueda
    lc_query := 'select * from ( '||
                'select JAQY735.jaqy735pais, JAQY735.jaqy735tdoc, JAQY735.jaqy735ndoc, JAQY735.jaqy735docod, JAQY735.jaqy735corr, JAQY735.JAQY735DIR, '||
                'count(busqueda.palabra) '||
                'from (select COLUMN_VALUE palabra '||
                'from table(fn_split(upper(fn_espacios(regexp_replace('||P_BUSQUEDA||',''( *[[:punct:]])'','' ''))))) '||
                'where not exists (select 1 from fst098 where pgcod = 1 and tpcod = 7688 and trim(tpdesc) = trim(COLUMN_VALUE))) busqueda, '||
                'JAQY735 PARTITION(JAQY735_'||TO_CHAR(P_DPTO)||') '||
                'where instr(''*''||trim(JAQY735.jaqy735txt1)||''*''|| trim(JAQY735.jaqy735txt2)||''*''||'||
                'trim(JAQY735.jaqy735txt3)||''*''||trim(JAQY735.jaqy735txt4)||''*''||'||
                'trim(JAQY735.jaqy735txt5)||''*''||trim(JAQY735.jaqy735txt6)||''*''||'||
                'trim(JAQY735.jaqy735txt7)||''*''||trim(JAQY735.jaqy735txt8)||''*''||'||
                'trim(JAQY735.jaqy735txt9)||''*''||trim(JAQY735.jaqy735txt10)||''*''||'||
                'trim(JAQY735.jaqy735txt11)||''*''||trim(JAQY735.jaqy735txt12)||''*''||'||
                'trim(JAQY735.jaqy735txt13)||''*''||trim(JAQY735.jaqy735txt14)||''*''||'||
                'trim(JAQY735.jaqy735txt15)||''*'', '||
                '''*''||busqueda.palabra||''*'') > 0 '||
                'AND JAQY735.jaqy735dpto = '||trim(to_char(P_DPTO))||' '||
                'AND JAQY735.jaqy735prov = '||trim(to_char(P_PROVINCIA))||' '||
                'AND JAQY735.jaqy735ugeo = '||trim(P_UBIGEO)||' '||
                'AND JAQY735.jaqy735est = ''H'''||
                'group by JAQY735.jaqy735pais, JAQY735.jaqy735tdoc, JAQY735.jaqy735ndoc, JAQY735.jaqy735docod, JAQY735.jaqy735corr, JAQY735.JAQY735DIR '||
                'having count(busqueda.palabra) >= '||LIM||' order by 7 desc) where rownum <= '||to_char(l_tpnro);
    OPEN l_cursor FOR lc_query;
    LOOP
      FETCH l_cursor INTO l_pais, l_tdoc, l_ndoc, l_docod, l_corr, l_dir, l_cont;
      IF l_cursor%FOUND THEN
         --busca nombre de persona
         begin
           SELECT PENOM INTO LC_NOMBRE FROM FSD001 WHERE PEPAIS = l_pais AND PETDOC = l_tdoc AND PENDOC = l_ndoc;
         exception
           when no_data_found then LC_NOMBRE := null;
         end;
         --inserta en tabla temporal
         INSERT INTO JAQY734 
          (JAQY734PAI, JAQY734TDOC, JAQY734NDOC, JAQY734DOCOD, JAQY734CORR,
           JAQY734USU, JAQY734MAQ, JAQY734DIR, JAQY734NOM)
         VALUES
          (l_pais, l_tdoc, l_ndoc, l_docod, l_corr, 
           TRIM(P_USU), TRIM(P_MAQUINA), l_dir, LC_NOMBRE);
      ELSE 
        EXIT;
      END IF;
    END LOOP;
    COMMIT;
    --retorna numero de registros encontrados
    P_TOT_CON2 := l_cursor%ROWCOUNT;
    CLOSE l_cursor;
  END sp_cr_volcado_palabras2;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end   PQ_CR_BUSQUEDA_DIRECCION_2e;
/

