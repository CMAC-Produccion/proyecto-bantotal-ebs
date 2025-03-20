CREATE OR REPLACE TRIGGER TG_SNGC17_AI_02
  after insert on SNGC17
  for each row
  
DECLARE
  lv_flag varchar2(1):='N';
  lv_beco varchar2(1):='N';
  lc_usuario char(10);
  lv_nombre  char(60);
  lc_movil   char(20);
BEGIN
  if :new.sngc17pais > 0 and :new.sngc16ttel = 6 then   --coorporativo
      begin
        Select a.dotelfp
          into lc_movil
          from fsr005 a
         where a.pepais = :new.sngc17pais 
           and a.petdoc = :new.sngc17tdoc
           and a.pendoc = :new.sngc17ndoc
           and a.docod  = :new.sngc17dcod
           and a.doordp = :new.sngc17corr;
           lv_flag := 'S';
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
             where a.pfpais  = :new.sngc17pais
               and a.pfndoc  = :new.sngc17ndoc
               and a.pftdoc  = :new.sngc17tdoc
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
                   and a.jaqn002pai = :new.sngc17pais
                   and a.jaqn002tdo = :new.sngc17tdoc
                   and a.jaqn002ndo = :new.sngc17ndoc;                                   
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
                                         :new.sngc17ndoc,
                                         lv_nombre,
                                         to_number(trim(lc_movil)),   
                                         trim(lc_usuario)||'@CAJAAREQUIPA.PE',
                                         0
                                         ); 
                  Exception
                  When dup_val_on_index then
                    update jaql708 x 
                       set x.jaql708tlf = to_number(trim(lc_movil)) 
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
END TG_SNGC17_AI_02;
/

