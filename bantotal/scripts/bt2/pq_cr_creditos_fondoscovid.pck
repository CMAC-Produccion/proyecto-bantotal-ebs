create or replace package pq_cr_creditos_fondoscovid is
  -- Author  : KVALENCIAC
  -- Created : 09/04/2021
  -- Purpose : Proceso para la alta de Monto Honrado
  -- Modificado:27/04/2021 Karen Valencia
  -- Modificacion: Se adcionó procedimiento para obtener el monto, gasto e interés de honramiento ocn las tablas de DLYA.
  -- Modificado : 09/04/2021 Karen Valencia
  -- Purpose : Se adicionó proceso si es un crédito honrado 
  -- Modificado: 02/09/2021 Karen Valencia
  -- Purpose : Se adicionó nuevos tipod de fondos
  -- Modificado: 09/12/2021   Karen Valencia
  -- Purpose : Se modificó para que no considere los saldos honrados cuando se ha extornado el castigo
  -- Modificado: 11/02/2022   Karen Valencia
  -- Purpose : Se modificó algunas tablas de busqueda de fondo
  -- Modificado: 27/05/2022   Karen Valencia  
  -- Purpose : Se adicionó operación en la búsqueda busqueda de si es un créditos de fondo
  -- Modificado: 03/06/2022   Karen Valencia
  -- Purpose : Se modificó la busqueda de los de FAE Agro como crédito de fondo
  -- Modificado: 13/07/2022   Karen Valencia  
  -- Purpose : Se modificó y adicionó el Interes Compensatoio FAE Agro 
  -- Modificado: 07/10/2022-20/10/2022   Karen Valencia 
  ------
  -- Purpose : Se adicionón el Interes compensatorio Honrado en las tablas de castigo
  -- Modificado: 26/10/2022   Karen Valencia 
  ----------------------
   -- Purpose : Se adicionó la aqpb065b para la busquedade fondos covid
  -- Modificado: 21/12/2022   Karen Valencia 
  ----------------------
   -- Purpose : Se modificó el proceso de verifica si es fondo para que solo considere lo de las tablas y ya no por tipo y operación
  -- Modificado: 06/03/2023   Karen Valencia 
  ----------------------
   -- Purpose : Se modificó el proceso, s eha adicionado Fae Texco
  -- Modificado: 15/06/2023   Karen Valencia 
  -------------------------------------
    -- Purpose : Se modificó el proceso, se ha optimizado para que solo entre a buscar saldos cuando es honrado
  -- Modificado: 23/09/2024   Karen Valencia 
  -------------------------------------
   -- Purpose : Se modificó el proceso, sp_verificar_cred_fondo se comento llamada a tabla antigua aqpb422 fondo fae2
  -- Modificado: 27/02/2025   Darling Castro 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_verificar_cred_fondo(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_flag out varchar2
                             );
                             
  procedure sp_busca_honramiento(pn_cod   in number,                                    
                                    pn_mda   in number,                                   
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_saldo out number,                                   
                                    pn_flag out varchar2
                             );                     
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_saldos_honramiento(pn_cod   in number,   --no esta el INteres Conpensatorio como concepto de salida
                                    pn_mda   in number, -- pero se modificó para que este en el total y active el flag de saldos de honramiento
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_flag out varchar2
                             );
--inicio 20/10/2022                             
  procedure sp_saldos_honramientoi(pn_cod   in number, --devuelve cada concepto de saldo honrado   y flag si tiene saldos honrados                                                                   
                                    pn_mda   in number,                                    
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_interesc out number,
                                    pn_flag out varchar2
                             );   
--fin 20/10/2022                                                       
--inicio 02/09/2021                             
  procedure sp_es_honrado(pn_cod   in number,                                    
                                    pn_mda   in number,                                   
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_flag out varchar2
                             );  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_verificar_cred_fondoc(pn_cod  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number,                                
                                    pn_flag out varchar2
                             );
                                                 
  procedure sp_saldos_honramientoc(pn_cod   in number,                                                                       
                                    pn_cta   in number,
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_flag out varchar2
                             );
  procedure sp_es_honradoc(pn_cod   in number,                                                                                                       
                                    pn_cta   in number,
                                    pn_flag out varchar2
                             ); 
--fin 02/09/2021
--inicio 09/12/2021 kdvc
  procedure sp_saldohonrado_castigado(pn_cod   in number,                                                                       
                                    pn_mda   in number,                                    
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_flag out varchar2
                             );
--fin 09/12/2021 kdvc  
--inicio 26/10/2022 kdvc
  procedure sp_saldohonrado_castigado2(pn_cod   in number,                                                                       
                                    pn_mda   in number,                                    
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_interesc out number,
                                    pn_flag out varchar2
                             );
--fin 26/10/2022 kdvc                                                                                                               
end pq_cr_creditos_fondoscovid;
/

create or replace package body pq_cr_creditos_fondoscovid is

  /* ************************************************************************************************************
  -- Author  : KVALENCIAC
  -- Created : 09/04/2021
  -- Purpose : Proceso para la alta de Monto Honrado
  * *************************************************************************************************************/
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
  procedure sp_verificar_cred_fondo(pn_cod  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number,
                                    pn_flag out varchar2) is

-- 2025.02.27 dcastro se comento llamada a tabla antigua aqpb422   fondo fae2                                 
  
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
    lx_gob number;
    lx_faea number;
    lx_faet number;
    lx_paem number;
     ln_r1mod number;
    ln_r1tope number;
    ln_Faex number;  --kvalenciac  15/06/2023
    ln_Impulsa number; --kvalenciac 30/10/2023
  begin
    --inicio 09/12/2021 kdvc
     -- busco crédito origen  inicio 09/12/2021   Karen Valencia
  -- -- -- -- -- -- -- -- -        
     begin
         select R1MOD,R1TOPE into ln_r1mod,ln_r1tope 
         from fsr011
         where R2COD = pn_cod
          -- and R1MOD = pn_mod 
           and R2SUC = pn_suc 
           and R2MDA = pn_mda 
           and R2PAP = pn_pap 
           and R2CTA = pn_cta 
           and R2OPER =pn_ope 
           and R2SBOP =pn_sbo 
           --and R1TOPE =pn_top 
           and RELCOD = 52;--- solo es para los que han pasado a estado 200 o 33 para obtener su clave inicial
       exception 
          when others then
              ln_r1mod := pn_mod;
              ln_r1tope := pn_top;
     end; 
   
    lx_faea := 0;
    lx_faet := 0;
    lx_paem := 0;
  --fae agro 
  begin     --inicio 27/05/2022 kvalenciac
     /* select count(*)
        into lx_faea
        from aqpb379b x
       where x.aqpb379bcod = pn_cod        
         and x.aqpb379bcta = pn_cta
         and x.aqpb379best <> 'D'
         and rownum = 1; */   
         --inicio 03/06/2022 kvalenciac    
       select  1 --count(*)  kvalenciac 21/12/2022
        into lx_faea
        from aqpb379b x
        inner join fsd010 f on f.PGCOD=x.aqpb379bcod and f.aoCTA=x.aqpb379bcta        
        where f.PGCOD = pn_cod
          and f.aoCTA = pn_cta
          and f.aoOPER= pn_ope  --11365218
          and f.aomda = pn_mda 
          and f.aomod  = 116  --and f.aomod  = 117   --117  13/07/2022 kvalenciac
          and f.aotope = 20
          and x.aqpb379best <> 'D';
          --fin 03/06/2022 kvalenciac    
    exception   --fin 27/05/2022 kvalenciac
      when no_data_found then
        if ( ln_r1mod = 116 and ln_r1tope=20 ) then
          --lx_faea := 1;
          --inicio 06/03/2023 kvalenciac
           begin
           select  count(*) 
            into lx_faea
            from aqpb379b x
            inner join fsd010 f on f.PGCOD=x.aqpb379bcod and f.aoCTA=x.aqpb379bcta        
            where f.PGCOD = pn_cod
              and f.aoCTA = pn_cta
              and f.aoOPER= pn_ope  
              and f.aomda = pn_mda 
              and f.aomod  = ln_r1mod  
              and f.aotope = ln_r1tope
              and x.aqpb379best <> 'D';
            exception 
            when no_data_found then
                lx_faea:=0;
            end;
            if lx_faea>0 then
                lx_faea:=1;
            end if;            
            --fin 06/03/2023 kvalenciac  
        end if;         
   end;
  --fondo fae turismo
   begin    --inicio 27/05/2022 kvalenciac
      select 1  --count(*)  kvalenciac 21/12/2022
        into lx_faet
        from aqpb762b x
       where x.aqpb762bcod = pn_cod        
         and x.aqpb762bccta = pn_cta
         and x.aqpb762boper = pn_ope     
         and x.aqpb762best <> 'D'
         and rownum = 1;
    exception    --fin 27/05/2022 kvalenciac
      when no_data_found then
        lx_faet:=0;
        /*if ( ln_r1mod = 101 and ln_r1tope=355 ) then
          lx_faet := 1;
        end if;*/
    end;
  --fondo pae mype
  begin    --inicio 27/05/2022 kvalenciac
      select 1 --count(*)  kvalenciac 21/12/2022
        into lx_paem
        from aqpb394b x
       where x.aqpb394bcod = pn_cod        
         and x.aqpb394bcta = pn_cta
         and x.aqpb394bope = pn_ope     
         and x.aqpb394best <> 'D'
         and rownum = 1;
    exception   --fin 27/05/2022 kvalenciac
      when no_data_found then 
          lx_paem:=0;
      /*if ( ln_r1mod = 101 and ln_r1tope=356 ) then
        lx_paem := 1;
      end if;*/
    end;
  -- fin 09/12/2021 kdvc
  --reactiva
    begin
      select 1 --count(*)  kvalenciac 21/12/2022
        into lx_reac
        from aqpb065b x
       where x.aqpb065bcod = pn_cod
        -- and x.aqpb065bmod = pn_mod
        -- and x.aqpb065bsuc = pn_suc
         and x.aqpb065bmda = pn_mda
         and x.aqpb065bpap = pn_pap
         and x.aqpb065bcta = pn_cta
         and x.aqpb065bope = pn_ope
       --  and x.aqpb065bsbo = pn_sbo
        -- and x.aqpb065btop = pn_top
         and x.aqpb065best <> 'D'
         and rownum = 1;
    exception
      when no_data_found then
         begin
          select count(*)
          into lx_reac
          from aqpb428 b
           where b.aqpb428emp = pn_cod
           and b.aqpb428mda = pn_mda
           and b.aqpb428cta = pn_cta
           and b.aqpb428ope = pn_ope
           and rownum = 1;
        exception 
          when others then
              lx_reac := 0;
         end;
    end;
  --crecer
    begin
      select count(*)
        into lx_crec
        from aqpb073b x
       where x.aqpb073bcod = pn_cod
        -- and x.aqpb073bmod = pn_mod
        -- and x.aqpb073bsuc = pn_suc
         and x.aqpb073bmda = pn_mda
         and x.aqpb073bpap = pn_pap
         and x.aqpb073bcta = pn_cta
         and x.aqpb073bope = pn_ope
        -- and x.aqpb073bsbo = pn_sbo
        -- and x.aqpb073btop = pn_top
         and x.aqpb073best <> 'D';
    exception
      when others then
        lx_crec := 0;
    end;
  ---fae1
    begin
      select count(*)
        into lx_fae1
        from aqpb067b x
       where x.aqpb067bcod = pn_cod
       --  and x.aqpb067bmod = pn_mod
       --  and x.aqpb067bsuc = pn_suc
         and x.aqpb067bmda = pn_mda
        -- and x.aqpb067bpap = pn_pap
         and x.aqpb067bcta = pn_cta
         and x.aqpb067bope = pn_ope
       --  and x.aqpb067bsbo = pn_sbo
        -- and x.aqpb067btop = pn_top
         and (x.aqpb067bmod <> 101 or x.aqpb067btop <> 354)
         and x.aqpb067best <> 'D';
    exception
      when others then
        lx_fae1 := 0;
    end;
  --fae2
    begin
      select 1  --count(*)  kvalenciac 21/12/2022
        into lx_fae2
        from aqpb067b x
       where x.aqpb067bcod = pn_cod
         and x.aqpb067bmda = pn_mda
         and x.aqpb067bcta = pn_cta
         and x.aqpb067bope = pn_ope
         and x.aqpb067bmod = 101
         and x.aqpb067btop = 354
         and x.aqpb067best <> 'D'
         and rownum = 1;
    exception
      /* 2025.02.27 dcastro se comento llamada a tabla antigua aqpb422
      when no_data_found then
       begin
            select count(*)
            into lx_fae2
            from aqpb422 b
             where b.aqpb422emp = pn_cod
             and b.aqpb422mda = pn_mda
             and b.aqpb422cta = pn_cta
             and b.aqpb422ope = pn_ope;
        exception 
          when others then
                 lx_fae2 := 0;
         end;*/
         
         when others then
           lx_fae2 := 0;
    end;
  ---covid gobierno
  --inicio 21/12/2022 kvalenciac
    begin
      select 1
        into lx_gob
        from aqpb095b a
       where a.aqpb095bcod = pn_cod    
         and a.aqpb095bmda = pn_mda
         and a.aqpb095bcta = pn_cta
         and a.aqpb095bope = pn_ope
         and a.aqpb095best <> 'D'
         and rownum = 1;
    exception
      when no_data_found then
         --fin 21/12/2022 kvalenciac 
          begin
            select count(*)
              into lx_gob
              from aqpa840 a
             where a.aqpa840emp = pn_cod
             --  and a.aqpa840mod = pn_mod
             --  and a.aqpa840suc = pn_suc
               and a.aqpa840mda = pn_mda
             --  and a.aqpa840pap = pn_pap
               and a.aqpa840cta = pn_cta
               and a.aqpa840ope = pn_ope
             --  and a.aqpa840sbo = pn_sbo
             --  and a.aqpa840top = pn_top
               and a.aqpa840tip = 2
               and a.aqpa840est = 'C';
          exception
            when others then
              lx_gob := 0;
          end;          
     end;
    --- Verificas si es Fae Texco
    ln_Faex:= 0;
    --inicio 15/06/2023 kvalenciac
    begin
      select 1
        into ln_Faex
        from aqpc360b a
       where a.aqpc360bcod = pn_cod    
         --and a.aqpc360bmda = pn_mda
         and a.aqpc360bcta = pn_cta
         and a.aqpc360bope = pn_ope
         and a.aqpc360best <> 'D'
         and rownum = 1;
    exception
       when others then
              ln_Faex := 0;
    end;
    --fin 15/06/2023 kvalenciac
     --inicio 30/10/2023 kvalenciac   
        ---Impulso
        ln_Impulsa:= 0;
          begin
          select 1
            into ln_Impulsa
            from Aqpc366b a
           where aqpc366bcod = pn_cod    
           --   and a.aqpc360bmda = pn_mda
             and a.Aqpc366bcta = pn_cta
             and a.Aqpc366bope = pn_ope
             and a.Aqpc366best <> 'D'
             and rownum = 1;
           exception
           when others then
                  ln_Impulsa := 0;
           end;        
       --fin 30/10/2023 kvalenciac
    -- Verificación de Flag
    -- pn_flag
    if lx_reac >= 1 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob=0 and lx_faea=0 and lx_faet=0 and lx_paem=0 and ln_Faex=0 and ln_Impulsa=0 then
      pn_flag := 'R';
    elsif lx_reac = 0 and lx_crec >= 1 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob=0 and lx_faea=0 and lx_faet=0 and lx_paem=0  and ln_Faex=0 and ln_Impulsa=0 then
      pn_flag := 'C';
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 >= 1 and lx_fae2 = 0 and lx_gob=0 and lx_faea=0 and lx_faet=0 and lx_paem=0  and ln_Faex=0 and ln_Impulsa=0 then
      pn_flag := 'F1';
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 >= 1 and lx_gob=0 and lx_faea=0 and lx_faet=0 and lx_paem=0  and ln_Faex=0 and ln_Impulsa=0 then
      pn_flag := 'F2';
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob >=1 and lx_faea=0 and lx_faet=0 and lx_paem=0  and ln_Faex=0 and ln_Impulsa=0 then
      pn_flag := 'G';
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea>=1 and lx_faet=0 and lx_paem=0  and ln_Faex=0 and ln_Impulsa=0 then  --  09/12/2021 kdvc
      pn_flag := 'FA'; --  09/12/2021 kdvc
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea=0 and lx_faet>=1 and lx_paem=0  and ln_Faex=0 and ln_Impulsa=0 then --  09/12/2021 kdvc
      pn_flag := 'FT'; --  09/12/2021 kdvc
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea=0 and lx_faet=0 and lx_paem>=1  and ln_Faex=0 and ln_Impulsa=0 then --  09/12/2021 kdvc
      pn_flag := 'PM'; --  09/12/2021 kdvc
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea=0 and lx_faet=0 and lx_paem=0  and ln_Faex>=1 and ln_Impulsa=0 then --  15/06/2023 kdvc
      pn_flag := 'FX'; -- 15/06/2023 kdvc
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea=0 and lx_faet=0 and lx_paem=0  and ln_Faex=0 and ln_Impulsa>=1 then --  30/10/2023 kdvc
     pn_flag := 'I'; -- 30/10/2023 kdvc  
    else     
      pn_flag := 'N';
    end if;
    /*
    ¿	R: el crédito pertenece al Fondo Reactiva.
    ¿	C: el crédito pertenece al Fondo Crecer.
    ¿	F1: el crédito pertenece al Fondo FAE 1.
    ¿	F2: el crédito pertenece al Fondo FAE 2.
    ¿ G: Gobierno
      FA: Fae Agrario
      FT: Fae Turismo
      PM: Pae mype
      FX: Fae Textil  //15/06/2023
    ¿	N: el crédito no pertenece a ningún fondo.
    */
    if (lx_gob>= 1) then
      pn_flag := 'G';
    end if;  
  end sp_verificar_cred_fondo;
  
  procedure sp_busca_honramiento(pn_cod  in number,
                                    pn_mda  in number,                                   
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_saldo out number,                                   
                                    pn_flag out varchar2) is
      
    ln_saldo number;
  begin
  ln_saldo :=0;
  pn_flag:= 'N';
    begin
      select  sum(SCSDO) 
           into ln_saldo
      from fsd011
      where PGCOD = pn_cod
        and SCRUB in ( select tp1imp1 from fst198 where tp1cod=1 and tp1cod1=11123 and tp1corr1=6 and tp1corr2=1 and tp1corr3>=1 )--kvalenciac 15/06/2023
        and SCMDA = pn_mda
        and SCCTA = pn_cta
        and SCOPER= pn_ope;
       exception
      when others then
        ln_saldo := 0;
    end;
    pn_saldo := ln_saldo;
    if ( ln_saldo < 0 ) then
      ln_saldo:=ln_saldo*-1;
    end if;
    if (ln_saldo>0) then
      pn_flag:= 'S';
    end if;
   end sp_busca_honramiento;
   
   procedure sp_saldos_honramiento(pn_cod   in number,                                                                       
                                    pn_mda   in number,                                    
                                    pn_cta   in number,
                                    pn_ope   in number,                                   
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_flag out varchar2) is
    pn_interesc number;
    begin
      
    begin
      select /*+index (fsd011 FSD01110)*/ sum(SCSDO) 
           into pn_monto
      from fsd011
      where PGCOD = pn_cod
        and SCRUB in ( select /*+index (FSI006 SYS_C0080890)*/rubro from fsi006 where cicpo = 'MHONRAM')  --rubros del monto de honramiento
        and SCMDA = pn_mda
        and SCCTA = pn_cta
        and SCOPER= pn_ope;
    exception
      when others then
        pn_monto := 0;
    end;    
    if ( pn_monto < 0 ) then
      pn_monto:=pn_monto*-1;
    end if;
    ---------------
    begin
      select /*+index (fsd011 FSD01110)*/  sum(SCSDO) 
           into pn_gasto
      from fsd011
      where PGCOD = pn_cod
        and SCRUB in ( select /*+index (fsi006 SYS_C0080890)*/rubro from fsi006 where cicpo = 'GHONRAM')  --rubros de gastos de honramiento
        and SCMDA = pn_mda
        and SCCTA = pn_cta
        and SCOPER= pn_ope;
    exception
      when others then
        pn_gasto := 0;
    end;    
    if ( pn_gasto < 0 ) then
      pn_gasto:=pn_gasto*-1;
    end if;
    --------
     begin
      select /*+index (fsd011 FSD01110)*/  sum(SCSDO) 
           into pn_interes
      from fsd011
      where PGCOD = pn_cod
        and SCRUB in ( select /*+index (fsi006 SYS_C0080890)*/rubro from fsi006 where cicpo = 'IHONRAM')  --rubros del interes de honramiento
        and SCMDA = pn_mda
        and SCCTA = pn_cta
        and SCOPER= pn_ope;
    exception
      when others then
        pn_interes := 0;
    end;    
    if ( pn_interes < 0 ) then
      pn_interes:=pn_interes*-1;
    end if;
    ----inicio 07/10/2022 kvalenciac
    --------
     begin
      select /*+index (fsd011 FSD01110)*/  sum(SCSDO) 
           into pn_interesc
      from fsd011
      where PGCOD = pn_cod
        and SCRUB in ( select /*+index (fsi006 SYS_C0080890)*/rubro from fsi006 where cicpo = 'CHONRAM')  --rubros del interes compensatorio monto honramiento
        and SCMDA = pn_mda
        and SCCTA = pn_cta
        and SCOPER= pn_ope;
    exception
      when others then
        pn_interesc := 0;
    end;    
    if ( pn_interesc < 0 ) then
      pn_interesc:=pn_interesc*-1;
    end if;
    ---fin 07/10/2022 kvalenciac
    ---si tiene algún monto entonces devuelve pn_flag=1 que indica que tiene algún saldo de honramiento
    pn_flag:= 'N';
    if (pn_monto>0 or pn_gasto>0  or  pn_interes>0 or  pn_interesc > 0 ) then
      pn_flag:= 'S';
    end if;
    end sp_saldos_honramiento;
    
procedure sp_saldos_honramientoi(pn_cod   in number,  ----se ha creado el 20/10/2022 kvalenciac                                                                      
                                    pn_mda   in number,                                    
                                    pn_cta   in number,
                                    pn_ope   in number,                                   
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_interesc out number,
                                    pn_flag out varchar2) is
    ln_encontro number;
    begin    
    ln_encontro :=0;

    begin
      select  1 
           into ln_encontro
      from AQPB434
      where AQPB434COD = pn_cod
        and AQPB434CTA = pn_cta
        and AQPB434OPE = pn_ope
        and AQPB434MDA = pn_mda
        and AQPB434EST= 'C';
       exception
      when others then
        ln_encontro := 0;
    end;
    
    if ( ln_encontro = 1 ) then
      
            begin
              select /*+index (fsd011 FSD01110)*/ sum(SCSDO) 
                   into pn_monto
              from fsd011
              where PGCOD = pn_cod
                and SCRUB in ( select/*+index (fsi006 SYS_C0080890)*/ rubro from fsi006 where cicpo = 'MHONRAM')  --rubros del monto de honramiento
                and SCMDA = pn_mda
                and SCCTA = pn_cta
                and SCOPER= pn_ope;
            exception
              when others then
                pn_monto := 0;
            end;    
            if ( pn_monto < 0 ) then
              pn_monto:=pn_monto*-1;
            end if;
            ---------------
            begin
              select /*+index (fsd011 FSD01110)*/  sum(SCSDO) 
                   into pn_gasto
              from fsd011
              where PGCOD = pn_cod
                and SCRUB in ( select/*+index (fsi006 SYS_C0080890)*/ rubro from fsi006 where cicpo = 'GHONRAM')  --rubros de gastos de honramiento
                and SCMDA = pn_mda
                and SCCTA = pn_cta
                and SCOPER= pn_ope;
            exception
              when others then
                pn_gasto := 0;
            end;    
            if ( pn_gasto < 0 ) then
              pn_gasto:=pn_gasto*-1;
            end if;
            --------
             begin
              select /*+index (fsd011 FSD01110)*/  sum(SCSDO) 
                   into pn_interes
              from fsd011
              where PGCOD = pn_cod
                and SCRUB in ( select /*+index (fsi006 SYS_C0080890)*/rubro from fsi006 where cicpo = 'IHONRAM')  --rubros del interes de honramiento
                and SCMDA = pn_mda
                and SCCTA = pn_cta
                and SCOPER= pn_ope;
            exception
              when others then
                pn_interes := 0;
            end;    
            if ( pn_interes < 0 ) then
              pn_interes:=pn_interes*-1;
            end if;
            ----inicio 07/10/2022 kvalenciac
            --------
             begin
              select /*+index (fsd011 FSD01110)*/  sum(SCSDO) 
                   into pn_interesc
              from fsd011
              where PGCOD = pn_cod
                and SCRUB in ( select/*+index (fsi006 SYS_C0080890)*/ rubro from fsi006 where cicpo = 'CHONRAM')  --rubros del interes compensatorio monto honramiento
                and SCMDA = pn_mda
                and SCCTA = pn_cta
                and SCOPER= pn_ope;
            exception
              when others then
                pn_interesc := 0;
            end;    
            if ( pn_interesc < 0 ) then
              pn_interesc:=pn_interesc*-1;
            end if;
            ---fin 07/10/2022 kvalenciac
            ---si tiene algún monto entonces devuelve pn_flag=1 que indica que tiene algún saldo de honramiento
    end if;
    pn_flag:= 'N';
    if (pn_monto>0 or pn_gasto>0  or  pn_interes>0 or  pn_interesc > 0 ) then
      pn_flag:= 'S';
    end if;
    end sp_saldos_honramientoi;    
procedure sp_es_honrado(pn_cod  in number,
                                    pn_mda  in number,                                   
                                    pn_cta  in number,
                                    pn_ope  in number,                                                                      
                                    pn_flag out varchar2) is
      
    ln_encontro number;
  begin
  ln_encontro :=0;
  pn_flag:= 'N';
    begin
      select  1 
           into ln_encontro
      from AQPB434
      where AQPB434COD = pn_cod
        and AQPB434CTA = pn_cta
        and AQPB434OPE = pn_ope
        and AQPB434MDA = pn_mda
        and AQPB434EST= 'C';
       exception
      when others then
        ln_encontro := 0;
    end;
    
    if ( ln_encontro = 1 ) then
      pn_flag:='S';
    else
      pn_flag:='N';
    end if;
    
   end sp_es_honrado;                             
   procedure sp_verificar_cred_fondoc(pn_cod  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number,                                                                   
                                    pn_flag out varchar2
                                    ) is
    cursor creditos is
    select * 
    from  fsd011
    where sccta= pn_cta
    and scmod in (select modulo from fst111 where dscod=50)
    and scstat<>99;
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
    lx_gob number;
    lx_faea number;
    lx_faet number;
    lx_paem number;
    ln_r1mod number;
    ln_r1tope number;
    ln_Faex number;
    ln_Impulsa number;
  begin
  -- busco crédito origen  inicio 09/12/2021   Karen Valenciac
  -- -- -- -- -- -- -- -- -        
  for c in creditos loop
     begin
         select r1mod,r1tope into ln_r1mod,ln_r1tope 
         from fsr011
         where R2COD = c.pgcod
           --and R2MOD = pn_mod 
           and R2SUC = c.scsuc
           and R2MDA = c.scmda
           and R2PAP = c.scpap
           and R2CTA = c.sccta
           and R2OPER =c.scoper
           and R2SBOP =c.scsbop
           and RELCOD = 52;
       exception 
          when others then
              ln_r1mod := pn_mod;
              ln_r1tope := pn_top;
     end; 
      -- inicio  09/12/2021 kdvc
        lx_faea := 0;
        lx_faet := 0;
        lx_paem := 0;
      --fae agro 
      begin     --inicio 27/05/2022 kvalenciac           
          /*select count(*)
            into lx_faea
            from aqpb379b x
           where x.aqpb379bcod = c.pgcod       
             and x.aqpb379bcta = c.sccta
             and x.aqpb379best <> 'D'
             and rownum = 1;*/
             --inicio 03/06/2022 kvalenciac  
           select  1 --count(*)  kvalenciac 21/12/2022
            into lx_faea
            from aqpb379b x
            inner join fsd010 f on f.PGCOD=x.aqpb379bcod and f.aoCTA=x.aqpb379bcta        
            where f.PGCOD = c.pgcod
              and f.aoCTA = c.sccta
              and f.aoOPER= c.scoper  --11365218
              and f.aomod  = 116  --117  13/07/2022 kvalenciac
              and f.aotope = 20
              and x.aqpb379best <> 'D';
             --fin 03/06/2022 kvalenciac  
        exception   --fin 27/05/2022 kvalenciac
          when no_data_found then
            if ( ln_r1mod = 116 and ln_r1tope=20 ) then
              --lx_faea := 1;
              --inicio 06/03/2023 kvalenciac  
            begin
             select  count(*)
              into lx_faea
              from aqpb379b x
              inner join fsd010 f on f.PGCOD=x.aqpb379bcod and f.aoCTA=x.aqpb379bcta        
              where f.PGCOD = pn_cod
                and f.aoCTA = pn_cta
                and f.aoOPER= pn_ope  
                and f.aomda = pn_mda 
                and f.aomod  = ln_r1mod  
                and f.aotope = ln_r1tope
                and x.aqpb379best <> 'D';
              exception 
              when no_data_found then
                  lx_faea:=0;
             end; 
              if (lx_faea>0) then
                 lx_faea:=1;
              end if;              
              --fin 06/03/2023 kvalenciac
            end if;
                
       end;
      --fodno fae turismo
       begin    --inicio 27/05/2022 kvalenciac
          select 1 --count(*)  kvalenciac 21/12/2022
            into lx_faet
            from aqpb762b x
           where x.aqpb762bcod  = c.pgcod         
             and x.aqpb762bccta = c.sccta
             and x.aqpb762boper = c.scoper     
             and x.aqpb762best <> 'D'
             and rownum = 1;
        exception    --fin 27/05/2022 kvalenciac
          when no_data_found then
            lx_faet:=0;
            /*if ( ln_r1mod = 101 and ln_r1tope=355 ) then
              lx_faet := 1;
            end if;*/
        end;
      --fondo pae mype
      begin    --inicio 27/05/2022 kvalenciac
          select 1 --count(*)  kvalenciac 21/12/2022
            into lx_paem
            from aqpb394b x
           where x.aqpb394bcod = c.pgcod        
             and x.aqpb394bcta = c.sccta
             and x.aqpb394bope = c.scoper    
             and x.aqpb394best <> 'D'
             and rownum = 1;
        exception   --fin 27/05/2022 kvalenciac
          when no_data_found then 
            lx_paem:=0;
          /*if ( ln_r1mod = 101 and ln_r1tope=356 ) then
            lx_paem := 1;
          end if;*/
        end;
      -- fin 09/12/2021 kdvc
      
      --reactiva
        begin
          select 1
            into lx_reac
            from aqpb065b x
           where x.aqpb065bcod = c.pgcod
             and x.aqpb065bcta = c.sccta
             and x.aqpb065bope = c.scoper 
             and x.aqpb065best <> 'D'
             and rownum = 1;
        exception
          when no_data_found then
             begin
              select 1
              into lx_reac
              from aqpb428 b
               where b.aqpb428emp = c.pgcod
                 and b.aqpb428cta = c.sccta
                 and b.aqpb428ope = c.scoper 
                 and rownum = 1;
            exception 
              when others then
                  lx_reac := 0;
             end;
        end;
      --crecer
        begin
          select count(*)
            into lx_crec
            from aqpb073b x
           where x.aqpb073bcod = c.pgcod
             and x.aqpb073bcta = c.sccta
             and x.aqpb073bope = c.scoper 
             and x.aqpb073best <> 'D';
        exception
          when others then
            lx_crec := 0;
        end;
      ---fae1
        begin
          select count(*)
            into lx_fae1
            from aqpb067b x
           where x.aqpb067bcod = c.pgcod
             and x.aqpb067bcta = c.sccta
             and x.aqpb067bope = c.scoper 
             and (x.aqpb067bmod <> 101 or x.aqpb067btop <> 354)
             and x.aqpb067best <> 'D';
        exception
          when others then
            lx_fae1 := 0;
        end;
      --fae2
        begin
          select 1
            into lx_fae2
            from aqpb067b x
           where x.aqpb067bcod = c.pgcod
             and x.aqpb067bcta = c.sccta
             and x.aqpb067bope = c.scoper 
             and x.aqpb067bmod = 101
             and x.aqpb067btop = 354
             and x.aqpb067best <> 'D'
             and rownum = 1;
        exception
          when no_data_found then
            begin
              select count(*)
              into lx_fae2
              from aqpb422 b
               where b.aqpb422emp = c.pgcod
                 and b.aqpb422cta = c.sccta
                 and b.aqpb422ope = c.scoper ;
            exception 
              when others then
                     lx_fae2 := 0;
             end;
        end;
      ---covid gobierno
      --inicio 21/12/2022 kvalenciac
        begin
          select 1
            into lx_gob
            from aqpb095b a
           where a.aqpb095bcod = c.pgcod   
             and a.aqpb095bmda = c.scmda
             and a.aqpb095bcta = c.sccta 
             and a.aqpb095bope = c.scoper
             and a.aqpb095best <> 'D'
             and rownum = 1;
        exception
          when no_data_found then
             --fin 21/12/2022 kvalenciac 
              begin
                select count(*)
                  into lx_gob
                  from aqpa840 a
                 where a.aqpa840emp = c.pgcod
                   and a.aqpa840cta = c.sccta
                   and a.aqpa840ope = c.scoper 
                   and a.aqpa840tip = 2
                   and a.aqpa840est = 'C';
               exception
                when others then
                  lx_gob := 0;
               end;
        end;
         --- Verificas si es Fae Texco
        ln_Faex:= 0;
        --inicio 15/06/2023 kvalenciac
        begin
          select 1
            into ln_Faex
            from aqpc360b a
           where a.aqpc360bcod = pn_cod    
          --   and a.aqpc360bmda = pn_mda
             and a.aqpc360bcta = pn_cta
             and a.aqpc360bope = pn_ope
             and a.aqpc360best <> 'D'
             and rownum = 1;
        exception
           when others then
                  ln_Faex := 0;
        end;
        --fin 15/06/2023 kvalenciac   
        --inicio 30/10/2023 kvalenciac   
        ---Impulso
        ln_Impulsa:= 0;
          begin
          select 1
            into ln_Impulsa
            from Aqpc366b a
           where aqpc366bcod = pn_cod    
           --   and a.aqpc360bmda = pn_mda
             and a.Aqpc366bcta = pn_cta
             and a.Aqpc366bope = pn_ope
             and a.Aqpc366best <> 'D'
             and rownum = 1;
           exception
           when others then
                  ln_Impulsa := 0;
           end;        
       --fin 30/10/2023 kvalenciac
       
       -- Verificación de Flag
        -- pn_flag
        if lx_reac >= 1 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob=0 and lx_faea=0 and lx_faet=0 and lx_paem=0 and ln_Faex=0 and ln_Impulsa=0 then
          pn_flag := 'R';
        elsif lx_reac = 0 and lx_crec >= 1 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob=0 and lx_faea=0 and lx_faet=0 and lx_paem=0 and ln_Faex=0 and ln_Impulsa=0 then
          pn_flag := 'C';
        elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 >= 1 and lx_fae2 = 0 and lx_gob=0 and lx_faea=0 and lx_faet=0 and lx_paem=0 and ln_Faex=0 and ln_Impulsa=0 then
          pn_flag := 'F1';
        elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 >= 1 and lx_gob=0 and lx_faea=0 and lx_faet=0 and lx_paem=0 and ln_Faex=0 and ln_Impulsa=0 then
          pn_flag := 'F2';
        elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob >=1 and lx_faea=0 and lx_faet=0 and lx_paem=0 and ln_Faex=0 and ln_Impulsa=0 then
          pn_flag := 'G';
        elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea>=1 and lx_faet=0 and lx_paem=0 and ln_Faex=0 and ln_Impulsa=0 then  --   09/12/2021 kdvc
          pn_flag := 'FA';
        elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea=0 and lx_faet>=1 and lx_paem=0 and ln_Faex=0 and ln_Impulsa=0 then  --   09/12/2021 kdvc
          pn_flag := 'FT';
        elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea=0 and lx_faet=0 and lx_paem>=1 and ln_Faex=0 and ln_Impulsa=0 then  --   09/12/2021 kdvc
          pn_flag := 'PM';
        elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea=0 and lx_faet=0 and lx_paem=0  and ln_Faex>=1 and ln_Impulsa=0 then --  15/06/2023 kdvc
          pn_flag := 'FX'; -- 15/06/2023 kdvc
        elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 and lx_gob =0 and lx_faea=0 and lx_faet=0 and lx_paem=0  and ln_Faex=0 and ln_Impulsa>=1 then --  30/10/2023 kdvc
          pn_flag := 'I'; -- 30/10/2023 kdvc           
        else
          pn_flag := 'N';
        end if;
        /*
        ¿	R: el crédito pertenece al Fondo Reactiva.
        ¿	C: el crédito pertenece al Fondo Crecer.
        ¿	F1: el crédito pertenece al Fondo FAE 1.
        ¿	F2: el crédito pertenece al Fondo FAE 2.
        ¿ G: Gobierno
          FA: Fae Agrario
          FT: Fae Turismo
          PM: Pae mype
          FX: Fae Texco
        ¿	N: el crédito no pertenece a ningún fondo.
        */
        if (lx_gob>= 1) then
          pn_flag := 'G';
        end if;
        if ( pn_flag <> 'N')  then
          exit;
        end if;        
     end loop;
  end sp_verificar_cred_fondoc;
  
   
   procedure sp_saldos_honramientoc(pn_cod   in number,                                                                       
                                   -- pn_mda   in number,                                    
                                    pn_cta   in number,                                                                    
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_flag out varchar2) is
   pn_interesc number;
    begin
    begin
      select  sum(SCSDO) 
           into pn_monto
      from fsd011
      where PGCOD = pn_cod
        and SCRUB in ( select rubro from fsi006 where cicpo = 'MHONRAM')  --rubros del monto de honramiento
       -- and SCMDA = pn_mda
        and SCCTA = pn_cta;
       -- and SCOPER= pn_ope;
    exception
      when others then
        pn_monto := 0;
    end;    
    if ( pn_monto < 0 ) then
      pn_monto:=pn_monto*-1;
    end if;
    ---------------
    begin
      select   sum(SCSDO) 
           into pn_gasto
      from fsd011
      where PGCOD = pn_cod
        and SCRUB in ( select rubro from fsi006 where cicpo = 'GHONRAM')  --rubros de gastos de honramiento
       --- and SCMDA = pn_mda
        and SCCTA = pn_cta;
        --and SCOPER= pn_ope;
    exception
      when others then
        pn_gasto := 0;
    end;    
    if ( pn_gasto < 0 ) then
      pn_gasto:=pn_gasto*-1;
    end if;
    --------
     begin
      select   sum(SCSDO) 
           into pn_interes
      from fsd011
      where PGCOD = pn_cod
        and SCRUB in ( select rubro from fsi006 where cicpo = 'IHONRAM')  --rubros del interes de honramiento
        --and SCMDA = pn_mda
        and SCCTA = pn_cta;
       -- and SCOPER= pn_ope;
    exception
      when others then
        pn_interes := 0;
    end; 
     if ( pn_interes < 0 ) then
      pn_interes:=pn_interes*-1;
    end if;
    -------------------------------------------------
    ----inicio 20/10/2022 kvalenciac
    --------
     begin
      select   sum(SCSDO) 
           into pn_interesc
      from fsd011
      where PGCOD = pn_cod
        and SCRUB in ( select rubro from fsi006 where cicpo = 'CHONRAM')  --rubros del interes compensatorio monto honramiento
      --  and SCMDA = pn_mda
        and SCCTA = pn_cta;
      --  and SCOPER= pn_ope;
    exception
      when others then
        pn_interesc := 0;
    end;    
    if ( pn_interesc < 0 ) then
      pn_interesc:=pn_interesc*-1;
    end if;
    ---fin 20/10/2022 kvalenciac
    ------------------------------------------------      
    ---si tiene algún monto entonces devuelve pn_flag=1 que indica que tiene algún saldo de honramiento
    pn_flag:= 'N';
    if ( pn_monto>0 or pn_gasto>0  or  pn_interes>0 or pn_interesc>0 ) then
      pn_flag:= 'S';
    end if;
    end sp_saldos_honramientoc;
procedure sp_es_honradoc(pn_cod  in number,
                                    pn_cta  in number,                                                                                                         
                                    pn_flag out varchar2) is
      
    ln_encontro number;
  begin
  ln_encontro :=0;
  pn_flag:= 'N';
    begin
      select  1 
           into ln_encontro
      from AQPB434
      where AQPB434COD = pn_cod
       and AQPB434CTA = pn_cta
      --  and AQPB434OPE = pn_ope
       -- and AQPB434MDA = pn_mda
        and AQPB434EST= 'C'
        and rownum=1;
       exception
      when others then
        ln_encontro := 0;
    end;
    
    if ( ln_encontro = 1 ) then
      pn_flag:='S';
    else
      pn_flag:='N';
    end if;
    
   end sp_es_honradoc;  
   
procedure sp_saldohonrado_castigado(pn_cod   in number,                                                                       
                                    pn_mda   in number,                                    
                                    pn_cta   in number,
                                    pn_ope   in number,                                   
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_flag out varchar2) is
    pn_interesc number;
    begin
    begin
      select  jaql175mnthc,jaql175gashc,jaql175inthc,jaql175intchc
           into pn_monto,pn_gasto,pn_interes,pn_interesc
      from jaql175
      where jaql175emp = pn_cod
        and jaql175cta = pn_cta
        and jaql175ope = pn_ope
        and jaql175mda = pn_mda
        and jaql175itc='S';
    exception
      when others then
        pn_monto  :=0;
        pn_gasto  :=0;
        pn_interes:=0;
    end;    
    if ( pn_monto < 0 ) then
      pn_monto:=pn_monto*-1;
    end if;
    if ( pn_gasto < 0 ) then
      pn_gasto:=pn_gasto*-1;
    end if;
    if ( pn_interes < 0 ) then
      pn_interes:=pn_interes*-1;
    end if;
    if ( pn_interesc < 0 ) then
      pn_interesc:=pn_interesc*-1;
    end if;
    ---si tiene algún monto entonces devuelve pn_flag=1 que indica que tiene algún saldo de honramiento
    pn_flag:= 'N';
    if (pn_monto>0 or pn_gasto>0  or  pn_interes>0 or  pn_interesc>0) then
      pn_flag:= 'S';
    end if;
end sp_saldohonrado_castigado; 
procedure sp_saldohonrado_castigado2(pn_cod   in number,                                                                       
                                    pn_mda   in number,                                    
                                    pn_cta   in number,
                                    pn_ope   in number,                                   
                                    pn_monto out number,
                                    pn_gasto out number,
                                    pn_interes out number,
                                    pn_interesc out number,
                                    pn_flag out varchar2) is
    begin
    begin
      select  jaql175mnthc,jaql175gashc,jaql175inthc,jaql175intchc
           into pn_monto,pn_gasto,pn_interes,pn_interesc
      from jaql175
      where jaql175emp = pn_cod
        and jaql175cta = pn_cta
        and jaql175ope = pn_ope
        and jaql175mda = pn_mda
        and jaql175itc='S';
    exception
      when others then
        pn_monto  :=0;
        pn_gasto  :=0;
        pn_interes:=0;
    end;    
    if ( pn_monto < 0 ) then
      pn_monto:=pn_monto*-1;
    end if;
    if ( pn_gasto < 0 ) then
      pn_gasto:=pn_gasto*-1;
    end if;
    if ( pn_interes < 0 ) then
      pn_interes:=pn_interes*-1;
    end if;
    if ( pn_interesc < 0 ) then
      pn_interesc:=pn_interesc*-1;
    end if;
    ---si tiene algún monto entonces devuelve pn_flag=1 que indica que tiene algún saldo de honramiento
    pn_flag:= 'N';
    if (pn_monto>0 or pn_gasto>0  or  pn_interes>0 or  pn_interesc>0) then
      pn_flag:= 'S';
    end if;
end sp_saldohonrado_castigado2;                              
                             
end pq_cr_creditos_fondoscovid;
/

