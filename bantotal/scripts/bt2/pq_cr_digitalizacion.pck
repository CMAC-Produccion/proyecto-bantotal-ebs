create or replace package PQ_CR_DIGITALIZACION is

Procedure Sp_inserta (pn_ins in number,
                      pc_nod in varchar2,
                      pc_usr in char,
                      lc_varet out varchar2);
                      
end PQ_CR_DIGITALIZACION;
/

create or replace package body PQ_CR_DIGITALIZACION is

Procedure Sp_inserta (pn_ins in number,
                      pc_nod in varchar2,
                      pc_usr in char,
                      lc_varet out varchar2) is
ln_caconid        number(10) := 0;
ln_caconidF       number(10) := 0;
lc_caconling      char(3) := 'IND';
lc_caconvers      number(6) := 1;
ln_cactypappid    number(2) := 1;
ln_cactypid       number(10) := 1;
ln_caestappid     number(2) := 1;
ln_caestid        number(10) := 1;
ld_caconfchcre    date := sysdate;
ld_caconfchlstmod date := sysdate;
ln_caconchkout    number(1) := 0;
ld_cacontmechkout date := to_date('01/01/0001','dd/mm/yyyy');
ln_cacontmp       number(1) := 0;
ln_caconblobcnt   number(4) := 0;
ln_caconlstver    number(1) := 1;
ln_cacondel       number(1) := 0;

ln_DDOCINS        number(10) := 0;
ln_DDOCINSF       number(10) := 0;
--lc_DDOCTIT        char(200);
ln_DDULVER        number(6) := 1;
lc_DDEST          char(1) := 'A';
ld_DDFRES         date := to_date('01/01/0001','dd/mm/yyyy');
ld_DDFDEL         date := to_date('01/01/0001','dd/mm/yyyy');
ld_DDFEMI         date := to_date('01/01/2010','dd/mm/yyyy');
ld_DDFVTO         date := to_date('01/01/2040','dd/mm/yyyy');
ld_DDFPALE        date := to_date('01/01/0001','dd/mm/yyyy');
ld_DDFALER        date := to_date('01/01/0001','dd/mm/yyyy');
--ln_DOCID          number(10) := 70;

ln_ddocver        number(6) := 1;
ld_ddocfec        date := sysdate;
--lv_ddnomar        varchar2(200);

lc_doclng         char(3) := 'IND';
ln_docver         number(6) := 1;
ln_canuml         number(10);
ln_canumlF        number(10);
lc_pc_nod         varchar2(200);
ln_wfitemid       number(10);
ln_WFINSDOCVER    number(6) := 1;
ln_sng059dsc      number(10);

ln_suc            number(3);
PC_TITULO         VARCHAR2(200);
PC_MENSAJE        VARCHAR2(500);
lc_sucur          char(30);
lc_usr            char(30);
--lc_varet          varchar2(200);
PC_ORIGEN         VARCHAR2(10);
PC_DESTINO        VARCHAR2(10);
ln_flg            number(1);
ln_DOCID_ini      number(10);
ln_DOCID_fin      number(10);
ln_nrocont        number(10);
lc_ubuser         char(10);
cursor usuario_prueba is
select a.TP1DESC
  from fst198 a
 where a.TP1COD   = 1
   and a.TP1COD1  = 11118
   and a.TP1CORR1 = 2
   and a.TP1CORR2 = 1 
   and a.tp1corr3 > 0;
   
cursor usuario (cn_suc in number) is
select ubuser 
  from fst046 
 where ubuser in (select ubuser 
                    from prfu00 
                   where prfgcod='RCAS02') 
   and ubsuc in (select oficod 
                   from fst811 
                  where regcod in (select regcod 
                                     from fst811 
                                    where oficod = cn_suc 
                                      and regcod < 100 
                                      and regcod > 0));   

Begin
       --Usuario
       begin
           select b.ubuser,b.ubnom
             into lc_ubuser,lc_usr
             from sng001 a, fst746 b
            where a.sng001inst = pn_ins
              and a.sng001ase  = b.ubuser;
      exception
           when others then null;   
      end;
      
       
       --variable sin pdf
       
       lc_pc_nod := to_char(substr(trim(pc_nod),1,LENGTH(trim(pc_nod))-4));
                  
       --CANUM
       begin
           select a.canumlstnum
             into ln_canuml
             from canum a;
       exception
             when others then null;
       end;
       
       ln_canumlF := ln_canuml + 1;
       
       begin
           update canum a 
              set a.canumlstnum=ln_canumlF,
                  a.canumdatelastupd = sysdate;
           commit;
       end;
       
       
       
       --CACON
       begin
            select max(a.caconid)
              into ln_caconid
              from CaCon a;
       exception
              when others then
                   ln_caconid := 0;
       end;
       ln_caconidF := ln_caconid + 1;
       
       insert into cacon (caconid,
                          caconlng,
                          caconvers,
                          caconresp,
                          cactypappid,
                          cactypid,
                          cacontit,
                          caestappid,
                          caestid,
                          caconfchcre,
                          caconfchlstmod,
                          caconchkout,
                          cacontmechkout,
                          cacontmp,
                          caconblobcnt,
                          caconlstver,
                          cacondel)
                  values (ln_caconidF,
                          lc_caconling,
                          lc_caconvers,
                          lc_ubuser,
                          ln_cactypappid,
                          ln_cactypid,
                          lc_pc_nod,     
                          ln_caestappid,
                          ln_caestid,  
                          ld_caconfchcre,
                          ld_caconfchlstmod,
                          ln_caconchkout ,  
                          ld_cacontmechkout,
                          ln_cacontmp  ,    
                          ln_caconblobcnt , 
                          ln_caconlstver,   
                          ln_cacondel  );
                  commit;    
                  
       --WFITEMDOC
       begin
           select max(a.wfitemid)
             into ln_wfitemid
             from wfwrkitems a
            where a.wfinsprcid = pn_ins;
       exception
            when others then null;
       end;
       
       insert into WFITEMDOC(WFITEMID,
                             WFINSDOCID,
                             WFINSDOCLNG,
                             WFINSDOCVER)
                             
                     values (ln_wfitemid,
                             ln_canumlF,
                             lc_caconling,
                             ln_WFINSDOCVER);
                     commit;
       
       --SNG059
        begin
           select a.sng059num + 1
             into ln_sng059dsc
             from SNG059 a
            where a.sng059cod=40;
       end;
       
       begin
           update SNG059 t set sng059num=ln_sng059dsc where t.sng059cod=40;
           commit;
       end;
       
       --WFDocInst
       ln_nrocont := 0;
       begin
           select count(*)
             into ln_nrocont
             from WFDocInst a
            where a.wfinsprcid = pn_ins;
       exception
            when others then
                 ln_nrocont := 0;
                 
       end;
       
       --Tipos de documento
       begin
            select a.tp1nro1
              into ln_DOCID_ini
              from fst198 a
             where a.tp1cod   = 1
               and a.tp1cod1  = 11118
               and a.tp1corr1 = 4
               and a.tp1corr2 = 1
               and a.tp1corr3 = 1;
       exception
            when others then null;
       end;
       if ln_nrocont = 0 then
          ln_DOCID_fin := ln_DOCID_ini;
       end if;
       
       if ln_nrocont = 1 then
          ln_DOCID_fin := ln_DOCID_ini+1;
       end if;
       
       if ln_nrocont >= 2 then
          ln_DOCID_fin := ln_DOCID_ini+2;
       end if;
     
       ln_DOCID_fin := ln_DOCID_ini; --siempre en 300 por ahora
      insert into WFDocInst(Wfinsprcid,
                            Wfinsdocid,
                            Wfinsdoclng,
                            Wfinsdocver)
                    values (pn_ins,
                            ln_caconidF,
                            lc_doclng,
                            ln_docver);
                    commit;
       --XWFD01
       
       begin
            select max(a.xwfddocins)
              into ln_DDOCINS
              from XWFD01 a;
       exception
              when others then
                   ln_DDOCINS := 0;
       end;
       
       
       
       ln_DDOCINSF := ln_DDOCINS + 1;
       --lc_DDOCTIT  := to_char(pc_nod);
       
       insert into XWFD01 (XWFDDOCINS,
                           XWFDDOCTIT,
                           XWFDDULVER,
                           XWFDDEST,
                           XWFDDFRES,
                           XWFDDFDEL,
                           XWFDDFEMI,
                           XWFDDFVTO,
                           XWFDDFPALE,
                           XWFDDFALER,
                           XWFDOCID)
                   VALUES (ln_DDOCINSF,
                           lc_pc_nod,--lc_DDOCTIT,
                           ln_DDULVER,
                           lc_DDEST , 
                           ld_DDFRES ,
                           ld_DDFDEL ,
                           ld_DDFEMI ,
                           ld_DDFVTO ,
                           ld_DDFPALE,
                           ld_DDFALER,
                           ln_DOCID_fin  );
                           
                  commit;
      
       --XWFD02
       
       --lv_ddnomar := pc_nod||to_char(ln_caconidF)||'-'||'1'||'.pdf';

                              
       insert into xwfd02 (xwfddocins,
                           xwfddocver,
                           xwfddocusu,
                           xwfddocfec,
                           xwfddnomar)
                   values (ln_DDOCINSF,
                           ln_ddocver,   
                           lc_ubuser,
                           ld_ddocfec,
                           pc_nod);
                   commit;
      
      --variable de retorno
      lc_varet := lc_pc_nod||to_char(ln_caconidF)||'-'||'1'||'.pdf';  
      
      
      --envio mail
      begin
         select a.xwfsucursal
           into ln_suc
           from xwf700 a
          where a.xwfprcins = pn_ins
            and a.xwfcar3   = '1';
      exception
            when others then null;
      end;
      
      begin
          select a.scnom
            into lc_sucur
            from fst001 a
           where a.sucurs = ln_suc;
      exception
           when others then null;
      end;
      
      begin
           select trim(a.TP1DESC)
             into PC_ORIGEN
             from fst198 a 
            where a.TP1COD   = 1
              and a.TP1COD1  = 11118
              and a.TP1CORR1 = 3
              and a.TP1CORR2 = 1
              and a.TP1CORR3 = 1;
      exception when others then null;
      end;
      
           
      PC_TITULO := 'Digitalizacion Expendiente: '||to_char(pn_ins);
      PC_MENSAJE := 'Estimado(a), tiene un expendiente digitalizado
                     de la agencia: '||lc_sucur||', número de solicitud: '||
                     to_char(pn_ins)||', analista: '||lc_usr;
      
      --Flag indicador 1-prueba, 0-produccion
      begin
             select a.tp1nro1
               into ln_flg
               from fst198 a
              where a.tp1cod  = 1
                and a.tp1cod1 = 11118
                and a.tp1corr1 = 1
                and a.tp1corr2 = 1
                and a.tp1corr3 = 1;
      exception 
          when others then null;
      end;
      
      if ln_flg = 1 then
      
          for i in usuario_prueba loop
              PC_DESTINO := trim(i.tp1desc);
              sP_CONCATENA_MAIL(PC_ORIGEN ,
                                PC_DESTINO,
                                PC_TITULO ,
                                PC_MENSAJE)
              
              ;
          end loop;
          
       end if;
       
       if ln_flg = 0 then
      
          for j in usuario(ln_suc) loop
              --PC_DESTINO := 'lcarpio';--comentar en produccion
              PC_DESTINO := trim(j.ubuser); --descomentar en produccion
              --comentar en produccion
              --PC_MENSAJE := 'Estimado(a), tiene un expendiente digitalizado
              --       de la agencia: '||lc_sucur||', número de solicitud: '||
              --       to_char(pn_ins)||', analista: '||lc_usr||'-'||j.ubuser; 
              --comentar en produccion       
              sP_CONCATENA_MAIL(PC_ORIGEN ,
                                PC_DESTINO,
                                PC_TITULO ,
                                PC_MENSAJE)
              
              ;
          end loop;
          
       end if;
       
       
end Sp_inserta;

end PQ_CR_DIGITALIZACION;
/

