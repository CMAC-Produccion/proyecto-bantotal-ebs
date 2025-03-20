create or replace procedure SP_ACTUALIZAR_RENIEC is

  P_MESANT number;
  P_ANOANT number;
  P_MES    number;
  P_ANO    number;
  cant_1 number;
  cant_2 number;
  D_FECPRO date;
BEGIN

  --OBTENER MES Y AÑO
  D_FECPRO := sysdate;
  
  P_MES := extract(MONTH from D_FECPRO);
  P_ANO := extract(YEAR from D_FECPRO);

  --OBTENER MES Y AÑO ANTERIOR
  If P_MES = 1 then
    P_MESANT := 12;
    P_ANOANT := (extract(YEAR from D_FECPRO)) - 1;
  Else
    P_MESANT := (extract(MONTH from D_FECPRO)) - 1;
    P_ANOANT := extract(YEAR from D_FECPRO);
  End If;  
  
  --ACTUALIZAR USUARIOS
  select count( distinct a.c_codusu) into cant_1
      from reniec.redcous a
     where a.n_mespro = P_MESANT
       and a.n_anhopro = P_ANOANT --mes y año anterior
       and a.c_codusu not in (select c_codusu
                                from reniec.redcous b
                               where b.n_mespro = P_MES
                                 and b.n_anhopro = P_ANO);
                                 
  dbms_output.put_line (cant_1);                                
  insert into reniec.redcous
    (n_numcor, c_codusu, n_mespro, n_anhopro, n_numcon, c_estreg)
    select rownum + (select max(n_numcor) from reniec.redcous) as n_numcor, 
           x.c_codusu, x.P_MES, x.P_ANO, x.n_numcon, x.c_estreg
           from (
    select row_number() over (partition by c_codusu order by AUFECINS desc) orden,
           c_codusu,
           P_MES,
           P_ANO, --mes y año actual
           n_numcon,
           c_estreg
      from reniec.redcous a
     where a.n_mespro = P_MESANT
       and a.n_anhopro = P_ANOANT --mes y año anterior
       and a.c_codusu not in (select c_codusu
                                from reniec.redcous b
                               where b.n_mespro = P_MES
                                 and b.n_anhopro = P_ANO) --mes y año actual
                 ) x where x.orden=1;
     commit;                            
  --ACTUALIZAR CONSULTAS
  
  select count(*) into cant_2
  from reniec.redcous a where a.c_codusu in
         (select a.c_codusu
            from reniec.redcous a
           inner join reniec.redcous b on a.c_codusu = b.c_codusu
           where a.n_mespro = P_MESANT
             and a.n_anhopro = P_ANOANT --ant
             and b.n_mespro = P_MES
             and b.n_anhopro = P_ANO --act
             and (a.n_numcon != b.n_numcon or a.c_estreg != b.c_estreg)
             and a.n_numcon != 9999)
     and a.n_mespro = P_MES --act
     and a.n_anhopro = P_ANO;
  dbms_output.put_line (cant_2); 
  update reniec.redcous a
     set n_numcon = (select n_numcon from 
                      (select b.n_numcon, 
                       row_number() over (partition by b.c_codusu order by b.aufecins desc) orden
                       from reniec.redcous b
                      where b.n_mespro = P_MESANT
                        and b.n_anhopro = P_ANOANT --ant
                        and a.c_codusu = b.c_codusu) x where x.orden=1
                    ),
         c_estreg = (   select c_estreg from                       
                        (select b.c_estreg,
                        row_number() over (partition by b.c_codusu order by b.aufecins desc) orden
                       from reniec.redcous b
                      where b.n_mespro = P_MESANT
                        and b.n_anhopro = P_ANOANT --ant
                        and a.c_codusu = b.c_codusu) x where x.orden=1
                        )
   where a.c_codusu in
         (select a.c_codusu
            from reniec.redcous a
           inner join reniec.redcous b on a.c_codusu = b.c_codusu
           where a.n_mespro = P_MESANT
             and a.n_anhopro = P_ANOANT --ant
             and b.n_mespro = P_MES
             and b.n_anhopro = P_ANO --act
             and (a.n_numcon != b.n_numcon or a.c_estreg != b.c_estreg)
             and a.n_numcon != 9999)
     and a.n_mespro = P_MES --act
     and a.n_anhopro = P_ANO;
commit;
     
END SP_ACTUALIZAR_RENIEC;
/

