create or replace procedure SP_VALIDA_TASA_DPF(P_C_CODUSU IN VARCHAR2,
                                               P_N_CODAGE IN NUMBER,
                                               P_D_FECINI IN DATE,
                                               P_D_FECFIN IN DATE,
                                               P_N_CLEART IN NUMBER
                                               ) IS                          

  --difint number;
  --cont number;
  tasar number(10,6);
  tasab number(10,6);
  saldo number;
  --------------
  vipgcod  number;
  viscmod  number;
  viscsuc  number;
  viscmda  number;
  viscpap  number;
  visccta  number;
  viscoper number;
  viscsbop number;
  visctope number;
  ln_tipo  number;
  ld_fecvig  date; 
  ld_feccon  date; 
  ld_fecero  date; 
  vd012co    date; 
  
  cursor ctas is
    select a.*, p.petipo, c1.seccod, c1.ctccli
      from FSD010 a, fsr008 b, fsd001 p, fsd008 c1
     where a.pgcod = 1
       and a.aomod = 22
       and a.aostat != 99 
       and a.aoCTA = b.ctnro
       and b.ttcod = 1
       and b.cttfir = 'T'
       and a.aopap = 0
       and a.aosuc = P_N_CODAGE
       and p.pepais = b.pepais
       and p.petdoc = b.petdoc
       and p.pendoc = b.pendoc
       and c1.pgcod = b.pgcod
       and c1.ctnro = b.ctnro
       --and a.aocta = 68690
       --and a.aooper = 253388

    ;

  --especial    char(1);
  --especialcta char(1);
  --tasa10      number;
  tasa_x16    number(10,6);
  grupo       char(1);
  vsuc        number(3);
  vmod        number(3);
  vtran       number(3);
  vnrel       number(4);
  autape      char(1);
  --luren       char(1);
  vd012fc     date;
  vevcorr     number;
  vuser       varchar2(10);
  --campa7      char(1);

--  intbt       number;
  intcal      number;
--  saldo11     number;
--  jbcsdmo     number;
--  rubro12     number;
--  vCTSDepo    number;
--  vRemDepo    number;
--  vscfval_REM date;
  vscfulm     date;
  vscsbop     number(2);
--  intpag      number;
  vfecaut     date;
  ln_correl   number(10):=0;
  lc_usuaut   char(10):=null;
  ld_fecsis   date;

begin
  if P_N_CLEART = 1 then
    delete from jaqz175 a where a.c_usuario = RPAD(P_C_CODUSU,10,' ');
    commit; 
  End If;
  
  begin
    select a.pgfape into ld_fecsis from fst017 a where a.pgcod = 1;  
  exception
  when others then
    ld_fecsis := trunc(sysdate);
  end;
  
  select nvl(max(a.n_correl),0) into ln_correl from jaqz175 a where a.c_usuario = RPAD(P_C_CODUSU,10,' ');
  
  for i in ctas loop
    --tasa10    := i.aotasa;
    saldo     := i.aoimp;  
    vipgcod   := i.pgcod;
    viscmod   := i.aomod;
    viscsuc   := i.aosuc;
    viscmda   := i.aomda;
    viscpap   := i.aopap;
    visccta   := i.aocta;
    viscoper  := i.aooper;
    viscsbop  := i.aosbop;
    visctope  := i.aotope;
    lc_usuaut := null;
  
    --OBTENEMOS TASA DEL PLAZO FIJO A LA FECHA DE APERTURA                           
    begin
      -- Call the procedure
      pq_ah_productividad.tasa(vpgcod  => vipgcod,
                               vscsuc  => viscsuc,
                               vsccta  => visccta,
                               vscmda  => viscmda,
                               vscpap  => viscpap,
                               vscoper => viscoper,
                               vscsbop => viscsbop,
                               vsctope => visctope,
                               vscmod  => viscmod,
                               vsfval  => P_D_FECFIN,--i.aofval,
                               vmonto  => saldo,
                               vplazo  => i.aopzo,
                               tasa    => tasab
                               );
    end;                                 
    if i.aofval = ld_fecsis then     
        begin
          select x.itsuc, x.itmod, x.ittran, x.itnrel, x.itfval
            into vsuc, vmod, vtran, vnrel, vfecaut
            from fsd016 x
           where x.pgcod  = vipgcod
             and x.itfval = i.aofval
             and x.modulo = viscmod
             and x.ittope = visctope
             and x.itsucd = viscsuc
             and x.moneda = viscmda
             and x.papel  = viscpap
             and x.ctnro  = visccta
             and x.itoper = viscoper
             and x.itsubo = viscsbop
             and x.itmod  = 22
             and x.ittran = 800
             and x.itafgt = 'C'
             and rownum   = 1;
        exception
          when no_data_found then
            begin             
              select x.itsuc, x.itmod, x.ittran, x.itnrel, x.itfval
                into vsuc, vmod, vtran, vnrel, vfecaut
                from fsd016 x
               where x.pgcod  = vipgcod
                 and x.itfval <= i.aofval
                 and x.itfval >= i.aofval - 10
                 and x.modulo = 122
                 and x.ittope = visctope
                 and x.itsucd = viscsuc
                 and x.moneda = viscmda
                 and x.papel  = viscpap
                 and x.ctnro  = visccta
                 and x.itoper = viscoper
                 and x.itmod  = 22
                 and x.ittran = 600
                 and x.itafgt = 'C'
                 and rownum   = 1;                 
            exception
              when no_data_found then
                vnrel := 0;          
              when others then
                vnrel := 0;
            end;      
          when others then
            vnrel := 0;
        end;      
    Else                             
        begin
          select hsucor, hcmod, htran, hnrel, hfcon
            into vsuc, vmod, vtran, vnrel, vfecaut
            from fsh016
           where pgcod  = vipgcod
             and hfcon  = i.aofval
             and hmodul = viscmod
             and htoper = visctope
             and hsucur = viscsuc
             and hmda   = viscmda
             and hpap   = viscpap
             and hcta   = visccta
             and hoper  = viscoper
             and hsubop = viscsbop
             and hcmod  = 22
             and htran  = 800
             and hcafgt = 'C'
             and rownum = 1;
        exception
          when no_data_found then
            begin
              select hsucor, hcmod, htran, hnrel, hfcon
                into vsuc, vmod, vtran, vnrel, vfecaut
                from fsh016
               where pgcod  =  vipgcod
                 and hfcon  <= i.aofval
                 and hfcon  >= i.aofval - 10
                 and hmodul =  122
                 and hsucur =  viscsuc
                 and hmda   =  viscmda
                 and hpap   =  viscpap
                 and hcta   =  visccta
                 and hoper  =  viscoper
                 and hcmod  =  22
                 and htran  =  600
                 and hcafgt =  'C'
                 and rownum =  1;
            exception
              when no_data_found then
                vnrel := 0;          
              when others then
                vnrel := 0;
            end;      
          when others then
            vnrel := 0;
        end;
    End if;
      
    if vnrel = 0 then
      vfecaut := i.aofval;
    end if;
    
    if vnrel <> 0 then
      begin
        select 'S', substr(decode(trim(x.exusau),null,x.exusso,trim(x.exusau)),1,10)
          into autape, lc_usuaut
          from fsh010 x
         where hfcont  = vfecaut
           and hsucor  = vsuc
           and x.hcmod = vmod
           and x.htran = vtran
           and x.pgcod = 1
           and x.hnrel = vnrel
           and x.excod = 11
           and rownum  = 1;
          
      exception
        when no_data_found then
          autape := 'N';
          lc_usuaut := null;
        when others then
          autape := 'X';
          lc_usuaut := null;
      end;
    end if;  
    
    if lc_usuaut is null then
        if i.aofval = ld_fecsis then     
            begin
              select decode(trim(x.itucnf),null,x.ituing,x.itucnf)
                into lc_usuaut
                from fsd015 x
               where x.pgcod  = vipgcod
                 and x.itsuc  = vsuc    
                 and x.itmod  = vmod
                 and x.ittran = vtran
                 and x.itnrel = vnrel;
            exception
            When others then              
                 lc_usuaut := null;
            end;      
        Else                             
            begin
              select /*+index(x SYS_C00977884)*/ decode(trim(x.huscnf),null,x.husing,x.huscnf)
                into lc_usuaut
                from fsh015 x
               where x.pgcod  = vipgcod
                 and x.hcmod  = vmod
                 and x.hsucor = vsuc    
                 and x.htran  = vtran
                 and x.hnrel  = vnrel
                 and x.hfcon  = vfecaut;  
            exception
            When others then
                 lc_usuaut := null;
            end;          
        End if;            
    End If;    
    
    --OBTENEMOS TASA QUE LE CORRESPONDERIA A LA FECHA DE A LA APERTURA
    begin
      -- Call the procedure
      pq_ah_productividad.tasa(vpgcod  => vipgcod,
                               vscsuc  => viscsuc,
                               vsccta  => visccta,
                               vscmda  => viscmda,
                               vscpap  => viscpap,
                               vscoper => 0,
                               vscsbop => 0,
                               vsctope => visctope,
                               vscmod  => viscmod,
                               vsfval  => vfecaut,
                               vmonto  => saldo,
                               vplazo  => i.aopzo,
                               tasa    => tasar
                               );
    end;

    ld_fecvig := vfecaut;
    
    if tasab <> tasar or saldo < 0 then    
      --verificamos si es trabajador
      begin
        select 'S' 
          into grupo
          from fsd009 a 
         where a.tgcod = 4  
           and a.grnro = 22001 
           and a.pgcod = vipgcod
           and a.ctnro = visccta;
      exception
      when others then
        grupo := 'N';       
      end;
      
      If grupo = 'S' then  
          begin
            select tptasa
              into tasar
              from (select tptasa
                      from FSR027 t3, fsd027 t4
                     where t3.pgcod  = t4.pgcod
                       and t3.modulo = t4.modulo
                       and t3.tpizar = t4.tpizar
                       and t3.ctnro  = t4.ctnro
                       and t3.moneda = t4.moneda
                       and t3.papel  = t4.papel
                       and t3.tpfdes = t4.tpfdes
                       and t3.tpmto  = t4.tpmto
                       and t3.pgcod  = vipgcod
                       and t3.modulo = viscmod + 500
                       --and t3.tpizar = tipo
                       and t3.ctnro  = (4*10000000) + 22001
                       and t3.moneda = viscmda
                       and t4.tpmto  >= saldo
                       and t4.tpfdes <= vfecaut
                       and t4.tpvig  = 'S'
                       and t3.tppzo  >= i.aopzo                       
                     order by t4.tpfdes desc, t4.tpmto, t3.tppzo)
             where rownum = 1;
          exception
          when others then  
            null;
          end;             
      End If;
                 
      begin
        select x.txtord,x.txoren,x.hfcon
         into tasa_x16, ln_tipo, ld_feccon
         from (
              select to_number(trim(a.txtord),'990.990000') txtord,a.txoren,a.hfcon
                from fsx016 a
               where PgCod  = vipgcod
                 and Hfcon  >= i.aofval
                 and hfcon  >= P_D_FECINI
                 and hfcon  <= P_D_FECFIN           
                 and txtsuc = viscsuc
                 and txtmda = viscmda
                 and txtpap = viscpap
                 and txtcta = visccta
                 and txtope = viscoper
                 and txtsbo = viscsbop
                 and txttop = visctope
                 and txtmod = viscmod
                 and Txcod  = 70
                 order by hfcon desc
           ) x
          where rownum = 1;
          if ld_feccon > ld_fecvig then
             ld_fecvig := ld_feccon;
             tasa_x16  := tasa_x16;
          End If;  
      exception
        when no_data_found then
          tasa_x16 := 0;
          ln_tipo  := 99;
        when others then
          tasa_x16 := 99;
          ln_tipo  := 99;
      end;    
    
      vuser   := '';
      vd012fc := null;
      --campa7  := 'N';
          
      begin
        select evfval, evcorr, 
               case
                 when evfval >= nvl(ld_feccon,ld_fecvig) then
                   evtasa
                 Else
                   tasa_x16  
                end,
                d012fc,
               case
                 when evfval >= nvl(ld_feccon,ld_fecvig) then
                   99
                 Else
                   ln_tipo  
                end                 
          into vd012fc, vevcorr, tasa_x16, vd012co,ln_tipo
          from (select evfval, evcorr, evtasa, d012fc
                  from fsd012
                 Where Pgcod  = vipgcod
                   and Aomod  = viscmod
                   and Aosuc  = viscsuc
                   and Aomda  = viscmda
                   and Aopap  = viScpap
                   and Aocta  = visccta
                   and Aooper = viscoper
                   and Aosbop = viscsbop
                   and Aotope = visctope
                   and Evtipo = 3 --fijo interes
                   and D012co = 'S'
                   and evfval >= P_D_FECINI
                   and evfval <= P_D_FECFIN                            
                 order by evfval desc, evcorr desc
                 )
         where rownum = 1; --fijo
       Exception
       when others then
           tasa_x16 := tasa_x16;  
       end;  
       
       if ln_tipo <> 99 then
         begin
         select x.txoren
           into ln_tipo
         from (
              select to_number(trim(a.txtord),'990.990000') txtord,a.txoren,a.hfcon
                from fsx016 a
               where PgCod  = vipgcod
                 and Hfcon  >= i.aofval
                 and hfcon  >= P_D_FECINI
                 and hfcon  <= P_D_FECFIN           
                 and txtsuc = viscsuc
                 and txtmda = viscmda
                 and txtpap = viscpap
                 and txtcta = visccta
                 and txtope = viscoper
                 and txtsbo = viscsbop
                 and txttop = visctope
                 and txtmod = viscmod
                 and to_number(trim(txtord),'990.990000') = tasa_x16
                 and Txcod  = 70
                 order by hfcon desc
           ) x
          where rownum = 1;
      exception
      when others then
           null;
      end;             
       
       end if;
       
           
       if vd012fc > ld_fecvig then
          ld_fecvig := vd012fc;
          
          begin
            select aud_fsd012_ubu,
                   substr(decode(trim(lc_usuaut),null,decode(trim(aud_fsd012_ubu),null,aud_fsd012_uba,trim(aud_fsd012_ubu)),lc_usuaut),1,10)
              into vuser,
                   lc_usuaut
              from aud_fsd012_audit -- Evtasa      
             Where aud_new_Aomod  = viscmod
               and aud_new_Aosuc  = viscsuc
               and aud_new_Aomda  = viscmda
               and aud_new_Aopap  = viScpap
               and aud_new_Aocta  = visccta
               and aud_new_Aooper = viscoper
               and aud_new_Aosbop = viscsbop
               and aud_new_Aotope = visctope
               and aud_new_Evtipo = 3 --fijo interes
               and aud_new_D012co = 'S'
               and aud_new_d012fc = vd012co
               and aud_new_evcorr = vevcorr;
          exception
            when no_data_found then
              vuser   := '';
              vd012fc := null;
            when others then
              vuser := 'X';
          end;             
       End If;     
    
       begin
          select a.aofval 
            into ld_Fecero 
            from fsd010 a 
           where a.pgcod  = 1
             and a.aomod  = 22
             and a.aosuc  = i.aosuc
             and a.aomda  = i.aomda
             and a.aopap  = i.aopap
             and a.aocta  = i.aocta
             and a.aooper = i.aooper
             and a.aosbop = 0
             and a.aotope = i.aotope;
       exception
       when others then
          ld_fecero := null;
       end;
       if tasa_x16 = 0 then
          tasa_x16 := tasab;
       End If;  
           
      ln_correl := ln_correl + 1;
      insert into jaqz175
        (c_usuario,
         n_correl,
         n_monto1,
         n_monto2,
         n_monto3,
         n_monto4,
         n_monto5,
         n_monto6,
         n_monto7,
         D_FECHA1,
         C_TEXTO1,
         c_descri1,
         c_descri2,
         n_monto8,
         c_descri11,
         n_monto12,
         n_monto13,
         D_FECHA2,
         D_FECHA3,
         c_descri3,
         n_monto14,
         n_monto15,
         n_monto16,
         c_descri4,
         c_descri9,
         c_descri10,
         n_monto19,
         n_monto11,
         c_descri5,
         c_descri6,
         c_descri7,
         d_fecha4,
         c_descri8,
         c_descri12,
         c_descri13,
         c_descri14,
         c_descri15,
         n_monto20,
         n_monto21,
         d_fecha5,
         d_fecha6,
         n_monto22,
         n_monto23,
         c_descri16,
         c_descri17,
         c_descri18,
         jaqz175mo1,
         jaqz175da1,
         jaqz175ch1,
         jaqz175da2
         )
      values
        (P_C_CODUSU,
         ln_correl,
         i.aosuc,
         i.aocta,
         i.aomda,
         i.aopap,
         i.aooper,
         i.aosbop,
         i.aotope,
         i.aofval,
         saldo,
         TRIM(to_char(tasar, '990.990')),
         TRIM(to_char(tasa_x16, '990.990')),
         i.aostat,
         null,--to_char(difint, '9,999,990.9990'),
         null,--cont,
         i.aopzo, --dias,
         i.aofvto, --fecdev,
         vfecaut, --ld_fecpro,
         i.petipo,
         i.seccod,
         i.ctccli,
         0, --intcap,
         null,--campa7, --to_char(saldo21, '999,999,990.90'),
         null,--TRIM(to_char(intbt, '9,999,990.9990')),
         TRIM(to_char(intcal, '9,999,990.9990')),
         0, --acumulado,
         0, --acumes,
         null,--especial,
         null,--especialcta,
         null,--TRIM(to_char(saldo11, '999,999,990.90')),
         vd012fc, --i.aofulm,
         null,--rubro12,
         vuser, --'0', --to_char(acucap, '999,999,990.90'),
         null,--grupo, --cancel,
         null,--TRIM(to_char(jbcsdmo, '999,999,990.90')),
         null,--TRIM(to_char(tasa10, '990.990')),
         null,--vCTSDepo,
         null,--vRemDepo,
         null,--vscfval_REM,
         vscfulm,
         vscsbop,
         null,--intpag,
         TRIM(to_char(tasa_x16, '990.990')),
         autape,
         null,--luren,
         ln_tipo,
         ld_fecvig,
         lc_usuaut,
         ld_fecero
         );
    end if;
  
    commit;
  end loop; 

end SP_VALIDA_TASA_DPF;
/

