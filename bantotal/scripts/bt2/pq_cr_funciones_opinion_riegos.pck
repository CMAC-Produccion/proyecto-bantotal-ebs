create or replace package pq_cr_funciones_opinion_riegos is

  -- Author  : ENINAH
  -- Created : 20/03/2023 15:40:36
  -- Purpose : 
  function fn_cr_tas_fecha_tasacion(p_bcemp  in number,
                                    p_bcmod  in number,
                                    p_bcsuc  in number,
                                    p_bcmda  in number,
                                    p_bcpap  in number,
                                    p_bccta  in number,
                                    p_bcoper in number,
                                    p_bcsbop in number,
                                    p_bctope in number) return date;
  function fn_cr_tas_val_comercial(p_bcemp  in number,
                                   p_bcmod  in number,
                                   p_bcsuc  in number,
                                   p_bcmda  in number,
                                   p_bcpap  in number,
                                   p_bccta  in number,
                                   p_bcoper in number,
                                   p_bcsbop in number,
                                   p_bctope in number) return number;

  function fn_cr_tas_val_realizacion(p_bcemp  in number,
                                     p_bcmod  in number,
                                     p_bcsuc  in number,
                                     p_bcmda  in number,
                                     p_bcpap  in number,
                                     p_bccta  in number,
                                     p_bcoper in number,
                                     p_bcsbop in number,
                                     p_bctope in number) return number;
                                     
  function fn_cr_tas_tipo_bien(p_bcemp  in number,
                                     p_bcmod  in number,
                                     p_bcsuc  in number,
                                     p_bcmda  in number,
                                     p_bcpap  in number,
                                     p_bccta  in number,
                                     p_bcoper in number,
                                     p_bcsbop in number,
                                     p_bctope in number) return varchar2;
                                     
  function fn_cr_tas_fecha_declaracion(p_bcemp  in number,
                                     p_bcmod  in number,
                                     p_bcsuc  in number,
                                     p_bcmda  in number,
                                     p_bcpap  in number,
                                     p_bccta  in number,
                                     p_bcoper in number,
                                     p_bcsbop in number,
                                     p_bctope in number) return date;
                                                                        
  function fn_cr_ciiu_codigo(P_PAIS   in number,
                             P_PETDOC in number,
                             P_PENDOC in char,
                             P_PETIPO in varchar2) return number
  
    parallel_enable;

  function fn_cr_tas_dato(p_bcemp  in number,
                          p_bcmod  in number,
                          p_bcsuc  in number,
                          p_bcmda  in number,
                          p_bcpap  in number,
                          p_bccta  in number,
                          p_bcoper in number,
                          p_bcsbop in number,
                          p_bctope in number) return varchar2;

  function fn_petipo(P_PAIS   in number,
                     P_PETDOC in number,
                     P_PENDOC in char) return varchar2
  
    parallel_enable;

end pq_cr_funciones_opinion_riegos;
/

create or replace package body pq_cr_funciones_opinion_riegos is

  function fn_cr_tas_fecha_tasacion(p_bcemp  in number,
                                    p_bcmod  in number,
                                    p_bcsuc  in number,
                                    p_bcmda  in number,
                                    p_bcpap  in number,
                                    p_bccta  in number,
                                    p_bcoper in number,
                                    p_bcsbop in number,
                                    p_bctope in number) return date is
  
    ln_ppg02dato date;
  
  begin
    select max(p1.ppg002dato)
      into ln_ppg02dato
      from ppg000 p, ppg002 p1
     where p.ppg000pgc = p_bcemp
       and p.ppg000mod = p_bcmod
       and p.ppg000suc = p_bcsuc
       and p.ppg000mda = p_bcmda
       and p.ppg000pap = p_bcpap
       and p.ppg000cta = p_bccta
       and p.ppg000ope = p_bcoper
       and p.ppg000sbo = p_bcsbop
       and p.ppg000top = p_bctope
       and p1.ppg002cdat = 77
       and p.ppg000pgc = p1.ppg002cod
       and p.ppg000mod = p1.ppg002mod
       and p.ppg000suc = p1.ppg002suc
       and p.ppg000mda = p1.ppg002mda
       and p.ppg000pap = p1.ppg002pap
       and p.ppg000cta = p1.ppg002cta
       and p.ppg000ope = p1.ppg002ope
       and p.ppg000sbo = p1.ppg002sbo
       and p.ppg000top = p1.ppg002top
       and p.ppg000frm = p1.ppg002frm
       and p.ppg000tco = 'S'
       and p.ppg000frm in (select max(g000.ppg000frm)
                             from ppg000 g000
                            where g000.ppg000pgc = p.ppg000pgc
                              and g000.ppg000mod = p.ppg000mod
                              and g000.ppg000suc = p.ppg000suc
                              and g000.ppg000mda = p.ppg000mda
                              and g000.ppg000pap = p.ppg000pap
                              and g000.ppg000cta = p.ppg000cta
                              and g000.ppg000ope = p.ppg000ope
                              and g000.ppg000sbo = p.ppg000sbo
                              and g000.ppg000top = p.ppg000top
                              and g000.ppg000tco = 'S');
    /*select max(p1.ppg002dato)
     into ln_ppg02dato
     from ppg000 p, ppg002 p1, fsr011 r
    where r.r1cod = p_bcemp
      and r.r1mod = p_bcmod
      and r.r1suc = p_bcsuc
      and r.r1mda = p_bcmda
      and r.r1pap = p_bcpap
      and r.r1cta = p_bccta
      and r.r1oper = p_bcoper
      and r.r1sbop = p_bcsbop
      and r.r1tope = p_bctope
      and relcod = 50
      and r2mod = 70
      and p1.ppg002cod = r.r2cod
      and p1.ppg002mod = r.r2mod
      and p1.ppg002suc = r.r2suc
      and p1.ppg002mda = r.r2mda
      and p1.ppg002pap = r.r2pap
      and p1.ppg002cta = r.r2cta
      and p1.ppg002ope = r.r2oper
      and p1.ppg002sbo = r.r2sbop
      and p1.ppg002top = r.r2tope
      and p1.ppg002cdat = 77
      and p.ppg000pgc = p1.ppg002cod
      and p.ppg000mod = p1.ppg002mod
      and p.ppg000suc = p1.ppg002suc
      and p.ppg000mda = p1.ppg002mda
      and p.ppg000pap = p1.ppg002pap
      and p.ppg000cta = p1.ppg002cta
      and p.ppg000ope = p1.ppg002ope
      and p.ppg000sbo = p1.ppg002sbo
      and p.ppg000top = p1.ppg002top
      and p.ppg000frm = p1.ppg002frm
      and p.ppg000tco = 'S'
      and p.ppg000frm in (select max(g000.ppg000frm)
                            from ppg000 g000
                           where g000.ppg000pgc = p.ppg000pgc
                             and g000.ppg000mod = p.ppg000mod
                             and g000.ppg000suc = p.ppg000suc
                             and g000.ppg000mda = p.ppg000mda
                             and g000.ppg000pap = p.ppg000pap
                             and g000.ppg000cta = p.ppg000cta
                             and g000.ppg000ope = p.ppg000ope
                             and g000.ppg000sbo = p.ppg000sbo
                             and g000.ppg000top = p.ppg000top
                             and g000.ppg000tco = 'S');*/
  
    Return ln_ppg02dato;
  Exception
    When Others Then
      Return null;
    
  end fn_cr_tas_fecha_tasacion;

  function fn_cr_tas_val_comercial(p_bcemp  in number,
                                   p_bcmod  in number,
                                   p_bcsuc  in number,
                                   p_bcmda  in number,
                                   p_bcpap  in number,
                                   p_bccta  in number,
                                   p_bcoper in number,
                                   p_bcsbop in number,
                                   p_bctope in number) return number is
  
    ln_ppg04dato number;
  
  begin
    select sum(p1.ppg004dato)
      into ln_ppg04dato
      from ppg000 p, ppg004 p1
     where p1.ppg004cod = p_bcemp
       and p1.ppg004mod = p_bcmod
       and p1.ppg004suc = p_bcsuc
       and p1.ppg004mda = p_bcmda
       and p1.ppg004pap = p_bcpap
       and p1.ppg004cta = p_bccta
       and p1.ppg004ope = p_bcoper
       and p1.ppg004sbo = p_bcsbop
       and p1.ppg004top = p_bctope
       and p1.ppg004cdat = 63
       and p.ppg000pgc = p1.ppg004cod
       and p.ppg000mod = p1.ppg004mod
       and p.ppg000suc = p1.ppg004suc
       and p.ppg000mda = p1.ppg004mda
       and p.ppg000pap = p1.ppg004pap
       and p.ppg000cta = p1.ppg004cta
       and p.ppg000ope = p1.ppg004ope
       and p.ppg000sbo = p1.ppg004sbo
       and p.ppg000top = p1.ppg004top
       and p.ppg000frm = p1.ppg004frm
       and p.ppg000tco = 'S';
    /*select sum(p1.ppg004dato)
     into ln_ppg04dato
     from ppg000 p, ppg004 p1, fsr011 r
    where r.r1cod = p_bcemp
      and r.r1mod = p_bcmod
      and r.r1suc = p_bcsuc
      and r.r1mda = p_bcmda
      and r.r1pap = p_bcpap
      and r.r1cta = p_bccta
      and r.r1oper = p_bcoper
      and r.r1sbop = p_bcsbop
      and r.r1tope = p_bctope
      and relcod = 50
      and r2mod = 70
      and p1.ppg004cod = r.r2cod
      and p1.ppg004mod = r.r2mod
      and p1.ppg004suc = r.r2suc
      and p1.ppg004mda = r.r2mda
      and p1.ppg004pap = r.r2pap
      and p1.ppg004cta = r.r2cta
      and p1.ppg004ope = r.r2oper
      and p1.ppg004sbo = r.r2sbop
      and p1.ppg004top = r.r2tope
      and p1.ppg004cdat = 63
      and p.ppg000pgc = p1.ppg004cod
      and p.ppg000mod = p1.ppg004mod
      and p.ppg000suc = p1.ppg004suc
      and p.ppg000mda = p1.ppg004mda
      and p.ppg000pap = p1.ppg004pap
      and p.ppg000cta = p1.ppg004cta
      and p.ppg000ope = p1.ppg004ope
      and p.ppg000sbo = p1.ppg004sbo
      and p.ppg000top = p1.ppg004top
      and p.ppg000frm = p1.ppg004frm
      and p.ppg000tco = 'S';*/
  
    Return ln_ppg04dato;
  Exception
    When Others Then
      Return null;
    
  end fn_cr_tas_val_comercial;

  function fn_cr_tas_val_realizacion(p_bcemp  in number,
                                     p_bcmod  in number,
                                     p_bcsuc  in number,
                                     p_bcmda  in number,
                                     p_bcpap  in number,
                                     p_bccta  in number,
                                     p_bcoper in number,
                                     p_bcsbop in number,
                                     p_bctope in number) return number is
  
    ln_ppg04dato number;
  
  begin
    select sum(p1.ppg004dato)
      into ln_ppg04dato
      from ppg000 p, ppg004 p1
     where p1.ppg004cod = p_bcemp
       and p1.ppg004mod = p_bcmod
       and p1.ppg004suc = p_bcsuc
       and p1.ppg004mda = p_bcmda
       and p1.ppg004pap = p_bcpap
       and p1.ppg004cta = p_bccta
       and p1.ppg004ope = p_bcoper
       and p1.ppg004sbo = p_bcsbop
       and p1.ppg004top = p_bctope
       and p1.ppg004cdat = 136
       and p.ppg000pgc = p1.ppg004cod
       and p.ppg000mod = p1.ppg004mod
       and p.ppg000suc = p1.ppg004suc
       and p.ppg000mda = p1.ppg004mda
       and p.ppg000pap = p1.ppg004pap
       and p.ppg000cta = p1.ppg004cta
       and p.ppg000ope = p1.ppg004ope
       and p.ppg000sbo = p1.ppg004sbo
       and p.ppg000top = p1.ppg004top
       and p.ppg000frm = p1.ppg004frm
       and p.ppg000tco = 'S'
       and p.ppg000frm in (select max(g000.ppg000frm)
                             from ppg000 g000
                            where g000.ppg000pgc = p.ppg000pgc
                              and g000.ppg000mod = p.ppg000mod
                              and g000.ppg000suc = p.ppg000suc
                              and g000.ppg000mda = p.ppg000mda
                              and g000.ppg000pap = p.ppg000pap
                              and g000.ppg000cta = p.ppg000cta
                              and g000.ppg000ope = p.ppg000ope
                              and g000.ppg000sbo = p.ppg000sbo
                              and g000.ppg000top = p.ppg000top
                              and g000.ppg000tco = 'S');
    /*select sum(p1.ppg004dato)
     into ln_ppg04dato
     from ppg000 p, ppg004 p1, fsr011 r
    where r.r1cod = p_bcemp
      and r.r1mod = p_bcmod
      and r.r1suc = p_bcsuc
      and r.r1mda = p_bcmda
      and r.r1pap = p_bcpap
      and r.r1cta = p_bccta
      and r.r1oper = p_bcoper
      and r.r1sbop = p_bcsbop
      and r.r1tope = p_bctope
      and relcod = 50
      and r2mod = 70
      and p1.ppg004cod = r.r2cod
      and p1.ppg004mod = r.r2mod
      and p1.ppg004suc = r.r2suc
      and p1.ppg004mda = r.r2mda
      and p1.ppg004pap = r.r2pap
      and p1.ppg004cta = r.r2cta
      and p1.ppg004ope = r.r2oper
      and p1.ppg004sbo = r.r2sbop
      and p1.ppg004top = r.r2tope
      and p1.ppg004cdat = 136
      and p.ppg000pgc = p1.ppg004cod
      and p.ppg000mod = p1.ppg004mod
      and p.ppg000suc = p1.ppg004suc
      and p.ppg000mda = p1.ppg004mda
      and p.ppg000pap = p1.ppg004pap
      and p.ppg000cta = p1.ppg004cta
      and p.ppg000ope = p1.ppg004ope
      and p.ppg000sbo = p1.ppg004sbo
      and p.ppg000top = p1.ppg004top
      and p.ppg000frm = p1.ppg004frm
      and p.ppg000tco = 'S'
      and p.ppg000frm in (select max(g000.ppg000frm)
                            from ppg000 g000
                           where g000.ppg000pgc = p.ppg000pgc
                             and g000.ppg000mod = p.ppg000mod
                             and g000.ppg000suc = p.ppg000suc
                             and g000.ppg000mda = p.ppg000mda
                             and g000.ppg000pap = p.ppg000pap
                             and g000.ppg000cta = p.ppg000cta
                             and g000.ppg000ope = p.ppg000ope
                             and g000.ppg000sbo = p.ppg000sbo
                             and g000.ppg000top = p.ppg000top
                             and g000.ppg000tco = 'S');*/
  
    Return ln_ppg04dato;
  Exception
    When Others Then
      Return null;
    
  end fn_cr_tas_val_realizacion;
  
  function fn_cr_tas_tipo_bien(p_bcemp  in number,
                                     p_bcmod  in number,
                                     p_bcsuc  in number,
                                     p_bcmda  in number,
                                     p_bcpap  in number,
                                     p_bccta  in number,
                                     p_bcoper in number,
                                     p_bcsbop in number,
                                     p_bctope in number) return varchar2 is
  
    ln_ppg008dato varchar2(40);
  
  begin
    select trim(p1.ppg008desc)
      into ln_ppg008dato
      from ppg000 p, ppg008 p1
     where p1.ppg008pgc = p_bcemp
       and p1.ppg008mod = p_bcmod
       and p1.ppg008suc = p_bcsuc
       and p1.ppg008mda = p_bcmda
       and p1.ppg008pap = p_bcpap
       and p1.ppg008cta = p_bccta
       and p1.ppg008ope = p_bcoper
       and p1.ppg008sbo = p_bcsbop
       and p1.ppg008top = p_bctope
       and p1.ppg008cdat = 59
       and p.ppg000pgc = p1.ppg008pgc
       and p.ppg000mod = p1.ppg008mod
       and p.ppg000suc = p1.ppg008suc
       and p.ppg000mda = p1.ppg008mda
       and p.ppg000pap = p1.ppg008pap
       and p.ppg000cta = p1.ppg008cta
       and p.ppg000ope = p1.ppg008ope
       and p.ppg000sbo = p1.ppg008sbo
       and p.ppg000top = p1.ppg008top
       and p.ppg000frm = p1.ppg008frm
       and p.ppg000tco = 'S'
       and p.ppg000frm in (select max(g000.ppg000frm)
                             from ppg000 g000
                            where g000.ppg000pgc = p.ppg000pgc
                              and g000.ppg000mod = p.ppg000mod
                              and g000.ppg000suc = p.ppg000suc
                              and g000.ppg000mda = p.ppg000mda
                              and g000.ppg000pap = p.ppg000pap
                              and g000.ppg000cta = p.ppg000cta
                              and g000.ppg000ope = p.ppg000ope
                              and g000.ppg000sbo = p.ppg000sbo
                              and g000.ppg000top = p.ppg000top
                              and g000.ppg000tco = 'S');      
    Return ln_ppg008dato;
  Exception
    When Others Then
      Return null;
    
  end fn_cr_tas_tipo_bien;
  
  function fn_cr_tas_fecha_declaracion(p_bcemp  in number,
                                     p_bcmod  in number,
                                     p_bcsuc  in number,
                                     p_bcmda  in number,
                                     p_bcpap  in number,
                                     p_bccta  in number,
                                     p_bcoper in number,
                                     p_bcsbop in number,
                                     p_bctope in number) return date is
  
    ln_ppg002dato date;
  
  begin
    select max(p1.ppg002dato)
      into ln_ppg002dato
      from ppg000 p, ppg002 p1
     where p1.ppg002cod = p_bcemp
       and p1.ppg002mod = p_bcmod
       and p1.ppg002suc = p_bcsuc
       and p1.ppg002mda = p_bcmda
       and p1.ppg002pap = p_bcpap
       and p1.ppg002cta = p_bccta
       and p1.ppg002ope = p_bcoper
       and p1.ppg002sbo = p_bcsbop
       and p1.ppg002top = p_bctope
       and p1.ppg002cdat = 38
       and p.ppg000pgc = p1.ppg002cod
       and p.ppg000mod = p1.ppg002mod
       and p.ppg000suc = p1.ppg002suc
       and p.ppg000mda = p1.ppg002mda
       and p.ppg000pap = p1.ppg002pap
       and p.ppg000cta = p1.ppg002cta
       and p.ppg000ope = p1.ppg002ope
       and p.ppg000sbo = p1.ppg002sbo
       and p.ppg000top = p1.ppg002top
       and p.ppg000frm = p1.ppg002frm
       and p.ppg000tco = 'S'
       and p.ppg000frm in (select max(g000.ppg000frm)
                             from ppg000 g000
                            where g000.ppg000pgc = p.ppg000pgc
                              and g000.ppg000mod = p.ppg000mod
                              and g000.ppg000suc = p.ppg000suc
                              and g000.ppg000mda = p.ppg000mda
                              and g000.ppg000pap = p.ppg000pap
                              and g000.ppg000cta = p.ppg000cta
                              and g000.ppg000ope = p.ppg000ope
                              and g000.ppg000sbo = p.ppg000sbo
                              and g000.ppg000top = p.ppg000top
                              and g000.ppg000tco = 'S');      
    Return ln_ppg002dato;
  Exception
    When Others Then
      Return null;
    
  end fn_cr_tas_fecha_declaracion;
  
  function fn_cr_ciiu_codigo(P_PAIS   in number,
                             P_PETDOC in number,
                             P_PENDOC in char,
                             P_PETIPO in varchar2) return number
    parallel_enable is
    ln_codciiu fst750.actcod1%type;
    lv_petipo  varchar2(1);
  Begin
  
    lv_petipo := pq_cr_funciones_opinion_riegos.fn_petipo(P_PAIS,
                                                          P_PETDOC,
                                                          P_PENDOC);
  
    If lv_petipo = 'F' Then
      Begin
        Select
        /*+ALL_ROWS PARALLEL(c60,16)*/
         c60.sngc60acte
          Into ln_codciiu
          From sngc60 c60
         Where c60.sngc60pais = P_PAIS
           And c60.sngc60tdoc = P_PETDOC
           And c60.sngc60ndoc = P_PENDOC
           And c60.sngc60corr = 0;
      Exception
        when others then
          ln_codciiu := 0;
      End;
    End If;
  
    If lv_petipo = 'J' Then
      Begin
        Select
        /*+ALL_ROWS PARALLEL(e001,16)*/
         e001.expnins
          Into ln_codciiu
          From fse001 e001
         Where e001.d511pais = P_PAIS
           And e001.d511tdoc = P_PETDOC
           And e001.d511ndoc = P_PENDOC;
      Exception
        when others then
          ln_codciiu := 0;
      End;
    End If;
  
    Return ln_codciiu;
  Exception
    When Others Then
      Return null;
    
  end fn_cr_ciiu_codigo;

  function fn_cr_tas_dato(p_bcemp  in number,
                          p_bcmod  in number,
                          p_bcsuc  in number,
                          p_bcmda  in number,
                          p_bcpap  in number,
                          p_bccta  in number,
                          p_bcoper in number,
                          p_bcsbop in number,
                          p_bctope in number) return varchar2 is
  
    ln_ppg01dato varchar2(500);
    ln_ppg08dato varchar2(500);
    ln_resultado varchar2(1000);
  
  begin
    begin
      select trim(p1.ppg001dato)
        into ln_ppg01dato
        from ppg000 p, ppg001 p1
       where p1.ppg001cod = p_bcemp
         and p1.ppg001mod = p_bcmod
         and p1.ppg001suc = p_bcsuc
         and p1.ppg001mda = p_bcmda
         and p1.ppg001pap = p_bcpap
         and p1.ppg001cta = p_bccta
         and p1.ppg001ope = p_bcoper
         and p1.ppg001sbo = p_bcsbop
         and p1.ppg001top = p_bctope
         and p1.ppg001cdat = 41
         and p.ppg000pgc = p1.ppg001cod
         and p.ppg000mod = p1.ppg001mod
         and p.ppg000suc = p1.ppg001suc
         and p.ppg000mda = p1.ppg001mda
         and p.ppg000pap = p1.ppg001pap
         and p.ppg000cta = p1.ppg001cta
         and p.ppg000ope = p1.ppg001ope
         and p.ppg000sbo = p1.ppg001sbo
         and p.ppg000top = p1.ppg001top
         and p.ppg000frm = p1.ppg001frm
         and p.ppg000tco = 'S';
    exception
      when others then
        ln_ppg01dato := '';
    end;
    begin
      select trim(p1.ppg008desc)
        into ln_ppg08dato
        from ppg000 p, ppg008 p1
       where p1.ppg008pgc = p_bcemp
         and p1.ppg008mod = p_bcmod
         and p1.ppg008suc = p_bcsuc
         and p1.ppg008mda = p_bcmda
         and p1.ppg008pap = p_bcpap
         and p1.ppg008cta = p_bccta
         and p1.ppg008ope = p_bcoper
         and p1.ppg008sbo = p_bcsbop
         and p1.ppg008top = p_bctope
         and p1.ppg008cdat = 58
         and p.ppg000pgc = p1.ppg008pgc
         and p.ppg000mod = p1.ppg008mod
         and p.ppg000suc = p1.ppg008suc
         and p.ppg000mda = p1.ppg008mda
         and p.ppg000pap = p1.ppg008pap
         and p.ppg000cta = p1.ppg008cta
         and p.ppg000ope = p1.ppg008ope
         and p.ppg000sbo = p1.ppg008sbo
         and p.ppg000top = p1.ppg008top
         and p.ppg000frm = p1.ppg008frm
         and p.ppg000tco = 'S';    
    exception
      when others then
        ln_ppg08dato := '';
    end;
    
    ln_resultado := ln_ppg01dato || ' - ' || ln_ppg08dato;
    
    Return ln_resultado;
  Exception
    When Others Then
      Return null;
    
  end fn_cr_tas_dato;

  function fn_petipo(P_PAIS   in number,
                     P_PETDOC in number,
                     P_PENDOC in char) return varchar2
    parallel_enable is
    lv_tipper varchar2(1);
  Begin
    Select
    /*+ALL_ROWS PARALLEL(u,16)*/
     u.petipo
      Into lv_tipper
      from fsd001 u
     where u.pepais = P_PAIS
       and u.petdoc = P_PETDOC
       and u.pendoc = P_PENDOC;
  
    Return lv_tipper;
  
  Exception
    When Others Then
      Return null;
  end fn_petipo;

end pq_cr_funciones_opinion_riegos;
/

