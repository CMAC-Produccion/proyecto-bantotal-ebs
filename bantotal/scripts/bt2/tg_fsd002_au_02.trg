CREATE OR REPLACE TRIGGER TG_FSD002_AU_02
  after update on fsd002
  for each row
  
declare  
  cursor c_cuentas(ln_pais in number,ln_tipdoc in number,ln_numdoc in char) is
  Select a.aqpa126pgc,
         a.aqpa126mod,
         a.aqpa126suc,
         a.aqpa126mda,
         a.aqpa126pap,
         a.aqpa126cta,
         a.aqpa126ope,
         a.aqpa126sbo,
         a.aqpa126tpo
    from aqpa126 a
   where a.aqpa126pai = ln_pais
     and a.aqpa126tip = ln_tipdoc
     and a.aqpa126num = ln_numdoc;
  
  pd_fecpro  fst017.pgfape%type;
  pc_hora    char(8);
  lc_usuario char(10);
  ln_codsuc  number(3):=0;
  lc_user    char(10); 
  ln_meses   number(9):=0;
begin
  if :new.pfebco = 'N' and :old.pfebco = 'S' then
    pc_hora := to_char(sysdate,'HH24:mi:ss');
    begin
       select a.pgfape into pd_fecpro from fst017 a where a.pgcod= 1;
    end;    
    lc_usuario := SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),1,10);   
    if trim(lc_usuario) is null then
      lc_usuario := 'BANTOTAL';
    End if;
    begin
      Select a.ubsuc into ln_codsuc from fst046 a where a.pgcod = 1 and a.ubuser = lc_usuario;
    exception
    when others then
      ln_codsuc := 904;  
    end; 
    --quitar el beneficio para sus CTS
    update aqpa126 a 
       set a.aqpa126est = 'R',
           a.aqpa126fec = pd_fecpro,
           a.aqpa126usr = lc_usuario,
           a.aqpa126age = ln_codsuc
     where a.aqpa126pai = :old.pfpais
       and a.aqpa126tip = :old.pftdoc
       and a.aqpa126num = :old.pfndoc;

    For i in c_cuentas(:old.pfpais,:old.pftdoc,:old.pfndoc) loop
      insert into AQPA126a(AQPA126ACOR,
                           AQPA126APGC,
                           AQPA126AMOD,
                           AQPA126ASUC,
                           AQPA126AMDA,
                           AQPA126APAP,
                           AQPA126ACTA,
                           AQPA126AOPE,
                           AQPA126ASBO,
                           AQPA126ATPO,
                           AQPA126APAI,
                           AQPA126ATIP,
                           AQPA126ANUM,
                           AQPA126AEST,
                           AQPA126AFEC,
                           AQPA126AHOR,
                           AQPA126AUSR,
                           AQPA126AAGE                                
                           )
                   values(SQ_AH_ID_ADENDAHIS.NEXTVAL,
                          i.aqpa126pgc,
                          i.aqpa126mod,
                          i.aqpa126suc,
                          i.aqpa126mda,
                          i.aqpa126pap,
                          i.aqpa126cta,
                          i.aqpa126ope,
                          i.aqpa126sbo,
                          i.aqpa126tpo,
                          :old.pfpais,
                          :old.pftdoc,
                          :old.pfndoc,
                          'R',
                          pd_fecpro,
                          pc_hora,
                          lc_usuario,
                          ln_codsuc
                          );            
    End loop;
    
    --DESISTIMOS LOS CLIENTES REFERIDOS DEL TRABAJADOR
    begin
      Select a.tp1nro1
        into ln_meses 
        from fst198 a 
       where a.tp1cod   = 1 
         and a.tp1cod1  = 10825 
         and a.tp1corr1 = 117
         and a.tp1corr2 = 3;
    exception
    when others then
      ln_meses := 0;
    end;
    
    
    --BUSCAMOS LAS SIGLAS DEL TRABAJADOR
    begin
      Select a.jaqn002usr
        into lc_user 
        from jaqn002 a 
       where a.jaqn002pgc = 1 
         and a.jaqn002pai = :old.pfpais
         and a.jaqn002tdo = :old.pftdoc
         and a.jaqn002ndo = :old.pfndoc;
    exception
    when others then
      lc_user := '';
    end;
    
    --ACTUALIZAMOS LA TABLA DE REFERIDOS DEL TRABAJADOR
    begin   
      update aqpa134 a 
         set a.aqpa134est = 'D', 
             a.aqpa134fem = pd_fecpro,
             a.aqpa134hom = to_char(sysdate,'HH24:mi:ss'),
             a.aqpa134usm = lc_usuario,
             a.aqpa134agm = ln_codsuc 
       where a.aqpa134fer between to_date('01/'||to_char(Add_months(pd_fecpro,-1*(ln_meses-1)),'mm/rrrr'),'dd/mm/rrrr') and pd_fecpro
         and a.aqpa134usr = lc_user;
    exception
    when others then
         null;
    end;                 
  End if;
exception
when others then
    null;  
end TG_FSD002_AU_01;
/

