create or replace package pq_cr_aprob_extorno_rpg is

  -- *****************************************************************
  -- Nombre                     : pq_cr_aprob_extorno_rpg
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 18/09/2025
  -- Uso                        : PROCESOS DE APROBACION PARA PANEL DE EXTORNO REPROG
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Autor de la Modificación   : rcastro
  -- Descripción de Modificación: se cambia mensaje de aprobacion
  -- Fecha de Modificación      : 14/10/2025
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- Fecha de Modificación      :  
  -- *****************************************************************

  procedure sp_cr_CargaGrilla(ln_pgcod      in number,
                              ln_cuenta     in number,
                              ln_operacion  in number,
                              ln_usuarioIng in varchar2);

  PROCEDURE sp_validar_aprobac(v_pgcod      in number,
                               v_Scmod      in number,
                               v_Scsuc      in number,
                               v_Scmda      in number,
                               v_Scpap      in number,
                               v_Sccta      in number,
                               v_Scoper     in number,
                               v_Scsbop     in number,
                               v_Sctope     in number,
                               ln_fecOri    in date,
                               ln_fecReprg  in date,
                               ln_correlrpg in number,
                               outFlgAprob  out varchar2,
                               codError     out number,
                               msgError     out varchar2);
  PROCEDURE sp_aprobacion_rpg(v_pgcod      in number,
                              v_Scmod      in number,
                              v_Scsuc      in number,
                              v_Scmda      in number,
                              v_Scpap      in number,
                              v_Sccta      in number,
                              v_Scoper     in number,
                              v_Scsbop     in number,
                              v_Sctope     in number,
                              ln_fecOri    in date,
                              ln_fecReprg  in date,
                              ln_correlrpg in number,
                              ln_usuaAprob in varchar2,
                              ln_fechaApro in date,
                              outFlgAprob  out varchar2);

end pq_cr_aprob_extorno_rpg;
/
create or replace package body pq_cr_aprob_extorno_rpg is

  procedure sp_cr_CargaGrilla(ln_pgcod      in number,
                              ln_cuenta     in number,
                              ln_operacion  in number,
                              ln_usuarioIng in varchar2) is
  
    cursor lista_repr(parm_regionUsuIng number) is
      select AQPB002SUC ln_sucursal,
             AQPB002CTA ln_cuenta,
             AQPB002OPE ln_operacion,
             AQPB002EMP ln_pgcod,
             AQPB002MOD ln_modulo,
             AQPB002MDA ln_moneda,
             AQPB002PAP ln_papel,
             AQPB002SBO ln_sbop,
             AQPB002TOP ln_toper,
             AQPB002FEP ld_reprog,
             AQPB002COR ld_corr,
             nvl(AQPB002MORA, 'S') lc_mora,
             AQPB002FCTR ld_feccontrol,
             a.aqpb002fei ld_fchori
        from aqpb002 a
       where a.aqpb002emp = ln_pgcod --chernandez 10/07/2020
         and a.aqpb002cta = ln_cuenta
         and a.aqpb002ope = ln_operacion
         and a.aqpb002pro10 = 'S'
         and a.aqpb002pro11 = 'S'
         and a.aqpb002pro601 = 'S'
         and a.aqpb002pro611 = 'S'
         and a.aqpb002est = 'C'
         and nvl(a.aqpb002revr, 'N') = 'N'
         and exists (select *
                from fsd010
               where pgcod = a.aqpb002emp
                 and aomod = a.aqpb002mod
                 and aosuc = a.aqpb002suc
                 and aomda = a.aqpb002mda
                 and aopap = a.aqpb002pap
                 and aocta = a.aqpb002cta
                 and aooper = a.aqpb002ope
                 and aosbop = a.aqpb002sbo
                 and aotope = a.aqpb002top
                 and aostat <> 99)
         and exists (select *
                from regsuc
               where regcod = parm_regionUsuIng
                 and sucurs = a.aqpb002suc)
      union
      select j.jaqz698suc ln_sucursal,
             j.jaqz698cta ln_cuenta,
             j.jaqz698ope ln_operacion,
             j.jaqz698emp ln_pgcod,
             j.jaqz698mod ln_modulo,
             j.jaqz698mda ln_moneda,
             j.jaqz698pap ln_papel,
             j.jaqz698sbo ln_sbop,
             j.jaqz698top ln_toper,
             j.jaqz698fep ld_reprog,
             j.jaqz698cor ld_corr,
             nvl(j.jaqz698mora, 'S') ln_mora,
             j.jaqz698fep ld_feccontrol,
             j.jaqz698fev ld_fchori
        from jaqz698 j
       where j.jaqz698emp = ln_pgcod --chernandez 10/07/2020
         and j.jaqz698cta = ln_cuenta
         and j.jaqz698ope = ln_operacion
         and j.jaqz698est = 'C'
         and exists (select *
                from fsd010
               where pgcod = j.jaqz698emp
                 and aomod = j.jaqz698mod
                 and aosuc = j.jaqz698suc
                 and aomda = j.jaqz698mda
                 and aopap = j.jaqz698pap
                 and aocta = j.jaqz698cta
                 and aooper = j.jaqz698ope
                 and aosbop = j.jaqz698sbo
                 and aotope = j.jaqz698top
                 and aostat <> 99)
         and exists (select *
                from regsuc
               where regcod = parm_regionUsuIng
                 and sucurs = j.jaqz698suc)
      union
      
      select k.aqpb088suc ln_sucursal,
             k.aqpb088cta ln_cuenta,
             k.aqpb088ope ln_operacion,
             k.aqpb088emp ln_pgcod,
             k.aqpb088mod ln_modulo,
             k.aqpb088mda ln_moneda,
             k.aqpb088pap ln_papel,
             k.aqpb088sbo ln_sbop,
             k.aqpb088top ln_toper,
             k.aqpb088fep ld_reprog,
             k.aqpb088cor ld_corr,
             nvl(k.aqpb088mora, 'S') ln_mora,
             k.aqpb088fep ld_feccontrol,
             k.aqpb088fev ld_fchori
        from aqpb088 k
       where k.aqpb088emp = ln_pgcod --chernandez 10/07/2020
         and k.aqpb088cta = ln_cuenta
         and k.aqpb088ope = ln_operacion
         and k.aqpb088est = 'C'
         and exists (select *
                from fsd010
               where pgcod = k.aqpb088emp
                 and aomod = k.aqpb088mod
                 and aosuc = k.aqpb088suc
                 and aomda = k.aqpb088mda
                 and aopap = k.aqpb088pap
                 and aocta = k.aqpb088cta
                 and aooper = k.aqpb088ope
                 and aosbop = k.aqpb088sbo
                 and aotope = k.aqpb088top
                 and aostat <> 99)
         and exists (select *
                from regsuc
               where regcod = parm_regionUsuIng
                 and sucurs = k.aqpb088suc);
  
    ln_pais      number;
    ln_tdoc      number;
    lc_ndoc      varchar2(12);
    lc_nombre    varchar2(150);
    lc_nombage   varchar2(50);
    ln_corr      number := 0;
    ld_fchInsert date;
    lc_hora      char(8) := '00:00:00';
  
    var_sucurs     number(4);
    var_regUsuaing number(4);
  
    v_flgAprob   varchar2(1);
    v_codError   number(5);
    v_codMsg     varchar2(150);
    ln_formaFech Date;
  
  begin
  
    begin
      select ubsuc
        into var_sucurs
        from fst046
       where pgcod = ln_pgcod
         and ubuser = RPAD(ln_usuarioIng, 10, ' ');
    exception
      when others then
        null;
    end;
  
    var_sucurs := nvl(var_sucurs, 0);
  
    begin
      select REGCOD
        into var_regUsuaing
        from regsuc
       where sucurs = var_sucurs;
    exception
      when others then
        null;
    end;
  
    var_regUsuaing := nvl(var_regUsuaing, 0);
  
    begin
      delete aqpa376 a
       where a.aqpa376pgcod = ln_pgcod --chernandez 10/07/2020
         and a.aqpa376cta = ln_cuenta
         and a.aqpa376ope = ln_operacion;
      commit;
    exception
      when others then
        null;
    end;
  
    begin
      begin
        select f.pepais, f.petdoc, f.pendoc
          into ln_pais, ln_tdoc, lc_ndoc
          from fsr008 f
         where f.pgcod = 1
           and f.ctnro = ln_cuenta
           and f.cttfir = 'T';
      exception
        --mpostigoc 05.06.2020
        when others then
          null;
      end;
    
      begin
        select f.pgfape into ld_fchInsert from fst017 f where f.pgcod = 1;
      exception
        when others then
          null;
      end;
    
      If ln_tdoc = 21 and ln_pais = 604 then
        begin
          select Trim(Pfape1) || ' ' || Trim(Pfape2) || ' ' || Trim(Pfnom1) || ' ' ||
                 Trim(Pfnom2)
            into lc_nombre
            from FSD002
           Where Pfpais = ln_pais
             and Pftdoc = ln_tdoc
             and Pfndoc = rpad(lc_ndoc, 12, ' ');
        exception
          when others then
            null;
        end;
      
      else
        If ln_tdoc = 9 and ln_pais = 604 then
          begin
            select Trim(Pjrazs)
              into lc_nombre
              from fsd003
             Where Pjpais = ln_pais
               and Pjtdoc = ln_tdoc
               and Pjndoc = rpad(lc_ndoc, 12, ' ');
          exception
            when others then
              null;
          end;
        End If;
      End If;
    end;
  
    for l in lista_repr(var_regUsuaing) loop
    
      begin
        select max(a.aqpa376corr)
          into ln_corr
          from aqpa376 a
         where a.aqpa376pgcod = ln_pgcod --chernandez 10/07/2020
           and a.aqpa376cta = ln_cuenta
           and a.aqpa376ope = ln_operacion;
      exception
        when others then
          null;
      end;
    
      ln_corr := nvl(ln_corr, 0);
      begin
        select f.scnom
          into lc_nombage
          from fst001 f
         where f.pgcod = 1
           and f.sucurs = l.ln_sucursal;
      exception
        --mpostigoc 05.06.2020
        when others then
          null;
      end;
    
      begin
        select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      end;
      
      ln_formaFech := null;
      IF l.ld_fchori IS NOT NULL THEN
         ln_formaFech := l.ld_fchori;
      END IF;
    
      /* begin
        pq_cr_aprob_extorno_rpg.sp_validar_aprobac(
                                                  l.ln_pgcod,
                                                  l.ln_modulo,
                                                  l.ln_sucursal,
                                                  l.ln_moneda,
                                                  l.ln_papel,
                                                  l.ln_cuenta,
                                                  l.ln_operacion,
                                                  l.ln_sbop,
                                                  l.ln_toper,
                                                  l.ld_fchori,
                                                  l.ld_reprog,                                                  
                                                  l.ld_corr,
                                                  v_flgAprob,
                                                  v_codError,
                                                  v_codMsg);
      exception 
        when others then
           null;
      end;*/
      -- IF v_flgAprob = 'N' THEN      
    
      BEGIN
        insert into aqpa376
          (aqpa376corr,
           aqpa376pais,
           aqpa376tdoc,
           aqpa376ndoc,
           aqpa376nomb,
           aqpa376pgcod,
           aqpa376mod,
           aqpa376suc,
           aqpa376mda,
           aqpa376pap,
           aqpa376cta,
           aqpa376ope,
           aqpa376sbo,
           aqpa376top,
           aqpa376age,
           aqpa376frep,
           aqpa376corre,
           aqpa376mora,
           aqpa376fctrl,
           aqpa376fori,
           aqpa376finsr,
           aqpa376hinsr)
        values
          (ln_corr + 1,
           ln_pais,
           ln_tdoc,
           lc_ndoc,
           lc_nombre,
           l.ln_pgcod,
           l.ln_modulo,
           l.ln_sucursal,
           l.ln_moneda,
           l.ln_papel,
           l.ln_cuenta,
           l.ln_operacion,
           l.ln_sbop,
           l.ln_toper,
           lc_nombage,
           l.ld_reprog,
           l.ld_corr,
           l.lc_mora,
           l.ld_feccontrol,
           ln_formaFech, --l.ld_fchori,
           ld_fchInsert,
           lc_hora);
        commit;
      exception
        when others then
          null;
      END;
      -- END IF;
    end loop;
  end sp_cr_CargaGrilla;

  PROCEDURE sp_validar_aprobac(v_pgcod      in number,
                               v_Scmod      in number,
                               v_Scsuc      in number,
                               v_Scmda      in number,
                               v_Scpap      in number,
                               v_Sccta      in number,
                               v_Scoper     in number,
                               v_Scsbop     in number,
                               v_Sctope     in number,
                               ln_fecOri    in date,
                               ln_fecReprg  in date,
                               ln_correlrpg in number,
                               outFlgAprob  out varchar2,
                               codError     out number,
                               msgError     out varchar2) IS
    ln_formaFech date;
  
  BEGIN
    outFlgAprob := 'N';
  
   ln_formaFech := nvl(ln_fecOri, '');
  
    BEGIN
      SELECT AQPC846APROB
        INTO outFlgAprob
        FROM AQPC846
       WHERE AQPC846pgcod = v_pgcod
         AND AQPC846mod = v_Scmod
         AND AQPC846suc = v_Scsuc
         AND AQPC846mda = v_Scmda
         AND AQPC846pap = v_Scpap
         AND AQPC846cta = v_Sccta
         AND AQPC846ope = v_Scoper
         AND AQPC846sbo = v_Scsbop
         AND AQPC846top = v_Sctope
         --AND AQPC846fori = ln_formaFech
         AND AQPC846frep = ln_fecReprg
         AND AQPC846corre = ln_correlrpg
         AND ROWNUM= 1;
    EXCEPTION
     WHEN OTHERS THEN
       outFlgAprob := 'N';
      
    END;
    outFlgAprob := NVL(outFlgAprob, 'N');
  
    IF outFlgAprob = 'N' THEN
      codError := 1001;
      msgError := 'Se necesita aprobación de Gerente Regional.';
    END IF;
  
  END;

  PROCEDURE sp_aprobacion_rpg(v_pgcod      in number,
                              v_Scmod      in number,
                              v_Scsuc      in number,
                              v_Scmda      in number,
                              v_Scpap      in number,
                              v_Sccta      in number,
                              v_Scoper     in number,
                              v_Scsbop     in number,
                              v_Sctope     in number,
                              ln_fecOri    in date,
                              ln_fecReprg  in date,
                              ln_correlrpg in number,
                              ln_usuaAprob in varchar2,
                              ln_fechaApro in date,
                              outFlgAprob  out varchar2) IS
    vHora   varchar2(10);
    ln_corr number(10);
    auxFecha date;
  BEGIN
    outFlgAprob := 'N';
    begin
      select to_char(sysdate, 'HH24:MI:SS') into vHora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.AQPC846corr)
        into ln_corr
        from AQPC846 a
       where a.AQPC846pgcod = v_pgcod
         and a.AQPC846mod = v_Scmod
         and a.AQPC846suc = v_Scsuc
         and a.AQPC846mda = v_Scmda
         and a.AQPC846pap = v_Scpap
         and a.AQPC846cta = v_Sccta
         and a.AQPC846ope = v_Scoper
         and a.AQPC846sbo = v_Scsbop
         and a.AQPC846top = v_Sctope;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
    
    auxFecha := null;
    if ln_fecOri <= to_date('01/01/01', 'dd/MM/YYYY') then
       auxFecha := null;
    else
       auxFecha := ln_fecOri;
    End If;
  
    BEGIN
      INSERT INTO AQPC846
        (AQPC846corr,
         AQPC846pgcod,
         AQPC846mod,
         AQPC846suc,
         AQPC846mda,
         AQPC846pap,
         AQPC846cta,
         AQPC846ope,
         AQPC846sbo,
         AQPC846top,
         -- AQPC846age   ,
         AQPC846fori,
         AQPC846frep,
         AQPC846corre,
         AQPC846APROB,
         AQPC846USUAPR,
         AQPC846HORAPR,
         AQPC846FECAPR)
      VALUES
        (ln_corr + 1,
         v_pgcod,
         v_Scmod,
         v_Scsuc,
         v_Scmda,
         v_Scpap,
         v_Sccta,
         v_Scoper,
         v_Scsbop,
         v_Sctope,
         auxFecha,
         ln_fecReprg,
         ln_correlrpg,
         'S',
         ln_usuaAprob,
         vHora,
         ln_fechaApro);
      COMMIT;
    
      outFlgAprob := 'S';
    exception
      when others then
        outFlgAprob := 'N';
    END;
  END;

end pq_cr_aprob_extorno_rpg;
/
