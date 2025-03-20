create or replace procedure SP_SALDO_ACTUAL(vpgcod  number,
                                            vScsuc  number,
                                            vsccta  number,
                                            vScmda  number,
                                            vScpap  number,
                                            vScoper number,
                                            vScsbop number,
                                            vSctope number,
                                            vScmod  number,
                                            tipo    number,
                                            vsaldo  out number) is

  -- tipo 1 total, 2 dispo                                            

  cursor guia_21 is
    select Tp1nro1, Tp1nro2, Tp1nro3, Tp1imp1, Tp1imp2
      from fst198
     Where Tp1cod = vpgcod
       and Tp1cod1 = 10822
       and Tp1corr1 = 2
       and Tp1corr2 = decode(tipo,1,2,3);

  vmodulo number;

  cursor sal is
    select scsdo, scrub
      from FSD011
     Where PgCod = vPgcod
       and Scmod = vmodulo
       and Scmda = vscmda
       and Scpap = vscpap
       and Sccta = vsccta
       and Scsuc = vscsuc
       and Scoper = decode(vscmod, 22, vScoper, scoper)
       and Scsbop = vScsbop
       and Sctope = decode(vmodulo, 21, vSctope, sctope);

  cursor che is
    select *
      from fsr111
     Where I2cod = vPgcod
       and I2mod = vScmod
       and I2suc = vScsuc
       and I2mda = vScmda
       and I2pap = vScpap
       and I2cta = vSccta
       and I2oper = vScoper
       and I2sbop = vScsbop
       and I2tope = vSctope
       and Inscod = 3
       and I1cod = vPgcod
       and I1mod = vmodulo
       and R111co = 'S'
       and R111fc >= (trunc(sysdate) - 40);

  cursor guia_22 is
    select *
      from fst198
     Where Tp1cod = vPgcod
       and Tp1cod1 = 10822
       and Tp1corr1 = 1
       and Tp1corr2 = 8
       and nvl(tp1nro3, 0) = decode(tipo, 2, 1, nvl(tp1nro3, 0));

  vsalche number := 0;
  vtipoc  number;
  vScrub  number;

begin

  vsaldo := 0;

  if vscmod = 21 then
    for i in guia_21 loop
    
      vmodulo := i.Tp1nro1;
    
      if i.Tp1nro3 = 0 then
      
        for j in sal loop
        
          If i.Tp1imp1 = 0 or j.Scrub = i.Tp1imp1 or j.Scrub = i.Tp1imp2 then
            If i.Tp1nro2 = 1 then
              vsaldo := vsaldo + j.Scsdo;
            Else
              vsaldo := vsaldo - j.Scsdo;
            End If;
          End If;
        End Loop;
      
      Else
        for k in che loop
          select scsdo, scrub
            into vsalche, vScrub
            from FSD011
           Where PgCod = vPgcod
             and Scmod = k.I1mod
             and Scmda = k.I1mda
             and Scpap = k.I1pap
             and Sccta = k.I1cta
             and Scsuc = k.I1suc
             and Scoper = k.I1oper
             and Scsbop = k.I1sbop
             and Sctope = k.I1tope;
        
          sp_tipo_cambio(k.R111fc, k.I1mda, vScmda, 500, vTipoC);
        
          If vScmda <> k.I1mda then
            If vScmda = 0 then
              vsalche := vsalche * vTipoC;
            Else
              vsalche := vsalche / vTipoC;
            End If;
          End If;
        
          If i.Tp1imp1 = 0 or vScrub = i.Tp1imp1 or vScrub = i.Tp1imp2 then
            If i.Tp1nro2 = 1 then
              vsaldo := vsaldo + vsalche;
            Else
              vsaldo := vsaldo - vsalche;
            End If;
          End If;
        end loop;
      end if;
    end loop;
  
  else
    for i in guia_22 loop
      vmodulo := i.Tp1nro1;
      for j in sal loop
        If i.Tp1nro2 = 1 then
          vsaldo := vsaldo + j.Scsdo;
        Else
          vsaldo := vsaldo - j.Scsdo;
        End If;
      End Loop;
    End Loop;
  
  end if;

end SP_SALDO_ACTUAL;
/

