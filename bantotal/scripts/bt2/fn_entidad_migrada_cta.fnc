create or replace function FN_ENTIDAD_MIGRADA_CTA(vpgcod  number,
                                                  vscsuc  number,
                                                  vscmda  number,
                                                  vscpap  number,
                                                  vsccta  number,
                                                  vscoper number,
                                                  vscsbop number,
                                                  vsctope number,
                                                  vscmod  number,
                                                  tipo    varchar2,
                                                  pdfech  date
                                                  )
  return number is
  codigo number;

begin
  begin
    select jaql54enti
      into codigo
      from jaql054
     where jaql54pgco = vpgcod
       and jaql54scsu = vscsuc
       and jaql54scmd = vscmda
       and jaql54scpa = vscpap
       and jaql54scct = vsccta
       and jaql54scop = vscoper
       and jaql54scsb = decode(vscmod,21,vscsbop,jaql54scsb)
       and jaql54scto = vsctope
       and jaql54scmo = vscmod
       and jaql54timi = tipo;
  exception
    when no_data_found then      
      begin
        select jaql54enti
          into codigo
          from jaql054
         where jaql54pgco = vpgcod
           and jaql54scpa = vscpap
           and jaql54scct = vsccta
           and jaql54timi = tipo
           and rownum < 2;        
        If codigo <> 0 and tipo = 'M' then
           If pdfech >= to_date('12/10/2015','dd/mm/rrrr')  then
              codigo := 159;
           Else
              codigo := 0;
           End If;
        /* begin
           select \*+PARALLEL(fsh012,4) *\
                  codigo            
             into codigo
             from fsh012
            where bcemp   = vpgcod
              and bcsuc   = vscsuc
              and bcmda   = vscmda
              and bcpap   = vscpap
              and bccta   = vsccta
              and bcoper  = vscoper
              and bcsbop  = vscsbop
              and bctop   = vsctope
              and bcmod   = vscmod                               
              and bcfech  = pdfech
              and bcfval >= to_date('12/10/2015','dd/mm/rrrr');                                      
         Exception
         When others then
           codigo := 0;                          
         end; */
        Else
          codigo := 0;             
        End If;           
      Exception
      When others then
        codigo := 0;        
      end;      
  end;
  return(codigo);
end FN_ENTIDAD_MIGRADA_CTA;
/

