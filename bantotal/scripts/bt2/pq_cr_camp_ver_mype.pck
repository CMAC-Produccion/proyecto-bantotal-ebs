create or replace package pq_cr_camp_ver_mype is

  -- Author  : HSUAREZ
  -- Created : 17/01/2019 5:17:12 p. m.
  -- Purpose : Campaña Verano MYPE
  /*
  -- Public type declarations
  type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  <ConstantName> constant <Datatype> := <Value>;
  
  -- Public variable declarations
  <VariableName> <Datatype>;
  
  -- Public function and procedure declarations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  */
  procedure sp_cr_mnto_max_vald_aval(instancia in number,
                                     mto_max   out number,
                                     aval      out varchar);
end pq_cr_camp_ver_mype;
/

create or replace package body pq_cr_camp_ver_mype is

  procedure sp_cr_mnto_max_vald_aval(instancia in number,
                                     mto_max   out number,
                                     aval      out varchar) is
  
    ------------
    cursor cuentas_titular(ci_pepais number, ci_petdoc number, ci_pendoc varchar) is
      select f.pgcod, f.ctnro
        from fsr008 f
       where f.pepais = ci_pepais
         and f.petdoc = ci_petdoc
         and f.pendoc = ci_pendoc
         and f.cttfir = 'T';
    ------------
    cursor creditos(p_cta number) is
      select d.pgcod,
             d.scsuc,
             d.scmda,
             d.scpap,
             d.scmod,
             d.sccta,
             d.scoper,
             d.scsbop,
             d.sctope,
             d.scfcon,
             (d.scsdo * -1) scsdo
        from fsd011 d
       where pgcod = 1
         and scmod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in (108))
         and sccta = p_cta
         and scpap = 0
         and scstat <> 99;
    ------------
    vi_monto_max  number;
    vi_pepais     fsr008.pepais%type;
    vi_petdoc     fsr008.petdoc%type;
    vi_pendoc     fsr008.pendoc%type;
    vi_pgcod      fsd011.pgcod%type;
    vi_scsuc      fsd011.scsuc%type;
    vi_scmda      fsd011.scmda%type;
    vi_scpap      fsd011.scpap%type;
    vi_scmod      fsd011.scmod%type;
    vi_sccta      fsd011.sccta%type;
    vi_scoper     fsd011.scoper%type;
    vi_scsbop     fsd011.scsbop%type;
    vi_sctope     fsd011.sctope%type;
    vi_scfcon     fsd011.scfcon%type;
    vi_scsdo      fsd011.scsdo%type;
    vi_xinstancia xwf700.xwfprcins%type;
    vi_xmonto     xwf700.xwfmonto1%type;
    flag_garantia char;
    flag_aval     char;
    flag_avalCred char;
    tipoCambio    number(15, 8);
  begin
    ---------
    begin
      --obtiendo la cuenta del cliente por instancia
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into vi_pepais, vi_petdoc, vi_pendoc
        from sng001 s
       where s.sng001inst = instancia;
    exception
      when others then
        vi_pepais := null;
        vi_petdoc := null;
        vi_pendoc := null;
    end;
    -------
    -- LOOP DE CUENTAS - 
    ------
    vi_monto_max  := 0;
    flag_aval     := 'N';
    flag_avalCred := 'N';
    ------
    begin
      for i in cuentas_titular(vi_pepais, vi_petdoc, vi_pendoc) loop
        for k in creditos(i.ctnro) loop
          flag_avalCred := 'N';
          vi_pgcod      := k.pgcod;
          vi_scsuc      := k.scsuc;
          vi_scmda      := k.scmda;
          vi_scpap      := k.scpap;
          vi_scmod      := k.scmod;
          vi_sccta      := k.sccta;
          vi_scoper     := k.scoper;
          vi_scsbop     := k.scsbop;
          vi_sctope     := k.sctope;
          vi_scfcon     := k.scfcon;
          vi_scsdo      := k.scsdo;
        
          begin
            --Obtener la instancia del credito y el monto solicitado
            select x.xwfprcins, x.xwfmonto1
              into vi_xinstancia, vi_xmonto
              from xwf700 x
             where x.xwfempresa = vi_pgcod
               and x.xwfsucursal = vi_scsuc
               and x.xwfmodulo = vi_scmod
               and x.xwfmoneda = vi_scmda
               and x.xwfpapel = vi_scpap
               and x.xwfcuenta = vi_sccta
               and x.xwfoperacion = vi_scoper
               and x.xwfsubope = vi_scsbop
               and x.xwftipope = vi_sctope
               and x.xwfcar3 = '1'
               and rownum = 1;
          exception
            when others then
              vi_xinstancia := 0;
              vi_xmonto     := 0;
          end;
          if vi_scmda <> 0 then
            begin
              select SNG120TCbi
                into tipoCambio
                from sng120
               Where SNG120Ins = vi_xinstancia
                 and SNG120Tsk = 'EVALUACION';
            exception
              when others then
                begin
                  select cotcbi
                    into tipoCambio
                    from fsh005
                   where moneda = vi_scmda
                     and cofdes = (select max(cofdes)
                                     from fsh005
                                    where moneda = vi_scmda);
                exception
                  when others then
                    tipoCambio := 1;
                end;
            end;
            vi_xmonto := vi_xmonto * tipoCambio;
          end if;
          begin
            --Verificar si la instancia del credito tiene garantia Real                   
            select 'S'
              into flag_garantia
              from sng122 s
             where s.sng122inst = vi_xinstancia
               and s.sng122mod = 70 --para solo extraer instancias con garantia
               and s.sng122tope in
                   (select f4.totope
                      from fst004 f4
                     Where f4.Modulo = 70
                       and f4.totope not in
                           (select tp1nro1
                              from fst198
                             Where Tp1cod = 1
                               and Tp1cod1 = 10881
                               and Tp1corr1 = 2
                               and Tp1corr2 = 4));
          
          exception
            when others then
              flag_garantia := 'N';
          end;
          --verifica si tiene aval
          begin
            select 'S'
              into flag_avalCred
              from sng003
             where sng001inst = vi_xinstancia
               and rownum = 1;
            flag_aval := 'S';
          exception
            when others then
              flag_avalCred := 'N';
          end;
        
          begin
            --Compara el Monto nos quedamos con el credito que cumpla las condiciones y tenga mayor Monto. 
            if flag_garantia = 'N' and flag_avalCred = 'S' then
              if vi_xmonto > vi_monto_max then
                vi_monto_max := vi_xmonto;
              end if;
            end if;
          end; --retornamos el monto máximo y -- si tiene avales o no.
        end loop;
      end loop;
    
      mto_max := vi_monto_max;
      aval    := flag_aval;
    end;
    ------
  end;
end pq_cr_camp_ver_mype;
/

