CREATE OR REPLACE PROCEDURE SP_AH_INSJAQZ004( LN_AGENCIA  IN NUMBER,
                                              LC_USUARIO  IN VARCHAR2,
                                              LC_UBUSER   IN VARCHAR2,
                                              LD_FECHAINI IN DATE,
                                              LD_FECHAFIN IN DATE,
                                              LC_CHECK    IN VARCHAR2,
                                              LN_TIPO     IN NUMBER) IS
  CURSOR UNO (valor in number,usuario in char)IS

      select M4.MBCCSuc ,M4.MBCCUsu , M4.MBCCCaj , M4.MBCCFch , M4.MBCCHra , M4.MBCCEst , M1.MBC10Spr  ,P1.PRFGCOD , trim(P0.PRFGNOM) cargo
        from MBC004 M4,
             MBC010 M1,
             PRFU00 P1,
             FST198 F1,
             PRFG00 P0
       where M4.MBCCEmp = 1
         and M4.MBCCSuc = LN_AGENCIA
         and M4.MBCCEst = 'C'
         and M4.MBCCUSU = USUARIO
         and M4.MBCCFch between LD_FECHAINI and  LD_FECHAFIN
         and M1.mbc10Emp = M4.MBCCEmp
         and M1.MBC10Suc = M4.MBCCSuc
         and M1.MBC10Usr =  M4.MBCCUsu
         and M1.MBC10Caj = M4.MBCCCaj
         and trunc(M1.MBC10Fech)  = M4.MBCCFch --- //ctod(str(dtoc(MBC10Fech),8))  = &Mbccfch
         and M1.MBC10Hra = M4.MBCCHra
         and P1.UBUSER = M1.MBC10Spr
         AND F1.TP1DESC = P1.PRFGCOD
         AND F1.TP1COD1 = 10891
         AND F1.TP1CORR1 = 5
         AND F1.TP1CORR2 = valor --2,4
         AND P0.PGCOD = 1
         AND P0.PRFGCOD = P1.PRFGCOD;

   CURSOR DOS (valor in number)IS
      select M4.MBCCSuc,M4.MBCCUsu, M4.MBCCCaj, M4.MBCCFch, M4.MBCCHra, M4.MBCCEst, M1.MBC10Spr ,P1.PRFGCOD, trim(P0.PRFGNOM) cargo
        from MBC004 M4,
             MBC010 M1,
             PRFU00 P1,
             FST198 F1,
             PRFG00 P0
       where M4.MBCCEmp = 1
         and M4.MBCCSuc = LN_AGENCIA
         and M4.MBCCEst = 'C'
         and M4.MBCCFch between LD_FECHAINI and  LD_FECHAFIN
         and M1.mbc10Emp = M4.MBCCEmp
         and M1.MBC10Suc = M4.MBCCSuc
         and M1.MBC10Usr =  M4.MBCCUsu
         and M1.MBC10Caj = M4.MBCCCaj
         and trunc(M1.MBC10Fech)  = M4.MBCCFch --- //ctod(str(dtoc(MBC10Fech),8))  = &Mbccfch
         and M1.MBC10Hra = M4.MBCCHra
         and P1.UBUSER = M1.MBC10Spr
         AND F1.TP1DESC = P1.PRFGCOD
         AND F1.TP1COD1 = 10891
         AND F1.TP1CORR1 = 5
         AND F1.TP1CORR2 = valor --2,4
         AND P0.PGCOD = 1
         AND P0.PRFGCOD = P1.PRFGCOD;

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


 ---Vpgfape date;
 Valor   number;

 ImpSol  number(17,2):= 0;
 ImpDol  number(17,2):= 0;
 SldSol  number(17,2):= 0;
 SldDol  number(17,2):= 0;
 Mbcdsob_s number(17,2):=0;
 Mbcdsob_d number(17,2):=0;
 CorReg  number:=0;
 NomAge  varchar2(30);
 Usuario char(10);
BEGIN



 --- select pgfape into Vpgfape from fst017 where pgcod = 1;

  valor := 0;
   bEGIN
   select scnom into Nomage  from fst001  where sucurs = LN_AGENCIA ;
   EXCEPTION
     WHEN NO_data_found THEN
       Nomage := 'sIN AGE';
   eND;

  IF  rpad(LC_USUARIO,10,' ') = rpad('Sinvalor',10,' ') THEN
    Usuario := null;
  else
    Usuario := rpad(LC_USUARIO,10,' ');
  End if;


   case ln_tipo
     when 1 then    

         IF LC_CHECK  = 'S' then
            Valor := 2;

             for reg in uno(valor,usuario) loop

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
                 insert into JAQY671(jaqy671cod,
                                      jaqy671ubu,
                                      jaqy671fech,
                                      jaqy671hor,
                                      jaqy671age,
                                      jaqy671uarq,
                                      jaqy671uaut,
                                      jaqy671car,
                                      jaqy671mot1,
                                      jaqy671mot2,
                                      jaqy671mot3,
                                      jaqy671mot4,
                                      jaqy671aux1)
                              values (SEQ_JAQY671.NEXTVAL,            --CORRELATIVO
                                      LC_UBUSER,        -- Usuario que ejecuta
                                      reg.Mbccfch,      -- Fecha de Arqueo                  (4)
                                      reg.Mbcchra,      -- Hora de Arqueo                   (5)
                                      NomAge,
                                      reg.Mbccusu,
                                      reg.MBC10Spr,
                                      reg.cargo,
                                      Mbcdsob_s,        -- Monto Sobrante Soles             (6)
                                      Mbcdsob_d,        -- Monto Sobrante Dólares           (11)
                                      ImpSol,           -- Billetaje en Soles                (14)
                                      ImpDol,
                                      REG.MBCCSUC);          -- Billetaje en Soles                (15)
                 commit;

             End Loop;
         else
           
            Valor := 4;
            for reg in uno(valor,usuario) loop
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
                 insert into JAQY671(jaqy671cod,
                                      jaqy671ubu,
                                      jaqy671fech,
                                      jaqy671hor,
                                      jaqy671age,
                                      jaqy671uarq,
                                      jaqy671uaut,
                                      jaqy671car,
                                      jaqy671mot1,
                                      jaqy671mot2,
                                      jaqy671mot3,
                                      jaqy671mot4,
                                      jaqy671aux1)
                              values (SEQ_JAQY671.NEXTVAL,----CorReg,            --CORRELATIVO
                                      LC_UBUSER,        -- Usuario que ejecuta
                                      reg.Mbccfch,      -- Fecha de Arqueo                  (4)
                                      reg.Mbcchra,      -- Hora de Arqueo                   (5)
                                      NomAge,
                                      reg.Mbccusu,
                                      reg.MBC10Spr,
                                      reg.cargo,
                                      Mbcdsob_s,        -- Monto Sobrante Soles             (6)
                                      Mbcdsob_d,        -- Monto Sobrante Dólares           (11)
                                      ImpSol,           -- Billetaje en Soles                (14)
                                      ImpDol,
                                      REG.MBCCSUC);          -- Billetaje en Soles                (15)
                 commit;
             End Loop;
         end if;
      when 2 then
        IF LC_CHECK  = 'S' then
            Valor := 2;
             for reg in DOS(valor) loop
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
                 insert into JAQY671(jaqy671cod,
                                      jaqy671ubu,
                                      jaqy671fech,
                                      jaqy671hor,
                                      jaqy671age,
                                      jaqy671uarq,
                                      jaqy671uaut,
                                      jaqy671car,
                                      jaqy671mot1,
                                      jaqy671mot2,
                                      jaqy671mot3,
                                      jaqy671mot4,
                                      jaqy671aux1)
                              values (SEQ_JAQY671.NEXTVAL,---CorReg,            --CORRELATIVO
                                      LC_UBUSER,        -- Usuario que ejecuta
                                      reg.Mbccfch,      -- Fecha de Arqueo                  (4)
                                      reg.Mbcchra,      -- Hora de Arqueo                   (5)
                                      NomAge,
                                      reg.Mbccusu,
                                      reg.MBC10Spr,
                                      reg.cargo,
                                      Mbcdsob_s,        -- Monto Sobrante Soles             (6)
                                      Mbcdsob_d,        -- Monto Sobrante Dólares           (11)
                                      ImpSol,           -- Billetaje en Soles                (14)
                                      ImpDol,
                                      REG.MBCCSUC);          -- Billetaje en Soles                (15)

                 commit;
             End Loop;
         else
            Valor := 4;
            for reg in DOS(valor) loop
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
                 insert into JAQY671(jaqy671cod,
                                      jaqy671ubu,
                                      jaqy671fech,
                                      jaqy671hor,
                                      jaqy671age,
                                      jaqy671uarq,
                                      jaqy671uaut,
                                      jaqy671car,
                                      jaqy671mot1,
                                      jaqy671mot2,
                                      jaqy671mot3,
                                      jaqy671mot4,
                                      JAQY671AUX1)
                              values (SEQ_JAQY671.NEXTVAL,---CorReg,            --CORRELATIVO
                                      LC_UBUSER,        -- Usuario que ejecuta
                                      reg.Mbccfch,      -- Fecha de Arqueo                  (4)
                                      reg.Mbcchra,      -- Hora de Arqueo                   (5)
                                      NomAge,
                                      reg.Mbccusu,
                                      reg.MBC10Spr,
                                      reg.cargo,
                                      Mbcdsob_s,        -- Monto Sobrante Soles             (6)
                                      Mbcdsob_d,        -- Monto Sobrante Dólares           (11)
                                      ImpSol,           -- Billetaje en Soles                (14)
                                      ImpDol,
                                      REG.MBCCSUC);          -- Billetaje en Soles                (15)
                 commit;
             End Loop;
         end if;
   when 3 then
     delete JAQY671
     where jaqy671ubu = rpad(trim(LC_UBUSER),10,' ');
     commit;
  end case;

END SP_AH_INSJAQZ004;
/

