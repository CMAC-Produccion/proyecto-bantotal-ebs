create or replace package pq_cr_rel_crediticia_hs is
 
    -- *****************************************************************
    -- Nombre                     : PAQUETE PARA CALCULAR LA RELACION CREDITICIA.
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 17/05/2018
    -- Autor de Creación          : HSUAREZ 
    -- Uso                        : PAQUETE QUE DEVUELVE LA RELACION CREDITICIA DEL CLIENTE.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_calcular_relacion(instancia number,vi_histoCre out number);
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_calcular_correlativo(contador out number);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_calcular_correlativo_log(contador out number);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_saldo_consolidado(dni in char,saldo out number); 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 end pq_cr_rel_crediticia_hs;
/

create or replace package body pq_cr_rel_crediticia_hs is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_NUEVOS_RCC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2018.05.18
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 
    -- *****************************************************************
      


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_calcular_relacion(instancia number,vi_histoCre out number) is
    -- *****************************************************************
    -- Nombre                     : sp_calcular_relacion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : calcula la relacion crediticia 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 18/05/2018
    -- Autor de la Modificación   : HSUAREZ
    -- Descripción de Modificación: ....
		  
    -- *****************************************************************
    
	  --OBTENEMOS LA DATA DE LOS QUE TENGAN CALFICACION 100 NORMAL DEL ULTIMO MES.
    v_saldo number;
    vi_pgcod fsr008.pgcod%type;
    vi_pepais fsr008.pepais%type;
    vi_petdoc fsr008.petdoc%type;
    vi_pendoc fsr008.pendoc%type;
    pr_instancia xwf700.xwfprcins%type;
    
    flag_exceptuado char;
    vi_historico number;
    vi_fecha date;                 
                  
    flag_jaqz074 char;
    vi_hist074  jaqz074.jaqz074his%type;
    vi_est074   jaqz074.jaqz074est%type;
    vi_fec074   jaqz074.jaqz074fec%type; 
    
    --vi_histoCre jaqz074.jaqz074his%type;
    vi_fecha_sis date;    
    vi_fectemp date;               
		begin
      
            begin
              select 
                pgfape
              into
                vi_fecha_sis 
              from  fst017
              where pgcod=1;
              
              SELECT 
                    trunc(ADD_MONTHS(TO_DATE(vi_fecha_sis,'DD/MM/YYYY'),-12),'MM')
                into
                    vi_fectemp
               FROM DUAL;
              
            end;
            begin
               --DATOS INSTANCIA
               Select 
                       sng001Emp,
                       sng001pais,
                       sng001Tdoc,
                       sng001Ndoc
               into    
                       vi_pgcod,
                       vi_pepais,
                       vi_petdoc,
                       vi_pendoc
               from sng001
               where sng001Inst = instancia; 
            exception
              when no_data_found then
                vi_pgcod :=0;
                vi_pepais:=0;
                vi_petdoc:=0;
                vi_pendoc:=0;
            end;
            
            begin
              --RESOLUTOR
              select
                'S',
                jaqz076his
              into
                flag_exceptuado,
                vi_historico
              from
              jaqz076
              where jaqz076pai = vi_pepais
              and   jaqz076tdo = vi_petdoc
              and   jaqz076ndo = vi_pendoc
              and   jaqz076est = 'S';
            exception 
              when no_data_found then
                     flag_exceptuado:='N';
                     vi_historico:=0;
            end;
            
            if flag_exceptuado<>'S' then
              begin
                 --BUSCAR_EXISTA
                 Select
                       to_date(tp1nro1,'ddmmyyyy')
                 into
                       vi_fecha
                 from fst198
                 where tp1cod   = 1
                   and tp1cod1  = 10823
                   and tp1corr1 = 8;     
              exception
                when no_data_found then
                  vi_fecha := null;                                   
              end;
              begin
                 select 
                      'S',
                      jaqz074his,
                      jaqz074est,
                      jaqz074fec
                 into
                      flag_jaqz074,
                      vi_hist074,
                      vi_est074,
                      vi_fec074
                 from jaqz074
                 where jaqz074pai = vi_pepais
                   and jaqz074tdo = vi_petdoc
                   and jaqz074ndo = vi_pendoc  
                   and jaqz074fep = vi_fecha;
              exception 
                when no_data_found then
                  flag_jaqz074 := 'N';
                  vi_hist074   := null;
                  vi_est074    := null;
                  vi_fec074    := null;
              end;
              
              if flag_jaqz074 = 'S' then
                  if vi_est074 = 99 then
                    if vi_fec074 =null  or vi_fec074> vi_fectemp then
                      vi_histoCre := vi_hist074;
                    else
                      pq_cr_relcrediticia.sp_cr_recalcula(vi_pepais,vi_petdoc,vi_pendoc,vi_fecha_sis,vi_histoCre);
                    end if;
                  else
                      vi_histoCre := vi_hist074+1;
                  end if;
              else
                vi_histoCre :=0;
              end if;
            
            else
              vi_histoCre := vi_historico;
            end if;
            
            
            
		END sp_calcular_relacion;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_calcular_correlativo(contador out number) is
    
    begin
      select max(aqpa085id)
        into contador
        from aqpa085;  
 end;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_calcular_correlativo_log(contador out number) is
    
    begin
      select max(aqpa086cor)
        into contador
        from aqpa086;  
 end;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 
 procedure sp_saldo_consolidado(dni in char,saldo out number) is
 vi_fecha_URCC number(9);
 vi_fechaRCC date;
 vi_cod_sbs char(10);
 begin
      begin
          select 
               tpnro
           into 
               vi_fecha_URCC
          from fst098 
          where tpcod = 7647 
            and tpcorr =12;
      end;
      begin
          select 
            c_codsbs
          into
            vi_cod_sbs
          from  cldrcci
          where c_tipdet='Z' 
            and c_docide=saldo;
      end;
      begin
         vi_fechaRCC := to_date(to_char(vi_fecha_URCC),'ddmmyyyy');
         select 
            sum(N_SALCAP)
           into 
            saldo
           from CLDRCCS a
          Where C_CODSBS = vi_cod_sbs
            and D_FECPRE = vi_fechaRCC
            and substr(c_cuenta,1,4) not in ('1418','1428','1419','1429')
            and ( substr(c_cuenta,1,4) not  in ('7215','7225','8119','8129')
            and ( substr(c_cuenta,1,2) = '14' and substr(c_cuenta,7,2) not in ( '02','19' ) ))
            and c_codemp<>'00104';
      end;
 end;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 end pq_cr_rel_crediticia_hs;
/

