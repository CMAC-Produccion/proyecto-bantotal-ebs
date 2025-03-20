create or replace package pq_cr_reporte_garantpol183 is

  -- Author  : ABERNEDO
  -- Created : 16/01/2014 09:50:23 a.m.
  -- Purpose :

 Procedure SP_CR_reporte_insertdata ( ln_region   in number,
                                    	lc_usuario   in char);
Procedure SP_CR_reporte_fpa70reg (lc_usuario   in char,ld_inicial in date ,ld_final in date);
Procedure SP_CR_reporte_fpa70suc (lc_usuario in char,ln_sucusal in number,ld_inicial in date ,ld_final in date);
Procedure SP_CR_reporte_fpa70zona (lc_usuario   in char,ln_zona in number,ld_inicial in date ,ld_final in date);
end pq_cr_reporte_garantpol183;
/

create or replace package body pq_cr_reporte_garantpol183 is
   -- *****************************************************************
    -- Nombre                     : sp_resultadonetolinea
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : CRISTHIAN CERPA
    -- Uso                        : EVALUA EL OTORGAMIENTO DEUN CREDITO HIPOTECARIO cAJA.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    -- Retorno                    :
    -- Fecha de Modificación      : 07/02/2020
    -- Autor de la Modificación   : jrodriguej
    -- Descripción de Modificación: Se modificó la consulta de la segunda inserción a la tabla 
    --                              JAQY748 para que los registros de la primera inserción
    --                              sean excluidos. Se modificó la consulta del cursor 
    --                              consultar_instancias para que no haya violación de PK
    --                              al registrar datos en la tabla JAQY749
    --
    -- *****************************************************************



Procedure SP_CR_reporte_insertdata ( ln_region   in number,
                                    	lc_usuario   in char) is
 cursor actulizarjaqz748 is
     select  j.jaqz748pgc,j.jaqz748mod,j.jaqz748suc,
             j.jaqz748mda,j.jaqz748pap,j.jaqz748cta,
             j.jaqz748ope,j.jaqz748sbo,j.jaqz748top,
             j.jaqz748usr
      from jaqz748 j  where j.jaqz748usr=lc_usuario and  j.jaqz748ins=9999999999;
  BEGIN 
    
    delete jaqz748 where jaqz748.jaqz748usr=lc_usuario;  
         commit;

    INSERT INTO JAQZ748 (    JAQZ748PGC,
                             JAQZ748MOD,
                             JAQZ748SUC,
                             JAQZ748MDA,
                             JAQZ748PAP,
                             JAQZ748CTA,
                             JAQZ748OPE,
                             JAQZ748SBO,
                             JAQZ748TOP,
                             JAQZ748USR,
                             JAQZ748INS
    )
  select 
        a.pgcod,
        a.aomod,
        a.aosuc,
        a.aomda,
        a.aopap,
        a.aocta,
        a.aooper,
        a.aosbop,
        a.aotope,
        lc_usuario,
        9999999999
  from 
        fsd010 a, fst811 b, fst198 d 
  where 
        a.pgcod=1 
        and a.aomod in (select c.modulo from fst111 c where c.dscod = 50 and c.modulo <>108)
        and a.aostat=0 and a.aocta <>999999999
        and a.aosuc = b.oficod
        and b.regcod < 100
        and d.tp1cod = 1
        and d.tp1cod1 = 10872
        and d.tp1corr1 = 11
        and d.tp1nro2 = b.regcod
        and d.tp1nro1 = ln_region
  GROUP BY 
        a.pgcod,
        a.aomod,
        a.aosuc,
        a.aomda,
        a.aopap,
        a.aocta,
        a.aooper,
        a.aosbop,
        a.aotope,
        lc_usuario,
        9999999999;--345106
  COMMIT;

begin
   INSERT INTO JAQZ748 (       JAQZ748PGC,
                               JAQZ748MOD,
                               JAQZ748SUC,
                               JAQZ748MDA,
                               JAQZ748PAP,
                               JAQZ748CTA,
                               JAQZ748OPE,
                               JAQZ748SBO,
                               JAQZ748TOP,
                               JAQZ748USR,
                               JAQZ748INS


      )
  select 
      b.xwfempresa,
      b.xwfmodulo,
      b.xwfsucursal,
      b.xwfmoneda,
      b.xwfpapel,
      b.xwfcuenta,
      b.xwfoperacion,
      b.xwfsubope,
      b.xwftipope,
      lc_usuario,
      B.XWFPRCINS
   from 
      wfwrkitems a,xwf700 b,fst811 c, fst198 d 
  where 
      a.wfitemstsact = 1
      AND b.xwfmodulo in (select c.modulo from fst111 c where c.dscod = 50 and c.modulo <>108)
      and a.wfinsprcid = b.xwfprcins
      and b.xwfcar3    = '1'
      and b.xwfsucursal = c.oficod
      and c.regcod < 100
      and d.tp1cod = 1
      and d.tp1cod1 = 10872
      and d.tp1corr1 = 11
      and d.tp1nro2 = c.regcod
      and d.tp1nro1 = ln_region
      and not exists (
          select 
              'x' 
          from 
              JAQZ748 f
           where
             b.xwfempresa = f.jaqz748pgc and
             b.xwfmodulo = f.jaqz748mod and
             b.xwfsucursal = f.jaqz748suc and
             b.xwfmoneda = f.jaqz748mda and
             b.xwfpapel = f.jaqz748pap and
             b.xwfcuenta = f.jaqz748cta and
             b.xwfoperacion = f.jaqz748ope and
             b.xwfsubope = f.jaqz748sbo and
             b.xwftipope = f.jaqz748top and
             f.jaqz748usr = lc_usuario
      )
GROUP BY 
      b.xwfempresa,
      b.xwfmodulo,
      b.xwfsucursal,
      b.xwfmoneda,
      b.xwfpapel,
      b.xwfcuenta,
      b.xwfoperacion,
      b.xwfsubope,
      b.xwftipope,
      lc_usuario,
      B.XWFPRCINS;--345106;--75730
  COMMIT;
 exception
                         when others then 
                          DBMS_OUTPUT.put_line ('asd');

end ;



for j in actulizarjaqz748 loop        
            update jaqz748 
            	  set jaqz748.jaqz748ins= fn_instancia_credito(  j.jaqz748mod,j.jaqz748suc,
             j.jaqz748mda,j.jaqz748pap,j.jaqz748cta,
             j.jaqz748ope,j.jaqz748sbo,j.jaqz748top )
              where jaqz748.jaqz748pgc=j.jaqz748pgc
              and jaqz748.jaqz748mod=j.jaqz748mod
              and jaqz748.jaqz748suc=j.jaqz748suc
              and jaqz748.jaqz748mda=j.jaqz748mda
              and jaqz748.jaqz748pap=j.jaqz748pap
              and jaqz748.jaqz748cta=j.jaqz748cta
              and jaqz748.jaqz748ope=j.jaqz748ope
              and jaqz748.jaqz748sbo=j.jaqz748sbo
              and jaqz748.jaqz748top=j.jaqz748top
              and jaqz748.jaqz748usr=lc_usuario;

             commit;
      end loop;
      
end SP_CR_reporte_insertdata;


Procedure SP_CR_reporte_fpa70reg (lc_usuario   in char,ld_inicial in date ,ld_final in date) is

     cursor consultar_instancias is
     select 
           t.jaqz748pgc,
           t.jaqz748mod,
           t.jaqz748suc,
           t.jaqz748mda,
           t.jaqz748pap,
           t.jaqz748cta,
           t.jaqz748ope,
           t.jaqz748sbo,
           t.jaqz748top,
           t.jaqz748usr,
           t.jaqz748ins
     from 
            (
             select  
                    row_number() over(
                    partition by
                          r.jaqz748usr,r.jaqz748ins
                    order by 
                          r.jaqz748usr,r.jaqz748ins,
                          r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,
                          r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                          r.jaqz748ope,r.jaqz748sbo,r.jaqz748top
                         ) ro,
                    r.jaqz748pgc,
                    r.jaqz748mod,
                    r.jaqz748suc,
                    r.jaqz748mda,
                    r.jaqz748pap,
                    r.jaqz748cta,
                    r.jaqz748ope,
                    r.jaqz748sbo,
                    r.jaqz748top,
                    r.jaqz748usr,
                    r.jaqz748ins
              from 
                    jaqz748 r 
              where 
                    r.jaqz748usr=lc_usuario
      ) t
      where t.ro = 1;
      
     CURSOR GARANTIAS_REALES(CN_INSTANCIA IN NUMBER) IS 
     SELECT count(*) valor FROM SNG122 WHERE SNG122.SNG122INST=CN_INSTANCIA AND 
                                SNG122.sng122tope in (select fst098.tpnro from fst098 
                                                           where fst098.pgcod=1 
                                                           and fst098.tpcod=7715 
                                                           and fst098.tpcorr>100 
                                                           and fst098.tpcorr<199)
                                                            and ROWNUM =1;                              
                                   
    ln_eva2 NUMBER(10);
    ln_eva3 NUMBER(10);  
    ln_eva2tim TIMESTAMP;
    ln_eva3tim TIMESTAMP;
    lc_flg3 char(1);
    lc_flg2 char(1); 
     ln_agencia number(3);
    lc_analista char(10);
    ln_zona number(3);      
  BEGIN 
    

      delete from jaqz749 where jaqz749.jaqz749usr=lc_usuario;    
      commit;
 -- execute immediate ('truncate table JAQZ749');
     for r in consultar_instancias loop
         FOR  s in GARANTIAS_REALES(r.jaqz748ins) loop
           
             if s.valor<>0 then
                 begin 
                       select max(a.pae70nro),max(a.Pae70time) into ln_eva2,ln_eva2tim from fpae70 a where a.pae70pro = 1 and a.pae70ins =r.jaqz748ins and a.pae51eva=2 and a.pae70time>ld_inicial and a.pae70time<ld_final;
                         exception
                              when no_data_found then
                                   ln_eva2:=0;
                    end;
                    begin 
                       select max(a.pae70nro),max(a.Pae70time) into ln_eva3,ln_eva3tim from fpae70 a where a.pae70pro = 1 and a.pae70ins =r.jaqz748ins and a.pae51eva=3 and a.pae70time>ld_inicial and a.pae70time<ld_final;
                         exception
                              when no_data_found then
                                   ln_eva3:=0;
                    end;
                    

                   BEGIN
                      select 'S'
                        into lc_flg2
                        from fpae73 a  
                       where a.pae51eva = 2
                         and a.pae70nro = ln_eva2
                         and a.pae73pol = 183;
                       exception
                              when no_data_found then
                                   lc_flg2:='N';           
                   END;
                  BEGIN    
                    select 'S'
                      into lc_flg3
                      from fpae73 a  
                     where a.pae51eva = 3
                       and a.pae70nro = ln_eva3
                       and a.pae73pol = 183;  
                       exception
                              when no_data_found then
                                   lc_flg3:='N';               
                  END;
                   
                          if lc_flg3='S' AND lc_flg2='S' then
                    begin
                       select sng001.sng001ase,sng001.sng001age into lc_analista,ln_agencia  from sng001 where sng001.sng001inst=r.jaqz748ins;
                        exception
                              when no_data_found then
                                   lc_analista:='N'; 
                                   ln_agencia:=0;  
                    end;
                     begin 
                                 
                      select fst811.regcod into ln_zona from fst811 where fst811.oficod=ln_agencia and Rownum=1;
                       exception
                              when no_data_found then
                       ln_zona:=0; 
                      end;   
                      
                           insert into jaqz749 (
                              jaqz749pgc ,jaqz749mod ,jaqz749suc ,jaqz749mda ,jaqz749pap ,jaqz749cta ,jaqz749ope ,
                              jaqz749sbo ,jaqz749top ,jaqz749ins ,jaqz749usr ,jaqz749est ,jaqz749eva2,jaqz749eva3,JAQZ749AGE,
                                JAQZ749ANA,JAQZ749ZON
                              ) values (r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                         r.jaqz748ope,r.jaqz748sbo,r.jaqz748top,r.jaqz748ins,r.jaqz748usr,'3',ln_eva2tim,ln_eva3tim,ln_agencia,lc_analista,ln_zona);
                              commit;
                       else
                         if lc_flg3='S' AND lc_flg2='N' then
                              begin
                                   select sng001.sng001ase,sng001.sng001age into lc_analista,ln_agencia  from sng001 where sng001.sng001inst=r.jaqz748ins;
                                    exception
                                          when no_data_found then
                                               lc_analista:='N'; 
                                               ln_agencia:=0;  
                                end; 
                                begin 
                                 
                                  select fst811.regcod into ln_zona from fst811 where fst811.oficod=ln_agencia and Rownum=1;
                                   exception
                                          when no_data_found then
                                               ln_zona:=0; 
                                end;  
                                
                                insert into jaqz749 (
                                jaqz749pgc ,jaqz749mod ,jaqz749suc ,jaqz749mda ,jaqz749pap ,jaqz749cta ,jaqz749ope ,
                                jaqz749sbo ,jaqz749top ,jaqz749ins ,jaqz749usr ,jaqz749est ,jaqz749eva2,jaqz749eva3,JAQZ749AGE,
                                  JAQZ749ANA,JAQZ749ZON
                                ) values (r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                           r.jaqz748ope,r.jaqz748sbo,r.jaqz748top,r.jaqz748ins,r.jaqz748usr,'3',null,ln_eva3tim,ln_agencia,lc_analista,ln_zona);
                                 commit;
                               
                          ELSE
                            if lc_flg3='N' AND lc_flg2='S' then 
                                 begin
                                     select sng001.sng001ase,sng001.sng001age into lc_analista,ln_agencia  from sng001 where sng001.sng001inst=r.jaqz748ins;
                                      exception
                                            when no_data_found then
                                                 lc_analista:='N'; 
                                                 ln_agencia:=0;  
                                  end;
                                begin 
                                 
                                  select fst811.regcod into ln_zona from fst811 where fst811.oficod=ln_agencia and Rownum=1;
                                   exception
                                          when no_data_found then
                                               ln_zona:=0; 
                                end;   
                               insert into jaqz749 (
                                jaqz749pgc ,jaqz749mod ,jaqz749suc ,jaqz749mda ,jaqz749pap ,jaqz749cta ,jaqz749ope ,
                                jaqz749sbo ,jaqz749top ,jaqz749ins ,jaqz749usr ,jaqz749est ,jaqz749eva2,jaqz749eva3,JAQZ749AGE,
                                JAQZ749ANA,JAQZ749ZON
                                ) values (r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                           r.jaqz748ope,r.jaqz748sbo,r.jaqz748top,r.jaqz748ins,r.jaqz748usr,'2',ln_eva2tim,NULL,ln_agencia,lc_analista,ln_zona);
                                 commit;
                            END IF ;
                                       
                           END IF;
                    end if;
             end if;
         end loop;
     
    end loop;



    
end SP_CR_reporte_fpa70reg;
----------------------------------------------------------------

Procedure SP_CR_reporte_fpa70suc (lc_usuario in char,ln_sucusal in number,ld_inicial in date ,ld_final in date ) is
 
     cursor consultar_instancias is
     select 
           t.jaqz748pgc,
           t.jaqz748mod,
           t.jaqz748suc,
           t.jaqz748mda,
           t.jaqz748pap,
           t.jaqz748cta,
           t.jaqz748ope,
           t.jaqz748sbo,
           t.jaqz748top,
           t.jaqz748usr,
           t.jaqz748ins
     from 
           (
           select  
                  row_number() over(
                          partition by
                                r.jaqz748usr,r.jaqz748ins
                          order by 
                                r.jaqz748usr,r.jaqz748ins,
                                r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,
                                r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                r.jaqz748ope,r.jaqz748sbo,r.jaqz748top
                               ) ro,
                  r.jaqz748pgc,
                  r.jaqz748mod,
                  r.jaqz748suc,
                  r.jaqz748mda,
                  r.jaqz748pap,
                  r.jaqz748cta,
                  r.jaqz748ope,
                  r.jaqz748sbo,
                  r.jaqz748top,
                  r.jaqz748usr,
                  r.jaqz748ins
            from 
                  jaqz748 r /*,sng122 s*/  
            where 
                  r.jaqz748usr=lc_usuario 
                  and r.jaqz748suc=ln_sucusal
       ) t
      where t.ro = 1;
          
      /* and s.sng122inst=r.jaqz748ins 
       and s.sng122tope in (select fst098.tpnro from fst098 
                                   where fst098.pgcod=1 
                                   and fst098.tpcod=7715 
                                   and fst098.tpcorr>100 
                                   and fst098.tpcorr<199);*/
     CURSOR GARANTIAS_REALES(CN_INSTANCIA IN NUMBER) IS 
     SELECT count(*) valor FROM SNG122 WHERE SNG122.SNG122INST=CN_INSTANCIA AND 
                                SNG122.sng122tope in (select fst098.tpnro from fst098 
                                                           where fst098.pgcod=1 
                                                           and fst098.tpcod=7715 
                                                           and fst098.tpcorr>100 
                                                           and fst098.tpcorr<199)
                                                            and ROWNUM =1;                              
    ln_eva2 NUMBER(10);
    ln_eva3 NUMBER(10);  
    ln_eva2tim TIMESTAMP;
    ln_eva3tim TIMESTAMP;
    lc_flg3 char(1);
    lc_flg2 char(1); 
    ln_agencia number(3);
    lc_analista char(10);
    ln_zona number(3);   
  BEGIN 
    
    
   delete jaqz749 where jaqz749.jaqz749usr=lc_usuario;  
         commit;
--  execute immediate ('truncate table JAQZ749');
     for r in consultar_instancias loop
         FOR  s in GARANTIAS_REALES(r.jaqz748ins) loop
           
             if s.valor<>0 then
                 begin 
                       select max(a.pae70nro),max(a.Pae70time) into ln_eva2,ln_eva2tim from fpae70 a where a.pae70pro = 1 and a.pae70ins =r.jaqz748ins and a.pae51eva=2 and a.pae70time>ld_inicial and a.pae70time<ld_final;
                         exception
                              when no_data_found then
                                   ln_eva2:=0;
                    end;
                    begin 
                       select max(a.pae70nro),max(a.Pae70time) into ln_eva3,ln_eva3tim from fpae70 a where a.pae70pro = 1 and a.pae70ins =r.jaqz748ins and a.pae51eva=3 and a.pae70time>ld_inicial and a.pae70time<ld_final;
                         exception
                              when no_data_found then
                                   ln_eva3:=0;
                    end;
                    

                   BEGIN
                      select 'S'
                        into lc_flg2
                        from fpae73 a  
                       where a.pae51eva = 2
                         and a.pae70nro = ln_eva2
                         and a.pae73pol = 183;
                       exception
                              when no_data_found then
                                   lc_flg2:='N';           
                   END;
                  BEGIN    
                    select 'S'
                      into lc_flg3
                      from fpae73 a  
                     where a.pae51eva = 3
                       and a.pae70nro = ln_eva3
                       and a.pae73pol = 183;  
                       exception
                              when no_data_found then
                                   lc_flg3:='N';               
                  END;
                   
                    if lc_flg3='S' AND lc_flg2='S' then
                    begin
                       select sng001.sng001ase,sng001.sng001age into lc_analista,ln_agencia  from sng001 where sng001.sng001inst=r.jaqz748ins;
                        exception
                              when no_data_found then
                                   lc_analista:='N'; 
                                   ln_agencia:=0;  
                    end;
                     begin 
                                 
                      select fst811.regcod into ln_zona from fst811 where fst811.oficod=ln_agencia and Rownum=1;
                       exception
                              when no_data_found then
                       ln_zona:=0; 
                      end;   
                           insert into jaqz749 (
                              jaqz749pgc ,jaqz749mod ,jaqz749suc ,jaqz749mda ,jaqz749pap ,jaqz749cta ,jaqz749ope ,
                              jaqz749sbo ,jaqz749top ,jaqz749ins ,jaqz749usr ,jaqz749est ,jaqz749eva2,jaqz749eva3,JAQZ749AGE,
                                JAQZ749ANA,JAQZ749ZON
                              ) values (r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                         r.jaqz748ope,r.jaqz748sbo,r.jaqz748top,r.jaqz748ins,r.jaqz748usr,'3',ln_eva2tim,ln_eva3tim,ln_agencia,lc_analista,ln_zona);
                              commit;
                       else
                         if lc_flg3='S' AND lc_flg2='N' then
                              begin
                                   select sng001.sng001ase,sng001.sng001age into lc_analista,ln_agencia  from sng001 where sng001.sng001inst=r.jaqz748ins;
                                    exception
                                          when no_data_found then
                                               lc_analista:='N'; 
                                               ln_agencia:=0;  
                                end; 
                                begin 
                                 
                                  select fst811.regcod into ln_zona from fst811 where fst811.oficod=ln_agencia and Rownum=1;
                                   exception
                                          when no_data_found then
                                               ln_zona:=0; 
                                end;      
                            insert into jaqz749 (
                              jaqz749pgc ,jaqz749mod ,jaqz749suc ,jaqz749mda ,jaqz749pap ,jaqz749cta ,jaqz749ope ,
                              jaqz749sbo ,jaqz749top ,jaqz749ins ,jaqz749usr ,jaqz749est ,jaqz749eva2,jaqz749eva3,JAQZ749AGE,
                                JAQZ749ANA,JAQZ749ZON
                              ) values (r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                         r.jaqz748ope,r.jaqz748sbo,r.jaqz748top,r.jaqz748ins,r.jaqz748usr,'3',null,ln_eva3tim,ln_agencia,lc_analista,ln_zona);
                               commit;
                          ELSE
                            if lc_flg3='N' AND lc_flg2='S' then 
                                 begin
                                     select sng001.sng001ase,sng001.sng001age into lc_analista,ln_agencia  from sng001 where sng001.sng001inst=r.jaqz748ins;
                                      exception
                                            when no_data_found then
                                                 lc_analista:='N'; 
                                                 ln_agencia:=0;  
                                  end;
                                begin 
                                 
                                  select fst811.regcod into ln_zona from fst811 where fst811.oficod=ln_agencia and Rownum=1;
                                   exception
                                          when no_data_found then
                                               ln_zona:=0; 
                                end;   
                               insert into jaqz749 (
                                jaqz749pgc ,jaqz749mod ,jaqz749suc ,jaqz749mda ,jaqz749pap ,jaqz749cta ,jaqz749ope ,
                                jaqz749sbo ,jaqz749top ,jaqz749ins ,jaqz749usr ,jaqz749est ,jaqz749eva2,jaqz749eva3,JAQZ749AGE,
                                JAQZ749ANA,JAQZ749ZON
                                ) values (r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                           r.jaqz748ope,r.jaqz748sbo,r.jaqz748top,r.jaqz748ins,r.jaqz748usr,'2',ln_eva2tim,NULL,ln_agencia,lc_analista,ln_zona);
                                 commit;
                            END IF ;
                                       
                           END IF;
                    end if;
             end if;
         end loop;
     
    end loop;

end SP_CR_reporte_fpa70suc;


---------------------------------------------------------------------------------------
----------------------------------------------------------------

Procedure SP_CR_reporte_fpa70zona (lc_usuario   in char,ln_zona in number,ld_inicial in date ,ld_final in date) is
 
       
     cursor consultar_instancias is
     select 
           t.jaqz748pgc,
           t.jaqz748mod,
           t.jaqz748suc,
           t.jaqz748mda,
           t.jaqz748pap,
           t.jaqz748cta,
           t.jaqz748ope,
           t.jaqz748sbo,
           t.jaqz748top,
           t.jaqz748usr,
           t.jaqz748ins
     from 
            (
           select  
                  row_number() over(
                          partition by
                                r.jaqz748usr,r.jaqz748ins
                          order by 
                                r.jaqz748usr,r.jaqz748ins,
                                r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,
                                r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                r.jaqz748ope,r.jaqz748sbo,r.jaqz748top
                               ) ro,
                  r.jaqz748pgc,
                  r.jaqz748mod,
                  r.jaqz748suc,
                  r.jaqz748mda,
                  r.jaqz748pap,
                  r.jaqz748cta,
                  r.jaqz748ope,
                  r.jaqz748sbo,
                  r.jaqz748top,
                  r.jaqz748usr,
                  r.jaqz748ins
            from 
                  jaqz748 r /*,SNG122 s */ 
            where 
                  r.jaqz748usr=lc_usuario 
                  and r.jaqz748suc in (select oficod from fst811 
                                          where regcod<100 and regcod=ln_zona)
      ) t
      where t.ro = 1;
       /*and s.sng122inst=r.jaqz748ins 
       and s.sng122tope in (select fst098.tpnro from fst098 
                                   where fst098.pgcod=1 
                                   and fst098.tpcod=7715 
                                   and fst098.tpcorr>100 
                                   and fst098.tpcorr<199);*/
     CURSOR GARANTIAS_REALES(CN_INSTANCIA IN NUMBER) IS 
     SELECT count(*) valor FROM SNG122 WHERE SNG122.SNG122INST=CN_INSTANCIA AND 
                                SNG122.sng122tope in (select fst098.tpnro from fst098 
                                                           where fst098.pgcod=1 
                                                           and fst098.tpcod=7715 
                                                           and fst098.tpcorr>100 
                                                           and fst098.tpcorr<199)
                                                            and ROWNUM =1;
                             
     
    ln_eva2 NUMBER(10);
    ln_eva3 NUMBER(10);  
    ln_eva2tim TIMESTAMP;
    ln_eva3tim TIMESTAMP;
    lc_flg3 char(1);
    lc_flg2 char(1);
    ln_agencia number(3);
    lc_analista char(10);
        
  BEGIN 
    
          
   
      delete jaqz749 where jaqz749.jaqz749usr=lc_usuario;   
            commit; 
 -- execute immediate ('truncate table JAQZ749');
     for r in consultar_instancias loop
         FOR  s in GARANTIAS_REALES(r.jaqz748ins) loop
           
             if s.valor<>0 then
                 begin 
                       select max(a.pae70nro),max(a.Pae70time) into ln_eva2,ln_eva2tim from fpae70 a where a.pae70pro = 1 and a.pae70ins =r.jaqz748ins and a.pae51eva=2 and a.pae70time>ld_inicial and a.pae70time<ld_final;
                         exception
                              when no_data_found then
                                   ln_eva2:=0;
                    end;
                    begin 
                       select max(a.pae70nro),max(a.Pae70time) into ln_eva3,ln_eva3tim from fpae70 a where a.pae70pro = 1 and a.pae70ins =r.jaqz748ins and a.pae51eva=3 and a.pae70time>ld_inicial and a.pae70time<ld_final;
                         exception
                              when no_data_found then
                                   ln_eva3:=0;
                    end;
                    

                   BEGIN
                      select 'S'
                        into lc_flg2
                        from fpae73 a  
                       where a.pae51eva = 2
                         and a.pae70nro = ln_eva2
                         and a.pae73pol = 183;
                       exception
                              when no_data_found then
                                   lc_flg2:='N';           
                   END;
                  BEGIN    
                    select 'S'
                      into lc_flg3
                      from fpae73 a  
                     where a.pae51eva = 3
                       and a.pae70nro = ln_eva3
                       and a.pae73pol = 183;  
                       exception
                              when no_data_found then
                                   lc_flg3:='N';               
                  END;
                   
                     if lc_flg3='S' AND lc_flg2='S' then
                    begin
                       select sng001.sng001ase,sng001.sng001age into lc_analista,ln_agencia  from sng001 where sng001.sng001inst=r.jaqz748ins;
                        exception
                              when no_data_found then
                                   lc_analista:='N'; 
                                   ln_agencia:=0;  
                    end;
                      
                           insert into jaqz749 (
                              jaqz749pgc ,jaqz749mod ,jaqz749suc ,jaqz749mda ,jaqz749pap ,jaqz749cta ,jaqz749ope ,
                              jaqz749sbo ,jaqz749top ,jaqz749ins ,jaqz749usr ,jaqz749est ,jaqz749eva2,jaqz749eva3,JAQZ749AGE,
                                JAQZ749ANA,JAQZ749ZON
                              ) values (r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                         r.jaqz748ope,r.jaqz748sbo,r.jaqz748top,r.jaqz748ins,r.jaqz748usr,'3',ln_eva2tim,ln_eva3tim,ln_agencia,lc_analista,ln_zona);
                              commit;
                       else
                         if lc_flg3='S' AND lc_flg2='N' then
                              begin
                                   select sng001.sng001ase,sng001.sng001age into lc_analista,ln_agencia  from sng001 where sng001.sng001inst=r.jaqz748ins;
                                    exception
                                          when no_data_found then
                                               lc_analista:='N'; 
                                               ln_agencia:=0;  
                                end; 
                                
                            insert into jaqz749 (
                              jaqz749pgc ,jaqz749mod ,jaqz749suc ,jaqz749mda ,jaqz749pap ,jaqz749cta ,jaqz749ope ,
                              jaqz749sbo ,jaqz749top ,jaqz749ins ,jaqz749usr ,jaqz749est ,jaqz749eva2,jaqz749eva3,JAQZ749AGE,
                                JAQZ749ANA,JAQZ749ZON
                              ) values (r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                         r.jaqz748ope,r.jaqz748sbo,r.jaqz748top,r.jaqz748ins,r.jaqz748usr,'3',null,ln_eva3tim,ln_agencia,lc_analista,ln_zona);
                               commit;
                          ELSE
                            if lc_flg3='N' AND lc_flg2='S' then 
                                 begin
                                     select sng001.sng001ase,sng001.sng001age into lc_analista,ln_agencia  from sng001 where sng001.sng001inst=r.jaqz748ins;
                                      exception
                                            when no_data_found then
                                                 lc_analista:='N'; 
                                                 ln_agencia:=0;  
                                  end;
                                 
                               insert into jaqz749 (
                                jaqz749pgc ,jaqz749mod ,jaqz749suc ,jaqz749mda ,jaqz749pap ,jaqz749cta ,jaqz749ope ,
                                jaqz749sbo ,jaqz749top ,jaqz749ins ,jaqz749usr ,jaqz749est ,jaqz749eva2,jaqz749eva3,JAQZ749AGE,
                                JAQZ749ANA,JAQZ749ZON
                                ) values (r.jaqz748pgc,r.jaqz748mod,r.jaqz748suc,r.jaqz748mda,r.jaqz748pap,r.jaqz748cta,
                                           r.jaqz748ope,r.jaqz748sbo,r.jaqz748top,r.jaqz748ins,r.jaqz748usr,'2',ln_eva2tim,NULL,ln_agencia,lc_analista,ln_zona);
                                 commit;
                            END IF ;
                                       
                           END IF;
                    end if;
             end if;
         end loop;
     
    end loop;


    
end SP_CR_reporte_fpa70zona;


---------------------------------------------------------------------------------------
end pq_cr_reporte_garantpol183;
/

