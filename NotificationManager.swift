import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // Handle the error if needed
            if granted {
                print("We have permission to send notifications")
            } else {
                print("Permission denied")
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion(granted)
        }
    }
    
    func scheduleNotifications(for drug: Drug) {
        let center = UNUserNotificationCenter.current()
        
        for dose in drug.doses {
            let content = UNMutableNotificationContent()
            content.title = "Time for your medication"
            content.body = "Don't forget to take your \(drug.title)"
            content.sound = UNNotificationSound.default
            
            // Use the dose time to set the trigger
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dose.time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
        }
    }
}

