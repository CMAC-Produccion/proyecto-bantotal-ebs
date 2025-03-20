create or replace package PQ_CR_VALIDAR_VINC_HS is

  -- Author  : HSUAREZ
  -- Created : 31/08/2022 10:40:32
  -- Purpose : Paquete para validar vinculacion si es N no deshabilita si es S deshabilita
  
  PROCEDURE SP_DESHABILITAR_VINCULO( ve_instancia number,
                                      ve_instancia2 number,
                                      ve_msg out varchar,
                                      ve_rpta out varchar
                                      );
  PROCEDURE sp_validar_vinculos(VE_INSTANCIA number);
end PQ_CR_VALIDAR_VINC_HS;
/

create or replace package body PQ_CR_VALIDAR_VINC_HS is

    PROCEDURE SP_DESHABILITAR_VINCULO( ve_instancia number,
                                      ve_instancia2 number,
                                      ve_msg out varchar,
                                      ve_rpta out varchar
                                      ) IS
                                      
                                      
    vi_pgcod xwf700.xwfempresa%type;
    vi_aomod xwf700.xwfmodulo%type;
    vi_aosuc xwf700.xwfsucursal%type;
    vi_aomda xwf700.xwfmoneda%type;
    vi_aopap xwf700.xwfpapel%type;
    vi_aocta xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
    VI_EXCEPTUAR NUMBER;
    BEGIN
      BEGIN
          select xwfempresa,
                     xwfmodulo,
                     xwfsucursal,
                     xwfmoneda,
                     xwfpapel,
                     xwfcuenta,
                     xwfoperacion,
                     xwfsubope,
                     xwftipope
                into vi_pgcod,
                     vi_aomod,
                     vi_aosuc,
                     vi_aomda,
                     vi_aopap,
                     vi_aocta,
                     vi_aooper,
                     vi_aosbop,
                     vi_aotope     
              from xwf700
              where xwfprcins= ve_instancia2
                and xwfcar3 = '1';
          exception
            when others then
              nulL;
      END;
      BEGIN
        SELECT TP1NRO1
        INTO VI_EXCEPTUAR
        FROM FST198
        WHERE TP1COD = 1
        AND TP1COD1  = 10899
        AND TP1CORR1 = 50
        AND TP1CORR2 = 3
        AND TP1CORR3 = 1;
      EXCEPTION
        WHEN OTHERS THEN
            VI_EXCEPTUAR := 0;    
      END;
      ve_rpta := 'N';
      IF VI_EXCEPTUAR = 1 THEN        
         ve_rpta := 'S'; --SI ESTA EN S NO VALIDA.
      ELSE
         ve_rpta := 'N'; --SI ESTA EN S NO VALIDA.
      END IF;
      
      BEGIN
        SELECT COUNT(*) INTO VI_EXCEPTUAR FROM AQPB299 WHERE AQPB299CTA=vi_aocta  AND AQPB299OPER=vi_aooper;
      EXCEPTION
        WHEN OTHERS THEN
            VI_EXCEPTUAR:= 0;
      END;    
      IF VI_EXCEPTUAR >= 1 THEN
         ve_rpta := 'S'; --SI ESTA EN S NO VALIDA.
         pq_cr_validar_vinc_hs.sp_validar_vinculos(ve_instancia);
      END IF;    
      
    END;
    PROCEDURE sp_validar_vinculos(VE_INSTANCIA number) is
    VI_EXCEPTUAR number(9);
    cursor lista_creditos_vinculo is
    SELECT  *  FROM jaqy800 where jaqy800ins = VE_INSTANCIA;
    begin
         for x in lista_creditos_vinculo loop
             begin
               SELECT COUNT(*) INTO VI_EXCEPTUAR FROM AQPB299 WHERE AQPB299CTA=x.jaqy800cta  AND AQPB299OPER=x.jaqy800ope;
             exception
               when others then
                 VI_EXCEPTUAR := 0;
             end;  
             if vi_exceptuar = 0 then
                begin
                   update jaqy800 
                   set jaqy800vinc='N'
                   where jaqy800ins  = VE_INSTANCIA                     
                     and jaqy800cta  = x.jaqy800cta
                     and jaqy800ope  = x.jaqy800ope
                     and jaqy800sbop = x.jaqy800sbop
                     and jaqy800tope= x.jaqy800tope
                     and jaqy800ins2 = x.jaqy800ins2
                     and jaqy800vinc = 'S';
                exception
                  when others then
                    null;
                end; 
             end if;
         end loop;
    end;

end PQ_CR_VALIDAR_VINC_HS;
/

