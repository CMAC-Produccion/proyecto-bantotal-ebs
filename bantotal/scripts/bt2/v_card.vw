create or replace force view v_card as
select substr(pan,0,6)||'******'||substr(pan,13,4) pan,
--decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
bin, subinstid, alt_acct_id, status, tracking, useoffset, offset, retries, maxretries, batch, exp_date, re_order, card_type,
currency, altcurrency, atm_priv, pos_priv, lang_code, memo, datein, timein, datelast, timelast, dateact, timeact, atm_ofd_limflag,
atm_ond_limflag, atm_ofw_limflag, atm_onw_limflag, atm_ofm_limflag, atm_onm_limflag, pos_ofd_limflag, pos_ond_limflag, pos_ofw_limflag,
pos_onw_limflag, pos_ofm_limflag, pos_onm_limflag, on_wdcount, on_wdamt, on_altwdcount, on_altwdamt, off_wdcount, off_wdamt, off_altwdcount,
off_altwdamt, wdamttxn, wdcnttot, wdamttot, altwdamttxn, altwdcnttot, altwdamttot, onwdamttxn, onwdcnttot, onwdamttot, onaltwdamttxn,
onaltwdcnttot, onaltwdamttot, on_pwdcount, on_pwdamt, on_paltwdcount, on_paltwdamt, off_pwdcount, off_pwdamt, off_paltwdcount, off_paltwdamt,
pwdamttxn, pwdcnttot, pwdamttot, paltwdamttxn, paltwdcnttot, paltwdamttot, ponwdamttxn, ponwdcnttot, ponwdamttot, ponaltwdamttxn,
ponaltwdcnttot, ponaltwdamttot, linecredit, altlinecred, wddate, wdtime, track2len,
track2,
fname, mname, lname, title, gender, birthdate,
marital_stat, bank_region_code, address1, address2, city, prov, country, postal, phone, bphone, card_cat, embossing
from card@TXNSWT a/* left outer join Z0E478 b
  on a.pan=b.Z0E478NRO*/
;

