create or replace package PQ_OP_TRAMONTAR is
   Procedure sp_op_OpeDebCreCom(pd_FecPro in date);
   Procedure sp_op_SolIntBan(pd_FecPro in date);
   Procedure sp_op_SolTarDeb(pd_FecPro in date);
   Procedure sp_op_ActCtaSolTarDeb;
end PQ_OP_TRAMONTAR;
/

create or replace package body PQ_OP_TRAMONTAR is
                    
procedure sp_op_OpeDebCreCom(pd_FecPro in date) is
   -- *****************************************************************
   -- Nombre                     : sp_op_OpeDebCreCom
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 28/09/2018
   -- Autor de Creación          : WCRW
   -- Uso                        : Registro 8620 Operaciones Debito / Credito Comercio
   -- Estado                     : Activo
   -- Fecha Modificación         :
   -- Autor de Modificación      :
   -- Descripcion Modificacion   :
   -- *****************************************************************
begin
   delete jaql819c;
   commit;
   insert into jaql819c (jaql819c87550,jaql819c87584,jaql819c87507,jaql819c87506,jaql819c87563,
                        jaql819c87503,jaql819c87504,jaql819c87557,jaql819c87515,jaql819c87514,
                        jaql819c87502,jaql819c87595,jaql819c87654,jaql819c87655,jaql819c87516,
                        jaql819c87690,jaql819c87531,jaql819c87533,jaql819c87586,jaql819c87527,
                        jaql819c87521)
   select 10 n87550,(select c.pendoc 
                       from fsr008 c
                      where c.pgcod = 1
                        and c.ctnro = (select b.hcta
                                         from fsh016 b 
                                        where a.pgcod = b.pgcod
                                          and a.hcmod = b.hcmod
                                          and a.htran = b.htran
                                          and a.hfcon = b.hfcon
                                          and a.hsucor = b.hsucor
                                          and a.hnrel = b.hnrel
                                          and a.hfcon = b.hfcon
                                          and b.hcta > 0
                                          and ROWNUM = 1)
                        and ROWNUM = 1) s87584,
          to_number(to_char(a.hfcon,'YYYY')||to_char(a.hfcon,'MM')||to_char(a.hfcon,'DD'),'99999999') n87507,
          to_number(replace(a.hhora,':',''),'999999') n87506,
          to_number(to_char(a.hfvc,'YYYY')||to_char(a.hfvc,'MM')||to_char(a.hfvc,'DD'),'99999999') n87563,
          (select case when b.hmda = 0  then round(b.hcimp1,2) else round(b.hcimp1 * fn_tipo_cambio(a.hfcon,0,101,0),2) end
             from fsh016 b 
            where a.pgcod = b.pgcod
              and a.hcmod = b.hcmod
              and a.htran = b.htran
              and a.hfcon = b.hfcon
              and a.hsucor = b.hsucor
              and a.hnrel = b.hnrel
              and a.hfcon = b.hfcon
              and b.hcta > 0
              and ROWNUM =1) n87503,
          (select round(b.hcimp1,2)
             from fsh016 b 
            where a.pgcod = b.pgcod
              and a.hcmod = b.hcmod
              and a.htran = b.htran
              and a.hfcon = b.hfcon
              and a.hsucor = b.hsucor
              and a.hnrel = b.hnrel
              and a.hfcon = b.hfcon
              and b.hcta > 0
              and ROWNUM = 1) n87504,
          '0001' s87557,'0' s87515,trim(to_char(a.hnrel,'999999')) s87514,'N' s87502,
          '' s87595,'' s87654,'' s87655,a.hwsing s87516,a.husing s87690,
          trim(to_char(a.hsucor,'999999999999999')) s87531,a.husing s87533,'C' s87586,
         (select round(c.scsdo,2) 
            from fsh015 a,fsh016 b,fsd011 c
           where a.pgcod = 1
             and a.hcmod = 98
             and a.htran = 380 
             and a.hfcon = pd_fecpro
             and a.pgcod = b.pgcod
             and a.hcmod = b.hcmod
             and a.htran = b.htran
             and a.hfcon = b.hfcon
             and a.hsucor = b.hsucor
             and a.hnrel = b.hnrel
             and a.hfcon = b.hfcon
             and c.pgcod = a.pgcod
             and c.scsuc = b.hsucor
             and c.scmda = b.hmda
             and c.scpap = b.hpap
             and c.sccta = b.hcta
             and c.scoper = b.hoper
             and c.scsbop = b.hsubop
             and c.sctope = htoper
             and c.scmod = hmodul       
             and c.scfcon = a.hfcon
             and ROWNUM = 1) n87527,'AC' s87521
     from fsh015 a
    where a.pgcod = 1
      and a.hcmod = 98
      and a.htran = 380 
      and a.hfcon = pd_fecpro;
   commit;    
end sp_op_OpeDebCreCom;      

procedure sp_op_SolIntBan(pd_FecPro in date) is
   -- *****************************************************************
   -- Nombre                     : sp_op_SolIntBan
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 28/09/2018
   -- Autor de Creación          : WCRW
   -- Uso                        : Registro 921 Solicitud de Internet Banking
   -- Estado                     : Activo
   -- Fecha Modificación         :
   -- Autor de Modificación      :
   -- Descripcion Modificacion   :
   -- *****************************************************************
begin
   delete jaql819b;
   commit;
   insert into jaql819b (jaql819b9000,jaql819b9001,jaql819b9002,jaql819b9017,jaql819b9067,
                         jaql819b9136,jaql819b9137,jaql819b9138,jaql819b9139,jaql819b9140,
                         jaql819b9010,jaql819b9122,jaql819b9123,jaql819b9126,jaql819b9119,
                         jaql819b9121,jaql819b9127,jaql819b9128,jaql819b9141,jaql819b9152,
                         jaql819b9155)
   select lpad(lpad(to_char(a.cnl001pus),3,'0')||lpad(to_char(a.cnl001tus),2,'0')||trim(a.cnl001dus),18,'0') s9000,
          lpad(to_char(a.cnl001tus),3,'0') s9001,trim(a.cnl001dus) s9002,trim(a.cnl001nom) s9017,trim(a.cnl001dus) s9067,
          (select trim(to_char(z0e479cta,'99999999999999999999')) from z0e479 where z0e478nro = a.cnl001usu and ROWNUM =1) s9136,
          'A' s9137,
          (select trim(to_char(z0e479top,'99999')) from z0e479 where z0e478nro = a.cnl001usu and ROWNUM =1) s9138,
          '' s9139,'N' s9140,
          (select z0e478uau from z0e478 where z0e478nro = a.cnl001usu) s9010,
          to_number(to_char(a.cnl001ucf,'YYYY')||to_char(a.cnl001ucf,'MM')||to_char(a.cnl001ucf,'DD'),'99999999') n9122,
          to_number(replace(a.cnl001uch,':',''),'999999') s9123,
          substr(trim(a.cnl001uip),1,15) s9126,
          (select z0e478suc from z0e478 where z0e478nro = a.cnl001usu) s9119,
          (select b.depnom 
             from fst068 b,fst001 c
            where b.pais = 604 
              and b.depcod = to_number(c.scdept) 
              and c.pgcod = 1
              and c.sucurs = (select z0e479suc from z0e479 where z0e478nro = a.cnl001usu and ROWNUM =1)) s9121,
          'AGENCIA' s9127,
          'N' s9128,2 s9141,'N' s9152,'N' s9155
     from cnl001 a  
    where a.cnl001ucf = pd_fecpro;
   commit;    
end sp_op_SolIntBan;

procedure sp_op_SolTarDeb(pd_FecPro in date) is
   -- *****************************************************************
   -- Nombre                     : sp_op_SolTarDeb
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 28/09/2018
   -- Autor de Creación          : WCRW
   -- Uso                        : Registro 920 Solicitud Tarjeta Debito
   -- Estado                     : Activo
   -- Fecha Modificación         :
   -- Autor de Modificación      :
   -- Descripcion Modificacion   :
   -- *****************************************************************
begin
   delete jaql819a;
   commit;
   insert into jaql819a (jaql819a9000,jaql819a9001,jaql819a9002,jaql819a9017,jaql819a9131,
                         jaql819a9122,jaql819a9123,jaql819a9119,jaql819a9010,jaql819a9126,
                         jaql819a9018,jaql819a9019,jaql819a9020,jaql819a9021,jaql819a9022,
                         jaql819a9023,jaql819a9024,jaql819a9025,jaql819a9026,jaql819a9027,
                         jaql819a9028,jaql819a9029,jaql819a9030,jaql819a9031,jaql819a9032,
                         jaql819a9033,jaql819a9034,jaql819a9035,jaql819a9036,jaql819a9037,
                         jaql819a9038,jaql819a9039,jaql819a9040,jaql819a9041,jaql819a9152,
                         jaql819a9155,jaql819a9067,jaql819antar)
   select lpad(lpad(to_char(a.z0e478thp),3,'0')||lpad(to_char(a.z0e478tht),2,'0')||trim(a.z0e478thd),18,'0') s9000,
          lpad(to_char(a.z0e478tht),3,'0') s9001,trim(a.z0e478thd) s9002,a.z0e478nom s9017,to_number(substr(trim(a.z0e478nro),9,8)) n9131,
          (select to_number(substr(b.z0e483hor,1,2)||substr(b.z0e483hor,4,2)||substr(b.z0e483hor,7,2))
             from z0e483 b where b.z0e483nro = a.z0e478nro and ROWNUM = 1)n9122,
          to_number(to_char(a.z0e478fal,'YYYY')||to_char(a.z0e478fal,'MM')||to_char(a.z0e478fal,'DD'),'99999999') n9123,
          lpad(to_char(a.z0e478suc),15,'0') s9119,a.Z0E478UAU s9010,'' s9126,lpad(to_char(a.z0e478thp),3,'0') s9018,
          '' s9019,'' s9020,0 n9021,'' s9022,
          (select substr(trim(gc_13.sngc13dir),1,50)
             from sngc13 gc_13
            where gc_13.sngc13pais = a.z0e478thp
              and gc_13.sngc13tdoc = a.z0e478tht
              and gc_13.sngc13ndoc = a.z0e478thd
              and gc_13.docod = 1
              and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                         from sngc13 gc_13a
                                        where gc_13a.sngc13pais = a.z0e478thp
                                          and gc_13a.sngc13tdoc = a.z0e478tht
                                          and gc_13a.sngc13ndoc = a.z0e478thd
                                          and gc_13a.sngc13corr < 500
                                          and gc_13a.docod = 1))) s9023,
          (select substr(ubig_01.locnom,1,20)
             from sngc13 gc_13,fst070 ubig_01
            where gc_13.sngc13pais = a.z0e478thp
              and gc_13.sngc13tdoc = a.z0e478tht
              and gc_13.sngc13ndoc = a.z0e478thd
              and gc_13.sngc13prov = ubig_01.loccod
              and gc_13.docod = 1
              and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                         from sngc13 gc_13a
                                        where gc_13a.sngc13pais = a.z0e478thp
                                          and gc_13a.sngc13tdoc = a.z0e478tht
                                          and gc_13a.sngc13ndoc = a.z0e478thd
                                          and gc_13a.sngc13corr < 500
                                          and gc_13a.docod = 1))) s9024,
          0 n9025,
          (select d01.penom
             from fsd001 d01
            where d01.petdoc = 9 
              and d01.pendoc = (select gc_60.sngc60rute
                                  from sngc60 gc_60
                                 where gc_60.sngc60pais = a.z0e478thp
                                   and gc_60.sngc60tdoc = a.z0e478tht
                                   and gc_60.sngc60ndoc = a.z0e478thd
                                   and gc_60.sngc60corr = (select max(gc_60a.sngc60corr)
                                                             from sngc60 gc_60a
                                                            where gc_60a.sngc60pais = a.z0e478thp
                                                              and gc_60a.sngc60tdoc = a.z0e478tht
                                                              and gc_60a.sngc60ndoc = a.z0e478thd))) s9026, 
          (select substr(gc_13.sngc13dir,1,50)
             from sngc13 gc_13
            where gc_13.sngc13pais = a.z0e478thp
              and gc_13.sngc13tdoc = a.z0e478tht
              and gc_13.sngc13ndoc = a.z0e478thd
              and gc_13.docod = 4
              and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                         from sngc13 gc_13a
                                        where gc_13a.sngc13pais = a.z0e478thp
                                          and gc_13a.sngc13tdoc = a.z0e478tht
                                          and gc_13a.sngc13ndoc = a.z0e478thd
                                          and gc_13a.docod = 4))) s9027,
          (select substr(c07.sngc07dsc,1,20)
             from SNGC07 c07
            where c07.sngc07cod = (select gc_60.sngc60ocup
                                     from sngc60 gc_60
                                    where gc_60.sngc60pais = a.z0e478thp
                                      and gc_60.sngc60tdoc = a.z0e478tht
                                      and gc_60.sngc60ndoc = a.z0e478thd
                                      and gc_60.sngc60corr = (select max(gc_60a.sngc60corr)
                                                                from sngc60 gc_60a
                                                               where gc_60a.sngc60pais = a.z0e478thp
                                                                 and gc_60a.sngc60tdoc = a.z0e478tht
                                                                 and gc_60a.sngc60ndoc = a.z0e478thd))) s9028,
          (select substr(ubig_01.fst071dsc,1,20)
             from sngc13 gc_13,fst071 ubig_01
            where gc_13.sngc13pais = a.z0e478thp
              and gc_13.sngc13tdoc = a.z0e478tht
              and gc_13.sngc13ndoc = a.z0e478thd
              and gc_13.sngc13dist = ubig_01.fst071col
              and gc_13.docod = 4
              and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                         from sngc13 gc_13a
                                        where gc_13a.sngc13pais = a.z0e478thp
                                          and gc_13a.sngc13tdoc = a.z0e478tht
                                          and gc_13a.sngc13ndoc = a.z0e478thd
                                          and gc_13a.docod = 4))) s9029,
          0 n9030,
          replace(substr(PQ_CC_CONSULTAS_BT.BT_Tel_Cli(a.z0e478thp,a.z0e478tht,a.z0e478thd,1),1,12),'-','') s9031,
          replace(substr(PQ_CC_CONSULTAS_BT.BT_Tel_Cli(a.z0e478thp,a.z0e478tht,a.z0e478thd,4),1,12),'-','') s9032,
          replace(substr(PQ_CC_CONSULTAS_BT.BT_Cel_Cli(a.z0e478thp,a.z0e478tht,a.z0e478thd),1,12),'-','') s9033,
          0 n9034, 
          (select lpad(to_char(gc_60.sngc60ocup),5,'0')
             from sngc60 gc_60
            where gc_60.sngc60pais = a.z0e478thp
              and gc_60.sngc60tdoc = a.z0e478tht
              and gc_60.sngc60ndoc = a.z0e478thd
              and gc_60.sngc60corr = (select max(gc_60a.sngc60corr)
                                        from sngc60 gc_60a
                                       where gc_60a.sngc60pais = a.z0e478thp
                                         and gc_60a.sngc60tdoc = a.z0e478tht
                                         and gc_60a.sngc60ndoc = a.z0e478thd)) s9035,
          (select substr(t_009.ecnom,1,1)
             from fst009 t_009
            where t_009.eccod = (select d_002.pfeciv
                                   from fsd002 d_002
                                  where d_002.pfpais = a.z0e478thp
                                    and d_002.pftdoc = a.z0e478tht
                                    and d_002.pfndoc = a.z0e478thd)) s9036,
          (select to_number(to_char(d_002.pffnac,'YYYY')||to_char(d_002.pffnac,'MM')||to_char(d_002.pffnac,'DD'),'99999999')
             from fsd002 d_002
            where d_002.pfpais = a.z0e478thp
              and d_002.pftdoc = a.z0e478tht
              and d_002.pfndoc = a.z0e478thd) s9037,
          (select d_002.pfcant
             from fsd002 d_002
            where d_002.pfpais = a.z0e478thp
              and d_002.pftdoc = a.z0e478tht
              and d_002.pfndoc = a.z0e478thd) s9038,
          (select d_001.penom
             from fsr002 r_002,fsd001 d_001
            where r_002.rppais = d_001.pepais
              and r_002.rptdoc = d_001.petdoc
              and r_002.rpndoc = d_001.pendoc
              and r_002.pepais = a.z0e478thp
              and r_002.petdoc = a.z0e478tht
              and r_002.pendoc = a.z0e478thd
              and r_002.rpccyg = 66
              and rownum = 1) s9039,
          (select to_number(to_char(d_002.pffnac,'YYYY')||to_char(d_002.pffnac,'MM')||to_char(d_002.pffnac,'DD'),'99999999')
             from fsr002 r_002,fsd002 d_002
            where r_002.rppais = d_002.pfpais
              and r_002.rptdoc = d_002.pftdoc
              and r_002.rpndoc = d_002.pfndoc
              and r_002.pepais = a.z0e478thp
              and r_002.petdoc = a.z0e478tht
              and r_002.pendoc = a.z0e478thd
              and r_002.rpccyg = 66
              and rownum = 1) n9040,
          replace(substr(PQ_CC_CONSULTAS_BT.BT_Cel_Cli(a.z0e478thp,a.z0e478tht,(select r_002.rpndoc
                                                                          from fsr002 r_002
                                                                         where r_002.pepais = a.z0e478thp
                                                                           and r_002.petdoc = a.z0e478tht
                                                                           and r_002.pendoc = a.z0e478thd
                                                                           and r_002.rpccyg = 66
                                                                           and rownum = 1)),1,12),'-','') s9041,   
          'N' s9052,'N' s9155,trim(a.z0e478thd) s9067,a.z0e478nro                                                                 
     from z0e478 a
    where a.z0e478fal = pd_fecpro;
    commit;   
    sp_op_ActCtaSolTarDeb; 
end sp_op_SolTarDeb;

procedure sp_op_ActCtaSolTarDeb
   -- *****************************************************************
   -- Nombre                     : sp_op_ActCtaSolTarDeb
   -- Sistema                    : BANTOTAL
   -- Módulo                     : OPERACIONES
   -- Versión                    : 1.0
   -- Fecha de Creación          : 04/06/2018
   -- Autor de Creación          : WCRW
   -- Uso                        : 
   -- Estado                     : Activo
   -- Fecha Modificación         :
   -- Autor de Modificación      :
   -- Descripcion Modificacion   :
   -- *****************************************************************
   is
   ls_numtar char(19);
   ln_Ctl001 number(3);
   ls_numcta varchar(20);
   ld_fecpro date;
   CURSOR Tar
      IS select jaql819antar
           from jaql819a;
   CURSOR Cta (ps_NumTar in char)
      IS select z0e478nro,z0e479cta,z0e479mod,z0e479mon,Z0E479SCt,Z0E479top,Z0E479Ope
           from z0e479
          where z0e478nro = ps_NumTar;
   BEGIN
      ld_fecpro := trunc(sysdate);
      --ld_fecpro := '12/07/2018';
      FOR x IN Tar LOOP
         ls_numtar := x.jaql819antar;
         begin
            ln_Ctl001 := 1;
            FOR y IN Cta(ls_numtar) LOOP
               ls_numcta := '';
               if y.z0e479mod = 21 then
                  ls_numcta := lPad(Trim(to_char(y.z0e479cta)),9,'0') || lPad(Trim(to_char(y.z0e479mod)),3,'0') || lPad(Trim(to_char(y.z0e479mon)),3,'0') || lPad(Trim(to_char(y.Z0E479SCt)),2,'0') || lPad(Trim(to_char(y.Z0E479top)),3,'0');
               else
                  ls_numcta := lPad(Trim(to_char(y.z0e479cta)),9,'0') || lPad(Trim(to_char(y.z0e479mod)),3,'0') || lPad(Trim(to_char(y.z0e479mon)),3,'0') || lPad(Trim(to_char(y.Z0E479ope)),2,'0') || lPad(Trim(to_char(y.Z0E479top)),3,'0');
               end if;      
               if ln_Ctl001 = 1 then
                  update JAQL819a set JAQL819a9132 = ls_numcta
                   where jaql819antar = x.jaql819antar;
                  commit;      
               end if;   
               if ln_Ctl001 = 2 then
                  update JAQL819a set JAQL819a9133 = ls_numcta
                   where jaql819antar = x.jaql819antar;
                  commit;      
               end if;
               if ln_Ctl001 = 3 then
                  update JAQL819a set JAQL819a9134 = ls_numcta
                   where jaql819antar = x.jaql819antar;
                  commit;      
               end if;
               if ln_Ctl001 = 4 then
                  update JAQL819a set JAQL819a9135 = ls_numcta
                   where jaql819antar = x.jaql819antar;
                  commit;      
               end if;
               ln_Ctl001 := ln_Ctl001 + 1;   
            END LOOP;   
         end;   
      end loop;   
end sp_op_ActCtaSolTarDeb;      

end PQ_OP_TRAMONTAR;
/

