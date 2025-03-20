create or replace package PQ_CR_Calendario is
   procedure Actualiza_Tipo(p_n_aocta in number,
                           p_n_aooper in number,
                           p_n_aosbop in number,
                           p_s_Tipo_New in char,
                           p_s_Tipo_Old in char);
   procedure Actualiza_Fec_Cancel(p_n_aocta in number,
                                 p_n_aooper in number,
                                 p_n_aosbop in number);
   procedure Actualiza_Capital(p_n_aocta in number,
                              p_n_aooper in number,
                              p_n_aosbop in number);
   procedure Elimina_Registros(p_n_aocta in number,
                              p_n_aooper in number,
                              p_n_aosbop in number,
                              p_d_ppfpag in date);
   procedure Actualiza_Seguro(p_n_aocta  in number,
                             p_n_aooper in number,
                             p_n_aosbop in number,
                             p_d_ppfpag in date,
                             p_n_Seguro in number);
   procedure Actualiza_Interes(p_n_aocta  in number,
                              p_n_aooper in number,
                              p_n_aosbop in number,
                              p_d_ppfpag in date,
                              p_n_Interes in number);
   procedure Inserta_Calendario(ps_Tipo in char);
   procedure Actualiza_602Fecha(p_n_aocta  in number,
                                p_n_aooper in number,
                                p_n_aosbop in number,
                                p_n_pp1nump in number,
                                p_d_ppfpag in date);
   procedure Actualiza_602Estado(p_n_aocta  in number,
                                 p_n_aooper in number,
                                 p_n_aosbop in number,
                                 p_n_pp1nump in number,
                                 p_c_pp1stat in char);
end PQ_CR_Calendario;
/

create or replace package body PQ_CR_Calendario is
   procedure Actualiza_Tipo(p_n_aocta in number,
                            p_n_aooper in number,
                            p_n_aosbop in number,
                            p_s_Tipo_New in char,
                            p_s_Tipo_Old in char) is

   pc_error varchar2(2000);

   begin
      ---> Calendario
      begin

         pc_error := '0000';
         update fsd601 d_601
            set d_601.pptipo = p_s_Tipo_New
          where d_601.pgcod  = 1
            and d_601.ppcta  = p_n_aocta
            and d_601.ppoper = p_n_aooper
            and d_601.ppsbop = p_n_aosbop
            and d_601.pptipo = p_s_Tipo_Old;
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;
      ---> Movimientos
      begin

         update fsd602 d_602
            set d_602.pptipo = p_s_Tipo_New
          where d_602.pgcod  = 1
            and d_602.ppcta  = p_n_aocta
            and d_602.ppoper = p_n_aooper
            and d_602.ppsbop = p_n_aosbop
            and d_602.pptipo = p_s_Tipo_Old;
      exception
         when others then
            null;
      end;
      ---> Seguro
      begin

         update fsd611 d_611
            set d_611.pptipo = p_s_Tipo_New
          where d_611.pgcod  = 1
            and d_611.ppcta  = p_n_aocta
            and d_611.ppoper = p_n_aooper
            and d_611.ppsbop = p_n_aosbop
            and d_611.pptipo = p_s_Tipo_Old;
      exception
         when others then
            null;
      end;
      ---> Movimientos-Seguro
      begin

         update fsd612 d_612
            set d_612.pptipo = p_s_Tipo_New
          where d_612.pgcod  = 1
            and d_612.ppcta  = p_n_aocta
            and d_612.ppoper = p_n_aooper
            and d_612.ppsbop = p_n_aosbop
            and d_612.pptipo = p_s_Tipo_Old;
      exception
         when others then
            null;
      end;
      dbms_output.put_line(pc_error);

  insert into AQPB876 values (user,sysdate,'PQ_CR_CALENDARIO.ACTUALIZA_TIPO',   
  p_n_aocta||'-'||p_n_aooper||'-'||p_n_aosbop||'-'||p_s_Tipo_New||'-'||p_s_Tipo_Old);
  commit;
   end Actualiza_Tipo;

   procedure Actualiza_Fec_Cancel(p_n_aocta in number,
                                  p_n_aooper in number,
                                  p_n_aosbop in number) is

   pc_error varchar2(2000);

   begin
      begin

         pc_error := '0000';
         update fsd010 d_010
            set d_010.aofvto = (select max(d_601.ppfpag)
                                  from fsd601 d_601
                                 where d_601.pgcod = 1
                                   and d_601.ppcta  = p_n_aocta 
                                   and d_601.ppoper = p_n_aooper
                                   and d_601.ppsbop = p_n_aosbop)
          where d_010.pgcod  = 1
            and d_010.aocta  = p_n_aocta 
            and d_010.aooper = p_n_aooper
            and d_010.aosbop = p_n_aosbop
            and d_010.aomod in (select t_111.modulo
                                  from fst111 t_111
                                 where t_111.dscod = 50)
            and d_010.aostat <> 99;
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      begin   
         update fsd011 d_011
            set d_011.scfvto = (select max(d_601.ppfpag)
                                  from fsd601 d_601
                                 where d_601.pgcod = 1
                                   and d_601.ppcta  = p_n_aocta 
                                   and d_601.ppoper = p_n_aooper
                                   and d_601.ppsbop = p_n_aosbop)
          where d_011.pgcod  = 1
            and d_011.sccta  = p_n_aocta 
            and d_011.scoper = p_n_aooper
            and d_011.scsbop = p_n_aosbop
            and d_011.scmod in (select t_111.modulo
                                  from fst111 t_111
                                 where t_111.dscod = 50)
            and d_011.scstat <> 99;
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;
      dbms_output.put_line(pc_error);
  INSERT INTO AQPB876 VALUES (USER,SYSDATE,'PQ_CR_CALENDARIO.ACTUALIZA_FEC_CANCEL',   
  P_N_AOCTA||'-'||P_N_AOOPER||'-'||P_N_AOSBOP);
  COMMIT;
   end Actualiza_Fec_Cancel;

   procedure Actualiza_Capital(p_n_aocta in number,
                               p_n_aooper in number,
                               p_n_aosbop in number) is

   pc_error varchar2(2000);

   begin
      ---> Calendario
      begin

         pc_error := '0000';
         update fsd601 d_601
            set d_601.ppcap = (select d_602.pp1cap
                                 from fsd602 d_602
                                where d_602.pgcod = 1
                                  and d_602.ppcta  = p_n_aocta  
                                  and d_602.ppoper = p_n_aooper
                                  and d_602.ppsbop = p_n_aosbop
                                  and d_602.d602co = 'S'
                                  and d_602.pp1nump = (select max(d_602a.pp1nump)
                                                         from fsd602 d_602a
                                                        where d_602a.pgcod = 1
                                                          and d_602a.ppcta  = p_n_aocta 
                                                          and d_602a.ppoper = p_n_aooper
                                                          and d_602a.ppsbop = p_n_aosbop
                                                          and d_602a.d602co = 'S'))
          where d_601.pgcod = 1
            and d_601.ppcta  = p_n_aocta 
            and d_601.ppoper = p_n_aooper
            and d_601.ppsbop = p_n_aosbop
            and d_601.ppfpag = (select max(d_602a.ppfpag)
                                  from fsd602 d_602a
                                 where d_602a.pgcod = 1
                                   and d_602a.ppcta  = p_n_aocta 
                                   and d_602a.ppoper = p_n_aooper
                                   and d_602a.ppsbop = p_n_aosbop
                                   and d_602a.d602co = 'S'
                                   and d_602a.pp1nump = (select max(d_602b.pp1nump)
                                                           from fsd602 d_602b
                                                          where d_602b.pgcod = 1
                                                            and d_602b.ppcta  = p_n_aocta 
                                                            and d_602b.ppoper = p_n_aooper
                                                            and d_602b.ppsbop = p_n_aosbop
                                                            and d_602b.d602co = 'S'));

      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      begin
         ---> Movimientos
         update fsd602 d_602
            set d_602.pp1stat = 'T'
          where d_602.pgcod = 1
            and d_602.ppcta  = p_n_aocta 
            and d_602.ppoper = p_n_aooper
            and d_602.ppsbop = p_n_aosbop
            and d_602.d602co = 'S'
            and d_602.pp1nump = (select max(d_602a.pp1nump)
                                   from fsd602 d_602a
                                  where d_602a.pgcod = 1
                                    and d_602a.ppcta  = p_n_aocta  
                                    and d_602a.ppoper = p_n_aooper
                                    and d_602a.ppsbop = p_n_aosbop
                                    and d_602a.d602co = 'S');
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      dbms_output.put_line(pc_error);
  insert into AQPB876 values (user,sysdate,'PQ_CR_CALENDARIO.ACTUALIZA_CAPITAL',   
  p_n_aocta||'-'||p_n_aooper||'-'||p_n_aosbop);
  commit;
   end Actualiza_Capital;

   procedure Elimina_Registros(p_n_aocta in number,
                               p_n_aooper in number,
                               p_n_aosbop in number,
                               p_d_ppfpag in date) is

   pc_error varchar2(2000);

   begin
      ---> Calendario
      begin

         pc_error := '0000';
         delete
           from fsd601 d_601
          where d_601.pgcod  = 1
            and d_601.ppcta  = p_n_aocta 
            and d_601.ppoper = p_n_aooper
            and d_601.ppsbop = p_n_aosbop
            and d_601.ppfpag > p_d_ppfpag;
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      ---> Seguro
      begin

         delete
           from fsd611 d_611
          where d_611.pgcod  = 1
            and d_611.ppcta  = p_n_aocta 
            and d_611.ppoper = p_n_aooper
            and d_611.ppsbop = p_n_aosbop
            and d_611.ppfpag > p_d_ppfpag;
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      dbms_output.put_line(pc_error);
  insert into AQPB876 values (user,sysdate,'PQ_CR_CALENDARIO.ELIMINA_REGISTROS',   
  p_n_aocta||'-'||p_n_aooper||'-'||p_n_aosbop||'-'||to_char(p_d_ppfpag,'RRRR/MM/DD'));
  commit;
   end Elimina_Registros;

   procedure Actualiza_Seguro(p_n_aocta  in number,
                              p_n_aooper in number,
                              p_n_aosbop in number,
                              p_d_ppfpag in date,
                              p_n_Seguro in number) is

   pc_error varchar2(2000);

   begin
      ---> Seguro
      begin

         pc_error := '0000';
         update fsd611 d_611
            set d_611.ppimp11 = p_n_Seguro,
                d_611.ppimp12 = 0,
                d_611.ppimp13 = 0,
                d_611.ppimp14 = 0,
                d_611.ppfpag = p_d_ppfpag,
                d_611.pptipo = 'F'
          where d_611.pgcod  = 1
            and d_611.ppcta  = p_n_aocta 
            and d_611.ppoper = p_n_aooper
            and d_611.ppsbop = p_n_aosbop
            and d_611.ppfpag = (select max(d_611a.ppfpag)
                                  from fsd611 d_611a
                                 where d_611a.pgcod  = 1
                                   and d_611a.ppcta  = p_n_aocta 
                                   and d_611a.ppoper = p_n_aooper
                                   and d_611a.ppsbop = p_n_aosbop);
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      dbms_output.put_line(pc_error);
  insert into AQPB876 values (user,sysdate,'PQ_CR_CALENDARIO.ACTUALIZA_SEGURO',   
  p_n_aocta||'-'||p_n_aooper||'-'||p_n_aosbop||'-'||to_char(p_d_ppfpag,'RRRR/MM/DD')||'-'||p_n_Seguro);
  commit;
   end Actualiza_Seguro;

   procedure Actualiza_Interes(p_n_aocta  in number,
                               p_n_aooper in number,
                               p_n_aosbop in number,
                               p_d_ppfpag in date,
                               p_n_Interes in number) is

   pc_error varchar2(2000);

   begin
      ---> Capital-Interes
      begin

         pc_error := '0000';
         update fsd601 d_601
            set d_601.ppcap = (select abs(d_011.scsdo)
                                 from fsd011 d_011
                                inner join fst111 t_111
                                   on t_111.modulo = d_011.scmod
                                where d_011.pgcod  = 1
                                  and d_011.sccta  = p_n_aocta 
                                  and d_011.scoper = p_n_aooper
                                  and d_011.scsbop = p_n_aosbop
                                  and d_011.scstat <> 99
                                  and t_111.dscod  = 50),
                d_601.ppint  = p_n_Interes,
                d_601.d601fc = p_d_ppfpag,
                d_601.ppfpag = p_d_ppfpag,
                d_601.ppfval = p_d_ppfpag,
                d_601.ppfvto = p_d_ppfpag,
                d_601.Pppzo = 0,
                d_601.Pptipo = 'F'
          where d_601.pgcod  = 1
            and d_601.ppcta  = p_n_aocta 
            and d_601.ppoper = p_n_aooper
            and d_601.ppsbop = p_n_aosbop
            and d_601.ppfpag = ((select min(d_601a.ppfpag)
                                   from fsd601 d_601a
                                  where d_601a.pgcod  = 1
                                    and d_601a.ppcta  = p_n_aocta 
                                    and d_601a.ppoper = p_n_aooper
                                    and d_601a.ppsbop = p_n_aosbop
                                    and d_601a.ppfpag > (select max(d_602.ppfpag)
                                                           from fsd602 d_602
                                                          where d_602.pgcod  = 1
                                                            and d_602.ppcta  = p_n_aocta 
                                                            and d_602.ppoper = p_n_aooper
                                                            and d_602.ppsbop = p_n_aosbop
                                                            and d_602.d602co = 'S'
                                                            and d_602.pp1stat = 'T')));
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      dbms_output.put_line(pc_error);
  insert into AQPB876 values (user,sysdate,'PQ_CR_CALENDARIO.ACTUALIZA_INTERES',   
  p_n_aocta||'-'||p_n_aooper||'-'||p_n_aosbop||'-'||to_char(p_d_ppfpag,'RRRR/MM/DD')||'-'||p_n_Interes);
  commit;
   end Actualiza_Interes;

   procedure Inserta_Calendario(ps_Tipo in char) is

   pc_error varchar2(2000);
   begin

      begin
         case 
            when ps_Tipo = '601' then
               insert into fsd601
               select * from fsd601_aux;
            when ps_Tipo = '611' then
               insert into fsd611
               select * from fsd611_aux;
            else
               pc_error := 'Cod-Error';
         end case;
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      dbms_output.put_line(pc_error);
  insert into AQPB876 values (user,sysdate,'PQ_CR_CALENDARIO.INSERTA_CALENDARIO',ps_Tipo);
  commit;
   end Inserta_Calendario;
--27.07.2020
   procedure Actualiza_602Fecha(p_n_aocta  in number,
                                p_n_aooper in number,
                                p_n_aosbop in number,
                                p_n_pp1nump in number,
                                p_d_ppfpag in date) is

   pc_error varchar2(2000);

   begin
      begin
         pc_error := '0000';
         update fsd602 d_602
            set d_602.ppfpag  = p_d_ppfpag
          where d_602.pgcod   = 1
            and d_602.ppcta   = p_n_aocta  
            and d_602.ppoper  = p_n_aooper 
            and d_602.ppsbop  = p_n_aosbop 
            and d_602.pp1nump = p_n_pp1nump;
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      dbms_output.put_line(pc_error);
  insert into AQPB876 values (user,sysdate,'PQ_CR_CALENDARIO.ACTUALIZA_602FECHA',   
  p_n_aocta||'-'||p_n_aooper||'-'||p_n_aosbop||'-'||p_n_pp1nump||'-'||to_char(p_d_ppfpag,'RRRR/MM/DD'));
  commit;
   end Actualiza_602Fecha;
--27.07.2020
   procedure Actualiza_602Estado(p_n_aocta  in number,
                                 p_n_aooper in number,
                                 p_n_aosbop in number,
                                 p_n_pp1nump in number,
                                 p_c_pp1stat in char) is

   pc_error varchar2(2000);

   begin
      begin
         pc_error := '0000';
         update fsd602 d_602
            set d_602.pp1stat = p_c_pp1stat
          where d_602.pgcod   = 1
            and d_602.ppcta   = p_n_aocta  
            and d_602.ppoper  = p_n_aooper 
            and d_602.ppsbop  = p_n_aosbop 
            and d_602.pp1nump = p_n_pp1nump;
      exception
         when no_data_found then
            pc_error := 'No Data';
         when others then
            pc_error := 'Error ' || SQLCODE ||'-'||  SQLERRM;
      end;

      dbms_output.put_line(pc_error);
  insert into AQPB876 values (user,sysdate,'PQ_CR_CALENDARIO.ACTUALIZA_602ESTADO',   
  p_n_aocta||'-'||p_n_aooper||'-'||p_n_aosbop||'-'||p_n_pp1nump||'-'||p_c_pp1stat);
  commit;
   end Actualiza_602Estado;

end PQ_CR_Calendario;
/

