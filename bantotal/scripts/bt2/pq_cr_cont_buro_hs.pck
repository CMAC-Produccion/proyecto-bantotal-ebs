create or replace package PQ_CR_CONT_BURO_HS is
  procedure sp_cr_obtenerCont(pn_fechaIn  in date,
                              pn_fechaFin in date,
                              pn_fechaApe in date,
                              ve_buro     in number,
                              pn_cont    out number
                              );
  procedure sp_cr_incremCont(pn_fechaApe in date,VE_BURO IN NUMBER);
  procedure sp_cr_insertarContad(VE_BURO IN NUMBER);
  procedure sp_obtener_contxburo(ve_buro      in number,
                                 ld_fecIni    in date,
                                 ld_fecfin    in date,
                                 ve_contador out number);
  procedure sp_obtener_contxburo(ve_buro      in number,                                 
                                 ve_contador out number);                                 
end PQ_CR_CONT_BURO_HS;
/

create or replace package body PQ_CR_CONT_BURO_HS is

  procedure sp_cr_obtenerCont(pn_fechaIn  in date,
                              pn_fechaFin in date,
                              pn_fechaApe in date,
                              ve_buro     in number,
                              pn_cont    out number
                              ) is
  BURO_DSC varchar(30);
  begin
    --IDENTIFICAR BURO
    BEGIN
      SELECT TRIM(TP1DESC)
      INTO BURO_DSC
      FROM FST198 
      WHERE TP1COD  = 1
        AND TP1COD1 = 11160
        AND TP1CORR1= 0
        AND TP1CORR2= 0
        AND TP1CORR3> 0
        AND TP1NRO1 = ve_buro;
    exception
      when others then
        null;    
    END;
    --OBTENER CONTADOR BURO
    BEGIN
       pq_cr_cont_buro_hs.sp_obtener_contxburo(ve_buro,pn_fechaIn,pn_fechaFin,pn_cont); 
    END;
    
    Begin
      insert into AQPB599
        (AQPB599FECH, AQPB599CONT, AQPB599BURO)
      values
        (pn_fechaApe, pn_cont, ve_buro);
    Exception
      when others then
        null;
    end;
    commit;
  end sp_cr_obtenerCont;

  procedure sp_cr_incremCont(pn_fechaApe in date,VE_BURO in number) is
  begin
    Begin
      update AQPB599
         set AQPB599CONT = AQPB599CONT + 1
       where AQPB599FECH = pn_fechaApe
         and AQPB599BURO = VE_BURO;
    Exception
      when others then
        null;
    end;
    commit;
  end sp_cr_incremCont;

  procedure sp_cr_insertarContad(VE_BURO IN NUMBER) is
    ld_fecIni date;
    ld_fecFin date;
    ld_fecape date;
    ln_contad numeric(10);
    ln_conaux number(5);
    BURO_DSC VARCHAR(30);
  begin
    select pgfape into ld_fecape from fst017 where pgcod = 1;
    ld_fecIni := TRUNC(ld_fecape, 'MM');
    ld_fecfin := TRUNC(LAST_DAY(ld_fecape));
  
     --IDENTIFICAR BURO
    BEGIN
      SELECT TRIM(TP1DESC)
      INTO BURO_DSC
      FROM FST198 
      WHERE TP1COD  = 1
        AND TP1COD1 = 11160
        AND TP1CORR1= 0
        AND TP1CORR2= 0
        AND TP1CORR3> 0
        AND TP1NRO1 = ve_buro;
    exception
      when others then
        null; 
    END;
    
    select count(*)
      into ln_conaux
      from AQPB599
     where AQPB599FECH = ld_fecape;
    if ln_conaux = 0 then
      --OBTENER CONTADOR BURO
      BEGIN
         pq_cr_cont_buro_hs.sp_obtener_contxburo(ve_buro,ld_fecIni,ld_fecfin,ln_contad); 
      END; 
      Begin
          insert into AQPB599
            (AQPB599FECH, AQPB599CONT, AQPB599BURO)
          values
            (ld_fecape, ln_contad, ve_buro);
            Exception
              when others then
                null;
      end;
    end if;
    commit;
  end sp_cr_insertarContad;
  procedure sp_obtener_contxburo(ve_buro      in number,
                                 ld_fecIni    in date,
                                 ld_fecfin    in date,
                                 ve_contador out number) is
  ld_fecape date;
  begin
       begin
            select pgfape into ld_fecape from fst017 where pgcod = 1;
       end;
       begin
              select a.aqpb599cont
              into ve_contador
              from aqpb599 a
              where a.aqpb599fech = ld_fecape
                and a.aqpb599buro = ve_buro;
       exception
         when others then
           ve_contador := 0;
       end;
       
       if ve_buro = 1 and ve_contador = 0 then
          begin
            select count(*)
              into ve_contador
              from jaql546
             where jaql546feenv >= ld_fecIni
               and jaql546feenv <= ld_fecfin
               and jaql546coerr = '00000';
          end;     
       end if;
       if ve_buro = 2 and ve_contador = 0 then
           begin
            select count(*)
              into ve_contador
              from jaqz236
             where jaqz236feenv >= ld_fecIni
               and jaqz236feenv <= ld_fecfin
               and jaqz236coerr = '00000';
          end; 
       end if;
       if ve_buro = 3 and ve_contador = 0 then
           begin
            select count(*)
              into ve_contador
              from aqpb515
             where aqpb515feenv >= ld_fecIni
               and aqpb515feenv <= ld_fecfin
               and aqpb515resmsg='OK';
          end;
       end if;  
  end;
  procedure sp_obtener_contxburo(ve_buro      in number,                                 
                                 ve_contador out number) is
  ld_fecape date;
  ld_fecIni date;
  ld_fecfin date;
  begin
       select pgfape into ld_fecape from fst017 where pgcod = 1;
       ld_fecIni := TRUNC(ld_fecape, 'MM');
       ld_fecfin := TRUNC(LAST_DAY(ld_fecape));
       --validar si existen consultas en el buro seleccionado.
       ve_contador := 0;
       begin
              select a.aqpb599cont
              into ve_contador
              from aqpb599 a
              where a.aqpb599fech = ld_fecape
                and a.aqpb599buro = ve_buro;
       exception
         when others then
           ve_contador := 0;
       end;
       
       if ve_buro = 1 and ve_contador = 0 then
          begin
            select count(*)
              into ve_contador
              from jaql546
             where jaql546feenv >= ld_fecIni
               and jaql546feenv <= ld_fecfin
               and jaql546coerr = '00000';
          end;     
       end if;
       if ve_buro = 2 and ve_contador = 0 then
           begin
            select count(*)
              into ve_contador
              from jaqz236
             where jaqz236feenv >= ld_fecIni
               and jaqz236feenv <= ld_fecfin
               and jaqz236coerr = '00000';
          end; 
       end if;
       if ve_buro = 3 and ve_contador = 0 then
           begin
            select count(*)
              into ve_contador
              from aqpb515
             where aqpb515feenv >= ld_fecIni
               and aqpb515feenv <= ld_fecfin
               and aqpb515resmsg='OK';
          end;
       end if;  
  end;                                   
end PQ_CR_CONT_BURO_HS;
/

