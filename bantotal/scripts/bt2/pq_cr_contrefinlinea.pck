create or replace package PQ_CR_CONTREFINLINEA is

  -- Author  : CCERPA
  -- Created : 14/05/2018 04:54:57 p.m.
  -- Purpose :
  ------------------------------------------------------------------
  PROCEDURE sp_cr_instancia116(ln_pais in number ,
                               ln_tipodoc in number,
                               ln_document in varchar2, 
                               ln_respuesta out number,
                               ln_intancia out number);
  ------------------------------------------------------------------
  PROCEDURE sp_cr_verifrefinanciado(ln_Instancia in number,
                                    ln_respuesta out number);
  ------------------------------------------------------------------
  PROCEDURE sp_cr_rccrefinanciado(ln_Instancia in number,
                                ln_respuesta out number);
  ------------------------------------------------------------------                                
end PQ_CR_CONTREFINLINEA;
/

create or replace package body PQ_CR_CONTREFINLINEA is

PROCEDURE sp_cr_instancia116(ln_pais in number ,ln_tipodoc in number,ln_document in varchar2, ln_respuesta out number,ln_intancia out number)is 

ln_empresa       number ;
ln_sucursal      number ;
ln_modulo        number ;
ln_moneda        number ;
ln_papel         number ;
ln_cuenta        number ;
ln_operacion     number ;
ln_suboperacion  number ;
ln_tipooperacion number ;
ln_estado        number ;
lc_pendoc             char(12);

begin
  lc_pendoc       := RPAD(trim(ln_document), 12, ' ');
  begin
      select 
             xwf700.xwfempresa,xwf700.xwfsucursal,xwf700.xwfmodulo,
             xwf700.xwfmoneda,xwf700.xwfpapel,xwf700.xwfcuenta,
             xwf700.xwfoperacion,xwf700.xwfsubope,xwf700.xwftipope,
             xwf700.xwfprcins
              into 
              ln_empresa,ln_sucursal,ln_modulo,ln_moneda,ln_papel,ln_cuenta,ln_operacion,
             ln_suboperacion,ln_tipooperacion,ln_intancia
           
       from xwf700 inner join (
      select fsd016.pgcod,fsd016.itsucd,fsd016.ctnro,fsd016.modulo,fsd016.itoper,
      fsd016.moneda,fsd016.papel,fsd016.ittope,fsd016.itsubo from fsr008 inner join fsd016 
      on fsr008.pgcod=fsd016.pgcod
      and fsr008.ctnro=fsd016.ctnro
      where fsr008.pepais=ln_pais and fsr008.petdoc=ln_tipodoc and fsr008.pendoc=lc_pendoc AND fsr008.cttfir='T' -- variables 
      and fsd016.itnrel=(select max(fsd016.itnrel) from fsr008 inner join fsd016 
      on fsr008.pgcod=fsd016.pgcod
      and fsr008.ctnro=fsd016.ctnro
      where fsr008.pepais=ln_pais and fsr008.petdoc=ln_tipodoc and fsr008.pendoc=lc_pendoc AND fsr008.cttfir='T'-- variables 
      and (fsd016.itmod,fsd016.ittran) in (select fst198.TP1NRO1,fst198.TP1NRO2 from fst198 where fst198.tp1cod=1 and  fst198.TP1COD1=11109 and fst198.tp1corr1=50 and fst198.tp1corr2=10)
      )) fsh
      on xwf700.xwfempresa=fsh.pgcod
      and xwf700.xwfsucursal=fsh.itsucd
      and xwf700.xwfcuenta=fsh.ctnro
      and xwf700.xwfmodulo=fsh.modulo
      and xwf700.xwfoperacion=fsh.itoper
      and xwf700.xwfmoneda=fsh.moneda--101
      and xwf700.xwfpapel=fsh.papel--0-
      and xwf700.xwftipope=fsh.ittope--116
      and xwf700.xwfsubope=fsh.itsubo--0
      where xwf700.xwfcar3='A';
     exception when others then
               begin
              ----------------------------------car3 ='1'
              select xwf700.xwfempresa,xwf700.xwfsucursal,xwf700.xwfmodulo,
                     xwf700.xwfmoneda,xwf700.xwfpapel,xwf700.xwfcuenta,
                     xwf700.xwfoperacion,xwf700.xwfsubope,xwf700.xwftipope,
                     xwf700.xwfprcins
                       into 
                    ln_empresa,ln_sucursal,ln_modulo,ln_moneda,ln_papel,ln_cuenta,ln_operacion,
                   ln_suboperacion,ln_tipooperacion,ln_intancia
                      from xwf700 inner join (
              select fsd016.pgcod,fsd016.itsucd,fsd016.ctnro,fsd016.modulo,fsd016.itoper,
              fsd016.moneda,fsd016.papel,fsd016.ittope,fsd016.itsubo from fsr008 inner join fsd016 
              on fsr008.pgcod=fsd016.pgcod
              and fsr008.ctnro=fsd016.ctnro
              where fsr008.pepais=ln_pais and fsr008.petdoc=ln_tipodoc and fsr008.pendoc=lc_pendoc AND fsr008.cttfir='T'-- variables  
              and fsd016.itnrel=(select max(fsd016.itnrel) from fsr008 inner join fsd016 
              on fsr008.pgcod=fsd016.pgcod
              and fsr008.ctnro=fsd016.ctnro
              where fsr008.pepais=ln_pais and fsr008.petdoc=ln_tipodoc and fsr008.pendoc=lc_pendoc AND fsr008.cttfir='T'-- variables 
              and (fsd016.itmod,fsd016.ittran) in (select fst198.TP1NRO1,fst198.TP1NRO2 from fst198 where fst198.tp1cod=1 and  fst198.TP1COD1=11109 and fst198.tp1corr1=50 and fst198.tp1corr2=10)
              )) fsh
              on xwf700.xwfempresa=fsh.pgcod
              and xwf700.xwfsucursal=fsh.itsucd
              and xwf700.xwfcuenta=fsh.ctnro
              and xwf700.xwfmodulo=fsh.modulo
              and xwf700.xwfoperacion=fsh.itoper
              and xwf700.xwfmoneda=fsh.moneda--101
              and xwf700.xwfpapel=fsh.papel--0-
              and xwf700.xwftipope=fsh.ittope--116
              and xwf700.xwfsubope=fsh.itsubo--0
              where xwf700.xwfcar3='1';
              exception when others then
                ln_intancia:=0;
              end;
   end;
   if ln_intancia>0 then 
        begin

          select count(*)into ln_estado from fsd010 
          where fsd010.pgcod= ln_empresa
          and fsd010.aomod= ln_modulo
          and fsd010.aosuc= ln_sucursal
          and fsd010.aomda= ln_moneda
          and fsd010.aopap=ln_papel
          and fsd010.aocta= ln_cuenta
          and fsd010.aooper= ln_operacion
          and fsd010.aosbop = ln_suboperacion
          and fsd010.aotope= ln_tipooperacion
          and fsd010.aostat=0;
        end;
        if ln_estado>0 then
          ln_respuesta:=1;
        else
          ln_respuesta:=2;
        end if;
   else 
        begin
          ln_respuesta:=3;
        end;
   end if;

end sp_cr_instancia116;
-------------------------------------------------------------------
PROCEDURE sp_cr_verifrefinanciado(ln_Instancia in number,
                                  ln_respuesta out number) is

   cursor lista_Integrantes is
      select distinct (trim(f.pendoc)) documento,
                      f.pepais pais,
                      f.petdoc tipodocumento
       from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia);
    cursor lista_avales is
      select distinct (trim(f.pendoc)) avaldocumento,
                      f.pepais avalpais,
                      f.petdoc avaltipodocumento
       from fsr008 f
       where f.ctnro in (select d.sng003cta
                           from sng003 d
                          where d.sng001inst = ln_Instancia);
                          
    titular_integrante number(1);                                                           
    cont_avales NUMBER(1);    
    lc_nrodoc           char(12);
   begin
     ln_respuesta :=0;
     begin 
      for j in lista_Integrantes  loop
   
     lc_nrodoc := trim(J.DOCUMENTO);
       select count(*) INTO titular_integrante from fsd010 INNER JOIN  fsr008 
       ON (FSD010.AOCTA=FSR008.CTNRO and FSD010.PGCOD = FSR008.PGCOD)         --23/07/2018
          where fsr008.pepais=J.PAIS
            and fsr008.petdoc=J.TIPODOCUMENTO
            and fsr008.pendoc=lc_nrodoc
            and fsr008.cttfir='T'
      --      where fsd010.aocta=cuentas.ctnro
            and fsd010.aostat in (select fst026.cecod from fst026 where fst026.cenom like '%REFINA%') ;
  

          if titular_integrante>0 then
              ln_respuesta:=1;
             exit;
          end if;
      end loop;
     end; 
     if ln_respuesta<=0 then
           begin
            for a in lista_avales loop
                 lc_nrodoc := trim(A.AVALDOCUMENTO);
              select count(*) into cont_avales from fsd010,(
                select fsr008.pgcod, fsr008.ctnro from fsr008     ---23/07/2018
                  where fsr008.pepais=a.avalpais
                  and fsr008.petdoc  =a.avaltipodocumento
                  and fsr008.pendoc  =lc_nrodoc
                  and fsr008.cttfir='T') cuentas
                  where fsd010.pgcod=cuentas.pgcod
                  and fsd010.aocta=cuentas.ctnro                  --23/07/2018
                  and fsd010.aostat in (select fst026.cecod from fst026 where fst026.cenom like '%REFINA%')
                  and rownum=1;
                  
               if cont_avales<>0 then
                 ln_respuesta:=1;
                   exit;
                end if;   
            end loop;
           end;
     end if;
  end sp_cr_verifrefinanciado;

-------------------------------------------------------------------------------
PROCEDURE sp_cr_rccrefinanciado(ln_Instancia in number,
                                ln_respuesta out number) is

   cursor lista_Integrantes is
      select distinct (trim(f.pendoc)) documento,
                      f.pepais pais,
                      f.petdoc tipodocumento
       from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia);
    cursor lista_avales is
      select distinct (trim(f.pendoc)) avaldocumento,
                      f.pepais avalpais,
                      f.petdoc avaltipodocumento
       from fsr008 f
       where f.ctnro in (select d.sng003cta
                           from sng003 d
                          where d.sng001inst = ln_Instancia);
                          
    lc_nrodoc           varchar2(12);
    cod_sbs             VARCHAR2(10) ;
    con_rcctitular      number;
    fecha_inicio        date;
    fecha_fin           date;
    fecha_temp          date;
    ln_contar           number;
   begin
         ln_respuesta:=0;
         select to_date(fst098.tpnro,'DD/MM/YYYY') into fecha_inicio
                   from fst098  where fst098.tpcod=7647 and fst098.tpcorr=12;
                   
         select ADD_MONTHS(to_date(fst098.tpnro,'DD/MM/YYYY'),-6) into fecha_fin
                   from fst098  where fst098.tpcod=7647 and fst098.tpcorr=12;
            begin 
            for j in lista_Integrantes  loop
         
           lc_nrodoc := trim(J.DOCUMENTO);
         if j.tipodocumento<>9 then
            BEGIN
               select cldrcci.c_codsbs into cod_sbs from cldrcci  where cldrcci.c_docide=lc_nrodoc 
               and cldrcci.d_fecpre<=fecha_inicio
               and cldrcci.d_fecpre>fecha_fin
               and rownum=1;
                exception when others then
                      cod_sbs :='0';
            END;
            
             IF cod_sbs <>0 then 
              /* begin
                  SELECT count(CLDRCCS.C_CUENTA) into con_rcctitular FROM CLDRCCS 
                   WHERE CLDRCCS.C_CODSBS =cod_sbs 
                   and CLDRCCS.D_FECPRE<=fecha_inicio
                   and CLDRCCS.D_FECPRE>fecha_fin
                   and substr(cldrccs.c_cuenta,1,4) in (select fst198.tp1nro1 
                   from fst198 where fst198.tp1cod=1 and fst198.Tp1cod1 = 11109 
                   and fst198.tp1corr1=50 and  fst198.tp1corr2=2) and cldrccs.c_codemp<>'00104';--- se agrego
                 if con_rcctitular>0 then 
                   
                   ln_respuesta:=1;
                   exit;
                 end if;
               end;*/
                 ln_contar:=0;--23/07/2018
                 WHILE ln_contar<6
                LOOP

                  begin
                     select ADD_MONTHS(to_date(fst098.tpnro,'DD/MM/YYYY'),-1*ln_contar) into fecha_temp
                     from fst098  where fst098.tpcod=7647 and fst098.tpcorr=12;
                  end;
                                  
                 begin
                    SELECT count(CLDRCCS.C_CUENTA) into con_rcctitular FROM CLDRCCS 
                     WHERE CLDRCCS.C_CODSBS =cod_sbs
                     and CLDRCCS.D_FECPRE=fecha_temp
                     and substr(cldrccs.c_cuenta,1,4) in (select fst198.tp1nro1 
                     from fst198 where fst198.tp1cod=1 and fst198.Tp1cod1 = 11109 
                     and fst198.tp1corr1=50 and  fst198.tp1corr2=2) and cldrccs.c_codemp<>'00104';--- se agrego
                   if con_rcctitular>0 then 
                     
                     ln_respuesta:=1;
                     exit;
                   end if;   
                 end;
                 ln_contar:=ln_contar+1;
                END LOOP;
                    if ln_respuesta=1 then                    
                     exit;
                    end if;     ---23/07/2018                            
             end if;
          else
              BEGIN
                 select cldrcci.c_codsbs into cod_sbs from cldrcci  where cldrcci.c_doctri=lc_nrodoc 
                 and cldrcci.d_fecpre<=fecha_inicio
                 and cldrcci.d_fecpre>fecha_fin
                 and rownum=1;
                  exception when others then
                        cod_sbs :='0';
              END;
              
               IF cod_sbs <>0 then 
                 /*begin
                    SELECT count(CLDRCCS.C_CUENTA) into con_rcctitular FROM CLDRCCS 
                     WHERE CLDRCCS.C_CODSBS =cod_sbs 
                     and CLDRCCS.D_FECPRE<=fecha_inicio
                     and CLDRCCS.D_FECPRE>fecha_fin
                      and cldrccs.c_codemp<>'00104'--- se agrego
                     and substr(cldrccs.c_cuenta,1,4) in (select fst198.tp1nro1 from fst198 where fst198.tp1cod=1 and fst198.Tp1cod1 = 11109 and fst198.tp1corr1=50 and  fst198.tp1corr2=2);
                   if con_rcctitular>0 then 

                     ln_respuesta:=1;
                      exit;
                   end if;
                 end;*/
                  ln_contar:=0;--23/07/2018
                   WHILE ln_contar<6
                  LOOP

                    begin
                       select ADD_MONTHS(to_date(fst098.tpnro,'DD/MM/YYYY'),-1*ln_contar) into fecha_temp
                       from fst098  where fst098.tpcod=7647 and fst098.tpcorr=12;
                    end;
                                    
                   begin
                      SELECT count(CLDRCCS.C_CUENTA) into con_rcctitular FROM CLDRCCS 
                       WHERE CLDRCCS.C_CODSBS =cod_sbs
                       and CLDRCCS.D_FECPRE=fecha_temp
                       and substr(cldrccs.c_cuenta,1,4) in (select fst198.tp1nro1 
                       from fst198 where fst198.tp1cod=1 and fst198.Tp1cod1 = 11109 
                       and fst198.tp1corr1=50 and  fst198.tp1corr2=2) and cldrccs.c_codemp<>'00104';--- se agrego
                     if con_rcctitular>0 then 
                         ln_respuesta:=1;
                       exit;
                     end if;   
                   end;
                     ln_contar:=ln_contar+1;
                  END LOOP;
                      if ln_respuesta=1 then                    
                       exit;
                      end if; --23/07/2018                         
               end if;
          end if;
            end loop;
           end; 	
     begin 
      for a in lista_avales  loop
   
     lc_nrodoc := trim(a.avaldocumento);
           lc_nrodoc := trim(a.avaldocumento);
          if a.avaltipodocumento<>9 then
              BEGIN
                 select cldrcci.c_codsbs into cod_sbs from cldrcci  where cldrcci.c_docide=lc_nrodoc--a.avaldocumento--'10874246'--lc_nrodoc--'10874246' 
               and cldrcci.d_fecpre<=fecha_inicio
               and cldrcci.d_fecpre>fecha_fin
               and rownum=1;
                  exception when others then
                        cod_sbs :='0';
              END;
              
               IF cod_sbs <>0 then 
                 /*begin
                    SELECT count(CLDRCCS.C_CUENTA) into con_rcctitular FROM CLDRCCS 
                     WHERE CLDRCCS.C_CODSBS =cod_sbs 
                     and CLDRCCS.D_FECPRE<=fecha_inicio
                     and CLDRCCS.D_FECPRE> fecha_fin
                      and cldrccs.c_codemp<>'00104'
                     and substr(cldrccs.c_cuenta,1,4) in (select fst198.tp1nro1 from fst198 where fst198.tp1cod=1 and fst198.Tp1cod1 = 11109 and fst198.tp1corr1=50 and  fst198.tp1corr2=2);
                   if con_rcctitular>0 then 
                    
                     ln_respuesta:=1;
                      exit;
                   end if;
                 end;*/
                  ln_contar:=0;--23/07/2018
                   WHILE ln_contar<6
                  LOOP

                    begin
                       select ADD_MONTHS(to_date(fst098.tpnro,'DD/MM/YYYY'),-1*ln_contar) into fecha_temp
                       from fst098  where fst098.tpcod=7647 and fst098.tpcorr=12;
                    end;
                                    
                   begin
                      SELECT count(CLDRCCS.C_CUENTA) into con_rcctitular FROM CLDRCCS 
                       WHERE CLDRCCS.C_CODSBS =cod_sbs
                       and CLDRCCS.D_FECPRE=fecha_temp
                       and substr(cldrccs.c_cuenta,1,4) in (select fst198.tp1nro1 
                       from fst198 where fst198.tp1cod=1 and fst198.Tp1cod1 = 11109 
                       and fst198.tp1corr1=50 and  fst198.tp1corr2=2) and cldrccs.c_codemp<>'00104';--- se agrego
                     if con_rcctitular>0 then 
                         ln_respuesta:=1;
                       exit;
                     end if;   
                   end;
                       ln_contar:=ln_contar+1;                   
                  END LOOP;
                      if ln_respuesta=1 then                    
                       exit;
                      end if;  --23/07/2018   
                                   
              end if;
         else
            BEGIN
                 select cldrcci.c_codsbs into cod_sbs from cldrcci  where cldrcci.c_doctri=lc_nrodoc--a.avaldocumento
                 and cldrcci.d_fecpre<=fecha_inicio
                 and cldrcci.d_fecpre>fecha_fin
                 and rownum=1;
                  exception when others then
                        cod_sbs :='0';
              END;
              
               IF cod_sbs <>0 then 
                /* begin
                    SELECT count(CLDRCCS.C_CUENTA) into con_rcctitular FROM CLDRCCS  WHERE CLDRCCS.C_CODSBS =cod_sbs
                    and CLDRCCS.D_FECPRE<=fecha_inicio
                     and CLDRCCS.D_FECPRE> fecha_fin
                      and cldrccs.c_codemp<>'00104'
                     and substr(cldrccs.c_cuenta,1,4) in (select fst198.tp1nro1 from fst198 where fst198.tp1cod=1 and fst198.Tp1cod1 = 11109 and fst198.tp1corr1=50 and  fst198.tp1corr2=2);
                   if con_rcctitular>0 then 
                     ln_respuesta:=1;
                     exit;
                   end if;
                 end;*/
                       ln_contar:=0;--23/07/2018
                   WHILE ln_contar<6
                  LOOP

                    begin
                       select ADD_MONTHS(to_date(fst098.tpnro,'DD/MM/YYYY'),-1*ln_contar) into fecha_temp
                       from fst098  where fst098.tpcod=7647 and fst098.tpcorr=12;
                    end;
                                    
                   begin
                      SELECT count(CLDRCCS.C_CUENTA) into con_rcctitular FROM CLDRCCS 
                       WHERE CLDRCCS.C_CODSBS =cod_sbs
                       and CLDRCCS.D_FECPRE=fecha_temp
                       and substr(cldrccs.c_cuenta,1,4) in (select fst198.tp1nro1 
                       from fst198 where fst198.tp1cod=1 and fst198.Tp1cod1 = 11109 
                       and fst198.tp1corr1=50 and  fst198.tp1corr2=2) and cldrccs.c_codemp<>'00104';--- se agrego
                     if con_rcctitular>0 then 
                         ln_respuesta:=1;
                       exit;
                     end if;   
                   end;
                       ln_contar:=ln_contar+1;                   
                  END LOOP;
                      if ln_respuesta=1 then                    
                       exit;
                      end if;   --23/07/2018
                                   
              end if;
         end if;
        end loop;
       end; 
    
     
  end sp_cr_rccrefinanciado;

end PQ_CR_CONTREFINLINEA;
/

