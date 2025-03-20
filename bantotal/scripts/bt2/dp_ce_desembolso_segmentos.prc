CREATE OR REPLACE PROCEDURE dp_ce_desembolso_segmentos
 is
BEGIN 
  begin  
  execute immediate 'drop table desembolso_segmentos';
  exception
    when others then
      null; 
  end   ; 
  execute immediate 'create table  desembolso_segmentos(
              instancia number(20),
              tipo varchar2(1000),
              segcli varchar2(1000),
              estcred varchar2(20),
              pgcod number(3),hsucur number(3),hmodul number(3),hmda number(4),
              hpap number(4),hcta number(9),hoper number(9),hsubop number(3),
              htoper number(3),hfcon date,codsbs varchar2(10),pepais number(3),
              petdoc number(2),pendoc char(12),
              fecnac date,
              feccon date)';
             
end;
/

