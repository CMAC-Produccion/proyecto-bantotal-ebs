create or replace package PQ_CR_JAQZ456I_Instancia is

   -- *****************************************************************
    -- Nombre                     : PQ_CR_JAQZ456I_Instancia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2019.03.25
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : REtorna Instancia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_graba_instancia(p_JAQZ456Ipai in number,
                               p_JAQZ456Itdo in number,
                               p_JAQZ456Idoc in varchar2,                                                          
                               p_JAQZ456IINS in number,
                               p_JAQZ456Imod in number,
                               p_JAQZ456Itop in number,
                               p_JAQZ456Imda in number,
                               p_JAQZ456Iite in number,
                               p_JAQZ456Ipro in number,
                               p_JAQZ456Iusu in varchar2
                              
                              );
                              
                              

end PQ_CR_JAQZ456I_Instancia;
/

create or replace package body PQ_CR_JAQZ456I_Instancia is

 procedure sp_graba_instancia(p_JAQZ456Ipai in number,
                                 p_JAQZ456Itdo in number,
                                 p_JAQZ456Idoc in varchar2,                                                          
                                 p_JAQZ456IINS in number,
                                 p_JAQZ456Imod in number,
                                 p_JAQZ456Itop in number,
                                 p_JAQZ456Imda in number,
                                 p_JAQZ456Iite in number,
                                 p_JAQZ456Ipro in number,
                                 p_JAQZ456Iusu in varchar2
                                 
                              ) is

  ld_FecApe date;
  lc_hora char(8);
                              
  BEGIN
  
    begin
        select pgfape into  ld_FecApe from fst017 where pgcod=1;          
    end;
    
    lc_hora := to_char(sysdate,'HH:MI:SS');
    
    insert into JAQZ456I
      (jaqz456ipai,
       jaqz456itdo,
       jaqz456idoc,
       jaqz456iins,
       jaqz456ifec,
       jaqz456imod,
       jaqz456itop,
       jaqz456imda,
       jaqz456iite,
       jaqz456ipro,
       jaqz456iusu,
       jaqz456ihor)
    values
      (p_JAQZ456Ipai,
       p_JAQZ456Itdo,
       p_JAQZ456Idoc,
       p_JAQZ456IINS,
       ld_FecApe,
       p_JAQZ456Imod,
       p_JAQZ456Itop,
       p_JAQZ456Imda,
       nvl(p_JAQZ456Iite,0),
       nvl(p_JAQZ456Ipro,0),
       p_JAQZ456Iusu,
       lc_hora);

    commit;
    
  end sp_graba_instancia;    
  
  
end PQ_CR_JAQZ456I_Instancia;
/

