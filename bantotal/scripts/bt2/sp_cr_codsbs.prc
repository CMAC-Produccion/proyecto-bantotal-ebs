create or replace procedure sp_cr_codsbs(p_documento in varchar2,
                                         p_tipodoc   in varchar2,
                                         p_petipo    in varchar2,
                                         p_codigo    out varchar2,
                                         p_nombre    out varchar2) is
/*cursor perfisica is
  select distinct c_codsbs
    from cldrcci
   where c_docide  = trim(p_documento)
     and c_tdocid  = p_tipodoc
     order by 1;
cursor perjuridica is
  select distinct c_codsbs
    from cldrcci
   where c_doctri = trim(p_documento)
     and c_tdoctr = p_tipodoc
     order by 1;*/
cursor CrCldrcci(numdoc varchar2, tipdoc varchar2) is
      select c_codsbs
        from (select c_codsbs
                from cldrcci
               where ((c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdoctr = tipdoc and c_doctri = numdoc))
               order by d_fecpre desc)
       where rownum = 1;
     
nombre varchar2(120);
codigosbs varchar2(10);
begin
    For cod in CrCldrcci(p_documento,p_tipodoc)loop
      codigosbs := cod.c_codsbs;
    end loop;
    p_codigo := trim(codigosbs);
    if  p_petipo = 'F' then
    --  for fcod in perfisica loop
      begin
        select c_nomdeu
          into nombre
           from cldrcci
          where c_docide  = trim(p_documento)
            and c_tdocid  = p_tipodoc
            and c_codsbs  = codigosbs
            and d_fecpre = (select max(d_fecpre)
                              from cldrcci
                              where c_docide  = trim(p_documento)
                                and c_tdocid  = p_tipodoc
                                and c_codsbs  = codigosbs);
      exception
        when no_data_found then
          nombre:= ' ';     
      end;
      p_nombre := trim(nombre);
    else
      --for jcod in perjuridica loop
      Begin
          select c_nomdeu
            into nombre
            from cldrcci
           where c_doctri = trim(p_documento)
             and c_tdoctr = p_tipodoc
             and c_codsbs  = codigosbs
             and d_fecpre = (select max(d_fecpre)
                               from cldrcci
                               where c_doctri = trim(p_documento)
                                 and c_tdoctr = p_tipodoc
                                 and c_codsbs  = codigosbs);
      exception
        when no_data_found then
            nombre:= ' ';
      end loop;
      p_nombre := trim(nombre);
    end if;

end sp_cr_codsbs;
/

