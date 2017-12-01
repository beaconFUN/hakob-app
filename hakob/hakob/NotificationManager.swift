//
//  NotificationManager.swift
//  hakob
//
//  Created by 佐藤秀輔 on 2017/10/23.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

struct NotificationManager {
    /*
     前回の通知から一定時間以上経過していればローカル通知を飛ばす
     
     - parameter message:  表示メッセージ
     */
    static func postLocalNotificationIfNeeded(message: String, major: Int, minor: Int) {
        if !shouldNotifyWithMessage(message: message) {
            return
        }
        
        print(message)
        
        // content
        let content = UNMutableNotificationContent()
        content.title = message
        content.body = "バス停が近くにあります"
        content.sound = UNNotificationSound.default()
        
        // trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(0.1), repeats: false)
        
        // request includes content & trigger
        let request = UNNotificationRequest(identifier: "correct",
                                            content: content,
                                            trigger: trigger)
        
        // schedule notification by adding request to notification center
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func postLocalNotificationIfNeeded(message: String) {
        if !shouldNotifyWithMessage(message: message) {
            return
        }
        
        print(message)
        
        // content
        let content = UNMutableNotificationContent()
        content.title = "違うよ！"
        content.body = "このバス停ではありません"
        content.sound = UNNotificationSound.default()
        
        // trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(0.1), repeats: false)
        
        // request includes content & trigger
        let request = UNNotificationRequest(identifier: "wrong",
                                            content: content,
                                            trigger: trigger)
        
        // schedule notification by adding request to notification center
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    /*
     通知可否を返す。
     前回の通知から一定時間経過していれば通知可
     
     - parameter message: 表示メッセージ
     
     - returns: true:通知可/false:通知不可
     */
    private static func shouldNotifyWithMessage(message: String) -> Bool {
        let defaults = UserDefaults.standard
        let key = message
        let now = NSDate()
        let date = defaults.object(forKey: key)
        
        defaults.set(now, forKey: key)
        defaults.synchronize()
        
        if let date = date as? NSDate {
            let remainder = now.timeIntervalSince(date as Date)
            let threshold: TimeInterval = 1.0 * 3 // 3秒
            return (remainder > threshold)
        }
        
        return true
    }
}
