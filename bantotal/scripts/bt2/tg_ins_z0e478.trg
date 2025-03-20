CREATE OR REPLACE TRIGGER "TG_INS_Z0E478"
  after insert on Z0E478
  for each row
   -- *****************************************************************
    -- Nombre                     : TG_INS_Z0E478
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/01/2024
    -- Autor de Creación          : Yrving Lozada
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- *****************************************************************
DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_hsucor fsd015.itsuc%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
  pc_hora char(8);
  lc_z0e463dscant z0e463.z0e463dsc%type;
  lc_z0e463dscact z0e463.z0e463dsc%type;
  
  lc_valido char(1) := 'N';
  /*
  lv_afilia varchar2(1);
  lv_coderr varchar2(400);  
  lv_msgerr varchar2(400);
  lv_tiptme varchar2(1) := null;  
  lv_mail   varchar2(65);   
  lv_numcel varchar2(20);
  ln_pais   number(3); 
  ln_tipdoc number(2);
  lc_numdoc char(12);

  cursor c_cuentas is
  Select x.z0e481nro, 
         x.z0e482suc, 
         x.z0e482cta, 
         x.z0e482sct, 
         x.z0e482mod, 
         x.z0e482mon, 
         x.z0e482pap, 
         x.z0e482top, 
         x.z0e482ope,
         case
         when x.z0e482mod = 21 then
           lpad(x.z0e482cta,9,'0')||lpad(x.z0e482mod,3,'0')||lpad(x.z0e482mon,3,'0')||lpad(x.z0e482sct,2,'0')||lpad(x.z0e482top,3,'0')
         when x.z0e482mod = 22 then
           lpad(x.z0e482cta,9,'0')||lpad(x.z0e482mod,3,'0')||lpad(x.z0e482mon,3,'0')||lpad(x.z0e482ope,9,'0')||lpad(x.z0e482top,3,'0')
         Else
           ''
         End concatenado     
    from z0e482 x 
   where x.z0e481nro = :new.z0e478nro
     and x.z0e482mod IN (21,22);
     */
BEGIN
     If  :new.z0e463cod = 1 Then
                
          pn_pgcod := 1;
          pn_hcmod := 800;
          pn_htran := 101;          
          pc_hora := to_char(sysdate,'HH24:mi:ss');
          
          begin
                   select a.pgfape into pd_fecpro from fst017 a where a.pgcod= pn_pgcod;
          end;
        -- Call the procedure
           begin
                select a.z0e463dsc into lc_z0e463dscant from z0e463 a  where z0e463cod = :old.z0e463cod;
           exception
           when others then
                lc_z0e463dscant := ' ';
           end;

           begin
                select a.z0e463dsc into lc_z0e463dscact from z0e463 a  where z0e463cod = :new.z0e463cod;
           exception
           when others then
                lc_z0e463dscact := null;
           end;
           
           begin
                select UBSUC into pn_hsucor from fst046 where ubuser= :new.z0e478uau;
           exception
           when others then
                pn_hsucor := 999;                
           end;
            pq_op_asientos_mplus.sp_op_registra_jaql977a(pn_pgcod  => pn_pgcod,
                                                         pn_hcmod  => pn_hcmod,
                                                         pn_hsucor => pn_hsucor,
                                                         pn_htran  => pn_htran,
                                                         pn_hnrel  => 0,
                                                         pd_fecpro => pd_fecpro,
                                                         pc_uing   => :new.z0e478uau,
                                                         pc_hora   => pc_hora,
                                                         pc_cont   => 'S',
                                                         pn_corr   =>  0,
                                                         pn_pais   => :new.z0e478thp,
                                                         pn_tipo   => :new.z0e478tht,
                                                         pc_numero => :new.z0e478thd,
                                                         pc_valant => lc_z0e463dscant,
                                                         pc_valact => trim(:new.Z0E478NRO)||lc_z0e463dscact
                                                         );
     End If;

     -- registro de activaciones de tarjeta rojinegra x campaña     
     -- verificamos si es tarjeta rojinegra
     lc_valido := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_valida_tarjeta(:new.z0e478nro);
     If lc_valido = 'S' Then

          lc_valido :=  PQ_AH_CAMPANA_ROJINEGRA.fn_ah_valida_tarper(:new.z0e478thp,:new.z0e478tht,:new.z0e478thd);
          If lc_valido = 'S' Then
              begin
                -- Call the procedure
                pq_ah_campana_rojinegra.sp_ah_reg_cliente_tar(p_d_fecact => :new.z0e478fau,
                                                              p_n_codpai => :new.z0e478thp,
                                                              p_n_codtpd => :new.z0e478tht,
                                                              p_c_numdoc => :new.z0e478thd,
                                                              p_n_numopt => 1,
                                                              p_n_numoct => 0
                                                              );                                                         
              end;
          End If;
     End If;
     
     /*
     --
     --afiliamos a ichannel por activación de tarjeta
     --
     begin
       select a.pgfape into pd_fecpro from fst017 a where a.pgcod= 1;
     end; 
         
     For i in c_cuentas loop
        lv_tiptme := NULL;
        begin
          Select a.pepais,a.petdoc,a.pendoc
            into ln_pais, ln_tipdoc,lc_numdoc 
            from fsr008 a 
           where a.pgcod = 1 
             and a.ctnro = i.z0e482cta 
             and a.cttfir= 'T';
        end;
        --obtenemocs mail
        begin
          Select trim(substr(b.pextxt,1,(instr(b.pextxt,'\')-1 )))
            into lv_mail
            from (
                  Select * 
                    from fsx001 a 
                   where a.pepais = ln_pais
                     and a.petdoc = ln_tipdoc
                     and a.pendoc = lc_numdoc
                     and a.txcod = 0
                     and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(a.pextxt,1,instr(a.pextxt,'\')-1))) = 'S'
                     order by a.pexren desc
                 ) b where rownum <2;
          lv_tiptme := 'M';
        exception
        when others then
          null;
        end;
        --obtenemos celular
        begin
          Select trim(c.dotelfp)
            into lv_numcel
            from (
                  Select a.* 
                    from fsr005 a, 
                         sngc17 b
                   where a.pepais = b.sngc17pais
                     and a.petdoc = b.sngc17tdoc
                     and a.pendoc = b.sngc17ndoc
                     and a.docod  = b.sngc17dcod
                     and a.doordp = b.sngc17corr
                     and b.sngc16ttel In (1,3,4,5,6)
                     and a.pepais = ln_pais
                     and a.petdoc = ln_tipdoc
                     and a.pendoc = lc_numdoc
                     and length(trim(a.dotelfp)) = 9
                     and substr(trim(a.dotelfp),1,1) = '9'
                     and trim(a.dotelfp) not in ('999999999','000000000','987654321')
                     and case
                         when REGEXP_LIKE(trim(dotelfp), '[^0-9]') then
                          'N'
                         else
                          'S'
                         end = 'S'
                     order by b.sngc17dcod desc,b.sngc17corr desc
                 ) c where rownum <2;
                 
          if lv_tiptme  is null then
             lv_tiptme := 'S';
          Else
             lv_tiptme := 'A';
          End If;
        exception
        When others then          
          null;
        end;      
        if lv_tiptme is not null then
          begin
            Select 'N'
              into lv_afilia
              from jaqy660 a 
             where a.jaqy660pgo = 1
               and a.jaqy660suc = i.z0e482suc   
               and a.jaqy660mod = i.z0e482mod   
               and a.jaqy660mda = i.z0e482mon   
               and a.jaqy660cta = i.z0e482cta   
               and a.jaqy660pap = i.z0e482pap   
               and a.jaqy660ope = i.z0e482ope   
               and a.jaqy660sub = i.z0e482sct   
               and a.jaqy660top = i.z0e482top
               and a.jaqy660tip = 'T'; 
          exception
          when no_data_found then
            lv_afilia := 'S';
          end;
          if lv_afilia = 'S'  then
              SP_AH_AFILIA_ICHANNEL(p_c_jaqy660tip => 'T',
                                    p_n_jaqy660pgo => 1,   
                                    p_n_jaqy660suc => i.z0e482suc,   
                                    p_n_jaqy660mod => i.z0e482mod,   
                                    p_n_jaqy660mda => i.z0e482mon,   
                                    p_n_jaqy660cta => i.z0e482cta,   
                                    p_n_jaqy660pap => i.z0e482pap,   
                                    p_n_jaqy660ope => i.z0e482ope,   
                                    p_n_jaqy660sub => i.z0e482sct,   
                                    p_n_jaqy660top => i.z0e482top,
                                    p_d_jaqy660fch => pd_fecpro,
                                    p_c_jaqy660usu => :new.z0e478uau,
                                    p_c_jaqy660tpr => case
                                                      when i.z0e482mod = 21 then
                                                        'A'
                                                     When i.z0e482mod = 22 then
                                                        'D'
                                                      Else
                                                        'X' 
                                                      end,
                                    p_c_jaqy660tme  => lv_tiptme,
                                    p_c_jaqy660afi  => lv_mail,
                                    p_c_jaqy660fde  => null,
                                    p_c_jaqy660ude  => null,
                                    p_c_jaqy660aux1 => lv_numcel,
                                    p_c_jaqy660aux2 => i.concatenado,
                                    p_c_hora        => to_char(sysdate,'HH24:mi:ss'),
                                    p_c_code        => lv_coderr,
                                    p_c_error       => lv_msgerr
                                    );  
          End if;                                
        End if;                                                                
     End loop;
     */
Exception
When others then
    null;
END TG_INS_Z0E478;


--select * from JAQL977A for update
/

