create or replace procedure sp_alerta_creven  is

  -- *****************************************************************
  -- Nombre                     : sp_alerta_creven
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.10.10
  -- Autor de Creación          : PVARGAS
  -- Uso                        : Enviar correo a analista de créditos vencidos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_C_NUMCAR ( NUMERO CORRELATIVO DE LA CARTA FIANZA )
  -- Parámetros de Salida       :
  -- Retorno                    : CODIGO DE AFIANZADO.
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************

  --- CURSOR DE ALERTAS
   CURSOR c_alerta (tipcam in number)
       IS Select *
            From (
                  select jaql964usu codusu,
                         nomana,
                         count(distinct jaql964pai||jaql964tid||jaql964doc) numcli,
                         count(distinct jaql964cta||jaql964ope||jaql964top) numcre,
                         sum(saldo) Saldo,
                         trim(lower(jaql964usu))||'@cajaarequipa.pe' correo,
                         'Desde hoy hasta el día '||trim(to_char(trunc(sysdate) + 5,'day dd month', 'nls_date_language=Spanish'))||', ingresarán a estado VENCIDO ' diamax,
                         'P' tipo
                    from(
                  select --r.regnom,
                         --r.scnom,
                         j.jaql964usu,
                         trim(initcap(u.ubnom)) nomana,
                         j.jaql964suc,
                         j.jaql964pai,
                         j.jaql964tid,
                         j.jaql964doc,
                         j.jaql964dia,
                         -nvl(j.jaql964sac,0) saldo,
                         decode(j.jaql964mda,0,j.jaql964cuo,j.jaql964cuo*tipcam) mtocuo,
                         j.jaql964pro,
                         -nvl(j.jaql964sdve,0) salven,
                         j.jaql964cta,
                         j.jaql964ope,
                         j.jaql964top
                    from jaql964 j --join regsuc@por r on r.sucurs = j.jaql964suc
                                   join fst746 u on u.ubuser = rpad(j.jaql964usu,10,' ')
                   where j.jaql964fec = trunc(sysdate)
                     and (((jaql964pro like 'MICRO%' or  jaql964pro like 'PEQUE%' or j.jaql964mod = 108)
                            and jaql964dia between (31-6)+1 and 31
                           ) Or
                           (jaql964pro like 'MEDIAN%'and jaql964dia between (16-6)+1 and 16) Or
                           ((jaql964pro like 'CONSU%' or  jaql964pro like 'HIPOT%')
                            and jaql964dia between (91-6)+1 and 91
                           )
                         )
                  UNION ALL
                  select --r.regnom,
                         --r.scnom,
                         j.jaql964usu codana,
                         trim(initcap(u.ubnom)) nomana,
                         j.jaql964suc codsuc,
                         j.jaql964pai pepais,
                         j.jaql964tid petdoc,
                         j.jaql964doc pendoc,
                         j.jaql964dia diaatr,
                         decode(j.jaql964mda,0,j.jaql964cuo,j.jaql964cuo*tipcam) + (-nvl(j.jaql964sdve,0)) saldo,
                         decode(j.jaql964mda,0,j.jaql964cuo,j.jaql964cuo*tipcam) mtocuo,
                         j.jaql964pro tipcre,
                         -nvl(j.jaql964sdve,0) salven,
                         j.jaql964cta,
                         j.jaql964ope,
                         j.jaql964top
                    from jaql964 j --join regsuc r on r.sucurs = j.jaql964suc
                                   join fst746 u on u.ubuser = rpad(j.jaql964usu,10,' ')
                   where j.jaql964fec = trunc(sysdate)
                     and jaql964pro like 'CONSU%'
                     and jaql964dia between (32-6)+1 and 32
                     and j.jaql964mod not in (33,141,108,200)
                  ) where jaql964top <> 550
                  Group by jaql964usu,
                         nomana

                  -----
                  union all

                  select jaql964usu codusu,
                         nomana,
                         count(distinct jaql964pai||jaql964tid||jaql964doc) numcli,
                         count(distinct jaql964cta||jaql964ope||jaql964top) numcre,
                         sum(saldo) Saldo,
                         trim(lower(jaql964usu))||'@cajaarequipa.pe' correo,
                         'Ayer,'||trim(to_char(trunc(sysdate) + 5,'day dd month', 'nls_date_language=Spanish'))||', ingresaron a estado VENCIDO ' diamax,
                         'R' tipo
                    from(
                  select --r.regnom,
                         --r.scnom,
                         j.jaql964usu,
                         trim(initcap(u.ubnom)) nomana,
                         j.jaql964suc,
                         j.jaql964pai,
                         j.jaql964tid,
                         j.jaql964doc,
                         j.jaql964dia,
                         -nvl(j.jaql964sac,0) saldo,
                         decode(j.jaql964mda,0,j.jaql964cuo,j.jaql964cuo*tipcam) mtocuo,
                         j.jaql964pro,
                         -nvl(j.jaql964sdve,0) salven,
                         j.jaql964cta,
                         j.jaql964ope,
                         j.jaql964top
                    from jaql964 j --join regsuc r on r.sucurs = j.jaql964suc
                                   join fst746 u on u.ubuser = rpad(j.jaql964usu,10,' ')
                   where j.jaql964fec = trunc(sysdate)
                     and (((jaql964pro like 'MICRO%' or  jaql964pro like 'PEQUE%' or j.jaql964mod = 108)
                            and jaql964dia = 32
                           ) Or
                           (jaql964pro like 'MEDIAN%'and jaql964dia =17) Or
                           ((jaql964pro like 'CONSU%' or  jaql964pro like 'HIPOT%')
                            and jaql964dia = 92
                           )
                         )
                  UNION ALL
                  select --r.regnom,
                         --r.scnom,
                         j.jaql964usu codana,
                         trim(initcap(u.ubnom)) nomana,
                         j.jaql964suc codsuc,
                         j.jaql964pai pepais,
                         j.jaql964tid petdoc,
                         j.jaql964doc pendoc,
                         j.jaql964dia diaatr,
                         decode(j.jaql964mda,0,j.jaql964cuo,j.jaql964cuo*tipcam) + (-nvl(j.jaql964sdve,0)) saldo,
                         decode(j.jaql964mda,0,j.jaql964cuo,j.jaql964cuo*tipcam) mtocuo,
                         j.jaql964pro tipcre,
                         -nvl(j.jaql964sdve,0) salven,
                         j.jaql964cta,
                         j.jaql964ope,
                         j.jaql964top
                    from jaql964 j --join regsuc r on r.sucurs = j.jaql964suc
                                   join fst746 u on u.ubuser = rpad(j.jaql964usu,10,' ')
                   where j.jaql964fec = trunc(sysdate)
                     and jaql964pro like 'CONSU%'
                     and jaql964dia = 33
                     and j.jaql964mod not in (33,141,108,200)
                  ) where jaql964top <> 550
                  Group by jaql964usu,
                            nomana
                )
                --where codusu in ('AAPAZAV','AAQUINOQ','ABETANCURT') ---eliminar
                Order by codusu;

    ln_tipcam number(14,8);
    lv_codusu varchar2(10);
    lv_msgpre varchar2(1000);
    lv_msgrea varchar2(1000);
    lv_correo varchar2(100);
    lv_nomusu varchar2(50);
    msgmail varchar2(10000);
    ln_coma number(5);
    ln_espa number(5);

  BEGIN
           -- Obtiene Tipo de Cambio
           Begin
                 Select cotcbi
                   Into ln_tipcam
                   From (
                           select u.cotcbi
                             From fsh005 u
                            Where moneda=101
                              And cofdes <= trunc(sysdate)
                         Order by cofdes desc
                        )
                  Where rownum = 1;
           Exception When Others Then
              ln_tipcam := 0;
           End;

     --- Envio de Correo
     For x in c_alerta(ln_tipcam) Loop
         If lv_codusu is null or lv_codusu=x.codusu Then
            lv_correo := x.correo;
            lv_nomusu := x.nomana;
            If x.tipo = 'P' Then

               lv_msgpre := x.diamax||to_char(x.numcre)||' crédito(s), de '||to_char(x.numcli)
                          ||' cliente(s); que representan S/.'||trim(to_char(x.saldo,'999,9999,999.99'));
            Else
               lv_msgrea := x.diamax||to_char(x.numcre)||' crédito(s), de '||to_char(x.numcli)
                          ||' cliente(s); que representan S/.'||trim(to_char(x.saldo,'999,9999,999.99'));
            End IF;
            lv_codusu := x.codusu;
         Else
             ln_coma   := instr(lv_nomusu,',');
             lv_nomusu := trim(substr(lv_nomusu,ln_coma+1));
             ln_espa   := instr(lv_nomusu,' ');
             IF ln_espa > 0 Then
                lv_nomusu := trim(substr(lv_nomusu,1,ln_espa-1));
             End IF;

             msgmail := 'Buenos días '||lv_nomusu||':'||chr(12)||chr(13)||chr(13)
                       ||lv_msgrea||chr(12)||chr(13)
                       ||lv_msgpre||chr(12)||chr(13)||chr(13)
                       ||'En el sistema Bantotal, ingresa a la opción "Menú de Reportes > Reportes Activas" y emite el "REPORTE DE CREDITOS POR VENCER Y VENCIDOS" para conocer el detalle de los clientes y gestionarlos.'||chr(12)||chr(13)
                       ||'- Para la emisión de los clientes que vencieron ayer, selecciona la opción "Vencidos" y en el parámetro "Vencido hace(Días)" ingresa: 1.'||chr(12)||chr(13)
                       ||'- Para la emisión de los clientes que ingresarán a estado VENCIDO, selecciona la opción "Por Vencer" y en el parámetro "Vence dentro(Días)" ingresa: 6.'
                       ||chr(12)||chr(13)||chr(13)||'NOTA: Un crédito ingresa a estado VENCIDO:'||chr(12)||chr(13)
                       ||'* Micro Empresa ,Pequeña Empresa y Prendario: atraso mayor a 30 días.'||chr(12)||chr(13)
                       ||'* Mediana Empresa: atraso mayor a 15 días.'||chr(12)||chr(13)
                       ||'* Consumo e Hipotecario: atraso mayor a 90 días.'||chr(12)||chr(13)
                       ||'*** En Consumo e Hipotecario con atraso mayor a 30 días el saldo capital de la cuota ingresa a VENCIDO.';

            ---ENVIAR CORREO
            --dbms_output.put_line(msgmail);

            --lv_correo := 'inteligencianegocios@cajaarequipa.pe';
            sys.sp_sy_enviamail('inteligencianegocios@cajaarequipa.pe',
                                lv_correo,
                                'CREDITOS EN ESTADO VENCIDO',
                                msgmail
                               );

            /*sys.sp_sy_enviamail('inteligencianegocios@cajaarequipa.pe',
                                'inteligencianegocios@cajaarequipa.pe',
                                'CREDITOS EN ESTADO VENCIDO',
                                msgmail
                               );*/

            -----

            lv_correo := x.correo;
            lv_nomusu := x.nomana;
            lv_codusu := x.codusu;
            lv_msgpre := null;
            lv_msgrea := null;

            If x.tipo = 'P' Then
               lv_msgpre := x.diamax||to_char(x.numcre)||' crédito(s), de '||to_char(x.numcli)
                          ||' cliente(s); que representan S/.'||trim(to_char(x.saldo,'999,9999,999.99'));
            Else
               lv_msgrea := x.diamax||to_char(x.numcre)||' crédito(s), de '||to_char(x.numcli)
                          ||' cliente(s); que representan S/.'||trim(to_char(x.saldo,'999,9999,999.99'));
            End IF;

         End If;

     End Loop;

             ln_coma   := instr(lv_nomusu,',');
             lv_nomusu := trim(substr(lv_nomusu,ln_coma+1));
             ln_espa   := instr(lv_nomusu,' ');
             IF ln_espa > 0 Then
                lv_nomusu := trim(substr(lv_nomusu,1,ln_espa-1));
             End If;
             msgmail := 'Buenos días '||lv_nomusu||':'||chr(12)||chr(13)||chr(13)
                       ||lv_msgrea||chr(12)||chr(13)
                       ||lv_msgpre||chr(12)||chr(13)||chr(13)
                       ||'En el sistema Bantotal, ingresa a la opción "Menú de Reportes > Reportes Activas" y emite el "REPORTE DE CREDITOS POR VENCER Y VENCIDOS" para conocer el detalle de los clientes y gestionarlos.'||chr(12)||chr(13)
                       ||'- Para la emisión de los clientes que vencieron ayer, selecciona la opción "Vencidos" y en el parámetro "Vencido hace(Días)" ingresa: 1.'||chr(12)||chr(13)
                       ||'- Para la emisión de los clientes que ingresarán a estado VENCIDO, selecciona la opción "Por Vencer" y en el parámetro "Vence dentro(Días)" ingresa: 6.'
                       ||chr(12)||chr(13)||chr(13)||'NOTA: Un crédito ingresa a estado VENCIDO:'||chr(12)||chr(13)
                       ||'* Micro Empresa ,Pequeña Empresa y Prendario: atraso mayor a 30 días.'||chr(12)||chr(13)
                       ||'* Mediana Empresa: atraso mayor a 15 días.'||chr(12)||chr(13)
                       ||'* Consumo e Hipotecario: atraso mayor a 90 días.'||chr(12)||chr(13)
                       ||'*** En Consumo e Hipotecario con atraso mayor a 30 días el saldo capital de la cuota ingresa a VENCIDO.';
     ---ENVIAR CORREO
     --lv_correo := 'inteligencianegocios@cajaarequipa.pe';
     sys.sp_sy_enviamail('inteligencianegocios@cajaarequipa.pe',
                         lv_correo,
                         'CREDITOS EN ESTADO VENCIDO',
                         msgmail
                        );
     /*sys.sp_sy_enviamail('inteligencianegocios@cajaarequipa.pe',
                         'inteligencianegocios@cajaarequipa.pe',
                         'CREDITOS EN ESTADO VENCIDO',
                         msgmail
                        );*/

     --dbms_output.put_line(msgmail);
     ----------------

end sp_alerta_creven;
/

