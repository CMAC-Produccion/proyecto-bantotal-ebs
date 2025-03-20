create or replace package pq_cr_cronog_pago_hs is

  -- Author  : HSUAREZ
  -- Created : 18/10/2021 20:58:24
  -- Purpose : paquete para crongorama de pagos
procedure sp_TotInt_DifPen(
                               vi_pgcod in number,
                               vi_paomod in number,
                               vi_paosuc in number,
                               vi_paomda in number,
                               vi_paopap in number,
                               vi_paocta in number,
                               vi_paooper in number,
                               vi_paosbop in number,
                               vi_paotope in number,
                               vi_program in varchar,
                               vi_rpta out number,
                               vo_err out number,
                               vo_msg out varchar                               
                             );

end pq_cr_cronog_pago_hs;
/

create or replace package body pq_cr_cronog_pago_hs is

   procedure sp_TotInt_DifPen(
                               vi_pgcod in number,
                               vi_paomod in number,
                               vi_paosuc in number,
                               vi_paomda in number,
                               vi_paopap in number,
                               vi_paocta in number,
                               vi_paooper in number,
                               vi_paosbop in number,
                               vi_paotope in number,
                               vi_program in varchar,
                               vi_rpta out number,
                               vo_err out number,
                               vo_msg out varchar                               
                             ) is
   vi_maxFechaPagoP date;
   vi_flag_fecPagP varchar(1);
   vi_flag_fecPagT varchar(1);
   vi_maxFechaPagoT date;
   vi_maxFechaPago date;
   vi_interes_dev number(17,2);
   begin
        --OBTENER MAXIMA FECHA DE PAGO TOTAL
        vi_flag_fecPagT := 'S';
        vi_flag_fecPagP := 'S';
        begin
          SELECT MAX(P.PPFPAG)
          INTO vi_maxFechaPagoT
          FROM FSD602 P
          WHERE P.PGCOD =  vi_pgcod 
            AND P.PPMOD =  vi_paomod
            AND P.PPSUC =  vi_paosuc
            AND P.PPMDA =  vi_paomda
            AND P.PPPAP =  vi_paopap
            AND P.PPCTA =  vi_paocta
            AND P.PPOPER=  vi_paooper
            AND P.PPSBOP=  vi_paosbop
            AND P.PPTOPE=  vi_paotope
            AND P.PP1STAT = 'T'
            AND P.D602CO = 'S';
        exception 
          when others then
            vi_maxFechaPagoT := null; 
            vi_flag_fecPagT := 'N';   
          end;
        --OBTENER MAXIMA FECHA DE PAGO PARCIAL
        Begin
          SELECT MAX(P.PPFPAG)
          INTO vi_maxFechaPagoP
          FROM FSD602 P
          WHERE P.PGCOD =  vi_pgcod 
            AND P.PPMOD =  vi_paomod
            AND P.PPSUC =  vi_paosuc
            AND P.PPMDA =  vi_paomda
            AND P.PPPAP =  vi_paopap
            AND P.PPCTA =  vi_paocta
            AND P.PPOPER=  vi_paooper
            AND P.PPSBOP=  vi_paosbop
            AND P.PPTOPE=  vi_paotope
            AND P.PP1STAT = 'P'
            AND P.D602CO = 'S';
        Exception
            when others then
              vi_maxFechaPagoP := null;
              vi_flag_fecPagP := 'N';
        End;  
        
        if vi_maxFechaPagoT is null then
           vi_maxFechaPagoT := to_date('01/01/1990','dd/mm/yyyy');
        end if;
        if vi_maxFechaPagoP is null then
           vi_maxFechaPagoP := to_date('01/01/1990','dd/mm/yyyy');
        end if;
        
        if vi_flag_fecPagP =  'S' or vi_flag_fecPagT =  'S' then
           if  vi_maxFechaPagoT > vi_maxFechaPagoP then
               vi_maxFechaPago := vi_maxFechaPagoT;
           else
               vi_maxFechaPago := vi_maxFechaPagop;
           end if;
        end if;  
        
        --OBTENER INTERES DEUDOR (CAPITAL NEGATIVO)
        BEGIN
          SELECT sum(D.PPCAP)
            INTO vi_interes_dev
            FROM FSD601 D
            WHERE D.PGCOD =  vi_pgcod 
              AND D.PPMOD =  vi_paomod
              AND D.PPSUC =  vi_paosuc
              AND D.PPMDA =  vi_paomda
              AND D.PPPAP =  vi_paopap
              AND D.PPCTA =  vi_paocta
              AND D.PPOPER=  vi_paooper
              AND D.PPSBOP=  vi_paosbop
              AND D.PPTOPE=  vi_paotope
              AND D.PPFPAG > vi_maxFechaPago
              AND D.PPICAP < 0
              AND D.D601CO= 'S'
              ;
        EXCEPTION
          WHEN OTHERS THEN
            vi_interes_dev :=0;      
        END;
        
        vi_rpta:= vi_interes_dev; 
   end;
     
end pq_cr_cronog_pago_hs;
/

