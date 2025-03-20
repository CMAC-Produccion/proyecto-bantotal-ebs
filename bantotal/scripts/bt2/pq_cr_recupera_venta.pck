create or replace package pq_cr_recupera_venta is

  -- Author  : KVALENCIAC
  -- Created : 08/08/2018
  -- Purpose :   
  procedure sp_verificarubro (vn_JQY470CRUB number, vn_considerado out number);
  procedure sp_verificamontos (vn_JAQZ255ACODPER char, vn_JAQZ255ACODTRA number);
end pq_cr_recupera_venta;
/

create or replace package body pq_cr_recupera_venta is
procedure sp_verificarubro (vn_JQY470CRUB number, vn_considerado out number)
is
vc_JQY470CRUB varchar(16);

begin
vn_considerado := 0;
vc_JQY470CRUB := To_char(vn_JQY470CRUB);
vc_JQY470CRUB := concat(Replace(rTrim(Replace(vc_JQY470CRUB, '0', ' ')), ' ', 0),'%');
          begin
          select 1 into vn_considerado from FSR014 r
          inner join fst098 t on t.pgcod=1 
          and t.tpcod=7701 
          and t.tpcorr>700 
          and t.tpcorr<750 
          and t.TPNRO=r.rrcod
          where r.rrrubr like (vc_JQY470CRUB)
          and rownum =1;
          Exception
                 when no_data_found then
                      vn_considerado := 0;
          end;
end sp_verificarubro;

procedure sp_verificamontos (vn_JAQZ255ACODPER char, vn_JAQZ255ACODTRA number)
is 
cursor creditos is
 select *
   from jaqz255a a
   where a.jaqz255acodper = vn_JAQZ255ACODPER
   and a.jaqz255acodtra = vn_JAQZ255ACODTRA
   order by JAQZ255ACODPER, JAQZ255ACODTRA;

jaqz255atot number;
jaqz255atot_t number;
njaqz255etotCal number;
diferencia number;
existe number;
mensaje varchar(300);
begin
  begin
  delete jaqz255e where jaqz255ecodtra=vn_JAQZ255ACODTRA and jaqz255ecodper=vn_JAQZ255ACODPER;
  commit;
  For i in creditos loop
    njaqz255etotCal := i.jaqz255acap + i.jaqz255aint;
    Begin
    select 1 into existe from JAQY470c where JQY470CNRO = vn_JAQZ255ACODTRA 
    and JQY470CCTA = i.jaqz255acta
    and JQY470COPE = i.jaqz255acodope
    and rownum = 1;
    exception 
    when no_data_found then
        existe := 0;
    end;
    mensaje := '';
    if ( existe = 0 ) then      
      mensaje := '- No existe esta cuenta+operación.';
    end if;
    if i.jaqz255atot <> njaqz255etotCal then
      mensaje := mensaje || '- El monto total ingresado, no es igual al capital+interés ingresado.';
    end if;  
    if i.jaqz255atot <> njaqz255etotCal or existe = 0 then 
      diferencia := (i.jaqz255acap + i.jaqz255aint) - i.jaqz255atot;      
      mensaje := mensaje || ' - Cuenta:' || to_char(i.jaqz255acta) || ' Operación:' || to_char(i.jaqz255acodope);
      insert  into jaqz255e ( jaqz255ecodtra, jaqz255ecodper, jaqz255enomcli,jaqz255etipdoc,jaqz255enrodoc,
      jaqz255ecta,jaqz255ecodope,jaqz255emon,jaqz255ecap,jaqz255eint,jaqz255etot,jaqz255etotCal,jaqz255edif,jaqz255ecom,jaqz255eusr,jaqz255efecupd)
      values(i.jaqz255acodtra,i.jaqz255acodper,i.jaqz255anomcli,i.jaqz255atipdoc,i.jaqz255anrodoc,i.jaqz255acta,
      i.jaqz255acodope,i.jaqz255amon, i.jaqz255acap, i.jaqz255aint, i.jaqz255atot,njaqz255etotCal, diferencia,mensaje,i.jaqz255ausr, sysdate());
      commit; 
    end if;
   end loop;
end;
end sp_verificamontos;
end pq_cr_recupera_venta;
/

