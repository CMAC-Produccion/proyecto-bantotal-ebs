create or replace procedure SP_AH_REP_SALDOSCARTERA(P_EJECUTIVO IN VARCHAR2,
                                                    P_USUARIO   IN VARCHAR2)is

   CURSOR DATOS IS
   select * 
     from jaql061
    where JAQL61PGCO = 1
      AND JAQL61USER = RPAD(P_EJECUTIVO,10,' ')
      AND JAQL61ESTA = 'S';
   
   CURSOR CUENTAS(PAIS IN NUMBER, TIPDOC IN NUMBER, doc IN char) IS
   SELECT b.scsuc sucursal,
           b.scrub rubro,
           b.scmda moneda,
           b.sccta cuenta,
           b.scoper operacion,
           B.SCSBOP suboperacion,
           b.sctope tope,
           b.scmod modulo,
           b.scsdo saldo
      FROM FSR008 A,
           FSD011 B
     WHERE A.PEPAIS = PAIS
       AND A.PETDOC= TIPDOC
       AND A.PENDOC =  doc
       AND A.CTTFIR = 'T'
       AND B.PGCOD = A.PGCOD
       AND B.SCCTA = A.CTNRO
       AND B.SCMOD IN (21,22)
       and b.scstat <> 99;  
       
SALDO NUMBER(18,2):=0; 
SALDO_TOTAL NUMBER(18,2);      
FECHA       DATE;
FECHA1      DATE;
Nombre      char(30);
Rrrubr number;
Capcts number;
Intcts number;
Bcfech date;
Totaho number;
Capaho number;
Intaho number;  
vscsdo NUMBER;
Hoy    date;

begin
  
  Delete jaqy697 where jaqy697user = rpad(p_usuario,10,' ');
  commit;
--  SELECT PGFAPE INTO FECHA FROM FST017 WHERE PGCOD = 1; 
   fecha := to_date('01/07/2016','dd/mm/yyyy');----pruebas
   Hoy := fecha; 
   FOR REG IN DATOS LOOP     
     SALDO_TOTAL := 0;
     Rrrubr := 0;
     Capcts := 0;
     Intcts := 0;
     Totaho := 0;
     Capaho := 0;
     Intaho := 0;
     vscsdo := 0;
     FOR DAT IN CUENTAS (REG.JAQL61PAIS, REG.JAQL61TDOC, REG.JAQL61NDOC) LOOP
                                   
        case
          when DAT.MODULO = 22 then
            begin
              select scsdo
                into vscsdo
                from fsd011
               where pgcod = 1
                 and scsuc = DAT.SUCURSAL
                 and scrub = DAT.RUBRO
                 and scmda = DAT.MONEDA
                 and scpap = 0
                 and sccta = DAT.CUENTA
                 and scoper = DAT.OPERACION
                 and scsbop = DAT.SUBOPERACION
                 and sctope = DAT.TOPE;
            exception
              when no_data_found then
                vscsdo := 0;
            end;
            saldo_total := SALDO_TOTAL + vscsdo;
          when DAT.TOPE = 2 then
            --cap intangible
            Capcts := 0; 
            Intcts := 0;
            begin
              select Rrrubr
                into Rrrubr
                from FSR014
               Where Rubro = DAT.RUBRO
                 and Rrcod = 169;
            exception
              when no_data_found then
                Rrrubr := 0;
            end;
          
            begin
              select case
                       when Scsdo < 0 then
                        Scsdo * (-1)
                       else
                        Scsdo
                     end case
                into Capcts
                from FSD011
               Where Pgcod = 1
                 and Scsuc = DAT.SUCURSAL
                 and Scrub = Rrrubr
                 and Sccta = DAT.CUENTA
                 and Scmda = DAT.MONEDA
                 and Scpap = 0
                 and Scoper = DAT.OPERACION
                 and Scsbop = DAT.SUBOPERACION;
            exception
              when no_data_found then
                Capcts := 0;
            end;
            --int intangible
            begin
              select Rrrubr
                into Rrrubr
                from FSR014
               Where Rubro = DAT.RUBRO
                 and Rrcod = 1;
            exception
              when no_data_found then
                Rrrubr := 0;
            end;
            begin
              select case
                       when Scsdo < 0 then
                        Scsdo * (-1)
                       else
                        Scsdo
                     end case
                into Intcts
                from FSD011
               Where Pgcod = 1
                 and Scsuc = DAT.SUCURSAL
                 and Scrub = Rrrubr
                 and Sccta = DAT.CUENTA
                 and Scmda = DAT.MONEDA
                 and Scpap = 0
                 and Scoper = DAT.OPERACION
                 and Scsbop = DAT.SUBOPERACION;
            exception
              when no_data_found then
                Intcts := 0;
            end;
            VScsdo := Capcts + Intcts;
            saldo_total := SALDO_TOTAL + vscsdo;
          else              
             
--            Bcfech := Hoy - 1 ;
            FECHA1 := FECHA -1;
            Capaho := 0;
            Intaho := 0;
            begin
--              BCEMP, BCSUC, BCRUBR, BCMDA, BCPAP, BCCTA, BCOPER, BCSBOP, BCTOP, BCFECH
              select sum(BCSdMO), count(*)
                into Capaho, Totaho
                from FSH012
               Where BCEmp = 1
                 and BCSuc = DAT.SUCURSAL
                 and BCRubr = DAT.RUBRO
                 and BCMda = DAT.MONEDA
                 and BCPap = 0
                 and BCCta = DAT.CUENTA
                 and BCOper = DAT.OPERACION
                 and BCSbOp = DAT.SUBOPERACION
                 and BCTOp = DAT.TOPE
                 and BCFech = FECHA1; ---BCFECH; ----between Bcfech and Hoy;            
            end;
          
            If Capaho IS NULL THEN
              Capaho := 0;
        /*    ELSE
              Capaho := Capaho / Totaho;*/
            End If;      
            Totaho := 0;
            begin
              select Rrrubr
                into Rrrubr
                from FSR014
               Where Rubro = DAT.RUBRO
                 and Rrcod = 1;
            exception
              when no_data_found then
                Rrrubr := 0;
            end;
          
            begin
              select  sum(BCSdMO), count(*)
                into Intaho, Totaho
                from FSH012
               Where BCEmp = 1
                 and BCSuc = DAT.SUCURSAL
                 and BCRubr = Rrrubr
                 and BCMda = DAT.MONEDA
                 and BCPap = 0
                 and BCCta = DAT.CUENTA
                 and BCOper = DAT.OPERACION
                 and BCSbOp = DAT.SUBOPERACION                
                 and BCTOp = DAT.TOPE
                 and BCFech = FECHA1; --- BCFECH;-----BCFech between Bcfech and Hoy;
            end;
            If Intaho IS NULL then
              Intaho := 0;
          /*  Else
              Intaho := Intaho / Totaho;*/
            End If;
          
            VScsdo := Capaho + Intaho;
            saldo_total := SALDO_TOTAL + vscsdo;
        end case;    
        
     END LOOP; 
     begin
     select penom
       into Nombre
       from fsd001      
      where pepais = reg.jaql61pais
        and petdoc = reg.jaql61tdoc
        and pendoc = reg.jaql61ndoc;
     exception
       when no_data_found then
         null;
     end;   
     bEGIN   
       insert into jaqy697(jaqy697pais,
                           jaqy697tdoc,
                           jaqy697ndoc,
                           jaqy697nomb,
                           jaqy697sali,
                           jaqy697sala,
                           jaqy697tot,
                           jaqy697user,
                           jaqy697date)
                    VALUES(reg.jaql61pais,
                           reg.jaql61tdoc,
                           reg.jaql61ndoc,
                           Nombre,
                           reg.jaql61au03,
                           SALDO_TOTAL,
                           (reg.jaql61au03- SALDO_TOTAL),
                           P_USUARIO,
                           FECHA);
       COMMIT;                    
       EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
           NULL;
       END;
   END LOOP;




end SP_AH_REP_SALDOSCARTERA;
/

