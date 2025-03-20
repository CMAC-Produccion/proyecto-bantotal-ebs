create or replace package PQ_UNICAS_MULTIPLES is

  Function Fn_Ejecutivo (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                       pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) return char;
  Function fn_analista (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                      pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) return char;

end PQ_UNICAS_MULTIPLES;
/

create or replace package body PQ_UNICAS_MULTIPLES is

Function Fn_Ejecutivo (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                       pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) 
return char
IS


lc_user      char(20);
lc_flag      char(5);
ln_sbop      number(5);
ln_instancia number(20);

Begin

    --if pn_mod in(21,22) then
           
         begin
         
             select a.jaql61user
               into lc_user
               from jaql061 a
              where a.jaql61pgco = 1
                and a.jaql61pais = pn_pais
                and a.jaql61tdoc = pn_tdoc
                and a.jaql61ndoc = pc_ndoc
                and a.jaql61esta = 'S';
          exception 
                when others then
                      lc_user:=null;
          end; 
    --end if; 
    if lc_user is null then
        Begin
             select 'S',b.aosbop 
               into lc_flag,ln_sbop
               from fsd010 b
              where b.pgcod  = 1
                and b.aomod  = pn_mod
                and b.aosuc  = pn_suc
                and b.aomda  = pn_mda
                and b.aopap  = 0
                and b.aocta  = pn_cta
                and b.aooper = pn_oper
                and b.aotope = pn_top
                and b.aostat <> 99;
          exception
                when others then
                     lc_flag := 'N';
          end; 
          
          ln_instancia := fn_instancia_credito(pn_mod,pn_suc,pn_mda,0,pn_cta,pn_oper,ln_sbop,pn_top);
          
                    
          if lc_flag = 'S' then
          
             begin 
               select c.sng001ase
                 into lc_user 
                 from sng001 c
                where c.sng001emp = 1
                  --and c.sng001cta  = pn_cta
                  and c.sng001inst = ln_instancia
                  /*and rownum = 1*/;
             exception     
             when others then
                  lc_user := null;
             end;
             
          end if;
       
    
    
    end if;
    
          
    return lc_user;

end Fn_Ejecutivo;

Function fn_analista (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                      pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) return char 

IS

--lc_user char(20);
lc_flag char(5);
ln_sbop number(5);
ln_instancia number(20);
lc_analista char(20);
ln_mod       number(5); 
ln_suc       number(5);
ln_mda       number(5);
ln_pap       number(5);
ln_cta       number(12);
ln_oper      number(12);
ln_tope      number(5);

Begin

    
       /*    
         begin
         
             select a.jaql61user
               into lc_user
               from jaql061 a
              where a.jaql61pgco = 1
                and a.jaql61pais = pn_pais
                and a.jaql61tdoc = pn_tdoc
                and a.jaql61ndoc = pc_ndoc
                and a.jaql61esta = 'S';
          exception 
                when others then
                      lc_user:=null;
          end; */
    
    if /*lc_user is null and*/ pn_cta <> 0 then
        Begin
             select 'S',b.aosbop 
               into lc_flag,ln_sbop
               from fsd010 b
              where b.pgcod  = 1
                and b.aomod  = pn_mod
                and b.aosuc  = pn_suc
                and b.aomda  = pn_mda
                and b.aopap  = 0
                and b.aocta  = pn_cta
                and b.aooper = pn_oper
                and b.aotope = pn_top
                and b.aostat <> 99;
          exception
                when no_data_found then
                     Begin
                       select 'S',b.aosbop 
                         into lc_flag,ln_sbop
                         from fsd010 b
                        where b.pgcod  = 1
                          and b.aomod  = pn_mod
                          and b.aosuc  = pn_suc
                          and b.aomda  = pn_mda
                          and b.aopap  = 0
                          and b.aocta  = pn_cta
                          and b.aooper = pn_oper
                          and b.aotope = pn_top
                          and rownum = 1;
                    exception
                          when others then
                               lc_flag := 'N';
                    end;
          end; 
          
          ln_instancia := fn_instancia_credito(pn_mod,pn_suc,pn_mda,0,pn_cta,pn_oper,ln_sbop,pn_top);
          
                    
          if lc_flag = 'S' then
          
             begin 
               select c.sng001ase
                 into lc_analista 
                 from sng001 c
                where c.sng001emp = 1
                  --and c.sng001cta  = pn_cta
                  and c.sng001inst = ln_instancia
                  /*and rownum = 1*/;
             exception     
             when others then
                  lc_analista := null;
             end;
             
          end if;
       
          else
              Begin
                 select 'S',b.aomod,b.aosuc,b.aomda,b.aopap,b.aocta,b.aooper,b.aosbop,b.aotope 
                   into lc_flag,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_oper,ln_sbop,ln_tope
                   from fsd010 b,fsr008 h
                  where h.pgcod  = 1
                    and h.pepais = pn_pais
                    and h.petdoc = pn_tdoc
                    and h.pendoc = pc_ndoc
                    and b.pgcod  = 1
                    and b.aocta  = h.ctnro
                    and h.cttfir = 'T'
                    and b.aomod  in (select modulo from fst111 f where f.dscod = 50)
                    and rownum   = 1;
              exception
                   when others then
                        lc_flag := 'N';
                   
              end; 
              
              ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_oper,ln_sbop,ln_tope);
          
                    
              if lc_flag = 'S' then
              
                 begin 
                   select c.sng001ase
                     into lc_analista 
                     from sng001 c
                    where c.sng001emp = 1
                      --and c.sng001cta  = pn_cta
                      and c.sng001inst = ln_instancia
                      /*and rownum = 1*/;
                 exception     
                 when others then
                      lc_analista := null;
                 end;
                 
              end if;
        
    end if;
    /*
    
    if lc_user is null and pn_cta = 0 then
        Begin
             select 'S',b.aomod,b.aosuc,b.aomda,b.aopap,b.aocta,b.aooper,b.aosbop,b.aotope 
               into lc_flag,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_oper,ln_sbop,ln_tope
               from fsd010 b,fsr008 h
              where h.pgcod  = 1
                and h.pepais = pn_pais
                and h.petdoc = pn_tdoc
                and h.pendoc = pc_ndoc
                and b.pgcod  = 1
                and b.aocta  = h.ctnro
                and h.cttfir = 'T'
                and b.aomod  in (select modulo from fst111 f where f.dscod = 50)
                and rownum   = 1;
          exception
                
                          when others then
                               lc_flag := 'N';
                    --end;
          end; 
          
          ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_oper,ln_sbop,ln_tope);
          
                    
          if lc_flag = 'S' then
          
             begin 
               select c.sng001ase
                 into lc_analista 
                 from sng001 c
                where c.sng001emp = 1
                  --and c.sng001cta  = pn_cta
                  and c.sng001inst = ln_instancia
                  ;
             exception     
             when others then
                  lc_analista := null;
             end;
             
          end if;
       
          
    
    end if;*/
    
    
    
    
          
    return lc_analista;
end fn_analista;

end PQ_UNICAS_MULTIPLES;
/

