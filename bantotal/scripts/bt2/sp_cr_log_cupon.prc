create or replace procedure SP_CR_LOG_CUPON(LC_USUARIO in varchar2,
                                            LC_NOMCLI  in varchar2,
                                            LN_CTA     in number,
                                            LN_MONTO   in number,
                                            LC_NDO     in varchar2) is
  LD_FCHSIST date;
  LN_CORR    number := 0;
  ld_hora    char(8);

begin

  begin
    select F.PGFAPE into LD_FCHSIST from fst017 F where pgcod = 1;
  end;

  begin
    select MAX(A.AQPC558CORR)
      into LN_CORR
      from AQPC558 A
     where A.AQPC558FECHA = LD_FCHSIST
       AND A.AQPC558USUREG = LC_USUARIO;
  
  end;

  begin
    select to_char(sysdate, 'HH24:MI:SS') into ld_hora from dual;
  end;

  LN_CORR := NVL(LN_CORR, 0);

  begin
    insert into AQPC558
      (AQPC558CORR,
       AQPC558FECHA,
       AQPC558HORA,
       AQPC558USUREG,
       AQPC558NOMCLI,
       AQPC558NROCTA,
       AQPC558MONTO,
       AQPC558NDO)
    values
      (LN_CORR + 1,
       LD_FCHSIST,
       ld_hora,
       LC_USUARIO,
       LC_NOMCLI,
       LN_CTA,
       LN_MONTO,
       LC_NDO);
  exception
    when others then
      null;
    
  end;
  commit;

end SP_CR_LOG_CUPON;
/

