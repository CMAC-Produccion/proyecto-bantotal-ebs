create or replace package pq_cr_exocastigado is


  -- ***************************************************************************************************************************
  -- Nombre                     : Paquete para el Módulo de Autonomías de los créditos Judiciales
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 13/11/2024
  -- Autor de Creación          : KVALENCIAC
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- *************************************************************************************************************************** 
procedure sp_es_exonerado (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,                                   
                                   ln_Indicador out number,
                                   ln_monto out number);   
procedure sp_valida       (        vn_codigo in number,
                                   vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   lc_mensaje out varchar);
procedure sp_inserta      (       vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vd_pgfape  in date,
                                   vc_usuario in  varchar,
                                   lc_mensaje out varchar);                                    
procedure sp_extorna      (        
                                   vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vc_usuario in varchar,
                                   vd_pgfape  in date); 
procedure sp_Esexcepcionado       (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vn_ppfpag in date, 
                                   vn_tipo in number,
                                   ln_Indicador out number); 
procedure sp_validamonto ( vn_Pgcod in number, 
                                vn_ppmod in number, 
                                vn_ppsuc in number, 
                                vn_ppmda in number, 
                                vn_pppap in number,
                                vn_ppcta in number, 
                                vn_ppoper in number,
                                vn_ppsbop in number,
                                vn_pptope in number,
                                vn_Indicador out number,
                                vn_montoexo out number,
                                vn_montoutlcuo out number); 
procedure sp_plazo ( vn_Pgcod in number, 
                                vn_ppmod in number, 
                                vn_ppsuc in number, 
                                vn_ppmda in number, 
                                vn_pppap in number,
                                vn_ppcta in number, 
                                vn_ppoper in number,
                                vn_ppsbop in number,
                                vn_pptope in number,
                                 vn_tipo out number,
                                vn_plazo out number);  
procedure sp_extorna2      (        
                                   vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vc_usuario in varchar,
                                   vd_pgfape  in date);                                                                                                          
-------------------------------------------------
end pq_cr_exocastigado;
/

create or replace package body pq_cr_exocastigado is
--valida si es exonerado de última cuota
procedure sp_es_exonerado (vn_Pgcod in number,   
                           vn_ppmod in number, 
                           vn_ppsuc in number, 
                           vn_ppmda in number, 
                           vn_pppap in number,
                           vn_ppcta in number, 
                           vn_ppoper in number,
                           vn_ppsbop in number, 
                           vn_pptope in number,                            
                           ln_Indicador out number,
                           ln_monto out number)

is
begin
  ln_Indicador:=0;
  begin
      select 1,JAQN8HTEX into ln_Indicador,ln_monto
      from JAQN8H
      where JAQN8HEMP = vn_Pgcod
       and JAQN8HMOD = vn_ppmod
       and JAQN8HSUC = vn_ppsuc
       and JAQN8HMDA = vn_ppmda
       and JAQN8HPAP = vn_pppap
       and JAQN8HCTA = vn_ppcta
       and JAQN8HOPE = vn_ppoper
       and JAQN8HSBO = vn_ppsbop
       and JAQN8HTOP = vn_pptope
       and JAQN8HEST ='G';--G esta en estado de exoneración
   exception 
      when others then
        ln_Indicador :=0;
   end;       
end  sp_es_exonerado;
procedure sp_valida (    vn_codigo in number,
                         vn_Pgcod in number, 
                         vn_ppmod in number, 
                         vn_ppsuc in number, 
                         vn_ppmda in number, 
                         vn_pppap in number,
                         vn_ppcta in number, 
                         vn_ppoper in number,
                         vn_ppsbop in number, 
                         vn_pptope in number,                        
                         lc_mensaje out varchar)
is

ln_Indicador number(1);
lc_horaa varchar(10);
ld_fechaj date;
lc_horaj varchar(10);
ld_fechainia date;
ln_horaa number(2);
ln_horaj number(2);
ln_mina number(2);
ln_minj number(2);
ln_sega number(2);
ln_segj number(2);
ln_existe number(1);
begin
  lc_mensaje:='';
  --solo valida con la tabla de saldos JAQN8H
  begin
       select 1,JAQN8Hfec,JAQN8Hhum into ln_existe,ld_fechaj,lc_horaj
          from JAQN8H
          where JAQN8HEMP = vn_Pgcod
           and JAQN8HMOD = vn_ppmod
           and JAQN8HSUC = vn_ppsuc
           and JAQN8HMDA = vn_ppmda
           and JAQN8HPAP = vn_pppap
           and JAQN8HCTA = vn_ppcta
           and JAQN8HOPE = vn_ppoper
           and JAQN8HSBO = vn_ppsbop
           and JAQN8HTOP = vn_pptope
           and JAQN8Hest = 'G';
       exception 
          when others then
            ln_existe :=0;
            lc_horaj:='';
            ln_Indicador:=1;
  end;
  
  if ( ln_existe = 1 ) then
     --busco hora y fecha de acuerdo de pago
     begin       
       select aqpa806hori,aqpa806feci into lc_horaa, ld_fechainia
         from aqpa806 a
       where a.aqpa806pgc = vn_Pgcod
         and a.aqpa806mod = vn_ppmod
         and a.aqpa806suc = vn_ppsuc
         and a.aqpa806mda = vn_ppmda
         and a.aqpa806pap = vn_pppap
         and a.aqpa806cta = vn_ppcta
         and a.aqpa806ope = vn_ppoper
         and a.aqpa806sbo = vn_ppsbop
         and a.aqpa806tpo = vn_pptope
         and a.aqpa806est ='P';  --en proceso
     exception 
        when others then
          lc_horaa:=null;
          ld_fechainia:=null;
     end;  
     if ( ld_fechaj >ld_fechainia) then
        ln_Indicador:=2;
     else
        ln_horaa := to_number(substr(lc_horaa,1,2));
        ln_horaj := to_number(substr(lc_horaj,1,2));
        ln_mina := to_number(substr(lc_horaa,4,2));
        ln_minj := to_number(substr(lc_horaj,4,2));
        ln_sega := to_number(substr(lc_horaa,7,2));
        ln_segj := to_number(substr(lc_horaj,7,2));
        if ( ld_fechaj = ld_fechainia ) then
          if ( ln_horaj > ln_horaa ) then
            ln_Indicador:=2;
          else
            if ( ln_horaj = ln_horaa and ln_minj > ln_mina ) then
               ln_Indicador:=2;
            end if;
            if ( ln_horaj = ln_horaa and ln_minj = ln_mina and ln_segj > ln_sega ) then
               ln_Indicador:=2;
            end if;
          end if;  
        end if;
     end if;
   else
     ln_Indicador:=1;
   end if;
   lc_mensaje:=''; 
   case ln_Indicador
     when 1 then lc_mensaje:='La exoneración ha sido rechazada no puede Confirmar.';
     when 2 then lc_mensaje:='Debe volver a iniciar el proceso del Acuerdo de Pago ya que ha generado una exoneración posterior a la ejecución del Acuerdo.';
     else  lc_mensaje:='';
   end case;
   if (ln_Indicador<4) then
     update aqpa806 set aqpa806menex=lc_mensaje
     where aqpa806cod=vn_codigo;
     commit;
   end if;
end  sp_valida;   
procedure sp_inserta (   vn_Pgcod in number, 
                         vn_ppmod in number, 
                         vn_ppsuc in number, 
                         vn_ppmda in number, 
                         vn_pppap in number,
                         vn_ppcta in number, 
                         vn_ppoper in number,
                         vn_ppsbop in number, 
                         vn_pptope in number,
                         vd_pgfape  in date,
                         vc_usuario in  varchar,                        
                         lc_mensaje out varchar)
is
lc_hora varchar(8);
begin
   lc_mensaje:='';
   lc_hora:=substr(current_timestamp,10,8);
   update JAQN8H set JAQN8HEST='C',JAQN8Hfec=vd_pgfape
     where JAQN8HEMP = vn_Pgcod
       and JAQN8HMOD = vn_ppmod
       and JAQN8HSUC = vn_ppsuc
       and JAQN8HMDA = vn_ppmda
       and JAQN8HPAP = vn_pppap
       and JAQN8HCTA = vn_ppcta
       and JAQN8HOPE = vn_ppoper
       and JAQN8HSBO = vn_ppsbop
       and JAQN8HTOP = vn_pptope
       and JAQN8HEST = 'G';
   commit;
   insert into aqpd225
      (AQPD225COD,   
       AQPD225MOD,  
       AQPD225SUC,   
       AQPD225MDA,   
       AQPD225PAP,   
       AQPD225CTA,   
       AQPD225OPE,   
       AQPD225SBO,   
       AQPD225TPO,   
       AQPD225EST,   
       AQPD225USUACT,
       AQPD225FECACT,
       AQPD225HORACT,
       AQPD225TIP)
    values
       (vn_Pgcod, 
       vn_ppmod, 
       vn_ppsuc, 
       vn_ppmda, 
       vn_pppap,
       vn_ppcta, 
       vn_ppoper,
       vn_ppsbop,
       vn_pptope,
       'C',
       vc_usuario,--fecha de actualización
       vd_pgfape,--usuario de actualización 
       lc_hora ,       
       'Exoneración Ultima cuota estado 90-JAQN8H');--tipo  
    commit;         
end  sp_inserta;
procedure sp_extorna (   vn_Pgcod in number, 
                         vn_ppmod in number, 
                         vn_ppsuc in number, 
                         vn_ppmda in number, 
                         vn_pppap in number,
                         vn_ppcta in number, 
                         vn_ppoper in number,
                         vn_ppsbop in number, 
                         vn_pptope in number,
                         vc_usuario in varchar,
                         vd_pgfape  in date)
is

begin
   
   update aqpa806 set aqpa806est='I',aqpa806fecactr=vd_pgfape,aqpa806usuactr=vc_usuario
     where aqpa806pgc = vn_Pgcod
       and aqpa806mod = vn_ppmod
       and aqpa806suc = vn_ppsuc
       and aqpa806mda = vn_ppmda
       and aqpa806pap = vn_pppap
       and aqpa806cta = vn_ppcta
       and aqpa806ope = vn_ppoper
       and aqpa806sbo = vn_ppsbop
       and aqpa806tpo = vn_pptope
       and aqpa806est = 'S';
   update JAQN8H set JAQN8HEST='A',JAQN8Hfec=vd_pgfape
      where JAQN8HEMP= vn_Pgcod
       and JAQN8HMOD = vn_ppmod
       and JAQN8HSUC = vn_ppsuc
       and JAQN8HMDA = vn_ppmda
       and JAQN8HPAP = vn_pppap
       and JAQN8HCTA = vn_ppcta
       and JAQN8HOPE = vn_ppoper
       and JAQN8HSBO = vn_ppsbop
       and JAQN8HTOP = vn_pptope
       and JAQN8HEST = 'C';
   update aqpd225 set AQPD225EST='A', AQPD225FECEXT=vd_pgfape
   where AQPD225COD= vn_Pgcod 
     and AQPD225MOD= vn_ppmod
     and AQPD225SUC= vn_ppsuc 
     and AQPD225MDA= vn_ppmda 
     and AQPD225PAP= vn_pppap 
     and AQPD225CTA= vn_ppcta 
     and AQPD225OPE= vn_ppoper 
     and AQPD225SBO= vn_ppsbop 
     and AQPD225TPO= vn_pptope 
     and AQPD225EST= 'C'; 
    commit;         
end  sp_extorna;  
procedure sp_Esexcepcionado (vn_Pgcod in number, 
                         vn_ppmod in number, 
                         vn_ppsuc in number, 
                         vn_ppmda in number, 
                         vn_pppap in number,
                         vn_ppcta in number, 
                         vn_ppoper in number,
                         vn_ppsbop in number, 
                         vn_pptope in number,
                         vn_ppfpag in date,
                         vn_tipo in number,
                         ln_Indicador out number)
is
begin
  ln_Indicador:=0;
  begin
      select 1 into ln_Indicador
      from AQPD224
      where AQPD224COD = vn_Pgcod
       and AQPD224MOD = vn_ppmod
       and AQPD224SUC = vn_ppsuc
       and AQPD224MDA = vn_ppmda
       and AQPD224PAP = vn_pppap
       and AQPD224CTA = vn_ppcta
       and AQPD224OPE = vn_ppoper
       and AQPD224SBO = vn_ppsbop
       and AQPD224TPO = vn_pptope
       and AQPD224EST = 'A'
       and AQPD224TIPE = vn_tipo;
   exception 
      when others then
        ln_Indicador :=0;      
   end;       
end  sp_Esexcepcionado;
procedure sp_validamonto ( vn_Pgcod in number, 
                                vn_ppmod in number, 
                                vn_ppsuc in number, 
                                vn_ppmda in number, 
                                vn_pppap in number,
                                vn_ppcta in number, 
                                vn_ppoper in number,
                                vn_ppsbop in number, 
                                vn_pptope in number,
                                vn_Indicador out number,
                                vn_montoexo out number,
                                vn_montoutlcuo out number)
is
ln_montoexo number(18,2):=0;
ln_ultimacuota number(18,2):=0;
ln_cod number(17):=0;
begin
  begin
      select JAQN8HTEX into ln_montoexo
      from JAQN8H
      where JAQN8HEMP = vn_Pgcod
       and JAQN8HMOD = vn_ppmod
       and JAQN8HSUC = vn_ppsuc
       and JAQN8HMDA = vn_ppmda
       and JAQN8HPAP = vn_pppap
       and JAQN8HCTA = vn_ppcta
       and JAQN8HOPE = vn_ppoper
       and JAQN8HSBO = vn_ppsbop
       and JAQN8HTOP = vn_pptope
       and JAQN8HEST='G';
   exception 
      when others then
        ln_montoexo :=0;
   end;
   begin
     select aqpa806cod into ln_cod
     from aqpa806 a
     where a.aqpa806pgc = vn_Pgcod
     and a.aqpa806mod = vn_ppmod
     and a.aqpa806suc = vn_ppsuc
     and a.aqpa806mda = vn_ppmda
     and a.aqpa806pap = vn_pppap
     and a.aqpa806cta = vn_ppcta
     and a.aqpa806ope = vn_ppoper
     and a.aqpa806sbo = vn_ppsbop
     and a.aqpa806tpo = vn_pptope
     and a.aqpa806est ='P';  --en proceso
   exception 
      when others then
        ln_cod :=0;
   end;
   begin
     select aqpa807cuoval into ln_ultimacuota
     from aqpa807
     where aqpa806cod = ln_cod
     and aqpa807cuonro in ( select max(aqpa807cuonro)
                             from aqpa807
                             where aqpa806cod = ln_cod);
   exception 
      when others then
        ln_ultimacuota :=0;
   end;
   vn_montoexo:=ln_montoexo;
   vn_montoutlcuo:=ln_ultimacuota;
   if ( ln_ultimacuota <> ln_montoexo ) then
      vn_Indicador:=1;  --devuelve 1 si el monto a exonerar es mayor a la ultima cuota del cronograma
   else
      vn_Indicador:=0;
   end if;
end sp_validamonto;  
procedure sp_plazo ( vn_Pgcod in number, 
                                vn_ppmod in number, 
                                vn_ppsuc in number, 
                                vn_ppmda in number, 
                                vn_pppap in number,
                                vn_ppcta in number, 
                                vn_ppoper in number,
                                vn_ppsbop in number, 
                                vn_pptope in number,
                                vn_tipo out number,
                                vn_plazo out number)
is
ln_cod number(17):=0;
ld_fechaini date;
ln_cuofpg date;
ln_Indicador number;
ln_tipo number;
begin
   begin
     select aqpa806cod,aqpa806feci into ln_cod, ld_fechaini
     from aqpa806 a
     where a.aqpa806pgc = vn_Pgcod
     and a.aqpa806mod = vn_ppmod
     and a.aqpa806suc = vn_ppsuc
     and a.aqpa806mda = vn_ppmda
     and a.aqpa806pap = vn_pppap
     and a.aqpa806cta = vn_ppcta
     and a.aqpa806ope = vn_ppoper
     and a.aqpa806sbo = vn_ppsbop
     and a.aqpa806tpo = vn_pptope
     and a.aqpa806est ='P';  --en proceso
   exception 
      when others then
        ln_cod :=0;
        ld_fechaini:=null;
   end;
   --falta obtener la fecha de la ultima cuota
   begin
     select  aqpa807cuofpg into ln_cuofpg
     from aqpa807 
     where aqpa807cuonro in (select max(aqpa807cuonro) from aqpa807 where aqpa806cod=ln_cod)
     and aqpa806cod=ln_cod;
   exception 
      when others then
        ln_cuofpg :=null;
   end; 
   vn_plazo := ln_cuofpg - ld_fechaini;
   Begin
   select 1,JAQN8HTIP into ln_Indicador,ln_tipo
      from JAQN8H
      where JAQN8HEMP = vn_Pgcod
       and JAQN8HMOD = vn_ppmod
       and JAQN8HSUC = vn_ppsuc
       and JAQN8HMDA = vn_ppmda
       and JAQN8HPAP = vn_pppap
       and JAQN8HCTA = vn_ppcta
       and JAQN8HOPE = vn_ppoper
       and JAQN8HSBO = vn_ppsbop
       and JAQN8HTOP = vn_pptope
       and JAQN8HEST='G';
   exception 
      when others then
        ln_tipo :=0;
   end;
   vn_tipo:=ln_tipo;
end sp_plazo;
--extorno para la transacción 300/400
procedure sp_extorna2 (  vn_Pgcod in number, 
                         vn_ppmod in number, 
                         vn_ppsuc in number, 
                         vn_ppmda in number, 
                         vn_pppap in number,
                         vn_ppcta in number, 
                         vn_ppoper in number,
                         vn_ppsbop in number, 
                         vn_pptope in number,
                         vc_usuario in varchar,
                         vd_pgfape  in date)
is

begin
   
   update aqpa806 set aqpa806est='I',aqpa806fecactr=vd_pgfape,aqpa806usuactr=vc_usuario
     where aqpa806pgc = vn_Pgcod
       and aqpa806mod = vn_ppmod
       and aqpa806suc = vn_ppsuc
       and aqpa806mda = vn_ppmda
       and aqpa806pap = vn_pppap
       and aqpa806cta = vn_ppcta
       and aqpa806ope = vn_ppoper
       and aqpa806sbo = vn_ppsbop
       and aqpa806tpo = vn_pptope
       and aqpa806est = 'S';
   update JAQN8H set JAQN8HEST='A',JAQN8Hfec=vd_pgfape
      where JAQN8HEMP= vn_Pgcod
       and JAQN8HMOD = vn_ppmod
       and JAQN8HSUC = vn_ppsuc
       and JAQN8HMDA = vn_ppmda
       and JAQN8HPAP = vn_pppap
       and JAQN8HCTA = vn_ppcta
       and JAQN8HOPE = vn_ppoper
       and JAQN8HSBO = vn_ppsbop
       and JAQN8HTOP = vn_pptope
       and JAQN8HEST = 'C';
   update JAQN8I set JAQN8IEST='A',JAQN8Ifec=vd_pgfape
      where JAQN8IEMP= vn_Pgcod
       and JAQN8IMOD = vn_ppmod
       and JAQN8ISUC = vn_ppsuc
       and JAQN8IMDA = vn_ppmda
       and JAQN8IPAP = vn_pppap
       and JAQN8ICTA = vn_ppcta
       and JAQN8IOPE = vn_ppoper
       and JAQN8ISBO = vn_ppsbop
       and JAQN8ITOP = vn_pptope
       and JAQN8IEST = 'C';       
   update aqpd225 set AQPD225EST='A', AQPD225FECEXT=vd_pgfape
   where AQPD225COD= vn_Pgcod 
     and AQPD225MOD= vn_ppmod
     and AQPD225SUC= vn_ppsuc 
     and AQPD225MDA= vn_ppmda 
     and AQPD225PAP= vn_pppap 
     and AQPD225CTA= vn_ppcta 
     and AQPD225OPE= vn_ppoper 
     and AQPD225SBO= vn_ppsbop 
     and AQPD225TPO= vn_pptope 
     and AQPD225EST= 'C'; 
    commit;         
end  sp_extorna2;  
----------------------------------------------------------------------
end pq_cr_exocastigado;
/

