create or replace package pq_cr_rep_control is

  -- Author : KVALENCIAC
  -- Created : 16/11/2020 
  -- Proyecto : Devuelve los controles de créditos reprogramdos NOVACIÓN - Exoneracion de capitalización.
  -- Public type declarations
  ---MOdificado: Karen Valencia 
  --FechaModificación: 07/12/2020  - 09/12/2020
  --MOdificación: Se modificó par aque busque desde las tablas de CMR
  ---MOdificado: Karen Valencia 
  --FechaModificación: 17/12/2020 
  --MOdificación: Se modificó para que busque si es novación para casos que ya estaban proc  
  ---
   procedure sp_control (vd_Pgfape in date, 
                           vn_instancia in number, 
                          vn_montominimo out number,                           
                          vn_existe out number);
  procedure sp_control2 (vn_Ppgcod in number, 
                        vn_Pitsuc in number, 
                        vn_Pitmod in number, 
                        vn_PIttran in number, 
                        vn_Pitnrel in number, 
                        vn_Pitord in number, 
                        vn_Pitsbor in number,  
                        rpta out number);
 procedure sp_control3 (vd_Pgfape in date, 
                           vn_instancia in number,                                                    
                          rpta out number);                        
end pq_cr_rep_control;
/

create or replace package body pq_cr_rep_control is

  procedure sp_control (vd_Pgfape in date, 
                          vn_instancia in number,                            
                          vn_montominimo out number,                           
                          vn_existe out number
                          )
  is  
  ln_Fecha date;--la máxima fecha de la tabla , es la último cargada
  ln_esnovacion number(1);
  
 begin
 vn_montominimo := 0 ;
 vn_existe :=0;
 ln_esnovacion := 0;
 begin   --se comento poro cambios 07/12/2020  -- se volivó a descomentar el 17/12/2020
   select max(AQPA842FECUPD) into ln_Fecha
   from AQPA842;
 exception
      when no_data_found then
              ln_Fecha := null;
 end;
  begin          
    select 1 into ln_esnovacion from sng001 
    where sng001inst=vn_instancia 
      and sng014cod=5;
  exception
    when no_data_found then
      ln_esnovacion:= 0;
  end;
   if ( ln_esnovacion = 1  )then
        
        --07/12/2020 se modificó para que busque desde el CMR
       begin
         select count(*) into vn_existe
          FROM LEY31050 L
          INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
          inner join xwf700 x  on x.xwfempresa = F.EMPRESA and  x.xwfcuenta = SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)
          and  x.xwfprcins = vn_instancia and x.xwfcar3 = '1'
          where  L.ESTADOSOLICITUD in ( 'BT' ,'AP' )  --  kdvc 29/12/2020
                AND L.TIPOFACILIDAD = 'CAJA'
                AND F.FACILIDAD like 'Exoneraci%'; -- revisar si es este texto // esto es NOvación pero cambió de nombre 
        Exception
          when no_data_found then
            vn_existe:=0;
        end;
        ---fin 07/12/2020 se modificó para que busque desde el CMR 
        if (vn_existe=0) then  --17/12/2020
          begin  --se comentó por cambios  07/12/2020  //se volvió a descomentar el 17/12/2020
          select count(*) into vn_existe
          from AQPA842 a
          inner join XWF700 x 
                on x.xwfempresa = a.aqpa842emp  
               --and x.xwfmodulo =  a.aqpa842mod
              -- and x.xwfsucursal= a.aqpa842suc
               --and x.xwfmoneda =  a.aqpa842mda
              -- and x.xwfpapel =   a.aqpa842pap 
               and x.xwfcuenta =    a.aqpa842cta   
              -- and x.xwfoperacion= a.aqpa842ope
              -- and x.xwfsubope =   a.aqpa842sbo
              -- and x.xwftipope =   a.aqpa842top
               and x.xwfprcins = vn_instancia
               and x.xwfcar3 = '1'               
           where
               a.aqpa842fecupd = ln_Fecha;
          Exception
               when no_data_found then
                 vn_existe := 0;
          End;
        end if;--17/12/2020                     
     end if; 
     if (vn_existe >1)then
       vn_existe:=1;
     end if;            
 end sp_control;
 procedure sp_control2(vn_Ppgcod in number, vn_Pitsuc in number, vn_Pitmod in number, vn_PIttran in number, vn_Pitnrel in number, vn_Pitord in number, vn_Pitsbor in number,  rpta out number)
  is
  ln_pgc number(3);
  ln_mod number(4);
  ln_suc number(3);
  ln_mda number(4);
  ln_pap number(4);
  ln_cta number(9);
  ln_ope number(9);
  ln_sbo number(3);
  ln_tpo number(3);
  ln_instancia number(10);
  ld_pgfape date;
  ln_Fecha date;--la máxima fecha de la tabla , es la última cargadas
  ln_esnovacion number(1);
begin
  rpta := 0;
  ln_esnovacion :=0;
  Begin
      select 
          pgcod,modulo,itsucd,moneda,papel,ctnro,itoper,itsubo,ittope into 
          ln_pgc,
          ln_mod,
          ln_suc,
          ln_mda,
          ln_pap,
          ln_cta,
          ln_ope,
          ln_sbo,
          ln_tpo
        from fsd016
       where pgcod = vn_Ppgcod
         and itsuc = vn_Pitsuc
         and itmod = vn_Pitmod
         and ittran = vn_PIttran
         and itnrel = vn_Pitnrel         
         and itord = vn_Pitord;
      Exception
         when no_data_found then
          ln_cta:=0;
          ln_ope:=0;
   end;
   if ( ln_cta<> 0 ) then
     --07/12/2020 se modificó para que busque desde el CMR
     begin
       select 1 into  rpta 
        FROM LEY31050 L
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1) = ln_cta
        AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = ln_ope                               
        AND F.EMPRESA = ln_pgc
        AND F.SUCURSAL = ln_suc
        ANd F.MODULO = ln_mod
        AND F.MONEDA = ln_mda
        AND F.PAPEL = ln_pap
        AND F.SUBOPERACION = ln_sbo
        AND F.TIPOOPERACION = ln_tpo
        AND L.ESTADOSOLICITUD = 'BT' 
        AND L.TIPOFACILIDAD = 'CAJA'
        AND F.FACILIDAD like 'Exoneraci%'; -- revisar si es este texto // esto es NOvación pero cambió de nombre
      Exception
        when no_data_found then
          rpta:=0;
      end;
      ---fin 07/12/2020 se modificó para que busque desde el CMR         
    if ( rpta = 0 ) then --inicio 17/12/2020 
     begin 
         select max(AQPA842FECUPD) into ln_Fecha
         from AQPA842;
       exception
            when no_data_found then
                    ln_Fecha := null;
      end;
     begin
      select 1 into  rpta from AQPA842  
      where AQPA842EMP = ln_pgc  
               and aqpa842mod = ln_mod
               and aqpa842suc = ln_suc
               and aqpa842mda = ln_mda
               and aqpa842pap = ln_pap
               and aqpa842cta = ln_cta  
               and aqpa842ope = ln_ope
               and aqpa842sbo = ln_sbo
               and aqpa842top = ln_tpo
               and aqpa842fecupd = ln_Fecha;
      Exception
         when no_data_found then
          rpta:=0;
      end;                         
    end if;--fin 17/12/2020 
      
   End if ;
 end sp_control2;
 ---Se adicionó sp_control3 09/12/2020 para que busque  si es cre¿ridot reprogramado caja novación/Exoneracion Capitalizacion
 procedure sp_control3 (vd_Pgfape in date, 
                          vn_instancia in number,                                                                             
                          rpta out number
                          )
  is  

  ln_esnovacion number(1);
  ln_pgc number(3);
  ln_mod number(4);
  ln_suc number(3);
  ln_mda number(4);
  ln_pap number(4);
  ln_cta number(9);
  ln_ope number(9);
  ln_sbo number(3);
  ln_tpo number(3);
  
 begin

 rpta :=0;
 ln_esnovacion := 0;
 
  begin          
    select 1 into ln_esnovacion from sng001 
    where sng001inst=vn_instancia 
      and sng014cod=5;
  exception
    when no_data_found then
      ln_esnovacion:= 0;
  end;
   if ( ln_esnovacion = 1  )then  
       begin
         select jaqy800pgcd ,
                jaqy800suc,
                jaqy800mod,
                jaqy800mda,
                jaqy800pap,
                jaqy800cta,
                jaqy800ope,
                jaqy800sbop,
                jaqy800tope
                into 
                ln_pgc, 
                ln_suc, 
                ln_mod,
                ln_mda, 
                ln_pap, 
                ln_cta, 
                ln_ope, 
                ln_sbo, 
                ln_tpo                  
         from JAQY800
         where jaqy800ins = vn_instancia
          and jaqy800vinc = 'S'  --  kdvc 29/12/2020
          and rownum = 1;  --  kdvc 29/12/2020
         Exception
           when no_data_found then
             ln_cta:=0;
       end;      
       begin
        select 1 into  rpta 
        FROM LEY31050 L
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1) = ln_cta
        AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = ln_ope                               
        AND F.EMPRESA = ln_pgc
        AND F.SUCURSAL = ln_suc
        ANd F.MODULO = ln_mod
        AND F.MONEDA = ln_mda
        AND F.PAPEL = ln_pap
       -- AND F.SUBOPERACION = ln_sbo
        AND F.TIPOOPERACION = ln_tpo
        AND L.ESTADOSOLICITUD = 'BT' 
        AND L.TIPOFACILIDAD = 'CAJA'
        AND F.FACILIDAD like 'Exoneraci%'; -- revisar si es este texto // esto es NOvación pero cambió de nombre
      Exception
        when no_data_found then
          rpta:=0;
      end;
        ---fin 07/12/2020 se modificó para que busque desde el CMR     
     end if; 
     if rpta = 0 then --- inicio 17/12/2020  sino lo encuentra en las tablas e CRM busca en esta opción 
       begin
         select 1 into  rpta 
            FROM v_reprog L, xwf700 a  -- bantprod.
          Where  L.ESTADOSOLICITUD = 'BT'
             and a.xwfprcins = vn_instancia--@instancia
             AND SUBSTR(L.CUENTAOPERACION, 0, INSTR(L.CUENTAOPERACION, '-') - 1) = a.xwfcuenta
             AND SUBSTR(L.CUENTAOPERACION, INSTR(L.CUENTAOPERACION, '-') + 1, 99) = a.xwfoperacion
             and a.xwfcar3 <> '1'
             and rownum = 1;
       Exception
        when no_data_found then
          rpta:=0;
      end;
     end if;--- fin 17/12/2020
             
 end sp_control3;
end pq_cr_rep_control;
/

