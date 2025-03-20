CREATE OR REPLACE PROCEDURE SP_AH_INSJAQZ001( LN_AGENCIA  IN NUMBER,
                                              LC_USUARIO  IN VARCHAR2,
                                              LD_FECHAINI IN DATE,
                                              LD_FECHAFIN IN DATE,
                                              LN_TIPO     IN NUMBER) IS
  cursor tablasdia (fecha in date,sucursal in number) is
    select (select scnom from fst001 where sucurs = f6.itsuc) agencia,
           decode (f9.tp1nro1,22,'Depositos Plazo Fijo','Cuentas de Ahorro') producto,
           decode(f6.moneda,0,'Nuevos Soles','Dolares Americanos') moneda,
           f6.moneda nromoneda,
           f9.tp1desc descripcion,
           f5.itfcon fecha, 
           f5.ithora hora,
           f9.tp1nro1 modulo,
           decode(f9.tp1nro1,22, (Lpad(trim(to_char(f6.ctnro)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( f6.moneda)),3,'0') ||'-'|| Lpad(trim(to_char(f6.itoper)),9,'0') ||'-'|| Lpad(trim(to_char(f6.ittope)),3,'0')),
                  (Lpad(trim(to_char(f6.ctnro)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( f6.moneda)),3,'0') ||'-'|| Lpad(trim(to_char(f6.itsubo)),2,'0') ||'-'|| Lpad(trim(to_char(f6.ittope)),3,'0'))) cuenta,            
           (select penom from fsd001 where pepais = f8.pepais and petdoc = f8.petdoc and pendoc = f8.pendoc) titular,
           f5.ituing usuing,
           f5.itucnf usucof,
           f10.exusau usuauto
      from fst198 f9, fsd016 f6, fsd015 f5, fsr008 f8, fsh010 f10
     Where f9.Tp1cod = 1
       and f9.Tp1cod1 = 10891
       and f9.Tp1corr1 = 4
       and f9.Tp1corr2 = 1
       and f6.pgcod = f9.tp1cod
       and f6.itsuc = sucursal ---2 ---ingreso suc
       and f6.itmod = f9.tp1nro1
       and f6.ittran = f9.tp1nro2
       and f6.itord = f9.tp1nro3
       and f5.pgcod = f6.pgcod
       and f5.itsuc = f6.itsuc
       and f5.itmod = f6.itmod
       and f5.ittran = f6.ittran
       and f5.itnrel = f6.itnrel
       and f5.itcorr = 0
       and f5.itcont = 'S'
       and f8.pgcod = f6.pgcod
       and f8.ctnro = f6.ctnro
       and f8.cttfir = 'T'
       and f10.pgcod = f6.pgcod
       and f10.hcmod = f6.itmod
       and f10.hsucor = f6.itsuc
       and f10.htran = f6.ittran   
       and f10.hcord = trunc(f9.tp1imp2)
       and f10.hnrel = f6.itnrel
       and f10.hfcont = fecha-----pgfape
       order by 1,2,4;
    cursor tablashist (sucursal in number) is  
    select (select scnom from fst001 where sucurs = f6.hsucor) agencia,
           decode (f9.tp1nro1,22,'Depositos Plazo Fijo','Cuentas de Ahorro') producto,
           decode(f6.hmda,0,'Nuevos Soles','Dolares Americanos') moneda,
           f6.hmda nromoneda,
           f9.tp1desc descripcion,
           f5.hfcon fecha , 
           f5.hhora hora,
            decode(f9.tp1nro1,22, (Lpad(trim(to_char(f6.Hcta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( f6.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(f6.hoper)),9,'0') ||'-'|| Lpad(trim(to_char(f6.htoper)),3,'0')),
                  (Lpad(trim(to_char(f6.Hcta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( f6.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(f6.hsubop)),2,'0') ||'-'|| Lpad(trim(to_char(f6.htoper)),3,'0'))) cuenta,        
           (select penom from fsd001 where pepais = f8.pepais and petdoc = f8.petdoc and pendoc = f8.pendoc) titular,
           f5.husing usuing,
           f5.huscnf usucof,
           f10.exusau usuauto
      from fst198 f9, fsh016 f6, fsh015 f5, fsr008 f8, fsh010 f10
     Where f9.Tp1cod = 1
       and f9.Tp1cod1 = 10891
       and f9.Tp1corr1 = 4
       and f9.Tp1corr2 = 1
       and f6.pgcod = f9.tp1cod
       and f6.hsucor = sucursal
       and f6.hfcon Between LD_FECHAINI and LD_FECHAFIN 
       and f6.hcmod = f9.tp1nro1
       and f6.htran = f9.tp1nro2
       and f6.hcord = f9.tp1nro3
       and f5.pgcod = f6.pgcod
       and f5.hsucor = f6.hsucor
       and f5.hcmod = f6.hcmod
       and f5.htran = f6.htran
       and f5.hnrel = f6.hnrel
       and f5.hfcon = f6.hfcon
       and f5.hccorr <> 99
       and f8.pgcod = f6.pgcod
       and f8.ctnro = f6.hcta
       and f8.cttfir = 'T'
       and f10.pgcod = f6.pgcod
       and f10.hcmod = f6.hcmod
       and f10.hsucor = f6.hsucor
       and f10.htran = f6.htran  
       and f10.hcord = trunc(f9.tp1imp2)
       and f10.hnrel = f6.hnrel
       and f10.hfcont = f6.hfcon ---Between LD_FECHAINI and LD_FECHAFIN 
       order by 1,2,4;                                    
 fechahoy date ;   
 cont number  := 0;
BEGIN
  
   DELETE JAQZ001
   WHERE jaqz001usu = rpad(LC_USUARIO,10,' ')
     AND jaqz001tre = 'R'
     AND jaqz001tsa = 'R';
     COMMIT;
  select pgfape into fechahoy from fst017 where pgcod = 1;         
  CASE LN_TIPO 
    WHEN 1 THEN
        if LN_AGENCIA <> 0 then
          For reg in tablashist (LN_AGENCIA)loop
            cont := cont + 1;
            insert into jaqz001 ( jaqz001usu,
                                  jaqz001tre,
                                  jaqz001tsa,  
                                  jaqz001cor, 
                                  JAQZ001001,                        
                                  jaqz001002,
                                  jaqz001003,
                                  jaqz001004,
                                  jaqz001005,
                                  jaqz001014,
                                  jaqz001007,
                                  jaqz001008,
                                  jaqz001009,                           
                                  jaqz001013,
                                  jaqz001016)                                  
                           values( LC_USUARIO,
                                   'R',
                                   'R',
                                   SEQ_JAQZ001.NEXTVAL,
                                   reg.nromoneda,
                                   reg.producto,
                                   reg.moneda,
                                   reg.fecha,
                                   reg.hora,
                                   reg.cuenta,
                                   reg.usuing,
                                   reg.usucof,
                                   reg.usuauto,
                                   reg.agencia,
                                   reg.titular);
            COMMIT;                            
          end loop;
          if LD_FECHAINI = fechahoy or LD_FECHAFIN = fechahoy then
            for reh in tablasdia(fechahoy,LN_AGENCIA) loop
              cont := cont + 1;
              insert into jaqz001(jaqz001usu,
                                  jaqz001tre,
                                  jaqz001tsa,  
                                  jaqz001cor,   
                                  JAQZ001001,                       
                                  jaqz001002,
                                  jaqz001003,
                                  jaqz001004,
                                  jaqz001005,
                                  jaqz001014,
                                  jaqz001007,
                                  jaqz001008,
                                  jaqz001009,  
                                  jaqz001013,                         
                                  jaqz001016)
                                  
                           values( LC_USUARIO,
                                   'R',
                                   'R',
                                   SEQ_JAQZ001.NEXTVAL,
                                   reh.nromoneda,
                                   reh.producto,
                                   reh.moneda,
                                   reh.fecha,
                                   reh.hora,
                                   reh.cuenta,
                                   reh.usuing,
                                   reh.usucof,
                                   reh.usuauto,
                                   reh.agencia,
                                   reh.titular);
            COMMIT;                            
            end loop;  
          end if;  
        else
          null;
        end if;
    WHEN 2 THEN
      DELETE JAQZ001
       WHERE jaqz001usu = rpad(LC_USUARIO,10,' ')
         AND jaqz001tre = 'R'
         AND jaqz001tsa = 'R';
         COMMIT;
  end case;
END SP_AH_INSJAQZ001;
/

