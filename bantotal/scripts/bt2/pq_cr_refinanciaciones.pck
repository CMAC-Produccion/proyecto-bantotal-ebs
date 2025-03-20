create or replace package pq_cr_refinanciaciones is


  -- ***************************************************************************************************************************
  -- Nombre                     : Paquete para el Conteo del número de Refinanciaciones valdiad todas las transacciones de Refinanciación
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 18/01/2024
  -- Autor de Creación          : KVALENCIAC
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- *************************************************************************************************************************** 

procedure sp_conteo (        v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_contador out number                            
                             ) ;
Function  fn_refinanciana(   pd_pgcodt in number,
                              pt_hcmod in number,   
                              pt_hsucor in number,  
                              pt_htran in number,   
                              pt_hnrel in number,   
                              pt_hfcon in date,   
                              pt_contadorf in number)
                             return number;                           
end pq_cr_refinanciaciones;
/

create or replace package body pq_cr_refinanciaciones is

procedure sp_conteo(         v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_contador out number
                             ) is    

ld_pgfape date;
ln_Scmod number(3);
ln_Scsuc number(3);
ln_Scmda number(4);
ln_Scpap number(4);
ln_Sccta number(9);
ln_Scoper number(9);
ln_Scsbop number(3);
ln_Sctope number(3);
ld_fecha date;
ln_existe number(2);
ln_PGCOD number(3);
ln_PGCODH number(3);
ln_HCMOD number(3);
ln_HSUCOR number(3);
ln_HTRAN number(3);
ln_HNREL number(4);
ld_HFCON date;
ln_continua number(2);
ln_nrefinancias number(2);
ln_salir number(1);
begin
  select pgfape into ld_pgfape from fst017 where  pgcod=v_pgcod;
  ln_pgcod := v_pgcod  ;
  ln_Scmod := v_Scmod ;
  ln_Scsuc := v_Scsuc ;
  ln_Scmda := v_Scmda ;
  ln_Scpap := v_Scpap ;
  ln_Sccta := v_Sccta ;
  ln_Scoper:= v_Scoper;
  ln_Scsbop:= v_Scsbop;
  ln_Sctope:= v_Sctope;
  ln_contador:=0;
  loop
    ln_existe:=0;
    ld_fecha:=null;
    ln_continua:=0;
    
     begin 
     select  aofval into ld_fecha
      from fsd010 f
     where f.pgcod  = ln_pgcod 
       and f.aomod  = ln_Scmod 
       and f.aosuc  = ln_Scsuc 
       and f.aomda  = ln_Scmda 
       and f.aopap  = ln_Scpap 
       and f.aocta  = ln_Sccta 
       and f.aooper = ln_Scoper
       and f.aosbop = ln_Scsbop
       and f.aotope = ln_Sctope;
      Exception
         when no_data_found then
         ld_fecha:=null;
      end;     
     begin 
          --si encuentra registro viene de una refinanciacón
          select 1,h.PGCOD,h.HCMOD,h.HSUCOR,h.HTRAN,h.HNREL,h.HFCON into ln_existe,ln_PGCODH,ln_HCMOD,ln_HSUCOR,ln_HTRAN,ln_HNREL,ld_HFCON
          from fsh016 h
          inner join fsh015 s on s.pgcod=h.pgcod and s.hcmod=h.hcmod and s.hsucor=h.hsucor and s.htran=h.htran and s.hnrel=h.hnrel and s.hfcon=h.hfcon
          where h.PGCOD = ln_pgcod 
        --  and h.HSUCUR= ln_Scsuc
          and h.HMODUL= ln_Scmod
          and h.HMDA =  ln_Scmda
          and h.HPAP =  ln_Scpap     
          and h.HCTA = ln_Sccta
          and h.HOPER= ln_Scoper
          and h.HSUBOP= ln_Scsbop
          and h.HTOPER= ln_Sctope
          and h.HFCON = ld_fecha
          and ( h.HCMOD,h.HTRAN,h.HCORD) in (select tp1nro1,tp1nro2,tp1imp1 from fst198 where tp1cod1=11172 and tp1corr1=1 and tp1corr2=1 and tp1corr3>0)--se busca en el ordinal donde esta el crédito que muere de la refinanciación
          and s.hccorr=0 --debe estar contabilizado  
          order by h.PGCOD, h.HCTA;
         Exception
          when no_data_found then
             ln_HCMOD:=0;
             ln_HTRAN:=0;
      end;
      if (ln_HCMOD=0 and ln_htran=0) then 
         begin
          select 1,h.PGCOD,h.HCMOD,h.HSUCOR,h.HTRAN,h.HNREL,h.HFCON into ln_continua,ln_PGCODH,ln_HCMOD,ln_HSUCOR,ln_HTRAN,ln_HNREL,ld_HFCON
            from fsh016 h
            inner join fsh015 s on s.pgcod=h.pgcod and s.hcmod=h.hcmod and s.hsucor=h.hsucor and s.htran=h.htran and s.hnrel=h.hnrel and s.hfcon=h.hfcon
          where h.PGCOD = ln_pgcod 
        --    and h.HSUCUR= ln_Scsuc
            and h.HMODUL= ln_Scmod
            and h.HMDA =  ln_Scmda
            and h.HPAP =  ln_Scpap     
            and h.HCTA = ln_Sccta
            and h.HOPER= ln_Scoper
            and h.HSUBOP= ln_Scsbop
            and h.HTOPER= ln_Sctope
            and h.HFCON = ld_fecha
            and ( h.HCMOD,h.HTRAN,h.HCORD) in (select tp1nro1,tp1nro2,tp1imp1 from fst198 where tp1cod1=11172 and tp1corr1=1 and tp1corr2=2 and tp1corr3>0)--se busca en el ordinal donde esta el crédito que muere de la refinanciación
            and s.hccorr=0 --debe estar contabilizado  
            order by h.PGCOD, h.HCTA;
          Exception
          when no_data_found then        
             ln_HCMOD:=0;
             ln_HTRAN:=0;
          end;
      end if;
     if ( ln_HCMOD<>0 and ln_HTRAN<>0 ) then
       if ( ln_existe = 1 ) then
          --viene de una refinanciacion valido si es de n a 1
          begin
              select count(*) into ln_nrefinancias                 
                from fsh016 h
                inner join fst198 f on f.tp1cod=h.pgcod and f.tp1cod1=11172 and f.tp1corr1=1 and f.tp1corr2=1 and f.tp1corr3>0 and f.tp1nro1=h.hcmod and f.tp1nro2=h.htran 
                where h.PGCOD = ln_PGCODH
                and h.hcmod = ln_HCMOD
                and h.hsucor = ln_HSUCOR
                and h.htran = ln_HTRAN
                and h.hnrel = ln_HNREL
                and h.hfcon = ld_HFCON
                and h.hcord = f.tp1imp2;--se busca en el ordinal que muere de la refinanciación 
            Exception
            when no_data_found then
               ln_nrefinancias:=0; 
            end; 
            if ( ln_nrefinancias>1 ) then
                ln_contador:= pq_cr_refinanciaciones.fn_refinanciana(     pd_pgcodt => ln_PGCODH,
                                                                            pt_hcmod   => ln_HCMOD,  
                                                                            pt_hsucor  => ln_HSUCOR, 
                                                                            pt_htran   => ln_HTRAN, 
                                                                            pt_hnrel   => ln_HNREL,
                                                                            pt_hfcon   => ld_HFCON,
                                                                            pt_contadorf =>ln_contador); 
                 ln_salir :=1;
            else
               begin
                  select PGCOD, HSUCUR, HMODUL, HMDA, HPAP, HCTA, HOPER, HSUBOP, HTOPER into 
                    ln_pgcod, ln_Scsuc, ln_Scmod, ln_Scmda, ln_Scpap, ln_Sccta, ln_Scoper, ln_Scsbop, ln_Sctope
                    from fsh016 h
                    inner join fst198 f on f.tp1cod=h.pgcod and f.tp1cod1=11172 and f.tp1corr1=1 and f.tp1corr2=1 and f.tp1corr3>0 and f.tp1nro1=h.hcmod and f.tp1nro2=h.htran 
                    where h.PGCOD = ln_PGCODH
                    and h.hcmod = ln_HCMOD
                    and h.hsucor = ln_HSUCOR
                    and h.htran = ln_HTRAN
                    and h.hnrel = ln_HNREL
                    and h.hfcon = ld_HFCON
                    and h.hcord = f.tp1imp2;--se busca en el ordinal que muere de la refinanciación 
                Exception
                when no_data_found then
                   ln_Sccta:=0; 
                end; 
             end if;
          end if;
          if (ln_continua=1) then
             begin
              select PGCOD, HSUCUR, HMODUL, HMDA, HPAP, HCTA, HOPER, HSUBOP, HTOPER into 
                ln_pgcod, ln_Scsuc, ln_Scmod, ln_Scmda, ln_Scpap, ln_Sccta, ln_Scoper, ln_Scsbop, ln_Sctope
                from fsh016 h
                inner join fst198 f on f.tp1cod=h.pgcod and f.tp1cod1=11172 and f.tp1corr1=1 and f.tp1corr2=2 and f.tp1corr3>0 and f.tp1nro1=h.hcmod and f.tp1nro2=h.htran 
                where h.PGCOD = ln_PGCODH
                and h.hcmod = ln_HCMOD
                and h.hsucor = ln_HSUCOR
                and h.htran = ln_HTRAN
                and h.hnrel = ln_HNREL
                and h.hfcon = ld_HFCON
                and h.hcord = f.tp1imp2;--se busca en el ordinal que muere de la refinanciación 
            Exception
            when no_data_found then
               ln_Sccta:=0; 
            end; 
          end if;
      end if;         
      if (ln_existe = 1) then
       ln_contador:= ln_contador+1; 
       if ln_salir=1 then
         ln_continua:=0; 
       else
         ln_continua:=1; 
       end if;
     end if;
   EXIT WHEN ln_continua =0;
   end loop;
end sp_conteo;

Function fn_refinanciana(     pd_pgcodt in number,
                               pt_hcmod in number,   
                               pt_hsucor in number,  
                               pt_htran in number,   
                               pt_hnrel in number,   
                               pt_hfcon in date,   
                               pt_contadorf in number)
                             return number
is
cursor listado is
select h.PGCOD, h.HMODUL, h.HSUCUR, h.HMDA, h.HPAP, h.HCTA , h.HOPER, h.HSUBOP, h.HTOPER
          from fsh016 h
          inner join fsh015 s on s.pgcod=h.pgcod and s.hcmod=h.hcmod and s.hsucor=h.hsucor and s.htran=h.htran and s.hnrel=h.hnrel and s.hfcon=h.hfcon
          inner join fst198 f on f.tp1cod=h.pgcod and f.tp1cod1=11172 and f.tp1corr1=1 and f.tp1corr2=1 and f.tp1corr3>0 and f.tp1nro1=h.hcmod and f.tp1nro2=h.htran 
          where h.pgcod = pd_pgcodt 
            and h.hcmod = pt_hcmod 
            and h.hsucor= pt_hsucor
            and h.htran = pt_htran 
            and h.hnrel = pt_hnrel 
            and h.hfcon = pt_hfcon 
            and s.hccorr=0 --debe estar contabilizado 
            and h.hcord = f.tp1imp2--se busca en el ordinal que muere de la refinanciación  
            order by h.PGCOD, h.HCTA;
         
ln_contadorf number(2);
ln_maxcontador number(2);
ln_continuaf number(2);
ln_Scmodf number(3);
ln_Scsucf number(3);
ln_Scmdaf number(4);
ln_Scpapf number(4);
ln_Scctaf number(9);
ln_Scoperf number(9);
ln_Scsbopf number(3);
ln_Sctopef number(3);
ld_fechaf date;
ln_existef number(2);
ln_PGCODf number(3);
ln_PGCODHf number(3);
ln_HCMODf number(3);
ln_HSUCORf number(3);
ln_HTRANf number(3);
ln_HNRELf number(4);
ld_HFCONf date;
ln_nrefinanciasf number(4);
ln_salir number(1):=0;
begin
  ln_maxcontador:=0;
  FOR c in listado LOOP
    ln_contadorf:=pt_contadorf;
    ln_pgcodf   := c.PGCOD ;
    ln_Scsucf   := c.HSUCUR ;
    ln_Scmodf   := c.HMODUL;
    ln_Scmdaf   := c.HMDA;
    ln_Scpapf   := c.HPAP;
    ln_Scctaf   := c.HCTA;
    ln_Scoperf  :=c.HOPER ;
    ln_Scsbopf  :=c.HSUBOP ;
    ln_Sctopef  :=c.HTOPER;
    LOOP
    ln_existef:=0;
    ld_fechaf:=null;
    ln_continuaf:=0;
     begin 
     select  aofval into ld_fechaf
      from fsd010 f
     where f.pgcod  = ln_pgcodf 
       and f.aomod  = ln_Scmodf 
       and f.aosuc  = ln_Scsucf   
       and f.aomda  = ln_Scmdaf 
       and f.aopap  = ln_Scpapf 
       and f.aocta  = ln_Scctaf 
       and f.aooper = ln_Scoperf
       and f.aosbop = ln_Scsbopf
       and f.aotope = ln_Sctopef;
      Exception       
         when no_data_found then
         ld_fechaf:=null;
      end;
      begin 
          --si encuentra registro viene de una refinanciacón
          select 1,h.PGCOD,h.HCMOD,h.HSUCOR,h.HTRAN,h.HNREL,h.HFCON into ln_existef,ln_PGCODHf,ln_HCMODf,ln_HSUCORf,ln_HTRANf,ln_HNRELf,ld_HFCONf
          from fsh016 h
          inner join fsh015 s on s.pgcod=h.pgcod and s.hcmod=h.hcmod and s.hsucor=h.hsucor and s.htran=h.htran and s.hnrel=h.hnrel and s.hfcon=h.hfcon
          where h.PGCOD = ln_pgcodf 
         -- and h.HSUCUR=  ln_Scsucf
          and h.HMODUL  = ln_Scmodf  
          and h.HMDA   =  ln_Scmdaf 
          and h.HPAP   =  ln_Scpapf 
          and h.HCTA   =  ln_Scctaf 
          and h.HOPER   = ln_Scoperf
          and h.HSUBOP  = ln_Scsbopf
          and h.HTOPER  = ln_Sctopef
          and h.HFCON   = ld_fechaf
          and ( h.HCMOD,h.HTRAN,h.HCORD) in (select tp1nro1,tp1nro2,tp1imp1 from fst198 where tp1cod1=11172 and tp1corr1=1 and tp1corr2=1 and tp1corr3>0)--se busca en el ordinal donde esta el crédito que muere de la refinanciación
          and s.hccorr=0 --debe estar contabilizado  
          order by h.PGCOD, h.HCTA;
         Exception
          when no_data_found then
             ln_HCMODf:=0;
             ln_HTRANf:=0;
      end;
      if (ln_HCMODf=0 and ln_htranf=0) then 
         begin
          select 1,h.PGCOD,h.HCMOD,h.HSUCOR,h.HTRAN,h.HNREL,h.HFCON into ln_continuaf,ln_PGCODHf,ln_HCMODf,ln_HSUCORf,ln_HTRANf,ln_HNRELf,ld_HFCONf
            from fsh016 h
            inner join fsh015 s on s.pgcod=h.pgcod and s.hcmod=h.hcmod and s.hsucor=h.hsucor and s.htran=h.htran and s.hnrel=h.hnrel and s.hfcon=h.hfcon
          where h.PGCOD   = ln_pgcodf 
             -- and h.HSUCUR=  ln_Scsucf
              and h.HMODUL= ln_Scmodf 
              and h.HMDA =  ln_Scmdaf 
              and h.HPAP =  ln_Scpapf     
              and h.HCTA  = ln_Scctaf 
              and h.HOPER = ln_Scoperf
              and h.HSUBOP= ln_Scsbopf
              and h.HTOPER= ln_Sctopef
              and h.HFCON = ld_fechaf
            and ( h.HCMOD,h.HTRAN,h.HCORD) in (select tp1nro1,tp1nro2,tp1imp1 from fst198 where tp1cod1=11172 and tp1corr1=1 and tp1corr2=2 and tp1corr3>0)--se busca en el ordinal donde esta el crédito que muere de la refinanciación
            and s.hccorr=0 --debe estar contabilizado  
            order by h.PGCOD, h.HCTA;
          Exception
          when no_data_found then        
             ln_HCMODf:=0;
             ln_HTRANf:=0;
          end;
      end if;            
     if ( ln_HCMODf<>0 and ln_HTRANf<>0 ) then
       if ( ln_existef = 1 ) then
          --viene de una refinanciacion valido si es de n a 1
          begin
              select count(*) into ln_nrefinanciasf                 
                from fsh016 h
                inner join fst198 f on f.tp1cod=h.pgcod and f.tp1cod1=11172 and f.tp1corr1=1 and f.tp1corr2=1 and f.tp1corr3>0 and f.tp1nro1=h.hcmod and f.tp1nro2=h.htran 
                where h.PGCOD = ln_PGCODHf
                and h.hcmod = ln_HCMODf
                and h.hsucor = ln_HSUCORf
                and h.htran = ln_HTRANf
                and h.hnrel = ln_HNRELf
                and h.hfcon = ld_HFCONf
                and h.hcord = f.tp1imp2;--se busca en el ordinal que muere de la refinanciación 
            Exception
            when no_data_found then
               ln_nrefinanciasf:=0; 
            end; 
            if ( ln_nrefinanciasf>1 ) then
               /* ln_contadorf:= pq_cr_refinanciaciones2.fn_refinanciana1(    pd_pgcodt => ln_PGCODHf,
                                                                            pt_hcmod   => ln_HCMODf,  
                                                                            pt_hsucor  => ln_HSUCORf, 
                                                                            pt_htran   => ln_HTRANf, 
                                                                            pt_hnrel   => ln_HNRELf,
                                                                            pt_hfcon   => ld_HFCONf,
                                                                            pt_contador =>ln_contadorf ); */
                 ln_salir :=1;
             else
               begin
                  select PGCOD, HSUCUR, HMODUL, HMDA, HPAP, HCTA, HOPER, HSUBOP, HTOPER into 
                    ln_pgcodf, ln_Scsucf, ln_Scmodf, ln_Scmdaf, ln_Scpapf, ln_Scctaf, ln_Scoperf, ln_Scsbopf, ln_Sctopef
                    from fsh016 h
                    inner join fst198 f on f.tp1cod=h.pgcod and f.tp1cod1=11172 and f.tp1corr1=1 and f.tp1corr2=1 and f.tp1corr3>0 and f.tp1nro1=h.hcmod and f.tp1nro2=h.htran 
                    where h.PGCOD = ln_PGCODHf
                    and h.hcmod = ln_HCMODf
                    and h.hsucor = ln_HSUCORf
                    and h.htran = ln_HTRANf
                    and h.hnrel = ln_HNRELf
                    and h.hfcon = ld_HFCONf
                    and h.hcord = f.tp1imp2;--se busca en el ordinal que muere de la refinanciación 
                Exception
                when no_data_found then
                   ln_Scctaf:=0; 
                end; 
             end if;
       end if;
       if (ln_continuaf=1) then
             begin
              select PGCOD, HSUCUR, HMODUL, HMDA, HPAP, HCTA, HOPER, HSUBOP, HTOPER into 
                ln_pgcodf, ln_Scsucf, ln_Scmodf, ln_Scmdaf, ln_Scpapf, ln_Scctaf, ln_Scoperf, ln_Scsbopf, ln_Sctopef
                from fsh016 h
                inner join fst198 f on f.tp1cod=h.pgcod and f.tp1cod1=11172 and f.tp1corr1=1 and f.tp1corr2=2 and f.tp1corr3>0 and f.tp1nro1=h.hcmod and f.tp1nro2=h.htran 
                where h.PGCOD = ln_PGCODHf
                and h.hcmod = ln_HCMODf
                and h.hsucor = ln_HSUCORf
                and h.htran = ln_HTRANf
                and h.hnrel = ln_HNRELf
                and h.hfcon = ld_HFCONf
                and h.hcord = f.tp1imp2;--se busca en el ordinal que muere de la refinanciación 
            Exception
            when no_data_found then
               ln_Scctaf:=0; 
            end; 
          end if;
      end if;       
      if (ln_existef = 1) then
       ln_contadorf:= ln_contadorf+1;
       if ln_salir=1 then
         ln_continuaf:=0; 
       else
         ln_continuaf:=1; 
       end if;
      end if;
      EXIT WHEN ln_continuaf =0;
     end loop;
     if (ln_contadorf>ln_maxcontador) then
        ln_maxcontador := ln_contadorf;
     end if;     
   END LOOP;
  return ln_maxcontador;
end fn_refinanciana ;

end pq_cr_refinanciaciones;
/

