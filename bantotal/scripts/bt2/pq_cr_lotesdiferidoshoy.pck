create or replace package PQ_CR_LotesDiferidosHoy is

  -- Author  : MPOSTIGOC
  -- Created : 18/11/2015 06:03:10 p.m.
  -- Purpose : 
  
 procedure sp_cr_lotesdifehoy(Fecpro in DATE/*,
                              CUENTA out number,
                              OPERACION out number,
                              SUCURSAL out number,
                              modulo out number,
                              moneda out number,
                              TipoOper out number*/);
 -----------------------------------------------------------
 
procedure sp_cr_datos(SUCURSAL in number,
                          moneda in number,  
                          CUENTA in number, 
                          OPERACION in number, 
                          TipoOper in number/*,
                          cod_sorfy out character,
                          Nom_Cliente out varchar2,
                          nom_suc out varchar2*/);
-----------------------------------------------------------------
procedure sp_cr_carga(fecha in DATE);                       

end PQ_CR_LotesDiferidosHoy;
/

create or replace package body PQ_CR_LotesDiferidosHoy is

 procedure sp_cr_lotesdifehoy(Fecpro in DATE) is


  
  LOTE NUMBER;
  ESTADO NUMBER;
 

--begin
  cursor  inserta is   
  select f.pp174cod LOTE,
         g.pp182cod ESTADO,
         f.pp175cta CUENTA,
         f.pp175oper OPERACION,
         f.pp175suc SUCURSAL,
         f.pp175mod modulo,
         f.pp175mda moneda,
         f.pp175tope TipoOper,
         g.pp183fec FechaEstado,
         d.aofe99 FechCanc
       from fpp175 f
   inner join fpp183 g on f.pp174cod = g.pp174cod
   inner join fsd010 d on f.pp175pgcod = d.pgcod                       
                      and f.pp175mod = d.aomod
                      and f.pp175suc = d.aosuc
                      and f.pp175mda = d.aomda
                      and f.pp175pap = d.aopap
                      and f.pp175cta = d.aocta
                      and f.pp175oper = d.aooper
                      and f.pp175sbop = d.aosbop
                      and f.pp175tope = d.aotope
   where f.pp175tco = 'S'
     and g.pp182cod in (3, 7)
     and g.pp183fec = Fecpro--to_date(FechaInicio, 'yyyymmdd')
     and d.aostat = 99
     and d.aofe99 <> to_date('01/01/0001','dd/mm/yyyy')
     and g.pp182cod =
         (Select max(pp182cod) from fpp183 where pp174cod = f.pp174cod)
     and (g.pp183fec - d.aofe99) between 30 and 35
     and f.pp175suc = d.aosuc
     and f.pp175mda = d.aomda
     and f.pp175pap = d.aopap
     and f.pp175cta = d.aocta
     and f.pp175oper = d.aooper
     and f.pp175sbop = d.aosbop;
   
   
ln_corr number:=1;
begin
execute immediate ('truncate table jaqy127');
COMMIT;

for i in inserta/*(PN_TIPCam,PD_FINICIO,PD_FFIN)*/ loop
 insert into jaqy127(jaqy127corr,jaqy127lote,jaqy127est,jaqy127cta,jaqy127ope,jaqy127suc,jaqy127mod,jaqy127mda,jaqy127top,jaqy127fech,jaqy127fechcan)
  values(ln_corr,i.LOTE,i.estado,i.cuenta,i.operacion,i.sucursal,i.modulo,i.moneda,i.tipooper,i.FechaEstado,i.fechcanc);

ln_corr := ln_corr +1;
COMMIT;
end loop;

end sp_cr_lotesdifehoy;


---------------------------------------------------

procedure sp_cr_datos(SUCURSAL in number,
                          moneda in number,  
                          CUENTA in number, 
                          OPERACION in number, 
                          TipoOper in number/*,
                          cod_sorfy out character,
                          Nom_Cliente out varchar2,
                          nom_suc out varchar2*/) is

cod_sorfy character(17);
Nom_Cliente varchar2(100);
nom_suc varchar2(50);


BEGIN
  Select BNJ096SOR -- Extrae codigo Sorfy
    into cod_sorfy
    from bnj096 b
  
   where b.bnj096suc = SUCURSAL
     and b.bnj096mda = moneda
     and b.bnj096pap = 0
     and b.bnj096cta = CUENTA
     and b.bnj096ope = OPERACION
     and b.bnj096top = TipoOper;
exception
  when others then
    NULL;
  
    BEGIN
      -- nombre del cliente
    
      select ctnom --Nom_Cliente
        into Nom_Cliente
        from fsd008 d
       where d.pgcod = 1
         and d.ctnro = CUENTA;
    exception
      when others then
        NULL;
    end;
    
    Begin
      --Nombre sucursal
    
      select f.scnom --nom_suc
        into nom_suc
        from fst001 f
       where f.pgcod = 1
         and f.sucurs = SUCURSAL;
    exception
      when others then
        NULL;
      
    end;
    
    
    begin 
    
  update jaqy127 j set j.jaqy127equi=cod_sorfy,
                         j.jaqy127clie = Nom_Cliente,
                         j.jaqy127nomsuc = nom_suc
                 where j.jaqy127cta=CUENTA
                 and j.jaqy127ope =OPERACION
                 and j.jaqy127suc =  SUCURSAL;
  end;
end sp_cr_datos;


------------

procedure sp_cr_carga(fecha in DATE) is


--fechavalor varchar2(10);
--cuenta number;
--operacion number;
--sucursal number;
--modulo number;
--moneda number;
--tipoope number;
--codsorfy character(17);
--nombre varchar2(100);
--sucurs varchar2(50);
--fecha date;


cursor diferidos is

select j.jaqy127cta, j.jaqy127ope, j.jaqy127suc, j.jaqy127mda, j.jaqy127top
  from jaqy127 j;

begin

PQ_CR_LotesDiferidosHoy.sp_cr_lotesdifehoy(fecha/*,
                                           cuenta,
                                           operacion,
                                           sucurs,
                                           modulo,
                                           moneda ,
                                           tipoope*/);

--end;

begin

for i in diferidos loop
PQ_CR_LotesDiferidosHoy.sp_cr_datos(SUCURSAL =>i.jaqy127suc,
                                    moneda =>i.jaqy127mda,
                                    CUENTA => i.jaqy127cta,
                                    OPERACION =>i.jaqy127ope,
                                    TipoOper =>i.jaqy127top/*,
                                    cod_sorfy =>codsorfy,
                                    Nom_Cliente =>nombre,
                                    nom_suc => sucurs*/);
 commit;
 end loop;
end;

end sp_cr_carga;

---------------------------------
end PQ_CR_LotesDiferidosHoy;
/

