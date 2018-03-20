//
//  LocalNotificationManager.swift
//  AvantariApp
//
//  Created by Sanjay Shingarwad on 14/03/18.
//  Copyright © 2018 Sanjay Shingarwad. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    
     func register() {
        // Request Notification Settings
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                })
            case .authorized:
                // Schedule Local Notification
                print("Authoriezed")
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    // MARK: - Private Methods
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    func scheduleLocalNotification(chartEntityValue:Int) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Avantari App"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "Repeated index value \(chartEntityValue)."
        notificationContent.sound  = UNNotificationSound(named: "notification.mp3")
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
}
