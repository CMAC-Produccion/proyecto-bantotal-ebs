create or replace procedure SP_AH_DESEMBOLSO (LD_fechaini in date,
                                              LD_fechafin in date,
                                              LN_MONTO IN NUMBER,
                                              LC_USUARIO IN VARCHAR2,
                                              LC_opcion   in varchar2)is

CURSOR ORIGEN IS

   select (select f10.regnom  from fst810 f10, fst811 f11 where f10.pgcod = 1 and f10.regcod <100 and f11.regcod = f10.regcod and f11.oficod =f5.hsucor) Region,
          (select scnom from fst001 where sucurs = f5.hsucor) as AgenciaDesembolso,
          j9.jaql964usu Analista,
          j9.jaql964tit Cliente,
          Lpad(to_char(f6.Hcta),9,'0') || Lpad(to_char(f6.Hmda),4,'0')||Lpad(to_char(f6.Hoper),9,'0')as NroCredito,
          decode(f6.hmda,0,'Nuevos Soles','Dolares Americanos') Moneda,
          f5.hfcon Fecha ,
          f6.hcimp1 Monto,
          (select Tonom from Fst004 where Modulo = f6.hmodul and totope = f6.htoper) Tipocredito,
         --(select a.hcord from fsh016 a where a.pgcod = 1 and a.hcord in (81,82,83,84)and a.hfcon = f6.hfcon and a.hcmod in(30,183) and a.htran = 951 and a.hcta = f6.hcta and a.hnrel = f6.hnrel and a.hmda = f6.hmda and a.hoper = f6.hoper) ordinal
          f6.hcmod modulo,
          f6.htran trans,
          f6.hnrel relacion,
          f6.hcta cuenta,
          f6.hsucor sucursal,
          f6.hmda hmda,
          f6.htoper TOPEr,
          f6.hfcon fechtran
     from fsh016  f6,
          fsh015  f5,
          jaql964 j9
    where f6.pgcod = 1
      and f6.hcmod in (30,183)
    --  and f6.hcord in (81,82,83,84)
      and f6.htran in (951,10)
      and f6.hmodul in (29,33,101,102,103,104,105,106,107,108,109,110,111,112,113,115,116,120,142,144,200)
      and f6.hcimp1 >= LN_MONTO---5000
      and f5.pgcod = f6.pgcod
      and f5.hcmod = f6.hcmod
      and f5.hsucor = f6.hsucor
      and f5.htran = f6.htran
      and f5.hfcon = f6.hfcon
      and f5.hfcon >= LD_fechaini
      and f5.hfcon <= LD_fechafin
      and f5.hnrel = f6.hnrel
      and f5.hccorr = 0
     /* and f5.hsucor =20*/
      and j9.jaql964cta = f6.hcta
      and j9.jaql964ope = f6.hoper
      and j9.jaql964mod = f6.hmodul
      and j9.jaql964mda = f6.hmda
      order by 1,2,7;

    ordinal number;
    CUENTA1 NUMBER;
    MODULO1 NUMBER;
    OPERA1  NUMBER;
    SUCU1   NUMBER;
    TOPE1   NUMBER;
    MDA1    NUMBER;
    SUBOP1  NUMBER;
    SALDOcta number(17,2);
    TipoDesembolso varchar2(20);
    ctaCorriente varchar2(30);
    tipo    varchar2(30);
  /*  dato    varchar2(500);
    cont    number;*/
    nombre  varchar2(50);
    credito varchar2(30);
    monto1  varchar2(30);
    lc_error varchar2(250);

begin

  IF LC_opcion ='1' THEN
      for reg in Origen loop
        Begin
           credito := to_char(reg.nrocredito);
           monto1:= replace(to_char(reg.monto),',','.');
           SALDOcta := 0;
           TipoDesembolso := null;
           ctaCorriente := null;
          tipo := null;
          select h.hcord, H.HCTA,H.HMODUL,H.HOPER,H.HSUCUR, H.HTOPER, H.HMDA,H.HSUBOP
            into ordinal,
                 CUENTA1,
                 MODULO1,
                 OPERA1,
                 SUCU1,
                 TOPE1,
                 MDA1,
                 SUBOP1
          from fsh016  h
          where h.pgcod = 1
            and h.hcmod = reg.modulo
            and h.hsucor = reg.sucursal
            and h.htran = reg.trans
            and h.hnrel = reg.relacion
            and h.hfcon = reg.fechtran
            and h.hcord in (81,82,83,84)
            and rownum = 1;

            select tonom
              into tipo
              from FST004
             WHERE Modulo = 21
               and Totope = TOPE1;

             select replace(penom,',',' ')
               into nombre
               from fsr008 f8,
                    fsd001 f11
              where f8.pgcod = 1
                and f8.ctnro = CUENTA1
                and f8.cttfir = 'T'
                and f11.pepais = f8.pepais
                and f11.petdoc = f8.petdoc
                and f11.pendoc = f8.pendoc;


            If ordinal = 81 THEN
                TipoDesembolso := 'CUENTA DE AHORROS';
                ctaCorriente := (Lpad(trim(to_char(CUENTA1)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( MDA1)),3,'0') ||'-'|| Lpad(trim(to_char(SUBOP1)),2,'0') ||'-'|| Lpad(trim(to_char(TOPE1)),3,'0'));
                bEGIN
                    SELECT F1.SCSDO
                     INTO SALDOcta
                     FROM FSD011 F1
                    WHERE F1.PGCOD = 1
                      AND F1.SCSUC =SUCU1
                      AND F1.SCMDA = MDA1
                      AND F1.SCPAP = 0
                      AND F1.SCCTA = CUENTA1
                      AND F1.SCOPER = OPERA1
                      AND F1.SCSBOP = SUBOP1
                      AND F1.SCTOPE = TOPE1
                      AND F1.SCMOD = 21
                      and rownum = 1;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    sALDOcta := 0;
               END;
            END IF;
            if ordinal = 82 THEN
                TipoDesembolso := 'CHEQUE';
                ctaCorriente := null;
                saldocta := 0;
                tipo := null;
            end if;
            IF ordinal = 83 THEN
                TipoDesembolso := 'EFECTIVO';
                ctaCorriente := null;
                saldocta := 0;
                tipo := null;
            end if;
            if ordinal = 84     THEN
                TipoDesembolso := 'ORDENES DE PAGO';
                ctaCorriente := null;
                saldocta := 0;
                tipo := null;
            end if;

        Exception
          When no_data_found then
                TipoDesembolso := NULL;
                ctaCorriente := null;
                saldocta := 0;
                tipo := null;
        End;
        bEGIN
            INSERT INTO JAQY674(jaqy674cod,
                                jaqy674reg,
                                jaqy674age,
                                jaqy674ana,
                                jaqy674cli,
                                jaqy674cre,
                                jaqy674mda,
                                jaqy674fec,
                                jaqy674mto,
                                jaqy674tcr,
                                jaqy674cct,
                                jaqy674tcc,
                                jaqy674sct,
                                jaqy674ax2,
                                jaqy674ax4
                                )
                        values(SEQ_JAQY674.NEXTVAL,
                               REG.REGION,
                               reg.agenciadesembolso,
                               REG.ANALISTA,
                               REG.CLIENTE,
                               REG.NROCREDITO,
                               REG.MONEDA,
                               REG.FECHA,
                               REG.MONTO,
                               REG.TIPOCREDITO,
                               TipoDesembolso,
                               ctaCorriente,
                               SALDOcta,
                               tipo,
                               LC_USUARIO);
                       commit;
        Exception
          when DUP_VAL_ON_INDEX THEN
              lc_error := (sqlcode||'-'||sqlerrm);
             dbms_output.put_line(lc_error);
          when others then
                 lc_error := (sqlcode||'-'||sqlerrm);
             dbms_output.put_line(lc_error);
        eND;
      End loop;
  ELSE
     DELETE JAQY674
      WHERE JAQY674AX4 = LC_USUARIO;
  END IF;
end SP_AH_DESEMBOLSO;
/

