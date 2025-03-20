create or replace procedure SP_CR_GARANTIAVIGENTE(P_SUCURSAL in NUMBER,
                                                  P_USUARIO in VARCHAR2) is
ubuser1 character(12);                                                  
begin
  ubuser1 := P_USUARIO;
  --delete from JAQZ555 where jaqz555usr = UBUSER1; 15092023
  --commit;
 
  INSERT INTO JAQZ555(jaqz555corr,
                      jaqz555cod1,
                      jaqz555suc,
                      jaqz555mda,
                      jaqz555pap,
                      jaqz555cta,
                      jaqz555ope,
                      jaqz555sbo,
                      jaqz555top,
                      jaqz555mod,
                      jaqz555ncre,
                      jaqz555fval,
                      jaqz555fcon,
                      jaqz555sald,
                      jaqz555est,
                      jaqz555oga,
                      jaqz555fgar,
                      jaqz555impg,
                      jaqz555ctag,
                      jaqz555estc,
                      jaqz555feci,
                      jaqz555tit,
                      jaqz555tic,
                      jaqz555reg,
                      jaqz555age,
                      jaqz555par,
                      jaqz555doc,
                      jaqz555tdoc,
                      jaqz555tgar,
                      jaqz555dmda,
                      jaqz555usr,
                      jaqz555au7,
                      jaqz555au1,
                      jaqz555au2,
                      jaqz555au4,
                      jaqz555mdag,
                      jaqz555dmdag,
                      jaqz555fees,
                      jaqz555tasi)
    with DATA as                      
    (select a.pgcod jaqz555cod1,
           a.scsuc jaqz555suc,
           a.scmda jaqz555mda,
           a.scpap jaqz555pap,
           a.sccta jaqz555cta,
           a.scoper jaqz555ope,
           a.scsbop jaqz555sbo,
           a.sctope jaqz555top,
           a.scmod jaqz555mod,
           (lpad(trim(to_char(a.sccta)),9,'0') || lpad(trim(to_char(a.scmod)),3,'0') || lpad(trim(to_char(a.scmda)),3,'0') || lpad(trim(to_char(a.scoper)),9,'0') || lpad(trim(to_char(a.sctope)),3,'0')) jaqz555ncre,                       
           a.scfval jaqz555fval,
           a.scfcon jaqz555fcon,
           a.scsdo jaqz555sald,
           a.scstat jaqz555est,
           y.sng122oper jaqz555oga,           
           (select t.scfval
              from fsd011 t
             where t.pgcod = 1
               and t.scsuc = y.sng122suc
               and t.scmda = y.sng122mda
               and t.scpap = y.sng122pap
               and t.sccta = y.sng122cta
               and t.scoper = y.sng122oper
               and t.scsbop = y.sng122sbop
               and t.sctope = y.sng122tope
               and t.scmod = 70
               and t.scstat <> 99) jaqz555fgar,                       
           (select t.scsdo
              from fsd011 t
             where t.pgcod = 1
               and t.scsuc = y.sng122suc
               and t.scmda = y.sng122mda
               and t.scpap = y.sng122pap
               and t.sccta = y.sng122cta
               and t.scoper = y.sng122oper
               and t.scsbop = y.sng122sbop
               and t.sctope = y.sng122tope
               and t.scmod = 70
               and t.scstat <> 99) jaqz555impg,
           (select t.ctnom from fsd008 t where t.pgcod = 1 and t.ctnro = y.sng122cta) jaqz555ctag,
           (select c.cenom from fst026 c where cecod = a.scstat) jaqz555estc,
           (select min(b.aofval)
              from fsd010 b
             where b.pgcod = 1
               and a.scmod = b.aomod
               and a.sccta = b.aocta
               and a.scoper = b.aooper
               and a.scsuc = b.aosuc) jaqz555feci,
           (select t.ctnom from fsd008 t where t.pgcod = 1 and t.ctnro = a.sccta) jaqz555tit,
           (select k.mdnom from fst003 k where k.modulo = a.scmod) jaqz555tic,         
           (select regnom from fst810 f1,fst811 f2
             where f2.pgcod = 1 and f2.oficod = P_SUCURSAL and f1.regcod = f2.regcod and f1.regcod < 100 ) jaqz555reg,
           (select scnom from fst001 where pgcod = 1 and sucurs = P_SUCURSAL) jaqz555age,           
           (select TRIM(ppg001dato) 
              from ppg001 
             where ppg001cod = 1
               and ppg001mod = 470
               and ppg001suc = y.sng122suc
               and ppg001mda = y.sng122mda
               and ppg001pap = y.sng122pap
               and ppg001cta = y.sng122cta
               and ppg001ope = y.sng122oper
               and ppg001sbo = y.sng122sbop
               and ppg001top = y.sng122tope
               and ppg001cdat = 129
               and ppg001frm = FN_MAX_FORM_PPG000(1,470,y.sng122suc,y.sng122mda,y.sng122pap,y.sng122cta,y.sng122oper,y.sng122sbop,y.sng122tope,'S')) jaqz555par,
           (select pendoc from fsr008 r WHERE r.pgcod = 1 and r.ctnro= a.sccta and r.cttfir='T')jaqz555doc,
            (select s.tdnom
              from fsr008 r,
                   fst014 s
             where/* r.pgcod = 1
               and*/ r.ctnro  = a.sccta
               and r.cttfir='T'              
               and s.tdocum = r.petdoc)jaqz555tdoc,     
             --  fn_garantia_cred(gar.pgcod,gar.aomod,gar.aosuc,gar.aomda,gar.aopap,gar.aocta,gar.aooper,gar.aosbop,gar.aotope) garantia,  
               (select f.tonom from fst004 f where f.modulo=y.sng122mod and f.totope=y.sng122tope) jaqz555tgar,
               decode(a.scmda,101,'DOLAR AMERICANO','SOL') jaqz555dmda,
               ubuser1 jaqz555usr,
               (select max(ppg002dato )
                  from ppg002 
                 where ppg002cod = 1
                   and ppg002mod = 470
                   and ppg002suc = y.sng122suc
                   and ppg002mda = y.sng122mda
                   and ppg002pap = y.sng122pap
                   and ppg002cta = y.sng122cta 
                   AND PPG002OPE = y.sng122oper 
                   and ppg002sbo = y.sng122sbop
                   and ppg002top = y.sng122tope  
                   and PPG002CdAt = 95 ) jaqz555au7,
           y.sng122suc  jaqz555au1,
           y.sng122cta  jaqz555au2,
           (SELECT SCNOM FROM FST001 WHERE PGCOD = 1 and SUCURS =y.sng122suc) jaqz555au4,
           y.sng122mda jaqz555mdag,
           decode(y.sng122mda,101,'DOLAR AMERICANO','SOL') jaqz555dmdag,
           (select (ppg002dato) 
              from ppg002 
             where ppg002cod = 1
               and ppg002mod = 470 ---fijo  formulario 470
               and ppg002suc = y.sng122suc
                   and ppg002mda = y.sng122mda
                   and ppg002pap = y.sng122pap
                   and ppg002cta = y.sng122cta 
                   AND PPG002OPE = y.sng122oper 
                   and ppg002sbo = y.sng122sbop
                   and ppg002top = y.sng122tope  
               and ppg002cdat = 93
               and ppg002frm = FN_MAX_FORM_PPG000(1,470,y.sng122suc,y.sng122mda,y.sng122pap,y.sng122cta,y.sng122oper,y.sng122sbop,y.sng122tope,'S')) jaqz555fees,
            (select (ppg008desc) 
               from ppg008
             where ppg008pgc = 1
               and ppg008mod = 470 ---fijo  formulario 470
               and ppg008suc = y.sng122suc
              and ppg008mda = y.sng122mda
              and ppg008pap = y.sng122pap
               and ppg008cta = y.sng122cta
               and ppg008ope = y.sng122oper 
               and ppg008sbo = y.sng122sbop
               and ppg008top = y.sng122tope 
               and ppg008cdat = 107  ---valor fijo
               and ppg008frm = FN_MAX_FORM_PPG000(1,470,y.sng122suc,y.sng122mda,y.sng122pap,y.sng122cta,y.sng122oper,y.sng122sbop,y.sng122tope,'S')
               ) jaqz555tasi

      from fsd011 a, xwf700 x, sng122 y
     where a.pgcod = 1
       and a.scsuc = P_SUCURSAL
       and a.scmod >= 101 --and 117
       and a.scmod <= 117
       and a.scmod <> 116
       and a.scmod <> 108
       and x.xwfempresa = a.pgcod
       and x.xwfsucursal = a.scsuc
       and x.xwfmodulo = a.scmod
       and x.xwfmoneda = a.scmda
       and x.xwfpapel = a.scpap
       and x.xwfcuenta = a.sccta
       and x.xwfoperacion = a.scoper
       and x.xwfsubope = a.scsbop
       and x.xwftipope = a.sctope
       and x.xwfcar3 = '1'
       and y.sng122inst = x.xwfprcins
       and y.sng122tope <= 65
       order by jaqz555tit )   
       SELECT seq_jaqz555.nextval,
                      jaqz555cod1,
                      jaqz555suc,
                      jaqz555mda,
                      jaqz555pap,
                      jaqz555cta,
                      jaqz555ope,
                      jaqz555sbo,
                      jaqz555top,
                      jaqz555mod,
                      jaqz555ncre,
                      jaqz555fval,
                      jaqz555fcon,
                      jaqz555sald,
                      jaqz555est,
                      jaqz555oga,
                      jaqz555fgar,
                      jaqz555impg,
                      jaqz555ctag,
                      jaqz555estc,
                      jaqz555feci,
                      jaqz555tit,
                      jaqz555tic,
                      jaqz555reg,
                      jaqz555age,
                      jaqz555par,
                      jaqz555doc,
                      jaqz555tdoc,
                      jaqz555tgar,
                      jaqz555dmda,
                      jaqz555usr,
                      jaqz555au7,
                      jaqz555au1,
                      jaqz555au2,
                      jaqz555au4,
                      jaqz555mdag,
                      jaqz555dmdag,
                      jaqz555fees,
                      jaqz555tasi FROM DATA;                      
     commit;
 exception
   when others then
     null;           
end SP_CR_GARANTIAVIGENTE;
/

