create or replace package PQ_CR_AVISOS is
    -- *****************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS PRENDARIOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.11.12
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Realiza Calculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    --
    --
    -- *****************************************************************
-----------------------------------------------------------------------
PROCEDURE SP_CR_LIMPIAR_TABLA(table_name VARCHAR2);
-----------------------------------------------------------------------
-----------------------------------------------------------------------
PROCEDURE SP_CR_COBRANZA_CRD_VCDO(vhsucur in integer,Datrz in integer,datrzf in integer);
-----------------------------------------------------------------------
PROCEDURE SP_CR_REMATE_CREDITO_PRD(vhsucur in integer,Datrz in integer,datrzf in integer);
-----------------------------------------------------------------------
PROCEDURE SP_CR_SOBRANTE_PRD(vhsucur in integer);
-----------------------------------------------------------------------
function FN_CR_IMPORTEALETRAS(vmontoaconvertir IN NUMBER)return varchar2;
-----------------------------------------------------------------------

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
--- Mod. Nuevo Modulo de Remate Prendario
PROCEDURE sp_cr_cobranza_crd_vcdo_nr(vhsucur in integer,Datrz in integer,datrzf in integer);
-----------------------------------------------------------------------
PROCEDURE sp_cr_remate_credito_prd_nr(vhsucur in integer,Datrz in integer,datrzf in integer);
-----------------------------------------------------------------------
end PQ_CR_AVISOS;
/

create or replace package body PQ_CR_AVISOS is
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

----------------------------------------------------------------------------------------
PROCEDURE SP_CR_LIMPIAR_TABLA(table_name VARCHAR2)
 -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : HSUAREZ
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
     IS
        vn_table_name VARCHAR2(30);
        str varchar2(100);
      BEGIN
        vn_table_name := UPPER(LTRIM(RTRIM(table_name)));
        str := 'TRUNCATE TABLE '||vn_table_name;
       execute immediate(str);
END SP_CR_LIMPIAR_TABLA;

---------------------------------------------------------------------------------------------*/
PROCEDURE sp_cr_cobranza_crd_vcdo(vhsucur in integer,Datrz in integer,datrzf in integer) is
fa_s date;
     --Actualizado el MIERCOLES, 06/04/2016
		 --MODIFICACION : Henry Suarez - OPTIMIZACION DEL CODIGO.
 cursor listado is      
      Select distinct--/*+index_ss(f83)parallel(f,2,1)*/(fa_s - ff.aofvto ) Atraso,
             f.pp175cta  cuenta,
             f.pp175oper operacion,
             f.pp174cod  lote,
             f.pp175suc  sucursal,
             f.pp173cod  codempresa,
             f.pp175mod  modulo,
             f.pp175mda  moneda,
             f.pp175pap  papel, 
             f.pp175sbop suboperacion,
             f.pp175tope tipooperacion,
             trim(p.scnom) nsucursal,  --"Sucursal",
             trim(s.penom) cliente,
             trim(c.sngc13dir) direccion,
             trim(g.fst071dsc) distrito--,*/
             --ff.aofvto,
            -- fa_s
      From Fpp175 f
           inner join fst001 p
                   on p.pgcod = f.pp173cod
                  and p.sucurs = f.pp175suc
           inner join fsr008 r
                   on r.pgcod = p.pgcod
                  and r.ctnro = f.pp175cta
                  and r.cttfir = 'T'
           inner join fsd001 s
                   on s.pepais = r.pepais
                  and s.petdoc = r.petdoc
                  and s.pendoc = r.pendoc
           inner join sngc13 c
                   on c.sngc13pais = s.pepais
                  and c.sngc13tdoc = s.petdoc
                  and c.sngc13ndoc = s.pendoc
                  and c.docod = 1
									and c.sngc13est = 'H' --2018.01.31 - HSUAREZ AGREGADO PARA SOLO DIRECCION VIGENTE.
           inner join fst071 g
                   on g.fst071pai = c.sngc13pais
                  and g.fst071col = c.sngc13dist
           --se agregan estos inner join para incluir la fecha del remate
           inner join fpp183 f83
                   on f83.pp174cod=f.pp174cod
                   and not exists (select /*+parallel(fpp183,2,1)*/ pp182cod from fpp183 where pp174cod=f.pp174cod and pp182cod=5 and pp183con='S')
      where f.pp175suc=vhsucur
			and f.pp175tco='S';

			ld_fcvto date;
			ln_dias number;

			begin
			--Modificacion Enviada por HENRY SUAREZ
			--Martes, 12 DE NOVIEMBRE DEL 2015
			--Actualizado el LUNES, 18 de NOVIEMBRE de 2015 18:30
			--OPEN DATA FOR
			--Actualizado el MIERCOLES, 06/04/2016
			--MODIFICACION : Henry Suarez - OPTIMIZACION DEL CODIGO.

						--SP_CR_LIMPIAR_TABLA('JAQZ410');
						delete from jaqz410 where jaqz410CSUC=vhsucur; --and jaqz410fat=fa_s ;
						select pgfape into fa_s from fst017 where pgcod=1;
						
								for i in listado loop
								
									 begin
											select ff.aofvto
												into ld_fcvto
												from fsd010 ff 
											 where FF.PGCOD  = i.codempresa
												 AND FF.AOMOD  = i.modulo
												 AND FF.AOSUC  = i.sucursal
												 AND FF.AOMDA  = i.moneda
												 AND FF.AOPAP  = i.papel
												 AND FF.AOCTA  = i.cuenta
												 AND FF.AOOPER = i.operacion
												 AND FF.AOSBOP = i.suboperacion 
												 AND FF.AOTOPE = i.tipooperacion
												 AND FF.AOSTAT <> 41
												 AND FF.AOSTAT <> 99;
									exception when no_data_found then
														ld_fcvto := null;			 
									 end;			 

									if ld_fcvto is not null then 
											 ln_dias := (fa_s -ld_fcvto) ;
											 if ln_dias >= Datrz and ln_dias <= datrzf then
												 --- INSERTAMOS LOS DATOS
												 INSERT INTO JAQZ410
															(JAQZ410DAT,
															 JAQZ410CTA,
															 JAQZ410OPE,
															 JAQZ410LTE,
															 JAQZ410CSUC,
															 JAQZ410SUC,
															 JAQZ410CLI,
															 JAQZ410DIR,
															 JAQZ410DIS,
															 JAQZ410FTO,
															 JAQZ410FAT)
													values 
															 (ln_dias, 
																i.cuenta , 
																i.operacion,
																i.lote,
																i.sucursal,
																i.nsucursal,
																trim(i.cliente),
																trim(i.direccion),
																trim(i.distrito),
																ld_fcvto,
																fa_s
															 );
												end if; 
												--commit; 
									end if;												 
								end loop;
								commit; 
end sp_cr_cobranza_crd_vcdo;

---------------------------------------------------------------------------------------------

PROCEDURE SP_CR_REMATE_CREDITO_PRD(vhsucur in integer,Datrz in integer,Datrzf in integer) is
fa_s date;

cursor listado is      
      Select distinct--/*+index_ss(f83)parallel(f,2,1)*/(fa_s - ff.aofvto ) Atraso,
             f.pp175cta          cuenta,
             f.pp175oper         operacion,
             f.pp174cod          lote,
						 f.pp175suc          sucursal,
             f.pp173cod          codempresa,
             f.pp175mod          modulo,
             f.pp175mda          moneda,
             f.pp175pap          papel, 
             f.pp175sbop         suboperacion,
             f.pp175tope         tipooperacion,
             trim(p.scnom)       nsucursal,  --"Sucursal",
             trim(s.penom)       cliente,
             trim(c.sngc13dir)   direccion,
             trim(g.fst071dsc)   distrito,
						 f85.pp185dfec       fremate,
             f85.pp179codre      cremate				
						
      From Fpp175 f
           inner join fst001 p
                   on p.pgcod = f.pp173cod
                  and p.sucurs = f.pp175suc
           /*
					 inner join fsd010 ff
                   on ff.pgcod = f.pp173cod
                  and ff.aomod = f.pp175mod
                  and ff.aosuc = f.pp175suc
                  and ff.aomda = f.pp175mda
                  and ff.aopap = f.pp175pap
                  and ff.aocta = f.pp175cta
                  and ff.aooper = f.pp175oper
                  and ff.aosbop = f.pp175sbop
                  and ff.aotope = f.pp175tope
            */
           inner join fsr008 r
                   on r.pgcod = p.pgcod
                  and r.ctnro = f.pp175cta
                  and r.cttfir = 'T'
           inner join fsd001 s
                   on s.pepais = r.pepais
                  and s.petdoc = r.petdoc
                  and s.pendoc = r.pendoc
           inner join sngc13 c
                   on c.sngc13pais = s.pepais
                  and c.sngc13tdoc = s.petdoc
                  and c.sngc13ndoc = s.pendoc
                  and c.docod = 1
									and c.sngc13est = 'H' --2018.01.31 - HSUAREZ AGREGADO PARA SOLO DIRECCION VIGENTE.
           inner join fst071 g
                   on g.fst071pai = c.sngc13pais
                  and g.fst071col = c.sngc13dist
           -- se agregan estos inner join para incluir la fecha del remate
           inner join fpp183 f83
                   on f83.pp174cod=f.pp174cod
                   and f83.pp182cod=5
                   --and f83.Pp183con='S'
                   and not exists (select pp182cod from fpp183 where pp174cod=f.pp174cod and pp183con='S' and pp182cod in(8,10,11))
                   --- no se considera
           inner join fpp186 f86
                   on f86.pp174cod=f.pp174cod
                  and f86.pp173cod=f.pp173cod
                  AND PP179CODRE=(select max(PP179CODRE) FROM fpp186 where pp174cod=f.pp174cod)
           inner join fpp179 f79
                   on f79.pp179codre=f86.pp179codre
                  and f79.pp179sts='PREPARADO'
           inner join fpp185 f85
                   on f85.pp179codre=f79.pp179codre
                   and f85.pp177codd=1 -- aqui indico que quiero la de la fecha de remate.
      where f.pp175suc=vhsucur
			and f.pp175tco='S';
			
			ld_fcvto date;
			ln_dias number;
			
			begin
			--Modificacion Enviada por HENRY SUAREZ
			--Martes, 12 DE NOVIEMBRE DEL 2015
			--Actualizado el LUNES, 18 de NOVIEMBRE de 2015 18:30
			--OPEN DATA FOR
      --SP_CR_LIMPIAR_TABLA('JAQZ410');
      delete from jaqz410 where jaqz410CSUC=vhsucur; --and jaqz410fat=fa_s ;
      select pgfape into fa_s from fst017 where pgcod=1;
						
								for i in listado loop								
									 begin
											select ff.aofvto
												into ld_fcvto
												from fsd010 ff 
											 where FF.PGCOD  = i.codempresa
												 AND FF.AOMOD  = i.modulo
												 AND FF.AOSUC  = i.sucursal
												 AND FF.AOMDA  = i.moneda
												 AND FF.AOPAP  = i.papel
												 AND FF.AOCTA  = i.cuenta
												 AND FF.AOOPER = i.operacion
												 AND FF.AOSBOP = i.suboperacion 
												 AND FF.AOTOPE = i.tipooperacion
												 AND FF.AOSTAT <> 41
												 AND FF.AOSTAT <> 99;
									exception when no_data_found then
														ld_fcvto := null;			 
									 end;			 

									if ld_fcvto is not null then 
											 ln_dias := (fa_s -ld_fcvto) ;
											 if ln_dias >= Datrz and ln_dias <= datrzf then
												 --- INSERTAMOS LOS DATOS
												 INSERT INTO JAQZ410
															(													 
															 JAQZ410DAT,
															 JAQZ410CTA,
															 JAQZ410OPE,
															 JAQZ410LTE,
															 JAQZ410CSUC,
															 JAQZ410SUC,
															 JAQZ410CLI,
															 JAQZ410DIR,
															 JAQZ410DIS,
															 JAQZ410FTO,
															 JAQZ410FAT,
															 JAQZ410FRMT,
															 jaqz410crmt
															 )
													values 
															 (ln_dias, 
																i.cuenta , 
																i.operacion,
																i.lote,
																i.sucursal,
																i.nsucursal,
																trim(i.cliente),
																trim(i.direccion),
																trim(i.distrito),
																ld_fcvto,
																fa_s,
																i.fremate,
																i.cremate
															 );
												end if; 
												--commit; 
									end if;												 
								end loop;
								commit; 
			/*
      INSERT INTO JAQZ410
      (
             JAQZ410DAT,
             JAQZ410CTA,
             JAQZ410OPE,
             JAQZ410LTE,
             JAQZ410CSUC,
             JAQZ410SUC,
             JAQZ410CLI,
             JAQZ410DIR,
             JAQZ410DIS,
             JAQZ410FTO,
             JAQZ410FAT,
             JAQZ410FRMT,
             JAQZ410CRMT
      )
      Select (fa_s - ff.aofvto ) Atraso,
             f.pp175cta          cuenta,
             f.pp175oper         operacion,
             f.pp174cod          lote,
             f.pp175suc          csucursal,
             trim(p.scnom)       sucursal,
             trim(s.penom)       cliente,
             trim(c.sngc13dir)   direccion,
             trim(g.fst071dsc)   distrito,
             ff.aofvto           fvencimiento,
             fa_s                fatraso,
             f85.pp185dfec       fremate,
             f85.pp179codre      cremate

      From Fpp175 f
           inner join fst001 p
                   on p.pgcod = f.pp173cod
                  and p.sucurs = f.pp175suc
           
					 inner join fsd010 ff
                   on ff.pgcod = f.pp173cod
                  and ff.aomod = f.pp175mod
                  and ff.aosuc = f.pp175suc
                  and ff.aomda = f.pp175mda
                  and ff.aopap = f.pp175pap
                  and ff.aocta = f.pp175cta
                  and ff.aooper = f.pp175oper
                  and ff.aosbop = f.pp175sbop
                  and ff.aotope = f.pp175tope

           inner join fsr008 r
                   on r.pgcod = p.pgcod
                  and r.ctnro = f.pp175cta
                  and r.cttfir = 'T'
           inner join fsd001 s
                   on s.pepais = r.pepais
                  and s.petdoc = r.petdoc
                  and s.pendoc = r.pendoc
           inner join sngc13 c
                   on c.sngc13pais = s.pepais
                  and c.sngc13tdoc = s.petdoc
                  and c.sngc13ndoc = s.pendoc
                  and c.docod = 1
           inner join fst071 g
                   on g.fst071pai = c.sngc13pais
                  and g.fst071col = c.sngc13dist
           -- se agregan estos inner join para incluir la fecha del remate
           inner join fpp183 f83
                   on f83.pp174cod=f.pp174cod
                   and f83.pp182cod=5
                   --and f83.Pp183con='S'
                   and not exists (select pp182cod from fpp183 where pp174cod=f.pp174cod and pp182cod in(8,10,11))
                   --- no se considera
           inner join fpp186 f86
                   on f86.pp174cod=f.pp174cod
                  and f86.pp173cod=f.pp173cod
                  AND PP179CODRE=(select max(PP179CODRE) FROM fpp186 where pp174cod=f.pp174cod)
           inner join fpp179 f79
                   on f79.pp179codre=f86.pp179codre
                  and f79.pp179sts='PREPARADO'
           inner join fpp185 f85
                   on f85.pp179codre=f79.pp179codre
                   and f85.pp177codd=1 -- aqui indico que quiero la de la fecha de remate.
      where f.pp175suc=vhsucur
      and   (fa_s - ff.aofvto)>= Datrz

      group by fa_s,
               ff.aofvto,
               f.pp175cta,
               f.pp175oper,
               f.pp174cod,
               f.pp175suc,
               trim(p.scnom),
               trim(s.penom),
               trim(c.sngc13dir),
               trim(g.fst071dsc),
               F85.PP185DFEC,
               f85.pp179codre;

      commit;
      */
end SP_CR_REMATE_CREDITO_PRD;


PROCEDURE SP_CR_SOBRANTE_PRD(vhsucur in integer) is
fa_s date;
begin
--Modificacion Enviada por HENRY SUAREZ
--Martes, 12 DE NOVIEMBRE DEL 2015
--Actualizado el LUNES, 18 de NOVIEMBRE de 2015 18:30
--OPEN DATA FOR

      --SP_CR_LIMPIAR_TABLA('JAQZ410');
      delete from jaqz410 where jaqz410CSUC=vhsucur; --and jaqz410fat=fa_s ;
      select pgfape into fa_s from fst017 where pgcod=1;
      INSERT INTO JAQZ410
      (
             JAQZ410CTA,
             JAQZ410OPE,
             JAQZ410LTE,
             JAQZ410CSUC,
             JAQZ410SUC,
             JAQZ410CLI,
             JAQZ410DIR,
             JAQZ410DIS,
             JAQZ410FTO,
             JAQZ410FAT,
             JAQZ410FRMT,
             JAQZ410CRMT,
             JAQZ410SBR
      )
      Select 
             f.pp175cta "Cuenta",
             f.pp175oper "Operacion",
             f.pp174cod "Lote",
             f.pp175suc,
             trim(p.scnom) "Sucursal",
             trim(s.penom) "Cliente",
             trim(c.sngc13dir) "Direccion",
             trim(g.fst071dsc) "Distrito",
             ff.aofvto,
             fa_s,
             f85.pp185dfec "FREMATE",
             f85.pp179codre "CODREMATE",
             (f87v.pp187dsal-(f87d.pp187dsal+f87c.pp187dsal)) sobrante

      From Fpp175 f
           inner join fst001 p
                   on p.pgcod = f.pp173cod
                  and p.sucurs = f.pp175suc
           inner join fsd010 ff
                   on ff.pgcod = f.pp173cod
                  and ff.aomod = f.pp175mod
                  and ff.aosuc = f.pp175suc
                  and ff.aomda = f.pp175mda
                  and ff.aopap = f.pp175pap
                  and ff.aocta = f.pp175cta
                  and ff.aooper = f.pp175oper
                  and ff.aosbop = (select max(q.aosbop) from fsd010 q where q.pgcod = ff.pgcod and q.aocta = ff.aocta and q.aooper = ff.aooper)
                  and ff.aotope = f.pp175tope

           inner join fsr008 r
                   on r.pgcod = p.pgcod
                  and r.ctnro = f.pp175cta
                  and r.cttfir = 'T'
           inner join fsd001 s
                   on s.pepais = r.pepais
                  and s.petdoc = r.petdoc
                  and s.pendoc = r.pendoc
           inner join sngc13 c
                   on c.sngc13pais = s.pepais
                  and c.sngc13tdoc = s.petdoc
                  and c.sngc13ndoc = s.pendoc
                  and c.docod = 1
									and c.sngc13est = 'H' --2018.01.31 - HSUAREZ AGREGADO PARA SOLO DIRECCION VIGENTE.
           inner join fst071 g
                   on g.fst071pai = c.sngc13pais
                  and g.fst071col = c.sngc13dist
           -- se agregan estos inner join para incluir la fecha del remate
           inner join fpp183 f83
                   on f83.pp174cod=f.pp174cod
                   and f83.pp182cod=3
                   --and f83.Pp183con='S'
                   --and exists (select pp182cod from fpp183 where pp174cod=f.pp174cod and pp182cod in(8,10,11))
                   --- no se considera
           inner join fpp187 f87V
                   on f87V.pp174cod=f.pp174cod
                  and f87V.pp177codd=16
           inner join fpp187 f87D
                   on f87D.pp174cod=f.pp174cod
                  and f87D.Pp177codd=3
           inner join fpp187 f87C
                   on f87c.pp174cod=f.pp174cod
                  and f87c.pp177codd=6
           inner join fpp186 f86
                   on f86.pp174cod=f.pp174cod
                  and f86.pp173cod=f.pp173cod
                  AND f86.PP179CODRE=(select max(PP179CODRE) FROM fpp186 where pp174cod=f.pp174cod)
           inner join fpp179 f79
                   on f79.pp179codre=f86.pp179codre
           inner join fpp185 f85
                   on f85.pp179codre=f79.pp179codre
                   and f85.pp177codd=1 -- aqui indico que quiero la de la fecha de remate.  */
      where f.pp175suc=vhsucur
      --and (f87v.pp187dsal-(f87d.pp187dsal+f87c.pp187dsal))>0 
      group by 
               ff.aofvto,
               f.pp175cta,
               f.pp175oper,
               f.pp174cod,
               f.pp175suc,
               trim(p.scnom),
               trim(s.penom),
               trim(c.sngc13dir),
               trim(g.fst071dsc),
               F85.pp185dfec,
               F85.PP179CODRE,
               (f87v.pp187dsal-(f87d.pp187dsal+f87c.pp187dsal));
          
      commit;

end SP_CR_SOBRANTE_PRD;

function FN_CR_IMPORTEALETRAS(vmontoaconvertir IN NUMBER) return varchar2 is
  vdigito number;
  vbandera number;
  vfila number;
  vmontoint number;
  vdescripcion varchar2(30);
  vbandmillon number;
  vbandmil number;
  vcentavos varchar(10);
  vdescimporte varchar(500);

begin
    select  floor(vmontoaconvertir)
    into vmontoint
    from dual;

     vdescimporte := '';

     vbandera := 0;
     vdigito := floor(vmontoint / 100000000);
     vbandmillon :=0;

    if  vdigito > 0 then

        vbandmillon :=1;
        vfila := floor(vdigito * 100);
        Select rtrim(descripcionnumero)
            into vdescripcion
            from numeros
            where codnumero = vfila;


        vdescimporte := vdescimporte || vdescripcion;
        vmontoint := vmontoint - (vdigito * 100000000);
        if  vmontoint >= 1000000 and vdigito = 1 then
             vdescimporte := vdescimporte||'to';
        end if;
    end if;--borrar luego



    vdigito := floor(vmontoint / 10000000);

    if  vdigito > 0 then

        vbandmillon:=1;
        if  vdigito = 1 or vdigito = 2 then

            vdigito := floor(vmontoint / 1000000);
            select   rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

             vdescimporte := vdescimporte || ' ' || vdescripcion;
             vmontoint := (vmontoint - (vdigito * 1000000));
        else
             vbandera := 1;
             vfila := (vdigito * 10);
            select   rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vfila;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
             vmontoint := (vmontoint - (vdigito * 10000000));
        end if;
    end if;


    if  vmontoint >= 1000000
    then
        vdigito := floor(vmontoint / 1000000);

        if vdigito > 0
        then
            select rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

            if  vbandera = 1
            then
                vdescimporte := vdescimporte || ' y ' || vdescripcion || ' Millones';
                vbandera := 0;
            else
                if  vdigito = 1 then
                    vdescimporte := (vdescimporte || ' ' || vdescripcion || ' Millon');
                else
                    vdescimporte := (vdescimporte || ' ' || vdescripcion || ' Millones');
                end if;
            end if;
            vmontoint := (vmontoint - (vdigito * 1000000));
        end if;
    elsif  vbandmillon=1 then
            vdescimporte := (vdescimporte || ' Millones');
    end if;

    vbandera := 0;
    vdigito := floor(vmontoint / 100000);
    vbandmil := 0;

    if  vdigito > 0
    then
        vbandmil:=1;
        vfila := (vdigito * 100);
        select  rtrim(descripcionnumero)
          into vdescripcion
          from numeros
          where codnumero = vfila;
        vdescimporte := (vdescimporte || ' ' || vdescripcion);
        vmontoint := (vmontoint - (vdigito * 100000));
        if  vmontoint >= 1000 and vdigito = 1 then
            vdescimporte := (vdescimporte || 'to');
        end if;
    end if;

    vdigito := floor(vmontoint / 10000);

    if  vdigito > 0
    then
        vbandmil:=1;
        if  vdigito = 1 or vdigito = 2
        then
            vdigito := floor(vmontoint / 1000);
            select rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
            vmontoint := (vmontoint - (vdigito * 1000));
        else
            vbandera := 1;
            vfila := (vdigito * 10);
            select   rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vfila;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
            vmontoint := (vmontoint - (vdigito * 10000));
        end if;
    end if;

    if  vmontoint >= 1000
    then
        vdigito := floor(vmontoint / 1000);

        if  vdigito > 0
        then
            select  rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

            if  vbandera = 1
            then
                vdescimporte := (vdescimporte || ' y ' || vdescripcion || ' Mil');
                vbandera := 0;
            else
                vdescimporte := (vdescimporte || ' ' || vdescripcion || ' Mil');
            end if;

            vmontoint := (vmontoint - (vdigito * 1000));
        end if;
    elsif  vbandmil=1 then
         vdescimporte := (vdescimporte || ' Mil');
    end if;

    vbandera := 0;
    vdigito := floor(vmontoint / 100);

    if  vdigito > 0
    then
        vfila := (vdigito * 100);

        select  rtrim(descripcionnumero)
          into vdescripcion
          from numeros
          where codnumero = vfila;

        vdescimporte := (vdescimporte || ' ' || vdescripcion);
        vmontoint := (vmontoint - (vdigito * 100));
        if  vmontoint > 0 and vdigito = 1 then
            vdescimporte := (vdescimporte || 'to');
        end if;
    end if;

    vdigito := floor(vmontoint / 10);

    if vdigito > 0
    then
        if vdigito = 1 or vdigito = 2 then
            vdigito := floor(vmontoint / 1);
            select rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
            vmontoint := (vmontoint - (vdigito * 1));
        else
            vbandera := 1;
            vfila := (vdigito * 10);
            select rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vfila;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
            vmontoint := (vmontoint - (vdigito * 10));
        end if;
    end if;

    if  vmontoint >= 1
    then
        select rtrim(descripcionnumero)
          into vdescripcion
          from numeros
          where codnumero = vmontoint;

        if  vbandera = 1 then
            vdescimporte := (vdescimporte || ' y ' || vdescripcion);
        else
            vdescimporte := (vdescimporte || ' ' || vdescripcion);
        end if;

        if  vmontoint = 1 then
            vdescimporte := (vdescimporte || 'o');
        end if;
    end if;


    vdigito:=(vmontoaconvertir -  floor(vmontoaconvertir)) * 100;
    vcentavos:=round(vdigito);

    if vcentavos>0 then
      vdescimporte:= vdescimporte || ' con ' || vcentavos || '/100 Nuevos Soles';

    end if;
return(vdescimporte);
end FN_CR_IMPORTEALETRAS;


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Paquete Modificado para el Nuevo Mod. de Remate Prendario --------------------------------
PROCEDURE sp_cr_cobranza_crd_vcdo_nr(vhsucur in integer,Datrz in integer,datrzf in integer) is
fa_s date;
     --Actualizado el MIERCOLES, 06/04/2016
		 --MODIFICACION : Henry Suarez - OPTIMIZACION DEL CODIGO.
 cursor listado is      
      Select distinct--/*+index_ss(f83)parallel(f,2,1)*/(fa_s - ff.aofvto ) Atraso,
             f.pp175cta  cuenta,
             f.pp175oper operacion,
             f.pp174cod  lote,
             f.pp175suc  sucursal,
             f.pp173cod  codempresa,
             f.pp175mod  modulo,
             f.pp175mda  moneda,
             f.pp175pap  papel, 
             f.pp175sbop suboperacion,
             f.pp175tope tipooperacion,
             trim(p.scnom) nsucursal,  --"Sucursal",
             trim(s.penom) cliente,
             trim(c.sngc13dir) direccion,
             trim(g.fst071dsc) distrito--,*/
             --ff.aofvto,
            -- fa_s
      From Fpp175 f
           inner join fst001 p
                   on p.pgcod = f.pp173cod
                  and p.sucurs = f.pp175suc
           inner join fsr008 r
                   on r.pgcod = p.pgcod
                  and r.ctnro = f.pp175cta
                  and r.cttfir = 'T'
           inner join fsd001 s
                   on s.pepais = r.pepais
                  and s.petdoc = r.petdoc
                  and s.pendoc = r.pendoc
           inner join sngc13 c
                   on c.sngc13pais = s.pepais
                  and c.sngc13tdoc = s.petdoc
                  and c.sngc13ndoc = s.pendoc
                  and c.docod = 1
									and c.sngc13est = 'H' --2018.01.31 - HSUAREZ AGREGADO PARA SOLO DIRECCION VIGENTE.
           inner join fst071 g
                   on g.fst071pai = c.sngc13pais
                  and g.fst071col = c.sngc13dist
           --se agregan estos inner join para incluir la fecha del remate
           inner join fpp183 f83
                   on f83.pp174cod=f.pp174cod
                   and not exists (select /*+parallel(fpp183,2,1)*/ pp182cod from fpp183 where pp174cod=f.pp174cod and pp182cod=5 and pp183con='S')
      where f.pp175suc=vhsucur
			and f.pp175tco='S';

			ld_fcvto date;
			ln_dias number;

			begin
			--Modificacion Enviada por HENRY SUAREZ
			--Martes, 12 DE NOVIEMBRE DEL 2015
			--Actualizado el LUNES, 18 de NOVIEMBRE de 2015 18:30
			--OPEN DATA FOR
			--Actualizado el MIERCOLES, 06/04/2016
			--MODIFICACION : Henry Suarez - OPTIMIZACION DEL CODIGO.

						--SP_CR_LIMPIAR_TABLA('JAQZ410');
						delete from jaqz410 where jaqz410CSUC=vhsucur; --and jaqz410fat=fa_s ;
						select pgfape into fa_s from fst017 where pgcod=1;
						
								for i in listado loop
								
									 begin
											select ff.aofvto
												into ld_fcvto
												from fsd010 ff 
											 where FF.PGCOD  = i.codempresa
												 AND FF.AOMOD  = i.modulo
												 AND FF.AOSUC  = i.sucursal
												 AND FF.AOMDA  = i.moneda
												 AND FF.AOPAP  = i.papel
												 AND FF.AOCTA  = i.cuenta
												 AND FF.AOOPER = i.operacion
												 AND FF.AOSBOP = i.suboperacion 
												 AND FF.AOTOPE = i.tipooperacion
												 AND FF.AOSTAT <> 41
												 AND FF.AOSTAT <> 99;
									exception when no_data_found then
														ld_fcvto := null;			 
									 end;			 

									if ld_fcvto is not null then 
											 ln_dias := (fa_s -ld_fcvto) ;
											 if ln_dias >= Datrz and ln_dias <= datrzf then
												 --- INSERTAMOS LOS DATOS
												 INSERT INTO JAQZ410
															(JAQZ410DAT,
															 JAQZ410CTA,
															 JAQZ410OPE,
															 JAQZ410LTE,
															 JAQZ410CSUC,
															 JAQZ410SUC,
															 JAQZ410CLI,
															 JAQZ410DIR,
															 JAQZ410DIS,
															 JAQZ410FTO,
															 JAQZ410FAT)
													values 
															 (ln_dias, 
																i.cuenta , 
																i.operacion,
																i.lote,
																i.sucursal,
																i.nsucursal,
																trim(i.cliente),
																trim(i.direccion),
																trim(i.distrito),
																ld_fcvto,
																fa_s
															 );
												end if; 
												--commit; 
									end if;												 
								end loop;
								commit; 
end sp_cr_cobranza_crd_vcdo_nr;
---------------------------------------------------------------------------------------------
PROCEDURE sp_cr_remate_credito_prd_nr(vhsucur in integer,Datrz in integer,Datrzf in integer) is
fa_s date;

cursor listado is      
      Select distinct--/*+index_ss(f83)parallel(f,2,1)*/(fa_s - ff.aofvto ) Atraso,
             f.pp175cta          cuenta,
             f.pp175oper         operacion,
             f.pp174cod          lote,
						 f.pp175suc          sucursal,
             f.pp173cod          codempresa,
             f.pp175mod          modulo,
             f.pp175mda          moneda,
             f.pp175pap          papel, 
             f.pp175sbop         suboperacion,
             f.pp175tope         tipooperacion,
             trim(p.scnom)       nsucursal,  --"Sucursal",
             trim(s.penom)       cliente,
             trim(c.sngc13dir)   direccion,
             trim(g.fst071dsc)   distrito,
						 z41.qz441dfec       fremate,
             z41.qz440codre      cremate				
						
      From Fpp175 f
           inner join fst001 p
                   on p.pgcod = f.pp173cod
                  and p.sucurs = f.pp175suc
           /*
					 inner join fsd010 ff
                   on ff.pgcod = f.pp173cod
                  and ff.aomod = f.pp175mod
                  and ff.aosuc = f.pp175suc
                  and ff.aomda = f.pp175mda
                  and ff.aopap = f.pp175pap
                  and ff.aocta = f.pp175cta
                  and ff.aooper = f.pp175oper
                  and ff.aosbop = f.pp175sbop
                  and ff.aotope = f.pp175tope
            */
           inner join fsr008 r
                   on r.pgcod = p.pgcod
                  and r.ctnro = f.pp175cta
                  and r.cttfir = 'T'
           inner join fsd001 s
                   on s.pepais = r.pepais
                  and s.petdoc = r.petdoc
                  and s.pendoc = r.pendoc
           inner join sngc13 c
                   on c.sngc13pais = s.pepais
                  and c.sngc13tdoc = s.petdoc
                  and c.sngc13ndoc = s.pendoc
                  and c.docod = 1
									and c.sngc13est = 'H' --2018.01.31 - HSUAREZ AGREGADO PARA SOLO DIRECCION VIGENTE.
           inner join fst071 g
                   on g.fst071pai = c.sngc13pais
                  and g.fst071col = c.sngc13dist
           -- se agregan estos inner join para incluir la fecha del remate
           inner join fpp183 f83
                   on f83.pp174cod=f.pp174cod
                   and f83.pp182cod=5
                   --and f83.Pp183con='S'
                   and not exists (select pp182cod from fpp183 where pp174cod=f.pp174cod and pp183con='S' and pp182cod in(8,10,11))
                   --- no se considera
           inner join /*fpp186 f86*/ jaqz442 z42 
                   on z42.pp174cod=f.pp174cod
                  and z42.pp173cod=f.pp173cod
                  AND qz440codre=(select max(qz440codre) FROM jaqz442 where pp174cod=f.pp174cod)
           inner join /*fpp179 f79*/ jaqz440 z40
                   on z40.qz440codre=z42.qz440codre
                  and z40.qz440sts='PREPARADO'
           inner join /*fpp185 f85*/ jaqz441 z41
                   on  z41.qz440codre=z40.qz440codre
                  and  z41.pp177codd=1 -- aqui indico que quiero la de la fecha de remate.
      where f.pp175suc=vhsucur
			and f.pp175tco='S';
			
			ld_fcvto date;
			ln_dias number;
			
			begin
			--Modificacion Enviada por HENRY SUAREZ
			--Martes, 12 DE NOVIEMBRE DEL 2015
			--Actualizado el LUNES, 18 de NOVIEMBRE de 2015 18:30
			--OPEN DATA FOR
      --SP_CR_LIMPIAR_TABLA('JAQZ410');
      delete from jaqz410 where jaqz410CSUC=vhsucur; --and jaqz410fat=fa_s ;
      select pgfape into fa_s from fst017 where pgcod=1;
						
								for i in listado loop								
									 begin
											select ff.aofvto
												into ld_fcvto
												from fsd010 ff 
											 where FF.PGCOD  = i.codempresa
												 AND FF.AOMOD  = i.modulo
												 AND FF.AOSUC  = i.sucursal
												 AND FF.AOMDA  = i.moneda
												 AND FF.AOPAP  = i.papel
												 AND FF.AOCTA  = i.cuenta
												 AND FF.AOOPER = i.operacion
												 AND FF.AOSBOP = i.suboperacion 
												 AND FF.AOTOPE = i.tipooperacion
												 AND FF.AOSTAT <> 41
												 AND FF.AOSTAT <> 99;
									exception when no_data_found then
														ld_fcvto := null;			 
									 end;			 

									if ld_fcvto is not null then 
											 ln_dias := (fa_s -ld_fcvto) ;
											 if ln_dias >= Datrz and ln_dias <= datrzf then
												 --- INSERTAMOS LOS DATOS
												 INSERT INTO JAQZ410
															(													 
															 JAQZ410DAT,
															 JAQZ410CTA,
															 JAQZ410OPE,
															 JAQZ410LTE,
															 JAQZ410CSUC,
															 JAQZ410SUC,
															 JAQZ410CLI,
															 JAQZ410DIR,
															 JAQZ410DIS,
															 JAQZ410FTO,
															 JAQZ410FAT,
															 JAQZ410FRMT,
															 jaqz410crmt
															 )
													values 
															 (ln_dias, 
																i.cuenta , 
																i.operacion,
																i.lote,
																i.sucursal,
																i.nsucursal,
																trim(i.cliente),
																trim(i.direccion),
																trim(i.distrito),
																ld_fcvto,
																fa_s,
																i.fremate,
																i.cremate
															 );
												end if; 
												--commit; 
									end if;												 
								end loop;
								commit; 
			/*
      INSERT INTO JAQZ410
      (
             JAQZ410DAT,
             JAQZ410CTA,
             JAQZ410OPE,
             JAQZ410LTE,
             JAQZ410CSUC,
             JAQZ410SUC,
             JAQZ410CLI,
             JAQZ410DIR,
             JAQZ410DIS,
             JAQZ410FTO,
             JAQZ410FAT,
             JAQZ410FRMT,
             JAQZ410CRMT
      )
      Select (fa_s - ff.aofvto ) Atraso,
             f.pp175cta          cuenta,
             f.pp175oper         operacion,
             f.pp174cod          lote,
             f.pp175suc          csucursal,
             trim(p.scnom)       sucursal,
             trim(s.penom)       cliente,
             trim(c.sngc13dir)   direccion,
             trim(g.fst071dsc)   distrito,
             ff.aofvto           fvencimiento,
             fa_s                fatraso,
             f85.pp185dfec       fremate,
             f85.pp179codre      cremate

      From Fpp175 f
           inner join fst001 p
                   on p.pgcod = f.pp173cod
                  and p.sucurs = f.pp175suc
           
					 inner join fsd010 ff
                   on ff.pgcod = f.pp173cod
                  and ff.aomod = f.pp175mod
                  and ff.aosuc = f.pp175suc
                  and ff.aomda = f.pp175mda
                  and ff.aopap = f.pp175pap
                  and ff.aocta = f.pp175cta
                  and ff.aooper = f.pp175oper
                  and ff.aosbop = f.pp175sbop
                  and ff.aotope = f.pp175tope

           inner join fsr008 r
                   on r.pgcod = p.pgcod
                  and r.ctnro = f.pp175cta
                  and r.cttfir = 'T'
           inner join fsd001 s
                   on s.pepais = r.pepais
                  and s.petdoc = r.petdoc
                  and s.pendoc = r.pendoc
           inner join sngc13 c
                   on c.sngc13pais = s.pepais
                  and c.sngc13tdoc = s.petdoc
                  and c.sngc13ndoc = s.pendoc
                  and c.docod = 1
           inner join fst071 g
                   on g.fst071pai = c.sngc13pais
                  and g.fst071col = c.sngc13dist
           -- se agregan estos inner join para incluir la fecha del remate
           inner join fpp183 f83
                   on f83.pp174cod=f.pp174cod
                   and f83.pp182cod=5
                   --and f83.Pp183con='S'
                   and not exists (select pp182cod from fpp183 where pp174cod=f.pp174cod and pp182cod in(8,10,11))
                   --- no se considera
           inner join fpp186 f86
                   on f86.pp174cod=f.pp174cod
                  and f86.pp173cod=f.pp173cod
                  AND PP179CODRE=(select max(PP179CODRE) FROM fpp186 where pp174cod=f.pp174cod)
           inner join fpp179 f79
                   on f79.pp179codre=f86.pp179codre
                  and f79.pp179sts='PREPARADO'
           inner join fpp185 f85
                   on f85.pp179codre=f79.pp179codre
                   and f85.pp177codd=1 -- aqui indico que quiero la de la fecha de remate.
      where f.pp175suc=vhsucur
      and   (fa_s - ff.aofvto)>= Datrz

      group by fa_s,
               ff.aofvto,
               f.pp175cta,
               f.pp175oper,
               f.pp174cod,
               f.pp175suc,
               trim(p.scnom),
               trim(s.penom),
               trim(c.sngc13dir),
               trim(g.fst071dsc),
               F85.PP185DFEC,
               f85.pp179codre;

      commit;
      */
end sp_cr_remate_credito_prd_nr;


END PQ_CR_AVISOS;
/

