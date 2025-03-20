create or replace package PQ_CR_CREDITOS_MOV is

  -- Author  : ABERNEDO
  -- Created : 23/03/2015 07:13:20 p.m.
  -- Modificado : 2016.04.05 DCASTRO Se agrego procedimiento que retorna estado contable
  --

Procedure SP_CR_FSD016_MOV ( ln_pgcod in number,
                           ln_itmod in number,
                           ln_ittran in number,
                           ln_itsucd in number,
                           ln_moneda in number,
                           ln_ctnro in number,
                           ln_itoper in number,
                           ld_itfcon out date,
                           lc_ithora out char
) ;

 Procedure SP_CR_FSH016_MOV ( ln_pgcod in number,
                           ln_itmod in number,
                           ln_ittran in number,
                           ln_itsucd in number,
                           ln_moneda in number,
                           ln_ctnro in number,
                           ln_itoper in number,
                           ld_fecha  in date,
                           ld_itfcon out date,
                           lc_ithora out char
) ;

Procedure SP_CR_TIPO_CRED ( ld_fecref in date,
                           ln_pepais in number,
                           ln_petdoc in number,
                           ln_pendoc in VARCHAR2,
                           ln_ctnro in number,
                           ln_itoper in number,
                           ln_tipcre out number
);

Procedure SP_CR_ESTADO_CONTABLE (P_N_PGCOD in number,  
                                 P_N_AOMOD in number, 
                                 P_N_AOSUC in number, 
                                 P_N_AOMDA in number, 
                                 P_N_AOPAP in number, 
                                 P_N_AOCTA in number,
                                 P_N_AOOPER in number,
                                 P_N_AOSBOP in number,
                                 P_N_AOTOPE in number,
                                 P_D_FVTO in date,
                                 P_C_ESTADO out varchar2,
                                 P_N_BCGPO out number );
                                 

end PQ_CR_CREDITOS_MOV;
/

create or replace package body PQ_CR_CREDITOS_MOV is

Procedure SP_CR_FSD016_MOV ( ln_pgcod in number,
                           ln_itmod in number,
                           ln_ittran in number,
                           ln_itsucd in number,
                           ln_moneda in number,
                           ln_ctnro in number,
                           ln_itoper in number,
                           ld_itfcon out date,
                           lc_ithora out char
) IS


ln_itnrel number;

BEGIN

     begin
       select distinct itnrel
          into ln_itnrel
          from fsd016
         where PGCOD = ln_pgcod
           and ITMOD = ln_itmod
           and ITTRAN = ln_ittran
           and ITSUCD = ln_itsucd           
           --and ITORD  = 10
           and CTNRO  = ln_ctnro
           and MONEDA = ln_moneda
           and ITOPER = ln_itoper              
           AND rownum = 1 ;       
      exception 
        when no_data_found then
          ln_itnrel := null;
      end;

     if ln_itnrel is not null then
        begin
          select itfcon, ithora
            into ld_itfcon, lc_ithora
            from fsd015
           where PGCOD = ln_pgcod
             and ITSUC = ln_itsucd
             and ITMOD = ln_itmod
             and ITTRAN = ln_ittran
             and ITNREL = ln_itnrel;
        Exception
          when no_data_found then     
             ld_itfcon := null;
             lc_ithora := null;
        end;
     end if;


END SP_CR_FSD016_MOV;


Procedure SP_CR_FSH016_MOV ( ln_pgcod in number,
                           ln_itmod in number,
                           ln_ittran in number,
                           ln_itsucd in number,
                           ln_moneda in number,
                           ln_ctnro in number,
                           ln_itoper in number,
                           ld_fecha in date,
                           ld_itfcon out date,
                           lc_ithora out char
) IS

ln_itnrel number;

BEGIN

      begin
        select distinct HNREL
          into ln_itnrel
          from fsh016
         where PGCOD = ln_pgcod
           and HCMOD = ln_itmod
           and HSUCOR = ln_itsucd
           and HTRAN = ln_ittran
           and hfcon =  ld_fecha
           and HMDA = ln_moneda
           and HCTA  = ln_ctnro
           and HOPER = ln_itoper
           and rownum = 1;
      exception when no_data_found then
          ln_itnrel := null;
      end;

      if ln_itnrel is not null then
        begin
          select HFCON, HHORA
            into ld_itfcon, lc_ithora
            from fsh015
           where PGCOD = ln_pgcod
             and HCMOD = ln_itmod
             and HSUCOR = ln_itsucd
             and HTRAN = ln_ittran
             and HNREL = ln_itnrel
             and hfcon =  ld_fecha
             and rownum =1 ;

         end;
       end if;


END SP_CR_FSH016_MOV;


Procedure SP_CR_TIPO_CRED ( ld_fecref in date,
                           ln_pepais in number,
                           ln_petdoc in number,
                           ln_pendoc in VARCHAR2,
                           ln_ctnro in number,
                           ln_itoper in number,
                           ln_tipcre out number
) is
 cursor creditos(pn_pepais in number, pn_petdoc in number, pn_pendoc in varchar2, pn_cuenta in number, pn_operacion in number) is
         select des.pgcod, des.aomod, des.aosuc, des.aomda, des.aopap, des.aocta, des.aooper, des.aosbop, des.aotope,
               des.aofval
          from fsd010 des
               inner join fsr008 pers
                      on pers.pgcod = des.pgcod
                     and pers.ctnro = des.aocta
                     and pers.ttcod = 1
                     and pers.CTTFIR = 'T'
         where
               des.aomod in (select modulo from fst111 where dscod=50 and modulo not in (29,120) union all select 117 from dual)
           and des.aomod not in (/*33,*/141)
           and des.aomod <> 120
           and pers.pepais = ln_pepais
           and pers.petdoc = ln_petdoc
           and pers.pendoc = rpad(ln_pendoc,12,' ')
           and des.aofval <= ld_fecref
           and ( /*des.aocta not in pn_cuenta and*/ des.aooper not in pn_operacion );--;


 cursor creddes(pn_pepais in number, pn_petdoc in number, pn_pendoc in varchar2, pn_cuenta in number, pn_operacion in number) is
         select des.pgcod, des.aomod, des.aosuc, des.aomda, des.aopap, des.aocta, des.aooper, des.aosbop, des.aotope,
               des.aofval
          from fsd010 des
               inner join fsr008 pers
                      on pers.pgcod = des.pgcod
                     and pers.ctnro = des.aocta
                     and pers.ttcod = 1
                     and pers.CTTFIR = 'T'
         where
               des.aomod in (select modulo from fst111 where dscod=50 and modulo not in (29,120) union all select 117 from dual)
           and des.aomod not in (/*33,*/141)
           and des.aomod <> 120
           and pers.pepais = ln_pepais
           and pers.petdoc = ln_petdoc
           and pers.pendoc = rpad(ln_pendoc,12,' ')
           and des.aofval <= ld_fecref
           and des.aocta = pn_cuenta and des.aooper = pn_operacion ;--;



  cursor transaccion is
    select tp1nro1 mod, tp1nro2 tran, tp1desc from fst198 where tp1cod = 1 and tp1cod1= 10855 and tp1corr1= 6 and tp1corr2=1 ;

lc_pepais fsr008.pepais%type;
lc_petdoc fsr008.petdoc%type;
lc_pendoc fsr008.pendoc%type;


ld_fecape date;
ld_itfcon date;
lc_ithora char(8);


ln_itnrel number;


ld_fini date;
lc_hini char(8);
lc_tipo number;


begin

   begin
      select pgfape into  ld_fecape from fst017 where pgcod = 1;
   exception when others then
       ld_fecape := null;
   end;

   if  ld_fecape = ld_fecref then
      --consulta credito desembolsado
       for i in creddes(ln_pepais, ln_petdoc, ln_pendoc, ln_ctnro, ln_itoper) loop
           for x in transaccion loop
               begin
                    pq_cr_creditos_mov.sp_cr_fsd016_mov(ln_pgcod => i.pgcod,
                                                        ln_itmod => x.mod,
                                                        ln_ittran => x.tran,
                                                        ln_itsucd => i.aosuc,
                                                        ln_moneda => i.aomda,
                                                        ln_ctnro => i.aocta,
                                                        ln_itoper => i.aooper,
                                                        ld_itfcon => ld_fini ,
                                                        lc_ithora => lc_hini );
                end;
                if ld_fini is not null then
                   exit;
                end if;
           end loop;

       end loop;

     --consulta historico FSD016
        for i in creditos(ln_pepais, ln_petdoc, ln_pendoc, ln_ctnro, ln_itoper) loop
            for x in transaccion loop
               if i.aofval = ld_fecape then
                    begin
                      pq_cr_creditos_mov.sp_cr_fsd016_mov(ln_pgcod => i.pgcod,
                                                          ln_itmod => x.mod,
                                                          ln_ittran => x.tran,
                                                          ln_itsucd => i.aosuc,
                                                          ln_moneda => i.aomda,
                                                          ln_ctnro => i.aocta,
                                                          ln_itoper => i.aooper,                                                
                                                          ld_itfcon => ld_itfcon  ,
                                                          lc_ithora => lc_ithora);
                    end;


                   if ld_itfcon is not null then
                      case
                       when ld_fini > ld_itfcon then --ya existe credito anterior
                         ln_tipcre := 2; --recurrente.
                       when ld_fini = ld_itfcon then
                         if lc_hini < lc_ithora then
                               ln_tipcre := 1; --nuevo
                         elsif lc_hini > lc_ithora then
                               ln_tipcre := 2; --recurrente
                         end if;

                       when  ld_fini < ld_itfcon then
                         ln_tipcre := 1; --nuevo
                         --exit;
                       else
                         null;
                      end case ;
                      if ln_tipcre = 2 then
                         exit; --salir despues que encuentra transaccion de desembolso
                      end if;                 
                  end if;
               else
                  begin
                      pq_cr_creditos_mov.sp_cr_fsh016_mov(ln_pgcod => i.pgcod,
                                                          ln_itmod => x.mod,
                                                          ln_ittran => x.tran,
                                                          ln_itsucd => i.aosuc,
                                                          ln_moneda => i.aomda,
                                                          ln_ctnro => i.aocta,
                                                          ln_itoper => i.aooper,
                                                          ld_fecha  => i.aofval,
                                                          ld_itfcon => ld_itfcon,
                                                          lc_ithora => lc_ithora);
                  end;

                  if ld_itfcon is not null then
                     case
                       when ld_fini > ld_itfcon then --ya existe credito anterior
                         ln_tipcre := 2; --recurrente.
                       when ld_fini = ld_itfcon then
                         if lc_hini < lc_ithora then
                               ln_tipcre := 1; --nuevo
                         elsif lc_hini > lc_ithora then
                               ln_tipcre := 2; --recurrente
                         end if;

                       when  ld_fini < ld_itfcon then
                         ln_tipcre := 1; --nuevo
                         --exit;
                       else
                         null;
                      end case ;
                      if ln_tipcre = 2 then
                         exit; --salir despues que encuentra transaccion de desembolso
                      end if;               
                   end if;
               
               end if ;

            end loop;




        end loop;

  else
     -- FSH016 Historico
         --consulta credito desembolsado
         for i in creddes(ln_pepais, ln_petdoc, ln_pendoc, ln_ctnro, ln_itoper) loop
             for x in transaccion loop
                 begin
                      pq_cr_creditos_mov.sp_cr_fsh016_mov(ln_pgcod => i.pgcod,
                                                          ln_itmod => x.mod,
                                                          ln_ittran => x.tran,
                                                          ln_itsucd => i.aosuc,
                                                          ln_moneda => i.aomda,
                                                          ln_ctnro => i.aocta,
                                                          ln_itoper => i.aooper,
                                                          ld_fecha  => ld_fecref,
                                                          ld_itfcon => ld_fini ,
                                                          lc_ithora => lc_hini );
                  end;
                  if ld_fini is not null then
                     exit;
                  end if;

             end loop;

         end loop;


         for i in creditos(ln_pepais, ln_petdoc, ln_pendoc, ln_ctnro, ln_itoper) loop
            for x in transaccion loop

                 begin
                      pq_cr_creditos_mov.sp_cr_fsh016_mov(ln_pgcod => i.pgcod,
                                                          ln_itmod => x.mod,
                                                          ln_ittran => x.tran,
                                                          ln_itsucd => i.aosuc,
                                                          ln_moneda => i.aomda,
                                                          ln_ctnro => i.aocta,
                                                          ln_itoper => i.aooper,
                                                          ld_fecha  => i.aofval,
                                                          ld_itfcon => ld_itfcon,
                                                          lc_ithora => lc_ithora);
                  end;

                if ld_itfcon is not null then
                   case
                     when ld_fini > ld_itfcon then --ya existe credito anterior
                       ln_tipcre := 2; --recurrente.
                     when ld_fini = ld_itfcon then
                       if lc_hini < lc_ithora then
                             ln_tipcre := 1; --nuevo
                       elsif lc_hini > lc_ithora then
                             ln_tipcre := 2; --recurrente
                       end if;

                     when  ld_fini < ld_itfcon then
                       ln_tipcre := 1; --nuevo
                       --exit;
                     else
                       null;
                    end case ;
                    if ln_tipcre = 2 then
                       exit; --salir despues que encuentra transaccion de desembolso
                    end if;               
                 end if;
            end loop;
        end loop;              
   end if;
   if ld_itfcon is null then
     if  ln_tipcre is null then
       ln_tipcre := 1;
     end if  ;    
   end if;
END SP_CR_TIPO_CRED;
   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

Procedure SP_CR_ESTADO_CONTABLE (P_N_PGCOD in number,  
                                 P_N_AOMOD in number, 
                                 P_N_AOSUC in number, 
                                 P_N_AOMDA in number, 
                                 P_N_AOPAP in number, 
                                 P_N_AOCTA in number,
                                 P_N_AOOPER in number,
                                 P_N_AOSBOP in number,
                                 P_N_AOTOPE in number,
                                 P_D_FVTO in date,
                                 P_C_ESTADO out varchar2,
                                 P_N_BCGPO out number ) IS

lc_estado varchar2(30);
ln_bcgpo number;

begin

  begin
  
   select /*+index (f FSH01200)*/ substr(bcrubr,1,4), f.bcgpo 
     into lc_estado, ln_bcgpo     
     from FSH012 f
    where f.BCEMP  = P_N_PGCOD
      and f.BCFECH = P_D_FVTO
      and substr(f.BCRUBR,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426,8113,8123,8119,8129) 
      and f.BCCTA  = P_N_AOCTA
      and f.BCSUC  = P_N_AOSUC
      and f.BCMDA  = P_N_AOMDA
      and f.BCMOD  = P_N_AOMOD
      and f.BCPAP  = P_N_AOPAP
      and f.BCOPER = P_N_AOOPER
      and f.BCSBOP = P_N_AOSBOP
      and f.BCTOP  = P_N_AOTOPE;
  
  exception 
      when too_many_rows then
        begin
          select min(substr(bcrubr,1,4)), min(f.bcgpo) 
             into lc_estado, ln_bcgpo     
             from FSH012 f
            where f.BCEMP  = P_N_PGCOD
              and f.BCFECH = P_D_FVTO
              and substr(f.BCRUBR,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426,8113,8123,8119,8129) 
              and f.BCCTA  = P_N_AOCTA
              and f.BCSUC  = P_N_AOSUC
              and f.BCMDA  = P_N_AOMDA
              and f.BCMOD  = P_N_AOMOD
              and f.BCPAP  = P_N_AOPAP
              and f.BCOPER = P_N_AOOPER
              and f.BCSBOP = P_N_AOSBOP
              and f.BCTOP  = P_N_AOTOPE;
         exception when others then
              lc_estado := null;
              ln_bcgpo  := null;
         end;     
  
      when others then
           lc_estado := null;
           ln_bcgpo  := null;
  end;
  
  case 
      when lc_estado = '1411' or lc_estado = '1421' then
           P_C_ESTADO := 'Normal';
      when lc_estado = '1414' or lc_estado = '1424' then
           P_C_ESTADO := 'Refinanciado';
      when lc_estado = '1415' or lc_estado = '1425' then
           P_C_ESTADO := 'Vencido';
      when lc_estado = '1416' or lc_estado = '1426' then
           P_C_ESTADO := 'Judicial';
      when lc_estado = '8113' or lc_estado = '8123' then
           P_C_ESTADO := 'Castigado';
      when lc_estado = '8119' or lc_estado = '8129' then
           P_C_ESTADO := 'Castigado';
  else
      null;    
  end case;
  P_N_BCGPO := ln_bcgpo;
  
end SP_CR_ESTADO_CONTABLE;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_CREDITOS_MOV;
/

