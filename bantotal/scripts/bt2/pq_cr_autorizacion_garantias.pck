create or replace package pQ_CR_AUTORIZACION_GARANTIAS is

  -- Author  : CCERPA
  -- Created : 23/05/2017 03:16:22 p.m.
  -- Purpose :

  procedure sp_cr_contarRegitros(ln_instancia in numeric,
                              ln_numeroregistro out numeric,
                              ln_numeroexistente out numeric);

  procedure sp_cr_grabarjaqz715(ln_instancia in number,
                              ld_fecha in date,
                              lv_usuario in varchar,
                              ln_aviso out number);
  procedure   sp_cr_updatejaqz715  (ln_instancia in number,
                              ld_fecha in date,--fecha  de la vista
                              lv_usuario in varchar,
                              ln_estado out number);

 procedure   sp_cr_eliminarjaqz715 (ln_instancia in number );

     procedure   sp_cr_deshabiliarjaqz715 (ln_instancia in number,
                                          lv_descripcion in varchar,
                                          lv_usuario in varchar);
end pQ_CR_AUTORIZACION_GARANTIAS;
/

create or replace package body pQ_CR_AUTORIZACION_GARANTIAS is



  --------------------------------------------------------------------------------
  procedure sp_cr_contarRegitros(ln_instancia in numeric,
                              ln_numeroregistro out numeric,
                              ln_numeroexistente out numeric) is
BEGIN
  select count(*)into ln_numeroexistente  from wfwrkitems x where  x.wfinsprcid=ln_instancia;
select count(*)into ln_numeroregistro from wfwrkitems x where x.wfitemstsact=1 and x.wfinsprcid=ln_instancia;
--select count(*) into ln_numeroregistro from xwf700 x where x.xwfprcins = ln_instancia  and  XWFCar3 = '1'  ;
--select count(*) into ln_numeroexistente from xwf070  where xwfprcin= ln_instancia And XWFCont='S';

  end sp_cr_contarRegitros;
  ---------------------------------------------------------------------------------


  procedure sp_cr_grabarjaqz715(ln_instancia in number,
                              ld_fecha in date,
                              lv_usuario in varchar,
                              ln_aviso out number) is
                     
 ln_verif number(8,0);
BEGIN
  begin
    select ja.jaqz715inst
   INTO ln_verif
      from jaqz715 JA
     WHERE JA.JAQZ715INST = ln_instancia
     and ja.jaqz715activo=1
     and ja.jaqz715estado='N'
       for update of ja.jaqz715inst;
  exception     
  When
  others then null;
 
  if ln_verif IS null THEN
    INSERT INTO jaqz715 (JAQZ715INST,
                         JAQZ715ACTIVO,
                         JAQZ715FECVIGAUTO,
                         JAQZ715DESC,
                         JAQZ715ESTADO,
                         JAQZ715USUR,
                         JAQZ715FECHAHORA,
                         JAQZ715FECHAMOD,
                         JAQZ715USURMOD)
                          values
                          (ln_instancia,
                          1,
                          ld_fecha,
                          '',
                          'N',
                         '',
                          (select TO_TIMESTAMP(CONCAT(to_char((select pgfape from fst017 where pgcod=1),'DD/MM/YYYY '),to_char(systimestamp,'HH24:MI:SS')),'DD/MM/YYYY HH24:MI:SS') from dual),
                          NULL,
                         NULL
                          );

   --COMMIT;

    Insert INTO jaqz714 (
                        JAQZ714INST,
                         JAQZ714CORR,
                         JAQZ714PGC,
                         JAQZ714MOD,
                         JAQZ714SUC,
                         JAQZ714MDA,
                         JAQZ714PAP,
                         JAQZ714CTA,
                         JAQZ714OPER,
                         JAQZ714SBOP,
                         JAQZ714TOPE,
                         JAQZ714PRI,
                         JAQZ714EST,
                         JAQZ714FECH,
                         JAQZ714COD,
                         JAQZ714MONT)
      select
                        sn.sng122inst,
                        sn.sng122corr,
                        sn.sng122pgc,
                        sn.sng122mod,
                        sn.sng122suc,
                        sn.sng122mda,
                        sn.sng122pap,
                        sn.sng122cta,
                        sn.sng122oper,
                        sn.sng122sbop,
                        sn.sng122tope,
                        sn.sng122pri,
                        0,
                        (select pgfape from fst017 where pgcod=1),
                        (select j.jaqz715cod from jaqz715 j where j.jaqz715inst=ln_instancia and j.jaqz715estado='N' and j.jaqz715activo=1),
                        sn.sng122sdog

      from sng122 sn
          inner join ppg000 pp
          on sn.sng122pgc = pp.ppg000pgc
          and sn.sng122mod=pp.ppg000mod
          and sn.sng122suc=pp.ppg000suc
          and sn.sng122mda=pp.ppg000mda
          and sn.sng122pap=pp.ppg000pap
          and sn.sng122cta=pp.ppg000cta
          and sn.sng122oper=pp.ppg000ope
          and sn.sng122sbop=pp.ppg000sbo
          and sn.sng122tope=pp.ppg000top
          and pp.ppg000tco='S'
                    where sng122Inst=ln_instancia
                    and  sng122Mod=70 ;
                      ln_aviso:=1;
   insert into jaqz718 (jaqz718cta,jaqz718oper,jaqz718desc,JAQZ718FEC,JAQZ718DEST) values (ln_aviso,ln_instancia,lv_usuario,(select TO_TIMESTAMP(to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF'),'DD/MM/YYYY HH24:MI:SS.FF') from dual),'GRABAR'); 
  
            commit;
                

  END IF;
  
  end;
 IF  ln_verif IS NOT  NULL THEN  
   ln_aviso :=0;
   insert into jaqz718 (jaqz718cta,jaqz718oper,jaqz718desc,JAQZ718FEC,JAQZ718DEST) values (ln_aviso,ln_instancia,lv_usuario,(select TO_TIMESTAMP(to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF'),'DD/MM/YYYY HH24:MI:SS.FF') from dual),'GRABAR'); 
         commit;
  
   END IF;
end sp_cr_grabarjaqz715;

  ---------------------------------------------------------------------------------
  procedure   sp_cr_updatejaqz715  (ln_instancia in number,
                              ld_fecha in date,--fecha  de la vista
                              lv_usuario in varchar,
                              ln_estado out number) is
 ln_verif number(8,0);
BEGIN
   BEGIN 
 select jaqz715inst into ln_verif from jaqz715 ja  where ja.jaqz715inst=ln_instancia
 and ja.jaqz715estado='S' and JA.JAQZ715ACTIVO=1
 FOR UPDATE OF ja.jaqz715inst;

 EXCEPTION  WHEN OTHERS THEN NULL;
if ln_verif is null then
     update jaqz714 ja1

        set
        ja1.jaqz714est=1

         where ja1.jaqz714cod=(select j5.jaqz715cod from jaqz715 j5  where j5.jaqz715inst=ln_instancia and j5.jaqz715activo=1 and j5.jaqz715estado='N')

        and ja1.jaqz714est=0;
      update jaqz715 ja
      set ja.jaqz715estado='S',
          ja.jaqz715fechahora=(select TO_TIMESTAMP(CONCAT(to_char((select pgfape from fst017 where pgcod=1),'DD/MM/YYYY '),to_char(systimestamp,'HH24:MI:SS')),'DD/MM/YYYY HH24:MI:SS') from dual),
          ja.jaqz715usur=lv_usuario,
          ja.jaqz715fecvigauto=ld_fecha




      where ja.jaqz715inst=ln_instancia and ja.jaqz715activo=1 and ja.jaqz715estado='N'  ;
           ln_estado :=1;
   insert into jaqz718 (jaqz718cta,jaqz718oper,jaqz718desc,JAQZ718FEC,JAQZ718DEST) values (ln_estado,ln_instancia,lv_usuario,(select TO_TIMESTAMP(to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF'),'DD/MM/YYYY HH24:MI:SS.FF') from dual),'AUTORIZAR'); 
     commit;

end if ;
  END;
  if ln_verif is not null then
     ln_estado :=0;    
        insert into jaqz718 (jaqz718cta,jaqz718oper,jaqz718desc,JAQZ718FEC,JAQZ718DEST) values (ln_estado,ln_instancia,lv_usuario,(select TO_TIMESTAMP(to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF'),'DD/MM/YYYY HH24:MI:SS.FF') from dual),'AUTORIZAR'); 
        COMMIT;
  end if;
  end   sp_cr_updatejaqz715  ;

    ---------------------------------------------------------------------------------

    procedure   sp_cr_eliminarjaqz715 (ln_instancia in number ) is

BEGIN
  delete jaqz714 ja  where  ja.jaqz714inst=ln_instancia and ja.jaqz714cod=(select jaq.jaqz715cod from jaqz715 jaq where jaq.jaqz715inst=ln_instancia and jaq.jaqz715activo=1 and jaq.jaqz715estado='N');
  delete jaqz715  jaqz where jaqz.jaqz715activo=1 and jaqz.jaqz715estado='N' and jaqz.jaqz715inst=ln_instancia;

COMMIT;


  end   Sp_cr_eliminarjaqz715 ;

      ---------------------------------------------------------------------------------


    procedure   sp_cr_deshabiliarjaqz715 (ln_instancia in number,
                                          lv_descripcion in varchar,
                                          lv_usuario in varchar) is

BEGIN
  update  jaqz714 ja
  set ja.jaqz714est=0

  where ja.jaqz714inst=ln_instancia and ja.jaqz714cod=(select jaqz.jaqz715cod from jaqz715 jaqz where jaqz.jaqz715inst=ln_instancia and jaqz.jaqz715estado='S' and jaqz.jaqz715activo=1 );

update jaqz715 jz
  set jz.jaqz715desc=lv_descripcion,
  jz.jaqz715estado='N',
  jz.jaqz715activo='0',
      jz.jaqz715fechamod=(select TO_TIMESTAMP(CONCAT(to_char((select pgfape from fst017 where pgcod=1),'DD/MM/YYYY '),to_char(systimestamp,'HH24:MI:SS')),'DD/MM/YYYY HH24:MI:SS') from dual),
      jz.jaqz715usurmod=lv_usuario

  where jz.jaqz715inst=ln_instancia and jz.jaqz715estado='S' and jz.jaqz715activo=1 ;
COMMIT;


  end   sp_cr_deshabiliarjaqz715;


      ---------------------------------------------------------------------------------

end pQ_CR_AUTORIZACION_GARANTIAS;
/

