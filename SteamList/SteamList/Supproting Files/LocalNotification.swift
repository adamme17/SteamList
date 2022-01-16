//
//  LocalNotification.swift
//  SteamList
//
//  Created by Adam Bokun on 16.01.22.
//

import Foundation
import UserNotifications

class LocalNotification {

    static let shared = LocalNotification()
    let notificationCenter = UNUserNotificationCenter.current()

    private init() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in

            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
    }

    func sendNotification(name: String, price: Int) {
        let content = UNMutableNotificationContent()
        content.title = name
        content.body = "The price has dropped to $\(price)!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
}
