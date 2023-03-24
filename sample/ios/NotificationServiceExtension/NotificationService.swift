//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Helder Pinhal on 24/03/2023.
//

import UserNotifications
import NotificareNotificationServiceExtensionKit

class NotificationService: UNNotificationServiceExtension {

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        NotificareNotificationServiceExtension.handleNotificationRequest(request) { result in
            switch result {
            case let .success(content):
                contentHandler(content)

            case let .failure(error):
                print("Failed to handle the notification request.\n\(error)")
                contentHandler(request.content)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    }

}
