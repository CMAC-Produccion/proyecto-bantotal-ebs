create or replace package PQ_CR_RCCTRABAJADOR is
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS PRENDARIOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2015.11.12
  -- Autor de Creación          : HSUAREZ
  -- Uso                        : Realiza Calculos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Version                    : 2.0
  -- Fecha de Modificación      : 2019.05.03
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: sp_cr_llenar_Data se agregó insert para cargar informacion de trabajadores ca_alt_vs_empleados@erp.             
  --
  -- *****************************************************************
  -----------------------------------------------------------------------
  procedure sp_cr_registrorcc;
  procedure sp_cr_pasahistoricarcc;
  procedure sp_cr_llenardata(ldfechas date );
-----------------------------------------------------------------------
-------------------------------------------
end PQ_CR_RCCTRABAJADOR;
/

create or replace package body PQ_CR_RCCTRABAJADOR is
procedure sp_cr_registrorcc as
    ld_fecha date;
    Pc_flag char;
    ln_cont number;
    cursor Cabecera is
    select * from jaqz651 j; --where j.jaqz651fecc = ld_fecha;

    begin
        begin
            select TO_DATE(f.tpnro, 'DDMMRRRR')
              INTO ld_fecha
              from fst098 f
             where tpcod = 7647
               and tpcorr = 12;
             exception
            when no_data_found then
              ld_fecha := null;
        end;

        begin
          
              begin
                  select count(*)
                   into ln_cont
                    from jaqz652 b;
                  exception 
                      when no_data_found then
                    ln_cont := 0;
                  end;


            if ln_cont > 0 then
          
                PQ_CR_RCCTRABAJADOR.sp_cr_pasahistoricarcc;                
                execute immediate('Truncate table JAQZ652');
            END IF;
                PQ_CR_RCCTRABAJADOR.sp_cr_llenardata(ld_fecha);
              
       exception
                when others then null;
      end;
 

end sp_cr_registrorcc;
---------------------------------------------------------------------------------------------------------
procedure sp_cr_pasahistoricarcc as
  lc_coderr varchar2(100);
lc_msgerr varchar2(1000);
begin 

  begin

    INSERT INTO JAQZ653
      (jaqz653fecp,
       jaqz653fecc,
       jaqz653pai,
       jaqz653tdoc,
       jaqz653ndoc,
       jaqz653nomt,
       jaqz653est,
       jaqz653cal0,
       jaqz653cal1,
       jaqz653cal2,
       jaqz653cal3,
       jaqz653cal4
       
       )
      select jaqz652fecp,  --SYSDATE,
             jaqz652fecc,
             jaqz652pai,
             jaqz652tdoc,
             jaqz652ndoc,
             jaqz652nomt,
             'N',
             JAQZ652CAL0,
             JAQZ652CAL1,
             JAQZ652CAL2,
             JAQZ652CAL3,
             jaqz652cal4
        From JAQZ652;

    commit;
     exception when others then
      lc_coderr := sqlcode;
     lc_msgerr := sqlerrm;
 end;
end sp_cr_pasahistoricarcc;
---------------------------------------------------------------------
procedure sp_cr_llenardata(ldfechas date ) as
cursor data is 
             select SYSDATE,
             QZ51.jaqz651fecc,
             QZ51.jaqz651pai,
             QZ51.jaqz651tdoc,
             QZ51.jaqz651ndoc,
             QZ51.jaqz651nomt,
             'N',
             CI.n_calIf0,
             CI.n_calIf1,
             CI.n_calIf2,
             CI.n_calIf3,
             CI.n_calIf4
             From JAQZ651 QZ51
             inner join CLDRCCI CI
             on qz51.jaqz651ndoc = ci.c_docide
						 --se agrego el selec case para determinar el tipo de documento en caso de ser dni "21" se transforma a c_tdocid=1 caso contrario a c_tdocid=2 extranjero
						 and (ci.c_tdocid = ( select case a.jaqz651tdoc when 21 then 1 else 2 end from jaqz651 a where a.jaqz651ndoc=qz51.jaqz651ndoc))  
             where D_FECPRE = ldfechas 
             AND CI.C_TIPDET='Z'
             and c_person = '1';
             

lc_coderr varchar2(100);
lc_msgerr varchar2(1000);


begin
  

 --2019.05.03
 delete jaqz651;
 commit;

 --insertar en tabla de listado de trabajadores
  insert into jaqz651
  select distinct trunc(sysdate) Fecha, j.pepais, j.petdoc, trim(j.pendoc), h.penom
  from ca_alt_vs_empleados@erp f , fsr008 j, fsd001 h
   where 
   j.pgcod = 1
   and j.pepais = 604
   and j.petdoc = 21
   and j.pendoc =  rpad(f.Employee_num,12,' ')
   and h.pepais = j.pepais
   and h.petdoc = j.petdoc
   and h.pendoc = j.pendoc;
   commit;
 --2019.05.03

   for c in data  loop
     begin
        INSERT INTO JAQZ652
                    (jaqz652fecp,
                     jaqz652fecc,                     
                     jaqz652pai,
                     jaqz652tdoc,
                     jaqz652ndoc,
                     jaqz652nomt,
                     jaqz652est,
                     jaqz652cal0,
                     jaqz652cal1,
                     jaqz652cal2,
                     jaqz652cal3,
                     jaqz652cal4)
          values(
           c.sysdate,c.jaqz651fecc,c.jaqz651pai,c.jaqz651tdoc,c.jaqz651ndoc
           ,c.jaqz651nomt, 'N',c.n_calif0, c.n_calif1,c.n_calif2,c.n_calif3
           ,c.n_calif4);
   exception when others then
     lc_coderr := sqlcode;
     lc_msgerr := sqlerrm;
   end;        
 commit;

--lc_nomt :=c.jaqz651nomt;


  END LOOP;
end sp_cr_llenardata;
END PQ_CR_RCCTRABAJADOR;
/

