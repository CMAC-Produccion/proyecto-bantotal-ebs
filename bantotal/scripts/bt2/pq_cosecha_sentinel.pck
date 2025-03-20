CREATE OR REPLACE PACKAGE pq_cosecha_sentinel is
  -- *****************************************************************
  -- Nombre                       : pq_venta
  -- Sistema                      : SORFY
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 18/05/2007
  -- Autor de Creación            : yyampi
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  -- Descripción de Modificación  : 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  
 /* procedure SP_CR_INSTANCIA(F_FEC VARCHAR , C_EST VARCHAR
                                    ) ;

   FUNCTION SP_CR_PREN_RUBRO(CTA NUMBER , OPE NUMBER, per varchar 
                                    ) RETURN NUMBER;     

   PROCEDURE SP_CR_AMP_SBS(CTA NUMBER , OPE NUMBER, per varchar , RUB out number, SBS out varchar 
                                    );   
                                    
   FUNCTION FN_CR_AMP_SBS(CTA NUMBER , OPE NUMBER, per varchar , opcion number    
                                    ) RETURN VARCHAR ;                                                                                                     
                                    
   FUNCTION SP_CR_PREN_SBS(CTA NUMBER , OPE NUMBER, per varchar 
                                    ) RETURN VARCHAR;        
                                    
   FUNCTION SP_CR_AMP_SDOMN(CTA NUMBER , OPE NUMBER, per varchar   
                                    ) RETURN NUMBER;
                                       
   procedure SP_CR_DESEMBOLSO_PREN(F_FEC VARCHAR
                                    );    
                                    
   procedure SP_CR_DESEMBOLSO_AMP(F_FEC VARCHAR
                                    );

   procedure SP_CR_DESEMBOLSO_AMP_TOT(F_FEC VARCHAR
                                    );                                                               
                                    
   procedure SP_CR_DESEMBOLSO_AMP_TRANS(F_FEC VARCHAR
                                    ) ;                                                                                                                                                                                                         


   FUNCTION  FN_CR_IMP_DESEM( PGCOD NUMBER,   MODU NUMBER,  SUC NUMBER,   MDA NUMBER,  PAP NUMBER,
  CTA NUMBER,  OPER NUMBER,   SBOP NUMBER,   TOPE NUMBER 
                                   ) RETURN NUMBER ;   
                                   
   procedure SP_CR_DESEMBOLSO_IMP(F_FEC VARCHAR
                                    );
                                    
   
   
   procedure SP_CR_ACT_SALDOS_AMP(F_FEC VARCHAR
                                    );     
                                    
   procedure SP_CR_ACT_SALDOS_AMP2(F_FEC VARCHAR
                                    );     
                                    
   
procedure SP_CR_DESEMBOLSO_NORMAL(F_FEC VARCHAR
                                    );   
                                    
procedure SP_CR_ACT_ASESOR(F_FEC VARCHAR
                                    );
                                    

procedure SP_CR_ACT_SALDOS_AMP3(F_FEC VARCHAR
                                    );*/
                                    
function fn_tipo_cambio_fijo(P_FECHA in date) return number;                                     
                                    


function FN_REGION_HIST(P_FECHA in date, P_SUCUR IN NUMBER) return varchar ;

function FN_COD_REGION_HIST(P_FECHA in date, P_SUCUR IN NUMBER) return number;  

procedure SP_CR_CARGA_INICIAL(F_FEC date );
procedure SP_CR_CARGA_HILOS ;     

procedure SP_CR_ACTUALIZA_DIMENSIONES(F_FEC in varchar);

function FN_AGENCIA_HIST( P_SUCUR IN NUMBER) return varchar ;  

PROCEDURE GENERA_REPORTE_DESEM( F_FEC VARCHAR ) ;    

procedure SP_CR_REP_DESEM_HILOS( F_FEC VARCHAR );

procedure SP_CR_ACT_DIMEN_HILOS( F_FEC VARCHAR );  

procedure SP_CR_CARGA_INICIAL_HILOS( F_FEC IN VARCHAR ); 

function FN_CR_DEPURA( C_CADENA IN VARCHAR ) RETURN VARCHAR;     
  
function FN_CR_ZONA_ACTUAL( N_SUCURSAL IN NUMBER ) RETURN VARCHAR; 
                 
function FN_Nom_CAMPANA( COD_CAM IN varchar2) return varchar2; 

function FN_Sec_CAMPANA( COD_CAM IN varchar2) return varchar2; 

PROCEDURE FN_InsertaCampana(resul out varchar2 );
                                                                                                                       
end pq_cosecha_sentinel;
/

CREATE OR REPLACE PACKAGE BODY pq_cosecha_sentinel is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/*  procedure SP_CR_INSTANCIA(F_FEC VARCHAR , C_EST VARCHAR
                                    ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  cursor mes is 
  select distinct t.jaqy646fec 
    from jaqy646 t
   where t.jaqy646fec = to_date(F_FEC,'rrrr/mm/dd')  ;
   
  
  
  cursor cre(fecpro date) is 
   select --distinct 
      a.jaqy646fec jaqy646fec,
      a.jaqy646pgp jaqy646pgp,  
      a.jaqy646suc jaqy646suc,
      a.jaqy646cta jaqy646cta,
      a.jaqy646ope jaqy646ope,
      a.jaqy646pap jaqy646pap,
      a.jaqy646mod jaqy646mod,
      a.jaqy646sop jaqy646sop,
      a.jaqy646top jaqy646top,  
      a.jaqy646mda jaqy646mda,      
      a.jaqy646rub jaqy646rub
      FROM JAQY646a a      
      where a.jaqy646fec = fecpro
      AND a.jaqy646est = C_EST  --to_date('20130731','rrrrmmdd')        
      ; 
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
     
  begin 
    
      fecha := to_date('31072013','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
   for m in mes loop
      for c in cre(m.jaqy646fec) loop 
      
      begin 
        select d.jaql114inst, (select i.sng001ori from sng001 i where i.sng001inst = d.jaql114inst ) 
        into insta , origen
        from jaql114 d 
               where d.jaql114fech = c.jaqy646fec
               and d.jaql114emp = c.jaqy646pgp
               and d.jaql114mod = c.jaqy646mod
               and d.jaql114suc = c.jaqy646suc
               and d.jaql114mda = c.jaqy646mda
               and d.jaql114pap = c.jaqy646pap
               and d.jaql114cta = c.jaqy646cta
               and d.jaql114oper = c.jaqy646ope 
               and d.jaql114sbop = c.jaqy646sop
               and d.jaql114top = c.jaqy646top
               and d.jaql114rubr = c.jaqy646rub;
       exception when others then 
           insta := 0;
           origen := 0;  
            dbms_output.put_line('intancia '|| sqlerrm ||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);  
      end; 
 
      begin 
      update jaqy646a a set a.jaqy646ains = insta , a.jaqy646aori = origen             
             where c.jaqy646fec = a.jaqy646fec
             and c.jaqy646pgp = a.jaqy646pgp
             and c.jaqy646mod = a.jaqy646mod
             and c.jaqy646suc = a.jaqy646suc
             and c.jaqy646mda = a.jaqy646mda
             and c.jaqy646pap = a.jaqy646pap
             and c.jaqy646cta = a.jaqy646cta
             and c.jaqy646ope = a.jaqy646ope 
             and c.jaqy646sop = a.jaqy646sop
             and c.jaqy646top = a.jaqy646top
             and c.jaqy646rub = a.jaqy646rub;
             commit;
       exception when others then 
         dbms_output.put_line('jaqy646a '||sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);      
       end;               
      end loop ;
      commit;      
  end loop;
    
  end;
  

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --





 FUNCTION SP_CR_PREN_RUBRO(CTA NUMBER , OPE NUMBER, per varchar 
                                    ) RETURN NUMBER is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    rubro number;
  
  begin 
    
  
      select   
           h16.hrubro
                         into rubro
        from fsh015 h15 join fsh016 h16 
                        on h16.pgcod = h15.pgcod
                        and h16.hcmod = h15.hcmod
                        and h16.hsucor= h15.hsucor
                        and h16.htran = h15.htran
                        and h16.hnrel = h15.hnrel
                        and h16.hfcon = h15.hfcon
                        and substr(h16.hrubro,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426) 
                        and h16.hfvco = h15.hfcon        
      where h15.pgcod = 1
         and (             
              (h16.hcmod = 210 and h16.htran = 971) OR
              (h16.hcmod =  30 and h16.htran = 951)
             )           
         and h15.hfcon between to_date(per||'01','rrrrmmdd') and last_day(to_date(per||'01','rrrrmmdd')) 
         and h15.hccorr <> 99
         and h16.hcodmo = 1
         and h16.hcta = CTA	
         and h16.hoper = OPE;
  return rubro;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
END;

--------------------------------------------------------------------------
FUNCTION SP_CR_PREN_SBS(CTA NUMBER , OPE NUMBER, per varchar 
                                    ) RETURN VARCHAR is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
   PRODSBS  VARCHAR2(800) ;
  
  begin 
    
  
      select  
      
      Case When Substr(h16.hrubro, 1, 2) = '14' and
                             Substr(h16.hrubro, 5, 2) = '02' then 'MICRO EMPRESA'
                        When Substr(h16.hrubro, 1, 2) = '14' and
                             Substr(h16.hrubro, 5, 2) = '03' then 'CONSUMO'
                        When Substr(h16.hrubro, 1, 2) = '14' and
                             Substr(h16.hrubro, 5, 2) = '04' then 'HIPOTECARIO'
                        When Substr(h16.hrubro, 1, 2) = '14' and
                             Substr(h16.hrubro, 5, 2) = '09' then 'CORPORATIVO E.I.F.'
                        When Substr(h16.hrubro, 1, 2) = '14' and
                             Substr(h16.hrubro, 5, 2) = '11' then 'GRANDES EMPRESAS'
                        When Substr(h16.hrubro, 1, 2) = '14' and
                             Substr(h16.hrubro, 5, 2) = '12' then 'MEDIANA EMPRESA'
                        When Substr(h16.hrubro, 1, 2) = '14' and
                             Substr(h16.hrubro, 5, 2) = '13' then 'PEQUEÑA EMPRESA'
                        When Substr(h16.hrubro,1,2) in ('71','72') and
                             Substr(h16.hrubro,7,2) = '02' then 'MICRO EMPRESA'
                        When Substr(h16.hrubro,1,2) in ('71','72') and
                             Substr(h16.hrubro,7,2) = '03' then 'CONSUMO'
                        When Substr(h16.hrubro,1,2) in ('71','72') and
                             Substr(h16.hrubro,7,2) = '04' then 'HIPOTECARIO'
                        When Substr(h16.hrubro,1,2) in ('71','72') and
                             Substr(h16.hrubro,7,2) = '12' then 'MEDIANA EMPRESA'
                        When Substr(h16.hrubro,1,2) in ('71','72') and
                             Substr(h16.hrubro,7,2) = '13' then 'PEQUEÑA EMPRESA'
                        Else ''
                   End SBS           
          INTO PRODSBS                
        from fsh015 h15 join fsh016 h16 
                        on h16.pgcod = h15.pgcod
                        and h16.hcmod = h15.hcmod
                        and h16.hsucor= h15.hsucor
                        and h16.htran = h15.htran
                        and h16.hnrel = h15.hnrel
                        and h16.hfcon = h15.hfcon
                        and substr(h16.hrubro,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426) 
                        and h16.hfvco = h15.hfcon        
      where h15.pgcod = 1
         and (             
              (h16.hcmod = 210 and h16.htran = 971) OR
              (h16.hcmod =  30 and h16.htran = 951)
             )           
         and h15.hfcon between to_date(per||'01','rrrrmmdd') and last_day(to_date(per||'01','rrrrmmdd')) 
         and h15.hccorr <> 99
         and h16.hcodmo = 1
         and h16.hcta = CTA	
         and h16.hoper = OPE;
  
 RETURN PRODSBS;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   exception when others then 
     RETURN PRODSBS;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
END;


------------------------------------------------------------------------------

PROCEDURE SP_CR_AMP_SBS(CTA NUMBER , OPE NUMBER, per varchar , RUB out number, SBS out varchar 
                                    )  is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
   PRODSBS  VARCHAR2(800) ;
   
   MONEDA NUMBER(3);
   RUBRO NUMBER(17);
   CUENTA NUMBER(9);
   OPERACION NUMBER(9);
   MONTO_D NUMBER(17,2); 
   SALDO_MN NUMBER(17,2);
   
  begin 
    
  
  select \*+ all_rows *\
       \*   hfcon,
          trnom,
          region_cre,
          zona_cre,
          sucursal_cre,
          amp.hcmod,
          amp.hsucor,
          amp.htran,
          amp.hnrel,
          amp.aomda moneda_alta,*\
          --decode(amp.aomda,0,amp.desem,amp.desem*(select t.cotcbv from fsh005 t  where last_day(amp.hfcon) = t.cofdes and t.moneda = 101)) 
          0 monto_desembolsado, 
          --NVL((case when cance_salcapME is not null then cance_salcapME*ebegazo.fn_tipo_cambio_fijo(last_day(amp.hfcon)) else cance_salcapMN end),0)  ImporteMN,
          -- NVL((case when cance_salcapME is not null then cance_salcapME*(select t.cotcbv from fsh005 t  where last_day(amp.hfcon) = t.cofdes and t.moneda = 101) else cance_salcapMN end),0) 
          0 saldoMN,
           -- (select t.cotcbv from fsh005 t  where last_day(amp.hfcon) = t.cofdes and t.moneda = 101)
          \*   
          amp.pgcod,
          amp.aomod,
          amp.aotop,
          amp.aosuc,
          amp.aopap,*\
          amp.hcta,
          amp.hoper,
       --   amp.aosub ,
          amp.hrubro,            
           Case When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '02' then 'MICRO EMPRESA'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '03' then 'CONSUMO'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '04' then 'HIPOTECARIO'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '09' then 'CORPORATIVO E.I.F.'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '11' then 'GRANDES EMPRESAS'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '12' then 'MEDIANA EMPRESA'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '13' then 'PEQUEÑA EMPRESA'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '02' then 'MICRO EMPRESA'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '03' then 'CONSUMO'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '04' then 'HIPOTECARIO'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '12' then 'MEDIANA EMPRESA'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '13' then 'PEQUEÑA EMPRESA'
                        Else ''
                   End SBS           
           INTO MONTO_D , SALDO_MN, CUENTA, OPERACION, RUBRO, PRODSBS
        from (
              tabla_amp_a   --, hrubro
            ) amp  where amp.pgcod = 1 and  amp.hcta = CTA	and amp.hoper = OPE
            AND to_char(hfcon,'rrrrmm') = per ;
            
      rub := rubro;
      sbs := prodsbs;
 --RETURN PRODSBS;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   exception when others then 
    PRODSBS := '' ;
    MONTO_D :=0 ;
    SALDO_MN := 0;
    CUENTA := 0; 
    OPERACION := 0;
    RUBRO := 0;  
    RUB := 0;
    SBS :=0;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
END;

-----------------------------------------------------------------------


FUNCTION FN_CR_AMP_SBS(CTA NUMBER , OPE NUMBER, per varchar , opcion number    
                                    ) RETURN VARCHAR  is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
   PRODSBS  VARCHAR2(800) ;
   
   MONEDA NUMBER(3);
   RUBRO NUMBER(17);
   CUENTA NUMBER(9);
   OPERACION NUMBER(9);
   MONTO_D NUMBER(17,2); 
   SALDO_MN NUMBER(17,2);
   
  begin 
    
  
  select \*+ all_rows *\
  distinct 
       \*   hfcon,
          trnom,
          region_cre,
          zona_cre,
          sucursal_cre,
          amp.hcmod,
          amp.hsucor,
          amp.htran,
          amp.hnrel,
          amp.aomda moneda_alta,*\
          --decode(amp.aomda,0,amp.desem,amp.desem*(select t.cotcbv from fsh005 t  where last_day(amp.hfcon) = t.cofdes and t.moneda = 101)) 
          0 monto_desembolsado, 
          --NVL((case when cance_salcapME is not null then cance_salcapME*ebegazo.fn_tipo_cambio_fijo(last_day(amp.hfcon)) else cance_salcapMN end),0)  ImporteMN,
          -- NVL((case when cance_salcapME is not null then cance_salcapME*(select t.cotcbv from fsh005 t  where last_day(amp.hfcon) = t.cofdes and t.moneda = 101) else cance_salcapMN end),0)  
          0 saldoMN,
           -- (select t.cotcbv from fsh005 t  where last_day(amp.hfcon) = t.cofdes and t.moneda = 101)
          \*   
          amp.pgcod,
          amp.aomod,
          amp.aotop,
          amp.aosuc,
          amp.aopap,*\
          amp.hcta,
          amp.hoper,
       --   amp.aosub ,
          amp.hrubro,            
           Case When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '02' then 'MICRO EMPRESA'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '03' then 'CONSUMO'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '04' then 'HIPOTECARIO'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '09' then 'CORPORATIVO E.I.F.'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '11' then 'GRANDES EMPRESAS'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '12' then 'MEDIANA EMPRESA'
                        When Substr(amp.hrubro, 1, 2) = '14' and
                             Substr(amp.hrubro, 5, 2) = '13' then 'PEQUEÑA EMPRESA'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '02' then 'MICRO EMPRESA'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '03' then 'CONSUMO'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '04' then 'HIPOTECARIO'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '12' then 'MEDIANA EMPRESA'
                        When Substr(amp.hrubro,1,2) in ('71','72') and
                             Substr(amp.hrubro,7,2) = '13' then 'PEQUEÑA EMPRESA'
                        Else ''
                   End SBS           
           INTO MONTO_D , SALDO_MN, CUENTA, OPERACION, RUBRO, PRODSBS
        from (
              tabla_amp_a    --, hrubro
            ) amp  where amp.pgcod = 1 and  amp.hcta = CTA	and amp.hoper = OPE
            AND to_char(hfcon,'rrrrmm') = per ;
            
      --rub := rubro;
      --sbs := prodsbs;
      if opcion  = 1 then
         return  to_char(rubro);
      else 
         return prodsbs;
      end if ; 
         
      
 --RETURN PRODSBS;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   exception when others then 
    PRODSBS := '' ;
    MONTO_D :=0 ;
    SALDO_MN := 0;
    CUENTA := 0; 
    OPERACION := 0;
    RUBRO := 0;  
    return '';
    --RUB := 0;
    --SBS :=0;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
END;


FUNCTION SP_CR_AMP_SDOMN(CTA NUMBER , OPE NUMBER, per varchar  
                                    )  RETURN NUMBER is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
  
   SALDO_MN NUMBER(17,2);
   
  begin 
    
  
  select \*+ all_rows *\
       \*   hfcon,
          trnom,
          region_cre,
          zona_cre,
          sucursal_cre,
          amp.hcmod,
          amp.hsucor,
          amp.htran,
          amp.hnrel,
          amp.aomda moneda_alta,*\
          --decode(amp.aomda,0,amp.desem,amp.desem*(select t.cotcbv from fsh005 t  where last_day(amp.hfcon) = t.cofdes and t.moneda = 101)) monto_desembolsado, 
          --NVL((case when cance_salcapME is not null then cance_salcapME*ebegazo.fn_tipo_cambio_fijo(last_day(amp.hfcon)) else cance_salcapMN end),0)  ImporteMN,
           NVL((case when cance_salcapME is not null then cance_salcapME*(fn_tipo_cambio_fijo( last_day(to_date(per||'01','rrrrmmdd')))) else cance_salcapMN end),0)  saldoMN
           -- (select t.cotcbv from fsh005 t  where last_day(amp.hfcon) = t.cofdes and t.moneda = 101)
          \*   
          amp.pgcod,
          amp.aomod,
          amp.aotop,
          amp.aosuc,
          amp.aopap,*\
          --amp.aocta,
          --amp.aooper,
          --amp.aosub ,
          --amp.hrubro,               
          INTO SALDO_MN 
        from (
              tabla_amp   --, hrubro
            ) amp  where amp.pgcod = 1 and  amp.aocta = CTA	and amp.aooper = OPE
            AND to_char(hfcon,'rrrrmm') = per ;
            
     RETURN SALDO_MN;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   exception when others then 
   RETURN 0;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
END;


-----------------------------------------------------------------------

procedure SP_CR_DESEMBOLSO_PREN(F_FEC VARCHAR
                                    ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  
  
  
  cursor cre(fecpro VARCHAR) is 
  select \*+ all_rows *\
    last_day(c.aofval) jaqy646fec, 
    c.pgcod jaqy646pgp,
    c.aosuc jaqy646suc, 
    c.aocta jaqy646cta, 
    c.aooper jaqy646ope, 
    c.aopap jaqy646pap, 
    c.aomod jaqy646mod, 
    c.aosbop jaqy646sop, 
    c.aotope jaqy646top, 
    c.aomda jaqy646mda, 
    '' jaqy646cre, 
   case when c.aomda = 101 then c.aoimp*(pq_cosecha_sentinel.fn_tipo_cambio_fijo(c.aofval)) else c.aoimp end jaqy646mmn,       
    c.aoimp jaqy646mto,   
    (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  jaqy646age,
    --(select j.jaqy646reg from agencias_c j where j.jaqy646fec = last_day(c.aofval) and j.jaqy646age =  (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  ) jaqy646reg, 
     upper( pq_cosecha_sentinel.FN_REGION_HIST(last_day(c.aofval),c.aosuc) ) jaqy646reg,
     fn_analista_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope) jaqy646ase ,
      (select upper(x.tonom) from fst004 x where x.modulo = c.aomod and x.totope = c.aotope ) jaqy646pbt,
      (select upper(y.mdnom) from fst003 y where y.modulo = c.aomod ) jaqy646pbm,   
     --fn_csbs(r.pepais,r.petdoc, r.pendoc, last_day(c.aofval))  jaqy646sbs,
     pq_cosecha_sentinel.SP_CR_PREN_SBS(c.aocta, c.aooper,fecpro)  jaqy646sbs,
     c.aoimp JAQY646SAL , 
     case when c.aomda = 101 then c.aoimp*(pq_cosecha_sentinel.fn_tipo_cambio_fijo(c.aofval)) else c.aoimp end jaqy646smn,       
     fn_dias_atraso( last_day(c.aofval) , --fecha de proceso
      c.pgcod ,c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope, 99, c.aofvto) jaqy646dat,                
      r.pepais jaqy646pai, 
      r.petdoc jaqy646tdo, 
      r.pendoc jaqy646ndo, 
      99 jaqy646esc,
      c.aofval jaqy646fed, 
      to_date('01010001','DDMMRRRR') jaqy646fca,
      pq_cosecha_sentinel.SP_CR_PREN_RUBRO(c.aocta, c.aooper,fecpro)  jaqy646rub 
    from fsd010 c , fsr008 r  
     where to_char( c.aofval,'rrrrmm') = fecpro and c.aomod = 108 
     and c.aosbop =0
     and r.pgcod = c.pgcod
     and r.ctnro = c.aocta
     and to_char(c.aofe99, 'RRRRMM') = fecpro
     and r.cttfir = 'T' and r.ttcod = 1    ;
  
  \*select \*+ all_rows *\
    last_day(c.aofval) jaqy646fec, 
    c.pgcod jaqy646pgp,
    c.aosuc jaqy646suc, 
    c.aocta jaqy646cta, 
    c.aooper jaqy646ope, 
    c.aopap jaqy646pap, 
    c.aomod jaqy646mod, 
    c.aosbop jaqy646sop, 
    c.aotope jaqy646top, 
    c.aomda jaqy646mda, 
    '' jaqy646cre, 
   case when c.aomda = 101 then c.aoimp*( select t.cotcbv from fsh005 t  where last_day(c.aofval) = t.cofdes and t.moneda = 101 ) else c.aoimp end jaqy646mmn,       
    c.aoimp jaqy646mto,   
    (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  jaqy646age,
    (select j.jaqy646reg from agencias_c j where j.jaqy646fec = last_day(c.aofval) and j.jaqy646age =  (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  ) jaqy646reg, 
     fn_analista_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope) jaqy646ase ,
      (select upper(x.tonom) from fst004 x where x.modulo = c.aomod and x.totope = c.aotope ) jaqy646pbt,
      (select upper(y.mdnom) from fst003 y where y.modulo = c.aomod ) jaqy646pbm,   
     --fn_csbs(r.pepais,r.petdoc, r.pendoc, last_day(c.aofval))  jaqy646sbs,
     SP_CR_PREN_SBS(c.aocta, c.aooper,F_FEC)  jaqy646sbs,
     c.aoimp JAQY646SAL , 
     case when c.aomda = 101 then c.aoimp*( select t.cotcbv from fsh005 t  where last_day(c.aofval) = t.cofdes and t.moneda = 101 ) else c.aoimp end jaqy646smn,       
     fn_dias_atraso( last_day(c.aofval) , --fecha de proceso
      c.pgcod ,c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope, 99, c.aofvto) jaqy646dat,                
      r.pepais jaqy646pai, 
      r.petdoc jaqy646tdo, 
      r.pendoc jaqy646ndo, 
      99 jaqy646esc,
      c.aofval jaqy646fed, 
      to_date('01010001','DDMMRRRR') jaqy646fca,
      SP_CR_PREN_RUBRO(c.aocta, c.aooper,F_FEC)  jaqy646rub 
    from fsd010\*@\*produ*\*\ c , fsr008 r  
     where to_char( c.aofval,'rrrrmm') = fecpro and c.aomod = 108 
     and c.aosbop =0
     and r.pgcod = c.pgcod
     and r.ctnro = c.aocta
     and to_char(c.aofe99, 'RRRRMM') = fecpro
     and r.cttfir = 'T' and r.ttcod = 1     *\
     --;  
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
     
  begin 
    
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop 
        
          begin         
            insert into jaqy646a
              (
               JAQY646FEC,             JAQY646PGP,             JAQY646SUC,             JAQY646CTA,
               JAQY646OPE,             JAQY646PAP,             JAQY646MOD,             JAQY646SOP,
               JAQY646TOP,             JAQY646MDA,             JAQY646CRE,             JAQY646MMN,
               JAQY646MTO,             JAQY646AGE,             JAQY646REG,             JAQY646ASE,
               JAQY646PBM,             JAQY646PBT,             JAQY646SBS,             JAQY646SAL,
               JAQY646SMN,             JAQY646DAT,             JAQY646PAI,             JAQY646TDO,
               JAQY646NDO,             JAQY646ESC,             JAQY646FED,             JAQY646FCA,
               JAQY646RUB , jaqy646est )
            values
              (
               c.JAQY646FEC,             c.JAQY646PGP,             c.JAQY646SUC,             c.JAQY646CTA,
               c.JAQY646OPE,             c.JAQY646PAP,             c.JAQY646MOD,             c.JAQY646SOP,
               c.JAQY646TOP,             c.JAQY646MDA,             c.JAQY646CRE,             c.JAQY646MMN,
               c.JAQY646MTO,             c.JAQY646AGE,             c.JAQY646REG,             c.JAQY646ASE,
               c.JAQY646PBM,             c.JAQY646PBT,             c.JAQY646SBS,             c.JAQY646SAL,
               c.JAQY646SMN,             c.JAQY646DAT,             c.JAQY646PAI,             c.JAQY646TDO,
               c.JAQY646NDO,             c.JAQY646ESC,             c.JAQY646FED,             c.JAQY646FCA,
               c.jaqy646rub, 'P'  
               );   
             commit;           
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);
             end;          
  end loop ;
    
  end;
-----------------------------------------------------------------------

procedure SP_CR_DESEMBOLSO_AMP(F_FEC VARCHAR
                                    ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  
  
  
  cursor cre(fecpro VARCHAR) is 
 
select \*+ all_rows *\
DISTINCT 
    last_day(c.aofval) jaqy646fec, 
    c.pgcod jaqy646pgp,
    c.aosuc jaqy646suc, 
    c.aocta jaqy646cta, 
    c.aooper jaqy646ope, 
    c.aopap jaqy646pap, 
    c.aomod jaqy646mod, 
    c.aosbop jaqy646sop, 
    c.aotope jaqy646top, 
    c.aomda jaqy646mda, 
    '' jaqy646cre, 
   case when c.aomda = 101 then c.aoimp*( pq_cosecha_sentinel.fn_tipo_cambio_fijo(last_day(c.aofval)) ) else c.aoimp end jaqy646mmn,       
    c.aoimp jaqy646mto,   
    (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  jaqy646age,
    --(select j.jaqy646reg from agencias_c j where j.jaqy646fec = last_day(c.aofval) and j.jaqy646age =  (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  ) jaqy646reg,
     ( pq_cosecha_sentinel.FN_REGION_HIST(last_day(c.aofval),c.aosuc) ) jaqy646reg,
     fn_analista_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope) jaqy646ase ,
      (select upper(x.tonom) from fst004 x where x.modulo = c.aomod and x.totope = c.aotope ) jaqy646pbt,
      (select upper(y.mdnom) from fst003 y where y.modulo = c.aomod ) jaqy646pbm,   
     --fn_csbs(r.pepais,r.petdoc, r.pendoc, last_day(c.aofval))  jaqy646sbs,
     \*pq_cosecha_sentinel.SP_CR_PREN_SBS(c.aocta, c.aooper,&F_FEC)*\
     pq_cosecha_sentinel.fn_CR_AMP_SBS(c.aocta,c.aooper, fecpro,2)  jaqy646sbs,
     c.aoimp JAQY646SAL , 
     case when c.aomda = 101 then c.aoimp*( pq_cosecha_sentinel.fn_tipo_cambio_fijo(last_day(c.aofval)) ) else c.aoimp end jaqy646smn,       
     fn_dias_atraso( last_day(c.aofval) , --fecha de proceso
      c.pgcod ,c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope, 99, c.aofvto) jaqy646dat,                
      r.pepais jaqy646pai, 
      r.petdoc jaqy646tdo, 
      r.pendoc jaqy646ndo, 
      99 jaqy646esc,
      c.aofval jaqy646fed, 
      to_date('01010001','DDMMRRRR') jaqy646fca,
      to_number(pq_cosecha_sentinel.fn_CR_AMP_SBS(c.aocta,c.aooper, fecpro,1))   jaqy646rub, 
      fn_instancia_credito(c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope) jaqy646ins ,  
      i.sng001ori jaqy646ori--      
  -- select\*+ all_rows *\ distinct  c.aocta , c.aomda, c.aooper, c.aosbop--,      
       from fsd010 c , sng001 i , fst111 h ,  FSR008 r
       where i.sng001inst = fn_instancia_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope)
       and i.sng001ori = 4               
       and to_char( c.aofval,'RRRRMM') = fecpro --and t.aomod = 108              
       and c.aostat =99
       and c.pgcod = 1        
       and h.dscod = 50
       and to_char(c.aofe99,'RRRRMM') = fecpro        
       and c.aomod = h.modulo
       and r.pgcod = 1 and r.ctnro = c.aocta
       and r.cttfir =  'T'
       and r.ttcod = 1 
       ; 

  
  
 \* 
  select \*+ all_rows *\
DISTINCT 
    last_day(c.aofval) jaqy646fec, 
    c.pgcod jaqy646pgp,
    c.aosuc jaqy646suc, 
    c.aocta jaqy646cta, 
    c.aooper jaqy646ope, 
    c.aopap jaqy646pap, 
    c.aomod jaqy646mod, 
    c.aosbop jaqy646sop, 
    c.aotope jaqy646top, 
    c.aomda jaqy646mda, 
    '' jaqy646cre, 
   case when c.aomda = 101 then c.aoimp*( select t.cotcbv from fsh005 t  where last_day(c.aofval) = t.cofdes and t.moneda = 101 ) else c.aoimp end jaqy646mmn,       
    c.aoimp jaqy646mto,   
    (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  jaqy646age,
    (select j.jaqy646reg from agencias_c j where j.jaqy646fec = last_day(c.aofval) and j.jaqy646age =  (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  ) jaqy646reg, 
     fn_analista_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope) jaqy646ase ,
      (select upper(x.tonom) from fst004 x where x.modulo = c.aomod and x.totope = c.aotope ) jaqy646pbt,
      (select upper(y.mdnom) from fst003 y where y.modulo = c.aomod ) jaqy646pbm,   
     --fn_csbs(r.pepais,r.petdoc, r.pendoc, last_day(c.aofval))  jaqy646sbs,
     \*pq_cosecha_sentinel.SP_CR_PREN_SBS(c.aocta, c.aooper,&F_FEC)*\0  jaqy646sbs,
     c.aoimp JAQY646SAL , 
     case when c.aomda = 101 then c.aoimp*( select t.cotcbv from fsh005 t  where last_day(c.aofval) = t.cofdes and t.moneda = 101 ) else c.aoimp end jaqy646smn,       
     fn_dias_atraso( last_day(c.aofval) , --fecha de proceso
      c.pgcod ,c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope, 99, c.aofvto) jaqy646dat,                
      r.pepais jaqy646pai, 
      r.petdoc jaqy646tdo, 
      r.pendoc jaqy646ndo, 
      99 jaqy646esc,
      c.aofval jaqy646fed, 
      to_date('01010001','DDMMRRRR') jaqy646fca,
      \*pq_cosecha_sentinel.SP_CR_PREN_RUBRO(c.aocta, c.aooper,&F_FEC)*\0  jaqy646rub--      
  -- select\*+ all_rows *\ distinct  c.aocta , c.aomda, c.aooper, c.aosbop--,      
       from fsd010 c , sng001 i , fst111 h ,  FSR008 r
       where i.sng001inst = fn_instancia_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope)
       and i.sng001ori = 4               
       and to_char( c.aofval,'RRRRMM') = fecpro --and t.aomod = 108              
       and c.aostat =99
       and c.pgcod = 1        
       and h.dscod = 50
       and to_char(c.aofe99,'RRRRMM') = fecpro        
       and c.aomod = h.modulo
       and r.pgcod = 1 and r.ctnro = c.aocta
       and r.cttfir =  'T'
       and r.ttcod = 1 
       ;
      *\
      
   \* from fsd010 c , fsr008 r  
     where to_char( c.aofval,'rrrrmm') = fecpro and c.aomod = 108 
     and c.aosbop =0
     and r.pgcod = c.pgcod
     and r.ctnro = c.aocta
     and to_char(c.aofe99, 'RRRRMM') = fecpro
     and r.cttfir = 'T' and r.ttcod = 1    *\ 
      
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
   
   jaqy646rubN NUMBER(16) :=0 ;
   JAQY646SBSV VARCHAR(100) ;
     
  begin 
    
  null;
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop 
          
     --        SP_CR_AMP_SBS(c.JAQY646CTA , c.JAQY646OPE, F_FEC , jaqy646rubN,  JAQY646SBSV  ) ;        
        
          begin         
            insert into jaqy646a
              (
               JAQY646FEC,             JAQY646PGP,             JAQY646SUC,             JAQY646CTA,
               JAQY646OPE,             JAQY646PAP,             JAQY646MOD,             JAQY646SOP,
               JAQY646TOP,             JAQY646MDA,             JAQY646CRE,             JAQY646MMN,
               JAQY646MTO,             JAQY646AGE,             JAQY646REG,             JAQY646ASE,
               JAQY646PBM,             JAQY646PBT,             JAQY646SBS,             JAQY646SAL,
               JAQY646SMN,             JAQY646DAT,             JAQY646PAI,             JAQY646TDO,
               JAQY646NDO,             JAQY646ESC,             JAQY646FED,             JAQY646FCA,
               JAQY646RUB , jaqy646est , JAQY646aINS, JAQY646aORI )
            values
              (
               c.JAQY646FEC,             c.JAQY646PGP,             c.JAQY646SUC,             c.JAQY646CTA,
               c.JAQY646OPE,             c.JAQY646PAP,             c.JAQY646MOD,             c.JAQY646SOP,
               c.JAQY646TOP,             c.JAQY646MDA,             c.JAQY646CRE,             c.JAQY646MMN,
               c.JAQY646MTO,             c.JAQY646AGE,             c.JAQY646REG,             c.JAQY646ASE,
               c.JAQY646PBM,             c.JAQY646PBT,             c.jaqy646sbs,             c.JAQY646SAL,
               c.JAQY646SMN,             c.JAQY646DAT,             c.JAQY646PAI,             c.JAQY646TDO,
               c.JAQY646NDO,             c.JAQY646ESC,             c.JAQY646FED,             c.JAQY646FCA,
               c.jaqy646rub, 'A', c.JAQY646INS , c.JAQY646ORI  
               );   
             commit;           
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);
             end;          
  end loop ;
 
  end;

-------------------------------------------------------------------------------------

procedure SP_CR_DESEMBOLSO_NORMAL(F_FEC VARCHAR
                                    ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  
  
  
  cursor cre(fecpro VARCHAR) is 
  
select \*+ all_rows *\
DISTINCT 
    last_day(c.aofval) jaqy646fec, 
    c.pgcod jaqy646pgp,
    c.aosuc jaqy646suc, 
    c.aocta jaqy646cta, 
    c.aooper jaqy646ope, 
    c.aopap jaqy646pap, 
    c.aomod jaqy646mod, 
    c.aosbop jaqy646sop, 
    c.aotope jaqy646top, 
    c.aomda jaqy646mda, 
    '' jaqy646cre, 
   case when c.aomda = 101 then c.aoimp*( pq_cosecha_sentinel.fn_tipo_cambio_fijo(last_day(c.aofval)) ) else c.aoimp end jaqy646mmn,       
    c.aoimp jaqy646mto,   
    (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  jaqy646age,
    --(select j.jaqy646reg from agencias_c j where j.jaqy646fec = last_day(c.aofval) and j.jaqy646age =  (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  ) jaqy646reg, 
    ( pq_cosecha_sentinel.FN_REGION_HIST(last_day(c.aofval),c.aosuc) ) jaqy646reg,
     fn_analista_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope) jaqy646ase ,
      (select upper(x.tonom) from fst004 x where x.modulo = c.aomod and x.totope = c.aotope ) jaqy646pbt,
      (select upper(y.mdnom) from fst003 y where y.modulo = c.aomod ) jaqy646pbm,   
     --fn_csbs(r.pepais,r.petdoc, r.pendoc, last_day(c.aofval))  jaqy646sbs,     
     pq_cosecha_sentinel.SP_CR_PREN_SBS(c.aocta, c.aooper,fecpro)  jaqy646sbs,
     c.aoimp JAQY646SAL , 
     case when c.aomda = 101 then c.aoimp*( pq_cosecha_sentinel.fn_tipo_cambio_fijo(last_day(c.aofval)) ) else c.aoimp end jaqy646smn,       
     fn_dias_atraso( last_day(c.aofval) , --fecha de proceso
      c.pgcod ,c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope, 99, c.aofvto) jaqy646dat,                
      r.pepais jaqy646pai, 
      r.petdoc jaqy646tdo, 
      r.pendoc jaqy646ndo, 
      99 jaqy646esc,
      c.aofval jaqy646fed, 
      to_date('01010001','DDMMRRRR') jaqy646fca,
      pq_cosecha_sentinel.SP_CR_PREN_RUBRO(c.aocta, c.aooper,fecpro)   jaqy646rub,-- 
       fn_instancia_credito(c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope) jaqy646ins ,  
      i.sng001ori    jaqy646ori     
  -- select\*+ all_rows *\ distinct  c.aocta , c.aomda, c.aooper, c.aosbop--,      
       from fsd010 c , sng001 i , fst111 h ,  FSR008 r
           where i.sng001inst = fn_instancia_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope)
           and i.sng001ori <> 4               
           and c.aomod not in ( 108, 117,116)
           and to_char( c.aofval,'RRRRMM') = fecpro --and t.aomod = 108              
           and c.aostat =99
           and c.pgcod = 1        
           and h.dscod = 50
           and to_char(c.aofe99,'RRRRMM') = fecpro        
           and c.aomod = h.modulo
           and r.pgcod = 1 and r.ctnro = c.aocta
           and r.cttfir =  'T'
           and r.ttcod = 1 ;
           
   \* select \*+ all_rows *\
DISTINCT 
    last_day(c.aofval) jaqy646fec, 
    c.pgcod jaqy646pgp,
    c.aosuc jaqy646suc, 
    c.aocta jaqy646cta, 
    c.aooper jaqy646ope, 
    c.aopap jaqy646pap, 
    c.aomod jaqy646mod, 
    c.aosbop jaqy646sop, 
    c.aotope jaqy646top, 
    c.aomda jaqy646mda, 
    '' jaqy646cre, 
   case when c.aomda = 101 then c.aoimp*( pq_cosecha_sentinel.fn_tipo_cambio_fijo(last_day(c.aofval)) ) else c.aoimp end jaqy646mmn,       
    c.aoimp jaqy646mto,   
    (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  jaqy646age,
    (select j.jaqy646reg from agencias_c j where j.jaqy646fec = last_day(c.aofval) and j.jaqy646age =  (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  ) jaqy646reg, 
     fn_analista_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope) jaqy646ase ,
      (select upper(x.tonom) from fst004 x where x.modulo = c.aomod and x.totope = c.aotope ) jaqy646pbt,
      (select upper(y.mdnom) from fst003 y where y.modulo = c.aomod ) jaqy646pbm,   
     --fn_csbs(r.pepais,r.petdoc, r.pendoc, last_day(c.aofval))  jaqy646sbs,
     pq_cosecha_sentinel.SP_CR_PREN_SBS(c.aocta, c.aooper,fecpro)  jaqy646sbs,
     c.aoimp JAQY646SAL , 
     case when c.aomda = 101 then c.aoimp*( pq_cosecha_sentinel.fn_tipo_cambio_fijo(last_day(c.aofval)) ) else c.aoimp end jaqy646smn,       
     fn_dias_atraso( last_day(c.aofval) , --fecha de proceso
      c.pgcod ,c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope, 99, c.aofvto) jaqy646dat,                
      r.pepais jaqy646pai, 
      r.petdoc jaqy646tdo, 
      r.pendoc jaqy646ndo, 
      99 jaqy646esc,
      c.aofval jaqy646fed, 
      to_date('01010001','DDMMRRRR') jaqy646fca,
      pq_cosecha_sentinel.SP_CR_PREN_RUBRO(c.aocta, c.aooper,fecpro)   jaqy646rub--      
  -- select\*+ all_rows *\ distinct  c.aocta , c.aomda, c.aooper, c.aosbop--,      
       from fsd010 c , sng001 i , fst111 h ,  FSR008 r
           where i.sng001inst = fn_instancia_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope)
           and i.sng001ori <> 4               
           and c.aomod not in ( 108, 117,116)
           and to_char( c.aofval,'RRRRMM') = fecpro --and t.aomod = 108              
           and c.aostat =99
           and c.pgcod = 1        
           and h.dscod = 50
           and to_char(c.aofe99,'RRRRMM') = fecpro        
           and c.aomod = h.modulo
           and r.pgcod = 1 and r.ctnro = c.aocta
           and r.cttfir =  'T'
           and r.ttcod = 1 ;
       *\
      
      
   \* from fsd010 c , fsr008 r  
     where to_char( c.aofval,'rrrrmm') = fecpro and c.aomod = 108 
     and c.aosbop =0
     and r.pgcod = c.pgcod
     and r.ctnro = c.aocta
     and to_char(c.aofe99, 'RRRRMM') = fecpro
     and r.cttfir = 'T' and r.ttcod = 1    *\ 
      
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
   
   jaqy646rubN NUMBER(16) :=0 ;
   JAQY646SBSV VARCHAR(100) ;
     
  begin 
    
  null;
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop 
          
            -- SP_CR_AMP_SBS(c.JAQY646CTA , c.JAQY646OPE, F_FEC , jaqy646rubN,  JAQY646SBSV  ) ;        
        
          begin         
            insert into jaqy646a
              (
               JAQY646FEC,             JAQY646PGP,             JAQY646SUC,             JAQY646CTA,
               JAQY646OPE,             JAQY646PAP,             JAQY646MOD,             JAQY646SOP,
               JAQY646TOP,             JAQY646MDA,             JAQY646CRE,             JAQY646MMN,
               JAQY646MTO,             JAQY646AGE,             JAQY646REG,             JAQY646ASE,
               JAQY646PBM,             JAQY646PBT,             JAQY646SBS,             JAQY646SAL,
               JAQY646SMN,             JAQY646DAT,             JAQY646PAI,             JAQY646TDO,
               JAQY646NDO,             JAQY646ESC,             JAQY646FED,             JAQY646FCA,
               JAQY646RUB , jaqy646est , jaqy646mto1 , jaqy646mto2 , jaqy646ains , jaqy646aori  )
            values
              (
               c.JAQY646FEC,             c.JAQY646PGP,             c.JAQY646SUC,             c.JAQY646CTA,
               c.JAQY646OPE,             c.JAQY646PAP,             c.JAQY646MOD,             c.JAQY646SOP,
               c.JAQY646TOP,             c.JAQY646MDA,             c.JAQY646CRE,             c.JAQY646MMN,
               c.JAQY646MTO,             c.JAQY646AGE,             c.JAQY646REG,             c.JAQY646ASE,
               c.JAQY646PBM,             c.JAQY646PBT,             c.jaqy646sbs,             c.JAQY646SAL,
               c.JAQY646SMN,             c.JAQY646DAT,             c.JAQY646PAI,             c.JAQY646TDO,
               c.JAQY646NDO,             c.JAQY646ESC,             c.JAQY646FED,             c.JAQY646FCA,
               c.jaqy646rub, 'N' ,c.JAQY646SMN , c.JAQY646MMN, c.jaqy646ins , c.jaqy646ori 
               );   
             commit;           
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);
             end;          
  end loop ;
 
  end;



-------------------------------------------------------------------------------------
procedure SP_CR_ACT_SALDOS_AMP(F_FEC VARCHAR
                                    ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  cursor cre(fecpro VARCHAR) is 
   select \*+ ALL_ROWS *\\*pq_cosecha_sentinel.SP_CR_AMP_SDOMN(F.JAQY646CTA, F.JAQY646OPE, &FECHA) ,*\ F.* 
   from jaqy646a f
     where f.jaqy646fed between to_date(fecpro||'01', 'RRRRMMDD') and
           last_day(to_date(fecpro||'01', 'RRRRMMDD'))
       and TO_CHAR(f.jaqy646fec, 'MMRRRR') = to_char(jaqy646fed, 'MMRRRR')
       and f.jaqy646esc not in (33,34,61,120) --no refinanciados 
       and f.jaqy646mod not in (117,116, 142,141) --no lineas                             
       and f.jaqy646rub not in (1415,1425)  --no vencidos              
       and (f.jaqy646aori in (  4  ) )
       -- and f.jaqy646mto2 is null
      ;
      
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
   
   jaqy646rubN NUMBER(16) :=0 ;
   JAQY646SBSV VARCHAR(100) ;
     
  begin 
    
  null;
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop             
        
          begin         
            UPDATE JAQY646A F SET
            F.JAQY646MTO2 = F.JAQY646MMN ,
            F.JAQY646MTO3 = SP_CR_AMP_SDOMN(C.JAQY646CTA,C.JAQY646OPE,F_FEC)
          --F.JAQY646EST = 'I'                   
              WHERE F.JAQY646FEC = C.JAQY646FEC
              AND   F.JAQY646PGP = C.JAQY646PGP
              AND   F.JAQY646SUC = C.JAQY646SUC
              AND   F.JAQY646CTA = C.JAQY646CTA
              AND   F.JAQY646OPE = C.JAQY646OPE
              AND   F.JAQY646PAP = C.JAQY646PAP
              AND   F.JAQY646MOD = C.JAQY646MOD
              AND   F.JAQY646SOP = C.JAQY646SOP
              AND   F.JAQY646TOP = C.JAQY646TOP
              AND   F.JAQY646MDA = C.JAQY646MDA
              and substr(f.jaqy646rub,1,4) not in (1415,1425); 
          
             commit;           
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);
             end;          
  end loop ;
 
  end;

------------------------------------------------------------------------------------

procedure SP_CR_ACT_SALDOS_AMP2(F_FEC VARCHAR
                                    ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  cursor cre(fecpro VARCHAR) is 
   select \*+ ALL_ROWS *\\*pq_cosecha_sentinel.SP_CR_AMP_SDOMN(F.JAQY646CTA, F.JAQY646OPE, &FECHA) ,*\ F.* 
   from jaqy646a f
     where f.jaqy646fed between to_date(fecpro||'01', 'RRRRMMDD') and
           last_day(to_date(fecpro||'01', 'RRRRMMDD'))
       and TO_CHAR(f.jaqy646fec, 'MMRRRR') = to_char(jaqy646fed, 'MMRRRR')
       and f.jaqy646esc not in (33,34,61,120) --no refinanciados 
       and f.jaqy646mod not in (117,116, 142,141) --no lineas                             
       and f.jaqy646rub not in (1415,1425)  --no vencidos              
       and (f.jaqy646aori in (  4  ) )
       -- and f.jaqy646mto2 is null
      ;
      
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
   
   jaqy646rubN NUMBER(16) :=0 ;
   JAQY646SBSV VARCHAR(100) ;
     
  begin 
    
  null;
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop             
        
          begin         
            UPDATE JAQY646A F SET
            F.JAQY646MMN = F.JAQY646MTO2 - F.JAQY646MTO3
            --F.JAQY646MTO3 = SP_CR_AMP_SDOMN(C.JAQY646CTA,C.JAQY646OPE,F_FEC)
          --F.JAQY646EST = 'I'                   
              WHERE F.JAQY646FEC = C.JAQY646FEC
              AND   F.JAQY646PGP = C.JAQY646PGP
              AND   F.JAQY646SUC = C.JAQY646SUC
              AND   F.JAQY646CTA = C.JAQY646CTA
              AND   F.JAQY646OPE = C.JAQY646OPE
              AND   F.JAQY646PAP = C.JAQY646PAP
              AND   F.JAQY646MOD = C.JAQY646MOD
              AND   F.JAQY646SOP = C.JAQY646SOP
              AND   F.JAQY646TOP = C.JAQY646TOP
              AND   F.JAQY646MDA = C.JAQY646MDA
              and substr(f.jaqy646rub,1,4) not in (1415,1425); 
          
             commit;           
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);
             end;          
  end loop ;
 
  end;
-------------------------------------------------------------------------------------

procedure SP_CR_ACT_SALDOS_AMP3(F_FEC VARCHAR
                                    ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  cursor cre(fecpro VARCHAR) is 
   select \*+ ALL_ROWS *\\*pq_cosecha_sentinel.SP_CR_AMP_SDOMN(F.JAQY646CTA, F.JAQY646OPE, &FECHA) ,*\ F.* 
   from jaqy646a f
     where f.jaqy646fed between to_date(fecpro||'01', 'RRRRMMDD') and
           last_day(to_date(fecpro||'01', 'RRRRMMDD'))
       and TO_CHAR(f.jaqy646fec, 'MMRRRR') = to_char(jaqy646fed, 'MMRRRR')
       and f.jaqy646esc not in (33,34,61,120) --no refinanciados 
       and f.jaqy646mod not in (117,116, 142,141) --no lineas                             
       and f.jaqy646rub not in (1415,1425)  --no vencidos              
       and (f.jaqy646aori in (  4  ) )
       -- and f.jaqy646mto2 is null
      ;
      
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
   
   jaqy646rubN NUMBER(16) :=0 ;
  -- JAQY646SBSV VARCHAR(100) ;
     
  begin 
    
  null;
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop             
        
          begin         
            UPDATE JAQY646A F SET
            F.JAQY646MMN = F.JAQY646MTO2--,
            --F.JAQY646MTO3 = SP_CR_AMP_SDOMN(C.JAQY646CTA,C.JAQY646OPE,F_FEC)
          --F.JAQY646EST = 'I'                   
              WHERE F.JAQY646FEC = C.JAQY646FEC
              AND   F.JAQY646PGP = C.JAQY646PGP
              AND   F.JAQY646SUC = C.JAQY646SUC
              AND   F.JAQY646CTA = C.JAQY646CTA
              AND   F.JAQY646OPE = C.JAQY646OPE
              AND   F.JAQY646PAP = C.JAQY646PAP
              AND   F.JAQY646MOD = C.JAQY646MOD
              AND   F.JAQY646SOP = C.JAQY646SOP
              AND   F.JAQY646TOP = C.JAQY646TOP
              AND   F.JAQY646MDA = C.JAQY646MDA
              and substr(f.jaqy646rub,1,4) not in (1415,1425); 
          
             commit;           
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);
             end;          
  end loop ;
 
  end;


-------------------------------------------------------------------------------------
procedure SP_CR_DESEMBOLSO_AMP_TOT(F_FEC VARCHAR
                                    ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  
  
  
  cursor cre(fecpro VARCHAR) is 
  select \*+ all_rows *\
DISTINCT 
    last_day(c.aofval) jaqy646fec, 
    c.pgcod jaqy646pgp,
    c.aosuc jaqy646suc, 
    c.aocta jaqy646cta, 
    c.aooper jaqy646ope, 
    c.aopap jaqy646pap, 
    c.aomod jaqy646mod, 
    c.aosbop jaqy646sop, 
    c.aotope jaqy646top, 
    c.aomda jaqy646mda, 
    '' jaqy646cre, 
   case when c.aomda = 101 then c.aoimp*( select t.cotcbv from fsh005 t  where last_day(c.aofval) = t.cofdes and t.moneda = 101 ) else c.aoimp end jaqy646mmn,       
    c.aoimp jaqy646mto,   
    (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  jaqy646age,
    (select j.jaqy646reg from agencias_c j where j.jaqy646fec = last_day(c.aofval) and j.jaqy646age =  (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  ) jaqy646reg, 
     fn_analista_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope) jaqy646ase ,
      (select upper(x.tonom) from fst004 x where x.modulo = c.aomod and x.totope = c.aotope ) jaqy646pbt,
      (select upper(y.mdnom) from fst003 y where y.modulo = c.aomod ) jaqy646pbm,   
     --fn_csbs(r.pepais,r.petdoc, r.pendoc, last_day(c.aofval))  jaqy646sbs,
     \*pq_cosecha_sentinel.SP_CR_PREN_SBS(c.aocta, c.aooper,&F_FEC)*\0  jaqy646sbs,
     c.aoimp JAQY646SAL , 
     case when c.aomda = 101 then c.aoimp*( select t.cotcbv from fsh005 t  where last_day(c.aofval) = t.cofdes and t.moneda = 101 ) else c.aoimp end jaqy646smn,       
     fn_dias_atraso( last_day(c.aofval) , --fecha de proceso
      c.pgcod ,c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope, 99, c.aofvto) jaqy646dat,                
      r.pepais jaqy646pai, 
      r.petdoc jaqy646tdo, 
      r.pendoc jaqy646ndo, 
      99 jaqy646esc,
      c.aofval jaqy646fed, 
      to_date('01010001','DDMMRRRR') jaqy646fca,
      \*pq_cosecha_sentinel.SP_CR_PREN_RUBRO(c.aocta, c.aooper,&F_FEC)*\0  jaqy646rub--      
  -- select\*+ all_rows *\ distinct  c.aocta , c.aomda, c.aooper, c.aosbop--,      
       from fsd010 c , sng001 i , fst111 h ,  FSR008 r
       where i.sng001inst = fn_instancia_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope)
       and i.sng001ori = 4               
       and to_char( c.aofval,'RRRRMM') = fecpro --and t.aomod = 108              
       and c.aostat =99
       and c.pgcod = 1        
       and h.dscod = 50
       and to_char(c.aofe99,'RRRRMM') = fecpro        
       and c.aomod = h.modulo
       and r.pgcod = 1 and r.ctnro = c.aocta
       and r.cttfir =  'T'
       and r.ttcod = 1 
       ;
      
      
   \* from fsd010 c , fsr008 r  
     where to_char( c.aofval,'rrrrmm') = fecpro and c.aomod = 108 
     and c.aosbop =0
     and r.pgcod = c.pgcod
     and r.ctnro = c.aocta
     and to_char(c.aofe99, 'RRRRMM') = fecpro
     and r.cttfir = 'T' and r.ttcod = 1    *\ 
      
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
   
   jaqy646rubN NUMBER(16) :=0 ;
   JAQY646SBSV VARCHAR(100) ;
     
  begin 
    
  null;
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop 
          
             SP_CR_AMP_SBS(c.JAQY646CTA , c.JAQY646OPE, F_FEC , jaqy646rubN,  JAQY646SBSV  ) ;        
        
          begin         
            insert into jaqy646a
              (
               JAQY646FEC,             JAQY646PGP,             JAQY646SUC,             JAQY646CTA,
               JAQY646OPE,             JAQY646PAP,             JAQY646MOD,             JAQY646SOP,
               JAQY646TOP,             JAQY646MDA,             JAQY646CRE,             JAQY646MMN,
               JAQY646MTO,             JAQY646AGE,             JAQY646REG,             JAQY646ASE,
               JAQY646PBM,             JAQY646PBT,             JAQY646SBS,             JAQY646SAL,
               JAQY646SMN,             JAQY646DAT,             JAQY646PAI,             JAQY646TDO,
               JAQY646NDO,             JAQY646ESC,             JAQY646FED,             JAQY646FCA,
               JAQY646RUB , jaqy646est )
            values
              (
               c.JAQY646FEC,             c.JAQY646PGP,             c.JAQY646SUC,             c.JAQY646CTA,
               c.JAQY646OPE,             c.JAQY646PAP,             c.JAQY646MOD,             c.JAQY646SOP,
               c.JAQY646TOP,             c.JAQY646MDA,             c.JAQY646CRE,             c.JAQY646MMN,
               c.JAQY646MTO,             c.JAQY646AGE,             c.JAQY646REG,             c.JAQY646ASE,
               c.JAQY646PBM,             c.JAQY646PBT,             JAQY646SBSV,             c.JAQY646SAL,
               c.JAQY646SMN,             c.JAQY646DAT,             c.JAQY646PAI,             c.JAQY646TDO,
               c.JAQY646NDO,             c.JAQY646ESC,             c.JAQY646FED,             c.JAQY646FCA,
               jaqy646rubN, 'A'  
               );   
             commit;           
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);
             end;          
  end loop ;
 
  end;


-------------------------------------------------------------------------------------
procedure SP_CR_DESEMBOLSO_AMP_TRANS(F_FEC VARCHAR
                                    ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  
  
  
  cursor cre(fecpro VARCHAR) is 
       select \*+ all_rows *\
                 trnom, \*region_cre, zona_cre,*\ \*sucursal_cre,*\ 
                 PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, hfcon, HCSUBO, 
                 sum(case when hcodmo = 1 then hcimp1 end) desem,
                 sum(case when hcodmo = 2 and hmda=0 then hcimp1 end) cance_salcapMN,
                 sum(case when hcodmo = 2 and hmda=101 then hcimp1 end) cance_salcapME,              
                 sum(case when hcodmo = 2 then hcimp2 end) cance_int,               
                 sum(case when hcodmo = 1 then hcimp1 end)-sum(case when hcodmo = 2 then hcimp1+hcimp2 end) mtoamp,
                 max(case when hcodmo = 1 then hsucur end) aosuc,
                 max(case when hcodmo = 1 then hmda end) aomda,--Moneda de credito Alta
                 max(case when hcodmo = 1 then hpap end) aopap,               
                 max(case when hcodmo = 1 then hcta end) aocta,
                 max(case when hcodmo = 1 then hoper end) aooper,
                 max(case when hcodmo = 1 then hsubop end) aosub,
                 max(case when hcodmo = 1 then htoper end) aotop,
                 max(case when hcodmo = 1 then hmodul end) aomod,
                 max(case when hcodmo = 1 then hrubro end) hrubro
                             
          from (
                    SELECT rs.regnom region_cre, rs.deszon zona_cre, rs.scnom sucursal_cre,
                         t34.trnom, h16.* 
                    From fsh015 h15 join fsh016 h16  on h15.pgcod = h16.pgcod
                                                    and h15.hcmod = h16.hcmod
                                                    and h15.hsucor= h16.hsucor
                                                    and h15.htran = h16.htran
                                                    and h15.hnrel = h16.hnrel
                                                    and h15.hfcon = h16.hfcon                                   
                                    join fst034 t34 on t34.pgcod = h16.pgcod
                                                   and t34.trmod = h16.hcmod
                                                   and t34.trnro = h16.htran
                                    join \*bantprod.*\regsuc rs on rs.sucurs = h16.hsucur 
                   where h15.pgcod = 1
                     and h15.hcmod  = 30 
                     and h15.htran  = 360
                     and h15.hfcon between to_date(fecpro||'01','rrrrmmdd') and last_day(to_date(fecpro||'01','rrrrmmdd'))  
                     and h16.hmodul in (select modulo from fst111 where dscod = 50 and modulo not in (29,120,144,33,108))
                     and h15.hccorr <> 99
                   --  and h16.hcta = 15682 and h16.hoper = 142318
                     and h16.pgcod = 1
                      
          )
          group by trnom, \*region_cre, zona_cre,*\ \*sucursal_cre,*\
                PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, hfcon, HCSUBO;
                      
                      
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
     
  begin 
    
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop 
        
          begin         
            
              insert into TABLA_AMP
                (TRNOM,
                 REGION_CRE,
                 ZONA_CRE,
                 SUCURSAL_CRE,
                 PGCOD,
                 HCMOD,
                 HSUCOR,
                 HTRAN,
                 HNREL,
                 HFCON,
                 HCSUBO,
                 DESEM,
                 CANCE_SALCAPMN,
                 CANCE_SALCAPME,
                 CANCE_INT,
                 MTOAMP,
                 AOSUC,
                 AOMDA,
                 AOPAP,
                 AOCTA,
                 AOOPER,
                 AOSUB,
                 AOTOP,
                 AOMOD,
                 HRUBRO)
              values
                (c.TRNOM,
                 '',--c.REGION_CRE,
                 '',--c.ZONA_CRE,
                 '',--c.SUCURSAL_CRE,
                 c.PGCOD,
                 c.HCMOD,
                 c.HSUCOR,
                 c.HTRAN,
                 c.HNREL,
                 c.HFCON,
                 c.HCSUBO,
                 c.DESEM,
                 c.CANCE_SALCAPMN,
                 c.CANCE_SALCAPME,
                 c.CANCE_INT,
                 c.MTOAMP,
                 c.AOSUC,
                 c.AOMDA,
                 c.AOPAP,
                 c.AOCTA,
                 c.AOOPER,
                 c.AOSUB,
                 c.AOTOP,
                 c.AOMOD,
                 c.HRUBRO);

          
             
             commit;           
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.AOCTA||'|'||c.AOOPER);
             end;          
  end loop ;
    
  end;


----------------------------------------------------------------------------

        
FUNCTION  FN_CR_IMP_DESEM(
  PGCOD NUMBER,   MODU NUMBER,  SUC NUMBER,   MDA NUMBER,  PAP NUMBER,
  CTA NUMBER,  OPER NUMBER,   SBOP NUMBER,   TOPE NUMBER 
                                    ) RETURN NUMBER  is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
  importe number(17,2);
     
  begin 
    
     select q.aoimp into importe 
     from fsd010 q 
     where q.pgcod = PGCOD
        and q.aomod = MODU 
        --and q.aosuc = SUC
        and q.aomda = MDA
        and q.aopap = PAP
        and q.aocta = CTA
        and q.aooper = OPER
        and q.aosbop = SBOP
        and q.aotope = TOPE  ;         
  
      return importe;
    
       exception when others then 
               
          return 0;
    
    
  end;
----------------------------------------------------------------------------



procedure SP_CR_DESEMBOLSO_IMP(F_FEC VARCHAR
                                    ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
  
  cursor cre(fecpro VARCHAR) is 
  select 
   f.jaqy646fec, 
   f.jaqy646pgp,
   f.jaqy646suc, 
   f.jaqy646cta, 
   f.jaqy646ope,
   f.jaqy646pap, 
   f.jaqy646mod, 
   f.jaqy646sop, 
   f.jaqy646top, 
   f.jaqy646mda    
  from jaqy646a f                     
   where f.jaqy646fed between to_date(FECPRO||01, 'RRRRMMDD') and
         last_day(to_date(FECPRO||01, 'RRRRMMDD'))
     and TO_CHAR(f.jaqy646fec, 'MMRRRR') = to_char(jaqy646fed, 'MMRRRR')
     and f.jaqy646esc not in (33,34,61,120) --no refinanciados
     and f.jaqy646mod not in (117,116, 142,141) --no lineas
     --and f.jaqy646mod in (108) --no lineas
     and substr(f.jaqy646rub,1,4) not in (1415,1425)
     and f.jaqy646mmn is null
     --AND F.JAQY646EST = 'I'  
     ;
     
  
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
   
   jaqy646rubN NUMBER(16) :=0 ;
   JAQY646SBSV VARCHAR(100) ;
     
  begin     
      
      for c in cre(F_FEC) loop                     
        begin                      
          UPDATE JAQY646A F SET 
         \* F.JAQY646MTO =  FN_CR_IMP_DESEM(C.JAQY646PGP,
              C.JAQY646MOD, C.JAQY646SUC, C.JAQY646MDA, C.JAQY646PAP, 
              C.JAQY646CTA, C.JAQY646OPE, C.JAQY646SOP, C.JAQY646TOP), *\          
          F.JAQY646MMN = FN_CR_IMP_DESEM(C.JAQY646PGP,
              C.JAQY646MOD, C.JAQY646SUC, C.JAQY646MDA, C.JAQY646PAP, 
              C.JAQY646CTA, C.JAQY646OPE, C.JAQY646SOP, C.JAQY646TOP)*(
              DECODE(C.JAQY646MDA,101,fn_tipo_cambio_fijo(C.JAQY646FEC),1)) ,
          F.JAQY646EST = 'I'                   
              WHERE F.JAQY646FEC = C.JAQY646FEC
              AND   F.JAQY646PGP = C.JAQY646PGP
              AND   F.JAQY646SUC = C.JAQY646SUC
              AND   F.JAQY646CTA = C.JAQY646CTA
              AND   F.JAQY646OPE = C.JAQY646OPE
              AND   F.JAQY646PAP = C.JAQY646PAP
              AND   F.JAQY646MOD = C.JAQY646MOD
              AND   F.JAQY646SOP = C.JAQY646SOP
              AND   F.JAQY646TOP = C.JAQY646TOP
              AND   F.JAQY646MDA = C.JAQY646MDA
              and substr(f.jaqy646rub,1,4) not in (1415,1425); 
          
             commit;           
          exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'||C.JAQY646CTA ||'|'||c.JAQY646OPE);
          end;   
                    
       end loop ;
 
  end;

----------------------------------------------------------------------------



procedure SP_CR_SBS_PARCHE(F_FEC VARCHAR
                                    ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_INSTANCIA
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
  
  cursor cre(fecpro VARCHAR) is 
  select 
   f.jaqy646fec, 
   f.jaqy646pgp,
   f.jaqy646suc, 
   f.jaqy646cta, 
   f.jaqy646ope,
   f.jaqy646pap, 
   f.jaqy646mod, 
   f.jaqy646sop, 
   f.jaqy646top, 
   f.jaqy646mda    
  from jaqy646a f                     
   where f.jaqy646fed between to_date(FECPRO||01, 'RRRRMMDD') and
         last_day(to_date(FECPRO||01, 'RRRRMMDD'))
     and TO_CHAR(f.jaqy646fec, 'MMRRRR') = to_char(jaqy646fed, 'MMRRRR')
     and f.jaqy646esc not in (33,34,61,120) --no refinanciados
     and f.jaqy646mod not in (117,116, 142,141) --no lineas
     --and f.jaqy646mod in (108) --no lineas
     and substr(f.jaqy646rub,1,4) not in (1415,1425)
     and f.jaqy646mmn is null
     --AND F.JAQY646EST = 'I'  
     ;
     
  
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
   
   jaqy646rubN NUMBER(16) :=0 ;
   JAQY646SBSV VARCHAR(100) ;
     
  begin     
      
      for c in cre(F_FEC) loop                     
        begin                      
          UPDATE JAQY646A F SET 
         \* F.JAQY646MTO =  FN_CR_IMP_DESEM(C.JAQY646PGP,
              C.JAQY646MOD, C.JAQY646SUC, C.JAQY646MDA, C.JAQY646PAP, 
              C.JAQY646CTA, C.JAQY646OPE, C.JAQY646SOP, C.JAQY646TOP), *\          
          F.JAQY646MMN = FN_CR_IMP_DESEM(C.JAQY646PGP,
              C.JAQY646MOD, C.JAQY646SUC, C.JAQY646MDA, C.JAQY646PAP, 
              C.JAQY646CTA, C.JAQY646OPE, C.JAQY646SOP, C.JAQY646TOP)*(
              DECODE(C.JAQY646MDA,101,fn_tipo_cambio_fijo(C.JAQY646FEC),1)) ,
          F.JAQY646EST = 'I'                   
              WHERE F.JAQY646FEC = C.JAQY646FEC
              AND   F.JAQY646PGP = C.JAQY646PGP
              AND   F.JAQY646SUC = C.JAQY646SUC
              AND   F.JAQY646CTA = C.JAQY646CTA
              AND   F.JAQY646OPE = C.JAQY646OPE
              AND   F.JAQY646PAP = C.JAQY646PAP
              AND   F.JAQY646MOD = C.JAQY646MOD
              AND   F.JAQY646SOP = C.JAQY646SOP
              AND   F.JAQY646TOP = C.JAQY646TOP
              AND   F.JAQY646MDA = C.JAQY646MDA
              and substr(f.jaqy646rub,1,4) not in (1415,1425); 
          
             commit;           
          exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'||C.JAQY646CTA ||'|'||c.JAQY646OPE);
          end;   
                    
       end loop ;
 
  end;


------------------------------------------------------------------------------
*/



function fn_tipo_cambio_fijo(P_FECHA in date) return number
  is
    ln_tipcam fsh005.cotcbi%type;
  Begin
       Select cotcbi
         Into ln_tipcam
         From (
                 select u.cotcbi
                   From fsh005 u
                  Where moneda=101
                    And cofdes <= P_FECHA
               Order by cofdes desc
              )
        Where rownum = 1;

       Return ln_tipcam;
  Exception when others then
            return 0;
  end fn_tipo_cambio_fijo;



----------------------------------------------------------------------------




----------------------------------------------------------------------------


/*
procedure SP_CR_ACT_ASESOR(F_FEC VARCHAR
                                    ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_ACT_ASESOR
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  cursor cre(fecpro VARCHAR) is 
   select \*+all_rows parallel(f,6)*\
         F.*  
          from jaqy646a f
         \* where 
           f.jaqy646mod = 108 
          and to_char(f.jaqy646fec,'rrrrmm') = F_FEC  *\       
         
          
         where f.jaqy646fed between to_date(F_FEC||'01', 'RRRRMMDD') and
               last_day(to_date(F_FEC||'01', 'RRRRMMDD'))
           and TO_CHAR(f.jaqy646fec, 'MMRRRR') = to_char(jaqy646fed, 'MMRRRR')
           --AND UPPER(f.jaqy646reg) like &region || '%'         
         and f.jaqy646esc not in (33,34,61,120) --no refinanciados 
         and f.jaqy646mod not in (117,116) --no lineas  
         
         and (
         \*prendarios*\
         ( f.jaqy646mod in (108) and f.jaqy646sop = 0 and  f.jaqy646aori is null  ) or 
         \*ampliaciones*\
         (  f.jaqy646mod not in (108) and f.jaqy646aori = 4 ) or 
         \*normales*\
         (   f.jaqy646mod not in (108) and nvl(f.jaqy646aori,0) in ( 0, 10 ) )
         )
         
         and f.jaqy646ase is null;
      
      
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
   
   jaqy646rubN NUMBER(16) :=0 ;
  -- JAQY646SBSV VARCHAR(100) ;
     
  begin 
    
  null;
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop             
        
          begin         
            UPDATE JAQY646A F SET
            F.jaqy646ase = fn_analista_credito(c.jaqy646mod,c.jaqy646suc,c.jaqy646mda,
            c.jaqy646pap,c.jaqy646cta,c.jaqy646ope,c.jaqy646sop,c.jaqy646top)
            --F.JAQY646MTO3 = SP_CR_AMP_SDOMN(C.JAQY646CTA,C.JAQY646OPE,F_FEC)
          --F.JAQY646EST = 'I'                   
              WHERE F.JAQY646FEC = C.JAQY646FEC
              AND   F.JAQY646PGP = C.JAQY646PGP
              AND   F.JAQY646SUC = C.JAQY646SUC
              AND   F.JAQY646CTA = C.JAQY646CTA
              AND   F.JAQY646OPE = C.JAQY646OPE
              AND   F.JAQY646PAP = C.JAQY646PAP
              AND   F.JAQY646MOD = C.JAQY646MOD
              AND   F.JAQY646SOP = C.JAQY646SOP
              AND   F.JAQY646TOP = C.JAQY646TOP
              AND   F.JAQY646MDA = C.JAQY646MDA
              --and substr(f.jaqy646rub,1,4) not in (1415,1425)
              ; 
          
             commit;           
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);
             end;          
  end loop ;
 
  end;*/

----------------------------------------------------------------------------

function FN_REGION_HIST(P_FECHA in date, P_SUCUR IN NUMBER) return varchar
  is
    fecha date;
    fechamin date;
    fechamax date;
    region fst810.regnom%type; 
    agencia fst001.scnom%type; 
     
  Begin
    
  select min(t.fecha) into fechamin  from fst001_all t;
  select MAX(t.fecha) into fechamax  from fst001_all t;
   
  if fechamin >= P_FECHA then
    
     select /*+ all_rows*/ /*distinct*/ d.fecha, d.regnom,  b.scnom
      into fecha , region, agencia
      from fst001_all b, FST811_all c, fst810_all d
     where b.sucurs = c.oficod
       and d.regcod = c.regcod
       and d.pgcod = c.pgcod
       and c.regcod < 100
       and c.ofisuc = 'S' 
       and d.fecha = c.fecha
       and d.fecha = c.fecha
       and b.fecha = c.fecha
       and b.sucurs = P_SUCUR
       AND c.fecha = fechamin ;   
  
  else    
     if fechamax <= P_FECHA then
     
     select /*+ all_rows */ /*distinct*/ d.fecha, d.regnom,  b.scnom
      into fecha , region, agencia
      from fst001_all b, FST811_all c, fst810_all d
     where b.sucurs = c.oficod
       and d.regcod = c.regcod
       and d.pgcod = c.pgcod
       and c.regcod < 100
       and c.ofisuc = 'S' 
       and d.fecha = c.fecha
       and d.fecha = c.fecha
       and b.fecha = c.fecha
       and b.sucurs = P_SUCUR
       AND c.fecha = fechamax ; 
     
     
     else 
   
         select /*+ all_rows */ /*distinct*/ d.fecha, d.regnom,  b.scnom
          into fecha , region, agencia
          from fst001_all b, FST811_all c, fst810_all d
         where b.sucurs = c.oficod
           and d.regcod = c.regcod
           and d.pgcod = c.pgcod
           and c.regcod < 100
           and c.ofisuc = 'S' 
           and d.fecha = c.fecha
           and d.fecha = c.fecha
           and b.fecha = c.fecha
           and b.sucurs = P_SUCUR
           AND c.fecha = P_FECHA ; 
           
      end if; 
       
   end if ;  

     Return region;
  Exception when others then
            return 'X';
  end FN_REGION_HIST;

--------------------------------------------------------------
  
function FN_COD_REGION_HIST(P_FECHA in date, P_SUCUR IN NUMBER) return number 
  is
    fecha date;
    fechamin date;
    region fst810.regnom%type; 
    codreg fst810.regcod%type; 
    
    agencia fst001.scnom%type; 
     
  Begin
    
  select min(t.fecha) into fechamin  from fst001_all t;
   
  if fechamin >= P_FECHA then
    
     select /*distinct*/ d.fecha, d.regnom,  d.regcod
      into fecha , region, codreg
      from fst001_all b, FST811_all c, fst810_all d
     where b.sucurs = c.oficod
       and d.regcod = c.regcod
       and d.pgcod = c.pgcod
       and c.regcod < 100
       and c.ofisuc = 'S' 
       and d.fecha = c.fecha
       and d.fecha = c.fecha
       and b.fecha = c.fecha
       and b.sucurs = P_SUCUR
       AND c.fecha = fechamin ;   
  
  else    
      
     select /*distinct*/ d.fecha, d.regnom,  d.regcod
      into fecha , region, codreg
      from fst001_all b, FST811_all c, fst810_all d
     where b.sucurs = c.oficod
       and d.regcod = c.regcod
       and d.pgcod = c.pgcod
       and c.regcod < 100
       and c.ofisuc = 'S' 
       and d.fecha = c.fecha
       and d.fecha = c.fecha
       and b.fecha = c.fecha
       and b.sucurs = P_SUCUR
       AND c.fecha = P_FECHA ; 
       
   end if;  

     Return codreg;
     
  Exception when others then
            return 0;
  end FN_COD_REGION_HIST;
  

----------------------------------------------------------------------------



--------------------------------------------------------------
  
function FN_AGENCIA_HIST( P_SUCUR IN NUMBER) return varchar 
  is
    fecha date;
    fechamin date;
    
    agencia fst001.scnom%type; 
     
  Begin
    
     select t.scnom into agencia from fst001/*_produ*/  t where t.pgcod =  1 and t.sucurs = P_SUCUR; 

     Return agencia;
     
  Exception when others then
            return '-';
            
  end FN_AGENCIA_HIST;
  

----------------------------------------------------------------------------
procedure SP_CR_CARGA_INICIAL(F_FEC date) is
---rms 1
  -- *****************************************************************
  -- Nombre                     : SP_CR_ACT_ASESOR
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_PERANO ( año del proceso )
  --                              P_PERMES ( mes del proceso )                            
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************
  -- Variable para el nombre del Titular Principal del Crédito.   

  cursor mes is
    select distinct t.jaql114fech
      from jaql114 t
     where t.jaql114fech = F_FEC; --to_date('20130731', 'rrrrmmdd');


  cursor cre(fecpro date) is  
    select 
     a.jaql114fech jaqy646fec,
     a.jaql114emp jaqy646pgp,
     a.jaql114suc jaqy646suc,
     a.jaql114cta jaqy646cta,
     a.jaql114oper jaqy646ope,
     a.jaql114pap jaqy646pap,
     a.jaql114mod jaqy646mod,
     a.jaql114sbop jaqy646sop,
     a.jaql114top jaqy646top,
     a.jaql114mda jaqy646mda,
     min('') jaqy646cre,
     
     max(case
           when t.aomda = 101 then
            t.aoimp * (pq_cosecha_sentinel.fn_tipo_cambio_fijo(fecpro))
           else
            t.aoimp
         end) jaqy646mmn,
     t.aoimp jaqy646mto,
     --* b.scnom jaqy646age , 
     -- upper( b.scnom )  jaqy646age,
     pq_cosecha_sentinel.FN_AGENCIA_HIST(a.jaql114suc) jaqy646age,
     --* upper(d.regnom) jaqy646reg,
     --upper( d.regnom )  jaqy646reg, 
     pq_cosecha_sentinel.FN_REGION_HIST(a.jaql114fech, a.jaql114suc) jaqy646reg,
     a.jaql114ase jaqy646ase,
     (select upper(x.tonom)
        from fst004 x
       where x.modulo = a.jaql114mod
         and x.totope = a.jaql114top) jaqy646pbt,
     (select upper(y.mdnom) from fst003 y where y.modulo = a.jaql114mod) jaqy646pbm,
     
     REPLACE(TRIM(a.jaql114tcrd), 'MICRO EMPRESA', 'MICROEMPRESAS') || case
       when jaql114tcrd = 'CONSUMO' and substr(a.JAQL114RUBR, 11, 3) = '015' then
        ' REVOLVENTE'
       WHEN jaql114tcrd = 'CONSUMO' and
            substr(a.JAQL114RUBR, 11, 3) <> '015' THEN
        ' NO-REVOLVENTE'
       when jaql114tcrd = 'PEQUEÑA EMPRESA' then
        ' ' || JAQL114SECT
     END jaqy646sbs,
     
     sum(a.jaql114sdmo) jaqy646sal,
     sum(a.jaql114sdmn) jaqy646smn,
     a.jaql114datr jaqy646dat,
     a.jaql114pais jaqy646pai,
     a.jaql114tdoc jaqy646tdo,
     a.jaql114ndoc jaqy646ndo,
     a.JAQL114stat jaqy646esc,
    -- t.aofval jaqy646fed,
     case when t.aofval is null then a.jaql114fval else t.aofval end jaqy646fed,
     to_date('01010001', 'DDMMRRRR') jaqy646fca,
     -- max(case when  substr(a.jaql114rubr,1,4) = '1415' or substr(a.jaql114rubr,1,4) = '1425' then 'V' else 'N' end) jaqy646est
     a.jaql114rubr jaqy646rub,
     (select i.sng001ori from sng001 i where i.sng001inst = a.jaql114inst) jaqy646aori,
     a.jaql114inst jaqy646ains
    
      from fsd010 /*_22022016*/ t, jaql114 a --, fst001 b, FST811 c, fst810 d 
     where t.pgcod(+) = a.jaql114emp
       and t.aosuc(+) = a.jaql114suc
       and t.aomda(+) = a.jaql114mda
       and t.aopap(+) = a.jaql114pap
       and t.aocta(+) = a.jaql114cta
       and t.aooper(+) = a.jaql114oper
       and t.aosbop(+) = a.jaql114sbop
       and t.aotope(+) = a.jaql114top
       and t.aomod(+) = a.jaql114mod
       and substr(a.jaql114rubr, 5, 2) not in '09'
       and ---rmogrovejo 3-10-2017
          -- b.sucurs(+) = a.jaql114suc and 
          -- b.sucurs = c.oficod and
          -- d.regcod = c.regcod and       
          -- d.pgcod = c.pgcod and 
          -- c.regcod < 100 and   
          -- a.jaql114suc = c.oficod and 
          -- c.ofisuc = 'S'     and 
           a.jaql114fech = fecpro --to_date('20130731','rrrrmmdd')  
     --       and a.jaql114cta = 1098--1965188--rmogrovejo
      --      and a.jaql114oper = 1698471
   --         and a.jaql114cta = 1963822--1965188--rmogrovejo
    --      and a.jaql114cta in (232486, 104883, 105084, 105210, 105642, 118272)--verificar
    --      and a.jaql114oper  in (2336947,1913052,1914790,1916663, 1919947,2812228)--verificar        
     group by a.jaql114fech,
              a.jaql114emp,
              a.jaql114suc,
              a.jaql114cta,
              a.jaql114oper,
              a.jaql114pap,
              a.jaql114mod,
              a.jaql114sbop,
              a.jaql114top,
              a.jaql114mda,
              --'' jaqy646cre,  
              -- case when t.aomda = 101 then t.aoimp*( select t.cotcbv from fsh005 t  where a.jaql114fech = t.cofdes and t.moneda = 101 ) else t.aoimp end ,
              t.aoimp,
              --upper(b.scnom)   ,
              --upper(d.regnom),          
              a.jaql114ase,
              a.jaql114tcrd,
              a.JAQL114SECT,
              a.jaql114datr,
              a.jaql114pais,
              a.jaql114tdoc,
              a.jaql114ndoc,
              a.JAQL114stat,
              -- t.aofval,--romgrovejo 
             case when t.aofval is null then a.jaql114fval else t.aofval end,
              a.jaql114rubr,
              to_date('01010001', 'DDMMRRRR'),
              a.jaql114inst
    
    ;

  fecha  date;
  insta  number(17) := 0;
  origen number(2) := 0;

  jaqy646rubN NUMBER(16) := 0;
  -- JAQY646SBSV VARCHAR(100) ;

  lc_codcam   varchar2(20); ---rmogrovejo 3-10-2017 --cod de campaña 
  lc_nomcam   varchar2(100); ---rmogrovejo 3-10-2017 --Nom de campaña 
  lc_seccam   varchar2(90); ---rmogrovejo 3-11-2017 --sec de campaña 
  lc_concam   varchar2(200); ---rmogrovejo 3-11-2017 --concatenar nom + sec 



begin

  --fecha := to_date('30112013','DDMMRRRR');

  --create table jaqy646_bk_20150127 as select * from  jaqy646;

  --delete jaqy646 t where t.jaqy646fec >= '31072013'
  --select * from jaqy646 t where t.jaqy646fec >= '31072013'

  --      for m in mes loop
  for c in cre(F_FEC) loop
  
    begin
    --codigo campaña
    lc_codcam := pq_consechas.fn_campania_cred(p_n_modulo => c.JAQY646MOD,
                                               p_n_suc    => c.jaqy646suc,
                                               p_n_mda    => c.jaqy646mda,
                                               p_n_pap    => c.jaqy646pap,
                                               p_n_cta    => c.jaqy646cta,
                                               p_n_oper   => c.jaqy646ope,
                                               p_n_sbop   => c.jaqy646sop,
                                               p_n_tipope => c.jaqy646top,
                                               p_d_fecdes => c.jaqy646fed ,--c.jaqy646fec
                                               p_c_flgtip => 'D');
  
    --nombre campaña
    lc_nomcam := pq_cosecha_sentinel.fn_nom_campana(cod_cam => lc_codcam);
    
    --Sec campaña
    lc_seccam := pq_cosecha_sentinel.fn_sec_campana(cod_cam => lc_codcam);
    
     --Concatena Sec-campaña
    lc_concam:= lc_nomcam || '-' || lc_seccam;
    
      insert into jaqy646a
        (JAQY646FEC,
         JAQY646PGP,
         JAQY646SUC,
         JAQY646CTA,
         JAQY646OPE,
         JAQY646PAP,
         JAQY646MOD,
         JAQY646SOP,
         JAQY646TOP,
         JAQY646MDA,
         JAQY646CRE,
         JAQY646MMN,
         JAQY646MTO,
         JAQY646AGE,
         JAQY646REG,
         JAQY646ASE,
         JAQY646PBM,
         JAQY646PBT,
         JAQY646SBS,
         JAQY646SAL,
         JAQY646SMN,
         JAQY646DAT,
         JAQY646PAI,
         JAQY646TDO,
         JAQY646NDO,
         JAQY646ESC,
         JAQY646FED,
         JAQY646FCA,
         JAQY646RUB,
         jaqy646ains,
         jaqy646aori,
         JAQY646CCA,
         JAQY646DCA, /*JAQY646EST*/
         JAQY646CCAM)
      values
        (c.JAQY646FEC,
         c.JAQY646PGP,
         c.JAQY646SUC,
         c.JAQY646CTA,
         c.JAQY646OPE,
         c.JAQY646PAP,
         c.JAQY646MOD,
         c.JAQY646SOP,
         c.JAQY646TOP,
         c.JAQY646MDA,
         c.JAQY646CRE,
         c.JAQY646MMN,
         c.JAQY646MTO,
         c.JAQY646AGE,
         c.JAQY646REG,
         c.JAQY646ASE,
         c.JAQY646PBM,
         c.JAQY646PBT,
         c.JAQY646SBS,
         c.JAQY646SAL,
         c.JAQY646SMN,
         c.JAQY646DAT,
         c.JAQY646PAI,
         c.JAQY646TDO,
         c.JAQY646NDO,
         c.JAQY646ESC,
         c.JAQY646FED,
         c.JAQY646FCA,
         c.jaqy646rub,
         c.jaqy646ains,
         c.jaqy646aori,
         lc_codcam,
         lc_nomcam, /*c.jaqy646est*/
         lc_concam);--concatenar
      commit;
    exception
      when others then
        null;
        dbms_output.put_line(sqlerrm || ':' || c.JAQY646CTA || '|' ||
                             c.JAQY646OPE);
    end;
  end loop;
  commit;
  --   end loop;

end;

----------------------------------------------------------------------------


procedure SP_CR_ACTUALIZA_DIMENSIONES(F_FEC in varchar) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_ACTUALIZA_HILOS
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  
  cursor cre(fecpro VARCHAR) is 
  select /*+ all_rows */
    a.jaqy646fec, 
    a.jaqy646pgp, 
    a.jaqy646suc, 
    a.jaqy646cta, 
    a.jaqy646ope, 
    a.jaqy646pap, 
    a.jaqy646mod, 
    a.jaqy646sop, 
    a.jaqy646top, 
    a.jaqy646mda,
    a.jaqy646mmn, 
    a.jaqy646mto,
    a.jaqy646ains,
    pq_consechas.fn_modalidad(a.jaqy646pgp,a.jaqy646mod,a.jaqy646mda,a.jaqy646cta,a.jaqy646ope,a.jaqy646sop,a.jaqy646top,a.jaqy646ains )   jaqy646amoda , 
    pq_consechas.fn_cl_actividad_econom(r.pepais, r.petdoc,r.pendoc,decode(r.petdoc,9,'J','F')) jaqy646acte,
    pq_consechas.fn_segmento(r.pepais,r.petdoc, r.pendoc, to_number(to_char(a.jaqy646fed,'rrrr')),to_number(to_char(a.jaqy646fed,'mm')) ) jaqy646aseg  ,
    pq_consechas.fn_rango_desembolso(a.jaqy646mmn) jaqy646amon , 
    a.jaqy646cca,--rmogrovejo 09-10-2017
    a.jaqy646dca, --rmogrovejo 09-10-2017                  
    pq_consechas.fn_producto(a.jaqy646mod) jaqy646amod , 
    pq_consechas.fn_Tipo_credito(a.jaqy646rub,a.jaqy646mod,a.jaqy646suc,a.jaqy646mda,a.jaqy646pap,a.jaqy646cta,a.jaqy646ope,a.jaqy646sop,a.jaqy646top,a.jaqy646fec) jaqy646asbs,
    UPPER(pq_consechas.fn_Comite_Aprobador(a.jaqy646ains, A.JAQY646MOD)) JAQY646ACOM    
    from JAQY646A  a , fsr008 r 
     where to_char( a.jaqy646fec,'rrrrmm') = fecpro  
     and  a.jaqy646fed between to_date(fecpro||'01','rrrrmmdd') and last_day(to_date(fecpro||'01','rrrrmmdd')) 
     and r.ctnro = a.jaqy646cta and r.cttfir = 'T' and r.ttcod = 1
     and r.pgcod = 1;  
  
  /*select \*+ all_rows *\
    last_day(c.aofval) jaqy646fec, 
    c.pgcod jaqy646pgp,
    c.aosuc jaqy646suc, 
    c.aocta jaqy646cta, 
    c.aooper jaqy646ope, 
    c.aopap jaqy646pap, 
    c.aomod jaqy646mod, 
    c.aosbop jaqy646sop, 
    c.aotope jaqy646top, 
    c.aomda jaqy646mda, 
    '' jaqy646cre, 
   case when c.aomda = 101 then c.aoimp*( select t.cotcbv from fsh005 t  where last_day(c.aofval) = t.cofdes and t.moneda = 101 ) else c.aoimp end jaqy646mmn,       
    c.aoimp jaqy646mto,   
    (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  jaqy646age,
    (select j.jaqy646reg from agencias_c j where j.jaqy646fec = last_day(c.aofval) and j.jaqy646age =  (select ag.scnom from fst001 ag where ag.pgcod = 1 and ag.sucurs = c.aosuc )  ) jaqy646reg, 
     fn_analista_credito(c.aomod,c.aosuc,c.aomda,c.aopap,c.aocta,c.aooper,c.aosbop,c.aotope) jaqy646ase ,
      (select upper(x.tonom) from fst004 x where x.modulo = c.aomod and x.totope = c.aotope ) jaqy646pbt,
      (select upper(y.mdnom) from fst003 y where y.modulo = c.aomod ) jaqy646pbm,   
     --fn_csbs(r.pepais,r.petdoc, r.pendoc, last_day(c.aofval))  jaqy646sbs,
     SP_CR_PREN_SBS(c.aocta, c.aooper,F_FEC)  jaqy646sbs,
     c.aoimp JAQY646SAL , 
     case when c.aomda = 101 then c.aoimp*( select t.cotcbv from fsh005 t  where last_day(c.aofval) = t.cofdes and t.moneda = 101 ) else c.aoimp end jaqy646smn,       
     fn_dias_atraso( last_day(c.aofval) , --fecha de proceso
      c.pgcod ,c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope, 99, c.aofvto) jaqy646dat,                
      r.pepais jaqy646pai, 
      r.petdoc jaqy646tdo, 
      r.pendoc jaqy646ndo, 
      99 jaqy646esc,
      c.aofval jaqy646fed, 
      to_date('01010001','DDMMRRRR') jaqy646fca,
      SP_CR_PREN_RUBRO(c.aocta, c.aooper,F_FEC)  jaqy646rub 
    from fsd010\*@\*produ*\*\ c , fsr008\**\ r  
     where to_char( c.aofval,'rrrrmm') = fecpro and c.aomod = 108 
     and c.aosbop =0
     and r.pgcod = c.pgcod
     and r.ctnro = c.aocta
     and to_char(c.aofe99, 'RRRRMM') = fecpro
     and r.cttfir = 'T' and r.ttcod = 1     */
     --;  
    
   fecha date;
   insta number(17) := 0;
   origen number(2) := 0;
     
  begin 
    
     -- fecha := to_date('31102015','DDMMRRRR');
      
       
      --create table jaqy646_bk_20150127 as select * from  jaqy646;
      
      --delete jaqy646 t where t.jaqy646fec >= '31072013'
      --select * from jaqy646 t where t.jaqy646fec >= '31072013'
     -- fecha := TO_CHAR(fecpro,'RRRRMM'); 
      
      for c in cre(F_FEC) loop 
        
          begin 
            
            UPDATE jaqy646a T SET 
                T.JAQY646ACTE = c.jaqy646acte,
                T.JAQY646AMOD = c.JAQY646AMOD,            
                T.JAQY646ASEG = c.JAQY646ASEG,
                T.JAQY646ASBS = c.JAQY646ASBS,
                T.JAQY646ASBS2 = c.JAQY646ASBS,
                T.JAQY646ACOM = c.JAQY646ACOM,
                T.JAQY646AMON = c.JAQY646AMON,
                T.Jaqy646cca = c.jaqy646cca,--rmogrovejo 10-10-2017
                T.Jaqy646dca = c.jaqy646dca, --rmogrovejo
                T.JAQY646AMODA = c.JAQY646AMODA 
            WHERE 
                T.JAQY646FEC = c.JAQY646FEC and 
                T.JAQY646PGP = c.JAQY646PGP and 
                T.JAQY646SUC = c.JAQY646SUC and 
                T.JAQY646CTA = c.jaqy646cta and 
                T.JAQY646OPE = c.jaqy646ope and 
                T.JAQY646PAP = c.jaqy646pap and 
                T.JAQY646MOD = c.jaqy646mod and
                T.JAQY646SOP = c.jaqy646sop and 
                T.JAQY646TOP = c.jaqy646top and 
                T.JAQY646MDA = c.jaqy646mda;
              
            commit;     
          
             exception when others then 
               null;
               dbms_output.put_line(sqlerrm||':'|| c.JAQY646CTA||'|'||c.JAQY646OPE);
             end;          
  end loop ;
    
    
END;

 

----------------------------------------------------------------------------



----------------------------------------------------------------------------
procedure SP_CR_CARGA_HILOS is

    -- *****************************************************************
    -- Nombre                     : SP_CR_ACT_ASESOR
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  

CURSOR FECHA IS 
select /*+ ALL_ROWS */ TO_CHAR(T.JAQL114FECH,'RRRR/MM/DD') JAQY646FEC from jaql114 T 
GROUP BY T.JAQL114FECH;


CURSOR PERIODO IS 
select /*+ ALL_ROWS */
 TO_CHAR(T.JAQL114FECH, 'RRRRMM') JAQY646FEC
  from JAQL114 T
 WHERE T.JAQL114FECH >= to_date('20130731', 'rrrrmmdd')
 GROUP BY T.JAQL114FECH;

lc_prcsobend varchar2(500);
ln_count number(10);
ln_limit number(18);

ln_indpro NUMBER(18);
LNINI NUMBER ;
LNFIN NUMBER ;


job_id number;
NROCRE NUMBER  := 6000 ; 




BEGIN

     execute immediate 'ALTER SESSION SET commit_wait=''NOWAIT''';
     execute immediate 'ALTER SESSION SET commit_logging=''BATCH''';
    -- execute immediate 'ALTER SESSION SET optimizer_mode=''FIRST_ROWS_10''';

   --SELECT max(t.cod) FROM jaqy610 t;
   --SELECT max(t.NRO)  INTO ln_limit  FROM CREDITOSv t;  --56412
   
  -- select CEIL(56412/6000)  from DUAL;

    LNINI := 1; 
    LNFIN := 1;
   
  -- truncate table TABLA_AMP;
   FOR P IN PERIODO LOOP
       
    sys.dbms_job.submit(
          job_id,
          what => 'begin          
                  pq_cosecha_sentinel.GENERA_REPORTE('''||P.JAQY646FEC||''' ); 
                   end;',
          next_date => sysdate
           );            
     commit;       
   END LOOP;
  
  
  
   /*FOR P IN FECHA LOOP
       
    sys.dbms_job.submit(
          job_id,
          what => 'begin          
                  pq_cosecha_sentinel.SP_CR_CARGA_INICIAL(to_date('''||P.JAQY646FEC||''',''rrrr/mm/dd'')   ); 
                   end;',
          next_date => sysdate
           );            
     commit;       
   END LOOP;*/
   
  /* FOR F IN FECHAS LOOP
       
    sys.dbms_job.submit(
          job_id,
          what => 'begin          
                  pq_cosecha_sentinel.SP_CR_INSTANCIA('''|| F.JAQY646FEC  ||''' ); 
                   end;',
          next_date => sysdate
           );            
     commit;       
   END LOOP;*/
   
  
  /* FOR i IN 1 .. CEIL(ln_limit/NROCRE) LOOP

      --ln_count := i;
      
      LNINI  := LNFIN; 
      LNFIN  := LNFIN + NROCRE;

      sys.dbms_job.submit(
          job_id,
          what => 'begin          
                  pq_venta.SP_CR_PAGOS('||LNINI||','||LNFIN||' ); 
                   end;',
          next_date => sysdate
           );            
     commit;
    END LOOP;  */
    
END;
---------------------------------------------------------------------------------------------------------------
 

  PROCEDURE GENERA_REPORTE_DESEM( F_FEC VARCHAR ) 
    IS 
  
-----------------------------sbs
  
  CURSOR CSBS  IS      
  --rms
  
/*desembolsos*/        
select /*+all_rows*/         
         f.jaqy646fec fecpro, 
         decode(f.jaqy646tdo,21,'DNI',9,'RUC',2,'C/E','X') tipdoc,
         f.jaqy646ndo numdoc,
         lpad(f.jaqy646cta,9,0)||lpad(f.jaqy646mda,3,0)||lpad(f.jaqy646ope,9,0) codcre, 
         a.jaqy646fed fecdes ,
         a.jaqy646mmn mondes , 
         --case when f.jaqy646aori = 4 then f.jaqy646smn- f.jaqy646mto3 else f.jaqy646smn end salcap , 
         sum(f.jaqy646smn)  salcap ,
         f.jaqy646dat diatr ,
         (max(a.jaqy646mmn) - sum(f.jaqy646smn)) recu,
         a.tipo tipo,
         100 codreg , 
         a.jaqy646reg region , 
         200 codage ,
         a.jaqy646age agen, 
         a.jaqy646ase analista ,         
         (select d.ubnom from fst746 d where d.ubuser = a.jaqy646ase ) nomana , 
         a.jaqy646acte, 
         a.jaqy646amod, 
         a.jaqy646aseg, 
         a.jaqy646asbs, 
         a.jaqy646acom ,
         a.jaqy646amon, 
         a.jaqy646amoda, 
         a.jaqy646cta,
         a.jaqy646ope,
         a.jaqy646mda, 
         a.zona, --cambio 2016 06 17       
         f.jaqy646cca,--rmogrovejo 
         f.jaqy646dca, --rmogrovejo
         f.jaqy646ccam --rmogrovejo 3-11-2017
         from 
         jaqy646a f ,         
         (
         select 
         f.jaqy646fec, 
         f.jaqy646pgp, 
         f.jaqy646suc, 
         f.jaqy646cta, 
         f.jaqy646ope, 
         f.jaqy646pap, 
         f.jaqy646mod, 
         f.jaqy646mda, 
         f.jaqy646sop, 
         f.jaqy646top, 
         f.jaqy646mmn, 
         f.jaqy646fed, 
         upper(TRIM(f.jaqy646reg)) jaqy646reg,
         upper(TRIM(f.jaqy646age)) jaqy646age,
         --nvl(f.jaqy646ase, fn_analista_credito(f.jaqy646mod,f.jaqy646suc,f.jaqy646mda,f.jaqy646pap,f.jaqy646cta,f.jaqy646ope,f.jaqy646sop,f.jaqy646top)   ) jaqy646ase,         
         NVL(f.jaqy646ase,'NO REGISTRADO') jaqy646ase ,         
         upper(TRIM(f.jaqy646acte)) jaqy646acte, 
         upper(TRIM(f.jaqy646amod)) jaqy646amod, 
         upper(TRIM(f.jaqy646aseg)) jaqy646aseg, 
         upper(TRIM(f.jaqy646asbs2)) jaqy646asbs, 
         upper(nvl(TRIM(f.jaqy646acom),'NO REGISTRADO')) jaqy646acom ,
         upper(TRIM(f.jaqy646amon)) jaqy646amon, 
         upper(TRIM(f.jaqy646amoda)) jaqy646amoda,
         case when  
         /*prendario*/  
         ( f.jaqy646mod in (108) and f.jaqy646sop = 0 and  f.jaqy646aori is null  ) then 'Prendario' 
         /*ampliaciones*/
         when   (  f.jaqy646mod not in (108) and f.jaqy646aori = 4 ) then 'Ampliacion' 
         /*normales*/
         when (   f.jaqy646mod not in (108) and nvl(f.jaqy646aori,0) in ( 0,3, 10 ) ) then 'Normal'           
         end tipo, 
          pq_cosecha_sentinel.FN_CR_ZONA_ACTUAL( f.jaqy646suc) zona ----cambio 2016 06 17 
          from jaqy646a f
         where f.jaqy646fed between to_date(F_FEC||'01', 'RRRRMMDD') and 
               last_day(to_date(F_FEC||'01', 'RRRRMMDD'))
          and TO_CHAR(f.jaqy646fec, 'MMRRRR') = to_char(f.jaqy646fed, 'MMRRRR') 
           --AND UPPER(f.jaqy646reg) like &region || '%'         
           and f.jaqy646mod not in (200,33)  
        -- and f.jaqy646esc not in (33,34,61,120) --no refinanciados 
         and f.jaqy646mod not in (117,116) --no lineas 
         and (
         /*prendarios*/
         ( f.jaqy646mod in (108) and f.jaqy646sop = 0 and  f.jaqy646aori is null  ) or 
         /*ampliaciones*/
         (  f.jaqy646mod not in (108) and f.jaqy646aori = 4 ) or 
         /*normales*/
         (   f.jaqy646mod not in (108) and nvl(f.jaqy646aori,0) in ( 0, 3, 10 ) )
         )
        
         
          ) a
          
            where f.jaqy646pgp = a.jaqy646pgp
            and f.jaqy646ope = a.jaqy646ope
             and f.jaqy646pap = a.jaqy646pap
             and f.jaqy646mda = a.jaqy646mda
             AND f.JAQY646CTA = a.JAQY646CTA
             and f.jaqy646fec >= a.jaqy646fec    
          --   and f.JAQY646CTA = 1098  --rmogrovejo
           --  and f.jaqy646ope = 1698471
        
        
--and f.jaqy646cta in (1629017,2073258,1970829,594889,2080433,265587,1985852,1602943)     --rms return
             
           group by            
             f.jaqy646fec , 
             decode(f.jaqy646tdo,21,'DNI',9,'RUC',2,'C/E','X') ,
             f.jaqy646ndo ,
             lpad(f.jaqy646cta,9,0)||lpad(f.jaqy646mda,3,0)||lpad(f.jaqy646ope,9,0) , 
             a.jaqy646fed  ,
             a.jaqy646mmn  ,         
             f.jaqy646dat  ,
             --(sum(f.jaqy646mmn) - sum(f.jaqy646smn)) ,
             a.tipo, 
             --1 codreg , 
             a.jaqy646reg  , 
             --2 codage ,
             a.jaqy646age, 
             a.jaqy646ase,
             a.jaqy646acte, 
             a.jaqy646amod, 
             a.jaqy646aseg, 
             a.jaqy646asbs, 
             a.jaqy646acom ,
             a.jaqy646amon, 
             a.jaqy646amoda ,
             a.jaqy646cta,
             a.jaqy646ope,
             a.jaqy646mda  , 
             a.zona,
             f.jaqy646cca,--rmogrovejo 
             f.jaqy646dca, --rmogrovejo
             f.jaqy646ccam --rmogrovejo
             
             --nvl(f.jaqy646ase, fn_analista_credito(f.jaqy646mod,f.jaqy646suc,f.jaqy646mda,f.jaqy646pap,f.jaqy646cta,f.jaqy646ope,f.jaqy646sop,f.jaqy646top)   ) 
             --(select d.ubnom from fst746 d where d.ubuser = f.jaqy646ase ) nomana                
              ;   
  
  
  
   /* select \*+all_rows parallel(f,6)*\
        -- f.jaqy646cta , f.jaqy646ope,
         f.jaqy646fec fecpro, 
         decode(f.jaqy646tdo,21,'DNI',9,'RUC',2,'C/E','X') tipdoc,
         f.jaqy646ndo numdoc,
         lpad(f.jaqy646cta,9,0)||lpad(f.jaqy646mda,3,0)||lpad(f.jaqy646ope,9,0) codcre, 
         f.jaqy646fed fecdes ,
         f.jaqy646mmn mondes , 
         --case when f.jaqy646aori = 4 then f.jaqy646smn- f.jaqy646mto3 else f.jaqy646smn end salcap , 
         f.jaqy646smn  salcap ,
         f.jaqy646dat diatr ,
         (f.jaqy646mmn - f.jaqy646smn) recu,
         case when  
         \*prendario*\  
         ( f.jaqy646mod in (108) and f.jaqy646sop = 0 and  f.jaqy646aori is null  ) then 'Prendario' 
         \*ampliaciones*\
         when   (  f.jaqy646mod not in (108) and f.jaqy646aori = 4 ) then 'Ampliacion' 
         \*normales*\
         when (   f.jaqy646mod not in (108) and nvl(f.jaqy646aori,0) in ( 0, 10 ) ) then 'Normal'           
         end tipo, 
         1 codreg , 
         f.jaqy646reg region , 
         2 codage ,
         f.jaqy646age agen, 
         f.jaqy646ase analista , 
        -- fn_analista_credito(f.jaqy646mod,f.jaqy646suc,f.jaqy646mda,f.jaqy646pap,f.jaqy646cta,f.jaqy646ope,
        -- f.jaqy646sop,f.jaqy646top) ,
         (select d.ubnom from fst746 d where d.ubuser = f.jaqy646ase ) nomana           
         
          from jaqy646a f
         where f.jaqy646fed between to_date(F_FEC||'01', 'RRRRMMDD') and
               last_day(to_date(F_FEC||'01', 'RRRRMMDD'))
           and TO_CHAR(f.jaqy646fec, 'MMRRRR') = to_char(jaqy646fed, 'MMRRRR')
           --AND UPPER(f.jaqy646reg) like &region || '%'         
         and f.jaqy646esc not in (33,34,61,120) --no refinanciados 
         and f.jaqy646mod not in (117,116) --no lineas 
         and (
         \*prendarios*\
         ( f.jaqy646mod in (108) and f.jaqy646sop = 0 and  f.jaqy646aori is null  ) or 
         \*ampliaciones*\
         (  f.jaqy646mod not in (108) and f.jaqy646aori = 4 ) or 
         \*normales*\
         (   f.jaqy646mod not in (108) and nvl(f.jaqy646aori,0) in ( 0,3, 10 ) )
         )
         \*and  not exists (select 1
                           from apacheco.cred_desdol dol 
                          where c_crite1 = 'S'
                            and dol.pgcod = f.jaqy646pgp
                            and dol.AOMOD = f.jaqy646mod 
                            --and dol.AOSUC = h15.aosuc 
                            and dol.AOMDA = f.jaqy646mda 
                            and dol.AOPAP = f.jaqy646pap
                            and dol.AOCTA = f.jaqy646cta
                            and dol.AOOPER= f.jaqy646ope  
                            and dol.AOSBOP= f.jaqy646sop  
                            and dol.AOTOPE= f.jaqy646top  
                            and to_char(dol.fecha,'rrrrmm') = F_FEC 
                        ) *\
        -- and f.jaqy646ase is null
           

union 
 select \*+all_rows parallel(f,6)*\         
         f.jaqy646fec fecpro, 
         decode(f.jaqy646tdo,21,'DNI',9,'RUC',2,'C/E','X') tipdoc,
         f.jaqy646ndo numdoc,
         lpad(f.jaqy646cta,9,0)||lpad(f.jaqy646mda,3,0)||lpad(f.jaqy646ope,9,0) codcre, 
         a.jaqy646fed fecdes ,
         a.jaqy646mmn mondes , 
         --case when f.jaqy646aori = 4 then f.jaqy646smn- f.jaqy646mto3 else f.jaqy646smn end salcap , 
         sum(f.jaqy646smn)  salcap ,
         f.jaqy646dat diatr ,
         (max(a.jaqy646mmn) - sum(f.jaqy646smn)) recu,
         a.tipo tipo,
         100 codreg , 
         f.jaqy646reg region , 
         200 codage ,
         f.jaqy646age agen, 
         a.jaqy646ase analista ,         
         (select d.ubnom from fst746 d where d.ubuser = a.jaqy646ase ) nomana           
         from 
         jaqy646a f ,
         (select 
         f.jaqy646fec, 
         f.jaqy646pgp, 
         f.jaqy646suc, 
         f.jaqy646cta, 
         f.jaqy646ope, 
         f.jaqy646pap, 
         f.jaqy646mod, 
         f.jaqy646mda, 
         f.jaqy646sop, 
         f.jaqy646top, 
         f.jaqy646mmn, 
         f.jaqy646fed, 
         nvl(f.jaqy646ase, fn_analista_credito(f.jaqy646mod,f.jaqy646suc,f.jaqy646mda,f.jaqy646pap,f.jaqy646cta,f.jaqy646ope,f.jaqy646sop,f.jaqy646top)   ) jaqy646ase,         
         case when  
         \*prendario*\  
         ( f.jaqy646mod in (108) and f.jaqy646sop = 0 and  f.jaqy646aori is null  ) then 'Prendario' 
         \*ampliaciones*\
         when   (  f.jaqy646mod not in (108) and f.jaqy646aori = 4 ) then 'Ampliacion' 
         \*normales*\
         when (   f.jaqy646mod not in (108) and nvl(f.jaqy646aori,0) in ( 0, 10 ) ) then 'Normal'           
         end tipo
          from jaqy646a f
         where f.jaqy646fed between to_date(F_FEC||'01', 'RRRRMMDD') and
               last_day(to_date(F_FEC||'01', 'RRRRMMDD'))
           and TO_CHAR(f.jaqy646fec, 'MMRRRR') = to_char(jaqy646fed, 'MMRRRR')
           --AND UPPER(f.jaqy646reg) like &region || '%'         
         and f.jaqy646esc not in (33,34,61,120) --no refinanciados 
         and f.jaqy646mod not in (117,116) --no lineas 
         and (
         \*prendarios*\
         ( f.jaqy646mod in (108) and f.jaqy646sop = 0 and  f.jaqy646aori is null  ) or 
         \*ampliaciones*\
         (  f.jaqy646mod not in (108) and f.jaqy646aori = 4 ) or 
         \*normales*\
         (   f.jaqy646mod not in (108) and nvl(f.jaqy646aori,0) in ( 0, 3, 10 ) )
         )
         \*and  not exists (select 1
                           from apacheco.cred_desdol dol 
                          where c_crite1 = 'S'
                            and dol.pgcod = f.jaqy646pgp
                            and dol.AOMOD = f.jaqy646mod 
                            --and dol.AOSUC = h15.aosuc 
                            and dol.AOMDA = f.jaqy646mda 
                            and dol.AOPAP = f.jaqy646pap
                            and dol.AOCTA = f.jaqy646cta
                            and dol.AOOPER= f.jaqy646ope  
                            and dol.AOSBOP= f.jaqy646sop  
                            and dol.AOTOPE= f.jaqy646top  
                            and to_char(dol.fecha,'rrrrmm') = F_FEC 
                        ) *\
         
          ) a
          
            where f.jaqy646pgp = a.jaqy646pgp
            and f.jaqy646ope = a.jaqy646ope
             and f.jaqy646pap = a.jaqy646pap
             and f.jaqy646mda = a.jaqy646mda
             AND f.JAQY646CTA = a.JAQY646CTA
             and f.jaqy646fec > a.jaqy646fec           
             
           group by            
             f.jaqy646fec , 
             decode(f.jaqy646tdo,21,'DNI',9,'RUC',2,'C/E','X') ,
             f.jaqy646ndo ,
             lpad(f.jaqy646cta,9,0)||lpad(f.jaqy646mda,3,0)||lpad(f.jaqy646ope,9,0) , 
             a.jaqy646fed  ,
             a.jaqy646mmn  ,         
             f.jaqy646dat  ,
             --(sum(f.jaqy646mmn) - sum(f.jaqy646smn)) ,
             a.tipo, 
             --1 codreg , 
             f.jaqy646reg  , 
             --2 codage ,
             f.jaqy646age, 
             a.jaqy646ase--,
             --nvl(f.jaqy646ase, fn_analista_credito(f.jaqy646mod,f.jaqy646suc,f.jaqy646mda,f.jaqy646pap,f.jaqy646cta,f.jaqy646ope,f.jaqy646sop,f.jaqy646top)   ) 
             --(select d.ubnom from fst746 d where d.ubuser = f.jaqy646ase ) nomana                
              ;*/
  ERROR VARCHAR(200);  
  lc_codcam   varchar2(20); ---rmogrovejo 3-10-2017 --cod de campaña 
  lc_nomcam   varchar2(100); ---rmogrovejo 3-10-2017 --Nom de campaña 
  lc_seccam   varchar2(90); ---rmogrovejo 3-11-2017 --sec de campaña 
  lc_concam   varchar2(200); ---rmogrovejo 3-11-2017 --concatenar nom + sec 
  ld_fechamin date;
  JAQY646MOD_a number;
  jaqy646suc_a number;
  jaqy646mda_a number;
  jaqy646pap_a number;
  jaqy646cta_a number;
  jaqy646ope_a number;
  jaqy646sop_a number;
  jaqy646top_a number;
  jaqy646fed_a date;
 
     
  BEGIN
    
  
     FOR a IN CSBS LOOP    
       
     
     ----jaqy646a
     begin
       select min(jaqy646fec)
       into ld_fechamin
       from jaqy646a b
       where b.jaqy646cta= a.JAQY646CTA 
       and   b.jaqy646ope= a.jaqy646ope 
       and   b.jaqy646mda= a.jaqy646mda
       and rownum=1;
    exception 
      WHEN OTHERS THEN 
        null;
     end;
     
     begin
       
      select c.JAQY646MOD,c.jaqy646suc,c.jaqy646mda,c.jaqy646pap,c.jaqy646cta,
           c.jaqy646ope,c.jaqy646sop, c.jaqy646top,c.jaqy646fed /*c.jaqy646fec*/              
      into JAQY646MOD_a,jaqy646suc_a,jaqy646mda_a,jaqy646pap_a,jaqy646cta_a,
           jaqy646ope_a,jaqy646sop_a, jaqy646top_a,jaqy646fed_a --jaqy646fec_a
       from jaqy646a c
      where c.jaqy646fec = ld_fechamin
       and c.jaqy646cta= a.JAQY646CTA  
       and c.jaqy646ope= a.jaqy646ope 
       and c.jaqy646mda= a.jaqy646mda
        and rownum=1;
     exception 
     WHEN OTHERS THEN 
            null;
     end;
     
--select min(jaqy646fec) from jaqy646a where jaqy646cta=122721 and jaqy646ope=487252 and jaqy646mda=0;

--select * from jaqy646a where jaqy646fec='31032014'and jaqy646cta=122721 and jaqy646ope=487252 and jaqy646mda=0;
  
  --    begin
    --codigo campaña
    lc_codcam := pq_consechas.fn_campania_cred(p_n_modulo => JAQY646MOD_a, --c.JAQY646MOD,
                                               p_n_suc    => jaqy646suc_a,--c.jaqy646suc,
                                               p_n_mda    => jaqy646mda_a,--c.jaqy646mda,
                                               p_n_pap    => jaqy646pap_a,--c.jaqy646pap,
                                               p_n_cta    => jaqy646cta_a,--c.jaqy646cta,
                                               p_n_oper   => jaqy646ope_a,--c.jaqy646ope,
                                               p_n_sbop   => jaqy646sop_a,--c.jaqy646sop,
                                               p_n_tipope => jaqy646top_a,--c.jaqy646top,
                                               p_d_fecdes => jaqy646fed_a,-- jaqy646fec_a,--c.jaqy646fec,
                                               p_c_flgtip => 'D');
  
    --nombre campaña
    lc_nomcam := pq_cosecha_sentinel.fn_nom_campana(cod_cam => lc_codcam);
 -- end;
 
  --Sec campaña
    lc_seccam := pq_cosecha_sentinel.fn_sec_campana(cod_cam => lc_codcam);
    
     --Concatena Sec-campaña
    lc_concam:= lc_nomcam || '-' || lc_seccam;
      
      BEGIN 
         insert into jaqy646b 
          (
            jaqy646bfec,  
            jaqy646btdoc, 
            jaqy646bndoc,
            jaqy646bccre, 
            jaqy646bfecd, 
            jaqy646bmdes, 
            jaqy646bsalc, 
            jaqy646bdiat, 
            jaqy646brec,  
            jaqy646btip,  
            jaqy646bcreg, 
            jaqy646breg,  
            jaqy646bcage, 
            jaqy646bage,  
            jaqy646bana,  
            jaqy646bnana, 
           -- jaqy646best
            jaqy646bacte, 
            jaqy646bmod, 
            jaqy646bsegm, 
            jaqy646bsbs,  
            jaqy646bcom,  
            jaqy646bmon,  
            jaqy646bmoda,   
            jaqy646bcuen, 
            jaqy646boper, 
            jaqy646bmone, 
            jaqy646bzona, 
            JAQY646BCCA,
            JAQY646BDCA,
            JAQY646BCCAM
          /*FECPRO,           TIPDOC,           NUMDOC,
           CODCRE,           FECDES,           MONDES,
           SALCAP,           DIATR,           RECU,
           TIPO,                      CODREG,
           REGION,           CODAGE,           AGEN,
           ANALISTA,           NOMANA,            ACTECO,
           MODULO,           SEGMEN,           PRODSBS,
           COMITE,           MONTO,           MODALI,            
           CUENTA,           OPERACION,           MONEDA, 
           ZONACT*/
           )
        values
          (
           a.FECPRO,
           a.TIPDOC,
           a.NUMDOC,
           a.CODCRE,
           a.FECDES,
           a.MONDES,
           a.SALCAP,
           a.DIATR,
           a.RECU,
           a.TIPO,
           a.CODREG,
           a.REGION,
           a.CODAGE,
           a.AGEN,
           a.ANALISTA,
           a.NOMANA,
           a.jaqy646acte, 
           a.jaqy646amod, 
           a.jaqy646aseg, 
           a.jaqy646asbs, 
           a.jaqy646acom ,
           a.jaqy646amon, 
           a.jaqy646amoda,
           a.jaqy646cta,
           a.jaqy646ope,
           a.jaqy646mda , 
           a.zona,   
           lc_codcam,
           lc_nomcam,
           lc_concam           
          );
        COMMIT;
        
     EXCEPTION WHEN OTHERS THEN 
         
         ERROR :=   SUBSTR(SQLERRM,1,199);
       
        insert into JAQY646C
          (JAQY646CFEC,
           JAQY646CCCRE,
           JAQY646CMGE           
           )
        values
          (
           a.FECPRO,
           a.CODCRE,
            ERROR
          );          
          COMMIT;        
     
     END;
     END LOOP;            
    -- commit;        
      
  --NULL;  
  end;   
  


  

---------------------------------------------------------------------------------------------------------------

procedure SP_CR_REP_DESEM_HILOS( F_FEC IN VARCHAR ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_ACTUALIZACION_HILOS
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   

  


CURSOR PERIODO IS 

select -- ALL_ROWS ---original
 TO_CHAR(T.JAQL114FECH, 'RRRRMM') JAQY646FEC
  from JAQL114 T
 WHERE T.JAQL114FECH >= to_date(F_FEC, 'rrrrmmdd')
 GROUP BY T.JAQL114FECH;

/*
select --borrar
 TO_CHAR(T.JAQL114FECH, 'RRRRMM') JAQY646FEC
  from JAQL114 T
 WHERE T.JAQL114FECH = to_date('20170831', 'rrrrmmdd') 
 GROUP BY T.JAQL114FECH;
*/
lc_prcsobend varchar2(500);
ln_count number(10);
ln_limit number(18);

ln_indpro NUMBER(18);
LNINI NUMBER ;
LNFIN NUMBER ;


job_id number;
NROCRE NUMBER  := 6000 ; 
lc_hostname varchar2(64);



BEGIN

     execute immediate 'ALTER SESSION SET commit_wait=''NOWAIT''';
     execute immediate 'ALTER SESSION SET commit_logging=''BATCH''';


    LNINI := 1; 
    LNFIN := 1;
    
    
    select host_name
      into lc_hostname
    from v$instance;

   
  -- truncate table TABLA_AMP;
   FOR P IN PERIODO LOOP
    
--    if UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052') then      
--    if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then
IF SYS.FN_BD_ISRAC='TRUE' THEN
       dbms_job.submit(
          job_id,
          what => 'begin          
                  pq_cosecha_sentinel.GENERA_REPORTE_DESEM('''||P.JAQY646FEC||''' ); 
                   end;',
          next_date => sysdate, 
          interval => null, 
          no_parse => false,
          instance => 2, 
          force => false          
           );            
     else 
       dbms_job.submit(
          job_id,
          what => 'begin          
                  pq_cosecha_sentinel.GENERA_REPORTE_DESEM('''||P.JAQY646FEC||''' ); 
                   end;',
          next_date => sysdate, 
          interval => null, 
          no_parse => false,
          force => false          
           );     
     end if;  
         
     commit;       
     
   END LOOP;
  
  
  
  
    
END;

----------------------------------------------------------------------------------------------------------------


procedure SP_CR_ACT_DIMEN_HILOS( F_FEC IN VARCHAR ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_ACTUALIZACION_HILOS
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
  



CURSOR PERIODO IS 
select /*+ ALL_ROWS */
 TO_CHAR(T.JAQL114FECH, 'RRRRMM') JAQY646FEC
  from JAQL114 T
 WHERE T.JAQL114FECH >= to_date(F_FEC, 'rrrrmmdd')
 GROUP BY T.JAQL114FECH;

lc_prcsobend varchar2(500);
ln_count number(10);
ln_limit number(18);

ln_indpro NUMBER(18);
LNINI NUMBER ;
LNFIN NUMBER ;


job_id number;
NROCRE NUMBER  := 6000 ; 

lc_hostname varchar2(64);


BEGIN

     execute immediate 'ALTER SESSION SET commit_wait=''NOWAIT''';
     execute immediate 'ALTER SESSION SET commit_logging=''BATCH''';


    LNINI := 1; 
    LNFIN := 1;
   
    select host_name
      into lc_hostname
      from v$instance;

  -- truncate table TABLA_AMP;
   FOR P IN PERIODO LOOP
     
--   if UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052') then  
--   if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then
IF SYS.FN_BD_ISRAC='TRUE' THEN
       dbms_job.submit(
          job_id,
          what => 'begin          
                  pq_cosecha_sentinel.SP_CR_ACTUALIZA_DIMENSIONES('''||P.JAQY646FEC||''' ); 
                   end;',
          next_date => sysdate, 
          interval => null, 
          no_parse => false, 
          instance => 2, 
          force=> false
           );            
     else 
       
           dbms_job.submit(
          job_id,
          what => 'begin          
                  pq_cosecha_sentinel.SP_CR_ACTUALIZA_DIMENSIONES('''||P.JAQY646FEC||''' ); 
                   end;',
          next_date => sysdate, 
          interval => null, 
          no_parse => false,           
          force=> false
           );           
     
     
     end if ;           
           
     commit;       
   END LOOP;
  
  
  
  
    
END;

------------------------------------------------------------------------------------------------------



procedure SP_CR_CARGA_INICIAL_HILOS( F_FEC IN VARCHAR ) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_ACTUALIZACION_HILOS
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
  

CURSOR PERIODO IS 
select /*+ ALL_ROWS */
 TO_CHAR(T.JAQL114FECH, 'RRRRMMDD') JAQY646FEC
  from JAQL114 T
 WHERE T.JAQL114FECH >= to_date(F_FEC, 'rrrrmmdd')
 GROUP BY T.JAQL114FECH;

lc_prcsobend varchar2(500);
ln_count number(10);
ln_limit number(18);

ln_indpro NUMBER(18);
LNINI NUMBER ;
LNFIN NUMBER ;


job_id number;
NROCRE NUMBER  := 6000 ; 

lc_hostname varchar2(64);

BEGIN

     execute immediate 'ALTER SESSION SET commit_wait=''NOWAIT''';
     execute immediate 'ALTER SESSION SET commit_logging=''BATCH''';


    LNINI := 1; 
    LNFIN := 1;
   
   select host_name
      into lc_hostname
      from v$instance;


  -- truncate table TABLA_AMP;
   FOR P IN PERIODO LOOP
    
   
--    if UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052') then   
--    if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then
IF SYS.FN_BD_ISRAC='TRUE' THEN
         dbms_job.submit( 
            job_id,
            what => 'begin          
                    pq_cosecha_sentinel.SP_CR_CARGA_INICIAL( to_date('''|| P.JAQY646FEC ||''',''rrrrmmdd'')  ); 
                     end;',
            next_date => sysdate, 
            interval => null, 
            no_parse => false, 
            instance => 2, 
            force => false
             );            
    else 
           dbms_job.submit( 
            job_id,
            what => 'begin          
                    pq_cosecha_sentinel.SP_CR_CARGA_INICIAL( to_date('''|| P.JAQY646FEC ||''',''rrrrmmdd'')  ); 
                     end;',
            next_date => sysdate, 
            interval => null, 
            no_parse => false,             
            force => false
             );         
      
    end if;
                
    commit;       
     
   END LOOP; 
    
END;


------------------------------------------------------------------------------------------------------


function FN_CR_DEPURA( C_CADENA IN VARCHAR ) RETURN VARCHAR is

    -- *****************************************************************
    -- Nombre                     : SP_CR_ACTUALIZACION_HILOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
    CADENA VARCHAR(100);
    
BEGIN
  
/* create public synonym pq_cr_adjudicar for pq_cr_adjudicar;
   grant execute on pq_cr_adjudicar to rol_sorfy,rol_sorfy_consulta;
*/     

   CADENA := C_CADENA;
   CADENA := REPLACE(CADENA,'Á','A');
   CADENA := REPLACE(CADENA,'É','E');
   CADENA := REPLACE(CADENA,'Í','I');
   CADENA := REPLACE(CADENA,'Ó','O');
   CADENA := REPLACE(CADENA,'Ú','U');
   CADENA := REPLACE(CADENA,'Ñ','N');
   CADENA := REPLACE(CADENA,',',' ');
   
   return CADENA;
     
END;

-----------------------------------------------------------------------------------------

function FN_CR_ZONA_ACTUAL( N_SUCURSAL IN NUMBER ) RETURN VARCHAR is

    -- *****************************************************************
    -- Nombre                     : FN_CR_ZONA_ACTUAL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : N_SUCURSAL ( SUCURSAL )
    --                             
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
    lv_zona VARCHAR(40);
    
BEGIN
  
/* create public synonym pq_cr_adjudicar for pq_cr_adjudicar;
   grant execute on pq_cr_adjudicar to rol_sorfy,rol_sorfy_consulta;
*/     
 
    select 
     UPPER(b.regnom) --, t.sucurs, t.scnom
      into lv_zona
      from fst001 t, fst811 a, fst810 b
     where t.sucurs = a.oficod
       and b.pgcod = 1
       and b.regcod = a.regcod
       and a.regcod < 100
       and t.sucurs = N_SUCURSAL;
   
   return lv_zona;
   
exception when others then 
   return 'NO REGISTRADO';    
END;

--------------------------------------------------------------
  
function FN_Nom_CAMPANA( COD_CAM IN varchar2) return varchar2 
  is
    
    Nom_campana varchar2(100); 
     
  Begin
    
    select substr(a.jaqz968cdpri,1,100)  
    into Nom_campana
    from jaqz968 a where a.jaqz968cdcam = COD_CAM ;
    
  /*select substr(a.c_campri,1,100)  
    into Nom_campana
    from jaqz968 a where a.c_codcam = COD_CAM ;*/
    
     Return Nom_campana;
     
  Exception when others then
            return 'SIN CAMPAÑA';  --'-';
            
end FN_Nom_CAMPANA;
  

----------------------------------------------------------------------------
function FN_Sec_CAMPANA( COD_CAM IN varchar2) return varchar2 --RMS
  is
    
    Sec_campana varchar2(90); 
     
  Begin
    
    select substr(a.jaqz968casec,1,90) 
    into Sec_campana
    from jaqz968 a where a.jaqz968cdcam = COD_CAM ;
    /*select substr(a.c_camsec,1,90) 
    into Sec_campana
    from PAMCAMP@datanew a where a.c_codcam = COD_CAM ;
    */
     Return Sec_campana;
     
  Exception when others then
            return 'SIN SEC_CAMPAÑA';  --'-';
            
end FN_Sec_CAMPANA;


PROCEDURE FN_InsertaCampana( resul out varchar2 )--RMS
  is
        
  Begin
  
    delete from jaqz968;---PAMCAMP@datanew
    delete from jaqz969;---PADCAMP@datanew;
    
       insert into jaqz968
      select * from PAMCAMP@DATAWHCOS;
       insert into jaqz969
      select * from PADCAMP@DATAWHCOS;
      resul:='S';---s cargo la data
      
      commit;
              
  Exception when others then
        resul:='N';---n No cargo la data
            
end FN_InsertaCampana;
------------------------------------------------------------------------------------------------------
end pq_cosecha_sentinel;
/

