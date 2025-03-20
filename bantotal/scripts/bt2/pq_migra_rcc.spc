CREATE OR REPLACE PACKAGE pq_migra_rcc IS

    procedure sp_datos_rcc (p_d_fecini in date, p_d_fecpro in date, p_c_msgerr out varchar2);
    procedure sp_califica_6m (p_d_fecpro in date, 
                          p_c_tipdoc in varchar2,
                          p_c_numdoc in varchar2,
                          p_n_calif1 out number, 
                          p_c_calpo1 out varchar2,
                          p_n_calif2 out number,
                          p_c_calpo2 out varchar2,
                          p_n_calif3 out number,
                          p_c_calpo3 out varchar2,
                          p_n_calif4 out number,
                          p_c_calpo4 out varchar2,
                          p_n_calif5 out number,
                          p_c_calpo5 out varchar2,
                          p_n_calif6 out number,
                          p_c_calpo6 out varchar2,
                          p_c_msgerr out varchar2,
                          p_n_canent out number,
                          p_n_deusfi out number, 
                          p_n_deucma out number) ;
end pq_migra_rcc;
/

