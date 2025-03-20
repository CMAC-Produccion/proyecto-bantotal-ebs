create or replace package PQ_CR_INTERES_PUNITORIO is
 
    -- *****************************************************************
    -- Nombre                     : SALDOS COMPARATIVOS DE CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.01.03
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER SALDOS COMPARATIVOS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  type tp_intpun is table of varchar2(30) index by binary_integer;
  type tp_fecpun is table of date index by binary_integer;
   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure SP_CR_INSERTA_JAQL961_I( pn_pgcod in number, 
              pn_itsuc in number, 
              pn_itmod in number, 
              pn_ittran in number, 
              pn_itnrel in number, 
              pn_itord in number, 
              pn_itsbor in number, 
              pn_modulo in number, 
              pn_ittope in number, 
              pn_itsucd in number, 
              pn_rubro in number, 
              pn_moneda in number, 
              pn_papel in number, 
              pn_ctnro in number, 
              pn_itoper in number, 
              pn_itsubo in number, 
              pn_itfval in date, 
              pn_itfvto in date, 
              pn_itpzo in number, 
              pn_itper in number, 
              pn_itttas in number, 
              pn_ittasa in number, 
              pn_ittmor in number, 
              pn_ittdia in number, 
              pn_ittvto in character,
              pn_ittano in number, 
              pn_ittint in character, 
              pn_itarb in number, 
              pn_itarb1 in number, 
              pn_itmd in character, 
              pn_itmd1 in character, 
              pn_ittcbi in number, 
              pn_ittcbi1 in number, 
              pn_itpre in number, 
              pn_itpre1 in number, 
              pn_itdrev in number, 
              pn_itafiv in character, 
              pn_itafgt in character, 
              pn_itplus in number, 
              pn_itcodm in number, 
              pn_itser in character, 
              pn_itcheq in number, 
              pn_itimp1 in number, 
              pn_itimp2 in number, 
              pn_itimp3 in number, 
              pn_itimp4 in number, 
              pn_itimp5 in number, 
              pn_itimp6 in number, 
              pn_itimp7 in number, 
              pn_itimp8 in number, 
              pn_itimp9 in number, 
              pn_itimp10 in number, 
              pn_itimp11 in number, 
              pn_itimp12 in number, 
              pn_itimp13 in number, 
              pn_itimp14 in number, 
              pn_itimp15 in number, 
              pn_itimp16 in number, 
              pn_itimp17 in number, 
              pn_itimp18 in number, 
              pn_itimp19 in number, 
              pn_itimp20 in number, 
              pn_itimpo in number, 
              pn_itmdao in number, 
              pn_itdbha in number, 
              pn_itncor in number, 
              pn_itbbtt in character, 
              pn_itfunc in number, 
              pn_itsegm in number, 
              pn_itccos in number, 
              pn_itcbcu in number, 
              pn_itccli in number, 
              pn_itref in character, 
              pn_itanu in character, 
              pn_itposic in number, 
              pn_itvalua in number, 
              pn_itcltcod in number, 
              pn_itpza in number, 
              pn_itdcom  in number
              ) ;   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_INSERTA_JAQL961( pn_pgcod in number, 
              pn_itsuc in number, 
              pn_itmod in number, 
              pn_ittran in number, 
              pn_itnrel in number, 
              pn_itord in number, 
              pn_itsbor in number, 
              /*pn_ctnro in number, 
              pn_itoper in number, */
              pn_ordinal1 in number,
              pn_ordinal2 in number,
              pn_ordinal3 in number,
              pn_ordinal4 in number,
              pn_ordinal5 in number,
              pc_indicador out varchar2
              );              
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_RETORNA_INTERES( 
              pn_pgcod in number, 
              pn_itsuc in number, 
              pn_itmod in number, 
              pn_ittran in number, 
              pn_itnrel in number, 
              pd_fecha in date, 
              pn_interes out number
              );
              
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_RETORNA_INTERESES( 
              pn_pgcod in number, 
              pn_itsuc in number, 
              pn_itmod in number, 
              pn_ittran in number, 
              pn_itnrel in number, 
              pd_fecha in date, 
              pd_fecpag in date, 
              pn_interes out number, 
              pn_totpun out number,              
         /*     pn_interes out PQ_CR_INTERES_PUNITORIO.tp_intpun,
              pd_fecpag out PQ_CR_INTERES_PUNITORIO.tp_fecpun,
          */    pn_numcon out number
              );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_CALCULA_MORA( 
              pd_fecvto in date,  --fecha vencimiento cuota
              pd_fecpag in date,  --fecha pago
              pn_tasa in number, 
              pn_capital in number, 
              pn_base in number,  --360/365 dias
              pn_mora out number
              );              
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_INTERES_PUNITORIO;
/

create or replace package body PQ_CR_INTERES_PUNITORIO is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_INTERES_PUNITORIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.12.31
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS PARA REPORTE VARIACION DE SALDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.08.06
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: sp_cr_carga_datos, sp_cr_carga_datos_ini
   -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_INSERTA_JAQL961_I( pn_pgcod in number, 
              pn_itsuc in number, 
              pn_itmod in number, 
              pn_ittran in number, 
              pn_itnrel in number, 
              pn_itord in number, 
              pn_itsbor in number, 
              pn_modulo in number, 
              pn_ittope in number, 
              pn_itsucd in number, 
              pn_rubro in number, 
              pn_moneda in number, 
              pn_papel in number, 
              pn_ctnro in number, 
              pn_itoper in number, 
              pn_itsubo in number, 
              pn_itfval in date, 
              pn_itfvto in date, 
              pn_itpzo in number, 
              pn_itper in number, 
              pn_itttas in number, 
              pn_ittasa in number, 
              pn_ittmor in number, 
              pn_ittdia in number, 
              pn_ittvto in character, 
              pn_ittano in number, 
              pn_ittint in character, 
              pn_itarb in number, 
              pn_itarb1 in number, 
              pn_itmd in character, 
              pn_itmd1 in character, 
              pn_ittcbi in number, 
              pn_ittcbi1 in number, 
              pn_itpre in number, 
              pn_itpre1 in number, 
              pn_itdrev in number, 
              pn_itafiv in character, 
              pn_itafgt in character, 
              pn_itplus in number, 
              pn_itcodm in number, 
              pn_itser in character, 
              pn_itcheq in number, 
              pn_itimp1 in number, 
              pn_itimp2 in number, 
              pn_itimp3 in number, 
              pn_itimp4 in number, 
              pn_itimp5 in number, 
              pn_itimp6 in number, 
              pn_itimp7 in number, 
              pn_itimp8 in number, 
              pn_itimp9 in number, 
              pn_itimp10 in number, 
              pn_itimp11 in number, 
              pn_itimp12 in number, 
              pn_itimp13 in number, 
              pn_itimp14 in number, 
              pn_itimp15 in number, 
              pn_itimp16 in number, 
              pn_itimp17 in number, 
              pn_itimp18 in number, 
              pn_itimp19 in number, 
              pn_itimp20 in number, 
              pn_itimpo in number, 
              pn_itmdao in number, 
              pn_itdbha in number, 
              pn_itncor in number, 
              pn_itbbtt in character, 
              pn_itfunc in number, 
              pn_itsegm in number, 
              pn_itccos in number, 
              pn_itcbcu in number, 
              pn_itccli in number, 
              pn_itref in character, 
              pn_itanu in character, 
              pn_itposic in number, 
              pn_itvalua in number, 
              pn_itcltcod in number, 
              pn_itpza in number, 
              pn_itdcom  in number
                          ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSERTA_JAQL961
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

  
 begin
 
       begin
        insert into JAQL991(
              jaql991pgcod, jaql991suc, jaql991mod, jaql991tran, jaql991nrel, jaql991ord, jaql991sbor, jaql991modul, jaql991tope, jaql991sucd, 
              jaql991rubro, jaql991mda, jaql991pap, jaql991ctnro, jaql991oper, jaql991subo, jaql991fval, jaql991fvto, jaql991pzo, jaql991per, 
              jaql991ttas, jaql991tasa, jaql991tmor, jaql991tdia, jaql991tvto, jaql991tano, jaql991tint, jaql991arb, jaql991arb1, jaql991md, 
              jaql991md1, jaql991tcbi, jaql991tcbi1, jaql991pre, jaql991pre1, jaql991drev, jaql991afiv, jaql991afgt, jaql991plus, jaql991codm, 
              jaql991ser, jaql991cheq, jaql991imp1, jaql991imp2, jaql991imp3, jaql991imp4, jaql991imp5, jaql991imp6, jaql991imp7, jaql991imp8, 
              jaql991imp9, jaql991imp10, jaql991imp11, jaql991imp12, jaql991imp13, jaql991imp14, jaql991imp15, jaql991imp16, jaql991imp17, jaql991imp18, 
              jaql991imp19, jaql991imp20, jaql991impo, jaql991mdao, jaql991dbha, jaql991ncor, jaql991bbtt, jaql991func, jaql991segm, jaql991ccos, 
              jaql991cbcu, jaql991ccli, jaql991ref, jaql991anu, jaql991posic, jaql991valua, jaql991cltco, jaql991pza, jaql991dcom 
              )

        values (
              pn_pgcod, pn_itsuc, pn_itmod, pn_ittran, pn_itnrel, pn_itord, pn_itsbor, pn_modulo, pn_ittope, pn_itsucd, 
              pn_rubro, pn_moneda, pn_papel, pn_ctnro, pn_itoper, pn_itsubo, pn_itfval, pn_itfvto, pn_itpzo, pn_itper, 
              pn_itttas, pn_ittasa, pn_ittmor, pn_ittdia, pn_ittvto, pn_ittano, pn_ittint, pn_itarb, pn_itarb1, pn_itmd, 
              pn_itmd1, pn_ittcbi, pn_ittcbi1, pn_itpre, pn_itpre1, pn_itdrev, pn_itafiv, pn_itafgt, pn_itplus, pn_itcodm, 
              pn_itser, pn_itcheq, pn_itimp1, pn_itimp2, pn_itimp3, pn_itimp4, pn_itimp5, pn_itimp6, pn_itimp7, pn_itimp8, 
              pn_itimp9, pn_itimp10, pn_itimp11, pn_itimp12, pn_itimp13, pn_itimp14, pn_itimp15, pn_itimp16, pn_itimp17, pn_itimp18, 
              pn_itimp19, pn_itimp20, pn_itimpo, pn_itmdao, pn_itdbha, pn_itncor, pn_itbbtt, pn_itfunc, pn_itsegm, pn_itccos, 
              pn_itcbcu, pn_itccli, pn_itref, pn_itanu, pn_itposic, pn_itvalua, pn_itcltcod, pn_itpza, pn_itdcom 
            );
      exception 
         when others then
             null;           
      end;      

   
 end SP_CR_INSERTA_JAQL961_I;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_INSERTA_JAQL961( pn_pgcod in number, 
              pn_itsuc in number, 
              pn_itmod in number, 
              pn_ittran in number, 
              pn_itnrel in number, 
              pn_itord in number, 
              pn_itsbor in number, 
              /*pn_ctnro in number, 
              pn_itoper in number,*/ 
              pn_ordinal1 in number,
              pn_ordinal2 in number,
              pn_ordinal3 in number,
              pn_ordinal4 in number,
              pn_ordinal5 in number,
              pc_indicador out varchar2
                          ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSERTA_JAQL961
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************


   cursor movimiento is 
     select *
       from fsd016
      where Pgcod = pn_pgcod
        and Itsuc = pn_itsuc
        and Itmod = pn_itmod
        and Ittran = pn_ittran
        and Itnrel = pn_itnrel
        and ( itord = pn_ordinal1 or itord = pn_ordinal2 or
              itord = pn_ordinal3 or itord = pn_ordinal4 or
              itord = pn_ordinal5
            );

 ld_fecha date;
      
 begin
 
   for i in movimiento loop
        if i.itord in (10, 50) then
           ld_fecha := i.itfval ;    
        end if;
        
           
        begin
            insert into JAQL991(
                  jaql991pgcod, jaql991suc, jaql991mod, jaql991tran, jaql991nrel, jaql991ord, jaql991sbor, jaql991modul, jaql991tope, jaql991sucd, 
                  jaql991rubro, jaql991mda, jaql991pap, jaql991ctnro, jaql991oper, jaql991subo, jaql991fval, jaql991fvto, jaql991pzo, jaql991per, 
                  jaql991ttas, jaql991tasa, jaql991tmor, jaql991tdia, jaql991tvto, jaql991tano, jaql991tint, jaql991arb, jaql991arb1, jaql991md, 
                  jaql991md1, jaql991tcbi, jaql991tcbi1, jaql991pre, jaql991pre1, jaql991drev, jaql991afiv, jaql991afgt, jaql991plus, jaql991codm, 
                  jaql991ser, jaql991cheq, jaql991imp1, jaql991imp2, jaql991imp3, jaql991imp4, jaql991imp5, jaql991imp6, jaql991imp7, jaql991imp8, 
                  jaql991imp9, jaql991imp10, jaql991imp11, jaql991imp12, jaql991imp13, jaql991imp14, jaql991imp15, jaql991imp16, jaql991imp17, jaql991imp18, 
                  jaql991imp19, jaql991imp20, jaql991impo, jaql991mdao, jaql991dbha, jaql991ncor, jaql991bbtt, jaql991func, jaql991segm, jaql991ccos, 
                  jaql991cbcu, jaql991ccli, jaql991ref, jaql991anu, jaql991posic, jaql991valua, jaql991cltco, jaql991pza, jaql991dcom , jaql991fpro
                  )

            values (
                  i.pgcod, i.itsuc, i.itmod, i.ittran, i.itnrel, i.itord, i.itsbor, i.modulo, i.ittope, i.itsucd, 
                  i.rubro, i.moneda, i.papel, i.ctnro, i.itoper, i.itsubo, i.itfval, i.itfvto, i.itpzo, i.itper, 
                  i.itttas, i.ittasa, i.ittmor, i.ittdia, i.ittvto, i.ittano, i.ittint, i.itarb, i.itarb1, i.itmd, 
                  i.itmd1, i.ittcbi, i.ittcbi1, i.itpre, i.itpre1, i.itdrev, i.itafiv, i.itafgt, i.itplus, i.itcodm, 
                  i.itser, i.itcheq, i.itimp1, i.itimp2, i.itimp3, i.itimp4, i.itimp5, i.itimp6, i.itimp7, i.itimp8, 
                  i.itimp9, i.itimp10, i.itimp11, i.itimp12, i.itimp13, i.itimp14, i.itimp15, i.itimp16, i.itimp17, i.itimp18, 
                  i.itimp19, i.itimp20, i.itimpo, i.itmdao, i.itdbha, i.itncor, i.itbbtt, i.itfunc, i.itsegm, i.itccos, 
                  i.itcbcu, i.itccli, i.itref, i.itanu, i.itposic, i.itvalua, i.itcltcod, i.itpza, i.itdcom, ld_fecha );       
                  
            pc_indicador := 'S';      
            
            exception 
                WHEN DUP_VAL_ON_INDEX THEN
                    pc_indicador := 'S'; 
                    --null; 
                when others then
                   pc_indicador := 'N';                   
        end;      

   end loop;   
   
 end SP_CR_INSERTA_JAQL961;
 
 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_RETORNA_INTERES( 
              pn_pgcod in number, 
              pn_itsuc in number, 
              pn_itmod in number, 
              pn_ittran in number, 
              pn_itnrel in number, 
              pd_fecha in date, 
              pn_interes out number
              ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_RETORNA_INTERES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************


/*   select tp1corr1 mod , tp1corr2 tran , tp1nro1 ord1, tp1nro2 ord2, tp1nro3 ord3, tp1imp1 ord4 , 
     tp1imp2 ord5, tp1desc Transa
     from fst198 where tp1cod = 1 and tp1cod1= 10995;
*/
  ln_numcuo number := 0;
  ln_interes number := 0;
  ld_fecha date;
  lc_indicador char(1);

  begin
   
   ld_fecha := pd_fecha;
   
   
    --contar numero de cuotas pagadas
    begin         
        select count(*)
          into ln_numcuo      
          from FSD602 
         where d602cd = pn_pgcod
           and d602mo = pn_itmod
           and d602su = pn_itsuc
           and d602tr = pn_ittran
           and d602re = pn_itnrel
           and d602fc = pd_fecha ;
     exception when no_Data_found then
         ln_numcuo :=   0;          
     end;  
     
     if ln_numcuo = 1 then
       lc_indicador := 'N';  --no necesita calcular mora 
     else
       lc_indicador := 'S';  --calcular mora por cada cuota pagada para realizar distribucion
     end if;  
       
  
     if pn_itmod = 30 and pn_ittran in ( 103, 120,153,154,273,373,374,377, 670) then

       --obtener fecha almacenada en pp1fech 
         begin         
            select distinct pp1fech
              into ld_fecha      
              from FSD602 
             where d602cd = pn_pgcod
               and d602mo = pn_itmod
               and d602su = pn_itsuc
               and d602tr = pn_ittran
               and d602re = pn_itnrel
               and d602fc = pd_fecha ;
         exception when no_Data_found then
             ld_fecha :=   pd_fecha;          
         end;     
        
        
     end if;
      
     
      begin
        select j.jaql991imp1
          into ln_interes
          from jaql991 j, fst198 f
         where j.jaql991fpro = ld_fecha
           and j.JAQL991PGCOD = pn_pgcod
           and j.JAQL991SUC   = pn_itsuc 
           and j.JAQL991MOD   = pn_itmod 
           and j.JAQL991TRAN  = pn_ittran
           and j.JAQL991NREL  = pn_itnrel
           and j.JAQL991ORD in (f.tp1nro1, f.tp1nro2, f.tp1nro3, f.tp1imp1)
           and j.jaql991imp1 > 0
           and f.tp1cod   = j.jaql991pgcod
           and f.tp1cod1  = 10995
           and f.tp1corr1 = j.jaql991mod
           and f.tp1corr2 = j.jaql991tran;
       exception when no_data_found then
                       
           begin
              select j.jaql991imp12
                 into ln_interes
                from jaql991 j, fst198 f
               where j.jaql991fpro  = ld_fecha
                 and j.JAQL991PGCOD = pn_pgcod
                 and j.JAQL991SUC   = pn_itsuc 
                 and j.JAQL991MOD   = pn_itmod 
                 and j.JAQL991TRAN  = pn_ittran
                 and j.JAQL991NREL  = pn_itnrel
                 and j.JAQL991ORD   = f.tp1imp2
                 and j.jaql991imp1 > 0
                 and f.tp1cod   = j.jaql991pgcod
                 and f.tp1cod1  = 10995
                 and f.tp1corr1 = j.jaql991mod
                 and f.tp1corr2 = j.jaql991tran;
           exception when others then
                 ln_interes := 0;
            
           end;      
        
       end;


   pn_interes := ln_interes;


 end SP_CR_RETORNA_INTERES;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_RETORNA_INTERESES( 
              pn_pgcod in number, 
              pn_itsuc in number, 
              pn_itmod in number, 
              pn_ittran in number, 
              pn_itnrel in number, 
              pd_fecha in date, 
              pd_fecpag in date,
              pn_interes out number,
              pn_totpun out number,
          /*    pn_interes out PQ_CR_INTERES_PUNITORIO.tp_intpun,
              pd_fecpag out PQ_CR_INTERES_PUNITORIO.tp_fecpun,              
           */   pn_numcon out number
              )is
               
  cursor cuotas is 
        select *      
          from FSD602 f
         where d602cd = pn_pgcod
           and d602mo = pn_itmod
           and d602su = pn_itsuc
           and d602tr = pn_ittran
           and d602re = pn_itnrel
           and d602fc = pd_fecha 
           and ppfpag <= pd_fecpag;
               

 ln_tasa number  :=0;
 ln_base number  :=0;             
 ln_cont number  :=0;
 ln_mora number  :=0;
 ln_valor number :=0;
 ln_intp number  :=0;
 ln_cuota number :=0;
 ln_cuotap number :=0;
 ln_numcuo number :=0;
 ln_totpun  number :=0;
 ln_interes number :=0;
 lc_indicador char(1); 
 ld_fecha date;
  
 begin
 
  --obtiene el punitorio pagado
  ld_fecha := pd_fecha;
  if pn_itmod = 30 and pn_ittran in ( 103, 120,153,154,273,373,374,377, 670, 117) then

     --obtener fecha almacenada en pp1fech 
       begin         
          select distinct pp1fech
            into ld_fecha      
            from FSD602 
           where d602cd = pn_pgcod
             and d602mo = pn_itmod
             and d602su = pn_itsuc
             and d602tr = pn_ittran
             and d602re = pn_itnrel
             and d602fc = pd_fecha ;
       exception when no_Data_found then
           ld_fecha :=   pd_fecha;          
       end;     
        
        
   end if;
      
     
    begin
      select j.jaql991imp1
        into ln_interes
        from jaql991 j, fst198 f
       where j.jaql991fpro = ld_fecha
         and j.JAQL991PGCOD = pn_pgcod
         and j.JAQL991SUC   = pn_itsuc 
         and j.JAQL991MOD   = pn_itmod 
         and j.JAQL991TRAN  = pn_ittran
         and j.JAQL991NREL  = pn_itnrel
         and j.JAQL991ORD in (f.tp1nro1, f.tp1nro2, f.tp1nro3, f.tp1imp1)
         and j.jaql991imp1 > 0
         and f.tp1cod   = j.jaql991pgcod
         and f.tp1cod1  = 10995
         and f.tp1corr1 = j.jaql991mod
         and f.tp1corr2 = j.jaql991tran;
     exception when no_data_found then
                       
         begin
            select j.jaql991imp12
               into ln_interes
              from jaql991 j, fst198 f
             where j.jaql991fpro  = ld_fecha
               and j.JAQL991PGCOD = pn_pgcod
               and j.JAQL991SUC   = pn_itsuc 
               and j.JAQL991MOD   = pn_itmod 
               and j.JAQL991TRAN  = pn_ittran
               and j.JAQL991NREL  = pn_itnrel
               and j.JAQL991ORD   = f.tp1imp2
               and j.jaql991imp1 > 0
               and f.tp1cod   = j.jaql991pgcod
               and f.tp1cod1  = 10995
               and f.tp1corr1 = j.jaql991mod
               and f.tp1corr2 = j.jaql991tran;
         exception when others then
               ln_interes := 0;
           
         end;      
        
     end;
  
    ---------
    --contar numero de cuotas pagadas
    begin         
        select count(*)
          into ln_numcuo      
          from FSD602 
         where d602cd = pn_pgcod
           and d602mo = pn_itmod
           and d602su = pn_itsuc
           and d602tr = pn_ittran
           and d602re = pn_itnrel
           and d602fc = pd_fecha ;
     exception when no_Data_found then
         ln_numcuo :=   0;          
     end;  
     
     if ln_numcuo = 1 then
       lc_indicador := 'N';  --no necesita calcular mora 
       pn_numcon  := ln_cont;
       pn_interes := ln_interes;
       pn_totpun  := ln_interes;     
       
     else
       lc_indicador := 'S';  --calcular mora por cada cuota pagada para realizar distribucion
     end if;  
    
    -- if lc_indicador = 'S'  then
    if lc_indicador = 'S' and ln_interes >0 then
    
   
       for i in cuotas loop
           if i.ppmda = 0 then
              ln_tasa := 156.24;
           else
              ln_tasa := 96.12;   
           end if;
           
           if i.ppmod = 116 then
              ln_base := 365;
           else    
              ln_base := 360;
           end if;
              
           ln_mora := i.pp1intm;      
           
           if ln_mora = 0   then   --si mora es 0 no debe tener punitorio
              pn_numcon  := ln_cont;
              pn_interes := 0;
              pn_totpun  := ln_interes;   

           else  --si mora es mayor 0 puede tener punitorio
           
               --cuota

               --cuota segun cronograma
               begin
                 select f.ppcap + f.ppint
                   into ln_cuota
                   from fsd601 f
                  where f.pgcod = i.pgcod
                    and f.ppmod = i.ppmod
                    and f.ppsuc = i.ppsuc
                    and f.ppmda = i.ppmda
                    and f.pppap = i.pppap
                    and f.ppcta = i.ppcta
                    and f.ppoper = i.ppoper
                    and f.ppfpag = i.ppfpag
                    and f.d601co = 'S';
               exception when others then
                 ln_cuota := 0;        
               end;

               --cuota anteriormente pagada
               begin
                 select  f.pp1cap + f.pp1int
                   into ln_cuotap
                   from fsd602 f
                  where f.pgcod = i.pgcod
                    and f.ppmod = i.ppmod
                    and f.ppsuc = i.ppsuc
                    and f.ppmda = i.ppmda
                    and f.pppap = i.pppap
                    and f.ppcta = i.ppcta
                    and f.ppoper = i.ppoper
                    and f.ppfpag = i.ppfpag
                    and f.d602fc <> pd_fecha
                    and f.d602co = 'S';
               exception when others then
                 ln_cuotap := 0;        
                 
               end;

               ln_cuota := ln_cuota - ln_cuotap;
               
               
               begin
                  pq_cr_interes_punitorio.sp_cr_calcula_mora(pd_fecvto => i.ppfpag,  --fecha vcmto de cuota
                                                             pd_fecpag => i.pp1fech, --i.d602fc,  --fecha de pago de cuota
                                                             pn_tasa => ln_tasa,
                                                             pn_capital => ln_cuota,
                                                             pn_base => ln_base,
                                                             pn_mora => ln_valor);
               end;

               
               if ln_mora < ln_valor then
                 ln_intp := ln_interes - ln_totpun ;
               else
                 ln_intp := ln_mora - ln_valor ;
                 
               end if;
               ln_cont := ln_cont + 1;
                /*     pn_interes(ln_cont) := ln_intp;
                       pd_fecpag(ln_cont) := i.ppfpag;
                */       
               
               --2015.10.12 ln_totpun := ln_totpun + ln_interes;
               ln_totpun := ln_totpun + ln_intp;
              -- pn_numcon := ln_cont;
              
            end if;
           
       end loop;
       
       pn_numcon  := ln_numcuo;
       pn_interes := ln_intp;
       pn_totpun  := ln_totpun; 
       
       
     else
         ln_cont := ln_cont + 1;
           /*    pn_interes(ln_cont) := ln_interes;
                 pd_fecpag(ln_cont) := pd_fecha;
                 
           */    
       
     end if;

   
   
 end;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_CALCULA_MORA( 
              pd_fecvto in date,  --fecha vencimiento cuota
              pd_fecpag in date,  --fecha pago
              pn_tasa in number, 
              pn_capital in number, 
              pn_base in number,  --360/365 dias
              pn_mora out number
              ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_CALCULA_MORA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

  ln_plazo number:= 0;
  ln_potencia number := 0;
  ln_valor number:= 0;
  ln_tasa number:=0;

 begin
           
   ln_plazo    := (pd_fecpag - pd_fecvto);
   ln_potencia := round( ln_plazo / pn_base, 9);
   ln_tasa     := pn_tasa/100;
   ln_valor    :=  power( (1 + ln_tasa),ln_potencia );
   
   pn_mora     := round( ( ln_valor  - 1 ) * pn_capital ,2 );

  

 end SP_CR_CALCULA_MORA;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_INTERES_PUNITORIO;
/

