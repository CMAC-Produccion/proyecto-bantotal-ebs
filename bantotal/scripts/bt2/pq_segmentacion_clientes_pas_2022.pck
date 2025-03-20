create or replace package PQ_SEGMENTACION_CLIENTES_PAS_2022 is

  procedure sp_segmento(p_pgcod  in number,
                        p_Pepais in number,
                        p_Petdoc in number,
                        p_Pendoc in char,
                        p_codseg out number,
                        p_desseg out varchar2);

  procedure sp_posiciona_2022(vpgcod   number,
                              TDcd     number,
                              TDch     number,
                              TNcd     varchar2,
                              TNch     varchar2,
                              Hoy      date,
                              Tcbio    number,
                              Pbthread number);

  procedure sp_saldo_2022(vpgcod  number,
                          vScsuc  number,
                          vSccta  number,
                          vScmda  number,
                          vScpap  number,
                          vScoper number,
                          vScsbop number,
                          vSctope number,
                          vScmod  number,
                          vfecpro date,
                          vscsdo  out number);

end PQ_SEGMENTACION_CLIENTES_PAS_2022;
/

CREATE OR REPLACE package BODY PQ_SEGMENTACION_CLIENTES_PAS_2022 is

  ------------------------------------------------  

  procedure sp_segmento(p_pgcod  in number,
                        p_Pepais in number,
                        p_Petdoc in number,
                        p_Pendoc in char,
                        p_codseg out number,
                        p_desseg out varchar2) is
  
  begin
    select b.jaql750segm, upper(a.jaql748dseg)
      into p_codseg, p_desseg
      from jaql748 a, jaql750 b
     where a.jaql748segm = b.jaql750segm
       and b.jaql750pgco = p_pgcod
       and b.jaql750pais = p_Pepais
       and b.jaql750tdoc = p_Petdoc
       and b.jaql750ndoc = p_Pendoc
       and JAQL750ESTA = 'S';
  exception
    when no_data_found then
      p_codseg := 0;
      p_desseg := 'SIN CALIF';
  end;
  ---------------------------------------------------------
  procedure sp_posiciona_2022(vpgcod   number,
                              TDcd     number,
                              TDch     number,
                              TNcd     varchar2,
                              TNch     varchar2,
                              Hoy      date,
                              Tcbio    number,
                              Pbthread number) is
  
    vTNcd char(12) := TNcd;
    vTNch char(12) := TNch;
  
    cursor clientes is
    
      select *
        from fsd001
       Where Pepais >= 1
         and Pepais <= 999
         and Petdoc >= TDcd
         and Petdoc <= TDch
            -- and pendoc = '20498343814'
         and Pendoc >= decode(vTNcd, '0           ', Pendoc, vTNcd)
         and Pendoc <= decode(vTNch, '0           ', Pendoc, vTNch);
  
    cursor cuentas(v1pepais number, v1petdoc number, v1Pendoc char) is
      select Scsuc,
             Sccta,
             Scmda,
             Scpap,
             Scoper,
             Scsbop,
             Sctope,
             Scmod,
             scfval
        from fsd011 x, fsr008 y
       where x.pgcod = vpgcod
         and x.sccta = y.ctnro
         and y.Ttcod = 1
            --and y.cttfir = 'T'
         and x.scmod = 21
         and y.pepais = v1pepais
         and y.petdoc = v1petdoc
         and y.pendoc = v1pendoc
         and y.pgcod = vpgcod
         and (x.scstat <> 99 or (x.scstat = 99 and x.scfulm = Hoy))
         and scfval <= Hoy
      
      UNION
      
      select aosuc,
             aocta,
             aomda,
             aopap,
             aooper,
             aosbop,
             aotope,
             aomod,
             aofval
        from fsd010 x, fsr008 y
       where x.pgcod = vpgcod
         and x.aocta = y.ctnro
         and y.Ttcod = 1
            --and y.cttfir = 'T'
         and x.aomod = 22
         and y.pepais = v1pepais
         and y.petdoc = v1petdoc
         and y.pendoc = v1pendoc
         and (x.aostat <> 99 or (x.aostat = 99 and x.aofe99 = Hoy))
         and aofval <= Hoy;
  
    cursor sucursal is
      select sucurs from fst001 where pgcod = vpgcod;
  
    VPepais     fsd001.Pepais%type;
    VPetdoc     fsd001.Petdoc%type;
    VPendoc     fsd001.Pendoc%type;
    Vpetipo     fsd001.Petipo%type;
    VPefalt     fsd001.Pefalt%type;
    VJAQL56TIPE JAQL056.Jaql56tipe%type;
    Saldpf      number(17, 2);
    Salcts      number(17, 2);
    Salaho      number(17, 2);
    Salnac      number(17, 2);
    Salext      number(17, 2);
    Saltot      number(17, 2);
    Numcta      number(9);
  
    TYPE Array IS TABLE OF NUMBER;
    VAgencia Array := Array();
    age      number(3);
    Agesal   number;
  
    Scsdo   number(17, 2);
    error   varchar2(500);
    dscerr  varchar2(250);
    FecAnt  date;
    numdia  number;
    Vsucurs number(3);
    Agencia number(3);
    Salmay  number(17, 2);
    Salage  number(17, 2);
    Calcli  number(5);
    Desseg  varchar2(250);
    vfeval  date;
  
    numpro number := 0;
    --totcli number := 0;
  
  begin
  
    begin
      for i in clientes loop
        begin
        
          VPepais := i.Pepais;
          VPetdoc := i.Petdoc;
          VPendoc := i.Pendoc;
          Vpetipo := i.Petipo;
          VPefalt := i.Pefalt;
        
          If Vpetipo = 'F' then
            VJAQL56TIPE := 1;
          Else
            VJAQL56TIPE := 2;
          End If;
        
          Saldpf := 0;
          Salcts := 0;
          Salaho := 0;
          Saltot := 0;
          Numcta := 0;
          VAgencia.delete;
          VAgencia.EXTEND(999);
          numdia  := 0;
          numpro  := 0;
          FecAnt  := null;
          Calcli  := 0;
          Desseg  := 0;
          Agencia := 0;
          vfeval  := null;
        
          For j in cuentas(vpepais, vpetdoc, VPendoc) loop
            numpro := numpro + 1;
            begin
              sp_saldo_2022(vpgcod,
                            j.Scsuc,
                            j.Sccta,
                            j.Scmda,
                            j.Scpap,
                            j.Scoper,
                            j.Scsbop,
                            j.Sctope,
                            j.Scmod,
                            Hoy,
                            scsdo);
            
              If j.Scmda = 0 then
                Salnac := Scsdo;
                Salext := 0;
              Else
                Salnac := Scsdo * Tcbio;
                Salext := Scsdo;
              End If;
            
              case
                when j.Scmod = 22 then
                  Saldpf := Saldpf + Salnac;
                when j.Sctope = 2 then
                  SalCts := SalCts + Salnac;
                else
                  Salaho := Salaho + Salnac;
              end case;
            
              --por ver si se borra-------------------
              age := j.Scsuc;
            
              if VAgencia(age) is null then
                VAgencia(age) := 0;
              end if;
            
              VAgencia(age) := VAgencia(age) + Salnac;
              Agesal := VAgencia(age);
              -----------------------------------------
            exception
              when others then
                dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                          VPendoc || '-' || trim(to_char(j.sccta));
                dbms_output.put_line(dscerr);
            end;
          
            vfeval := j.scfval;
          
            If j.scmod = 22 and j.scsbop > 0 then
              begin
                select aofval
                  into vfeval
                  from fsd010 x
                 where x.pgcod = vpgcod
                   and aosuc = j.scsuc
                   and aocta = j.sccta
                   and aomda = j.scmda
                   and aopap = j.scpap
                   and aooper = j.scoper
                   and aotope = j.sctope
                   and aosbop = 0
                   and aomod = j.scmod;
              exception
                when others then
                  dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                            VPendoc || '-' || trim(to_char(j.sccta));
                  dbms_output.put_line(dscerr);
              end;
            end if;
          
            if fecant is null or fecant > vfeval then
              fecant := vfeval;
            end if;
          
          end loop;
        
          Saltot := Saldpf + Salcts + Salaho;
        
          Error := '';
        
          --fecha_antig_2022(vpgcod, vpepais, vpetdoc, vpendoc, hoy, fecant);
        
          numdia := Hoy - FecAnt;
        
          Salmay := 0;
        
          for b in sucursal loop
            VSucurs := b.Sucurs;
            If VAgencia(VSucurs) is not null then
              Salage := VAgencia(VSucurs);
              If Salage > Salmay then
                Salmay  := Salage;
                Agencia := VSucurs;
              End If;
            End If;
          end loop;
        
          --SACA SEGMENTACION
        
          begin
            select jaql749segm, jaql748dseg
              into calcli, desseg
              from (select a.jaql749segm, b.jaql748dseg
                      from jaql749 a, jaql748 b
                     where jaql749tipe = VJAQL56TIPE
                       and jaql749fvig <= hoy
                       and jaql749sald <= saltot
                       and jaql749anti <= numdia
                       and jaql749prod <= numpro
                       and a.jaql749segm = b.jaql748segm
                     order by JAQL749FVIG desc,
                              JAQL749SALD desc,
                              JAQL749ANTI desc,
                              JAQL749PROD desc)
             where rownum = 1;
          
          exception
            When no_data_found then
              Calcli := 0;
              Desseg := 'Sin Calificacion';
              Error  := Error ||
                        '-No se encontro clasificacion del cliente';
          end;
        
          begin
          
            update jaql750
               set jaql750esta = 'N'
             Where JAQL750PGCO = vPgcod
               and JAQL750PAIS = vPepais
               and JAQL750TDOC = vPetdoc
               and JAQL750NDOC = vPendoc
               and jaql750esta = 'S';
               
               commit;
          
            if sql%rowcount != 0 or Calcli <> 0 then
              --si antes tenía segment o si ahora tiene 
              begin
                insert into jaql750
                  (jaql750pgco,
                   jaql750pais,
                   jaql750tdoc,
                   jaql750ndoc,
                   jaql750fech,
                   jaql750hora,
                   jaql750saho,
                   jaql750sact,
                   jaql750sdpf,
                   jaql750posi,
                   jaql750fape,
                   jaql750anti,
                   jaql750nump,
                   jaql750sucu,
                   jaql750segm,
                   jaql750esta,
                   JAQL750AU01,
                   JAQL750AU02,
                   JAQL750AU04)
                values
                  (vPgcod,
                   vPepais,
                   vPetdoc,
                   vPendoc,
                   Hoy,
                   to_char(sysdate, 'HH24:mi:ss'),
                   Salaho,
                   Salcts,
                   Saldpf,
                   Saltot,
                   FecAnt,
                   numdia,
                   numpro,
                   Agencia,
                   Calcli,
                   'S',
                   Desseg,
                   substr(Error, 1, 50),
                   Pbthread);
              
                commit;
              
              exception
                when others then
                  dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                            VPendoc || '-' || 'insert';
                  dbms_output.put_line(dscerr);
                
                  commit;
              end;
            end if;
          end;
        /*
          totcli := totcli + 1;
          If totcli = 1 then
            commit;
            totcli := 0;
          End If;*/
        exception
          when others then
            dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                      VPendoc;
            dbms_output.put_line(dscerr);
        end;
      end loop;
    
    exception
      when others then
        dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                  VPendoc;
        dbms_output.put_line(dscerr);
    end;
    commit;
  end sp_posiciona_2022;

  ----------------------------------------

  procedure sp_saldo_2022(vpgcod  number,
                          vScsuc  number,
                          vSccta  number,
                          vScmda  number,
                          vScpap  number,
                          vScoper number,
                          vScsbop number,
                          vSctope number,
                          vScmod  number,
                          vfecpro date,
                          vscsdo  out number) is
  
    mes    varchar2(2);
    anio   varchar2(4);
    numtit number;
  
  begin
  
    mes  := to_char(vfecpro, 'mm');
    anio := to_char(vfecpro, 'rrrr');
  
    vscsdo := 0;
  
    begin
      select sum(nvl(monto, 0))
        into vscsdo
        from (select sum(Case
                           When mes = 1 then
                            HASD01
                           When mes = 2 then
                            HASD02
                           When mes = 3 then
                            HASD03
                           When mes = 4 then
                            HASD04
                           When mes = 5 then
                            HASD05
                           When mes = 6 then
                            HASD06
                           When mes = 7 then
                            HASD07
                           When mes = 8 then
                            HASD08
                           When mes = 9 then
                            HASD09
                           When mes = 10 then
                            HASD10
                           When mes = 11 then
                            HASD11
                           When mes = 12 then
                            HASD12
                           else
                            0
                         end) monto
                from fsh014
               where pgcod = vPgcod
                 and hasuc = vScsuc
                 and hamda = vScmda
                 and hapap = vScpap
                 and hacta = vSccta
                 and haoper = vScoper
                 and hatope = vSctope
                 and hasbop = vScsbop
                 and hamod = vScmod
                 and haanio = anio
              union all
              ---------------------------------------
              
              select sum(Case
                           When mes = 1 then
                            HASD01
                           When mes = 2 then
                            HASD02
                           When mes = 3 then
                            HASD03
                           When mes = 4 then
                            HASD04
                           When mes = 5 then
                            HASD05
                           When mes = 6 then
                            HASD06
                           When mes = 7 then
                            HASD07
                           When mes = 8 then
                            HASD08
                           When mes = 9 then
                            HASD09
                           When mes = 10 then
                            HASD10
                           When mes = 11 then
                            HASD11
                           When mes = 12 then
                            HASD12
                           else
                            0
                         end) monto
                from fsh014
               where pgcod = vPgcod
                 and hasuc = vScsuc
                 and hamda = vScmda
                 and hapap = vScpap
                 and hacta = vSccta
                 and haoper = vScoper
                 and hatope = 0
                 and hasbop = vScsbop
                 and hamod = 201 --vScmod
                 and haanio = anio);
    exception
      when others then
        vscsdo := 0;
    end;
  
    begin
      select count(f1.ctnro)
        into numtit
        from fsr008 f1
       where f1.ctnro = vSccta
         and f1.ttcod = 1;
    exception
      when others then
        numtit := 1;
    end;
  
    vscsdo := vscsdo / numtit;
  end;

----------------------------------------------------

end PQ_SEGMENTACION_CLIENTES_PAS_2022;
/

