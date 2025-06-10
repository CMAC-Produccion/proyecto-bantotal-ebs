create or replace package "PQ_CV_MONITOREO_ACF_MB" is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CV_MONITOREO_ACF_HB
  -- Sistema               : BANTOTAL
  -- Módulo                : HOMEBANKING - HB
  -- Versión               : 1.0
  -- Fecha de Creación     : 12/12/2018
  -- Autor de Creación     : JPINTO
  -- Uso                   : Construccion de la trama a enviar a UNIBANCA para el monitoreo de HB
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 16/05/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Nuevas transacciones (Transferencias Internas y Desembolsos) para enviar a Unibanca
  -- Fecha de Modificación : 25/05/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de datos de contacto a Unibanca
  -- Fecha de Modificación : 31/05/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de Cancelación de DPF a Unibanca
  -- Fecha de Modificación : 27/06/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de datos personales de cliente (documento de identidad, nombre completo y fecha de nacimiento)
  -- Fecha de Modificación : 05/08/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de índice 14 para extornos de transferencias
  -- Fecha de Modificación : 19/08/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de nombre de comercio para transferencias internas
  -- Fecha de Modificación : 24/11/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de saldo de cliente en índice 50
  -- Fecha de Modificación : 09/02/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Ajuste transacciones en trama monitor
  -- Fecha de Modificación : 26/03/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Ajuste nombre y correo para clientes con ruc
  -- Fecha de Modificación : 08/04/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Se incluye transferencia TIN y Diferida M/T
  -- Fecha de Modificación : 26/09/2024
  -- Autor de Modificación : Hernán Laqui Jimenez
  -- Descripción Modific.  : Se agrega transaccion 37 (transferencia contacto, similar a la 32)  
  -- Fecha de Modificación : 21/10/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Se incluye trasaccion 33 en campo 49
  -- Fecha de Modificación : 19/11/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Cambio en la desc. en los campos 40,41 y 42 (CM, HB y KIOSCO)
  -- Fecha de Modificación : 23/12/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Cambio en la desc. en los campos 42 Transf PLIN - CONTACT
  -- Fecha de Modificación : 21/04/2025
  -- Autor de Modificación : Renzo Cuadros Salazar
  -- Descripción Modific.  : Se agrega transaccion 70 (transferencias al exterior) 
  -- Fecha de Modificación : 03/06/2025
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Se agrega transaccion 38 y 41 (copias de la 37 y 31 respectivamente)
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  --// Entrada Principal 
  procedure sp_construirTrama(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number,
                              /*pn_numtra in number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        pd_fectra in date,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        pc_hortra in varchar2,*/
                              pn_codcan in varchar2,
                              pc_trmrsp out varchar2,
                              pc_coderr out varchar2,
                              pc_msgerr out varchar2);

  procedure sp_parsearTrama(pn_codcan in varchar2,
                            pc_trmpar in varchar2,
                            pc_coderr out varchar2,
                            pc_msgerr out varchar2);

  procedure sp_logTrama(pn_codcan in char,
                        pc_trmpar in varchar2,
                        pc_obstrm in varchar2,
                        pc_coderr out varchar2,
                        pc_msgerr out varchar2);

  procedure sp_debugErrorres(pn_codcan in char,
                             pc_trmpar in varchar2,
                             pc_obstrm in varchar2,
                             pc_coderr in varchar2,
                             pc_msgerr in varchar2);

  --// Cabecera
  function fn_trama_indice001 return varchar2;
  function fn_trama_indice002 return varchar2;
  function fn_trama_indice003 return varchar2;
  function fn_trama_indice004 return varchar2;
  function fn_trama_indice005 return varchar2;
  function fn_trama_indice006 return varchar2;
  function fn_trama_indice007 return varchar2;
  function fn_trama_indice008 return varchar2;
  function fn_trama_indice009 return varchar2;

  --// Detalle
  function fn_trama_indice010(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice011(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice012(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice013(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice014(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice015(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice016(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice017(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice018(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice019(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;

  function fn_trama_indice020(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice021(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice022(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice023(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice024(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice025(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice026(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice027(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice028(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice029(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;

  function fn_trama_indice030(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice031(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice032(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice033(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice034(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice035(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice036(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice037(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice038(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice039(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;

  function fn_trama_indice040(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice041(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice042(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice043(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice044(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice045(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice046(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice047(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice048(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice049(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;

  function fn_trama_indice050(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice051(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice052(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice053(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice054(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice055(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice056(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice057(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice058(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice059(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;

  function fn_trama_indice060(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice061(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice062(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice063(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice064(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice065(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice066(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice067(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice068(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice069(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;

  function fn_trama_indice070(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice071(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice072(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice073(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice074(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice075(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice076(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice077(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice078(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice079(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;

  function fn_trama_indice080(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice081(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice082(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice083(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice084(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice085(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice086(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice087(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice088(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice089(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;

  function fn_trama_indice090(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;
  function fn_trama_indice091(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2;

end PQ_CV_MONITOREO_ACF_MB;
 /* GOLDENGATE_DDL_REPLICATION */
/
create or replace package body "PQ_CV_MONITOREO_ACF_MB" is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CV_MONITOREO_ACF_MV
  -- Sistema               : BANTOTAL
  -- Módulo                : Caja Movil - MV
  -- Versión               : 1.0
  -- Fecha de Creación     : 14/01/2018
  -- Autor de Creación     : JPINTO
  -- Uso                   : Construccion de la trama a enviar a UNIBANCA para el monitoreo de Caja Movil
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 16/05/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Nuevas transacciones (Transferencias Internas y Desembolsos) para enviar a Unibanca
  -- Fecha de Modificación : 25/05/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de datos de contacto a Unibanca
  -- Fecha de Modificación : 31/05/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de Cancelación de DPF a Unibanca
  -- Fecha de Modificación : 27/06/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de datos personales de cliente (documento de identidad, nombre completo y fecha de nacimiento)
  -- Fecha de Modificación : 05/08/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de índice 14 para extornos de transferencias
  -- Fecha de Modificación : 19/08/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de nombre de comercio para transferencias internas
  -- Fecha de Modificación : 24/11/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de saldo de cliente en índice 50
  -- Fecha de Modificación : 28/03/2023
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de código y nombre de comercio en transacciones 11, 12 y 31
  -- Fecha de Modificación : 18/05/2023
  -- Autor de Creación     : Renzo Cuadros Salazar
  -- Descripción Modific.  : Se ajusta función de índice 012, 041, 042, 043 para envío de tramas espejo
  -- Fecha de Modificación : 29/05/2023
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Recuperado de cuenta origen en la trama 53
  -- Fecha de Modificación : 09/02/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Ajuste transacciones en trama monitor
  -- Fecha de Modificación : 26/03/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Ajuste nombre y correo para clientes con ruc
  -- Fecha de Modificación : 08/04/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Se incluye transferencia TIN y Diferida M/T
  -- Fecha de Modificación : 26/09/2024
  -- Autor de Modificación : Hernán Laqui Jimenez
  -- Descripción Modific.  : Se agrega transaccion 37 (transferencia contacto, similar a la 32)
  -- Fecha de Modificación : 21/10/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Se incluye trasaccion 33 en campo 49
  -- Fecha de Modificación : 19/11/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Cambio en la desc. en los campos 40,41 y 42 (CM, HB y KIOSCO)
  -- Fecha de Modificación : 23/12/2024
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Cambio en la desc. en los campos 42 Transf PLIN - CONTACT
  -- Fecha de Modificación : 21/04/2025
  -- Autor de Modificación : Renzo Cuadros Salazar
  -- Descripción Modific.  : Se agrega transaccion 70 (transferencias al exterior)
  -- Fecha de Modificación : 03/06/2025
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Se agrega transaccion 38 y 41 (copias de la 37 y 31 respectivamente)
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  --//
  procedure sp_construirTrama(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number,
                              /*pn_numtra in number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        pd_fectra in date,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        pc_hortra in varchar2,                              */
                              pn_codcan in varchar2,
                              pc_trmrsp out varchar2,
                              pc_coderr out varchar2,
                              pc_msgerr out varchar2) is
  
    lc_trmrsp varchar2(4000);
    --//
    lc_aux031 varchar2(19);
  
    cursor c1 is
      select acf.c_cabdet,
             acf.c_import,
             acf.n_indice,
             acf.n_codigo,
             acf.c_noming,
             acf.c_nomesp,
             acf.c_format,
             acf.c_tipdat,
             acf.n_longit,
             acf.n_decima,
             acf.n_posini,
             acf.n_camiso,
             acf.c_justxt,
             acf.c_jusnum
        from jaql634 acf
       where acf.n_indice <= 1000
       order by acf.n_indice;
  begin
    pc_coderr := '00000';
    pc_msgerr := '';
    --//
    for i in c1 loop
      --//
      case i.n_indice
        when 1 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := rpad(STR1 => fn_trama_indice001, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lpad(STR1 => fn_trama_indice001, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 2 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice002, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice002, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 3 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice003, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice003, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 4 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice004, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice004, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 5 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice005, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice005, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 6 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice006, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice006, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 7 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice007, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice007, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 8 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice008, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice008, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 9 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice009, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice009, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 10 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice010(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice010(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 11 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice011(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice011(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 12 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice012(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice012(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 13 then
          --S
          --//
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice013(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice013(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 14 then
          --R        
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice014(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice014(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 15 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice015(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice015(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 16 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice016(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice016(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 17 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice017(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice017(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 18 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice018(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice018(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 19 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice019(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice019(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 20 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice020(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice020(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 21 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice021(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice021(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 22 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice022(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice022(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 23 then
          --S
          --//
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice023(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice023(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 24 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice024(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice024(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 25 then
          --O
          --//
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice025(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice025(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 26 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice026(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice026(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 27 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice027(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice027(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 28 then
          --S
          --//
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice028(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice028(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 29 then
          --O
          --//
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice029(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice029(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 30 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice030(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice030(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 31 then
          --S
          --//          
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice031(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice031(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 32 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice032(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice032(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 33 then
          --O
          --//          
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice033(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice033(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 34 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice034(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice034(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 35 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice035(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice035(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 36 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice036(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice036(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 37 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice037(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice037(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 38 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice038(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice038(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 39 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice039(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice039(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 40 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice040(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice040(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 41 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice041(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice041(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 42 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice042(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice042(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 43 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice043(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice043(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 44 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice044(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice044(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 45 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice045(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice045(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 46 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice046(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice046(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 47 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice047(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice047(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 48 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice048(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice048(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 49 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice049(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice049(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 50 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice050(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice050(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 51 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice051(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice051(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 52 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice052(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice052(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 53 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice053(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice053(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 54 then
          --S
          --// aqui esta el problema 
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice054(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice054(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 55 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice055(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice055(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 56 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice056(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice056(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 57 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice057(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice057(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 58 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice058(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice058(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 59 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice059(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice059(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 60 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice060(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice060(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 61 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice061(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice061(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 62 then
          --O
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice062(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice062(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 63 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice063(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice063(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 64 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice064(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice064(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 65 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice065(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice065(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 66 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice066(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice066(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 67 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice067(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice067(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 68 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice068(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice068(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 69 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice069(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice069(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 70 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice070(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice070(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 71 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice071(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice071(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 72 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice072(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice072(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 73 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice073(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice073(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 74 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice074(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice074(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 75 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice075(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice075(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 76 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice076(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice076(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 77 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice077(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice077(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 78 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice078(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice078(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 79 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice079(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice079(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 80 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice080(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice080(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 81 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice081(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice081(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 82 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice082(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice082(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 83 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice083(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice083(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 84 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice084(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice084(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 85 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice085(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice085(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 86 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice086(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice086(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 87 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice087(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice087(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 88 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice088(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice088(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 89 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice089(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice089(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 90 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice090(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice090(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 91 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice091(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice091(pn_pgcod, pn_itsuc,
                                                         pn_itmod, pn_ittran,
                                                         pn_itnrel, pn_itord,
                                                         pn_itsbor),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        else
          null;
          --//    
      end case;
      --//
    end loop;
  
    --// Realizar validaciones antes de enviar la trama al ACF
    pc_trmrsp := lc_trmrsp;
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
  end sp_construirTrama;
  --//

  /*******************************************************************************************
  *
  * Inicio de la construccion de la trama CABECERA
  *
  *******************************************************************************************/

  --// R
  function fn_trama_indice001 return varchar2 is
    lc_cmp001 varchar2(100);
  begin
    --//
    lc_cmp001 := 'ByteI';
    return lc_cmp001;
  exception
    when others then
      return '00000';
  end fn_trama_indice001;

  --// R
  function fn_trama_indice002 return varchar2 is
    lc_cmp002 varchar2(100);
  begin
    --//
    lc_cmp002 := 'N';
    return lc_cmp002;
  exception
    when others then
      return '00000';
  end fn_trama_indice002;

  --// R
  function fn_trama_indice003 return varchar2 is
    lc_cmp003 varchar2(100);
  begin
    --//
    select to_char(trunc(sysdate), 'DD') into lc_cmp003 from dual;
    return lc_cmp003;
  exception
    when others then
      return '00000';
  end fn_trama_indice003;

  --// R
  function fn_trama_indice004 return varchar2 is
    lc_cmp004 varchar2(100);
  begin
    --//
    select to_char(trunc(sysdate), 'MM') into lc_cmp004 from dual;
    return lc_cmp004;
  exception
    when others then
      return '00000';
  end fn_trama_indice004;

  --// R
  function fn_trama_indice005 return varchar2 is
    lc_cmp005 varchar2(100);
  begin
    --//
    select to_char(trunc(sysdate), 'YYYY') into lc_cmp005 from dual;
    return lc_cmp005;
  exception
    when others then
      return '00000';
  end fn_trama_indice005;

  --// R
  function fn_trama_indice006 return varchar2 is
    lc_cmp006 varchar2(100);
  begin
    --//
    select to_char(sysdate, 'hh24') into lc_cmp006 from dual;
    return lc_cmp006;
  exception
    when others then
      return '00000';
  end fn_trama_indice006;

  --// R
  function fn_trama_indice007 return varchar2 is
    lc_cmp007 varchar2(100);
  begin
    --//
    select to_char(sysdate, 'mi') into lc_cmp007 from dual;
    return lc_cmp007;
  exception
    when others then
      return '00000';
  end fn_trama_indice007;

  --// R
  function fn_trama_indice008 return varchar2 is
    lc_cmp008 varchar2(100);
  begin
    --//
    lc_cmp008 := '00745';
    return lc_cmp008;
  exception
    when others then
      return '00000';
  end fn_trama_indice008;

  --// R
  function fn_trama_indice009 return varchar2 is
    lc_cmp009 varchar2(100);
  begin
    --//
    lc_cmp009 := '426153';
    return lc_cmp009;
  exception
    when others then
      return '00000';
  end fn_trama_indice009;

  /*******************************************************************************************
  *
  * Inicio de la construccion de la trama DETALLE
  *
  *******************************************************************************************/

  --// R
  function fn_trama_indice010(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp010 varchar2(100);
  begin
    --//
  
    --lc_cmp010 := '7945';
    --Hlaqui 19/04/2022
    If pn_itmod = 489 then 
       lc_cmp010 := '7945';   
    Else
        If pn_itmod = 181 then 
           lc_cmp010 := '7945';   
        Else
           lc_cmp010 := '7944'; 
        End If;
    End If; 
          -- p51 --7947 -- revisar nuevos codigos
          -- kiosco --7948
    return lc_cmp010;
  exception
    when others then
      return '00000';
  end fn_trama_indice010;

  --// R
  function fn_trama_indice011(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp011 varchar2(100) := '';
    ld_fectra date;
    ln_seint  number;
  begin
    --//
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_cmp011
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
  
    return lc_cmp011;
  exception
    when others then
      return ' ';
  end fn_trama_indice011;

  --// R
  function fn_trama_indice012(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp012 varchar2(100);
  begin
    --//  Hlaqui 06/03/2022 - Se agregan codigos proporcionados por Unibanca
    case 
      
      -- rcuadros - INICIO 18/05/2023
      when pn_ittran in (10, 15) and pn_itord = 20 then -- Transacciones: 10 - tranferencias propias, 15 - transf terceros
        lc_cmp012 := '27'; -- Transferencia recibida
      -- rcuadros - FIN 18/05/2023
      -- jlunaf 28/03/2023 - Se añade transaccion 11, 12 (Transf. Tipo de Cambio)
      when pn_ittran in (15, 10, 11, 12) then --jlunaf 16/05/2022 - Se añade transacción 10
        lc_cmp012 := '40'  ; --Transferencia mismo banco (terceros)
      --rcuadros 21/04/2025 - Transferencias al exterior 70
      when pn_ittran in (20, 21, 70) then --Dmanriquec - 08/04/2024 - Se añade transaccion 21 - diferidas M/T
        lc_cmp012 := '48'  ; --Transferencia interbancaria (diferido)
      -- jlunaf 28/03/2023 - Se añade transaccion 31 (TIN M/T)
      --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
      --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
      --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
      when pn_ittran in (30, 31,32,33, 37,38,41) then 
        lc_cmp012 := '90'  ; --Transferencia interbancaria (inmediata)  
      when pn_ittran in (951, 360, 59, 61) then --jlunaf 16/05/2022 - Se añade transacciones de desembolso de crédito y línea
        --Desembolso credito normal 951
        --Ampliación credito 360
        --Desembolso línea normal 59
        --Incremento línea 61
        lc_cmp012 := '21'  ; --Desembolsos de creditos
      when pn_ittran in (600) then -- jlunaf 31/05/2022 - Se añade transacción de Cancelación DPF
        --Cancelacion DPF 600     
        lc_cmp012 := '68'  ;
      else
        lc_cmp012 := '0'  ; --Otros    
    end case;
    
    --lc_cmp012 := '400000';
    --lc_cmp012 := pn_itmod;
    return lc_cmp012;
  exception
    when others then
      return '0';
  end fn_trama_indice012;

  --// S
  function fn_trama_indice013(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp013 varchar2(100);
  begin
    --//
    lc_cmp013 := '0';
    return lc_cmp013;
  exception
    when others then
      return '0';
  end fn_trama_indice013;

  --// R 
  function fn_trama_indice014(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp014 varchar2(100) := 'N';
  begin
    -- jlunaf 05/08/2022 - INICIO - Extornos de transferencias
    If pn_itsbor = 999 then
       lc_cmp014 := 'S';
    End If;
    -- jlunaf 05/08/2022 - FIN
    return lc_cmp014;
  exception
    when others then
      return ' ';
  end fn_trama_indice014;

  --// R
  function fn_trama_indice015(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_aux004 varchar2(100);
    ln_aux004 number := 0;
    ln_conver number(14, 2) := 0.0;
    lc_cmp015 varchar2(100);
    ln_tipcam number := 0;
    ld_fectra date;
    ln_codmda number;
    ln_ordaux number;
  begin
    --//   
    select b1.pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    sp_tipo_cambio(FECHA => ld_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    --//    
        
    --Hlaqui 06/03/2022 - Se modifica para  condicionar los tipos de transaccion y se habilita  la obtención    
    case
       -- jlunaf 28/03/2023 - Se añade transaccion 31
       --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
       --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
       --rcuadros 21/04/2025 - Transferencias al exterior 70
       --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
       when pn_ittran in (30,50,35,31,32,33,37,70,38,41) then --Transferencias Interb.
            --Transferencia TIN Linea O/T 30
            --Transferencia TIN Linea M/T 31
            ln_ordaux := 20;
       when pn_ittran in (942,982,981) then 
            --Pago de Recaurdos 982,981
            --Recargas 942            
            ln_ordaux := 23;
       when pn_ittran in (600) then -- jlunaf 31/05/2022 - Se añade transacción de Cancelación DPF
            --Cancelacion DPF 600     
            ln_ordaux := 5;
       else 
            ln_ordaux := 10;
    end case;
    
    select a.itimp1, a.moneda
      into ln_aux004, ln_codmda
      from fsd016 a
     where a.pgcod = pn_pgcod
       and a.itsuc = pn_itsuc
       and a.itmod = pn_itmod
       and a.ittran = pn_ittran
       and a.itnrel = pn_itnrel
       and a.itord = ln_ordaux --Cuenta Origen --Hlaqui 06/03/2022
       and a.itsbor = 1;
  
    if ln_codmda = 0 then
      ln_conver := ln_aux004 / ln_tipcam;
      lc_cmp015 := lpad(trim(replace(replace(to_char(ln_conver, '9999999D99'),
                                             ',', ''), '.', '')), 14, '0');
    else
      lc_cmp015 := lpad(trim(replace(replace(to_char(ln_aux004, '9999999D99'),
                                             ',', ''), '.', '')), 14, '0');
    end if;
  
    --//               
    return lc_cmp015;
  exception
    when others then
      return '0';
  end fn_trama_indice015;

  --// R
  function fn_trama_indice016(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp016 varchar2(100);
    ln_ordaux number;
  begin
    --//     
    --Hlaqui 06/03/2022 - Se modifica para  condicionar los tipos de transaccion y se habilita  la obtención    
    case
       -- jlunaf 28/03/2023 - Se añade transaccion 31
       --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
       --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
       --rcuadros 21/04/2025 - Transferencias al exterior 70
       --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
       when pn_ittran in (30,50,35,31,32,33,37,70,38,41) then --Transacciones --Hlaqui 14/03/2022 - Se agrega 35
            --Transferencia TIN Linea O/T 30
            --Transferencia TIN Linea M/T 31
            --efectivo movil 50
            ln_ordaux := 20;
       when pn_ittran in (942,982,981) then 
            --Pago de Recaurdos 982,981
            --Recargas 942            
            ln_ordaux := 23;
       when pn_ittran in (600) then -- jlunaf 31/05/2022 - Se añade transacción de Cancelación DPF
            --Cancelacion DPF 600     
            ln_ordaux := 5;
       else 
            ln_ordaux := 10;
    end case;
    
    select lpad(trim(replace(replace(to_char(a.itimp1, '9999999D99'), ',',
                                     ''), '.', '')), 14, '0')
      into lc_cmp016
      from fsd016 a
     where a.pgcod = pn_pgcod
       and a.itsuc = pn_itsuc
       and a.itmod = pn_itmod
       and a.ittran = pn_ittran
       and a.itnrel = pn_itnrel
       and a.itord = ln_ordaux --Cuenta Origen --Hlaqui 06/03/2022
       and a.itsbor = 1;
  
    return lc_cmp016;
  exception
    when others then
      return '0';
  end fn_trama_indice016;

  --// R
  function fn_trama_indice017(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_aux004 varchar2(100);
    ln_aux004 number := 0;
    ln_conver number(14, 2) := 0.0;
    lc_cmp017 varchar2(100);
    ln_tipcam number := 0;
    ld_fectra date;
    ln_codmda number;
    ln_ordaux number;
  begin
    select b1.pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    sp_tipo_cambio(FECHA => ld_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    --Hlaqui 06/03/2022 - Se modifica para  condicionar los tipos de transaccion y se habilita  la obtención    
    case
       -- jlunaf 28/03/2023 - Se añade transaccion 31
       --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
       --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
       --rcuadros 21/04/2025 - Transferencias al exterior 70
       --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
       when pn_ittran in (30,50,35,31,32,33,37,70,38,41) then --Transferencias Interb. --Hlaqui 14/03/2022 - Se agrega 35
            --Transferencia TIN Linea O/T 30
            --Transferencia TIN Linea M/T 31
            --efectivo movil 50
            ln_ordaux := 20;
       when pn_ittran in (942,982,981) then 
            --Pago de Recaurdos 982,981
            --Recargas 942            
            ln_ordaux := 23;
       when pn_ittran in (600) then -- jlunaf 31/05/2022 - Se añade transacción de Cancelación DPF
            --Cancelacion DPF 600     
            ln_ordaux := 5;
       else 
            ln_ordaux := 10;
    end case;
    --//    
    select a.itimp1, a.moneda
      into ln_aux004, ln_codmda
      from fsd016 a
     where a.pgcod = pn_pgcod
       and a.itsuc = pn_itsuc
       and a.itmod = pn_itmod
       and a.ittran = pn_ittran
       and a.itnrel = pn_itnrel
       and a.itord = ln_ordaux --Cuenta Origen --Hlaqui 06/03/2022
       and a.itsbor = 1;
  
    if ln_codmda = 0 then
      ln_conver := ln_aux004 / ln_tipcam;
      lc_cmp017 := lpad(trim(replace(replace(to_char(ln_conver, '9999999D99'),
                                             ',', ''), '.', '')), 14, '0');
    else
      lc_cmp017 := lpad(trim(replace(replace(to_char(ln_aux004, '9999999D99'),
                                             ',', ''), '.', '')), 14, '0');
    end if;
    --//               
    return lc_cmp017;
  exception
    when others then
      return '00000';
  end fn_trama_indice017;

  --// R
  function fn_trama_indice018(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp018 varchar2(100);
    ld_fectra date;
    lc_horaut varchar2(10);
  begin
    select b1.pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select a.ithora
      into lc_horaut
      from fsd015 a
     where a.pgcod = pn_pgcod
       and a.itsuc = pn_itsuc
       and a.itmod = pn_itmod
       and a.ittran = pn_ittran
       and a.itnrel = pn_itnrel;
  
    lc_cmp018 := to_char(ld_fectra, 'yyyymmdd') ||
                 trim(replace(lc_horaut, ':', ''));
    return lc_cmp018;
  exception
    when others then
      return '00000';
  end fn_trama_indice018;

  --// R
  function fn_trama_indice019(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp019 varchar2(100);
    ln_tipcam number := 0;
    ld_fectra date;
  begin
    select b1.pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
    sp_tipo_cambio(FECHA => ld_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    lc_cmp019 := lpad(replace(replace(to_char(ln_tipcam,'FM90D900'), ',', ''), '.', ''), 11, '0'); --Hlaqui 26/01/2022 - Se agrega formato para mostrar correctamente
    return lc_cmp019;
  exception
    when others then
      return '00000';
  end fn_trama_indice019;

  --// R
  function fn_trama_indice020(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp020 varchar2(100);
  begin
    --//
    lc_cmp020 := lpad(trim(to_char(pn_ittran)), 2, '0') ||
                 lpad(trim(to_char(pn_itnrel)), 4, '0');
    return lc_cmp020;
  exception
    when others then
      return '00000';
  end fn_trama_indice020;

  --// R
  function fn_trama_indice021(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp021 varchar2(100);
  begin
    --//
    select trim(replace(a.ithora, ':', ''))
      into lc_cmp021
      from fsd015 a
     where a.pgcod = pn_pgcod
       and a.itsuc = pn_itsuc
       and a.itmod = pn_itmod
       and a.ittran = pn_ittran
       and a.itnrel = pn_itnrel;
  
    return lc_cmp021;
  exception
    when others then
      return '00000';
  end fn_trama_indice021;

  --// R
  function fn_trama_indice022(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp022 varchar2(100);
  begin
    --//
    select to_char(a.itfcon, 'yyyymmdd')
      into lc_cmp022
      from fsd015 a
     where a.pgcod = pn_pgcod
       and a.itsuc = pn_itsuc
       and a.itmod = pn_itmod
       and a.ittran = pn_ittran
       and a.itnrel = pn_itnrel;
    return lc_cmp022;
  exception
    when others then
      return '00000';
  end fn_trama_indice022;

  --// S
  function fn_trama_indice023(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp023 varchar2(100);
    lc_tracet varchar2(100);
    ld_fectra date;
  begin
    --//      
    lc_cmp023 := '00000';
    return lc_cmp023;
  exception
    when others then
      return '00000';
  end fn_trama_indice023;

  --// R
  function fn_trama_indice024(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp024 varchar2(100);
  begin
    --//
    lc_cmp024 := 'O';
    return lc_cmp024;
  exception
    when others then
      return 'O';
  end fn_trama_indice024;

  --// O
  function fn_trama_indice025(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp025 varchar2(100);
  begin
    --//
    select to_char(a1.pgfape, 'yyyymmdd')
      into lc_cmp025
      from fst017 a1
     where a1.pgcod = 1;
    return lc_cmp025;
  exception
    when others then
      return '00000';
  end fn_trama_indice025;

  --// R
  function fn_trama_indice026(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp026 varchar2(100) := '0000';
  begin
    -- jlunaf 31/05/2022 - Se añade case para validar transacción de Cancelación DPF
    case
      when pn_ittran in (600) then
        --Cancelacion DPF 600     
        lc_cmp026 := '6012';
      else
        lc_cmp026 := '6010'; --Otros    
        --revisar codigo para kiosco -- MISMO DE ATM
    end case;
    return lc_cmp026;
  exception
    when others then
      return '00000';
  end fn_trama_indice026;

  --// R  -- Oscar Diaz Yataco
  function fn_trama_indice027(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp027 varchar2(100) := '604';
  begin
    --//
    return lc_cmp027;
  exception
    when others then
      return '00000';
  end fn_trama_indice027;

  --// S
  function fn_trama_indice028(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp028 varchar2(100) := '604';
  begin
    --//
    return lc_cmp028;
  exception
    when others then
      return '00000';
  end fn_trama_indice028;

  --// O
  function fn_trama_indice029(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp029 varchar2(100) := '604';
  begin
    --//
    return lc_cmp029;
  exception
    when others then
      return '00000';
  end fn_trama_indice029;

  --// R
  function fn_trama_indice030(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp030 varchar2(100);
    lc_tracet varchar2(100);
    ld_fectra date;
  begin
    --//    
    --Valor UBA
    --jlunaf 16/05/2022 - Se añade case para transacciones de desembolso de crédito y línea
    Case
      when pn_ittran in (951,360,59,61,600) then
        --Desembolso credito normal 951
        --Ampliación credito 360
        --Desembolso línea normal 59
        --Incremento línea 61
        --Cancelación DPF 600 - jlunaf 31/05/2022
        lc_cmp030 := '0100';
      else
        lc_cmp030 := '01';
    end case;
    
    
    return lc_cmp030;
  exception
    when others then
      return '00000';
  end fn_trama_indice030;

  --// S
  function fn_trama_indice031(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp031 varchar2(100) := ' ';
    ld_fectra date;
    ln_seint  number;
  begin
    --//                 
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_cmp031
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
  
    return lc_cmp031;
  exception
    when others then
      return '00000';
  end fn_trama_indice031;

  --// R
  function fn_trama_indice032(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp032 varchar2(100);
  begin
    --Se el valor en duro debido a que no se tiene este valor en las transacciones
    lc_cmp032 := '64';
    return lc_cmp032;
  exception
    when others then
      return '00000';
  end fn_trama_indice032;

  --// O
  function fn_trama_indice033(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp033 varchar2(100);
  begin
    --//
    lc_cmp033 := '0';
    return lc_cmp033;
  exception
    when others then
      return '00000';
  end fn_trama_indice033;

  --// R
  function fn_trama_indice034(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp034 varchar2(100) := '';
  begin
    --//Se envía el BIN de la Caja 
    lc_cmp034 := '426153';
    return lc_cmp034;
  exception
    when others then
      return '00000';
  end fn_trama_indice034;

  --// R
  function fn_trama_indice035(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp035 varchar2(100);
  begin
    --//Se envía el BIN de la Caja   
    lc_cmp035 := '426153';
    return lc_cmp035;
  exception
    when others then
      return '00000';
  end fn_trama_indice035;

  --// R
  function fn_trama_indice036(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp036 varchar2(100);
  begin
    --//
    lc_cmp036 := lpad(trim(to_char(pn_ittran)), 2, '0') ||
                 lpad(trim(to_char(pn_itnrel)), 4, '0');
    return lc_cmp036;
  exception
    when others then
      return '00000';
  end fn_trama_indice036;

  --// R
  function fn_trama_indice037(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp037 varchar2(100) := '00';
  begin
    return lc_cmp037;
  exception
    when others then
      return lc_cmp037;
  end fn_trama_indice037;

  --// O
  function fn_trama_indice038(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp038 varchar2(100) := '00';
    ld_fectra date;
  begin
    /*If pn_itmod in(489,140) then
          select pgfape into ld_fectra from fst017 where pgcod = 1;
         select TXTORD
          into lc_cmp038
          from fsx016 b
         where b.pgcod = pn_pgcod
           and b.hcmod = pn_itmod
           and b.htran = pn_ittran
           and b.hnrel = pn_itnrel
           and b.hfcon = ld_fectra
           and b.hsucor = pn_itsuc
           and b.txcod = 179
           and b.txoren = 1;
    End If;*/
    return lc_cmp038;
  exception
    when others then
      return lc_cmp038;
  end fn_trama_indice038;

  --// R
  function fn_trama_indice039(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp039 varchar2(100) := '';
  begin
    --//Valor UBA
    lc_cmp039 := '000';
    return lc_cmp039;
  exception
    when others then
      return lc_cmp039;
  end fn_trama_indice039;

  --// R
  function fn_trama_indice040(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp040 varchar2(100) := 'CAJAMB';
    ld_fectra date;
  begin
    /*  --P51 - Dmanriquec - 19/11/2024          
          If pn_itmod = 489 then 
             lc_cmp040 := 'CAJAAPP';   
          Else
             If pn_itmod = 140 then 
                lc_cmp040 := 'CAJAHBK'; 
             Else
                lc_cmp040 := 'P51APP'; 
             End If;
          End If;
          --P51 - Dmanriquec - 19/11/2024
          -- KIOS001*/
    case
      when pn_itmod = 489 then
        lc_cmp040 := 'CAJAAPP';
      when pn_itmod = 140 then
        lc_cmp040 := 'CAJAHBK';
      when pn_itmod = 181 then
        lc_cmp040 := 'P51APP';
      when pn_itmod = 176 then
        lc_cmp040 := 'KIOSCO';

            /*select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
            select TXTORD
            into lc_cmp040
            from fsx016 b
           where b.pgcod = 1
             and b.hcmod = 489
             and b.htran = 30
             and b.hnrel = 1357
             and b.hfcon = '29/11/2024'
             and b.hsucor = 907
             and b.txcod = 178
             and b.txoren = 1;*/
            
    end case;
    return lc_cmp040;
  exception
    when others then
      return lc_cmp040;
  end fn_trama_indice040;

  --// R
  function fn_trama_indice041(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp041 varchar2(100) := ' '; --Hlaqui 06/03/2022
    ld_fectra date;
--Parametros para envio correo
    p_c_coderr varchar2(100);
    p_c_deserr varchar2(100);
    Destino varchar2(100);
    DestinoCC varchar2(100);
    Emisor varchar2(100);
    Asunto varchar2(100);
    Mensaje CLOB;
  begin
    --Hlaqui 06/03/2022
    case 
      -- rcuadros inicio 18/05/2023
      when pn_ittran in (10, 15) and pn_itord = 20 then -- Transacciones: 10 - tranferencias propias, 15 - transf terceros
        lc_cmp041 := 'AQPTRANSFRECIB';
      -- rcuadros fin 18/05/2023
      --jlunaf 19/08/2022 - Se añade transf. internas
      -- jlunaf 28/03/2023 - Se añaden transacciones 11, 12 y 31
      --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
      --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
      --rcuadros 21/04/2025 - Transferencias al exterior 70
      --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
      when pn_ittran in (15,20,21,10,11,12,30,31,32,33,37,70,38,41) then 
          --Trans. internas 10, 11, 12
          --Trans. terceros CM 15
          --Transf CCE otro tit-CajaMovil 20
          --Transferencia TIN Linea O/T 30
          --Transferencia TIN Linea M/T 31
          --Dmanriquec -08/04/2024 - Transf CCE mismo tit-CajaMovil 21
          /*If pn_itmod = 489 then --Hlaqui 14/03/2022
             lc_cmp041 := 'AREQUIPAAPP';   
          Else
             lc_cmp041 := 'AREQUIPAHBK'; 
          End If;  */
          /*If pn_itmod = 489 then --Hlaqui 14/03/2022
             lc_cmp041 := 'AREQUIPAAPP';   
          Else
             If pn_itmod = 140 then 
                lc_cmp041 := 'AREQUIPAHBK'; 
             Else
                lc_cmp041 := 'P51APP'; 
             End If;
          End If; -- añadir modulo PAMPKIOS001*/
          case
            when pn_itmod = 489 then
              lc_cmp041 := 'AREQUIPAAPP';
            when pn_itmod = 140 then
              lc_cmp041 := 'AREQUIPAHBK';
            when pn_itmod = 181 then
              lc_cmp041 := 'P51APP';
            when pn_itmod = 176 then
              lc_cmp041 := 'KIOSCO';
            /*select a1.pgfape into ld_fectra from fst017 a1 where a1.pgcod = 1;
                select TXTORD
                into lc_cmp041
                from fsx016 b
               where b.pgcod = pn_pgcod
                 and b.hcmod = pn_itmod
                 and b.htran = pn_ittran
                 and b.hnrel = pn_itnrel
                 and b.hfcon = ld_fectra
                 and b.hsucor = pn_itsuc
                 and b.txcod = 178
                 and b.txoren = 1;
              --lc_cmp040 := 'PAMPKIOS001';*/
          end case;

      when pn_ittran in (942,982,981) then 
          --Pago de Recaurdos 982,981
          --Recargas 942 
          --lc_cmp041 := 'AREQUIPAPAGO';  
          --P51 - Dmanriquec - 19/11/2024
          If pn_itmod = 181 then
            lc_cmp041 := 'P51PAGO';  
          Else
            lc_cmp041 := 'AREQUIPAPAGO';  
          End If;
          --P51 - Dmanriquec - 19/11/2024
      when pn_ittran in (50) then 
          --Envio Efectivo Movil 50
          --lc_cmp041 := 'AREQUIPAEFECTIV'; 
                    --P51 - Dmanriquec - 19/11/2024
          If pn_itmod = 181 then
            lc_cmp041 := 'P51APP';  
          Else
            lc_cmp041 := 'AREQUIPAEFECTIV';  
          End If;
          --P51 - Dmanriquec - 19/11/2024
      when pn_ittran in (35) then --Hlaqui 31/03/2022
          --Pago de Tarjeta de Credito 35
          --lc_cmp041 := 'AQPPAGOTC'; 
          --P51 - Dmanriquec - 19/11/2024
          If pn_itmod = 181 then
            lc_cmp041 := 'P51PAGOTC';  
          Else
            lc_cmp041 := 'AQPPAGOTC';  
          End If;
          --P51 - Dmanriquec - 19/11/2024
      when pn_ittran in (951,360,59,61) then --jlunaf 16/05/2022 Se añaden transacciones de desembolso de crédito y línea
          --Desembolso credito normal 951
          --Ampliación credito 360
          --Desembolso línea normal 59
          --Incremento línea 61
          lc_cmp041 := 'DSBLAQP';
      when pn_ittran in (600) then -- jlunaf 31/05/2022 - Se añade transacción de Cancelación DPF
          --Cancelacion DPF 600     
          lc_cmp041 := 'CANCDEPOSITPLZ'; 
      else
          lc_cmp041 := ' '  ; --Otros    
    end case;
      IF Trim(lc_cmp041) IS NULL THEN
        Destino := 'produccion@cajaarequipa.pe';
        DestinoCC := 'dmanriquec@cajaarequipa.pe;hlaqui@cajaarequipa.pe;saybar@cajaarequipa.pe;ecarlos@cajaarequipa.pe';
        Emisor := 'alertamonitoreo@cajaarequipa.pe';
        Asunto := 'Revisar Monitoreo Unibanca - btprod';
        Mensaje := '<html>
                      <head><style type="text/css">p{margin:0;}</style></head>
                      <body>
                        <p>Error campo 41</p>
                        <p>Asiento de la operación: </p>
                        <p>Modulo: ' || pn_itmod ||'</p>
                        <p>Transacción: ' || pn_ittran ||'</p>
                        <p>Relación: ' || pn_itnrel ||'</p>
                        <p>Fecha: ' || Sysdate() || '
                      </body>
                    </html>';
          
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => Destino, --produccion
                                         p_destinatarioscc   => DestinoCC,
                                         p_destinatariosbcc  => '',
                                         p_mensaje           => Mensaje,
                                         p_remitente         => Emisor,
                                         p_asunto            => Asunto,
                                         p_tipomensaje       => 'HTML',
                                         p_directorio        => '',
                                         p_archivosadjuntos  => '',
                                         p_c_coderr          => p_c_coderr,
                                         p_c_deserr          => p_c_deserr
                                         );
      End If;
    return lc_cmp041;
  exception
    when others then
      return lc_cmp041;
  end fn_trama_indice041;

  --// R
  function fn_trama_indice042(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp042 varchar2(150) := ' '; --Hlaqui 06/03/2022
    ld_fectra date;
    ln_codent numeric(10);
    --Parametros para envio correo
    p_c_coderr varchar2(100);
    p_c_deserr varchar2(100);
    Destino varchar2(100);
    DestinoCC varchar2(100);
    Emisor varchar2(100);
    Asunto varchar2(100);
    Mensaje CLOB;
  begin
    --Hlaqui 06/03/2022
    case 
      -- rcuadros inicio 18/05/2023
      when pn_ittran in (10, 15) and pn_itord = 20 then -- Transacciones: 10 - tranferencias propias, 15 - transf terceros
           lc_cmp042 := 'Transferencia Recibida';
      -- rcuadros fin 18/05/2023
      --jlunaf 19/08/2022 - Se añade transf. internas
      -- jlunaf 28/03/2023 - Se añaden transacciones 11, 12 y 31
      --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
      --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
      --rcuadros 21/04/2025 - Transferencias al exterior 70
      --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
      when pn_ittran in (15,20,21,30,10,11,12,31,32,33,37,70,38,41) then
          --Trans. internas 10, 11, 12
          --Trans. terceros CM 15
          --Transf CCE otro tit-CajaMovil 20
          --Transferencia TIN Linea O/T 30
          --Transferencia TIN Linea M/T 31
          --Dmanriquec -08/04/2024 - Transf CCE mismo tit-CajaMovil 21
          /*If pn_itmod = 489 then --Hlaqui 14/03/2022
            lc_cmp042 := 'AREQUIPA APP'; 
          Else
            lc_cmp042 := 'AREQUIPA HOMEBANKING'; 
          End If;*/
          --dmanriquec 18/11/2024
         /* If pn_itmod = 489 then --P51 - Dmanriquec - 19/11/2024
             lc_cmp042 := 'AQPAPP ';   
          Else
             If pn_itmod = 140 then 
                lc_cmp042 := 'AQPHBK '; 
             Else
                lc_cmp042 := 'P51APP '; 
             End If;
          End If;*/
          --KIOS 
          
          case
            when pn_itmod = 489 then
              lc_cmp042 := 'AQPAPP ';
            when pn_itmod = 140 then
              lc_cmp042 := 'AQPHBK ';
            when pn_itmod = 181 then
              lc_cmp042 := 'P51APP ';
            when pn_itmod = 176 then
              lc_cmp042 := 'KIOSCO ';
          end case;
          Case
            When pn_ittran in (10,11,12) then
                 lc_cmp042 := lc_cmp042 || 'CAJA MT'; --Internas Mismo titular
            When pn_ittran in (15) then
                 lc_cmp042 := lc_cmp042 || 'CAJA OT'; --Internas Otro titular
            When pn_ittran in (21) then
                 lc_cmp042 := lc_cmp042 || 'DIF MT'; --diferidas Mismo Titular
            When pn_ittran in (20) then
                 lc_cmp042 := lc_cmp042 || 'DIF OT'; --diferidas Otro Titular
            When pn_ittran in (31,41) then
                 lc_cmp042 := lc_cmp042 || 'TIN MT'; -- INMEDIATAS Mismo Titular
            When pn_ittran in (30) then
                 lc_cmp042 := lc_cmp042 || 'TIN OT'; -- INMEDIATAS Otro Titular
            When pn_ittran in (32,37,38) then
                 lc_cmp042 := lc_cmp042 || 'CONTACT'; -- TRANSF A CONTACTO
            When pn_ittran in (33) then
                 lc_cmp042 := lc_cmp042 || 'CONTACT'; -- YP-PLIN
            When pn_ittran in (70) then
                 lc_cmp042 := lc_cmp042 || 'TRF EXT'; -- Transferencia exterior
          end case;
          --dmanriquec 18/11/2024
          
      when pn_ittran in (942,982,981) then 
          --Pago de Recaurdos 982,981
          --Recargas 942 
          select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;  
          select JAQL515COENT into ln_codent
          from JAQL515 
          where JAQL515SCMOD = pn_itmod
          and JAQL515STRAN = pn_ittran
          and JAQL515SNREL = pn_itnrel
          and JAQL515FEMOV = ld_fectra
          and JAQL515PGCOD = pn_pgcod
          and JAQL515PGSUC = pn_itsuc;
          
          select substr(trim(JAQL508NOENT),1,25) into lc_cmp042
          from JAQL508
          Where JAQL508COENT = ln_codent;
      when pn_ittran in (50) then 
          --Envio Efectivo Movil 50 
          --lc_cmp042 := 'AREQUIPA EFECTIVO';
          --lc_cmp042 := 'EFECTIVO MOVIL';
          --P51 - Dmanriquec - 19/11/2024
          If pn_itmod = 181 then
            lc_cmp042 := 'P51APP EFECTIV';  
          Else
            lc_cmp042 := 'EFECTIVO MOVIL';  
          End If;
          --P51 - Dmanriquec - 19/11/2024
      when pn_ittran in (35) then --Hlaqui 31/03/2022
          --Pago de Tarjeta de Credito 35
         select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1; 
         select trim(a.jaql706refe)
         into lc_cmp042 
         from JAQL706 a 
         where a.JAQL706ITCD = pn_pgcod 
         and JAQL706ITSU  = pn_itsuc
         and JAQL706ITMO  = pn_itmod
         and JAQL706ITTR  = pn_ittran
         and JAQL706ITRE  = pn_itnrel
         and JAQL706ITFC  = ld_fectra;  
      when pn_ittran in (951,360,59,61) then --jlunaf 16/05/2022 Se añaden transacciones de desembolso de crédito y línea
          --Desembolso credito normal 951
          --Ampliación credito 360
          --Desembolso línea normal 59
          --Incremento línea 61
          lc_cmp042 := 'Desembolso Arequipa'; 
      when pn_ittran in (600) then -- jlunaf 31/05/2022 - Se añade transacción de Cancelación DPF
          --Cancelacion DPF 600     
          lc_cmp042 := 'Cancela Arequipa'; 
      else
          lc_cmp042 := ' '  ; --Otros    
    end case;
     If Trim(lc_cmp042) IS NULL THEN

        Destino := 'produccion@cajaarequipa.pe';
        DestinoCC := 'dmanriquec@cajaarequipa.pe;hlaqui@cajaarequipa.pe;saybar@cajaarequipa.pe;ecarlos@cajaarequipa.pe';
        Emisor := 'alertamonitoreo@cajaarequipa.pe';
        Asunto := 'Revisar Monitoreo Unibanca - btprod';
        Mensaje := '<html>
                      <head><style type="text/css">p{margin:0;}</style></head>
                      <body>
                        <p>Error campo 42</p>
                        <p>Asiento de la operación: </p>
                        <p>Modulo: ' || pn_itmod ||'</p>
                        <p>Transacción: ' || pn_ittran ||'</p>
                        <p>Relación: ' || pn_itnrel ||'</p>
                        <p>Fecha: ' || Sysdate() || '
                      </body>
                    </html>';
          
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => Destino, --produccion
                                         p_destinatarioscc   => DestinoCC,
                                         p_destinatariosbcc  => '',
                                         p_mensaje           => Mensaje,
                                         p_remitente         => Emisor,
                                         p_asunto            => Asunto,
                                         p_tipomensaje       => 'HTML',
                                         p_directorio        => '',
                                         p_archivosadjuntos  => '',
                                         p_c_coderr          => p_c_coderr,
                                         p_c_deserr          => p_c_deserr
                                         );
      End If;
    return lc_cmp042;
  exception
    when others then
      return lc_cmp042;
  end fn_trama_indice042;

  --// R
  function fn_trama_indice043(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp043 varchar2(100) := 'PE';
    lc_paisdestino char(3) := '';
    ld_fectra date;
  begin
    --jlunaf 16/05/2022 - Se añade case para evualuar nuevas transacciones
    case
        -- rcuadros inicio 18/05/2023
        when pn_ittran in (10, 15) and pn_itord = 20 then -- Transacciones: 10 - tranferencias propias, 15 - transf terceros
             If pn_itmod = 489 then
                lc_cmp043 := 'App';
             Else
                lc_cmp043 := 'HBK';
             End If;
        -- rcuadros fin 18/05/2023
        when pn_ittran in (951,360) then --jlunaf 16/05/2022
             --Desembolso credito normal 951
             --Ampliación credito 360
             lc_cmp043 := 'prestamo';
        when pn_ittran in (59,61) then --jlunaf 16/05/2022
             --Desembolso línea normal 59
             --Incremento línea 61
             lc_cmp043 := 'de linea';
        when pn_ittran in (600) then -- jlunaf 31/05/2022 - Se añade transacción de Cancelación DPF
             --Cancelacion DPF 600     
             If pn_itmod = 489 then -- jlunaf 31/05/2022
                lc_cmp043 := 'App';   
             Else
                lc_cmp043 := 'HBK'; 
             End If;
        --rcuadros 21/04/2025 - Transferencias al exterior 70
        when pn_ittran in (70) then
          select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
          select aqpc330psd
            into lc_paisdestino
            from aqpc330
           where aqpc330pgc = pn_pgcod
             and aqpc330suc = pn_itsuc
             and aqpc330moc = pn_itmod
             and aqpc330tnc = pn_ittran
             and aqpc330nrc = pn_itnrel
             and aqpc330fec = ld_fectra;
          if pn_itmod = 489 then
            lc_cmp043 := 'App ' || lc_paisdestino;
          else
            lc_cmp043 := 'HBK ' || lc_paisdestino;
          end if;
        else
             lc_cmp043 := 'PE';
    end case;
    return lc_cmp043;
  exception
    when others then
      return lc_cmp043;
  end fn_trama_indice043;

  --// R
  function fn_trama_indice044(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp044 varchar2(100) := 'PE';
  begin
    return lc_cmp044;
  exception
    when others then
      return lc_cmp044;
  end fn_trama_indice044;

  --// O
  function fn_trama_indice045(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp045 varchar2(100) := '00';
  begin
    --// Unibanca indico que no van ceros sino espacios en blanco 
    lc_cmp045 := '00';
    return lc_cmp045;
  exception
    when others then
      return lc_cmp045;
  end fn_trama_indice045;

  --// S
  function fn_trama_indice046(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp046 varchar2(100) := '';
  begin
    --// No aplica porque nuestras tarjetas no son nominadas y no lega el TRACK 1
    lc_cmp046 := ' ';
    return lc_cmp046;
  exception
    when others then
      return lc_cmp046;
  end fn_trama_indice046;

  --// S
  function fn_trama_indice047(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp047 varchar2(100) := '';
  begin
    --// No aplica porque nuestras tarjetas no son nominadas y no lega el TRACK 1   
    lc_cmp047 := ' ';
    return lc_cmp047;
  exception
    when others then
      return lc_cmp047;
  end fn_trama_indice047;

  --// R
  function fn_trama_indice048(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp048 varchar2(100) := '0';
    ln_ordaux number;
  begin
    --//Transacciones en Soles        
  
    --Hlaqui 06/03/2022 - Se modifica para  condicionar los tipos de transaccion y se habilita  la obtención    
    case
       -- jlunaf 28/03/2023 - Se añade transaccion 31
       --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
       --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
       --rcuadros 21/04/2025 - Transferencias al exterior 70
      --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
       when pn_ittran in (30,50,35,31,32,33,37,70,38,41) then --Transferencias Interb. --Hlaqui 14/03/2022 - Se agrega 35
            --Transferencia TIN Linea O/T 30
            --Transferencia TIN Linea M/T 31
            --efectivo movil 50
            ln_ordaux := 20;
       when pn_ittran in (942,982,981) then 
            --Pago de Recaurdos 982,981
            --Recargas 942            
            ln_ordaux := 23;
       when pn_ittran in (600) then -- jlunaf 31/05/2022 - Se añade transacción de Cancelación DPF
            --Cancelacion DPF 600     
            ln_ordaux := 5;
       else 
            ln_ordaux := 10;
    end case;
    
    select case
             when a.moneda = 0 then
              '604'
             else
              '840'
           end
      into lc_cmp048
      from fsd016 a
     where a.pgcod = pn_pgcod
       and a.itsuc = pn_itsuc
       and a.itmod = pn_itmod
       and a.ittran = pn_ittran
       and a.itnrel = pn_itnrel
       and a.itord = ln_ordaux --Cuenta Origen --Hlaqui 06/03/2022
       and a.itsbor = 1;
  
    return lc_cmp048;
  exception
    when others then
      return lc_cmp048;
  end fn_trama_indice048;

  --// S
  function fn_trama_indice049(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp049 varchar2(100) := '0'; --Danny Manrique 21/10/2024 Se inicia variable en 0
    lc_auxtar varchar2(100) := '';
    ln_ordaux number;
  begin
     --Hlaqui 06/03/2022 - Se modifica para  condicionar los tipos de transaccion y se habilita  la obtención    
    case
       -- jlunaf 28/03/2023 - Se añade transaccion 31
       --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
       --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
       --rcuadros 21/04/2025 - Transferencias al exterior 70
       --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
       when pn_ittran in (30,50,35,31,32,37,33,70,38,41) then --Transferencias Interb. --Hlaqui 14/03/2022 - Se agrega 35
            --Transferencia TIN Linea O/T 30
            --Transferencia TIN Linea O/T 31
            --efectivo movill 50
            --Transferencia Linea de YP-Plin Danny Manrique 21/10/2024
            ln_ordaux := 20;
       when pn_ittran in (942,982,981) then 
            --Pago de Recaurdos 982,981
            --Recargas 942            
            ln_ordaux := 23;
       else 
            ln_ordaux := 10;
    end case;
    --// Moneda de la cuenta de la transacción     
    select case
             when a.moneda = 0 then
              '604'
             else
              '840'
           end
      into lc_cmp049
      from fsd016 a
     where a.pgcod = pn_pgcod
       and a.itsuc = pn_itsuc
       and a.itmod = pn_itmod
       and a.ittran = pn_ittran
       and a.itnrel = pn_itnrel
       and a.itord = ln_ordaux --Cuenta Origen --Hlaqui 06/03/2022
       and a.itsbor = 1;
  
    return lc_cmp049;
  exception
    when others then
      return lc_cmp049;
  end fn_trama_indice049;

  --// O
  function fn_trama_indice050(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp050 varchar2(100) := '';
    lc_auxtar varchar2(100);
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    ln_saldo  number;
    ln_tipcam number := 0;
    ld_fectra date;
  begin
    --//        
    -- jlunaf 24/11/2022 - INICIO - Obtención del saldo sumarizado de todas las cuentas asociadas del tarjeta
    lc_cmp050 := '0';
    ln_saldo  := 0;
    
    -- Obtiene tipo de cambio
    select a1.pgfape into ld_fectra from fst017 a1 where a1.pgcod = 1;
    sp_tipo_cambio(FECHA => ld_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    
    -- Obtiene tarjeta habiente para recorrer cuentas asociadas al documento del cliente
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
      
    -- Obtiene saldo sumarizado
    select nvl(sum(case when scmda = 0 then (scsdo / ln_tipcam) else scsdo end), 0) into ln_saldo from fsd011
       where pgcod = 1 and scmod in (21,22) and sccta in 
      (select ctnro from fsr008 where cttfir = 'T' and pepais = ln_codpai and petdoc = ln_tipdoc
          and pendoc = lc_numdoc)
       and scstat = 0;
    lc_cmp050 := lpad(trim(replace(replace(to_char(ln_saldo, '999999999D99'), ',', ''), '.', '')), 14, '0');
    -- jlunaf 27/06/2022 - FIN
    return lc_cmp050;
  exception
    when others then
      return lc_cmp050;
  end fn_trama_indice050;

  --// S dirección del atm 
  function fn_trama_indice051(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp051 varchar2(100) := ' ';
  begin
    --//
    return lc_cmp051;
  exception
    when others then
      return lc_cmp051;
  end fn_trama_indice051;

  --// O
  function fn_trama_indice052(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp052 varchar2(100) := '';
  begin
    --//        
    lc_cmp052 := '0';
    return lc_cmp052;
  exception
    when others then
      return lc_cmp052;
  end fn_trama_indice052;

  --// S
  function fn_trama_indice053(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp053 varchar2(100) := ' ';
    ln_ordaux numeric(10) :=0;
  begin
    lc_cmp053 := ' ';
    --CUENTA ORIGEN
    --Hlaqui 06/03/2022 - Se modifica para  condicionar los tipos de transaccion y se habilita  la obtención    
    case 
       -- Dmanriquec 24/05/2023 - Se añaden las transaccion 600
       when pn_ittran in (600) then
            --Cancelacion DPF Movil  600
            ln_ordaux := 5;
       -- jlunaf 28/03/2023 - Se añade transaccion 31
       --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
       --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
       --rcuadros 21/04/2025 - Transferencias al exterior 70
       --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
       when pn_ittran in (30,50,35,31,11,32,33,37,70,38,41) then --Transacciones --Hlaqui 14/03/2022  - Se agrega pago de tarjeta (35)
            --Transferencia TIN Linea O/T 30
            --Transferencia TIN Linea O/T 31
            --Efectivo Movil 50
            --Transf Tipo Cambio Compra 11
            ln_ordaux := 20;
       when pn_ittran in (942,982,981) then 
            --Pago de Recaudos 982,981
            --Recargas 942         
            ln_ordaux := 23;
       else 
            ln_ordaux := 10; --10,15,12,20
    end case;   
    -- Armado de cuenta para las transacciones 600
    if (pn_ittran = 600) then
         select lpad(to_char(a.ctnro), 9, '0') ||
               lpad(to_char(a.modulo), 3, '0') ||
               lpad(to_char(a.moneda), 3, '0') ||
               lpad(to_char(a.itoper), 9, '0') ||
               lpad(to_char(a.ittope), 3, '0')
          into lc_cmp053
          from fsd016 a
         where a.pgcod = pn_pgcod
           and a.itsuc = pn_itsuc
           and a.itmod = pn_itmod
           and a.ittran = pn_ittran
           and a.itnrel = pn_itnrel
           and a.itord = ln_ordaux --Cuenta Origen
           and a.itsbor = 1;  
    else
         select lpad(to_char(a.ctnro), 9, '0') ||
               lpad(to_char(a.modulo), 3, '0') ||
               lpad(to_char(a.moneda), 3, '0') ||
               lpad(to_char(a.itsubo), 2, '0') ||
               lpad(to_char(a.ittope), 3, '0')
          into lc_cmp053
          from fsd016 a
         where a.pgcod = pn_pgcod
           and a.itsuc = pn_itsuc
           and a.itmod = pn_itmod
           and a.ittran = pn_ittran
           and a.itnrel = pn_itnrel
           and a.itord = ln_ordaux --Cuenta Origen
           and a.itsbor = 1;
    end if;
    
    return lc_cmp053;
  exception
    when others then
      return lc_cmp053;
  end fn_trama_indice053;

  --// S
  function fn_trama_indice054(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp054 varchar2(100) := ' ';
    ld_fectra date;
  begin
    --CUENTA DESTINO
    --Hlaqui 06/03/2022 - Se habilita la obtencion de cuenta destino
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;  
    case
    -- jlunaf 28/03/2023 - Se añade transaccion 31
    --dmanriquec 09/02/2024 - Se añade transaccion 32 (Transf. Cel)y 33(PLIN)
    --hlaqui 26/09/2024 - Se añade transaccion 37 (Transf. Cel)
    --dmanriquec 03/06/2025 - Se añade las transacciones 38 y 41(copias de la 37 y 31 respectivamente)
    when pn_ittran in (30,31,32,33,37,38,41) then         
         --Transferencia TIN Linea O/T 30
         --Transferencia TIN Linea M/T 31
         select trim(a.JAQL706CCID)                 
         into lc_cmp054 
         from JAQL706 a 
         where a.JAQL706ITCD = pn_pgcod 
         and JAQL706ITSU  = pn_itsuc
         and JAQL706ITMO  = pn_itmod
         and JAQL706ITTR  = pn_ittran
         and JAQL706ITRE  = pn_itnrel
         and JAQL706ITFC  = ld_fectra; 
     when pn_ittran in (35) then  --Hlaqui 21/03/2022 - Se agrega tarjeta destino
         --Pago Tarjeta CCE Linea 35                  
         select '0000'||substr(trim(a.JAQL706TACR),1,6)|| substr(trim(a.JAQL706TACR),length(trim(a.JAQL706TACR))-4,5)  --Hlaqui 21/03/2022                
         into lc_cmp054 
         from JAQL706 a 
         where a.JAQL706ITCD = pn_pgcod 
         and JAQL706ITSU  = pn_itsuc
         and JAQL706ITMO  = pn_itmod
         and JAQL706ITTR  = pn_ittran
         and JAQL706ITRE  = pn_itnrel
         and JAQL706ITFC  = ld_fectra;   
          
    when pn_ittran in (20,21) then --Dmanriquec -08/04/2024 - Transf CCE mismo tit-CajaMovil 21
         --Transf CCE otro tit-CajaMovil 20
         select SE115CCIDS
         into lc_cmp054
         from fse115
         where SE115CD = pn_pgcod
         and SE115MD = pn_itmod
         and SE115SU = pn_itsuc
         and SE115TR = pn_ittran
         and SE115RE = pn_itnrel 
         and SE115FC = ld_fectra
         and SE115OR = 39 
         and SE115SBOR = 1 ; 
    when pn_ittran in (50) then
         --Envio Efectivo Movil 50
         select JAQZ320NUMCEL
         into lc_cmp054
         from JAQZ320 
         where JAQZ320MOD = pn_itmod
         and JAQZ320TRA = pn_ittran
         and JAQZ320REL = pn_itnrel
         and JAQZ320SUC = pn_itsuc
         and JAQZ320FECPRO = ld_fectra
         and JAQZ320PGCOD = pn_pgcod;
    when pn_ittran in (982,981) then  
         --Pago de Recaurdos 982,981        
         lc_cmp054 := ' ';          
    when pn_ittran in (942) then  --Hlaqui 14/03/2022
         --Recargas 942    
         select trim(JAQL515SUMIN)
         into lc_cmp054 
         from jaql515 
         where JAQL515FEMOV= ld_fectra 
         and JAQL515SCMOD  = pn_itmod 
         and JAQL515STRAN  = pn_ittran 
         and jaql515snrel  = pn_itnrel
         and JAQL515PGCOD  = pn_pgcod
         and JAQL515PGSUC  = pn_itsuc;    
         
    when pn_ittran in (942,982,981) then  
         --Pago de Recaurdos 982,981
         --Recargas 942            
         lc_cmp054 := ' ';  
    when pn_ittran in (951,360) then -- jlunaf 16/05/2022 - Se añaden transacciones de desembolso de crédito
         --Desembolso credito normal 951
         --Ampliación credito 360
         select lpad(to_char(a.ctnro), 9, '0') ||
                lpad(to_char(a.modulo), 3, '0') ||
                lpad(to_char(a.moneda), 3, '0') ||
                lpad(to_char(a.itsubo), 2, '0') ||
                lpad(to_char(a.ittope), 3, '0')
                into lc_cmp054
         from fsd016 a
         where a.pgcod = pn_pgcod
            and a.itsuc = pn_itsuc
            and a.itmod = pn_itmod
            and a.ittran = pn_ittran
            and a.itnrel = pn_itnrel
            and a.itord = 81 --Cuenta Destino
            and a.itsbor = 1;
    when pn_ittran in (59,61) then -- jlunaf 16/05/2022 - Se añaden transacciones de desembolso de línea
         --Desembolso línea normal 59
         --Incremento línea 61
         select lpad(to_char(a.ctnro), 9, '0') ||
                lpad(to_char(a.modulo), 3, '0') ||
                lpad(to_char(a.moneda), 3, '0') ||
                lpad(to_char(a.itsubo), 2, '0') ||
                lpad(to_char(a.ittope), 3, '0')
                into lc_cmp054
         from fsd016 a
         where a.pgcod = pn_pgcod
            and a.itsuc = pn_itsuc
            and a.itmod = pn_itmod
            and a.ittran = pn_ittran
            and a.itnrel = pn_itnrel
            and a.itord = 15 --Cuenta Destino
            and a.itsbor = 1;
    when pn_ittran in (600) then -- jlunaf 31/05/2022 - Se añade transacción de Cancelación DPF
         --Cancelación DPF 600
         select lpad(to_char(a.ctnro), 9, '0') ||
                lpad(to_char(a.modulo), 3, '0') ||
                lpad(to_char(a.moneda), 3, '0') ||
                lpad(to_char(a.itsubo), 2, '0') ||
                lpad(to_char(a.ittope), 3, '0')
                into lc_cmp054
         from fsd016 a
         where a.pgcod = pn_pgcod
            and a.itsuc = pn_itsuc
            and a.itmod = pn_itmod
            and a.ittran = pn_ittran
            and a.itnrel = pn_itnrel
            and a.itord = 22 --Cuenta Destino
            and a.itsbor = 1;
    --rcuadros 21/04/2025 - Transferencias al exterior 70
    When pn_ittran = 70 then
         select AQPC330NCD
           into lc_cmp054
           from AQPC330
          where AQPC330PGC = pn_pgcod
            and AQPC330SUC = pn_itsuc
            and AQPC330MOC = pn_itmod
            and AQPC330TNC = pn_ittran
            and AQPC330NRC = pn_itnrel
            and AQPC330FEC = ld_fectra;
    else --Tranferencias interna / Resto de transacciones
          select lpad(to_char(a.ctnro), 9, '0') ||
             lpad(to_char(a.modulo), 3, '0') ||
             lpad(to_char(a.moneda), 3, '0') ||
             lpad(to_char(a.itsubo), 2, '0') ||
             lpad(to_char(a.ittope), 3, '0')
        into lc_cmp054
        from fsd016 a
       where a.pgcod = pn_pgcod
         and a.itsuc = pn_itsuc
         and a.itmod = pn_itmod
         and a.ittran = pn_ittran
         and a.itnrel = pn_itnrel
         and a.itord = 20 --Cuenta Destino
         and a.itsbor = 1;  
    end case;   
              
    return lc_cmp054;
  exception
    when others then
      return lc_cmp054;
  end fn_trama_indice054;

  --// S
  function fn_trama_indice055(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp055 varchar2(100) := '';
  begin
    --//        
    lc_cmp055 := 'VISA';
    return lc_cmp055;
  exception
    when others then
      return lc_cmp055;
  end fn_trama_indice055;

  --// R
  function fn_trama_indice056(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp056 varchar2(100) := ' ';
  begin
    --//  BIN     
    lc_cmp056 := '426153';
    return lc_cmp056;
  exception
    when others then
      return lc_cmp056;
  end fn_trama_indice056;

  --// S Definir descripciones de los eatados de las tarjetas 
  function fn_trama_indice057(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp057 varchar2(100) := ' ';
    lc_auxtar varchar2(100) := ' ';
    ld_fectra date;
    ln_seint  number;
  begin
    --//
    /*
    P: Procesada
    A: Activa
    C: Cancelada
    W: Suspendida
    H: Orden de captura
    F: Posible fraude
    T: Solicita cambio de PIN como primera transacción
    */
    --//                         
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
  
    --//
    select decode(b1.z0e478est, 'AC', 'A', 'BA', 'C', 'BT', 'W')
      into lc_cmp057
      from z0e478 b1
     where b1.z0e478nro = rpad(trim(lc_auxtar),19,' '); --Hlaqui 26/01/2022 - Se completa a 19 espacios
    --//   
    return lc_cmp057;
  exception
    when others then
      return lc_cmp057;
  end fn_trama_indice057;

  --// O 
  function fn_trama_indice058(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp058 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta number;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp058 := ' ';
    --Hlaqui 21/03/2022 - Se agrega indicador de mismo titular
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;  
    case
      when pn_ittran in (35) then  --Hlaqui 21/03/2022
         --Pago Tarjeta CCE Linea 35                  
         select case when a.JAQL706TACR='M' then 'S' else 'N' end
         into lc_cmp058 
         from JAQL706 a 
         where a.JAQL706ITCD = pn_pgcod
         and JAQL706ITSU  = pn_itsuc
         and JAQL706ITMO  = pn_itmod
         and JAQL706ITTR  = pn_ittran
         and JAQL706ITRE  = pn_itnrel
         and JAQL706ITFC  = ld_fectra;
      -- jlunaf 28/03/2023 - Se añade transaccion 11, 12 (Transf. Tipo de Cambio)
      when pn_ittran in (10, 11, 12) then --jlunaf 16/05/2022 - Se añade identificador mismo titular 'S' para transacción 10
         lc_cmp058 := 'S';
      else
         lc_cmp058 := ' ';
    end case;
            
    /*
    -- comentado por indicacion de riesgos/procesos centrales en reunión el viernes 23/03/2019 
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(trim(lc_auxtar), 19, ' ')
       and a1.z0e478est = 'AC';
  
    --// PFEBCO
    if length(trim(lc_numdoc)) <= 8 then
      select nvl(b1.PFEBCO, 'N')
        into lc_cmp058
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp058 := 'N';
    end if;
    --//
    */
    return lc_cmp058;
  exception
    when others then
      return lc_cmp058;
  end fn_trama_indice058;

  --// O
  function fn_trama_indice059(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp059 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp059 := 'T';
    return lc_cmp059;
  exception
    when others then
      return lc_cmp059;
  end fn_trama_indice059;

  --// S
  function fn_trama_indice060(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp060 varchar2(100) := '0';
  begin
    --//        
    lc_cmp060 := '0';
    return lc_cmp060;
  exception
    when others then
      return lc_cmp060;
  end fn_trama_indice060;

  --// R
  function fn_trama_indice061(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp061 varchar2(100) := '0';
  begin
    --//            
    return lc_cmp061;
  exception
    when others then
      return lc_cmp061;
  end fn_trama_indice061;

  --// O
  function fn_trama_indice062(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp062 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp062 := ' ';
    return lc_cmp062;
  exception
    when others then
      return lc_cmp062;
  end fn_trama_indice062;

  --// R
  function fn_trama_indice063(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp063 varchar2(100) := ' ';
    lc_tipdoc char(1);
    lc_numdoc char(12);
    lc_espbla char(1) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    --//
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_cmp063
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
  
    select decode(to_char(b1.z0e478tht), '21', '1', '9', '2', '2', '3', '5',
                  '5'),
           trim(b1.z0e478thd)
      into lc_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_cmp063, 19, ' ');
  
    lc_cmp063 := lc_tipdoc || lpad(trim(lc_numdoc), 12, '0') ||
                 lpad(lc_espbla, 2, ' ');
    dbms_output.put_line('lc_cmp063 : ' || lc_cmp063);
    return lc_cmp063;
  exception
    when others then
      return lc_cmp063;
  end fn_trama_indice063;

  --// S
  function fn_trama_indice064(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp064 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp064 := ' ';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca primer nombre
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    /*select nvl(pfnom1, ' ') into lc_cmp064 from fsd002
     where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;*/
     
    --Dmanriquec 26/03/2024 Inicio
    If ln_tipdoc = 9 then
      select nvl(trim(PJRAZS), ' ') into lc_cmp064 from fsd003
      where PJPAIS = ln_codpai and PJTDOC = ln_tipdoc and PJNDOC = lc_numdoc;
    else 
      select nvl(PFNOM1, ' ') into lc_cmp064 from fsd002
      where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;
    end if;
    --Dmanriquec 26/03/2024 Fin
    -- jlunaf 27/06/2022 - FIN
    /*
    --//               
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
  
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
  
    --//
    if length(trim(lc_numdoc)) <= 8 then
      select nvl(b1.pfnom1, ' ')
        into lc_cmp064
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp064 := ' ';
    end if;
    --//
    */
    return lc_cmp064;
  exception
    when others then
      return lc_cmp064;
  end fn_trama_indice064;

  --// S
  function fn_trama_indice065(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp065 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp065 := ' ';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca segundo nombre
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    select nvl(pfnom2, ' ') into lc_cmp065 from fsd002
     where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;
    -- jlunaf 27/06/2022 - FIN
    /*
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
    --//           
    if length(trim(lc_numdoc)) <= 8 then
      select nvl(b1.pfnom2, ' ')
        into lc_cmp065
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp065 := ' ';
    end if;
    --//
    */
    return lc_cmp065;
  exception
    when others then
      return lc_cmp065;
  end fn_trama_indice065;

  --// S
  function fn_trama_indice066(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp066 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ');
       --and a1.z0e478est = 'AC'; -- jlunaf 27/06/2022 Sin excluir tarjetas no activas
    --//       
    --if length(trim(lc_numdoc)) <= 8 then -- jlunaf 27/06/2022 Carga datos de nacionales y extranjeros
      /*select nvl(b1.pfape1, ' ')
        into lc_cmp066
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;*/
         
    --Dmanriquec 26/03/2024 Inicio
     select nvl(b1.pfape1, ' ') into lc_cmp066 from fsd002 b1
     where b1.pfpais = ln_codpai and b1.pftdoc = ln_tipdoc and b1.pfndoc = lc_numdoc;
    --Dmanriquec 26/03/2024 Fin
    --else -- jlunaf 27/06/2022
    --  lc_cmp066 := ' '; -- jlunaf 27/06/2022
    --end if; -- jlunaf 27/06/2022
    --//        
    return lc_cmp066;
  exception
    when others then
      return lc_cmp066;
  end fn_trama_indice066;

  --// S
  function fn_trama_indice067(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp067 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp067 := ' ';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca segundo apellido
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    select nvl(pfape2, ' ') into lc_cmp067 from fsd002
     where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;
    -- jlunaf 27/06/2022 - FIN
    /*
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
  
    --//
    if length(trim(lc_numdoc)) <= 8 then
      select nvl(b1.pfape2, ' ')
        into lc_cmp067
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp067 := ' ';
    end if;
    --//  
    */ 
    return lc_cmp067;
  exception
    when others then
      return lc_cmp067;
  end fn_trama_indice067;

  --// S
  function fn_trama_indice068(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp068 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp068 := ' ';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca número de documento
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    select nvl(z0e478thd, ' ') into lc_cmp068
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    -- jlunaf 27/06/2022 - FIN
    /*
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
  
    --//
    if length(trim(lc_numdoc)) <= 8 then
      select b1.pfape2
        into lc_cmp068
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
      lc_cmp068 := lc_numdoc;
    else
      --// 
      lc_cmp068 := ' ';
    end if;
    */
    return lc_cmp068;
  exception
    when others then
      return lc_cmp068;
  end fn_trama_indice068;

  --// O
  function fn_trama_indice069(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp069 varchar2(100) := '0';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp069 := '0';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca fecha de nacimiento
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    select nvl(to_char(pffnac, 'YYYYMMDD'), '0') into lc_cmp069 from fsd002
     where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;
    -- jlunaf 27/06/2022 - FIN
    /*
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
    --//
    if length(trim(lc_numdoc)) <= 8 then
      select to_char(b1.pffnac, 'YYYYMMDD')
        into lc_cmp069
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp069 := '0';
    end if;
    --//     
    */   
    return lc_cmp069;
  exception
    when others then
      return lc_cmp069;
  end fn_trama_indice069;

  --// O
  function fn_trama_indice070(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp070 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp070 := ' ';
    /*
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
    --//
    select nvl(c1.ecnom, ' ')
      into lc_cmp070
      from fsd002 b1, fst009 c1
     where b1.pfpais = ln_codpai
       and b1.pftdoc = ln_tipdoc
       and b1.pfndoc = lc_numdoc
       and b1.pfeciv = c1.eccod;
    --//        
    */
    return lc_cmp070;
  exception
    when others then
      return lc_cmp070;
  end fn_trama_indice070;

  --// O
  function fn_trama_indice071(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp071 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp071 := ' ';
    /*
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
    --// 
    select nvl(trim(b1.sngc13dir), ' ')
      into lc_cmp071
      from sngc13 b1
     where b1.sngc13pais = ln_codpai
       and b1.sngc13tdoc = ln_tipdoc
       and b1.sngc13ndoc = lc_numdoc
       and b1.sngc13est = 'H'
       and rownum <= 1
     order by docod desc;
  
    --// 
    */
    return lc_cmp071;
  exception
    when others then
      return lc_cmp071;
  end fn_trama_indice071;

  --// S 72
  function fn_trama_indice072(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp072 varchar2(100) := ' ';
    --//
    --ln_codpai number; -- jlunaf 25/05/2022
    --ln_tipdoc number; -- jlunaf 25/05/2022
    --lc_numdoc char(12); -- jlunaf 25/05/2022
    lc_auxtar varchar2(100) := ' ';
    --ln_numcta numeric; -- jlunaf 25/05/2022
    ld_fectra date;
    --ln_seint  number; -- jlunaf 25/05/2022
  begin
    lc_cmp072 := ' ';
    -- jlunaf 25/05/2022 - INICIO - Se añade email de contacto
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --dmanriquec - se realiza el ajuste para llenar con campos vacioscuando no se encuentre el correo
    select nvl(substr(trim(c1.jaqz205email), 1, 35),' ') into lc_cmp072 from jaqz205 c1 WHERE c1.jaqz205nutar = rpad(lc_auxtar, 19, ' ');
    -- jlunaf 25/05/2022 - FIN
    /*
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select b1.z0e478thp, b1.z0e478tht, b1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and b1.z0e478est = 'AC';
    --//
    select nvl(substr(pextxt, 1, instr(pextxt, '\', 15) - 1), ' ')
      into lc_cmp072
      from Fsx001 c1
     where c1.pepais = ln_codpai
       and c1.petdoc = ln_tipdoc
       and c1.pendoc = lc_numdoc
       and rownum <= 1
     order by pexren desc;
    --//   
    */
    return lc_cmp072;
  exception
    when others then
      return lc_cmp072;
  end fn_trama_indice072;

  --// S 73
  function fn_trama_indice073(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp073 varchar2(100) := '0';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp073 := '0';
    /*
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select b1.z0e478thp, b1.z0e478tht, b1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and b1.z0e478est = 'AC';
    --//
    select nvl(d1.dotelfp, '0')
      into lc_cmp073
      from sngc17 c1, fsr005 d1
     where c1.sngc17pais = d1.pepais
       and c1.sngc17tdoc = d1.petdoc
       and c1.sngc17ndoc = d1.pendoc
       and c1.sngc17dcod = d1.docod
       and c1.sngc17corr = d1.doordp
       and c1.sngc16ttel = 2
       and c1.sngc17ndoc = ln_codpai
       and c1.sngc17tdoc = ln_tipdoc
       and c1.sngc17ndoc = lc_numdoc
       and rownum <= 1
     order by c1.sngc17corr desc;
    --//
    */
    return lc_cmp073;
  exception
    when others then
      return lc_cmp073;
  end fn_trama_indice073;

  --// S 74
  function fn_trama_indice074(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp074 varchar2(100) := '0';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
    ld_fectra date;
    ln_seint  number;
  begin
    lc_cmp074 := '0';
    /*
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
    --//
    select b1.z0e478thp, b1.z0e478tht, b1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and b1.z0e478est = 'AC';
    --//
    select nvl(d1.dotelfp, '0')
      into lc_cmp074
      from sngc17 c1, fsr005 d1
     where c1.sngc17pais = d1.pepais
       and c1.sngc17tdoc = d1.petdoc
       and c1.sngc17ndoc = d1.pendoc
       and c1.sngc17dcod = d1.docod
       and c1.sngc17corr = d1.doordp
       and c1.sngc16ttel = 6
       and c1.sngc17ndoc = ln_codpai
       and c1.sngc17tdoc = ln_tipdoc
       and c1.sngc17ndoc = lc_numdoc
       and rownum <= 1
     order by c1.sngc17corr desc;
    --//
    */
    return lc_cmp074;
  exception
    when others then
      return lc_cmp074;
  end fn_trama_indice074;

  --// S 75
  function fn_trama_indice075(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp075 varchar2(100) := '0';
    --//
    --ln_codpai number; -- jlunaf 25/05/2022
    --ln_tipdoc number; -- jlunaf 25/05/2022
    --lc_numdoc char(12); -- jlunaf 25/05/2022
    lc_auxtar varchar2(100) := ' ';
    --ln_numcta numeric; -- jlunaf 25/05/2022
    ld_fectra date;
    --ln_seint  number; -- jlunaf 25/05/2022
  begin
    --//        
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
       
    select c1.jaqz205celul into lc_cmp075 from jaqz205 c1 WHERE c1.jaqz205nutar = rpad(lc_auxtar, 19, ' ');--jlunaf 25/05/2022 Se añade celular de contacto
    --jlunaf 25/05/2022 comentado por cambio de consulta a tabla jaqz205
    /*
    --//
    select b1.z0e478thp, b1.z0e478tht, b1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and b1.z0e478est = 'AC';
    --//
    select nvl(d1.dotelfp, '0')
      into lc_cmp075
      from sngc17 c1, fsr005 d1
     where c1.sngc17pais = d1.pepais
       and c1.sngc17tdoc = d1.petdoc
       and c1.sngc17ndoc = d1.pendoc
       and c1.sngc17dcod = d1.docod
       and c1.sngc17corr = d1.doordp
       and c1.sngc16ttel in (1, 5, 3, 4)
       and c1.sngc17ndoc = ln_codpai
       and c1.sngc17tdoc = ln_tipdoc
       and c1.sngc17ndoc = lc_numdoc
       and rownum <= 1
     order by c1.sngc17corr desc;
    --//
    */
    return lc_cmp075;
  exception
    when others then
      return lc_cmp075;
  end fn_trama_indice075;

  --// R 76
  function fn_trama_indice076(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp076 varchar2(100) := ' ';
    ld_fectra date;
    ln_seint  number;
  begin
    --//
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_cmp076
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
  
    return lc_cmp076;
  exception
    when others then
      return lc_cmp076;
  end fn_trama_indice076;

  --// I 77
  function fn_trama_indice077(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp077 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp077 := ' ';
    return lc_cmp077;
  exception
    when others then
      return lc_cmp077;
  end fn_trama_indice077;

  --// I 78
  function fn_trama_indice078(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp078 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp078 := ' ';
    return lc_cmp078;
  exception
    when others then
      return lc_cmp078;
  end fn_trama_indice078;

  --// I 79
  function fn_trama_indice079(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp079 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp079 := ' ';
    return lc_cmp079;
  exception
    when others then
      return lc_cmp079;
  end fn_trama_indice079;

  --// S 80
  function fn_trama_indice080(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp080 varchar2(100) := ' ';
    lc_auxtar varchar2(100) := ' ';
    ld_fectra date;
    ln_seint  number;
  begin
    --//
    select pgfape into ld_fectra from fst017 b1 where b1.pgcod = 1;
  
    select substr(trim(b.txtext), 1, 16)
      into lc_auxtar
      from fsx015 b
     where b.pgcod = pn_pgcod
       and b.hcmod = pn_itmod
       and b.htran = pn_ittran
       and b.hnrel = pn_itnrel
       and b.hfcon = ld_fectra
       and b.hsucor = pn_itsuc
       and b.txcod = 100
       and b.txreng = 1;
  
    --//        
    select nvl(to_char(a1.Z0E478FAL, 'YYYYMMDD'), ' ')
      into lc_cmp080
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
    --//
    return lc_cmp080;
  exception
    when others then
      return lc_cmp080;
  end fn_trama_indice080;

  --// I 81
  function fn_trama_indice081(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp081 varchar2(100) := '';
  begin
    --//        
    lc_cmp081 := ' ';
    return lc_cmp081;
  exception
    when others then
      return lc_cmp081;
  end fn_trama_indice081;

  --// R 82
  function fn_trama_indice082(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp082 varchar2(100) := '';
  begin
    --//        
    lc_cmp082 := '1';
    return lc_cmp082;
  exception
    when others then
      return lc_cmp082;
  end fn_trama_indice082;

  --// I 83
  function fn_trama_indice083(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp083 varchar2(100) := '';
  begin
    --//        
    lc_cmp083 := '0';
    return lc_cmp083;
  exception
    when others then
      return lc_cmp083;
  end fn_trama_indice083;

  --// I 84
  function fn_trama_indice084(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp084 varchar2(100) := '';
  begin
    --//        
    lc_cmp084 := '0';
    return lc_cmp084;
  exception
    when others then
      return lc_cmp084;
  end fn_trama_indice084;

  --// I 85
  function fn_trama_indice085(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp085 varchar2(100) := '';
  begin
    --//        
    lc_cmp085 := ' ';
    return lc_cmp085;
  exception
    when others then
      return lc_cmp085;
  end fn_trama_indice085;

  --// I 86
  function fn_trama_indice086(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp086 varchar2(100) := '';
  begin
    --//        
    lc_cmp086 := ' ';
    return lc_cmp086;
  exception
    when others then
      return lc_cmp086;
  end fn_trama_indice086;

  --// I 87
  function fn_trama_indice087(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp087 varchar2(100) := '';
  begin
    --//        
    lc_cmp087 := '0';
    return lc_cmp087;
  exception
    when others then
      return lc_cmp087;
  end fn_trama_indice087;

  --// I 88
  function fn_trama_indice088(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp088 varchar2(100) := '';
  begin
    --//        
    lc_cmp088 := ' ';
    return lc_cmp088;
  exception
    when others then
      return lc_cmp088;
  end fn_trama_indice088;

  --// I 89
  function fn_trama_indice089(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp089 varchar2(100) := '';
  begin
    --//        
    lc_cmp089 := '0';
    return lc_cmp089;
  exception
    when others then
      return lc_cmp089;
  end fn_trama_indice089;

  --// I 90
  function fn_trama_indice090(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp090 varchar2(100) := '';
  begin
    --//        
    lc_cmp090 := ' ';
    return lc_cmp090;
  exception
    when others then
      return lc_cmp090;
  end fn_trama_indice090;

  --// R 91
  function fn_trama_indice091(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_itord  in number,
                              pn_itsbor in number) return varchar2 is
    lc_cmp091 varchar2(100) := '';
  begin
    --//        
    lc_cmp091 := 'ByteF';
    return lc_cmp091;
  exception
    when others then
      return lc_cmp091;
  end fn_trama_indice091;

  --//
  procedure sp_parsearTrama(pn_codcan in varchar2,
                            pc_trmpar in varchar2,
                            pc_coderr out varchar2,
                            pc_msgerr out varchar2) is
    --//
    lc_coderr varchar2(5) := '';
    lc_msgerr varchar2(1000) := '';
    lc_trmpar varchar2(4000) := '';
    ln_indice number := 0;
    --//
    cursor c1 is
      select acf.c_cabdet,
             acf.c_import,
             acf.n_indice,
             acf.n_codigo,
             acf.c_noming,
             acf.c_nomesp,
             acf.c_format,
             acf.c_tipdat,
             acf.n_longit,
             acf.n_decima,
             acf.n_posini,
             acf.n_camiso,
             acf.c_justxt,
             acf.c_jusnum
        from jaql634 acf
       where acf.n_indice < 1000
       order by acf.n_indice;
  begin
    lc_coderr := '00000';
    lc_msgerr := '';
    lc_trmpar := '';
    --// Longitud de la trama
    dbms_output.put_line('LONGITUD TRAMA ACF [' || length(pc_trmpar) || ']');
    --//
    for i in c1 loop
      --//
      lc_trmpar := substr(pc_trmpar, i.n_posini, i.n_longit);
      dbms_output.put_line('TRAMA ACF PARSEADA CAMPO[' ||
                           lpad(trim(to_char(i.n_indice)), 2, '0') ||
                           '], IMPORTANCIA [' || i.c_import || ']' ||
                           ', VALOR : [' || lc_trmpar || ']' --||
                           --', LONGITUD : [' || i.n_longit || ']'
                           );
      --//
    /*
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  lc_trmpar := substr(pc_trmpar, i.n_posini, i.n_longit);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  dbms_output.put_line('TRAMA ACF PARSEADA CAMPO[' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       lpad(trim(to_char(i.n_indice)), 2, '0') ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       '], LONGITUD [' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       lpad(trim(to_char(i.n_longit)), 2, '0') ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       '], TIPO DE DATO [' || i.c_tipdat ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       '], IMPORTANCIA [' || i.c_import || ']' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ', VALOR : [' || lc_trmpar || ']');
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  */
    --//
    end loop;
    --//
    pc_coderr := lc_coderr;
    pc_msgerr := lc_msgerr;
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
  end sp_parsearTrama;

  --//
  procedure sp_logTrama(pn_codcan in char,
                        pc_trmpar in varchar2,
                        pc_obstrm in varchar2,
                        pc_coderr out varchar2,
                        pc_msgerr out varchar2) is
  
    --//
    lc_coderr varchar2(5) := '';
    lc_msgerr varchar2(1000) := '';
    --//
    ln_serenv JAQL635.N_SERENV%type;
    lc_canenv JAQL635.C_CANENV%type;
    ld_fecenv JAQL635.D_FECENV%type;
    lc_horenv JAQL635.C_HORENV%type;
    lc_trmenv JAQL635.C_TRMENV%type;
    lc_obsenv JAQL635.C_OBSENV%type;
    lc_auxvc1 JAQL635.C_AUXVC1%type;
    lc_auxvc2 JAQL635.C_AUXVC2%type;
    lc_auxvc3 JAQL635.C_AUXVC3%type;
    ln_auxnu1 JAQL635.N_AUXNU1%type;
    ln_auxnu2 JAQL635.N_AUXNU2%type;
    ln_auxnu3 JAQL635.N_AUXNU3%type;
    ld_auxda1 JAQL635.D_AUXDA1%type;
    ld_auxda2 JAQL635.D_AUXDA2%type;
    ld_auxda3 JAQL635.D_AUXDA3%type;
  
  begin
    --//
    lc_coderr := '00000';
    lc_msgerr := '';
    --//
    ln_serenv := SQ_CV_LOGACF_TRAMASUNIBANCA.NEXTVAL;
    lc_canenv := lpad(to_char(pn_codcan), 10, '0');
    ld_fecenv := trunc(sysdate);
    lc_horenv := to_char(sysdate, 'HH24:mi:ss');
    lc_trmenv := pc_trmpar;
    lc_obsenv := pc_obstrm;
    lc_auxvc1 := '';
    lc_auxvc2 := '';
    lc_auxvc3 := '';
    ln_auxnu1 := 0;
    ln_auxnu2 := 0;
    ln_auxnu3 := 0;
    ld_auxda1 := null;
    ld_auxda2 := null;
    ld_auxda3 := null;
  
    insert into JAQL635
      (N_SERENV,
       C_CANENV,
       D_FECENV,
       C_HORENV,
       C_TRMENV,
       C_OBSENV,
       C_AUXVC1,
       C_AUXVC2,
       C_AUXVC3,
       N_AUXNU1,
       N_AUXNU2,
       N_AUXNU3,
       D_AUXDA1,
       D_AUXDA2,
       D_AUXDA3)
    values
      (ln_serenv,
       lc_canenv,
       ld_fecenv,
       lc_horenv,
       lc_trmenv,
       lc_obsenv,
       lc_auxvc1,
       lc_auxvc2,
       lc_auxvc3,
       ln_auxnu1,
       ln_auxnu2,
       ln_auxnu3,
       ld_auxda1,
       ld_auxda2,
       ld_auxda3);
  
    commit;
    --//
    pc_coderr := lc_coderr;
    pc_msgerr := lc_msgerr;
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
  end sp_logTrama;

  procedure sp_debugErrorres(pn_codcan in char,
                             pc_trmpar in varchar2,
                             pc_obstrm in varchar2,
                             pc_coderr in varchar2,
                             pc_msgerr in varchar2) is
    --//
    ld_fecenv JAQL635A.D_FECENV%type;
    lc_horenv JAQL635A.C_HORENV%type;
  begin
    --//
    ld_fecenv := trunc(sysdate);
    lc_horenv := to_char(sysdate, 'HH24:mi:ss');
    --//
    insert into JAQL635A
      (C_CANENV,
       D_FECENV,
       C_HORENV,
       C_TRMENV,
       C_OBSENV,
       C_CODERR,
       C_MGSERR)
    values
      (pn_codcan,
       ld_fecenv,
       lc_horenv,
       pc_trmpar,
       pc_obstrm,
       pc_coderr,
       pc_msgerr);
    commit;
  exception
    when others then
      null;
  end sp_debugErrorres;

--//
end PQ_CV_MONITOREO_ACF_MB;
 /* GOLDENGATE_DDL_REPLICATION */
/
