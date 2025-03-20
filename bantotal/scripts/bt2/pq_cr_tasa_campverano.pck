create or replace package PQ_CR_TASA_CAMPVERANO is

  -- Author  : MPOSTIGOC
  -- Created : 3/01/2020 8:53:45 a. m.
  -- Descripcion : Tasa para la campaña verano PYME 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 

  procedure sp_cr_inicio(ln_pais      in number,
                         ln_tdoc      in number,
                         lc_ndoc      in varchar2,
                         lc_usuario   in varchar2,
                         ld_fecpro    in date,
                         ln_NroCuenta in number,
                         ln_modulo    in number);

end PQ_CR_TASA_CAMPVERANO;
/

create or replace package body PQ_CR_TASA_CAMPVERANO is

  procedure sp_cr_inicio(ln_pais      in number,
                         ln_tdoc      in number,
                         lc_ndoc      in varchar2,
                         lc_usuario   in varchar2,
                         ld_fecpro    in date,
                         ln_NroCuenta in number,
                         ln_modulo    in number) is
  
    cursor datos_tasa_fsd027(Nro_Pizarra number) is
      select distinct d.pgcod  ln_pgcod,
                      d.tamod  ln_tamod,
                      d.tpizar ln_tpizar,
                      d.tamda  ln_tamda,
                      d.tapap  ln_tapap,
                      d.tafdes ld_tafdes,
                      d.tamto  ln_tamto,
                      d.tattas ln_tattas
        from fsd025 d, fsr025 s
       where d.pgcod = s.pgcod
         and d.tamod = s.tamod
         and d.tpizar = s.tpizar
         and d.tamda = s.tamda
         and d.tapap = s.tapap
         and d.tafdes = s.tafdes
         and d.tamto = s.tamto
         and d.tpizar = Nro_Pizarra
         and d.tamod = ln_modulo;
  
    cursor datos_tasa_fsd327(Nro_Pizarra number) is
      select distinct d.pgcod  ln_pgcod,
                      d.tamod  ln_tamod,
                      d.tpizar ln_tpizar,
                      d.tamda  ln_tamda,
                      d.tapap  ln_tapap,
                      d.tafdes ld_tafdes
        from fsd025 d, fsr025 s
       where d.pgcod = s.pgcod
         and d.tamod = s.tamod
         and d.tpizar = s.tpizar
         and d.tamda = s.tamda
         and d.tapap = s.tapap
         and d.tafdes = s.tafdes
         and d.tamto = s.tamto
         and d.tpizar = Nro_Pizarra
         and d.tamod = ln_modulo;
  
    cursor datos_tasa(Nro_Pizarra number) is
      select d.pgcod  ln_pgcod,
             d.tamod  ln_tamod,
             d.tpizar ln_tpizar,
             d.tamda  ln_tamda,
             d.tapap  ln_tapap,
             d.tafdes ld_tafdes,
             d.tamto  ln_tamto,
             d.tattas ln_tattas,
             s.tatasa ln_tatasa,
             s.tapzo  ln_tapzo
        from fsd025 d, fsr025 s
       where d.pgcod = s.pgcod
         and d.tamod = s.tamod
         and d.tpizar = s.tpizar
         and d.tamda = s.tamda
         and d.tapap = s.tapap
         and d.tafdes = s.tafdes
         and d.tamto = s.tamto
         and d.tpizar = Nro_Pizarra
         and d.tamod = ln_modulo; --
  
    ln_calificacion number;
    Nro_Pizarra     number;
    ld_FchFin       date;
    ln_dia          varchar2(2);
    ln_mes          varchar2(2);
    ln_anio         varchar2(4);
    ld_FchInv       number;
    vTpfinv         number;
  
  begin
  
    /*  begin
      pq_cr_segmentacion_aplic.sp_carga_data(pd_fecpro => ld_fecpro, --Fecha de proceso
                                             pn_pai    => ln_pais, --pais
                                             pn_tdo    => ln_tdoc, --tipo document
                                             pc_doc    => lc_ndoc, --nro document
                                             pc_usr    => lc_usuario); --usuario de proceso
    end;
    
    begin
      select j.jaqz086calf
        into ln_calificacion
        from jaqz086_APL j
       where j.jaqz086paic = ln_pais
         and j.jaqz086tdoc = ln_tdoc
         and j.jaqz086tndoc = lc_ndoc
         and j.jaqz086usr = lc_usuario;
    exception
      when others then
        null;
    end;*/
  
    ln_calificacion := 39;
  
    begin
      select f.tp1imp1
        into Nro_Pizarra
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 450
         AND F.TP1CORR2 = 1
         and f.tp1nro3 = ln_calificacion;
    exception
      when others then
        Nro_Pizarra := 0;
    end;
  
    begin
      select to_date(Tp1nro1 || '/' || Tp1nro2 || '/' || Tp1nro3,
                     'DD/MM/YYYY')
        into ld_FchFin
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 450
         AND F.TP1CORR2 = 2;
    exception
      when others then
        ld_FchFin := '30/04/2020';
    end;
  
    begin
    
      begin
        select to_char(ld_fecpro, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_fecpro, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_fecpro, 'YYYY') into ln_anio from dual;
      end;
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    for d in datos_tasa_fsd027(Nro_Pizarra) loop
    
      begin
        insert into fsd027
          (pgcod,
           modulo,
           tpizar,
           ctnro,
           moneda,
           papel,
           tpfdes,
           tpmto,
           tpttas,
           tpfinv,
           tpvig)
        values
          (d.ln_pgcod,
           d.ln_tamod,
           d.ln_tpizar,
           ln_NroCuenta,
           d.ln_tamda,
           d.ln_tapap,
           ld_fecpro, --d.ld_tafdes,
           d.ln_tamto,
           d.ln_tattas,
           vTpfinv,
           'S');
      end;
    end loop;
  
    for d in datos_tasa_fsd327(Nro_Pizarra) loop
      begin
        insert into fsd327
          (vt1pgcod,
           vt1mod,
           vt1tpiz,
           vt1ctnr,
           vt1mon,
           vt1pap,
           vt1tpfd,
           vt1fchven)
        values
          (d.ln_pgcod,
           d.ln_tamod,
           d.ln_tpizar,
           ln_NroCuenta,
           d.ln_tamda,
           d.ln_tapap,
           ld_fecpro, --d.ld_tafdes,
           ld_FchFin);
      end;
      commit;
    end loop;
  
    for d in datos_tasa(Nro_Pizarra) loop
    
      begin
        insert into fsr027
          (pgcod,
           modulo,
           tpizar,
           ctnro,
           moneda,
           papel,
           tpfdes,
           tpmto,
           tppzo,
           tptasa)
        values
          (d.ln_pgcod,
           d.ln_tamod,
           d.ln_tpizar,
           ln_NroCuenta,
           d.ln_tamda,
           d.ln_tapap,
           ld_fecpro, --d.ld_tafdes,
           d.ln_tamto,
           d.ln_tapzo,
           d.ln_tatasa);
      end;
      commit;
    end loop;
  
  end sp_cr_inicio;

end PQ_CR_TASA_CAMPVERANO;
/

