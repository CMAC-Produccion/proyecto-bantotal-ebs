CREATE OR REPLACE PACKAGE PQ_AH_TIPOCAMBIO IS
    -- *********************************************************************************
    -- Nombre                     : FUNCIONES PARA COBRO DE COMISIONES INTERPLAZAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : PASIVAS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.10.07
    -- Autor de Creación          : SMARQUEZ
    -- Uso                        : tipo de cambio Ventanilllas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 07/10/14
    -- *********************************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_AH_TRANSACCIONES(ln_pgcod    in number,
                                ln_scsuc    in number,
                                ln_fechaini in date, --
                                ln_fechafin in date, --
                                ln_operador in varchar2,
                                ln_accion   in number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
  function fn_ah_nombre(CUENTA  in number) return VARCHAR2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
  function fn_ah_PERSONA(FECHA in DATE, RTRAN IN NUMBER, RREL IN NUMBER, RSUC IN NUMBER) return VARCHAR2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
  function fn_ah_DNI(FECHA in DATE, RTRAN IN NUMBER, RREL IN NUMBER, RSUC IN NUMBER) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --

   procedure Sp_ins_Compra(Agencia   in varchar2,
                           fecha     in date,
                           hora      in VARCHAR2,
                           usuing    in varchar2,
                           cliente   in varchar2,
                           tasa      in number,
                           monto     in number,
                           entregado in number,
                           operador  in varchar2,
                           Nrodoc    in character);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
  procedure Sp_ins_Venta(Agencia     in varchar2,
                         fecha       in date,
                         hora        in varchar2,
                         usuing      in varchar2,
                         cliente     in varchar2,
                         tasa        in number,
                         entregado   in number,
                         monto       in number,
                         ln_operador in varchar2,
                         Nrodoc      in character);

END PQ_AH_TIPOCAMBIO;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_TIPOCAMBIO IS
    -- *********************************************************************************
    -- Nombre                     : FUNCIONES PARA COBRO DE COMISIONES INTERPLAZAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : PASIVAS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.10.07
    -- Autor de Creación          : SMARQUEZ
    -- Uso                        : tipo de cambio Ventanilllas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 07/10/14
    -- *********************************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_AH_TRANSACCIONES( ln_pgcod    in number,
                                 ln_scsuc    in number,
                                 ln_fechaini in date,--
                                 ln_fechafin in date,--
                                 ln_operador in varchar2,
                                 ln_accion   in number)IS

   CURSOR  TIPOTRAN IS
    SELECT TP1NRO1, TP1NRO3, TP1DESC
      FROM Fst198
     Where Tp1cod = 1
       and Tp1cod1 = 2014
       and Tp1corr1 = 101
       and Tp1corr2 = 1;

  CURSOR MOVHIST (V_MOD NUMBER,V_TRAN NUMBER)IS
    SELECT Hhora hora, Hsucor sucursal, Hnrel relacion, Hfcon fecha, Husing usuing
      FROM FSH015
     Where Pgcod = ln_pgcod
       and Hcmod = V_MOD
       and Hsucor = ln_scsuc
       and Htran = V_TRAN
       and Hfcon BETWEEN ln_fechaini AND ln_fechafin
       and hccorr = 0;

  CURSOR MOVHISTORD(VAR_MOD NUMBER,VAR_TRAN NUMBER,VAR_REL NUMBER,VAR_FEC DATE)IS
    SELECT f6.Hmda,f6.Hcimp1, f6.Hcta , f6.Hctcbi , f6.Hsucor,f6.htran,f6.hnrel,f6.hfcon,f6.Hmodul
      FROM FSH016 f6
     Where f6.Pgcod = ln_pgcod
       AND f6.Hcmod = VAR_MOD
       AND f6.Hsucor = ln_scsuc
       AND f6.Htran = VAR_TRAN
       AND f6.Hnrel = VAR_REL
       AND f6.Hfcon = VAR_FEC
       AND (f6.Hmodul = VAR_MOD  or f6.Hmodul =472)
       and f6.hrubro in  (1121020000003,1111020000003)
       and not exists (select *
                         from fsh010 s
                        where s.Pgcod= 1
                          and s.Hcmod = f6.hcmod
                          and s.Hsucor = f6.hsucor
                          and s.Htran = f6.htran
                          and s.Hnrel = f6.hnrel
                          and s.Hfcont = f6.hfcon
                          and s.Hcsubo = 1
                          and s.Excod = 3
                          and s.Exstat = 'S' );

  CURSOR ORDINALES (fechauno in date, fechados in date,sucing in number)  IS
    select Pgcod, Hnrel, Hsucor, Hcmod, Htran, Hfcon, Hcodmo
      from FSH016
     Where Pgcod = 1
       and Hcmod <> 99
       and Hsucor = sucing
       and Htran not in (535, 536, 986)
       and Hfcon between fechauno AND  fechados
       and Hmda in (0, 101)
       and Hrubro in (2928090100001);--, 1918090100002) ;


  CURSOR ORDINAL16  (vhcmod in number,vhsucor in number,vhtran in number,vhnrel in number, vhfcon in date) IS
    SELECT h6.Hctcbi,h6.hcta,h6.Hrubro, h6.Hcimp1, h6.hsucor
      FROM FSH016 h6
     Where h6.Pgcod = 1
       and h6.Hcmod = vHcmod
       and h6.Hsucor = vHsucor
       and h6.Htran = vHtran
       and h6.Hnrel = vHnrel
       and h6.Hfcon = vHfcon
       and not exists (select *
                         from fsh010 s
                        where s.Pgcod= 1
                          and s.Hcmod = h6.hcmod
                          and s.Hsucor = h6.hsucor
                          and s.Htran = h6.htran
                          and s.Hnrel = h6.hnrel
                          and s.Hfcont = h6.hfcon
                          and s.Hcsubo = 1
                          and s.Excod = 3
                          and s.Exstat = 'S' );
   -- and Husing = &SNGAS2Usr When &SNGAS2Usr <> nullValue(&SNGAS2Usr)


    MODULO NUMBER;
    TRAN  NUMBER;
    MOD1  NUMBER;
    TIPO  VARCHAR2(2);
    MONTO NUMBER;
    ENTREGADO NUMBER;
    agencia varchar2(30);
    tasa number;
    tasa1 number;
    Nomcliente varchar2(70);
    documento varchar2(12);
    fecha date;
    TipoRubro varchar2(2);
    imphrora varchar2(8);
    impusuario varchar2(10);
    exCuenta varchar2(2);
    ExHctbi  varchar2(2);
    v_cuenta number;
    v_Hctcbi number;
    Auto char(1);
    ordinal number(2);
    modulo1 number;
    BEGIN
        MODULO := 0;
        TRAN  := 0;
        MOD1  := 0;
        MONTO := 0;
        ENTREGADO :=0;
        tasa :=0;
        TipoRubro := null;
        case ln_accion
        When 1 Then

          FOR T IN TIPOTRAN LOOP
             IF T.TP1NRO3 = 1 THEN
                  MODULO := trunc(T.TP1NRO1/1000) ;
                  TRAN  := mod(T.TP1NRO1, 1000) ;---T.TP1NRO1 - (MODULO * 1000); TRANV := TRAN ;
                  TIPO := 'C';
                  MOD1 := Modulo;
                 For i in MOVHIST(MOD1,TRAN) LOOP
                     BEGIN
                        Nomcliente := NULL;
                        Agencia := NULL;
                        monto := 0;
                        entregado := 0;

                        fOR j IN MOVHISTORD(MOD1,TRAN, i.relacion, i.fecha)loop
                           if  j.hmda = 101 then
                               monto := j.hcimp1;
                           end if;
                           if j.hmda = 0 then
                               entregado := j.hcimp1;
                           end if;
                           fecha := j.hfcon;
                           SELECT Scnom
                             into Agencia
                             FROM FST001
                            Where Pgcod = 1
                              and Sucurs = j.hsucor;
                              tasa := j.hctcbi;
                              if tasa <> 0.00000000 then
                                 tasa1 := j.hctcbi;
                              end if;
                           if j.hcta <> 0 then
                               nomcliente := fn_ah_nombre(j.hcta);
                           else
                              if j.hcta = 0 and Nomcliente is null then
                                 nomcliente := fn_ah_PERSONA(j.hfcon,j.htran,j.hnrel, j.hsucor);
                                 documento := trim(fn_ah_dni(j.hfcon,j.htran,j.hnrel, j.hsucor));
                              end if;
                           end if;
                        End LOOP;
                        Begin  ---05042019
                            if Tipo = 'C' then
                                ordinal := 53;
                            else
                                ordinal := 55;
                            end if;
                            select 'S'
                              into Auto
                              from  fsh010
                            where PgCod= 1
                            ANd Hcmod = MOD1
                            ANd Hsucor = i.sucursal ---agencia
                            ANd Htran = TRAN
                            ANd Hnrel = i.relacion
                            ANd Hcord = ordinal
                            ANd Hfcont = i.fecha
                            ANd Excod  = 3
                            ANd Exstat ='S'
                            and rownum = 1;
                       exception
                         when no_data_found then
                            Auto := 'N';
                       end;

                        IF Agencia is not  Null then
                            If Tipo = 'C' and Auto = 'N' then
                               if tasa <> 0.00000000 then
                                 Sp_ins_Compra(Agencia,fecha,I.HORA,i.usuing,nomcliente,tasa, monto, entregado, ln_operador ,documento);
                               end if;
                            End If;
                            If Tipo = 'V' then
                                if tasa <> 0.00000000 then
                                  Sp_ins_Venta(Agencia,fecha,imphrora,i.usuing,nomcliente,tasa, entregado,monto, ln_operador,documento);
                                end if;
                            End If;
                        End If;

                     END;
                 END LOOP;

                 FOR v1 in ORDINALES (ln_fechaini, ln_fechafin ,ln_scsuc) loop
                    If  v1.hcodmo = 2  then
                        TipoRubro := 'C';
                    End If;
                    If v1.hcodmo = 1  then
                        TipoRubro := 'V';
                    End If;
                    --(vhcmod in number,vhsucor in number,vhtran in number,vhnrel in number, vhfcon in date)
                    begin
                        SELECT Hhora, Husing
                          into imphrora, impusuario
                          FROM FSH015
                         Where Pgcod = 1
                           and Hcmod = v1.hcmod
                           and Hsucor = v1.hsucor
                           and Htran = v1.htran
                           and Hnrel = v1.hnrel
                           and Hfcon = v1.hfcon;
                    end;
                    Nomcliente := NULL;
                    Agencia := Null;

                    For ord in ORDINAL16(v1.hcmod,v1.hsucor,v1.htran,v1.hnrel,v1.hfcon)loop
                          If  ord.hcta <> 0 and exCuenta =  'N'   then
                              v_cuenta   := ord.hcta;
                              exCuenta := 'S';
                         End If;
                         If ord.hctcbi <> 0 and ExHctbi = 'N' then
                            v_Hctcbi := ord.hctcbi ;
                            ExHctbi := 'S';
                        End If;
                        If ord.hrubro = 1918090100002 then
                            Entregado := ord.hcimp1;
                        End If;
                        If ord.hrubro = 2928090100001 then
                            Monto := ord.hcimp1;
                        End If;
                        SELECT Scnom
                             into Agencia
                             FROM FST001
                            Where Pgcod = 1
                              and Sucurs = ord.hsucor;
                    end loop;
                    if Agencia is not null then
                      If exCuenta = 'N' AND v_cuenta = 0   then
                         nomcliente := fn_ah_PERSONA(v1.hfcon, v1.htran, v1.hnrel, v1.hsucor);
                         documento  := trim(fn_ah_DNI(v1.hfcon, v1.htran, v1.hnrel, v1.hsucor));
                      Else
                         nomcliente := fn_ah_nombre(v_cuenta);
                      End If;
                      If TIPO = 'C' AND TIPO = TipoRubro then
                          if v_Hctcbi <> 0.00000000 then
                            Sp_ins_Compra(Agencia,v1.hfcon,imphrora , impusuario, nomcliente,v_Hctcbi,monto,entregado, ln_operador,documento);
                          end if;
                      End If;
                      If Tipo = 'V' AND Tipo = TipoRubro then
                          if v_Hctcbi <> 0.00000000 then
                             Sp_ins_Venta(Agencia,v1.hfcon,imphrora , impusuario, nomcliente,v_Hctcbi,entregado,monto, ln_operador,documento );
                          end if;
                      End If;
                   End If;
                 END LOOP;
             ELSE
                  MODULO := trunc(T.TP1NRO1/1000);
                  TRAN  := mod(T.TP1NRO1,1000) ;---T.TP1NRO1 - (MODULO * 1000); TRANV := TRAN ;
                  TIPO := 'V';
                  MOD1 := Modulo;
                  For i in MOVHIST(MOD1,TRAN) LOOP
                     BEGIN
                        Nomcliente := NULL;
                        Agencia := Null;
                        monto := 0;
                        entregado := 0;

                        fOR j IN MOVHISTORD(MOD1,TRAN, i.relacion, i.fecha)loop
                           if  j.hmda = 101 then
                               monto := j.hcimp1;
                           end if;
                           if j.hmda = 0 then
                               entregado := j.hcimp1;
                           end if;
                           fecha := j.hfcon;
                           SELECT Scnom
                             into Agencia
                             FROM FST001
                            Where Pgcod = 1
                              and Sucurs = j.hsucor;
                              tasa := j.hctcbi;
                              if tasa <> 0.00000000 then
                                 tasa1 := j.hctcbi;
                              end if;
                           if j.hcta <> 0 then
                               nomcliente := fn_ah_nombre(j.hcta);
                           else
                              if j.hcta = 0 and Nomcliente is  null then
                                 nomcliente := fn_ah_PERSONA(j.hfcon,j.htran,j.hnrel, j.hsucor);
                                 documento := trim(fn_ah_dNI(j.hfcon,j.htran,j.hnrel, j.hsucor));
                              end if;
                           end if;
                           modulo1 := j.hmodul;
                        End LOOP;
                        Begin  ---05042019
                            if Tipo = 'C' then
                                ordinal := 53;
                            else
                                ordinal := 55;
                            end if;
                            select 'S'
                              into Auto
                              from  fsh010
                            where PgCod= 1
                            ANd Hcmod = MOD1
                            ANd Hsucor = i.sucursal --agencia
                            ANd Htran = TRAN
                            ANd Hnrel = i.relacion
                            ANd Hcord = ordinal
                            ANd Hfcont = i.fecha
                            ANd Excod  = 3
                            ANd Exstat ='S'
                            and rownum = 1;
                       exception
                         when no_data_found then
                            Auto := 'N';
                       end;
                        if Agencia  is not null then
                            If Tipo = 'C' and Auto = 'N' then
                               if tasa <> 0.00000000 then
                                 Sp_ins_Compra(Agencia,fecha,i.hora,i.usuing,nomcliente,tasa, monto, entregado, ln_operador,documento );
                               else
                                  if modulo1 = 472 then
                                     Sp_ins_Venta(Agencia,fecha,i.hora,i.usuing,nomcliente,tasa1, entregado,monto, ln_operador,documento );
                                  end if;
                               end if;
                            End If;
                            If Tipo = 'V'  and Auto = 'N' then
                                if tasa <> 0.00000000 then
                                  Sp_ins_Venta(Agencia,fecha,i.hora,i.usuing,nomcliente,tasa, entregado,monto, ln_operador,documento );
                                else
                                  if modulo1 = 472 then
                                     Sp_ins_Venta(Agencia,fecha,i.hora,i.usuing,nomcliente,tasa1, entregado,monto, ln_operador,documento );
                                  end if;
                                end if;
                            End If;
                         End If;

                     END;
                 END LOOP;
--                 Nomcliente := NULL;
                 FOR v1 in ORDINALES (ln_fechaini, ln_fechafin ,ln_scsuc) loop
                    If  v1.hcodmo = 2  then
                        TipoRubro := 'C';
                    End If;
                    If v1.hcodmo = 1  then
                        TipoRubro := 'V';
                    End If;
                    --(vhcmod in number,vhsucor in number,vhtran in number,vhnrel in number, vhfcon in date)
                    begin
                        SELECT Hhora, Husing
                          into imphrora, impusuario
                          FROM FSH015
                         Where Pgcod = 1
                           and Hcmod = v1.hcmod
                           and Hsucor = v1.hsucor
                           and Htran = v1.htran
                           and Hnrel = v1.hnrel
                           and Hfcon = v1.hfcon;
                    end;
                    NomCliente := Null;
                    Agencia := Null;

                    For ord in ORDINAL16(v1.hcmod,v1.hsucor,v1.htran,v1.hnrel,v1.hfcon)loop
                          If  ord.hcta <> 0 and exCuenta =  'N'   then
                              v_cuenta   := ord.hcta;
                              exCuenta := 'S';
                         End If;
                         If ord.hctcbi <> 0 and ExHctbi = 'N' then
                            v_Hctcbi := ord.hctcbi ;
                            ExHctbi := 'S';
                        End If;
                        If ord.hrubro = 1918090100002 then
                            Entregado := ord.hcimp1;
                        End If;
                        If ord.hrubro = 2928090100001 then
                            Monto := ord.hcimp1;
                        End If;
                        SELECT Scnom
                             into Agencia
                             FROM FST001
                            Where Pgcod = 1
                              and Sucurs = ord.hsucor;
                    end loop;

                    if Agencia is not null then
                        If exCuenta = 'N' AND v_cuenta = 0   then
                           nomcliente := fn_ah_PERSONA(v1.hfcon, v1.htran, v1.hnrel, v1.hsucor);
                           documento  := trim(fn_ah_dni(v1.hfcon, v1.htran, v1.hnrel, v1.hsucor));
                        Else
                           nomcliente := fn_ah_nombre(v_cuenta);
                        End If;

                        If TIPO = 'C' AND TIPO = TipoRubro then
                            if v_Hctcbi <> 0.00000000 then
                              Sp_ins_Compra(Agencia,v1.hfcon,imphrora , impusuario, nomcliente,v_Hctcbi,monto,entregado, ln_operador,documento );
                            end if;
                        End If;
                        If Tipo = 'V' AND Tipo = TipoRubro then
                            if v_Hctcbi <> 0.00000000 then
                               Sp_ins_Venta(Agencia,v1.hfcon,imphrora , impusuario, nomcliente,v_Hctcbi,entregado,monto, ln_operador,documento);
                            else
                              if modulo1 = 472 then
                                 Sp_ins_Venta(Agencia,v1.hfcon,imphrora , impusuario, nomcliente,v_Hctcbi,entregado,monto, ln_operador,documento);
                              end if;
                            end if;
                        End If;
                    End If;
                 END LOOP;
             End If;
         End LOOP;
    when 2 then
       Delete from jaqy659;
       commit;
    end case;
END;
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
function fn_ah_nombre(CUENTA  in number) return VARCHAR2 IS
   nombre varchar2(50);
   begin
     select f1.penom
       into nombre
       from FSR008 F8, FSD001 F1
      Where F8.Pgcod = 1
        AND F8.Ctnro = CUENTA
        AND F8.Cttfir = 'T'
        and f1.pepais = f8.pepais
        and f1.petdoc = f8.petdoc
        and f1.pendoc = f8.pendoc ;
     IF NOMBRE IS NULL THEN
        NOMBRE := 'SIN REGISTRO';
     END IF;
     return(nombre);
   exception
     when no_data_found then
      nombre := 'SIN REGISTRO';
      return(nombre);
end fn_ah_nombre;
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
function fn_ah_PERSONA(FECHA in DATE, RTRAN IN NUMBER, RREL IN NUMBER, RSUC IN NUMBER) return VARCHAR2 IS
   persona varchar2(70);
  BEGIN
     SELECT Txtord
       into persona
       FROM FSX016
      WHERE Hfcon = fecha
        and Htran = rtran
        and Hnrel = rrel
        and Pgcod = 1
        and Hcmod = 50
        and Hsucor = rsuc
        and Hcord in (52, 50)
        and Txcod = 5
        and Txoren = 1;
        IF persona IS NULL THEN
           persona := 'SIN REGISTRO';
        END IF;
       return(persona);
  exception
     when no_data_found then
      persona := 'SIN REGISTRO';
      return(persona);

end fn_ah_PERSONA;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
function fn_ah_DNI(FECHA in DATE, RTRAN IN NUMBER, RREL IN NUMBER, RSUC IN NUMBER) return varchar2 IS
   persona varchar2(70);
  BEGIN
     SELECT trim(Txtord)
       into persona
       FROM FSX016
      WHERE Hfcon = fecha
        and Htran = rtran
        and Hnrel = rrel
        and Pgcod = 1
        and Hcmod = 50
        and Hsucor = rsuc
        and Hcord in (52, 50)
        and Txcod = 6
        and Txoren = 1;
        IF persona IS NULL THEN
           persona := 'SIN REGISTRO';
        END IF;
--       return(persona);
return(substr(persona,1,12));

  exception
     when no_data_found then
      persona := 'SIN REGISTRO';
      return(persona);
when others then
persona := 'SIN REGISTRO';
return(persona);
end fn_ah_DNI;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
procedure Sp_ins_Compra(Agencia in varchar2,
                        fecha in date,
                        hora in VARCHAR2,
                        usuing in varchar2,
                        cliente in varchar2,
                        tasa in number,
                        monto in number,
                        entregado in number,
                        operador in varchar2,
                        Nrodoc in character)is
begin

          INSERT INTO JAQY659(JAQY659COD,
                              JAQY659AGE,
                              JAQY659FEC,
                              JAQY659HOR,
                              JAQY659OPE,
                              JAQY659CLI,
                              JAQY659TC,
                              JAQY659M1,
                              JAQY659M2,
                              TIPO,
                              USUARIO,
                              Jaqy659dni)
                     VALUES (SEQ_JAQY659.NEXTVAL,
                             AGENCIA,
                             FECHA,
                             HORA,
                             USUING,
                             CLIENTE,
                             TASA,
                             MONTO,
                             ENTREGADO,
                             1,
                             operador,
                             Nrodoc);
           commit;
end Sp_ins_Compra;
procedure Sp_ins_Venta(Agencia in varchar2,
                       fecha in date,
                       hora in varchar2,
                       usuing in varchar2,
                       cliente in varchar2,
                       tasa in number,
                       entregado in number,
                       monto in number,
                       ln_operador in varchar2,
                       Nrodoc in character )is
begin

 INSERT INTO JAQY659(JAQY659COD,
                    JAQY659AGE,
                    JAQY659FEC,
                    JAQY659HOR,
                    JAQY659OPE,
                    JAQY659CLI,
                    JAQY659TC,
                    JAQY659M1,
                    JAQY659M2,
                    TIPO,
                    USUARIO,
                    JAQY659DNI)
             VALUES (SEQ_JAQY659.NEXTVAL,
                     AGENCIA,
                     FECHA,
                     HORA,
                     USUING,
                     CLIENTE,
                     TASA,
                     ENTREGADO,
                     MONTO,
                     2,
                     ln_operador,
                     NroDoc );
           commit;
end Sp_ins_Venta;


END PQ_AH_TIPOCAMBIO;
/

