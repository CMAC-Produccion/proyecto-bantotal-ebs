create or replace package pq_cr_capital_negativo is
  -- Author  : DCASTRO
  -- Created : 02/08/2021
  -- Purpose : Indicador capital negativo
  -- MODIFCADO :

procedure sp_existe(pn_instancia  in number,
                         pc_ind out varchar2);

procedure sp_existe_609 (pn_instancia  in number,
                         pc_ind out varchar2);
                         
                         
end pq_cr_capital_negativo;
/

create or replace package body pq_cr_capital_negativo is



procedure sp_existe(pn_instancia  in number,
                         pc_ind out varchar2) is

--dcastro 02/08/2021 dcastro se agrego indicador si tiene capital negativo


lc_tipo varchar2(1);
pn_emp number;
pn_suc number;
pn_mod number;
pn_mda number;
pn_pap number;
pn_cta number;
pn_ope number;
pn_sbo number;
pn_top number;
ln_capneg number := 0;
ld_fecpag date;


begin

   lc_tipo := 'N'; --- 2021/04/23 se inicializo variable dcastro     

    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;

    if pn_cta is not null then

       begin
         SELECT min(j.ppfpag)
         INTO ld_fecpag 
         FROM FSD601 J   
             WHERE J.PGCOD = pn_emp
               AND J.PPMOD = pn_mod
               AND J.PPSUC = pn_suc
               AND J.PPMDA = pn_mda
               AND J.PPPAP = pn_pap
               AND J.PPCTA = pn_cta
               AND J.PPOPER = pn_ope
               AND J.PPSBOP = pn_sbo
               AND J.PPTOPE = pn_top
               AND j.d601co  in ( 'S' ,'X')
               AND j.ppfpag >   
                      (SELECT max(j.ppfpag)
                       FROM FSD602 J   
                           WHERE J.PGCOD = pn_emp
                             AND J.PPMOD = pn_mod
                             AND J.PPSUC = pn_suc
                             AND J.PPMDA = pn_mda
                             AND J.PPPAP = pn_pap
                             AND J.PPCTA = pn_cta
                             AND J.PPOPER = pn_ope
                             AND J.PPSBOP = pn_sbo
                             AND J.PPTOPE = pn_top
                             AND j.pp1stat = 'T' 
                             AND j.d602co  = 'S' );
        exception when others then
             begin
               SELECT max(j.ppfpag)
               INTO ld_fecpag 
               FROM FSD602 J   
                   WHERE J.PGCOD = pn_emp
                     AND J.PPMOD = pn_mod
                     AND J.PPSUC = pn_suc
                     AND J.PPMDA = pn_mda
                     AND J.PPPAP = pn_pap
                     AND J.PPCTA = pn_cta
                     AND J.PPOPER = pn_ope
                     AND J.PPSBOP = pn_sbo
                     AND J.PPTOPE = pn_top
                     AND j.pp1stat = 'P'
                     AND j.d602co  = 'S' ;
              exception when others then
                  ld_fecpag := null;      
              end;    
        end;
        
        if ld_fecpag is null then
            begin
               SELECT min(j.ppfpag)
               INTO ld_fecpag 
               FROM FSD601 J   
                   WHERE J.PGCOD = pn_emp
                     AND J.PPMOD = pn_mod
                     AND J.PPSUC = pn_suc
                     AND J.PPMDA = pn_mda
                     AND J.PPPAP = pn_pap
                     AND J.PPCTA = pn_cta
                     AND J.PPOPER = pn_ope
                     AND J.PPSBOP = pn_sbo
                     AND J.PPTOPE = pn_top
                     AND j.d601co in ( 'S', 'X');      
             exception when others then
                   ld_fecpag := null;    
             end;        
        end if;
        
        if ld_fecpag is not null then
          
          begin
           SELECT count(*)
           INTO ln_capneg
           FROM FSD601 J   
               WHERE J.PGCOD = pn_emp
                 AND J.PPMOD = pn_mod
                 AND J.PPSUC = pn_suc
                 AND J.PPMDA = pn_mda
                 AND J.PPPAP = pn_pap
                 AND J.PPCTA = pn_cta
                 AND J.PPOPER = pn_ope
                 AND J.PPSBOP = pn_sbo
                 AND J.PPTOPE = pn_top
                 AND j.ppfpag >= ld_fecpag
                 AND j.ppcap < 0;
                 --AND j.d601co = 'S';      
          exception when others then
              ln_capneg := 0;
          end;
  
          if ln_capneg > 0 then
             pc_ind := 'S';
          else
             pc_ind := 'N';
          end if; 
                
        else
                 pc_ind := 'E';
        end if;          
   else 
      pc_ind := 'E';
   end if;
            
end sp_existe;

procedure sp_existe_609 (pn_instancia  in number,
                         pc_ind out varchar2) is

--dcastro 02/08/2021 dcastro se agrego indicador si tiene capital negativo


lc_tipo varchar2(1);
pn_emp number;
pn_suc number;
pn_mod number;
pn_mda number;
pn_pap number;
pn_cta number;
pn_ope number;
pn_sbo number;
pn_top number;
ln_capneg number := 0;
ld_fecpag date;


begin

   lc_tipo := 'N'; --- 2021/04/23 se inicializo variable dcastro     

    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;

    if pn_cta is not null then

       begin
         SELECT min(j.ppfpag)
         INTO ld_fecpag 
         FROM FSD601 J   
             WHERE J.PGCOD = pn_emp
               AND J.PPMOD = pn_mod
               AND J.PPSUC = pn_suc
               AND J.PPMDA = pn_mda
               AND J.PPPAP = pn_pap
               AND J.PPCTA = pn_cta
               AND J.PPOPER = pn_ope
               AND J.PPSBOP = 609
               AND J.PPTOPE = pn_top
               AND j.d601co  = 'X';
                
        exception when others then
            ld_fecpag := null;      
        end;
        
        
        if ld_fecpag is not null then
          
          begin
           SELECT count(*)
           INTO ln_capneg
           FROM FSD601 J   
               WHERE J.PGCOD = pn_emp
                 AND J.PPMOD = pn_mod
                 AND J.PPSUC = pn_suc
                 AND J.PPMDA = pn_mda
                 AND J.PPPAP = pn_pap
                 AND J.PPCTA = pn_cta
                 AND J.PPOPER = pn_ope
                 AND J.PPSBOP = 609
                 AND J.PPTOPE = pn_top
                 AND j.ppcap < 0
                 AND j.d601co = 'X';      
          exception when others then
              ln_capneg := 0;
          end;
  
          if ln_capneg > 0 then
             pc_ind := 'S';
          else
             pc_ind := 'N';
          end if; 
                
        else
                 pc_ind := 'E';
        end if;          
   else 
      pc_ind := 'E';
   end if;
            
end sp_existe_609;


end pq_cr_capital_negativo;
/

