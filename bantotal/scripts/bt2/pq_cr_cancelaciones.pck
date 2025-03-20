create or replace package PQ_CR_CANCELACIONES is
    -- *****************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE BANCARIZACION
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.08.22
    -- Autor de Creación          : 
    -- Uso                        : Realiza Calculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    --                              
    --
    -- *****************************************************************
----------------------------------------------------------------------- 
PROCEDURE SP_CR_LIMPIAR_TABLA(table_name VARCHAR2,usuario varchar2);
-----------------------------------------------------------------------
----------------------------------------------------------------------- 
PROCEDURE sp_cr_cancelaciones_x_credito(vpgcod in integer,vfecha_ini in date,vfecha_fin in date,vhsucur in integer,usuario in character);
-----------------------------------------------             
FUNCTION fn_cr_rubro( hrubro in fsh016.hrubro%type,
                      hfcon  in fsh016.hfcon%type,
                      pgcod  in fsh016.pgcod%type,
											hmodul in fsh016.hmodul%type,
											hsucur in fsh016.hsucur%type,
											hmda   in fsh016.hmda%type,
											hpap   in fsh016.hpap%type,
											hcta   in fsh016.hcta%type,
											hoper  in fsh016.hoper%type,
											hsubop in fsh016.hsubop%type,
											htoper in fsh016.htoper%type)
return varchar2;
-------------------------------------------------------------------------
function fn_obtener_nsucursal(cod in int, sucursal in int)
return varchar2;
-------------------------------------------------------------------------
function fn_obtener_region(cod in int,sucursal in int)
return varchar2;
end PQ_CR_CANCELACIONES;
/

create or replace package body PQ_CR_CANCELACIONES is
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


----------------------------------------------------------------------------------------
PROCEDURE SP_CR_LIMPIAR_TABLA(table_name VARCHAR2,usuario varchar2)
 -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 23/10/2015
    -- Autor de Creación          : Henry Angel Suarez Lazarte
    -- Uso                        : Obtencion de las cancelaciones desde donde se creo.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      : 21/04/2016
    -- Autor de la Modificación   : HSUAREZ
    -- Descripción de Modificación: SE AÑADIO USUARIO PARA LIMPIAR EL REG. DE LA TABLA QUE EL USUARIO QUE CONSULTA
    --
    -- *****************************************************************   
     IS
        vn_table_name VARCHAR2(30);
				vn_user_name varchar2(50);
        str varchar2(150);
      BEGIN
        vn_table_name := UPPER(LTRIM(RTRIM(table_name)));
				vn_user_name :=upper(LTRIM(RTRIM(usuario)));
        str := 'DELETE FROM  '||vn_table_name||' WHERE Z401USU="'||vn_user_name||'"';
       execute immediate(str);
END SP_CR_LIMPIAR_TABLA;
----------------------------

PROCEDURE sp_cr_cancelaciones_x_credito(vpgcod in integer,vfecha_ini in date,vfecha_fin in date,vhsucur in integer,usuario in character) is
fecha date;
begin 
--Modificacion Enviada por hENRY SUAREZ                           
--Martes, 21 DE OCTUBRE DEL 2015 
--Actualizado el LUNES, 26 de oCTUBRE de 2015 13:00
--OPEN DATA FOR
-- Retorno                    : 
    -- Fecha de Modificación      : 21/04/2016
    -- Autor de la Modificación   : HSUAREZ
    -- Descripción de Modificación: SE AÑADIO USUARIO PARA LIMPIAR EL REG. DE LA TABLA QUE EL USUARIO QUE CONSULTA, SE AGREGO CAMPO USUARIO AL STORE PROCEDURE
    --
    -- *****************************************************************   
--SP_CR_LIMPIAR_TABLA('JAQZ401',usuario);
delete from jaqz401 where z401usu=usuario; --and jaqz401fat=fa_s ;
commit;
fecha:=vfecha_ini;		

while fecha <= vfecha_fin loop
		 		
INSERT INTO JAQZ401
(
       JAQZ401FEC,
       JAQZ401HHR,
       JAQZ401TRN,
       JAQZ401CLI,
       JAQZ401EMP,
       JAQZ401MON,
       JAQZ401CNT,
       JAQZ401OPE,
       JAQZ401SOP,
       JAQZ401TOP,
       JAQZ401MOD,
       JAQZ401SPR,
       JAQZ401MNT,
       JAQZ401SCD,
       JAQZ401TCA,
       JAQZ401IMP,
       JAQZ401SUCT,
       JAQZ401MDO,
       JAQZ401TPO,
       JAQZ401TCR,
       JAQZ401ANA,
       JAQZ401RGO,
       JAQZ401RGT,
			 z401usu
       
)
select h16.hfcon Fecha,
       h15.hhora,
       h16.hcmod||'-'||h16.htran||':'||trim(t34.trnom) Transaccion,
       InitCap(Trim(replace(d1.penom,'"',''))) Cliente,
       h16.pgcod Empresa,
       h16.hmda Moneda,
       h16.hcta Cuenta,
       h16.hoper Operacion,
       h16.hsubop Sub_Oper,
       h16.htoper Tipo_Oper,
       h16.hmodul Modulo,
			 h16.hsucur||'-'||Initcap(trim(fn_obtener_nsucursal(h16.pgcod,h16.hsucur))) Sucursal_Ope,
       decode(h16.hmda,0,'S/.','US$') Moneda_Trx,
       h16.hcimp1 Saldo_Cancelado,
       h16.hcimp6 Total_Cancelacion,
       d10.aoimp ImpOtorgado,
			 fn_obtener_nsucursal(h16.pgcod,h16.hsucor),
       t3.mdnom Modulo,
       t4.tonom Tipo_Oper,
			 fn_cr_rubro(h16.hrubro,h16.hfcon,h16.pgcod,h16.hmodul,h16.hsucur,h16.hmda,h16.hpap,h16.hcta,h16.hoper,h16.hsubop,h16.htoper),
			 
       fn_analista_credito(h16.hmodul,h16.hsucur,h16.hmda,h16.hpap,h16.hcta,h16.hoper,h16.hsubop,h16.htoper) Analista,
       
			 fn_obtener_region(h16.pgcod,h16.hsucur),
			 fn_obtener_region(h16.pgcod,h16.hsucor),
			 usuario

               
  From fsh016 h16  join fsh015 h15 on h15.pgcod = h16.pgcod
                                  and h15.hcmod = h16.hcmod
                                  and h15.hsucor= h16.hsucor
                                  and h15.htran = h16.htran
                                  and h15.hnrel = h16.hnrel
                                  and h15.hfcon = h16.hfcon
                                  and h15.hccorr <> 99 
                  join fst034 t34 on t34.pgcod = h16.pgcod
                                 and t34.trmod = h16.hcmod
                                 and t34.trnro = h16.htran
                  join fsd010 d10 on d10.pgcod = h16.pgcod
                                 and d10.aomod = h16.hmodul
                                 and d10.aosuc = h16.hsucur
                                 and d10.aomda = h16.hmda
                                 and d10.aopap = h16.hpap
                                 and d10.aocta = h16.hcta
                                 and d10.aooper= h16.hoper
                                 and d10.aosbop= h16.hsubop
                                 and d10.aotope= h16.htoper
                                 and d10.aofe99= h16.hfcon
                                 and d10.aostat= 99
                  left join fst003 t3 on t3.modulo = h16.hmodul
                  left join fst004 t4 on t4.modulo = h16.hmodul
                                 and t4.totope = h16.htoper
                  left join fsr008 r8 on r8.ctnro = h16.hcta
                                 and r8.ttcod = 1
                                 and r8.cttfir= 'T'
                  left join fsd001 d1 on d1.pepais= r8.pepais
                                 and d1.petdoc= r8.petdoc
                                 and d1.pendoc= r8.pendoc 

                                                                                             
 where h16.pgcod = vpgcod
   --and h16.hfcon BETWEEN to_date(vfecha_ini) AND to_date(vfecha_fin)   
   and h16.hfcon=fecha
   and h16.hcodmo = 2
   and h16.hmodul in (select modulo from fst111 where dscod = 50)
   and ((h16.hcmod <> 99 and h16.htran <> 994) AND
        (h16.hcmod <> 300 and h16.htran <> 390) AND
        (h16.hcmod <> 300 and h16.htran <> 400)
       )
   AND h16.hsucur = vhsucur;
   commit;
	 fecha:=fecha+1;
 end loop;	
end sp_cr_cancelaciones_x_credito;



FUNCTION fn_cr_rubro( hrubro in fsh016.hrubro%type,
                      hfcon  in fsh016.hfcon%type,
                      pgcod  in fsh016.pgcod%type,
											hmodul in fsh016.hmodul%type,
											hsucur in fsh016.hsucur%type,
											hmda   in fsh016.hmda%type,
											hpap   in fsh016.hpap%type,
											hcta   in fsh016.hcta%type,
											hoper  in fsh016.hoper%type,
											hsubop in fsh016.hsubop%type,
											htoper in fsh016.htoper%type)
return varchar2 is
       v_fcuenta varchar2(100) := '';
       begin
			           if substr(hrubro,1,2)='14' and substr(hrubro,5,2)='02' then 
								        v_fcuenta:='MICROEMPRESAS'; 
								 else
								     if substr(hrubro,1,2)='14' and substr(hrubro,5,2)='03' and substr(hrubro,11,3)='015' then 
								        v_fcuenta:='CONSUMO REVOLVENTE';
										 else
										 		 if substr(hrubro,1,2)='14' and substr(hrubro,5,2)='03' and substr(hrubro,11,3)<>'015' then 
										 				v_fcuenta:='CONSUMO NO REVOLVENTE';
										 		 else
										 		    if substr(hrubro,1,2)='14' and substr(hrubro,5,2)='04' then
										 		 		   v_fcuenta:='HIPOTECARIO';
										 		 	  else
										 		 		   if substr(hrubro,1,2)='14' and substr(hrubro,5,2)='12' then
										 		 			    v_fcuenta:='MEDIANA EMPRESA';
										  		 			 else
										 		 			    if substr(hrubro,1,2)='14' and substr(hrubro,5,2)='13' then 
										 		 					   v_fcuenta:='PEQUEÑA EMPRESA' || ' '|| 
										 		 					   fn_sector_credito(hfcon,pgcod,hmodul,hsucur,hmda,hpap,hcta,hoper,hsubop,htoper);
										 		 			    else
										 		 					   v_fcuenta:='';
										 		 					end if;
												 			 end if;
										 		 		end if;
										 		 end if;
										 end if;
									end if;
              return(v_fcuenta);
end fn_cr_rubro;
function fn_obtener_nsucursal(cod in int, sucursal in int)
return varchar2 is
         nsucursal varchar2(100) := '';
         begin
				 select t1.scnom into nsucursal from
				          fst001 t1 
									       where t1.pgcod = cod
                           and t1.sucurs= sucursal;                          
         return nsucursal;
end fn_obtener_nsucursal;

function fn_obtener_region(cod in int,sucursal in int)
return varchar2 is
         nregion varchar2(100) := '';
				 begin
				 select rs.regnom into nregion from 
									 fst001 t1    
                   inner join fst811 r on r.pgcod = t1.pgcod
                            and r.oficod = (case when t1.sucurs > 900 then 11 else t1.sucurs end)
                            and r.regcod < 100
                   inner join fst810 rs on rs.regcod = r.regcod
                            and r.regcod < 100
                   where t1.pgcod = cod
                     and t1.sucurs= sucursal;
	      return nregion;
				commit;
end fn_obtener_region;

END PQ_CR_CANCELACIONES;
/

