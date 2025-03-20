create or replace package PQ_CR_RES_MDESGRAVAMEN is

  -- Author  : ABERNEDO
  -- Created : 04/10/2016 09:12:08 a.m.
  -- Purpose :
  -- Modificado : SMARQUEZ 05/09/2018
  

  Procedure Sp_cr_edad(pn_pai in number,pn_tdo in number,pc_doc in char,pd_fecpro in date,
                     pc_flag out varchar2);
  Procedure Sp_continuidad(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                            pc_flag out varchar2);
  Procedure Sp_antiguedad(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date,
                         pc_flag out char);
  Procedure Sp_Historial(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date,
                         ln_contador out number);
  Procedure Sp_plazo(pn_ins in number,pc_flag out varchar2);
 ----------------------------------sma------------------------------------------------------
  Procedure Sp_cr_edad7176(pn_pai    in number,
                           pn_tdo    in number,
                           pc_doc    in char,
                           pd_fecpro in date,
                           pc_flag   out varchar2,
                           pn_edad   out number);
  Procedure Sp_Seguro(pn_instancia in number,
                      pc_FlagEdad  in varchar2,
                      pc_flag      out varchar2,
                      pn_codseg    out number);

  Procedure Sp_plazo7176(pn_ins       in number,
                         Pn_pai       in number,
                         pn_tdo       in number,
                         pc_doc       in char,
                         pd_fechapro  in date,
                         pc_flagplazo out varchar2,
                         pc_flagEdad  out varchar2,
                         pn_EDAD      out number);

  Procedure Sp_saldoConsolidado(pn_ins  in number,
                                pn_Saldosoles out number,
                                pn_Saldodolares out number);

  Procedure Sp_ConsolidadoSaldo7176(pn_ins  in number,
                                    pn_Saldosoles out number,
                                    pn_Saldodolares out number);
  function PagosParciales(pn_emp in number,
                           pn_suc in number,
                           pn_mod in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sub in number,
                           pn_top in number)return number ;
  PRocedure Cred_EnVuelo(pn_pais in number,
                         pn_tdoc in number,
                         pn_ndoc in varchar2,
                         pn_ins in number,
                         pn_salsol out number,
                         pn_saldol out number);
---------------------------------------------------------------------------------------
  -- Fecha      : 23/03/2022                                           
  -- Modificado : SMARQUEZ 
  -- Porpose    : ADICION DE RESOLUTORES  SEGUROS RESCATE 70 Y 77 LEY DE USUARA                          
---------------------------------------------------------------------------------------
   Procedure SEGURO_RESCATE_70(pn_ins_70        in number,
                               Pn_pai_70        in number,
                               pn_tdo_70        in number,
                               pc_doc_70        in char,
                               pd_fecpro_70     in date,
                               pn_edad_70      out number,    --EDAD
                               pc_flagSeg_70   out varchar2,  --FLAG SEGURO
                               pn_codseg_70    out number,    --CODIGO SEGURO                         
                               pc_flagplazo_70 out varchar2,  --FLAG PLAZO
                               pc_flagEdad_70  out varchar2); --FLAG EDAD
                             

   Procedure SEGURO_RESCATE_77(pn_ins_77        in number,
                               Pn_pai_77        in number,
                               pn_tdo_77        in number,
                               pc_doc_77        in char,
                               pd_fecpro_77     in date,
                               pn_edad_77      out number,    --EDAD
                               pc_flagSeg_77   out varchar2,  --FLAG SEGURO
                               pn_codseg_77    out number,    --CODIGO SEGURO                         
                               pc_flagplazo_77 out varchar2,  --FLAG PLAZO
                               pc_flagEdad_77  out varchar2); --FLAG EDA
   Procedure Sp_SeguroDES(pn_instancia in number,                  
                          pn_codseg    out number,
                          pc_flagres   out varchar2);                                                              

end PQ_CR_RES_MDESGRAVAMEN;
/

create or replace package body PQ_CR_RES_MDESGRAVAMEN is

Procedure Sp_cr_edad(pn_pai in number,pn_tdo in number,pc_doc in char,pd_fecpro in date,
                     pc_flag out varchar2)is
ld_fec date;
ln_edad number(3);
ln_paij number(3);
ln_tdoj number(2);
lc_ndoj char(12);

EdadMinima number:= 0;
EdadMaxima number:= 0;

begin
  begin
    select a.pffnac
    into ld_fec
    from fsd002 a
    where a.pfpais = pn_pai
    and a.pftdoc = pn_tdo
    and a.pfndoc = pc_doc;
  exception
    when others then null;
  end;
  if ld_fec is null then
      begin
        select a.pfpai1,
               a.pftdo1,
               a.pfndo1
          into ln_paij,
               ln_tdoj,
               lc_ndoj
          from fsr003 a
         where a.pjpais = pn_pai
           and a.pjtdoc = pn_tdo
           and a.pjndoc = pc_doc;
        exception
        when too_many_rows then
            begin
              select a.pfpai1,
                     a.pftdo1,
                     a.pfndo1
                into ln_paij,
                     ln_tdoj,
                     lc_ndoj
                from fsr003 a
               where a.pjpais = pn_pai
                 and a.pjtdoc = pn_tdo
                 and a.pjndoc = pc_doc
                 and a.vicod  <> 1
                 and rownum = 1;
            exception
              when no_data_found then null;

            end;
        when no_data_found then null;
      end;

      begin
        select a.pffnac
        into ld_fec
        from fsd002 a
        where a.pfpais = ln_paij
          and a.pftdoc = ln_tdoj
          and a.pfndoc = lc_ndoj;
      exception
        when others then null;
      end;

  end if;
  Begin
    select tp1nro1
    into EdadMinima
    from fst198
   where tp1cod = 1
     and tp1cod1 = 10884
     and tp1corr1 = 37
     and tp1corr2 = 1;
  select tp1nro1
    into EdadMaxima
    from fst198
   where tp1cod = 1
     and tp1cod1 = 10884
     and tp1corr1 = 37
     and tp1corr2 = 2;
  Exception
    when no_data_found then
      pc_flag := 'E';
  end;
  if length(floor(MONTHS_BETWEEN(pd_fecpro,ld_fec)/12))<= 3 then  ---sma 12052020 restriccion

      ln_edad := floor(MONTHS_BETWEEN(pd_fecpro,ld_fec)/12);

--      if ln_edad >= 70 and ln_edad < 76  then
      if ln_edad >= EdadMinima and ln_edad < EdadMaxima  then
         pc_flag := 'S';
      else
         pc_flag := 'N';
      end if;
  else
     pc_flag := 'E';
  end if;

end Sp_cr_edad;

Procedure Sp_continuidad(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                            pc_flag out varchar2)is
cursor cuentas is
select ctnro
  from fsr008
 where pepais = pn_pai
   and petdoc = pn_tdo
   and pendoc = pc_ndo;
ld_fecaux date;
ld_fecult date;
ld_fecnac date;
ln_paij number(3);
ln_tdoj number(3);
lc_ndoj char(12);
ld_fecmin date;
ld_fecmax date;
ln_ctaUlt number(9);
lc_fgEdad char(1);
ln_estado number(2);
ld_fecan date;

ln_dias number;
ln_vigente number:=0;

begin
  begin
    ld_fecult := null;

    For j in cuentas loop
        begin
           select count(*)
             into ln_vigente
             from fsd010
            where aomod  in (select modulo from fst111 where dscod = 50)
              and aocta  = j.ctnro
              --and aofval = ld_fecult
              and aostat <> 99;
         exception
             when no_data_found then
                  ln_vigente := 0;
         end;
         if ln_vigente > 0 then
             pc_flag := 'S';
             exit;
         else
             pc_flag := 'N';
         end if;

    end loop;

    if pc_flag = 'N' then
        for i in cuentas loop
           begin
                select max(a.aofe99)
                  into ld_fecaux
                  from fsd010 a
                 where a.aomod in (select modulo from fst111 where dscod = 50)
                   and a.aocta = i.ctnro;
           exception
             when too_many_rows then
               begin
                  select max(a.aofe99)
                  into ld_fecaux
                  from fsd010 a
                 where a.aomod in (select modulo from fst111 where dscod = 50)
                   and a.aocta = i.ctnro
                   and rownum = 1;
               end;
             when others then
                  ld_fecaux:=to_date('01.01.0001','dd.m.yyyy');
           end;
           if ld_fecult is null then
             ld_fecult := ld_fecaux;
             ln_ctaUlt := i.ctnro;
             else
                 if ld_fecaux > ld_fecult then
                   ld_fecult := ld_fecaux;
                   ln_ctaUlt := i.ctnro;
                 end if;
           end if;

        end loop;

        begin
          select a.pffnac
            into ld_fecnac
            from fsd002 a
           where a.pfpais = pn_pai
             and a.pftdoc = pn_tdo
             and a.pfndoc = pc_ndo;
        exception
          when others then null;
        end;

        if ld_fecnac is null then
          begin
            select a.pfpai1,
                   a.pftdo1,
                   a.pfndo1
              into ln_paij,
                   ln_tdoj,
                   lc_ndoj
              from fsr003 a
             where a.pjpais = pn_pai
               and a.pjtdoc = pn_tdo
               and a.pjndoc = pc_ndo;
            exception
            when too_many_rows then

                begin
                  select a.pfpai1,
                         a.pftdo1,
                         a.pfndo1
                    into ln_paij,
                         ln_tdoj,
                         lc_ndoj
                    from fsr003 a
                   where a.pjpais = pn_pai
                     and a.pjtdoc = pn_tdo
                     and a.pjndoc = pc_ndo
                     and a.vicod  <> 1
                     and rownum = 1;
                exception
                  when no_data_found then null;

                end;
            when no_data_found then null;
          end;

          begin
            select a.pffnac
            into ld_fecnac
            from fsd002 a
            where a.pfpais = ln_paij
              and a.pftdoc = ln_tdoj
              and a.pfndoc = lc_ndoj;
          exception
            when others then null;
          end;

      end if;

      ld_fecmin := add_months(ld_fecnac,(12*70));
      ld_fecmax := add_months(ld_fecnac,(12*76));
      --ld_fecmax := ld_fecmax - 1;

      if ld_fecult >= ld_fecmin and ld_fecult < ld_fecmax then
         lc_fgEdad := 'S';
         else
             lc_fgEdad := 'N';
      end if;

      if lc_fgEdad ='S' then
         begin
           select aostat,aofe99
             into ln_estado,ld_fecan
             from fsd010
            where aomod  in (select modulo from fst111 where dscod = 50)
              and aocta  = ln_ctaUlt
              and aofe99 = ld_fecult;
         exception
           when too_many_rows then
             begin
                 select aostat,aofe99
                   into ln_estado,ld_fecan
                   from fsd010
                  where aomod  in (select modulo from fst111 where dscod = 50)
                    and aocta  = ln_ctaUlt
                    and aofe99 = ld_fecult
                    and rownum = 1;
               exception
                 when others then null;
               end;
            when others then null;
         end;

         if ln_estado = 99 then
            ln_dias :=  pd_fecpro -ld_fecan; --months_between(ld_fecan,pd_fecpro);
            if  ln_dias <= 180 then --months_between(ld_fecan,pd_fecpro)<=6;
               pc_flag := 'S';
               else
                 pc_flag := 'N';
            end if;


         end if;


      end if;
    end if;
  end;


  --begin mod20161111 abr
    --select a.pffnac mod20161111 abr
      --into ld_fecnac mod20161111 abr
      --from fsd002 a mod20161111 abr
     --where a.pfpais = pn_pai mod20161111 abr
       --and a.pftdoc = pn_tdo mod20161111 abr
       --and a.pfndoc = pc_ndo; mod20161111 abr
  --exception mod20161111 abr
    --when others then null; mod20161111 abr
  --end; mod20161111 abr

  --if ld_fecnac is null then mod20161111 abr
      --begin mod20161111 abr
        --select a.pfpai1, mod20161111 abr
          --     a.pftdo1, mod20161111 abr
          --     a.pfndo1 mod20161111 abr
          --into ln_paij, mod20161111 abr
          --     ln_tdoj, mod20161111 abr
          --     lc_ndoj mod20161111 abr
          --from fsr003 a mod20161111 abr
         --where a.pjpais = pn_pai mod20161111 abr
          -- and a.pjtdoc = pn_tdo mod20161111 abr
          -- and a.pjndoc = pc_ndo; mod20161111 abr
        --exception mod20161111 abr
        --when too_many_rows then mod20161111 abr

            --begin mod20161111 abr
              --select a.pfpai1,mod20161111 abr
              --       a.pftdo1,mod20161111 abr
              --       a.pfndo1mod20161111 abr
              --  into ln_paij,mod20161111 abr
              --       ln_tdoj,mod20161111 abr
              --       lc_ndoj mod20161111 abr
              --  from fsr003 a mod20161111 abr
              -- where a.pjpais = pn_pai mod20161111 abr
              --   and a.pjtdoc = pn_tdo mod20161111 abr
              --   and a.pjndoc = pc_ndo mod20161111 abr
              --   and a.vicod  <> 1 mod20161111 abr
              --   and rownum = 1; mod20161111 abr
            --exception mod20161111 abr
            --  when no_data_found then null; mod20161111 abr

          --  end; mod20161111 abr
        --when no_data_found then null;   mod20161111 abr
      --end; mod20161111 abr

      --begin
      --  select a.pffnac mod20161111 abr
      --  into ld_fecnac mod20161111 abr
      --  from fsd002 a mod20161111 abr
      --  where a.pfpais = ln_paij mod20161111 abr
      --    and a.pftdoc = ln_tdoj mod20161111 abr
      --    and a.pfndoc = lc_ndoj; mod20161111 abr
      --exception mod20161111 abr
      --  when others then null; mod20161111 abr
      --end; mod20161111 abr

  --end if; mod20161111 abr

  --ld_fecmin := add_months(ld_fecnac,(12*70)); mod20161111 abr
  --ld_fecmax := add_months(ld_fecnac,(12*76)); mod20161111 abr
  --ld_fecmax := ld_fecmax - 1;

  --if ld_fecult >= ld_fecmin and ld_fecult < ld_fecmax then mod20161111 abr
    -- lc_fgEdad := 'S'; mod20161111 abr
    -- else mod20161111 abr
    --     lc_fgEdad := 'N'; mod20161111 abr
  --end if; mod20161111 abr

  --if lc_fgEdad ='S' then mod20161111 abr
     --begin mod20161111 abr
     --  select aostat,aofe99 mod20161111 abr
     --    into ln_estado,ld_fecan mod20161111 abr
     --    from fsd010  mod20161111 abr
     --   where aomod  in (select modulo from fst111 where dscod = 50) mod20161111 abr
     --     and aocta  = ln_ctaUlt mod20161111 abr
     --     and aofe99 = ld_fecult mod20161111 abr;
     --exception  mod20161111 abr
     --  when too_many_rows then mod20161111 abr
     --    begin  mod20161111 abr
     --        select aostat,aofe99 mod20161111 abr
     --          into ln_estado,ld_fecan mod20161111 abr
     --          from fsd010  mod20161111 abr
     --         where aomod  in (select modulo from fst111 where dscod = 50) mod20161111 abr
     --           and aocta  = ln_ctaUlt mod20161111 abr
     --           and aofe99 = ld_fecult mod20161111 abr
     --           and rownum = 1; mod20161111 abr
     --      exception mod20161111 abr
     --        when others then null;  mod20161111 abr
     --      end;  mod20161111 abr
     --   when others then null;  mod20161111 abr
     --end; mod20161111 abr

     --if ln_estado = 99 then mod20161111 abr
     --   ln_dias :=  pd_fecpro -ld_fecan; mod20161111 abr --months_between(ld_fecan,pd_fecpro);
     --   if  ln_dias <= 180 then  mod20161111 abr--months_between(ld_fecan,pd_fecpro)<=6;
     --      pc_flag := 'S'; mod20161111 abr
     --      else mod20161111 abr
     --        pc_flag := 'N'; mod20161111 abr
     --   end if; mod20161111 abr
     --   else mod20161111 abr
     --     pc_flag := 'S'; mod20161111 abr

     --end if; mod20161111 abr
    -- else mod20161111 abr
       ----
       --begin mod20161111 abr
         --select count(*) mod20161111 abr
          -- into ln_vigente mod20161111 abr
          -- from fsd010  mod20161111 abr
          --where aomod  in (select modulo from fst111 where dscod = 50) mod20161111 abr
           -- and aocta  = ln_ctaUlt mod20161111 abr
            --and aofval = ld_fecult
            --and aostat <> 99; mod20161111 abr
       --exception mod20161111 abr
           --when no_data_found then  mod20161111 abr
                --ln_vigente := 0;  mod20161111 abr
       --end;mod20161111 abr
       --if ln_vigente > 0 then mod20161111 abr
           --pc_flag := 'S'; mod20161111 abr
       --else mod20161111 abr
           --pc_flag := 'N'; mod20161111 abr
       --end if;     mod20161111 abr
       ---

       --pc_flag := 'N';
  --end if; mod20161111 abr

end Sp_continuidad;

Procedure Sp_antiguedad(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date,
                         pc_flag out char)is
ln_contador number(5);
begin
      begin
           pq_cr_res_mdesgravamen.sp_historial(pn_pai,pn_tdo,pc_ndo,pd_Fecpro,ln_contador);

           if ln_contador >= 24 then
             pc_flag := 'S';
             else
               pc_flag := 'N';
           end if;
      end;
end Sp_antiguedad;
Procedure Sp_Historial(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date,
                         ln_contador out number)  is

cursor creditos is
select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       a.aofval,
       a.aofvto,
       --a.aofe99,
       pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,aofe99)aofe99,
       a.aostat
  from fsd010 a, fsr008 b
 where aomod in (select modulo from fst111 where dscod = 50 and modulo not in (200,33,108))
   --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
   and aotope <> 550
   and a.pgcod = 1
   and a.pgcod = b.pgcod
   and a.aocta = b.ctnro
   and b.pepais = pn_pai
   and b.petdoc = pn_tdo
   and b.pendoc = pc_ndo
   and b.cttfir = 'T'
   and b.ttcod = 1
order by aofval;

ld_fecantD date;
ld_fecantC date;

ln_mesac number(2);
ln_aniac number(4);
ln_mesan number(2);
ln_anian number(4);
ln_suma number(5);

ld_aofval date;
ld_aofe99 date;
ld_sysdate DATE;

ln_sw number(1);
begin


    begin
    ln_contador := 0;
    ld_fecantD := null;
    ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    ld_sysdate := last_day(pd_fecpro );
    For i in creditos loop

    ln_sw := 0;
      if (i.aofe99 is null or i.aofe99 = to_date('0001.01.01','yyyy.mm.dd'))and i.aostat = 99 then
         ln_sw := 1;

      end if;
      if ln_sw = 0 then

        ln_mesac := to_number(to_char(i.aofval,'mm'));
        ln_aniac := to_number(to_char(i.aofval,'yyyy'));
        ln_suma := null;
        ld_aofval := i.aofval;
        ld_aofe99 := last_day(i.aofe99);


        if ld_fecantD is null then
              if i.aostat = 99 then
                 ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                 if ln_suma <0 then
                    ln_suma := 0;
                 end if;
                 ln_contador := ln_contador + ln_suma;
                 else
                     ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                     if ln_suma <0 then
                        ln_suma := 0;
                     end if;
                     ln_contador := ln_contador + ln_suma;

              end if;

              Else

                  if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                     if i.aostat = 99 then
                          ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                           if ln_suma <0 then
                              ln_suma := 0;
                           end if;
                          ln_contador := ln_contador + ln_suma;

                          else
                            ln_suma := trunc(months_between(ld_sysdate,
                                                               ld_aofval));
                             if ln_suma <0 then
                                ln_suma := 0;
                             end if;
                            ln_contador := ln_contador + ln_suma;
                      end if;

                      else
                          if ld_aofval < ld_fecantC then
                             --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));
                             ld_aofval :=  ld_fecantC;
                             if i.aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                   if ln_suma <0 then
                                      ln_suma := 0;
                                   end if;

                                  ln_contador := ln_contador + ln_suma;-- - ln_aux;

                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval));
                                     if ln_suma <0 then
                                        ln_suma := 0;
                                     end if;

                                    ln_contador := ln_contador + ln_suma;-- - ln_aux;
                              end if;



                          end if;

                          if ld_aofval > ld_fecantC then

                             if i.aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                   if ln_suma <0 then
                                      ln_suma := 0;
                                   end if;
                                  ln_contador := ln_contador + ln_suma;

                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                                     if ln_suma <0 then
                                        ln_suma := 0;
                                     end if;
                                    ln_contador := ln_contador + ln_suma;
                              end if;



                          end if;


                  end if;

        end if;

        if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
           if ld_fecantC > i.aofval then
              ld_aofval := ld_fecantC;
           end if;
           ld_fecantC := pd_Fecpro;--trunc(sysdate);
        end if;

        if i.aofe99 > ld_fecantC then
                    --ld_fecantD := ld_aofval;
                     ld_fecantC := i.aofe99;

        end if;
        ld_fecantD := ld_aofval;




        ln_mesan := to_number(to_char(ld_fecantC,'mm'));
        ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
      end if;
    end loop;

    END;



end Sp_Historial;
Procedure Sp_plazo(pn_ins in number,pc_flag out varchar2)is

ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);
ld_fecvto date;
ln_pai number(3);
ln_tdo number(2);
lc_ndo char(12);
ln_paij number(3);
ln_tdoj number(2);
lc_ndoj char(12);
ld_fecmax date;
ld_fecnac date;

begin
  begin
       select a.xwfempresa,
              a.xwfsucursal,
              a.xwfmodulo,
              a.xwfmoneda,
              a.xwfpapel,
              a.xwfcuenta,
              a.xwfoperacion,
              a.xwfsubope,
              a.xwftipope
         into ln_emp,
              ln_mod,
              ln_suc,
              ln_mda,
              ln_pap,
              ln_cta,
              ln_ope,
              ln_sbo,
              ln_top
         from xwf700 a
        where a.xwfprcins = pn_ins
          and a.xwfcar3 = '1';
  exception
    when others then null;
  end;

  begin
    select a.aofvto
      into ld_fecvto
      from fsd010 a
     where pgcod  = ln_emp
       and aomod  = ln_mod
       and aosuc  = ln_suc
       and aomda  = ln_mda
       and aopap  = ln_pap
       and aocta  = ln_cta
       and aooper = ln_ope
       and aosbop = ln_sbo
       and aotope = ln_top;
  exception
    when others then null;
  end;

  begin
    select pepais,
           petdoc,
           pendoc
      into ln_pai,
           ln_tdo,
           lc_ndo
      from fsr008
     where ctnro  = ln_cta
       and cttfir = 'T';
  exception --mod@abr 20181102
      when others then null;
  end;
  begin
    select a.pffnac
      into ld_fecnac
      from fsd002 a
     where a.pfpais = ln_pai
       and a.pftdoc = ln_tdo
       and a.pfndoc = lc_ndo;
  exception
    when others then null;
  end;

  if ld_fecnac is null then
      begin
        select a.pfpai1,
               a.pftdo1,
               a.pfndo1
          into ln_paij,
               ln_tdoj,
               lc_ndoj
          from fsr003 a
         where a.pjpais = ln_pai
           and a.pjtdoc = ln_tdo
           and a.pjndoc = lc_ndo;
        exception
        when too_many_rows then

            begin
              select a.pfpai1,
                     a.pftdo1,
                     a.pfndo1
                into ln_paij,
                     ln_tdoj,
                     lc_ndoj
                from fsr003 a
               where a.pjpais = ln_pai
                 and a.pjtdoc = ln_tdo
                 and a.pjndoc = lc_ndo
                 and a.vicod  <> 1
                 and rownum = 1;
            exception
              when no_data_found then null;

            end;
        when no_data_found then null;
      end;

      begin
        select a.pffnac
        into ld_fecnac
        from fsd002 a
        where a.pfpais = ln_paij
          and a.pftdoc = ln_tdoj
          and a.pfndoc = lc_ndoj;
      exception
        when others then null;
      end;

  end if;

  ld_fecmax := add_months(ld_fecnac,(12*76));

  if ld_fecvto > ld_fecmax then
    pc_flag := 'N';
    else
            pc_flag := 'S';
  end if;

end Sp_plazo;
------------------------------------------------------------------------------------------
Procedure Sp_cr_edad7176(pn_pai    in number,
                         pn_tdo    in number,
                         pc_doc    in char,
                         pd_fecpro in date,
                         pc_flag   out varchar2,
                         pn_edad   out number)is
ld_fec date;
ln_edad number(3);
ln_paij number(3);
ln_tdoj number(2);
lc_ndoj char(12);

ln_edadmin number;
ln_edadmax number;

begin
  begin
    select a.pffnac
    into ld_fec
    from fsd002 a
    where a.pfpais = pn_pai
    and a.pftdoc = pn_tdo
    and a.pfndoc = pc_doc;
  exception
    when others then null;
  end;

  Begin
    select tp1imp1
      into ln_edadmin
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10884
       and tp1corr1 = 9
       and tp1corr2 = 1
       and tp1corr3 = 1;
    select tp1imp1
      into ln_edadmax
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10884
       and tp1corr1 = 9
       and tp1corr2 = 1
       and tp1corr3 = 2;
  exception
     when no_data_found then
     null;
  end;

  if ld_fec is null then
      begin
        select a.pfpai1,
               a.pftdo1,
               a.pfndo1
          into ln_paij,
               ln_tdoj,
               lc_ndoj
          from fsr003 a
         where a.pjpais = pn_pai
           and a.pjtdoc = pn_tdo
           and a.pjndoc = pc_doc;
        exception
        when too_many_rows then

            begin
              select a.pfpai1,
                     a.pftdo1,
                     a.pfndo1
                into ln_paij,
                     ln_tdoj,
                     lc_ndoj
                from fsr003 a
               where a.pjpais = pn_pai
                 and a.pjtdoc = pn_tdo
                 and a.pjndoc = pc_doc
                 and a.vicod  <> 1
                 and rownum = 1;
            exception
              when no_data_found then null;

            end;
        when no_data_found then null;
      end;

      begin
        select a.pffnac
        into ld_fec
        from fsd002 a
        where a.pfpais = ln_paij
          and a.pftdoc = ln_tdoj
          and a.pfndoc = lc_ndoj;
      exception
        when others then null;
      end;

  end if;
   if length(floor(MONTHS_BETWEEN(pd_fecpro,ld_fec)/12))<= 3 then ---sma 12052020 restriccion
      ln_edad := floor(MONTHS_BETWEEN(pd_fecpro,ld_fec)/12);
      pn_edad := ln_edad;
      if ln_edad >= ln_edadmin and ln_edad < ln_edadmax  then
          pc_flag := 'S';
      else
          pc_flag := 'N';
      end if;
   else
     pc_flag := 'E';
   end if;
end Sp_cr_edad7176;

Procedure Sp_Seguro(pn_instancia in number,
                    pc_FlagEdad  in varchar2,
                    pc_flag      out varchar2,
                    pn_codseg    out number)is
    valida number;
    seguro number;
  begin
    if pc_FlagEdad = 'S' then
        Begin
          select 1 ,b.sgcod
            into valida,seguro
            from xwf700 a,
                 fpp001 b
           where a.xwfempresa = 1
             and a.xwfprcins = pn_Instancia
             and a.xwfcar3 = '1'
             and b.pgcod = a.xwfempresa
             and b.aomod = a.xwfmodulo
             and b.aosuc = a.xwfsucursal
             and b.aomda = a.xwfmoneda
             and b.aopap = a.xwfpapel
             and b.aocta = a.xwfcuenta
             and b.aooper = a.xwfoperacion
             and b.aosbop = a.xwfsubope
             and b.aotope = a.xwftipope
             and b.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1=10884 and tp1corr1=8);
        exception
          when no_data_found then
            valida := 0;
        end;
    else
      Begin
          select 1 ,b.sgcod
            into valida, seguro
            from xwf700 a,
                 fpp001 b
           where a.xwfempresa = 1
             and a.xwfprcins = pn_Instancia
             and a.xwfcar3 = '1'
             and b.pgcod = a.xwfempresa
             and b.aomod = a.xwfmodulo
             and b.aosuc = a.xwfsucursal
             and b.aomda = a.xwfmoneda
             and b.aopap = a.xwfpapel
             and b.aocta = a.xwfcuenta
             and b.aooper = a.xwfoperacion
             and b.aosbop = a.xwfsubope
             and b.aotope = a.xwftipope
             and b.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1=10884 and tp1corr1=7);
      Exception
        when no_data_found then
            valida := 0;
        when too_many_rows then
            select 1 ,b.sgcod
            into valida, seguro
            from xwf700 a,
                 fpp001 b
           where a.xwfempresa = 1
             and a.xwfprcins = pn_Instancia
             and a.xwfcar3 = '1'
             and b.pgcod = a.xwfempresa
             and b.aomod = a.xwfmodulo
             and b.aosuc = a.xwfsucursal
             and b.aomda = a.xwfmoneda
             and b.aopap = a.xwfpapel
             and b.aocta = a.xwfcuenta
             and b.aooper = a.xwfoperacion
             and b.aosbop = a.xwfsubope
             and b.aotope = a.xwftipope
             and b.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1=10884 and tp1corr1=7)
             and rownum = 1;
      end;
    end if;
       pn_codseg := seguro;
    if valida = 1 then
      pc_flag := 'S';

    else
      pc_flag := 'N';

    end if ;
  end Sp_Seguro;
 Procedure Sp_plazo7176(pn_ins in number,
                        Pn_pai       in number,
                        pn_tdo       in number,
                        pc_doc       in char,
                        pd_fechapro  in date,
                        pc_flagplazo out varchar2,
                        pc_flagEdad  out varchar2,
                        pn_edad      out number)is

  ld_fecnac date;
  ld_fecNew date;
  plazo number(5):=0;
  meses number :=0;
  ln_edad number:=0;
  ln_edadmin number:=0;
  ln_edadmax number:=0;
  begin
    begin
         select a.xwfplazo1
           into plazo
           from xwf700 a
          where a.xwfprcins = pn_ins
            and a.xwfcar3 = '1';
    exception
      when others then null;
    end;
    begin
      select a.pffnac
        into ld_fecnac
        from fsd002 a
       where a.pfpais = Pn_pai
         and a.pftdoc = pn_tdo
         and a.pfndoc = pc_doc;
    exception
      when no_data_found then
        begin
          select b.pffnac
            into ld_fecnac
            from fsr003 a,
                 fsd002 b
           where a.pjpais = pn_pai
             and a.pjtdoc = pn_tdo
             and a.pjndoc = pc_doc
             and a.vicod  <> 1
             and b.pfpais = a.pfpai1
             and b.pftdoc = a.pftdo1
             and b.pfndoc = a.pfndo1
             and rownum = 1;
        exception
          when no_data_found then null;
        end;
    end;

    meses :=  (plazo/30);
    ld_fecNew := add_months(pd_fechapro,meses);
    ln_edad := floor(MONTHS_BETWEEN(ld_fecNew,ld_fecnac)/12);
    pn_edad := ln_edad;

    Begin
    select tp1imp1
      into ln_edadmin
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10884
       and tp1corr1 = 9
       and tp1corr2 = 1
       and tp1corr3 = 1;
    select tp1imp1
      into ln_edadmax
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10884
       and tp1corr1 = 9
       and tp1corr2 = 1
       and tp1corr3 = 2;
  exception
     when no_data_found then
     null;
  end;


    --if ln_edad >= 71 and ln_edad < 76  then
    if ln_edad >= ln_edadmin and ln_edad < ln_edadmax  then  --sma 20200527
       pc_flagEdad := 'S';
    else
        pc_flagEdad := 'N';
    end if;

    if pc_flagEdad = 'S' then
        pc_flagplazo := 'S';
    else
        pc_flagplazo := 'N';
    end if;
  end Sp_plazo7176;

  Procedure Sp_saldoConsolidado(pn_ins  in number,
                                pn_Saldosoles out number,
                                pn_Saldodolares out number)is

  cursor saldos_XWF is
    Select *
     from XWF700
    Where XWFPRCINS = pn_ins;

  cursor cuentas(pais in number,tipdoc in number, documento in char) is
    select *
      from Fsr008
     where Pepais = pais
       AND Petdoc = tipdoc
       AND Pendoc = documento
       AND Ttcod = 1
       AND Cttfir = 'T';


  pais  number(3);
  tipdoc number(2);
  documento char(12);
  origen number(2);
  cuenta number(9);
  TCFijo number(17,3);

  Capital number:= 0 ;
  TotalSol number := 0;
  TotalDol number := 0;

  saldoCan number(17,2):=0;
  saldo    number(17,2):=0;
  existe number(1):=0;

  begin
    Begin
      select sNG001Pais, SNG001Tdoc, SNG001NDoc, SNG001Ori,SNG001cta
        into pais, tipdoc, documento, origen ,cuenta
      from SNG001
      Where SNG001Inst = pn_Ins;
    exception
      when no_data_found then null;
    end;

  For r in saldos_XWF loop
      begin
        select XllCapital
          into capital
          from X054023
        Where XllPgcod  = r.XWfEmpresa
          and XllAomod  = r.XWfModulo
          AND XllAosuc  = r.XWfSucursal
          AND XllAomda  = r.XWfMoneda
          AND XllAopap  = r.XWfPapel
          AND XllAocta  = r.XWfCuenta
          AND XllAooper = r.XWfOperacion
          AND XllAosbop = r.XWfSubope
          AND XllAotop  = r.XWfTipOpe ;
       exception
         when no_data_found then
           capital := 0;
       end;
        If r.XWFCar3 = '1' then
            If r.XWfMoneda = 101 then
                TotalDol := TotalDol + Capital;
            Else
                TotalSol := TotalSol + Capital;
            End if ;
        Else
          BEgin
             select 1
               into existe
               from Fst198
              Where Tp1cod = 1
                and Tp1cod1 = 10898
                and Tp1corr1 = 11
                and Tp1corr2 = 1
                and Tp1nro1 =  origen;
              if r.XWfMoneda = 0 then
--            // Creditos vigentes SOLES
                Begin
                    select nvl(Decode(scmod, 117, Scsdo, (Scsdo * -1)),0)
                      into saldocan
                      from Fsd011
                     Where Pgcod = r.XWfEmpresa
                       AND Scmod = r.XWfModulo
                       AND Scmda = r.XWfMoneda
                       AND Scpap = r.XWfPapel
                       AND Sccta = r.XWfCuenta
                       AND Scsuc = r.XWfSucursal
                       AND Scoper = r.XWfOperacion
                       AND Scsbop = r.XWfSubope
                       AND Sctope = r.XWfTipOpe;

                        TotalSol := TotalSol - saldoCan;
                  exception
                    when no_Data_found then
                      saldocan := 0;
                  End;
              else
--                // Creditos vigentes DOLARES
                Begin
                    select  nvl(decode(scmod,117,Scsdo,(Scsdo * -1)),0)
                      into saldocan
                      from Fsd011
                     Where Pgcod = r.XWfEmpresa
                       AND Scmod = r.XWfModulo
                       AND Scmda = r.XWfMoneda
                       AND Scpap = r.XWfPapel
                       AND Sccta = r.XWfCuenta
                       AND Scsuc = r.XWfSucursal
                       AND Scoper = r.XWfOperacion
                       AND Scsbop = r.XWfSubope
                       AND Sctope = r.XWfTipOpe;
                    TotalDol := TotalDol - saldoCan;
                exception
                  when no_data_found then
                    saldocan := 0;
                End;
              end if;
           exception
             when no_data_found then
               existe := 0;
           end;
       End If;
    End loop;


     --soles
    for c in cuentas (pais,tipdoc, documento) loop
       Begin
            select nvl(sum(Decode( scmod,117,Scsdo,(Scsdo * -1) )),0)
             into Saldo
             from Fsd011
            Where Pgcod = c.Pgcod
            AND Sccta = c.Ctnro
            AND Scmod in ( select modulo from Fst111
                              Where Dscod = 50
                              and  modulo not in (29,120,144,108,142,116)
                              union
                              select 117 from dual)
            and Scmda = 0
            AND Scpap = 0;
            TotalSol := TotalSol + saldo;
       Exception
         when no_data_found then
           Saldo := 0;
       End;

        -- Dolares
        Begin
            select nvl(sum(Decode(scmod, 117, Scsdo, (Scsdo * -1))),0)
              into Saldo
              from Fsd011
             Where Pgcod = c.Pgcod
               AND Sccta = c.Ctnro
               AND Scmod in
                   (select modulo
                      from Fst111
                     Where Dscod = 50
                       and modulo not in (29, 120, 144, 108, 142, 116)
                    union
                    select 117
                      from dual)
               and Scmda = 101
               AND Scpap = 0;
            TotalDol := TotalDol + saldo;
       Exception
         when no_data_found then
           saldo := 0;
       End;

  End loop;


  sp_Cr_TipoCambioAmp(pn_ins,TCFijo);

  if  TCFijo <> 0 then
      pn_Saldodolares := Round(TotalSol / TCFijo, 2) + TotalDol;
      pn_SaldoSoles   := TotalSol + round((TotalDol * TCFijo),2);
  else
      pn_Saldodolares := TotalDol;
      pn_SaldoSoles   := TotalSol;
  end if;

  end Sp_saldoConsolidado;
  Procedure Sp_ConsolidadoSaldo7176(pn_ins  in number,
                                    pn_Saldosoles out number,
                                    pn_Saldodolares out number)is

  cursor saldos_XWF is
    Select *
     from XWF700
    Where XWFPRCINS = pn_ins
      AND XWFCAR3 ='1';

  cursor cuentas(pais in number,tipdoc in number, documento in char) is
    select *
      from Fsr008
     where Pepais = pais
       AND Petdoc = tipdoc
       AND Pendoc = documento
       AND Ttcod = 1
       AND Cttfir = 'T';

  cursor CreditosSoles(cuenta in number)is
     select *
       from Fsd011
      Where Pgcod = 1
        AND Sccta = cuenta
        AND Scmod in (select modulo
                        from Fst111
                       Where Dscod = 50
                         and modulo not in (29, 120, 144, 108, 142, 116)
                      union
                      select 117
                        from dual)
        and Scmda = 0
        AND Scpap = 0;

  cursor CreditosDolares(cuenta in number)is
     select *
       from Fsd011
      Where Pgcod = 1
        AND Sccta = cuenta
        AND Scmod in (select modulo
                        from Fst111
                       Where Dscod = 50
                         and modulo not in (29, 120, 144, 108, 142, 116)
                      union
                      select 117
                        from dual)
        and Scmda = 101
        AND Scpap = 0;


  pais  number(3);
  tipdoc number(2);
  documento char(12);
  origen number(2);
  cuenta number(9);
  TCFijo number(17,3);

  Capital number:= 0 ;
  TotalSol number := 0;
  TotalDol number := 0;

  saldoCan number(17,2);
  --saldo    number(17,2);
  existe   number(1);
  fechanac date;
  fnewnac  date;
  --ctaing   number;
  --opeing   number;

  sdo_despar number;
  MvueloS    number;
  MvueloD    number;
  begin

    Begin
      select a.sNG001Pais, a.SNG001Tdoc, a.SNG001NDoc, a.SNG001Ori, a.SNG001cta, b.pffnac
        into pais, tipdoc, documento, origen, cuenta,fechanac
        from SNG001 a,
             fsd002 b
       Where a.SNG001Inst = pn_Ins
         and b.pfpais = a.sng001pais
         and b.pftdoc = a.sng001tdoc
         and b.pfndoc = a.sng001ndoc;
    exception
      when no_data_found then
        null;
    end;

   -- fnewnac := Add_months(fechanac,(71*12));
    Cred_EnVuelo(pais,tipdoc,documento, pn_Ins,MvueloS,MvueloD);
    TotalSol := TotalSol + MvueloS;
    TotalDol := TotalDol + MvueloD;
  For r in saldos_XWF loop
    begin
        select nvl(sum(ppcap),0)
          into capital
          from fsd601
         where pgcod = r.xwfempresa
           and ppmod = r.xwfmodulo
           and ppsuc = r.xwfsucursal
           and ppmda = r.xwfmoneda
           and pppap = r.xwfpapel
           and ppcta = r.xwfcuenta
           and ppoper = r.xwfoperacion
           and ppsbop = r.xwfsubope
           and pptope = r.xwftipope
         --  and ppfpag > fnewnac
           and d601co = 'X';
     exception
       when no_Data_found then
         capital := 0;
     end;


        If r.XWFCar3 = '1' then
            If r.XWfMoneda = 101 then
                TotalDol := TotalDol + Capital;
            Else
                TotalSol := TotalSol + Capital;
            End if ;
        Else
          BEgin
             select 1
               into existe
               from Fst198
              Where Tp1cod = 1
                and Tp1cod1 = 10898
                and Tp1corr1 = 11
                and Tp1corr2 = 1
                and Tp1nro1 =  origen;
              if r.XWfMoneda = 0 then
--            // Creditos vigentes SOLES
                Begin
                    select nvl(Decode(scmod, 117, Scsdo, (Scsdo * -1)),0)
                      into saldocan
                      from Fsd011
                     Where Pgcod = r.XWfEmpresa
                       AND Scmod = r.XWfModulo
                       AND Scmda = r.XWfMoneda
                       AND Scpap = r.XWfPapel
                       AND Sccta = r.XWfCuenta
                       AND Scsuc = r.XWfSucursal
                       AND Scoper = r.XWfOperacion
                       AND Scsbop = r.XWfSubope
                       AND Sctope = r.XWfTipOpe;

                        TotalSol := TotalSol - saldoCan;
                  exception
                    when no_Data_found then
                      saldocan := 0;
                  End;
              else
--                // Creditos vigentes DOLARES
                Begin
                    select  nvl(decode(scmod,117,Scsdo,(Scsdo * -1)),0)
                      into saldocan
                      from Fsd011
                     Where Pgcod = r.XWfEmpresa
                       AND Scmod = r.XWfModulo
                       AND Scmda = r.XWfMoneda
                       AND Scpap = r.XWfPapel
                       AND Sccta = r.XWfCuenta
                       AND Scsuc = r.XWfSucursal
                       AND Scoper = r.XWfOperacion
                       AND Scsbop = r.XWfSubope
                       AND Sctope = r.XWfTipOpe;
                    TotalDol := TotalDol - saldoCan;
                exception
                  when no_data_found then
                    saldocan := 0;
                End;
              end if;
          exception
             when no_data_found then
               existe := 0;
           end;
       End If;
    End loop;

     --soles
    For c in cuentas (pais,tipdoc, documento) loop
      For cre in CreditosSoles(c.ctnro) loop
        sdo_despar := 0;
        Capital := 0;
        Begin
        select nvl(sum(ppcap),0)
          into Capital
          from fsd601
         where pgcod = cre.pgcod
           and ppmod = cre.scmod
           and ppsuc = cre.scsuc
           and ppmda = cre.scmda
           and pppap = cre.scpap
           and ppcta = cre.sccta
           and ppoper = cre.scoper
           and ppsbop = cre.scsbop
           and pptope = cre.sctope
           ---and ppfpag > fnewnac
           and d601co ='S';
        exception
          when no_data_found then
           Capital := 0;
        end;

           sdo_despar := PagosParciales(cre.pgcod,
                                        cre.scsuc,
                                        cre.scmod,
                                        cre.scmda,
                                        cre.scpap,
                                        cre.sccta,
                                        cre.scoper,
                                        cre.scsbop,
                                        cre.sctope);
         TotalSol := TotalSol + Capital + sdo_despar;
      End loop;
      For cre in CreditosDolares(c.ctnro) loop
        sdo_despar := 0;
        Capital := 0;
        begin
          select nvl(sum(ppcap),0)
            into Capital
            from fsd601
           where pgcod = 1
             and ppmod = cre.scmod
             and ppsuc = cre.scsuc
             and ppmda = cre.scmda
             and pppap = cre.scpap
             and ppcta = cre.sccta
             and ppoper = cre.scoper
             and ppsbop = cre.scsbop
             and pptope = cre.sctope
             --and ppfpag > fnewnac
             and d601co ='S';
         exception
           when no_data_found then
             capital :=0;
         end;
         sdo_despar := PagosParciales(cre.pgcod,
                                        cre.scsuc,
                                        cre.scmod,
                                        cre.scmda,
                                        cre.scpap,
                                        cre.sccta,
                                        cre.scoper,
                                        cre.scsbop,
                                        cre.sctope);
         TotalDol := TotalDol + Capital + sdo_despar;
      End loop;
    End loop;
  sp_Cr_TipoCambioAmp(pn_ins,TCFijo);

  if TCFijo <> 0 then
       pn_Saldodolares := Round(TotalSol / TCFijo, 2) + TotalDol;
       pn_SaldoSoles   := TotalSol + round((TotalDol * TCFijo),2);
  else
     pn_Saldodolares :=  TotalDol;
     pn_SaldoSoles   := TotalSol ;
  end if;

  end Sp_ConsolidadoSaldo7176;
  function PagosParciales(pn_emp in number,
                           pn_suc in number,
                           pn_mod in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sub in number,
                           pn_top in number)return number is
  instancia number;
  saldo  number;
  cont1  number;
  cont2  number;
  pgcod1 number;
  mod1   number;
  suc1   number;
  tran1  number;
  rel1   number;
  fec1   date;

  Begin
   select x.xwfprcins
     into instancia
     from xwf700 x,
          sng001 s
    where x.xwfempresa = pn_emp
      and x.xwfsucursal = pn_suc
      and x.xwfmodulo =  pn_mod
      and x.xwfmoneda = pn_mda
      and x.xwfpapel = pn_pap
      and x.xwfcuenta = pn_cta
      and x.xwfoperacion = pn_ope
      and x.xwfsubope = pn_sub
      and x.xwftipope = pn_top
      and x.xwfcar3 = '1'
      and s.sng001inst = x.xwfprcins
      and s.sng001emp = x.xwfempresa
      and s.sng001cta = x.xwfcuenta
      and s.sng001ori = 7;

        select NVL(Sum(count(*)),0)
          into cont1--pgcod1, mod1,suc1,tran1, rel1,fec1
          from fsd602
         where pgcod = pn_emp
           and ppmod = pn_mod
           and ppsuc = pn_suc
           and ppmda = pn_mda
           and pppap = pn_pap
           and ppcta = pn_cta
           and ppoper = pn_ope
           and ppsbop = pn_sub
           and pptope = pn_top
           and d602mo = 30
           and d602tr = 508
           and d602co ='S'
           and pp1cap <> 0
           and pp1stat = 'P'
         group by d602cd, d602mo, d602su, d602tr, d602re, d602fc;
         cont1 := cont1 + 1;
        select count(*)
          into cont2
          from sng002
         where sng001inst = instancia;

        if cont1 <> cont2 then
             select nvl(sum(sng002ima),0)
               into saldo
               from sng002
              where sng001inst = instancia
                and sng002cor > cont1;
        else
          saldo := 0;
        end if;
        return saldo;

  exception
    when no_data_found then
       saldo := 0;
       return saldo;
  end PagosParciales;

  procedure Cred_EnVuelo(pn_pais in number,
                         pn_tdoc in number,
                         pn_ndoc in varchar2,
                         pn_ins in number,
                         pn_salsol out number,
                         pn_saldol out number) is
                        

  Begin
    begin
      select sum(t.monto)
      into pn_salsol
      From(
      select sum(x.xwfmonto1) monto
        --into pn_salsol
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = pn_pais
                                and Petdoc = pn_tdoc
                                and pendoc = pn_ndoc
                                and Ttcod = 1
                                and Cttfir = 'T')
         and (x.xwfmodulo in (select f.modulo
                                from fst111 f
                               where f.dscod = 50)
                               or x.xwfmodulo = 117)
         and x.XWFPRCINS in (select wf.wfinsprcid
                                from wfwrkitems wf
                               where wf.wfinsprcid = x.xwfprcins
                                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                                 and wf.wfiteminit = (select max(wfiteminit)
                                                        from wfwrkitems w
                                                       where w.wfinsprcid = x.xwfprcins
                                                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                                                         and w.wfitemstsact = 1
                                                         and w.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))--20160519
                                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
         and s.sng120ins = x.XWFPRCINS
         and x.xwfprcins <> pn_ins
         and x.xwfcar3 = '1'
         and x.xwfmoneda = 0
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope) t;
    exception
      when no_Data_found then
         pn_salsol := 0;
      when others then ---07/06/2020
         pn_salsol := 0;
    end;
    Begin
      select sum(v.monto)
        into pn_saldol
      from(  
      select sum(x.xwfmonto1) monto
        --into pn_saldol
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = pn_pais
                                and Petdoc = pn_tdoc
                                and pendoc = pn_ndoc
                                and Ttcod = 1
                                and Cttfir = 'T')
         and (x.xwfmodulo in (select f.modulo
                                from fst111 f
                               where f.dscod = 50)
                               or x.xwfmodulo = 117)
         and x.XWFPRCINS in (select wf.wfinsprcid
                                from wfwrkitems wf
                               where wf.wfinsprcid = x.xwfprcins
                                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                                 and wf.wfiteminit = (select max(wfiteminit)
                                                        from wfwrkitems w
                                                       where w.wfinsprcid = x.xwfprcins
                                                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                                                         and w.wfitemstsact = 1
                                                         and w.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))--20160519
                                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
         and s.sng120ins = x.XWFPRCINS
         and x.xwfprcins <> pn_ins
         and x.xwfcar3 = '1'
         and x.xwfmoneda = 101
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope)v;
  exception
    when no_data_found then
       pn_saldol := 0;
  end;
  end Cred_EnVuelo;
  ---------------------------------------------------------------------------------------
  -- Fecha      : 23/03/2022                                           
  -- Modificado : SMARQUEZ 
  -- Porpose    : ADICION DE RESOLUTORES  SEGUROS RESCATE 70 Y 77 LEY DE USUARA                          
---------------------------------------------------------------------------------------
   Procedure SEGURO_RESCATE_70(pn_ins_70        in number,
                               Pn_pai_70        in number,
                               pn_tdo_70        in number,
                               pc_doc_70        in char,
                               pd_fecpro_70     in date,
                               pn_edad_70      out number,     --EDAD
                               pc_flagSeg_70   out varchar2,   --FLAG SEGURO
                               pn_codseg_70    out number,     --CODIGO SEGURO                         
                               pc_flagplazo_70 out varchar2,   --FLAG PLAZO
                               pc_flagEdad_70  out varchar2)IS --FLAG EDAD
     ln_edad_min number:=0;
     ln_edad_max number:=0;
     ld_fec_nac  date;
     ln_paij     number;
     ln_tdoj     number;
     lc_ndoj     character(12);
     ln_edad     number:=0;
     ln_edad1    number:=0;
     valida      number:=0;
     --seguro      number:=0;
     plazo       number:=0;
     meses       number:=0;
     ld_fecNew   date;
   bEGIN
     
   -- Calculamos Edad y flagedad
    select tp1nro1, tp1nro2
      into ln_edad_min, ln_edad_max
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10884
       and tp1corr1 = 57
       and tp1corr2 = 1
       and tp1corr3 = 1;
    begin
      select a.pffnac
        into ld_fec_nac
        from fsd002 a
       where a.pfpais = pn_pai_70
         and a.pftdoc = pn_tdo_70
         and a.pfndoc = pc_doc_70;
    exception
      when others then
        null;
    end;
    if ld_fec_nac is null then
      begin
        select a.pfpai1,
               a.pftdo1,
               a.pfndo1
          into ln_paij,
               ln_tdoj,
               lc_ndoj
          from fsr003 a
         where a.pjpais = pn_pai_70
           and a.pjtdoc = pn_tdo_70
           and a.pjndoc = pc_doc_70;
        exception
        when too_many_rows then
            begin
              select a.pfpai1,
                     a.pftdo1,
                     a.pfndo1
                into ln_paij,
                     ln_tdoj,
                     lc_ndoj
                from fsr003 a
               where a.pjpais = pn_pai_70
                 and a.pjtdoc = pn_tdo_70
                 and a.pjndoc = pc_doc_70
                 and a.vicod  <> 1
                 and rownum = 1;
            exception
              when no_data_found then null;
            end;
        when no_data_found then null;
      end;

      begin
        select a.pffnac
          into ld_fec_nac
          from fsd002 a
         where a.pfpais = ln_paij
           and a.pftdoc = ln_tdoj
           and a.pfndoc = lc_ndoj;
      exception
        when others then null;
      end;
   end if;
   if length(floor(MONTHS_BETWEEN(pd_fecpro_70,ld_fec_nac)/12))<= 3 then ---sma 12052020 restriccion
      ln_edad := floor(MONTHS_BETWEEN(pd_fecpro_70,ld_fec_nac)/12);
      
      if ln_edad >= ln_edad_min and ln_edad < ln_edad_max  then
          pc_flagEdad_70 := 'S';
      else
          pc_flagEdad_70 := 'N';
      end if;
   else
     pc_flagEdad_70 := 'E';
   end if;
   --- calculamos Seguro y  flag seguro
    if pc_flagEdad_70 = 'S' then
        Begin
          select 1 ,nvl(b.sgcod,0)
            into valida,pn_codseg_70
            from xwf700 a,
                 fpp001 b
           where a.xwfempresa = 1
             and a.xwfprcins = pn_Ins_70
             and a.xwfcar3 = '1'
             and b.pgcod = a.xwfempresa
             and b.aomod = a.xwfmodulo
             and b.aosuc = a.xwfsucursal
             and b.aomda = a.xwfmoneda
             and b.aopap = a.xwfpapel
             and b.aocta = a.xwfcuenta
             and b.aooper = a.xwfoperacion
             and b.aosbop = a.xwfsubope
             and b.aotope = a.xwftipope
             and b.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1=10884 and tp1corr1=55);
        exception
          when no_data_found then
            valida := 0;
            pn_codseg_70 :=0;
        end;
    else
      pn_codseg_70 := 0;
    end if;  
    if valida = 1 then
      pc_flagSeg_70 := 'S';
    else
      pc_flagSeg_70 := 'N';
    end if ;
    -- PLAZO
    begin
         select a.xwfplazo1
           into plazo
           from xwf700 a
          where a.xwfprcins = pn_ins_70
            and a.xwfcar3 = '1';
    exception
      when others then null;
    end;
    meses :=  (plazo/30);
    ld_fecNew := add_months(pd_fecpro_70,meses);
    ln_edad1 := floor(MONTHS_BETWEEN(ld_fecNew,ld_fec_nac)/12);
    pn_edad_70 := ln_edad1; --edad +plazo
    if ln_edad1 >= ln_edad_min and ln_edad1 < ln_edad_max  then  
       pc_flagplazo_70 := 'S';
    else
       pc_flagplazo_70 := 'S';
    end if;   
   END SEGURO_RESCATE_70;                             

   Procedure SEGURO_RESCATE_77(pn_ins_77        in number,
                               Pn_pai_77        in number,
                               pn_tdo_77        in number,
                               pc_doc_77        in char,
                               pd_fecpro_77     in date,
                               pn_edad_77      out number,     --EDAD
                               pc_flagSeg_77   out varchar2,   --FLAG SEGURO
                               pn_codseg_77    out number,     --CODIGO SEGURO                         
                               pc_flagplazo_77 out varchar2,   --FLAG PLAZO
                               pc_flagEdad_77  out varchar2)IS --FLAG EDAD
     ln_edad_min number:=0;
     ln_edad_max number:=0;
     ld_fec_nac  date;
     ln_paij     number;
     ln_tdoj     number;
     lc_ndoj     character(12);
     ln_edad     number:=0;
     ln_edad1    number:=0;
     valida      number:=0;
     --seguro      number:=0;
     plazo       number:=0;
     meses       number:=0;
     ld_fecNew   date;
   bEGIN
     
   -- Calculamos Edad y flagedad
    select tp1nro1, tp1nro2
      into ln_edad_min, ln_edad_max
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10884
       and tp1corr1 = 57
       and tp1corr2 = 1
       and tp1corr3 = 2;
    begin
      select a.pffnac
        into ld_fec_nac
        from fsd002 a
       where a.pfpais = pn_pai_77
         and a.pftdoc = pn_tdo_77
         and a.pfndoc = pc_doc_77;
    exception
      when others then
        null;
    end;
    if ld_fec_nac is null then
      begin
        select a.pfpai1,
               a.pftdo1,
               a.pfndo1
          into ln_paij,
               ln_tdoj,
               lc_ndoj
          from fsr003 a
         where a.pjpais = pn_pai_77
           and a.pjtdoc = pn_tdo_77
           and a.pjndoc = pc_doc_77;
        exception
        when too_many_rows then
            begin
              select a.pfpai1,
                     a.pftdo1,
                     a.pfndo1
                into ln_paij,
                     ln_tdoj,
                     lc_ndoj
                from fsr003 a
               where a.pjpais = pn_pai_77
                 and a.pjtdoc = pn_tdo_77
                 and a.pjndoc = pc_doc_77
                 and a.vicod  <> 1
                 and rownum = 1;
            exception
              when no_data_found then null;
            end;
        when no_data_found then null;
      end;

      begin
        select a.pffnac
          into ld_fec_nac
          from fsd002 a
         where a.pfpais = ln_paij
           and a.pftdoc = ln_tdoj
           and a.pfndoc = lc_ndoj;
      exception
        when others then null;
      end;
   end if;
   if length(floor(MONTHS_BETWEEN(pd_fecpro_77,ld_fec_nac)/12))<= 3 then ---sma 12052020 restriccion
      ln_edad := floor(MONTHS_BETWEEN(pd_fecpro_77,ld_fec_nac)/12);
    
      if ln_edad >= ln_edad_min and ln_edad < ln_edad_max  then
          pc_flagEdad_77 := 'S';
      else
          pc_flagEdad_77 := 'N';
      end if;
   else
     pc_flagEdad_77 := 'E';
   end if;
   --- calculamos Seguro y  flag seguro
    if pc_flagEdad_77 = 'S' then
        Begin
          select 1 ,nvl(b.sgcod,0)
            into valida,pn_codseg_77
            from xwf700 a,
                 fpp001 b
           where a.xwfempresa = 1
             and a.xwfprcins = pn_Ins_77
             and a.xwfcar3 = '1'
             and b.pgcod = a.xwfempresa
             and b.aomod = a.xwfmodulo
             and b.aosuc = a.xwfsucursal
             and b.aomda = a.xwfmoneda
             and b.aopap = a.xwfpapel
             and b.aocta = a.xwfcuenta
             and b.aooper = a.xwfoperacion
             and b.aosbop = a.xwfsubope
             and b.aotope = a.xwftipope
             and b.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1=10884 and tp1corr1=56);
        exception
          when no_data_found then
            valida := 0;
            pn_codseg_77 := 0;
        end;
    else
      pn_codseg_77 := 0;
    end if;  
    if valida = 1 then
      pc_flagSeg_77 := 'S';
    else
      pc_flagSeg_77 := 'N';
    end if ;
    -- PLAZO
    begin
         select a.xwfplazo1
           into plazo
           from xwf700 a
          where a.xwfprcins = pn_ins_77
            and a.xwfcar3 = '1';
    exception
      when others then null;
    end;
    meses :=  (plazo/30);
    ld_fecNew := add_months(pd_fecpro_77,meses);
    ln_edad1 := floor(MONTHS_BETWEEN(ld_fecNew,ld_fec_nac)/12);
    pn_edad_77 := ln_edad1; --edad + plazo
    if ln_edad1 >= ln_edad_min and ln_edad1 < ln_edad_max  then  
       pc_flagplazo_77 := 'S';
    else
       pc_flagplazo_77 := 'N';
    end if; 
   END SEGURO_RESCATE_77; 

Procedure Sp_SeguroDES(pn_instancia in number,                  
                       pn_codseg    out number,
                       pc_flagres   out varchar2)is
  
    seguro number;
  begin

       Begin
          select b.sgcod
           into seguro
            from xwf700 a,
                 fpp001 b
           where a.xwfempresa = 1
             and a.xwfprcins = pn_instancia
             and a.xwfcar3 = '1'
             and b.pgcod = a.xwfempresa
             and b.aomod = a.xwfmodulo
             and b.aosuc = a.xwfsucursal
             and b.aomda = a.xwfmoneda
             and b.aopap = a.xwfpapel
             and b.aocta = a.xwfcuenta
             and b.aooper = a.xwfoperacion
             and b.aosbop = a.xwfsubope
             and b.aotope = a.xwftipope
             and b.sgcod in (select tp1imp1 from fst198 where tp1cod = 1 and tp1cod1=10898 and tp1corr1=8);
         
        exception
          when no_data_found then
            seguro := 0;
          when too_many_rows then
             select b.sgcod
           into seguro
            from xwf700 a,
                 fpp001 b
           where a.xwfempresa = 1
             and a.xwfprcins = pn_instancia
             and a.xwfcar3 = '1'
             and b.pgcod = a.xwfempresa
             and b.aomod = a.xwfmodulo
             and b.aosuc = a.xwfsucursal
             and b.aomda = a.xwfmoneda
             and b.aopap = a.xwfpapel
             and b.aocta = a.xwfcuenta
             and b.aooper = a.xwfoperacion
             and b.aosbop = a.xwfsubope
             and b.aotope = a.xwftipope
             and b.sgcod in (select tp1imp1 from fst198 where tp1cod = 1 and tp1cod1=10898 and tp1corr1=8)
             and rownum = 1;
         
            
        end;   
       pn_codseg := seguro;
       
       begin
         select 'S'
           into pc_flagres
           from fst198
          where tp1cod = 1
            and tp1cod1 = 10898
            and tp1corr1 = 8
            and tp1imp1 between 411 and 498
            and tp1imp1 = seguro;
       exception
         when no_data_found then
           pc_flagres :='N';
        
       end;
       
   
  end Sp_SeguroDES;   
                           
end PQ_CR_RES_MDESGRAVAMEN;
/

