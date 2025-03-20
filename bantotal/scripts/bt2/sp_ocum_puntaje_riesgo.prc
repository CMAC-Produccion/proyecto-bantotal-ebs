CREATE OR REPLACE Procedure SP_OCUM_PUNTAJE_RIESGO
---------------------------------------------------------------------------------
--- Autor    : Paola Vargas Longhi (proveedor)
--- Caja Aqp.: Dennis del Carpio Rodriguez (coordinaciones)
--- Objetivo : Insertar el puntaje de riesgo calculado en el datamart de la Oficialia
---            de cumplimiento a las estructuras del sistema Bantotal:JAY474,JAQY474D
---            y JAQZ264 utilizando el dblink "@datawh"
--- Fecha    : 2017.11.29
----------------------------------------------------------------------------------
Is
   
   ld_fecpro date := last_day(add_months(trunc(sysdate),-1));
   ln_period number(6):= to_number(to_char(ld_fecpro,'rrrrmm'));
       
   Type tc_ptjries is Ref Cursor;
   c_ptjrie tc_ptjries;
   
   Type tp_pais  Is table of Number(3);
   Type tp_tdoc  Is table of Number(3);
   Type tp_ndoc  Is table of Varchar2(12);
   Type tp_aomod Is table of Number(3);
   Type tp_aotop Is table of Number(3);
   Type tp_aosuc Is table of Number(3);
   Type tp_aomda Is table of Number(4);
   Type tp_aopap Is table of Number(3);
   Type tp_aocta Is table of Number(9);
   Type tp_aoope Is table of Number(9);
   Type tp_aosbo Is table of Number(3);
   Type tp_fectx Is table of Date;
   Type tp_hortx Is table of Varchar2(12);
   Type tp_suctx Is table of Number(3);
   Type tp_modtx Is table of Number(3);
   Type tp_codtx Is table of Number(3);
   Type tp_reltx Is table of Number(10);
   Type tp_ordtx Is table of Number(5);
   Type tp_sortx Is table of Number(5);
   Type tp_mayim Is table of Number(12,2);
   Type tp_ptjri Is table of Number(17,5);
   Type tp_nivri Is table of Number(3);
   Type tp_codtpe Is table of number(5);
   Type tp_coddom Is table of number(5);
   Type tp_codres Is table of number(5);
   Type tp_codtdo Is table of number(5);
   Type tp_codsjo Is table of number(5);
   Type tp_codocu Is table of number(10);
   Type tp_codpre Is table of number(5);
   Type tp_codbne Is table of number(5);
   Type tp_codttx Is table of number(5);
   Type tp_codmtx Is table of number(5);
   Type tp_codstx Is table of number(5);
   Type tp_codiac Is table of number(5);
   Type tp_codima Is table of number(5);
   Type tp_valtpe Is table of number(5);
   Type tp_valdom Is table of number(5);
   Type tp_valres Is table of number(5);
   Type tp_valtdo Is table of number(5);
   Type tp_valsjo Is table of number(5);
   Type tp_valocu Is table of number(5);
   Type tp_valpre Is table of number(5);
   Type tp_valbne Is table of number(5);
   Type tp_valttx Is table of number(5);
   Type tp_valmtx Is table of number(5);
   Type tp_valstx Is table of number(5);
   Type tp_valiac Is table of number(5);
   Type tp_valima Is table of number(5);
   Type tp_portpe Is table of number(8,4);
   Type tp_pordom Is table of number(8,4);
   Type tp_porres Is table of number(8,4);
   Type tp_portdo Is table of number(8,4);
   Type tp_porsjo Is table of number(8,4);
   Type tp_porocu Is table of number(8,4);
   Type tp_porpre Is table of number(8,4);
   Type tp_porbne Is table of number(8,4);
   Type tp_porttx Is table of number(8,4);
   Type tp_pormtx Is table of number(8,4);
   Type tp_porstx Is table of number(8,4);
   Type tp_poriac Is table of number(8,4);
   Type tp_porima Is table of number(8,4);
   Type tp_desnri Is table of varchar2(30);
      
   n_pais  tp_pais  ;
   n_tdoc  tp_tdoc  ;
   c_ndoc  tp_ndoc  ;
   n_aomod tp_aomod ;
   n_aotop tp_aotop ;
   n_aosuc tp_aosuc ;
   n_aomda tp_aomda ;
   n_aopap tp_aopap ;
   n_aocta tp_aocta ;
   n_aoope tp_aoope ;
   n_aosbo tp_aosbo ;
   d_fectx tp_fectx ;
   v_hortx tp_hortx ;
   n_suctx tp_suctx ;
   n_modtx tp_modtx ;
   n_codtx tp_codtx ;
   n_reltx tp_reltx ;
   n_ordtx tp_ordtx ;
   n_sortx tp_sortx ;
   n_mayim tp_mayim ;
   n_ptjri tp_ptjri ;
   n_nivri tp_nivri ;
   ln_numrg number(10);
   n_codtpe tp_codtpe ;
   n_coddom tp_coddom ;
   n_codres tp_codres ;
   n_codtdo tp_codtdo ;
   n_codsjo tp_codsjo ;
   n_codocu tp_codocu;
   n_codpre tp_codpre ;
   n_codbne tp_codbne ;
   n_codttx tp_codttx ;
   n_codmtx tp_codmtx ;
   n_codstx tp_codstx ;
   n_codiac tp_codiac ;
   n_codima tp_codima ;
   n_valtpe tp_valtpe ;
   n_valdom tp_valdom ;
   n_valres tp_valres ;
   n_valtdo tp_valtdo ;
   n_valsjo tp_valsjo ;
   n_valocu tp_valocu ;
   n_valpre tp_valpre ;
   n_valbne tp_valbne ;
   n_valttx tp_valttx ;
   n_valmtx tp_valmtx ;
   n_valstx tp_valstx ;
   n_valiac tp_valiac ;
   n_valima tp_valima ;
   n_portpe tp_portpe ;
   n_pordom tp_pordom ;
   n_porres tp_porres ;
   n_portdo tp_portdo ;
   n_porsjo tp_porsjo ;
   n_porocu tp_porocu ;
   n_porpre tp_porpre ;
   n_porbne tp_porbne ;
   n_porttx tp_porttx ;
   n_pormtx tp_pormtx ;
   n_porstx tp_porstx ;
   n_poriac tp_poriac ;
   n_porima tp_porima ;
   v_desnri tp_desnri ;
   ln_errms varchar2(200);
   ln_regin number(10):=0;
   lv_user  varchar2(10) := substr(user,1,10);
   
   Function fn_corr_jaqy474(PN_PAIS IN Number,PN_TDOC In Number,PC_NDOC In Varchar2) Return Number
   Is
     ln_nreg Number(10);
   Begin
      Begin
      Select nvl(max(l.jaqy474nreg),0) Into ln_nreg
        From jaqy474 l
       Where l.jaqy474pais=PN_PAIS 
         and l.jaqy474tdoc=PN_TDOC
         and l.jaqy474ndoc=PC_NDOC; 
      Exception When Others Then
        ln_nreg:=0;
      End;   
      Return ln_nreg+1;   
   End;  
   
Begin
   
   -- Eliminar registros si existen
   Delete From jaqy474d d
   Where exists (select 1 from jaqy474 c where c.jaqy474pais=d.jaqy474pais
                   and c.jaqy474tdoc=d.jaqy474tdoc and c.jaqy474ndoc=d.jaqy474ndoc
                   and c.jaqy474nreg=d.jaqy474nreg
                   and c.jaqy474tpr = 2 and c.jaqy474per=ld_fecpro);
  Commit;
  
  Delete From jaqy474 Where jaqy474tpr = 2 and jaqy474per=ld_fecpro;
  Commit;
   
  
  Delete From jaqz264 where jaqz264per = to_char(ld_fecpro,'rrrrmm');
  Commit;
  
  ------------
   
   Open c_ptjrie FOR
        Select c.pais,c.tipo_documento,trim(c.numero_documento),
                l.aomod,l.aotop,l.aosuc,l.aomda,l.aopap,l.aocta,
                l.aoope,l.aosbo,trunc(l.d_fhotrx),to_char(l.d_fhotrx,'HH24:MI:SS'),
                decode(to_number(g.codigo_agencia),0,null,to_number(g.codigo_agencia)),
                decode(x.modulo,-1,null,x.modulo),decode(x.transaccion,-1,null,x.transaccion),l.n_reltrx,
                l.ordtx,l.sortx,l.n_mayimp,l.n_ptjrie,l.nivrie_key,
                nvl(l.n_codtpe,0),l.n_tperva,l.n_tperpo,
                nvl(l.n_coddom,0),l.n_dptdva,l.n_dptdpo,
                nvl(l.n_codres,0),l.n_resiva,l.n_resipo,
                nvl(l.n_codtdo,0),l.n_tdocva,l.n_tdocpo,
                nvl(l.n_codsjo,0),l.n_sujova,l.n_sujopo,
                nvl(l.n_acteco,0),l.n_acteva,l.n_actepo,
                nvl(l.n_codpre,0),l.n_prorva,l.n_prorpo,
                nvl(l.n_codbne,0),l.n_basnva,l.n_basnpo,
                nvl(l.n_codttx,0),l.n_ttrxva,l.n_ttrxpo,
                nvl(l.n_codmtx,0),l.n_mdatva,l.n_mdatpo,
                nvl(l.n_codstx,0),l.n_suctva,l.n_suctcpo,
                nvl(l.n_codiac,0),l.n_totiva,l.n_totipo,
                nvl(l.n_codima,0),l.n_mayiva,l.n_mayipo,n.nivrie_des       
        From fact_oc_puntaje_riesgo@datawh l
        Join dm_cliente@datawh c on c.cliente_key=l.cliente_key
        Join dm_geografia@datawh g on g.geografia_key=l.geografia_key
        Join dm_transaccion@datawh x on x.transacc_key=l.transacc_key
        Join dm_pr_nivel@datawh n on n.nivrie_key=l.nivrie_key
      Where l.periodo = ln_period
        and l.nivrie_key > 2; /*Nivel de Riesgo Medio,Alto y Muy Alto*/
        

        
   Loop
       FETCH c_ptjrie BULK COLLECT INTO
             n_pais ,n_tdoc ,c_ndoc ,n_aomod,n_aotop,n_aosuc,n_aomda,n_aopap,
             n_aocta,n_aoope,n_aosbo,d_fectx,v_hortx,n_suctx,n_modtx,n_codtx,
             n_reltx,n_ordtx,n_sortx,n_mayim,n_ptjri,n_nivri,
             n_codtpe,n_valtpe,n_portpe, 
             n_coddom,n_valdom,n_pordom,
             n_codres,n_valres,n_porres,
             n_codtdo,n_valtdo,n_portdo,
             n_codsjo,n_valsjo,n_porsjo,
             n_codocu,n_valocu,n_porocu,
             n_codpre,n_valpre,n_porpre,
             n_codbne,n_valbne,n_porbne,
             n_codttx,n_valttx,n_porttx,
             n_codmtx,n_valmtx,n_pormtx,
             n_codstx,n_valstx,n_porstx,
             n_codiac,n_valiac,n_poriac,
             n_codima,n_valima,n_porima,v_desnri
       LIMIT 1000;            
       
          FOR x IN 1 .. n_pais.COUNT Loop   
             ln_numrg:=fn_corr_jaqy474(n_pais(x),n_tdoc(x),c_ndoc(x));
             Begin
             Insert into JAQY474(JAQY474pais,JAQY474tdoc,JAQY474ndoc,JAQY474nreg,
                                 JAQY474pmod,JAQY474ptop,  JAQY474psuc,JAQY474pmon,
                                 JAQY474ppap,JAQY474pcta,JAQY474pope,JAQY474psop,
                                 JAQY474tfec,JAQY474hora,JAQY474tsuc,JAQY474tmod,
                                 JAQY474ttrn,JAQY474trel,JAQY474tord,JAQY474tsor,
                                 JAQY474impo,JAQY474laft,JAQY474nivr,JAQY474esta,
                                 jaqy474PER,jaqy474TPR) ---
                     VALUES(n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,
                            n_aomod(x),n_aotop(x),n_aosuc(x),n_aomda(x),
                            n_aopap(x),n_aocta(x),n_aoope(x),n_aosbo(x),
                            d_fectx(x),v_hortx(x),n_suctx(x),n_modtx(x),
                            n_codtx(x),n_reltx(x),n_ordtx(x),n_sortx(x),
                            n_mayim(x),n_ptjri(x),n_nivri(x),'V',
                            ld_fecpro,2
                           );                                 
                --- DETALLE
                INSERT INTO JAQY474D(JAQY474PAIS,JAQY474TDOC,JAQY474NDOC,JAQY474NREG,
                                     JAQY474DNUMFAC,JAQY474DCODFAC,JAQY474DVAL,JAQY474DPON,JAQY474DPTJ)
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,1,n_codtpe(x),n_valtpe(x),n_portpe(x),nvl(n_valtpe(x),0)*nvl(n_portpe(x),0) From dual                     
                union all 
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,2,n_coddom(x),n_valdom(x),n_pordom(x),nvl(n_valdom(x),0)*nvl(n_pordom(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,3,n_codres(x),n_valres(x),n_porres(x),nvl(n_valres(x),0)*nvl(n_porres(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,4,n_codtdo(x),n_valtdo(x),n_portdo(x),nvl(n_valtdo(x),0)*nvl(n_portdo(x),0) From dual 
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,5,n_codsjo(x),n_valsjo(x),n_porsjo(x),nvl(n_valsjo(x),0)*nvl(n_porsjo(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,6,n_codocu(x),n_valocu(x),n_porocu(x),nvl(n_valocu(x),0)*nvl(n_porocu(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,7,n_codpre(x),n_valpre(x),n_porpre(x),nvl(n_valpre(x),0)*nvl(n_porpre(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,8,n_codbne(x),n_valbne(x),n_porbne(x),nvl(n_valbne(x),0)*nvl(n_porbne(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,9,n_codttx(x),n_valttx(x),n_porttx(x),nvl(n_valttx(x),0)*nvl(n_porttx(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,10,n_codmtx(x),n_valmtx(x),n_porpre(x),nvl(n_valmtx(x),0)*nvl(n_pormtx(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,11,n_codstx(x),n_valstx(x),n_porstx(x),nvl(n_valstx(x),0)*nvl(n_porstx(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,12,n_codiac(x),n_valiac(x),n_poriac(x),nvl(n_valiac(x),0)*nvl(n_poriac(x),0) From dual
                union all
                Select n_pais(x),n_tdoc(x),c_ndoc(x),ln_numrg,13,n_codima(x),n_valima(x),n_porima(x),nvl(n_valima(x),0)*nvl(n_porima(x),0) From dual;
                
                
                --- MENSUAL
                Insert Into jaqz264(jaqz264per,jaqz264tdoc,jaqz264ndoc,jaqz264cal,jaqz264ptj,jaqz264usu,jaqz264fec)
                Values(to_char(ld_fecpro,'rrrrmm'),n_tdoc(x),c_ndoc(x),v_desnri(x),n_ptjri(x),lv_user,sysdate);
                
                ln_regin:=ln_regin+1;
                If mod(ln_regin,5000)=0 Then
                   Commit;
                   ln_regin:=0;
                End If;   
           Exception When Others Then
              ln_errms := substr(sqlerrm,1,200);
              dbms_output.put_line(n_pais(x)||'-'||n_tdoc(x)||'-'||c_ndoc(x)||'-'||ln_numrg||': '||ln_errms);
              exit;
           End;     
         End Loop;     
         Commit;  
   Exit When c_ptjrie%Notfound;
   End Loop;
End SP_OCUM_PUNTAJE_RIESGO;
/

