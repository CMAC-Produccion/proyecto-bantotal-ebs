create or replace package pq_cr_creditos_fondos is
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
                             
  function fn_verificar_cred_fondo(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number
                             ) return varchar2;                             
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end pq_cr_creditos_fondos;
/

create or replace package body pq_cr_creditos_fondos is

  /* ************************************************************************************************************
      -- Nombre                     : Verificación de créditos de fondos
      -- Sistema                    : BANTOTAL
      -- Versión                    : 1.0
      -- Fecha de Creación          : 02/03/2021
      -- Autor de Creación          : Juan Fernando Rodríguez Mamani
      -- Versión                    : 
      -- Fecha de Modificación      : 
      -- Autor de la Modificación   : 
      -- Descripción de Modificación: 
      --                                 
      --
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
  
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
  
  begin
  
    begin
      select count(*)
        into lx_reac
        from aqpb065b x
       where x.aqpb065bcod = pn_cod
         and x.aqpb065bmod = pn_mod
         and x.aqpb065bsuc = pn_suc
         and x.aqpb065bmda = pn_mda
         and x.aqpb065bpap = pn_pap
         and x.aqpb065bcta = pn_cta
         and x.aqpb065bope = pn_ope
         and x.aqpb065bsbo = pn_sbo
         and x.aqpb065btop = pn_top
         and x.aqpb065best <> 'D';
    exception
      when others then
        lx_reac := 0;
    end;
  
    begin
      select count(*)
        into lx_crec
        from aqpb073b x
       where x.aqpb073bcod = pn_cod
         and x.aqpb073bmod = pn_mod
         and x.aqpb073bsuc = pn_suc
         and x.aqpb073bmda = pn_mda
         and x.aqpb073bpap = pn_pap
         and x.aqpb073bcta = pn_cta
         and x.aqpb073bope = pn_ope
         and x.aqpb073bsbo = pn_sbo
         and x.aqpb073btop = pn_top
         and x.aqpb073best <> 'D';
    exception
      when others then
        lx_crec := 0;
    end;
  
    begin
      select count(*)
        into lx_fae1
        from aqpb067b x
       where x.aqpb067bcod = pn_cod
         and x.aqpb067bmod = pn_mod
         and x.aqpb067bsuc = pn_suc
         and x.aqpb067bmda = pn_mda
         and x.aqpb067bpap = pn_pap
         and x.aqpb067bcta = pn_cta
         and x.aqpb067bope = pn_ope
         and x.aqpb067bsbo = pn_sbo
         and x.aqpb067btop = pn_top
         and (x.aqpb067bmod <> 101 or x.aqpb067btop <> 354)
         and x.aqpb067best <> 'D';
    exception
      when others then
        lx_fae1 := 0;
    end;
  
    begin
      select count(*)
        into lx_fae2
        from aqpb067b x
       where x.aqpb067bcod = pn_cod
         and x.aqpb067bmod = pn_mod
         and x.aqpb067bsuc = pn_suc
         and x.aqpb067bmda = pn_mda
         and x.aqpb067bpap = pn_pap
         and x.aqpb067bcta = pn_cta
         and x.aqpb067bope = pn_ope
         and x.aqpb067bsbo = pn_sbo
         and x.aqpb067btop = pn_top
         and x.aqpb067bmod = 101
         and x.aqpb067btop = 354
         and x.aqpb067best <> 'D';
    exception
      when others then
        lx_fae2 := 0;
    end;
  
    -- Verificación de Flag
    -- pn_flag
    if lx_reac >= 1 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 then
      pn_flag := 'R';
    elsif lx_reac = 0 and lx_crec >= 1 and lx_fae1 = 0 and lx_fae2 = 0 then
      pn_flag := 'C';
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 >= 1 and lx_fae2 = 0 then
      pn_flag := 'F';
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 >= 1 then
      pn_flag := 'G';
    else
      pn_flag := 'N';
    end if;
  
  end sp_verificar_cred_fondo;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_verificar_cred_fondo(pn_cod  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number
                                    ) return varchar2 is
  
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
    pn_flag varchar2(1);
  
  begin
  
    begin
      select count(*)
        into lx_reac
        from aqpb065b x
       where x.aqpb065bcod = pn_cod
         and x.aqpb065bmod = pn_mod
         and x.aqpb065bsuc = pn_suc
         and x.aqpb065bmda = pn_mda
         and x.aqpb065bpap = pn_pap
         and x.aqpb065bcta = pn_cta
         and x.aqpb065bope = pn_ope
         and x.aqpb065bsbo = pn_sbo
         and x.aqpb065btop = pn_top
         and x.aqpb065best <> 'D';
    exception
      when others then
        lx_reac := 0;
    end;
  
    begin
      select count(*)
        into lx_crec
        from aqpb073b x
       where x.aqpb073bcod = pn_cod
         and x.aqpb073bmod = pn_mod
         and x.aqpb073bsuc = pn_suc
         and x.aqpb073bmda = pn_mda
         and x.aqpb073bpap = pn_pap
         and x.aqpb073bcta = pn_cta
         and x.aqpb073bope = pn_ope
         and x.aqpb073bsbo = pn_sbo
         and x.aqpb073btop = pn_top
         and x.aqpb073best <> 'D';
    exception
      when others then
        lx_crec := 0;
    end;
  
    begin
      select count(*)
        into lx_fae1
        from aqpb067b x
       where x.aqpb067bcod = pn_cod
         and x.aqpb067bmod = pn_mod
         and x.aqpb067bsuc = pn_suc
         and x.aqpb067bmda = pn_mda
         and x.aqpb067bpap = pn_pap
         and x.aqpb067bcta = pn_cta
         and x.aqpb067bope = pn_ope
         and x.aqpb067bsbo = pn_sbo
         and x.aqpb067btop = pn_top
         and (x.aqpb067bmod <> 101 or x.aqpb067btop <> 354)
         and x.aqpb067best <> 'D';
    exception
      when others then
        lx_fae1 := 0;
    end;
  
    begin
      select count(*)
        into lx_fae2
        from aqpb067b x
       where x.aqpb067bcod = pn_cod
         and x.aqpb067bmod = pn_mod
         and x.aqpb067bsuc = pn_suc
         and x.aqpb067bmda = pn_mda
         and x.aqpb067bpap = pn_pap
         and x.aqpb067bcta = pn_cta
         and x.aqpb067bope = pn_ope
         and x.aqpb067bsbo = pn_sbo
         and x.aqpb067btop = pn_top
         and x.aqpb067bmod = 101
         and x.aqpb067btop = 354
         and x.aqpb067best <> 'D';
    exception
      when others then
        lx_fae2 := 0;
    end;
  
    -- Verificación de Flag
    -- pn_flag
    if lx_reac >= 1 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 then
      pn_flag := 'R';
    elsif lx_reac = 0 and lx_crec >= 1 and lx_fae1 = 0 and lx_fae2 = 0 then
      pn_flag := 'C';
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 >= 1 and lx_fae2 = 0 then
      pn_flag := 'F';
    elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 >= 1 then
      pn_flag := 'G';
    else
      pn_flag := 'N';
    end if;
    
    return pn_flag;
  
  end fn_verificar_cred_fondo;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end pq_cr_creditos_fondos;
/

