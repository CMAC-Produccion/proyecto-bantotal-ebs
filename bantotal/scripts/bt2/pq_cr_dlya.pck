create or replace package PQ_CR_DLYA is

  -- Author  : ENINAH
  -- Created : 16/11/2022 11:30:00
  -- Purpose : Este paquete se encargara de todos los procesos que realice el bot de correos.
  procedure sp_cr_tabla_tem_AQPC574(fecha       in date,
                                    correlativo in number,
                                    usuario     in varchar2);
  procedure sp_cr_tabla_tem_AQPC576(fecha       in date,
                                    correlativo in number,
                                    usuario     in varchar2);
end PQ_CR_DLYA;
/

create or replace package body PQ_CR_DLYA is
  procedure sp_cr_tabla_tem_AQPC574(fecha       in date,
                                    correlativo in number,
                                    usuario     in varchar2) is
  begin
    begin
      delete from AQPC574 a
       where a.aqpc574fec = fecha
         and a.aqpc574cor = correlativo;
      --and a.aqpc574usu = usuario;
      commit;
    exception
      when others then
        null;
    end;
  
    begin
      insert into AQPC574 a
        (a.aqpc574pgcod,
         a.aqpc574ppmod,
         a.aqpc574ppsuc,
         a.aqpc574ppmda,
         a.aqpc574pppap,
         a.aqpc574ppcta,
         a.aqpc574ppoper,
         a.aqpc574ppsbop,
         a.aqpc574pptope,
         a.aqpc574ppfpag,
         a.aqpc574pptipo,
         a.aqpc574ppfval,
         a.aqpc574ppfvto,
         a.aqpc574pppzo,
         a.aqpc574ppcap,
         a.aqpc574ppint,
         a.aqpc574ppintmex,
         a.aqpc574ppicap,
         a.aqpc574ppiint,
         a.aqpc574ppstat,
         a.aqpc574ppnume,
         a.aqpc574ppfinv,
         a.aqpc574d601cd,
         a.aqpc574d601mo,
         a.aqpc574d601su,
         a.aqpc574d601tr,
         a.aqpc574d601re,
         a.aqpc574d601fc,
         a.aqpc574d601or,
         a.aqpc574d601sb,
         a.aqpc574d601co,
         a.aqpc574fec,
         a.aqpc574cor,
         a.AQPC574USU)
        (select b.pgcod,
                b.ppmod,
                b.ppsuc,
                b.ppmda,
                b.pppap,
                b.ppcta,
                b.ppoper,
                b.ppsbop,
                b.pptope,
                b.ppfpag,
                b.pptipo,
                b.ppfval,
                b.ppfvto,
                b.pppzo,
                b.ppcap,
                b.ppint,
                b.ppintmex,
                b.ppicap,
                b.ppiint,
                b.ppstat,
                b.ppnume,
                b.ppfinv,
                b.d601cd,
                b.d601mo,
                b.d601su,
                b.d601tr,
                b.d601re,
                b.d601fc,
                b.d601or,
                b.d601sb,
                b.d601co,
                b.fec,
                b.cor,
                usuario
           from AQPB088_601C b
          where b.fec = fecha
            and b.cor = correlativo);
      commit;
    exception
      when others then
        null;
    end;
  end sp_cr_tabla_tem_AQPC574;

  procedure sp_cr_tabla_tem_AQPC576(fecha       in date,
                                    correlativo in number,
                                    usuario     in varchar2) is
  begin
    begin
      delete from AQPC576 a
       where a.aqpc576fec = fecha
         and a.aqpc576cor = correlativo;
      --and a.aqpc576usu = usuario;
      commit;
    exception
      when others then
        null;
    end;
  
    begin
      insert into AQPC576 a
        (a.aqpc576pgcod,
         a.aqpc576ppmod,
         a.aqpc576ppsuc,
         a.aqpc576ppmda,
         a.aqpc576pppap,
         a.aqpc576ppcta,
         a.aqpc576ppoper,
         a.aqpc576ppsbop,
         a.aqpc576pptope,
         a.aqpc576ppfpag,
         a.aqpc576pptipo,
         a.aqpc576ppexte,
         a.aqpc576ppimp1,
         a.aqpc576ppimp2,
         a.aqpc576ppimp3,
         a.aqpc576ppimp4,
         a.aqpc576ppimp5,
         a.aqpc576ppimp6,
         a.aqpc576ppimp7,
         a.aqpc576ppimp8,
         a.aqpc576ppimp9,
         a.aqpc576ppimp10,
         a.aqpc576ppimp11,
         a.aqpc576ppimp12,
         a.aqpc576ppimp13,
         a.aqpc576ppimp14,
         a.aqpc576ppimp15,
         a.aqpc576ppimp16,
         a.aqpc576ppimp17,
         a.aqpc576ppimp18,
         a.aqpc576ppimp19,
         a.aqpc576ppimp20,
         a.aqpc576fec,
         a.aqpc576cor,
         a.aqpc576usu)
        (select b.pgcod,
                b.ppmod,
                b.ppsuc,
                b.ppmda,
                b.pppap,
                b.ppcta,
                b.ppoper,
                b.ppsbop,
                b.pptope,
                b.ppfpag,
                b.pptipo,
                b.ppexte,
                b.ppimp1,
                b.ppimp2,
                b.ppimp3,
                b.ppimp4,
                b.ppimp5,
                b.ppimp6,
                b.ppimp7,
                b.ppimp8,
                b.ppimp9,
                b.ppimp10,
                b.ppimp11,
                b.ppimp12,
                b.ppimp13,
                b.ppimp14,
                b.ppimp15,
                b.ppimp16,
                b.ppimp17,
                b.ppimp18,
                b.ppimp19,
                b.ppimp20,
                b.fec,
                b.cor,
                usuario
           from AQPB088_611C b
          where b.fec = fecha
            and b.cor = correlativo);
      commit;
    exception
      when others then
        null;
    end;
  end sp_cr_tabla_tem_AQPC576;

end PQ_CR_DLYA;
/

