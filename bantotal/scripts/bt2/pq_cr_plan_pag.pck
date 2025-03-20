create or replace package pq_cr_plan_pag is

  -- Author  : HSUAREZ
  -- Created : 23/10/2018 4:48:30 p. m.
  -- Purpose : SE CREO PARA EXCEPTUAR ITF EN EL PLAN DE PAGOS ORIGINAL Y ACTUALIZADO.
  --

  procedure exceptuar_ITF(ve_cta fsr008.ctnro%type,
                          flag_itf out varchar);
end pq_cr_plan_pag;
/

create or replace package body pq_cr_plan_pag is

   -- Function and procedure implementations
  procedure exceptuar_ITF(ve_cta fsr008.ctnro%type,
                          flag_itf out varchar)is
  
  vi_pepais fsr008.pepais%type;
  vi_petdoc fsr008.petdoc%type;
  vi_pendoc fsr008.pendoc%type;
  
  begin
           begin
             select pepais,
                    petdoc,
                    pendoc
               into 
                    vi_pepais,
                    vi_petdoc,
                    vi_pendoc                    
               from fsr008
               where ctnro = ve_cta
               and cttfir='T';
           exception 
               when others then
                 null;  
             end;
           begin
               select
                     'S' 
               into  flag_itf
               from ti0001 t
               where t.tirippais = vi_pepais
                 and t.tiriptdoc = vi_petdoc
                 and t.tiripndoc = vi_pendoc
                 and t.ticd_ant_i<>1
                 and rownum=1;
           exception
             when others then
                   flag_itf:='N';
           end;
  end;      
end pq_cr_plan_pag;
/

