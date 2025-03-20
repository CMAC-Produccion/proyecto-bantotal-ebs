create or replace force view v_aqpa568 as
(select employee_id ,PREPAY_NUM,EXPENSE_LAST_STATUS_DATE, EXPENSE_STATUS_CODE,INVOICE_NUM, DESCRIPTION, DEFAULT_CURRENCY_CODE
 from ap_expense_report_headers_all@erp);

