CREATE OR REPLACE PROCEDURE "SP_AH_DATAUBICACION_APERTURA" is

	cursor du_insercion is

		select distinct e.co_unid as COD_UNIDAD,
						trim(a.de_unid) as UNIDAD,
						e.co_sede as COD_SEDE,
						trim(s.de_sede) as SEDE,
						e.co_depa as COD_DEPARTAMENTO,
						d.de_depa as DEPARTAMENTO,
            e.co_area COD_AREA, --
            trim(r.de_area) AREA,
            e.co_secc COD_SECCION,
            trim(h.de_secc) SECCION,--
            e.co_trab COD_TRABAJADOR,
            trim(p.no_apel_pate) as APE_PAT,
            trim(p.no_apel_mate) as APE_MAT,
            trim(p.no_trab) as NOMBRE, --
            i.nu_docu_iden as DNI,
            p.st_sexo as SEXO,
            p.fe_naci_trab FECHA_NACIM,
            p.fe_naci_trab FEC_NAC,
            lower(p.no_dire_mai1) CORREO, --
            e.co_plan COD_PLANILLA,
            l.de_plan PLANILLA,
            rtrim(c.de_pues_trab) as PUES_TRAB,
            e.fe_ingr_empr FECHA_INGRESO,
            e.fe_cese_trab FECHA_CESE,
            case e.ti_situ
                  when 'ANU' then
                   n.de_moti_sepa
                  else
                   ''
                end MOTIVO,
                case e.ti_situ
                  when 'ACT' then
                   'ACTIVO'
                  when 'ANU' then
                   'ANULADO'
                end SITUACION_TRABAJADOR

		from tmtrab_pers@ofiplan p
		left outer join tmtrab_empr@ofiplan e
		on p.co_trab = e.co_trab
		left outer join ttpues_trab@ofiplan c
		on e.co_pues_trab = c.co_pues_trab
		left outer join tmunid_empr@ofiplan a
		on e.co_unid = a.co_unid
    left outer join ttsede@ofiplan s
		on e.co_sede = s.co_sede
      left outer join ttarea@ofiplan r
    on e.co_area = r.co_area
   and e.co_depa = r.co_depa
    left outer join ttsecc@ofiplan h
    on e.co_secc = h.co_secc
   and e.co_depa = h.co_depa
   and e.co_area = h.co_area
		left outer join ttdepa@ofiplan d
		on e.co_depa = d.co_depa
   left outer join ttplan@ofiplan l
    on e.co_plan = l.co_plan
  left outer join ttmoti_sepa@ofiplan n
    on e.co_moti_sepa = n.co_moti_sepa
  left outer join tdiden_trab@ofiplan i
    on p.co_trab = i.co_trab
   and ti_docu_iden = 'DNI'
  left outer join tdlice_trab@ofiplan m
    on p.co_trab = m.co_trab
   and co_tipo_lice = 'SPP'
  order by 13;

		 -- para el cursor
	   le_CODUNIDAD VARCHAR2(3)   := null;
	   la_UNIDAD    VARCHAR2(100) := null;
	   le_CODSEDE   VARCHAR2(10)  := null;
	   ls_SEDE      VARCHAR2(100) := null;
	   le_CODDEPARTAMENTO VARCHAR2(20)  := null;
	   ld_DEPARTAMENTO    VARCHAR2(100) := null;
       le_CODAREA         VARCHAR2(20)  := null;
       lr_AREA            VARCHAR2(100) := null;
       le_CODSECCION      VARCHAR2(10)  := null;
       lh_SECCION         VARCHAR2(100) := null;
       le_CODTRABAJADOR   VARCHAR2(20)  := null;
       lp_APEPAT          VARCHAR2(50)  := null;
       lp_APEMAT          VARCHAR2(50)  := null;
       lp_NOMBRE          VARCHAR2(100) := null;
       li_DNI             VARCHAR2(20)  := null;
       lp_SEXO            VARCHAR2(1)   := null;
       lp_FECHANACIM      DATE          := null;
       lp_FECNAC          DATE          := null;
       lp_CORREO          VARCHAR2(100) := null;
       le_CODPLANILLA     VARCHAR2(3)   := null;
       ll_PLANILLA        VARCHAR2(50)  := null;
       lc_PUESTRAB        VARCHAR2(100) := null;
       le_FECHAINGRESO    DATE          := null;
       le_FECHACESE       DATE          := null;
       ln_MOTIVO          VARCHAR2(250) := null;
       le_SITUACIONTRABAJADOR  VARCHAR2(20) := null;
BEGIN  
	for i in du_insercion --Recorre el cursor por i (fila) 

	loop
	 le_CODUNIDAD       := trim(i.COD_UNIDAD);
     la_UNIDAD          := trim(i.UNIDAD);
     le_CODSEDE         := trim(i.COD_SEDE);
	 ls_SEDE 	        := trim(i.SEDE);
     le_CODDEPARTAMENTO := trim(i.COD_DEPARTAMENTO);
     ld_DEPARTAMENTO 	:= trim(i.DEPARTAMENTO);
	 le_CODAREA         := trim(i.COD_AREA);
     lr_AREA            := trim(i.AREA);
     le_CODSECCION      := trim(i.COD_SECCION);
     lh_SECCION         := trim(i.SECCION);
     le_CODTRABAJADOR   := trim(i.COD_TRABAJADOR);
     lp_APEPAT          := trim(i.APE_PAT);
     lp_APEMAT          := trim(i.APE_MAT);
     lp_NOMBRE          := trim(i.NOMBRE);
     li_DNI             := trim(i.DNI);
     lp_SEXO            := trim(i.SEXO);
     lp_FECHANACIM      := trim(i.FECHA_NACIM);
     lp_FECNAC          := trim(i.FEC_NAC);
     lp_CORREO          := trim(i.CORREO);
     le_CODPLANILLA     := trim(i.COD_PLANILLA);
     ll_PLANILLA        := trim(i.PLANILLA);
     lc_PUESTRAB        := trim(i.PUES_TRAB);
     le_FECHAINGRESO    := trim(i.FECHA_INGRESO);
     le_FECHACESE       := trim(i.FECHA_CESE);
     ln_MOTIVO          := trim(i.MOTIVO);
     le_SITUACIONTRABAJADOR := trim(i.SITUACION_TRABAJADOR);

		INSERT INTO JAQN77
		(JAQN77CODU,JAQN77UNI,JAQN77CSE,JAQN77SEDE,JAQN77CDEP,JAQN77DEP,JAQN77CAR,JAQN77ARE,JAQN77COS,JAQN77SEC,JAQN77CTR,JAQN77APP,JAQN77APM,JAQN77NOM,JAQN77DNI,JAQN77SEX,JAQN77FNAC,JAQN77FNM,JAQN77COR,JAQN77CPL,JAQN77PLA,JAQN77PTR,JAQN77FING,JAQN77FCES,JAQN77MOV,JAQN77SITU)
		VALUES(le_CODUNIDAD, la_UNIDAD, le_CODSEDE, ls_SEDE,
		le_CODDEPARTAMENTO, ld_DEPARTAMENTO, le_CODAREA , lr_AREA ,
		le_CODSECCION, lh_SECCION, le_CODTRABAJADOR, lp_APEPAT, lp_APEMAT,
		lp_NOMBRE, li_DNI, lp_SEXO, lp_FECHANACIM, lp_FECNAC, lp_CORREO,
		le_CODPLANILLA, ll_PLANILLA, lc_PUESTRAB, le_FECHAINGRESO,
		le_FECHACESE, ln_MOTIVO, le_SITUACIONTRABAJADOR);

	end loop;
     commit;
	  exception
	    when others then
         dbms_output.put_line('error');

end SP_AH_DATAUBICACION_APERTURA;
/

