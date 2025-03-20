create or replace force view v_aqpa567 as
(select  employee_id, last_update_date, last_updated_by, last_update_login, creation_date, created_by, employee_num,
 full_name, first_name, middle_name, last_name, prefix ,expense_check_address_flag, email_address, attribute1, attribute2,
  attribute3, attribute4, attribute5, attribute_category from  hr_employees@erp );

