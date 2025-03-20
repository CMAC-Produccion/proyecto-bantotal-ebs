create or replace package PQ_OP_MENCLINUE is
  -- Author  : RWONG
  -- Created : 04/05/2018
  -- Purpose : 
   Procedure sp_cr_clinuecre;  
   procedure sp_ah_clinueaho;    
   procedure sp_op_leecli;
   procedure sp_op_envmai(ps_TipCli in varchar2,ps_NomCli in varchar2,ps_DesMai in varchar2,pn_NumCta in number);
end PQ_OP_MENCLINUE;
/

create or replace package body PQ_OP_MENCLINUE is
                    
procedure sp_cr_clinuecre
   -- *****************************************************************
   -- Nombre                     : sp_cr_clinuecre
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 04/06/2018
   -- Autor de Creación          : WCRW
   -- Uso                        : Clientes nuevos créditos
   -- Estado                     : Activo
   -- Fecha Modificación         :
   -- Autor de Modificación      :
   -- Descripcion Modificacion   :
   -- *****************************************************************
   is
   ld_fecpro date;   
   ln_numcta number(9);                                
   CURSOR clicre
      IS select a.aocta 
           from fsd010 a
          where a.aomod in (select modulo from fst111 where dscod = 50) 
            and a.pgcod = 1
            and a.aofval = ld_fecpro
            and a.aocta not in (select jaql836ncta from jaql836 where jaql836ncta = a.aocta)
            and a.aocta not in (select aocta from fsd010 
                                 where aocta = a.aocta
                                   and pgcod = 1
                                   and aomod in (select modulo from fst111 where dscod = 50)
                                   and aofval < ld_fecpro);
      
   BEGIN
      ld_fecpro := trunc(sysdate);
      --ld_fecpro := '30/07/2018';
      FOR x IN clicre LOOP    
         begin
            select jaql836ncta into ln_numcta from jaql836 where jaql836ncta = x.aocta;
         exception
         when no_data_found then
            insert into JAQL836 (jaql836ncta,jaql836fpro,jaql836cest,jaql836ctip) 
            values (x.aocta,ld_fecpro,1,'C');
            commit;
         end;     
      END LOOP;  
end sp_cr_clinuecre;      

procedure sp_ah_clinueaho
   -- *****************************************************************
   -- Nombre                     : sp_ah_clinueaho
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 07/06/2018
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
   CURSOR cliaho
      IS select a.sccta 
           from fsd011 a
          where a.pgcod = 1
            and a.scmod in (21,22) 
            and a.scfval = ld_fecpro
            and a.scsdo > 0
            and a.sccta not in (select jaql836ncta from jaql836 where jaql836ncta = a.sccta)
            and a.sccta not in (select sccta from fsd011 
                                 where sccta = a.sccta
                                   and pgcod = 1
                                   and scmod in (21,22)
                                   and scfval < ld_fecpro);
   BEGIN
      ld_fecpro := trunc(sysdate);
      --ld_fecpro := '30/07/2018';
      FOR x IN cliaho LOOP           
         begin
            select jaql836ncta into ln_numcta from jaql836 where jaql836ncta = x.sccta;
         exception
         when no_data_found then
            insert into JAQL836 (jaql836ncta,jaql836fpro,jaql836cest,jaql836ctip) 
            values (x.sccta ,ld_fecpro,1,'A');
            commit;  
         end;     
      END LOOP;  
end sp_ah_clinueaho;      

procedure sp_op_leecli
   -- *****************************************************************
   -- Nombre                     : sp_op_leecli
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 04/06/2018
   -- Autor de Creación          : WCRW
   -- Uso                        : Lee Clientes para envio de mail
   -- Estado                     : Activo
   -- Fecha Modificación         :
   -- Autor de Modificación      :
   -- Descripcion Modificacion   :
   -- *****************************************************************
   is
   ls_desmai varchar2(200);
   ls_nomcli varchar2(200);
   ld_fecpro date;
   ln_numpos number;
   ln_Cuenta number;
   ls_tipper char(1);
   ln_codpai number(3);
   ln_tipdoc number(2);
   ls_numdoc char(12);
   ln_numcor number(3);
   ln_Ctl001 number(3);
   CURSOR cli
      IS select jaql836ncta,jaql836ctip
           from jaql836
          where jaql836cest = 1;
   CURSOR per (pn_Cuenta in number)
      IS select pepais,petdoc,pendoc
           from fsr008 
          where pgcod = 1
            and ctnro = pn_Cuenta;
          --and a.cttfir = 'T' 
   BEGIN
      ld_fecpro := trunc(sysdate);
      --ld_fecpro := '12/07/2018';
      FOR x IN cli LOOP
         ln_cuenta := x.jaql836ncta;
         begin
            FOR y IN per(ln_Cuenta) LOOP
               ln_numcor := 0;
               begin
                  select count(*) into ln_numcor
                    from fsx001 b,fsd001 c
                   where b.pepais = y.pepais
                     and b.petdoc = y.petdoc
                     and b.pendoc = y.pendoc
                     and b.txcod = 0
                     and c.pepais = b.pepais
                     and c.petdoc = b.petdoc
                     and c.pendoc = b.pendoc;
                  exception
                  when others then     
                     ln_numcor := 0;
               end;   
               if ln_numcor > 0 then
                  ln_Ctl001 := 1;
                  while ln_ctl001 <= ln_numcor loop
                     begin   
                     select b.pextxt,c.petipo,y.pepais,y.petdoc,trim(y.pendoc),c.penom 
                       into ls_desmai,ls_tipper,ln_codpai,ln_tipdoc,ls_numdoc,ls_nomcli 
                       from fsx001 b,fsd001 c
                      where b.pepais = y.pepais
                        and b.petdoc = y.petdoc
                        and b.pendoc = y.pendoc
                        and b.txcod = 0
                        and c.pepais = b.pepais
                        and c.petdoc = b.petdoc
                        and c.pendoc = b.pendoc
                        and b.pexren = ln_Ctl001;
                    exception
                    when others then      
                       ls_desmai := null;
                    end;   
                    if ls_desmai is null then
                       update JAQL836 set jaql836cest = 2,jaql836fpro = ld_fecpro
                       where jaql836ncta = x.jaql836ncta;
                       commit;  
                    else   
                       if ls_tipper = 'F' then
                          begin
                             select pfnom1 into ls_nomcli
                               from fsd002
                               where pfpais = ln_codpai
                                 and pftdoc = ln_tipdoc
                                 and pfndoc = ls_numdoc;
                          exception
                          when others then      
                             ls_nomcli := '';
                          end; 
                       end if;
                       ln_numpos := INSTR(ls_desmai,'\');
                       ls_desmai := TRIM(SUBSTR(ls_desmai,1,ln_numpos -1));
                       sp_op_envmai(x.jaql836ctip,ls_nomcli,ls_desmai,x.jaql836ncta);
                     end if;
                     ln_Ctl001 := ln_Ctl001 + 1;
                  end loop; 
               else
                  update JAQL836 set jaql836cest = 3,jaql836fpro = ld_fecpro
                  where jaql836ncta = x.jaql836ncta;
                  commit;      
               end if;
            END LOOP;   
            --CLOSE per;    
         end;   
      end loop;   
end sp_op_leecli;      

procedure sp_op_envmai(ps_TipCli in varchar2,ps_NomCli in varchar2,ps_DesMai in varchar2,pn_NumCta in number)
   -- *****************************************************************
   -- Nombre                     : sp_op_envmai
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 18/06/2018
   -- Autor de Creación          : WCRW
   -- Uso                        : Envia Mails
   -- Estado                     : Activo
   -- Fecha Modificación         : 23/12/2019
   -- Autor de Modificación      : WCRW
   -- Descripcion Modificacion   : Validación de mail registrado
   -- *****************************************************************
   is
   ld_fecpro date;                                   
   ls_rutarc varchar2(200);
   ls_desrem varchar2(200);
   ls_desasu varchar2(200);
   ls_desarc varchar2(200);
   ls_coderr varchar2(400);
   ls_deserr varchar2(400);
   ls_nomimg varchar2(200);
   ll_mensaj clob;
   ls_mensaj varchar2(32767);   

   BEGIN
      ld_fecpro := trunc(sysdate);
      begin
         select trim(a.tp1desc)
           into ls_rutarc 
           from fst198 a
          Where a.Tp1cod   = 1
            and a.Tp1cod1  = 10825
            and a.Tp1corr1 = 61
            and a.Tp1corr2 = 6
            and a.tp1corr3 = 3; --repositorio  
      exception
      when others then
         ls_rutarc := null;
      end;     
      if ps_TipCli = 'A' then
         ls_nomimg := 'educacion-financiera-ahorros-junio-18.jpg';
         ls_desarc := 'MenCliAHORROS.pdf';
      else
         ls_nomimg := 'educacion-financiera-creditos-junio-18.jpg';
         ls_desarc := 'MenCliCREDITOS.pdf';
      end if;      
      dbms_lob.createtemporary(ll_mensaj, TRUE); 
      ls_mensaj := '<p align="left">' || ps_nomcli || ',  tenemos algo que decirte:</p>';
      ls_mensaj := ls_mensaj || '<IMG SRC="https://www.cajaarequipa.pe/documents/' || ls_nomimg || '" ALIGN="LEFT">'; 
      ls_mensaj := ls_mensaj || '<p align="left"> </p>'; 
      ls_mensaj := ls_mensaj || '<p align="left">Por favor no responda a este correo. Si tienes dudas, para mayor información ingresa a nuestra web www.cajaarequipa.pe</p>'; 
      ls_mensaj := ls_mensaj || '<p align="left"> </p>'; 
      ls_mensaj := ls_mensaj || '<p align="left">Por tu seguridad, Caja Arequipa te informa:</p>'; 
      ls_mensaj := ls_mensaj || '<p align="left">Nunca solicitaremos tus datos confidenciales por correo, tales como la clave de tu tarjeta de débito, información de tus cuentas o DNI.</p>'; 
      ls_mensaj := ls_mensaj || '<p align="left">Si tienes alguna duda acerca de la autenticidad de este correo envíalo a la dirección: somosCaja@cajaarequipa.pe y te responderemos.</p>'; 
      ls_mensaj := ls_mensaj || '<p align="left">Este correo electrónico fue enviado por Caja Arequipa. Dirección: Calle La Merced Nro 106 Arequipa Perú.</p>'; 
      dbms_lob.writeappend(ll_mensaj,length(ls_mensaj),ls_mensaj);
      --dbms_lob.freetemporary(ll_mensaj, TRUE); 
      --ls_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
      --dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

      ls_desrem := 'CAJAAREQUIPA@cajaarequipa.pe';
      ls_desasu := '¡Bienvenido a Caja Arequipa!';
      if pq_ah_enviodigital.fn_ah_valida_mail(trim(ps_desmai)) = 'S' then
         pq_ah_planillas.p_sendmailattach(ps_desmai,'','',ls_mensaj,ls_desrem,ls_desasu,
                                          'HTML',ls_rutarc,ls_desarc,ls_coderr,ls_deserr);
         if ls_coderr = '000' then
            update JAQL836 set jaql836cest = 0,jaql836fenv = ld_fecpro
            where jaql836ncta = pn_NumCta;
            --and jaql836fpro = ld_fecpro;
            commit;  
         end if;
      else
         update JAQL836 set jaql836cest = 4 where jaql836ncta = pn_NumCta;
		     commit;
      end if;
      dbms_lob.freetemporary(ll_mensaj); 
end  sp_op_envmai;      

end PQ_OP_MENCLINUE;
/

