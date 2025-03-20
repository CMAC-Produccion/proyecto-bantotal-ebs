create or replace package pq_cr_conecta is
Procedure sp_job_mov_aho (pd_fecini in varchar2, pd_fecfin in varchar2 ) ;
Procedure sp_mov_aho (/*pn_numsuc in number,*/ pd_fecini in varchar2/*,pd_fecfin in varchar2*/  ) ;
function fn_suc_atm (pn_atm in number) return number;
function fn_suc_comercio (pn_comercio in number) return number;
function fn_plaza (pn_suc in number) return number;
function fn_plaza_des (pn_suc in number) return varchar2;
function fn_cod_come (pn_cod in number, pn_mod in number, pn_tra in number, 
                       pn_suc in number, pn_rel in number, pd_fec in date) return number;
function fn_tipo_cambio_fijo(P_FECHA in date) return number;
end pq_cr_conecta;
/

create or replace package body pq_cr_conecta is
Procedure sp_job_mov_aho (pd_fecini in varchar2, pd_fecfin in varchar2 ) is

  
  ln_ini number;
  i      number;
  lc_variable varchar2(1000);
  lc_fecha varchar2(20);
  ln_job number:=0;
  lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  cursor fecha is 
  select to_char(ffecha,'yyyymmdd') fecha from fst028 
   where calcod = 1 
     and ffecha between to_date(pd_fecini,'yyyymmdd') and to_date(pd_fecfin,'yyyymmdd');

  
  begin 
     execute immediate ('truncate table jaql118');
     --commit;
     delete Tab_jobs where  c_Codage = 'MOVI';
     commit;
     for i in fecha loop    
        --ln_ini := i.sucurs;
        lc_fecha := i.fecha;
        --lc_variable := ' begin '|| '  pq_cr_conecta.sp_contab_datos('||ln_ini||','||''''||Pd_FECini||'''' ||','||''''||Pd_FECfin||'''' ||');'|| ' End; ';
        lc_variable := ' begin '|| '  pq_cr_conecta.sp_mov_aho('||''''||lc_fecha||''''||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      --instance => 2,
                      force => false
                      );
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('MOVI',to_number(lc_fecha),lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'MOVI',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
  Procedure sp_mov_aho (/*pn_numsuc in number,*/ pd_fecini in varchar2/*,pd_fecfin in varchar2*/  ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
ln_tipcam number; 
/*cursor rubro is
select rubro  
 from BANTPROD.fsd014 
where pcimpu = 'S'
  and pmtit in (4,5);*/

/*cursor fecha is 
select ffecha from bantprod.fst028 
 where calcod = 1 
   and ffecha between to_date(pd_fecini,'yyyymmdd') and to_date(pd_fecfin,'yyyymmdd');
  
*/
cursor agencia is 
select sucurs from fst001 where pgcod =1;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = to_number(pd_fecini)
     and g.c_codage = 'MOVI';
  commit;
  ld_fecpro := to_date(pd_fecini,'yyyymmdd');
  ln_tipcam := pq_cr_conecta.fn_tipo_cambio_fijo (ld_fecpro);
  
  --for i in agencia loop
    --for j in fecha loop
     begin 
     
       insert /*+ APPEND */ into jaql118  (PRODUCTO,SUB_PRODUCTO,
                                               NRO_CUENTA,COD_CUENTA_CLIENTE,OPERACION, SUB_OPERACION,DNI_RUC,NOMBRE,
                                               COD_SUCURSAL,SUCURSAL,COD_PLAZA_PROD,PLAZA_PROD,MONEDA_CUENTA,DES_MONEDA,
                                               FECHA_MOVIMIENTO,COD_MOVIMIENTO,DES_MOVIMIENTO,NRO_MOVIMIENTO,COD_CONCEPTO,CONCEPTO,
                                               COD_MONEDA_TRANSACCION,MONEDA_TRANSACCION,MONTO_MOV,COD_AGE_MOV,COD_PLAZA_MOV,
                                               PLAZA_MOV,ATM)    
       select distinct a.hmodul Producto,
       --c.mdnom Des_Producto,
       HTOPER sub_producto,
       --b.tonom Des_Sub_prod,
       (case when a.hmodul in (21,440) then 
             21 || '-' || a.HMDA || '-' || a.HCTA || '-' || a.HOPER || '-' ||
             a.HSUBOP || '-' || a.htoper
            when a.hmodul in (22,426) then 
             22 || '-' || a.HMDA || '-' || a.HCTA || '-' || a.HOPER
            end) Nro_cuenta,
       HCTA Cod_Cuenta_Cliente,
       hoper Operacion,
       a.hsubop Sub_Operacion,
       d.pendoc DNI_RUC,
       e.penom Nombre,
       --Case When e.petipo = 'F' then 'Natutal' else 'Juridica' end Tipo_persona,
       a.hsucur Cod_Sucursal,
       f.scnom Sucursal,
       pq_cr_conecta.fn_plaza(a.hsucur) cod_plaza_prod,
       pq_cr_conecta.fn_plaza_des(a.hsucur)  Plaza_prod,
       a.hmda Moneda_Cuenta,
       Case when a.hmda = 0 thEn 'SOLES'
             when a.hmda = 101 thEn 'DOLARES'
             else 'OTROS' end Des_Moneda,
       a.hfcon FEcha_Movimiento,
       a.hcmod ||'-'||a.htran Cod_Movimiento,
       g.trnom Des_Movimiento,
       a.hcmod ||'-'||a.htran ||'-'||a.hsucor||'-'||to_char(h.hfvc,'yyyymmdd') ||'-'||a.hnrel Nro_movimiento,
       a.hcmcod Cod_Concepto, 
       i.cmnom Concepto,
       Case when a.hmda = 101 and a.hcmd = 'D' then 0 
            when a.hmda = 0 and a.hcmd = 'M' then 101
            else a.hmda end Cod_moneda_transaccion,
       Case when a.hmda = 101 and a.hcmd = 'D' then 'SOLES'
            when a.hmda = 0 and a.hcmd = 'M' then 'DOLARES'
            else decode(a.hmda,0,'SOLES','DOLARES')  end moneda_transaccion,
       Case when a.HMDA = 0 and a.hcmd = 'M' and a.hctcbi <> 0 then  a.hcimp1 * a.hctcbi 
            when a.HMDA = 0 and a.hcmd = 'M' and a.hctcbi = 0 then  a.hcimp1 * ln_tipcam
            else a.hcimp1 end  Monto_Mov,
       h.hsucor cod_age_mov,
----   
       case when h.hsucor in (902,903, 904) and ATM.JAQY254NOTER is not null then
            pq_cr_conecta.fn_plaza(pq_cr_conecta.fn_suc_atm(to_number(trim(ATM.JAQY254NOTER)))) 
            When h.hsucor in (902,903, 904) and h.hcmod = 490 then
            pq_cr_conecta.fn_plaza(pq_cr_conecta.fn_suc_comercio( pq_cr_conecta.fn_cod_come(h.pgcod,h.hcmod,h.htran,
            h.hsucor,h.hnrel,h.hfcon)))
            else 
            pq_cr_conecta.fn_plaza(h.hsucor) end cod_plaza_mov,
      case when h.hsucor in (902,903, 904) and trim(ATM.JAQY254NOTER) is not null then
            pq_cr_conecta.fn_plaza_des(pq_cr_conecta.fn_suc_atm(to_number(trim(ATM.JAQY254NOTER)))) 
            When h.hsucor in (902,903, 904) and h.hcmod = 490 then
            pq_cr_conecta.fn_plaza_des(pq_cr_conecta.fn_suc_comercio( pq_cr_conecta.fn_cod_come(h.pgcod,h.hcmod,h.htran,
            h.hsucor,h.hnrel,h.hfcon)))
            else 
            pq_cr_conecta.fn_plaza_des(h.hsucor) end  Plaza_Mov,
            ATM.JAQY254NOTER
  from fsh016  a, fsr008  d,
       fsd001  e, fst001  f, fst034  g, fsh015  h,
       fst025  i, 
       (SELECT JA.JAQY254NOTER, JA.JAQY254UBTRA, ZE.Z0E475DSC, ZE.Z0E475UBI, ZE.Z0E475SUC,
               ja.JAQY254FETRA, ja.JAQY254PGCTR,ja.JAQY254SUCTR,ja.JAQY254MODTR,ja.JAQY254CODTR,
               ja.JAQY254RELTR
          FROM JAQY254  JA , z0e475 ZE
         WHERE JAQY254FETRA  = ld_fecpro        
           AND JAQY254NOTER = ZE.Z0E475COD (+)) atm
 where a.pgcod = 1
   and (a.hcmod ,a.htran )  in ( select trmod, trnro from jaql119) /*( a.hcmod <> 99 or  (a.hcmod = 99 and a.htran not IN (999)) or (a.hcmod = 98 and a.htran not IN (290,292)) 
        or (a.hcmod = 66 and a.htran not IN (50,65,85,90,99,97)))*/
   and a.hmodul in (21, 440)
   and a.htoper not in (2,5,6)
   and a.hfcon = ld_fecpro
   and h.hfcon = ld_fecpro
   and h.PGCOD = 1
   and d.pgcod = 1
   and d.ctnro = a.hcta
   and d.cttfir ='T'
   and e.pepais = d.pepais
   and e.petdoc = d.petdoc
   and e.pendoc = d.pendoc
   and f.pgcod = a.pgcod
   and f.sucurs = a.hsucur
   and g.pgcod = 1 
   and g.trmod = a.hcmod
   and g.trnro = a.htran
   and a.pgcod = h.pgcod 
   and a.hcmod = h.hcmod 
   and a.hsucor= h.hsucor
   and a.htran = h.htran 
   and a.hnrel = h.hnrel 
   and a.hfcon = h.hfcon 
   and h.hccorr <> 99
   and i.cmcod (+) = a.hcmcod
   --and a.hcta in (131544,787702,786815,161665)

   ---
   and atm.JAQY254PGCTR (+)= A.PGCOD
   AND atm.JAQY254SUCTR  (+)= A.HSUCOR
   AND atm.JAQY254MODTR  (+)= A.HCMOD
   AND atm.JAQY254CODTR  (+)= A.HTRAN
   AND atm.JAQY254RELTR  (+)= A.HNREL
   AND atm.JAQY254FETRA  (+)= A.HFCON
   ;
  
   

     commit; 
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'MOVI',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
    --end loop; 
  --end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  to_number(pd_fecini)
       and g.c_codage = 'MOVI';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = to_number(pd_fecini)
         and g.c_codage = 'MOVI';
    commit;
    return;

end sp_mov_aho;  

function fn_suc_atm (pn_atm in number) return number is
ln_suc number;
begin
  begin
    select Z0E475SUC	
      into ln_suc
      from jaql117 a 
     where trim(a.z0e475cod) =  pn_atm;

  exception
      
      when too_many_rows then
         ln_suc := 0;
      when others then 
         ln_suc := 0;
  end;
   return ln_suc;
end ;

function fn_suc_comercio (pn_comercio in number) return number is
ln_suc number;
begin
  begin
    select sucursal 
      into ln_suc
      from jaql116 a 
     where a.cod_ccr = pn_comercio;
--       and a.jaql4cocom = '303652990000';

  exception
      
      when too_many_rows then
         ln_suc := 0;
      when others then 
         ln_suc := 0;
  end;
   return ln_suc;
end ;


function fn_plaza (pn_suc in number) return number is
ln_plaza number;
begin
  begin
    select b.jaqy656pza --, b.jaqy656npz 
      into ln_plaza
      from jaqy656 b, jaqy657 c
     where b.jaqy656pza = c.jaqy657pza
       and c.jaqy657suc =  pn_suc;

  exception
      
      when too_many_rows then
         ln_plaza := 0;
      when others then 
         ln_plaza := 0;
  end;
   return ln_plaza;
end ;

function fn_plaza_des (pn_suc in number) return varchar2 is
lc_plaza varchar2(50);
begin
  begin
    select b.jaqy656npz 
      into lc_plaza
      from jaqy656 b, jaqy657 c
     where b.jaqy656pza = c.jaqy657pza
       and c.jaqy657suc =  pn_suc;

  exception
      
      when too_many_rows then
         lc_plaza := null;
      when others then 
         lc_plaza := null;
  end;
   return lc_plaza;
end ;

function fn_cod_come (pn_cod in number, pn_mod in number, pn_tra in number, 
                       pn_suc in number, pn_rel in number, pd_fec in date) return number is
ln_come number;
begin
  begin
     select jaql9nuele 
       into ln_come
       from jaql006 
      where JAQL6CTCOD = pn_cod
        and JAQL6CTMOD = pn_mod
        and JAQL6CTSUC = pn_suc
        and JAQL6CTTRA = pn_tra
        and JAQL6CTREL = pn_rel
        and JAQL6CTFCO = pd_fec  ;

  exception
      
      when too_many_rows then
         ln_come := 0;
      when others then 
         ln_come := 0;
  end;
   return ln_come;
end ;

function fn_tipo_cambio_fijo(P_FECHA in date) return number
  is
    ln_tipcam  fsh005.cotcbi%type;
  Begin
       Select cotcbi
         Into ln_tipcam
         From (
                 select u.cotcbi
                   From  fsh005 u
                  Where moneda=101
                    And cofdes <= P_FECHA
               Order by cofdes desc
              )
        Where rownum = 1;

       Return ln_tipcam;
  Exception when others then
            return 0;
  end fn_tipo_cambio_fijo;
         

end pq_cr_conecta;
/

