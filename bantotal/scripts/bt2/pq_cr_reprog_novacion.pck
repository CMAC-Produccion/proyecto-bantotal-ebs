create or replace package pq_Cr_reprog_novacion is

  procedure Sp_existeBII(pn_ins in number,
                        pc_flg out char,
                        pn_mto out number);
  Procedure sp_esNovacion(pn_ins in number, pc_flg out char);
  procedure Sp_existeBI(pn_ins in number,
                        pc_flg out char,
                        pn_mto out number);
end;
/

create or replace package body pq_Cr_reprog_novacion is

  procedure Sp_existeBII(pn_ins in number,
                        pc_flg out char,
                        pn_mto out number) is
  --abernedo  apunta a tabla AQPA842
    ln_emp    number(3);
    ln_mod    number(3);
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_cta    number(9);
    ln_ope    number(9);
    ln_sbo    number(3);
    ln_top    number(3);
    ln_cta001 number(9);
    ld_Fec    date;
    lc_flg    char(1) := 'N';
    ln_mto    number(17, 2);
  
  begin
  
    begin
    
      select a.jaqy800pgcd,
             a.jaqy800mod,
             a.jaqy800suc,
             a.jaqy800mda,
             a.jaqy800pap,
             a.jaqy800cta,
             a.jaqy800ope,
             a.jaqy800sbop,
             a.jaqy800tope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from jaqy800 a
       where a.jaqy800ins = pn_ins;
    exception
      when too_many_rows then
        begin
        
          select a.jaqy800pgcd,
                 a.jaqy800mod,
                 a.jaqy800suc,
                 a.jaqy800mda,
                 a.jaqy800pap,
                 a.jaqy800cta,
                 a.jaqy800ope,
                 a.jaqy800sbop,
                 a.jaqy800tope
            into ln_emp,
                 ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbo,
                 ln_top
            from jaqy800 a
           where a.jaqy800ins = pn_ins
             and a.jaqy800vinc = 'S'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    begin
      select a.sng001cta
        into ln_cta001
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpa842fecupd) into ld_Fec from aqpa842 a;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_flg
        from aqpa842 a
       where a.aqpa842fecupd = ld_Fec
         and a.aqpa842cta = ln_cta001
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpa842mtoi
        into ln_mto
        from aqpa842 a
       where a.aqpa842fecupd = ld_Fec
         and a.aqpa842emp = ln_emp
         and a.aqpa842mod = ln_mod
         and a.aqpa842suc = ln_suc
         and a.aqpa842mda = ln_mda
         and a.aqpa842pap = ln_pap
         and a.aqpa842cta = ln_cta
         and a.aqpa842ope = ln_ope
         and a.aqpa842sbo = ln_sbo
         and a.aqpa842top = ln_top;
    exception
      when too_many_rows then
        begin
          select a.aqpa842mtoi
            into ln_mto
            from aqpa842 a
           where a.aqpa842fecupd = ld_Fec
             and a.aqpa842emp = ln_emp
             and a.aqpa842mod = ln_mod
             and a.aqpa842suc = ln_suc
             and a.aqpa842mda = ln_mda
             and a.aqpa842pap = ln_pap
             and a.aqpa842cta = ln_cta
             and a.aqpa842ope = ln_ope
             and a.aqpa842sbo = ln_sbo
             and a.aqpa842top = ln_top
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
    pc_flg := nvl(lc_flg, 'N');
    pn_mto := nvl(ln_mto, 0);
  
  end Sp_existeBII;

  Procedure sp_esNovacion(pn_ins in number, pc_flg out char) is
  
    lc_flg char(1) := 'N';
  begin
  
    begin
      select 'S'
        into lc_flg
        from sng001 s
       where s.sng001inst = pn_ins
         and s.sng014cod = 5 --colocar codigo de novacion
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    pc_flg := nvl(lc_flg, 'N');
  
  end sp_esNovacion;

  procedure Sp_existeBI(pn_ins in number,
                        pc_flg out char,
                        pn_mto out number) is
  
    ln_emp    number(3);
    ln_mod    number(3);
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_cta    number(9);
    ln_ope    number(9);
    ln_sbo    number(3);
    ln_top    number(3);
    ln_cta001 number(9);
    ld_Fec    date;
    lc_flg    char(1) := 'N';
    ln_mto    number(17, 2);
    ln_idley  number;

  --dcastro  apunta a tablas contactabilidad
  --dcastro 2020.12.17 dcastro se modifico consulta a tabla LEY31050_CREDITOSFACILIDAD
  --dcastro 2020.12.18 dcastro se agrego condicion de campo idley en tabla LEY31050_CREDITOSFACILIDAD
  begin
  
    begin
    
      select a.jaqy800pgcd,
             a.jaqy800mod,
             a.jaqy800suc,
             a.jaqy800mda,
             a.jaqy800pap,
             a.jaqy800cta,
             a.jaqy800ope,
             a.jaqy800sbop,
             a.jaqy800tope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from jaqy800 a
       where a.jaqy800ins = pn_ins;
    exception
      when too_many_rows then
        begin
        
          select a.jaqy800pgcd,
                 a.jaqy800mod,
                 a.jaqy800suc,
                 a.jaqy800mda,
                 a.jaqy800pap,
                 a.jaqy800cta,
                 a.jaqy800ope,
                 a.jaqy800sbop,
                 a.jaqy800tope
            into ln_emp,
                 ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbo,
                 ln_top
            from jaqy800 a
           where a.jaqy800ins = pn_ins
             and a.jaqy800vinc = 'S'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    begin
      select a.sng001cta
        into ln_cta001
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
  
    begin
       select 'S', L.IDLEY31050
        into lc_flg, ln_idley
        FROM LEY31050 L
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE L.ESTADOSOLICITUD = 'BT' 
            AND L.TIPOFACILIDAD = 'CAJA'
            AND F.FACILIDAD like 'Exoneraci%'
            AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = ln_cta001
            and rownum = 1;
       
    exception
      when others then
        ln_idley := null;
    end;
  
    begin
      SELECT F.MONTOCAPITALIZACION
        into ln_mto
      FROM LEY31050_CREDITOSFACILIDAD F --2020.12.17 se cambio en lugar de LEY31050_CREDITOS
      WHERE F.IDLEY31050 =  ln_idley  --2020.12.18 se agrego condicion idley
          AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = ln_cta
          AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = ln_ope
          AND F.EMPRESA  = ln_emp
          AND F.SUCURSAL = ln_suc
          AND F.MODULO =  ln_mod
          AND F.MONEDA =  ln_mda
          AND F.PAPEL  =  ln_pap
          AND F.SUBOPERACION  = ln_sbo
          AND F.TIPOOPERACION = ln_top;  
    exception
      when too_many_rows then
        begin
          SELECT F.MONTOCAPITALIZACION
            into ln_mto
          FROM LEY31050_CREDITOSFACILIDAD F --2020.12.17 se cambio en lugar de LEY31050_CREDITOS
          WHERE F.IDLEY31050 =  ln_idley  --2020.12.18 se agrego condicion idley
              AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = ln_cta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = ln_ope
              AND F.EMPRESA  = ln_emp
              AND F.SUCURSAL = ln_suc
              AND F.MODULO =  ln_mod
              AND F.MONEDA =  ln_mda
              AND F.PAPEL  =  ln_pap
              AND F.SUBOPERACION  = ln_sbo
              AND F.TIPOOPERACION = ln_top
              and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
    pc_flg := nvl(lc_flg, 'N');
    pn_mto := nvl(ln_mto, 0);
  
  end Sp_existeBI;

end pq_Cr_reprog_novacion;
/

