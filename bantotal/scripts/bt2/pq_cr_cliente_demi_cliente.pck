create or replace package PQ_CR_CLIENTE_DEMI_CLIENTE is

  -- Author  : SMARQUEZ
  -- Created : 7/04/2021 10:15:50 a. m.
  -- Purpose : DATOS AFILIACION DE SEGUROS VC

  -- Public type declarations
  procedure SP_VERIFICA_VC(ln_pais in number,
                           ln_tdoc in number,
                           lc_ndoc in varchar2,
                           lc_fVC  out varchar2,
                           lc_Tipro out varchar2 );

  procedure SP_Creditos_VC( pais in number,
                            tdoc in number,
                            ndoc in varchar2,
                            flag out varchar2) ;

end PQ_CR_CLIENTE_DEMI_CLIENTE;
/

create or replace package body PQ_CR_CLIENTE_DEMI_CLIENTE is

  procedure SP_VERIFICA_VC(ln_pais in number,
                           ln_tdoc in number,
                           lc_ndoc in varchar2,
                           lc_fVC  out varchar2,
                           lc_Tipro out varchar2 ) is

   flgVC varchar2(1);
   lc_seg varchar2(20);
   tipopro varchar(1);
   ln_cta number :=0;
   ln_mod number:=0;
   ln_mda number:=0;
   ln_sbop number:=0;
   ln_tip number:=0;
   ln_suc number:=0;
   ln_pap number:=0;
   ln_oper number:=0;   
   ln_cod number :=1;
   ld_fecha date;
   lc_flag char(1);
   lc_rpta varchar2(100);
   lc_tipro1 char(1);
   lc_doc char(12);
   ln_tam number:=0;
   lc_cuenta char(30);
   begin
     lc_doc := trim(lc_ndoc);
     lc_seg := 'VIDA CAJA AHORROS%';
     
     select pgfape into ld_fecha from fst017 where pgcod = ln_cod;

     pQ_CR_CREDITOS_ALERTAS.SP_CR_TIENE_SEGURO(ln_pais,ln_tdoc,lc_ndoc,lc_seg,flgVC);
     
     
     

     if flgVC <> 'S' then
        SP_Creditos_VC(ln_pais,ln_tdoc,lc_ndoc,flgVC);
        lc_Tipro :='C';
        lc_tipro1 :='C';   
     else
       lc_Tipro :='A';
       lc_tipro1 :='A';
       BEGIN
         
            SELECT distinct length(cuenta), cuenta 
              into ln_tam, lc_cuenta
              FROM v_certseguros c
             where c.PRODUCTO like 'VIDA CAJA AHORROS%' 
               and c.documento = lc_ndoc;
             if ln_tam = 27 then
                 ln_cta := SUBSTR(lc_cuenta,1,9);
                 ln_mod := SUBSTR(lc_cuenta,10,3);
                 ln_mda := SUBSTR(lc_cuenta,13,3);
                 ln_oper := SUBSTR(lc_cuenta,16,9);
                 ln_tip := SUBSTR(lc_cuenta,25,3);
                 Begin
                    Select scsuc, scsbop
                      into ln_suc, ln_sbop
                      from fsd011
                     where pgcod = ln_cod
                       and sccta = ln_cta
                       and scmod = ln_mod
                       and scmda = ln_mda
                       and scoper = ln_oper
                       and sctope = ln_tip;
                Exception
                  when no_data_found then
                    Begin
                      select aosuc, aosbop
                        into ln_suc, ln_sbop
                        from fsd010
                       where pgcod = ln_cod
                         and aocta = ln_cta
                         and aomod = ln_mod
                         and aomda = ln_mda
                         and aooper = ln_oper
                         and aotope = ln_tip;
                    exception
                      when no_data_found then   
                        ln_suc := 0;
                        ln_oper := 0;
                    end;
                end;    
             else
                 if ln_tam = 20 then
                   ln_cta := SUBSTR(lc_cuenta,1,9);
                   ln_mod := SUBSTR(lc_cuenta,10,3);
                   ln_mda := SUBSTR(lc_cuenta,13,3);
                   ln_sbop := SUBSTR(lc_cuenta,16,2);
                   ln_tip := SUBSTR(lc_cuenta,18,3);   
                   Begin
                      Select scsuc, scoper
                        into ln_suc, ln_oper
                        from fsd011
                       where pgcod = ln_cod
                         and sccta = ln_cta
                         and scmod = ln_mod
                         and scmda = ln_mda
                         and scsbop = ln_sbop
                         and sctope = ln_tip;
                  Exception
                    when no_data_found then
                      Begin
                        select aosuc, aosbop
                          into ln_suc, ln_sbop
                          from fsd010
                         where pgcod = ln_cod
                           and aocta = ln_cta
                           and aomod = ln_mod
                           and aomda = ln_mda
                           and aosbop = ln_sbop
                           and aotope = ln_tip;
                      exception
                        when no_data_found then   
                          ln_suc := 0;
                          ln_oper := 0;
                      end;
                  end;               
               end if; 
             end if;
             lc_flag := 'S';  
       exception
         when no_data_found then
           lc_flag := 'N';  
       end;
        
       If lc_flag ='S' then     
          pq_ah_seguros_pasivas.sp_marca_cuentas_campania(P_N_PGCOD  => ln_cod,
                                                          P_N_SCSUC  => ln_suc,
                                                          P_N_SCMDA  => ln_mda,
                                                          P_N_SCPAP  => ln_pap,
                                                          P_N_SCCTA  => ln_cta,
                                                          P_N_SCOPER => ln_oper,
                                                          P_N_SCSBOP => ln_sbop,
                                                          P_N_SCTOPE => ln_tip,
                                                          P_N_SCMOD  => ln_mod,
                                                          P_N_PAIS   => ln_pais,
                                                          P_N_TDOC   => ln_tdoc,
                                                          P_C_NDOC   => lc_doc,
                                                          P_D_FERE   => ld_fecha,
                                                          P_C_TIPO   => lc_Tipro1,
                                                          P_C_RPTA   => lc_rpta) ;            
        end if;                                                                
       
     end if;
     lc_fVC := flgVC;
  end SP_VERIFICA_VC;

  procedure SP_Creditos_VC( pais in number,
                            tdoc in number,
                            ndoc in varchar2,
                            flag out varchar2)is

  documento char(12);
  pn_cantV number:=0;
  pn_cantVV number:=0;
  fecha date;
  mensaje char(100);
  begin
    documento := ndoc;
    
    select pgfape into fecha from fst017 where pgcod = 1;
    
     select Nvl(count(*), 0)
       into pn_cantV
       from fsd010 ff,
            fpp001 gg
      where ff.pgcod  = gg.pgcod
        and ff.aomod  = gg.aomod
        and ff.aosuc  = gg.aosuc
        and ff.aomda  = gg.aomda
        and ff.aopap  = gg.aopap
        and ff.aocta  = gg.aocta
        and ff.aooper = gg.aooper
        and ff.aosbop = gg.aosbop
        and ff.aotope = gg.aotope
        and ff.aocta in (SELECT NVL (B1.CTNRO, B1.CTNRO)---15022017
                           from SNG001 A,
                                FSR008 B1
                          WHERE A.SNG001PAIS = B1.PEPAIS
                            AND A.SNG001TDOC = B1.PETDOC
                            AND A.SNG001NDOC = B1.PENDOC
                            --AND A.SNG001INST = pn_ins
                            and b1.pepais = pais
                            and b1.petdoc = tdoc
                            and b1.pendoc = documento
                            )
        and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50)
        and ff.aostat <>99
        and gg.sgcod  in (select b2.tp1nro3
                            from fst198 b2
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 = 1
                             and tp1nro1 = 1)
        and gg.aooper not in
        (select xwfoperacion from xwf700 where xwfcuenta = ff.aocta and xwfcar3 <> '1');
        
        

     if pn_cantV = 0 then

         --solicitudes en vuelo

         select NVL(count(*),0)
           into pn_cantVV
           from fpp001 gg,xwf700 h,wfwrkitems i
          where
          --gg.aocta in (SELECT NVL (B1.CTNRO, B1.CTNRO)---20180607 se comento y reemplazo por H.XWFCUENTA IN (SELECT NVL(B1.CTNRO, B1.CTNRO)
          H.XWFCUENTA IN (SELECT NVL(B1.CTNRO, B1.CTNRO)
                               from SNG001 A,
                                    FSR008 B1
                              WHERE A.SNG001PAIS = B1.PEPAIS
                                AND A.SNG001TDOC = B1.PETDOC
                                AND A.SNG001NDOC = B1.PENDOC
                               -- AND A.SNG001INST = pn_ins)
                                and b1.pepais = pais
                                and b1.petdoc = tdoc
                                and b1.pendoc = documento)
            --and gg.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50) ---20180607 se comento y reemplazo por AND H.XWFMODULO IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
            AND H.XWFMODULO IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
            and gg.sgcod  in (select b2.tp1nro3
                                from fst198 b2
                               Where Tp1cod   = 1
                                 and Tp1cod1  = 10898
                                 and Tp1corr1 = 18
                                 and tp1corr3 = 1
                                 and tp1nro1 = 1)
            and gg.pgcod  = h.xwfempresa
            and gg.aomod  = h.xwfmodulo
            and gg.aosuc  = h.xwfsucursal
            and gg.aomda  = h.xwfmoneda
            and gg.aopap  = h.xwfpapel
            and gg.aocta  = h.xwfcuenta
            and gg.aooper = h.xwfoperacion
            and gg.aosbop = h.xwfsubope
            and gg.aotope = h.xwftipope
            and h.xwfcar3 = '1'
            and i.wfinsprcid = h.xwfprcins
            and i.wfitemstsact = 1;
        
   end if;
    IF pn_cantV >= 1 OR pn_cantVV >=1 then
         flag := 'S';
       if pn_cantV >=1 then
         Begin
           insert into aqpa553 (aqpa553cod, 
                                aqpa553mod, 
                                aqpa553suc, 
                                aqpa553mda, 
                                aqpa553pap, 
                                aqpa553cta, 
                                aqpa553ope, 
                                aqpa553sbo, 
                                aqpa553tip, 
                                aqpa553fec, 
                                aqpa553pai, 
                                aqpa553tdo, 
                                aqpa553ndo, 
                                aqpa553tpro, 
                                aqpa553est,
                                aqpa553a1) 
                 select ff.pgcod,
                        ff.aomod,
                        ff.aosuc,
                        ff.aomda,
                        ff.aopap,
                        ff.aocta,
                        ff.aooper,
                        ff.aosbop,
                        ff.aotope,
                        fecha,
                        pais,
                        tdoc,
                        documento,
                        'C',
                        'E',
                        gg.sgcod
                   from fsd010 ff,
                        fpp001 gg
                  where ff.pgcod  = gg.pgcod
                    and ff.aomod  = gg.aomod
                    and ff.aosuc  = gg.aosuc
                    and ff.aomda  = gg.aomda
                    and ff.aopap  = gg.aopap
                    and ff.aocta  = gg.aocta
                    and ff.aooper = gg.aooper
                    and ff.aosbop = gg.aosbop
                    and ff.aotope = gg.aotope
                    and ff.aocta in (SELECT NVL (B1.CTNRO, B1.CTNRO)---15022017
                                       from SNG001 A,
                                            FSR008 B1
                                      WHERE A.SNG001PAIS = B1.PEPAIS
                                        AND A.SNG001TDOC = B1.PETDOC
                                        AND A.SNG001NDOC = B1.PENDOC
                                        --AND A.SNG001INST = pn_ins
                                        and b1.pepais = pais
                                        and b1.petdoc = tdoc
                                        and b1.pendoc = documento
                                        )
                    and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50)
                    and ff.aostat <>99
                    and gg.sgcod  in (select b2.tp1nro3
                                        from fst198 b2
                                       Where Tp1cod   = 1
                                         and Tp1cod1  = 10898
                                         and Tp1corr1 = 18
                                         and tp1corr3 = 1
                                         and tp1nro1 = 1)
                    and gg.aooper not in
                    (select xwfoperacion from xwf700 where xwfcuenta = ff.aocta and xwfcar3 <> '1');
           commit;
           exception
              when others then
                mensaje := substr(sqlerrm, 1, 100);         
           end;                   
       else
         Begin
            insert into aqpa553 (aqpa553cod, 
                                aqpa553mod, 
                                aqpa553suc, 
                                aqpa553mda, 
                                aqpa553pap, 
                                aqpa553cta, 
                                aqpa553ope, 
                                aqpa553sbo, 
                                aqpa553tip, 
                                aqpa553fec, 
                                aqpa553pai, 
                                aqpa553tdo, 
                                aqpa553ndo, 
                                aqpa553tpro, 
                                aqpa553est,
                                aqpa553a1)
             select gg.pgcod, 
                    gg.aomod,
                    gg.aosuc,
                    gg.aomda,
                    gg.aopap,
                    gg.aocta,
                    gg.aooper,
                    gg.aosbop,
                    gg.aotope,
                    fecha,
                    pais,
                    tdoc,
                    documento,
                    'C',
                    'V', 
                    gg.sgcod
               from fpp001 gg,xwf700 h,wfwrkitems i
              where H.XWFCUENTA IN (SELECT NVL(B1.CTNRO, B1.CTNRO)
                                     from SNG001 A,
                                          FSR008 B1
                                    WHERE A.SNG001PAIS = B1.PEPAIS
                                      AND A.SNG001TDOC = B1.PETDOC
                                      AND A.SNG001NDOC = B1.PENDOC
                                      and b1.pepais = pais
                                      and b1.petdoc = tdoc
                                      and b1.pendoc = documento)
                AND H.XWFMODULO IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
                and gg.sgcod  in (select b2.tp1nro3
                                    from fst198 b2
                                   Where Tp1cod   = 1
                                     and Tp1cod1  = 10898
                                     and Tp1corr1 = 18
                                     and tp1corr3 = 1
                                     and tp1nro1 = 1)
                and gg.pgcod  = h.xwfempresa
                and gg.aomod  = h.xwfmodulo
                and gg.aosuc  = h.xwfsucursal
                and gg.aomda  = h.xwfmoneda
                and gg.aopap  = h.xwfpapel
                and gg.aocta  = h.xwfcuenta
                and gg.aooper = h.xwfoperacion
                and gg.aosbop = h.xwfsubope
                and gg.aotope = h.xwftipope
                and h.xwfcar3 = '1'
                and i.wfinsprcid = h.xwfprcins
                and i.wfitemstsact = 1;
         commit;
         exception
            when others then
              mensaje := substr(sqlerrm, 1, 100);
           
         end;
       end if;     
    else
         flag := 'N';
    end if;

  end  SP_Creditos_VC;


end PQ_CR_CLIENTE_DEMI_CLIENTE;
/

