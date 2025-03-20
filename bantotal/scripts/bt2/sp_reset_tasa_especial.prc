create or replace procedure SP_RESET_TASA_ESPECIAL(vpgcod  number,
                                                   vScsuc  number,
                                                   vsccta  number,
                                                   vScmda  number,
                                                   vScpap  number,
                                                   vScoper number,
                                                   vScsbop number,
                                                   vSctope number,
                                                   vScmod  number,
                                                   vfecpro date,
                                                   vtasa   in out number) is

  tasa     number;
  petipo   char(1);
  tipo     number(9);
  ctifin   char(1);
  vTasfinv number;

begin

  update fsd427 a
     set TASVIG = 'N'
   where tasemp = vpgcod
     and tasmod = vscmod
     and tascta = vsccta
     and tassop = vScsbop
     and tasmda = vScmda
     and taspap = vscpap
     and TASVIG = 'S';

  pq_segmentacion_clientes_pas.sp_tasa(vpgcod,
                                       vScsuc,
                                       vsccta,
                                       vScmda,
                                       vScpap,
                                       vScoper,
                                       vScsbop,
                                       vSctope,
                                       vScmod,
                                       tasa);

  if vtasa <> 0 then
  
    if tasa <> vtasa then
    
      begin
        select ctifin into ctifin from fsd008 where ctnro = vsccta;
      exception
        when no_data_found then
          ctifin := 'N';
      end;
    
      begin
        select b.petipo
          into petipo
          from fsr008 a, fsd001 b
         where a.pepais = b.pepais
           and a.petdoc = b.petdoc
           and a.pendoc = b.pendoc
           and a.ctnro = vsccta
           and a.ttcod = 1
           and a.cttfir = 'T';
      exception
        when no_data_found then
          petipo := 'F';
      end;
    
      select totpiz
        into tipo
        from fst004
       where modulo = vScmod
         and toeleg = 'S'
         and totope = vsctope;
    
      if petipo = 'J' then
        If ctifin = 'S' then
          If vsctope = 3 then
            tipo := 97;
          Else
            tipo := 96;
          End if;
        Else
          begin
            select ModCodn
              into tipo
              from FST100 -- ModCodN
             Where ModTcli = 2
               and ModSuc = 0
               and ModCod = tipo;
          exception
            when no_data_found then
              null;
          end;
        end if;
      end if;
    
      vTasfinv := 99999999 - to_number(to_char(vfecpro, 'yyyy')) * 10000 +
                  to_number(to_char(vFecpro, 'mm')) * 100 +
                  to_number(to_char(vFecpro, 'dd'));
    
      insert into fsd427
      values
        (vpgcod,
         vScmod,
         Tipo,
         vSccta,
         vScsbop,
         vScmda,
         vScpap,
         vFecpro,
         99999999999,
         1,
         vTasfinv,
         'S');
    
      insert into fsr427
      values
        (vpgcod,
         vScmod,
         Tipo,
         vSccta,
         vScsbop,
         vScmda,
         vScpap,
         vFecpro,
         99999999999,
         9999,
         vtasa);
    end if;
  
  else
    vtasa := tasa;
  end if;

end SP_RESET_TASA_ESPECIAL;
/

