create or replace package PQ_CR_LISTAS_NEGRAS is
 
    -- *****************************************************************
    -- Nombre                     : BAJAR SOLICITUDES SUPERIORES A UNA CANTIDAD DE DIAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.05.27
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : FILTRAR, ACTUALIZAR Y ELIMINAR SOLICITUDES PENDIENTES
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_fsd201( Ln_Pais in number, 
                          Ln_Tdoc in number, 
                          Ln_Ndoc in char,
                          ln_lista1 out char,
                          ln_lista2 out char,
                          ln_lista3 out char,
                          ln_lista4 out char,
                          ln_lista5 out char
                         ) ;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_integrantes(ln_cuenta in number,
                            pn_lista1 out char,             
                            pn_lista2 out char,
                            pn_lista3 out char,
                            pn_lista4 out char,
                            pn_lista5 out char
                           );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 end PQ_CR_LISTAS_NEGRAS;
/

create or replace package body PQ_CR_LISTAS_NEGRAS is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_LISTAS_NEGRAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.05.27
    -- Autor de Creación          : DCASTRO
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
  procedure sp_cr_fsd201( Ln_Pais in number, 
                          Ln_Tdoc in number, 
                          Ln_Ndoc in char,
                          ln_lista1 out char,
                          ln_lista2 out char,
                          ln_lista3 out char,
                          ln_lista4 out char,
                          ln_lista5 out char
                         ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_fsd201
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

   ln_lista char(1);
    
   BEGIN

   ln_lista := 'N';
     
      FOR num IN 1 .. 5 loop
       begin
         select 'S'
           into ln_lista
           from Fsd201 --: Personas Inhabilitadas
          Where LnPais = Ln_Pais
            and LnTdoc = Ln_Tdoc
            and LnNdoc = Ln_Ndoc
            and TLis = num;
       exception
         when too_many_rows then
           begin
             select 'S'
               into ln_lista
               from Fsd201 f --: Personas Inhabilitadas
              Where LnPais = Ln_Pais
                and LnTdoc = Ln_Tdoc
                and LnNdoc = Ln_Ndoc
                and TLis = num
                and f.lnfact in (select max(g.lnfact)
                                   from Fsd201 g --: Personas Inhabilitadas
                                  Where g.LnPais = f.LnPais
                                    and g.LnTdoc = f.LnTdoc
                                    and g.LnNdoc = f.LnNdoc
                                    and g.TLis = num);
           exception
             when others then
               ln_lista := 'N';
           end;

          when others then
               ln_lista := 'N';
       end;
         case
          when num = 1 then
            ln_lista1 := ln_lista;
          when num = 2 then
            ln_lista2 := ln_lista;
            
            if ln_lista2 = 'S' then
               --verificar excepcion en jaqy466
               begin
                 select 'N'  --esta exceptuado, no debe considerarse 
                   into ln_lista2
                   from jaqy466 k
                  where k.jaqy466lis = 2
                    and k.jaqy466pai = Ln_Pais
                    and k.jaqy466tdc = Ln_Tdoc
                    and k.jaqy466ndc = Ln_Ndoc
                    and k.jaqy466est = 'S'
                    and k.jaqy466cor in
                        (select max(f.jaqy466cor)
                           from jaqy466 f
                          where f.jaqy466lis = 2
                            and f.jaqy466pai = Ln_Pais
                            and f.jaqy466tdc = Ln_Tdoc
                            and f.jaqy466ndc = Ln_Ndoc
                          );
               exception when others then
                  null;
                 
               end;
              
            end if;
            
          when num = 3 then
            ln_lista3 := ln_lista;
          when num = 4 then
            ln_lista4 := ln_lista;
          when num = 5 then
            ln_lista5 := ln_lista;
         else
            null;           
         end case;

     end loop;    

END sp_cr_fsd201;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_integrantes(ln_cuenta in number,
                            pn_lista1 out char,             
                            pn_lista2 out char,
                            pn_lista3 out char,
                            pn_lista4 out char,
                            pn_lista5 out char
                           ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_fsd201
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

cursor cuentas is 
select * from fsr008 f
where f.pgcod = 1
  and f.ctnro = ln_cuenta;

cursor juridica(LnPais in number, LnTdoc in number, LnNdoc in number) is
select * from FSR003
Where Pjpais = LnPais
and Pjtdoc = LnTdoc
and Pjndoc = LnNdoc;


ln_lista1 char(1);
ln_lista2 char(1);
ln_lista3 char(1);
ln_lista4 char(1);
ln_lista5 char(1);
ln_pais number;
ln_tdoc number; 
ln_ndoc char(12);



BEGIN


ln_lista1 := 'N';
ln_lista2 := 'N';
ln_lista3 := 'N';
ln_lista4 := 'N';
ln_lista5 := 'N';

pn_lista1 := 'N';             
pn_lista2 := 'N';
pn_lista3 := 'N';
pn_lista4 := 'N';
pn_lista5 := 'N';


for i in cuentas loop

     ln_pais := null;
     ln_tdoc := null;
     ln_ndoc := null; 
  
    if  i.Petdoc <> 9  then
        begin
        pq_cr_listas_negras.sp_cr_fsd201(ln_pais => i.Pepais,
                                        ln_tdoc => i.Petdoc,
                                        ln_ndoc => i.Pendoc,
                                        ln_lista1 => ln_lista1,
                                        ln_lista2 => ln_lista2,
                                        ln_lista3 => ln_lista3,
                                        ln_lista4 => ln_lista4,
                                        ln_lista5 => ln_lista5);
        end;
        
        if pn_lista1 <> 'S' then pn_lista1 := ln_lista1; end if;
        if pn_lista2 <> 'S' then pn_lista2 := ln_lista2; end if;
        if pn_lista3 <> 'S' then pn_lista3 := ln_lista3; end if;                
        if pn_lista4 <> 'S' then pn_lista4 := ln_lista4; end if;
        if pn_lista5 <> 'S' then pn_lista5 := ln_lista5; end if;
        
        ---obtener conyuge
        begin 
              select Rppais,  Rptdoc, Rpndoc
               into ln_pais, ln_tdoc, ln_ndoc
               from FSR002 f
              where f.Pepais = i.Pepais
                and f.Petdoc = i.Petdoc
                and f.Pendoc = i.Pendoc
                and Rpccyg = 66;
        exception when others then
             ln_pais := null;
             ln_tdoc := null;
             ln_ndoc := null;     
        end;   
        
        if ln_ndoc is not null then
          begin
            pq_cr_listas_negras.sp_cr_fsd201(ln_pais => ln_pais,
                                            ln_tdoc => ln_tdoc,
                                            ln_ndoc => ln_ndoc,
                                            ln_lista1 => ln_lista1,
                                            ln_lista2 => ln_lista2,
                                            ln_lista3 => ln_lista3,
                                            ln_lista4 => ln_lista4,
                                            ln_lista5 => ln_lista5);
          end;
          
          if pn_lista1 <> 'S' then pn_lista1 := ln_lista1; end if;
          if pn_lista2 <> 'S' then pn_lista2 := ln_lista2; end if;
          if pn_lista3 <> 'S' then pn_lista3 := ln_lista3; end if;                
          if pn_lista4 <> 'S' then pn_lista4 := ln_lista4; end if;
          if pn_lista5 <> 'S' then pn_lista5 := ln_lista5; end if;
            
        end if;
        -- fin conyuge
    else
        
       ln_pais := null;
       ln_tdoc := null;
       ln_ndoc := null; 
        
       --obteniendo lista negra de juridica
       begin
            pq_cr_listas_negras.sp_cr_fsd201(ln_pais => i.Pepais,
                                            ln_tdoc => i.Petdoc,
                                            ln_ndoc => i.Pendoc,
                                            ln_lista1 => ln_lista1,
                                            ln_lista2 => ln_lista2,
                                            ln_lista3 => ln_lista3,
                                            ln_lista4 => ln_lista4,
                                            ln_lista5 => ln_lista5);
          end;
          
          if pn_lista1 <> 'S' then pn_lista1 := ln_lista1; end if;
          if pn_lista2 <> 'S' then pn_lista2 := ln_lista2; end if;
          if pn_lista3 <> 'S' then pn_lista3 := ln_lista3; end if;                
          if pn_lista4 <> 'S' then pn_lista4 := ln_lista4; end if;
          if pn_lista5 <> 'S' then pn_lista5 := ln_lista5; end if;
       ---            
       
        for y in juridica(i.Pepais , i.Petdoc, i.Pendoc) loop
             begin
             
              pq_cr_listas_negras.sp_cr_fsd201(ln_pais => y.Pfpai1,
                                              ln_tdoc => y.Pftdo1,
                                              ln_ndoc => y.Pfndo1,
                                              ln_lista1 => ln_lista1,
                                              ln_lista2 => ln_lista2,
                                              ln_lista3 => ln_lista3,
                                              ln_lista4 => ln_lista4,
                                              ln_lista5 => ln_lista5);
              end;  
        
              if pn_lista1 <> 'S' then pn_lista1 := ln_lista1; end if;
              if pn_lista2 <> 'S' then pn_lista2 := ln_lista2; end if;
              if pn_lista3 <> 'S' then pn_lista3 := ln_lista3; end if;                
              if pn_lista4 <> 'S' then pn_lista4 := ln_lista4; end if;
              if pn_lista5 <> 'S' then pn_lista5 := ln_lista5; end if;

              ---obtener conyuge
              begin 
                    select Rppais,  Rptdoc, Rpndoc
                     into ln_pais, ln_tdoc, ln_ndoc
                     from FSR002 f
                    where f.Pepais = y.Pfpai1
                      and f.Petdoc = y.Pftdo1
                      and f.Pendoc = y.Pfndo1
                      and Rpccyg = 66;
              exception when others then
                   ln_pais := null;
                   ln_tdoc := null;
                   ln_ndoc := null;     
              end;   
              
              if ln_ndoc is not null then
                begin
                  pq_cr_listas_negras.sp_cr_fsd201(ln_pais => ln_pais,
                                                  ln_tdoc => ln_tdoc,
                                                  ln_ndoc => ln_ndoc,
                                                  ln_lista1 => ln_lista1,
                                                  ln_lista2 => ln_lista2,
                                                  ln_lista3 => ln_lista3,
                                                  ln_lista4 => ln_lista4,
                                                  ln_lista5 => ln_lista5);
                end;
                
                if pn_lista1 <> 'S' then pn_lista1 := ln_lista1; end if;
                if pn_lista2 <> 'S' then pn_lista2 := ln_lista2; end if;
                if pn_lista3 <> 'S' then pn_lista3 := ln_lista3; end if;                
                if pn_lista4 <> 'S' then pn_lista4 := ln_lista4; end if;
                if pn_lista5 <> 'S' then pn_lista5 := ln_lista5; end if;
                  
              end if;
              -- fin conyuge
        
        end loop;
      
    end if;
        
end loop;
  
END sp_cr_integrantes;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_LISTAS_NEGRAS;
/

