//
//  DateExtension.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/13.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import Foundation

extension TimeZone {
    
    static let japan = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    
    static let japan = Locale(identifier: "ja_JP")
}

extension Date {
    
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .japan
        calendar.locale   = .japan
        return calendar
    }
    
    var weekName: String {
        let index = calendar.component(.weekday, from: self) - 1 // index値を 1〜7 から 0〜6 にしている
        return ["日", "月", "火", "水", "木", "金", "土"][index]
    }
    
}

extension Date {
    
    
    
    /// 基準日を取得
    ///
    /// - Returns: <#return value description#>
    func getBaseDate() -> Date?{
        let strTmpStartDate: String = DateFormatters.yymmddhhmmssFormatter.string(from:self)
        return strTmpStartDate.dateFromString("yyyyMMddHHmmss")
    }
    
    
    /// 日付の差分
    ///
    /// - Parameter targetDate: <#targetDate description#>
    /// - Returns: <#return value description#>
    func daysDiff(_ targetDate: Date) -> Int {
        
        return calendar.dateComponents([.day], from: self, to: targetDate).day ?? 0
    }
    
    
    /// 月の差分
    ///
    /// - Parameter targetDate: <#targetDate description#>
    /// - Returns: <#return value description#>
    func monthsDiff(_ targetDate: Date) -> Int {
        return calendar.dateComponents([.month], from: self, to: targetDate).month ?? 0
    }
    
    
    /// 月初
    ///
    /// - Returns: <#return value description#>
    func startOfMonth() -> Date {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!
    }
    
    
    /// 月末
    var endOfMonth: Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    /// 指定差分日付を取得
    ///
    /// - Parameters:
    ///   - doubleDiff: <#doubleDiff description#>
    /// - Returns: <#return value description#>
    func getDateFromDiff(_ doubleDiff: Double) -> Date{
        
        let tmpDate: Date = Date(timeInterval: 86400*doubleDiff, since: self)
        return tmpDate
    }
    
    /// <#Description#>
    ///
    /// - Parameter intDiff: <#intDiff description#>
    /// - Returns: <#return value description#>
    func getMonthFromDiff(_ intDiff: Int) -> Date?{
        let targetMonth = calendar.date(byAdding: .month, value: intDiff, to: self)
        return targetMonth
    }
}
