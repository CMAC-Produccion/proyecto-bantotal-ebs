create or replace package PQ_CAUS_WEB is

  -- Author  : ABERNEDO
  -- Created : 11/12/2014 08:37:24 a.m.
  -- Purpose : 
  --         : 2024.10.29 DCASTRO se modificó Acceso a vista reclamos v_reclamos
  
 Function Fn_Equivalencia_Producto(pc_codpro in varchar2)return varchar2;
 Function Fn_Equivalencia_Motivo(pc_codpro in varchar2,pc_tipreg in varchar2)return number ;
 Function Fn_Ubigeo(pc_ubigeo in varchar2) return number ;
 Function Fn_Codigo(pc_tipreg in varchar2,pd_fecreg in date)return varchar2;
 Function Fn_Trimestre(pd_fecreg in date)return number;
 Function Fn_Correlativo(pc_tipreg in varchar2,pd_fecreg in date)return number;
 Function Fn_Es_Cliente(pc_tipdoc in varchar2, pc_numdoc in varchar2) return varchar2;
 Function Fn_tip_doc(pc_tipdoc in varchar2) return number;
 Function Fn_tip_docsql(pn_tipdoc in number) return varchar2;
 Procedure SP_CAUS_PROCBACH(pd_fecpro in date);
 Procedure SP_CAUS_PROCBACH_II(pd_fecpro in date);
 Procedure SP_CAUS_PROCBACH_III(pd_fecpro in date);
 Procedure SP_ActSQLRec(pd_fecpro in date);
 Procedure SP_InsSQLRec(pd_fecpro in date);
end PQ_CAUS_WEB;
/

create or replace package body PQ_CAUS_WEB is

Function Fn_Equivalencia_Producto(pc_codpro in varchar2)return varchar2 is
pc_codFin varchar2(10);

begin
     begin
       select a.jaql421cod
         into pc_codFin
         from jaql421 a
        where a.jaql421sbs = trim(pc_codpro)
        and a.jaql421est = 'S';
     exception
        when others then null;
     end;
     
     return pc_codFin;
end Fn_Equivalencia_Producto;


Function Fn_Equivalencia_Motivo(pc_codpro in varchar2,pc_tipreg in varchar2)return number is

pn_codFin number;
pn_cod    number;
  LVCCAD VARCHAR2(2000);
begin
     --DBMS_OUTPUT.PUT_LINE(pc_codpro);
     if pc_codpro is null then
       pn_cod := 0;
     else
       pn_cod := to_number(trim(pc_codpro));    
     end if;    
     
     
     
     if  trim(pc_tipreg) = 'Reclamo' or trim(pc_tipreg) = 'Queja'  then
         
         begin

           select a.jaql422cod
             into pn_codFin
             from jaql422 a
            where a.jaql422sbs = pn_cod
            and a.jaql422est = 'S';--pn_cod;
         exception
            when others then null;
         end;
     end if;
     
     if  trim(pc_tipreg) = 'Requerimie' or trim(pc_tipreg) = 'Consulta' then -- Req. 3653 09/12/2015  KDVC adicione or trim(pc_tipreg) = 'Consulta'       
         begin
           select a.jaqy294cod
             into pn_codFin
             from jaqy294 a
            where a.jaqy294cod = pn_cod--pn_cod;
            and a.jaqy294est = 'S';--- Req. 3653 09/12/2015  KDVC 
         exception
            when others then null;
         end;
     end if;
     
     
     return pn_codFin;
exception when others then
  LVCCAD := TO_CHAR('Fn_Equivalencia_Motivo'||'-'||SQLCODE||' - '||SQLERRM);
  --insert into log_error_bandeja values(1,pc_codpro,LVCCAD,sysdate);
  --commit;     
  DBMS_OUTPUT.PUT_LINE(LVCCAD||'-'||pc_codpro);
end Fn_Equivalencia_Motivo;

Function Fn_Ubigeo(pc_ubigeo in varchar2) return number is

pc_temp varchar2(8);
pn_ubg number;
pn_tam number;
begin
       begin
       
         pn_tam := LENGTH(pc_ubigeo);
         
         if substr(pc_ubigeo,1,0) = '0' then
            pc_temp := substr(pc_ubigeo,2,pn_tam-2);
            pn_ubg := to_number(pc_temp);
            
            else
                   pc_temp := substr(pc_ubigeo,1,pn_tam-2);
                   pn_ubg := to_number(pc_temp);
         
         end if;
       end;
       return pn_ubg;
end Fn_Ubigeo;


Function Fn_Codigo(pc_tipreg in varchar2,pd_fecreg in date)return varchar2 is

pc_codigo varchar2(20);
pc_agencia varchar2(3);
--pc_fecha varchar(12);
pc_anio varchar2(4);
pc_mes varchar2(2);
pc_tri varchar2(1);
pn_corr number(9);
pc_corr varchar2(9);
pn_anio number(4);
Begin        
         begin
              
           if  trim(pc_tipreg) = 'Reclamo' then
                        
              pc_agencia := '904';
              pc_anio    := to_char(extract(year from pd_fecreg));
              pc_mes     := to_char(extract(month from pd_fecreg));
              pn_anio    := to_number(pc_anio);
              if pc_mes = '1' or pc_mes = '2' or pc_mes = '3' then
                 pc_tri := '1';
                 
                 else
                        if pc_mes = '4' or pc_mes = '5' or pc_mes = '6' then
                           pc_tri := '2';
                           
                           else
                                  if pc_mes = '7' or pc_mes = '8' or pc_mes = '9' then
                                     pc_tri := '3';
                                     
                                     else
                                            if pc_mes = '10' or pc_mes = '11' or pc_mes = '12' then
                                               pc_tri := '4';
                                            end if;
                                  end if;
                        end if;
              end if;
              
              pc_codigo  := 'R';
              pc_codigo  := concat(trim(pc_codigo),'00');
              pc_codigo  := concat(trim(pc_codigo),'4');
              pc_codigo  := concat(trim(pc_codigo),trim(pc_agencia));
              pc_codigo  := concat(trim(pc_codigo),trim(pc_anio));
              pc_codigo  := concat(trim(pc_codigo),trim(pc_tri));
              --pn_corr := 1;
              
              
              
              Begin
              
                     select max(jaql420cor)
                       into pn_corr
                       from jaql420  a
                      where a.jaql420emp = 1
                        and a.jaql420ani = pn_anio
                        ;
             exception         
              when no_data_found then
                   pn_corr := 1;
              End;
              
              pn_corr := pn_corr + 1;
              
              if pn_corr is null then
                 pn_corr := 1;
              end if;
              
              
              pc_corr := to_char(pn_corr);
                       
              if length(trim(pc_corr)) = 1 then
                 pc_codigo  := concat(trim(pc_codigo),'000');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
              
              if length(trim(pc_corr)) = 2 then
                 pc_codigo  := concat(trim(pc_codigo),'00');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
              
              if length(trim(pc_corr)) = 3 then
                 pc_codigo  := concat(trim(pc_codigo),'0');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
              
              if length(trim(pc_corr)) = 4 then
                 pc_codigo  := concat(trim(pc_codigo),'');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
                 
          end if;    
          
          if  trim(pc_tipreg) = 'Consulta' then
                        
              pc_agencia := '904';
              --pc_fecha   := to_char(pd_fecreg);
              pc_anio    := to_char(extract(year from pd_fecreg));
              pc_mes     := to_char(extract(month from pd_fecreg));
              pn_anio    := to_number(pc_anio);
              if pc_mes = '1' or pc_mes = '2' or pc_mes = '3' then
                 pc_tri := '1';
                 
                 else
                        if pc_mes = '4' or pc_mes = '5' or pc_mes = '6' then
                           pc_tri := '2';
                           
                           else
                                  if pc_mes = '7' or pc_mes = '8' or pc_mes = '9' then
                                     pc_tri := '3';
                                     
                                     else
                                            if pc_mes = '10' or pc_mes = '11' or pc_mes = '12' then
                                               pc_tri := '4';
                                            end if;
                                  end if;
                        end if;
              end if;
              
              pc_codigo  := 'C';
              pc_codigo  := concat(trim(pc_codigo),'00');
              pc_codigo  := concat(trim(pc_codigo),'4');
              pc_codigo  := concat(trim(pc_codigo),trim(pc_agencia));
              pc_codigo  := concat(trim(pc_codigo),trim(pc_anio));
              pc_codigo  := concat(trim(pc_codigo),trim(pc_tri));
              pn_corr := 1;
              Begin
              
                     select max(jaqy290cor)
                       into pn_corr
                       from jaqy290  a
                      where a.jaqy290emp = 1
                        and a.jaqy290ani = pn_anio
                        ;
              exception 
              when no_data_found then
                   pn_corr := 1;
              End;
              pn_corr := pn_corr + 1;
              
              if pn_corr is null then
                 pn_corr := 1;
              end if;
              
              
              pc_corr := to_char(pn_corr);
              
              if length(trim(pc_corr)) = 1 then
                 pc_codigo  := concat(trim(pc_codigo),'000');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
              
              if length(trim(pc_corr)) = 2 then
                 pc_codigo  := concat(trim(pc_codigo),'00');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
              
              if length(trim(pc_corr)) = 3 then
                 pc_codigo  := concat(trim(pc_codigo),'0');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
              
              if length(trim(pc_corr)) = 4 then
                 pc_codigo  := concat(trim(pc_codigo),'');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
                 
          end if;    
          
          if  trim(pc_tipreg) = 'Requerimie' then
                        
              pc_agencia := '904';
              pc_anio    := to_char(extract(year from pd_fecreg));
              pc_mes     := to_char(extract(month from pd_fecreg));
              pn_anio    := to_number(pc_anio);
              if pc_mes = '1' or pc_mes = '2' or pc_mes = '3' then
                 pc_tri := '1';
                 
                 else
                        if pc_mes = '4' or pc_mes = '5' or pc_mes = '6' then
                           pc_tri := '2';
                           
                           else
                                  if pc_mes = '7' or pc_mes = '8' or pc_mes = '9' then
                                     pc_tri := '3';
                                     
                                     else
                                            if pc_mes = '10' or pc_mes = '11' or pc_mes = '12' then
                                               pc_tri := '4';
                                            end if;
                                  end if;
                        end if;
              end if;
              
              pc_codigo  := 'Q';
              pc_codigo  := concat(trim(pc_codigo),'00');
              pc_codigo  := concat(trim(pc_codigo),'4');
              pc_codigo  := concat(trim(pc_codigo),trim(pc_agencia));
              pc_codigo  := concat(trim(pc_codigo),trim(pc_anio));
              pc_codigo  := concat(trim(pc_codigo),trim(pc_tri));
              Begin
              
                     select max(jaqy290_Rcor)
                       into pn_corr
                       from jaqy290_R  a
                      where a.jaqy290_Remp = 1
                        and a.jaqy290_Rani = pn_anio
                        ;
               exception 
              when no_data_found then
                   pn_corr := 1;
              
              End;
              pn_corr := pn_corr + 1;
              if pn_corr is null then
                 pn_corr := 1;
              end if;
              
              
              
              pc_corr := to_char(pn_corr);
              
              if length(trim(pc_corr)) = 1 then
                 pc_codigo  := concat(trim(pc_codigo),'000');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
              
              if length(trim(pc_corr)) = 2 then
                 pc_codigo  := concat(trim(pc_codigo),'00');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
              
              if length(trim(pc_corr)) = 3 then
                 pc_codigo  := concat(trim(pc_codigo),'0');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
              
              if length(trim(pc_corr)) = 4 then
                 pc_codigo  := concat(trim(pc_codigo),'');
                 pc_codigo  := concat(trim(pc_codigo),trim(pc_corr));
              end if;
                 
          end if;    
    
         end;
         
         return pc_codigo;
         
         --return pc_tipreg;
         
end Fn_Codigo;

Function Fn_Trimestre(pd_fecreg in date)return number is


pc_mes varchar2(2);
pn_tri number(1);

Begin

         begin
              
             
              pc_mes     := to_char(extract(month from pd_fecreg));                  
             
              if pc_mes = '1' or pc_mes = '2' or pc_mes = '3' then
                 pn_tri := 1;
                 
                 else
                        if pc_mes = '4' or pc_mes = '5' or pc_mes = '6' then
                           pn_tri := 2;
                           
                           else
                                  if pc_mes = '7' or pc_mes = '8' or pc_mes = '9' then
                                     pn_tri := 3;
                                     
                                     else
                                            if pc_mes = '10' or pc_mes = '11' or pc_mes = '12' then
                                               pn_tri := 4;
                                            end if;
                                  end if;
                        end if;
              end if;
                              
         end;
         
         return pn_tri;
         
end Fn_Trimestre;


Function Fn_Correlativo(pc_tipreg in varchar2,pd_fecreg in date)return number is

--pc_fecha varchar(12);
pc_anio varchar2(4);
pn_anio number(4);
pn_corr number(9);

Begin

         begin
              
           if  trim(pc_tipreg) = 'Reclamo' then
                        
              pc_anio    := to_char(extract(year from pd_fecreg));
              pn_anio    := to_number(pc_anio);
              Begin
              
                     select max(jaql420cor)
                       into pn_corr
                       from jaql420  a
                      where a.jaql420emp = 1
                        and a.jaql420ani = pn_anio
                        ;
             exception         
              when no_data_found then
                   pn_corr := 1;
              End;
              pn_corr := pn_corr + 1;
              if pn_corr is null then
                 pn_corr := 1;
              end if;
              
              
              
                             
          end if;    
          
          if  trim(pc_tipreg) = 'Consulta' then
                        
              pc_anio    := to_char(extract(year from pd_fecreg));
              pn_anio    := to_number(pc_anio);
              Begin
              
                     select max(jaqy290cor)
                       into pn_corr
                       from jaqy290  a
                      where a.jaqy290emp = 1
                        and a.jaqy290ani = pn_anio
                        ;
              exception 
              when no_data_found then
                   pn_corr := 1;
              End;
              pn_corr := pn_corr + 1;
             if pn_corr is null then
                 pn_corr := 1;
              end if;
              
                 
          end if;    
          
          if  trim(pc_tipreg) = 'Requerimie' then
                        
              pc_anio    := to_char(extract(year from pd_fecreg));
              pn_anio    := to_number(pc_anio);
              Begin
              
                     select max(jaqy290_Rcor)
                       into pn_corr
                       from jaqy290_R  a
                      where a.jaqy290_Remp = 1
                        and a.jaqy290_Rani = pn_anio
                        
                        ;
                        
                 
               exception 
              when no_data_found then
                   pn_corr := 1;
              End;
              
              pn_corr := pn_corr + 1;
              if pn_corr is null then
                 pn_corr := 1;
              end if;
              
                 
          end if;    
    
         end;
         
         return pn_corr;
         
end Fn_Correlativo;


Function Fn_Es_Cliente(pc_tipdoc in varchar2, pc_numdoc in varchar2) return varchar2 is

pc_flg varchar2(1);
pn_tdoc number(2);
pc_doc  char(12);
begin
       pc_doc := to_char(trim(pc_numdoc));
       begin
       
         if trim(pc_tipdoc) = 'DNI' then
            pn_tdoc := 21;
            
            else
                    if trim(pc_tipdoc) = 'CE' then
                      pn_tdoc := 2;
                      
                      else   
                              if trim(pc_tipdoc) = 'RUC' then
                                pn_tdoc := 9;
                                
                                else 
                                     pn_tdoc := NULL;
                              END IF;
                    end if;              
         
         end if;
         
         begin
         
             select '1'
               into pc_flg
               from fsd001
              where pepais = 604
                and petdoc = pn_tdoc
                and pendoc = pc_doc;
                        
         exception
               when no_data_found then 
                    pc_flg := '0';
         end;
         
         
       end;

       return pc_flg;
end Fn_Es_Cliente;

Function Fn_tip_doc(pc_tipdoc in varchar2) return number is


pn_tdoc number(2);
begin
       begin
       
         if trim(pc_tipdoc) = 'DNI' then
            pn_tdoc := 21;
            
            else
                    if trim(pc_tipdoc) = 'CE' then
                      pn_tdoc := 2;
                      
                      else   
                              if trim(pc_tipdoc) = 'RUC' then
                                pn_tdoc := 9;
                                
                                else 
                                     pn_tdoc := NULL;
                              END IF;
                    end if;              
         
         end if;

         
         
       end;

       return pn_tdoc;
end Fn_tip_doc;

Function Fn_tip_docsql(pn_tipdoc in number) return varchar2 is
ps_tdoc varchar2(3);
begin
       begin
       
         if pn_tipdoc = 21 then
            ps_tdoc := 'DNI';
         else
            if pn_tipdoc = 2 then
               ps_tdoc := 'CE';
            else   
               if pn_tipdoc = 9 then
                  ps_tdoc := 'RUC';
               else 
                  ps_tdoc := NULL; 
               END IF;
            end if;              
         end if;
       end;
       return ps_tdoc;
end Fn_tip_docsql;

Procedure SP_CAUS_PROCBACH(pd_fecpro in date)is

----RECLAMOS
cursor reclamo is
select 1 JAQL420EMP,
       --pq_caus_web.Fn_Codigo(c_tiprec,d_fecrec),
       904 JAQL420AGE,
       extract(year from d_fecrec) JAQL420ANI,
       pq_caus_web.Fn_Trimestre(d_fecrec) JAQL420TRI,
       --pq_caus_web.Fn_Correlativo(c_tiprec,d_fecrec),
       604 JAQL420PAC,
       pq_caus_web.Fn_tip_doc(c_tipdoc) JAQL420TDC,
       c_numdoc JAQL420NDC,
       'BANTOTAL' JAQL420USR,
       to_date(d_fecrec,'dd/mm/yy') JAQL420FCR,
       'BANTOTAL' JAQL420USP,
       to_date(d_fecrec,'dd/mm/yy') JAQL420FCP,
       pq_caus_web.Fn_Equivalencia_Producto(c_codopr) JAQL420OPS,
       pq_caus_web.Fn_Equivalencia_Motivo(c_codmor,c_tiprec) JAQL420MOT,
       1 JAQL420ESR,
       pq_caus_web.Fn_Es_Cliente(c_tipdoc,c_numdoc) JAQL420FLC,
       'S' JAQL420EST,
       5 JAQL420VIR,
       1 JAQL420PRC,
       1 JAQL420TRC,
       c_dircon JAQL420DIR,
       c_dirref JAQL420REF,
       pq_caus_web.Fn_Ubigeo(c_ubgdir) JAQL420UBG,
       c_codrec JAQL420WEB,
       'N' JAQL420EDT,
       c_email JAQL420EML,
       c_numtel JAQL420TLF,
       1 JAQL420ACT,
       c_numcel JAQL420CEL,
       c_monpro JAQL420MPS,
       c_pedcon JAQL420PCC,
       c_tiprec,
       d_fecrec,
       c_apepat JAQL420APP,
       c_apemat JAQL420APM,
       c_nombre JAQL420NOM,
       (case
           when pq_caus_web.Fn_tip_doc(c_tipdoc) = 9 then c_nomcon
           else null
       end) JAQY290NOJ,
       to_number(c_codcan) JAQL420CAN, --- Req. 3653 09/12/2015  KDVC 
       c_departr JAQL420DOR,--- Req. 3653 09/12/2015  KDVC 
       c_provinr JAQL420POR,--- Req. 3653 09/12/2015  KDVC 
       to_number(c_seguro) JAQL420SEG,  --- Req. 3653 09/12/2015  KDVC 
       --to_char(d_fecrec,'HH24:MI:SS') JAQL420HOR --- Req. 3653 09/12/2015  KDVC extraigo la hora
       c_hora JAQL420HOR --- Req. 3653 09/12/2015  KDVC extraigo la hora
--  from reclamos@reclamos a
  from v_reclamos@reclamos a--2024.10.29 .. SQL Server
 where to_date(d_fecrec,'dd/mm/yy') = to_date(pd_fecpro,'dd/mm/yy')
 and c_codmor is not null 
 and c_codopr is not null
 --WCRW 22/12/2021 Importar reclamos registrados en la WEB
 and c_codure = 'HB01'
 order by d_fecrec
 ;

---CONSULTAS 
 cursor consultas is
select 1 JAQL420EMP,
       --pq_caus_web.Fn_Codigo(c_tiprec,d_fecrec),
       904 JAQL420AGE,
       extract(year from d_fecrec) JAQL420ANI,
       pq_caus_web.Fn_Trimestre(d_fecrec) JAQL420TRI,
       --pq_caus_web.Fn_Correlativo(c_tiprec,d_fecrec),
       604 JAQL420PAC,
       pq_caus_web.Fn_tip_doc(c_tipdoc) JAQL420TDC,
       c_numdoc JAQL420NDC,
       'BANTOTAL' JAQL420USR,
       to_date(d_fecrec,'dd/mm/yy') JAQL420FCR,
       'BANTOTAL' JAQL420USP,
       to_date(d_fecrec,'dd/mm/yy') JAQL420FCP,
       pq_caus_web.Fn_Equivalencia_Producto(c_codopr) JAQL420OPS,
       pq_caus_web.Fn_Equivalencia_Motivo(c_codmor,c_tiprec) JAQL420MOT,
       1 JAQL420ESR,
       pq_caus_web.Fn_Es_Cliente(c_tipdoc,c_numdoc) JAQL420FLC,
       'S' JAQL420EST,
       5 JAQL420VIR,
       1 JAQL420PRC,
       1 JAQL420TRC,
       c_dircon JAQL420DIR,
       c_dirref JAQL420REF,
       pq_caus_web.Fn_Ubigeo(c_ubgdir) JAQL420UBG,
       c_codrec JAQL420WEB,
       'N' JAQL420EDT,
       c_email JAQL420EML,
       c_numtel JAQL420TLF,
       1 JAQL420ACT,
       c_numcel JAQL420CEL,
       c_monpro JAQL420MPS,
       c_pedcon JAQL420PCC,
       c_tiprec,
       d_fecrec,
       c_apepat JAQL420APP,
       c_apemat JAQL420APM,
       c_nombre JAQL420NOM,
       'CPAREDES' JAQY290USA,
       (select b.prfgnom 
          from prfu00 a,prfg00 b 
         where a.prfgcod = b.prfgcod 
           and a.ubuser ='CPAREDES' 
           and prfufecalt = (select max(aa.prfufecalt)
                               from prfu00 aa
                              where aa.ubuser = a.ubuser)) JAQY290ARA,
       904 JAQY290AGA,
       TO_CHAR(d_fecrec,'HH24:MM:SS') JAQY290HCR,
       (case
           when pq_caus_web.Fn_tip_doc(c_tipdoc) = 9 then c_nomcon
           else null
       end) JAQY290NOJ
              
  from consultas@reclamos a
 where to_date(d_fecrec,'dd/mm/yy') = to_date(pd_fecpro,'dd/mm/yy')
 and c_codmor is not null 
 and c_codopr is not null
 order by d_fecrec
 ;


---REQUERIMIENTO 
cursor REQUERIMIENTO is
select 1 JAQL420EMP,
       --pq_caus_web.Fn_Codigo(c_tiprec,d_fecrec),
       904 JAQL420AGE,
       extract(year from d_fecrec) JAQL420ANI,
       pq_caus_web.Fn_Trimestre(d_fecrec) JAQL420TRI,
       --pq_caus_web.Fn_Correlativo(c_tiprec,d_fecrec),
       604 JAQL420PAC,
       pq_caus_web.Fn_tip_doc(c_tipdoc) JAQL420TDC,
       c_numdoc JAQL420NDC,
       'BANTOTAL' JAQL420USR,
       to_date(d_fecrec,'dd/mm/yy') JAQL420FCR,
       'BANTOTAL' JAQL420USP,
       to_date(d_fecrec,'dd/mm/yy') JAQL420FCP,
       pq_caus_web.Fn_Equivalencia_Producto(c_codopr) JAQL420OPS,
       pq_caus_web.Fn_Equivalencia_Motivo(c_codmor,c_tiprec) JAQL420MOT,
       1 JAQL420ESR,
       pq_caus_web.Fn_Es_Cliente(c_tipdoc,c_numdoc) JAQL420FLC,
       'S' JAQL420EST,
       5 JAQL420VIR,
       1 JAQL420PRC,
       1 JAQL420TRC,
       c_dircon JAQL420DIR,
       c_dirref JAQL420REF,
       pq_caus_web.Fn_Ubigeo(c_ubgdir) JAQL420UBG,
       c_codrec JAQL420WEB,
       'N' JAQL420EDT,
       c_email JAQL420EML,
       c_numtel JAQL420TLF,
       1 JAQL420ACT,
       c_numcel JAQL420CEL,
       c_monpro JAQL420MPS,
       c_pedcon JAQL420PCC,
       c_tiprec,
       d_fecrec,
       c_apepat JAQL420APP,
       c_apemat JAQL420APM,
       c_nombre JAQL420NOM,
       'CPAREDES' JAQY290USA,
       (select b.prfgnom 
          from prfu00 a,prfg00 b 
         where a.prfgcod = b.prfgcod 
           and a.ubuser ='CPAREDES' 
           and prfufecalt = (select max(aa.prfufecalt)
                               from prfu00 aa
                              where aa.ubuser = a.ubuser)) JAQY290ARA,
       904 JAQY290AGA,
       TO_CHAR(d_fecrec,'HH24:MM:SS') JAQY290HCR,
       (case
           when pq_caus_web.Fn_tip_doc(c_tipdoc) = 9 then c_nomcon
           else null
       end) JAQY290NOJ
  from requerimiento@reclamos a
 where to_date(d_fecrec,'dd/mm/yy') = to_date(pd_fecpro,'dd/mm/yy')
 ;
 
  
lc_codigo JAQL420.JAQL420COD%type;
ln_corr  jaql420.jaql420cor%type;

lc_codigoC JAQL420.JAQL420COD%type;
ln_corrC  jaql420.jaql420cor%type;

lc_codigoQ JAQL420.JAQL420COD%type;
ln_corrQ  jaql420.jaql420cor%type;
LVCCAD varchar(3000);

begin
          
     --RECLAMOS
     for i in reclamo loop
       begin
           lc_codigo := pq_caus_web.Fn_Codigo(i.c_tiprec,i.d_fecrec);
           ln_corr := pq_caus_web.Fn_Correlativo(i.c_tiprec,i.d_fecrec);
       
            insert into JAQL420(JAQL420EMP,JAQL420COD,JAQL420AGE,JAQL420ANI,JAQL420TRI,JAQL420COR,JAQL420PAC,
                                JAQL420TDC,JAQL420NDC,JAQL420USR,JAQL420FCR,JAQL420USP,JAQL420FCP,JAQL420OPS,
                                JAQL420MOT,JAQL420ESR,JAQL420FLC,JAQL420CMR,JAQL420EST,JAQL420VIR,JAQL420DOC,
                                JAQL420PRC,JAQL420TRC,JAQL420DIR,JAQL420REF,JAQL420UBG,JAQL420WEB,JAQL420EDT,
                                JAQL420EML,JAQL420TLF,JAQL420ACT,JAQL420CEL,JAQL420MPS,JAQL420PCC,JAQL420APP,
                                JAQL420APM,JAQL420NOM,JAQL420NOJ,JAQL420CAN, JAQL420DOR,JAQL420POR,JAQL420SEG,JAQL420HOR )--- Req. 3653 09/12/2015  KDVC  se adiciono JAQL420CAN, JAQL420DOR,JAQL420POR,JAQL420SEG,jaql420h
            values(i.jaql420emp,
                   lc_codigo,
                   i.jaql420age,
                   i.jaql420ani,
                   i.jaql420tri,
                   ln_corr,
                   i.jaql420pac,
                   i.jaql420tdc,
                   i.jaql420ndc,
                   i.jaql420usr,
                   i.jaql420fcr,
                   i.jaql420usp,
                   i.jaql420fcp,
                   i.jaql420ops,
                   i.jaql420mot,
                   i.jaql420esr,
                   i.jaql420flc,
                   '',
                   i.jaql420est,
                   i.jaql420vir,
                   '',
                   i.jaql420prc,
                   i.jaql420trc,
                   i.jaql420dir,
                   i.jaql420ref,
                   i.jaql420ubg,
                   i.jaql420web,
                   i.jaql420edt,
                   i.jaql420eml,
                   i.jaql420tlf,
                   i.jaql420act,
                   i.jaql420cel,
                   i.jaql420mps,
                   i.jaql420pcc,
                   i.jaql420app,
                   i.jaql420apm,
                   i.jaql420nom,
                   i.JAQY290NOJ,
                   i.JAQL420CAN, --- Req. 3653 09/12/2015  KDVC 
                   i.JAQL420DOR,--- Req. 3653 09/12/2015  KDVC 
                   i.JAQL420POR,--- Req. 3653 09/12/2015  KDVC 
                   i.JAQL420SEG,--- Req. 3653 09/12/2015  KDVC 
                   i.JAQL420HOR);--- Req. 3653 09/12/2015  KDVC 
                                            
       
       exception when others then
        LVCCAD := TO_CHAR('insert'||'-'||SQLCODE||' - '||SQLERRM);
        --insert into log_error_bandeja values(1,pc_codpro,LVCCAD,sysdate);
        --commit;     
        DBMS_OUTPUT.PUT_LINE(LVCCAD||'-'||lc_codigo);
       end;
       commit;
     end loop;
     
     --CONSULTAS
     
     for i in consultas loop
       begin
           lc_codigoC := pq_caus_web.Fn_Codigo(i.c_tiprec,i.d_fecrec);
           ln_corrC := pq_caus_web.Fn_Correlativo(i.c_tiprec,i.d_fecrec);
       
            insert into JAQY290(JAQY290EMP,JAQY290COD,JAQY290AGE,JAQY290ANI,JAQY290TRI,JAQY290COR,JAQY290PAC,
                                JAQY290TDC,JAQY290NDC,JAQY290USR,JAQY290FCR,JAQY290USP,JAQY290FCP,JAQY290OPS,
                                JAQY290MOT,JAQY290ESR,JAQY290FLC,JAQY290CMR,JAQY290EST,JAQY290VIR,JAQY290DOC,
                                JAQY290PRC,JAQY290DIR,JAQY290REF,JAQY290UBG,JAQY290WEB,JAQY290EDT,
                                JAQY290EML,JAQY290TLF,JAQY290ACT,JAQY290CEL,JAQY290FDA,JAQY290USA,JAQY290ARA,
                                JAQY290AGA,JAQY290HCR,JAQY290DLC,JAQY290UBC,JAQY290APP,JAQY290APM,JAQY290NOM,
                                JAQY290NOJ)
            values(i.jaql420emp,
                   lc_codigoC,
                   i.jaql420age,
                   i.jaql420ani,
                   i.jaql420tri,
                   ln_corrC,
                   i.jaql420pac,
                   i.jaql420tdc,
                   i.jaql420ndc,
                   i.jaql420usr,
                   i.jaql420fcr,
                   i.jaql420usp,
                   i.jaql420fcp,
                   i.jaql420ops,
                   i.jaql420mot,
                   i.jaql420esr,
                   i.jaql420flc,
                   '',
                   i.jaql420est,
                   i.jaql420vir,
                   '',
                   i.jaql420prc,
                   i.jaql420dir,
                   i.jaql420ref,
                   i.jaql420ubg,
                   i.jaql420web,
                   i.jaql420edt,
                   i.jaql420eml,
                   i.jaql420tlf,
                   i.jaql420act,
                   i.jaql420cel,
                   i.jaql420fcr,
                   i.JAQY290USA,
                   i.JAQY290ARA,
                   i.JAQY290AGA,
                   i.JAQY290HCR,
                   i.jaql420dir,
                   i.jaql420ubg,
                   i.jaql420app,
                   i.jaql420apm,
                   i.jaql420nom,
                   i.JAQY290NOJ
                   );
                                            
       
       
       end;
       commit;
     end loop;
     
     --REQUERMIENTO
     
     for i in REQUERIMIENTO loop
       begin
           lc_codigoQ := pq_caus_web.Fn_Codigo(i.c_tiprec,i.d_fecrec);
           ln_corrQ := pq_caus_web.Fn_Correlativo(i.c_tiprec,i.d_fecrec);
       
            insert into JAQY290_R(JAQY290_REMP,JAQY290_RCOD,JAQY290_RAGE,JAQY290_RANI,JAQY290_RTRI,JAQY290_RCOR,JAQY290_RPAC,
                                JAQY290_RTDC,JAQY290_RNDC,JAQY290_RUSR,JAQY290_RFCR,JAQY290_RUSP,JAQY290_RFCP,JAQY290_ROPS,
                                JAQY290_RMOT,JAQY290_RESR,JAQY290_RFLC,JAQY290_RCMR,JAQY290_REST,JAQY290_RVIR,JAQY290_RDOC,
                                JAQY290_RPRC,JAQY290_RDIR,JAQY290_RREF,JAQY290_RUBG,JAQY290_RWEB,JAQY290_REDT,
                                JAQY290_REML,JAQY290_RTLF,JAQY290_RACT,JAQY290_RCEL,JAQY290_RFDA,JAQY290_RUSA,JAQY290_RARA,
                                JAQY290_RAGA,JAQY290_RHCR,JAQY290_RDLC,JAQY290_RUBC,JAQY290_RAPP,JAQY290_RAPM,JAQY290_RNOM,
                                JAQY290_RNOJ)
            values(i.jaql420emp,
                   lc_codigoQ,
                   i.jaql420age,
                   i.jaql420ani,
                   i.jaql420tri,
                   ln_corrQ,
                   i.jaql420pac,
                   i.jaql420tdc,
                   i.jaql420ndc,
                   i.jaql420usr,
                   i.jaql420fcr,
                   i.jaql420usp,
                   i.jaql420fcp,
                   i.jaql420ops,
                   i.jaql420mot,
                   i.jaql420esr,
                   i.jaql420flc,
                   '',
                   i.jaql420est,
                   i.jaql420vir,
                   '',
                   i.jaql420prc,
                   i.jaql420dir,
                   i.jaql420ref,
                   i.jaql420ubg,
                   i.jaql420web,
                   i.jaql420edt,
                   i.jaql420eml,
                   i.jaql420tlf,
                   i.jaql420act,
                   i.jaql420cel,
                   i.jaql420fcr,
                   i.JAQY290USA,
                   i.JAQY290ARA,
                   i.JAQY290AGA,
                   i.JAQY290HCR,
                   i.jaql420dir,
                   i.jaql420ubg,
                   i.jaql420app,
                   i.jaql420apm,
                   i.jaql420nom,
                   i.JAQY290NOJ);
                                            
       
       
       end;
       commit;
     end loop;
end SP_CAUS_PROCBACH;

Procedure SP_CAUS_PROCBACH_II(pd_fecpro in date)is

begin
     execute immediate ('truncate table JAQL420_AUX');
     execute immediate ('truncate table JAQY290_AUX');
     execute immediate ('truncate table JAQY290R_AUX');
       begin 
       
       INSERT into JAQL420_AUX(JAQL420EMP,JAQL420AGE,JAQL420ANI,JAQL420TRI,JAQL420PAC,JAQL420TDC,
                              JAQL420NDC,JAQL420USR,JAQL420FCR,JAQL420USP,JAQL420FCP,JAQL420OPS,
                              JAQL420MOT,JAQL420ESR,JAQL420FLC,JAQL420EST,JAQL420VIR,JAQL420PRC,
                              JAQL420TRC,JAQL420DIR,JAQL420REF,JAQL420UBG,JAQL420WEB,JAQL420EDT,
                              JAQL420EML,JAQL420TLF,JAQL420ACT,JAQL420CEL,JAQL420MPS,JAQL420PCC,
                              C_TIPREC,D_FECREC,JAQL420APP,JAQL420APM,JAQL420NOM,JAQY290NOJ,
                              C_COMENT,C_ADJUNT,JAQL420HOR,JAQL420VRP,JAQL420CAN,JAQL420DOR,
                              JAQL420POR,JAQL420SEG,JAQL420FDA)
       
      select 1 JAQL420EMP,
             --pq_caus_web.Fn_Codigo(c_tiprec,d_fecrec),
             904 JAQL420AGE,
             extract(year from d_fecrec) JAQL420ANI,
             pq_caus_web.Fn_Trimestre(d_fecrec) JAQL420TRI,
             --pq_caus_web.Fn_Correlativo(c_tiprec,d_fecrec),
             604 JAQL420PAC,
             pq_caus_web.Fn_tip_doc(c_tipdoc) JAQL420TDC,
             c_numdoc JAQL420NDC,
             'BANTOTAL' JAQL420USR,
             to_date(d_fecrec,'dd/mm/yy') JAQL420FCR,
             'BANTOTAL' JAQL420USP,
             to_date(d_fecrec,'dd/mm/yy') JAQL420FCP,
             pq_caus_web.Fn_Equivalencia_Producto(c_codopr) JAQL420OPS,
             pq_caus_web.Fn_Equivalencia_Motivo(c_codmor,c_tiprec) JAQL420MOT,
             1 JAQL420ESR,
             pq_caus_web.Fn_Es_Cliente(c_tipdoc,c_numdoc) JAQL420FLC,
             'S' JAQL420EST,
             5 JAQL420VIR,
             1 JAQL420PRC,
             1 JAQL420TRC,
             substr((trim(c_dircon)||' Nro/Mz '||trim(c_nromza)||' Lote '||trim(c_nrlote)||' Int/Dpto'||trim(c_intdpt)||' Urb '||
             trim(c_urbani)),1,200),
             --c_dircon JAQL420DIR,
             substr(c_dirref,1,50) JAQL420REF,
             pq_caus_web.Fn_Ubigeo(c_ubgdir) JAQL420UBG,
             c_codrec JAQL420WEB,
             'N' JAQL420EDT,
             c_email JAQL420EML,
             c_numtel JAQL420TLF,
             1 JAQL420ACT,
             c_numcel JAQL420CEL,
             c_monpro JAQL420MPS,
             c_pedcon JAQL420PCC,
             c_tiprec,
             d_fecrec,
             trim(c_apepat) JAQL420APP,
             trim(c_apemat) JAQL420APM,
             trim(c_nombre) JAQL420NOM,
             (case
                 when pq_caus_web.Fn_tip_doc(c_tipdoc) = 9 then substr(c_nomcon,1,50)
                 else null
             end) JAQY290NOJ,
             SUBSTR(C_COMENT,1,1000),
             C_ADJUNT,
             C_Hora JAQL420HOR,--TO_CHAR(d_fecrec,'HH24:MM:SS'),
             case when trim(c_mdrpta) = 'Email' then 1
                  when trim(c_mdrpta) = 'Carta' then 2
                  else 0
             end ,
             to_number(c_codcan) JAQL420CAN, --- Req. 3653 09/12/2015  KDVC 
             c_departr JAQL420DOR,--- Req. 3653 09/12/2015  KDVC 
             c_provinr JAQL420POR,--- Req. 3653 09/12/2015  KDVC 
             to_number(c_seguro) JAQL420SEG, --- Req. 3653 09/12/2015  KDVC */
             c_fladat JAQL420FDA
--        from reclamos@reclamos a
        from v_reclamos@reclamos a--2024.10.29 .. SQL Server
       where to_date(d_fecrec,'dd/mm/yy') = to_date(pd_fecpro,'dd/mm/yy')
       and c_codmor is not null 
       and c_codopr is not null
       --WCRW 22/12/2021 Importar reclamos registrados en la WEB
       and c_codure = 'HB01'
       order by d_fecrec;
     
       end;
       commit;
       
       BEGIN
       
       insert into JAQY290_AUX(JAQL420EMP,JAQL420AGE,JAQL420ANI,JAQL420TRI,JAQL420PAC,JAQL420TDC,
                               JAQL420NDC,JAQL420USR,JAQL420FCR,JAQL420USP,JAQL420FCP,JAQL420OPS,
                               JAQL420MOT,JAQL420ESR,JAQL420FLC,JAQL420EST,JAQL420VIR,JAQL420PRC,
                               JAQL420TRC,JAQL420DIR,JAQL420REF,JAQL420UBG,JAQL420WEB,JAQL420EDT,
                               JAQL420EML,JAQL420TLF,JAQL420ACT,JAQL420CEL,JAQL420MPS,JAQL420PCC,
                               C_TIPREC,D_FECREC,JAQL420APP,JAQL420APM,JAQL420NOM,JAQY290USA,
                               JAQY290ARA,JAQY290AGA,JAQY290HCR,JAQY290NOJ,c_coment,c_adjunt,
                               JAQL420VRP)
       
       select 1 JAQL420EMP,
               --pq_caus_web.Fn_Codigo(c_tiprec,d_fecrec),
               904 JAQL420AGE,
               extract(year from d_fecrec) JAQL420ANI,
               pq_caus_web.Fn_Trimestre(d_fecrec) JAQL420TRI,
               --pq_caus_web.Fn_Correlativo(c_tiprec,d_fecrec),
               604 JAQL420PAC,
               pq_caus_web.Fn_tip_doc(c_tipdoc) JAQL420TDC,
               c_numdoc JAQL420NDC,
               'BANTOTAL' JAQL420USR,
               to_date(d_fecrec,'dd/mm/yy') JAQL420FCR,
               'BANTOTAL' JAQL420USP,
               to_date(d_fecrec,'dd/mm/yy') JAQL420FCP,
               pq_caus_web.Fn_Equivalencia_Producto(c_codopr) JAQL420OPS,
               pq_caus_web.Fn_Equivalencia_Motivo(c_codmor,c_tiprec) JAQL420MOT,
               1 JAQL420ESR,
               pq_caus_web.Fn_Es_Cliente(c_tipdoc,c_numdoc) JAQL420FLC,
               'S' JAQL420EST,
               5 JAQL420VIR,
               1 JAQL420PRC,
               1 JAQL420TRC,
               c_dircon JAQL420DIR,
               c_dirref JAQL420REF,
               pq_caus_web.Fn_Ubigeo(c_ubgdir) JAQL420UBG,
               c_codrec JAQL420WEB,
               'N' JAQL420EDT,
               c_email JAQL420EML,
               c_numtel JAQL420TLF,
               1 JAQL420ACT,
               c_numcel JAQL420CEL,
               c_monpro JAQL420MPS,
               c_pedcon JAQL420PCC,
               c_tiprec,
               d_fecrec,
               trim(c_apepat) JAQL420APP,
               trim(c_apemat) JAQL420APM,
               trim(c_nombre) JAQL420NOM,
               'CPAREDES' JAQY290USA,
               (select b.prfgnom 
                  from prfu00 a,prfg00 b 
                 where a.prfgcod = b.prfgcod 
                   and a.ubuser ='CPAREDES' 
                   and prfufecalt = (select max(aa.prfufecalt)
                                       from prfu00 aa
                                      where aa.ubuser = a.ubuser)
                   and rownum = 1) JAQY290ARA,
               904 JAQY290AGA,
               TO_CHAR(d_fecrec,'HH24:MM:SS') JAQY290HCR,
             --  C_HORA JAQY290HCR,
               (case
                   when pq_caus_web.Fn_tip_doc(c_tipdoc) = 9 then c_nomcon
                   else null
               end) JAQY290NOJ,
               SUBSTR(C_COMENT,1,1000),
               c_adjunt,
               case when trim(c_mdrpta) = 'Email' then 1
                  when trim(c_mdrpta) = 'Carta' then 2
                  else 0
             end
                      
          from consultas@reclamos a
         where to_date(d_fecrec,'dd/mm/yy') = to_date(pd_fecpro,'dd/mm/yy')
         and c_codmor is not null 
       and c_codopr is not null
       order by d_fecrec
         ;
       END;
       COMMIT;
       
       BEGIN
       insert into JAQY290R_AUX(JAQL420EMP,JAQL420AGE,JAQL420ANI,JAQL420TRI,JAQL420PAC,JAQL420TDC,
                               JAQL420NDC,JAQL420USR,JAQL420FCR,JAQL420USP,JAQL420FCP,JAQL420OPS,
                               JAQL420MOT,JAQL420ESR,JAQL420FLC,JAQL420EST,JAQL420VIR,JAQL420PRC,
                               JAQL420TRC,JAQL420DIR,JAQL420REF,JAQL420UBG,JAQL420WEB,JAQL420EDT,
                               JAQL420EML,JAQL420TLF,JAQL420ACT,JAQL420CEL,JAQL420MPS,JAQL420PCC,
                               C_TIPREC,D_FECREC,JAQL420APP,JAQL420APM,JAQL420NOM,JAQY290USA,
                               JAQY290ARA,JAQY290AGA,JAQY290HCR,JAQY290NOJ,c_coment,c_adjunt,
                               JAQL420VRP)
       
       select 1 JAQL420EMP,
               --pq_caus_web.Fn_Codigo(c_tiprec,d_fecrec),
               904 JAQL420AGE,
               extract(year from d_fecrec) JAQL420ANI,
               pq_caus_web.Fn_Trimestre(d_fecrec) JAQL420TRI,
               --pq_caus_web.Fn_Correlativo(c_tiprec,d_fecrec),
               604 JAQL420PAC,
               pq_caus_web.Fn_tip_doc(c_tipdoc) JAQL420TDC,
               c_numdoc JAQL420NDC,
               'BANTOTAL' JAQL420USR,
               to_date(d_fecrec,'dd/mm/yy') JAQL420FCR,
               'BANTOTAL' JAQL420USP,
               to_date(d_fecrec,'dd/mm/yy') JAQL420FCP,
               pq_caus_web.Fn_Equivalencia_Producto(c_codopr) JAQL420OPS,
               pq_caus_web.Fn_Equivalencia_Motivo(c_codmor,c_tiprec) JAQL420MOT,
               1 JAQL420ESR,
               pq_caus_web.Fn_Es_Cliente(c_tipdoc,c_numdoc) JAQL420FLC,
               'S' JAQL420EST,
               5 JAQL420VIR,
               1 JAQL420PRC,
               1 JAQL420TRC,
               c_dircon JAQL420DIR,
               c_dirref JAQL420REF,
               pq_caus_web.Fn_Ubigeo(c_ubgdir) JAQL420UBG,
               c_codrec JAQL420WEB,
               'N' JAQL420EDT,
               c_email JAQL420EML,
               c_numtel JAQL420TLF,
               1 JAQL420ACT,
               c_numcel JAQL420CEL,
               c_monpro JAQL420MPS,
               c_pedcon JAQL420PCC,
               c_tiprec,
               d_fecrec,
               c_apepat JAQL420APP,
               c_apemat JAQL420APM,
               c_nombre JAQL420NOM,
               'CPAREDES' JAQY290USA,
               (select b.prfgnom 
                  from prfu00 a,prfg00 b 
                 where a.prfgcod = b.prfgcod 
                   and a.ubuser ='CPAREDES' 
                   and prfufecalt = (select max(aa.prfufecalt)
                                       from prfu00 aa
                                      where aa.ubuser = a.ubuser)
                  and rownum = 1) JAQY290ARA,
               904 JAQY290AGA,
               TO_CHAR(d_fecrec,'HH24:MM:SS') JAQY290HCR,
               (case
                   when pq_caus_web.Fn_tip_doc(c_tipdoc) = 9 then c_nomcon
                   else null
               end) JAQY290NOJ,
               SUBSTR(C_COMENT,1,1000),
               C_ADJUNT,
               case when trim(c_mdrpta) = 'Email' then 1
                  when trim(c_mdrpta) = 'Carta' then 2
                  else 0
             end
          from requerimiento@reclamos a
         where to_date(d_fecrec,'dd/mm/yy') = to_date(pd_fecpro,'dd/mm/yy')
         and c_codmor is not null 
         and c_codopr is not null
         and trim(c_tiprec) = 'Requerimie'
         order by d_fecrec
         ;
       END;
       COMMIT;    
end SP_CAUS_PROCBACH_II;

Procedure SP_CAUS_PROCBACH_III(pd_fecpro in date)is

----RECLAMOS
cursor reclamo is
select JAQL420EMP,
       JAQL420AGE,
       JAQL420ANI,
       JAQL420TRI,
       JAQL420PAC,
       JAQL420TDC,
       JAQL420NDC,
       JAQL420USR,
       JAQL420FCR,
       JAQL420USP,
       JAQL420FCP,
       JAQL420OPS,
       JAQL420MOT,
       JAQL420ESR,
       JAQL420FLC,
       JAQL420EST,
       JAQL420VIR,
       JAQL420PRC,
       JAQL420TRC,
       JAQL420DIR,
       JAQL420REF,
       JAQL420UBG,
       JAQL420WEB,
       JAQL420EDT,
       JAQL420EML,
       JAQL420TLF,
       JAQL420ACT,
       JAQL420CEL,
       JAQL420MPS,
       JAQL420PCC,
       c_tiprec,
       d_fecrec,
       JAQL420APP,
       JAQL420APM,
       JAQL420NOM,
       JAQY290NOJ,
       A.C_COMENT,
       A.C_ADJUNT,
       A.JAQL420HOR,
       A.jaql420vrp,
       A.JAQL420CAN, --- Req. 3653 09/12/2015  KDVC 
       A.JAQL420DOR,--- Req. 3653 09/12/2015  KDVC 
       A.JAQL420POR,--- Req. 3653 09/12/2015  KDVC 
       A.JAQL420SEG,   --- Req. 3653 09/12/2015  KDVC */
       A.JAQL420FDA
  from JAQL420_AUX A
 ;

cursor consultas is
select JAQL420EMP,
       JAQL420AGE,
       JAQL420ANI,
       JAQL420TRI,
       JAQL420PAC,
       JAQL420TDC,
       JAQL420NDC,
       JAQL420USR,
       JAQL420FCR,
       JAQL420USP,
       JAQL420FCP,
       JAQL420OPS,
       JAQL420MOT,
       JAQL420ESR,
       JAQL420FLC,
       JAQL420EST,
       JAQL420VIR,
       JAQL420PRC,
       JAQL420TRC,
       JAQL420DIR,
       JAQL420REF,
       JAQL420UBG,
       JAQL420WEB,
       JAQL420EDT,
       JAQL420EML,
       JAQL420TLF,
       JAQL420ACT,
       JAQL420CEL,
       JAQL420MPS,
       JAQL420PCC,
       c_tiprec,
       d_fecrec,
       JAQL420APP,
       JAQL420APM,
       JAQL420NOM,
       JAQY290USA,
       JAQY290ARA,
       JAQY290AGA,
       JAQY290HCR,
       JAQY290NOJ,
       c_coment,
       c_adjunt,
       jaql420vrp
                      
  from jaqy290_aux;
  
cursor requerimiento is

select JAQL420EMP,
       JAQL420AGE,
       JAQL420ANI,
       JAQL420TRI,
       JAQL420PAC,
       JAQL420TDC,
       JAQL420NDC,
       JAQL420USR,
       JAQL420FCR,
       JAQL420USP,
       JAQL420FCP,
       JAQL420OPS,
       JAQL420MOT,
       JAQL420ESR,
       JAQL420FLC,
       JAQL420EST,
       JAQL420VIR,
       JAQL420PRC,
       JAQL420TRC,
       JAQL420DIR,
       JAQL420REF,
       JAQL420UBG,
       JAQL420WEB,
       JAQL420EDT,
       JAQL420EML,
       JAQL420TLF,
       JAQL420ACT,
       JAQL420CEL,
       JAQL420MPS,
       JAQL420PCC,
       c_tiprec,
       d_fecrec,
       JAQL420APP,
       JAQL420APM,
       JAQL420NOM,
       JAQY290USA,
       JAQY290ARA,
       JAQY290AGA,
       JAQY290HCR,
       JAQY290NOJ,
       C_COMENT,
       C_ADJUNT,
       jaql420vrp
  from JAQY290R_AUX;
          
            
lc_codigo JAQL420.JAQL420COD%type;
ln_corr   jaql420.jaql420cor%type;
lc_codigoC JAQL420.JAQL420COD%type;
ln_corrC   jaql420.jaql420cor%type;
lc_codigoQ JAQL420.JAQL420COD%type;
ln_corrQ   jaql420.jaql420cor%type;
LVCCAD varchar(3000);
lc_codweb JAQL420.JAQL420WEB%type;

begin
   --RECLAMOS
   for i in reclamo loop
      begin -- valida si existe en JAQL420 WCRW 06/10/2022
         select JAQL420WEB into lc_codweb from JAQL420 where JAQL420WEB = i.jaql420web;
      exception
      when no_data_found then
         begin
            lc_codigo := pq_caus_web.Fn_Codigo(i.c_tiprec,i.d_fecrec);
            ln_corr := pq_caus_web.Fn_Correlativo(i.c_tiprec,i.d_fecrec);
      
            insert into JAQL420(JAQL420EMP,JAQL420COD,JAQL420AGE,JAQL420ANI,JAQL420TRI,JAQL420COR,JAQL420PAC,
                                JAQL420TDC,JAQL420NDC,JAQL420USR,JAQL420FCR,JAQL420USP,JAQL420FCP,JAQL420OPS,
                                JAQL420MOT,JAQL420ESR,JAQL420FLC,JAQL420CMR,JAQL420EST,JAQL420VIR,JAQL420DOC,
                                JAQL420PRC,JAQL420TRC,JAQL420DIR,JAQL420REF,JAQL420UBG,JAQL420WEB,JAQL420EDT,
                                JAQL420EML,JAQL420TLF,JAQL420ACT,JAQL420CEL,JAQL420MPS,JAQL420PCC,JAQL420APP,
                                JAQL420APM,JAQL420NOM,JAQL420NOJ,JAQL420HOR,Jaql420vrp,
                                JAQL420CAN,JAQL420DOR,JAQL420POR,JAQL420SEG,JAQL420FDA ) --Req. 3653 09/12/2015  KDVC  se adiciono JAQL420CAN, JAQL420DOR,JAQL420POR,JAQL420SEG,jaql420h)
            values(i.jaql420emp,
                   lc_codigo,
                   i.jaql420age,
                   i.jaql420ani,
                   i.jaql420tri,
                   ln_corr,
                   i.jaql420pac,
                   i.jaql420tdc,
                   i.jaql420ndc,
                   i.jaql420usr,
                   i.jaql420fcr,
                   i.jaql420usp,
                   i.jaql420fcp,
                   i.jaql420ops,
                   i.jaql420mot,
                   i.jaql420esr,
                   i.jaql420flc,
                   i.c_coment,
                   i.jaql420est,
                   i.jaql420vir,
                   substr(i.c_adjunt,1,500),
                   i.jaql420prc,
                   i.jaql420trc,
                   i.jaql420dir,
                   i.jaql420ref,
                   i.jaql420ubg,
                   i.jaql420web,
                   i.jaql420edt,
                   i.jaql420eml,
                   i.jaql420tlf,
                   i.jaql420act,
                   i.jaql420cel,
                   i.jaql420mps,
                   i.jaql420pcc,
                   i.jaql420app,
                   i.jaql420apm,
                   i.jaql420nom,
                   i.JAQY290NOJ,
                   I.JAQL420HOR,
                   i.Jaql420vrp,
                   i.JAQL420CAN, --- Req. 3653 09/12/2015  KDVC 
                   i.JAQL420DOR,--- Req. 3653 09/12/2015  KDVC 
                   i.JAQL420POR,--- Req. 3653 09/12/2015  KDVC 
                   i.JAQL420SEG,
                   i.JAQL420FDA); --- 06/10/2022 WCRW 
         exception when others then
            LVCCAD := TO_CHAR('insert'||'-'||SQLCODE||' - '||SQLERRM);
            --insert into log_error_bandeja values(1,pc_codpro,LVCCAD,sysdate);
            --commit;     
            DBMS_OUTPUT.PUT_LINE(LVCCAD||'-'||lc_codigo);
         end;
         commit;     
       end;  
    end loop;
     
    for i in consultas loop
       begin
           lc_codigoC := pq_caus_web.Fn_Codigo(i.c_tiprec,i.d_fecrec);
           ln_corrC := pq_caus_web.Fn_Correlativo(i.c_tiprec,i.d_fecrec);
       
            insert into JAQY290(JAQY290EMP,JAQY290COD,JAQY290AGE,JAQY290ANI,JAQY290TRI,JAQY290COR,JAQY290PAC,
                                JAQY290TDC,JAQY290NDC,JAQY290USR,JAQY290FCR,JAQY290USP,JAQY290FCP,JAQY290OPS,
                                JAQY290MOT,JAQY290ESR,JAQY290FLC,JAQY290CMR,JAQY290EST,JAQY290VIR,JAQY290DOC,
                                JAQY290PRC,JAQY290DIR,JAQY290REF,JAQY290UBG,JAQY290WEB,JAQY290EDT,
                                JAQY290EML,JAQY290TLF,JAQY290ACT,JAQY290CEL,JAQY290FDA,JAQY290USA,JAQY290ARA,
                                JAQY290AGA,JAQY290HOR,JAQY290DLC,JAQY290UBC,JAQY290APP,JAQY290APM,JAQY290NOM,
                                JAQY290NOJ,Jaqy290vrp)
            values(i.jaql420emp,
                   lc_codigoC,
                   i.jaql420age,
                   i.jaql420ani,
                   i.jaql420tri,
                   ln_corrC,
                   i.jaql420pac,
                   i.jaql420tdc,
                   i.jaql420ndc,
                   i.jaql420usr,
                   i.jaql420fcr,
                   i.jaql420usp,
                   i.jaql420fcp,
                   i.jaql420ops,
                   i.jaql420mot,
                   i.jaql420esr,
                   i.jaql420flc,
                   i.c_coment,
                   i.jaql420est,
                   i.jaql420vir,
                   i.c_adjunt,
                   i.jaql420prc,
                   i.jaql420dir,
                   i.jaql420ref,
                   i.jaql420ubg,
                   i.jaql420web,
                   i.jaql420edt,
                   i.jaql420eml,
                   i.jaql420tlf,
                   i.jaql420act,
                   i.jaql420cel,
                   i.jaql420fcr,
                   i.JAQY290USA,
                   i.JAQY290ARA,
                   i.JAQY290AGA,
                   i.JAQY290HCR,
                   i.jaql420dir,
                   i.jaql420ubg,
                   i.jaql420app,
                   i.jaql420apm,
                   i.jaql420nom,
                   i.JAQY290NOJ,
                   i.Jaql420vrp
                   );
       end;
       commit;
     end loop;
     
     for i in requerimiento loop
       begin
           lc_codigoQ := pq_caus_web.Fn_Codigo(i.c_tiprec,i.d_fecrec);
           ln_corrQ := pq_caus_web.Fn_Correlativo(i.c_tiprec,i.d_fecrec);
       
            insert into JAQY290_R(JAQY290_REMP,JAQY290_RCOD,JAQY290_RAGE,JAQY290_RANI,JAQY290_RTRI,JAQY290_RCOR,JAQY290_RPAC,
                                JAQY290_RTDC,JAQY290_RNDC,JAQY290_RUSR,JAQY290_RFCR,JAQY290_RUSP,JAQY290_RFCP,JAQY290_ROPS,
                                JAQY290_RMOT,JAQY290_RESR,JAQY290_RFLC,JAQY290_RCMR,JAQY290_REST,JAQY290_RVIR,JAQY290_RDOC,
                                JAQY290_RPRC,JAQY290_RDIR,JAQY290_RREF,JAQY290_RUBG,JAQY290_RWEB,JAQY290_REDT,
                                JAQY290_REML,JAQY290_RTLF,JAQY290_RACT,JAQY290_RCEL,JAQY290_RFDA,JAQY290_RUSA,JAQY290_RARA,
                                JAQY290_RAGA,JAQY290_RHOR,JAQY290_RDLC,JAQY290_RUBC,JAQY290_RAPP,JAQY290_RAPM,JAQY290_RNOM,
                                JAQY290_RNOJ,Jaqy290_Rvrp)
            values(i.jaql420emp,
                   lc_codigoQ,
                   i.jaql420age,
                   i.jaql420ani,
                   i.jaql420tri,
                   ln_corrQ,
                   i.jaql420pac,
                   i.jaql420tdc,
                   i.jaql420ndc,
                   i.jaql420usr,
                   i.jaql420fcr,
                   i.jaql420usp,
                   i.jaql420fcp,
                   i.jaql420ops,
                   i.jaql420mot,
                   i.jaql420esr,
                   i.jaql420flc,
                   i.c_coment,
                   i.jaql420est,
                   i.jaql420vir,
                   i.c_adjunt,
                   i.jaql420prc,
                   i.jaql420dir,
                   i.jaql420ref,
                   i.jaql420ubg,
                   i.jaql420web,
                   i.jaql420edt,
                   i.jaql420eml,
                   i.jaql420tlf,
                   i.jaql420act,
                   i.jaql420cel,
                   i.jaql420fcr,
                   i.JAQY290USA,
                   i.JAQY290ARA,
                   i.JAQY290AGA,
                   i.JAQY290HCR,
                   i.jaql420dir,
                   i.jaql420ubg,
                   i.jaql420app,
                   i.jaql420apm,
                   i.jaql420nom,
                   i.JAQY290NOJ,
                   i.Jaql420vrp
                   );
       end;
       commit;
     end loop;
     -- WCRW 27/12/2021 Actualiza Estados y reclamos de bantotal en SQL Server
     sp_inssqlrec(pd_fecpro);
     sp_actsqlrec(pd_fecpro);    
end SP_CAUS_PROCBACH_III;

Procedure SP_ActSQLRec(pd_fecpro in date)is

----RECLAMOS
cursor recweb is
select jaql420cod,jaql420fcr,jaql420fcp,CASE when jaql420fcc < jaql420fcr then jaql420fcr when jaql420fcc is null then jaql420fcr
       else jaql420fcc end as jaql420fcc,trim(b.tp1desc) as desest,jaql420web,trim(c.tp1desc) as descan
  from jaql420 a,FST198 b,FST198 c
 where a.jaql420fcp = pd_fecpro
   and b.Tp1cod = 1
   and b.Tp1cod1 = 10871
   and b.Tp1corr1 = 3    
   and b.Tp1corr2 = 7
   and b.Tp1nro1 = 1 
   and a.jaql420esr = b.tp1corr3
   and c.Tp1cod = 1
   and c.Tp1cod1 = 10871
   and c.Tp1corr1 = 3    
   and c.Tp1corr2 = 1
   and c.Tp1nro1 = 1 
   and a.jaql420vir = c.tp1corr3;
LVCCAD varchar(3000);
--ls_codrec nvarchar2(20);
lc_codigo JAQL420.JAQL420COD%type;
begin
   --Actualiza Estado y Fecha reclamos web
   for i in recweb loop
      begin
         if substr(i.jaql420web,5,3) = '000' then
             --ls_codrec := i.jaql420web; -- Verison Nueva
             UPDATE "reclamos"@reclamos
                --SET "C_DESEST" = i.desest,"D_FECEST" = i.jaql420fcp,"C_DESCAN" = i.descan 
                --WCRW 20/04/2022 se cambia por el campo jaql420fcc
                SET "C_DESEST" = i.desest,"D_FECEST" = i.jaql420fcc,"C_DESCAN" = i.descan
              WHERE "C_CODREC" = i.jaql420web; -- Version anterior
              --WHERE "C_CODREC" = ls_codrec; -- Version nueva
         else
            --ls_codrec := i.jaql420cod; -- Verison Nueva
            UPDATE "reclamos"@reclamos
               SET "C_DESEST" = i.desest,"D_FECEST" = i.jaql420fcc,"C_DESCAN" = i.descan
             WHERE "C_CODREC" = i.jaql420cod; -- Version Anterior
             --WHERE "C_CODREC" = ls_codrec; -- Version Nueva
         end if;
       exception when others then
        LVCCAD := TO_CHAR('insert'||'-'||SQLCODE||' - '||SQLERRM);
        --insert into log_error_bandeja values(1,pc_codpro,LVCCAD,sysdate);
        --commit;     
        DBMS_OUTPUT.PUT_LINE(LVCCAD||'-'||lc_codigo);
       end;
       commit;
   end loop;
end SP_ActSQLRec;

Procedure SP_InsSQLRec(pd_fecpro in date)is

----RECLAMOS
cursor recweb is
select jaql420cod,jaql420fcr,jaql420fcp,CASE when jaql420fcc < jaql420fcr then jaql420fcr when jaql420fcc is null then jaql420fcr
       else jaql420fcc end as jaql420fcc,trim(b.tp1desc) as desest,jaql420ndc,trim(c.penom) as nomcom,jaql420usr,
       PQ_CAUS_WEB.Fn_tip_docsql(jaql420tdc) as tipdoc,substr(jaql420cod,5,3) as ls_codage
  from jaql420 a,FST198 b,FSD001 c
 where a.jaql420fcr = pd_fecpro
   and b.Tp1cod = 1
   and b.Tp1cod1 = 10871
   and b.Tp1corr1 = 3    
   and b.Tp1corr2 = 7
   and b.Tp1nro1 = 1 
   and a.jaql420esr = b.tp1corr3
   and c.Pepais = a.jaql420pac
   and c.Petdoc = a.jaql420tdc
   and c.Pendoc = a.jaql420ndc;
LVCCAD varchar(3000);
ls_codrec nvarchar2(20);
--ls_codage nvarchar2(3);
lc_codigo JAQL420.JAQL420COD%type;
ln_flag number(1);
begin
   --Actualiza Estado y Fecha reclamos web
   for i in recweb loop
      if i.jaql420usr <> 'BANTOTAL' then
         ln_flag := 0;
         ls_codrec := '';
         begin
          select c_codrec into ls_codrec from "reclamos"@reclamos where c_codrec = i.jaql420cod;
         exception when NO_DATA_FOUND then
            begin
            --ls_codage := substr(i.jaql420cod,5,3);
            --WCRW 20/04/2022 jaql420fcp se cambia por el campo jaql420fcc
            INSERT INTO "reclamos"@reclamos (c_codrec,c_numdoc,d_fecrec,d_fecest,c_desest,c_nomcon,c_codage,c_codcma,c_codure,c_tipdoc)
            VALUES (i.jaql420cod,i.jaql420ndc,i.jaql420fcr,i.jaql420fcc,i.desest,i.nomcom,i.ls_codage,'004',i.jaql420usr,i.tipdoc);
            exception when others then
               LVCCAD := TO_CHAR('insert'||'-'||SQLCODE||' - '||SQLERRM);
               DBMS_OUTPUT.PUT_LINE(LVCCAD||'-'||lc_codigo);
            end;
         commit;
         end; 
       end if;
   end loop;
end SP_InsSQLRec;

end PQ_CAUS_WEB;
/

