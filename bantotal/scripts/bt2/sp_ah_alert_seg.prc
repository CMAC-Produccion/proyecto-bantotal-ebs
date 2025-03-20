create or replace procedure SP_AH_ALERT_SEG(pn_pgcod  number,
                                            pn_scsuc  number,
                                            pn_scmda  number,
                                            pn_scpap  number,
                                            pn_sccta  number,
                                            pn_scoper number,
                                            pn_scsbop number,
                                            pn_sctope number,
                                            pn_scmod  number,
                                            pn_canbat out number,
                                            pc_resul  out varchar2) is
  CURSOR SEGUROS (NUMDOC  IN CHAR) IS
     select distinct producto 
       from v_certificados
      where DOCUMENTO = NUMDOC;

  
  documentos char(12);
  producto   char(500);
  cuenta varchar2(9);
  var_pendoc varchar2(12);
Begin

    ---sma.01032023
    begin
      select tp1nro1
        into  pn_canbat
        from fst198 d
       where d.tp1cod = 1
         and d.tp1cod1 = 10816
         and d.tp1corr1 = 10
         and d.tp1corr2 = 4;
    exception
      when others then
        pn_canbat := 0;
    end;

    begin  --alerta seguros
       cuenta := to_char(pn_sccta);
       select trim(pendoc) 
         into var_pendoc
         from fsr008 
        where pgcod = 1 
          and ctnro = pn_sccta
          and ttcod = 1 
          and cttfir = 'T';
       
      select 'La cuenta que intenta cancelar tiene vinculado un seguro '|| trim(b.PRODUCTO)||' '||'si continua con la operación, perderá los beneficios del seguro'
        into pc_resul
        from v_certificados b
       where b.DOCUMENTO =  var_pendoc
         and instr(b.CUENTA, cuenta) <> 0
         ;

    exception
      when no_data_found then
        pc_resul := '';
        pn_canbat := 0;
      when too_many_rows then
        begin
          select pendoc
            into documentos
            from FSR008
           WHERE pgcod = 1 
             and CTNRO = pn_sccta--20230406
             and ttcod = 1
             and cttfir = 'T';
          For a in seguros(documentos) loop
            producto := trim(producto)||','||trim(a.producto);
          end loop;
          pc_resul := 'La cuenta que intenta cancelar tiene vinculado'||' '||trim(producto )||' '||'si continua con la operación, perderá los beneficios del seguro';
        exception
          when no_data_found then
            null;
        end;
    end;

end SP_AH_ALERT_SEG;
/

