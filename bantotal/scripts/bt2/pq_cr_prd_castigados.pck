create or replace package PQ_CR_PRD_CASTIGADOS is

  -- Author  : EFUENTES
  -- Created : 13/12/2021 17:50:45
  -- Versión : 1.0
  -- ****************************************************************

  --** obtener clave del credito de castigo
  procedure sp_cr_ClaveCrd_Castigos(pn_pgcodt  in number,
                                    pn_suct    in number,
                                    pn_modt    in number,
                                    pn_trant   in number,
                                    pn_itnrelt in number,
                                    pn_itfcon  in date,
                                    pn_fagC    out varchar2,
                                    pn_pgcodC  out number,
                                    pn_modulo  out number,
                                    pn_tipope  out number,
                                    pn_sucur   out number,
                                    pn_moneda  out number,
                                    pn_papel   out number,
                                    pn_ctnro   out number,
                                    pn_oper    out number,
                                    pn_subope  out number);
end PQ_CR_PRD_CASTIGADOS;
/

create or replace package body PQ_CR_PRD_CASTIGADOS is

  procedure sp_cr_ClaveCrd_Castigos(pn_pgcodt  in number,
                                    pn_suct    in number,
                                    pn_modt    in number,
                                    pn_trant    in number,
                                    pn_itnrelt in number,
                                    pn_itfcon  in date,
                                    pn_fagC    out varchar2,
                                    pn_pgcodC  out number,
                                    pn_modulo  out number,
                                    pn_tipope  out number,
                                    pn_sucur   out number,
                                    pn_moneda  out number,
                                    pn_papel   out number,
                                    pn_ctnro   out number,
                                    pn_oper    out number,
                                    pn_subope  out number) is
    my_errm VARCHAR2(32000);
    lv_msgerr VARCHAR2(500);

    ln_cont   NUMBER;
  
    CURSOR LST_ORDINALES(PN_MODULO IN NUMBER, PN_TRANSA IN NUMBER) IS
      select TO_NUMBER(tpimp) ORDINAL
        from fst098
       where pgcod = 1
         and tpcod = 7750
         and tpcorr >= 51
         and tpcorr <= 90
         and tpnro = PN_MODULO
         and TO_NUMBER(TRIM(tpdesc)) = PN_TRANSA;
  
    ln_Ordinal NUMBER;
    
  
  BEGIN
  
    begin
      select COUNT(tpimp)
        into ln_cont
        from fst098
       where pgcod = 1
         and tpcod = 7750
         and tpcorr >= 51
         and tpcorr <= 90
         and tpnro = pn_modt
         and TO_NUMBER(TRIM(tpdesc)) = pn_trant;
    EXCEPTION
      WHEN OTHERS THEN
        ln_cont := 0;
    END;
  
    --** obtenermos la clave del credito
    if ln_cont > 0 then
      FOR i IN LST_ORDINALES(pn_modt, pn_trant) LOOP
        pn_fagC    := 'N';
        ln_Ordinal := i.ORDINAL;
      
        --obtener clave del credito
        begin
          SELECT B.PGCOD,
                 B.MODULO,
                 B.ITTOPE,
                 B.ITSUCD,
                 B.MONEDA,
                 B.PAPEL,
                 B.CTNRO,
                 B.ITOPER,
                 B.ITSUBO
            INTO pn_pgcodC,
                 pn_modulo,
                 pn_tipope,
                 pn_sucur,
                 pn_moneda,
                 pn_papel,
                 pn_ctnro,
                 pn_oper,
                 pn_subope
            FROM FSD016 B
           WHERE B.PGCOD = pn_pgcodt
             AND B.ITSUC = pn_suct
             AND B.ITMOD = pn_modt
             AND B.ITTRAN = pn_trant
             AND B.ITNREL = pn_itnrelt
             --AND B.ITFVAL = pn_itfcon
             AND B.ITORD = ln_Ordinal;
        
          pn_fagC := 'S';
        EXCEPTION
          when others then
            lv_msgerr := 'Error en clave de credito';
            my_errm   := SQLERRM;
            DBMS_OUTPUT.put_line(my_errm);
        end;
      
        EXIT WHEN pn_fagC = 'S';
      END LOOP;
    
    else
      pn_fagC    := 'N';    
      --obtener clave del credito
      begin
        SELECT B.PGCOD,
               B.MODULO,
               B.ITTOPE,
               B.ITSUCD,
               B.MONEDA,
               B.PAPEL,
               B.CTNRO,
               B.ITOPER,
               B.ITSUBO
          INTO pn_pgcodC,
               pn_modulo,
               pn_tipope,
               pn_sucur,
               pn_moneda,
               pn_papel,
               pn_ctnro,
               pn_oper,
               pn_subope
          FROM FSD016 B
         WHERE B.PGCOD = pn_pgcodt
           AND B.ITSUC = pn_suct
           AND B.ITMOD = pn_modt
           AND B.ITTRAN = pn_trant
           AND B.ITNREL = pn_itnrelt
           AND B.ITFVAL = pn_itfcon
           AND B.ITORD = 10;
      
        pn_fagC := 'S';
      EXCEPTION
        when others then
          lv_msgerr := 'Error en clave de credito';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
          DBMS_OUTPUT.put_line(lv_msgerr);          
      end;
    
    end if;
  
  END sp_cr_ClaveCrd_Castigos;

end PQ_CR_PRD_CASTIGADOS;
/

