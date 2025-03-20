create or replace package PQ_CR_MIGRA_SOLICITUD is

-- *****************************************************************
-- Nombre                     : PQ_CR_MIGRA_SOLICITUD
-- Sistema                    : BANTOTAL
-- Módulo                     : DataEntry
-- Versión                    : 1.0
-- Fecha de Creación          : 2016.03.09
-- Autor de Creación          : CMAC-HLAQUI
-- Uso                        : Migracion de bd evaluacion a bantotal
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      : 23/12/2016
-- Autor de Modificación      : hlaqui
-- Descripción de Modificación: Se agrega validacion en caso ya exista un registro en la JAQM80
--
--  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
--procedure sp_cr_migra_solicitud_cuenta (P_USUARIO varchar2, P_NUMSOL out number, P_ERROR out  varchar2);
procedure sp_cr_migra_solicitud_cuenta(P_USUARIO varchar2, P_NUMSOL number, P_CODERR out varchar2, P_MSJERR out varchar2);
procedure sp_cr_migra_cuentas (P_NUMCTA out number, P_ERROR out  varchar2);
--procedure sp_cr_actualiza_solicitud (P_IDSOL number, P_NUMCTA number,P_ERROR out  varchar2);
procedure sp_cr_actualiza_solicitud (P_IDSOL number, P_NUMCTA number, P_CTATMP number, P_TIPCTA varchar2 ,P_ERROR out  varchar2);
procedure sp_cr_anula_solicitud (P_IDSOL number, P_NUMCOR number, P_ERROR out  varchar2);
end PQ_CR_MIGRA_SOLICITUD;
/

create or replace package body PQ_CR_MIGRA_SOLICITUD is

procedure sp_cr_migra_solicitud_cuenta(P_USUARIO varchar2,
                                       P_NUMSOL number,
                                       P_CODERR out varchar2,
                                       P_MSJERR out varchar2)
is 

 cursor c_solicitudes is  --Solicitudes a migrar
 select JAQM80ID, JAQM80FC, JAQM80OR,JAQM80PA,JAQM80TD,
        JAQM80ND,JAQM80CT,JAQM80TS,JAQM80SU,JAQM80MO,JAQM80TP,
        JAQM80MN,JAQM80PP,JAQM80CN,JAQM80PE,JAQM80IM,JAQM80TA,JAQM80AS,
        JAQM80OG,JAQM80ES,JAQM80SO,JAQM80DS, JAQM80FGCTA
 from JAQM80@eval
 where JAQM80FGPRO = 0 and (trim(UPPER(JAQM80AS)) = trim(UPPER(P_USUARIO)) or trim(P_USUARIO) = '' or P_USUARIO IS null)
 and JAQM80FGCTA='N' and (JAQM80ID = P_NUMSOL or P_NUMSOL = 0)
 order by JAQM80ID asc;
 
 cursor c_avales is --Garantes
 select a.JAQM81ID, a.JAQM81EM, a.JAQM81CA
 from JAQM81@eval a
 where a.JAQM81ID in 
 (select b.JAQM80ID  from JAQM80@eval b  where b.JAQM80FGPRO = 0 and (trim(UPPER(b.JAQM80AS)) = trim(UPPER(P_USUARIO)) or trim(P_USUARIO) = '' or P_USUARIO IS null));
 
 l_NumIns number;                             
 l_Clave number;                             
 l_ID_max number;
 l_TotSol number;
 l_RefCor number;  
 type array_t is varray(10) of number;
 array array_t := array_t();
 i number;
                           
begin    
  begin         
     l_TotSol := 0;
     l_ID_max := 0;
     i:=1;
     SELECT max(wfinsprcid) into l_NumIns  FROM wfinstprc;
     
     for f in c_solicitudes loop
         select max(jaqm80id) into l_ID_max from jaqm80;--maximo valor         
         
         If f.JAQM80ID <= l_ID_max then
            l_ID_max := l_ID_max +1;
         Else
            l_ID_max := f.JAQM80ID;
         End If;
         
         insert into jaqm80
         (JAQM80ID, JAQM80FC, JAQM80OR, JAQM80PA, JAQM80TD, JAQM80ND, 
          JAQM80CT, JAQM80TS, JAQM80SU, JAQM80MO, JAQM80TP, JAQM80MN, 
          JAQM80PP, JAQM80CN, JAQM80PE, JAQM80IM, JAQM80TA, JAQM80AS, 
          JAQM80OG, JAQM80ES, JAQM80SO, JAQM80DS)    
         values(l_ID_max, f.JAQM80FC, f.JAQM80OR,f.JAQM80PA,f.JAQM80TD,
          f.JAQM80ND,f.JAQM80CT,f.JAQM80TS,f.JAQM80SU,f.JAQM80MO,f.JAQM80TP,
          f.JAQM80MN,f.JAQM80PP,f.JAQM80CN,f.JAQM80PE,f.JAQM80IM,f.JAQM80TA,
          f.JAQM80AS,f.JAQM80OG,f.JAQM80ES,0,f.JAQM80DS);                           
          l_TotSol := l_TotSol +1;
         
         --Registramos la referencia entre las solicitudes
         --select max(JAQZ327aCorr) into l_RefCor from JAQZ327a;--maximo valor           
         
         for g in c_avales loop
           if g.jaqm81id = f.jaqm80id then
             insert into jaqm81
             (JAQM81ID, JAQM81EM, JAQM81CA)
             values (l_ID_max, g.JAQM81EM, g.JAQM81CA);
           End If;
         end loop;         
         array.extend();
         array(i) := l_ID_max;    
         i:= i + 1;     
     end loop;
     commit;         
     
     i:=1;
     for f in c_solicitudes loop                        
       update JAQM80@eval
       set JAQM80FGPRO = 1,
       JAQM80IDREF = array(i),
       JAQM80LOG = 'Solicitud Procesada Exitosamente'
       where JAQM80ID = f.jaqm80id;
       i:= i + 1;            
     end loop;
     commit;  
     P_CODERR := '0000';
     P_MSJERR := 'Se migró ' || l_TotSol || ' solicitudes de crédito';
  end; 
exception
  WHEN others THEN
    P_CODERR := '1111';
    P_MSJERR := sqlerrm;
    --p_error :='ERROR EN LA MIGRACION';
  
end sp_cr_migra_solicitud_cuenta;
  
procedure sp_cr_migra_cuentas (P_NUMCTA out number, P_ERROR out  varchar2)
is 

 cursor c_cuentas is  --Cuentas de Clientes
 select pgcod, ctnro, pepais, petdoc, pendoc, ttcod, cttfir
 from fsr008 
 where ctnro>( select max(ctnro) 
               from fsr008@eval);     
begin
  begin    
  P_NUMCTA := 0;
    for g in c_cuentas loop
      insert into fsr008@eval
      values ( g.pgcod, g.ctnro, g.pepais, g.petdoc, g.pendoc, g.ttcod, g.cttfir);      
      commit; 
      P_NUMCTA := P_NUMCTA + 1;
    end loop;         
  end;     
  exception
  WHEN others THEN
    --p_error := sqlerrm;
    p_error :='ERROR AL MIGRAR CUENTAS';           
end sp_cr_migra_cuentas;


procedure sp_cr_actualiza_solicitud (P_IDSOL number, P_NUMCTA number, P_CTATMP number, P_TIPCTA varchar2 ,P_ERROR out  varchar2)

is 
begin    
  begin
    if P_TIPCTA = 'C' then --Si es la cuenta Cliente de la Solicitud
      commit;
      update JAQM80@eval
      set
        JAQM80FGCTA =  'N',
        JAQM80CT= P_NUMCTA      
      where JAQM80ID = P_IDSOL
      and JAQM80FGCTA = 'S';            
      commit;
    else --'A' en este caso se debe actualizar la informacion de los AVALES - GARANTES
      commit;
      update JAQM81@eval
      set
        JAQM81CA = P_NUMCTA,
        JAQM81FGCTA = 'N'
      where JAQM81ID = P_IDSOL
      and JAQM81FGCTA  = 'S'
      and JAQM81CTATMP = P_CTATMP;            
      commit;
    end if;
        
    
    
  end;
  exception
  WHEN others THEN
    p_error := sqlerrm;
    --p_error :='ERROR EN LA ACTUALIZACION';
end sp_cr_actualiza_solicitud;

procedure sp_cr_anula_solicitud (P_IDSOL number, P_NUMCOR number, P_ERROR out  varchar2)

is 
  cursor c_cuentas is  --Cuentas a actualizar
  SELECT ctnro, pendoc, b.jaqz329log log from (select * from fsr008_aux@eval 
  where ctnro in (select jaqm80ctatmp from jaqm80@eval where jaqm80id=P_IDSOL)) a 
  inner join jaqz329 b on a.pendoc = b.jaqz329numdoc and b.jaqz329nro=P_NUMCOR;

  cursor c_avales is  --Cuentas Avales a actualizar
  SELECT ctnro, pendoc, b.jaqz329log log from (select * from fsr008_aux@eval 
  where ctnro in (select jaqm81ctatmp from jaqm81@eval where jaqm81id=P_IDSOL and jaqm81fgcta2='S')) a 
  inner join jaqz329 b on a.pendoc = b.jaqz329numdoc and b.jaqz329nro=P_NUMCOR;

begin    
  begin
    commit;    
    for g in c_cuentas loop
        update fsr008_aux@eval
        set log = g.log
        where ctnro= g.ctnro and pendoc=g.pendoc;
    end loop;
    
    for g in c_avales loop
        update fsr008_aux@eval
        set log = g.log
        where ctnro= g.ctnro and pendoc=g.pendoc;
    end loop;      

    update JAQM80@eval
    set JAQM80FGPRO= 2 --Anulada - Error el Generar solicitud - Cuenta Invalida
    , JAQM80LOG = 'Solicitud Anulada - Cuenta Cliente con Errores'
    where JAQM80ID = P_IDSOL;
    commit;
  end;
  exception
  WHEN others THEN
    p_error := sqlerrm;    
end sp_cr_anula_solicitud;

/*
JAQM80FGPRO : 
	0: No procesado
	1: Si procesado
	2: Error al generar Solicitud
*/

end PQ_CR_MIGRA_SOLICITUD;
/

