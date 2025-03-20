CREATE OR REPLACE TRIGGER TG_FSD002_AU_01
  after update on fsd002
  for each row
declare
  -- local variables here
   cursor Cuentas(pais number,tdoc number,ndoc in char)is
   select ctnro
     from Fsr008
    Where PgCod = 1
      and Pepais = pais
      and Petdoc = tdoc
      and Pendoc = ndoc
      and Ttcod = 1;

   cursor productos (ctnro number)is
   select Scmod,Scsuc, Scmda, Scpap, Sccta, Scoper, Scsbop, Sctope, Scstat
     from fsd011
    where PgCod = 1
      and Sccta = Ctnro
      and Scmod in (21,22)
      and Scstat in (select tpnro from fst098 where tpcod= 7671);  ---- in (99,55);

   cursor lineas (ctnro number)is
   select *
     from fsd010 --PGCOD, AOCTA, AOMOD
    where pgcod = 1
      and aomod = 117
      and aocta = ctnro
      and aostat <> 99 ;

  pepais   number;
  petdoc   number;
  pendoc   char(12);
  facCta   varchar2(12);
  fecha    date;
  relacion number;
  desEst   char(30);
  EstBloq  number:=55;
  dato     number;
  lv_mensaje VARCHAR2(1000);
begin
   ---pfeciv
  pepais   := :old.pfpais;
  petdoc   := :old.pftdoc;
  pendoc   := :old.pfndoc;

  Begin
    select pgfape into fecha from fst017 where pgcod = 1;
  exception
    when no_data_found then
    fecha:= trunc(sysdate);
  end;
  
  
  if :new.pfffal <> to_date('01/01/0001','dd/mm/yyyy') and :new.pfffal is not null  then
    
        for cta in Cuentas(pepais, petdoc, pendoc) loop
          For pro in productos(cta.ctnro) loop -- Pasivas
             facCta := fn_facultad_cta(vpgcod => 1,
                                       vscsuc => pro.scsuc,
                                       vscmda => pro.scmda,
                                       vscpap => pro.scpap,
                                       vsccta => pro.sccta,
                                       vscoper => pro.scoper,
                                       vscsbop => pro.scsbop,
                                       vsctope => pro.sctope,
                                       vscmod => pro.scmod );
 
             if faccta ='INDIVIDUAL'OR faccta ='MANCOMUNADA' THEN
               select Max(Cbierel) + 1
                 into relacion
                 from FSD450
                Where Cbieemp = 1
                  and Cbiemod = pro.scmod
                  and Cbiesuc = pro.scsuc
                  and Cbiemda = pro.scmda
                  and Cbiepap = pro.scpap
                  and Cbiecta = pro.sccta
                  and Cbieope = pro.scoper
                  and Cbiesub = pro.scsbop
                  and Cbietop = pro.sctope
                  and Cbiefec = fecha;
               if relacion is null then
                 relacion := 1;
               end if;
               Begin
                 select Cenom into desEst from fst026 Where Cecod = 55;
                 insert into fsd450(Cbieemp,
                                    Cbiemod,
                                    Cbiesuc,
                                    Cbiemda,
                                    Cbiepap,
                                    Cbiecta,
                                    Cbieope,
                                    Cbiesub,
                                    Cbietop,
                                    Cbiefec,
                                    Cbierel,
                                    Cbietxt1,
                                    Cbieant)
                             values(1,
                                    pro.scmod,
                                    pro.scsuc,
                                    pro.scmda,
                                    pro.scpap,
                                    pro.sccta,
                                    pro.scoper,
                                    pro.scsbop,
                                    pro.sctope,
                                    fecha,
                                    relacion,
                                    desEst,
                                    pro.scstat
                             );

                 update Fsd011
                    set Scstat = EstBloq
                  Where PgCod  = 1
                    and Scmod  = pro.scmod
                    and Scsuc  = pro.scsuc
                    and Scmda  = pro.scmda
                    and Scpap  = pro.scpap
                    and Sccta  = pro.sccta
                    and Scoper = pro.scoper
                    and Scsbop = pro.scsbop
                    and Sctope = pro.sctope;

                  if pro.scmod = 22 then
                    update Fsd010
                       set Aostat = EstBloq
                     Where PgCod  = 1
                       and Aomod  = pro.scmod
                       and Aosuc  = pro.scsuc
                       and Aomda  = pro.scmda
                       and Aopap  = pro.scpap
                       and Aocta  = pro.sccta
                       and Aooper = pro.scoper
                       and Aosbop = pro.scsbop
                       and Aotope = pro.sctope;
                  end if;

               Exception
                 when dup_val_on_index then
                   null;
               End;
             end if;
          end loop;
        end loop;
  end if;
  
  if :new.pfffal <> to_date('01/01/0001','dd/mm/yyyy') and :new.pfffal is not null  then    
        for cta in Cuentas(pepais, petdoc, pendoc) loop
          for lin in lineas(cta.ctnro) loop
              begin
                insert into jaqz090(jaqz090pai,
                                    jaqz090tdo,
                                    jaqz090ndo,
                                    jaqz090cva,
                                    jaqz090fei,
                                    jaqz090fef,
                                    jaqz090cmo,
                                    jaqz090mot,
                                    jaqz090con,
                                    jaqz090van,
                                    jaqz090vac,
                                    jaqz090emp,
                                    jaqz090mod,
                                    jaqz090suc,
                                    jaqz090mda,
                                    jaqz090pap,
                                    jaqz090cta,
                                    jaqz090ope,
                                    jaqz090sbo,
                                    jaqz090top
                                    )
                              values(pepais,
                                     petdoc,
                                     pendoc,
                                     56,
                                     fecha,
                                     lin.aofvto,
                                     3,
                                     'FALLECIDO',
                                     1,
                                     0,
                                     'S',
                                     1,
                                     lin.aomod,
                                     lin.aosuc,
                                     lin.aomda,
                                     lin.aopap,
                                     lin.aocta,
                                     lin.aooper,
                                     lin.aosbop,
                                     lin.aotope
                                    );
                exception
                  when dup_val_on_index then
                    null;

                end;
           end loop;     
        end loop;  
  end if ;
end TG_FSD002_BU_01;
/

