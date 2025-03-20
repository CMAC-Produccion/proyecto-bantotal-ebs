create or replace procedure SP_CR_COM_FAETURISMO (
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,                           
                             v_Sctope  in number,                             
                          --   lc_tipo_fondo out varchar,
                             ln_monto   out number
                         --    lc_estado  out varchar                                                           
                             ) is
    begin        
       select --AQPB435TIPFON, 
              SUM(AQPB435FCOMMT)-- AQPB435FEST
       into  ln_monto
       from  AQPB435 
       where AQPB435EMP = v_pgcod  
       and AQPB435MOD =  v_Scmod  
     --  and AQPB435SUC =  v_Scsuc  
       and AQPB435MDA =  v_Scmda  
       and AQPB435PAP =  v_Scpap  
       and AQPB435CTA =  v_Sccta  
       and AQPB435OPE =  v_Scoper     
       and AQPB435TOP =  v_Sctope
       and(AQPB435FEST <> 'C' OR AQPB435FEST IS NULL)  ;                              
    Exception
         when no_data_found then
          --lc_tipo_fondo:='';
          ln_monto:=0;
          --lc_estado:='';
end SP_CR_COM_FAETURISMO;
/

