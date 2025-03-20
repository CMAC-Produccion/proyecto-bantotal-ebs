create or replace force view v_aqpa722 as
select a.aqpa722id,
       /*decode(a.aqpa722numtar,
              b.Z0E478NRO,*/
              substr(a.aqpa722numtar, 0, 6) || '******' ||
              substr(a.aqpa722numtar, 13, 4)/*,
              a.aqpa722numtar)*/ aqpa722numtar,
       decode(b.z0e478thd,
              null,
              null,
              '****' ||
              substr(trim(b.z0e478thd), 5, length(trim(b.z0e478thd)) - 4)) z0e478thd,
       a.aqpa722imei,
       a.aqpa722modelo,
       a.aqpa722token,
       a.aqpa722fecreg,
       a.aqpa722horreg
  FROM AQPA722 a
  left outer join Z0E478 b
    on a.aqpa722numtar = b.Z0E478NRO;

