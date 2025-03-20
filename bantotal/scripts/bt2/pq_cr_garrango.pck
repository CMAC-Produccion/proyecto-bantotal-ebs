create or replace package PQ_CR_GARRANGO is

  -- Author  : MCANDIA
  -- Created : 07/03/2018 04:31:56 p.m.
  -- Purpose : 

  -- Public function and procedure declarations
  procedure SP_CR_GARRANGO;

end PQ_CR_GARRANGO;
/

create or replace package body PQ_CR_GARRANGO is

  procedure SP_CR_GARRANGO is
  
    lv_asunto        varchar2(200);
    lv_nombre        char(30);
    lv_documento     varchar2(12);
    ln_tipodocumento number(3);
    ln_pais          number(3);
    lv_cuerpo        varchar2(8000);
    lv_usuario       varchar2(50);
    lv_UserSuple     varchar2(16);
    lv_analista      varchar2(20);
    ld_fecha_i       date;
    ld_fecha_f       date;
    lc_hab_aofval    char(1);
    ld_aofval_F      date;
    ld_aofval_I      date;
    Flag_mail        char(1);
    fech_sys         date;
    Dominio          VARCHAR2(20) := '@cajaarequipa.pe';
  
    cursor garantia is
      select c.pgcod,
             c.aomod,
             c.aosuc,
             c.aomda,
             c.aopap,
             c.aocta,
             c.aooper,
             c.aosbop,
             c.aotope
        from ppg000 d, ppg008 p, fsd010 c
       Where p.PPG008Pgc = d.PPG000Pgc
         and p.PPG008Mod = d.ppg000mod
         and p.PPG008Suc = d.PPG000Suc
         and p.PPG008Mda = d.PPG000Mda
         and p.PPG008Pap = d.PPG000Pap
         and p.PPG008Cta = d.PPG000Cta
         and p.PPG008Ope = d.PPG000Ope
         and p.PPG008Sbo = d.PPG000Sbo
         and p.PPG008Top = d.PPG000Top
         and p.PPG008Corr = d.PPG000Cor
         and p.PPG008Frm = d.ppg000frm
         and p.PPG008CdAt = 149
         and p.ppg008desc <> 'Primer Rango'
         and d.ppg000tco = 'S'
         and c.pgcod = d.ppg000pgc
         and c.aomod = 70
         and c.aosuc = d.PPG000Suc
         and c.aomda = d.PPG000Mda
         and c.aopap = d.PPG000Pap
         and c.aocta = d.ppg000cta
         and c.aooper = d.ppg000ope
         and c.aosbop = d.PPG000Sbo
         and c.aotope = d.ppg000top
         and c.aostat <> 99
         and c.aostat in (select tp1nro1
                            from fst198
                           where Tp1cod = 1
                             and Tp1cod1 = 10872
                             and Tp1corr1 = 15)
         and c.aotope in
             (select totope
                from fst004
               Where Modulo = 70
                 and totope not in (select tp1nro1
                                      from fst198
                                     Where Tp1cod = 1
                                       and Tp1cod1 = 10881
                                       and Tp1corr1 = 2
                                       and Tp1corr2 = 4));
  
    cursor credito(ln_pgcod  number,
                   ln_aomod  number,
                   ln_aosuc  number,
                   ln_aomda  number,
                   ln_aopap  number,
                   ln_aocta  number,
                   ln_aooper number,
                   ln_aosbop number,
                   ln_aotope number) is
    
      select dd.pgcod,
             dd.aomod,
             dd.aosuc,
             dd.aomda,
             dd.aopap,
             dd.aocta,
             dd.aooper,
             dd.aosbop,
             dd.aotope,
             dd.aofval
        from fsr011 r, fsd010 dd
       where r.r2mod = ln_aomod
         and r.r2cta = ln_aocta
         and r.r2oper = ln_aooper
         and r.r2sbop = ln_aosbop
         and r.r2cod = ln_pgcod
         and r.r2suc = ln_aosuc
         and r.r2mda = ln_aomda
         and r.r2pap = ln_aopap
         and r.r2tope = ln_aotope
         and r.relcod = 50
         and dd.pgcod = r.r1cod
         and dd.aomod = r.r1mod
         and dd.aosuc = r.r1suc
         and dd.aomda = r.r1mda
         and dd.aopap = r.r1pap
         and dd.aocta = r.r1cta
         and dd.aooper = r.r1oper
         and dd.aosbop = r.r1sbop
         and dd.aotope = r.r1tope
         and dd.aostat <> 99;
  
    cursor Gage(ln_sucursal number) is
    
      SELECT fs.ubuser
        FROM FST046 fs,
             (select distinct (p.ubuser) usuario
                from prfu00 p
               INNER JOIN (select *
                            from fst198
                           Where Tp1cod = 1
                             and tp1cod1 = 11007
                             and TP1CORR1 = 3
                             and tp1corr2 = 1) f
                  on p.prfgcod = f.tp1desc) prf
       where fs.ubuser = prf.usuario
         and fs.ubsuc = ln_sucursal;
  
  begin
  
    for i in garantia loop
      for j in credito(i.pgcod,
                       i.aomod,
                       i.aosuc,
                       i.aomda,
                       i.aopap,
                       i.aocta,
                       i.aooper,
                       i.aosbop,
                       i.aotope) loop
      
        begin
          select fsr008.petdoc, fsr008.pepais, fsr008.pendoc
            into ln_tipodocumento, ln_pais, lv_documento
            from fsr008
           where fsr008.ttcod = 1
             and fsr008.pgcod = 1
             and fsr008.cttfir = 'T'
             and fsr008.ctnro = i.aocta;
        exception
          when others then
            null;
        end;
      
        begin
          select fsd001.penom
            into lv_nombre
            from fsd001
           where fsd001.pepais = ln_pais
             and fsd001.petdoc = ln_tipodocumento
             and fsd001.pendoc = lv_documento;
        exception
          when others then
            null;
        end;
      
        lv_asunto := trim(lv_nombre) || ' - ' ||
                     'Garantía Pendiente de Regularizar por compra de deuda';
      
        ld_fecha_i := j.aofval + 15;
        ld_fecha_f := j.aofval + 25;
      
        Flag_mail := 'N';
      
        --verificar si es dia habil 15 
        begin
          select a.fhabil
            into lc_hab_aofval
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_fecha_i
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_aofval = 'N' then
        
          begin
            select min(a.ffecha)
              into ld_aofval_I
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_fecha_i
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_aofval_I := ld_fecha_i;
        end if;
      
        --verificar si es dia habil 25
        begin
          select a.fhabil
            into lc_hab_aofval
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_fecha_f
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_aofval = 'N' then
        
          begin
            select min(a.ffecha)
              into ld_aofval_F
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_fecha_f
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_aofval_F := ld_fecha_f;
        end if;
      
        begin
          select pgfape into fech_sys from fst017 where pgcod = 1;
        exception
          when others then
            null;
        end;
      
        if ld_aofval_F = fech_sys then
          -- sysdate then
          Flag_mail := 'S';
        else
          if ld_aofval_I = fech_sys then
            -- sysdate then
            Flag_mail := 'S';
          end if;
        end if;
      
        if Flag_mail = 'S' then
        
          for a in Gage(i.aosuc) loop
          
            begin
              --// verifica suplencia      
              select sng057.sng057sup
                into lv_UserSuple
                from sng057
               where sng057.sng055emp = 1
                 and sng057.sng057sup = a.ubuser;
            exception
              when no_data_found then
                select sng057.sng057usr
                  into lv_UserSuple
                  from sng057
                 where sng057.sng055emp = 1
                   and sng057.sng057usr = a.ubuser;
            end;
          
            lv_usuario := TRIM(lv_UserSuple) || Dominio;
            lv_cuerpo  := '<html> 
                        <body>         
                           <br><b>Estimado(a),</b><br><br>  
                           En relaci&oacute;n al cliente <b>' ||
                          trim(lv_nombre) ||
                          '</b> , se encuentra pendiente de regularizar la garant&iacute;a por ser un caso de compra de deuda, a fin de evitar contingencias legales se les recuerda que deben de realizar las acciones necesarias a fin de obtener los documentos para lograr tener la prioridad en nuestra garant&iacute;a.
                                        <br>      
                           Coordinar las acciones a seguir con el personal de Garant&iacute;as encargado de la Regi&oacute;n.<br><br>
                           Saludos.                                                     
                        </body>
                        </html>';
          
            send_mail(lv_usuario,
                      'AlertaDeGanrantias' || Dominio,
                      lv_asunto,
                      lv_cuerpo);
          
          end loop;
        
          lv_analista := fn_analista_credito(j.aomod,
                                             j.aosuc,
                                             j.aomda,
                                             j.aopap,
                                             j.aocta,
                                             j.aooper,
                                             j.aosbop,
                                             j.aotope);
        
          begin
            --// verifica suplencia      
            select sng057.sng057sup
              into lv_UserSuple
              from sng057
             where sng057.sng055emp = 1
               and sng057.sng057sup = lv_analista;
          exception
            when no_data_found then
              select sng057.sng057usr
                into lv_UserSuple
                from sng057
               where sng057.sng055emp = 1
                 and sng057.sng057usr = lv_analista;
          end;
        
          lv_usuario := TRIM(lv_UserSuple) || Dominio;
          lv_cuerpo  := '<html> 
                        <body>         
                           <br><b>Estimado(a),</b><br><br>  
                           En relaci&oacute;n al cliente <b>' ||
                        trim(lv_nombre) || '</b> , se encuentra pendiente de regularizar la garant&iacute;a por ser un caso de compra de deuda, a fin de evitar contingencias legales se les recuerda que deben de realizar las acciones necesarias a fin de obtener los documentos para lograr tener la prioridad en nuestra garant&iacute;a.
                                        <br>      
                           Coordinar las acciones a seguir con el personal de Garant&iacute;as encargado de la Regi&oacute;n.<br><br>
                           Saludos.                                                     
                        </body>
                        </html>';
        
          send_mail(lv_usuario,
                    'AlertaDeGanrantias' || Dominio,
                    lv_asunto,
                    lv_cuerpo);
        
        end if;
      end loop;
    end loop;
  end;
end PQ_CR_GARRANGO;
/

