create or replace package PQ_OP_MENCLISMS is
  -- Author  : RWONG
  -- Created : 02/04/2019
  -- Purpose : 
   Procedure sp_cr_clicre;  
   procedure sp_ah_clinueaho;    
end PQ_OP_MENCLISMS;
/

create or replace package body PQ_OP_MENCLISMS is
                    
procedure sp_cr_clicre
   -- *****************************************************************
   -- Nombre                     : sp_cr_clicre
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 02/04/2019
   -- Autor de Creación          : WCRW
   -- Uso                        : Clientes créditos
   -- Estado                     : Activo
   -- Fecha Modificación         :
   -- Autor de Modificación      :
   -- Descripcion Modificacion   :
   -- *****************************************************************
   is
   ld_fecpro date;   
   ln_numcta number(9);   
   ls_nomana varchar2(30);                             
   ls_telana varchar2(10);
   ls_nomcli varchar2(100);
   ls_telcli varchar2(10);
   ls_sexcli char(1);
   ls_doccli varchar2(10);
   ls_codcli varchar2(21);
   ls_fecpro varchar2(6);
   CURSOR clicre
      IS select a.aomod,a.aosuc,a.aomda,a.aopap,a.aocta,a.aooper,a.aosbop,a.aotope
           from fsd010 a
          where a.aomod in (select modulo from fst111 where dscod = 50) 
            and a.pgcod = 1
            and a.aofval = ld_fecpro;
   BEGIN
      ld_fecpro := trunc(sysdate);
      --ld_fecpro := '26/04/2019';
      ls_fecpro := substr(to_char(ld_fecpro),1,2) || substr(to_char(ld_fecpro),4,2) || substr(to_char(ld_fecpro),7,2);
      FOR x IN clicre LOOP    
         begin
            select jaql836sncta into ln_numcta 
              from jaql836s
             where jaql836sncta = x.aocta
               and jaql836sfpro = ld_fecpro
               and jaql836sctip <> 'A';
         exception
         when no_data_found then
            begin   
               select substr(b.jaql708nom,1,30),substr(trim(b.jaql708tlf),1,10) into ls_nomana,ls_telana
                 from sng001 a,jaql708 b
                where a.sng001inst = fn_instancia_credito(x.aomod,x.aosuc,x.aomda,x.aopap,x.aocta,x.aooper,x.aosbop,x.aotope)
                  and a.sng001ase = b.jaql708usr;
            exception
            when no_data_found then
               ls_nomana := null;
               ls_telana := null;
            end;   
            begin
               select c.pfcant,b.penom,trim(b.pendoc) into ls_sexcli,ls_nomcli,ls_doccli
                 from fsr008 a,fsd001 b,fsd002 c
                where a.ctnro = x.aocta
                  and b.pepais = a.pepais
                  and b.petdoc = a.petdoc
                  and b.pendoc = a.pendoc
                  and a.pepais = c.pfpais
                  and a.petdoc = c.pftdoc
                  and a.pendoc = c.pfndoc
                  and rownum = 1;   
            exception
            when no_data_found then
               ls_sexcli := '';
               ls_nomcli := '';
               ls_doccli := null;
            end;   
            begin
               select substr(trim(b.dotelfp),1,10) into ls_telcli
                 from fsr008 a,fsr005 b,sngc17 c
                where a.ctnro = x.aocta
                  and b.pepais = a.pepais
                  and b.petdoc = a.petdoc
                  and b.pendoc = a.pendoc
                  and c.sngc17pais = b.pepais
                  and c.sngc17tdoc = b.petdoc
                  and c.sngc17ndoc = b.pendoc
                  and c.sngc17dcod = b.docod
                  and c.sngc17corr = b.doordp
                  and c.sngc16ttel <> 2
                  and rownum = 1;
            exception     
            when no_data_found then
               ls_telcli := null;
            end;   
            if ls_telcli is not null then
               if ls_doccli is not null then
                  ls_codcli := 'DA' || lpad(ls_doccli,10,'0') || lpad(trim(ls_fecpro),9,'0');
                  begin
                     select codigo_cliente into ls_codcli from ichannelalert.clientes_afiliados where codigo_cliente = ls_codcli;
                  exception
                  when no_data_found then
                     if ls_telana is not null then   
                        begin
                        insert into ichannelalert.clientes_afiliados
                           (codigo_cliente,nombre_cliente,mail_cliente,celular_cliente,sexo_cliente,
                            enviar_celular,enviar_mail)
                        values
                           (ls_codcli,ls_nomcli,'',ls_telcli,ls_sexcli,'S','N');
                        commit;   
                        exception
                        when dup_val_on_index then
                           null;
                        when others then
                           null; 
                        end;   
                     end if;      
                  end;
                  begin
                  insert into JAQL836S (jaql836sncta,jaql836sfpro,jaql836shpro,jaql836scest,
                         jaql836sctip,jaql836sfenv,jaql836snana,jaql836sfana,jaql836sccli)
                  values (x.aocta,ld_fecpro,to_char(sysdate, 'HH24:MI:SS'),1,'C',ld_fecpro,
                         ls_nomana,ls_telana,ls_codcli);
                  commit;
                  exception
                  when dup_val_on_index then
                     null;
                  when others then
                     null; 
                  end;
               end if;      
            end if;   
         end;     
      END LOOP;  
end sp_cr_clicre;      

procedure sp_ah_clinueaho
   -- *****************************************************************
   -- Nombre                     : sp_ah_clinueaho
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 04/04/2019
   -- Autor de Creación          : WCRW
   -- Uso                        : Clientes nuevos ahorros
   -- Estado                     : Activo
   -- Fecha Modificación         :
   -- Autor de Modificación      :
   -- Descripcion Modificacion   :
   -- *****************************************************************
   is
   ld_fecpro date;                            
   ln_numcta number(9);
   ls_nomcli varchar2(100);
   ls_telcli varchar2(10);
   ls_sexcli char(1);
   ls_doccli varchar2(10);
   ls_codcli varchar2(21);                                       
   CURSOR cliaho
      IS select a.sccta 
           from fsd011 a
          where a.pgcod = 1
            and a.scmod in (21,22) 
            and a.scfval = ld_fecpro
            and a.scsdo > 0
            and a.sccta not in (select jaql836sncta from jaql836s where jaql836sncta = a.sccta)
            and a.sccta not in (select sccta from fsd011 
                                 where sccta = a.sccta
                                   and pgcod = 1
                                   and scmod in (21,22)
                                   and scfval < ld_fecpro);
   BEGIN
      ld_fecpro := trunc(sysdate);
      --ld_fecpro := '24/01/2019';
      FOR x IN cliaho LOOP           
         begin
            select jaql836sncta into ln_numcta from jaql836s where jaql836sncta = x.sccta;
         exception
         when no_data_found then
             begin
               select c.pfcant,b.penom,substr(trim(b.pendoc),1,10) into ls_sexcli,ls_nomcli,ls_doccli
                 from fsr008 a,fsd001 b,fsd002 c
                where a.ctnro = x.sccta
                  and b.pepais = a.pepais
                  and b.petdoc = a.petdoc
                  and b.pendoc = a.pendoc
                  and a.pepais = c.pfpais
                  and a.petdoc = c.pftdoc
                  and a.pendoc = c.pfndoc
                  and rownum = 1;      
            exception
            when no_data_found then
               ls_sexcli := '';
               ls_nomcli := '';
               ls_doccli := null;
            end;   
            begin
               select substr(trim(b.dotelfp),1,10) into ls_telcli
                 from fsr008 a,fsr005 b,sngc17 c
                where a.ctnro = x.sccta
                  and b.pepais = a.pepais
                  and b.petdoc = a.petdoc
                  and b.pendoc = a.pendoc
                  and c.sngc17pais = b.pepais
                  and c.sngc17tdoc = b.petdoc
                  and c.sngc17ndoc = b.pendoc
                  and c.sngc17dcod = b.docod
                  and c.sngc17corr = b.doordp
                  and c.sngc16ttel <> 2
                  and rownum = 1;
            exception     
            when no_data_found then
               ls_telcli := '';
            end;
            if ls_telcli is not null then
               if ls_doccli is not null then
                  ls_codcli := 'DA' || lpad(ls_doccli,10,'0') || lpad(trim(to_char(x.sccta,'999999999')),9,'0');
                  begin
                     select codigo_cliente into ls_codcli from ichannelalert.clientes_afiliados where codigo_cliente = ls_codcli;
                  exception
                  when no_data_found then   
                     begin
                     insert into ichannelalert.clientes_afiliados
                        (codigo_cliente,nombre_cliente,mail_cliente,celular_cliente,sexo_cliente,
                         enviar_celular,enviar_mail)
                     values
                        (ls_codcli,ls_nomcli,'',ls_telcli,ls_sexcli,'S','N');
                        commit;
                     exception
                     when dup_val_on_index then
                        null;
                     when others then
                        null; 
                     end;
                  end;
                  begin
                  insert into JAQL836S (jaql836sncta,jaql836sfpro,jaql836shpro,jaql836scest,
                                        jaql836sctip,jaql836sfenv,jaql836snana,jaql836sfana,
                                        jaql836sccli)
                  values (x.sccta,ld_fecpro,to_char(sysdate, 'HH24:MI:SS'),1,'A',ld_fecpro,
                          '','',ls_codcli);
                  commit;
                  exception
                  when dup_val_on_index then
                      null;
                  when others then
                      null; 
                  end;
               end if;   
            end if;   
         end;     
      END LOOP;  
end sp_ah_clinueaho;      

end PQ_OP_MENCLISMS;
/

