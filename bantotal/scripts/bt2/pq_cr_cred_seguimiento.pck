create or replace package pq_cr_cred_seguimiento is

  -- Author  : KVALENCIAC
  -- Created : 13/03/2018 07:09:44 p.m.
  -- Purpose : Control de Seguimiento de Créditos - Área de Control de Créditos
  -- Fecha de Modificación      : 20/05/2019
  -- Autor de la Modificación   : KVALENCIAC        
  -- Descripción de Modificación: Se modificó el listado de los cancelados los obtengo de la FSD010
  -- Fecha de Modificación      : 03/10/2019  
  -- Autor de la Modificación   : KVALENCIAC        
  -- Descripción de Modificación: Se modificó el listado de los cancelados para que solo este el último estado del crédito

  procedure sp_ExtraeListado (pn_user in varchar2, pn_pgcod in number, pn_sucursal in number, pc_Situacion in varchar2, pd_Pgfape in date,pd_PgfapeAnt in date, pc_Analista in varchar2, pn_cuenta in number);
  Function fn_nombre(pn_Pais in number,pn_Tdoc in number,pc_Numdoc in char)return character;
  Function fn_analista_credito(v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number)return character;
  procedure sp_cr_SegmntLinea(ln_Instancia in number,
                              P_N_CODCAl   out number,
                              P_C_DESCAL   out varchar2);                                               
  end pq_cr_cred_seguimiento;
/

create or replace package body pq_cr_cred_seguimiento is
procedure sp_ExtraeListado (pn_user in varchar2, pn_pgcod in number, pn_sucursal in number, pc_Situacion in varchar2, pd_Pgfape in date,pd_PgfapeAnt in date, pc_Analista in varchar2, pn_cuenta in number) is 
  vn_relcod number;
  vc_analista char(10);
  vc_sentencia varchar(5000);
  vn_continua number;
  cursor creditos is  --kdvc 03/10/2019
  select pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope
  from fsd010 d
  inner join fst111 s on s.dscod=50 and s.modulo=d.aomod
  where d.pgcod=pn_pgcod and d.aosuc=pn_sucursal
  and d.aostat=99 and aofe99<=pd_Pgfape
  and pq_cr_cred_seguimiento.fn_analista_credito(aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope) = vc_analista
  and ( d.aocta,d.aooper) not in (select jaqz285cta,jaqz285ope from jaqz285 where jaqz285cta=d.aocta and jaqz285ope=d.aooper and jaqz285MDA=d.aomda);
begin    
    vc_analista := pc_Analista;
    if (pc_Situacion = 'V') then
      begin
         delete jaqz287 where jaqz287USER=pn_user;--kdvc 03/10/2019
         commit;
         vc_sentencia:= 'insert into jaqz287 (jaqz287USER,jaqz287MOD,jaqz287SUC,jaqz287MDA,jaqz287PAP,jaqz287CTA,jaqz287OPE,jaqz287SOPE,jaqz287TOPE,jaqz287EST,jaqz287PAIS,jaqz287TDOC,jaqz287NDOC,jaqz287cliente,
                         jaqz287Anacre,jaqz287SIT,jaqz287fechact,JAQZ287FECD)
                    select ''' || pn_user || ''',                           
                           scmod,
                           scsuc,
                           f.scmda,
                           f.scpap,
                           sccta,
                           scoper, 
                           f.scsbop,
                           f.sctope,
                           f.scstat,                          
                           r.pepais,
                           r.petdoc,
                           r.pendoc,
                           pq_cr_cred_seguimiento.fn_nombre(pepais,petdoc,pendoc) cliente,
                           pq_cr_cred_seguimiento.fn_analista_credito(scmod,scsuc,f.scmda,f.scpap,sccta,scoper, f.scsbop,f.sctope) analista,
                           ''' || pc_Situacion || ''',                           
                           ''' || pd_Pgfape || ''',
                           f.scfval
                      from fsd011 f
                      inner join fst111 s on s.dscod=50 and s.modulo=f.scmod
                      inner join fsr008 r on r.pgcod=f.pgcod and r.ctnro=f.sccta and r.cttfir='||'''T''' ||'
                      where f.pgcod=''' || pn_pgcod  || ''' and  f.scsuc=''' || pn_sucursal || ''' and f.scstat <>99 ';
                      
         if ( pn_cuenta <> 0 ) then
            vc_sentencia := vc_sentencia || ' and f.sccta=' || pn_cuenta ;
         end if;
         vc_sentencia := vc_sentencia || ' 
                      and pq_cr_cred_seguimiento.fn_analista_credito(scmod,scsuc,f.scmda,f.scpap,sccta,scoper, f.scsbop,f.sctope)='''|| vc_analista || ''' 
                      and ( f.scoper not in (select jaqz285ope from jaqz285 where jaqz285cta=f.sccta and jaqz285ope=f.scoper and jaqz285MDA=f.scmda))
                      group by ''' || pn_user ||''',scmod,scsuc,f.scmda,f.scpap,f.sccta,f.scoper,f.scsbop,f.sctope,f.scstat,r.pepais,r.petdoc,r.pendoc,''' ||  pc_Situacion || ''',''' || pd_Pgfape ||''',f.scfval
                      order by f.PGCOD, f.SCSUC';
                      dbms_output.put_line (vc_sentencia);
         EXECUTE IMMEDIATE vc_sentencia; -- kdvc 03/10/2019    se creo sentencia dinámica  
         commit;         
      end;
     end if;
     if (pc_Situacion = 'C') then --se modificó 20/05/2019
       --inicio de cambios kdvc 03/10/2019
         delete jaqz287 where jaqz287USER=pn_user;
         commit;         
         for i in creditos loop           
              vn_continua := 1;
             if ( pn_cuenta <> 0 ) then
               vn_continua := 0;
               if ( pn_cuenta = i.Aocta ) then
                    vn_continua := 1;
               end if;
             end if; 
             if ( vn_continua = 1 ) then 
                     begin
                     select Relcod into vn_relcod from fsr011
                     where R1cod  = i.Pgcod
                       and R1mod  = i.Aomod 
                       and R1suc  = i.Aosuc
                       and R1mda  = i.Aomda
                       and R1pap  = i.Aopap
                       and R1cta  = i.Aocta 
                       and R1oper = i.Aooper
                       and R1sbop = i.Aosbop
                       and R1tope = i.Aotope  
                       and R011co = 'S'
                       and relcod in (33,34,35,36,37,52)
                       and rownum=1;
                     exception when no_data_found then
                       vn_relcod := 0;
                     end;
                     if ( vn_relcod in (33,34,35,36,37,52) )  then                      
                         vn_relcod :=0;
                     else
                       --dbms_output.put_line (to_char(i.Aocta));
                        begin
                               insert into jaqz287 (jaqz287USER,jaqz287MOD,jaqz287SUC,jaqz287MDA,jaqz287PAP,jaqz287CTA,jaqz287OPE,jaqz287SOPE,jaqz287TOPE,jaqz287EST,jaqz287PAIS,jaqz287TDOC,jaqz287NDOC,jaqz287cliente,
                                   jaqz287Anacre,jaqz287SIT,jaqz287fechact,JAQZ287FECD)
                               select pn_user,
                                     f.aomod,
                                     f.aosuc, 
                                     f.aomda,
                                     f.aopap,                           
                                     f.aocta,
                                     f.aooper,
                                     f.aosbop,
                                     f.aotope,
                                     f.aostat,
                                     r.pepais,
                                     r.petdoc,
                                     r.pendoc,
                                     pq_cr_cred_seguimiento.fn_nombre(pepais,petdoc,pendoc) cliente,
                                     pq_cr_cred_seguimiento.fn_analista_credito(f.aomod,f.aosuc,f.aomda,f.aopap,f.aocta,f.aooper, f.aosbop,f.aotope) analista,                          
                                     pc_Situacion,                           
                                     pd_Pgfape,
                                     f.aofval
                                from fsd010 f
                                inner join  fst111 s on s.dscod=50 and s.modulo=f.aomod
                                inner join fsr008 r on r.pgcod=f.pgcod and r.ctnro=f.aocta and r.cttfir='T'
                                where f.pgcod=i.pgcod and f.aomod=i.aomod and f.aosuc=i.aosuc and  f.aomda=i.aomda and f.aopap=i.aopap and
                                f.aocta=i.aocta and f.aooper=i.aooper and f.aosbop=i.aosbop and f.aotope=i.aotope;  
                                commit;
                        end;
                   end if;        
                end if;
       end loop;       
     end if;
     --fin de cambios kdvc 03/10/2019      
           /* insert into jaqz287 (jaqz287USER,jaqz287MOD,jaqz287SUC,jaqz287MDA,jaqz287PAP,jaqz287CTA,jaqz287OPE,jaqz287SOPE,jaqz287TOPE,jaqz287EST,jaqz287PAIS,jaqz287TDOC,jaqz287NDOC,jaqz287cliente,
                         jaqz287Anacre,jaqz287SIT,jaqz287fechact,JAQZ287FECD)
                     select pn_user,
                           f.aomod,
                           f.aosuc,
                           f.aomda,
                           f.aopap,                           
                           f.aocta,
                           f.aooper,
                           f.aosbop,
                           f.aotope,
                           f.aostat,
                           r.pepais,
                           r.petdoc,
                           r.pendoc,
                           pq_cr_cred_seguimiento.fn_nombre(pepais,petdoc,pendoc) cliente,
                           pq_cr_cred_seguimiento.fn_analista_credito(f.aomod,f.aosuc,f.aomda,f.aopap,f.aocta,f.aooper, f.aosbop,f.aotope) analista,                          
                           pc_Situacion,                           
                           pd_Pgfape,
                           f.aofval
                      from fsd010 f
                      inner join  fst111 s on s.dscod=50 and s.modulo=f.aomod
                      inner join fsr008 r on r.pgcod=f.pgcod and r.ctnro=f.aocta and r.cttfir='T'
                      where f.pgcod=pn_pgcod and f.aosuc=pn_sucursal                      
                      and f.aostat=99 and aofe99<=pd_Pgfape
--                      and ( f.scoper,f.aocta) not in (select jaqz285ope from jaqz285 where jaqz285cta=f.aocta and jaqz285ope=f.aooper and jaqz285MDA=f.aomda)                      
                      and ( f.aocta,f.aooper,f.aomda,f.aosbop) in  (select aocta,aooper,aomda,max(d.aosbop)
                                                    from fsd010 d
                                                    inner join  fst111 s on s.dscod=50 and s.modulo=d.aomod
                                                    where d.pgcod=pn_pgcod and d.aosuc=pn_sucursal
                                                    and d.aostat=99 and aofe99<=pd_Pgfape                      
                                                    and ( d.aocta,d.aooper) not in (select jaqz285cta,jaqz285ope from jaqz285 where jaqz285cta=d.aocta and jaqz285ope=d.aooper and jaqz285MDA=d.aomda)
                                                    group by d.aocta,d.aooper,aomda)
                      group by pn_user,f.aomod,f.aosuc,f.aomda,f.aopap,f.aocta,f.aooper,f.aosbop,f.aotope,f.aostat,r.pepais,r.petdoc,r.pendoc, pc_Situacion, pd_Pgfape,f.aofval
                      order by f.PGCOD, f.aoSUC; --, f.SCRUB, f.SCSDO
                 commit;*/

end sp_ExtraeListado;
Function fn_nombre(pn_Pais in number,pn_Tdoc in number,pc_Numdoc in char) return character is
lc_cliente varchar(30);
begin
   begin
              select Penom
                into lc_cliente
                from Fsd001 f
               where f.pepais = pn_Pais
                 and f.petdoc = pn_Tdoc
                 and f.pendoc = pc_Numdoc;
                 
         exception
                 when others then 
                      lc_cliente := '';
         end;

         if lc_cliente is null then
            lc_cliente := '';
         end if;
         return lc_cliente;
end fn_nombre;


Function fn_analista_credito(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number                                               
                                             ) return character is

    lc_analista fst046.ubuser%type;
    ln_instancia number(10);
    ln_lote fpp175.pp174cod%type;    
    v_analista char(10);

  begin

    --para prendario nombre del tasador   
   if (v_Scmod = 108) then 
     begin
      SELECT max(pp174cod) 
             into ln_lote
      FROM fpp175 d
      where d.PP175PGCOD = 1
       and d.pp175mod  = v_Scmod
       and d.pp175suc  = v_Scsuc
       and d.pp175mda  = v_Scmda
       and d.pp175pap  = v_Scpap
       and d.pp175cta  = v_Sccta
       and d.pp175oper = v_Scoper
       and d.pp175sbop = v_Scsbop       
       and d.pp175tope = v_Sctope;
    exception
      when no_data_found then
           ln_lote := null;       
     end;  
       
      begin
       select max(substr(pp178dtext,1,10)) 
              into lc_analista
       from fpp178 
       where 
            pp174cod = ln_lote 
        and pp177codd = 7;
      exception
        when no_data_found then
             lc_analista := null;
      end;        
   else
       If v_Scmod = 116 THEN
          Begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                  and xw2.xwfmodulo    = rel.r2mod  
                                                  and xw2.xwfsucursal  = rel.r2suc  
                                                  and xw2.xwfmoneda    = rel.r2mda  
                                                  and xw2.xwfpapel     = rel.r2pap  
                                                  and xw2.xwfcuenta    = rel.r2cta  
                                                  and xw2.xwfoperacion = rel.r2oper  
                                                  and xw2.xwfsubope    = rel.r2sbop  
                                                  and xw2.xwftipope    = rel.r2tope 
                                                  and rel.relcod       = 46     
                                                  and xw2.xwfcar3      = '1'
                 where rel.r1cod = 1
                   and rel.r1mod = v_Scmod
                   and rel.r1suc = v_Scsuc
                   and rel.r1mda = v_Scmda
                   and rel.r1pap = v_Scpap
                   and rel.r1cta = v_Sccta
                   and rel.r1oper= v_Scoper
                   and rel.r1sbop= v_Scsbop
                   and rel.r1tope= v_Sctope;
                   If nvl(ln_instancia,0) = 0 Then
                    Begin
                        select max(xw2.xwfprcins)
                          into ln_instancia
                          From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                          and xw2.xwfmodulo    = rel.r2mod  
                                                          and xw2.xwfsucursal  = rel.r2suc  
                                                          and xw2.xwfmoneda    = rel.r2mda  
                                                          and xw2.xwfpapel     = rel.r2pap  
                                                          and xw2.xwfcuenta    = rel.r2cta  
                                                          and xw2.xwfoperacion = rel.r2oper  
                                                          and xw2.xwfsubope    = rel.r2sbop  
                                                          and xw2.xwftipope    = rel.r2tope 
                                                          and rel.relcod       = 46     
                         where rel.r1cod = 1
                           and rel.r1mod = v_Scmod
                           and rel.r1suc = v_Scsuc
                           and rel.r1mda = v_Scmda
                           and rel.r1pap = v_Scpap
                           and rel.r1cta = v_Sccta
                           and rel.r1oper= v_Scoper
                           and rel.r1tope= v_Sctope;
                    End;   
                 End IF;   
          End;         
                     
       Else
           Begin
               select xw2.xwfprcins
                 into ln_instancia
                 from   xwf700 xw2
                where xw2.xwfempresa   = 1
                  and xw2.xwfsucursal  = v_Scsuc
                  and xw2.xwfmodulo    = v_Scmod
                  and xw2.xwfmoneda    = v_Scmda
                  and xw2.xwfpapel     = v_Scpap
                  and xw2.xwfcuenta    = v_Sccta
                  and xw2.xwfoperacion = v_Scoper
                  and xw2.xwfsubope    = v_Scsbop
                  and xw2.xwftipope    = v_Sctope
                  and xw2.xwfcar3      = '1';
           Exception When Others Then
                      If v_Scmod in (200,33) or  v_Sctope = 550  Then
                         Begin
                                 select max(xw2.xwfprcins)
                                   into ln_instancia
                                   from   xwf700 xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper;
                           end;
                      Else
                      
                           Begin
                                 select xw2.xwfprcins
                                   into ln_instancia
                                   from   xwf700 xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmodulo    = v_Scmod
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper
                                    and xw2.xwftipope    = v_Sctope
                                    and xw2.xwfcar3      = '1';
                           Exception When Others Then
                                  begin
                                       select max(xw2.xwfprcins)
                                         into ln_instancia
                                         from   xwf700 xw2
                                        where xw2.xwfempresa   = 1
                                          and xw2.xwfsucursal  = v_Scsuc
                                          and xw2.xwfmodulo    = v_Scmod
                                          and xw2.xwfmoneda    = v_Scmda
                                          and xw2.xwfpapel     = v_Scpap
                                          and xw2.xwfcuenta    = v_Sccta
                                          and xw2.xwfoperacion = v_Scoper
                                          and xw2.xwftipope    = v_Sctope
                                          and xw2.xwfcar3      = '1';
                                    end;
                           End;         
                           End IF;                           
           End ;
           
           --2015.11.23 cuando instancia es 0 verificar si es judicial           
           if nvl(ln_instancia,0) = 0 and v_Scmod in (200,33) then
              begin            
                    select max(xw2.xwfprcins)
                      into ln_instancia
                      From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                      and xw2.xwfmodulo    = rel.r2mod  
                                                      and xw2.xwfsucursal  = rel.r2suc  
                                                      and xw2.xwfmoneda    = rel.r2mda  
                                                      and xw2.xwfpapel     = rel.r2pap  
                                                      and xw2.xwfcuenta    = rel.r2cta  
                                                      and xw2.xwfoperacion = rel.r2oper  
                                                      and xw2.xwfsubope    = rel.r2sbop  
                                                      and xw2.xwftipope    = rel.r2tope 
                                                      and rel.relcod       = 46     
                                                      and xw2.xwfcar3      = '1'
                     where rel.r1cod = 1
                       and rel.r1mod = v_Scmod
                       and rel.r1suc = v_Scsuc
                       and rel.r1mda = v_Scmda
                       and rel.r1pap = v_Scpap
                       and rel.r1cta = v_Sccta
                       and rel.r1oper= v_Scoper
                       and rel.r1sbop= v_Scsbop
                       and rel.r1tope= v_Sctope;
            
               --2016.08.09        
                 if nvl(ln_instancia,0) = 0 then 
                     begin        
                          select max(xw2.xwfprcins)
                            into ln_instancia
                            From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                            and xw2.xwfmodulo    = rel.r2mod  
                                                            and xw2.xwfsucursal  = rel.r2suc  
                                                            and xw2.xwfmoneda    = rel.r2mda  
                                                            and xw2.xwfpapel     = rel.r2pap  
                                                            and xw2.xwfcuenta    = rel.r2cta  
                                                            and xw2.xwfoperacion = rel.r2oper  
                                                            and xw2.xwfsubope    = rel.r2sbop  
                                                            and xw2.xwftipope    = rel.r2tope 
                                                            and rel.relcod       = 46     
                           where rel.r1cod = 1
                             and rel.r1mod = v_Scmod
                             and rel.r1suc = v_Scsuc
                             and rel.r1mda = v_Scmda
                             and rel.r1pap = v_Scpap
                             and rel.r1cta = v_Sccta
                             and rel.r1oper= v_Scoper
                             and rel.r1sbop= v_Scsbop
                             and rel.r1tope= v_Sctope;
                    exception when no_Data_found then
                       ln_instancia := 0;       
                     end;        
                   end if;  
               end; 
               --2016.08.09   

           
                        
           end if;   
           --2015.11.23
           
       End IF;
       if nvl(ln_instancia,0) = 0 then 
          Begin
            select max(xw2.xwfprcins)
              into ln_instancia
              from xwf700 xw2
             where xw2.xwfempresa   = 1
               and xw2.xwfsucursal  = v_Scsuc
               and xw2.xwfmoneda    = v_Scmda
               and xw2.xwfpapel     = v_Scpap
               and xw2.xwfcuenta    = v_Sccta
               and xw2.xwfoperacion = v_Scoper;
           end;
       end if;
       
       If ln_instancia is not null then
           Begin
                 select sng001ase
                   into lc_analista
                   from sng001  --Cambiar la tabla para producción
                  where sng001inst =  ln_instancia;
           Exception when no_data_found then
                      lc_analista := null;
           end;
       End If; 
       
     end if;      

  --return lc_analista;
  v_analista := lc_analista;
  return  v_analista; 
  --end;
end fn_analista_credito;
procedure sp_cr_SegmntLinea(ln_Instancia in number,
                              P_N_CODCAl   out number,
                              P_C_DESCAL   out varchar2) is
  
    lc_Usuario       char(30);
    ln_SegLinea      number;
    ln_pae70nro      number;
    P_N_PAIS         number;
    p_n_tipdoc       number;
    p_c_numdoc       char(12);
    lc_UltSegmnLinea varchar2(30);
  
  begin
  
    begin
      select wfitemusrcod
        into lc_Usuario
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wftaskcod = 3
         and w.wfiteminit =
             (select max(r.wfiteminit)
                from wfwrkitems r
               where r.wfinsprcid = w.wfinsprcid
                 and r.wftaskcod = w.wftaskcod);
    exception
      when others then
        lc_Usuario := null;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into P_N_PAIS, p_n_tipdoc, p_c_numdoc
        from sng001 s
       where s.sng001inst = ln_Instancia
         and s.sng001emp = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select b.segcod
        into ln_SegLinea
        from sngc60 a, sngc07 b
       where a.sngc60pais = P_N_PAIS
         and a.sngc60tdoc = p_n_tipdoc
         and a.sngc60ndoc = p_c_numdoc
         and a.sngc60ocup = b.sngc07cod;
    exception
      when too_many_rows then
        begin
          select b.segcod
            into ln_SegLinea
            from sngc60 a, sngc07 b
           where a.sngc60pais = P_N_PAIS
             and a.sngc60tdoc = p_n_tipdoc
             and a.sngc60ndoc = p_c_numdoc
             and a.sngc60ocup = b.sngc07cod
             and a.sngc60corr = 
                 (select min(a.sngc60corr)
                    from sngc60 a, sngc07 b
                   where a.sngc60pais = P_N_PAIS
                     and a.sngc60tdoc = p_n_tipdoc
                     and a.sngc60ndoc = p_c_numdoc
                     and a.sngc60ocup = b.sngc07cod);
        
        end;
      when no_data_found then
        null;
    end;
  
    if p_n_tipdoc = 9 then
      ln_SegLinea := 1;
    end if;
  
    begin
    
      select max(f.pae70nro)
        into ln_pae70nro
        from fpae70 f
       where f.pae70ins = ln_Instancia
         and f.pae70usr = lc_Usuario
         and f.pae51eva = 1
         and f.pae70nro = (select max(g.pae70nro)
                             from fpae70 g
                            where g.pae70ins = f.pae70ins
                              and g.pae70usr = f.pae70usr
                              and g.pae51eva = f.pae51eva);
    exception
      when others then
        null;
    end;
  
    if ln_SegLinea = 1 then
      begin
        select trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(h.pae71val,
                                                              '[0-9]',
                                                              '')),
                                              ':',
                                              '')),
                                     '/',
                                     '')),
                            '.',
                            ''))
          into lc_UltSegmnLinea
          from fpae71 h
         where h.pae51eva = 1
           and h.pae70nro = ln_pae70nro
           and h.pae71ite = 380; --PYME
      exception
        when others then
          null;
      end;
    else
      if ln_SegLinea = 2 then
      
        begin
          select trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(h.pae71val,
                                                                '[0-9]',
                                                                '')),
                                                ':',
                                                '')),
                                       '/',
                                       '')),
                              '.',
                              ''))
            into lc_UltSegmnLinea
            from fpae71 h
           where h.pae51eva = 1
             and h.pae70nro = ln_pae70nro
             and h.pae71ite = 443; -- CONSUMO
        exception
          when others then
            null;
        end;
      
      end if;
    end if;
  
    begin
      select tp1nro1, tp1desc
        into P_N_CODCAl, P_C_DESCAL
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10823
         and Tp1corr1 = 2
         and Tp1corr2 = 7
         and tp1nro1 >= 22
         and trim(tp1desc) = TRIM(lc_UltSegmnLinea);
    exception
      when others then
        null;
    end;
  
    begin
      select c1.jaqy067ncal
        into P_C_DESCAL
        from jaqy067 c1
       where c1.jaqy067ccal = P_N_CODCAl;
    exception
      when no_data_found then
        If P_N_CODCAl = 0 then
          P_C_DESCAL := 'SIN CALIFICACION';
        Else
          P_C_DESCAL := 'NO DEFINIDA';
        End If;
    end;
  
end sp_cr_SegmntLinea;

end pq_cr_cred_seguimiento;
/

