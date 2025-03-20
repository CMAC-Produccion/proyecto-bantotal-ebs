create or replace package PQ_CR_CRED_REPROGSC is

  -- Author  : HSUAREZ
  -- Created : 6/02/2021 14:27:51
  -- Purpose : Paqute par areprogramacion de creditos si ncapitalizacion
  procedure SP_CALC_DIF_DIA(ve_instancia in number, vo_dias out number);

end PQ_CR_CRED_REPROGSC;
/

create or replace package body PQ_CR_CRED_REPROGSC is
 procedure SP_CALC_DIF_DIA(ve_instancia in number, vo_dias out number) is
   vi_pgcod   fsd010.pgcod%type;
   vi_susurs  fsd010.aosuc%type;
   vi_aomod   fsd010.aomod%type;
   vi_mda     fsd010.aomda%type;
   vi_aopap   fsd010.aopap%type;
   vi_cta     fsd010.aocta%type;
   vi_aooper  fsd010.aooper%type;
   vi_aosbop  fsd010.aosbop%type;
   vi_aotope  fsd010.aotope%type;
   
   VI_FEC DATE;
   vi_fec_original date;   
   vi_fec_nuevo    date;
   
   estado_pag varchar(1);
   begin
           --OBTENER LA CLAVE DEL CREDITO
           BEGIN
             SELECT 
                    X.XWFEMPRESA,X.XWFSUCURSAL,X.XWFMODULO,X.XWFMONEDA,X.XWFPAPEL,X.XWFCUENTA,X.XWFOPERACION,X.XWFSUBOPE,X.XWFTIPOPE
             INTO   vi_pgcod,vi_susurs,vi_aomod,vi_mda,vi_aopap,vi_cta,vi_aooper,vi_aosbop,vi_aotope
             FROM XWF700 X
             WHERE X.XWFPRCINS = ve_instancia
               AND X.XWFCAR3 = '1'
               and rownum=1;
           EXCEPTION 
             WHEN OTHERS THEN
               NULL;    
             END;
           --OBTENER LA ULTIMA FECHA DE PAGO DEL CREDITO.
/*           BEGIN
           SELECT MAX(D2.PPFPAG)--,D2.PP1STAT 
             INTO vi_fec_original--,estado_pag
             FROM FSD601 D1 INNER JOIN FSD602 D2  ON D1.PPCTA=D2.PPCTA AND D1.PPOPER=D2.PPOPER AND D1.PPSBOP=D2.PPSBOP AND D1.PPFPAG=D2.PPFPAG
            WHERE D1.PGCOD = vi_pgcod
              AND D1.PPMOD = vi_susurs
              AND D1.PPSUC = vi_aomod
              AND D1.PPMDA = vi_mda
              AND D1.PPPAP = vi_aopap
              AND D1.PPCTA = vi_cta
              AND D1.PPOPER = vi_aooper
              AND D1.PPSBOP = vi_aosbop
              AND D1.PPTOPE = vi_aotope
              AND D1.D601CO='S';
             EXCEPTION
               WHEN OTHERS THEN
                 NULL;        
             END;        

           END;
           
           BEGIN
           SELECT max(D2.PP1STAT) 
             INTO estado_pag
             FROM FSD601 D1 INNER JOIN FSD602 D2  ON D1.PPCTA=D2.PPCTA AND D1.PPOPER=D2.PPOPER AND D1.PPSBOP=D2.PPSBOP AND D1.PPFPAG=D2.PPFPAG
            WHERE D1.PGCOD = vi_pgcod
              AND D1.PPMOD = vi_susurs
              AND D1.PPSUC = vi_aomod
              AND D1.PPMDA = vi_mda
              AND D1.PPPAP = vi_aopap
              AND D1.PPCTA = vi_cta
              AND D1.PPOPER = vi_aooper
              AND D1.PPSBOP = vi_aosbop
              AND D1.PPTOPE = vi_aotope
              AND D1.D601CO='S'
              AND D1.PPFPAG = vi_fec_original;
           exception when others then
             estado_pag := null;
           END;
*/

      BEGIN
        select max(ppfpag)
          into vi_fec_original
          from fsd602 f
         where f.pgcod = vi_pgcod
           and f.ppmod = vi_aomod
           and f.ppsuc = vi_susurs
           and f.ppmda = vi_mda
           and f.pppap = vi_aopap
           and f.ppcta = vi_cta
           and f.ppoper = vi_aooper
           and f.ppsbop = vi_aosbop
           and f.pptope = vi_aotope
           and D602CO = 'S';
      exception
        when others then
          null;
      END;
      if vi_fec_original IS NULL THEN
        BEGIN
          select min(ppfpag)
            into vi_fec_original
            from fsd601 f
           where f.pgcod = vi_pgcod
             and f.ppmod = vi_aomod
             and f.ppsuc = vi_susurs
             and f.ppmda = vi_mda
             and f.pppap = vi_aopap
             and f.ppcta = vi_cta
             and f.ppoper = vi_aooper
             and f.ppsbop = vi_aosbop
             and f.pptope = vi_aotope;
        END;
      END IF;
      begin
        select max(f602.pp1stat) --, ppfpag
          into estado_pag
          from fsd602 f602
         where f602.pgcod =  vi_pgcod
           and f602.ppmod =  vi_aomod
           and f602.ppsuc =  vi_susurs
           and f602.ppmda =  vi_mda
           and f602.pppap =  vi_aopap
           and f602.ppcta =  vi_cta
           and f602.ppoper = vi_aooper
           and f602.ppsbop = vi_aosbop
           and f602.pptope = vi_aotope
           and f602.ppfpag = vi_fec_original
           and D602CO = 'S';
      exception
        when others then
          NULL;
      end;     
      

           --DETERMINAR SI IMPAGA O PAGADA  
           IF estado_pag = 'P' or estado_pag is null THEN
             BEGIN
              SELECT MAX(D1.PPFVAL)
                INTO VI_FEC 
                   FROM FSD601 D1
                   WHERE D1.PGCOD =  vi_pgcod
                     AND D1.PPMOD =  vi_aomod
                     AND D1.PPSUC =  vi_susurs 
                     AND D1.PPMDA =  vi_mda
                     AND D1.PPPAP =  vi_aopap
                     AND D1.PPCTA =  vi_cta
                     AND D1.PPOPER = vi_aooper
                     AND D1.PPSBOP = vi_aosbop
                     AND D1.PPTOPE = vi_aotope
                     AND D1.D601CO='S'
                     AND D1.PPFPAG=vi_fec_original;
             EXCEPTION
               WHEN OTHERS THEN
                 NULL;        
             END;        
           ELSIF estado_pag = 'T' THEN
             --OBTENER LA FECHA DE LA SIGUIENTE CUOTA PENDIENTE DE PAGO
             BEGIN
                   SELECT MIN(D1.PPFVAL)
                   INTO VI_FEC
                   FROM FSD601 D1
                   WHERE D1.PGCOD = vi_pgcod
                     AND D1.PPMOD = vi_aomod 
                     AND D1.PPSUC = vi_susurs
                     AND D1.PPMDA = vi_mda
                     AND D1.PPPAP = vi_aopap
                     AND D1.PPCTA = vi_cta
                     AND D1.PPOPER = vi_aooper
                     AND D1.PPSBOP = vi_aosbop
                     AND D1.PPTOPE = vi_aotope
                     AND D1.D601CO='S'
                     AND D1.PPFPAG>vi_fec_original;
             EXCEPTION
               WHEN OTHERS THEN
                 NULL;  
               END;  
           END IF;
           --FECHA VECIMIENTO NUEVO CRONGORAMA
           BEGIN
                 SELECT min(D1.PPFPAG)--MIN(D1.PPFVTO)SE HA COMENTADO CONSIDERANDO LO DE RAQUEL.
                   INTO vi_fec_nuevo
                   FROM FSD601 D1
                   WHERE D1.PGCOD = vi_pgcod
                     AND D1.PPMOD = vi_aomod
                     AND D1.PPSUC = vi_susurs
                     AND D1.PPMDA = vi_mda
                     AND D1.PPPAP = vi_aopap
                     AND D1.PPCTA = vi_cta
                     AND D1.PPOPER = vi_aooper
                     AND D1.PPSBOP = 609
                     AND D1.PPTOPE = vi_aotope
                     AND D1.D601CO='X';
                     --AND D1.PPFPAG>=vi_fec_original; 
         EXCEPTION
           WHEN OTHERS THEN
             NULL;               
             END;
        ---RESTAR DIAS
        BEGIN
          SELECT PGFAPE
          INTO VI_FEC 
          FROM FST017 WHERE PGCOD=1
          AND ROWNUM=1;
          END;
        BEGIN
          SELECT vi_fec_nuevo - VI_FEC 
          INTO vo_dias
          FROM DUAL;
        EXCEPTION 
          WHEN OTHERS THEN
               vo_dias:= 0;  
          END;
        IF vo_dias is null THEN
           vo_dias := 0;
        END IF; 
     end;
end PQ_CR_CRED_REPROGSC;
/

