CREATE OR REPLACE TRIGGER TG_FSR005_AU_01
  after update on FSR005
  for each row
  
DECLARE
  lv_flag varchar2(1):='N';
  lv_beco varchar2(1):='N';
  lc_usuario char(10);
  lv_nombre  char(60);
BEGIN
  if :new.pepais > 0 then 
      begin
        Select 'S'
          into lv_flag
          from sngc17 a
         where a.sngc17pais = :old.pepais
           and a.sngc17ndoc = :old.pendoc
           and a.sngc17tdoc = :old.petdoc
           and a.sngc17dcod = :old.docod
           and a.sngc17corr = :old.doordp
           and a.sngc16ttel = 6;  --coorporativo
      Exception
      When others then
           lv_flag := 'N';
      end;
      
      if lv_flag = 'S' then
        --verificamos si es trabajador
          begin
            Select 'S',
                   substr(trim(a.pfape1)||' '||trim(a.pfape2)||', '||trim(a.pfnom1)||' '||trim(a.pfnom2),1,60)
              into lv_beco,
                   lv_nombre
              from fsd002 a
             where a.pfpais  = :old.pepais
               and a.pfndoc  = :old.pendoc
               and a.pftdoc  = :old.petdoc
               and a.pfebco  = 'S';               
          Exception
          When others then
               lv_beco := 'N';
          end;  
          if lv_beco = 'S' then
            --obtenemos las siglas
              begin
                Select a.jaqn002usr
                  into lc_usuario
                  from jaqn002 a
                 where a.jaqn002pgc = 1            
                   and a.jaqn002pai = :old.pepais
                   and a.jaqn002tdo = :old.petdoc
                   and a.jaqn002ndo = :old.pendoc;
              Exception
              When others then
                   lc_usuario := '';
              end; 
              if trim(lc_usuario) is not null then
                  begin
                    insert into jaql708 (jaql708usr, 
                                         jaql708doi, 
                                         jaql708nom, 
                                         jaql708tlf, 
                                         jaql708mail,
                                         jaql708cod
                                         )                                         
                                  values(lc_usuario,
                                         :old.pendoc,
                                         lv_nombre,
                                         to_number(trim(:new.dotelfp)),   
                                         trim(lc_usuario)||'@CAJAAREQUIPA.PE',
                                         0
                                         ); 
                  Exception
                  When dup_val_on_index then
                    update jaql708 x 
                       set x.jaql708tlf = to_number(trim(:new.dotelfp)) 
                     where x.jaql708usr = lc_usuario;  
                  When others then
                       null;
                  end;                 
              End If;               
          End If;            
      End If;   
  end if;                                             
Exception
When others then
    null;
END TG_FSR005_AU_01;
/

