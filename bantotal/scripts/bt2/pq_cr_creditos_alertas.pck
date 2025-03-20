create or replace package PQ_CR_CREDITOS_ALERTAS is

    -- *********************************************************************************
    -- Nombre                     : FUNCIONES PARA ALERTAS DE CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.02.13
    -- Autor de Creación          : DCASTRO
    -- Uso                        : SE APLICARA LOS ALERTAS EN LA CANCELACION DE CUENTAS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 21/02/2014
    -- Autor de la Modificación   : SMARQUEZ
    -- Descripción de Modificación: SE HARAN LAS VERIFICACIONES PARA
    --                              2014.05.14 APACHECO -> Creacion de sp_cr_control_vc
    -- ********************************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_ah_AlertCancelCuenta(ln_cuenta in number,
                                    lc_cuenta in varchar2,
                                    ln_tipope in number,
                                    ln_modulo in number,
                                    lc_mensaje out VARCHAR2,
                                    lc_msg1 out varchar2,
                                    lc_msg2 out varchar2,
                                    ln_num out number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_ah_verificacion (ln_cuenta in number,
                                lc_cuenta in varchar2,
                                ln_tipope in number,
                                ln_modulo in number,
                                lc_mensaje out varchar2,
                                lc_msg1 out varchar2,
                                lc_msg2 out varchar2,
                                ln_num out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_credito_mora( ln_pepais in number,
                                ln_petdoc in number,
                                lc_pendoc in char,
                                lc_ind out char,
                                lc_msg out char) ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_credito_seguro( ln_pepais in number,
                                  ln_petdoc in number,
                                  lc_pendoc in char,
                                  lc_ind out char,
                                  lc_msg out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_ah_control(ln_pais in number,
                          ln_tdoc in number,
                          lc_ndoc in char,
                          lc_men out char);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_TIENE_SEGURO(P_N_PAIS IN NUMBER,
                               P_N_TDOC IN NUMBER,
                               P_C_NDOC IN VARCHAR2,
                               P_C_PROD IN VARCHAR2, 
                               p_c_rpta out varchar2 );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_Alerta_prendario(ln_cuenta in number,
                                ln_sucur  in number,
                                lc_mensaje out varchar2);
                                
end PQ_CR_CREDITOS_ALERTAS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CREDITOS_ALERTAS IS
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- *****************************************************************
    -- Nombre                     : sp_ah_AlertCancelCuenta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/02/2014
    -- Autor de Creación          : SMARQUEZ
    -- Uso                        : Determina si cliente tiene creditos en mora.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- *****************************************************************
  procedure sp_ah_AlertCancelCuenta(ln_cuenta in number,
                                    lc_cuenta in varchar2,
                                    ln_tipope in number,
                                    ln_modulo in number,
                                    lc_mensaje out VARCHAR2,
                                    lc_msg1 out varchar2,
                                    lc_msg2 out varchar2,
                                    ln_num out number) is

  Begin

       sp_ah_verificacion (ln_cuenta,lc_cuenta,ln_tipope,ln_modulo,lc_mensaje,lc_msg1,lc_msg2,ln_num);

  end;
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   -- ***************************************************************************
    -- Nombre                     : sp_ah_verificacion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/02/2014
    -- Autor de Creación          : SMARQUEZ
    -- Uso                        : Determina si cliente tiene seguros asociados
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- **************************************************************************
  procedure sp_ah_verificacion (ln_cuenta in number,
                                lc_cuenta in varchar2,
                                ln_tipope in number,
                                ln_modulo in number,
                                lc_mensaje out varchar2,
                                lc_msg1 out varchar2,
                                lc_msg2 out varchar2,
                                ln_num out number) is


  Cursor seguro (v_cuenta in varchar2) is
    SELECT RTRIM(producto,'MANUAL')AS PRO
      FROM v_certseguros
     where cuenta is not null
       AND CUENTA = v_cuenta;

-------       and LTRIM(SUBSTR(CUENTA,1,9),'0')= v_cuenta;

  Cursor datos(numcta in number)  is
    select pepais,
           petdoc,
           pendoc
      from fsr008
     where ctnro = numcta;
     
  Cursor datos1 (ctanro in number) is
      select pfpai2,
             pftdo2,
             pfndo2                
       from  FSR130
       where ctnro = ctanro;

  msg varchar2(600);
  msg1 char(300);
  msg2 char(300);
  estado char(1);
  estado1 char(1);
 -- nombre char(30);
/* cuenta1 varchar2(10);
  mensaje1 char(500);
  mensaje2 char(500);*/
  PRO CHAR(50);

  Begin
   --  cuenta1 := trim(to_char(ln_cuenta,'999999999'));
     msg := null;
     msg1 := null;
     msg2 := null;
     ln_num := 0;
     For k in seguro(lc_cuenta) loop
         msg := msg ||' '||'Tiene seguro'||' '|| k.pro;
     End loop;
     if ln_modulo = 21 then        
       If ln_tipope not in (2,6,8,5)  Then
           For i in datos(ln_cuenta) loop
              If i.petdoc  not in (30,99,27,9,15) Then
                sp_cr_credito_mora( i.pepais,i.petdoc,i.pendoc,estado1,msg1);      
                   if msg1 is not null then
                      lc_mensaje := lc_mensaje||' '|| trim(msg1);
                      ln_num := 1;
                   end if;
                sp_cr_credito_seguro(i.pepais,i.petdoc,i.pendoc,estado,msg2);
                  if msg2 is not null then
                     lc_msg1 := lc_mensaje||' '||trim(msg2);
                     ln_num := 1;
                  end if;
              Else
                For j in datos1(ln_cuenta) loop
                   sp_cr_credito_mora( j.pfpai2,j.pftdo2,j.pfndo2,estado1,msg1);      
                   if msg1 is not null then
                      lc_mensaje :=lc_mensaje||' '|| trim(msg1);
                      ln_num := 1;
                   end if;
                End loop;  
              End If;
           end loop;

           if msg is not null then
             lc_msg2 := msg;
             ln_num := 1;
           end if;
       End If;
    Else
      For i in datos(ln_cuenta) loop
        If i.petdoc  not in (30,99,27,9,15) Then
          sp_cr_credito_mora( i.pepais,i.petdoc,i.pendoc,estado1,msg1);      
             if msg1 is not null then
                lc_mensaje := lc_mensaje||' '|| trim(msg1);
                ln_num := 1;
             end if;
          sp_cr_credito_seguro(i.pepais,i.petdoc,i.pendoc,estado,msg2);
            if msg2 is not null then
               lc_msg1 := lc_mensaje||' '||trim(msg2);
               ln_num := 1;
            end if;
        Else
          For j in datos1(ln_cuenta) loop
             sp_cr_credito_mora( j.pfpai2,j.pftdo2,j.pfndo2,estado1,msg1);      
             if msg1 is not null then
                lc_mensaje := lc_mensaje||' '||trim(msg1);
                ln_num := 1;
             end if;
          End loop;  
        End If;
     end loop;

     if msg is not null then
       lc_msg2 := msg;
       ln_num := 1;
     end if; 
    
    End If;   

  End;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_credito_mora( ln_pepais in number,
                                ln_petdoc in number,
                                lc_pendoc in char,
                                lc_ind out char,
                                lc_msg out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_credito_mora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          :
    -- Uso                        : Determina si cliente tiene creditos en mora.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- *****************************************************************

cursor cuentas is
select s.sng003pgc, s.sng003cta, s.sng001inst, fs.penom
          from fsr008 f8, sng003 s, fsd001 fs
         where f8.pepais = ln_pepais
           and f8.petdoc = ln_petdoc
           and f8.pendoc = lc_pendoc
           and s.sng003pgc = 1
           and s.sng003cta = f8.ctnro
           and fs.pepais = f8.pepais
           and fs.petdoc = f8.petdoc
           and fs.pendoc = f8.pendoc;


cursor garantia(lc_cuenta in number) is
select r1cod, r1mod, r1suc, r1mda, r1pap, r1cta, r1oper, r1sbop, r1tope
  from fsr011 f
 where f.r1cod = 1
   and f.r2cta = lc_cuenta   
   and relcod = 50
   and not exists (select 1--a
                    from fsr011 fs
                    where fs.r2cta = f.r2cta 
                      and fs.r1mod = 21
                      and fs.r1tope in (8,6,2,5));


ld_fecpro date;
ln_numero number := 0;
lc_nombre char(30);
lc_nomaval char(300):= '';
lc_penom char(30);
cuenta number(10) := 0;

begin

   lc_ind := 'N';

   begin --fecha inicio sistema
     select pgfape
       into ld_fecpro
       from fst017 where pgcod = 1;
   end;

    begin
      select count(*)
        into ln_numero
        from fsd011 f, fsr008 f8
       where f.pgcod = f8.pgcod
         and f.sccta = f8.ctnro
         and f8.pepais = ln_pepais
         and f8.petdoc = ln_petdoc
         and f8.pendoc = lc_pendoc
         and f8.ttcod = '1'
         and f8.cttfir = 'T'         
         and f.scmod in (select modulo from fst111 where dscod = 50)
         and fn_dias_atraso(ld_fecpro,f.pgcod,f.scmod,f.scsuc,f.scmda,f.scpap,f.sccta,f.scoper,
                            f.scsbop,f.sctope,0,f.scfvto) > 0
         and (f.scmod <> 21 and f.sctope not in (8,6,2,5));   
        if ln_numero = 0 then
          select count(*)
            into ln_numero
            from fsd011 f, fsr008 f8
           where f.pgcod = f8.pgcod
             and f.sccta = f8.ctnro
             and f8.pepais = ln_pepais
             and f8.petdoc = ln_petdoc
             and f8.pendoc = lc_pendoc
             and f8.ttcod = '1'                
             and f.scmod in (select modulo from fst111 where dscod = 50)
             and fn_dias_atraso(ld_fecpro,f.pgcod,f.scmod,f.scsuc,f.scmda,f.scpap,f.sccta,f.scoper,
                                f.scsbop,f.sctope,0,f.scfvto) > 0
             and (f.scmod <> 21 and f.sctope not in (8,6,2,5));    
        end if;                 
        Begin        
           select f01.penom
             into lc_nombre
             from fsd001 f01,
                  fsr008 f08
            where f01.pepais = ln_pepais
              and f01.petdoc = ln_petdoc
              and f01.pendoc = lc_pendoc
              and f08.pepais = f01.pepais
              and f08.petdoc = f01.petdoc
              and f08.pendoc = f01.pendoc
           --   and f08.cttfir = 'T'
              and rownum = 1;
        exception
        When no_Data_found then
           lc_nombre := null;
        end;                        

        if ln_numero >0 then
          lc_msg := lc_msg||' '||'Cliente'||' '||trim(lc_nombre)||' '||' tiene Credito(s) en Mora.';
          lc_ind := 'S';
        end if;
    end;

     --buscar si es aval de algun credito en mora
   begin
      for i in cuentas loop

           for y in garantia(i.sng003cta) loop

              select count(*)
               into ln_numero
              from fsd010 f
              where f.pgcod = y.r1cod
                and f.aomod = y.r1mod
                and f.aosuc = y.r1suc
                and f.aomda = y.r1mda
                and f.aopap = y.r1pap
                and f.aocta = y.r1cta
                and f.aooper = y.r1oper
                and f.aosbop = y.r1sbop
                and f.aotope = y.r1tope
                and f.aostat <> 99
                and fn_dias_atraso(ld_fecpro, f.pgcod, f.aomod, f.aosuc, f.aomda, f.aopap, f.aocta, f.aooper, f.aosbop, f.aotope, 0,
                  f.aofvto )>0;
                cuenta :=  y.r1cta;                 
           end loop;
           select f01.penom
                  into lc_penom 
                  from fsd001 f01,
                       fsr008 f08
                 where f08.ctnro = cuenta
                   and f08.pepais = f01.pepais
                   and f08.petdoc = f01.petdoc
                   and f08.pendoc = f01.pendoc                
                   and rownum= 1;
                 lc_nomaval := trim(lc_nomaval)||' '||trim(lc_penom);  
           if ln_numero >0 then
              lc_msg := trim(lc_msg)||' '||'Cliente es aval de'||' '||trim(lc_nomaval)||' '||'que tiene Credito(s) en Mora. ';
              lc_ind := 'S';
              exit;
           else
               lc_msg := null;
               lc_ind := 'N';
          end if;
      end loop;
    end;

 end sp_cr_credito_mora;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_credito_seguro( ln_pepais in number,
                                  ln_petdoc in number,
                                  lc_pendoc in char,
                                  lc_ind out char,
                                  lc_msg out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_credito_seguro
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          :
    -- Uso                        : Determina si cliente tiene seguros en creditos.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- *****************************************************************
cursor creditos is
 select distinct p.pgcod, p.aomod, p.aosuc, p.aomda, p.aopap,
        p.aocta, p.aooper, p.aosbop, p.aotope, p.sgcod
    from fsd011 f, fsr008 f8, fpp001 p, fsd611 d
    where f.pgcod = f8.pgcod
      and f.sccta = f8.ctnro
      and f8.pepais = ln_pepais
      and f8.petdoc = ln_petdoc
      and f8.pendoc = lc_pendoc
      and f8.ttcod = '1'
   --   and f8.cttfir = 'T'
      and (f.scmod <> 21 and f.sctope not in (2,5,6,8))
      and p.pgcod = f.pgcod
      and p.aomod = f.scmod
      and p.aosuc = f.scsuc
      and p.aomda = f.scmda
      and p.aopap = f.scpap
      and p.aocta = f.sccta
      and p.aooper = f.scoper
      and p.aosbop = f.scsbop
      and p.aotope = f.sctope
      and d.pgcod =  p.pgcod
      and d.ppmod =  p.aomod
      and d.ppsuc =  p.aosuc
      and d.ppmda =  p.aomda
      and d.pppap =  p.aopap
      and d.ppcta =  p.aocta
      and d.ppoper = p.aooper
      and d.ppsbop = p.aosbop
      and d.pptope = p.aotope
      order by p.sgcod;

/*ld_fecpro date := trunc(sysdate);
ln_numero number := 0;*/
lc_texto varchar2(20);

begin

   lc_ind := 'N';
   lc_msg := null;

   for i in creditos loop
       lc_ind := 'S';

       if i.aomod = 112 then
         lc_texto := 'Seguro Vehicular';
       elsif i.aomod = 113 then
            lc_texto := 'Seguro Movigas';
       else
           begin
             select trim(sgtxt) into lc_texto from fst300 where sgcod = i.sgcod and sgcod <> 150;
           exception when no_data_found then
                lc_msg := null;
                lc_ind := 'N';
           end;
       end if;
       if lc_ind = 'S' then
           lc_msg := 'Cliente tiene credito(s) con ' ||' '||lc_texto;
           exit;
       end if;

    end loop;

 end sp_cr_credito_seguro;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   -- *****************************************************************
    -- Nombre                     : sp_cr_credito_mora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/02/2014
    -- Autor de Creación          : SMARQUEZ
    -- Uso                        : Determina si cliente tiene seguros asociados.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2007.09.03
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                                                       
    -- *****************************************************************
   procedure sp_ah_control(ln_pais in number,
                           ln_tdoc in number,
                           lc_ndoc in char,
                           lc_men out char) is
     Cursor seguro is
        SELECT LTRIM(SUBSTR(CUENTA,1,9),'0')as certificado,
               producto
          FROM v_certseguros
         where cuenta is not null;
     cuenta number := 0;
     msg char(200);
   Begin
      select ctnro
        into cuenta
        from fsr008
       where pepais = ln_pais
         and petdoc = ln_tdoc
         and pendoc = lc_ndoc;
      for j in  seguro loop
       if cuenta = to_number(j.certificado) then
          msg := msg ||('Tiene seguro asociado'||j.producto);
       end if;
     end loop;
     lc_men := msg;
   End;
   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   -- *****************************************************************
   -- Nombre                     : sp_cr_tiene_seguro
   -- Sistema                    : BANTOTAL
   -- Módulo                     : Créditos - Activas
   -- Versión                    : 1.0
   -- Fecha de Creación          : 15/05/2014
   -- Autor de Creación          : APACHECO
   -- Uso                        : Determina si cliente tiene un tipo de seguro asociado.
   -- Estado                     : Activo
   -- Acceso                     : Público
   -- Parámetros de Entrada      : P_N_PAIS ( PAIS DEL CLIENTE )
   --                              P_N_TDOC ( TIPO DE DOCUMENTO CLIENTE )
   --                              P_C_NDOC ( NUMERO DE DOCUMENTO CLIENTE )
   --                              P_C_PROD ( NOMBRE SEGURO A EVALUAR )
   -- Parámetros de Salida       : p_c_rpta ( S=SI TIENE SEGURO EVALULADO, N=SINO TIENE )
   --
   -- Fecha de Modificación      : 
   -- Autor de la Modificación   : 
   -- Descripción de Modificación: 
   --                                                       
   -- *****************************************************************
   PROCEDURE SP_CR_TIENE_SEGURO(P_N_PAIS IN NUMBER,
                                P_N_TDOC IN NUMBER,
                                P_C_NDOC IN VARCHAR2,
                                P_C_PROD IN VARCHAR2, 
                                p_c_rpta out varchar2 ) 
   IS
     
     ln_reg number(3) := 0;
     lc_numdoc char(12) := null;

   BEGIN
     lc_numdoc := trim(P_C_NDOC);
     p_c_rpta := 'N';
         
     SELECT count(*) into ln_reg 
       FROM v_certseguros c
      where c.PRODUCTO like P_C_PROD
        and c.DOCUMENTO = P_C_NDOC;
        
     if ln_reg = 0 then
       select count(*) into ln_reg 
         from jaqa41 
        where jaqa41emp = 1 
          and jaqa41naf like 'V%' 
          and jaqa41tse = 1
          and jaqa41est ='H'  
        --  AND JAQA41CTA <> 0 
          and jaqa41pac = P_N_PAIS 
          and jaqa41tpc = P_N_TDOC
          and jaqa41ndc = lc_numdoc  ;
     
     end if;
    
         
     if ln_reg > 0 then
        p_c_rpta := 'S';     
           
     end if;
     
  END SP_CR_TIENE_SEGURO;
  
  
  procedure sp_Alerta_prendario(ln_cuenta in number,                                
                                ln_sucur  in number,
                                lc_mensaje out varchar2)is
  cursor cuentas is
    select distinct aocta, aooper, aosuc, aotope
      from fsd010
     where pgcod = 1
       and aomod = 108
       and aocta = ln_cuenta
       and aostat <> 99
     order by aosuc;
         
  ln_contador number := 0;   
  lc_analista varchar2(10);
  mensaje varchar2(200);
  sucursal char(100);
  nombre char(100);
  begin
    For c in cuentas loop
      if ln_sucur <> c.aosuc then
        ln_contador := ln_contador + 1;   
        Begin
          select scnom
            into nombre
            from fst001
           where sucurs = c.aosuc;
        exception
          when no_Data_found then
            nombre := null;
        end;
        begin   
            if ln_contador = 1 then                 
                sucursal := trim(nombre);
            else      
              if INSTR(sucursal, trim(nombre)) = 0 then
                 sucursal := trim(nombre)||' '||trim(sucursal);
              end if;
            end if;               
            exception
              when others then
                 sucursal := trim(nombre);   
        end;
        begin         
         select max(substr(pp178dtext, 1, 10))
           into lc_analista
           from fpp178
          where pp174cod = (SELECT max(pp174cod)
                              FROM fpp175 d
                             where d.pp173cod = 1
                               and d.pp175suc = c.aosuc
                               and d.pp175mda = 0
                               and d.pp175pap = 0
                               and d.pp175cta = c.aocta
                               and d.pp175oper = c.aooper
                               and d.pp175sbop = ( select max(aosbop)
                                                     from fsd010
                                                    where pgcod = 1 
                                                      and aomod = 108
                                                      and aosuc = c.aosuc
                                                      and aomda = 0
                                                      and aopap = 0
                                                      and aocta = c.aocta
                                                      and aooper = c.aooper
                                                      and aotope = c.aotope)
                               and d.pp175mod = 108
                               and d.pp175tope = c.aotope)
            and pp177codd = 7;   
            if ln_contador = 1 then   
               mensaje := trim(lc_analista);
            else        
              if INSTR(mensaje, trim(lc_analista)) = 0 then
                 mensaje := trim(mensaje) ||' '||trim(lc_analista);
              end if;
            end if;
        exception
          when no_data_found then
               lc_analista := null;
        end;             
      end if;
    end loop;      
    if ln_contador <> 0 then
       lc_mensaje := 'El cliente cuenta con otro(s) credito(s) prendario(s) en la(s) Agencia(s):'||' '||trim(sucursal)||' '||'Analista(s):'||' '|| trim (mensaje);
    else
       lc_mensaje := null;
    end if;        
  end sp_Alerta_prendario;                               
END PQ_CR_CREDITOS_ALERTAS;
/

