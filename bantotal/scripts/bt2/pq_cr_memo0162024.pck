create or replace package PQ_CR_MEMO0162024 is

 -- *****************************************************************
    -- Nombre                     : PQ_CR_MEMO0162024
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.01.16
    -- Autor de Creación          : YYAMPI
    -- Uso                        : juego de procemientos correspondiente al memorando 016-2024 CMAC/GMAN
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 2024.01.24
    -- Autor de la Modificación   : YYAMPI
    -- Descripción de Modificación: Modificaciones en el rubro
    
    -- *****************************************************************
  
   Function fn_codsbs_cliente(
                        pd_fecini  in date,
                        pd_fecfin  in date,
                        pn_pgpais   in number,
                        pn_tipdoc   in number,
                        pc_numdoc   in char
                        ) return varchar ; 
-------------------------------------------------------------------------  
procedure sp_cr_deu_rep_ins(pn_instance in numeric,
                                       pv_usuario in char,
                                       pv_nomprog in char,                      
                                       pv_rptaH     out varchar2,
                                       pv_rptaU     out varchar2
                                       );
-------------------------------------------------------------------------  
               
procedure sp_cr_deu_rep_cli(pv_codsbs in varchar2,
                                       pd_fechaRCC in date, 
                                       pc_usuario in char,
                                       pv_origen1 in varchar2,
                                       pv_origen2 in varchar2,                                          
                                       pn_instancia in number,  
                                       pn_grupo in varchar2,                                  
                                       pv_rpta out varchar2                                       
                                       );
                                       
-------------------------------------------------------------------------  
 
 procedure sp_cr_deu_rep_central(      pv_codsbs in varchar2,
                                       pn_pais in number,
                                       pn_tdoc in number,
                                       pc_ndoc in char,
                                       pv_usuario in char
                                       ) ;                                      
  
-------------------------------------------------------------------------  

end PQ_CR_MEMO0162024;
/

create or replace package body PQ_CR_MEMO0162024 is

  
----------------------------------------------------------------------------------------------------------

procedure sp_cr_deu_rep_ins(pn_instance in numeric,
                                       pv_usuario in char,
                                       pv_nomprog in char,                      
                                       pv_rptaH     out varchar2,
                                       pv_rptaU     out varchar2
                                       ) is
                               
  -- *****************************************************************
    -- Nombre                     : sp_cr_deu_rep_ins
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.01.16
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA INDICADOR DE DEUDA REPROGRAMADA - RESOLUTOR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instance ( INSTANCIA)
    --                            : pv_usuario ( USUARIO )
    --                            : pv_nomprog ( NOMBRE DEL PROGRAMA)
    --                            :  

    -- Parámetros de Salida       : pv_rptaH  (6 MESES INDICADOR S: CUMPLE N: NO CUMPLE )
    --                            : pv_rptaU  ( ULTIMO CARGA INDICADOR S: CUMPLE N: NO CUMPLE )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************                               
    ln_paisT       number := 0;
    ln_tdocT       number := 0;
    lc_ndocT       char(12) := '';
    lv_codsbsT      varchar2(12) := '';
    
    ln_paisC       number := 0;
    ln_tdocC       number := 0;
    lc_ndocC       char(12) := '';
    lv_codsbsC      varchar2(12) := '';
    
    ld_fechaRCC      date;
    ld_fechaI       date;
    ld_fechaF       date; 
    lv_codsbs     varchar2(12);
    ln_saldo1     number;
    ln_saldo2     number;
    ln_diferencia number;
    ln_porcentaje number;
    ln_indicador number := 0; 
    pv_rptaT     char(1) := 'N';
    pv_rptaC     char(1) := 'N';
    ln_indicadorE  number := 0; 
    ln_grupo varchar2(12) :='';
    
  begin
    
  
   /*calculo de ultima fecha de carga del RCC*/
   begin
      select to_date(substr(tpnro, 1, 2) || '/' || substr(tpnro, 3, 2) || '/' ||
                     substr(tpnro, 5, 4),
                     'dd/mm/yyyy')
        into ld_fechaRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        ld_fechaRCC := null;
    end;
  
    
    /*calculo de fecha ini y fecha fin*/
    ld_fechaF := ld_fechaRCC ;
    ld_fechaI := ADD_MONTHS(ld_fechaRCC, -5); --PONER EL GUIA
    
  
     /*obtener el porcentage de limite*/
    begin
      SELECT tp1imp1
        into ln_porcentaje
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11162
         AND TP1CORR1 = 6;
    exception
      when no_data_found then
        ln_porcentaje := 0;
    end; 
  
  
    /*calculo de datos titular*/
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc , PQ_CR_MEMO0162024.fn_codsbs_cliente(pd_fecini => ld_fechaI,
                                                                                                pd_fecfin => ld_fechaF,
                                                                                                pn_pgpais => a.sng001pais,
                                                                                                pn_tipdoc => a.sng001tdoc,
                                                                                                pc_numdoc => a.sng001ndoc)
        into ln_paisT, ln_tdocT, lc_ndocT , lv_codsbsT
        from sng001 a
       where a.sng001inst = pn_instance;
    exception
      when others then
        null;
    end;
    
    
    /*calculador los 6 meses de saldo reprogramado*/
     
    begin   
     delete AQPB281 t
      where t.aqpb281usur = pv_usuario
        and t.aqpb281ins = pn_instance
        and t.aqpb281ori1 = 'RESOLUTOR'
        and t.aqpb281ori2 = pv_nomprog;
     commit;
      exception when others then
     null; 
     end;   
    
    begin  
     PQ_CR_MEMO0162024.sp_cr_deu_rep_cli(pv_codsbs => lv_codsbsT,
                                                     pd_fechaRCC => ld_fechaRCC,
                                                     pc_usuario => pv_usuario,
                                                     pv_origen1 => 'RESOLUTOR',
                                                     pv_origen2 => pv_nomprog,                                                     
                                                     pn_instancia => pn_instance,
                                                     pn_grupo => ln_grupo,
                                                     pv_rpta => pv_rptaT);
   exception when others then
     null; 
     end;  
    
  
   
   
   
    /*calculo de datos conyugue*/
    begin 
      --select * from fsr002   
      
      select  b.rppais, b.rptdoc, b.rpndoc , PQ_CR_MEMO0162024.fn_codsbs_cliente(pd_fecini => ld_fechaI,
                                                                                                pd_fecfin => ld_fechaF,
                                                                                                pn_pgpais => b.rppais,
                                                                                                pn_tipdoc => b.rptdoc,
                                                                                                pc_numdoc => b.rpndoc)
        into ln_paisC, ln_tdocC, lc_ndocC, lv_codsbsC
        from fsr002 b
       where b.pepais = ln_paisT
         and b.petdoc = ln_tdocT
         and b.pendoc = lc_ndocT
         and b.rpccyg = 66;
    
     
    exception
      
      when others then
        
      begin
         select b.pepais, b.petdoc, b.pendoc, PQ_CR_MEMO0162024.fn_codsbs_cliente(pd_fecini => ld_fechaI,
                                                                                                pd_fecfin => ld_fechaF,
                                                                                                pn_pgpais => b.rppais,
                                                                                                pn_tipdoc => b.rptdoc,
                                                                                                pc_numdoc => b.rpndoc)
       
        into ln_paisC, ln_tdocC, lc_ndocC, lv_codsbsC
        from fsr002 b
       where b.rppais = ln_paisT
         and b.rptdoc = ln_tdocT
         and b.rpndoc = lc_ndocT
         and b.rpccyg = 66;
       exception when others then
         null;
         end ;  
    end;
    
    
    
    /*calculador los 6 meses de saldo reprogramado conyugue*/
     begin  
     PQ_CR_MEMO0162024.sp_cr_deu_rep_cli(pv_codsbs => lv_codsbsC,
                                                     pd_fechaRCC => ld_fechaRCC,
                                                     pc_usuario => pv_usuario,
                                                     pv_origen1 => 'RESOLUTOR',
                                                     pv_origen2 => pv_nomprog,                                                     
                                                     pn_instancia => pn_instance,
                                                     pn_grupo => ln_grupo,
                                                     pv_rpta => pv_rptaC);
       exception when others then
         null; 
         end;  
    
    
    
    /*buscamos si algun mes tiene el porcentage menor al parametro*/ 
    if pv_rptaT = 'S' or pv_rptaC = 'S' then   
            
        select count(*)
          into ln_indicador
          from AQPB281 t
         where t.aqpb281usur = pv_usuario
           and t.aqpb281ins = pn_instance
           and t.aqpb281ori1 = 'RESOLUTOR'
           and t.aqpb281ori2 = pv_nomprog
           and t.aqpb281prdis1 > ln_porcentaje;
        
        if ln_indicador > 0 then 
           pv_rptaH := 'S'; --tiene algun mes con el indicador menor del parametro establecido
        else   
          pv_rptaH := 'N';  -- todos los indicadores son mayores al parametro establecido
        end if ; 
    else
         pv_rptaH := 'N';       
    end if;
    
    /*buscamos si existe deuda reprograma en el ultimo rcc*/ 
       if pv_rptaT = 'S' or pv_rptaC = 'S' then   
              
          select count(*)
            into ln_indicadorE
            from AQPB281 t
           where t.aqpb281usur = pv_usuario
             and t.aqpb281ins = pn_instance
             and t.aqpb281ori1 = 'RESOLUTOR'
             and t.aqpb281ori2 = pv_nomprog
             and t.aqpb281saldo5 > 0;
          
          if ln_indicadorE > 0 then 
             pv_rptaU := 'S'; -- Existe deuda en le ultimo rcc
          else   
            pv_rptaU := 'N';  -- No Existe deuda en le ultimo rcc
          end if ; 
      else
           pv_rptaU := 'N';  -- No Existe deuda en le ultimo rcc     
      end if;
    
  exception
      when others then
        null;  
    
  
  end sp_cr_deu_rep_ins;
 ------------------------------------------------------------------------------------------ 

procedure sp_cr_deu_rep_cli(pv_codsbs in varchar2,
                                       pd_fechaRCC in date, 
                                       pc_usuario in char,
                                       pv_origen1 in varchar2,
                                       pv_origen2 in varchar2,                                          
                                       pn_instancia in number,  
                                       pn_grupo in varchar2,                                  
                                       pv_rpta out varchar2                                       
                                       ) is
                               
  -- *****************************************************************
    -- Nombre                     : sp_cr_deu_rep_cli
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.01.16
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA LOS SALDOS  
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pv_codsbs ( codigo SBS)
    --                            : pd_fechaRCC ( FECHA DE PROCESO RCC )
    --                            : pc_usuario ( USUARIO )
    --                            : pv_origen1 ( ORIGEN 1 )
    --                            : pv_origen2 ( ORIGEN 2 )
    --                            : pn_instancia ( NUMERO DE INSTANCIA )
    --                            : pn_grupo ( GRUPO )
    -- Parámetros de Salida       : pv_rpta
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************   
    cursor saldo_entidad ( codsbs varchar2, fecharcc date  ) is
    
     select /*+ ALL_ROWS*/  C_CODEMP, C_DESEFI, 
         max(NVL(SALCAP0,0)) SALCAP0,
         max(NVL(SALCAP1,0)) SALCAP1,
         max(NVL(SALCAP2,0)) SALCAP2,
         max(NVL(SALCAP3,0)) SALCAP3,
         max(NVL(SALCAP4,0)) SALCAP4,
         max(NVL(SALCAP5,0)) SALCAP5            
         from (
         select /*+ ALL_ROWS*/ DISTINCT A.D_FECPRE , A.C_CODEMP,T.C_DESEFI ,          
          CASE WHEN A.D_FECPRE =  add_months(fecharcc, -5) THEN SUM(A.N_SALCAP) END SALCAP0, 
          CASE WHEN A.D_FECPRE =  add_months(fecharcc, -4) THEN SUM(A.N_SALCAP) END SALCAP1, 
          CASE WHEN A.D_FECPRE =  add_months(fecharcc, -3) THEN SUM(A.N_SALCAP) END SALCAP2, 
          CASE WHEN A.D_FECPRE =  add_months(fecharcc, -2) THEN SUM(A.N_SALCAP) END SALCAP3, 
          CASE WHEN A.D_FECPRE =  add_months(fecharcc, -1) THEN SUM(A.N_SALCAP) END SALCAP4, 
          CASE WHEN A.D_FECPRE =  add_months(fecharcc, -0) THEN SUM(A.N_SALCAP) END SALCAP5,                       
          SUM(A.N_SALCAP) SALCAP         
           -- into ln_saldo1
            from CLDRCCS a, ahtbanc t
           Where C_CODSBS = codsbs --'0051279263'
             and D_FECPRE BETWEEN add_months(fecharcc, -5) AND add_months(fecharcc, 0)
             and (C_CUENTA like ('81_954%')
             or C_CUENTA like ('81_927%') 
             or C_CUENTA like ('81_937%')
             or C_CUENTA like ('81_936%'))
             and NOT ( t.C_DESEFI like '%REACTIVA%' or t.C_DESEFI like '%CRECER%' or t.C_DESEFI like '%FONDOS%')
             AND A.C_CODEMP <> '00104' --NO INCLUIR CMAC AQP
             AND T.C_CODEFI = A.C_CODEMP
             GROUP BY A.D_FECPRE ,A.C_CODEMP,T.C_DESEFI
             ORDER BY 1 )
             GROUP BY  C_CODEMP, C_DESEFI
             ;
                                
    ln_pais       number;
    ln_tdoc       number;
    lc_ndoc       char(12);
    ld_fecha      date;
    lv_codsbs     varchar2(12);
    ln_saldo0     number;
    ln_saldo1     number;
    ln_saldo2     number;
    ln_saldo3     number;
    ln_saldo4     number;
    ln_saldo5     number;
    ln_prddis1     number;
    ld_fechamin   date;
    ld_fechamax   date;
    ln_saldofmin  number;
    ln_saldofmax  number;
    ld_fechap      date;
    lc_hora        char(10);
              
   
    ln_diferencia number;
    ln_porcentaje number;
    pn_instance number(10);
    lv_nombreEnt varchar2(50);
    
    
  begin
     
    lv_codsbs := pv_codsbs;
    pv_rpta := 'N';
      
    /*fecha de proceso  */
    begin
      select t.pgfape into ld_fechap from fst017 t where t.pgcod = 1;
    exception
      when others then
        ld_fechap := null;
    end;
    
  
     
    
    begin
      
    
    
    for saldo in saldo_entidad (lv_codsbs, pd_fechaRCC) loop
    
      /*calculo de saldos reprogramados*/
      begin 
       select min(a.d_fecpre), max(a.d_fecpre)
         into ld_fechamin, ld_fechamax
         from CLDRCCS a--, ahtbanc t
        Where C_CODSBS = pv_codsbs
          and D_FECPRE BETWEEN
              add_months(pd_fechaRCC, -5) AND
              add_months(pd_fechaRCC, 0)
          and (C_CUENTA like ('81_954%') or C_CUENTA like ('81_927%') or
              C_CUENTA like ('81_937%') or C_CUENTA like ('81_936%'))           
          and a.c_codemp = saldo.c_codemp ;
      exception when others then 
        ld_fechamin := null;
        ld_fechamax := null;
        end;      
        /*monto fecha minima*/
        begin          
           select NVL(sum(NVL(a.n_Salcap,0)),0)
           into ln_saldofmin
            from CLDRCCS a
           Where C_CODSBS = pv_codsbs
             and D_FECPRE = ld_fechamin
             and (C_CUENTA like ('81_954%')
             or C_CUENTA like ('81_927%') 
             or C_CUENTA like ('81_937%')
             or C_CUENTA like ('81_936%'))
             and a.c_codemp = saldo.c_codemp
             ;                   
        exception
          when no_data_found then
            ln_saldofmin := 0;
        end;
        
        
        /*monto fecha maxima*/
        begin          
           select NVL(sum(NVL(a.n_Salcap,0)),0)
           into ln_saldofmax
            from CLDRCCS a
           Where C_CODSBS = lv_codsbs
             and D_FECPRE = pd_fechaRCC --ld_fechamax
             and (C_CUENTA like ('81_954%')
             or C_CUENTA like ('81_927%') 
             or C_CUENTA like ('81_937%')
             or C_CUENTA like ('81_936%'))
             and a.c_codemp = saldo.c_codemp
             ;                   
        exception
          when no_data_found then
            ln_saldofmax := 0;
        end;
        
       /*calculo de porcentage */
        begin 
                ln_prddis1 := ((( ln_saldofmax/case when ln_saldofmin= 0 then 1 else ln_saldofmin end) ) -1);
        exception when others then 
           ln_prddis1 :=0;
        end;
       
       
       /*obtencion de nombre contraido de la institucion*/       
        begin
          lv_nombreEnt := '';
          select Tp1desc
          into lv_nombreEnt
            from fst198
           where Tp1cod = 1
             and Tp1cod1 = 10849
             and Tp1corr1 = 10
             and Tp1nro1 = saldo.c_codemp;
        Exception
          When others then
            lv_nombreEnt := 'No descripción';
        End;
            
       /*insercion en el log*/
       begin
         insert into AQPB281
           (AQPB281USUR, --
            AQPB281CODSBS, --
            AQPB281FPROC,
            AQPB281FCR, --
            AQPB281HCR, --
            AQPB281CODEMP, --
            AQPB281DESEMP,
            AQPB281SALDO0,
            AQPB281SALDO1,
            AQPB281SALDO2,
            AQPB281SALDO3,
            AQPB281SALDO4,
            AQPB281SALDO5,
            AQPB281PRDIS1,
            AQPB281ORI1, --
            AQPB281ORI2, --
            AQPB281INS,
            AQPB281AUX2,
            AQPB281AUX3,
            AQPB281AUX1            
            )
         values
           (pc_usuario,
            lv_codsbs,
            pd_fechaRCC,
            ld_fechap,
            to_char(sysdate(),'HH24:MI:SS'),
            saldo.c_codemp,
            saldo.C_DESEFI,
            saldo.SALCAP0,
            saldo.SALCAP1,
            saldo.SALCAP2,
            saldo.SALCAP3,
            saldo.SALCAP4,
            saldo.SALCAP5,
            ln_prddis1,
            pv_origen1,
            pv_origen2,
            pn_instancia,
            pn_grupo,
            'D',
            lv_nombreEnt);
            
            pv_rpta := 'S';
            commit;
       exception
         when others then
           rollback;
           null;
       end;
       
       end loop;
        
       
    exception when others then null;
    end;
  
  end sp_cr_deu_rep_cli;
 ------------------------------------------------------------------------------------------ 

  
 Function fn_codsbs_cliente(
                        pd_fecini  in date,
                        pd_fecfin  in date,
                        pn_pgpais   in number,
                        pn_tipdoc   in number,
                        pc_numdoc   in char
                        ) return varchar is
  
  -- *****************************************************************
    -- Nombre                     : fn_codsbs_cliente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.01.16
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA EL CODIGO SBS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecini ( FECHA DE PROCESO INICIAL )
    --                            : pd_fecfin ( FECHA DE PROCESO FIN )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : codigo sbs
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
                       
    ln_potencial number(10) :=0;  --valor sin respuesta
    ln_potval number(10) :=0; --
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :=''; --codigoSBS 
    pv_numdoc varchar(12):=0; --numero de documento 
   -- ln_petipo
  begin
  
      /*obtener tipo de persona (Juridica o natural) */
      begin 
        select t.petipo into ln_petipo 
        from fsd001 t
        where t.pepais = pn_pgpais
              and t.petdoc = pn_tipdoc
              and t.pendoc = pc_numdoc;
      exception when others then 
       --DBMS_OUTPUT.put_line(SQLERRM);
       ln_petipo := '';
       null;                        
      end;
      
      /*Calculo de tipo de documento SBS*/
      begin 
          select t.tp1corr3 into ln_tipdocSBS 
          from FST198 t 
          where t.tp1cod = 1 and t.tp1cod1 = 11111
               and t.tp1corr1 = 1 and t.tp1corr2 = 3
               and t.tp1nro1 =  pn_tipdoc; 
      exception when others then 
         --DBMS_OUTPUT.put_line(SQLERRM);
         ln_tipdocSBS := 0;
         null;                          
      end;
      
      /*Obtencion del codigo SBS*/
      begin
        pv_numdoc := trim(pc_numdoc); 
        if ln_petipo = 'F' then     
          select c_codsbs into lv_codSBS 
          from (      
          select c.c_codsbs 
          from CLDRCCI c
          Where --D_FECPRE = ld_fecrcc
                C.D_FECPRE between pd_fecini and pd_fecfin
                and C_TDOCID = ln_tipdocSBS
                and C_DOCIDE = pv_numdoc
                order by C.D_FECPRE desc
                ) where rownum = 1;
        else   
          if ln_petipo = 'J' then
            select c_codsbs into lv_codSBS 
            from ( 
            select c.c_codsbs --into lv_codSBS
            from CLDRCCI c
             Where --D_FECPRE = ld_fecrcc
                C.D_FECPRE between pd_fecini and pd_fecfin
                and C_TDOCTR = ln_tipdocSBS
                and C_DOCTRI = pv_numdoc
                 order by C.D_FECPRE desc
                ) where rownum = 1 ;
           else      
               /*caso externo */
               begin 
                    select c_codsbs
                      into lv_codSBS
                      from (select c.c_codsbs
                               from CLDRCCI c
                              Where --D_FECPRE = ld_fecrcc
                              C.D_FECPRE between pd_fecini and pd_fecfin
                           and C_TDOCID = ln_tipdocSBS
                           and C_DOCIDE = pv_numdoc
                              order by C.D_FECPRE desc)
                     where rownum = 1;
               exception when others then          
                   lv_codSBS := null;
               end;
          end if ;
        end if ;  
      exception when others then 
          --DBMS_OUTPUT.put_line(SQLERRM);
          lv_codSBS := null; 
                                        
      end;
     
    return lv_codSBS;
  
  end fn_codsbs_cliente;
  
  ---------------------------------------------------------------------------------------------
 
 
 procedure sp_cr_deu_rep_central(      pv_codsbs in varchar2,
                                       pn_pais in number,
                                       pn_tdoc in number,
                                       pc_ndoc in char,
                                       pv_usuario in char
                                       ) is
                               
  -- *****************************************************************
    -- Nombre                     : sp_cr_deu_rep_central
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.01.16
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA LOS SALDOS  
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pv_codsbs ( CODIGO SBS)
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    --                            : pv_usuario ( USUARIO )
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************                            
    ln_paisT       number := 0;
    ln_tdocT       number := 0;
    lc_ndocT       char(12) := '';
    lv_codsbsT      varchar2(12) := '';
    
    ln_paisC       number := 0;
    ln_tdocC       number := 0;
    lc_ndocC       char(12) := '';
    lv_codsbsC      varchar2(12) := '';
    
    ld_fechaRCC      date;
    ld_fechaI       date;
    ld_fechaF       date; 
    lv_codsbs     varchar2(12);
    ln_saldo1     number;
    ln_saldo2     number;
    ln_diferencia number;
    ln_porcentaje number;
    ln_indicador number := 0; 
    pv_rptaT     char(1) := 'N';
    pv_rptaC     char(1) := 'N';
    ln_indicadorE  number := 0; 
    pn_instance  number:=0;
    lv_nomprog varchar2(12);
    
  begin
    
  
   /*calculo de ultima fecha de carga del RCC*/
   begin
      select to_date(substr(tpnro, 1, 2) || '/' || substr(tpnro, 3, 2) || '/' ||
                     substr(tpnro, 5, 4),
                     'dd/mm/yyyy')
        into ld_fechaRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        ld_fechaRCC := null;
    end;
  
    
    /*calculo de fecha ini y fecha fin*/
    ld_fechaF := ld_fechaRCC ;
    ld_fechaI := ADD_MONTHS(ld_fechaRCC, -5); --PONER EL GUIA
    
  
     /*obtener el porcentage de limite*/
    begin
      SELECT tp1imp1
        into ln_porcentaje
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11162
         AND TP1CORR1 = 6;
    exception
      when no_data_found then
        ln_porcentaje := 0;
    end; 
  
  
    /*calculo de datos titular*/
    begin
      
       
       lv_codsbsT := pv_codsbs;
       ln_paisT := pn_pais;
       ln_tdocT := pn_tdoc;
       lc_ndocT := pc_ndoc;
      
       --pv_usuario in char,
       --pv_nomprog in char
       
       
    exception
      when others then
        null;
    end;
    
    
    /*calculador los 6 meses de saldo reprogramado*/
     
    begin   
      
    lv_nomprog := 'SALD_REP';  
    
     delete AQPB281 t
      where t.aqpb281usur = pv_usuario
        --and t.aqpb281codsbs = pv_codsbs
        and t.aqpb281ori1 = 'CENTRAL'
        and t.aqpb281ori2 = 'SALD_REP'        
        and t.aqpb281aux2 = pv_codsbs
        --and t.aqpb281ori2 = decode(pv_nomprog,'','SALD_REP',pv_nomprog)
        ;
     commit;
      exception when others then
     null; 
     end;   
    
    begin  
     PQ_CR_MEMO0162024.sp_cr_deu_rep_cli(pv_codsbs => lv_codsbsT,
                                                     pd_fechaRCC => ld_fechaRCC,
                                                     pc_usuario => pv_usuario,
                                                     pv_origen1 => 'CENTRAL',
                                                     pv_origen2 => lv_nomprog,                                                     
                                                     pn_instancia => pn_instance,    
                                                     pn_grupo => pv_codsbs,                                                 
                                                     pv_rpta => pv_rptaT);
   exception when others then
     null; 
     end;  
    
    /*se calcula e inserta el consolidado*/
    begin      
     insert into AQPB281
           (AQPB281USUR, --
            AQPB281CODSBS, --
            AQPB281FPROC,
            AQPB281FCR, --
            AQPB281HCR, --
            AQPB281CODEMP, --
            AQPB281DESEMP,
            AQPB281SALDO0,
            AQPB281SALDO1,
            AQPB281SALDO2,
            AQPB281SALDO3,
            AQPB281SALDO4,
            AQPB281SALDO5,
            AQPB281PRDIS1,
            AQPB281ORI1, --
            AQPB281ORI2, --
            AQPB281INS,
            AQPB281AUX1,
            AQPB281AUX2,
            AQPB281AUX3
            )
                     
            select /*+ all_rows*/
             AQPB281USUR,
             AQPB281CODSBS,
             AQPB281FPROC,
             AQPB281FCR,
             AQPB281HCR,
             AQPB281CODEMP,
             AQPB281DESEMP,
             AQPB281SALDO0,
             AQPB281SALDO1,
             AQPB281SALDO2,
             AQPB281SALDO3,
             AQPB281SALDO4,
             AQPB281SALDO5,
             (aqpb281saldo5 / (CASE
               WHEN (aqpb281saldo0) > 0 THEN
                (aqpb281saldo0)
               WHEN (aqpb281saldo1) > 0 THEN
                (aqpb281saldo1)
               WHEN (aqpb281saldo2) > 0 THEN
                (aqpb281saldo2)
               WHEN (aqpb281saldo3) > 0 THEN
                (aqpb281saldo3)
               WHEN (aqpb281saldo4) > 0 THEN
                (aqpb281saldo4)
               else
                aqpb281saldo5
             end) - 1) AQPB281PRDIS1,
             AQPB281ORI1,
             AQPB281ORI2,
             AQPB281INS,
             'CODSBS_TIT' AQPB281AUX1,
             AQPB281AUX2,
             'T' AQPB281AUX3
              from (select /*+ all_rows*/
                     t.AQPB281USUR,
                     t.AQPB281CODSBS,
                     t.AQPB281FPROC,
                     t.AQPB281FCR,
                     to_char(sysdate, 'HH24:MI:SS') AQPB281HCR,
                     '00000' AQPB281CODEMP,
                     'TOTAL' AQPB281DESEMP,
                     SUM(t.aqpb281saldo0) aqpb281saldo0,
                     SUM(t.aqpb281saldo1) aqpb281saldo1,
                     SUM(t.aqpb281saldo2) aqpb281saldo2,
                     SUM(t.aqpb281saldo3) aqpb281saldo3,
                     SUM(t.aqpb281saldo4) aqpb281saldo4,
                     SUM(t.aqpb281saldo5) aqpb281saldo5,
                     T.AQPB281ORI1,
                     T.AQPB281ORI2,
                     T.AQPB281INS,
                     --t.AQPB281AUX1,
                     t.AQPB281AUX2,
                     t.AQPB281AUX3
                      from AQPB281 t
                     where t.aqpb281usur = pv_usuario --'SCRE0204'
                       and t.aqpb281codsbs = lv_codsbsT--'0051279263'  --titular
                       and t.aqpb281ori1 = 'CENTRAL'
                       and t.aqpb281ori2 = 'SALD_REP'
                       and t.aqpb281aux2 = pv_codsbs --titular principal
                     group by t.AQPB281USUR,
                              t.AQPB281CODSBS,
                              t.AQPB281FPROC,
                              t.AQPB281FCR,
                              to_char(sysdate, 'HH24:MI:SS'),
                              '00000',
                              'TOTAL',
                              T.AQPB281ORI1,
                              T.AQPB281ORI2,
                              T.AQPB281INS,
                              --t.AQPB281AUX1,                              
                              t.AQPB281AUX2,
                              T.AQPB281AUX3)
                        ;
    
      commit;     
    exception when others then 
       null;
     --  DBMS_OUTPUT.put_line(sqlerrm);
    end;
   
   
   
    /*calculo de datos conyugue*/
    begin 
      --select * from fsr002   
      
      select b.rppais,
             b.rptdoc,
             b.rpndoc,
             PQ_CR_MEMO0162024.fn_codsbs_cliente(pd_fecini => ld_fechaI,
                                                 pd_fecfin => ld_fechaF,
                                                 pn_pgpais => b.rppais,
                                                 pn_tipdoc => b.rptdoc,
                                                 pc_numdoc => b.rpndoc)
        into ln_paisC, ln_tdocC, lc_ndocC, lv_codsbsC
        from fsr002 b
       where b.pepais = ln_paisT
         and b.petdoc = ln_tdocT
         and b.pendoc = lc_ndocT
         and b.rpccyg = 66;    
     
    exception when others then
        
      begin
        select b.pepais,
               b.petdoc,
               b.pendoc,
               PQ_CR_MEMO0162024.fn_codsbs_cliente(pd_fecini => ld_fechaI,
                                                   pd_fecfin => ld_fechaF,
                                                   pn_pgpais => b.rppais,
                                                   pn_tipdoc => b.rptdoc,
                                                   pc_numdoc => b.rpndoc)
        
          into ln_paisC, ln_tdocC, lc_ndocC, lv_codsbsC
          from fsr002 b
         where b.rppais = ln_paisT
           and b.rptdoc = ln_tdocT
           and b.rpndoc = lc_ndocT
           and b.rpccyg = 66;
       exception when others then
         null;
         end ;  
    end;
    
    
    
    /*calculador los 6 meses de saldo reprogramado conyugue*/
     begin  
     
     PQ_CR_MEMO0162024.sp_cr_deu_rep_cli(pv_codsbs => lv_codsbsC,
                                                     pd_fechaRCC => ld_fechaRCC,
                                                     pc_usuario => pv_usuario,
                                                     pv_origen1 => 'CENTRAL',
                                                     pv_origen2 => lv_nomprog,                                                     
                                                     pn_instancia => pn_instance,    
                                                     pn_grupo => pv_codsbs,                                                 
                                                     pv_rpta => pv_rptaT);       
  
       exception when others then
         null; 
         end;  
    
    
     /*se calcula e inserta el consolidado*/
    begin      
     insert into AQPB281
           (AQPB281USUR, --
            AQPB281CODSBS, --
            AQPB281FPROC,
            AQPB281FCR, --
            AQPB281HCR, --
            AQPB281CODEMP, --
            AQPB281DESEMP,
            AQPB281SALDO0,
            AQPB281SALDO1,
            AQPB281SALDO2,
            AQPB281SALDO3,
            AQPB281SALDO4,
            AQPB281SALDO5,
            AQPB281PRDIS1,
            AQPB281ORI1, --
            AQPB281ORI2, --
            AQPB281INS,
            AQPB281AUX1,
            AQPB281AUX2,
            AQPB281AUX3
            )
                     
            select /*+ all_rows*/
             AQPB281USUR,
             AQPB281CODSBS,
             AQPB281FPROC,
             AQPB281FCR,
             AQPB281HCR,
             AQPB281CODEMP,
             AQPB281DESEMP,
             AQPB281SALDO0,
             AQPB281SALDO1,
             AQPB281SALDO2,
             AQPB281SALDO3,
             AQPB281SALDO4,
             AQPB281SALDO5,
             (aqpb281saldo5 / (CASE
               WHEN (aqpb281saldo0) > 0 THEN
                (aqpb281saldo0)
               WHEN (aqpb281saldo1) > 0 THEN
                (aqpb281saldo1)
               WHEN (aqpb281saldo2) > 0 THEN
                (aqpb281saldo2)
               WHEN (aqpb281saldo3) > 0 THEN
                (aqpb281saldo3)
               WHEN (aqpb281saldo4) > 0 THEN
                (aqpb281saldo4)
               else
                aqpb281saldo5
             end) - 1) AQPB281PRDIS1,
             AQPB281ORI1,
             AQPB281ORI2,
             AQPB281INS,
             'CODSBS_TIT' AQPB281AUX1,
             AQPB281AUX2,
             'T' AQPB281AUX3
              from (select /*+ all_rows*/
                     t.AQPB281USUR,
                     t.AQPB281CODSBS,
                     t.AQPB281FPROC,
                     t.AQPB281FCR,
                     to_char(sysdate, 'HH24:MI:SS') AQPB281HCR,
                     '00000' AQPB281CODEMP,
                     'TOTAL' AQPB281DESEMP,
                     SUM(t.aqpb281saldo0) aqpb281saldo0,
                     SUM(t.aqpb281saldo1) aqpb281saldo1,
                     SUM(t.aqpb281saldo2) aqpb281saldo2,
                     SUM(t.aqpb281saldo3) aqpb281saldo3,
                     SUM(t.aqpb281saldo4) aqpb281saldo4,
                     SUM(t.aqpb281saldo5) aqpb281saldo5,
                     T.AQPB281ORI1,
                     T.AQPB281ORI2,
                     T.AQPB281INS,
                     --t.AQPB281AUX1,
                     t.AQPB281AUX2,
                     t.AQPB281AUX3
                      from AQPB281 t
                     where t.aqpb281usur = pv_usuario --'SCRE0204'
                       and t.aqpb281codsbs = lv_codsbsC--'0051279263'  --conyugue 
                       and t.aqpb281ori1 = 'CENTRAL'
                       and t.aqpb281ori2 = 'SALD_REP'    
                       and t.aqpb281aux2 = pv_codsbs -- titular principal                
                     group by t.AQPB281USUR,
                              t.AQPB281CODSBS,
                              t.AQPB281FPROC,
                              t.AQPB281FCR,
                              to_char(sysdate, 'HH24:MI:SS'),
                              '00000',
                              'TOTAL',
                              T.AQPB281ORI1,
                              T.AQPB281ORI2,
                              T.AQPB281INS,
                              --t.AQPB281AUX1,                              
                              t.AQPB281AUX2,
                              T.AQPB281AUX3)
                        ;
    
      commit;     
    exception when others then 
       null;
      -- DBMS_OUTPUT.put_line(sqlerrm);
    end;
    
    
      
  exception
      when others then
        null;  
    
  
  end sp_cr_deu_rep_central;
 ------------------------------------------------------------------------------------------ 
end PQ_CR_MEMO0162024;
/

