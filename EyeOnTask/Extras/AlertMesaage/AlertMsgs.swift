//
//  AlertMsgs.swift
//  EyeOnTask
//
//  Created by Mac on 01/11/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation

public class AlertMessage {
    
    static var checkNetwork : String { return LanguageKey.err_check_network}

    static var bothFieldEmpty : String { return LanguageKey.user_name_pass}
    
    static var enterUserName : String { return LanguageKey.user_name}
    
    static var enterPassword : String { return LanguageKey.user_pass}
    
    static var enterKey : String { return LanguageKey.enter_key}
    
    static var enterValidEmail : String { return LanguageKey.email_error}
    
    static var passwordNotMatch : String { return LanguageKey.frgt_pass_match}
    
    static var checkVersion : String { return LanguageKey.new_version_msg}
    
    static var formatProblem : String { return LanguageKey.format_problem}
    
    static var item : String { return LanguageKey.please_add_item}
    
    static var amount : String { return LanguageKey.please_enter_amount}
    
    static var discount : String { return LanguageKey.please_enter_discount}
    
    static var qty : String { return  LanguageKey.please_enter_quality}
    
    static var fieldworker : String { return LanguageKey.please_add_fieldworker}
    
    static var Switch_User_Alert : String { return LanguageKey.switch_user}
    
    static var filterButton : String { return LanguageKey.err_filter_button}

    static var validFieldWorker : String { return LanguageKey.select_valid_field_worker_name_list}
    
    static var addTag : String { return LanguageKey.enter_some_text_without_space}
    
    static var dateMustBeGreater : String { return LanguageKey.start_date_must_less_then_schedule_end_date}
    
    static var selectStartDate : String { return LanguageKey.select_schedule_start_date}
    
    static var selectEndDate : String { return LanguageKey.select_schedule_end_date}
    
    static var addFieldWorker : String { return LanguageKey.add_atleast_one_field_worker}
    
    static var validState : String { return LanguageKey.state_error}
    
    static var validCountry : String { return LanguageKey.country_error}
    
    static var selectCountry : String { return LanguageKey.please_select_country_first}
    
    static var validAddress : String { return LanguageKey.err_addr}
    
    static var clientName : String { return LanguageKey.add_client_name}
    
    static var jobPriority : String { return LanguageKey.select_job_priority_from_list}
    
    static var jobTitle : String { return LanguageKey.enter_job_title}
    
    static var noJobTitleAvailable : String { return LanguageKey.no_job_title_available}
    
    static var noFieldWorkerAvailable : String { return LanguageKey.no_fw_available}
    
    static var noTagAvailable : String { return LanguageKey.no_tag_available}
    
    static var rejectJob : String { return LanguageKey.do_you_want_reject_this_job}
    
    static var cancelJob : String  { return LanguageKey.do_you_want_can_this_job}
    
    static var locationNotAvailable : String { return LanguageKey.location_not_available}
    
    static var descriptionNotAvailable : String { return LanguageKey.desc_no}
    
    static var instructionNotAvailable : String { return LanguageKey.no_inst}
    
    static var emailNotAvailable : String { return LanguageKey.job_det_email}
    
    static var chatNotAvailable : String { return LanguageKey.no_avail}
    
    static var contactNotAvailable : String { return LanguageKey.no_contact_available}
    
    static var twitterApp : String { return LanguageKey.install_the_twitter_app}
    
    static var skypeApp : String { return LanguageKey.install_the_skype_app}
    
    static var changeImageName : String { return LanguageKey.do_you_want_change_name_image}
    
    static var updated : String { return LanguageKey.updated_successfully}
    
    static var selectAnyForm : String { return LanguageKey.fill_all_mandatory_questions}
    
    static var addClientMobileNumber : String { return LanguageKey.c_e_mob}
    
    static var siteName : String { return LanguageKey.err_site_name}
    
    static var city : String { return LanguageKey.enter_city}

    static var enterClientName : String { return LanguageKey.cont_name}
    
    static var validAltMobNo : String { return LanguageKey.enter_alternate_mobile_number}
    
    static var validAlMobileNo : String { return LanguageKey.enter_valid_alternate_mobile_number}
    
    static var validMobileNo : String { return LanguageKey.enter_valid_mobile_number}
    
    static var contactUpdate : String { return LanguageKey.contact_updated_successfully}
    
    static var siteUpdate : String { return LanguageKey.site_update}
    
    static var contactAdd : String { return LanguageKey.contact_added_successfully}
    
    static var siteAdd : String { return LanguageKey.site_add}
    
    static var clientUpdate : String { return LanguageKey.clt_updated}
    
    static var clientAdd : String { return LanguageKey.clt_added}
    
    static var itemRemove : String { return LanguageKey.item_remove};
   
    static var itemRemoveAllItem : String { return LanguageKey.remove_item_mandtry};
    
    static var discountError : String { return LanguageKey.discountError};
    
    static var noneitems : String { return LanguageKey.no_invoice };
    
    static var nonPaymentType : String { return LanguageKey.select_payment_type};
    
    static var enterAmount : String { return LanguageKey.please_enter_amount};
    
    static var add : String { return LanguageKey.added_successfully}
    
    static var upDate : String { return LanguageKey.item_updated}
    
    static var delete : String { return LanguageKey.deleted_successfully}
    
    static var subject : String { return LanguageKey.enter_subject}
    
    static var validEmailid : String { return LanguageKey.enter_valid_receipt_email_id}
    
    static var message : String { return LanguageKey.input_text_email}
    
    static var userId : String { return LanguageKey.enter_receipt_email_id}
    
    static var validMobile : String { return LanguageKey.enter_valid_mobile_number}
    
    static var validEmail : String { return LanguageKey.email_empty}
    
    static var validEmailId : String { return LanguageKey.email_error}
    
    static var atleastOneQuantity : String { return LanguageKey.please_enter_atleast_one_quantity}
    
    static var removeJobFromAdmin : String { return LanguageKey.admin_removed_you_from_this_job}
    
    static var clearOfflinePendings : String { return LanguageKey.switch_user}
    
    static var invoiceNotGenerate : String { return LanguageKey.no_Item_generate_inv}
    
    static var invoiceAndPreview : String { return LanguageKey.Invoice_priview}
    
    static var photo_denied : String { return LanguageKey.photo_denied}
    
    static var networkIssue : String { return LanguageKey.payment_ntwrk}
    
    static var paymentRecieved : String { return LanguageKey.payment_recv}
    
    static var mailSend : String { return LanguageKey.mail_success}
    
    static var Note_not_available : String { return LanguageKey.note_not_available}
    
    static var cant_open_this_file : String { return LanguageKey.file_cant_open}
    
    static var sorryThisJobNoLonger : String { return LanguageKey.job_no_available}
    
    static var do_not_use_this_name : String { return LanguageKey.Please_do_not_use_site_name}
    
    static var location_app_setting : String { return LanguageKey.location_app_setting}
    
    static var items_screen_title : String { return LanguageKey.items_screen_title}
    
    static var frm_updated : String { return LanguageKey.frm_updated}
    
    static var service_error : String { return LanguageKey.service_error}
    
    static var err_job_title : String { return LanguageKey.err_job_title}
    
    static var err_start_end_time : String { return LanguageKey.err_start_end_time}
    
    static var please_select_start_date : String { return LanguageKey.please_select_start_date}
    
    static var linked : String { return LanguageKey.linked}
    
    static var unlinked : String { return LanguageKey.unlinked}
    
    static var customer_sign_required : String { return LanguageKey.customer_sign_required}
    
    static var sign_uploaded : String { return LanguageKey.sign_uploaded}
    
    static var check_in_out_fail : String { return LanguageKey.check_in_out_fail}
    
    static var no_suggesstion : String { return LanguageKey.no_suggesstion}
    
    static var item_added : String { return LanguageKey.item_added}
    
    static var cont_name : String { return LanguageKey.cont_name}
    
    static var err_site_name : String { return LanguageKey.err_site_name}
    
    static var select_date_range : String { return LanguageKey.select_date_range}
    
    
}



