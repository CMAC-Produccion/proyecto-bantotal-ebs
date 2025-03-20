create or replace package pq_cr_ampliacion_lineas is

  -- Author  : MPOSTIGOC
  -- Created : 3/12/2021 08:56:10
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_inicio(ln_instancia in number, lc_flag out varchar2);
  -------------------------------------------------
  procedure sp_cr_insert_jaqy800(ln_pgcd in number,
                                 ln_ins  in number,
                                 ln_mod  in number,
                                 ln_suc  in number,
                                 ln_mda  in number,
                                 ln_pap  in number,
                                 ln_cta  in number,
                                 ln_ope  in number,
                                 ln_sbop in number,
                                 ln_tope in number,
                                 ln_mto  in number,
                                 lc_usr  in varchar2,
                                 ln_ins2 in number);

end pq_cr_ampliacion_lineas;
/

create or replace package body pq_cr_ampliacion_lineas is

  -- Private type declarations
  procedure sp_cr_inicio(ln_instancia in number, lc_flag out varchar2) is
  
    ld_MaxFch697 date;
    ln_EsAmpl    number;
    lc_asesor    varchar2(10);
    ln_mnt       number(17, 2);
    ln_mod697    number;
    ln_suc697    number;
    ln_mda697    number;
    ln_pap697    number;
    ln_cta697    number;
    ln_ope697    number;
    ln_sbop697   number;
    ln_tope697   number;
    ln_intancia2 number;
    ln_inserto   number;
  
  begin
  
    lc_flag := 'S';
  
    begin
      select max(j.jaqz697fep) into ld_MaxFch697 from jaqz697 j;
    end;
  
    begin
    
      select count(*)
        into ln_EsAmpl
        from xwf700 x, jaqz697 j
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1'
         and x.xwfempresa = 1
         and x.xwfsucursal = j.jaqz697suc
         and x.xwfmodulo = j.jaqz697mod
         and x.xwfmoneda = j.jaqz697mda
         and x.xwfcuenta = j.jaqz697cta
         and x.xwftipope = j.jaqz697top
         and j.jaqz697des = 'AMPLIACION'
         and j.jaqz697mod = 117
         and j.jaqz697fep = ld_MaxFch697;
    end;
  
    IF ln_EsAmpl > 0 then
    
      begin
        select J.JAQZ697ASE,
               J.JAQZ697MTO,
               J.JAQZ697MOA,
               J.JAQZ697SUA,
               J.JAQZ697MAA,
               J.JAQZ697PAA,
               J.JAQZ697CAA,
               J.JAQZ697OPA,
               J.JAQZ697SBA,
               J.JAQZ697TOA
          into lc_asesor,
               ln_mnt,
               ln_mod697,
               ln_suc697,
               ln_mda697,
               ln_pap697,
               ln_cta697,
               ln_ope697,
               ln_sbop697,
               ln_tope697
          from xwf700 x, jaqz697 j
         where x.xwfprcins = ln_instancia
           and x.xwfcar3 = '1'
           and x.xwfempresa = 1
           and x.xwfsucursal = j.jaqz697suc
           and x.xwfmodulo = j.jaqz697mod
           and x.xwfmoneda = j.jaqz697mda
           and x.xwfcuenta = j.jaqz697cta
           and x.xwftipope = j.jaqz697top
           and j.jaqz697des = 'AMPLIACION'
           and j.jaqz697mod = 117
           and j.jaqz697fep = ld_MaxFch697;
      exception
        when others then
          null;
      end;
    
      if ln_mod697 =116 then
      
        begin
          select f.r2mod,
                 f.r2suc,
                 f.r2mda,
                 f.r2pap,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2tope
            into ln_mod697,
                 ln_suc697,
                 ln_mda697,
                 ln_pap697,
                 ln_cta697,
                 ln_ope697,
                 ln_sbop697,
                 ln_tope697
            from fsr011 f
           where f.r1cod = 1
             and f.r1mod = ln_mod697
             and f.r1suc = ln_suc697
             and f.r1mda = ln_mda697
             and f.r1pap = ln_pap697
             and f.r1cta = ln_cta697
             and f.r1oper = ln_ope697
             and f.r1sbop = ln_sbop697
             and f.r1tope = ln_tope697
             and f.relcod = 46;
        exception
          when others then
            null;          
        end;      
      end if;
    
      ln_intancia2 := fn_instancia_credito(v_Scmod  => ln_mod697,
                                           v_Scsuc  => ln_suc697,
                                           v_Scmda  => ln_mda697,
                                           v_Scpap  => ln_pap697,
                                           v_Sccta  => ln_cta697,
                                           v_Scoper => ln_ope697,
                                           v_Scsbop => ln_sbop697,
                                           v_Sctope => ln_tope697);
    
      begin
      
        pq_cr_ampliacion_lineas.sp_cr_insert_jaqy800(ln_pgcd => 1,
                                                     ln_ins  => ln_instancia,
                                                     ln_mod  => ln_mod697,
                                                     ln_suc  => ln_suc697,
                                                     ln_mda  => ln_mda697,
                                                     ln_pap  => ln_pap697,
                                                     ln_cta  => ln_cta697,
                                                     ln_ope  => ln_ope697,
                                                     ln_sbop => ln_sbop697,
                                                     ln_tope => ln_tope697,
                                                     ln_mto  => ln_mnt,
                                                     lc_usr  => lc_asesor,
                                                     ln_ins2 => ln_intancia2);
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_inserto
          from jaqy800 j
         where j.jaqy800ins = ln_instancia;
      end;
    
      if ln_inserto > 0 then
        lc_flag := 'SI';
      else
        lc_flag := 'NO';
      end if;
    end if;
  
  end sp_cr_inicio;
  --------------------------------------------------
  procedure sp_cr_insert_jaqy800(ln_pgcd in number,
                                 ln_ins  in number,
                                 ln_mod  in number,
                                 ln_suc  in number,
                                 ln_mda  in number,
                                 ln_pap  in number,
                                 ln_cta  in number,
                                 ln_ope  in number,
                                 ln_sbop in number,
                                 ln_tope in number,
                                 ln_mto  in number,
                                 lc_usr  in varchar2,
                                 ln_ins2 in number) is
  
    ld_ufec TIMESTAMP(6);
  
  begin
  
    begin
      select sysdate into ld_ufec from dual;
    end;
  
    /* begin
      insert into prueba (instancia, salida) values (ln_ins, 'JAQY800');
      commit;
    end;*/
  
    begin
      insert into jaqy800
        (jaqy800pgcd,
         jaqy800ins,
         jaqy800mod,
         jaqy800suc,
         jaqy800mda,
         jaqy800pap,
         jaqy800cta,
         jaqy800ope,
         jaqy800sbop,
         jaqy800tope,
         jaqy800mto,
         jaqy800usr,
         jaqy800ufec,
         jaqy800vinc,
         jaqy800usrm,
         jaqy800fecm,
         jaqy800nipm,
         jaqy800tpc,
         jaqy800ins2)
      values
        (ln_pgcd,
         ln_ins,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_mto,
         lc_usr,
         ld_ufec,
         'S',
         '',
         '',
         '',
         'P',
         ln_ins2);
    
      commit;
    end;
  
  end;

end pq_cr_ampliacion_lineas;
/

