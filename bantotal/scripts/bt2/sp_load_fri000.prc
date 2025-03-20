CREATE OR REPLACE PROCEDURE SP_LOAD_FRI000
is
    CURSOR c_fri105 is
      SELECT * FROM fri105 where RI105CTA != 999999999;
    
    TYPE t_fri105 is TABLE of c_fri105%ROWTYPE index by PLS_INTEGER;
    l_fri105 t_fri105;
    
    l_fri000 fri000%ROWTYPE;

    l_asesor VARCHAR2(20);
    l_sal430 NUMBER(17,2);
    l_sal14  NUMBER(17,2);
    l_corr   PLS_INTEGER := 0;
    l_inst   NUMBER(10) := 0;    
    l_annio  PLS_INTEGER := 0;    
begin 
    
    -- Limpiamos         
    DELETE FROM fri000 WHERE ri000usu = 'GLOBAL' and ri000est = 'GLOBAL' and ri000inf = 'RPTCARTERAFRI105';
    
    -- Obtenemos Annio
    SELECT EXTRACT(YEAR FROM pgfape) INTO l_annio
    FROM FST017
    WHERE PGCOD = 1;

    OPEN c_fri105;
    LOOP
      FETCH c_fri105
      BULK COLLECT INTO l_fri105 LIMIT 1000;
      EXIT WHEN l_fri105.count = 0;
      
      FOR i in l_fri105.FIRST .. l_fri105.LAST LOOP
          l_corr := l_corr + 1;

          l_inst := 0;
          FOR a in (SELECT * FROM xwf700 WHERE XWfEmpresa   = l_fri105(i).ri105cod and
                                	      XWfSucursal  = l_fri105(i).ri105suc and
                                	      XWfModulo    = DECODE(l_fri105(i).ri105mod, 116, 117, l_fri105(i).ri105mod) and 
                                	      XWfMoneda    = l_fri105(i).ri105mda and
                                	      XWfPapel     = l_fri105(i).ri105pap and
                                	      XWfCuenta    = l_fri105(i).ri105cta and
                                	      XWfOperacion = l_fri105(i).ri105oper and
                                	      XWfSubope    = l_fri105(i).ri105sbop and
                                	      XWfTipOpe    = l_fri105(i).ri105tope) LOOP
          
              If a.XWFCar3 = '1' Then
            		l_inst := a.XWFPRCINS;
            		Exit;
            	Else
            		If a.XWFCar3 is null Or a.XWFCar3 = 'A' Then
            			l_inst := a.XWFPRCINS;
            		End If;
            	End If;
          END LOOP;
          
          begin
              SELECT SNG001Ase into l_asesor
              FROM SNG001
              WHERE SNG001Inst = l_inst;
          exception
              when no_data_found then
                   l_asesor := '';
          end;          
          
          -- Obtenemos Relacion 430
          begin
              SELECT scsdo into l_sal430
              FROM FSD011 
              WHERE pgcod = l_fri105(i).ri105cod and
                    sccta = l_fri105(i).ri105cta and
                    scoper = l_fri105(i).ri105oper and
                    scsbop = l_fri105(i).ri105sbop and
                    scrub = (select rrrubr from fsr014 where rubro = l_fri105(i).ri105rub and rrcod = 430);
          exception
              when no_data_found then
                  l_sal430 := 0;
          end;          
          
          -- Obtenemos Saldo FSH014 (Actual)
          begin
              SELECT hasd13 into l_sal14
              FROM FSH014 
              WHERE pgcod   = l_fri105(i).ri105cod  and
                    hasuc   = l_fri105(i).ri105suc  and
                    harub   = l_fri105(i).ri105rub  and
                    hamda   = l_fri105(i).ri105mda  and
                    hapap   = l_fri105(i).ri105pap  and
                    hacta   = l_fri105(i).ri105cta  and
                    haoper  = l_fri105(i).ri105oper and
                    hasbop  = l_fri105(i).ri105sbop and
                    hatope  = l_fri105(i).ri105tope and
                    haanio  = l_annio;
          exception
              when no_data_found then
                  l_sal14 := 0;
          end; 
          
          -- Grabamos FRI000
          l_fri000.ri000usu   := 'GLOBAL';
          l_fri000.ri000est   := 'GLOBAL';
          l_fri000.ri000inf   := 'RPTCARTERAFRI105';
          l_fri000.ri000id1   := 6;
          l_fri000.ri000id2   := 6;
          l_fri000.ri000id3   := 6;
          l_fri000.ri000id4   := l_corr;
          l_fri000.ri000emp   := l_fri105(i).ri105cod;
          l_fri000.ri000suc   := l_fri105(i).ri105suc;
          l_fri000.ri000rub   := l_fri105(i).ri105rub;
          l_fri000.ri000mod   := l_fri105(i).ri105mod;
          l_fri000.ri000mda   := l_fri105(i).ri105mda;
          l_fri000.ri000pap   := l_fri105(i).ri105pap;
          l_fri000.ri000cta   := l_fri105(i).ri105cta;
          l_fri000.ri000oper  := l_fri105(i).ri105oper;
          l_fri000.ri000sbop  := l_fri105(i).ri105sbop;
          l_fri000.ri000tope  := l_fri105(i).ri105tope;
          l_fri000.ri000imp01 := l_fri105(i).ri105imp;
          l_fri000.ri000imp02 := l_fri105(i).ri105saldo;
          l_fri000.ri000imp03 := l_fri105(i).ri105prev;
          l_fri000.ri000imp04 := l_fri105(i).ri105aux1;
--          l_fri000.ri000imp05 := l_fri105(i).ri105aux5;
          l_fri000.ri000imp06 := l_sal430;
          l_fri000.ri000imp07 := ABS(l_sal14);
          l_fri000.ri000tas01 := l_fri105(i).ri105coef;
          l_fri000.ri000num01 := l_fri105(i).ri105cat;
          l_fri000.ri000num02 := l_fri105(i).ri105tipo;
          l_fri000.ri000num03 := l_fri105(i).ri105aux2;
          l_fri000.ri000fec01 := l_fri105(i).ri105aux7;
          l_fri000.ri000txt01 := l_asesor;
          
          INSERT INTO FRI000
          VALUES l_fri000;
      END LOOP;
      COMMIT;
    END LOOP;
    CLOSE c_fri105;    
end;
/

