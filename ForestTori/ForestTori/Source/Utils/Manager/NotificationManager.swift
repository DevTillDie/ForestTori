//
//  NotificationManager.swift
//  ForestTori
//
//  Created by Nayeon Kim on 7/6/24.
//

import SwiftUI
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var isNotificationSet = false
    
    static let instance = NotificationManager()
    private init() { }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            DispatchQueue.main.async {
                if let error {
                    print("Request Notificaiton Authorization ERROR: \(error)")
                } else if success {
                    self.isNotificationSet = true
                    print("permission granted")
                } else {
                    self.isNotificationSet = true
                    print("permission denied")
                }
            }
        }
    }
    
    func scheduleNotification(for plantName: String) {
        // 선택 식물이 바뀌면 과거에 설정된 알림 대기를 모두 지움
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let times: [(hour: Int, minute: Int)] = [(10, 0), (20, 0)]
        for time in times {
            let content = UNMutableNotificationContent()
            content.title = "숲토리"
            content.body = "\(plantName)이/가 토리를 기다리고 있어요:)\n오늘 미션을 수행해서 \(plantName)을/를 키워보아요!"
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error {
                    print("Request Scheduled Notification ERROR: \(error)")
                } else {
                    print("notification scheduled")
                }
            }
        }
    }
}
