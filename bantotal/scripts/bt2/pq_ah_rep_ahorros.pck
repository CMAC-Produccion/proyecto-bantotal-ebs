create or replace package pq_ah_rep_ahorros is

  -- Author  : YLOZADA
  -- Created : 09/10/2014 11:44:43 a.m.
  -- Purpose : 
  
  -- Public type declarations
  
  procedure sp_tasa_producto(vpgcod  number,
                             vScsuc  number,
                             vSccta  number,
                             vScmda  number,
                             vScpap  number,
                             vScoper number,
                             vScsbop number,
                             vSctope number,
                             vScmod  number,
                             tasa    out number
                             );
  procedure sp_tasa_pizarra(vpgcod  number,
                            vScsuc  number,
                            vSccta  number,
                            vScmda  number,
                            vScpap  number,
                            vScoper number,
                            vScsbop number,
                            vSctope number,
                            vScmod  number,
                            tasa    out number
                            );
  Function fn_imp_cts_gar_mn(P_PGCOD in number,
                             P_SCSUC in number,
                             P_SCRUB in number,
                             P_SCPAP in number,
                             P_SCMDA in number,
                             P_SCCTA in number,
                             P_SCOPE in number,
                             P_SCSBO in number,
                             P_FECHA in date
                            ) return number;
                            
  Function fn_imp_cts_gar_mo(P_PGCOD in number,
                             P_SCSUC in number,
                             P_SCRUB in number,
                             P_SCPAP in number,
                             P_SCMDA in number,
                             P_SCCTA in number,
                             P_SCOPE in number,
                             P_SCSBO in number,
                             P_FECHA in date
                            ) return number;                                

  Function fn_agencia_max_segmentacion(P_PGCOD  in number,
                                       P_PAIS   in number,
                                       P_PETDOC in number,
                                       P_PENDOC in char,
                                       P_FECHA  in date
                                      ) return varchar2;
  Function fn_ah_saldocheque(P_N_COD IN NUMBER,           
                             P_N_MDA IN NUMBER,
                             P_N_PAP IN NUMBER,
                             P_N_CTA IN NUMBER,
                             P_N_SUC IN NUMBER,  
                             P_N_SUB IN NUMBER,
                             P_N_OPE IN NUMBER,                             
                             P_N_MOD IN NUMBER,
                             P_N_TOP IN NUMBER,
                             P_D_FEC IN DATE
                             ) RETURN NUMBER;
                                  
  Function fn_ah_saldointangible(P_N_COD IN NUMBER,
                                 P_N_MDA IN NUMBER,
                                 P_N_PAP IN NUMBER,
                                 P_N_CTA IN NUMBER,
                                 P_N_SUC IN NUMBER,  
                                 P_N_SUB IN NUMBER,
                                 P_D_FEC IN DATE
                                 ) RETURN NUMBER;
  Procedure sp_ah_saldo_ahorros( P_N_COD     IN NUMBER,
                                 P_C_USUARIO IN VARCHAR2,
                                 P_D_FECPRO IN DATE
                                );                                                                                              
  Procedure sp_ah_gasto_ahorros(P_N_COD     IN NUMBER,
                                P_C_USUARIO IN VARCHAR2,
                                P_D_FECPRO  IN DATE
                               );           
  Procedure sp_ah_cli_newret(P_C_USUARIO IN VARCHAR2,
                             P_D_FECPRO  IN DATE,
                             P_N_TIPO    IN NUMBER
                            ); 
  Function fn_ah_tasa_AH_DPF(P_PGCOD in number,
                             P_SCSUC in number,
                             P_SCCTA in number,                             
                             P_SCMDA in number,                             
                             P_SCPAP in number,
                             P_SCOPE in number,
                             P_SCSBO in number,
                             P_SCTPO in number,
                             P_SCMOD in number
                            ) return number;                                                                               
end pq_ah_rep_ahorros;
/

create or replace package body pq_ah_rep_ahorros is

  procedure sp_tasa_producto(vpgcod  number,
                             vScsuc  number,
                             vSccta  number,
                             vScmda  number,
                             vScpap  number,
                             vScoper number,
                             vScsbop number,
                             vSctope number,
                             vScmod  number,
                             tasa    out number) is
  
  begin

  -- Call the procedure
  pq_segmentacion_clientes_pas.sp_tasa(vpgcod => vpgcod,
                                       vscsuc => vscsuc,
                                       vsccta => vsccta,
                                       vscmda => vscmda,
                                       vscpap => vscpap,
                                       vscoper => vscoper,
                                       vscsbop => vscsbop,
                                       vsctope => vsctope,
                                       vscmod => vscmod,
                                       tasa => tasa);
    
  end sp_tasa_producto;

  procedure sp_tasa_pizarra(vpgcod  number,
                            vScsuc  number,
                            vSccta  number,
                            vScmda  number,
                            vScpap  number,
                            vScoper number,
                            vScsbop number,
                            vSctope number,
                            vScmod  number,
                            tasa    out number) is
  
    petipo char(1);
    tipo   number(9);
    ctifin char(1);
    ld_tafdes date;  
    ln_aopzo  number;
    ld_aofval date;
    ln_aoimp number(17,2);
    ln_tapzo number;
    ln_tamto number(17,2);
    
  begin
  
    select ctifin into ctifin from fsd008 where ctnro = vsccta;
  
    select b.petipo
      into petipo
      from fsr008 a, fsd001 b
     where a.pepais = b.pepais
       and a.petdoc = b.petdoc
       and a.pendoc = b.pendoc
       and a.ctnro = vsccta
       and a.ttcod = 1
       and a.cttfir = 'T';

      select totpiz
        into tipo
        from fst004
       where modulo = vScmod
         and toeleg = 'S'
         and totope = vsctope;
           
    if vscmod = 21 then    
      if petipo = 'J' then
        If ctifin = 'S' then
          If vsctope = 3 then
            tipo := 97;
          Else
            tipo := 96;
          End if;
        Else
          begin
            select ModCodn
              into tipo
              from FST100 -- ModCodN
             Where ModTcli = 2
               and ModSuc = 0
               and ModCod = tipo;
          exception
            when no_data_found then
              null;
          end;
        end if;
      end if;
        
      select tatasa
        into tasa
        from (select tatasa
                from FSR025
               Where Pgcod = vpgcod
                 and Tamod = vscmod
                 and Tpizar = tipo -- totpiz
                 and Tamda = vscmda -- moneda
                 and Tapap = vScpap
               order by tafdes desc)
       where rownum = 1;
    else
      begin
        select x.aopzo, x.aofval,x.aoimp
          into ln_aopzo,ld_aofval,ln_aoimp
          from fsd010 x
         where x.PGCOD  = vpgcod
           and x.AOMOD  = vScmod
           and x.AOSUC  = vScsuc
           and x.AOMDA  = vScmda
           and x.AOPAP  = vScpap
           and x.AOCTA  = vSccta
           and x.AOOPER = vScoper
           and x.AOSBOP = vScsbop
           and x.AOTOPE = vSctope;
        exception 
        when others then 
             null;   
      end;       

      select tafdes
        into ld_tafdes
        from (select tafdes
                from FSR025
               Where Pgcod = vpgcod
                 and Tamod = vscmod
                 and Tpizar = tipo -- totpiz
                 and Tamda = vscmda -- moneda
                 and Tapap = vScpap
                 and tafdes <= ld_aofval
               order by tafdes desc)
       where rownum = 1;
   
      select tapzo
        into ln_tapzo
        from (select tapzo
                from FSR025
               Where Pgcod = vpgcod
                 and Tamod = vscmod
                 and Tpizar = tipo -- totpiz
                 and Tamda = vscmda -- moneda
                 and Tapap = vScpap
                 and tafdes = ld_tafdes
                 and tapzo >= ln_aopzo                
               order by tapzo asc)
       where rownum = 1;      
       
      select tamto
        into ln_tamto
        from (select tamto
                from FSR025
               Where Pgcod = vpgcod
                 and Tamod = vscmod
                 and Tpizar = tipo -- totpiz
                 and Tamda = vscmda -- moneda
                 and Tapap = vScpap
                 and tafdes = ld_tafdes
                 and tapzo = ln_tapzo    
                 and tamto >= ln_aoimp           
               order by tamto asc)
       where rownum = 1;          
      
      begin
        select tatasa
          into tasa
          from FSR025
         Where Pgcod = vpgcod
           and Tamod = vscmod
           and Tpizar = tipo -- totpiz
           and Tamda = vscmda -- moneda
           and Tapap = vScpap
           and tafdes = ld_tafdes
           and tapzo = ln_tapzo
           and tamto = ln_tamto;
      exception
        when others then
          null;
      end;
         
    end if;
  end sp_tasa_pizarra;
  Function fn_imp_cts_gar_mn(P_PGCOD in number,
                             P_SCSUC in number,
                             P_SCRUB in number,
                             P_SCPAP in number,
                             P_SCMDA in number,
                             P_SCCTA in number,
                             P_SCOPE in number,
                             P_SCSBO in number,
                             P_FECHA in date
                            ) return number
  is
    ln_imppro number(12,2);
  begin
       Select sum(nvl(d11.bcsdmn,0))
         Into ln_imppro
         From fsr014 r014 join fsh012 d11 on d11.bcemp   = P_PGCOD
                                         and d11.bcsuc  = P_SCSUC
                                         and d11.bcrubr  = r014.rrrubr
                                         and d11.bcmda  = P_SCMDA
                                         and d11.bcpap  = P_SCPAP
                                         and d11.bccta  = P_SCCTA
                                         and d11.bcoper = P_SCOPE
                                         and d11.bcsbop = P_SCSBO
                                         and d11.bcfech = P_FECHA
                                          --and h012.bctop  = P_SCTOP
                                          --and h012.bcfech = P_FECHA
                                          --and h012.bcmod  = P_SCMOD
        Where r014.rubro = P_SCRUB
          And r014.rrcod = 901;

       Return ln_imppro;

  Exception 
  When others then
       Return 0;
  End fn_imp_cts_gar_mn; 
  
  Function fn_imp_cts_gar_mo(P_PGCOD in number,
                             P_SCSUC in number,
                             P_SCRUB in number,
                             P_SCPAP in number,
                             P_SCMDA in number,
                             P_SCCTA in number,
                             P_SCOPE in number,
                             P_SCSBO in number,
                             P_FECHA in date
                            ) return number
  is
    ln_imppro number(12,2);
  begin
       Select sum(nvl(d11.bcsdmo,0))
         Into ln_imppro
         From fsr014 r014 join fsh012 d11 on d11.bcemp  = P_PGCOD
                                         and d11.bcsuc  = P_SCSUC
                                         and d11.bcrubr = r014.rrrubr
                                         and d11.bcmda  = P_SCMDA
                                         and d11.bcpap  = P_SCPAP
                                         and d11.bccta  = P_SCCTA
                                         and d11.bcoper = P_SCOPE
                                         and d11.bcsbop = P_SCSBO
                                         and d11.bcfech = P_FECHA
                                          --and h012.bctop  = P_SCTOP
                                          --and h012.bcfech = P_FECHA
                                          --and h012.bcmod  = P_SCMOD
        Where r014.rubro = P_SCRUB
          And r014.rrcod = 901;

       Return ln_imppro;

  Exception 
  When others then
       Return 0;
  End fn_imp_cts_gar_mo;   
  
  Function fn_agencia_max_segmentacion(P_PGCOD  in number,
                                       P_PAIS   in number,
                                       P_PETDOC in number,
                                       P_PENDOC in char,
                                       P_FECHA  in date
                                      ) return varchar2
                                      is
      ln_codsuc fst001.sucurs%type;
      lc_nomsuc fst001.scnom%type;
  begin
     Begin
           Select l60.jaql60sucu
             Into ln_codsuc
             From jaql060 l60
            Where l60.jaql60pgco = P_PGCOD
              And l60.jaql60pais = P_PAIS
              And l60.jaql60tdoc = P_PETDOC
              And l60.jaql60ndoc = P_PENDOC
              And l60.jaql60fech = P_FECHA;
     Exception When Others Then
               Begin
                   Select l60.jaql60sucu
                     Into ln_codsuc
                     From jaql060 l60
                    Where l60.jaql60pgco = P_PGCOD
                      And l60.jaql60pais = P_PAIS
                      And l60.jaql60tdoc = P_PETDOC
                      And l60.jaql60ndoc = P_PENDOC
                      And l60.jaql60fech = (Select Max(l602.jaql60fech)
                                              From jaql060 l602
                                             Where l602.jaql60pgco = P_PGCOD
                                               And l602.jaql60pais = P_PAIS
                                               And l602.jaql60tdoc = P_PETDOC
                                               And l602.jaql60ndoc = P_PENDOC
                                           );
                Exception When others then
                          lc_nomsuc := null;
                End;
      End;
      
      Begin
           Select t001.scnom
             Into lc_nomsuc
             From fst001 t001
            Where t001.pgcod  = P_PGCOD
              And t001.sucurs = ln_codsuc;
      Exception when others then
          lc_nomsuc := null;
      End;
      
      Return lc_nomsuc;
  end fn_agencia_max_segmentacion;  
  
  Function fn_ah_saldocheque(P_N_COD IN NUMBER,           
                             P_N_MDA IN NUMBER,
                             P_N_PAP IN NUMBER,
                             P_N_CTA IN NUMBER,
                             P_N_SUC IN NUMBER,  
                             P_N_SUB IN NUMBER,
                             P_N_OPE IN NUMBER,                             
                             P_N_MOD IN NUMBER,
                             P_N_TOP IN NUMBER,
                             P_D_FEC IN DATE
                             ) RETURN NUMBER 
                             IS
  cursor C_GUIA is
    select * from  fst198
    Where Tp1cod   = P_N_COD
      and Tp1cod1  = 10822
      and Tp1corr1 = 2
      and Tp1corr2 = 1;
      
  cursor c_saldo(Tp1nro1 in number,rubro in number) is     
   select a.*,b.*
     from FSR111 a, FSD011 b
    Where b.PgCod = a.I1COD
      and b.Scmod = a.I1mod
      and b.Scmda = a.I1mda
      and b.Scpap = a.I1pap
      and b.Sccta = a.I1cta
      and b.Scsuc = a.I1suc
      and b.Scoper = a.I1oper
      and b.Scsbop = a.I1sbop
      and b.Sctope = a.I1tope
      and a.i1rub = b.scrub
      and a.I2COD = P_N_COD
      and a.I2MOD = P_N_MOD
      and a.I2SUC = P_N_SUC
      and a.I2MDA = P_N_MDA
      and a.I2PAP = P_N_PAP
      and a.I2CTA = P_N_CTA
      and a.I2OPER = P_N_OPE
      and a.I2SBOP = P_N_SUB
      and a.I2TOPE = P_N_TOP
      and a.INSCOD = 3
      and a.I1COD = P_N_COD
      and a.I1MOD = Tp1nro1
      and a.i1rub = rubro
      and a.R111CO = 'S'
      and a.r111fc >= P_D_FEC - 5;
       
  cursor c_saldohis(Tp1nro1 in number,rubro in number) is     
   select a.*,b.*
     from FSR111 a, FSH012 b
    Where b.bcemp = a.I1COD
      and b.Bcmod = a.I1mod
      and b.bcmda = a.I1mda
      and b.bcpap = a.I1pap
      and b.bccta = a.I1cta
      and b.bcsuc = a.I1suc
      and b.bcoper = a.I1oper
      and b.bcsbop = a.I1sbop
      and b.bctop = a.I1tope
      and a.i1rub = b.bcrubr
      and a.I2COD = P_N_COD
      and a.I2MOD = P_N_MOD
      and a.I2SUC = P_N_SUC
      and a.I2MDA = P_N_MDA
      and a.I2PAP = P_N_PAP
      and a.I2CTA = P_N_CTA
      and a.I2OPER = P_N_OPE
      and a.I2SBOP = P_N_SUB
      and a.I2TOPE = P_N_TOP
      and a.INSCOD = 3
      and a.I1COD = P_N_COD
      and a.I1MOD = Tp1nro1
      and a.i1rub = rubro
      and a.R111CO = 'S'
      and a.r111fc >= P_D_FEC - 5
      --and b.bcfvto >= P_D_FEC    
      and b.bcfech = P_D_FEC
       ;       
       
  cursor c_saldo40(Tp1nro1 in number,rubro in number) is     
   select b.*
     from FSD011 b
    Where b.PgCod = P_N_COD
      and b.scrub = rubro
      and b.Scmod = Tp1nro1
      and b.Scmda = P_N_MDA
      and b.Scpap = P_N_PAP
      and b.Sccta = P_N_CTA
      and b.Scsuc = P_N_SUC      
      and b.Scsbop = P_N_SUB;

  cursor c_saldohis40(Tp1nro1 in number,rubro in number) is     
   select b.*
     from FSH012 b
    Where b.bcemp= P_N_COD
      and b.bcrubr = rubro
      and b.bcmod = Tp1nro1
      and b.bcmda = P_N_MDA
      and b.bcpap = P_N_PAP
      and b.bccta = P_N_CTA
      and b.bcsuc = P_N_SUC      
      and b.bcsbop = P_N_SUB
      and b.bcfech = P_D_FEC;
       
  SdoCheque number(17,2):=0;
  Saldo number(17,2):=0;
  Fecproc   date;
  rubro number;
  tccod number;
  TipoC number(14,8);
  
  begin  
  select a.pgfape into Fecproc  from fst017 a where a.pgcod = P_N_COD;  
   
      If Fecproc = P_D_FEC then              
          For i in c_guia loop
              If i.tp1nro1 = 19 then
                  If P_N_MDA = 0 then
                         rubro := 2918070000033;  
                  Else
                         rubro := 2928070000033;
                  End If;              
              Else
                  If P_N_MDA = 0 then
                         rubro := 2918070000039;  
                  Else
                         rubro := 2928070000039;
                  End If;                              
              End If;
              If i.Tp1nro3 = 0 then   
                  For j in c_saldo40(i.Tp1nro1,rubro) loop
                    If (i.Tp1imp1 = 0) or (j.Scrub  = i.Tp1imp1) or (j.Scrub  = i.Tp1imp2)  then 
                        If i.Tp1nro2 = 1 then
                            SdoCheque := SdoCheque + j.Scsdo;
                        Else
                            SdoCheque := SdoCheque - j.Scsdo;
                        End If;
                    End If;          
                  End Loop;
              Else
                  tccod := 500;
                  For j in c_saldo(i.tp1nro1,rubro) loop
                    Saldo := j.Scsdo;
                    sp_tipo_cambio(fecha  => j.R111FC,
                                   monori => j.Scmda,
                                   mondes => j.I1mda,
                                   tipo   => tccod,
                                   tc     => TipoC
                                   );                    

                        If j.Scmda <> j.I1mda Then
                            If j.Scmda = 0 Then
                                Saldo := j.Scsdo * TipoC;
                            Else
                                Saldo := j.Scsdo / TipoC;
                            End If;
                        End If;

                        If (i.Tp1imp1 = 0) OR (j.Scrub  = i.Tp1imp1) OR (j.Scrub  = i.Tp1imp2) Then
                            If i.Tp1nro2 = 1 then
                                SdoCheque := SdoCheque + Saldo;
                            Else
                                SdoCheque := SdoCheque - Saldo;
                            End If;
                        End If;              
                  End Loop;  
              End If;                        
          End Loop;    
      Else   
          For i in c_guia loop
              If i.tp1nro1 = 19 then
                  If P_N_MDA = 0 then
                         rubro := 2918070000033;  
                  Else
                         rubro := 2928070000033;
                  End If;              
              Else
                  If P_N_MDA = 0 then
                         rubro := 2918070000039;  
                  Else
                         rubro := 2928070000039;
                  End If;                              
              End If;  
              
              If i.Tp1nro3 = 0 then        
                  For j in c_saldohis40(i.Tp1nro1,rubro) loop
                    If (i.Tp1imp1 = 0) or (j.Bcrubr  = i.Tp1imp1) or (j.Bcrubr  = i.Tp1imp2)  then 
                        If i.Tp1nro2 = 1 then
                            SdoCheque := SdoCheque + j.Bcsdmo;
                        Else
                            SdoCheque := SdoCheque - j.Bcsdmo;
                        End If;
                    End If;          
                  End Loop;
              Else
                  tccod := 500;
                  For j in c_saldohis(i.tp1nro1,rubro) loop
                    Saldo := j.Bcsdmo;
                    sp_tipo_cambio(fecha  => j.R111FC,
                                   monori => j.bcmda,
                                   mondes => j.I1mda,
                                   tipo   => tccod,
                                   tc     => TipoC
                                   );                    

                        If j.bcmda <> j.I1mda Then
                            If j.bcmda = 0 Then
                                Saldo := j.Bcsdmo * TipoC;
                            Else
                                Saldo := j.Bcsdmo / TipoC;
                            End If;
                        End If;

                        If (i.Tp1imp1 = 0) OR (j.Bcrubr  = i.Tp1imp1) OR (j.Bcrubr  = i.Tp1imp2) Then
                            If i.Tp1nro2 = 1 then
                                SdoCheque := SdoCheque + Saldo;
                            Else
                                SdoCheque := SdoCheque - Saldo;
                            End If;
                        End If;              
                  End Loop;   
              End If;              
          End Loop;             
      End If;
  return round(SdoCheque,2);    
  End fn_ah_saldocheque;
  
  Function fn_ah_saldointangible(P_N_COD IN NUMBER,
                                 P_N_MDA IN NUMBER,
                                 P_N_PAP IN NUMBER,
                                 P_N_CTA IN NUMBER,
                                 P_N_SUC IN NUMBER,  
                                 P_N_SUB IN NUMBER,
                                 P_D_FEC IN DATE
                                 ) RETURN NUMBER 
                                 IS  
  Sdointg number(17,2):=0;   
  Fecproc Date;                             
  begin
    select a.pgfape into Fecproc  from fst017 a where a.pgcod = P_N_COD;  
    If Fecproc = P_D_FEC then 
        select Scsdo
          Into Sdointg
          from fsd011 a
         Where Pgcod  = P_N_COD
           and scsuc  = P_N_SUC
           and scrub  = '9300070500000'
           and scmda  = P_N_MDA
           and scpap  = P_N_PAP
           and sccta  = P_N_CTA
           and scoper = 0
           and scsbop = P_N_SUB
           and sctope = 0
           and scmod  = 157;                           
    Else
        select Bcsdmo
          Into Sdointg
          from fsh012 a
         Where bcemp  = P_N_COD
           and bcsuc  = P_N_SUC
           and bcrubr = '9300070500000'
           and bcmda  = P_N_MDA
           and bcpap  = P_N_PAP
           and bccta  = P_N_CTA
           and bcoper = 0
           and bcsbop = P_N_SUB
           and bctop  = 0
           and bcmod  = 157
           and bcfech = P_D_FEC;         
    End If;           
  return Sdointg;       
  Exception
  When others then
       Sdointg := 0;
       return Sdointg;
  end fn_ah_saldointangible;     
  
  Procedure sp_ah_saldo_ahorros(P_N_COD     IN NUMBER,
                                P_C_USUARIO IN VARCHAR2,
                                P_D_FECPRO  IN DATE
                               ) IS
  Cursor c_saldos_his is
    select 
           bcfech Periodo,
           decode(regcod, 999, 999, regcod) Regcod,
           upper(decode(regcod, 999, 'TESORERIA', regnom)) regnom,
           sucurs,
           decode(sucurs, 999, 'TESORERIA', scnom) scnom,
           Modulo,
           upper(TipOpe) Tipope,
           codmon,
           desmon,
           sum(Saldo) Saldo,
           sum(SaldoMN) SaldoMN,
           round((case
                   when sum(SaldoMN) <> 0 then
                    sum(Saltas) / sum(SaldoMN)
                   else
                    0
                 end),
                 2) TasaPonderada,
           count(distinct bcemp || bcsuc || bcmda || bcpap || bccta || bcoper ||
                 bcsbop || bctop || bcmod) NOpe,
           abs(sum(Intangible)) Intangible,            
           sum(Cheque)     Cheque
      from (select /*+ parallel(a,5) +*/
                   a.bcfech,
                   case
                     when (a.bcmod = 22  and (a.bccta, a.bcoper) in
                                                                (select jaql478cta, jaql478ope
                                                                   from jaql478
                                                                  where jaql478EST = 'A')
                            ) or
                           (a.bcmod = 21  and (a.bccta, a.bcsbop) in
                                                                (select jaql478cta, jaql478sub
                                                                   from jaql478
                                                                  where jaql478EST = 'A')
                           )                        
                     then
                      999
                     else
                      t81.regcod
                   end regcod,
                   t80.regnom,
                   t.sucurs,
                   t.scnom,
                   a.bcmda codmon,
                   decode(a.bcmda, 0, 'S/.', 'US$') desmon,
                   case
                     when a.bcmod = 21 and a.bctop = 2 then
                      a.bcsdmo + nvl(pq_ah_rep_ahorros.fn_imp_cts_gar_mo(a.bcemp,
                                                                         a.bcsuc,
                                                                         a.bcrubr,
                                                                         a.bcpap,
                                                                         a.bcmda,
                                                                         a.bccta,
                                                                         a.bcoper,
                                                                         a.bcsbop,
                                                                         a.bcfech),
                                     0)
                     else
                      a.bcsdmo
                   end Saldo,
                   case
                     when a.bcmod = 21 and a.bctop = 2 then
                      a.bcsdmn + nvl(pq_ah_rep_ahorros.fn_imp_cts_gar_mn(a.bcemp,
                                                                         a.bcsuc,
                                                                         a.bcrubr,
                                                                         a.bcpap,
                                                                         a.bcmda,
                                                                         a.bccta,
                                                                         a.bcoper,
                                                                         a.bcsbop,
                                                                         a.bcfech),
                                     0)
                     else
                      a.bcsdmn
                   end SaldoMN,
                   case when a.bcmod=21 and a.bctop=2  then 
                      a.bcsdmn + nvl(pq_ah_rep_ahorros.fn_imp_cts_gar_mn(a.bcemp,
                                                                         a.bcsuc,
                                                                         a.bcrubr,
                                                                         a.bcpap,
                                                                         a.bcmda,
                                                                         a.bccta,
                                                                         a.bcoper,
                                                                         a.bcsbop,
                                                                         a.bcfech
                                                                         ),
                                      0)*a.bctasa
                        else 
                              a.bcsdmn * a.bctasa
                   end SalTas,                   
                   (Case
                     when (a.bcmod = 21 and a.bctop = 2) then
                      'CTS'
                     else
                      f.mdnom
                   end) Modulo,
                   trim(e.tonom) TipOpe,
                   a.bcemp,
                   a.bcsuc,
                   a.bcmda,
                   a.bcpap,
                   a.bccta,
                   a.bcoper,
                   a.bcsbop,
                   a.bctop bctop,
                   a.bcmod bcmod,
                   case                                         
                   when (a.bcmod = 21 and a.bctop = 2) then
                        pq_ah_rep_ahorros.fn_ah_saldointangible(a.bcemp,a.bcmda,a.bcpap,a.bccta,a.bcsuc,a.bcsbop,a.bcfech)
                   Else
                        0
                   end Intangible,          
                   pq_ah_rep_ahorros.fn_ah_saldocheque(a.bcemp,a.bcmda,a.bcpap,a.bccta,a.bcsuc,a.bcsbop,a.bcoper,a.bcmod, a.bctop,a.bcfech) Cheque                            
              from fsh012 a,
                   fst001 t,
                   fst811 t81,
                   fst810 t80,
                   fst003 f,
                   fst004 e
             where t81.pgcod = t.pgcod
               and t81.oficod = t.sucurs
               and t.sucurs = a.bcsuc
               and t81.regcod < 100
               and t80.pgcod = t81.pgcod
               and t80.regcod = t81.regcod
               and f.modulo = a.bcmod
               and e.modulo = a.bcmod
               and e.totope = a.bctop
               and a.bccta <> 999999999
               and a.bcmod in (21, 22)
               and a.bcfech = P_D_FECPRO
               and a.bcprod <> 99)
     group by  bcfech,
               Modulo,
               TipOpe,
               regcod,
               regnom,
               sucurs,
               scnom,
               codmon,
               desmon;    
  cont number := 0;       
  
  cursor c_saldos_hoy is
    select decode(regcod, 999, 999, regcod) regcod,
           upper(decode(regcod, 999, 'TESORERIA', regnom)) regnom,
           sucurs,
           decode(sucurs, 999, 'TESORERIA', scnom) scnom,
           Modulo,
           upper(TipOpe) Tipope,
           codmon,
           desmon,
           sum(Saldo) Saldo,
           sum(SaldoMN) SaldoMN,
           (case
             when sum(SaldoMN) <> 0 then
              sum(Saltas) / sum(SaldoMN)
             else
              0
           end) TasaPonderada,
           count(distinct Pgcod || scsuc || scmda || scpap || sccta || scoper ||
                 scsbop || sctope || scmod) NOpe,
           abs(sum(Intangible)) Intangible,
           sum(Cheque) Cheque                               
      from (select --a.bcfech, 
            /*+ parallel(a,5) +*/
             case
               when (a.scmod = 22  and (a.sccta, a.scoper) in
                                                          (select jaql478cta, jaql478ope
                                                             from jaql478
                                                            where jaql478EST = 'A')
                      ) or
                     (a.scmod = 21  and (a.sccta, a.scsbop) in
                                                          (select jaql478cta, jaql478sub
                                                             from jaql478
                                                            where jaql478EST = 'A')
                     )                        
               then
                999
               else
                t81.regcod
             end regcod,
             t80.regnom,
             t.sucurs,
             t.scnom,
             a.scmda codmon,
             decode(a.scmda, 0, 'S/.', 'US$') desmon,
             case
               when a.scmod = 21 and a.scmod = 2 then
                a.scsdo
               else
                a.scsdo
             end Saldo,
             case
               when a.scmda = 0 then
                a.scsdo
               else
                a.scsdo * fn_tipo_cambio(fecha  => P_D_FECPRO,
                                         monori => a.scmda,
                                         mondes => 0,
                                         tipo   => 500
                                         )     
             end SaldoMN,
             case
              when a.scmda = 0 then
              a.scsdo * pq_ah_rep_ahorros.fn_ah_tasa_ah_dpf(p_pgcod => a.pgcod,
                                                           p_scsuc => a.scsuc,
                                                           p_sccta => a.sccta,
                                                           p_scmda => a.scmda,
                                                           p_scpap => a.scpap,
                                                           p_scope => a.scoper,
                                                           p_scsbo => a.scsbop,
                                                           p_sctpo => a.sctope,
                                                           p_scmod => a.scmod
                                                           )
              else
               a.scsdo * pq_ah_rep_ahorros.fn_ah_tasa_ah_dpf(p_pgcod => a.pgcod,
                                                             p_scsuc => a.scsuc,
                                                             p_sccta => a.sccta,
                                                             p_scmda => a.scmda,
                                                             p_scpap => a.scpap,
                                                             p_scope => a.scoper,
                                                             p_scsbo => a.scsbop,
                                                             p_sctpo => a.sctope,
                                                             p_scmod => a.scmod
                                                             ) *             
                fn_tipo_cambio(fecha  => P_D_FECPRO,
                               monori => a.scmda,
                               mondes => 0,
                               tipo   => 500
                               )             
             
              End SalTas,                            
             (Case
               when (a.scmod = 21 and a.sctope = 2) then
                'CTS'
               else
                f.mdnom
             end) Modulo,
             trim(e.tonom) TipOpe,
             a.pgcod,
             a.scsuc,
             a.scmda,
             a.scpap,
             a.sccta,
             a.scoper,
             a.scsbop,
             a.sctope,
             a.scmod,
             case
               when (a.scmod = 21 and a.sctope = 2) then
                pq_ah_rep_ahorros.fn_ah_saldointangible(a.pgcod,
                                                        a.scmda,
                                                        a.scpap,
                                                        a.sccta,
                                                        a.scsuc,
                                                        a.scsbop,
                                                        P_D_FECPRO)
               Else
                0
             end Intangible,
             pq_ah_rep_ahorros.fn_ah_saldocheque(a.pgcod,
                                                 a.scmda,
                                                 a.scpap,
                                                 a.sccta,
                                                 a.scsuc,
                                                 a.scsbop,
                                                 a.scoper,
                                                 a.scmod,
                                                 a.sctope,
                                                 P_D_FECPRO) Cheque
              from FSD011 a,
                   fst001 t,
                   fst811 t81,
                   fst810 t80,
                   fst003 f,
                   fst004 e
             where t81.pgcod = t.pgcod
               and t81.oficod = t.sucurs
               and t.sucurs = a.scsuc
               and t81.regcod < 100
               and t80.pgcod = t81.pgcod
               and t80.regcod = t81.regcod
               and f.modulo = a.scmod
               and e.modulo = a.scmod
               and e.totope = a.sctope
               and a.scmod in (21, 22)
               and a.scstat <> 99
               )
     group by Modulo, 
              TipOpe, 
              regcod, 
              regnom, 
              sucurs, 
              scnom, 
              codmon, 
              desmon;              
     
  Fecproc DATE;
  lc_usuario char(10);
  begin  
/*    delete from jaql479
     where JAQL479USU = P_C_USUARIO
       and JAQL479FEC = P_D_FECPRO
       and JAQL479COD = 1;
    commit;   */
    execute immediate('truncate table jaql479');
    execute immediate('truncate table temporal');
    
    lc_usuario := rpad(P_C_USUARIO,10,' ');    
         
    select a.pgfape into Fecproc  from fst017 a where a.pgcod = P_N_COD;  
    If Fecproc = P_D_FECPRO then         
        For i in c_saldos_hoy loop
          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,
                              JAQL479A31,
                              JAQL479AX1,
                              JAQL479A21,
                              JAQL479AX2,
                              JAQL479A22,
                              JAQL479A23,
                              JAQL479A24,
                              JAQL479AX3,
                              JAQL479A25,
                              JAQL479A11,
                              JAQL479A12,
                              JAQL479A13,
                              JAQL479AX4,
                              JAQL479A14,
                              JAQL479A15
                             )
                       values(lc_usuario,
                              P_D_FECPRO,
                              1,
                              cont,  
                              P_D_FECPRO,
                              i.Regcod,
                              i.regnom,
                              i.sucurs,  
                              i.scnom,
                              i.Modulo,
                              i.Tipope,
                              i.Codmon,
                              i.desmon,
                              i.Saldo,
                              i.SaldoMN, 
                              i.TasaPonderada,
                              i.NOpe,
                              i.Intangible,
                              i.cheque                
                              );
        End Loop;
    Else
        For i in c_saldos_his loop

          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,
                              JAQL479A31,
                              JAQL479AX1,
                              JAQL479A21,
                              JAQL479AX2,
                              JAQL479A22,
                              JAQL479A23,
                              JAQL479A24,
                              JAQL479AX3,
                              JAQL479A25,
                              JAQL479A11,
                              JAQL479A12,
                              JAQL479A13,
                              JAQL479AX4,
                              JAQL479A14,
                              JAQL479A15
                             )
                       values(lc_usuario,
                              P_D_FECPRO,
                              1,
                              cont,  
                              i.Periodo,
                              i.Regcod,
                              i.regnom,
                              i.sucurs,  
                              i.scnom,
                              i.Modulo,
                              i.Tipope,
                              i.Codmon,
                              i.desmon,
                              i.Saldo,
                              i.SaldoMN, 
                              i.TasaPonderada,
                              i.NOpe,
                              i.Intangible,
                              i.cheque                
                              );
        End Loop;    
    End If;
    commit;
  End sp_ah_saldo_ahorros;   
  Procedure sp_ah_gasto_ahorros(P_N_COD     IN NUMBER,
                                P_C_USUARIO IN VARCHAR2,
                                P_D_FECPRO  IN DATE
                               ) IS
  Cursor c_gasto_his is
    select 
           bcfech Periodo,
           decode(regcod, 999, 999, regcod) Regcod,
           upper(decode(regcod, 999, 'TESORERIA', regnom)) regnom,
           sucurs,
           decode(sucurs, 999, 'TESORERIA', scnom) scnom,
           Modulo,
           /*upper(TipOpe)*/'INTERES DEVENGADO' Tipope,
           codmon,
           desmon,
           sum(Saldo) Saldo,
           count(distinct bcemp || bcsuc || bcmda || bcpap || bccta || bcoper ||
                 bcsbop || bctop || bcmod) NOpe
      from (select /*+ parallel(a,5) +*/
                   a.bcfech,
                   case
                     when (a.bcmod = 22  and (a.bccta, a.bcoper) in
                                                                (select jaql478cta, jaql478ope
                                                                   from jaql478
                                                                  where jaql478EST = 'A')
                            ) or
                           (a.bcmod = 21  and (a.bccta, a.bcsbop) in
                                                                (select jaql478cta, jaql478sub
                                                                   from jaql478
                                                                  where jaql478EST = 'A')
                           )                        
                     then
                      999
                     else
                      t81.regcod
                   end regcod,
                   t80.regnom,
                   t.sucurs,
                   t.scnom,
                   a.bcmda codmon,
                   decode(a.bcmda, 0, 'S/.', 'US$') desmon,
                   a.bcsdmo Saldo,
                   (Case
                     when (a.bcmod = 429) then
                      'CTS'
                     else
                      f.mdnom
                   end) Modulo,
                   trim(e.tonom) TipOpe,
                   a.bcemp,
                   a.bcsuc,
                   a.bcmda,
                   a.bcpap,
                   a.bccta,
                   a.bcoper,
                   a.bcsbop,
                   a.bctop bctop,
                   decode(a.bcmod,426,22,21) bcmod                         
              from fsh012 a,
                   fst001 t,
                   fst811 t81,
                   fst810 t80,
                   fst003 f,
                   fst004 e
             where t81.pgcod = t.pgcod
               and t81.oficod = t.sucurs
               and t.sucurs = a.bcsuc
               and t81.regcod < 100
               and t80.pgcod = t81.pgcod
               and t80.regcod = t81.regcod
               and f.modulo = decode(a.bcmod,426,22,21)
               and e.modulo = decode(a.bcmod,426,22,21)
               and e.totope = a.bctop
               and a.bccta <> 999999999
               and a.bcmod  in (426,429)
               and a.bcfech = P_D_FECPRO
               and a.bcprod <> 99)
     group by  bcfech,
               Modulo,
               TipOpe,
               regcod,
               regnom,
               sucurs,
               scnom,
               codmon,
               desmon;                                   
  
  cont number := 0;       
  
  cursor c_gasto_hoy is
    select decode(regcod, 999, 999, regcod) regcod,
           upper(decode(regcod, 999, 'TESORERIA', regnom)) regnom,
           sucurs,
           decode(sucurs, 999, 'TESORERIA', scnom) scnom,
           Modulo,
           /*upper(TipOpe) */'INTERES DEVENGADO' Tipope,           
           codmon,
           desmon,
           sum(Saldo) Saldo,
           count(distinct Pgcod || scsuc || scmda || scpap || sccta || scoper ||
                 scsbop || sctope || scmod) NOpe
      from (select --a.bcfech, 
            /*+ parallel(a,5) +*/
             case
               when (a.scmod = 22  and (a.sccta, a.scoper) in
                                                          (select jaql478cta, jaql478ope
                                                             from jaql478
                                                            where jaql478EST = 'A')
                      ) or
                     (a.scmod = 21  and (a.sccta, a.scsbop) in
                                                          (select jaql478cta, jaql478sub
                                                             from jaql478
                                                            where jaql478EST = 'A')
                     )                        
               then
                999
               else
                t81.regcod
             end regcod,
             t80.regnom,
             t.sucurs,
             t.scnom,
             a.scmda codmon,
             decode(a.scmda, 0, 'S/.', 'US$') desmon,
             a.scsdo Saldo,             
             (Case
               when (a.scmod = 429) then
                'CTS'
               else
                f.mdnom
             end) Modulo,
             trim(e.tonom) TipOpe,
             a.pgcod,
             a.scsuc,
             a.scmda,
             a.scpap,
             a.sccta,
             a.scoper,
             a.scsbop,
             a.sctope,
             decode(a.scmod,426,22,21) scmod
        from FSD011 a,
             fst001 t,
             fst811 t81,
             fst810 t80,
             fst003 f,
             fst004 e
       where t81.pgcod = t.pgcod
         and t81.oficod = t.sucurs
         and t.sucurs = a.scsuc
         and t81.regcod < 100
         and t80.pgcod = t81.pgcod
         and t80.regcod = t81.regcod
         and f.modulo = decode(a.scmod,426,22,21)
         and e.modulo = decode(a.scmod,426,22,21)
         and e.totope = a.sctope
         and a.scmod in (426,429)
         and a.scstat <> 99
         )
     group by Modulo, 
              TipOpe, 
              regcod, 
              regnom, 
              sucurs, 
              scnom, 
              codmon, 
              desmon
    union all              
    select decode(regcod, 999, 999, regcod) regcod,
           upper(decode(regcod, 999, 'TESORERIA', regnom)) regnom,
           sucurs,
           decode(sucurs, 999, 'TESORERIA', scnom) scnom,
           Modulo,
           upper(TipOpe) Tipope,           
           codmon,
           desmon,
           sum(Saldo) Saldo,
           count(distinct Pgcod || dvsuc || dvmda || dvpap || dvcta || dvoper ||
                 dvsbop || dvtope || dvmod) NOpe
      from (select --a.bcfech, 
            /*+ parallel(a,5) +*/
             case
               when (a.dvmod = 22  and (a.dvcta, a.dvoper) in
                                                          (select jaql478cta, jaql478ope
                                                             from jaql478
                                                            where jaql478EST = 'A')
                      ) or
                     (a.dvmod = 21  and (a.dvcta, a.dvoper) in
                                                          (select jaql478cta, jaql478sub
                                                             from jaql478
                                                            where jaql478EST = 'A')
                     )                        
               then
                999
               else
                t81.regcod
             end regcod,
             t80.regnom,
             t.sucurs,
             t.scnom,
             a.dvmda codmon,
             decode(a.dvmda, 0, 'S/.', 'US$') desmon,
             a.dvtint Saldo,             
             (Case
               when (g.scmod = 21 and g.sctope = 2) then
                'CTS'
               else
                f.mdnom
             end) Modulo,
             trim(e.tonom) TipOpe,
             a.pgcod,
             a.dvsuc,
             a.dvmda,
             a.dvpap,
             a.dvcta,
             a.dvoper,
             a.dvsbop,
             a.dvtope,
             a.dvmod 
        from FSD313 a,
             fst001 t,
             fst811 t81,
             fst810 t80,
             fst003 f,
             fst004 e,
             fsd011 g
       where t81.pgcod = t.pgcod
         and t81.oficod = t.sucurs
         and t.sucurs = a.dvsuc
         and t81.regcod < 100
         and t80.pgcod = t81.pgcod
         and t80.regcod = t81.regcod
         and f.modulo = a.dvmod
         and e.modulo = a.dvmod
         and e.totope = a.dvtope
         and a.pgcod = g.pgcod
         and a.dvmod = g.scmod
         and a.dvmda = g.scmda
         and a.dvpap = g.scpap
         and a.dvcta = g.sccta
         and a.dvsuc = g.scsuc
         and a.dvoper = g.scoper
         and a.dvsbop = g.scsbop
         and a.dvtope = g.sctope
         and g.scstat <> 99
         and a.dvmod = 21
         and a.dvtope <> 2
         )
     group by Modulo, 
              TipOpe, 
              regcod, 
              regnom, 
              sucurs, 
              scnom, 
              codmon, 
              desmon;                 
              
  cursor c_gasto_mes is
    select P_D_FECPRO Periodo,
           decode(regcod, 999, 999, regcod) regcod,
           upper(decode(regcod, 999, 'TESORERIA', regnom)) regnom,
           sucurs,
           decode(sucurs, 999, 'TESORERIA', scnom) scnom,
           Modulo,
           upper(TipOpe) Tipope,           
           codmon,
           desmon,
           sum(Saldo) Saldo,
           count(distinct Pgcod || hsucur || hmda || hpap || hcta || hoper ||
                 hsubop || htoper || hmodul) NOpe
      from (select --a.bcfech, 
            /*+ parallel(a,5) +*/
             case
               when (a.hmodul = 22  and (a.hcta, a.hoper) in
                                                          (select jaql478cta, jaql478ope
                                                             from jaql478
                                                            where jaql478EST = 'A')
                      ) or
                     (a.hmodul = 21  and (a.hcta, a.hoper) in
                                                          (select jaql478cta, jaql478sub
                                                             from jaql478
                                                            where jaql478EST = 'A')
                     )                        
               then
                999
               else
                t81.regcod
             end regcod,
             t80.regnom,
             t.sucurs,
             t.scnom,
             a.hmda codmon,
             decode(a.hmda, 0, 'S/.', 'US$') desmon,
             a.hcimp1 Saldo,
             (Case
               when (a.hmodul = 21 and a.htoper = 2) then
                'CTS'
               else
                f.mdnom
             end) Modulo,
             trim(e.tonom) TipOpe,
             a.pgcod,
             a.hsucur,
             a.hmda,
             a.hpap,
             a.hcta,
             a.hoper,
             a.hsubop,
             a.htoper,
             a.hmodul
        from fsh016 a,
             fst001 t,
             fst811 t81,
             fst810 t80,
             fst003 f,
             fst004 e
       where t81.pgcod = t.pgcod
         and t81.oficod = t.sucurs
         and t.sucurs = a.hsucur
         and t81.regcod < 100
         and t80.pgcod = t81.pgcod
         and t80.regcod = t81.regcod
         and f.modulo = a.hmodul
         and e.modulo = a.hmodul
         and e.totope = a.htoper
         and a.hfcon = P_D_FECPRO
         and a.pgcod = 1
         and a.hcmod = 99
         and a.hsucor = 11
         and (
             (a.htran = 915 and a.hcord = 6) OR (a.htran = 903 and a.hcord = 3)
             )
                  
         )
     group by P_D_FECPRO,
              Modulo, 
              TipOpe, 
              regcod, 
              regnom, 
              sucurs, 
              scnom, 
              codmon, 
              desmon
 Union All
    select 
           bcfech Periodo,
           decode(regcod, 999, 999, regcod) Regcod,
           upper(decode(regcod, 999, 'TESORERIA', regnom)) regnom,
           sucurs,
           decode(sucurs, 999, 'TESORERIA', scnom) scnom,
           Modulo,
           /*upper(TipOpe)*/'INTERES DEVENGADO' Tipope,
           codmon,
           desmon,
           sum(Saldo) Saldo,
           count(distinct bcemp || bcsuc || bcmda || bcpap || bccta || bcoper ||
                 bcsbop || bctop || bcmod) NOpe
      from (select /*+ parallel(a,5) +*/
                   a.bcfech,
                   case
                     when (decode(a.bcmod,426,22,21) = 22  and (a.bccta, a.bcoper) in
                                                                (select jaql478cta, jaql478ope
                                                                   from jaql478
                                                                  where jaql478EST = 'A')
                            ) or
                           (decode(a.bcmod,426,22,21) = 21  and (a.bccta, a.bcoper) in
                                                                (select jaql478cta, jaql478sub
                                                                   from jaql478
                                                                  where jaql478EST = 'A')
                           )                        
                     then
                      999
                     else
                      t81.regcod
                   end regcod,                   
                   t80.regnom,
                   t.sucurs,
                   t.scnom,
                   a.bcmda codmon,
                   decode(a.bcmda, 0, 'S/.', 'US$') desmon,
                   a.bcsdmo Saldo,
                   (Case
                     when (a.bcmod = 429) then
                      'CTS'
                     else
                      f.mdnom
                   end) Modulo,
                   trim(e.tonom) TipOpe,
                   a.bcemp,
                   a.bcsuc,
                   a.bcmda,
                   a.bcpap,
                   a.bccta,
                   a.bcoper,
                   a.bcsbop,
                   a.bctop bctop,
                   decode(a.bcmod,426,22,21) bcmod                         
              from fsh012 a,
                   fst001 t,
                   fst811 t81,
                   fst810 t80,
                   fst003 f,
                   fst004 e
             where t81.pgcod = t.pgcod
               and t81.oficod = t.sucurs
               and t.sucurs = a.bcsuc
               and t81.regcod < 100
               and t80.pgcod = t81.pgcod
               and t80.regcod = t81.regcod
               and f.modulo = decode(a.bcmod,426,22,21)
               and e.modulo = decode(a.bcmod,426,22,21)
               and e.totope = a.bctop
               and a.bccta <> 999999999
               and a.bcmod  in (426)
               and a.bcfech = P_D_FECPRO
               and a.bcprod <> 99)
     group by  bcfech,
               Modulo,
               TipOpe,
               regcod,
               regnom,
               sucurs,
               scnom,
               codmon,
               desmon;                                 
                            
  Fecproc DATE;
  lc_usuario char(10);
  begin  
/*    delete from jaql479
     where JAQL479USU = P_C_USUARIO
       and JAQL479FEC = P_D_FECPRO
       and JAQL479COD = 2;
    commit;  */ 
    lc_usuario := rpad(P_C_USUARIO,10,' ');  
    execute immediate('truncate table jaql479');
    execute immediate('truncate table temporal');
         
    select a.pgfape into Fecproc  from fst017 a where a.pgcod = P_N_COD;  
    If Fecproc = P_D_FECPRO then         
        For i in c_gasto_hoy loop
          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,
                              JAQL479A31,
                              JAQL479AX1,
                              JAQL479A21,
                              JAQL479AX2,
                              JAQL479A22,
                              JAQL479A23,
                              JAQL479A24,
                              JAQL479AX3,
                              JAQL479A25,
                              JAQL479A11,
                              JAQL479A12,
                              JAQL479A13,
                              JAQL479AX4,
                              JAQL479A14,
                              JAQL479A15
                             )
                       values(lc_usuario,
                              P_D_FECPRO,
                              2,
                              cont,  
                              P_D_FECPRO,
                              i.Regcod,
                              i.regnom,
                              i.sucurs,  
                              i.scnom,
                              i.Modulo,
                              i.Tipope,
                              i.Codmon,
                              i.desmon,
                              i.Saldo,
                              0, 
                              0,
                              i.NOpe,
                              0,
                              0                
                              );
        End Loop;
    ElsIf (P_D_FECPRO < Fecproc) and (last_day(P_D_FECPRO) <> P_D_FECPRO) then
        For i in c_gasto_his loop

          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,
                              JAQL479A31,
                              JAQL479AX1,
                              JAQL479A21,
                              JAQL479AX2,
                              JAQL479A22,
                              JAQL479A23,
                              JAQL479A24,
                              JAQL479AX3,
                              JAQL479A25,
                              JAQL479A11,
                              JAQL479A12,
                              JAQL479A13,
                              JAQL479AX4,
                              JAQL479A14,
                              JAQL479A15
                             )
                       values(lc_usuario,
                              P_D_FECPRO,
                              2,
                              cont,  
                              i.Periodo,
                              i.Regcod,
                              i.regnom,
                              i.sucurs,  
                              i.scnom,
                              i.Modulo,
                              i.Tipope,
                              i.Codmon,
                              i.desmon,
                              i.Saldo,
                              0, 
                              0,
                              i.NOpe,
                              0,
                              0                
                              );

        End Loop;    
    Else
        For i in c_gasto_mes loop

          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,
                              JAQL479A31,
                              JAQL479AX1,
                              JAQL479A21,
                              JAQL479AX2,
                              JAQL479A22,
                              JAQL479A23,
                              JAQL479A24,
                              JAQL479AX3,
                              JAQL479A25,
                              JAQL479A11,
                              JAQL479A12,
                              JAQL479A13,
                              JAQL479AX4,
                              JAQL479A14,
                              JAQL479A15
                             )
                       values(lc_usuario,
                              P_D_FECPRO,
                              2,
                              cont,  
                              i.Periodo,
                              i.Regcod,
                              i.regnom,
                              i.sucurs,  
                              i.scnom,
                              i.Modulo,
                              i.Tipope,
                              i.Codmon,
                              i.desmon,
                              i.Saldo,
                              0, 
                              0,
                              i.NOpe,
                              0,
                              0                
                              );

        End Loop;            
    End If;
    commit;
  End sp_ah_gasto_ahorros;                
  Procedure sp_ah_cli_newret(P_C_USUARIO IN VARCHAR2,
                             P_D_FECPRO  IN DATE,
                             P_N_TIPO    IN NUMBER            
                            ) IS

    TYPE tp_bcfech IS TABLE OF fsh012.bcfech%type INDEX BY BINARY_INTEGER;
    TYPE tp_pepais IS TABLE OF fsr008.pepais%type INDEX BY BINARY_INTEGER;
    TYPE tp_petdoc IS TABLE OF fsr008.petdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_pendoc IS TABLE OF fsr008.pendoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_petipo IS TABLE OF fsd001.petipo%type INDEX BY BINARY_INTEGER;
    TYPE tp_bcfval IS TABLE OF fsh012.bcfval%type INDEX BY BINARY_INTEGER;
    TYPE tp_bcmod  IS TABLE OF fsh012.bcmod%type INDEX BY BINARY_INTEGER;
    TYPE tp_bctop  IS TABLE OF fsh012.bctop%type INDEX BY BINARY_INTEGER;
    TYPE tp_bcsuc  IS TABLE OF fsh012.bcsuc%type INDEX BY BINARY_INTEGER;
    TYPE tp_bcprod IS TABLE OF fsh012.bcprod%type INDEX BY BINARY_INTEGER;
    TYPE tp_cont IS TABLE OF fsd011.sccta%type INDEX BY BINARY_INTEGER;
                                
    lc_bcfech      tp_bcfech ;      
    lc_pepais      tp_pepais ;
    lc_petdoc      tp_petdoc ;
    lc_pendoc      tp_pendoc ;
    lc_petipo      tp_petipo ;    
    lc_bcfval      tp_bcfval ;      
    lc_bcmod       tp_bcmod ;
    lc_bctop       tp_bctop ;
    lc_bcsuc       tp_bcsuc ;
    lc_bcprod      tp_bcprod ;
    lc_cont        tp_cont ;
    lc_usuario char(10);
    
    cursor det_ah(ld_fecha in date) is      
       select  h012.bcfech,
               r008.pepais,
               r008.petdoc,
               r008.pendoc,
               d001.petipo, 
               h012.bcfval,
               h012.bcmod,
               h012.bctop,
               nvl(j60.jaql60sucu,999) bcsuc,
               h012.bcprod,
               rownum cont
          from fsh012 h012 left join fsr008 r008 on r008.pgcod  = h012.bcemp
                                                and r008.ctnro  = h012.bccta
                                                and r008.ttcod  = 1
                                                and r008.cttfir = 'T'
                           left join fsd001 d001 on d001.pepais = r008.pepais
                                                and d001.petdoc = r008.petdoc
                                                and d001.pendoc = r008.pendoc
                           left join jaql060 j60 on j60.jaql60pais = r008.pepais                       
                                                and j60.jaql60tdoc = r008.petdoc
                                                and j60.jaql60ndoc = r008.pendoc
                                                and j60.jaql60pgco = 1                                                
                                                 
         where h012.bcfech  = ld_fecha 
           and h012.bccta  <> 999999999
           and h012.bcmod  in (21,22)
           and h012.bcprod <> 99;                
           
 cursor clientes(ld_fecha in date) is                
       select  h012.bcfech,
               r008.pepais,
               r008.petdoc,
               r008.pendoc,
               d001.petipo, 
               h012.bcfval,
               nvl(j60.jaql60sucu,999) bcsuc,
               rownum cont
          from fsh012 h012 left join fsr008 r008 on r008.pgcod  = h012.bcemp
                                                and r008.ctnro  = h012.bccta
                                                and r008.ttcod  = 1
                                                and r008.cttfir = 'T'
                           left join fsd001 d001 on d001.pepais = r008.pepais
                                                and d001.petdoc = r008.petdoc
                                                and d001.pendoc = r008.pendoc
                           left join jaql060 j60 on j60.jaql60pais = r008.pepais                       
                                                and j60.jaql60tdoc = r008.petdoc
                                                and j60.jaql60ndoc = r008.pendoc
                                                and j60.jaql60pgco = 1
                                                 
         where h012.bcfech  = ld_fecha
           and h012.bccta  <> 999999999
           and h012.bcmod  in (21,22)
           and h012.bcprod <> 99;        
                
  lc_periodo varchar2(10);    
  Cursor c_nuevos_p(PERIODO IN DATE) is
    select 
           decode(sucurs, 999, 999, regcod) Regcod,
           upper(decode(sucurs, 999, 'SIN ASIGNAR', regnom)) regnom,
           sucurs,
           decode(sucurs, 999, 'SIN ASIGNAR', scnom) scnom,
           count(distinct u.pepais||u.petdoc||u.pendoc) Clientes
--      from (select /*+ parallel(a,5) +*/
        FROM (SELECT /*+ index_ss(T) use_nl(T80 T81) parallel(F,2,1)*/ --30.10.2014
                    distinct 
                    t81.regcod,
                    t80.regnom,
                    t.sucurs,
                    t.scnom,
                    a.JAQL479AX1 pepais,
                    a.JAQL479AX2 petdoc,
                    a.JAQL479A21 pendoc,
                    a.JAQL479A32 bcfval
              from jaql479 a,
                   fst001 t,
                   (
                    --select PGCOD,REGCOD,OFICOD,OFISUC,OFIFCH,OFIHOR,OFIHAB 
                    select /*+index_ss(FST811)*/ PGCOD,REGCOD,OFICOD,OFISUC,OFIFCH,OFIHOR,OFIHAB  --30.10.2014
                      from fst811 
                    union
                    select 1,999,999,'S',null,null,null from dual
                   )t81,
                   (--select pgcod,regcod,regnom  
                   select /*+index_ss(FST810)*/ pgcod,regcod,regnom   --30.10.2014                   
                     from fst810 
                    union
                    select 1,999,'SIN ASIGNAR' from dual
                   ) t80,
                   jaql106 i 
             where t81.pgcod = t.pgcod
               and t81.oficod = t.sucurs
               and t.sucurs = a.JAQL479AX5
               and (t81.regcod < 100 OR t81.regcod = 999)
               and t80.pgcod = t81.pgcod
               and t80.regcod = t81.regcod
               and a.JAQL479USU = lc_usuario
               and a.JAQL479FEC = P_D_FECPRO
               and a.JAQL479COD = 3   
               --and a.JAQL479A32 = i.jaql106fhc
               and i.jaql106fhc between PERIODO AND last_day(PERIODO)
               and a.JAQL479A32 between PERIODO AND last_day(PERIODO)
               and i.jaql106pai = a.JAQL479AX1
               and i.jaql106tdo = a.JAQL479AX2
               and i.jaql106doc = substr(a.JAQL479A21,1,12)
               and i.jaql106a01 = 1                               
               ) u
     group by  regcod,
               regnom,
               sucurs,
               scnom;
                                                        
  Cursor c_nuevos_c(PERIODO IN DATE) is
    select 
           decode(sucurs, 999, 999, regcod) Regcod,
           upper(decode(sucurs, 999, 'SIN ASIGNAR', regnom)) regnom,
           sucurs,
           decode(sucurs, 999, 'SIN ASIGNAR', scnom) scnom,
           Modulo,
           upper(TipOpe) Tipope,
           petipo,
           count(distinct u.pepais||u.petdoc||u.pendoc) Clientes
      from (select /*+ parallel(a,5) */
                   t81.regcod,
                   t80.regnom,
                   t.sucurs,
                   t.scnom,
                   (Case
                     when (a.JAQL479AX3 = 21 and a.JAQL479AX4 = 2) then
                      'CTS'
                     else
                      f.mdnom
                   end) Modulo,
                   trim(e.tonom) TipOpe,
                   (Case 
                    When trim(a.JAQL479A22)  = 'F' then
                    'FISICA'                      
                    else
                    'JURIDICA'
                    end
                    ) petipo,
                    a.JAQL479AX1 pepais,
                    a.JAQL479AX2 petdoc,
                    a.JAQL479A21 pendoc,
                    a.JAQL479A32 bcfval
              from jaql479 a,
                   fst001 t,
                   (
                    select PGCOD,REGCOD,OFICOD,OFISUC,OFIFCH,OFIHOR,OFIHAB 
                      from fst811 
                    union
                    select 1,999,999,'S',null,null,null from dual
                   )t81,
                   (select pgcod,regcod,regnom  
                     from fst810 
                    union
                    select 1,999,'SIN ASIGNAR' from dual
                   ) t80,
                   fst003 f,
                   fst004 e
             where t81.pgcod = t.pgcod
               and t81.oficod = t.sucurs
               and t.sucurs = a.JAQL479AX5
               and (t81.regcod < 100 OR t81.regcod = 999)
               and t80.pgcod = t81.pgcod
               and t80.regcod = t81.regcod
               and f.modulo = a.JAQL479AX3
               and e.modulo = a.JAQL479AX3
               and e.totope = a.JAQL479AX4
               and a.JAQL479USU = lc_usuario
               and a.JAQL479FEC = P_D_FECPRO
               and a.JAQL479COD = 3    
               ) u,
               jaql106 i 
        where --u.bcfval = i.jaql106fhc
              i.jaql106fhc between PERIODO AND last_day(PERIODO)
          and u.bcfval between PERIODO AND LAST_DAY(PERIODO)
          and i.jaql106pai = u.pepais
          and i.jaql106tdo = u.petdoc
          and i.jaql106doc = substr(u.pendoc,1,12)
          and i.jaql106a01 = 1                              
     group by  Modulo,
               TipOpe,
               regcod,
               regnom,
               sucurs,
               scnom,
               petipo;    
               
  Cursor c_retenidos_p is
     select 
               decode(u.sucurs, 999, 999, u.regcod) Regcod,
               upper(decode(u.sucurs, 999, 'SIN ASIGNAR', u.regnom)) regnom,
               u.sucurs,
               decode(u.sucurs, 999, 'SIN ASIGNAR', u.scnom) scnom,
               count(distinct u.pepais||u.petdoc||u.pendoc) Clientes
          from (  
                  select /*+ parallel(b,5) */
                         t81.regcod,
                         t80.regnom,
                         t.sucurs,
                         t.scnom,
                         a.JAQL479AX1 pepais,
                         a.JAQL479AX2 petdoc,
                         a.JAQL479A21 pendoc
                    from jaql479  a,
                         temporal b,
                         fst001   t,
                         (
                          select PGCOD,REGCOD,OFICOD,OFISUC,OFIFCH,OFIHOR,OFIHAB 
                            from fst811 
                          union
                          select 1,999,999,'S',null,null,null from dual
                         )t81,
                         (select pgcod,regcod,regnom  
                           from fst810 
                          union
                          select 1,999,'SIN ASIGNAR' from dual
                         ) t80
                   where a.JAQL479USU = b.JAQLXXXUSU
                     and a.JAQL479FEC = b.JAQLXXXFEC
                     and a.JAQL479AX1 = b.JAQLXXXAX1
                     and a.JAQL479AX2 = b.JAQLXXXAX2
                     and a.JAQL479A21 = b.JAQLXXXA21
                     and a.JAQL479COD = 3
                     and b.JAQLXXXCOD = 5
                     and a.JAQL479USU = lc_usuario
                     and a.JAQL479FEC = P_D_FECPRO
                     and t81.pgcod = t.pgcod
                     and t81.oficod = t.sucurs
                     and t.sucurs = a.JAQL479AX5
                     and (t81.regcod < 100 OR t81.regcod = 999)
                     and t80.pgcod = t81.pgcod
                     and t80.regcod = t81.regcod
             ) u
       group by u.regcod,
                u.regnom,
                u.sucurs,
                u.scnom           
             ;        
  Cursor c_retenidos_c is
     select 
               decode(u.sucurs, 999, 999, u.regcod) Regcod,
               upper(decode(u.sucurs, 999, 'SIN ASIGNAR', u.regnom)) regnom,
               u.sucurs,
               decode(u.sucurs, 999, 'SIN ASIGNAR', u.scnom) scnom,
               u.Modulo,
               upper(u.TipOpe) Tipope,
               u.petipo,
               count(distinct u.pepais||u.petdoc||u.pendoc) Clientes
          from (  
                  select /*+ parallel(b,5) */
                         a.JAQL479FEC bcfech,
                         t81.regcod,
                         t80.regnom,
                         t.sucurs,
                         t.scnom,
                         (Case
                           when (a.JAQL479AX3 = 21 and a.JAQL479AX4 = 2) then
                            'CTS'
                           else
                            f.mdnom
                         end) Modulo,
                         trim(e.tonom) TipOpe,
                         (Case
                           When trim(a.JAQL479A22) = 'F' then
                            'FISICA'
                           else
                            'JURIDICA'
                         end) petipo,
                         a.JAQL479AX1 pepais,
                         a.JAQL479AX2 petdoc,
                         a.JAQL479A21 pendoc
                    from jaql479  a,
                         temporal b,
                         fst001   t,
                         (
                          select PGCOD,REGCOD,OFICOD,OFISUC,OFIFCH,OFIHOR,OFIHAB 
                            from fst811 
                          union
                          select 1,999,999,'S',null,null,null from dual
                         )t81,
                         (select pgcod,regcod,regnom  
                           from fst810 
                          union
                          select 1,999,'SIN ASIGNAR' from dual
                         ) t80,
                         fst003   f,
                         fst004   e
                   where a.JAQL479USU = b.JAQLXXXUSU
                     and a.JAQL479FEC = b.JAQLXXXFEC
                     and a.JAQL479AX1 = b.JAQLXXXAX1
                     and a.JAQL479AX2 = b.JAQLXXXAX2
                     and a.JAQL479A21 = b.JAQLXXXA21
                     and a.JAQL479COD = 3
                     and b.JAQLXXXCOD = 5
                     and a.JAQL479USU = lc_usuario
                     and a.JAQL479FEC = P_D_FECPRO
                     and t81.pgcod = t.pgcod
                     and t81.oficod = t.sucurs
                     and t.sucurs = a.JAQL479AX5
                     and (t81.regcod < 100 OR t81.regcod = 999)
                     and t80.pgcod = t81.pgcod
                     and t80.regcod = t81.regcod
                     and f.modulo = a.JAQL479AX3
                     and e.modulo = a.JAQL479AX3
                     and e.totope = a.JAQL479AX4
             ) u
       group by u.Modulo,
                u.TipOpe,
                u.regcod,
                u.regnom,
                u.sucurs,
                u.scnom,
                u.petipo           
             ; 
  Cursor c_resultado is  
    select 
            z.JAQL479USU,
            z.JAQL479FEC,
            z.JAQL479AX1,                          
            z.JAQL479A21,   
            z.JAQL479AX2,                                    
            z.JAQL479A22,             
            z.JAQL479A23,
            z.JAQL479A24,
            z.JAQL479A25,
            sum(z.JAQL479AX3) /*JAQL479AX3 */NUEVOS,
            sum(z.JAQL479AX4) /*JAQL479AX4 */RETENIDOS
       from (
               select JAQL479USU,
                      JAQL479FEC,
                      JAQL479COD,
                      JAQL479COR,                                       
                      JAQL479AX1,                          
                      JAQL479A21,   
                      JAQL479AX2,                                    
                      JAQL479A22,             
                      JAQL479A23,
                      JAQL479A24,
                      JAQL479A25,
                      JAQL479AX3,
                      JAQL479AX4
                 from JAQL479
                Where JAQL479COD = 4
                  and JAQL479USU = lc_usuario
                  and JAQL479FEC = P_D_FECPRO
              union all    
               select JAQL479USU,
                      JAQL479FEC,
                      JAQL479COD,
                      JAQL479COR,                                       
                      JAQL479AX1,                          
                      JAQL479A21,   
                      JAQL479AX2,                                    
                      JAQL479A22,             
                      JAQL479A23,
                      JAQL479A24,
                      JAQL479A25,
                      JAQL479AX3,
                      JAQL479AX4
                 from JAQL479
                Where JAQL479COD = 6
                  and JAQL479USU = lc_usuario
                  and JAQL479FEC = P_D_FECPRO
            ) z
    group by JAQL479USU,
             JAQL479FEC,
             JAQL479AX1,                          
             JAQL479A21,   
             JAQL479AX2,                                    
             JAQL479A22,             
             JAQL479A23,
             JAQL479A24,
             JAQL479A25;
  
                                
  cont number := 0;       
  ld_fecha DATE;
  ld_Periodo Date;

  begin  
             
/*    delete from jaql479
     where JAQL479USU = P_C_USUARIO
       and JAQL479FEC = P_D_FECPRO
       and JAQL479COD >= 3;
    commit;   */
    lc_usuario := rpad(P_C_USUARIO,10,' ');
    execute immediate('truncate table jaql479');
    execute immediate('truncate table temporal');
          
    lc_periodo := to_char(P_D_FECPRO,'DD/MM/YYYY');
    lc_periodo := substr(lc_periodo,3,8);
    ld_fecha := P_D_FECPRO;     
    ld_Periodo := to_date('01'||lc_periodo,'DD/MM/YYYY');
    
    If P_N_TIPO = 1 Then          
    
        OPEN det_ah(ld_fecha);
              LOOP
              FETCH det_ah BULK COLLECT 
               INTO lc_bcfech,  lc_pepais, lc_petdoc, lc_pendoc, lc_petipo, 
                    lc_bcfval, lc_bcmod , lc_bctop,  lc_bcsuc,  lc_bcprod , lc_cont
              LIMIT 10000;
              EXIT WHEN lc_bcfech.count = 0;                  
                   NULL;                                     
                  begin                    
                  FORALL z IN 1..lc_bcfech.COUNT
                  
                  insert /*+ append */ into jaql479(
                                        JAQL479USU,
                                        JAQL479FEC,
                                        JAQL479COD,
                                        JAQL479COR,                          
                                        JAQL479A31,             
                                        JAQL479AX1,             
                                        JAQL479AX2,             
                                        JAQL479A21,             
                                        JAQL479A22,             
                                        JAQL479A32,             
                                        JAQL479AX3,             
                                        JAQL479AX4,             
                                        JAQL479AX5,             
                                        JAQL479AX6             
                                       )
                                 values(lc_usuario,
                                        P_D_FECPRO,
                                        3,
                                        lc_cont(z),  
                                        lc_bcfech(z),  
                                        lc_pepais(z), 
                                        lc_petdoc(z), 
                                        lc_pendoc(z), 
                                        lc_petipo(z), 
                                        lc_bcfval(z), 
                                        lc_bcmod(z), 
                                        lc_bctop(z),  
                                        lc_bcsuc(z),  
                                        lc_bcprod(z) 
                                        );                
                              commit;          
                   exception
                   when others then
                        null;         
                   end;  
              END LOOP;       
        CLOSE det_ah;    
        cont := 0;
        For i in c_nuevos_c(ld_Periodo) loop
          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,                                       
                              JAQL479AX1,                          
                              JAQL479A21,   
                              JAQL479AX2,                                    
                              JAQL479A22,             
                              JAQL479A23,
                              JAQL479A24,
                              JAQL479A25,
                              JAQL479AX3,
                              JAQL479AX4
                              )       
                       values(lc_usuario,
                              P_D_FECPRO,
                              4,
                              cont,  
                              i.Regcod,
                              i.regnom,  
                              i.sucurs,
                              i.scnom,                          
                              i.Modulo,
                              i.Tipope,
                              i.petipo,
                              i.Clientes,
                              0
                              );    
        End Loop;
        commit;
        cont:=0;
        -- cargamos lo retenidos del año pasado diciembre
        ld_fecha := add_months(P_D_FECPRO,-12);
        lc_periodo := to_char(ld_fecha,'rrrrmmdd');
        lc_periodo := '31/12/'||substr(lc_periodo,1,4);
        ld_fecha := to_date(lc_periodo,'DD/MM/YYYY');        
           
        OPEN det_ah(ld_fecha);
              LOOP
              FETCH det_ah BULK COLLECT 
               INTO lc_bcfech,  lc_pepais, lc_petdoc, lc_pendoc, lc_petipo, 
                    lc_bcfval, lc_bcmod , lc_bctop,  lc_bcsuc,  lc_bcprod, lc_cont 
              LIMIT 10000;
              EXIT WHEN lc_bcfech.count = 0;                  
                   NULL;                                     
                  begin                    
                  FORALL z IN 1..lc_bcfech.COUNT
                  
                  insert /*+ append */ into temporal(
                                        JAQLXXXUSU,
                                        JAQLXXXFEC,
                                        JAQLXXXCOD,
                                        JAQLXXXCOR,                          
                                        JAQLXXXA31,             
                                        JAQLXXXAX1,             
                                        JAQLXXXAX2,             
                                        JAQLXXXA21,             
                                        JAQLXXXA22,             
                                        JAQLXXXA32,             
                                        JAQLXXXAX3,             
                                        JAQLXXXAX4,             
                                        JAQLXXXAX5,             
                                        JAQLXXXAX6             
                                       )
                                 values(lc_usuario,
                                        P_D_FECPRO,
                                        5,
                                        lc_cont(z),  
                                        lc_bcfech(z),  
                                        lc_pepais(z), 
                                        lc_petdoc(z), 
                                        lc_pendoc(z), 
                                        lc_petipo(z), 
                                        lc_bcfval(z), 
                                        lc_bcmod(z), 
                                        lc_bctop(z),  
                                        lc_bcsuc(z),  
                                        lc_bcprod(z) 
                                        );                
                              commit;          
                   exception
                   when others then
                        null;         
                   end;  
              END LOOP;       
        CLOSE det_ah;       
        cont := 0;
        --CREAMOS INDICE PARA OPTIMIZAR QUERY
        begin execute immediate ('create index IJAQL479IDX02 on bantprod.JAQL479 (JAQL479USU, JAQL479FEC, JAQL479COD, JAQL479AX1, JAQL479AX2, JAQL479A21) tablespace bantprod_idx'); exception when others then null; end;
        begin SYS.dbms_stats.gather_table_stats('BANTPROD','JAQL479'); end;
        --begin execute immediate ('create index IJAQL479IDX02 on JAQL479 (JAQL479USU, JAQL479FEC, JAQL479COD, JAQL479AX1, JAQL479AX2, JAQL479A21)'); exception when others then null; end;--40s        
        --begin SYS.dbms_stats.gather_table_stats('DESA01082014A','JAQL479'); end;        
        For i in c_retenidos_c loop
          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,                                       
                              JAQL479AX1,                          
                              JAQL479A21,   
                              JAQL479AX2,                                    
                              JAQL479A22,             
                              JAQL479A23,
                              JAQL479A24,
                              JAQL479A25,
                              JAQL479AX3,
                              JAQL479AX4
                              )       
                       values(lc_usuario,
                              P_D_FECPRO,
                              6,
                              cont,  
                              i.Regcod,
                              i.regnom,  
                              i.sucurs,
                              i.scnom,                          
                              i.Modulo,
                              i.Tipope,
                              i.petipo,
                              0,
                              i.Clientes
                              );    
        End Loop;
        commit;    
    Else
    
    OPEN clientes(ld_fecha);
              LOOP
              FETCH clientes BULK COLLECT 
               INTO lc_bcfech,  lc_pepais, lc_petdoc, lc_pendoc, lc_petipo, 
                    lc_bcfval,  lc_bcsuc,  lc_cont
              LIMIT 10000;
              EXIT WHEN lc_bcfech.count = 0;                  
                   NULL;                                     
                  begin                    
                  FORALL z IN 1..lc_bcfech.COUNT
                  
                  insert /*+ append */ into jaql479(
                                        JAQL479USU,
                                        JAQL479FEC,
                                        JAQL479COD,
                                        JAQL479COR,                          
                                        JAQL479A31,             
                                        JAQL479AX1,             
                                        JAQL479AX2,             
                                        JAQL479A21,             
                                        JAQL479A22,             
                                        JAQL479A32,             
                                        JAQL479AX5                          
                                       )
                                 values(lc_usuario,
                                        P_D_FECPRO,
                                        3,
                                        lc_cont(z),  
                                        lc_bcfech(z),  
                                        lc_pepais(z), 
                                        lc_petdoc(z), 
                                        lc_pendoc(z), 
                                        lc_petipo(z), 
                                        lc_bcfval(z),   
                                        lc_bcsuc(z)  
                                        );                
                              commit;          
                   exception
                   when others then
                        null;         
                   end;  
              END LOOP;       
        CLOSE clientes;        
        cont := 0;
        For i in c_nuevos_p(ld_Periodo) loop
          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,                                       
                              JAQL479AX1,                          
                              JAQL479A21,   
                              JAQL479AX2,                                    
                              JAQL479A22,             
                              JAQL479AX3,
                              JAQL479AX4
                              )       
                       values(lc_usuario,
                              P_D_FECPRO,
                              4,
                              cont,  
                              i.Regcod,
                              i.regnom,  
                              i.sucurs,
                              i.scnom,                          
                              i.Clientes,
                              0
                              );    
        End Loop;
        commit;
        cont:=0;
        -- cargamos lo retenidos del año pasado diciembre
        ld_fecha := add_months(P_D_FECPRO,-12);
        lc_periodo := to_char(ld_fecha,'rrrrmmdd');
        lc_periodo := '31/12/'||substr(lc_periodo,1,4);
        ld_fecha := to_date(lc_periodo,'DD/MM/YYYY');
        
        OPEN clientes(ld_fecha);
              LOOP
              FETCH clientes BULK COLLECT 
               INTO lc_bcfech,  lc_pepais, lc_petdoc, lc_pendoc, lc_petipo, 
                    lc_bcfval,  lc_bcsuc,  lc_cont
              LIMIT 10000;
              EXIT WHEN lc_bcfech.count = 0;                  
                   NULL;                                     
                  begin                    
                  FORALL z IN 1..lc_bcfech.COUNT
                  
                  insert /*+ append */ into temporal(
                                        JAQLXXXUSU,
                                        JAQLXXXFEC,
                                        JAQLXXXCOD,
                                        JAQLXXXCOR,                          
                                        JAQLXXXA31,             
                                        JAQLXXXAX1,             
                                        JAQLXXXAX2,             
                                        JAQLXXXA21,             
                                        JAQLXXXA22,             
                                        JAQLXXXA32,             
                                        JAQLXXXAX5            
                                       )
                                 values(lc_usuario,
                                        P_D_FECPRO,
                                        5,
                                        lc_cont(z),  
                                        lc_bcfech(z),  
                                        lc_pepais(z), 
                                        lc_petdoc(z), 
                                        lc_pendoc(z), 
                                        lc_petipo(z), 
                                        lc_bcfval(z),   
                                        lc_bcsuc(z)   
                                        );          
                              commit;          
                   exception
                   when others then
                        null;         
                   end;  
              END LOOP;       
        CLOSE clientes;  
        cont := 0;
        begin execute immediate ('create index IJAQL479IDX02 on JAQL479 (JAQL479USU, JAQL479FEC, JAQL479COD, JAQL479AX1, JAQL479AX2, JAQL479A21) tablespace bantprod_idx'); exception when others then null; end;
        begin SYS.dbms_stats.gather_table_stats('BANTPROD','JAQL479'); end;        
        --begin execute immediate ('create index IJAQL479IDX02 on JAQL479 (JAQL479USU, JAQL479FEC, JAQL479COD, JAQL479AX1, JAQL479AX2, JAQL479A21)'); exception when others then null; end;--40s        
        --begin SYS.dbms_stats.gather_table_stats('DESA01082014A','JAQL479'); end;          
        For i in c_retenidos_p loop

          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,                                       
                              JAQL479AX1,                          
                              JAQL479A21,   
                              JAQL479AX2,                                    
                              JAQL479A22,             
                              JAQL479AX3,
                              JAQL479AX4
                              )       
                       values(lc_usuario,
                              P_D_FECPRO,
                              6,
                              cont,  
                              i.Regcod,
                              i.regnom,  
                              i.sucurs,
                              i.scnom,                          
                              0,
                              i.Clientes
                              );    
        End Loop;
        commit;                                          
    End If;  
    
    -- GRABAMOS EL RESULTADO FINAL
    cont := 0;
    For i in c_resultado loop
          cont := cont + 1;  
          insert into jaql479(JAQL479USU,
                              JAQL479FEC,
                              JAQL479COD,
                              JAQL479COR,                                       
                              JAQL479AX1,                          
                              JAQL479A21,   
                              JAQL479AX2,                                    
                              JAQL479A22,             
                              JAQL479A23,
                              JAQL479A24,
                              JAQL479A25,
                              JAQL479AX3,
                              JAQL479AX4
                              )       
                       values(i.JAQL479USU,
                              i.JAQL479FEC,
                              7,
                              cont,  
                              i.JAQL479AX1,
                              i.JAQL479A21,  
                              i.JAQL479AX2,
                              i.JAQL479A22,                          
                              i.JAQL479A23,
                              i.JAQL479A24,
                              i.JAQL479A25,
                              i.NUEVOS,
                              i.RETENIDOS
                              );    
    End Loop;
    commit;     
    begin execute immediate ('drop index  IJAQL479IDX02'); exception when others then null; end;                 
  End sp_ah_cli_newret;                 
  Function fn_ah_tasa_AH_DPF(P_PGCOD in number,
                             P_SCSUC in number,
                             P_SCCTA in number,                             
                             P_SCMDA in number,                             
                             P_SCPAP in number,
                             P_SCOPE in number,
                             P_SCSBO in number,
                             P_SCTPO in number,
                             P_SCMOD in number
                            ) return number is
 ln_tasa number(8,2);                            
 Begin                            
  pq_ah_rep_ahorros.sp_tasa_producto(vpgcod  => P_PGCOD,
                                     vscsuc  => P_SCSUC,
                                     vsccta  => P_SCCTA,
                                     vscmda  => P_SCMDA,
                                     vscpap  => P_SCPAP,
                                     vscoper => P_SCOPE,
                                     vscsbop => P_SCSBO,
                                     vsctope => P_SCTPO,
                                     vscmod  => P_SCMOD,
                                     tasa => ln_tasa
                                     );
 return ln_tasa;                                      
 End fn_ah_tasa_AH_DPF;
                               
end pq_ah_rep_ahorros;
/

