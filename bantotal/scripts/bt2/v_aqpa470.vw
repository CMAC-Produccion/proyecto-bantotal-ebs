create or replace force view v_aqpa470 as
select  aqpa470serie, aqpa470nro, aqpa470pgcod, aqpa470mod, aqpa470sucor, aqpa470tran, aqpa470rel, aqpa470con, aqpa470cord,
          aqpa470subo, aqpa470ind, aqpa470rubro, aqpa470ccos, aqpa470femi, aqpa470tcomf, aqpa470seri, aqpa470num, aqpa470tdocr, aqpa470nruc,
          aqpa470rasoc, aqpa470fdref, aqpa470mtotal, aqpa470mtimp, aqpa470mtinf, aqpa470impt, aqpa470mone, aqpa470tcam, aqpa470tcomp,
          aqpa470sdref, aqpa470ndref, aqpa470lest, aqpa470csuna, apaq470imdeb, apaq470imhab, aqpa470mbim, aqpa470prvit, aqpa470total, aqpa470vvuig,
          aqpa470vvun, aqpa470item, aqpa470desc, aqpa470corr, aqpa470flag
   from xxbol.aqpa470@ERP;

