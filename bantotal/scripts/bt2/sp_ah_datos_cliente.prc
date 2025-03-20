create or replace procedure SP_AH_DATOS_CLIENTE(p_tipdoc       number,
                                                p_numdoc       varchar2,
                                                p_cliente      out char,
                                                p_nombres      out varchar2,
                                                p_apepat       out varchar2,
                                                p_apemat       out varchar2,
                                                p_empbco       out char,
                                                p_sexo         out char,
                                                p_fecnac       out date,
                                                p_cumple       out char,
                                                p_segmentacion out number,
                                                p_coderr       out number,
                                                p_deserr       out varchar2) is

  vpftcod fsd002.pftdoc%type := p_tipdoc;
  vpfncod fsd002.pfndoc%type := p_numdoc;
  vfechoy date := trunc(sysdate);

begin

  if vpftcod is null then
    vpftcod := 21;
  end if;
  
  if length(p_numdoc) <> 8 or not REGEXP_LIKE (p_numdoc, '^[0-9]+$')then
    vpftcod := 99;
  end if;
    
  
  p_cumple  := 'N';
  p_coderr  := 0;
  p_deserr  := '';
  p_cliente := 'N';

  begin
    --saca datos tabla personas BT
    select trim(PFAPE1),
           trim(PFAPE2),
           trim(PFNOM1) || ' ' || trim(PFNOM2),
           nvl(PFEBCO, 'N'),
           PFCANT,
           PFFNAC
      into p_apepat, p_apemat, p_nombres, p_empbco, p_sexo, p_fecnac
      from fsd002
     where PFPAIS = decode(vpftcod,99,PFPAIS,604)
       and PFTDOC = decode(vpftcod,99,pftdoc,vpftcod)
       and PFNDOC = vpfncod;
  
    p_cliente := 'S';
  exception
    when no_data_found then
      begin
        --ir a tabla no clientes
        select BC602APE, BC602APEM, BC602NOM, 'N', BC602SEXO, BC602FCHN
          into p_apepat, p_apemat, p_nombres, p_empbco, p_sexo, p_fecnac
          from fbc602
         where BC602PAIS = decode(vpftcod,99,BC602PAIS,604)
           and BC602TDOC = decode(vpftcod,99,BC602TDOC,vpftcod)
           and BC602NDOC = vpfncod;
      exception
        when no_data_found then
          begin
            --ir a tabla Reniec BI
            select AQPB834PATER,
                   AQPB834MATER,
                   AQPB834NOMBRE,
                   'N',
                   AQPB834SEXO,
                   to_date(AQPB834NACI, 'dd/mm/yy')
              into p_apepat,
                   p_apemat,
                   p_nombres,
                   p_empbco,
                   p_sexo,
                   p_fecnac
              from AQPB834
             where AQPB834NUMDOC = p_numdoc;
          exception
            when no_data_found then
                begin
                  --ir a tabla Reniec log
                  select JAQL1APPAT,
                         JAQL1APMAT,
                         JAQL1PRNOM,
                         'N',
                         JAQL1COSEX,
                         to_date(JAQL1FENAC, 'yyyy.mm.dd')
                    into p_apepat,
                         p_apemat,
                         p_nombres,
                         p_empbco,
                         p_sexo,
                         p_fecnac
                    from jaql001
                   where JAQL1PENDO = p_numdoc;
                exception
                  when no_data_found then
                    -- va a Reniec
                    p_coderr := 1;
                    p_deserr := 'Persona no existe en BT';
                end;
          end;
      end;
  end;

  if to_char(p_fecnac, 'ddmm') = to_char(vfechoy, 'ddmm') then
    p_cumple := 'S';
  end if;
  
  -- segmentación
  begin
    select jaql750segm
      into p_segmentacion
      from jaql750
     where JAQL750PGCO = 1
       and JAQL750PAIS = decode(vpftcod,99,JAQL750PAIS,604)
       and JAQL750TDOC = decode(vpftcod,99,JAQL750TDOC,vpftcod)
       and JAQL750NDOC = vpfncod
       and JAQL750ESTA = 'S';
  exception
    when no_data_found then
      p_segmentacion := 0;
  end;

end SP_AH_DATOS_CLIENTE;
/

