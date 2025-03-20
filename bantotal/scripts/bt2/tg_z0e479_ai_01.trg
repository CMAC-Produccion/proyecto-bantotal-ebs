CREATE OR REPLACE TRIGGER TG_Z0E479_AI_01
  after insert on Z0E479
  for each row
   -- *****************************************************************
    -- Nombre                     : TG_Z0E479_AI_01
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/01/2024
    -- Autor de Creación          : yrving Lozada
    -- Uso                        : Controles varios
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    --
    -- *****************************************************************
DECLARE
  lv_afilia varchar2(1);  
  lv_coderr varchar2(400);  
  lv_msgerr varchar2(400);
  lv_tiptme varchar2(1) := null;  
  lv_mail   varchar2(65);   
  lv_numcel varchar2(20);
  ln_pais   number(3); 
  ln_tipdoc number(2);
  lc_numdoc char(12);
  pd_fecpro DATE;
  lv_concatenado varchar2(27);

BEGIN    
     --
     --afiliamos a ichannel por activación de tarjeta
     --
     begin
       select a.pgfape into pd_fecpro from fst017 a where a.pgcod= 1;
     end; 
         
     lv_tiptme := NULL;
        begin
          Select a.pepais,a.petdoc,a.pendoc
            into ln_pais, ln_tipdoc,lc_numdoc 
            from fsr008 a 
           where a.pgcod = 1 
             and a.ctnro = :NEW.Z0E479CTA  
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
               and a.jaqy660suc = :NEW.Z0E479SUC  
               and a.jaqy660mod = :NEW.Z0E479MOD  
               and a.jaqy660mda = :NEW.Z0E479MON  
               and a.jaqy660cta = :NEW.Z0E479CTA  
               and a.jaqy660pap = :NEW.Z0E479PAP  
               and a.jaqy660ope = :NEW.Z0E479OPE  
               and a.jaqy660sub = :NEW.Z0E479SCT  
               and a.jaqy660top = :NEW.Z0E479TOP
               and a.jaqy660tip = 'T'; 
          exception
          when no_data_found then
            lv_afilia := 'S';
          end;
                   
         If :NEW.Z0E479MOD = 21 then
           lv_concatenado := lpad(:NEW.Z0E479CTA,9,'0')||lpad(:NEW.Z0E479MOD,3,'0')||lpad(:NEW.Z0E479MON,3,'0')||lpad(:NEW.Z0E479SCT,2,'0')||lpad(:NEW.Z0E479TOP,3,'0');
         End If;
         If :NEW.Z0E479MOD = 22 then
           lv_concatenado := lpad(:NEW.Z0E479CTA,9,'0')||lpad(:NEW.Z0E479MOD,3,'0')||lpad(:NEW.Z0E479MON,3,'0')||lpad(:NEW.Z0E479OPE,9,'0')||lpad(:NEW.Z0E479TOP,3,'0');
         End If;     
                   
          if lv_afilia = 'S'  then
              SP_AH_AFILIA_ICHANNEL(p_c_jaqy660tip => 'T',
                                    p_n_jaqy660pgo => 1,   
                                    p_n_jaqy660suc => :NEW.Z0E479SUC,   
                                    p_n_jaqy660mod => :NEW.Z0E479MOD,   
                                    p_n_jaqy660mda => :NEW.Z0E479MON,   
                                    p_n_jaqy660cta => :NEW.Z0E479CTA,   
                                    p_n_jaqy660pap => :NEW.Z0E479PAP,   
                                    p_n_jaqy660ope => :NEW.Z0E479OPE,   
                                    p_n_jaqy660sub => :NEW.Z0E479SCT,   
                                    p_n_jaqy660top => :NEW.Z0E479TOP,
                                    p_d_jaqy660fch => pd_fecpro,
                                    p_c_jaqy660usu => :new.z0e479uau,
                                    p_c_jaqy660tpr => case
                                                      when :NEW.Z0E479MOD = 21 then
                                                        'A'
                                                      When :NEW.Z0E479MOD = 22 then
                                                        'D'
                                                      Else
                                                        'X' 
                                                      end,
                                    p_c_jaqy660tme  => lv_tiptme,
                                    p_c_jaqy660afi  => lv_mail,
                                    p_c_jaqy660fde  => null,
                                    p_c_jaqy660ude  => null,
                                    p_c_jaqy660aux1 => lv_numcel,
                                    p_c_jaqy660aux2 => lv_concatenado,
                                    p_c_hora        => to_char(sysdate,'HH24:mi:ss'),
                                    p_c_code        => lv_coderr,
                                    p_c_error       => lv_msgerr
                                    );  
          End if;                                
        End if;                                                                
Exception
When others then
    null;
END TG_Z0E479_AI_01;
/

