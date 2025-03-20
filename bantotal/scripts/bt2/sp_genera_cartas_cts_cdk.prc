create or replace procedure sp_genera_cartas_cts_cdk(P_C_USUARIO IN VARCHAR2,
                                                     P_C_TIPDIR  IN VARCHAR2
                                                     ) is        
   -- *****************************************************************
    -- Nombre                     : sp_genera_cartas_cts_cdk
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/12/2024
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Genera Cartas CTS migracion saldos ex CREDINKA 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- *****************************************************************                                                                                                  
cursor c_depo1 is
    select a.aqpa149pacl,
           a.aqpa149tpcl,
           a.aqpa149docl,
           a.aqpa149paem,
           a.aqpa149tpem,
           a.aqpa149doem,
           c.r1cta,
           c.r2cod, 
           c.r2mod,
           c.r2suc, 
           c.r2mda, 
           c.r2pap, 
           c.r2cta, 
           c.r2oper,
           c.r2sbop,
           c.r2tope,
           a.aqpa149sald migrado,
           e.scsdo total,
           to_date('01/12/2024','dd/mm/rrrr') fecdepo,
           to_date('01/12/2024','dd/mm/rrrr') fecreal
      from AQPA149 A,       
           FSR008  B,
           FSR011  C,
           FSR008  D,
           FSD011  E           
     where a.aqpa149pacl = b.pepais
       and a.aqpa149tpcl = b.petdoc
       and a.aqpa149docl = b.pendoc
       and b.ctnro = c.r2cta
       and b.pgcod = c.r2cod 
       and a.aqpa149paem = d.pepais
       and a.aqpa149tpem = d.petdoc
       and a.aqpa149doem = d.pendoc 
       and d.ctnro = c.r1cta
       and d.pgcod = c.r1cod   
       and c.r2mod = e.scmod 
       and c.r2cta = e.sccta  
       and c.r2oper= e.scoper 
       and c.r2sbop= e.scsbop 
       and c.r2cod = e.pgcod   
       and c.r2suc = e.scsuc 
       and c.r2mda = e.scmda 
       and c.r2pap = e.scpap 
       and c.r2tope= e.sctope 
       and c.r2tope = 2
       and c.relcod = 45
       and b.pgcod = 1
       and b.ttcod = 1
       and b.cttfir = 'T'
       and d.pgcod = 1
       and d.ttcod = 1
       and d.cttfir = 'T'
       and a.aqpa149mone = c.r2mda
       and c.r011co = 'S'
       and a.AQPA149sald >0
       and e.scstat <> 99;                                               

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
  lc_envio       char(1):='N';
begin

  delete from jaql456 where jaql456usu = rpad(P_C_USUARIO,10,' ');
  COMMIT;
  
  begin
    select upper(mosign) into lc_Siglas from fst005 where moneda = 0;
    select upper(mosign) into lc_Siglad from fst005 where moneda = 101;
  end;
  
    
     begin
       for i in c_depo1 loop                         
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
               ln_paisE := i.aqpa149paem;
               ln_tipoE := i.aqpa149tpem;
               lc_numdocE := i.aqpa149doem;
               
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
               ln_paisC:= i.aqpa149pacl;
               ln_tipoC:= i.aqpa149tpcl;              
               lc_numdocC:= i.aqpa149docl;
               
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
               ln_saldo := i.total;           
               
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
                                   JAQL456AX3, 
                                   JAQL456AX4                                                             
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
                                   i.r2mda,
                                   i.migrado                                                                                 
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
end sp_genera_cartas_cts_cdk;
/

