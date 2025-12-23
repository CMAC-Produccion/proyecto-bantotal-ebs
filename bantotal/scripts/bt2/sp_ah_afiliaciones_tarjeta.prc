create or replace procedure SP_AH_AFILIACIONES_TARJETA(P_C_Z0E478NRO  IN VARCHAR2,--NUEVA
                                                       P_C_TIPTAR     IN VARCHAR2,
                                                       P_N_PFPAIS     IN NUMBER,
                                                       P_N_PFTDOC     IN NUMBER,
                                                       P_C_PFNDOC     IN VARCHAR2,
                                                       P_C_Z0E478NRO1 IN VARCHAR2,--ANTIGUA
                                                       p_c_coderr     out varchar2,
                                                       p_c_msgerr     out varchar2
                                                       ) is
                                                       
  -- *****************************************************************
  -- Nombre                      : SP_AH_AFILIACIONES_TARJETA
  -- Sistema                     : BANTOTAL
  -- Módulo                      : PASIVAS
  -- Versión                     : 1.0
  -- Fecha de Creación           : 2019.11.25
  -- Autor de Creación           : Yrving Lozada
  -- Uso                         : Afiliacion de tarjetas
  -- Estado                      : Activo
  -- Acceso                      : Público
  -- Fecha de Modificación       : 2025.12.05
  -- Autor de la Modificación    : Renzo Cuadros
  -- Descripción la Modificación : Se agrega campo para control notif. push
  -- *****************************************************************
                                                     
lc_z0e478nro1 char(19);
begin  
  lc_z0e478nro1 := P_C_Z0E478NRO1;
    begin             
      delete from Cnl001 a
       where a.cnl000cod = 5
         and a.cnl001adm = rpad(P_C_Z0E478NRO, 30, ' ')
         and a.cnl001usu = rpad(P_C_Z0E478NRO, 30, ' ');
         commit;
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;     
      
    begin 
       insert into Cnl001 x
         Select a.cnl000cod,P_C_Z0E478NRO,P_C_Z0E478NRO,a.cnl001nom,a.cnl001pwd,
                a.cnl001tu, a.cnl001pad,a.cnl001tad,a.cnl001dad,a.cnl001pus,
                a.cnl001tus,a.cnl001dus,a.cnl001ppv,a.cnl001tpv,a.cnl001dpv,
                a.cnl003cod,a.cnl004cod,a.cnl001hab,a.cnl001suc,a.cnl001cid,
                a.cnl001mai,a.cnl001fir,a.cnl001pw1,a.cnl001wfe,a.cnl001wfp,
                a.cnl001wfn,a.cnl001wfi,a.cnl001ucf,a.cnl001uch,a.cnl001act,
                a.cnl001uip,a.cnl001uss,a.cnl001inf,a.cnl001pal,a.cnl001cam,
                a.cnl001fcm,a.cnl001pg1,a.cnl001pg2,a.cnl001pg3,a.cnl001rs1,
                a.cnl001rs2,a.cnl001rs3,a.cnl001cai,a.cnl001fci,a.cnl001lme,
                a.cnl001csp,a.cnl001csm,a.cnl001grp,a.cnl032cod,a.cnl001raz,
                a.cnl001pti,a.cnl001ocu,a.cnl001tel,a.cnl001dom,a.cnl023prc,
                a.cnl001lha,a.cnl001fnc,a.cnl001iuc,a.cnl001hdc,a.cnl180cat
           from Cnl001 a
          where a.cnl000cod = 5
            and a.cnl001adm = rpad(lc_z0e478nro1,30,' ')
            and a.cnl001usu = rpad(lc_z0e478nro1,30,' ');
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;
    
    begin             
      delete from Cnl002 a
       where a.cnl000cod = 5
         and a.cnl001adm = rpad(P_C_Z0E478NRO, 30, ' ')
         and a.cnl001usu = rpad(P_C_Z0E478NRO, 30, ' ');
         commit;
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;     
    
    begin 
       insert into Cnl002 x
         Select a.cnl000cod,P_C_Z0E478NRO,P_C_Z0E478NRO,a.cnl002pgc,a.cnl002mod,
                a.cnl002suc,a.cnl002mda,a.cnl002pap,a.cnl002ope,a.cnl002top,
                a.cnl002cta,a.cnl002sbo,a.cnl008cod,a.cnl002hab,a.cnl002ima,
                a.cnl002nct
           from Cnl002 a
          where a.cnl000cod = 5
            and a.cnl001adm = rpad(lc_z0e478nro1,30,' ')
            and a.cnl001usu = rpad(lc_z0e478nro1,30,' ');
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;    
 
    begin             
      delete from Cnl023 a
       where a.cnl000cod = 5
         and a.cnl001adm = rpad(P_C_Z0E478NRO, 30, ' ')
         and a.cnl001usu = rpad(P_C_Z0E478NRO, 30, ' ');
         commit;
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;  
    
    begin 
       insert into Cnl023 x
         Select a.cnl000cod,P_C_Z0E478NRO,P_C_Z0E478NRO,a.cnl005cod,a.cnl023hin,
                a.cnl023hfi,a.cnl023ctr,a.cnl023hab,a.cnl023rol,a.cnl023ima,
                a.cnl023mda,a.cnl023prc
           from Cnl023 a
          where a.cnl000cod = 5
            and a.cnl001adm = rpad(lc_z0e478nro1,30,' ')
            and a.cnl001usu = rpad(lc_z0e478nro1,30,' ');
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;  
    
    begin             
      delete from Cnl034 a
       where a.cnl000cod = 5
         and a.cnl001adm = rpad(P_C_Z0E478NRO, 30, ' ')
         and a.cnl001usu = rpad(P_C_Z0E478NRO, 30, ' ');
         commit;
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;  
        
    begin 
       insert into Cnl034 x
         Select a.cnl000cod,P_C_Z0E478NRO,P_C_Z0E478NRO,a.cnl035cod,a.cnl034hab
           from Cnl034 a
          where a.cnl000cod = 5
            and a.cnl001adm = rpad(lc_z0e478nro1,30,' ')
            and a.cnl001usu = rpad(lc_z0e478nro1,30,' ');
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;   
    
    begin             
        delete from jaqy572 a
         where a.jaqy572nutar = rpad(P_C_Z0E478NRO, 19, ' ');
         commit;
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;        
    begin 
       insert into jaqy572 x
         Select P_C_Z0E478NRO,a.jaqy572habil,a.jaqy572usafi,a.jaqy572feafi,a.jaqy572hoafi,
                a.jaqy572usdes,a.jaqy572fedes,a.jaqy572hodes
           from jaqy572 a
          where a.jaqy572nutar = rpad(lc_z0e478nro1,19,' ');
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;         
    
    begin             
      delete from jaql629 a
       where a.jaql629nutar = rpad(P_C_Z0E478NRO, 19, ' ');
         commit;
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end; 
        
    begin 
       insert into jaql629 x
         Select P_C_Z0E478NRO,a.jaql629habil,a.jaql629can00,a.jaql629can01,a.jaql629can02,
                a.jaql629can03,a.jaql629can04,a.jaql629can05,a.jaql629can06,a.jaql629can07,
                a.jaql629can08,a.jaql629can09,a.jaql629can10,a.jaql629can11,a.jaql629can12,
                a.jaql629obser,a.jaql629uscre,a.jaql629fecre,a.jaql629hocre,a.jaqy629usmod,
                a.jaql629femod,a.jaql629homod,a.jaql629auxc1,a.jaql629auxc2,a.jaql629auxc3,null,null -- 2025.12.05 rcuadros
           from jaql629 a
          where a.jaql629nutar = rpad(lc_z0e478nro1,19,' ');
    exception
    when others then  
         p_c_coderr := 'N';
         p_c_msgerr := substr(sqlerrm,1,100);
         return;
    end;   
    commit;
    p_c_coderr := 'S'; 
    p_c_msgerr := null;  
exception
when others then  
  p_c_coderr := 'N';
  p_c_msgerr := substr(sqlerrm,1,100);
  return;
end SP_AH_AFILIACIONES_TARJETA;
/
