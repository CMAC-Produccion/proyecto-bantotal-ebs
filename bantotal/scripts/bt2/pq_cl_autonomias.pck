create or replace package pq_cl_autonomias is
    -- *****************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER AUTONOMIAS DE FACULTADES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.11.12
    -- Autor de Creación          : yRVING LOZADA
    -- Uso                        : Realiza cálculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Autor Modificacion	        : Yrving Lozada
    -- fecha		                  : 29/04/2024
    -- Modificacion 	            : Optimizacuib de reporte dictamen legal
    -- Autor Modificacion	        : Yrving Lozada
    -- fecha		                  : 23/05/2024
    -- Modificacion 	           : Corrección generación de código de grupo para facultades INDISTINTAS Y CONJUNTAS
    -- *****************************************************************

  TYPE paisarray IS VARRAY(20) OF NUMBER(3);
  TYPE tposarray IS VARRAY(20) OF NUMBER(2);
  TYPE numsarray IS VARRAY(20) OF CHAR(12);
  
   procedure sp_cl_valida_archivo(pc_documento in  varchar2,
	                                pc_existe    out varchar2
                                 );
   procedure sp_ah_valida_grupo(pn_codpgc in number, 
                                pn_codsuc in number, 
                                pn_codmod in number, 
                                pn_codtrx in number, 
                                pn_codrel in number, 
                                pn_codfec in date, 
                                pn_pais   in number, 
                                pn_tipdoc in number, 
                                pc_numdoc in varchar2, 
                                pc_tipcal in varchar2,
                                pn_mdaope in number,
                                pn_monimp in number
                               );
  Procedure sp_cl_elimina_data(pn_codpgc in number, 
                               pn_codsuc in number, 
                               pn_codmod in number, 
                               pn_codtrx in number, 
                               pn_codrel in number, 
                               pn_codfec in date,
                               pn_indaxs in number
                               );                               
  
  procedure sp_ah_llena_vincul(pn_codpgc in number, 
                               pn_codsuc in number, 
                               pn_codmod in number, 
                               pn_codtrx in number, 
                               pn_codrel in number, 
                               pn_codfec in date, 
                               pn_pais   in number, 
                               pn_tipdoc in number, 
                               pc_numdoc in varchar2,
                               pn_numcta in number,
                               pc_tipper in varchar2
                               );       
  procedure sp_ah_llena_validos(pn_codpgc in number, 
                                pn_codsuc in number, 
                                pn_codmod in number, 
                                pn_codtrx in number, 
                                pn_codrel in number, 
                                pn_codfec in date, 
                                /*
                                pn_pais   in number,                                 
                                pn_tipdoc in number, 
                                pc_numdoc in varchar2,
                                */
                                pn_faccod in number, 
                                pn_faccor in number, 
                                pd_fecdes in date,
                                --pn_coreel in number,
                                pn_numcta in number
                                );    
                                
  Procedure sp_ah_mail_actcta_PJ(pn_codpgc in number, 
                                 pn_codmod in number, 
                                 pn_codsuc in number, 
                                 pn_codmda in number, 
                                 pn_codpap in number, 
                                 pn_codcta in number, 
                                 pn_codope in number, 
                                 pn_codsub in number, 
                                 pn_codtpo in number, 
                                 pn_estant in number,
                                 pc_codusu in varchar2
                                 );                                                                              
  Procedure sp_valida_dup_grupo(PN_PGCOD  IN NUMBER,
                                PN_PAIS   IN NUMBER, 
                                PN_TIPO   IN NUMBER,
                                PN_NUMERO IN VARCHAR2,     
                                PN_CTNRO  IN NUMBER,
                                PN_FACCOD IN NUMBER,
                                PN_FACCOR IN NUMBER,    
                                PD_FECINI IN DATE,        
                                PD_FECFIN IN DATE,
                                PC_TIPFAC IN VARCHAR2,
                                pc_exist  out varchar2                                   
                               );
  /*                                                                
  Procedure sp_procesa_fac(P_C_CODMOD IN VARCHAR2,
                           P_N_CODPAI IN NUMBER,
                           P_N_CODTPO IN NUMBER,
                           P_C_CODNUM IN VARCHAR2,
                           P_N_CODPA2 IN NUMBER,
                           P_N_CODTP2 IN NUMBER,
                           P_C_CODNU2 IN VARCHAR2,
                           P_N_CODFAC IN NUMBER,
                           P_D_CODVID IN DATE,
                           P_D_CODVIH IN DATE,
                           P_N_CODLIS IN NUMBER,
                           P_N_CODLID IN NUMBER,
                           P_C_CODTFA IN VARCHAR2,
                           p_n_coderr out number,
                           p_c_deserr out varchar2
                          );   
*/      
                       
Procedure sp_genera_grupos(pc_usuari in varchar2,
                             pd_fecpro in date,          
                             pc_tipreg in varchar2,
                             pc_indall in varchar2,
                             pn_paijur in number, 
                             pn_tipjur in number, 
                             pc_numjur in varchar2, 
                             pn_numcta in number,
                             pc_codmas in varchar2,
                             pc_tipgru in varchar2, 
                             pn_codfac in number,
                             pc_indind in varchar2,
                             pd_fecini in date,
                             pd_fecfin in date,
                             pn_totsol in number,
                             pn_totdol in number,                            
                             pn_painat in number, 
                             pn_tipnat in number, 
                             pc_numnat in varchar2,                              
                             p_n_pgcod in number, 
                             p_n_scmod in number, 
                             p_n_scsuc in number, 
                             p_n_scmda in number, 
                             p_n_scpap in number, 
                             p_n_sccta in number, 
                             pn_scoper in number, 
                             pn_scsbop in number, 
                             pn_sctope in number, 
                             pc_coderr out varchar2,                              
                             pc_msgerr out varchar2                             
                            );                                                   
  Procedure sp_modifica_grupos(pc_usuari in varchar2,
                               pd_fecpro in date,          
                               pc_tipreg in varchar2,
                               pc_codmas in varchar2,
                               pn_paijur in number, 
                               pn_tipjur in number, 
                               pc_numjur in varchar2,                                                                       
                               pn_numcta in number,
                               pn_codfac in number,
                               pn_painat in number, 
                               pn_tipnat in number, 
                               pc_numnat in varchar2,                              
                               pc_coderr out varchar2,                              
                               pc_msgerr out varchar2                             
                              );                          
 Procedure sp_genera_asociaciones(pc_usuari in varchar2,
                                  pc_tipreg in varchar2,
                                  pc_tipagr in varchar2,
                                  pn_codpgc in number, 
                                  pn_codmod in number, 
                                  pn_codsuc in number, 
                                  pn_codmda in number, 
                                  pn_codpap in number, 
                                  pn_codcta in number, 
                                  pn_codope in number, 
                                  pn_codsbo in number, 
                                  pn_codtop in number, 
                                  pn_painat in number, 
                                  pn_tipnat in number, 
                                  pc_numnat in varchar2,   
                                  pn_codide in number,                          
                                  pc_coderr out varchar2,                              
                                  pc_msgerr out varchar2                             
                                 );
  Function fn_genera_ide return number;                                 
  Procedure sp_reg_selecgrupo_trx(P_N_CODPGC IN NUMBER,                                 
                                  P_N_CODSUC IN NUMBER,                                 
                                  P_N_CODMOD IN NUMBER,                                 
                                  P_N_CODTRX IN NUMBER,                                 
                                  P_N_CODREL IN NUMBER,                                 
                                  P_D_CODFEC IN DATE,                                   
                                  P_C_CODUSR IN VARCHAR2,                                   
                                  P_N_CODPAI IN NUMBER,                                   
                                  P_N_CODTPO IN NUMBER,                                   
                                  P_C_CODNUM IN VARCHAR2,                                   
                                  P_N_CODCTA IN NUMBER,                                   
                                  P_N_CODFAC IN NUMBER,                                   
                                  P_N_CODFCO IN NUMBER,                                   
                                  P_D_CODFDE IN DATE                                   
                                 );  
  Procedure sp_val_fac_trx_HB(P_N_CODPGC IN NUMBER,                                 
                              P_N_CODSUC IN NUMBER,                                 
                              P_N_CODMOD IN NUMBER,                                 
                              P_N_CODTRX IN NUMBER,                                 
                              P_N_CODREL IN NUMBER, 
                              P_N_NUMORD IN NUMBER,                                 
                              P_D_FECPRO IN DATE,                                   
                              P_N_CODPAI IN paisarray,                                   
                              P_N_CODTPO IN tposarray,                                   
                              P_C_CODNUM IN numsarray                                   
                             );
  type vc_array is table of number(9) index by pls_integer;                                                                              
  TYPE rec_repre IS RECORD(Orden  NUMBER(5),
                           Cuenta NUMBER(9),
                           Pais   NUMBER(3),
                           Tipdoc NUMBER(2),
                           Numdoc CHAR(12)
                           );
     
  TYPE tp_repre IS TABLE OF rec_repre INDEX BY BINARY_INTEGER; 
 
  PROCEDURE sp_cl_quickSort(v_arr   in out vc_array,
                            n_first number,
                            n_last  number
                           );
  Procedure sp_cl_facultades(P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_N_NUMDOC IN VARCHAR2,
                            P_N_NUMCTA IN NUMBER,
                            P_N_CODFAC IN NUMBER,
                            P_C_TIPFAC IN VARCHAR2,
                            p_c_desfac out varchar2           
                            );      
  Procedure sp_cl_facultades_ah(P_N_CODPAI IN NUMBER,
                                P_N_TIPDOC IN NUMBER,
                                P_N_NUMDOC IN VARCHAR2,
                                P_N_NUMCTA IN NUMBER,
                                P_N_CODFAC IN NUMBER,
                                P_C_TIPFAC IN VARCHAR2,
                                p_c_desfac out varchar2           
                                );
  Procedure sp_cl_facultades_cr(P_N_CODPAI IN NUMBER,
                                P_N_TIPDOC IN NUMBER,
                                P_N_NUMDOC IN VARCHAR2,
                                P_N_CODFAC IN NUMBER,
                                P_C_TIPFAC IN VARCHAR2,
                                p_c_desfac out varchar2           
                                );                                                                            
end pq_cl_autonomias;
/

create or replace package body pq_cl_autonomias is
  
  procedure sp_cl_valida_archivo(pc_documento in  varchar2,
                                 pc_existe    out varchar2
                                ) is
  begin
    select 'SI'
     into pc_existe
     from jaql001
    where dbms_lob.getlength(jaql1firma) > 0
    and jaql1pendo = pc_documento;
  exception
  when others then
    pc_existe := 'NO';
  end sp_cl_valida_archivo;  
  
  procedure sp_ah_valida_grupo(pn_codpgc in number, 
                               pn_codsuc in number, 
                               pn_codmod in number, 
                               pn_codtrx in number, 
                               pn_codrel in number, 
                               pn_codfec in date, 
                               pn_pais   in number, 
                               pn_tipdoc in number, 
                               pc_numdoc in varchar2, 
                               pc_tipcal in varchar2,
                               pn_mdaope in number,
                               pn_monimp in number
                               ) is
  cursor c_grupospas(pn_cuenta in number) is
    select b.* 
      from fse130 a,
           fsr130 b
     where a.pgcod = b.pgcod
       and a.ctnro = b.ctnro
       and a.faccod = b.faccod
       and a.ctfaccor = b.ctfaccor
       and a.ctfecdes = b.ctfecdes
       and a.ctfacvig = 'S'
       and a.pgcod = 1
       and a.ctnro = pn_cuenta        
       and case
           when pn_mdaope = 0 then
             a.ctfaclimmn
           Else
             a.ctfaclim
           end >= pn_monimp
  order by b.pfndo2,a.ctfaccor;                                       
  
  cursor c_gruposact(pn_pais in number,pn_tipo in number,pn_docu in varchar2) is
    select b.* 
      from jaql499 a,
           jaqz151 b
     where a.jaql499pgc = b.jaqz151pgc
       and a.jaql499pai = b.jaqz151pai
       and a.jaql499tpo = b.jaqz151tpo
       and a.jaql499num = b.jaqz151num
       and a.jaql499fco = b.jaqz151fco
       and a.jaql499fcc = b.jaqz151fcc
       and a.jaql499vid = b.jaqz151vid
       and a.jaql499est = 'S'
       and a.jaql499pgc = 12
       and a.jaql499pai = pn_pais
       and a.jaql499tpo = pn_tipo
       and a.jaql499num = rpad(pn_docu,10,' ')
       and case
           when pn_mdaope = 0 then
             a.jaql499lis
           Else
             a.jaql499lid
           end >= pn_monimp
  order by b.jaqz151nu2,b.jaqz151fcc;
  
  
  ln_paiant number(3) :=0; 
  ln_tpoant number(2); 
  lc_docant char(12):= 'X';
  ln_painew number(3);
  ln_tponew number(2);
  lc_docnew char(12);
  lc_grupos varchar2(60);
  lc_gruant varchar2(60);
  ln_pais   number(3);
  ln_tipo   number(2);
  lc_docu   char(12);
  lc_penom  char(30);
  ln_flag   number(1):= 0;
  ln_cont   number(4):= 0;
  CONTADO   number(4):= 0;
  begin
     
    begin
      -- Call the procedure
      pq_cl_autonomias.sp_cl_elimina_data(pn_codpgc => pn_codpgc,
                                          pn_codsuc => pn_codsuc,
                                          pn_codmod => pn_codmod,
                                          pn_codtrx => pn_codtrx,
                                          pn_codrel => pn_codrel,
                                          pn_codfec => pn_codfec,
                                          pn_indaxs =>0
                                          );
    end;  
  
    If pc_tipcal = 'P' then
      for i in c_grupospas(pn_pais) loop    
        CONTADO   := CONTADO + 1;
        ln_painew := i.pfpai2;
        ln_tponew := i.pftdo2;
        lc_docnew := i.pfndo2;
        If lc_docnew = lc_docant then
           lc_grupos := lc_grupos || ','||to_char(i.ctfaccor);
        Else         
           lc_grupos := to_char(i.ctfaccor);         
           if CONTADO > 1 then
              ln_pais := ln_paiant;
              ln_tipo := ln_tpoant;
              lc_docu := lc_docant;    
                               
               begin
                  select a.penom
                    into lc_penom 
                    from fsd001 a 
                   where a.pepais = ln_pais
                     and a.petdoc = ln_tipo
                     and a.pendoc = lc_docu;
                exception
                when others then
                  lc_penom := null;
               end;  
               ln_cont := ln_cont + 1;         
                 begin
                  insert into JAQZ152(jaqz152pgc,
                                      jaqz152suc,
                                      jaqz152mod,
                                      jaqz152trx,
                                      jaqz152rel,
                                      jaqz152fec,
                                      jaqz152cor,
                                      jaqz152pai,
                                      jaqz152tpo,
                                      jaqz152num,
                                      jaqz152nom,
                                      jaqz152cad            
                                      )
                                values(pn_codpgc, 
                                       pn_codsuc,
                                       pn_codmod, 
                                       pn_codtrx,
                                       pn_codrel, 
                                       pn_codfec,
                                       ln_cont, 
                                       ln_pais,
                                       ln_tipo,
                                       lc_docu,
                                       lc_penom,
                                       lc_gruant--lc_grupos                                 
                                      );
                 ln_flag := 1;
                 end;   
           end if;           
        End If;    

        ln_paiant := ln_painew;
        ln_tpoant := ln_tponew;
        lc_docant := lc_docnew;
        lc_gruant := lc_grupos;
        
  /*      if ln_flag = 1 then
           lc_grupos := null;
        end if;   */
        
      End loop;
          
     ln_pais := ln_paiant;
     ln_tipo := ln_tpoant;
     lc_docu := lc_docant;    
         
     begin
        select a.penom
          into lc_penom 
          from fsd001 a 
         where a.pepais = ln_pais
           and a.petdoc = ln_tipo
           and a.pendoc = lc_docu;
      exception
      when others then
        lc_penom := null;
     end;  
     ln_cont := ln_cont + 1;         
     begin
      insert into JAQZ152(jaqz152pgc,
                          jaqz152suc,
                          jaqz152mod,
                          jaqz152trx,
                          jaqz152rel,
                          jaqz152fec,
                          jaqz152cor,
                          jaqz152pai,
                          jaqz152tpo,
                          jaqz152num,
                          jaqz152nom,
                          jaqz152cad            
                          )
                    values(pn_codpgc, 
                           pn_codsuc,
                           pn_codmod, 
                           pn_codtrx,
                           pn_codrel, 
                           pn_codfec, 
                           ln_cont,
                           ln_pais,
                           ln_tipo,
                           lc_docu,
                           lc_penom,
                           lc_gruant  
                          );
     end;   
    Else  
      for i in c_gruposact(pn_pais,pn_tipdoc,pc_numdoc) loop    
        CONTADO   := CONTADO + 1;
        ln_painew := i.jaqz151pa2;
        ln_tponew := i.jaqz151tp2;
        lc_docnew := i.jaqz151nu2;
        If lc_docnew = lc_docant then
           lc_grupos := lc_grupos || ','||to_char(i.jaqz151fcc);
        Else         
           lc_grupos := to_char(i.jaqz151fcc);         
           if CONTADO > 1 then
              ln_pais := ln_paiant;
              ln_tipo := ln_tpoant;
              lc_docu := lc_docant;    
                               
               begin
                  select a.penom
                    into lc_penom 
                    from fsd001 a 
                   where a.pepais = ln_pais
                     and a.petdoc = ln_tipo
                     and a.pendoc = lc_docu;
                exception
                when others then
                  lc_penom := null;
               end;  
               ln_cont := ln_cont + 1;         
                 begin
                  insert into JAQZ152(jaqz152pgc,
                                      jaqz152suc,
                                      jaqz152mod,
                                      jaqz152trx,
                                      jaqz152rel,
                                      jaqz152fec,
                                      jaqz152cor,
                                      jaqz152pai,
                                      jaqz152tpo,
                                      jaqz152num,
                                      jaqz152nom,
                                      jaqz152cad            
                                      )
                                values(pn_codpgc, 
                                       pn_codsuc,
                                       pn_codmod, 
                                       pn_codtrx,
                                       pn_codrel, 
                                       pn_codfec,
                                       ln_cont, 
                                       ln_pais,
                                       ln_tipo,
                                       lc_docu,
                                       lc_penom,
                                       lc_gruant--lc_grupos                                 
                                      );
                 ln_flag := 1;
                 end;   
           end if;           
        End If;    

        ln_paiant := ln_painew;
        ln_tpoant := ln_tponew;
        lc_docant := lc_docnew;
        lc_gruant := lc_grupos;
        
  /*      if ln_flag = 1 then
           lc_grupos := null;
        end if;   */
        
      End loop;
          
     ln_pais := ln_paiant;
     ln_tipo := ln_tpoant;
     lc_docu := lc_docant;    
         
     begin
        select a.penom
          into lc_penom 
          from fsd001 a 
         where a.pepais = ln_pais
           and a.petdoc = ln_tipo
           and a.pendoc = lc_docu;
      exception
      when others then
        lc_penom := null;
     end;  
     ln_cont := ln_cont + 1;         
     begin
      insert into JAQZ152(jaqz152pgc,
                          jaqz152suc,
                          jaqz152mod,
                          jaqz152trx,
                          jaqz152rel,
                          jaqz152fec,
                          jaqz152cor,
                          jaqz152pai,
                          jaqz152tpo,
                          jaqz152num,
                          jaqz152nom,
                          jaqz152cad            
                          )
                    values(pn_codpgc, 
                           pn_codsuc,
                           pn_codmod, 
                           pn_codtrx,
                           pn_codrel, 
                           pn_codfec, 
                           ln_cont,
                           ln_pais,
                           ln_tipo,
                           lc_docu,
                           lc_penom,
                           lc_gruant  
                          );
     end;   
    End If;  
  Exception
  when others then  
    null;
  end sp_ah_valida_grupo;
  Procedure sp_cl_elimina_data(pn_codpgc in number, 
                               pn_codsuc in number, 
                               pn_codmod in number, 
                               pn_codtrx in number, 
                               pn_codrel in number, 
                               pn_codfec in date,
                               pn_indaxs in number
                               ) is
  PRAGMA AUTONOMOUS_TRANSACTION;                                  
  begin
    if pn_indaxs = 0 then      
        delete 
          from jaqz152 a 
         where a.jaqz152pgc = pn_codpgc
           and a.jaqz152suc = pn_codsuc
           and a.jaqz152mod = pn_codmod
           and a.jaqz152trx = pn_codtrx
           and a.jaqz152rel = pn_codrel
           and a.jaqz152fec = pn_codfec;
    Else
        delete 
          from jaqz152 a 
         where a.jaqz152pgc = pn_codpgc
           and a.jaqz152suc = pn_codsuc
           and a.jaqz152mod = pn_codmod
           and a.jaqz152trx = pn_codtrx
           and a.jaqz152rel = pn_codrel
           and a.jaqz152fec = pn_codfec
           and a.jaqz152ax1 = pn_indaxs;     
    End If;   
    commit;
  Exception
  when others then  
    null;
  end sp_cl_elimina_data;   
                              
  procedure sp_ah_llena_vincul(pn_codpgc in number, 
                               pn_codsuc in number, 
                               pn_codmod in number, 
                               pn_codtrx in number, 
                               pn_codrel in number, 
                               pn_codfec in date, 
                               pn_pais   in number, 
                               pn_tipdoc in number, 
                               pc_numdoc in varchar2,
                               pn_numcta in number,
                               pc_tipper in varchar2
                               ) is  
  PRAGMA AUTONOMOUS_TRANSACTION;                                   
  cursor c_vinculados is
    select distinct 
           a.pfpai1,
           a.pftdo1,
           a.pfndo1,
           b.penom 
      from fsr003 a,
           fsd001 b
     where a.pfpai1 = b.pepais
       and a.pftdo1 = b.petdoc
       and a.pfndo1 = b.pendoc
       and a.Pjpais = pn_pais
       and a.Pjtdoc = pn_tipdoc
       and a.Pjndoc = rpad(pc_numdoc,12,' ');
       
  ln_cont number:=0;     
  
  cursor c_integrantes is  
    select a.pepais,
           a.petdoc,
           a.pendoc,
           b.penom	 
      from fsr008 a,
           fsd001 b
     where a.pepais = b.pepais
       and a.petdoc = b.petdoc
       and a.pendoc = b.pendoc
       and a.Pgcod = pn_codpgc 
       and a.Ctnro = pn_numcta;
       
  begin
    if pc_tipper = 'J' then   
      For i in c_vinculados loop
          ln_cont := ln_cont + 1;
          insert into jaqz152(jaqz152pgc,
                              jaqz152suc,
                              jaqz152mod,
                              jaqz152trx,
                              jaqz152rel,
                              jaqz152fec,
                              jaqz152cor,
                              jaqz152pai,
                              jaqz152tpo,
                              jaqz152num,
                              jaqz152nom,
                              jaqz152ax1,
                              jaqz152ax3,
                              jaqz152ax4,
                              jaqz152ax7                                
                             )
                      values(pn_codpgc,
                             pn_codsuc,
                             pn_codmod,
                             pn_codtrx,
                             pn_codrel,
                             pn_codfec,
                             ln_cont,
                             i.pfpai1,
                             i.pftdo1,
                             i.pfndo1,
                             i.penom,
                             1, --indicador de integrantes                    
                             0,
                             0,
                             trunc(sysdate)
                             ); 
      End Loop;
    Else
      For i in c_integrantes loop
          ln_cont := ln_cont + 1;
          insert into jaqz152(jaqz152pgc,
                              jaqz152suc,
                              jaqz152mod,
                              jaqz152trx,
                              jaqz152rel,
                              jaqz152fec,
                              jaqz152cor,
                              jaqz152pai,
                              jaqz152tpo,
                              jaqz152num,
                              jaqz152nom,
                              jaqz152ax1,
                              jaqz152ax3,
                              jaqz152ax4,
                              jaqz152ax7                                                              
                             )
                      values(pn_codpgc,
                             pn_codsuc,
                             pn_codmod,
                             pn_codtrx,
                             pn_codrel,
                             pn_codfec,
                             ln_cont,
                             i.pepais,
                             i.petdoc,
                             i.pendoc,
                             i.penom,
                             1 ,--indicador de integrantes                    
                             0,
                             0,
                             trunc(sysdate)                             
                             ); 
      End Loop;      
    End If;
    commit;
  Exception
  when others then   
    null;
  end sp_ah_llena_vincul;          
  procedure sp_ah_llena_validos(pn_codpgc in number, 
                                pn_codsuc in number, 
                                pn_codmod in number, 
                                pn_codtrx in number, 
                                pn_codrel in number, 
                                pn_codfec in date, 
                                /*
                                pn_pais   in number, 
                                pn_tipdoc in number, 
                                pc_numdoc in varchar2,                                                           
                                */
                                pn_faccod in number, 
                                pn_faccor in number, 
                                pd_fecdes in date,                                
                                --pn_coreel in number,
                                pn_numcta in number
                                ) is  
  PRAGMA AUTONOMOUS_TRANSACTION;       
  --lc_msgerr varchar2(100);
  cursor c_grupos is
    select a.pfpai2,a.pftdo2,a.pfndo2
      from fsr130 a
     where a.pgcod    = pn_codpgc
       and a.ctnro    = pn_numcta
       and a.faccod   = pn_faccod
       and a.ctfaccor = pn_faccor
       and a.ctfecdes = pd_fecdes;
  begin          
    For i in c_grupos loop     
        begin                 
          insert into jaqz152(jaqz152pgc,
                              jaqz152suc,
                              jaqz152mod,
                              jaqz152trx,
                              jaqz152rel,
                              jaqz152fec,
                              --jaqz152cor,
                              jaqz152pai,                              
                              jaqz152tpo,
                              jaqz152num,
                              jaqz152ax3,
                              jaqz152ax4,
                              jaqz152ax7,                              
                              jaqz152ax1
                             )
                      values(pn_codpgc,
                             pn_codsuc,
                             pn_codmod,
                             pn_codtrx,
                             pn_codrel,
                             pn_codfec,
                             --pn_coreel,
                             i.pfpai2,--pn_pais  ,
                             i.pftdo2,--pn_tipdoc,
                             i.pfndo2,--pc_numdoc,                             
                             pn_faccod,
                             pn_faccor,
                             pd_fecdes,
                             2 --indicador de integrantes                    
                             );    
        Exception                                                          
        When others then 
        /*  lc_msgerr := sqlerrm;
          insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(123,'jaqz152',lc_msgerr,trunc(sysdate))  ;      
          commit;  */         
          null;
        end;                             
    end loop;                                                          
    commit;                             
  exception
  when others then                         
    
/*    lc_msgerr := sqlerrm;
    insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(123,'jaqz152',lc_msgerr,trunc(sysdate))  ;      
    commit;                            
*/    
    null;
  End sp_ah_llena_validos;      
  Procedure sp_ah_mail_actcta_PJ(pn_codpgc in number, 
                                 pn_codmod in number, 
                                 pn_codsuc in number, 
                                 pn_codmda in number, 
                                 pn_codpap in number, 
                                 pn_codcta in number, 
                                 pn_codope in number, 
                                 pn_codsub in number, 
                                 pn_codtpo in number, 
                                 pn_estant in number,
                                 pc_codusu in varchar2
                                 ) is
  lv_mensaje    VARCHAR2(32767);
  ll_mensaje    CLOB;  
  Lv_descta     Varchar2(45);    
  ld_fecpro     date; 
  lc_producto   varchar2(27):='';  
  lc_sucursal   varchar2(30):='';   
  lv_mail       varchar2(50);       
  ln_estact     fsd011.scstat%type; 
  lc_desant     varchar2(30);                   
  lc_desact     varchar2(30);  
  ln_pais       number(3);
  ln_tipo       number(3);
  lv_numdoc     varchar2(12);  
  ln_indpro     number(1):=0;
  ln_sucdes     number(3);
  lc_hora       char(8);
  begin
    --validamos el nuevo estado 
    begin
       select a.scstat
         into ln_estact 
         from fsd011 a 
        where a.pgcod  = pn_codpgc
          and a.scsuc  = pn_codsuc
          and a.scmda  = pn_codmda
          and a.scpap  = pn_codpap
          and a.sccta  = pn_codcta
          and a.scoper = pn_codope
          and a.scsbop = pn_codsub
          and a.sctope = pn_codtpo
          and a.scmod  = pn_codmod;     
    exception
    when others then  
      ln_estact := null;
    end;
    begin
      select a.ctnom,
             b.pepais,
             b.petdoc,
             trim(b.pendoc)
        into Lv_descta, 
             ln_pais,
             ln_tipo,
             lv_numdoc
        from fsd008 a,
             fsr008 b 
       where a.pgcod = b.pgcod
         and a.ctnro = b.ctnro
         and a.pgcod = pn_codpgc 
         and a.ctnro = pn_codcta;
    exception
    when others then
      Lv_descta := null;
    end;    
    
    begin
      select 1,x.jaqy690mail
        into ln_indpro, lv_mail
        from (
               select a.*          
                 from jaqy690 a 
                where a.jaqy690pais = ln_pais
                  and a.jaqy690tdoc = ln_tipo
                  and a.jaqy690nruc = lv_numdoc
                  and a.jaqy690esta = 'P'
                order by jaqy690fech desc, jaqy690hora desc
              ) x
        where rownum < 2 ;     
    exception
    when others then  
      ln_indpro := 0;
      lv_mail   := null;
    end;    
    
    if ln_estact = 0 and ln_indpro = 1 then
        lc_hora := to_char(sysdate,'HH24:mi:ss');
        begin
          select a.pgfape
            into ld_fecpro 
            from fst017 a 
           where a.pgcod = pn_codpgc;
        exception
        when others then
          ld_fecpro := null;
        end;

        begin
          select a.ubsuc
            into ln_sucdes 
            from fst046 a 
           where a.pgcod  = pn_codpgc 
             and a.ubuser = rpad(pc_codusu,10,' ');
        exception
        when others then
          ln_sucdes := 0;
        end;    
                       
        begin
          select a.scnom
            into lc_sucursal 
            from fst001 a 
           where a.pgcod  = pn_codpgc 
             and a.sucurs = ln_sucdes;
        exception
        when others then
          lc_sucursal := null;
        end;    
        
        begin
          select upper(a.cenom)
            into lc_desant 
            from fst026 a 
           where a.cecod = pn_estant;
        exception
        when others then  
          lc_desant := null;
        end;       
        
        begin
          select upper(a.cenom)
            into lc_desact 
            from fst026 a 
           where a.cecod = ln_estact;
        exception
        when others then  
          lc_desact := null;
        end;       
                
        Lv_descta := pn_codcta || ' - '|| trim(Lv_descta);
        
        if pn_codmod = 21 then
           lc_producto := lpad(pn_codcta,9,'0')||lpad(pn_codmod,3,'0')||lpad(pn_codmda,3,'0')||lpad(pn_codsub,2,'0')||lpad(pn_codtpo,3,'0');                                              
        Else
           lc_producto := lpad(pn_codcta,9,'0')||lpad(pn_codmod,3,'0')||lpad(pn_codmda,3,'0')||lpad(pn_codope,9,'0')||lpad(pn_codtpo,3,'0');                     
        End IF;
        
        --GENERA MAIL 
        dbms_lob.createtemporary(ll_mensaje, TRUE);    
        lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Estimado Usuario : </p>' ||  
                      '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Se informa sobre el siguiente DESBLOQUEO DE CUENTA realizado en el Sistema Bantotal.</p><br/>';  
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
                            
              lv_mensaje := --ll_mensaje ||                                                
              '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
              '<table cellspacing=0 cellpadding=2 width=650>'||
              '  <tr>'||
              '    <td width="200" style="border-bottom: 1px solid black;"><b>Datos:</b></td>'||
              '    <td width="200" style="border-bottom: 1px solid black;"><b></b></td>'||
              '  </tr>          ';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);       
              

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Cuenta Cliente:'||'</td>'||
        '    <td align="left">'||Lv_descta||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Producto:'||'</td>'||
        '    <td align="left">'||lc_producto||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Estado Anterior:'||'</td>'||
        '    <td align="left">'||lc_desant||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Estado Actual:'||'</td>'||
        '    <td align="left">'||lc_desact||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
                        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Sucursal Desbloqueo:'||'</td>'||
        '    <td align="left">'||trim(lc_sucursal)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
            
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Desbloqueado por:'||'</td>'||
        '    <td align="left">'||trim(pc_codusu)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
                
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Fecha-Hora Desbloqueo:'||'</td>'||
        '    <td align="left">'||to_char(ld_fecpro,'dd/mm/rrrr')||' '||lc_hora||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        lv_mensaje := 
        '</table>'||
        '<br/>'||
        '<br/>'||         
        '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>';           
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
         
          begin
                sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html
                                         pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                         pc_motivo => 'DESBLOQUEO DE CUENTA PERSONA JURÍDICA',
                                         pc_mensaje => ll_mensaje
                                         );   
          Exception
          when others then                             
            null;
          end;       

        dbms_lob.freetemporary(ll_mensaje);    
        
        --registramos historico de cambio de estado
        begin
          insert into JAQZ153C(jaqz153cfec,
                               jaqz153chor,
                               jaqz153cusr,
                               jaqz153cpai,
                               jaqz153ctdo,
                               jaqz153cndo,
                               jaqz153cmdo,
                               jaqz153cax1,
                               jaqz153ccue,
                               jaqz153ctpo,
                               jaqz153cage,
                               jaqz153cfac,
                               jaqz153cfcc,
                               jaqz153cfde,
                               jaqz153cfha,
                               jaqz153cpgc,
                               jaqz153cmod,
                               jaqz153csuc,
                               jaqz153cmda,
                               jaqz153cpap,
                               jaqz153ccta,
                               jaqz153cope,
                               jaqz153csub,
                               jaqz153ctop,
                               jaqz153cax3,
                               jaqz153cax4           
                              ) 
                        values(ld_fecpro,
                               lc_hora,
                               pc_codusu,
                               ln_pais,
                               ln_tipo,
                               lv_numdoc,
                               'U',--UNBLOCK
                               1,
                               pn_codcta,
                               'A', 
                               ln_sucdes,
                               0,
                               0,
                               null,
                               null,
                               pn_codpgc,
                               pn_codmod,
                               pn_codsuc,
                               pn_codmda,
                               pn_codpap,
                               pn_codcta,
                               pn_codope,
                               pn_codsub,
                               pn_codtpo,
                               pn_estant,
                               ln_estact
                              );
        exception                      
        when others then
          null;          
        end;
    end if;  
  End sp_ah_mail_actcta_PJ;                                                    
  Procedure sp_valida_dup_grupo(PN_PGCOD  IN NUMBER,
                                PN_PAIS   IN NUMBER, 
                                PN_TIPO   IN NUMBER,
                                PN_NUMERO IN VARCHAR2, 
                                PN_CTNRO  IN NUMBER,
                                PN_FACCOD IN NUMBER,  
                                PN_FACCOR IN NUMBER,  
                                PD_FECINI IN DATE,        
                                PD_FECFIN IN DATE,
                                PC_TIPFAC IN VARCHAR2,
                                pc_exist  out varchar2   
                               ) is
  lc_exist varchar2(1) := 'N';  
  ld_fecha  date;
  ld_fecfin date;
  begin
    ld_fecha := to_date('01/01/0001','dd/mm/rrrr');
    if PD_FECFIN = ld_fecha then
       ld_fecfin := null; 
    else
       ld_fecfin := PD_FECFIN;   
    end if; 
    
    if PC_TIPFAC = 'A' then
      begin    
        select 'S'
          into lc_exist
          from (select a.pgcod,
                       a.ctnro,
                       a.faccod,
                       a.ctfaccor,
                       a.ctfecdes,
                       nvl(
                            (select b.f131fehs
                               from fse131 b
                              where b.f131pg = a.pgcod
                                and b.f131cta = a.ctnro
                                and b.f131fac = a.faccod
                                and b.f131cor = a.ctfaccor
                                and b.f131feds = a.ctfecdes
                             ),
                             nvl(ld_fecfin/*PD_FECFIN*/, PD_FECINI)
                          ) f131feds
                  from fse130 a
                ) x
         where x.pgcod  = PN_PGCOD
           and x.ctnro  = PN_CTNRO
           and x.faccod = PN_FACCOD
           and x.ctfaccor <> (case
                               when PN_FACCOR = 0 then
                                 x.ctfaccor
                               Else
                                 PN_FACCOR
	                             end      
                             )
           and (
                (PD_FECINI between x.ctfecdes and x.f131feds)
                 OR 
                (nvl(ld_fecfin/*PD_FECFIN*/, PD_FECINI) between x.ctfecdes and x.f131feds)
               )
           and rownum < 2;  
            
      pc_exist := lc_exist;   
      exception
      when others then
       lc_exist := 'N';    
       pc_exist := lc_exist;  
      End;
    Else
      begin    
        select 'S'
          into lc_exist
          from (select a.jaql499pgc,
                       a.jaql499pai,
                       a.jaql499tpo,
                       a.jaql499num,
                       a.jaql499fco,
                       a.jaql499fcc,
                       a.jaql499vid,
                       nvl(a.jaql499vih,nvl(ld_fecfin/*PD_FECFIN*/, PD_FECINI)) jaql499vih
                  from jaql499 a
                ) x
         where x.jaql499pgc  = PN_PGCOD
           and x.jaql499pai  = PN_PAIS
           and x.jaql499tpo  = PN_TIPO
           and x.jaql499num  = rpad(PN_NUMERO,12,' ')
           and x.jaql499fco  = PN_FACCOD
           and x.jaql499fcc <> (case
                                when PN_FACCOR = 0 then
                                  x.jaql499fcc
                                Else
                                  PN_FACCOR
	                              end      
                               )           
           and (
                (PD_FECINI between x.jaql499vid and x.jaql499vih)
                 OR 
                (nvl(ld_fecfin/*PD_FECFIN*/, PD_FECINI) between x.jaql499vid and x.jaql499vih)
               )
           and rownum < 2;  
            
      pc_exist := lc_exist;   
      exception
      when others then
       lc_exist := 'N';    
       pc_exist := lc_exist;  
      End;      
    End if;  
  exception
  when others then
   lc_exist := 'N';    
   pc_exist := lc_exist;  
  
  End sp_valida_dup_grupo;  
  /*
  Procedure sp_procesa_fac(P_C_CODMOD IN VARCHAR2,
                           P_N_CODPAI IN NUMBER,
                           P_N_CODTPO IN NUMBER,
                           P_C_CODNUM IN VARCHAR2,
                           P_N_CODPA2 IN NUMBER,
                           P_N_CODTP2 IN NUMBER,
                           P_C_CODNU2 IN VARCHAR2,
                           P_N_CODFAC IN NUMBER,
                           P_D_CODVID IN DATE,
                           P_D_CODVIH IN DATE,
                           P_N_CODLIS IN NUMBER,
                           P_N_CODLID IN NUMBER,
                           P_C_CODTFA IN VARCHAR2,
                           p_n_coderr out number,
                           p_c_deserr out varchar2
                          ) is                        
  begin
    p_n_coderr := 0;
    p_c_deserr := null;
  	case
      When P_C_CODMOD = 'INS' then    
        begin
          insert into JAQZ157(JAQZ157PAI,
                              JAQZ157TPO,
                              JAQZ157NUM,
                              JAQZ157PA2,
                              JAQZ157TP2,
                              JAQZ157NU2,
                              JAQZ157FAC,
                              JAQZ157FDE,
                              JAQZ157FHA,
                              JAQZ157LIS,
                              JAQZ157LID,
                              JAQZ157TFA
                              ) 
                       values(P_N_CODPAI, 
                              P_N_CODTPO, 
                              P_C_CODNUM, 
                              P_N_CODPA2, 
                              P_N_CODTP2, 
                              P_C_CODNU2, 
                              P_N_CODFAC, 
                              P_D_CODVID, 
                              P_D_CODVIH, 
                              P_N_CODLIS, 
                              P_N_CODLID, 
                              P_C_CODTFA 
                              );
        exception
        when dup_val_on_index then    
            p_n_coderr := sqlcode;
            p_c_deserr := 'Facultad ya existe para Persona Asociada';          
            return;
        when others then  
            p_n_coderr := sqlcode;
            p_c_deserr := sqlerrm;
            return;
        end;
      When P_C_CODMOD = 'MOD' then   
        begin  
               update JAQZ157
                  set JAQZ157FHA = P_D_CODVIH,
                      JAQZ157LIS = P_N_CODLIS,
                      JAQZ157LID = P_N_CODLID                
                where JAQZ157PAI = P_N_CODPAI
                  and JAQZ157TPO = P_N_CODTPO
                  and JAQZ157NUM = RPAD(P_C_CODNUM,12,' ')
                  and JAQZ157PA2 = P_N_CODPA2
                  and JAQZ157TP2 = P_N_CODTP2
                  and JAQZ157NU2 = RPAD(P_C_CODNU2,12,' ')
                  and JAQZ157FAC = P_N_CODFAC
                  and JAQZ157FDE = P_D_CODVID;                                                                    
                  
                if SQL%NOTFOUND then                  
                  p_n_coderr := 100;
                  p_c_deserr := 'No se encontró registro a actualizar';
                  return;                        
                End If;          
        exception                  
        when others then
            p_n_coderr := sqlcode;
            p_c_deserr := sqlerrm;
            return;            
        end;
   
      When P_C_CODMOD = 'DEL' then     
        begin  
               delete 
                 from JAQZ157
                where JAQZ157PAI = P_N_CODPAI
                  and JAQZ157TPO = P_N_CODTPO
                  and JAQZ157NUM = RPAD(P_C_CODNUM,12,' ')
                  and JAQZ157PA2 = P_N_CODPA2
                  and JAQZ157TP2 = P_N_CODTP2
                  and JAQZ157NU2 = RPAD(P_C_CODNU2,12,' ')
                  and JAQZ157FAC = P_N_CODFAC
                  and JAQZ157FDE = P_D_CODVID;                                                                    
                  
                if SQL%NOTFOUND then                  
                  p_n_coderr := 100;
                  p_c_deserr := 'No se encontró registro a eliminar';
                  return;                        
                End If;          
        exception                  
        when others then
            p_n_coderr := sqlcode;
            p_c_deserr := sqlerrm;
            return;            
        end;
      Else
        null;
      End Case;   
      commit;                           
  end sp_procesa_fac;
  */
Procedure sp_genera_grupos(pc_usuari in varchar2,
                             pd_fecpro in date,          
                             pc_tipreg in varchar2,
                             pc_indall in varchar2,
                             pn_paijur in number, 
                             pn_tipjur in number, 
                             pc_numjur in varchar2, 
                             pn_numcta in number,
                             pc_codmas in varchar2,
                             pc_tipgru in varchar2, 
                             pn_codfac in number,
                             pc_indind in varchar2,
                             pd_fecini in date,
                             pd_fecfin in date,
                             pn_totsol in number,
                             pn_totdol in number,                            
                             pn_painat in number, 
                             pn_tipnat in number, 
                             pc_numnat in varchar2,                              
                             p_n_pgcod in number, 
                             p_n_scmod in number, 
                             p_n_scsuc in number, 
                             p_n_scmda in number, 
                             p_n_scpap in number, 
                             p_n_sccta in number, 
                             pn_scoper in number, 
                             pn_scsbop in number, 
                             pn_sctope in number, 
                             pc_coderr out varchar2,                              
                             pc_msgerr out varchar2                             
                            ) is    
    cursor c_facultades  is
      select * 
       from jaqz156a a
      where a.jaqz156ausr = RPAD(pc_usuari,10,' ');
      
    cursor c_integración is
      select * 
       from jaqz156b a
      where a.jaqz156busr = RPAD(pc_usuari,10,' ');
    
    cursor c_productos   is
      select * 
       from jaqz156c a
      where a.jaqz156cusr = RPAD(pc_usuari,10,' ');
      
    cursor c_fsd011 is
    select a.* 
      from fsd011 a 
     where a.pgcod = 1 
       and a.scmod in (21,22) 
       and a.scstat <> 99 
       and a.sccta = pn_numcta;
       
  ln_codgru  number(3):=0; 
  ln_codsuc  number(3):=0;    
  ln_cont    number(9):=0;   
  ln_cont1   number(9):=0;   
  ln_cont2   number(9):=0;   
                            
  begin
    pc_coderr := null; 
    pc_msgerr := null;
    
    begin
      select a.ubsuc 
        into ln_codsuc 
        from fst046 a 
       where a.pgcod  = 1 
         and a.ubuser = rpad(pc_usuari,10,' ');
    exception
    when others then  
      ln_codsuc := 0;
    end;
      
    Case
      When pc_tipreg = 'C' then
        --generar correlativo de tabla
        begin
          delete from jaqz156 a  where a.jaqz156usr  = rpad(pc_usuari,10,' ');
          delete from jaqz156a a where a.jaqz156ausr = rpad(pc_usuari,10,' ');
          delete from jaqz156b a where a.jaqz156busr = rpad(pc_usuari,10,' ');
          delete from jaqz156c a where a.jaqz156cusr = rpad(pc_usuari,10,' ');
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '1 - '||sqlerrm;
          return;
        end;     
        begin
          insert into jaqz156(jaqz156usr,
                              jaqz156pai,
                              jaqz156tpo,
                              jaqz156num,
                              jaqz156cta,
                              jaqz156mas,
                              jaqz156gru,
                              jaqz156ind,                              
                              jaqz156fin,                              
                              jaqz156ffi,                              
                              jaqz156lso,                              
                              jaqz156ldo                                                            
                              ) 
                        values(pc_usuari,
                               pn_paijur,
                               pn_tipjur,
                               pc_numjur,
                               pn_numcta,
                               pc_codmas,
                               pc_tipgru,
                               pc_indind,
                               pd_fecini,
                               pd_fecfin,
                               pn_totsol,
                               pn_totdol                                                             
                              );
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '2 - '||sqlerrm;
          return;
        end;                       
      When pc_tipreg = 'F' then
        begin
          insert into jaqz156a(jaqz156ausr,   
                               jaqz156afac   
                              ) 
                        values(pc_usuari,
                               pn_codfac
                              );
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '3 - '||sqlerrm;
          return;
        end;                      
      When pc_tipreg = 'I' then    
        begin
          insert into jaqz156b(jaqz156busr,   
                               jaqz156bpai, 
                               jaqz156btpo, 
                               jaqz156bnum,
                               jaqz156btip
                              ) 
                        values(pc_usuari,
                               pn_painat,
                               pn_tipnat,
                               pc_numnat,
                               1                               
                              );
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '4 - '||sqlerrm;
          return;
        end;                              
      When pc_tipreg = 'P' then   
         begin
          insert into jaqz156c(jaqz156cusr,
                               jaqz156cpgc,
                               jaqz156cmod,
                               jaqz156csuc,
                               jaqz156cmda,
                               jaqz156cpap,
                               jaqz156ccta,
                               jaqz156cope,
                               jaqz156csbo,
                               jaqz156ctpo                               
                              ) 
                        values(pc_usuari,
                               p_n_pgcod,
                               p_n_scmod,
                               p_n_scsuc,
                               p_n_scmda,
                               p_n_scpap,
                               p_n_sccta,
                               pn_scoper,
                               pn_scsbop,
                               pn_sctope
                              );
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '5 - '||sqlerrm;
          return;
        end;              
      Else
        -- procesamos
        if pc_codmas = 'A' then
          For i in c_facultades loop
             --genera codigo de grupo
            ln_cont := ln_cont + 1; 
            Case 
              When pc_tipgru = 'M' then
                 ln_codgru := 511;
              When pc_tipgru in ('I','C') then   
                  begin
                    select nvl(max(x.ctfaccor),500) 
                      into ln_codgru
                      from fse130 x 
                     where x.pgcod    = 1 
                       and x.ctnro    = pn_numcta 
                       and x.faccod   = i.jaqz156afac 
                       and x.ctfaccor <> 511;
                       --and x.ctfecdes = pd_fecini;
                  exception
                  when others then  
                    pc_coderr := sqlcode;
                    pc_msgerr := '6 - '||sqlerrm;   
                    return;               
                  end;                              
                  ln_codgru := ln_codgru + 1;   
                  
                  if ln_codgru = 511 then 
                     ln_codgru := ln_codgru + 1;   
                  End if;
              Else                
                  begin
                    select nvl(max(x.ctfaccor),0) 
                      into ln_codgru
                      from fse130 x 
                     where x.pgcod    = 1 
                       and x.ctnro    = pn_numcta 
                       and x.faccod   = i.jaqz156afac 
                       and x.ctfaccor < 500
                       and x.ctfecdes = pd_fecini;
                  exception
                  when others then  
                    pc_coderr := sqlcode;
                    pc_msgerr := '7 - '||sqlerrm;   
                    return;               
                  end;                              
                  ln_codgru := ln_codgru + 1;                     
            End Case;    
            
            if pc_tipgru <> 'I' then         
                --registramos el grupo
                begin
                  insert into fse130(pgcod,
                                     ctnro,
                                     faccod,
                                     ctfaccor,
                                     ctfecdes,
                                     ctfaclim,
                                     ctfacvig,
                                     ctfaclimmn
                                     ) 
                              values(1,
                                     pn_numcta,
                                     i.jaqz156afac,
                                     ln_codgru,
                                     pd_fecini,                                 
                                     pn_totdol,
                                     'S',                                  
                                     pn_totsol                                 
                                     );
                exception
                when others then  
                     pc_coderr := sqlcode;
                     pc_msgerr := '8 - '||sqlerrm;    
                     return;                            
                end;            
                
                If pc_indind = 'N' then              
                    begin
                      insert into fse131(f131pg,  
                                         f131cta, 
                                         f131fac, 
                                         f131cor, 
                                         f131feds,
                                         f131fehs
                                         ) 
                                  values(1,
                                         pn_numcta,
                                         i.jaqz156afac,
                                         ln_codgru,
                                         pd_fecini,     
                                         pd_fecfin
                                         );
                    exception
                    when others then  
                         pc_coderr := sqlcode;
                         pc_msgerr := '9 - '||sqlerrm; 
                         return;                               
                    end;            
                end if;                        
                   
                --registramos histórico
                begin
                  insert into jaqz153a(jaqz153afec,
                                       jaqz153ahor,
                                       jaqz153ausr,
                                       jaqz153apai,
                                       jaqz153atdo,
                                       jaqz153ando,
                                       jaqz153acta,
                                       jaqz153atpo,
                                       jaqz153asuc,
                                       jaqz153amod,
                                       jaqz153afac,
                                       jaqz153afcc,
                                       jaqz153afde,
                                       jaqz153afha,
                                       jaqz153alis,
                                       jaqz153alid,
                                       jaqz153afd1,
                                       jaqz153ali1,
                                       jaqz153ali2,
                                       jaqz153aax1
                                      ) 
                               values(pd_fecpro,
                                      to_char(sysdate,'HH24:mi:ss'),
                                      pc_usuari,
                                      pn_paijur, 
                                      pn_tipjur, 
                                      pc_numjur, 
                                      pn_numcta,
                                      pc_codmas, 
                                      ln_codsuc,  
                                      'I',                                
                                      i.jaqz156afac,
                                      ln_codgru,
                                      pd_fecini,
                                      pd_fecfin,                                 
                                      pn_totsol,                                 
                                      pn_totdol,
                                      null,
                                      0,
                                      0,
                                      ln_cont                                 
                                     );
                exception
                when others then  
                     pc_coderr := sqlcode;
                     pc_msgerr := ln_cont||' - 10 - '||sqlerrm;    
                     return;                            
                end;
            end if;                                                   
            For j in c_integración loop    
              ln_cont1 := ln_cont1 + 1;                  
              
              if pc_tipgru = 'I' then   
                 ln_cont  := ln_cont + 1;
                  --registramos el grupo
                  begin
                    insert into fse130(pgcod,
                                       ctnro,
                                       faccod,
                                       ctfaccor,
                                       ctfecdes,
                                       ctfaclim,
                                       ctfacvig,
                                       ctfaclimmn
                                       ) 
                                values(1,
                                       pn_numcta,
                                       i.jaqz156afac,
                                       ln_codgru,
                                       pd_fecini,                                 
                                       pn_totdol,
                                       'S',                                  
                                       pn_totsol                                 
                                       );
                  exception
                  when others then  
                       pc_coderr := sqlcode;
                       pc_msgerr := '11 - '||sqlerrm;    
                       return;                            
                  end;            
                  
                  If pc_indind = 'N' then              
                      begin
                        insert into fse131(f131pg,  
                                           f131cta, 
                                           f131fac, 
                                           f131cor, 
                                           f131feds,
                                           f131fehs
                                           ) 
                                    values(1,
                                           pn_numcta,
                                           i.jaqz156afac,
                                           ln_codgru,
                                           pd_fecini,     
                                           pd_fecfin
                                           );
                      exception
                      when others then  
                           pc_coderr := sqlcode;
                           pc_msgerr := '12 - '||sqlerrm; 
                           return;                               
                      end;            
                  end if;                        
                     
                  --registramos histórico
                  begin
                    insert into jaqz153a(jaqz153afec,
                                         jaqz153ahor,
                                         jaqz153ausr,
                                         jaqz153apai,
                                         jaqz153atdo,
                                         jaqz153ando,
                                         jaqz153acta,
                                         jaqz153atpo,
                                         jaqz153asuc,
                                         jaqz153amod,
                                         jaqz153afac,
                                         jaqz153afcc,
                                         jaqz153afde,
                                         jaqz153afha,
                                         jaqz153alis,
                                         jaqz153alid,
                                         jaqz153afd1,
                                         jaqz153ali1,
                                         jaqz153ali2,
                                         jaqz153aax1
                                        ) 
                                 values(pd_fecpro,
                                        to_char(sysdate,'HH24:mi:ss'),
                                        pc_usuari,
                                        pn_paijur, 
                                        pn_tipjur, 
                                        pc_numjur, 
                                        pn_numcta,
                                        pc_codmas, 
                                        ln_codsuc,  
                                        'I',                                
                                        i.jaqz156afac,
                                        ln_codgru,
                                        pd_fecini,
                                        pd_fecfin,                                 
                                        pn_totsol,                                 
                                        pn_totdol,
                                        null,
                                        0,
                                        0,
                                        ln_cont                                 
                                       );
                  exception
                  when others then  
                       pc_coderr := sqlcode;
                       pc_msgerr := '13 - '||sqlerrm;    
                       return;                            
                  end; 
              end if;                               
              -----
                   
              begin
                insert into fsr130 (pgcod,
                                    ctnro,
                                    faccod,
                                    ctfaccor,
                                    ctfecdes,
                                    pfpai2,
                                    pftdo2,
                                    pfndo2
                                    )
                             values(1,
                                    pn_numcta,
                                    i.jaqz156afac,
                                    ln_codgru,
                                    pd_fecini,
                                    j.jaqz156bpai,                             
                                    j.jaqz156btpo,                             
                                    j.jaqz156bnum                                                          
                                    );
                                   
              exception
              when others then  
                  pc_coderr := sqlcode;
                  pc_msgerr := '14 - '||sqlerrm;  
                  return;                    
              end;
              
              --registramos historico
              if pc_tipgru = 'I' then
                 ln_cont1 := ln_cont1 + 1;
              End If;   
              
              begin
                insert into jaqz153b(jaqz153bfec,
                                     jaqz153bhor,
                                     jaqz153busr,
                                     jaqz153bpai,
                                     jaqz153btdo,
                                     jaqz153bndo,
                                     jaqz153bcta,
                                     jaqz153btpo,
                                     jaqz153bsuc,
                                     jaqz153bmod,
                                     jaqz153bfac,
                                     jaqz153bfcc,
                                     jaqz153bfde,
                                     jaqz153bfha,
                                     jaqz153bpa2,
                                     jaqz153btp2,
                                     jaqz153bno2,
                                     jaqz153bax1                            
                                    ) 
                             values(pd_fecpro,
                                    to_char(sysdate,'HH24:mi:ss'),
                                    pc_usuari,
                                    pn_paijur, 
                                    pn_tipjur, 
                                    pc_numjur, 
                                    pn_numcta,
                                    pc_codmas, 
                                    ln_codsuc,  
                                    'I',     
                                    i.jaqz156afac,                        
                                    ln_codgru,
                                    pd_fecini,
                                    pd_fecfin,
                                    j.jaqz156bpai, 
                                    j.jaqz156btpo, 
                                    j.jaqz156bnum,
                                    ln_cont1  
                                    );
              exception                     
              when others then  
                  pc_coderr := sqlcode;
                  pc_msgerr := '15 - '||sqlerrm;  
                  return;                  
              end;                                  
              --ingresamos los productos cuando es indistinto x cada grupo
              if pc_tipgru = 'I' then
                      if pc_indall = 'S' then                        
                        For k in c_fsd011 loop
                          ln_cont2 := ln_cont2 + 1;
                          begin
                            insert into fsr011(R1cod,  
                                               R1mod,  
                                               R1suc,  
                                               R1mda,  
                                               R1pap, 
                                               R1cta,  
                                               R1oper, 
                                               R1sbop, 
                                               R1tope, 
                                               Relcod, 
                                               R2mod, 
                                               R2cta,  
                                               R2oper, 
                                               R2sbop, 
                                               R2cod,  
                                               R011fc, 
                                               R011co
                                               ) 
                                         values(k.pgcod,
                                                k.scmod,
                                                k.scsuc,
                                                k.scmda,
                                                k.scpap,
                                                k.sccta,
                                                k.scoper,
                                                k.scsbop,
                                                k.sctope,
                                                5,                                        
                                                i.jaqz156afac,
                                                k.sccta,
                                                to_number(to_char(pd_fecini,'rrrrmmdd')),
                                                ln_codgru,
                                                k.pgcod,
                                                pd_fecpro,
                                                'S'                                                     
                                               );
                          exception
                          when others then  
                            pc_coderr := sqlcode;
                            pc_msgerr := '16 - '||sqlerrm;  
                            return;                
                          end;    
                          
                          -- registramos historico
                          begin
                             insert into jaqz153c(jaqz153cfec,
                                                  jaqz153chor,
                                                  jaqz153cusr,
                                                  jaqz153cpai,
                                                  jaqz153ctdo,
                                                  jaqz153cndo,
                                                  jaqz153ccue,
                                                  jaqz153ctpo,
                                                  jaqz153cage,
                                                  jaqz153cmdo,
                                                  jaqz153cfac,
                                                  jaqz153cfcc,
                                                  jaqz153cfde,
                                                  jaqz153cfha,
                                                  jaqz153cpgc,
                                                  jaqz153cmod,
                                                  jaqz153csuc,
                                                  jaqz153cmda,
                                                  jaqz153cpap,
                                                  jaqz153ccta,
                                                  jaqz153cope,
                                                  jaqz153csub,
                                                  jaqz153ctop,
                                                  jaqz153cax1                                    
                                                 ) 
                                           values(pd_fecpro,
                                                  to_char(sysdate,'HH24:mi:ss'),
                                                  pc_usuari,
                                                  pn_paijur, 
                                                  pn_tipjur, 
                                                  pc_numjur, 
                                                  pn_numcta,
                                                  pc_codmas, 
                                                  ln_codsuc,  
                                                  'I',                              
                                                  i.jaqz156afac,
                                                  ln_codgru,
                                                  pd_fecini,
                                                  pd_fecfin,
                                                  k.pgcod,
                                                  k.scmod,
                                                  k.scsuc,
                                                  k.scmda,
                                                  k.scpap,
                                                  k.sccta,
                                                  k.scoper,
                                                  k.scsbop,
                                                  k.sctope,
                                                  ln_cont2
                                                 );
                          exception
                          when others then
                            pc_coderr := sqlcode;
                            pc_msgerr := '17 - '||sqlerrm;  
                            return;                   
                          end;
                          
                        End Loop;                           
                      Else  
                        For k in c_productos loop
                          ln_cont2 := ln_cont2 + 1;
                          begin
                              insert into fsr011(R1cod,  
                                                 R1mod,  
                                                 R1suc,  
                                                 R1mda,  
                                                 R1pap, 
                                                 R1cta,  
                                                 R1oper, 
                                                 R1sbop, 
                                                 R1tope, 
                                                 Relcod, 
                                                 R2mod, 
                                                 R2cta,  
                                                 R2oper, 
                                                 R2sbop, 
                                                 R2cod,  
                                                 R011fc, 
                                                 R011co
                                                 ) 
                                           values(k.jaqz156cpgc,                                          
                                                  k.jaqz156cmod,                                          
                                                  k.jaqz156csuc,                                          
                                                  k.jaqz156cmda,                                          
                                                  k.jaqz156cpap,                                                                                                                              
                                                  k.jaqz156ccta,                                          
                                                  k.jaqz156cope,                                          
                                                  k.jaqz156csbo,                                          
                                                  k.jaqz156ctpo,                                          
                                                  5,
                                                  i.jaqz156afac,
                                                  k.jaqz156ccta,
                                                  to_number(to_char(pd_fecini,'rrrrmmdd')),
                                                  ln_codgru,
                                                  k.jaqz156cpgc,
                                                  pd_fecpro,
                                                  'S'                                                     
                                                 );
                            exception
                            when others then  
                              pc_coderr := sqlcode;
                              pc_msgerr := '18 - '||sqlerrm;   
                              return;               
                            end;  
                            
                          -- registramos historico
                          begin
                             insert into jaqz153c(jaqz153cfec,
                                                  jaqz153chor,
                                                  jaqz153cusr,
                                                  jaqz153cpai,
                                                  jaqz153ctdo,
                                                  jaqz153cndo,
                                                  jaqz153ccue,
                                                  jaqz153ctpo,
                                                  jaqz153cage,
                                                  jaqz153cmdo,
                                                  jaqz153cfac,
                                                  jaqz153cfcc,
                                                  jaqz153cfde,
                                                  jaqz153cfha,
                                                  jaqz153cpgc,
                                                  jaqz153cmod,
                                                  jaqz153csuc,
                                                  jaqz153cmda,
                                                  jaqz153cpap,
                                                  jaqz153ccta,
                                                  jaqz153cope,
                                                  jaqz153csub,
                                                  jaqz153ctop,
                                                  jaqz153cax1                                    
                                                 ) 
                                           values(pd_fecpro,
                                                  to_char(sysdate,'HH24:mi:ss'),
                                                  pc_usuari,
                                                  pn_paijur, 
                                                  pn_tipjur, 
                                                  pc_numjur, 
                                                  pn_numcta,
                                                  pc_codmas, 
                                                  ln_codsuc,  
                                                  'I',                              
                                                  i.jaqz156afac,
                                                  ln_codgru,
                                                  pd_fecini,
                                                  pd_fecfin,
                                                  k.jaqz156cpgc, 
                                                  k.jaqz156cmod, 
                                                  k.jaqz156csuc, 
                                                  k.jaqz156cmda, 
                                                  k.jaqz156cpap, 
                                                  k.jaqz156ccta, 
                                                  k.jaqz156cope, 
                                                  k.jaqz156csbo, 
                                                  k.jaqz156ctpo, 
                                                  ln_cont2
                                                 );
                          exception
                          when others then
                            pc_coderr := sqlcode;
                            pc_msgerr := '19 - '||sqlerrm;  
                            return;                   
                          end;                                           
                        End Loop;            
                      End If;                
              end If;
              --fin--
              if pc_tipgru = 'I' then
                ln_codgru := ln_codgru + 1;   
                if ln_codgru = 511 then 
                   ln_codgru := ln_codgru + 1;   
                End if;
              End If;              
            End Loop;  
            
            if pc_indall = 'S' and pc_tipgru <> 'I'  then
              For k in c_fsd011 loop
                ln_cont2 := ln_cont2 + 1;
                begin
                  insert into fsr011(R1cod,  
                                     R1mod,  
                                     R1suc,  
                                     R1mda,  
                                     R1pap, 
                                     R1cta,  
                                     R1oper, 
                                     R1sbop, 
                                     R1tope, 
                                     Relcod, 
                                     R2mod, 
                                     R2cta,  
                                     R2oper, 
                                     R2sbop, 
                                     R2cod,  
                                     R011fc, 
                                     R011co
                                     ) 
                               values(k.pgcod,
                                      k.scmod,
                                      k.scsuc,
                                      k.scmda,
                                      k.scpap,
                                      k.sccta,
                                      k.scoper,
                                      k.scsbop,
                                      k.sctope,
                                      5,                                        
                                      i.jaqz156afac,
                                      k.sccta,
                                      to_number(to_char(pd_fecini,'rrrrmmdd')),
                                      ln_codgru,
                                      k.pgcod,
                                      pd_fecpro,
                                      'S'                                                     
                                     );
                exception
                when others then  
                  pc_coderr := sqlcode;
                  pc_msgerr := '20 - '||sqlerrm;  
                  return;                
                end;    
                
                -- registramos historico
                begin
                   insert into jaqz153c(jaqz153cfec,
                                        jaqz153chor,
                                        jaqz153cusr,
                                        jaqz153cpai,
                                        jaqz153ctdo,
                                        jaqz153cndo,
                                        jaqz153ccue,
                                        jaqz153ctpo,
                                        jaqz153cage,
                                        jaqz153cmdo,
                                        jaqz153cfac,
                                        jaqz153cfcc,
                                        jaqz153cfde,
                                        jaqz153cfha,
                                        jaqz153cpgc,
                                        jaqz153cmod,
                                        jaqz153csuc,
                                        jaqz153cmda,
                                        jaqz153cpap,
                                        jaqz153ccta,
                                        jaqz153cope,
                                        jaqz153csub,
                                        jaqz153ctop,
                                        jaqz153cax1                                    
                                       ) 
                                 values(pd_fecpro,
                                        to_char(sysdate,'HH24:mi:ss'),
                                        pc_usuari,
                                        pn_paijur, 
                                        pn_tipjur, 
                                        pc_numjur, 
                                        pn_numcta,
                                        pc_codmas, 
                                        ln_codsuc,  
                                        'I',                              
                                        i.jaqz156afac,
                                        ln_codgru,
                                        pd_fecini,
                                        pd_fecfin,
                                        k.pgcod,
                                        k.scmod,
                                        k.scsuc,
                                        k.scmda,
                                        k.scpap,
                                        k.sccta,
                                        k.scoper,
                                        k.scsbop,
                                        k.sctope,
                                        ln_cont2
                                       );
                exception
                when others then
                  pc_coderr := sqlcode;
                  pc_msgerr := '21 - '||sqlerrm;  
                  return;                   
                end;
                
              End Loop;                           
            End If;  
            If pc_indall <> 'S' and pc_tipgru <> 'I' then
              For k in c_productos loop
                ln_cont2 := ln_cont2 + 1;
                begin
                    insert into fsr011(R1cod,  
                                       R1mod,  
                                       R1suc,  
                                       R1mda,  
                                       R1pap, 
                                       R1cta,  
                                       R1oper, 
                                       R1sbop, 
                                       R1tope, 
                                       Relcod, 
                                       R2mod, 
                                       R2cta,  
                                       R2oper, 
                                       R2sbop, 
                                       R2cod,  
                                       R011fc, 
                                       R011co
                                       ) 
                                 values(k.jaqz156cpgc,                                          
                                        k.jaqz156cmod,                                          
                                        k.jaqz156csuc,                                          
                                        k.jaqz156cmda,                                          
                                        k.jaqz156cpap,                                                                                                                              
                                        k.jaqz156ccta,                                          
                                        k.jaqz156cope,                                          
                                        k.jaqz156csbo,                                          
                                        k.jaqz156ctpo,                                          
                                        5,
                                        i.jaqz156afac,
                                        k.jaqz156ccta,
                                        to_number(to_char(pd_fecini,'rrrrmmdd')),
                                        ln_codgru,
                                        k.jaqz156cpgc,
                                        pd_fecpro,
                                        'S'                                                     
                                       );
                  exception
                  when others then  
                    pc_coderr := sqlcode;
                    pc_msgerr := '22 - '||sqlerrm;   
                    return;               
                  end;  
                  
                -- registramos historico
                begin
                   insert into jaqz153c(jaqz153cfec,
                                        jaqz153chor,
                                        jaqz153cusr,
                                        jaqz153cpai,
                                        jaqz153ctdo,
                                        jaqz153cndo,
                                        jaqz153ccue,
                                        jaqz153ctpo,
                                        jaqz153cage,
                                        jaqz153cmdo,
                                        jaqz153cfac,
                                        jaqz153cfcc,
                                        jaqz153cfde,
                                        jaqz153cfha,
                                        jaqz153cpgc,
                                        jaqz153cmod,
                                        jaqz153csuc,
                                        jaqz153cmda,
                                        jaqz153cpap,
                                        jaqz153ccta,
                                        jaqz153cope,
                                        jaqz153csub,
                                        jaqz153ctop,
                                        jaqz153cax1                                    
                                       ) 
                                 values(pd_fecpro,
                                        to_char(sysdate,'HH24:mi:ss'),
                                        pc_usuari,
                                        pn_paijur, 
                                        pn_tipjur, 
                                        pc_numjur, 
                                        pn_numcta,
                                        pc_codmas, 
                                        ln_codsuc,  
                                        'I',                              
                                        i.jaqz156afac,
                                        ln_codgru,
                                        pd_fecini,
                                        pd_fecfin,
                                        k.jaqz156cpgc, 
                                        k.jaqz156cmod, 
                                        k.jaqz156csuc, 
                                        k.jaqz156cmda, 
                                        k.jaqz156cpap, 
                                        k.jaqz156ccta, 
                                        k.jaqz156cope, 
                                        k.jaqz156csbo, 
                                        k.jaqz156ctpo, 
                                        ln_cont2
                                       );
                exception
                when others then
                  pc_coderr := sqlcode;
                  pc_msgerr := '23 - '||sqlerrm;  
                  return;                   
                end;                                           
              End Loop;            
            End If;
          End loop;
          
        Else --PARA CREDITOS
          For i in c_facultades loop
             --genera codigo de grupo
             ln_cont := ln_cont + 1;
            if pc_tipgru = 'M' then
               ln_codgru := 511;
            else
                begin
                  select nvl(max(x.JAQL499FCC),500) 
                    into ln_codgru
                    from JAQL499 x 
                   where JAQL499PGC = 1                     
                     and JAQL499PAI = pn_paijur                   
                     and JAQL499TPO = pn_tipjur                  
                     and JAQL499NUM = pc_numjur                   
                     and JAQL499FCO = i.jaqz156afac                    
                     and JAQL499FCC <> 511                     
                     and JAQL499VID = pd_fecini;                    
                exception
                when others then  
                  pc_coderr := sqlcode;
                  pc_msgerr := '24 - '||sqlerrm;   
                  return;               
                end;                              
                ln_codgru := ln_codgru + 1;   
                
                if ln_codgru = 511 then 
                   ln_codgru := ln_codgru + 1;   
                End if;                
            end if; 
            
            if pc_tipgru <> 'I' then
                --registramos el grupo
                begin
                  insert into JAQL499(JAQL499PGC,                                 
                                      JAQL499PAI,                                 
                                      JAQL499TPO,                                 
                                      JAQL499NUM,                                 
                                      JAQL499FCO,                                 
                                      JAQL499FCC,                                 
                                      JAQL499VID,                                 
                                      JAQL499VIH,                                 
                                      JAQL499LIS,                                 
                                      JAQL499LID,                                 
                                      JAQL499EST,                                 
                                      JAQL499USR,                                 
                                      JAQL499FEI,                                 
                                      JAQL499HOI                                                                  
                                      ) 
                              values(1,
                                     pn_paijur,
                                     pn_tipjur,
                                     pc_numjur,
                                     i.jaqz156afac,
                                     ln_codgru,
                                     pd_fecini, 
                                     pd_fecfin,                                 
                                     pn_totsol,
                                     pn_totdol,
                                     'S',      
                                     pc_usuari,
                                     pd_fecpro,
                                     to_char(sysdate,'HH24:mi:ss')                                                                                              
                                     );
                exception
                when others then  
                     pc_coderr := sqlcode;
                     pc_msgerr := '25 - '||sqlerrm;   
                     return;                             
                end;  
                
                --registramos histórico
                begin
                  insert into jaqz153a(jaqz153afec,
                                       jaqz153ahor,
                                       jaqz153ausr,
                                       jaqz153apai,
                                       jaqz153atdo,
                                       jaqz153ando,
                                       jaqz153acta,
                                       jaqz153atpo,
                                       jaqz153asuc,
                                       jaqz153amod,
                                       jaqz153afac,
                                       jaqz153afcc,
                                       jaqz153afde,
                                       jaqz153afha,
                                       jaqz153alis,
                                       jaqz153alid,
                                       jaqz153afd1,
                                       jaqz153ali1,
                                       jaqz153ali2,
                                       jaqz153aax1
                                      ) 
                               values(pd_fecpro,
                                      to_char(sysdate,'HH24:mi:ss'),
                                      pc_usuari,
                                      pn_paijur, 
                                      pn_tipjur, 
                                      pc_numjur, 
                                      pn_numcta,
                                      pc_codmas, 
                                      ln_codsuc,  
                                      'I',                                
                                      i.jaqz156afac,
                                      ln_codgru,
                                      pd_fecini,
                                      pd_fecfin,                                 
                                      pn_totsol,                                 
                                      pn_totdol,
                                      null,
                                      0,
                                      0,
                                      ln_cont                                 
                                     );
                exception
                when others then  
                     pc_coderr := sqlcode;
                     pc_msgerr := '26 - '||sqlerrm;    
                     return;                            
                end;                                                         
            end if;                                          
            For j in c_integración loop   
              ln_cont1 := ln_cont1 + 1;     
              
              if  pc_tipgru = 'I' then
                --registramos el grupo
                ln_cont  := ln_cont + 1;
                begin
                  insert into JAQL499(JAQL499PGC,                                 
                                      JAQL499PAI,                                 
                                      JAQL499TPO,                                 
                                      JAQL499NUM,                                 
                                      JAQL499FCO,                                 
                                      JAQL499FCC,                                 
                                      JAQL499VID,                                 
                                      JAQL499VIH,                                 
                                      JAQL499LIS,                                 
                                      JAQL499LID,                                 
                                      JAQL499EST,                                 
                                      JAQL499USR,                                 
                                      JAQL499FEI,                                 
                                      JAQL499HOI                                                                  
                                      ) 
                              values(1,
                                     pn_paijur,
                                     pn_tipjur,
                                     pc_numjur,
                                     i.jaqz156afac,
                                     ln_codgru,
                                     pd_fecini, 
                                     pd_fecfin,                                 
                                     pn_totsol,
                                     pn_totdol,
                                     'S',      
                                     pc_usuari,
                                     pd_fecpro,
                                     to_char(sysdate,'HH24:mi:ss')                                                                                              
                                     );
                exception
                when others then  
                     pc_coderr := sqlcode;
                     pc_msgerr := '27 - '||sqlerrm;   
                     return;                             
                end;  
                
                --registramos histórico
                begin
                  insert into jaqz153a(jaqz153afec,
                                       jaqz153ahor,
                                       jaqz153ausr,
                                       jaqz153apai,
                                       jaqz153atdo,
                                       jaqz153ando,
                                       jaqz153acta,
                                       jaqz153atpo,
                                       jaqz153asuc,
                                       jaqz153amod,
                                       jaqz153afac,
                                       jaqz153afcc,
                                       jaqz153afde,
                                       jaqz153afha,
                                       jaqz153alis,
                                       jaqz153alid,
                                       jaqz153afd1,
                                       jaqz153ali1,
                                       jaqz153ali2,
                                       jaqz153aax1
                                      ) 
                               values(pd_fecpro,
                                      to_char(sysdate,'HH24:mi:ss'),
                                      pc_usuari,
                                      pn_paijur, 
                                      pn_tipjur, 
                                      pc_numjur, 
                                      pn_numcta,
                                      pc_codmas, 
                                      ln_codsuc,  
                                      'I',                                
                                      i.jaqz156afac,
                                      ln_codgru,
                                      pd_fecini,
                                      pd_fecfin,                                 
                                      pn_totsol,                                 
                                      pn_totdol,
                                      null,
                                      0,
                                      0,
                                      ln_cont                                 
                                     );
                exception
                when others then  
                     pc_coderr := sqlcode;
                     pc_msgerr := '28 - '||sqlerrm;    
                     return;                            
                end;   
                                                   
              end if;  
                
              begin
                insert into JAQZ151 (JAQZ151PGC, 
                                     JAQZ151PAI, 
                                     JAQZ151TPO,                                    
                                     JAQZ151NUM,                                     
                                     JAQZ151FCO,                                     
                                     JAQZ151FCC,                                     
                                     JAQZ151VID,                                     
                                     JAQZ151VIH,                                     
                                     JAQZ151PA2,                                     
                                     JAQZ151TP2,                                     
                                     JAQZ151NU2,                                     
                                     JAQZ151USR,                                     
                                     JAQZ151FEI,                                     
                                     JAQZ151HOI                                                                         
                                    )
                             values(1,
                                    pn_paijur,                             
                                    pn_tipjur,                             
                                    pc_numjur,                             
                                    i.jaqz156afac,
                                    ln_codgru,
                                    pd_fecini,
                                    pd_fecfin,
                                    j.jaqz156bpai,                             
                                    j.jaqz156btpo,                             
                                    j.jaqz156bnum,                                
                                    pc_usuari,
                                    pd_fecpro,
                                    to_char(sysdate,'HH24:mi:ss')                                                                                              
                                    );
                                   
              exception
              when others then  
                  pc_coderr := sqlcode;
                  pc_msgerr := '29 - '||sqlerrm;    
                  return;                  
              end;
              
              --registramos historico
              begin
                insert into jaqz153b(jaqz153bfec,
                                     jaqz153bhor,
                                     jaqz153busr,
                                     jaqz153bpai,
                                     jaqz153btdo,
                                     jaqz153bndo,
                                     jaqz153bcta,
                                     jaqz153btpo,
                                     jaqz153bsuc,
                                     jaqz153bmod,
                                     jaqz153bfac,
                                     jaqz153bfcc,
                                     jaqz153bfde,
                                     jaqz153bfha,
                                     jaqz153bpa2,
                                     jaqz153btp2,
                                     jaqz153bno2,
                                     jaqz153bax1                            
                                    ) 
                             values(pd_fecpro,
                                    to_char(sysdate,'HH24:mi:ss'),
                                    pc_usuari,
                                    pn_paijur, 
                                    pn_tipjur, 
                                    pc_numjur, 
                                    pn_numcta,
                                    pc_codmas, 
                                    ln_codsuc,  
                                    'I',     
                                    i.jaqz156afac,                        
                                    ln_codgru,
                                    pd_fecini,
                                    pd_fecfin,
                                    j.jaqz156bpai, 
                                    j.jaqz156btpo, 
                                    j.jaqz156bnum,
                                    ln_cont1  
                                    );
              exception                     
              when others then  
                  pc_coderr := sqlcode;
                  pc_msgerr := '30 - '||sqlerrm;  
                  return;                  
              end; 
              if  pc_tipgru = 'I' then
                ln_codgru := ln_codgru + 1;   
                if ln_codgru = 511 then 
                   ln_codgru := ln_codgru + 1;   
                End if;                 
              end if;                  
              
            End Loop;
          End loop;
        End if;
    End case;  
    commit;
  end sp_genera_grupos;  
  Procedure sp_modifica_grupos(pc_usuari in varchar2,
                               pd_fecpro in date,          
                               pc_tipreg in varchar2,
                               pc_codmas in varchar2,
                               pn_paijur in number, 
                               pn_tipjur in number, 
                               pc_numjur in varchar2,                                    
                               pn_numcta in number,
                               pn_codfac in number,
                               pn_painat in number, 
                               pn_tipnat in number, 
                               pc_numnat in varchar2,                              
                               pc_coderr out varchar2,                              
                               pc_msgerr out varchar2                             
                              ) is    
    cursor c_facultades  is
      select * 
       from jaqz156a a
      where a.jaqz156ausr = RPAD(pc_usuari,10,' ');
      
    cursor c_integración_1 is
      select * 
       from jaqz156b a
      where a.jaqz156busr = RPAD(pc_usuari,10,' ')
        and a.jaqz156btip = 1;
        
    cursor c_integración_2 is
      select * 
       from jaqz156b a
      where a.jaqz156busr = RPAD(pc_usuari,10,' ')
        and a.jaqz156btip = 2;
        
   cursor c_grupos_integra_a1(ln_painat in number,ln_tipnat in number,lc_numnat in varchar2,ln_faccod in number) is
      select distinct a.pgcod,a.ctnro,a.faccod,a.ctfaccor,a.ctfecdes  
        from fsr130 a 
       where a.pgcod  = 1 
         and a.ctnro  = pn_numcta
         and a.pfpai2 = ln_painat 
         and a.pftdo2 = ln_tipnat
         and a.pfndo2 = RPAD(lc_numnat,12,' ')
         and a.faccod = ln_faccod;
         
   cursor c_grupos_integra_a2(ln_painat in number,ln_tipnat in number,lc_numnat in varchar2,ln_faccod in number) is
      select distinct a.pgcod,a.ctnro,a.faccod,a.ctfaccor,a.ctfecdes 
        from fsr130 a 
       where a.pgcod  = 1 
         and a.ctnro  = pn_numcta         
         and (a.pfpai2 <> ln_painat or
              a.pftdo2 <> ln_tipnat or 
              a.pfndo2 <> RPAD(lc_numnat,12,' ')
             )
         and a.faccod = ln_faccod
         intersect
      select distinct a.pgcod,a.ctnro,a.faccod,a.ctfaccor,a.ctfecdes 
        from fsr130 a 
       where a.pgcod  = 1 
         and a.ctnro  = pn_numcta         
         and (a.pfpai2, a.pftdo2, a.pfndo2) in (         
                                                 select b.jaqz156bpai,b.jaqz156btpo,b.jaqz156bnum 
                                                   from jaqz156b b
                                                  where b.jaqz156busr = RPAD(pc_usuari,10,' ')
                                                    and b.jaqz156btip = 1         
                                                )             
         and a.faccod = ln_faccod         
         ;    
         
   cursor c_grupos_integra_a3(ln_painat in number,ln_tipnat in number,lc_numnat in varchar2,ln_faccod in number) is
      select distinct a.pgcod,a.ctnro,a.faccod,a.ctfaccor,a.ctfecdes 
        from fse130 a 
       where a.pgcod  = 1 
         and a.ctnro  = pn_numcta         
         and a.faccod = ln_faccod
      minus
      select distinct a.pgcod,a.ctnro,a.faccod,a.ctfaccor,a.ctfecdes 
        from fsr130 a 
       where a.pgcod  = 1 
         and a.ctnro  = pn_numcta         
         and a.pfpai2 = ln_painat 
         and a.pftdo2 = ln_tipnat  
         and a.pfndo2 = RPAD(lc_numnat,12,' ')             
         and a.faccod = ln_faccod;                   
               
   cursor c_grupos_integra_c1(ln_painat in number,ln_tipnat in number,lc_numnat in varchar2,ln_faccod in number) is                   
        select distinct a.jaqz151pgc,a.jaqz151pai,a.jaqz151tpo,a.jaqz151num,a.jaqz151fco,a.jaqz151fcc,a.jaqz151vid  
         from jaqz151 a 
        where a.jaqz151pgc = 1 
          and a.jaqz151pai = pn_paijur 
          and a.jaqz151tpo = pn_tipjur
          and a.jaqz151num = RPAD(pc_numjur,12,' ')
          and a.jaqz151pa2 = ln_painat
          and a.jaqz151tp2 = ln_tipnat
          and a.jaqz151nu2 = RPAD(lc_numnat,12,' ')
          and a.jaqz151fco = ln_faccod;
          
   cursor c_grupos_integra_c2(ln_painat in number,ln_tipnat in number,lc_numnat in varchar2,ln_faccod in number) is                   
        select distinct a.jaqz151pgc,a.jaqz151pai,a.jaqz151tpo,a.jaqz151num,a.jaqz151fco,a.jaqz151fcc,a.jaqz151vid 
         from jaqz151 a 
        where a.jaqz151pgc = 1 
          and a.jaqz151pai = pn_paijur 
          and a.jaqz151tpo = pn_tipjur
          and a.jaqz151num = RPAD(pc_numjur,12,' ')          
          and (a.jaqz151pa2 <> ln_painat or 
               a.jaqz151tp2 <> ln_tipnat or
               a.jaqz151nu2 <> RPAD(lc_numnat,12,' ')
              )
          and a.jaqz151fco = ln_faccod
         intersect
        select distinct a.jaqz151pgc,a.jaqz151pai,a.jaqz151tpo,a.jaqz151num,a.jaqz151fco,a.jaqz151fcc,a.jaqz151vid 
         from jaqz151 a 
        where a.jaqz151pgc = 1 
          and a.jaqz151pai = pn_paijur 
          and a.jaqz151tpo = pn_tipjur
          and a.jaqz151num = RPAD(pc_numjur,12,' ')          
          and (a.jaqz151pa2, a.jaqz151tp2, a.jaqz151nu2) in (         
                                                             select b.jaqz156bpai,b.jaqz156btpo,b.jaqz156bnum 
                                                               from jaqz156b b
                                                              where b.jaqz156busr = RPAD(pc_usuari,10,' ')
                                                                and b.jaqz156btip = 1         
                                                            )             
         and a.jaqz151fco = ln_faccod         
         ;               
                  
   cursor c_grupos_integra_c3(ln_painat in number,ln_tipnat in number,lc_numnat in varchar2,ln_faccod in number) is                   
       select distinct a.jaql499pgc,a.jaql499pai,a.jaql499tpo,a.jaql499num,a.jaql499fco,a.jaql499fcc,a.jaql499vid 
         from jaql499 a 
        where a.jaql499pgc = 1 
          and a.jaql499pai = pn_paijur 
          and a.jaql499tpo = pn_tipjur
          and a.jaql499num = RPAD(pc_numjur,12,' ')          
          and a.jaql499fco = ln_faccod
     minus          
       select distinct a.jaqz151pgc,a.jaqz151pai,a.jaqz151tpo,a.jaqz151num,a.jaqz151fco,a.jaqz151fcc,a.jaqz151vid 
         from jaqz151 a 
        where a.jaqz151pgc = 1 
          and a.jaqz151pai = pn_paijur 
          and a.jaqz151tpo = pn_tipjur
          and a.jaqz151num = RPAD(pc_numjur,12,' ')          
          and a.jaqz151pa2 = ln_painat 
          and a.jaqz151tp2 = ln_tipnat 
          and a.jaqz151nu2 = RPAD(lc_numnat,12,' ')
          and a.jaqz151fco = ln_faccod;
                           
          
  ln_codsuc  number(3):=0;      
  ln_cont1   number(9):=0;   
  ln_cont    number(9):=0;   
                           
  begin
    pc_coderr := null; 
    pc_msgerr := null;
    
    begin
      select a.ubsuc 
        into ln_codsuc 
        from fst046 a 
       where a.pgcod  = 1 
         and a.ubuser = rpad(pc_usuari,10,' ');
    exception
    when others then  
      ln_codsuc := 0;
    end;
      
    Case
      When pc_tipreg = 'C' then
        --generar correlativo de tabla
        begin
          delete from jaqz156a a where a.jaqz156ausr = rpad(pc_usuari,10,' ');
          delete from jaqz156b a where a.jaqz156busr = rpad(pc_usuari,10,' ');
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '1 - '||sqlerrm;
          return;
        end;                                 
      When pc_tipreg = 'E' then    
        begin
          insert into jaqz156b(jaqz156busr,   
                               jaqz156bpai, 
                               jaqz156btpo, 
                               jaqz156bnum,
                               jaqz156btip
                              ) 
                        values(pc_usuari,
                               pn_painat,
                               pn_tipnat,
                               pc_numnat,
                               1                               
                              );
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '2 - '||sqlerrm;
          return;
        end;     
      When pc_tipreg = 'A' then    
        begin
          insert into jaqz156b(jaqz156busr,   
                               jaqz156bpai, 
                               jaqz156btpo, 
                               jaqz156bnum,
                               jaqz156btip
                              ) 
                        values(pc_usuari,
                               pn_painat,
                               pn_tipnat,
                               pc_numnat,
                               2                               
                              );
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '3 - '||sqlerrm;
          return;
        end; 
      When pc_tipreg = 'F' then
        begin
          insert into jaqz156a(jaqz156ausr,   
                               jaqz156afac   
                              ) 
                        values(pc_usuari,
                               pn_codfac
                              );
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '4 - '||sqlerrm;
          return;
        end;                                                           
      Else
        -- procesamos las modificaciones 
        ln_cont1 := 0;
        for i in c_facultades loop
            for j in c_integración_2 loop ---integrantes a agregar
              if pc_codmas = 'A' then
                  begin
                     select count(1)
                       into ln_cont
                       from jaqz156b a
                      where a.jaqz156busr = RPAD(pc_usuari,10,' ')
                        and a.jaqz156btip = 1;
                  exception
                  when others then
                      ln_cont := 0;      
                  end;
                  if ln_cont > 0 then
                      for k in c_grupos_integra_a2(j.jaqz156bpai,j.jaqz156btpo,j.jaqz156bnum,i.jaqz156afac) loop
                        ln_cont1 := ln_cont1 + 1; 
                        begin
                          insert into fsr130(pgcod,
                                             ctnro,
                                             faccod,
                                             ctfaccor,
                                             ctfecdes,
                                             pfpai2,
                                             pftdo2,
                                             pfndo2
                                             ) 
                                      values(1, 
                                             pn_numcta, 
                                             i.jaqz156afac, 
                                             k.ctfaccor, 
                                             k.ctfecdes, 
                                             j.jaqz156bpai,  
                                             j.jaqz156btpo,
                                             j.jaqz156bnum
                                             );
                        exception  
                        when others then  
                             pc_coderr := sqlcode;
                             pc_msgerr := '5 - '||sqlerrm;
                             return;                    
                        end;  
                        --registramos historico
                        begin
                          insert into jaqz153b(jaqz153bfec,
                                               jaqz153bhor,
                                               jaqz153busr,
                                               jaqz153bpai,
                                               jaqz153btdo,
                                               jaqz153bndo,
                                               jaqz153bcta,
                                               jaqz153btpo,
                                               jaqz153bsuc,
                                               jaqz153bmod,
                                               jaqz153bfac,
                                               jaqz153bfcc,
                                               jaqz153bfde,
                                               jaqz153bfha,
                                               jaqz153bpa2,
                                               jaqz153btp2,
                                               jaqz153bno2,
                                               jaqz153bax1                            
                                              ) 
                                       values(pd_fecpro,
                                              to_char(sysdate,'HH24:mi:ss'),
                                              pc_usuari,
                                              pn_paijur, 
                                              pn_tipjur, 
                                              pc_numjur, 
                                              pn_numcta,
                                              pc_codmas,
                                              ln_codsuc,  
                                              'I',     
                                              i.jaqz156afac,                        
                                              k.ctfaccor,
                                              k.ctfecdes,
                                              null,--ojo
                                              j.jaqz156bpai, 
                                              j.jaqz156btpo, 
                                              j.jaqz156bnum,
                                              ln_cont1  
                                              );
                        exception                     
                        when others then  
                            pc_coderr := sqlcode;
                            pc_msgerr := '6 - '||sqlerrm;  
                            return;                  
                        end;                                       
                      end loop;
                  else
                      for k in c_grupos_integra_a3(j.jaqz156bpai,j.jaqz156btpo,j.jaqz156bnum,i.jaqz156afac) loop
                        ln_cont1 := ln_cont1 + 1; 
                        begin
                          insert into fsr130(pgcod,
                                             ctnro,
                                             faccod,
                                             ctfaccor,
                                             ctfecdes,
                                             pfpai2,
                                             pftdo2,
                                             pfndo2
                                             ) 
                                      values(1, 
                                             pn_numcta, 
                                             i.jaqz156afac, 
                                             k.ctfaccor, 
                                             k.ctfecdes, 
                                             j.jaqz156bpai,  
                                             j.jaqz156btpo,
                                             j.jaqz156bnum
                                             );
                        exception  
                        when others then  
                             pc_coderr := sqlcode;
                             pc_msgerr := '7 - '||sqlerrm;
                             return;                    
                        end;  
                        --registramos historico
                        begin
                          insert into jaqz153b(jaqz153bfec,
                                               jaqz153bhor,
                                               jaqz153busr,
                                               jaqz153bpai,
                                               jaqz153btdo,
                                               jaqz153bndo,
                                               jaqz153bcta,
                                               jaqz153btpo,
                                               jaqz153bsuc,
                                               jaqz153bmod,
                                               jaqz153bfac,
                                               jaqz153bfcc,
                                               jaqz153bfde,
                                               jaqz153bfha,
                                               jaqz153bpa2,
                                               jaqz153btp2,
                                               jaqz153bno2,
                                               jaqz153bax1                            
                                              ) 
                                       values(pd_fecpro,
                                              to_char(sysdate,'HH24:mi:ss'),
                                              pc_usuari,
                                              pn_paijur, 
                                              pn_tipjur, 
                                              pc_numjur, 
                                              pn_numcta,
                                              pc_codmas,
                                              ln_codsuc,  
                                              'I',     
                                              i.jaqz156afac,                        
                                              k.ctfaccor,
                                              k.ctfecdes,
                                              null,--ojo
                                              j.jaqz156bpai, 
                                              j.jaqz156btpo, 
                                              j.jaqz156bnum,
                                              ln_cont1  
                                              );
                        exception                     
                        when others then  
                            pc_coderr := sqlcode;
                            pc_msgerr := '8 - '||sqlerrm;  
                            return;                  
                        end;                                       
                      end loop;                    
                  end if;   
              else --creditos  
                  begin
                     select count(1)
                       into ln_cont
                       from jaqz156b a
                      where a.jaqz156busr = RPAD(pc_usuari,10,' ')
                        and a.jaqz156btip = 1;
                  exception
                  when others then
                      ln_cont := 0;      
                  end;
                  if ln_cont > 0 then                  
                      for k in c_grupos_integra_c2(j.jaqz156bpai,j.jaqz156btpo,j.jaqz156bnum,i.jaqz156afac) loop
                        ln_cont1 := ln_cont1 + 1;
                        begin
                        insert into jaqz151(jaqz151pgc,
                                              jaqz151pai,
                                              jaqz151tpo,
                                              jaqz151num,
                                              jaqz151fco,
                                              jaqz151fcc,
                                              jaqz151vid,
                                              jaqz151pa2,
                                              jaqz151tp2,
                                              jaqz151nu2
                                             ) 
                                      values(k.jaqz151pgc, 
                                             k.jaqz151pai,
                                             k.jaqz151tpo,
                                             k.jaqz151num,
                                             i.jaqz156afac, 
                                             k.jaqz151fcc,
                                             k.jaqz151vid,
                                             j.jaqz156bpai,  
                                             j.jaqz156btpo,
                                             j.jaqz156bnum
                                             );
                        exception
                        when others then  
                             pc_coderr := sqlcode;
                             pc_msgerr := '9 - '||sqlerrm;
                             return;                    
                        end;  
                        
                        --registramos historico
                        begin
                          insert into jaqz153b(jaqz153bfec,
                                               jaqz153bhor,
                                               jaqz153busr,
                                               jaqz153bpai,
                                               jaqz153btdo,
                                               jaqz153bndo,
                                               jaqz153bcta,
                                               jaqz153btpo,
                                               jaqz153bsuc,
                                               jaqz153bmod,
                                               jaqz153bfac,
                                               jaqz153bfcc,
                                               jaqz153bfde,
                                               jaqz153bfha,
                                               jaqz153bpa2,
                                               jaqz153btp2,
                                               jaqz153bno2,
                                               jaqz153bax1                            
                                              ) 
                                       values(pd_fecpro,
                                              to_char(sysdate,'HH24:mi:ss'),
                                              pc_usuari,
                                              pn_paijur, 
                                              pn_tipjur, 
                                              pc_numjur, 
                                              pn_numcta,
                                              pc_codmas, 
                                              ln_codsuc,  
                                              'I',     
                                              i.jaqz156afac,                        
                                              k.jaqz151fcc,
                                              k.jaqz151vid,
                                              null,
                                              j.jaqz156bpai, 
                                              j.jaqz156btpo, 
                                              j.jaqz156bnum,
                                              ln_cont1  
                                              );
                        exception                     
                        when others then  
                            pc_coderr := sqlcode;
                            pc_msgerr := '10 - '||sqlerrm;  
                            return;                  
                        end;                                                       
                      end loop;    
                  else
                      for k in c_grupos_integra_c3(j.jaqz156bpai,j.jaqz156btpo,j.jaqz156bnum,i.jaqz156afac) loop
                        ln_cont1 := ln_cont1 + 1;
                        begin
                        insert into jaqz151(jaqz151pgc,
                                              jaqz151pai,
                                              jaqz151tpo,
                                              jaqz151num,
                                              jaqz151fco,
                                              jaqz151fcc,
                                              jaqz151vid,
                                              jaqz151pa2,
                                              jaqz151tp2,
                                              jaqz151nu2
                                             ) 
                                      values(k.jaql499pgc, 
                                             k.jaql499pai,
                                             k.jaql499tpo,
                                             k.jaql499num,
                                             i.jaqz156afac, 
                                             k.jaql499fcc,
                                             k.jaql499vid,
                                             j.jaqz156bpai,  
                                             j.jaqz156btpo,
                                             j.jaqz156bnum
                                             );
                        exception
                        when others then  
                             pc_coderr := sqlcode;
                             pc_msgerr := '11 - '||sqlerrm;
                             return;                    
                        end;  
                        
                        --registramos historico
                        begin
                          insert into jaqz153b(jaqz153bfec,
                                               jaqz153bhor,
                                               jaqz153busr,
                                               jaqz153bpai,
                                               jaqz153btdo,
                                               jaqz153bndo,
                                               jaqz153bcta,
                                               jaqz153btpo,
                                               jaqz153bsuc,
                                               jaqz153bmod,
                                               jaqz153bfac,
                                               jaqz153bfcc,
                                               jaqz153bfde,
                                               jaqz153bfha,
                                               jaqz153bpa2,
                                               jaqz153btp2,
                                               jaqz153bno2,
                                               jaqz153bax1                            
                                              ) 
                                       values(pd_fecpro,
                                              to_char(sysdate,'HH24:mi:ss'),
                                              pc_usuari,
                                              pn_paijur, 
                                              pn_tipjur, 
                                              pc_numjur, 
                                              pn_numcta,
                                              pc_codmas, 
                                              ln_codsuc,  
                                              'I',     
                                              i.jaqz156afac,                        
                                              k.jaql499fcc,
                                              k.jaql499vid,
                                              null,
                                              j.jaqz156bpai, 
                                              j.jaqz156btpo, 
                                              j.jaqz156bnum,
                                              ln_cont1  
                                              );
                        exception                     
                        when others then  
                            pc_coderr := sqlcode;
                            pc_msgerr := '12 - '||sqlerrm;  
                            return;                  
                        end;                                                       
                      end loop;                        
                  end if;             
              end if;           
            End loop;     
            
            for j in c_integración_1 loop ---integrantes a quitar
              if pc_codmas = 'A' then
                  for k in c_grupos_integra_a1(j.jaqz156bpai,j.jaqz156btpo,j.jaqz156bnum,i.jaqz156afac) loop
                    ln_cont1 := ln_cont1 + 1; 
                    begin
                      delete 
                        from fsr130 a 
                       where a.pgcod    = 1 
                         and a.ctnro    = k.ctnro 
                         and a.faccod   = i.jaqz156afac 
                         and a.ctfaccor = k.ctfaccor 
                         and a.ctfecdes = k.ctfecdes 
                         and a.pfpai2   = j.jaqz156bpai  
                         and a.pftdo2   = j.jaqz156btpo
                         and a.pfndo2   = j.jaqz156bnum;
                    exception
                    when others then  
                         pc_coderr := sqlcode;
                         pc_msgerr := '13 - '||sqlerrm;
                         return;                    
                    end;
                    --registramos historico
                    begin
                      insert into jaqz153b(jaqz153bfec,
                                           jaqz153bhor,
                                           jaqz153busr,
                                           jaqz153bpai,
                                           jaqz153btdo,
                                           jaqz153bndo,
                                           jaqz153bcta,
                                           jaqz153btpo,
                                           jaqz153bsuc,
                                           jaqz153bmod,
                                           jaqz153bfac,
                                           jaqz153bfcc,
                                           jaqz153bfde,
                                           jaqz153bfha,
                                           jaqz153bpa2,
                                           jaqz153btp2,
                                           jaqz153bno2,
                                           jaqz153bax1                            
                                          ) 
                                   values(pd_fecpro,
                                          to_char(sysdate,'HH24:mi:ss'),
                                          pc_usuari,
                                          pn_paijur, 
                                          pn_tipjur, 
                                          pc_numjur, 
                                          pn_numcta,
                                          pc_codmas,
                                          ln_codsuc,  
                                          'D',     
                                          i.jaqz156afac,                        
                                          k.ctfaccor,
                                          k.ctfecdes,
                                          null,--ojo
                                          j.jaqz156bpai, 
                                          j.jaqz156btpo, 
                                          j.jaqz156bnum,
                                          ln_cont1  
                                          );
                    exception                     
                    when others then  
                        pc_coderr := sqlcode;
                        pc_msgerr := '14 - '||sqlerrm;  
                        return;                  
                    end;                                                      
                  end loop;
              else --creditos
                  for k in c_grupos_integra_c1(j.jaqz156bpai,j.jaqz156btpo,j.jaqz156bnum,i.jaqz156afac) loop
                    ln_cont1 := ln_cont1 + 1;
                    begin
                      delete 
                        from jaqz151 a 
                       where a.jaqz151pgc = k.jaqz151pgc
                         and a.jaqz151pai = k.jaqz151pai 
                         and a.jaqz151tpo = k.jaqz151tpo
                         and a.jaqz151num = k.jaqz151num
                         and a.jaqz151fco = i.jaqz156afac 
                         and a.jaqz151fcc = k.jaqz151fcc
                         and a.jaqz151vid = k.jaqz151vid
                         and a.jaqz151pa2 = j.jaqz156bpai  
                         and a.jaqz151tp2 = j.jaqz156btpo
                         and a.jaqz151nu2 = j.jaqz156bnum;
                    exception
                    when others then  
                         pc_coderr := sqlcode;
                         pc_msgerr := '15 - '||sqlerrm;
                         return;                    
                    end;
                    
                    --registramos historico
                    begin
                      insert into jaqz153b(jaqz153bfec,
                                           jaqz153bhor,
                                           jaqz153busr,
                                           jaqz153bpai,
                                           jaqz153btdo,
                                           jaqz153bndo,
                                           jaqz153bcta,
                                           jaqz153btpo,
                                           jaqz153bsuc,
                                           jaqz153bmod,
                                           jaqz153bfac,
                                           jaqz153bfcc,
                                           jaqz153bfde,
                                           jaqz153bfha,
                                           jaqz153bpa2,
                                           jaqz153btp2,
                                           jaqz153bno2,
                                           jaqz153bax1                            
                                          ) 
                                   values(pd_fecpro,
                                          to_char(sysdate,'HH24:mi:ss'),
                                          pc_usuari,
                                          pn_paijur, 
                                          pn_tipjur, 
                                          pc_numjur, 
                                          pn_numcta,
                                          pc_codmas, 
                                          ln_codsuc,  
                                          'D',     
                                          i.jaqz156afac,                        
                                          k.jaqz151fcc,
                                          k.jaqz151vid,
                                          null,
                                          j.jaqz156bpai, 
                                          j.jaqz156btpo, 
                                          j.jaqz156bnum,
                                          ln_cont1  
                                          );
                    exception                     
                    when others then  
                        pc_coderr := sqlcode;
                        pc_msgerr := '16 - '||sqlerrm;  
                        return;                  
                    end;                     
                  end loop;                
              End If;
            End loop;                       
        end loop;
      end case;
      commit;
 end sp_modifica_grupos;        
 Procedure sp_genera_asociaciones(pc_usuari in varchar2,
                                  pc_tipreg in varchar2,
                                  pc_tipagr in varchar2,
                                  pn_codpgc in number, 
                                  pn_codmod in number, 
                                  pn_codsuc in number, 
                                  pn_codmda in number, 
                                  pn_codpap in number, 
                                  pn_codcta in number, 
                                  pn_codope in number, 
                                  pn_codsbo in number, 
                                  pn_codtop in number, 
                                  pn_painat in number, 
                                  pn_tipnat in number, 
                                  pc_numnat in varchar2,   
                                  pn_codide in number,                          
                                  pc_coderr out varchar2,                              
                                  pc_msgerr out varchar2                             
                                 ) is    
  PRAGMA AUTONOMOUS_TRANSACTION;     
  cursor c_asociaciones is
    select a.jaqz158ide 
      from jaqz158 a
      where a.jaqz158pge = pn_codpgc
        and a.jaqz158mod = pn_codmod
        and a.jaqz158suc = pn_codsuc
        and a.jaqz158mda = pn_codmda
        and a.jaqz158pap = pn_codpap
        and a.jaqz158cta = pn_codcta
        and a.jaqz158ope = pn_codope
        and a.jaqz158sbo = pn_codsbo
        and a.jaqz158tpo = pn_codtop
        and a.jaqz158tip = pc_tipagr
        and a.jaqz158ide <> pn_codide;  
        
  cursor c_mapeo(pn_idecod in number) is
    select b.jaqz156bpai,b.jaqz156btpo,b.jaqz156bnum 
      from jaqz156b b 
     where b.jaqz156busr = rpad(pc_usuari,10,' ')
       and b.jaqz156btip = pn_codide---1
     minus
    select a.jaqz158apai,a.jaqz158atpo,a.jaqz158anum
      from jaqz158a a                                          
     where a.jaqz158aide = pn_idecod;
     
  ln_codide number(15):=0;   
  
  ln_cont number(10) := 0;
  begin
  pc_coderr := null; 
  pc_msgerr := null;
         
    Case
      When pc_tipreg = 'C' then
        --generar correlativo de tabla
        begin
          delete from jaqz156b a where a.jaqz156busr = rpad(pc_usuari,10,' ');
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '1 - '||sqlerrm;
          return;
        end;                                      
      When pc_tipreg = 'I' then    
        begin
          insert into jaqz156b(jaqz156busr,   
                               jaqz156bpai, 
                               jaqz156btpo, 
                               jaqz156bnum,
                               jaqz156btip
                              ) 
                        values(pc_usuari,
                               pn_painat,
                               pn_tipnat,
                               pc_numnat,
                               pn_codide                               
                              );
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '3 - '||sqlerrm;
          return;
        end;         
      When pc_tipreg = 'M' then    
        begin
          insert into jaqz156b(jaqz156busr,
                              jaqz156bpai,
                              jaqz156btpo,
                              jaqz156bnum,
                              jaqz156btip
                              )
                              select rpad(pc_usuari,10,' '),
                                     a.jaqz158apai,
                                     a.jaqz158atpo,
                                     a.jaqz158anum,
                                     a.jaqz158aide
                                from jaqz158a a
                               where a.jaqz158aide = pn_codide;
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '3 - '||sqlerrm;
          return;
        end;         
      When pc_tipreg = 'D' then    
        begin
          delete from jaqz158a a where a.jaqz158aide = pn_codide;
          delete from jaqz158  a where a.jaqz158ide  = pn_codide;
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '3 - '||sqlerrm;
          return;
        end;       
      When pc_tipreg = 'E' then    
        begin
          delete 
            from jaqz156b a 
           where a.jaqz156busr = rpad(pc_usuari,10,' ')
             and a.jaqz156bpai = pn_painat
             and a.jaqz156btpo = pn_tipnat
             and a.jaqz156bnum = rpad(pc_numnat,12,' ')
             and a.jaqz156btip = pn_codide;         
        exception
        when others then  
          pc_coderr := sqlcode;
          pc_msgerr := '3 - '||sqlerrm;
          return;
        end;             
      When pc_tipreg = 'P' then   
        ln_cont := -1;           
        for i in c_asociaciones loop         
            ln_cont := 0;
            for j in c_mapeo(i.jaqz158ide) loop           
              ln_cont := ln_cont + 1;
            End loop;    
            if ln_cont = 0 then
              exit;
            end if;
        end loop;
        if ln_cont = 0 then
          pc_coderr := 100;
          pc_msgerr := 'ERROR: - '||'Ya existe una agrupación para dicha integración';
          return;          
        Else
          if pn_codide = -1 then
              --generar id con secuencia
              ln_codide := pq_cl_autonomias.fn_genera_ide;
              --insertar a la tabla jaqz158 y jaqz158a
              begin
                insert into jaqz158(jaqz158ide,
                                    jaqz158tip,
                                    jaqz158pge,
                                    jaqz158mod,
                                    jaqz158suc,
                                    jaqz158mda,
                                    jaqz158pap,
                                    jaqz158cta,
                                    jaqz158ope,
                                    jaqz158sbo,
                                    jaqz158tpo
                                   )
                             values(ln_codide,
                                    pc_tipagr,
                                    pn_codpgc,
                                    pn_codmod,
                                    pn_codsuc,
                                    pn_codmda,
                                    pn_codpap,
                                    pn_codcta,
                                    pn_codope,
                                    pn_codsbo,
                                    pn_codtop
                                   );
              exception
              when others then  
                pc_coderr := sqlcode;
                pc_msgerr := '3 - '||sqlerrm;
                return;                               
              end;
              
              begin
                insert into jaqz158a
                  (jaqz158aide, jaqz158apai, jaqz158atpo, jaqz158anum)
                  select ln_codide, a.jaqz156bpai, a.jaqz156btpo, a.jaqz156bnum
                    from jaqz156b a 
                   where a.jaqz156busr = rpad(pc_usuari, 10, ' ')
                     and a.jaqz156btip = pn_codide;
              exception
              when others then  
                pc_coderr := sqlcode;
                pc_msgerr := '3 - '||sqlerrm;
                return;                               
              end;
          else
              begin
                update jaqz158 a 
                   set a.jaqz158tip = pc_tipagr
                 where a.jaqz158ide = pn_codide;
              exception
              when others then  
                pc_coderr := sqlcode;
                pc_msgerr := '3 - '||sqlerrm;
                return;                               
              end;
              
              begin
                delete 
                  from jaqz158a a 
                 where a.jaqz158aide = pn_codide;
              exception
              when others then  
                pc_coderr := sqlcode;
                pc_msgerr := '3 - '||sqlerrm;
                return;                               
              end;                            
              begin
                insert into jaqz158a
                  (jaqz158aide, jaqz158apai, jaqz158atpo, jaqz158anum)
                  select pn_codide, a.jaqz156bpai, a.jaqz156btpo, a.jaqz156bnum
                    from jaqz156b a 
                   where a.jaqz156busr = rpad(pc_usuari, 10, ' ')
                     and a.jaqz156btip = pn_codide;
              exception
              when others then  
                pc_coderr := sqlcode;
                pc_msgerr := '3 - '||sqlerrm;
                return;                               
              end;            
          end if;                    
        End if;                 
      Else    
        null;
      End Case;
      commit;
  end sp_genera_asociaciones;                                 
  Function fn_genera_ide return number is
    ln_codide number(15):=0;
  begin
    select id_agrupa_seq.nextval into ln_codide from dual;
    return ln_codide;
  exception 
  when others then
    return 0;
  end fn_genera_ide; 
  Procedure sp_reg_selecgrupo_trx(P_N_CODPGC IN NUMBER,                                 
                                  P_N_CODSUC IN NUMBER,                                 
                                  P_N_CODMOD IN NUMBER,                                 
                                  P_N_CODTRX IN NUMBER,                                 
                                  P_N_CODREL IN NUMBER,                                 
                                  P_D_CODFEC IN DATE,                                   
                                  P_C_CODUSR IN VARCHAR2,                                   
                                  P_N_CODPAI IN NUMBER,                                   
                                  P_N_CODTPO IN NUMBER,                                   
                                  P_C_CODNUM IN VARCHAR2,                                   
                                  P_N_CODCTA IN NUMBER,                                   
                                  P_N_CODFAC IN NUMBER,                                   
                                  P_N_CODFCO IN NUMBER,                                   
                                  P_D_CODFDE IN DATE                                   
                                 ) is 
  cursor c_audita is
  select a.* 
    from fsr130 a 
   where a.pgcod    = P_N_CODPGC 
     and a.ctnro    = P_N_CODCTA
     and a.faccod   = P_N_CODFAC
     and a.ctfaccor = P_N_CODFCO
     and a.ctfecdes = P_D_CODFDE;                               
  ln_pais     number(3);         
  ln_tipdoc   number(2); 
  lc_numdoc   char(12);
  begin
    if P_N_CODCTA > 0 then
      begin
        select a.pepais,a.petdoc,a.pendoc
          into ln_pais, ln_tipdoc, lc_numdoc 
          from fsr008 a 
         where a.pgcod = P_N_CODPGC 
           and a.ctnro = P_N_CODCTA 
           and a.ttcod = 1 
           and a.cttfir = 'T';
      exception
      when others then      
        null;
      end;
    else
      ln_pais   := P_N_CODPAI;    
      ln_tipdoc := P_N_CODTPO;
      lc_numdoc := P_C_CODNUM;   
    end if;
    
    for i in c_audita loop
        insert into JAQZ153D(JAQZ153DPGC,
                             JAQZ153DSUC,
                             JAQZ153DMOD,
                             JAQZ153DTRX,
                             JAQZ153DREL,
                             JAQZ153DFEC,
                             JAQZ153DHOR,
                             JAQZ153DUSR,
                             JAQZ153DPAI,
                             JAQZ153DTPO,
                             JAQZ153DNUM,
                             JAQZ153DCTA,
                             JAQZ153DFAC,
                             JAQZ153DFCO,
                             JAQZ153DFDE,
                             JAQZ153DPA2,
                             JAQZ153DTP2,
                             JAQZ153DNU2
                            )
                      values(P_N_CODPGC,
                             P_N_CODSUC,
                             P_N_CODMOD,
                             P_N_CODTRX,
                             P_N_CODREL,
                             P_D_CODFEC,
                             to_char(sysdate,'HH24:mi.ss'),
                             P_C_CODUSR,
                             ln_pais,
                             ln_tipdoc,
                             lc_numdoc,
                             P_N_CODCTA,
                             P_N_CODFAC,
                             P_N_CODFCO,
                             P_D_CODFDE,
                             i.pfpai2,
                             i.pftdo2,
                             i.pfndo2
                            );
    end loop;                
    commit;        
  exception
  when others then         
    null;             
  end sp_reg_selecgrupo_trx;                                     
  Procedure sp_val_fac_trx_HB(P_N_CODPGC IN NUMBER,                                 
                              P_N_CODSUC IN NUMBER,                                 
                              P_N_CODMOD IN NUMBER,                                 
                              P_N_CODTRX IN NUMBER,                                 
                              P_N_CODREL IN NUMBER, 
                              P_N_NUMORD IN NUMBER,                                 
                              P_D_FECPRO IN DATE,                                   
                              P_N_CODPAI IN paisarray,                                   
                              P_N_CODTPO IN tposarray,                                   
                              P_C_CODNUM IN numsarray                                   
                             ) is 
  cursor c_facu is
   select * 
     from fst198
    Where Tp1cod   = 1
      and Tp1cod1  = 10825
      and Tp1corr1 = 37
      and Tp1corr2 = 5
      and Tp1nro1  = P_N_CODMOD
      and Tp1nro2  = P_N_CODTRX;
      
  cursor c_integra(pais in number ,tipdoc in number, numdoc in char, Tp1nro3 in number,Sccta in number) is      
   select * 
     from fsr130
    Where PgCod = P_N_CODPGC
      and Ctnro =  Sccta
      and FacCod = Tp1nro3
      and Pfpai2 = Pais
      and Pftdo2 = Tipdoc
      and Pfndo2 = Numdoc ; 

  Tp_codpai  paisarray;
  Tp_tpodoc  tposarray;
  Tp_numero  numsarray;
  FacCod      number(3);
  CtFacCor2   number(3);
  Pfpai2      number(3);
  Pftdo2      number(2);
  Pfndo2      char(12);
  CtFecDes1  date;
  
  Scsuc      number(3);
  Scmod      number(3);
  Scmda      number(4);
  Scpap      number(4);
  Sccta      number(9);
  Scoper     number(9);
  Scsbop     number(3);
  Sctope     number(3);
  Moneda     number(4);
  Itimp1     number(17,2);
  MontoLimite number(17,2);
  CtFacLim    number(17,2);
  CtFacLimMn  number(17,2);
  
  flag        char(1);
  cont        number(9);
  Tp1nro3     number(9);
  Tp1nro4     number(9);
  F131fehs1   date;
  
  relcod   number(3);
  Ano      number(4); 
  Mes      number(2);
  Dia      number(2);
  Cadena   varchar2(10);
  Fecnum   number(9);
  
  begin
    cont := 0;
    Tp_codpai := P_N_CODPAI;
    Tp_tpodoc := P_N_CODTPO;
    Tp_numero := P_C_CODNUM;
    
    begin
      select Itsucd,
             Modulo,
             Moneda,
             Papel,
             Ctnro,
             Itoper,
             Itsubo,
             Ittope,
             Moneda,
             Itimp1 
        into Scsuc, 
             Scmod,
             Scmda, 
             Scpap, 
             Sccta, 
             Scoper,
             Scsbop,
             Sctope,
             Moneda,
             Itimp1
       from fsd016
      Where PgCod  = P_N_CODPGC
        and Itsuc  = P_N_CODSUC
        and Itmod  = P_N_CODMOD
        and Ittran = P_N_CODTRX
        and Itnrel = P_N_CODREL
        and Itord  = P_N_NUMORD;
    exception  
    when others then
      null;
    end;  
    for i in c_facu loop
        Tp1nro3 := i.Tp1nro3;

        For j in 1 .. Tp_numero.count loop --recorremos vector de documentos    
            For k in c_integra(Tp_codpai(j),Tp_tpodoc(j),Tp_numero(j),Tp1nro3,Sccta) loop
              cont := cont + 1;    
              FacCod    := k.FacCod;
              CtFacCor2 := k.CtFacCor;                         
              Pfpai2    := k.Pfpai2;
              Pftdo2    := k.Pftdo2;
              Pfndo2    := k.Pfndo2;                    
              CtFecDes1 := k.CtFecDes;     

              --Do 'valida_Montos'
              begin
                select x.CtFacLim,x.CtFacLimMn
                 into CtFacLim ,
                      CtFacLimMn
                 from fse130 x
                Where x.PgCod    = P_N_CODPGC
                  and x.Ctnro    = Sccta
                  and x.FacCod   = FacCod
                  and x.CtFacCor = Ctfaccor2
                  and x.CtFecDes = CtFecdes1;                
              exception
              when others then 
                   CtFacLim   := 0;
                   CtFacLimMn := 0;                               
              end;
              
              --Do 'Fecha_fin'
              begin
                select y.F131FeHs  
                  into F131fehs1 
                  from FSE131 y
                 Where y.F131Pg   = P_N_CODPGC
                   and y.F131Cta  = Sccta
                   and y.F131Fac  = FacCod
                   and y.F131Cor  = CtFacCor2
                   and y.F131FeDs = CtFecDes1;         
              exception
              when others then 
                   F131fehs1   := null;                   
              end;              
    
              If Moneda = 0 then
                 MontoLimite := CtFacLimMn;
              Else
                 MontoLimite := CtFacLim;
              End If;           
                If MontoLimite >= Itimp1 And (F131fehs1>= P_D_FECPRO Or F131fehs1 is null) then               
                    If CtFacCor2 > 500 then
                        --Do 'Valida_producto'
                        relcod := 5;
                        Ano    := to_number(to_char(CtFecDes1,'rrrr'));
                        Mes    := to_number(to_char(CtFecDes1,'mm'));
                        Dia    := to_number(to_char(CtFecDes1,'dd'));
                        Cadena := Ano || lpad(Mes,2,'0')||lpad(Dia,2,'0');
                        Fecnum := to_number(Cadena);                            
                        flag   := 'N';
                            
                        begin
                         select 'S'
                           into flag 
                           from Fsr011
                          Where R1cod  = P_N_CODPGC
                            and R1mod  = Scmod
                            and R1suc  = Scsuc
                            and R1mda  = Scmda
                            and R1pap  = Scpap
                            and R1cta  = Sccta
                            and R1oper = Scoper
                            and R1sbop = Scsbop
                            and R1tope = Sctope
                            and Relcod = relcod
                            and R2mod  = FacCod
                            and R2cta  = Sccta
                            and R2oper = Fecnum
                            and R2sbop = CtFacCor2
                            and R2cod  = P_N_CODPGC;
                        exception
                        when others then 
                           flag := 'N'; 
                        end;                                                                               
                    Else
                        flag := 'S';
                    End If;
                   
                    If flag = 'S' then                                               
                        begin
                          -- Call the procedure
                          pq_cl_autonomias.sp_ah_llena_validos(pn_codpgc => P_N_CODPGC,
                                                               pn_codsuc => P_N_CODSUC,
                                                               pn_codmod => P_N_CODMOD,
                                                               pn_codtrx => P_N_CODTRX,
                                                               pn_codrel => P_N_CODREL,
                                                               pn_codfec => P_D_FECPRO,
                                                               pn_faccod => FacCod,
                                                               pn_faccor => CtFacCor2,
                                                               pd_fecdes => CtFecDes1,
                                                               pn_numcta => Sccta
                                                               );
                        end;                       
                    End If;
                End If;
                
            End loop; --fin de k
            
            --
             if cont = 0 then   
                          
                Tp1nro4 := 1;
                For k in c_integra(Tp_codpai(j),Tp_tpodoc(j),Tp_numero(j),Tp1nro3,Sccta) loop
                  FacCod    := k.FacCod;
                  CtFacCor2 := k.CtFacCor;         
                  Pfpai2    := k.Pfpai2;
                  Pftdo2    := k.Pftdo2;
                  Pfndo2    := k.Pfndo2;
                  CtFecDes1 := k.CtFecDes;     
                    
                  --Do 'valida_Montos'
                  begin
                    select x.CtFacLim,x.CtFacLimMn
                     into CtFacLim ,
                          CtFacLimMn
                     from fse130 x
                    Where x.PgCod    = P_N_CODPGC
                      and x.Ctnro    = Sccta
                      and x.FacCod   = FacCod
                      and x.CtFacCor = Ctfaccor2
                      and x.CtFecDes = CtFecdes1;                
                  exception
                  when others then 
                       CtFacLim   := 0;
                       CtFacLimMn := 0;                               
                  end;
                    
                  --Do 'Fecha_fin'
                  begin
                    select y.F131FeHs  
                      into F131fehs1 
                      from FSE131 y
                     Where y.F131Pg   = P_N_CODPGC
                       and y.F131Cta  = Sccta
                       and y.F131Fac  = FacCod
                       and y.F131Cor  = CtFacCor2
                       and y.F131FeDs = CtFecDes1;         
                  exception
                  when others then 
                       F131fehs1   := null;                   
                  end;              
                        
                  If Moneda = 0 then
                      MontoLimite := CtFacLimMn;
                  Else
                      MontoLimite := CtFacLim;
                  End If;   
                          
                  If MontoLimite >= Itimp1 And (F131fehs1>= P_D_FECPRO Or F131fehs1 is null) then               
                      If CtFacCor2 > 500 then
                          --Do 'Valida_producto'
                          relcod := 5;
                          Ano    := to_number(to_char(CtFecDes1,'rrrr'));
                          Mes    := to_number(to_char(CtFecDes1,'mm'));
                          Dia    := to_number(to_char(CtFecDes1,'dd'));
                          Cadena := Ano || lpad(Mes,2,'0')||lpad(Dia,2,'0');
                          Fecnum := to_number(Cadena);                            
                          flag   := 'N';
                            
                          begin
                           select 'S'
                             into flag 
                             from Fsr011
                            Where R1cod  = P_N_CODPGC
                              and R1mod  = Scmod
                              and R1suc  = Scsuc
                              and R1mda  = Scmda
                              and R1pap  = Scpap
                              and R1cta  = Sccta
                              and R1oper = Scoper
                              and R1sbop = Scsbop
                              and R1tope = Sctope
                              and Relcod = relcod
                              and R2mod  = FacCod
                              and R2cta  = Sccta
                              and R2oper = Fecnum
                              and R2sbop = CtFacCor2
                              and R2cod  = P_N_CODPGC;
                          exception
                          when others then 
                             flag := 'N'; 
                          end;                            
                      Else
                          flag := 'S';
                      End If;
                                        
                      If flag = 'S' then                        
                          begin
                            -- Call the procedure
                            pq_cl_autonomias.sp_ah_llena_validos(pn_codpgc => P_N_CODPGC,
                                                                 pn_codsuc => P_N_CODSUC,
                                                                 pn_codmod => P_N_CODMOD,
                                                                 pn_codtrx => P_N_CODTRX,
                                                                 pn_codrel => P_N_CODREL,
                                                                 pn_codfec => P_D_FECPRO,
                                                                 pn_faccod => FacCod,
                                                                 pn_faccor => CtFacCor2,
                                                                 pd_fecdes => CtFecDes1,
                                                                 pn_numcta => Sccta
                                                                 );
                          end;                                              
                      End If;
                  End If;                         
                End loop;               
             end if;
             cont :=0;            
            --           
         End loop; --fin vectores
    End loop; --fin facu
              
  end sp_val_fac_trx_HB;         
                            
  PROCEDURE sp_cl_quickSort(v_arr   in out vc_array,
                            n_first number,
                            n_last  number
                            ) IS
     pivot number:=n_first;
     i number:=n_first;
     j number:=n_last;
     temp number;
   BEGIN

         while i<j loop
            while v_arr (i) <= v_arr (pivot) loop
                 if i<n_last then
                   i:=i+1;
                 else
                   EXIT WHEN i>=n_last;
                 end if;
            end loop;
            while v_arr(j) > v_arr(pivot) loop
                 if j>n_first then
                   j:=j-1;
                 else
                    EXIT WHEN j<=n_first;
                 end if;
            end loop;
            if i<j then
                 temp := v_arr(i);
                 v_arr(i) := v_arr(j);
                 v_arr(j) :=temp;
            elsif i>=j then
                 temp := v_arr(pivot);
                 v_arr(pivot) := v_arr(j);
                 v_arr(j) := temp;
            end if;
         end loop;
         if j-1 > 1 then
            sp_cl_quickSort(v_arr,1,j-1);
         end if;
         if  j+1 < n_last then
            sp_cl_quickSort(v_arr,j+1,n_last);
         end if;
  END sp_cl_quickSort;     
  
  Procedure sp_cl_facultades(P_N_CODPAI IN NUMBER,
                             P_N_TIPDOC IN NUMBER,
                             P_N_NUMDOC IN VARCHAR2,
                             P_N_NUMCTA IN NUMBER,
                             P_N_CODFAC IN NUMBER,
                             P_C_TIPFAC IN VARCHAR2,
                             p_c_desfac out varchar2           
                             ) is
  ln_tipfac number(9):=0;                              
  begin
    select x.tp1nro1
      into ln_tipfac
      from FST198 x
     where x.Tp1cod   = 1
       and x.Tp1cod1  = 10825
       and x.Tp1corr1 = 37
       and x.Tp1corr2 = 3
       and x.tp1nro2  = P_N_CODFAC;
       
     if ln_tipfac = 1 then
        begin
          -- Call the procedure
          pq_cl_autonomias.sp_cl_facultades_ah(p_n_codpai => P_N_CODPAI,
                                               p_n_tipdoc => P_N_TIPDOC,
                                               p_n_numdoc => P_N_NUMDOC,
                                               p_n_numcta => P_N_NUMCTA,
                                               p_n_codfac => P_N_CODFAC,
                                               p_c_tipfac => P_C_TIPFAC,
                                               p_c_desfac => p_c_desfac
                                               );                                             
        end;          
     End If;    
     
     if ln_tipfac = 2 then
        begin
          -- Call the procedure
          pq_cl_autonomias.sp_cl_facultades_cr(p_n_codpai => P_N_CODPAI,
                                               p_n_tipdoc => P_N_TIPDOC,
                                               p_n_numdoc => P_N_NUMDOC,
                                               p_n_codfac => P_N_CODFAC,
                                               p_c_tipfac => P_C_TIPFAC,
                                               p_c_desfac => p_c_desfac
                                               );
        end;       
     End If;     
  Exception
  When others then  
    p_c_desfac := null;
  End sp_cl_facultades;                               
  Procedure sp_cl_facultades_ah(P_N_CODPAI IN NUMBER,
                                P_N_TIPDOC IN NUMBER,
                                P_N_NUMDOC IN VARCHAR2,
                                P_N_NUMCTA IN NUMBER,
                                P_N_CODFAC IN NUMBER,
                                P_C_TIPFAC IN VARCHAR2,
                                p_c_desfac out varchar2           
                                ) is
  cursor c_repre is
    select distinct 
           a.pfpai1,
           a.pftdo1,
           a.pfndo1 
      from fsr003 a 
     where a.pjpais = P_N_CODPAI  
       and a.pjtdoc = P_N_TIPDOC
       and a.pjndoc = rpad(P_N_NUMDOC,12,' ')
       and a.vicod  = 7
  order by a.pfpai1,a.pftdo1,a.pfndo1;    
  
  cursor c_facu(ln_pfpai2 in number,ln_pftdo2 in number,lc_pfndo2 in char) is
    select a.* 
      from fsr130 a 
     where a.pgcod  = 1
       and a.ctnro  = P_N_NUMCTA
       and a.FacCod = P_N_CODFAC
       and a.Pfpai2 = ln_pfpai2
       and a.Pftdo2 = ln_pftdo2
       and a.Pfndo2 = lc_pfndo2;  
  
  cursor c_grupo(ln_pfpai2 in number,ln_pftdo2 in number,lc_pfndo2 in char,ln_ctfaccor in number) is
    select a.* 
      from fsr130 a 
     where a.pgcod  = 1
       and a.ctnro  = P_N_NUMCTA
       and a.FacCod = P_N_CODFAC
       and a.Ctfaccor = ln_ctfaccor
       and (
            (a.pfpai2 <> ln_pfpai2) or  (a.pftdo2  <> ln_pftdo2) or (a.pfndo2  <> lc_pfndo2)  
            );
  cursor c_crdtcap is
    select distinct 
           a.c_descri 
      from crdtcap a order by length(a.c_descri),a.c_descri; 
                   
  v_arr pq_cl_autonomias.vc_array;
  REPRE pq_cl_autonomias.tp_repre;
  ln_conta  number(5);
  ln_cont   number(5);
  ln_cont2  number(5);  
  ln_cont3  number(5);    
  ln_orden  number(5);  
  ln_ctnro  number(9);    

  ln_Pfpai2   number(3);      
  ln_Pftdo2   number(2);
  lc_Pfndo2   char(12);
  ln_Pfpai3   number(3);      
  ln_Pftdo3   number(2);
  lc_Pfndo3   char(12);  
  lv_individual varchar2(4000):= '';
  lv_conjunta   varchar2(4000):= '';
  lv_conjuntax  varchar2(4000):= '';
  ln_ctfaccor   number(3);
  begin
    delete from crdtcap;
    commit;
    ln_conta := 1;
    For i in c_repre loop                    
      REPRE(ln_conta).Orden  := ln_conta;
      REPRE(ln_conta).Cuenta := P_N_NUMCTA;
      REPRE(ln_conta).Pais   := i.pfpai1;
      REPRE(ln_conta).Tipdoc := i.pftdo1;
      REPRE(ln_conta).Numdoc := i.pfndo1;
      ln_conta := ln_conta + 1;       
    End loop;
           
    ln_cont := 0;
    lv_individual := '';
    lv_conjunta   := '';
    
    For i in REPRE.FIRST .. REPRE.LAST loop
      ln_cont  := REPRE(i).Orden;
      ln_ctnro := REPRE(i).Cuenta;
      --verificamos si tienne integración unica    
      ln_Pfpai2 := REPRE(i).Pais;
      ln_Pftdo2 := REPRE(i).Tipdoc;
      lc_Pfndo2 := REPRE(i).Numdoc;        

      ln_ctfaccor := 0;
      For j in c_facu(ln_Pfpai2,ln_Pftdo2,lc_Pfndo2) loop 
        ln_ctfaccor := j.CtFacCor;
        If P_C_TIPFAC = 'I' then
          ln_cont2 := 0;
          For k in c_grupo(ln_Pfpai2,ln_Pftdo2,lc_Pfndo2,ln_ctfaccor) loop 
             ln_ctfaccor := ln_ctfaccor;
             ln_cont2 := ln_cont2 + 1;
          End loop;
                      
          if ln_cont2 = 0 then
              lv_individual :=  lv_individual || ln_cont || ',';
              Exit;
          End If;
        Else
            lv_conjuntax := '';
            ln_cont3 := 1;            
            For k in c_grupo(ln_Pfpai2,ln_Pftdo2,lc_Pfndo2,ln_ctfaccor) loop  
                ln_Pfpai3 := k.pfpai2;
                ln_Pftdo3 := k.pftdo2;
                lc_Pfndo3 := k.pfndo2;            
                ln_orden  := 0;
                if ln_cont3 = 1 then
                  v_arr(ln_cont3):= ln_cont;
                End If;
                ln_cont3  := ln_cont3 + 1;
                      For w in REPRE.FIRST .. REPRE.LAST loop
                          if ln_Pfpai3 = REPRE(w).Pais and ln_Pftdo3 =  REPRE(w).Tipdoc and lc_Pfndo3 = REPRE(w).Numdoc then
                              ln_orden := REPRE(w).Orden; 
                              v_arr(ln_cont3):= ln_orden;                             
                              lv_conjuntax := lv_conjuntax || ln_orden;
                              Exit;
                          End If;                         
                      End loop;       
                      lv_conjuntax := lv_conjuntax || '-';
            End loop;                      
            if ln_cont3 > 1 then
                --ordenamos y metemos a la crdtcap
                pq_cl_autonomias.sp_cl_quicksort(v_arr,1,v_arr.count);            
                for z in 1.. v_arr.count loop
                     lv_conjunta := lv_conjunta || v_arr(z)||'-';
                end loop;
                lv_conjunta := substr(lv_conjunta,1,length(lv_conjunta)-1);
                insert into crdtcap(c_descri) values(lv_conjunta);
                commit;
                v_arr.delete;
                lv_conjunta := '';                
            End If;                      
        End If;
      End loop;        
    End loop;    
    If P_C_TIPFAC = 'I' then
       p_c_desfac := substr(lv_individual,1,length(lv_individual)-1);
    Else
      for z in c_crdtcap loop
        lv_conjunta := lv_conjunta ||z.c_descri||',';
      End loop;  
      p_c_desfac := substr(lv_conjunta,1,length(lv_conjunta)-1);
      delete from crdtcap;
      commit;
    End If;       
  Exception
  When others then  
    null;
  End sp_cl_facultades_ah;                               
  Procedure sp_cl_facultades_cr(P_N_CODPAI IN NUMBER,
                                P_N_TIPDOC IN NUMBER,
                                P_N_NUMDOC IN VARCHAR2,
                                P_N_CODFAC IN NUMBER,
                                P_C_TIPFAC IN VARCHAR2,
                                p_c_desfac out varchar2           
                                ) is
  cursor c_repre is
    select distinct 
           a.pfpai1,
           a.pftdo1,
           a.pfndo1 
      from fsr003 a 
     where a.pjpais = P_N_CODPAI  
       and a.pjtdoc = P_N_TIPDOC
       and a.pjndoc = rpad(P_N_NUMDOC,12,' ')
       and a.vicod  = 7
  order by a.pfpai1,a.pftdo1,a.pfndo1;    
  
  cursor c_facu(ln_pfpai1 in number,ln_pftdo1 in number,lc_pfndo1 in char,ln_pfpai2 in number,ln_pftdo2 in number,lc_pfndo2 in char) is
    select a.jaqz151fcc CtFacCor
      from jaqz151 a 
     where a.jaqz151pgc = 1
       and a.jaqz151fco = P_N_CODFAC
       and a.jaqz151pai = ln_pfpai1
       and a.jaqz151tpo = ln_pftdo1
       and a.jaqz151num = lc_pfndo1         
       and a.jaqz151pa2 = ln_pfpai2
       and a.jaqz151tp2 = ln_pftdo2
       and a.jaqz151nu2 = lc_pfndo2;  
  
  cursor c_grupo(ln_pfpai1 in number,ln_pftdo1 in number,lc_pfndo1 in char,ln_pfpai2 in number,ln_pftdo2 in number,lc_pfndo2 in char,ln_ctfaccor in number) is
    select a.jaqz151pa2 pfpai2,
           a.jaqz151tp2 pftdo2,
           a.jaqz151nu2 pfndo2
      from jaqz151 a 
     where a.jaqz151pgc = 1
       and a.jaqz151fco = P_N_CODFAC
       and a.jaqz151pai = ln_pfpai1
       and a.jaqz151tpo = ln_pftdo1
       and a.jaqz151num = lc_pfndo1       
       and a.jaqz151fcc = ln_ctfaccor 
       and (
            (a.jaqz151pa2 <> ln_pfpai2) or  (a.jaqz151tp2  <> ln_pftdo2) or (a.jaqz151nu2  <> lc_pfndo2)  
            );
  cursor c_crdtcap is
    select distinct 
           a.c_descri 
      from crdtcap a order by length(a.c_descri),a.c_descri; 
                   
  v_arr pq_cl_autonomias.vc_array;
  REPRE pq_cl_autonomias.tp_repre;
  ln_conta  number(5);
  ln_cont   number(5);
  ln_cont2  number(5);  
  ln_cont3  number(5);    
  ln_orden  number(5);  
     
  ln_Pfpai1   number(3);      
  ln_Pftdo1   number(2);
  lc_Pfndo1   char(12);
  ln_Pfpai2   number(3);      
  ln_Pftdo2   number(2);
  lc_Pfndo2   char(12);
  ln_Pfpai3   number(3);      
  ln_Pftdo3   number(2);
  lc_Pfndo3   char(12);  
  lv_individual varchar2(400):= '';
  lv_conjunta   varchar2(400):= '';
  lv_conjuntax  varchar2(400):= '';
  ln_ctfaccor   number(3);
  begin
    ln_conta := 1;
    For i in c_repre loop                    
      REPRE(ln_conta).Orden  := ln_conta;
      REPRE(ln_conta).Pais   := i.pfpai1;
      REPRE(ln_conta).Tipdoc := i.pftdo1;
      REPRE(ln_conta).Numdoc := i.pfndo1;
      ln_conta := ln_conta + 1;       
    End loop;
           
    ln_cont := 0;
    lv_individual := '';
    lv_conjunta   := '';
    
    For i in REPRE.FIRST .. REPRE.LAST loop
      ln_cont  := REPRE(i).Orden;
      --verificamos si tienne integración unica    
      ln_Pfpai2 := REPRE(i).Pais;
      ln_Pftdo2 := REPRE(i).Tipdoc;
      lc_Pfndo2 := REPRE(i).Numdoc;        

      ln_ctfaccor := 0;
      ln_Pfpai1 := P_N_CODPAI;
      ln_Pftdo1 := P_N_TIPDOC;
      lc_Pfndo1 := P_N_NUMDOC;
          
      For j in c_facu(ln_Pfpai1,ln_Pftdo1,lc_Pfndo1,ln_Pfpai2,ln_Pftdo2,lc_Pfndo2) loop 
        ln_ctfaccor := j.CtFacCor;
        If P_C_TIPFAC = 'I' then
          ln_cont2 := 0;
          For k in c_grupo(ln_Pfpai1,ln_Pftdo1,lc_Pfndo1,ln_Pfpai2,ln_Pftdo2,lc_Pfndo2,ln_ctfaccor) loop 
             ln_ctfaccor := ln_ctfaccor;
             ln_cont2 := ln_cont2 + 1;
          End loop;
                      
          if ln_cont2 = 0 then
              lv_individual :=  lv_individual || ln_cont || ',';
              Exit;
          End If;
        Else
            lv_conjuntax := '';
            ln_cont3 := 1;            
            For k in c_grupo(ln_Pfpai1,ln_Pftdo1,lc_Pfndo1,ln_Pfpai2,ln_Pftdo2,lc_Pfndo2,ln_ctfaccor) loop  
                ln_Pfpai3 := k.pfpai2;
                ln_Pftdo3 := k.pftdo2;
                lc_Pfndo3 := k.pfndo2;            
                ln_orden  := 0;
                if ln_cont3 = 1 then
                  v_arr(ln_cont3):= ln_cont;
                End If;
                ln_cont3  := ln_cont3 + 1;
                      For w in REPRE.FIRST .. REPRE.LAST loop
                          if ln_Pfpai3 = REPRE(w).Pais and ln_Pftdo3 =  REPRE(w).Tipdoc and lc_Pfndo3 = REPRE(w).Numdoc then
                              ln_orden := REPRE(w).Orden; 
                              v_arr(ln_cont3):= ln_orden;                             
                              lv_conjuntax := lv_conjuntax || ln_orden;
                              Exit;
                          End If;                         
                      End loop;       
                      lv_conjuntax := lv_conjuntax || '-';
            End loop;                      
            if ln_cont3 > 1 then
                --ordenamos y metemos a la crdtcap
                pq_cl_autonomias.sp_cl_quicksort(v_arr,1,v_arr.count);            
                for z in 1.. v_arr.count loop
                     lv_conjunta := lv_conjunta || v_arr(z)||'-';
                end loop;
                lv_conjunta := substr(lv_conjunta,1,length(lv_conjunta)-1);
                insert into crdtcap(c_descri) values(lv_conjunta);
                commit;
                v_arr.delete;
                lv_conjunta := '';                
            End If;                      
        End If;
      End loop;        
    End loop;    
    If P_C_TIPFAC = 'I' then
       p_c_desfac := substr(lv_individual,1,length(lv_individual)-1);
    Else
      for z in c_crdtcap loop
        lv_conjunta := lv_conjunta ||z.c_descri||',';
      End loop;  
      p_c_desfac := substr(lv_conjunta,1,length(lv_conjunta)-1);
      delete from crdtcap;
      commit;
    End If;       
  Exception
  When others then  
    null;
  End sp_cl_facultades_cr;                                 
end pq_cl_autonomias;
/

