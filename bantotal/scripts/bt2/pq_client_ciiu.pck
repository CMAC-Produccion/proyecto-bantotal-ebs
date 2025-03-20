create or replace package pq_client_ciiu is

  -- Author  : PVARGAS
  -- Created : 27/09/2013 06:56:01 p.m.
  -- Purpose : 
  
  function fn_ciiu_codigo(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return number;
                         
  function fn_ciiu_descri(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return varchar2;                        

  function fn_act_codigo(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return varchar2;
                         
 function fn_petipo(P_PAIS   in number,
                    P_PETDOC in number,   
                    P_PENDOC in char
                   ) return varchar2;
                   
 function fn_acteco_codigo(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return number;
                         
 function fn_acteco_descri(P_PAIS   in number,
                           P_PETDOC in number,   
                           P_PENDOC in char,
                           P_PETIPO in varchar2
                          ) return varchar2;                                                                     
                         
 function fn_ciiu_actcod2(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return number;                         
                         
  function fn_ini_activid(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char
                         ) return date;                         
end pq_client_ciiu;
/

create or replace package body pq_client_ciiu is

  function fn_ciiu_codigo(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return number
  is
    ln_codciiu fst750.actcod1%type;
    lv_petipo varchar2(1);
  Begin
     
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS,P_PETDOC,P_PENDOC);
    
    If lv_petipo = 'F' Then
       Begin
            Select c60.sngc60acte
              Into ln_codciiu
              From sngc60 c60
             Where c60.sngc60pais = P_PAIS
               And c60.sngc60tdoc = P_PETDOC
               And c60.sngc60ndoc = P_PENDOC
               And c60.sngc60corr = 0;       
       Exception when others then
          ln_codciiu := 0;       
       End;
    End If;                           
    
    If lv_petipo = 'J' Then
       Begin
            Select e001.expnins
              Into ln_codciiu
              From fse001 e001
             Where e001.d511pais = P_PAIS
               And e001.d511tdoc = P_PETDOC
               And e001.d511ndoc = P_PENDOC;       
       Exception when others then
          ln_codciiu := 0;       
       End; 
    End If;
    
    Return ln_codciiu;
        
  end fn_ciiu_codigo;
  ---------------------------------
  function fn_ciiu_descri(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return varchar2
  is
    ln_desciiu fst750.actnom1%type;
    lv_petipo varchar2(1);
  Begin
          
     
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS,P_PETDOC,P_PENDOC);
     
    If lv_petipo = 'F' Then
       Begin
            Select t750.actnom1
              Into ln_desciiu
              From sngc60 c60,
                   fst750 t750
             Where c60.sngc60pais = P_PAIS
               And c60.sngc60tdoc = P_PETDOC
               And c60.sngc60ndoc = P_PENDOC
               And c60.sngc60corr = 0
               And t750.actcod1   = c60.sngc60acte;       
       Exception when others then
          ln_desciiu := 'No Registrado';       
       End;
    End If;                           
    
    If lv_petipo = 'J' Then
       Begin
            Select t750.actnom1
              Into ln_desciiu
              From fse001 e001,
                   fst750 t750
             Where e001.d511pais = P_PAIS
               And e001.d511tdoc = P_PETDOC
               And e001.d511ndoc = P_PENDOC
               And t750.actcod1  = e001.expnins;       
       Exception when others then
          ln_desciiu := 'No Registrado';       
       End; 
    End If;
    
    Return ln_desciiu;
        
  end fn_ciiu_descri;
  ----------------------------------------------------
  function fn_act_codigo(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return varchar2
  is
    ln_actcod fst750.actcod3%type;
    lc_petipo fsd001.petipo%type;
  Begin
      Select u.petipo
     Into lc_petipo
   from fsd001 u
   where u.pepais = P_PAIS
     and u.petdoc = P_PETDOC
     and u.pendoc = P_PENDOC;
  
  
    If lc_petipo = 'F' Then
       Begin
            Select t750.actcod3
              Into ln_actcod
              From sngc60 c60,
                   fst750 t750
             Where c60.sngc60pais = P_PAIS
               And c60.sngc60tdoc = P_PETDOC
               And c60.sngc60ndoc = P_PENDOC
               And c60.sngc60corr = 0
               And t750.actcod1   = c60.sngc60acte;       
       Exception when others then
          ln_actcod := 0;       
       End;
    End If;                           
    
    If lc_petipo = 'J' Then
       Begin
            Select t750.actcod3
              Into ln_actcod
              From fse001 e001,
                   fst750 t750
             Where e001.d511pais = P_PAIS
               And e001.d511tdoc = P_PETDOC
               And e001.d511ndoc = P_PENDOC
               And t750.actcod1  = e001.expnins;       
       Exception when others then
          ln_actcod := 0;       
       End; 
    End If;
    
    Return ln_actcod;
        
  end fn_act_codigo;
  ---------------------------------  
  /* Select u.petipo
     Into lc_petipo
   from fsd001 u
   where u.pepais = P_PAIS
     and u.petdoc = P_PETDOC
     and u.pendoc = P_PENDOC;
  */

 function fn_petipo(P_PAIS   in number,
                    P_PETDOC in number,   
                    P_PENDOC in char
                   ) return varchar2
 is
   lv_tipper varchar2(1);
 Begin
       Select u.petipo
         Into lv_tipper
       from fsd001 u
       where u.pepais = P_PAIS
         and u.petdoc = P_PETDOC
         and u.pendoc = P_PENDOC;    
       
       
       Return lv_tipper;
       
 Exception When Others Then
           Return null;                  
 end fn_petipo;                          
 ---------------------
 function fn_acteco_codigo(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return number
  is
    ln_codact  fst752.actcod3%type;
    ln_codciiu fst750.actcod1%type;
    lv_petipo varchar2(1);
  Begin
     
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS,P_PETDOC,P_PENDOC);
    
    If lv_petipo = 'F' Then
       Begin
            Select c60.sngc60tipa
              Into ln_codact
              From sngc60 c60
             Where c60.sngc60pais = P_PAIS
               And c60.sngc60tdoc = P_PETDOC
               And c60.sngc60ndoc = P_PENDOC
               And c60.sngc60corr = 0;       
       Exception when others then
          ln_codact := 0;       
       End;
    End If;                           
    
    If lv_petipo = 'J' Then
       Begin
            Select e001.expnins
              Into ln_codciiu
              From fse001 e001
             Where e001.d511pais = P_PAIS
               And e001.d511tdoc = P_PETDOC
               And e001.d511ndoc = P_PENDOC;  
               
            Select t750.actcod3
              Into ln_codact  
              From FST750 t750
             Where t750.actcod1 = ln_codciiu;
             
       Exception when others then
          ln_codact := 0;       
       End; 
    End If;
    
    Return ln_codact;
        
  end fn_acteco_codigo;
  ------------------  
function fn_acteco_descri(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return varchar2
  is
    ln_desact fst752.actnom3%type;
    lv_petipo varchar2(1);
  Begin
          
     
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS,P_PETDOC,P_PENDOC);
     
    If lv_petipo = 'F' Then
       Begin
            Select t752.actnom3
              Into ln_desact
              From sngc60 c60,
                   fst752 t752
             Where c60.sngc60pais = P_PAIS
               And c60.sngc60tdoc = P_PETDOC
               And c60.sngc60ndoc = P_PENDOC
               And c60.sngc60corr = 0
               And t752.actcod3   = c60.sngc60tipa;       
       Exception when others then
          ln_desact := 'No Registrado';       
       End;
    End If;                           
    
    If lv_petipo = 'J' Then
       Begin
            Select t752.actnom3
              Into ln_desact
              From fse001 e001,
                   fst750 t750,
                   fst752 t752
             Where e001.d511pais = P_PAIS
               And e001.d511tdoc = P_PETDOC
               And e001.d511ndoc = P_PENDOC
               And t750.actcod1  = e001.expnins
               And t752.actcod3  = t750.actcod3;       
       Exception when others then
          ln_desact := 'No Registrado';       
       End; 
    End If;
    
    Return ln_desact;
        
  end fn_acteco_descri;
  ------------------------------------  
 function fn_ciiu_actcod2(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char,
                          P_PETIPO in varchar2
                         ) return number
  is
    ln_codciiu fst750.actcod1%type;
    lv_petipo varchar2(1);
    lv_actcod2 fst750.actcod2%type;
  Begin
     
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS,P_PETDOC,P_PENDOC);
    
    If lv_petipo = 'F' Then
       Begin
            Select c60.sngc60acte
              Into ln_codciiu
              From sngc60 c60
             Where c60.sngc60pais = P_PAIS
               And c60.sngc60tdoc = P_PETDOC
               And c60.sngc60ndoc = P_PENDOC
               And c60.sngc60corr = 0;       
       Exception when others then
          ln_codciiu := 0;       
       End;
    End If;                           
    
    If lv_petipo = 'J' Then
       Begin
            Select e001.expnins
              Into ln_codciiu
              From fse001 e001
             Where e001.d511pais = P_PAIS
               And e001.d511tdoc = P_PETDOC
               And e001.d511ndoc = P_PENDOC;       
       Exception when others then
          ln_codciiu := 0;       
       End; 
    End If;
    
    
    Begin
        select actcod2 
          into lv_actcod2
          from fst750 
         where actcod1=ln_codciiu;
    Exception when others then
         lv_actcod2 := null;
    End;
    

    
    Return lv_actcod2;
        
  end fn_ciiu_actcod2;
  ---------------------------------  
  function fn_ini_activid(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char
                         ) return date
  is
    ld_fecini date;
    lv_petipo varchar2(1);
  Begin
          
     
    --lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS,P_PETDOC,P_PENDOC);
     
    --If lv_petipo = 'F' Then
       Begin
            Select c60.sngc60fini
              Into ld_fecini
              From sngc60 c60
             Where c60.sngc60pais = P_PAIS
               And c60.sngc60tdoc = P_PETDOC
               And c60.sngc60ndoc = P_PENDOC
               And c60.sngc60corr = 0;       
       Exception when others then
              ld_fecini := null;   
       End;
    --End If;                           
    /*
    If lv_petipo = 'J' Then
       Begin
            Select t750.actnom1
              Into ln_desciiu
              From fse001 e001,
                   fst750 t750
             Where e001.d511pais = P_PAIS
               And e001.d511tdoc = P_PETDOC
               And e001.d511ndoc = P_PENDOC
               And t750.actcod1  = e001.expnins;       
       Exception when others then
          ln_desciiu := 'No Registrado';       
       End; 
    End If;*/
    
    Return ld_fecini;
        
  end fn_ini_activid;
  ---------------------------------      
end pq_client_ciiu;
/

