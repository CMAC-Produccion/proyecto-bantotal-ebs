create or replace force view v_itxn_saybar_precon as
select
status, msgno, capdate, datein, timein, dateout, timeout, trace, sys_trace, msgtype, abmdate, abmtime, respcode,
--substr(a.pan,0,6)||'******'||substr(a.pan,13,4) pan,
pan,
--decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
b.z0e478thd,
prcode, facctype, tacctype, acctid1, acctid2, rep_fromacct, rep_toacct, txnamt, compamount, compcdbamt, stlamt, cnvrate_stl,
convdate, cur_tran, cur_stl, refnum, stldate, transdate, transtime, otrdate, otrtime, rev_flag, auth_id, addtl_resp_data, merchant,
payee, pos_cond_code, pos_code_ext, pos_entry_mode, acc_termid, acc_ident, rep_txnamt, rep_stlamt, poa, operator_number, dev_no,
response, card_seq_num, expdate, misc1, misc2, acqinst, acqinstid, issinst, issinstid, stlinst, stlinstid, orginst, orginstid,
reqinst, revreason, orgmsg, otrace, orefnum, odate, otime, oacqinst, oissinst, termid, devicetype, branch, acceptorname, abmloc, track2,
track3, other_fee, isspdagent_fee, isspdswitch_fee, isspdnetwork_fee, acqpdagent_fee, acqpdswitch_fee, acqpdnetwork_fee, acq_fee, region_fee,
bitmap, cdbamt, cnvrate_cdb, cur_cdb, customer_response, misc, nii, sys_batch, iss_fee, ntwk_private_data, iso_acqinst, iso_issinst,
iso_stlinst, iso_reqinst, device_data, stl_fee, cnv_fee, net_intl_data, smart_card_data, acq_posting_date, retailer_id, card_scheme_id,
card_scheme_info, notes_given, subscriber_id, terminal_owner, terminal_location, terminal_city, terminal_country, pos_term_data, settlement_code,
batchid, devsettled, merposted, chd_id_method, misc3, issdate, acqdate, acq_cntry_code, othamt, addtl_data, tran_fee
from itxn@TXNSWT a left outer join Z0E478 b
  on a.pan=trim(b.Z0E478NRO)
;

