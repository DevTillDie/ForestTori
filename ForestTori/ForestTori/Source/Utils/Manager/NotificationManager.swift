//
//  NotificationManager.swift
//  ForestTori
//
//  Created by Nayeon Kim on 7/6/24.
//

import SwiftUI
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    @Published var isNotificationSet = false
    
    static let instance = NotificationManager()
    
    private init() { }
    
    func requestAuthorization() async {
        let center = UNUserNotificationCenter.current()
        let granted = await withCheckedContinuation { continuation in
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
        print("Notification: permission \(granted ? "granted" : "denied")")
        self.isNotificationSet = true
    }
    
    func scheduleNotification(line: String) {
        // 선택 식물이 바뀌면 과거에 설정된 알림 대기를 모두 지움
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let times: [(hour: Int, minute: Int)] = [(10, 0), (20, 0)]
        
        for time in times {
            let content = UNMutableNotificationContent()
            content.title = "숲토리"
            
            content.body = line
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
    
    func removeNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
