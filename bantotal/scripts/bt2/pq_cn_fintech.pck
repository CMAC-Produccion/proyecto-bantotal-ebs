create or replace package pq_cn_fintech is

  -- Author  : HLAQUI
  -- Created : 29/11/2017
  -- Purpose : Paquete que realiza la migracion de FORMIK
  -- Autor Modificacion:   
  -- Fecha Modificacion: 
  -- Descripcion Modificacion: 
  
   Procedure sp_obtener_tasa(pn_Monto in number,
                       pn_Plazo in number,
                       pn_Modulo in number,
                       pn_TipOpe in number,
                       pn_tasa out number,
                       pn_TasDes out number);
   Procedure sp_valida_cliente(pn_Pais in number,
                       pn_TipDoc in number,
                       pn_NumDoc in varchar2,
                       pc_CliNue out varchar2,
                       pc_LisNeg out varchar2
                       );
 
   Procedure sp_productos_cliente(pn_Pais in number,
                       pn_TipDoc in number,
                       pn_NumDoc in varchar2,
                       pc_ProCli out varchar2
                       );         
  
   Procedure sp_cuota_estimada(                    
                       pn_NumDoc in varchar2,
                       pn_IdLog in number,
                       pn_CuoEst out number
                       );
   Procedure sp_productos_dolares_RCC(                       
                       pn_NumDoc in varchar2,
                       pc_DeuDol out varchar2
                       );   
   Procedure sp_registra_flujo( p_n_NumCorr number );                       
   Procedure sp_actualiza_solicitudes(pd_FecIni in date,
                       pd_FecFin in date
                       );
   Procedure sp_anular_instancias;
   Procedure sp_registra_panel_saldo(pn_NroIns in number);
   Procedure sp_migracion_personas_fintech (p_n_NumCorr number);
   Procedure sp_migracion_cuentas_fintech (p_n_NumCorr number);
                         
end pq_cn_fintech;
/

create or replace package body pq_cn_fintech is
-- rmontes 2021.03.08 se agrego rubro 0303 en lineas 309...318

Procedure sp_obtener_tasa(pn_Monto in number,
                       pn_Plazo in number,
                       pn_Modulo in number,
                       pn_TipOpe in number,
                       pn_Tasa out number,
                       pn_TasDes out number)is

ln_mod  number(3);
ln_suc  number(3);
ln_mda  number(4);
ln_pap  number(4);
ln_top  number(3);
ln_mto  number(17,2);
ln_pzo  number(5);
ln_defn number(17,2);
ln_cont number(5) := 0;
ln_tas  number(10,6);
ln_tasdes  number(10,6);
ln_mtt  number(17,2);
ln_fde  date;
ln_tat  number(7,4);
ln_cont2 number(5) := 0;
ln_tvmpo number(7,4);
ln_porc  number(4) := 100;
pd_fecpro date;

cursor tasa(cn_defn in number,
            cn_mod in number,
            cn_mda in number,
            cn_pap in number,
            cn_mto in number,
            cn_pzo in number,
            cf_fec in date) is
select *
  from fsr025 a
 where a.pgcod  =  1
   and a.tpizar =  cn_defn
   and a.tamod  =  cn_mod
   and a.tamda  =  cn_mda
   and a.tapap  =  cn_pap
   and a.tamto  >= cn_mto
   and a.tapzo  >= cn_pzo 
   and a.tafdes <= cf_fec
   and a.tafdes  = (select max(aa.tafdes)
                      from fsr025 aa
                     where aa.pgcod  =  1
                       and aa.tpizar =  cn_defn
                       and aa.tamod  =  cn_mod
                       and aa.tamda  =  cn_mda
                       and aa.tapap  =  cn_pap
                       --and aa.tamto  >= cn_mto
                       --and aa.tapzo  >= cn_pzo 
                       and aa.tafdes <= cf_fec
                       );
cursor region (cn_sucR in number)is
select *
  from fst811 a
 where a.pgcod  =  1
   and a.regcod >= 100
   and a.oficod =  cn_sucR;
   
   
cursor tasa_esp(cn_modE in number,
                cn_defE in number,
                cn_papE in number,
                cn_mdaE in number,
                cn_mtoE in number,
                cn_regE in number,
                cd_fecE in date
                ) is   
                
select *
  from fsd527 a
 where a.pgcod  = 1
   and a.tamod  = cn_modE
   and a.tpizar = cn_defE
   and a.tapap  = cn_papE
   and a.tamda  = cn_mdaE
   and a.tvfmon = cn_mtoE
   and a.tvsuc  = cn_regE
   and a.tvfdes <=cd_fecE;
  
cursor tasa_des is
  select d.cominp from x054011 z 
  inner join fst300 b on b.sgcod > 260 and b.sgcod < 269 and z.sgcod=b.sgcod
  inner join fpp065 f on f.pp065sgcod = z.sgcod and f.pp065tipo3=30 
  inner join fsp026 d on d.comod=z.xpremod and d.cocod=b.sgcd03 and d.cocta=0 and comda=0
  where 
  z.xpremod=pn_Modulo and z.xpretope=pn_TipOpe;

              
begin
     select pgfape into pd_fecpro from fst017 where pgcod=1;   
      ln_mod := pn_Modulo;
      ln_mda := 0;
      ln_pap := 0;
      ln_top := pn_TipOpe;
      ln_pzo := pn_Plazo*30;
      ln_suc := 1;
      ln_mto := pn_Monto;
     
     --obtiene pizarra
     begin
         select Pp028DefN
           into ln_defn
           from fpp028 
          where Pp010Prd = 1
            and Pp017Par = 17
            and Pp028Mod = ln_mod
            and Pp028Mda = ln_mda
            and Pp028Pap = ln_pap
            and Pp028Top = ln_top;
     exception
       when others then null;
     end;
     
     for i in tasa (ln_defn,
                    ln_mod,
                    ln_mda,
                    ln_pap,
                    ln_mto,
                    ln_pzo,
                    pd_fecpro
                    )loop
                    
         ln_tas  := i.Tatasa;
         ln_mtt  := i.Tamto;
         ln_fde  := i.Tafdes;
         ln_tat  := i.Tatol;
         ln_cont := ln_cont + 1;
         
         if ln_cont > 0 then
            exit;
         end if;
         
     end loop;
     
     for j in region(ln_suc) loop
         for k in tasa_esp(ln_mod,
                           ln_defn,
                           ln_pap,
                           ln_mda,
                           ln_mtt,--MOD@ABR 20171018
                           j.regcod,
                           pd_fecpro)loop
         
         ln_tvmpo := k.TvMPorc - ln_porc;
         ln_cont2 := ln_cont2 + 1;
         
         if ln_cont2 > 0 then
            exit;
         end if;
         
         end loop;
     end loop;
     
     for k in tasa_des loop
        ln_tasdes := k.cominp;
     end loop; 
     
     pn_tasa := nvl(ln_tas,0)+nvl(ln_tvmpo,0);
     pn_tasdes := nvl(ln_tasdes, 0)/100;
     
end sp_obtener_tasa; 

Procedure sp_valida_cliente(pn_Pais in number,
                       pn_TipDoc in number,
                       pn_NumDoc in varchar2,
                       pc_CliNue out varchar2,
                       pc_LisNeg out varchar2
                       )is
ln_NumLis Number(5);
lc_ProCli varchar(2);
  
begin    
    pq_cn_fintech.sp_productos_cliente(pn_pais,
                                     pn_tipdoc,
                                     pn_numdoc,
                                     lc_ProCli);
    If lc_ProCli = 'S' then --S: Si tiene Productos en la CAJA
       pc_CliNue := 'N';
    Else --N: No tiene Productos en la CAJA
       pc_CliNue := 'S';
    End If;
                                     
    
    select count(1) into ln_NumLis from fsd201 a
    where  LnPais = pn_Pais
    and LnTdoc = pn_TipDoc
    and LnNdoc = rpad(trim(pn_NumDoc), '25', ' ') ;
    --and tlis = 2;
    
    if ln_NumLis >= 1 then --NO esta en Lista Negra
      pc_LisNeg := 'S';
    else
      pc_LisNeg := 'N';
    end if;
  
end sp_valida_cliente;
Procedure sp_productos_cliente(pn_Pais in number,
                       pn_TipDoc in number,
                       pn_NumDoc in varchar2,
                       pc_ProCli out varchar2
                       )is
/*
Verifica que el cliente no tenga Productos Vigentes
ni tampoco Solicitudes en Vuelo
*/
ln_NumCre Number(5);
  
begin  
  
    select count(1) into ln_NumCre from (
    select 1
    from xwf700 x
   where x.xwfempresa = 1
     and x.xwfcuenta in (select Ctnro
                           from fsr008
                          where pepais = pn_Pais
                            and Petdoc = pn_TipDoc
                            and pendoc = rpad(trim(pn_NumDoc), '12', ' ')
                            and Ttcod = 1
                            and Cttfir = 'T'
                         )            
     and (x.xwfmodulo in
         (select modulo
             from fst111
            where dscod = 50
          ) or
         x.xwfmodulo = 117)
              
     and x.XWFPRCINS in
         (select wf.wfinsprcid
            from wfwrkitems wf
           where wf.wfinsprcid = x.xwfprcins
             and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
             and wf.wfiteminit =
                 (select max(wfiteminit)
                    from wfwrkitems w
                   where w.wfinsprcid = x.xwfprcins
                     and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                     and w.wfitemstsact = 1
                     and w.wfiteminit >=
                         to_date('2013.07.01', 'yyyy.mm.dd'))                     
             and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')            
             )                           
     and x.xwfcar3 = '1'      
  union all
    select 1
    from fsd011 f
    where f.PGCOD = 1 and f.SCMOD in (select modulo from fst111 where dscod = 50)
    and sccta in (select ctnro from fsr008 where pepais=pn_Pais and petdoc= pn_TipDoc and pendoc=rpad(trim(pn_NumDoc), '12', ' ') and cttfir='T')
    and scsdo != 0
    );
    
    if ln_NumCre >= 1 then --Tiene Productos Vigentes
      pc_ProCli := 'S';
    else
      pc_ProCli := 'N';
    end if;       
  
end sp_productos_cliente;

Procedure sp_cuota_estimada(                       
                       pn_NumDoc in varchar2,
                       pn_IdLog in number,
                       pn_CuoEst out number
                       )is
lc_CodSbs varchar2(50);
ld_FecRcc date;
  
begin  
  
select to_date(To_Char(tpnro), 'DDMMYYYY') into ld_FecRcc from fst098 where tpcod = 7647 and tpcorr =12;
--select to_date('30092016', 'DDMMYYYY') into ld_FecRcc from dual;

  BEGIN
       select nvl(c_codsbs,'') into lc_CodSbs from cldrcci where c_docide=trim(pn_NumDoc) and d_fecpre = ld_FecRcc;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      lc_CodSbs := '';
  END;
    --select nvl(c_codsbs,'') into lc_CodSbs from cldrcci where c_docide=trim(pn_NumDoc) and d_fecpre = ld_FecRcc;

 insert into aqpa184d
 (aqpa184did, aqpa184dcorr, aqpa184dsalcap, aqpa184dgasfin, aqpa184dnomemp, 
  aqpa184dfactor, aqpa184drubro, aqpa184dcodemp, aqpa184dnumdoc, aqpa184dcodsbs, 
  aqpa184dfecrcc, aqpa184dtipcre, aqpa184dtipcod)
 select pn_IdLog, rownum, x.Capital, x.Gasto, 
        (select y.c_desefi from ahtbanc y where y.c_codefi = x.c_codemp and rownum=1) desefi,
        x.Gasto/x.capital, x.c_cuenta, x.c_codemp, pn_NumDoc, lc_CodSbs, ld_FecRcc, 
        case 
          when substr(x.c_cuenta, 3,1) = 1 and x.c_cretip  in ('01','02','03','04','05','06','07','08','09','10') then 'Pymes S/.'
          when substr(x.c_cuenta, 3,1) = 1 and x.c_cretip  in ('11','12') then 'Consumo S/.'
          when substr(x.c_cuenta, 3,1) = 1 and x.c_cretip  in ('13') then 'Hipotecario S/.'
          when substr(x.c_cuenta, 3,1) = 2 and x.c_cretip  in ('01','02','03','04','05','06','07','08','09','10') then 'Pymes US$'
          when substr(x.c_cuenta, 3,1) = 2 and x.c_cretip  in ('11','12') then 'Consumo US$'
          when substr(x.c_cuenta, 3,1) = 2 and x.c_cretip  in ('13') then 'Hipotecario US$'
        end, x.c_cretip             
 from (
      select 
      sum(
          case 
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]0302') then 0.0440 * a.n_salcap 
          when REGEXP_LIKE(c_cuenta, '^72.506') and not REGEXP_LIKE(c_cuenta, '^72.50602|^72.50613') then 0.0880 * a.n_salcap        
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030302') and a.n_salcap <= 30000 then 0.0264 * a.n_salcap  -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030302') and a.n_salcap > 30000 then 0.0222 * a.n_salcap -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')  and a.n_salcap <= 8000 then 0.0514 * a.n_salcap -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')  and a.n_salcap <= 15000 then 0.0356 * a.n_salcap -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')  and a.n_salcap <= 45000 then 0.0282 * a.n_salcap -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')  and a.n_salcap > 45000 then 0.0222 * a.n_salcap     -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') and a.n_salcap <= 10000 then 0.0349 * a.n_salcap -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') and a.n_salcap <= 20000 then 0.0248 * a.n_salcap -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') and a.n_salcap <= 30000 then 0.0224 * a.n_salcap -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') and a.n_salcap > 30000 then 0.0205 * a.n_salcap -- se agrego rubro 0303
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]04') then 0.0090 * a.n_salcap            
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') and a.n_salcap <= 8000 then 0.0514 * a.n_salcap            
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') and a.n_salcap <= 15000 then 0.0356 * a.n_salcap            
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') and a.n_salcap <= 45000 then 0.0282 * a.n_salcap            
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') and a.n_salcap > 45000 then 0.0222 * a.n_salcap                              
          when REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') then 0.0900 * a.n_salcap      
          when REGEXP_LIKE(c_cuenta, '^72.50602|^72.50613') then 0.0378 * a.n_salcap
          when REGEXP_LIKE(c_cuenta, '^7101') then 0.0100 * a.n_salcap              
          else 0 end
      ) Gasto, c_CodEmp,c_cuenta, SUM(a.n_salcap) capital, a.c_cretip
  from cldrccs a
  where c_codsbs=lc_CodSbs and d_fecpre = ld_FecRcc
  group by c_CodEmp, c_cuenta, a.c_cretip ) x
  where x.gasto <> 0;
  commit;
------------------------------------------------------------------------------------------
  select nvl(sum(a.aqpa184dgasfin),0) into pn_CuoEst 
  from aqpa184d a
  where a.aqpa184did = pn_IdLog;
------------------------------------------------------------------------------------------
/*select 
sum(
  case 
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]0302') then 0.0440 * a.n_salcap 
    when REGEXP_LIKE(c_cuenta, '^72.506') and not REGEXP_LIKE(c_cuenta, '^72.50602|^72.50613') then 0.0880 * a.n_salcap        
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]030602') and a.n_salcap <= 30000 then 0.0264 * a.n_salcap 
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]030602') and a.n_salcap > 30000 then 0.0222 * a.n_salcap
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]0306') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612')  and a.n_salcap <= 8000 then 0.0514 * a.n_salcap
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]0306') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612')  and a.n_salcap <= 15000 then 0.0356 * a.n_salcap
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]0306') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612')  and a.n_salcap <= 45000 then 0.0282 * a.n_salcap
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]0306') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612')  and a.n_salcap > 45000 then 0.0222 * a.n_salcap    
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]030611|^14.[1-6]030612') and a.n_salcap <= 10000 then 0.0349 * a.n_salcap
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]030611|^14.[1-6]030612') and a.n_salcap <= 20000 then 0.0248 * a.n_salcap
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]030611|^14.[1-6]030612') and a.n_salcap <= 30000 then 0.0224 * a.n_salcap
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]030611|^14.[1-6]030612') and a.n_salcap > 30000 then 0.0205 * a.n_salcap
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]04') then 0.0090 * a.n_salcap            
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') and a.n_salcap <= 8000 then 0.0514 * a.n_salcap            
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') and a.n_salcap <= 15000 then 0.0356 * a.n_salcap            
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') and a.n_salcap <= 45000 then 0.0282 * a.n_salcap            
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') and a.n_salcap > 45000 then 0.0222 * a.n_salcap                              
    when REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302') then 0.0900 * a.n_salcap      
    when REGEXP_LIKE(c_cuenta, '^72.50602|^72.50613') then 0.0378 * a.n_salcap
    when REGEXP_LIKE(c_cuenta, '^7101') then 0.0100 * a.n_salcap              
  else 0 end
    ) into pn_CuoEst
from cldrccs a
where c_codsbs=lc_CodSbs and d_fecpre = ld_FecRcc;
*/
end sp_cuota_estimada;

Procedure sp_productos_dolares_RCC(                       
                       pn_NumDoc in varchar2,
                       pc_DeuDol out varchar2
                       )is
lc_CodSbs varchar2(50);
ld_FecRcc date;
ln_NumCre Number(5);
  
begin  
  
select to_date(To_Char(tpnro), 'DDMMYYYY') into ld_FecRcc from fst098 where tpcod = 7647 and tpcorr =12;
--select to_date('30092016', 'DDMMYYYY') into ld_FecRcc from dual;

  BEGIN
       select nvl(c_codsbs,'') into lc_CodSbs from cldrcci where c_docide=trim(pn_NumDoc) and d_fecpre = ld_FecRcc;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      lc_CodSbs := '';
  END;    
  --Contar las deudas en Dolares
  select count(1) into ln_NumCre from cldrccs a
  where c_codsbs=lc_CodSbs and d_fecpre = ld_FecRcc and substr(c_cuenta,3,1) = 2; 
  
  If ln_NumCre = 0 then
      pc_DeuDol := 'N';
  Else
      pc_DeuDol := 'S';
  End If;

end sp_productos_dolares_RCC;

Procedure sp_registra_flujo( p_n_NumCorr number )is
/*
Registra en el Flujo Express 
Registra en las tablas de Evaluacion (AQPA190a, AQPA190b, AQPA190c)
*/
cursor c1 is
select a.* from aqpa185 a where a.aqpa185flgpro = 'N' and a.aqpa185id=p_n_NumCorr;

cursor c2 is
select * from fst198 b where b.tp1cod1=10801 and b.tp1corr1=51 and b.tp1corr2=3 and b.tp1corr3 > 0;

                             
ln_NumReg Number(9);

ld_fecha  date;

--Producto Fintech
ln_Modulo Number(3);
ln_TipOpe Number(3);
ld_FecPriPag date;
----------------------
--Parametros Fintech--
----------------------
ln_TipSol Number(5);
ln_TipCli Number(5);
ln_CodSuc Number(5);
lc_Asesor varchar(10);
ln_CodCap Number(5);
ln_CodDes Number(5);  --Codigo Destino Credito
ln_Periodo Number(5); --Periodo en dias
-----------------------
ln_Aqpa184dId Number;
ln_DeuTot Number(17,2);
ln_CuoEst Number(17,2);
ln_correl Number;
  
begin  
    --Se obtiene la fecha del sistema   
    select pgfape into ld_fecha from fst017 where pgcod = 1;
        
    --Se obtiene los parametros para la generacion del flujo express
    for i in c2 loop   
        case when i.tp1corr3 = 1 then ln_TipSol := to_number(i.tp1desc); --Tipo Solicitud -- Nuevo 1; Ampliacion 4
             when i.tp1corr3 = 2 then ln_TipCli := to_number(i.tp1desc); --Tipo Cliente -- Nuevo 1; Recurrente 2
             when i.tp1corr3 = 3 then ln_CodSuc := to_number(i.tp1desc); --Agencia Sucursal Desembolso
             when i.tp1corr3 = 4 then lc_Asesor := trim(i.tp1desc); --Asesor del Credito
             when i.tp1corr3 = 5 then ln_CodCap := to_number(i.tp1desc); --Codigo de Captacion
             when i.tp1corr3 = 6 then ln_CodDes := to_number(i.tp1desc); --Codigo de Destino Crédito 
             when i.tp1corr3 = 7 then ln_Periodo := to_number(i.tp1desc); --Periodo del Crédito
        end case;
    end loop;

    for i in c1 loop
      --Obtenemos Modulo y Tipo Operacion
      select c.tp1nro1, c.tp1nro2 into ln_Modulo, ln_TipOpe from fst198 c 
      where c.tp1cod1=10801 and c.tp1corr1=51 and c.tp1corr2=1 and c.tp1corr3=i.aqpa185TipPro;
      --Obtenemos Fecha de Primer Pago
      ld_FecPriPag:= add_months( i.aqpa185FecReg, 1 );
      --------------------------------------NUEVO-------------------------------------
      --Obtenemos el correlativo de la Evaluacion
      
      select SQ_CN_FLUJOEVAL.nextval into ln_correl from dual;
      /*
     select a.TP1NRO1 + 1
      into ln_correl
      from fst198 a
     where a.tp1cod = 1
       and a.tp1cod1 = 10800
       and a.tp1corr1 = 5
       and a.tp1corr2 = 9000
       and a.tp1corr3 = 54;

    update fst198
       set TP1NRO1 = ln_correl
     where tp1cod = 1
       and tp1cod1 = 10800
       and tp1corr1 = 5
       and tp1corr2 = 9000
       and tp1corr3 = 54;
       commit;
       */       
      --------------------------------------END NUEVO-------------------------------------
      
      begin --Registra Evaluacion SNG021    
        insert into aqpa190a 
        (aqpa190aeval, aqpa190apdoc, aqpa190atdoc, aqpa190andoc, 
         aqpa190afec, aqpa190ausu, aqpa190asol, aqpa190atmod)
        values
        (ln_correl, i.aqpa185paidoc, i.aqpa185tipdoc, i.aqpa185numdoc, i.aqpa185fecreg, lc_Asesor, 0, 14);
        commit;
      end;
      begin --Registra Gasto Financiero SNG028                
        select max(c.aqpa184did) into ln_Aqpa184dId from aqpa184d c where c.aqpa184dnumdoc = i.aqpa185numdoc;        
        insert into aqpa190c
        (aqpa190ceval, aqpa190ccod, aqpa190clin, aqpa190cmto1, aqpa190cmto2, aqpa190cmto3, aqpa190cmto4, 
         aqpa190cmda1, aqpa190cmda2, aqpa190cmda3, aqpa190cmda4, aqpa190ctxt1, aqpa190ctxt2, aqpa190ctxt3,
         aqpa190ccon1, aqpa190ccon2, aqpa190ccon3, aqpa190ccan1, aqpa190ccan2, aqpa190ccan3, aqpa190ccan4, 
         aqpa190ctxl1, aqpa190ctxl2, aqpa190ctxl3)         
        select ln_correl, 36, d.aqpa184dcorr, d.aqpa184dsalcap, d.aqpa184dgasfin, 0.00, 0.00, 0, 0, 0, 0,
        substr(d.aqpa184dnomemp, 0,40), '', '', 'Mensual', '', case when substr(d.aqpa184drubro, 3,1) = 1  then 'Soles' else 'Dolares' end,
        0.000, 0.000, 0.000, 0.000, '', '', ''        
        from aqpa184d d where d.aqpa184did = ln_Aqpa184dId;        
        commit; 
      end;
                                  
      begin --Registra Detalle Evaluacion SNG023      
        select nvl(sum(a.aqpa190cmto1),0), nvl(sum(a.aqpa190cmto2),0) into ln_DeuTot, ln_CuoEst
        from aqpa190c a where a.aqpa190ceval = ln_correl;
        
        insert into aqpa190b (aqpa190beval, aqpa190bcod, aqpa190bmto)
        values (ln_correl,  1, i.aqpa185ingdec);
        insert into aqpa190b (aqpa190beval, aqpa190bcod, aqpa190bmto)
        values (ln_correl, 21, i.aqpa185ingdec);
        insert into aqpa190b (aqpa190beval, aqpa190bcod, aqpa190bmto)
        values (ln_correl, 29, i.aqpa185monsol);
        insert into aqpa190b (aqpa190beval, aqpa190bcod, aqpa190bmto)
        values (ln_correl, 27, i.aqpa185ingdec - ln_CuoEst);
        insert into aqpa190b (aqpa190beval, aqpa190bcod, aqpa190bmto)
        values (ln_correl, 24, ln_DeuTot);
        insert into aqpa190b (aqpa190beval, aqpa190bcod, aqpa190bmto)
        values (ln_correl, 25, -ln_DeuTot);
        insert into aqpa190b (aqpa190beval, aqpa190bcod, aqpa190bmto)
        values (ln_correl, 26, i.aqpa185moncuo);
        insert into aqpa190b (aqpa190beval, aqpa190bcod, aqpa190bmto)
        select ln_correl, sng026cod, 0 from sng026 g where g.sng026cod in 
        (/*1,*/ 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
         20, /*21,*/ 22, 23, /*24, 25, 26, 27,*/ 28, /*29,*/ 30, 37, 501, 502, 503, 504, 
         505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 
         519, 520, 521, 522, 524, 526, 527, 529
        );       
        commit;  
      end;        
            
      begin --Registra Solicitud Flujo Express
        select nvl(max(a.jaqm750reg),0) +1 into ln_NumReg  from jaqm750 a 
        where a.jaqm750emp = 1 and a.jaqm750fch=i.aqpa185FecReg and a.jaqm750reg<1000000;
        insert into jaqm750
       (jaqm750emp, jaqm750fch, jaqm750reg, jaqm750pai, jaqm750tdo, jaqm750ndo, jaqm750ins, 
        jaqm750tso, jaqm750tct, jaqm750mod, jaqm750tip, jaqm750suc, jaqm750mda, jaqm750pap, 
        jaqm750cta, jaqm750ase, jaqm750cap, jaqm750dcr, jaqm750fpg, jaqm750imp, jaqm750cuo, 
        jaqm750pdo, jaqm750est)
        values (1, i.aqpa185FecReg, ln_NumReg, i.aqpa185paidoc , i.aqpa185tipdoc, i.aqpa185numdoc, 0, 
        ln_TipSol, ln_TipCli, ln_Modulo, ln_TipOpe, ln_CodSuc, 0, 0, 
        i.aqpa185CtaCli, lc_Asesor, ln_CodCap, ln_CodDes, ld_FecPriPag, i.aqpa185MonSol, i.aqpa185plasol,
        ln_Periodo, 'N'); 
        /*Hlaqui 21/11/2019 - Cambios en el programa PJAQM754*/
        insert into jaqm751
        (JAQM751EMP, JAQM751FCH, JAQM751REG, JAQM751ATT, JAQM751COR, JAQM751VAL)
        values( 1, i.aqpa185FecReg, ln_NumReg, 'SEGCOD', 1,263);        
        commit;       
        
        --Actualizamos el registro a Estado EN PROCESO
        update aqpa185 a
        set a.aqpa185numreg = ln_NumReg, a.aqpa185flgpro = 'P', 
            a.aqpa185fecpro = ld_fecha, a.aqpa185horpro = to_char(sysdate, 'HH24:MI:SS')        
        where a.aqpa185id = p_n_NumCorr;
        commit;
      end;      
      commit;
    end loop;      
    
end sp_registra_flujo;

Procedure sp_actualiza_solicitudes(pd_FecIni in date,
                       pd_FecFin in date
                       )is
/*
**Permite actualizar las solicitudes Fintech con las procesadas en el Flujo Express
*/
ld_fecini   date;
ld_fecfin   date;

cursor c1(FecIni in Date, FecFin in Date) is
select a.*, b.*, case when b.jaqm750est = 'S' then 'A' else 'R' end estado,
       case when b.jaqm750est = 'S' then '' else 'Credito no aprobado en proceso Online' end Motivo
from aqpa185 a 
inner join jaqm750 b
on b.jaqm750emp = 1 and b.jaqm750fch = a.aqpa185fecreg and b.jaqm750reg = a.aqpa185numreg
where a.aqpa185fecreg >= FecIni and a.aqpa185fecreg <= FecFin
and a.aqpa185flgpro = 'P'; --Solo actualizar los que estan en estado "EN PROCESO"
--and a.aqpa185flgpro <> 'R'; --No actualizar los Rechazados por condiciones: Monto > 2000 or Cuotas > 12
/* SOlo considerar
N: No Procesado
S: Procesado
P: En Proceso
*/
  
begin    
  If pd_FecIni IS NULL THEN
       select pgfape into ld_fecini from fst017 where pgcod = 1;               
  else
       ld_fecini := pd_FecIni;
  End If;    
  If pd_FecFin IS NULL THEN
       select pgfape into ld_fecfin from fst017 where pgcod = 1;               
  else
       ld_fecfin := pd_FecFin;
  End If;    
    
  for i in c1(ld_fecini, ld_fecfin) loop
      --lc_Estado:='N'
      --Buscamos el registro en la tabla del Flujo Express
      --select b.jaqm750ins, case when b.jaqm750est = 'S' then 'S' else 'N' end into ln_NumIns, lc_Estado from jaqm750 b
      --where b.jaqm750emp = 1 and b.jaqm750fch = i.aqpa185fecreg and b.jaqm750reg = i.aqpa185numreg;
      
      If i.jaqm750ins > 0 then
        update aqpa185 c
        set --c.aqpa185FlgPro = 'S',
            c.aqpa185FlgPro = i.estado,
            c.aqpa185NumIns = i.jaqm750ins,
            --c.aqpa185EstSol = i.estado,
            c.aqpa185motrec = i.motivo
        where aqpa185id = i.aqpa185id;        
      End If;            
  end loop;
  commit;
end sp_actualiza_solicitudes;
Procedure sp_anular_instancias is
/*
**Permite actualizar las solicitudes Fintech con las procesadas en el Flujo Express
*/

cursor c1 is
select * from jaqm750 where jaqm750est='E';

ln_NumId Number;

begin    
  for i in c1 loop          
    begin
         select wfitemid into ln_NumId from wfwrkitems a where a.wfinsprcid=i.jaqm750ins and a.wfitemstsact=1;
    exception
      when no_data_found then
         ln_NumId:= 0;
    end;
    update wfwrkitems a  set a.wfstscod='B',a.wfitemstsact=0,a.wfitemend='09/11/2017' 
    where a.wfinsprcid= i.jaqm750ins and a.wfitemstsact=1; 
    update wfinstprc b set b.wfinsprcsta='B',b.wfinsprcosta=0, b.WFInsPrcEnd =  '09/11/2017' where b.wfinsprcid=i.jaqm750ins;
    delete from wfworklist c where c.wfwrklstitemid=ln_NumId;
    commit;
  end loop;
end sp_anular_instancias;

Procedure sp_registra_panel_saldo(pn_NroIns in number
                       )is
ld_Fecha Date;
ln_jaqy327corr numeric(10);
ln_NroEva sng021.sng021eval%type;
ln_IdAqpa184 numeric(10);
 l_pdoc sng021.sng021pdoc%type;
 l_tdoc sng021.sng021tdoc%type;
 l_ndoc sng021.sng021ndoc%type;
  
begin    
    select pgfape into  ld_Fecha from fst017 where pgcod=1;
    select nvl(max(JAQY327CORR),1) into ln_jaqy327corr from JAQY327 Where JAQY327FECH = ld_Fecha;
        
    select c.sng021eval, c.sng021pdoc, c.sng021tdoc, c.sng021ndoc
    into ln_NroEva, l_pdoc, l_tdoc, l_ndoc     
    from sng021 c
    where c.sng021sol = pn_NroIns; 
    
    select max(aqpa184ID) into ln_IdAqpa184 from aqpa184 y where y.aqpa184paidoc=l_pdoc 
    and y.aqpa184tipdoc=l_tdoc and y.aqpa184numdoc=l_ndoc;
                
    update JAQY327 
    set JAQY327ESTA = 'N'
    where JAQY327INST = pn_NroIns and JAQY327ESTA='S';    
                       
    insert into JAQZ862
    (JAQZ862CORR, JAQZ862FECH, JAQZ862HORA, JAQZ862INST, JAQZ862NEVA, JAQZ862PAIS, JAQZ862TDOC,
     JAQZ862NDOC, JAQZ862RUBR, JAQZ862ESTA, JAQZ862ENTI, JAQZ862TCRE, JAQZ862SDEU, JAQZ862PLAZ,
     JAQZ862TAZA, JAQZ862CCALC, JAQZ862GFIN, JAQZ862FRCC, JAQZ862DORI, JAQZ862CHEK, JAQZ862AUX5)
    
    select rownum + ln_jaqy327corr, ld_Fecha, to_char( CURRENT_TIMESTAMP, 'HH24:MI:SS' ), pn_NroIns, ln_NroEva, b.aqpa184paidoc, b.aqpa184tipdoc, 
    b.aqpa184numdoc, c.aqpa184drubro, 'S', c.aqpa184dnomemp, c.aqpa184dtipcre, c.aqpa184dsalcap, 0, 
    0, c.aqpa184dgasfin, c.aqpa184dgasfin, c.aqpa184dfecrcc, 1, 1, b.aqpa184usureg
    from aqpa184 b 
    inner join aqpa184d c on b.aqpa184id = c.aqpa184did
    where b.aqpa184id = ln_IdAqpa184;        
    
end sp_registra_panel_saldo;

Procedure sp_migracion_personas_fintech (p_n_NumCorr number) is
  cursor c1 is
  select * from aqpa185 a where a.aqpa185flgcli = 0 and a.aqpa185id=p_n_NumCorr ;
  
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_indexi number := 0;
  ld_fecha         date;
  ln_nroerr number := 0;
  
  ln_ActEco number ;
  ln_TipAct number ;
  
  begin
      --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;        

      --Se eliminan los registros de las bandejas.
      begin
        DELETE FROM bandejas.bjd001;
        DELETE FROM bandejas.bjd002;
        DELETE FROM bandejas.bjd003;
        DELETE FROM bandejas.bjd004;
        DELETE FROM bandejas.bjr001;
        DELETE FROM bandejas.bjr002;
        DELETE FROM bandejas.bjr003;
        DELETE FROM bandejas.bjr004;
        DELETE FROM bandejas.bjx001;    
        DELETE FROM bandejas.bjd201;    
        DELETE FROM bandejas.bngc60;          
        DELETE FROM bandejas.bnjti1;        
        DELETE FROM bandejas.bnjti2;        
        DELETE FROM bandejas.bje101;        
        DELETE FROM bandejas.bje102;  

        DELETE FROM bandejas.bjd005;
        DELETE FROM bandejas.bjr005;
        DELETE FROM bandejas.bngc13;
        DELETE FROM bandejas.bngc11;   
        
        DELETE FROM bandejas.BJX001;
        
        commit;
      exception
        when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BANDEJAS', 'DELETE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
      End;

      --Se recorre la tabla JAQZ311 cuto estado sea 0         
      for i in c1 loop   
      --Se validan cada persona antes de registrar en bandejas.     
      ln_indexi:= pq_dinero_electronico.fn_valida_persona(p_n_pais   => 604,
                                                              p_n_tipo   => 21,
                                                              p_c_numero => i.aqpa185numdoc                  
                                                  );                                                                                                                                        
      --ln_indexi := 0;                                                                                                    
      If ln_indexi = 0 then                                                            
        ln_cuenta := ln_cuenta + 1;      

        begin --BJD001
          insert into BJD001
            (BD001Pais,--1
             BD001Tdoc,
             BD001Ndoc,
             BD001Tipo,
             BD001Nom,--5
             BD001Falt,
             BD001Exent,
             BD001ResIn,
             BD001ResNo,
             BD001NoRes,--10
             BD001ConsF,
             BD001BceAj,
             BD001IngBr,
             BD001ImpIn,
             BD001NroBr,--15
             BD001NroIn,
             BD001Rg312,
             BD001Rg333,
             BD001Rg278,
             BD001InstF,--20
             BD001Pesn0,
             BE001SCnd,
             BE001SJur,
             BE001GCnd,
             BE001Prov,--25
             BE001TAlt,
             BE001ICod,
             BE001OCod,
             BE001DstCo,
             BD001Est,
             BD001VTORGNAC               
             )--30
          values
            (604,--1
             21,
             substr(i.aqpa185numdoc,1,12),
             'F',
             upper(substr(i.aqpa185priape || ' ' || i.aqpa185segape || ', '|| i.aqpa185prinom || ' ' || i.aqpa185segnom,1,30)),--5
             ld_fecha,
             null,
             null,
             null,
             null,--10
             null,
             null,
             null,
             null,
             0,--15
             i.aqpa185ingdec, --HLAQUI 09/08/2018 ---------------------
             null,
             null,
             null,
             'N', --20
             'N',
             null,
             null,
             null,
             null,--25
             1,--Normal
             null,
             i.aqpa185numdep,
             14,
             'P',               
             null
             );                            
          
        exception
          when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BANDEJAS', 'DELETE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
        end;
          
        begin --BNJTI1
          insert into  bandejas.bnjti1 (
                                BT1PAIS,
                                BT1TDOC,
                                BT1NDOC,
                                BT1IMPC,
                                BT1CORR,
                                BT1BAND,
                                BT1COND,
                                BT1EST
                               ) 
                         values(604,--1
                                21,
                                substr(i.aqpa185numdoc,1,12),
                                9,
                                1,
                                150,
                                1,
                                'P'
                                );

          insert into  bandejas.bnjti1 (
                                BT1PAIS,
                                BT1TDOC,
                                BT1NDOC,
                                BT1IMPC,
                                BT1CORR,
                                BT1BAND,
                                BT1COND,
                                BT1EST 
                               )
                         values(604,--1
                                21,
                                substr(i.aqpa185numdoc,1,12),
                                9,
                                2,
                                150,
                                1,
                                'P'
                                );
                                  
          insert into  bandejas.bnjti1 (
                                BT1PAIS,
                                BT1TDOC,
                                BT1NDOC,
                                BT1IMPC,
                                BT1CORR,
                                BT1BAND,
                                BT1COND,
                                BT1EST 
                               )
                         values(604,--1
                                21,
                                substr(i.aqpa185numdoc,1,12),
                                9,
                                6,
                                150,
                                1,
                                'P'
                                );      

        exception
          when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BANDEJAS', 'DELETE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
        end;
          
        begin --BJD002
        insert  /*+append*/ into BANDEJAS.BJD002
                  (BD002Pais,
                   BD002Tdoc,
                   BD002Ndoc,
                   BD002Ape1,
                   BD002Ape2,
                   BD002Nom1,
                   BD002Nom2,
                   BD002Ebco,
                   BD002Fibc,
                   BD002Cant,
                   BD002Fnac,
                   BD002Eciv,
                   BD002Pnac,
                   BD002Lnac,
                   BD002Cleg,
                   BE002HobC,
                   BE002Club,
                   BE002NIns,
                   BE002PCod,
                   BE002PDde,
                   BE002OCod,
                   BE002VCod,
                   BE002Empr,
                   BE002CHij,
                   BE002PaiX,
                   BE002FIni,
                   BE002TVnd,
                   BE002TRes,
                   BE002NArr,
                   BE002TArr,
                   BE002DAn1,
                   BE002DAn2,
                   BE002TAnt,
                   BE002PAnt,
                   BE002AntT,
                   BE002CAnt,
                   BE002AInd,
                   BE002Fing,
                   BE002EAct,
                   BE002CAct,
                   BE002DAc1,
                   BE002DAc2,
                   BE002TAct,
                   BE002IngM,
                   BE002IngS,
                   BE002IngO,
                   BE002IngR,
                   BE002SalC,
                   BE002OtrC,
                   BE002RefC,
                   BE002IEgr,
                   BE002Hipo,
                   BE002SHip,
                   BE002CHip,
                   BE002STar,
                   BE002CTar,
                   BE002SPre,
                   BE002CPre,
                   BE002GAlq,
                   BE002GFam,
                   BE002GOtr,
                   BE002GRef,
                   BE002TInm,
                   BE002TVeh,
                   BE002TAcO,
                   BE002OAcR,
                   BE002PrdAp,
                   BE002PrdNo,
                   BE002MrdAp,
                   BE002MrdNo,
                   BE002ConAp,
                   BE002ConNo,
                   BE002ConOc,
                   BE002AxC1,
                   BE002FFal,
                   BD002Est)
                values
                  (604,
                   21,
                   substr(i.aqpa185numdoc,1,12),
                   upper(substr(i.aqpa185priape,1,30)),
                   upper(substr(i.aqpa185segape,1,30)),
                   upper(substr(i.aqpa185prinom,1,25)),
                   upper(substr(i.aqpa185segnom,1,25)),
                   'N',
                   null,
                   i.aqpa185sexo,
                   i.aqpa185fecnac,
                   i.aqpa185estciv, --09/08/2018 HLAQUI
                   604,--i.pais, se cambio yessenia 2013.06.07
                   substr(i.aqpa185lugnac,1,20), --No se ingresa 'Lugar de Nacimiento'
                   'S',
                   99, --Correspondiente a OTROS en tabla FST108
                   999, --Usar el codigo 999 correspondiente a "NO DEFINIDO" (FST109)
                   i.aqpa185nivedu, --Nivel Educativo (FST114)
                   905, --Profesion - Sin profesion --09/08/2018 HLAQUI - OTROS
                   null,
                   1, --Ocupacion - Empleado --09/08/2018 HLAQUI - 
                   null,--ln_vicod,
                   null,
                   null, --  ****aqui deben de ir los hijos ****
                   604,
                   null, --Fecha inicio
                   null,
                   0,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   0, --Es el monto del Alquiler, si es Arrendado
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null, -- Apellido del padre
                   null, -- Nombre del padre
                   null, -- Apellido de la madre
                   null, -- Nombre de la madre
                   null,
                   null,
                   null,
                   null,
                   null,
                   'P');                                        
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BJD002', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));            
        end;
        
        begin --BJD005        
         insert into BANDEJAS.BJD005
                    (BD005Pais,
                     BD005TDoc,
                     BD005NDoc,
                     BD005DCod,
                     BD005Call,
                     BD005Nro,
                     BD005Apar,
                     BD005Ciud,
                     BD005PaiD,
                     BD005CPos,
                     BD005CCor,
                     BD005CDep,
                     BD005Ciudp,
                     BD005Axn1,
                     BD005Deptp,
                     BD005Est,
                     BD005Ref1,
                     BD005Ref2,
                     BD005APo,
                     BD005Upo
                     )
                  values
                    (604,
                     21,
                     i.aqpa185numdoc,
                     1,--tipo de direccion 1 legal 3 es negocio analizar si se va a llenar los 2??
                     null,
                     null,
                     null,
                     null,
                     604,
                     null,
                     null,
                     to_number(substr(lpad(i.aqpa185ubidom,6,'0'),1,2)),  --i.jaqz311dirdep,
                     substr(lpad(i.aqpa185ubidom,6,'0'),1,4), --i.jaqz311dirpro,
                     to_number(i.aqpa185ubidom), --i.jaqz311dirdis,
                     null,
                     'P',
                     null,
                     null,
                     null,
                     null);                
            
          exception
            when others then             
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJD005', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
          end;
        /*09/08/2018 HLAQUI - Grabar Direccion*/
          begin --BNGC13
            insert into BANDEJAS.BNGC13
            (BNGC13PAIS, --1
             BNGC13TDOC, --2
             BNGC13NDOC, --3
             DOCOD,       --4 
             BNGC13CORR, --5
             BNGC13PDOC, --6
             BNGC12VIVC, --7
             BNGC01ID, --8
             BNGC02ID, --9
             BNGC03ID, --10
             BNGC04ID, --11
             BNGC05ID, --12
             BNGC06ID, --13
             BNGC13DSC1, --14
             BNGC13DSC2, --15
             BNGC13DSC3, --16
             BNGC13DSC4, --17
             BNGC13DSC5, --18
             BNGC13DSC6, --19
             BNGC13UGEO, --20
             BNGC13DPTO, --21
             BNGC13PROV, --22
             BNGC13DIST, --23
             BNGC13CNEG, --24
             BNGC13REF, --25
             BNGC13REF1, --26
             BNGC13DIR, --27
             BNGC13RDES, --28
             BNGC13ARR, --29
             BNGC13ATEL,--30
             BNGC13FHAB,--31
             BNGC13DEST,--32
             BNGC13EST,--33
             BNGC13FDIR,--34
             BNGC13USER,--35
             BNGC13MEST)--36
          values
            (604, --1
             21, --2
             i.aqpa185numdoc,  --3
             1,  --4
             1, --5
             604,-- pais de direccion6
             null, -- codigo tipo de vivienda 7
             i.aqpa185nivel1, --19, -- codigo tipo de via   8
             i.aqpa185nivel2, -- codigo via          9        
             i.aqpa185nivel3, -- codigo detalle de via10
             i.aqpa185nivel4,--0,11
             i.aqpa185nivel5,--0,12
             i.aqpa185nivel6,--0,  13             
             i.aqpa185nivdet1, --substr(i.aqpa185dirdom,1,30), -- descripcion de via  14
             i.aqpa185nivdet2, --15
             i.aqpa185nivdet3, --16
             i.aqpa185nivdet4, --17
             i.aqpa185nivdet5, --18
             i.aqpa185nivdet6, --19
             lpad(trim(i.aqpa185ubidom),6,'0'), --20 - Ubigeo             
             to_number(substr(lpad(i.aqpa185ubidom,6,'0'),1,2)), --i.jaqz311dirdep, --21  - Departamento
             to_number(substr(lpad(i.aqpa185ubidom,6,'0'),1,4)),  --i.jaqz311dirpro, --22  - Provincia
             to_number(i.aqpa185ubidom), --i.jaqz311dirdis, --23  - Distrito
             null, --24
             null, --25
             substr(' / ' || i.aqpa185dirdom,1,200), -- referencia26
             substr(i.aqpa185dirdom,1,140),--null, --27
             ld_fecha,--null, --28
             null, --29
             null, --30
             null, --31
             2, --32
             'H', --33
             null, --34
             null, --35
             'P'); --36
          exception
            when others then
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BNGC13', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
          end;                           
        
        /*Hlaqui 09/08/2018 - Se agrega Logica para la actividad y Tipo de Actividad - EMPLEADO*/        
        begin
             select actcod1, actcod3 into ln_ActEco, ln_TipAct from fst750 where actcod1 = i.Aqpa185ActEco;
        exception
          WHEN NO_DATA_FOUND THEN
            ln_ActEco := 999900;
            ln_TipAct := 4;
        end;
                
                     
        begin --BNGC60
            insert into bandejas.BNGC60
            (BNGC60PAIS,
             BNGC60TDOC,
             BNGC60NDOC,
             BNGC60CORR,
             BNGC60VCOD,
             BNGC60OCUP,
             BNGC60RUTE,
             BNGC60RZSO,
             BNGC60RUTP,
             BNGC60ERUT,
             BNGC60FINE,
             BNGC60FINI,
             BNGC60NOME,
             BNGC60UBIC,
             BNGC60TIPA,
             BNGC60ACTE,
             BNGC60EST)
          values
            (604,
             21,
             i.aqpa185numdoc,
             0, --Correlativo 0 Indica Actividad Laboral Principal
             82, --i."Vcod",--null, Cargo - No Corresponde
             1, --i."Ocud",--Empleado
             i.aqpa185rucemp, --i."RuTe", --09/08/2018
             substr(i.aqpa185razsoc,1,50), --i."RzSo",
             null, --i."RuTp",
             null, --i."ErUt",
             i.aqpa185fecing, --i."Fine", --09/08/2018
             null, --i."Fini",
             null, --i."Nome",
             null, --i."Ubic",
             ln_TipAct, --12,--ln_actcod3, Tipo Actividad
             ln_ActEco, --99,--ln_actcod1, Actividad Economica
             'P');
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BNGC60', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
        end;                 
                               
        /*Hlaqui 22/05/2017: Se agrega logica para el Lugar de Nacimiento*/
        begin --BNGC11
               insert into bandejas.BNGC11
              (BNGC11PAIS,
               BNGC11TDOC,
               BNGC11NDOC,
               BNGC11COND,
               BNGC11NREG,
               BNGC11EST,
               BNGC11ACAS,
               BNGC11DPTO,
               BNGC11PROV,
               BNGC11DIST,
               BNGC11UGEO,
               BNGC11NEST,
               BNGC11CONP,
               BNGC11COTD,
               BNGC11CO1N,
               BNGC11AUX,     ----BUSCAR DE DONDE SE JALA CAMPO SIGLAS DE JURIDICAS
               BNGC11CAPS,
               BNGC11TPA2,
               BNGC11ACT2,
               BNGC11TXT1, -- sujeto obligado
               BNGC11TXT2,
               BNGC11CMB1,
               BNGC11CMB2,
               BNGC11DAT1,
               BNGC11DAT2,
               BNGC11NUM1,-- actividad sujeto obligado
               BNGC11NUM2
               )
            values
              (604,
               21,
               i.aqpa185numdoc,
               null,
               null,
               'P',
               null,
               i.aqpa185depnac,
               i.aqpa185pronac,
               i.aqpa185disnac,                      
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               'N',
               null,
               null,
               null,
               null,
               null,
               null,
               null                       
               );
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BNGC11', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
        end;
        /*Hlaqui 22/05/2017: Fin*/

        /*CORREO*/
        begin --BJX001
          insert /*+ append */ 
           into BANDEJAS.BJX001
           ( BX001Pais,
             BX001TDoc,
             BX001NDoc,
             BX001XCod,
             BX001XRen,
             BX001XTxt,
             BX001XUsu,
             BX001XFch,
             BX001Est)
          values
            (604,
             21,
             i.aqpa185numdoc,
             0,
             1,
             upper(substr(i.aqpa185correo,1,65)) || '\',
             null, --i."Usu",
             null, --i."Fch",
             'P');
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BJX001', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
        end;
       
        /*TELEFONO*/
        begin --BJR005
          insert /*+ append */ 
           into BANDEJAS.BJR005
            (BR005Pais,
             BR005TDoc,
             BR005NDoc,
             BR005DCod,
             BR005DOrd,
             BR005Telf,
             BR005Tlex,
             BR005Fax,
             BR005Est
             )
          values
            (604,
             21,
             i.aqpa185numdoc,
             1,--tipo de direccion 1 legal 3 es negocio analizar si se va a llenar los 2??
             1,
             substr(i.aqpa185numcel,1,20),
             null,
             null,
             'P'
             );
        exception
          when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BJX001', i.aqpa185numdoc, lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
        end;
        /*
        begin --AQPA185
              update aqpa185 a
              set a.aqpa185flgcli = 1
              Where a.aqpa185id = i.aqpa185id                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ;
        exception
          when others then            
            select nvl(max(JAQZ311aNro),0) + 1 into ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'AQPA185', i.aqpa185numdoc, lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                 
        end;
        */
      End If;          
      End Loop;  
      commit; 
      
      -- Generamos el registro de las personas en BANTOTAL
      begin
        bandejas.mig_personas_datos(1000);
        bandejas.mig_personas_domicilios(1000);
      end;   
      
end sp_migracion_personas_fintech;
  
Procedure sp_migracion_cuentas_fintech (p_n_NumCorr number) is
  cursor c1 is
  select a.aqpa185numdoc, b.*, d.segcod,  e.* from aqpa185 a
  left outer join FSD002 b on b.pfpais=604 and b.pftdoc=21 and rpad(trim(a.aqpa185numdoc),12,' ') = b.pfndoc
  left outer join FSE002 c on b.pfpais = c.pfxpais and b.pftdoc = c.pfxtdoc and  b.pfndoc = c.pfxndoc
  left outer join SNGC07 d on d.SNGC07cod = c.ocucod
  left outer join sngc13 e on e.sngc13pais=604 and e.sngc13tdoc=b.pftdoc and e.sngc13ndoc= b.pfndoc  and e.docod= 1 and e.sngc13est='H' and e.sngc13pais <>0  
  where a.aqpa185flgcta = 0 and a.aqpa185id=p_n_NumCorr;
    
  cursor c2(cp_numdoc in varchar2) is
  select * from sngc13 b 
  where b.sngc13pais=604 and b.sngc13tdoc=21 and sngc13ndoc=rpad(trim(cp_numdoc),12,' ') and b.sngc13est='H' and b.sngc13pais <>0;  
   
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ld_fecha         date;
  ln_nroerr number := 0;
  lc_nomcli  varchar2(400);

begin
   --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;        

      --Se eliminan los registros de las bandejas.
      begin        
        
        DELETE FROM bandejas.bjd008;
        DELETE FROM bandejas.bjr008;
        DELETE FROM bandejas.bjx008;      
        DELETE FROM bandejas.bje108; 

        DELETE FROM bandejas.bjd006;
        DELETE FROM bandejas.bjr006;
        DELETE FROM bandejas.bngc13;
        
        commit;
      exception
        when others then
          select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
          lc_error := sqlerrm;
          insert into jaqz311a
            (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
          values
            (ln_nroerr, 'BANDEJAS-CUENTAS', 'DELETE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
      End;
      --Se obtiene el Nro de Cuenta - El siguiente Valor
       begin --BNJTI1
          select ngnum + 1 into ln_cuenta 
          from fsn999 
          where pgcod=1 and ngsuc=11 and ngtipo=3;
            
          update fsn999
          set ngnum = ngnum + 1
          where pgcod=1 and ngsuc=11 and ngtipo=3;
         
        exception
          when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'CORRELATIVO CUENTA', 'UPDATE', lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));
        end;
        
      --Se recorre la tabla JAQZ311 cuto estado sea 0         
      for i in c1 loop         
        If i.pfape1 is null then
           lc_nomcli := trim(i.pfnom1);
        Else
           lc_nomcli := trim(i.pfape1) || ' ' || trim(i.pfape2) || ', ' || trim(i.pfnom1) || ' ' || trim(i.pfnom2);
        End if;
            
                                                                                       
          begin --BJD008
           insert /*+ append */ into bandejas.BJD008
            (BD008ECod,
             BD008NCta,
             BD008CNom,
             BD008Resi,
             BD008CCla, 
             BD008FAlt,
             BD008RCor,
             BD008SCod,
             BD008IFin,
             BD008Empl,
             BD008Prov,
             BD008SegM,
             BE008Suc,
             BE008FvClf,
             BD008Est,
             BD008Ctnro)
          values
            (1,
             ln_cuenta,           
             substr(lc_nomcli,1,35),
             'N',
             1, --no es obligatorio, y es un GAP
             ld_fecha,
             'S',
             1,
             'N',
             'N',
             'N',
             nvl(i.segcod, 3),--Se obtiene el segmento, si no se coloca el segmento Otros
             11, --Agencia Principal
             ADD_MONTHS(ld_fecha, 120),--DLYA asigna en programa de carga una fecha valida.
             'P',
             99
             );                          
            
          exception          
             when others then
              select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'BJD008', i.aqpa185numdoc, lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                               
          end;
                          
          begin --BJD006
            insert /*+ append */ into bandejas.BJD006
              (BD006ECod,
               BD006NCta,
               BD006DCod,
               BD006Call,
               BD006Nro,
               BD006Apar,
               BD006Ciud, -- codigo de localidad
               BD006Pais,
               BD006CPos,
               BD006CCor,
               BD006Sucu,
               BD006CDep, -- coidgo de departamento
               BD006Dept,
               BD006Est,
               BD006Ref1,
               BD006Ref2,
               BD006APo,
               BD006Upo)
            values
              (1,
               ln_cuenta,
               1, --Tipo de domicilio: LEGAL
               '',
               '',
               '',
               i.sngc13prov, --lc_desdis,
               604,
               null,
               null,
               null,
               i.sngc13dpto,
               null,
               'P',
               substr(i.sngc13dir,1,35),
               null,
               null,
               null);
               
          exception
            when others then
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJD006', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));            
          end;

          /*Hlaqui 18/08/2017 - Se agrega Logica para la direccion del cliente*/            
          --Se obtienen los datos de la SNGC13 para el registro de la direccion.
          for p in c2(i.aqpa185numdoc) loop         
               begin --BNGC13                
                insert into BANDEJAS.BNGC13
                (BNGC13PAIS, --1
                 BNGC13TDOC, --2
                 BNGC13NDOC, --3
                 DOCOD,       --4 
                 BNGC13CORR, --5
                 BNGC13PDOC, --6
                 BNGC12VIVC, --7
                 BNGC01ID, --8
                 BNGC02ID, --9
                 BNGC03ID, --10
                 BNGC04ID, --11
                 BNGC05ID, --12
                 BNGC06ID, --13
                 BNGC13DSC1, --14
                 BNGC13DSC2, --15
                 BNGC13DSC3, --16
                 BNGC13DSC4, --17
                 BNGC13DSC5, --18
                 BNGC13DSC6, --19
                 BNGC13UGEO, --20
                 BNGC13DPTO, --21
                 BNGC13PROV, --22
                 BNGC13DIST, --23
                 BNGC13CNEG, --24
                 BNGC13REF, --25
                 BNGC13REF1, --26
                 BNGC13DIR, --27
                 BNGC13RDES, --28
                 BNGC13ARR, --29
                 BNGC13ATEL,--30
                 BNGC13FHAB,--31
                 BNGC13DEST,--32
                 BNGC13EST,--33
                 BNGC13FDIR,--34
                 BNGC13USER,--35
                 BNGC13MEST)--36
              values
                (0, --1
                 0, --2
                 ln_cuenta,  --3
                 p.docod,  --4
                 p.sngc13corr, --5
                 p.sngc13pdoc, -- pais de direccion6
                 p.sngc12vivc, -- codigo tipo de vivienda 7
                 p.sngc01id, -- codigo tipo de via   8
                 p.sngc02id, -- codigo via          9        
                 p.sngc03id, -- codigo detalle de via10
                 p.sngc04id,--0,11
                 p.sngc05id,--0,12
                 p.sngc06id,--0,  13             
                 substr(p.sngc13dsc1,1,30), -- descripcion de via  14
                 substr(p.sngc13dsc2,1,30), --15
                 substr(p.sngc13dsc3,1,30), --16
                 substr(p.sngc13dsc4,1,30), --17
                 substr(p.sngc13dsc5,1,30), --18
                 substr(p.sngc13dsc6,1,30), --19
                 p.sngc13ugeo, --20 - Ubigeo
                 p.sngc13dpto, --21  - Departamento
                 p.sngc13prov, --22  - Provincia
                 p.sngc13dist, --23  - Distrito
                 p.sngc13cneg, --24
                 p.sngc13ref, --25
                 p.sngc13ref1, -- referencia26
                 p.sngc13dir,--null, --27
                 p.sngc13rdes ,--null, --28
                 null, --29
                 null, --30
                 null, --31
                 p.sngc13dest, --32
                 p.sngc13est, --33
                 null, --34
                 null, --35
                 'P'--36
                 ); 
              exception
                when others then
                select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
                lc_error := sqlerrm;
                insert into jaqz311a
                  (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
                values
                  (ln_nroerr, 'BNGC13', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
              end;  

           end loop;

          
          begin --BJE108
             insert into bandejas.BJE108
              (BE108Cod,
               BE108Cta,
               BE108Fch,
               BE108Hora,
               BE108Usu,
               BE108Wrk,
               BE108Hab,
               BE108Est)
             values
              (1,
               ln_cuenta,
               ld_fecha,--to_date(to_char(i."Fch",'dd/mm/rrrr'),'dd/mm/rrrr'),
               TO_CHAR(sysdate, 'HH:MI:SS'),--to_char(i."Hora",'hh24:mi:ss'),
               'BANTOTAL',
               null,
               'S',
               'P'); 
          exception
            when others then
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJE108', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
          end;
          
          begin --BJR008
              insert into bandejas.BJR008
                (BR008ECod,
                 BR008NCta,
                 BR008Pais,
                 BR008TDoc,
                 BR008NDoc,
                 BR008TCod,
                 BR008TFir,
                 BR008Est)
              values
                (1,
                 ln_cuenta,
                 604,
                 21,
                 i.aqpa185numdoc,
                 1,--1,
                 'T',
                 'P'); 
          exception
            when others then
            select nvl(max(JAQZ311aNro),0) + 1 into  ln_nroerr from jaqz311a;
            lc_error := sqlerrm;
            insert into jaqz311a
              (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
            values
              (ln_nroerr, 'BJR008', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                        
          end;
          /*          
          begin --JAQZ311
                update jaqz311 a
                set a.jaqz311fgcta = 1
                Where a.jaqz311numdoc = i.aqpa185numdoc;
          exception
            when others then            
              select nvl(max(JAQZ311aNro),0) + 1 into ln_nroerr from jaqz311a;
              lc_error := sqlerrm;
              insert into jaqz311a
                (JAQZ311ANRO, JAQZ311AOBJ, JAQZ311ADOC, JAQZ311ADES, JAQZ311AFEC, JAQZ311AHOR)
              values
                (ln_nroerr, 'JAQZ311', i.aqpa185numdoc , lc_error, sysdate, TO_CHAR(sysdate, 'HH:MI:SS'));                 
          end;        
          */                              
      End Loop;  
        
      commit; 
      
      -- Generamos el registro de las cuentas en BANTOTAL
      begin
        bandejas.mig_cuentas_datos(1000);
        bandejas.mig_cuentas_domicilios(1000);
      end;   
      
end sp_migracion_cuentas_fintech;

end pq_cn_fintech;
/

