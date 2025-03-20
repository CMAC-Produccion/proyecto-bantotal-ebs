CREATE OR REPLACE TRIGGER INS_WFWRKITEMS
  after insert on wfwrkitems
  for each row
  declare
  --local variables here
  indicador            number(1);
  estado               number(1);
  contador             number(2);
  x                    number(2);
  mensaje              long;
  asunto               varchar(150);
  nombre               varchar(50);
  agencia              varchar(50);
  usuario              varchar(50);
  usuario_guia_proceso varchar(50);
  codigo               numeric(10);
begin
  --Si cambia a estado 55 verifica si tiene ingreso de opinion de lo contrario enviar correo
  mensaje   := '';
  asunto    := '';
  indicador := 1;
  estado    := 0;
  codigo    := :new.wfinsprcid; -- numero de instancia
  ---- listado depoliticas que debe cumplir
  x        := 0;
  contador := 0;
  if (:new.wftaskcod = 55) then
    ----listado--and dd.pae73pol=103
    select nvl(count(PAE70POL), 0)
      into estado
      from fpae70 vv, fpae73 dd
     where vv.pae70nro = dd.pae70nro
       and vv.pae51eva = dd.pae51eva
       and dd.pae51eva = 2
       and vv.pae70ins = codigo
       and dd.pae73pol in (select trim(cast(tpdesc as varchar(5)))
                             from FST098
                            where TPCOD = 7700
                              and tpcorr > 199
                              and tpcorr < 300)
       and vv.pae70nro = (select max(pae70nro)
                            from fpae70
                           where pae51eva = vv.pae51eva
                             and pae70ins = vv.pae70ins);
    if (estado > 0) then
      Begin

          begin
            select nvl(count(JAQZ253COD), 0)
              into indicador
              from JAQZ253
             where JAQZ253SOL = :NEW.WFINSPRCID
               and JAQZ253EST = 'A';
            select trim(penom), trim(t.Scnom)
              into nombre, agencia
              from sng001 s
             inner join FSD001 f
                on f.Pepais = s.SNG001Pais
               and f.Petdoc = s.SNG001Tdoc
               and f.Pendoc = s.SNG001NDoc
             inner join fst001 t
                on t.Sucurs = s.SNG001Age
             where s.sng001inst = :NEW.WFINSPRCID;
          end;
      end;
    End If;

    If (indicador = 0 and :new.wftaskcod = 55) then
      begin
        usuario  := '';
        contador := 0;
        select nvl(count(sng065usr), 0)
          into contador
          from SNG091 C
         inner join SNG065 D
            on C.SNG091AUT = D.SNG062AUT
         where C.SNG001INST = codigo
           and C.SNG091TPO = 'C'
           AND TO_CHAR(sng065fap, 'DD/MM/YYYY') <> '01/01/0001'
         order by D.SNG062aut DESC, sng065ord desc;
        if (contador > 0) then
          begin
            select nvl(trim(sng065usr), '')
              into usuario
              from SNG065
             where TO_CHAR(sng065fap, 'DD/MM/YYYY') <> '01/01/0001'
               and SNG062AUT in (select max(SNG091AUT)
                                   from SNG091
                                  where SNG001INST = codigo
                                    and SNG091TPO = 'C')
               and rownum = 1
             order by SNG062aut DESC;
            usuario := usuario || '@cajaarequipa.pe';
          end;
        end if;
        mensaje  := '<html>
      <head>
        <title>Alerta de Bantotal: </title>
      </head>
      <body>
        <font size = 4 color=darkblue><br><i>
           <b>Alerta de Bantotal:</i></b><hr color=darkblue><br>
           <font color=darkblue size = 4 ><br><b>Estimado(a):</b><br><br>
           El presente es para informarles que la instancia con N <b>' ||
                    to_char(codigo) || '</b> ( Nombre del cliente: ' ||
                    nombre || ' ) de la Agencia ' || agencia || ' no cuenta con ingreso de opini;n de riesgo.
           Su verificaci;n del mismo para que la instancia no se considere como bloqueante.<br><br>
           Saludos Cordiales<br><br>
           <b>Administrador Bantotal.</b></font><br><br>
      </body>
      </html>';
        asunto   := 'Alerta Bantotal - Registro de Opinion Instancia N ' ||
                    to_char(codigo);
        x        := 1;
        contador := 0;
        select nvl(max(tpcorr), 0)
          into contador
          from FST098
         where TPCOD = 7700
           and tpcorr < 100; --guia de proceso 7700 solo los registros menores de 100
        ----este correo envía al ultimo aprobador
        --asunto := asunto || usuario ;    ---esto eliminar al pasar a produccion
        --usuario := 'zsalasl@cajaarequipa.pe'; ---esto eliminar al pasar a produccion
        send_mail(usuario, --este se debe activar cuando pase a produccion para que le llegue al  último que aprobó
                      'alertariesgos@cajaarequipa.pe',
                      asunto,
                      mensaje);
        while (x <= contador) Loop
          select trim(tpdesc)
            into usuario_guia_proceso
            from FST098
           where TPCOD = 7700
             and tpcorr < 100
             and tpcorr = x;
          --dbms_output.put_line('usuario_guia_proceso:' || usuario_guia_proceso);
          usuario_guia_proceso := usuario_guia_proceso || '@cajaarequipa.pe';
          --este correo se envía a los que esta en la guia de proceso
          send_mail(usuario_guia_proceso,
                    'alertariesgos@cajaarequipa.pe',
                    asunto,
                    mensaje);
          x := x + 1;
        End loop;
      end;
    End if;
  End If;
end INS_WFWRKITEMS;
/

