create or replace package pq_cr_var_riesgo_cambiario is

  procedure sp_total_variables_rc(p_instancia            in number,
                                  p_SALARIO_DOL          out varchar2,
                                  p_SALARIO_SOL          out varchar2,
                                  p_MONEDA_SOLICITUD_SOL out varchar2,
                                  p_DEUDA_EN_DOLAR       out varchar2,
                                  p_DEUDA_EN_SOLES       out varchar2,
                                  p_VENTAS_DOL           out varchar2,
                                  p_VENTAS_SOL           out varchar2,
                                  p_TPO_CAMBIO           out varchar2,
                                  p_EXCEDENTE_DOL        out varchar2,
                                  p_EXCEDENTE_SOL        out varchar2,
                                  p_RESULTADO_DOL        out varchar2,
                                  p_RESULTADO_SOL        out varchar2);

  procedure sp_valor_variable_rc(p_instancia    in number,
                                 p_variable     in varchar2,
                                 p_val_variable out varchar2);

end pq_cr_var_riesgo_cambiario;
/

create or replace package body pq_cr_var_riesgo_cambiario is

  procedure sp_total_variables_rc(p_instancia            in number,
                                  p_SALARIO_DOL          out varchar2,
                                  p_SALARIO_SOL          out varchar2,
                                  p_MONEDA_SOLICITUD_SOL out varchar2,
                                  p_DEUDA_EN_DOLAR       out varchar2,
                                  p_DEUDA_EN_SOLES       out varchar2,
                                  p_VENTAS_DOL           out varchar2,
                                  p_VENTAS_SOL           out varchar2,
                                  p_TPO_CAMBIO           out varchar2,
                                  p_EXCEDENTE_DOL        out varchar2,
                                  p_EXCEDENTE_SOL        out varchar2,
                                  p_RESULTADO_DOL        out varchar2,
                                  p_RESULTADO_SOL        out varchar2) is
    ln_auxnum number;
  begin
  
    begin
      select sum(sng023mto)
        into ln_auxnum
        from SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = p_instancia)
         AND SNG026COD IN (501, 502, 503, 504, 509, 510, 511, 512)
       group by sng021eval;
    
      p_SALARIO_DOL := to_char(ln_auxnum);
    exception
      when others then
        p_SALARIO_DOL := null;
    end;
  
    begin
      select sum(sng023mto)
        into ln_auxnum
        from SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = p_instancia)
         AND SNG026COD IN (1, 2, 3, 4, 9, 10, 11, 12)
       group by sng021eval;
    
      p_SALARIO_SOL := to_char(ln_auxnum);
    exception
      when others then
        p_SALARIO_SOL := null;
    end;
  
    begin
      select CASE
               WHEN COUNT(*) > 0 THEN
                'S'
               ELSE
                'N'
             END
        into p_MONEDA_SOLICITUD_SOL
        from XWF700 C
       WHERE C.XWFMONEDA = 0
         AND C.XWFPRCINS = p_instancia;
    
    exception
      when others then
        p_MONEDA_SOLICITUD_SOL := null;
    end;
  
    begin
      select CASE
               WHEN COUNT(*) > 0 THEN
                'S'
               ELSE
                'N'
             END
        into p_DEUDA_EN_DOLAR
        from FSD010 B
       WHERE B.AOMDA = 101
         AND B.AOCTA IN (select A.CTNRO
                           from FSR008 A
                          WHERE A.PEPAIS =
                                (select d.sng001pais
                                   from SNG001 D
                                  WHERE D.SNG001INST = p_instancia)
                            AND A.PETDOC =
                                (select d.sng001tdoc
                                   from SNG001 D
                                  WHERE D.SNG001INST = p_instancia)
                            AND A.PENDOC =
                                (select d.sng001ndoc
                                   from SNG001 D
                                  WHERE D.SNG001INST = p_instancia)
                            AND A.CTTFIR = 'T')
         AND B.PGCOD = 1
         AND B.AOMOD IN (101,
                         102,
                         103,
                         104,
                         105,
                         106,
                         107,
                         109,
                         110,
                         111,
                         112,
                         113,
                         114,
                         115,
                         116,
                         117)
         AND B.AOSTAT <> 99;
    
    exception
      when others then
        p_DEUDA_EN_DOLAR := null;
    end;
  
    begin
      select CASE
               WHEN COUNT(*) > 0 THEN
                'S'
               ELSE
                'N'
             END
        into p_DEUDA_EN_SOLES
        from FSD010 B
       WHERE B.AOMDA = 0
         AND B.AOCTA IN (select A.CTNRO
                           from FSR008 A
                          WHERE A.PEPAIS =
                                (select d.sng001pais
                                   from SNG001 D
                                  WHERE D.SNG001INST = p_instancia)
                            AND A.PETDOC =
                                (select d.sng001tdoc
                                   from SNG001 D
                                  WHERE D.SNG001INST = p_instancia)
                            AND A.PENDOC =
                                (select d.sng001ndoc
                                   from SNG001 D
                                  WHERE D.SNG001INST = p_instancia)
                            AND A.CTTFIR = 'T')
         AND B.PGCOD = 1
         AND B.AOMOD IN (101,
                         102,
                         103,
                         104,
                         105,
                         106,
                         107,
                         109,
                         110,
                         111,
                         112,
                         113,
                         114,
                         115,
                         116,
                         117)
         AND B.AOSTAT <> 99;
    
    exception
      when others then
        p_DEUDA_EN_SOLES := null;
    end;
  
    begin
      select sum(sng023mto)
        into ln_auxnum
        from SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = p_instancia)
         AND SNG026COD IN (573)
       group by sng021eval;
    
      p_VENTAS_DOL := to_char(ln_auxnum);
    exception
      when others then
        p_VENTAS_DOL := null;
    end;
  
    begin
      select sum(sng023mto)
        into ln_auxnum
        from SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = p_instancia)
         AND SNG026COD IN (73)
       group by sng021eval;
    
      p_VENTAS_SOL := to_char(ln_auxnum);
    exception
      when others then
        p_VENTAS_SOL := null;
    end;
  
    begin
      select case
               when SNG120TCBI = 0 THEN
                1
               else
                SNG120TCBI
             end
        into ln_auxnum
        from SNG120
       WHERE SNG120TSK = 'EVALUACION'
         AND SNG120INS = p_instancia;
    
      p_TPO_CAMBIO := to_char(ln_auxnum);
    exception
      when others then
        p_TPO_CAMBIO := null;
    end;
  
    begin
      select sng023mto
        into ln_auxnum
        from SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = p_instancia)
         AND SNG026COD IN (527);
    
      p_EXCEDENTE_DOL := to_char(ln_auxnum);
    exception
      when others then
        p_EXCEDENTE_DOL := null;
    end;
  
    begin
      select sng023mto
        into ln_auxnum
        from SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = p_instancia)
         AND SNG026COD IN (27);
    
      p_EXCEDENTE_SOL := to_char(ln_auxnum);
    exception
      when others then
        p_EXCEDENTE_SOL := null;
    end;
  
    begin
      select sng023mto
        into ln_auxnum
        from SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = p_instancia)
         AND SNG026COD IN (540);
    
      p_RESULTADO_DOL := to_char(ln_auxnum);
    exception
      when others then
        p_RESULTADO_DOL := null;
    end;
  
    begin
      select sng023mto
        into ln_auxnum
        from SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = p_instancia)
         AND SNG026COD IN (40);
    
      p_RESULTADO_SOL := to_char(ln_auxnum);
    exception
      when others then
        p_RESULTADO_SOL := null;
    end;
  
  end sp_total_variables_rc;

  procedure sp_valor_variable_rc(p_instancia    in number,
                                 p_variable     in varchar2,
                                 p_val_variable out varchar2) is
  
    ln_auxnum number;
  begin
  
    case
      when p_variable = 'SALARIO_DOL' then
        begin
          select sum(sng023mto)
            into ln_auxnum
            from SNG023
           where sng021eval = (select SNG021EVAL
                                 from sng021
                                where sng021sol = p_instancia)
             AND SNG026COD IN (501, 502, 503, 504, 509, 510, 511, 512)
           group by sng021eval;
        
          p_val_variable := to_char(ln_auxnum);
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'SALARIO_SOL' then
        begin
          select sum(sng023mto)
            into ln_auxnum
            from SNG023
           where sng021eval = (select SNG021EVAL
                                 from sng021
                                where sng021sol = p_instancia)
             AND SNG026COD IN (1, 2, 3, 4, 9, 10, 11, 12)
           group by sng021eval;
        
          p_val_variable := to_char(ln_auxnum);
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'MONEDA_SOLICITUD_SOL' then
        begin
          select CASE
                   WHEN COUNT(*) > 0 THEN
                    'S'
                   ELSE
                    'N'
                 END
            into p_val_variable
            from XWF700 C
           WHERE C.XWFMONEDA = 0
             AND C.XWFPRCINS = p_instancia;
        
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'DEUDA_EN_DOLAR' then
        begin
          select CASE
                   WHEN COUNT(*) > 0 THEN
                    'S'
                   ELSE
                    'N'
                 END
            into p_val_variable
            from FSD010 B
           WHERE B.AOMDA = 101
             AND B.AOCTA IN (select A.CTNRO
                               from FSR008 A
                              WHERE A.PEPAIS =
                                    (select d.sng001pais
                                       from SNG001 D
                                      WHERE D.SNG001INST = p_instancia)
                                AND A.PETDOC =
                                    (select d.sng001tdoc
                                       from SNG001 D
                                      WHERE D.SNG001INST = p_instancia)
                                AND A.PENDOC =
                                    (select d.sng001ndoc
                                       from SNG001 D
                                      WHERE D.SNG001INST = p_instancia)
                                AND A.CTTFIR = 'T')
             AND B.PGCOD = 1
             AND B.AOMOD IN (101,
                             102,
                             103,
                             104,
                             105,
                             106,
                             107,
                             109,
                             110,
                             111,
                             112,
                             113,
                             114,
                             115,
                             116,
                             117)
             AND B.AOSTAT <> 99;
        
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'DEUDA_EN_SOLES' then
        begin
          select CASE
                   WHEN COUNT(*) > 0 THEN
                    'S'
                   ELSE
                    'N'
                 END
            into p_val_variable
            from FSD010 B
           WHERE B.AOMDA = 0
             AND B.AOCTA IN (select A.CTNRO
                               from FSR008 A
                              WHERE A.PEPAIS =
                                    (select d.sng001pais
                                       from SNG001 D
                                      WHERE D.SNG001INST = p_instancia)
                                AND A.PETDOC =
                                    (select d.sng001tdoc
                                       from SNG001 D
                                      WHERE D.SNG001INST = p_instancia)
                                AND A.PENDOC =
                                    (select d.sng001ndoc
                                       from SNG001 D
                                      WHERE D.SNG001INST = p_instancia)
                                AND A.CTTFIR = 'T')
             AND B.PGCOD = 1
             AND B.AOMOD IN (101,
                             102,
                             103,
                             104,
                             105,
                             106,
                             107,
                             109,
                             110,
                             111,
                             112,
                             113,
                             114,
                             115,
                             116,
                             117)
             AND B.AOSTAT <> 99;
        
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'VENTAS_DOL' then
        begin
          select sum(sng023mto)
            into ln_auxnum
            from SNG023
           where sng021eval = (select SNG021EVAL
                                 from sng021
                                where sng021sol = p_instancia)
             AND SNG026COD IN (573)
           group by sng021eval;
        
          p_val_variable := to_char(ln_auxnum);
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'VENTAS_SOL' then
        begin
          select sum(sng023mto)
            into ln_auxnum
            from SNG023
           where sng021eval = (select SNG021EVAL
                                 from sng021
                                where sng021sol = p_instancia)
             AND SNG026COD IN (73)
           group by sng021eval;
        
          p_val_variable := to_char(ln_auxnum);
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'TPO_CAMBIO' then
        begin
          select case
                   when SNG120TCBI = 0 THEN
                    1
                   else
                    SNG120TCBI
                 end
            into ln_auxnum
            from SNG120
           WHERE SNG120TSK = 'EVALUACION'
             AND SNG120INS = p_instancia;
        
          p_val_variable := to_char(ln_auxnum);
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'EXCEDENTE_DOL' then
        begin
          select sng023mto
            into ln_auxnum
            from SNG023
           where sng021eval = (select SNG021EVAL
                                 from sng021
                                where sng021sol = p_instancia)
             AND SNG026COD IN (527);
        
          p_val_variable := to_char(ln_auxnum);
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'EXCEDENTE_SOL' then
        begin
          select sng023mto
            into ln_auxnum
            from SNG023
           where sng021eval = (select SNG021EVAL
                                 from sng021
                                where sng021sol = p_instancia)
             AND SNG026COD IN (27);
        
          p_val_variable := to_char(ln_auxnum);
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'RESULTADO_DOL' then
        begin
          select sng023mto
            into ln_auxnum
            from SNG023
           where sng021eval = (select SNG021EVAL
                                 from sng021
                                where sng021sol = p_instancia)
             AND SNG026COD IN (540);
        
          p_val_variable := to_char(ln_auxnum);
        exception
          when others then
            p_val_variable := null;
        end;
      
      when p_variable = 'RESULTADO_SOL' then
        begin
          select sng023mto
            into ln_auxnum
            from SNG023
           where sng021eval = (select SNG021EVAL
                                 from sng021
                                where sng021sol = p_instancia)
             AND SNG026COD IN (40);
        
          p_val_variable := to_char(ln_auxnum);
        exception
          when others then
            p_val_variable := null;
        end;
      
      else
        p_val_variable := null;
    end case;
  
  end sp_valor_variable_rc;

end pq_cr_var_riesgo_cambiario;
/

