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
    /**
     前回の通知から一定時間以上経過していればローカル通知を飛ばす
     
     - parameter message:  表示メッセージ
     */
    static func postLocalNotificationIfNeeded(message: String, major: Int, minor: Int) {
//        if !shouldNotifyWithMessage(message: message, major: major, minor: minor) {
//            return
//        }
        
        print(message)
        
        // content
        let content = UNMutableNotificationContent()
        content.title = message
        content.body = "バス停が近くにあります"
        content.sound = UNNotificationSound.default()
        
        // trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(0.1), repeats: false)
        
        // request includes content & trigger
        let request = UNNotificationRequest(identifier: "test",
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
    
    /**
     通知可否を返す。
     前回の通知から一定時間経過していれば通知可
     
     - parameter message: 表示メッセージ
     
     - returns: true:通知可/false:通知不可
     */
    private static func shouldNotifyWithMessage(message: String, major: Int, minor: Int) -> Bool {
        // major minorの値を実際に設定した値にする。
        if major == 1 && minor == 65535 {
            
            return true
        }
        
        return false
    }
}
