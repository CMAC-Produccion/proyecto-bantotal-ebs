create or replace package PQ_AH_REP_SOFI is

  -- Author  : YLOZADA
  -- Created : 27/03/2019 1:00:59 p. m.
  -- Purpose : 
  
  procedure sp_ah_carga(P_D_FECPRO IN DATE,
                        P_N_CODREP IN NUMBER,          
                        P_C_CODTIP IN VARCHAR2,
                        P_C_CODUSU IN VARCHAR2           
                       );
  Function fn_ah_valsubgrupo(P_D_FECPRO IN DATE, 
                             P_C_CODUSU IN VARCHAR2, 
                             P_N_CODGRU IN NUMBER, 
                             P_N_CODSGR IN NUMBER,
                             P_C_CODTIP IN VARCHAR2,
                             P_N_CODREP IN NUMBER                             
                             ) return varchar2;        
  procedure sp_ah_prom_sofi(P_D_FECPRO IN DATE,
                            P_C_CODUSU IN VARCHAR2           
                           );     
                           
  procedure sp_ah_exonera(P_D_FECPRO IN DATE,
                          P_N_CODREP IN NUMBER,          
                          P_C_CODTIP IN VARCHAR2,           
                          P_C_CODUSU IN VARCHAR2           
                          );                                                                  

end PQ_AH_REP_SOFI;
/

create or replace package body PQ_AH_REP_SOFI is

  
  -- Function and procedure implementations
  procedure sp_ah_carga(P_D_FECPRO IN DATE,
                        P_N_CODREP IN NUMBER,          
                        P_C_CODTIP IN VARCHAR2,           
                        P_C_CODUSU IN VARCHAR2           
                       ) is
  ln_cont number(9):=0;   
  ln_fila number(9):=0;      
  ln_colu number(9):=0;   
  ln_flag number(9):=0;   
  lc_flag char(1) := 'N';
  
  cursor c_gruposrep1 is                   
     Select a.jaqz195cod,
            a.jaqz195ord,
            a.jaqz195des,
            b.jaqz195aor,
            b.jaqz195ade,
            replace(trim(b.jaqz195act),'X','_') jaqz195act,--RUBRO
            b.jaqz195aca,
            b.jaqz195ain,
            0 jaqz195cco
       from jaqz195 a, jaqz195a b, fst198 c
      where a.jaqz195cod = b.jaqz195aco
        and b.jaqz195aco = c.tp1nro2
        and a.jaqz195est = 'S'
        and b.jaqz195ain = 2
        and c.tp1cod     = 1 
        and c.tp1cod1    = 10825 
        and c.tp1corr1   = 88 
        and c.tp1corr2   = 2 
        and c.tp1nro1    = P_N_CODREP  --codigo de reporte
   order by a.jaqz195ord, b.jaqz195aor;        
     
  cursor c_gruposrep3 is
     Select a.jaqz195cod,
            a.jaqz195ord,
            a.jaqz195des,
            b.jaqz195aor,
            b.jaqz195ade,
            to_number(trim(b.jaqz195act)) jaqz195act,
            b.jaqz195aca,
            b.jaqz195ain,
            0 jaqz195cco
       from jaqz195 a, jaqz195a b, fst198 c
      where a.jaqz195cod = b.jaqz195aco
        and b.jaqz195aco = c.tp1nro2
        and a.jaqz195est = 'S'
        and b.jaqz195ain = 0
        and c.tp1cod     = 1 
        and c.tp1cod1    = 10825 
        and c.tp1corr1   = 88 
        and c.tp1corr2   = 2 
        and c.tp1nro1    = P_N_CODREP  --codigo de reporte
     union
     Select a.jaqz195cod,
            a.jaqz195ord,
            a.jaqz195des,
            b.jaqz195aor,
            c.jaqz195cde,
            d.jaqz195dct,
            b.jaqz195aca,
            b.jaqz195ain,
            c.jaqz195cco
       from jaqz195 a, jaqz195a b, jaqz195c c, jaqz195d d, fst198 e
      where a.jaqz195cod = b.jaqz195aco
        and b.jaqz195aco = e.tp1nro2
        and trim(b.jaqz195act) = c.jaqz195cco
        and c.jaqz195cco = d.jaqz195dco
        and b.jaqz195ain = 1
        and a.jaqz195est = 'S'
        and c.jaqz195ces = 'S'
        and e.tp1cod     = 1 
        and e.tp1cod1    = 10825 
        and e.tp1corr1   = 88 
        and e.tp1corr2   = 2 
        and e.tp1nro1    = P_N_CODREP  --codigo de reporte       
   order by jaqz195ord, jaqz195aor;
      
  cursor c_campos is
    Select a.*
      from jaqz196  a
     where a.jaqz196est = 'S' 
  order by a.jaqz196col;
 
  cursor rubrocampo(ln_codcam in number) is
    Select b.jaqz196aco,replace(trim(b.jaqz196arb),'X','_') jaqz196arb
      from jaqz196a b
     where b.jaqz196aco = ln_codcam;
     
  cursor rubro(lv_codrub in varchar2) is     
    Select a.*
      from fsd014 a
     where a.rubro like lv_codrub;         
  
  cursor saldorubro(ln_codrub in number, ln_numcta in number) is
    Select b.*
      from fsh012 b
     where b.bcemp  = 1
       and b.bcrubr = ln_codrub       
       and b.bccta  = decode(ln_numcta,0,b.bccta,ln_numcta) 
       and b.bcfech = P_D_FECPRO;

  cursor rep3detall is
        Select a.jaqz197cod,
               P_C_CODTIP jaqz197tip,
               a.jaqz197fec,
               a.jaqz197usr,
               a.jaqz197gru,
               a.jaqz197ent,
               a.jaqz197cal,
               a.jaqz197rub,
               a.jaqz197dru,
               a.jaqz197mda,
               a.jaqz197cta,
               a.jaqz197ope,
               a.jaqz197fve,
               a.jaqz197fva,
               a.jaqz197tas,
               sum(a.jaqz197smo) jaqz197smo,
               sum(a.jaqz197smn) jaqz197smn,
               sum(a.jaqz197int) jaqz197int
          from jaqz197 a  
         where a.jaqz197cod = P_N_CODREP
           and a.jaqz197tip = 'A'
           and a.jaqz197fec = P_D_FECPRO
           and a.jaqz197usr = RPAD(P_C_CODUSU,10,' ')
           and not exists (
                            Select 1
                              from crdtcap x
                             where x.c_descri  = TRIM(P_C_CODUSU)
                               and x.c_descri1 = a.jaqz197tip
                               and x.n_monto1  = P_N_CODREP
                               and x.d_fecha   = P_D_FECPRO
                               and to_number(trim(x.c_descri2)) = a.jaqz197rub           
                           )
           and ( a.jaqz197smo > 0
                 or
                 a.jaqz197smn > 0
                 or
                 a.jaqz197int > 0
               )
    group by a.jaqz197cod,               
             a.jaqz197fec,
             a.jaqz197usr,
             a.jaqz197gru,
             a.jaqz197ent,
             a.jaqz197cal,
             a.jaqz197rub,
             a.jaqz197dru,
             a.jaqz197mda,
             a.jaqz197cta,
             a.jaqz197ope,
             a.jaqz197fve,
             a.jaqz197fva,
             a.jaqz197tas;
                  
  cursor rep3consol is
        Select a.jaqz197cod,
               P_C_CODTIP jaqz197tip,
               a.jaqz197fec,
               a.jaqz197usr,
               a.jaqz197fil,
               a.jaqz197col,
               a.jaqz197gru,
               a.jaqz197ent,
               a.jaqz197cal,
               sum(a.jaqz197smn) jaqz197smn
          from jaqz197 a  
         where a.jaqz197cod = P_N_CODREP
           and a.jaqz197tip = 'A'
           and a.jaqz197fec = P_D_FECPRO
           and a.jaqz197usr = RPAD(P_C_CODUSU,10,' ')
           and not exists (
                            Select 1
                              from crdtcap x
                             where x.c_descri  = TRIM(P_C_CODUSU)
                               and x.c_descri1 = a.jaqz197tip
                               and x.n_monto1  = P_N_CODREP
                               and x.d_fecha   = P_D_FECPRO
                               and to_number(trim(x.c_descri2)) = a.jaqz197rub           
                           )           
      group by a.jaqz197cod,
               a.jaqz197fec,
               a.jaqz197usr,
               a.jaqz197fil,
               a.jaqz197col,
               a.jaqz197gru,
               a.jaqz197ent,
               a.jaqz197cal
      order by a.jaqz197fil,
               a.jaqz197col;
               
  cursor rep1consol is               
        Select a.jaqz197cod,
               P_C_CODTIP jaqz197tip,
               a.jaqz197fec,
               a.jaqz197usr,
               a.jaqz197fil,
               min(a.jaqz197col)jaqz197col,
               a.jaqz197gru,
               a.jaqz197ent,
               a.jaqz197cal,
               sum(a.jaqz197smn) jaqz197smn,
               sum(
               case 
                 when a.jaqz197smn = 0 then
                    0
                 else  
                    1
               End 
               )totope  
          from jaqz197 a  
         where a.jaqz197cod = P_N_CODREP
           and a.jaqz197tip = 'A'
           and a.jaqz197fec = P_D_FECPRO
           and a.jaqz197usr = RPAD(P_C_CODUSU,10,' ')
           and not exists (
                            Select 1
                              from crdtcap x
                             where x.c_descri  = TRIM(P_C_CODUSU)
                               and x.c_descri1 = a.jaqz197tip
                               and x.n_monto1  = P_N_CODREP
                               and x.d_fecha   = P_D_FECPRO
                               and to_number(trim(x.c_descri2)) = a.jaqz197rub           
                           )           
      group by a.jaqz197cod,
               a.jaqz197fec,
               a.jaqz197usr,
               a.jaqz197fil,
               a.jaqz197gru,
               a.jaqz197ent,
               a.jaqz197cal
      order by a.jaqz197fil,
               min(a.jaqz197col);      
                        
  cursor rep3totfil is               
        Select a.jaqz197cod,
                P_C_CODTIP jaqz197tip,
               a.jaqz197fec,
               a.jaqz197usr,
               a.jaqz197fil,
               sum(a.jaqz197smn) jaqz197smn
          from jaqz197 a  
         where a.jaqz197cod = P_N_CODREP
           and a.jaqz197tip = 'A'
           and a.jaqz197fec = P_D_FECPRO
           and a.jaqz197usr = RPAD(P_C_CODUSU,10,' ')     
           and not exists (
                            Select 1
                              from crdtcap x
                             where x.c_descri  = TRIM(P_C_CODUSU)
                               and x.c_descri1 = a.jaqz197tip
                               and x.n_monto1  = P_N_CODREP
                               and x.d_fecha   = P_D_FECPRO
                               and to_number(trim(x.c_descri2)) = a.jaqz197rub           
                           )                 
      group by a.jaqz197cod,
               a.jaqz197fec,
               a.jaqz197usr,
               a.jaqz197fil
      order by a.jaqz197fil;    
      
  cursor rep3totcol is     
        Select a.jaqz197cod,
               P_C_CODTIP jaqz197tip,
               a.jaqz197fec,
               a.jaqz197usr,
               a.jaqz197col,
               sum(a.jaqz197smn) jaqz197smn
          from jaqz197 a  
         where a.jaqz197cod = P_N_CODREP
           and a.jaqz197tip = 'A'
           and a.jaqz197fec = P_D_FECPRO
           and a.jaqz197usr = RPAD(P_C_CODUSU,10,' ')    
           and not exists (
                            Select 1
                              from crdtcap x
                             where x.c_descri  = TRIM(P_C_CODUSU)
                               and x.c_descri1 = a.jaqz197tip
                               and x.n_monto1  = P_N_CODREP
                               and x.d_fecha   = P_D_FECPRO
                               and to_number(trim(x.c_descri2)) = a.jaqz197rub           
                           )                  
      group by a.jaqz197cod,
               a.jaqz197fec,
               a.jaqz197usr,
               a.jaqz197col
      order by a.jaqz197col;              
  cursor rep2consol is
        Select xx.*,yy.monto 
          from (
                 Select a.jaqz195cod,
                        a.jaqz195ord,
                        a.jaqz195des,
                        b.jaqz195aor,
                        b.jaqz195ade,
                        decode(b.jaqz195ain,0,to_number(trim(b.jaqz195act)),b.jaqz195act) jaqz195act,
                        b.jaqz195aca,
                        b.jaqz195ain,
                        0 jaqz195cco
                   from jaqz195 a, jaqz195a b, fst198 c
                  where a.jaqz195cod = b.jaqz195aco
                    and b.jaqz195aco = c.tp1nro2
                    and a.jaqz195est = 'S'
                    and b.jaqz195ain = 0
                    and c.tp1cod     = 1 
                    and c.tp1cod1    = 10825 
                    and c.tp1corr1   = 88 
                    and c.tp1corr2   = 2 
                    and c.tp1nro1    = P_N_CODREP  --codigo de reporte
                 union
                 Select a.jaqz195cod,
                        a.jaqz195ord,
                        a.jaqz195des,
                        b.jaqz195aor,
                        c.jaqz195cde,
                        decode(b.jaqz195ain,0,to_number(trim(b.jaqz195act)),b.jaqz195act) jaqz195act,
                        b.jaqz195aca,
                        b.jaqz195ain,
                        c.jaqz195cco
                   from jaqz195 a, jaqz195a b, jaqz195c c, jaqz195d d, fst198 e
                  where a.jaqz195cod = b.jaqz195aco
                    and b.jaqz195aco = e.tp1nro2
                    and trim(b.jaqz195act) = c.jaqz195cco
                    and c.jaqz195cco = d.jaqz195dco
                    and b.jaqz195ain = 1
                    and a.jaqz195est = 'S'
                    and c.jaqz195ces = 'S'
                    and e.tp1cod     = 1 
                    and e.tp1cod1    = 10825 
                    and e.tp1corr1   = 88 
                    and e.tp1corr2   = 2 
                    and e.tp1nro1    = P_N_CODREP  --codigo de reporte       
              ) XX,  
              (
                 Select to_number(trim(b.jaqz195act)) jaqz195act,
                        b.jaqz195ain,
                        sum(f.bcsdmn) monto
                   from jaqz195 a, jaqz195a b, fst198 c, fsh012 f
                  where a.jaqz195cod = b.jaqz195aco
                    and b.jaqz195aco = c.tp1nro2
                    and a.jaqz195est = 'S'
                    and b.jaqz195ain = 0
                    and c.tp1cod     = 1 
                    and c.tp1cod1    = 10825 
                    and c.tp1corr1   = 88 
                    and c.tp1corr2   = 2 
                    and c.tp1nro1    = P_N_CODREP  --codigo de reporte
                    and f.BCEMP = 1
                    and f.BCMOD = 22
                    and (f.BCSUC = 904 
                         or 
                         (f.BCSUC = 11 and b.jaqz195act = 538187)
                        )
                    and to_number(trim(b.jaqz195act)) = f.bccta
                    and f.BCFECH = P_D_FECPRO
               group by to_number(trim(b.jaqz195act)),
                        b.jaqz195ain                    
                 union              
                 Select to_number(trim(b.jaqz195act)) jaqz195act,
                        b.jaqz195ain,
                        sum(f.bcsdmn) monto
                   from jaqz195 a, jaqz195a b, jaqz195c c, jaqz195d d, fst198 e, fsh012 f
                  where a.jaqz195cod = b.jaqz195aco
                    and b.jaqz195aco = e.tp1nro2
                    and trim(b.jaqz195act) = c.jaqz195cco
                    and c.jaqz195cco = d.jaqz195dco
                    and b.jaqz195ain = 1
                    and a.jaqz195est = 'S'
                    and c.jaqz195ces = 'S'
                    and e.tp1cod     = 1 
                    and e.tp1cod1    = 10825 
                    and e.tp1corr1   = 88 
                    and e.tp1corr2   = 2 
                    and e.tp1nro1    = P_N_CODREP                    
                    and f.BCEMP = 1
                    and f.BCMOD = 22
                    and (f.BCSUC = 904 
                         or 
                         (f.BCSUC = 11 and b.jaqz195act = 538187)
                        )
                    and d.jaqz195dct = f.bccta
                    and f.BCFECH = P_D_FECPRO
               group by to_number(trim(b.jaqz195act)),
                        b.jaqz195ain
              ) YY
        where xx.jaqz195act = yy.jaqz195act(+)
     order by xx.jaqz195aor;  
  /*
        Select xx.*,yy.monto 
          from (
               Select a.jaqz195cod,
                        a.jaqz195ord,
                        a.jaqz195des,
                        b.jaqz195aor,
                        b.jaqz195ade,
                        to_number(trim(b.jaqz195act)) jaqz195act,
                        b.jaqz195aca,
                        b.jaqz195ain,
                        0 jaqz195cco
                 from jaqz195 a, jaqz195a b, fst198 c
                where a.jaqz195cod = b.jaqz195aco
                  and b.jaqz195aco = c.tp1nro2
                  and a.jaqz195est = 'S'
                  and b.jaqz195ain = 0
                  and c.tp1cod = 1
                  and c.tp1cod1 = 10825
                  and c.tp1corr1 = 88
                  and c.tp1corr2 = 2
                  and c.tp1nro1 = P_N_CODREP --codigo de reporte
              ) XX,  
              (
                 Select to_number(trim(b.jaqz195act)) jaqz195act,
                        sum(d.bcsdmn) monto
                   from jaqz195 a, jaqz195a b, fst198 c, fsh012 d
                  where a.jaqz195cod = b.jaqz195aco
                    and b.jaqz195aco = c.tp1nro2
                    and a.jaqz195est = 'S'
                    and b.jaqz195ain = 0
                    and c.tp1cod = 1
                    and c.tp1cod1 = 10825
                    and c.tp1corr1 = 88
                    and c.tp1corr2 = 2
                    and c.tp1nro1 = P_N_CODREP --codigo de reporte
                    and d.BCEMP = 1
                    and d.BCMOD = 22
                    and (d.BCSUC = 904 
                         or 
                         (d.BCSUC = 11 and b.jaqz195act = 538187)
                        )
                    and b.jaqz195act = d.bccta
                    and d.BCFECH = P_D_FECPRO
               group by to_number(trim(b.jaqz195act))
              ) YY
        where xx.jaqz195act = yy.jaqz195act(+)
     order by xx.jaqz195aor; 
     */                       
  begin
    Case 
    when P_N_CODREP = 1 then --REPORTE DE VERIFICACIÓN DE SALDOS
        if P_C_CODTIP in ('A') then
            delete from jaqz197 a where a.jaqz197fec = P_D_FECPRO and a.jaqz197usr = RPAD(P_C_CODUSU,10,' ') and a.jaqz197cod = P_N_CODREP;
            commit;        
            
            begin
              -- Call the procedure
              pq_ah_rep_sofi.sp_ah_exonera(p_d_fecpro => P_D_FECPRO,
                                           p_n_codrep => P_N_CODREP,
                                           p_c_codtip => P_C_CODTIP,
                                           p_c_codusu => P_C_CODUSU
                                           );
            end;
                  
            ln_fila := 0;       
            for i in c_gruposrep1 loop --recorremos los grupos del reporte
              ln_fila := i.jaqz195ord;
              ln_colu := i.jaqz195aor;
              ln_flag := 0;  
                  for zz in rubro(i.jaqz195act) loop --saldo de rubros fsh012                              
                    for z in saldorubro(zz.rubro,0) loop 
                      --REGISTRAR LOS SALDOS EN TABLA TEMPORAL CON CODIGO DE FILA Y COLUMNA
                      ln_flag := ln_flag + 1;                
                      ln_cont := ln_cont + 1;
                      begin
                        if z.bccta <> 105423 then
                          insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                              jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                              jaqz197int,jaqz197ain,jaqz197cgr,jaqz197csg
                                              ) 
                                        values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,ln_fila,ln_colu,i.jaqz195des,i.jaqz195ade,i.jaqz195aca,
                                               z.bcrubr,zz.pcnomr,z.bcmda,z.bccta,z.bcoper,z.bcfvto,z.bcfval,z.bctasa,abs(z.bcsdmo),abs(z.bcsdmn),
                                               abs(z.bcint),i.jaqz195ain,i.jaqz195cod,i.jaqz195cco
                                              );  
                        end if;                             
                      end;                        
                    end loop;
                  end loop;
                  if ln_flag = 0 then
                    ln_cont := ln_cont + 1;
                    begin
                      insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                          jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                          jaqz197int,jaqz197ain,jaqz197cgr,jaqz197csg
                                          ) 
                                    values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,ln_fila,ln_colu,i.jaqz195des,i.jaqz195ade,i.jaqz195aca,
                                           null,null,null,0,null,null,null,null,0,0,
                                           0,i.jaqz195ain,i.jaqz195cod,i.jaqz195cco
                                          );    
                    end;  
                  end if;          
            end loop;
          commit;
        end if;      
        if P_C_CODTIP = 'D'  then --DETALLADO
          ln_cont := 0; 
          for i in rep3detall loop
            ln_cont := ln_cont + 1;
            begin
              insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                  jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                  jaqz197int
                                  ) 
                            values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,null,null,i.jaqz197gru,i.jaqz197ent,i.jaqz197cal,
                                   i.jaqz197rub,i.jaqz197dru,i.jaqz197mda,i.jaqz197cta,i.jaqz197ope,i.jaqz197fve,i.jaqz197fva,i.jaqz197tas,i.jaqz197smo,i.jaqz197smn,
                                   i.jaqz197int
                                  );    
            end;        
          end loop;
          commit;
        End If;    
        if P_C_CODTIP = 'C' then --CONSOLIDADO
          ln_cont := 0; 
          for i in rep1consol loop
            ln_cont := ln_cont + 1;
            begin
              insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                  jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                  jaqz197int
                                  ) 
                            values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,i.jaqz197fil,i.jaqz197col,i.jaqz197gru,i.jaqz197ent,i.jaqz197cal,
                                   null,null,null,null,null,null,null,null,0,i.jaqz197smn,
                                   i.totope
                                  );    
            end;        
          end loop;
          commit;
        End If;  
        
    when P_N_CODREP = 3 then --REPORTE DE GRUPOS ECONÓMICOS
        if P_C_CODTIP in ('A') then
            delete from jaqz197 a where a.jaqz197fec = P_D_FECPRO and a.jaqz197usr = RPAD(P_C_CODUSU,10,' ') and a.jaqz197cod = P_N_CODREP;
            commit;     
            begin
              -- Call the procedure
              pq_ah_rep_sofi.sp_ah_exonera(p_d_fecpro => P_D_FECPRO,
                                           p_n_codrep => P_N_CODREP,
                                           p_c_codtip => P_C_CODTIP,
                                           p_c_codusu => P_C_CODUSU
                                           );
            end;                     
            ln_fila := 0;       
            for i in c_gruposrep3 loop --recorremos los grupos del reporte
              if i.jaqz195ain = 0 then
                 ln_fila := ln_fila + 1;
              Else
                lc_flag := pq_ah_rep_sofi.fn_ah_valsubgrupo(p_d_fecpro => P_D_FECPRO,
                                                            p_c_codusu => P_C_CODUSU,
                                                            p_n_codgru => i.jaqz195cod,
                                                            p_n_codsgr => i.jaqz195cco,
                                                            p_c_codtip => P_C_CODTIP,
                                                            p_n_codrep => P_N_CODREP
                                                            );        
                if lc_flag = 'N'then
                   ln_fila := ln_fila + 1;
                End If;                                                      
              End If;  
              for j in c_campos loop --recorremos los campos
                ln_colu := j.jaqz196col;
                for k in rubrocampo(j.jaqz196cod) loop --mapeo rubro x campo        
                  ln_flag := 0;  
                  for zz in rubro(k.jaqz196arb) loop --saldo de rubros fsh012                              
                    for z in saldorubro(zz.rubro,to_number(trim(i.jaqz195act))) loop 
                      --REGISTRAR LOS SALDOS EN TABLA TEMPORAL CON CODIGO DE FILA Y COLUMNA
                      ln_flag := ln_flag + 1;                
                      ln_cont := ln_cont + 1;
                      begin
                        insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                            jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                            jaqz197int,jaqz197ain,jaqz197cgr,jaqz197csg
                                            ) 
                                      values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,ln_fila,ln_colu,i.jaqz195des,i.jaqz195ade,i.jaqz195aca,
                                             z.bcrubr,zz.pcnomr,z.bcmda,to_number(trim(i.jaqz195act)),z.bcoper,z.bcfvto,z.bcfval,z.bctasa,abs(z.bcsdmo),abs(z.bcsdmn),
                                             abs(z.bcint),i.jaqz195ain,i.jaqz195cod,i.jaqz195cco
                                            );          
                      end;                        
                    end loop;
                  end loop;
                  if ln_flag = 0 then
                    ln_cont := ln_cont + 1;
                    begin
                      insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                          jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                          jaqz197int,jaqz197ain,jaqz197cgr,jaqz197csg
                                          ) 
                                    values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,ln_fila,ln_colu,i.jaqz195des,i.jaqz195ade,i.jaqz195aca,
                                           null,null,null,to_number(trim(i.jaqz195act)),null,null,null,null,0,0,
                                           0,i.jaqz195ain,i.jaqz195cod,i.jaqz195cco
                                          );    
                    end;  
                  end if;          
                end loop;
              end loop;  
            end loop;  
          commit;
      end if;
      
      if P_C_CODTIP = 'D' then --DETALLADO
        ln_cont := 0; 
        for i in rep3detall loop
          ln_cont := ln_cont + 1;
          begin
            insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                jaqz197int
                                ) 
                          values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,null,null,i.jaqz197gru,i.jaqz197ent,i.jaqz197cal,
                                 i.jaqz197rub,i.jaqz197dru,i.jaqz197mda,i.jaqz197cta,i.jaqz197ope,i.jaqz197fve,i.jaqz197fva,i.jaqz197tas,i.jaqz197smo,i.jaqz197smn,
                                 i.jaqz197int
                                );    
          end;        
        end loop;
        commit;
      End If;    
      if P_C_CODTIP = 'C' then --CONSOLIDADO
        ln_cont := 0; 
        for i in rep3consol loop
          ln_cont := ln_cont + 1;
          begin
            insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                jaqz197int
                                ) 
                          values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,i.jaqz197fil,i.jaqz197col,i.jaqz197gru,i.jaqz197ent,i.jaqz197cal,
                                 null,null,null,null,null,null,null,null,0,i.jaqz197smn,
                                 0
                                );    
          end;        
        end loop;
        commit;
      End If;  
      
      if P_C_CODTIP = 'I' then --totales por fila
        ln_cont := 0; 
        for i in rep3totfil loop
          ln_cont := ln_cont + 1;
          begin
            insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                jaqz197int
                                ) 
                          values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,i.jaqz197fil,0,null,null,null,
                                 null,null,null,null,null,null,null,null,0,i.jaqz197smn,
                                 0
                                );    
          end;        
        end loop;
        commit;    
      End if;  
      if P_C_CODTIP = 'J' then --totales por columna
        ln_cont := 0; 
        for i in rep3totcol loop
          ln_cont := ln_cont + 1;
          begin
            insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                jaqz197int
                                ) 
                          values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,0,i.jaqz197col,null,null,null,
                                 null,null,null,null,null,null,null,null,0,i.jaqz197smn,
                                 0
                                );    
          end;        
        end loop;
        commit;    
      End if;  
    when P_N_CODREP = 2 then --REPORTE DE SALDOS PASIVOS
      delete from jaqz197 a where a.jaqz197fec = P_D_FECPRO and a.jaqz197usr = RPAD(P_C_CODUSU,10,' ') and a.jaqz197cod = P_N_CODREP;
      commit;
      
      begin
        -- Call the procedure
        pq_ah_rep_sofi.sp_ah_exonera(p_d_fecpro => P_D_FECPRO,
                                     p_n_codrep => P_N_CODREP,
                                     p_c_codtip => P_C_CODTIP,
                                     p_c_codusu => P_C_CODUSU
                                     );
      end;      
      if P_C_CODTIP = 'C' then --CONSOLIDADO
        ln_cont := 0; 
        for i in rep2consol loop
          ln_cont := ln_cont + 1;
          begin
            insert into jaqz197(jaqz197cod,jaqz197tip,jaqz197fec,jaqz197usr,jaqz197cor,jaqz197fil,jaqz197col,jaqz197gru,jaqz197ent,jaqz197cal,
                                jaqz197rub,jaqz197dru,jaqz197mda,jaqz197cta,jaqz197ope,jaqz197fve,jaqz197fva,jaqz197tas,jaqz197smo,jaqz197smn,
                                jaqz197int
                                ) 
                          values(P_N_CODREP,P_C_CODTIP,P_D_FECPRO,P_C_CODUSU,ln_cont,0,0,null,i.jaqz195ade,null,
                                 null,null,null,i.jaqz195act,null,null,null,null,i.jaqz195ain,i.monto,
                                 0
                                );    
          end;        
        end loop;
        commit;
      End If;  
    End case;
  end sp_ah_carga;
  Function fn_ah_valsubgrupo(P_D_FECPRO IN DATE, 
                             P_C_CODUSU IN VARCHAR2, 
                             P_N_CODGRU IN NUMBER, 
                             P_N_CODSGR IN NUMBER,
                             P_C_CODTIP IN VARCHAR2,
                             P_N_CODREP IN NUMBER
                             ) return varchar2 is
  lc_flag char(1):= 'N';                             
  begin
        Select 'S'
          into lc_flag
          from jaqz197 a  
         where a.jaqz197cod = P_N_CODREP
           and a.jaqz197tip = P_C_CODTIP
           and a.jaqz197fec = P_D_FECPRO
           and a.jaqz197usr = RPAD(P_C_CODUSU,10,' ')   
           and a.jaqz197cgr = P_N_CODGRU
           and a.jaqz197csg = P_N_CODSGR;
  return lc_flag;           
  exception
  when no_data_found then
       lc_flag := 'N';
       return lc_flag;
  when others then
       lc_flag := 'S';
       return lc_flag;    
  end fn_ah_valsubgrupo;                             
  procedure sp_ah_prom_sofi(P_D_FECPRO IN DATE,
                            P_C_CODUSU IN VARCHAR2           
                           ) is  
  ln_fonred number(17,2):= 0;                           
  ln_fontes number(17,2):= 0;
  ln_firapo number(17,2):= 0;
  ln_tenapo number(17,2):= 0;
  ln_tweapo number(17,2):= 0;
  ln_cont   number(9):= 0;
  ln_profon number(17,2):= 0;
  ln_propri number(17,2):= 0;
  ln_numdia number(2):= 0;
  
  cursor c_aportantes is
    SELECT C.PEPAIS, C.PETDOC, C.PENDOC, SUM(B.BCSDMN) AS SALDO
      FROM FSH012 B
      LEFT JOIN FSI006 A
        ON B.BCRUBR = A.RUBRO
     INNER JOIN FSR008 C
        ON C.CTNRO = B.BCCTA
     WHERE B.BCEMP = 1
       AND A.CICPO = 'INDICAD2'
       AND B.BCFECH = P_D_FECPRO
       AND C.CTTFIR = 'T'
       AND C.TTCOD = 1
     GROUP BY C.PEPAIS, C.PETDOC, C.PENDOC
     ORDER BY SALDO DESC;
    
  begin
    
    execute immediate 'alter session set "_optimizer_batch_table_access_by_rowid" =false';
    
      delete from jaqz198 a where a.jaqz198fec = P_D_FECPRO;
      commit;
      
      --obtenemos el fondeo de agencias para el día
      begin        
           Select nvl(sum(x.bcsdmn),0) 
             into ln_fonred
             from FSH012 X
            WHERE X.BCEMP = 1
              AND (X.BCMOD in (21, 22)
                   or  
                   (x.bcmod = 201 and x.bctop = 0)
                  )
              and x.bcmda in (0, 101)
              AND X.BCSUC <> 904
              and x.bccta <> 999999999 
              AND X.BCFECH = P_D_FECPRO
              and (x.bccta, x.bcoper) not in
                   (              
                   select cc.jaql478cta, cc.jaql478ope
                     from jaql478 cc                                                          
                    where cc.jaql478MOD = x.bcmod
                      and cc.jaql478EST = 'A'              
                      );        
      exception
      when others then
        ln_fonred := 0;
      end;  
      --obtenemos el fondeo de tesoreria 904
      begin        
       Select sum(xx.total)
         into ln_fontes
         from ( 
                 Select nvl(sum(d.bcsdmn),0) total
                   from jaqz195 a, jaqz195a b, fst198 c, fsh012 d
                  where a.jaqz195cod = b.jaqz195aco
                    and b.jaqz195aco = c.tp1nro2
                    and a.jaqz195est = 'S'
                    and b.jaqz195ain = 0
                    and c.tp1cod = 1
                    and c.tp1cod1 = 10825
                    and c.tp1corr1 = 88
                    and c.tp1corr2 = 2
                    and c.tp1nro1 = 2 --codigo de reporte
                    and d.BCEMP = 1
                    and d.BCMOD = 22
                    and (d.BCSUC = 904 
                         or 
                         (d.BCSUC = 11 and b.jaqz195act = 538187)
                        )
                    and b.jaqz195act = d.bccta
                    and d.BCFECH = P_D_FECPRO
                    union
                 Select nvl(sum(g.bcsdmn),0) total
                   from jaqz195 a, jaqz195a b, jaqz195c c, jaqz195d d, fst198 e, fsh012 g
                  where a.jaqz195cod = b.jaqz195aco
                    and b.jaqz195aco = e.tp1nro2
                    and trim(b.jaqz195act) = c.jaqz195cco
                    and c.jaqz195cco = d.jaqz195dco
                    and b.jaqz195ain = 1
                    and a.jaqz195est = 'S'
                    and c.jaqz195ces = 'S'
                    and e.tp1cod     = 1 
                    and e.tp1cod1    = 10825 
                    and e.tp1corr1   = 88 
                    and e.tp1corr2   = 2 
                    and e.tp1nro1    = 2  --codigo de reporte              
                    and g.BCEMP = 1
                      and g.BCMOD = 22
                      and (g.BCSUC = 904 
                           or 
                           (g.BCSUC = 11 and d.jaqz195dct = 538187)
                          )
                      and d.jaqz195dct = g.bccta
                      and g.BCFECH = P_D_FECPRO
              ) xx;                      
      exception
      when others then
        ln_fontes := 0;
      end;        
      --obtenemos el principal aportante, los 10 y los 20 primeros
      for i in c_aportantes loop
        ln_cont := ln_cont + 1;
        if ln_cont = 1 then
          ln_firapo := ln_firapo + i.saldo;
        End If;  
        if ln_cont <= 10 then
          ln_tenapo := ln_tenapo + i.saldo;
        End If;
        if ln_cont <= 20 then
          ln_tweapo := ln_tweapo + i.saldo;
        End If;
        if ln_cont > 20 then
          Exit;
        End If;                        
      end loop;
      --registramos los totales de fondeo y saldos de aportantes del día
      begin
           insert into jaqz198(jaqz198fec,
                               jaqz198hor,
                               jaqz198usr,
                               jaqz198sfr,
                               jaqz198sfs,
                               jaqz198sft,
                               jaqz198sfa,
                               jaqz198sta,
                               jaqz198swa,
                               jaqz198prf,
                               jaqz198pra
                               ) 
                         values(P_D_FECPRO,
                                to_char(sysdate,'HH24:mi:ss'),
                                P_C_CODUSU,
                                ln_fonred,
                                ln_fontes,
                                ln_fonred+ln_fontes,
                                ln_firapo,
                                ln_tenapo,
                                ln_tweapo,
                                0,
                                0
                               );
          commit;                               
      exception 
      when others then   
        null;
      end;            
      --obtenemos el número de días del mes del la fecha de proceso
      ln_numdia := to_number(to_char(LAST_DAY(P_D_FECPRO),'DD'));
      begin
           Select round(nvl(sum(a.jaqz198sft)/ln_numdia,0),2), 
                  round(nvl(sum(a.jaqz198sfa)/ln_numdia,0),2)
             into ln_profon,
                  ln_propri
             from jaqz198 a 
            where a.jaqz198fec between P_D_FECPRO - ln_numdia + 1 and P_D_FECPRO;        
      exception 
      when others then   
           ln_profon := 0;
           ln_propri := 0;
      end;
      --actualizamos los promedios
      update jaqz198 a 
         set a.jaqz198prf = ln_profon, 
             a.jaqz198pra = ln_propri
       where a.jaqz198fec = P_D_FECPRO;
       commit;
  exception
  when others then
    null;  
  end sp_ah_prom_sofi;                           
  procedure sp_ah_exonera(P_D_FECPRO IN DATE,
                          P_N_CODREP IN NUMBER,          
                          P_C_CODTIP IN VARCHAR2,           
                          P_C_CODUSU IN VARCHAR2           
                          ) is  
  cursor exonerados is     
    Select replace(trim(a.Tp1desc), 'X', '_') rubros
      from fst198 a
     where a.tp1cod   = 1
       and a.tp1cod1  = 10825
       and a.tp1corr1 = 88
       and a.tp1corr2 = 5
       and a.tp1nro1  = P_N_CODREP;
       
  cursor rubro(lv_codrub in varchar2) is     
    Select a.rubro
      from fsd014 a
     where a.rubro like lv_codrub;                                         
  begin
    delete from crdtcap x
     where x.c_descri  = TRIM(P_C_CODUSU)
       and x.c_descri1 = TRIM(P_C_CODTIP)
       and x.n_monto1  = P_N_CODREP
       and x.d_fecha   = P_D_FECPRO;
       commit;
    for i in exonerados loop
      for j in rubro(i.rubros) loop
        insert into crdtcap (c_descri,
                             c_descri1,
                             n_monto1,
                             d_fecha,
                             c_descri2
                             ) 
                      values(TRIM(P_C_CODUSU),
                             TRIM(P_C_CODTIP),
                             P_N_CODREP,
                             P_D_FECPRO,
                             j.rubro
                             );
      End loop;  
    End loop;  
    commit;
  end sp_ah_exonera;                          
end PQ_AH_REP_SOFI;
/

