create or replace procedure sp_genera_cartas_cts(P_C_USUARIO IN VARCHAR2,
                                                 P_D_FECINI IN DATE,              
                                                 P_D_FECFIN IN DATE,
                                                 P_N_NUMAGE IN NUMBER,
                                                 P_N_CTAEMP IN NUMBER,
                                                 P_C_TIPDIR  IN VARCHAR2
                                                 ) is        
   -- *****************************************************************
    -- Nombre                     : sp_genera_cartas_cts
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/01/2022
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Genera Cartas CTS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 15/10/2024
    -- Autor de la Modificación   : Yrving Lozada  
    -- Modificación               : Se adicionó registro de cuenta cliente del empleado y del empleador
    -- *****************************************************************                                                                                                  
cursor c_depo1(ln_sucur in number, ln_cuenta in number) is
select /*+all_rows index(a FSH01612)*/
       distinct
       c.r1cta, --ylozada 2022.04.04
       c.R2mod,
       c.R2mda,
       c.R2pap,
       c.R2cta,
       c.R2tope,
       c.R2suc,
       c.R2oper, 
       c.r2sbop,
       a.hfval /*max(a.hfval)*/fecdepo,
       a.hfcon                 fecreal
  from fsh016 a,
       fst098 b,
       fsr011 c
 where a.PgCod = b.PgCod
   and b.PgCod = 1--21.11.2014
   and a.Hcmod = trunc(b.Tpnro/1000)
   and a.Htran = b.Tpnro - (trunc(b.Tpnro/1000)*1000)   
   and a.hcord = b.tpimp --se adicionó 30/07/2018
   and a.Hcodmo = 2   
   and a.Hcta    = c.R2cta
   and a.Hmodul  = c.R2mod
   and a.Htoper  = c.R2tope
   and a.Hsucur  = c.R2suc
   and a.Hmda    = c.R2mda
   and a.Hpap    = c.R2pap
   and a.Hoper   = c.R2oper 
   and a.Hsubop  = c.R2sbop
   and c.relcod = 45
   and c.R2tope = 2
   and a.hfvco >= P_D_FECINI
   and a.hfvco <= P_D_FECFIN   
   and b.Tpcod = 2165
   and c.R2mod = 21
   and c.R2suc = decode(ln_sucur,0,c.R2suc,ln_sucur) 
   and c.r1cta = decode(ln_cuenta,0,c.r1cta,ln_cuenta)
   and c.r011co = 'S';
/*group by c.r1cta,
         c.R2mod,
         c.R2mda,
         c.R2pap,
         c.R2cta,
         c.R2tope,
         c.R2suc,
         c.R2oper, 
         c.R2sbop;*/
                                               

  ln_tasa        number(10,6);  
  lc_nomemp      char(70);
  ln_paisE       number(5);
  ln_tipoE       number(5);
  lc_numdocE     char(12);
  lc_nomclt      char(170);
  ln_paisC       number(5);
  ln_tipoC       number(5);
  lc_numdocC     char(12);
  lc_desdirE     char(140);
  ln_dptoE       number(8);
  ln_provE       number(8); 
  ln_distE       number(8);
  lc_desdirC     char(140);
  ln_dptoC       number(8);
  ln_provC       number(8); 
  ln_distC       number(8);
  lc_distriE     char(30);
  lc_distriC     char(30);
  lc_departE     char(30);
  lc_departC     char(30);
  lc_cuenta      char(20);
  lc_Siglas      char(4);
  lc_Siglad      char(4);
  ln_saldo       number(18,2) :=0;
  ln_cont        number := 0;
  lc_provC       char(30);
  lc_provE       char(30);
  lc_telemp      char(20);
  lc_telcli      char(20);
  lc_envio       char(1);
  lv_telefono    varchar2(20);
begin

  delete from jaql456 where jaql456usu = rpad(P_C_USUARIO,10,' ');
  COMMIT;
  
  begin
    select upper(mosign) into lc_Siglas from fst005 where moneda = 0;
    select upper(mosign) into lc_Siglad from fst005 where moneda = 101;
  end;
  
    
     begin
       for i in c_depo1(P_N_NUMAGE,P_N_CTAEMP)loop
         
         --verificamos que ya no se haya enviado         
          begin
            select 'S' 
              into lc_envio
              from jaqz178 d
             Where d.jaqz178pgc = 1
               and d.jaqz178mod = i.r2mod
               and d.jaqz178suc = i.r2suc
               and d.jaqz178mda = i.r2mda
               and d.jaqz178pap = i.r2pap
               and d.jaqz178cta = i.r2cta
               and d.jaqz178ope = i.r2oper
               and d.jaqz178sbo = i.r2sbop
               and d.jaqz178tpo = i.r2tope
               and d.jaqz178est = 'S'
               and d.jaqz178fec between P_D_FECINI and P_D_FECFIN
               and rownum < 2;   
               
               update jaqz178 a 
                  set a.jaqz178ax1 = 1
                where a.jaqz178pgc = 1
                  and a.jaqz178mod = i.r2mod
                  and a.jaqz178suc = i.r2suc
                  and a.jaqz178mda = i.r2mda
                  and a.jaqz178pap = i.r2pap
                  and a.jaqz178cta = i.r2cta
                  and a.jaqz178ope = i.r2oper
                  and a.jaqz178sbo = i.r2sbop
                  and a.jaqz178tpo = i.r2tope
                  and a.jaqz178est = 'S'
                  and a.jaqz178fec between P_D_FECINI and P_D_FECFIN;
          Exception
          when Others then
            lc_envio := 'N';
          end; 
          --verificar que si ya se envío por SMS no lo meta a la tabla
          if lc_envio = 'N' then
            begin
              Select b.dotelfp
                into lv_telefono
                from fsr008 a,
                     fsr005 b
               where a.pepais = b.pepais
                 and a.petdoc = b.petdoc
                 and a.pendoc = b.pendoc
                 and b.docod  = 2
                 and b.doordp = 99
                 and a.pgcod  = 1
                 and a.ctnro  = i.r2cta
                 and a.ttcod  = 1
                 and a.cttfir = 'T'                 
                 and length(trim(b.dotelfp)) = 9
                 and case
                     when REGEXP_LIKE(trim(b.dotelfp), '[^0-9]') then
                      'N'
                     else
                      'S'
                     end = 'S'                 
                 and rownum < 2;
            Exception
            when Others then
              lv_telefono := null;
            end; 
            if lv_telefono is not null then            
              begin
                Select 'S' 
                  into lc_envio
                  from /*mensajes@ichannel*/ichannelalert.mensajes a
                 where a.tipo_envio = 'SMS' 
                   and a.estado     = 'T' 
                   and a.canal      = 24                    --código de alerta para abono de CTS
                   and a.destino    = trim(lv_telefono)
                   and trunc(a.fecha_hora_insercion) between P_D_FECINI and P_D_FECFIN
                   and rownum < 2;
              Exception
              when Others then
                lc_envio := 'N';
              end; 
            else
             lc_envio := 'N';   
            end if;
          end if;   
                
          if lc_envio = 'N' then                        
               ln_tasa    := 0;    
               lc_nomemp  := ''; 
               ln_paisE   := 0; 
               ln_tipoE   := 0; 
               lc_numdocE := ''; 
               lc_nomclt  := '';
               ln_paisC   := 0;  
               ln_tipoC   := 0; 
               lc_numdocC := '';
               lc_desdirE := '';
               ln_dptoE   := 0;
               ln_provE   := 0;
               ln_distE   := 0;
               lc_desdirC := '';
               ln_dptoC   := 0;
               ln_provC   := 0;
               ln_distC   := 0;
               lc_distriE := '';
               lc_distriC := '';
               lc_departE := '';
               lc_departC := '';
               lc_cuenta  := '';
               ln_saldo   := 0;     
               lc_telemp  := '';
               lc_telcli  := '';           
                      
                begin
                
                  pq_segmentacion_clientes_pas.sp_tasa(vpgcod  => 1,
                                                       vscsuc  => i.R2suc,
                                                       vsccta  => i.R2cta,
                                                       vscmda  => i.R2mda,
                                                       vscpap  => i.R2pap,
                                                       vscoper => i.R2oper,
                                                       vscsbop => i.R2sbop,
                                                       vsctope => i.R2tope,
                                                       vscmod  => i.R2mod,
                                                       tasa    => ln_tasa);
                exception
                  when others then
                    null;
                end;       
           
               lc_cuenta := lpad(i.R2cta,9,'0')||lpad(i.R2mod,3,'0')||lpad(i.R2mda,3,'0')||lpad(i.R2sbop,2,'0')||lpad(i.R2tope,3,'0');
               
               begin
                 select y.pepais,
                        y.petdoc,
                        y.pendoc 
                   into ln_paisE,
                        ln_tipoE,
                        lc_numdocE
                   from fsr008 y
                  where y.ttcod  = 1
                    and y.cttfir = 'T'
                    and y.ctnro  = i.r1cta;
               exception
                 when others then
                   null;
               end;
               
              begin
                select trim(PJRAZS)
                  into lc_nomemp
                  from fsd003
                 where pjpais = ln_paisE
                   and pjtdoc = ln_tipoE
                   and pjndoc = lc_numdocE;
              exception
                when no_data_found then            
                    begin
                      select trim(PFAPE1) || ' ' || trim(PFAPE2) || ', ' || trim(pfnom1) || ' ' ||trim(pfnom2)
                        into lc_nomemp
                        from fsd002
                       where pfpais = ln_paisE
                         and pftdoc = ln_tipoE
                         and pfndoc = lc_numdocE;
                    exception
                      when others then
                        null;
                    end;            
                when others then
                  null;
              end;
               
               begin
                 select y.pepais,
                        y.petdoc,
                        y.pendoc 
                   into ln_paisC,
                        ln_tipoC,
                        lc_numdocC
                   from fsr008 y
                  where y.ttcod  = 1
                    and y.cttfir = 'T'
                    and y.ctnro  = i.r2cta;
               exception
                 when others then
                   null;
               end;
               
              begin
                select trim(PFAPE1) || ' ' || trim(PFAPE2) || ', ' || trim(pfnom1) || ' ' ||trim(pfnom2)
                  into lc_nomclt
                  from fsd002
                 where pfpais = ln_paisC
                   and pftdoc = ln_tipoC
                   and pfndoc = lc_numdocC;
              exception
                when others then
                  null;
              end;           
               
               IF P_C_TIPDIR = 'E' THEN
                     begin
                       -- direccion 
                       select Trim(Sngc13Dir), Sngc13Dpto, Sngc13Prov, Sngc13Dist
                         into lc_desdirE, ln_dptoE, ln_provE, ln_distE
                         from sngc13
                        where docod = 1
                          and sngc13pais = ln_paisE
                          and sngc13tdoc = ln_tipoE
                          and sngc13ndoc = lc_numdocE
                          and sngc13est  = 'H';
                     exception                                    
                     when others then
                         null;
                     end;
                     
                      begin
                        select DepNom
                          into lc_departE
                          from FST068 --DEPARTAMENTO
                         Where Pais = ln_paisE
                           and DepCod = ln_dptoE;
                      exception
                        when others then
                          null;
                      end;
                                     
                     begin
                     
                       select LocNom
                         into lc_provE
                         from FST070 --PROVINCIA
                        Where Pais = ln_paisE
                          and DepCod = ln_dptoE
                          and LocCod = ln_provE;
                     exception
                       when others then
                         null;
                     end;
                     begin
                       select fst071dsc
                         into lc_distriE
                         from FST071 --DISTRITO
                        Where Fst071Pai = ln_paisE
                          and Fst071Col = ln_distE;
                     exception
                       when others then
                         null;
                     end;  
               END IF;
               
              IF P_C_TIPDIR = 'C' THEN
                     begin
                       -- direccion 
                       select Trim(Sngc13Dir), Sngc13Dpto, Sngc13Prov, Sngc13Dist
                         into lc_desdirC, ln_dptoC, ln_provC, ln_distC
                         from sngc13
                        where docod = 2
                          and sngc13pais = ln_paisC
                          and sngc13tdoc = ln_tipoC
                          and sngc13ndoc = lc_numdocC
                          and sngc13est  = 'H';
                     exception
                     when no_data_found then
                       begin
                         -- direccion 
                         select Trim(Sngc13Dir), Sngc13Dpto, Sngc13Prov, Sngc13Dist
                           into lc_desdirC, ln_dptoC, ln_provC, ln_distC
                           from sngc13
                          where docod = 1
                            and sngc13pais = ln_paisC
                            and sngc13tdoc = ln_tipoC
                            and sngc13ndoc = lc_numdocC
                            and sngc13est  = 'H';
                       exception
                         when others then
                           null;
                       end;                         
                     when others then
                         null;
                     end;
                     
                     begin
                       select DepNom
                         into lc_departC
                         from FST068 --DEPARTAMENTO
                        Where Pais = ln_paisC
                          and DepCod = ln_dptoC;
                     exception
                       when others then
                         null;
                     end;
                     
                     begin
                     
                       select LocNom
                         into lc_provC
                         from FST070 --PROVINCIA
                        Where Pais = ln_paisC
                          and DepCod = ln_dptoC
                          and LocCod = ln_provC;
                     exception
                       when others then
                         null;
                     end;
                     begin
                       select fst071dsc
                         into lc_distriC
                         from FST071 --DISTRITO
                        Where Fst071Pai = ln_paisC
                          and Fst071Col = ln_distC;
                     exception
                       when others then
                         null;
                     end;  
               END IF;
               --SACAMOS EL SALDO DE LA CUENTA
               begin
                 select scsdo
                   into ln_saldo
                   from fsd011
                  where pgcod = 1
                    and scmod = i.R2mod
                    and scsuc = i.R2suc
                    and scmda = i.R2mda
                    and sccta = i.R2cta
                    and scpap = i.R2pap
                    and scoper = i.R2oper
                    and scsbop = i.R2sbop
                    and sctope = i.R2tope;
               exception
                 when others then
                   ln_saldo := 0;
               end;            
               
               --SACAMOS TELEFONO DEL EMPLEADOR             
               begin
                 select dotelfp
                   into lc_telemp
                   from fsr005
                  Where Pepais = ln_paisE
                    and Petdoc = ln_tipoE
                    and Pendoc = lc_numdocE
                    and Docod = 1
                    and rownum = 1;           
               exception
               when others then 
                    lc_telemp := '';
               end;
               
               --SACAMOS TELEFONO DEL EMPLEADO
               begin
                 select dotelfp
                   into lc_telcli
                   from fsr005
                  Where Pepais = ln_paisC
                    and Petdoc = ln_tipoC
                    and Pendoc = lc_numdocC
                    and Docod = 1
                    and rownum = 1;           
               exception
               when others then 
                    lc_telcli := '';
               end;                               
               
               -- REGISTRAMOS LA INFORMACIÓN
               BEGIN
               ln_cont := ln_cont + 1;
               
               insert into JAQL456(JAQL456COR, 
                                   JAQL456USU, 
                                   JAQL456NEM, 
                                   JAQL456DIE, 
                                   JAQL456CTA, 
                                   JAQL456FDE, 
                                   JAQL456SMN, 
                                   JAQL456SDO, 
                                   JAQL456DIC, 
                                   JAQL456DDE, 
                                   JAQL456DEE, 
                                   JAQL456DDC, 
                                   JAQL456DEC, 
                                   JAQL456TAS,
                                   JAQL456NEC,
                                   JAQL456PRE,
                                   JAQL456PRC,
                                   JAQL456TEE,
                                   JAQL456TEC,
                                   JAQL456AX5,
                                   JAQL456AX1,
                                   JAQL456AX2,
                                   JAQL456AX3                                                              
                                   )
                            values(ln_cont,
                                   P_C_USUARIO,
                                   lc_nomemp,
                                   lc_desdirE,
                                   lc_cuenta,
                                   i.fecdepo,
                                   decode(i.r2mda,0,lc_Siglas,lc_Siglad),
                                   ln_saldo,
                                   lc_desdirC,
                                   lc_distriE,
                                   lc_departE,
                                   lc_distriC,
                                   lc_departC,
                                   ln_tasa,
                                   lc_nomclt,
                                   lc_provE,
                                   lc_provC,
                                   lc_telemp,
                                   lc_telcli,
                                   i.fecreal,
                                   i.r2cta,
                                   i.r1cta,
                                   i.r2mda                                                                                 
                                   );
                            commit;
               
               EXCEPTION
               WHEN OTHERS THEN
               NULL;
               END;  
          End If;                            
       end loop;           
                
     exception
     when others then
          null;
     end;   
end sp_genera_cartas_cts;
/

