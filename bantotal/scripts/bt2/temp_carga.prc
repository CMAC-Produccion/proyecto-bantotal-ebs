CREATE OR REPLACE PROCEDURE TEMP_CARGA as

      ca1 number(9,0);--sucursal
      ca2 number(9,0);--cuenta
      ca3 number(9,0);--suboperacion
      ca4 number(9,0);--tipo operacion
      ca5 number(9,0);--moneda
      ca6 number(9,0);--moneda
      ca7 number(9,0);--moneda
      ca8 number(9,0);--moneda
      v1 number(9,0);
      v2 number(9,0);

cursor diferencias is
       SELECT /*+all_rows parallel(a,8) parallel(b,8) parallel(C,8)*/C_DESCRI,
       c_descri1,
       b.bnj096suc,
       b.bnj096mda,
       b.bnj096pap,
       b.bnj096cta,
       b.bnj096ope,
       b.bnj096sub,
       b.bnj096mod,
       b.bnj096top
      from crdtcap a, bnj096 b, fsd011 c
     where trim(a.c_descri) = trim(b.bnj096sor)
       and b.bnj096suc = c.scsuc
       and b.bnj096mda = c.scmda
       and b.bnj096pap = c.scpap
       and b.bnj096cta = c.sccta
       and b.bnj096ope = c.scoper
       and b.bnj096sub = c.scsbop
       and b.bnj096mod = c.scmod
       and b.bnj096top = c.sctope
       and c.pgcod = 1
       and c.scstat < 99;
begin
    for i in diferencias loop
        ca1:= i.bnj096suc;
        ca2:= i.bnj096mda;
        ca3:= i.bnj096pap;
        ca4:= i.bnj096cta;
        ca5:= i.bnj096ope;
        ca6:= i.bnj096sub;
        ca7:= i.bnj096mod;
        ca8:= i.bnj096top;
        begin
         select distinct (x.ctnro) into v2
              from fsr008 x
             where x.pepais = 604
               and x.petdoc = 9
               and x.pendoc =   rpad(i.c_descri1,12,' ')
               and not exists (select 1
                                 from fse108 y
                                where y.ctxnro = x.ctnro
                                  and y.ctxhab = 'N'
                               )
              and (select count(*) from fsr008 t where t.pgcod=1 and t.ctnro=x.ctnro)=1 and rownum =1 ;
             exception
           when others then
                v2:=0;
           end;

           if v2>0 then
             begin
               insert into fsr011
               (R1COD, R1MOD, R1SUC, R1MDA, R1PAP, R1CTA, R1OPER, R1SBOP, R1TOPE, RELCOD, R2MOD, R2CTA, R2OPER, R2SBOP, R1RUB,
               R2COD, R2SUC, R2MDA, R2PAP, R2TOPE, R2RUB, R011CD, R011MO, R011SU, R011TR, R011RE, R011FC, R011OR, R011SB, R011CO)
               values(
                1,0,0,0,0,v2,0,0,0,45,21,ca4,0,ca6,0,1,ca1,ca2,0,
                       ca8,0,0,0,0,0,0,
                       to_date('04112015','ddmmyyyy'),0,0,'S');
               exception
               when others then
                    null;
             end ;
           end if;
    END LOOP;
END;
/

