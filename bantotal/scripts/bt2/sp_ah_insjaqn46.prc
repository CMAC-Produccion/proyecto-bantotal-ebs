CREATE OR REPLACE PROCEDURE SP_AH_INSJAQN46(USUARIOI IN VARCHAR2,
                                              FEC_INICIO IN DATE,
                                              FEC_FIN IN DATE,
                                              FECHA IN DATE,
                                              HORA IN VARCHAR2,
                                              REGION IN NUMBER,
                                              ZONA IN NUMBER,
                                              SUCURSAL IN NUMBER,
                                              TIPO IN VARCHAR2,
                                              COMENTARIOS IN VARCHAR2) IS

  CURSOR UNO (reg1 in number, fecIni1 in date,fecFin1 in date) IS --Solo región
      select M4.MBCCSuc ,M4.MBCCUsu , M4.MBCCCaj , M4.MBCCFch , M4.MBCCHra , M4.MBCCEst , M1.MBC10Spr, F2.Tp1nro2
        from MBC004 M4,
             MBC010 M1,
             FST198 F1,
             FST198 F2,
             Fst811 F3,
             PRFU00 P1,
             SNG057 S1
       where M4.MBCCEmp = 1
         and M4.MBCCSuc in (select b.oficod from fst198 a inner join Fst811 b on b.RegCod = a.Tp1nro2 where a.Tp1cod1=10872 and a.Tp1corr1 = 11 and a.Tp1nro1=reg1)
         --and trim(M4.MBCCEst) is null // Se comenta por petición de cliente WEB 228028 17/08/23
         and M1.mbc10emp  = S1.sng055emp
         and M1.mbc10spr  = S1.sng057usr
         and S1.sng055car = 202
         and M4.MBCCCAJ =0
         and M4.MBCCFch between fecIni1 and fecFin1
         and M1.mbc10Emp = M4.MBCCEmp
         and M1.MBC10Suc = M4.MBCCSuc
         and M1.MBC10Usr =  M4.MBCCUsu
         and M1.MBC10Caj = M4.MBCCCaj
         and trunc(M1.MBC10Fech)  = M4.MBCCFch --- //ctod(str(dtoc(MBC10Fech),8))  = &Mbccfch
         and M1.MBC10Hra = M4.MBCCHra
         and P1.UBUSER = M1.MBC10Spr
         AND trim(F1.TP1DESC) = trim(P1.PRFGCOD)
         and F3.RegCod = F2.Tp1nro2
         and F3.oficod = M4.MBCCSuc
         AND F1.TP1COD1 = 10891
         AND F1.TP1CORR1 = 5
         AND F1.TP1CORR2 = 2 --Solo valor 2
         AND F2.TP1COD1 = 10872
         AND F2.TP1CORR1 = 11;

  CURSOR UNOD (reg1 in number,zon1 in number, fecIni1 in date,fecFin1 in date) IS --Region y Zona
      select M4.MBCCSuc ,M4.MBCCUsu , M4.MBCCCaj , M4.MBCCFch , M4.MBCCHra , M4.MBCCEst , M1.MBC10Spr
        from MBC004 M4,
             MBC010 M1,
             FST198 F1,
             PRFU00 P1,
             SNG057 S1
       where M4.MBCCEmp = 1
         and M4.MBCCSuc in (select b.oficod from fst198 a inner join Fst811 b on b.RegCod = a.Tp1nro2 where a.Tp1cod1=10872 and a.Tp1corr1 = 11 and a.Tp1nro1=reg1 and a.Tp1nro2=zon1)
         --and trim(M4.MBCCEst) is null // Se comenta por petición de cliente WEB 228028 17/08/23
         and M1.mbc10emp  = S1.sng055emp
         and M1.mbc10spr  = S1.sng057usr
         and S1.sng055car = 202
         and M4.MBCCCAJ = 0
         --and M4.MBCCUSU = USUARIO --Sin Usuario
         and M4.MBCCFch between fecIni1 and fecFin1
         and M1.mbc10Emp = M4.MBCCEmp
         and M1.MBC10Suc = M4.MBCCSuc
         and M1.MBC10Usr =  M4.MBCCUsu
         and M1.MBC10Caj = M4.MBCCCaj
         and trunc(M1.MBC10Fech)  = M4.MBCCFch --- //ctod(str(dtoc(MBC10Fech),8))  = &Mbccfch
         and M1.MBC10Hra = M4.MBCCHra
         and P1.UBUSER = M1.MBC10Spr
         AND trim(F1.TP1DESC) = trim(P1.PRFGCOD)
         AND F1.TP1COD1 = 10891
         AND F1.TP1CORR1 = 5
         AND F1.TP1CORR2 = 2; --Solo valor 2

  CURSOR UNOT (reg1 in number,zon1 in number,suc1 in number, fecIni1 in date,fecFin1 in date) IS --Region Zona y Sucursal
      select M4.MBCCSuc ,M4.MBCCUsu , M4.MBCCCaj , M4.MBCCFch , M4.MBCCHra , M4.MBCCEst , M1.MBC10Spr
        from MBC004 M4,
             MBC010 M1,
             FST198 F1,
             PRFU00 P1,
             SNG057 S1
       where M4.MBCCEmp = 1
         and M4.MBCCSuc in (select b.oficod from fst198 a inner join Fst811 b on b.RegCod = a.Tp1nro2 where a.Tp1cod1=10872 and a.Tp1corr1 = 11 and a.Tp1nro1=reg1 and a.Tp1nro2=zon1 and b.oficod=suc1)
         --and trim(M4.MBCCEst) is null // Se comenta por petición de cliente WEB 228028 17/08/23
         and M1.mbc10emp  = S1.sng055emp
         and M1.mbc10spr  = S1.sng057usr
         and S1.sng055car = 202
         and M4.MBCCCAJ = 0
         --and M4.MBCCUSU = USUARIO --Sin Usuario
         and M4.MBCCFch between fecIni1 and fecFin1
         and M1.mbc10Emp = M4.MBCCEmp
         and M1.MBC10Suc = M4.MBCCSuc
         and M1.MBC10Usr =  M4.MBCCUsu
         and M1.MBC10Caj = M4.MBCCCaj
         and trunc(M1.MBC10Fech)  = M4.MBCCFch --- //ctod(str(dtoc(MBC10Fech),8))  = &Mbccfch
         and M1.MBC10Hra = M4.MBCCHra
         and P1.UBUSER = M1.MBC10Spr
         AND trim(F1.TP1DESC) = trim(P1.PRFGCOD)
         AND F1.TP1COD1 = 10891
         AND F1.TP1CORR1 = 5
         AND F1.TP1CORR2 = 2;


    cursor Billetaje (vsuc in number,vusu in varchar2,vcaja in number, vfecha in date,vhora in varchar2) is
      select mbcdmda, Sum(Mbcdimp) IMPORTE,Mbcdsdo
       from MBC005
        Where MBCCEmp = 1
        and MBCCSuc = vsuc
        and MBCCUsu  = rpad(vusu,10,' ')
        and MBCCCaj = vcaja
        and MBCCFch = vfecha
        and MBCCHra = vhora
        group by mbcdmda, Mbcdsdo;

    CURSOR DOS (vmoneda in number,reg1 in number,fecIni1 in date,fecFin1 in date)IS
    select a.JAQL527AGARQ, a.JAQL527ATARQ,  a.JAQL527FEARQ, a.JAQL527HOARQ,a.JAQL527DSPSO,a.JAQL527DSPDO,trim(a.JAQL527USUEJ) JAQL527USUEJ,c.Tp1nro2,a.JAQL527OBSERV,SUM(b.JAQL528DENOM*b.JAQL528CANTI) BILLETAJE
        from JAQL527 a
        INNER JOIN JAQL528 b on
        a.JAQL527IDARQ = b.JAQL527IDARQ
        INNER JOIN Fst811 d on
        d.oficod = a.JAQL527AGARQ
        INNER JOIN fst198 c on
        c.Tp1nro2 = d.RegCod
        INNER JOIN SNG057 d ON 
        substr(a.jaql527usuej,1,10)  = d.sng057usr
        INNER JOIN z0e475 e ON 
        a.jaql527atarq = e.z0e475cod
        where JAQL527AGARQ in (select b.oficod from fst198 a inner join Fst811 b on b.RegCod = a.Tp1nro2 where a.Tp1cod1=10872 and a.Tp1corr1 = 11 and a.Tp1nro1=reg1)
        And d.sng055emp = e.z0e474cod
        and d.sng055car    = 202
        and a.jaql527agarq = e.z0e475suc
        and e.z0e475tip    = 'A'
        and a.JAQL527CONFI ='SI' --ARQUEO EXITOSO
        and a.JAQL527FEARQ between fecIni1 and fecFin1
        and b.JAQL528COMON  =  vmoneda
        and c.TP1COD1 = 10872 --ARQUEO EXITOSO
        and c.TP1CORR1 = 11 --ARQUEO EXITOSO
        group by a.JAQL527AGARQ,  a.JAQL527ATARQ, a.JAQL527FEARQ, a.JAQL527HOARQ,a.JAQL527DSPSO,a.JAQL527DSPDO,a.JAQL527USUEJ,c.Tp1nro2,a.JAQL527OBSERV;

    CURSOR DOSD (vmoneda in number,reg1 in number,zon1 in number,fecIni1 in date,fecFin1 in date)IS
    select a.JAQL527AGARQ, a.JAQL527ATARQ, a.JAQL527FEARQ, a.JAQL527HOARQ,a.JAQL527DSPSO,a.JAQL527DSPDO,trim(a.JAQL527USUEJ) JAQL527USUEJ,a.JAQL527OBSERV, SUM(b.JAQL528DENOM*b.JAQL528CANTI) BILLETAJE
        from JAQL527 a
        INNER JOIN JAQL528 b on
        a.JAQL527IDARQ = b.JAQL527IDARQ
        INNER JOIN SNG057 d ON 
        substr(a.jaql527usuej,1,10)  = d.sng057usr
        INNER JOIN z0e475 e ON 
        a.jaql527atarq = e.z0e475cod
        where JAQL527AGARQ in (select b.oficod from fst198 a inner join Fst811 b on b.RegCod = a.Tp1nro2 where a.Tp1cod1=10872 and a.Tp1corr1 = 11 and a.Tp1nro1=reg1 and a.Tp1nro2=zon1)
        And d.sng055emp = e.z0e474cod
        and d.sng055car    = 202
        and a.jaql527agarq = e.z0e475suc
        and e.z0e475tip    = 'A'
        and a.JAQL527CONFI ='SI' --ARQUEO EXITOSO
        and a.JAQL527FEARQ between fecIni1 and fecFin1
        --and a.JAQL527ATARQ  =  CODATM
        and b.JAQL528COMON  =  vmoneda
        group by a.JAQL527AGARQ,  a.JAQL527ATARQ, a.JAQL527FEARQ, a.JAQL527HOARQ,a.JAQL527DSPSO,a.JAQL527DSPDO,a.JAQL527USUEJ,a.JAQL527OBSERV;

    CURSOR DOST (vmoneda in number,reg1 in number,zon1 in number,suc1 in number,fecIni1 in date,fecFin1 in date)IS
    select a.JAQL527AGARQ, a.JAQL527ATARQ, a.JAQL527FEARQ, a.JAQL527HOARQ,a.JAQL527DSPSO,a.JAQL527DSPDO,trim(a.JAQL527USUEJ) JAQL527USUEJ,a.JAQL527OBSERV, SUM(b.JAQL528DENOM*b.JAQL528CANTI) BILLETAJE
        from JAQL527 a
        INNER JOIN JAQL528 b on
        a.JAQL527IDARQ = b.JAQL527IDARQ
        INNER JOIN SNG057 d ON 
        substr(a.jaql527usuej,1,10)  = d.sng057usr
        INNER JOIN z0e475 e ON 
        a.jaql527atarq = e.z0e475cod
        where JAQL527AGARQ in (select b.oficod from fst198 a inner join Fst811 b on b.RegCod = a.Tp1nro2 where a.Tp1cod1=10872 and a.Tp1corr1 = 11 and a.Tp1nro1=reg1 and a.Tp1nro2=zon1 and b.oficod=suc1)
        and d.sng055emp = e.z0e474cod
        and d.sng055car    = 202
        and a.jaql527agarq = e.z0e475suc
        and e.z0e475tip    = 'A'
        and a.JAQL527CONFI ='SI' --ARQUEO EXITOSO
        and a.JAQL527FEARQ between fecIni1 and fecFin1
        --and a.JAQL527ATARQ  =  CODATM
        and b.JAQL528COMON  =  vmoneda
        group by a.JAQL527AGARQ, a.JAQL527ATARQ, a.JAQL527FEARQ, a.JAQL527HOARQ,a.JAQL527DSPSO,a.JAQL527DSPDO,a.JAQL527USUEJ,a.JAQL527OBSERV;

 Valor   number;
 ImpSol  number(17,2):= 0;
 ImpDol  number(17,2):= 0;
 SldSol  number(17,2):= 0;
 SldDol  number(17,2):= 0;
 Mbcdsob_s number(17,2):=0;
 Mbcdsob_d number(17,2):=0;
 CorReg  number:=0;
 CONTADOR  number:=0;
 NomAge  varchar2(30);
 Usuario char(10);
 MONEDA   number;
 TIPOB  varchar2(1);
BEGIN
    TIPOB :=TIPO;
    IF((REGION <> 0 or REGION <> NULL) AND (ZONA = 0 or ZONA = NULL) AND (SUCURSAL = 0 or SUCURSAL = NULL)) THEN
              IF(TIPO = 'A' OR TIPO = 'C') THEN
                MONEDA := 0;
                for reg in DOS(MONEDA,REGION, FEC_INICIO,FEC_FIN)loop
                      CorReg := CorReg + 1;
                      begin
                      INSERT INTO JAQN46 (JAQN46USU,JAQN46FEC,JAQN46HOR,JAQN46COR,JAQN46FEI,JAQN46FEF,JAQN46REG,JAQN46ZON,JAQN46SUC,JAQN46USR,JAQN46USA,JAQN46TIP,JAQN46FEA,JAQN46HOA,JAQN46MSA,JAQN46MFS,JAQN46MOS,JAQN46COM,JAQN46AC1)
                                VALUES(USUARIOI,
                                       FECHA,  --FECHA REGISTRO
                                       HORA,  --HORA REGISTRO
                                       CorReg, --CORRELATIVO
                                       FEC_INICIO, --FECHA INICIO REPORTE
                                       FEC_FIN, -- FECHA FIN REPORTE
                                       REGION, --REGION
                                       reg.Tp1nro2, --ZONA
                                       reg.JAQL527AGARQ, --SUCURSAL
                                       reg.JAQL527USUEJ, --USUARIO RESPONSABLE DEL ARQUEO
                                       reg.JAQL527ATARQ, -- USUARIO VERIFICADO ARQUEO
                                       TIPO, --TIPO A: ATM , B:Boveda, C: Ambos
                                       reg.JAQL527FEARQ,
                                       reg.JAQL527HOARQ, --Hora Arqueo
                                       (reg.BILLETAJE+(reg.JAQL527DSPSO*-1)),
                                       reg.BILLETAJE, --Monto en soles Arqueado
                                       reg.JAQL527DSPSO, --Monto Sobrante o Faltante en soles
                                       reg.JAQL527OBSERV,
                                       'ATM'); --Comentarios
                      exception
                      when others then                 
                        null;
                      end;                 
                      commit;
                End Loop;
                MONEDA := 101;
                for reg in DOS(MONEDA,REGION, FEC_INICIO,FEC_FIN)loop
                    UPDATE JAQN46 SET
                    JAQN46MFD = reg.BILLETAJE,
                    JAQN46MOD = reg.JAQL527DSPDO,
                    JAQN46MSD = (reg.BILLETAJE+(reg.JAQL527DSPDO*-1))
                    WHERE JAQN46FEA = reg.JAQL527FEARQ
                    AND JAQN46HOA = reg.JAQL527HOARQ
                    AND JAQN46SUC = reg.JAQL527AGARQ
                    AND JAQN46USA = reg.JAQL527ATARQ
                    AND JAQN46USU = USUARIOI
                    AND JAQN46FEC = FECHA
                    AND JAQN46HOR = HORA;
                COMMIT;
                End Loop;
            END IF;

            IF(TIPO = 'B' OR TIPO = 'C') THEN
               for reg in uno (REGION, FEC_INICIO,FEC_FIN) loop
                   For reh in billetaje(reg.mbccsuc,reg.mbccusu,reg.mbcccaj,reg.mbccfch,reg.mbcchra) loop
                        if reh.mbcdmda = 0 then
                          ImpSol := reh.IMPORTE;
                          SldSol := reh.mbcdsdo;
                        else
                          ImpDol := reh.IMPORTE;
                          SldDol := reh.mbcdsdo;
                        end if;
                   end loop;
                     Mbcdsob_s :=ImpSol - SldSol;--Monto sobrante o faltante soles (Reporte: Mbcdsob_s).
                     Mbcdsob_d :=ImpDol - SldDol;--- //Monto sobrante o faltante dólares (Reporte: Mbcdsob_d).
                   --INSERT JAQZ001
                   CorReg := CorReg + 1 ;
                   begin
                   INSERT INTO JAQN46 (JAQN46USU,JAQN46FEC,JAQN46HOR,JAQN46COR,JAQN46FEI,JAQN46FEF,JAQN46REG,JAQN46ZON,JAQN46SUC,JAQN46USR,JAQN46USA,JAQN46TIP,JAQN46FEA,JAQN46HOA,JAQN46MSA,JAQN46MFS,JAQN46MOS,JAQN46MSD,JAQN46MFD,JAQN46MOD,JAQN46COM,JAQN46AC1)
                            VALUES(USUARIOI,
                                   FECHA,  --FECHA REGISTRO
                                   HORA,  --HORA REGISTRO
                                   CorReg, --CORRELATIVO
                                   FEC_INICIO, --FECHA INICIO REPORTE
                                   FEC_FIN, -- FECHA FIN REPORTE
                                   REGION, --REGION
                                   reg.Tp1nro2,
                                   reg.MBCCSUC, --SUCURSAL
                                   reg.MBC10Spr, --USUARIO RESPONSABLE DEL ARQUEO
                                   reg.Mbccusu, -- USUARIO VERIFICADO ARQUEO
                                   TIPO, --TIPO A: ATM , B:Boveda, C: Ambos
                                   reg.Mbccfch,
                                   reg.Mbcchra, --Hora Arqueo
                                   (ImpSol+(Mbcdsob_s*-1)),
                                   ImpSol, --Monto en soles Arqueado
                                   Mbcdsob_s, --Monto Sobrante o Faltante en soles
                                   (ImpDol+(Mbcdsob_d*-1)),
                                   ImpDol, --Monto en dolares Arqueado
                                   Mbcdsob_d, -- Monto sobrante o faltante en dolares
                                   COMENTARIOS,
                                   'BÓVEDA'); --Comentarios
                                    commit;
                      exception
                      when others then                 
                        null;
                      end;                                     
                   
            End Loop;
          END IF;
    END IF;

    IF((REGION <> 0 or REGION <> NULL) AND (ZONA <> 0 or ZONA <> NULL) AND (SUCURSAL = 0 or SUCURSAL = NULL)) THEN
          IF(TIPO = 'A' OR TIPO = 'C') THEN
              MONEDA := 0;
              for reg in DOSD(MONEDA,REGION,ZONA, FEC_INICIO,FEC_FIN)loop
                    CorReg := CorReg + 1;
                    begin
                    INSERT INTO JAQN46 (JAQN46USU,
                                        JAQN46FEC,
                                        JAQN46HOR,
                                        JAQN46COR,
                                        JAQN46FEI,
                                        JAQN46FEF,
                                        JAQN46REG,
                                        JAQN46ZON,
                                        JAQN46SUC,
                                        JAQN46USR,
                                        JAQN46USA,
                                        JAQN46TIP,
                                        JAQN46FEA,
                                        JAQN46HOA,
                                        JAQN46MSA,
                                        JAQN46MFS,
                                        JAQN46MOS,
                                        JAQN46COM,
                                        JAQN46AC1)
                              VALUES(USUARIOI,
                                     FECHA,  --FECHA REGISTRO
                                     HORA,  --HORA REGISTRO
                                     CorReg, --CORRELATIVO
                                     FEC_INICIO, --FECHA INICIO REPORTE
                                     FEC_FIN, -- FECHA FIN REPORTE
                                     REGION, --REGION
                                     ZONA, --ZONA
                                     reg.JAQL527AGARQ, --SUCURSAL
                                     reg.JAQL527USUEJ, --USUARIO RESPONSABLE DEL ARQUEO
                                     reg.JAQL527ATARQ, -- USUARIO VERIFICADO ARQUEO
                                     TIPO, --TIPO A: ATM , B:Boveda, C: Ambos
                                     reg.JAQL527FEARQ,
                                     reg.JAQL527HOARQ, --Hora Arqueo
                                     (reg.BILLETAJE+(reg.JAQL527DSPSO*-1)),
                                     reg.BILLETAJE, --Monto en soles Arqueado
                                     reg.JAQL527DSPSO, --Monto Sobrante o Faltante en soles
                                     reg.JAQL527OBSERV,
                                     'ATM'); --Comentarios
                      commit;
                      exception
                      when others then                 
                        null;
                      end;    
                      
              End Loop;
              MONEDA := 101;
              for reg in DOSD(MONEDA,REGION,ZONA, FEC_INICIO,FEC_FIN)loop
                  UPDATE JAQN46 SET
                  JAQN46MFD = reg.BILLETAJE,
                  JAQN46MOD = reg.JAQL527DSPDO,
                  JAQN46MSD = (reg.BILLETAJE+(reg.JAQL527DSPDO*-1))
                  WHERE JAQN46FEA = reg.JAQL527FEARQ
                  AND JAQN46HOA = reg.JAQL527HOARQ
                  AND JAQN46SUC = reg.JAQL527AGARQ
                  AND JAQN46USA = reg.JAQL527ATARQ
                  AND JAQN46USU = USUARIOI
                  AND JAQN46FEC = FECHA
                  AND JAQN46HOR = HORA;
              COMMIT;
              End Loop;
         END IF;

         IF(TIPO = 'B' OR TIPO = 'C') THEN
             for reg in unod (REGION,ZONA, FEC_INICIO,FEC_FIN) loop
                 For reh in billetaje(reg.mbccsuc,reg.mbccusu,reg.mbcccaj,reg.mbccfch,reg.mbcchra) loop
                      if reh.mbcdmda = 0 then
                        ImpSol := reh.IMPORTE;
                        SldSol := reh.mbcdsdo;
                      else
                        ImpDol := reh.IMPORTE;
                        SldDol := reh.mbcdsdo;
                      end if;
                 end loop;
                   Mbcdsob_s :=ImpSol - SldSol;--Monto sobrante o faltante soles (Reporte: Mbcdsob_s).
                   Mbcdsob_d :=ImpDol - SldDol;--- //Monto sobrante o faltante dólares (Reporte: Mbcdsob_d).
                 --INSERT JAQZ001
                 CorReg := CorReg + 1 ;
                 begin       
                 INSERT INTO JAQN46 (JAQN46USU,JAQN46FEC,JAQN46HOR,JAQN46COR,JAQN46FEI,JAQN46FEF,JAQN46REG,JAQN46ZON,JAQN46SUC,JAQN46USR,JAQN46USA,JAQN46TIP,JAQN46FEA,JAQN46HOA,JAQN46MSA,JAQN46MFS,JAQN46MOS,JAQN46MSD,JAQN46MFD,JAQN46MOD,JAQN46COM,JAQN46AC1)
                          VALUES(USUARIOI,
                                 FECHA,  --FECHA REGISTRO
                                 HORA,  --HORA REGISTRO
                                 CorReg, --CORRELATIVO
                                 FEC_INICIO, --FECHA INICIO REPORTE
                                 FEC_FIN, -- FECHA FIN REPORTE
                                 REGION, --REGION
                                 ZONA, --ZONA
                                 reg.MBCCSUC, --SUCURSAL
                                 reg.MBC10Spr, --USUARIO RESPONSABLE DEL ARQUEO
                                 reg.Mbccusu, -- USUARIO VERIFICADO ARQUEO
                                 TIPO, --TIPO A: ATM , B:Boveda, C: Ambos
                                 reg.Mbccfch,
                                 reg.Mbcchra, --Hora Arqueo
                                 (ImpSol+(Mbcdsob_s*-1)),
                                 ImpSol, --Monto en soles Arqueado
                                 Mbcdsob_s, --Monto Sobrante o Faltante en soles
                                 (ImpDol+(Mbcdsob_d*-1)),
                                 ImpDol, --Monto en dolares Arqueado
                                 Mbcdsob_d, -- Monto sobrante o faltante en dolares
                                 COMENTARIOS,
                                 'BÓVEDA'); --Comentarios
                                 commit;
                      exception
                      when others then                 
                        null;
                      end;                      
          End Loop;
        End if;
    END IF;

    IF(REGION <> 0 AND ZONA <> 0  AND SUCURSAL <> 0) THEN
          IF(TIPOB = 'A' OR TIPOB = 'C') THEN
              MONEDA := 0;
              for reg in DOST(MONEDA,REGION,ZONA,SUCURSAL, FEC_INICIO,FEC_FIN)loop
                    CorReg := CorReg + 1;
                    begin
                    INSERT INTO JAQN46 (JAQN46USU, JAQN46FEC, JAQN46HOR, JAQN46COR,JAQN46FEI,JAQN46FEF,JAQN46REG,JAQN46ZON,JAQN46SUC,JAQN46USR,JAQN46USA,JAQN46TIP,JAQN46FEA,JAQN46HOA,JAQN46MSA,JAQN46MFS,JAQN46MOS,
                                        JAQN46COM,JAQN46AC1)
                              VALUES(USUARIOI,
                                     FECHA,  --FECHA REGISTRO
                                     HORA,  --HORA REGISTRO
                                     CorReg, --CORRELATIVO
                                     FEC_INICIO, --FECHA INICIO REPORTE
                                     FEC_FIN, -- FECHA FIN REPORTE
                                     REGION, --REGION
                                     ZONA, --ZONA
                                     reg.JAQL527AGARQ, --SUCURSAL
                                     reg.JAQL527USUEJ, --USUARIO RESPONSABLE DEL ARQUEO
                                     reg.JAQL527ATARQ, -- USUARIO VERIFICADO ARQUEO
                                     TIPO, --TIPO A: ATM , B:Boveda, C: Ambos
                                     reg.JAQL527FEARQ,
                                     reg.JAQL527HOARQ, --Hora Arqueo
                                     (reg.BILLETAJE+(reg.JAQL527DSPSO*-1)),
                                     reg.BILLETAJE, --Monto en soles Arqueado
                                     reg.JAQL527DSPSO, --Monto Sobrante o Faltante en soles
                                     reg.JAQL527OBSERV,
                                     'ATM'); --Comentarios
                      commit;
                      exception
                      when others then                 
                        null;
                      end;                          
              End Loop;
              MONEDA := 101;
              for reg in DOST(MONEDA,REGION,ZONA,SUCURSAL, FEC_INICIO,FEC_FIN)loop
                  UPDATE JAQN46 SET
                  JAQN46MFD = reg.BILLETAJE,
                  JAQN46MOD = reg.JAQL527DSPDO,
                  JAQN46MSD = (reg.BILLETAJE+(reg.JAQL527DSPDO*-1))
                  WHERE JAQN46FEA = reg.JAQL527FEARQ
                  AND JAQN46HOA = reg.JAQL527HOARQ
                  AND JAQN46SUC = reg.JAQL527AGARQ
                  AND JAQN46USA = reg.JAQL527ATARQ
                  AND JAQN46USU = USUARIOI
                  AND JAQN46FEC = FECHA
                  AND JAQN46HOR = HORA;
              COMMIT;
              End Loop;
          END IF;


          IF(TIPOB = 'B' OR TIPOB = 'C') THEN
             for reg in unot (REGION,ZONA,SUCURSAL, FEC_INICIO,FEC_FIN) loop
                 For reh in billetaje(reg.mbccsuc,reg.mbccusu,reg.mbcccaj,reg.mbccfch,reg.mbcchra) loop
                      if reh.mbcdmda = 0 then
                        ImpSol := reh.IMPORTE;
                        SldSol := reh.mbcdsdo;
                      else
                        ImpDol := reh.IMPORTE;
                        SldDol := reh.mbcdsdo;
                      end if;
                 end loop;
                   Mbcdsob_s :=ImpSol - SldSol;--Monto sobrante o faltante soles (Reporte: Mbcdsob_s).
                   Mbcdsob_d :=ImpDol - SldDol;--- //Monto sobrante o faltante dólares (Reporte: Mbcdsob_d).
                 --INSERT JAQZ001
                 CorReg := CorReg + 1 ;
                 begin
                 INSERT INTO JAQN46 (JAQN46USU,JAQN46FEC,JAQN46HOR,JAQN46COR,JAQN46FEI,JAQN46FEF,JAQN46REG,JAQN46ZON,JAQN46SUC,JAQN46USR,JAQN46USA,JAQN46TIP,JAQN46FEA,JAQN46HOA,JAQN46MSA,JAQN46MFS,JAQN46MOS,JAQN46MSD,JAQN46MFD,JAQN46MOD,JAQN46COM,JAQN46AC1)
                          VALUES(USUARIOI,
                                 FECHA,  --FECHA REGISTRO
                                 HORA,  --HORA REGISTRO
                                 CorReg, --CORRELATIVO
                                 FEC_INICIO, --FECHA INICIO REPORTE
                                 FEC_FIN, -- FECHA FIN REPORTE
                                 REGION, --REGION
                                 ZONA, --ZONA
                                 reg.MBCCSUC, --SUCURSAL
                                 reg.MBC10Spr, --USUARIO RESPONSABLE DEL ARQUEO
                                 reg.Mbccusu, -- USUARIO VERIFICADO ARQUEO
                                 TIPO, --TIPO A: ATM , B:Boveda, C: Ambos
                                 reg.Mbccfch,
                                 reg.Mbcchra, --Hora Arqueo
                                 (ImpSol+(Mbcdsob_s*-1)),
                                 ImpSol, --Monto en soles Arqueado
                                 Mbcdsob_s, --Monto Sobrante o Faltante en soles
                                 (ImpDol+(Mbcdsob_d*-1)),
                                 ImpDol, --Monto en dolares Arqueado
                                 Mbcdsob_d, -- Monto sobrante o faltante en dolares
                                 COMENTARIOS,
                                 'BÓVEDA'); --Comentarios
                  commit;
                      exception
                      when others then                 
                        null;
                      end;                      
          End Loop;
      End if;

    END IF;
EXCEPTION
WHEN OTHERS THEN    
  null;
END SP_AH_INSJAQN46;
/

