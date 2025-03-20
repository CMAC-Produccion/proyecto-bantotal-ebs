create or replace package PQ_CR_VALIDACIONES_CRE_CANCE is
  -- *****************************************************************
  -- Nombre                     : VALIDAR TITULAR DE CREDITO CANCELADO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2021.05.14
  -- Autor de Creación          : EFUENTES
  -- Uso                        : VALIDAR TITULAR
  -- Estado                     : Activo
  -- Acceso                     : Público
  --
  -- ****************************************************************
  
  procedure sp_cr_val_modulo(pn_modulo  in number,
                             pv_FlagMod out varchar2);
                                
  -----------------------------------------------------------------------
  procedure sp_cr_val_estado(pn_pgcod   in number, 
                             pn_cuenta  in number,
                             pn_modulo  in number,
                             pn_opera   in number,
                             pn_sucur   in number,
                             pn_moneda  in number,
                             pn_papel   in number,
                             pn_tope    in number,
                             pd_fecgui  in date, 
                             pv_FlagSta out varchar2);

  -----------------------------------------------------------------------
  procedure sp_cr_dat_credito(pn_pgcod  in number, 
                              pn_cta    in number, 
                              pv_ope    in number,
                              pn_mod    in number,                              
                              pn_pgcodO out number,
                              pn_sucO   out number,
                              pn_modO   out number,
                              pn_monO   out number,
                              pn_papO   out number,
                              pn_ctaO   out number,
                              pn_opeO   out number,
                              pn_sopeO  out number,
                              pn_topeO  out number);
                               
  -----------------------------------------------------------------------                                      
  procedure sp_cr_val_contancia(pn_pgcod   in number,
                                pn_suc     in number,
                                pn_mod     in number,
                                pn_mon     in number,
                                pn_pap     in number,
                                pn_cta     in number,
                                pn_ope     in number,
                                pn_sope    in number,
                                pn_tope    in number,
                                pv_Flag608 out varchar,
                                pv_FlagImp out varchar);

  -----------------------------------------------------------------------
  procedure sp_cr_val_TipOpe_gr(pn_pgcodc   in NUMBER,
                                pn_modc     in NUMBER,
                                pn_succ     in NUMBER,
                                pn_monc     in NUMBER,
                                pn_papc     in NUMBER,
                                pn_ctac     in NUMBER,
                                pn_opec     in NUMBER,
                                pn_sopec    in NUMBER,
                                pn_topec    in NUMBER,
                                pv_FlagGar  out varchar);
                               
  -----------------------------------------------------------------------
                               
end PQ_CR_VALIDACIONES_CRE_CANCE;
/

create or replace package body PQ_CR_VALIDACIONES_CRE_CANCE is
  procedure sp_cr_val_modulo(pn_modulo  in number,
                             pv_FlagMod out varchar2)is
                             
  CURSOR lst_modulos IS
    select t111.modulo Cur_Mod
      from fst111 t111
      where t111.Dscod = 50 and t111.Modulo != 116;
          
  BEGIN
    begin 
      FOR i IN lst_modulos LOOP
        if i.Cur_Mod = pn_modulo then
          pv_FlagMod := 'S';
        else
          pv_FlagMod := 'N';
        end if;
        EXIT WHEN pv_FlagMod = 'S';
      END LOOP;      
    EXCEPTION    
       when others then
        pv_FlagMod := 'N';
    end;       
  END sp_cr_val_modulo;
  
 
--**********************************************************************************************************--  
  procedure sp_cr_val_estado(pn_pgcod   in number, 
                             pn_cuenta  in number,
                             pn_modulo  in number,
                             pn_opera   in number,
                             pn_sucur   in number,
                             pn_moneda  in number,
                             pn_papel   in number,
                             pn_tope    in number,
                             pd_fecgui  in date, 
                             pv_FlagSta out varchar2) is
  ln_estado number;
  BEGIN
    begin
      select Aostat into ln_estado
      from fsd010 a
      where Pgcod  = pn_pgcod and Aocta  = pn_cuenta and Aomod  = pn_modulo
        and Aooper = pn_opera --and Aofe99 >= pd_fecgui 
        and Aosuc  = pn_sucur and Aomda  = pn_moneda 
        and Aopap  = pn_papel and Aotope = pn_tope
        and rownum = 1
      order by Aosbop desc;
      
      if ln_estado = 99 then 
        pv_FlagSta := 'S';
      else
        pv_FlagSta := 'N';
      end if;      
    EXCEPTION         
       when others then
         pv_FlagSta := 'N';
    end;
    
  END sp_cr_val_estado;
  
--**********************************************************************************************************-- 

  procedure sp_cr_dat_credito(pn_pgcod  in number, 
                              pn_cta    in number, 
                              pv_ope    in number,
                              pn_mod    in number,                              
                              pn_pgcodO out number,
                              pn_sucO   out number,
                              pn_modO   out number,
                              pn_monO   out number,
                              pn_papO   out number,
                              pn_ctaO   out number,
                              pn_opeO   out number,
                              pn_sopeO  out number,
                              pn_topeO  out number) is
  BEGIN

    begin      
      select Pgcod, Aosuc, Aomod, Aomda, Aopap, Aocta, Aooper, Aosbop, Aotope
        into pn_pgcodO, pn_sucO, pn_modO, pn_monO, pn_papO, pn_ctaO, pn_opeO, pn_sopeO, pn_topeO
      from fsd010
      where Pgcod  = pn_pgcod and Aocta  = pn_cta and Aooper  = pv_ope
        and Aomod  = pn_mod   and aostat = 99;
    EXCEPTION          
       when others then 
         null;
    end;

  END sp_cr_dat_credito;
  
--**********************************************************************************************************--  
 
  procedure sp_cr_val_contancia(pn_pgcod   in number,
                                pn_suc     in number,
                                pn_mod     in number,
                                pn_mon     in number,
                                pn_pap     in number,
                                pn_cta     in number,
                                pn_ope     in number,
                                pn_sope    in number,
                                pn_tope    in number,
                                pv_Flag608 out varchar,
                                pv_FlagImp out varchar) is
  ln_correlativo number;
  BEGIN
    begin 
      pv_Flag608 := 'S';
      pv_FlagImp := 'S';
      
      select AQPB608CORR, AQPB608FIMP
        INTO ln_correlativo, pv_FlagImp
      from AQPB608
      Where AQPB608PGCODC = pn_pgcod and AQPB608MODC   = pn_mod and AQPB608SUCC   = pn_suc
      and AQPB608MONC   = pn_mon and AQPB608PAPC   = pn_pap and AQPB608CTAC   = pn_cta
      and AQPB608OPEC   = pn_ope and AQPB608SOPEC  = pn_sope and AQPB608TOPEC  = pn_tope;
      
      IF ln_correlativo IS NULL OR ln_correlativo = 0 THEN
        pv_Flag608 := 'N';
        pv_FlagImp := 'N';
      END IF;      
    EXCEPTION          
       when others then
         pv_Flag608 := 'N';
         pv_FlagImp := 'N';
    end;
  END sp_cr_val_contancia;
  
  --**********************************************************************************************************--  
  
  procedure sp_cr_val_TipOpe_gr(pn_pgcodc   in NUMBER,
                                        pn_modc     in NUMBER,
                                        pn_succ     in NUMBER,
                                        pn_monc     in NUMBER,
                                        pn_papc     in NUMBER,
                                        pn_ctac     in NUMBER,
                                        pn_opec     in NUMBER,
                                        pn_sopec    in NUMBER,
                                        pn_topec    in NUMBER,
                                        pv_FlagGar  out varchar) is

  CURSOR lst_tipope IS
      select TRIM(Tpdesc) CodTO
      from fst098
      Where Pgcod = 1
        And Tpcod = 7750
        And Tpnro = 1
        And Tpcorr >= 21
        And Tpcorr <= 50;
        
  ln_CurTO  number;
  l_instancia number; 
  pn_tipope number;
  my_errm   VARCHAR2(32000);
  BEGIN
    --OBTENEMOS INSTANCIA
    begin 
      select f.xwfprcins into l_instancia
      from xwf700 f 
      where f.xwfempresa = pn_pgcodc and f.xwfsucursal = pn_succ 
        and f.xwfmodulo = pn_modc    and f.xwfmoneda = pn_monc 
        and f.xwfpapel = pn_papc     and f.xwfcuenta = pn_ctac
        and f.xwfoperacion = pn_opec and f.xwfsubope = pn_sopec 
        and f.xwftipope = pn_topec   and f.xwfcar3 = '1' ;
    EXCEPTION    
       when others then
         begin 
           select f.xwfprcins into l_instancia
           from xwf700 f 
           where f.xwfempresa = pn_pgcodc and f.xwfsucursal = pn_succ 
             and f.xwfmodulo = pn_modc    and f.xwfmoneda = pn_monc 
             and f.xwfpapel = pn_papc     and f.xwfcuenta = pn_ctac
             and f.xwfoperacion = pn_opec and f.xwfsubope = pn_sopec 
             and f.xwftipope = pn_topec   and f.xwfcar3 = '1'
             and rownum = 1;
         EXCEPTION
           when others then
             my_errm := SQLERRM;
             --DBMS_OUTPUT.put_line (my_errm);
             pv_FlagGar := 'N';
        end;  
    end;
      
    --OBTENEMOS TIPO DE OPERACION DE GARANTIA
    begin 
      select g.sng122tope into pn_tipope
      from sng122 g
      where g.sng122inst = l_instancia;
    EXCEPTION
      when others then
        begin 
          select g.sng122tope into pn_tipope
          from sng122 g
          where g.sng122inst = l_instancia and rownum = 1;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
            --DBMS_OUTPUT.put_line (my_errm);
            pv_FlagGar := 'N';
        end; 
    end; 
    --OPCIONAL USAR ESTA TABLA 
    --select * from fsr011 where relcod = 50 and r011co = 'F' and r1 va la clave del credito  
    begin 
      FOR i IN lst_tipope LOOP
        ln_CurTO := i.CodTO;
          
        if ln_CurTO = pn_tipope then
          pv_FlagGar := 'S';
        else
          pv_FlagGar := 'N';           
        end if;
                  
        EXIT WHEN pv_FlagGar = 'S';
      END LOOP;
            
    EXCEPTION    
       when others then
         my_errm := SQLERRM;
         --DBMS_OUTPUT.put_line (my_errm);
         pv_FlagGar := 'N';
    end;

  END sp_cr_val_TipOpe_gr;
  
  --**********************************************************************************************************--  

end PQ_CR_VALIDACIONES_CRE_CANCE;
/

