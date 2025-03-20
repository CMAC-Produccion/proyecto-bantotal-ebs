create or replace package pq_cr_buro_hs is

  -- Author  : HSUAREZ
  -- Created : 14/01/2022 17:43:24
  -- Purpose : Paqute para los Buros, en este caso para identificar el buro

procedure sp_consultar_matriz(
                               sucursal int,
                               buro1 out int,
                               buro2 out int,
                               buro3 out int
                             );

end pq_cr_buro_hs;
/

create or replace package body pq_cr_buro_hs is

procedure sp_consultar_matriz(
                               sucursal int,
                               buro1 out int,
                               buro2 out int,
                               buro3 out int
                             )
                             is
begin
    buro1:=3;
    begin
      select  aqpb253cob1,aqpb253cob2,aqpb253cob3
        into  buro1,buro2,buro3
        from  aqpb253
       where  aqpb253est='S' 
         and  aqpb253codsuc = sucursal;
      exception when others then
        buro1:=1;
    end;
end;                             

end pq_cr_buro_hs;
/

