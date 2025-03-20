create or replace force view jc_ar_fe_est_doc_v as
select  AQPA471TRXID
        ,aqpa460seri
        ,aqpa460num
        ,aqpa460femi
        ,aqpa460mone
        ,AQPA471TODCO
        ,aqpa460impt
        ,aqpa460nruc
        ,aqpa460rasoc
        ,h.AQPA471STATUS as estado
        ,case
          when h.AQPA471STATUS = 'ACEPTADO' then 'Aceptado'
          when h.AQPA471STATUS = 'PEN_BT'   then 'Pendiente de BT'
          when h.AQPA471STATUS = 'RECHAZADO' then 'Rechazado'
          when h.AQPA471STATUS = 'PEN_ACT_EST' then 'Pendiente Actualizar Estado'
          when h.AQPA471STATUS = 'PEN_EMI' then 'Pendiente Enviar a TCI'
        end as DESC_ESTADO
        ,null as tipo_error
        ,h.AQPA471STATUSD as desc_error
        ,SYSDATE as fecha_proceso
    from aqpa471 h;

