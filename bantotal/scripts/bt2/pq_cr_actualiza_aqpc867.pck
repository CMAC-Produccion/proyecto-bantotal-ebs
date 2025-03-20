create or replace package PQ_CR_ACTUALIZA_AQPC867 is
  -- *****************************************************************
  -- Nombre                       : PQ_CR_ACTUALIZA_AQPC867
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 14/06/2024
  -- Autor de Creación            : DCASTRO
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : Procedimiento actualiza AQPC867
  -- *****************************************************************

  Procedure sp_Cr_ACTUALIZA(
                      Pgcod in number,
                      Scmod in number,
                      Scsuc in number,
                      Scmda in number,
                      Scpap in number,
                      Sccta in number,
                      Scoper in number,
                      Scsbop in number,
                      Sctope in number, 
                      Capital in number, 
                      Interes in number, 
                      Mora in number, 
                      GasOtr in number, 
                      ICV in number, 
                      Penalidad in number,
                      CuoSeg in number, 
                      SalBBP in number, 
                      IntBBP in number, 
                      SalPBP in number, 
                      IntPBP in number, 
                      SalBMS in number, 
                      IntBMS in number, 
                      SalBFH in number,
                      IntBFH in number,
                      Fecape in date
                      );

--------------------------------------
Procedure sp_cr_carga_data;
                                
end PQ_CR_ACTUALIZA_AQPC867;
/

create or replace package body PQ_CR_ACTUALIZA_AQPC867 is


Procedure sp_Cr_ACTUALIZA(
                      Pgcod in number,
                      Scmod in number,
                      Scsuc in number,
                      Scmda in number,
                      Scpap in number,
                      Sccta in number,
                      Scoper in number,
                      Scsbop in number,
                      Sctope in number, 
                      Capital in number, 
                      Interes in number, 
                      Mora in number, 
                      GasOtr in number, 
                      ICV in number, 
                      Penalidad in number,
                      CuoSeg in number, 
                      SalBBP in number, 
                      IntBBP in number, 
                      SalPBP in number, 
                      IntPBP in number, 
                      SalBMS in number, 
                      IntBMS in number, 
                      SalBFH in number,
                      IntBFH in number,
                      Fecape in date                      
                      )is

  -- *****************************************************************
  -- Nombre                       : sp_Cr_ACTUALIZA
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 14/06/2024
  -- Autor de Creación            : DCASTRO
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : Procedimiento actualiza AQPC867
  -- *****************************************************************


TotalMora number(17,2);  
                    
    
begin
   
      TotalMora := nvl(Capital,0) + nvl(Interes,0) + nvl(Mora,0) + nvl(ICV,0) + 
      nvl(Penalidad,0) + nvl(CuoSeg,0)  + nvl(SalBBP,0) + nvl(IntBBP,0) + 
      nvl(SalPBP,0) + nvl(IntPBP,0) + nvl(SalBMS,0) + nvl(IntBMS,0) + nvl(SalBFH,0)+ nvl(IntBFH,0) ;

       begin
            update AQPC867
              set
              AQPC867CAP  = nvl(Capital,0),
              AQPC867INT  = nvl(Interes,0),
              AQPC867MORA = nvl(Mora,0),
              AQPC867SEGS = nvl(CuoSeg,0),
              AQPC867ICV  = nvl(ICV,0),
              AQPC867PENA = nvl(Penalidad,0),
              AQPC867DTOT = nvl(TotalMora,0)/*,
              aqpc867otro = nvl(Capital,0)*/
            where
                  AQPC867PGCOD = Pgcod 
              and AQPC867MOD   = Scmod 
              and AQPC867SUC   = Scsuc 
              and AQPC867MDA   = Scmda 
              and AQPC867PAP   = Scpap 
              and AQPC867CTA   = Sccta 
              and AQPC867OPER  = Scoper
              and AQPC867SBOP  = Scsbop
              and AQPC867TOPE  = Sctope
              and AQPC867FEC   = Fecape;
              commit;
      
      exception when others then
              null;
      end;                

                 
exception 
  when others then 
     NULL;
end sp_Cr_ACTUALIZA;

--------------------------------------
Procedure sp_cr_carga_data is
  -- *****************************************************************
  -- Nombre                       : sp_cr_carga_data
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 14/06/2024
  -- Autor de Creación            : DCASTRO
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : Carga cartera vigente de JAQL964 en AQPC867
  -- *****************************************************************

cursor listado is
select * from AQPC867 ;

ln_saldo number := 0;

BEGIN
  
       --insertar creditos vigentes de tabla jaql964
       insert into AQPC867
        (AQPC867PGCOD, AQPC867MOD, AQPC867SUC, AQPC867MDA, AQPC867PAP, AQPC867CTA, AQPC867OPER, AQPC867SBOP, AQPC867TOPE, AQPC867FEC)
        select jaql964pgcod  ,jaql964mod, jaql964suc, jaql964mda, jaql964pap, jaql964cta , jaql964ope, jaql964sob , jaql964top, trunc(sysdate)      
        from jaql964 where jaql964mod not in (117,200,33,108);
       commit; 


       ---actualizar saldo capital de FSD011
       for i in listado loop
           begin
                select f.scsdo
                  into ln_saldo
                  from fsd011 f
                 where f.pgcod = i.AQPC867PGCOD
                   and f.scsuc = i.AQPC867SUC
                   and f.scmda = i.AQPC867MDA
                   and f.scpap = i.AQPC867PAP
                   and f.sccta = i.AQPC867CTA
                   and f.scoper = i.AQPC867OPER
                   and f.scsbop = i.AQPC867SBOP
                   and f.sctope = i.AQPC867TOPE
                   and f.scmod =  i.AQPC867MOD;
           exception when others then
             ln_saldo := 0;
           end;
           
           update AQPC867 a
              set AQPC867SACACR = ln_saldo * -1
            where a.AQPC867CTA  =  i.AQPC867CTA
              and a.AQPC867OPER =  i.AQPC867OPER ;
            commit;  
       end loop;


end sp_cr_carga_data;

end PQ_CR_ACTUALIZA_AQPC867;
/

