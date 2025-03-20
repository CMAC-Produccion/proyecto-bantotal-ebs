create or replace package PQ_CR_PRENDARIO_HS is

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
procedure sp_addest_desmontado(fechaini in date,fechafin in date,usuario in varchar);
-----------------------------------------------------------------------
procedure sp_addest_desmontadoxf(fechaini in date,fechafin in date,fechadedesmontaje in date,usuario in varchar);
-----------------------------------------------------------------------
procedure sp_addest_desmontadoxl(fechaini in date,fechafin in date,lote in number,usuario in varchar );
-----------------------------------------------------------------------
procedure sp_delest_desmontado(fechaini in date,fechafin in date,usuario in varchar);
-----------------------------------------------------------------------
procedure sp_delest_desmontadoxl(fechaini in date,fechafin in date,lote in number,usuario in varchar);
-----------------------------------------------------------------------
procedure sp_extest_desmontado(fechaini in date,fechafin in date,usuario in varchar);
-----------------------------------------------------------------------
procedure sp_extest_desmontadoxl(fechaini in date,fechafin in date,lote in number,usuario in varchar);
-----------------------------------------------------------------------
function FN_CR_MAXCORRLOTE(lote IN NUMBER) return number;
-----------------------------------------------------------------------
procedure sp_monto_cancelacion(lv_pgcod in number,lv_scsuc in number,lv_sccta in number,lv_scoper in number,lv_scmod in number,tcancl out number,fcancl out varchar2);
-----------------------------------------------------------------------

end PQ_CR_PRENDARIO_HS;
/

create or replace package body PQ_CR_PRENDARIO_HS is

procedure sp_addest_desmontado(fechaini in date,fechafin in date,usuario in varchar)
is
cursor listado is
               select
                    PP173COD,
                    pp174cod
               from
                    fpp183 p83
               where p83.pp182cod=10
                    and p83.pp183con='S'
                    and p83.pp183fec>=fechaini
                    and p83.pp183fec<=fechafin
                    and p83.pp183cod=(select max(pp183cod) from fpp183 where pp183con='S' and pp174cod=p83.pp174cod);


    ln_pp173cod number;
    ln_pp174cod number;
    ln_corr     number;
    ln_fecha    date;
    ln_pp182cod number;
    ln_pp183con char;

    begin
         for i in listado loop

                     ln_pp173cod  :=  i.pp173cod;
                     ln_pp174cod  :=  i.pp174cod;
                     ln_corr      :=  fn_cr_maxcorrlote(ln_pp174cod);
                     ln_fecha     :=  trunc(sysdate);
                     ln_pp182cod  :=  12;
                     ln_pp183con  :=  'S';

                  if ln_pp174cod is not null then
                         insert into FPP183
                                           (
                                              PP173COD,
                                              PP174COD,
                                              PP183COD,
                                              PP183FEC,
                                              PP182COD,
                                              PP183CON,
                                              PP183AUX1
                                           )
                                    values (  ln_pp173cod,
                                              ln_pp174cod,
                                              ln_corr,
                                              ln_fecha,
                                              --fechadedesmontaje,
                                              ln_pp182cod,
                                              ln_pp183con,
                                              to_char(ln_fecha,'YYYYMMDD')
                                           );
                                    commit;
                        insert into jaqz425
                                           (
                                              jaqz425lot,
                                              jaqz425corr,
                                              jaqz425est,
                                              jaqz425usu,
                                              jaqz425fec,
                                              jaqz425tim
                                           )
                                     values (
                                              ln_pp174cod,
                                              ln_corr,
                                              ln_pp183con,
                                              usuario,
                                              ln_fecha,
                                              to_char(sysdate,'HH24:MI:SS')

                                            );
                                    commit;
									end if;
								end loop;
end;

procedure sp_addest_desmontadoxf(fechaini in date,fechafin in date,fechadedesmontaje in date,usuario in varchar)
is
cursor listado is
               select
                    PP173COD,
                    pp174cod
               from
                    fpp183 p83
               where p83.pp182cod=10
                    and p83.pp183con='S'
            				and p83.pp183fec>=fechaini
										and p83.pp183fec<=fechafin
										and p83.pp183cod=(select max(pp183cod) from fpp183 where pp183con='S' and pp174cod=p83.pp174cod);


		ln_pp173cod number;
		ln_pp174cod number;
		ln_corr     number;
		ln_fecha    date;
		ln_pp182cod number;
		ln_pp183con char;

		begin
				 for i in listado loop

				             ln_pp173cod  :=  i.pp173cod;
										 ln_pp174cod  :=  i.pp174cod;
										 ln_corr      :=  fn_cr_maxcorrlote(ln_pp174cod);
										 ln_fecha     :=  trunc(sysdate);
										 ln_pp182cod  :=  12;
										 ln_pp183con  :=  'S';

                  if ln_pp174cod is not null then
                         insert into FPP183
																					 (
																							PP173COD,
																							PP174COD,
																							PP183COD,
																							PP183FEC,
																							PP182COD,
																							PP183CON,
																							PP183AUX1
																					 )
																    values (  ln_pp173cod,
																		          ln_pp174cod,
																							ln_corr,
																							--ln_fecha,
																							fechadedesmontaje,
																							ln_pp182cod,
																							ln_pp183con,
																							to_char(ln_fecha,'YYYYMMDD')
																					 );
																		commit;
												insert into jaqz425
												                   (
	                                            jaqz425lot,
																							jaqz425corr,
																							jaqz425est,
																							jaqz425usu,
																							jaqz425fec,
																							jaqz425tim
																					 )
																		 values (
																		          ln_pp174cod,
																							ln_corr,
																							ln_pp183con,
																							usuario,
																							ln_fecha,
																							to_char(sysdate,'HH24:MI:SS')

																		        );
													          commit;
									end if;
								end loop;
end;
procedure sp_addest_desmontadoxl(fechaini in date,fechafin in date,lote in number,usuario in varchar )
is

cursor listado is
               select
                    PP173COD,
                    pp174cod
               from
                    fpp183 p83
               where p83.pp182cod=10
                    and p83.pp183con='S'
            				and p83.pp183fec>=fechaini
										and p83.pp183fec<=fechafin
										and p83.pp174cod=lote
										and p83.pp183cod=(select max(pp183cod) from fpp183 where pp183con='S' and pp174cod=p83.pp174cod);


		ln_pp173cod number;
		ln_pp174cod number;
		ln_corr     number;
		ln_fecha    date;
		ln_pp182cod number;
		ln_pp183con char;

		begin
				 for i in listado loop

				             ln_pp173cod  :=  i.pp173cod;
										 ln_pp174cod  :=  i.pp174cod;
										 ln_corr      :=  fn_cr_maxcorrlote(ln_pp174cod);
										 ln_fecha     :=  trunc(sysdate);
										 ln_pp182cod  :=  12;
										 ln_pp183con  :=  'S';

                  if ln_pp174cod is not null then
                         insert into FPP183
																					 (
																							PP173COD,
																							PP174COD,
																							PP183COD,
																							PP183FEC,
																							PP182COD,
																							PP183CON,
																							PP183AUX1
																					 )
																    values (  ln_pp173cod,
																		          ln_pp174cod,
																							ln_corr,
																							ln_fecha,
																							ln_pp182cod,
																							ln_pp183con,
																							to_char(ln_fecha,'YYYYMMDD')
																					 );
																		commit;

																		insert into jaqz425
												                   (
	                                            jaqz425lot,
																							jaqz425corr,
																							jaqz425est,
																							jaqz425usu,
																							jaqz425fec,
																							jaqz425tim
																					 )
																		 values (
																		          ln_pp174cod,
																							ln_corr,
																							ln_pp183con,
																							usuario,
																							ln_fecha,
																							to_char(sysdate,'HH24:MI:SS')
																		        );
												             commit;
									end if;
								end loop;
end;
procedure sp_delest_desmontado(fechaini in date,fechafin in date,usuario in varchar)
is
cursor listado is
               select
                    PP173COD,
                    pp174cod,
										pp183cod
               from
                    fpp183 p83
               where p83.pp182cod=12
                    and p83.pp183con='S'
            				and p83.pp183fec>=fechaini
										and p83.pp183fec<=fechafin
										and p83.pp183cod=(select max(pp183cod) from fpp183 where pp183con='S' and pp174cod=p83.pp174cod);


		ln_pp173cod number;
		ln_pp174cod number;
		ln_corr     number;
		ln_fecha    date;
		ln_pp182cod number;
		ln_pp183con char;
    
		begin
               for i in listado loop

				             ln_pp173cod  :=  i.pp173cod;
										 ln_pp174cod  :=  i.pp174cod;
										 ln_corr      :=  i.pp183cod;
										 ln_fecha     :=  trunc(sysdate);
										 ln_pp182cod  :=  12;
										 ln_pp183con  :=  'D';

								 if ln_pp174cod is not null then
										 
										         delete
														    from
														    	fpp183 p83
														 where p83.pp182cod=12
																	and p83.pp183con='S'
																	and p83.pp183fec>=fechaini
																	and p83.pp183fec<=fechafin
																	and p83.pp174cod=ln_pp174cod
																	and p83.pp183cod=ln_corr;
														 commit;
													
										 insert into jaqz425
																				 (
																								jaqz425lot,
																								jaqz425corr,
																								jaqz425est,
																								jaqz425usu,
																								jaqz425fec,
																								jaqz425tim
																				 )
																	values (
																								ln_pp174cod,
																								ln_corr,
																								'D',
																								usuario,
																								ln_fecha,
																								to_char(sysdate,'HH24:MI:SS')
																				 );
										 commit;	
								 end if;		
						   end loop;
							 
      

end;

procedure sp_delest_desmontadoxl(fechaini in date,fechafin in date,lote in number,usuario in varchar)
is
cursor listado is
               select
                    PP173COD,
                    pp174cod,
										pp183cod
               from
                    fpp183 p83
               where p83.pp182cod=12
                    and p83.pp183con='S'
            				and p83.pp183fec>=fechaini
										and p83.pp183fec<=fechafin
										and p83.pp174cod=lote
										and p83.pp183cod=(select max(pp183cod) from fpp183 where pp183con='S' and pp174cod=p83.pp174cod);


		ln_pp173cod number;
		ln_pp174cod number;
		ln_corr     number;
		ln_fecha    date;
		ln_pp182cod number;
		ln_pp183con char;
    
		begin
               for i in listado loop

				             ln_pp173cod  :=  i.pp173cod;
										 ln_pp174cod  :=  i.pp174cod;
										 ln_corr      :=  i.pp183cod;
										 ln_fecha     :=  trunc(sysdate);
										 ln_pp182cod  :=  12;
										 ln_pp183con  :=  'D';

								 if ln_pp174cod is not null then
										 
										         delete
														    from
														    	fpp183 p83
														 where p83.pp182cod=12
																	and p83.pp183con='S'
																	and p83.pp183fec>=fechaini
																	and p83.pp183fec<=fechafin
																	and p83.pp174cod=ln_pp174cod
																	and p83.pp183cod=ln_corr;
														 commit;
													
										 insert into jaqz425
																				 (
																								jaqz425lot,
																								jaqz425corr,
																								jaqz425est,
																								jaqz425usu,
																								jaqz425fec,
																								jaqz425tim
																				 )
																	values (
																								ln_pp174cod,
																								ln_corr,
																								'D',
																								usuario,
																								ln_fecha,
																								to_char(sysdate,'HH24:MI:SS')
																				 );
										 commit;	
								 end if;		
						   end loop;
							 
      

end;
procedure sp_extest_desmontado(fechaini in date,fechafin in date,usuario in varchar)
is
cursor listado is
               select
                    PP173COD,
                    pp174cod
               from
                    fpp183 p83
               where p83.pp182cod=12
                    and p83.pp183con='S'
            				and p83.pp183fec>=fechaini
										and p83.pp183fec<=fechafin
										and p83.pp183cod=(select max(pp183cod) from fpp183 where pp183con='S' and pp174cod=p83.pp174cod);


		ln_pp173cod number;
		ln_pp174cod number;
		ln_corr     number;
		ln_fecha    date;
		ln_pp182cod number;
		ln_pp183con char;
    
		begin
               for i in listado loop

				             ln_pp173cod  :=  i.pp173cod;
										 ln_pp174cod  :=  i.pp174cod;
										 ln_corr      :=  (fn_cr_maxcorrlote(ln_pp174cod)-1);
										 ln_fecha     :=  trunc(sysdate);
										 ln_pp182cod  :=  12;
										 ln_pp183con  :=  'S';

								 if ln_pp174cod is not null then
										 
										 update
													fpp183 p83
											 set p83.pp183con = 'E'
										 where p83.pp182cod = ln_pp182cod
													and p83.pp174cod=ln_pp174cod
													and p83.pp183con=ln_pp183con
													and p83.pp183fec>=fechaini
													and p83.pp183fec<=fechafin
													and p83.pp183cod=ln_corr;
													
										 insert into jaqz425
																				 (
																								jaqz425lot,
																								jaqz425corr,
																								jaqz425est,
																								jaqz425usu,
																								jaqz425fec,
																								jaqz425tim
																				 )
																	values (
																								ln_pp174cod,
																								ln_corr,
																								'E',
																								usuario,
																								ln_fecha,
																								to_char(sysdate,'HH24:MI:SS')
																				 );
										 commit;	
								 end if;		
						   end loop;
end;

procedure sp_extest_desmontadoxl(fechaini in date,fechafin in date,lote in number,usuario in varchar)
is
cursor listado is
               select
                    PP173COD,
                    pp174cod
               from
                    fpp183 p83
               where p83.pp182cod=12
                    and p83.pp183con='S'
										and p83.pp174cod=lote
            				and p83.pp183fec>=fechaini
										and p83.pp183fec<=fechafin
										and p83.pp183cod=(select max(pp183cod) from fpp183 where pp183con='S' and pp174cod=p83.pp174cod);


		ln_pp173cod number;
		ln_pp174cod number;
		ln_corr     number;
		ln_fecha    date;
		ln_pp182cod number;
		ln_pp183con char;
    
		begin
               for i in listado loop

				             ln_pp173cod  :=  i.pp173cod;
										 ln_pp174cod  :=  i.pp174cod;
										 ln_corr      :=  (fn_cr_maxcorrlote(ln_pp174cod)-1);
										 ln_fecha     :=  trunc(sysdate);
										 ln_pp182cod  :=  12;
										 ln_pp183con  :=  'S';

								 if ln_pp174cod is not null then
										 
										 update
													fpp183 p83
											 set p83.pp183con = 'E'
										 where p83.pp182cod = ln_pp182cod
													and p83.pp174cod=ln_pp174cod
													and p83.pp183con=ln_pp183con
													and p83.pp183fec>=fechaini
													and p83.pp183fec<=fechafin
													and p83.pp183cod=ln_corr;
													
										 insert into jaqz425
																				 (
																								jaqz425lot,
																								jaqz425corr,
																								jaqz425est,
																								jaqz425usu,
																								jaqz425fec,
																								jaqz425tim
																				 )
																	values (
																								ln_pp174cod,
																								ln_corr,
																								'E',
																								usuario,
																								ln_fecha,
																								to_char(sysdate,'HH24:MI:SS')
																				 );
										 commit;	
								 end if;		
						   end loop;
end;

function FN_CR_MAXCORRLOTE(lote IN NUMBER) return number is
  correlativo number(3) :=0;

  begin
       select f3.pp183cod
           into correlativo
         from fpp183 f3
              where f3.pp174cod=lote
                and f3.pp183cod= (select max(pp183cod) from fpp183 where pp174cod=f3.pp174cod);
       correlativo := correlativo+1;
       return correlativo;
end FN_CR_MAXCORRLOTE;

procedure sp_monto_cancelacion(lv_pgcod in number,lv_scsuc in number,lv_sccta in number,lv_scoper in number,lv_scmod in number,tcancl out number,fcancl out varchar2)
is
    ln_itf number(17,2);
		ln_capital number(17,2);
		ln_interes number(17,2);
		ln_mora    number(17,2);
		ln_nrel    number;
		ln_total   number(17,2);
		ln_fecha   date;
		flag       char(1);		
		-------------------------
		ln_pgcod   number;
		ln_suc     number;
		ln_mod     number;
		ln_tran    number;
		ln_rel     number;
		ln_sbor    number;
		ln_fcon    date;
		-------------------------
		begin
		   begin        
	       	
				 select 'S',
				        d16.pgcod,
								d16.itsuc,
								d16.itmod,
								d16.ittran,
								d16.itnrel,
								d16.itsbor,
								d16.itfval 
					 into flag,
					      ln_pgcod,
								ln_suc,
								ln_mod,
								ln_tran,
								ln_rel,
								ln_sbor,
								ln_fecha
					 from fsd015 d5,fsd016 d16 where 
					          d16.ctnro=lv_sccta 
						        and d16.itsucd=lv_scsuc 
						        and d16.itoper=lv_scoper
										and d16.ittran=d5.ittran 
										and d16.itmod=d5.itmod
										and d16.itnrel=d5.itnrel 
										and d16.modulo=lv_scmod
										and d5.itcont='S'
										and d16.itord=10 
										and d5.pgcod=1 
										and d5.itmod=30 
										and d5.ittran=974 
										and rownum=1;
			 exception 
		   when others then
			      flag:='N';
						begin
								select 
										h16.pgcod,
										h16.hsucor,
										h16.hcmod,
										h16.htran,
										h16.hnrel,
										h16.hcsubo,
										h16.hfcon,
										h16.hfval
									 into
										ln_pgcod,
										ln_suc,
										ln_mod,
										ln_tran,
										ln_rel,
										ln_sbor,
										ln_fcon,
										ln_fecha
									from fsh015 h5,fsh016 h16                   
									where h16.hcta  =lv_sccta
										and h16.hsucor=h5.hsucor 
										and h16.hsucur=lv_scsuc
										and h16.hoper =lv_scoper 
										and h16.htran =h5.htran 
										and h16.hcmod =h5.hcmod
										and h16.hnrel =h5.hnrel
										and h16.hfval =h5.hfcon 
										and h16.hmodul=lv_scmod
										and h5.pgcod =1 
										and h16.hcord=10
										and h5.hcmod =30  
										and h5.htran=974;
						exception
						when others then
						     ln_pgcod:=0 ;
								 ln_suc:=0;
								 ln_mod:=0;
								 ln_tran:=0;
								 ln_rel:=0;
								 ln_sbor:=0;
								 --ln_fcon:='10/10/2001';
								 --ln_fecha:='10/10/2001';
						end;
			 end;
			 
			 if flag='S' then
			    begin			    
						select 
							 d16.itimp1						 
							into
							 ln_capital	
						 from fsd016 d16                        
									where  
												d16.itsuc=ln_suc
										and d16.itsbor=ln_sbor
										and d16.itnrel=ln_rel
										and d16.itord=83
										--and d5.itcont='S' 
										and d16.pgcod=1 
										and d16.itmod=30
										and d16.ittran=974
										and d16.modulo=50;
					 exception
					 when others then 
					      ln_capital:=0;
					end;
			 else
			     begin
						 select 
								h16.hcimp1
							 into
								ln_capital								
							from fsh016 h16                   
							where 
								    h16.hsucor=ln_suc
								and h16.hcsubo=ln_sbor
								and h16.hnrel =ln_rel 
								and h16.hfcon =ln_fecha
								and h16.pgcod =1 
								and h16.hcord =83
								and h16.hcmod =30  
								and h16.hmodul=50
								and h16.htran =974;    
					  exception
						when no_data_found then
						   ln_capital    := 0;
						end;
			 end if;
			 --TOTAL
			 ln_total:= ln_capital; /* +ln_interes+ln_mora+ln_itf; */
       tcancl:=ln_total;
			 
			 fcancl:=concat( to_char (to_date ( ln_fecha,'DD/MM/RRRR'),'dd','NLS_DATE_LANGUAGE=SPANISH'),concat(' de ',
concat(trim(to_char (to_date ( ln_fecha,'DD/MM/RRRR'),'month','NLS_DATE_LANGUAGE=SPANISH')),
concat(' del ',concat(trim(to_char (to_date ( ln_fecha,'DD/MM/RRRR'),'yyyy','NLS_DATE_LANGUAGE=SPANISH')),'.')))));

			 --fcancl:=ln_fecha;
end;

end PQ_CR_PRENDARIO_HS;
/

