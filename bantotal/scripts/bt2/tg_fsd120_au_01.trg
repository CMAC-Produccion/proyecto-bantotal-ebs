CREATE OR REPLACE TRIGGER TG_FSD120_AU_01
  after update
  on FSD120 
  for each row
declare
  cursor c_agencias is
  Select * from fst001 x where x.pgcod = 1 and x.sucurs < 300;
  
  cursor c_plataformas(ln_sucurs in number) is
  --Obtenemos el correo del jefe de plataforma de la agencia correspondiente    
 Select b.sng057usr, b.sng057sup
   from fst046 a, sng057 b
  where a.pgcod = b.sng055emp
    and a.ubuser = b.sng057usr
    and a.ubsuc = ln_sucurs
    and b.sng055car = 50 --JEFE DE PLATAFORMA                   
    and decode(b.sng057fin, null, '01/01/0001', b.sng057fin) =
        (Select decode(max(b.sng057fin),
                       null,
                       '01/01/0001',
                       max(b.sng057fin))
           from fst046 a, sng057 b
          where a.pgcod = b.sng055emp
            and a.ubuser = b.sng057usr
            and a.ubsuc = ln_sucurs
            and b.sng055car = 50);
           
  ln_sucurs number(3):=0;   
  ln_correl number(6):=0;               
begin      
  if :old.tccod in (500) and :new.tccpa>0 and :new.tcvta >0 then
    for i in c_agencias loop
      ln_sucurs := i.sucurs;
      for j in c_plataformas(ln_sucurs) loop    
        if trim(j.sng057usr) is not null or trim(j.sng057sup) is not null then   
          begin
            Select a.frseqcnt
              into ln_correl
              from FRSEQS a
             where a.frseqid = 'Alerts'
            for update of a.frseqcnt;   
          exception 
          when others then
             ln_correl := 0;
          end;  
           
          if ln_correl = 999999 then
            ln_correl := 1;
          End if;          
           
          if trim(j.sng057usr) is not null then
            ln_correl := ln_correl + 1;
            begin
              insert into fralerts(FRAleId,
                                   FRAleCall,
                                   FRAleText,
                                   FRAleUser,
                                   FRAleType,
                                   FRAleDate
                                  )
                            values(ln_correl,
                                   null,
                                   'HA VARIADO EL TIPO DE CAMBIO: '||'TCC.'||:new.tccpa||', TCV.'||:new.tcvta,
                                   trim(j.sng057usr),
                                   'I',
                                   trunc(sysdate)
                                  );                                                                            
            exception 
            when others then
               ln_correl := 0;
            end; 
          end if;
          
          if trim(j.sng057sup) is not null then
            ln_correl := ln_correl + 1;
            begin
              insert into fralerts(FRAleId,
                                   FRAleCall,
                                   FRAleText,
                                   FRAleUser,
                                   FRAleType,
                                   FRAleDate
                                  )
                            values(ln_correl,
                                   null,
                                   'HA VARIADO EL TIPO DE CAMBIO: '||'TCC.'||:new.tccpa||', TCV.'||:new.tcvta,
                                   trim(j.sng057sup),
                                   'I',
                                   trunc(sysdate)
                                  );                                                                            
            exception 
            when others then
               ln_correl := 0;
            end;  
          end if;       
          
          if ln_correl <> 0 then
            update FRSEQS a
              set a.frseqcnt = ln_correl 
             where a.frseqid = 'Alerts';
             --commit;
          End If;  
        end If;
      End loop; 
    End loop;  
  end If;
Exception
when others then
  null;
end TG_FSD120_AU_01;
/

