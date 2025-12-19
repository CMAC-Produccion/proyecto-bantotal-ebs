create or replace package PQ_CR_EXPEDIENTE is


  -- *****************************************************************
  -- Nombre                     : CONTROLES PARA DETERMINAR EXPEDIENTE DIGITAL
  -- Sistema                    : BANTOTAL
  -- Modulo                     : CREDITOS
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2025.04.30
  -- Autor de Creacion          : DCASTRO
  -- Uso                        :
  -- Fecha de Modificacion      : 2025.05.07
  -- Autor de la Modificacion   : dcastro
  -- Descripcion de Modificacion: se modificó sp_cr_ValidaExpediente
  -- Fecha de Modificacion      : 2025.11.19 DCASTRO Se modificó funciones fn_cr_Validacion y fn_cr_Propuesta.
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_Validacion(pn_instancia in number) return char;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   Function fn_cr_Propuesta(pn_instancia in number) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_ValidaExpediente(pn_instancia in number, pc_tipo out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   Procedure sp_cr_contratacion( pn_cuenta in number,
                                pn_operacion in number,
                                pn_instancia in number,
                                pc_tipo out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Expediente(pn_cuenta in number,
                             pn_operacion in number,
                             pc_contratacion out varchar2,
                             pc_expediente out varchar2
                             );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_EXPEDIENTE;
/
create or replace package body PQ_CR_EXPEDIENTE is

  -- *****************************************************************
  -- Nombre                     : CONTROLES PARA DETERMINAR EXPEDIENTE DIGITAL
  -- Sistema                    : BANTOTAL
  -- Modulo                     : CREDITOS
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2025.04.30
  -- Autor de Creacion          : DCASTRO
  -- Uso                        :
  -- Fecha de Modificacion      : -
  -- Autor de la Modificacion   : -
  -- Descripcion de Modificacion: -
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 Function fn_cr_Validacion(pn_instancia in number) return char is
  -- *****************************************************************
  -- Nombre                     : fn_cr_Validacion
  -- Sistema                    : BANTOTAL
  -- Modulo                     : CREDITOS
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2025.04.29
  -- Autor de Creacion          : YYAMPI
  -- Uso                        :
  -- Fecha de Modificacion      : 2025.11.19 DCASTRO Se modificó script para validacion.
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  lc_existe char(1);


  Begin

     /*validación*/
     begin
  
     select resp
       into lc_existe
       from (   
          select /*+ all_rows*/
         case
            when count(*) = 0 then
             'S'
            else
             'N'
          end resp


          from (select jaqm70cue, usuarios, fecha, hora, fecha_hora
                   from (select distinct v.jaqm70cue,
                                         count(distinct v.jaqm70usr) usuarios,
                                         max(v.jaqm70fec) fecha,
                                         max(v.jaqm70hor) hora,
                                         max(TO_DATE(TO_CHAR(jaqm70fec,
                                                             'DD/MM/RRRR') || ' ' ||
                                                     jaqm70hor,
                                                     'DD/MM/RRRR HH24:MI:SS')) fecha_hora
                           from jaqm70 v
                          where v.jaqm70ins = pn_instancia
                            and v.jaqm70est = 'A'
                            and v.jaqm70hab = 'S'
                          group by v.jaqm70cue)) a,
                (select /*+all_rows*/
                 distinct t.jaqm12ins instancia, t.jaqm12cue
                   from jaqm12 t, jaqm11 f, xwf700 i
                  where t.jaqm12ins = pn_instancia
                    and f.jaqm11cui = t.jaqm12cue
                    and f.JAQM11LUO = 'XWF060'
                    AND f.JAQM11CAD < > 'IMPRESOS'
                    AND f.jaqm11cad in ('SOLICITUD', 'EVALUACION')
                    and t.jaqm12hab = 'S'
                    and i.xwfprcins = t.jaqm12ins
                    and i.xwfmodulo = t.jaqm12mod
                    and i.xwfempresa = 1
                    and i.xwfcar3 = '1'
                    and t.jaqm12mod = f.jaqm11mod
                    AND EXISTS (select 1
                           from XWF063 a
                          where a.xwfinsprcid = t.jaqm12ins
                            and a.xwfdocstvc = 'S'
                            and a.xwfdocid = f.jaqm11cod)) b,
                (select min(w.wfinsprcid) instancia,
                        max(w.wfiteminit) FECHA_INI,
                        max(w.wfitemend) FECHA_FIN
                   from wfwrkitems w
                  where w.wfinsprcid = pn_instancia) w
         where w.instancia = b.instancia(+)
           and a.jaqm70cue(+) = b.jaqm12cue
           and (w.instancia <> b.instancia or a.jaqm70cue <> b.jaqm12cue or
               nvl(a.usuarios, 0) < 2)) validacion_expediente;
               
               
     exception when others then
       lc_existe := 'N';
     end;


     return lc_existe;

  End fn_cr_Validacion;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_Propuesta(pn_instancia in number) return char is
  -- *****************************************************************
  -- Nombre                     : fn_cr_Propuesta
  -- Sistema                    : BANTOTAL
  -- Modulo                     : CREDITOS
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2025.04.29
  -- Autor de Creacion          : YYAMPI
  -- Uso                        :
  -- Fecha de Modificacion      : 2025.11.19 DCASTRO Se modificó script para propuesta.
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  lc_existe char(1);


  Begin

     /*propuesta*/
     Begin
        select /*+ all_rows */
        case
           when count(*) = 0 then
            'S'
           else
            'N'
        end resp
           into lc_existe
          from (select instancia, usuarios, fecha, hora, fecha_hora
                  from (select distinct p.jaqm9ains instancia,
                                        count(distinct p.jaqm9ausr) usuarios,
                                        max(p.jaqm9afch) fecha,
                                        max(p.jaqm9ahra) hora,
                                        max(TO_DATE(TO_CHAR(p.jaqm9afch, 'DD/MM/RRRR') || ' ' ||
                                                    p.jaqm9ahra,
                                                    'DD/MM/RRRR HH24:MI:SS')) fecha_hora
                          from jaqm9a p, xwf700 i
                         where p.jaqm9ains = pn_instancia
                           and i.xwfempresa = 1
                           and i.xwfcuenta = p.jaqm9acta
                           and i.xwfoperacion = p.jaqm9aope
                           and i.xwfcar3 = '1'
                         group by p.jaqm9ains)) a,
               (select min(w.wfinsprcid) instancia,
                       max(w.wfiteminit) FECHA_INI,
                       max(w.wfitemend) FECHA_FIN
                  from wfwrkitems w
                 where w.wfinsprcid = pn_instancia) w
        where w.instancia = a.instancia(+)
           and (w.instancia <> a.instancia or nvl(usuarios, 0) < 2) ;

     exception when others then
       lc_existe := 'N';
     end;

     return lc_existe;

  End fn_cr_Propuesta;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_ValidaExpediente(pn_instancia in number, pc_tipo out varchar2)  is
  -- *****************************************************************
  -- Nombre                     : sp_cr_ValidaExpediente
  -- Sistema                    : BANTOTAL
  -- Modulo                     : CREDITOS
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2025.04.30
  -- Autor de Creacion          : DCASTRO
  -- Uso                        :
  -- Fecha de Modificacion      : 2025.05.07 dcastro se agrego consulta a tabla jaql964
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  lc_valida char(1);
  lc_propuesta char(1);
  ln_val number(1);
  lc_tipo varchar2(50);

  Begin

    --busca instancia en JAQL964
    begin
      select j.jaql964au2v
        into lc_tipo
        from jaql964 j
        where j.jaql964ins = pn_instancia
        and rownum = 1;
    exception when others then
        lc_tipo := null;
    end;

    if lc_tipo is null then --sino existe en la tabla realiza la validacion en linea

          begin
            lc_valida := PQ_CR_EXPEDIENTE.fn_cr_Validacion(pn_instancia => pn_instancia);
          end;

          begin
            lc_propuesta := PQ_CR_EXPEDIENTE.fn_cr_Propuesta(pn_instancia => pn_instancia);
          end;

          if lc_valida = 'S' and lc_propuesta = 'S' then
             ln_val := 1; --si cumple expediente
          else
             ln_val := 2; --no cumple
          end if;

          begin
            select upper(f.tp1desc)
              into pc_tipo
              from fst198 f
             where f.tp1cod = 1
               and f.tp1cod1 = 10872
               and f.tp1corr1 = 90
               and f.tp1corr2 = 1
               and f.tp1corr3 > 0
               and f.tp1nro3 = ln_val; -- 1:si / 2 :no
          exception when others then
              pc_tipo := null;
          end;

     end if;


  End  sp_cr_ValidaExpediente;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   Procedure sp_cr_contratacion(  pn_cuenta in number,
                                  pn_operacion in number,
                                  pn_instancia in number,
                                  pc_tipo out varchar2)  is

  -- *****************************************************************
  -- Nombre                     : sp_cr_contratacion
  -- Sistema                    : BANTOTAL
  -- Modulo                     : CREDITOS
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2025.04.30
  -- Autor de Creacion          : DCASTRO
  -- Uso                        : Determina si realizó contratacion digital
  -- Fecha de Modificacion      : -
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  lc_ContratacionD varchar2(50);
  ln_cantidad number;
  lc_estado varchar2(30);

  Begin

      ln_cantidad := 0;

      begin
           select count(*)   -- >0 S / =0 N
            into ln_cantidad
            from JAQM1A --Trailer relacion Contratacion Digital
            Where JAQM1ACTA = pn_cuenta
              and JAQM1AOPE = pn_operacion
              and JAQM1AINS = pn_instancia
              and JAQM1AEST <> 'E'
              and rownum = 1 ;
              lc_ContratacionD := 'DIGITAL'; --'S';
       exception when others then
                 ln_cantidad := 0;
                 lc_ContratacionD := 'NORMAL'; -- 'N';
       end;

       if ln_cantidad = 0 then
           lc_estado := 'ERROR';
           begin
              select JAQM16TOK
                into lc_estado
                from JAQM16 -- Contratacion Digital Creditos
               Where JAQM16CTA = pn_cuenta
                 and JAQM16OPE = pn_operacion
                 and JAQM16INS = pn_instancia;
           exception when others then
              lc_estado := 'ERROR';
           end;

            If lc_estado <> 'ERROR'then
                lc_ContratacionD := 'DIGITAL'; --'S';
            Else
                lc_ContratacionD := 'NORMAL'; -- 'N';
            End If;

       end if;

        pc_tipo := lc_ContratacionD;

  End  sp_cr_contratacion;
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Expediente(pn_cuenta in number,
                             pn_operacion in number,
                             pc_contratacion out varchar2,
                             pc_expediente out varchar2
                             ) is
  -- *****************************************************************
  -- Nombre                     : sp_cr_Expediente
  -- Sistema                    : BANTOTAL
  -- Modulo                     : CREDITOS
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2025.04.29
  -- Autor de Creacion          : DCASTRO
  -- Uso                        : Retorna informacion expediente - contratacion JAQL964
  -- Fecha de Modificacion      : -
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  Begin
       begin
         select  j.jaql964au2v, j.jaql964au3v
           into  pc_expediente, pc_contratacion
           from jaql964 j
          where j.jaql964cta = pn_cuenta
            and j.jaql964ope = pn_operacion
            and rownum = 1;
       exception when others then
           pc_contratacion := '';
           pc_expediente   := '';
       end;


  End sp_cr_Expediente;

   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
End PQ_CR_EXPEDIENTE;
/
