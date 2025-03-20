create or replace package PQ_CR_NROCONSULTAS is

  -- Author  : ABERNEDO
  -- Created : 12/08/2015 04:01:59 p.m.
  -- Purpose : 
  
  Procedure SP_CargaData (pd_fecini in date, pf_fecfin in date);
  Procedure Sp_cr_Contador ;
  Function fn_inserta(pn_tdo in number,pc_doc in char,pc_tit in varchar2)return number;
  Function fn_existe(pc_int1 in char,pc_int2 in char,pc_int3 in char,pc_int4 in char,pc_int5 in char,
                   pc_int6 in char,pc_int7 in char,pc_int8 in char,pc_int9 in char,pc_int10 in char,
                   pc_int11 in char,pc_int12 in char,pc_int13 in char,pc_int14 in char,pc_int15 in char,
                   pc_int16 in char,pc_int17 in char,pc_int18 in char,pc_int19 in char,pc_int20 in char)
                   return number;
  Procedure Sp_PreIntegrante;
  Procedure Sp_Integrantes(pn_nro in number);
  Procedure Sp_Integrantes_II;
  Procedure Sp_DefineReg(pn_tdo in number,pc_doc in char, pc_int in varchar2,pn_ins out number) ;
  Procedure Sp_Instancia(pn_ins in number,/*pn_tar out number,pc_est out char*/pc_flag out char);
  Procedure Sp_Instancia_Des(pn_ins in number,pn_tar out number);
  Procedure SP_CargaData_Pre (pd_fecini in date, pf_fecfin in date);
  Procedure Sp_cr_Contador_Pre;
  Procedure SP_CargaData_Re (pd_fecini in date, pf_fecfin in date);
  Procedure Sp_cr_Contador_Re;
  Function fn_inserta_pre(pn_tdo in number,pc_doc in char,pc_tit in varchar2)return number;
  Function fn_inserta_re(pn_tdo in number,pc_doc in char,pc_tit in varchar2)return number;
  ------------------------------------------------------------------------------------------------
  Procedure SP_CargaData_Tot (pd_fecini in date, pf_fecfin in date);
  Procedure Sp_cr_Contador_Tot_Rechazados;
  Procedure Sp_cr_Contador_Tot ;
  Function fn_inserta_Tot(pn_tdo in number,pc_doc in char,pc_tit in varchar2)return number;

end PQ_CR_NROCONSULTAS;
/

create or replace package body PQ_CR_NROCONSULTAS is

Procedure SP_CargaData (pd_fecini in date, pf_fecfin in date)is

begin

      execute immediate ('truncate table jaqz066');
      execute immediate ('truncate table jaqz067');
      --execute immediate ('truncate table jaqz068');
      
      Begin
      
              insert into jaqz066 (JAQZ066NCO,JAQZ066FEN,JAQZ066HOE,JAQZ066SUC,JAQZ066INT,JAQZ066TDO,
                                   JAQZ066NDO,JAQZ066ACC,JAQZ066INS)
                                   
                      select distinct 
                             a.jaql546nucon,
                             a.jaql546feenv,
                             a.jaql546hoenv,
                             a.jaql546ussuc,
                             b.jaqy765integr,
                             b.jaqy765tdoc,
                             b.jaqy765ndoc,
                             a.jaql546accio,
                             (select c.jaqy728inst from  jaqy728 c 
                               where a.jaql546nucon = c.jaqy728nuope
                                 and c.jaqy728hor = (select max(cc.jaqy728hor)
                                               from jaqy728 cc
                                              where cc.jaqy728nuope = c.jaqy728nuope))
                             
                        from jaql546 a,
                             jaqy765 b
                              
                      where a.jaql546feenv between pd_fecini and pf_fecfin
                        and a.jaql546nucon = b.jaqy765numcon
                        and a.jaql546feenv = b.jaqy765fchsis
                        and a.jaql546accio = 'O'
                        and a.jaql546hoenv = (select max(aa.jaql546hoenv)
                                                from jaql546 aa
                                               where aa.jaql546nucon = a.jaql546nucon);          
              
              commit;
              
              
      end;
      
      /*begin
              insert into JAQZ068 (JAQZ068NRO)
              select distinct
                     a.jaqz066nco
                from jaqz066 a;      
      end;*/
      
      --pq_cr_nroconsultas.Sp_PreIntegrante;    
      pq_cr_nroconsultas.Sp_cr_Contador;

end SP_CargaData;


Procedure Sp_cr_Contador is

cursor consultas is
select * from jaqz066;
ln_ins number(1);


lc_flag char(1);
begin 
     for i in consultas loop
     
         ln_ins := pq_cr_nroconsultas.fn_inserta(i.jaqz066tdo,i.jaqz066ndo,i.jaqz066int);
         
         
         if ln_ins = 0 then
         
            pq_cr_nroconsultas.sp_instancia(i.jaqz066ins,lc_flag/*ln_tar,lc_est*/);
            
            If lc_flag = 'S' then
              insert into jaqz067 (JAQZ067NCO,JAQZ067FEN,JAQZ067HOE,JAQZ067SUC,JAQZ067INT,JAQZ067TDO,
                                   JAQZ067NDO,JAQZ067ACC,JAQZ067INS,jaqz067flg/*JAQZ067TAR,jaqz067est*/)
                           values (i.jaqz066nco,i.jaqz066fen,i.jaqz066hoe,i.jaqz066suc,i.jaqz066int,
                                   i.jaqz066tdo,i.jaqz066ndo,i.jaqz066acc,i.jaqz066ins,lc_flag
                                   /*ln_tar,lc_est*/);
                                   
                                   commit;
             end if;
         end if;
         commit;
     end loop;
     commit;


end Sp_cr_Contador;


Function fn_inserta(pn_tdo in number,pc_doc in char,pc_tit in varchar2)return number is
ln_existe number(1);
--ln_ins number(10);
begin
    
         begin
              select 1--,a.jaqz066ins
                into ln_existe--,ln_ins
                from jaqz067 a
               where a.jaqz067tdo = pn_tdo
                 and a.jaqz067ndo = pc_doc
                 and a.jaqz067int = pc_tit;
                 
         exception
                 when others then 
                      ln_existe := 0;
         end;
         
         /*if ln_existe = 1 and ln_ins is not null then
            ln_existe := 0;

         end if;
         */
         if ln_existe is null then
            ln_existe := 0;
         end if;
         return ln_existe;
end fn_inserta;

Procedure Sp_DefineReg(pn_tdo in number,pc_doc in char, pc_int in varchar2,pn_ins out number) is 

begin
     
     --instancia
     begin
     
          select max(a.jaqz066ins)
            into pn_ins
            from jaqz066 a 
           where a.jaqz066tdo = pn_tdo
             and a.jaqz066ndo = pc_doc
             and a.jaqz066int = pc_int;
     exception
     when others then
          pn_ins := null;
     end;   

end Sp_DefineReg;

Procedure Sp_PreIntegrante is

cursor jaqz068 is
select * from jaqz068;

begin

       begin
       
         For i in jaqz068 loop
             pq_cr_nroconsultas.sp_Integrantes(i.jaqz068nro);
         
         end loop;
         
       end;
end Sp_PreIntegrante; 

Procedure Sp_Integrantes(pn_nro in number) is

cursor integrantes(pn_nro in number) is
select a.jaqz066nco,
       a.jaqz066ndo
  from jaqz066 a
 where a.jaqz066nco = pn_nro;
 
ln_count number(6);      
begin
  ln_count:= 0;
  Begin
       for i in integrantes(pn_nro) loop
       
           ln_count := ln_count + 1;
        
       
           if ln_count = 1 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in1 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;

           end if;   
           if ln_count = 2 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in2 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;

           end if; 
           if ln_count = 3 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in3 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;

           end if; 
           if ln_count = 4 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in4 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;  
           if ln_count = 5 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in5 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if; 
           if ln_count = 6 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in6 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 7 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in7 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 8 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in8 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 9 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in9 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 10 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in10 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 11 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in11 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 12 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in12 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 13 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in13 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 14 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in14 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 15 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in15 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 16 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in16 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 17 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in17 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 18 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in18 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 19 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in19 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;   
           if ln_count = 20 and  ln_count <= 20 then
       
              update jaqz068
                 set jaqz068in20 = i.jaqz066ndo
               where jaqz068nro = pn_nro;
               
               commit;
           end if;                   
           commit;
       end loop; 
       commit;
   end;     
   pq_cr_nroconsultas.Sp_Integrantes_II;
end Sp_Integrantes;

Procedure Sp_Integrantes_II is

cursor integrantes is
select * from jaqz068;
ln_exs number(1);
begin

       begin
         For i in integrantes loop
         
   ln_exs := pq_cr_nroconsultas.fn_existe(i.jaqz068in1,i.jaqz068in2,i.jaqz068in3,i.jaqz068in4,
                                          i.jaqz068in5,i.jaqz068in6,i.jaqz068in7,i.jaqz068in8,
                                          i.jaqz068in9,i.jaqz068in10,i.jaqz068in11,i.jaqz068in12,
                                          i.jaqz068in13,i.jaqz068in14,i.jaqz068in15,i.jaqz068in16,
                                          i.jaqz068in17,i.jaqz068in18,i.jaqz068in19,i.jaqz068in20);
                                          
             update jaqz068 a 
                set jaqz068res = ln_exs
              where a.jaqz068nro = i.jaqz068nro;
              commit;
         
         end loop;
       
       COMMIT;
       end;

end Sp_Integrantes_II;

Function fn_existe(pc_int1 in char,pc_int2 in char,pc_int3 in char,pc_int4 in char,pc_int5 in char,
                   pc_int6 in char,pc_int7 in char,pc_int8 in char,pc_int9 in char,pc_int10 in char,
                   pc_int11 in char,pc_int12 in char,pc_int13 in char,pc_int14 in char,pc_int15 in char,
                   pc_int16 in char,pc_int17 in char,pc_int18 in char,pc_int19 in char,pc_int20 in char)
                   return number is
ln_existe number(1);
begin

         begin
              select 1
                into ln_existe
                from jaqz068 a
               where a.jaqz068in1 = pc_int1
                 and a.jaqz068in2 = pc_int2
                 and a.jaqz068in3 = pc_int3
                 and a.jaqz068in4 = pc_int4
                 and a.jaqz068in5 = pc_int5
                 and a.jaqz068in6 = pc_int6
                 and a.jaqz068in7 = pc_int7
                 and a.jaqz068in8 = pc_int8
                 and a.jaqz068in9 = pc_int9
                 and a.jaqz068in10 = pc_int10
                 and a.jaqz068in11 = pc_int11
                 and a.jaqz068in12 = pc_int12
                 and a.jaqz068in13 = pc_int13
                 and a.jaqz068in14 = pc_int14
                 and a.jaqz068in15 = pc_int15
                 and a.jaqz068in16 = pc_int16
                 and a.jaqz068in17 = pc_int17
                 and a.jaqz068in18 = pc_int18
                 and a.jaqz068in19 = pc_int19
                 and a.jaqz068in20 = pc_int20;
                 
         exception
                 when others then 
                      ln_existe := 0;
         end;
         
         if ln_existe is null then
            ln_existe := 0;
         end if;
         return ln_existe;
end fn_existe;

Procedure Sp_Instancia(pn_ins in number,/*pn_tar out number,pc_est out char*/pc_flag out char) is

begin

         /* begin
          
                     select d.wftaskcod,d.wfstscod
                        into pn_tar,pc_est
                       from wfwrkitems d 
                      where d.wfinsprcid = pn_ins
                        and d.wfiteminit = (select max(dd.wfiteminit)
                                              from wfwrkitems dd
                                             where dd.wfinsprcid = d.wfinsprcid);
          exception
              when others then
                   pn_tar := null;
                   pc_est := null;
          end;*/
          
           begin
          
                     select 'S'
                        into pc_flag--pn_tar,pc_est
                       from wfwrkitems d 
                      where d.wfinsprcid = pn_ins
                        and d.wftaskcod = 11
                        and rownum = 1;--55;
                        --and d.wfstscod = 'C';
                        --and d.wfiteminit = (select max(dd.wfiteminit)
                          --                    from wfwrkitems dd
                               --              where dd.wfinsprcid = d.wfinsprcid);
          exception
              when others then
                   pc_flag := 'N';
--                   pn_tar := null;
--                   pc_est := null;
          end;
          
          
          
end Sp_Instancia;

Procedure Sp_Instancia_Des(pn_ins in number,pn_tar out number) is

begin

         begin
          
                     select d.wftaskcod
                        into pn_tar
                       from wfwrkitems d 
                      where d.wfinsprcid = pn_ins
                        and d.wfiteminit = (select max(dd.wfiteminit)
                                              from wfwrkitems dd
                                             where dd.wfinsprcid = d.wfinsprcid);
          exception
              when others then
                   pn_tar := null;
                 
          end;
          
    
          
          
          
end Sp_Instancia_Des;

Procedure SP_CargaData_Pre (pd_fecini in date, pf_fecfin in date)is

begin

      execute immediate ('truncate table jaqz069');
      execute immediate ('truncate table jaqz070');
      
      Begin
      
              insert into jaqz069 (JAQZ069NCO,JAQZ069FEN,JAQZ069HOE,JAQZ069SUC,JAQZ069INT,JAQZ069TDO,
                                   JAQZ069NDO,JAQZ069ACC,JAQZ069INS)
                                   
                      select distinct 
                             a.jaql546nucon,
                             a.jaql546feenv,
                             a.jaql546hoenv,
                             a.jaql546ussuc,
                             b.jaqy765integr,
                             b.jaqy765tdoc,
                             b.jaqy765ndoc,
                             a.jaql546accio,
                             (select c.jaqy728inst from  jaqy728 c 
                               where a.jaql546nucon = c.jaqy728nuope
                                 and c.jaqy728hor = (select max(cc.jaqy728hor)
                                               from jaqy728 cc
                                              where cc.jaqy728nuope = c.jaqy728nuope))
                             
                        from jaql546 a,
                             jaqy765 b
                              
                      where a.jaql546feenv between pd_fecini and pf_fecfin
                        and a.jaql546nucon = b.jaqy765numcon
                        and a.jaql546feenv = b.jaqy765fchsis
                        and a.jaql546accio = 'P'
                        and a.jaql546hoenv = (select max(aa.jaql546hoenv)
                                                from jaql546 aa
                                               where aa.jaql546nucon = a.jaql546nucon);          
              
              commit;
              
              
      end;

      pq_cr_nroconsultas.Sp_cr_Contador_Pre;

end SP_CargaData_Pre;


Procedure Sp_cr_Contador_Pre is

cursor consultas is
select * from jaqz069;
ln_ins number(1);


lc_flag char(1);
begin 
     for i in consultas loop
     
         ln_ins := pq_cr_nroconsultas.fn_inserta_pre(i.jaqz069tdo,i.jaqz069ndo,i.jaqz069int);
         
         
         if ln_ins = 0 then
         
            pq_cr_nroconsultas.sp_instancia(i.jaqz069ins,lc_flag);
            insert into jaqz070 (JAQZ070NCO,JAQZ070FEN,JAQZ070HOE,JAQZ070SUC,JAQZ070INT,JAQZ070TDO,
                                 JAQZ070NDO,JAQZ070ACC,JAQZ070INS,JAQZ070FLG)
                         values (i.jaqz069nco,i.jaqz069fen,i.jaqz069hoe,i.jaqz069suc,i.jaqz069int,
                                 i.jaqz069tdo,i.jaqz069ndo,i.jaqz069acc,i.jaqz069ins,lc_flag);
                                 
                                 commit;
         end if;
         commit;
     end loop;
     commit;


end Sp_cr_Contador_Pre;

Procedure SP_CargaData_Re (pd_fecini in date, pf_fecfin in date)is

begin

      execute immediate ('truncate table jaqz071');
      execute immediate ('truncate table jaqz072');
      
      Begin
      
              insert into jaqz071 (JAQZ071NCO,JAQZ071FEN,JAQZ071HOE,JAQZ071SUC,JAQZ071INT,JAQZ071TDO,
                                   JAQZ071NDO,JAQZ071ACC,JAQZ071INS)
                                   
                      select distinct 
                             a.jaql546nucon,
                             a.jaql546feenv,
                             a.jaql546hoenv,
                             a.jaql546ussuc,
                             b.jaqy765integr,
                             b.jaqy765tdoc,
                             b.jaqy765ndoc,
                             a.jaql546accio,
                             (select c.jaqy728inst from  jaqy728 c 
                               where a.jaql546nucon = c.jaqy728nuope
                                 and c.jaqy728hor = (select max(cc.jaqy728hor)
                                               from jaqy728 cc
                                              where cc.jaqy728nuope = c.jaqy728nuope))
                             
                        from jaql546 a,
                             jaqy765 b
                              
                      where a.jaql546feenv between pd_fecini and pf_fecfin
                        and a.jaql546nucon = b.jaqy765numcon
                        and a.jaql546feenv = b.jaqy765fchsis
                        and a.jaql546accio = 'R'
                        and a.jaql546hoenv = (select max(aa.jaql546hoenv)
                                                from jaql546 aa
                                               where aa.jaql546nucon = a.jaql546nucon);          
              
              commit;
              
              
      end;

      pq_cr_nroconsultas.Sp_cr_Contador_Re;

end SP_CargaData_Re;


Procedure Sp_cr_Contador_Re is

cursor consultas is
select * from jaqz071;
ln_ins number(1);


lc_flag char(1);
begin 
     for i in consultas loop
     
         ln_ins := pq_cr_nroconsultas.fn_inserta_re(i.jaqz071tdo,i.jaqz071ndo,i.jaqz071int);
         
         
         if ln_ins = 0 then
         
            pq_cr_nroconsultas.sp_instancia(i.jaqz071ins,lc_flag);
            insert into jaqz072 (JAQZ072NCO,JAQZ072FEN,JAQZ072HOE,JAQZ072SUC,JAQZ072INT,JAQZ072TDO,
                                 JAQZ072NDO,JAQZ072ACC,JAQZ072INS,JAQZ072flg)
                         values (i.jaqz071nco,i.jaqz071fen,i.jaqz071hoe,i.jaqz071suc,i.jaqz071int,
                                 i.jaqz071tdo,i.jaqz071ndo,i.jaqz071acc,i.jaqz071ins,lc_flag);
                                 
                                 commit;
         end if;
         commit;
     end loop;
     commit;


end Sp_cr_Contador_Re;

Function fn_inserta_pre(pn_tdo in number,pc_doc in char,pc_tit in varchar2)return number is
ln_existe number(1);
--ln_ins number(10);
begin
    
         begin
              select 1--,a.jaqz066ins
                into ln_existe--,ln_ins
                from jaqz070 a
               where a.jaqz070tdo = pn_tdo
                 and a.jaqz070ndo = pc_doc
                 and a.jaqz070int = pc_tit;
                 
         exception
                 when others then 
                      ln_existe := 0;
         end;
         
         /*if ln_existe = 1 and ln_ins is not null then
            ln_existe := 0;

         end if;
         */
         if ln_existe is null then
            ln_existe := 0;
         end if;
         return ln_existe;
end fn_inserta_pre;

Function fn_inserta_re(pn_tdo in number,pc_doc in char,pc_tit in varchar2)return number is
ln_existe number(1);
--ln_ins number(10);
begin
    
         begin
              select 1--,a.jaqz066ins
                into ln_existe--,ln_ins
                from jaqz072 a
               where a.jaqz072tdo = pn_tdo
                 and a.jaqz072ndo = pc_doc
                 and a.jaqz072int = pc_tit;
                 
         exception
                 when others then 
                      ln_existe := 0;
         end;
         
         /*if ln_existe = 1 and ln_ins is not null then
            ln_existe := 0;

         end if;
         */
         if ln_existe is null then
            ln_existe := 0;
         end if;
         return ln_existe;
end fn_inserta_re;


-------------------------------------------------------------------------------------------------

Procedure SP_CargaData_Tot (pd_fecini in date, pf_fecfin in date)is

begin

      execute immediate ('truncate table jaqz066');
      execute immediate ('truncate table jaqz067');
      
      Begin
      
              insert into jaqz066 (JAQZ066NCO,JAQZ066FEN,JAQZ066HOE,JAQZ066SUC,JAQZ066INT,JAQZ066TDO,
                                   JAQZ066NDO,JAQZ066ACC,JAQZ066INS,jaqz066usr)
                    --mod@abr 20180829               
                      select /*+PARALLEL(B,5)*/ 
                             a.jaql546nucon,
                             a.jaql546feenv,
                             a.jaql546hoenv,
                             a.jaql546ussuc,
                             b.aqpa011integr,
                             b.aqpa011tdoc,
                             b.aqpa011ndoc,
                             a.jaql546accio,
                             (select /*+ PARALLEL(C,5)*/ c.jaqy599ainst from  jaqy599A c 
                               where a.jaql546nucon = c.jaqy599anuope
                                 and c.jaqy599ahor = (select /*+ PARALLEL(CC,5)*/max(cc.jaqy599ahor)
                                               from jaqy599A cc
                                              where cc.jaqy599anuope = c.jaqy599anuope)
                                 and rownum = 1),
                             a.jaql546uscod
                             
                        from jaql546 a,
                             aqpa011 b
                              
                      where a.jaql546feenv between pd_fecini and pf_fecfin
                        and a.jaql546nucon = b.aqpa011numcon
                        and a.jaql546feenv = b.aqpa011fchsis
                        and a.jaql546accio <> ' ';          
                   --mod@abr 20180829 
              commit;
              
              
      end;

      --pq_cr_nroconsultas.Sp_cr_Contador_Tot;

end SP_CargaData_Tot;

Procedure Sp_cr_Contador_Tot_Rechazados is

cursor consultas is
select * from jaqz066
where jaqz066acc = 'R';

ln_ins number(1);
ln_tar number(4);
lc_est char(1);
begin 
     for i in consultas loop
     
        
        ln_ins := pq_cr_nroconsultas.fn_inserta_Tot(i.jaqz066tdo,i.jaqz066ndo,i.jaqz066int);
            
        if ln_ins = 0 then
           insert into jaqz067 (JAQZ067NCO,JAQZ067FEN,JAQZ067HOE,JAQZ067SUC,JAQZ067INT,JAQZ067TDO,
                             JAQZ067NDO,JAQZ067ACC,JAQZ067INS,JAQZ067TAR,jaqz067est)
                     values (i.jaqz066nco,i.jaqz066fen,i.jaqz066hoe,i.jaqz066suc,i.jaqz066int,
                             i.jaqz066tdo,i.jaqz066ndo,i.jaqz066acc,i.jaqz066ins,ln_tar,lc_est);
                                 
                             commit;
        end if;
         
         
         commit;
     end loop;
     commit;


end Sp_cr_Contador_Tot_Rechazados;

Procedure Sp_cr_Contador_Tot is

cursor consultas is
select * from jaqz066 a
where a.jaqz066acc in ('O','P');
ln_ins number(1);
ln_tar number(4);

lc_flag char(1);

begin 
     for i in consultas loop
        
         ln_ins := pq_cr_nroconsultas.fn_inserta_Tot(i.jaqz066tdo,i.jaqz066ndo,i.jaqz066int);
         
         
         if ln_ins = 0 then
         
            
            --if ln_tar = 11 and lc_est = 'C' then
            
            pq_cr_nroconsultas.sp_instancia(i.jaqz066ins,lc_flag); --instancia que hayan llegado a la tarea 55 en algun momento del flujo
            --pq_cr_nroconsultas.sp_instancia_des(i.jaqz066ins,ln_tar); --instancia que su ultima tarea sea la 55
            
            --If lc_flag = 'S' then
            --If ln_tar = 55 then
              insert into jaqz067 (JAQZ067NCO,JAQZ067FEN,JAQZ067HOE,JAQZ067SUC,JAQZ067INT,JAQZ067TDO,
                                   JAQZ067NDO,JAQZ067ACC,JAQZ067INS,jaqz067flg/*JAQZ067TAR,jaqz067est*/)
                           values (i.jaqz066nco,i.jaqz066fen,i.jaqz066hoe,i.jaqz066suc,i.jaqz066int,
                                   i.jaqz066tdo,i.jaqz066ndo,i.jaqz066acc,i.jaqz066ins,lc_flag
                                   /*ln_tar,lc_est*/);
                                   
                                   commit;
            -- end if;

            --end if;

         end if;
         commit;
     end loop;
     commit;


end Sp_cr_Contador_Tot;


Function fn_inserta_Tot(pn_tdo in number,pc_doc in char,pc_tit in varchar2)return number is
ln_existe number(1);
--ln_ins number(10);
begin
    
         begin
              select 1--,a.jaqz066ins
                into ln_existe--,ln_ins
                from jaqz067 a
               where a.jaqz067tdo = pn_tdo
                 and a.jaqz067ndo = pc_doc/*
                 and a.jaqz067int = pc_tit*/;
                 
         exception
                 when others then 
                      ln_existe := 0;
         end;
         
         /*if ln_existe = 1 and ln_ins is not null then
            ln_existe := 0;

         end if;
         */
         if ln_existe is null then
            ln_existe := 0;
         end if;
         return ln_existe;
end fn_inserta_Tot;

/*Procedure SP_CargaData_WEB (pd_fecini in date, pf_fecfin in date)is

begin

      execute immediate ('truncate table JAQZ092');
      
      Begin
      
              insert into jaqz092 (jaqz092NCO,jaqz092FEN,jaqz092HOE,jaqz092SUC,jaqz092INT,jaqz092TDO,
                                   jaqz092NDO,jaqz092ACC,jaqz092INS,jaqz092usr)
                                   
                      select  
                             a.jaql546nucon,
                             a.jaql546feenv,
                             a.jaql546hoenv,
                             a.jaql546ussuc,
                             b.jaqy765integr,
                             b.jaqy765tdoc,
                             b.jaqy765ndoc,
                             a.jaql546accio,
                             (select c.jaqy728inst from  jaqy728 c 
                               where a.jaql546nucon = c.jaqy728nuope
                                 and c.jaqy728hor = (select max(cc.jaqy728hor)
                                               from jaqy728 cc
                                              where cc.jaqy728nuope = c.jaqy728nuope)),
                             a.jaql546uscod
                             
                        from JAQY760 a
                              
                      where a.jaqy760fch_con between pd_fecini and pf_fecfin
                        and a.jaql546accio <> ' ';          
              
              commit;
              
              
      end;

      --pq_cr_nroconsultas.Sp_cr_Contador_Tot;

end SP_CargaData_WEB;*/
end PQ_CR_NROCONSULTAS;
/

