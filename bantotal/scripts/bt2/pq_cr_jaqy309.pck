create or replace package PQ_CR_JAQY309 is
    -- *****************************************************************
    -- Nombre                     : paquete para PRENDARIOS - OCUM
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                              
    --
    -- *****************************************************************


---------------------------------------------------------------------------------------------
 Procedure sp_cr_elimina (JAQY309COR in number);                        
---------------------------------------------------------------------------------------------
Procedure sp_cr_inserta (pd_fecha in varchar2,
                        pd_fecap in varchar2,
                        pn_cont out number);                     
---------------------------------------------------------------------------------------------
-----------------------------------------------------------------------             
end PQ_CR_JAQY309;
/

create or replace package body PQ_CR_JAQY309 is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  ---------------------------------------

---------------------------------------------------------------------------------------------
Procedure sp_cr_elimina (JAQY309COR in number)
    is
 
   -- *****************************************************************
    -- Nombre                     : sp_cr_elimina
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- ***************************************************************** 

 
begin
   
  execute immediate 'truncate table jaqy309';
  COMMIT;
    

end sp_cr_elimina;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
Procedure sp_cr_inserta (pd_fecha in varchar2,
                        pd_fecap in varchar2,
                        pn_cont out number)
    is
 
   -- *****************************************************************
    -- Nombre                     : sp_cr_inserta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- ***************************************************************** 

cursor creditos(ld_fecha in date ) is
select *--Pgcod, Aomod, Aomda, Aopap, Aocta, Aosuc, Aooper, Aosbop,Aotope
 from fsd010
 where Pgcod = 1
   and Aomod = 108 
   and Aomda = 0
   and Aopap = 0
  -- and aocta in (/*47,153,*/218/*,17029*/)
   and (aostat <> 99 or  (aostat = 99 and aofe99 > ld_fecha) )
   order by aocta;

ld_fecin date;
ld_fecha date;
ln_saldo number(17,2);
ln_lote number(9);
ln_nombre varchar2(30);
ln_cor number:=0;
ln_documento varchar2(12);
ln_desclote varchar2(250);
ln_sucursal varchar2(30);

begin
  ld_fecin := to_date(pd_fecha,'yyyy.mm.dd');

 pq_cr_jaqy309.sp_cr_elimina(null);
 

 for i in creditos(ld_fecin ) loop
 
 if pd_fecha =  pd_fecap then
       --diaria
        begin
         select -1 * sum(Scsdo)
           into ln_saldo
           from fsd011
          where Pgcod = i.Pgcod
            and Scmod = i.Aomod
            and Sctope = i.aotope
            and Scmda = i.aomda
            and Scpap = i.aopap
            and sccta = i.Aocta
            and scoper = i.Aooper
            and scsuc = i.Aosuc
            and Scsbop = i.Aosbop;
         exception
           when no_data_found then
             ln_saldo := 0;
           when too_many_rows then
             ln_saldo := 0;
           when others then
             ln_saldo := 0;
         end;
        
       
 else
       ---historica
       begin
         select -1 * sum(BCSdMN)
           into ln_saldo
           from fsh012
          where BCEmp = i.Pgcod
            and BCSuc = i.Aosuc
            and substr(bcrubr, 1, 4) in (1411, 1414, 1415, 1421, 1424, 1425)
            and BCMda = i.Aomda
            and BCPap = i.Aopap
            and BCCta = i.Aocta
            and BCOper = i.Aooper
            and BCSbOp = i.Aosbop
            and BCTOp = i.Aotope
            and BCFech = ld_fecin
            and BCMod = i.Aomod;
       exception
         when no_data_found then
           ln_saldo := 0;
         when too_many_rows then
           ln_saldo := 0;
         when others then
           ln_saldo := 0;
       end;
       
end if;

  if ln_saldo >0 then
  
       
    begin
      select PP174Cod
        into ln_lote
        from fpp175
       where PP175Pgcod = i.Pgcod
         and PP175Mod = i.Aomod
         and PP175Suc = i.Aosuc
         and PP175Mda = i.Aomda
         and PP175Pap = i.Aopap
         and PP175Cta = i.Aocta
         and PP175Oper = i.Aooper
      --   and PP175Sbop = i.Aosbop
         and PP175Tope = i.Aotope
         and PP175TCo = 'S';
    exception
      when no_data_found then
        ln_lote := 0;
      when too_many_rows then
        ln_lote := 0;
      when others then
        ln_lote := 0;
    end;
    
   begin
       select g.penom, g.pendoc
         into ln_nombre, ln_documento
         from fsr008 f, fsd001 g
        where g.pepais = f.pepais
         and g.petdoc = f.petdoc
         and g.pendoc = f.pendoc
         and f.Pgcod = 1
         and f.ttcod = 1
         and f.cttfir = 'T'
         and f.Ctnro = i.Aocta;
     exception
       when no_data_found then
         ln_nombre := null;
       when too_many_rows then
         ln_nombre := null;
       when others then
         ln_nombre := null;
     end;
     
     --ln_sucursal
     begin
         select scnom
         into ln_sucursal
         from fst001
        where pgcod = i.pgcod
          and sucurs = i.aosuc;     
     exception
         when no_data_found then
             ln_sucursal := null;
           when too_many_rows then
             ln_sucursal := null;
           when others then
             ln_sucursal := null;     
     end;
     
     --ln_desclote
     begin
       select PP178DCom
       into ln_desclote
       from fpp178
      where pp174cod = ln_lote
        and PP177CodD = 19;
     exception
       when no_data_found then
         ln_desclote := null;
       when too_many_rows then
         ln_desclote := null;
       when others then
         ln_desclote := null;
     end;
     
   --   dbms_output.put_line( i.Aocta || ' ' ||i.Aooper||' '||ln_saldo||' '||ln_lote||' '||ln_nombre );
     --insertar
     ln_cor:= ln_cor + 1;
     
     insert into jaqy309 (jaqy309cor, jaqy309csuc, jaqy309dsuc, jaqy309nom, jaqy309ndoc, jaqy309cta, jaqy309oper, jaqy309nlote, 
                 jaqy309dlote, jaqy309mto)                 
     values(ln_cor ,i.Aosuc, ln_sucursal, ln_nombre, ln_documento, i.Aocta, i.Aooper, ln_lote, ln_desclote, ln_saldo);
    
    commit;
    
  end if;
 
 end loop;
--pn_cont := ln_cor;

end sp_cr_inserta;

---------------------------------------------------------------------------------------------
 

----------------------------------------------------------------------------------------
end PQ_CR_JAQY309;
/

