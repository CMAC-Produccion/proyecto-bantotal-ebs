create or replace procedure sp_cr_cpotencial(ln_instancia in number,
                                             ln_segmento  in number,
                                             ln_cpoten    out number) is
begin

  ln_cpoten := 0;

  if ln_segmento = 1 then
  
    begin
      select j.jaqy140cpoten
        into ln_cpoten
        from jaqy140 j
       where j.jaqy140inst = ln_instancia
         and j.jaqy140est = 'H';
    exception
      when others then
        null;
    end;
  
  else
    if ln_segmento = 2 then
    
      begin
        select a.jaqz821cpoten
          into ln_cpoten
          from jaqz821 a
         where a.jaqz821inst = ln_instancia
           and a.jaqz821est = 'H';
      exception
        when others then
          null;
      end;
    end if;
  end if;

end sp_cr_cpotencial;
/

