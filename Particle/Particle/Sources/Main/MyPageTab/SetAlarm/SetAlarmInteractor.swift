//
//  SetAlarmInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift

protocol SetAlarmRouting: ViewableRouting {
    func attachDirectlySetAlarm()
    func detachDirectlySetAlarm()
}

protocol SetAlarmPresentable: Presentable {
    var listener: SetAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SetAlarmListener: AnyObject {
    func setAlarmBackButtonTapped()
}

final class SetAlarmInteractor: PresentableInteractor<SetAlarmPresentable>, SetAlarmInteractable, SetAlarmPresentableListener {
    
    weak var router: SetAlarmRouting?
    weak var listener: SetAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SetAlarmPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - SetAlarmPresentableListener
    
    func setAlarmBackButtonTapped() {
        handleLocalNotificationRegistration()
        listener?.setAlarmBackButtonTapped()
    }
    
    func setAlarmDirectlySettingButtonTapped() {
        router?.attachDirectlySetAlarm()
    }
    
    func directlySetAlarmCloseButtonTapped() {
        router?.detachDirectlySetAlarm()
    }
    
    func handleLocalNotificationRegistration() {

        let alarms = [
            ("출근할 때 한 번 더 보기", "20000101 08:00:00"),
            ("점심시간에 한 번 더 보기", "20000101 12:00:00"),
            ("퇴근할 때 한 번 더 보기", "20000101 19:00:00"),
            ("자기전에 한 번 더 보기", "20000101 22:00:00")
        ]
        
        var identifiersForRemove = [String]()
        
        alarms.forEach {
            if UserDefaults.standard.bool(forKey: $0.0) {
                addLocalNotification(identifier: $0.0, title: "title정하기", body: "body정하기", timeHHmm: $0.1)
            } else {
                identifiersForRemove.append($0.0)
            }
        }
        
        removeLocalNotifications(identifiers: identifiersForRemove)
        
        // TODO: 알람 설정이 잘 되었는지 테스트 필요.
        
        UNUserNotificationCenter.current().getDeliveredNotifications { lists in
            Console.log("설정된 알람 시간들: \(lists)")
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { lists in
            Console.log("보류된 요청들 : \(lists)")
        }
    }
    
    // MARK: - Methods
    
    private func addLocalNotification(identifier: String, title: String, body: String, timeHHmm: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let date = DateManager.shared.convertTimeToDate(previousHHmm: timeHHmm)
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.hour], from: date), // FIXME: 특정 시간으로 지정
            repeats: true)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                Console.error(error.localizedDescription)
            }
        }
    }
    
    private func removeLocalNotifications(identifiers: [String]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
}
