//
//  SideMenuModel.swift
//  EyeOnTask
//
//  Created by Mac on 30/05/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

struct SideMenuModel {
    var id = Int()
    var name = String()
    var subMenu = [Any]()
    var image = String()
    var isCollaps = false
}


class SideMenu: NSObject {
    static func getModel() -> ([SideMenuModel],Int) {
        var menus = [SideMenuModel]()
        var languageIndex = 0
        
        //==================
        var CheckInTime = ""
        var second = 30
        var timer:Timer?
        
        second -= 1
        CheckInTime = String("00:\(second)")
        
        if second == 0 {
            
            second = 30
            
            timer?.invalidate()
            timer = nil
        }
       //========
        
        var checkButtonTitle = ""
        if let check = getCheckInId() {
            if check == "" {
                checkButtonTitle = LanguageKey.check_in
            }else{
                
                checkButtonTitle = LanguageKey.check_out
            }
        }else{
            checkButtonTitle = LanguageKey.check_in
        }
        
        
        
        //====================================
        // for append CHECKIN CHECKOUT section
        //====================================
        let checkinModel = SideMenuModel(id: 4, name:checkButtonTitle , subMenu: [], image: "History_icon_selected", isCollaps: false)
        menus.append(checkinModel)
        
        //=========================
        // for append Expence section
        //=========================
          
        if isPermitForShow(permission: permissions.isSchedular) == true{
        if isPermitForShow(permission: permissions.isAppointmentVisible) == true{
            let expence = SideMenuModel(id: 10, name: LanguageKey.title_appointments, subMenu: [], image: "Appointment", isCollaps: false)
        menus.append(expence) // for Appointment
             }
        }
             
        
        //=========================
        // for append JOBS section
        //=========================
        let jobModel = SideMenuModel(id: 1, name: LanguageKey.jobs, subMenu: [], image: "job_icon", isCollaps: false)
        menus.append(jobModel) // for JOBS
        
        
        
        //=========================
        // for append Audit section
        //=========================
         if isPermitForShow(permission: permissions.isAuditVisible) == true{
        let auditModel = SideMenuModel(id: 6, name: LanguageKey.audit_nav, subMenu: [], image: "audit_icon", isCollaps: false)
        menus.append(auditModel) // for Audit
        }
        
        /////////////////////////////////////// for futer use creat any new modul ///////////////////////////////
        //=========================
        // for append Equipment section
        //=========================
        // if isPermitForShow(permission: permissions.isAuditVisible) == true{
//        let equipmentModel = SideMenuModel(id: 11, name: "Equipment", subMenu: [], image: "equip", isCollaps: false)
//        menus.append(equipmentModel) //
        // }
               
        ///////////////////////////////////////
        
        
        //===========================
        // for append CLIENTS section
        //===========================
        if isPermitForShow(permission: permissions.isClientVisible) == true{
            let clientModel = SideMenuModel(id: 2, name: LanguageKey.clients, subMenu: [], image: "Clien_icon", isCollaps: false)
            menus.append(clientModel)
        }
        
        
        //===========================
        // for append CLIENTS section
        //===========================
        if isPermitForShow(permission: permissions.isQuoteVisible) == true{
            let quoteModel = SideMenuModel(id: 5, name: LanguageKey.quotes, subMenu: [], image: "Quoteimg", isCollaps: false)
            menus.append(quoteModel)
        }
        
        //=========================
        // for append Barcode section// jugal
        //=========================
          if isPermitForShow(permission: permissions.isAuditVisible) == true{
        
        if let enableCustomForm = getDefaultSettings()?.isEquipmentEnable{ //This is round off digit for invoice
                                               if enableCustomForm == "1"{
        let BarcodeModel = SideMenuModel(id: 7, name: LanguageKey.detail_scan_barcode, subMenu: [], image: "qr-code_icon", isCollaps: false)
        menus.append(BarcodeModel) // for Barcode
            }}
        }
        //=========================
        // for append Admin Chats
        //=========================
                
        
        if let enableOnetoOneChat = getDefaultSettings()?.isOnetoOneChatEnable{ //This is round off digit for invoice
            if enableOnetoOneChat == "1"{
                let AdminChats = SideMenuModel(id: 8, name: LanguageKey.side_menu_title_chats, subMenu: [], image: "chat-icon", isCollaps: false)
                menus.append(AdminChats) // for AdminChats
            }
        }else{
            let AdminChats = SideMenuModel(id: 8, name: LanguageKey.side_menu_title_chats, subMenu: [], image: "chat-icon", isCollaps: false)
            menus.append(AdminChats) // for AdminChats
        }
        
        //=========================
        // for append Expence section
        //=========================
        
        if isPermitForShow(permission: permissions.isExpenseVisible) == true{
                let expence = SideMenuModel(id: 9, name: LanguageKey.title_expence, subMenu: [], image: "Expense 2", isCollaps: false)
                  menus.append(expence) // for Expence
        }
        
        //====================================
        // for append Check In/Out Report section
        //====================================
        
        if isPermitForShow(permission: permissions.isCheckInOutDownload) == true{
            let expence = SideMenuModel(id: 12, name: LanguageKey.title_report, subMenu: [], image: "Report111", isCollaps: false)
            menus.append(expence) // for Expence
        }
        
        //====================================
        // for append Time Sheet Report section
        //====================================
        
        if isPermitForShow(permission: permissions.isTimeSheetEnableMobile) == true{
            let TimeSheet = SideMenuModel(id: 13, name: LanguageKey.title_timeSheet, subMenu: [], image: "Vector", isCollaps: false)
            menus.append(TimeSheet) // for Expence
        }
        
        //====================================
        // for append Leave section
        //====================================
        
        if isPermitForShow(permission: permissions.isLeaveAddEnable) == true{
            let Leave = SideMenuModel(id: 14, name:LanguageKey.user_leave, subMenu: [], image: "leave_icon_3", isCollaps: false)
            menus.append(Leave) // for Expence
        }
        
     
        //============================
        // for append LANUGAGE section
        //============================
        
//        if getDefaultSettings()?.language?.isLock == "0" {
//                 var lang = ""
//                 if let selectedLang = getCurrentSelectedLanguage() {
//                     lang = "\(LanguageKey.settings) (\(selectedLang))"
//                 }
//                 let languageModel = SideMenuModel(id: 3, name: lang, subMenu: getDefaultSettings()!.languageList!, image: "Group 224", isCollaps: false)
//                 menus.append(languageModel)
//                 languageIndex = menus.endIndex - 1
//             }
//        if getDefaultSettings()?.language?.isLock == "0" {
//            var lang = ""
//            if let selectedLang = getCurrentSelectedLanguage() {
//                lang = "\(LanguageKey.language) (\(selectedLang))"
//            }
        
        
           // let languageModel = SideMenuModel(id: 3, name: "Settings", subMenu: [], image: "Group 224", isCollaps: false)
           // menus.append(languageModel)
//            languageIndex = menus.endIndex - 1
//        }
        
        
        return (menus,languageIndex)
    }
}
