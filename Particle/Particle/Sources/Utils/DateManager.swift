//
//  DateManager.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import Foundation

final class DateManager {
    static let shared = DateManager()
    private let dateFormatter: DateFormatter
    
    private init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.locale = Locale(identifier: "ko")
    }
    
    func convert(previousDate: String, to format: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let date = dateFormatter.date(from: previousDate) else { return "" }
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func convertTimeToDate(previousHHmm: String) -> Date {
        dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
        guard let date = dateFormatter.date(from: previousHHmm) else { return Date() }
        return date
    }
}
