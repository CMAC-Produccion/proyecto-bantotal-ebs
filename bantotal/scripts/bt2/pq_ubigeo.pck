create or replace package pq_ubigeo is

  -- Author  : CHERNANDEZ
  -- Created : 21/08/2015 09:49:25 a.m.
  -- Purpose : 
  -- Public function and procedure declarations
  function obtener_descripciones_ubigeo(P_TARJETA in char,
                                        P_TIPO    in number) return varchar;
  procedure pr_obtener_documento(P_TARJETA in char,
                                 P_PAIS    out number,
                                 P_TDOCU   out number,
                                 P_NDOC    out varchar);
  procedure pr_obtener_codigos_ubigeo(P_PAIS     in number,
                                      P_TDOCU    in number,
                                      P_NDOC     in varchar,
                                      P_N_CODDEP out number,
                                      P_N_CODPRO out number,
                                      P_N_CODDIS out number,
                                      P_C_DIRECC out char);
  function fn_descripcion_departamento(P_N_CODDEP in number) return varchar;
  function fn_descripcion_provincia(P_N_CODDEP in number,
                                    P_N_CODPRO in number) return varchar;
  function fn_descripcion_distrito(P_N_CODDEP in number,
                                   P_N_CODPRO in number,
                                   P_N_CODDIS in number) return varchar;
end pq_ubigeo;
/

create or replace package body pq_ubigeo is
  -- Function and procedure implementations
  function obtener_descripciones_ubigeo(P_TARJETA in char,
                                        P_TIPO    in number) return varchar is
    P_PAIS     sngc13.sngc13pais%type;
    P_TDOCU    sngc13.sngc13tdoc%type;
    P_NDOC     sngc13.sngc13ndoc%type;
    P_N_CODDEP sngc13.sngc13dpto%type;
    P_N_CODPRO sngc13.sngc13prov%type;
    P_N_CODDIS sngc13.sngc13dist%type;
    P_C_DIRECC sngc13.sngc13dir%type;
    P_C_DESCRI char(140);
  begin
    pr_obtener_documento(P_TARJETA, P_PAIS, P_TDOCU, P_NDOC);
    If P_PAIS is not null Then
      pr_obtener_codigos_ubigeo(P_PAIS,
                                P_TDOCU,
                                P_NDOC,
                                P_N_CODDEP,
                                P_N_CODPRO,
                                P_N_CODDIS,
                                P_C_DIRECC);
      If P_N_CODDEP is not null Then
      
        If P_TIPO = 1 Then
          --departamento
          P_C_DESCRI := fn_descripcion_departamento(P_N_CODDEP);
        ElsIf P_TIPO = 2 then
          --provincia
          P_C_DESCRI := fn_descripcion_provincia(P_N_CODDEP, P_N_CODPRO);
        ElsIf P_TIPO = 3 then
          --distrito
          P_C_DESCRI := fn_descripcion_distrito(P_N_CODDEP,
                                                P_N_CODPRO,
                                                P_N_CODDIS);
        ElsIf P_TIPO = 4 then
          P_C_DESCRI := P_C_DIRECC;
        Else
          P_C_DESCRI := '';
        End If;
      
      Else
        P_C_DESCRI := '';
      End If;
    
    Else
      P_C_DESCRI := '';
    End If;
  
    return P_C_DESCRI;
  end;

  procedure pr_obtener_documento(P_TARJETA in char,
                                 P_PAIS    out number,
                                 P_TDOCU   out number,
                                 P_NDOC    out varchar) is
    cursor c_tarjeta(P_TARJETA in char) is
      select z0e478thp, z0e478tht, z0e478thd
        from z0e478
       where z0e478nro = P_TARJETA;
  begin
    P_PAIS  := null;
    P_TDOCU := null;
    P_NDOC  := null;
    for tarjeta in c_tarjeta(P_TARJETA) loop
      P_PAIS  := tarjeta.z0e478thp;
      P_TDOCU := tarjeta.z0e478tht;
      P_NDOC  := tarjeta.z0e478thd;
    end loop;
  end pr_obtener_documento;

  procedure pr_obtener_codigos_ubigeo(P_PAIS     in number,
                                      P_TDOCU    in number,
                                      P_NDOC     in varchar,
                                      P_N_CODDEP out number,
                                      P_N_CODPRO out number,
                                      P_N_CODDIS out number,
                                      P_C_DIRECC out char) is
    cursor c_ubigeos(P_PAIS in number, P_TDOCU in number, P_NDOC in varchar) is
      select sngc13dpto, sngc13prov, sngc13dist, sngc13dir
        from sngc13
       where sngc13pais = P_PAIS
         and sngc13tdoc = P_TDOCU
         and sngc13ndoc = P_NDOC
         and docod = 1
         and sngc13est = 'H';
  begin
    P_N_CODDEP := null;
    P_N_CODPRO := null;
    P_N_CODDIS := null;
    P_C_DIRECC := '';
  
    for ubig in c_ubigeos(P_PAIS, P_TDOCU, P_NDOC) loop
      if ubig.sngc13dpto is not null then
         if ubig.sngc13dpto > 0 then
            P_N_CODDEP := ubig.sngc13dpto;
            P_N_CODPRO := ubig.sngc13prov;
            P_N_CODDIS := ubig.sngc13dist;
            P_C_DIRECC := ubig.sngc13dir;
         end if;   
      end if;
    end loop;
  
  end pr_obtener_codigos_ubigeo;

  function fn_descripcion_departamento(P_N_CODDEP in number) return varchar is
    P_C_DESDEP fst068.depnom%type;
  begin
    begin
      select depnom
        into P_C_DESDEP
        from fst068
       where pais = 604
         and depcod = P_N_CODDEP;
    exception
      when no_data_found then
        P_C_DESDEP := ' ';
      when others then
        P_C_DESDEP := ' ';
    end;
    return P_C_DESDEP;
  end fn_descripcion_departamento;
  function fn_descripcion_provincia(P_N_CODDEP in number,
                                    P_N_CODPRO in number) return varchar is
    P_C_DESPRO fst070.locnom%type;
  begin
    begin
      select locnom
        into P_C_DESPRO
        from fst070 --pais   depcod  loccod
       where Pais = 604
         and Depcod = P_N_CODDEP
         and Loccod = P_N_CODPRO;
    exception
      when no_data_found then
        P_C_DESPRO := ' ';
      when others then
        P_C_DESPRO := ' ';
    end;
    return P_C_DESPRO;
  end fn_descripcion_provincia;
  function fn_descripcion_distrito(P_N_CODDEP in number,
                                   P_N_CODPRO in number,
                                   P_N_CODDIS in number) return varchar is
    P_C_DESDIS fst071.fst071dsc%type;
  begin
    begin
      select fst071dsc
        into P_C_DESDIS
        from fst071 --pais   depcod  loccod
       where fst071pai = 604
         and fst071dpt = P_N_CODDEP
         and fst071loc = P_N_CODPRO
         and fst071col = P_N_CODDIS;
    
    exception
      when no_data_found then
        P_C_DESDIS := ' ';
      when others then
        P_C_DESDIS := ' ';
      
    end;
    return P_C_DESDIS;
  end fn_descripcion_distrito;
end pq_ubigeo;
/

