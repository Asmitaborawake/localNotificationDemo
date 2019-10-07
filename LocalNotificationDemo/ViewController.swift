//
//  ViewController.swift
//  LocalNotificationDemo
//
//  Created by Asmita Borawake on 07/10/19.
//  Copyright © 2019 Asmita Borawake. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController ,UNUserNotificationCenterDelegate{
    
    let notificationCenter = UNUserNotificationCenter.current()
   
     
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]) { (sucess, error) in
            
        }
        notificationCall()
    }

    @IBAction func tapOnNotificationClick(_ sender: Any) {
        
       
       
    }
    
    private func notificationCall() {
        
        //content
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "My Category Indentifier"
        content.title = "Local Notification"
        content.body = "This is e.g. of create local notification"
        content.badge =  1
        content.sound = UNNotificationSound.default
        //pass data to other vc use userinfo and send data in dictionery format
        content.userInfo = ["name": "Asmita"]
       
        //content Image
        let url = Bundle.main.url(forResource: "localnotification", withExtension: "png")
        let attachment = try! UNNotificationAttachment(identifier: "image", url: url!, options: [:])
        content.attachments = [attachment]
        //trigger time
        let thisTime:TimeInterval = 60.0
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: thisTime, repeats: true)
        let indenifer = "Main Identifier"
        
        //request
        let request = UNNotificationRequest.init(identifier: indenifer, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            print(error?.localizedDescription)
        }
        
        //add action to notification
        let like = UNNotificationAction.init(identifier: "Like", title: "Like", options: .foreground)
        
        let delete = UNNotificationAction.init(identifier: "Delete", title: "Delete"
            , options: .destructive)
        let catogory = UNNotificationCategory(identifier: content.categoryIdentifier, actions: [like,delete], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([catogory])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
    //for navigating on specific vc on notification click
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        if let dict = response.notification.request.content.userInfo as? [AnyHashable:Any]{
            secondVC.strText = dict["name"] as! String
        }
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}

